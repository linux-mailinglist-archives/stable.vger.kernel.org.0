Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE6C49A9E5
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323805AbiAYD3l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:29:41 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58586 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446041AbiAXVGO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:06:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AD5FB80CCF;
        Mon, 24 Jan 2022 21:06:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35949C340E5;
        Mon, 24 Jan 2022 21:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058370;
        bh=mMOviML6d2B2nz9G6cNtiKt2sKzaa74z8yvSpCvSpoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zF3hqJqleIZ6GWftlyCX+7QQI7xcy4AI6xy6AzT0QasZ+9cRCLsxNpwpowlf4G5gB
         bLNR9XXftDjap79J31GaKkk9ZxwFzB5N3wQO4ZcuM3BkH4VsRtFJkbcgW6mqtn2AYz
         AwvWEh2etZevkjk58fRIlyIPrRZiP38PuqUlF+bU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biju Das <biju.das.jz@bp.renesas.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0235/1039] drm: rcar-du: Add DSI support to rcar_du_output_name
Date:   Mon, 24 Jan 2022 19:33:44 +0100
Message-Id: <20220124184133.216456115@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

[ Upstream commit e0e4c64a64780a8672480618142776de8bf98d07 ]

The DSI output names were not added when the DSI pipeline support was
introduced.

Add the correct labels for these outputs, and fix the sort order to
match 'enum rcar_du_output' while we are here.

Fixes: b291fdcf5114 ("drm: rcar-du: Add r8a779a0 device support")
Suggested-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rcar-du/rcar_du_drv.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_drv.c b/drivers/gpu/drm/rcar-du/rcar_du_drv.c
index 5612a9e7a9056..5a8131ef81d5a 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_drv.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_drv.c
@@ -544,10 +544,12 @@ const char *rcar_du_output_name(enum rcar_du_output output)
 	static const char * const names[] = {
 		[RCAR_DU_OUTPUT_DPAD0] = "DPAD0",
 		[RCAR_DU_OUTPUT_DPAD1] = "DPAD1",
-		[RCAR_DU_OUTPUT_LVDS0] = "LVDS0",
-		[RCAR_DU_OUTPUT_LVDS1] = "LVDS1",
+		[RCAR_DU_OUTPUT_DSI0] = "DSI0",
+		[RCAR_DU_OUTPUT_DSI1] = "DSI1",
 		[RCAR_DU_OUTPUT_HDMI0] = "HDMI0",
 		[RCAR_DU_OUTPUT_HDMI1] = "HDMI1",
+		[RCAR_DU_OUTPUT_LVDS0] = "LVDS0",
+		[RCAR_DU_OUTPUT_LVDS1] = "LVDS1",
 		[RCAR_DU_OUTPUT_TCON] = "TCON",
 	};
 
-- 
2.34.1



