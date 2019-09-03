Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEC8A7074
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730623AbfICQj3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:39:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729939AbfICQZm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:25:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FF1623717;
        Tue,  3 Sep 2019 16:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527941;
        bh=OUB517hQEW/tE8hx4gcYRH+OGx2V43iRvpIem4nJ9Lg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0yhf0y6bvE9AQBwQd1mkGSfVqZBrgetbuF8BpEgY6MfJub/jSlMTSxyXY8vEi6rft
         0xTsbsjmgEX14Pd/T6DNzY92j+jzyj1n5rTq/Ts5DVSxTjX+rVq6iZTElFXE6iMz5T
         Fh5QJyow9zprFEvNQNsNaz06ssiOPIkCTLG05OPc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Feifei Xu <Feifei.Xu@amd.com>, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 010/167] drm/amdgpu: Update gc_9_0 golden settings.
Date:   Tue,  3 Sep 2019 12:22:42 -0400
Message-Id: <20190903162519.7136-10-sashal@kernel.org>
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

[ Upstream commit c55045adf7210d246a016c961916f078ed31a951 ]

Add mmDB_DEBUG3 settings.

Signed-off-by: Feifei Xu <Feifei.Xu@amd.com>
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index f040ec10eecf6..7824116498169 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -83,6 +83,7 @@ MODULE_FIRMWARE("amdgpu/raven_rlc.bin");
 static const struct soc15_reg_golden golden_settings_gc_9_0[] =
 {
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmDB_DEBUG2, 0xf00fffff, 0x00000400),
+	SOC15_REG_GOLDEN_VALUE(GC, 0, mmDB_DEBUG3, 0x80000000, 0x80000000),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmGB_GPU_ID, 0x0000000f, 0x00000000),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmPA_SC_BINNER_EVENT_CNTL_3, 0x00000003, 0x82400024),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmPA_SC_ENHANCE, 0x3fffffff, 0x00000001),
-- 
2.20.1

