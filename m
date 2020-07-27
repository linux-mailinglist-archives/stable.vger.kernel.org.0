Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D9822FB46
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 23:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgG0VYi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 17:24:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgG0VYh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 17:24:37 -0400
Received: from localhost (unknown [13.85.75.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED77F20838;
        Mon, 27 Jul 2020 21:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595885077;
        bh=CI0zaCVXtCwm6kl4vbxepT61HWBSJwnzXur6ko1kHrM=;
        h=Date:From:To:To:To:To:CC:CC:Cc:Subject:In-Reply-To:References:
         From;
        b=Y+/uxdL/0w3G+CeBSah3MaUdlTAK4mK9ygatH4eKj5J43phQktsj/IbN40NIGfv9i
         g8+cv+X83a+zraTSQHZyUp2PsV7u3VeVfQSdiqcInBZiGUgbKeK5dR3CeIjyyXftXr
         99vBY3f56kUzHmpgpaRpDyyLbJL6vjtSWLmGZNHY=
Date:   Mon, 27 Jul 2020 21:24:36 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Eryk Brol <eryk.brol@amd.com>
To:     hersen wu <hersenxs.wu@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>
CC:     Stable <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 11/15] drm/amd/display: dchubbub p-state warning during surface planes switch
In-Reply-To: <20200724210618.2709738-12-eryk.brol@amd.com>
References: <20200724210618.2709738-12-eryk.brol@amd.com>
Message-Id: <20200727212436.ED77F20838@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.7.10, v5.4.53, v4.19.134, v4.14.189, v4.9.231, v4.4.231.

v5.7.10: Build OK!
v5.4.53: Build OK!
v4.19.134: Failed to apply! Possible dependencies:
    1e7e86c43f38 ("drm/amd/display: decouple front and backend pgm using dpms_off as backend enable flag")
    24f7dd7ea98d ("drm/amd/display: move pplib/smu notification to dccg block")
    4c5e8b541527 ("drm/amd/display: split dccg clock manager into asic folders")
    8c3db1284a01 ("drm/amdgpu: fill in amdgpu_dm_remove_sink_from_freesync_module")
    98e6436d3af5 ("drm/amd/display: Refactor FreeSync module")
    ad908423ef86 ("drm/amd/display: support 48 MHZ refclk off")
    c85e6e546edd ("drm/amd/display: Create new i2c resource")

v4.14.189: Failed to apply! Possible dependencies:
    1b0c0f9dc5ca ("drm/amdgpu: move userptr BOs to CPU domain during CS v2")
    1ed3d2567c80 ("drm/amdgpu: keep the MMU lock until the update ends v4")
    3fe89771cb0a ("drm/amdgpu: stop reserving the BO in the MMU callback v3")
    4562236b3bc0 ("drm/amd/dc: Add dc display driver (v2)")
    4c5e8b541527 ("drm/amd/display: split dccg clock manager into asic folders")
    60de1c1740f3 ("drm/amdgpu: use a rw_semaphore for MMU notifiers")
    9a18999640fa ("drm/amdgpu: move MMU notifier related defines to amdgpu_mn.h")
    9cca0b8e5df0 ("drm/amdgpu: move amdgpu_cs_sysvm_access_required into find_mapping")
    a216ab09955d ("drm/amdgpu: fix userptr put_page handling")
    b72cf4fca2bb ("drm/amdgpu: move taking mmap_sem into get_user_pages v2")
    ca666a3c298f ("drm/amdgpu: stop using BO status for user pages")

v4.9.231: Failed to apply! Possible dependencies:
    1cec20f0ea0e ("dma-buf: Restart reservation_object_wait_timeout_rcu() after writes")
    248a1d6f1ac4 ("drm/amd: fix include notation and remove -Iinclude/drm flag")
    4562236b3bc0 ("drm/amd/dc: Add dc display driver (v2)")
    4c5e8b541527 ("drm/amd/display: split dccg clock manager into asic folders")
    78010cd9736e ("dma-buf/fence: add an lockdep_assert_held()")
    f54d1867005c ("dma-buf: Rename struct fence to dma_fence")
    fedf54132d24 ("dma-buf: Restart reservation_object_get_fences_rcu() after writes")

v4.4.231: Failed to apply! Possible dependencies:
    0f477c6dea70 ("staging/android/sync: add sync_fence_create_dma")
    1f7371b2a5fa ("drm/amd/powerplay: add basic powerplay framework")
    248a1d6f1ac4 ("drm/amd: fix include notation and remove -Iinclude/drm flag")
    288912cb95d1 ("drm/amdgpu: use $(src) in Makefile (v2)")
    375fb53ec1be ("staging: android: replace explicit NULL comparison")
    395dec6f6bc5 ("Documentation: add doc for sync_file_get_fence()")
    4325198180e5 ("drm/amdgpu: remove GART page addr array")
    4562236b3bc0 ("drm/amd/dc: Add dc display driver (v2)")
    4c5e8b541527 ("drm/amd/display: split dccg clock manager into asic folders")
    62304fb1fc08 ("dma-buf/sync_file: de-stage sync_file")
    a1d29476d666 ("drm/amdgpu: optionally enable GART debugfs file")
    a8fe58cec351 ("drm/amd: add ACP driver support")
    b70f014d58b9 ("drm/amdgpu: change default sched jobs to 32")
    c784c82a3fd6 ("Documentation: add Sync File doc")
    d4cab38e153d ("staging/android: prepare sync_file for de-staging")
    d7fdb0ae9d11 ("staging/android: rename sync_fence to sync_file")
    f54d1867005c ("dma-buf: Rename struct fence to dma_fence")
    fac8434dab96 ("Documentation: Fix some grammar mistakes in sync_file.txt")
    fdba11f4079e ("drm/amdgpu: move all Kconfig options to amdgpu/Kconfig")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
