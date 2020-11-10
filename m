Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55E62AD1DF
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 09:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbgKJIym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 03:54:42 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:60756 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726213AbgKJIym (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 03:54:42 -0500
X-UUID: a18501082d5a479dacaa74d1972b3a74-20201110
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=busI8tzaIjOQfi9V2ZmeWHinzielzkKRRHvJYt8BzSk=;
        b=KH2H+LIQukKINWY+XXSHqBPD93HBiZy5h4WIjX0APcCqh1576xUKNyIYc8c3gBV5H8IVRlcDUrur21gBgUsIoRZuv8R3Nx8BSPyZtpB7QzrrCmvm1vtJZLjfaSSLzt0GsHqncLwxzJmT6Ns7oen/gKA3S0mLt7T+3VNDVXKud3I=;
X-UUID: a18501082d5a479dacaa74d1972b3a74-20201110
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1981452464; Tue, 10 Nov 2020 16:54:37 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 10 Nov 2020 16:54:30 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 10 Nov 2020 16:54:30 +0800
Message-ID: <1604998469.2817.3.camel@mtkswgap22>
Subject: Re: [PATCH v2] ALSA: usb-audio: disable 96khz support for HUAWEI
 USB-C HEADSET
From:   Macpaul Lin <macpaul.lin@mediatek.com>
To:     Greg KH <greg@kroah.com>
CC:     Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Alexander Tsoy <alexander@tsoy.me>,
        Nicola Lunghi <nick83ola@gmail.com>,
        "Christopher Swenson" <swenson@swenson.io>,
        Nick Kossifidis <mickflemm@gmail.com>,
        <alsa-devel@alsa-project.org>, Ainge Hsu <ainge.hsu@mediatek.com>,
        Eddie Hung <eddie.hung@mediatek.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
        <stable@vger.kernel.org>
Date:   Tue, 10 Nov 2020 16:54:29 +0800
In-Reply-To: <X6pUaatZ7aML4sKq@kroah.com>
References: <1604995443-30453-1-git-send-email-macpaul.lin@mediatek.com>
         <1604997774-13593-1-git-send-email-macpaul.lin@mediatek.com>
         <X6pUaatZ7aML4sKq@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 6DB580D9FD98F3A3017B4D3065C7D004E39255AD44F7F8ECCD7CD23B23672D3B2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCAyMDIwLTExLTEwIGF0IDA5OjUwICswMTAwLCBHcmVnIEtIIHdyb3RlOg0KPiBPbiBU
dWUsIE5vdiAxMCwgMjAyMCBhdCAwNDo0Mjo1NFBNICswODAwLCBNYWNwYXVsIExpbiB3cm90ZToN
Cj4gPiBUaGUgSFVBV0VJIFVTQi1DIGhlYWRzZXQgKFZJRDoweDEyZDEsIFBJRDoweDNhMDcpIHJl
cG9ydGVkIGl0IHN1cHBvcnRzDQo+ID4gOTZraHouIEhvd2V2ZXIgdGhlcmUgd2lsbCBiZSBzb21l
IHJhbmRvbSBpc3N1ZSB1bmRlciA5Nmtoei4NCj4gPiBOb3Qgc3VyZSBpZiB0aGVyZSBpcyBhbnkg
YWx0ZXJuYXRlIHNldHRpbmcgY291bGQgYmUgYXBwbGllZC4NCj4gPiBIZW5jZSA0OGtoeiBpcyBz
dWdnZXN0ZWQgdG8gYmUgYXBwbGllZCBhdCB0aGlzIG1vbWVudC4NCj4gPiANCj4gPiBTaWduZWQt
b2ZmLWJ5OiBNYWNwYXVsIExpbiA8bWFjcGF1bC5saW5AbWVkaWF0ZWsuY29tPg0KPiA+IFNpZ25l
ZC1vZmYtYnk6IEVkZGllIEh1bmcgPGVkZGllLmh1bmdAbWVkaWF0ZWsuY29tPg0KPiA+IENjOiBz
dGFibGVAdmdlci5rZXJuZWwub3JnDQo+ID4gLS0tDQo+ID4gQ2hhbmdlcyBmb3IgdjI6DQo+ID4g
ICAtIEZpeCBidWlsZCBlcnJvci4NCj4gPiAgIC0gQWRkIENjOiBzdGFibGVAdmdlci5rZXJuZWwu
b3JnDQo+ID4gDQo+ID4gIHNvdW5kL3VzYi9mb3JtYXQuYyB8ICAgIDYgKysrKysrDQo+ID4gIDEg
ZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKykNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvc291
bmQvdXNiL2Zvcm1hdC5jIGIvc291bmQvdXNiL2Zvcm1hdC5jDQo+ID4gaW5kZXggMWIyOGQwMS4u
N2E0ODM3YiAxMDA2NDQNCj4gPiAtLS0gYS9zb3VuZC91c2IvZm9ybWF0LmMNCj4gPiArKysgYi9z
b3VuZC91c2IvZm9ybWF0LmMNCj4gPiBAQCAtMjAyLDYgKzIwMiw3IEBAIHN0YXRpYyBpbnQgcGFy
c2VfYXVkaW9fZm9ybWF0X3JhdGVzX3YxKHN0cnVjdCBzbmRfdXNiX2F1ZGlvICpjaGlwLCBzdHJ1
Y3QgYXVkaW9mDQo+ID4gIAkJZnAtPnJhdGVfbWluID0gZnAtPnJhdGVfbWF4ID0gMDsNCj4gPiAg
CQlmb3IgKHIgPSAwLCBpZHggPSBvZmZzZXQgKyAxOyByIDwgbnJfcmF0ZXM7IHIrKywgaWR4ICs9
IDMpIHsNCj4gPiAgCQkJdW5zaWduZWQgaW50IHJhdGUgPSBjb21iaW5lX3RyaXBsZSgmZm10W2lk
eF0pOw0KPiA+ICsJCQlzdHJ1Y3QgdXNiX2RldmljZSAqdWRldiA9IGNoaXAtPmRldjsNCj4gPiAg
CQkJaWYgKCFyYXRlKQ0KPiA+ICAJCQkJY29udGludWU7DQo+ID4gIAkJCS8qIEMtTWVkaWEgQ002
NTAxIG1pc2xhYmVscyBpdHMgOTYga0h6IGFsdHNldHRpbmcgKi8NCj4gDQo+IERpZCB5b3UgcnVu
IHRoaXMgcGF0Y2ggdGhyb3VnaCBjaGVja3BhdGNoLnBsPw0KPiANCg0KSSd2ZSByYW4gY2hlY2tw
YXRjaCBmb3IgdGhpcyBwYXRjaCB2MiwgYW5kIGl0IHNob3duDQoidG90YWw6IDAgZXJyb3JzLCAw
IHdhcm5pbmdzIi4gV2UncmUgdXNpbmcgNS45LXJjMSBpbnRlcm5hbC4NCg0KSG93ZXZlciwgSSds
bCBzZW5kIHBhdGNoIHYzIGFjY29yZGluZyB0byBUYWthc2hpJ3Mgc3VnZ2VzdGlvbi4NCg0KVGhh
bmtzDQpNYWNwYXVsIExpbg0K

