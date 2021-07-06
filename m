Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22C13BD211
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237597AbhGFLlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:41:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237477AbhGFLgL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8921061DA7;
        Tue,  6 Jul 2021 11:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570874;
        bh=VsUJo/G01m795u2MCdAiXc6gQHD+pp3Da68q0lsOLzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CZ3wKIXH4iJOg5OHQgl5/stZDhom/BBfnHGP9P6xLR6UAnZKeWdCX/r3KE43uVzMI
         a+qJll+UjISXwbjCeKBKvv+96/pZNsFVTJYGdx3dWS9/JQ0XZekVvHu793ab5R65XE
         ZO6VmSq0f6RYfY20TNrvWXN4k6u8SrKN3eIo9lthfM7o7eKZqEWezd5a6TmjWXmkOr
         kSmYFCOvYDqQj1YbTM9aH1mdmrVG0ccEMxNilAJEo1LrmLtTmJBkoZVTOCrgtBFKJ+
         PzZCXazs1Q6r/hrVvSwbkFwPQsyTY3fuUCyLe58weEuYxoH5ZCzquC3rkwo7RlMxCJ
         VxO1QDTi1SagQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.14 03/45] drm/zte: Don't select DRM_KMS_FB_HELPER
Date:   Tue,  6 Jul 2021 07:27:07 -0400
Message-Id: <20210706112749.2065541-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112749.2065541-1-sashal@kernel.org>
References: <20210706112749.2065541-1-sashal@kernel.org>
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
index 5b36421ef3e5..75b70126d2d3 100644
--- a/drivers/gpu/drm/zte/Kconfig
+++ b/drivers/gpu/drm/zte/Kconfig
@@ -2,7 +2,6 @@ config DRM_ZTE
 	tristate "DRM Support for ZTE SoCs"
 	depends on DRM && ARCH_ZX
 	select DRM_KMS_CMA_HELPER
-	select DRM_KMS_FB_HELPER
 	select DRM_KMS_HELPER
 	select SND_SOC_HDMI_CODEC if SND_SOC
 	select VIDEOMODE_HELPERS
-- 
2.30.2

