Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0448E2C9C53
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389926AbgLAJRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:17:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:50106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389915AbgLAJMG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:12:06 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2A1921D7A;
        Tue,  1 Dec 2020 09:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813886;
        bh=52+Yj70UplDHtM658ZmuaLUge146iEtW34CFRaXYOkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yvKN5mOPMrh0Fb/F8y3NTxWE0GXLIBOrNZDlAEqlES+L5nGLPH6VrTTmLTMGcGlsr
         iMRGSJwn339qaipzT/3FOTOZP4VPIxb2apNdd3LsQa879nFruktxyPO5/J3zz7NOYH
         R+T1vC2VnkuByDCb52CvxMjYBPA+bfezPN/nODNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 094/152] dpaa2-eth: select XGMAC_MDIO for MDIO bus support
Date:   Tue,  1 Dec 2020 09:53:29 +0100
Message-Id: <20201201084724.195899692@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit d2624e70a2f53b6f402fdaeabe7db798148618c5 ]

Explicitly enable the FSL_XGMAC_MDIO Kconfig option in order to have
MDIO access to internal and external PHYs.

Fixes: 719479230893 ("dpaa2-eth: add MAC/PHY support through phylink")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://lore.kernel.org/r/20201119145106.712761-1-ciorneiioana@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/Kconfig b/drivers/net/ethernet/freescale/dpaa2/Kconfig
index feea797cde022..70aabd2343371 100644
--- a/drivers/net/ethernet/freescale/dpaa2/Kconfig
+++ b/drivers/net/ethernet/freescale/dpaa2/Kconfig
@@ -3,6 +3,7 @@ config FSL_DPAA2_ETH
 	tristate "Freescale DPAA2 Ethernet"
 	depends on FSL_MC_BUS && FSL_MC_DPIO
 	select PHYLINK
+	select FSL_XGMAC_MDIO
 	help
 	  This is the DPAA2 Ethernet driver supporting Freescale SoCs
 	  with DPAA2 (DataPath Acceleration Architecture v2).
-- 
2.27.0



