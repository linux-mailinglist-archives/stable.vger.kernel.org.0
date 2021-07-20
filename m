Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9093CFC45
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 16:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239098AbhGTNr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 09:47:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239593AbhGTNpH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Jul 2021 09:45:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF87161186;
        Tue, 20 Jul 2021 14:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626791144;
        bh=VKA4Uyxbkn59m4bZtg/gLVJ0P3Tzy9RzHiOKmGJrjuw=;
        h=From:To:Cc:Subject:Date:From;
        b=cm6GKEbJYN5SyHUyfzk08g5fLRjVrUY3Sup6QEARHYRGR8ng2hPAbe0B4y5hMUhxD
         6vttlGGIePG0qCyolWlr8NHH1nLUTATIt0Ig//4iSF41NjknaPqxftT0piCpMRN0Ed
         ZpWcXVe2dNEzN00W3o29cAyV7kV+BYpDVgVX1eWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.134
Date:   Tue, 20 Jul 2021 16:25:40 +0200
Message-Id: <162679114025167@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.134 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                  |    2 
 arch/arm/boot/dts/am335x-cm-t335.dts                      |    2 
 arch/arm/boot/dts/am43x-epos-evm.dts                      |    4 
 arch/arm/boot/dts/bcm5301x.dtsi                           |   18 +-
 arch/arm/boot/dts/exynos5422-odroidhc1.dts                |    2 
 arch/arm/boot/dts/exynos5422-odroidxu4.dts                |    2 
 arch/arm/boot/dts/exynos54xx-odroidxu-leds.dtsi           |    4 
 arch/arm/boot/dts/gemini-rut1xx.dts                       |   12 -
 arch/arm/boot/dts/imx6q-dhcom-som.dtsi                    |   41 ++++
 arch/arm/boot/dts/r8a7779-marzen.dts                      |    2 
 arch/arm/boot/dts/r8a7779.dtsi                            |    1 
 arch/arm/mach-exynos/exynos.c                             |    2 
 arch/arm/probes/kprobes/test-thumb.c                      |   10 -
 arch/arm64/boot/dts/renesas/r8a77970-v3msk.dts            |    2 
 arch/hexagon/kernel/vmlinux.lds.S                         |    7 
 arch/mips/boot/compressed/Makefile                        |    4 
 arch/mips/boot/compressed/decompress.c                    |    2 
 arch/mips/include/asm/vdso/vdso.h                         |    2 
 arch/powerpc/boot/devtree.c                               |   59 +++---
 arch/powerpc/boot/ns16550.c                               |    9 -
 arch/powerpc/include/asm/ps3.h                            |    2 
 arch/powerpc/platforms/ps3/mm.c                           |   12 +
 arch/s390/boot/ipl_parm.c                                 |   19 +-
 arch/s390/boot/mem_detect.c                               |   47 +++--
 arch/s390/include/asm/processor.h                         |    4 
 arch/s390/kernel/setup.c                                  |    2 
 arch/um/drivers/chan_user.c                               |    3 
 arch/um/drivers/slip_user.c                               |    3 
 arch/x86/include/asm/fpu/internal.h                       |   19 +-
 arch/x86/kernel/fpu/regset.c                              |    2 
 arch/x86/kernel/signal.c                                  |   24 ++
 arch/x86/kvm/cpuid.c                                      |    8 
 arch/x86/kvm/x86.c                                        |    2 
 drivers/acpi/acpi_amba.c                                  |    1 
 drivers/acpi/acpi_video.c                                 |    9 +
 drivers/block/virtio_blk.c                                |    2 
 drivers/char/virtio_console.c                             |    4 
 drivers/dma/fsl-qdma.c                                    |    6 
 drivers/firmware/arm_scmi/driver.c                        |    4 
 drivers/firmware/tegra/bpmp-tegra210.c                    |    2 
 drivers/firmware/turris-mox-rwtm.c                        |   53 +++++-
 drivers/gpio/gpio-pca953x.c                               |    1 
 drivers/gpio/gpio-zynq.c                                  |    5 
 drivers/hwtracing/intel_th/core.c                         |   17 +
 drivers/hwtracing/intel_th/gth.c                          |   16 +
 drivers/hwtracing/intel_th/intel_th.h                     |    3 
 drivers/i2c/i2c-core-base.c                               |    3 
 drivers/iio/gyro/fxas21002c_core.c                        |   11 -
 drivers/iio/magnetometer/bmc150_magn.c                    |   10 -
 drivers/input/touchscreen/hideep.c                        |   13 +
 drivers/iommu/arm-smmu.c                                  |   10 -
 drivers/memory/atmel-ebi.c                                |    4 
 drivers/memory/fsl_ifc.c                                  |    8 
 drivers/memory/pl353-smc.c                                |    1 
 drivers/mfd/da9052-i2c.c                                  |    1 
 drivers/mfd/motorola-cpcap.c                              |    4 
 drivers/mfd/stmpe-i2c.c                                   |    2 
 drivers/misc/cardreader/alcor_pci.c                       |    8 
 drivers/misc/ibmasm/module.c                              |    5 
 drivers/net/ethernet/moxa/moxart_ether.c                  |    4 
 drivers/net/virtio_net.c                                  |   27 ++-
 drivers/nvme/target/tcp.c                                 |    1 
 drivers/pci/controller/pci-tegra.c                        |    1 
 drivers/pci/controller/pcie-iproc-msi.c                   |   29 ++-
 drivers/pci/p2pdma.c                                      |   34 +++
 drivers/pci/pci-label.c                                   |    2 
 drivers/power/reset/gpio-poweroff.c                       |    1 
 drivers/power/supply/Kconfig                              |    3 
 drivers/power/supply/ab8500_btemp.c                       |    1 
 drivers/power/supply/ab8500_charger.c                     |   19 ++
 drivers/power/supply/ab8500_fg.c                          |    1 
 drivers/power/supply/charger-manager.c                    |    1 
 drivers/power/supply/max17042_battery.c                   |    2 
 drivers/power/supply/rt5033_battery.c                     |    7 
 drivers/power/supply/sc2731_charger.c                     |    1 
 drivers/power/supply/sc27xx_fuel_gauge.c                  |    1 
 drivers/pwm/pwm-img.c                                     |    2 
 drivers/pwm/pwm-imx1.c                                    |    2 
 drivers/pwm/pwm-spear.c                                   |    4 
 drivers/pwm/pwm-tegra.c                                   |   13 -
 drivers/reset/core.c                                      |    5 
 drivers/reset/reset-a10sr.c                               |    1 
 drivers/reset/reset-brcmstb.c                             |    1 
 drivers/rtc/proc.c                                        |    4 
 drivers/s390/char/sclp_vt220.c                            |    4 
 drivers/scsi/be2iscsi/be_main.c                           |    5 
 drivers/scsi/bnx2i/bnx2i_iscsi.c                          |    2 
 drivers/scsi/cxgbi/libcxgbi.c                             |    4 
 drivers/scsi/device_handler/scsi_dh_alua.c                |   11 -
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c                    |   12 -
 drivers/scsi/hosts.c                                      |    4 
 drivers/scsi/libiscsi.c                                   |  122 ++++++--------
 drivers/scsi/lpfc/lpfc_els.c                              |    9 +
 drivers/scsi/lpfc/lpfc_sli.c                              |    5 
 drivers/scsi/megaraid/megaraid_sas.h                      |   12 +
 drivers/scsi/megaraid/megaraid_sas_base.c                 |   96 ++++++++++-
 drivers/scsi/megaraid/megaraid_sas_fp.c                   |    6 
 drivers/scsi/megaraid/megaraid_sas_fusion.c               |   10 -
 drivers/scsi/qedi/qedi_fw.c                               |    2 
 drivers/scsi/qedi/qedi_main.c                             |    2 
 drivers/scsi/scsi_transport_iscsi.c                       |   12 +
 drivers/staging/rtl8723bs/hal/odm.h                       |    5 
 drivers/thermal/rcar_gen3_thermal.c                       |    2 
 drivers/tty/serial/8250/serial_cs.c                       |   11 +
 drivers/tty/serial/fsl_lpuart.c                           |    3 
 drivers/tty/serial/uartlite.c                             |   27 ---
 drivers/usb/gadget/function/f_hid.c                       |    2 
 drivers/usb/gadget/legacy/hid.c                           |    4 
 drivers/video/backlight/lm3630a_bl.c                      |   12 -
 drivers/video/fbdev/core/fbmem.c                          |   12 -
 drivers/w1/slaves/w1_ds2438.c                             |    4 
 drivers/watchdog/aspeed_wdt.c                             |    2 
 drivers/watchdog/iTCO_wdt.c                               |   12 +
 drivers/watchdog/imx_sc_wdt.c                             |   11 -
 drivers/watchdog/lpc18xx_wdt.c                            |    2 
 drivers/watchdog/sbc60xxwdt.c                             |    2 
 drivers/watchdog/sc520_wdt.c                              |    2 
 drivers/watchdog/w83877f_wdt.c                            |    2 
 fs/ceph/addr.c                                            |   10 -
 fs/f2fs/super.c                                           |    1 
 fs/jfs/jfs_logmgr.c                                       |    1 
 fs/nfs/inode.c                                            |    4 
 fs/nfs/nfs3proc.c                                         |    4 
 fs/nfs/nfs4client.c                                       |   82 ++++-----
 fs/nfs/pnfs_nfs.c                                         |   52 ++---
 fs/orangefs/super.c                                       |    2 
 fs/seq_file.c                                             |    3 
 fs/ubifs/dir.c                                            |    7 
 include/linux/nfs_fs.h                                    |    1 
 include/linux/sched/signal.h                              |   19 +-
 include/scsi/libiscsi.h                                   |   11 -
 include/scsi/scsi_transport_iscsi.h                       |    2 
 kernel/cgroup/cgroup-v1.c                                 |    2 
 kernel/rcu/rcu.h                                          |    2 
 kernel/rcu/srcutree.c                                     |    3 
 kernel/rcu/tree.c                                         |   16 +
 kernel/trace/trace_events_hist.c                          |    6 
 lib/decompress_unlz4.c                                    |    8 
 sound/ac97/bus.c                                          |    2 
 sound/firewire/Kconfig                                    |    5 
 sound/firewire/bebob/bebob.c                              |    5 
 sound/firewire/oxfw/oxfw.c                                |    2 
 sound/isa/cmi8330.c                                       |    2 
 sound/isa/sb/sb16_csp.c                                   |    8 
 sound/pci/hda/hda_tegra.c                                 |    3 
 sound/ppc/powermac.c                                      |    6 
 sound/soc/img/img-i2s-in.c                                |    2 
 sound/soc/intel/boards/kbl_da7219_max98357a.c             |    4 
 sound/soc/intel/common/soc-acpi-intel-kbl-match.c         |    2 
 sound/soc/soc-core.c                                      |    2 
 sound/usb/mixer_scarlett_gen2.c                           |   39 ++--
 sound/usb/usx2y/usb_stream.c                              |    7 
 tools/testing/selftests/powerpc/pmu/ebb/no_handler_test.c |    2 
 tools/testing/selftests/timers/rtcpie.c                   |   10 +
 virt/kvm/coalesced_mmio.c                                 |    2 
 155 files changed, 978 insertions(+), 498 deletions(-)

Alexander Shishkin (1):
      intel_th: Wait until port is in reset before programming it

Arnd Bergmann (1):
      mips: always link byteswap helpers into decompressor

Aswath Govindraju (2):
      ARM: dts: am335x: align ti,pindir-d0-out-d1-in property with dt-shema
      ARM: dts: am437x: align ti,pindir-d0-out-d1-in property with dt-shema

Athira Rajeev (1):
      selftests/powerpc: Fix "no_handler" EBB selftest

Benjamin Herrenschmidt (1):
      powerpc/boot: Fixup device-tree on little endian

Bixuan Cui (1):
      power: reset: gpio-poweroff: add missing MODULE_DEVICE_TABLE

Chandrakanth Patil (2):
      scsi: megaraid_sas: Fix resource leak in case of probe failure
      scsi: megaraid_sas: Handle missing interrupts while re-enabling IRQs

Chang S. Bae (1):
      x86/signal: Detect and prevent an alternate signal stack overflow

Chao Yu (1):
      f2fs: add MODULE_SOFTDEP to ensure crc32 is included in the initramfs

Christian Brauner (1):
      cgroup: verify that source is a string

Christoph Niedermaier (3):
      ARM: dts: imx6q-dhcom: Fix ethernet reset time properties
      ARM: dts: imx6q-dhcom: Fix ethernet plugin detection problems
      ARM: dts: imx6q-dhcom: Add gpios pinctrl for i2c bus recovery

Christophe JAILLET (2):
      tty: serial: 8250: serial_cs: Fix a memory leak in error handling path
      scsi: be2iscsi: Fix an error handling path in beiscsi_dev_probe()

Corentin Labbe (1):
      ARM: dts: gemini-rut1xx: remove duplicate ethernet node

Cristian Marussi (1):
      firmware: arm_scmi: Reset Rx buffer to max size during async commands

Dan Carpenter (2):
      rtc: fix snprintf() checking in is_rtc_hctosys()
      scsi: scsi_dh_alua: Fix signedness bug in alua_rtpg()

Daniel Mack (1):
      serial: tty: uartlite: fix console setup

Dimitri John Ledkov (1):
      lib/decompress_unlz4.c: correctly handle zero-padding around initrds.

Dmitry Torokhov (1):
      i2c: core: Disable client irq on reboot/shutdown

Eric Sandeen (1):
      seq_file: disallow extremely large seq buffer allocations

Fabio Aiuto (1):
      staging: rtl8723bs: fix macro value for 2.4Ghz only device

Frederic Weisbecker (1):
      srcu: Fix broken node geometry after early ssp init

Gao Xiang (1):
      nfs: fix acl memory leak of posix_acl_create()

Geert Uytterhoeven (1):
      ARM: dts: r8a7779, marzen: Fix DU clock names

Geoff Levand (1):
      powerpc/ps3: Add dma_mask to ps3_dma_region

Geoffrey D. Bennett (4):
      ALSA: usb-audio: scarlett2: Fix 18i8 Gen 2 PCM Input count
      ALSA: usb-audio: scarlett2: Fix data_mutex lock
      ALSA: usb-audio: scarlett2: Fix scarlett2_*_ctl_put() return values
      ALSA: usb-audio: scarlett2: Fix 6i6 Gen 2 line out descriptions

Greg Kroah-Hartman (1):
      Linux 5.4.134

Hannes Reinecke (1):
      scsi: scsi_dh_alua: Check for negative result value

Hans de Goede (1):
      ACPI: video: Add quirk for the Dell Vostro 3350

Heiko Carstens (4):
      s390/processor: always inline stap() and __load_psw_mask()
      s390/ipl_parm: fix program check new psw handling
      s390/mem_detect: fix diag260() program check new psw handling
      s390/mem_detect: fix tprot() program check new psw handling

James Smart (2):
      scsi: lpfc: Fix "Unexpected timeout" error in direct attach topology
      scsi: lpfc: Fix crash when lpfc_sli4_hba_setup() fails to initialize the SGLs

Jan Kiszka (1):
      watchdog: iTCO_wdt: Account for rebooting on second timeout

Jeff Layton (1):
      ceph: remove bogus checks and WARN_ONs from ceph_set_page_dirty

Jiajun Cao (1):
      ALSA: hda: Add IRQ check for platform_get_irq()

Jiapeng Chong (1):
      fs/jfs: Fix missing error code in lmLogInit()

John Garry (1):
      scsi: core: Cap scsi_host cmd_per_lun at can_queue

Jonathan Cameron (2):
      iio: gyro: fxa21002c: Balance runtime pm + use pm_runtime_resume_and_get().
      iio: magn: bmc150: Balance runtime pm + use pm_runtime_resume_and_get()

Kashyap Desai (1):
      scsi: megaraid_sas: Early detection of VD deletion through RaidMap update

Kefeng Wang (1):
      KVM: mmio: Fix use-after-free Read in kvm_vm_ioctl_unregister_coalesced_mmio

Krzysztof Kozlowski (9):
      power: supply: max17042: Do not enforce (incorrect) interrupt trigger type
      reset: a10sr: add missing of_match_table reference
      ARM: exynos: add missing of_node_put for loop iteration
      ARM: dts: exynos: fix PWM LED max brightness on Odroid XU/XU3
      ARM: dts: exynos: fix PWM LED max brightness on Odroid HC1
      ARM: dts: exynos: fix PWM LED max brightness on Odroid XU4
      memory: atmel-ebi: add missing of_node_put for loop iteration
      memory: fsl_ifc: fix leak of IO mapping on probe failure
      memory: fsl_ifc: fix leak of private memory on probe failure

Krzysztof Wilczyński (1):
      PCI/sysfs: Fix dsm_label_utf16s_to_utf8s() buffer overrun

Lai Jiangshan (1):
      KVM: X86: Disable hardware breakpoints unconditionally before kvm_x86->run()

Liguang Zhang (1):
      ACPI: AMBA: Fix resource name in /proc/iomem

Linus Walleij (1):
      power: supply: ab8500: Avoid NULL pointers

Logan Gunthorpe (1):
      PCI/P2PDMA: Avoid pci_get_slot(), which may sleep

Luiz Sampaio (1):
      w1: ds2438: fixing bug that would always get page0

Lv Yunlong (1):
      misc/libmasm/module: Fix two use after free in ibmasm_init_one

Marek Behún (2):
      firmware: turris-mox-rwtm: fix reply status decoding function
      firmware: turris-mox-rwtm: report failures better

Martin Fäcknitz (1):
      MIPS: vdso: Invalid GIC access through VDSO

Maurizio Lombardi (1):
      nvme-tcp: can't set sk_user_data without write_lock

Michael S. Tsirkin (1):
      virtio_net: move tx vq operation under tx queue lock

Mike Christie (4):
      scsi: iscsi: Add iscsi_cls_conn refcount helpers
      scsi: iscsi: Fix conn use after free during resets
      scsi: iscsi: Fix shost->max_id use
      scsi: qedi: Fix null ref during abort handling

Mike Marshall (1):
      orangefs: fix orangefs df output.

Nathan Chancellor (1):
      hexagon: use common DISCARDS macro

Nick Desaulniers (1):
      ARM: 9087/1: kprobes: test-thumb: fix for LLVM_IAS=1

Niklas Söderlund (1):
      thermal/drivers/rcar_gen3_thermal: Fix coefficient calculations

Pali Rohár (1):
      firmware: turris-mox-rwtm: fail probing when firmware does not support hwrng

Peter Robinson (1):
      gpio: pca953x: Add support for the On Semi pca9655

Philipp Zabel (1):
      reset: bail if try_module_get() fails

Pierre-Louis Bossart (1):
      ASoC: Intel: kbl_da7219_max98357a: shrink platform_id below 20 characters

Po-Hsu Lin (1):
      selftests: timers: rtcpie: skip test if default RTC device does not exist

Rafał Miłecki (1):
      ARM: dts: BCM5301X: Fixup SPI binding

Randy Dunlap (1):
      mips: disable branch profiling in boot/decompress.o

Robin Gong (1):
      dmaengine: fsl-qdma: check dma_set_mask return value

Ruslan Bilovol (1):
      usb: gadget: f_hid: fix endianness issue with descriptors

Sandor Bodo-Merle (2):
      PCI: iproc: Fix multi-MSI base vector number allocation
      PCI: iproc: Support multi-MSI only on uniprocessor kernel

Sean Christopherson (1):
      KVM: x86: Use guest MAXPHYADDR from CPUID.0x8000_0008 iff TDP is enabled

Sergey Shtylyov (1):
      scsi: hisi_sas: Propagate errors in interrupt_init_v1_hw()

Sherry Sun (1):
      tty: serial: fsl_lpuart: fix the potential risk of division or modulo by zero

Srinivas Neeli (1):
      gpio: zynq: Check return value of pm_runtime_get_sync

Stefan Eichenberger (1):
      watchdog: imx_sc_wdt: fix pretimeout

Stephan Gerhold (1):
      power: supply: rt5033_battery: Fix device tree enumeration

Steven Rostedt (VMware) (1):
      tracing: Do not reference char * as a string in histograms

Takashi Iwai (2):
      ALSA: usx2y: Don't call free_pages_exact() with NULL address
      ALSA: sb: Fix potential double-free of CSP mixer elements

Takashi Sakamoto (2):
      Revert "ALSA: bebob/oxfw: fix Kconfig entry for Mackie d.2 Pro"
      ALSA: bebob: add support for ToneWeal FW66

Tao Ren (1):
      watchdog: aspeed: fix hardware timeout calculation

Thomas Gleixner (2):
      x86/fpu: Return proper error codes from user access functions
      x86/fpu: Limit xstate copy size in xstateregs_set()

Tong Zhang (2):
      misc: alcor_pci: fix null-ptr-deref when there is no PCI bridge
      misc: alcor_pci: fix inverted branch condition

Tony Lindgren (1):
      mfd: cpcap: Fix cpcap dmamask not set warnings

Trond Myklebust (3):
      NFS: nfs_find_open_context() may only select open files
      NFSv4: Initialise connection to the server in nfs4_alloc_client()
      NFSv4/pNFS: Don't call _nfs4_pnfs_v3_ds_connect multiple times

Tyrel Datwyler (1):
      scsi: core: Fix bad pointer dereference when ehandler kthread is invalid

Uwe Kleine-König (4):
      backlight: lm3630a: Fix return code of .update_status() callback
      pwm: spear: Don't modify HW state in .remove callback
      pwm: tegra: Don't modify HW state in .remove callback
      pwm: imx1: Don't disable clocks at device remove time

Valentin Vidic (1):
      s390/sclp_vt220: fix console name to match device

Valentine Barshak (1):
      arm64: dts: renesas: v3msk: Fix memory size

Xie Yongji (3):
      virtio-blk: Fix memory leak among suspend/resume procedure
      virtio_net: Fix error handling in virtnet_restore()
      virtio_console: Assure used length from device is limited

Xiyu Yang (2):
      iommu/arm-smmu: Fix arm_smmu_device refcount leak when arm_smmu_rpm_get fails
      iommu/arm-smmu: Fix arm_smmu_device refcount leak in address translation

Yang Yingliang (3):
      net: moxa: Use devm_platform_get_and_ioremap_resource()
      ALSA: ppc: fix error return code in snd_pmac_probe()
      usb: gadget: hid: fix error return code in hid_bind()

Yizhuo Zhai (1):
      Input: hideep - fix the uninitialized use in hideep_nvm_unlock()

Yufen Yu (2):
      ALSA: ac97: fix PM reference leak in ac97_bus_remove()
      ASoC: img: Fix PM reference leak in img_i2s_in_probe()

Zhen Lei (7):
      fbmem: Do not delete the mode that is still in use
      ASoC: soc-core: Fix the error return code in snd_soc_of_parse_audio_routing()
      um: fix error return code in slip_open()
      um: fix error return code in winch_tramp()
      ALSA: isa: Fix error return code in snd_cmi8330_probe()
      memory: pl353: Fix error return code in pl353_smc_probe()
      firmware: tegra: Fix error return code in tegra210_bpmp_init()

Zhihao Cheng (1):
      ubifs: Set/Clear I_LINKABLE under i_lock for whiteout inode

Zou Wei (11):
      mfd: da9052/stmpe: Add and modify MODULE_DEVICE_TABLE
      power: supply: sc27xx: Add missing MODULE_DEVICE_TABLE
      power: supply: sc2731_charger: Add missing MODULE_DEVICE_TABLE
      watchdog: Fix possible use-after-free in wdt_startup()
      watchdog: sc520_wdt: Fix possible use-after-free in wdt_turnoff()
      watchdog: Fix possible use-after-free by calling del_timer_sync()
      PCI: tegra: Add missing MODULE_DEVICE_TABLE
      power: supply: charger-manager: add missing MODULE_DEVICE_TABLE
      power: supply: ab8500: add missing MODULE_DEVICE_TABLE
      pwm: img: Fix PM reference leak in img_pwm_enable()
      reset: brcmstb: Add missing MODULE_DEVICE_TABLE

