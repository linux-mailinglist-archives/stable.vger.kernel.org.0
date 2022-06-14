Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B6254B6F7
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 18:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350611AbiFNQyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 12:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351953AbiFNQyl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 12:54:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8481C10F6;
        Tue, 14 Jun 2022 09:54:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B55561604;
        Tue, 14 Jun 2022 16:54:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6224C3411B;
        Tue, 14 Jun 2022 16:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655225671;
        bh=lqMBRoej/n2uTTiOkvWzBZyWYYsW5OnKXz7jCwJfrUo=;
        h=From:To:Cc:Subject:Date:From;
        b=QgDNbgs2B35+FNcdnAOgsZhJXuUui9NXNUvJpDK1ZRmltWzxYJdZn5slVA9SYd6rE
         Y5kjB63YBrirRAtYk6uhKUHcNh0QgQD0OIW4kWDGG8gvNOdgxdVrWcoX5MrkMTzB3k
         REN7xKlqHrPjcp1jv0fSlXwlXu2F9OttEzqSw9so=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.122
Date:   Tue, 14 Jun 2022 18:54:27 +0200
Message-Id: <16552256679385@kroah.com>
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

I'm announcing the release of the 5.10.122 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-ata                      |   11 +-
 Makefile                                                 |    2 
 arch/arm64/net/bpf_jit_comp.c                            |    1 
 arch/m68k/Kconfig.machine                                |    1 
 arch/m68k/include/asm/pgtable_no.h                       |    3 
 arch/mips/kernel/mips-cpc.c                              |    1 
 arch/powerpc/Kconfig                                     |    1 
 arch/powerpc/include/asm/ppc-opcode.h                    |    2 
 arch/powerpc/include/asm/thread_info.h                   |   10 +-
 arch/powerpc/kernel/idle.c                               |    2 
 arch/powerpc/kernel/idle_6xx.S                           |    2 
 arch/powerpc/kernel/l2cr_6xx.S                           |    6 -
 arch/powerpc/kernel/ptrace/ptrace.c                      |   21 +++-
 arch/powerpc/kernel/swsusp_32.S                          |    2 
 arch/powerpc/kernel/swsusp_asm64.S                       |    2 
 arch/powerpc/mm/mmu_context.c                            |    2 
 arch/powerpc/platforms/powermac/cache.S                  |    4 
 arch/riscv/kernel/efi.c                                  |    2 
 arch/s390/crypto/aes_s390.c                              |    4 
 arch/s390/mm/gmap.c                                      |   14 +++
 arch/x86/include/asm/cpufeature.h                        |    2 
 drivers/ata/libata-transport.c                           |    2 
 drivers/ata/pata_octeon_cf.c                             |    3 
 drivers/base/bus.c                                       |    4 
 drivers/base/dd.c                                        |   10 --
 drivers/block/nbd.c                                      |   37 +++++---
 drivers/bus/ti-sysc.c                                    |    4 
 drivers/clocksource/timer-oxnas-rps.c                    |    2 
 drivers/clocksource/timer-riscv.c                        |    2 
 drivers/clocksource/timer-sp804.c                        |   10 +-
 drivers/dma/idxd/dma.c                                   |   23 +++++
 drivers/dma/xilinx/zynqmp_dma.c                          |    5 -
 drivers/extcon/extcon-ptn5150.c                          |   11 ++
 drivers/extcon/extcon.c                                  |   29 +++---
 drivers/firmware/dmi-sysfs.c                             |    2 
 drivers/firmware/stratix10-svc.c                         |   12 +-
 drivers/gpio/gpio-pca953x.c                              |   19 ++--
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c       |   42 ++++++++-
 drivers/gpu/drm/drm_atomic_helper.c                      |   16 ++-
 drivers/gpu/drm/imx/ipuv3-crtc.c                         |    2 
 drivers/gpu/drm/radeon/radeon_connectors.c               |    4 
 drivers/hwtracing/coresight/coresight-cpu-debug.c        |    7 -
 drivers/i2c/busses/i2c-cadence.c                         |   12 ++
 drivers/iio/adc/ad7124.c                                 |    1 
 drivers/iio/adc/sc27xx_adc.c                             |   20 ++--
 drivers/iio/adc/stmpe-adc.c                              |    8 -
 drivers/iio/common/st_sensors/st_sensors_core.c          |   24 +++--
 drivers/iio/dummy/iio_simple_dummy.c                     |   20 ++--
 drivers/iio/proximity/vl53l0x-i2c.c                      |    7 -
 drivers/input/mouse/bcm5974.c                            |    7 +
 drivers/interconnect/core.c                              |    7 +
 drivers/interconnect/qcom/sc7180.c                       |   21 ----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c              |    2 
 drivers/iommu/arm/arm-smmu/arm-smmu.c                    |    5 -
 drivers/md/md.c                                          |   15 ++-
 drivers/md/raid0.c                                       |   31 +++---
 drivers/misc/cardreader/rtsx_usb.c                       |    1 
 drivers/misc/fastrpc.c                                   |    9 +
 drivers/misc/lkdtm/bugs.c                                |    5 +
 drivers/misc/lkdtm/usercopy.c                            |   17 +++
 drivers/mmc/core/block.c                                 |    3 
 drivers/mtd/ubi/fastmap-wl.c                             |   69 ++++++++++-----
 drivers/mtd/ubi/fastmap.c                                |   11 --
 drivers/mtd/ubi/ubi.h                                    |    4 
 drivers/mtd/ubi/vmt.c                                    |    1 
 drivers/mtd/ubi/wl.c                                     |   19 ++--
 drivers/net/dsa/lantiq_gswip.c                           |    4 
 drivers/net/dsa/mv88e6xxx/chip.c                         |    1 
 drivers/net/ethernet/altera/altera_tse_main.c            |    6 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c           |    8 -
 drivers/net/ethernet/mediatek/mtk_eth_soc.c              |    3 
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c          |    2 
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c |    7 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c        |    5 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c        |   35 ++++++-
 drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c |    9 -
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c     |    4 
 drivers/net/ethernet/sfc/efx_channels.c                  |    6 -
 drivers/net/ethernet/sfc/net_driver.h                    |    2 
 drivers/net/ethernet/ti/am65-cpsw-nuss.c                 |    3 
 drivers/net/phy/dp83867.c                                |   29 ++++++
 drivers/net/phy/mdio_bus.c                               |    1 
 drivers/nfc/st21nfca/se.c                                |   53 ++++++-----
 drivers/pci/controller/dwc/pcie-qcom.c                   |    6 -
 drivers/pcmcia/Kconfig                                   |    2 
 drivers/phy/qualcomm/phy-qcom-qmp.c                      |    2 
 drivers/pwm/pwm-lp3943.c                                 |    1 
 drivers/rpmsg/qcom_smd.c                                 |    4 
 drivers/rtc/rtc-mt6397.c                                 |    2 
 drivers/scsi/myrb.c                                      |   11 +-
 drivers/scsi/sd.c                                        |    1 
 drivers/soc/rockchip/grf.c                               |    2 
 drivers/staging/fieldbus/anybuss/host.c                  |    2 
 drivers/staging/greybus/audio_codec.c                    |    4 
 drivers/staging/rtl8192e/rtllib_softmac.c                |    2 
 drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c   |    2 
 drivers/staging/rtl8712/os_intfs.c                       |    1 
 drivers/staging/rtl8712/usb_intf.c                       |   12 +-
 drivers/staging/rtl8712/usb_ops.c                        |   27 +++--
 drivers/tty/goldfish.c                                   |    2 
 drivers/tty/n_tty.c                                      |   38 ++++++++
 drivers/tty/serial/8250/8250_fintek.c                    |    8 -
 drivers/tty/serial/digicolor-usart.c                     |    2 
 drivers/tty/serial/fsl_lpuart.c                          |   24 -----
 drivers/tty/serial/icom.c                                |    2 
 drivers/tty/serial/meson_uart.c                          |   13 ++
 drivers/tty/serial/msm_serial.c                          |    5 +
 drivers/tty/serial/owl-uart.c                            |    1 
 drivers/tty/serial/rda-uart.c                            |    2 
 drivers/tty/serial/sa1100.c                              |    4 
 drivers/tty/serial/serial_txx9.c                         |    2 
 drivers/tty/serial/sh-sci.c                              |    6 +
 drivers/tty/serial/sifive.c                              |    8 +
 drivers/tty/serial/st-asc.c                              |    4 
 drivers/tty/serial/stm32-usart.c                         |   15 ++-
 drivers/tty/synclink_gt.c                                |    2 
 drivers/tty/sysrq.c                                      |   13 +-
 drivers/usb/core/hcd-pci.c                               |    4 
 drivers/usb/dwc2/gadget.c                                |    1 
 drivers/usb/dwc3/dwc3-pci.c                              |    2 
 drivers/usb/host/isp116x-hcd.c                           |    6 -
 drivers/usb/host/oxu210hp-hcd.c                          |    2 
 drivers/usb/musb/omap2430.c                              |    1 
 drivers/usb/storage/karma.c                              |   15 +--
 drivers/usb/typec/mux.c                                  |   14 ++-
 drivers/usb/usbip/stub_dev.c                             |    2 
 drivers/usb/usbip/stub_rx.c                              |    2 
 drivers/vhost/vringh.c                                   |   10 +-
 drivers/video/fbdev/hyperv_fb.c                          |   19 ----
 drivers/video/fbdev/pxa3xx-gcu.c                         |   12 +-
 drivers/watchdog/rti_wdt.c                               |    2 
 drivers/watchdog/ts4800_wdt.c                            |    5 -
 drivers/watchdog/wdat_wdt.c                              |    1 
 drivers/xen/xlate_mmu.c                                  |    1 
 fs/afs/dir.c                                             |    5 -
 fs/ceph/xattr.c                                          |   10 +-
 fs/cifs/cifsfs.c                                         |    2 
 fs/cifs/cifsfs.h                                         |    2 
 fs/cifs/cifsglob.h                                       |    4 
 fs/cifs/misc.c                                           |   27 +++--
 fs/cifs/smb2ops.c                                        |    7 +
 fs/cifs/smb2pdu.c                                        |    3 
 fs/f2fs/checkpoint.c                                     |    4 
 fs/jffs2/fs.c                                            |    1 
 fs/kernfs/dir.c                                          |   31 ++++--
 fs/nfs/nfs4proc.c                                        |    4 
 fs/zonefs/super.c                                        |   11 +-
 include/linux/iio/common/st_sensors.h                    |    3 
 include/linux/jump_label.h                               |    4 
 include/linux/mlx5/mlx5_ifc.h                            |    5 -
 include/linux/nodemask.h                                 |   38 ++++----
 include/net/flow_offload.h                               |    1 
 include/net/netfilter/nf_tables.h                        |    1 
 include/net/netfilter/nf_tables_offload.h                |    2 
 include/net/sch_generic.h                                |   42 +++------
 kernel/bpf/core.c                                        |   14 +--
 kernel/trace/trace.c                                     |   13 ++
 lib/Makefile                                             |    2 
 lib/nodemask.c                                           |    4 
 net/core/flow_offload.c                                  |    6 +
 net/ipv4/ip_gre.c                                        |   11 +-
 net/ipv4/tcp_input.c                                     |   11 +-
 net/ipv4/tcp_output.c                                    |    4 
 net/ipv4/xfrm4_protocol.c                                |    1 
 net/ipv6/seg6_hmac.c                                     |    1 
 net/key/af_key.c                                         |   10 +-
 net/netfilter/nf_tables_api.c                            |   52 ++++-------
 net/netfilter/nf_tables_offload.c                        |   23 ++++-
 net/netfilter/nft_nat.c                                  |    3 
 net/smc/smc_cdc.c                                        |    2 
 net/sunrpc/xdr.c                                         |    6 +
 net/sunrpc/xprtrdma/rpc_rdma.c                           |    5 +
 net/tipc/bearer.c                                        |    3 
 net/unix/af_unix.c                                       |    2 
 scripts/gdb/linux/config.py                              |    6 -
 scripts/mod/modpost.c                                    |    5 -
 sound/pci/hda/patch_conexant.c                           |    7 +
 sound/pci/hda/patch_realtek.c                            |    1 
 sound/soc/fsl/fsl_sai.h                                  |    4 
 tools/perf/builtin-c2c.c                                 |    4 
 tools/testing/selftests/netfilter/nft_nat.sh             |   43 +++++++++
 181 files changed, 1050 insertions(+), 569 deletions(-)

Adrian Hunter (1):
      mmc: block: Fix CQE recovery reset success

Alexander Lobakin (1):
      modpost: fix removing numeric suffixes

Alexandru Tachici (1):
      iio: adc: ad7124: Remove shift from scan_type

Alexey Kardashevskiy (1):
      powerpc/mm: Switch obsolete dssall to .long

Andre Przywara (1):
      clocksource/drivers/sp804: Avoid error on multiple instances

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

Christian Borntraeger (1):
      s390/gmap: voluntarily schedule during key setting

Christophe JAILLET (1):
      staging: fieldbus: Fix the error handling path in anybuss_host_common_probe()

Chuck Lever (1):
      SUNRPC: Fix the calculation of xdr->end in xdr_get_next_encode_buffer()

Cixi Geng (2):
      iio: adc: sc27xx: fix read big scale voltage not right
      iio: adc: sc27xx: Fine tune the scale calibration values

Damien Le Moal (2):
      scsi: sd: Fix potential NULL pointer dereference
      zonefs: fix handling of explicit_open option on mount

Dan Carpenter (1):
      net: ethernet: mtk_eth_soc: out of bounds read in mtk_hwlro_get_fdir_entry()

Daniel Gibson (1):
      tty: n_tty: Restore EOF push handling behavior

Dave Jiang (2):
      dmaengine: idxd: set DMA_INTERRUPT cap bit
      dmaengine: idxd: add missing callback function to support DMA_INTERRUPT

David Howells (1):
      afs: Fix infinite loop found by xfstest generic/676

Dongliang Mu (1):
      f2fs: remove WARN_ON in f2fs_is_valid_blkaddr

Duoming Zhou (4):
      drivers: staging: rtl8192u: Fix deadlock in ieee80211_beacons_stop()
      drivers: staging: rtl8192e: Fix deadlock in rtllib_beacons_stop()
      drivers: tty: serial: Fix deadlock in sa1100_set_termios()
      drivers: usb: host: Fix deadlock in oxu_bus_suspend()

Eric Dumazet (3):
      tcp: tcp_rtx_synack() can be called from process context
      bpf, arm64: Clear prog->jited_len along prog->jited
      tcp: fix tcp_mtup_probe_success vs wrong snd_cwnd

Evan Green (1):
      USB: hcd-pci: Fully suspend across freeze/thaw cycle

Feras Daoud (1):
      net/mlx5: Rearm the FW tracer after each tracer event

Florian Westphal (1):
      netfilter: nat: really support inet nat without l3 address

Gal Pressman (1):
      net/mlx4_en: Fix wrong return value on ioctl EEPROM query failure

Gong Yuanjun (2):
      mips: cpc: Fix refcount leak in mips_cpc_default_phys_base
      drm/radeon: fix a possible null pointer dereference

Greg Kroah-Hartman (1):
      Linux 5.10.122

Greg Ungerer (2):
      m68knommu: set ZERO_PAGE() to the allocated zeroed page
      m68knommu: fix undefined reference to `_init_sp'

Guangguan Wang (1):
      net/smc: fixes for converting from "struct smc_cdc_tx_pend **" to "struct smc_wr_tx_pend_priv *"

Guilherme G. Piccoli (1):
      coresight: cpu-debug: Replace mutex with mutex_trylock on panic notifier

Guoju Fang (1):
      net: sched: add barrier to fix packet stuck problem for lockless qdisc

Guoqing Jiang (1):
      md: protect md_unregister_thread from reentrancy

Haibo Chen (1):
      gpio: pca953x: use the correct register address to do regcache sync

Hangyu Hua (1):
      usb: usbip: fix a refcount leak in stub_probe()

Hannes Reinecke (1):
      scsi: myrb: Fix up null pointer access on myrb_cleanup()

Hao Luo (1):
      kernfs: Separate kernfs_pr_cont_buf and rename_lock.

Heinrich Schuchardt (1):
      riscv: read-only pages should not be writable

Hoang Le (1):
      tipc: check attribute length for bearer name

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

Jakob Koschel (1):
      staging: greybus: codecs: fix type confusion of list iterator variable

Jann Horn (1):
      s390/crypto: fix scatterwalk_unmap() callers in AES-GCM

Jiasheng Jiang (1):
      lkdtm/bugs: Check for the NULL pointer after calling kmalloc

Johan Hovold (2):
      phy: qcom-qmp: fix pipe-clock imbalance on power-on failure
      PCI: qcom: Fix pipe clock imbalance

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

Leo Yan (1):
      perf c2c: Fix sorting in percent_rmt_hitm_cmp()

Leon Romanovsky (1):
      net/mlx5: Don't use already freed action pointer

Li Jun (1):
      extcon: ptn5150: Add queue work sync before driver release

Lin Ma (1):
      USB: storage: karma: fix rio_karma_init return

Linus Torvalds (1):
      drm: imx: fix compiler warning with gcc-12

Liu Xinpeng (1):
      watchdog: wdat_wdt: Stop watchdog when rebooting the system

Lucas Tanure (1):
      i2c: cadence: Increase timeout per message if necessary

Maciej W. Rozycki (1):
      serial: sifive: Report actual baud base rather than fixed 115200

Marek Szyprowski (1):
      usb: dwc2: gadget: don't reset gadget's driver->bus

Mark Bloch (1):
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

Miaoqian Lin (13):
      tty: serial: owl: Fix missing clk_disable_unprepare() in owl_uart_probe
      usb: musb: Fix missing of_node_put() in omap2430_probe
      iio: adc: stmpe-adc: Fix wait_for_completion_timeout return value check
      iio: proximity: vl53l0x: Fix return value check of wait_for_completion_timeout
      soc: rockchip: Fix refcount leak in rockchip_grf_init
      firmware: dmi-sysfs: Fix memory leak in dmi_sysfs_register_handle
      watchdog: rti-wdt: Fix pm_runtime_get_sync() error checking
      watchdog: ts4800_wdt: Fix refcount leak in ts4800_wdt_probe
      net: ethernet: ti: am65-cpsw-nuss: Fix some refcount leaks
      net: dsa: mv88e6xxx: Fix refcount leak in mv88e6xxx_mdios_register
      ata: pata_octeon_cf: Fix refcount leak in octeon_cf_probe
      net: dsa: lantiq_gswip: Fix refcount leak in gswip_gphy_fw_list
      net: altera: Fix refcount leak in altera_tse_mdio_create

Michael Ellerman (2):
      powerpc/kasan: Force thread size increase with KASAN
      powerpc/32: Fix overread/overwrite of thread_struct via ptrace

Michal Kubecek (1):
      Revert "net: af_key: add check for pfkey_broadcast in function pfkey_process"

Miquel Raynal (1):
      iio: st_sensors: Add a local lock for protecting odr

Niels Dossche (1):
      usb: usbip: add missing device lock on tweak configuration cmd

Olivier Matz (2):
      ixgbe: fix bcast packets Rx on VF after promisc removal
      ixgbe: fix unexpected VLAN Rx in promisc mode on VF

Pablo Neira Ayuso (5):
      netfilter: nf_tables: delete flowtable hooks via transaction list
      netfilter: nf_tables: always initialize flowtable hook list in transaction
      netfilter: nf_tables: release new hooks on unsupported flowtable flags
      netfilter: nf_tables: memleak flow rule from commit path
      netfilter: nf_tables: bail out early if hardware offload is not supported

Pascal Hambourg (1):
      md/raid0: Ignore RAID0 layout if the second zone has only one device

Paulo Alcantara (1):
      cifs: fix reconnect on smb3 mount types

Peter Zijlstra (2):
      x86/cpu: Elide KCSAN for cpu_has() and friends
      jump_label,noinstr: Avoid instrumentation for JUMP_LABEL=n builds

Radhey Shyam Pandey (1):
      dmaengine: zynqmp_dma: In struct zynqmp_dma_chan fix desc_size data type

Randy Dunlap (1):
      pcmcia: db1xxx_ss: restrict to MIPS_DB1XXX boards

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

Stephen Boyd (2):
      interconnect: qcom: sc7180: Drop IP0 interconnects
      interconnect: Restore sync state by ignoring ipa-virt in provider count

Steve French (1):
      cifs: version operations for smb20 unneeded when legacy support disabled

Tan Tee Min (1):
      net: phy: dp83867: retrigger SGMII AN when link change

Tony Lindgren (1):
      bus: ti-sysc: Fix warnings for unbind for serial

Trond Myklebust (1):
      NFSv4: Don't hold the layoutget locks across multiple RPC calls

Uwe Kleine-König (1):
      pwm: lp3943: Fix duty calculation in case period was clamped

Venky Shankar (1):
      ceph: allow ceph.dir.rctime xattr to be updatable

Vincent Ray (1):
      net: sched: fixed barrier to prevent skbuff sticking in qdisc backlog

Wang Cheng (2):
      staging: rtl8712: fix uninit-value in usb_read8() and friends
      staging: rtl8712: fix uninit-value in r871xu_drv_init()

Wang Weiyang (1):
      tty: goldfish: Use tty_port_destroy() to destroy port

Willem de Bruijn (1):
      ip_gre: test csum_start instead of transport header

Xiaoke Wang (2):
      iio: dummy: iio_simple_dummy: check the return value of kstrdup()
      staging: rtl8712: fix a potential memory leak in r871xu_drv_init()

Xiaomeng Tong (2):
      misc: fastrpc: fix an incorrect NULL check on list iterator
      firmware: stratix10-svc: fix a missing check on list iterator

Xie Yongji (1):
      vringh: Fix loop descriptors check in the indirect cases

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

