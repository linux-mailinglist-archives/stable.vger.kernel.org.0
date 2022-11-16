Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D293F62B5F3
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 10:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbiKPJGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 04:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbiKPJGC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 04:06:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 228102181;
        Wed, 16 Nov 2022 01:06:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4E1B61B09;
        Wed, 16 Nov 2022 09:06:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DBA4C433D6;
        Wed, 16 Nov 2022 09:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668589560;
        bh=CkFkVb0GXh+nRSBvrvCFkn2ygbIK0C3/H4l/n/KSndM=;
        h=From:To:Cc:Subject:Date:From;
        b=L/YKhFuSsubPfn8WrPLFSCIyqVnOBY5Bd5X4SRjUqZ5UJrZGzdpDfK5PN7bznCCH0
         7Q8ZGziOIyTs00L+V6eSl2qusWCeelpd6m5Ub3AKQ1epUUVHwr3FTytwxuy0KUClry
         hFYw6fVKzR0vN9ZUlCFyHoDNvCCfsmAor9hC3n/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.155
Date:   Wed, 16 Nov 2022 10:05:56 +0100
Message-Id: <166858955628230@kroah.com>
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

I'm announcing the release of the 5.10.155 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/virt/kvm/devices/vm.rst                              |    3 
 Makefile                                                           |    2 
 arch/arm64/kernel/efi.c                                            |   52 +-
 arch/mips/kernel/jump_label.c                                      |    2 
 arch/riscv/include/asm/pgtable.h                                   |    1 
 arch/riscv/kernel/process.c                                        |    2 
 arch/riscv/kernel/setup.c                                          |    2 
 arch/riscv/kernel/vdso/Makefile                                    |    2 
 arch/riscv/mm/init.c                                               |   15 
 arch/s390/kvm/kvm-s390.c                                           |   31 +
 arch/s390/kvm/kvm-s390.h                                           |    3 
 arch/s390/kvm/priv.c                                               |   15 
 arch/x86/include/asm/msr-index.h                                   |    8 
 arch/x86/kernel/cpu/amd.c                                          |    6 
 arch/x86/kernel/cpu/hygon.c                                        |    4 
 arch/x86/kvm/svm/svm.c                                             |   10 
 arch/x86/kvm/x86.c                                                 |    2 
 arch/x86/power/cpu.c                                               |    1 
 drivers/ata/libata-scsi.c                                          |    3 
 drivers/dma/at_hdmac.c                                             |  153 ++----
 drivers/dma/at_hdmac_regs.h                                        |   10 
 drivers/dma/mv_xor_v2.c                                            |    1 
 drivers/dma/pxa_dma.c                                              |    4 
 drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c                         |    4 
 drivers/gpu/drm/vc4/vc4_drv.c                                      |    7 
 drivers/hid/hid-hyperv.c                                           |    2 
 drivers/hwspinlock/qcom_hwspinlock.c                               |    2 
 drivers/mmc/host/sdhci-cqhci.h                                     |   24 
 drivers/mmc/host/sdhci-esdhc-imx.c                                 |   89 ---
 drivers/mmc/host/sdhci-of-arasan.c                                 |    3 
 drivers/mmc/host/sdhci-tegra.c                                     |    3 
 drivers/mmc/host/sdhci_am654.c                                     |    7 
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c                   |    4 
 drivers/net/ethernet/aquantia/atlantic/aq_macsec.c                 |    2 
 drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c         |   18 
 drivers/net/ethernet/broadcom/Kconfig                              |    2 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                          |    2 
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c                  |    2 
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c                    |    1 
 drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c                |    2 
 drivers/net/ethernet/freescale/fman/mac.c                          |    9 
 drivers/net/ethernet/marvell/mv643xx_eth.c                         |    1 
 drivers/net/ethernet/marvell/prestera/prestera_rxtx.c              |    7 
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c                      |   11 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c |   14 
 drivers/net/ethernet/neterion/s2io.c                               |   29 -
 drivers/net/ethernet/ni/nixge.c                                    |    1 
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c                |    8 
 drivers/net/ethernet/ti/cpsw.c                                     |    2 
 drivers/net/ethernet/tundra/tsi108_eth.c                           |    5 
 drivers/net/hamradio/bpqether.c                                    |    2 
 drivers/net/macsec.c                                               |   23 
 drivers/net/macvlan.c                                              |    4 
 drivers/net/phy/mscc/mscc_macsec.c                                 |    1 
 drivers/net/tun.c                                                  |   18 
 drivers/net/wan/lapbether.c                                        |    2 
 drivers/phy/st/phy-stm32-usbphyc.c                                 |    2 
 drivers/platform/x86/hp-wmi.c                                      |   12 
 fs/btrfs/tests/btrfs-tests.c                                       |    2 
 fs/fuse/readdir.c                                                  |   10 
 fs/io_uring.c                                                      |    3 
 fs/nilfs2/segment.c                                                |   15 
 fs/nilfs2/super.c                                                  |    2 
 fs/nilfs2/the_nilfs.c                                              |    2 
 fs/udf/namei.c                                                     |    2 
 include/asm-generic/vmlinux.lds.h                                  |    2 
 include/linux/bpf_verifier.h                                       |   23 
 include/uapi/linux/capability.h                                    |    2 
 kernel/bpf/verifier.c                                              |  252 +++++-----
 mm/memremap.c                                                      |    1 
 net/can/af_can.c                                                   |    2 
 net/can/j1939/main.c                                               |    3 
 net/core/skbuff.c                                                  |   36 -
 net/ipv4/tcp.c                                                     |    2 
 net/ipv4/tcp_bpf.c                                                 |    8 
 net/ipv6/addrlabel.c                                               |    1 
 net/tipc/netlink_compat.c                                          |    2 
 net/wireless/reg.c                                                 |   12 
 net/wireless/scan.c                                                |    4 
 scripts/extract-cert.c                                             |    7 
 scripts/sign-file.c                                                |    7 
 sound/hda/hdac_sysfs.c                                             |    4 
 sound/pci/hda/hda_intel.c                                          |    3 
 sound/pci/hda/patch_ca0132.c                                       |    1 
 sound/pci/hda/patch_realtek.c                                      |    1 
 sound/usb/quirks-table.h                                           |    4 
 sound/usb/quirks.c                                                 |    1 
 tools/arch/x86/include/asm/msr-index.h                             |    8 
 tools/bpf/bpftool/common.c                                         |    3 
 tools/perf/util/stat-display.c                                     |    2 
 90 files changed, 611 insertions(+), 473 deletions(-)

Alex Barba (1):
      bnxt_en: fix potentially incorrect return value for ndo_rx_flow_steer

Alexander Potapenko (1):
      ipv6: addrlabel: fix infoleak when sending struct ifaddrlblmsg to network

Alexei Starovoitov (1):
      bpf: Support for pointers beyond pkt_end.

Antoine Tenart (2):
      net: phy: mscc: macsec: clear encryption keys when freeing a flow
      net: atlantic: macsec: clear encryption keys from the stack

Ard Biesheuvel (1):
      arm64: efi: Fix handling of misaligned runtime regions and drop warning

Arend van Spriel (1):
      wifi: cfg80211: fix memory leak in query_regdb_file()

Athira Rajeev (1):
      perf stat: Fix printing os->prefix in CSV metrics output

Atish Patra (1):
      riscv: Separate memory init from paging init

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

Claudio Imbrenda (1):
      KVM: s390x: fix SCK locking

Conor Dooley (1):
      riscv: fix reserved memory setup

Dan Carpenter (1):
      phy: stm32: fix an error code in probe

Doug Brown (1):
      dmaengine: pxa_dma: use platform_get_irq_optional

Edson Juliano Drosdeck (1):
      ALSA: hda/realtek: Add Positivo C6300 model quirk

Eric Dumazet (1):
      net: tun: call napi_schedule_prep() to ensure we own a napi

Evan Quan (1):
      ALSA: hda/hdmi - enable runtime pm for more AMD display audio

Fabio Estevam (1):
      mmc: sdhci-esdhc-imx: Convert the driver to DT-only

Gaosheng Cui (1):
      capabilities: fix undefined behavior in bit shift for CAP_TO_MASK

Greg Kroah-Hartman (1):
      Linux 5.10.155

Jens Axboe (1):
      io_uring: kill goto error handling in io_sqpoll_wait_sq()

Jiaxun Yang (1):
      MIPS: jump_label: Fix compat branch range check

Jiri Benc (1):
      net: gso: fix panic on frag_list with mixed head alloc types

Jisheng Zhang (2):
      riscv: process: fix kernel info leakage
      riscv: vdso: fix build with llvm

Johannes Berg (1):
      wifi: cfg80211: silence a sparse RCU warning

Jorge Lopez (1):
      platform/x86: hp_wmi: Fix rfkill causing soft blocked wifi

Jussi Laako (1):
      ALSA: usb-audio: Add DSD support for Accuphase DAC-60

Kefeng Wang (1):
      riscv: Enable CMA support

Krzysztof Kozlowski (1):
      hwspinlock: qcom: correct MMIO max register for newer SoCs

Kumar Kartikeya Dwivedi (1):
      bpf: Add helper macro bpf_for_each_reg_in_vstate

Linus Torvalds (1):
      cert host tools: Stop complaining about deprecated OpenSSL functions

Lu Wei (1):
      tcp: prohibit TCP_REPAIR_OPTIONS if data was already sent

Matthew Auld (1):
      drm/i915/dmabuf: fix sg_table handling in map_dma_buf

Michael Chan (1):
      bnxt_en: Fix possible crash in bnxt_hwrm_set_coal()

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

Pu Lehui (1):
      bpftool: Fix NULL pointer dereference when pin {PROG, MAP, LINK} without FILE

Rasmus Villemoes (1):
      net: stmmac: dwmac-meson8b: fix meson8b_devm_clk_prepare_enable()

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

Sean Anderson (1):
      net: fman: Unregister ethernet device on removal

Shin'ichiro Kawasaki (1):
      ata: libata-scsi: fix SYNCHRONIZE CACHE (16) command failure

Takashi Iwai (1):
      ALSA: usb-audio: Add quirk entry for M-Audio Micro

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

Wang Yufen (2):
      bpf, sockmap: Fix the sk->sk_forward_alloc warning of sk_stream_kill_queues
      net: tun: Fix memory leaks of napi_get_frags

Xian Wang (1):
      ALSA: hda/ca0132: add quirk for EVGA Z390 DARK

Xin Long (1):
      tipc: fix the msg->req tlv len check in tipc_nl_compat_name_table_dump_header

Yang Yingliang (1):
      HID: hyperv: fix possible memory leak in mousevsc_probe()

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

Zhengchao Shao (12):
      net: lapbether: fix issue of dev reference count leakage in lapbeth_device_event()
      hamradio: fix issue of dev reference count leakage in bpq_device_event()
      can: af_can: fix NULL pointer dereference in can_rx_register()
      drivers: net: xgene: disable napi when register irq failed in xgene_enet_open()
      net: marvell: prestera: fix memory leak in prestera_rxtx_switch_init()
      net: nixge: disable napi when enable interrupts failed in nixge_open()
      net: cpsw: disable napi in cpsw_ndo_open()
      net: cxgb3_main: disable napi when bind qsets failed in cxgb_up()
      cxgb4vf: shut down the adapter when t4vf_update_port_info() failed in cxgb4vf_open()
      ethernet: s2io: disable napi when start nic failed in s2io_card_up()
      net: mv643xx_eth: disable napi when init rxq or txq failed in mv643xx_eth_open()
      ethernet: tundra: free irq when alloc ring failed in tsi108_open()

