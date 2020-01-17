Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89B7B1414AD
	for <lists+stable@lfdr.de>; Sat, 18 Jan 2020 00:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729952AbgAQXKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 18:10:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:41542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729099AbgAQXKY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jan 2020 18:10:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BABA921D7D;
        Fri, 17 Jan 2020 23:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579302623;
        bh=6cUJOafNcC0hYlt/oMzVsJQ4BJvjppjdOsVm8GgYn3E=;
        h=Date:From:To:Cc:Subject:From;
        b=UGtTpJ8L+e0nXY3XdexqUBemSYgU+7pZMPP4GVEeyuHbxpJlM4A/QQstE0VGV/HB0
         pCPgRSC+xFaClwAQT4K1oJJwRy/AmToQPqwU9FgMZXJSgPNHztFng5POAx1KMRutCK
         uxnvpWPiIpIx3NVdTYy94OtDG12+LQeGZ/+QEtcM=
Date:   Sat, 18 Jan 2020 00:10:21 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.166
Message-ID: <20200117231021.GA2128904@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.166 kernel.

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

 Documentation/ABI/testing/sysfs-bus-mei            |    2=20
 Makefile                                           |    2=20
 arch/arm64/boot/dts/qcom/apq8096-db820c.dtsi       |    2=20
 arch/arm64/include/asm/kvm_mmu.h                   |    5=20
 arch/arm64/include/asm/pgtable.h                   |    1=20
 arch/arm64/kernel/cpufeature.c                     |    5=20
 arch/arm64/kernel/hibernate.c                      |    3=20
 arch/arm64/mm/mmu.c                                |   32 +++
 arch/hexagon/include/asm/atomic.h                  |    8=20
 arch/hexagon/include/asm/bitops.h                  |    8=20
 arch/hexagon/include/asm/cmpxchg.h                 |    2=20
 arch/hexagon/include/asm/futex.h                   |    6=20
 arch/hexagon/include/asm/spinlock.h                |   20 +-
 arch/hexagon/kernel/stacktrace.c                   |    4=20
 arch/hexagon/kernel/vm_entry.S                     |    2=20
 arch/mips/boot/compressed/Makefile                 |    3=20
 arch/mips/kernel/cacheinfo.c                       |   27 +++
 arch/powerpc/platforms/powernv/pci.c               |   17 ++
 drivers/clk/samsung/clk-exynos5420.c               |    2=20
 drivers/dma/ioat/dma.c                             |    3=20
 drivers/dma/k3dma.c                                |   12 +
 drivers/gpio/gpio-mpc8xxx.c                        |    1=20
 drivers/gpio/gpio-zynq.c                           |    8=20
 drivers/gpio/gpiolib.c                             |    5=20
 drivers/gpu/drm/i915/i915_gem_context.c            |   13 -
 drivers/hid/hidraw.c                               |    7=20
 drivers/hid/uhid.c                                 |    5=20
 drivers/iio/imu/adis16480.c                        |    6=20
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |   12 -
 drivers/infiniband/hw/mlx5/mr.c                    |    2=20
 drivers/infiniband/ulp/srpt/ib_srpt.c              |   24 ++
 drivers/iommu/iommu.c                              |    1=20
 drivers/media/i2c/ov6650.c                         |   72 +++++---
 drivers/media/platform/exynos4-is/fimc-isp-video.c |    2=20
 drivers/media/usb/zr364xx/zr364xx.c                |    3=20
 drivers/misc/enclosure.c                           |    3=20
 drivers/mtd/spi-nor/spi-nor.c                      |    4=20
 drivers/net/wimax/i2400m/op-rfkill.c               |    1=20
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |    1=20
 drivers/net/wireless/realtek/rtlwifi/regd.c        |    2=20
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |    1=20
 drivers/pci/pcie/ptm.c                             |    2=20
 drivers/pinctrl/intel/pinctrl-lewisburg.c          |  171 ++++++++++------=
-----
 drivers/pinctrl/ti/pinctrl-ti-iodelay.c            |    2=20
 drivers/platform/x86/asus-wmi.c                    |    8=20
 drivers/rtc/rtc-msm6242.c                          |    3=20
 drivers/rtc/rtc-mt6397.c                           |   47 ++++-
 drivers/scsi/cxgbi/libcxgbi.c                      |    3=20
 drivers/scsi/sd.c                                  |   18 +-
 drivers/spi/spi-atmel.c                            |   10 -
 drivers/tty/serial/imx.c                           |    2=20
 drivers/tty/serial/pch_uart.c                      |    5=20
 fs/btrfs/file.c                                    |    5=20
 fs/cifs/smb2file.c                                 |    2=20
 fs/cifs/smb2pdu.c                                  |    1=20
 fs/f2fs/data.c                                     |    2=20
 fs/f2fs/file.c                                     |    2=20
 fs/nfs/nfs4proc.c                                  |    4=20
 fs/ocfs2/journal.c                                 |    8=20
 include/linux/poll.h                               |    4=20
 include/net/cfg80211.h                             |   11 +
 net/core/ethtool.c                                 |   16 +
 net/dccp/feat.c                                    |    7=20
 net/hsr/hsr_device.c                               |    2=20
 net/mac80211/cfg.c                                 |   58 -------
 net/mac80211/sta_info.c                            |    4=20
 net/socket.c                                       |    1=20
 net/sunrpc/xprtrdma/verbs.c                        |    2=20
 net/unix/af_unix.c                                 |   19 ++
 net/wireless/util.c                                |   45 +++++
 sound/soc/stm/stm32_spdifrx.c                      |   36 +++-
 tools/testing/selftests/rseq/settings              |    1=20
 72 files changed, 539 insertions(+), 301 deletions(-)

Alexander Usyskin (1):
      mei: fix modalias documentation

Alexander.Barabash@dell.com (1):
      ioat: ioat_alloc_ring() failure handling.

Alexandru Ardelean (1):
      iio: imu: adis16480: assign bias value only if operation succeeded

Andy Shevchenko (1):
      pinctrl: lewisburg: Update pin list according to v1.1v6

Arnd Bergmann (5):
      ethtool: reduce stack usage with clang
      fs/select: avoid clang stack usage warning
      scsi: sd: enable compat ioctls for sed-opal
      af_unix: add compat_ioctl support
      compat_ioctl: handle SIOCOUTQNSD

Bart Van Assche (1):
      RDMA/srpt: Report the SCSI residual to the initiator

Ben Hutchings (1):
      arm64: mm: Change page table pointer name in p[md]_set_huge()

Bjorn Helgaas (1):
      PCI/PTM: Remove spurious "d" from granularity message

Chao Yu (1):
      f2fs: fix potential overflow

Chuck Lever (1):
      xprtrdma: Fix completion wait during device removal

Colin Ian King (1):
      pinctl: ti: iodelay: fix error checking on pinctrl_count_index_with_a=
rgs call

Dedy Lansky (1):
      cfg80211/mac80211: make ieee80211_send_layer2_update a public function

Dirk Mueller (1):
      arm64: Check for errata before evaluating cpu features

Fabian Henneke (1):
      hidraw: Return EPOLLOUT from hidraw_poll

Geert Uytterhoeven (1):
      gpio: Fix error message on out-of-range GPIO in lookup table

Goldwyn Rodrigues (1):
      btrfs: simplify inode locking for RWF_NOWAIT

Greg Kroah-Hartman (1):
      Linux 4.14.166

James Bottomley (1):
      scsi: enclosure: Fix stale device oops with hot replug

Janusz Krzysztofik (3):
      media: ov6650: Fix incorrect use of JPEG colorspace
      media: ov6650: Fix some format attributes not under control
      media: ov6650: Fix .get_fmt() V4L2_SUBDEV_FORMAT_TRY support

Jian-Hong Pan (1):
      platform/x86: asus-wmi: Fix keyboard brightness cannot be set to 0

Jiri Kosina (1):
      HID: hidraw, uhid: Always report EPOLLOUT

John Stultz (1):
      dmaengine: k3dma: Avoid null pointer traversal

Johnson CH Chen (=E9=99=B3=E6=98=AD=E5=8B=B3) (1):
      gpio: mpc8xxx: Add platform device to gpiochip->parent

Jon Derrick (1):
      iommu: Remove device link to group on failure

Jouni Hogander (1):
      MIPS: Prevent link failure with kcov instrumentation

Jouni Malinen (1):
      mac80211: Do not send Layer 2 Update frame before authorization

Kai Li (1):
      ocfs2: call journal flush to mark journal as empty after journal reco=
very when mount

Kars de Jong (1):
      rtc: msm6242: Fix reading of 10-hour digit

Kristina Martsenko (1):
      arm64: don't open code page table entry creation

Laura Abbott (1):
      arm64: Make sure permission updates happen for pmd/pud

Leon Romanovsky (1):
      RDMA/mlx5: Return proper error value

Loic Poulain (1):
      arm64: dts: apq8096-db820c: Increase load on l21 for SDCARD

Mans Rullgard (1):
      spi: atmel: fix handling of cs_change set on non-last xfer

Marcel Holtmann (1):
      HID: hidraw: Fix returning EPOLLOUT from hidraw_poll

Marian Mihailescu (1):
      clk: samsung: exynos5420: Preserve CPU clocks configuration during su=
spend/resume

Mark Rutland (1):
      arm64: add sentinel to kpti_safe_list

Mathieu Desnoyers (1):
      rseq/selftests: Turn off timeout setting

Nathan Chancellor (2):
      cifs: Adjust indentation in smb2_open_file
      rtlwifi: Remove unnecessary NULL check in rtl_regd_init

Navid Emamdoost (3):
      wimax: i2400: fix memory leak
      wimax: i2400: Fix memory leak in i2400m_op_rfkill_sw_toggle
      iwlwifi: dbg_ini: fix memory leak in alloc_sgtable

Nick Desaulniers (2):
      hexagon: parenthesize registers in asm predicates
      hexagon: work around compiler crash

Oliver O'Halloran (1):
      powerpc/powernv: Disable native PCIe port management

Olivier Moysan (2):
      ASoC: stm32: spdifrx: fix inconsistent lock state
      ASoC: stm32: spdifrx: fix race condition in irq handler

Peng Fan (2):
      tty: serial: imx: use the sg count from dma_map_sg
      tty: serial: pch_uart: correct usage of dma_unmap_sg

Ran Bi (1):
      rtc: mt6397: fix alarm register overwrite

Sanjay Konduri (1):
      rsi: add fix for crash during assertions

Selvin Xavier (1):
      RDMA/bnxt_re: Fix Send Work Entry state check while polling completio=
ns

Sergei Shtylyov (2):
      mtd: spi-nor: fix silent truncation in spi_nor_read()
      mtd: spi-nor: fix silent truncation in spi_nor_read_raw()

Seung-Woo Kim (1):
      media: exynos4-is: Fix recursive locking in isp_video_release()

Swapna Manupati (1):
      gpio: zynq: Fix for bug in zynq_gpio_restore_context API

Taehee Yoo (1):
      hsr: reset network header when supervision frame is created

Trond Myklebust (1):
      NFSv4.x: Drop the slot if nfs4_delegreturn_prepare waits for layoutre=
turn

Tyler Hicks (1):
      drm/i915: Fix use-after-free when destroying GEM context

Vandana BN (1):
      media: usb:zr364xx:Fix KASAN:null-ptr-deref Read in zr364xx_vidioc_qu=
erycap

Varun Prakash (1):
      scsi: libcxgbi: fix NULL pointer dereference in cxgbi_device_destroy()

Vladimir Kondratiev (1):
      mips: cacheinfo: report shared CPU map

Will Deacon (1):
      arm64: Enforce BBM for huge IO/VMAP mappings

Xiang Chen (1):
      scsi: sd: Clear sdkp->protection_type if disk is reformatted without =
PI

YueHaibing (1):
      dccp: Fix memleak in __feat_register_sp

ZhangXiaoxu (1):
      cifs: Fix lease buffer length error


--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl4iPtgACgkQONu9yGCS
aT6sAA/+LrFQ9IEacOl1HPvaSRZIr//6xUkpUJVu83sh0aTgqNOPInmxUC3ZvnfU
Me//B6Z7xk7M4UtOjd8vky0GrOS5IWGsDBPmxPE1T7jZpHOTNv7fTAoLWkvK8jmy
SnndaXODlNoHjuzbpLvnPcPIIQsJyhG3iZuSrU/Ev5LOAhJY9BLQsneFwQJytLVe
jWVkryxBm+rTDJb/4MYEdGFqiqIZTE713CQ4KuK5kSl0VcJT8jXLcipAidJ0pSOZ
BVpNqNXfIeBnzho+zxDPgpISEruTm9nm4VUrQackPbUmb0D+zBX+/A1xUCzemLLj
lb2pRGQ0Zj7b06etkaJfCMtnQv2S0J5gOZewBZuPlA5ODYEmOV0qblFMpjfAIOjz
LsokFwq+QjUVC3j9EquUaL1JG0Io4qET0qQ/6yGwGKAx1DuQjtZBpQhmYbLXN06K
xieNNXp6Xjd5NawctNntM02BELayeWScnE2WBHoVbZzJX1JILw4pBaSVF27ipwpb
BshgrVs2228fwuWa0c0/KXHJdQFwjJD8gygQiHIyuqc7lTnXu2rQFnT9I9xFOnIH
ZdBWxI7aKCOQwmF/XSBKOSdDsCHenAyvyY/tRxhOWQ1ny2xLbM1ddFj8zkv/n9h6
kh5UKhmsAKdUSVOdGI+xwwuuPv1U6d/m0jD7p9e1JqrHdP9tDhY=
=t79b
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
