Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD4B3BD16A
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238361AbhGFLj1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:39:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237007AbhGFLfu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60CDA61C3B;
        Tue,  6 Jul 2021 11:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570706;
        bh=7B8J8Q6iAZvGAEwKlJhNjZzre+LVz0+Y/y5z3CsLS90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tWpxki0KL1AmSzD2jaMxsogzPbcm5b/ANSb/8dAUhsgBo2fSLtrzFKrow3gAUc/ax
         N6pHimJebKheqBmEM1X4Nhr3nAiVIJF3CeoEyh/ZTulZ2ncmFvDpslhmh4hZnvtQqu
         Jgofrc14qw5zNwDgPUSPhyO+Y/1PN7ph4o0/yBs6nMvgzDg6G/MEg5WUgWYf2x9CQ7
         Z+0Jew4qF5+rQT+jwbiCzI6D50pJR1rLxAMcF5+B95+GHD4MbCy1EOpbqibKhtjn8V
         krrlmu3svXb07Jn5MAB9oczVadrz/ijl6DannLM0VbdhX4l2M3Z+vm9qdKK8nkOIN9
         Lu1QT0ktvkbEA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Zimmermann <tzimmermann@suse.de>,
        Stefan Agner <stefan@agner.ch>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 02/74] drm/mxsfb: Don't select DRM_KMS_FB_HELPER
Date:   Tue,  6 Jul 2021 07:23:50 -0400
Message-Id: <20210706112502.2064236-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112502.2064236-1-sashal@kernel.org>
References: <20210706112502.2064236-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 13b29cc3a722c2c0bc9ab9f72f9047d55d08a2f9 ]

Selecting DRM_FBDEV_EMULATION will include the correct settings for
fbdev emulation. Drivers should not override this.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Acked-by: Stefan Agner <stefan@agner.ch>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20210415110040.23525-3-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mxsfb/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/mxsfb/Kconfig b/drivers/gpu/drm/mxsfb/Kconfig
index 0dca8f27169e..33916b7b2c50 100644
--- a/drivers/gpu/drm/mxsfb/Kconfig
+++ b/drivers/gpu/drm/mxsfb/Kconfig
@@ -10,7 +10,6 @@ config DRM_MXSFB
 	depends on COMMON_CLK
 	select DRM_MXS
 	select DRM_KMS_HELPER
-	select DRM_KMS_FB_HELPER
 	select DRM_KMS_CMA_HELPER
 	select DRM_PANEL
 	help
-- 
2.30.2

