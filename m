Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFAEB60A1D1
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbiJXLdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbiJXLdP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:33:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D9257545;
        Mon, 24 Oct 2022 04:32:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4263CB81147;
        Mon, 24 Oct 2022 11:32:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67016C433B5;
        Mon, 24 Oct 2022 11:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611152;
        bh=5sX+OmFTE1w7aHjsg/fwnyOtTiF5HXKmF/IgClyAqZg=;
        h=From:To:Cc:Subject:Date:From;
        b=QbSKLCP+lGl65ISpezw6vn9FSRFqTOIO9hzicXhWdRCnG6saOukJXA9uCs4A4q4aj
         WOz5qyLiRfrn0W0Cp40G4xxQNjlW8ZohJhgX5sE6GPmb/Q/Z3eJ8Cn+a7sbpiB+9jj
         u07sSa7455Tw22GUOKD4x2XoC/roeQ1jQQqR/OC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: [PATCH 6.0 00/20] 6.0.4-rc1 review
Date:   Mon, 24 Oct 2022 13:31:02 +0200
Message-Id: <20221024112934.415391158@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.4-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.0.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.0.4-rc1
X-KernelTest-Deadline: 2022-10-26T11:29+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 6.0.4 release.
There are 20 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.4-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.0.4-rc1

Thomas Zimmermann <tzimmermann@suse.de>
    fbdev/core: Remove remove_conflicting_pci_framebuffers()

Mel Gorman <mgorman@techsingularity.net>
    mm/huge_memory: do not clobber swp_entry_t during THP split

Rafael Mendonca <rafaelmendsr@gmail.com>
    io-wq: Fix memory leak in worker creation

Martin Liska <mliska@suse.cz>
    gcov: support GCC 12.1 and newer compilers

Ard Biesheuvel <ardb@kernel.org>
    efi: ssdt: Don't free memory if ACPI table was loaded successfully

Ard Biesheuvel <ardb@kernel.org>
    efi: efivars: Fix variable writes without query_variable_store()

Nikos Tsironis <ntsironis@arrikto.com>
    dm clone: Fix typo in block_device format specifier

Tim Huang <tim.huang@amd.com>
    drm/amd/pm: update SMU IP v13.0.4 driver interface version

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: fulfill SMU13.0.0 cstate control interface

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: disable cstate feature for gpu reset scenario

Tim Huang <tim.huang@amd.com>
    drm/amd/pm: add SMU IP v13.0.4 IF version define to V7

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: fulfill SMU13.0.7 cstate control interface

Pavel Begunkov <asml.silence@gmail.com>
    net: flag sockets supporting msghdr originated zerocopy

Roderick Colenbrander <roderick@gaikai.com>
    HID: playstation: add initial DualSense Edge controller support

Roderick Colenbrander <roderick@gaikai.com>
    HID: playstation: stop DualSense output work on remove.

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/net: fail zc send when unsupported by socket

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: intel_powerclamp: Use first online CPU as control_cpu

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    pinctrl: amd: change dev_warn to dev_dbg for additional feature support

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/bios: Use hardcoded fp_timing size for generating LFP data pointers

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/bios: Validate fp_timing terminator presence


-------------

Diffstat:

 Makefile                                           |   4 +-
 drivers/firmware/efi/efi.c                         |   2 +
 drivers/firmware/efi/vars.c                        |  10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   8 ++
 .../pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_4.h |  17 +++-
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h       |   2 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c  |   8 ++
 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c |   9 ++
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c   |  11 +++
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c   |  12 +++
 drivers/gpu/drm/i915/display/intel_bios.c          | 106 ++++++++++-----------
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-playstation.c                      |  46 +++++++--
 drivers/md/dm-clone-target.c                       |   2 +-
 drivers/pinctrl/pinctrl-amd.c                      |   4 +-
 drivers/thermal/intel/intel_powerclamp.c           |   6 +-
 drivers/video/aperture.c                           |  30 +++---
 drivers/video/fbdev/core/fbmem.c                   |  48 ----------
 fs/efivarfs/vars.c                                 |  16 ----
 include/linux/efi.h                                |   3 -
 include/linux/fb.h                                 |   2 -
 include/linux/net.h                                |   1 +
 io_uring/io-wq.c                                   |   2 +-
 io_uring/net.c                                     |   2 +
 kernel/gcov/gcc_4_7.c                              |  18 +++-
 mm/huge_memory.c                                   |  11 ++-
 net/ipv4/tcp.c                                     |   1 +
 net/ipv4/udp.c                                     |   1 +
 28 files changed, 218 insertions(+), 165 deletions(-)


