Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0636238EE73
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233303AbhEXPu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:50:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:33874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233405AbhEXPsI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:48:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 533E461481;
        Mon, 24 May 2021 15:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870638;
        bh=xfpbtCYOgj/mHQkgMoGWUuFqbIMSieEkqd5zln9Vf2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DVi2doIsfe5CLhXGuE7ogmuRX99WWaKT2551aHTW0DUe0oLQ+ieSvxLLqJtYFAQ5P
         pR3q30Jv/+p2tzp54BABb73N/l7wY6L4n3UAH3/LVQRRhhIQF/UrO0crX5laYhaOIq
         QsNudKESUPP9mjNASZrJh1rooBZ5LyzuDec0I0ec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guchun Chen <guchun.chen@amd.com>,
        Kenneth Feng <kenneth.feng@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 38/71] drm/amdgpu: update gc golden setting for Navi12
Date:   Mon, 24 May 2021 17:25:44 +0200
Message-Id: <20210524152327.709112285@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152326.447759938@linuxfoundation.org>
References: <20210524152326.447759938@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guchun Chen <guchun.chen@amd.com>

commit 99c45ba5799d6b938bd9bd20edfeb6f3e3e039b9 upstream.

Current golden setting is out of date.

Signed-off-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -190,9 +190,10 @@ static const struct soc15_reg_golden gol
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmDB_DEBUG, 0xffffffff, 0x20000000),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmDB_DEBUG2, 0xffffffff, 0x00000420),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmDB_DEBUG3, 0xffffffff, 0x00000200),
-	SOC15_REG_GOLDEN_VALUE(GC, 0, mmDB_DEBUG4, 0xffffffff, 0x04800000),
+	SOC15_REG_GOLDEN_VALUE(GC, 0, mmDB_DEBUG4, 0xffffffff, 0x04900000),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmDB_DFSM_TILES_IN_FLIGHT, 0x0000ffff, 0x0000003f),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmDB_LAST_OF_BURST_CONFIG, 0xffffffff, 0x03860204),
+	SOC15_REG_GOLDEN_VALUE(GC, 0, mmGB_ADDR_CONFIG, 0x0c1800ff, 0x00000044),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmGCR_GENERAL_CNTL, 0x1ff0ffff, 0x00000500),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmGE_PRIV_CONTROL, 0x00007fff, 0x000001fe),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmGL1_PIPE_STEER, 0xffffffff, 0xe4e4e4e4),
@@ -210,12 +211,13 @@ static const struct soc15_reg_golden gol
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmPA_SC_ENHANCE_2, 0x00000820, 0x00000820),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmPA_SC_LINE_STIPPLE_STATE, 0x0000ff0f, 0x00000000),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmRMI_SPARE, 0xffffffff, 0xffff3101),
+	SOC15_REG_GOLDEN_VALUE(GC, 0, mmSPI_CONFIG_CNTL_1, 0x001f0000, 0x00070104),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmSQ_ALU_CLK_CTRL, 0xffffffff, 0xffffffff),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmSQ_ARB_CONFIG, 0x00000133, 0x00000130),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmSQ_LDS_CLK_CTRL, 0xffffffff, 0xffffffff),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmTA_CNTL_AUX, 0xfff7ffff, 0x01030000),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmTCP_CNTL, 0xffdf80ff, 0x479c0010),
-	SOC15_REG_GOLDEN_VALUE(GC, 0, mmUTCL1_CTRL, 0xffffffff, 0x00800000)
+	SOC15_REG_GOLDEN_VALUE(GC, 0, mmUTCL1_CTRL, 0xffffffff, 0x00c00000)
 };
 
 static const struct soc15_reg_golden golden_settings_gc_10_1_nv14[] =


