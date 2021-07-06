Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4EB3BCEC0
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234202AbhGFL1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:27:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234473AbhGFLYc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:24:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABB9161CD2;
        Tue,  6 Jul 2021 11:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570310;
        bh=8zY8dRMfQiVYsok90pcHhDj8dcATD+Fzm7MWBbgQjNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IQG54Ngrqdby+BGhfmS87/wptvwXnS/n+/Uro8aFgArALTnuCQAb3nAxE/omTQd8U
         VMHIieVmLBxbEV/3mt7ledKA+Q6HJwDshfBUt+lysUs5StwWusUBK2eheh1D/uMZ3o
         v8H8zDjECiIv0lu/F2HBmtuFrzoNMKYoCfZenseDe1vzQUP3GYVYcfzmRIvujPY8mb
         D7m7I/cpe1Cx1G85u9c1r5gQQEONeDP6FL2DdYKWp+beq55Rm5Fmk5IjqOQI/0UJ/I
         OAQBiBwGyq+nlpRIy7b3PbY+rZLeBY6R6PcKbZ0iL6fehlmsQ0f+f4zXLIMqlV3iLq
         D58lG6xRpZGuA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Zimmermann <tzimmermann@suse.de>,
        Stefan Agner <stefan@agner.ch>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 002/160] drm/mxsfb: Don't select DRM_KMS_FB_HELPER
Date:   Tue,  6 Jul 2021 07:15:48 -0400
Message-Id: <20210706111827.2060499-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
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
index 0143d539f8f8..ee22cd25d3e3 100644
--- a/drivers/gpu/drm/mxsfb/Kconfig
+++ b/drivers/gpu/drm/mxsfb/Kconfig
@@ -10,7 +10,6 @@ config DRM_MXSFB
 	depends on COMMON_CLK
 	select DRM_MXS
 	select DRM_KMS_HELPER
-	select DRM_KMS_FB_HELPER
 	select DRM_KMS_CMA_HELPER
 	select DRM_PANEL
 	select DRM_PANEL_BRIDGE
-- 
2.30.2

