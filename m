Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5EA15ACFC5
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 12:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237886AbiIEKOt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 06:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237822AbiIEKNy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 06:13:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF105721A;
        Mon,  5 Sep 2022 03:12:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2211FB8102E;
        Mon,  5 Sep 2022 10:12:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED30C433B5;
        Mon,  5 Sep 2022 10:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662372771;
        bh=VRylm+RrVNsori+HD5VNWtIxj0v8lrP5LOAtGd3d/xw=;
        h=From:To:Cc:Subject:Date:From;
        b=H/GkpkfipTDKObB33wsTUyXezz4+Ob1igkxLHSBhzqu54PBk1yImvYiCpmIvx63R6
         KWpteuS9sV0+fC2R8TePNuSjaCU0En/geEFd5sW4husTHZeXWu7PmWqFlZMiptGy3t
         gM3V0AbjSdoiO7h5VHJX//0wb72VcMX625wty01g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.19.7
Date:   Mon,  5 Sep 2022 12:12:30 +0200
Message-Id: <1662372751208160@kroah.com>
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

I'm announcing the release of the 5.19.7 kernel.

All users of the 5.19 kernel series must upgrade.

The updated 5.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/arm64/silicon-errata.rst                             |    2 
 Documentation/sphinx/kerneldoc-preamble.sty                        |   22 
 Documentation/tools/rtla/rtla-timerlat-hist.rst                    |    2 
 Makefile                                                           |    2 
 arch/arm64/Kconfig                                                 |   17 
 arch/arm64/kernel/cacheinfo.c                                      |    6 
 arch/arm64/kernel/cpu_errata.c                                     |    8 
 arch/s390/hypfs/hypfs_diag.c                                       |    2 
 arch/s390/hypfs/inode.c                                            |    2 
 drivers/android/binder_alloc.c                                     |    9 
 drivers/dma-buf/udmabuf.c                                          |   18 
 drivers/firmware/tegra/bpmp.c                                      |    6 
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                                |    2 
 drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c                             |    3 
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c                              |    3 
 drivers/gpu/drm/amd/amdgpu/ih_v6_0.c                               |    1 
 drivers/gpu/drm/amd/amdgpu/navi10_ih.c                             |    7 
 drivers/gpu/drm/amd/amdgpu/psp_v12_0.c                             |   10 
 drivers/gpu/drm/amd/amdgpu/soc21.c                                 |    2 
 drivers/gpu/drm/amd/amdgpu/vega10_ih.c                             |    7 
 drivers/gpu/drm/amd/amdgpu/vega20_ih.c                             |    7 
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c                           |    2 
 drivers/gpu/drm/amd/amdkfd/kfd_events.c                            |   24 
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h                              |    2 
 drivers/gpu/drm/amd/display/dc/core/dc.c                           |   12 
 drivers/gpu/drm/amd/display/dc/dc_link.h                           |    1 
 drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c              |    2 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c          |    1 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_mpc.c                   |    6 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c                  |    5 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_mpc.c                   |    6 
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hubbub.c                |    8 
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubp.c                  |    2 
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hpo_dp_stream_encoder.h |    3 
 drivers/gpu/drm/amd/display/modules/freesync/freesync.c            |   15 
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c            |    1 
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c                     |   10 
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c               |    2 
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_4_ppt.c               |    3 
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c               |    2 
 drivers/gpu/drm/vc4/Kconfig                                        |    1 
 drivers/gpu/drm/vc4/vc4_hdmi.c                                     |   17 
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c                             |   18 
 drivers/hid/hid-asus.c                                             |    7 
 drivers/hid/hid-ids.h                                              |    3 
 drivers/hid/hid-input.c                                            |    7 
 drivers/hid/hid-nintendo.c                                         |    6 
 drivers/hid/hid-quirks.c                                           |    2 
 drivers/hid/hid-steam.c                                            |   10 
 drivers/hid/hid-thrustmaster.c                                     |    3 
 drivers/hid/hidraw.c                                               |    2 
 drivers/hid/intel-ish-hid/ipc/hw-ish.h                             |    1 
 drivers/hid/intel-ish-hid/ipc/pci-ish.c                            |    1 
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c                            |    1 
 drivers/mmc/host/mtk-sd.c                                          |    6 
 drivers/mmc/host/sdhci-of-dwcmshc.c                                |   88 ++-
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c              |    8 
 drivers/pci/pcie/portdrv_core.c                                    |    9 
 drivers/platform/x86/serial-multi-instantiate.c                    |    1 
 drivers/usb/gadget/udc/core.c                                      |   11 
 drivers/video/fbdev/pm2fb.c                                        |    5 
 fs/btrfs/ctree.c                                                   |    3 
 fs/btrfs/ctree.h                                                   |    2 
 fs/btrfs/disk-io.c                                                 |   82 ---
 fs/btrfs/disk-io.h                                                 |   10 
 fs/btrfs/extent-tree.c                                             |   18 
 fs/btrfs/extent_io.c                                               |   11 
 fs/btrfs/locking.c                                                 |   91 +++
 fs/btrfs/locking.h                                                 |   14 
 fs/btrfs/relocation.c                                              |    2 
 fs/btrfs/tree-checker.c                                            |   25 -
 fs/ksmbd/mgmt/tree_connect.c                                       |    2 
 fs/ksmbd/smb2pdu.c                                                 |   21 
 fs/ntfs3/xattr.c                                                   |    7 
 include/linux/rmap.h                                               |    7 
 include/linux/skbuff.h                                             |    8 
 include/linux/skmsg.h                                              |    3 
 include/net/sock.h                                                 |   68 +-
 kernel/trace/ftrace.c                                              |   10 
 lib/crypto/Kconfig                                                 |    1 
 mm/rmap.c                                                          |   29 -
 net/bluetooth/l2cap_core.c                                         |   10 
 net/bpf/test_run.c                                                 |    3 
 net/core/dev.c                                                     |    1 
 net/core/neighbour.c                                               |   27 -
 net/core/skmsg.c                                                   |    4 
 net/netfilter/Kconfig                                              |    1 
 net/packet/af_packet.c                                             |    4 
 sound/pci/hda/patch_cs8409-tables.c                                |    4 
 sound/pci/hda/patch_realtek.c                                      |    2 
 sound/soc/codecs/rt5640.c                                          |    5 
 sound/soc/sh/rz-ssi.c                                              |   26 -
 sound/usb/quirks.c                                                 |    2 
 tools/testing/selftests/netfilter/nft_flowtable.sh                 |  246 +++++-----
 tools/tracing/rtla/src/timerlat_hist.c                             |    2 
 tools/tracing/rtla/src/timerlat_top.c                              |    2 
 96 files changed, 802 insertions(+), 403 deletions(-)

Aditya Garg (1):
      HID: Add Apple Touchbar on T2 Macs in hid_have_special_driver list

Akihiko Odaki (1):
      HID: AMD_SFH: Add a DMI quirk entry for Chromebooks

Akira Yokosawa (1):
      docs: kerneldoc-preamble: Test xeCJK.sty before loading

Alan Stern (1):
      USB: gadget: Fix use-after-free Read in usb_udc_uevent()

Alexandre Vicenzi (1):
      rtla: Fix tracer name

Alvin Lee (1):
      drm/amd/display: For stereo keep "FLIP_ANY_FRAME"

Aurabindo Pillai (1):
      drm/amd/display: Add a missing register field for HPO DP stream encoder

Benjamin Tissoires (1):
      HID: input: fix uclogic tablets

Biju Das (1):
      ASoC: sh: rz-ssi: Improve error handling in rz_ssi_probe() error path

Charlene Liu (1):
      drm/amd/display: avoid doing vm_init multiple time

Chiawen Huang (1):
      drm/amd/display: Device flash garbage before get in OS

Daniel J. Ogorchock (1):
      HID: nintendo: fix rumble worker null pointer deref

Denis V. Lunev (1):
      neigh: fix possible DoS due to net iface start/stop loop

Dongliang Mu (1):
      media: pvrusb2: fix memory leak in pvr_probe

Dusica Milinkovic (1):
      drm/amdgpu: Increase tlb flush timeout for sriov

Eric Biggers (1):
      crypto: lib - remove unneeded selection of XOR_BLOCKS

Evan Quan (3):
      drm/amdgpu: disable 3DCGCG/CGLS temporarily due to stability issue
      drm/amd/pm: add missing ->fini_microcode interface for Sienna Cichlid
      drm/amd/pm: add missing ->fini_xxxx interfaces for some SMU13 asics

Even Xu (1):
      HID: intel-ish-hid: ipc: Add Meteor Lake PCI device ID

Felix Kuehling (1):
      drm/amdkfd: Handle restart of kfd_ioctl_wait_events

Florian Westphal (1):
      testing: selftests: nft_flowtable.sh: use random netns names

Fudong Wang (1):
      drm/amd/display: clear optc underflow before turn off odm clock

Geert Uytterhoeven (1):
      netfilter: conntrack: NF_CONNTRACK_PROCFS should no longer default to y

Greg Kroah-Hartman (2):
      Revert "PCI/portdrv: Don't disable AER reporting in get_port_device_capability()"
      Linux 5.19.7

Harish Kasiviswanathan (1):
      drm/amdgpu: Add decode_iv_ts helper for ih_v6 block

Hawkins Jiawei (1):
      net: fix refcount bug in sk_psock_get (2)

Ilya Bakoulin (1):
      drm/amd/display: Fix pixel clock programming

James Morse (1):
      arm64: errata: Add Cortex-A510 to the repeat tlbi list

Jann Horn (1):
      mm/rmap: Fix anon_vma->degree ambiguity leading to double-reuse

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

Kenneth Feng (1):
      drm/amd/pm: skip pptable override for smu_v13_0_7

Konstantin Komarov (1):
      fs/ntfs3: Fix work with fragmented xattr

Lee Jones (1):
      HID: steam: Prevent NULL pointer dereference in steam_{recv,send}_report

Leo Ma (1):
      drm/amd/display: Fix HDMI VSIF V3 incorrect issue

Letu Ren (1):
      fbdev: fb_pm2fb: Avoid potential divide by zero error

Li Qiong (1):
      net: lan966x: fix checking for return value of platform_get_irq_byname()

Liam Howlett (1):
      android: binder: fix lockdep check on clearing vma

Liming Sun (1):
      mmc: sdhci-of-dwcmshc: Re-enable support for the BlueField-3 SoC

Lucas Tanure (1):
      platform/x86: serial-multi-instantiate: Add CLSA0101 Laptop

Luiz Augusto von Dentz (1):
      Bluetooth: L2CAP: Fix build errors in some archs

Maxime Ripard (2):
      drm/vc4: hdmi: Rework power up
      drm/vc4: hdmi: Depends on CONFIG_PM

Meenakshikumar Somasundaram (1):
      drm/amd/display: Fix TDR eDP and USB4 display light up issue

Michael Hübner (1):
      HID: thrustmaster: Add sparco wheel and fix array length

Mukul Joshi (1):
      drm/amdgpu: Fix interrupt handling on ih_soft ring

Namjae Jeon (2):
      ksmbd: return STATUS_BAD_NETWORK_NAME error status if share is not configured
      ksmbd: don't remove dos attribute xattr on O_TRUNC open

Oder Chiou (1):
      ASoC: rt5640: Fix the JD voltage dropping issue

Sebastian Reichel (1):
      mmc: sdhci-of-dwcmshc: rename rk3568 to rk35xx

Shane Xiao (1):
      drm/amdgpu: Add secure display TA load for Renoir

Steev Klimaszewski (1):
      HID: add Lenovo Yoga C630 battery quirk

Stefan Binding (2):
      ALSA: hda/realtek: Add quirks for ASUS Zenbooks using CS35L41
      ALSA: hda/cs8409: Support new Dolphin Variants

Sudeep Holla (1):
      arm64: cacheinfo: Fix incorrect assignment of signed error value to unsigned fw_level

Takashi Iwai (1):
      ALSA: usb-audio: Add quirk for LH Labs Geek Out HD Audio 1V5

Timo Alho (1):
      firmware: tegra: bpmp: Do only aligned access to IPC memory area

Tom Chung (1):
      drm/amd/display: Fix plug/unplug external monitor will hang while playback MPO video

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

Zhen Ni (1):
      drm/amd/pm: Fix a potential gpu_metrics_table memory leak

Zhengchao Shao (2):
      bpf: Don't redirect packets with invalid pkt_len
      net/af_packet: check len when min_header_len equals to 0

