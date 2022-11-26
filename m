Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 871A663956B
	for <lists+stable@lfdr.de>; Sat, 26 Nov 2022 11:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiKZKmh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Nov 2022 05:42:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiKZKmf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Nov 2022 05:42:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62AA8E45;
        Sat, 26 Nov 2022 02:42:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E07EB8119B;
        Sat, 26 Nov 2022 10:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 417EFC433C1;
        Sat, 26 Nov 2022 10:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669459345;
        bh=jyEpiZlJqg2KgA7ouWZP5VFeHXYNI/Mz/LfafQzaWq8=;
        h=From:To:Cc:Subject:Date:From;
        b=NIdUfiKxe3yIppLlGiimW8CsCXPpmgmZw10dz+3CMEAihGq/oSn0lpjGn1/V17Jz2
         16tIu/7VhTk5oUfgZxtIWP3S3B0DVj4QwjBeE9kI0YcDh/f7ElfD/QBCCZB6csPpgS
         V+/ABNdl27v03tZZfxCHJegRqMGkndZinJVu2iqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.80
Date:   Sat, 26 Nov 2022 11:20:46 +0100
Message-Id: <1669458046480@kroah.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.80 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/process/code-of-conduct-interpretation.rst |    2 
 Makefile                                                 |    2 
 arch/arm/boot/dts/imx7s.dtsi                             |    4 
 arch/arm/boot/dts/sama7g5-pinfunc.h                      |    2 
 arch/arm/mach-at91/pm_suspend.S                          |    7 
 arch/arm64/boot/dts/freescale/imx8mm.dtsi                |    4 
 arch/arm64/boot/dts/freescale/imx8mn.dtsi                |    2 
 arch/arm64/boot/dts/qcom/sa8155p-adp.dts                 |   13 +
 arch/arm64/boot/dts/qcom/sm8150-sony-xperia-kumano.dtsi  |    6 
 arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi     |    6 
 arch/arm64/boot/dts/qcom/sm8350-hdk.dts                  |   12 +
 arch/arm64/include/asm/cputype.h                         |    2 
 arch/mips/kernel/relocate_kernel.S                       |   15 --
 arch/mips/loongson64/reset.c                             |   10 +
 arch/x86/events/intel/pt.c                               |    9 +
 arch/x86/include/asm/intel-family.h                      |   11 +
 arch/x86/kvm/x86.c                                       |   14 -
 block/sed-opal.c                                         |   32 +++-
 drivers/accessibility/speakup/main.c                     |    2 
 drivers/acpi/scan.c                                      |    1 
 drivers/acpi/x86/utils.c                                 |    6 
 drivers/ata/libata-transport.c                           |   19 ++
 drivers/block/drbd/drbd_main.c                           |    4 
 drivers/firmware/arm_scmi/bus.c                          |   11 +
 drivers/firmware/arm_scmi/common.h                       |    1 
 drivers/firmware/arm_scmi/driver.c                       |   31 ++--
 drivers/firmware/google/coreboot_table.c                 |   37 +++--
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c       |    2 
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubp.c        |    1 
 drivers/gpu/drm/drm_drv.c                                |    2 
 drivers/gpu/drm/drm_internal.h                           |    3 
 drivers/gpu/drm/imx/imx-tve.c                            |    5 
 drivers/gpu/drm/panel/panel-simple.c                     |    2 
 drivers/gpu/drm/vc4/vc4_kms.c                            |    8 -
 drivers/i2c/busses/i2c-i801.c                            |    1 
 drivers/i2c/busses/i2c-tegra.c                           |   16 +-
 drivers/iio/adc/at91_adc.c                               |    4 
 drivers/iio/adc/mp2629_adc.c                             |    5 
 drivers/iio/pressure/ms5611_spi.c                        |    2 
 drivers/iio/trigger/iio-trig-sysfs.c                     |    6 
 drivers/infiniband/hw/efa/efa_main.c                     |    4 
 drivers/input/joystick/iforce/iforce-main.c              |    8 -
 drivers/input/serio/i8042.c                              |    4 
 drivers/iommu/intel/iommu.c                              |    8 -
 drivers/iommu/intel/pasid.c                              |    5 
 drivers/isdn/mISDN/core.c                                |    2 
 drivers/isdn/mISDN/dsp_pipeline.c                        |    3 
 drivers/md/dm-ioctl.c                                    |    4 
 drivers/mfd/lpc_ich.c                                    |   59 +++++++
 drivers/misc/vmw_vmci/vmci_queue_pair.c                  |    2 
 drivers/mmc/core/core.c                                  |    8 -
 drivers/mmc/host/sdhci-pci-core.c                        |    2 
 drivers/mmc/host/sdhci-pci-o2micro.c                     |    7 
 drivers/mtd/spi-nor/controllers/intel-spi-pci.c          |   29 ++-
 drivers/mtd/spi-nor/controllers/intel-spi.c              |   51 +++---
 drivers/net/ethernet/amazon/ena/ena_netdev.c             |    8 -
 drivers/net/ethernet/atheros/ag71xx.c                    |    3 
 drivers/net/ethernet/broadcom/bgmac.c                    |    1 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                |   10 +
 drivers/net/ethernet/cavium/liquidio/lio_main.c          |   34 +++-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c  |   10 -
 drivers/net/ethernet/huawei/hinic/hinic_main.c           |    9 +
 drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c   |    3 
 drivers/net/ethernet/microchip/sparx5/sparx5_main.c      |    3 
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c     |    6 
 drivers/net/ethernet/pensando/ionic/ionic_main.c         |    8 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c        |    3 
 drivers/net/macvlan.c                                    |    6 
 drivers/net/mhi_net.c                                    |    2 
 drivers/net/phy/marvell.c                                |   16 +-
 drivers/net/thunderbolt.c                                |   19 +-
 drivers/nvme/host/ioctl.c                                |    6 
 drivers/nvme/host/nvme.h                                 |   16 +-
 drivers/parport/parport_pc.c                             |    2 
 drivers/pinctrl/devicetree.c                             |    2 
 drivers/pinctrl/pinctrl-rockchip.c                       |   40 +++++
 drivers/platform/surface/aggregator/ssh_packet_layer.c   |   24 ++-
 drivers/platform/x86/intel/pmc/pltdrv.c                  |    9 +
 drivers/s390/scsi/zfcp_fsf.c                             |    2 
 drivers/scsi/scsi_debug.c                                |    6 
 drivers/scsi/scsi_transport_sas.c                        |   13 +
 drivers/siox/siox-core.c                                 |    2 
 drivers/slimbus/Kconfig                                  |    2 
 drivers/slimbus/stream.c                                 |    8 -
 drivers/soc/imx/soc-imx8m.c                              |   11 +
 drivers/spi/spi-stm32.c                                  |    1 
 drivers/target/loopback/tcm_loop.c                       |    3 
 drivers/tty/n_gsm.c                                      |    2 
 drivers/tty/serial/8250/8250_lpss.c                      |   18 +-
 drivers/tty/serial/8250/8250_omap.c                      |   45 +++---
 drivers/tty/serial/8250/8250_port.c                      |    7 
 drivers/tty/serial/imx.c                                 |    1 
 drivers/usb/cdns3/host.c                                 |   56 +++----
 drivers/usb/chipidea/otg_fsm.c                           |    2 
 drivers/usb/core/quirks.c                                |    3 
 drivers/usb/dwc3/host.c                                  |   10 -
 drivers/usb/host/bcma-hcd.c                              |   10 -
 drivers/usb/serial/option.c                              |   19 ++
 drivers/usb/typec/mux/intel_pmc_mux.c                    |   15 +-
 drivers/xen/pcpu.c                                       |    2 
 fs/btrfs/raid56.c                                        |    6 
 fs/btrfs/tests/qgroup-tests.c                            |   16 --
 fs/buffer.c                                              |    4 
 fs/cifs/ioctl.c                                          |    4 
 fs/cifs/smb2ops.c                                        |    4 
 fs/gfs2/ops_fstype.c                                     |   17 +-
 fs/hugetlbfs/inode.c                                     |   13 -
 fs/namei.c                                               |    2 
 fs/nfs/nfs4proc.c                                        |    6 
 fs/ntfs/attrib.c                                         |   28 +++
 fs/ntfs/inode.c                                          |    7 
 include/linux/platform_data/x86/intel-spi.h              |    6 
 include/linux/ring_buffer.h                              |    2 
 include/linux/trace.h                                    |    4 
 include/linux/wireless.h                                 |   10 +
 include/net/ip.h                                         |    2 
 include/net/ipv6.h                                       |    2 
 include/soc/at91/sama7-ddr.h                             |    5 
 include/uapi/linux/ip.h                                  |    6 
 include/uapi/linux/ipv6.h                                |    6 
 kernel/bpf/percpu_freelist.c                             |   23 +--
 kernel/bpf/verifier.c                                    |   14 +
 kernel/events/core.c                                     |   25 ++-
 kernel/kprobes.c                                         |    8 -
 kernel/trace/ftrace.c                                    |    5 
 kernel/trace/kprobe_event_gen_test.c                     |   48 ++++--
 kernel/trace/ring_buffer.c                               |   71 ++++++---
 kernel/trace/synth_event_gen_test.c                      |   16 --
 kernel/trace/trace.c                                     |    3 
 kernel/trace/trace_eprobe.c                              |    3 
 kernel/trace/trace_events_synth.c                        |    5 
 mm/filemap.c                                             |    2 
 mm/hugetlb.c                                             |    4 
 mm/maccess.c                                             |    2 
 mm/memory-failure.c                                      |  111 ++++++++++-----
 mm/shmem.c                                               |   51 ++++++
 mm/userfaultfd.c                                         |    5 
 net/9p/trans_fd.c                                        |   45 +++---
 net/bluetooth/l2cap_core.c                               |    2 
 net/bpf/test_run.c                                       |    1 
 net/bridge/br_vlan.c                                     |   17 +-
 net/caif/chnl_net.c                                      |    3 
 net/dsa/dsa_priv.h                                       |    1 
 net/dsa/master.c                                         |    3 
 net/dsa/port.c                                           |   16 ++
 net/ipv4/tcp_cdg.c                                       |    2 
 net/kcm/kcmsock.c                                        |   62 +-------
 net/wireless/wext-core.c                                 |   17 +-
 net/x25/x25_dev.c                                        |    2 
 sound/pci/hda/patch_realtek.c                            |    2 
 sound/soc/codecs/jz4725b.c                               |   34 ++--
 sound/soc/codecs/mt6660.c                                |    8 -
 sound/soc/codecs/rt1019.c                                |   20 +-
 sound/soc/codecs/rt1019.h                                |    6 
 sound/soc/codecs/rt1308-sdw.h                            |    2 
 sound/soc/codecs/tas2764.c                               |   19 --
 sound/soc/codecs/tas2770.c                               |   20 --
 sound/soc/codecs/wm5102.c                                |    6 
 sound/soc/codecs/wm5110.c                                |    6 
 sound/soc/codecs/wm8962.c                                |   54 +++++++
 sound/soc/codecs/wm8997.c                                |    6 
 sound/soc/intel/boards/sof_sdw.c                         |   11 +
 sound/soc/soc-core.c                                     |   17 ++
 sound/soc/soc-utils.c                                    |    2 
 sound/usb/midi.c                                         |    4 
 tools/testing/selftests/futex/functional/Makefile        |    6 
 tools/testing/selftests/intel_pstate/Makefile            |    6 
 167 files changed, 1331 insertions(+), 611 deletions(-)

Aashish Sharma (1):
      tracing: Fix warning on variable 'struct trace_array'

Adrian Hunter (1):
      perf/x86/intel/pt: Fix sampling using single range output

Aishwarya Kothari (1):
      drm/panel: simple: set bpc field for logic technologies displays

Alban Crequy (1):
      maccess: Fix writing offset in case of fault in strncpy_from_kernel_nofault()

Alexander Potapenko (2):
      misc/vmw_vmci: fix an infoleak in vmci_host_do_receive_datagram()
      mm: fs: initialize fsdata passed to write_begin/write_end interface

Aminuddin Jamaluddin (1):
      net: phy: marvell: add sleep time after enabling the loopback bit

Anastasia Belova (2):
      cifs: add check for returning value of SMB2_close_init
      cifs: add check for returning value of SMB2_set_info_init

Andreas Gruenbacher (1):
      gfs2: Switch from strlcpy to strscpy

Andrew Price (1):
      gfs2: Check sb_bsize_shift after reading superblock

Baisong Zhong (1):
      bpf, test_run: Fix alignment problem in bpf_prog_test_run_skb()

Benjamin Block (1):
      scsi: zfcp: Fix double free of FSF request when qdio send fails

Benjamin Coddington (1):
      NFSv4: Retry LOCK on OLD_STATEID during delegation return

Benoît Monin (1):
      USB: serial: option: add Sierra Wireless EM9191

Brian Norris (1):
      firmware: coreboot: Register bus in module init

Chen Jun (1):
      Input: i8042 - fix leaking of platform device on module removal

Chen Zhongjin (2):
      ASoC: core: Fix use-after-free in snd_soc_exit()
      ASoC: soc-utils: Remove __exit for snd_soc_util_exit()

Chevron Li (1):
      mmc: sdhci-pci-o2micro: fix card detect fail issue caused by CD# debounce timeout

Chuang Wang (1):
      net: macvlan: Use built-in RCU list checking

Claudiu Beznea (1):
      ARM: at91: pm: avoid soft resetting AC DLL

Colin Ian King (1):
      ASoC: codecs: jz4725b: Fix spelling mistake "Sourc" -> "Source", "Routee" -> "Route"

Cong Wang (1):
      kcm: close race conditions on sk_receive_queue

Cristian Marussi (1):
      firmware: arm_scmi: Cleanup the core driver removal callback

D Scott Phillips (1):
      arm64: Fix bit-shifting UB in the MIDR_CPU_MODEL() macro

Dan Carpenter (1):
      drbd: use after free in drbd_create_device()

Daniil Tatianin (1):
      ring_buffer: Do not deactivate non-existant pages

Davide Tronchin (3):
      USB: serial: option: remove old LARA-R6 PID
      USB: serial: option: add u-blox LARA-R6 00B modem
      USB: serial: option: add u-blox LARA-L6 modem

Derek Fang (1):
      ASoC: rt1019: Fix the TDM settings

Dominique Martinet (2):
      9p: trans_fd/p9_conn_cancel: drop client lock earlier
      net/9p: use a dedicated spinlock for trans_fd

Douglas Anderson (4):
      arm64: dts: qcom: sa8155p-adp: Specify which LDO modes are allowed
      arm64: dts: qcom: sm8150-xperia-kumano: Specify which LDO modes are allowed
      arm64: dts: qcom: sm8250-xperia-edo: Specify which LDO modes are allowed
      arm64: dts: qcom: sm8350-hdk: Specify which LDO modes are allowed

Duoming Zhou (2):
      tty: n_gsm: fix sleep-in-atomic-context bug in gsm_control_send
      usb: chipidea: fix deadlock in ci_otg_del_timer

Emil Flink (1):
      ALSA: hda/realtek: fix speakers for Samsung Galaxy Book Pro

Eric Dumazet (3):
      macvlan: enforce a consistent minimal mtu
      tcp: cdg: allow tcp_cdg_release() to be called multiple times
      kcm: avoid potential race in kcm_tx_work

Filipe Manana (1):
      btrfs: remove pointless and double ulist frees in error paths of qgroup tests

Gaosheng Cui (2):
      drm/vc4: kms: Fix IS_ERR() vs NULL check for vc4_kms
      bnxt_en: Remove debugfs when pci_register_driver failed

Greg Kroah-Hartman (1):
      Linux 5.15.80

Guangbin Huang (1):
      net: hns3: fix setting incorrect phy link ksettings for firmware in resetting process

Hangbin Liu (1):
      net: use struct_group to copy ip/ipv6 header addresses

Hans de Goede (1):
      ACPI: scan: Add LATT2021 to acpi_ignore_dep_ids[]

Hawkins Jiawei (4):
      wifi: wext: use flex array destination for memcpy()
      ntfs: fix use-after-free in ntfs_attr_find()
      ntfs: fix out-of-bounds read in ntfs_attr_find()
      ntfs: check overflow when iterating ATTR_RECORDs

Ido Schimmel (1):
      bridge: switchdev: Fix memory leaks when changing VLAN protocol

Ilpo Järvinen (4):
      serial: 8250: Fall back to non-DMA Rx if IIR_RDI occurs
      serial: 8250: Flush DMA Rx on RLSI
      serial: 8250_lpss: Configure DMA also w/o DMA filter
      serial: 8250_lpss: Use 16B DMA burst with Elkhart Lake

Jaco Coetzee (1):
      nfp: change eeprom length to max length enumerators

James Houghton (1):
      hugetlbfs: don't delete error page from pagecache

Johan Hovold (1):
      Revert "usb: dwc3: disable USB core PHY management"

Keith Busch (2):
      nvme: restrict management ioctls to admin
      nvme: ensure subsystem reset is single threaded

Krzysztof Kozlowski (1):
      slimbus: stream: correct presence rate frequencies

Li Huafei (1):
      kprobes: Skip clearing aggrprobe's post_handler in kprobe-on-ftrace case

Li Jun (1):
      usb: cdns3: host: fix endless superspeed hub port reset

Liao Chang (1):
      MIPS: Loongson64: Add WARN_ON on kexec related kmalloc failed

Like Xu (1):
      KVM: x86/pmu: Do not speculatively query Intel GP PMCs that don't exist yet

Linus Walleij (1):
      USB: bcma: Make GPIO explicitly optional

Liu Jian (1):
      net: ag71xx: call phylink_disconnect_phy if ag71xx_hw_enable() fail in ag71xx_open()

Luiz Augusto von Dentz (1):
      Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm

Maciej W. Rozycki (1):
      parport_pc: Avoid FIFO port location truncation

Marco Elver (1):
      perf: Improve missing SIGTRAP checking

Marek Vasut (4):
      spi: stm32: Print summary 'callbacks suppressed' message
      ARM: dts: imx7: Fix NAND controller size-cells
      arm64: dts: imx8mm: Fix NAND controller size-cells
      arm64: dts: imx8mn: Fix NAND controller size-cells

Mario Limonciello (1):
      ACPI: x86: Add another system to quirk list for forcing StorageD3Enable

Martin Povišer (2):
      ASoC: tas2770: Fix set_tdm_slot in case of single slot
      ASoC: tas2764: Fix set_tdm_slot in case of single slot

Matthias Schiffer (1):
      serial: 8250_omap: remove wait loop from Errata i202 workaround

Mauro Lima (1):
      spi: intel: Fix the offset to get the 64K erase opcode

Maximilian Luz (1):
      platform/surface: aggregator: Do not check for repeated unsequenced packets

Michael Margolin (1):
      RDMA/efa: Add EFA 0xefa2 PCI ID

Mihai Sain (1):
      ARM: dts: at91: sama7g5: fix signal name of pin PB2

Mika Westerberg (2):
      mtd: spi-nor: intel-spi: Disable write protection only if asked
      spi: intel: Use correct mask for flash and protected regions

Mikulas Patocka (1):
      dm ioctl: fix misbehavior if list_versions races with module loading

Mitja Spes (1):
      iio: pressure: ms5611: changed hardcoded SPI speed to value limited

Mohd Faizal Abdul Rahim (1):
      net: stmmac: ensure tx function is not running in stmmac_xdp_release()

Mushahid Hussain (1):
      speakup: fix a segfault caused by switching consoles

Nam Cao (1):
      i2c: i801: add lis3lv02d's I2C address for Vostro 5568

Nathan Huckleberry (1):
      drm/imx: imx-tve: Fix return type of imx_tve_connector_mode_valid

Nicolas Dumazet (1):
      usb: add NO_LPM quirk for Realforce 87U Keyboard

Pierre-Louis Bossart (1):
      ASoC: Intel: sof_sdw: add quirk variant for LAPBC710 NUC15

Qu Wenruo (1):
      btrfs: raid56: properly handle the error when unable to find the missing stripe

Quentin Schulz (1):
      pinctrl: rockchip: list all pins in a possible mux route for PX30

Rajat Khandelwal (1):
      usb: typec: mux: Enter safe mode only when pins need to be reconfigured

Reinhard Speyerer (1):
      USB: serial: option: add Fibocom FM160 0x0111 composition

Ricardo Cañuelo (2):
      selftests/futex: fix build for clang
      selftests/intel_pstate: fix build for ARCH=x86_64

Rodrigo Siqueira (2):
      drm/amd/display: Remove wrong pipe control lock
      drm/amd/display: Add HUBP surface flip interrupt handler

Roger Pau Monné (1):
      platform/x86/intel: pmc: Don't unconditionally attach Intel PMC when virtualized

Rongwei Zhang (1):
      MIPS: fix duplicate definitions for exported symbols

Saravanan Sekar (2):
      iio: adc: mp2629: fix wrong comparison of channel
      iio: adc: mp2629: fix potential array out of bound access

Serge Semin (1):
      block: sed-opal: kmalloc the cmd/resp buffers

Shang XiaoJing (7):
      drm/drv: Fix potential memory leak in drm_dev_init()
      drm: Fix potential null-ptr-deref in drm_vblank_destroy_worker()
      net: microchip: sparx5: Fix potential null-ptr-deref in sparx_stats_init() and sparx5_start()
      tracing: Fix memory leak in test_gen_synth_cmd() and test_empty_synth_event()
      tracing: Fix wild-memory-access in register_synth_event()
      tracing: kprobe: Fix potential null-ptr-deref on trace_event_file in kprobe_event_gen_test_exit()
      tracing: kprobe: Fix potential null-ptr-deref on trace_array in kprobe_event_gen_test_exit()

Shawn Guo (1):
      serial: imx: Add missing .thaw_noirq hook

Shuah Khan (1):
      docs: update mediator contact information in CoC doc

Shuming Fan (1):
      ASoC: rt1308-sdw: add the default value of some registers

Siarhei Volkau (4):
      ASoC: codecs: jz4725b: add missed Line In power control bit
      ASoC: codecs: jz4725b: fix reported volume for Master ctl
      ASoC: codecs: jz4725b: use right control for Capture Volume
      ASoC: codecs: jz4725b: fix capture selector naming

Steven Rostedt (Google) (3):
      tracing/ring-buffer: Have polling block on watermark
      tracing: Fix race where eprobes can be called before the event
      ring-buffer: Include dropped pages in counting dirty patches

Takashi Iwai (2):
      ALSA: usb-audio: Drop snd_BUG_ON() from snd_usbmidi_output_open()
      ALSA: hda/realtek: Fix the speaker output on Samsung Galaxy Book Pro 360

Tetsuo Handa (2):
      Input: iforce - invert valid length check when fetching device IDs
      9p/trans_fd: always use O_NONBLOCK read/write

Thierry Reding (1):
      i2c: tegra: Allocate DMA memory for DMA engine

Tina Zhang (2):
      iommu/vt-d: Preset Access bit for IOVA in FL non-leaf paging entries
      iommu/vt-d: Set SRE bit only when hardware has SRS cap

Tony Lindgren (3):
      serial: 8250: omap: Fix missing PM runtime calls for omap8250_set_mctrl()
      serial: 8250: omap: Fix unpaired pm_runtime_put_sync() in omap8250_remove()
      serial: 8250: omap: Flush PM QOS work on remove

Tony Luck (1):
      x86/cpu: Add several Intel server CPU model numbers

Vladimir Oltean (1):
      net: dsa: make dsa_master_ioctl() see through port_hwtstamp_get() shims

Wang ShaoBo (1):
      mISDN: fix misuse of put_device() in mISDN_register_device()

Wang Wensheng (2):
      ftrace: Fix the possible incorrect kernel message
      ftrace: Optimize the allocation for mcount entries

Wang Yufen (2):
      bpf: Fix memory leaks in __check_func_call
      tracing: Fix memory leak in tracing_read_pipe()

Wei Yongjun (3):
      net: bgmac: Drop free_netdev() from bgmac_enet_remove()
      net: mhi: Fix memory leak in mhi_net_dellink()
      net/x25: Fix skb leak in x25_lapb_receive_frame()

Xiaolei Wang (2):
      ASoC: wm8962: Add an event handler for TEMP_HP and TEMP_SPK
      soc: imx8m: Enable OCOTP clock before reading the register

Xiongfeng Wang (1):
      mmc: sdhci-pci: Fix possible memory leak caused by missing pci_dev_put()

Xiu Jianfeng (1):
      ftrace: Fix null pointer dereference in ftrace_add_mod()

Xu Kuohai (1):
      bpf: Initialize same number of free nodes for each pcpu_freelist

Yang Shi (3):
      mm: hwpoison: refactor refcount check handling
      mm: hwpoison: handle non-anonymous THP correctly
      mm: shmem: don't truncate page if memory failure happens

Yang Yingliang (11):
      scsi: scsi_transport_sas: Fix error handling in sas_phy_add()
      siox: fix possible memory leak in siox_device_add()
      ata: libata-transport: fix double ata_host_put() in ata_tport_add()
      ata: libata-transport: fix error handling in ata_tport_add()
      ata: libata-transport: fix error handling in ata_tlink_add()
      ata: libata-transport: fix error handling in ata_tdev_add()
      mISDN: fix possible memory leak in mISDN_dsp_element_register()
      xen/pcpu: fix possible memory leak in register_pcpu()
      iio: adc: at91_adc: fix possible memory leak in at91_adc_allocate_trigger()
      iio: trigger: sysfs: fix possible memory leak in iio_sysfs_trig_init()
      scsi: target: tcm_loop: Fix possible name leak in tcm_loop_setup_hba_bus()

Yann Gautier (1):
      mmc: core: properly select voltage range without power cycle

Yuan Can (5):
      net: hinic: Fix error handling in hinic_module_init()
      net: ionic: Fix error handling in ionic_init_module()
      net: ena: Fix error handling in ena_init()
      net: thunderbolt: Fix error handling in tbnet_init()
      scsi: scsi_debug: Fix possible UAF in sdebug_add_host_helper()

Zeng Heng (1):
      pinctrl: devicetree: fix null pointer dereferencing in pinctrl_dt_to_map

Zhang Qilong (4):
      ASoC: wm5102: Revert "ASoC: wm5102: Fix PM disable depth imbalance in wm5102_probe"
      ASoC: wm5110: Revert "ASoC: wm5110: Fix PM disable depth imbalance in wm5110_probe"
      ASoC: wm8997: Revert "ASoC: wm8997: Fix PM disable depth imbalance in wm8997_probe"
      ASoC: mt6660: Keep the pm_runtime enables before component stuff in mt6660_i2c_probe

Zhang Xiaoxu (1):
      cifs: Fix wrong return value checking when GETFLAGS

Zheng Bin (1):
      slimbus: qcom-ngd: Fix build error when CONFIG_SLIM_QCOM_NGD_CTRL=y && CONFIG_QCOM_RPROC_COMMON=m

Zhengchao Shao (2):
      net: liquidio: release resources when liquidio driver open failed
      net: caif: fix double disconnect client in chnl_net_open()

