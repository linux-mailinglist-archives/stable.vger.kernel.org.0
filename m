Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1D72B65EB
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 15:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbgKQN7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:59:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:50464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730623AbgKQNSB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:18:01 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 677DE206D5;
        Tue, 17 Nov 2020 13:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619080;
        bh=yqqX88Y5IQcAqP0bDmpDsPmoEFbLBsTzRMdGaaS4Ad8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZANRZFFppsbGCyq0PZ2e8VeaA0PKHxjvjDDgBXAcafVXF3OsqauYtfgegNLlVcwl8
         eVnUOuspYAemgY0dyPejQ4Itnfuo0i3cTkKYrteHHr0TFbhWUSZ50VfUX+5sRbDm0j
         MamyCfmGwEIuyRVhqkEmTMifS/PwKLWPulG22jH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pankaj Bansal <pankaj.bansal@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 022/101] can: flexcan: remove FLEXCAN_QUIRK_DISABLE_MECR quirk for LS1021A
Date:   Tue, 17 Nov 2020 14:04:49 +0100
Message-Id: <20201117122114.171253098@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122113.128215851@linuxfoundation.org>
References: <20201117122113.128215851@linuxfoundation.org>
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
index 0be8db6ab3195..92fe345e48ab7 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -301,8 +301,7 @@ static const struct flexcan_devtype_data fsl_vf610_devtype_data = {
 
 static const struct flexcan_devtype_data fsl_ls1021a_r2_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
-		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
-		FLEXCAN_QUIRK_USE_OFF_TIMESTAMP,
+		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_USE_OFF_TIMESTAMP,
 };
 
 static const struct can_bittiming_const flexcan_bittiming_const = {
-- 
2.27.0



