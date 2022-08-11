Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32B9559022E
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236555AbiHKQGt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236768AbiHKQGf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:06:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D4109F0C9;
        Thu, 11 Aug 2022 08:53:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3E05B82150;
        Thu, 11 Aug 2022 15:53:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51440C433D6;
        Thu, 11 Aug 2022 15:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233187;
        bh=7ryKt3BvDv8KyfJYLeaDSvJJFnVL4177BFp4TNwqe/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BYm4MdxaoD0bLgQ7zAJikLafEgoMKJ8POhhjGZ3JK3aqijMbUPzJs6/wlKk105W92
         1QDAHBXl3NIw1X6SVD3ib2v8SO9ifeEr5ucW7T8NBrvh8bFFmm1lTo3LJ6TuXwJkpB
         iFk6AjbeKft9A+XEDkiY8c6VjyoDEU29uXAnxkUijnrhc2zafl+/6uQ3OTh+GvpK+y
         7tIrLlpol+iblkSV0ffbNGzxzyjMcM3eh2+bPDj51Imy758Wi6lEgh9wdjxxOv3BkL
         FoqKcdT9ZmPFaUnzxbcIXZ++soizWlpmTHRGXbtqkUWqP/f7RdEzRZU2Mswx/yCS1M
         e8jndxdGFyaAg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Guchun Chen <guchun.chen@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>, Xinhui.Pan@amd.com,
        airlied@linux.ie, daniel@ffwll.ch, charlene.liu@amd.com,
        harry.wentland@amd.com, jun.lei@amd.com, zhan.liu@amd.com,
        HaoPing.Liu@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.18 63/93] drm/amdgpu: fix file permissions on some files
Date:   Thu, 11 Aug 2022 11:41:57 -0400
Message-Id: <20220811154237.1531313-63-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811154237.1531313-1-sashal@kernel.org>
References: <20220811154237.1531313-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 0a94608f0f7de9b1135ffea3546afe68eafef57f ]

Drop execute.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2085
Reviewed-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/include/asic_reg/clk/clk_11_0_1_offset.h   | 0
 drivers/gpu/drm/amd/include/asic_reg/clk/clk_11_0_1_sh_mask.h  | 0
 drivers/gpu/drm/amd/include/asic_reg/dcn/dcn_2_0_3_offset.h    | 0
 drivers/gpu/drm/amd/include/asic_reg/dcn/dcn_2_0_3_sh_mask.h   | 0
 drivers/gpu/drm/amd/include/asic_reg/dpcs/dpcs_2_0_3_offset.h  | 0
 drivers/gpu/drm/amd/include/asic_reg/dpcs/dpcs_2_0_3_sh_mask.h | 0
 6 files changed, 0 insertions(+), 0 deletions(-)
 mode change 100755 => 100644 drivers/gpu/drm/amd/include/asic_reg/clk/clk_11_0_1_offset.h
 mode change 100755 => 100644 drivers/gpu/drm/amd/include/asic_reg/clk/clk_11_0_1_sh_mask.h
 mode change 100755 => 100644 drivers/gpu/drm/amd/include/asic_reg/dcn/dcn_2_0_3_offset.h
 mode change 100755 => 100644 drivers/gpu/drm/amd/include/asic_reg/dcn/dcn_2_0_3_sh_mask.h
 mode change 100755 => 100644 drivers/gpu/drm/amd/include/asic_reg/dpcs/dpcs_2_0_3_offset.h
 mode change 100755 => 100644 drivers/gpu/drm/amd/include/asic_reg/dpcs/dpcs_2_0_3_sh_mask.h

diff --git a/drivers/gpu/drm/amd/include/asic_reg/clk/clk_11_0_1_offset.h b/drivers/gpu/drm/amd/include/asic_reg/clk/clk_11_0_1_offset.h
old mode 100755
new mode 100644
diff --git a/drivers/gpu/drm/amd/include/asic_reg/clk/clk_11_0_1_sh_mask.h b/drivers/gpu/drm/amd/include/asic_reg/clk/clk_11_0_1_sh_mask.h
old mode 100755
new mode 100644
diff --git a/drivers/gpu/drm/amd/include/asic_reg/dcn/dcn_2_0_3_offset.h b/drivers/gpu/drm/amd/include/asic_reg/dcn/dcn_2_0_3_offset.h
old mode 100755
new mode 100644
diff --git a/drivers/gpu/drm/amd/include/asic_reg/dcn/dcn_2_0_3_sh_mask.h b/drivers/gpu/drm/amd/include/asic_reg/dcn/dcn_2_0_3_sh_mask.h
old mode 100755
new mode 100644
diff --git a/drivers/gpu/drm/amd/include/asic_reg/dpcs/dpcs_2_0_3_offset.h b/drivers/gpu/drm/amd/include/asic_reg/dpcs/dpcs_2_0_3_offset.h
old mode 100755
new mode 100644
diff --git a/drivers/gpu/drm/amd/include/asic_reg/dpcs/dpcs_2_0_3_sh_mask.h b/drivers/gpu/drm/amd/include/asic_reg/dpcs/dpcs_2_0_3_sh_mask.h
old mode 100755
new mode 100644
-- 
2.35.1

