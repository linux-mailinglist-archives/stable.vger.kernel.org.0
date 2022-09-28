Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4AFE5EDA77
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 12:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233766AbiI1Kub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 06:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbiI1KuX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 06:50:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB05E3F32D;
        Wed, 28 Sep 2022 03:49:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B411361E18;
        Wed, 28 Sep 2022 10:49:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15FDC433B5;
        Wed, 28 Sep 2022 10:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664362178;
        bh=sVxMM/UgvDCRifgHEJz0jl5zim/RpB0ie1rVgkFRqJc=;
        h=From:To:Cc:Subject:Date:From;
        b=mbtmpOCOjVe9qYINmfLYzGABxSEM/AHomnY0ANNciqhpRgAPEE6wjrocAPo16KqE1
         /qBxmFGhNZb7WGFKhWVQ9RZxzXxFcCzkaJDuU+BV55KloGY/oEyI2zta0aHIXLiqTs
         Vt+laaNM9ttyqBR42306MFn2/57UiCzuTvlmYRfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.146
Date:   Wed, 28 Sep 2022 12:49:21 +0200
Message-Id: <1664362162207228@kroah.com>
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

I'm announcing the release of the 5.10.146 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                       |    2 
 arch/arm64/Kconfig                                             |    5 
 arch/arm64/boot/dts/rockchip/rk3399-gru-bob.dts                |    5 
 arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi        |    9 
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi                  |    1 
 arch/mips/lantiq/clk.c                                         |    1 
 arch/mips/loongson32/common/platform.c                         |   16 
 arch/riscv/kernel/signal.c                                     |    2 
 arch/x86/include/asm/kvm_host.h                                |    1 
 arch/x86/kvm/svm/sev.c                                         |    8 
 arch/x86/kvm/svm/svm.c                                         |    1 
 arch/x86/kvm/svm/svm.h                                         |    2 
 arch/x86/kvm/x86.c                                             |    6 
 drivers/dax/hmem/device.c                                      |    1 
 drivers/dma/ti/k3-udma-private.c                               |    6 
 drivers/firmware/efi/libstub/secureboot.c                      |    8 
 drivers/firmware/efi/libstub/x86-stub.c                        |    7 
 drivers/gpio/gpio-mockup.c                                     |    2 
 drivers/gpio/gpiolib-cdev.c                                    |    5 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                     |   23 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c                    |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c                        |   15 
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c                       |   34 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h                       |    1 
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c                         |    5 
 drivers/gpu/drm/amd/amdgpu/soc15.c                             |   25 -
 drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c |    3 
 drivers/gpu/drm/amd/display/modules/color/color_gamma.c        |    4 
 drivers/gpu/drm/gma500/gma_display.c                           |   11 
 drivers/gpu/drm/hisilicon/hibmc/Kconfig                        |    3 
 drivers/gpu/drm/mediatek/mtk_dsi.c                             |   24 -
 drivers/gpu/drm/panel/panel-simple.c                           |    2 
 drivers/gpu/drm/rockchip/cdn-dp-core.c                         |    5 
 drivers/hv/vmbus_drv.c                                         |   10 
 drivers/i2c/busses/i2c-imx.c                                   |    2 
 drivers/i2c/busses/i2c-mlxbf.c                                 |   68 +---
 drivers/interconnect/qcom/icc-rpmh.c                           |   10 
 drivers/interconnect/qcom/sm8150.c                             |    1 
 drivers/interconnect/qcom/sm8250.c                             |    1 
 drivers/iommu/intel/iommu.c                                    |    2 
 drivers/media/usb/b2c2/flexcop-usb.c                           |    2 
 drivers/mmc/core/sd.c                                          |   42 --
 drivers/net/bonding/bond_3ad.c                                 |    5 
 drivers/net/bonding/bond_main.c                                |   57 ++-
 drivers/net/can/flexcan.c                                      |   10 
 drivers/net/can/usb/gs_usb.c                                   |    4 
 drivers/net/ethernet/freescale/enetc/enetc.c                   |   32 -
 drivers/net/ethernet/freescale/enetc/enetc.h                   |    9 
 drivers/net/ethernet/freescale/enetc/enetc_pf.c                |   11 
 drivers/net/ethernet/freescale/enetc/enetc_qos.c               |   23 +
 drivers/net/ethernet/freescale/enetc/enetc_vf.c                |    4 
 drivers/net/ethernet/intel/i40e/i40e_main.c                    |   32 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c             |   20 +
 drivers/net/ethernet/intel/iavf/iavf_txrx.c                    |    9 
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c                |    7 
 drivers/net/ethernet/sfc/efx_channels.c                        |    2 
 drivers/net/ethernet/sfc/tx.c                                  |    2 
 drivers/net/ethernet/sun/sunhme.c                              |    4 
 drivers/net/ipa/gsi.c                                          |   16 
 drivers/net/ipa/gsi_private.h                                  |    2 
 drivers/net/ipa/gsi_trans.c                                    |    9 
 drivers/net/ipa/ipa_cmd.c                                      |    2 
 drivers/net/ipa/ipa_data.h                                     |    4 
 drivers/net/ipa/ipa_qmi.c                                      |   10 
 drivers/net/ipa/ipa_qmi_msg.c                                  |    8 
 drivers/net/ipa/ipa_qmi_msg.h                                  |   37 +-
 drivers/net/ipa/ipa_table.c                                    |   88 ++---
 drivers/net/ipa/ipa_table.h                                    |    6 
 drivers/net/ipvlan/ipvlan_core.c                               |    6 
 drivers/net/mdio/of_mdio.c                                     |    1 
 drivers/net/phy/aquantia_main.c                                |   53 +++
 drivers/net/team/team.c                                        |   24 +
 drivers/net/wireguard/netlink.c                                |   13 
 drivers/net/wireguard/selftest/ratelimiter.c                   |   25 -
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c                |    2 
 drivers/s390/block/dasd_alias.c                                |    9 
 drivers/scsi/mpt3sas/mpt3sas_base.c                            |  161 +++++++---
 drivers/scsi/mpt3sas/mpt3sas_base.h                            |    1 
 drivers/tty/serial/atmel_serial.c                              |    8 
 drivers/tty/serial/serial-tegra.c                              |    5 
 drivers/tty/serial/tegra-tcu.c                                 |    2 
 drivers/usb/cdns3/gadget.c                                     |    4 
 drivers/usb/core/hub.c                                         |    2 
 drivers/usb/dwc3/core.c                                        |    4 
 drivers/usb/dwc3/core.h                                        |    4 
 drivers/usb/dwc3/gadget.c                                      |   81 ++---
 drivers/usb/host/xhci-mtk-sch.c                                |  149 +++++----
 drivers/usb/host/xhci-mtk.h                                    |    2 
 drivers/usb/serial/option.c                                    |    6 
 drivers/usb/typec/mux/intel_pmc_mux.c                          |   37 +-
 drivers/vfio/vfio_iommu_type1.c                                |  110 +++++-
 fs/cifs/cifsproto.h                                            |    2 
 fs/cifs/cifssmb.c                                              |    6 
 fs/cifs/connect.c                                              |   22 +
 fs/cifs/transport.c                                            |    6 
 fs/ext4/extents.c                                              |    4 
 fs/ext4/ialloc.c                                               |    2 
 fs/ext4/mballoc.c                                              |    4 
 fs/xfs/libxfs/xfs_inode_buf.c                                  |   35 +-
 fs/xfs/xfs_inode.c                                             |   36 +-
 include/linux/inetdevice.h                                     |    9 
 include/linux/kvm_host.h                                       |    2 
 include/linux/netdevice.h                                      |    8 
 include/linux/serial_core.h                                    |   17 +
 include/net/bond_3ad.h                                         |    2 
 include/net/bonding.h                                          |    3 
 kernel/workqueue.c                                             |    6 
 mm/slub.c                                                      |    5 
 net/bridge/netfilter/ebtables.c                                |    4 
 net/core/dev_ioctl.c                                           |   44 --
 net/core/flow_dissector.c                                      |   21 -
 net/ipv4/devinet.c                                             |    4 
 net/netfilter/nf_conntrack_irc.c                               |   34 +-
 net/netfilter/nf_conntrack_sip.c                               |    4 
 net/netfilter/nf_tables_api.c                                  |    8 
 net/netfilter/nfnetlink_osf.c                                  |    4 
 net/sched/cls_api.c                                            |    1 
 net/sched/sch_taprio.c                                         |   18 -
 net/smc/smc_core.c                                             |    5 
 sound/pci/hda/hda_intel.c                                      |    2 
 sound/pci/hda/patch_hdmi.c                                     |    1 
 sound/pci/hda/patch_realtek.c                                  |   32 +
 tools/perf/util/genelf.c                                       |   14 
 tools/perf/util/genelf.h                                       |    4 
 tools/perf/util/symbol-elf.c                                   |    7 
 tools/testing/selftests/net/forwarding/sch_red.sh              |    1 
 virt/kvm/kvm_main.c                                            |   16 
 127 files changed, 1195 insertions(+), 703 deletions(-)

Adrian Hunter (2):
      mmc: core: Fix inconsistent sd3_bus_mode at UHS-I SD voltage switch failure
      perf kcore_copy: Do not check /proc/modules is unchanged

Al Viro (1):
      riscv: fix a nasty sigreturn bug...

Alan Stern (1):
      USB: core: Fix RST error in hub.c

Alex Deucher (2):
      drm/amdgpu: move nbio sdma_doorbell_range() into sdma code for vega
      drm/amdgpu: make sure to init common IP before gmc

Alex Elder (6):
      net: ipa: fix assumptions about DMA address size
      net: ipa: fix table alignment requirement
      net: ipa: avoid 64-bit modulus
      net: ipa: DMA addresses are nicely aligned
      net: ipa: kill IPA_TABLE_ENTRY_SIZE
      net: ipa: properly limit modem routing table use

Alex Williamson (1):
      vfio/type1: Unpin zero pages

AngeloGioacchino Del Regno (1):
      drm/mediatek: dsi: Add atomic {destroy,duplicate}_state, reset callbacks

Ard Biesheuvel (2):
      efi: x86: Wipe setup_data on pure EFI boot
      efi: libstub: check Shim mode using MokSBStateRT

Arnd Bergmann (1):
      net: socket: remove register_gifconf

Asmaa Mnebhi (3):
      i2c: mlxbf: incorrect base address passed during io write
      i2c: mlxbf: prevent stack overflow in mlxbf_i2c_smbus_start_transaction()
      i2c: mlxbf: Fix frequency calculation

Azhar Shaikh (1):
      usb: typec: intel_pmc_mux: Update IOM port status offset for AlderLake

Bartosz Golaszewski (1):
      gpio: mockup: fix NULL pointer dereference when removing debugfs

Benjamin Poirier (3):
      net: bonding: Share lacpdu_mcast_addr definition
      net: bonding: Unsync device addresses on ndo_stop
      net: team: Unsync device addresses on ndo_stop

Brett Creeley (1):
      iavf: Fix cached head and tail value for iavf_get_tx_pending

Brian Norris (1):
      arm64: dts: rockchip: Pull up wlan wake# on Gru-Bob

Callum Osmotherly (2):
      ALSA: hda/realtek: Enable 4-speaker output Dell Precision 5570 laptop
      ALSA: hda/realtek: Enable 4-speaker output Dell Precision 5530 laptop

Carl Yin(殷张成) (1):
      USB: serial: option: add Quectel BG95 0x0203 composition

Chao Yu (1):
      mm/slub: fix to return errno if kmalloc() fails

Christoph Hellwig (1):
      xfs: fix up non-directory creation in SGID directories

Chunfeng Yun (7):
      usb: xhci-mtk: get the microframe boundary for ESIT
      usb: xhci-mtk: add only one extra CS for FS/LS INTR
      usb: xhci-mtk: use @sch_tt to check whether need do TT schedule
      usb: xhci-mtk: add a function to (un)load bandwidth info
      usb: xhci-mtk: add some schedule error number
      usb: xhci-mtk: allow multiple Start-Split in a microframe
      usb: xhci-mtk: fix issue of out-of-bounds array access

Dan Williams (1):
      devdax: Fix soft-reservation memory description

Daniel Jordan (3):
      vfio/type1: Change success value of vaddr_get_pfn()
      vfio/type1: Prepare for batched pinning with struct vfio_batch
      vfio/type1: fix vaddr_get_pfns() return in vfio_pin_page_external()

Dave Chinner (2):
      xfs: reorder iunlink remove operation in xfs_ifree
      xfs: validate inode fork size against fork format

David Howells (1):
      cifs: use discard iterator to discard unneeded network data more efficiently

David Leadbeater (1):
      netfilter: nf_conntrack_irc: Tighten matching on DCC message

Fabio Estevam (1):
      arm64: dts: rockchip: Remove 'enable-active-low' from rk3399-puma

Felix Fietkau (1):
      wifi: mt76: fix reading current per-tid starting sequence number for aggregation

Florian Westphal (1):
      netfilter: ebtables: fix memory leak when blob is malformed

Greg Kroah-Hartman (3):
      Revert "usb: add quirks for Lenovo OneLink+ Dock"
      Revert "usb: gadget: udc-xilinx: replace memcpy with memcpy_toio"
      Linux 5.10.146

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

Ikjoon Jang (1):
      usb: xhci-mtk: relax TT periodic bandwidth allocation

Ilpo Järvinen (3):
      serial: Create uart_xmit_advance()
      serial: tegra: Use uart_xmit_advance(), fixes icount.tx accounting
      serial: tegra-tcu: Use uart_xmit_advance(), fixes icount.tx accounting

Ioana Ciornei (1):
      net: phy: aquantia: wait for the suspend/resume operations to finish

Jan Kara (1):
      ext4: make directory inode spreading reflect flexbg size

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

Kai Vehmanen (1):
      ALSA: hda: add Intel 5 Series / 3400 PCI DID

Liang He (2):
      dmaengine: ti: k3-udma-private: Fix refcount leak bug in of_xudma_dev_get()
      of: mdio: Add of_node_put() when breaking out of for_each_xx

Lieven Hey (1):
      perf jit: Include program header in ELF files

Lino Sanfilippo (1):
      serial: atmel: remove redundant assignment in rs485_config

Lu Wei (1):
      ipvlan: Fix out-of-bound bugs caused by unset skb->mac_header

Luben Tuikov (1):
      drm/amdgpu: Fix check for RAS support

Ludovic Cintrat (1):
      net: core: fix flow symmetric hash

Luke D. Jones (3):
      ALSA: hda/realtek: Add pincfg for ASUS G513 HP jack
      ALSA: hda/realtek: Add pincfg for ASUS G533Z HP jack
      ALSA: hda/realtek: Add quirk for ASUS GA503R laptop

Luís Henriques (1):
      ext4: fix bug in extents parsing when eh_entries == 0 and eh_depth > 0

Marc Kleine-Budde (2):
      can: flexcan: flexcan_mailbox_read() fix return value for drop = true
      can: gs_usb: gs_can_open(): fix race dev->can.state condition

Mark Brown (1):
      arm64/bti: Disable in kernel BTI when cross section thunks are broken

Meng Li (1):
      gpiolib: cdev: Set lineevent_state::irq after IRQ register successfully

Michal Jaron (3):
      iavf: Fix set max MTU size with port VLAN and jumbo frames
      i40e: Fix VF set max MTU size
      i40e: Fix set max_tx_rate when it is lower than 1 Mbps

Mike Tipton (1):
      interconnect: qcom: icc-rpmh: Add BCMs to commit list in pre_aggregate

Mingwei Zhang (1):
      KVM: SEV: add cache flush to solve SEV cache incoherency issues

Mohan Kumar (1):
      ALSA: hda/tegra: set depop delay for tegra

Nathan Chancellor (2):
      arm64: Restrict ARM64_BTI_KERNEL to clang 12.0.0 and newer
      drm/amd/display: Mark dml30's UseMinimumDCFCLK() as noinline for stack usage

Nathan Huckleberry (1):
      drm/rockchip: Fix return type of cdn_dp_connector_mode_valid

Norbert Zulinski (1):
      iavf: Fix bad page state

Nícolas F. R. A. Prado (1):
      drm/mediatek: dsi: Move mtk_dsi_stop() call back to mtk_dsi_poweroff()

Pablo Neira Ayuso (1):
      netfilter: nfnetlink_osf: fix possible bogus match in nf_osf_find()

Pawel Laszczak (2):
      usb: cdns3: fix incorrect handling TRB_SMM flag for ISOC transfer
      usb: cdns3: fix issue with rearming ISO OUT endpoint

Peng Ju Zhou (1):
      drm/amdgpu: indirect register access for nv12 sriov

Piyush Mehta (1):
      usb: gadget: udc-xilinx: replace memcpy with memcpy_toio

Randy Dunlap (2):
      MIPS: lantiq: export clk_get_io() for lantiq_wdt.ko
      drm/hisilicon: Add depends on MMU

Sean Anderson (1):
      net: sunhme: Fix packet reception for len < RX_COPY_THRESHOLD

Serge Semin (1):
      MIPS: Loongson32: Fix PHY-mode being left unspecified

Sergiu Moga (1):
      tty: serial: atmel: Preserve previous USART mode if RS485 disabled

Sreekanth Reddy (1):
      scsi: mpt3sas: Fix return value check of dma_get_required_mask()

Stefan Haberland (1):
      s390/dasd: fix Oops in dasd_alias_get_start_dev due to missing pavgroup

Stefan Metzmacher (1):
      cifs: always initialize struct msghdr smb_msg completely

Suganath Prabu S (1):
      scsi: mpt3sas: Force PCIe scatterlist allocations to be within same 4 GB region

Takashi Iwai (1):
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

Utkarsh Patel (1):
      usb: typec: intel_pmc_mux: Add new ACPI ID for Meteor Lake IOM device

Uwe Kleine-König (1):
      i2c: imx: If pm_runtime_get_sync() returned 1 device access is possible

Victor Skvortsov (1):
      drm/amdgpu: Separate vf2pf work item init from virt data exchange

Vitaly Kuznetsov (1):
      Drivers: hv: Never allocate anything besides framebuffer from framebuffer memory region

Vladimir Oltean (3):
      net: enetc: move enetc_set_psfp() out of the common enetc_set_features()
      net/sched: taprio: avoid disabling offload when it was never enabled
      net/sched: taprio: make qdisc_leaf() see the per-netdev-queue pfifo child qdiscs

Wen Gu (1):
      net/smc: Stop the CLC flow if no link to map buffers on

Wesley Cheng (3):
      usb: dwc3: gadget: Avoid starting DWC3 gadget during UDC unbind
      usb: dwc3: Issue core soft reset before enabling run/stop
      usb: dwc3: gadget: Avoid duplicate requests to enable Run/Stop

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

zhang kai (1):
      net: let flow have same hash in two directions

Íñigo Huguet (2):
      sfc: fix TX channel offset when using legacy interrupts
      sfc: fix null pointer dereference in efx_hard_start_xmit

