Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB822429FC
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 15:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbgHLNCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 09:02:42 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:4486 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727993AbgHLNCk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Aug 2020 09:02:40 -0400
X-UUID: 8b45364098d8405b8e7204291d8662b9-20200812
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=CBjDMfS4ZVhji0R5jmv55ojWlHfMqOgeKR+VafpiBXg=;
        b=mGTIkWRs28RZe81Aqxvi441JCi8aarHLLaBEiNkAVjlC/5VK6nDZhKnuK9uXQ7I/Jcf5cixUhZ04J8uvCx/rRnYKONK6PM5Uw2Ry2Ks4h8Vnt7L8PTJk/kSq9Bx9aG9sldBqsfEF4dcgYaPTi2NzwttRHxSAtSdEm3a7VeqApqk=;
X-UUID: 8b45364098d8405b8e7204291d8662b9-20200812
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <wenbin.mei@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 303957295; Wed, 12 Aug 2020 21:02:36 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 12 Aug 2020 21:02:33 +0800
Received: from localhost.localdomain (10.17.3.153) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 Aug 2020 21:02:32 +0800
From:   Wenbin Mei <wenbin.mei@mediatek.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
CC:     Chaotian Jing <chaotian.jing@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        <linux-mmc@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <srv_heupstream@mediatek.com>, Wenbin Mei <wenbin.mei@mediatek.com>
Subject: [v2,3/3] mmc: mediatek: add optional module reset property
Date:   Wed, 12 Aug 2020 21:01:29 +0800
Message-ID: <20200812130129.13519-4-wenbin.mei@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200812130129.13519-1-wenbin.mei@mediatek.com>
References: <20200812130129.13519-1-wenbin.mei@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

VGhpcyBwYXRjaCBmaXhzIGVNTUMtQWNjZXNzIG9uIG10NzYyMi9CcGktNjQuDQpCZWZvcmUgd2Ug
Z290IHRoZXNlIEVycm9ycyBvbiBtb3VudGluZyBlTU1DIGlvbiBSNjQ6DQpbICAgNDguNjY0OTI1
XSBibGtfdXBkYXRlX3JlcXVlc3Q6IEkvTyBlcnJvciwgZGV2IG1tY2JsazAsIHNlY3RvciAyMDQ4
MDAgb3AgMHgxOihXUklURSkNCmZsYWdzIDB4ODAwIHBoeXNfc2VnIDEgcHJpbyBjbGFzcyAwDQpb
ICAgNDguNjc2MDE5XSBCdWZmZXIgSS9PIGVycm9yIG9uIGRldiBtbWNibGswcDEsIGxvZ2ljYWwg
YmxvY2sgMCwgbG9zdCBzeW5jIHBhZ2Ugd3JpdGUNCg0KVGhpcyBwYXRjaCBhZGRzIGEgb3B0aW9u
YWwgcmVzZXQgbWFuYWdlbWVudCBmb3IgbXNkYy4NClNvbWV0aW1lcyB0aGUgYm9vdGxvYWRlciBk
b2VzIG5vdCBicmluZyBtc2RjIHJlZ2lzdGVyDQp0byBkZWZhdWx0IHN0YXRlLCBzbyBuZWVkIHJl
c2V0IHRoZSBtc2RjIGNvbnRyb2xsZXIuDQoNCkZpeGVzOiA5NjY1ODBhZDIzNmUgKCJtbWM6IG1l
ZGlhdGVrOiBhZGQgc3VwcG9ydCBmb3IgTVQ3NjIyIFNvQyIpDQpTaWduZWQtb2ZmLWJ5OiBXZW5i
aW4gTWVpIDx3ZW5iaW4ubWVpQG1lZGlhdGVrLmNvbT4NClRlc3RlZC1ieTogRnJhbmsgV3VuZGVy
bGljaCA8ZnJhbmstd0BwdWJsaWMtZmlsZXMuZGU+DQotLS0NCiBkcml2ZXJzL21tYy9ob3N0L210
ay1zZC5jIHwgMTMgKysrKysrKysrKysrKw0KIDEgZmlsZSBjaGFuZ2VkLCAxMyBpbnNlcnRpb25z
KCspDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL21tYy9ob3N0L210ay1zZC5jIGIvZHJpdmVycy9t
bWMvaG9zdC9tdGstc2QuYw0KaW5kZXggMzllN2ZjNTRjNDM4Li4yYjI0M2MwM2M5YjIgMTAwNjQ0
DQotLS0gYS9kcml2ZXJzL21tYy9ob3N0L210ay1zZC5jDQorKysgYi9kcml2ZXJzL21tYy9ob3N0
L210ay1zZC5jDQpAQCAtMjIsNiArMjIsNyBAQA0KICNpbmNsdWRlIDxsaW51eC9zbGFiLmg+DQog
I2luY2x1ZGUgPGxpbnV4L3NwaW5sb2NrLmg+DQogI2luY2x1ZGUgPGxpbnV4L2ludGVycnVwdC5o
Pg0KKyNpbmNsdWRlIDxsaW51eC9yZXNldC5oPg0KIA0KICNpbmNsdWRlIDxsaW51eC9tbWMvY2Fy
ZC5oPg0KICNpbmNsdWRlIDxsaW51eC9tbWMvY29yZS5oPg0KQEAgLTQzNCw2ICs0MzUsNyBAQCBz
dHJ1Y3QgbXNkY19ob3N0IHsNCiAJc3RydWN0IG1zZGNfc2F2ZV9wYXJhIHNhdmVfcGFyYTsgLyog
dXNlZCB3aGVuIGdhdGUgSENMSyAqLw0KIAlzdHJ1Y3QgbXNkY190dW5lX3BhcmEgZGVmX3R1bmVf
cGFyYTsgLyogZGVmYXVsdCB0dW5lIHNldHRpbmcgKi8NCiAJc3RydWN0IG1zZGNfdHVuZV9wYXJh
IHNhdmVkX3R1bmVfcGFyYTsgLyogdHVuZSByZXN1bHQgb2YgQ01EMjEvQ01EMTkgKi8NCisJc3Ry
dWN0IHJlc2V0X2NvbnRyb2wgKnJlc2V0Ow0KIH07DQogDQogc3RhdGljIGNvbnN0IHN0cnVjdCBt
dGtfbW1jX2NvbXBhdGlibGUgbXQ4MTM1X2NvbXBhdCA9IHsNCkBAIC0xNTE2LDYgKzE1MTgsMTIg
QEAgc3RhdGljIHZvaWQgbXNkY19pbml0X2h3KHN0cnVjdCBtc2RjX2hvc3QgKmhvc3QpDQogCXUz
MiB2YWw7DQogCXUzMiB0dW5lX3JlZyA9IGhvc3QtPmRldl9jb21wLT5wYWRfdHVuZV9yZWc7DQog
DQorCWlmICghSVNfRVJSKGhvc3QtPnJlc2V0KSkgew0KKwkJcmVzZXRfY29udHJvbF9hc3NlcnQo
aG9zdC0+cmVzZXQpOw0KKwkJdXNsZWVwX3JhbmdlKDEwLCA1MCk7DQorCQlyZXNldF9jb250cm9s
X2RlYXNzZXJ0KGhvc3QtPnJlc2V0KTsNCisJfQ0KKw0KIAkvKiBDb25maWd1cmUgdG8gTU1DL1NE
IG1vZGUsIGNsb2NrIGZyZWUgcnVubmluZyAqLw0KIAlzZHJfc2V0X2JpdHMoaG9zdC0+YmFzZSAr
IE1TRENfQ0ZHLCBNU0RDX0NGR19NT0RFIHwgTVNEQ19DRkdfQ0tQRE4pOw0KIA0KQEAgLTIyNzMs
NiArMjI4MSwxMSBAQCBzdGF0aWMgaW50IG1zZGNfZHJ2X3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9k
ZXZpY2UgKnBkZXYpDQogCWlmIChJU19FUlIoaG9zdC0+c3JjX2Nsa19jZykpDQogCQlob3N0LT5z
cmNfY2xrX2NnID0gTlVMTDsNCiANCisJaG9zdC0+cmVzZXQgPSBkZXZtX3Jlc2V0X2NvbnRyb2xf
Z2V0X29wdGlvbmFsX2V4Y2x1c2l2ZSgmcGRldi0+ZGV2LA0KKwkJCQkJCQkJImhyc3QiKTsNCisJ
aWYgKFBUUl9FUlIoaG9zdC0+cmVzZXQpID09IC1FUFJPQkVfREVGRVIpDQorCQlyZXR1cm4gUFRS
X0VSUihob3N0LT5yZXNldCk7DQorDQogCWhvc3QtPmlycSA9IHBsYXRmb3JtX2dldF9pcnEocGRl
diwgMCk7DQogCWlmIChob3N0LT5pcnEgPCAwKSB7DQogCQlyZXQgPSAtRUlOVkFMOw0KLS0gDQoy
LjE4LjANCg==

