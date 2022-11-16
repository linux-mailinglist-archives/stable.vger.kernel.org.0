Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABEB962B5F8
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 10:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbiKPJGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 04:06:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233364AbiKPJGV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 04:06:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453D0E020;
        Wed, 16 Nov 2022 01:06:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C780C61B07;
        Wed, 16 Nov 2022 09:06:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD00EC433D7;
        Wed, 16 Nov 2022 09:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668589579;
        bh=0W2Oy4HIA6M/lb8rtmDsky9i3oh6h45cSr815aNTNUc=;
        h=From:To:Cc:Subject:Date:From;
        b=UkpgQcJ7Wt3a8kxlsnTIGD3k1yxz3L3hyKvX50KrpA5JChOeTaeT4bGubV9AgWE7e
         UpQ2Q6aqCN2E5jBYqMv5QlFux9rNhySr6yQqlIYS1BIh8HSBYGWrZBc1rk/p+efuaN
         L7NYSXQPKfahm1ty5pWSJsEoyExlKMfXPpWnDOTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.79
Date:   Wed, 16 Nov 2022 10:06:05 +0100
Message-Id: <166858956522698@kroah.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.79 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/virt/kvm/devices/vm.rst                              |    3 
 Makefile                                                           |    2 
 arch/arm64/kernel/efi.c                                            |   52 ++-
 arch/mips/kernel/jump_label.c                                      |    2 
 arch/riscv/kernel/process.c                                        |    2 
 arch/riscv/kernel/setup.c                                          |    1 
 arch/riscv/kernel/vdso/Makefile                                    |    2 
 arch/riscv/mm/init.c                                               |    1 
 arch/s390/kvm/kvm-s390.c                                           |   26 +
 arch/s390/kvm/kvm-s390.h                                           |    1 
 arch/x86/include/asm/msr-index.h                                   |    8 
 arch/x86/kernel/cpu/amd.c                                          |    6 
 arch/x86/kernel/cpu/hygon.c                                        |    4 
 arch/x86/kvm/svm/svm.c                                             |   10 
 arch/x86/kvm/x86.c                                                 |    2 
 arch/x86/power/cpu.c                                               |    1 
 drivers/ata/libata-scsi.c                                          |    3 
 drivers/dma/at_hdmac.c                                             |  153 +++-------
 drivers/dma/at_hdmac_regs.h                                        |   10 
 drivers/dma/mv_xor_v2.c                                            |    1 
 drivers/dma/pxa_dma.c                                              |    4 
 drivers/dma/ti/k3-udma-glue.c                                      |    3 
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c                           |   49 ++-
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h                              |    1 
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c                               |    2 
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c            |    4 
 drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c                         |    4 
 drivers/gpu/drm/vc4/vc4_drv.c                                      |    7 
 drivers/hid/hid-hyperv.c                                           |    2 
 drivers/hwspinlock/qcom_hwspinlock.c                               |    2 
 drivers/mmc/host/sdhci-cqhci.h                                     |   24 +
 drivers/mmc/host/sdhci-esdhc-imx.c                                 |    7 
 drivers/mmc/host/sdhci-of-arasan.c                                 |    3 
 drivers/mmc/host/sdhci-tegra.c                                     |    3 
 drivers/mmc/host/sdhci_am654.c                                     |    7 
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c                   |    4 
 drivers/net/ethernet/aquantia/atlantic/aq_macsec.c                 |    2 
 drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c         |   18 -
 drivers/net/ethernet/broadcom/Kconfig                              |    2 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                          |    2 
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c                  |    2 
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c                    |    1 
 drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c                |    2 
 drivers/net/ethernet/freescale/fman/mac.c                          |    9 
 drivers/net/ethernet/marvell/mv643xx_eth.c                         |    1 
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c           |    3 
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h           |    1 
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c               |  135 ++++++--
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h           |   57 +++
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c             |   69 ++++
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h             |    5 
 drivers/net/ethernet/marvell/prestera/prestera_rxtx.c              |    7 
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c                      |   11 
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c            |   31 ++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c |   14 
 drivers/net/ethernet/neterion/s2io.c                               |   29 +
 drivers/net/ethernet/ni/nixge.c                                    |    1 
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c                  |   14 
 drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c               |   39 ++
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c                |    8 
 drivers/net/ethernet/ti/cpsw.c                                     |    2 
 drivers/net/ethernet/tundra/tsi108_eth.c                           |    5 
 drivers/net/hamradio/bpqether.c                                    |    2 
 drivers/net/macsec.c                                               |   23 -
 drivers/net/macvlan.c                                              |    4 
 drivers/net/phy/mscc/mscc_macsec.c                                 |    1 
 drivers/net/tun.c                                                  |   18 -
 drivers/net/wan/lapbether.c                                        |    3 
 drivers/net/wireless/ath/ath11k/reg.c                              |    6 
 drivers/net/wwan/iosm/iosm_ipc_pcie.c                              |   11 
 drivers/net/wwan/iosm/iosm_ipc_wwan.c                              |    1 
 drivers/net/wwan/mhi_wwan_mbim.c                                   |    1 
 drivers/phy/ralink/phy-mt7621-pci.c                                |    3 
 drivers/phy/st/phy-stm32-usbphyc.c                                 |    2 
 drivers/platform/x86/hp-wmi.c                                      |   12 
 drivers/soundwire/qcom.c                                           |    9 
 drivers/thunderbolt/path.c                                         |   42 +-
 drivers/thunderbolt/tb.c                                           |   96 +++++-
 drivers/thunderbolt/tb.h                                           |    5 
 drivers/thunderbolt/tunnel.c                                       |   27 +
 drivers/thunderbolt/tunnel.h                                       |    9 
 fs/btrfs/disk-io.c                                                 |    4 
 fs/btrfs/tests/btrfs-tests.c                                       |    2 
 fs/btrfs/volumes.c                                                 |   27 +
 fs/btrfs/volumes.h                                                 |    2 
 fs/fuse/readdir.c                                                  |   10 
 fs/nilfs2/segment.c                                                |   15 
 fs/nilfs2/super.c                                                  |    2 
 fs/nilfs2/the_nilfs.c                                              |    2 
 fs/udf/namei.c                                                     |    2 
 include/asm-generic/vmlinux.lds.h                                  |    2 
 include/linux/bpf.h                                                |    1 
 include/linux/bpf_verifier.h                                       |   21 +
 include/linux/skmsg.h                                              |    3 
 include/linux/soc/marvell/octeontx2/asm.h                          |   15 
 include/uapi/linux/capability.h                                    |    2 
 kernel/bpf/verifier.c                                              |  148 ++-------
 mm/damon/dbgfs.c                                                   |    7 
 mm/memremap.c                                                      |    1 
 mm/userfaultfd.c                                                   |    2 
 net/can/af_can.c                                                   |    2 
 net/can/j1939/main.c                                               |    3 
 net/core/skbuff.c                                                  |   36 +-
 net/core/skmsg.c                                                   |    8 
 net/core/sock_map.c                                                |   28 +
 net/ipv4/tcp.c                                                     |    2 
 net/ipv4/tcp_bpf.c                                                 |    9 
 net/ipv6/addrlabel.c                                               |    1 
 net/mac80211/s1g.c                                                 |    3 
 net/mctp/af_mctp.c                                                 |    4 
 net/mctp/route.c                                                   |    2 
 net/netfilter/nf_tables_api.c                                      |    3 
 net/netfilter/nfnetlink.c                                          |    1 
 net/tipc/netlink_compat.c                                          |    2 
 net/wireless/reg.c                                                 |   12 
 net/wireless/scan.c                                                |    4 
 scripts/extract-cert.c                                             |    7 
 scripts/sign-file.c                                                |    7 
 sound/hda/hdac_sysfs.c                                             |    4 
 sound/pci/hda/hda_intel.c                                          |    3 
 sound/pci/hda/patch_ca0132.c                                       |    1 
 sound/pci/hda/patch_realtek.c                                      |    1 
 sound/usb/card.c                                                   |   29 +
 sound/usb/quirks-table.h                                           |    4 
 sound/usb/quirks.c                                                 |    1 
 tools/arch/x86/include/asm/msr-index.h                             |    8 
 tools/bpf/bpftool/common.c                                         |    3 
 tools/perf/.gitignore                                              |    1 
 tools/perf/util/stat-display.c                                     |    2 
 129 files changed, 1092 insertions(+), 528 deletions(-)

Alex Barba (1):
      bnxt_en: fix potentially incorrect return value for ndo_rx_flow_steer

Alex Sierra (1):
      drm/amdkfd: avoid recursive lock in migrations back to RAM

Alexander Potapenko (1):
      ipv6: addrlabel: fix infoleak when sending struct ifaddrlblmsg to network

Anders Roxell (1):
      marvell: octeontx2: build error: unknown type name 'u64'

Antoine Tenart (2):
      net: phy: mscc: macsec: clear encryption keys when freeing a flow
      net: atlantic: macsec: clear encryption keys from the stack

Ard Biesheuvel (1):
      arm64: efi: Fix handling of misaligned runtime regions and drop warning

Arend van Spriel (1):
      wifi: cfg80211: fix memory leak in query_regdb_file()

Athira Rajeev (1):
      perf stat: Fix printing os->prefix in CSV metrics output

Borislav Petkov (1):
      x86/cpu: Restore AMD's DE_CFG MSR after resume

Brian Norris (5):
      mmc: cqhci: Provide helper for resetting both SDHCI and CQHCI
      mmc: sdhci-of-arasan: Fix SDHCI_RESET_ALL for CQHCI
      mmc: sdhci_am654: Fix SDHCI_RESET_ALL for CQHCI
      mmc: sdhci-tegra: Fix SDHCI_RESET_ALL for CQHCI
      mms: sdhci-esdhc-imx: Fix SDHCI_RESET_ALL for CQHCI

Christophe JAILLET (1):
      dmaengine: mv_xor_v2: Fix a resource leak in mv_xor_v2_remove()

Chuang Wang (1):
      net: macvlan: fix memory leaks of macvlan_common_newlink

Cong Wang (1):
      bpf, sock_map: Move cancel_work_sync() out of sock lock

Conor Dooley (1):
      riscv: fix reserved memory setup

Dan Carpenter (1):
      phy: stm32: fix an error code in probe

Donglin Peng (1):
      perf tools: Add the include/perf/ directory to .gitignore

Doug Brown (1):
      dmaengine: pxa_dma: use platform_get_irq_optional

Edson Juliano Drosdeck (1):
      ALSA: hda/realtek: Add Positivo C6300 model quirk

Eric Dumazet (1):
      net: tun: call napi_schedule_prep() to ensure we own a napi

Evan Quan (1):
      ALSA: hda/hdmi - enable runtime pm for more AMD display audio

Gaosheng Cui (1):
      capabilities: fix undefined behavior in bit shift for CAP_TO_MASK

Geetha sowjanya (1):
      octeontx2-pf: Use hardware register for CQE count

Greg Kroah-Hartman (1):
      Linux 5.15.79

Guchun Chen (1):
      drm/amdgpu: disable BACO on special BEIGE_GOBY card

HW He (2):
      net: wwan: iosm: fix memory leak in ipc_wwan_dellink
      net: wwan: mhi: fix memory leak in mhi_mbim_dellink

Haibo Chen (1):
      mmc: sdhci-esdhc-imx: use the correct host caps for MMC_CAP_8_BIT_DATA

Howard Hsu (1):
      wifi: mac80211: Set TWT Information Frame Disabled bit as 1

Jiaxun Yang (1):
      MIPS: jump_label: Fix compat branch range check

Jiri Benc (1):
      net: gso: fix panic on frag_list with mixed head alloc types

Jisheng Zhang (2):
      riscv: process: fix kernel info leakage
      riscv: vdso: fix build with llvm

Johannes Berg (1):
      wifi: cfg80211: silence a sparse RCU warning

Johannes Thumshirn (1):
      btrfs: zoned: initialize device's zone info for seeding

John Fastabend (1):
      bpf: Fix sockmap calling sleepable function in teardown path

John Thomson (1):
      phy: ralink: mt7621-pci: add sentinel to quirks table

Jorge Lopez (1):
      platform/x86: hp_wmi: Fix rfkill causing soft blocked wifi

Jussi Laako (1):
      ALSA: usb-audio: Add DSD support for Accuphase DAC-60

Kees Cook (1):
      bpf, verifier: Fix memory leak in array reallocation for stack state

Krzysztof Kozlowski (1):
      hwspinlock: qcom: correct MMIO max register for newer SoCs

Kumar Kartikeya Dwivedi (1):
      bpf: Add helper macro bpf_for_each_reg_in_vstate

Linus Torvalds (1):
      cert host tools: Stop complaining about deprecated OpenSSL functions

Liu Shixin (1):
      btrfs: fix match incorrectly in dev_args_match_device

Lu Wei (1):
      tcp: prohibit TCP_REPAIR_OPTIONS if data was already sent

M Chetan Kumar (1):
      net: wwan: iosm: fix memory leak in ipc_pcie_read_bios_cfg

Matthew Auld (1):
      drm/i915/dmabuf: fix sg_table handling in map_dma_buf

Michael Chan (1):
      bnxt_en: Fix possible crash in bnxt_hwrm_set_coal()

Mika Westerberg (1):
      thunderbolt: Tear down existing tunnels when resuming from hibernate

Miklos Szeredi (1):
      fuse: fix readdir cache race

Nathan Chancellor (1):
      vmlinux.lds.h: Fix placement of '.data..decrypted' section

Nico Boehr (1):
      KVM: s390: pv: don't allow userspace to set the clock under PV

Oliver Hartkopp (1):
      can: j1939: j1939_send_one(): fix missing CAN header initialization

Pankaj Gupta (1):
      mm/memremap.c: map FS_DAX device memory as decrypted

Peter Xu (1):
      mm/shmem: use page_mapping() to detect page cache for uffd continue

Philip Yang (2):
      drm/amdkfd: handle CPU fault on COW mapping
      drm/amdkfd: Migrate in CPU page fault use current mm

Pu Lehui (1):
      bpftool: Fix NULL pointer dereference when pin {PROG, MAP, LINK} without FILE

Rasmus Villemoes (1):
      net: stmmac: dwmac-meson8b: fix meson8b_devm_clk_prepare_enable()

Ratheesh Kannoth (1):
      octeontx2-pf: NIX TX overwrites SQ_CTX_HW_S[SQ_INT]

Roi Dayan (1):
      net/mlx5e: E-Switch, Fix comparing termination table instance

Roy Novich (1):
      net/mlx5: Allow async trigger completion execution on single CPU systems

Ryusuke Konishi (2):
      nilfs2: fix deadlock in nilfs_count_free_blocks()
      nilfs2: fix use-after-free bug of ns_writer on remount

Sabrina Dubroca (4):
      macsec: delete new rxsc when offload fails
      macsec: fix secy->n_rx_sc accounting
      macsec: fix detection of RXSCs when toggling offloading
      macsec: clear encryption keys from the stack after setting up offload

Sanjay R Mehta (1):
      thunderbolt: Add DP OUT resource when DP tunnel is discovered

Sean Anderson (1):
      net: fman: Unregister ethernet device on removal

SeongJae Park (1):
      mm/damon/dbgfs: check if rm_contexts input is for a real context

Shigeru Yoshida (1):
      netfilter: Cleanup nft_net->module_list from nf_tables_exit_net()

Shin'ichiro Kawasaki (1):
      ata: libata-scsi: fix SYNCHRONIZE CACHE (16) command failure

Srinivas Kandagatla (2):
      soundwire: qcom: reinit broadcast completion
      soundwire: qcom: check for outanding writes before doing a read

Takashi Iwai (2):
      ALSA: usb-audio: Yet more regression for for the delayed card registration
      ALSA: usb-audio: Add quirk entry for M-Audio Micro

Tan, Tee Min (1):
      stmmac: intel: Update PCH PTP clock rate from 200MHz to 204.8MHz

Tudor Ambarus (15):
      dmaengine: at_hdmac: Fix at_lli struct definition
      dmaengine: at_hdmac: Don't start transactions at tx_submit level
      dmaengine: at_hdmac: Start transfer for cyclic channels in issue_pending
      dmaengine: at_hdmac: Fix premature completion of desc in issue_pending
      dmaengine: at_hdmac: Do not call the complete callback on device_terminate_all
      dmaengine: at_hdmac: Protect atchan->status with the channel lock
      dmaengine: at_hdmac: Fix concurrency problems by removing atc_complete_all()
      dmaengine: at_hdmac: Fix concurrency over descriptor
      dmaengine: at_hdmac: Free the memset buf without holding the chan lock
      dmaengine: at_hdmac: Fix concurrency over the active list
      dmaengine: at_hdmac: Fix descriptor handling when issuing it to hardware
      dmaengine: at_hdmac: Fix completion of unissued descriptor in case of errors
      dmaengine: at_hdmac: Don't allow CPU to reorder channel enable
      dmaengine: at_hdmac: Fix impossible condition
      dmaengine: at_hdmac: Check return code of dma_async_device_register

Vlad Buslov (1):
      net/mlx5: Bridge, verify LAG state when adding bond to bridge

Wang Yufen (3):
      bpf, sockmap: Fix the sk->sk_forward_alloc warning of sk_stream_kill_queues
      bpf, sockmap: Fix sk->sk_forward_alloc warn_on in sk_stream_kill_queues
      net: tun: Fix memory leaks of napi_get_frags

Wei Yongjun (1):
      mctp: Fix an error handling path in mctp_init()

Wen Gong (1):
      wifi: ath11k: avoid deadlock during regulatory update in ath11k_regd_update()

Wong Vee Khee (1):
      stmmac: intel: Enable 2.5Gbps for Intel AlderLake-S

Xian Wang (1):
      ALSA: hda/ca0132: add quirk for EVGA Z390 DARK

Xin Long (1):
      tipc: fix the msg->req tlv len check in tipc_nl_compat_name_table_dump_header

Yang Li (1):
      drm/amdkfd: Fix NULL pointer dereference in svm_migrate_to_ram()

Yang Yingliang (5):
      HID: hyperv: fix possible memory leak in mousevsc_probe()
      dmaengine: ti: k3-udma-glue: fix memory leak when register device fail
      stmmac: dwmac-loongson: fix missing pci_disable_msi() while module exiting
      stmmac: dwmac-loongson: fix missing pci_disable_device() in loongson_dwmac_probe()
      stmmac: dwmac-loongson: fix missing of_node_put() while module exiting

Ye Bin (1):
      ALSA: hda: fix potential memleak in 'add_widget_node'

Youlin Li (1):
      bpf: Fix wrong reg type conversion in release_reference()

Yuan Can (1):
      drm/vc4: Fix missing platform_unregister_drivers() call in vc4_drm_register()

YueHaibing (1):
      net: broadcom: Fix BCMGENET Kconfig

Zhang Xiaoxu (1):
      btrfs: selftests: fix wrong error check in btrfs_free_dummy_root()

ZhangPeng (1):
      udf: Fix a slab-out-of-bounds write bug in udf_find_entry()

Zhengchao Shao (13):
      net: lapbether: fix issue of dev reference count leakage in lapbeth_device_event()
      hamradio: fix issue of dev reference count leakage in bpq_device_event()
      can: af_can: fix NULL pointer dereference in can_rx_register()
      net: lapbether: fix issue of invalid opcode in lapbeth_open()
      drivers: net: xgene: disable napi when register irq failed in xgene_enet_open()
      net: marvell: prestera: fix memory leak in prestera_rxtx_switch_init()
      net: nixge: disable napi when enable interrupts failed in nixge_open()
      net: cpsw: disable napi in cpsw_ndo_open()
      net: cxgb3_main: disable napi when bind qsets failed in cxgb_up()
      cxgb4vf: shut down the adapter when t4vf_update_port_info() failed in cxgb4vf_open()
      ethernet: s2io: disable napi when start nic failed in s2io_card_up()
      net: mv643xx_eth: disable napi when init rxq or txq failed in mv643xx_eth_open()
      ethernet: tundra: free irq when alloc ring failed in tsi108_open()

Ziyang Xuan (1):
      netfilter: nfnetlink: fix potential dead lock in nfnetlink_rcv_msg()

