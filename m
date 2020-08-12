Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686282429F0
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 15:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbgHLNCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 09:02:39 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:18681 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727906AbgHLNCi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Aug 2020 09:02:38 -0400
X-UUID: 406736eff46c4b1880a72bdaefd7245d-20200812
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=xVTG3i3NZ+1cOXWR7yCUvveG4pS/BEjPy1kRWzM1V+Y=;
        b=kddPrpoqCaWMbFRZer5U93e4t9/aHgAQSTy/LAmfyf0PlDi25nkl4fbGEHMuSRb6ilHQvhkj3cv/Rn4bdxGykFZRjTj2WDgsBsOkpC6a2Xq/rzQNW1H2oqzrGZXQiSigESzrKepQM5+ld4UHPCWL7AoZzKsyb2VLdn349I5DOx0=;
X-UUID: 406736eff46c4b1880a72bdaefd7245d-20200812
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <wenbin.mei@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1908127229; Wed, 12 Aug 2020 21:02:33 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 12 Aug 2020 21:02:30 +0800
Received: from localhost.localdomain (10.17.3.153) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 Aug 2020 21:02:30 +0800
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
        <srv_heupstream@mediatek.com>
Subject: [v2,0/3] add optional reset property arm64: dts: mt7622: add reset node for mmc device  mmc: mediatek: add optional module reset property Documentation/devicetree/bindings/mmc/mtk-sd.txt |  2 ++ arch/arm64/boot/dts/mediatek/mt7622.dtsi         |  2 ++ drivers/mmc/host/mtk-sd.c                        | 13 +++++++++++++ 3 files changed, 17 insertions(+)
Date:   Wed, 12 Aug 2020 21:01:26 +0800
Message-ID: <20200812130129.13519-1-wenbin.mei@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

LS0NCjIuMTguMA0K

