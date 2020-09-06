Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A874B25EC4A
	for <lists+stable@lfdr.de>; Sun,  6 Sep 2020 05:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbgIFDQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Sep 2020 23:16:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:54448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728491AbgIFDQL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Sep 2020 23:16:11 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BECF62137B;
        Sun,  6 Sep 2020 03:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599362170;
        bh=YGVlrMA1Ai8Gybc+0vWgFweTUB1UYvieny0REuWIywE=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=IFStoF9Hv0TnAnT6Kyc4oDVh1UUOIKc/ugYNsRODmhRzYJ8HDKV/KvXlBD/XGHMhR
         bMAqBQwrh0NNosBUin7pL/M+SGV39S458ikmVcF0ZBxsXVwu+mMsDrD1S+Z/mtfEoH
         +O66HCthvJr3CXQM84lV5KP615ym9UA8ePc3ajRg=
Date:   Sun, 06 Sep 2020 03:16:10 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Jordan Crouse <jcrouse@codeaurora.org>
To:     linux-arm-msm@vger.kernel.org
Cc:     stable@vger.kernel.org, Daniel Vetter <daniel@ffwll.ch>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/4] drm/msm: Split the a5xx preemption record
In-Reply-To: <20200904020313.1810988-2-jcrouse@codeaurora.org>
References: <20200904020313.1810988-2-jcrouse@codeaurora.org>
Message-Id: <20200906031610.BECF62137B@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.8.6, v5.4.62, v4.19.143, v4.14.196, v4.9.235, v4.4.235.

v5.8.6: Build OK!
v5.4.62: Build failed! Errors:
    drivers/gpu/drm/msm/adreno/a5xx_preempt.c:235:21: error: 'MSM_BO_MAP_PRIV' undeclared (first use in this function); did you mean 'MSM_BO_CACHED'?

v4.19.143: Failed to apply! Possible dependencies:
    0815d7749a68 ("drm/msm: Add a name field for gem objects")
    1e29dff00400 ("drm/msm: Add a common function to free kernel buffer objects")
    64686886bbff ("drm/msm: Replace drm_gem_object_{un/reference} with put, get functions")
    6a41da17e87d ("drm: msm: Use DRM_DEV_* instead of dev_*")
    c97ea6a61b5e ("drm: msm: adreno: Use PTR_ERR_OR_ZERO rather than if(IS_ERR(...)) +PTR_ERR")
    df0dff132905 ("drm/msm/a6xx: Poll for HFI responses")
    f384d7d514d1 ("drm: Convert to using %pOFn instead of device_node.name")
    feb085ec8a3d ("drm/msm: dsi: Return errors whan dt parsing fails")

v4.14.196: Failed to apply! Possible dependencies:
    b1fc2839d2f9 ("drm/msm: Implement preemption for A5XX targets")
    cd414f3d9316 ("drm/msm: Move memptrs to msm_gpu")
    e8f3de96a9d3 ("drm/msm/adreno: split out helper to load fw")
    eec874ce5ff1 ("drm/msm/adreno: load gpu at probe/bind time")
    f7de15450e90 ("drm/msm: Add per-instance submit queues")
    f97decac5f4c ("drm/msm: Support multiple ringbuffers")

v4.9.235: Failed to apply! Possible dependencies:
    1cec20f0ea0e ("dma-buf: Restart reservation_object_wait_timeout_rcu() after writes")
    667ce33e57d0 ("drm/msm: support multiple address spaces")
    78010cd9736e ("dma-buf/fence: add an lockdep_assert_held()")
    89d777a57245 ("drm/msm: Remove 'src_clk' from adreno configuration")
    b1fc2839d2f9 ("drm/msm: Implement preemption for A5XX targets")
    b5f103ab98c7 ("drm/msm: gpu: Add A5XX target support")
    f54d1867005c ("dma-buf: Rename struct fence to dma_fence")
    fb0399819239 ("drm/msm: Add adreno_gpu_write64()")
    fedf54132d24 ("dma-buf: Restart reservation_object_get_fences_rcu() after writes")

v4.4.235: Failed to apply! Possible dependencies:
    01c8f1c44b83 ("mm, dax, gpu: convert vm_insert_mixed to pfn_t")
    0caeef63e6d2 ("libnvdimm: Add a poison list and export badblocks")
    0e749e54244e ("dax: increase granularity of dax_clear_blocks() operations")
    34c0fd540e79 ("mm, dax, pmem: introduce pfn_t")
    357ff00b08d6 ("drm/msm/adreno: support for adreno 430.")
    52db400fcd50 ("pmem, dax: clean up clear_pmem()")
    667ce33e57d0 ("drm/msm: support multiple address spaces")
    68209390f116 ("drm/msm: shrinker support")
    7d0c5ee9f077 ("drm/msm/adreno: get CP_RPTR from register instead of shadow memory")
    87ba05dff351 ("libnvdimm: don't fail init for full badblocks list")
    89d777a57245 ("drm/msm: Remove 'src_clk' from adreno configuration")
    a5725ab0497a ("drm/msm/adreno: move function declarations to header file")
    b1fc2839d2f9 ("drm/msm: Implement preemption for A5XX targets")
    b2e0d1625e19 ("dax: fix lifetime of in-kernel dax mappings with dax_map_atomic()")
    b5f103ab98c7 ("drm/msm: gpu: Add A5XX target support")
    b95f5f4391fa ("libnvdimm: convert to statically allocated badblocks")
    edcd60ce243d ("drm/msm: move debugfs code to it's own file")
    fb0399819239 ("drm/msm: Add adreno_gpu_write64()")
    fde5de6cb461 ("drm/msm: move fence code to it's own file")
    fe683adabfe6 ("dax: guarantee page aligned results from bdev_direct_access()")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
