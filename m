Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96C532B75E5
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 06:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbgKRF0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 00:26:13 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:55535 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725446AbgKRF0M (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 00:26:12 -0500
X-UUID: dff173429cf944bf885c6e4eb8117996-20201118
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=feaWGkTA0pDN4xL1xb59wAcryyZv9HU/J1oPsDG2QIk=;
        b=Wz8NRaFhXXrYtiAhdjwOe8ysvLqJwGDbbo7+uUyk23LOv22VH9Y0qWseR1WOmF1tghWMAScC0eFlYuJhY+jwZLXWM8NVQ7g26jzl/VKZCy4qiIdZRa0ZP4ihsAfiH6buMj6OJXwxtJ8EunYd65MTu3DGs83Us3XQ7RwXJqs06FY=;
X-UUID: dff173429cf944bf885c6e4eb8117996-20201118
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1957854605; Wed, 18 Nov 2020 13:26:08 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 18 Nov 2020 13:26:07 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 18 Nov 2020 13:26:07 +0800
Message-ID: <1605677166.23663.4.camel@mtkswgap22>
Subject: Re: [PATCH v3] ALSA: usb-audio: disable 96khz support for HUAWEI
 USB-C HEADSET
From:   Macpaul Lin <macpaul.lin@mediatek.com>
To:     Takashi Iwai <tiwai@suse.com>
CC:     Jaroslav Kysela <perex@perex.cz>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Alexander Tsoy <alexander@tsoy.me>,
        "Nicola Lunghi" <nick83ola@gmail.com>,
        Christopher Swenson <swenson@swenson.io>,
        Nick Kossifidis <mickflemm@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Ainge Hsu =?UTF-8?Q?=28=E5=BE=90=E5=B7=A7=E5=AE=9C=29?= 
        <ainge.hsu@mediatek.com>,
        Eddie Hung =?UTF-8?Q?=28=E6=B4=AA=E6=AD=A3=E9=91=AB=29?= 
        <Eddie.Hung@mediatek.com>,
        Chunfeng Yun =?UTF-8?Q?=28=E4=BA=91=E6=98=A5=E5=B3=B0=29?= 
        <Chunfeng.Yun@mediatek.com>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date:   Wed, 18 Nov 2020 13:26:06 +0800
In-Reply-To: <1604999048-20294-1-git-send-email-macpaul.lin@mediatek.com>
References: <1604996266.2817.1.camel@mtkswgap22>
         <1604999048-20294-1-git-send-email-macpaul.lin@mediatek.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCAyMDIwLTExLTEwIGF0IDE3OjA0ICswODAwLCBNYWNwYXVsIExpbiB3cm90ZToNCj4g
VGhlIEhVQVdFSSBVU0ItQyBoZWFkc2V0IChWSUQ6MHgxMmQxLCBQSUQ6MHgzYTA3KSByZXBvcnRl
ZCBpdCBzdXBwb3J0cw0KPiA5Nmtoei4gSG93ZXZlciB0aGVyZSB3aWxsIGJlIHNvbWUgcmFuZG9t
IGlzc3VlIHVuZGVyIDk2a2h6Lg0KPiBOb3Qgc3VyZSBpZiB0aGVyZSBpcyBhbnkgYWx0ZXJuYXRl
IHNldHRpbmcgY291bGQgYmUgYXBwbGllZC4NCj4gSGVuY2UgNDhraHogaXMgc3VnZ2VzdGVkIHRv
IGJlIGFwcGxpZWQgYXQgdGhpcyBtb21lbnQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBNYWNwYXVs
IExpbiA8bWFjcGF1bC5saW5AbWVkaWF0ZWsuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBFZGRpZSBI
dW5nIDxlZGRpZS5odW5nQG1lZGlhdGVrLmNvbT4NCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5v
cmcNCj4gLS0tDQo+IENoYW5nZXMgZm9yIHYyOg0KPiAgIC0gRml4IGJ1aWxkIGVycm9yLg0KPiAg
IC0gQWRkIENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IENoYW5nZXMgZm9yIHYzOg0KPiAg
IC0gUmVwbGFjZSAidWRldiIgd2l0aCAiY2hpcC0+ZGV2IiBhY2NvcmRpbmcgdG8gVGFrYXNoaSdz
IHN1Z2dlc3Rpb24uIFRoYW5rcy4NCj4gDQo+ICBzb3VuZC91c2IvZm9ybWF0LmMgfCAgICA1ICsr
KysrDQo+ICAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0
IGEvc291bmQvdXNiL2Zvcm1hdC5jIGIvc291bmQvdXNiL2Zvcm1hdC5jDQo+IGluZGV4IDFiMjhk
MDEuLjBhZmY3NzQgMTAwNjQ0DQo+IC0tLSBhL3NvdW5kL3VzYi9mb3JtYXQuYw0KPiArKysgYi9z
b3VuZC91c2IvZm9ybWF0LmMNCj4gQEAgLTIxNyw2ICsyMTcsMTEgQEAgc3RhdGljIGludCBwYXJz
ZV9hdWRpb19mb3JtYXRfcmF0ZXNfdjEoc3RydWN0IHNuZF91c2JfYXVkaW8gKmNoaXAsIHN0cnVj
dCBhdWRpb2YNCj4gIAkJCSAgICAoY2hpcC0+dXNiX2lkID09IFVTQl9JRCgweDA0MWUsIDB4NDA2
NCkgfHwNCj4gIAkJCSAgICAgY2hpcC0+dXNiX2lkID09IFVTQl9JRCgweDA0MWUsIDB4NDA2OCkp
KQ0KPiAgCQkJCXJhdGUgPSA4MDAwOw0KPiArCQkJLyogSHVhd2VpIGhlYWRzZXQgY2FuJ3Qgc3Vw
cG9ydCA5NmtIeiBmdWxseSAqLw0KPiArCQkJaWYgKHJhdGUgPT0gOTYwMDAgJiYNCj4gKwkJCSAg
ICBjaGlwLT51c2JfaWQgPT0gVVNCX0lEKDB4MTJkMSwgMHgzYTA3KSAmJg0KPiArCQkJICAgIGxl
MTZfdG9fY3B1KGNoaXAtPmRldi0+ZGVzY3JpcHRvci5iY2REZXZpY2UpID09IDB4NDkpDQo+ICsJ
CQkJY29udGludWU7DQo+ICANCj4gIAkJCWZwLT5yYXRlX3RhYmxlW2ZwLT5ucl9yYXRlc10gPSBy
YXRlOw0KPiAgCQkJaWYgKCFmcC0+cmF0ZV9taW4gfHwgcmF0ZSA8IGZwLT5yYXRlX21pbikNCg0K
U29ycnkgZm9yIGJvdGhlcmluZyBhZ2FpbiwgcGxlYXNlIGhvbGQtb24gdGhpcyBwYXRjaC4NCkkn
bSBzdGlsbCB0cnlpbmcgdG8gY2xhcmlmeSBpZiB0aGVyZSBpcyBhbm90aGVyIGFwcHJvYWNoIGZv
ciB0aGlzDQppbnRlcm9wZXJhYmlsaXR5IGlzc3VlLg0KSSdsbCB1cGRhdGUgdGhpcyB0aHJlYWQg
b25jZSB0aGUgcmVzdWx0IGhhcyBjYW1lIG91dC4NCg0KVGhhbmtzDQpNYWNwYXVsIExpbg0K

