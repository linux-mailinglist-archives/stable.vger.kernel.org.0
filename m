Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 638F53BD1AC
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238752AbhGFLkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:40:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237304AbhGFLgE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E0E661EEF;
        Tue,  6 Jul 2021 11:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570803;
        bh=VsUJo/G01m795u2MCdAiXc6gQHD+pp3Da68q0lsOLzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jvR2GX9xoaYjuP41YeD0pMCm7rxf0CRafyhV6RYqMOe/s8Ez9cop2xZwznBOc3Pe7
         gt9ornTmEh+kYHNc/U0/SyTMrNWehTL9JO7nsuKDF6V7Sl0KRXj3Z7L7iBDlF62i6M
         nxZCI4m/joOFRTyJz/9FW0se9OFECKozZ2KtYQFk3DfWSLz0rLI4TiCablu7t8qzfI
         lc8PTPG/ehObQWqF5Sv+sMuiMZ7Cyz0oJs6k+VutY3PTodKh/Rda4gVgScfsOFP+iX
         9JTxwrrpjll0ssxHhK1RcewfZeWZ21iry8HERcfU5q3+0/tBTURDCzNPWkgFmrRj8V
         RX3uH/anZTbbA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 03/55] drm/zte: Don't select DRM_KMS_FB_HELPER
Date:   Tue,  6 Jul 2021 07:25:46 -0400
Message-Id: <20210706112638.2065023-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112638.2065023-1-sashal@kernel.org>
References: <20210706112638.2065023-1-sashal@kernel.org>
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

