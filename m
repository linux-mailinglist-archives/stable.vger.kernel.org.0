Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B24CA2429F7
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 15:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgHLNCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 09:02:38 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:1258 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727834AbgHLNCg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Aug 2020 09:02:36 -0400
X-UUID: 1a18e545231d48dea80c2630aff1cb3e-20200812
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=dbv5n9ZrV/hPISdod9P90491MauUYffRqU2Ok68U9Ok=;
        b=X795UlL2rDDAnNhYxp0U2S1K4MQwtDBOHV90pNs379VlgeDxGLnugetWomkAzyfWVi/RcHZSZdLv7GU1kkQIhjH+JPGdB+ZjSR3LdOlQoipSCAlwvIu8J2imkdHoJej766PcsQgpfGhr9VCOw5RmgjAsNoYypv8ASmfLs08S9zo=;
X-UUID: 1a18e545231d48dea80c2630aff1cb3e-20200812
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw02.mediatek.com
        (envelope-from <wenbin.mei@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1241049186; Wed, 12 Aug 2020 21:02:34 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 12 Aug 2020 21:02:31 +0800
Received: from localhost.localdomain (10.17.3.153) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 Aug 2020 21:02:31 +0800
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
Subject: [v2,1/3] mmc: dt-bindings: Add resets/reset-names for Mediatek MMC bindings
Date:   Wed, 12 Aug 2020 21:01:27 +0800
Message-ID: <20200812130129.13519-2-wenbin.mei@mediatek.com>
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

QWRkIGRlc2NyaXB0aW9uIGZvciByZXNldHMvcmVzZXQtbmFtZXMuDQoNClNpZ25lZC1vZmYtYnk6
IFdlbmJpbiBNZWkgPHdlbmJpbi5tZWlAbWVkaWF0ZWsuY29tPg0KLS0tDQogRG9jdW1lbnRhdGlv
bi9kZXZpY2V0cmVlL2JpbmRpbmdzL21tYy9tdGstc2QudHh0IHwgMiArKw0KIDEgZmlsZSBjaGFu
Z2VkLCAyIGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vZGV2aWNl
dHJlZS9iaW5kaW5ncy9tbWMvbXRrLXNkLnR4dCBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9i
aW5kaW5ncy9tbWMvbXRrLXNkLnR4dA0KaW5kZXggOGE1MzJmNDQ1M2YyLi4xNWQ0MjU5NWEzZjMg
MTAwNjQ0DQotLS0gYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbW1jL210ay1z
ZC50eHQNCisrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9tbWMvbXRrLXNk
LnR4dA0KQEAgLTQ5LDYgKzQ5LDggQEAgT3B0aW9uYWwgcHJvcGVydGllczoNCiAJCSAgICAgZXJy
b3IgY2F1c2VkIGJ5IHN0b3AgY2xvY2soZmlmbyBmdWxsKQ0KIAkJICAgICBWYWxpZCByYW5nZSA9
IFswOjB4N10uIGlmIG5vdCBwcmVzZW50LCBkZWZhdWx0IHZhbHVlIGlzIDAuDQogCQkgICAgIGFw
cGxpZWQgdG8gY29tcGF0aWJsZSAibWVkaWF0ZWssbXQyNzAxLW1tYyIuDQorLSByZXNldHM6IFBo
YW5kbGUgYW5kIHJlc2V0IHNwZWNpZmllciBwYWlyIHRvIHNvZnRyZXNldCBsaW5lIG9mIE1TREMg
SVAuDQorLSByZXNldC1uYW1lczogc2hvdWxkIGJlICJocnN0Ii4NCiANCiBFeGFtcGxlczoNCiBt
bWMwOiBtbWNAMTEyMzAwMDAgew0KLS0gDQoyLjE4LjANCg==

