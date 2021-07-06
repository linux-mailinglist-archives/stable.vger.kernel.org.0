Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F003BCB75
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhGFLQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:16:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231787AbhGFLQv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:16:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73EEE61C20;
        Tue,  6 Jul 2021 11:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570053;
        bh=8zY8dRMfQiVYsok90pcHhDj8dcATD+Fzm7MWBbgQjNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aUXzhInT+xpj6YXqQla6mqbHe1AMlUXbuvD1IR526S3jtawvWI3BxzT40BcB3Jh4o
         8e9CR4E84IDOIIxybeAV5/RhWRQvOnX6ZQzSigNXalZFAiAjSyjd/0BzzMvyJb1yfw
         ftoL4WWDb+Zb+LpzdsGses533nCM+P0mW+TPz2nzoMjdhwFS7DXfsygHZbpveFJXWK
         k8v+jczzgCiWNXtoYaX8RgD1XbtPp95rnzn7dPH5yj8rIygFT55/rf8e0qIYtrzunQ
         E522e8Gfb3nYBqNOSk25ciQ6mXkmRC+6J+xOhZKw5LZTdgEPJeurMlnXAtBHDgJNlN
         VjUwFop2JbeKA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Zimmermann <tzimmermann@suse.de>,
        Stefan Agner <stefan@agner.ch>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 002/189] drm/mxsfb: Don't select DRM_KMS_FB_HELPER
Date:   Tue,  6 Jul 2021 07:11:02 -0400
Message-Id: <20210706111409.2058071-2-sashal@kernel.org>
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

