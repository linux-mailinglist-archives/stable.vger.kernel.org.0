Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275723CA5C2
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbhGOSoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:44:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229695AbhGOSoU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:44:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF6A0613CF;
        Thu, 15 Jul 2021 18:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374486;
        bh=epLAffIQc77bcA44wYbXzn+8dh4Eepktdm8W90mUD4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZdJQTTXG4N81DB4zQtyJ+nD5gonJYO1ukfwRrE6Ec0oIVH1GKl9ZA97OLK7qTaNSw
         IF8y9b9boDejOz89HvwtySfv4QxQqKDwEqXUs0cLdsxCpcZb1QM1xv6UamSS9qWwyA
         269OkysFJppM6mA7IotPXrnAWsnmh+GeQ5wNk04M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 002/122] drm/zte: Dont select DRM_KMS_FB_HELPER
Date:   Thu, 15 Jul 2021 20:37:29 +0200
Message-Id: <20210715182449.148551728@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182448.393443551@linuxfoundation.org>
References: <20210715182448.393443551@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



