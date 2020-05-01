Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725F31C0C51
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 04:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbgEACzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 22:55:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:59974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728162AbgEACzS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 22:55:18 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD6C1207DD;
        Fri,  1 May 2020 02:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588301718;
        bh=cJZDwhdKmVmAPA17KoxHWrNGsDZvlWmk5qDuWgIP+t0=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=jKiEoLAUB4IlX2S9ZlvEgjNZZKWcDbwbeEOOKopwQqxhB0oR3+kPYgihsF/3oR5vK
         d1xvXGiCK09TP9iwc/+BxKu6uuLCqwhsA10oN2K5ESZZzyrRlPU1ODCmLENmb1zwES
         i3cMxi5S3sherx9lZdfSvtHGZ/8MpyaZLl8gxFL0=
Date:   Fri, 01 May 2020 02:55:17 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Lyude Paul <lyude@redhat.com>
To:     dri-devel@lists.freedesktop.org
Cc:     Maxime Ripard <mripard@kernel.org>
Cc:     Sean Paul <sean@poorly.run>
Cc:     "Lin, Wayne" <Wayne.Lin@amd.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/1] drm/dp_mst: Kill the second sideband tx slot, save the world
In-Reply-To: <20200427213422.1414614-2-lyude@redhat.com>
References: <20200427213422.1414614-2-lyude@redhat.com>
Message-Id: <20200501025517.CD6C1207DD@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: ad7f8a1f9ced ("drm/helper: add Displayport multi-stream helper (v0.6)").

The bot has tested the following trees: v5.6.7, v5.4.35, v4.19.118, v4.14.177, v4.9.220, v4.4.220.

v5.6.7: Failed to apply! Possible dependencies:
    1cfff5f01563 ("drm/dp_mst: Convert drm_dp_mst_topology_mgr.is_waiting_for_dwn_reply to bitfield")

v5.4.35: Failed to apply! Possible dependencies:
    14692a3637d4 ("drm/dp_mst: Add probe_lock")
    2f015ec6eab6 ("drm/dp_mst: Add sideband down request tracing + selftests")
    37dfdc55ffeb ("drm/dp_mst: Cleanup drm_dp_send_link_address() a bit")
    50094b5dcd32 ("drm/dp_mst: Destroy topology_mgr mutexes")
    5950f0b797fc ("drm/dp_mst: Move link address dumping into a function")
    5a64967a2f3b ("drm/dp_mst: Have DP_Tx send one msg at a time")
    60f9ae9d0d3d ("drm/dp_mst: Remove huge conditional in drm_dp_mst_handle_up_req()")
    7cb12d48314e ("drm/dp_mst: Destroy MSTBs asynchronously")
    7cbce45d6243 ("drm/dp_mst: Move test_calc_pbn_mode() into an actual selftest")
    8b1e589d138c ("drm/dp_mst: Refactor drm_dp_mst_handle_down_rep()")
    9408cc94eb04 ("drm/dp_mst: Handle UP requests asynchronously")
    a29d881875fc ("drm/dp_mst: Refactor drm_dp_mst_handle_up_req()")
    caf81ec6cd72 ("drm: Destroy the correct mutex name in drm_dp_mst_topology_mgr_destroy")
    e2839ff692c6 ("drm/dp_mst: Rename drm_dp_add_port and drm_dp_update_port")

v4.19.118: Failed to apply! Possible dependencies:
    16bff572cc66 ("drm/dp-mst-helper: Remove hotplug callback")
    19b85cfabf5c ("drm/bochs: move remaining fb bits to kms")
    2f015ec6eab6 ("drm/dp_mst: Add sideband down request tracing + selftests")
    2f69deb1d9a1 ("drm/arcpgu: prepare for drmP.h removal from drm_modeset_helper.h")
    48b442238250 ("drm/bochs: fix DRM_FORMAT_* handling for big endian machines.")
    562836a269e3 ("drm/dp_mst: Enable registration of AUX devices for MST ports")
    580fc13f3ee4 ("drm/dp: drmP.h include removal")
    5a64967a2f3b ("drm/dp_mst: Have DP_Tx send one msg at a time")
    6579c39594ae ("drm/bochs: atomic: switch planes to atomic, wire up helpers.")
    6abb49402a79 ("drm/bridge: cdns: prepare for drmP.h removal from drm_modeset_helper.h")
    6c76c0eb031f ("drm/bridge: ti-sn65dsi86: Fixup register names")
    7780eb9ce80f ("bochs: convert to drm_dev_register")
    86351de023dd ("drm/bochs: support changing byteorder at mode set time")
    a095f15c00e2 ("drm/bridge: add support for sn65dsi86 bridge driver")
    b814ec6d4535 ("drm/bridge: ti-sn65dsi86: Implement AUX channel")
    df2052cc9221 ("bochs: convert to drm_fb_helper_fbdev_setup/teardown")
    f38b7cca6d0e ("drm/bridge: tc358764: Add DSI to LVDS bridge driver")
    fcd70cd36b9b ("drm: Split out drm_probe_helper.h")
    fe1f664a3609 ("drm/arc: do not rely on drmP.h from drm_gem_cma_helper.h")

v4.14.177: Failed to apply! Possible dependencies:
    1b0c0f9dc5ca ("drm/amdgpu: move userptr BOs to CPU domain during CS v2")
    1ed3d2567c80 ("drm/amdgpu: keep the MMU lock until the update ends v4")
    2f015ec6eab6 ("drm/dp_mst: Add sideband down request tracing + selftests")
    3fe89771cb0a ("drm/amdgpu: stop reserving the BO in the MMU callback v3")
    4562236b3bc0 ("drm/amd/dc: Add dc display driver (v2)")
    562836a269e3 ("drm/dp_mst: Enable registration of AUX devices for MST ports")
    580fc13f3ee4 ("drm/dp: drmP.h include removal")
    5a64967a2f3b ("drm/dp_mst: Have DP_Tx send one msg at a time")
    60de1c1740f3 ("drm/amdgpu: use a rw_semaphore for MMU notifiers")
    9a18999640fa ("drm/amdgpu: move MMU notifier related defines to amdgpu_mn.h")
    9cca0b8e5df0 ("drm/amdgpu: move amdgpu_cs_sysvm_access_required into find_mapping")
    a216ab09955d ("drm/amdgpu: fix userptr put_page handling")
    b72cf4fca2bb ("drm/amdgpu: move taking mmap_sem into get_user_pages v2")
    ca666a3c298f ("drm/amdgpu: stop using BO status for user pages")
    fcd70cd36b9b ("drm: Split out drm_probe_helper.h")

v4.9.220: Failed to apply! Possible dependencies:
    178e32c224d2 ("drm/atomic: Remove pointless private object NULL state check")
    1cec20f0ea0e ("dma-buf: Restart reservation_object_wait_timeout_rcu() after writes")
    2f015ec6eab6 ("drm/dp_mst: Add sideband down request tracing + selftests")
    3941dae15ed9 ("drm_dp_aux_dev: switch to read_iter/write_iter")
    3f3353b7e121 ("drm/dp: Introduce MST topology state to track available link bandwidth")
    562836a269e3 ("drm/dp_mst: Enable registration of AUX devices for MST ports")
    580fc13f3ee4 ("drm/dp: drmP.h include removal")
    5a64967a2f3b ("drm/dp_mst: Have DP_Tx send one msg at a time")
    6806cdf9aa1c ("drm/kms-helpers: Use recommened kerneldoc for struct member refs")
    78010cd9736e ("dma-buf/fence: add an lockdep_assert_held()")
    9498c19b3f53 ("drm: Move tile group code into drm_connector.c")
    9a83a71ac0d5 ("drm/fences: add DOC: for explicit fencing")
    a4370c777406 ("drm/atomic: Make private objs proper objects")
    b430c27a7de3 ("drm: Add driver-private objects to atomic state")
    beaf5af48034 ("drm/fence: add out-fences support")
    d807ed1c55fb ("drm: atomic: Clarify documentation around drm_atomic_crtc_needs_modeset")
    ea0dd85a75f1 ("drm/doc: use preferred struct reference in kernel-doc")
    f54d1867005c ("dma-buf: Rename struct fence to dma_fence")
    fedf54132d24 ("dma-buf: Restart reservation_object_get_fences_rcu() after writes")

v4.4.220: Failed to apply! Possible dependencies:
    22554020409f ("Documentation/gpu: use recommended order of heading markers")
    22cba31bae9d ("Documentation/sphinx: add basic working Sphinx configuration and build")
    2f015ec6eab6 ("drm/dp_mst: Add sideband down request tracing + selftests")
    2fa91d15588c ("Documentation/gpu: split up mm, kms and kms-helpers from internals")
    311b62d94c0b ("drm/doc: Reorg for drm-kms.rst")
    321a95ae35f2 ("drm: Extract drm_encoder.[hc]")
    36230cb5668c ("drm/dp: Allow signals to interrupt drm_aux-dev reads/writes")
    3941dae15ed9 ("drm_dp_aux_dev: switch to read_iter/write_iter")
    43968d7b806d ("drm: Extract drm_plane.[hc]")
    522171951761 ("drm: Extract drm_connector.[hc]")
    562836a269e3 ("drm/dp_mst: Enable registration of AUX devices for MST ports")
    580fc13f3ee4 ("drm/dp: drmP.h include removal")
    5a64967a2f3b ("drm/dp_mst: Have DP_Tx send one msg at a time")
    5fff80bbdb6b ("drm/atomic: Allow for holes in connector state, v2.")
    70412cfa6dde ("drm/kms_helper: Add a common place to call init and exit functions.")
    96106c9729f5 ("drm: fix implicit declaration build error on ia64")
    9b20fa08d3fd ("Documentation/gpu: convert the KMS properties table to CSV")
    a095caa7f5ec ("drm/atomic-helper: roll out commit synchronization")
    a4370c777406 ("drm/atomic: Make private objs proper objects")
    b430c27a7de3 ("drm: Add driver-private objects to atomic state")
    be9174a482b9 ("drm/atomic-helper: use for_each_*_in_state more")
    ca00c2b986ea ("Documentation/gpu: split up the gpu documentation")
    cb597fcea5c2 ("Documentation/gpu: add new gpu.rst converted from DocBook gpu.tmpl")
    e94cb37b34eb ("drm/dp: Add a drm_aux-dev module for reading/writing dpcd registers.")
    ede53344dbfd ("drm: Add helper for DP++ adaptors")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
