Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE07B60DFA4
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 13:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233339AbiJZLhk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 07:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233387AbiJZLhj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 07:37:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C8F9C22C;
        Wed, 26 Oct 2022 04:37:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EA6BB821A9;
        Wed, 26 Oct 2022 11:37:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2ADCC433C1;
        Wed, 26 Oct 2022 11:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666784255;
        bh=OXdZXBJGs5GOkLEdV2hSZ+fPeUoUkSNZCTvHS5y68nI=;
        h=From:To:Cc:Subject:Date:From;
        b=gJCrx9C3kskKZXXvwQ5Uvv9JzLUYxOZbZ3FW8X4xKwaP+jCmvBxPaQ5HM2kcr0dxD
         fQ2nfszo+k8gvJKIxtm9NzczJNZsMzSk6/YDki4IGLMGWVLlZ7XhdXYPYgjtYLqjNn
         SlxCcuUmWwG0LZAcjICZuWTq+t0WuyG3gb1tQB2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.331
Date:   Wed, 26 Oct 2022 13:37:31 +0200
Message-Id: <166678425111092@kroah.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.331 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-bus-iio                   |    2 
 Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt |    4 
 Makefile                                                  |    2 
 arch/arm/Kconfig                                          |    3 
 arch/arm/Kconfig.debug                                    |    6 
 arch/arm/boot/dts/exynos4412-origen.dts                   |    2 
 arch/arm/boot/dts/imx6dl.dtsi                             |    3 
 arch/arm/boot/dts/imx6q.dtsi                              |    3 
 arch/arm/boot/dts/imx6qp.dtsi                             |    6 
 arch/arm/boot/dts/imx6sl.dtsi                             |    3 
 arch/arm/boot/dts/imx7d-sdb.dts                           |    7 -
 arch/arm/boot/dts/kirkwood-lsxl.dtsi                      |   16 --
 arch/arm/boot/dts/moxart-uc7112lx.dts                     |    2 
 arch/arm/boot/dts/moxart.dtsi                             |    4 
 arch/mips/bcm47xx/prom.c                                  |    4 
 arch/powerpc/boot/dts/fsl/e500v1_power_isa.dtsi           |   51 +++++++
 arch/powerpc/boot/dts/fsl/mpc8540ads.dts                  |    2 
 arch/powerpc/boot/dts/fsl/mpc8541cds.dts                  |    2 
 arch/powerpc/boot/dts/fsl/mpc8555cds.dts                  |    2 
 arch/powerpc/boot/dts/fsl/mpc8560ads.dts                  |    2 
 arch/powerpc/kernel/pci_dn.c                              |    1 
 arch/powerpc/math-emu/math_efp.c                          |    1 
 arch/sh/include/asm/sections.h                            |    2 
 arch/sh/kernel/machvec.c                                  |   10 -
 arch/um/kernel/um_arch.c                                  |    2 
 arch/x86/kvm/emulate.c                                    |    2 
 arch/x86/um/shared/sysdep/syscalls_32.h                   |    5 
 arch/x86/um/tls_32.c                                      |    6 
 drivers/acpi/acpi_video.c                                 |   16 ++
 drivers/char/random.c                                     |   22 ++-
 drivers/clk/bcm/clk-bcm2835.c                             |    6 
 drivers/clk/bcm/clk-iproc-pll.c                           |   95 ++++++--------
 drivers/clk/tegra/clk-tegra114.c                          |    1 
 drivers/clk/tegra/clk-tegra20.c                           |    1 
 drivers/clk/tegra/clk-tegra210.c                          |    1 
 drivers/clk/ti/clk-dra7-atl.c                             |    9 -
 drivers/dma/ioat/dma.c                                    |    6 
 drivers/dma/xilinx/xilinx_dma.c                           |    8 -
 drivers/firmware/google/gsmi.c                            |    9 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c            |    7 -
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c        |   13 -
 drivers/gpu/drm/drm_ioctl.c                               |    8 +
 drivers/gpu/drm/drm_mipi_dsi.c                            |    1 
 drivers/hid/hid-roccat.c                                  |    4 
 drivers/hsi/controllers/omap_ssi_core.c                   |    1 
 drivers/hsi/controllers/omap_ssi_port.c                   |    8 -
 drivers/iio/adc/at91-sama5d2_adc.c                        |    2 
 drivers/iio/dac/ad5593r.c                                 |   46 +++---
 drivers/iio/inkern.c                                      |    6 
 drivers/infiniband/sw/rxe/rxe_qp.c                        |   10 +
 drivers/input/joystick/xpad.c                             |   20 ++
 drivers/input/touchscreen/melfas_mip4.c                   |    2 
 drivers/iommu/omap-iommu-debug.c                          |    6 
 drivers/isdn/mISDN/l1oip.h                                |    1 
 drivers/isdn/mISDN/l1oip_core.c                           |   13 +
 drivers/media/pci/cx88/cx88-vbi.c                         |    9 -
 drivers/media/pci/cx88/cx88-video.c                       |   43 +++---
 drivers/media/platform/exynos4-is/fimc-is.c               |    1 
 drivers/media/platform/xilinx/xilinx-vipp.c               |    9 -
 drivers/memory/of_memory.c                                |    1 
 drivers/mfd/intel_soc_pmic_core.c                         |    1 
 drivers/mfd/lp8788-irq.c                                  |    3 
 drivers/mfd/lp8788.c                                      |   12 +
 drivers/mfd/sm501.c                                       |    7 -
 drivers/mmc/host/au1xmmc.c                                |    3 
 drivers/mmc/host/moxart-mmc.c                             |   17 --
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c           |    1 
 drivers/net/ethernet/freescale/fs_enet/mac-fec.c          |    2 
 drivers/net/usb/qmi_wwan.c                                |    1 
 drivers/net/usb/r8152.c                                   |    4 
 drivers/net/usb/usbnet.c                                  |    7 -
 drivers/net/wireless/ath/ath10k/mac.c                     |   54 ++++---
 drivers/net/wireless/mac80211_hwsim.c                     |    2 
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c            |    3 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c     |   18 +-
 drivers/nvme/host/core.c                                  |    9 -
 drivers/pci/setup-res.c                                   |   11 +
 drivers/platform/x86/msi-laptop.c                         |   11 -
 drivers/powercap/intel_rapl.c                             |    3 
 drivers/regulator/qcom_rpm-regulator.c                    |   24 +--
 drivers/scsi/3w-9xxx.c                                    |    2 
 drivers/scsi/stex.c                                       |   17 +-
 drivers/soc/qcom/smem_state.c                             |    3 
 drivers/soc/qcom/smsm.c                                   |   20 +-
 drivers/spi/spi-omap-100k.c                               |    1 
 drivers/spi/spi-qup.c                                     |   21 ++-
 drivers/thermal/intel_powerclamp.c                        |    4 
 drivers/tty/serial/8250/8250_port.c                       |    7 -
 drivers/tty/serial/jsm/jsm_driver.c                       |    3 
 drivers/tty/serial/xilinx_uartps.c                        |    2 
 drivers/usb/host/xhci-mem.c                               |    7 -
 drivers/usb/misc/idmouse.c                                |    8 -
 drivers/usb/mon/mon_bin.c                                 |    5 
 drivers/usb/musb/musb_gadget.c                            |    3 
 drivers/usb/serial/ftdi_sio.c                             |    3 
 drivers/usb/serial/qcserial.c                             |    1 
 drivers/usb/storage/unusual_devs.h                        |    6 
 drivers/usb/storage/unusual_uas.h                         |   21 +++
 drivers/video/fbdev/smscufx.c                             |   14 +-
 drivers/video/fbdev/stifb.c                               |    2 
 fs/ceph/file.c                                            |    9 -
 fs/dlm/ast.c                                              |    6 
 fs/dlm/lock.c                                             |   16 +-
 fs/ext4/file.c                                            |    6 
 fs/ext4/inode.c                                           |    7 +
 fs/ext4/resize.c                                          |    2 
 fs/ext4/super.c                                           |    3 
 fs/f2fs/extent_cache.c                                    |    3 
 fs/inode.c                                                |    7 -
 fs/nilfs2/inode.c                                         |   20 ++
 fs/nilfs2/segment.c                                       |   21 +--
 fs/ntfs/super.c                                           |    3 
 fs/quota/quota_tree.c                                     |   38 +++++
 include/linux/ata.h                                       |   39 +++--
 include/linux/dynamic_debug.h                             |    2 
 include/linux/tcp.h                                       |    2 
 include/net/ieee802154_netdev.h                           |   43 ++++++
 include/net/sock.h                                        |    2 
 include/net/tcp.h                                         |    5 
 include/scsi/scsi_cmnd.h                                  |    2 
 kernel/gcov/gcc_4_7.c                                     |   18 ++
 kernel/trace/ring_buffer.c                                |   46 ++++++
 lib/dynamic_debug.c                                       |   11 +
 mm/page_alloc.c                                           |   12 +
 net/bluetooth/hci_sysfs.c                                 |    3 
 net/bluetooth/l2cap_core.c                                |   17 +-
 net/can/bcm.c                                             |    7 -
 net/ieee802154/socket.c                                   |   46 +++---
 net/ipv4/af_inet.c                                        |    2 
 net/ipv4/tcp.c                                            |   19 +-
 net/ipv4/tcp_input.c                                      |    2 
 net/ipv4/tcp_ipv4.c                                       |   13 +
 net/ipv4/tcp_output.c                                     |   19 +-
 net/ipv4/udp.c                                            |    6 
 net/ipv6/tcp_ipv6.c                                       |   11 +
 net/mac80211/cfg.c                                        |    3 
 net/openvswitch/datapath.c                                |   18 +-
 net/rds/tcp.c                                             |    2 
 net/xfrm/xfrm_ipcomp.c                                    |    1 
 scripts/Makefile.extrawarn                                |    1 
 scripts/selinux/install_policy.sh                         |    2 
 sound/core/pcm_dmaengine.c                                |    8 -
 sound/core/rawmidi.c                                      |    2 
 sound/core/sound_oss.c                                    |   13 +
 sound/pci/hda/hda_intel.c                                 |    3 
 sound/soc/fsl/eukrea-tlv320.c                             |    8 -
 sound/usb/endpoint.c                                      |    6 
 tools/perf/util/intel-pt.c                                |    9 +
 tools/testing/selftests/net/reuseport_bpf.c               |    2 
 149 files changed, 959 insertions(+), 470 deletions(-)

Adrian Hunter (1):
      perf intel-pt: Fix segfault in intel_pt_print_info() with uClibc

Alexander Aring (3):
      fs: dlm: fix race between test_bit() and queue_work()
      fs: dlm: handle -EBUSY first in lock arg validation
      net: ieee802154: return -EINVAL for unknown addr type

Alexander Stein (4):
      ARM: dts: imx6q: add missing properties for sram
      ARM: dts: imx6dl: add missing properties for sram
      ARM: dts: imx6qp: add missing properties for sram
      ARM: dts: imx6sl: add missing properties for sram

Andreas Pape (1):
      ALSA: dmaengine: increment buffer pointer atomically

Andrew Gaul (1):
      r8152: Rate limit overflow messages

Arvid Norlander (1):
      ACPI: video: Add Toshiba Satellite/Portege Z830 quirk

Baokun Li (1):
      ext4: fix null-ptr-deref in ext4_write_info

Bitterblue Smith (1):
      wifi: rtl8xxxu: gen2: Fix mistake in path B IQ calibration

Brian Norris (1):
      Revert "drm: bridge: analogix/dp: add panel prepare/unprepare in suspend/resume time"

Cameron Gutman (1):
      Input: xpad - fix wireless 360 controller breaking after suspend

Chaitanya Kulkarni (1):
      nvme: add new line after variable declatation

Chao Qin (1):
      powercap: intel_rapl: fix UBSAN shift-out-of-bounds issue

ChenXiaoSong (1):
      ntfs: fix BUG_ON in ntfs_lookup_inode_by_name()

Christophe JAILLET (4):
      mmc: au1xmmc: Fix an error handling path in au1xmmc_probe()
      mfd: intel_soc_pmic: Fix an error handling path in intel_soc_pmic_i2c_probe()
      mfd: lp8788: Fix an error handling path in lp8788_probe()
      mfd: lp8788: Fix an error handling path in lp8788_irq_init() and lp8788_irq_init()

Claudiu Beznea (1):
      iio: adc: at91-sama5d2_adc: fix AT91_SAMA5D2_MR_TRACKTIM_MAX

Dan Carpenter (3):
      wifi: rtl8xxxu: tighten bounds checking in rtl8xxxu_read_efuse()
      drivers: serial: jsm: fix some leaks in probe
      iommu/omap: Fix buffer overflow in debugfs

Daniel Golle (1):
      wifi: rt2x00: don't run Rt5592 IQ calibration on MT7620

Dave Jiang (1):
      dmaengine: ioat: stop mod_timer from resurrecting deleted timer in __cleanup()

Dmitry Torokhov (1):
      ARM: dts: exynos: fix polarity of VBUS GPIO of Origen

Dongliang Mu (2):
      fs: fix UAF/GPF bug in nilfs_mdt_destroy
      usb: idmouse: fix an uninit-value in idmouse_open

Duoming Zhou (1):
      mISDN: fix use-after-free bugs in l1oip timer handlers

Eric Dumazet (2):
      tcp: annotate data-race around tcp_md5sig_pool_populated
      inet: fully convert sk->sk_rx_dst to RCU rules

Florian Fainelli (1):
      clk: iproc: Do not rely on node name for correct PLL setup

Frank Wunderlich (2):
      net: usb: qmi_wwan: Add new usb-id for Dell branded EM7455
      USB: serial: qcserial: add new usb-id for Dell branded EM7455

Geert Uytterhoeven (1):
      ARM: Drop CMDLINE_* dependency on ATAGS

Greg Kroah-Hartman (2):
      selinux: use "grep -E" instead of "egrep"
      Linux 4.9.331

Guilherme G. Piccoli (1):
      firmware: google: Test spinlock on panic path to avoid lockups

Haibo Chen (1):
      ARM: dts: imx7d-sdb: config the max pressure for tsc2046

Haimin Zhang (1):
      net/ieee802154: fix uninit value bug in dgram_sendmsg

Hans de Goede (2):
      platform/x86: msi-laptop: Fix old-ec check for backlight registering
      platform/x86: msi-laptop: Change DMI match / alias strings to fix module autoloading

Hari Chandrakanthan (1):
      wifi: mac80211: allow bw change during channel switch in mesh

Helge Deller (1):
      parisc: fbdev/stifb: Align graphics memory size to 4MB

Hongling Zeng (3):
      uas: add no-uas quirk for Hiksemi usb_disk
      usb-storage: Add Hiksemi USB3-FW to IGNORE_UAS
      uas: ignore UAS for Thinkplus chips

Hu Weiwen (1):
      ceph: don't truncate file in atomic_open

Huacai Chen (1):
      UM: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK

Hyunwoo Kim (2):
      fbdev: smscufx: Fix use-after-free in ufx_ops_open()
      HID: roccat: Fix use-after-free in roccat_read()

Jack Wang (1):
      HSI: omap_ssi_port: Fix dma_map_sg error check

Jan Kara (1):
      ext4: avoid crash when inline data creation follows DIO write

Jason A. Donenfeld (4):
      random: clamp credited irq bits to maximum mixed
      random: avoid reading two cache lines on irq randomness
      random: restore O_NONBLOCK support
      random: use expired timer rather than wq for mixing fast pool

Javier Martinez Canillas (2):
      drm: Use size_t type for len variable in drm_copy_field()
      drm: Prevent drm_copy_field() to attempt copying a NULL pointer

Jerry Lee 李修賢 (1):
      ext4: continue to expand file system when the target size doesn't reach

Jianglei Nie (2):
      bnx2x: fix potential memory leak in bnx2x_tpa_stop()
      usb: host: xhci: Fix potential memory leak in xhci_alloc_stream_info()

Jiasheng Jiang (1):
      mfd: sm501: Add check for platform_driver_register()

Jim Cromie (2):
      dyndbg: fix module.dyndbg handling
      dyndbg: let query-modname override actual module name

Jinke Han (1):
      ext4: place buffer head allocation before handle start

Johan Hovold (1):
      USB: serial: ftdi_sio: fix 300 bps rate for SIO

Johannes Berg (1):
      wifi: mac80211_hwsim: avoid mac80211 warning on bad rate

Jonathan Cameron (1):
      iio: ABI: Fix wrong format of differential capacitance channel ABI.

Kees Cook (2):
      sh: machvec: Use char[] for section boundaries
      MIPS: BCM47XX: Cast memcmp() of function to (void *)

Khalid Masum (1):
      xfrm: Update ipcomp_scratches with NULL when freed

Lalith Rajendran (1):
      ext4: make ext4_lazyinit_thread freezable

Letu Ren (1):
      scsi: 3w-9xxx: Avoid disabling device if failing to enable it

Liang He (6):
      ASoC: eureka-tlv320: Hold reference returned from of_find_xxx API
      memory: of: Fix refcount leak bug in of_get_ddr_timings()
      soc: qcom: smsm: Fix refcount leak bugs in qcom_smsm_probe()
      soc: qcom: smem_state: Add refcounting for the 'state->of_node'
      media: exynos4-is: fimc-is: Add of_node_put() when breaking out of loop
      powerpc/pci_dn: Add missing of_node_put()

Linus Torvalds (1):
      scsi: stex: Properly zero out the passthrough command structure

Linus Walleij (1):
      regulator: qcom_rpm: Fix circular deferral regression

Lori Hikichi (1):
      clk: iproc: Minor tidy up of iproc pll data structures

Luiz Augusto von Dentz (2):
      Bluetooth: hci_sysfs: Fix attempting to call device_add multiple times
      Bluetooth: L2CAP: Fix user-after-free

Lukas Straub (2):
      um: Cleanup syscall_handler_t cast in syscalls_32.h
      um: Cleanup compiler warning in arch/x86/um/tls_32.c

Maciej W. Rozycki (1):
      PCI: Sanitise firmware BAR assignments behind a PCI-PCI bridge

Martin Liska (1):
      gcov: support GCC 12.1 and newer compilers

Maurizio Lombardi (1):
      mm: prevent page_frag_alloc() from corrupting the memory

Maxime Ripard (1):
      drm/mipi-dsi: Detach devices when removing the host

Miaoqian Lin (6):
      clk: tegra: Fix refcount leak in tegra210_clock_init
      clk: tegra: Fix refcount leak in tegra114_clock_init
      clk: tegra20: Fix refcount leak in tegra20_clock_init
      HSI: omap_ssi: Fix refcount leak in ssi_probe
      media: xilinx: vipp: Fix refcount leak in xvip_graph_dma_init
      clk: ti: dra7-atl: Fix reference leak in of_dra7_atl_clk_probe

Michael Hennerich (1):
      iio: dac: ad5593r: Fix i2c read protocol requirements

Michael Kelley (1):
      nvme: Fix IOC_PR_CLEAR and IOC_PR_RELEASE ioctls for nvme devices

Michael Walle (2):
      ARM: dts: kirkwood: lsxl: fix serial line
      ARM: dts: kirkwood: lsxl: remove first ethernet port

Michal Luczaj (1):
      KVM: x86/emulator: Fix handing of POP SS to correctly set interruptibility

Mike Pattrick (2):
      openvswitch: Fix double reporting of drops in dropwatch
      openvswitch: Fix overreporting of drops in dropwatch

Nathan Chancellor (1):
      powerpc/math_emu/efp: Include module.h

Neal Cardwell (1):
      tcp: fix tcp_cwnd_validate() to not forget is_cwnd_limited

Niklas Cassel (4):
      ata: fix ata_id_sense_reporting_enabled() and ata_id_has_sense_reporting()
      ata: fix ata_id_has_devslp()
      ata: fix ata_id_has_ncq_autosense()
      ata: fix ata_id_has_dipm()

Nuno Sá (1):
      iio: inkern: only release the device node when done with it

Pali Rohár (2):
      serial: 8250: Fix restoring termios speed after suspend
      powerpc: Fix SPE Power ISA properties for e500v1 platforms

Pavel Rojtberg (1):
      Input: xpad - add supported devices as contributed on github

Peilin Ye (1):
      usbnet: Fix memory leak in usbnet_disconnect()

Rafael J. Wysocki (1):
      thermal: intel_powerclamp: Use first online CPU as control_cpu

Robin Guo (1):
      usb: musb: Fix musb_gadget.c rxstate overflow bug

Russell King (1):
      ARM: fix function graph tracer and unwinder dependencies

Ryusuke Konishi (4):
      nilfs2: fix NULL pointer dereference at nilfs_bmap_lookup_at_level()
      nilfs2: fix leak of nilfs_root in case of writer thread creation failure
      nilfs2: replace WARN_ONs by nilfs_error for checkpoint acquisition failure
      nilfs2: fix use-after-free bug of struct nilfs_root

Sami Tolvanen (1):
      Makefile.extrawarn: Move -Wcast-function-type-strict to W=1

Sergei Antonov (2):
      mmc: moxart: fix 4-bit bus width and remove 8-bit bus width
      ARM: dts: fix Moxa SDIO 'compatible', remove 'sdhci' misnomer

Shubhrajyoti Datta (1):
      tty: xilinx_uartps: Fix the ignore_status

Srinivas Pandruvada (1):
      thermal: intel_powerclamp: Use get_cpu() instead of smp_processor_id() to avoid crash

Stefan Wahren (1):
      clk: bcm2835: fix bcm2835_clock_rate_from_divisor declaration

Steven Rostedt (Google) (3):
      ring-buffer: Allow splice to read previous partially read pages
      ring-buffer: Check pending waiters when doing wake ups as well
      ring-buffer: Fix race between reset page and reading page

Swati Agarwal (2):
      dmaengine: xilinx_dma: cleanup for fetching xlnx,num-fstores property
      dmaengine: xilinx_dma: Report error in case of dma_set_mask_and_coherent API failure

Tadeusz Struk (1):
      usb: mon: make mmapped memory read only

Takashi Iwai (5):
      ALSA: hda: Fix position reporting on Poulsbo
      ALSA: oss: Fix potential deadlock at unregistration
      ALSA: rawmidi: Drop register_mutex in snd_rawmidi_free()
      ALSA: usb-audio: Fix potential memory leaks
      ALSA: usb-audio: Fix NULL dererence at error path

Tetsuo Handa (3):
      net: rds: don't hold sock lock when cancelling work from rds_tcp_reset_callbacks()
      Bluetooth: L2CAP: initialize delayed works at l2cap_chan_create()
      net/ieee802154: don't warn zero-sized raw_sendmsg()

Wang Yufen (1):
      selftests: Fix the if conditions of in test_extra_filter()

Wen Gong (1):
      wifi: ath10k: add peer map clean up for peer delete in ath10k_sta_state()

Xu Qiang (2):
      spi: qup: add missing clk_disable_unprepare on error in spi_qup_resume()
      spi: qup: add missing clk_disable_unprepare on error in spi_qup_pm_resume_runtime()

Yang Yingliang (1):
      Input: melfas_mip4 - fix return value check in mip4_probe()

Zhang Qilong (2):
      spi/omap100k:Fix PM disable depth imbalance in omap1_spi100k_probe
      f2fs: fix race condition on setting FI_NO_EXTENT flag

Zheng Yongjun (1):
      net: fs_enet: Fix wrong check in do_pd_setup

Zheyu Ma (1):
      media: cx88: Fix a null-ptr-deref bug in buffer_prepare()

Zhihao Cheng (1):
      quota: Check next/prev free block number after reading from quota file

Zhu Yanjun (2):
      RDMA/rxe: Fix "kernel NULL pointer dereference" error
      RDMA/rxe: Fix the error caused by qp->sk

Ziyang Xuan (1):
      can: bcm: check the result of can_send() in bcm_can_tx()

hongao (1):
      drm/amdgpu: fix initial connector audio value

sunghwan jung (1):
      Revert "usb: storage: Add quirk for Samsung Fit flash"

