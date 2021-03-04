Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 698EB32CF75
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 10:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235914AbhCDJRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 04:17:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:41124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234847AbhCDJQx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 04:16:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 348C764EED;
        Thu,  4 Mar 2021 09:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614849373;
        bh=1yuFPgozyw3o0uBaPATCCEDRvDqUL/23O2kVeNQhAP8=;
        h=From:To:Cc:Subject:Date:From;
        b=uDrEoYctCpVufqvtgrLt1BUOpvhWzJ2z8l2WF+FuGuWLgysWzeimZ24+2+vqOBcA4
         rq66w/oCKawwfbKakHPsa9q5GfDyyoEZJplvyxUjIQPR4dWZJ46yF/i7R0Fp/e0BUX
         YBCC7G9oDjpl5UWegDuLZhWBno0wZTaAyIxPwKMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.178
Date:   Thu,  4 Mar 2021 10:16:09 +0100
Message-Id: <1614849369155173@kroah.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.178 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/filesystems/seq_file.txt                |    6 
 Makefile                                              |    2 
 arch/arm/boot/compressed/head.S                       |    4 
 arch/arm/boot/dts/armada-388-helios4.dts              |   28 
 arch/arm/boot/dts/aspeed-g4.dtsi                      |    1 
 arch/arm/boot/dts/aspeed-g5.dtsi                      |    1 
 arch/arm/boot/dts/exynos3250-artik5.dtsi              |    2 
 arch/arm/boot/dts/exynos3250-monk.dts                 |    2 
 arch/arm/boot/dts/exynos3250-rinato.dts               |    2 
 arch/arm/boot/dts/exynos5250-spring.dts               |    2 
 arch/arm/boot/dts/exynos5420-arndale-octa.dts         |    2 
 arch/arm/boot/dts/exynos5422-odroid-core.dtsi         |    2 
 arch/arm/boot/dts/omap443x.dtsi                       |    2 
 arch/arm64/Kconfig                                    |    2 
 arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts |    5 
 arch/arm64/boot/dts/allwinner/sun50i-a64-sopine.dtsi  |    1 
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi         |    6 
 arch/arm64/boot/dts/exynos/exynos5433-tm2-common.dtsi |    2 
 arch/arm64/boot/dts/exynos/exynos7-espresso.dts       |    2 
 arch/arm64/boot/dts/mediatek/mt7622.dtsi              |    2 
 arch/arm64/boot/dts/nvidia/tegra210.dtsi              |    1 
 arch/arm64/boot/dts/qcom/msm8916.dtsi                 |    4 
 arch/arm64/crypto/sha1-ce-glue.c                      |    1 
 arch/arm64/crypto/sha2-ce-glue.c                      |    2 
 arch/arm64/crypto/sha3-ce-glue.c                      |    4 
 arch/arm64/crypto/sha512-ce-glue.c                    |    2 
 arch/arm64/kernel/cpufeature.c                        |    2 
 arch/arm64/kernel/head.S                              |    1 
 arch/arm64/kernel/probes/uprobes.c                    |    2 
 arch/mips/kernel/vmlinux.lds.S                        |    1 
 arch/mips/lantiq/irq.c                                |    2 
 arch/mips/mm/c-r4k.c                                  |    2 
 arch/powerpc/Kconfig                                  |    2 
 arch/powerpc/kernel/head_8xx.S                        |    2 
 arch/powerpc/kvm/powerpc.c                            |    8 
 arch/powerpc/platforms/pseries/dlpar.c                |    7 
 arch/sparc/Kconfig                                    |    2 
 arch/sparc/lib/memset.S                               |    1 
 arch/x86/kernel/reboot.c                              |   29 
 arch/x86/mm/pat.c                                     |    3 
 block/bfq-iosched.c                                   |    1 
 block/blk-core.c                                      |    1 
 block/blk-mq-sysfs.c                                  |   12 
 block/blk-settings.c                                  |   12 
 block/blk-sysfs.c                                     |   49 -
 block/blk-wbt.c                                       |    2 
 block/blk.h                                           |    2 
 block/elevator.c                                      |   30 
 certs/blacklist.c                                     |    2 
 crypto/ecdh_helper.c                                  |    3 
 drivers/acpi/acpi_configfs.c                          |    7 
 drivers/acpi/property.c                               |   44 -
 drivers/amba/bus.c                                    |   20 
 drivers/ata/ahci_brcm.c                               |   14 
 drivers/auxdisplay/ht16k33.c                          |    3 
 drivers/base/regmap/regmap-sdw.c                      |    4 
 drivers/block/floppy.c                                |   27 
 drivers/bluetooth/btqcomsmd.c                         |   27 
 drivers/char/hw_random/timeriomem-rng.c               |    2 
 drivers/char/random.c                                 |    2 
 drivers/char/tpm/tpm_tis_core.c                       |   50 -
 drivers/clk/meson/clk-pll.c                           |    2 
 drivers/clk/qcom/gcc-msm8998.c                        |  100 +-
 drivers/clk/sunxi-ng/ccu-sun50i-h6.c                  |   10 
 drivers/clocksource/mxs_timer.c                       |    5 
 drivers/cpufreq/brcmstb-avs-cpufreq.c                 |   24 
 drivers/cpufreq/intel_pstate.c                        |    5 
 drivers/crypto/bcm/cipher.c                           |    2 
 drivers/crypto/bcm/cipher.h                           |    4 
 drivers/crypto/bcm/util.c                             |    2 
 drivers/crypto/chelsio/chtls/chtls_cm.h               |    3 
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c             |  125 +-
 drivers/crypto/talitos.c                              |   28 
 drivers/crypto/talitos.h                              |    1 
 drivers/dma/fsldma.c                                  |    6 
 drivers/dma/hsu/pci.c                                 |   21 
 drivers/dma/owl-dma.c                                 |    1 
 drivers/gpio/gpio-pcf857x.c                           |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c                |    6 
 drivers/gpu/drm/amd/amdgpu/amdgpu_trace.h             |    2 
 drivers/gpu/drm/amd/display/dc/dce/dce_transform.c    |    8 
 drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c            |   22 
 drivers/gpu/drm/gma500/psb_drv.c                      |    2 
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_20nm.c            |    2 
 drivers/hid/hid-core.c                                |    9 
 drivers/hid/wacom_wac.c                               |    7 
 drivers/hv/channel_mgmt.c                             |    3 
 drivers/i2c/busses/i2c-brcmstb.c                      |    2 
 drivers/infiniband/core/user_mad.c                    |   17 
 drivers/infiniband/hw/mlx5/devx.c                     |    4 
 drivers/infiniband/sw/rxe/rxe_net.c                   |    5 
 drivers/infiniband/sw/rxe/rxe_recv.c                  |   11 
 drivers/input/joydev.c                                |    7 
 drivers/input/joystick/xpad.c                         |    1 
 drivers/input/serio/i8042-x86ia64io.h                 |    4 
 drivers/input/touchscreen/elo.c                       |    4 
 drivers/input/touchscreen/raydium_i2c_ts.c            |    3 
 drivers/input/touchscreen/sur40.c                     |    1 
 drivers/md/dm-core.h                                  |    4 
 drivers/md/dm-crypt.c                                 |    1 
 drivers/md/dm-era-target.c                            |   93 +-
 drivers/md/dm.c                                       |   60 +
 drivers/media/i2c/ov5670.c                            |    3 
 drivers/media/pci/cx25821/cx25821-core.c              |    4 
 drivers/media/pci/intel/ipu3/ipu3-cio2.c              |    2 
 drivers/media/pci/saa7134/saa7134-empress.c           |    5 
 drivers/media/platform/pxa_camera.c                   |    3 
 drivers/media/platform/qcom/camss/camss-video.c       |    1 
 drivers/media/platform/vsp1/vsp1_drv.c                |    4 
 drivers/media/tuners/qm1d1c0042.c                     |    4 
 drivers/media/usb/dvb-usb-v2/lmedm04.c                |    2 
 drivers/media/usb/em28xx/em28xx-core.c                |    6 
 drivers/media/usb/tm6000/tm6000-dvb.c                 |    4 
 drivers/media/usb/uvc/uvc_v4l2.c                      |   18 
 drivers/memory/ti-aemif.c                             |    8 
 drivers/mfd/bd9571mwv.c                               |    6 
 drivers/mfd/wm831x-auxadc.c                           |    3 
 drivers/misc/aspeed-lpc-snoop.c                       |   30 
 drivers/misc/cardreader/rts5227.c                     |    5 
 drivers/misc/eeprom/eeprom_93xx46.c                   |    1 
 drivers/misc/vmw_vmci/vmci_queue_pair.c               |    5 
 drivers/mmc/host/renesas_sdhi_internal_dmac.c         |    4 
 drivers/mmc/host/sdhci-esdhc-imx.c                    |    3 
 drivers/mmc/host/usdhi6rol0.c                         |    4 
 drivers/mtd/spi-nor/cadence-quadspi.c                 |    2 
 drivers/mtd/spi-nor/hisi-sfc.c                        |    4 
 drivers/net/ethernet/amd/xgbe/xgbe-common.h           |   14 
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c              |    1 
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c             |    3 
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c           |   39 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c             |    3 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h        |    3 
 drivers/net/ethernet/chelsio/cxgb4/sge.c              |   11 
 drivers/net/ethernet/ibm/ibmvnic.c                    |   16 
 drivers/net/ethernet/intel/i40e/i40e_main.c           |   41 
 drivers/net/ethernet/intel/i40e/i40e_txrx.c           |    9 
 drivers/net/ethernet/marvell/mvneta.c                 |    9 
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c |    1 
 drivers/net/ethernet/realtek/r8169.c                  |    4 
 drivers/net/ethernet/sun/sunvnet_common.c             |   23 
 drivers/net/gtp.c                                     |    5 
 drivers/net/usb/qmi_wwan.c                            |    1 
 drivers/net/vxlan.c                                   |   11 
 drivers/net/wireless/ath/ath10k/snoc.c                |    5 
 drivers/net/wireless/ath/ath9k/debug.c                |    5 
 drivers/net/wireless/broadcom/b43/phy_n.c             |    2 
 drivers/net/xen-netback/interface.c                   |    8 
 drivers/nvdimm/dimm_devs.c                            |   18 
 drivers/of/fdt.c                                      |   12 
 drivers/pci/controller/dwc/pcie-qcom.c                |    4 
 drivers/pci/syscall.c                                 |   10 
 drivers/power/reset/at91-sama5d2_shdwc.c              |    2 
 drivers/pwm/pwm-rockchip.c                            |    1 
 drivers/regulator/axp20x-regulator.c                  |    7 
 drivers/regulator/s5m8767.c                           |    8 
 drivers/rtc/Kconfig                                   |    1 
 drivers/scsi/bnx2fc/Kconfig                           |    1 
 drivers/spi/spi-atmel.c                               |    2 
 drivers/spi/spi-pxa2xx-pci.c                          |   27 
 drivers/spi/spi-s3c24xx-fiq.S                         |    9 
 drivers/spi/spi-stm32.c                               |    4 
 drivers/staging/gdm724x/gdm_usb.c                     |   10 
 drivers/staging/mt7621-dma/Makefile                   |    2 
 drivers/staging/mt7621-dma/hsdma-mt7621.c             |  771 ++++++++++++++++++
 drivers/staging/mt7621-dma/mtk-hsdma.c                |  771 ------------------
 drivers/staging/rtl8188eu/os_dep/usb_intf.c           |    1 
 drivers/staging/rtl8723bs/os_dep/wifi_regd.c          |    2 
 drivers/target/iscsi/cxgbit/cxgbit_target.c           |    3 
 drivers/usb/core/quirks.c                             |    9 
 drivers/usb/dwc2/hcd.c                                |   15 
 drivers/usb/dwc2/hcd_intr.c                           |   14 
 drivers/usb/dwc3/gadget.c                             |   19 
 drivers/usb/gadget/function/u_audio.c                 |   17 
 drivers/usb/musb/musb_core.c                          |   31 
 drivers/usb/serial/ftdi_sio.c                         |    5 
 drivers/usb/serial/mos7720.c                          |    4 
 drivers/usb/serial/mos7840.c                          |    4 
 drivers/usb/serial/option.c                           |    3 
 drivers/video/fbdev/Kconfig                           |    2 
 drivers/watchdog/mei_wdt.c                            |    1 
 fs/affs/namei.c                                       |    4 
 fs/btrfs/ctree.c                                      |    7 
 fs/btrfs/free-space-cache.c                           |    6 
 fs/btrfs/relocation.c                                 |    4 
 fs/cifs/connect.c                                     |    1 
 fs/ext4/namei.c                                       |    7 
 fs/f2fs/file.c                                        |    7 
 fs/f2fs/inline.c                                      |    4 
 fs/gfs2/lock_dlm.c                                    |    8 
 fs/isofs/dir.c                                        |    1 
 fs/isofs/namei.c                                      |    1 
 fs/jffs2/summary.c                                    |    3 
 fs/jfs/jfs_dmap.c                                     |    2 
 fs/ntfs/inode.c                                       |    6 
 fs/ocfs2/cluster/heartbeat.c                          |    8 
 fs/pstore/platform.c                                  |    4 
 fs/quota/quota_v2.c                                   |   11 
 include/acpi/acexcep.h                                |   10 
 include/asm-generic/vmlinux.lds.h                     |    7 
 include/linux/blkdev.h                                |    2 
 include/linux/device-mapper.h                         |    5 
 include/linux/filter.h                                |    2 
 include/linux/icmpv6.h                                |   48 +
 include/linux/ipv6.h                                  |    2 
 include/linux/kexec.h                                 |    5 
 include/linux/key.h                                   |    1 
 include/linux/rmap.h                                  |    3 
 include/net/icmp.h                                    |   10 
 include/net/tcp.h                                     |    9 
 kernel/bpf/bpf_lru_list.c                             |    7 
 kernel/debug/kdb/kdb_private.h                        |    2 
 kernel/jump_label.c                                   |   26 
 kernel/kexec_file.c                                   |    5 
 kernel/module.c                                       |   21 
 kernel/printk/printk_safe.c                           |   16 
 kernel/seccomp.c                                      |    2 
 kernel/tracepoint.c                                   |   80 +
 mm/hugetlb.c                                          |    4 
 mm/memory.c                                           |   16 
 net/bluetooth/a2mp.c                                  |    3 
 net/bluetooth/hci_core.c                              |    6 
 net/core/filter.c                                     |   13 
 net/ipv4/icmp.c                                       |   34 
 net/ipv6/icmp.c                                       |   19 
 net/ipv6/ip6_icmp.c                                   |   46 -
 net/mac80211/mesh_hwmp.c                              |    2 
 net/qrtr/tun.c                                        |   12 
 net/xfrm/xfrm_interface.c                             |    6 
 scripts/Makefile                                      |    9 
 scripts/recordmcount.pl                               |    6 
 security/commoncap.c                                  |   12 
 security/integrity/ima/ima_kexec.c                    |    3 
 security/integrity/ima/ima_mok.c                      |    5 
 security/keys/key.c                                   |    2 
 security/keys/trusted.c                               |    2 
 sound/pci/hda/patch_realtek.c                         |   11 
 sound/soc/codecs/cpcap.c                              |   12 
 sound/soc/codecs/cs42l56.c                            |    3 
 sound/usb/pcm.c                                       |    2 
 tools/perf/tests/sample-parsing.c                     |    2 
 tools/perf/util/event.c                               |    2 
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c   |    3 
 242 files changed, 2306 insertions(+), 1498 deletions(-)

Adrian Hunter (1):
      perf intel-pt: Fix missing CYC processing in PSB

Al Viro (1):
      sparc32: fix a user-triggerable oops in clear_user()

Alain Volmat (1):
      spi: stm32: properly handle 0 byte transfer

Alexander Lobakin (1):
      MIPS: vmlinux.lds.S: add missing PAGE_ALIGNED_DATA() section

Alexander Usyskin (1):
      watchdog: mei_wdt: request stop on unregister

Amey Narkhede (1):
      staging: gdm724x: Fix DMA from stack

Andre Przywara (5):
      arm64: dts: allwinner: A64: properly connect USB PHY to port 0
      arm64: dts: allwinner: Drop non-removable from SoPine/LTS SD card
      arm64: dts: allwinner: A64: Limit MMC2 bus frequency to 150 MHz
      clk: sunxi-ng: h6: Fix CEC clock
      clk: sunxi-ng: h6: Fix clock divider range on some clocks

Andrea Parri (Microsoft) (1):
      Drivers: hv: vmbus: Avoid use-after-free in vmbus_onoffer_rescind()

Andrii Nakryiko (1):
      bpf: Avoid warning when re-casting __bpf_call_base into __bpf_call_base_args

Andy Shevchenko (1):
      spi: pxa2xx: Fix the controller numbering for Wildcat Point

AngeloGioacchino Del Regno (1):
      clk: qcom: gcc-msm8998: Fix Alpha PLL type for all GPLLs

Ansuel Smith (1):
      PCI: qcom: Use PHY_REFCLK_USE_PAD only for ipq8064

Ard Biesheuvel (1):
      crypto: arm64/sha - add missing module aliases

Arnaldo Carvalho de Melo (1):
      perf tools: Fix DSO filtering when not finding a map for a sampled address

Arnd Bergmann (1):
      ARM: s3c: fix fiq for clang IAS

Aswath Govindraju (2):
      misc: eeprom_93xx46: Fix module alias to enable module autoprobe
      misc: eeprom_93xx46: Add module alias to avoid breaking support for non device tree users

Ayush Sawal (1):
      cxgb4/chtls/cxgbit: Keeping the max ofld immediate data size same in cxgb4 and ulds

Bard Liao (1):
      regmap: sdw: use _no_pm functions in regmap_read/write

Bartosz Golaszewski (1):
      rtc: s5m: select REGMAP_I2C

Bob Pearson (2):
      RDMA/rxe: Fix coding error in rxe_recv.c
      RDMA/rxe: Correct skb on loopback path

Bob Peterson (1):
      gfs2: Don't skip dlm unlock if glock has an lvb

Chao Yu (1):
      f2fs: fix out-of-repair __setattr_copy()

Chen Yu (1):
      cpufreq: intel_pstate: Get per-CPU max freq via MSR_HWP_CAPABILITIES if available

Chen-Yu Tsai (1):
      staging: rtl8723bs: wifi_regd.c: Fix incorrect number of regulatory rules

Chenyang Li (1):
      drm/amdgpu: Fix macro name _AMDGPU_TRACE_H_ in preprocessor if condition

Christoph Schemmel (1):
      NET: usb: qmi_wwan: Adding support for Cinterion MV31

Christophe JAILLET (9):
      Bluetooth: btqcomsmd: Fix a resource leak in error handling paths in the probe function
      cpufreq: brcmstb-avs-cpufreq: Free resources in error path
      cpufreq: brcmstb-avs-cpufreq: Fix resource leaks in ->remove()
      media: vsp1: Fix an error handling path in the probe function
      media: cx25821: Fix a bug when reallocating some dma memory
      dmaengine: fsldma: Fix a resource leak in the remove function
      dmaengine: fsldma: Fix a resource leak in an error handling path of the probe function
      dmaengine: owl-dma: Fix a resource leak in the remove function
      mmc: usdhi6rol0: Fix a resource leak in the error handling path of the probe

Christophe Leroy (3):
      crypto: talitos - Work around SEC6 ERRATA (AES-CTR mode data size error)
      powerpc/47x: Disable 256k page size
      powerpc/8xx: Fix software emulation interrupt

Christopher William Snowhill (1):
      Bluetooth: Fix initializing response id after clearing struct

Chuhong Yuan (1):
      net/mlx4_core: Add missed mlx4_free_cmd_mailbox()

Claudiu Beznea (1):
      power: reset: at91-sama5d2_shdwc: fix wkupdbc mask

Colin Ian King (3):
      mac80211: fix potential overflow when multiplying to u32 integers
      b43: N-PHY: Fix the update of coef for the PHY revision >= 3case
      fs/jfs: fix potential integer overflow on shift of a int

Corentin Labbe (3):
      crypto: sun4i-ss - fix kmap usage
      crypto: sun4i-ss - checking sg length is not sufficient
      crypto: sun4i-ss - handle BigEndian for cipher

Cédric Le Goater (1):
      KVM: PPC: Make the VMX instruction emulation routines static

Dan Carpenter (11):
      gma500: clean up error handling in init
      media: camss: missing error code in msm_video_register()
      ASoC: cs42l56: fix up error handling in probe
      drm/amdgpu: Prevent shift wrapping in amdgpu_read_mask()
      mfd: wm831x-auxadc: Prevent use after free in wm831x_auxadc_read_irq()
      Input: sur40 - fix an error code in sur40_probe()
      Input: elo - fix an error code in elo_connect()
      ocfs2: fix a use after free on error
      Input: joydev - prevent potential read overflow in ioctl
      USB: serial: mos7840: fix error code in mos7840_write()
      USB: serial: mos7720: fix error code in mos7720_write()

Dan Williams (1):
      libnvdimm/dimm: Avoid race between probe and available_slots_show()

Daniele Alessandrelli (1):
      crypto: ecdh_helper - Ensure 'len >= secret.len' in decode_key()

David Howells (1):
      certs: Fix blacklist flag type confusion

Dinghao Liu (3):
      media: em28xx: Fix use-after-free in em28xx_alloc_urbs
      media: media/pci: Fix memleak in empress_init
      media: tm6000: Fix memleak in tm6000_start_stream

Edwin Peer (1):
      bnxt_en: reverse order of TX disable and carrier off

Eric Biggers (1):
      random: fix the RNDRESEEDCRNG ioctl

Eric Dumazet (2):
      tcp: fix SO_RCVLOWAT related hangs under mem pressure
      ipv6: icmp6: avoid indirect call for icmpv6_send()

Eric W. Biederman (1):
      capabilities: Don't allow writing ambiguous v3 file capabilities

Fangrui Song (1):
      module: Ignore _GLOBAL_OFFSET_TABLE_ when warning for undefined symbols

Ferry Toth (1):
      dmaengine: hsu: disable spurious interrupt

Filipe Manana (1):
      btrfs: fix extent buffer leak on failure to copy root

Florian Fainelli (1):
      ata: ahci_brcm: Add back regulators management

Frank Li (1):
      mmc: sdhci-esdhc-imx: fix kernel panic when remove module

Frank Wunderlich (1):
      dts64: mt7622: fix slow sd card access

Geert Uytterhoeven (1):
      auxdisplay: ht16k33: Fix refresh rate handling

Greg Kroah-Hartman (1):
      Linux 4.19.178

Guenter Roeck (3):
      usb: dwc2: Do not update data length if it is 0 on inbound transfers
      usb: dwc2: Abort transaction after errors with unknown reason
      usb: dwc2: Make "trimming xfer length" a debug message

He Zhe (1):
      arm64: uprobe: Return EOPNOTSUPP for AARCH32 instruction probing

Heiner Kallweit (2):
      PCI: Align checking of syscall user config accessors
      r8169: fix jumbo packet handling on RTL8168e

Ilya Lipnitskiy (1):
      staging/mt7621-dma: mtk-hsdma.c->hsdma-mt7621.c

Jack Pham (1):
      usb: gadget: u_audio: Free requests only after callback

Jacopo Mondi (1):
      media: i2c: ov5670: Fix PIXEL_RATE minimum value

Jae Hyun Yoo (1):
      soc: aspeed: snoop: Add clock control logic

James Bottomley (2):
      tpm_tis: Fix check_locality for correct locality acquisition
      tpm_tis: Clean up locality release

Jan Henrik Weinstock (1):
      hwrng: timeriomem - Fix cooldown period calculation

Jan Kara (2):
      bfq: Avoid false bfq queue merging
      quota: Fix memory leak when handling corrupted quota file

Jarkko Sakkinen (1):
      KEYS: trusted: Fix migratable=1 failing

Jason A. Donenfeld (6):
      icmp: introduce helper for nat'd source address in network device context
      icmp: allow icmpv6_ndo_send to work with CONFIG_IPV6=n
      gtp: use icmp_ndo_send helper
      sunvnet: use icmp_ndo_send helper
      xfrm: interface: use icmp_ndo_send helper
      net: icmp: pass zeroed opts from icmp{,v6}_ndo_send before sending

Jason Gerecke (1):
      HID: wacom: Ignore attempts to overwrite the touch_max value from HID

Jesper Dangaard Brouer (1):
      bpf: Fix bpf_fib_lookup helper MTU check for SKB ctx

Jialin Zhang (1):
      drm/gma500: Fix error return code in psb_driver_load()

Jiri Bohac (1):
      pstore: Fix typo in compression option name

Jiri Kosina (1):
      floppy: reintroduce O_NDELAY fix

Jiri Olsa (1):
      crypto: bcm - Rename struct device_private to bcm_device_private

Joe Perches (1):
      media: lmedm04: Fix misuse of comma

Johan Hovold (2):
      USB: quirks: sort quirk entries
      USB: serial: ftdi_sio: fix FTX sub-integer prescaler

John Wang (1):
      ARM: dts: aspeed: Add LCLK to lpc-snoop

Jorgen Hansen (1):
      VMCI: Use set_page_dirty_lock() when unregistering guest memory

Josef Bacik (2):
      btrfs: abort the transaction if we fail to inc ref in btrfs_copy_root
      btrfs: fix reloc root leak with 0 ref reloc roots on recovery

Juergen Gross (1):
      xen/netback: fix spurious event detection for common event case

KarimAllah Ahmed (1):
      fdt: Properly handle "no-map" field in the memory region

Konrad Dybcio (1):
      drm/msm/dsi: Correct io_start for MSM8994 (20nm PHY)

Krzysztof Kozlowski (9):
      ARM: dts: exynos: correct PMIC interrupt trigger level on Artik 5
      ARM: dts: exynos: correct PMIC interrupt trigger level on Monk
      ARM: dts: exynos: correct PMIC interrupt trigger level on Rinato
      ARM: dts: exynos: correct PMIC interrupt trigger level on Spring
      ARM: dts: exynos: correct PMIC interrupt trigger level on Arndale Octa
      ARM: dts: exynos: correct PMIC interrupt trigger level on Odroid XU3 family
      arm64: dts: exynos: correct PMIC interrupt trigger level on TM2
      arm64: dts: exynos: correct PMIC interrupt trigger level on Espresso
      regulator: s5m8767: Drop regulators OF node reference

Lakshmi Ramasubramanian (2):
      ima: Free IMA measurement buffer on error
      ima: Free IMA measurement buffer after kexec syscall

Laurent Pinchart (1):
      media: uvcvideo: Accept invalid bFormatIndex and bFrameIndex values

Lech Perczak (1):
      USB: serial: option: update interface mapping for ZTE P685M

Leon Romanovsky (1):
      ipv6: silence compilation warning for non-IPV6 builds

Lijun Pan (2):
      ibmvnic: add memory barrier to protect long term buffer
      ibmvnic: skip send_request_unmap for timeout reset

Linus Lüssing (1):
      ath9k: fix data bus crash when setting nf_override via debugfs

Luo Meng (1):
      media: qm1d1c0042: fix error return code in qm1d1c0042_init()

Marc Zyngier (1):
      arm64: Add missing ISB after invalidating TLB in __primary_switch

Marco Elver (1):
      bpf_lru_list: Read double-checked variable once without lock

Marcos Paulo de Souza (1):
      Input: i8042 - add ASUS Zenbook Flip to noselftest list

Mario Kleiner (1):
      drm/amd/display: Fix 10/12 bpc setup in DCE output bit depth reduction.

Martin Blumenstingl (1):
      clk: meson: clk-pll: fix initializing the old rate (fallback) for a PLL

Martin Kaiser (1):
      staging: rtl8188eu: Add Edimax EW-7811UN V2 to device table

Mateusz Palczewski (3):
      i40e: Add zero-initialization of AQ command structures
      i40e: Fix overwriting flow control settings during driver loading
      i40e: Fix add TC filter for IPv6

Maxim Kiselev (1):
      gpio: pcf857x: Fix missing first interrupt

Maxime Chevallier (1):
      net: mvneta: Remove per-cpu queue mapping for Armada 3700

Maxime Ripard (1):
      i2c: brcmstb: Fix brcmstd_send_i2c_cmd condition

Maximilian Luz (1):
      ACPICA: Fix exception code class checks

Miaohe Lin (3):
      mm/memory.c: fix potential pte_unmap_unlock pte error
      mm/hugetlb: fix potential double free in hugetlb_register_node() error path
      mm/rmap: fix potential pte_unmap on an not mapped pte

Mike Kravetz (1):
      hugetlb: fix copy_huge_page_from_user contig page struct assumption

Mikulas Patocka (2):
      blk-settings: align max_sectors on "logical_block_size" boundary
      dm: fix deadlock when swapping to encrypted device

Ming Lei (4):
      block: add helper for checking if queue is registered
      block: split .sysfs_lock into two locks
      block: fix race between switching elevator and removing queues
      block: don't release queue's sysfs lock during switching elevator

Muchun Song (1):
      printk: fix deadlock when kernel panic

Namhyung Kim (1):
      perf test: Fix unaligned access in sample parsing test

Nathan Chancellor (2):
      MIPS: c-r4k: Fix section mismatch for loongson2_sc_init
      MIPS: lantiq: Explicitly compare LTQ_EBU_PCC_ISTAT against 0

Nathan Lynch (1):
      powerpc/pseries/dlpar: handle ibm, configure-connector delay status

NeilBrown (2):
      seq_file: document how per-entry resources are managed.
      x86: fix seq_file iteration for pat/memtype.c

Nick Desaulniers (1):
      vmlinux.lds.h: add DWARF v5 sections

Nicolas Boichat (1):
      of/fdt: Make sure no-map does not remove already reserved regions

Nikos Tsironis (7):
      dm era: Recover committed writeset after crash
      dm era: Verify the data block size hasn't changed
      dm era: Fix bitset memory leaks
      dm era: Use correct value size in equality function of writeset tree
      dm era: Reinitialize bitset cache before digesting a new writeset
      dm era: only resize metadata in preresume
      dm era: Update in-core bitset after committing the metadata

Olivier Crête (1):
      Input: xpad - add support for PowerA Enhanced Wired Controller for Xbox Series X|S

Pan Bian (8):
      Bluetooth: drop HCI device reference before return
      Bluetooth: Put HCI device if inquiry procedure interrupts
      memory: ti-aemif: Drop child node when jumping out loop
      regulator: axp20x: Fix reference cout leak
      spi: atmel: Put allocated master before return
      isofs: release buffer head before return
      mtd: spi-nor: hisi-sfc: Put child node np on error path
      fs/affs: release old buffer head on error path

Paul Cercueil (2):
      usb: musb: Fix runtime PM race in musb_queue_resume_work
      seccomp: Add missing return in non-void function

Pavel Machek (1):
      media: ipu3-cio2: Fix mbus_code processing in cio2_subdev_set_fmt()

PeiSen Hou (1):
      ALSA: hda/realtek: modify EAPD in the ALC886

Peter Zijlstra (2):
      jump_label/lockdep: Assert we hold the hotplug lock for _cpuslocked() operations
      locking/static_key: Fix false positive warnings on concurrent dec/inc

Pratyush Yadav (1):
      spi: cadence-quadspi: Abort read if dummy cycles required are too many

Qinglang Miao (1):
      ACPI: configfs: add missing check after configfs_register_default_group()

Rafael J. Wysocki (1):
      ACPI: property: Fix fwnode string properties matching

Rakesh Pillai (1):
      ath10k: Fix error handling in case of CE pipe init failure

Randy Dunlap (4):
      fbdev: aty: SPARC64 requires FB_ATY_CT
      HID: core: detect and skip invalid inputs to snto32()
      sparc64: only select COMPAT_BINFMT_ELF if BINFMT_ELF is set
      scsi: bnx2fc: Fix Kconfig warning & CNIC build errors

Ricky Wu (1):
      misc: rtsx: init of rts522a add OCP power off when no card is present

Rolf Eike Beer (2):
      scripts: use pkg-config to locate libcrypto
      scripts: set proper OpenSSL include dir also for sign-file

Rong Chen (1):
      scripts/recordmcount.pl: support big endian for ARCH sh

Rosen Penev (2):
      ARM: dts: armada388-helios4: assign pinctrl to LEDs
      ARM: dts: armada388-helios4: assign pinctrl to each fan

Rustam Kovhaev (1):
      ntfs: check for valid standard information attribute

Sabyrzhan Tasbolatov (1):
      drivers/misc/vmw_vmci: restrict too big queue size in qp_host_alloc_queue

Sameer Pujar (1):
      arm64: tegra: Add power-domain for Tegra210 HDA

Sean Christopherson (1):
      x86/reboot: Force all cpus to exit VMX root if VMX is supported

Sebastian Reichel (1):
      ASoC: cpcap: fix microphone timeslot mask

Shay Drory (2):
      IB/umad: Return EIO in case of when device disassociated
      IB/umad: Return EPOLLERR in case of when device disassociated

Shyam Prasad N (1):
      cifs: Set CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.

Shyam Sundar S K (4):
      net: amd-xgbe: Reset the PHY rx data path when mailbox command timeout
      net: amd-xgbe: Fix NETDEV WATCHDOG transmit queue timeout warning
      net: amd-xgbe: Reset link when the link never comes back
      net: amd-xgbe: Fix network fluctuations when using 1G BELFUSE SFP

Simon South (1):
      pwm: rockchip: rockchip_pwm_probe(): Remove superfluous clk_unprepare()

Slawomir Laba (1):
      i40e: Fix flow for IPv6 next header (extension header)

Stefan Ursella (1):
      usb: quirks: add quirk to start video capture on ELMO L-12F document camera reliable

Steven Rostedt (VMware) (1):
      tracepoint: Do not fail unregistering a probe due to memory failure

Sukadev Bhattiprolu (1):
      ibmvnic: Set to CLOSED state even on error

Sumit Garg (1):
      kdb: Make memory allocations more robust

Suzuki K Poulose (1):
      arm64: Extend workaround for erratum 1024718 to all versions of Cortex-A55

Sylwester Dziedziuch (1):
      i40e: Fix VFs not created

Taehee Yoo (1):
      vxlan: move debug check after netdev unregister

Takashi Iwai (1):
      ALSA: usb-audio: Fix PCM buffer allocation in non-vmalloc mode

Takeshi Misawa (1):
      net: qrtr: Fix memory leak in qrtr_tun_open

Takeshi Saito (1):
      mmc: renesas_sdhi_internal_dmac: Fix DMA buffer alignment from 8 to 128-bytes

Theodore Ts'o (1):
      ext4: fix potential htree index checksum corruption

Thinh Nguyen (2):
      usb: dwc3: gadget: Fix setting of DEPCFG.bInterval_m1
      usb: dwc3: gadget: Fix dep->interval for fullspeed interrupt

Tom Rix (3):
      media: pxa_camera: declare variable when DEBUG is defined
      jffs2: fix use after free in jffs2_sum_write_data()
      clocksource/drivers/mxs_timer: Add missing semicolon when DEBUG is defined

Tony Lindgren (1):
      ARM: dts: Configure missing thermal interrupt for 4430

Uwe Kleine-König (1):
      amba: Fix resource leak for drivers without .remove

Vincent Knecht (1):
      arm64: dts: msm8916: Fix reserved and rfsa nodes unit address

Vladimir Murzin (1):
      ARM: 9046/1: decompressor: Do not clear SCTLR.nTLSMD for ARMv7+ cores

Will McVicker (1):
      HID: make arrays usage and value to be the same

Yi Chen (1):
      f2fs: fix to avoid inconsistent quota data

Yishai Hadas (1):
      RDMA/mlx5: Use the correct obj_id upon DEVX TIR creation

Yoshihiro Shimoda (1):
      mfd: bd9571mwv: Use devm_mfd_add_devices()

Zhihao Cheng (1):
      btrfs: clarify error returns values in __load_free_space_cache

jeffrey.lin (1):
      Input: raydium_ts_i2c - do not send zero length

