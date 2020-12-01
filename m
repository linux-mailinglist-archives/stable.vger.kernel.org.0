Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A9F2C9B7C
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389362AbgLAJI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:08:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:45484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389354AbgLAJI5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:08:57 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36DDE20671;
        Tue,  1 Dec 2020 09:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813721;
        bh=d1nG980IEPZLA+rcNckBpmtfXV0lAqqDGh0N0pm5Szs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pvn2+f1z2LY+pGXGmTx3OFKrprHE2lRF7w2v8By6Jf4bZiEpuvvb8/QfBLrW8HRGE
         jH4c5ChmFEUs+suGhcHFCp1H8l/J98AMUPVy89+8ozzL8J/OD58GgnDPwbELO7zfn2
         AMM1ok0UIUOAiybKLDM3N088P+LE0PxAx1qoWtzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Likun Gao <Likun.Gao@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.9 036/152] drm/amdgpu: update golden setting for sienna_cichlid
Date:   Tue,  1 Dec 2020 09:52:31 +0100
Message-Id: <20201201084716.593967194@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Likun Gao <Likun.Gao@amd.com>

commit 60734bd54679d7998a24a257b0403f7644005572 upstream.

Update golden setting for sienna_cichlid.

Signed-off-by: Likun Gao <Likun.Gao@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.9.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -3105,6 +3105,8 @@ static const struct soc15_reg_golden gol
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmDB_DEBUG3, 0xffffffff, 0x00000280),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmDB_DEBUG4, 0xffffffff, 0x00800000),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmDB_EXCEPTION_CONTROL, 0x7fff0f1f, 0x00b80000),
+	SOC15_REG_GOLDEN_VALUE(GC, 0 ,mmGCEA_SDP_TAG_RESERVE0, 0xffffffff, 0x10100100),
+	SOC15_REG_GOLDEN_VALUE(GC, 0, mmGCEA_SDP_TAG_RESERVE1, 0xffffffff, 0x17000088),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmGCR_GENERAL_CNTL_Sienna_Cichlid, 0x1ff1ffff, 0x00000500),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmGE_PC_CNTL, 0x003fffff, 0x00280400),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmGL2A_ADDR_MATCH_MASK, 0xffffffff, 0xffffffcf),


