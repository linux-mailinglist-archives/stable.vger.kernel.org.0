Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D94A25FCAA
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 17:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730095AbgIGPJy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 11:09:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730122AbgIGPDu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Sep 2020 11:03:50 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0D6A21775;
        Mon,  7 Sep 2020 15:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599491023;
        bh=grkG3Lt8o9eJoyFPJVtSmu5jce8oOV24tmOW7iBh82A=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=aBKoL9HyS6Uu+/IOP8r2UT4Jhf8y9PfKFcDldM9JThw8y5TXqgzORVfsQ/xi4TSxz
         cpL+f1Do+lGrwfH4adqkh/dCd9EF3eARI7aURRu8UJJBEkqW4fkiDPnaIHHdo05f10
         rNTDtAoRunRVgCTgrw+yVEuEvMFbM/Mqzr9b6YnA=
Date:   Mon, 07 Sep 2020 15:03:42 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
To:     amd-gfx@lists.freedesktop.org
Cc:     dri-devel@lists.freedesktop.org, harry.wentland@amd.com
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 03/11] drm/amd/display: Honor the offset for plane 0.
In-Reply-To: <20200904160709.123970-4-bas@basnieuwenhuizen.nl>
References: <20200904160709.123970-4-bas@basnieuwenhuizen.nl>
Message-Id: <20200907150342.D0D6A21775@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.8.7, v5.4.63, v4.19.143, v4.14.196, v4.9.235, v4.4.235.

v5.8.7: Build OK!
v5.4.63: Build OK!
v4.19.143: Failed to apply! Possible dependencies:
    180db303ff46 ("drm/amd/display: Add below the range support for FreeSync")
    7df7e505e82a ("drm/amd/display: Set requested plane state DCC params for GFX9")
    8c3db1284a01 ("drm/amdgpu: fill in amdgpu_dm_remove_sink_from_freesync_module")
    98e6436d3af5 ("drm/amd/display: Refactor FreeSync module")
    c1ee92f94ce3 ("drm/amd: Add abm level drm property")
    d999853e60a0 ("drm/amd/display: Guard against null stream dereference in do flip")
    e5d0170e5644 ("drm/amd/display: Use non-deprecated vblank handler")

v4.14.196: Failed to apply! Possible dependencies:
    1b0c0f9dc5ca ("drm/amdgpu: move userptr BOs to CPU domain during CS v2")
    3fe89771cb0a ("drm/amdgpu: stop reserving the BO in the MMU callback v3")
    4562236b3bc0 ("drm/amd/dc: Add dc display driver (v2)")
    60de1c1740f3 ("drm/amdgpu: use a rw_semaphore for MMU notifiers")
    7df7e505e82a ("drm/amd/display: Set requested plane state DCC params for GFX9")
    9a18999640fa ("drm/amdgpu: move MMU notifier related defines to amdgpu_mn.h")
    9cca0b8e5df0 ("drm/amdgpu: move amdgpu_cs_sysvm_access_required into find_mapping")
    a216ab09955d ("drm/amdgpu: fix userptr put_page handling")
    b72cf4fca2bb ("drm/amdgpu: move taking mmap_sem into get_user_pages v2")
    ca666a3c298f ("drm/amdgpu: stop using BO status for user pages")
    e7b07ceef2a6 ("drm/amd/display: Merge amdgpu_dm_types and amdgpu_dm")

v4.9.235: Failed to apply! Possible dependencies:
    1cec20f0ea0e ("dma-buf: Restart reservation_object_wait_timeout_rcu() after writes")
    248a1d6f1ac4 ("drm/amd: fix include notation and remove -Iinclude/drm flag")
    4562236b3bc0 ("drm/amd/dc: Add dc display driver (v2)")
    78010cd9736e ("dma-buf/fence: add an lockdep_assert_held()")
    7df7e505e82a ("drm/amd/display: Set requested plane state DCC params for GFX9")
    e7b07ceef2a6 ("drm/amd/display: Merge amdgpu_dm_types and amdgpu_dm")
    f54d1867005c ("dma-buf: Rename struct fence to dma_fence")
    fedf54132d24 ("dma-buf: Restart reservation_object_get_fences_rcu() after writes")

v4.4.235: Failed to apply! Possible dependencies:
    0f477c6dea70 ("staging/android/sync: add sync_fence_create_dma")
    1f7371b2a5fa ("drm/amd/powerplay: add basic powerplay framework")
    248a1d6f1ac4 ("drm/amd: fix include notation and remove -Iinclude/drm flag")
    288912cb95d1 ("drm/amdgpu: use $(src) in Makefile (v2)")
    375fb53ec1be ("staging: android: replace explicit NULL comparison")
    395dec6f6bc5 ("Documentation: add doc for sync_file_get_fence()")
    4325198180e5 ("drm/amdgpu: remove GART page addr array")
    4562236b3bc0 ("drm/amd/dc: Add dc display driver (v2)")
    62304fb1fc08 ("dma-buf/sync_file: de-stage sync_file")
    7df7e505e82a ("drm/amd/display: Set requested plane state DCC params for GFX9")
    a1d29476d666 ("drm/amdgpu: optionally enable GART debugfs file")
    a8fe58cec351 ("drm/amd: add ACP driver support")
    b70f014d58b9 ("drm/amdgpu: change default sched jobs to 32")
    c784c82a3fd6 ("Documentation: add Sync File doc")
    d4cab38e153d ("staging/android: prepare sync_file for de-staging")
    d7fdb0ae9d11 ("staging/android: rename sync_fence to sync_file")
    e7b07ceef2a6 ("drm/amd/display: Merge amdgpu_dm_types and amdgpu_dm")
    f54d1867005c ("dma-buf: Rename struct fence to dma_fence")
    fac8434dab96 ("Documentation: Fix some grammar mistakes in sync_file.txt")
    fdba11f4079e ("drm/amdgpu: move all Kconfig options to amdgpu/Kconfig")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
