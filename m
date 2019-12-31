Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4F712D6DA
	for <lists+stable@lfdr.de>; Tue, 31 Dec 2019 08:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbfLaHpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Dec 2019 02:45:00 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:24148 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725497AbfLaHo7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Dec 2019 02:44:59 -0500
X-UUID: e003038cc2f4487da55edbab76bdff2b-20191231
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=G3qstG1VMSmVPYGxJvUnbDb79Y6VwOFhgHb1R1BPAB4=;
        b=sd2ARO9ZcLQg+xPUgoNfM0dwG0ZQfhw0lKWKHnqr+5d8syR7SPOPjSP77c/bveshPhmXBF9Ohsx4uf/I7Wu1Mou/hhpX7QwamGqDOjS3c/cUK7VlxkFABt4efIXd6NCfr+Ih4jG58MZ9EpgbVHbmRGNaBQBubzs6tibmesJZvQ8=;
X-UUID: e003038cc2f4487da55edbab76bdff2b-20191231
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1748911559; Tue, 31 Dec 2019 15:44:52 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 31 Dec 2019 15:44:06 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 31 Dec 2019 15:43:33 +0800
Message-ID: <1577778290.13164.45.camel@mtkswgap22>
Subject: Re: [PATCH v1 1/2] scsi: ufs: set device as default active power
 mode during initialization only
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     <linux-scsi-owner@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <subhashj@codeaurora.org>,
        <jejb@linux.ibm.com>, <chun-hung.wu@mediatek.com>,
        <kuohong.wang@mediatek.com>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, <avri.altman@wdc.com>,
        <linux-mediatek@lists.infradead.org>, <peter.wang@mediatek.com>,
        <alim.akhtar@samsung.com>, <andy.teng@mediatek.com>,
        <matthias.bgg@gmail.com>, <beanhuo@micron.com>,
        <pedrom.sousa@synopsys.com>, <bvanassche@acm.org>,
        <linux-arm-kernel@lists.infradead.org>, <asutoshd@codeaurora.org>
Date:   Tue, 31 Dec 2019 15:44:50 +0800
In-Reply-To: <1577766179.13164.24.camel@mtkswgap22>
References: <1577693546-7598-1-git-send-email-stanley.chu@mediatek.com>
         <1577693546-7598-2-git-send-email-stanley.chu@mediatek.com>
         <fd129b859c013852bd80f60a36425757@codeaurora.org>
         <1577754469.13164.5.camel@mtkswgap22>
         <836772092daffd8283a97d633e59fc34@codeaurora.org>
         <1577766179.13164.24.camel@mtkswgap22>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 45FB1168EF4BF48378D8C06BB302A9DF542A4E7C9858C67C2092FB067919067B2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBUdWUsIDIwMTktMTItMzEgYXQgMTI6MjIgKzA4MDAsIFN0YW5sZXkgQ2h1
IHdyb3RlOg0KPiBIaSBDYW4sDQo+IA0KPiANCj4gPiBIaSBTdGFubGV5LA0KPiA+IA0KPiA+IEkg
c2VlIHNraXBwaW5nIHVmc2hjZF9zZXRfdWZzX2Rldl9hY3RpdmUoKSBpbiB1ZnNoY2RfcHJvYmVf
aGJhKCkNCj4gPiBpZiBpdCBpcyBjYWxsZWQgZnJvbSB1ZnNoY2RfcmVzdW1lKCkgcGF0aCBpcyB0
aGUgcHVycG9zZSBoZXJlLg0KPiA+IA0KPiA+IElmIHNvLCB0aGVuIHVmc2hjZF9zZXRfZGV2X3B3
cl9tb2RlKCkgd291bGQgYmUgY2FsbGVkLCBtZWFuaW5nDQo+ID4gU1NVIGNvbW1hbmQgd2lsbCBi
ZSBzZW50LiBXaHkgaXMgdGhpcyBTU1UgY29tbWFuZCBuZWVkZWQgdG8gYmUNCj4gPiBzZW50IGFm
dGVyIGEgZnVsbCBob3N0IHJlc2V0IGFuZCByZXN0b3JlPyBJcyB1ZnNoY2RfcHJvYmVfaGJhKCkN
Cj4gPiBub3QgZW5vdWdoIHRvIG1ha2UgVUZTIGRldmljZSBmdWxseSBmdW5jdGlvbmFsPw0KPiAN
Cj4gQWZ0ZXIgcmVzdW1lIChmb3IgYm90aCBydW50aW1lIHJlc3VtZSBhbmQgc3lzdGVtIHJlc3Vt
ZSksIGRldmljZSBwb3dlcg0KPiBtb2RlIHNoYWxsIGJlIGJhY2sgdG8gIkFjdGl2ZSIgdG8gc2Vy
dmljZSBpbmNvbWluZyByZXF1ZXN0cy4NCj4gDQo+IEkgc2VlIHR3byBjYXNlcyBuZWVkIGRldmlj
ZSBwb3dlciBtb2RlIHRyYW5zaXRpb24gZHVyaW5nIHJlc3VtZSBmbG93DQo+IDEuIERldmljZSBQ
b3dlciBNb2RlID0gU2xlZXANCj4gMi4gRGV2aWNlIFBvd2VyIE1vZGUgPSBQb3dlckRvd24NCj4g
DQo+IEZvciAxLCB1ZnNoY2RfcHJvYmVfaGJhKCkgaXMgbm90IGludm9rZWQgZHVyaW5nIHJlc3Vt
ZSBmbG93LA0KPiBoYmEtPmN1cnJfZGV2X3B3cl9tb2RlID0gU0xFRVAsIHRodXMgdWZzaGNkX3Jl
c3VtZSgpIGNhbiBpbnZva2UNCj4gdWZzaGNkX3NldF9kZXZfcHdyX21vZGUoKSB0byBjaGFuZ2Ug
ZGV2aWNlIHBvd2VyIG1vZGUuDQo+IA0KPiBGb3IgMiwgdWZzaGNkX3Byb2JlX2hiYSgpIGlzIGlu
dm9rZWQgZHVyaW5nIHJlc3VtZSBmbG93LCBiZWZvcmUgdGhpcw0KPiBmaXgsIGhiYS0+Y3Vycl9k
ZXZfcHdyX21vZGUgd2lsbCBiZSBzZXQgdG8gQUNUSVZFIChub3RlIHRoYXQgb25seSB0aGlzDQo+
IGZsYWcgaXMgc2V0IGFzIEFDVElWRSwgYnV0IGRldmljZSBtYXkgYmUgc3RpbGwgaW4gUG93ZXJE
b3duIHN0YXRlIGlmDQo+IGRldmljZSBwb3dlciBpcyBub3QgZnVsbHkgc2h1dGRvd24gb3IgZGV2
aWNlIEhXIHJlc2V0IGlzIG5vdCBleGVjdXRlZA0KPiBiZWZvcmUgcmVzdW1lKSwgaW4gdGhlIGVu
ZCwgdWZzaGNkX3Jlc3VtZSgpIHdpbGwgbm90IGludm9rZQ0KPiB1ZnNoY2Rfc2V0X2Rldl9wd3Jf
bW9kZSgpIHRvIHNlbmQgU1NVIGNvbW1hbmQgdG8gbWFrZSBkZXZpY2UgY2hhbmdlIGJhY2sNCj4g
dG8gQWN0aXZlIHBvd2VyIG1vZGUuDQo+IA0KPiBCdXQgaWYgZGV2aWNlIGlzIGZ1bGx5IHJlc2V0
IGJlZm9yZSByZXN1bWUgKG5vdCBieSBjdXJyZW50IG1haW5zdHJlYW0NCj4gZHJpdmVyKSwgZGV2
aWNlIGNhbiBiZSBhbHJlYWR5IGluICJBY3RpdmUiIHBvd2VyIG1vZGUgYWZ0ZXIgcG93ZXIgb24N
Cj4gYWdhaW4gZHVyaW5nIHJlc3VtZSBmbG93LiBJbiB0aGlzIGNhc2UsIGl0IGlzIE9LIHRvIHNl
dA0KPiBoYmEtPmN1cnJfZGV2X3B3cl9tb2RlIGFzIEFDVElWRSBpbiB1ZnNoY2RfcHJvYmVfaGJh
KCkgYW5kIFNTVSBjb21tYW5kDQo+IGlzIG5vdCBuZWNlc3NhcnkuDQo+IA0KPiBUaGFua3MsDQo+
IFN0YW5sZXkNCg0KSSB0aGluayBjdXJyZW50bHkgdGhlIGFzc3VtcHRpb24gaW4gdWZzaGNkX3By
b2JlX2hiYSgpIHRoYXQgImRldmljZQ0Kc2hhbGwgYmUgYWxyZWFkeSBpbiBBY3RpdmUgcG93ZXIg
bW9kZSIgbWFrZXMgc2Vuc2UgYmVjYXVzZSBtYW55IGRldmljZQ0KY29tbWFuZHMgd2lsbCBiZSBz
ZW50IHRvIGRldmljZSBpbiB1ZnNoY2RfcHJvYmVfaGJhKCkgYnV0IGRldmljZSBpcyBub3QNCnBy
b21pc2VkIHRvIGhhbmRsZSB0aG9zZSBjb21tYW5kcyBpbiBQb3dlckRvd24gcG93ZXIgbW9kZSBh
Y2NvcmRpbmcgdG8NClVGUyBzcGVjLiANCg0KU28sIG1heWJlIGFsd2F5cyBlbnN1cmluZyBkZXZp
Y2UgYmVpbmcgQWN0aXZlIHBvd2VyIG1vZGUgYmVmb3JlIGxlYXZpbmcNCnVmc2hjZF9wcm9iZV9o
YmEoKSBpcyBtb3JlIHJlYXNvbmFibGUuIElmIHNvLCBJIHdpbGwgZHJvcCB0aGlzIHBhdGNoDQpm
aXJzdC4NCg0KVGhhbmtzIHNvIG11Y2ggZm9yIHlvdXIgcmV2aWV3cy4NCg0KSGFwcHkgbmV3IHll
YXIhDQoNClRoYW5rcywNClN0YW5sZXkNCg0KDQoNCg==

