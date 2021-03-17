Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F4333E42A
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbhCQA6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:58:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:37268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231445AbhCQA5t (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:57:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB55564F9E;
        Wed, 17 Mar 2021 00:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942665;
        bh=/vDZC9ObBHc0XZzNbo9Dx3X2Hf3Qg4Rcv2XiUb2UmTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TpwL2brcLlosTZcz8nzxBlgmOTs/BVVjxkmzkrbCCeChi5jeVrwDkAWMF5COX6z6n
         Mf/iVpyNKc620OyTymE5Xn2glDCmmTuWgw9QU2LZ6wpnjkTBDSzKHWViiMo47NZxEc
         HdfNzcfcHWCdi+HKgj0ZWcqcVPQxGPeWnEAdSvJA1fUP5cEUn0b3BqnROou3jv2tY9
         wIBOFkPHja0BSYKR1xij1Rntt5FmaDlIgojhHQKw+0gwb8UvfziiCNPewRNTipZVfE
         IgsDnj6YMtfvJDuj5bse3vSWb5zkTOWRtz98nXJgpcaUYtNLpCVKIQw8Gz+UXKC8kt
         2vW5qvtj25hMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 42/54] drm/radeon: fix AGP dependency
Date:   Tue, 16 Mar 2021 20:56:41 -0400
Message-Id: <20210317005654.724862-42-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005654.724862-1-sashal@kernel.org>
References: <20210317005654.724862-1-sashal@kernel.org>
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
index 16f73c102394..ca868271f4c4 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -239,6 +239,7 @@ source "drivers/gpu/drm/arm/Kconfig"
 config DRM_RADEON
 	tristate "ATI Radeon"
 	depends on DRM && PCI && MMU
+	depends on AGP || !AGP
 	select FW_LOADER
         select DRM_KMS_HELPER
         select DRM_TTM
-- 
2.30.1

