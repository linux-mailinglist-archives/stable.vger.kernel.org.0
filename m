Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63309159AD2
	for <lists+stable@lfdr.de>; Tue, 11 Feb 2020 21:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731925AbgBKU5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Feb 2020 15:57:17 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56736 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728078AbgBKU5P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Feb 2020 15:57:15 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j1cal-0000VA-Ma; Tue, 11 Feb 2020 20:57:11 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j1cak-000IJi-UN; Tue, 11 Feb 2020 20:57:11 +0000
Date:   Tue, 11 Feb 2020 20:57:10 +0000
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc:     lwn@lwn.net
Subject: Linux 3.16.82
Message-ID: <lsq.1581454595.190800754@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="oLBj+sq0vYjzfsbl"
Content-Disposition: inline
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--oLBj+sq0vYjzfsbl
Content-Type: multipart/mixed; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.16.82 kernel.

All users of the 3.16 kernel series should upgrade.

The updated 3.16.y git tree can be found at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
=2Egit linux-3.16.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

The diff from 3.16.81 is attached to this message.

Ben.

------------

 Documentation/hw-vuln/mds.rst                      |   7 +-
 Documentation/hw-vuln/tsx_async_abort.rst          |   5 +-
 Documentation/kernel-parameters.txt                |  30 +-
 Makefile                                           |   2 +-
 arch/arm/boot/dts/s3c6410-mini6410.dts             |   4 +
 arch/arm/boot/dts/s3c6410-smdk6410.dts             |   4 +
 arch/arm/mach-tegra/reset-handler.S                |   6 +-
 arch/arm/mach-ux500/board-mop500-regulators.c      | 600 -----------------=
----
 arch/arm/mach-ux500/board-mop500-regulators.h      |   8 -
 arch/powerpc/include/asm/vdso_datapage.h           |   2 +
 arch/powerpc/kernel/asm-offsets.c                  |   2 +-
 arch/powerpc/kernel/misc_64.S                      |   4 +-
 arch/powerpc/kernel/time.c                         |   1 +
 arch/powerpc/kernel/vdso32/gettimeofday.S          |   7 +-
 arch/powerpc/kernel/vdso64/cacheflush.S            |   4 +-
 arch/powerpc/kernel/vdso64/gettimeofday.S          |   7 +-
 arch/s390/kernel/runtime_instr.c                   |   2 +-
 arch/x86/kernel/apic/io_apic.c                     |   9 +-
 arch/x86/kernel/cpu/bugs.c                         |  17 +-
 arch/x86/kernel/module.c                           |   1 +
 arch/x86/kvm/x86.c                                 |  14 +-
 arch/x86/pci/fixup.c                               |  11 +
 arch/x86/tools/relocs.c                            |   1 +
 arch/xtensa/mm/tlb.c                               |   4 +-
 block/blk-mq-sysfs.c                               |  19 +-
 block/blk-mq.c                                     |   7 +
 drivers/acpi/bus.c                                 |   2 +-
 drivers/acpi/osl.c                                 |  28 +-
 drivers/block/xen-blkback/blkback.c                |   2 +
 drivers/char/hw_random/omap3-rom-rng.c             |   3 +-
 drivers/clk/samsung/clk-exynos5420.c               |   2 +
 drivers/cpuidle/driver.c                           |  15 +-
 drivers/devfreq/devfreq.c                          |   7 +-
 drivers/gpu/drm/i810/i810_dma.c                    |   4 +-
 drivers/gpu/drm/i915/i915_gem_userptr.c            |  22 +-
 drivers/gpu/drm/radeon/cik.c                       |   4 +-
 drivers/gpu/drm/radeon/r100.c                      |   4 +-
 drivers/gpu/drm/radeon/r200.c                      |   4 +-
 drivers/gpu/drm/radeon/r600.c                      |   4 +-
 drivers/gpu/drm/radeon/si.c                        |   4 +-
 drivers/iio/imu/adis16480.c                        |   7 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |  24 +
 drivers/media/i2c/soc_camera/ov6650.c              |  21 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |   2 +-
 drivers/media/radio/radio-wl1273.c                 |   3 +-
 drivers/media/usb/usbvision/usbvision-core.c       |  50 --
 drivers/media/usb/usbvision/usbvision-video.c      | 107 ++--
 drivers/media/usb/usbvision/usbvision.h            |   5 -
 drivers/mmc/host/sdhci-s3c.c                       |  16 +-
 drivers/mtd/devices/spear_smi.c                    |  38 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |   3 +-
 drivers/net/ethernet/stmicro/stmmac/common.h       |   2 +-
 drivers/net/ethernet/stmicro/stmmac/descs_com.h    |  14 +-
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c     |  10 +-
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c    |  10 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  20 +-
 drivers/net/ethernet/ti/davinci_cpdma.c            |  12 +-
 drivers/net/macvlan.c                              |   3 +-
 drivers/net/wireless/ath/ar5523/ar5523.c           |   3 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |   2 +-
 drivers/net/wireless/cw1200/fwio.c                 |   6 +-
 drivers/net/wireless/iwlwifi/dvm/led.c             |   3 +
 drivers/net/wireless/iwlwifi/mvm/led.c             |   3 +
 drivers/pci/msi.c                                  |   3 +-
 drivers/pci/quirks.c                               |   2 +-
 drivers/pinctrl/pinctrl-s3c24xx.c                  |   6 +-
 drivers/pinctrl/pinctrl-s3c64xx.c                  |   3 +
 drivers/platform/x86/hp-wmi.c                      |  10 +-
 drivers/regulator/ab8500.c                         |  17 -
 drivers/rtc/rtc-msm6242.c                          |   3 +-
 drivers/s390/scsi/zfcp_dbf.c                       |   8 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c                   |   2 +-
 drivers/scsi/csiostor/csio_lnode.c                 |  15 +-
 drivers/scsi/esas2r/esas2r_flash.c                 |   1 +
 drivers/scsi/lpfc/lpfc_els.c                       |   2 +-
 drivers/scsi/qla4xxx/ql4_mbx.c                     |   3 -
 drivers/scsi/scsi_trace.c                          | 125 ++---
 drivers/spi/spi-atmel.c                            |  10 +-
 drivers/staging/android/binder.c                   |   6 +-
 drivers/staging/line6/pcm.c                        |  61 +--
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c       |   5 +-
 drivers/tty/serial/ifx6x60.c                       |   3 +
 drivers/tty/serial/imx.c                           |   2 +-
 drivers/tty/serial/msm_serial.c                    |   6 +-
 drivers/tty/serial/pch_uart.c                      |   5 +-
 drivers/tty/serial/serial_core.c                   |   2 +-
 drivers/tty/vt/keyboard.c                          |   2 +-
 drivers/usb/core/hub.c                             |   5 +-
 drivers/usb/gadget/pch_udc.c                       |   1 -
 drivers/usb/gadget/u_serial.c                      |   2 +
 drivers/usb/misc/appledisplay.c                    |   8 +-
 drivers/usb/serial/cp210x.c                        |   1 +
 drivers/usb/serial/ftdi_sio.c                      |   3 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   7 +
 drivers/usb/serial/mos7720.c                       |   4 -
 drivers/usb/serial/mos7840.c                       |  16 +-
 drivers/usb/storage/uas.c                          |  10 +
 fs/btrfs/file.c                                    |   2 +-
 fs/btrfs/free-space-cache.c                        |   6 +
 fs/cifs/cifsglob.h                                 |   5 +
 fs/cifs/cifsproto.h                                |   1 +
 fs/cifs/file.c                                     |  35 +-
 fs/cifs/smb2file.c                                 |   2 +-
 fs/cifs/smb2misc.c                                 |   7 +-
 fs/ext2/inode.c                                    |   7 +-
 fs/ext4/namei.c                                    |  13 +-
 fs/fuse/dir.c                                      |  27 +-
 fs/fuse/fuse_i.h                                   |   2 +
 fs/ocfs2/quota_global.c                            |   2 +-
 fs/pstore/ram.c                                    |  11 +
 fs/quota/dquot.c                                   |  11 +-
 fs/xfs/xfs_quotaops.c                              |   3 +
 include/linux/futex.h                              |   7 +-
 include/linux/hrtimer.h                            |   6 +-
 include/linux/jbd2.h                               |   4 +-
 include/linux/netdevice.h                          |   5 +
 include/linux/quotaops.h                           |  10 +
 include/linux/regulator/ab8500.h                   |   3 -
 include/linux/time.h                               |  12 +
 include/net/ip.h                                   |   5 +
 include/net/tcp.h                                  |  38 +-
 kernel/futex.c                                     |  49 +-
 kernel/futex_compat.c                              |   5 +-
 kernel/hrtimer.c                                   |  26 +-
 kernel/time/timer_list.c                           |   8 +-
 kernel/workqueue.c                                 |  28 +-
 net/bluetooth/hci_core.c                           |  11 +-
 net/bluetooth/l2cap_core.c                         |   4 +-
 net/bridge/br_device.c                             |   6 +
 net/core/dev.c                                     |   3 +-
 net/ipv4/devinet.c                                 |   5 -
 net/ipv4/inetpeer.c                                |  12 +-
 net/ipv4/ip_output.c                               |  14 +-
 net/ipv4/tcp_output.c                              |   5 +-
 net/openvswitch/datapath.c                         |  11 +-
 net/socket.c                                       |   1 +
 net/sunrpc/cache.c                                 |   5 -
 scripts/package/builddeb                           |   2 +-
 sound/core/oss/linear.c                            |   2 +
 sound/core/oss/mulaw.c                             |   2 +
 sound/core/oss/route.c                             |   2 +
 sound/isa/cs423x/cs4236.c                          |   3 +-
 sound/soc/soc-jack.c                               |   3 +-
 tools/lib/traceevent/parse-filter.c                |   9 +-
 tools/perf/util/dwarf-aux.c                        |  88 ++-
 tools/perf/util/dwarf-aux.h                        |   6 +
 tools/perf/util/perf_regs.h                        |   2 +-
 tools/perf/util/probe-finder.c                     |  70 ++-
 .../cpupower/utils/idle_monitor/hsw_ext_idle.c     |   1 -
 149 files changed, 987 insertions(+), 1226 deletions(-)

Aaro Koskinen (2):
      net: stmmac: use correct DMA buffer size in the RX descriptor
      net: stmmac: don't stop NAPI processing when dropping a packet

Akinobu Mita (1):
      blk-mq: fix deadlock when reading cpu_list

Alan Stern (2):
      media: usbvision: Fix invalid accesses after device disconnect
      media: usbvision: Fix races among open, close, and disconnect

Alastair D'Silva (2):
      powerpc: Allow flush_icache_range to work across ranges >4GB
      powerpc: Allow 64bit VDSO __kernel_sync_dicache to work across ranges=
 >4GB

Aleksandr Yashkin (1):
      pstore/ram: Write new dumps to start of recycled zones

Alex Deucher (1):
      drm/radeon: fix r1xx/r2xx register checker for POT textures

Alexandru Ardelean (1):
      iio: imu: adis16480: assign bias value only if operation succeeded

Arnaldo Carvalho de Melo (1):
      perf regs: Make perf_reg_name() return "unknown" instead of NULL

Arnd Bergmann (3):
      net: davinci_cpdma: use dma_addr_t for DMA address
      compat_ioctl: handle SIOCOUTQNSD
      ARM: ux500: remove unused regulator data

Asbjoern Sloth Toennesen (1):
      deb-pkg: remove obsolete -isp option to dpkg-gencontrol

Bart Van Assche (3):
      scsi: core: scsi_trace: Use get_unaligned_be*()
      scsi: tracing: Fix handling of TRANSFER LENGTH =3D=3D 0 for READ(6) a=
nd WRITE(6)
      RDMA/srpt: Report the SCSI residual to the initiator

Ben Hutchings (2):
      s390: Fix unmatched preempt_disable() on exit
      Linux 3.16.82

Chengguang Xu (1):
      ext2: check err when partial !=3D NULL

Chris Wilson (1):
      drm/i915/userptr: Try to acquire the page lock around set_page_dirty()

Chuhong Yuan (1):
      serial: ifx6x60: add missed pm_runtime_disable

Colin Ian King (1):
      ALSA: cs4236: fix error return comparison of an unsigned integer

Dan Carpenter (6):
      cw1200: Fix a signedness bug in cw1200_load_firmware()
      drm/i810: Prevent underflow in ioctl
      usbvision-video: two use after frees
      scsi: csiostor: Don't enable IRQs too early
      scsi: esas2r: unlock on error in esas2r_nvram_read_direct()
      Bluetooth: delete a stray unlock

Dave Wysochanski (1):
      cifs: Fix cifsInodeInfo lock_sem deadlock when reconnect occurs

Denis Efremov (2):
      ath9k_hw: fix uninitialized variable data
      ar5523: check NULL before memcpy() in ar5523_cmd()

Dmitry Monakhov (2):
      quota: fix livelock in dquot_writeback_dquots
      quota: Check that quota is not dirty before release

Dmitry Osipenko (1):
      ARM: tegra: Fix FLOW_CTLR_HALT register clobbering by tegra_resume()

Dmitry Torokhov (1):
      tty: vt: keyboard: reject invalid keycodes

Eric Dumazet (4):
      inetpeer: fix data-race in inet_putpeer / inet_putpeer
      tcp: md5: fix potential overestimation of TCP option space
      tcp: syncookies: extend validity range
      inet: protect against too small mtu values.

Fabio D'Urso (1):
      USB: serial: ftdi_sio: add device IDs for U-Blox C099-F9P

Filipe Manana (1):
      Btrfs: fix negative subv_writers counter and data space leak after bu=
ffered write

Francesco Ruggeri (1):
      ACPI: OSL: only free map once in osl.c

Giuseppe CAVALLARO (1):
      stmmac: fix oversized frame reception

Greg Kroah-Hartman (1):
      usb-serial: cp201x: support Mark-10 digital force gauge

Guillaume Nault (2):
      tcp: fix rejected syncookies due to stale timestamps
      tcp: Protect accesses to .ts_recent_stamp with {READ,WRITE}_ONCE()

Gustavo A. R. Silva (1):
      usb: gadget: pch_udc: fix use after free

H.J. Lu (1):
      x86: Treat R_X86_64_PLT32 as R_X86_64_PC32

Hans Verkuil (2):
      usbvision: remove power_on_at_open and timed power off
      usbvision: fix locking error

Hans de Goede (2):
      platform/x86: hp-wmi: Fix ACPI errors caused by too small buffer
      platform/x86: hp-wmi: Fix ACPI errors caused by passing 0 as input si=
ze

Hewenliang (1):
      libtraceevent: Fix memory leakage in copy_filter_type

Insu Yun (1):
      usbvision: fix locking error

James Smart (1):
      scsi: lpfc: fix: Coverity: lpfc_cmpl_els_rsp(): Null pointer derefere=
nces

Jan Kara (2):
      xfs: Sanity check flags of Q_XQUOTARM call
      jbd2: Fix possible overflow in jbd2_log_space_left()

Jann Horn (1):
      binder: Handle start=3D=3DNULL in binder_update_page_range()

Janusz Krzysztofik (2):
      media: ov6650: Fix incorrect use of JPEG colorspace
      media: ov6650: Fix stored frame format not in sync with hardware

Jeffrey Hugo (1):
      tty: serial: msm_serial: Fix flow control

Jian-Hong Pan (1):
      PCI/MSI: Fix incorrect MSI-X masking on resume

Jiangfeng Xiao (1):
      serial: serial_core: Perform NULL checks for break_ctl ops

Johan Hovold (3):
      media: radio: wl1273: fix interrupt masking on release
      USB: serial: mos7720: fix remote wakeup
      USB: serial: mos7840: fix remote wakeup

Johannes Berg (1):
      iwlwifi: check kasprintf() return value

Josef Bacik (1):
      btrfs: check page->mapping when loading free space cache

Kai-Heng Feng (2):
      usb: Allow USB device to be warm reset in suspended state
      x86/PCI: Avoid AMD FCH XHCI USB PME# from D0 defect

Kars de Jong (1):
      rtc: msm6242: Fix reading of 10-hour digit

Konstantin Khlebnikov (1):
      ACPI / osl: speedup grace period in acpi_os_map_cleanup

Krzysztof Kozlowski (2):
      pinctrl: samsung: Fix device node refcount leaks in S3C24xx wakeup co=
ntroller init
      pinctrl: samsung: Fix device node refcount leaks in S3C64xx wakeup co=
ntroller init

Leonard Crestez (1):
      PM / devfreq: Lock devfreq in trans_stat_show

Lihua Yao (1):
      ARM: dts: s3c64xx: Fix init order of clock providers

Mans Rullgard (1):
      spi: atmel: fix handling of cs_change set on non-last xfer

Marian Mihailescu (1):
      clk: samsung: exynos5420: Preserve CPU clocks configuration during su=
spend/resume

Mark Brown (1):
      mmc: sdhci-s3c: Check if clk_set_rate() succeeds

Masami Hiramatsu (15):
      perf probe: Fix to handle optimized not-inlined functions
      perf probe: Fix to show lines of sys_ functions correctly
      perf probe: Fix to add missed brace around if block
      perf probe: Skip if the function address is 0
      perf probe: Fix to find range-only function instance
      perf probe: Fix to show function entry line as probe-able
      perf probe: Fix wrong address verification
      perf probe: Fix to probe a function which has no entry pc
      perf probe: Fix to probe an inline function which has no entry pc
      perf probe: Fix to list probe event with correct line number
      perf probe: Fix to show inlined function callsite without entry_pc
      perf probe: Skip end-of-sequence and non statement lines
      perf probe: Filter out instances except for inlined subroutine and su=
bprogram
      perf probe: Fix to show calling lines of inlined functions
      perf probe: Skip overlapped location on searching variables

Mattijs Korpershoek (1):
      Bluetooth: hci_core: fix init for HCI_USER_CHANNEL

Max Filippov (1):
      xtensa: fix TLB sanity checker

Menglong Dong (1):
      macvlan: schedule bc_work even if error

Micha=C5=82 Miros=C5=82aw (1):
      usb: gadget: u_serial: add missing port entry locking

Miklos Szeredi (2):
      fuse: verify attributes
      fuse: verify nlink

Ming Lei (2):
      blk-mq: avoid sysfs buffer overflow with too many CPU cores
      blk-mq: make sure that line break can be printed

Miquel Raynal (1):
      mtd: spear_smi: Fix Write Burst mode

Nathan Chancellor (1):
      tools/power/cpupower: Fix initializer override in hsw_ext_cstates

Nikolay Aleksandrov (1):
      net: bridge: deny dev_set_mac_address() when unregistering

Nuno S=C3=A1 (1):
      iio: adis16480: Add debugfs_reg_access entry

Oliver Neukum (4):
      appledisplay: fix error handling in the scheduled work
      USB: uas: honor flag to avoid CAPACITY16
      USB: uas: heed CAPACITY_HEURISTICS
      USB: documentation: flags on usb-storage versus UAS

Pan Bian (3):
      staging: rtl8192e: fix potential use after free
      scsi: qla4xxx: fix double free bug
      scsi: bnx2i: fix potential use after free

Paolo Abeni (2):
      openvswitch: drop unneeded BUG_ON() in ovs_flow_cmd_build_info()
      openvswitch: remove another BUG_ON()

Paolo Bonzini (2):
      KVM: x86: fix presentation of TSX feature in ARCH_CAPABILITIES
      KVM: x86: do not modify masked bits of shared MSRs

Paul Osmialowski (1):
      mmc: sdhci-s3c: solve problem with sleeping in atomic context

Pavel L=C3=B6bl (1):
      USB: serial: mos7840: add USB ID to support Moxa UPort 2210

Pavel Shilovsky (3):
      CIFS: Respect O_SYNC and O_DIRECT flags during reconnect
      CIFS: Fix SMB2 oplock break processing
      CIFS: Fix NULL-pointer dereference in smb2_push_mandatory_locks

Pavel Tikhomirov (1):
      sunrpc: fix crash when cache_head become valid before update

Pawel Harlozinski (1):
      ASoC: Jack: Fix NULL pointer dereference in snd_soc_jack_report

Peng Fan (2):
      tty: serial: imx: use the sg count from dma_map_sg
      tty: serial: pch_uart: correct usage of dma_unmap_sg

Sam Bobroff (1):
      drm/radeon: fix bad DMA from INTERRUPT_CNTL2

SeongJae Park (1):
      xen/blkback: Avoid unmapping unmapped grant pages

Seung-Woo Kim (1):
      media: exynos4-is: Fix recursive locking in isp_video_release()

Steffen Liebergeld (1):
      PCI: Fix Intel ACS quirk UPDCR register address

Steffen Maier (1):
      scsi: zfcp: trace channel log even for FCP command responses

Stephan Gerhold (2):
      regulator: ab8500: Remove AB8505 USB regulator
      regulator: ab8500: Remove SYSCLKREQ from enum ab8505_regulator_id

Sudarsana Reddy Kalluru (1):
      bnx2x: Enable Multi-Cos feature.

Takashi Iwai (3):
      ALSA: line6: Drop superfluous snd_device for PCM
      ALSA: line6: Fix memory leak at line6_init_pcm() error path
      ALSA: pcm: oss: Avoid potential buffer overflows

Tejun Heo (1):
      workqueue: Fix spurious sanity check failures in destroy_workqueue()

Theodore Ts'o (1):
      ext4: work around deleting a file with i_nlink =3D=3D 0 safely

Thomas Gleixner (2):
      x86/ioapic: Prevent inconsistent state when moving an interrupt
      hrtimer: Get rid of the resolution field in hrtimer_clock_base

Tony Lindgren (1):
      hwrng: omap3-rom - Call clk_disable_unprepare() on exit only if not i=
dled

Vamshi K Sthambamkadi (1):
      ACPI: bus: Fix NULL pointer check in acpi_bus_get_private_data()

Vincenzo Frascino (1):
      powerpc: Fix vDSO clock_getres()

Waiman Long (1):
      x86/speculation: Fix incorrect MDS/TAA mitigation status

Yang Tao (1):
      futex: Prevent robust futex exit race

Zhenzhong Duan (1):
      cpuidle: Do not unset the driver if it is there already


--yrj/dFKFPuw6o+aM
Content-Type: text/x-diff; charset=UTF-8; name="linux-3.16.82.patch"
Content-Disposition: attachment; filename="linux-3.16.82.patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/Documentation/hw-vuln/mds.rst b/Documentation/hw-vuln/mds.rst
index 3f92728be021..7b8a1e9c5240 100644
--- a/Documentation/hw-vuln/mds.rst
+++ b/Documentation/hw-vuln/mds.rst
@@ -262,8 +262,11 @@ The kernel command line allows to control the MDS miti=
gations at boot
=20
   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
-Not specifying this option is equivalent to "mds=3Dfull".
-
+Not specifying this option is equivalent to "mds=3Dfull". For processors
+that are affected by both TAA (TSX Asynchronous Abort) and MDS,
+specifying just "mds=3Doff" without an accompanying "tsx_async_abort=3Doff"
+will have no effect as the same mitigation is used for both
+vulnerabilities.
=20
 Mitigation selection guide
 --------------------------
diff --git a/Documentation/hw-vuln/tsx_async_abort.rst b/Documentation/hw-v=
uln/tsx_async_abort.rst
index 38beda735f39..0adfe63612ce 100644
--- a/Documentation/hw-vuln/tsx_async_abort.rst
+++ b/Documentation/hw-vuln/tsx_async_abort.rst
@@ -169,7 +169,10 @@ The kernel command line allows to control the TAA miti=
gations at boot time with
                 systems will have no effect.
   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
-Not specifying this option is equivalent to "tsx_async_abort=3Dfull".
+Not specifying this option is equivalent to "tsx_async_abort=3Dfull". For
+processors that are affected by both TAA and MDS, specifying just
+"tsx_async_abort=3Doff" without an accompanying "mds=3Doff" will have no
+effect as the same mitigation is used for both vulnerabilities.
=20
 The kernel command line also allows to control the TSX feature using the
 parameter "tsx=3D" on CPUs which support TSX control. MSR_IA32_TSX_CTRL is=
 used
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-par=
ameters.txt
index 1c936be7e7f8..01eb7cab0419 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1793,6 +1793,12 @@ bytes respectively. Such letter suffixes can also be=
 entirely omitted.
 			full    - Enable MDS mitigation on vulnerable CPUs
 			off     - Unconditionally disable MDS mitigation
=20
+			On TAA-affected machines, mds=3Doff can be prevented by
+			an active TAA mitigation as both vulnerabilities are
+			mitigated with the same mechanism so in order to disable
+			this mitigation, you need to specify tsx_async_abort=3Doff
+			too.
+
 			Not specifying this option is equivalent to
 			mds=3Dfull.
=20
@@ -3634,6 +3640,11 @@ bytes respectively. Such letter suffixes can also be=
 entirely omitted.
=20
 			off        - Unconditionally disable TAA mitigation
=20
+			On MDS-affected machines, tsx_async_abort=3Doff can be
+			prevented by an active MDS mitigation as both vulnerabilities
+			are mitigated with the same mechanism so in order to disable
+			this mitigation, you need to specify mds=3Doff too.
+
 			Not specifying this option is equivalent to
 			tsx_async_abort=3Dfull.  On CPUs which are MDS affected
 			and deploy MDS mitigation, TAA mitigation is not
@@ -3719,13 +3730,13 @@ bytes respectively. Such letter suffixes can also b=
e entirely omitted.
 			Flags is a set of characters, each corresponding
 			to a common usb-storage quirk flag as follows:
 				a =3D SANE_SENSE (collect more than 18 bytes
-					of sense data);
+					of sense data, not on uas);
 				b =3D BAD_SENSE (don't collect more than 18
-					bytes of sense data);
+					bytes of sense data, not on uas);
 				c =3D FIX_CAPACITY (decrease the reported
 					device capacity by one sector);
 				d =3D NO_READ_DISC_INFO (don't use
-					READ_DISC_INFO command);
+					READ_DISC_INFO command, not on uas);
 				e =3D NO_READ_CAPACITY_16 (don't use
 					READ_CAPACITY_16 command);
 				f =3D NO_REPORT_OPCODES (don't use report opcodes
@@ -3740,17 +3751,18 @@ bytes respectively. Such letter suffixes can also b=
e entirely omitted.
 				j =3D NO_REPORT_LUNS (don't use report luns
 					command, uas only);
 				l =3D NOT_LOCKABLE (don't try to lock and
-					unlock ejectable media);
+					unlock ejectable media, not on uas);
 				m =3D MAX_SECTORS_64 (don't transfer more
-					than 64 sectors =3D 32 KB at a time);
+					than 64 sectors =3D 32 KB at a time,
+					not on uas);
 				n =3D INITIAL_READ10 (force a retry of the
-					initial READ(10) command);
+					initial READ(10) command, not on uas);
 				o =3D CAPACITY_OK (accept the capacity
-					reported by the device);
+					reported by the device, not on uas);
 				p =3D WRITE_CACHE (the device cache is ON
-					by default);
+					by default, not on uas);
 				r =3D IGNORE_RESIDUE (the device reports
-					bogus residue values);
+					bogus residue values, not on uas);
 				s =3D SINGLE_LUN (the device has only one
 					Logical Unit);
 				t =3D NO_ATA_1X (don't allow ATA(12) and ATA(16)
diff --git a/Makefile b/Makefile
index f749333fdeed..64e7647e6a9d 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 16
-SUBLEVEL =3D 81
+SUBLEVEL =3D 82
 EXTRAVERSION =3D
 NAME =3D Museum of Fishiegoodies
=20
diff --git a/arch/arm/boot/dts/s3c6410-mini6410.dts b/arch/arm/boot/dts/s3c=
6410-mini6410.dts
index a25debb50401..61716fa07dcc 100644
--- a/arch/arm/boot/dts/s3c6410-mini6410.dts
+++ b/arch/arm/boot/dts/s3c6410-mini6410.dts
@@ -167,6 +167,10 @@
 	};
 };
=20
+&clocks {
+	clocks =3D <&fin_pll>;
+};
+
 &sdhci0 {
 	pinctrl-names =3D "default";
 	pinctrl-0 =3D <&sd0_clk>, <&sd0_cmd>, <&sd0_cd>, <&sd0_bus4>;
diff --git a/arch/arm/boot/dts/s3c6410-smdk6410.dts b/arch/arm/boot/dts/s3c=
6410-smdk6410.dts
index ecf35ec466f7..7ade1a0686d2 100644
--- a/arch/arm/boot/dts/s3c6410-smdk6410.dts
+++ b/arch/arm/boot/dts/s3c6410-smdk6410.dts
@@ -71,6 +71,10 @@
 	};
 };
=20
+&clocks {
+	clocks =3D <&fin_pll>;
+};
+
 &sdhci0 {
 	pinctrl-names =3D "default";
 	pinctrl-0 =3D <&sd0_clk>, <&sd0_cmd>, <&sd0_cd>, <&sd0_bus4>;
diff --git a/arch/arm/mach-tegra/reset-handler.S b/arch/arm/mach-tegra/rese=
t-handler.S
index 6448324aa9b4..f22b131a7c74 100644
--- a/arch/arm/mach-tegra/reset-handler.S
+++ b/arch/arm/mach-tegra/reset-handler.S
@@ -55,16 +55,16 @@ ENTRY(tegra_resume)
 	cmp	r6, #TEGRA20
 	beq	1f				@ Yes
 	/* Clear the flow controller flags for this CPU. */
-	cpu_to_csr_reg r1, r0
+	cpu_to_csr_reg r3, r0
 	mov32	r2, TEGRA_FLOW_CTRL_BASE
-	ldr	r1, [r2, r1]
+	ldr	r1, [r2, r3]
 	/* Clear event & intr flag */
 	orr	r1, r1, \
 		#FLOW_CTRL_CSR_INTR_FLAG | FLOW_CTRL_CSR_EVENT_FLAG
 	movw	r0, #0x3FFD	@ enable, cluster_switch, immed, bitmaps
 				@ & ext flags for CPU power mgnt
 	bic	r1, r1, r0
-	str	r1, [r2]
+	str	r1, [r2, r3]
 1:
=20
 	mov32	r9, 0xc09
diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-=
ux500/board-mop500-regulators.c
index a4e139aa2441..eff141ddeea5 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -13,46 +13,6 @@
 #include <linux/regulator/machine.h>
 #include <linux/regulator/ab8500.h>
 #include "board-mop500-regulators.h"
-#include "id.h"
-
-static struct regulator_consumer_supply gpio_en_3v3_consumers[] =3D {
-       REGULATOR_SUPPLY("vdd33a", "smsc911x.0"),
-};
-
-struct regulator_init_data gpio_en_3v3_regulator =3D {
-       .constraints =3D {
-               .name =3D "EN-3V3",
-               .min_uV =3D 3300000,
-               .max_uV =3D 3300000,
-               .valid_ops_mask =3D REGULATOR_CHANGE_STATUS,
-       },
-       .num_consumer_supplies =3D ARRAY_SIZE(gpio_en_3v3_consumers),
-       .consumer_supplies =3D gpio_en_3v3_consumers,
-};
-
-/*
- * TPS61052 regulator
- */
-static struct regulator_consumer_supply tps61052_vaudio_consumers[] =3D {
-	/*
-	 * Boost converter supply to raise voltage on audio speaker, this
-	 * is actually connected to three pins, VInVhfL (left amplifier)
-	 * VInVhfR (right amplifier) and VIntDClassInt - all three must
-	 * be connected to the same voltage.
-	 */
-	REGULATOR_SUPPLY("vintdclassint", "ab8500-codec.0"),
-};
-
-struct regulator_init_data tps61052_regulator =3D {
-	.constraints =3D {
-		.name =3D "vaudio-hf",
-		.min_uV =3D 4500000,
-		.max_uV =3D 4500000,
-		.valid_ops_mask =3D REGULATOR_CHANGE_STATUS,
-	},
-	.num_consumer_supplies =3D ARRAY_SIZE(tps61052_vaudio_consumers),
-	.consumer_supplies =3D tps61052_vaudio_consumers,
-};
=20
 static struct regulator_consumer_supply ab8500_vaux1_consumers[] =3D {
 	/* Main display, u8500 R3 uib */
@@ -107,27 +67,6 @@ static struct regulator_consumer_supply ab8500_vaux3_co=
nsumers[] =3D {
 	REGULATOR_SUPPLY("vmmc", "sdi0"),
 };
=20
-static struct regulator_consumer_supply ab8505_vaux4_consumers[] =3D {
-};
-
-static struct regulator_consumer_supply ab8505_vaux5_consumers[] =3D {
-};
-
-static struct regulator_consumer_supply ab8505_vaux6_consumers[] =3D {
-};
-
-static struct regulator_consumer_supply ab8505_vaux8_consumers[] =3D {
-	/* AB8500 audio codec device */
-	REGULATOR_SUPPLY("v-aux8", NULL),
-};
-
-static struct regulator_consumer_supply ab8505_vadc_consumers[] =3D {
-	/* Internal general-purpose ADC */
-	REGULATOR_SUPPLY("vddadc", "ab8500-gpadc.0"),
-	/* ADC for charger */
-	REGULATOR_SUPPLY("vddadc", "ab8500-charger.0"),
-};
-
 static struct regulator_consumer_supply ab8500_vtvout_consumers[] =3D {
 	/* TV-out DENC supply */
 	REGULATOR_SUPPLY("vtvout", "ab8500-denc.0"),
@@ -168,11 +107,6 @@ static struct regulator_consumer_supply ab8500_vintcor=
e_consumers[] =3D {
 	REGULATOR_SUPPLY("v-intcore", "abx500-clk.0"),
 };
=20
-static struct regulator_consumer_supply ab8505_usb_consumers[] =3D {
-	/* HS USB OTG physical interface */
-	REGULATOR_SUPPLY("v-ape", NULL),
-};
-
 static struct regulator_consumer_supply ab8500_vana_consumers[] =3D {
 	/* DB8500 DSI */
 	REGULATOR_SUPPLY("vdddsi1v2", "mcde"),
@@ -483,11 +417,6 @@ static struct regulator_consumer_supply ab8500_ext_sup=
ply3_consumers[] =3D {
 	REGULATOR_SUPPLY("vinvsim", "sim-detect.0"),
 };
=20
-/* extended configuration for VextSupply2, only used for HREFP_V20 boards =
*/
-static struct ab8500_ext_regulator_cfg ab8500_ext_supply2 =3D {
-	.hwreq =3D true,
-};
-
 /*
  * AB8500 external regulators
  */
@@ -526,456 +455,6 @@ static struct regulator_init_data ab8500_ext_regulato=
rs[] =3D {
 	},
 };
=20
-/* ab8505 regulator register initialization */
-static struct ab8500_regulator_reg_init ab8505_reg_init[] =3D {
-	/*
-	 * VarmRequestCtrl
-	 * VsmpsCRequestCtrl
-	 * VsmpsARequestCtrl
-	 * VsmpsBRequestCtrl
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUREQUESTCTRL1,       0x00, 0x00),
-	/*
-	 * VsafeRequestCtrl
-	 * VpllRequestCtrl
-	 * VanaRequestCtrl          =3D HP/LP depending on VxRequest
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUREQUESTCTRL2,       0x30, 0x00),
-	/*
-	 * Vaux1RequestCtrl         =3D HP/LP depending on VxRequest
-	 * Vaux2RequestCtrl         =3D HP/LP depending on VxRequest
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUREQUESTCTRL3,       0xf0, 0x00),
-	/*
-	 * Vaux3RequestCtrl         =3D HP/LP depending on VxRequest
-	 * SwHPReq                  =3D Control through SWValid disabled
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUREQUESTCTRL4,       0x07, 0x00),
-	/*
-	 * VsmpsASysClkReq1HPValid
-	 * VsmpsBSysClkReq1HPValid
-	 * VsafeSysClkReq1HPValid
-	 * VanaSysClkReq1HPValid    =3D disabled
-	 * VpllSysClkReq1HPValid
-	 * Vaux1SysClkReq1HPValid   =3D disabled
-	 * Vaux2SysClkReq1HPValid   =3D disabled
-	 * Vaux3SysClkReq1HPValid   =3D disabled
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUSYSCLKREQ1HPVALID1, 0xe8, 0x00),
-	/*
-	 * VsmpsCSysClkReq1HPValid
-	 * VarmSysClkReq1HPValid
-	 * VbbSysClkReq1HPValid
-	 * VsmpsMSysClkReq1HPValid
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUSYSCLKREQ1HPVALID2, 0x00, 0x00),
-	/*
-	 * VsmpsAHwHPReq1Valid
-	 * VsmpsBHwHPReq1Valid
-	 * VsafeHwHPReq1Valid
-	 * VanaHwHPReq1Valid        =3D disabled
-	 * VpllHwHPReq1Valid
-	 * Vaux1HwHPreq1Valid       =3D disabled
-	 * Vaux2HwHPReq1Valid       =3D disabled
-	 * Vaux3HwHPReqValid        =3D disabled
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUHWHPREQ1VALID1,     0xe8, 0x00),
-	/*
-	 * VsmpsMHwHPReq1Valid
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUHWHPREQ1VALID2,     0x00, 0x00),
-	/*
-	 * VsmpsAHwHPReq2Valid
-	 * VsmpsBHwHPReq2Valid
-	 * VsafeHwHPReq2Valid
-	 * VanaHwHPReq2Valid        =3D disabled
-	 * VpllHwHPReq2Valid
-	 * Vaux1HwHPReq2Valid       =3D disabled
-	 * Vaux2HwHPReq2Valid       =3D disabled
-	 * Vaux3HwHPReq2Valid       =3D disabled
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUHWHPREQ2VALID1,     0xe8, 0x00),
-	/*
-	 * VsmpsMHwHPReq2Valid
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUHWHPREQ2VALID2,     0x00, 0x00),
-	/**
-	 * VsmpsCSwHPReqValid
-	 * VarmSwHPReqValid
-	 * VsmpsASwHPReqValid
-	 * VsmpsBSwHPReqValid
-	 * VsafeSwHPReqValid
-	 * VanaSwHPReqValid
-	 * VanaSwHPReqValid         =3D disabled
-	 * VpllSwHPReqValid
-	 * Vaux1SwHPReqValid        =3D disabled
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUSWHPREQVALID1,      0xa0, 0x00),
-	/*
-	 * Vaux2SwHPReqValid        =3D disabled
-	 * Vaux3SwHPReqValid        =3D disabled
-	 * VsmpsMSwHPReqValid
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUSWHPREQVALID2,      0x03, 0x00),
-	/*
-	 * SysClkReq2Valid1         =3D SysClkReq2 controlled
-	 * SysClkReq3Valid1         =3D disabled
-	 * SysClkReq4Valid1         =3D SysClkReq4 controlled
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUSYSCLKREQVALID1,    0x0e, 0x0a),
-	/*
-	 * SysClkReq2Valid2         =3D disabled
-	 * SysClkReq3Valid2         =3D disabled
-	 * SysClkReq4Valid2         =3D disabled
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUSYSCLKREQVALID2,    0x0e, 0x00),
-	/*
-	 * Vaux4SwHPReqValid
-	 * Vaux4HwHPReq2Valid
-	 * Vaux4HwHPReq1Valid
-	 * Vaux4SysClkReq1HPValid
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUVAUX4REQVALID,    0x00, 0x00),
-	/*
-	 * VadcEna                  =3D disabled
-	 * VintCore12Ena            =3D disabled
-	 * VintCore12Sel            =3D 1.25 V
-	 * VintCore12LP             =3D inactive (HP)
-	 * VadcLP                   =3D inactive (HP)
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUMISC1,              0xfe, 0x10),
-	/*
-	 * VaudioEna                =3D disabled
-	 * Vaux8Ena                 =3D disabled
-	 * Vamic1Ena                =3D disabled
-	 * Vamic2Ena                =3D disabled
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VAUDIOSUPPLY,           0x1e, 0x00),
-	/*
-	 * Vamic1_dzout             =3D high-Z when Vamic1 is disabled
-	 * Vamic2_dzout             =3D high-Z when Vamic2 is disabled
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUCTRL1VAMIC,         0x03, 0x00),
-	/*
-	 * VsmpsARegu
-	 * VsmpsASelCtrl
-	 * VsmpsAAutoMode
-	 * VsmpsAPWMMode
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VSMPSAREGU,    0x00, 0x00),
-	/*
-	 * VsmpsBRegu
-	 * VsmpsBSelCtrl
-	 * VsmpsBAutoMode
-	 * VsmpsBPWMMode
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VSMPSBREGU,    0x00, 0x00),
-	/*
-	 * VsafeRegu
-	 * VsafeSelCtrl
-	 * VsafeAutoMode
-	 * VsafePWMMode
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VSAFEREGU,    0x00, 0x00),
-	/*
-	 * VPll                     =3D Hw controlled (NOTE! PRCMU bits)
-	 * VanaRegu                 =3D force off
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VPLLVANAREGU,           0x0f, 0x02),
-	/*
-	 * VextSupply1Regu          =3D force OFF (OTP_ExtSupply12LPnPolarity 1)
-	 * VextSupply2Regu          =3D force OFF (OTP_ExtSupply12LPnPolarity 1)
-	 * VextSupply3Regu          =3D force OFF (OTP_ExtSupply3LPnPolarity 0)
-	 * ExtSupply2Bypass         =3D ExtSupply12LPn ball is 0 when Ena is 0
-	 * ExtSupply3Bypass         =3D ExtSupply3LPn ball is 0 when Ena is 0
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_EXTSUPPLYREGU,          0xff, 0x30),
-	/*
-	 * Vaux1Regu                =3D force HP
-	 * Vaux2Regu                =3D force off
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VAUX12REGU,             0x0f, 0x01),
-	/*
-	 * Vaux3Regu                =3D force off
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VRF1VAUX3REGU,          0x03, 0x00),
-	/*
-	 * VsmpsASel1
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VSMPSASEL1,    0x00, 0x00),
-	/*
-	 * VsmpsASel2
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VSMPSASEL2,    0x00, 0x00),
-	/*
-	 * VsmpsASel3
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VSMPSASEL3,    0x00, 0x00),
-	/*
-	 * VsmpsBSel1
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VSMPSBSEL1,    0x00, 0x00),
-	/*
-	 * VsmpsBSel2
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VSMPSBSEL2,    0x00, 0x00),
-	/*
-	 * VsmpsBSel3
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VSMPSBSEL3,    0x00, 0x00),
-	/*
-	 * VsafeSel1
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VSAFESEL1,    0x00, 0x00),
-	/*
-	 * VsafeSel2
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VSAFESEL2,    0x00, 0x00),
-	/*
-	 * VsafeSel3
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VSAFESEL3,    0x00, 0x00),
-	/*
-	 * Vaux1Sel                 =3D 2.8 V
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VAUX1SEL,               0x0f, 0x0C),
-	/*
-	 * Vaux2Sel                 =3D 2.9 V
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VAUX2SEL,               0x0f, 0x0d),
-	/*
-	 * Vaux3Sel                 =3D 2.91 V
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VRF1VAUX3SEL,           0x07, 0x07),
-	/*
-	 * Vaux4RequestCtrl
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VAUX4REQCTRL,    0x00, 0x00),
-	/*
-	 * Vaux4Regu
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VAUX4REGU,    0x00, 0x00),
-	/*
-	 * Vaux4Sel
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VAUX4SEL,    0x00, 0x00),
-	/*
-	 * Vaux1Disch               =3D short discharge time
-	 * Vaux2Disch               =3D short discharge time
-	 * Vaux3Disch               =3D short discharge time
-	 * Vintcore12Disch          =3D short discharge time
-	 * VTVoutDisch              =3D short discharge time
-	 * VaudioDisch              =3D short discharge time
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUCTRLDISCH,          0xfc, 0x00),
-	/*
-	 * VanaDisch                =3D short discharge time
-	 * Vaux8PullDownEna         =3D pulldown disabled when Vaux8 is disabled
-	 * Vaux8Disch               =3D short discharge time
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUCTRLDISCH2,         0x16, 0x00),
-	/*
-	 * Vaux4Disch               =3D short discharge time
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUCTRLDISCH3,         0x01, 0x00),
-	/*
-	 * Vaux5Sel
-	 * Vaux5LP
-	 * Vaux5Ena
-	 * Vaux5Disch
-	 * Vaux5DisSfst
-	 * Vaux5DisPulld
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_CTRLVAUX5,              0x00, 0x00),
-	/*
-	 * Vaux6Sel
-	 * Vaux6LP
-	 * Vaux6Ena
-	 * Vaux6DisPulld
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_CTRLVAUX6,              0x00, 0x00),
-};
-
-struct regulator_init_data ab8505_regulators[AB8505_NUM_REGULATORS] =3D {
-	/* supplies to the display/camera */
-	[AB8505_LDO_AUX1] =3D {
-		.constraints =3D {
-			.name =3D "V-DISPLAY",
-			.min_uV =3D 2800000,
-			.max_uV =3D 3300000,
-			.valid_ops_mask =3D REGULATOR_CHANGE_VOLTAGE |
-					  REGULATOR_CHANGE_STATUS,
-			.boot_on =3D 1, /* display is on at boot */
-		},
-		.num_consumer_supplies =3D ARRAY_SIZE(ab8500_vaux1_consumers),
-		.consumer_supplies =3D ab8500_vaux1_consumers,
-	},
-	/* supplies to the on-board eMMC */
-	[AB8505_LDO_AUX2] =3D {
-		.constraints =3D {
-			.name =3D "V-eMMC1",
-			.min_uV =3D 1100000,
-			.max_uV =3D 3300000,
-			.valid_ops_mask =3D REGULATOR_CHANGE_VOLTAGE |
-					  REGULATOR_CHANGE_STATUS |
-					  REGULATOR_CHANGE_MODE,
-			.valid_modes_mask =3D REGULATOR_MODE_NORMAL |
-					    REGULATOR_MODE_IDLE,
-		},
-		.num_consumer_supplies =3D ARRAY_SIZE(ab8500_vaux2_consumers),
-		.consumer_supplies =3D ab8500_vaux2_consumers,
-	},
-	/* supply for VAUX3, supplies to SDcard slots */
-	[AB8505_LDO_AUX3] =3D {
-		.constraints =3D {
-			.name =3D "V-MMC-SD",
-			.min_uV =3D 1100000,
-			.max_uV =3D 3300000,
-			.valid_ops_mask =3D REGULATOR_CHANGE_VOLTAGE |
-					  REGULATOR_CHANGE_STATUS |
-					  REGULATOR_CHANGE_MODE,
-			.valid_modes_mask =3D REGULATOR_MODE_NORMAL |
-					    REGULATOR_MODE_IDLE,
-		},
-		.num_consumer_supplies =3D ARRAY_SIZE(ab8500_vaux3_consumers),
-		.consumer_supplies =3D ab8500_vaux3_consumers,
-	},
-	/* supply for VAUX4, supplies to NFC and standalone secure element */
-	[AB8505_LDO_AUX4] =3D {
-		.constraints =3D {
-			.name =3D "V-NFC-SE",
-			.min_uV =3D 1100000,
-			.max_uV =3D 3300000,
-			.valid_ops_mask =3D REGULATOR_CHANGE_VOLTAGE |
-					  REGULATOR_CHANGE_STATUS |
-					  REGULATOR_CHANGE_MODE,
-			.valid_modes_mask =3D REGULATOR_MODE_NORMAL |
-					    REGULATOR_MODE_IDLE,
-		},
-		.num_consumer_supplies =3D ARRAY_SIZE(ab8505_vaux4_consumers),
-		.consumer_supplies =3D ab8505_vaux4_consumers,
-	},
-	/* supply for VAUX5, supplies to TBD */
-	[AB8505_LDO_AUX5] =3D {
-		.constraints =3D {
-			.name =3D "V-AUX5",
-			.min_uV =3D 1050000,
-			.max_uV =3D 2790000,
-			.valid_ops_mask =3D REGULATOR_CHANGE_VOLTAGE |
-					  REGULATOR_CHANGE_STATUS |
-					  REGULATOR_CHANGE_MODE,
-			.valid_modes_mask =3D REGULATOR_MODE_NORMAL |
-					    REGULATOR_MODE_IDLE,
-		},
-		.num_consumer_supplies =3D ARRAY_SIZE(ab8505_vaux5_consumers),
-		.consumer_supplies =3D ab8505_vaux5_consumers,
-	},
-	/* supply for VAUX6, supplies to TBD */
-	[AB8505_LDO_AUX6] =3D {
-		.constraints =3D {
-			.name =3D "V-AUX6",
-			.min_uV =3D 1050000,
-			.max_uV =3D 2790000,
-			.valid_ops_mask =3D REGULATOR_CHANGE_VOLTAGE |
-					  REGULATOR_CHANGE_STATUS |
-					  REGULATOR_CHANGE_MODE,
-			.valid_modes_mask =3D REGULATOR_MODE_NORMAL |
-					    REGULATOR_MODE_IDLE,
-		},
-		.num_consumer_supplies =3D ARRAY_SIZE(ab8505_vaux6_consumers),
-		.consumer_supplies =3D ab8505_vaux6_consumers,
-	},
-	/* supply for gpadc, ADC LDO */
-	[AB8505_LDO_ADC] =3D {
-		.constraints =3D {
-			.name =3D "V-ADC",
-			.valid_ops_mask =3D REGULATOR_CHANGE_STATUS,
-		},
-		.num_consumer_supplies =3D ARRAY_SIZE(ab8505_vadc_consumers),
-		.consumer_supplies =3D ab8505_vadc_consumers,
-	},
-	/* supply for ab8500-vaudio, VAUDIO LDO */
-	[AB8505_LDO_AUDIO] =3D {
-		.constraints =3D {
-			.name =3D "V-AUD",
-			.valid_ops_mask =3D REGULATOR_CHANGE_STATUS,
-		},
-		.num_consumer_supplies =3D ARRAY_SIZE(ab8500_vaud_consumers),
-		.consumer_supplies =3D ab8500_vaud_consumers,
-	},
-	/* supply for v-anamic1 VAMic1-LDO */
-	[AB8505_LDO_ANAMIC1] =3D {
-		.constraints =3D {
-			.name =3D "V-AMIC1",
-			.valid_ops_mask =3D REGULATOR_CHANGE_STATUS |
-					  REGULATOR_CHANGE_MODE,
-			.valid_modes_mask =3D REGULATOR_MODE_NORMAL |
-					    REGULATOR_MODE_IDLE,
-		},
-		.num_consumer_supplies =3D ARRAY_SIZE(ab8500_vamic1_consumers),
-		.consumer_supplies =3D ab8500_vamic1_consumers,
-	},
-	/* supply for v-amic2, VAMIC2 LDO, reuse constants for AMIC1 */
-	[AB8505_LDO_ANAMIC2] =3D {
-		.constraints =3D {
-			.name =3D "V-AMIC2",
-			.valid_ops_mask =3D REGULATOR_CHANGE_STATUS |
-					  REGULATOR_CHANGE_MODE,
-			.valid_modes_mask =3D REGULATOR_MODE_NORMAL |
-					    REGULATOR_MODE_IDLE,
-		},
-		.num_consumer_supplies =3D ARRAY_SIZE(ab8500_vamic2_consumers),
-		.consumer_supplies =3D ab8500_vamic2_consumers,
-	},
-	/* supply for v-aux8, VAUX8 LDO */
-	[AB8505_LDO_AUX8] =3D {
-		.constraints =3D {
-			.name =3D "V-AUX8",
-			.valid_ops_mask =3D REGULATOR_CHANGE_STATUS,
-		},
-		.num_consumer_supplies =3D ARRAY_SIZE(ab8505_vaux8_consumers),
-		.consumer_supplies =3D ab8505_vaux8_consumers,
-	},
-	/* supply for v-intcore12, VINTCORE12 LDO */
-	[AB8505_LDO_INTCORE] =3D {
-		.constraints =3D {
-			.name =3D "V-INTCORE",
-			.min_uV =3D 1250000,
-			.max_uV =3D 1350000,
-			.input_uV =3D 1800000,
-			.valid_ops_mask =3D REGULATOR_CHANGE_VOLTAGE |
-					  REGULATOR_CHANGE_STATUS |
-					  REGULATOR_CHANGE_MODE |
-					  REGULATOR_CHANGE_DRMS,
-			.valid_modes_mask =3D REGULATOR_MODE_NORMAL |
-					    REGULATOR_MODE_IDLE,
-		},
-		.num_consumer_supplies =3D ARRAY_SIZE(ab8500_vintcore_consumers),
-		.consumer_supplies =3D ab8500_vintcore_consumers,
-	},
-	/* supply for LDO USB */
-	[AB8505_LDO_USB] =3D {
-		.constraints =3D {
-			.name =3D "V-USB",
-			.valid_ops_mask =3D REGULATOR_CHANGE_STATUS |
-					  REGULATOR_CHANGE_MODE,
-			.valid_modes_mask =3D REGULATOR_MODE_NORMAL |
-					    REGULATOR_MODE_IDLE,
-		},
-		.num_consumer_supplies =3D ARRAY_SIZE(ab8505_usb_consumers),
-		.consumer_supplies =3D ab8505_usb_consumers,
-	},
-	/* supply for U8500 CSI-DSI, VANA LDO */
-	[AB8505_LDO_ANA] =3D {
-		.constraints =3D {
-			.name =3D "V-CSI-DSI",
-			.valid_ops_mask =3D REGULATOR_CHANGE_STATUS,
-		},
-		.num_consumer_supplies =3D ARRAY_SIZE(ab8500_vana_consumers),
-		.consumer_supplies =3D ab8500_vana_consumers,
-	},
-};
-
 struct ab8500_regulator_platform_data ab8500_regulator_plat_data =3D {
 	.reg_init               =3D ab8500_reg_init,
 	.num_reg_init           =3D ARRAY_SIZE(ab8500_reg_init),
@@ -984,82 +463,3 @@ struct ab8500_regulator_platform_data ab8500_regulator=
_plat_data =3D {
 	.ext_regulator          =3D ab8500_ext_regulators,
 	.num_ext_regulator      =3D ARRAY_SIZE(ab8500_ext_regulators),
 };
-
-struct ab8500_regulator_platform_data ab8505_regulator_plat_data =3D {
-	.reg_init               =3D ab8505_reg_init,
-	.num_reg_init           =3D ARRAY_SIZE(ab8505_reg_init),
-	.regulator              =3D ab8505_regulators,
-	.num_regulator          =3D ARRAY_SIZE(ab8505_regulators),
-};
-
-static void ab8500_modify_reg_init(int id, u8 mask, u8 value)
-{
-	int i;
-
-	if (cpu_is_u8520()) {
-		for (i =3D ARRAY_SIZE(ab8505_reg_init) - 1; i >=3D 0; i--) {
-			if (ab8505_reg_init[i].id =3D=3D id) {
-				u8 initval =3D ab8505_reg_init[i].value;
-				initval =3D (initval & ~mask) | (value & mask);
-				ab8505_reg_init[i].value =3D initval;
-
-				BUG_ON(mask & ~ab8505_reg_init[i].mask);
-				return;
-			}
-		}
-	} else {
-		for (i =3D ARRAY_SIZE(ab8500_reg_init) - 1; i >=3D 0; i--) {
-			if (ab8500_reg_init[i].id =3D=3D id) {
-				u8 initval =3D ab8500_reg_init[i].value;
-				initval =3D (initval & ~mask) | (value & mask);
-				ab8500_reg_init[i].value =3D initval;
-
-				BUG_ON(mask & ~ab8500_reg_init[i].mask);
-				return;
-			}
-		}
-	}
-
-	BUG_ON(1);
-}
-
-void mop500_regulator_init(void)
-{
-	struct regulator_init_data *regulator;
-
-	/*
-	 * Temporarily turn on Vaux2 on 8520 machine
-	 */
-	if (cpu_is_u8520()) {
-		/* Vaux2 initialized to be on */
-		ab8500_modify_reg_init(AB8505_VAUX12REGU, 0x0f, 0x05);
-	}
-
-	/*
-	 * Handle AB8500_EXT_SUPPLY2 on HREFP_V20_V50 boards (do it for
-	 * all HREFP_V20 boards)
-	 */
-	if (cpu_is_u8500v20()) {
-		/* VextSupply2RequestCtrl =3D  HP/OFF depending on VxRequest */
-		ab8500_modify_reg_init(AB8500_REGUREQUESTCTRL3, 0x01, 0x01);
-
-		/* VextSupply2SysClkReq1HPValid =3D SysClkReq1 controlled */
-		ab8500_modify_reg_init(AB8500_REGUSYSCLKREQ1HPVALID2,
-			0x20, 0x20);
-
-		/* VextSupply2 =3D force HP at initialization */
-		ab8500_modify_reg_init(AB8500_EXTSUPPLYREGU, 0x0c, 0x04);
-
-		/* enable VextSupply2 during platform active */
-		regulator =3D &ab8500_ext_regulators[AB8500_EXT_SUPPLY2];
-		regulator->constraints.always_on =3D 1;
-
-		/* disable VextSupply2 in suspend */
-		regulator =3D &ab8500_ext_regulators[AB8500_EXT_SUPPLY2];
-		regulator->constraints.state_mem.disabled =3D 1;
-		regulator->constraints.state_standby.disabled =3D 1;
-
-		/* enable VextSupply2 HW control (used in suspend) */
-		regulator->driver_data =3D (void *)&ab8500_ext_supply2;
-	}
-}
diff --git a/arch/arm/mach-ux500/board-mop500-regulators.h b/arch/arm/mach-=
ux500/board-mop500-regulators.h
index 9bece38fe933..3bbb0831b0cf 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.h
+++ b/arch/arm/mach-ux500/board-mop500-regulators.h
@@ -11,14 +11,6 @@
 #ifndef __BOARD_MOP500_REGULATORS_H
 #define __BOARD_MOP500_REGULATORS_H
=20
-#include <linux/regulator/machine.h>
-#include <linux/regulator/ab8500.h>
-
 extern struct ab8500_regulator_platform_data ab8500_regulator_plat_data;
-extern struct ab8500_regulator_platform_data ab8505_regulator_plat_data;
-extern struct regulator_init_data tps61052_regulator;
-extern struct regulator_init_data gpio_en_3v3_regulator;
-
-void mop500_regulator_init(void);
=20
 #endif
diff --git a/arch/powerpc/include/asm/vdso_datapage.h b/arch/powerpc/includ=
e/asm/vdso_datapage.h
index 1e0ee59c8276..6e700593fcb1 100644
--- a/arch/powerpc/include/asm/vdso_datapage.h
+++ b/arch/powerpc/include/asm/vdso_datapage.h
@@ -86,6 +86,7 @@ struct vdso_data {
 	__s32 wtom_clock_nsec;			/* Wall to monotonic clock nsec */
 	__s64 wtom_clock_sec;			/* Wall to monotonic clock sec */
 	struct timespec stamp_xtime;		/* xtime as at tb_orig_stamp */
+	__u32 hrtimer_res;			/* hrtimer resolution */
    	__u32 syscall_map_64[SYSCALL_MAP_SIZE]; /* map of syscalls  */
    	__u32 syscall_map_32[SYSCALL_MAP_SIZE]; /* map of syscalls */
 };
@@ -107,6 +108,7 @@ struct vdso_data {
 	__s32 wtom_clock_nsec;
 	struct timespec stamp_xtime;	/* xtime as at tb_orig_stamp */
 	__u32 stamp_sec_fraction;	/* fractional seconds of stamp_xtime */
+	__u32 hrtimer_res;		/* hrtimer resolution */
    	__u32 syscall_map_32[SYSCALL_MAP_SIZE]; /* map of syscalls */
 	__u32 dcache_block_size;	/* L1 d-cache block size     */
 	__u32 icache_block_size;	/* L1 i-cache block size     */
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-of=
fsets.c
index 213fcaf4168d..eaafd1e4728b 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -397,6 +397,7 @@ int main(void)
 	DEFINE(WTOM_CLOCK_NSEC, offsetof(struct vdso_data, wtom_clock_nsec));
 	DEFINE(STAMP_XTIME, offsetof(struct vdso_data, stamp_xtime));
 	DEFINE(STAMP_SEC_FRAC, offsetof(struct vdso_data, stamp_sec_fraction));
+	DEFINE(CLOCK_HRTIMER_RES, offsetof(struct vdso_data, hrtimer_res));
 	DEFINE(CFG_ICACHE_BLOCKSZ, offsetof(struct vdso_data, icache_block_size));
 	DEFINE(CFG_DCACHE_BLOCKSZ, offsetof(struct vdso_data, dcache_block_size));
 	DEFINE(CFG_ICACHE_LOGBLOCKSZ, offsetof(struct vdso_data, icache_log_block=
_size));
@@ -425,7 +426,6 @@ int main(void)
 	DEFINE(CLOCK_REALTIME, CLOCK_REALTIME);
 	DEFINE(CLOCK_MONOTONIC, CLOCK_MONOTONIC);
 	DEFINE(NSEC_PER_SEC, NSEC_PER_SEC);
-	DEFINE(CLOCK_REALTIME_RES, MONOTONIC_RES_NSEC);
=20
 #ifdef CONFIG_BUG
 	DEFINE(BUG_ENTRY_SIZE, sizeof(struct bug_entry));
diff --git a/arch/powerpc/kernel/misc_64.S b/arch/powerpc/kernel/misc_64.S
index 2b57cd9c8d6a..c77551859d7b 100644
--- a/arch/powerpc/kernel/misc_64.S
+++ b/arch/powerpc/kernel/misc_64.S
@@ -84,7 +84,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_COHERENT_ICACHE)
 	subf	r8,r6,r4		/* compute length */
 	add	r8,r8,r5		/* ensure we get enough */
 	lwz	r9,DCACHEL1LOGLINESIZE(r10)	/* Get log-2 of cache line size */
-	srw.	r8,r8,r9		/* compute line count */
+	srd.	r8,r8,r9		/* compute line count */
 	beqlr				/* nothing to do? */
 	mtctr	r8
 1:	dcbst	0,r6
@@ -100,7 +100,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_COHERENT_ICACHE)
 	subf	r8,r6,r4		/* compute length */
 	add	r8,r8,r5
 	lwz	r9,ICACHEL1LOGLINESIZE(r10)	/* Get log-2 of Icache line size */
-	srw.	r8,r8,r9		/* compute line count */
+	srd.	r8,r8,r9		/* compute line count */
 	beqlr				/* nothing to do? */
 	mtctr	r8
 2:	icbi	0,r6
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 9fff9cdcc519..1c1142f0bd4e 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -781,6 +781,7 @@ void update_vsyscall_old(struct timespec *wall_time, st=
ruct timespec *wtm,
 	vdso_data->wtom_clock_nsec =3D wtm->tv_nsec;
 	vdso_data->stamp_xtime =3D *wall_time;
 	vdso_data->stamp_sec_fraction =3D frac_sec;
+	vdso_data->hrtimer_res =3D hrtimer_resolution;
 	smp_wmb();
 	++(vdso_data->tb_update_count);
 }
diff --git a/arch/powerpc/kernel/vdso32/gettimeofday.S b/arch/powerpc/kerne=
l/vdso32/gettimeofday.S
index 8bacb8721961..aca055007783 100644
--- a/arch/powerpc/kernel/vdso32/gettimeofday.S
+++ b/arch/powerpc/kernel/vdso32/gettimeofday.S
@@ -159,12 +159,15 @@ V_FUNCTION_BEGIN(__kernel_clock_getres)
 	cror	cr0*4+eq,cr0*4+eq,cr1*4+eq
 	bne	cr0,99f
=20
+	mflr	r12
+  .cfi_register lr,r12
+	bl	__get_datapage@local	/* get data page */
+	lwz	r5, CLOCK_HRTIMER_RES(r3)
+	mtlr	r12
 	li	r3,0
 	cmpli	cr0,r4,0
 	crclr	cr0*4+so
 	beqlr
-	lis	r5,CLOCK_REALTIME_RES@h
-	ori	r5,r5,CLOCK_REALTIME_RES@l
 	stw	r3,TSPC32_TV_SEC(r4)
 	stw	r5,TSPC32_TV_NSEC(r4)
 	blr
diff --git a/arch/powerpc/kernel/vdso64/cacheflush.S b/arch/powerpc/kernel/=
vdso64/cacheflush.S
index 69c5af2b3c96..228a4a2383d6 100644
--- a/arch/powerpc/kernel/vdso64/cacheflush.S
+++ b/arch/powerpc/kernel/vdso64/cacheflush.S
@@ -39,7 +39,7 @@ V_FUNCTION_BEGIN(__kernel_sync_dicache)
 	subf	r8,r6,r4		/* compute length */
 	add	r8,r8,r5		/* ensure we get enough */
 	lwz	r9,CFG_DCACHE_LOGBLOCKSZ(r10)
-	srw.	r8,r8,r9		/* compute line count */
+	srd.	r8,r8,r9		/* compute line count */
 	crclr	cr0*4+so
 	beqlr				/* nothing to do? */
 	mtctr	r8
@@ -56,7 +56,7 @@ V_FUNCTION_BEGIN(__kernel_sync_dicache)
 	subf	r8,r6,r4		/* compute length */
 	add	r8,r8,r5
 	lwz	r9,CFG_ICACHE_LOGBLOCKSZ(r10)
-	srw.	r8,r8,r9		/* compute line count */
+	srd.	r8,r8,r9		/* compute line count */
 	crclr	cr0*4+so
 	beqlr				/* nothing to do? */
 	mtctr	r8
diff --git a/arch/powerpc/kernel/vdso64/gettimeofday.S b/arch/powerpc/kerne=
l/vdso64/gettimeofday.S
index 6a6a8495bd55..f00ba94c3f96 100644
--- a/arch/powerpc/kernel/vdso64/gettimeofday.S
+++ b/arch/powerpc/kernel/vdso64/gettimeofday.S
@@ -144,12 +144,15 @@ V_FUNCTION_BEGIN(__kernel_clock_getres)
 	cror	cr0*4+eq,cr0*4+eq,cr1*4+eq
 	bne	cr0,99f
=20
+	mflr	r12
+  .cfi_register lr,r12
+	bl	V_LOCAL_FUNC(__get_datapage)
+	lwz	r5, CLOCK_HRTIMER_RES(r3)
+	mtlr	r12
 	li	r3,0
 	cmpldi	cr0,r4,0
 	crclr	cr0*4+so
 	beqlr
-	lis	r5,CLOCK_REALTIME_RES@h
-	ori	r5,r5,CLOCK_REALTIME_RES@l
 	std	r3,TSPC64_TV_SEC(r4)
 	std	r5,TSPC64_TV_NSEC(r4)
 	blr
diff --git a/arch/s390/kernel/runtime_instr.c b/arch/s390/kernel/runtime_in=
str.c
index ddbec1054f75..9808fe741def 100644
--- a/arch/s390/kernel/runtime_instr.c
+++ b/arch/s390/kernel/runtime_instr.c
@@ -53,9 +53,9 @@ void exit_thread_runtime_instr(void)
 {
 	struct task_struct *task =3D current;
=20
-	preempt_disable();
 	if (!task->thread.ri_cb)
 		return;
+	preempt_disable();
 	disable_runtime_instr();
 	kfree(task->thread.ri_cb);
 	task->thread.ri_signum =3D 0;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 9b0a93bfc800..d38fa977b814 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2377,9 +2377,10 @@ static bool io_apic_level_ack_pending(struct irq_cfg=
 *cfg)
=20
 static inline bool ioapic_irqd_mask(struct irq_data *data, struct irq_cfg =
*cfg)
 {
-	/* If we are moving the irq we need to mask it */
+	/* If we are moving the IRQ we need to mask it */
 	if (unlikely(irqd_is_setaffinity_pending(data))) {
-		mask_ioapic(cfg);
+		if (!irqd_irq_masked(data))
+			mask_ioapic(cfg);
 		return true;
 	}
 	return false;
@@ -2417,7 +2418,9 @@ static inline void ioapic_irqd_unmask(struct irq_data=
 *data,
 		 */
 		if (!io_apic_level_ack_pending(cfg))
 			irq_move_masked_irq(data);
-		unmask_ioapic(cfg);
+		/* If the IRQ is masked in the core, leave it: */
+		if (!irqd_irq_masked(data))
+			unmask_ioapic(cfg);
 	}
 }
 #else
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 1ff1f10e8c80..9739e4436e79 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -349,8 +349,12 @@ static void __init taa_select_mitigation(void)
 		return;
 	}
=20
-	/* TAA mitigation is turned off on the cmdline (tsx_async_abort=3Doff) */
-	if (taa_mitigation =3D=3D TAA_MITIGATION_OFF)
+	/*
+	 * TAA mitigation via VERW is turned off if both
+	 * tsx_async_abort=3Doff and mds=3Doff are specified.
+	 */
+	if (taa_mitigation =3D=3D TAA_MITIGATION_OFF &&
+	    mds_mitigation =3D=3D MDS_MITIGATION_OFF)
 		goto out;
=20
 	if (boot_cpu_has(X86_FEATURE_MD_CLEAR))
@@ -381,6 +385,15 @@ static void __init taa_select_mitigation(void)
 	 */
 	static_branch_enable(&mds_user_clear);
=20
+	/*
+	 * Update MDS mitigation, if necessary, as the mds_user_clear is
+	 * now enabled for TAA mitigation.
+	 */
+	if (mds_mitigation =3D=3D MDS_MITIGATION_OFF &&
+	    boot_cpu_has_bug(X86_BUG_MDS)) {
+		mds_mitigation =3D MDS_MITIGATION_FULL;
+		mds_select_mitigation();
+	}
 out:
 	pr_info("%s\n", taa_strings[taa_mitigation]);
 }
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index e69f9882bf95..7c6bc9fe3947 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -180,6 +180,7 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 				goto overflow;
 			break;
 		case R_X86_64_PC32:
+		case R_X86_64_PLT32:
 			val -=3D (u64)loc;
 			*(u32 *)loc =3D val;
 #if 0
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d6711e5b9e78..9d4d3e0eaa6b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -242,13 +242,14 @@ int kvm_set_shared_msr(unsigned slot, u64 value, u64 =
mask)
 	struct kvm_shared_msrs *smsr =3D per_cpu_ptr(shared_msrs, cpu);
 	int err;
=20
-	if (((value ^ smsr->values[slot].curr) & mask) =3D=3D 0)
+	value =3D (value & mask) | (smsr->values[slot].host & ~mask);
+	if (value =3D=3D smsr->values[slot].curr)
 		return 0;
-	smsr->values[slot].curr =3D value;
 	err =3D wrmsrl_safe(shared_msrs_global.msrs[slot], value);
 	if (err)
 		return 1;
=20
+	smsr->values[slot].curr =3D value;
 	if (!smsr->registered) {
 		smsr->urn.on_user_return =3D kvm_on_user_return;
 		user_return_notifier_register(&smsr->urn);
@@ -945,10 +946,15 @@ u64 kvm_get_arch_capabilities(void)
 	 * If TSX is disabled on the system, guests are also mitigated against
 	 * TAA and clear CPU buffer mitigation is not required for guests.
 	 */
-	if (boot_cpu_has_bug(X86_BUG_TAA) && boot_cpu_has(X86_FEATURE_RTM) &&
-	    (data & ARCH_CAP_TSX_CTRL_MSR))
+	if (!boot_cpu_has(X86_FEATURE_RTM))
+		data &=3D ~ARCH_CAP_TAA_NO;
+	else if (!boot_cpu_has_bug(X86_BUG_TAA))
+		data |=3D ARCH_CAP_TAA_NO;
+	else if (data & ARCH_CAP_TSX_CTRL_MSR)
 		data &=3D ~ARCH_CAP_MDS_NO;
=20
+	/* KVM does not emulate MSR_IA32_TSX_CTRL.  */
+	data &=3D ~ARCH_CAP_TSX_CTRL_MSR;
 	return data;
 }
=20
diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index 4c0cfc53263b..7c3ec00efaa2 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -574,6 +574,17 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x6f60, p=
ci_invalid_bar);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x6fa0, pci_invalid_bar);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x6fc0, pci_invalid_bar);
=20
+/*
+ * Device [1022:7914]
+ * When in D0, PME# doesn't get asserted when plugging USB 2.0 device.
+ */
+static void pci_fixup_amd_fch_xhci_pme(struct pci_dev *dev)
+{
+	dev_info(&dev->dev, "PME# does not work under D0, disabling it\n");
+	dev->pme_support &=3D ~(PCI_PM_CAP_PME_D0 >> PCI_PM_CAP_PME_SHIFT);
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x7914, pci_fixup_amd_fch_xhci_=
pme);
+
 /*
  * Apple MacBook Pro: Avoid [mem 0x7fa00000-0x7fbfffff]
  *
diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index c5d2acce7f15..894f04464126 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -763,6 +763,7 @@ static int do_reloc64(struct section *sec, Elf_Rel *rel=
, ElfW(Sym) *sym,
 	switch (r_type) {
 	case R_X86_64_NONE:
 	case R_X86_64_PC32:
+	case R_X86_64_PLT32:
 		/*
 		 * NONE can be ignored and PC relative relocations don't
 		 * need to be adjusted.
diff --git a/arch/xtensa/mm/tlb.c b/arch/xtensa/mm/tlb.c
index 5ece856c5725..23d634916de9 100644
--- a/arch/xtensa/mm/tlb.c
+++ b/arch/xtensa/mm/tlb.c
@@ -218,6 +218,8 @@ static int check_tlb_entry(unsigned w, unsigned e, bool=
 dtlb)
 	unsigned tlbidx =3D w | (e << PAGE_SHIFT);
 	unsigned r0 =3D dtlb ?
 		read_dtlb_virtual(tlbidx) : read_itlb_virtual(tlbidx);
+	unsigned r1 =3D dtlb ?
+		read_dtlb_translation(tlbidx) : read_itlb_translation(tlbidx);
 	unsigned vpn =3D (r0 & PAGE_MASK) | (e << PAGE_SHIFT);
 	unsigned pte =3D get_pte_for_vaddr(vpn);
 	unsigned mm_asid =3D (get_rasid_register() >> 8) & ASID_MASK;
@@ -233,8 +235,6 @@ static int check_tlb_entry(unsigned w, unsigned e, bool=
 dtlb)
 	}
=20
 	if (tlb_asid =3D=3D mm_asid) {
-		unsigned r1 =3D dtlb ? read_dtlb_translation(tlbidx) :
-			read_itlb_translation(tlbidx);
 		if ((pte ^ r1) & PAGE_MASK) {
 			pr_err("%cTLB: way: %u, entry: %u, mapping: %08x->%08x, PTE: %08x\n",
 					dtlb ? 'D' : 'I', w, e, r0, r1, pte);
diff --git a/block/blk-mq-sysfs.c b/block/blk-mq-sysfs.c
index 4bd57a9cf5ff..f19ed271a139 100644
--- a/block/blk-mq-sysfs.c
+++ b/block/blk-mq-sysfs.c
@@ -226,24 +226,25 @@ static ssize_t blk_mq_hw_sysfs_active_show(struct blk=
_mq_hw_ctx *hctx, char *pag
=20
 static ssize_t blk_mq_hw_sysfs_cpus_show(struct blk_mq_hw_ctx *hctx, char =
*page)
 {
+	const size_t size =3D PAGE_SIZE - 1;
 	unsigned int i, first =3D 1;
-	ssize_t ret =3D 0;
-
-	blk_mq_disable_hotplug();
+	int ret =3D 0, pos =3D 0;
=20
 	for_each_cpu(i, hctx->cpumask) {
 		if (first)
-			ret +=3D sprintf(ret + page, "%u", i);
+			ret =3D snprintf(pos + page, size - pos, "%u", i);
 		else
-			ret +=3D sprintf(ret + page, ", %u", i);
+			ret =3D snprintf(pos + page, size - pos, ", %u", i);
+
+		if (ret >=3D size - pos)
+			break;
=20
 		first =3D 0;
+		pos +=3D ret;
 	}
=20
-	blk_mq_enable_hotplug();
-
-	ret +=3D sprintf(ret + page, "\n");
-	return ret;
+	ret =3D snprintf(pos + page, size + 1 - pos, "\n");
+	return pos + ret;
 }
=20
 static struct blk_mq_ctx_sysfs_entry blk_mq_sysfs_dispatched =3D {
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 8884453d0247..7d7e927f5876 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1645,6 +1645,11 @@ static void blk_mq_map_swqueue(struct request_queue =
*q)
 	struct blk_mq_ctx *ctx;
 	struct blk_mq_tag_set *set =3D q->tag_set;
=20
+	/*
+	 * Avoid others reading imcomplete hctx->cpumask through sysfs
+	 */
+	mutex_lock(&q->sysfs_lock);
+
 	queue_for_each_hw_ctx(q, hctx, i) {
 		cpumask_clear(hctx->cpumask);
 		hctx->nr_ctx =3D 0;
@@ -1664,6 +1669,8 @@ static void blk_mq_map_swqueue(struct request_queue *=
q)
 		hctx->ctxs[hctx->nr_ctx++] =3D ctx;
 	}
=20
+	mutex_unlock(&q->sysfs_lock);
+
 	queue_for_each_hw_ctx(q, hctx, i) {
 		/*
 		 * If not software queues are mapped to this hardware queue,
diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 244ff338e5c9..9dd6d6dd4c6b 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -154,7 +154,7 @@ int acpi_bus_get_private_data(acpi_handle handle, void =
**data)
 {
 	acpi_status status;
=20
-	if (!*data)
+	if (!data)
 		return -EINVAL;
=20
 	status =3D acpi_get_data(handle, acpi_bus_private_data_handler, data);
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 9fb0e4fd6ac0..ba9c12a3f859 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -416,24 +416,27 @@ acpi_os_map_memory(acpi_physical_address phys, acpi_s=
ize size)
 }
 EXPORT_SYMBOL_GPL(acpi_os_map_memory);
=20
-static void acpi_os_drop_map_ref(struct acpi_ioremap *map)
+/* Must be called with mutex_lock(&acpi_ioremap_lock) */
+static unsigned long acpi_os_drop_map_ref(struct acpi_ioremap *map)
 {
-	if (!--map->refcount)
+	unsigned long refcount =3D --map->refcount;
+
+	if (!refcount)
 		list_del_rcu(&map->list);
+	return refcount;
 }
=20
 static void acpi_os_map_cleanup(struct acpi_ioremap *map)
 {
-	if (!map->refcount) {
-		synchronize_rcu();
-		acpi_unmap(map->phys, map->virt);
-		kfree(map);
-	}
+	synchronize_rcu_expedited();
+	acpi_unmap(map->phys, map->virt);
+	kfree(map);
 }
=20
 void __ref acpi_os_unmap_iomem(void __iomem *virt, acpi_size size)
 {
 	struct acpi_ioremap *map;
+	unsigned long refcount;
=20
 	if (!acpi_gbl_permanent_mmap) {
 		__acpi_unmap_table(virt, size);
@@ -447,10 +450,11 @@ void __ref acpi_os_unmap_iomem(void __iomem *virt, ac=
pi_size size)
 		WARN(true, PREFIX "%s: bad address %p\n", __func__, virt);
 		return;
 	}
-	acpi_os_drop_map_ref(map);
+	refcount =3D acpi_os_drop_map_ref(map);
 	mutex_unlock(&acpi_ioremap_lock);
=20
-	acpi_os_map_cleanup(map);
+	if (!refcount)
+		acpi_os_map_cleanup(map);
 }
 EXPORT_SYMBOL_GPL(acpi_os_unmap_iomem);
=20
@@ -491,6 +495,7 @@ void acpi_os_unmap_generic_address(struct acpi_generic_=
address *gas)
 {
 	u64 addr;
 	struct acpi_ioremap *map;
+	unsigned long refcount;
=20
 	if (gas->space_id !=3D ACPI_ADR_SPACE_SYSTEM_MEMORY)
 		return;
@@ -506,10 +511,11 @@ void acpi_os_unmap_generic_address(struct acpi_generi=
c_address *gas)
 		mutex_unlock(&acpi_ioremap_lock);
 		return;
 	}
-	acpi_os_drop_map_ref(map);
+	refcount =3D acpi_os_drop_map_ref(map);
 	mutex_unlock(&acpi_ioremap_lock);
=20
-	acpi_os_map_cleanup(map);
+	if (!refcount)
+		acpi_os_map_cleanup(map);
 }
 EXPORT_SYMBOL(acpi_os_unmap_generic_address);
=20
diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkbac=
k/blkback.c
index 5bc220aefdd2..ef4290c9ef78 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -825,6 +825,8 @@ static int xen_blkbk_map(struct xen_blkif *blkif,
 out_of_memory:
 	pr_alert(DRV_PFX "%s: out of memory\n", __func__);
 	put_free_pages(blkif, pages_to_gnt, segs_to_map);
+	for (i =3D last_map; i < num; i++)
+		pages[i]->handle =3D BLKBACK_INVALID_HANDLE;
 	return -ENOMEM;
 }
=20
diff --git a/drivers/char/hw_random/omap3-rom-rng.c b/drivers/char/hw_rando=
m/omap3-rom-rng.c
index 6f2eaffed623..f6a556ca72fa 100644
--- a/drivers/char/hw_random/omap3-rom-rng.c
+++ b/drivers/char/hw_random/omap3-rom-rng.c
@@ -119,7 +119,8 @@ static int omap3_rom_rng_probe(struct platform_device *=
pdev)
 static int omap3_rom_rng_remove(struct platform_device *pdev)
 {
 	hwrng_unregister(&omap3_rom_rng_ops);
-	clk_disable_unprepare(rng_clk);
+	if (!rng_idle)
+		clk_disable_unprepare(rng_clk);
 	return 0;
 }
=20
diff --git a/drivers/clk/samsung/clk-exynos5420.c b/drivers/clk/samsung/clk=
-exynos5420.c
index d504b9124b9f..4f28877e6b5a 100644
--- a/drivers/clk/samsung/clk-exynos5420.c
+++ b/drivers/clk/samsung/clk-exynos5420.c
@@ -162,6 +162,8 @@ static unsigned long exynos5x_clk_regs[] __initdata =3D=
 {
 	GATE_BUS_CPU,
 	GATE_SCLK_CPU,
 	CLKOUT_CMU_CPU,
+	APLL_CON0,
+	KPLL_CON0,
 	CPLL_CON0,
 	DPLL_CON0,
 	EPLL_CON0,
diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
index 9634f20e3926..dd407d10f2e0 100644
--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -60,24 +60,23 @@ static inline void __cpuidle_unset_driver(struct cpuidl=
e_driver *drv)
  * __cpuidle_set_driver - set per CPU driver variables for the given drive=
r.
  * @drv: a valid pointer to a struct cpuidle_driver
  *
- * For each CPU in the driver's cpumask, unset the registered driver per C=
PU
- * to @drv.
- *
- * Returns 0 on success, -EBUSY if the CPUs have driver(s) already.
+ * Returns 0 on success, -EBUSY if any CPU in the cpumask have a driver
+ * different from drv already.
  */
 static inline int __cpuidle_set_driver(struct cpuidle_driver *drv)
 {
 	int cpu;
=20
 	for_each_cpu(cpu, drv->cpumask) {
+		struct cpuidle_driver *old_drv;
=20
-		if (__cpuidle_get_cpu_driver(cpu)) {
-			__cpuidle_unset_driver(drv);
+		old_drv =3D __cpuidle_get_cpu_driver(cpu);
+		if (old_drv && old_drv !=3D drv)
 			return -EBUSY;
-		}
+	}
=20
+	for_each_cpu(cpu, drv->cpumask)
 		per_cpu(cpuidle_drivers, cpu) =3D drv;
-	}
=20
 	return 0;
 }
diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index df02406ce085..fee949f7cf0a 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -95,6 +95,7 @@ static int devfreq_update_status(struct devfreq *devfreq,=
 unsigned long freq)
 	int lev, prev_lev, ret =3D 0;
 	unsigned long cur_time;
=20
+	lockdep_assert_held(&devfreq->lock);
 	cur_time =3D jiffies;
=20
 	prev_lev =3D devfreq_get_freq_level(devfreq, devfreq->previous_freq);
@@ -1054,9 +1055,13 @@ static ssize_t trans_stat_show(struct device *dev,
 	int i, j;
 	unsigned int max_state =3D devfreq->profile->max_state;
=20
+	mutex_lock(&devfreq->lock);
 	if (!devfreq->stop_polling &&
-			devfreq_update_status(devfreq, devfreq->previous_freq))
+			devfreq_update_status(devfreq, devfreq->previous_freq)) {
+		mutex_unlock(&devfreq->lock);
 		return 0;
+	}
+	mutex_unlock(&devfreq->lock);
=20
 	len =3D sprintf(buf, "   From  :   To\n");
 	len +=3D sprintf(buf + len, "         :");
diff --git a/drivers/gpu/drm/i810/i810_dma.c b/drivers/gpu/drm/i810/i810_dm=
a.c
index e88bac1d781f..428cab38b27a 100644
--- a/drivers/gpu/drm/i810/i810_dma.c
+++ b/drivers/gpu/drm/i810/i810_dma.c
@@ -724,7 +724,7 @@ static void i810_dma_dispatch_vertex(struct drm_device =
*dev,
 	if (nbox > I810_NR_SAREA_CLIPRECTS)
 		nbox =3D I810_NR_SAREA_CLIPRECTS;
=20
-	if (used > 4 * 1024)
+	if (used < 0 || used > 4 * 1024)
 		used =3D 0;
=20
 	if (sarea_priv->dirty)
@@ -1044,7 +1044,7 @@ static void i810_dma_dispatch_mc(struct drm_device *d=
ev, struct drm_buf *buf, in
 	if (u !=3D I810_BUF_CLIENT)
 		DRM_DEBUG("MC found buffer that isn't mine!\n");
=20
-	if (used > 4 * 1024)
+	if (used < 0 || used > 4 * 1024)
 		used =3D 0;
=20
 	sarea_priv->dirty =3D 0x7f;
diff --git a/drivers/gpu/drm/i915/i915_gem_userptr.c b/drivers/gpu/drm/i915=
/i915_gem_userptr.c
index ff290fc691c8..5db4d9ccf240 100644
--- a/drivers/gpu/drm/i915/i915_gem_userptr.c
+++ b/drivers/gpu/drm/i915/i915_gem_userptr.c
@@ -569,8 +569,28 @@ i915_gem_userptr_put_pages(struct drm_i915_gem_object =
*obj)
 	for_each_sg_page(obj->pages->sgl, &sg_iter, obj->pages->nents, 0) {
 		struct page *page =3D sg_page_iter_page(&sg_iter);
=20
-		if (obj->dirty)
+		if (obj->dirty && trylock_page(page)) {
+			/*
+			 * As this may not be anonymous memory (e.g. shmem)
+			 * but exist on a real mapping, we have to lock
+			 * the page in order to dirty it -- holding
+			 * the page reference is not sufficient to
+			 * prevent the inode from being truncated.
+			 * Play safe and take the lock.
+			 *
+			 * However...!
+			 *
+			 * The mmu-notifier can be invalidated for a
+			 * migrate_page, that is alreadying holding the lock
+			 * on the page. Such a try_to_unmap() will result
+			 * in us calling put_pages() and so recursively try
+			 * to lock the page. We avoid that deadlock with
+			 * a trylock_page() and in exchange we risk missing
+			 * some page dirtying.
+			 */
 			set_page_dirty(page);
+			unlock_page(page);
+		}
=20
 		mark_page_accessed(page);
 		page_cache_release(page);
diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index 06c62ad349da..66ae99d01158 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -6875,8 +6875,8 @@ static int cik_irq_init(struct radeon_device *rdev)
 	}
=20
 	/* setup interrupt control */
-	/* XXX this should actually be a bus address, not an MC address. same on =
older asics */
-	WREG32(INTERRUPT_CNTL2, rdev->ih.gpu_addr >> 8);
+	/* set dummy read address to dummy page address */
+	WREG32(INTERRUPT_CNTL2, rdev->dummy_page.addr >> 8);
 	interrupt_cntl =3D RREG32(INTERRUPT_CNTL);
 	/* IH_DUMMY_RD_OVERRIDE=3D0 - dummy read disabled with msi, enabled witho=
ut msi
 	 * IH_DUMMY_RD_OVERRIDE=3D1 - dummy read controlled by IH_DUMMY_RD_EN
diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index 0da2837bd099..11dc0dbe15f8 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -1810,8 +1810,8 @@ static int r100_packet0_check(struct radeon_cs_parser=
 *p,
 			track->textures[i].use_pitch =3D 1;
 		} else {
 			track->textures[i].use_pitch =3D 0;
-			track->textures[i].width =3D 1 << ((idx_value >> RADEON_TXFORMAT_WIDTH_=
SHIFT) & RADEON_TXFORMAT_WIDTH_MASK);
-			track->textures[i].height =3D 1 << ((idx_value >> RADEON_TXFORMAT_HEIGH=
T_SHIFT) & RADEON_TXFORMAT_HEIGHT_MASK);
+			track->textures[i].width =3D 1 << ((idx_value & RADEON_TXFORMAT_WIDTH_M=
ASK) >> RADEON_TXFORMAT_WIDTH_SHIFT);
+			track->textures[i].height =3D 1 << ((idx_value & RADEON_TXFORMAT_HEIGHT=
_MASK) >> RADEON_TXFORMAT_HEIGHT_SHIFT);
 		}
 		if (idx_value & RADEON_TXFORMAT_CUBIC_MAP_ENABLE)
 			track->textures[i].tex_coord_type =3D 2;
diff --git a/drivers/gpu/drm/radeon/r200.c b/drivers/gpu/drm/radeon/r200.c
index 58f0473aa73f..d41aa2965d56 100644
--- a/drivers/gpu/drm/radeon/r200.c
+++ b/drivers/gpu/drm/radeon/r200.c
@@ -473,8 +473,8 @@ int r200_packet0_check(struct radeon_cs_parser *p,
 			track->textures[i].use_pitch =3D 1;
 		} else {
 			track->textures[i].use_pitch =3D 0;
-			track->textures[i].width =3D 1 << ((idx_value >> RADEON_TXFORMAT_WIDTH_=
SHIFT) & RADEON_TXFORMAT_WIDTH_MASK);
-			track->textures[i].height =3D 1 << ((idx_value >> RADEON_TXFORMAT_HEIGH=
T_SHIFT) & RADEON_TXFORMAT_HEIGHT_MASK);
+			track->textures[i].width =3D 1 << ((idx_value & RADEON_TXFORMAT_WIDTH_M=
ASK) >> RADEON_TXFORMAT_WIDTH_SHIFT);
+			track->textures[i].height =3D 1 << ((idx_value & RADEON_TXFORMAT_HEIGHT=
_MASK) >> RADEON_TXFORMAT_HEIGHT_SHIFT);
 		}
 		if (idx_value & R200_TXFORMAT_LOOKUP_DISABLE)
 			track->textures[i].lookup_disable =3D true;
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index f5f9a5e28f48..979137efcfb0 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -3427,8 +3427,8 @@ int r600_irq_init(struct radeon_device *rdev)
 	}
=20
 	/* setup interrupt control */
-	/* set dummy read address to ring address */
-	WREG32(INTERRUPT_CNTL2, rdev->ih.gpu_addr >> 8);
+	/* set dummy read address to dummy page address */
+	WREG32(INTERRUPT_CNTL2, rdev->dummy_page.addr >> 8);
 	interrupt_cntl =3D RREG32(INTERRUPT_CNTL);
 	/* IH_DUMMY_RD_OVERRIDE=3D0 - dummy read disabled with msi, enabled witho=
ut msi
 	 * IH_DUMMY_RD_OVERRIDE=3D1 - dummy read controlled by IH_DUMMY_RD_EN
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index d473912ceb53..6d4c29dd619c 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -5749,8 +5749,8 @@ static int si_irq_init(struct radeon_device *rdev)
 	}
=20
 	/* setup interrupt control */
-	/* set dummy read address to ring address */
-	WREG32(INTERRUPT_CNTL2, rdev->ih.gpu_addr >> 8);
+	/* set dummy read address to dummy page address */
+	WREG32(INTERRUPT_CNTL2, rdev->dummy_page.addr >> 8);
 	interrupt_cntl =3D RREG32(INTERRUPT_CNTL);
 	/* IH_DUMMY_RD_OVERRIDE=3D0 - dummy read disabled with msi, enabled witho=
ut msi
 	 * IH_DUMMY_RD_OVERRIDE=3D1 - dummy read controlled by IH_DUMMY_RD_EN
diff --git a/drivers/iio/imu/adis16480.c b/drivers/iio/imu/adis16480.c
index 4f2994a667d0..29957630b40a 100644
--- a/drivers/iio/imu/adis16480.c
+++ b/drivers/iio/imu/adis16480.c
@@ -405,12 +405,14 @@ static int adis16480_get_calibbias(struct iio_dev *in=
dio_dev,
 	case IIO_MAGN:
 	case IIO_PRESSURE:
 		ret =3D adis_read_reg_16(&st->adis, reg, &val16);
-		*bias =3D sign_extend32(val16, 15);
+		if (ret =3D=3D 0)
+			*bias =3D sign_extend32(val16, 15);
 		break;
 	case IIO_ANGL_VEL:
 	case IIO_ACCEL:
 		ret =3D adis_read_reg_32(&st->adis, reg, &val32);
-		*bias =3D sign_extend32(val32, 31);
+		if (ret =3D=3D 0)
+			*bias =3D sign_extend32(val32, 31);
 		break;
 	default:
 			ret =3D -EINVAL;
@@ -758,6 +760,7 @@ static const struct iio_info adis16480_info =3D {
 	.read_raw =3D &adis16480_read_raw,
 	.write_raw =3D &adis16480_write_raw,
 	.update_scan_mode =3D adis_update_scan_mode,
+	.debugfs_reg_access =3D adis_debugfs_reg_access,
 	.driver_module =3D THIS_MODULE,
 };
=20
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp=
/srpt/ib_srpt.c
index fcf2647cd6c2..3ce71eda4b14 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1519,9 +1519,11 @@ static int srpt_build_cmd_rsp(struct srpt_rdma_ch *c=
h,
 			      struct srpt_send_ioctx *ioctx, u64 tag,
 			      int status)
 {
+	struct se_cmd *cmd =3D &ioctx->cmd;
 	struct srp_rsp *srp_rsp;
 	const u8 *sense_data;
 	int sense_data_len, max_sense_len;
+	u32 resid =3D cmd->residual_count;
=20
 	/*
 	 * The lowest bit of all SAM-3 status codes is zero (see also
@@ -1543,6 +1545,28 @@ static int srpt_build_cmd_rsp(struct srpt_rdma_ch *c=
h,
 	srp_rsp->tag =3D tag;
 	srp_rsp->status =3D status;
=20
+	if (cmd->se_cmd_flags & SCF_UNDERFLOW_BIT) {
+		if (cmd->data_direction =3D=3D DMA_TO_DEVICE) {
+			/* residual data from an underflow write */
+			srp_rsp->flags =3D SRP_RSP_FLAG_DOUNDER;
+			srp_rsp->data_out_res_cnt =3D cpu_to_be32(resid);
+		} else if (cmd->data_direction =3D=3D DMA_FROM_DEVICE) {
+			/* residual data from an underflow read */
+			srp_rsp->flags =3D SRP_RSP_FLAG_DIUNDER;
+			srp_rsp->data_in_res_cnt =3D cpu_to_be32(resid);
+		}
+	} else if (cmd->se_cmd_flags & SCF_OVERFLOW_BIT) {
+		if (cmd->data_direction =3D=3D DMA_TO_DEVICE) {
+			/* residual data from an overflow write */
+			srp_rsp->flags =3D SRP_RSP_FLAG_DOOVER;
+			srp_rsp->data_out_res_cnt =3D cpu_to_be32(resid);
+		} else if (cmd->data_direction =3D=3D DMA_FROM_DEVICE) {
+			/* residual data from an overflow read */
+			srp_rsp->flags =3D SRP_RSP_FLAG_DIOVER;
+			srp_rsp->data_in_res_cnt =3D cpu_to_be32(resid);
+		}
+	}
+
 	if (sense_data_len) {
 		BUILD_BUG_ON(MIN_MAX_RSP_SIZE <=3D sizeof(*srp_rsp));
 		max_sense_len =3D ch->max_ti_iu_len - sizeof(*srp_rsp);
diff --git a/drivers/media/i2c/soc_camera/ov6650.c b/drivers/media/i2c/soc_=
camera/ov6650.c
index c0e25bf55fb8..83aba0bbff77 100644
--- a/drivers/media/i2c/soc_camera/ov6650.c
+++ b/drivers/media/i2c/soc_camera/ov6650.c
@@ -203,7 +203,6 @@ struct ov6650 {
 	unsigned long		pclk_max;	/* from resolution and format */
 	struct v4l2_fract	tpf;		/* as requested with s_parm */
 	enum v4l2_mbus_pixelcode code;
-	enum v4l2_colorspace	colorspace;
 };
=20
=20
@@ -508,7 +507,7 @@ static int ov6650_g_fmt(struct v4l2_subdev *sd,
 	mf->width	=3D priv->rect.width >> priv->half_scale;
 	mf->height	=3D priv->rect.height >> priv->half_scale;
 	mf->code	=3D priv->code;
-	mf->colorspace	=3D priv->colorspace;
+	mf->colorspace	=3D V4L2_COLORSPACE_SRGB;
 	mf->field	=3D V4L2_FIELD_NONE;
=20
 	return 0;
@@ -606,7 +605,6 @@ static int ov6650_s_fmt(struct v4l2_subdev *sd, struct =
v4l2_mbus_framefmt *mf)
 		dev_err(&client->dev, "Pixel format not handled: 0x%x\n", code);
 		return -EINVAL;
 	}
-	priv->code =3D code;
=20
 	if (code =3D=3D V4L2_MBUS_FMT_Y8_1X8 ||
 			code =3D=3D V4L2_MBUS_FMT_SBGGR8_1X8) {
@@ -619,11 +617,6 @@ static int ov6650_s_fmt(struct v4l2_subdev *sd, struct=
 v4l2_mbus_framefmt *mf)
 		priv->pclk_max =3D 8000000;
 	}
=20
-	if (code =3D=3D V4L2_MBUS_FMT_SBGGR8_1X8)
-		priv->colorspace =3D V4L2_COLORSPACE_SRGB;
-	else if (code !=3D 0)
-		priv->colorspace =3D V4L2_COLORSPACE_JPEG;
-
 	if (half_scale) {
 		dev_dbg(&client->dev, "max resolution: QCIF\n");
 		coma_set |=3D COMA_QCIF;
@@ -632,7 +625,6 @@ static int ov6650_s_fmt(struct v4l2_subdev *sd, struct =
v4l2_mbus_framefmt *mf)
 		dev_dbg(&client->dev, "max resolution: CIF\n");
 		coma_mask |=3D COMA_QCIF;
 	}
-	priv->half_scale =3D half_scale;
=20
 	if (sense) {
 		if (sense->master_clock =3D=3D 8000000) {
@@ -672,11 +664,14 @@ static int ov6650_s_fmt(struct v4l2_subdev *sd, struc=
t v4l2_mbus_framefmt *mf)
 		ret =3D ov6650_reg_rmw(client, REG_COMA, coma_set, coma_mask);
 	if (!ret)
 		ret =3D ov6650_reg_write(client, REG_CLKRC, clkrc);
-	if (!ret)
+	if (!ret) {
+		priv->half_scale =3D half_scale;
+
 		ret =3D ov6650_reg_rmw(client, REG_COML, coml_set, coml_mask);
+	}
=20
 	if (!ret) {
-		mf->colorspace	=3D priv->colorspace;
+		priv->code =3D code;
 		mf->width =3D priv->rect.width >> half_scale;
 		mf->height =3D priv->rect.height >> half_scale;
 	}
@@ -695,6 +690,7 @@ static int ov6650_try_fmt(struct v4l2_subdev *sd,
 				&mf->height, 2, H_CIF, 1, 0);
=20
 	mf->field =3D V4L2_FIELD_NONE;
+	mf->colorspace =3D V4L2_COLORSPACE_SRGB;
=20
 	switch (mf->code) {
 	case V4L2_MBUS_FMT_Y10_1X10:
@@ -704,12 +700,10 @@ static int ov6650_try_fmt(struct v4l2_subdev *sd,
 	case V4L2_MBUS_FMT_YUYV8_2X8:
 	case V4L2_MBUS_FMT_VYUY8_2X8:
 	case V4L2_MBUS_FMT_UYVY8_2X8:
-		mf->colorspace =3D V4L2_COLORSPACE_JPEG;
 		break;
 	default:
 		mf->code =3D V4L2_MBUS_FMT_SBGGR8_1X8;
 	case V4L2_MBUS_FMT_SBGGR8_1X8:
-		mf->colorspace =3D V4L2_COLORSPACE_SRGB;
 		break;
 	}
=20
@@ -1016,7 +1010,6 @@ static int ov6650_probe(struct i2c_client *client,
 	priv->rect.height =3D H_CIF;
 	priv->half_scale  =3D false;
 	priv->code	  =3D V4L2_MBUS_FMT_YUYV8_2X8;
-	priv->colorspace  =3D V4L2_COLORSPACE_JPEG;
=20
 	priv->clk =3D v4l2_clk_get(&client->dev, "mclk");
 	if (IS_ERR(priv->clk)) {
diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/m=
edia/platform/exynos4-is/fimc-isp-video.c
index 3927f0f7dea2..bd154c528a53 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -322,7 +322,7 @@ static int isp_video_release(struct file *file)
 		ivc->streaming =3D 0;
 	}
=20
-	vb2_fop_release(file);
+	_vb2_fop_release(file, NULL);
=20
 	if (v4l2_fh_is_singular_file(file)) {
 		fimc_pipeline_call(&ivc->ve, close);
diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio=
-wl1273.c
index 9cf6731fb816..224f2c168ed7 100644
--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -1142,8 +1142,7 @@ static int wl1273_fm_fops_release(struct file *file)
 	if (radio->rds_users > 0) {
 		radio->rds_users--;
 		if (radio->rds_users =3D=3D 0) {
-			if (mutex_lock_interruptible(&core->lock))
-				return -EINTR;
+			mutex_lock(&core->lock);
=20
 			radio->irq_flags &=3D ~WL1273_RDS_EVENT;
=20
diff --git a/drivers/media/usb/usbvision/usbvision-core.c b/drivers/media/u=
sb/usbvision/usbvision-core.c
index 816b1cffab7d..43b6a868ed69 100644
--- a/drivers/media/usb/usbvision/usbvision-core.c
+++ b/drivers/media/usb/usbvision/usbvision-core.c
@@ -2166,56 +2166,6 @@ int usbvision_power_on(struct usb_usbvision *usbvisi=
on)
 }
=20
=20
-/*
- * usbvision timer stuff
- */
-
-/* to call usbvision_power_off from task queue */
-static void call_usbvision_power_off(struct work_struct *work)
-{
-	struct usb_usbvision *usbvision =3D container_of(work, struct usb_usbvisi=
on, power_off_work);
-
-	PDEBUG(DBG_FUNC, "");
-	if (mutex_lock_interruptible(&usbvision->v4l2_lock))
-		return;
-
-	if (usbvision->user =3D=3D 0) {
-		usbvision_i2c_unregister(usbvision);
-
-		usbvision_power_off(usbvision);
-		usbvision->initialized =3D 0;
-	}
-	mutex_unlock(&usbvision->v4l2_lock);
-}
-
-static void usbvision_power_off_timer(unsigned long data)
-{
-	struct usb_usbvision *usbvision =3D (void *)data;
-
-	PDEBUG(DBG_FUNC, "");
-	del_timer(&usbvision->power_off_timer);
-	INIT_WORK(&usbvision->power_off_work, call_usbvision_power_off);
-	(void) schedule_work(&usbvision->power_off_work);
-}
-
-void usbvision_init_power_off_timer(struct usb_usbvision *usbvision)
-{
-	init_timer(&usbvision->power_off_timer);
-	usbvision->power_off_timer.data =3D (long)usbvision;
-	usbvision->power_off_timer.function =3D usbvision_power_off_timer;
-}
-
-void usbvision_set_power_off_timer(struct usb_usbvision *usbvision)
-{
-	mod_timer(&usbvision->power_off_timer, jiffies + USBVISION_POWEROFF_TIME);
-}
-
-void usbvision_reset_power_off_timer(struct usb_usbvision *usbvision)
-{
-	if (timer_pending(&usbvision->power_off_timer))
-		del_timer(&usbvision->power_off_timer);
-}
-
 /*
  * usbvision_begin_streaming()
  * Sure you have to put bit 7 to 0, if not incoming frames are droped, but=
 no
diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/=
usb/usbvision/usbvision-video.c
index e70eca819be9..182a236462ad 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -122,8 +122,6 @@ static void usbvision_release(struct usb_usbvision *usb=
vision);
 static int isoc_mode =3D ISOC_MODE_COMPRESS;
 /* Set the default Debug Mode of the device driver */
 static int video_debug;
-/* Set the default device to power on at startup */
-static int power_on_at_open =3D 1;
 /* Sequential Number of Video Device */
 static int video_nr =3D -1;
 /* Sequential Number of Radio Device */
@@ -134,13 +132,11 @@ static int radio_nr =3D -1;
 /* Showing parameters under SYSFS */
 module_param(isoc_mode, int, 0444);
 module_param(video_debug, int, 0444);
-module_param(power_on_at_open, int, 0444);
 module_param(video_nr, int, 0444);
 module_param(radio_nr, int, 0444);
=20
 MODULE_PARM_DESC(isoc_mode, " Set the default format for ISOC endpoint.  D=
efault: 0x60 (Compression On)");
 MODULE_PARM_DESC(video_debug, " Set the default Debug Mode of the device d=
river.  Default: 0 (Off)");
-MODULE_PARM_DESC(power_on_at_open, " Set the default device to power on wh=
en device is opened.  Default: 1 (On)");
 MODULE_PARM_DESC(video_nr, "Set video device number (/dev/videoX).  Defaul=
t: -1 (autodetect)");
 MODULE_PARM_DESC(radio_nr, "Set radio device number (/dev/radioX).  Defaul=
t: -1 (autodetect)");
=20
@@ -351,11 +347,14 @@ static int usbvision_v4l2_open(struct file *file)
=20
 	if (mutex_lock_interruptible(&usbvision->v4l2_lock))
 		return -ERESTARTSYS;
-	usbvision_reset_power_off_timer(usbvision);
=20
-	if (usbvision->user)
+	if (usbvision->remove_pending) {
+		err_code =3D -ENODEV;
+		goto unlock;
+	}
+	if (usbvision->user) {
 		err_code =3D -EBUSY;
-	else {
+	} else {
 		/* Allocate memory for the scratch ring buffer */
 		err_code =3D usbvision_scratch_alloc(usbvision);
 		if (isoc_mode =3D=3D ISOC_MODE_COMPRESS) {
@@ -372,11 +371,6 @@ static int usbvision_v4l2_open(struct file *file)
=20
 	/* If so far no errors then we shall start the camera */
 	if (!err_code) {
-		if (usbvision->power =3D=3D 0) {
-			usbvision_power_on(usbvision);
-			usbvision_i2c_register(usbvision);
-		}
-
 		/* Send init sequence only once, it's large! */
 		if (!usbvision->initialized) {
 			int setup_ok =3D 0;
@@ -392,18 +386,14 @@ static int usbvision_v4l2_open(struct file *file)
 			err_code =3D usbvision_init_isoc(usbvision);
 			/* device must be initialized before isoc transfer */
 			usbvision_muxsel(usbvision, 0);
+
+			/* prepare queues */
+			usbvision_empty_framequeues(usbvision);
 			usbvision->user++;
-		} else {
-			if (power_on_at_open) {
-				usbvision_i2c_unregister(usbvision);
-				usbvision_power_off(usbvision);
-				usbvision->initialized =3D 0;
-			}
 		}
 	}
=20
-	/* prepare queues */
-	usbvision_empty_framequeues(usbvision);
+unlock:
 	mutex_unlock(&usbvision->v4l2_lock);
=20
 	PDEBUG(DBG_IO, "success");
@@ -421,6 +411,7 @@ static int usbvision_v4l2_open(struct file *file)
 static int usbvision_v4l2_close(struct file *file)
 {
 	struct usb_usbvision *usbvision =3D video_drvdata(file);
+	int r;
=20
 	PDEBUG(DBG_IO, "close");
=20
@@ -435,19 +426,14 @@ static int usbvision_v4l2_close(struct file *file)
 	usbvision_scratch_free(usbvision);
=20
 	usbvision->user--;
+	r =3D usbvision->remove_pending;
+	mutex_unlock(&usbvision->v4l2_lock);
=20
-	if (power_on_at_open) {
-		/* power off in a little while
-		   to avoid off/on every close/open short sequences */
-		usbvision_set_power_off_timer(usbvision);
-		usbvision->initialized =3D 0;
-	}
-
-	if (usbvision->remove_pending) {
+	if (r) {
 		printk(KERN_INFO "%s: Final disconnect\n", __func__);
 		usbvision_release(usbvision);
+		return 0;
 	}
-	mutex_unlock(&usbvision->v4l2_lock);
=20
 	PDEBUG(DBG_IO, "success");
 	return 0;
@@ -503,6 +489,9 @@ static int vidioc_querycap(struct file *file, void  *pr=
iv,
 {
 	struct usb_usbvision *usbvision =3D video_drvdata(file);
=20
+	if (!usbvision->dev)
+		return -ENODEV;
+
 	strlcpy(vc->driver, "USBVision", sizeof(vc->driver));
 	strlcpy(vc->card,
 		usbvision_device_data[usbvision->dev_model].model_string,
@@ -1154,20 +1143,17 @@ static int usbvision_radio_open(struct file *file)
=20
 	if (mutex_lock_interruptible(&usbvision->v4l2_lock))
 		return -ERESTARTSYS;
+
+	if (usbvision->remove_pending) {
+		err_code =3D -ENODEV;
+		goto out;
+	}
 	if (usbvision->user) {
 		dev_err(&usbvision->rdev->dev,
 			"%s: Someone tried to open an already opened USBVision Radio!\n",
 				__func__);
 		err_code =3D -EBUSY;
 	} else {
-		if (power_on_at_open) {
-			usbvision_reset_power_off_timer(usbvision);
-			if (usbvision->power =3D=3D 0) {
-				usbvision_power_on(usbvision);
-				usbvision_i2c_register(usbvision);
-			}
-		}
-
 		/* Alternate interface 1 is is the biggest frame size */
 		err_code =3D usbvision_set_alternate(usbvision);
 		if (err_code < 0) {
@@ -1182,14 +1168,6 @@ static int usbvision_radio_open(struct file *file)
 		usbvision_set_audio(usbvision, USBVISION_AUDIO_RADIO);
 		usbvision->user++;
 	}
-
-	if (err_code) {
-		if (power_on_at_open) {
-			usbvision_i2c_unregister(usbvision);
-			usbvision_power_off(usbvision);
-			usbvision->initialized =3D 0;
-		}
-	}
 out:
 	mutex_unlock(&usbvision->v4l2_lock);
 	return err_code;
@@ -1200,30 +1178,29 @@ static int usbvision_radio_close(struct file *file)
 {
 	struct usb_usbvision *usbvision =3D video_drvdata(file);
 	int err_code =3D 0;
+	int r;
=20
 	PDEBUG(DBG_IO, "");
=20
 	mutex_lock(&usbvision->v4l2_lock);
 	/* Set packet size to 0 */
 	usbvision->iface_alt =3D 0;
-	err_code =3D usb_set_interface(usbvision->dev, usbvision->iface,
-				    usbvision->iface_alt);
+	if (usbvision->dev)
+		err_code =3D usb_set_interface(usbvision->dev, usbvision->iface,
+					     usbvision->iface_alt);
=20
 	usbvision_audio_off(usbvision);
 	usbvision->radio =3D 0;
 	usbvision->user--;
+	r =3D usbvision->remove_pending;
+	mutex_unlock(&usbvision->v4l2_lock);
=20
-	if (power_on_at_open) {
-		usbvision_set_power_off_timer(usbvision);
-		usbvision->initialized =3D 0;
-	}
-
-	if (usbvision->remove_pending) {
+	if (r) {
 		printk(KERN_INFO "%s: Final disconnect\n", __func__);
 		usbvision_release(usbvision);
+		return err_code;
 	}
=20
-	mutex_unlock(&usbvision->v4l2_lock);
 	PDEBUG(DBG_IO, "success");
 	return err_code;
 }
@@ -1432,8 +1409,6 @@ static struct usb_usbvision *usbvision_alloc(struct u=
sb_device *dev,
 		goto err_unreg;
 	init_waitqueue_head(&usbvision->ctrl_urb_wq);
=20
-	usbvision_init_power_off_timer(usbvision);
-
 	return usbvision;
=20
 err_unreg:
@@ -1454,8 +1429,6 @@ static void usbvision_release(struct usb_usbvision *u=
sbvision)
 {
 	PDEBUG(DBG_PROBE, "");
=20
-	usbvision_reset_power_off_timer(usbvision);
-
 	usbvision->initialized =3D 0;
=20
 	usbvision_remove_sysfs(usbvision->vdev);
@@ -1499,11 +1472,9 @@ static void usbvision_configure_video(struct usb_usb=
vision *usbvision)
 	/* first switch off audio */
 	if (usbvision_device_data[model].audio_channels > 0)
 		usbvision_audio_off(usbvision);
-	if (!power_on_at_open) {
-		/* and then power up the noisy tuner */
-		usbvision_power_on(usbvision);
-		usbvision_i2c_register(usbvision);
-	}
+	/* and then power up the tuner */
+	usbvision_power_on(usbvision);
+	usbvision_i2c_register(usbvision);
 }
=20
 /*
@@ -1657,6 +1628,7 @@ static int usbvision_probe(struct usb_interface *intf,
 static void usbvision_disconnect(struct usb_interface *intf)
 {
 	struct usb_usbvision *usbvision =3D to_usbvision(usb_get_intfdata(intf));
+	int u;
=20
 	PDEBUG(DBG_PROBE, "");
=20
@@ -1671,19 +1643,16 @@ static void usbvision_disconnect(struct usb_interfa=
ce *intf)
 	usbvision_stop_isoc(usbvision);
=20
 	v4l2_device_disconnect(&usbvision->v4l2_dev);
-
-	if (usbvision->power) {
-		usbvision_i2c_unregister(usbvision);
-		usbvision_power_off(usbvision);
-	}
+	usbvision_i2c_unregister(usbvision);
 	usbvision->remove_pending =3D 1;	/* Now all ISO data will be ignored */
+	u =3D usbvision->user;
=20
 	usb_put_dev(usbvision->dev);
 	usbvision->dev =3D NULL;	/* USB device is no more */
=20
 	mutex_unlock(&usbvision->v4l2_lock);
=20
-	if (usbvision->user) {
+	if (u) {
 		printk(KERN_INFO "%s: In use, disconnect pending\n",
 		       __func__);
 		wake_up_interruptible(&usbvision->wait_frame);
diff --git a/drivers/media/usb/usbvision/usbvision.h b/drivers/media/usb/us=
bvision/usbvision.h
index a0c73cf1517c..ec0e17243c02 100644
--- a/drivers/media/usb/usbvision/usbvision.h
+++ b/drivers/media/usb/usbvision/usbvision.h
@@ -391,8 +391,6 @@ struct usb_usbvision {
 	unsigned char iface_alt;					/* Alt settings */
 	unsigned char vin_reg2_preset;
 	struct mutex v4l2_lock;
-	struct timer_list power_off_timer;
-	struct work_struct power_off_work;
 	int power;							/* is the device powered on? */
 	int user;							/* user count for exclusive use */
 	int initialized;						/* Had we already sent init sequence? */
@@ -510,9 +508,6 @@ int usbvision_muxsel(struct usb_usbvision *usbvision, i=
nt channel);
 int usbvision_set_input(struct usb_usbvision *usbvision);
 int usbvision_set_output(struct usb_usbvision *usbvision, int width, int h=
eight);
=20
-void usbvision_init_power_off_timer(struct usb_usbvision *usbvision);
-void usbvision_set_power_off_timer(struct usb_usbvision *usbvision);
-void usbvision_reset_power_off_timer(struct usb_usbvision *usbvision);
 int usbvision_power_off(struct usb_usbvision *usbvision);
 int usbvision_power_on(struct usb_usbvision *usbvision);
=20
diff --git a/drivers/mmc/host/sdhci-s3c.c b/drivers/mmc/host/sdhci-s3c.c
index 1e47903fa184..f973e5a98d0b 100644
--- a/drivers/mmc/host/sdhci-s3c.c
+++ b/drivers/mmc/host/sdhci-s3c.c
@@ -12,6 +12,7 @@
  * published by the Free Software Foundation.
  */
=20
+#include <linux/spinlock.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
 #include <linux/platform_device.h>
@@ -300,6 +301,7 @@ static void sdhci_cmu_set_clock(struct sdhci_host *host=
, unsigned int clock)
 	struct device *dev =3D &ourhost->pdev->dev;
 	unsigned long timeout;
 	u16 clk =3D 0;
+	int ret;
=20
 	host->mmc->actual_clock =3D 0;
=20
@@ -311,7 +313,19 @@ static void sdhci_cmu_set_clock(struct sdhci_host *hos=
t, unsigned int clock)
=20
 	sdhci_s3c_set_clock(host, clock);
=20
-	clk_set_rate(ourhost->clk_bus[ourhost->cur_clk], clock);
+	/* Reset SD Clock Enable */
+	clk =3D sdhci_readw(host, SDHCI_CLOCK_CONTROL);
+	clk &=3D ~SDHCI_CLOCK_CARD_EN;
+	sdhci_writew(host, clk, SDHCI_CLOCK_CONTROL);
+
+	spin_unlock_irq(&host->lock);
+	ret =3D clk_set_rate(ourhost->clk_bus[ourhost->cur_clk], clock);
+	spin_lock_irq(&host->lock);
+	if (ret !=3D 0) {
+		dev_err(dev, "%s: failed to set clock rate %uHz\n",
+			mmc_hostname(host->mmc), clock);
+		return;
+	}
=20
 	clk =3D SDHCI_CLOCK_INT_EN;
 	sdhci_writew(host, clk, SDHCI_CLOCK_CONTROL);
diff --git a/drivers/mtd/devices/spear_smi.c b/drivers/mtd/devices/spear_sm=
i.c
index c4176b0f382d..d839460f023f 100644
--- a/drivers/mtd/devices/spear_smi.c
+++ b/drivers/mtd/devices/spear_smi.c
@@ -595,6 +595,26 @@ static int spear_mtd_read(struct mtd_info *mtd, loff_t=
 from, size_t len,
 	return 0;
 }
=20
+/*
+ * The purpose of this function is to ensure a memcpy_toio() with byte wri=
tes
+ * only. Its structure is inspired from the ARM implementation of _memcpy_=
toio()
+ * which also does single byte writes but cannot be used here as this is j=
ust an
+ * implementation detail and not part of the API. Not mentioning the comme=
nt
+ * stating that _memcpy_toio() should be optimized.
+ */
+static void spear_smi_memcpy_toio_b(volatile void __iomem *dest,
+				    const void *src, size_t len)
+{
+	const unsigned char *from =3D src;
+
+	while (len) {
+		len--;
+		writeb(*from, dest);
+		from++;
+		dest++;
+	}
+}
+
 static inline int spear_smi_cpy_toio(struct spear_smi *dev, u32 bank,
 		void __iomem *dest, const void *src, size_t len)
 {
@@ -617,7 +637,23 @@ static inline int spear_smi_cpy_toio(struct spear_smi =
*dev, u32 bank,
 	ctrlreg1 =3D readl(dev->io_base + SMI_CR1);
 	writel((ctrlreg1 | WB_MODE) & ~SW_MODE, dev->io_base + SMI_CR1);
=20
-	memcpy_toio(dest, src, len);
+	/*
+	 * In Write Burst mode (WB_MODE), the specs states that writes must be:
+	 * - incremental
+	 * - of the same size
+	 * The ARM implementation of memcpy_toio() will optimize the number of
+	 * I/O by using as much 4-byte writes as possible, surrounded by
+	 * 2-byte/1-byte access if:
+	 * - the destination is not 4-byte aligned
+	 * - the length is not a multiple of 4-byte.
+	 * Avoid this alternance of write access size by using our own 'byte
+	 * access' helper if at least one of the two conditions above is true.
+	 */
+	if (IS_ALIGNED(len, sizeof(u32)) &&
+	    IS_ALIGNED((uintptr_t)dest, sizeof(u32)))
+		memcpy_toio(dest, src, len);
+	else
+		spear_smi_memcpy_toio_b(dest, src, len);
=20
 	writel(ctrlreg1, dev->io_base + SMI_CR1);
=20
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/=
ethernet/broadcom/bnx2x/bnx2x_cmn.c
index d44f22a487ab..66ca0978ec06 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -1914,7 +1914,8 @@ u16 bnx2x_select_queue(struct net_device *dev, struct=
 sk_buff *skb,
 	}
=20
 	/* select a non-FCoE queue */
-	return fallback(dev, skb) % (BNX2X_NUM_ETH_QUEUES(bp));
+	return fallback(dev, skb) %
+			(BNX2X_NUM_ETH_QUEUES(bp) * bp->max_cos);
 }
=20
 void bnx2x_set_num_queues(struct bnx2x *bp)
diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/eth=
ernet/stmicro/stmmac/common.h
index 1ad65fefa7aa..4561b16a9ebb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -298,7 +298,7 @@ struct dma_features {
 struct stmmac_desc_ops {
 	/* DMA RX descriptor ring initialization */
 	void (*init_rx_desc) (struct dma_desc *p, int disable_rx_ic, int mode,
-			      int end);
+			      int end, int bfsize);
 	/* DMA TX descriptor ring initialization */
 	void (*init_tx_desc) (struct dma_desc *p, int mode, int end);
=20
diff --git a/drivers/net/ethernet/stmicro/stmmac/descs_com.h b/drivers/net/=
ethernet/stmicro/stmmac/descs_com.h
index 166add5dc40b..f4f9f35d30b1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/descs_com.h
+++ b/drivers/net/ethernet/stmicro/stmmac/descs_com.h
@@ -33,9 +33,10 @@
 /* Specific functions used for Ring mode */
=20
 /* Enhanced descriptors */
-static inline void ehn_desc_rx_set_on_ring(struct dma_desc *p, int end)
+static inline void ehn_desc_rx_set_on_ring(struct dma_desc *p, int end, in=
t bfsize)
 {
-	p->des01.erx.buffer2_size =3D BUF_SIZE_8KiB;
+	if (bfsize =3D=3D BUF_SIZE_16KiB)
+		p->des01.erx.buffer2_size =3D BUF_SIZE_8KiB;
 	if (end)
 		p->des01.erx.end_ring =3D 1;
 }
@@ -61,9 +62,14 @@ static inline void enh_set_tx_desc_len_on_ring(struct dm=
a_desc *p, int len)
 }
=20
 /* Normal descriptors */
-static inline void ndesc_rx_set_on_ring(struct dma_desc *p, int end)
+static inline void ndesc_rx_set_on_ring(struct dma_desc *p, int end, int b=
fsize)
 {
-	p->des01.rx.buffer2_size =3D BUF_SIZE_2KiB - 1;
+	int size;
+
+	if (bfsize >=3D BUF_SIZE_2KiB) {
+		size =3D min(bfsize - BUF_SIZE_2KiB + 1, BUF_SIZE_2KiB - 1);
+		p->des01.rx.buffer2_size =3D size;
+	}
 	if (end)
 		p->des01.rx.end_ring =3D 1;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c b/drivers/net/e=
thernet/stmicro/stmmac/enh_desc.c
index 9d64428a327a..8f54ed9cc465 100644
--- a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
@@ -238,16 +238,20 @@ static int enh_desc_get_rx_status(void *data, struct =
stmmac_extra_stats *x,
 }
=20
 static void enh_desc_init_rx_desc(struct dma_desc *p, int disable_rx_ic,
-				  int mode, int end)
+				  int mode, int end, int bfsize)
 {
+	int bfsize1;
+
 	p->des01.all_flags =3D 0;
 	p->des01.erx.own =3D 1;
-	p->des01.erx.buffer1_size =3D BUF_SIZE_8KiB;
+
+	bfsize1 =3D min(bfsize, BUF_SIZE_8KiB);
+	p->des01.erx.buffer1_size =3D bfsize1;
=20
 	if (mode =3D=3D STMMAC_CHAIN_MODE)
 		ehn_desc_rx_set_on_chain(p, end);
 	else
-		ehn_desc_rx_set_on_ring(p, end);
+		ehn_desc_rx_set_on_ring(p, end, bfsize);
=20
 	if (disable_rx_ic)
 		p->des01.erx.disable_ic =3D 1;
diff --git a/drivers/net/ethernet/stmicro/stmmac/norm_desc.c b/drivers/net/=
ethernet/stmicro/stmmac/norm_desc.c
index 48c3456445b2..07e0c03cfb10 100644
--- a/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
@@ -121,16 +121,20 @@ static int ndesc_get_rx_status(void *data, struct stm=
mac_extra_stats *x,
 }
=20
 static void ndesc_init_rx_desc(struct dma_desc *p, int disable_rx_ic, int =
mode,
-			       int end)
+			       int end, int bfsize)
 {
+	int bfsize1;
+
 	p->des01.all_flags =3D 0;
 	p->des01.rx.own =3D 1;
-	p->des01.rx.buffer1_size =3D BUF_SIZE_2KiB - 1;
+
+	bfsize1 =3D min(bfsize, (BUF_SIZE_2KiB - 1));
+	p->des01.rx.buffer1_size =3D bfsize1;
=20
 	if (mode =3D=3D STMMAC_CHAIN_MODE)
 		ndesc_rx_set_on_chain(p, end);
 	else
-		ndesc_rx_set_on_ring(p, end);
+		ndesc_rx_set_on_ring(p, end, bfsize);
=20
 	if (disable_rx_ic)
 		p->des01.rx.disable_ic =3D 1;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/ne=
t/ethernet/stmicro/stmmac/stmmac_main.c
index fd35371ffae5..5fe95ef7954b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -933,11 +933,11 @@ static void stmmac_clear_descriptors(struct stmmac_pr=
iv *priv)
 		if (priv->extend_desc)
 			priv->hw->desc->init_rx_desc(&priv->dma_erx[i].basic,
 						     priv->use_riwt, priv->mode,
-						     (i =3D=3D rxsize - 1));
+						     (i =3D=3D rxsize - 1), priv->dma_buf_sz);
 		else
 			priv->hw->desc->init_rx_desc(&priv->dma_rx[i],
 						     priv->use_riwt, priv->mode,
-						     (i =3D=3D rxsize - 1));
+						     (i =3D=3D rxsize - 1), priv->dma_buf_sz);
 	for (i =3D 0; i < txsize; i++)
 		if (priv->extend_desc)
 			priv->hw->desc->init_tx_desc(&priv->dma_etx[i].basic,
@@ -2060,8 +2060,7 @@ static inline void stmmac_rx_refill(struct stmmac_pri=
v *priv)
 static int stmmac_rx(struct stmmac_priv *priv, int limit)
 {
 	unsigned int rxsize =3D priv->dma_rx_size;
-	unsigned int entry =3D priv->cur_rx % rxsize;
-	unsigned int next_entry;
+	unsigned int next_entry =3D priv->cur_rx % rxsize;
 	unsigned int count =3D 0;
 	int coe =3D priv->plat->rx_coe;
=20
@@ -2073,9 +2072,11 @@ static int stmmac_rx(struct stmmac_priv *priv, int l=
imit)
 			stmmac_display_ring((void *)priv->dma_rx, rxsize, 0);
 	}
 	while (count < limit) {
-		int status;
+		int status, entry;
 		struct dma_desc *p;
=20
+		entry =3D next_entry;
+
 		if (priv->extend_desc)
 			p =3D (struct dma_desc *)(priv->dma_erx + entry);
 		else
@@ -2120,6 +2121,12 @@ static int stmmac_rx(struct stmmac_priv *priv, int l=
imit)
=20
 			frame_len =3D priv->hw->desc->get_rx_frame_len(p, coe);
=20
+			/*  check if frame_len fits the preallocated memory */
+			if (frame_len > priv->dma_buf_sz) {
+				priv->dev->stats.rx_length_errors++;
+				continue;
+			}
+
 			/* ACS is set; GMAC core strips PAD/FCS for IEEE 802.3
 			 * Type frames (LLC/LLC-SNAP)
 			 */
@@ -2138,7 +2145,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int li=
mit)
 				pr_err("%s: Inconsistent Rx descriptor chain\n",
 				       priv->dev->name);
 				priv->dev->stats.rx_dropped++;
-				break;
+				continue;
 			}
 			prefetch(skb->data - NET_IP_ALIGN);
 			priv->rx_skbuff[entry] =3D NULL;
@@ -2169,7 +2176,6 @@ static int stmmac_rx(struct stmmac_priv *priv, int li=
mit)
 			priv->dev->stats.rx_packets++;
 			priv->dev->stats.rx_bytes +=3D frame_len;
 		}
-		entry =3D next_entry;
 	}
=20
 	stmmac_rx_refill(priv);
diff --git a/drivers/net/ethernet/ti/davinci_cpdma.c b/drivers/net/ethernet=
/ti/davinci_cpdma.c
index 619b815f9bac..3f8f6b704898 100644
--- a/drivers/net/ethernet/ti/davinci_cpdma.c
+++ b/drivers/net/ethernet/ti/davinci_cpdma.c
@@ -82,7 +82,7 @@ struct cpdma_desc {
=20
 struct cpdma_desc_pool {
 	phys_addr_t		phys;
-	u32			hw_addr;
+	dma_addr_t		hw_addr;
 	void __iomem		*iomap;		/* ioremap map */
 	void			*cpumap;	/* dma_alloc map */
 	int			desc_size, mem_size;
@@ -152,7 +152,7 @@ struct cpdma_chan {
  * abstract out these details
  */
 static struct cpdma_desc_pool *
-cpdma_desc_pool_create(struct device *dev, u32 phys, u32 hw_addr,
+cpdma_desc_pool_create(struct device *dev, u32 phys, dma_addr_t hw_addr,
 				int size, int align)
 {
 	int bitmap_size;
@@ -176,13 +176,13 @@ cpdma_desc_pool_create(struct device *dev, u32 phys, =
u32 hw_addr,
=20
 	if (phys) {
 		pool->phys  =3D phys;
-		pool->iomap =3D ioremap(phys, size);
+		pool->iomap =3D ioremap(phys, size); /* should be memremap? */
 		pool->hw_addr =3D hw_addr;
 	} else {
-		pool->cpumap =3D dma_alloc_coherent(dev, size, &pool->phys,
+		pool->cpumap =3D dma_alloc_coherent(dev, size, &pool->hw_addr,
 						  GFP_KERNEL);
-		pool->iomap =3D pool->cpumap;
-		pool->hw_addr =3D pool->phys;
+		pool->iomap =3D (void __iomem __force *)pool->cpumap;
+		pool->phys =3D pool->hw_addr; /* assumes no IOMMU, don't use this value =
*/
 	}
=20
 	if (pool->iomap)
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 7ba1bfea2864..9493690885cf 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -262,10 +262,11 @@ static void macvlan_broadcast_enqueue(struct macvlan_=
port *port,
 	}
 	spin_unlock(&port->bc_queue.lock);
=20
+	schedule_work(&port->bc_work);
+
 	if (err)
 		goto free_nskb;
=20
-	schedule_work(&port->bc_work);
 	return;
=20
 free_nskb:
diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireles=
s/ath/ar5523/ar5523.c
index f92050617ae6..aa06231d8b58 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -255,7 +255,8 @@ static int ar5523_cmd(struct ar5523 *ar, u32 code, cons=
t void *idata,
=20
 	if (flags & AR5523_CMD_FLAG_MAGIC)
 		hdr->magic =3D cpu_to_be32(1 << 24);
-	memcpy(hdr + 1, idata, ilen);
+	if (ilen)
+		memcpy(hdr + 1, idata, ilen);
=20
 	cmd->odata =3D odata;
 	cmd->olen =3D olen;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/w=
ireless/ath/ath9k/ar9003_eeprom.c
index d429dcbcb055..fef0c928ca31 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -4107,7 +4107,7 @@ static void ar9003_hw_thermometer_apply(struct ath_hw=
 *ah)
=20
 static void ar9003_hw_thermo_cal_apply(struct ath_hw *ah)
 {
-	u32 data, ko, kg;
+	u32 data =3D 0, ko, kg;
=20
 	if (!AR_SREV_9462_20_OR_LATER(ah))
 		return;
diff --git a/drivers/net/wireless/cw1200/fwio.c b/drivers/net/wireless/cw12=
00/fwio.c
index e23d67e0bfe6..306481e4142d 100644
--- a/drivers/net/wireless/cw1200/fwio.c
+++ b/drivers/net/wireless/cw1200/fwio.c
@@ -316,12 +316,12 @@ int cw1200_load_firmware(struct cw1200_common *priv)
 		goto out;
 	}
=20
-	priv->hw_type =3D cw1200_get_hw_type(val32, &major_revision);
-	if (priv->hw_type < 0) {
+	ret =3D cw1200_get_hw_type(val32, &major_revision);
+	if (ret < 0) {
 		pr_err("Can't deduce hardware type.\n");
-		ret =3D -ENOTSUPP;
 		goto out;
 	}
+	priv->hw_type =3D ret;
=20
 	/* Set DPLL Reg value, and read back to confirm writes work */
 	ret =3D cw1200_reg_write_32(priv, ST90TDS_TSET_GEN_R_W_REG_ID,
diff --git a/drivers/net/wireless/iwlwifi/dvm/led.c b/drivers/net/wireless/=
iwlwifi/dvm/led.c
index ca4d6692cc4e..47e5fa70483d 100644
--- a/drivers/net/wireless/iwlwifi/dvm/led.c
+++ b/drivers/net/wireless/iwlwifi/dvm/led.c
@@ -184,6 +184,9 @@ void iwl_leds_init(struct iwl_priv *priv)
=20
 	priv->led.name =3D kasprintf(GFP_KERNEL, "%s-led",
 				   wiphy_name(priv->hw->wiphy));
+	if (!priv->led.name)
+		return;
+
 	priv->led.brightness_set =3D iwl_led_brightness_set;
 	priv->led.blink_set =3D iwl_led_blink_set;
 	priv->led.max_brightness =3D 1;
diff --git a/drivers/net/wireless/iwlwifi/mvm/led.c b/drivers/net/wireless/=
iwlwifi/mvm/led.c
index e3b3cf4dbd77..948be43e4d26 100644
--- a/drivers/net/wireless/iwlwifi/mvm/led.c
+++ b/drivers/net/wireless/iwlwifi/mvm/led.c
@@ -109,6 +109,9 @@ int iwl_mvm_leds_init(struct iwl_mvm *mvm)
=20
 	mvm->led.name =3D kasprintf(GFP_KERNEL, "%s-led",
 				   wiphy_name(mvm->hw->wiphy));
+	if (!mvm->led.name)
+		return -ENOMEM;
+
 	mvm->led.brightness_set =3D iwl_led_brightness_set;
 	mvm->led.max_brightness =3D 1;
=20
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 1d6c61ad7da7..792e56fe0446 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -220,8 +220,9 @@ u32 default_msix_mask_irq(struct msi_desc *desc, u32 fl=
ag)
 	u32 mask_bits =3D desc->masked;
 	unsigned offset =3D desc->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE +
 						PCI_MSIX_ENTRY_VECTOR_CTRL;
+
 	mask_bits &=3D ~PCI_MSIX_ENTRY_CTRL_MASKBIT;
-	if (flag)
+	if (flag & PCI_MSIX_ENTRY_CTRL_MASKBIT)
 		mask_bits |=3D PCI_MSIX_ENTRY_CTRL_MASKBIT;
 	writel(mask_bits, desc->mask_base + offset);
=20
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 22f4b928fbdf..496eafc7ac79 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3787,7 +3787,7 @@ int pci_dev_specific_acs_enabled(struct pci_dev *dev,=
 u16 acs_flags)
 #define INTEL_BSPR_REG_BPPD  (1 << 9)
=20
 /* Upstream Peer Decode Configuration Register */
-#define INTEL_UPDCR_REG 0x1114
+#define INTEL_UPDCR_REG 0x1014
 /* 5:0 Peer Decode Enable bits */
 #define INTEL_UPDCR_REG_MASK 0x3f
=20
diff --git a/drivers/pinctrl/pinctrl-s3c24xx.c b/drivers/pinctrl/pinctrl-s3=
c24xx.c
index ad3eaad17001..f0b6d3a15121 100644
--- a/drivers/pinctrl/pinctrl-s3c24xx.c
+++ b/drivers/pinctrl/pinctrl-s3c24xx.c
@@ -497,8 +497,10 @@ static int s3c24xx_eint_init(struct samsung_pinctrl_dr=
v_data *d)
 		return -ENODEV;
=20
 	eint_data =3D devm_kzalloc(dev, sizeof(*eint_data), GFP_KERNEL);
-	if (!eint_data)
+	if (!eint_data) {
+		of_node_put(eint_np);
 		return -ENOMEM;
+	}
=20
 	eint_data->drvdata =3D d;
=20
@@ -510,6 +512,7 @@ static int s3c24xx_eint_init(struct samsung_pinctrl_drv=
_data *d)
 		irq =3D irq_of_parse_and_map(eint_np, i);
 		if (!irq) {
 			dev_err(dev, "failed to get wakeup EINT IRQ %d\n", i);
+			of_node_put(eint_np);
 			return -ENXIO;
 		}
=20
@@ -517,6 +520,7 @@ static int s3c24xx_eint_init(struct samsung_pinctrl_drv=
_data *d)
 		irq_set_chained_handler(irq, handlers[i]);
 		irq_set_handler_data(irq, eint_data);
 	}
+	of_node_put(eint_np);
=20
 	bank =3D d->ctrl->pin_banks;
 	for (i =3D 0; i < d->ctrl->nr_banks; ++i, ++bank) {
diff --git a/drivers/pinctrl/pinctrl-s3c64xx.c b/drivers/pinctrl/pinctrl-s3=
c64xx.c
index 89143c903000..cad8f97e046d 100644
--- a/drivers/pinctrl/pinctrl-s3c64xx.c
+++ b/drivers/pinctrl/pinctrl-s3c64xx.c
@@ -718,6 +718,7 @@ static int s3c64xx_eint_eint0_init(struct samsung_pinct=
rl_drv_data *d)
 	data =3D devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
 	if (!data) {
 		dev_err(dev, "could not allocate memory for wkup eint data\n");
+		of_node_put(eint0_np);
 		return -ENOMEM;
 	}
 	data->drvdata =3D d;
@@ -728,12 +729,14 @@ static int s3c64xx_eint_eint0_init(struct samsung_pin=
ctrl_drv_data *d)
 		irq =3D irq_of_parse_and_map(eint0_np, i);
 		if (!irq) {
 			dev_err(dev, "failed to get wakeup EINT IRQ %d\n", i);
+			of_node_put(eint0_np);
 			return -ENXIO;
 		}
=20
 		irq_set_chained_handler(irq, s3c64xx_eint0_handlers[i]);
 		irq_set_handler_data(irq, data);
 	}
+	of_node_put(eint0_np);
=20
 	bank =3D d->ctrl->pin_banks;
 	for (i =3D 0; i < d->ctrl->nr_banks; ++i, ++bank) {
diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 450d790c8bbf..d5f86dbf6dd6 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -90,7 +90,7 @@ struct bios_args {
 	u32 command;
 	u32 commandtype;
 	u32 datasize;
-	u32 data;
+	u8 data[128];
 };
=20
 struct bios_return {
@@ -199,7 +199,7 @@ static int hp_wmi_perform_query(int query, int write, v=
oid *buffer,
 		.command =3D write ? 0x2 : 0x1,
 		.commandtype =3D query,
 		.datasize =3D insize,
-		.data =3D 0,
+		.data =3D { 0 },
 	};
 	struct acpi_buffer input =3D { sizeof(struct bios_args), &args };
 	struct acpi_buffer output =3D { ACPI_ALLOCATE_BUFFER, NULL };
@@ -207,7 +207,7 @@ static int hp_wmi_perform_query(int query, int write, v=
oid *buffer,
=20
 	if (WARN_ON(insize > sizeof(args.data)))
 		return -EINVAL;
-	memcpy(&args.data, buffer, insize);
+	memcpy(&args.data[0], buffer, insize);
=20
 	wmi_evaluate_method(HPWMI_BIOS_GUID, 0, 0x3, &input, &output);
=20
@@ -400,7 +400,7 @@ static int hp_wmi_rfkill2_refresh(void)
 	struct bios_rfkill2_state state;
=20
 	err =3D hp_wmi_perform_query(HPWMI_WIRELESS2_QUERY, 0, &state,
-				   0, sizeof(state));
+				   sizeof(state), sizeof(state));
 	if (err)
 		return err;
=20
@@ -825,7 +825,7 @@ static int __init hp_wmi_rfkill2_setup(struct platform_=
device *device)
 	int err, i;
 	struct bios_rfkill2_state state;
 	err =3D hp_wmi_perform_query(HPWMI_WIRELESS2_QUERY, 0, &state,
-				   0, sizeof(state));
+				   sizeof(state), sizeof(state));
 	if (err)
 		return err;
=20
diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index c625468c7f2c..267d2a19fa99 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -1099,23 +1099,6 @@ static struct ab8500_regulator_info
 		.update_val_idle	=3D 0x82,
 		.update_val_normal	=3D 0x02,
 	},
-	[AB8505_LDO_USB] =3D {
-		.desc =3D {
-			.name           =3D "LDO-USB",
-			.ops            =3D &ab8500_regulator_mode_ops,
-			.type           =3D REGULATOR_VOLTAGE,
-			.id             =3D AB8505_LDO_USB,
-			.owner          =3D THIS_MODULE,
-			.n_voltages     =3D 1,
-			.volt_table	=3D fixed_3300000_voltage,
-		},
-		.update_bank            =3D 0x03,
-		.update_reg             =3D 0x82,
-		.update_mask            =3D 0x03,
-		.update_val		=3D 0x01,
-		.update_val_idle	=3D 0x03,
-		.update_val_normal	=3D 0x01,
-	},
 	[AB8505_LDO_AUDIO] =3D {
 		.desc =3D {
 			.name		=3D "LDO-AUDIO",
diff --git a/drivers/rtc/rtc-msm6242.c b/drivers/rtc/rtc-msm6242.c
index 426cb5189daa..7e09e2f16515 100644
--- a/drivers/rtc/rtc-msm6242.c
+++ b/drivers/rtc/rtc-msm6242.c
@@ -130,7 +130,8 @@ static int msm6242_read_time(struct device *dev, struct=
 rtc_time *tm)
 		      msm6242_read(priv, MSM6242_SECOND1);
 	tm->tm_min  =3D msm6242_read(priv, MSM6242_MINUTE10) * 10 +
 		      msm6242_read(priv, MSM6242_MINUTE1);
-	tm->tm_hour =3D (msm6242_read(priv, MSM6242_HOUR10 & 3)) * 10 +
+	tm->tm_hour =3D (msm6242_read(priv, MSM6242_HOUR10) &
+		       MSM6242_HOUR10_HR_MASK) * 10 +
 		      msm6242_read(priv, MSM6242_HOUR1);
 	tm->tm_mday =3D msm6242_read(priv, MSM6242_DAY10) * 10 +
 		      msm6242_read(priv, MSM6242_DAY1);
diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index ee662b7b09bf..de396ece93db 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -93,11 +93,9 @@ void zfcp_dbf_hba_fsf_res(char *tag, int level, struct z=
fcp_fsf_req *req)
 	memcpy(rec->u.res.fsf_status_qual, &q_head->fsf_status_qual,
 	       FSF_STATUS_QUALIFIER_SIZE);
=20
-	if (req->fsf_command !=3D FSF_QTCB_FCP_CMND) {
-		rec->pl_len =3D q_head->log_length;
-		zfcp_dbf_pl_write(dbf, (char *)q_pref + q_head->log_start,
-				  rec->pl_len, "fsf_res", req->req_id);
-	}
+	rec->pl_len =3D q_head->log_length;
+	zfcp_dbf_pl_write(dbf, (char *)q_pref + q_head->log_start,
+			  rec->pl_len, "fsf_res", req->req_id);
=20
 	debug_event(dbf->hba, level, rec, sizeof(*rec));
 	spin_unlock_irqrestore(&dbf->hba_lock, flags);
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_is=
csi.c
index 0bf408ac5b7a..e4bc1bc1827c 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -913,12 +913,12 @@ void bnx2i_free_hba(struct bnx2i_hba *hba)
 	INIT_LIST_HEAD(&hba->ep_ofld_list);
 	INIT_LIST_HEAD(&hba->ep_active_list);
 	INIT_LIST_HEAD(&hba->ep_destroy_list);
-	pci_dev_put(hba->pcidev);
=20
 	if (hba->regview) {
 		pci_iounmap(hba->pcidev, hba->regview);
 		hba->regview =3D NULL;
 	}
+	pci_dev_put(hba->pcidev);
 	bnx2i_free_mp_bdt(hba);
 	bnx2i_release_free_cid_que(hba);
 	iscsi_host_free(shost);
diff --git a/drivers/scsi/csiostor/csio_lnode.c b/drivers/scsi/csiostor/csi=
o_lnode.c
index ffe9be04dc39..289124e3786b 100644
--- a/drivers/scsi/csiostor/csio_lnode.c
+++ b/drivers/scsi/csiostor/csio_lnode.c
@@ -292,6 +292,7 @@ csio_ln_fdmi_rhba_cbfn(struct csio_hw *hw, struct csio_=
ioreq *fdmi_req)
 	struct fc_fdmi_port_name *port_name;
 	uint8_t buf[64];
 	uint8_t *fc4_type;
+	unsigned long flags;
=20
 	if (fdmi_req->wr_status !=3D FW_SUCCESS) {
 		csio_ln_dbg(ln, "WR error:%x in processing fdmi rhba cmd\n",
@@ -369,13 +370,13 @@ csio_ln_fdmi_rhba_cbfn(struct csio_hw *hw, struct csi=
o_ioreq *fdmi_req)
 	len =3D (uint32_t)(pld - (uint8_t *)cmd);
=20
 	/* Submit FDMI RPA request */
-	spin_lock_irq(&hw->lock);
+	spin_lock_irqsave(&hw->lock, flags);
 	if (csio_ln_mgmt_submit_req(fdmi_req, csio_ln_fdmi_done,
 				FCOE_CT, &fdmi_req->dma_buf, len)) {
 		CSIO_INC_STATS(ln, n_fdmi_err);
 		csio_ln_dbg(ln, "Failed to issue fdmi rpa req\n");
 	}
-	spin_unlock_irq(&hw->lock);
+	spin_unlock_irqrestore(&hw->lock, flags);
 }
=20
 /*
@@ -396,6 +397,7 @@ csio_ln_fdmi_dprt_cbfn(struct csio_hw *hw, struct csio_=
ioreq *fdmi_req)
 	struct fc_fdmi_rpl *reg_pl;
 	struct fs_fdmi_attrs *attrib_blk;
 	uint8_t buf[64];
+	unsigned long flags;
=20
 	if (fdmi_req->wr_status !=3D FW_SUCCESS) {
 		csio_ln_dbg(ln, "WR error:%x in processing fdmi dprt cmd\n",
@@ -476,13 +478,13 @@ csio_ln_fdmi_dprt_cbfn(struct csio_hw *hw, struct csi=
o_ioreq *fdmi_req)
 	attrib_blk->numattrs =3D htonl(numattrs);
=20
 	/* Submit FDMI RHBA request */
-	spin_lock_irq(&hw->lock);
+	spin_lock_irqsave(&hw->lock, flags);
 	if (csio_ln_mgmt_submit_req(fdmi_req, csio_ln_fdmi_rhba_cbfn,
 				FCOE_CT, &fdmi_req->dma_buf, len)) {
 		CSIO_INC_STATS(ln, n_fdmi_err);
 		csio_ln_dbg(ln, "Failed to issue fdmi rhba req\n");
 	}
-	spin_unlock_irq(&hw->lock);
+	spin_unlock_irqrestore(&hw->lock, flags);
 }
=20
 /*
@@ -497,6 +499,7 @@ csio_ln_fdmi_dhba_cbfn(struct csio_hw *hw, struct csio_=
ioreq *fdmi_req)
 	void *cmd;
 	struct fc_fdmi_port_name *port_name;
 	uint32_t len;
+	unsigned long flags;
=20
 	if (fdmi_req->wr_status !=3D FW_SUCCESS) {
 		csio_ln_dbg(ln, "WR error:%x in processing fdmi dhba cmd\n",
@@ -527,13 +530,13 @@ csio_ln_fdmi_dhba_cbfn(struct csio_hw *hw, struct csi=
o_ioreq *fdmi_req)
 	len +=3D sizeof(*port_name);
=20
 	/* Submit FDMI request */
-	spin_lock_irq(&hw->lock);
+	spin_lock_irqsave(&hw->lock, flags);
 	if (csio_ln_mgmt_submit_req(fdmi_req, csio_ln_fdmi_dprt_cbfn,
 				FCOE_CT, &fdmi_req->dma_buf, len)) {
 		CSIO_INC_STATS(ln, n_fdmi_err);
 		csio_ln_dbg(ln, "Failed to issue fdmi dprt req\n");
 	}
-	spin_unlock_irq(&hw->lock);
+	spin_unlock_irqrestore(&hw->lock, flags);
 }
=20
 /**
diff --git a/drivers/scsi/esas2r/esas2r_flash.c b/drivers/scsi/esas2r/esas2=
r_flash.c
index b7dc59fca7a6..0016dca70df0 100644
--- a/drivers/scsi/esas2r/esas2r_flash.c
+++ b/drivers/scsi/esas2r/esas2r_flash.c
@@ -1197,6 +1197,7 @@ bool esas2r_nvram_read_direct(struct esas2r_adapter *=
a)
 	if (!esas2r_read_flash_block(a, a->nvram, FLS_OFFSET_NVR,
 				     sizeof(struct esas2r_sas_nvram))) {
 		esas2r_hdebug("NVRAM read failed, using defaults");
+		up(&a->nvram_semaphore);
 		return false;
 	}
=20
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 7a5d81a65be8..e53ea24e713d 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3861,7 +3861,7 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_=
iocbq *cmdiocb,
 		mempool_free(mbox, phba->mbox_mem_pool);
 	}
 out:
-	if (ndlp && NLP_CHK_NODE_ACT(ndlp)) {
+	if (ndlp && NLP_CHK_NODE_ACT(ndlp) && shost) {
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag &=3D ~(NLP_ACC_REGLOGIN | NLP_RM_DFLT_RPI);
 		spin_unlock_irq(shost->host_lock);
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 0a3312c6dd6d..f6d93fa49d0b 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -641,9 +641,6 @@ int qla4xxx_initialize_fw_cb(struct scsi_qla_host * ha)
=20
 	if (qla4xxx_get_ifcb(ha, &mbox_cmd[0], &mbox_sts[0], init_fw_cb_dma) !=3D
 	    QLA_SUCCESS) {
-		dma_free_coherent(&ha->pdev->dev,
-				  sizeof(struct addr_ctrl_blk),
-				  init_fw_cb, init_fw_cb_dma);
 		goto exit_init_fw_cb;
 	}
=20
diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
index 2bea4f0b684a..27a92e714a41 100644
--- a/drivers/scsi/scsi_trace.c
+++ b/drivers/scsi/scsi_trace.c
@@ -17,10 +17,11 @@
  */
 #include <linux/kernel.h>
 #include <linux/trace_seq.h>
+#include <asm/unaligned.h>
 #include <trace/events/scsi.h>
=20
 #define SERVICE_ACTION16(cdb) (cdb[1] & 0x1f)
-#define SERVICE_ACTION32(cdb) ((cdb[8] << 8) | cdb[9])
+#define SERVICE_ACTION32(cdb) (get_unaligned_be16(&cdb[8]))
=20
 static const char *
 scsi_trace_misc(struct trace_seq *, unsigned char *, int);
@@ -29,15 +30,18 @@ static const char *
 scsi_trace_rw6(struct trace_seq *p, unsigned char *cdb, int len)
 {
 	const char *ret =3D p->buffer + p->len;
-	sector_t lba =3D 0, txlen =3D 0;
+	u32 lba =3D 0, txlen;
=20
 	lba |=3D ((cdb[1] & 0x1F) << 16);
 	lba |=3D  (cdb[2] << 8);
 	lba |=3D   cdb[3];
-	txlen =3D cdb[4];
+	/*
+	 * From SBC-2: a TRANSFER LENGTH field set to zero specifies that 256
+	 * logical blocks shall be read (READ(6)) or written (WRITE(6)).
+	 */
+	txlen =3D cdb[4] ? cdb[4] : 256;
=20
-	trace_seq_printf(p, "lba=3D%llu txlen=3D%llu",
-			 (unsigned long long)lba, (unsigned long long)txlen);
+	trace_seq_printf(p, "lba=3D%u txlen=3D%u", lba, txlen);
 	trace_seq_putc(p, 0);
=20
 	return ret;
@@ -47,17 +51,12 @@ static const char *
 scsi_trace_rw10(struct trace_seq *p, unsigned char *cdb, int len)
 {
 	const char *ret =3D p->buffer + p->len;
-	sector_t lba =3D 0, txlen =3D 0;
+	u32 lba, txlen;
=20
-	lba |=3D (cdb[2] << 24);
-	lba |=3D (cdb[3] << 16);
-	lba |=3D (cdb[4] << 8);
-	lba |=3D  cdb[5];
-	txlen |=3D (cdb[7] << 8);
-	txlen |=3D  cdb[8];
+	lba =3D get_unaligned_be32(&cdb[2]);
+	txlen =3D get_unaligned_be16(&cdb[7]);
=20
-	trace_seq_printf(p, "lba=3D%llu txlen=3D%llu protect=3D%u",
-			 (unsigned long long)lba, (unsigned long long)txlen,
+	trace_seq_printf(p, "lba=3D%u txlen=3D%u protect=3D%u", lba, txlen,
 			 cdb[1] >> 5);
=20
 	if (cdb[0] =3D=3D WRITE_SAME)
@@ -72,19 +71,12 @@ static const char *
 scsi_trace_rw12(struct trace_seq *p, unsigned char *cdb, int len)
 {
 	const char *ret =3D p->buffer + p->len;
-	sector_t lba =3D 0, txlen =3D 0;
-
-	lba |=3D (cdb[2] << 24);
-	lba |=3D (cdb[3] << 16);
-	lba |=3D (cdb[4] << 8);
-	lba |=3D  cdb[5];
-	txlen |=3D (cdb[6] << 24);
-	txlen |=3D (cdb[7] << 16);
-	txlen |=3D (cdb[8] << 8);
-	txlen |=3D  cdb[9];
-
-	trace_seq_printf(p, "lba=3D%llu txlen=3D%llu protect=3D%u",
-			 (unsigned long long)lba, (unsigned long long)txlen,
+	u32 lba, txlen;
+
+	lba =3D get_unaligned_be32(&cdb[2]);
+	txlen =3D get_unaligned_be32(&cdb[6]);
+
+	trace_seq_printf(p, "lba=3D%u txlen=3D%u protect=3D%u", lba, txlen,
 			 cdb[1] >> 5);
 	trace_seq_putc(p, 0);
=20
@@ -95,23 +87,13 @@ static const char *
 scsi_trace_rw16(struct trace_seq *p, unsigned char *cdb, int len)
 {
 	const char *ret =3D p->buffer + p->len;
-	sector_t lba =3D 0, txlen =3D 0;
-
-	lba |=3D ((u64)cdb[2] << 56);
-	lba |=3D ((u64)cdb[3] << 48);
-	lba |=3D ((u64)cdb[4] << 40);
-	lba |=3D ((u64)cdb[5] << 32);
-	lba |=3D (cdb[6] << 24);
-	lba |=3D (cdb[7] << 16);
-	lba |=3D (cdb[8] << 8);
-	lba |=3D  cdb[9];
-	txlen |=3D (cdb[10] << 24);
-	txlen |=3D (cdb[11] << 16);
-	txlen |=3D (cdb[12] << 8);
-	txlen |=3D  cdb[13];
-
-	trace_seq_printf(p, "lba=3D%llu txlen=3D%llu protect=3D%u",
-			 (unsigned long long)lba, (unsigned long long)txlen,
+	u64 lba;
+	u32 txlen;
+
+	lba =3D get_unaligned_be64(&cdb[2]);
+	txlen =3D get_unaligned_be32(&cdb[10]);
+
+	trace_seq_printf(p, "lba=3D%llu txlen=3D%u protect=3D%u", lba, txlen,
 			 cdb[1] >> 5);
=20
 	if (cdb[0] =3D=3D WRITE_SAME_16)
@@ -126,8 +108,8 @@ static const char *
 scsi_trace_rw32(struct trace_seq *p, unsigned char *cdb, int len)
 {
 	const char *ret =3D p->buffer + p->len, *cmd;
-	sector_t lba =3D 0, txlen =3D 0;
-	u32 ei_lbrt =3D 0;
+	u64 lba;
+	u32 ei_lbrt, txlen;
=20
 	switch (SERVICE_ACTION32(cdb)) {
 	case READ_32:
@@ -147,26 +129,12 @@ scsi_trace_rw32(struct trace_seq *p, unsigned char *c=
db, int len)
 		goto out;
 	}
=20
-	lba |=3D ((u64)cdb[12] << 56);
-	lba |=3D ((u64)cdb[13] << 48);
-	lba |=3D ((u64)cdb[14] << 40);
-	lba |=3D ((u64)cdb[15] << 32);
-	lba |=3D (cdb[16] << 24);
-	lba |=3D (cdb[17] << 16);
-	lba |=3D (cdb[18] << 8);
-	lba |=3D  cdb[19];
-	ei_lbrt |=3D (cdb[20] << 24);
-	ei_lbrt |=3D (cdb[21] << 16);
-	ei_lbrt |=3D (cdb[22] << 8);
-	ei_lbrt |=3D  cdb[23];
-	txlen |=3D (cdb[28] << 24);
-	txlen |=3D (cdb[29] << 16);
-	txlen |=3D (cdb[30] << 8);
-	txlen |=3D  cdb[31];
-
-	trace_seq_printf(p, "%s_32 lba=3D%llu txlen=3D%llu protect=3D%u ei_lbrt=
=3D%u",
-			 cmd, (unsigned long long)lba,
-			 (unsigned long long)txlen, cdb[10] >> 5, ei_lbrt);
+	lba =3D get_unaligned_be64(&cdb[12]);
+	ei_lbrt =3D get_unaligned_be32(&cdb[20]);
+	txlen =3D get_unaligned_be32(&cdb[28]);
+
+	trace_seq_printf(p, "%s_32 lba=3D%llu txlen=3D%u protect=3D%u ei_lbrt=3D%=
u",
+			 cmd, lba, txlen, cdb[10] >> 5, ei_lbrt);
=20
 	if (SERVICE_ACTION32(cdb) =3D=3D WRITE_SAME_32)
 		trace_seq_printf(p, " unmap=3D%u", cdb[10] >> 3 & 1);
@@ -181,7 +149,7 @@ static const char *
 scsi_trace_unmap(struct trace_seq *p, unsigned char *cdb, int len)
 {
 	const char *ret =3D p->buffer + p->len;
-	unsigned int regions =3D cdb[7] << 8 | cdb[8];
+	unsigned int regions =3D get_unaligned_be16(&cdb[7]);
=20
 	trace_seq_printf(p, "regions=3D%u", (regions - 8) / 16);
 	trace_seq_putc(p, 0);
@@ -193,8 +161,8 @@ static const char *
 scsi_trace_service_action_in(struct trace_seq *p, unsigned char *cdb, int =
len)
 {
 	const char *ret =3D p->buffer + p->len, *cmd;
-	sector_t lba =3D 0;
-	u32 alloc_len =3D 0;
+	u64 lba;
+	u32 alloc_len;
=20
 	switch (SERVICE_ACTION16(cdb)) {
 	case SAI_READ_CAPACITY_16:
@@ -208,21 +176,10 @@ scsi_trace_service_action_in(struct trace_seq *p, uns=
igned char *cdb, int len)
 		goto out;
 	}
=20
-	lba |=3D ((u64)cdb[2] << 56);
-	lba |=3D ((u64)cdb[3] << 48);
-	lba |=3D ((u64)cdb[4] << 40);
-	lba |=3D ((u64)cdb[5] << 32);
-	lba |=3D (cdb[6] << 24);
-	lba |=3D (cdb[7] << 16);
-	lba |=3D (cdb[8] << 8);
-	lba |=3D  cdb[9];
-	alloc_len |=3D (cdb[10] << 24);
-	alloc_len |=3D (cdb[11] << 16);
-	alloc_len |=3D (cdb[12] << 8);
-	alloc_len |=3D  cdb[13];
-
-	trace_seq_printf(p, "%s lba=3D%llu alloc_len=3D%u", cmd,
-			 (unsigned long long)lba, alloc_len);
+	lba =3D get_unaligned_be64(&cdb[2]);
+	alloc_len =3D get_unaligned_be32(&cdb[10]);
+
+	trace_seq_printf(p, "%s lba=3D%llu alloc_len=3D%u", cmd, lba, alloc_len);
=20
 out:
 	trace_seq_putc(p, 0);
diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index 27ebf096e703..f4890340d2b4 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -242,7 +242,6 @@ struct atmel_spi {
 	struct atmel_spi_dma	dma;
=20
 	bool			keep_cs;
-	bool			cs_active;
 };
=20
 /* Controller-specific per-slave state */
@@ -1190,11 +1189,9 @@ static int atmel_spi_one_transfer(struct spi_master =
*master,
 				 &msg->transfers)) {
 			as->keep_cs =3D true;
 		} else {
-			as->cs_active =3D !as->cs_active;
-			if (as->cs_active)
-				cs_activate(as, msg->spi);
-			else
-				cs_deactivate(as, msg->spi);
+			cs_deactivate(as, msg->spi);
+			udelay(10);
+			cs_activate(as, msg->spi);
 		}
 	}
=20
@@ -1217,7 +1214,6 @@ static int atmel_spi_transfer_one_message(struct spi_=
master *master,
 	atmel_spi_lock(as);
 	cs_activate(as, spi);
=20
-	as->cs_active =3D true;
 	as->keep_cs =3D false;
=20
 	msg->status =3D 0;
diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/bin=
der.c
index 6a06230a40e1..ba0b66f8c677 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -624,8 +624,7 @@ static int binder_update_page_range(struct binder_proc =
*proc, int allocate,
 	return 0;
=20
 free_range:
-	for (page_addr =3D end - PAGE_SIZE; page_addr >=3D start;
-	     page_addr -=3D PAGE_SIZE) {
+	for (page_addr =3D end - PAGE_SIZE; 1; page_addr -=3D PAGE_SIZE) {
 		page =3D &proc->pages[(page_addr - proc->buffer) / PAGE_SIZE];
 		if (vma)
 			zap_page_range(vma, (uintptr_t)page_addr +
@@ -636,7 +635,8 @@ static int binder_update_page_range(struct binder_proc =
*proc, int allocate,
 		__free_page(*page);
 		*page =3D NULL;
 err_alloc_page_failed:
-		;
+		if (page_addr =3D=3D start)
+			break;
 	}
 err_no_vma:
 	if (mm) {
diff --git a/drivers/staging/line6/pcm.c b/drivers/staging/line6/pcm.c
index 846d09940161..2c74df0b46b6 100644
--- a/drivers/staging/line6/pcm.c
+++ b/drivers/staging/line6/pcm.c
@@ -345,24 +345,21 @@ static void line6_cleanup_pcm(struct snd_pcm *pcm)
 			usb_free_urb(line6pcm->urb_audio_in[i]);
 		}
 	}
+	kfree(line6pcm);
 }
=20
 /* create a PCM device */
-static int snd_line6_new_pcm(struct snd_line6_pcm *line6pcm)
+static int snd_line6_new_pcm(struct usb_line6 *line6, struct snd_pcm **pcm=
_ret)
 {
 	struct snd_pcm *pcm;
 	int err;
=20
-	err =3D snd_pcm_new(line6pcm->line6->card,
-			  (char *)line6pcm->line6->properties->name,
-			  0, 1, 1, &pcm);
+	err =3D snd_pcm_new(line6->card, (char *)line6->properties->name,
+			  0, 1, 1, pcm_ret);
 	if (err < 0)
 		return err;
-
-	pcm->private_data =3D line6pcm;
-	pcm->private_free =3D line6_cleanup_pcm;
-	line6pcm->pcm =3D pcm;
-	strcpy(pcm->name, line6pcm->line6->properties->name);
+	pcm =3D *pcm_ret;
+	strcpy(pcm->name, line6->properties->name);
=20
 	/* set operators */
 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_PLAYBACK,
@@ -374,13 +371,6 @@ static int snd_line6_new_pcm(struct snd_line6_pcm *lin=
e6pcm)
 					      snd_dma_continuous_data
 					      (GFP_KERNEL), 64 * 1024,
 					      128 * 1024);
-
-	return 0;
-}
-
-/* PCM device destructor */
-static int snd_line6_pcm_free(struct snd_device *device)
-{
 	return 0;
 }
=20
@@ -416,12 +406,9 @@ void line6_pcm_disconnect(struct snd_line6_pcm *line6p=
cm)
 int line6_init_pcm(struct usb_line6 *line6,
 		   struct line6_pcm_properties *properties)
 {
-	static struct snd_device_ops pcm_ops =3D {
-		.dev_free =3D snd_line6_pcm_free,
-	};
-
 	int err;
 	int ep_read =3D 0, ep_write =3D 0;
+	struct snd_pcm *pcm;
 	struct snd_line6_pcm *line6pcm;
=20
 	if (!(line6->properties->capabilities & LINE6_BIT_PCM))
@@ -475,17 +462,31 @@ int line6_init_pcm(struct usb_line6 *line6,
 		MISSING_CASE;
 	}
=20
-	line6pcm =3D kzalloc(sizeof(*line6pcm), GFP_KERNEL);
+	err =3D snd_line6_new_pcm(line6, &pcm);
+	if (err < 0)
+		return err;
=20
-	if (line6pcm =3D=3D NULL)
+	line6pcm =3D kzalloc(sizeof(*line6pcm), GFP_KERNEL);
+	if (!line6pcm)
 		return -ENOMEM;
=20
+	line6pcm->pcm =3D pcm;
+	line6pcm->properties =3D properties;
 	line6pcm->volume_playback[0] =3D line6pcm->volume_playback[1] =3D 255;
 	line6pcm->volume_monitor =3D 255;
 	line6pcm->line6 =3D line6;
 	line6pcm->ep_audio_read =3D ep_read;
 	line6pcm->ep_audio_write =3D ep_write;
=20
+	spin_lock_init(&line6pcm->lock_audio_out);
+	spin_lock_init(&line6pcm->lock_audio_in);
+	spin_lock_init(&line6pcm->lock_trigger);
+
+	line6->line6pcm =3D line6pcm;
+
+	pcm->private_data =3D line6pcm;
+	pcm->private_free =3D line6_cleanup_pcm;
+
 	/* Read and write buffers are sized identically, so choose minimum */
 	line6pcm->max_packet_size =3D min(
 			usb_maxpacket(line6->usbdev,
@@ -498,22 +499,6 @@ int line6_init_pcm(struct usb_line6 *line6,
 		return -EINVAL;
 	}
=20
-	line6pcm->properties =3D properties;
-	line6->line6pcm =3D line6pcm;
-
-	/* PCM device: */
-	err =3D snd_device_new(line6->card, SNDRV_DEV_PCM, line6, &pcm_ops);
-	if (err < 0)
-		return err;
-
-	err =3D snd_line6_new_pcm(line6pcm);
-	if (err < 0)
-		return err;
-
-	spin_lock_init(&line6pcm->lock_audio_out);
-	spin_lock_init(&line6pcm->lock_audio_in);
-	spin_lock_init(&line6pcm->lock_trigger);
-
 	err =3D line6_create_audio_out_urbs(line6pcm);
 	if (err < 0)
 		return err;
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c b/drivers/staging=
/rtl8192e/rtl8192e/rtl_core.c
index 2920e406030a..0fac550b6dbd 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
@@ -1884,8 +1884,6 @@ void rtl8192_hard_data_xmit(struct sk_buff *skb, stru=
ct net_device *dev,
 	memcpy((unsigned char *)(skb->cb), &dev, sizeof(dev));
 	skb_push(skb, priv->rtllib->tx_headroom);
 	ret =3D rtl8192_tx(dev, skb);
-	if (ret !=3D 0)
-		kfree_skb(skb);
=20
 	if (queue_index !=3D MGNT_QUEUE) {
 		priv->rtllib->stats.tx_bytes +=3D (skb->len -
@@ -1893,6 +1891,9 @@ void rtl8192_hard_data_xmit(struct sk_buff *skb, stru=
ct net_device *dev,
 		priv->rtllib->stats.tx_packets++;
 	}
=20
+	if (ret !=3D 0)
+		kfree_skb(skb);
+
 	return;
 }
=20
diff --git a/drivers/tty/serial/ifx6x60.c b/drivers/tty/serial/ifx6x60.c
index fe958f415e85..0812b844eb9c 100644
--- a/drivers/tty/serial/ifx6x60.c
+++ b/drivers/tty/serial/ifx6x60.c
@@ -1242,6 +1242,9 @@ static int ifx_spi_spi_remove(struct spi_device *spi)
 	struct ifx_spi_device *ifx_dev =3D spi_get_drvdata(spi);
 	/* stop activity */
 	tasklet_kill(&ifx_dev->io_work_tasklet);
+
+	pm_runtime_disable(&spi->dev);
+
 	/* free irq */
 	free_irq(gpio_to_irq(ifx_dev->gpio.reset_out), (void *)ifx_dev);
 	free_irq(gpio_to_irq(ifx_dev->gpio.srdy), (void *)ifx_dev);
diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 21d8a5a02d05..ebfd878a448b 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -541,7 +541,7 @@ static void imx_dma_tx(struct imx_port *sport)
 		dev_err(dev, "DMA mapping error for TX.\n");
 		return;
 	}
-	desc =3D dmaengine_prep_slave_sg(chan, sgl, sport->dma_tx_nents,
+	desc =3D dmaengine_prep_slave_sg(chan, sgl, ret,
 					DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT);
 	if (!desc) {
 		dev_err(dev, "We cannot prepare for the TX slave dma!\n");
diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_seria=
l.c
index 6c938adae429..1c438396c630 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -316,6 +316,7 @@ static unsigned int msm_get_mctrl(struct uart_port *por=
t)
 static void msm_reset(struct uart_port *port)
 {
 	struct msm_port *msm_port =3D UART_TO_MSM(port);
+	unsigned int mr;
=20
 	/* reset everything */
 	msm_write(port, UART_CR_CMD_RESET_RX, UART_CR);
@@ -323,7 +324,10 @@ static void msm_reset(struct uart_port *port)
 	msm_write(port, UART_CR_CMD_RESET_ERR, UART_CR);
 	msm_write(port, UART_CR_CMD_RESET_BREAK_INT, UART_CR);
 	msm_write(port, UART_CR_CMD_RESET_CTS, UART_CR);
-	msm_write(port, UART_CR_CMD_SET_RFR, UART_CR);
+	msm_write(port, UART_CR_CMD_RESET_RFR, UART_CR);
+	mr =3D msm_read(port, UART_MR1);
+	mr &=3D ~UART_MR1_RX_RDY_CTL;
+	msm_write(port, mr, UART_MR1);
=20
 	/* Disable DM modes */
 	if (msm_port->is_uartdm)
diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 0cb6a8e52bd0..1d2e00b7a163 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -251,6 +251,7 @@ struct eg20t_port {
 	struct dma_chan			*chan_rx;
 	struct scatterlist		*sg_tx_p;
 	int				nent;
+	int				orig_nent;
 	struct scatterlist		sg_rx;
 	int				tx_dma_use;
 	void				*rx_buf_virt;
@@ -803,9 +804,10 @@ static void pch_dma_tx_complete(void *arg)
 	}
 	xmit->tail &=3D UART_XMIT_SIZE - 1;
 	async_tx_ack(priv->desc_tx);
-	dma_unmap_sg(port->dev, sg, priv->nent, DMA_TO_DEVICE);
+	dma_unmap_sg(port->dev, sg, priv->orig_nent, DMA_TO_DEVICE);
 	priv->tx_dma_use =3D 0;
 	priv->nent =3D 0;
+	priv->orig_nent =3D 0;
 	kfree(priv->sg_tx_p);
 	pch_uart_hal_enable_interrupt(priv, PCH_UART_HAL_TX_INT);
 }
@@ -1030,6 +1032,7 @@ static unsigned int dma_handle_tx(struct eg20t_port *=
priv)
 		dev_err(priv->port.dev, "%s:dma_map_sg Failed\n", __func__);
 		return 0;
 	}
+	priv->orig_nent =3D num;
 	priv->nent =3D nent;
=20
 	for (i =3D 0; i < nent; i++, sg++) {
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_c=
ore.c
index 493a7af9696f..6b71032b8123 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1013,7 +1013,7 @@ static int uart_break_ctl(struct tty_struct *tty, int=
 break_state)
=20
 	mutex_lock(&port->mutex);
=20
-	if (uport->type !=3D PORT_UNKNOWN)
+	if (uport->type !=3D PORT_UNKNOWN && uport->ops->break_ctl)
 		uport->ops->break_ctl(uport, break_state);
=20
 	mutex_unlock(&port->mutex);
diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index 4e3722d1906f..586fc6600484 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -1358,7 +1358,7 @@ static void kbd_event(struct input_handle *handle, un=
signed int event_type,
=20
 	if (event_type =3D=3D EV_MSC && event_code =3D=3D MSC_RAW && HW_RAW(handl=
e->dev))
 		kbd_rawcode(value);
-	if (event_type =3D=3D EV_KEY)
+	if (event_type =3D=3D EV_KEY && event_code <=3D KEY_MAX)
 		kbd_keycode(event_code, value, HW_RAW(handle->dev));
=20
 	spin_unlock(&kbd_event_lock);
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index cec7a62b4028..2e9e0012286b 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -5535,7 +5535,7 @@ static int usb_reset_and_verify_device(struct usb_dev=
ice *udev)
=20
 /**
  * usb_reset_device - warn interface drivers and perform a USB port reset
- * @udev: device to reset (not in SUSPENDED or NOTATTACHED state)
+ * @udev: device to reset (not in NOTATTACHED state)
  *
  * Warns all drivers bound to registered interfaces (using their pre_reset
  * method), performs the port reset, and then lets the drivers know that
@@ -5563,8 +5563,7 @@ int usb_reset_device(struct usb_device *udev)
 	struct usb_host_config *config =3D udev->actconfig;
 	struct usb_hub *hub =3D usb_hub_to_struct_hub(udev->parent);
=20
-	if (udev->state =3D=3D USB_STATE_NOTATTACHED ||
-			udev->state =3D=3D USB_STATE_SUSPENDED) {
+	if (udev->state =3D=3D USB_STATE_NOTATTACHED) {
 		dev_dbg(&udev->dev, "device reset not allowed in state %d\n",
 				udev->state);
 		return -EINVAL;
diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
index 460d953c91b6..0ca28a1a7fd6 100644
--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -1533,7 +1533,6 @@ static void pch_udc_free_dma_chain(struct pch_udc_dev=
 *dev,
 		td =3D phys_to_virt(addr);
 		addr2 =3D (dma_addr_t)td->next;
 		pci_pool_free(dev->data_requests, td, addr);
-		td->next =3D 0x00;
 		addr =3D addr2;
 	}
 	req->chain_len =3D 1;
diff --git a/drivers/usb/gadget/u_serial.c b/drivers/usb/gadget/u_serial.c
index 771d3d8ffaa3..0ac766962557 100644
--- a/drivers/usb/gadget/u_serial.c
+++ b/drivers/usb/gadget/u_serial.c
@@ -1140,8 +1140,10 @@ int gserial_alloc_line(unsigned char *line_num)
 				__func__, port_num, PTR_ERR(tty_dev));
=20
 		ret =3D PTR_ERR(tty_dev);
+		mutex_lock(&ports[port_num].lock);
 		port =3D ports[port_num].port;
 		ports[port_num].port =3D NULL;
+		mutex_unlock(&ports[port_num].lock);
 		gserial_free_port(port);
 		goto err;
 	}
diff --git a/drivers/usb/misc/appledisplay.c b/drivers/usb/misc/appledispla=
y.c
index a1648fe0937e..eb9b60ea02a3 100644
--- a/drivers/usb/misc/appledisplay.c
+++ b/drivers/usb/misc/appledisplay.c
@@ -180,7 +180,12 @@ static int appledisplay_bl_get_brightness(struct backl=
ight_device *bd)
 		0,
 		pdata->msgdata, 2,
 		ACD_USB_TIMEOUT);
-	brightness =3D pdata->msgdata[1];
+	if (retval < 2) {
+		if (retval >=3D 0)
+			retval =3D -EMSGSIZE;
+	} else {
+		brightness =3D pdata->msgdata[1];
+	}
 	mutex_unlock(&pdata->sysfslock);
=20
 	if (retval < 0)
@@ -326,6 +331,7 @@ static int appledisplay_probe(struct usb_interface *ifa=
ce,
 	if (pdata) {
 		if (pdata->urb) {
 			usb_kill_urb(pdata->urb);
+			cancel_delayed_work_sync(&pdata->work);
 			if (pdata->urbdata)
 				usb_free_coherent(pdata->udev, ACD_URB_BUFFER_LEN,
 					pdata->urbdata, pdata->urb->transfer_dma);
diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 3e22dd294879..c371d4c59efa 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -121,6 +121,7 @@ static const struct usb_device_id id_table[] =3D {
 	{ USB_DEVICE(0x10C4, 0x8341) }, /* Siemens MC35PU GPRS Modem */
 	{ USB_DEVICE(0x10C4, 0x8382) }, /* Cygnal Integrated Products, Inc. */
 	{ USB_DEVICE(0x10C4, 0x83A8) }, /* Amber Wireless AMB2560 */
+	{ USB_DEVICE(0x10C4, 0x83AA) }, /* Mark-10 Digital Force Gauge */
 	{ USB_DEVICE(0x10C4, 0x83D8) }, /* DekTec DTA Plus VHF/UHF Booster/Attenu=
ator */
 	{ USB_DEVICE(0x10C4, 0x8411) }, /* Kyocera GPS Module */
 	{ USB_DEVICE(0x10C4, 0x8418) }, /* IRZ Automation Teleport SG-10 GSM/GPRS=
 Modem */
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index d5d33bf5188f..a39e2307b09f 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1041,6 +1041,9 @@ static const struct usb_device_id id_table_combined[]=
 =3D {
 	/* Sienna devices */
 	{ USB_DEVICE(FTDI_VID, FTDI_SIENNA_PID) },
 	{ USB_DEVICE(ECHELON_VID, ECHELON_U20_PID) },
+	/* U-Blox devices */
+	{ USB_DEVICE(UBLOX_VID, UBLOX_C099F9P_ZED_PID) },
+	{ USB_DEVICE(UBLOX_VID, UBLOX_C099F9P_ODIN_PID) },
 	{ }					/* Terminating entry */
 };
=20
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_si=
o_ids.h
index 655672d1be6f..6c2f53e2a46a 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1557,3 +1557,10 @@
  */
 #define UNJO_VID			0x22B7
 #define UNJO_ISODEBUG_V1_PID		0x150D
+
+/*
+ * U-Blox products (http://www.u-blox.com).
+ */
+#define UBLOX_VID			0x1546
+#define UBLOX_C099F9P_ZED_PID		0x0502
+#define UBLOX_C099F9P_ODIN_PID		0x0503
diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index 454898c4a137..5963e2c11354 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -1917,10 +1917,6 @@ static int mos7720_startup(struct usb_serial *serial)
 		}
 	}
=20
-	/* setting configuration feature to one */
-	usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-			(__u8)0x03, 0x00, 0x01, 0x00, NULL, 0x00, 5000);
-
 #ifdef CONFIG_USB_SERIAL_MOS7715_PARPORT
 	if (product =3D=3D MOSCHIP_DEVICE_ID_7715) {
 		ret_val =3D mos7715_parport_init(serial);
diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index b269c3727172..c5c827211d22 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -131,11 +131,15 @@
 /* This driver also supports
  * ATEN UC2324 device using Moschip MCS7840
  * ATEN UC2322 device using Moschip MCS7820
+ * MOXA UPort 2210 device using Moschip MCS7820
  */
 #define USB_VENDOR_ID_ATENINTL		0x0557
 #define ATENINTL_DEVICE_ID_UC2324	0x2011
 #define ATENINTL_DEVICE_ID_UC2322	0x7820
=20
+#define USB_VENDOR_ID_MOXA		0x110a
+#define MOXA_DEVICE_ID_2210		0x2210
+
 /* Interrupt Routine Defines    */
=20
 #define SERIAL_IIR_RLS      0x06
@@ -206,6 +210,7 @@ static const struct usb_device_id id_table[] =3D {
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL2_4)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2324)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2322)},
+	{USB_DEVICE(USB_VENDOR_ID_MOXA, MOXA_DEVICE_ID_2210)},
 	{}			/* terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, id_table);
@@ -2139,6 +2144,7 @@ static int mos7840_probe(struct usb_serial *serial,
 				const struct usb_device_id *id)
 {
 	u16 product =3D le16_to_cpu(serial->dev->descriptor.idProduct);
+	u16 vid =3D le16_to_cpu(serial->dev->descriptor.idVendor);
 	u8 *buf;
 	int device_type;
=20
@@ -2148,6 +2154,11 @@ static int mos7840_probe(struct usb_serial *serial,
 		goto out;
 	}
=20
+	if (vid =3D=3D USB_VENDOR_ID_MOXA && product =3D=3D MOXA_DEVICE_ID_2210) {
+		device_type =3D MOSCHIP_DEVICE_ID_7820;
+		goto out;
+	}
+
 	buf =3D kzalloc(VENDOR_READ_LENGTH, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
@@ -2403,11 +2414,6 @@ static int mos7840_port_probe(struct usb_serial_port=
 *port)
 			goto error;
 		} else
 			dev_dbg(&port->dev, "ZLP_REG5 Writing success status%d\n", status);
-
-		/* setting configuration feature to one */
-		usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-				0x03, 0x00, 0x01, 0x00, NULL, 0x00,
-				MOS_WDR_TIMEOUT);
 	}
 	return 0;
 error:
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index bdd3fc01e6c3..6d616e9885ed 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -991,6 +991,10 @@ static int uas_slave_configure(struct scsi_device *sde=
v)
 	if (devinfo->flags & US_FL_BROKEN_FUA)
 		sdev->broken_fua =3D 1;
=20
+	/* Some disks cannot handle READ_CAPACITY_16 */
+	if (devinfo->flags & US_FL_NO_READ_CAPACITY_16)
+		sdev->no_read_capacity_16 =3D 1;
+
 	/*
 	 * Some disks return the total number of blocks in response
 	 * to READ CAPACITY rather than the highest block number.
@@ -999,6 +1003,12 @@ static int uas_slave_configure(struct scsi_device *sd=
ev)
 	if (devinfo->flags & US_FL_FIX_CAPACITY)
 		sdev->fix_capacity =3D 1;
=20
+	/*
+	 * in some cases we have to guess
+	 */
+	if (devinfo->flags & US_FL_CAPACITY_HEURISTICS)
+		sdev->guess_capacity =3D 1;
+
 	/*
 	 * Some devices don't like MODE SENSE with page=3D0x3f,
 	 * which is the command used for checking if a device
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 49f1868450b9..b5812913fe99 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1540,6 +1540,7 @@ static noinline ssize_t __btrfs_buffered_write(struct=
 file *file,
 			break;
 		}
=20
+		only_release_metadata =3D false;
 		reserve_bytes =3D num_pages << PAGE_CACHE_SHIFT;
 		ret =3D btrfs_check_data_free_space(inode, reserve_bytes);
 		if (ret =3D=3D -ENOSPC &&
@@ -1671,7 +1672,6 @@ static noinline ssize_t __btrfs_buffered_write(struct=
 file *file,
 			set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
 				       lockend, EXTENT_NORESERVE, NULL,
 				       NULL, GFP_NOFS);
-			only_release_metadata =3D false;
 		}
=20
 		btrfs_drop_pages(pages, num_pages);
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index be5f24c860d0..49c7c5344a0a 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -360,6 +360,12 @@ static int io_ctl_prepare_pages(struct io_ctl *io_ctl,=
 struct inode *inode,
 		if (uptodate && !PageUptodate(page)) {
 			btrfs_readpage(NULL, page);
 			lock_page(page);
+			if (page->mapping !=3D inode->i_mapping) {
+				btrfs_err(BTRFS_I(inode)->root->fs_info,
+					  "free space cache page truncated");
+				io_ctl_drop_pages(io_ctl);
+				return -EIO;
+			}
 			if (!PageUptodate(page)) {
 				btrfs_err(BTRFS_I(inode)->root->fs_info,
 					   "error reading free space cache");
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index a13450937bce..2882ebeff95b 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1113,6 +1113,11 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file=
);
 struct cifsInodeInfo {
 	bool can_cache_brlcks;
 	struct list_head llist;	/* locks helb by this inode */
+	/*
+	 * NOTE: Some code paths call down_read(lock_sem) twice, so
+	 * we must always use use cifs_down_write() instead of down_write()
+	 * for this semaphore to avoid deadlocks.
+	 */
 	struct rw_semaphore lock_sem;	/* protect the fields above */
 	/* BB add in lists for dirty pages i.e. write caching info for oplock */
 	struct list_head openFileList;
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index b8d81a86404c..9acd4cbcc658 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -137,6 +137,7 @@ extern int cifs_unlock_range(struct cifsFileInfo *cfile,
 			     struct file_lock *flock, const unsigned int xid);
 extern int cifs_push_mandatory_locks(struct cifsFileInfo *cfile);
=20
+extern void cifs_down_write(struct rw_semaphore *sem);
 extern struct cifsFileInfo *cifs_new_fileinfo(struct cifs_fid *fid,
 					      struct file *file,
 					      struct tcon_link *tlink,
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 038a810418d8..fc42214fe231 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -281,6 +281,13 @@ cifs_has_mand_locks(struct cifsInodeInfo *cinode)
 	return has_locks;
 }
=20
+void
+cifs_down_write(struct rw_semaphore *sem)
+{
+	while (!down_write_trylock(sem))
+		msleep(10);
+}
+
 struct cifsFileInfo *
 cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 		  struct tcon_link *tlink, __u32 oplock)
@@ -306,9 +313,6 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file *fi=
le,
 	INIT_LIST_HEAD(&fdlocks->locks);
 	fdlocks->cfile =3D cfile;
 	cfile->llist =3D fdlocks;
-	down_write(&cinode->lock_sem);
-	list_add(&fdlocks->llist, &cinode->llist);
-	up_write(&cinode->lock_sem);
=20
 	cfile->count =3D 1;
 	cfile->pid =3D current->tgid;
@@ -332,6 +336,10 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file *f=
ile,
 		oplock =3D 0;
 	}
=20
+	cifs_down_write(&cinode->lock_sem);
+	list_add(&fdlocks->llist, &cinode->llist);
+	up_write(&cinode->lock_sem);
+
 	spin_lock(&tcon->open_file_lock);
 	if (fid->pending_open->oplock !=3D CIFS_OPLOCK_NO_CHANGE && oplock)
 		oplock =3D fid->pending_open->oplock;
@@ -462,7 +470,7 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_file, =
bool wait_oplock_handler)
 	 * Delete any outstanding lock records. We'll lose them when the file
 	 * is closed anyway.
 	 */
-	down_write(&cifsi->lock_sem);
+	cifs_down_write(&cifsi->lock_sem);
 	list_for_each_entry_safe(li, tmp, &cifs_file->llist->locks, llist) {
 		list_del(&li->llist);
 		cifs_del_lock_waiters(li);
@@ -711,6 +719,13 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_=
flush)
 	if (backup_cred(cifs_sb))
 		create_options |=3D CREATE_OPEN_BACKUP_INTENT;
=20
+	/* O_SYNC also has bit for O_DSYNC so following check picks up either */
+	if (cfile->f_flags & O_SYNC)
+		create_options |=3D CREATE_WRITE_THROUGH;
+
+	if (cfile->f_flags & O_DIRECT)
+		create_options |=3D CREATE_NO_BUFFER;
+
 	if (server->ops->get_lease_key)
 		server->ops->get_lease_key(inode, &cfile->fid);
=20
@@ -963,7 +978,7 @@ static void
 cifs_lock_add(struct cifsFileInfo *cfile, struct cifsLockInfo *lock)
 {
 	struct cifsInodeInfo *cinode =3D CIFS_I(cfile->dentry->d_inode);
-	down_write(&cinode->lock_sem);
+	cifs_down_write(&cinode->lock_sem);
 	list_add_tail(&lock->llist, &cfile->llist->locks);
 	up_write(&cinode->lock_sem);
 }
@@ -985,7 +1000,7 @@ cifs_lock_add_if(struct cifsFileInfo *cfile, struct ci=
fsLockInfo *lock,
=20
 try_again:
 	exist =3D false;
-	down_write(&cinode->lock_sem);
+	cifs_down_write(&cinode->lock_sem);
=20
 	exist =3D cifs_find_lock_conflict(cfile, lock->offset, lock->length,
 					lock->type, &conf_lock, CIFS_LOCK_OP);
@@ -1007,7 +1022,7 @@ cifs_lock_add_if(struct cifsFileInfo *cfile, struct c=
ifsLockInfo *lock,
 					(lock->blist.next =3D=3D &lock->blist));
 		if (!rc)
 			goto try_again;
-		down_write(&cinode->lock_sem);
+		cifs_down_write(&cinode->lock_sem);
 		list_del_init(&lock->blist);
 	}
=20
@@ -1060,7 +1075,7 @@ cifs_posix_lock_set(struct file *file, struct file_lo=
ck *flock)
 		return rc;
=20
 try_again:
-	down_write(&cinode->lock_sem);
+	cifs_down_write(&cinode->lock_sem);
 	if (!cinode->can_cache_brlcks) {
 		up_write(&cinode->lock_sem);
 		return rc;
@@ -1260,7 +1275,7 @@ cifs_push_locks(struct cifsFileInfo *cfile)
 	int rc =3D 0;
=20
 	/* we are going to update can_cache_brlcks here - need a write access */
-	down_write(&cinode->lock_sem);
+	cifs_down_write(&cinode->lock_sem);
 	if (!cinode->can_cache_brlcks) {
 		up_write(&cinode->lock_sem);
 		return rc;
@@ -1444,7 +1459,7 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct =
file_lock *flock,
 	if (!buf)
 		return -ENOMEM;
=20
-	down_write(&cinode->lock_sem);
+	cifs_down_write(&cinode->lock_sem);
 	for (i =3D 0; i < 2; i++) {
 		cur =3D buf;
 		num =3D 0;
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 179a50218995..633517012c26 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -114,7 +114,7 @@ smb2_unlock_range(struct cifsFileInfo *cfile, struct fi=
le_lock *flock,
=20
 	cur =3D buf;
=20
-	down_write(&cinode->lock_sem);
+	cifs_down_write(&cinode->lock_sem);
 	list_for_each_entry_safe(li, tmp, &cfile->llist->locks, llist) {
 		if (flock->fl_start > li->offset ||
 		    (flock->fl_start + length) <
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index f80fcc6921ee..8e523a7a90fb 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -563,10 +563,10 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_S=
erver_Info *server)
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each(tmp, &server->smb_ses_list) {
 		ses =3D list_entry(tmp, struct cifs_ses, smb_ses_list);
+
 		list_for_each(tmp1, &ses->tcon_list) {
 			tcon =3D list_entry(tmp1, struct cifs_tcon, tcon_list);
=20
-			cifs_stats_inc(&tcon->stats.cifs_stats.num_oplock_brks);
 			spin_lock(&tcon->open_file_lock);
 			list_for_each(tmp2, &tcon->openFileList) {
 				cfile =3D list_entry(tmp2, struct cifsFileInfo,
@@ -578,6 +578,8 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Ser=
ver_Info *server)
 					continue;
=20
 				cifs_dbg(FYI, "file id match, oplock break\n");
+				cifs_stats_inc(
+				    &tcon->stats.cifs_stats.num_oplock_brks);
 				cinode =3D CIFS_I(cfile->dentry->d_inode);
 				spin_lock(&cfile->file_info_lock);
 				if (!CIFS_CACHE_WRITE(cinode) &&
@@ -610,9 +612,6 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Ser=
ver_Info *server)
 				return true;
 			}
 			spin_unlock(&tcon->open_file_lock);
-			spin_unlock(&cifs_tcp_ses_lock);
-			cifs_dbg(FYI, "No matching file for oplock break\n");
-			return true;
 		}
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 829fb1e01898..6601489e614c 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -696,11 +696,14 @@ static int ext2_get_blocks(struct inode *inode,
 		if (!partial) {
 			count++;
 			mutex_unlock(&ei->truncate_mutex);
-			if (err)
-				goto cleanup;
 			clear_buffer_new(bh_result);
 			goto got_it;
 		}
+
+		if (err) {
+			mutex_unlock(&ei->truncate_mutex);
+			goto cleanup;
+		}
 	}
=20
 	/*
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 9e1760f8bf1d..67f936dcbc69 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2830,19 +2830,18 @@ static int ext4_unlink(struct inode *dir, struct de=
ntry *dentry)
 	if (IS_DIRSYNC(dir))
 		ext4_handle_sync(handle);
=20
-	if (!inode->i_nlink) {
-		ext4_warning(inode->i_sb,
-			     "Deleting nonexistent file (%lu), %d",
-			     inode->i_ino, inode->i_nlink);
-		set_nlink(inode, 1);
-	}
 	retval =3D ext4_delete_entry(handle, dir, de, bh);
 	if (retval)
 		goto end_unlink;
 	dir->i_ctime =3D dir->i_mtime =3D ext4_current_time(dir);
 	ext4_update_dx_flag(dir);
 	ext4_mark_inode_dirty(handle, dir);
-	drop_nlink(inode);
+	if (inode->i_nlink =3D=3D 0)
+		ext4_warning(inode->i_sb,
+			     "Deleting nonexistent file (%lu), %d",
+			     inode->i_ino, inode->i_nlink);
+	else
+		drop_nlink(inode);
 	if (!inode->i_nlink)
 		ext4_orphan_add(handle, inode);
 	inode->i_ctime =3D ext4_current_time(inode);
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 64dbc1bab865..2f9f078b4a02 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -250,7 +250,8 @@ static int fuse_dentry_revalidate(struct dentry *entry,=
 unsigned int flags)
 			spin_unlock(&fc->lock);
 		}
 		kfree(forget);
-		if (err || (outarg.attr.mode ^ inode->i_mode) & S_IFMT)
+		if (err || fuse_invalid_attr(&outarg.attr) ||
+		    (outarg.attr.mode ^ inode->i_mode) & S_IFMT)
 			goto invalid;
=20
 		fuse_change_attributes(inode, &outarg.attr,
@@ -295,6 +296,12 @@ int fuse_valid_type(int m)
 		S_ISBLK(m) || S_ISFIFO(m) || S_ISSOCK(m);
 }
=20
+bool fuse_invalid_attr(struct fuse_attr *attr)
+{
+	return !fuse_valid_type(attr->mode) ||
+		attr->size > LLONG_MAX;
+}
+
 int fuse_lookup_name(struct super_block *sb, u64 nodeid, struct qstr *name,
 		     struct fuse_entry_out *outarg, struct inode **inode)
 {
@@ -334,7 +341,7 @@ int fuse_lookup_name(struct super_block *sb, u64 nodeid=
, struct qstr *name,
 	err =3D -EIO;
 	if (!outarg->nodeid)
 		goto out_put_forget;
-	if (!fuse_valid_type(outarg->attr.mode))
+	if (fuse_invalid_attr(&outarg->attr))
 		goto out_put_forget;
=20
 	*inode =3D fuse_iget(sb, outarg->nodeid, outarg->generation,
@@ -464,7 +471,8 @@ static int fuse_create_open(struct inode *dir, struct d=
entry *entry,
 		goto out_free_ff;
=20
 	err =3D -EIO;
-	if (!S_ISREG(outentry.attr.mode) || invalid_nodeid(outentry.nodeid))
+	if (!S_ISREG(outentry.attr.mode) || invalid_nodeid(outentry.nodeid) ||
+	    fuse_invalid_attr(&outentry.attr))
 		goto out_free_ff;
=20
 	fuse_put_request(fc, req);
@@ -580,7 +588,7 @@ static int create_new_entry(struct fuse_conn *fc, struc=
t fuse_req *req,
 		goto out_put_forget_req;
=20
 	err =3D -EIO;
-	if (invalid_nodeid(outarg.nodeid))
+	if (invalid_nodeid(outarg.nodeid) || fuse_invalid_attr(&outarg.attr))
 		goto out_put_forget_req;
=20
 	if ((outarg.attr.mode ^ mode) & S_IFMT)
@@ -882,7 +890,8 @@ static int fuse_link(struct dentry *entry, struct inode=
 *newdir,
=20
 		spin_lock(&fc->lock);
 		fi->attr_version =3D ++fc->attr_version;
-		inc_nlink(inode);
+		if (likely(inode->i_nlink < UINT_MAX))
+			inc_nlink(inode);
 		spin_unlock(&fc->lock);
 		fuse_invalidate_attr(inode);
 		fuse_update_ctime(inode);
@@ -971,7 +980,8 @@ static int fuse_do_getattr(struct inode *inode, struct =
kstat *stat,
 	err =3D req->out.h.error;
 	fuse_put_request(fc, req);
 	if (!err) {
-		if ((inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
+		if (fuse_invalid_attr(&outarg.attr) ||
+		    (inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
 			make_bad_inode(inode);
 			err =3D -EIO;
 		} else {
@@ -1282,7 +1292,7 @@ static int fuse_direntplus_link(struct file *file,
=20
 	if (invalid_nodeid(o->nodeid))
 		return -EIO;
-	if (!fuse_valid_type(o->attr.mode))
+	if (fuse_invalid_attr(&o->attr))
 		return -EIO;
=20
 	fc =3D get_fuse_conn(dir);
@@ -1794,7 +1804,8 @@ int fuse_do_setattr(struct dentry *dentry, struct iat=
tr *attr,
 		goto error;
 	}
=20
-	if ((inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
+	if (fuse_invalid_attr(&outarg.attr) ||
+	    (inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
 		make_bad_inode(inode);
 		err =3D -EIO;
 		goto error;
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 66019e05e3ad..c3adafd593c4 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -828,6 +828,8 @@ void fuse_ctl_remove_conn(struct fuse_conn *fc);
  */
 int fuse_valid_type(int m);
=20
+bool fuse_invalid_attr(struct fuse_attr *attr);
+
 /**
  * Is current process allowed to perform filesystem operation?
  */
diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index b990a62cff50..5524b5bad5ba 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -714,7 +714,7 @@ static int ocfs2_release_dquot(struct dquot *dquot)
=20
 	mutex_lock(&dquot->dq_lock);
 	/* Check whether we are not racing with some other dqget() */
-	if (atomic_read(&dquot->dq_count) > 1)
+	if (dquot_is_busy(dquot))
 		goto out;
 	/* Running from downconvert thread? Postpone quota processing to wq */
 	if (current =3D=3D osb->dc_task) {
diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index a467edd1a363..b0d07e3547b0 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -273,6 +273,17 @@ static int notrace ramoops_pstore_write_buf(enum pstor=
e_type_id type,
=20
 	prz =3D cxt->przs[cxt->dump_write_cnt];
=20
+	/*
+	 * Since this is a new crash dump, we need to reset the buffer in
+	 * case it still has an old dump present. Without this, the new dump
+	 * will get appended, which would seriously confuse anything trying
+	 * to check dump file contents. Specifically, ramoops_read_kmsg_hdr()
+	 * expects to find a dump header in the beginning of buffer data, so
+	 * we must to reset the buffer values, in order to ensure that the
+	 * header will be written to the beginning of the buffer.
+	 */
+	persistent_ram_zap(prz);
+
 	hlen =3D ramoops_write_kmsg_hdr(prz, compressed);
 	if (size + hlen > prz->buffer_size)
 		size =3D prz->buffer_size - hlen;
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 8ec56dbacaba..d7b1bb967c17 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -475,7 +475,7 @@ int dquot_release(struct dquot *dquot)
=20
 	mutex_lock(&dquot->dq_lock);
 	/* Check whether we are not racing with some other dqget() */
-	if (atomic_read(&dquot->dq_count) > 1)
+	if (dquot_is_busy(dquot))
 		goto out_dqlock;
 	mutex_lock(&dqopt->dqio_mutex);
 	if (dqopt->ops[dquot->dq_id.type]->release_dqblk) {
@@ -607,7 +607,7 @@ EXPORT_SYMBOL(dquot_scan_active);
 /* Write all dquot structures to quota files */
 int dquot_writeback_dquots(struct super_block *sb, int type)
 {
-	struct list_head *dirty;
+	struct list_head dirty;
 	struct dquot *dquot;
 	struct quota_info *dqopt =3D sb_dqopt(sb);
 	int cnt;
@@ -620,9 +620,10 @@ int dquot_writeback_dquots(struct super_block *sb, int=
 type)
 		if (!sb_has_quota_active(sb, cnt))
 			continue;
 		spin_lock(&dq_list_lock);
-		dirty =3D &dqopt->info[cnt].dqi_dirty_list;
-		while (!list_empty(dirty)) {
-			dquot =3D list_first_entry(dirty, struct dquot,
+		/* Move list away to avoid livelock. */
+		list_replace_init(&dqopt->info[cnt].dqi_dirty_list, &dirty);
+		while (!list_empty(&dirty)) {
+			dquot =3D list_first_entry(&dirty, struct dquot,
 						 dq_dirty);
 			/* Dirty and inactive can be only bad dquot... */
 			if (!test_bit(DQ_ACTIVE_B, &dquot->dq_flags)) {
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index ece0f31320ce..4f87841b0eb4 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -119,6 +119,9 @@ xfs_fs_rm_xquota(
 	if (XFS_IS_QUOTA_ON(mp))
 		return -EINVAL;
=20
+	if (uflags & ~(FS_USER_QUOTA | FS_GROUP_QUOTA | FS_PROJ_QUOTA))
+		return -EINVAL;
+
 	if (uflags & FS_USER_QUOTA)
 		flags |=3D XFS_DQ_USER;
 	if (uflags & FS_GROUP_QUOTA)
diff --git a/include/linux/futex.h b/include/linux/futex.h
index 6435f46d6e13..83fe0d85f8db 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -11,8 +11,13 @@ union ktime;
 long do_futex(u32 __user *uaddr, int op, u32 val, union ktime *timeout,
 	      u32 __user *uaddr2, u32 val2, u32 val3);
=20
+/* Constants for the pending_op argument of handle_futex_death */
+#define HANDLE_DEATH_PENDING	true
+#define HANDLE_DEATH_LIST	false
+
 extern int
-handle_futex_death(u32 __user *uaddr, struct task_struct *curr, int pi);
+handle_futex_death(u32 __user *uaddr, struct task_struct *curr,
+		   bool pi, bool pending_op);
=20
 /*
  * Futexes are matched on equal values of this key.
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index bb4ffff31c69..5306bac6aee4 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -137,7 +137,6 @@ struct hrtimer_sleeper {
  *			timer to a base on another cpu.
  * @clockid:		clock id for per_cpu support
  * @active:		red black tree root node for the active timers
- * @resolution:		the resolution of the clock, in nanoseconds
  * @get_time:		function to retrieve the current time of the clock
  * @softirq_time:	the time when running the hrtimer queue in the softirq
  * @offset:		offset of this clock to the monotonic base
@@ -147,7 +146,6 @@ struct hrtimer_clock_base {
 	int			index;
 	clockid_t		clockid;
 	struct timerqueue_head	active;
-	ktime_t			resolution;
 	ktime_t			(*get_time)(void);
 	ktime_t			softirq_time;
 	ktime_t			offset;
@@ -293,11 +291,15 @@ extern void hrtimer_peek_ahead_timers(void);
=20
 extern void clock_was_set_delayed(void);
=20
+extern unsigned int hrtimer_resolution;
+
 #else
=20
 # define MONOTONIC_RES_NSEC	LOW_RES_NSEC
 # define KTIME_MONOTONIC_RES	KTIME_LOW_RES
=20
+#define hrtimer_resolution	LOW_RES_NSEC
+
 static inline void hrtimer_peek_ahead_timers(void) { }
=20
 /*
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index e137e962834b..361f21cbc344 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1340,7 +1340,7 @@ static inline int jbd2_space_needed(journal_t *journa=
l)
 static inline unsigned long jbd2_log_space_left(journal_t *journal)
 {
 	/* Allow for rounding errors */
-	unsigned long free =3D journal->j_free - 32;
+	long free =3D journal->j_free - 32;
=20
 	if (journal->j_committing_transaction) {
 		unsigned long committing =3D atomic_read(&journal->
@@ -1349,7 +1349,7 @@ static inline unsigned long jbd2_log_space_left(journ=
al_t *journal)
 		/* Transaction + control blocks */
 		free -=3D committing + (committing >> JBD2_CONTROL_BLOCKS_SHIFT);
 	}
-	return free;
+	return max_t(long, free, 0);
 }
=20
 /*
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5d74c847efec..6fac5b8a42c2 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1345,6 +1345,11 @@ struct net_device {
 	unsigned char		if_port;	/* Selectable AUI, TP,..*/
 	unsigned char		dma;		/* DMA channel		*/
=20
+	/* Note : dev->mtu is often read without holding a lock.
+	 * Writers usually hold RTNL.
+	 * It is recommended to use ACCESS_ONCE() to annotate the reads
+	 * and writes.
+	 */
 	unsigned int		mtu;	/* interface MTU value		*/
 	unsigned short		type;	/* interface hardware type	*/
 	unsigned short		hard_header_len;	/* hardware hdr length	*/
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index bfaf7138d5ee..c2c41f6a65e2 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -54,6 +54,16 @@ static inline struct dquot *dqgrab(struct dquot *dquot)
 	atomic_inc(&dquot->dq_count);
 	return dquot;
 }
+
+static inline bool dquot_is_busy(struct dquot *dquot)
+{
+	if (test_bit(DQ_MOD_B, &dquot->dq_flags))
+		return true;
+	if (atomic_read(&dquot->dq_count) > 1)
+		return true;
+	return false;
+}
+
 void dqput(struct dquot *dquot);
 int dquot_scan_active(struct super_block *sb,
 		      int (*fn)(struct dquot *dquot, unsigned long priv),
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8=
500.h
index 75307447cef9..94629517ac69 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -38,14 +38,11 @@ enum ab8505_regulator_id {
 	AB8505_LDO_AUX6,
 	AB8505_LDO_INTCORE,
 	AB8505_LDO_ADC,
-	AB8505_LDO_USB,
 	AB8505_LDO_AUDIO,
 	AB8505_LDO_ANAMIC1,
 	AB8505_LDO_ANAMIC2,
 	AB8505_LDO_AUX8,
 	AB8505_LDO_ANA,
-	AB8505_SYSCLKREQ_2,
-	AB8505_SYSCLKREQ_4,
 	AB8505_NUM_REGULATORS,
 };
=20
diff --git a/include/linux/time.h b/include/linux/time.h
index 7d532a32ff3a..0a9d74f14118 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -280,4 +280,16 @@ static __always_inline void timespec_add_ns(struct tim=
espec *a, u64 ns)
 	a->tv_nsec =3D ns;
 }
=20
+/**
+ * time_between32 - check if a 32-bit timestamp is within a given time ran=
ge
+ * @t:	the time which may be within [l,h]
+ * @l:	the lower bound of the range
+ * @h:	the higher bound of the range
+ *
+ * time_before32(t, l, h) returns true if @l <=3D @t <=3D @h. All operands=
 are
+ * treated as 32-bit integers.
+ *
+ * Equivalent to !(time_before32(@t, @l) || time_after32(@t, @h)).
+ */
+#define time_between32(t, l, h) ((u32)(h) - (u32)(l) >=3D (u32)(t) - (u32)=
(l))
 #endif
diff --git a/include/net/ip.h b/include/net/ip.h
index 8ec53320c902..333f1159d0f8 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -522,4 +522,9 @@ void ip_local_error(struct sock *sk, int err, __be32 da=
ddr, __be16 dport,
 int ip_misc_proc_init(void);
 #endif
=20
+static inline bool inetdev_valid_mtu(unsigned int mtu)
+{
+	return likely(mtu >=3D 68);
+}
+
 #endif	/* _IP_H */
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 7667c9adc92a..417460d2b217 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -326,18 +326,6 @@ static inline bool tcp_too_many_orphans(struct sock *s=
k, int shift)
=20
 bool tcp_check_oom(struct sock *sk, int shift);
=20
-/* syncookies: remember time of last synqueue overflow */
-static inline void tcp_synq_overflow(struct sock *sk)
-{
-	tcp_sk(sk)->rx_opt.ts_recent_stamp =3D jiffies;
-}
-
-/* syncookies: no recent synqueue overflow on this listening socket? */
-static inline bool tcp_synq_no_recent_overflow(const struct sock *sk)
-{
-	unsigned long last_overflow =3D tcp_sk(sk)->rx_opt.ts_recent_stamp;
-	return time_after(jiffies, last_overflow + TCP_TIMEOUT_FALLBACK);
-}
=20
 extern struct proto tcp_prot;
=20
@@ -485,13 +473,35 @@ struct sock *cookie_v4_check(struct sock *sk, struct =
sk_buff *skb,
  * i.e. a sent cookie is valid only at most for 2*60 seconds (or less if
  * the counter advances immediately after a cookie is generated).
  */
-#define MAX_SYNCOOKIE_AGE 2
+#define MAX_SYNCOOKIE_AGE	2
+#define TCP_SYNCOOKIE_PERIOD	(60 * HZ)
+#define TCP_SYNCOOKIE_VALID	(MAX_SYNCOOKIE_AGE * TCP_SYNCOOKIE_PERIOD)
+
+/* syncookies: remember time of last synqueue overflow
+ * But do not dirty this field too often (once per second is enough)
+ */
+static inline void tcp_synq_overflow(struct sock *sk)
+{
+	unsigned long last_overflow =3D ACCESS_ONCE(tcp_sk(sk)->rx_opt.ts_recent_=
stamp);
+	unsigned long now =3D jiffies;
+
+	if (!time_between32(now, last_overflow, last_overflow + HZ))
+		ACCESS_ONCE(tcp_sk(sk)->rx_opt.ts_recent_stamp) =3D now;
+}
+
+/* syncookies: no recent synqueue overflow on this listening socket? */
+static inline bool tcp_synq_no_recent_overflow(const struct sock *sk)
+{
+	unsigned long last_overflow =3D ACCESS_ONCE(tcp_sk(sk)->rx_opt.ts_recent_=
stamp);
+
+	return time_after(jiffies, last_overflow + TCP_SYNCOOKIE_VALID);
+}
=20
 static inline u32 tcp_cookie_time(void)
 {
 	u64 val =3D get_jiffies_64();
=20
-	do_div(val, 60 * HZ);
+	do_div(val, TCP_SYNCOOKIE_PERIOD);
 	return val;
 }
=20
diff --git a/kernel/futex.c b/kernel/futex.c
index 99679c0040cc..7976a19877e4 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2905,7 +2905,8 @@ SYSCALL_DEFINE3(get_robust_list, int, pid,
  * Process a futex-list entry, check whether it's owned by the
  * dying task, and do notification if so:
  */
-int handle_futex_death(u32 __user *uaddr, struct task_struct *curr, int pi)
+int handle_futex_death(u32 __user *uaddr, struct task_struct *curr,
+		       bool pi, bool pending_op)
 {
 	u32 uval, uninitialized_var(nval), mval;
=20
@@ -2917,6 +2918,42 @@ int handle_futex_death(u32 __user *uaddr, struct tas=
k_struct *curr, int pi)
 	if (get_user(uval, uaddr))
 		return -1;
=20
+	/*
+	 * Special case for regular (non PI) futexes. The unlock path in
+	 * user space has two race scenarios:
+	 *
+	 * 1. The unlock path releases the user space futex value and
+	 *    before it can execute the futex() syscall to wake up
+	 *    waiters it is killed.
+	 *
+	 * 2. A woken up waiter is killed before it can acquire the
+	 *    futex in user space.
+	 *
+	 * In both cases the TID validation below prevents a wakeup of
+	 * potential waiters which can cause these waiters to block
+	 * forever.
+	 *
+	 * In both cases the following conditions are met:
+	 *
+	 *	1) task->robust_list->list_op_pending !=3D NULL
+	 *	   @pending_op =3D=3D true
+	 *	2) User space futex value =3D=3D 0
+	 *	3) Regular futex: @pi =3D=3D false
+	 *
+	 * If these conditions are met, it is safe to attempt waking up a
+	 * potential waiter without touching the user space futex value and
+	 * trying to set the OWNER_DIED bit. The user space futex value is
+	 * uncontended and the rest of the user space mutex state is
+	 * consistent, so a woken waiter will just take over the
+	 * uncontended futex. Setting the OWNER_DIED bit would create
+	 * inconsistent state and malfunction of the user space owner died
+	 * handling.
+	 */
+	if (pending_op && !pi && !uval) {
+		futex_wake(uaddr, 1, 1, FUTEX_BITSET_MATCH_ANY);
+		return 0;
+	}
+
 	if ((uval & FUTEX_TID_MASK) =3D=3D task_pid_vnr(curr)) {
 		/*
 		 * Ok, this dying thread is truly holding a futex
@@ -3021,10 +3058,11 @@ void exit_robust_list(struct task_struct *curr)
 		 * A pending lock might already be on the list, so
 		 * don't process it twice:
 		 */
-		if (entry !=3D pending)
+		if (entry !=3D pending) {
 			if (handle_futex_death((void __user *)entry + futex_offset,
-						curr, pi))
+						curr, pi, HANDLE_DEATH_LIST))
 				return;
+		}
 		if (rc)
 			return;
 		entry =3D next_entry;
@@ -3038,9 +3076,10 @@ void exit_robust_list(struct task_struct *curr)
 		cond_resched();
 	}
=20
-	if (pending)
+	if (pending) {
 		handle_futex_death((void __user *)pending + futex_offset,
-				   curr, pip);
+				   curr, pip, HANDLE_DEATH_PENDING);
+	}
 }
=20
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index 4ae3232e7a28..541828b74fea 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -94,7 +94,8 @@ void compat_exit_robust_list(struct task_struct *curr)
 		if (entry !=3D pending) {
 			void __user *uaddr =3D futex_uaddr(entry, futex_offset);
=20
-			if (handle_futex_death(uaddr, curr, pi))
+			if (handle_futex_death(uaddr, curr, pi,
+					       HANDLE_DEATH_LIST))
 				return;
 		}
 		if (rc)
@@ -113,7 +114,7 @@ void compat_exit_robust_list(struct task_struct *curr)
 	if (pending) {
 		void __user *uaddr =3D futex_uaddr(pending, futex_offset);
=20
-		handle_futex_death(uaddr, curr, pip);
+		handle_futex_death(uaddr, curr, pip, HANDLE_DEATH_PENDING);
 	}
 }
=20
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index aaf2b480d111..c8faa5906f0d 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -64,7 +64,6 @@
  */
 DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) =3D
 {
-
 	.lock =3D __RAW_SPIN_LOCK_UNLOCKED(hrtimer_bases.lock),
 	.clock_base =3D
 	{
@@ -72,25 +71,21 @@ DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) =
=3D
 			.index =3D HRTIMER_BASE_MONOTONIC,
 			.clockid =3D CLOCK_MONOTONIC,
 			.get_time =3D &ktime_get,
-			.resolution =3D KTIME_LOW_RES,
 		},
 		{
 			.index =3D HRTIMER_BASE_REALTIME,
 			.clockid =3D CLOCK_REALTIME,
 			.get_time =3D &ktime_get_real,
-			.resolution =3D KTIME_LOW_RES,
 		},
 		{
 			.index =3D HRTIMER_BASE_BOOTTIME,
 			.clockid =3D CLOCK_BOOTTIME,
 			.get_time =3D &ktime_get_boottime,
-			.resolution =3D KTIME_LOW_RES,
 		},
 		{
 			.index =3D HRTIMER_BASE_TAI,
 			.clockid =3D CLOCK_TAI,
 			.get_time =3D &ktime_get_clocktai,
-			.resolution =3D KTIME_LOW_RES,
 		},
 	}
 };
@@ -501,6 +496,8 @@ static inline void debug_deactivate(struct hrtimer *tim=
er)
  * High resolution timer enabled ?
  */
 static int hrtimer_hres_enabled __read_mostly  =3D 1;
+unsigned int hrtimer_resolution __read_mostly =3D LOW_RES_NSEC;
+EXPORT_SYMBOL_GPL(hrtimer_resolution);
=20
 /*
  * Enable / Disable high resolution mode
@@ -707,7 +704,7 @@ static void retrigger_next_event(void *arg)
  */
 static int hrtimer_switch_to_hres(void)
 {
-	int i, cpu =3D smp_processor_id();
+	int cpu =3D smp_processor_id();
 	struct hrtimer_cpu_base *base =3D &per_cpu(hrtimer_bases, cpu);
 	unsigned long flags;
=20
@@ -723,8 +720,7 @@ static int hrtimer_switch_to_hres(void)
 		return 0;
 	}
 	base->hres_active =3D 1;
-	for (i =3D 0; i < HRTIMER_MAX_CLOCK_BASES; i++)
-		base->clock_base[i].resolution =3D KTIME_HIGH_RES;
+	hrtimer_resolution =3D HIGH_RES_NSEC;
=20
 	tick_setup_sched_timer();
 	/* "Retrigger" the interrupt to get things going */
@@ -859,8 +855,8 @@ u64 hrtimer_forward(struct hrtimer *timer, ktime_t now,=
 ktime_t interval)
 	if (delta.tv64 < 0)
 		return 0;
=20
-	if (interval.tv64 < timer->base->resolution.tv64)
-		interval.tv64 =3D timer->base->resolution.tv64;
+	if (interval.tv64 < hrtimer_resolution)
+		interval.tv64 =3D hrtimer_resolution;
=20
 	if (unlikely(delta.tv64 >=3D interval.tv64)) {
 		s64 incr =3D ktime_to_ns(interval);
@@ -1001,7 +997,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, kt=
ime_t tim,
 		 * timeouts. This will go away with the GTOD framework.
 		 */
 #ifdef CONFIG_TIME_LOW_RES
-		tim =3D ktime_add_safe(tim, base->resolution);
+		tim =3D ktime_add_safe(tim, ktime_set(0, hrtimer_resolution));
 #endif
 	}
=20
@@ -1240,12 +1236,8 @@ EXPORT_SYMBOL_GPL(hrtimer_init);
  */
 int hrtimer_get_res(const clockid_t which_clock, struct timespec *tp)
 {
-	struct hrtimer_cpu_base *cpu_base;
-	int base =3D hrtimer_clockid_to_base(which_clock);
-
-	cpu_base =3D &__raw_get_cpu_var(hrtimer_bases);
-	*tp =3D ktime_to_timespec(cpu_base->clock_base[base].resolution);
-
+	tp->tv_sec =3D 0;
+	tp->tv_nsec =3D hrtimer_resolution;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(hrtimer_get_res);
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index 37d7e4d29e5f..7e6a815aa377 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -120,10 +120,10 @@ static void
 print_base(struct seq_file *m, struct hrtimer_clock_base *base, u64 now)
 {
 	SEQ_printf(m, "  .base:       %pK\n", base);
-	SEQ_printf(m, "  .index:      %d\n",
-			base->index);
-	SEQ_printf(m, "  .resolution: %Lu nsecs\n",
-			(unsigned long long)ktime_to_ns(base->resolution));
+	SEQ_printf(m, "  .index:      %d\n", base->index);
+
+	SEQ_printf(m, "  .resolution: %u nsecs\n", (unsigned) hrtimer_resolution);
+
 	SEQ_printf(m,   "  .get_time:   ");
 	print_name_offset(m, base->get_time);
 	SEQ_printf(m,   "\n");
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0d09d4a4de7b..1d99457a05b6 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4266,9 +4266,29 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	struct pool_workqueue *pwq;
 	int node;
=20
+	/*
+	 * Remove it from sysfs first so that sanity check failure doesn't
+	 * lead to sysfs name conflicts.
+	 */
+	workqueue_sysfs_unregister(wq);
+
 	/* drain it before proceeding with destruction */
 	drain_workqueue(wq);
=20
+	/* kill rescuer, if sanity checks fail, leave it w/o rescuer */
+	if (wq->rescuer) {
+		struct worker *rescuer =3D wq->rescuer;
+
+		/* this prevents new queueing */
+		spin_lock_irq(&wq_mayday_lock);
+		wq->rescuer =3D NULL;
+		spin_unlock_irq(&wq_mayday_lock);
+
+		/* rescuer will empty maydays list before exiting */
+		kthread_stop(rescuer->task);
+		kfree(rescuer);
+	}
+
 	/* sanity checks */
 	mutex_lock(&wq->mutex);
 	for_each_pwq(pwq, wq) {
@@ -4298,14 +4318,6 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	list_del_init(&wq->list);
 	mutex_unlock(&wq_pool_mutex);
=20
-	workqueue_sysfs_unregister(wq);
-
-	if (wq->rescuer) {
-		kthread_stop(wq->rescuer->task);
-		kfree(wq->rescuer);
-		wq->rescuer =3D NULL;
-	}
-
 	if (!(wq->flags & WQ_UNBOUND)) {
 		/*
 		 * The base ref is never dropped on per-cpu pwqs.  Directly
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 0a43cce9a914..afa67d8ff9f5 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -5226,8 +5226,15 @@ static void hci_rx_work(struct work_struct *work)
 			hci_send_to_sock(hdev, skb);
 		}
=20
-		if (test_bit(HCI_RAW, &hdev->flags) ||
-		    test_bit(HCI_USER_CHANNEL, &hdev->dev_flags)) {
+		/* If the device has been opened in HCI_USER_CHANNEL,
+		 * the userspace has exclusive access to device.
+		 * When device is HCI_INIT, we still need to process
+		 * the data packets to the driver in order
+		 * to complete its setup().
+		 */
+		if ((test_bit(HCI_RAW, &hdev->flags) ||
+		     test_bit(HCI_USER_CHANNEL, &hdev->dev_flags)) &&
+		    !test_bit(HCI_INIT, &hdev->flags)) {
 			kfree_skb(skb);
 			continue;
 		}
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 79b2d349de99..35c41fdbde16 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4902,10 +4902,8 @@ void __l2cap_physical_cfm(struct l2cap_chan *chan, i=
nt result)
 	BT_DBG("chan %p, result %d, local_amp_id %d, remote_amp_id %d",
 	       chan, result, local_amp_id, remote_amp_id);
=20
-	if (chan->state =3D=3D BT_DISCONN || chan->state =3D=3D BT_CLOSED) {
-		l2cap_chan_unlock(chan);
+	if (chan->state =3D=3D BT_DISCONN || chan->state =3D=3D BT_CLOSED)
 		return;
-	}
=20
 	if (chan->state !=3D BT_CONNECTED) {
 		l2cap_do_create(chan, result, local_amp_id, remote_amp_id);
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index f6c9fb8e7449..9e18e759eed4 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -193,6 +193,12 @@ static int br_set_mac_address(struct net_device *dev, =
void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
=20
+	/* dev_set_mac_addr() can be called by a master device on bridge's
+	 * NETDEV_UNREGISTER, but since it's being destroyed do nothing
+	 */
+	if (dev->reg_state !=3D NETREG_REGISTERED)
+		return -EBUSY;
+
 	spin_lock_bh(&br->lock);
 	if (!ether_addr_equal(dev->dev_addr, addr->sa_data)) {
 		/* Mac address will be changed in br_stp_change_bridge_id(). */
diff --git a/net/core/dev.c b/net/core/dev.c
index 4c821b721713..7e499da4a06f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5680,7 +5680,8 @@ static int __dev_set_mtu(struct net_device *dev, int =
new_mtu)
 	if (ops->ndo_change_mtu)
 		return ops->ndo_change_mtu(dev, new_mtu);
=20
-	dev->mtu =3D new_mtu;
+	/* Pairs with all the lockless reads of dev->mtu in the stack */
+	ACCESS_ONCE(dev->mtu) =3D new_mtu;
 	return 0;
 }
=20
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 710fe64fb2f7..026f69106ec2 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1318,11 +1318,6 @@ static void inetdev_changename(struct net_device *de=
v, struct in_device *in_dev)
 	}
 }
=20
-static bool inetdev_valid_mtu(unsigned int mtu)
-{
-	return mtu >=3D 68;
-}
-
 static void inetdev_send_gratuitous_arp(struct net_device *dev,
 					struct in_device *in_dev)
=20
diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
index c2b97cdb2e72..5746d54e52c0 100644
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -419,7 +419,12 @@ static int inet_peer_gc(struct inet_peer_base *base,
 		p =3D rcu_deref_locked(**stackptr, base);
 		if (atomic_read(&p->refcnt) =3D=3D 0) {
 			smp_rmb();
-			delta =3D (__u32)jiffies - p->dtime;
+
+			/* The ACCESS_ONCE() pairs with the ACCESS_ONCE()
+			 * in inet_putpeer()
+			 */
+			delta =3D (__u32)jiffies - ACCESS_ONCE(p->dtime);
+
 			if (delta >=3D ttl &&
 			    atomic_cmpxchg(&p->refcnt, 0, -1) =3D=3D 0) {
 				p->gc_next =3D gchead;
@@ -504,7 +509,10 @@ EXPORT_SYMBOL_GPL(inet_getpeer);
=20
 void inet_putpeer(struct inet_peer *p)
 {
-	p->dtime =3D (__u32)jiffies;
+	/* The ACCESS_ONCE() pairs with itself (we run lockless)
+	 * and the ACCESS_ONCE() in inet_peer_gc()
+	 */
+	ACCESS_ONCE(p->dtime) =3D (__u32)jiffies;
 	smp_mb__before_atomic();
 	atomic_dec(&p->refcnt);
 }
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 2a05dfc9a35e..260e50e77d55 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1106,13 +1106,17 @@ static int ip_setup_cork(struct sock *sk, struct in=
et_cork *cork,
 	rt =3D *rtp;
 	if (unlikely(!rt))
 		return -EFAULT;
-	/*
-	 * We steal reference to this route, caller should not release it
-	 */
-	*rtp =3D NULL;
+
 	cork->fragsize =3D ip_sk_use_pmtu(sk) ?
-			 dst_mtu(&rt->dst) : rt->dst.dev->mtu;
+			 dst_mtu(&rt->dst) : ACCESS_ONCE(rt->dst.dev->mtu);
+
+	if (!inetdev_valid_mtu(cork->fragsize))
+		return -ENETUNREACH;
+
 	cork->dst =3D &rt->dst;
+	/* We stole this route, caller should not release it. */
+	*rtp =3D NULL;
+
 	cork->length =3D 0;
 	cork->ttl =3D ipc->ttl;
 	cork->tos =3D ipc->tos;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index f3e3c36368db..e292792e9964 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -680,8 +680,9 @@ static unsigned int tcp_established_options(struct sock=
 *sk, struct sk_buff *skb
 			min_t(unsigned int, eff_sacks,
 			      (remaining - TCPOLEN_SACK_BASE_ALIGNED) /
 			      TCPOLEN_SACK_PERBLOCK);
-		size +=3D TCPOLEN_SACK_BASE_ALIGNED +
-			opts->num_sack_blocks * TCPOLEN_SACK_PERBLOCK;
+		if (likely(opts->num_sack_blocks))
+			size +=3D TCPOLEN_SACK_BASE_ALIGNED +
+				opts->num_sack_blocks * TCPOLEN_SACK_PERBLOCK;
 	}
=20
 	return size;
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 15a8a568018c..b92826982177 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -788,7 +788,10 @@ static struct sk_buff *ovs_flow_cmd_build_info(const s=
truct sw_flow *flow,
 	retval =3D ovs_flow_cmd_fill_info(flow, dp_ifindex, skb,
 					info->snd_portid, info->snd_seq, 0,
 					cmd);
-	BUG_ON(retval < 0);
+	if (WARN_ON_ONCE(retval < 0)) {
+		kfree_skb(skb);
+		skb =3D ERR_PTR(retval);
+	}
 	return skb;
 }
=20
@@ -1133,7 +1136,10 @@ static int ovs_flow_cmd_del(struct sk_buff *skb, str=
uct genl_info *info)
 						     info->snd_seq, 0,
 						     OVS_FLOW_CMD_DEL);
 			rcu_read_unlock();
-			BUG_ON(err < 0);
+			if (WARN_ON_ONCE(err < 0)) {
+				kfree_skb(reply);
+				goto out_free;
+			}
=20
 			ovs_notify(&dp_flow_genl_family, reply, info);
 		} else {
@@ -1141,6 +1147,7 @@ static int ovs_flow_cmd_del(struct sk_buff *skb, stru=
ct genl_info *info)
 		}
 	}
=20
+out_free:
 	ovs_flow_free(flow, true);
 	return 0;
 unlock:
diff --git a/net/socket.c b/net/socket.c
index c28a7048bc16..650ea025c0b9 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -3311,6 +3311,7 @@ static int compat_sock_ioctl_trans(struct file *file,=
 struct socket *sock,
 	case SIOCSARP:
 	case SIOCGARP:
 	case SIOCDARP:
+	case SIOCOUTQNSD:
 	case SIOCATMARK:
 		return sock_do_ioctl(net, sock, cmd, arg);
 	}
diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index 4a5598a42cd6..41d363080315 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -50,8 +50,6 @@ static void cache_init(struct cache_head *h)
 	h->last_refresh =3D now;
 }
=20
-static inline int cache_is_valid(struct cache_head *h);
-static void cache_fresh_locked(struct cache_head *head, time_t expiry);
 static void cache_fresh_unlocked(struct cache_head *head,
 				struct cache_detail *detail);
=20
@@ -99,9 +97,6 @@ struct cache_head *sunrpc_cache_lookup(struct cache_detai=
l *detail,
 				*hp =3D tmp->next;
 				tmp->next =3D NULL;
 				detail->entries --;
-				if (cache_is_valid(tmp) =3D=3D -EAGAIN)
-					set_bit(CACHE_NEGATIVE, &tmp->flags);
-				cache_fresh_locked(tmp, 0);
 				freeme =3D tmp;
 				break;
 			}
diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 7c0e6e46905d..8051969250a3 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -64,7 +64,7 @@ create_package() {
 	fi
=20
 	# Create the package
-	dpkg-gencontrol -isp $forcearch -Vkernel:debarch=3D"${debarch:-$(dpkg --p=
rint-architecture)}" -p$pname -P"$pdir"
+	dpkg-gencontrol $forcearch -Vkernel:debarch=3D"${debarch:-$(dpkg --print-=
architecture)}" -p$pname -P"$pdir"
 	dpkg --build "$pdir" ..
 }
=20
diff --git a/sound/core/oss/linear.c b/sound/core/oss/linear.c
index 2045697f449d..797d838a2f9e 100644
--- a/sound/core/oss/linear.c
+++ b/sound/core/oss/linear.c
@@ -107,6 +107,8 @@ static snd_pcm_sframes_t linear_transfer(struct snd_pcm=
_plugin *plugin,
 		}
 	}
 #endif
+	if (frames > dst_channels[0].frames)
+		frames =3D dst_channels[0].frames;
 	convert(plugin, src_channels, dst_channels, frames);
 	return frames;
 }
diff --git a/sound/core/oss/mulaw.c b/sound/core/oss/mulaw.c
index 7915564bd394..3788906421a7 100644
--- a/sound/core/oss/mulaw.c
+++ b/sound/core/oss/mulaw.c
@@ -269,6 +269,8 @@ static snd_pcm_sframes_t mulaw_transfer(struct snd_pcm_=
plugin *plugin,
 		}
 	}
 #endif
+	if (frames > dst_channels[0].frames)
+		frames =3D dst_channels[0].frames;
 	data =3D (struct mulaw_priv *)plugin->extra_data;
 	data->func(plugin, src_channels, dst_channels, frames);
 	return frames;
diff --git a/sound/core/oss/route.c b/sound/core/oss/route.c
index c8171f5783c8..72dea04197ef 100644
--- a/sound/core/oss/route.c
+++ b/sound/core/oss/route.c
@@ -57,6 +57,8 @@ static snd_pcm_sframes_t route_transfer(struct snd_pcm_pl=
ugin *plugin,
 		return -ENXIO;
 	if (frames =3D=3D 0)
 		return 0;
+	if (frames > dst_channels[0].frames)
+		frames =3D dst_channels[0].frames;
=20
 	nsrcs =3D plugin->src_format.channels;
 	ndsts =3D plugin->dst_format.channels;
diff --git a/sound/isa/cs423x/cs4236.c b/sound/isa/cs423x/cs4236.c
index 750f51c904fc..0c395c9319ed 100644
--- a/sound/isa/cs423x/cs4236.c
+++ b/sound/isa/cs423x/cs4236.c
@@ -293,7 +293,8 @@ static int snd_cs423x_pnp_init_mpu(int dev, struct pnp_=
dev *pdev)
 	} else {
 		mpu_port[dev] =3D pnp_port_start(pdev, 0);
 		if (mpu_irq[dev] >=3D 0 &&
-		    pnp_irq_valid(pdev, 0) && pnp_irq(pdev, 0) >=3D 0) {
+		    pnp_irq_valid(pdev, 0) &&
+		    pnp_irq(pdev, 0) !=3D (resource_size_t)-1) {
 			mpu_irq[dev] =3D pnp_irq(pdev, 0);
 		} else {
 			mpu_irq[dev] =3D -1;	/* disable interrupt */
diff --git a/sound/soc/soc-jack.c b/sound/soc/soc-jack.c
index d0d98810af91..5c22fc5d03d1 100644
--- a/sound/soc/soc-jack.c
+++ b/sound/soc/soc-jack.c
@@ -69,10 +69,9 @@ void snd_soc_jack_report(struct snd_soc_jack *jack, int =
status, int mask)
 	unsigned int sync =3D 0;
 	int enable;
=20
-	trace_snd_soc_jack_report(jack, mask, status);
-
 	if (!jack)
 		return;
+	trace_snd_soc_jack_report(jack, mask, status);
=20
 	codec =3D jack->codec;
 	dapm =3D  &codec->dapm;
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/par=
se-filter.c
index 15a43ee8e8b5..ce4330effc88 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -1482,8 +1482,10 @@ static int copy_filter_type(struct event_filter *fil=
ter,
 	if (strcmp(str, "TRUE") =3D=3D 0 || strcmp(str, "FALSE") =3D=3D 0) {
 		/* Add trivial event */
 		arg =3D allocate_arg();
-		if (arg =3D=3D NULL)
+		if (arg =3D=3D NULL) {
+			free(str);
 			return -1;
+		}
=20
 		arg->type =3D FILTER_ARG_BOOLEAN;
 		if (strcmp(str, "TRUE") =3D=3D 0)
@@ -1492,8 +1494,11 @@ static int copy_filter_type(struct event_filter *fil=
ter,
 			arg->boolean.value =3D 0;
=20
 		filter_type =3D add_filter_type(filter, event->id);
-		if (filter_type =3D=3D NULL)
+		if (filter_type =3D=3D NULL) {
+			free(str);
+			free_arg(arg);
 			return -1;
+		}
=20
 		filter_type->filter =3D arg;
=20
diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index cc66c4049e09..57c4b81275b6 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -277,6 +277,51 @@ bool die_is_func_def(Dwarf_Die *dw_die)
 		dwarf_attr(dw_die, DW_AT_declaration, &attr) =3D=3D NULL);
 }
=20
+/**
+ * die_entrypc - Returns entry PC (the lowest address) of a DIE
+ * @dw_die: a DIE
+ * @addr: where to store entry PC
+ *
+ * Since dwarf_entrypc() does not return entry PC if the DIE has only addr=
ess
+ * range, we have to use this to retrieve the lowest address from the addr=
ess
+ * range attribute.
+ */
+int die_entrypc(Dwarf_Die *dw_die, Dwarf_Addr *addr)
+{
+	Dwarf_Addr base, end;
+
+	if (!addr)
+		return -EINVAL;
+
+	if (dwarf_entrypc(dw_die, addr) =3D=3D 0)
+		return 0;
+
+	return dwarf_ranges(dw_die, 0, &base, addr, &end) < 0 ? -ENOENT : 0;
+}
+
+/**
+ * die_is_func_instance - Ensure that this DIE is an instance of a subprog=
ram
+ * @dw_die: a DIE
+ *
+ * Ensure that this DIE is an instance (which has an entry address).
+ * This returns true if @dw_die is a function instance. If not, the @dw_die
+ * must be a prototype. You can use die_walk_instances() to find actual
+ * instances.
+ **/
+bool die_is_func_instance(Dwarf_Die *dw_die)
+{
+	Dwarf_Addr tmp;
+	Dwarf_Attribute attr_mem;
+	int tag =3D dwarf_tag(dw_die);
+
+	if (tag !=3D DW_TAG_subprogram &&
+	    tag !=3D DW_TAG_inlined_subroutine)
+		return false;
+
+	return dwarf_entrypc(dw_die, &tmp) =3D=3D 0 ||
+		dwarf_attr(dw_die, DW_AT_ranges, &attr_mem) !=3D NULL;
+}
+
 /**
  * die_get_data_member_location - Get the data-member offset
  * @mb_die: a DIE of a member of a data structure
@@ -516,6 +561,9 @@ static int __die_walk_instances_cb(Dwarf_Die *inst, voi=
d *data)
 	Dwarf_Die *origin;
 	int tmp;
=20
+	if (!die_is_func_instance(inst))
+		return DIE_FIND_CB_CONTINUE;
+
 	attr =3D dwarf_attr(inst, DW_AT_abstract_origin, &attr_mem);
 	if (attr =3D=3D NULL)
 		return DIE_FIND_CB_CONTINUE;
@@ -587,7 +635,7 @@ static int __die_walk_funclines_cb(Dwarf_Die *in_die, v=
oid *data)
 	if (dwarf_tag(in_die) =3D=3D DW_TAG_inlined_subroutine) {
 		fname =3D die_get_call_file(in_die);
 		lineno =3D die_get_call_lineno(in_die);
-		if (fname && lineno > 0 && dwarf_entrypc(in_die, &addr) =3D=3D 0) {
+		if (fname && lineno > 0 && die_entrypc(in_die, &addr) =3D=3D 0) {
 			lw->retval =3D lw->callback(fname, lineno, addr, lw->data);
 			if (lw->retval !=3D 0)
 				return DIE_FIND_CB_END;
@@ -628,7 +676,7 @@ static int __die_walk_funclines(Dwarf_Die *sp_die, bool=
 recursive,
 	/* Handle function declaration line */
 	fname =3D dwarf_decl_file(sp_die);
 	if (fname && dwarf_decl_line(sp_die, &lineno) =3D=3D 0 &&
-	    dwarf_entrypc(sp_die, &addr) =3D=3D 0) {
+	    die_entrypc(sp_die, &addr) =3D=3D 0) {
 		lw.retval =3D callback(fname, lineno, addr, data);
 		if (lw.retval !=3D 0)
 			goto done;
@@ -666,15 +714,19 @@ int die_walk_lines(Dwarf_Die *rt_die, line_walk_callb=
ack_t callback, void *data)
 	Dwarf_Lines *lines;
 	Dwarf_Line *line;
 	Dwarf_Addr addr;
-	const char *fname;
+	const char *fname, *decf =3D NULL, *inf =3D NULL;
 	int lineno, ret =3D 0;
+	int decl =3D 0, inl;
 	Dwarf_Die die_mem, *cu_die;
 	size_t nlines, i;
+	bool flag;
=20
 	/* Get the CU die */
-	if (dwarf_tag(rt_die) !=3D DW_TAG_compile_unit)
+	if (dwarf_tag(rt_die) !=3D DW_TAG_compile_unit) {
 		cu_die =3D dwarf_diecu(rt_die, &die_mem, NULL, NULL);
-	else
+		dwarf_decl_line(rt_die, &decl);
+		decf =3D dwarf_decl_file(rt_die);
+	} else
 		cu_die =3D rt_die;
 	if (!cu_die) {
 		pr_debug2("Failed to get CU from given DIE.\n");
@@ -698,16 +750,36 @@ int die_walk_lines(Dwarf_Die *rt_die, line_walk_callb=
ack_t callback, void *data)
 				  "Possible error in debuginfo.\n");
 			continue;
 		}
+		/* Skip end-of-sequence */
+		if (dwarf_lineendsequence(line, &flag) !=3D 0 || flag)
+			continue;
+		/* Skip Non statement line-info */
+		if (dwarf_linebeginstatement(line, &flag) !=3D 0 || !flag)
+			continue;
 		/* Filter lines based on address */
-		if (rt_die !=3D cu_die)
+		if (rt_die !=3D cu_die) {
 			/*
 			 * Address filtering
 			 * The line is included in given function, and
 			 * no inline block includes it.
 			 */
-			if (!dwarf_haspc(rt_die, addr) ||
-			    die_find_inlinefunc(rt_die, addr, &die_mem))
+			if (!dwarf_haspc(rt_die, addr))
 				continue;
+
+			if (die_find_inlinefunc(rt_die, addr, &die_mem)) {
+				/* Call-site check */
+				inf =3D die_get_call_file(&die_mem);
+				if ((inf && !strcmp(inf, decf)) &&
+				    die_get_call_lineno(&die_mem) =3D=3D lineno)
+					goto found;
+
+				dwarf_decl_line(&die_mem, &inl);
+				if (inl !=3D decl ||
+				    decf !=3D dwarf_decl_file(&die_mem))
+					continue;
+			}
+		}
+found:
 		/* Get source line */
 		fname =3D dwarf_linesrc(line, NULL, NULL);
=20
diff --git a/tools/perf/util/dwarf-aux.h b/tools/perf/util/dwarf-aux.h
index b4fe90c6cb2d..c89712e2a104 100644
--- a/tools/perf/util/dwarf-aux.h
+++ b/tools/perf/util/dwarf-aux.h
@@ -38,9 +38,15 @@ extern int cu_find_lineinfo(Dwarf_Die *cudie, unsigned l=
ong addr,
 extern int cu_walk_functions_at(Dwarf_Die *cu_die, Dwarf_Addr addr,
 			int (*callback)(Dwarf_Die *, void *), void *data);
=20
+/* Get the lowest PC in DIE (including range list) */
+int die_entrypc(Dwarf_Die *dw_die, Dwarf_Addr *addr);
+
 /* Ensure that this DIE is a subprogram and definition (not declaration) */
 extern bool die_is_func_def(Dwarf_Die *dw_die);
=20
+/* Ensure that this DIE is an instance of a subprogram */
+extern bool die_is_func_instance(Dwarf_Die *dw_die);
+
 /* Compare diename and tname */
 extern bool die_compare_name(Dwarf_Die *dw_die, const char *tname);
=20
diff --git a/tools/perf/util/perf_regs.h b/tools/perf/util/perf_regs.h
index 980dbf76bc98..df02158e82a1 100644
--- a/tools/perf/util/perf_regs.h
+++ b/tools/perf/util/perf_regs.h
@@ -16,7 +16,7 @@ int perf_reg_value(u64 *valp, struct regs_dump *regs, int=
 id);
=20
 static inline const char *perf_reg_name(int id __maybe_unused)
 {
-	return NULL;
+	return "unknown";
 }
=20
 static inline int perf_reg_value(u64 *valp __maybe_unused,
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 98e304766416..17e950959a7a 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -588,34 +588,26 @@ static int convert_to_trace_point(Dwarf_Die *sp_die, =
Dwfl_Module *mod,
 				  Dwarf_Addr paddr, bool retprobe,
 				  struct probe_trace_point *tp)
 {
-	Dwarf_Addr eaddr, highaddr;
+	Dwarf_Addr eaddr;
 	GElf_Sym sym;
 	const char *symbol;
=20
 	/* Verify the address is correct */
-	if (dwarf_entrypc(sp_die, &eaddr) !=3D 0) {
-		pr_warning("Failed to get entry address of %s\n",
-			   dwarf_diename(sp_die));
-		return -ENOENT;
-	}
-	if (dwarf_highpc(sp_die, &highaddr) !=3D 0) {
-		pr_warning("Failed to get end address of %s\n",
-			   dwarf_diename(sp_die));
-		return -ENOENT;
-	}
-	if (paddr > highaddr) {
-		pr_warning("Offset specified is greater than size of %s\n",
+	if (!dwarf_haspc(sp_die, paddr)) {
+		pr_warning("Specified offset is out of %s\n",
 			   dwarf_diename(sp_die));
 		return -EINVAL;
 	}
=20
-	/* Get an appropriate symbol from symtab */
+	/* Try to get actual symbol name from symtab */
 	symbol =3D dwfl_module_addrsym(mod, paddr, &sym, NULL);
 	if (!symbol) {
 		pr_warning("Failed to find symbol at 0x%lx\n",
 			   (unsigned long)paddr);
 		return -ENOENT;
 	}
+	eaddr =3D sym.st_value;
+
 	tp->offset =3D (unsigned long)(paddr - sym.st_value);
 	tp->address =3D (unsigned long)paddr;
 	tp->symbol =3D strdup(symbol);
@@ -866,11 +858,16 @@ static int probe_point_inline_cb(Dwarf_Die *in_die, v=
oid *data)
 		ret =3D find_probe_point_lazy(in_die, pf);
 	else {
 		/* Get probe address */
-		if (dwarf_entrypc(in_die, &addr) !=3D 0) {
+		if (die_entrypc(in_die, &addr) !=3D 0) {
 			pr_warning("Failed to get entry address of %s.\n",
 				   dwarf_diename(in_die));
 			return -ENOENT;
 		}
+		if (addr =3D=3D 0) {
+			pr_debug("%s has no valid entry address. skipped.\n",
+				 dwarf_diename(in_die));
+			return -ENOENT;
+		}
 		pf->addr =3D addr;
 		pf->addr +=3D pp->offset;
 		pr_debug("found inline addr: 0x%jx\n",
@@ -909,17 +906,18 @@ static int probe_point_search_cb(Dwarf_Die *sp_die, v=
oid *data)
 		dwarf_decl_line(sp_die, &pf->lno);
 		pf->lno +=3D pp->line;
 		param->retval =3D find_probe_point_by_line(pf);
-	} else if (!dwarf_func_inline(sp_die)) {
+	} else if (die_is_func_instance(sp_die)) {
+		/* Instances always have the entry address */
+		die_entrypc(sp_die, &pf->addr);
+		/* But in some case the entry address is 0 */
+		if (pf->addr =3D=3D 0) {
+			pr_debug("%s has no entry PC. Skipped\n",
+				 dwarf_diename(sp_die));
+			param->retval =3D 0;
 		/* Real function */
-		if (pp->lazy_line)
+		} else if (pp->lazy_line)
 			param->retval =3D find_probe_point_lazy(sp_die, pf);
 		else {
-			if (dwarf_entrypc(sp_die, &pf->addr) !=3D 0) {
-				pr_warning("Failed to get entry address of "
-					   "%s.\n", dwarf_diename(sp_die));
-				param->retval =3D -ENOENT;
-				return DWARF_CB_ABORT;
-			}
 			pf->addr +=3D pp->offset;
 			/* TODO: Check the address in this function */
 			param->retval =3D call_probe_finder(sp_die, pf);
@@ -1232,6 +1230,18 @@ static int collect_variables_cb(Dwarf_Die *die_mem, =
void *data)
 		return DIE_FIND_CB_SIBLING;
 }
=20
+static bool available_var_finder_overlap(struct available_var_finder *af)
+{
+	int i;
+
+	for (i =3D 0; i < af->nvls; i++) {
+		if (af->pf.addr =3D=3D af->vls[i].point.address)
+			return true;
+	}
+	return false;
+
+}
+
 /* Add a found vars into available variables list */
 static int add_available_vars(Dwarf_Die *sc_die, struct probe_finder *pf)
 {
@@ -1241,6 +1251,14 @@ static int add_available_vars(Dwarf_Die *sc_die, str=
uct probe_finder *pf)
 	Dwarf_Die die_mem;
 	int ret;
=20
+	/*
+	 * For some reason (e.g. different column assigned to same address),
+	 * this callback can be called with the address which already passed.
+	 * Ignore it first.
+	 */
+	if (available_var_finder_overlap(af))
+		return 0;
+
 	/* Check number of tevs */
 	if (af->nvls =3D=3D af->max_vls) {
 		pr_warning("Too many( > %d) probe point found.\n", af->max_vls);
@@ -1347,7 +1365,7 @@ int debuginfo__find_probe_point(struct debuginfo *dbg=
, unsigned long addr,
 		/* Get function entry information */
 		func =3D basefunc =3D dwarf_diename(&spdie);
 		if (!func ||
-		    dwarf_entrypc(&spdie, &baseaddr) !=3D 0 ||
+		    die_entrypc(&spdie, &baseaddr) !=3D 0 ||
 		    dwarf_decl_line(&spdie, &baseline) !=3D 0) {
 			lineno =3D 0;
 			goto post;
@@ -1364,7 +1382,7 @@ int debuginfo__find_probe_point(struct debuginfo *dbg=
, unsigned long addr,
 		while (die_find_top_inlinefunc(&spdie, (Dwarf_Addr)addr,
 						&indie)) {
 			/* There is an inline function */
-			if (dwarf_entrypc(&indie, &_addr) =3D=3D 0 &&
+			if (die_entrypc(&indie, &_addr) =3D=3D 0 &&
 			    _addr =3D=3D addr) {
 				/*
 				 * addr is at an inline function entry.
@@ -1514,7 +1532,7 @@ static int line_range_search_cb(Dwarf_Die *sp_die, vo=
id *data)
 		pr_debug("New line range: %d to %d\n", lf->lno_s, lf->lno_e);
 		lr->start =3D lf->lno_s;
 		lr->end =3D lf->lno_e;
-		if (dwarf_func_inline(sp_die))
+		if (!die_is_func_instance(sp_die))
 			param->retval =3D die_walk_instances(sp_die,
 						line_range_inline_cb, lf);
 		else
diff --git a/tools/power/cpupower/utils/idle_monitor/hsw_ext_idle.c b/tools=
/power/cpupower/utils/idle_monitor/hsw_ext_idle.c
index ebeaba6571a3..475e18e04318 100644
--- a/tools/power/cpupower/utils/idle_monitor/hsw_ext_idle.c
+++ b/tools/power/cpupower/utils/idle_monitor/hsw_ext_idle.c
@@ -40,7 +40,6 @@ static cstate_t hsw_ext_cstates[HSW_EXT_CSTATE_COUNT] =3D=
 {
 	{
 		.name			=3D "PC9",
 		.desc			=3D N_("Processor Package C9"),
-		.desc			=3D N_("Processor Package C2"),
 		.id			=3D PC9,
 		.range			=3D RANGE_PACKAGE,
 		.get_count_percent	=3D hsw_ext_get_count_percent,

--yrj/dFKFPuw6o+aM--

--oLBj+sq0vYjzfsbl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl5DFSYACgkQ57/I7JWG
EQmzYQ/8DqnXjMqD4HQEQDA5ppfTeEgGmm1STfq0zq8bhrwmVFcaLdFU1EMVCsi+
lHVJeKUqwmgXoyrG9xhHs9bFxsGVO5wP/sGMQW7o5QKyj/ajto4s4Ccfv1AdUx0t
wg3bCziQVFmXuxJQboa64+jfrZEWNfzhIzipMQ80bqcZ838wy4xyUZc9VKt873Ss
p7dPhQ/DQOdSBPSKDrr9no0weepdqKSViRX/ExBQGJfwXm11/U/ySaIo107PB/Eu
XuUT0wKiOwaDam34pz+EHloRJT/BbYdhTFk12nH9kS4IQIxNXslyes0GLNw5babJ
SAFwbmnxetKm9wz/aN5mnveS3vvDrx8R8ZK3PgkojuRO1JUwlAsRhW1jOaYuERoL
2LGGcWiqG9zREid2a+2Dae8zHQfh3sgKUyI4vziqTi626JfykZs/0Q6bi6Nlx7XR
HYj+7u3W96lTBBMPpNlDu2Gv2rKgov9i1tvmw0ngXSZVnRhXU9TkZr8nJJyZDQ4s
fZErAvwMX71FfCQFGD3ihOnGzTmtYVCWUalO3LK1p1FrOYzvO/g/ls7LqjwYunm7
y1yN9nnbLYNA8liV2ZV5+21zc5nEHVpFjI89Ga3+ZYAWH6QZuAnvIg/ZUaG5yN69
TxugWot7peF4UF6EF4eNg/f51uMQ4xI9d1Z4ig10g1JNGZ/sVAw=
=hPhk
-----END PGP SIGNATURE-----

--oLBj+sq0vYjzfsbl--
