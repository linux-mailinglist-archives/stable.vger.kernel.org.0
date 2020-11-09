Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4A92ABA90
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732848AbgKINUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:20:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:47970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387923AbgKINUZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:20:25 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2044620663;
        Mon,  9 Nov 2020 13:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604928024;
        bh=TF/rx04DQfoiTX6V3jnN74VQ+JLF2s+0TjX8PCW224A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CjQIQmjJyKdhQ42Ag/wNegQzJdG6/9pRHzfr3DDcaSJsowbFeTV2uZ+AZItgnVnpb
         8IgY93Lse0osdMB/iqFSn8W2RTI9/3X2u9d8L+eKEzFMhkEle4kaeDm31OI0ASbAls
         U4lkIao//07SsYbHEt6cXOZzYdTRHKBEFEZkUImM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Likun Gao <Likun.Gao@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.9 061/133] drm/amdgpu: update golden setting for sienna_cichlid
Date:   Mon,  9 Nov 2020 13:55:23 +0100
Message-Id: <20201109125033.667124832@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Likun Gao <Likun.Gao@amd.com>

commit a2404fd4823053db08d82582f4361e0978a98a24 upstream.

Update golden setting for sienna_cichlid.

Signed-off-by: Likun Gao <Likun.Gao@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -128,6 +128,9 @@
 #define PA_SC_ENHANCE_3__FORCE_PBB_WORKLOAD_MODE_TO_ZERO__SHIFT 0x3
 #define PA_SC_ENHANCE_3__FORCE_PBB_WORKLOAD_MODE_TO_ZERO_MASK   0x00000008L
 
+#define mmCGTT_SPI_CS_CLK_CTRL			0x507c
+#define mmCGTT_SPI_CS_CLK_CTRL_BASE_IDX         1
+
 MODULE_FIRMWARE("amdgpu/navi10_ce.bin");
 MODULE_FIRMWARE("amdgpu/navi10_pfp.bin");
 MODULE_FIRMWARE("amdgpu/navi10_me.bin");
@@ -3094,6 +3097,7 @@ static const struct soc15_reg_golden gol
 
 static const struct soc15_reg_golden golden_settings_gc_10_3[] =
 {
+	SOC15_REG_GOLDEN_VALUE(GC, 0, mmCGTT_SPI_CS_CLK_CTRL, 0x78000000, 0x78000100),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmCGTT_SPI_PS_CLK_CTRL, 0xff7f0fff, 0x78000100),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmCGTT_SPI_RA0_CLK_CTRL, 0xff7f0fff, 0x30000100),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmCGTT_SPI_RA1_CLK_CTRL, 0xff7f0fff, 0x7e000100),


