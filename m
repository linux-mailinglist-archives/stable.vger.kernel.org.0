Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB352442D2
	for <lists+stable@lfdr.de>; Fri, 14 Aug 2020 03:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgHNBo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Aug 2020 21:44:56 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:60327 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726681AbgHNBoy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Aug 2020 21:44:54 -0400
X-UUID: 372feafcc8cf43b4a9cda9f9ab1202a5-20200814
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=VFjE0n0yP6rYccsrd1vDlg8jm85JSl2DOXPzRxPAWrs=;
        b=WBlGYSJPB3dX2DcMkh83kUpq6aw52KxoBRhG1jKfnr7DbTYhaA8GR9bbt/3oG1CRLWpep+AE0CSThoA9jv+x8+hCfkiP7ewhU5rUnPLIicdZ9joD5uN0pEarwzaxwGZuuk/UIDaVnKw2v72J44DtB0UcTOcoDLRh19038578zSo=;
X-UUID: 372feafcc8cf43b4a9cda9f9ab1202a5-20200814
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw02.mediatek.com
        (envelope-from <wenbin.mei@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 579499826; Fri, 14 Aug 2020 09:44:50 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 14 Aug 2020 09:44:48 +0800
Received: from localhost.localdomain (10.17.3.153) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 14 Aug 2020 09:44:47 +0800
From:   Wenbin Mei <wenbin.mei@mediatek.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
CC:     Chaotian Jing <chaotian.jing@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        <linux-mmc@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <srv_heupstream@mediatek.com>,
        Wenbin Mei <wenbin.mei@mediatek.com>, <stable@vger.kernel.org>
Subject: [v5,3/3] mmc: mediatek: add optional module reset property
Date:   Fri, 14 Aug 2020 09:43:46 +0800
Message-ID: <20200814014346.6496-4-wenbin.mei@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200814014346.6496-1-wenbin.mei@mediatek.com>
References: <20200814014346.6496-1-wenbin.mei@mediatek.com>
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
c2V0IHRoZSBtc2RjIGNvbnRyb2xsZXIuDQoNCkNjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4g
IyB2NS40Kw0KRml4ZXM6IDk2NjU4MGFkMjM2ZSAoIm1tYzogbWVkaWF0ZWs6IGFkZCBzdXBwb3J0
IGZvciBNVDc2MjIgU29DIikNClNpZ25lZC1vZmYtYnk6IFdlbmJpbiBNZWkgPHdlbmJpbi5tZWlA
bWVkaWF0ZWsuY29tPg0KUmV2aWV3ZWQtYnk6IFBoaWxpcHAgWmFiZWwgPHAuemFiZWxAcGVuZ3V0
cm9uaXguZGU+DQpUZXN0ZWQtYnk6IEZyYW5rIFd1bmRlcmxpY2ggPGZyYW5rLXdAcHVibGljLWZp
bGVzLmRlPg0KLS0tDQogZHJpdmVycy9tbWMvaG9zdC9tdGstc2QuYyB8IDEzICsrKysrKysrKysr
KysNCiAxIGZpbGUgY2hhbmdlZCwgMTMgaW5zZXJ0aW9ucygrKQ0KDQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9tbWMvaG9zdC9tdGstc2QuYyBiL2RyaXZlcnMvbW1jL2hvc3QvbXRrLXNkLmMNCmluZGV4
IDM5ZTdmYzU0YzQzOC4uZmM5N2Q1YmYzYTIwIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9tbWMvaG9z
dC9tdGstc2QuYw0KKysrIGIvZHJpdmVycy9tbWMvaG9zdC9tdGstc2QuYw0KQEAgLTIyLDYgKzIy
LDcgQEANCiAjaW5jbHVkZSA8bGludXgvc2xhYi5oPg0KICNpbmNsdWRlIDxsaW51eC9zcGlubG9j
ay5oPg0KICNpbmNsdWRlIDxsaW51eC9pbnRlcnJ1cHQuaD4NCisjaW5jbHVkZSA8bGludXgvcmVz
ZXQuaD4NCiANCiAjaW5jbHVkZSA8bGludXgvbW1jL2NhcmQuaD4NCiAjaW5jbHVkZSA8bGludXgv
bW1jL2NvcmUuaD4NCkBAIC00MzQsNiArNDM1LDcgQEAgc3RydWN0IG1zZGNfaG9zdCB7DQogCXN0
cnVjdCBtc2RjX3NhdmVfcGFyYSBzYXZlX3BhcmE7IC8qIHVzZWQgd2hlbiBnYXRlIEhDTEsgKi8N
CiAJc3RydWN0IG1zZGNfdHVuZV9wYXJhIGRlZl90dW5lX3BhcmE7IC8qIGRlZmF1bHQgdHVuZSBz
ZXR0aW5nICovDQogCXN0cnVjdCBtc2RjX3R1bmVfcGFyYSBzYXZlZF90dW5lX3BhcmE7IC8qIHR1
bmUgcmVzdWx0IG9mIENNRDIxL0NNRDE5ICovDQorCXN0cnVjdCByZXNldF9jb250cm9sICpyZXNl
dDsNCiB9Ow0KIA0KIHN0YXRpYyBjb25zdCBzdHJ1Y3QgbXRrX21tY19jb21wYXRpYmxlIG10ODEz
NV9jb21wYXQgPSB7DQpAQCAtMTUxNiw2ICsxNTE4LDEyIEBAIHN0YXRpYyB2b2lkIG1zZGNfaW5p
dF9odyhzdHJ1Y3QgbXNkY19ob3N0ICpob3N0KQ0KIAl1MzIgdmFsOw0KIAl1MzIgdHVuZV9yZWcg
PSBob3N0LT5kZXZfY29tcC0+cGFkX3R1bmVfcmVnOw0KIA0KKwlpZiAoaG9zdC0+cmVzZXQpIHsN
CisJCXJlc2V0X2NvbnRyb2xfYXNzZXJ0KGhvc3QtPnJlc2V0KTsNCisJCXVzbGVlcF9yYW5nZSgx
MCwgNTApOw0KKwkJcmVzZXRfY29udHJvbF9kZWFzc2VydChob3N0LT5yZXNldCk7DQorCX0NCisN
CiAJLyogQ29uZmlndXJlIHRvIE1NQy9TRCBtb2RlLCBjbG9jayBmcmVlIHJ1bm5pbmcgKi8NCiAJ
c2RyX3NldF9iaXRzKGhvc3QtPmJhc2UgKyBNU0RDX0NGRywgTVNEQ19DRkdfTU9ERSB8IE1TRENf
Q0ZHX0NLUEROKTsNCiANCkBAIC0yMjczLDYgKzIyODEsMTEgQEAgc3RhdGljIGludCBtc2RjX2Ry
dl9wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KIAlpZiAoSVNfRVJSKGhvc3Qt
PnNyY19jbGtfY2cpKQ0KIAkJaG9zdC0+c3JjX2Nsa19jZyA9IE5VTEw7DQogDQorCWhvc3QtPnJl
c2V0ID0gZGV2bV9yZXNldF9jb250cm9sX2dldF9vcHRpb25hbF9leGNsdXNpdmUoJnBkZXYtPmRl
diwNCisJCQkJCQkJCSJocnN0Iik7DQorCWlmIChJU19FUlIoaG9zdC0+cmVzZXQpKQ0KKwkJcmV0
dXJuIFBUUl9FUlIoaG9zdC0+cmVzZXQpOw0KKw0KIAlob3N0LT5pcnEgPSBwbGF0Zm9ybV9nZXRf
aXJxKHBkZXYsIDApOw0KIAlpZiAoaG9zdC0+aXJxIDwgMCkgew0KIAkJcmV0ID0gLUVJTlZBTDsN
Ci0tIA0KMi4xOC4wDQo=

