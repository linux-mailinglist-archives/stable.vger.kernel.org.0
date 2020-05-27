Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A068A1E391E
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 08:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbgE0GZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 02:25:59 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:44740 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728007AbgE0GZ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 May 2020 02:25:59 -0400
X-UUID: cc806eb682f1441e965534c1150cb877-20200527
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=3JgPtKgRdy8ddR7xtaWXijDFOHGnyaGurBt3CDZDbJc=;
        b=qa3bSPrvl0ZaXE29kjfi/OCbwK/CBns3iU/bn193BTzTIC8m9KXM7e+ODSYjAyw4m/MhHBZ64uESU0j3wJdPRzr2SXv3k15qGdBMpe6favG1RWr12y3QHPawBEzy0oMy/v1gokoVwDoouJLug0hDk5423JdQnefmWRUEb6k0DFA=;
X-UUID: cc806eb682f1441e965534c1150cb877-20200527
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <weiyi.lu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1443509584; Wed, 27 May 2020 14:25:55 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 27 May 2020 14:25:52 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 27 May 2020 14:25:52 +0800
From:   Weiyi Lu <weiyi.lu@mediatek.com>
To:     Nicolas Boichat <drinkcat@chromium.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     James Liao <jamesjj.liao@mediatek.com>,
        Fan Chen <fan.chen@mediatek.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <linux-clk@vger.kernel.org>,
        <srv_heupstream@mediatek.com>, <stable@vger.kernel.org>,
        Weiyi Lu <weiyi.lu@mediatek.com>,
        Owen Chen <owen.chen@mediatek.com>
Subject: [PATCH v2] clk: mediatek: assign the initial value to clk_init_data of mtk_mux
Date:   Wed, 27 May 2020 14:25:49 +0800
Message-ID: <1590560749-29136-1-git-send-email-weiyi.lu@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: BFDC40E46F0324815F4D3721A56AD387881A75494A619CD8E2BD5B4CD48C0DC62000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

V2hlbiBzb21lIG5ldyBjbG9jayBzdXBwb3J0cyBhcmUgaW50cm9kdWNlZCwgZS5nLiBbMV0NCml0
IG1pZ2h0IGxlYWQgdG8gYW4gZXJyb3IgYWx0aG91Z2ggaXQgc2hvdWxkIGJlIE5VTEwgYmVjYXVz
ZQ0KY2xrX2luaXRfZGF0YSBpcyBvbiB0aGUgc3RhY2sgYW5kIGl0IG1pZ2h0IGhhdmUgcmFuZG9t
IHZhbHVlcw0KaWYgdXNpbmcgd2l0aG91dCBpbml0aWFsaXphdGlvbi4NCkFkZCB0aGUgbWlzc2lu
ZyBpbml0aWFsIHZhbHVlIHRvIGNsa19pbml0X2RhdGEuDQoNClsxXSBodHRwczovL2FuZHJvaWQt
cmV2aWV3Lmdvb2dsZXNvdXJjZS5jb20vYy9rZXJuZWwvY29tbW9uLysvMTI3ODA0Ng0KDQpGaXhl
czogYTNhZTU0OTkxN2YxICgiY2xrOiBtZWRpYXRlazogQWRkIG5ldyBjbGttdXggcmVnaXN0ZXIg
QVBJIikNCkNjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4NClNpZ25lZC1vZmYtYnk6IFdlaXlp
IEx1IDx3ZWl5aS5sdUBtZWRpYXRlay5jb20+DQpSZXZpZXdlZC1ieTogTWF0dGhpYXMgQnJ1Z2dl
ciA8bWF0dGhpYXMuYmdnQGdtYWlsLmNvbT4NCi0tLQ0KIGRyaXZlcnMvY2xrL21lZGlhdGVrL2Ns
ay1tdXguYyB8IDIgKy0NCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRp
b24oLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvY2xrL21lZGlhdGVrL2Nsay1tdXguYyBiL2Ry
aXZlcnMvY2xrL21lZGlhdGVrL2Nsay1tdXguYw0KaW5kZXggNzZmOWNkMC4uMTRlMTI3ZSAxMDA2
NDQNCi0tLSBhL2RyaXZlcnMvY2xrL21lZGlhdGVrL2Nsay1tdXguYw0KKysrIGIvZHJpdmVycy9j
bGsvbWVkaWF0ZWsvY2xrLW11eC5jDQpAQCAtMTYwLDcgKzE2MCw3IEBAIHN0cnVjdCBjbGsgKm10
a19jbGtfcmVnaXN0ZXJfbXV4KGNvbnN0IHN0cnVjdCBtdGtfbXV4ICptdXgsDQogCQkJCSBzcGlu
bG9ja190ICpsb2NrKQ0KIHsNCiAJc3RydWN0IG10a19jbGtfbXV4ICpjbGtfbXV4Ow0KLQlzdHJ1
Y3QgY2xrX2luaXRfZGF0YSBpbml0Ow0KKwlzdHJ1Y3QgY2xrX2luaXRfZGF0YSBpbml0ID0ge307
DQogCXN0cnVjdCBjbGsgKmNsazsNCiANCiAJY2xrX211eCA9IGt6YWxsb2Moc2l6ZW9mKCpjbGtf
bXV4KSwgR0ZQX0tFUk5FTCk7DQotLSANCjEuOC4xLjEuZGlydHkNCg==

