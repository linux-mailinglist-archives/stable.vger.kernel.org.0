Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A184D2437C8
	for <lists+stable@lfdr.de>; Thu, 13 Aug 2020 11:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgHMJjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Aug 2020 05:39:24 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:31901 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726334AbgHMJjX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Aug 2020 05:39:23 -0400
X-UUID: 9dba2db18d3e44018201919d7c7dca9b-20200813
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=v5RL6V9x3ufySZ6lQXXP3W0N4mG04Wkwj8+hcLlIG0M=;
        b=RBZ0X2JAZI9/IVgbYc5VIUVhawvVKhqL87sdiJ+17vk2gzf3QHPfEVm2IeGLmNl/bdMu0P2nO/n1qSM4agqhnaQtJb3Z6vd5CxW3LjAI7Ao1MN+Ea01toRYS8JpJTR2cThudQ7LAKRkgzj61SRHwUmgjgC/FOrWFDo12Wh0dG2c=;
X-UUID: 9dba2db18d3e44018201919d7c7dca9b-20200813
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <wenbin.mei@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 647228357; Thu, 13 Aug 2020 17:39:19 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 13 Aug 2020 17:39:16 +0800
Received: from localhost.localdomain (10.17.3.153) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 13 Aug 2020 17:39:09 +0800
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
Subject: [RESEND,v4,2/3] arm64: dts: mt7622: add reset node for mmc device
Date:   Thu, 13 Aug 2020 17:38:10 +0800
Message-ID: <20200813093811.28606-3-wenbin.mei@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200813093811.28606-1-wenbin.mei@mediatek.com>
References: <20200813093811.28606-1-wenbin.mei@mediatek.com>
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

