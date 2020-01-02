Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B72112E31F
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 07:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbgABGiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 01:38:52 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:56751 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725788AbgABGiw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 01:38:52 -0500
X-UUID: d0ef305adcd9465cb3f179a9a6b233e0-20200102
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=EY8CHJ1MOwpTVq0/F8e5ITYSow6Z2y2qYGrDALgu+g0=;
        b=pJXkWvF37dqw5HMuhYArqf40LDfY6vEeWuJv+6ij/MSLg4rCvjnOYACql3gZWmbFBPpxGhzMQ05Xs8LfANxbX8hIGahW42esE5XHwspiatuUM/0vyxW/2ox/jcKFz2WOPy4798wqBx/YPXUyq/gfzeljK/wB41Qx8+X+dD0ZYSM=;
X-UUID: d0ef305adcd9465cb3f179a9a6b233e0-20200102
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1107668345; Thu, 02 Jan 2020 14:38:46 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 2 Jan 2020 14:37:59 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 2 Jan 2020 14:38:03 +0800
Message-ID: <1577947124.13164.75.camel@mtkswgap22>
Subject: Re: [PATCH v1 1/2] scsi: ufs: set device as default active power
 mode during initialization only
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <andy.teng@mediatek.com>, <jejb@linux.ibm.com>,
        <chun-hung.wu@mediatek.com>, <kuohong.wang@mediatek.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <asutoshd@codeaurora.org>, <avri.altman@wdc.com>,
        <linux-mediatek@lists.infradead.org>, <peter.wang@mediatek.com>,
        <linux-scsi-owner@vger.kernel.org>, <subhashj@codeaurora.org>,
        <alim.akhtar@samsung.com>, <beanhuo@micron.com>,
        <pedrom.sousa@synopsys.com>, <bvanassche@acm.org>,
        <linux-arm-kernel@lists.infradead.org>, <matthias.bgg@gmail.com>,
        <ron.hsu@mediatek.com>, <cc.chou@mediatek.com>
Date:   Thu, 2 Jan 2020 14:38:44 +0800
In-Reply-To: <44393ed9ff3ba9878bae838307e7eec0@codeaurora.org>
References: <1577693546-7598-1-git-send-email-stanley.chu@mediatek.com>
         <1577693546-7598-2-git-send-email-stanley.chu@mediatek.com>
         <fd129b859c013852bd80f60a36425757@codeaurora.org>
         <1577754469.13164.5.camel@mtkswgap22>
         <836772092daffd8283a97d633e59fc34@codeaurora.org>
         <1577766179.13164.24.camel@mtkswgap22>
         <1577778290.13164.45.camel@mtkswgap22>
         <44393ed9ff3ba9878bae838307e7eec0@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 6DF2DA8F51F0E1171061F223F8110C3970D122A74F33AAB3D5F7588FEE5DB6412000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBUdWUsIDIwMTktMTItMzEgYXQgMTY6MzUgKzA4MDAsIENhbiBHdW8gd3Jv
dGU6DQoNCj4gSGkgU3RhbmxleSwNCj4gDQo+IEkgbWlzc2VkIHRoaXMgbWFpbCBiZWZvcmUgSSBo
aXQgc2VuZC4gSW4gY3VycmVudCBjb2RlLCBhcyBwZXIgbXkgDQo+IHVuZGVyc3RhbmRpbmcsDQo+
IFVGUyBkZXZpY2UncyBwb3dlciBzdGF0ZSBzaG91bGQgYmUgQWN0aXZlIGFmdGVyIHVmc2hjZF9s
aW5rX3N0YXJ0dXAoKSANCj4gcmV0dXJucy4NCj4gSWYgSSBhbSB3cm9uZywgcGxlYXNlIGZlZWwg
ZnJlZSB0byBjb3JyZWN0IG1lLg0KPiANCg0KWWVzLCB0aGlzIGFzc3VtcHRpb24gb2YgdWZzaGNk
X3Byb2JlX2hiYSgpIGlzIHRydWUgc28gSSB3aWxsIGRyb3AgdGhpcw0KcGF0Y2guDQpUaGFua3Mg
Zm9yIHJlbWluZC4NCg0KPiBEdWUgdG8geW91IGFyZSBhbG1vc3QgdHJ5aW5nIHRvIHJldmVydCBj
b21taXQgN2NhZjQ4OWI5OWE0MmEsIEkgYW0ganVzdCANCj4gd29uZGVyaW5nDQo+IGlmIHlvdSBl
bmNvdW50ZXIgZmFpbHVyZS9lcnJvciBjYXVzZWQgYnkgaXQuDQoNClllcywgd2UgYWN0dWFsbHkg
aGF2ZSBzb21lIGRvdWJ0cyBmcm9tIHRoZSBjb21taXQgbWVzc2FnZSBvZiAic2NzaTogdWZzOg0K
aXNzdWUgbGluayBzdGFydHVwIDIgdGltZXMgaWYgZGV2aWNlIGlzbid0IGFjdGl2ZSINCg0KSWYg
d2UgY29uZmlndXJlZCBzeXN0ZW0gc3VzcGVuZCBhcyBkZXZpY2U9UG93ZXJEb3duL0xpbms9TGlu
a0Rvd24gbW9kZSwNCmR1cmluZyByZXN1bWUsIHRoZSAxc3QgbGluayBzdGFydHVwIHdpbGwgYmUg
c3VjY2Vzc2Z1bCwgYW5kIGFmdGVyIHRoYXQNCmRldmljZSBjb3VsZCBiZSBhY2Nlc3NlZCBub3Jt
YWxseSBzbyBpdCBzaGFsbCBiZSBhbHJlYWR5IGluIEFjdGl2ZSBwb3dlcg0KbW9kZS4gV2UgZGlk
IG5vdCBmaW5kIGRldmljZXMgd2hpY2ggbmVlZCB0d2ljZSBsaW5rdXAgZm9yIG5vcm1hbCB3b3Jr
Lg0KDQpBbmQgYmVjYXVzZSB0aGUgMXN0IGxpbmt1cCBpcyBPSywgdGhlIGZvcmNlZCAybmQgbGlu
a3VwIGJ5IGNvbW1pdCAic2NzaToNCnVmczogaXNzdWUgbGluayBzdGFydHVwIDIgdGltZXMgaWYg
ZGV2aWNlIGlzbid0IGFjdGl2ZSIgbGVhZHMgdG8gbGluaw0KbG9zdCBhbmQgZmluYWxseSB0aGUg
M3JkIGxpbmt1cCBpcyBtYWRlIGFnYWluIGJ5IHJldHJ5IG1lY2hhbmlzbSBpbg0KdWZzaGNkX2xp
bmtfc3RhcnR1cCgpIGFuZCBiZSBzdWNjZXNzZnVsLiBTbyBhIGxpbmt1cCBwZXJmb3JtYW5jZSBp
c3N1ZQ0KaXMgaW50cm9kdWNlZCBoZXJlOiBXZSBhY3R1YWxseSBuZWVkIG9uZS10aW1lIGxpbmt1
cCBvbmx5IGJ1dCBmaW5hbGx5DQpnb3QgMyBsaW5rdXAgb3BlcmF0aW9ucy4NCg0KQWNjb3JkaW5n
IHRvIHRoZSBVRlMgc3BlYywgYWxsIHJlc2V0IHR5cGVzIChpbmNsdWRpbmcgUE9SIGFuZCBIb3N0
DQpVbmlQcm8gV2FybSBSZXNldCB3aGljaCBib3RoIG1heSBoYXBwZW4gaW4gYWJvdmUgY29uZmln
dXJhdGlvbnMpIG90aGVyDQp0aGFuIExVIHJlc2V0LCBVRlMgZGV2aWNlIHBvd2VyIG1vZGUgc2hh
bGwgcmV0dXJuIHRvIFNsZWVwIG1vZGUgb3INCkFjdGl2ZSBtb2RlIGRlcGVuZGluZyBvbiBiSW5p
dFBvd2VyTW9kZSwgYnkgZGVmYXVsdCwgaXQncyBBY3RpdmUgbW9kZS4NCg0KU28gd2UgYXJlIGN1
cmlvdXMgdGhhdCB3aHkgZW5mb3JjaW5nIHR3aWNlIGxpbmt1cCBpcyBuZWNlc3NhcnkgaGVyZT8N
CkNvdWxkIHlvdSBraW5kbHkgaGVscCB1cyBjbGFyaWZ5IHRoaXM/DQoNCklmIGFueXRoaW5nIHdy
b25nIGluIGFib3ZlIGRlc2NyaXB0aW9uLCBwbGVhc2UgZmVlbCBmcmVlIHRvIGNvcnJlY3QgbWUu
DQoNCj4gDQo+IEhhcHB5IG5ldyB5ZWFyIHRvIHlvdSB0b28hDQo+IA0KPiBUaGFua3MsDQo+IA0K
PiBDYW4gR3VvDQoNClRoYW5rcywNCg0KU3RhbmxleQ0KDQo+IA0KPiBfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXw0KPiBMaW51eC1tZWRpYXRlayBtYWlsaW5n
IGxpc3QNCj4gTGludXgtbWVkaWF0ZWtAbGlzdHMuaW5mcmFkZWFkLm9yZw0KPiBodHRwOi8vbGlz
dHMuaW5mcmFkZWFkLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW1lZGlhdGVrDQoNCg==

