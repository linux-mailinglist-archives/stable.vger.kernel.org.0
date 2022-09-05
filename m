Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A09A75ACFE6
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 12:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237884AbiIEKOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 06:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237636AbiIEKM7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 06:12:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39325465F;
        Mon,  5 Sep 2022 03:12:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51647B81002;
        Mon,  5 Sep 2022 10:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5788C433D6;
        Mon,  5 Sep 2022 10:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662372761;
        bh=zPhGU2cvp34uNNu5GJEprmj9gGXkQPiysYP3DfM9sPE=;
        h=From:To:Cc:Subject:Date:From;
        b=P6XgW4fX/NHtW+YIRtctUFzFL52G4dQ6WV1GikXpc5Y/uSO53cd+Ra6Tk8kAgwm+S
         CVBWJ2SL4fImb0AWGGbOTCAyf6khA6MX6BMmqJ1mhcynwNM1A1dmLHHycmIkO0/RPP
         zXQptBDKpHHlxSZPK9xKCIkmIMxOpxKlIgmRIGbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.65
Date:   Mon,  5 Sep 2022 12:12:25 +0200
Message-Id: <166237274583179@kroah.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.65 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/arm64/silicon-errata.rst                  |    2 
 Makefile                                                |    2 
 arch/arm64/Kconfig                                      |   17 
 arch/arm64/kernel/cpu_errata.c                          |    8 
 arch/s390/hypfs/hypfs_diag.c                            |    2 
 arch/s390/hypfs/inode.c                                 |    2 
 drivers/acpi/thermal.c                                  |    2 
 drivers/android/binder_alloc.c                          |    9 
 drivers/dma-buf/udmabuf.c                               |   18 
 drivers/firmware/tegra/bpmp.c                           |    6 
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                     |    2 
 drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c                  |    3 
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c                   |    3 
 drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c   |    2 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_mpc.c        |    6 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c       |    5 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_mpc.c        |    6 
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hubbub.c     |    8 
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubp.c       |    2 
 drivers/gpu/drm/amd/display/modules/freesync/freesync.c |   15 
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c |    1 
 drivers/gpu/drm/i915/gt/intel_gt.c                      |    3 
 drivers/gpu/drm/vc4/Kconfig                             |    1 
 drivers/gpu/drm/vc4/vc4_hdmi.c                          |   17 
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c                  |   18 
 drivers/hid/hid-asus.c                                  |    7 
 drivers/hid/hid-ids.h                                   |    1 
 drivers/hid/hid-input.c                                 |    2 
 drivers/hid/hid-steam.c                                 |   10 
 drivers/hid/hid-thrustmaster.c                          |    3 
 drivers/hid/hidraw.c                                    |    3 
 drivers/hv/hv_balloon.c                                 |   13 
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c                 |    1 
 drivers/mmc/host/mtk-sd.c                               |    6 
 drivers/mmc/host/sdhci-of-dwcmshc.c                     |   88 +
 drivers/pci/pcie/portdrv_core.c                         |    9 
 drivers/video/fbdev/pm2fb.c                             |    5 
 fs/btrfs/block-group.c                                  |   47 -
 fs/btrfs/block-group.h                                  |    4 
 fs/btrfs/ctree.c                                        |    3 
 fs/btrfs/ctree.h                                        |    4 
 fs/btrfs/disk-io.c                                      |   82 -
 fs/btrfs/disk-io.h                                      |   10 
 fs/btrfs/extent-tree.c                                  |   48 -
 fs/btrfs/extent_io.c                                    |   11 
 fs/btrfs/inode.c                                        |   25 
 fs/btrfs/locking.c                                      |   91 +
 fs/btrfs/locking.h                                      |   14 
 fs/btrfs/relocation.c                                   |    2 
 fs/btrfs/tree-checker.c                                 |   25 
 fs/btrfs/tree-log.c                                     |  221 +---
 fs/io_uring.c                                           |  746 +++++++---------
 fs/ksmbd/mgmt/tree_connect.c                            |    2 
 fs/ksmbd/smb2pdu.c                                      |   21 
 fs/ntfs3/xattr.c                                        |    7 
 include/drm/drm_bridge.h                                |   13 
 include/linux/rmap.h                                    |    7 
 include/linux/skbuff.h                                  |    8 
 include/linux/skmsg.h                                   |    3 
 include/net/sock.h                                      |   68 +
 include/uapi/linux/btrfs_tree.h                         |    4 
 kernel/kprobes.c                                        |    9 
 kernel/trace/ftrace.c                                   |   10 
 lib/crypto/Kconfig                                      |    1 
 mm/hugetlb.c                                            |    2 
 mm/mmap.c                                               |   12 
 mm/rmap.c                                               |   29 
 net/bluetooth/l2cap_core.c                              |   10 
 net/bpf/test_run.c                                      |    3 
 net/core/dev.c                                          |    1 
 net/core/neighbour.c                                    |   27 
 net/core/skmsg.c                                        |    4 
 net/netfilter/Kconfig                                   |    1 
 net/packet/af_packet.c                                  |    4 
 scripts/Makefile.modpost                                |    3 
 sound/soc/sh/rz-ssi.c                                   |   26 
 sound/usb/quirks.c                                      |    2 
 tools/testing/selftests/netfilter/nft_flowtable.sh      |  246 ++---
 78 files changed, 1194 insertions(+), 970 deletions(-)

Adam Borowski (1):
      ACPI: thermal: drop an always true check

Akihiko Odaki (1):
      HID: AMD_SFH: Add a DMI quirk entry for Chromebooks

Alvin Lee (1):
      drm/amd/display: For stereo keep "FLIP_ANY_FRAME"

Biju Das (1):
      ASoC: sh: rz-ssi: Improve error handling in rz_ssi_probe() error path

Boqun Feng (1):
      Drivers: hv: balloon: Support status report for larger page sizes

Charlene Liu (1):
      drm/amd/display: avoid doing vm_init multiple time

Chris Wilson (1):
      drm/i915/gt: Skip TLB invalidations once wedged

Denis V. Lunev (1):
      neigh: fix possible DoS due to net iface start/stop loop

Dongliang Mu (1):
      media: pvrusb2: fix memory leak in pvr_probe

Dusica Milinkovic (1):
      drm/amdgpu: Increase tlb flush timeout for sriov

Eric Biggers (1):
      crypto: lib - remove unneeded selection of XOR_BLOCKS

Evan Quan (1):
      drm/amd/pm: add missing ->fini_microcode interface for Sienna Cichlid

Filipe Manana (4):
      btrfs: remove root argument from btrfs_unlink_inode()
      btrfs: remove no longer needed logic for replaying directory deletes
      btrfs: add and use helper for unlinking inode during log replay
      btrfs: fix warning during log replay when bumping inode link count

Florian Westphal (1):
      testing: selftests: nft_flowtable.sh: use random netns names

Fudong Wang (1):
      drm/amd/display: clear optc underflow before turn off odm clock

Geert Uytterhoeven (1):
      netfilter: conntrack: NF_CONNTRACK_PROCFS should no longer default to y

Greg Kroah-Hartman (2):
      Revert "PCI/portdrv: Don't disable AER reporting in get_port_device_capability()"
      Linux 5.15.65

Hawkins Jiawei (1):
      net: fix refcount bug in sk_psock_get (2)

Ilya Bakoulin (1):
      drm/amd/display: Fix pixel clock programming

James Morse (1):
      arm64: errata: Add Cortex-A510 to the repeat tlbi list

Jann Horn (2):
      mm: Force TLB flush for PFNMAP mappings before unlink_file_vma()
      mm/rmap: Fix anon_vma->degree ambiguity leading to double-reuse

Jens Axboe (2):
      io_uring: remove poll entry from list when canceling all
      io_uring: bump poll refs to full 31-bits

Jiapeng Chong (1):
      io_uring: Remove unused function req_ref_put

Jing Leng (1):
      kbuild: Fix include path in scripts/Makefile.modpost

Josef Bacik (3):
      btrfs: move lockdep class helpers to locking.c
      btrfs: fix lockdep splat with reloc root extent buffers
      btrfs: tree-checker: check for overlapping extent items

Josh Kilmer (1):
      HID: asus: ROG NKey: Ignore portion of 0x5a report

Josip Pavic (1):
      drm/amd/display: Avoid MPC infinite loop

Juergen Gross (1):
      s390/hypfs: avoid error message under KVM

Karthik Alapati (1):
      HID: hidraw: fix memory leak in hidraw_release()

Konstantin Komarov (1):
      fs/ntfs3: Fix work with fragmented xattr

Kuniyuki Iwashima (1):
      kprobes: don't call disarm_kprobe() for disabled kprobes

Lee Jones (1):
      HID: steam: Prevent NULL pointer dereference in steam_{recv,send}_report

Leo Ma (1):
      drm/amd/display: Fix HDMI VSIF V3 incorrect issue

Letu Ren (1):
      fbdev: fb_pm2fb: Avoid potential divide by zero error

Liam Howlett (1):
      android: binder: fix lockdep check on clearing vma

Liming Sun (1):
      mmc: sdhci-of-dwcmshc: Re-enable support for the BlueField-3 SoC

Luiz Augusto von Dentz (1):
      Bluetooth: L2CAP: Fix build errors in some archs

Maxime Ripard (3):
      drm/bridge: Add stubs for devm_drm_of_get_bridge when OF is disabled
      drm/vc4: hdmi: Rework power up
      drm/vc4: hdmi: Depends on CONFIG_PM

Miaohe Lin (1):
      mm/hugetlb: avoid corrupting page->mapping in hugetlb_mcopy_atomic_pte

Michael Hübner (1):
      HID: thrustmaster: Add sparco wheel and fix array length

Namjae Jeon (2):
      ksmbd: return STATUS_BAD_NETWORK_NAME error status if share is not configured
      ksmbd: don't remove dos attribute xattr on O_TRUNC open

Omar Sandoval (1):
      btrfs: fix space cache corruption and potential double allocations

Pavel Begunkov (10):
      io_uring: correct fill events helpers types
      io_uring: clean cqe filling functions
      io_uring: refactor poll update
      io_uring: move common poll bits
      io_uring: kill poll linking optimisation
      io_uring: inline io_poll_complete
      io_uring: poll rework
      io_uring: fail links when poll fails
      io_uring: fix wrong arm_poll error handling
      io_uring: fix UAF due to missing POLLFREE handling

Sebastian Reichel (1):
      mmc: sdhci-of-dwcmshc: rename rk3568 to rk35xx

Steev Klimaszewski (1):
      HID: add Lenovo Yoga C630 battery quirk

Takashi Iwai (1):
      ALSA: usb-audio: Add quirk for LH Labs Geek Out HD Audio 1V5

Timo Alho (1):
      firmware: tegra: bpmp: Do only aligned access to IPC memory area

Vivek Kasireddy (1):
      udmabuf: Set the DMA mask for the udmabuf device (v2)

Wenbin Mei (1):
      mmc: mtk-sd: Clear interrupts when cqe off/disable

Yang Jihong (1):
      ftrace: Fix NULL pointer dereference in is_ftrace_trampoline when ftrace is dead

Yang Yingliang (1):
      net: neigh: don't call kfree_skb() under spin_lock_irqsave()

Yifeng Zhao (1):
      mmc: sdhci-of-dwcmshc: add reset call back for rockchip Socs

Zhengchao Shao (2):
      bpf: Don't redirect packets with invalid pkt_len
      net/af_packet: check len when min_header_len equals to 0

