Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 600655EDA8B
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 12:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233380AbiI1Kvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 06:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233919AbiI1Kuf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 06:50:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E7584D833;
        Wed, 28 Sep 2022 03:49:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17B13B82024;
        Wed, 28 Sep 2022 10:49:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E08BC433C1;
        Wed, 28 Sep 2022 10:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664362184;
        bh=FxV5FuB1zdO0Lu+kxn/v13c9yrzk+dUpE6xFqtu403k=;
        h=From:To:Cc:Subject:Date:From;
        b=nXwBkxIAM7JxvCrGBfnEMQBwVPJG8IsnG/DvaRifenxzWKR28EjhRAypfrmf84aZw
         snfLV5IcwrBpW3JMFKPqze8Ch+H2hDG3UmYkvrAoaSX7RJHNUpKGpT9a4lVG9ATBJ7
         GB968t3nmoJMkHXYqYzVwj3WUcqeO9hz2xHG+7Rg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.71
Date:   Wed, 28 Sep 2022 12:49:26 +0200
Message-Id: <166436216672194@kroah.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.71 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                       |    2 
 arch/arm64/boot/dts/rockchip/px30-engicam-px30-core.dtsi       |    4 
 arch/arm64/boot/dts/rockchip/rk3399-gru-bob.dts                |    5 
 arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi        |    9 
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi                  |    1 
 arch/arm64/kernel/topology.c                                   |    2 
 arch/mips/lantiq/clk.c                                         |    1 
 arch/mips/loongson32/common/platform.c                         |   16 
 arch/riscv/kernel/signal.c                                     |    2 
 arch/um/kernel/um_arch.c                                       |    2 
 arch/x86/kvm/emulate.c                                         |    3 
 arch/x86/kvm/mmu/mmu.c                                         |   40 
 arch/x86/kvm/x86.c                                             |    1 
 drivers/dax/hmem/device.c                                      |    1 
 drivers/dma/ti/k3-udma-private.c                               |    6 
 drivers/firmware/arm_scmi/reset.c                              |   10 
 drivers/firmware/efi/libstub/secureboot.c                      |    8 
 drivers/firmware/efi/libstub/x86-stub.c                        |    7 
 drivers/gpio/gpio-mockup.c                                     |    6 
 drivers/gpio/gpiolib-cdev.c                                    |    5 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                     |   18 
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c                    |   13 
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c                       |   42 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h                       |    1 
 drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c |    3 
 drivers/gpu/drm/amd/display/dc/dml/dcn31/display_mode_vba_31.c |  420 ++--------
 drivers/gpu/drm/amd/display/modules/color/color_gamma.c        |    4 
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c        |   11 
 drivers/gpu/drm/gma500/gma_display.c                           |   11 
 drivers/gpu/drm/hisilicon/hibmc/Kconfig                        |    3 
 drivers/gpu/drm/mediatek/mtk_dsi.c                             |   24 
 drivers/gpu/drm/panel/panel-simple.c                           |    2 
 drivers/gpu/drm/rockchip/cdn-dp-core.c                         |    5 
 drivers/hv/vmbus_drv.c                                         |   10 
 drivers/i2c/busses/i2c-imx.c                                   |    2 
 drivers/i2c/busses/i2c-mlxbf.c                                 |   68 -
 drivers/iommu/intel/iommu.c                                    |    2 
 drivers/media/usb/b2c2/flexcop-usb.c                           |    2 
 drivers/net/bonding/bond_3ad.c                                 |    5 
 drivers/net/bonding/bond_main.c                                |   72 +
 drivers/net/can/flexcan.c                                      |   10 
 drivers/net/can/usb/gs_usb.c                                   |    4 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                      |   10 
 drivers/net/ethernet/freescale/enetc/Makefile                  |    1 
 drivers/net/ethernet/freescale/enetc/enetc.c                   |   53 -
 drivers/net/ethernet/freescale/enetc/enetc.h                   |   12 
 drivers/net/ethernet/freescale/enetc/enetc_pf.c                |   32 
 drivers/net/ethernet/freescale/enetc/enetc_qos.c               |   23 
 drivers/net/ethernet/freescale/enetc/enetc_vf.c                |   17 
 drivers/net/ethernet/intel/i40e/i40e_main.c                    |   32 
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c             |   20 
 drivers/net/ethernet/intel/iavf/iavf_txrx.c                    |    9 
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c                |    7 
 drivers/net/ethernet/intel/ice/ice_main.c                      |    2 
 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c     |    6 
 drivers/net/ethernet/microsoft/mana/gdma_main.c                |   10 
 drivers/net/ethernet/renesas/ravb_main.c                       |    2 
 drivers/net/ethernet/renesas/sh_eth.c                          |    2 
 drivers/net/ethernet/sfc/efx_channels.c                        |    2 
 drivers/net/ethernet/sfc/tx.c                                  |    2 
 drivers/net/ethernet/sun/sunhme.c                              |    4 
 drivers/net/ipa/ipa_qmi.c                                      |    8 
 drivers/net/ipa/ipa_qmi_msg.c                                  |    8 
 drivers/net/ipa/ipa_qmi_msg.h                                  |   37 
 drivers/net/ipa/ipa_table.c                                    |    2 
 drivers/net/ipa/ipa_table.h                                    |    3 
 drivers/net/ipvlan/ipvlan_core.c                               |    6 
 drivers/net/mdio/of_mdio.c                                     |    1 
 drivers/net/phy/aquantia_main.c                                |   53 +
 drivers/net/team/team.c                                        |   24 
 drivers/net/wireguard/netlink.c                                |   13 
 drivers/net/wireguard/selftest/ratelimiter.c                   |   25 
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c                |    2 
 drivers/s390/block/dasd_alias.c                                |    9 
 drivers/scsi/mpt3sas/mpt3sas_base.c                            |    2 
 drivers/scsi/qla2xxx/qla_target.c                              |    4 
 drivers/staging/r8188eu/os_dep/usb_intf.c                      |    2 
 drivers/thunderbolt/icm.c                                      |    1 
 drivers/thunderbolt/nhi.h                                      |    1 
 drivers/tty/serial/fsl_lpuart.c                                |    9 
 drivers/tty/serial/serial-tegra.c                              |    5 
 drivers/tty/serial/tegra-tcu.c                                 |    2 
 drivers/usb/core/hub.c                                         |    2 
 drivers/usb/dwc3/core.c                                        |   17 
 drivers/usb/dwc3/core.h                                        |    4 
 drivers/usb/dwc3/gadget.c                                      |   81 +
 drivers/usb/serial/option.c                                    |    6 
 fs/btrfs/disk-io.c                                             |   42 -
 fs/dax.c                                                       |    3 
 fs/ext4/extents.c                                              |    4 
 fs/ext4/ialloc.c                                               |    2 
 fs/ext4/mballoc.c                                              |   69 -
 fs/nfs/delegation.c                                            |   10 
 fs/xfs/libxfs/xfs_inode_buf.c                                  |   35 
 fs/xfs/xfs_inode.c                                             |   22 
 include/asm-generic/vmlinux.lds.h                              |    3 
 include/linux/cpumask.h                                        |    5 
 include/linux/serial_core.h                                    |   17 
 include/net/bond_3ad.h                                         |    2 
 include/net/bonding.h                                          |    3 
 kernel/workqueue.c                                             |    6 
 mm/slub.c                                                      |   18 
 net/bridge/netfilter/ebtables.c                                |    4 
 net/core/flow_dissector.c                                      |    5 
 net/netfilter/nf_conntrack_irc.c                               |   34 
 net/netfilter/nf_conntrack_sip.c                               |    4 
 net/netfilter/nf_tables_api.c                                  |    8 
 net/netfilter/nfnetlink_osf.c                                  |    4 
 net/sched/cls_api.c                                            |    1 
 net/sched/sch_taprio.c                                         |   18 
 net/smc/smc_core.c                                             |    5 
 sound/core/init.c                                              |   10 
 sound/pci/hda/hda_intel.c                                      |    2 
 sound/pci/hda/patch_hdmi.c                                     |    1 
 sound/pci/hda/patch_realtek.c                                  |   32 
 sound/usb/endpoint.c                                           |   23 
 sound/usb/endpoint.h                                           |    6 
 sound/usb/pcm.c                                                |   14 
 tools/perf/util/bpf_skel/bperf_cgroup.bpf.c                    |    2 
 tools/perf/util/genelf.c                                       |   14 
 tools/perf/util/genelf.h                                       |    4 
 tools/perf/util/symbol-elf.c                                   |    7 
 tools/perf/util/synthetic-events.c                             |   17 
 tools/testing/selftests/net/forwarding/sch_red.sh              |    1 
 124 files changed, 1049 insertions(+), 844 deletions(-)

Adrian Hunter (1):
      perf kcore_copy: Do not check /proc/modules is unchanged

Al Viro (1):
      riscv: fix a nasty sigreturn bug...

Alan Stern (1):
      USB: core: Fix RST error in hub.c

Alex Deucher (2):
      drm/amdgpu: make sure to init common IP before gmc
      drm/amdgpu: don't register a dirty callback for non-atomic

Alex Elder (1):
      net: ipa: properly limit modem routing table use

Andy Shevchenko (1):
      gpio: mockup: Fix potential resource leakage when register a chip

AngeloGioacchino Del Regno (1):
      drm/mediatek: dsi: Add atomic {destroy,duplicate}_state, reset callbacks

Ard Biesheuvel (2):
      efi: x86: Wipe setup_data on pure EFI boot
      efi: libstub: check Shim mode using MokSBStateRT

Asmaa Mnebhi (3):
      i2c: mlxbf: incorrect base address passed during io write
      i2c: mlxbf: prevent stack overflow in mlxbf_i2c_smbus_start_transaction()
      i2c: mlxbf: Fix frequency calculation

Bartosz Golaszewski (1):
      gpio: mockup: fix NULL pointer dereference when removing debugfs

Benjamin Poirier (3):
      net: bonding: Share lacpdu_mcast_addr definition
      net: bonding: Unsync device addresses on ndo_stop
      net: team: Unsync device addresses on ndo_stop

Brett Creeley (1):
      iavf: Fix cached head and tail value for iavf_get_tx_pending

Brian Foster (1):
      xfs: fix xfs_ifree() error handling to not leak perag ref

Brian Norris (1):
      arm64: dts: rockchip: Pull up wlan wake# on Gru-Bob

Callum Osmotherly (2):
      ALSA: hda/realtek: Enable 4-speaker output Dell Precision 5570 laptop
      ALSA: hda/realtek: Enable 4-speaker output Dell Precision 5530 laptop

Candy Febriyanto (1):
      staging: r8188eu: Remove support for devices with 8188FU chipset (0bda:f179)

Carl Yin(殷张成) (1):
      USB: serial: option: add Quectel BG95 0x0203 composition

Chao Yu (1):
      mm/slub: fix to return errno if kmalloc() fails

Christian Lamparter (1):
      um: fix default console kernel parameter

Cristian Marussi (2):
      firmware: arm_scmi: Harden accesses to the reset domains
      firmware: arm_scmi: Fix the asynchronous reset requests

Dan Williams (1):
      devdax: Fix soft-reservation memory description

Dave Chinner (2):
      xfs: reorder iunlink remove operation in xfs_ifree
      xfs: validate inode fork size against fork format

Dave Ertman (1):
      ice: Don't double unplug aux on peer initiated reset

David Leadbeater (1):
      netfilter: nf_conntrack_irc: Tighten matching on DCC message

David Matlack (1):
      KVM: x86/mmu: Fold rmap_recycle into rmap_add

David Thompson (1):
      mlxbf_gige: clear MDIO gateway lock after read

Fabio Estevam (1):
      arm64: dts: rockchip: Remove 'enable-active-low' from rk3399-puma

Felix Fietkau (1):
      wifi: mt76: fix reading current per-tid starting sequence number for aggregation

Filipe Manana (2):
      btrfs: fix hang during unmount when stopping block group reclaim worker
      btrfs: fix hang during unmount when stopping a space reclaim worker

Florian Westphal (1):
      netfilter: ebtables: fix memory leak when blob is malformed

Geert Uytterhoeven (2):
      net: ravb: Fix PHY state warning splat during system resume
      net: sh_eth: Fix PHY state warning splat during system resume

Gil Fine (1):
      thunderbolt: Add support for Intel Maple Ridge single port controller

Greg Kroah-Hartman (3):
      Revert "usb: add quirks for Lenovo OneLink+ Dock"
      Revert "usb: gadget: udc-xilinx: replace memcpy with memcpy_toio"
      Linux 5.15.71

Guchun Chen (1):
      drm/amd/pm: disable BACO entry/exit completely on several sienna cichlid cards

Haiyang Zhang (1):
      net: mana: Add rmb after checking owner bits

Hamza Mahfooz (1):
      drm/amdgpu: use dirty framebuffer helper

Hangbin Liu (1):
      selftests: forwarding: add shebang for sch_red.sh

Hangyu Hua (1):
      net: sched: fix possible refcount leak in tc_new_tfilter()

Hans de Goede (1):
      drm/gma500: Fix BUG: sleeping function called from invalid context errors

Heiko Schocher (1):
      drm/panel: simple: Fix innolux_g121i1_l01 bus_format

Igor Ryzhov (1):
      netfilter: nf_conntrack_sip: fix ct_sip_walk_headers

Ilpo Järvinen (3):
      serial: Create uart_xmit_advance()
      serial: tegra: Use uart_xmit_advance(), fixes icount.tx accounting
      serial: tegra-tcu: Use uart_xmit_advance(), fixes icount.tx accounting

Ioana Ciornei (1):
      net: phy: aquantia: wait for the suspend/resume operations to finish

Jagan Teki (1):
      arm64: dts: rockchip: Fix typo in lisense text for PX30.Core

Jakub Kicinski (1):
      bnxt: prevent skb UAF after handing over to PTP worker

Jan Kara (4):
      ext4: make directory inode spreading reflect flexbg size
      ext4: make mballoc try target group first even with mb_optimize_scan
      ext4: avoid unnecessary spreading of allocations among groups
      ext4: use locality group preallocation for small closed files

Jason A. Donenfeld (2):
      wireguard: ratelimiter: disable timings test by default
      wireguard: netlink: avoid variable-sized memcpy on sockaddr

Javier Martinez Canillas (1):
      drm/hisilicon/hibmc: Allow to be built if COMPILE_TEST is enabled

Jean-Francois Le Fillatre (1):
      usb: add quirks for Lenovo OneLink+ Dock

Jingwen Chen (1):
      drm/amd/amdgpu: fixing read wrong pf2vf data in SRIOV

Johan Hovold (1):
      media: flexcop-usb: fix endpoint type check

Jonathan Toppins (1):
      bonding: fix NULL deref in bond_rr_gen_slave_id

Kai Vehmanen (1):
      ALSA: hda: add Intel 5 Series / 3400 PCI DID

Larry Finger (1):
      staging: r8188eu: Add Rosewill USB-N150 Nano to device tables

Li Jinlin (1):
      fsdax: Fix infinite loop in dax_iomap_rw()

Liang He (2):
      dmaengine: ti: k3-udma-private: Fix refcount leak bug in of_xudma_dev_get()
      of: mdio: Add of_node_put() when breaking out of for_each_xx

Lieven Hey (1):
      perf jit: Include program header in ELF files

Lu Wei (1):
      ipvlan: Fix out-of-bound bugs caused by unset skb->mac_header

Ludovic Cintrat (1):
      net: core: fix flow symmetric hash

Lukas Wunner (1):
      serial: fsl_lpuart: Reset prior to registration

Luke D. Jones (3):
      ALSA: hda/realtek: Add pincfg for ASUS G513 HP jack
      ALSA: hda/realtek: Add pincfg for ASUS G533Z HP jack
      ALSA: hda/realtek: Add quirk for ASUS GA503R laptop

Luís Henriques (1):
      ext4: fix bug in extents parsing when eh_entries == 0 and eh_depth > 0

Marc Kleine-Budde (2):
      can: flexcan: flexcan_mailbox_read() fix return value for drop = true
      can: gs_usb: gs_can_open(): fix race dev->can.state condition

Maurizio Lombardi (1):
      mm: slub: fix flush_cpu_slab()/__free_slab() invocations in task context.

Meng Li (1):
      gpiolib: cdev: Set lineevent_state::irq after IRQ register successfully

Michal Jaron (3):
      iavf: Fix set max MTU size with port VLAN and jumbo frames
      i40e: Fix VF set max MTU size
      i40e: Fix set max_tx_rate when it is lower than 1 Mbps

Mohan Kumar (1):
      ALSA: hda/tegra: set depop delay for tegra

Namhyung Kim (2):
      perf stat: Fix BPF program section name
      perf tools: Honor namespace when synthesizing build-ids

Nathan Chancellor (3):
      drm/amd/display: Reduce number of arguments of dml31's CalculateWatermarksAndDRAMSpeedChangeSupport()
      drm/amd/display: Reduce number of arguments of dml31's CalculateFlipSchedule()
      drm/amd/display: Mark dml30's UseMinimumDCFCLK() as noinline for stack usage

Nathan Huckleberry (1):
      drm/rockchip: Fix return type of cdn_dp_connector_mode_valid

Norbert Zulinski (1):
      iavf: Fix bad page state

Nícolas F. R. A. Prado (1):
      drm/mediatek: dsi: Move mtk_dsi_stop() call back to mtk_dsi_poweroff()

Pablo Neira Ayuso (1):
      netfilter: nfnetlink_osf: fix possible bogus match in nf_osf_find()

Peter Collingbourne (1):
      kasan: call kasan_malloc() from __kmalloc_*track_caller()

Phil Auld (1):
      drivers/base: Fix unsigned comparison to -1 in CPUMAP_FILE_MAX_BYTES

Piyush Mehta (1):
      usb: gadget: udc-xilinx: replace memcpy with memcpy_toio

Rafael Mendonca (1):
      scsi: qla2xxx: Fix memory leak in __qlt_24xx_handle_abts()

Randy Dunlap (2):
      MIPS: lantiq: export clk_get_io() for lantiq_wdt.ko
      drm/hisilicon: Add depends on MMU

Sean Anderson (1):
      net: sunhme: Fix packet reception for len < RX_COPY_THRESHOLD

Sean Christopherson (1):
      KVM: x86: Inject #UD on emulated XSETBV if XSAVES isn't enabled

Serge Semin (1):
      MIPS: Loongson32: Fix PHY-mode being left unspecified

Sergey Shtylyov (1):
      arm64: topology: fix possible overflow in amu_fie_setup()

Sreekanth Reddy (1):
      scsi: mpt3sas: Fix return value check of dma_get_required_mask()

Stefan Haberland (1):
      s390/dasd: fix Oops in dasd_alias_get_start_dev due to missing pavgroup

Takashi Iwai (3):
      Revert "ALSA: usb-audio: Split endpoint setups for hw_params and prepare"
      ALSA: core: Fix double-free at snd_card_new()
      ALSA: hda/realtek: Re-arrange quirk table entries

Tetsuo Handa (3):
      netfilter: nf_tables: fix nft_counters_enabled underflow at nf_tables_addchain()
      netfilter: nf_tables: fix percpu memory leak at nf_tables_addchain()
      workqueue: don't skip lockdep work dependency in cancel_work_sync()

Theodore Ts'o (1):
      ext4: limit the number of retries after discarding preallocations blocks

Thinh Nguyen (3):
      usb: dwc3: gadget: Prevent repeat pullup()
      usb: dwc3: gadget: Refactor pullup()
      usb: dwc3: gadget: Don't modify GEVNTCOUNT in pullup()

Trond Myklebust (1):
      NFSv4: Fixes for nfs4_inode_return_delegation()

Uwe Kleine-König (1):
      i2c: imx: If pm_runtime_get_sync() returned 1 device access is possible

Victor Skvortsov (1):
      drm/amdgpu: Separate vf2pf work item init from virt data exchange

Vitaly Kuznetsov (1):
      Drivers: hv: Never allocate anything besides framebuffer from framebuffer memory region

Vladimir Oltean (4):
      net: enetc: move enetc_set_psfp() out of the common enetc_set_features()
      net: enetc: deny offload of tc-based TSN features on VF interfaces
      net/sched: taprio: avoid disabling offload when it was never enabled
      net/sched: taprio: make qdisc_leaf() see the per-netdev-queue pfifo child qdiscs

Wen Gu (1):
      net/smc: Stop the CLC flow if no link to map buffers on

Wesley Cheng (3):
      usb: dwc3: gadget: Avoid starting DWC3 gadget during UDC unbind
      usb: dwc3: Issue core soft reset before enabling run/stop
      usb: dwc3: gadget: Avoid duplicate requests to enable Run/Stop

Will Deacon (1):
      vmlinux.lds.h: CFI: Reduce alignment of jump-table to function alignment

William Wu (1):
      usb: dwc3: core: leave default DMA if the controller does not support 64-bit DMA

Yao Wang1 (1):
      drm/amd/display: Limit user regamma to a valid value

Yi Liu (1):
      iommu/vt-d: Check correct capability for sagaw determination

huangwenhui (1):
      ALSA: hda/realtek: Add quirk for Huawei WRT-WX9

jerry meng (1):
      USB: serial: option: add Quectel RM520N

zain wang (1):
      arm64: dts: rockchip: Set RK3399-Gru PCLK_EDP to 24 MHz

Íñigo Huguet (2):
      sfc: fix TX channel offset when using legacy interrupts
      sfc: fix null pointer dereference in efx_hard_start_xmit

