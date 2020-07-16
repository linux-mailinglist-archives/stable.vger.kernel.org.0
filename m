Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF7D2218D9
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 02:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgGPA1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 20:27:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:54794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726770AbgGPA1j (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jul 2020 20:27:39 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A72320787;
        Thu, 16 Jul 2020 00:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594859258;
        bh=byFO9gItVELygOKCPDEq4IMrcBxDNLN8suiUyPYGC6A=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=U4Z6UGAuG4dJhQYVBA4nmXr01MeQtWyYS2UT3Uh10rESBySQ7XQiCy2+oz2uLL4s9
         EHWyT1XUmLYNzd6WJy4t6eNrQklJoOjBO2T4nfA+r7vb+S8HP5hpJuYa7pP5ZPt0sk
         r5hAFo9epX/z+zMORCIC54s5qHqSX9hHWfTd2fLw=
Date:   Thu, 16 Jul 2020 00:27:37 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
To:     hersen wu <hersenxs.wu@amd.com>
To:     amd-gfx@lists.freedesktop.org
Cc:     Harry.Wentland@amd.com, Sunpeng.Li@amd.com
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 04/10] drm/amd/display: OLED panel backlight adjust not work with external display connected
In-Reply-To: <20200710203325.1097188-5-Rodrigo.Siqueira@amd.com>
References: <20200710203325.1097188-5-Rodrigo.Siqueira@amd.com>
Message-Id: <20200716002738.6A72320787@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.7.8, v5.4.51, v4.19.132, v4.14.188, v4.9.230, v4.4.230.

v5.7.8: Build OK!
v5.4.51: Failed to apply! Possible dependencies:
    945628101be55 ("drm/amd/display: Add backlight support via AUX")

v4.19.132: Failed to apply! Possible dependencies:
    0cafc82fae415 ("drm/amd/display: set backlight level limit to 1")
    11c3ee48bd7c2 ("drm/amdgpu/display: add support for LVDS (v5)")
    1e7e86c43f38d ("drm/amd/display: decouple front and backend pgm using dpms_off as backend enable flag")
    206bbafe00dca ("drm/amd: Query and use ACPI backlight caps")
    262485a50fd45 ("drm/amd/display: Expand dc to use 16.16 bit backlight")
    694d0775ca94b ("drm/amd: Don't fail on backlight = 0")
    8c3db1284a016 ("drm/amdgpu: fill in amdgpu_dm_remove_sink_from_freesync_module")
    945628101be55 ("drm/amd/display: Add backlight support via AUX")
    98e6436d3af5f ("drm/amd/display: Refactor FreeSync module")
    aa9c4abe466ac ("drm/amd/display: Refactor FPGA-specific link setup")

v4.14.188: Failed to apply! Possible dependencies:
    1b0c0f9dc5ca6 ("drm/amdgpu: move userptr BOs to CPU domain during CS v2")
    1ed3d2567c800 ("drm/amdgpu: keep the MMU lock until the update ends v4")
    3fe89771cb0a6 ("drm/amdgpu: stop reserving the BO in the MMU callback v3")
    4562236b3bc0a ("drm/amd/dc: Add dc display driver (v2)")
    60de1c1740f39 ("drm/amdgpu: use a rw_semaphore for MMU notifiers")
    945628101be55 ("drm/amd/display: Add backlight support via AUX")
    9a18999640fa6 ("drm/amdgpu: move MMU notifier related defines to amdgpu_mn.h")
    9cca0b8e5df0a ("drm/amdgpu: move amdgpu_cs_sysvm_access_required into find_mapping")
    a216ab09955d6 ("drm/amdgpu: fix userptr put_page handling")
    b72cf4fca2bb7 ("drm/amdgpu: move taking mmap_sem into get_user_pages v2")
    ca666a3c298f8 ("drm/amdgpu: stop using BO status for user pages")

v4.9.230: Failed to apply! Possible dependencies:
    1cec20f0ea0e3 ("dma-buf: Restart reservation_object_wait_timeout_rcu() after writes")
    3fe89771cb0a6 ("drm/amdgpu: stop reserving the BO in the MMU callback v3")
    4562236b3bc0a ("drm/amd/dc: Add dc display driver (v2)")
    4df654d293c64 ("drm/amdgpu: move amdgpu_uvd structure to uvd header")
    5e5681788befb ("drm/amdgpu: move amdgpu_vce structure to vce header")
    660e855813f78 ("amdgpu: use drm sync objects for shared semaphores (v6)")
    78010cd9736ec ("dma-buf/fence: add an lockdep_assert_held()")
    945628101be55 ("drm/amd/display: Add backlight support via AUX")
    95aa13f6b196d ("drm/amdgpu: move amdgpu_vcn structure to vcn header")
    95d0906f85065 ("drm/amdgpu: add initial vcn support and decode tests")
    9a18999640fa6 ("drm/amdgpu: move MMU notifier related defines to amdgpu_mn.h")
    b636922553ee2 ("drm/amdgpu: only move VM BOs in the LRU during validation v2")
    b72cf4fca2bb7 ("drm/amdgpu: move taking mmap_sem into get_user_pages v2")
    f54d1867005c3 ("dma-buf: Rename struct fence to dma_fence")
    fedf54132d241 ("dma-buf: Restart reservation_object_get_fences_rcu() after writes")

v4.4.230: Failed to apply! Possible dependencies:
    1f7371b2a5faf ("drm/amd/powerplay: add basic powerplay framework")
    288912cb95d15 ("drm/amdgpu: use $(src) in Makefile (v2)")
    37cd0ca204a55 ("drm/amdgpu: unify AMDGPU_CTX_MAX_CS_PENDING and amdgpu_sched_jobs")
    3c0eea6c35d93 ("drm/amdgpu: put VM page tables directly into duplicates list")
    3f99dd814a6fd ("drm/amdgpu: save and restore UVD context with suspend and resume")
    4325198180e5a ("drm/amdgpu: remove GART page addr array")
    4562236b3bc0a ("drm/amd/dc: Add dc display driver (v2)")
    4acabfe3793eb ("drm/amdgpu: fix num_ibs check")
    4df654d293c64 ("drm/amdgpu: move amdgpu_uvd structure to uvd header")
    50838c8cc413d ("drm/amdgpu: add proper job alloc/free functions")
    56467ebfb2548 ("drm/amdgpu: split VM PD and PT handling during CS")
    5e5681788befb ("drm/amdgpu: move amdgpu_vce structure to vce header")
    7270f8391df1a ("drm/amdgpu: add amdgpu_set_ib_value helper (v2)")
    945628101be55 ("drm/amd/display: Add backlight support via AUX")
    95aa13f6b196d ("drm/amdgpu: move amdgpu_vcn structure to vcn header")
    9a18999640fa6 ("drm/amdgpu: move MMU notifier related defines to amdgpu_mn.h")
    a1d29476d666f ("drm/amdgpu: optionally enable GART debugfs file")
    a8fe58cec351c ("drm/amd: add ACP driver support")
    c036554170fcc ("drm/amdgpu: handle more than 10 UVD sessions (v2)")
    c3cca41e6249e ("drm/amdgpu: cleanup amdgpu_cs_parser structure")
    cadf97b196a1e ("drm/amdgpu: clean up non-scheduler code path (v2)")
    cd75dc6887f1e ("drm/amdgpu: separate pushing CS to scheduler")
    d71518b5aa7c9 ("drm/amdgpu: cleanup in kernel job submission")
    d7af97dbccf01 ("drm/amdgpu: send UVD IB tests directly to the ring again")
    d8e0cae645504 ("drm/amdgpu: validate duplicates first")
    f69f90a113f28 ("drm/amdgpu: fix amdgpu_cs_get_threshold_for_moves handling")
    fdba11f4079ec ("drm/amdgpu: move all Kconfig options to amdgpu/Kconfig")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
