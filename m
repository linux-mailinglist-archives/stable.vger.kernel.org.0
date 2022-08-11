Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62531590097
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236447AbiHKPpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236450AbiHKPot (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:44:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54278A0639;
        Thu, 11 Aug 2022 08:39:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0DDDB82123;
        Thu, 11 Aug 2022 15:39:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93189C433C1;
        Thu, 11 Aug 2022 15:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232340;
        bh=7ryKt3BvDv8KyfJYLeaDSvJJFnVL4177BFp4TNwqe/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EatQvS4a/p1Za8mUpLLsmd0LAXAW2f24ONwRmMb5EvZyjxnKniSQ2GiV/Rv3G+cK8
         /x7VCljiRjWXTBAbh0VRks5AccoqrB3VsW49KLu4Z/rEKqlywmhzF/IfiLsby5ZLdV
         h0wn0S2Ph3Cwv2CdClEKDfrpyBYTlGke7BKRxMEeqmeCg7PailE5wnsxR1L4SXrnUX
         gMzCF0HzmLKpcfYZ5HKvk77NqaFjqz/DU2fsgq2zdi8MuO+NrPtji8087zXkHIn1fn
         1FNygqH8miT2ND7kllWhBjjD9Wu+DQWhy56YqMQlGvwGa80tbIg+vMvE1UvifYdL9w
         gdee6Zd1z71Zw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Guchun Chen <guchun.chen@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>, Xinhui.Pan@amd.com,
        airlied@linux.ie, daniel@ffwll.ch, charlene.liu@amd.com,
        zhan.liu@amd.com, harry.wentland@amd.com, HaoPing.Liu@amd.com,
        jun.lei@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 070/105] drm/amdgpu: fix file permissions on some files
Date:   Thu, 11 Aug 2022 11:27:54 -0400
Message-Id: <20220811152851.1520029-70-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
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

