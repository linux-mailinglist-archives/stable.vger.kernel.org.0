Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFBF10E138
	for <lists+stable@lfdr.de>; Sun,  1 Dec 2019 10:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbfLAJlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Dec 2019 04:41:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:56222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725993AbfLAJlG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Dec 2019 04:41:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AD182073C;
        Sun,  1 Dec 2019 09:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575193263;
        bh=KEDHnE8rZ3AaxF7zIMK4Z8jkyf+Eo3Xjn+BtVJwFOf8=;
        h=Date:From:To:Cc:Subject:From;
        b=TLNTGnI7GMALbQr7GqYxVY2Z/Ilxs+gLsdzNca2qp7dxS4zI1BU2jTD6lgT+fn9i0
         jBunxBBJHAzkQisUPo0lMjwHlWX8q5f1KW6IgVe8ZtQYr6Wr4Dp3SDiuPmqa5+yJnw
         WNaEOnGYhxp7Co0Rw6u9pmxNAPkLntlUpd1REsB0=
Date:   Sun, 1 Dec 2019 10:41:01 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.157
Message-ID: <20191201094101.GA3791294@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.157 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/admin-guide/hw-vuln/mds.rst                          |    7=
=20
 Documentation/admin-guide/hw-vuln/tsx_async_abort.rst              |    5=
=20
 Documentation/admin-guide/kernel-parameters.txt                    |   11 +
 Makefile                                                           |    2=
=20
 arch/arc/kernel/perf_event.c                                       |    4=
=20
 arch/arm/mm/mmu.c                                                  |    3=
=20
 arch/arm64/Makefile                                                |    2=
=20
 arch/arm64/include/asm/string.h                                    |   14 -
 arch/arm64/kernel/arm64ksyms.c                                     |    7=
=20
 arch/arm64/kernel/traps.c                                          |    1=
=20
 arch/arm64/lib/memchr.S                                            |    2=
=20
 arch/arm64/lib/memcmp.S                                            |    2=
=20
 arch/arm64/lib/strchr.S                                            |    2=
=20
 arch/arm64/lib/strcmp.S                                            |    2=
=20
 arch/arm64/lib/strlen.S                                            |    2=
=20
 arch/arm64/lib/strncmp.S                                           |    2=
=20
 arch/arm64/lib/strnlen.S                                           |    2=
=20
 arch/arm64/lib/strrchr.S                                           |    2=
=20
 arch/m68k/kernel/uboot.c                                           |    2=
=20
 arch/powerpc/boot/Makefile                                         |    4=
=20
 arch/powerpc/include/asm/asm-prototypes.h                          |    3=
=20
 arch/powerpc/include/asm/security_features.h                       |    3=
=20
 arch/powerpc/kernel/eeh_pe.c                                       |    2=
=20
 arch/powerpc/kernel/entry_64.S                                     |    6=
=20
 arch/powerpc/kernel/process.c                                      |    3=
=20
 arch/powerpc/kernel/security.c                                     |   74 =
++++++++
 arch/powerpc/kvm/book3s_hv_rmhandlers.S                            |   27 =
+++
 arch/powerpc/platforms/ps3/os-area.c                               |    2=
=20
 arch/powerpc/platforms/pseries/hotplug-memory.c                    |    2=
=20
 arch/powerpc/platforms/pseries/lpar.c                              |   54 =
++++++
 arch/powerpc/xmon/Makefile                                         |    6=
=20
 arch/s390/kernel/perf_cpum_sf.c                                    |    6=
=20
 arch/sparc/include/asm/cmpxchg_64.h                                |    7=
=20
 arch/sparc/include/asm/parport.h                                   |    2=
=20
 arch/um/drivers/line.c                                             |    2=
=20
 arch/x86/hyperv/hv_init.c                                          |    2=
=20
 arch/x86/include/asm/ptrace.h                                      |   42 =
++++-
 arch/x86/kernel/cpu/bugs.c                                         |   30 =
+++
 arch/x86/kvm/mmu.c                                                 |    8=
=20
 arch/x86/kvm/vmx.c                                                 |   12 -
 arch/x86/tools/gen-insn-attr-x86.awk                               |    4=
=20
 block/blk-merge.c                                                  |   46 =
++++-
 drivers/acpi/acpi_memhotplug.c                                     |    2=
=20
 drivers/atm/zatm.c                                                 |   42 =
++---
 drivers/base/memory.c                                              |    9 -
 drivers/base/power/domain.c                                        |    6=
=20
 drivers/block/amiflop.c                                            |   84 =
++++------
 drivers/block/nbd.c                                                |    6=
=20
 drivers/block/skd_main.c                                           |    4=
=20
 drivers/bluetooth/hci_bcsp.c                                       |    3=
=20
 drivers/cdrom/cdrom.c                                              |   27 =
+--
 drivers/char/virtio_console.c                                      |   28 =
+--
 drivers/clk/at91/clk-audio-pll.c                                   |    2=
=20
 drivers/clk/mmp/clk-of-mmp2.c                                      |    4=
=20
 drivers/clk/sunxi-ng/ccu-sun50i-a64.c                              |    7=
=20
 drivers/cpufreq/cpufreq.c                                          |    9 +
 drivers/edac/thunderx_edac.c                                       |    4=
=20
 drivers/firmware/google/gsmi.c                                     |    5=
=20
 drivers/gpio/gpio-max77620.c                                       |    6=
=20
 drivers/gpu/drm/i915/i915_gem_userptr.c                            |   22 =
++
 drivers/i2c/busses/i2c-uniphier-f.c                                |   72 =
++++++--
 drivers/infiniband/hw/bnxt_re/main.c                               |   13 +
 drivers/isdn/mISDN/tei.c                                           |    7=
=20
 drivers/macintosh/windfarm_smu_sat.c                               |   25 =
--
 drivers/md/dm-raid.c                                               |    2=
=20
 drivers/md/raid10.c                                                |    2=
=20
 drivers/media/platform/vivid/vivid-kthread-cap.c                   |    8=
=20
 drivers/media/platform/vivid/vivid-kthread-out.c                   |    8=
=20
 drivers/media/platform/vivid/vivid-sdr-cap.c                       |    8=
=20
 drivers/media/platform/vivid/vivid-vid-cap.c                       |    3=
=20
 drivers/media/platform/vivid/vivid-vid-out.c                       |    3=
=20
 drivers/media/rc/imon.c                                            |    3=
=20
 drivers/media/usb/b2c2/flexcop-usb.c                               |    3=
=20
 drivers/media/usb/dvb-usb/cxusb.c                                  |    3=
=20
 drivers/media/usb/usbvision/usbvision-video.c                      |   21 =
++
 drivers/media/usb/uvc/uvc_driver.c                                 |   28 =
+--
 drivers/mfd/arizona-core.c                                         |    8=
=20
 drivers/mfd/intel_soc_pmic_bxtwc.c                                 |   41 =
+++-
 drivers/mfd/max8997.c                                              |    8=
=20
 drivers/mfd/mc13xxx-core.c                                         |    3=
=20
 drivers/misc/mic/scif/scif_fence.c                                 |    2=
=20
 drivers/mmc/host/mtk-sd.c                                          |    2=
=20
 drivers/net/dsa/bcm_sf2.c                                          |    4=
=20
 drivers/net/dsa/mv88e6xxx/chip.c                                   |    4=
=20
 drivers/net/dsa/mv88e6xxx/port.c                                   |   25 =
++
 drivers/net/dsa/mv88e6xxx/port.h                                   |    1=
=20
 drivers/net/ethernet/amazon/Kconfig                                |    2=
=20
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                     |    2=
=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hns3_enet.c             |   24 =
++
 drivers/net/ethernet/intel/igb/igb_ptp.c                           |    8=
=20
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c                    |    1=
=20
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c                  |    2=
=20
 drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c                    |    2=
=20
 drivers/net/ethernet/qlogic/qed/qed.h                              |    2=
=20
 drivers/net/ethernet/qlogic/qed/qed_main.c                         |   22 =
++
 drivers/net/ethernet/qlogic/qed/qed_mcp.c                          |   27 =
+--
 drivers/net/ethernet/qlogic/qed/qed_mcp.h                          |    5=
=20
 drivers/net/ethernet/qlogic/qed/qed_vf.c                           |    2=
=20
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.c                    |    2=
=20
 drivers/net/ethernet/sfc/ptp.c                                     |    3=
=20
 drivers/net/ethernet/ti/cpsw.c                                     |    1=
=20
 drivers/net/macsec.c                                               |   20 =
++
 drivers/net/ntb_netdev.c                                           |    2=
=20
 drivers/net/phy/dp83867.c                                          |   37 =
++++
 drivers/net/vrf.c                                                  |   19 =
+-
 drivers/net/wireless/ath/ath10k/pci.c                              |   23 =
+-
 drivers/net/wireless/ath/ath10k/usb.c                              |    8=
=20
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c                     |    2=
=20
 drivers/net/wireless/ath/wil6210/wmi.c                             |    9 -
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c     |   30 =
+++
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h            |    1=
=20
 drivers/net/wireless/cisco/airo.c                                  |    2=
=20
 drivers/net/wireless/marvell/mwifiex/cfg80211.c                    |   13 +
 drivers/net/wireless/marvell/mwifiex/ioctl.h                       |    1=
=20
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c                   |   11 -
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c              |    1=
=20
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c                |    2=
=20
 drivers/net/wireless/ti/wlcore/vendor_cmd.c                        |    2=
=20
 drivers/nfc/port100.c                                              |    2=
=20
 drivers/ntb/hw/intel/ntb_hw_intel.c                                |    2=
=20
 drivers/nvme/target/fcloop.c                                       |    1=
=20
 drivers/of/unittest.c                                              |   43 =
++++-
 drivers/pci/dwc/pci-keystone.c                                     |    3=
=20
 drivers/pci/host/vmd.c                                             |    2=
=20
 drivers/pinctrl/pinctrl-lpc18xx.c                                  |   10 -
 drivers/pinctrl/pinctrl-zynq.c                                     |    9 -
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c                           |   21 =
++
 drivers/pinctrl/sunxi/pinctrl-sunxi.c                              |   11 -
 drivers/platform/x86/asus-nb-wmi.c                                 |   21 =
++
 drivers/platform/x86/asus-wmi.c                                    |    2=
=20
 drivers/platform/x86/asus-wmi.h                                    |    1=
=20
 drivers/pwm/pwm-lpss.c                                             |   12 -
 drivers/rtc/rtc-s35390a.c                                          |    2=
=20
 drivers/scsi/dc395x.c                                              |   12 -
 drivers/scsi/ips.c                                                 |    1=
=20
 drivers/scsi/isci/host.c                                           |    8=
=20
 drivers/scsi/isci/host.h                                           |    2=
=20
 drivers/scsi/isci/request.c                                        |    4=
=20
 drivers/scsi/isci/task.c                                           |    4=
=20
 drivers/scsi/iscsi_tcp.c                                           |    3=
=20
 drivers/scsi/lpfc/lpfc_els.c                                       |   28 =
++-
 drivers/scsi/lpfc/lpfc_hbadisc.c                                   |   20 =
++
 drivers/scsi/lpfc/lpfc_init.c                                      |    2=
=20
 drivers/scsi/lpfc/lpfc_nportdisc.c                                 |    5=
=20
 drivers/scsi/lpfc/lpfc_sli.c                                       |   11 -
 drivers/scsi/lpfc/lpfc_sli4.h                                      |    1=
=20
 drivers/scsi/megaraid/megaraid_sas_base.c                          |    9 -
 drivers/scsi/mpt3sas/mpt3sas_base.c                                |    2=
=20
 drivers/scsi/mpt3sas/mpt3sas_config.c                              |    4=
=20
 drivers/scsi/mpt3sas/mpt3sas_scsih.c                               |   36 =
++++
 drivers/spi/spi-omap2-mcspi.c                                      |   26 =
---
 drivers/spi/spi-sh-msiof.c                                         |    4=
=20
 drivers/staging/ccree/cc_hw_queue_defs.h                           |    6=
=20
 drivers/staging/comedi/drivers/usbduxfast.c                        |   21 =
+-
 drivers/thermal/rcar_thermal.c                                     |    4=
=20
 drivers/tty/pty.c                                                  |   14 +
 drivers/tty/synclink_gt.c                                          |   16 -
 drivers/usb/misc/appledisplay.c                                    |   15 +
 drivers/usb/misc/chaoskey.c                                        |   24 =
++
 drivers/usb/serial/cp210x.c                                        |    1=
=20
 drivers/usb/serial/mos7720.c                                       |    4=
=20
 drivers/usb/serial/mos7840.c                                       |   16 +
 drivers/usb/serial/option.c                                        |    7=
=20
 drivers/usb/usbip/stub_rx.c                                        |   50 =
+++--
 drivers/vhost/vsock.c                                              |   66 =
+++++--
 drivers/virtio/virtio_ring.c                                       |    2=
=20
 drivers/w1/slaves/w1_ds2438.c                                      |   66 =
++++++-
 drivers/xen/balloon.c                                              |    3=
=20
 fs/btrfs/ctree.c                                                   |    4=
=20
 fs/btrfs/super.c                                                   |    6=
=20
 fs/ceph/inode.c                                                    |    1=
=20
 fs/dlm/member.c                                                    |    5=
=20
 fs/dlm/user.c                                                      |    2=
=20
 fs/f2fs/data.c                                                     |    8=
=20
 fs/f2fs/dir.c                                                      |    1=
=20
 fs/f2fs/segment.c                                                  |    4=
=20
 fs/gfs2/rgrp.c                                                     |   13 +
 fs/hfs/brec.c                                                      |    1=
=20
 fs/hfs/btree.c                                                     |   41 =
++--
 fs/hfs/btree.h                                                     |    1=
=20
 fs/hfs/catalog.c                                                   |   16 +
 fs/hfs/extent.c                                                    |   10 -
 fs/hfs/inode.c                                                     |    2=
=20
 fs/hfsplus/attributes.c                                            |   10 +
 fs/hfsplus/brec.c                                                  |    1=
=20
 fs/hfsplus/btree.c                                                 |   44 =
+++--
 fs/hfsplus/catalog.c                                               |   24 =
++
 fs/hfsplus/extents.c                                               |    8=
=20
 fs/hfsplus/hfsplus_fs.h                                            |    2=
=20
 fs/hfsplus/inode.c                                                 |    1=
=20
 fs/ocfs2/buffer_head_io.c                                          |   77 =
+++++++--
 fs/ocfs2/dlm/dlmdebug.c                                            |    2=
=20
 fs/ocfs2/dlmglue.c                                                 |    2=
=20
 fs/ocfs2/move_extents.c                                            |   17 =
++
 fs/ocfs2/stackglue.c                                               |    6=
=20
 fs/ocfs2/stackglue.h                                               |    3=
=20
 fs/ocfs2/xattr.c                                                   |   56 =
+++---
 fs/read_write.c                                                    |   33 =
+++
 fs/xfs/xfs_buf.c                                                   |   38 =
++++
 include/linux/bitmap.h                                             |    9 -
 include/linux/kvm_host.h                                           |    1=
=20
 include/linux/memory_hotplug.h                                     |    1=
=20
 include/linux/mfd/intel_soc_pmic.h                                 |    1=
=20
 include/linux/mfd/max8997.h                                        |    1=
=20
 include/linux/mfd/mc13xxx.h                                        |    1=
=20
 kernel/auditsc.c                                                   |    2=
=20
 kernel/bpf/devmap.c                                                |    3=
=20
 kernel/printk/printk.c                                             |    2=
=20
 kernel/sched/fair.c                                                |   13 +
 kernel/sched/topology.c                                            |    2=
=20
 mm/ksm.c                                                           |   14 -
 mm/memory_hotplug.c                                                |   48 =
+++--
 mm/page-writeback.c                                                |   33 =
+--
 net/core/dev.c                                                     |    2=
=20
 net/core/rtnetlink.c                                               |   23 =
++
 net/ipv6/tcp_ipv6.c                                                |    3=
=20
 net/openvswitch/conntrack.c                                        |    3=
=20
 net/sched/act_pedit.c                                              |    7=
=20
 net/sunrpc/auth_gss/gss_krb5_seal.c                                |    1=
=20
 net/sunrpc/xprtsock.c                                              |   34 =
++--
 net/unix/af_unix.c                                                 |    2=
=20
 net/vmw_vsock/virtio_transport_common.c                            |   15 +
 net/wireless/ap.c                                                  |    2=
=20
 net/wireless/core.h                                                |    2=
=20
 net/wireless/sme.c                                                 |    8=
=20
 sound/firewire/isight.c                                            |   10 -
 sound/i2c/cs8427.c                                                 |    2=
=20
 sound/soc/tegra/tegra_sgtl5000.c                                   |   17 =
+-
 tools/gpio/Build                                                   |    1=
=20
 tools/gpio/Makefile                                                |   10 -
 tools/objtool/arch/x86/tools/gen-insn-attr-x86.awk                 |    4=
=20
 tools/power/acpi/tools/acpidump/apmain.c                           |    2=
=20
 tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args_syntax.tc |    3=
=20
 tools/testing/selftests/powerpc/cache_shape/Makefile               |    9 -
 tools/testing/selftests/powerpc/signal/Makefile                    |   11 -
 tools/testing/selftests/powerpc/switch_endian/Makefile             |    1=
=20
 tools/testing/selftests/watchdog/watchdog-test.c                   |   16 +
 tools/usb/usbip/libsrc/usbip_host_common.c                         |    8=
=20
 virt/kvm/kvm_main.c                                                |   26 =
++-
 239 files changed, 1937 insertions(+), 780 deletions(-)

Adrian Bunk (1):
      mwifiex: Fix NL80211_TX_POWER_LIMITED

Al Viro (2):
      pty: fix compat ioctls
      synclink_gt(): fix compat_ioctl()

Alan Stern (1):
      media: usbvision: Fix races among open, close, and disconnect

Aleksander Morgado (2):
      USB: serial: option: add support for DW5821e with eSIM support
      USB: serial: option: add support for Foxconn T77W968 LTE modules

Alexander Kapshuk (1):
      x86/insn: Fix awk regexp warnings

Alexander Popov (1):
      media: vivid: Fix wrong locking that causes race conditions on stream=
ing stop

Alexandre Belloni (1):
      clk: at91: audio-pll: fix audio pmc type

Alexey Brodkin (1):
      ARC: perf: Accommodate big-endian CPU

Ali MJ Al-Nasrawy (2):
      brcmsmac: AP mode: update beacon when TIM changes
      brcmsmac: never log "tid x is not agg'able" by default

Andreas Gruenbacher (1):
      gfs2: Fix marking bitmaps non-full

Andrey Ryabinin (2):
      mm/ksm.c: don't WARN if page is still mapped in remove_stable_node()
      arm64: lib: use C string functions with KASAN enabled

Andy Shevchenko (1):
      mfd: intel_soc_pmic_bxtwc: Chain power button IRQs as well

Angelo Dureghello (1):
      m68k: fix command-line parsing when passed from u-boot

Anton Ivanov (1):
      um: Make line/tty semantics use true write IRQ

Aravinda Prasad (1):
      powerpc/pseries: Export raw per-CPU VPA data via debugfs

Arnd Bergmann (2):
      openvswitch: fix linking without CONFIG_NF_CONNTRACK_LABELS
      btrfs: avoid link error with CONFIG_NO_AUTO_INLINE

Bart Van Assche (1):
      nvmet-fcloop: suppress a compiler warning

Benjamin Herrenschmidt (1):
      macintosh/windfarm_smu_sat: Fix debug output

Bernd Porr (1):
      staging: comedi: usbduxfast: usbduxfast_ai_cmdtest rounding error

Bo Yan (1):
      cpufreq: Skip cpufreq resume if it's not suspended

Brian Masney (1):
      pinctrl: qcom: spmi-gpio: fix gpio-hog related boot issues

Carl Huang (1):
      ath10k: allocate small size dma memory in ath10k_pci_diag_write_mem

Changwei Ge (1):
      ocfs2: don't put and assigning null to bh allocated outside

Chao Yu (1):
      f2fs: fix to spread clear_cold_data()

Chaotian Jing (1):
      mmc: mediatek: fix cannot receive new request when msdc_cmd_is_ready =
fail

Chester Lin (1):
      ARM: 8904/1: skip nomap memblocks while finding the lowmem/highmem bo=
undary

Chris Wilson (1):
      drm/i915/userptr: Try to acquire the page lock around set_page_dirty()

Christoph Hellwig (2):
      scsi: dc395x: fix dma API usage in srb_done
      scsi: dc395x: fix DMA API usage in sg_update_list

Christophe JAILLET (2):
      pinctrl: sunxi: Fix a memory leak in 'sunxi_pinctrl_build_state()'
      wlcore: Fix the return value in case of error in 'wlcore_vendor_cmd_s=
mart_config_start()'

Christopher M. Riedl (1):
      powerpc/64s: support nospectre_v2 cmdline option

Colin Ian King (3):
      usbip: tools: fix atoi() on non-null terminated string
      fs/hfs/extent.c: fix array out of bounds read of array extent
      ACPICA: Use %d for signed int print formatting instead of %u

Dan Carpenter (5):
      net: rtnetlink: prevent underflows in do_setvfinfo()
      powerpc: Fix signedness bug in update_flash_db()
      EDAC, thunderx: Fix memory leak in thunderx_l2c_threaded_isr()
      qlcnic: fix a return in qlcnic_dcb_get_capability()
      wireless: airo: potential buffer overflow in sprintf()

Darrick J. Wong (1):
      vfs: avoid problematic remapping requests into partial EOF block

Dave Chinner (2):
      xfs: fix use-after-free race in xfs_buf_rele
      mm/page-writeback.c: fix range_cyclic writeback vs writepages deadlock

Dave Jiang (1):
      ntb: intel: fix return value for ndev_vec_mask()

David Ahern (1):
      ipv6: Fix handling of LLA with VRF and sockets bound to VRF

David Hildenbrand (2):
      mm/memory_hotplug: make add_memory() take the device_hotplug_lock
      mm/memory_hotplug: don't access uninitialized memmaps in shrink_zone_=
span()

David S. Miller (2):
      sparc: Fix parport build warnings.
      sparc64: Rework xchg() definition to avoid warnings.

Davide Caratti (1):
      net/sched: act_pedit: fix WARN() in the traffic path

Denis Efremov (1):
      ath9k_hw: fix uninitialized variable data

Devesh Sharma (1):
      RDMA/bnxt_re: Fix qp async event reporting

Duncan Laurie (1):
      gsmi: Fix bug in append_to_eventlog sysfs handler

Eran Ben Elisha (1):
      net/mlxfw: Verify FSM error code translation doesn't exceed array size

Eric Dumazet (1):
      net: do not abort bulk send on BQL status

Ernesto A. Fern=E1ndez (8):
      hfsplus: fix BUG on bnode parent update
      hfs: fix BUG on bnode parent update
      hfsplus: prevent btree data loss on ENOSPC
      hfs: prevent btree data loss on ENOSPC
      hfsplus: fix return value of hfsplus_get_block()
      hfs: fix return value of hfs_get_block()
      hfsplus: update timestamps on truncate()
      hfs: update timestamp on truncate()

Fabio Estevam (1):
      mfd: mc13xxx-core: Fix PMIC shutdown when reading ADC values

Felipe Rechia (1):
      powerpc/process: Fix flush_all_to_thread for SPE

Florian Fainelli (1):
      net: dsa: bcm_sf2: Turn on PHY to allow successful registration

Frank Rowand (1):
      of: unittest: allow base devicetree to have symbol metadata

Gang He (1):
      ocfs2: remove ocfs2_is_o2cb_active()

Geert Uytterhoeven (1):
      thermal: rcar_thermal: Prevent hardware access during system suspend

Greg Kroah-Hartman (2):
      usb-serial: cp201x: support Mark-10 digital force gauge
      Linux 4.14.157

Gustavo A. R. Silva (2):
      scsi: ips: fix missing break in switch
      rtl8xxxu: Fix missing break in switch

Halil Pasic (1):
      virtio_ring: fix return code on DMA mapping fails

Hans de Goede (2):
      platform/x86: asus-wmi: Only Tell EC the OS will handle display hotke=
ys from asus_nb_wmi
      pwm: lpss: Only set update bit if we are actually changing the settin=
gs

Hari Vyas (1):
      arm64: fix for bad_mode() handler to always result in panic

Heinz Mauelshagen (1):
      dm raid: avoid bitmap with raid4/5/6 journal device

Hewenliang (1):
      usbip: tools: fix fd leakage in the function of read_attr_usbip_status

Huazhong Tan (1):
      net: hns3: bugfix for buffer not free problem during resetting

Hui Peng (1):
      ath10k: Fix a NULL-ptr-deref bug in ath10k_usb_alloc_urb_from_pipe

Icenowy Zheng (1):
      clk: sunxi-ng: enable so-said LDOs for A64 SoC's pll-mipi clock

Ivan Khoronzhuk (1):
      net: ethernet: ti: cpsw: unsync mcast entries while switch promisc mo=
de

J. Bruce Fields (1):
      sunrpc: safely reallow resvport min/max inversion

James Smart (2):
      scsi: lpfc: fcoe: Fix link down issue after 1000+ link bounces
      scsi: lpfc: Correct loss of fc4 type on remote port address change

Jens Axboe (2):
      skd: fixup usage of legacy IO API
      cdrom: don't attempt to fiddle with cdo->capability

Jerry Hoemann (1):
      selftests: watchdog: Fix error message.

Jia-Ju Bai (1):
      fs/ocfs2/dlm/dlmdebug.c: fix a sleep-in-atomic-context bug in dlm_pri=
nt_one_mle()

Jianchao Wang (1):
      block: fix the DISCARD request merge

Joel Stanley (3):
      powerpc/boot: Disable vector instructions
      powerpc/xmon: Relax frame size for clang
      selftests/powerpc/signal: Fix out-of-tree build

Johan Hovold (2):
      USB: serial: mos7720: fix remote wakeup
      USB: serial: mos7840: fix remote wakeup

Johannes Berg (1):
      cfg80211: call disconnect_wk when AP stops

John Pittman (1):
      md/raid10: prevent access of uninitialized resync_pages offset

Jon Derrick (1):
      PCI: vmd: Detach resources after stopping root bus

Jon Mason (1):
      ntb_netdev: fix sleep time mismatch

Joseph Qi (1):
      Revert "fs: ocfs2: fix possible null-pointer dereferences in ocfs2_xa=
_prepare_entry()"

Julien Folly (1):
      w1: IAD Register is yet readable trough iad sys file. Fix snprintf (%=
u for unsigned, count for max size).

Kai Shen (1):
      cpufreq: Add NULL checks to show() and store() methods of cpufreq

Kiernan Hager (1):
      platform/x86: asus-nb-wmi: Support ALS on the Zenbook UX430UQ

Kishon Vijay Abraham I (1):
      PCI: keystone: Use quirk to limit MRRS for K2G

Kyeongdon Kim (1):
      net: fix warning in af_unix

Larry Chen (1):
      ocfs2: fix clusters leak in ocfs2_defrag_extent()

Laura Abbott (1):
      tools: gpio: Correctly add make dependencies for gpio_utils

Laurent Pinchart (1):
      media: uvcvideo: Fix error path in control parsing failure

Laurent Vivier (1):
      virtio_console: allocate inbufs in add_port() only if it is needed

Lior David (1):
      wil6210: fix locking in wmi_call

Lubomir Rintel (1):
      clk: mmp2: fix the clock id for sdh2_clk and sdh3_clk

Luigi Rizzo (1):
      net/mlx4_en: fix mlx4 ethtool -N insertion

Marcel Ziswiler (1):
      ASoC: tegra_sgtl5000: fix device_node refcounting

Marek Beh=FAn (1):
      net: dsa: mv88e6xxx: Fix 88E6141/6341 2500mbps SERDES speed

Marek Szyprowski (1):
      mfd: max8997: Enale irq-wakeup unconditionally

Martin Habets (1):
      sfc: Only cancel the PPS workqueue if it exists

Masahiro Yamada (4):
      i2c: uniphier-f: make driver robust against concurrency
      i2c: uniphier-f: fix occasional timeout error
      i2c: uniphier-f: fix race condition when IRQ is cleared
      i2c: uniphier-f: fix timeout error after reading 8 bytes

Masami Hiramatsu (1):
      selftests/ftrace: Fix to test kprobe $comm arg only if available

Mattias Jacobsson (1):
      USB: misc: appledisplay: fix backlight update_status return code

Max Uvarov (2):
      net: phy: dp83867: fix speed 10 in sgmii mode
      net: phy: dp83867: increase SGMII autoneg timer duration

Michael Ellerman (4):
      selftests/powerpc/switch_endian: Fix out-of-tree build
      selftests/powerpc/cache_shape: Fix out-of-tree build
      powerpc/book3s64: Fix link stack flush on context switch
      KVM: PPC: Book3S HV: Flush link stack on guest exit to host kernel

Mike Manning (1):
      vrf: mark skb for multicast or link-local as enslaved to VRF

Miroslav Lichvar (1):
      igb: shorten maximum PHC timecounter update interval

Nathan Chancellor (9):
      scsi: isci: Use proper enumerated type in atapi_d2h_reg_frame_handler
      scsi: isci: Change sci_controller_start_task's return type to sci_sta=
tus
      scsi: iscsi_tcp: Explicitly cast param in iscsi_sw_tcp_host_get_param
      crypto: ccree - avoid implicit enum conversion
      atm: zatm: Fix empty body Clang warnings
      rtc: s35390a: Change buf's type to u8 in s35390a_init
      mISDN: Fix type of switch control variable in ctrl_teimanager
      pinctrl: lpc18xx: Use define directive for PIN_CONFIG_GPIO_PIN_INT
      pinctrl: zynq: Use define directive for PIN_CONFIG_IO_STANDARD

Navid Emamdoost (1):
      nbd: prevent memory leak

Netanel Belgazal (1):
      net: ena: Fix Kconfig dependency on X86

Nikolay Borisov (1):
      btrfs: handle error of get_old_root

Oliver Neukum (4):
      nfc: port100: handle command failure cleanly
      media: b2c2-flexcop-usb: add sanity checking
      USB: chaoskey: fix error case of a timeout
      appledisplay: fix error handling in the scheduled work

Omar Sandoval (1):
      amiflop: clean up on errors during setup

Pavel L=F6bl (1):
      USB: serial: mos7840: add USB ID to support Moxa UPort 2210

Peter Zijlstra (1):
      sched/topology: Fix off by one bug

Philipp Klocke (1):
      ALSA: i2c/cs8427: Fix int to char conversion

Rahul Verma (1):
      qed: Align local and global PTT to propagate through the APIs.

Rasmus Villemoes (2):
      linux/bitmap.h: handle constant zero-size bitmaps correctly
      linux/bitmap.h: fix type of nbits in bitmap_shift_right()

Richard Guy Briggs (1):
      audit: print empty EXECVE args

Roi Dayan (1):
      net/mlx5e: Fix set vf link state error flow

Sabrina Dubroca (2):
      macsec: update operstate when lower device changes
      macsec: let the administrator set UP state even if lowerdev is down

Sam Bobroff (1):
      powerpc/eeh: Fix use of EEH_PE_KEEP on wrong field

Sapthagiri Baratam (1):
      mfd: arizona: Correct calling of runtime_put_sync

Sasha Levin (1):
      x86/hyperv: mark hyperv_init as __init function

Sean Christopherson (2):
      KVM: nVMX: reset cache/shadows when switching loaded VMCS
      KVM: MMU: Do not treat ZONE_DEVICE pages as being reserved

Sean Young (1):
      media: imon: invalid dereference in imon_touch_event

Sergei Shtylyov (1):
      spi: sh-msiof: fix deferred probing

Sergey Senozhatsky (1):
      printk: fix integer overflow in setup_log_buf()

Shaokun Zhang (1):
      rtlwifi: rtl8192de: Fix misleading REG_MCUFWDL information

Shivasharan S (2):
      scsi: megaraid_sas: Fix msleep granularity
      scsi: megaraid_sas: Fix goto labels in error handling

Shuah Khan (Samsung OSG) (1):
      selftests: watchdog: fix message when /dev/watchdog open fails

Sriram R (1):
      cfg80211: Prevent regulatory restore during STA disconnect in concurr=
ent interfaces

Stefano Garzarella (1):
      vhost/vsock: split packets to send using multiple buffers

Steven Rostedt (VMware) (1):
      kprobes, x86/ptrace.h: Make regs_get_kernel_stack_nth() not fault on =
bad stack

Suganath Prabu (3):
      scsi: mpt3sas: Fix Sync cache command failure during driver unload
      scsi: mpt3sas: Don't modify EEDPTagMode field setting on SAS3.5 HBA d=
evices
      scsi: mpt3sas: Fix driver modifying persistent data in Manufacturing =
page11

Sun Ke (1):
      nbd:fix memory leak in nbd_get_socket()

Suwan Kim (1):
      usbip: Fix uninitialized symbol 'nents' in stub_recv_cmd_submit()

Taehee Yoo (1):
      bpf: devmap: fix wrong interface selection in notifier_call

Takashi Sakamoto (1):
      ALSA: isight: fix leak of reference to firewire unit in error path of=
 .probe callback

Thierry Reding (1):
      gpio: max77620: Fixup debounce delays

Thomas Richter (1):
      s390/perf: Return error when debug_register fails

Tomas Bortoli (1):
      Bluetooth: Fix invalid-free in bcsp_close()

Trond Myklebust (1):
      SUNRPC: Fix a compile warning for cmpxchg64()

Tycho Andersen (2):
      dlm: fix invalid free
      dlm: don't leak kernel pointer to userspace

Ulf Hansson (1):
      PM / Domains: Deal with multiple states but no governor in genpd

Uros Bizjak (1):
      KVM/x86: Fix invvpid and invept register operand size in 64-bit mode

Valentin Schneider (1):
      sched/fair: Don't increase sd->balance_interval on newidle balance

Vandana BN (1):
      media: vivid: Set vid_cap_streaming and vid_out_streaming to true

Victor Kamensky (1):
      arm64: makefile fix build of .i file in external module case

Vignesh R (2):
      spi: omap2-mcspi: Set FIFO DMA trigger level to word length
      spi: omap2-mcspi: Fix DMA and FIFO event trigger size mismatch

Vito Caputo (1):
      media: cxusb: detect cxusb_ctrl_msg error in query

Waiman Long (2):
      x86/speculation: Fix incorrect MDS/TAA mitigation status
      x86/speculation: Fix redundant MDS mitigation message

Wenwen Wang (1):
      misc: mic: fix a DMA pool free failure

Yan, Zheng (1):
      ceph: fix dentry leak in ceph_readdir_prepopulate

YueHaibing (1):
      net: bcmgenet: return correct value 'ret' from bcmgenet_power_down

zhong jiang (1):
      mm/memory_hotplug: Do not unlock when fails to take the device_hotplu=
g_lock


--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl3jiq0ACgkQONu9yGCS
aT6eYg/7BbZbT7uYVBhwm6nMbsT7hPP+MKXcCux7qWy2RgtTpK2TA8P0sAErfOT4
wcwUpo9P5kGmLAog/Mg8FVE69GzRCIzYq0b8CXWbJeTuSaO6WuGNWzhBNe3xr/gm
bCpzhnHJWPKaZsia8t4gJ7nPvdAeYXj95RHZS0biAiavZF3IUONzIDsau1n0TKaL
uJuj8iX72I4iiVnB0MMpbudlq2Kwrr2qZcDG00QV4ye7V9k5rT+Xdm3kwt5wBnO6
hj/Tk0fhnkQ7CkyGZbkVjrm4IgiXyOYIEBTB9ZFv6IIUMzVw9+RiaQV2dDeFSC6Y
wCP8ApFtnls4GQV9ctsMrpIAq6nPv7SRXlx6K3WDdy+ak3/J2dwLElG3iDmBPRiT
iQ7f3eTLtl2Gnz3nvb1Suc4d/psNlzkbmkU0pyK0eKIwuAECyPaZUMiVZBWc6q4g
TwXfLe19Or4dJIkQiX2CR9dih0qAYk1c+aGC/2kn7bIjk6roEF05x2peVVtNj5vz
j7MF7fWzUqC0SAF0UrP756/c0iobHXNFTG/wW3GW4pP3i1d1dnbTAN5DSOpQKb5m
WXPtmZYqlAPdPxtHPPyhe44WSjp/xa9i3KjXPxTajCS9CsGEAEZLHh6Wmh+FXpvT
0tCmoSbgZX8qm39155mb6pEsVF7k3COlyiQvHYs8s3jzE58GkdY=
=zUVV
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
