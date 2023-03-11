Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D55A26B5D75
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 16:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjCKPuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 10:50:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbjCKPt6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 10:49:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD612EB89E;
        Sat, 11 Mar 2023 07:49:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55829B82570;
        Sat, 11 Mar 2023 15:49:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2BDC4339B;
        Sat, 11 Mar 2023 15:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678549786;
        bh=JPZm0vNUHVHhTDSLHYtBja1i66yveAWRq9FZ7Xkkau0=;
        h=From:To:Cc:Subject:Date:From;
        b=UjLfeMPML3QIWPJ+7pOE4ickERzgrtT7y4Dsp7pp3Yq688oQ7YCJgxVk/sTFY+AuQ
         XxZjjmqNlkE8y1eiYcQgSRtXSiCHhJ6hXJhBqotog5LAj1H5iS4ZhD/MUDdoq2oFQ/
         Qk9oA6TQXuZ2soFVZTv+yhyz1143dpEOw4sCdKKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.276
Date:   Sat, 11 Mar 2023 16:49:39 +0100
Message-Id: <1678549779155207@kroah.com>
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

I'm announcing the release of the 4.19.276 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/hw-vuln/spectre.rst                       |   21 
 Documentation/dev-tools/gdb-kernel-debugging.rst                    |    4 
 Makefile                                                            |   15 
 arch/alpha/kernel/traps.c                                           |   30 
 arch/arm/boot/dts/exynos3250-rinato.dts                             |    2 
 arch/arm/boot/dts/exynos4-cpu-thermal.dtsi                          |    2 
 arch/arm/boot/dts/exynos4.dtsi                                      |    2 
 arch/arm/boot/dts/exynos5410-odroidxu.dts                           |    1 
 arch/arm/boot/dts/exynos5420.dtsi                                   |    2 
 arch/arm/boot/dts/spear320-hmi.dts                                  |    2 
 arch/arm/mach-imx/mmdc.c                                            |   24 
 arch/arm/mach-omap1/timer.c                                         |    2 
 arch/arm/mach-omap2/timer.c                                         |    1 
 arch/arm/mach-zynq/slcr.c                                           |    1 
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi                          |   26 
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi                           |    6 
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi                          |    2 
 arch/arm64/boot/dts/mediatek/mt7622.dtsi                            |    1 
 arch/m68k/68000/entry.S                                             |    2 
 arch/m68k/Kconfig.devices                                           |    1 
 arch/m68k/coldfire/entry.S                                          |    2 
 arch/m68k/kernel/entry.S                                            |    3 
 arch/mips/include/asm/syscall.h                                     |    2 
 arch/mips/include/asm/vpe.h                                         |    1 
 arch/mips/kernel/vpe-mt.c                                           |    7 
 arch/mips/lantiq/prom.c                                             |    6 
 arch/powerpc/Makefile                                               |    2 
 arch/powerpc/kernel/rtas.c                                          |   24 
 arch/powerpc/platforms/powernv/pci-ioda.c                           |    3 
 arch/powerpc/platforms/pseries/lparcfg.c                            |   20 
 arch/riscv/kernel/time.c                                            |    3 
 arch/s390/kernel/kprobes.c                                          |    4 
 arch/s390/kernel/setup.c                                            |    1 
 arch/s390/kernel/vmlinux.lds.S                                      |    1 
 arch/s390/mm/maccess.c                                              |   16 
 arch/sparc/Kconfig                                                  |    2 
 arch/um/drivers/vector_kern.c                                       |    1 
 arch/x86/include/asm/microcode.h                                    |    4 
 arch/x86/include/asm/microcode_amd.h                                |    4 
 arch/x86/include/asm/msr-index.h                                    |    4 
 arch/x86/include/asm/reboot.h                                       |    2 
 arch/x86/include/asm/virtext.h                                      |   16 
 arch/x86/kernel/cpu/bugs.c                                          |   35 
 arch/x86/kernel/cpu/microcode/amd.c                                 |   53 
 arch/x86/kernel/cpu/microcode/core.c                                |    6 
 arch/x86/kernel/crash.c                                             |   17 
 arch/x86/kernel/kprobes/opt.c                                       |    6 
 arch/x86/kernel/reboot.c                                            |   88 -
 arch/x86/kernel/smp.c                                               |    6 
 arch/x86/kernel/sysfb_efi.c                                         |    8 
 arch/x86/um/vdso/um_vdso.c                                          |   12 
 block/bio-integrity.c                                               |    1 
 block/blk-mq-sched.c                                                |    3 
 crypto/rsa-pkcs1pad.c                                               |   34 
 crypto/seqiv.c                                                      |    2 
 drivers/acpi/acpica/Makefile                                        |    2 
 drivers/acpi/acpica/hwvalid.c                                       |    7 
 drivers/acpi/acpica/nsrepair.c                                      |   12 
 drivers/acpi/battery.c                                              |    2 
 drivers/acpi/video_detect.c                                         |    2 
 drivers/block/rbd.c                                                 |   20 
 drivers/clk/clk.c                                                   |   11 
 drivers/crypto/amcc/crypto4xx_core.c                                |   10 
 drivers/firmware/google/framebuffer-coreboot.c                      |    4 
 drivers/gpio/gpio-vf610.c                                           |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                   |    6 
 drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c            |    6 
 drivers/gpu/drm/drm_mipi_dsi.c                                      |   52 
 drivers/gpu/drm/mediatek/mtk_drm_drv.c                              |    1 
 drivers/gpu/drm/mediatek/mtk_drm_gem.c                              |    2 
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c                            |    2 
 drivers/gpu/drm/msm/dsi/dsi_host.c                                  |    3 
 drivers/gpu/drm/msm/hdmi/hdmi.c                                     |    4 
 drivers/gpu/drm/msm/msm_fence.c                                     |    2 
 drivers/gpu/drm/mxsfb/Kconfig                                       |    1 
 drivers/gpu/drm/radeon/atombios_encoders.c                          |    5 
 drivers/gpu/drm/radeon/radeon_device.c                              |    1 
 drivers/gpu/drm/vc4/vc4_dpi.c                                       |   66 
 drivers/gpu/host1x/hw/syncpt_hw.c                                   |    3 
 drivers/gpu/ipu-v3/ipu-common.c                                     |    1 
 drivers/hid/hid-asus.c                                              |   38 
 drivers/hwmon/ltc2945.c                                             |    2 
 drivers/hwmon/mlxreg-fan.c                                          |    6 
 drivers/iio/accel/mma9551_core.c                                    |   10 
 drivers/input/touchscreen/ads7846.c                                 |   13 
 drivers/irqchip/irq-alpine-msi.c                                    |    1 
 drivers/irqchip/irq-bcm7120-l2.c                                    |    3 
 drivers/irqchip/irq-brcmstb-l2.c                                    |    6 
 drivers/irqchip/irq-mvebu-gicp.c                                    |    1 
 drivers/md/dm-cache-target.c                                        |    4 
 drivers/md/dm-flakey.c                                              |   30 
 drivers/md/dm-thin.c                                                |    2 
 drivers/md/dm.c                                                     |    1 
 drivers/media/i2c/ov7670.c                                          |    2 
 drivers/media/i2c/ov772x.c                                          |    3 
 drivers/media/pci/intel/ipu3/ipu3-cio2.c                            |    3 
 drivers/media/platform/omap3isp/isp.c                               |    9 
 drivers/media/rc/ene_ir.c                                           |    3 
 drivers/media/usb/siano/smsusb.c                                    |    1 
 drivers/media/usb/uvc/uvc_ctrl.c                                    |   30 
 drivers/media/usb/uvc/uvc_driver.c                                  |   48 
 drivers/media/usb/uvc/uvc_entity.c                                  |    2 
 drivers/media/usb/uvc/uvc_status.c                                  |   40 
 drivers/media/usb/uvc/uvc_video.c                                   |    4 
 drivers/media/usb/uvc/uvcvideo.h                                    |    5 
 drivers/mfd/pcf50633-adc.c                                          |    7 
 drivers/misc/mei/bus-fixup.c                                        |    8 
 drivers/mtd/nand/raw/sunxi_nand.c                                   |    2 
 drivers/mtd/ubi/build.c                                             |    7 
 drivers/mtd/ubi/vmt.c                                               |   18 
 drivers/mtd/ubi/wl.c                                                |   25 
 drivers/net/can/usb/esd_usb2.c                                      |    4 
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                      |    8 
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c            |    2 
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c                 |    3 
 drivers/net/wireless/ath/ath9k/hif_usb.c                            |   60 
 drivers/net/wireless/ath/ath9k/htc.h                                |   32 
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c                       |   10 
 drivers/net/wireless/ath/ath9k/htc_hst.c                            |    4 
 drivers/net/wireless/ath/ath9k/wmi.c                                |    1 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c           |    7 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c             |    1 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c           |    5 
 drivers/net/wireless/intel/ipw2x00/ipw2100.c                        |  121 -
 drivers/net/wireless/intel/ipw2x00/ipw2200.c                        |   67 
 drivers/net/wireless/intel/iwlegacy/3945-mac.c                      |   16 
 drivers/net/wireless/intel/iwlegacy/4965-mac.c                      |   12 
 drivers/net/wireless/intersil/orinoco/hw.c                          |    2 
 drivers/net/wireless/marvell/libertas/cmdresp.c                     |    2 
 drivers/net/wireless/marvell/libertas/if_usb.c                      |    2 
 drivers/net/wireless/marvell/libertas/main.c                        |    3 
 drivers/net/wireless/marvell/libertas_tf/if_usb.c                   |    2 
 drivers/net/wireless/marvell/mwifiex/11n.c                          |    6 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c              |    5 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c               |   11 
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c                |   91 -
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.c              |    4 
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.h              |    4 
 drivers/net/wireless/rsi/rsi_91x_coex.c                             |    1 
 drivers/net/wireless/wl3501_cs.c                                    |    2 
 drivers/nfc/st-nci/se.c                                             |    6 
 drivers/nfc/st21nfca/se.c                                           |    6 
 drivers/pci/quirks.c                                                |    1 
 drivers/phy/rockchip/phy-rockchip-typec.c                           |    3 
 drivers/pinctrl/pinctrl-at91-pio4.c                                 |    4 
 drivers/pinctrl/pinctrl-at91.c                                      |    2 
 drivers/pinctrl/pinctrl-rockchip.c                                  |   23 
 drivers/powercap/powercap_sys.c                                     |   14 
 drivers/pwm/pwm-stm32-lp.c                                          |    2 
 drivers/regulator/max77802-regulator.c                              |   34 
 drivers/regulator/s5m8767.c                                         |    6 
 drivers/rpmsg/qcom_glink_native.c                                   |    1 
 drivers/rtc/rtc-pm8xxx.c                                            |   24 
 drivers/scsi/aic94xx/aic94xx_task.c                                 |    3 
 drivers/scsi/ipr.c                                                  |   41 
 drivers/scsi/qla2xxx/qla_os.c                                       |    9 
 drivers/scsi/ses.c                                                  |   64 
 drivers/spi/spi-bcm63xx-hsspi.c                                     |   20 
 drivers/thermal/intel_powerclamp.c                                  |   20 
 drivers/thermal/intel_quark_dts_thermal.c                           |   12 
 drivers/thermal/intel_soc_dts_iosf.c                                |    2 
 drivers/tty/serial/fsl_lpuart.c                                     |   24 
 drivers/tty/tty_io.c                                                |    8 
 drivers/tty/vt/vc_screen.c                                          |    4 
 drivers/usb/host/xhci-mvebu.c                                       |    2 
 drivers/usb/storage/ene_ub6250.c                                    |    2 
 drivers/watchdog/at91sam9_wdt.c                                     |    7 
 drivers/watchdog/pcwd_usb.c                                         |    6 
 drivers/watchdog/watchdog_dev.c                                     |    2 
 fs/cifs/smbdirect.c                                                 |    4 
 fs/ext4/xattr.c                                                     |   35 
 fs/f2fs/data.c                                                      |    4 
 fs/f2fs/inline.c                                                    |   13 
 fs/gfs2/aops.c                                                      |    3 
 fs/hfs/bnode.c                                                      |    1 
 fs/hfsplus/super.c                                                  |    4 
 fs/jfs/jfs_dmap.c                                                   |    3 
 fs/nfsd/nfs4layouts.c                                               |    4 
 fs/ocfs2/move_extents.c                                             |   34 
 fs/ubifs/budget.c                                                   |    9 
 fs/ubifs/dir.c                                                      |   13 
 fs/ubifs/file.c                                                     |   12 
 fs/ubifs/tnc.c                                                      |   24 
 fs/udf/file.c                                                       |   26 
 fs/udf/inode.c                                                      |   58 
 fs/udf/udf_sb.h                                                     |    2 
 include/drm/drm_connector.h                                         |   36 
 include/drm/drm_mipi_dsi.h                                          |    4 
 include/linux/ima.h                                                 |    6 
 include/linux/kernel_stat.h                                         |    2 
 include/linux/kprobes.h                                             |    2 
 include/uapi/linux/usb/video.h                                      |   30 
 include/uapi/linux/uvcvideo.h                                       |    2 
 kernel/irq/irqdomain.c                                              |   31 
 kernel/kprobes.c                                                    |    6 
 kernel/rcu/tree_exp.h                                               |    2 
 kernel/time/hrtimer.c                                               |    2 
 kernel/time/posix-stubs.c                                           |    2 
 kernel/time/posix-timers.c                                          |    2 
 kernel/trace/ring_buffer.c                                          |    7 
 lib/mpi/mpicoder.c                                                  |    3 
 net/9p/trans_rdma.c                                                 |   15 
 net/9p/trans_xen.c                                                  |   48 
 net/bluetooth/hci_sock.c                                            |   11 
 net/bluetooth/l2cap_core.c                                          |   24 
 net/bluetooth/l2cap_sock.c                                          |    8 
 net/core/dev.c                                                      |    4 
 net/ipv4/inet_connection_sock.c                                     |    1 
 net/ipv4/inet_hashtables.c                                          |   12 
 net/ipv4/tcp_minisocks.c                                            |    7 
 net/mac80211/sta_info.c                                             |    2 
 net/netfilter/nf_conntrack_netlink.c                                |    5 
 net/nfc/netlink.c                                                   |    4 
 net/rds/message.c                                                   |    2 
 net/sched/Kconfig                                                   |   11 
 net/sched/Makefile                                                  |    1 
 net/sched/cls_tcindex.c                                             |  698 ----------
 net/wireless/sme.c                                                  |   31 
 security/integrity/ima/ima_main.c                                   |    7 
 security/security.c                                                 |    7 
 sound/pci/hda/patch_ca0132.c                                        |    2 
 sound/pci/ice1712/aureon.c                                          |    2 
 sound/soc/kirkwood/kirkwood-dma.c                                   |    2 
 sound/soc/soc-compress.c                                            |    2 
 tools/iio/iio_utils.c                                               |   23 
 tools/lib/bpf/nlattr.c                                              |    2 
 tools/perf/perf-completion.sh                                       |   11 
 tools/perf/util/llvm-utils.c                                        |   25 
 tools/testing/ktest/ktest.pl                                        |   26 
 tools/testing/ktest/sample.conf                                     |    5 
 tools/testing/selftests/ftrace/test.d/ftrace/func_event_triggers.tc |    2 
 tools/testing/selftests/net/fib_tests.sh                            |    2 
 232 files changed, 1670 insertions(+), 1665 deletions(-)

Al Viro (1):
      alpha: fix FEN fault handling

Alexander Usyskin (1):
      mei: bus-fixup:upon error print return values of send and receive

Alexander Wetzel (1):
      wifi: cfg80211: Fix use after free for wext

Alexey Kodanev (1):
      wifi: orinoco: check return value of hermes_write_wordrec()

Alexey V. Vissarionov (1):
      ALSA: hda/ca0132: minor fix for allocation size

Alper Nebi Yasak (1):
      firmware: coreboot: framebuffer: Ignore reserved pixel color bits

Ammar Faizi (1):
      x86: um: vdso: Add '%rcx' and '%r11' to the syscall clobber list

Andreas Gruenbacher (1):
      gfs2: jdata writepage fix

AngeloGioacchino Del Regno (1):
      arm64: dts: mediatek: mt7622: Add missing pwm-cells to pwm node

Angus Chen (1):
      ARM: imx: Call ida_simple_remove() for ida_simple_get

Armin Wolf (1):
      ACPI: battery: Fix missing NUL-termination with large strings

Arnd Bergmann (3):
      rtlwifi: fix -Wpointer-sign warning
      wifi: ath9k: use proper statements in conditionals
      scsi: ipr: Work around fortify-string warning

Benjamin Coddington (1):
      nfsd: fix race to check ls_layouts

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

Chen-Yu Tsai (1):
      clk: Honor CLK_OPS_PARENT_ENABLE in clk_core_is_enabled()

Christophe JAILLET (1):
      ipw2x00: switch from 'pci_' to 'dma_' API

Claudiu Beznea (1):
      pinctrl: at91: use devm_kasprintf() to avoid potential leaks

Conor Dooley (1):
      RISC-V: time: initialize hrtimer based broadcast clock event device

Damien Le Moal (1):
      PCI: Avoid FLR for AMD FCH AHCI adapters

Dan Carpenter (2):
      wifi: mwifiex: fix loop iterator in mwifiex_update_ampdu_txwinsize()
      thermal: intel: quark_dts: fix error pointer dereference

Daniel Mentz (1):
      drm/mipi-dsi: Fix byte order of 16-bit DCS set/get brightness

Daniel Scally (1):
      usb: uvc: Enumerate valid values for color matching

Daniil Tatianin (1):
      ACPICA: nsrepair: handle cases without a return value correctly

Darrell Kavanagh (1):
      firmware/efi sysfb_efi: Add quirk for Lenovo IdeaPad Duet 3

Dave Stevenson (2):
      drm/vc4: dpi: Add option for inverting pixel clock and output enable
      drm/vc4: dpi: Fix format mapping for RGB565

Dmitry Baryshkov (1):
      drm/msm: use strscpy instead of strncpy

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

Eric Biggers (2):
      f2fs: fix information leak in f2fs_move_inline_dirents()
      f2fs: fix cgroup writeback accounting with fs-layer encryption

Eric Dumazet (2):
      net: fix __dev_kfree_skb_any() vs drop monitor
      tcp: tcp_check_req() can be called from process context

Fabrice Gasnier (1):
      pwm: stm32-lp: fix the check on arr and cmp registers update

Fedor Pchelkin (3):
      wifi: ath9k: htc_hst: free skb in ath9k_htc_rx_msg() if there is no callback function
      wifi: ath9k: hif_usb: clean up skbs if ath9k_hif_usb_rx_stream() fails
      nfc: fix memory leak of se_io context in nfc_genl_se_io

Florian Fainelli (3):
      irqchip/irq-brcmstb-l2: Set IRQ_LEVEL for level triggered interrupts
      irqchip/irq-bcm7120-l2: Set IRQ_LEVEL for level triggered interrupts
      net: bcmgenet: Add a check for oversized packets

Frank Jungclaus (1):
      can: esd_usb: Move mislocated storage of SJA1000_ECC_SEG bits in case of a bus error

Frederic Barrat (1):
      powerpc/powernv/ioda: Skip unallocated resources when mapping to PE

Geert Uytterhoeven (1):
      drm: mxsfb: DRM_MXSFB should depend on ARCH_MXS || ARCH_MXC

George Kennedy (2):
      ubi: ensure that VID header offset + VID header size <= alloc, size
      vc_screen: modify vcs_size() handling in vcs_read()

Greg Kroah-Hartman (1):
      Linux 4.19.276

Guenter Roeck (1):
      media: uvcvideo: Handle errors from calls to usb_string

Haibo Chen (1):
      gpio: vf610: connect GPIO label to dev name

Hangyu Hua (1):
      netfilter: ctnetlink: fix possible refcount leak in ctnetlink_create_conntrack()

Hans Verkuil (1):
      media: i2c: ov7670: 0 instead of -EINVAL was returned

Hans de Goede (1):
      ACPI: video: Fix Lenovo Ideapad Z570 DMI match

Harshit Mogalapalli (2):
      iio: accel: mma9551_core: Prevent uninitialized variable in mma9551_read_status_word()
      iio: accel: mma9551_core: Prevent uninitialized variable in mma9551_read_config_word()

Heming Zhao via Ocfs2-devel (2):
      ocfs2: fix defrag path triggering jbd2 ASSERT
      ocfs2: fix non-auto defrag path not working issue

Herbert Xu (4):
      lib/mpi: Fix buffer overrun when SG is too long
      crypto: seqiv - Handle EBUSY correctly
      crypto: rsa-pkcs1pad - Use akcipher_request_complete
      crypto: crypto4xx - Call dma_unmap_page when done

Ian Rogers (1):
      perf llvm: Fix inadvertent file creation

Ilya Dryomov (1):
      rbd: avoid use-after-free in do_rbd_add() when rbd_dev_create() fails

Ilya Leoshkevich (2):
      libbpf: Fix alen calculation in libbpf_nla_dump_errormsg()
      s390: discard .interp section

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

Jerome Brunet (1):
      arm64: dts: meson-axg: enable SCPI

Jia-Ju Bai (1):
      tracing: Add NULL checks for buffer in ring_buffer_free_read_page()

Jiapeng Chong (1):
      phy: rockchip-typec: Fix unsigned comparison with less than zero

Jiasheng Jiang (7):
      wifi: iwl3945: Add missing check for create_singlethread_workqueue
      wifi: iwl4965: Add missing check for create_singlethread_workqueue()
      drm/msm/hdmi: Add missing check for alloc_ordered_workqueue
      drm/msm/dpu: Add check for pstates
      scsi: aic94xx: Add missing check for dma_map_single()
      media: platform: ti: Add missing check for devm_regulator_get
      drm/msm/dsi: Add missing check for alloc_ordered_workqueue

Jisoo Jang (2):
      wifi: brcmfmac: Fix potential stack-out-of-bounds in brcmf_c_preinit_dcmds()
      wifi: brcmfmac: ensure CLM version is null-terminated to prevent stack-out-of-bounds

Johan Hovold (4):
      rtc: pm8xxx: fix set-alarm race
      irqdomain: Fix association race
      irqdomain: Fix disassociation race
      irqdomain: Drop bogus fwspec-mapping error handling

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

Kees Cook (6):
      ASoC: kirkwood: Iterate over array indexes instead of using pointer math
      regulator: max77802: Bounds check regulator id against opmode
      regulator: s5m8767: Bounds check id indexing into arrays
      media: uvcvideo: Silence memcpy() run-time false positive warnings
      usb: host: xhci: mvebu: Iterate over array indexes instead of using pointer math
      USB: ene_usb6250: Allocate enough memory for full object

Kemeng Shi (1):
      blk-mq: remove stale comment for blk_mq_sched_mark_restart_hctx

Krzysztof Kozlowski (5):
      ARM: dts: exynos: correct wr-active property in Exynos3250 Rinato
      ARM: dts: exynos: correct HDMI phy compatible in Exynos4
      ARM: dts: exynos: correct TMU phandle in Exynos4
      ARM: dts: exynos: correct TMU phandle in Odroid XU
      ARM: dts: spear320-hmi: correct STMPE GPIO compatible

Kuninori Morimoto (1):
      ASoC: soc-compress.c: fixup private_data on snd_soc_new_compress()

Kuniyuki Iwashima (1):
      tcp: Fix listen() regression in 4.19.270

Laurent Pinchart (1):
      drm: Clarify definition of the DRM_BUS_FLAG_(PIXDATA|SYNC)_* macros

Lee Jones (1):
      pinctrl: pinctrl-rockchip: Fix a bunch of kerneldoc misdemeanours

Li Hua (1):
      watchdog: pcwd_usb: Fix attempting to access uninitialized memory

Li Zetao (3):
      wifi: rtlwifi: Fix global-out-of-bounds bug in _rtl8812ae_phy_set_txpower_limit()
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

Mario Limonciello (1):
      ACPICA: Drop port I/O validation for some regions

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

Masami Hiramatsu (Google) (1):
      selftests/ftrace: Fix bash specific "==" operator

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

Mikko Perttunen (1):
      gpu: host1x: Don't skip assigning syncpoints to channels

Mikulas Patocka (2):
      dm flakey: fix logic when corrupting a bio
      dm flakey: don't corrupt the zero page

Minsuk Kang (1):
      wifi: ath9k: Fix potential stack-out-of-bounds write in ath9k_wmi_rsp_callback()

Nathan Chancellor (1):
      powerpc: Remove linker flag from KBUILD_AFLAGS

Nathan Lynch (3):
      powerpc/pseries/lparcfg: add missing RTAS retry status handling
      powerpc/rtas: make all exports GPL
      powerpc/rtas: ensure 4KB alignment for rtas_data_buf

Neil Armstrong (5):
      arm64: dts: amlogic: meson-gx: fix SCPI clock dvfs node name
      arm64: dts: amlogic: meson-axg: fix SCPI clock dvfs node name
      arm64: dts: amlogic: meson-gx: add missing SCPI sensors compatible
      arm64: dts: amlogic: meson-gx: add missing unit address to rng node name
      arm64: dts: amlogic: meson-gxl: add missing unit address to eth-phy-mux node name

Nguyen Dinh Phi (1):
      Bluetooth: hci_sock: purge socket queues in the destruct() callback

Nícolas F. R. A. Prado (1):
      drm/mediatek: Clean dangling pointer on bind error path

Paul E. McKenney (1):
      rcu: Suppress smp_processor_id() complaint in synchronize_rcu_expedited_wait()

Pavel Skripkin (1):
      ath9k: htc: clean up statistics macros

Pietro Borrello (4):
      HID: asus: use spinlock to protect concurrent accesses
      HID: asus: use spinlock to safely schedule workers
      rds: rds_rm_zerocopy_callback() correct order for list_add_tail()
      inet: fix fast path in __inet_hash_connect()

Qiheng Lin (2):
      ARM: zynq: Fix refcount leak in zynq_early_slcr_init
      mfd: pcf50633-adc: Fix potential memleak in pcf50633_adc_async_read()

Quinn Tran (2):
      scsi: qla2xxx: Fix link failure in NPIV environment
      scsi: qla2xxx: Fix erroneous link down

Randy Dunlap (3):
      m68k: /proc/hardware should depend on PROC_FS
      sparc: allow PM configs for sparc32 COMPILE_TEST
      MIPS: vpe-mt: drop physical_memsize

Ricardo Ribalda (3):
      media: uvcvideo: Handle cameras with invalid descriptors
      media: uvcvideo: Provide sync and async uvc_ctrl_status_event
      media: uvcvideo: Fix race condition with usb_kill_urb

Rob Clark (1):
      drm/mediatek: Drop unbalanced obj unref

Roberto Sassu (1):
      ima: Align ima_file_mmap() parameters with mmap_file LSM hook

Roman Li (1):
      drm/amd/display: Fix potential null-deref in dm_resume

Roxana Nicolescu (1):
      selftest: fib_tests: Always cleanup before exit

Sakari Ailus (1):
      media: ipu3-cio2: Fix PM runtime usage_count in driver unbind

Samuel Holland (1):
      mtd: rawnand: sunxi: Fix the size of the last OOB region

Sean Christopherson (4):
      x86/virt: Force GIF=1 prior to disabling SVM (for reboot flows)
      x86/crash: Disable virt in core NMI crash handler to avoid double shootdown
      x86/reboot: Disable virtualization in an emergency if SVM is supported
      x86/reboot: Disable SVM, not just VMX, when stopping CPUs

Shay Drory (1):
      net/mlx5: fw_tracer: Fix debug print

Shayne Chen (1):
      wifi: mac80211: make rate u32 in sta_set_rate_info_rx()

Sherry Sun (1):
      tty: serial: fsl_lpuart: disable the CTS when send break signal

Srinivas Pandruvada (1):
      thermal: intel: powerclamp: Fix cur_state for multi package system

Steven Rostedt (3):
      ktest.pl: Give back console on Ctrt^C on monitor
      ktest.pl: Fix missing "end_monitor" when machine check fails
      ktest.pl: Add RUN_TIMEOUT option with default unlimited

Sven Schnelle (1):
      tty: fix out-of-bounds access in tty_driver_lookup_tty()

Tomas Henzl (4):
      scsi: ses: Fix slab-out-of-bounds in ses_enclosure_data_process()
      scsi: ses: Fix possible addl_desc_ptr out-of-bounds accesses
      scsi: ses: Fix possible desc_ptr out-of-bounds accesses
      scsi: ses: Fix slab-out-of-bounds in ses_intf_remove()

Vadim Pasternak (1):
      hwmon: (mlxreg-fan) Return zero speed for broken fan

Vasily Gorbik (4):
      s390/kprobes: fix irq mask clobbering on kprobe reenter from post_handler
      s390/kprobes: fix current_kprobe never cleared after kprobes reenter
      s390/maccess: add no DAT mode to kernel_write
      s390/setup: init jump labels before command line parsing

Wan Jiabing (1):
      ath9k: hif_usb: simplify if-if to if-else

William Zhang (1):
      spi: bcm63xx-hsspi: Fix multi-bit mode setting

Xiang Yang (1):
      um: vector: Fix memory leak in vector_config

Yang Jihong (2):
      x86/kprobes: Fix __recover_optprobed_insn check optimizing logic
      x86/kprobes: Fix arch_check_optimized_kprobe check within optimized_kprobe range

Yang Li (1):
      thermal: intel: Fix unsigned comparison with less than zero

Yang Yingliang (10):
      ARM: OMAP1: call platform_device_put() in error case in omap1_dm_timer_init()
      wifi: rtl8xxxu: don't call dev_kfree_skb() under spin_lock_irqsave()
      wifi: ipw2x00: don't call dev_kfree_skb() under spin_lock_irqsave()
      wifi: libertas_tf: don't call kfree_skb() under spin_lock_irqsave()
      wifi: libertas: if_usb: don't call kfree_skb() under spin_lock_irqsave()
      wifi: libertas: main: don't call kfree_skb() under spin_lock_irqsave()
      wifi: libertas: cmdresp: don't call kfree_skb() under spin_lock_irqsave()
      wifi: wl3501_cs: don't call kfree_skb() under spin_lock_irqsave()
      powercap: fix possible name leak in powercap_register_zone()
      ubi: Fix possible null-ptr-deref in ubi_free_volume()

Yicong Yang (1):
      perf tools: Fix auto-complete on aarch64

Yuan Can (3):
      wifi: rsi: Fix memory leak in rsi_coex_attach()
      drm/bridge: megachips: Fix error handling in i2c_register_driver()
      media: i2c: ov772x: Fix memleak in ov772x_probe()

Yulong Zhang (1):
      tools/iio/iio_utils:fix memory leak

Zhang Changzhong (1):
      wifi: brcmfmac: fix potential memory leak in brcmf_netdev_start_xmit()

Zhang Xiaoxu (2):
      cifs: Fix lost destroy smbd connection when MR allocate failed
      cifs: Fix warning and UAF when destroy the MR list

Zhen Lei (1):
      genirq: Fix the return type of kstat_cpu_irqs_sum()

Zhengchao Shao (4):
      wifi: libertas: fix memory leak in lbs_init_adapter()
      wifi: ipw2200: fix memory leak in ipw_wdev_init()
      wifi: brcmfmac: unmap dma buffer in brcmf_msgbuf_alloc_pktid()
      9p/rdma: unmap receive dma buffer in rdma_request()/post_recv()

Zhihao Cheng (10):
      ubifs: Rectify space budget for ubifs_symlink() if symlink is encrypted
      ubifs: Rectify space budget for ubifs_xrename()
      ubifs: Fix wrong dirty space budget for dirty inode
      ubifs: do_rename: Fix wrong space budget when target inode's nlink > 1
      ubifs: Reserve one leb for each journal head while doing budget
      ubifs: Re-statistic cleaned znode count if commit failed
      ubifs: dirty_cow_znode: Fix memleak in error handling path
      ubifs: ubifs_writepage: Mark page dirty after writing inode failed
      ubi: Fix UAF wear-leveling entry in eraseblk_count_seq_show()
      ubi: ubi_wl_put_peb: Fix infinite loop when wear-leveling work failed

ruanjinjie (1):
      watchdog: at91sam9_wdt: use devm_request_irq to avoid missing free_irq() in error path

Álvaro Fernández Rojas (1):
      spi: bcm63xx-hsspi: fix pm_runtime

