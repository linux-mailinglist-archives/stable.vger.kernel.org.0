Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4982A6E5A
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730436AbfICQZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:25:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:45858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730432AbfICQZj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:25:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFB692377D;
        Tue,  3 Sep 2019 16:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527938;
        bh=XlxNZltnNdt+6EtfyRaBtW3SLGlCNlWUzNKBkJGyq/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SaY/pN1ZiAJlU8M2uM47SkfHk8jxx4hJgAqdtycNv+Y77a5Furqy3hLKY9svk2wRa
         1LnX+yJt05B6Z5D3bTDRyJ6P2j3indIBuYK10fDja9Vja9PMrHUmCi0HiXJRCmtyBP
         QWRDfiJlaaV2N6lIE9f1k60PIFY9Xo9dIdVVB2do=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Feifei Xu <Feifei.Xu@amd.com>, Evan Quan <evan.quan@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 009/167] drm/amdgpu/gfx9: Update gfx9 golden settings.
Date:   Tue,  3 Sep 2019 12:22:41 -0400
Message-Id: <20190903162519.7136-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Feifei Xu <Feifei.Xu@amd.com>

[ Upstream commit 54d682d9a5b357eb711994fa94ef1bc44d7ce9d9 ]

Update the goldensettings for vega20.

Signed-off-by: Feifei Xu <Feifei.Xu@amd.com>
Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index 46568497ef181..f040ec10eecf6 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -82,7 +82,7 @@ MODULE_FIRMWARE("amdgpu/raven_rlc.bin");
 
 static const struct soc15_reg_golden golden_settings_gc_9_0[] =
 {
-	SOC15_REG_GOLDEN_VALUE(GC, 0, mmDB_DEBUG2, 0xf00fffff, 0x00000420),
+	SOC15_REG_GOLDEN_VALUE(GC, 0, mmDB_DEBUG2, 0xf00fffff, 0x00000400),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmGB_GPU_ID, 0x0000000f, 0x00000000),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmPA_SC_BINNER_EVENT_CNTL_3, 0x00000003, 0x82400024),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmPA_SC_ENHANCE, 0x3fffffff, 0x00000001),
-- 
2.20.1

