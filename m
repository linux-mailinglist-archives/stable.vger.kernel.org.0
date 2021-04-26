Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEEDF36AEA1
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232504AbhDZHpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:45:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:34640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234043AbhDZHoo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:44:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFC66613DC;
        Mon, 26 Apr 2021 07:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422877;
        bh=/3N0E6+hOxggBDfkuOMqtb4lM4JlwQVRZe4+NBkJ+qA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sbLrqTXPuxMa+81BQRlGhi0HIc9G2eTyJ0bkyzE9jqHZwsyW+aOIe/zBn+6s7lD/3
         GrNwn2Cim+9QUe1gY/0BCHHX/tt1z8AqCFeiUkEBnnUGpV2ICu1+AbAOqOr31dBeyx
         9bsO0r/SYKNjE4S91BkLpYxKNekmdrLnQQh3uEWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiansong Chen <Jiansong.Chen@amd.com>,
        Tao Zhou <tao.zhou1@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.11 06/41] drm/amdgpu: fix GCR_GENERAL_CNTL offset for dimgrey_cavefish
Date:   Mon, 26 Apr 2021 09:29:53 +0200
Message-Id: <20210426072819.910540107@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072819.666570770@linuxfoundation.org>
References: <20210426072819.666570770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiansong Chen <Jiansong.Chen@amd.com>

commit 24d034528ef06ad94cfcf4394beac0443ab1b16d upstream.

dimgrey_cavefish has similar gc_10_3 ip with sienna_cichlid,
so follow its registers offset setting.

Signed-off-by: Jiansong Chen <Jiansong.Chen@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -3280,7 +3280,7 @@ static const struct soc15_reg_golden gol
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmCPF_GCR_CNTL, 0x0007ffff, 0x0000c000),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmDB_DEBUG3, 0x00000280, 0x00000280),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmDB_DEBUG4, 0x07800000, 0x00800000),
-	SOC15_REG_GOLDEN_VALUE(GC, 0, mmGCR_GENERAL_CNTL, 0x00001d00, 0x00000500),
+	SOC15_REG_GOLDEN_VALUE(GC, 0, mmGCR_GENERAL_CNTL_Sienna_Cichlid, 0x00001d00, 0x00000500),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmGE_PC_CNTL, 0x003c0000, 0x00280400),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmGL2A_ADDR_MATCH_MASK, 0xffffffff, 0xffffffcf),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmGL2C_ADDR_MATCH_MASK, 0xffffffff, 0xffffffcf),


