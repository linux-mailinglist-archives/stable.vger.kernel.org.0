Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75EA82442A6
	for <lists+stable@lfdr.de>; Fri, 14 Aug 2020 03:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgHNBJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Aug 2020 21:09:22 -0400
Received: from mailgw02.mediatek.com ([1.203.163.81]:10213 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726522AbgHNBJW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Aug 2020 21:09:22 -0400
X-UUID: b7ff8b513efa43338d5e458a09c2c369-20200814
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=8ID4EfASv2yCTJeN/ScYKkSMihUHk0DUrytaknzcfkI=;
        b=Izgi86lJ+ZO81e66RjyyEbEUV9rRPXcF8F969hhTL/FN683MDgWxX5Z29gk0MgkrYkXqq+OCGtGkQMuK/rjtw+VxOTWaDL0w9y0vDw1XM9BxqC/48nGU4z6wqQXUPrx6UYR4CznjNRWl2CQQsFrSNjdAR2BLcPtKSW3oi7bdxVk=;
X-UUID: b7ff8b513efa43338d5e458a09c2c369-20200814
Received: from mtkcas36.mediatek.inc [(172.27.4.253)] by mailgw02.mediatek.com
        (envelope-from <wenbin.mei@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLS)
        with ESMTP id 572709713; Fri, 14 Aug 2020 09:09:13 +0800
Received: from MTKCAS32.mediatek.inc (172.27.4.184) by MTKMBS31N1.mediatek.inc
 (172.27.4.69) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 14 Aug
 2020 09:09:09 +0800
Received: from [10.17.3.153] (10.17.3.153) by MTKCAS32.mediatek.inc
 (172.27.4.170) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 14 Aug 2020 09:09:11 +0800
Message-ID: <1597367294.5891.8.camel@mhfsdcap03>
Subject: Re: [RESEND,v4,3/3] mmc: mediatek: add optional module reset
 property
From:   Wenbin Mei <wenbin.mei@mediatek.com>
To:     Matthias Brugger <matthias.bgg@gmail.com>
CC:     Ulf Hansson <ulf.hansson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Chaotian Jing <chaotian.jing@mediatek.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        <linux-mmc@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <srv_heupstream@mediatek.com>,
        <stable@vger.kernel.org>
Date:   Fri, 14 Aug 2020 09:08:14 +0800
In-Reply-To: <7337a174-169d-2dd1-ed91-f05291d4f3a6@gmail.com>
References: <20200813093811.28606-1-wenbin.mei@mediatek.com>
         <20200813093811.28606-4-wenbin.mei@mediatek.com>
         <7337a174-169d-2dd1-ed91-f05291d4f3a6@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 137A8128AEAC25F6B12D0DC97D4527C08E2816AFB625FBD12667D6AAEB2A51AD2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

WWVzLCBJIHdpbGwgYWRkIFBoaWxpcHAgWmFiZWxzIFJldmlld2VkLWJ5IHRhZyBpbiB0aGUgbmV4
dCB2ZXJzaW9uLg0KT24gVGh1LCAyMDIwLTA4LTEzIGF0IDE1OjU3ICswMjAwLCBNYXR0aGlhcyBC
cnVnZ2VyIHdyb3RlOg0KPiANCj4gT24gMTMvMDgvMjAyMCAxMTozOCwgV2VuYmluIE1laSB3cm90
ZToNCj4gPiBUaGlzIHBhdGNoIGZpeHMgZU1NQy1BY2Nlc3Mgb24gbXQ3NjIyL0JwaS02NC4NCj4g
PiBCZWZvcmUgd2UgZ290IHRoZXNlIEVycm9ycyBvbiBtb3VudGluZyBlTU1DIGlvbiBSNjQ6DQo+
ID4gWyAgIDQ4LjY2NDkyNV0gYmxrX3VwZGF0ZV9yZXF1ZXN0OiBJL08gZXJyb3IsIGRldiBtbWNi
bGswLCBzZWN0b3IgMjA0ODAwIG9wIDB4MTooV1JJVEUpDQo+ID4gZmxhZ3MgMHg4MDAgcGh5c19z
ZWcgMSBwcmlvIGNsYXNzIDANCj4gPiBbICAgNDguNjc2MDE5XSBCdWZmZXIgSS9PIGVycm9yIG9u
IGRldiBtbWNibGswcDEsIGxvZ2ljYWwgYmxvY2sgMCwgbG9zdCBzeW5jIHBhZ2Ugd3JpdGUNCj4g
PiANCj4gPiBUaGlzIHBhdGNoIGFkZHMgYSBvcHRpb25hbCByZXNldCBtYW5hZ2VtZW50IGZvciBt
c2RjLg0KPiA+IFNvbWV0aW1lcyB0aGUgYm9vdGxvYWRlciBkb2VzIG5vdCBicmluZyBtc2RjIHJl
Z2lzdGVyDQo+ID4gdG8gZGVmYXVsdCBzdGF0ZSwgc28gbmVlZCByZXNldCB0aGUgbXNkYyBjb250
cm9sbGVyLg0KPiA+IA0KPiA+IENjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4gIyB2NS40Kw0K
PiA+IEZpeGVzOiA5NjY1ODBhZDIzNmUgKCJtbWM6IG1lZGlhdGVrOiBhZGQgc3VwcG9ydCBmb3Ig
TVQ3NjIyIFNvQyIpDQo+ID4gU2lnbmVkLW9mZi1ieTogV2VuYmluIE1laSA8d2VuYmluLm1laUBt
ZWRpYXRlay5jb20+DQo+ID4gVGVzdGVkLWJ5OiBGcmFuayBXdW5kZXJsaWNoIDxmcmFuay13QHB1
YmxpYy1maWxlcy5kZT4NCj4gDQo+IEkgdGhpbmsgeW91IG1pc3NlZCB0byBhZGQgUGhpbGlwcCBa
YWJlbHMgUmV2aWV3ZWQtYnkgdGFnLg0KPiANCj4gUmVnYXJkcywNCj4gTWF0dGhpYXMNCj4gDQo+
IA0KPiA+IC0tLQ0KPiA+ICAgZHJpdmVycy9tbWMvaG9zdC9tdGstc2QuYyB8IDEzICsrKysrKysr
KysrKysNCj4gPiAgIDEgZmlsZSBjaGFuZ2VkLCAxMyBpbnNlcnRpb25zKCspDQo+ID4gDQo+ID4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbW1jL2hvc3QvbXRrLXNkLmMgYi9kcml2ZXJzL21tYy9ob3N0
L210ay1zZC5jDQo+ID4gaW5kZXggMzllN2ZjNTRjNDM4Li5mYzk3ZDViZjNhMjAgMTAwNjQ0DQo+
ID4gLS0tIGEvZHJpdmVycy9tbWMvaG9zdC9tdGstc2QuYw0KPiA+ICsrKyBiL2RyaXZlcnMvbW1j
L2hvc3QvbXRrLXNkLmMNCj4gPiBAQCAtMjIsNiArMjIsNyBAQA0KPiA+ICAgI2luY2x1ZGUgPGxp
bnV4L3NsYWIuaD4NCj4gPiAgICNpbmNsdWRlIDxsaW51eC9zcGlubG9jay5oPg0KPiA+ICAgI2lu
Y2x1ZGUgPGxpbnV4L2ludGVycnVwdC5oPg0KPiA+ICsjaW5jbHVkZSA8bGludXgvcmVzZXQuaD4N
Cj4gPiAgIA0KPiA+ICAgI2luY2x1ZGUgPGxpbnV4L21tYy9jYXJkLmg+DQo+ID4gICAjaW5jbHVk
ZSA8bGludXgvbW1jL2NvcmUuaD4NCj4gPiBAQCAtNDM0LDYgKzQzNSw3IEBAIHN0cnVjdCBtc2Rj
X2hvc3Qgew0KPiA+ICAgCXN0cnVjdCBtc2RjX3NhdmVfcGFyYSBzYXZlX3BhcmE7IC8qIHVzZWQg
d2hlbiBnYXRlIEhDTEsgKi8NCj4gPiAgIAlzdHJ1Y3QgbXNkY190dW5lX3BhcmEgZGVmX3R1bmVf
cGFyYTsgLyogZGVmYXVsdCB0dW5lIHNldHRpbmcgKi8NCj4gPiAgIAlzdHJ1Y3QgbXNkY190dW5l
X3BhcmEgc2F2ZWRfdHVuZV9wYXJhOyAvKiB0dW5lIHJlc3VsdCBvZiBDTUQyMS9DTUQxOSAqLw0K
PiA+ICsJc3RydWN0IHJlc2V0X2NvbnRyb2wgKnJlc2V0Ow0KPiA+ICAgfTsNCj4gPiAgIA0KPiA+
ICAgc3RhdGljIGNvbnN0IHN0cnVjdCBtdGtfbW1jX2NvbXBhdGlibGUgbXQ4MTM1X2NvbXBhdCA9
IHsNCj4gPiBAQCAtMTUxNiw2ICsxNTE4LDEyIEBAIHN0YXRpYyB2b2lkIG1zZGNfaW5pdF9odyhz
dHJ1Y3QgbXNkY19ob3N0ICpob3N0KQ0KPiA+ICAgCXUzMiB2YWw7DQo+ID4gICAJdTMyIHR1bmVf
cmVnID0gaG9zdC0+ZGV2X2NvbXAtPnBhZF90dW5lX3JlZzsNCj4gPiAgIA0KPiA+ICsJaWYgKGhv
c3QtPnJlc2V0KSB7DQo+ID4gKwkJcmVzZXRfY29udHJvbF9hc3NlcnQoaG9zdC0+cmVzZXQpOw0K
PiA+ICsJCXVzbGVlcF9yYW5nZSgxMCwgNTApOw0KPiA+ICsJCXJlc2V0X2NvbnRyb2xfZGVhc3Nl
cnQoaG9zdC0+cmVzZXQpOw0KPiA+ICsJfQ0KPiA+ICsNCj4gPiAgIAkvKiBDb25maWd1cmUgdG8g
TU1DL1NEIG1vZGUsIGNsb2NrIGZyZWUgcnVubmluZyAqLw0KPiA+ICAgCXNkcl9zZXRfYml0cyho
b3N0LT5iYXNlICsgTVNEQ19DRkcsIE1TRENfQ0ZHX01PREUgfCBNU0RDX0NGR19DS1BETik7DQo+
ID4gICANCj4gPiBAQCAtMjI3Myw2ICsyMjgxLDExIEBAIHN0YXRpYyBpbnQgbXNkY19kcnZfcHJv
YmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gPiAgIAlpZiAoSVNfRVJSKGhvc3Qt
PnNyY19jbGtfY2cpKQ0KPiA+ICAgCQlob3N0LT5zcmNfY2xrX2NnID0gTlVMTDsNCj4gPiAgIA0K
PiA+ICsJaG9zdC0+cmVzZXQgPSBkZXZtX3Jlc2V0X2NvbnRyb2xfZ2V0X29wdGlvbmFsX2V4Y2x1
c2l2ZSgmcGRldi0+ZGV2LA0KPiA+ICsJCQkJCQkJCSJocnN0Iik7DQo+ID4gKwlpZiAoSVNfRVJS
KGhvc3QtPnJlc2V0KSkNCj4gPiArCQlyZXR1cm4gUFRSX0VSUihob3N0LT5yZXNldCk7DQo+ID4g
Kw0KPiA+ICAgCWhvc3QtPmlycSA9IHBsYXRmb3JtX2dldF9pcnEocGRldiwgMCk7DQo+ID4gICAJ
aWYgKGhvc3QtPmlycSA8IDApIHsNCj4gPiAgIAkJcmV0ID0gLUVJTlZBTDsNCj4gPiANCg0K

