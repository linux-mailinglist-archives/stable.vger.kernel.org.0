Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE084272441
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 14:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgIUMyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 08:54:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:59994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726395AbgIUMyr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 08:54:47 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E7E921789;
        Mon, 21 Sep 2020 12:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600692886;
        bh=HY4FdjomRHFx4NlAmacrCNHK81B5khhTgCqc1BE7owE=;
        h=Date:From:To:To:To:To:CC:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=kcD+Hl6L8eOWz4vvwqkeqxU9xgOxL1li9Fsh9mJOx96HIbQNrL/24J203g7bBPs1Y
         3f9HVTq5ZD8Cu4wYI7kPPTwtnVWLjsDuRuyx5i7oiqZef2DWyhdaQUUgWTmc2xHxRe
         kLbjqBqtGdpQtHkmuvsE4Qdmxgi5+pagZrYWOjN4=
Date:   Mon, 21 Sep 2020 12:54:45 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Qingqing Zhuo <qingqing.zhuo@amd.com>
To:     Wesley Chalmers <Wesley.Chalmers@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 08/15] drm/amd/display: Increase timeout for DP Disable
In-Reply-To: <20200916193635.5169-9-qingqing.zhuo@amd.com>
References: <20200916193635.5169-9-qingqing.zhuo@amd.com>
Message-Id: <20200921125446.2E7E921789@mail.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.8.10, v5.4.66, v4.19.146, v4.14.198, v4.9.236, v4.4.236.

v5.8.10: Build OK!
v5.4.66: Build OK!
v4.19.146: Failed to apply! Possible dependencies:
    3af91bb15093 ("drm/amd/display: Increase DP blank timeout from 30 ms to 50 ms")

v4.14.198: Failed to apply! Possible dependencies:
    0c41891c81c0 ("drm/amd/display: Refactor stream encoder for HW review")
    1b0c0f9dc5ca ("drm/amdgpu: move userptr BOs to CPU domain during CS v2")
    3fe89771cb0a ("drm/amdgpu: stop reserving the BO in the MMU callback v3")
    4562236b3bc0 ("drm/amd/dc: Add dc display driver (v2)")
    587cdfe9463e ("drm/amd/display: Rename trasnform to dpp for dcn's")
    5aff86c1b325 ("drm/amd/display: Implement input gamma LUT")
    60de1c1740f3 ("drm/amdgpu: use a rw_semaphore for MMU notifiers")
    70ccab604049 ("drm/amdgpu/display: Add core dc support for DCN")
    9a18999640fa ("drm/amdgpu: move MMU notifier related defines to amdgpu_mn.h")
    9a70eba7f2c6 ("drm/amd/display: consolidate dce8-11.2 display clock code")
    9cca0b8e5df0 ("drm/amdgpu: move amdgpu_cs_sysvm_access_required into find_mapping")
    a216ab09955d ("drm/amdgpu: fix userptr put_page handling")
    b1a4eb992c17 ("drm/amd/display: enable diags compilation")
    b51adc77e220 ("drm/amd/display: Only blank DCN when we have set_blank implementation")
    b72cf4fca2bb ("drm/amdgpu: move taking mmap_sem into get_user_pages v2")
    ca666a3c298f ("drm/amdgpu: stop using BO status for user pages")

v4.9.236: Failed to apply! Possible dependencies:
    0c41891c81c0 ("drm/amd/display: Refactor stream encoder for HW review")
    1cec20f0ea0e ("dma-buf: Restart reservation_object_wait_timeout_rcu() after writes")
    248a1d6f1ac4 ("drm/amd: fix include notation and remove -Iinclude/drm flag")
    4562236b3bc0 ("drm/amd/dc: Add dc display driver (v2)")
    587cdfe9463e ("drm/amd/display: Rename trasnform to dpp for dcn's")
    5aff86c1b325 ("drm/amd/display: Implement input gamma LUT")
    70ccab604049 ("drm/amdgpu/display: Add core dc support for DCN")
    78010cd9736e ("dma-buf/fence: add an lockdep_assert_held()")
    9a70eba7f2c6 ("drm/amd/display: consolidate dce8-11.2 display clock code")
    b1a4eb992c17 ("drm/amd/display: enable diags compilation")
    b51adc77e220 ("drm/amd/display: Only blank DCN when we have set_blank implementation")
    f54d1867005c ("dma-buf: Rename struct fence to dma_fence")
    fedf54132d24 ("dma-buf: Restart reservation_object_get_fences_rcu() after writes")

v4.4.236: Failed to apply! Possible dependencies:
    0c41891c81c0 ("drm/amd/display: Refactor stream encoder for HW review")
    0f477c6dea70 ("staging/android/sync: add sync_fence_create_dma")
    1f7371b2a5fa ("drm/amd/powerplay: add basic powerplay framework")
    248a1d6f1ac4 ("drm/amd: fix include notation and remove -Iinclude/drm flag")
    288912cb95d1 ("drm/amdgpu: use $(src) in Makefile (v2)")
    375fb53ec1be ("staging: android: replace explicit NULL comparison")
    395dec6f6bc5 ("Documentation: add doc for sync_file_get_fence()")
    4325198180e5 ("drm/amdgpu: remove GART page addr array")
    4562236b3bc0 ("drm/amd/dc: Add dc display driver (v2)")
    587cdfe9463e ("drm/amd/display: Rename trasnform to dpp for dcn's")
    5aff86c1b325 ("drm/amd/display: Implement input gamma LUT")
    62304fb1fc08 ("dma-buf/sync_file: de-stage sync_file")
    70ccab604049 ("drm/amdgpu/display: Add core dc support for DCN")
    9a70eba7f2c6 ("drm/amd/display: consolidate dce8-11.2 display clock code")
    a1d29476d666 ("drm/amdgpu: optionally enable GART debugfs file")
    a8fe58cec351 ("drm/amd: add ACP driver support")
    b1a4eb992c17 ("drm/amd/display: enable diags compilation")
    b51adc77e220 ("drm/amd/display: Only blank DCN when we have set_blank implementation")
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
