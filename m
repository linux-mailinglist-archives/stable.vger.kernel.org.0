Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A749243731
	for <lists+stable@lfdr.de>; Thu, 13 Aug 2020 11:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgHMJHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Aug 2020 05:07:30 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:12242 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726048AbgHMJHa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Aug 2020 05:07:30 -0400
X-UUID: 29103f08110e4229a3206b0d697f9d91-20200813
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=9httdLSXqot72Vjp5bmV2MlVnnvkCGEnLIRNKAXrnXo=;
        b=abcXzxmU9r8/9YyvInQGYa08sP7Kc+QsxcCc9XSZRug9MylwB5JoqvwLqfIso+odrDMoNs8FXg2vpBSUrqA/qGFEAKL7UkdFUqAobrslitVTB9x8H433Dk8evHYoPDrxp2NJzThSVEzxbgRpFBCEpapvUSdwZNNNCSqAiL6vxPc=;
X-UUID: 29103f08110e4229a3206b0d697f9d91-20200813
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw02.mediatek.com
        (envelope-from <wenbin.mei@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 886169983; Thu, 13 Aug 2020 17:07:22 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 13 Aug 2020 17:07:19 +0800
Received: from localhost.localdomain (10.17.3.153) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 13 Aug 2020 17:07:19 +0800
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
Subject: [v4,3/3] mmc: mediatek: add optional module reset property
Date:   Thu, 13 Aug 2020 17:06:18 +0800
Message-ID: <20200813090618.28009-4-wenbin.mei@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200813090618.28009-1-wenbin.mei@mediatek.com>
References: <20200813090618.28009-1-wenbin.mei@mediatek.com>
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
bWVkaWF0ZWsuY29tPg0KVGVzdGVkLWJ5OiBGcmFuayBXdW5kZXJsaWNoIDxmcmFuay13QHB1Ymxp
Yy1maWxlcy5kZT4NCi0tLQ0KIGRyaXZlcnMvbW1jL2hvc3QvbXRrLXNkLmMgfCAxMyArKysrKysr
KysrKysrDQogMSBmaWxlIGNoYW5nZWQsIDEzIGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbW1jL2hvc3QvbXRrLXNkLmMgYi9kcml2ZXJzL21tYy9ob3N0L210ay1zZC5jDQpp
bmRleCAzOWU3ZmM1NGM0MzguLmZjOTdkNWJmM2EyMCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbW1j
L2hvc3QvbXRrLXNkLmMNCisrKyBiL2RyaXZlcnMvbW1jL2hvc3QvbXRrLXNkLmMNCkBAIC0yMiw2
ICsyMiw3IEBADQogI2luY2x1ZGUgPGxpbnV4L3NsYWIuaD4NCiAjaW5jbHVkZSA8bGludXgvc3Bp
bmxvY2suaD4NCiAjaW5jbHVkZSA8bGludXgvaW50ZXJydXB0Lmg+DQorI2luY2x1ZGUgPGxpbnV4
L3Jlc2V0Lmg+DQogDQogI2luY2x1ZGUgPGxpbnV4L21tYy9jYXJkLmg+DQogI2luY2x1ZGUgPGxp
bnV4L21tYy9jb3JlLmg+DQpAQCAtNDM0LDYgKzQzNSw3IEBAIHN0cnVjdCBtc2RjX2hvc3Qgew0K
IAlzdHJ1Y3QgbXNkY19zYXZlX3BhcmEgc2F2ZV9wYXJhOyAvKiB1c2VkIHdoZW4gZ2F0ZSBIQ0xL
ICovDQogCXN0cnVjdCBtc2RjX3R1bmVfcGFyYSBkZWZfdHVuZV9wYXJhOyAvKiBkZWZhdWx0IHR1
bmUgc2V0dGluZyAqLw0KIAlzdHJ1Y3QgbXNkY190dW5lX3BhcmEgc2F2ZWRfdHVuZV9wYXJhOyAv
KiB0dW5lIHJlc3VsdCBvZiBDTUQyMS9DTUQxOSAqLw0KKwlzdHJ1Y3QgcmVzZXRfY29udHJvbCAq
cmVzZXQ7DQogfTsNCiANCiBzdGF0aWMgY29uc3Qgc3RydWN0IG10a19tbWNfY29tcGF0aWJsZSBt
dDgxMzVfY29tcGF0ID0gew0KQEAgLTE1MTYsNiArMTUxOCwxMiBAQCBzdGF0aWMgdm9pZCBtc2Rj
X2luaXRfaHcoc3RydWN0IG1zZGNfaG9zdCAqaG9zdCkNCiAJdTMyIHZhbDsNCiAJdTMyIHR1bmVf
cmVnID0gaG9zdC0+ZGV2X2NvbXAtPnBhZF90dW5lX3JlZzsNCiANCisJaWYgKGhvc3QtPnJlc2V0
KSB7DQorCQlyZXNldF9jb250cm9sX2Fzc2VydChob3N0LT5yZXNldCk7DQorCQl1c2xlZXBfcmFu
Z2UoMTAsIDUwKTsNCisJCXJlc2V0X2NvbnRyb2xfZGVhc3NlcnQoaG9zdC0+cmVzZXQpOw0KKwl9
DQorDQogCS8qIENvbmZpZ3VyZSB0byBNTUMvU0QgbW9kZSwgY2xvY2sgZnJlZSBydW5uaW5nICov
DQogCXNkcl9zZXRfYml0cyhob3N0LT5iYXNlICsgTVNEQ19DRkcsIE1TRENfQ0ZHX01PREUgfCBN
U0RDX0NGR19DS1BETik7DQogDQpAQCAtMjI3Myw2ICsyMjgxLDExIEBAIHN0YXRpYyBpbnQgbXNk
Y19kcnZfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCiAJaWYgKElTX0VSUiho
b3N0LT5zcmNfY2xrX2NnKSkNCiAJCWhvc3QtPnNyY19jbGtfY2cgPSBOVUxMOw0KIA0KKwlob3N0
LT5yZXNldCA9IGRldm1fcmVzZXRfY29udHJvbF9nZXRfb3B0aW9uYWxfZXhjbHVzaXZlKCZwZGV2
LT5kZXYsDQorCQkJCQkJCQkiaHJzdCIpOw0KKwlpZiAoSVNfRVJSKGhvc3QtPnJlc2V0KSkNCisJ
CXJldHVybiBQVFJfRVJSKGhvc3QtPnJlc2V0KTsNCisNCiAJaG9zdC0+aXJxID0gcGxhdGZvcm1f
Z2V0X2lycShwZGV2LCAwKTsNCiAJaWYgKGhvc3QtPmlycSA8IDApIHsNCiAJCXJldCA9IC1FSU5W
QUw7DQotLSANCjIuMTguMA0K

