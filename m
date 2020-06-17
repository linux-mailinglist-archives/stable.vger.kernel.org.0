Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C661FC9DC
	for <lists+stable@lfdr.de>; Wed, 17 Jun 2020 11:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgFQJcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 05:32:04 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:6303 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725554AbgFQJcE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jun 2020 05:32:04 -0400
X-UUID: c0668f6be54f4e37ab9d06e6f23eb73e-20200617
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=2Uc00OvqQOe/lmf1GLJboKZ6rmYpxT2fY8sxKg5cx9g=;
        b=ZlyqApBEl6yJTqJf8/+N/2hMBVo8HTj2M/pCHiHT4xFyMoKXLj9WOCjtkomaxnPAk2ztD0NlVVMV1IdKOLk8YA5796S7uhSl8u2XvkSgqjRNR8yJ2cJMuO788f12ENrjvo+fkkNXHZ/Lq+ziqIGe2/3Tt9YIKalJDn4g2EvOLsA=;
X-UUID: c0668f6be54f4e37ab9d06e6f23eb73e-20200617
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1683399060; Wed, 17 Jun 2020 17:31:59 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 17 Jun 2020 17:31:55 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by mtkcas07.mediatek.inc
 (172.21.101.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 17 Jun
 2020 17:31:56 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 17 Jun 2020 17:31:56 +0800
Message-ID: <1592386317.5395.2.camel@mtkswgap22>
Subject: Re: [PATCH 4/6] usb: musb: mediatek: add reset FADDR to zero in
 reset interrupt handle
From:   Macpaul Lin <macpaul.lin@mediatek.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Macpaul Lin <macpaul@gmail.com>, Bin Liu <b-liu@ti.com>,
        <linux-usb@vger.kernel.org>, <stable@vger.kernel.org>
Date:   Wed, 17 Jun 2020 17:31:57 +0800
In-Reply-To: <20200617085804.GA1736257@kroah.com>
References: <20200525025049.3400-1-b-liu@ti.com>
         <20200525025049.3400-5-b-liu@ti.com>
         <CACCg+XNfOaE7LE01NPeR6amvCTyrJaJ3sj3AF+Se49T0YFy_Uw@mail.gmail.com>
         <20200617085804.GA1736257@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
X-TM-SNTS-SMTP: A27705E4EDBE49C719E912324865AE26FA61B6C51002A43C6A76078686B110122000:8
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gV2VkLCAyMDIwLTA2LTE3IGF0IDEwOjU4ICswMjAwLCBHcmVnIEtyb2FoLUhhcnRtYW4gd3Jv
dGU6DQo+IE9uIFdlZCwgSnVuIDE3LCAyMDIwIGF0IDA0OjE3OjA3UE0gKzA4MDAsIE1hY3BhdWwg
TGluIHdyb3RlOg0KPiA+IEJpbiBMaXUgPGItbGl1QHRpLmNvbT4g5pa8IDIwMjDlubQ15pyIMjXm
l6Ug6YCx5LiAIOS4iuWNiDEwOjUz5a+r6YGT77yaDQo+ID4gPg0KPiA+ID4gRnJvbTogTWFjcGF1
bCBMaW4gPG1hY3BhdWwubGluQG1lZGlhdGVrLmNvbT4NCj4gPiA+DQo+ID4gPiBXaGVuIHJlY2Vp
dmluZyByZXNldCBpbnRlcnJ1cHQsIEZBRERSIG5lZWQgdG8gYmUgcmVzZXQgdG8gemVybyBpbg0K
PiA+ID4gcGVyaXBoZXJhbCBtb2RlLiBPdGhlcndpc2UgZXAwIGNhbm5vdCBkbyBlbnVtZXJhdGlv
biB3aGVuIHJlLXBsdWdnaW5nIFVTQg0KPiA+ID4gY2FibGUuDQo+ID4gPg0KPiA+ID4gU2lnbmVk
LW9mZi1ieTogTWFjcGF1bCBMaW4gPG1hY3BhdWwubGluQG1lZGlhdGVrLmNvbT4NCj4gPiA+IEFj
a2VkLWJ5OiBNaW4gR3VvIDxtaW4uZ3VvQG1lZGlhdGVrLmNvbT4NCj4gPiA+IFNpZ25lZC1vZmYt
Ynk6IEJpbiBMaXUgPGItbGl1QHRpLmNvbT4NCj4gPiA+IC0tLQ0KPiA+ID4gIGRyaXZlcnMvdXNi
L211c2IvbWVkaWF0ZWsuYyB8IDYgKysrKysrDQo+ID4gPiAgMSBmaWxlIGNoYW5nZWQsIDYgaW5z
ZXJ0aW9ucygrKQ0KPiA+ID4NCj4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9tdXNiL21l
ZGlhdGVrLmMgYi9kcml2ZXJzL3VzYi9tdXNiL21lZGlhdGVrLmMNCj4gPiA+IGluZGV4IDYxOTZi
MGU4ZDc3ZC4uZWViZWFkZDI2OTQ2IDEwMDY0NA0KPiA+ID4gLS0tIGEvZHJpdmVycy91c2IvbXVz
Yi9tZWRpYXRlay5jDQo+ID4gPiArKysgYi9kcml2ZXJzL3VzYi9tdXNiL21lZGlhdGVrLmMNCj4g
PiA+IEBAIC0yMDgsNiArMjA4LDEyIEBAIHN0YXRpYyBpcnFyZXR1cm5fdCBnZW5lcmljX2ludGVy
cnVwdChpbnQgaXJxLCB2b2lkICpfX2hjaSkNCj4gPiA+ICAgICAgICAgbXVzYi0+aW50X3J4ID0g
bXVzYl9jbGVhcncobXVzYi0+bXJlZ3MsIE1VU0JfSU5UUlJYKTsNCj4gPiA+ICAgICAgICAgbXVz
Yi0+aW50X3R4ID0gbXVzYl9jbGVhcncobXVzYi0+bXJlZ3MsIE1VU0JfSU5UUlRYKTsNCj4gPiA+
DQo+ID4gPiArICAgICAgIGlmICgobXVzYi0+aW50X3VzYiAmIE1VU0JfSU5UUl9SRVNFVCkgJiYg
IWlzX2hvc3RfYWN0aXZlKG11c2IpKSB7DQo+ID4gPiArICAgICAgICAgICAgICAgLyogZXAwIEZB
RERSIG11c3QgYmUgMCB3aGVuIChyZSllbnRlcmluZyBwZXJpcGhlcmFsIG1vZGUgKi8NCj4gPiA+
ICsgICAgICAgICAgICAgICBtdXNiX2VwX3NlbGVjdChtdXNiLT5tcmVncywgMCk7DQo+ID4gPiAr
ICAgICAgICAgICAgICAgbXVzYl93cml0ZWIobXVzYi0+bXJlZ3MsIE1VU0JfRkFERFIsIDApOw0K
PiA+ID4gKyAgICAgICB9DQo+ID4gPiArDQo+ID4gPiAgICAgICAgIGlmIChtdXNiLT5pbnRfdXNi
IHx8IG11c2ItPmludF90eCB8fCBtdXNiLT5pbnRfcngpDQo+ID4gPiAgICAgICAgICAgICAgICAg
cmV0dmFsID0gbXVzYl9pbnRlcnJ1cHQobXVzYik7DQo+ID4gPg0KPiA+ID4gLS0NCj4gPiA+IDIu
MTcuMQ0KPiA+ID4NCj4gPiBDb3VsZCB0aGlzIGJ1ZyBmaXggYWxzbyBiZWVuIGFwcGxpZWQgdG8g
c3RhYmxlIGtlcm5lbD8NCj4gDQo+IFN1cmUsIHdoYXQgaXMgdGhlIGdpdCBjb21taXQgb2YgaXQg
aW4gTGludXMncyB0cmVlPw0KPiANCj4gdGhhbmtzLA0KPiANCj4gZ3JlZyBrLWgNCg0KVGhlIGNv
bW1pdCBpZCBvZiB0aGlzIHBhdGNoIHNob3VsZCBiZQ0KNDAyYmNhYzRiMjViNTIwYzg5YmE2MGRi
ODVlYjYzMTZmMzZlNzk3Zg0KDQpUaGFuayB5b3UgdmVyeSBtdWNoLg0KDQpCUg0KTWFjcGF1bCBM
aW4NCg==

