Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9627A1C7E18
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 01:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgEFXmW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 19:42:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728237AbgEFXmU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 May 2020 19:42:20 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6716D20735;
        Wed,  6 May 2020 23:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588808539;
        bh=qWFwYxWu+WrgDyHJfEd58XhfWlKT92sUdROUGTFaQfA=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=RSfMZMxoKjMj4WihxE4yE3mXY5dl2njcDLNBEidBKtEUK1XbxKu9gS1vT6waRYQK7
         2YtZbLdA0Nr1E6LkwIafbnb2kTp4ND4bNmMzFPNTJyiXi13ZuLjxSnr3ACACVl5ufG
         8zkoRX9vje2lzHIx1dl+h/I9EEb2/3pJFcmDLUJk=
Date:   Wed, 06 May 2020 23:42:18 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Jordan Crouse <jcrouse@codeaurora.org>
To:     linux-arm-msm@vger.kernel.org
Cc:     Eric Anholt <eric@anholt.net>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3] drm/msm: Check for powered down HW in the devfreq callbacks
In-Reply-To: <20200501194326.14593-1-jcrouse@codeaurora.org>
References: <20200501194326.14593-1-jcrouse@codeaurora.org>
Message-Id: <20200506234219.6716D20735@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.6.8, v5.4.36, v4.19.119, v4.14.177, v4.9.220, v4.4.220.

v5.6.8: Build OK!
v5.4.36: Build OK!
v4.19.119: Failed to apply! Possible dependencies:
    16f37102181e ("drm/msm: a6xx: Fix improper u64 division")
    a2c3c0a54d4c ("drm/msm/a6xx: Add devfreq support for a6xx")
    de0a3d094de0 ("drm/msm: re-factor devfreq code")
    f926a2e1718e ("drm/msm: a5xx: Fix improper u64 division")
    fcf9d0b7d2f5 ("drm/msm/a6xx: Add support for an interconnect path")

v4.14.177: Failed to apply! Possible dependencies:
    4c7085a5d581 ("drm/msm: Shadow current pointer in the ring until command is complete")
    b1fc2839d2f9 ("drm/msm: Implement preemption for A5XX targets")
    c09513cfebd8 ("drm/msm/adreno: a5xx: Explicitly program the CP0 performance counter")
    cd414f3d9316 ("drm/msm: Move memptrs to msm_gpu")
    eec874ce5ff1 ("drm/msm/adreno: load gpu at probe/bind time")
    f7de15450e90 ("drm/msm: Add per-instance submit queues")
    f91c14ab448a ("drm/msm: Add devfreq support for the GPU")
    f97decac5f4c ("drm/msm: Support multiple ringbuffers")

v4.9.220: Failed to apply! Possible dependencies:
    1cec20f0ea0e ("dma-buf: Restart reservation_object_wait_timeout_rcu() after writes")
    667ce33e57d0 ("drm/msm: support multiple address spaces")
    78010cd9736e ("dma-buf/fence: add an lockdep_assert_held()")
    89d777a57245 ("drm/msm: Remove 'src_clk' from adreno configuration")
    b5f103ab98c7 ("drm/msm: gpu: Add A5XX target support")
    c09513cfebd8 ("drm/msm/adreno: a5xx: Explicitly program the CP0 performance counter")
    f54d1867005c ("dma-buf: Rename struct fence to dma_fence")
    f91c14ab448a ("drm/msm: Add devfreq support for the GPU")
    fb0399819239 ("drm/msm: Add adreno_gpu_write64()")
    fedf54132d24 ("dma-buf: Restart reservation_object_get_fences_rcu() after writes")

v4.4.220: Failed to apply! Possible dependencies:
    1aaa57f5d4b6 ("drm/msm: Free fb helper resources in msm_unload")
    1dd0a0b18697 ("drm/msm/mdp5: Create a separate MDP5 device")
    2b669875332f ("drm/msm: Drop load/unload drm_driver ops")
    357ff00b08d6 ("drm/msm/adreno: support for adreno 430.")
    667ce33e57d0 ("drm/msm: support multiple address spaces")
    7d0c5ee9f077 ("drm/msm/adreno: get CP_RPTR from register instead of shadow memory")
    8208ed931eea ("drm/msm: Centralize connector registration/unregistration")
    89d777a57245 ("drm/msm: Remove 'src_clk' from adreno configuration")
    990a40079a55 ("drm/msm/mdp5: Add MDSS top level driver")
    a2b3a5571f38 ("drm/msm: Get irq number within kms driver itself")
    a3ccfb9feb46 ("drm/msm: Rename async to nonblock.")
    a5725ab0497a ("drm/msm/adreno: move function declarations to header file")
    b5f103ab98c7 ("drm/msm: gpu: Add A5XX target support")
    ba00c3f2f0c8 ("drm/msm: remove fence_cbs")
    c09513cfebd8 ("drm/msm/adreno: a5xx: Explicitly program the CP0 performance counter")
    ca762a8ae7f4 ("drm/msm: introduce msm_fence_context")
    cd79272696ef ("drm/msm: Call pm_runtime_enable/disable for newly created devices")
    edcd60ce243d ("drm/msm: move debugfs code to it's own file")
    f759020530e8 ("drm/msm/mdp: Detach iommu in mdp4_destroy")
    f91c14ab448a ("drm/msm: Add devfreq support for the GPU")
    fb0399819239 ("drm/msm: Add adreno_gpu_write64()")
    fde5de6cb461 ("drm/msm: move fence code to it's own file")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
