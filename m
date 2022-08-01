Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5805870B2
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 21:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbiHATCd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 15:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232741AbiHATCa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 15:02:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1F126568;
        Mon,  1 Aug 2022 12:02:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A9DDB81603;
        Mon,  1 Aug 2022 19:02:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB166C433B5;
        Mon,  1 Aug 2022 19:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659380546;
        bh=G6z55BCnM9EFXJvqKHhQOx84UM7dS+cHpqatbRvC6C8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FlYJmJaP2/KLA6AJAJvccr8Vv9s88ZpWq5fs/L00Rwv+2o67gdhrsDaJMhRiZQViC
         3I3HPNxP1HrF5u4hqfenDz5BFGk2gHbYQDL9b3tX/OERhXh/6CKcV/3S3B1JbH79z1
         mbWeCOuMWviuykn8FPQrpW0hXD7dcUHNzD9azsi9iOEFFMF/T02fnyxEzwwWSjMGdJ
         1422d3zuvJwuCZHNop0gxALfwfEr3eGtKv7Mcxo7a2iQyY9uQ8f3P4rcu1NPNU/+OB
         Avj/AII2iI3V9ErzFiquswawry4LXI9dMTtVLjgT6AaOhikzLZHo/rY2G888k7pCpm
         ggfnnU309ZGVw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     xinhui pan <xinhui.pan@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, Xinhui.Pan@amd.com,
        airlied@linux.ie, daniel@ffwll.ch, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.18 02/10] drm/amdgpu: Remove one duplicated ef removal
Date:   Mon,  1 Aug 2022 15:02:14 -0400
Message-Id: <20220801190222.3818378-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220801190222.3818378-1-sashal@kernel.org>
References: <20220801190222.3818378-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: xinhui pan <xinhui.pan@amd.com>

[ Upstream commit e1aadbab445b06e072013a1365fd0cf2aa25e843 ]

That has been done in BO release notify.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2074
Signed-off-by: xinhui pan <xinhui.pan@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index f4509656ea8c..e9a8eb070766 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1401,16 +1401,10 @@ void amdgpu_amdkfd_gpuvm_destroy_cb(struct amdgpu_device *adev,
 				    struct amdgpu_vm *vm)
 {
 	struct amdkfd_process_info *process_info = vm->process_info;
-	struct amdgpu_bo *pd = vm->root.bo;
 
 	if (!process_info)
 		return;
 
-	/* Release eviction fence from PD */
-	amdgpu_bo_reserve(pd, false);
-	amdgpu_bo_fence(pd, NULL, false);
-	amdgpu_bo_unreserve(pd);
-
 	/* Update process info */
 	mutex_lock(&process_info->lock);
 	process_info->n_vms--;
-- 
2.35.1

