Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C285A06BC
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 03:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235326AbiHYBnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 21:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234937AbiHYBmt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 21:42:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 759AC9AFBC;
        Wed, 24 Aug 2022 18:39:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEE9BB826E0;
        Thu, 25 Aug 2022 01:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76BAC433C1;
        Thu, 25 Aug 2022 01:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391545;
        bh=E0TlQQG75AR1bWOlBrS/FsccmN36OcRqbdY69d/jkME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=boZjYTFyLK5cT4Y07mtoDc9FpDz78g9hQk4zF9aYbUD5M0LDmeeYEIJrTfFSh2er7
         cXVoYczbzJrKOQAvgmgL2qzO0dljA48LSNcWUxdN3W7w+3OWbU+nJWgOMvDKBEXE/C
         v4aBTGLgA1NtG4EYQS4a7zKJ9dmSvQR7BZJaB7v/VSHyJFgllWvo7Ww3FBsk+QyQ8x
         1lJ6IJ+2ZEyDyENW3dg8046HExmsrTm99ftUOBPeWbvNjg/V4TaxRj/UB1mkZe8j5E
         WStVzoqbzTEg/9+FsrNtAVDIGFIYRMJ9n8m2Do/gMNnnS2fHui7WnFQuN42xzJpQ/h
         cSCVBxJVN0fcg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        lijo.lazar@amd.com, guchun.chen@amd.com, luben.tuikov@amd.com,
        sathishkumar.sundararaju@amd.com, danijel.slivka@amd.com,
        Mohammadzafar.ziya@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 06/11] drm/amd/pm: add missing ->fini_microcode interface for Sienna Cichlid
Date:   Wed, 24 Aug 2022 21:38:27 -0400
Message-Id: <20220825013836.23205-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220825013836.23205-1-sashal@kernel.org>
References: <20220825013836.23205-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit 0a2d922a5618377cdf8fa476351362733ef55342 ]

To avoid any potential memory leak.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index 8556c229ff59..49d7fa1d0842 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -2759,6 +2759,7 @@ static const struct pptable_funcs sienna_cichlid_ppt_funcs = {
 	.dump_pptable = sienna_cichlid_dump_pptable,
 	.init_microcode = smu_v11_0_init_microcode,
 	.load_microcode = smu_v11_0_load_microcode,
+	.fini_microcode = smu_v11_0_fini_microcode,
 	.init_smc_tables = sienna_cichlid_init_smc_tables,
 	.fini_smc_tables = smu_v11_0_fini_smc_tables,
 	.init_power = smu_v11_0_init_power,
-- 
2.35.1

