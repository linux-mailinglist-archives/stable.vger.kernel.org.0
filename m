Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8AC2B630A
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732175AbgKQNeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:34:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:44892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732173AbgKQNeY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:34:24 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89D8424654;
        Tue, 17 Nov 2020 13:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620064;
        bh=SUz/Ii3HKUd1fMwXTwSlazINS8l9j1vrF4i8RC5Jggs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YYdguJMwCYBXUaVSSPFzyrt+XpASQNod54/6tFe9hOmGgI513+EwUJ853RywxhNV1
         N7TkNAAZEQV+DoZ15lkVsOkzSPmOnuQT/Rb56llY/Zf6nT8ynxfxsbUxM+yHXAnrXQ
         NibeKPVPWHvvrpjMiAM9eYs0AcAnLPrR+vfUaRlE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pankaj Bansal <pankaj.bansal@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 056/255] can: flexcan: remove FLEXCAN_QUIRK_DISABLE_MECR quirk for LS1021A
Date:   Tue, 17 Nov 2020 14:03:16 +0100
Message-Id: <20201117122141.679947413@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>

[ Upstream commit 018799649071a1638c0c130526af36747df4355a ]

After double check with Layerscape CAN owner (Pankaj Bansal), confirm that
LS1021A doesn't support ECC feature, so remove FLEXCAN_QUIRK_DISABLE_MECR
quirk.

Fixes: 99b7668c04b27 ("can: flexcan: adding platform specific details for LS1021A")
Cc: Pankaj Bansal <pankaj.bansal@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Link: https://lore.kernel.org/r/20201020155402.30318-4-qiangqing.zhang@nxp.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/flexcan.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index bc21a82cf3a76..bc504e09f2259 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -321,8 +321,7 @@ static const struct flexcan_devtype_data fsl_vf610_devtype_data = {
 
 static const struct flexcan_devtype_data fsl_ls1021a_r2_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
-		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
-		FLEXCAN_QUIRK_USE_OFF_TIMESTAMP,
+		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_USE_OFF_TIMESTAMP,
 };
 
 static const struct can_bittiming_const flexcan_bittiming_const = {
-- 
2.27.0



