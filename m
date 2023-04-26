Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCFBD6EF493
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 14:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240972AbjDZMoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Apr 2023 08:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240957AbjDZMoM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 08:44:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1352865AD;
        Wed, 26 Apr 2023 05:43:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15EC36364C;
        Wed, 26 Apr 2023 12:43:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07AADC433D2;
        Wed, 26 Apr 2023 12:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682512984;
        bh=3Z82WxcG7XUQKBpidVAOhlQDZCNeATNvV3lY8QvkBOE=;
        h=From:To:Cc:Subject:Date:From;
        b=MmHXKWTHq2xCYrFc45jb+jtcmVESy2Kj6kWdnt1KLWZyLsOexHuBjdT1uy3QYoS9d
         gdKLowulmGCZ4mD4JEkn+ig6wz0yq9eGL5vy+9QX1OZ9lCyRsJEhtIEIPQ58ohaHys
         /1PRsesfbMnQUGpiYGI29A+NdkQQ4br5c5HvoBEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.2.13
Date:   Wed, 26 Apr 2023 14:42:56 +0200
Message-Id: <2023042656-sprain-lung-de64@gregkh>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 6.2.13 kernel.

All users of the 6.2 kernel series must upgrade.

The updated 6.2.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.2.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.rst             |    1 
 Documentation/admin-guide/kernel-parameters.txt             |    6 
 Makefile                                                    |    2 
 arch/arm/boot/dts/rk3288.dtsi                               |    2 
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi           |   15 +-
 arch/arm64/boot/dts/freescale/imx8mm-evk.dtsi               |    2 
 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi            |    4 
 arch/arm64/boot/dts/freescale/imx8mp-verdin-dev.dtsi        |    2 
 arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi            |    4 
 arch/arm64/boot/dts/qcom/ipq8074-hk01.dts                   |    4 
 arch/arm64/boot/dts/qcom/ipq8074-hk10.dtsi                  |    4 
 arch/arm64/boot/dts/qcom/sc8280xp-pmics.dtsi                |    5 
 arch/arm64/boot/dts/rockchip/rk3566-soquartz.dtsi           |    2 
 arch/arm64/include/asm/kvm_host.h                           |   19 ++
 arch/arm64/kvm/hypercalls.c                                 |    2 
 arch/loongarch/Kconfig                                      |   35 +++++
 arch/loongarch/Makefile                                     |    5 
 arch/loongarch/include/asm/acpi.h                           |    3 
 arch/loongarch/include/asm/cpu-features.h                   |    1 
 arch/loongarch/include/asm/cpu.h                            |   40 +++---
 arch/loongarch/include/asm/io.h                             |    4 
 arch/loongarch/include/asm/loongarch.h                      |    2 
 arch/loongarch/include/asm/module.lds.h                     |    8 -
 arch/loongarch/kernel/Makefile                              |    4 
 arch/loongarch/kernel/cpu-probe.c                           |    9 +
 arch/loongarch/kernel/proc.c                                |    1 
 arch/loongarch/kernel/setup.c                               |   21 +++
 arch/loongarch/kernel/stacktrace.c                          |    2 
 arch/loongarch/kernel/traps.c                               |    9 +
 arch/loongarch/kernel/unwind.c                              |    1 
 arch/loongarch/kernel/unwind_prologue.c                     |    4 
 arch/loongarch/mm/init.c                                    |    4 
 arch/mips/kernel/vmlinux.lds.S                              |    2 
 arch/riscv/purgatory/Makefile                               |    4 
 arch/s390/kernel/ptrace.c                                   |    8 -
 arch/x86/purgatory/Makefile                                 |    3 
 drivers/acpi/acpica/evevent.c                               |   11 -
 drivers/acpi/acpica/hwsleep.c                               |   14 --
 drivers/acpi/acpica/utglobal.c                              |    4 
 drivers/fpga/fpga-bridge.c                                  |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c                     |    3 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c      |   17 ++
 drivers/gpu/drm/amd/display/dc/dml/dcn31/dcn31_fpu.c        |    2 
 drivers/gpu/drm/drm_buddy.c                                 |    4 
 drivers/gpu/drm/i915/display/intel_dp_aux.c                 |    2 
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c                |    4 
 drivers/gpu/drm/tests/drm_buddy_test.c                      |    3 
 drivers/iio/adc/at91-sama5d2_adc.c                          |    2 
 drivers/iio/dac/ad5755.c                                    |    1 
 drivers/iio/light/tsl2772.c                                 |    1 
 drivers/input/tablet/pegasus_notetaker.c                    |    6 
 drivers/input/touchscreen/cyttsp5.c                         |    1 
 drivers/memstick/core/memstick.c                            |    5 
 drivers/mmc/host/sdhci_am654.c                              |    2 
 drivers/mtd/spi-nor/core.c                                  |   14 +-
 drivers/mtd/spi-nor/core.h                                  |    2 
 drivers/mtd/spi-nor/debugfs.c                               |   11 +
 drivers/net/bonding/bond_main.c                             |    7 -
 drivers/net/dsa/b53/b53_mmap.c                              |   14 ++
 drivers/net/dsa/microchip/ksz8795.c                         |    2 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                   |    4 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c        |    2 
 drivers/net/ethernet/intel/e1000e/netdev.c                  |   51 +++----
 drivers/net/ethernet/intel/i40e/i40e_main.c                 |    9 -
 drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2_tlv_multi.c  |    2 
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h                |    2 
 drivers/net/ethernet/sfc/efx.c                              |    1 
 drivers/net/ethernet/sfc/efx_common.c                       |    2 
 drivers/net/virtio_net.c                                    |    8 -
 drivers/net/wireless/ath/ath9k/mci.c                        |    4 
 drivers/net/xen-netback/netback.c                           |    6 
 drivers/nvme/host/tcp.c                                     |   46 +++---
 drivers/pci/msi/msi.c                                       |    9 -
 drivers/perf/amlogic/meson_g12_ddr_pmu.c                    |   34 ++---
 drivers/platform/x86/asus-nb-wmi.c                          |    3 
 drivers/platform/x86/gigabyte-wmi.c                         |    3 
 drivers/platform/x86/intel/vsec.c                           |    1 
 drivers/pwm/core.c                                          |   12 +
 drivers/regulator/fan53555.c                                |   13 +
 drivers/scsi/megaraid/megaraid_sas_base.c                   |    2 
 drivers/scsi/scsi.c                                         |   11 +
 drivers/spi/spi-rockchip-sfc.c                              |    2 
 fs/btrfs/discard.c                                          |   21 +--
 fs/cifs/cifs_dfs_ref.c                                      |    2 
 fs/cifs/dfs.h                                               |   22 ++-
 fs/fs-writeback.c                                           |   17 +-
 fs/nilfs2/segment.c                                         |   20 +++
 fs/userfaultfd.c                                            |    6 
 include/acpi/actypes.h                                      |    3 
 include/linux/kmsan.h                                       |   39 +++--
 include/linux/skbuff.h                                      |    5 
 include/net/netfilter/nf_tables.h                           |    4 
 include/trace/events/f2fs.h                                 |    2 
 init/Kconfig                                                |   10 -
 kernel/bpf/verifier.c                                       |   15 ++
 kernel/fork.c                                               |    1 
 kernel/sys.c                                                |   69 ++++++----
 lib/maple_tree.c                                            |   66 ++++-----
 mm/backing-dev.c                                            |   12 +
 mm/huge_memory.c                                            |   19 ++
 mm/khugepaged.c                                             |    4 
 mm/kmsan/hooks.c                                            |   55 +++++++-
 mm/kmsan/shadow.c                                           |   27 ++--
 mm/mmap.c                                                   |   48 ++++++-
 mm/page_alloc.c                                             |   19 ++
 mm/vmalloc.c                                                |   10 +
 net/bridge/br_netfilter_hooks.c                             |   17 +-
 net/bridge/br_switchdev.c                                   |   11 +
 net/ipv6/rpl.c                                              |    3 
 net/mptcp/protocol.c                                        |   74 +++++++----
 net/mptcp/protocol.h                                        |    2 
 net/mptcp/subflow.c                                         |   80 +++++++++++-
 net/netfilter/nf_tables_api.c                               |   69 +++++++++-
 net/netfilter/nft_lookup.c                                  |   36 -----
 net/sched/sch_qfq.c                                         |   13 +
 rust/kernel/print.rs                                        |    6 
 rust/kernel/str.rs                                          |    2 
 scripts/asn1_compiler.c                                     |    2 
 sound/pci/hda/patch_realtek.c                               |    1 
 sound/soc/fsl/fsl_asrc_dma.c                                |   11 +
 sound/soc/fsl/fsl_sai.c                                     |    2 
 sound/soc/sof/ipc4-topology.c                               |   10 -
 sound/soc/sof/pm.c                                          |    8 +
 tools/testing/selftests/sigaltstack/current_stack_pointer.h |   23 +++
 tools/testing/selftests/sigaltstack/sas.c                   |    7 -
 tools/vm/page_owner_sort.c                                  |    2 
 126 files changed, 1016 insertions(+), 465 deletions(-)

Alan Liu (1):
      drm/amdgpu: Fix desktop freezed after gpu-reset

Aleksandr Loktionov (2):
      i40e: fix accessing vsi->active_filters without holding lock
      i40e: fix i40e_setup_misc_vector() error handling

Alexander Aring (1):
      net: rpl: fix rpl header size calculation

Alexander Potapenko (2):
      mm: kmsan: handle alloc failures in kmsan_ioremap_page_range()
      mm: kmsan: handle alloc failures in kmsan_vmap_pages_range_noflush()

Alexis Lothoré (1):
      fpga: bridge: properly initialize bridge device before populating children

Alyssa Ross (1):
      purgatory: fix disabling debug info

Andy Chi (1):
      ALSA: hda/realtek: fix mute/micmute LEDs for a HP ProBook

Baokun Li (1):
      writeback, cgroup: fix null-ptr-deref write in bdi_split_work_to_wbs

Bhavya Kapoor (1):
      mmc: sdhci_am654: Set HIGH_SPEED_ENA for SDR12 and SDR25

Boris Burkov (2):
      btrfs: set default discard iops_limit to 1000
      btrfs: reinterpret async discard iops_limit=0 as no delay

Brian Masney (1):
      iio: light: tsl2772: fix reading proximity-diodes from device tree

Chancel Liu (1):
      ASoC: fsl_sai: Fix pins setting for i.MX8QM platform

Chen Aotian (1):
      netfilter: nf_tables: Modify nla_memdup's flag to GFP_KERNEL_ACCOUNT

Christophe JAILLET (1):
      net: dsa: microchip: ksz8795: Correctly handle huge frame configuration

Cristian Ciocaltea (2):
      regulator: fan53555: Explicitly include bits header
      regulator: fan53555: Fix wrong TCS_SLEW_MASK

Damien Le Moal (1):
      scsi: core: Improve scsi_vpd_inquiry() checks

Dan Carpenter (2):
      KVM: arm64: Fix buffer overflow in kvm_arm_set_fw_reg()
      iio: adc: at91-sama5d2_adc: fix an error code in at91_adc_allocate_trigger()

Dan Johansen (1):
      arm64: dts: rockchip: Lower sd speed on rk3566-soquartz

Daniel Baluta (1):
      ASoC: SOF: pm: Tear down pipelines only if DSP was active

Daniel Borkmann (1):
      bpf: Fix incorrect verifier pruning due to missing register precision taints

David Gow (3):
      drm: buddy_allocator: Fix buddy allocator init on 32-bit systems
      drm: test: Fix 32-bit issue in drm_buddy_test
      rust: kernel: Mark rust_fmt_argument as extern "C"

David Hildenbrand (1):
      mm/userfaultfd: fix uffd-wp handling for THP migration entries

Ding Hui (1):
      sfc: Fix use-after-free due to selftest_work

Dmitry Baryshkov (2):
      arm64: dts: qcom: ipq8074-hk01: enable QMP device, not the PHY node
      arm64: dts: qcom: ipq8074-hk10: enable QMP device, not the PHY node

Dmytro Laktyushkin (1):
      drm/amd/display: set dcn315 lb bpp to 48

Dongliang Mu (1):
      platform/x86/intel: vsec: Fix a memory leak in intel_vsec_add_aux

Douglas Raillard (1):
      f2fs: Fix f2fs_truncate_partial_nodes ftrace event

Duoming Zhou (1):
      cxgb4: fix use after free bugs caused by circular dependency problem

Ekaterina Orlova (1):
      ASN.1: Fix check for strdup() success

Florian Westphal (2):
      netfilter: br_netfilter: fix recent physdev match breakage
      netfilter: nf_tables: fix ifdef to also consider nf_tables=m

Frank Crawford (1):
      platform/x86 (gigabyte-wmi): Add support for A320M-S2H V2

Greg Kroah-Hartman (3):
      mtd: spi-nor: fix memory leak when using debugfs_lookup()
      memstick: fix memory leak if card device is never registered
      Linux 6.2.13

Gwangun Jung (1):
      net: sched: sch_qfq: prevent slab-out-of-bounds in qfq_activate_agg

Hans de Goede (1):
      platform/x86: gigabyte-wmi: add support for X570S AORUS ELITE

Heiko Carstens (1):
      s390/ptrace: fix PTRACE_GET_LAST_BREAK error handling

Huacai Chen (6):
      LoongArch: Fix build error if CONFIG_SUSPEND is not set
      LoongArch: module: set section addresses to 0x0
      LoongArch: Fix probing of the CRC32 feature
      LoongArch: Mark 3 symbol exports as non-GPL
      LoongArch: Make -mstrict-align configurable
      LoongArch: Make WriteCombine configurable for ioremap()

Ido Schimmel (2):
      bonding: Fix memory leak when changing bond type to Ethernet
      mlxsw: pci: Fix possible crash during initialization

Jianqun Xu (1):
      ARM: dts: rockchip: fix a typo error for rk3288 spdif node

Jiaxun Yang (1):
      MIPS: Define RUNTIME_DISCARD_EXIT in LD script

Johan Hovold (1):
      arm64: dts: qcom: sc8280xp-pmics: fix pon compatible and registers

Juergen Gross (1):
      xen/netback: use same error messages for same errors

Li Lanzhe (1):
      spi: spi-rockchip: Fix missing unwind goto in rockchip_sfc_probe()

Liam R. Howlett (3):
      maple_tree: make maple state reusable after mas_empty_area_rev()
      maple_tree: fix mas_empty_area() search
      mm/mmap: regression fix for unmapped_area{_topdown}

Liang He (1):
      iio: dac: ad5755: Add missing fwnode_handle_put()

Linus Torvalds (2):
      Revert "ACPICA: Events: Support fixed PCIe wake event"
      gcc: disable '-Warray-bounds' for gcc-13 too

Marc Gonzalez (3):
      arm64: dts: meson-g12-common: specify full DMC range
      arm64: dts: meson-g12-common: resolve conflict between canvas & pmu
      perf/amlogic: adjust register offsets

Marc Zyngier (1):
      KVM: arm64: Make vcpu flag updates non-preemptible

Mathieu Desnoyers (1):
      mm: fix memory leak on mm_init error handling

Mel Gorman (1):
      mm: page_alloc: skip regions with hugetlbfs pages when allocating 1G pages

Michael Chan (1):
      bnxt_en: Do not initialize PTP on older P3/P4 chips

Naoya Horiguchi (1):
      mm/huge_memory.c: warn with pr_warn_ratelimited instead of VM_WARN_ON_ONCE_FOLIO

Nick Desaulniers (1):
      selftests: sigaltstack: fix -Wuninitialized

Nikita Zhandarovich (2):
      mlxfw: fix null-ptr-deref in mlxfw_mfa2_tlv_next()
      ASoC: fsl_asrc_dma: fix potential null-ptr-deref

Ondrej Mosnacek (1):
      kernel/sys.c: fix and improve control flow in __sys_setres[ug]id()

Pablo Neira Ayuso (2):
      netfilter: nf_tables: validate catch-all set elements
      netfilter: nf_tables: tighten netlink attribute requirements for catch-all elements

Paolo Abeni (2):
      mptcp: stops worker on unaccepted sockets at listener close
      mptcp: fix accept vs worker race

Patrick Blass (1):
      rust: str: fix requierments->requirements typo

Paulo Alcantara (1):
      cifs: avoid dup prefix path in dfs_get_automount_devname()

Peng Fan (3):
      arm64: dts: imx8mm-evk: correct pmic clock source
      arm64: dts: imx8mm-verdin: correct off-on-delay
      arm64: dts: imx8mp-verdin: correct off-on-delay

Peng Zhang (1):
      maple_tree: fix a potential memory leak, OOB access, or other unpredictable bug

Peter Ujfalusi (1):
      ASoC: SOF: ipc4-topology: Clarify bind failure caused by missing fw_module

Peter Xu (2):
      Revert "userfaultfd: don't fail on unrecognized features"
      mm/khugepaged: check again on anon uffd-wp during isolation

Ryusuke Konishi (1):
      nilfs2: initialize unused bytes in segment summary blocks

Sagi Grimberg (1):
      nvme-tcp: fix a possible UAF when failing to allocate an io queue

Sascha Hauer (2):
      drm/rockchip: vop2: fix suspend/resume
      drm/rockchip: vop2: Use regcache_sync() to fix suspend/resume

Sebastian Basierski (1):
      e1000e: Disable TSO on i219-LM card to increase speed

Soumya Negi (1):
      Input: pegasus-notetaker - check pipe type when probing

Steve Chou (1):
      tools/mm/page_owner_sort.c: fix TGID output when cull=tg is used

Tetsuo Handa (1):
      mm/page_alloc: fix potential deadlock on zonelist_update_seq seqlock

Thomas Gleixner (1):
      PCI/MSI: Remove over-zealous hardware size check in pci_msix_validate_entries()

Thomas Weißschuh (1):
      platform/x86: gigabyte-wmi: add support for B650 AORUS ELITE AX

Tiezhu Yang (1):
      LoongArch: Check unwind_error() in arch_stack_walk()

Toke Høiland-Jørgensen (1):
      wifi: ath9k: Don't mark channelmap stack variable read-only in ath9k_mci_update_wlan_channels()

Tomas Henzl (1):
      scsi: megaraid_sas: Fix fw_crash_buffer_show()

Uwe Kleine-König (1):
      pwm: Zero-initialize the pwm_state passed to driver's .get_state()

Vadim Fedorenko (1):
      bnxt_en: fix free-runnig PHC mode

Ville Syrjälä (1):
      drm/i915: Fix fast wake AUX sync len

Vladimir Oltean (1):
      net: bridge: switchdev: don't notify FDB entries with "master dynamic"

Xuan Zhuo (1):
      virtio_net: bugfix overflow inside xdp_linearize_page()

hrdl (1):
      Input: cyttsp5 - fix sensing configuration data structure

weiliang1503 (1):
      platform/x86: asus-nb-wmi: Add quirk_asus_tablet_mode to other ROG Flow X13 models

Álvaro Fernández Rojas (1):
      net: dsa: b53: mmap: add phy ops

