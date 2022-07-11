Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4012956FDC1
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 12:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbiGKJ76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234277AbiGKJ7L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:59:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15FD624A7;
        Mon, 11 Jul 2022 02:27:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69D4B613F8;
        Mon, 11 Jul 2022 09:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD29C34115;
        Mon, 11 Jul 2022 09:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531653;
        bh=wpauSRjKkxczRqOFAKR0G9QBSNrt+x6DlEL/bNnxU/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h/rL3QdQpqogNpHlkVkeJr9A22NpOL9+wytUBTQGbFNWi+j3x96wcYLQWrLGp8AeP
         bgTeRwbFxUxX63XmE2CQL67Vy13NY6e0HRAe7pevomPemKwtP5bpHY5NOVY2f5snUx
         qfYs4GvXIkYs6FetiSLFZNuw4Fpb2auRtBZ2BxHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@denx.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 184/230] ARM: mxs_defconfig: Enable the framebuffer
Date:   Mon, 11 Jul 2022 11:07:20 +0200
Message-Id: <20220711090609.329087746@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit b10ef5f2ddb3a5a22ac0936c8d91a50ac5e55e77 ]

Currently, when booting Linux on a imx28-evk board there is
no display activity.

Enable CONFIG_FB which is nowadays required for CONFIG_DRM_PANEL_LVDS,
CONFIG_DRM_PANEL_SIMPLE, CONFIG_DRM_PANEL_SEIKO_43WVF1G,
CONFIG_FB_MODE_HELPERS, CONFIG_BACKLIGHT_PWM, CONFIG_BACKLIGHT_GPIO,
CONFIG_FRAMEBUFFER_CONSOLE, CONFIG_LOGO, CONFIG_FONTS, CONFIG_FONT_8x8
and CONFIG_FONT_8x16.

Based on commit c54467482ffd ("ARM: imx_v6_v7_defconfig: enable fb").

Fixes: f611b1e7624c ("drm: Avoid circular dependencies for CONFIG_FB")
Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/configs/mxs_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/mxs_defconfig b/arch/arm/configs/mxs_defconfig
index ca32446b187f..f53086ddc48b 100644
--- a/arch/arm/configs/mxs_defconfig
+++ b/arch/arm/configs/mxs_defconfig
@@ -93,6 +93,7 @@ CONFIG_REGULATOR_FIXED_VOLTAGE=y
 CONFIG_DRM=y
 CONFIG_DRM_PANEL_SEIKO_43WVF1G=y
 CONFIG_DRM_MXSFB=y
+CONFIG_FB=y
 CONFIG_FB_MODE_HELPERS=y
 CONFIG_LCD_CLASS_DEVICE=y
 CONFIG_BACKLIGHT_CLASS_DEVICE=y
-- 
2.35.1



