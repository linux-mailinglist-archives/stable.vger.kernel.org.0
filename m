Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3952E71B9
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 16:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgL2PRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Dec 2020 10:17:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:40636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726823AbgL2PRb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Dec 2020 10:17:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FBBD2222A;
        Tue, 29 Dec 2020 15:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609254999;
        bh=ywJFW/n5R8EaLhct8bHxl8ZPk2hP0cnyxCU6EUyWwCU=;
        h=From:To:Cc:Subject:Date:From;
        b=BiGP7WMXgi8BEpNMccINZyZsJtbOQ9ZqMBhZe8ptf6FmC2ME5IJYG8fbOT/ji8PcH
         1iJ6pHn6B5jGykXDI8Fs9VAbWMtlVVU2MpzXdH46ThYJr54O1IP4mQoq9dAqMJVTgp
         TOwOy4STynZCmtw+KiOtzAeTze9OOmIgjWU/n4j0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.213
Date:   Tue, 29 Dec 2020 16:17:47 +0100
Message-Id: <1609255067229134@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.213 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt       |    1 
 Makefile                                              |    2 
 arch/arc/kernel/stacktrace.c                          |   23 ++-
 arch/arm/boot/dts/armada-xp-98dx3236.dtsi             |    5 
 arch/arm/boot/dts/at91-sama5d3_xplained.dts           |    7 +
 arch/arm/boot/dts/at91-sama5d4_xplained.dts           |    7 +
 arch/arm/boot/dts/at91sam9rl.dtsi                     |   19 +-
 arch/arm/boot/dts/exynos5410-odroidxu.dts             |    6 
 arch/arm/boot/dts/exynos5410-pinctrl.dtsi             |   28 ++++
 arch/arm/boot/dts/exynos5410.dtsi                     |    4 
 arch/arm/boot/dts/sama5d2.dtsi                        |    7 -
 arch/arm/boot/dts/sun8i-v3s.dtsi                      |    2 
 arch/arm/kernel/head.S                                |    6 
 arch/arm/mach-shmobile/pm-rmobile.c                   |    1 
 arch/arm64/boot/dts/exynos/exynos7.dtsi               |    4 
 arch/arm64/boot/dts/rockchip/rk3328.dtsi              |   16 +-
 arch/arm64/boot/dts/rockchip/rk3399.dtsi              |    3 
 arch/arm64/include/asm/kvm_host.h                     |    1 
 arch/arm64/kvm/sys_regs.c                             |    1 
 arch/mips/bcm47xx/Kconfig                             |    1 
 arch/powerpc/include/asm/cputable.h                   |    5 
 arch/powerpc/kernel/rtas.c                            |    2 
 arch/powerpc/perf/core-book3s.c                       |   10 +
 arch/powerpc/platforms/powernv/memtrace.c             |   22 +++
 arch/powerpc/platforms/pseries/suspend.c              |    4 
 arch/powerpc/xmon/nonstdio.c                          |    2 
 arch/s390/kernel/smp.c                                |   18 --
 arch/um/drivers/xterm.c                               |    5 
 arch/x86/include/asm/pgtable_types.h                  |    1 
 arch/x86/kernel/kprobes/core.c                        |    5 
 arch/x86/mm/ident_map.c                               |   12 +
 arch/x86/mm/mem_encrypt.c                             |    4 
 crypto/af_alg.c                                       |   10 +
 crypto/ecdh.c                                         |    9 -
 drivers/acpi/acpi_pnp.c                               |    3 
 drivers/acpi/device_pm.c                              |   41 +----
 drivers/acpi/resource.c                               |    2 
 drivers/block/xen-blkback/xenbus.c                    |    4 
 drivers/bus/mips_cdmm.c                               |    4 
 drivers/clk/clk-s2mps11.c                             |    1 
 drivers/clk/mvebu/armada-37xx-xtal.c                  |    4 
 drivers/clk/sunxi-ng/ccu-sun50i-a64.c                 |    1 
 drivers/clk/sunxi-ng/ccu-sun8i-h3.c                   |    1 
 drivers/clk/tegra/clk-id.h                            |    1 
 drivers/clk/tegra/clk-tegra-periph.c                  |    2 
 drivers/clk/ti/fapll.c                                |   11 +
 drivers/clocksource/arm_arch_timer.c                  |   23 ++-
 drivers/clocksource/cadence_ttc_timer.c               |   18 +-
 drivers/cpufreq/highbank-cpufreq.c                    |    7 +
 drivers/cpufreq/loongson1-cpufreq.c                   |    1 
 drivers/cpufreq/mediatek-cpufreq.c                    |    1 
 drivers/cpufreq/scpi-cpufreq.c                        |    1 
 drivers/cpufreq/sti-cpufreq.c                         |    7 +
 drivers/crypto/omap-aes.c                             |    3 
 drivers/crypto/talitos.c                              |    6 
 drivers/edac/amd64_edac.c                             |   26 ++-
 drivers/extcon/extcon-max77693.c                      |    2 
 drivers/gpio/gpio-mvebu.c                             |   16 +-
 drivers/gpu/drm/drm_dp_aux_dev.c                      |    2 
 drivers/gpu/drm/drm_dp_mst_topology.c                 |    7 -
 drivers/gpu/drm/gma500/cdv_intel_dp.c                 |    2 
 drivers/gpu/drm/omapdrm/omap_dmm_tiler.c              |    1 
 drivers/gpu/drm/tegra/sor.c                           |   10 +
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c              |    8 +
 drivers/hsi/controllers/omap_ssi_core.c               |    2 
 drivers/iio/adc/rockchip_saradc.c                     |    2 
 drivers/iio/imu/bmi160/bmi160_core.c                  |    4 
 drivers/iio/industrialio-buffer.c                     |    6 
 drivers/iio/light/rpr0521.c                           |   17 +-
 drivers/iio/pressure/mpl3115.c                        |    9 +
 drivers/infiniband/core/cm.c                          |    2 
 drivers/infiniband/hw/bnxt_re/ib_verbs.c              |    1 
 drivers/infiniband/hw/cxgb4/cq.c                      |    3 
 drivers/infiniband/hw/mthca/mthca_cq.c                |    2 
 drivers/infiniband/hw/mthca/mthca_dev.h               |    1 
 drivers/infiniband/sw/rxe/rxe_req.c                   |    3 
 drivers/input/keyboard/cros_ec_keyb.c                 |    1 
 drivers/input/keyboard/omap4-keypad.c                 |   89 +++++++-----
 drivers/input/misc/cm109.c                            |    7 -
 drivers/input/mouse/cyapa_gen6.c                      |    2 
 drivers/input/serio/i8042-x86ia64io.h                 |   42 ++++++
 drivers/input/touchscreen/ads7846.c                   |   52 ++++---
 drivers/input/touchscreen/goodix.c                    |   12 +
 drivers/irqchip/irq-alpine-msi.c                      |    3 
 drivers/md/dm-ioctl.c                                 |    1 
 drivers/md/dm-table.c                                 |    6 
 drivers/md/md-cluster.c                               |   67 +++++----
 drivers/md/md.c                                       |   13 +
 drivers/media/common/siano/smsdvb-main.c              |    5 
 drivers/media/i2c/max2175.c                           |    2 
 drivers/media/pci/netup_unidvb/netup_unidvb_spi.c     |    5 
 drivers/media/pci/saa7146/mxb.c                       |   19 +-
 drivers/media/pci/solo6x10/solo6x10-g723.c            |    2 
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c |    1 
 drivers/media/rc/sunxi-cir.c                          |    2 
 drivers/media/usb/gspca/gspca.c                       |    1 
 drivers/media/usb/msi2500/msi2500.c                   |    2 
 drivers/memstick/core/memstick.c                      |    1 
 drivers/memstick/host/r592.c                          |   12 +
 drivers/mtd/cmdlinepart.c                             |   14 +-
 drivers/net/can/softing/softing_main.c                |    9 +
 drivers/net/ethernet/allwinner/sun4i-emac.c           |    7 -
 drivers/net/ethernet/broadcom/genet/bcmgenet.c        |    4 
 drivers/net/ethernet/korina.c                         |    2 
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c        |   21 ++-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c            |   40 ++++-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h          |   12 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c        |    6 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c      |    1 
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c   |    6 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c     |   27 +++
 drivers/net/vxlan.c                                   |    3 
 drivers/net/wireless/ath/ath10k/usb.c                 |    7 -
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c     |    2 
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c       |   36 +++--
 drivers/net/wireless/intersil/orinoco/orinoco_usb.c   |   14 +-
 drivers/net/wireless/marvell/mwifiex/main.c           |    2 
 drivers/net/wireless/st/cw1200/main.c                 |    2 
 drivers/net/xen-netback/xenbus.c                      |    6 
 drivers/nfc/s3fwrn5/firmware.c                        |    4 
 drivers/nvdimm/label.c                                |    9 +
 drivers/pci/dwc/pcie-qcom.c                           |   12 +
 drivers/pci/host/pcie-iproc.c                         |   10 -
 drivers/pci/pci-acpi.c                                |    4 
 drivers/pci/slot.c                                    |    6 
 drivers/pinctrl/intel/pinctrl-baytrail.c              |    8 +
 drivers/pinctrl/intel/pinctrl-merrifield.c            |    8 +
 drivers/pinctrl/pinctrl-amd.c                         |    7 -
 drivers/pinctrl/pinctrl-falcon.c                      |   14 +-
 drivers/platform/x86/acer-wmi.c                       |    1 
 drivers/power/supply/bq24190_charger.c                |   20 ++
 drivers/ps3/ps3stor_lib.c                             |    2 
 drivers/pwm/pwm-lp3943.c                              |    1 
 drivers/pwm/pwm-zx.c                                  |    1 
 drivers/s390/block/dasd_alias.c                       |   12 +
 drivers/scsi/be2iscsi/be_main.c                       |    4 
 drivers/scsi/bnx2i/Kconfig                            |    1 
 drivers/scsi/fnic/fnic_main.c                         |    1 
 drivers/scsi/mpt3sas/mpt3sas_base.c                   |    2 
 drivers/scsi/pm8001/pm8001_init.c                     |    3 
 drivers/scsi/qedi/qedi_main.c                         |    4 
 drivers/scsi/scsi_lib.c                               |  126 ++++++++++++------
 drivers/scsi/ufs/ufshcd.c                             |    7 +
 drivers/soc/mediatek/mtk-scpsys.c                     |    5 
 drivers/soc/qcom/smp2p.c                              |    5 
 drivers/soc/tegra/fuse/speedo-tegra210.c              |    2 
 drivers/soc/ti/knav_dma.c                             |   13 +
 drivers/soc/ti/knav_qmss_queue.c                      |    4 
 drivers/spi/spi-bcm2835aux.c                          |   17 --
 drivers/spi/spi-davinci.c                             |    2 
 drivers/spi/spi-img-spfi.c                            |    4 
 drivers/spi/spi-pic32.c                               |    1 
 drivers/spi/spi-rb4xx.c                               |    2 
 drivers/spi/spi-sc18is602.c                           |   13 -
 drivers/spi/spi-sh.c                                  |   13 -
 drivers/spi/spi-st-ssc4.c                             |    5 
 drivers/spi/spi-tegra114.c                            |    2 
 drivers/spi/spi-tegra20-sflash.c                      |    1 
 drivers/spi/spi-tegra20-slink.c                       |    2 
 drivers/spi/spi-ti-qspi.c                             |    1 
 drivers/staging/comedi/drivers/mf6x4.c                |    3 
 drivers/staging/fsl-mc/bus/dpio/dpio-driver.c         |    5 
 drivers/staging/greybus/audio_codec.c                 |    2 
 drivers/staging/speakup/speakup_dectlk.c              |    2 
 drivers/tty/serial/8250/8250_omap.c                   |    5 
 drivers/tty/serial/serial_core.c                      |    4 
 drivers/usb/chipidea/ci_hdrc_imx.c                    |    3 
 drivers/usb/core/quirks.c                             |    3 
 drivers/usb/gadget/function/f_acm.c                   |    2 
 drivers/usb/gadget/function/f_fs.c                    |    5 
 drivers/usb/gadget/function/f_midi.c                  |    6 
 drivers/usb/gadget/function/f_rndis.c                 |    4 
 drivers/usb/gadget/udc/dummy_hcd.c                    |    2 
 drivers/usb/host/ehci-omap.c                          |    1 
 drivers/usb/host/oxu210hp-hcd.c                       |    4 
 drivers/usb/host/xhci-hub.c                           |    4 
 drivers/usb/misc/sisusbvga/Kconfig                    |    2 
 drivers/usb/serial/keyspan_pda.c                      |   63 ++++-----
 drivers/usb/serial/mos7720.c                          |    2 
 drivers/usb/serial/option.c                           |   23 +++
 drivers/usb/storage/uas.c                             |    3 
 drivers/usb/storage/unusual_uas.h                     |    7 -
 drivers/usb/storage/usb.c                             |    3 
 drivers/vfio/pci/vfio_pci.c                           |    4 
 drivers/watchdog/Kconfig                              |    3 
 drivers/watchdog/qcom-wdt.c                           |    2 
 drivers/xen/xen-pciback/xenbus.c                      |    2 
 drivers/xen/xenbus/xenbus.h                           |    2 
 drivers/xen/xenbus/xenbus_client.c                    |    8 +
 drivers/xen/xenbus/xenbus_probe.c                     |    1 
 drivers/xen/xenbus/xenbus_probe_backend.c             |    7 +
 drivers/xen/xenbus/xenbus_xs.c                        |   34 +++-
 fs/btrfs/inode.c                                      |    2 
 fs/btrfs/tests/btrfs-tests.c                          |    8 +
 fs/ceph/caps.c                                        |   11 +
 fs/ext4/inode.c                                       |   19 ++
 fs/ext4/mballoc.c                                     |    1 
 fs/jffs2/readinode.c                                  |   16 ++
 fs/jfs/jfs_dmap.h                                     |    2 
 fs/lockd/host.c                                       |   20 +-
 fs/nfs/inode.c                                        |    2 
 fs/nfs/nfs4proc.c                                     |   10 +
 fs/nfs_common/grace.c                                 |    6 
 fs/nfsd/nfssvc.c                                      |    3 
 fs/quota/quota_v2.c                                   |   19 ++
 include/acpi/acpi_bus.h                               |    5 
 include/linux/build_bug.h                             |    5 
 include/linux/security.h                              |    2 
 include/linux/seq_buf.h                               |    2 
 include/linux/sunrpc/xprt.h                           |    1 
 include/linux/trace_seq.h                             |    4 
 include/linux/usb_usual.h                             |    2 
 include/uapi/linux/if_alg.h                           |   16 ++
 include/xen/xenbus.h                                  |   15 ++
 kernel/cpu.c                                          |    6 
 kernel/irq/irqdomain.c                                |   11 +
 kernel/sched/core.c                                   |    6 
 kernel/sched/deadline.c                               |    5 
 kernel/sched/sched.h                                  |   42 ++----
 net/bluetooth/hci_event.c                             |   17 +-
 net/bridge/br_vlan.c                                  |    4 
 net/ipv4/tcp_output.c                                 |    9 -
 net/mac80211/mesh_pathtbl.c                           |    4 
 net/sunrpc/xprt.c                                     |   65 +++++++--
 net/sunrpc/xprtrdma/module.c                          |    1 
 net/sunrpc/xprtrdma/transport.c                       |    1 
 net/sunrpc/xprtsock.c                                 |    4 
 net/wireless/nl80211.c                                |    2 
 samples/bpf/lwt_len_hist.sh                           |    2 
 scripts/checkpatch.pl                                 |    2 
 security/integrity/ima/ima_crypto.c                   |   20 --
 security/selinux/hooks.c                              |   16 +-
 sound/core/oss/pcm_oss.c                              |   28 ++--
 sound/pci/hda/patch_realtek.c                         |    1 
 sound/soc/codecs/wm8997.c                             |    2 
 sound/soc/codecs/wm8998.c                             |    4 
 sound/soc/codecs/wm_adsp.c                            |    5 
 sound/soc/jz4740/jz4740-i2s.c                         |    4 
 sound/soc/soc-pcm.c                                   |    2 
 sound/usb/clock.c                                     |    6 
 sound/usb/format.c                                    |    2 
 sound/usb/stream.c                                    |    6 
 tools/perf/util/parse-regs-options.c                  |    2 
 243 files changed, 1447 insertions(+), 672 deletions(-)

Alan Stern (1):
      media: gspca: Fix memory leak in probe

Alexander Sverdlin (1):
      serial: 8250_omap: Avoid FIFO corruption caused by MDR1 access

Alexandre Belloni (1):
      ARM: dts: at91: at91sam9rl: fix ADC triggers

Alexey Kardashevskiy (1):
      serial_core: Check for port state when tty is in error state

Andy Shevchenko (2):
      pinctrl: merrifield: Set default bias in case no particular value given
      pinctrl: baytrail: Avoid clearing debounce value when turning it off

Anmol Karn (1):
      Bluetooth: Fix null pointer dereference in hci_event_packet()

Ansuel Smith (1):
      PCI: qcom: Add missing reset for ipq806x

Anton Ivanov (1):
      um: chan_xterm: Fix fd leak

Antti Palosaari (1):
      media: msi2500: assign SPI bus number dynamically

Ard Biesheuvel (2):
      ARM: p2v: fix handling of LPAE translation in BE mode
      crypto: ecdh - avoid unaligned accesses in ecdh_set_secret()

Arnd Bergmann (5):
      kbuild: avoid static_assert for genksyms
      RDMa/mthca: Work around -Wenum-conversion warning
      seq_buf: Avoid type mismatch for seq_buf_init
      watchdog: coh901327: add COMMON_CLK dependency
      Input: cyapa_gen6 - fix out-of-bounds stack access

Arvind Sankar (2):
      x86/mm/mem_encrypt: Fix definition of PMD_FLAGS_DEC_WP
      x86/mm/ident_map: Check for errors from ident_pud_init()

Athira Rajeev (1):
      powerpc/perf: Exclude kernel samples while counting events in user space.

Baruch Siach (1):
      gpio: mvebu: fix potential user-after-free on probe

Bharat Gooty (1):
      PCI: iproc: Fix out-of-bound array accesses

Bob Pearson (1):
      RDMA/rxe: Compute PSN windows correctly

Bongsu Jeon (1):
      nfc: s3fwrn5: Release the nfc firmware

Borislav Petkov (1):
      EDAC/amd64: Fix PCI component registration

Bui Quang Minh (1):
      USB: dummy-hcd: Fix uninitialized array use in init()

Calum Mackay (1):
      lockd: don't use interval-based rebinding over TCP

Can Guo (1):
      scsi: ufs: Make sure clk scaling happens only when HBA is runtime ACTIVE

Cezary Rojewski (1):
      ASoC: pcm: DRAIN support reactivation

Chen-Yu Tsai (1):
      arm64: dts: rockchip: Fix UART pull-ups on rk3328

Cheng Lin (1):
      nfs_common: need lock during iterate through the list

Chris Chiu (2):
      Input: i8042 - add Acer laptops to the i8042 reset list
      ALSA: hda/realtek - Enable headset mic of ASUS Q524UQK with ALC255

Chris Packham (1):
      ARM: dts: Remove non-existent i2c1 from 98dx3236

Christophe JAILLET (5):
      ath10k: Fix an error handling path
      ath10k: Release some resources in an error handling path
      net: bcmgenet: Fix a resource leak in an error handling path in the probe functin
      net: allwinner: Fix some resources leak in the error handling path of the probe and in the remove function
      clk: s2mps11: Fix a resource leak in error handling paths in the probe function

Christophe Leroy (3):
      crypto: talitos - Fix return type of current_desc_hdr()
      powerpc/feature: Fix CPU_FTRS_ALWAYS by removing CPU_FTRS_GENERIC_32
      powerpc/xmon: Change printk() to pr_cont()

Chuhong Yuan (1):
      ASoC: jz4740-i2s: add missed checks for clk_get()

Chunguang Xu (1):
      ext4: fix a memory leak of ext4_free_data

Claudiu Beznea (1):
      ARM: dts: at91: sama5d2: map securam as device

Coiby Xu (1):
      pinctrl: amd: remove debounce filter setting in IRQ type setting

Cristian Birsan (2):
      ARM: dts: at91: sama5d4_xplained: add pincontrol for USB Host
      ARM: dts: at91: sama5d3_xplained: add pincontrol for USB Host

Dae R. Jeong (1):
      md: fix a warning caused by a race between concurrent md_ioctl()s

Dan Carpenter (6):
      scsi: be2iscsi: Revert "Fix a theoretical leak in beiscsi_create_eqs()"
      soc: renesas: rmobile-sysc: Fix some leaks in rmobile_init_pm_domains()
      media: max2175: fix max2175_set_csm_mode() error code
      media: saa7146: fix array overflow in vidioc_s_audio()
      ASoC: wm_adsp: remove "ctl" from list on error in wm_adsp_create_control()
      qlcnic: Fix error code in probe

Dan Williams (1):
      libnvdimm/namespace: Fix reaping of invalidated block-window-namespace labels

Daniel Scally (1):
      Revert "ACPI / resources: Use AE_CTRL_TERMINATE to terminate resources walks"

Daniel T. Lee (1):
      samples: bpf: Fix lwt_len_hist reusing previous BPF map

Dave Kleikamp (1):
      jfs: Fix array index bounds check in dbAdjTree

David Hildenbrand (1):
      powerpc/powernv/memtrace: Don't leak kernel memory to user space

David Jander (1):
      Input: ads7846 - fix race that causes missing releases

Dmitry Osipenko (1):
      clk: tegra: Fix duplicated SE clock entry

Dmitry Torokhov (3):
      Input: cm109 - do not stomp on control URB
      Input: ads7846 - fix unaligned access on 7845
      Input: cros_ec_keyb - send 'scancodes' in addition to key events

Dwaipayan Ray (1):
      checkpatch: fix unescaped left brace

Eric Biggers (1):
      crypto: af_alg - avoid undefined behavior accessing salg_name

Eric Dumazet (1):
      mac80211: mesh: fix mesh_pathtbl_init() error path

Evan Green (1):
      soc: qcom: smp2p: Safely acquire spinlock without IRQs

Fabio Estevam (1):
      usb: chipidea: ci_hdrc_imx: Pass DISABLE_DEVICE_STREAMING flag to imx6ul

Filipe Manana (1):
      Btrfs: fix selftests failure due to uninitialized i_mode in test inodes

Fugang Duan (2):
      net: stmmac: free tx skb buffer in stmmac_resume()
      net: stmmac: delete the eee_ctrl_timer after napi disabled

Greg Kroah-Hartman (1):
      Linux 4.14.213

Guenter Roeck (1):
      watchdog: sirfsoc: Add missing dependency on HAS_IOMEM

Hao Si (1):
      soc: fsl: dpio: Get the cpumask through cpumask_of(cpu)

Hui Wang (1):
      ACPI: PNP: compare the string length in the matching_id()

Ian Abbott (1):
      staging: comedi: mf6x4: Fix AI end-of-conversion detection

Icenowy Zheng (1):
      ARM: dts: sun8i: v3s: fix GIC node memory range

Jack Pham (1):
      usb: gadget: f_fs: Re-use SS descriptors for SuperSpeedPlus

Jan Kara (2):
      quota: Sanity-check quota file headers on load
      ext4: fix deadlock with fs freezing and EA inodes

Jason Gunthorpe (1):
      vfio-pci: Use io_remap_pfn_range() for PCI IO memory

Jernej Skrabec (1):
      clk: sunxi-ng: Make sure divider tables have sentinel

Jing Xiangfeng (2):
      HSI: omap_ssi: Don't jump to free ID in ssi_add_controller()
      memstick: r592: Fix error return in r592_probe()

Johan Hovold (8):
      USB: serial: option: add interface-number sanity check to flag handling
      USB: serial: mos7720: fix parallel-port state restore
      USB: serial: keyspan_pda: fix dropped unthrottle interrupts
      USB: serial: keyspan_pda: fix write deadlock
      USB: serial: keyspan_pda: fix stalled writes
      USB: serial: keyspan_pda: fix write-wakeup use-after-free
      USB: serial: keyspan_pda: fix tx-unthrottle use-after-free
      USB: serial: keyspan_pda: fix write unthrottling

Johannes Berg (1):
      iwlwifi: pcie: limit memory read spin time

Jonathan Cameron (3):
      iio:light:rpr0521: Fix timestamp alignment and prevent data leak.
      iio:pressure:mpl3115: Force alignment of buffer
      iio:imu:bmi160: Fix too large a buffer.

Jubin Zhong (1):
      PCI: Fix pci_slot_release() NULL pointer dereference

Julian Sax (1):
      HID: i2c-hid: add Vero K147 to descriptor override

Kamal Heib (2):
      RDMA/bnxt_re: Set queue pair state when being queried
      RDMA/cxgb4: Validate the number of CQEs

Keita Suzuki (1):
      media: siano: fix memory leak of debugfs members in smsdvb_hotplug

Keqian Zhu (1):
      clocksource/drivers/arm_arch_timer: Correct fault programming of CNTKCTL_EL1.EVNTI

Krzysztof Kozlowski (3):
      ARM: dts: exynos: fix roles of USB 3.0 ports on Odroid XU
      ARM: dts: exynos: fix USB 3.0 VBUS control and over-current pins on Exynos5410
      ARM: dts: exynos: fix USB 3.0 pins supply being turned off on Odroid XU

Leon Romanovsky (2):
      RDMA/cm: Fix an attempt to use non-valid pointer when cleaning timewait
      net/mlx5: Properly convey driver version to firmware

Li Jun (1):
      xhci: Give USB2 ports time to enter U3 in bus suspend

Lokesh Vutla (1):
      pwm: lp3943: Dynamically allocate PWM chip base

Luis Henriques (1):
      ceph: fix race in concurrent __ceph_remove_cap invocations

Lukas Wunner (8):
      spi: bcm2835aux: Fix use-after-free on unbind
      media: netup_unidvb: Don't leak SPI master in probe error path
      spi: spi-sh: Fix use-after-free on unbind
      spi: davinci: Fix use-after-free on unbind
      spi: pic32: Don't leak DMA channels in probe error path
      spi: rb4xx: Don't leak SPI master in probe error path
      spi: sc18is602: Don't leak SPI master in probe error path
      spi: st-ssc4: Fix unbalanced pm_runtime_disable() in probe error path

Manivannan Sadhasivam (1):
      watchdog: qcom: Avoid context switch in restart handler

Marc Zyngier (3):
      genirq/irqdomain: Don't try to free an interrupt that has no mapping
      irqchip/alpine-msi: Fix freeing of interrupts on allocation error path
      KVM: arm64: Introduce handling of AArch32 TTBCR2 traps

Marek Szyprowski (1):
      extcon: max77693: Fix modalias string

Markus Reichl (1):
      arm64: dts: rockchip: Assign a fixed index to mmc devices on rk3399 boards.

Martin Blumenstingl (1):
      net: stmmac: dwmac-meson8b: fix mask definition of the m250_sel mux

Martin Wilck (1):
      scsi: core: Fix VPD LUN ID designator priorities

Masami Hiramatsu (1):
      x86/kprobes: Restore BTF if the single-stepping is cancelled

Moshe Shemesh (2):
      net/mlx4_en: Avoid scheduling restart task if it is already running
      net/mlx4_en: Handle TX error CQE

Nathan Chancellor (1):
      spi: bcm2835aux: Restore err assignment in bcm2835aux_spi_probe

Nathan Lynch (2):
      powerpc/pseries/hibernation: drop pseries_suspend_begin() from suspend ops
      powerpc/pseries/hibernation: remove redundant cacheinfo update

Neal Cardwell (1):
      tcp: fix cwnd-limited bug for TSO deferral where we send nothing

Necip Fazil Yildiran (1):
      MIPS: BCM47XX: fix kconfig dependency bug for BCM47XX_BCMA

NeilBrown (1):
      NFS: switch nfsiod to be an UNBOUND workqueue.

Nicholas Piggin (1):
      kernel/cpu: add arch override for clear_tasks_mm_cpumask() mm handling

Nicolas Boichat (1):
      soc: mediatek: Check if power domains can be powered on at boot time

Nicolas Ferre (1):
      ARM: dts: at91: sama5d2: fix CAN message ram offset and size

Nicolin Chen (1):
      soc/tegra: fuse: Fix index bug in get_process_id

Nuno Sá (1):
      iio: buffer: Fix demux update

Oleksij Rempel (1):
      Input: ads7846 - fix integer overflow on Rt calculation

Olga Kornievskaia (1):
      NFSv4.2: condition READDIR's mask for security label based on LSM state

Oliver Neukum (2):
      USB: add RESET_RESUME quirk for Snapscan 1212
      USB: UAS: introduce a quirk to set no_write_same

Pali Rohár (5):
      cpufreq: highbank: Add missing MODULE_DEVICE_TABLE
      cpufreq: mediatek: Add missing MODULE_DEVICE_TABLE
      cpufreq: st: Add missing MODULE_DEVICE_TABLE
      cpufreq: loongson1: Add missing MODULE_ALIAS
      cpufreq: scpi: Add missing MODULE_ALIAS

Paul Moore (1):
      selinux: fix inode_doinit_with_dentry() LABEL_INVALID error handling

Pavel Machek (1):
      btrfs: fix return value mixup in btrfs_get_extent

Pawel Wieczorkiewicz (1):
      xen-blkback: set ring->xenblkd to NULL after kthread_stop()

Paweł Chmiel (1):
      arm64: dts: exynos: Correct psci compatible used on Exynos7

Peilin Ye (1):
      Bluetooth: Fix slab-out-of-bounds read in hci_le_direct_adv_report_evt()

Peng Liu (1):
      sched/deadline: Fix sched_dl_global_validate()

Qinglang Miao (8):
      drm/tegra: sor: Disable clocks on error in tegra_sor_init()
      media: solo6x10: fix missing snd_card_free in error handling case
      memstick: fix a double-free bug in memstick_check
      cw1200: fix missing destroy_workqueue() on error in cw1200_init_common
      mips: cdmm: fix use-after-free in mips_cdmm_bus_discover
      dm ioctl: fix error return code in target_message
      scsi: qedi: Fix missing destroy_workqueue() on error in __qedi_probe
      iio: adc: rockchip_saradc: fix missing clk_disable_unprepare() on error in rockchip_saradc_resume

Rafael J. Wysocki (1):
      PM: ACPI: PCI: Drop acpi_pm_set_bridge_wakeup()

Randy Dunlap (1):
      scsi: bnx2i: Requires MMU

Roberto Sassu (1):
      ima: Don't modify file descriptor mode on the fly

Sara Sharon (2):
      iwlwifi: mvm: fix kernel panic in case of assert during CSA
      cfg80211: initialize rekey_data

Sean Young (1):
      media: sunxi-cir: ensure IR is handled when it is continuous

Sebastian Andrzej Siewior (1):
      orinoco: Move context allocation after processing the skb

SeongJae Park (5):
      xen/xenbus: Allow watches discard events before queueing
      xen/xenbus: Add 'will_handle' callback support in xenbus_watch_path()
      xen/xenbus/xen_bus_type: Support will_handle watch callback
      xen/xenbus: Count pending messages for each watch
      xenbus/xenbus_backend: Disallow pending watch messages

Serge Hallyn (1):
      fix namespaced fscaps when !CONFIG_SECURITY

Simon Beginn (1):
      Input: goodix - add upside-down quirk for Teclast X98 Pro tablet

Sreekanth Reddy (1):
      scsi: mpt3sas: Increase IOCInit request timeout to 30s

Stefan Haberland (3):
      s390/dasd: prevent inconsistent LCU device data
      s390/dasd: fix list corruption of pavgroup group list
      s390/dasd: fix list corruption of lcu list

Sven Eckelmann (3):
      vxlan: Add needed_headroom for lower device
      vxlan: Copy needed_tailroom from lowerdev
      mtd: parser: cmdline: Fix parsing of part-names with colons

Sven Schnelle (1):
      s390/smp: perform initial CPU reset also for SMT siblings

Takashi Iwai (5):
      ALSA: usb-audio: Fix potential out-of-bounds shift
      ALSA: usb-audio: Fix control 'access overflow' errors from chmap
      ALSA: pcm: oss: Fix potential out-of-bounds shift
      ALSA: pcm: oss: Fix a few more UBSAN fixes
      ALSA: usb-audio: Disable sample read check if firmware doesn't give back

Terry Zhou (1):
      clk: mvebu: a3700: fix the XTAL MODE pin to MPP1_9

Thomas Gleixner (3):
      USB: sisusbvga: Make console support depend on BROKEN
      dm table: Remove BUG_ON(in_interrupt())
      sched: Reenable interrupts in do_sched_yield()

Tianyue Ren (1):
      selinux: fix error initialization in inode_doinit_with_dentry()

Timo Witte (1):
      platform/x86: acer-wmi: add automatic keyboard background light toggle key as KEY_LIGHTS_TOGGLE

Tom Rix (1):
      drm/gma500: fix double free of gma_connector

Trond Myklebust (1):
      SUNRPC: xprt_load_transport() needs to support the netid "rdma6"

Tsuchiya Yuto (1):
      mwifiex: fix mwifiex_shutdown_sw() causing sw reset failure

Tyrel Datwyler (1):
      powerpc/rtas: Fix typo of ibm,open-errinjct in RTAS filter

Uwe Kleine-König (1):
      pwm: zx: Add missing cleanup in error path

Vincent Stehlé (2):
      powerpc/ps3: use dma_mapping_error()
      net: korina: fix return value

Vineet Gupta (1):
      ARC: stack unwinding: don't assume non-current task is sleeping

Will McVicker (2):
      USB: gadget: f_midi: setup SuperSpeed Plus descriptors
      USB: gadget: f_rndis: fix bitrate for SuperSpeed and above

Xin Xiong (1):
      drm: fix drm_dp_mst_port refcount leaks in drm_dp_mst_allocate_vcpi

Yang Yingliang (2):
      drm/omap: dmm_tiler: fix return error code in omap_dmm_probe()
      speakup: fix uninitialized flush_lock

Yu Kuai (3):
      media: mtk-vcodec: add missing put_device() call in mtk_vcodec_release_dec_pm()
      clocksource/drivers/cadence_ttc: Fix memory leak in ttc_setup_clockevent()
      pinctrl: falcon: add missing put_device() call in pinctrl_falcon_probe()

Zhang Changzhong (2):
      net: bridge: vlan: fix error return code in __vlan_add()
      scsi: fnic: Fix error return code in fnic_probe()

Zhang Qilong (18):
      can: softing: softing_netdev_open(): fix error handling
      spi: img-spfi: fix reference leak in img_spfi_resume
      spi: spi-ti-qspi: fix reference leak in ti_qspi_setup
      spi: tegra20-slink: fix reference leak in slink ops of tegra20
      spi: tegra20-sflash: fix reference leak in tegra_sflash_resume
      spi: tegra114: fix reference leak in tegra spi ops
      ASoC: wm8998: Fix PM disable depth imbalance on error
      ASoC: arizona: Fix a wrong free in wm8997_probe
      staging: greybus: codecs: Fix reference counter leak in error handling
      crypto: omap-aes - Fix PM disable depth imbalance in omap_aes_probe
      soc: ti: knav_qmss: fix reference leak in knav_queue_probe
      soc: ti: Fix reference imbalance in knav_dma_probe
      Input: omap4-keypad - fix runtime PM error handling
      power: supply: bq24190_charger: fix reference leak
      scsi: pm80xx: Fix error return in pm8001_pci_probe()
      usb: ehci-omap: Fix PM disable depth umbalance in ehci_hcd_omap_probe
      usb: oxu210hp-hcd: Fix memory leak in oxu_create
      clk: ti: Fix memleak in ti_fapll_synth_setup

Zhao Heming (1):
      md/cluster: fix deadlock when node is doing resync job

Zhe Li (1):
      jffs2: Fix GC exit abnormally

Zheng Zengkai (1):
      perf record: Fix memory leak when using '--user-regs=?' to list registers

Zhihao Cheng (1):
      drivers: soc: ti: knav_qmss_queue: Fix error return code in knav_queue_probe

Zwane Mwaikambo (1):
      drm/dp_aux_dev: check aux_dev before use in drm_dp_aux_dev_get_by_minor()

kazuo ito (1):
      nfsd: Fix message level for normal termination

taehyun.cho (1):
      USB: gadget: f_acm: add support for SuperSpeed Plus

