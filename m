Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E490F3BCB76
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbhGFLQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:16:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231817AbhGFLQw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:16:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF7D061C23;
        Tue,  6 Jul 2021 11:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570054;
        bh=epLAffIQc77bcA44wYbXzn+8dh4Eepktdm8W90mUD4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fzh08ZuiohHcbjvUwi+4t1XocdH2UdBbN4n6TYcF3WRNCG/mLESYIFYhCaqhAolbj
         wtA/cEz9Lu3b9S0IhhtR01pF7j0E/7rwhN2nqaJ1v8mLsyAtv7YZ84y8ziW/yWQhx0
         6PF7eztSS8J1gMHJzMao9yrZj305zTxUJLrXjSKreNVrhN9GbrJeN/EnB4oCDEwGoM
         qecwIDxj56/rAXeJYoa3mhGa7T/TbAj2FH1ZScwMpkZasUreIxYcqak3NKUCLqFuHQ
         ue422oTsU8dlL2+44zgGxWx2wTVpSoklt9bMbxO23gog1QqoyoNH+xbESPWPBpIjIA
         ShdYv9wBc4mcA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.13 003/189] drm/zte: Don't select DRM_KMS_FB_HELPER
Date:   Tue,  6 Jul 2021 07:11:03 -0400
Message-Id: <20210706111409.2058071-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit a50e74bec1d17e95275909660c6b43ffe11ebcf0 ]

Selecting DRM_FBDEV_EMULATION will include the correct settings for
fbdev emulation. Drivers should not override this.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20210415110040.23525-4-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/zte/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/zte/Kconfig b/drivers/gpu/drm/zte/Kconfig
index 90ebaedc11fd..aa8594190b50 100644
--- a/drivers/gpu/drm/zte/Kconfig
+++ b/drivers/gpu/drm/zte/Kconfig
@@ -3,7 +3,6 @@ config DRM_ZTE
 	tristate "DRM Support for ZTE SoCs"
 	depends on DRM && ARCH_ZX
 	select DRM_KMS_CMA_HELPER
-	select DRM_KMS_FB_HELPER
 	select DRM_KMS_HELPER
 	select SND_SOC_HDMI_CODEC if SND_SOC
 	select VIDEOMODE_HELPERS
-- 
2.30.2

