Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 085212442D6
	for <lists+stable@lfdr.de>; Fri, 14 Aug 2020 03:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgHNBow (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Aug 2020 21:44:52 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:43893 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726564AbgHNBov (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Aug 2020 21:44:51 -0400
X-UUID: f87b5a846e634f77a0de72d80417c25c-20200814
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=v5RL6V9x3ufySZ6lQXXP3W0N4mG04Wkwj8+hcLlIG0M=;
        b=B0vETmTKvsxBb1noaJDYlh3KsTjswjB7EtiTOAfgw2Xxx8YR8oXWdCTrfQn/VrquZm10/vkXB3rGY/6o1A26ip3jAl18USnaQWIO0ARVpCuLQwA3gEcYoLYdC8IXm9qfzv6NxjFELyiS7Ua4h7d8hOQeIe2eWRiRPIJV+5wO6Vk=;
X-UUID: f87b5a846e634f77a0de72d80417c25c-20200814
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <wenbin.mei@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1854550537; Fri, 14 Aug 2020 09:44:48 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 14 Aug 2020 09:44:47 +0800
Received: from localhost.localdomain (10.17.3.153) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 14 Aug 2020 09:44:46 +0800
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
Subject: [v5,2/3] arm64: dts: mt7622: add reset node for mmc device
Date:   Fri, 14 Aug 2020 09:43:45 +0800
Message-ID: <20200814014346.6496-3-wenbin.mei@mediatek.com>
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

VGhpcyBjb21taXQgYWRkcyByZXNldCBub2RlIGZvciBtbWMgZGV2aWNlLg0KDQpDYzogPHN0YWJs
ZUB2Z2VyLmtlcm5lbC5vcmc+ICMgdjUuNCsNCkZpeGVzOiA5NjY1ODBhZDIzNmUgKCJtbWM6IG1l
ZGlhdGVrOiBhZGQgc3VwcG9ydCBmb3IgTVQ3NjIyIFNvQyIpDQpTaWduZWQtb2ZmLWJ5OiBXZW5i
aW4gTWVpIDx3ZW5iaW4ubWVpQG1lZGlhdGVrLmNvbT4NClRlc3RlZC1ieTogRnJhbmsgV3VuZGVy
bGljaCA8ZnJhbmstd0BwdWJsaWMtZmlsZXMuZGU+DQotLS0NCiBhcmNoL2FybTY0L2Jvb3QvZHRz
L21lZGlhdGVrL210NzYyMi5kdHNpIHwgMiArKw0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlv
bnMoKykNCg0KZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQvYm9vdC9kdHMvbWVkaWF0ZWsvbXQ3NjIy
LmR0c2kgYi9hcmNoL2FybTY0L2Jvb3QvZHRzL21lZGlhdGVrL210NzYyMi5kdHNpDQppbmRleCAx
YTM5ZTBlZjc3NmIuLjViOWVjMDMyY2U4ZCAxMDA2NDQNCi0tLSBhL2FyY2gvYXJtNjQvYm9vdC9k
dHMvbWVkaWF0ZWsvbXQ3NjIyLmR0c2kNCisrKyBiL2FyY2gvYXJtNjQvYm9vdC9kdHMvbWVkaWF0
ZWsvbXQ3NjIyLmR0c2kNCkBAIC02ODYsNiArNjg2LDggQEANCiAJCWNsb2NrcyA9IDwmcGVyaWNm
ZyBDTEtfUEVSSV9NU0RDMzBfMF9QRD4sDQogCQkJIDwmdG9wY2tnZW4gQ0xLX1RPUF9NU0RDNTBf
MF9TRUw+Ow0KIAkJY2xvY2stbmFtZXMgPSAic291cmNlIiwgImhjbGsiOw0KKwkJcmVzZXRzID0g
PCZwZXJpY2ZnIE1UNzYyMl9QRVJJX01TREMwX1NXX1JTVD47DQorCQlyZXNldC1uYW1lcyA9ICJo
cnN0IjsNCiAJCXN0YXR1cyA9ICJkaXNhYmxlZCI7DQogCX07DQogDQotLSANCjIuMTguMA0K

