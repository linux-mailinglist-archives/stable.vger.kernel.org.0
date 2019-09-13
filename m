Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7E5B1FF8
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389188AbfIMNMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:12:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388580AbfIMNMk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:12:40 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1220D214AE;
        Fri, 13 Sep 2019 13:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380359;
        bh=Dg5xxp6XDyUNhywFnjd4CywNXen2+N6sfss7jCc7eNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hFQgKMwQnaAij0Y6GDdV15fHXdaR3zbKmLXxlO8d1kEXUz8g9E0g32PAD6bBdF8Pt
         isldhcLiJlAmK5ToMbzLBePuwFVeEaxSK+8mr7/5mRjNdA1EwB3qjG7XpzF3eLFGKl
         Tggwl+cuPb4eqy4bYWMrs0xtyKB7TbnjicvjE4lg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Feifei Xu <Feifei.Xu@amd.com>,
        Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 039/190] drm/amdgpu: Update gc_9_0 golden settings.
Date:   Fri, 13 Sep 2019 14:04:54 +0100
Message-Id: <20190913130602.842018619@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



