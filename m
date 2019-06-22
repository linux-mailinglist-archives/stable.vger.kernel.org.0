Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A88E64F4DD
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 11:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbfFVJpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 05:45:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:32906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbfFVJpr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Jun 2019 05:45:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8F2B2089C;
        Sat, 22 Jun 2019 09:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561196744;
        bh=/T0J1DD+cDjKW6HDDmZ3S5nukh9YLNH3QkFyyw3Pki8=;
        h=Date:From:To:Cc:Subject:From;
        b=hVG13O6wsTH3ZkXtil0lKod079RugBThuW4K1HmVeJSYHukcT1J7wJZe0eT8n6Lg3
         VrlnVggUZm3RqKgdjjl4JjIaBZgIoH7OygbQ2wLwpapWEQ5t3jGYsPYvBiAvr0nhs9
         vnRN34c6E189xEXsGnAb3g7AWaDRTOtuwjaU6fs0=
Date:   Sat, 22 Jun 2019 11:45:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.183
Message-ID: <20190622094542.GA12225@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.183 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                                           |    2=
=20
 arch/arm/boot/dts/exynos5420-arndale-octa.dts                      |    2=
=20
 arch/arm/boot/dts/imx6qdl.dtsi                                     |    2=
=20
 arch/arm/boot/dts/imx6sl.dtsi                                      |    2=
=20
 arch/arm/boot/dts/imx6sx.dtsi                                      |    2=
=20
 arch/arm/boot/dts/imx6ul.dtsi                                      |    2=
=20
 arch/arm/boot/dts/imx7s.dtsi                                       |    4 -
 arch/arm/include/asm/hardirq.h                                     |    1=
=20
 arch/arm/kernel/smp.c                                              |    6 +
 arch/arm/mach-exynos/suspend.c                                     |   19 =
+++++
 arch/arm64/mm/mmu.c                                                |   11 =
++-
 arch/ia64/mm/numa.c                                                |    1=
=20
 arch/powerpc/include/asm/kvm_host.h                                |    1=
=20
 arch/powerpc/kvm/book3s.c                                          |    1=
=20
 arch/powerpc/kvm/book3s_hv.c                                       |    9 =
--
 arch/powerpc/kvm/book3s_rtas.c                                     |   14 =
+---
 arch/s390/kvm/kvm-s390.c                                           |   35 =
++++++----
 arch/um/kernel/time.c                                              |    2=
=20
 arch/x86/events/intel/core.c                                       |    2=
=20
 arch/x86/events/intel/ds.c                                         |   28 =
++++----
 arch/x86/kernel/cpu/amd.c                                          |    7 =
+-
 arch/x86/kvm/pmu_intel.c                                           |   13 =
++-
 arch/x86/pci/irq.c                                                 |   10 =
++
 drivers/ata/libata-core.c                                          |    9 =
+-
 drivers/clk/rockchip/clk-rk3288.c                                  |   11 =
+++
 drivers/dma/idma64.c                                               |    6 +
 drivers/dma/idma64.h                                               |    2=
=20
 drivers/gpio/Kconfig                                               |    1=
=20
 drivers/gpio/gpio-omap.c                                           |   25 =
++++---
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c                       |    6 -
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c                            |    7 =
+-
 drivers/i2c/busses/i2c-acorn.c                                     |    1=
=20
 drivers/i2c/i2c-dev.c                                              |    1=
=20
 drivers/iommu/intel-iommu.c                                        |    7 =
+-
 drivers/isdn/mISDN/socket.c                                        |    5 -
 drivers/md/bcache/bset.c                                           |   16 =
+++-
 drivers/md/bcache/bset.h                                           |   34 =
+++++----
 drivers/media/v4l2-core/v4l2-ioctl.c                               |   17 =
++++
 drivers/mfd/intel-lpss.c                                           |    3=
=20
 drivers/mfd/tps65912-spi.c                                         |    1=
=20
 drivers/mfd/twl6040.c                                              |   13 =
+++
 drivers/misc/kgdbts.c                                              |    4 -
 drivers/net/ethernet/dec/tulip/de4x5.c                             |    1=
=20
 drivers/net/ethernet/emulex/benet/be_ethtool.c                     |    2=
=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c                     |    4 +
 drivers/net/ethernet/renesas/sh_eth.c                              |    4 +
 drivers/net/usb/ipheth.c                                           |    3=
=20
 drivers/nvmem/core.c                                               |   15 =
++--
 drivers/pci/host/pcie-rcar.c                                       |   10 =
++
 drivers/pci/host/pcie-xilinx.c                                     |   12 =
++-
 drivers/pci/hotplug/rpadlpar_core.c                                |    4 +
 drivers/platform/chrome/cros_ec_proto.c                            |   11 =
+++
 drivers/platform/x86/intel_pmc_ipc.c                               |    6 +
 drivers/pwm/core.c                                                 |   10 =
+-
 drivers/pwm/pwm-meson.c                                            |   25 =
++++---
 drivers/pwm/pwm-tiehrpwm.c                                         |    2=
=20
 drivers/pwm/sysfs.c                                                |   14 =
----
 drivers/rapidio/rio_cm.c                                           |    8 =
++
 drivers/rtc/rtc-pcf8523.c                                          |   32 =
++++++---
 drivers/scsi/bnx2fc/bnx2fc_hwi.c                                   |    2=
=20
 drivers/scsi/cxgbi/libcxgbi.c                                      |    4 +
 drivers/scsi/libsas/sas_expander.c                                 |    2=
=20
 drivers/scsi/lpfc/lpfc_els.c                                       |    5 +
 drivers/scsi/smartpqi/smartpqi_init.c                              |    2=
=20
 drivers/soc/mediatek/mtk-pmic-wrap.c                               |    2=
=20
 drivers/spi/spi-pxa2xx.c                                           |    7 =
--
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c |    9 =
--
 drivers/thermal/qcom/tsens.c                                       |    3=
=20
 drivers/tty/serial/8250/8250_dw.c                                  |    4 -
 drivers/tty/serial/sunhv.c                                         |    2=
=20
 drivers/usb/core/quirks.c                                          |    3=
=20
 drivers/usb/dwc2/hcd.c                                             |   10 =
++
 drivers/usb/serial/option.c                                        |    6 +
 drivers/usb/serial/pl2303.c                                        |    1=
=20
 drivers/usb/serial/pl2303.h                                        |    3=
=20
 drivers/usb/storage/unusual_realtek.h                              |    5 +
 drivers/video/fbdev/hgafb.c                                        |    2=
=20
 drivers/video/fbdev/imsttfb.c                                      |    5 +
 drivers/watchdog/Kconfig                                           |    1=
=20
 drivers/watchdog/imx2_wdt.c                                        |    4 -
 fs/configfs/dir.c                                                  |   31 =
+++++---
 fs/f2fs/inode.c                                                    |    1=
=20
 fs/f2fs/recovery.c                                                 |   10 =
++
 fs/f2fs/segment.h                                                  |    3=
=20
 fs/fat/file.c                                                      |   11 =
++-
 fs/fuse/dev.c                                                      |    2=
=20
 fs/inode.c                                                         |    9 =
++
 fs/nfsd/vfs.h                                                      |    5 +
 fs/ocfs2/dcache.c                                                  |   12 =
+++
 include/linux/cgroup.h                                             |   10 =
++
 include/linux/pwm.h                                                |    5 -
 include/net/bluetooth/hci_core.h                                   |    3=
=20
 ipc/mqueue.c                                                       |   10 =
++
 ipc/msgutil.c                                                      |    6 +
 kernel/Makefile                                                    |    1=
=20
 kernel/cred.c                                                      |    9 =
++
 kernel/events/ring_buffer.c                                        |   33 =
++++++++-
 kernel/ptrace.c                                                    |   20 =
+++++
 kernel/sys.c                                                       |    2=
=20
 kernel/sysctl.c                                                    |    6 +
 kernel/time/ntp.c                                                  |    2=
=20
 mm/cma.c                                                           |    4 -
 mm/cma_debug.c                                                     |    2=
=20
 mm/hugetlb.c                                                       |   21 =
++++--
 mm/list_lru.c                                                      |    2=
=20
 mm/page_alloc.c                                                    |    6 +
 mm/slab.c                                                          |    6 +
 net/ax25/ax25_route.c                                              |    2=
=20
 net/bluetooth/hci_conn.c                                           |    8 =
--
 net/core/neighbour.c                                               |    7 =
++
 net/ipv6/ip6_flowlabel.c                                           |    7 =
+-
 net/lapb/lapb_iface.c                                              |    1=
=20
 sound/core/seq/seq_clientmgr.c                                     |   10 =
--
 sound/core/seq/seq_ports.c                                         |   15 =
++--
 sound/core/seq/seq_ports.h                                         |    5 -
 sound/firewire/oxfw/oxfw.c                                         |    3=
=20
 sound/pci/hda/hda_intel.c                                          |    6 -
 sound/soc/codecs/cs42xx8.c                                         |    1=
=20
 sound/soc/fsl/fsl_asrc.c                                           |    4 -
 tools/objtool/check.c                                              |    8 =
+-
 tools/perf/arch/s390/util/machine.c                                |    9 =
+-
 tools/perf/util/data-convert-bt.c                                  |    2=
=20
 tools/testing/selftests/netfilter/nft_nat.sh                       |    6 +
 tools/testing/selftests/timers/adjtick.c                           |    1=
=20
 tools/testing/selftests/timers/leapcrash.c                         |    1=
=20
 tools/testing/selftests/timers/mqueue-lat.c                        |    1=
=20
 tools/testing/selftests/timers/nanosleep.c                         |    1=
=20
 tools/testing/selftests/timers/nsleep-lat.c                        |    1=
=20
 tools/testing/selftests/timers/raw_skew.c                          |    1=
=20
 tools/testing/selftests/timers/set-tai.c                           |    1=
=20
 tools/testing/selftests/timers/set-tz.c                            |    2=
=20
 tools/testing/selftests/timers/threadtest.c                        |    1=
=20
 tools/testing/selftests/timers/valid-adjtimex.c                    |    2=
=20
 133 files changed, 645 insertions(+), 283 deletions(-)

Alexander Lochmann (1):
      Abort file_remove_privs() for non-reg. files

Amit Cohen (1):
      mlxsw: spectrum: Prevent force of 56G

Amit Kucheria (1):
      drivers: thermal: tsens: Don't print error message on -EPROBE_DEFER

Andrey Smirnov (5):
      ARM: dts: imx6sx: Specify IMX6SX_CLK_IPG as "ahb" clock to SDMA
      ARM: dts: imx7d: Specify IMX7D_CLK_IPG as "ipg" clock to SDMA
      ARM: dts: imx6ul: Specify IMX6UL_CLK_IPG as "ipg" clock to SDMA
      ARM: dts: imx6sx: Specify IMX6SX_CLK_IPG as "ipg" clock to SDMA
      ARM: dts: imx6qdl: Specify IMX6QDL_CLK_IPG as "ipg" clock to SDMA

Andy Shevchenko (1):
      dmaengine: idma64: Use actual device for DMA transfers

Arnd Bergmann (1):
      ARM: prevent tracing IPI_CPU_BACKTRACE

Baruch Siach (1):
      rtc: pcf8523: don't return invalid date when battery is low

Bernd Eckstein (1):
      usbnet: ipheth: fix racing condition

Binbin Wu (1):
      mfd: intel-lpss: Set the device in reset state when init

Chao Yu (3):
      f2fs: fix to avoid panic in do_recover_data()
      f2fs: fix to clear dirty inode in error path of f2fs_iget()
      f2fs: fix to do sanity check on valid block count of segment

Chris Packham (1):
      USB: serial: pl2303: add Allied Telesis VT-Kit3

Christian Borntraeger (1):
      KVM: s390: fix memory slot handling for KVM_SET_USER_MEMORY_REGION

Christian Brauner (1):
      sysctl: return -EINVAL if val violates minmax

Christoph Vogtl=C3=A4nder (1):
      pwm: tiehrpwm: Update shadow register for disabling PWMs

Colin Ian King (1):
      scsi: bnx2fc: fix incorrect cast to u64 on shift operation

Coly Li (1):
      bcache: fix stack corruption by PRECEDING_KEY()

Cyrill Gorcunov (1):
      kernel/sys.c: prctl: fix false positive in validate_prctl_map()

Dan Carpenter (1):
      mISDN: make sure device name is NUL terminated

Daniel Gomez (1):
      mfd: tps65912-spi: Add missing of table registration

Daniele Palmas (1):
      USB: serial: option: add Telit 0x1260 and 0x1261 compositions

Douglas Anderson (1):
      clk: rockchip: Turn on "aclk_dmac1" for suspend on rk3288

Enrico Granata (1):
      platform/chrome: cros_ec_proto: check for NULL transfer function

Eric Dumazet (3):
      ax25: fix inconsistent lock state in ax25_destroy_timer
      ipv6: flowlabel: fl6_sock_lookup() must use atomic_inc_not_zero
      neigh: fix use-after-free read in pneigh_get_next

Eric W. Biederman (1):
      signal/ptrace: Don't leak unitialized kernel memory with PTRACE_PEEK_=
SIGINFO

Frank van der Linden (1):
      x86/CPU/AMD: Don't force the CPB cap when running under a hypervisor

Georg Hofmann (1):
      watchdog: imx2_wdt: Fix set_timeout for big timeout values

Greg Kroah-Hartman (3):
      Revert "Bluetooth: Align minimum encryption key size for LE and BR/ED=
R connections"
      Revert "staging: vc04_services: prevent integer overflow in create_pa=
gelist()"
      Linux 4.9.183

Hans Verkuil (1):
      media: v4l2-ioctl: clear fields in s_parm

Hans de Goede (1):
      libata: Extend quirks for the ST1000LM024 drives with NOLPM quirk

Hou Tao (1):
      fs/fat/file.c: issue flush after the writeback of FAT

Ivan Vecera (1):
      be2net: Fix number of Rx queues used for flow hashing

J. Bruce Fields (1):
      nfsd: allow fh_want_write to be called twice

James Smart (1):
      scsi: lpfc: add check for loss of ndlp when sending RRQ

Jann Horn (1):
      ptrace: restore smp_rmb() in __ptrace_may_access()

Jason Yan (1):
      scsi: libsas: delete sas port if expander discover failed

Jeffrin Jose T (1):
      selftests: netfilter: missing error check when setting up veth interf=
ace

Jeremy Sowden (1):
      lapb: fixed leak of control-blocks.

John Paul Adrian Glaubitz (1):
      sunhv: Fix device naming inconsistency between sunhv_console and sunh=
v_reg

Jorge Ramirez-Ortiz (1):
      nvmem: core: fix read buffer in place

Josh Poimboeuf (1):
      objtool: Don't use ignore flag for fake jumps

Junxiao Chang (1):
      platform/x86: intel_pmc_ipc: adding error handling

J=C3=B6rgen Storvist (1):
      USB: serial: option: add support for Simcom SIM7500/SIM7600 RNDIS mode

Kai-Heng Feng (1):
      USB: usb-storage: Add new ID to ums-realtek

Kangjie Lu (5):
      rapidio: fix a NULL pointer dereference when create_workqueue() fails
      PCI: rcar: Fix a potential NULL pointer dereference
      video: hgafb: fix potential NULL pointer dereference
      video: imsttfb: fix potential NULL pointer dereferences
      PCI: xilinx: Check for __get_free_pages() failure

Kees Cook (2):
      selftests/timers: Add missing fflush(stdout) calls
      net: tulip: de4x5: Drop redundant MODULE_DEVICE_TABLE()

Kirill Smelkov (1):
      fuse: retrieve: cap requested size to negotiated max_write

Krzysztof Kozlowski (1):
      ARM: dts: exynos: Always enable necessary APIO_1V8 and ABB_1V8 regula=
tors on Arndale Octa

Li Rongqing (1):
      ipc: prevent lockup on alloc_msg and free_msg

Lianbo Jiang (1):
      scsi: smartpqi: properly set both the DMA mask and the coherent DMA m=
ask

Linxu Fang (1):
      mem-hotplug: fix node spanned pages when we have a node with only ZON=
E_MOVABLE

Lu Baolu (1):
      iommu/vt-d: Set intel_iommu_gfx_mapped correctly

Maciej =C5=BBenczykowski (1):
      uml: fix a boot splat wrt use of cpu_all_mask

Marco Zatta (1):
      USB: Fix chipmunk-like voice when using Logitech C270 for recording a=
udio.

Marek Szyprowski (1):
      ARM: exynos: Fix undefined instruction during Exynos5422 resume

Marek Vasut (1):
      PCI: rcar: Fix 64bit MSI message address handling

Mark Rutland (1):
      arm64/mm: Inhibit huge-vmap with ptdump

Martin Blumenstingl (1):
      pwm: meson: Use the spin-lock only to protect register modifications

Martin Schiller (1):
      usb: dwc2: Fix DMA cache alignment issues

Matt Redfearn (1):
      drm/bridge: adv7511: Fix low refresh rate selection

Mike Kravetz (1):
      hugetlbfs: on restore reserve error path retain subpool reservation

Miroslav Lichvar (1):
      ntp: Allow TAI-UTC offset to be set to zero

Murray McAllister (2):
      drm/vmwgfx: integer underflow in vmw_cmd_dx_set_shader() leading to a=
n invalid read
      drm/vmwgfx: NULL pointer dereference from vmw_cmd_dx_view_define()

Nathan Chancellor (1):
      soc: mediatek: pwrap: Zero initialize rdata in pwrap_init_cipher

Paolo Bonzini (1):
      KVM: x86/pmu: do not mask the value that is written to fixed PMUs

Paul Mackerras (2):
      KVM: PPC: Book3S: Use new mutex to synchronize access to rtas token l=
ist
      KVM: PPC: Book3S HV: Don't take kvm->lock around kvm_for_each_vcpu

Peter Zijlstra (2):
      x86/uaccess, kcov: Disable stack protector
      perf/ring_buffer: Add ordering to rb->nest increment

Phong Hoang (1):
      pwm: Fix deadlock warning when removing PWM device

Qian Cai (1):
      mm/slab.c: fix an infinite loop in leaks_show()

Randy Dunlap (2):
      gpio: fix gpio-adp5588 build errors
      ia64: fix build errors by exporting paddr_to_nid()

Russell King (1):
      i2c: acorn: fix i2c warning

S.j. Wang (2):
      ASoC: cs42xx8: Add regcache mask dirty
      ASoC: fsl_asrc: Fix the issue about unsupported rate

Sahitya Tummala (1):
      configfs: Fix use-after-free when accessing sd->s_dentry

Shakeel Butt (1):
      mm/list_lru.c: fix memory leak in __memcg_init_list_lru_node

Shawn Landden (1):
      perf data: Fix 'strncat may truncate' build failure with recent gcc

Stephane Eranian (2):
      perf/x86/intel: Allow PEBS multi-entry in watermark mode
      perf/x86/intel/ds: Fix EVENT vs. UEVENT PEBS constraints

Takashi Iwai (5):
      ALSA: hda - Register irq handler after the chip initialization
      ALSA: seq: Cover unsubscribe_port() in list_mutex
      ALSA: seq: Protect in-kernel ioctl calls with mutex
      ALSA: seq: Fix race of get-subscription call vs port-delete ioctls
      Revert "ALSA: seq: Protect in-kernel ioctl calls with mutex"

Takashi Sakamoto (1):
      ALSA: oxfw: allow PCM capture for Stanton SCS.1m

Tejun Heo (1):
      cgroup: Use css_tryget() instead of css_tryget_online() in task_get_c=
ss()

Thomas Richter (1):
      perf record: Fix s390 missing module symbol and warning for non-root =
users

Tony Lindgren (2):
      mfd: twl6040: Fix device init errors for ACCCTL register
      gpio: gpio-omap: add check for off wake capable gpios

Tyrel Datwyler (1):
      PCI: rpadlpar: Fix leaked device_node references in add/remove paths

Varun Prakash (1):
      scsi: libcxgbi: add a check for NULL pointer in cxgbi_check_route()

Vladimir Zapolskiy (1):
      watchdog: fix compile time error of pretimeout governors

Wengang Wang (1):
      fs/ocfs2: fix race in ocfs2_dentry_attach_lock()

Wenwen Wang (1):
      x86/PCI: Fix PCI IRQ routing table memory leak

Yabin Cui (1):
      perf/ring_buffer: Fix exposing a temporarily decreased data_head

Yingjoe Chen (1):
      i2c: dev: fix potential memory leak in i2cdev_ioctl_rdwr

Yoshihiro Shimoda (1):
      net: sh_eth: fix mdio access in sh_eth_close() for R-Car Gen2 and RZ/=
A1 SoCs

Young Xiao (1):
      Drivers: misc: fix out-of-bounds access in function param_set_kgdbts_=
var

Yue Hu (2):
      mm/cma.c: fix crash on CMA allocation if bitmap allocation fails
      mm/cma_debug.c: fix the break condition in cma_maxchunk_get()

YueHaibing (1):
      configfs: fix possible use-after-free in configfs_register_group


--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl0N+MIACgkQONu9yGCS
aT66ww/+L/F8DKWFq41e8Zpc4K0EnGRb3p5GdS6ApY7lrXuULZmShRh/6XbS3Pkc
e3FQ0hh684pnWbRXrMQefa9nlW2x44qomnZT9w4M+7gtOKStBvilVHin89JClg5r
DAmHYrKd1hd+9Fz2/9neUGccmzILtNRXrgJqSbHpzYI+2+l185dQTqSul94Yfez7
+VfFC1dawlF9AKwoSGuXDBtPfY+nfCzxQxMjOPVWgkAvslb7Rhb4maDNU66c6tCV
0Cy+qqnnVJHJkiHZCmbGKj/E7KqEZPbiAl2+Lw+2dD7a5cfxCqNWJXROIWp7FVV+
UDHDIg5Nn7D6veyFhTlQ2FXclumjYQufPP4z9ncTBjcxmedDTt+WT7FCpY62DPCV
2LITotmLKGCfk/Mn/txGibwEzYS8GD4hGlYEZP8j/mdBZLHHBo4FMvzzFExe2hd2
E4UOP7xdesNBTZn5dxsPpGyfwtB+Q/lDfWf8UY0Ar1PQZHj0zcDPb2l2R4up9dkH
G+eVq27ITdyfu43ZdDAGjngvnuGaRikke7l+/I3RZDhna+9AhxYKMdAI3H2cAlAY
5lM7n1VivMK6zAtc9gcQomOErTTX8jPNWEx2aBDdSHZgMT9M25jr5wiHJcKKbRfM
83wvd+dHHufZDytaC9xUCuM1bIczmwiOXJoJgbzBFshO2FKFqS4=
=CcnY
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
