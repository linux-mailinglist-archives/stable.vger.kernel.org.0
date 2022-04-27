Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6348A51197F
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 16:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235308AbiD0NOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 09:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234061AbiD0NOk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 09:14:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70EA512FEFC;
        Wed, 27 Apr 2022 06:11:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 002F861BA7;
        Wed, 27 Apr 2022 13:11:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01B8C385A7;
        Wed, 27 Apr 2022 13:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651065087;
        bh=PedEKEzEg/FHrRmTvSMGppcYG30dIIYwPYjUdRfk9hQ=;
        h=From:To:Cc:Subject:Date:From;
        b=TvQx9hNzUOxJ06abQab28EoROBB8f1SzOpdGqvze4IGM6l56YRI0irkRyCmo5VmO6
         vKhDLzxFWQ5YqRby+iGKDlUGw3BWHUcRcws6uUcI2pdiIi8xaelNZeLYu+VaIy7J/g
         gYc0pdYR/Nrp2mr7UsiHUms/jg8XoJ+++MflEgso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.191
Date:   Wed, 27 Apr 2022 15:11:23 +0200
Message-Id: <165106508323896@kroah.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.191 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/filesystems/ext4/attributes.rst               |    2 
 Makefile                                                    |    2 
 arch/arc/kernel/entry.S                                     |    1 
 arch/arm/mach-vexpress/spc.c                                |    2 
 arch/powerpc/kvm/book3s_64_vio.c                            |   45 ++++---
 arch/powerpc/kvm/book3s_64_vio_hv.c                         |   44 +++----
 arch/powerpc/perf/power9-pmu.c                              |    8 -
 arch/x86/include/asm/compat.h                               |    6 -
 arch/xtensa/kernel/coprocessor.S                            |    4 
 arch/xtensa/kernel/jump_label.c                             |    2 
 block/compat_ioctl.c                                        |    2 
 drivers/ata/pata_marvell.c                                  |    2 
 drivers/dma/at_xdmac.c                                      |   12 +-
 drivers/dma/imx-sdma.c                                      |    4 
 drivers/dma/mediatek/mtk-uart-apdma.c                       |    9 +
 drivers/edac/synopsys_edac.c                                |   16 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c                  |    3 
 drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c       |   13 +-
 drivers/gpu/drm/vc4/vc4_dsi.c                               |    2 
 drivers/net/can/usb/usb_8dev.c                              |   30 ++---
 drivers/net/ethernet/cadence/macb_main.c                    |    8 +
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c          |    8 +
 drivers/net/ethernet/intel/e1000e/ich8lan.c                 |    4 
 drivers/net/ethernet/intel/igc/igc_i225.c                   |   11 +
 drivers/net/ethernet/intel/igc/igc_phy.c                    |    4 
 drivers/net/ethernet/micrel/Kconfig                         |    1 
 drivers/net/vxlan.c                                         |    4 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c     |    2 
 drivers/net/wireless/mediatek/mt76/mt76x2/pci.c             |    2 
 drivers/perf/arm_pmu.c                                      |   10 -
 drivers/platform/x86/samsung-laptop.c                       |    2 
 drivers/reset/tegra/reset-bpmp.c                            |    9 +
 drivers/scsi/qedi/qedi_iscsi.c                              |   69 +++++-------
 drivers/spi/atmel-quadspi.c                                 |    3 
 drivers/staging/android/ion/ion.c                           |    3 
 fs/cifs/cifsfs.c                                            |    2 
 fs/ext4/ext4.h                                              |    4 
 fs/ext4/inode.c                                             |   11 +
 fs/ext4/namei.c                                             |    4 
 fs/ext4/page-io.c                                           |    4 
 fs/ext4/super.c                                             |   19 ++-
 fs/gfs2/rgrp.c                                              |    9 -
 fs/jbd2/commit.c                                            |    4 
 fs/stat.c                                                   |   19 +--
 include/linux/etherdevice.h                                 |    5 
 include/linux/sched.h                                       |    1 
 include/net/inet_hashtables.h                               |    5 
 kernel/trace/trace_events_trigger.c                         |    9 +
 mm/oom_kill.c                                               |   54 ++++++---
 mm/page_alloc.c                                             |    2 
 net/dccp/ipv4.c                                             |    2 
 net/dccp/ipv6.c                                             |    2 
 net/ipv4/inet_connection_sock.c                             |    2 
 net/ipv4/inet_hashtables.c                                  |   68 ++++++++++-
 net/ipv4/tcp_ipv4.c                                         |   13 ++
 net/ipv6/tcp_ipv6.c                                         |   13 ++
 net/l3mdev/l3mdev.c                                         |    2 
 net/netlink/af_netlink.c                                    |    7 +
 net/openvswitch/flow_netlink.c                              |    2 
 net/packet/af_packet.c                                      |   13 +-
 net/rxrpc/net_ns.c                                          |    2 
 net/sched/cls_u32.c                                         |   24 ++--
 net/smc/af_smc.c                                            |    4 
 sound/soc/atmel/sam9g20_wm8731.c                            |   61 ----------
 sound/soc/codecs/msm8916-wcd-digital.c                      |    9 +
 sound/soc/soc-dapm.c                                        |    6 -
 sound/usb/midi.c                                            |    1 
 sound/usb/usbaudio.h                                        |    2 
 tools/testing/selftests/drivers/net/mlxsw/vxlan_flooding.sh |   17 ++
 69 files changed, 459 insertions(+), 292 deletions(-)

Alexey Kardashevskiy (1):
      KVM: PPC: Fix TCE handling for VFIO

Athira Rajeev (1):
      powerpc/perf: Fix power9 event alternatives

Bob Peterson (1):
      gfs2: assign rgrp glock before compute_bitstructs

Borislav Petkov (3):
      ALSA: usb-audio: Fix undefined behavior due to shift overflowing the constant
      mt76: Fix undefined behavior due to shift overflowing the constant
      brcmfmac: sdio: Fix undefined behavior due to shift overflowing the constant

Daniel Bristot de Oliveira (1):
      tracing: Dump stacktrace trigger to the corresponding instance

Dave Stevenson (2):
      drm/panel/raspberrypi-touchscreen: Avoid NULL deref if not initialised
      drm/panel/raspberrypi-touchscreen: Initialise the bridge in prepare

David Ahern (1):
      l3mdev: l3mdev_master_upper_ifindex_by_index_rcu should be using netdev_master_upper_dev_get_rcu

David Howells (2):
      rxrpc: Restore removed timer deletion
      cifs: Check the IOCB_DIRECT flag, not O_DIRECT

Eric Dumazet (3):
      net/sched: cls_u32: fix netns refcount changes in u32_change()
      net/sched: cls_u32: fix possible leak in u32_init_knode()
      netlink: reset network and mac headers in netlink_dump()

Greg Kroah-Hartman (1):
      Linux 5.4.191

Guo Ren (1):
      xtensa: patch_text: Fixup last cpu should be master

Hangbin Liu (1):
      net/packet: fix packet_sock xmit return value checking

Hangyu Hua (1):
      can: usb_8dev: usb_8dev_start_xmit(): fix double dev_kfree_skb() in error path

Hongbin Wang (1):
      vxlan: fix error return code in vxlan_fdb_append

Ido Schimmel (1):
      selftests: mlxsw: vxlan_flooding: Prevent flooding of unwanted packets

Jiapeng Chong (1):
      platform/x86: samsung-laptop: Fix an unsigned comparison which can never be negative

Kees Cook (2):
      etherdevice: Adjust ether_addr* prototypes to silence -Wstringop-overead
      ARM: vexpress/spc: Avoid negative array index when !SMP

Khazhismel Kumykov (1):
      block/compat_ioctl: fix range check in BLKGETSIZE

Kuniyuki Iwashima (1):
      tcp: Fix potential use-after-free due to double kfree()

Lee Jones (1):
      staging: ion: Prevent incorrect reference counting behavour

Lv Ruyi (1):
      dpaa_eth: Fix missing of_node_put in dpaa_get_ts_info()

Marek Vasut (1):
      Revert "net: micrel: fix KS8851_MLL Kconfig"

Mark Brown (1):
      ASoC: atmel: Remove system clock tree configuration for at91sam9g20ek

Max Filippov (1):
      xtensa: fix a7 clobbering in coprocessor context load/store

Miaoqian Lin (3):
      ASoC: msm8916-wcd-digital: Check failure for devm_snd_soc_register_component
      dmaengine: imx-sdma: Fix error checking in sdma_event_remap
      drm/vc4: Use pm_runtime_resume_and_get to fix pm_runtime_get_sync() usage

Mike Christie (1):
      scsi: qedi: Fix failed disconnect handling

Mikulas Patocka (1):
      stat: fix inconsistency between struct stat and struct compat_stat

Nico Pache (1):
      oom_kill.c: futex: delay the OOM reaper to allow time for proper futex cleanup

Paolo Valerio (1):
      openvswitch: fix OOB access in reserve_sfa_size()

Ricardo Dias (1):
      tcp: fix race condition when creating child sockets from syncookies

Rob Herring (1):
      arm_pmu: Validate single/group leader events

Sameer Pujar (1):
      reset: tegra-bpmp: Restore Handle errors in BPMP response

Sasha Neftin (3):
      igc: Fix infinite loop in release_swfw_sync
      igc: Fix BUG: scheduling while atomic
      e1000e: Fix possible overflow in LTR decoding

Sergey Matyukevich (1):
      ARC: entry: fix syscall_trace_exit argument

Shubhrajyoti Datta (1):
      EDAC/synopsys: Read the error count from the correct register

Tadeusz Struk (1):
      ext4: limit length to bitmap_maxbytes - blocksize in punch_hole

Takashi Iwai (1):
      ALSA: usb-audio: Clear MIDI port active flag after draining

Theodore Ts'o (2):
      ext4: fix overhead calculation to account for the reserved gdt blocks
      ext4: force overhead calculation if the s_overhead_cluster makes no sense

Tomas Melin (1):
      net: macb: Restart tx only if queue pointer is lagging

Tony Lu (1):
      net/smc: Fix sock leak when release after smc_shutdown()

Tudor Ambarus (1):
      spi: atmel-quadspi: Fix the buswidth adjustment between spi-mem and controller

Xiaoke Wang (1):
      drm/msm/mdp5: check the return of kzalloc()

Xiaomeng Tong (2):
      dma: at_xdmac: fix a missing check on list iterator
      ASoC: soc-dapm: fix two incorrect uses of list iterator

Xiongwei Song (1):
      mm: page_alloc: fix building error on -Werror=array-compare

Ye Bin (3):
      ext4: fix symlink file size not match to file content
      ext4: fix use-after-free in ext4_search_dir
      jbd2: fix a potential race while discarding reserved buffers after an abort

Zheyu Ma (1):
      ata: pata_marvell: Check the 'bmdma_addr' beforing reading

wangjianjian (C) (1):
      ext4, doc: fix incorrect h_reserved size

zhangqilong (1):
      dmaengine: mediatek:Fix PM usage reference leak of mtk_uart_apdma_alloc_chan_resources

