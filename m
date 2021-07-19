Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84F23CDB65
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245077AbhGSOmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:42:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:60410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243243AbhGSOkT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:40:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B85B66128A;
        Mon, 19 Jul 2021 15:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708048;
        bh=VsUJo/G01m795u2MCdAiXc6gQHD+pp3Da68q0lsOLzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fwwKLnmaMd2bZctOM85Oy8FJulJd56ryCWS8jZnhQbZoyHQPLNSz5rAgTSN5FKCBB
         fDfaDjXQ9T/V1hyy3dBe0Zx4dKQnGG4KGGlZN+L2LdNpVEEUUXUOeZsxwJiNwd9jaf
         +PL+b+Qk2U4bNuqhp/EROha0N5+7InPfesk9bQ20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 161/315] drm/zte: Dont select DRM_KMS_FB_HELPER
Date:   Mon, 19 Jul 2021 16:50:50 +0200
Message-Id: <20210719144948.187910554@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
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



