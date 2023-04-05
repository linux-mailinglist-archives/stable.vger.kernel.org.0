Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E0D6D78D1
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 11:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237844AbjDEJtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 05:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237701AbjDEJsF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 05:48:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6924B5259;
        Wed,  5 Apr 2023 02:47:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D594263C4C;
        Wed,  5 Apr 2023 09:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1552C433D2;
        Wed,  5 Apr 2023 09:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680688042;
        bh=acIYug03y45Q1gBTCjEO7sbP206sgBTPE6BHi/wDRjo=;
        h=From:To:Cc:Subject:Date:From;
        b=Q2ygWfIW13zsRaLLP63Eal7TPb6u8Frvp/6HHbshHq3I/UDzFVAOauVP6+lXtu71G
         czgy8dwEzn8nD6zaaHkBImlAKwz7hsYuc1ins23KRuUajkbpMvL7sy6oR1KmiFk9k1
         ltMdn0EDAS6Xb+FM5QGQk8mEqsTXiBAP6CAhJoE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.106
Date:   Wed,  5 Apr 2023 11:47:15 +0200
Message-Id: <2023040515-monorail-everglade-9a41@gregkh>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.106 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                         |    2 
 arch/arm64/kvm/mmu.c                                             |   45 ++
 arch/mips/bmips/dma.c                                            |    5 
 arch/mips/bmips/setup.c                                          |    8 
 arch/powerpc/kernel/ptrace/ptrace-view.c                         |    6 
 arch/s390/lib/uaccess.c                                          |    2 
 arch/x86/kvm/lapic.c                                             |   11 
 arch/x86/kvm/vmx/vmx.c                                           |    6 
 arch/x86/kvm/x86.c                                               |   21 +
 arch/x86/xen/Makefile                                            |    2 
 arch/x86/xen/enlighten_pv.c                                      |    3 
 arch/x86/xen/enlighten_pvh.c                                     |   13 
 arch/x86/xen/vga.c                                               |    5 
 arch/x86/xen/xen-ops.h                                           |    7 
 arch/xtensa/kernel/traps.c                                       |   16 
 drivers/block/loop.c                                             |   21 +
 drivers/bus/imx-weim.c                                           |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c      |   19 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h      |   12 
 drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c                      |   10 
 drivers/gpu/drm/i915/display/intel_tc.c                          |    4 
 drivers/input/mouse/alps.c                                       |   16 
 drivers/input/mouse/focaltech.c                                  |    8 
 drivers/input/touchscreen/goodix.c                               |   14 
 drivers/iommu/intel/dmar.c                                       |    3 
 drivers/md/md.c                                                  |    3 
 drivers/mtd/nand/raw/meson_nand.c                                |    8 
 drivers/net/dsa/microchip/ksz8863_smi.c                          |    9 
 drivers/net/dsa/mv88e6xxx/chip.c                                 |    9 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                        |    8 
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                        |    1 
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c                |    3 
 drivers/net/ethernet/intel/i40e/i40e_diag.c                      |   11 
 drivers/net/ethernet/intel/i40e/i40e_diag.h                      |    2 
 drivers/net/ethernet/intel/ice/ice_sched.c                       |    8 
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c               |   73 ++++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c                   |   30 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c                   |   86 ++---
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c                  |    3 
 drivers/net/ethernet/realtek/r8169_phy_config.c                  |    3 
 drivers/net/ethernet/sfc/ef10.c                                  |   38 +-
 drivers/net/ethernet/sfc/efx.c                                   |   17 
 drivers/net/ethernet/smsc/smsc911x.c                             |    7 
 drivers/net/ethernet/stmicro/stmmac/common.h                     |    1 
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c                |   61 ---
 drivers/net/ieee802154/ca8210.c                                  |    3 
 drivers/net/ipa/gsi_trans.c                                      |    2 
 drivers/net/net_failover.c                                       |    8 
 drivers/net/phy/dp83869.c                                        |    6 
 drivers/net/xen-netback/common.h                                 |    2 
 drivers/net/xen-netback/netback.c                                |   25 +
 drivers/pinctrl/pinctrl-amd.c                                    |   36 +-
 drivers/pinctrl/pinctrl-at91-pio4.c                              |    1 
 drivers/pinctrl/pinctrl-ocelot.c                                 |    2 
 drivers/platform/x86/intel/pmc/core.c                            |   13 
 drivers/platform/x86/think-lmi.c                                 |   60 +++
 drivers/ptp/ptp_qoriq.c                                          |    2 
 drivers/regulator/fixed.c                                        |    2 
 drivers/s390/crypto/vfio_ap_drv.c                                |    3 
 drivers/scsi/megaraid/megaraid_sas_fusion.c                      |    4 
 drivers/scsi/mpt3sas/mpt3sas_base.c                              |    5 
 drivers/usb/dwc3/gadget.c                                        |   79 ++--
 drivers/video/fbdev/au1200fb.c                                   |    3 
 drivers/video/fbdev/geode/lxfb_core.c                            |    3 
 drivers/video/fbdev/intelfb/intelfbdrv.c                         |    3 
 drivers/video/fbdev/nvidia/nvidia.c                              |    2 
 drivers/video/fbdev/tgafb.c                                      |    3 
 fs/btrfs/ioctl.c                                                 |    2 
 fs/btrfs/qgroup.c                                                |   11 
 fs/btrfs/volumes.c                                               |   11 
 fs/cifs/cifsfs.h                                                 |    5 
 fs/cifs/cifssmb.c                                                |    9 
 fs/ksmbd/connection.c                                            |    4 
 fs/ksmbd/connection.h                                            |    3 
 fs/ksmbd/transport_rdma.c                                        |    2 
 fs/ksmbd/transport_tcp.c                                         |   35 +-
 fs/nfs/nfs4proc.c                                                |    5 
 fs/verity/enable.c                                               |   24 -
 fs/zonefs/super.c                                                |   16 
 include/trace/events/rcu.h                                       |    2 
 include/xen/interface/platform.h                                 |    3 
 kernel/compat.c                                                  |    2 
 kernel/kcsan/Makefile                                            |    3 
 kernel/sched/core.c                                              |    4 
 kernel/trace/kprobe_event_gen_test.c                             |    4 
 net/can/bcm.c                                                    |   16 
 net/can/j1939/transport.c                                        |    8 
 net/hsr/hsr_framereg.c                                           |    2 
 net/sunrpc/xprtsock.c                                            |    1 
 net/xfrm/xfrm_user.c                                             |   45 ++
 sound/core/pcm_lib.c                                             |    2 
 sound/pci/asihpi/hpi6205.c                                       |    2 
 sound/pci/hda/patch_ca0132.c                                     |    4 
 sound/pci/hda/patch_conexant.c                                   |    6 
 sound/pci/hda/patch_realtek.c                                    |    5 
 sound/pci/ymfpci/ymfpci.c                                        |    2 
 sound/pci/ymfpci/ymfpci_main.c                                   |    2 
 sound/soc/codecs/lpass-tx-macro.c                                |   11 
 sound/usb/endpoint.c                                             |   22 -
 sound/usb/endpoint.h                                             |    4 
 sound/usb/format.c                                               |    8 
 sound/usb/pcm.c                                                  |    2 
 tools/lib/bpf/btf_dump.c                                         |  154 ++++++---
 tools/power/x86/turbostat/turbostat.8                            |    2 
 tools/power/x86/turbostat/turbostat.c                            |    4 
 tools/testing/selftests/bpf/progs/btf_dump_test_case_bitfields.c |    2 
 tools/testing/selftests/bpf/progs/btf_dump_test_case_packing.c   |   80 ++++
 tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c   |  171 ++++++++--
 108 files changed, 1156 insertions(+), 453 deletions(-)

Alex Elder (1):
      net: ipa: compute DMA pool size properly

Alyssa Ross (1):
      loop: LOOP_CONFIGURE: send uevents for partitions

Anand Jain (1):
      btrfs: scan device in non-exclusive mode

Anders Roxell (1):
      kernel: kcsan: kcsan_test: build without structleak plugin

Andrii Nakryiko (3):
      libbpf: Fix BTF-to-C converter's padding logic
      selftests/bpf: Add few corner cases to test padding handling of btf_dump
      libbpf: Fix btf_dump's packed struct determination

Anton Gusev (1):
      tracing: Fix wrong return in kprobe_event_gen_test.c

Antti Laakso (1):
      tools/power turbostat: fix decoding of HWP_STATUS

Arseniy Krasnov (1):
      mtd: rawnand: meson: invalidate cache on polling ECC bit

Christoph Hellwig (1):
      loop: suppress uevents while reconfiguring the device

Christophe JAILLET (1):
      regulator: Handle deferred clk

ChunHao Lin (1):
      r8169: fix RTL8168H and RTL8107E rx crc error

Damien Le Moal (2):
      zonefs: Always invalidate last cached page on append write
      zonefs: Fix error message in zonefs_file_dio_append()

David Disseldorp (1):
      cifs: fix DFS traversal oops without CONFIG_CIFS_DFS_UPCALL

Douglas Raillard (1):
      rcu: Fix rcu_torture_read ftrace event

Eduard Zingerman (1):
      selftests/bpf: Test btf dump for struct with padding only fields

Eric Biggers (1):
      fsverity: don't drop pagecache at end of FS_IOC_ENABLE_VERITY

Faicker Mo (1):
      net/net_failover: fix txq exceeding warning

Fangzhi Zuo (1):
      drm/amd/display: Add DSC Support for Synaptics Cascaded MST Hub

Felix Fietkau (1):
      net: ethernet: mtk_eth_soc: fix flow block refcounting logic

Filipe Manana (1):
      btrfs: fix race between quota disable and quota assign ioctls

Greg Kroah-Hartman (1):
      Linux 5.15.106

Hans de Goede (1):
      Input: goodix - add Lenovo Yoga Book X90F to nine_bytes_report DMI table

Harshit Mogalapalli (1):
      ca8210: Fix unsigned mac_len comparison with zero in ca8210_skb_tx()

Heiko Carstens (1):
      s390/uaccess: add missing earlyclobber annotations to __clear_user()

Herbert Xu (1):
      xfrm: Zero padding when dumping algos and encap

Horatiu Vultur (1):
      pinctrl: ocelot: Fix alt mode for ocelot

Imre Deak (1):
      drm/i915/tc: Fix the ICL PHY ownership check in TC-cold state

Ivan Bornyakov (1):
      bus: imx-weim: fix branch condition evaluates to a garbage value

Ivan Orlov (1):
      can: bcm: bcm_tx_setup(): fix KMSAN uninit-value in vfs_write

Jakob Koschel (1):
      ice: fix invalid check for empty list in ice_sched_assoc_vsi_to_agg()

Jan Beulich (2):
      x86/PVH: obtain VGA console info in Dom0
      x86/PVH: avoid 32-bit build warning when obtaining VGA console info

Jason A. Donenfeld (1):
      Input: focaltech - use explicitly signed char type

Jens Axboe (1):
      powerpc: Don't try to copy PPR for task with NULL pt_regs

Jerry Snitselaar (1):
      scsi: mpt3sas: Don't print sense pool info twice

Johan Hovold (1):
      pinctrl: at91-pio4: fix domain name assignment

Josua Mayer (1):
      net: phy: dp83869: fix default value for tx-/rx-internal-delay

Juergen Gross (1):
      xen/netback: don't do grant copy across page boundary

Junfeng Guo (1):
      ice: add profile conflict check for AVF FDIR

Kalesh AP (2):
      bnxt_en: Fix reporting of test result in ethtool selftest
      bnxt_en: Fix typo in PCI id to device description string mapping

Kornel Dulęba (1):
      pinctrl: amd: Disable and mask interrupts on resume

Kristian Overskeid (1):
      net: hsr: Don't log netdev_err message on unknown prp dst node

Kuninori Morimoto (2):
      ALSA: asihpi: check pao in control_message()
      ALSA: hda/ca0132: fixup buffer overrun at tuning_ctl_set()

Linus Torvalds (1):
      sched_getaffinity: don't assume 'cpumask_size()' is fully initialized

Lu Baolu (1):
      iommu/vt-d: Allow zero SAGAW if second-stage not supported

Lucas Stach (1):
      drm/etnaviv: fix reference leak when mmaping imported buffer

Marc Zyngier (1):
      KVM: arm64: Disable interrupts while walking userspace PTs

Marco Elver (1):
      kcsan: avoid passing -g for test

Mark Pearson (4):
      platform/x86: think-lmi: add missing type attribute
      platform/x86: think-lmi: use correct possible_values delimiters
      platform/x86: think-lmi: only display possible_values if available
      platform/x86: think-lmi: Add possible_values for ThinkStation

Matthieu Baerts (1):
      hsr: ratelimit only when errors are printed

Max Filippov (1):
      xtensa: fix KASAN report for show_stack

Michael Chan (1):
      bnxt_en: Add missing 200G link speed reporting

Michael Grzeschik (1):
      usb: dwc3: gadget: move cmd_endtransfer to extra function

Namjae Jeon (1):
      ksmbd: don't terminate inactive sessions after a few seconds

NeilBrown (1):
      md: avoid signed overflow in slot_store()

Oleksij Rempel (2):
      net: dsa: microchip: ksz8863_smi: fix bulk access
      can: j1939: prevent deadlock by moving j1939_sk_errqueue()

Paulo Alcantara (1):
      cifs: prevent infinite recursion in CIFSGetDFSRefer()

Prarit Bhargava (1):
      tools/power turbostat: Fix /dev/cpu_dma_latency warnings

Radoslaw Tyl (1):
      i40e: fix registers dump after run ethtool adapter self test

Rajvi Jingar (1):
      platform/x86/intel/pmc: Alder Lake PCH slp_s0_residency fix

Ravulapati Vishnu Vardhan Rao (1):
      ASoC: codecs: tx-macro: Fix for KASAN: slab-out-of-bounds

Sean Christopherson (3):
      KVM: VMX: Move preemption timer <=> hrtimer dance to common x86
      KVM: x86: Inject #GP on x2APIC WRMSR that sets reserved bits 63:32
      KVM: x86: Purge "highest ISR" cache when updating APICv state

Siddharth Kawar (1):
      SUNRPC: fix shutdown of NFS TCP client socket

SongJingyi (1):
      ptp_qoriq: fix memory leak in probe()

Steffen Bätz (1):
      net: dsa: mv88e6xxx: Enable IGMP snooping on user ports only

Sven Auhagen (3):
      net: mvpp2: classifier flow fix fragmentation flags
      net: mvpp2: parser fix QinQ
      net: mvpp2: parser fix PPPoE

Takashi Iwai (3):
      ALSA: usb-audio: Fix recursive locking at XRUN during syncing
      ALSA: hda/conexant: Partial revert of a quirk for Lenovo
      ALSA: usb-audio: Fix regression on detection of Roland VS-100

Tasos Sahanidis (2):
      ALSA: ymfpci: Create card with device-managed snd_devm_card_new()
      ALSA: ymfpci: Fix BUG_ON in probe function

Tim Crawford (1):
      ALSA: hda/realtek: Add quirks for some Clevo laptops

Tomas Henzl (1):
      scsi: megaraid_sas: Fix crash after a double completion

Tony Krowiak (1):
      s390/vfio-ap: fix memory leak in vfio_ap device driver

Trond Myklebust (1):
      NFSv4: Fix hangs when recovering open state after a server reboot

Vladimir Oltean (1):
      net: stmmac: don't reject VLANs when IFF_PROMISC is set

Wei Chen (5):
      fbdev: tgafb: Fix potential divide by zero
      fbdev: nvidia: Fix potential divide by zero
      fbdev: intelfb: Fix potential divide by zero
      fbdev: lxfb: Fix potential divide by zero
      fbdev: au1200fb: Fix potential divide by zero

Wesley Cheng (1):
      usb: dwc3: gadget: Add 1ms delay after end transfer command without IOC

Wolfram Sang (1):
      smsc911x: avoid PHY being resumed when interface is not up

huangwenhui (1):
      ALSA: hda/realtek: Add quirk for Lenovo ZhaoYang CF4620Z

msizanoen (1):
      Input: alps - fix compatibility with -funsigned-char

Álvaro Fernández Rojas (1):
      mips: bmips: BCM6358: disable RAC flush for TP1

Íñigo Huguet (1):
      sfc: ef10: don't overwrite offload features at NIC reset

