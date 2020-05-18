Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB70D1D831E
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732488AbgERSCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:02:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732479AbgERSCN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:02:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F16C20872;
        Mon, 18 May 2020 18:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824932;
        bh=0zUgoL8zGPgVJ5XXJhZqITkeX4BLPqERLZPMDtUiQog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NvJqWjw4dcVB25GrNXfzqUm9PY3ThlRmBMbyO02dlVNBHLKSX3QA6i4SyfcLUIK21
         AJu7VXZXypiYuB0A8USMDsjA3TvaktPMWyDjNbqGRk0rYOgM7zYOe0tyvPXmz4vB8N
         xN+lDVOsIF28bnlsc/fBMqF8u+1kF8FvyCNDmSoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 061/194] drm/amdgpu: bump version for invalidate L2 before SDMA IBs
Date:   Mon, 18 May 2020 19:35:51 +0200
Message-Id: <20200518173536.800109596@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Olšák <marek.olsak@amd.com>

[ Upstream commit 9017a4897a20658f010bebea825262963c10afa6 ]

This fixes GPU hangs due to cache coherency issues.
Bump the driver version. Split out from the original patch.

Signed-off-by: Marek Olšák <marek.olsak@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Tested-by: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 42f4febe24c6d..8d45a2b662aeb 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -85,9 +85,10 @@
  * - 3.34.0 - Non-DC can flip correctly between buffers with different pitches
  * - 3.35.0 - Add drm_amdgpu_info_device::tcc_disabled_mask
  * - 3.36.0 - Allow reading more status registers on si/cik
+ * - 3.37.0 - L2 is invalidated before SDMA IBs, needed for correctness
  */
 #define KMS_DRIVER_MAJOR	3
-#define KMS_DRIVER_MINOR	36
+#define KMS_DRIVER_MINOR	37
 #define KMS_DRIVER_PATCHLEVEL	0
 
 int amdgpu_vram_limit = 0;
-- 
2.20.1



