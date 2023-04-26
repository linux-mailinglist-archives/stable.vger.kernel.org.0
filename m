Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1246EF492
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 14:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240909AbjDZMoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Apr 2023 08:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240960AbjDZMoM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 08:44:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0134565AC;
        Wed, 26 Apr 2023 05:43:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2196F62DEF;
        Wed, 26 Apr 2023 12:42:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114E6C433D2;
        Wed, 26 Apr 2023 12:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682512973;
        bh=HkeLsqP+rhogZ0TkWzNK4ZZtF9TIXZn2+ykmzV34n9c=;
        h=From:To:Cc:Subject:Date:From;
        b=uGYxKW+5VbXa+BVTnHke/2N7rXsxuAZbsEsc7HvxcdfMKkj+JsTuvKA4WiFCJHa7+
         waoB26VpKYYu3mfklf9dNUXYBaekwGEeh5x7vpv8gqj0GULrPCU5psS7ig4nf4I+YF
         ndfgplagnT4pbt2aRUeH+IicJgvg63EWKD+T3Zt0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.1.26
Date:   Wed, 26 Apr 2023 14:42:49 +0200
Message-Id: <2023042648-rectified-swinger-1987@gregkh>
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

I'm announcing the release of the 6.1.26 kernel.

All users of the 6.1 kernel series must upgrade.

The updated 6.1.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.1.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                    |    2 
 arch/arm/boot/dts/rk3288.dtsi                               |    2 
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi           |    3 
 arch/arm64/boot/dts/freescale/imx8mm-evk.dtsi               |    2 
 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi            |    4 
 arch/arm64/boot/dts/freescale/imx8mp-verdin-dev.dtsi        |    2 
 arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi            |    4 
 arch/arm64/boot/dts/qcom/ipq8074-hk01.dts                   |    4 
 arch/arm64/boot/dts/qcom/ipq8074-hk10.dtsi                  |   20 +-
 arch/arm64/boot/dts/qcom/sc8280xp-pmics.dtsi                |    5 
 arch/arm64/boot/dts/rockchip/rk3566-soquartz.dtsi           |    2 
 arch/arm64/include/asm/kvm_host.h                           |   19 ++
 arch/arm64/kvm/hypercalls.c                                 |    2 
 arch/loongarch/include/asm/cpu-features.h                   |    1 
 arch/loongarch/include/asm/cpu.h                            |   40 ++---
 arch/loongarch/include/asm/loongarch.h                      |    2 
 arch/loongarch/kernel/cpu-probe.c                           |    9 -
 arch/loongarch/kernel/proc.c                                |    1 
 arch/loongarch/mm/init.c                                    |    4 
 arch/mips/kernel/vmlinux.lds.S                              |    2 
 arch/riscv/purgatory/Makefile                               |    4 
 arch/s390/kernel/ptrace.c                                   |    8 -
 arch/x86/purgatory/Makefile                                 |    3 
 drivers/fpga/fpga-bridge.c                                  |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c                     |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c                     |   17 ++
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c      |   17 +-
 drivers/gpu/drm/amd/display/dc/dml/dcn31/dcn31_fpu.c        |    2 
 drivers/gpu/drm/drm_buddy.c                                 |    4 
 drivers/gpu/drm/i915/display/intel_dp_aux.c                 |    2 
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c                |    4 
 drivers/gpu/drm/tests/drm_buddy_test.c                      |    3 
 drivers/iio/adc/at91-sama5d2_adc.c                          |    2 
 drivers/iio/dac/ad5755.c                                    |    1 
 drivers/iio/light/tsl2772.c                                 |    1 
 drivers/input/tablet/pegasus_notetaker.c                    |    6 
 drivers/memstick/core/memstick.c                            |    5 
 drivers/mmc/host/sdhci_am654.c                              |    2 
 drivers/mtd/spi-nor/core.c                                  |   14 +
 drivers/mtd/spi-nor/core.h                                  |    2 
 drivers/mtd/spi-nor/debugfs.c                               |   11 +
 drivers/net/bonding/bond_main.c                             |    7 
 drivers/net/dsa/b53/b53_mmap.c                              |   14 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                   |    2 
 drivers/net/ethernet/intel/e1000e/netdev.c                  |   51 +++----
 drivers/net/ethernet/intel/i40e/i40e_main.c                 |    9 -
 drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2_tlv_multi.c  |    2 
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h                |    2 
 drivers/net/ethernet/sfc/efx.c                              |    1 
 drivers/net/ethernet/sfc/efx_common.c                       |    2 
 drivers/net/virtio_net.c                                    |    8 -
 drivers/net/xen-netback/netback.c                           |    6 
 drivers/nvme/host/tcp.c                                     |   46 +++---
 drivers/platform/x86/asus-nb-wmi.c                          |    3 
 drivers/platform/x86/gigabyte-wmi.c                         |    3 
 drivers/platform/x86/intel/vsec.c                           |    1 
 drivers/regulator/fan53555.c                                |   13 -
 drivers/scsi/megaraid/megaraid_sas_base.c                   |    2 
 drivers/scsi/scsi.c                                         |   11 +
 drivers/spi/spi-rockchip-sfc.c                              |    2 
 fs/btrfs/extent_map.c                                       |   31 ++++
 fs/btrfs/extent_map.h                                       |    2 
 fs/btrfs/file.c                                             |   44 +++---
 fs/fs-writeback.c                                           |   17 +-
 fs/fuse/dir.c                                               |    2 
 fs/nilfs2/segment.c                                         |   20 ++
 fs/userfaultfd.c                                            |    6 
 include/linux/kmsan.h                                       |   39 ++---
 include/linux/skbuff.h                                      |    5 
 include/net/netfilter/nf_tables.h                           |    4 
 include/trace/events/f2fs.h                                 |    2 
 init/Kconfig                                                |   10 -
 kernel/bpf/verifier.c                                       |   15 ++
 kernel/sched/fair.c                                         |   86 ++++++++++--
 kernel/sched/sched.h                                        |   19 ++
 kernel/sys.c                                                |   69 +++++----
 lib/maple_tree.c                                            |   66 ++++-----
 mm/backing-dev.c                                            |   12 +
 mm/huge_memory.c                                            |   19 ++
 mm/khugepaged.c                                             |    4 
 mm/kmsan/hooks.c                                            |   55 ++++++-
 mm/kmsan/shadow.c                                           |   27 ++-
 mm/mmap.c                                                   |   48 ++++++
 mm/page_alloc.c                                             |   19 ++
 mm/vmalloc.c                                                |   10 -
 net/bridge/br_netfilter_hooks.c                             |   17 +-
 net/bridge/br_switchdev.c                                   |   11 +
 net/dccp/dccp.h                                             |    1 
 net/dccp/ipv6.c                                             |   15 +-
 net/dccp/proto.c                                            |    8 -
 net/ipv6/af_inet6.c                                         |    1 
 net/ipv6/ping.c                                             |    6 
 net/ipv6/raw.c                                              |    2 
 net/ipv6/rpl.c                                              |    3 
 net/ipv6/tcp_ipv6.c                                         |    8 -
 net/ipv6/udp.c                                              |    2 
 net/l2tp/l2tp_ip6.c                                         |    2 
 net/mptcp/protocol.c                                        |    7 
 net/netfilter/nf_tables_api.c                               |   69 ++++++++-
 net/netfilter/nft_lookup.c                                  |   36 -----
 net/sched/sch_qfq.c                                         |   13 -
 net/sctp/socket.c                                           |   29 ++--
 rust/kernel/print.rs                                        |    6 
 rust/kernel/str.rs                                          |    2 
 scripts/asn1_compiler.c                                     |    2 
 sound/pci/hda/patch_realtek.c                               |    1 
 sound/soc/fsl/fsl_asrc_dma.c                                |   11 +
 sound/soc/fsl/fsl_sai.c                                     |    2 
 sound/soc/sof/pm.c                                          |    8 -
 tools/testing/selftests/sigaltstack/current_stack_pointer.h |   23 +++
 tools/testing/selftests/sigaltstack/sas.c                   |    7 
 tools/vm/page_owner_sort.c                                  |    2 
 112 files changed, 936 insertions(+), 418 deletions(-)

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

Brian Masney (1):
      iio: light: tsl2772: fix reading proximity-diodes from device tree

Chancel Liu (1):
      ASoC: fsl_sai: Fix pins setting for i.MX8QM platform

Chen Aotian (1):
      netfilter: nf_tables: Modify nla_memdup's flag to GFP_KERNEL_ACCOUNT

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

Ekaterina Orlova (1):
      ASN.1: Fix check for strdup() success

Filipe Manana (1):
      btrfs: get the next extent map during fiemap/lseek more efficiently

Florian Westphal (2):
      netfilter: br_netfilter: fix recent physdev match breakage
      netfilter: nf_tables: fix ifdef to also consider nf_tables=m

Frank Crawford (1):
      platform/x86 (gigabyte-wmi): Add support for A320M-S2H V2

Greg Kroah-Hartman (3):
      mtd: spi-nor: fix memory leak when using debugfs_lookup()
      memstick: fix memory leak if card device is never registered
      Linux 6.1.26

Guilherme G. Piccoli (1):
      drm/amdgpu/vcn: Disable indirect SRAM on Vangogh broken BIOSes

Gwangun Jung (1):
      net: sched: sch_qfq: prevent slab-out-of-bounds in qfq_activate_agg

Hans de Goede (1):
      platform/x86: gigabyte-wmi: add support for X570S AORUS ELITE

Heiko Carstens (1):
      s390/ptrace: fix PTRACE_GET_LAST_BREAK error handling

Huacai Chen (2):
      LoongArch: Fix probing of the CRC32 feature
      LoongArch: Mark 3 symbol exports as non-GPL

Ido Schimmel (2):
      bonding: Fix memory leak when changing bond type to Ethernet
      mlxsw: pci: Fix possible crash during initialization

Jiachen Zhang (1):
      fuse: always revalidate rename target dentry

Jianqun Xu (1):
      ARM: dts: rockchip: fix a typo error for rk3288 spdif node

Jiaxun Yang (1):
      MIPS: Define RUNTIME_DISCARD_EXIT in LD script

Johan Hovold (1):
      arm64: dts: qcom: sc8280xp-pmics: fix pon compatible and registers

Juergen Gross (1):
      xen/netback: use same error messages for same errors

Kuniyuki Iwashima (3):
      inet6: Remove inet6_destroy_sock() in sk->sk_prot->destroy().
      dccp: Call inet6_destroy_sock() via sk->sk_destruct().
      sctp: Call inet6_destroy_sock() via sk->sk_destruct().

Li Lanzhe (1):
      spi: spi-rockchip: Fix missing unwind goto in rockchip_sfc_probe()

Liam R. Howlett (3):
      maple_tree: make maple state reusable after mas_empty_area_rev()
      maple_tree: fix mas_empty_area() search
      mm/mmap: regression fix for unmapped_area{_topdown}

Liang He (1):
      iio: dac: ad5755: Add missing fwnode_handle_put()

Linus Torvalds (1):
      gcc: disable '-Warray-bounds' for gcc-13 too

Marc Gonzalez (1):
      arm64: dts: meson-g12-common: specify full DMC range

Marc Zyngier (1):
      KVM: arm64: Make vcpu flag updates non-preemptible

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

Patrick Blass (1):
      rust: str: fix requierments->requirements typo

Peng Fan (3):
      arm64: dts: imx8mm-evk: correct pmic clock source
      arm64: dts: imx8mm-verdin: correct off-on-delay
      arm64: dts: imx8mp-verdin: correct off-on-delay

Peng Zhang (1):
      maple_tree: fix a potential memory leak, OOB access, or other unpredictable bug

Peter Xu (2):
      Revert "userfaultfd: don't fail on unrecognized features"
      mm/khugepaged: check again on anon uffd-wp during isolation

Qais Yousef (3):
      sched/fair: Detect capacity inversion
      sched/fair: Consider capacity inversion in util_fits_cpu()
      sched/fair: Fixes for capacity inversion detection

Robert Marko (1):
      arm64: dts: qcom: hk10: use "okay" instead of "ok"

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

Thomas Weißschuh (1):
      platform/x86: gigabyte-wmi: add support for B650 AORUS ELITE AX

Tomas Henzl (1):
      scsi: megaraid_sas: Fix fw_crash_buffer_show()

Ville Syrjälä (1):
      drm/i915: Fix fast wake AUX sync len

Vladimir Oltean (1):
      net: bridge: switchdev: don't notify FDB entries with "master dynamic"

Xuan Zhuo (1):
      virtio_net: bugfix overflow inside xdp_linearize_page()

weiliang1503 (1):
      platform/x86: asus-nb-wmi: Add quirk_asus_tablet_mode to other ROG Flow X13 models

Álvaro Fernández Rojas (1):
      net: dsa: b53: mmap: add phy ops

