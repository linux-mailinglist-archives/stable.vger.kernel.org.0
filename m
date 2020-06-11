Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716B51F61F4
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 08:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgFKG5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 02:57:38 -0400
Received: from mo-csw1114.securemx.jp ([210.130.202.156]:59704 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgFKG5i (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 02:57:38 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1114) id 05B6vQmK018007; Thu, 11 Jun 2020 15:57:26 +0900
X-Iguazu-Qid: 2wHHsainR2OZpxXLJB
X-Iguazu-QSIG: v=2; s=0; t=1591858641; q=2wHHsainR2OZpxXLJB; m=tDg5H9AjW6/twqQtHarWqENxHpbeOhiTVeHNdtFRxVk=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1111) id 05B6vKCT006292;
        Thu, 11 Jun 2020 15:57:20 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 05B6vKdK029582;
        Thu, 11 Jun 2020 15:57:20 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 05B6vJSF015233;
        Thu, 11 Jun 2020 15:57:19 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, Zhao Qiang <qiang.zhao@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH for 4.4.y] net: phy: marvell: Limit 88m1101 autoneg errata to 88E1145 as well.
Date:   Thu, 11 Jun 2020 15:57:14 +0900
X-TSB-HOP: ON
Message-Id: <20200611065714.3619492-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhao Qiang <qiang.zhao@nxp.com>

commit c505873eaece2b4aefd07d339dc7e1400e0235ac upstream.

88E1145 also need this autoneg errata.

Fixes: f2899788353c ("net: phy: marvell: Limit errata to 88m1101")
Signed-off-by: Zhao Qiang <qiang.zhao@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/net/phy/marvell.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index ebec2dceff452..f62781ed6b584 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1091,7 +1091,7 @@ static struct phy_driver marvell_drivers[] = {
 		.features = PHY_GBIT_FEATURES,
 		.flags = PHY_HAS_INTERRUPT,
 		.config_init = &m88e1145_config_init,
-		.config_aneg = &marvell_config_aneg,
+		.config_aneg = &m88e1101_config_aneg,
 		.read_status = &genphy_read_status,
 		.ack_interrupt = &marvell_ack_interrupt,
 		.config_intr = &marvell_config_intr,
-- 
2.27.0

