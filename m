Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B712112D61D
	for <lists+stable@lfdr.de>; Tue, 31 Dec 2019 05:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfLaEXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 23:23:06 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:44411 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726364AbfLaEXF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Dec 2019 23:23:05 -0500
X-UUID: 91fcdc94c236451f89af17b1a4c9c051-20191231
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=ZRPxTeleJ3Mzk+ieB3WYQPdLPRugIPC5zES30k7LlyI=;
        b=EcY3oldMEN/Wjz8fNDots3u82qdEKdB28IMyFnNja/FsK+w1Y78jN/PGlcnc9+ggnDcRxEf1plhe3LoC9Pp5yHvcv6I/NOwVRe2kt0hBkHiG1RbyAeRLlhSr/lELEvT5dRKfS+OdVB49rOmoVcaa5vnNeIh9NdUwHngAQEO5YqQ=;
X-UUID: 91fcdc94c236451f89af17b1a4c9c051-20191231
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 711494458; Tue, 31 Dec 2019 12:23:01 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 31 Dec 2019 12:22:12 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 31 Dec 2019 12:21:43 +0800
Message-ID: <1577766179.13164.24.camel@mtkswgap22>
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
Date:   Tue, 31 Dec 2019 12:22:59 +0800
In-Reply-To: <836772092daffd8283a97d633e59fc34@codeaurora.org>
References: <1577693546-7598-1-git-send-email-stanley.chu@mediatek.com>
         <1577693546-7598-2-git-send-email-stanley.chu@mediatek.com>
         <fd129b859c013852bd80f60a36425757@codeaurora.org>
         <1577754469.13164.5.camel@mtkswgap22>
         <836772092daffd8283a97d633e59fc34@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgQ2FuLA0KDQoNCj4gSGkgU3RhbmxleSwNCj4gDQo+IEkgc2VlIHNraXBwaW5nIHVmc2hjZF9z
ZXRfdWZzX2Rldl9hY3RpdmUoKSBpbiB1ZnNoY2RfcHJvYmVfaGJhKCkNCj4gaWYgaXQgaXMgY2Fs
bGVkIGZyb20gdWZzaGNkX3Jlc3VtZSgpIHBhdGggaXMgdGhlIHB1cnBvc2UgaGVyZS4NCj4gDQo+
IElmIHNvLCB0aGVuIHVmc2hjZF9zZXRfZGV2X3B3cl9tb2RlKCkgd291bGQgYmUgY2FsbGVkLCBt
ZWFuaW5nDQo+IFNTVSBjb21tYW5kIHdpbGwgYmUgc2VudC4gV2h5IGlzIHRoaXMgU1NVIGNvbW1h
bmQgbmVlZGVkIHRvIGJlDQo+IHNlbnQgYWZ0ZXIgYSBmdWxsIGhvc3QgcmVzZXQgYW5kIHJlc3Rv
cmU/IElzIHVmc2hjZF9wcm9iZV9oYmEoKQ0KPiBub3QgZW5vdWdoIHRvIG1ha2UgVUZTIGRldmlj
ZSBmdWxseSBmdW5jdGlvbmFsPw0KDQpBZnRlciByZXN1bWUgKGZvciBib3RoIHJ1bnRpbWUgcmVz
dW1lIGFuZCBzeXN0ZW0gcmVzdW1lKSwgZGV2aWNlIHBvd2VyDQptb2RlIHNoYWxsIGJlIGJhY2sg
dG8gIkFjdGl2ZSIgdG8gc2VydmljZSBpbmNvbWluZyByZXF1ZXN0cy4NCg0KSSBzZWUgdHdvIGNh
c2VzIG5lZWQgZGV2aWNlIHBvd2VyIG1vZGUgdHJhbnNpdGlvbiBkdXJpbmcgcmVzdW1lIGZsb3cN
CjEuIERldmljZSBQb3dlciBNb2RlID0gU2xlZXANCjIuIERldmljZSBQb3dlciBNb2RlID0gUG93
ZXJEb3duDQoNCkZvciAxLCB1ZnNoY2RfcHJvYmVfaGJhKCkgaXMgbm90IGludm9rZWQgZHVyaW5n
IHJlc3VtZSBmbG93LA0KaGJhLT5jdXJyX2Rldl9wd3JfbW9kZSA9IFNMRUVQLCB0aHVzIHVmc2hj
ZF9yZXN1bWUoKSBjYW4gaW52b2tlDQp1ZnNoY2Rfc2V0X2Rldl9wd3JfbW9kZSgpIHRvIGNoYW5n
ZSBkZXZpY2UgcG93ZXIgbW9kZS4NCg0KRm9yIDIsIHVmc2hjZF9wcm9iZV9oYmEoKSBpcyBpbnZv
a2VkIGR1cmluZyByZXN1bWUgZmxvdywgYmVmb3JlIHRoaXMNCmZpeCwgaGJhLT5jdXJyX2Rldl9w
d3JfbW9kZSB3aWxsIGJlIHNldCB0byBBQ1RJVkUgKG5vdGUgdGhhdCBvbmx5IHRoaXMNCmZsYWcg
aXMgc2V0IGFzIEFDVElWRSwgYnV0IGRldmljZSBtYXkgYmUgc3RpbGwgaW4gUG93ZXJEb3duIHN0
YXRlIGlmDQpkZXZpY2UgcG93ZXIgaXMgbm90IGZ1bGx5IHNodXRkb3duIG9yIGRldmljZSBIVyBy
ZXNldCBpcyBub3QgZXhlY3V0ZWQNCmJlZm9yZSByZXN1bWUpLCBpbiB0aGUgZW5kLCB1ZnNoY2Rf
cmVzdW1lKCkgd2lsbCBub3QgaW52b2tlDQp1ZnNoY2Rfc2V0X2Rldl9wd3JfbW9kZSgpIHRvIHNl
bmQgU1NVIGNvbW1hbmQgdG8gbWFrZSBkZXZpY2UgY2hhbmdlIGJhY2sNCnRvIEFjdGl2ZSBwb3dl
ciBtb2RlLg0KDQpCdXQgaWYgZGV2aWNlIGlzIGZ1bGx5IHJlc2V0IGJlZm9yZSByZXN1bWUgKG5v
dCBieSBjdXJyZW50IG1haW5zdHJlYW0NCmRyaXZlciksIGRldmljZSBjYW4gYmUgYWxyZWFkeSBp
biAiQWN0aXZlIiBwb3dlciBtb2RlIGFmdGVyIHBvd2VyIG9uDQphZ2FpbiBkdXJpbmcgcmVzdW1l
IGZsb3cuIEluIHRoaXMgY2FzZSwgaXQgaXMgT0sgdG8gc2V0DQpoYmEtPmN1cnJfZGV2X3B3cl9t
b2RlIGFzIEFDVElWRSBpbiB1ZnNoY2RfcHJvYmVfaGJhKCkgYW5kIFNTVSBjb21tYW5kDQppcyBu
b3QgbmVjZXNzYXJ5Lg0KDQpUaGFua3MsDQpTdGFubGV5DQoNCj4gX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18NCj4gTGludXgtbWVkaWF0ZWsgbWFpbGluZyBs
aXN0DQo+IExpbnV4LW1lZGlhdGVrQGxpc3RzLmluZnJhZGVhZC5vcmcNCj4gaHR0cDovL2xpc3Rz
LmluZnJhZGVhZC5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1tZWRpYXRlaw0KDQo=

