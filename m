Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE54833E39A
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 01:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhCQA5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:57:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230492AbhCQA4f (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:56:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5C5964FE8;
        Wed, 17 Mar 2021 00:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942595;
        bh=u1IcUxAsnR0p8HYknTE2bkyfOLNMwcdfcfjLCaR9rV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rgW5YsKyqD9Va8mSYtWNUB6AwWLmiVdNyrm1Q7Dmn/JzA/gyBlaZWu/VnHDoPdnts
         AQjojU1Civsr0wCbtS1Cr4kOe3TGyg0ZwQuavd4/IICxq/xc/cOuH1i8PuyWNay0Vc
         12F55E51bnhmyGqQslPqHNztWDX6UTIO0ULYQvR//kgkAM3okoyr7uNOuPAqWDC8IR
         7Ee8ENESZMeqMKEPMLvBBIM1CL/vCcp4aEYv4z+BDqZrIezS++xUFhyJU6Cpc+GHVZ
         BVk//VLHPWnYX4FkG3G6cq/G6aLdtcC5JaqX3Ytx0S58mv8FddKjqtVL2jxBvjfD6I
         KPsIVkLLY5+XQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.11 48/61] drm/radeon: fix AGP dependency
Date:   Tue, 16 Mar 2021 20:55:22 -0400
Message-Id: <20210317005536.724046-48-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
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
index af6c6d214d91..f0c0ccdc8a10 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -232,6 +232,7 @@ source "drivers/gpu/drm/arm/Kconfig"
 config DRM_RADEON
 	tristate "ATI Radeon"
 	depends on DRM && PCI && MMU
+	depends on AGP || !AGP
 	select FW_LOADER
         select DRM_KMS_HELPER
         select DRM_TTM
-- 
2.30.1

