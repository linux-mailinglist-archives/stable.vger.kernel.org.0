Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 235F712889B
	for <lists+stable@lfdr.de>; Sat, 21 Dec 2019 11:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbfLUKlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Dec 2019 05:41:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:47624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbfLUKlF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Dec 2019 05:41:05 -0500
Received: from localhost (unknown [38.98.37.136])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E874224654;
        Sat, 21 Dec 2019 10:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576924863;
        bh=sdgt+WGtnA/Z981Gsvm4vKkgKg2gfCSgPU8uWpPlp0c=;
        h=Date:From:To:Cc:Subject:From;
        b=KuQoCFCYi6UmwexXTBV+49Q2o2DSyxvHLMBg1teRZHap6i7XCeShawSgxjbGnWTs4
         r0N0v9vaf9Aw1h1dGQp1+9WWHSF9fkK5w59LxrRunpaGcOLb9pm0PjTqCutzbEybUN
         ChIUDL6+ZoyvqjeMM00q+1AznhZg2m3D7NhJAYRA=
Date:   Sat, 21 Dec 2019 11:40:34 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.207
Message-ID: <20191221104034.GA61612@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.207 kernel.

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

 Documentation/devicetree/bindings/rtc/abracon,abx80x.txt |    2=20
 Makefile                                                 |   13 --
 arch/arm/Kconfig.debug                                   |   23 ++-
 arch/arm/boot/dts/arm-realview-pb1176.dts                |    4=20
 arch/arm/boot/dts/arm-realview-pb11mp.dts                |    4=20
 arch/arm/boot/dts/arm-realview-pbx.dtsi                  |    5=20
 arch/arm/boot/dts/exynos3250.dtsi                        |    2=20
 arch/arm/boot/dts/mmp2.dtsi                              |    2=20
 arch/arm/boot/dts/omap3-pandora-common.dtsi              |   36 +++++
 arch/arm/boot/dts/omap3-tao3530.dtsi                     |    2=20
 arch/arm/boot/dts/pxa27x.dtsi                            |    2=20
 arch/arm/boot/dts/pxa2xx.dtsi                            |    7 -
 arch/arm/boot/dts/pxa3xx.dtsi                            |    2=20
 arch/arm/boot/dts/rk3288-rock2-som.dtsi                  |    2=20
 arch/arm/boot/dts/s3c6410-mini6410.dts                   |    4=20
 arch/arm/boot/dts/s3c6410-smdk6410.dts                   |    4=20
 arch/arm/boot/dts/sun6i-a31.dtsi                         |    2=20
 arch/arm/boot/dts/sun7i-a20.dtsi                         |    2=20
 arch/arm/include/asm/uaccess.h                           |   18 ++
 arch/arm/lib/getuser.S                                   |   11 +
 arch/arm/lib/putuser.S                                   |   20 +--
 arch/arm/mach-omap1/id.c                                 |    6=20
 arch/arm/mach-omap2/id.c                                 |    4=20
 arch/arm/mach-omap2/pdata-quirks.c                       |   93 ----------=
-----
 arch/arm/mach-tegra/reset-handler.S                      |    6=20
 arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi           |    2=20
 arch/mips/Kconfig                                        |    1=20
 arch/mips/cavium-octeon/executive/cvmx-cmd-queue.c       |    2=20
 arch/mips/cavium-octeon/octeon-platform.c                |    2=20
 arch/mips/include/asm/octeon/cvmx-pko.h                  |    2=20
 arch/powerpc/include/asm/sfp-machine.h                   |   92 ++++------=
----
 arch/powerpc/include/asm/vdso_datapage.h                 |    2=20
 arch/powerpc/kernel/asm-offsets.c                        |    2=20
 arch/powerpc/kernel/time.c                               |    1=20
 arch/powerpc/kernel/vdso32/gettimeofday.S                |    7 -
 arch/powerpc/kernel/vdso64/cacheflush.S                  |    4=20
 arch/powerpc/kernel/vdso64/gettimeofday.S                |    7 -
 arch/x86/kernel/cpu/mcheck/mce.c                         |   30 ----
 arch/x86/kernel/cpu/mcheck/mce_amd.c                     |   36 +++++
 arch/x86/kvm/cpuid.c                                     |    5=20
 arch/x86/kvm/x86.c                                       |   14 +-
 arch/x86/pci/fixup.c                                     |   11 +
 arch/xtensa/mm/tlb.c                                     |    4=20
 block/blk-mq-sysfs.c                                     |   15 +-
 crypto/crypto_user.c                                     |    4=20
 crypto/ecc.c                                             |    3=20
 drivers/acpi/bus.c                                       |    2=20
 drivers/acpi/device_pm.c                                 |   12 +
 drivers/acpi/osl.c                                       |   28 ++--
 drivers/block/rsxx/core.c                                |    2=20
 drivers/char/ppdev.c                                     |   16 +-
 drivers/clk/rockchip/clk-rk3188.c                        |    8 -
 drivers/clk/sunxi-ng/ccu-sun8i-h3.c                      |    2=20
 drivers/cpuidle/driver.c                                 |   15 +-
 drivers/crypto/amcc/crypto4xx_core.c                     |    6=20
 drivers/crypto/ccp/ccp-dmaengine.c                       |    1=20
 drivers/devfreq/devfreq.c                                |   12 +
 drivers/dma-buf/sync_file.c                              |    2=20
 drivers/dma/coh901318.c                                  |    5=20
 drivers/extcon/extcon-max8997.c                          |   10 -
 drivers/firmware/qcom_scm-64.c                           |    2=20
 drivers/gpu/drm/i810/i810_dma.c                          |    4=20
 drivers/gpu/drm/radeon/r100.c                            |    4=20
 drivers/gpu/drm/radeon/r200.c                            |    4=20
 drivers/hwtracing/coresight/coresight-etm4x-sysfs.c      |   21 ++-
 drivers/i2c/busses/i2c-imx.c                             |    3=20
 drivers/iio/humidity/hdc100x.c                           |    2=20
 drivers/iio/imu/adis16480.c                              |    1=20
 drivers/infiniband/hw/hns/hns_roce_hem.h                 |    2=20
 drivers/infiniband/hw/mlx4/sysfs.c                       |   12 -
 drivers/infiniband/hw/qib/qib_sysfs.c                    |    6=20
 drivers/input/touchscreen/cyttsp4_core.c                 |    7 -
 drivers/input/touchscreen/goodix.c                       |    9 +
 drivers/isdn/gigaset/usb-gigaset.c                       |   23 ++-
 drivers/md/persistent-data/dm-btree-remove.c             |    8 +
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c            |    3=20
 drivers/media/radio/radio-wl1273.c                       |    3=20
 drivers/media/usb/stkwebcam/stk-webcam.c                 |    6=20
 drivers/misc/altera-stapl/altera.c                       |    3=20
 drivers/mmc/host/omap_hsmmc.c                            |   30 ++++
 drivers/mtd/devices/spear_smi.c                          |   38 +++++-
 drivers/net/can/slcan.c                                  |    1=20
 drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c      |    6=20
 drivers/net/ethernet/cirrus/ep93xx_eth.c                 |    5=20
 drivers/net/ethernet/intel/e100.c                        |    4=20
 drivers/net/ethernet/mellanox/mlx4/main.c                |   11 -
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c     |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/qp.c             |    4=20
 drivers/net/ethernet/stmicro/stmmac/common.h             |    2=20
 drivers/net/ethernet/stmicro/stmmac/descs_com.h          |   23 ++-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c       |    2=20
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c           |   10 +
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c          |   10 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c        |   20 +--
 drivers/net/ethernet/ti/cpsw.c                           |    2=20
 drivers/net/wireless/ath/ar5523/ar5523.c                 |    3=20
 drivers/net/wireless/ath/ath10k/pci.c                    |    9 -
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c        |   15 ++
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c      |    9 -
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c      |    1=20
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c     |   25 +++-
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.h     |    2=20
 drivers/nfc/nxp-nci/i2c.c                                |    6=20
 drivers/nvme/host/core.c                                 |    4=20
 drivers/pci/msi.c                                        |    2=20
 drivers/pci/quirks.c                                     |    2=20
 drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c                 |   23 ++-
 drivers/pinctrl/samsung/pinctrl-s3c24xx.c                |    6=20
 drivers/pinctrl/samsung/pinctrl-s3c64xx.c                |    3=20
 drivers/pinctrl/samsung/pinctrl-samsung.c                |   10 +
 drivers/regulator/core.c                                 |   42 +-----
 drivers/rtc/rtc-max8997.c                                |    2=20
 drivers/s390/scsi/zfcp_dbf.c                             |    8 -
 drivers/s390/scsi/zfcp_erp.c                             |    3=20
 drivers/scsi/libiscsi.c                                  |    4=20
 drivers/scsi/lpfc/lpfc.h                                 |    3=20
 drivers/scsi/lpfc/lpfc_attr.c                            |   12 +
 drivers/scsi/lpfc/lpfc_init.c                            |    3=20
 drivers/scsi/qla2xxx/qla_attr.c                          |    3=20
 drivers/scsi/qla2xxx/qla_bsg.c                           |   15 +-
 drivers/scsi/qla2xxx/qla_target.c                        |   11 -
 drivers/spi/spi-atmel.c                                  |    6=20
 drivers/staging/iio/addac/adt7316-i2c.c                  |    2=20
 drivers/staging/media/pulse8-cec/pulse8-cec.c            |    2=20
 drivers/staging/rtl8188eu/os_dep/usb_intf.c              |    2=20
 drivers/staging/rtl8712/usb_intf.c                       |    2=20
 drivers/thermal/thermal_core.c                           |    4=20
 drivers/tty/n_hdlc.c                                     |    4=20
 drivers/tty/n_r3964.c                                    |    2=20
 drivers/tty/n_tty.c                                      |    8 -
 drivers/tty/serial/amba-pl011.c                          |    6=20
 drivers/tty/serial/fsl_lpuart.c                          |    4=20
 drivers/tty/serial/ifx6x60.c                             |    3=20
 drivers/tty/serial/imx.c                                 |    2=20
 drivers/tty/serial/msm_serial.c                          |    6=20
 drivers/tty/serial/serial_core.c                         |    2=20
 drivers/tty/tty_ldisc.c                                  |    7 +
 drivers/tty/vt/keyboard.c                                |    2=20
 drivers/usb/atm/ueagle-atm.c                             |   18 +-
 drivers/usb/core/hub.c                                   |    5=20
 drivers/usb/core/urb.c                                   |    1=20
 drivers/usb/dwc3/core.c                                  |    3=20
 drivers/usb/gadget/configfs.c                            |    1=20
 drivers/usb/gadget/function/u_serial.c                   |    2=20
 drivers/usb/host/xhci-hub.c                              |   16 +-
 drivers/usb/host/xhci-mem.c                              |    4=20
 drivers/usb/host/xhci-pci.c                              |   13 ++
 drivers/usb/host/xhci-ring.c                             |    6=20
 drivers/usb/host/xhci.c                                  |    7 -
 drivers/usb/host/xhci.h                                  |    2=20
 drivers/usb/misc/adutux.c                                |    2=20
 drivers/usb/misc/idmouse.c                               |    2=20
 drivers/usb/mon/mon_bin.c                                |   32 +++--
 drivers/usb/serial/io_edgeport.c                         |   10 -
 drivers/usb/storage/uas.c                                |   10 +
 drivers/vfio/pci/vfio_pci_intrs.c                        |    2=20
 drivers/video/hdmi.c                                     |    8 -
 drivers/virtio/virtio_balloon.c                          |   11 +
 fs/autofs4/expire.c                                      |    5=20
 fs/btrfs/file.c                                          |    2=20
 fs/btrfs/free-space-cache.c                              |    6=20
 fs/btrfs/inode.c                                         |    3=20
 fs/btrfs/send.c                                          |   25 +++-
 fs/btrfs/volumes.h                                       |    1=20
 fs/cifs/file.c                                           |   14 +-
 fs/cifs/smb2misc.c                                       |    7 -
 fs/dlm/lockspace.c                                       |    1=20
 fs/dlm/memory.c                                          |    9 -
 fs/dlm/user.c                                            |    3=20
 fs/exportfs/expfs.c                                      |   31 +++--
 fs/ext2/inode.c                                          |    7 -
 fs/ext4/inode.c                                          |   12 +
 fs/fuse/dir.c                                            |   27 +++-
 fs/fuse/fuse_i.h                                         |    2=20
 fs/nfsd/nfs4recover.c                                    |   17 --
 fs/nfsd/vfs.c                                            |   17 ++
 fs/ocfs2/quota_global.c                                  |    2=20
 fs/quota/dquot.c                                         |   11 -
 fs/reiserfs/inode.c                                      |   12 +
 fs/reiserfs/namei.c                                      |    7 -
 fs/reiserfs/reiserfs.h                                   |    2=20
 fs/reiserfs/super.c                                      |    2=20
 fs/reiserfs/xattr.c                                      |   19 +--
 fs/reiserfs/xattr_acl.c                                  |    4=20
 include/linux/acpi.h                                     |    2=20
 include/linux/atalk.h                                    |    2=20
 include/linux/dma-mapping.h                              |    3=20
 include/linux/jbd2.h                                     |    4=20
 include/linux/mtd/mtd.h                                  |    2=20
 include/linux/netdevice.h                                |    5=20
 include/linux/quotaops.h                                 |   10 +
 include/linux/regulator/consumer.h                       |    2=20
 include/linux/serial_core.h                              |   37 +++++
 include/linux/time.h                                     |   12 +
 include/linux/tty.h                                      |    7 +
 include/math-emu/soft-fp.h                               |    2=20
 include/net/ip.h                                         |    5=20
 include/net/tcp.h                                        |   18 ++
 kernel/audit_watch.c                                     |    2=20
 kernel/cgroup_pids.c                                     |   11 -
 kernel/module.c                                          |    2=20
 kernel/sched/fair.c                                      |   36 +++--
 kernel/workqueue.c                                       |   38 ++++--
 lib/raid6/unroll.awk                                     |    2=20
 mm/shmem.c                                               |    2=20
 net/appletalk/aarp.c                                     |   15 +-
 net/appletalk/ddp.c                                      |   21 ++-
 net/bridge/br_device.c                                   |    6=20
 net/core/dev.c                                           |    3=20
 net/ipv4/devinet.c                                       |    5=20
 net/ipv4/ip_output.c                                     |   14 +-
 net/ipv4/tcp_output.c                                    |    5=20
 net/ipv4/tcp_timer.c                                     |   10 -
 net/openvswitch/conntrack.c                              |   11 +
 net/sunrpc/cache.c                                       |    6=20
 net/tipc/core.c                                          |   29 ++--
 net/x25/af_x25.c                                         |   18 +-
 scripts/mod/modpost.c                                    |   12 +
 sound/core/oss/linear.c                                  |    2=20
 sound/core/oss/mulaw.c                                   |    2=20
 sound/core/oss/route.c                                   |    2=20
 sound/core/pcm_lib.c                                     |    8 -
 sound/pci/hda/hda_bind.c                                 |    4=20
 sound/pci/hda/hda_intel.c                                |    3=20
 sound/soc/soc-jack.c                                     |    3=20
 225 files changed, 1264 insertions(+), 748 deletions(-)

Aaro Koskinen (5):
      MIPS: OCTEON: octeon-platform: fix typing
      ARM: OMAP1/2: fix SoC name printing
      MIPS: OCTEON: cvmx_pko_mem_debug8: use oldest forward compatible defi=
nition
      net: stmmac: use correct DMA buffer size in the RX descriptor
      net: stmmac: don't stop NAPI processing when dropping a packet

Aaron Conole (1):
      openvswitch: support asymmetric conntrack

Al Viro (3):
      autofs: fix a leak in autofs_expire_indirect()
      exportfs_decode_fh(): negative pinned may become positive without the=
 parent locked
      audit_get_nd(): don't unlock parent too early

Alastair D'Silva (1):
      powerpc: Allow 64bit VDSO __kernel_sync_dicache to work across ranges=
 >4GB

Aleksa Sarai (1):
      cgroup: pids: use atomic64_t for pids->limit

Alex Deucher (1):
      drm/radeon: fix r1xx/r2xx register checker for POT textures

Alexey Dobriyan (1):
      ACPI: fix acpi_find_child_device() invocation in acpi_preset_companio=
n()

Andreas Pape (1):
      media: stkwebcam: Bugfix for wrong return values

Andrei Otcheretianski (1):
      iwlwifi: mvm: Send non offchannel traffic via AP sta

Ard Biesheuvel (1):
      crypto: ecdh - fix big endian bug in ECC library

Arjun Vynipadath (1):
      cxgb4vf: fix memleak in mac_hlist initialization

Arnd Bergmann (1):
      ppdev: fix PPGETTIME/PPSETTIME ioctls

Bart Van Assche (4):
      scsi: qla2xxx: Fix session lookup in qlt_abort_work()
      scsi: qla2xxx: Fix qla24xx_process_bidir_cmd()
      scsi: qla2xxx: Always check the qla2x00_wait_for_hba_online() return =
value
      scsi: iscsi: Fix a potential deadlock in the timeout handler

Baruch Siach (1):
      rtc: dt-binding: abx80x: fix resistance scale

Brian Masney (1):
      pinctrl: qcom: ssbi-gpio: fix gpio-hog related boot issues

Brian Norris (1):
      usb: dwc3: don't log probe deferrals; but do log other error codes

Chen Jun (1):
      mm/shmem.c: cast the type of unmap_start to u64

Chen-Yu Tsai (1):
      clk: sunxi-ng: h3/h5: Fix CSI_MCLK parent

Chengguang Xu (1):
      ext2: check err when partial !=3D NULL

Chris Lesiak (1):
      iio: humidity: hdc100x: fix IIO_HUMIDITYRELATIVE channel reporting

Christian Lamparter (1):
      crypto: crypto4xx - fix double-free in crypto4xx_destroy_sdr

Christophe JAILLET (1):
      rtc: max8997: Fix the returned value in case of error in 'max8997_rtc=
_read_alarm()'

Chuhong Yuan (3):
      serial: ifx6x60: add missed pm_runtime_disable
      rsxx: add missed destroy_workqueue calls in remove
      net: ep93xx_eth: fix mismatch of request_mem_region in remove

Cl=C3=A9ment P=C3=A9ron (1):
      ARM: debug: enable UART1 for socfpga Cyclone5

Colin Ian King (1):
      altera-stapl: check for a null key before strcasecmp'ing it

Dan Carpenter (1):
      drm/i810: Prevent underflow in ioctl

Daniel Mack (1):
      ARM: dts: pxa: clean up USB controller nodes

David Hildenbrand (1):
      virtio-balloon: fix managed page counts when migrating pages between =
zones

David Teigland (2):
      dlm: fix missing idr_destroy for recover_idr
      dlm: fix invalid cluster name warning

Denis Efremov (1):
      ar5523: check NULL before memcpy() in ar5523_cmd()

Dmitry Monakhov (2):
      quota: Check that quota is not dirty before release
      quota: fix livelock in dquot_writeback_dquots

Dmitry Osipenko (1):
      ARM: tegra: Fix FLOW_CTLR_HALT register clobbering by tegra_resume()

Dmitry Safonov (1):
      tty: Don't block on IO when ldisc change is pending

Dmitry Torokhov (1):
      tty: vt: keyboard: reject invalid keycodes

Douglas Anderson (1):
      serial: core: Allow processing sysrq at port unlock time

Emiliano Ingrassia (1):
      usb: core: urb: fix URB structure initialization function

Eran Ben Elisha (1):
      net/mlx5e: Fix SFF 8472 eeprom length

Erez Alfasi (1):
      net/mlx4_core: Fix return codes of unsupported operations

Eric Dumazet (2):
      tcp: md5: fix potential overestimation of TCP option space
      inet: protect against too small mtu values.

Filipe Manana (2):
      Btrfs: send, skip backreference walking for extents with many referen=
ces
      Btrfs: fix negative subv_writers counter and data space leak after bu=
ffered write

Finley Xiao (1):
      clk: rockchip: fix rk3188 sclk_smc gate data

Francesco Ruggeri (1):
      ACPI: OSL: only free map once in osl.c

Greg Kroah-Hartman (3):
      lib: raid6: fix awk build warnings
      Revert "regulator: Defer init completion for a while after late_initc=
all"
      Linux 4.9.207

Gregory CLEMENT (1):
      spi: atmel: Fix CS high support

Grygorii Strashko (1):
      net: ethernet: ti: cpsw: fix extra rx interrupt

Guillaume Nault (3):
      tcp: fix rejected syncookies due to stale timestamps
      tcp: tighten acceptance of ACKs not matching a child socket
      tcp: Protect accesses to .ts_recent_stamp with {READ,WRITE}_ONCE()

H. Nikolaus Schaller (3):
      ARM: dts: pandora-common: define wl1251 as child node of mmc3
      mmc: host: omap_hsmmc: add code for special init of wl1251 to get rid=
 of pandora_wl1251_init_card
      omap: pdata-quirks: remove openpandora quirks for mmc3 and wl1251

Hans Verkuil (1):
      media: pulse8-cec: return 0 when invalidating the logical address

Hans de Goede (1):
      Input: goodix - add upside-down quirk for Teclast X89 tablet

Heiko Stuebner (1):
      clk: rockchip: fix rk3188 sclk_mac_lbtest parameter ordering

Henry Lin (1):
      usb: xhci: only set D3hot for pci device

Himanshu Madhani (1):
      scsi: qla2xxx: Fix DMA unmap leak

Hou Tao (1):
      dm btree: increase rebalance threshold in __rebalance2()

Ivan Bornyakov (1):
      nvme: host: core: fix precedence of ternary operator

James Smart (1):
      scsi: lpfc: Cap NPIV vports to 256

Jan Kara (1):
      jbd2: Fix possible overflow in jbd2_log_space_left()

Jarkko Nikula (1):
      ARM: dts: omap3-tao3530: Fix incorrect MMC card detection GPIO polari=
ty

Jeff Mahoney (1):
      reiserfs: fix extended attributes on the root directory

Jeffrey Hugo (1):
      tty: serial: msm_serial: Fix flow control

Jia-Ju Bai (1):
      dmaengine: coh901318: Fix a double-lock bug

Jian-Hong Pan (1):
      PCI/MSI: Fix incorrect MSI-X masking on resume

Jiang Yi (1):
      vfio/pci: call irq_bypass_unregister_producer() before freeing irq

Jiangfeng Xiao (1):
      serial: serial_core: Perform NULL checks for break_ctl ops

Joel Stanley (1):
      powerpc/math-emu: Update macros from GCC

Johan Hovold (11):
      staging: rtl8188eu: fix interface sanity check
      staging: rtl8712: fix interface sanity check
      staging: gigaset: fix general protection fault on probe
      staging: gigaset: fix illegal free on probe errors
      staging: gigaset: add endpoint-type sanity check
      USB: atm: ueagle-atm: add missing endpoint check
      USB: idmouse: fix interface sanity checks
      USB: serial: io_edgeport: fix epic endpoint lookup
      USB: adutux: fix interface sanity check
      media: bdisp: fix memleak on release
      media: radio: wl1273: fix interrupt masking on release

John Keeping (1):
      ARM: dts: rockchip: Fix rk3288-rock2 vcc_flash name

Jon Hunter (1):
      arm64: tegra: Fix 'active-low' warning for Jetson TX1 regulator

Josef Bacik (2):
      btrfs: check page->mapping when loading free space cache
      btrfs: record all roots for rename exchange on a subvol

Jouni Hogander (1):
      can: slcan: Fix use-after-free Read in slcan_open

Kai-Heng Feng (3):
      x86/PCI: Avoid AMD FCH XHCI USB PME# from D0 defect
      usb: Allow USB device to be warm reset in suspended state
      xhci: Increase STS_HALT timeout in xhci_suspend()

Konstantin Khorenko (1):
      kernel/module.c: wakeup processes in module_wq on module unload

Krzysztof Kozlowski (3):
      pinctrl: samsung: Fix device node refcount leaks in S3C24xx wakeup co=
ntroller init
      pinctrl: samsung: Fix device node refcount leaks in init code
      pinctrl: samsung: Fix device node refcount leaks in S3C64xx wakeup co=
ntroller init

Larry Finger (3):
      rtlwifi: rtl8192de: Fix missing code to retrieve RX buffer address
      rtlwifi: rtl8192de: Fix missing callback that tests for hw release of=
 buffer
      rtlwifi: rtl8192de: Fix missing enable interrupt flag

Leonard Crestez (1):
      PM / devfreq: Lock devfreq in trans_stat_show

Lihua Yao (1):
      ARM: dts: s3c64xx: Fix init order of clock providers

Lubomir Rintel (1):
      ARM: dts: mmp2: fix the gpio interrupt cell number

Lucas Stach (1):
      i2c: imx: don't print error message on probe defer

Maciej W. Rozycki (1):
      MIPS: SiByte: Enable ZONE_DMA32 for LittleSur

Marek Szyprowski (2):
      extcon: max8997: Fix lack of path setting in USB device mode
      ARM: dts: exynos: Use Samsung SoC specific compatible for DWC2 module

Mark Brown (1):
      regulator: Fix return value of _set_load() stub

Mark Salter (1):
      crypto: ccp - fix uninitialized list head

Martin Schiller (2):
      net/x25: fix called/calling length calculation in x25_parse_address_b=
lock
      net/x25: fix null_x25_address handling

Masahiro Yamada (1):
      kbuild: fix single target build for external module

Mathias Nyman (2):
      xhci: make sure interrupts are restored to correct state
      xhci: fix USB3 device initiated resume race with roothub autosuspend

Max Filippov (1):
      xtensa: fix TLB sanity checker

Miaoqing Pan (1):
      ath10k: fix fw crash by moving chip reset after napi disabled

Micha=C5=82 Miros=C5=82aw (1):
      usb: gadget: u_serial: add missing port entry locking

Mika Westerberg (1):
      xhci: Fix memory leak in xhci_add_in_port()

Mike Leach (1):
      coresight: etm4x: Fix input validation for sysfs.

Miklos Szeredi (2):
      fuse: verify nlink
      fuse: verify attributes

Ming Lei (2):
      blk-mq: avoid sysfs buffer overflow with too many CPU cores
      blk-mq: make sure that line break can be printed

Miquel Raynal (2):
      mtd: fix mtd_oobavail() incoherent returned value
      mtd: spear_smi: Fix Write Burst mode

Moni Shoua (1):
      net/mlx5: Release resource on error flow

Navid Emamdoost (2):
      crypto: user - fix memory leak in crypto_report
      dma-buf: Fix memory leak in sync_file_merge()

Niklas S=C3=B6derlund (1):
      dma-mapping: fix return type of dma_set_max_seg_size()

Nikolay Aleksandrov (1):
      net: bridge: deny dev_set_mac_address() when unregistering

Nuno S=C3=A1 (1):
      iio: adis16480: Add debugfs_reg_access entry

Oliver Neukum (2):
      USB: uas: honor flag to avoid CAPACITY16
      USB: uas: heed CAPACITY_HEURISTICS

Pan Bian (1):
      Input: cyttsp4_core - fix use after free bug

Paolo Bonzini (3):
      KVM: x86: do not modify masked bits of shared MSRs
      KVM: x86: fix presentation of TSX feature in ARCH_CAPABILITIES
      KVM: x86: fix out-of-bounds write in KVM_GET_EMULATED_CPUID (CVE-2019=
-19332)

Paul Walmsley (1):
      modpost: skip ELF local symbols during section mismatch check

Pavel Shilovsky (3):
      CIFS: Fix NULL-pointer dereference in smb2_push_mandatory_locks
      CIFS: Fix SMB2 oplock break processing
      CIFS: Respect O_SYNC and O_DIRECT flags during reconnect

Pavel Tikhomirov (1):
      sunrpc: fix crash when cache_head become valid before update

Pawel Harlozinski (1):
      ASoC: Jack: Fix NULL pointer dereference in snd_soc_jack_report

Peng Fan (1):
      tty: serial: fsl_lpuart: use the sg count from dma_map_sg

Pete Zaitcev (1):
      usb: mon: Fix a deadlock in usbmon between mmap and read

Qian Cai (1):
      mlx4: Use snprintf instead of complicated strcpy

Qu Wenruo (1):
      btrfs: Remove btrfs_bio::flags member

Rafael J. Wysocki (1):
      ACPI: PM: Avoid attaching ACPI PM domain to certain devices

Rob Herring (3):
      ARM: dts: realview-pbx: Fix duplicate regulator nodes
      ARM: dts: realview: Fix some more duplicate regulator nodes
      ARM: dts: sunxi: Fix PMU compatible strings

Scott Mayhew (1):
      nfsd: fix a warning in __cld_pipe_upcall()

Shirish S (2):
      x86/MCE/AMD: Turn off MC4_MISC thresholding on all family 0x15 models
      x86/MCE/AMD: Carve out the MC4_MISC thresholding quirk

Shreeya Patel (1):
      Staging: iio: adt7316: Fix i2c data reading, set the data field

Sirong Wang (1):
      RDMA/hns: Correct the value of HNS_ROCE_HEM_CHUNK_LEN

Stefan Agner (1):
      serial: imx: fix error handling in console_setup

Steffen Liebergeld (1):
      PCI: Fix Intel ACS quirk UPDCR register address

Steffen Maier (2):
      scsi: zfcp: drop default switch case which might paper over missing c=
ase
      scsi: zfcp: trace channel log even for FCP command responses

Stephan Gerhold (1):
      NFC: nxp-nci: Fix NULL pointer dereference after I2C communication er=
ror

Taehee Yoo (1):
      tipc: fix ordering of tipc module init and exit routine

Takashi Iwai (2):
      ALSA: pcm: oss: Avoid potential buffer overflows
      ALSA: hda - Fix pending unsol events at shutdown

Tejun Heo (3):
      workqueue: Fix spurious sanity check failures in destroy_workqueue()
      workqueue: Fix pwq ref leak in rescuer_thread()
      workqueue: Fix missing kfree(rescuer) in destroy_workqueue()

Vamshi K Sthambamkadi (1):
      ACPI: bus: Fix NULL pointer check in acpi_bus_get_private_data()

Ville Syrj=C3=A4l=C3=A4 (1):
      video/hdmi: Fix AVI bar unpack

Vincent Chen (1):
      math-emu/soft-fp.h: (_FP_ROUND_ZERO) cast 0 to void to fix warning

Vincent Whitchurch (2):
      serial: pl011: Fix DMA ->flush_buffer()
      ARM: 8813/1: Make aligned 2-byte getuser()/putuser() atomic on ARMv6+

Vincenzo Frascino (1):
      powerpc: Fix vDSO clock_getres()

Vinod Koul (1):
      dmaengine: coh901318: Remove unused variable

Viresh Kumar (1):
      RDMA/qib: Validate ->show()/store() callbacks before calling them

Wei Wang (1):
      thermal: Fix deadlock in thermal thermal_zone_device_check

Wei Yongjun (1):
      usb: gadget: configfs: Fix missing spin_lock_init()

Wen Yang (1):
      dlm: NULL check before kmem_cache_destroy is not needed

Will Deacon (1):
      firmware: qcom: scm: Ensure 'a0' status code is treated as signed

Xuewei Zhang (1):
      sched/fair: Scale bandwidth quota and period without losing quota/per=
iod ratio precision

Yuchung Cheng (2):
      tcp: fix off-by-one bug on aborting window-probing socket
      tcp: fix SNMP TCP timeout under-estimation

YueHaibing (3):
      appletalk: Fix potential NULL pointer dereference in unregister_snap_=
client
      appletalk: Set error code if register_snap_client failed
      e100: Fix passing zero to 'PTR_ERR' warning in e100_load_ucode_wait

Zhenzhong Duan (1):
      cpuidle: Do not unset the driver if it is there already

paulhsia (1):
      ALSA: pcm: Fix stream lock usage in snd_pcm_period_elapsed()

yangerkun (1):
      ext4: fix a bug in ext4_wait_for_tail_page_commit

zhengbin (1):
      nfsd: Return EPERM, not EACCES, in some SETATTR cases


--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl399pwACgkQONu9yGCS
aT6IehAAyPPRM+vEg680K1rLM7TocMVBQ9l7Q9nUglyL2X5QGgjbI4BUumgv1mhI
+cm4fQlV/wYc+K5x0mcNoImG1cy04v+YmUWdZ8CWI0K5+cu7K8SbVGbEfyymTZcz
IE9M2c5wV/EvbFjAJ3ss6Ul9q2rbUK1ymowQ+aKCwVYw0OCxFvFaD87uWu6OrPr6
mX8Hywn4PO+DSzIOWbJTt3MeCHQoo+1pASeXWHVwoONR7wguxB/LsmklPUUb0h+m
45usj7fbzhoXT69noddOi7GBWT1cYCE4QRKXTlyT1yUqOky1noF0wj7LTQ+oI7ty
8qacDA8aDFy7y3QeFra3bD4SfWDbP2Uc/GFeYUN/wn5RXcRBDOYDidsYle2wZWRt
68uLi+ERB1lSkH2M7Y4AuRMc5b+CQ5VaXOk+ejzwJ4mdQqTA92RGg5LDYMjGXoBo
VGdrapEpUN7k9HHbVfIoStzfQYjgtPssLaJl/AuP+A+45LJNhQaku84blv9GHfBY
le/QSqjoY7D7t5aO7qYzcf+cK8Sy1/Tnr4Oe0MG+oaHs7M+XrqIDObGnw5R/sfrD
A8/RSddVxhJXmWSm75EOQLMEpOlzV0kNC+XuPQZjJcXGH/G8+pQyfS28z0z6s4fZ
fkQMhwsqlEnUGWyrPPh5t+LSXMVPEWl88JFQZKsSymerpczXpvg=
=vXMk
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
