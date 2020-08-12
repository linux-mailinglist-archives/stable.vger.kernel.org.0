Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11E62429F1
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 15:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgHLNCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 09:02:39 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:27081 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727943AbgHLNCj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Aug 2020 09:02:39 -0400
X-UUID: 3bf25b47e65d41b185baced8352ecaf0-20200812
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=J+qTrluFnbm8L24nMFqbLJeAwO3aSNUSuAOeF4ndDNg=;
        b=YgD/uDEtaEAbbgZpwP/dDx/dRb/B9Vjl1sCm/B+2TTU81E+7ce/qijMlEaCTff3oUD19fCYxrF6/oVcEYY8RNryWRckjpsZR/AjXcSUvDJEclL0RaGC0yR05dAtzp4Ny2q5BU+HaPY3myS2V0o0FkyKeE8k2hYVWC5ndxlGgSro=;
X-UUID: 3bf25b47e65d41b185baced8352ecaf0-20200812
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <wenbin.mei@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 2054378827; Wed, 12 Aug 2020 21:02:35 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 12 Aug 2020 21:02:32 +0800
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
Subject: [v2,2/3] arm64: dts: mt7622: add reset node for mmc device
Date:   Wed, 12 Aug 2020 21:01:28 +0800
Message-ID: <20200812130129.13519-3-wenbin.mei@mediatek.com>
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

VGhpcyBjb21taXQgYWRkcyByZXNldCBub2RlIGZvciBtbWMgZGV2aWNlLg0KDQpGaXhlczogOTY2
NTgwYWQyMzZlICgibW1jOiBtZWRpYXRlazogYWRkIHN1cHBvcnQgZm9yIE1UNzYyMiBTb0MiKQ0K
U2lnbmVkLW9mZi1ieTogV2VuYmluIE1laSA8d2VuYmluLm1laUBtZWRpYXRlay5jb20+DQpUZXN0
ZWQtYnk6IEZyYW5rIFd1bmRlcmxpY2ggPGZyYW5rLXdAcHVibGljLWZpbGVzLmRlPg0KLS0tDQog
YXJjaC9hcm02NC9ib290L2R0cy9tZWRpYXRlay9tdDc2MjIuZHRzaSB8IDIgKysNCiAxIGZpbGUg
Y2hhbmdlZCwgMiBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2Jvb3Qv
ZHRzL21lZGlhdGVrL210NzYyMi5kdHNpIGIvYXJjaC9hcm02NC9ib290L2R0cy9tZWRpYXRlay9t
dDc2MjIuZHRzaQ0KaW5kZXggMWEzOWUwZWY3NzZiLi41YjllYzAzMmNlOGQgMTAwNjQ0DQotLS0g
YS9hcmNoL2FybTY0L2Jvb3QvZHRzL21lZGlhdGVrL210NzYyMi5kdHNpDQorKysgYi9hcmNoL2Fy
bTY0L2Jvb3QvZHRzL21lZGlhdGVrL210NzYyMi5kdHNpDQpAQCAtNjg2LDYgKzY4Niw4IEBADQog
CQljbG9ja3MgPSA8JnBlcmljZmcgQ0xLX1BFUklfTVNEQzMwXzBfUEQ+LA0KIAkJCSA8JnRvcGNr
Z2VuIENMS19UT1BfTVNEQzUwXzBfU0VMPjsNCiAJCWNsb2NrLW5hbWVzID0gInNvdXJjZSIsICJo
Y2xrIjsNCisJCXJlc2V0cyA9IDwmcGVyaWNmZyBNVDc2MjJfUEVSSV9NU0RDMF9TV19SU1Q+Ow0K
KwkJcmVzZXQtbmFtZXMgPSAiaHJzdCI7DQogCQlzdGF0dXMgPSAiZGlzYWJsZWQiOw0KIAl9Ow0K
IA0KLS0gDQoyLjE4LjANCg==

