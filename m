Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B149C5A69E5
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbiH3RYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbiH3RYB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:24:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA51114FCB9;
        Tue, 30 Aug 2022 10:21:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CBCBB81D17;
        Tue, 30 Aug 2022 17:21:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0727C433C1;
        Tue, 30 Aug 2022 17:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661880095;
        bh=Yqxdf40p+eJDpXpCuGnwjuEkWmXRdjLdXOKmqXAAtIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iDsW7Ueja1xJnsh96iUplKVxt1HT1/71Je8rNCfW82fLYUm+SmOe2vFKneZYJrCwq
         r6s/gQCtEueC5XjO1MSh/AShZU2mA0GEegjdGed1PqrZA+LFiiKd78oVJJScBX21Er
         yCUa4SVhh9rngdhjExD+msGOSyEXazsG+bJ9gP+zXf5no94EiUgX910p9A5W9NyexD
         xbevIPSCrIAa6z7bM/jMmQkW8SyXyveRbylQuHv+PgzXX0lIMkoLD2lWp3hW/sLkVg
         wdae3aMAxgsEKtcItWilYjdPhHvPRCGbWdnm2nA72G8aFd/Jbc5ml0k2IykArTf+1j
         gRafwwDc8XRaw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Huang <jinsdb@126.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        Hawking.Zhang@amd.com, evan.quan@amd.com, guchun.chen@amd.com,
        mario.limonciello@amd.com, YiPeng.Chai@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 33/33] drm/amdgpu: mmVM_L2_CNTL3 register not initialized correctly
Date:   Tue, 30 Aug 2022 13:18:24 -0400
Message-Id: <20220830171825.580603-33-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830171825.580603-1-sashal@kernel.org>
References: <20220830171825.580603-1-sashal@kernel.org>
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

From: Qu Huang <jinsdb@126.com>

[ Upstream commit b8983d42524f10ac6bf35bbce6a7cc8e45f61e04 ]

The mmVM_L2_CNTL3 register is not assigned an initial value

Signed-off-by: Qu Huang <jinsdb@126.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c b/drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c
index 3f44a099c52a4..3e51e773f92be 100644
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c
@@ -176,6 +176,7 @@ static void mmhub_v1_0_init_cache_regs(struct amdgpu_device *adev)
 	tmp = REG_SET_FIELD(tmp, VM_L2_CNTL2, INVALIDATE_L2_CACHE, 1);
 	WREG32_SOC15(MMHUB, 0, mmVM_L2_CNTL2, tmp);
 
+	tmp = mmVM_L2_CNTL3_DEFAULT;
 	if (adev->gmc.translate_further) {
 		tmp = REG_SET_FIELD(tmp, VM_L2_CNTL3, BANK_SELECT, 12);
 		tmp = REG_SET_FIELD(tmp, VM_L2_CNTL3,
-- 
2.35.1

