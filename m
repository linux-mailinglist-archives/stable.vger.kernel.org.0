Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D20354B6FA
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 18:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238633AbiFNQ4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 12:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234955AbiFNQ4n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 12:56:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368C093;
        Tue, 14 Jun 2022 09:56:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A2CFB81A1C;
        Tue, 14 Jun 2022 16:56:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE310C3411B;
        Tue, 14 Jun 2022 16:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655225798;
        bh=P3mnv5OF1OJDMyDui3Phfw5pltGDQ+E2UH92Jznr/+M=;
        h=From:To:Cc:Subject:Date:From;
        b=wJg4aVuGeCS/TY21pcnHi/roy7XnexnlSQP/sjcEVnMAIncgwyG+yvWMH2xCqJG1j
         brUlLRVcWVaMiPlug8ouQ/rnWzqjbhGUQcJwns3NqbSH7wfEO55ks0Cd3t2E2HaPPg
         Tx3FT4tvM3mcfCTHSmpcH6R270+KV9ThmxfuEPFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.47
Date:   Tue, 14 Jun 2022 18:56:34 +0200
Message-Id: <1655225794142214@kroah.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.47 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-ata                               |   11 -
 Documentation/devicetree/bindings/regulator/mt6315-regulator.yaml |    4 
 Makefile                                                          |    2 
 arch/arm/boot/dts/aspeed-ast2600-evb.dts                          |    4 
 arch/arm64/net/bpf_jit_comp.c                                     |    1 
 arch/m68k/Kconfig.machine                                         |    1 
 arch/m68k/include/asm/pgtable_no.h                                |    3 
 arch/m68k/kernel/setup_mm.c                                       |    7 
 arch/m68k/kernel/setup_no.c                                       |    1 
 arch/m68k/kernel/time.c                                           |    9 +
 arch/mips/kernel/mips-cpc.c                                       |    1 
 arch/powerpc/Kconfig                                              |    2 
 arch/powerpc/include/asm/ppc-opcode.h                             |    2 
 arch/powerpc/include/asm/thread_info.h                            |   10 +
 arch/powerpc/kernel/idle.c                                        |    2 
 arch/powerpc/kernel/idle_6xx.S                                    |    2 
 arch/powerpc/kernel/l2cr_6xx.S                                    |    6 
 arch/powerpc/kernel/ptrace/ptrace-fpu.c                           |   20 +-
 arch/powerpc/kernel/ptrace/ptrace.c                               |    3 
 arch/powerpc/kernel/swsusp_32.S                                   |    2 
 arch/powerpc/kernel/swsusp_asm64.S                                |    2 
 arch/powerpc/mm/mmu_context.c                                     |    2 
 arch/powerpc/platforms/powermac/cache.S                           |    4 
 arch/riscv/kernel/efi.c                                           |    2 
 arch/riscv/kernel/machine_kexec.c                                 |    4 
 arch/s390/crypto/aes_s390.c                                       |    4 
 arch/s390/kernel/entry.S                                          |    6 
 arch/s390/mm/gmap.c                                               |   14 +
 arch/um/drivers/chan_kern.c                                       |   10 -
 arch/um/drivers/line.c                                            |   22 +--
 arch/um/drivers/line.h                                            |    4 
 arch/um/drivers/ssl.c                                             |    2 
 arch/um/drivers/stdio_console.c                                   |    2 
 arch/um/include/asm/irq.h                                         |   22 +--
 arch/x86/include/asm/cpufeature.h                                 |    2 
 block/bio.c                                                       |    9 -
 block/blk-mq.c                                                    |    7 
 drivers/ata/libata-transport.c                                    |    2 
 drivers/ata/pata_octeon_cf.c                                      |    3 
 drivers/base/bus.c                                                |    4 
 drivers/base/dd.c                                                 |   10 -
 drivers/block/nbd.c                                               |   37 +++--
 drivers/bus/ti-sysc.c                                             |    4 
 drivers/char/random.c                                             |   15 --
 drivers/char/xillybus/xillyusb.c                                  |    1 
 drivers/clocksource/timer-oxnas-rps.c                             |    2 
 drivers/clocksource/timer-riscv.c                                 |    2 
 drivers/clocksource/timer-sp804.c                                 |   10 -
 drivers/dma/idxd/dma.c                                            |   23 +++
 drivers/dma/xilinx/zynqmp_dma.c                                   |    5 
 drivers/extcon/extcon-axp288.c                                    |    4 
 drivers/extcon/extcon-ptn5150.c                                   |   11 +
 drivers/extcon/extcon.c                                           |   33 ++--
 drivers/firmware/dmi-sysfs.c                                      |    2 
 drivers/firmware/stratix10-svc.c                                  |   12 -
 drivers/gpio/gpio-pca953x.c                                       |   19 +-
 drivers/gpu/drm/amd/amdgpu/nv.c                                   |    1 
 drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c             |    9 -
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c                    |    2 
 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c                |    1 
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c                    |    2 
 drivers/gpu/drm/ast/ast_mode.c                                    |    5 
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c                |   42 +++++
 drivers/gpu/drm/bridge/ti-sn65dsi83.c                             |   34 +++-
 drivers/gpu/drm/drm_atomic_helper.c                               |   16 +-
 drivers/gpu/drm/imx/ipuv3-crtc.c                                  |    2 
 drivers/gpu/drm/radeon/radeon_connectors.c                        |    4 
 drivers/hwtracing/coresight/coresight-cpu-debug.c                 |    7 
 drivers/i2c/busses/i2c-cadence.c                                  |   12 +
 drivers/iio/adc/ad7124.c                                          |    1 
 drivers/iio/adc/sc27xx_adc.c                                      |   20 +-
 drivers/iio/adc/stmpe-adc.c                                       |    8 -
 drivers/iio/common/st_sensors/st_sensors_core.c                   |   24 ++-
 drivers/iio/dummy/iio_simple_dummy.c                              |   20 +-
 drivers/iio/proximity/vl53l0x-i2c.c                               |    7 
 drivers/input/mouse/bcm5974.c                                     |    7 
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c                       |    2 
 drivers/iommu/arm/arm-smmu/arm-smmu.c                             |    5 
 drivers/md/md.c                                                   |   15 +-
 drivers/md/raid0.c                                                |   31 ++--
 drivers/misc/cardreader/rtsx_usb.c                                |    1 
 drivers/misc/fastrpc.c                                            |    9 -
 drivers/misc/lkdtm/bugs.c                                         |   10 +
 drivers/misc/lkdtm/lkdtm.h                                        |    8 -
 drivers/misc/lkdtm/usercopy.c                                     |   17 +-
 drivers/misc/pvpanic/pvpanic-mmio.c                               |    2 
 drivers/misc/pvpanic/pvpanic.c                                    |   10 +
 drivers/mmc/core/block.c                                          |    3 
 drivers/mtd/ubi/fastmap-wl.c                                      |   69 ++++++---
 drivers/mtd/ubi/fastmap.c                                         |   11 -
 drivers/mtd/ubi/ubi.h                                             |    4 
 drivers/mtd/ubi/vmt.c                                             |    1 
 drivers/mtd/ubi/wl.c                                              |   19 +-
 drivers/net/dsa/lantiq_gswip.c                                    |    4 
 drivers/net/dsa/mv88e6xxx/chip.c                                  |    1 
 drivers/net/dsa/mv88e6xxx/serdes.c                                |   27 +--
 drivers/net/ethernet/altera/altera_tse_main.c                     |    6 
 drivers/net/ethernet/intel/i40e/i40e_txrx.c                       |   11 -
 drivers/net/ethernet/intel/i40e/i40e_txrx.h                       |    1 
 drivers/net/ethernet/intel/i40e/i40e_xsk.c                        |    4 
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c                    |    8 -
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c               |    2 
 drivers/net/ethernet/mediatek/mtk_eth_soc.c                       |    3 
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c                   |    2 
 drivers/net/ethernet/mellanox/mlx5/core/dev.c                     |   72 ++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c          |    7 
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h                   |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c                |   19 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c                 |    5 
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                   |   38 +++++
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c                 |   37 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/lag.c                     |   12 -
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h               |    1 
 drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c          |    9 -
 drivers/net/ethernet/netronome/nfp/flower/conntrack.c             |   32 ++--
 drivers/net/ethernet/netronome/nfp/flower/match.c                 |   16 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c              |    4 
 drivers/net/ethernet/sfc/efx_channels.c                           |    6 
 drivers/net/ethernet/sfc/net_driver.h                             |    2 
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c                 |    4 
 drivers/net/ethernet/ti/am65-cpsw-nuss.c                          |    3 
 drivers/net/phy/dp83867.c                                         |   29 ++++
 drivers/net/phy/mdio_bus.c                                        |    1 
 drivers/nfc/st21nfca/se.c                                         |   53 ++++---
 drivers/pci/controller/dwc/pcie-qcom.c                            |    6 
 drivers/pcmcia/Kconfig                                            |    2 
 drivers/phy/qualcomm/phy-qcom-qmp.c                               |    2 
 drivers/power/supply/axp288_charger.c                             |   17 +-
 drivers/power/supply/axp288_fuel_gauge.c                          |    1 
 drivers/power/supply/charger-manager.c                            |    7 
 drivers/power/supply/max8997_charger.c                            |    8 -
 drivers/pwm/pwm-lp3943.c                                          |    1 
 drivers/pwm/pwm-raspberrypi-poe.c                                 |    2 
 drivers/remoteproc/imx_rproc.c                                    |    3 
 drivers/rpmsg/qcom_smd.c                                          |    4 
 drivers/rpmsg/virtio_rpmsg_bus.c                                  |    9 -
 drivers/rtc/rtc-ftrtc010.c                                        |   38 +++--
 drivers/rtc/rtc-mt6397.c                                          |    2 
 drivers/scsi/myrb.c                                               |   11 +
 drivers/scsi/sd.c                                                 |    1 
 drivers/soc/rockchip/grf.c                                        |    2 
 drivers/soundwire/intel.c                                         |    3 
 drivers/soundwire/qcom.c                                          |    2 
 drivers/staging/fieldbus/anybuss/host.c                           |    2 
 drivers/staging/greybus/audio_codec.c                             |    4 
 drivers/staging/r8188eu/core/rtw_xmit.c                           |   13 +
 drivers/staging/r8188eu/include/rtw_xmit.h                        |    2 
 drivers/staging/rtl8192e/rtllib_softmac.c                         |    2 
 drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c            |    2 
 drivers/staging/rtl8712/os_intfs.c                                |    1 
 drivers/staging/rtl8712/usb_intf.c                                |   12 -
 drivers/staging/rtl8712/usb_ops.c                                 |   27 ++-
 drivers/staging/rtl8723bs/core/rtw_mlme.c                         |   12 +
 drivers/thunderbolt/tb.c                                          |   19 ++
 drivers/thunderbolt/test.c                                        |   16 +-
 drivers/thunderbolt/tunnel.c                                      |   11 -
 drivers/thunderbolt/tunnel.h                                      |    4 
 drivers/tty/goldfish.c                                            |    2 
 drivers/tty/n_gsm.c                                               |   36 +++--
 drivers/tty/n_tty.c                                               |   38 +++++
 drivers/tty/serial/8250/8250_aspeed_vuart.c                       |    2 
 drivers/tty/serial/8250/8250_fintek.c                             |    8 -
 drivers/tty/serial/cpm_uart/cpm_uart_core.c                       |    2 
 drivers/tty/serial/digicolor-usart.c                              |    2 
 drivers/tty/serial/fsl_lpuart.c                                   |   24 ---
 drivers/tty/serial/icom.c                                         |    2 
 drivers/tty/serial/meson_uart.c                                   |   13 +
 drivers/tty/serial/msm_serial.c                                   |    5 
 drivers/tty/serial/owl-uart.c                                     |    1 
 drivers/tty/serial/rda-uart.c                                     |    2 
 drivers/tty/serial/sa1100.c                                       |    4 
 drivers/tty/serial/serial_txx9.c                                  |    2 
 drivers/tty/serial/sh-sci.c                                       |    6 
 drivers/tty/serial/sifive.c                                       |    8 -
 drivers/tty/serial/st-asc.c                                       |    4 
 drivers/tty/serial/stm32-usart.c                                  |   15 +-
 drivers/tty/synclink_gt.c                                         |    2 
 drivers/tty/sysrq.c                                               |   13 +
 drivers/usb/core/hcd-pci.c                                        |    4 
 drivers/usb/dwc2/gadget.c                                         |    1 
 drivers/usb/dwc3/drd.c                                            |    9 -
 drivers/usb/dwc3/dwc3-pci.c                                       |    2 
 drivers/usb/dwc3/gadget.c                                         |   20 ++
 drivers/usb/host/isp116x-hcd.c                                    |    6 
 drivers/usb/host/oxu210hp-hcd.c                                   |    2 
 drivers/usb/musb/omap2430.c                                       |    1 
 drivers/usb/phy/phy-omap-otg.c                                    |    4 
 drivers/usb/storage/karma.c                                       |   15 +-
 drivers/usb/typec/mux.c                                           |   14 +
 drivers/usb/typec/tcpm/fusb302.c                                  |    4 
 drivers/usb/usbip/stub_dev.c                                      |    2 
 drivers/usb/usbip/stub_rx.c                                       |    2 
 drivers/vdpa/ifcvf/ifcvf_main.c                                   |    3 
 drivers/vdpa/vdpa.c                                               |   13 +
 drivers/vdpa/vdpa_user/vduse_dev.c                                |    7 
 drivers/vhost/vringh.c                                            |   10 +
 drivers/video/fbdev/hyperv_fb.c                                   |   19 --
 drivers/video/fbdev/pxa3xx-gcu.c                                  |   12 -
 drivers/virtio/virtio_pci_modern_dev.c                            |    1 
 drivers/watchdog/rti_wdt.c                                        |    2 
 drivers/watchdog/ts4800_wdt.c                                     |    5 
 drivers/watchdog/wdat_wdt.c                                       |    1 
 drivers/xen/xlate_mmu.c                                           |    1 
 fs/afs/dir.c                                                      |    5 
 fs/ceph/mds_client.c                                              |   33 +++-
 fs/ceph/xattr.c                                                   |   10 +
 fs/cifs/cifsfs.c                                                  |    2 
 fs/cifs/cifsfs.h                                                  |    2 
 fs/cifs/cifsglob.h                                                |    4 
 fs/cifs/misc.c                                                    |   27 ++-
 fs/cifs/smb2ops.c                                                 |    7 
 fs/cifs/smb2pdu.c                                                 |    3 
 fs/f2fs/checkpoint.c                                              |    4 
 fs/f2fs/file.c                                                    |    1 
 fs/fs-writeback.c                                                 |   37 +++--
 fs/inode.c                                                        |    2 
 fs/jffs2/fs.c                                                     |    1 
 fs/kernfs/dir.c                                                   |   31 ++--
 fs/ksmbd/smbacl.c                                                 |    1 
 fs/nfs/nfs4proc.c                                                 |    4 
 fs/zonefs/super.c                                                 |   11 -
 include/linux/export.h                                            |    7 
 include/linux/extcon.h                                            |    2 
 include/linux/iio/common/st_sensors.h                             |    3 
 include/linux/jump_label.h                                        |    4 
 include/linux/mlx5/mlx5_ifc.h                                     |    5 
 include/linux/nodemask.h                                          |   38 ++---
 include/linux/random.h                                            |    2 
 include/net/flow_offload.h                                        |    1 
 include/net/netfilter/nf_tables.h                                 |    1 
 include/net/netfilter/nf_tables_offload.h                         |    2 
 include/net/sch_generic.h                                         |   42 +----
 include/net/tcp.h                                                 |   19 ++
 include/net/xdp_sock_drv.h                                        |    5 
 include/net/xsk_buff_pool.h                                       |    2 
 include/trace/events/tcp.h                                        |    2 
 kernel/bpf/core.c                                                 |   14 -
 kernel/trace/trace.c                                              |   13 +
 kernel/trace/trace_syscalls.c                                     |   35 +---
 lib/Makefile                                                      |    2 
 lib/iov_iter.c                                                    |   20 --
 lib/nodemask.c                                                    |    4 
 net/core/filter.c                                                 |    2 
 net/core/flow_offload.c                                           |    6 
 net/ipv4/inet_hashtables.c                                        |   10 -
 net/ipv4/ip_gre.c                                                 |   11 -
 net/ipv4/tcp.c                                                    |    8 -
 net/ipv4/tcp_bbr.c                                                |   20 +-
 net/ipv4/tcp_bic.c                                                |   14 -
 net/ipv4/tcp_cdg.c                                                |   30 ++--
 net/ipv4/tcp_cong.c                                               |   18 +-
 net/ipv4/tcp_cubic.c                                              |   22 +--
 net/ipv4/tcp_dctcp.c                                              |   11 -
 net/ipv4/tcp_highspeed.c                                          |   18 +-
 net/ipv4/tcp_htcp.c                                               |   10 -
 net/ipv4/tcp_hybla.c                                              |   18 +-
 net/ipv4/tcp_illinois.c                                           |   12 -
 net/ipv4/tcp_input.c                                              |   41 +++--
 net/ipv4/tcp_ipv4.c                                               |    2 
 net/ipv4/tcp_lp.c                                                 |    6 
 net/ipv4/tcp_metrics.c                                            |   12 -
 net/ipv4/tcp_nv.c                                                 |   24 +--
 net/ipv4/tcp_output.c                                             |   34 ++--
 net/ipv4/tcp_rate.c                                               |    2 
 net/ipv4/tcp_scalable.c                                           |    4 
 net/ipv4/tcp_vegas.c                                              |   21 +-
 net/ipv4/tcp_veno.c                                               |   24 +--
 net/ipv4/tcp_westwood.c                                           |    3 
 net/ipv4/tcp_yeah.c                                               |   30 ++--
 net/ipv4/xfrm4_protocol.c                                         |    1 
 net/ipv6/seg6_hmac.c                                              |    1 
 net/ipv6/tcp_ipv6.c                                               |    2 
 net/key/af_key.c                                                  |   10 -
 net/netfilter/nf_tables_api.c                                     |   54 +++----
 net/netfilter/nf_tables_offload.c                                 |   23 +++
 net/netfilter/nft_nat.c                                           |    3 
 net/openvswitch/actions.c                                         |    6 
 net/openvswitch/conntrack.c                                       |    4 
 net/sched/act_police.c                                            |   16 ++
 net/smc/smc_cdc.c                                                 |    2 
 net/sunrpc/xdr.c                                                  |    6 
 net/sunrpc/xprtrdma/rpc_rdma.c                                    |    5 
 net/sunrpc/xprtrdma/svc_rdma_rw.c                                 |    4 
 net/tipc/bearer.c                                                 |    3 
 net/unix/af_unix.c                                                |    2 
 net/xdp/xsk.c                                                     |   29 ++--
 net/xdp/xsk_buff_pool.c                                           |   15 ++
 net/xdp/xsk_queue.h                                               |   14 -
 scripts/gdb/linux/config.py                                       |    6 
 scripts/mod/modpost.c                                             |    5 
 security/keys/trusted-keys/trusted_tpm2.c                         |    4 
 sound/pci/hda/patch_conexant.c                                    |    7 
 sound/pci/hda/patch_realtek.c                                     |    2 
 sound/soc/fsl/fsl_sai.h                                           |    4 
 sound/usb/pcm.c                                                   |    5 
 sound/usb/quirks-table.h                                          |    7 
 tools/perf/builtin-c2c.c                                          |    4 
 tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c      |   12 -
 tools/testing/selftests/net/forwarding/tc_police.sh               |   52 +++++++
 tools/testing/selftests/netfilter/nft_nat.sh                      |   43 +++++
 300 files changed, 1924 insertions(+), 1119 deletions(-)

Adrian Hunter (1):
      mmc: block: Fix CQE recovery reset success

Alex Deucher (1):
      drm/amdgpu: update VCN codec support for Yellow Carp

Alexander Gordeev (1):
      s390/mcck: isolate SIE instruction when setting CIF_MCCK_GUEST flag

Alexander Lobakin (1):
      modpost: fix removing numeric suffixes

Alexandru Tachici (1):
      iio: adc: ad7124: Remove shift from scan_type

Alexey Kardashevskiy (1):
      powerpc/mm: Switch obsolete dssall to .long

Andre Przywara (1):
      clocksource/drivers/sp804: Avoid error on multiple instances

Andrii Nakryiko (1):
      selftests/bpf: fix selftest after random: Urandom_read tracepoint removal

Andy Shevchenko (1):
      pvpanic: Fix typos in the comments

Arnaud Pouliquen (1):
      rpmsg: virtio: Fix the unregistration of the device rpmsg_ctrl

Baokun Li (1):
      jffs2: fix memory leak in jffs2_do_fill_super

Bjorn Andersson (1):
      usb: typec: mux: Check dev_set_name() return value

Brian Norris (2):
      drm/bridge: analogix_dp: Support PSR-exit to disable transition
      drm/atomic: Force bridge self-refresh-exit on CRTC switch

Cameron Berkenpas (1):
      ALSA: hda/realtek: Fix for quirk to enable speaker output on the Lenovo Yoga DuetITL 2021

Changbin Du (1):
      sysrq: do not omit current cpu when showing backtrace of all active CPUs

Changcheng Liu (1):
      net/mlx5: correct ECE offset in query qp output

Chao Yu (1):
      f2fs: fix to tag gcing flag on page during file defragment

Christian Borntraeger (1):
      s390/gmap: voluntarily schedule during key setting

Christoph Hellwig (1):
      block: take destination bvec offsets into account in bio_copy_data_iter

Christophe JAILLET (4):
      staging: fieldbus: Fix the error handling path in anybuss_host_common_probe()
      virtio: pci: Fix an error handling path in vp_modern_probe()
      drm/bridge: sn65dsi83: Fix an error handling path in sn65dsi83_probe()
      stmmac: intel: Fix an error handling path in intel_eth_pci_probe()

Christophe Leroy (1):
      lkdtm/bugs: Don't expect thread termination without CONFIG_UBSAN_TRAP

Chuck Lever (2):
      SUNRPC: Trap RDMA segment overflows
      SUNRPC: Fix the calculation of xdr->end in xdr_get_next_encode_buffer()

Cixi Geng (2):
      iio: adc: sc27xx: fix read big scale voltage not right
      iio: adc: sc27xx: Fine tune the scale calibration values

Damien Le Moal (2):
      scsi: sd: Fix potential NULL pointer dereference
      zonefs: fix handling of explicit_open option on mount

Dan Carpenter (3):
      net: ethernet: mtk_eth_soc: out of bounds read in mtk_hwlro_get_fdir_entry()
      octeontx2-af: fix error code in is_valid_offset()
      extcon: Fix extcon_get_extcon_dev() error handling

Daniel Gibson (1):
      tty: n_tty: Restore EOF push handling behavior

Dave Jiang (2):
      dmaengine: idxd: set DMA_INTERRUPT cap bit
      dmaengine: idxd: add missing callback function to support DMA_INTERRUPT

David Galiffi (1):
      drm/amd/display: Check if modulo is 0 before dividing.

David Howells (2):
      afs: Fix infinite loop found by xfstest generic/676
      iov_iter: Fix iter_xarray_get_pages{,_alloc}()

David Safford (1):
      KEYS: trusted: tpm2: Fix migratable logic

Davide Caratti (1):
      net/sched: act_police: more accurate MTU policing

Dongliang Mu (1):
      f2fs: remove WARN_ON in f2fs_is_valid_blkaddr

Duoming Zhou (6):
      drivers: staging: rtl8723bs: Fix deadlock in rtw_surveydone_event_callback()
      drivers: staging: rtl8192bs: Fix deadlock in rtw_joinbss_event_prehandle()
      drivers: staging: rtl8192u: Fix deadlock in ieee80211_beacons_stop()
      drivers: staging: rtl8192e: Fix deadlock in rtllib_beacons_stop()
      drivers: tty: serial: Fix deadlock in sa1100_set_termios()
      drivers: usb: host: Fix deadlock in oxu_bus_suspend()

Eli Cohen (1):
      vdpa: Fix error logic in vdpa_nl_cmd_dev_get_doit

Eric Dumazet (4):
      tcp: add accessors to read/set tp->snd_cwnd
      tcp: tcp_rtx_synack() can be called from process context
      bpf, arm64: Clear prog->jited_len along prog->jited
      tcp: fix tcp_mtup_probe_success vs wrong snd_cwnd

Etienne van der Linde (1):
      nfp: flower: restructure flow-key for gre+vlan combination

Evan Green (1):
      USB: hcd-pci: Fully suspend across freeze/thaw cycle

Fabien Parent (1):
      regulator: mt6315-regulator: fix invalid allowed mode

Feras Daoud (1):
      net/mlx5: Rearm the FW tracer after each tracer event

Florian Westphal (1):
      netfilter: nat: really support inet nat without l3 address

Gal Pressman (1):
      net/mlx4_en: Fix wrong return value on ioctl EEPROM query failure

Gong Yuanjun (2):
      mips: cpc: Fix refcount leak in mips_cpc_default_phys_base
      drm/radeon: fix a possible null pointer dereference

Greg Kroah-Hartman (2):
      export: fix string handling of namespace in EXPORT_SYMBOL_NS
      Linux 5.15.47

Greg Ungerer (3):
      m68knommu: set ZERO_PAGE() to the allocated zeroed page
      m68knommu: fix undefined reference to `_init_sp'
      m68knommu: fix undefined reference to `mach_get_rtc_pll'

Guangguan Wang (1):
      net/smc: fixes for converting from "struct smc_cdc_tx_pend **" to "struct smc_wr_tx_pend_priv *"

Guilherme G. Piccoli (2):
      misc/pvpanic: Convert regular spinlock into trylock on panic path
      coresight: cpu-debug: Replace mutex with mutex_trylock on panic notifier

Guoju Fang (1):
      net: sched: add barrier to fix packet stuck problem for lockless qdisc

Guoqing Jiang (1):
      md: protect md_unregister_thread from reentrancy

Haibo Chen (1):
      gpio: pca953x: use the correct register address to do regcache sync

Hangyu Hua (4):
      usb: usbip: fix a refcount leak in stub_probe()
      rpmsg: virtio: Fix possible double free in rpmsg_probe()
      rpmsg: virtio: Fix possible double free in rpmsg_virtio_add_ctrl_dev()
      char: xillybus: fix a refcount leak in cleanup_dev()

Hannes Reinecke (1):
      scsi: myrb: Fix up null pointer access on myrb_cleanup()

Hans de Goede (1):
      power: supply: axp288_fuel_gauge: Drop BIOS version check from "T3 MRD" DMI quirk

Hao Luo (1):
      kernfs: Separate kernfs_pr_cont_buf and rename_lock.

Heinrich Schuchardt (1):
      riscv: read-only pages should not be writable

Hoang Le (1):
      tipc: check attribute length for bearer name

Howard Chiu (1):
      ARM: dts: aspeed: ast2600-evb: Enable RX delay for MAC0/MAC1

Huang Guobin (1):
      tty: Fix a possible resource leak in icom_probe

Ilpo Järvinen (8):
      serial: 8250_fintek: Check SER_RS485_RTS_* only with RS485
      serial: digicolor-usart: Don't allow CS5-6
      serial: rda-uart: Don't allow CS5-6
      serial: txx9: Don't allow CS5-6
      serial: sh-sci: Don't allow CS5-6
      serial: sifive: Sanitize CSIZE and c_iflag
      serial: st-asc: Sanitize CSIZE and correct PARENB for CS7
      serial: stm32-usart: Correct CSIZE, bits, and parity

Ilya Maximets (1):
      net: openvswitch: fix misuse of the cached connection on tuple changes

Jakob Koschel (1):
      staging: greybus: codecs: fix type confusion of list iterator variable

Jann Horn (1):
      s390/crypto: fix scatterwalk_unmap() callers in AES-GCM

Jason A. Donenfeld (3):
      random: avoid checking crng_ready() twice in random_init()
      random: mark bootloader randomness code as __init
      random: account for arch randomness in bits

Jason Wang (1):
      vdpa: ifcvf: set pci driver data in probe

Jchao Sun (1):
      writeback: Fix inode->i_io_list not be protected by inode->i_lock error

Jeff Xie (1):
      tracing: Make tp_printk work on syscall tracepoints

Jens Axboe (1):
      block: make bioset_exit() fully resilient against being called twice

Jeremy Soller (1):
      ALSA: hda/realtek: Add quirk for HP Dev One

Jiasheng Jiang (2):
      lkdtm/bugs: Check for the NULL pointer after calling kmalloc
      staging: r8188eu: add check for kzalloc

Johan Hovold (2):
      phy: qcom-qmp: fix pipe-clock imbalance on power-on failure
      PCI: qcom: Fix pipe clock imbalance

Johannes Berg (1):
      um: line: Use separate IRQs per line

John Ogness (2):
      serial: meson: acquire port->lock in startup()
      serial: msm_serial: disable interrupts in __msm_console_write()

Jun Miao (1):
      tracing: Fix sleeping function called from invalid context on RT kernel

Kees Cook (2):
      lkdtm/usercopy: Expand size of "out of frame" object
      nodemask: Fix return values to be unsigned

Kinglong Mee (1):
      xprtrdma: treat all calls not a bcall when bc_serv is NULL

Krzysztof Kozlowski (3):
      rpmsg: qcom_smd: Fix irq_of_parse_and_map() return value
      rpmsg: qcom_smd: Fix returning 0 if irq_of_parse_and_map() fails
      clocksource/drivers/oxnas-rps: Fix irq_of_parse_and_map() return value

Kuan-Ying Lee (1):
      scripts/gdb: change kernel config dumping method

Kuniyuki Iwashima (1):
      af_unix: Fix a data-race in unix_dgram_peer_wake_me().

KuoHsiang Chou (1):
      drm/ast: Create threshold values for AST2600

Lad Prabhakar (1):
      rtc: ftrtc010: Use platform_get_irq() to get the interrupt

Leo Yan (1):
      perf c2c: Fix sorting in percent_rmt_hitm_cmp()

Leon Romanovsky (1):
      net/mlx5: Don't use already freed action pointer

Li Jun (1):
      extcon: ptn5150: Add queue work sync before driver release

Liao Chang (1):
      RISC-V: use memcpy for kexec_file mode

Lijo Lazar (1):
      drm/amd/pm: Fix missing thermal throttler status

Lin Ma (1):
      USB: storage: karma: fix rio_karma_init return

Linus Torvalds (2):
      drm: imx: fix compiler warning with gcc-12
      iov_iter: fix build issue due to possible type mis-match

Liu Xinpeng (1):
      watchdog: wdat_wdt: Stop watchdog when rebooting the system

Lucas Tanure (1):
      i2c: cadence: Increase timeout per message if necessary

Maciej Fijalkowski (2):
      xsk: Fix handling of invalid descriptors in XSK TX batching API
      xsk: Fix possible crash when multiple sockets are created

Maciej W. Rozycki (1):
      serial: sifive: Report actual baud base rather than fixed 115200

Magnus Karlsson (1):
      i40e: xsk: Move tmp desc array from driver to pool

Maor Dickman (1):
      net/mlx5e: TC NIC mode, fix tc chains miss table

Marek Behún (1):
      net: dsa: mv88e6xxx: use BMSR_ANEGCOMPLETE bit for filling an_complete

Marek Szyprowski (1):
      usb: dwc2: gadget: don't reset gadget's driver->bus

Marek Vasut (1):
      drm/bridge: ti-sn65dsi83: Handle dsi_lanes == 0 as invalid

Mark Bloch (2):
      net/mlx5: Lag, filter non compatible devices
      net/mlx5: fs, fail conflicting actions

Mark-PK Tsai (1):
      tracing: Avoid adding tracer option before update_tracer_options

Martin Faltesek (3):
      nfc: st21nfca: fix incorrect validating logic in EVT_TRANSACTION
      nfc: st21nfca: fix memory leaks in EVT_TRANSACTION handling
      nfc: st21nfca: fix incorrect sizing calculations in EVT_TRANSACTION

Martin Habets (1):
      sfc: fix considering that all channels have TX queues

Masahiro Yamada (5):
      xen: unexport __init-annotated xen_xlate_map_ballooned_pages()
      net: mdio: unexport __init-annotated mdio_bus_init()
      net: xfrm: unexport __init-annotated xfrm4_protocol_init()
      net: ipv6: unexport __init-annotated seg6_hmac_init()
      modpost: fix undefined behavior of is_arm_mapping_symbol()

Masami Hiramatsu (1):
      bootconfig: Make the bootconfig.o as a normal object file

Mathias Nyman (1):
      Input: bcm5974 - set missing URB_NO_TRANSFER_DMA_MAP urb flag

Maxim Mikityanskiy (1):
      net/mlx5e: Update netdev features after changing XDP state

Menglong Dong (1):
      bpf: Fix probe read error in ___bpf_prog_run()

Miaoqian Lin (15):
      tty: serial: owl: Fix missing clk_disable_unprepare() in owl_uart_probe
      serial: 8250_aspeed_vuart: Fix potential NULL dereference in aspeed_vuart_probe
      usb: musb: Fix missing of_node_put() in omap2430_probe
      iio: adc: stmpe-adc: Fix wait_for_completion_timeout return value check
      iio: proximity: vl53l0x: Fix return value check of wait_for_completion_timeout
      soc: rockchip: Fix refcount leak in rockchip_grf_init
      rtc: ftrtc010: Fix error handling in ftrtc010_rtc_probe
      firmware: dmi-sysfs: Fix memory leak in dmi_sysfs_register_handle
      watchdog: rti-wdt: Fix pm_runtime_get_sync() error checking
      watchdog: ts4800_wdt: Fix refcount leak in ts4800_wdt_probe
      net: ethernet: ti: am65-cpsw-nuss: Fix some refcount leaks
      net: dsa: mv88e6xxx: Fix refcount leak in mv88e6xxx_mdios_register
      ata: pata_octeon_cf: Fix refcount leak in octeon_cf_probe
      net: dsa: lantiq_gswip: Fix refcount leak in gswip_gphy_fw_list
      net: altera: Fix refcount leak in altera_tse_mdio_create

Michael Ellerman (3):
      powerpc/kasan: Force thread size increase with KASAN
      powerpc: Don't select HAVE_IRQ_EXIT_ON_IRQ_STACK
      powerpc/32: Fix overread/overwrite of thread_struct via ptrace

Michal Kubecek (1):
      Revert "net: af_key: add check for pfkey_broadcast in function pfkey_process"

Mika Westerberg (1):
      thunderbolt: Use different lane for second DisplayPort tunnel

Ming Lei (1):
      blk-mq: don't touch ->tagset in blk_mq_get_sq_hctx

Miquel Raynal (1):
      iio: st_sensors: Add a local lock for protecting odr

Muchun Song (1):
      tcp: use alloc_large_system_hash() to allocate table_perturb

Niels Dossche (1):
      usb: usbip: add missing device lock on tweak configuration cmd

Olivier Matz (2):
      ixgbe: fix bcast packets Rx on VF after promisc removal
      ixgbe: fix unexpected VLAN Rx in promisc mode on VF

Pablo Neira Ayuso (6):
      netfilter: nf_tables: use kfree_rcu(ptr, rcu) to release hooks in clean_net path
      netfilter: nf_tables: delete flowtable hooks via transaction list
      netfilter: nf_tables: always initialize flowtable hook list in transaction
      netfilter: nf_tables: release new hooks on unsupported flowtable flags
      netfilter: nf_tables: memleak flow rule from commit path
      netfilter: nf_tables: bail out early if hardware offload is not supported

Pascal Hambourg (1):
      md/raid0: Ignore RAID0 layout if the second zone has only one device

Paul Blakey (1):
      net/mlx5: CT: Fix header-rewrite re-use for tupels

Paulo Alcantara (1):
      cifs: fix reconnect on smb3 mount types

Peng Fan (1):
      remoteproc: imx_rproc: Ignore create mem entry for resource table

Peter Zijlstra (2):
      x86/cpu: Elide KCSAN for cpu_has() and friends
      jump_label,noinstr: Avoid instrumentation for JUMP_LABEL=n builds

Pierre-Louis Bossart (1):
      soundwire: intel: prevent pm_runtime resume prior to system suspend

Radhey Shyam Pandey (1):
      dmaengine: zynqmp_dma: In struct zynqmp_dma_chan fix desc_size data type

Randy Dunlap (1):
      pcmcia: db1xxx_ss: restrict to MIPS_DB1XXX boards

Saeed Mahameed (1):
      net/mlx5: Fix mlx5_get_next_dev() peer device matching

Samuel Holland (1):
      clocksource/drivers/riscv: Events are stopped during CPU suspend

Saravana Kannan (1):
      driver core: Fix wait_for_device_probe() & deferred_probe_timeout interaction

Saurabh Sengar (1):
      video: fbdev: hyperv_fb: Allow resolutions with size > 64 MB for Gen1

Schspa Shi (1):
      driver: base: fix UAF when driver_attach failed

Sergey Shtylyov (1):
      ata: libata-transport: fix {dma|pio|xfer}_mode sysfs files

Shengjiu Wang (1):
      ASoC: fsl_sai: Fix FSL_SAI_xDR/xFR definition

Sherry Sun (1):
      tty: serial: fsl_lpuart: fix potential bug when using both of_alias_get_id and ida_simple_get

Shuah Khan (1):
      misc: rtsx: set NULL intfdata when probe fails

Shyam Prasad N (1):
      cifs: return errors during session setup during reconnects

Song Liu (1):
      selftests/bpf: fix stacktrace_build_id with missing kprobe/urandom_read

Srinivas Kandagatla (1):
      soundwire: qcom: adjust autoenumeration timeout

Steve French (1):
      cifs: version operations for smb20 unneeded when legacy support disabled

Takashi Iwai (2):
      ALSA: usb-audio: Skip generic sync EP parse for secondary EP
      ALSA: usb-audio: Set up (implicit) sync for Saffire 6

Tan Tee Min (1):
      net: phy: dp83867: retrigger SGMII AN when link change

Tony Lindgren (3):
      tty: n_gsm: Don't ignore write return value in gsmld_output()
      tty: n_gsm: Fix packet data hex dump output
      bus: ti-sysc: Fix warnings for unbind for serial

Trond Myklebust (1):
      NFSv4: Don't hold the layoutget locks across multiple RPC calls

Uwe Kleine-König (2):
      pwm: lp3943: Fix duty calculation in case period was clamped
      pwm: raspberrypi-poe: Fix endianness in firmware struct

Venky Shankar (1):
      ceph: allow ceph.dir.rctime xattr to be updatable

Vincent Ray (1):
      net: sched: fixed barrier to prevent skbuff sticking in qdisc backlog

Wang Cheng (2):
      staging: rtl8712: fix uninit-value in usb_read8() and friends
      staging: rtl8712: fix uninit-value in r871xu_drv_init()

Wang Weiyang (1):
      tty: goldfish: Use tty_port_destroy() to destroy port

Wesley Cheng (1):
      usb: dwc3: gadget: Replace list_for_each_entry_safe() if using giveback

Willem de Bruijn (1):
      ip_gre: test csum_start instead of transport header

Xiaoke Wang (2):
      iio: dummy: iio_simple_dummy: check the return value of kstrdup()
      staging: rtl8712: fix a potential memory leak in r871xu_drv_init()

Xiaomeng Tong (2):
      misc: fastrpc: fix an incorrect NULL check on list iterator
      firmware: stratix10-svc: fix a missing check on list iterator

Xie Yongji (2):
      vringh: Fix loop descriptors check in the indirect cases
      vduse: Fix NULL pointer dereference on sysfs access

Xin Xiong (1):
      ksmbd: fix reference count leak in smb_check_perm_dacl()

Xiubo Li (1):
      ceph: flush the mdlog for filesystem sync

Yang Yingliang (4):
      rtc: mt6397: check return value after calling platform_get_resource()
      iommu/arm-smmu: fix possible null-ptr-deref in arm_smmu_device_probe()
      iommu/arm-smmu-v3: check return value after calling platform_get_resource()
      video: fbdev: pxa3xx-gcu: release the resources correctly in pxa3xx_gcu_probe/remove()

Yu Kuai (3):
      nbd: call genl_unregister_family() first in nbd_cleanup()
      nbd: fix race between nbd_alloc_config() and module removal
      nbd: fix io hung while disconnecting device

Yu Xiao (1):
      nfp: only report pause frame configuration for physical device

YueHaibing (1):
      serial: cpm_uart: Fix build error without CONFIG_SERIAL_CPM_CONSOLE

Yury Norov (1):
      drm/amd/pm: use bitmap_{from,to}_arr32 where appropriate

Zhang Wensheng (1):
      driver core: fix deadlock in __device_attach

Zhen Ni (1):
      USB: host: isp116x: check return value after calling platform_get_resource()

Zheng Yongjun (1):
      usb: dwc3: pci: Fix pm_runtime_get_sync() error checking

Zheyu Ma (1):
      tty: synclink_gt: Fix null-pointer-dereference in slgt_clean()

Zhihao Cheng (2):
      ubi: fastmap: Fix high cpu usage of ubi_bgt by making sure wl_pool not empty
      ubi: ubi_create_volume: Fix use-after-free when volume creation failed

bumwoo lee (1):
      extcon: Modify extcon device to be created after driver data is set

huangwenhui (1):
      ALSA: hda/conexant - Fix loopback issue with CX20632

Íñigo Huguet (1):
      sfc: fix wrong tx channel offset with efx_separate_tx_channels

