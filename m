Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092DF3BD4B9
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 14:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238060AbhGFMRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 08:17:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235894AbhGFLac (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:30:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A2A361DD6;
        Tue,  6 Jul 2021 11:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570527;
        bh=epLAffIQc77bcA44wYbXzn+8dh4Eepktdm8W90mUD4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TvA5M8SD0AeJO67taxGjsLWECS/px3oKwV/WVCriIRbAEbP9OJdeLzauxjilJ2Yfl
         L4NGsJbf0hT7H1qodXLmGIinf0qEbX3kkUteDuYOQKrrO/o0YowzwQ7SsuKmPVylbu
         7BdLMbUEdMdWT+ceXQSRSsEBrW4gp/qYyCtrXoGYhFXR8b2zuRk7PBoRpSKBNucptX
         EkSDOG+TJ0CG3MPE3ZiACcVPRlX1d0sbHjNW95NZ+eUhto08Q7dvvoxNUmetT+nf7Y
         DDXEIV64IDAPmyUAK/xfaIRO/KkgQXTcujTucxApFZm6DtV5iYxpA/LZ0+lyQUdBWE
         wGONotxO93NJQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 003/137] drm/zte: Don't select DRM_KMS_FB_HELPER
Date:   Tue,  6 Jul 2021 07:19:49 -0400
Message-Id: <20210706112203.2062605-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
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

