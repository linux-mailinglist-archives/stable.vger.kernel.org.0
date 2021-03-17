Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C463A33E4AF
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbhCQBAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 21:00:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232156AbhCQA7O (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:59:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53AB864FC7;
        Wed, 17 Mar 2021 00:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942753;
        bh=n7t8f2l0CysmlHiuZW++Ft9mjEipInAmI5pBKnZIFSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GYpoCJlT93Aa5+xcRJ1FqV2NQkkW/wbfwF7TOORWKUeVXjsbgI7DMFfS6znzrxQkZ
         wfjKhvU/Bb+gpcLMY1l5c/eqbVAS3BfD4rZDyH73uBg7YatJ9zs91fZFg7VXXbEyuu
         H/b4+ifRUg9Lw2OMWoH2zGvy5Q2tjL2HjcV2E4P4oQiX4bKCuEpXUosGo9EE3uPITt
         J4rMv8qjthvdxGcvr/O+0KhGfNyx5NXrhGFDU2XzB9KRBQcQLMnJiXm29kdgWjHRpg
         /tgbC/zK0TqJQtr0duPKNu5nq89zehH70XJg3ccRV+/vClfp5zfMbmC+zu65vdnsmk
         T773+6idb0dkw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 19/23] drm/radeon: fix AGP dependency
Date:   Tue, 16 Mar 2021 20:58:45 -0400
Message-Id: <20210317005850.726479-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005850.726479-1-sashal@kernel.org>
References: <20210317005850.726479-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

[ Upstream commit cba2afb65cb05c3d197d17323fee4e3c9edef9cd ]

When AGP is compiled as module radeon must be compiled as module as
well.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index e44e567bd789..a050a9aa9a5e 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -192,6 +192,7 @@ source "drivers/gpu/drm/arm/Kconfig"
 config DRM_RADEON
 	tristate "ATI Radeon"
 	depends on DRM && PCI && MMU
+	depends on AGP || !AGP
 	select FW_LOADER
         select DRM_KMS_HELPER
         select DRM_TTM
-- 
2.30.1

