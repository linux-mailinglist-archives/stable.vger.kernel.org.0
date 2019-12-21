Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E125B128893
	for <lists+stable@lfdr.de>; Sat, 21 Dec 2019 11:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfLUKk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Dec 2019 05:40:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:47172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbfLUKk2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Dec 2019 05:40:28 -0500
Received: from localhost (unknown [38.98.37.136])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8665621655;
        Sat, 21 Dec 2019 10:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576924826;
        bh=jkekfFXkDmbphdz2139DUoYAFAlv/3uUis+0z5hZb+8=;
        h=Date:From:To:Cc:Subject:From;
        b=jdi2jrZt4Meyjce4A4I9Atu3lQNk+O5jRbuteLmCdqVYJlMNtR0czox63Woptd9yR
         G879WrAnP5NVL0GArxRpERQQYH1oG6iCjDjA8SJhZJQCKNp9ueHVxWOORQVimOQawS
         WwngHthqBKyDM02NLUFdZiD+VvNbZSuH3EE30xuc=
Date:   Sat, 21 Dec 2019 11:40:05 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.207
Message-ID: <20191221104005.GA61509@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.207 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/rtc/abracon,abx80x.txt |    2 
 Makefile                                                 |   13 --
 arch/arm/boot/dts/exynos3250.dtsi                        |    2 
 arch/arm/boot/dts/mmp2.dtsi                              |    2 
 arch/arm/boot/dts/omap3-tao3530.dtsi                     |    2 
 arch/arm/boot/dts/pxa27x.dtsi                            |    2 
 arch/arm/boot/dts/pxa2xx.dtsi                            |    7 -
 arch/arm/boot/dts/pxa3xx.dtsi                            |    2 
 arch/arm/boot/dts/s3c6410-mini6410.dts                   |    4 
 arch/arm/boot/dts/s3c6410-smdk6410.dts                   |    4 
 arch/arm/boot/dts/sun6i-a31.dtsi                         |    2 
 arch/arm/boot/dts/sun7i-a20.dtsi                         |    2 
 arch/arm/include/asm/uaccess.h                           |   18 ++
 arch/arm/lib/getuser.S                                   |   11 +
 arch/arm/lib/putuser.S                                   |   20 +--
 arch/arm/mach-omap1/id.c                                 |    6 
 arch/arm/mach-omap2/id.c                                 |    4 
 arch/arm/mach-tegra/reset-handler.S                      |    6 
 arch/mips/Kconfig                                        |    1 
 arch/mips/cavium-octeon/executive/cvmx-cmd-queue.c       |    2 
 arch/mips/cavium-octeon/octeon-platform.c                |    2 
 arch/mips/include/asm/octeon/cvmx-pko.h                  |    2 
 arch/powerpc/include/asm/sfp-machine.h                   |   92 ++++-----------
 arch/powerpc/include/asm/vdso_datapage.h                 |    2 
 arch/powerpc/kernel/asm-offsets.c                        |    2 
 arch/powerpc/kernel/time.c                               |    1 
 arch/powerpc/kernel/vdso32/gettimeofday.S                |    7 -
 arch/powerpc/kernel/vdso64/cacheflush.S                  |    4 
 arch/powerpc/kernel/vdso64/gettimeofday.S                |    7 -
 arch/x86/kernel/apic/apic.c                              |   25 ++--
 arch/x86/kernel/cpu/mcheck/mce.c                         |    5 
 arch/x86/kvm/cpuid.c                                     |    5 
 arch/x86/kvm/x86.c                                       |   14 +-
 arch/x86/pci/fixup.c                                     |   11 +
 arch/xtensa/mm/tlb.c                                     |    4 
 block/blk-mq-sysfs.c                                     |   15 +-
 crypto/crypto_user.c                                     |    4 
 drivers/acpi/bus.c                                       |    2 
 drivers/acpi/device_pm.c                                 |   12 +
 drivers/acpi/osl.c                                       |   28 ++--
 drivers/block/rsxx/core.c                                |    2 
 drivers/clk/rockchip/clk-rk3188.c                        |    8 -
 drivers/cpuidle/driver.c                                 |   15 +-
 drivers/crypto/amcc/crypto4xx_core.c                     |    6 
 drivers/dma/coh901318.c                                  |    5 
 drivers/extcon/extcon-max8997.c                          |   10 -
 drivers/gpu/drm/i810/i810_dma.c                          |    4 
 drivers/gpu/drm/radeon/r100.c                            |    4 
 drivers/gpu/drm/radeon/r200.c                            |    4 
 drivers/i2c/busses/i2c-imx.c                             |    3 
 drivers/iio/humidity/hdc100x.c                           |    2 
 drivers/iio/imu/adis16480.c                              |    1 
 drivers/infiniband/hw/mlx4/sysfs.c                       |   12 -
 drivers/infiniband/hw/qib/qib_sysfs.c                    |    6 
 drivers/input/touchscreen/cyttsp4_core.c                 |    7 -
 drivers/input/touchscreen/goodix.c                       |    9 +
 drivers/isdn/gigaset/usb-gigaset.c                       |   23 ++-
 drivers/md/persistent-data/dm-btree-remove.c             |    8 +
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c            |    3 
 drivers/media/radio/radio-wl1273.c                       |    3 
 drivers/misc/altera-stapl/altera.c                       |    3 
 drivers/mtd/devices/spear_smi.c                          |   38 ++++++
 drivers/net/can/slcan.c                                  |    1 
 drivers/net/ethernet/cirrus/ep93xx_eth.c                 |    5 
 drivers/net/ethernet/intel/e100.c                        |    4 
 drivers/net/ethernet/stmicro/stmmac/common.h             |    2 
 drivers/net/ethernet/stmicro/stmmac/descs_com.h          |   14 +-
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c           |   10 +
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c          |   10 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c        |   16 +-
 drivers/net/ethernet/ti/cpsw.c                           |    2 
 drivers/net/wireless/ath/ar5523/ar5523.c                 |    3 
 drivers/net/wireless/iwlwifi/mvm/mac80211.c              |   15 ++
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c      |    9 -
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c      |    1 
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c     |   25 +++-
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.h     |    2 
 drivers/nfc/nxp-nci/i2c.c                                |    6 
 drivers/pci/msi.c                                        |    2 
 drivers/pci/quirks.c                                     |    2 
 drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c                 |   23 ++-
 drivers/pinctrl/samsung/pinctrl-s3c24xx.c                |    6 
 drivers/pinctrl/samsung/pinctrl-s3c64xx.c                |    3 
 drivers/pinctrl/samsung/pinctrl-samsung.c                |   10 +
 drivers/rtc/rtc-max8997.c                                |    2 
 drivers/s390/scsi/zfcp_dbf.c                             |    8 -
 drivers/s390/scsi/zfcp_erp.c                             |    3 
 drivers/scsi/lpfc/lpfc.h                                 |    3 
 drivers/scsi/lpfc/lpfc_attr.c                            |   12 +
 drivers/scsi/lpfc/lpfc_init.c                            |    3 
 drivers/scsi/qla2xxx/qla_attr.c                          |    3 
 drivers/scsi/qla2xxx/qla_bsg.c                           |   15 +-
 drivers/scsi/qla2xxx/qla_target.c                        |    7 -
 drivers/spi/spi-atmel.c                                  |    6 
 drivers/staging/iio/addac/adt7316-i2c.c                  |    2 
 drivers/staging/rtl8188eu/os_dep/usb_intf.c              |    2 
 drivers/staging/rtl8712/usb_intf.c                       |    2 
 drivers/thermal/thermal_core.c                           |    4 
 drivers/tty/serial/ifx6x60.c                             |    3 
 drivers/tty/serial/imx.c                                 |    2 
 drivers/tty/serial/msm_serial.c                          |    6 
 drivers/tty/serial/serial_core.c                         |    2 
 drivers/tty/vt/keyboard.c                                |    2 
 drivers/usb/atm/ueagle-atm.c                             |   18 +-
 drivers/usb/core/hub.c                                   |    5 
 drivers/usb/core/urb.c                                   |    1 
 drivers/usb/gadget/configfs.c                            |    1 
 drivers/usb/gadget/function/u_serial.c                   |    2 
 drivers/usb/host/xhci-hub.c                              |   16 +-
 drivers/usb/host/xhci-mem.c                              |    4 
 drivers/usb/host/xhci-pci.c                              |   13 ++
 drivers/usb/host/xhci-ring.c                             |    6 
 drivers/usb/host/xhci.c                                  |    7 -
 drivers/usb/host/xhci.h                                  |    2 
 drivers/usb/misc/adutux.c                                |    2 
 drivers/usb/misc/idmouse.c                               |    2 
 drivers/usb/mon/mon_bin.c                                |   32 +++--
 drivers/usb/serial/io_edgeport.c                         |   10 -
 drivers/vfio/pci/vfio_pci_intrs.c                        |    2 
 drivers/video/hdmi.c                                     |    8 -
 drivers/virtio/virtio_balloon.c                          |   11 +
 fs/autofs4/expire.c                                      |    5 
 fs/btrfs/file.c                                          |    2 
 fs/btrfs/free-space-cache.c                              |    6 
 fs/btrfs/volumes.h                                       |    1 
 fs/cifs/file.c                                           |   14 +-
 fs/cifs/smb2misc.c                                       |    7 -
 fs/dlm/lockspace.c                                       |    1 
 fs/dlm/memory.c                                          |    9 -
 fs/dlm/user.c                                            |    3 
 fs/fuse/dir.c                                            |   27 +++-
 fs/fuse/fuse_i.h                                         |    2 
 fs/nfsd/nfs4recover.c                                    |   17 --
 fs/nfsd/vfs.c                                            |   17 ++
 fs/ocfs2/quota_global.c                                  |    2 
 fs/proc/array.c                                          |   18 ++
 fs/quota/dquot.c                                         |   11 -
 include/linux/acpi.h                                     |    2 
 include/linux/atalk.h                                    |    2 
 include/linux/dma-mapping.h                              |    3 
 include/linux/init_task.h                                |    9 +
 include/linux/jbd2.h                                     |    4 
 include/linux/netdevice.h                                |    5 
 include/linux/quotaops.h                                 |   10 +
 include/linux/regulator/consumer.h                       |    2 
 include/linux/sched.h                                    |   52 ++++++++
 include/linux/serial_core.h                              |   37 +++++-
 include/linux/thread_info.h                              |    4 
 include/linux/time.h                                     |   12 +
 include/math-emu/soft-fp.h                               |    2 
 include/net/ip.h                                         |    5 
 include/net/tcp.h                                        |   18 ++
 init/Kconfig                                             |   10 +
 init/init_task.c                                         |    7 -
 kernel/cgroup_pids.c                                     |   11 -
 kernel/module.c                                          |    2 
 kernel/sched/fair.c                                      |   36 +++--
 kernel/sched/sched.h                                     |    4 
 kernel/workqueue.c                                       |   38 ++++--
 lib/raid6/unroll.awk                                     |    2 
 mm/shmem.c                                               |    2 
 net/appletalk/aarp.c                                     |   15 +-
 net/appletalk/ddp.c                                      |   21 ++-
 net/bridge/br_device.c                                   |    6 
 net/core/dev.c                                           |    3 
 net/ipv4/devinet.c                                       |    5 
 net/ipv4/ip_output.c                                     |   14 +-
 net/ipv4/tcp_output.c                                    |    5 
 net/ipv4/tcp_timer.c                                     |    2 
 net/sunrpc/cache.c                                       |    6 
 net/tipc/core.c                                          |   29 ++--
 net/x25/af_x25.c                                         |   18 +-
 scripts/mod/modpost.c                                    |   12 +
 sound/core/oss/linear.c                                  |    2 
 sound/core/oss/mulaw.c                                   |    2 
 sound/core/oss/route.c                                   |    2 
 sound/core/pcm_lib.c                                     |    8 -
 sound/pci/hda/hda_bind.c                                 |    4 
 sound/pci/hda/hda_intel.c                                |    3 
 sound/soc/soc-jack.c                                     |    3 
 180 files changed, 1021 insertions(+), 492 deletions(-)

Aaro Koskinen (5):
      MIPS: OCTEON: octeon-platform: fix typing
      ARM: OMAP1/2: fix SoC name printing
      MIPS: OCTEON: cvmx_pko_mem_debug8: use oldest forward compatible definition
      net: stmmac: use correct DMA buffer size in the RX descriptor
      net: stmmac: don't stop NAPI processing when dropping a packet

Al Viro (1):
      autofs: fix a leak in autofs_expire_indirect()

Alastair D'Silva (1):
      powerpc: Allow 64bit VDSO __kernel_sync_dicache to work across ranges >4GB

Aleksa Sarai (1):
      cgroup: pids: use atomic64_t for pids->limit

Alex Deucher (1):
      drm/radeon: fix r1xx/r2xx register checker for POT textures

Alexey Dobriyan (2):
      ACPI: fix acpi_find_child_device() invocation in acpi_preset_companion()
      proc: fix coredump vs read /proc/*/stat race

Andrei Otcheretianski (1):
      iwlwifi: mvm: Send non offchannel traffic via AP sta

Andy Lutomirski (3):
      sched/core: Allow putting thread_info into task_struct
      sched/core: Add try_get_task_stack() and put_task_stack()
      fs/proc: Stop reporting eip and esp in /proc/PID/stat

Bart Van Assche (2):
      scsi: qla2xxx: Fix qla24xx_process_bidir_cmd()
      scsi: qla2xxx: Always check the qla2x00_wait_for_hba_online() return value

Baruch Siach (1):
      rtc: dt-binding: abx80x: fix resistance scale

Brian Masney (1):
      pinctrl: qcom: ssbi-gpio: fix gpio-hog related boot issues

Chen Jun (1):
      mm/shmem.c: cast the type of unmap_start to u64

Chris Lesiak (1):
      iio: humidity: hdc100x: fix IIO_HUMIDITYRELATIVE channel reporting

Christian Lamparter (1):
      crypto: crypto4xx - fix double-free in crypto4xx_destroy_sdr

Christophe JAILLET (1):
      rtc: max8997: Fix the returned value in case of error in 'max8997_rtc_read_alarm()'

Chuhong Yuan (3):
      serial: ifx6x60: add missed pm_runtime_disable
      rsxx: add missed destroy_workqueue calls in remove
      net: ep93xx_eth: fix mismatch of request_mem_region in remove

Colin Ian King (1):
      altera-stapl: check for a null key before strcasecmp'ing it

Dan Carpenter (1):
      drm/i810: Prevent underflow in ioctl

Daniel Mack (1):
      ARM: dts: pxa: clean up USB controller nodes

David Hildenbrand (1):
      virtio-balloon: fix managed page counts when migrating pages between zones

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

Dmitry Torokhov (1):
      tty: vt: keyboard: reject invalid keycodes

Douglas Anderson (1):
      serial: core: Allow processing sysrq at port unlock time

Emiliano Ingrassia (1):
      usb: core: urb: fix URB structure initialization function

Eric Dumazet (2):
      tcp: md5: fix potential overestimation of TCP option space
      inet: protect against too small mtu values.

Filipe Manana (1):
      Btrfs: fix negative subv_writers counter and data space leak after buffered write

Finley Xiao (1):
      clk: rockchip: fix rk3188 sclk_smc gate data

Francesco Ruggeri (1):
      ACPI: OSL: only free map once in osl.c

Greg Kroah-Hartman (2):
      lib: raid6: fix awk build warnings
      Linux 4.4.207

Gregory CLEMENT (1):
      spi: atmel: Fix CS high support

Grygorii Strashko (1):
      net: ethernet: ti: cpsw: fix extra rx interrupt

Guillaume Nault (3):
      tcp: fix rejected syncookies due to stale timestamps
      tcp: tighten acceptance of ACKs not matching a child socket
      tcp: Protect accesses to .ts_recent_stamp with {READ,WRITE}_ONCE()

Hans de Goede (1):
      Input: goodix - add upside-down quirk for Teclast X89 tablet

Heiko Carstens (1):
      sched/core, x86: Make struct thread_info arch specific again

Heiko Stuebner (1):
      clk: rockchip: fix rk3188 sclk_mac_lbtest parameter ordering

Henry Lin (1):
      usb: xhci: only set D3hot for pci device

Himanshu Madhani (1):
      scsi: qla2xxx: Fix DMA unmap leak

Hou Tao (1):
      dm btree: increase rebalance threshold in __rebalance2()

James Smart (1):
      scsi: lpfc: Cap NPIV vports to 256

Jan Beulich (1):
      x86/apic/32: Avoid bogus LDR warnings

Jan Kara (1):
      jbd2: Fix possible overflow in jbd2_log_space_left()

Jarkko Nikula (1):
      ARM: dts: omap3-tao3530: Fix incorrect MMC card detection GPIO polarity

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

John Ogness (2):
      fs/proc: Report eip/esp in /prod/PID/stat for coredumping
      fs/proc/array.c: allow reporting eip/esp for all coredumping threads

Josef Bacik (1):
      btrfs: check page->mapping when loading free space cache

Jouni Hogander (1):
      can: slcan: Fix use-after-free Read in slcan_open

Kai-Heng Feng (3):
      x86/PCI: Avoid AMD FCH XHCI USB PME# from D0 defect
      usb: Allow USB device to be warm reset in suspended state
      xhci: Increase STS_HALT timeout in xhci_suspend()

Konstantin Khorenko (1):
      kernel/module.c: wakeup processes in module_wq on module unload

Krzysztof Kozlowski (3):
      pinctrl: samsung: Fix device node refcount leaks in S3C24xx wakeup controller init
      pinctrl: samsung: Fix device node refcount leaks in init code
      pinctrl: samsung: Fix device node refcount leaks in S3C64xx wakeup controller init

Larry Finger (3):
      rtlwifi: rtl8192de: Fix missing code to retrieve RX buffer address
      rtlwifi: rtl8192de: Fix missing callback that tests for hw release of buffer
      rtlwifi: rtl8192de: Fix missing enable interrupt flag

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

Martin Schiller (2):
      net/x25: fix called/calling length calculation in x25_parse_address_block
      net/x25: fix null_x25_address handling

Masahiro Yamada (1):
      kbuild: fix single target build for external module

Mathias Nyman (2):
      xhci: make sure interrupts are restored to correct state
      xhci: fix USB3 device initiated resume race with roothub autosuspend

Max Filippov (1):
      xtensa: fix TLB sanity checker

Michał Mirosław (1):
      usb: gadget: u_serial: add missing port entry locking

Mika Westerberg (1):
      xhci: Fix memory leak in xhci_add_in_port()

Miklos Szeredi (2):
      fuse: verify nlink
      fuse: verify attributes

Ming Lei (2):
      blk-mq: avoid sysfs buffer overflow with too many CPU cores
      blk-mq: make sure that line break can be printed

Miquel Raynal (1):
      mtd: spear_smi: Fix Write Burst mode

Navid Emamdoost (1):
      crypto: user - fix memory leak in crypto_report

Niklas Söderlund (1):
      dma-mapping: fix return type of dma_set_max_seg_size()

Nikolay Aleksandrov (1):
      net: bridge: deny dev_set_mac_address() when unregistering

Nuno Sá (1):
      iio: adis16480: Add debugfs_reg_access entry

Pan Bian (1):
      Input: cyttsp4_core - fix use after free bug

Paolo Bonzini (3):
      KVM: x86: do not modify masked bits of shared MSRs
      KVM: x86: fix presentation of TSX feature in ARCH_CAPABILITIES
      KVM: x86: fix out-of-bounds write in KVM_GET_EMULATED_CPUID (CVE-2019-19332)

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

Pete Zaitcev (1):
      usb: mon: Fix a deadlock in usbmon between mmap and read

Qian Cai (1):
      mlx4: Use snprintf instead of complicated strcpy

Qu Wenruo (1):
      btrfs: Remove btrfs_bio::flags member

Rafael J. Wysocki (1):
      ACPI: PM: Avoid attaching ACPI PM domain to certain devices

Rob Herring (1):
      ARM: dts: sunxi: Fix PMU compatible strings

Scott Mayhew (1):
      nfsd: fix a warning in __cld_pipe_upcall()

Shirish S (1):
      x86/MCE/AMD: Turn off MC4_MISC thresholding on all family 0x15 models

Shreeya Patel (1):
      Staging: iio: adt7316: Fix i2c data reading, set the data field

Stefan Agner (1):
      serial: imx: fix error handling in console_setup

Steffen Liebergeld (1):
      PCI: Fix Intel ACS quirk UPDCR register address

Steffen Maier (2):
      scsi: zfcp: drop default switch case which might paper over missing case
      scsi: zfcp: trace channel log even for FCP command responses

Stephan Gerhold (1):
      NFC: nxp-nci: Fix NULL pointer dereference after I2C communication error

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

Ville Syrjälä (1):
      video/hdmi: Fix AVI bar unpack

Vincent Chen (1):
      math-emu/soft-fp.h: (_FP_ROUND_ZERO) cast 0 to void to fix warning

Vincent Whitchurch (1):
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

Xuewei Zhang (1):
      sched/fair: Scale bandwidth quota and period without losing quota/period ratio precision

Yuchung Cheng (1):
      tcp: fix off-by-one bug on aborting window-probing socket

YueHaibing (3):
      appletalk: Fix potential NULL pointer dereference in unregister_snap_client
      appletalk: Set error code if register_snap_client failed
      e100: Fix passing zero to 'PTR_ERR' warning in e100_load_ucode_wait

Zhenzhong Duan (1):
      cpuidle: Do not unset the driver if it is there already

paulhsia (1):
      ALSA: pcm: Fix stream lock usage in snd_pcm_period_elapsed()

zhengbin (1):
      nfsd: Return EPERM, not EACCES, in some SETATTR cases

