Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB2F5EDA8F
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 12:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233387AbiI1Kwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 06:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233828AbiI1KvZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 06:51:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB8657BC3;
        Wed, 28 Sep 2022 03:49:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D51E61DF2;
        Wed, 28 Sep 2022 10:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8648FC433C1;
        Wed, 28 Sep 2022 10:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664362191;
        bh=Dpr9BUrMJpy4bVKELMuaOwqeiUOQdHhzCwpLFDee20s=;
        h=From:To:Cc:Subject:Date:From;
        b=wdBN9seIp/Ldln/mX6UrEkSzoW82NQ98li4j/RnNQwOHd0eBH7PJknIcXfZvV0k+H
         jZyiAsLEliV8hsISDEgEyR/cgueuHPD4hS5okCXQf13gmkF7rJY5ALtgmbEwoInyZ/
         mDQUduTXS1+NrZ02OwGiqSFRCCMZC9LBXKsBtJSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.19.12
Date:   Wed, 28 Sep 2022 12:49:34 +0200
Message-Id: <1664362175225155@kroah.com>
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

I'm announcing the release of the 5.19.12 kernel.

All users of the 5.19 kernel series must upgrade.

The updated 5.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                       |    2 
 arch/arm/boot/dts/lan966x.dtsi                                 |    4 
 arch/arm64/boot/dts/freescale/imx8mm-mx8menlo.dts              |   10 
 arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml-mba8mx.dts      |    1 
 arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml.dtsi            |    1 
 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi               |   10 
 arch/arm64/boot/dts/freescale/imx8mn.dtsi                      |    1 
 arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts         |   12 
 arch/arm64/boot/dts/freescale/imx8ulp.dtsi                     |    3 
 arch/arm64/boot/dts/rockchip/px30-engicam-px30-core.dtsi       |    4 
 arch/arm64/boot/dts/rockchip/rk3399-gru-bob.dts                |    5 
 arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi        |    9 
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi                  |    1 
 arch/arm64/boot/dts/rockchip/rk3566-quartz64-a.dts             |    1 
 arch/arm64/boot/dts/rockchip/rk3566-quartz64-b.dts             |    2 
 arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dts               |    2 
 arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts                |    2 
 arch/arm64/kernel/topology.c                                   |    2 
 arch/mips/lantiq/clk.c                                         |    1 
 arch/mips/loongson32/common/platform.c                         |   16 
 arch/riscv/Kconfig                                             |    1 
 arch/riscv/kernel/signal.c                                     |    2 
 arch/um/kernel/um_arch.c                                       |    2 
 arch/x86/include/asm/kvm_host.h                                |    1 
 arch/x86/kvm/cpuid.c                                           |   11 
 arch/x86/kvm/emulate.c                                         |    3 
 arch/x86/kvm/x86.c                                             |   10 
 block/blk-core.c                                               |   43 -
 block/blk-mq-debugfs.c                                         |    8 
 block/blk-mq.c                                                 |   43 -
 block/blk-sysfs.c                                              |    5 
 block/blk.h                                                    |    3 
 block/bsg-lib.c                                                |    4 
 block/genhd.c                                                  |   45 -
 certs/Kconfig                                                  |    2 
 drivers/block/ataflop.c                                        |    1 
 drivers/block/loop.c                                           |    1 
 drivers/block/mtip32xx/mtip32xx.c                              |    2 
 drivers/block/rnbd/rnbd-clt.c                                  |    2 
 drivers/block/sx8.c                                            |    4 
 drivers/block/virtio_blk.c                                     |    1 
 drivers/block/z2ram.c                                          |    1 
 drivers/cdrom/gdrom.c                                          |    1 
 drivers/dax/hmem/device.c                                      |    1 
 drivers/dma/ti/k3-udma-private.c                               |    6 
 drivers/firmware/arm_scmi/reset.c                              |   10 
 drivers/firmware/efi/libstub/secureboot.c                      |    8 
 drivers/firmware/efi/libstub/x86-stub.c                        |    7 
 drivers/gpio/gpio-ixp4xx.c                                     |   17 
 drivers/gpio/gpio-mockup.c                                     |    6 
 drivers/gpio/gpio-mt7621.c                                     |   21 
 drivers/gpio/gpio-tqmx86.c                                     |    4 
 drivers/gpio/gpiolib-cdev.c                                    |    5 
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c                    |   13 
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c                        |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h                        |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c                        |    3 
 drivers/gpu/drm/amd/amdgpu/nbio_v7_7.c                         |    9 
 drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c |    3 
 drivers/gpu/drm/amd/display/dc/dml/dcn31/display_mode_vba_31.c |  420 ++--------
 drivers/gpu/drm/amd/display/modules/color/color_gamma.c        |    4 
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c        |   11 
 drivers/gpu/drm/gma500/cdv_device.c                            |    4 
 drivers/gpu/drm/gma500/gem.c                                   |    4 
 drivers/gpu/drm/gma500/gma_display.c                           |   11 
 drivers/gpu/drm/gma500/oaktrail_device.c                       |    5 
 drivers/gpu/drm/gma500/power.c                                 |    8 
 drivers/gpu/drm/gma500/psb_drv.c                               |    2 
 drivers/gpu/drm/gma500/psb_drv.h                               |    5 
 drivers/gpu/drm/gma500/psb_irq.c                               |   15 
 drivers/gpu/drm/gma500/psb_irq.h                               |    2 
 drivers/gpu/drm/hisilicon/hibmc/Kconfig                        |    1 
 drivers/gpu/drm/i915/display/g4x_dp.c                          |   22 
 drivers/gpu/drm/i915/display/icl_dsi.c                         |   18 
 drivers/gpu/drm/i915/display/intel_backlight.c                 |   23 
 drivers/gpu/drm/i915/display/intel_bios.c                      |  384 +++++----
 drivers/gpu/drm/i915/display/intel_bios.h                      |    4 
 drivers/gpu/drm/i915/display/intel_ddi.c                       |   22 
 drivers/gpu/drm/i915/display/intel_ddi_buf_trans.c             |    9 
 drivers/gpu/drm/i915/display/intel_display_types.h             |   69 +
 drivers/gpu/drm/i915/display/intel_dp.c                        |   40 
 drivers/gpu/drm/i915/display/intel_dp.h                        |    2 
 drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c          |    6 
 drivers/gpu/drm/i915/display/intel_drrs.c                      |    3 
 drivers/gpu/drm/i915/display/intel_dsi.c                       |    2 
 drivers/gpu/drm/i915/display/intel_dsi_dcs_backlight.c         |    9 
 drivers/gpu/drm/i915/display/intel_dsi_vbt.c                   |   56 -
 drivers/gpu/drm/i915/display/intel_lvds.c                      |    6 
 drivers/gpu/drm/i915/display/intel_panel.c                     |   13 
 drivers/gpu/drm/i915/display/intel_pps.c                       |   70 +
 drivers/gpu/drm/i915/display/intel_psr.c                       |   35 
 drivers/gpu/drm/i915/display/intel_sdvo.c                      |    3 
 drivers/gpu/drm/i915/display/vlv_dsi.c                         |   21 
 drivers/gpu/drm/i915/gem/i915_gem_context.c                    |    8 
 drivers/gpu/drm/i915/i915_drv.h                                |   63 -
 drivers/gpu/drm/i915/i915_gem.c                                |    3 
 drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c                    |    2 
 drivers/gpu/drm/mediatek/mtk_dsi.c                             |   24 
 drivers/gpu/drm/panel/panel-simple.c                           |    2 
 drivers/gpu/drm/rockchip/cdn-dp-core.c                         |    5 
 drivers/hv/vmbus_drv.c                                         |   10 
 drivers/i2c/busses/i2c-imx.c                                   |    2 
 drivers/i2c/busses/i2c-mlxbf.c                                 |   68 -
 drivers/i2c/i2c-mux.c                                          |    5 
 drivers/iommu/intel/iommu.c                                    |    2 
 drivers/media/usb/b2c2/flexcop-usb.c                           |    2 
 drivers/memstick/core/ms_block.c                               |    1 
 drivers/memstick/core/mspro_block.c                            |    1 
 drivers/mmc/core/block.c                                       |    1 
 drivers/mmc/core/queue.c                                       |    1 
 drivers/net/bonding/bond_3ad.c                                 |    5 
 drivers/net/bonding/bond_main.c                                |   72 +
 drivers/net/can/flexcan/flexcan-core.c                         |   10 
 drivers/net/can/usb/gs_usb.c                                   |    4 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                      |   10 
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c                  |    4 
 drivers/net/ethernet/freescale/enetc/Makefile                  |    1 
 drivers/net/ethernet/freescale/enetc/enetc.c                   |   53 -
 drivers/net/ethernet/freescale/enetc/enetc.h                   |   12 
 drivers/net/ethernet/freescale/enetc/enetc_pf.c                |   32 
 drivers/net/ethernet/freescale/enetc/enetc_qos.c               |   23 
 drivers/net/ethernet/freescale/enetc/enetc_vf.c                |   17 
 drivers/net/ethernet/google/gve/gve_rx_dqo.c                   |    2 
 drivers/net/ethernet/intel/i40e/i40e_main.c                    |   32 
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c             |   20 
 drivers/net/ethernet/intel/iavf/iavf_txrx.c                    |    9 
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c                |    7 
 drivers/net/ethernet/intel/ice/ice_lib.c                       |   42 -
 drivers/net/ethernet/intel/ice/ice_main.c                      |   25 
 drivers/net/ethernet/intel/ice/ice_txrx.c                      |    5 
 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c     |    6 
 drivers/net/ethernet/microsoft/mana/gdma_main.c                |   10 
 drivers/net/ethernet/renesas/ravb_main.c                       |    2 
 drivers/net/ethernet/renesas/sh_eth.c                          |    2 
 drivers/net/ethernet/sfc/efx_channels.c                        |    2 
 drivers/net/ethernet/sfc/siena/efx_channels.c                  |    2 
 drivers/net/ethernet/sfc/siena/tx.c                            |    2 
 drivers/net/ethernet/sfc/tx.c                                  |    2 
 drivers/net/ethernet/sun/sunhme.c                              |    4 
 drivers/net/ipa/ipa_qmi.c                                      |    8 
 drivers/net/ipa/ipa_qmi_msg.c                                  |    8 
 drivers/net/ipa/ipa_qmi_msg.h                                  |   37 
 drivers/net/ipa/ipa_table.c                                    |    2 
 drivers/net/ipa/ipa_table.h                                    |    3 
 drivers/net/ipvlan/ipvlan_core.c                               |    6 
 drivers/net/mdio/of_mdio.c                                     |    1 
 drivers/net/netdevsim/hwstats.c                                |    6 
 drivers/net/phy/aquantia_main.c                                |   53 +
 drivers/net/phy/micrel.c                                       |   18 
 drivers/net/team/team.c                                        |   24 
 drivers/net/wireguard/netlink.c                                |   13 
 drivers/net/wireguard/selftest/ratelimiter.c                   |   25 
 drivers/net/wireless/intel/iwlwifi/Kconfig                     |    1 
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c                |    2 
 drivers/nvdimm/pmem.c                                          |    6 
 drivers/nvme/host/apple.c                                      |    2 
 drivers/nvme/host/core.c                                       |    1 
 drivers/nvme/host/fc.c                                         |   12 
 drivers/nvme/host/pci.c                                        |    2 
 drivers/nvme/host/rdma.c                                       |   12 
 drivers/nvme/host/tcp.c                                        |   12 
 drivers/nvme/target/loop.c                                     |   12 
 drivers/perf/arm-cmn.c                                         |    2 
 drivers/phy/marvell/phy-mvebu-a3700-comphy.c                   |   87 --
 drivers/s390/block/dasd.c                                      |    2 
 drivers/s390/block/dasd_alias.c                                |    9 
 drivers/s390/block/dasd_genhd.c                                |    4 
 drivers/scsi/hosts.c                                           |   16 
 drivers/scsi/mpt3sas/mpt3sas_base.c                            |    2 
 drivers/scsi/qla2xxx/qla_target.c                              |    4 
 drivers/scsi/scsi_lib.c                                        |   12 
 drivers/scsi/scsi_priv.h                                       |    2 
 drivers/scsi/scsi_scan.c                                       |    1 
 drivers/scsi/scsi_sysfs.c                                      |    3 
 drivers/scsi/sd.c                                              |    4 
 drivers/scsi/sr.c                                              |    4 
 drivers/thunderbolt/icm.c                                      |    1 
 drivers/thunderbolt/nhi.h                                      |    1 
 drivers/tty/serial/fsl_lpuart.c                                |    9 
 drivers/tty/serial/serial-tegra.c                              |    5 
 drivers/tty/serial/tegra-tcu.c                                 |    2 
 drivers/ufs/core/ufshcd.c                                      |    4 
 drivers/usb/core/hub.c                                         |    2 
 drivers/usb/dwc3/core.c                                        |   13 
 drivers/usb/serial/option.c                                    |    6 
 drivers/xen/xenbus/xenbus_client.c                             |    9 
 fs/btrfs/disk-io.c                                             |   42 -
 fs/btrfs/zoned.c                                               |   40 
 fs/cifs/cifsfs.c                                               |    6 
 fs/cifs/smb2ops.c                                              |   69 +
 fs/dax.c                                                       |    3 
 fs/exfat/fatent.c                                              |    3 
 fs/ext4/ext4.h                                                 |   10 
 fs/ext4/extents.c                                              |    4 
 fs/ext4/ialloc.c                                               |    2 
 fs/ext4/mballoc.c                                              |  317 +++----
 fs/ext4/mballoc.h                                              |    1 
 include/asm-generic/vmlinux.lds.h                              |    3 
 include/linux/blk-mq.h                                         |    3 
 include/linux/blkdev.h                                         |    6 
 include/linux/cpumask.h                                        |    5 
 include/linux/serial_core.h                                    |   17 
 include/net/bond_3ad.h                                         |    2 
 include/net/bonding.h                                          |    3 
 include/scsi/scsi_host.h                                       |    2 
 include/uapi/linux/xfrm.h                                      |    2 
 io_uring/io_uring.c                                            |    3 
 kernel/cgroup/cgroup.c                                         |    5 
 kernel/workqueue.c                                             |    6 
 lib/Kconfig.debug                                              |    4 
 mm/slab_common.c                                               |    5 
 mm/slub.c                                                      |   18 
 net/batman-adv/hard-interface.c                                |    4 
 net/bridge/netfilter/ebtables.c                                |    4 
 net/core/flow_dissector.c                                      |    5 
 net/ipv6/af_inet6.c                                            |    4 
 net/netfilter/nf_conntrack_ftp.c                               |    6 
 net/netfilter/nf_conntrack_irc.c                               |   34 
 net/netfilter/nf_conntrack_sip.c                               |    4 
 net/netfilter/nf_tables_api.c                                  |    8 
 net/netfilter/nfnetlink_osf.c                                  |    4 
 net/sched/cls_api.c                                            |    1 
 net/sched/sch_taprio.c                                         |   18 
 net/smc/smc_core.c                                             |    5 
 scripts/Makefile.debug                                         |   21 
 sound/core/init.c                                              |   10 
 sound/pci/hda/hda_bind.c                                       |    4 
 sound/pci/hda/hda_intel.c                                      |    2 
 sound/pci/hda/patch_hdmi.c                                     |   24 
 sound/pci/hda/patch_realtek.c                                  |   33 
 sound/usb/endpoint.c                                           |   23 
 sound/usb/endpoint.h                                           |    6 
 sound/usb/pcm.c                                                |   14 
 tools/lib/perf/evlist.c                                        |    5 
 tools/perf/util/bpf_counter_cgroup.c                           |    4 
 tools/perf/util/bpf_skel/bperf_cgroup.bpf.c                    |    2 
 tools/perf/util/genelf.c                                       |   14 
 tools/perf/util/genelf.h                                       |    4 
 tools/perf/util/symbol-elf.c                                   |    7 
 tools/perf/util/synthetic-events.c                             |   17 
 tools/testing/selftests/net/forwarding/sch_red.sh              |    1 
 241 files changed, 2011 insertions(+), 1655 deletions(-)

Adrian Hunter (2):
      libperf evlist: Fix polling of system-wide events
      perf kcore_copy: Do not check /proc/modules is unchanged

Al Viro (1):
      riscv: fix a nasty sigreturn bug...

Alan Stern (1):
      USB: core: Fix RST error in hub.c

Alex Deucher (2):
      drm/amdgpu: add HDP remap functionality to nbio 7.7
      drm/amdgpu: don't register a dirty callback for non-atomic

Alex Elder (1):
      net: ipa: properly limit modem routing table use

Allen-KH Cheng (1):
      drm/mediatek: Fix wrong dither settings

Andy Shevchenko (1):
      gpio: mockup: Fix potential resource leakage when register a chip

AngeloGioacchino Del Regno (1):
      drm/mediatek: dsi: Add atomic {destroy,duplicate}_state, reset callbacks

Antony Antony (1):
      xfrm: fix XFRMA_LASTUSED comment

Ard Biesheuvel (2):
      efi: x86: Wipe setup_data on pure EFI boot
      efi: libstub: check Shim mode using MokSBStateRT

Asmaa Mnebhi (3):
      i2c: mlxbf: incorrect base address passed during io write
      i2c: mlxbf: prevent stack overflow in mlxbf_i2c_smbus_start_transaction()
      i2c: mlxbf: Fix frequency calculation

Bart Van Assche (1):
      scsi: core: Fix a use-after-free

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

Candice Li (1):
      drm/amdgpu: Skip reset error status for psp v13_0_0

Carl Yin(殷张成) (1):
      USB: serial: option: add Quectel BG95 0x0203 composition

Chao Yu (1):
      mm/slub: fix to return errno if kmalloc() fails

Chris Wilson (1):
      drm/i915/gem: Really move i915_gem_context.link under ref protection

Christian Lamparter (1):
      um: fix default console kernel parameter

Christoph Hellwig (6):
      block: remove QUEUE_FLAG_DEAD
      block: stop setting the nomerges flags in blk_cleanup_queue
      block: simplify disk shutdown
      blk-mq: fix error handling in __blk_mq_alloc_disk
      block: call blk_mq_exit_queue from disk_release for never added disks
      Revert "block: freeze the queue earlier in del_gendisk"

Cristian Marussi (2):
      firmware: arm_scmi: Harden accesses to the reset domains
      firmware: arm_scmi: Fix the asynchronous reset requests

Dan Carpenter (1):
      i2c: mux: harden i2c_mux_alloc() against integer overflows

Dan Williams (1):
      devdax: Fix soft-reservation memory description

Daniel Houldsworth (1):
      ALSA: hda/realtek: Add a quirk for HP OMEN 16 (8902) mute LED

Dave Ertman (1):
      ice: Don't double unplug aux on peer initiated reset

David Howells (2):
      smb3: Move the flush out of smb2_copychunk_range() into its callers
      smb3: fix temporary data corruption in insert range

David Leadbeater (1):
      netfilter: nf_conntrack_irc: Tighten matching on DCC message

David Thompson (1):
      mlxbf_gige: clear MDIO gateway lock after read

Ding Hui (1):
      ice: Fix crash by keep old cfg when update TCs more than queues

Dongliang Mu (1):
      gpio: tqmx86: fix uninitialized variable girq

Dr. David Alan Gilbert (1):
      KVM: x86: Always enable legacy FP/SSE in allowed user XFEATURES

Fabio Estevam (3):
      arm64: dts: rockchip: Remove 'enable-active-low' from rk3399-puma
      arm64: dts: rockchip: Remove 'enable-active-low' from rk3566-quartz64-a
      arm64: dts: tqma8mqml: Include phy-imx8-pcie.h header

Felix Fietkau (1):
      wifi: mt76: fix reading current per-tid starting sequence number for aggregation

Feng Tang (1):
      mm/slab_common: fix possible double free of kmem_cache

Filipe Manana (2):
      btrfs: fix hang during unmount when stopping block group reclaim worker
      btrfs: fix hang during unmount when stopping a space reclaim worker

Florian Westphal (2):
      netfilter: ebtables: fix memory leak when blob is malformed
      netfilter: nf_ct_ftp: fix deadlock when nat rewrite is needed

Geert Uytterhoeven (2):
      net: ravb: Fix PHY state warning splat during system resume
      net: sh_eth: Fix PHY state warning splat during system resume

Gil Fine (1):
      thunderbolt: Add support for Intel Maple Ridge single port controller

Greg Kroah-Hartman (3):
      Revert "usb: add quirks for Lenovo OneLink+ Dock"
      Revert "usb: gadget: udc-xilinx: replace memcpy with memcpy_toio"
      Linux 5.19.12

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

Hans de Goede (3):
      drm/gma500: Fix BUG: sleeping function called from invalid context errors
      drm/gma500: Fix WARN_ON(lock->magic != lock) error
      drm/gma500: Fix (vblank) IRQs not working after suspend/resume

Heiko Schocher (1):
      drm/panel: simple: Fix innolux_g121i1_l01 bus_format

Horatiu Vultur (1):
      ARM: dts: lan966x: Fix the interrupt number for internal PHYs

Ido Schimmel (2):
      netdevsim: Fix hwstats debugfs file permissions
      ipv6: Fix crash when IPv6 is administratively disabled

Igor Ryzhov (1):
      netfilter: nf_conntrack_sip: fix ct_sip_walk_headers

Ilkka Koskinen (1):
      perf/arm-cmn: Add more bits to child node address offset field

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

Jan Kara (6):
      ext4: make mballoc try target group first even with mb_optimize_scan
      ext4: avoid unnecessary spreading of allocations among groups
      ext4: use locality group preallocation for small closed files
      ext4: use buckets for cr 1 block scan instead of rbtree
      ext4: fixup possible uninitialized variable access in ext4_mb_choose_next_group_cr1()
      ext4: make directory inode spreading reflect flexbg size

Jane Chu (1):
      pmem: fix a name collision

Jani Nikula (2):
      drm/i915/dsi: filter invalid backlight and CABC ports
      drm/i915/dsi: fix dual-link DSI backlight and CABC ports for display 11+

Janusz Krzysztofik (1):
      drm/i915/gem: Flush contexts on driver release

Jason A. Donenfeld (2):
      wireguard: ratelimiter: disable timings test by default
      wireguard: netlink: avoid variable-sized memcpy on sockaddr

Jean-Francois Le Fillatre (1):
      usb: add quirks for Lenovo OneLink+ Dock

Jens Axboe (1):
      io_uring: ensure that cached task references are always put on exit

Johan Hovold (1):
      media: flexcop-usb: fix endpoint type check

Jonathan Toppins (1):
      bonding: fix NULL deref in bond_rr_gen_slave_id

José Roberto de Souza (1):
      drm/i915/display: Fix handling of enable_psr parameter

Juergen Gross (1):
      xen/xenbus: fix xenbus_setup_ring()

Kai Vehmanen (1):
      ALSA: hda: add Intel 5 Series / 3400 PCI DID

Larysa Zaremba (1):
      ice: Fix ice_xdp_xmit() when XDP TX queue number is not sufficient

Li Jinlin (1):
      fsdax: Fix infinite loop in dax_iomap_rw()

Liang He (2):
      dmaengine: ti: k3-udma-private: Fix refcount leak bug in of_xudma_dev_get()
      of: mdio: Add of_node_put() when breaking out of for_each_xx

Lieven Hey (1):
      perf jit: Include program header in ELF files

Linus Walleij (1):
      gpio: ixp4xx: Make irqchip immutable

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

Marco Felsch (1):
      arm64: dts: imx8mn: remove GPU power domain reset

Marek Vasut (1):
      arm64: dts: imx8mm: Reverse CPLD_Dn GPIO label mapping on MX8Menlo

Masahiro Yamada (1):
      certs: make system keyring depend on built-in x509 parser

Mateusz Palczewski (1):
      ice: Fix interface being down after reset with link-down-on-close flag on

Maurizio Lombardi (1):
      mm: slub: fix flush_cpu_slab()/__free_slab() invocations in task context.

Meng Li (1):
      gpiolib: cdev: Set lineevent_state::irq after IRQ register successfully

Michael Riesch (2):
      arm64: dts: rockchip: fix property for usb2 phy supply on rock-3a
      arm64: dts: rockchip: fix property for usb2 phy supply on rk3568-evb1-v10

Michael Walle (1):
      net: phy: micrel: fix shared interrupt on LAN8814

Michal Jaron (3):
      iavf: Fix set max MTU size with port VLAN and jumbo frames
      i40e: Fix VF set max MTU size
      i40e: Fix set max_tx_rate when it is lower than 1 Mbps

Michal Swiatkowski (1):
      ice: config netdev tc before setting queues number

Ming Lei (1):
      cgroup: cgroup_get_from_id() must check the looked-up kn is a directory

Mohan Kumar (2):
      ALSA: hda/tegra: set depop delay for tegra
      ALSA: hda: Fix Nvidia dp infoframe

Namhyung Kim (3):
      perf stat: Fix BPF program section name
      perf stat: Fix cpu map index in bperf cgroup code
      perf tools: Honor namespace when synthesizing build-ids

Naohiro Aota (1):
      btrfs: zoned: wait for extent buffer IOs before finishing a zone

Nathan Chancellor (3):
      drm/amd/display: Reduce number of arguments of dml31's CalculateWatermarksAndDRAMSpeedChangeSupport()
      drm/amd/display: Reduce number of arguments of dml31's CalculateFlipSchedule()
      drm/amd/display: Mark dml30's UseMinimumDCFCLK() as noinline for stack usage

Nathan Huckleberry (1):
      drm/rockchip: Fix return type of cdn_dp_connector_mode_valid

Nick Desaulniers (2):
      Makefile.debug: set -g unconditional on CONFIG_DEBUG_INFO_SPLIT
      Makefile.debug: re-enable debug info for .S files

Nicolas Frattaroli (1):
      arm64: dts: rockchip: Lower sd speed on quartz64-b

Norbert Zulinski (1):
      iavf: Fix bad page state

Nícolas F. R. A. Prado (1):
      drm/mediatek: dsi: Move mtk_dsi_stop() call back to mtk_dsi_poweroff()

Pablo Neira Ayuso (1):
      netfilter: nfnetlink_osf: fix possible bogus match in nf_osf_find()

Pali Rohár (1):
      phy: marvell: phy-mvebu-a3700-comphy: Remove broken reset support

Peng Fan (1):
      arm64: dts: imx8ulp: add #reset-cells for pcc

Peter Collingbourne (1):
      kasan: call kasan_malloc() from __kmalloc_*track_caller()

Phil Auld (1):
      drivers/base: Fix unsigned comparison to -1 in CPUMAP_FILE_MAX_BYTES

Philippe Schenker (1):
      arm64: dts: imx8mm-verdin: extend pmic voltages

Piyush Mehta (1):
      usb: gadget: udc-xilinx: replace memcpy with memcpy_toio

Rafael Mendonca (2):
      scsi: qla2xxx: Fix memory leak in __qlt_24xx_handle_abts()
      block: Do not call blk_put_queue() if gendisk allocation fails

Randy Dunlap (3):
      riscv: fix RISCV_ISA_SVPBMT kconfig dependency warning
      MIPS: lantiq: export clk_get_io() for lantiq_wdt.ko
      drm/hisilicon: Add depends on MMU

Sean Anderson (1):
      net: sunhme: Fix packet reception for len < RX_COPY_THRESHOLD

Sean Christopherson (2):
      KVM: x86: Reinstate kvm_vcpu_arch.guest_supported_xcr0
      KVM: x86: Inject #UD on emulated XSETBV if XSAVES isn't enabled

Serge Semin (1):
      MIPS: Loongson32: Fix PHY-mode being left unspecified

Sergey Shtylyov (1):
      arm64: topology: fix possible overflow in amu_fie_setup()

Sergio Paracuellos (1):
      gpio: mt7621: Make the irqchip immutable

Shailend Chand (1):
      gve: Fix GFP flags when allocing pages

Shigeru Yoshida (1):
      batman-adv: Fix hang up with small MTU hard-interface

Sreekanth Reddy (1):
      scsi: mpt3sas: Fix return value check of dma_get_required_mask()

Stefan Haberland (1):
      s390/dasd: fix Oops in dasd_alias_get_start_dev due to missing pavgroup

Steve French (2):
      smb3: fix temporary data corruption in collapse range
      smb3: use filemap_write_and_wait_range instead of filemap_write_and_wait

Takashi Iwai (4):
      Revert "ALSA: usb-audio: Split endpoint setups for hw_params and prepare"
      ALSA: core: Fix double-free at snd_card_new()
      ALSA: hda: Fix hang at HD-audio codec unbinding due to refcount saturation
      ALSA: hda/realtek: Re-arrange quirk table entries

Tetsuo Handa (3):
      netfilter: nf_tables: fix nft_counters_enabled underflow at nf_tables_addchain()
      netfilter: nf_tables: fix percpu memory leak at nf_tables_addchain()
      workqueue: don't skip lockdep work dependency in cancel_work_sync()

Theodore Ts'o (1):
      ext4: limit the number of retries after discarding preallocations blocks

Tim Harvey (3):
      arm64: dts: imx8mp-venice-gw74xx: fix CAN STBY polarity
      arm64: dts: imx8mp-venice-gw74xx: fix ksz9477 cpu port
      arm64: dts: imx8mp-venice-gw74xx: fix port/phy validation

Toke Høiland-Jørgensen (1):
      wifi: iwlwifi: Mark IWLMEI as broken

Uwe Kleine-König (1):
      i2c: imx: If pm_runtime_get_sync() returned 1 device access is possible

Vadim Fedorenko (1):
      bnxt_en: fix flags to check for supported fw version

Ville Syrjälä (5):
      drm/i915: Extract intel_edp_fixup_vbt_bpp()
      drm/i915/pps: Split pps_init_delays() into distinct parts
      drm/i915/bios: Split parse_driver_features() into two parts
      drm/i915/bios: Split VBT parsing to global vs. panel specific parts
      drm/i915/bios: Split VBT data into per-panel vs. global parts

Vitaly Kuznetsov (1):
      Drivers: hv: Never allocate anything besides framebuffer from framebuffer memory region

Vladimir Oltean (4):
      net: enetc: move enetc_set_psfp() out of the common enetc_set_features()
      net: enetc: deny offload of tc-based TSN features on VF interfaces
      net/sched: taprio: avoid disabling offload when it was never enabled
      net/sched: taprio: make qdisc_leaf() see the per-netdev-queue pfifo child qdiscs

Wen Gu (1):
      net/smc: Stop the CLC flow if no link to map buffers on

Will Deacon (1):
      vmlinux.lds.h: CFI: Reduce alignment of jump-table to function alignment

William Wu (1):
      usb: dwc3: core: leave default DMA if the controller does not support 64-bit DMA

Yang Wang (1):
      drm/amdgpu: change the alignment size of TMR BO to 1M

Yao Wang1 (1):
      drm/amd/display: Limit user regamma to a valid value

Yi Liu (1):
      iommu/vt-d: Check correct capability for sagaw determination

Yuezhang Mo (1):
      exfat: fix overflow for large capacity partition

huangwenhui (1):
      ALSA: hda/realtek: Add quirk for Huawei WRT-WX9

jerry meng (1):
      USB: serial: option: add Quectel RM520N

zain wang (1):
      arm64: dts: rockchip: Set RK3399-Gru PCLK_EDP to 24 MHz

Íñigo Huguet (4):
      sfc: fix TX channel offset when using legacy interrupts
      sfc: fix null pointer dereference in efx_hard_start_xmit
      sfc/siena: fix TX channel offset when using legacy interrupts
      sfc/siena: fix null pointer dereference in efx_hard_start_xmit

