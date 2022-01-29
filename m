Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A881A4A2DFF
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 12:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237592AbiA2LB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 06:01:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237804AbiA2LAV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 06:00:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42DF2C061756;
        Sat, 29 Jan 2022 03:00:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB682B826FF;
        Sat, 29 Jan 2022 11:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B46C340E5;
        Sat, 29 Jan 2022 11:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643454013;
        bh=Pp4DGTKktA5ojhNg/67ugwpIYmF7qQ5xxHwoXFf3rtw=;
        h=From:To:Cc:Subject:Date:From;
        b=1CyN33kd56rDO7ZovDQUQ2Hin2Oai7YwkmKApc/s/ndd84pyOYIIqiO/138uDFCiH
         UeVlc+/LWfr1t/pGRveCFiD+Qrj3J2fpWD6kyVzwfuXPHHy1ZGecqjFi1RdqpsrbiF
         +SrU81iWmv4VqyCLjxwwJ5IPgwubMhpy3PODQSlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.18
Date:   Sat, 29 Jan 2022 11:59:55 +0100
Message-Id: <1643453996204137@kroah.com>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.18 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                 |    2 
 arch/arm64/include/asm/extable.h                         |    9 -
 arch/arm64/include/asm/memory.h                          |    5 
 arch/arm64/kernel/traps.c                                |    2 
 arch/arm64/mm/extable.c                                  |   13 +
 arch/arm64/mm/ptdump.c                                   |    2 
 arch/arm64/net/bpf_jit_comp.c                            |    7 -
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c                    |   14 +-
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c |    6 
 drivers/gpu/drm/i915/gem/i915_gem_object_types.h         |    1 
 drivers/gpu/drm/i915/gem/i915_gem_pages.c                |   10 +
 drivers/gpu/drm/i915/gt/intel_gt.c                       |  102 +++++++++++++++
 drivers/gpu/drm/i915/gt/intel_gt.h                       |    2 
 drivers/gpu/drm/i915/gt/intel_gt_types.h                 |    2 
 drivers/gpu/drm/i915/i915_reg.h                          |   11 +
 drivers/gpu/drm/i915/i915_vma.c                          |    3 
 drivers/gpu/drm/i915/intel_uncore.c                      |   26 +++
 drivers/gpu/drm/i915/intel_uncore.h                      |    2 
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                      |    5 
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c                  |   33 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c                    |    2 
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                      |    2 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h              |   11 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c          |    6 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h      |    2 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h          |    3 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c         |   75 +++++++----
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c        |   13 +
 fs/io_uring.c                                            |   34 +++--
 fs/select.c                                              |   63 ++++-----
 kernel/rcu/tree.c                                        |    7 -
 mm/memcontrol.c                                          |   99 ++++++++++----
 32 files changed, 416 insertions(+), 158 deletions(-)

Greg Kroah-Hartman (1):
      Linux 5.15.18

Harry Wentland (1):
      drm/amdgpu: Use correct VIEWPORT_DIMENSION for DCN2

Jan Kara (1):
      select: Fix indefinitely sleeping task in poll_schedule_timeout()

Manish Chopra (2):
      bnx2x: Utilize firmware 7.13.21.0
      bnx2x: Invalidate fastpath HSI version for VFs

Mario Limonciello (1):
      drm/amd/display: reset dcn31 SMU mailbox on failures

Mathias Krause (1):
      drm/vmwgfx: Fix stale file descriptors on failed usercopy

Paul E. McKenney (1):
      rcu: Tighten rcu_advance_cbs_nowake() checks

Pavel Begunkov (1):
      io_uring: fix not released cached task refs

Russell King (1):
      arm64/bpf: Remove 128MB limit for BPF JIT programs

Shakeel Butt (3):
      memcg: flush stats only if updated
      memcg: unify memcg stat flushing
      memcg: better bounds on the memcg stats updates

Tvrtko Ursulin (1):
      drm/i915: Flush TLBs before releasing backing store

