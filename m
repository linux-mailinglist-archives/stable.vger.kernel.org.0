Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A91D38897C
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 10:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236249AbhESId3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 04:33:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244276AbhESId3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 May 2021 04:33:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2235B610CD;
        Wed, 19 May 2021 08:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621413128;
        bh=1NwdxzhM4CuAyTBzHuEQN1sfHyiC1Oh+x2OENplzvQ8=;
        h=From:To:Cc:Subject:Date:From;
        b=OszXXH+lC27+jeRE/zFI9bRJk6DI9TUcopcKhBordebB/PKYDwikM5UMNICaD3W57
         OwJm6MF8j1HepSXyv+kMCTKt6YevJJQSkhcFU6OnbONe8f4xq5W6L4o2w2YLepjp63
         1LRr7xiwRSRN03e433LVnj5/JqvMc1MV47dRFsTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.120
Date:   Wed, 19 May 2021 10:32:01 +0200
Message-Id: <1621413120117226@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.120 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/arm/memory.rst                            |    7 +
 Makefile                                                |    2 
 arch/arc/include/asm/page.h                             |   12 ++
 arch/arc/include/asm/pgtable.h                          |   12 --
 arch/arc/include/uapi/asm/page.h                        |    1 
 arch/arc/kernel/entry.S                                 |    4 
 arch/arc/mm/ioremap.c                                   |    5 
 arch/arc/mm/tlb.c                                       |    2 
 arch/arm/include/asm/fixmap.h                           |    2 
 arch/arm/include/asm/memory.h                           |    5 
 arch/arm/include/asm/prom.h                             |    4 
 arch/arm/kernel/atags.h                                 |    4 
 arch/arm/kernel/atags_parse.c                           |    6 -
 arch/arm/kernel/devtree.c                               |    6 -
 arch/arm/kernel/head.S                                  |    9 -
 arch/arm/kernel/hw_breakpoint.c                         |    2 
 arch/arm/kernel/setup.c                                 |   19 ++-
 arch/arm/mm/init.c                                      |    1 
 arch/arm/mm/mmu.c                                       |   20 ++-
 arch/arm/mm/pv-fixup-asm.S                              |    4 
 arch/ia64/include/asm/module.h                          |    6 -
 arch/ia64/kernel/module.c                               |   29 ++++-
 arch/mips/include/asm/div64.h                           |   55 +++++++---
 arch/powerpc/kernel/iommu.c                             |    4 
 arch/powerpc/kernel/smp.c                               |    6 -
 arch/powerpc/lib/feature-fixups.c                       |   35 +++++-
 arch/powerpc/platforms/pseries/hotplug-cpu.c            |    3 
 arch/riscv/kernel/smp.c                                 |    2 
 arch/x86/include/asm/kvm_host.h                         |    3 
 arch/x86/kvm/mmu.c                                      |   33 ------
 arch/x86/kvm/x86.c                                      |    2 
 block/bfq-iosched.c                                     |    3 
 block/blk-mq-sched.c                                    |    8 -
 block/blk-mq.c                                          |    6 -
 block/kyber-iosched.c                                   |    5 
 block/mq-deadline.c                                     |    3 
 drivers/acpi/scan.c                                     |    1 
 drivers/base/power/runtime.c                            |   10 +
 drivers/block/nbd.c                                     |    3 
 drivers/char/tpm/tpm2-cmd.c                             |    1 
 drivers/char/tpm/tpm_tis_core.c                         |   22 ++--
 drivers/clk/samsung/clk-exynos7.c                       |    7 +
 drivers/gpu/drm/amd/display/dc/core/dc.c                |    4 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hubp.c       |   15 +-
 drivers/gpu/drm/i915/gem/i915_gem_mman.c                |    2 
 drivers/gpu/drm/radeon/radeon.h                         |    1 
 drivers/gpu/drm/radeon/radeon_atombios.c                |   26 +++-
 drivers/gpu/drm/radeon/radeon_pm.c                      |    8 +
 drivers/gpu/drm/radeon/si_dpm.c                         |    3 
 drivers/hwmon/occ/common.c                              |    5 
 drivers/hwmon/occ/common.h                              |    2 
 drivers/i2c/i2c-dev.c                                   |    9 +
 drivers/iio/gyro/mpu3050-core.c                         |   13 ++
 drivers/iio/light/tsl2583.c                             |    8 +
 drivers/iio/proximity/pulsedlight-lidar-lite-v2.c       |    1 
 drivers/iommu/amd_iommu_init.c                          |   49 --------
 drivers/net/can/m_can/m_can.c                           |    3 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c               |   19 +++
 drivers/net/ethernet/cisco/enic/enic_main.c             |    7 -
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c         |   12 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c  |    3 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h  |    3 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c  |    2 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c |    2 
 drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h       |    6 -
 drivers/net/ethernet/intel/i40e/i40e_client.c           |    1 
 drivers/net/ethernet/intel/i40e/i40e_common.c           |    4 
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c          |    7 -
 drivers/net/ethernet/intel/i40e/i40e_type.h             |    7 -
 drivers/net/ethernet/intel/iavf/iavf_main.c             |    2 
 drivers/net/ethernet/mediatek/mtk_eth_soc.c             |    2 
 drivers/net/ethernet/mediatek/mtk_eth_soc.h             |    1 
 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c     |    2 
 drivers/net/fddi/Kconfig                                |   15 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c       |    4 
 drivers/net/wireless/quantenna/qtnfmac/event.c          |    6 -
 drivers/net/wireless/wl3501.h                           |   47 ++++----
 drivers/net/wireless/wl3501_cs.c                        |   54 +++++----
 drivers/nvme/host/core.c                                |    3 
 drivers/pci/controller/pcie-iproc-msi.c                 |    2 
 drivers/pci/endpoint/functions/pci-epf-test.c           |    3 
 drivers/pci/probe.c                                     |    1 
 drivers/pinctrl/samsung/pinctrl-exynos.c                |   10 -
 drivers/rpmsg/qcom_glink_native.c                       |    1 
 drivers/rtc/rtc-ds1307.c                                |   12 +-
 drivers/rtc/rtc-fsl-ftm-alarm.c                         |    1 
 drivers/thermal/fair_share.c                            |    4 
 drivers/thermal/of-thermal.c                            |    7 -
 drivers/usb/class/cdc-wdm.c                             |   30 ++++-
 drivers/usb/core/hub.c                                  |    6 -
 drivers/usb/dwc2/core.h                                 |    2 
 drivers/usb/dwc2/gadget.c                               |    3 
 drivers/usb/dwc3/dwc3-omap.c                            |    5 
 drivers/usb/dwc3/dwc3-pci.c                             |    1 
 drivers/usb/dwc3/gadget.c                               |    4 
 drivers/usb/host/fotg210-hcd.c                          |    4 
 drivers/usb/host/xhci-ext-caps.h                        |    5 
 drivers/usb/host/xhci-pci.c                             |    4 
 drivers/usb/host/xhci.c                                 |    6 -
 drivers/usb/typec/tcpm/tcpm.c                           |    6 -
 fs/ceph/export.c                                        |    4 
 fs/dlm/debug_fs.c                                       |    1 
 fs/f2fs/inline.c                                        |    3 
 fs/f2fs/verity.c                                        |   75 +++++++++----
 fs/fuse/cuse.c                                          |    2 
 fs/hfsplus/extents.c                                    |    7 -
 fs/hugetlbfs/inode.c                                    |    5 
 fs/iomap/buffered-io.c                                  |   34 ++++--
 fs/nfs/flexfilelayout/flexfilelayout.c                  |    2 
 fs/nfs/inode.c                                          |    8 -
 fs/nfs/nfs42proc.c                                      |   21 ++-
 fs/squashfs/file.c                                      |    6 -
 include/linux/elevator.h                                |    2 
 include/linux/i2c.h                                     |    2 
 include/linux/iomap.h                                   |    1 
 include/linux/mm.h                                      |   32 +++++
 include/linux/mm_types.h                                |    4 
 include/linux/pm.h                                      |    1 
 include/net/page_pool.h                                 |   12 ++
 include/uapi/linux/netfilter/xt_SECMARK.h               |    6 +
 kernel/kexec_file.c                                     |    4 
 kernel/sched/core.c                                     |    2 
 kernel/sched/fair.c                                     |   12 +-
 lib/kobject_uevent.c                                    |    9 -
 lib/nlattr.c                                            |    2 
 mm/hugetlb.c                                            |   11 +-
 mm/khugepaged.c                                         |   18 +--
 mm/ksm.c                                                |    1 
 mm/migrate.c                                            |    7 +
 mm/shmem.c                                              |   34 ++----
 net/bluetooth/l2cap_core.c                              |    4 
 net/bluetooth/l2cap_sock.c                              |    8 +
 net/bridge/br_arp_nd_proxy.c                            |    4 
 net/core/ethtool.c                                      |    2 
 net/core/flow_dissector.c                               |    6 -
 net/core/page_pool.c                                    |    6 -
 net/ipv6/ip6_vti.c                                      |    2 
 net/mac80211/mlme.c                                     |    5 
 net/netfilter/nf_conntrack_standalone.c                 |    5 
 net/netfilter/nfnetlink_osf.c                           |    2 
 net/netfilter/nft_set_hash.c                            |   10 +
 net/netfilter/xt_SECMARK.c                              |   88 ++++++++++++----
 net/sched/sch_taprio.c                                  |    6 +
 net/sctp/sm_make_chunk.c                                |    2 
 net/sctp/sm_statefuns.c                                 |   28 ++++-
 net/smc/af_smc.c                                        |    4 
 net/sunrpc/clnt.c                                       |   11 --
 net/tipc/netlink_compat.c                               |    2 
 samples/bpf/tracex1_kern.c                              |    4 
 scripts/kconfig/nconf.c                                 |    2 
 sound/firewire/bebob/bebob_stream.c                     |   12 +-
 sound/pci/hda/patch_hdmi.c                              |    4 
 sound/pci/rme9652/hdsp.c                                |    3 
 sound/pci/rme9652/hdspm.c                               |    3 
 sound/pci/rme9652/rme9652.c                             |    3 
 sound/soc/codecs/rt286.c                                |   23 ++--
 sound/soc/intel/boards/bytcr_rt5640.c                   |   20 +++
 sound/soc/sh/rcar/core.c                                |   69 ++++++++++++
 sound/soc/sh/rcar/ssi.c                                 |   16 --
 tools/testing/selftests/lib.mk                          |    4 
 160 files changed, 1034 insertions(+), 501 deletions(-)

Alexander Aring (1):
      fs: dlm: fix debugfs dump

Alexey Kardashevskiy (1):
      powerpc/iommu: Annotate nested lock for lockdep

Anthony Wang (1):
      drm/amd/display: Force vsync flip when reconfiguring MPCC

Anup Patel (1):
      RISC-V: Fix error code returned by riscv_hartid_to_cpuid()

Archie Pusaka (2):
      Bluetooth: Set CONF_NOT_COMPLETE as l2cap_chan default
      Bluetooth: check for zapped sk before connecting

Ard Biesheuvel (4):
      ARM: 9011/1: centralize phys-to-virt conversion of DT/ATAGS address
      ARM: 9012/1: move device tree mapping out of linear region
      ARM: 9020/1: mm: use correct section size macro to describe the FDT virtual address
      ARM: 9027/1: head.S: explicitly map DT even if it lives in the first physical section

Axel Rasmussen (1):
      userfaultfd: release page in error path to avoid BUG_ON

Badhri Jagan Sridharan (1):
      usb: typec: tcpm: Fix error while calculating PPS out values

Baptiste Lepers (1):
      sunrpc: Fix misplaced barrier in call_decode

Bart Van Assche (1):
      blk-mq: Swap two calls in blk_mq_exit_queue()

Bence Csókás (1):
      i2c: Add I2C_AQ_NO_REP_START adapter quirk

Christoph Hellwig (2):
      iomap: fix sub-page uptodate handling
      nvme: do not try to reconfigure APST when the controller is not live

Christophe JAILLET (3):
      usb: fotg210-hcd: Fix an error message
      ACPI: scan: Fix a memory leak in an error handling path
      xhci: Do not use GFP_KERNEL in (potentially) atomic context

Chunfeng Yun (1):
      usb: core: hub: fix race condition about TRSMRCY of resume

Colin Ian King (2):
      f2fs: fix a redundant call to f2fs_balance_fs if an error occurs
      iio: tsl2583: Fix division by a zero lux_val

Cong Wang (1):
      smc: disallow TCP_ULP in smc_setsockopt()

David Bauer (1):
      mt76: mt76x0: disable GTK offloading

David Ward (2):
      ASoC: rt286: Generalize support for ALC3263 codec
      ASoC: rt286: Make RT286_SET_GPIO_* readable and writable

Dinghao Liu (1):
      iio: proximity: pulsedlight: Fix rumtime PM imbalance on error

Dmitry Baryshkov (1):
      PCI: Release OF node in pci_scan_device()'s error path

Dmitry Osipenko (1):
      iio: gyro: mpu3050: Fix reported temperature value

Du Cheng (1):
      net: sched: tapr: prevent cycle_time == 0 in parse_taprio_schedule

Eddie James (1):
      hwmon: (occ) Fix poll rate limiting

Emmanuel Grumbach (1):
      mac80211: clear the beacon's CRC after channel switch

Eric Biggers (1):
      f2fs: fix error handling in f2fs_end_enable_verity()

Eric Dumazet (2):
      ip6_vti: proper dev_{hold|put} in ndo_[un]init methods
      netfilter: nftables: avoid overflows in nft_hash_buckets()

Felix Fietkau (1):
      net: ethernet: mtk_eth_soc: fix RX VLAN offload

Ferry Toth (1):
      usb: dwc3: pci: Enable usb2-gadget-lpm-disable for Intel Merrifield

Greg Kroah-Hartman (2):
      kobject_uevent: remove warning in init_uevent_argv()
      Linux 5.4.120

Gustavo A. R. Silva (5):
      sctp: Fix out-of-bounds warning in sctp_process_asconf_param()
      flow_dissector: Fix out-of-bounds warning in __skb_flow_bpf_to_target()
      ethtool: ioctl: Fix out-of-bounds warning in store_link_ksettings_for_user()
      wl3501_cs: Fix out-of-bounds warnings in wl3501_send_pkt
      wl3501_cs: Fix out-of-bounds warnings in wl3501_mgmt_join

Hans de Goede (2):
      ASoC: Intel: bytcr_rt5640: Enable jack-detect support on Asus T100TAF
      ASoC: Intel: bytcr_rt5640: Add quirk for the Chuwi Hi8 tablet

Hao Chen (1):
      net: hns3: fix for vxlan gpe tx checksum bug

Hoang Le (1):
      tipc: convert dest node's address to network order

Jarkko Sakkinen (2):
      tpm, tpm_tis: Extend locality handling to TPM2 in tpm_tis_gen_interrupt()
      tpm, tpm_tis: Reserve locality in tpm_tis_resume()

Jaroslaw Gawin (1):
      i40e: fix the restart auto-negotiation after FEC modified

Jeff Layton (1):
      ceph: fix inode leak on getattr error in __fh_to_dentry

Jia-Ju Bai (3):
      thermal: thermal_of: Fix error return code of thermal_of_populate_bind_params()
      rpmsg: qcom_glink_native: fix error return code of qcom_glink_rx_data()
      kernel: kexec_file: fix error return code of kexec_calculate_store_digests()

Jian Shen (1):
      net: hns3: add check for HNS3_NIC_STATE_INITED in hns3_reset_notify_up_enet()

Jonathan McDowell (1):
      net: stmmac: Set FIFO sizes for ipq806x

Jonathon Reinhart (1):
      netfilter: conntrack: Make global sysctls readonly in non-init netns

Jouni Roivas (1):
      hfsplus: prevent corruption in shrinking truncate

Kai Vehmanen (1):
      ALSA: hda/hdmi: fix race in handling acomp ELD notification at resume

Kai-Heng Feng (1):
      drm/radeon/dpm: Disable sclk switching on Oland when two 4K 60Hz monitors are connected

Kees Cook (2):
      drm/radeon: Fix off-by-one power_state index heap overwrite
      drm/radeon: Avoid power table parsing memory leaks

Krzysztof Kozlowski (1):
      pinctrl: samsung: use 'int' for register masks in Exynos

Kuninori Morimoto (2):
      ASoC: rsnd: call rsnd_ssi_master_clk_start() from rsnd_ssi_init()
      ASoC: rsnd: check all BUSIF status when error

Lee Gibson (1):
      qtnfmac: Fix possible buffer overflow in qtnf_event_handle_external_auth

Lukasz Luba (1):
      thermal/core/fair share: Lock the thermal zone while looping over instances

Lv Yunlong (1):
      ethernet:enic: Fix a use after free bug in enic_hard_start_xmit

Maciej W. Rozycki (4):
      FDDI: defxx: Make MMIO the configuration default except for EISA
      MIPS: Reinstate platform `__div64_32' handler
      MIPS: Avoid DIVU in `__div64_32' is result would be zero
      MIPS: Avoid handcoded DIVU in `__div64_32' altogether

Maciej Żenczykowski (1):
      net: fix nla_strcmp to handle more then one trailing null character

Marc Kleine-Budde (1):
      can: m_can: m_can_tx_work_queue(): fix tx_skb race condition

Marcel Hamer (1):
      usb: dwc3: omap: improve extcon initialization

Mateusz Palczewski (1):
      i40e: Fix PHY type identifiers for 2.5G and 5G adapters

Matthew Wilcox (Oracle) (1):
      mm: fix struct page layout on 32-bit systems

Maximilian Luz (1):
      usb: xhci: Increase timeout for HC halt

Miaohe Lin (4):
      khugepaged: fix wrong result value for trace_mm_collapse_huge_page_isolate()
      mm/hugeltb: handle the error case in hugetlb_fix_reserve_counts()
      mm/migrate.c: fix potential indeterminate pte entry in migrate_vma_insert_page()
      ksm: fix potential missing rmap_item for stable_node

Michael Chan (1):
      bnxt_en: Add PCI IDs for Hyper-V VF devices.

Michael Ellerman (3):
      powerpc/pseries: Stop calling printk in rtas_stop_self()
      powerpc/64s: Fix crashes when toggling stf barrier
      powerpc/64s: Fix crashes when toggling entry flush barrier

Michael Walle (1):
      rtc: fsl-ftm-alarm: add MODULE_TABLE()

Mihai Moldovan (1):
      kconfig: nconf: stop endless search loops

Mikhail Durnev (1):
      ASoC: rsnd: core: Check convert rate in rsnd_hw_params

Miklos Szeredi (1):
      cuse: prevent clone

Nikola Livic (1):
      pNFS/flexfiles: fix incorrect size check in decode_nfs_fh()

Nikolay Aleksandrov (1):
      net: bridge: when suppression is enabled exclude RARP packets

Nobuhiro Iwamatsu (1):
      rtc: ds1307: Fix wday settings for rx8130

Odin Ugedal (1):
      sched/fair: Fix unfairness caused by missing load decay

Olga Kornievskaia (1):
      NFSv4.2 fix handling of sr_eof in SEEK's reply

Oliver Neukum (1):
      cdc-wdm: untangle a circular dependency between callback and softint

Omar Sandoval (1):
      kyber: fix out of bounds access when preempted

Pablo Neira Ayuso (2):
      netfilter: xt_SECMARK: add new revision to fix structure layout
      netfilter: nfnetlink_osf: Fix a missing skb_header_pointer() NULL check

Pali Rohár (1):
      PCI: iproc: Fix return value of iproc_msi_irq_domain_alloc()

Paul Menzel (1):
      Revert "iommu/amd: Fix performance counter initialization"

Paweł Chmiel (1):
      clk: exynos7: Mark aclk_fsys1_200 as critical

Peng Li (1):
      net: hns3: use netif_tx_disable to stop the transmit queue

Peter Xu (1):
      mm/hugetlb: fix F_SEAL_FUTURE_WRITE

Phil Elwell (1):
      usb: dwc2: Fix gadget DMA unmap direction

Phillip Lougher (1):
      squashfs: fix divide error in calculate_skip()

Quentin Perret (1):
      sched: Fix out-of-bound access in uclamp

Robin Singh (1):
      drm/amd/display: fixed divide by zero kernel crash during dsc enablement

Sandeep Singh (1):
      xhci: Add reset resume quirk for AMD xhci controller.

Sean Christopherson (1):
      KVM: x86/mmu: Remove the defunct update_pte() paging hook

Sergei Trofimovich (1):
      ia64: module: fix symbolizer crash on fdescr

Srikar Dronamraju (1):
      powerpc/smp: Set numa node before updating mask

Stefan Assmann (1):
      iavf: remove duplicate free resources calls

Sun Ke (1):
      nbd: Fix NULL pointer in flush_workqueue

Suravee Suthikulpanit (1):
      iommu/amd: Remove performance counter pre-initialization test

Takashi Sakamoto (1):
      ALSA: bebob: enable to deliver MIDI messages for multiple ports

Tetsuo Handa (1):
      Bluetooth: initialize skb_queue_head at l2cap_chan_create()

Thomas Gleixner (1):
      KVM: x86: Cancel pvclock_gtod_work on module removal

Tong Zhang (3):
      ALSA: hdsp: don't disable if not enabled
      ALSA: hdspm: don't disable if not enabled
      ALSA: rme9652: don't disable if not enabled

Tony Lindgren (1):
      PM: runtime: Fix unpaired parent child_count for force_resume

Trond Myklebust (2):
      NFSv4.2: Always flush out writes in nfs42_proc_fallocate()
      NFS: Deal correctly with attribute generation counter overflow

Ville Syrjälä (1):
      drm/i915: Avoid div-by-zero on gen2

Vineet Gupta (1):
      ARC: entry: fix off-by-one error in syscall number validation

Vladimir Isaev (1):
      ARC: mm: PAE: use 40-bit physical page mask

Wesley Cheng (1):
      usb: dwc3: gadget: Return success always for kick transfer in ep queue

Wolfram Sang (1):
      i2c: bail out early when RDWR parameters are wrong

Xin Long (2):
      sctp: do asoc update earlier in sctp_sf_do_dupcook_a
      sctp: fix a SCTP_MIB_CURRESTAB leak in sctp_sf_do_dupcook_b

Yang Yingliang (1):
      PCI: endpoint: Fix missing destroy_workqueue()

Yaqi Chen (1):
      samples/bpf: Fix broken tracex1 due to kprobe argument change

Yonghong Song (1):
      selftests: Set CC to clang in lib.mk if LLVM is set

Yufeng Mo (3):
      net: hns3: fix incorrect configuration for igu_egu_hw_err
      net: hns3: initialize the message content in hclge_get_link_mode()
      net: hns3: disable phy loopback setting in hclge_mac_start_phy

Yunjian Wang (1):
      i40e: Fix use-after-free in i40e_client_subtask()

Zhen Lei (2):
      tpm: fix error return code in tpm2_get_cc_attrs_tbl()
      ARM: 9064/1: hw_breakpoint: Do not directly check the event's overflow_handler hook

