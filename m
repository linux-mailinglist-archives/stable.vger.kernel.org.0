Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05799243D4F
	for <lists+stable@lfdr.de>; Thu, 13 Aug 2020 18:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgHMQZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Aug 2020 12:25:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbgHMQZ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Aug 2020 12:25:56 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5110620829;
        Thu, 13 Aug 2020 16:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597335955;
        bh=BrWIA8LbofHC/W5LvZOxcVqlPpjNUl/zzmxJouyT9NM=;
        h=Date:From:To:To:To:To:CC:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=z01IZLiuZfytwyh/ZEiU4MHEKrRltyB2cW8cCLE1FIr1OjtbGWFUIiuqKbqzYETo5
         koJdQperaPb0uHhF7pfU5tl+iUqG8j32PsF8DTnNEbCbgMw+33RDEFh3BgvUIiV8lh
         d4yOIVCt53TclbUnfYjT7nA/Y6nyZPXRFD+pW1ac=
Date:   Thu, 13 Aug 2020 16:25:54 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Qingqing Zhuo <qingqing.zhuo@amd.com>
To:     Aric Cyr <aric.cyr@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 2/9] drm/amd/display: Fix incorrect backlight register offset for DCN
In-Reply-To: <20200805174058.11736-3-qingqing.zhuo@amd.com>
References: <20200805174058.11736-3-qingqing.zhuo@amd.com>
Message-Id: <20200813162555.5110620829@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.8, v5.7.14, v5.4.57, v4.19.138, v4.14.193, v4.9.232, v4.4.232.

v5.8: Build OK!
v5.7.14: Failed to apply! Possible dependencies:
    16012806e697 ("drm/amd/display: Add ABM driver implementation")
    904fb6e0f4e8 ("drm/amd/display: move panel power seq to new panel struct")
    9ec420d83341 ("drm/amd/display: code cleanup of dc_link file on func dc_link_construct")
    d1ebfdd8d0fc ("drm/amd/display: Unify psr feature flags")
    d4caa72e275c ("drm/amd/display: change from panel to panel cntl")
    efc3ec87a937 ("drm/amd/display: Remove unused defines")
    fe8db3bcf2e5 ("drm/amd/display: query hdcp capability during link detect")

v5.4.57: Failed to apply! Possible dependencies:
    2b77dcc5e5aa ("drm/amd/display: rename core_dc to dc")
    48af9b91b129 ("drm/amd/display: Don't allocate payloads if link lost")
    4c1a1335dfe0 ("drm/amd/display: Driverside changes to support PSR in DMCUB")
    7f7652ee8c8c ("drm/amd/display: enable single dp seamless boot")
    9ae1b27f31d0 ("drm/amd/display: fix hotplug during display off")
    9dac88d8792a ("drm/amd/display: Add driver support for enabling PSR on DMCUB")
    ab4a4072f260 ("drm/amd/display: exit PSR during detection")
    d4252eee1f7c ("drm/amd/display: Add debugfs entry to force YUV420 output")
    d462fcf5012b ("drm/amd/display: Update hdcp display config")
    d4caa72e275c ("drm/amd/display: change from panel to panel cntl")
    e0d08a40a63b ("drm/amd/display: Add debugfs entry for reading psr state")
    e78a312f81c8 ("drm/amd/display: use requested_dispclk_khz instead of clk")
    ef5a7d266e82 ("drm/amd/display: skip enable stream on disconnected display")

v4.19.138: Failed to apply! Possible dependencies:
    1f6010a96273 ("drm/amd/display: Improve spelling, grammar, and formatting of amdgpu_dm.c comments")
    813d20dccf93 ("drm/amd/display: Fix multi-thread writing to 1 state")
    8c3db1284a01 ("drm/amdgpu: fill in amdgpu_dm_remove_sink_from_freesync_module")
    98e6436d3af5 ("drm/amd/display: Refactor FreeSync module")
    a87fa9938749 ("drm/amd/display: Build stream update and plane updates in dm")
    a94d5569b232 ("drm/amd: Add DM DMCU support")
    b8592b48450b ("drm/amd/display: Initial documentation for AMDgpu DC")
    d4caa72e275c ("drm/amd/display: change from panel to panel cntl")
    dc88b4a684d2 ("drm/amd/display: make clk mgr soc specific")
    eb3dc8978596 ("drm/amd/display: Use private obj helpers for dm_atomic_state")

v4.14.193: Failed to apply! Possible dependencies:
    1296423bf23c ("drm/amd/display: define DC_LOGGER for logger")
    1b0c0f9dc5ca ("drm/amdgpu: move userptr BOs to CPU domain during CS v2")
    3fe89771cb0a ("drm/amdgpu: stop reserving the BO in the MMU callback v3")
    4562236b3bc0 ("drm/amd/dc: Add dc display driver (v2)")
    60de1c1740f3 ("drm/amdgpu: use a rw_semaphore for MMU notifiers")
    74c49c7ac14f ("drm/amdgpu/display: Add calcs code for DCN")
    9a18999640fa ("drm/amdgpu: move MMU notifier related defines to amdgpu_mn.h")
    9cca0b8e5df0 ("drm/amdgpu: move amdgpu_cs_sysvm_access_required into find_mapping")
    a216ab09955d ("drm/amdgpu: fix userptr put_page handling")
    b72cf4fca2bb ("drm/amdgpu: move taking mmap_sem into get_user_pages v2")
    ca666a3c298f ("drm/amdgpu: stop using BO status for user pages")
    d4caa72e275c ("drm/amd/display: change from panel to panel cntl")
    dc88b4a684d2 ("drm/amd/display: make clk mgr soc specific")
    f3efec54ed6a ("drm/amd/display: Allow option to use worst-case watermark")

v4.9.232: Failed to apply! Possible dependencies:
    1296423bf23c ("drm/amd/display: define DC_LOGGER for logger")
    1cec20f0ea0e ("dma-buf: Restart reservation_object_wait_timeout_rcu() after writes")
    248a1d6f1ac4 ("drm/amd: fix include notation and remove -Iinclude/drm flag")
    4562236b3bc0 ("drm/amd/dc: Add dc display driver (v2)")
    74c49c7ac14f ("drm/amdgpu/display: Add calcs code for DCN")
    78010cd9736e ("dma-buf/fence: add an lockdep_assert_held()")
    d4caa72e275c ("drm/amd/display: change from panel to panel cntl")
    dc88b4a684d2 ("drm/amd/display: make clk mgr soc specific")
    f3efec54ed6a ("drm/amd/display: Allow option to use worst-case watermark")
    f54d1867005c ("dma-buf: Rename struct fence to dma_fence")
    fedf54132d24 ("dma-buf: Restart reservation_object_get_fences_rcu() after writes")

v4.4.232: Failed to apply! Possible dependencies:
    0f477c6dea70 ("staging/android/sync: add sync_fence_create_dma")
    1296423bf23c ("drm/amd/display: define DC_LOGGER for logger")
    1f7371b2a5fa ("drm/amd/powerplay: add basic powerplay framework")
    248a1d6f1ac4 ("drm/amd: fix include notation and remove -Iinclude/drm flag")
    288912cb95d1 ("drm/amdgpu: use $(src) in Makefile (v2)")
    375fb53ec1be ("staging: android: replace explicit NULL comparison")
    395dec6f6bc5 ("Documentation: add doc for sync_file_get_fence()")
    4325198180e5 ("drm/amdgpu: remove GART page addr array")
    4562236b3bc0 ("drm/amd/dc: Add dc display driver (v2)")
    62304fb1fc08 ("dma-buf/sync_file: de-stage sync_file")
    74c49c7ac14f ("drm/amdgpu/display: Add calcs code for DCN")
    a1d29476d666 ("drm/amdgpu: optionally enable GART debugfs file")
    a8fe58cec351 ("drm/amd: add ACP driver support")
    b70f014d58b9 ("drm/amdgpu: change default sched jobs to 32")
    c784c82a3fd6 ("Documentation: add Sync File doc")
    d4caa72e275c ("drm/amd/display: change from panel to panel cntl")
    d4cab38e153d ("staging/android: prepare sync_file for de-staging")
    d7fdb0ae9d11 ("staging/android: rename sync_fence to sync_file")
    dc88b4a684d2 ("drm/amd/display: make clk mgr soc specific")
    f3efec54ed6a ("drm/amd/display: Allow option to use worst-case watermark")
    f54d1867005c ("dma-buf: Rename struct fence to dma_fence")
    fac8434dab96 ("Documentation: Fix some grammar mistakes in sync_file.txt")
    fdba11f4079e ("drm/amdgpu: move all Kconfig options to amdgpu/Kconfig")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
