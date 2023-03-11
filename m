Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C91E46B5D71
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 16:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbjCKPtn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 10:49:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCKPtm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 10:49:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D3FE20CA;
        Sat, 11 Mar 2023 07:49:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9BCE60C83;
        Sat, 11 Mar 2023 15:49:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2246C433EF;
        Sat, 11 Mar 2023 15:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678549778;
        bh=UlL1moaC10kKaPM5FW+gt1CK4ysCNMRDPcKQSfAg9bc=;
        h=From:To:Cc:Subject:Date:From;
        b=0MXXakis0WxRXT50kn9s3OYzMHR1mJxwUOtoP9K3W8KUWVs+8S2b1dTsj6NDyPm66
         Kv47S8xQrbh+gagj9XDS7jXUINPovKg65xtH2Mwvn8GD2WDqeceW4jUxy0JK8y+0cW
         YK5Xbn6wzCvUzay71sE5FIgXI1dmXiUeWAYvwz3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.308
Date:   Sat, 11 Mar 2023 16:49:34 +0100
Message-Id: <1678549774167165@kroah.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.308 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/hw-vuln/spectre.rst             |   21 
 Documentation/dev-tools/gdb-kernel-debugging.rst          |    4 
 Makefile                                                  |   15 
 arch/alpha/kernel/traps.c                                 |   30 
 arch/arm/boot/dts/exynos3250-rinato.dts                   |    2 
 arch/arm/boot/dts/exynos4-cpu-thermal.dtsi                |    2 
 arch/arm/boot/dts/exynos5410-odroidxu.dts                 |    1 
 arch/arm/boot/dts/exynos5420.dtsi                         |    2 
 arch/arm/boot/dts/rk3288.dtsi                             |    1 
 arch/arm/boot/dts/spear320-hmi.dts                        |    2 
 arch/arm/mach-omap1/timer.c                               |    2 
 arch/arm/mach-omap2/timer.c                               |    1 
 arch/arm/mach-zynq/slcr.c                                 |    1 
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi                 |    6 
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi                |    2 
 arch/m68k/68000/entry.S                                   |    2 
 arch/m68k/Kconfig.devices                                 |    1 
 arch/m68k/coldfire/entry.S                                |    2 
 arch/m68k/kernel/entry.S                                  |    3 
 arch/mips/include/asm/syscall.h                           |    2 
 arch/mips/include/asm/vpe.h                               |    1 
 arch/mips/kernel/vpe-mt.c                                 |    7 
 arch/mips/lantiq/prom.c                                   |    6 
 arch/powerpc/platforms/powernv/pci-ioda.c                 |    3 
 arch/powerpc/platforms/pseries/lparcfg.c                  |   20 
 arch/s390/kernel/kprobes.c                                |    4 
 arch/s390/kernel/setup.c                                  |    1 
 arch/s390/mm/maccess.c                                    |   16 
 arch/x86/include/asm/microcode.h                          |    4 
 arch/x86/include/asm/microcode_amd.h                      |    4 
 arch/x86/include/asm/msr-index.h                          |    4 
 arch/x86/include/asm/reboot.h                             |    2 
 arch/x86/include/asm/virtext.h                            |   16 
 arch/x86/kernel/cpu/bugs.c                                |   35 
 arch/x86/kernel/cpu/microcode/amd.c                       |   53 -
 arch/x86/kernel/cpu/microcode/core.c                      |    6 
 arch/x86/kernel/crash.c                                   |   17 
 arch/x86/kernel/kprobes/opt.c                             |    6 
 arch/x86/kernel/reboot.c                                  |   88 +
 arch/x86/kernel/smp.c                                     |    6 
 arch/x86/kernel/sysfb_efi.c                               |    8 
 arch/x86/um/vdso/um_vdso.c                                |   12 
 block/bio-integrity.c                                     |    1 
 crypto/rsa-pkcs1pad.c                                     |   34 
 crypto/seqiv.c                                            |    2 
 drivers/acpi/acpica/Makefile                              |    2 
 drivers/acpi/acpica/nsrepair.c                            |   12 
 drivers/acpi/battery.c                                    |    2 
 drivers/acpi/video_detect.c                               |    2 
 drivers/block/rbd.c                                       |   20 
 drivers/cpufreq/davinci-cpufreq.c                         |    4 
 drivers/dma/sh/rcar-dmac.c                                |    5 
 drivers/gpio/gpio-vf610.c                                 |    2 
 drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c  |    6 
 drivers/gpu/drm/drm_mipi_dsi.c                            |   52 +
 drivers/gpu/drm/mediatek/mtk_drm_gem.c                    |    2 
 drivers/gpu/drm/msm/dsi/dsi_host.c                        |    3 
 drivers/gpu/drm/msm/hdmi/hdmi.c                           |    4 
 drivers/gpu/drm/mxsfb/Kconfig                             |    1 
 drivers/gpu/drm/radeon/atombios_encoders.c                |    5 
 drivers/gpu/drm/radeon/radeon_device.c                    |    1 
 drivers/gpu/ipu-v3/ipu-common.c                           |    1 
 drivers/hid/hid-asus.c                                    |   38 
 drivers/hwmon/ltc2945.c                                   |    2 
 drivers/iio/accel/mma9551_core.c                          |   10 
 drivers/infiniband/hw/hfi1/user_exp_rcv.c                 |    9 
 drivers/input/touchscreen/ads7846.c                       |   13 
 drivers/irqchip/irq-alpine-msi.c                          |    1 
 drivers/irqchip/irq-bcm7120-l2.c                          |    3 
 drivers/irqchip/irq-mvebu-gicp.c                          |    1 
 drivers/md/dm-cache-target.c                              |    4 
 drivers/md/dm-flakey.c                                    |   30 
 drivers/md/dm-thin.c                                      |    2 
 drivers/md/dm.c                                           |    1 
 drivers/media/platform/omap3isp/isp.c                     |    9 
 drivers/media/rc/ene_ir.c                                 |    3 
 drivers/media/usb/siano/smsusb.c                          |    1 
 drivers/media/usb/uvc/uvc_entity.c                        |    2 
 drivers/mfd/pcf50633-adc.c                                |    7 
 drivers/mtd/nand/sunxi_nand.c                             |    2 
 drivers/mtd/ubi/build.c                                   |    7 
 drivers/mtd/ubi/vmt.c                                     |   18 
 drivers/mtd/ubi/wl.c                                      |   25 
 drivers/net/can/usb/esd_usb2.c                            |    4 
 drivers/net/ethernet/broadcom/genet/bcmgenet.c            |    8 
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c       |    3 
 drivers/net/wireless/ath/ath9k/htc_hst.c                  |    4 
 drivers/net/wireless/ath/ath9k/wmi.c                      |    1 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c |    1 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c   |    1 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c |    5 
 drivers/net/wireless/intel/ipw2x00/ipw2200.c              |    9 
 drivers/net/wireless/intersil/orinoco/hw.c                |    2 
 drivers/net/wireless/marvell/libertas/cmdresp.c           |    2 
 drivers/net/wireless/marvell/libertas/main.c              |    3 
 drivers/net/wireless/marvell/mwifiex/11n.c                |    6 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c    |    5 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c     |   11 
 drivers/net/wireless/wl3501_cs.c                          |    2 
 drivers/nfc/st-nci/se.c                                   |    6 
 drivers/nfc/st21nfca/se.c                                 |    6 
 drivers/pci/quirks.c                                      |    1 
 drivers/phy/rockchip/phy-rockchip-typec.c                 |    3 
 drivers/pinctrl/pinctrl-at91-pio4.c                       |    4 
 drivers/pinctrl/pinctrl-at91.c                            |    2 
 drivers/pinctrl/pinctrl-rockchip.c                        |    1 
 drivers/pwm/pwm-stm32-lp.c                                |    2 
 drivers/regulator/max77802-regulator.c                    |   34 
 drivers/regulator/s5m8767.c                               |    6 
 drivers/rpmsg/qcom_glink_native.c                         |    1 
 drivers/rtc/rtc-pm8xxx.c                                  |   24 
 drivers/scsi/aic94xx/aic94xx_task.c                       |    3 
 drivers/scsi/ipr.c                                        |   41 
 drivers/scsi/qla2xxx/qla_os.c                             |    9 
 drivers/scsi/ses.c                                        |   64 -
 drivers/spi/spi-bcm63xx-hsspi.c                           |   12 
 drivers/thermal/intel_powerclamp.c                        |   20 
 drivers/thermal/intel_quark_dts_thermal.c                 |   12 
 drivers/thermal/intel_soc_dts_iosf.c                      |    2 
 drivers/tty/serial/fsl_lpuart.c                           |   24 
 drivers/tty/tty_io.c                                      |    8 
 drivers/usb/core/hub.c                                    |    5 
 drivers/usb/core/sysfs.c                                  |    5 
 drivers/usb/host/xhci-mvebu.c                             |    2 
 drivers/usb/serial/option.c                               |    4 
 drivers/usb/storage/ene_ub6250.c                          |    2 
 drivers/watchdog/at91sam9_wdt.c                           |    7 
 drivers/watchdog/pcwd_usb.c                               |    6 
 drivers/watchdog/watchdog_dev.c                           |    2 
 fs/btrfs/send.c                                           |    6 
 fs/ext4/xattr.c                                           |   35 
 fs/f2fs/inline.c                                          |   13 
 fs/hfs/bnode.c                                            |    1 
 fs/hfsplus/super.c                                        |    4 
 fs/jfs/jfs_dmap.c                                         |    3 
 fs/ocfs2/move_extents.c                                   |   34 
 fs/ubifs/budget.c                                         |    9 
 fs/ubifs/dir.c                                            |    5 
 fs/ubifs/file.c                                           |   12 
 fs/ubifs/tnc.c                                            |   24 
 fs/udf/file.c                                             |   26 
 fs/udf/inode.c                                            |   58 -
 fs/udf/udf_sb.h                                           |    2 
 include/drm/drm_mipi_dsi.h                                |    4 
 include/linux/filter.h                                    |   24 
 include/linux/ima.h                                       |    6 
 include/linux/kernel_stat.h                               |    2 
 include/linux/kprobes.h                                   |    2 
 include/uapi/linux/usb/video.h                            |   30 
 kernel/bpf/core.c                                         |   39 
 kernel/bpf/verifier.c                                     |   39 
 kernel/irq/irqdomain.c                                    |   31 
 kernel/kprobes.c                                          |    6 
 kernel/rcu/tree_exp.h                                     |    2 
 kernel/time/hrtimer.c                                     |    2 
 kernel/time/posix-stubs.c                                 |    2 
 kernel/time/posix-timers.c                                |    2 
 kernel/trace/ring_buffer.c                                |    7 
 lib/mpi/mpicoder.c                                        |    3 
 net/9p/trans_xen.c                                        |   48 
 net/bluetooth/hci_sock.c                                  |   11 
 net/bluetooth/l2cap_core.c                                |   24 
 net/bluetooth/l2cap_sock.c                                |    8 
 net/caif/caif_socket.c                                    |    1 
 net/core/dev.c                                            |    4 
 net/core/filter.c                                         |    9 
 net/core/stream.c                                         |    1 
 net/ipv4/inet_connection_sock.c                           |    1 
 net/ipv4/inet_hashtables.c                                |   12 
 net/ipv4/tcp_minisocks.c                                  |    7 
 net/netfilter/nf_conntrack_netlink.c                      |    5 
 net/nfc/netlink.c                                         |    4 
 net/sched/Kconfig                                         |   11 
 net/sched/Makefile                                        |    1 
 net/sched/cls_tcindex.c                                   |  690 --------------
 net/wireless/sme.c                                        |   31 
 security/integrity/ima/ima_main.c                         |    7 
 security/security.c                                       |    7 
 sound/pci/hda/patch_ca0132.c                              |    2 
 sound/pci/ice1712/aureon.c                                |    2 
 sound/soc/kirkwood/kirkwood-dma.c                         |    2 
 sound/soc/soc-compress.c                                  |    2 
 tools/iio/iio_utils.c                                     |   23 
 tools/testing/ktest/ktest.pl                              |    3 
 184 files changed, 1164 insertions(+), 1340 deletions(-)

Al Viro (1):
      alpha: fix FEN fault handling

Alan Stern (1):
      USB: core: Don't hold device lock while reading the "descriptors" sysfs file

Alexander Wetzel (1):
      wifi: cfg80211: Fix use after free for wext

Alexey Kodanev (1):
      wifi: orinoco: check return value of hermes_write_wordrec()

Alexey V. Vissarionov (1):
      ALSA: hda/ca0132: minor fix for allocation size

Ammar Faizi (1):
      x86: um: vdso: Add '%rcx' and '%r11' to the syscall clobber list

Armin Wolf (1):
      ACPI: battery: Fix missing NUL-termination with large strings

Arnd Bergmann (1):
      scsi: ipr: Work around fortify-string warning

Bitterblue Smith (1):
      wifi: rtl8xxxu: Use a longer retry limit of 48

Bjorn Andersson (1):
      rpmsg: glink: Avoid infinite loop on intent for missing channel

Borislav Petkov (AMD) (3):
      x86/microcode/amd: Remove load_microcode_amd()'s bsp parameter
      x86/microcode/AMD: Add a @cpu parameter to the reloading functions
      x86/microcode/AMD: Fix mixed steppings support

Breno Leitao (1):
      x86/bugs: Reset speculation control settings on init

Chen Hui (1):
      ARM: OMAP2+: Fix memory leak in realtime_counter_init()

Chen Jun (1):
      watchdog: Fix kmemleak in watchdog_cdev_register

Claudiu Beznea (1):
      pinctrl: at91: use devm_kasprintf() to avoid potential leaks

Damien Le Moal (1):
      PCI: Avoid FLR for AMD FCH AHCI adapters

Dan Carpenter (2):
      wifi: mwifiex: fix loop iterator in mwifiex_update_ampdu_txwinsize()
      thermal: intel: quark_dts: fix error pointer dereference

Daniel Borkmann (4):
      bpf: Do not use ax register in interpreter on div/mod
      bpf: fix subprog verifier bypass by div/mod by 0 exception
      bpf: Fix 32 bit src register truncation on div/mod
      bpf: Fix truncation handling for mod32 dst reg wrt zero

Daniel Mentz (1):
      drm/mipi-dsi: Fix byte order of 16-bit DCS set/get brightness

Daniel Scally (1):
      usb: uvc: Enumerate valid values for color matching

Daniil Tatianin (1):
      ACPICA: nsrepair: handle cases without a return value correctly

Darrell Kavanagh (1):
      firmware/efi sysfb_efi: Add quirk for Lenovo IdeaPad Duet 3

David Sterba (1):
      btrfs: send: limit number of clones and allocated memory size

Dean Luick (1):
      IB/hfi1: Assign npages earlier

Dmitry Fomin (1):
      ALSA: ice1712: Do not left ice->gpio_mutex locked in aureon_add_controls()

Dmitry Goncharov (1):
      kbuild: Port silent mode detection to future gnu make.

Dongliang Mu (1):
      fs: hfsplus: fix UAF issue in hfsplus_put_super

Duoming Zhou (2):
      media: rc: Fix use-after-free bugs caused by ene_tx_irqsim()
      media: usb: siano: Fix use after free bugs caused by do_submit_urb

Elvira Khabirova (1):
      mips: fix syscall_get_nr

Eric Biggers (1):
      f2fs: fix information leak in f2fs_move_inline_dirents()

Eric Dumazet (2):
      net: fix __dev_kfree_skb_any() vs drop monitor
      tcp: tcp_check_req() can be called from process context

Fabrice Gasnier (1):
      pwm: stm32-lp: fix the check on arr and cmp registers update

Fedor Pchelkin (2):
      wifi: ath9k: htc_hst: free skb in ath9k_htc_rx_msg() if there is no callback function
      nfc: fix memory leak of se_io context in nfc_genl_se_io

Florian Fainelli (2):
      irqchip/irq-bcm7120-l2: Set IRQ_LEVEL for level triggered interrupts
      net: bcmgenet: Add a check for oversized packets

Florian Zumbiehl (1):
      USB: serial: option: add support for VW/Skoda "Carstick LTE"

Frank Jungclaus (1):
      can: esd_usb: Move mislocated storage of SJA1000_ECC_SEG bits in case of a bus error

Frederic Barrat (1):
      powerpc/powernv/ioda: Skip unallocated resources when mapping to PE

Geert Uytterhoeven (1):
      drm: mxsfb: DRM_MXSFB should depend on ARCH_MXS || ARCH_MXC

George Kennedy (1):
      ubi: ensure that VID header offset + VID header size <= alloc, size

Greg Kroah-Hartman (1):
      Linux 4.14.308

Haibo Chen (1):
      gpio: vf610: connect GPIO label to dev name

Hangyu Hua (1):
      netfilter: ctnetlink: fix possible refcount leak in ctnetlink_create_conntrack()

Hans de Goede (1):
      ACPI: video: Fix Lenovo Ideapad Z570 DMI match

Harshit Mogalapalli (2):
      iio: accel: mma9551_core: Prevent uninitialized variable in mma9551_read_status_word()
      iio: accel: mma9551_core: Prevent uninitialized variable in mma9551_read_config_word()

Heming Zhao via Ocfs2-devel (2):
      ocfs2: fix defrag path triggering jbd2 ASSERT
      ocfs2: fix non-auto defrag path not working issue

Herbert Xu (3):
      lib/mpi: Fix buffer overrun when SG is too long
      crypto: seqiv - Handle EBUSY correctly
      crypto: rsa-pkcs1pad - Use akcipher_request_complete

Ilya Dryomov (1):
      rbd: avoid use-after-free in do_rbd_add() when rbd_dev_create() fails

Jack Morgenstein (1):
      net/mlx5: Enhance debug print in page allocation failure

Jakob Koschel (1):
      docs/scripts/gdb: add necessary make scripts_gdb step

Jamal Hadi Salim (1):
      net/sched: Retire tcindex classifier

James Bottomley (1):
      scsi: ses: Don't attach if enclosure has no components

Jan Kara (5):
      udf: Define EFSCORRUPTED error code
      udf: Truncate added extents on failed expansion
      udf: Do not bother merging very long extents
      udf: Do not update file length for failed writes to inline files
      udf: Fix file corruption when appending just after end of preallocated extent

Jann Horn (1):
      timers: Prevent union confusion from unexpected restart_syscall()

Jia-Ju Bai (1):
      tracing: Add NULL checks for buffer in ring_buffer_free_read_page()

Jiapeng Chong (1):
      phy: rockchip-typec: Fix unsigned comparison with less than zero

Jiasheng Jiang (5):
      dmaengine: sh: rcar-dmac: Check for error num after dma_set_max_seg_size
      drm/msm/hdmi: Add missing check for alloc_ordered_workqueue
      scsi: aic94xx: Add missing check for dma_map_single()
      media: platform: ti: Add missing check for devm_regulator_get
      drm/msm/dsi: Add missing check for alloc_ordered_workqueue

Jisoo Jang (1):
      wifi: brcmfmac: Fix potential stack-out-of-bounds in brcmf_c_preinit_dcmds()

Johan Hovold (4):
      rtc: pm8xxx: fix set-alarm race
      irqdomain: Fix association race
      irqdomain: Fix disassociation race
      irqdomain: Drop bogus fwspec-mapping error handling

Johan Jonker (1):
      ARM: dts: rockchip: add power-domains property to dp node on rk3288

Jonathan Cormier (1):
      hwmon: (ltc2945) Handle error case in ltc2945_value_store

Juergen Gross (2):
      9p/xen: fix version parsing
      9p/xen: fix connection sequence

Jun ASAKA (1):
      wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu

Jun Nie (2):
      ext4: optimize ea_inode block expansion
      ext4: refuse to create ea block when umounted

KP Singh (2):
      x86/speculation: Allow enabling STIBP with legacy IBRS
      Documentation/hw-vuln: Document the interaction between IBRS and STIBP

Kees Cook (5):
      ASoC: kirkwood: Iterate over array indexes instead of using pointer math
      regulator: max77802: Bounds check regulator id against opmode
      regulator: s5m8767: Bounds check id indexing into arrays
      usb: host: xhci: mvebu: Iterate over array indexes instead of using pointer math
      USB: ene_usb6250: Allocate enough memory for full object

Krzysztof Kozlowski (4):
      ARM: dts: exynos: correct wr-active property in Exynos3250 Rinato
      ARM: dts: exynos: correct TMU phandle in Exynos4
      ARM: dts: exynos: correct TMU phandle in Odroid XU
      ARM: dts: spear320-hmi: correct STMPE GPIO compatible

Kuninori Morimoto (1):
      ASoC: soc-compress.c: fixup private_data on snd_soc_new_compress()

Kuniyuki Iwashima (2):
      net: Remove WARN_ON_ONCE(sk->sk_forward_alloc) from sk_stream_kill_queues().
      tcp: Fix listen() regression in 4.14.303.

Li Hua (1):
      watchdog: pcwd_usb: Fix attempting to access uninitialized memory

Li Zetao (2):
      ubi: Fix use-after-free when volume resizing failed
      ubi: Fix unreferenced object reported by kmemleak in ubi_resize_volume()

Liang He (1):
      gpu: ipu-v3: common: Add of_node_put() for reference returned by of_graph_get_port_by_id()

Liu Shixin (1):
      hfs: fix missing hfs_bnode_get() in __hfs_bnode_create

Liu Shixin via Jfs-discussion (1):
      fs/jfs: fix shift exponent db_agl2size negative

Liwei Song (1):
      drm/radeon: free iio for atombios when driver shutdown

Luca Ellero (2):
      Input: ads7846 - don't report pressure for ads7845
      Input: ads7846 - don't check penirq immediately for 7845

Luiz Augusto von Dentz (1):
      Bluetooth: L2CAP: Fix potential user-after-free

Luke D. Jones (1):
      HID: asus: Remove check for same LED brightness on set

Mark Hawrylak (1):
      drm/radeon: Fix eDP for single-display iMac11,2

Mark Rutland (1):
      ACPI: Don't build ACPICA with '-Os'

Markuss Broks (1):
      ARM: dts: exynos: Use Exynos5420 compatible for the MIPI video phy

Martin Blumenstingl (2):
      arm64: dts: meson-gx: Fix Ethernet MAC address unit name
      arm64: dts: meson-gx: Fix the SCPI DVFS node name and unit address

Martin K. Petersen (1):
      block: bio-integrity: Copy flags when bio_integrity_payload is cloned

Miaoqian Lin (3):
      irqchip/alpine-msi: Fix refcount leak in alpine_msix_init_domains
      irqchip/irq-mvebu-gicp: Fix refcount leak in mvebu_gicp_probe
      pinctrl: rockchip: Fix refcount leak in rockchip_pinctrl_parse_groups

Michael Schmitz (1):
      m68k: Check syscall_trace_enter() return code

Mike Snitzer (3):
      dm: remove flush_scheduled_work() during local_exit()
      dm thin: add cond_resched() to various workqueue loops
      dm cache: add cond_resched() to various workqueue loops

Mikulas Patocka (2):
      dm flakey: fix logic when corrupting a bio
      dm flakey: don't corrupt the zero page

Minsuk Kang (1):
      wifi: ath9k: Fix potential stack-out-of-bounds write in ath9k_wmi_rsp_callback()

Nathan Lynch (1):
      powerpc/pseries/lparcfg: add missing RTAS retry status handling

Neil Armstrong (3):
      arm64: dts: amlogic: meson-gx: fix SCPI clock dvfs node name
      arm64: dts: amlogic: meson-gx: add missing unit address to rng node name
      arm64: dts: amlogic: meson-gxl: add missing unit address to eth-phy-mux node name

Nguyen Dinh Phi (1):
      Bluetooth: hci_sock: purge socket queues in the destruct() callback

Paul E. McKenney (1):
      rcu: Suppress smp_processor_id() complaint in synchronize_rcu_expedited_wait()

Pietro Borrello (3):
      HID: asus: use spinlock to protect concurrent accesses
      HID: asus: use spinlock to safely schedule workers
      inet: fix fast path in __inet_hash_connect()

Qiheng Lin (2):
      ARM: zynq: Fix refcount leak in zynq_early_slcr_init
      mfd: pcf50633-adc: Fix potential memleak in pcf50633_adc_async_read()

Quinn Tran (2):
      scsi: qla2xxx: Fix link failure in NPIV environment
      scsi: qla2xxx: Fix erroneous link down

Randy Dunlap (2):
      m68k: /proc/hardware should depend on PROC_FS
      MIPS: vpe-mt: drop physical_memsize

Ricardo Ribalda (1):
      media: uvcvideo: Handle cameras with invalid descriptors

Rob Clark (1):
      drm/mediatek: Drop unbalanced obj unref

Roberto Sassu (1):
      ima: Align ima_file_mmap() parameters with mmap_file LSM hook

Samuel Holland (1):
      mtd: rawnand: sunxi: Fix the size of the last OOB region

Sean Christopherson (4):
      x86/virt: Force GIF=1 prior to disabling SVM (for reboot flows)
      x86/crash: Disable virt in core NMI crash handler to avoid double shootdown
      x86/reboot: Disable virtualization in an emergency if SVM is supported
      x86/reboot: Disable SVM, not just VMX, when stopping CPUs

Sherry Sun (1):
      tty: serial: fsl_lpuart: disable the CTS when send break signal

Srinivas Pandruvada (1):
      thermal: intel: powerclamp: Fix cur_state for multi package system

Steven Rostedt (1):
      ktest.pl: Fix missing "end_monitor" when machine check fails

Sven Schnelle (1):
      tty: fix out-of-bounds access in tty_driver_lookup_tty()

Tomas Henzl (4):
      scsi: ses: Fix slab-out-of-bounds in ses_enclosure_data_process()
      scsi: ses: Fix possible addl_desc_ptr out-of-bounds accesses
      scsi: ses: Fix possible desc_ptr out-of-bounds accesses
      scsi: ses: Fix slab-out-of-bounds in ses_intf_remove()

Uwe Kleine-König (1):
      cpufreq: davinci: Fix clk use after free

Vasily Gorbik (4):
      s390/kprobes: fix irq mask clobbering on kprobe reenter from post_handler
      s390/kprobes: fix current_kprobe never cleared after kprobes reenter
      s390/maccess: add no DAT mode to kernel_write
      s390/setup: init jump labels before command line parsing

William Zhang (1):
      spi: bcm63xx-hsspi: Fix multi-bit mode setting

Yang Jihong (2):
      x86/kprobes: Fix __recover_optprobed_insn check optimizing logic
      x86/kprobes: Fix arch_check_optimized_kprobe check within optimized_kprobe range

Yang Li (1):
      thermal: intel: Fix unsigned comparison with less than zero

Yang Yingliang (6):
      ARM: OMAP1: call platform_device_put() in error case in omap1_dm_timer_init()
      wifi: rtl8xxxu: don't call dev_kfree_skb() under spin_lock_irqsave()
      wifi: libertas: main: don't call kfree_skb() under spin_lock_irqsave()
      wifi: libertas: cmdresp: don't call kfree_skb() under spin_lock_irqsave()
      wifi: wl3501_cs: don't call kfree_skb() under spin_lock_irqsave()
      ubi: Fix possible null-ptr-deref in ubi_free_volume()

Yuan Can (1):
      drm/bridge: megachips: Fix error handling in i2c_register_driver()

Yulong Zhang (1):
      tools/iio/iio_utils:fix memory leak

Zhang Changzhong (1):
      wifi: brcmfmac: fix potential memory leak in brcmf_netdev_start_xmit()

Zhen Lei (1):
      genirq: Fix the return type of kstat_cpu_irqs_sum()

Zhengchao Shao (3):
      wifi: libertas: fix memory leak in lbs_init_adapter()
      wifi: ipw2200: fix memory leak in ipw_wdev_init()
      wifi: brcmfmac: unmap dma buffer in brcmf_msgbuf_alloc_pktid()

Zhihao Cheng (8):
      ubifs: Rectify space budget for ubifs_xrename()
      ubifs: Fix wrong dirty space budget for dirty inode
      ubifs: Reserve one leb for each journal head while doing budget
      ubifs: Re-statistic cleaned znode count if commit failed
      ubifs: dirty_cow_znode: Fix memleak in error handling path
      ubifs: ubifs_writepage: Mark page dirty after writing inode failed
      ubi: Fix UAF wear-leveling entry in eraseblk_count_seq_show()
      ubi: ubi_wl_put_peb: Fix infinite loop when wear-leveling work failed

ruanjinjie (1):
      watchdog: at91sam9_wdt: use devm_request_irq to avoid missing free_irq() in error path

