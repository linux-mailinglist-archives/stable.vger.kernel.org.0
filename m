Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22ED53C5363
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352357AbhGLHyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:54:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:35406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350305AbhGLHut (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:50:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 736CD61175;
        Mon, 12 Jul 2021 07:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075854;
        bh=k3rMDRj1CcYDCrfz6SCTtYRXpnOHVa/s87RkSHQ2/0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fGnwxwrX6UlgtTUwSfgjb/TuJv6Fom6c5ZqwH7nnqUhrd5IGNv1waCWoHZhQqXyVT
         V6mCwCebP5pI9BsVcUqlmzr+DHXEHN9O8jwnhC/ZKHS5B5cKtfcRijJAUpHXwhOE8u
         vv8IuxLvU2edgHgXcjQYlcHmWFFmDuXu2vRy1QuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michal=20Such=C3=A1nek?= <msuchanek@suse.de>,
        Adrien Grassein <adrien.grassein@gmail.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 394/800] drm/bridge: fix LONTIUM_LT8912B dependencies
Date:   Mon, 12 Jul 2021 08:06:57 +0200
Message-Id: <20210712061009.101358493@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrien Grassein <adrien.grassein@gmail.com>

[ Upstream commit 660729e494b6ee64feb97b41f3092c32a41c7dae ]

LONTIUM_LT8912B uses "drm_display_mode_to_videomode" from
DRM framework that needs VIDEOMODE_HELPERS to be enabled.

Fixes: 30e2ae943c26 ("drm/bridge: Introduce LT8912B DSI to HDMI bridge")
Reported-by: Michal Suchánek <msuchanek@suse.de>
Signed-off-by: Adrien Grassein <adrien.grassein@gmail.com>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210504220207.4004511-1-adrien.grassein@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/bridge/Kconfig b/drivers/gpu/drm/bridge/Kconfig
index eb3eebab4f27..9ce8438fb58b 100644
--- a/drivers/gpu/drm/bridge/Kconfig
+++ b/drivers/gpu/drm/bridge/Kconfig
@@ -68,6 +68,7 @@ config DRM_LONTIUM_LT8912B
 	select DRM_KMS_HELPER
 	select DRM_MIPI_DSI
 	select REGMAP_I2C
+	select VIDEOMODE_HELPERS
 	help
 	  Driver for Lontium LT8912B DSI to HDMI bridge
 	  chip driver.
-- 
2.30.2



