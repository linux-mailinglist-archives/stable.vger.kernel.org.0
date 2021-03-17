Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19F1A33E481
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbhCQBAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 21:00:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232167AbhCQA6x (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:58:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49DDD64FF9;
        Wed, 17 Mar 2021 00:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942720;
        bh=hJdYSGplaMOG7aKd6Syo8Iq0Ut9PQzZ1AwQJJHqbo4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dple1tXpLzjLbFAvoMphTltvP7AjQ0fEBw+afzCabScs0iQRauaiqOUq2VQn7XNpX
         vMXXyQSkfCJ9Yrd1yWX6pE2xFLuIt+FbEgnjCon/PFUtaKoD2wxJDtoL25wUC6953S
         L5zYyJCSXRH3QuzORgOhUJqLOv0zBG3rY8s570cWRIgLaKeh9wsDQiYpt9MokwQThN
         6yC24UkcGYQ9x9dq2HfVZ7Ynii4cR812eL4E+62WkTRmUFEo/T3aytbTF1Vy0r02D1
         njmRqK8X4Cc/nZn9Hv5jdTMR+TYVmz+VAd6YkKiwcJrbegJZ+cTVVXm6EDpLkKpBFd
         thpwLaq/gi+lQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 30/37] drm/radeon: fix AGP dependency
Date:   Tue, 16 Mar 2021 20:57:55 -0400
Message-Id: <20210317005802.725825-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005802.725825-1-sashal@kernel.org>
References: <20210317005802.725825-1-sashal@kernel.org>
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
index e67c194c2aca..649f17dfcf45 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -206,6 +206,7 @@ source "drivers/gpu/drm/arm/Kconfig"
 config DRM_RADEON
 	tristate "ATI Radeon"
 	depends on DRM && PCI && MMU
+	depends on AGP || !AGP
 	select FW_LOADER
         select DRM_KMS_HELPER
         select DRM_TTM
-- 
2.30.1

