Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866912218D4
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 02:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbgGPA1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 20:27:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726796AbgGPA1c (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jul 2020 20:27:32 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3260C2071B;
        Thu, 16 Jul 2020 00:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594859251;
        bh=Q5UlqIA1A3qRPR75tCHh5CuH2UD4bFglVu0IacBATqc=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=ZLuU0jkQwsJ0uMnHbFI37tXt6UjghbgqwkWSZOxbHhavogPDZztcRDwUU0jKuB1CL
         uQf/axZ9BVgWyDwhfd7lUWWGqEwG4I6eV59w5xUBtUDHtcjU/ryupJ0FKQb42Ns3+6
         InfKTXlCPsgBul0lLHcoi6Rf8piWcF6PBWPXHQvA=
Date:   Thu, 16 Jul 2020 00:27:30 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
To:     Josip Pavic <Josip.Pavic@amd.com>
To:     amd-gfx@lists.freedesktop.org
Cc:     Harry.Wentland@amd.com, Sunpeng.Li@amd.com
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 10/10] drm/amd/display: handle failed allocation during stream construction
In-Reply-To: <20200710203325.1097188-11-Rodrigo.Siqueira@amd.com>
References: <20200710203325.1097188-11-Rodrigo.Siqueira@amd.com>
Message-Id: <20200716002731.3260C2071B@mail.kernel.org>
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
    d9e32672a1285 ("drm/amd/display: cleanup of construct and destruct funcs")

v4.19.132: Failed to apply! Possible dependencies:
    0e3d73f1a440e ("drm/amd/display: Add Raven2 definitions in dc")
    1e7e86c43f38d ("drm/amd/display: decouple front and backend pgm using dpms_off as backend enable flag")
    21e471f0850de ("drm/amd/display: Set dispclk and dprefclock directly")
    24f7dd7ea98dc ("drm/amd/display: move pplib/smu notification to dccg block")
    4e60536d093f4 ("drm/amd/display: Set DFS bypass flags for dce110")
    5a83c93249098 ("drm/amd/display: Add support for toggling DFS bypass")
    76d981a9fe823 ("Revert "drm/amd/display: make clk_mgr call enable_pme_wa"")
    7ed4e6352c16f ("drm/amd/display: Add DCN2 HW Sequencer and Resource")
    84e7fc05a9270 ("drm/amd/display: rename dccg to clk_mgr")
    8c3db1284a016 ("drm/amdgpu: fill in amdgpu_dm_remove_sink_from_freesync_module")
    98e6436d3af5f ("drm/amd/display: Refactor FreeSync module")
    ad908423ef86f ("drm/amd/display: support 48 MHZ refclk off")
    d9673c920c035 ("drm/amd/display: Pass init_data into DCN resource creation")
    d9e32672a1285 ("drm/amd/display: cleanup of construct and destruct funcs")

v4.14.188: Failed to apply! Possible dependencies:
    1b0c0f9dc5ca6 ("drm/amdgpu: move userptr BOs to CPU domain during CS v2")
    1ed3d2567c800 ("drm/amdgpu: keep the MMU lock until the update ends v4")
    3fe89771cb0a6 ("drm/amdgpu: stop reserving the BO in the MMU callback v3")
    4562236b3bc0a ("drm/amd/dc: Add dc display driver (v2)")
    60de1c1740f39 ("drm/amdgpu: use a rw_semaphore for MMU notifiers")
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
