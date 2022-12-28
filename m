Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33B9C657CED
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbiL1Phd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:37:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233911AbiL1Phc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:37:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072EC164B9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:37:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2EFBB81647
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:37:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BAE1C433EF;
        Wed, 28 Dec 2022 15:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241849;
        bh=SxhX8RRTugluLrIwxcNtKr6LnnBhcPBA0pudhYJip5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M+tZzE4l/fXFl5eg72oQDqD1ZkLUvIOm7IW7q3kcnSITmzB2hLusZzRy5oVr/RBFp
         Z/5zYWlftwRcRwsus8sAHFNPAvgi1nNp7px6t+d1nuBW2sgj8szfgUsSYzjh8czr/h
         6xyvczaX1BTOoeECIJ5nnu4dIr52P09I4A8XmiR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0303/1073] drm: rcar-du: Drop leftovers dependencies from Kconfig
Date:   Wed, 28 Dec 2022 15:31:31 +0100
Message-Id: <20221228144336.241661335@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

[ Upstream commit 1760eb547276299ab0c6a6cd3d29469e54ade615 ]

Commit 841281fe52a7 ("drm: rcar-du: Drop LVDS device tree backward
compatibility") has removed device tree overlay sources used for
backward compatibility with old bindings, but forgot to remove related
dependencies from Kconfig. Fix it.

Fixes: 841281fe52a7 ("drm: rcar-du: Drop LVDS device tree backward compatibility")
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rcar-du/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/Kconfig b/drivers/gpu/drm/rcar-du/Kconfig
index f6e6a6d5d987..b3c29ca7726e 100644
--- a/drivers/gpu/drm/rcar-du/Kconfig
+++ b/drivers/gpu/drm/rcar-du/Kconfig
@@ -41,8 +41,6 @@ config DRM_RCAR_LVDS
 	depends on DRM_RCAR_USE_LVDS
 	select DRM_KMS_HELPER
 	select DRM_PANEL
-	select OF_FLATTREE
-	select OF_OVERLAY
 
 config DRM_RCAR_MIPI_DSI
 	tristate "R-Car DU MIPI DSI Encoder Support"
-- 
2.35.1



