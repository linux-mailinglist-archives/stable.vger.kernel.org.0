Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5820476BF8
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 09:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234750AbhLPIca (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 03:32:30 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:45478 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S234747AbhLPIca (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 03:32:30 -0500
X-UUID: e91765e00fb440f5801d3ce6ef4f0c2b-20211216
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=dmUwalDvL5wMFfVnZd9V2DFI7Cl0Jt//E7VNQ49dQ00=;
        b=ZmUxca8LvJaqOUf3RUohF2slPBDoKKe89O3ijLciy5//m2Wqljc0caU4mNGfGRNTG1nk0cZ/Pggxb3PbVfm7XNBTNyXj7DfDNn8iscUJiWqYvMp9MTuaOPzuHysL971CQxbtZFLKSjwgUjpNwzza1ImqqdsvRJMRYUYE5aJFjyw=;
X-UUID: e91765e00fb440f5801d3ce6ef4f0c2b-20211216
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1323285606; Thu, 16 Dec 2021 16:32:26 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Thu, 16 Dec 2021 16:32:25 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 16 Dec 2021 16:32:25 +0800
Message-ID: <aff31f9073b7c0a9a5500ded69ddaab27cd5e879.camel@mediatek.com>
Subject: Re: [PATCH 2/3] usb: mtu3: add memory barrier before set GPD's HWO
From:   Chunfeng Yun <chunfeng.yun@mediatek.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Matthias Brugger <matthias.bgg@gmail.com>,
        <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Eddie Hung <eddie.hung@mediatek.com>,
        "Yuwen Ng" <yuwen.ng@mediatek.com>, <stable@vger.kernel.org>
Date:   Thu, 16 Dec 2021 16:32:26 +0800
In-Reply-To: <YbdWI5PD3e6uFz8U@kroah.com>
References: <20211209031424.17842-1-chunfeng.yun@mediatek.com>
         <20211209031424.17842-2-chunfeng.yun@mediatek.com>
         <YbdWI5PD3e6uFz8U@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gTW9uLCAyMDIxLTEyLTEzIGF0IDE1OjE4ICswMTAwLCBHcmVnIEtyb2FoLUhhcnRtYW4gd3Jv
dGU6DQo+IE9uIFRodSwgRGVjIDA5LCAyMDIxIGF0IDExOjE0OjIzQU0gKzA4MDAsIENodW5mZW5n
IFl1biB3cm90ZToNCj4gPiBUaGVyZSBpcyBhIHNlbGRvbSBpc3N1ZSB0aGF0IHRoZSBjb250cm9s
bGVyIGFjY2VzcyBpbnZhbGlkIGFkZHJlc3MNCj4gPiBhbmQgdHJpZ2dlciBkZXZhcGMgb3IgZW1p
bXB1IHZpb2xhdGlvbi4gVGhhdCBpcyBkdWUgdG8gbWVtb3J5DQo+ID4gYWNjZXNzDQo+ID4gaXMg
b3V0IG9mIG9yZGVyIGFuZCBjYXVzZSBncGQgZGF0YSBpcyBub3QgY29ycmVjdC4NCj4gPiBNYWtl
IHN1cmUgR1BEIGlzIGZ1bGx5IHdyaXR0ZW4gYmVmb3JlIGdpdmluZyBpdCB0byBIVyBieSBzZXR0
aW5nDQo+ID4gaXRzDQo+ID4gSFdPLg0KPiA+IA0KPiA+IEZpeGVzOiA0OGUwZDM3MzVhYTUgKCJ1
c2I6IG10dTM6IHN1cHBvcnRzIG5ldyBRTVUgZm9ybWF0IikNCj4gPiBDYzogc3RhYmxlQHZnZXIu
a2VybmVsLm9yZw0KPiA+IFJlcG9ydGVkLWJ5OiBFZGRpZSBIdW5nIDxlZGRpZS5odW5nQG1lZGlh
dGVrLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBDaHVuZmVuZyBZdW4gPGNodW5mZW5nLnl1bkBt
ZWRpYXRlay5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvdXNiL210dTMvbXR1M19xbXUuYyB8
IDcgKysrKysrLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAxIGRlbGV0
aW9uKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL210dTMvbXR1M19xbXUu
Yw0KPiA+IGIvZHJpdmVycy91c2IvbXR1My9tdHUzX3FtdS5jDQo+ID4gaW5kZXggM2Y0MTRmOTFi
NTg5Li4zNGJiNWFjNjdlZmUgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy91c2IvbXR1My9tdHUz
X3FtdS5jDQo+ID4gKysrIGIvZHJpdmVycy91c2IvbXR1My9tdHUzX3FtdS5jDQo+ID4gQEAgLTI3
Myw2ICsyNzMsOCBAQCBzdGF0aWMgaW50IG10dTNfcHJlcGFyZV90eF9ncGQoc3RydWN0IG10dTNf
ZXANCj4gPiAqbWVwLCBzdHJ1Y3QgbXR1M19yZXF1ZXN0ICptcmVxKQ0KPiA+ICAJCQlncGQtPmR3
M19pbmZvIHw9IGNwdV90b19sZTMyKEdQRF9FWFRfRkxBR19aTFApOw0KPiA+ICAJfQ0KPiA+ICAN
Cj4gPiArCS8qIG1ha2Ugc3VyZSBHUEQgaXMgZnVsbHkgd3JpdHRlbiBiZWZvcmUgZ2l2aW5nIGl0
IHRvIEhXICovDQo+ID4gKwltYigpOw0KPiANCj4gU28gdGhpcyBtZWFucyB5b3UgYXJlIHVzaW5n
IG1taW8gZm9yIHRoaXMgc3RydWN0dXJlPyANCk5vLCBpdCdzIGEgbm9uY2FjaGVkIG1lbW9yeS4N
Cg0KPiAgSWYgc28sIHNob3VsZG4ndA0KPiB5b3UgYmUgdXNpbmcgbm9ybWFsIGlvIG1lbW9yeSBy
ZWFkL3dyaXRlIGNhbGxzIGFzIHdlbGwgYW5kIG5vdCBqdXN0DQo+ICJyYXciIHBvaW50ZXJzIGxp
a2UgdGhpczoNCj4gDQo+ID4gIAlncGQtPmR3MF9pbmZvIHw9IGNwdV90b19sZTMyKEdQRF9GTEFH
U19JT0MgfCBHUERfRkxBR1NfSFdPKTsNCj4gDQo+IEFyZSB5b3Ugc3VyZSB0aGlzIGlzIG9rPw0K
PiANCj4gU3ByaW5rbGluZyBhcm91bmQgbWIoKSBjYWxscyBpcyBhbG1vc3QgbmV2ZXIgdGhlIGNv
cnJlY3Qgc29sdXRpb24uDQo+IA0KPiBJZiB5b3UgbmVlZCB0byBlbnN1cmUgdGhhdCBhIHdyaXRl
IHN1Y2NlZWRzLCBzaG91bGRuJ3QgeW91IGRvIGEgcmVhZA0KPiBmcm9tIGl0IGFmdGVyd2FyZD8g
IE1hbnkgYnVzc2VzIHJlcXVpcmUgdGhpcywgZG9lc24ndCB5b3Vycz8NCkl0IHdvcmtzIGZvciBy
ZWdpc3RlciBhY2Nlc3MuDQpIZXJlIGlzIG5vbmNhY2hlIG1lbW9yeSBhY2Nlc3MsIGFkZCBtYigp
LCBqdXN0IHdhbnQgdG8gcHJvaGliaXRlIGJvdGgNCnRoZSBjb21waWxlciBhbmQgQ1BVIGZyb20g
cmVvcmRlcmluZyByZWFkL3dyaXRlcy4NCg0KPiANCj4gDQo+IA0KPiA+ICANCj4gPiAgCW1yZXEt
PmdwZCA9IGdwZDsNCj4gPiBAQCAtMzA2LDYgKzMwOCw4IEBAIHN0YXRpYyBpbnQgbXR1M19wcmVw
YXJlX3J4X2dwZChzdHJ1Y3QgbXR1M19lcA0KPiA+ICptZXAsIHN0cnVjdCBtdHUzX3JlcXVlc3Qg
Km1yZXEpDQo+ID4gIAlncGQtPm5leHRfZ3BkID0gY3B1X3RvX2xlMzIobG93ZXJfMzJfYml0cyhl
bnFfZG1hKSk7DQo+ID4gIAlleHRfYWRkciB8PSBHUERfRVhUX05HUChtdHUsIHVwcGVyXzMyX2Jp
dHMoZW5xX2RtYSkpOw0KPiA+ICAJZ3BkLT5kdzNfaW5mbyA9IGNwdV90b19sZTMyKGV4dF9hZGRy
KTsNCj4gPiArCS8qIG1ha2Ugc3VyZSBHUEQgaXMgZnVsbHkgd3JpdHRlbiBiZWZvcmUgZ2l2aW5n
IGl0IHRvIEhXICovDQo+ID4gKwltYigpOw0KPiANCj4gQWdhaW4sIG1iKCk7IGRvZXMgbm90IGVu
c3VyZSB0aGF0IG1lbW9yeS1tYXBwZWQgaS9vIGFjdHVhbGx5IGhpdHMgdGhlDQo+IEhXLiAgT3Ig
aWYgaXQgZG9lcyBvbiB5b3VyIHBsYXRmb3JtLCBob3c/DQpNYXliZSB0aGUgY29tbWVudCBpcyBt
aXNsZWFkaW5nLCBJJ2xsIGNoYW5nZSBpdCwgaGVyZSBqdXN0IHdhbnQgdG8NCnByZXZlbnQgcmVv
cmRlcmluZyBvZiBjb21waWxlciBhbmQgY3B1Lg0KPiANCj4gbWIoKSBpcyBhIGNvbXBpbGVyIGJh
cnJpZXIsIG5vdCBhIG1lbW9yeSB3cml0ZSB0byBhIGJ1cw0KPiBiYXJyaWVyLiAgUGxlYXNlDQo+
IHJlYWQgRG9jdW1lbnRhdGlvbi9tZW1vcnktYmFycmllcnMudHh0IGZvciBtb3JlIGRldGFpbHMu
DQpPaywgSSdsbCBkby4NCg0KVGhhbmtzIGEgbG90DQoNCj4gDQo+IHRoYW5rcywNCj4gDQo+IGdy
ZWcgay1oDQo=

