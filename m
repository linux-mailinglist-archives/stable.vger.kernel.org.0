Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3D13BD1A8
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238698AbhGFLkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:40:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237301AbhGFLgE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 328EB61C75;
        Tue,  6 Jul 2021 11:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570802;
        bh=MfhOHP9+n0LI8xfLnM2mS/CsEj2P2NLk0DnPZEVhPb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ug/nZFY1QC4z396BQi9VMLRYcFvgHI3Hxeirw+8bphlzDn8ZS//6VCmapC3S4el8w
         5kL0U+PHSp/00HvEU47Qhn2gOYpXIJwxW938MLTxsa6lrooie1oD6VhvXvoE6KIHFz
         ZOmk8wV7DoE1+dbwy7TRNEVvLbeXd2u1Y5RaGeqpRA7A0tt0fmKaBmQIbEkxWUDybj
         vC2tNf58djuxEi4WigI3Miz5XDAa97L1xl0KolaGvY21HLwFtE0OGORDOepuVp1hRi
         05N6Tc/BVVRopXFI3Ot1coSQ1GNf5SF57uupiuG9MzACC/FpDnusxctIDH2RSkER06
         rgbrQ47cFqHtQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Zimmermann <tzimmermann@suse.de>,
        Stefan Agner <stefan@agner.ch>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 02/55] drm/mxsfb: Don't select DRM_KMS_FB_HELPER
Date:   Tue,  6 Jul 2021 07:25:45 -0400
Message-Id: <20210706112638.2065023-2-sashal@kernel.org>
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
index e9a8d90e6723..3ed6849d63cb 100644
--- a/drivers/gpu/drm/mxsfb/Kconfig
+++ b/drivers/gpu/drm/mxsfb/Kconfig
@@ -9,7 +9,6 @@ config DRM_MXSFB
 	depends on COMMON_CLK
 	select DRM_MXS
 	select DRM_KMS_HELPER
-	select DRM_KMS_FB_HELPER
 	select DRM_KMS_CMA_HELPER
 	select DRM_PANEL
 	help
-- 
2.30.2

