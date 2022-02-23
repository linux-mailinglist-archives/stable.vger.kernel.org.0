Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C59214C1277
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 13:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240391AbiBWMJw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 07:09:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240394AbiBWMIC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 07:08:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 059029A9A6;
        Wed, 23 Feb 2022 04:07:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 958E5B81F00;
        Wed, 23 Feb 2022 12:07:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A87C340E7;
        Wed, 23 Feb 2022 12:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645618041;
        bh=1KtZQIWl9Qod0JWGkaUtgM74fomJx/+2g4B3zftgx4A=;
        h=From:To:Cc:Subject:Date:From;
        b=tJhiXjvw7UEvi+dfTl1O/YlkObfEV2kInpIEbqcJ5n0UWcPubnpze2ywyCcGmHviA
         rXmfpPzuzQL+7Lt4lSlIYRT3cwp+g/w2YO4OwF/kJio25ysxonB/PzcWwo1CwJmFsg
         qJD9CqQkKScYPgSlBPRm78mqR1YpvOiHgEY+LSWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.102
Date:   Wed, 23 Feb 2022 13:07:04 +0100
Message-Id: <164561802556115@kroah.com>
X-Mailer: git-send-email 2.35.1
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

I'm announcing the release of the 5.10.102 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                    |    2 
 arch/arm/mach-omap2/display.c                               |    2 
 arch/arm/mach-omap2/omap_hwmod.c                            |    4 
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi           |    6 
 arch/arm64/boot/dts/amlogic/meson-g12a-sei510.dts           |    8 
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi                   |    6 
 arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dts            |    8 
 arch/parisc/lib/iomap.c                                     |   18 +
 arch/parisc/mm/init.c                                       |    9 
 arch/powerpc/lib/sstep.c                                    |    2 
 arch/x86/kvm/pmu.c                                          |   15 -
 arch/x86/kvm/pmu.h                                          |    3 
 arch/x86/kvm/svm/avic.c                                     |    2 
 arch/x86/kvm/svm/pmu.c                                      |    8 
 arch/x86/kvm/svm/svm.c                                      |    7 
 arch/x86/kvm/vmx/pmu_intel.c                                |    9 
 arch/x86/xen/enlighten_pv.c                                 |    4 
 arch/x86/xen/smp_pv.c                                       |   26 --
 block/bfq-iosched.c                                         |    2 
 block/elevator.c                                            |    2 
 drivers/ata/libata-core.c                                   |    1 
 drivers/char/random.c                                       |    5 
 drivers/dma/sh/rcar-dmac.c                                  |    9 
 drivers/dma/stm32-dmamux.c                                  |    4 
 drivers/edac/edac_mc.c                                      |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c                     |    2 
 drivers/gpu/drm/i915/Kconfig                                |    1 
 drivers/gpu/drm/i915/display/intel_opregion.c               |   15 +
 drivers/gpu/drm/nouveau/nvkm/falcon/base.c                  |    8 
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gm200.c             |   31 ++
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gm20b.c             |    2 
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp102.c             |    2 
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp10b.c             |    2 
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/priv.h              |    2 
 drivers/gpu/drm/radeon/atombios_encoders.c                  |    3 
 drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c                 |   14 -
 drivers/hid/hid-ids.h                                       |    1 
 drivers/hid/hid-quirks.c                                    |    1 
 drivers/hv/vmbus_drv.c                                      |    5 
 drivers/i2c/busses/i2c-brcmstb.c                            |    2 
 drivers/i2c/busses/i2c-qcom-cci.c                           |   16 -
 drivers/irqchip/irq-sifive-plic.c                           |    1 
 drivers/mmc/core/block.c                                    |   28 +-
 drivers/mtd/nand/raw/brcmnand/brcmnand.c                    |    2 
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c                  |    3 
 drivers/mtd/nand/raw/qcom_nandc.c                           |   14 -
 drivers/net/bonding/bond_3ad.c                              |   30 ++
 drivers/net/bonding/bond_main.c                             |    5 
 drivers/net/dsa/lan9303-core.c                              |    2 
 drivers/net/dsa/lantiq_gswip.c                              |    2 
 drivers/net/ethernet/cadence/macb_main.c                    |    2 
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c            |    2 
 drivers/net/ieee802154/at86rf230.c                          |   13 -
 drivers/net/ieee802154/ca8210.c                             |    4 
 drivers/net/usb/qmi_wwan.c                                  |    2 
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c                |    2 
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c        |    3 
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c             |    3 
 drivers/nvme/host/core.c                                    |    9 
 drivers/nvme/host/rdma.c                                    |    1 
 drivers/nvme/host/tcp.c                                     |    1 
 drivers/parisc/ccio-dma.c                                   |    3 
 drivers/parisc/sba_iommu.c                                  |    3 
 drivers/pci/controller/pci-hyperv.c                         |   13 -
 drivers/phy/broadcom/phy-brcm-usb.c                         |   38 +++
 drivers/platform/x86/intel_speed_select_if/isst_if_common.c |   97 +++++---
 drivers/platform/x86/touchscreen_dmi.c                      |   24 ++
 drivers/scsi/lpfc/lpfc.h                                    |    1 
 drivers/scsi/lpfc/lpfc_attr.c                               |    3 
 drivers/scsi/lpfc/lpfc_els.c                                |   20 +
 drivers/scsi/lpfc/lpfc_nportdisc.c                          |    5 
 drivers/scsi/lpfc/lpfc_sli.c                                |   15 +
 drivers/scsi/pm8001/pm8001_sas.c                            |    5 
 drivers/scsi/pm8001/pm80xx_hwi.c                            |    4 
 drivers/soc/aspeed/aspeed-lpc-ctrl.c                        |    7 
 drivers/tty/n_tty.c                                         |    6 
 drivers/tty/serial/8250/8250_gsc.c                          |    2 
 fs/btrfs/send.c                                             |    4 
 fs/file.c                                                   |   72 +++++-
 fs/nfs/dir.c                                                |    4 
 fs/nfs/inode.c                                              |   23 +-
 fs/proc/task_mmu.c                                          |   43 ++-
 fs/quota/dquot.c                                            |   11 
 fs/super.c                                                  |   19 +
 include/linux/memcontrol.h                                  |    5 
 include/linux/netdevice.h                                   |    2 
 include/linux/sched.h                                       |    1 
 include/net/bond_3ad.h                                      |    2 
 include/net/ipv6.h                                          |    5 
 include/net/netns/ipv6.h                                    |    3 
 include/uapi/linux/can/isotp.h                              |    2 
 kernel/async.c                                              |    3 
 kernel/fork.c                                               |    7 
 kernel/locking/lockdep.c                                    |    4 
 kernel/module.c                                             |   25 --
 kernel/rcu/tree_plugin.h                                    |    2 
 kernel/stackleak.c                                          |    5 
 kernel/trace/trace.c                                        |    4 
 lib/iov_iter.c                                              |    2 
 mm/memcontrol.c                                             |   10 
 mm/mprotect.c                                               |    2 
 net/ax25/af_ax25.c                                          |    9 
 net/can/isotp.c                                             |   71 ++++--
 net/core/drop_monitor.c                                     |   11 
 net/core/rtnetlink.c                                        |    6 
 net/ipv4/ping.c                                             |   11 
 net/ipv6/ip6_flowlabel.c                                    |    4 
 net/netfilter/nf_conntrack_proto_sctp.c                     |    9 
 net/netfilter/nft_synproxy.c                                |    4 
 net/sched/act_api.c                                         |   13 -
 net/sched/cls_api.c                                         |    6 
 net/sched/sch_api.c                                         |   22 +
 net/sched/sch_generic.c                                     |   29 +-
 net/sunrpc/xprtrdma/verbs.c                                 |    3 
 net/vmw_vsock/af_vsock.c                                    |    1 
 scripts/kconfig/confdata.c                                  |   13 -
 scripts/kconfig/preprocess.c                                |    2 
 scripts/module.lds.S                                        |   26 ++
 sound/pci/hda/hda_intel.c                                   |    5 
 sound/pci/hda/patch_realtek.c                               |   40 ++-
 sound/soc/codecs/tas2770.c                                  |    7 
 sound/soc/soc-ops.c                                         |   29 +-
 tools/lib/subcmd/subcmd-util.h                              |   11 
 tools/perf/util/bpf-loader.c                                |    3 
 tools/testing/selftests/clone3/clone3.c                     |    2 
 tools/testing/selftests/exec/Makefile                       |    4 
 tools/testing/selftests/kselftest_harness.h                 |    4 
 tools/testing/selftests/mincore/mincore_selftest.c          |   20 +
 tools/testing/selftests/netfilter/nft_concat_range.sh       |    2 
 tools/testing/selftests/openat2/Makefile                    |    2 
 tools/testing/selftests/openat2/helpers.h                   |   12 -
 tools/testing/selftests/openat2/openat2_test.c              |   12 -
 tools/testing/selftests/pidfd/pidfd.h                       |   13 -
 tools/testing/selftests/pidfd/pidfd_fdinfo_test.c           |   22 +
 tools/testing/selftests/pidfd/pidfd_test.c                  |    6 
 tools/testing/selftests/pidfd/pidfd_wait.c                  |    5 
 tools/testing/selftests/rtc/settings                        |    2 
 tools/testing/selftests/zram/zram.sh                        |   15 -
 tools/testing/selftests/zram/zram01.sh                      |   33 --
 tools/testing/selftests/zram/zram02.sh                      |    1 
 tools/testing/selftests/zram/zram_lib.sh                    |  134 +++++++-----
 141 files changed, 1020 insertions(+), 510 deletions(-)

Al Cooper (1):
      phy: usb: Leave some clocks running during suspend

Alexey Khoroshilov (1):
      net: dsa: lantiq_gswip: fix use after free in gswip_remove()

Anders Roxell (1):
      powerpc/lib/sstep: fix 'ptesync' build error

Andy Shevchenko (1):
      parisc: Add ioread64_lo_hi() and iowrite64_lo_hi()

Arnaldo Carvalho de Melo (1):
      perf bpf: Defer freeing string after possible strlen() on it

Axel Rasmussen (2):
      pidfd: fix test failure due to stack overflow on some arches
      selftests: fixup build warnings in pidfd / clone3 tests

Ben Skeggs (1):
      drm/nouveau/pmu/gm200-: use alternate falcon reset sequence

Brenda Streiff (1):
      kconfig: let 'shell' return enough output for deep path names

Bryan O'Donoghue (1):
      mtd: rawnand: qcom: Fix clock sequencing in qcom_nandc_probe()

Cheng Jui Wang (1):
      lockdep: Correct lock_classes index mapping

Christian Eggers (1):
      mtd: rawnand: gpmi: don't leak PM reference in error path

Christian Hewitt (3):
      arm64: dts: meson-gx: add ATF BL32 reserved-memory region
      arm64: dts: meson-g12: add ATF BL32 reserved-memory region
      arm64: dts: meson-g12: drop BL32 region from SEI510/SEI610

Christian König (1):
      drm/amdgpu: fix logic inversion in check

Christian Löhle (1):
      mmc: block: fix read single on recovery logic

Cristian Marussi (4):
      selftests: openat2: Print also errno in failure messages
      selftests: openat2: Add missing dependency in Makefile
      selftests: openat2: Skip testcases that fail with EOPNOTSUPP
      selftests: skip mincore.check_file_mmap when fs lacks needed support

Dan Aloni (1):
      xprtrdma: fix pointer derefs in error cases of rpcrdma_ep_create

Darrick J. Wong (2):
      vfs: make freeze_super abort when sync_filesystem returns error
      quota: make dquot_quota_sync return errors from ->sync_fs

Duoming Zhou (1):
      ax25: improve the incomplete fix to avoid UAF and NPD bugs

Dāvis Mosāns (1):
      btrfs: send: in case of IO error log it

Eliav Farber (1):
      EDAC: Fix calculation of returned address and next offset in edac_align_ptr()

Eric Dumazet (4):
      drop_monitor: fix data-race in dropmon_net_event / trace_napi_poll_hit
      net_sched: add __rcu annotation to netdev->qdisc
      bonding: fix data-races around agg_select_timer
      net: sched: limit TC_ACT_REPEAT loops

Florian Westphal (1):
      netfilter: conntrack: don't refresh sctp entries in closed state

Greg Kroah-Hartman (1):
      Linux 5.10.102

Guo Ren (1):
      irqchip/sifive-plic: Add missing thead,c900-plic match string

Hangbin Liu (1):
      selftests: netfilter: fix exit value for nft_concat_range

Igor Pylypiv (1):
      Revert "module, async: async_synchronize_full() on module init iff async is used"

Jae Hyun Yoo (1):
      soc: aspeed: lpc-ctrl: Block error printing on probe defer cases

JaeSang Yoo (1):
      tracing: Fix tp_printk option related with tp_printk_stop_on_boot

James Smart (2):
      scsi: lpfc: Fix mailbox command failure during driver initialization
      scsi: lpfc: Fix pt2pt NVMe PRLI reject LOGO loop

Jan Beulich (1):
      x86/Xen: streamline (and fix) PV CPU enumeration

Jani Nikula (1):
      drm/i915/opregion: check port number bounds for SWSCI display power state

Jason A. Donenfeld (1):
      random: wake up /dev/random writers after zap

Jiasheng Jiang (2):
      dmaengine: sh: rcar-dmac: Check for error num after setting mask
      dmaengine: sh: rcar-dmac: Check for error num after dma_set_max_seg_size

Jim Mattson (2):
      KVM: x86/pmu: Don't truncate the PerfEvtSeln MSR when creating a perf event
      KVM: x86/pmu: Use AMD64_RAW_EVENT_MASK for PERF_TYPE_RAW

Jing Leng (1):
      kconfig: fix failing to generate auto.conf

Johannes Berg (3):
      iwlwifi: fix use-after-free
      iwlwifi: pcie: fix locking when "HW not ready"
      iwlwifi: pcie: gen2: fix locking when "HW not ready"

John David Anglin (3):
      parisc: Drop __init from map_pages declaration
      parisc: Fix data TLB miss in sba_unmap_sg
      parisc: Fix sglist access in ccio-dma.c

John Garry (2):
      scsi: pm8001: Fix use-after-free for aborted TMF sas_task
      scsi: pm8001: Fix use-after-free for aborted SSP/STP sas_task

Kees Cook (2):
      gcc-plugins/stackleak: Use noinstr in favor of notrace
      libsubcmd: Fix use-after-free for realloc(..., 0)

Laibin Qiu (1):
      block/wbt: fix negative inflight counter when remove scsi device

Li Zhijian (1):
      kselftest: signal all child processes

Like Xu (1):
      KVM: x86/pmu: Refactoring find_arch_event() to pmc_perf_hw_id()

Linus Torvalds (3):
      fget: clarify and improve __fget_files() implementation
      mm: don't try to NUMA-migrate COW pages that have other uses
      tty: n_tty: do not look ahead for EOL character past the end of the buffer

Long Li (1):
      PCI: hv: Fix NUMA node assignment when kernel boots with custom NUMA topology

Mans Rullgard (1):
      net: dsa: lan9303: fix reset on probe

Marc St-Amand (1):
      net: macb: Align the dma and coherent dma masks

Mark Brown (2):
      ASoC: ops: Fix stereo change notifications in snd_soc_put_volsw()
      ASoC: ops: Fix stereo change notifications in snd_soc_put_volsw_range()

Martin Povišer (1):
      ASoC: tas2770: Insert post reset delay

Max Kellermann (1):
      lib/iov_iter: initialize "flags" in new pipe_buffer

Miaoqian Lin (2):
      Drivers: hv: vmbus: Fix memory leak in vmbus_add_channel_kobj
      dmaengine: stm32-dmamux: Fix PM disable depth imbalance in stm32_dmamux_probe

Miquel Raynal (2):
      net: ieee802154: at86rf230: Stop leaking skb's
      net: ieee802154: ca8210: Fix lifs/sifs periods

Muhammad Usama Anjum (1):
      selftests/exec: Add non-regular to TEST_GEN_PROGS

Nicholas Bishop (1):
      drm/radeon: Fix backlight control on iMac 12,1

Norbert Slusarek (1):
      can: isotp: prevent race between isotp_bind() and isotp_setsockopt()

Nícolas F. R. A. Prado (1):
      selftests: rtc: Increase test timeout so that all tests run

Oliver Hartkopp (1):
      can: isotp: add SF_BROADCAST support for functional addressing

Pablo Neira Ayuso (1):
      netfilter: nft_synproxy: unregister hooks on init error path

Paul E. McKenney (1):
      rcu: Do not report strict GPs for outgoing CPUs

Radu Bulie (1):
      dpaa2-eth: Initialize mutex used in one step timestamping path

Rafał Miłecki (1):
      i2c: brcmstb: fix support for DSL and CM variants

Randy Dunlap (1):
      serial: parisc: GSC: fix build when IOSAPIC is not set

Roman Gushchin (1):
      mm: memcg: synchronize objcg lists with a dedicated spinlock

Sagi Grimberg (3):
      nvme: fix a possible use-after-free in controller reset during load
      nvme-tcp: fix possible use-after-free in transport error_recovery work
      nvme-rdma: fix possible use-after-free in transport error_recovery work

Sami Tolvanen (1):
      kbuild: lto: merge module sections

Sascha Hauer (1):
      drm/rockchip: dw_hdmi: Do not leave clock enabled in error case

Sean Christopherson (3):
      Revert "svm: Add warning message for AVIC IPI invalid target"
      kbuild: lto: Merge module sections if and only if CONFIG_LTO_CLANG is enabled
      KVM: SVM: Never reject emulation due to SMAP errata for !SEV guests

Sergio Costas (1):
      HID:Add support for UGTABLET WP5540

Seth Forshee (1):
      vsock: remove vsock from connected table when connect is interrupted by a signal

Siva Mullati (1):
      drm/i915/gvt: Make DRM_I915_GVT depend on X86

Slark Xiao (1):
      net: usb: qmi_wwan: Add support for Dell DW5829e

Srinivas Pandruvada (1):
      platform/x86: ISST: Fix possible circular locking dependency detected

Takashi Iwai (3):
      ALSA: hda/realtek: Fix deadlock by COEF mutex
      ALSA: hda: Fix regression on forced probe mask option
      ALSA: hda: Fix missing codec probe on Shenker Dock 15

Trond Myklebust (3):
      NFS: LOOKUP_DIRECTORY is also ok with symlinks
      NFS: Do not report writeback errors in nfs_getattr()
      NFS: Don't set NFS_INO_INVALID_XATTR if there is no xattr cache

Vladimir Zapolskiy (2):
      i2c: qcom-cci: don't delete an unregistered adapter
      i2c: qcom-cci: don't put a device tree node before i2c_add_adapter()

Waiman Long (1):
      copy_process(): Move fd_install() out of sighand->siglock critical section

Wan Jiabing (1):
      ARM: OMAP2+: hwmod: Add of_node_put() before break

Willem de Bruijn (1):
      ipv6: per-netns exclusive flowlabel checks

Xin Long (1):
      ping: fix the dif and sdif check in ping_lookup

Yang Shi (1):
      fs/proc: task_mmu.c: don't read mapcount for migration entry

Yang Xu (3):
      selftests/zram: Skip max_comp_streams interface on newer kernel
      selftests/zram01.sh: Fix compression ratio calculation
      selftests/zram: Adapt the situation that /dev/zram0 is being used

Ye Guojin (1):
      ARM: OMAP2+: adjust the location of put_device() call in omapdss_init_of

Yu Huang (1):
      ALSA: hda/realtek: Add quirk for Legion Y9000X 2019

Yuka Kawajiri (1):
      platform/x86: touchscreen_dmi: Add info for the RWC NANOTE P8 AY07J 2-in-1

Zhang Changzhong (1):
      bonding: force carrier update when releasing slave

Zoltán Böszörményi (1):
      ata: libata-core: Disable TRIM on M88V29

david regan (1):
      mtd: rawnand: brcmnand: Fixed incorrect sub-page ECC status

