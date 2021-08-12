Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4F03EA46C
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 14:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237320AbhHLMTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 08:19:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236349AbhHLMTh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Aug 2021 08:19:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E6C061077;
        Thu, 12 Aug 2021 12:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628770750;
        bh=tzCBHs+nT2TbHRmveFgUJJewalWCtTva00ApCDLPRuA=;
        h=From:To:Cc:Subject:Date:From;
        b=GJNyJPKZ38Altm2HVZ1dcUqV33iWcNQgJSv4XB2g3W6qhaMSZ/LjzflJNcbAUhga1
         yPuZT3w6jHJrm2Yrzkun4WKC9xoBFdmVYO4MrHEC3NOdRfGvl1Q0V0VKOR8Cp1iLSJ
         BvfgRApL8FL8bhb8QOWsHt1c52GkhCejpLpnsXsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.58
Date:   Thu, 12 Aug 2021 14:19:04 +0200
Message-Id: <1628770744124130@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.58 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                        |    2 
 arch/alpha/kernel/smp.c                                         |    2 
 arch/arm/boot/dts/am437x-l4.dtsi                                |    2 
 arch/arm/boot/dts/imx53-m53menlo.dts                            |    4 
 arch/arm/boot/dts/imx6qdl-sr-som.dtsi                           |    8 
 arch/arm/boot/dts/imx6ull-colibri-wifi.dtsi                     |    1 
 arch/arm/boot/dts/omap5-board-common.dtsi                       |    9 
 arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi                   |   24 +-
 arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi                    |    1 
 arch/arm/mach-imx/mmdc.c                                        |   17 +
 arch/arm/mach-omap2/omap_hwmod.c                                |   10 
 arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts |    2 
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi                  |    2 
 arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts          |    3 
 arch/arm64/include/asm/arch_timer.h                             |   21 --
 arch/arm64/include/asm/barrier.h                                |   19 +
 arch/arm64/include/asm/ptrace.h                                 |   12 +
 arch/arm64/include/asm/syscall.h                                |   19 -
 arch/arm64/include/asm/vdso/gettimeofday.h                      |    6 
 arch/arm64/kernel/ptrace.c                                      |    2 
 arch/arm64/kernel/signal.c                                      |    3 
 arch/arm64/kernel/stacktrace.c                                  |    2 
 arch/arm64/kernel/syscall.c                                     |    9 
 arch/mips/Makefile                                              |    2 
 arch/mips/include/asm/pgalloc.h                                 |   17 +
 arch/mips/mti-malta/malta-platform.c                            |    3 
 arch/x86/events/perf_event.h                                    |    3 
 arch/x86/kvm/mmu/mmu.c                                          |    2 
 arch/x86/kvm/x86.c                                              |   13 +
 block/blk-iolatency.c                                           |    6 
 drivers/acpi/acpica/nsrepair2.c                                 |    7 
 drivers/ata/libata-sff.c                                        |   35 ++-
 drivers/base/dd.c                                               |    4 
 drivers/base/firmware_loader/fallback.c                         |   14 -
 drivers/base/firmware_loader/firmware.h                         |   10 
 drivers/base/firmware_loader/main.c                             |    2 
 drivers/bus/ti-sysc.c                                           |   22 +-
 drivers/char/tpm/tpm_ftpm_tee.c                                 |    8 
 drivers/clk/clk-devres.c                                        |    9 
 drivers/clk/clk-stm32f4.c                                       |   10 
 drivers/clk/tegra/clk-sdmmc-mux.c                               |   10 
 drivers/dma/imx-dma.c                                           |    2 
 drivers/dma/stm32-dma.c                                         |    4 
 drivers/dma/stm32-dmamux.c                                      |    6 
 drivers/dma/uniphier-xdmac.c                                    |    4 
 drivers/fpga/dfl-fme-perf.c                                     |    2 
 drivers/gpio/gpio-mpc8xxx.c                                     |    2 
 drivers/gpio/gpio-tqmx86.c                                      |    6 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c               |    6 
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c                  |    7 
 drivers/gpu/drm/i915/i915_reg.h                                 |    2 
 drivers/infiniband/hw/mlx5/mr.c                                 |    4 
 drivers/interconnect/core.c                                     |    9 
 drivers/interconnect/qcom/icc-rpmh.c                            |   12 -
 drivers/md/raid1.c                                              |    2 
 drivers/md/raid10.c                                             |    4 
 drivers/media/common/videobuf2/videobuf2-core.c                 |   13 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c                         |   11 -
 drivers/net/dsa/qca/ar9331.c                                    |   14 +
 drivers/net/dsa/sja1105/sja1105_main.c                          |   85 ++++++--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c                 |    3 
 drivers/net/ethernet/freescale/fec_main.c                       |    2 
 drivers/net/ethernet/natsemi/natsemi.c                          |    8 
 drivers/net/ethernet/neterion/vxge/vxge-main.c                  |    6 
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c            |    2 
 drivers/net/ethernet/qlogic/qede/qede_filter.c                  |    4 
 drivers/net/ethernet/qlogic/qla3xxx.c                           |    6 
 drivers/net/phy/micrel.c                                        |   10 
 drivers/net/usb/pegasus.c                                       |   14 +
 drivers/net/wireless/virt_wifi.c                                |   52 +++--
 drivers/pcmcia/i82092.c                                         |    1 
 drivers/scsi/sr.c                                               |    2 
 drivers/soc/ixp4xx/ixp4xx-npe.c                                 |   11 -
 drivers/soc/ixp4xx/ixp4xx-qmgr.c                                |    9 
 drivers/spi/spi-imx.c                                           |   52 +++--
 drivers/spi/spi-meson-spicc.c                                   |    2 
 drivers/staging/rtl8712/hal_init.c                              |   30 +-
 drivers/staging/rtl8712/rtl8712_led.c                           |    8 
 drivers/staging/rtl8712/rtl871x_led.h                           |    1 
 drivers/staging/rtl8712/rtl871x_pwrctrl.c                       |    8 
 drivers/staging/rtl8712/rtl871x_pwrctrl.h                       |    1 
 drivers/staging/rtl8712/usb_intf.c                              |   51 ++---
 drivers/staging/rtl8723bs/hal/sdio_ops.c                        |    2 
 drivers/tee/optee/call.c                                        |   36 +++
 drivers/tee/optee/core.c                                        |   40 +++
 drivers/tee/optee/optee_private.h                               |    1 
 drivers/tee/optee/shm_pool.c                                    |   12 -
 drivers/tee/tee_shm.c                                           |   18 +
 drivers/tty/serial/8250/8250_mtk.c                              |    5 
 drivers/tty/serial/8250/8250_pci.c                              |    7 
 drivers/tty/serial/8250/8250_port.c                             |   12 -
 drivers/tty/serial/serial-tegra.c                               |    6 
 drivers/usb/cdns3/ep0.c                                         |    1 
 drivers/usb/class/usbtmc.c                                      |    9 
 drivers/usb/common/usb-otg-fsm.c                                |    6 
 drivers/usb/dwc3/gadget.c                                       |   11 +
 drivers/usb/gadget/function/f_hid.c                             |   44 +++-
 drivers/usb/gadget/udc/max3420_udc.c                            |   14 -
 drivers/usb/host/ohci-at91.c                                    |    9 
 drivers/usb/serial/ch341.c                                      |    1 
 drivers/usb/serial/ftdi_sio.c                                   |    1 
 drivers/usb/serial/ftdi_sio_ids.h                               |    3 
 drivers/usb/serial/option.c                                     |    2 
 drivers/usb/typec/tcpm/tcpm.c                                   |    4 
 fs/cifs/smb2ops.c                                               |    3 
 fs/ext4/namei.c                                                 |    2 
 fs/pipe.c                                                       |   19 +
 fs/reiserfs/stree.c                                             |   31 ++-
 fs/reiserfs/super.c                                             |    8 
 include/linux/tee_drv.h                                         |    1 
 include/linux/usb/otg-fsm.h                                     |    1 
 include/net/bluetooth/hci_core.h                                |    1 
 include/net/ip6_route.h                                         |    2 
 include/net/netns/xfrm.h                                        |    1 
 kernel/sched/core.c                                             |   90 +++-----
 kernel/time/timer.c                                             |    6 
 kernel/trace/trace.c                                            |    4 
 kernel/trace/trace_events_hist.c                                |   24 ++
 kernel/tracepoint.c                                             |  102 ++++++++--
 net/bluetooth/hci_core.c                                        |   16 -
 net/bluetooth/hci_sock.c                                        |   49 +++-
 net/bluetooth/hci_sysfs.c                                       |    3 
 net/ipv4/tcp_offload.c                                          |    3 
 net/ipv4/udp_offload.c                                          |    4 
 net/sched/sch_generic.c                                         |    2 
 net/sctp/auth.c                                                 |   14 -
 net/xfrm/xfrm_compat.c                                          |   49 ++++
 net/xfrm/xfrm_policy.c                                          |   17 -
 net/xfrm/xfrm_user.c                                            |   10 
 scripts/tracing/draw_functrace.py                               |    6 
 security/selinux/ss/policydb.c                                  |   10 
 sound/core/pcm_native.c                                         |    2 
 sound/core/seq/seq_ports.c                                      |   39 ++-
 sound/pci/hda/patch_realtek.c                                   |    2 
 sound/usb/card.c                                                |    2 
 sound/usb/clock.c                                               |    6 
 sound/usb/quirks.c                                              |    1 
 virt/kvm/kvm_main.c                                             |   18 +
 138 files changed, 1138 insertions(+), 489 deletions(-)

Aharon Landau (1):
      RDMA/mlx5: Delay emptying a cache entry when a new MR is added to it recently

Alex Deucher (1):
      drm/amdgpu/display: only enable aux backlight control for OLED panels

Alex Xu (Hello71) (1):
      pipe: increase minimum default pipe size to 2 pages

Alexander Monakov (1):
      ALSA: hda/realtek: add mic quirk for Acer SF314-42

Alexander Tsoy (1):
      ALSA: usb-audio: Add registration quirk for JBL Quantum 600

Allen Pais (1):
      optee: fix tee out of memory failure seen during kexec reboot

Andy Shevchenko (1):
      serial: 8250_pci: Enumerate Elkhart Lake UARTs via dedicated driver

Anirudh Rayabharam (2):
      firmware_loader: use -ETIMEDOUT instead of -EAGAIN in fw_load_sysfs_fallback
      firmware_loader: fix use-after-free in firmware_fallback_sysfs

Antoine Tenart (1):
      net: ipv6: fix returned variable type in ip6_skb_dst_mtu

Arnd Bergmann (2):
      soc: ixp4xx: fix printing resources
      soc: ixp4xx/qmgr: fix invalid __iomem access

Brian Norris (1):
      clk: fix leak on devm_clk_bulk_get_all() unwind

Christoph Hellwig (1):
      libata: fix ata_pio_sector for CONFIG_HIGHMEM

Claudiu Beznea (1):
      usb: host: ohci-at91: suspend/resume ports after/before OHCI accesses

Colin Ian King (2):
      ARM: imx: fix missing 3rd argument in macro imx_mmdc_perf_init
      interconnect: Fix undersized devress_alloc allocation

Dan Carpenter (1):
      bnx2x: fix an error code in bnx2x_nic_load()

Daniele Palmas (1):
      USB: serial: option: add Telit FD980 composition 0x1056

Dario Binacchi (2):
      clk: stm32f4: fix post divisor setup for I2S/SAI PLLs
      ARM: dts: am437x-l4: fix typo in can@0 node

David Bauer (1):
      USB: serial: ftdi_sio: add device ID for Auto-M3 OP-COM v2

Dmitry Osipenko (2):
      clk: tegra: Implement disable_unused() of tegra_clk_sdmmc_mux_ops
      usb: otg-fsm: Fix hrtimer list corruption

Dmitry Safonov (1):
      net/xfrm/compat: Copy xfrm_spdattr_type_t atributes

Dongliang Mu (1):
      spi: meson-spicc: fix memory leak in meson_spicc_remove

Fei Qin (1):
      nfp: update ethtool reporting of pauseframe control

Filip Schauer (1):
      drivers core: Fix oops when driver probe fails

Frederic Weisbecker (1):
      xfrm: Fix RCU vs hash_resize_mutex lock inversion

Greg Kroah-Hartman (1):
      Linux 5.10.58

H. Nikolaus Schaller (2):
      omap5-board-common: remove not physically existing vdds_1v8_main fixed-regulator
      mips: Fix non-POSIX regexp

Hans Verkuil (1):
      media: videobuf2-core: dequeue if start_streaming fails

Harshvardhan Jha (1):
      net: qede: Fix end of loop tests for list_for_each_entry

Huang Pei (1):
      MIPS: check return value of pgtable_pmd_page_ctor

Hui Su (1):
      scripts/tracing: fix the bug that can't parse raw_trace_func

Jakub Sitnicki (1):
      net, gro: Set inner transport header offset in tcp/udp GRO hook

Jaroslav Kysela (1):
      ALSA: pcm - fix mmap capability check for the snd-dummy driver

Jens Wiklander (1):
      tee: add tee_shm_alloc_kernel_buf()

Johan Hovold (1):
      media: rtl28xxu: fix zero-length control request

Jon Hunter (1):
      serial: tegra: Only print FIFO error message when an error occurs

Jonathan Gray (1):
      drm/i915: avoid uninitialised var in eb_parse()

Juergen Borleis (1):
      dmaengine: imx-dma: configure the generic DMA type to make it work

Kajol Jain (1):
      fpga: dfl: fme: Fix cpu hotplug issue in performance reporting

Kamal Agrawal (1):
      tracing: Fix NULL pointer dereference in start_creating

Kevin Hilman (1):
      bus: ti-sysc: AM3: RNG is GP only

Kunihiko Hayashi (1):
      dmaengine: uniphier-xdmac: Use readl_poll_timeout_atomic() in atomic state

Kyle Tso (1):
      usb: typec: tcpm: Keep other events when receiving FRS and Sourcing_vbus events

Letu Ren (1):
      net/qla3xxx: fix schedule while atomic in ql_wait_for_drvr_lock and ql_adapter_reset

Li Manyi (1):
      scsi: sr: Return correct event when media event code is 3

Like Xu (1):
      perf/x86/amd: Don't touch the AMD64_EVENTSEL_HOSTONLY bit inside the guest

Maciej W. Rozycki (2):
      serial: 8250: Mask out floating 16/32-bit bus bits
      MIPS: Malta: Do not byte-swap accesses to the CBUS UART

Marek Vasut (5):
      ARM: dts: imx: Swap M53Menlo pinctrl_power_button/pinctrl_power_out pins
      spi: imx: mx51-ecspi: Reinstate low-speed CONFIGREG delay
      spi: imx: mx51-ecspi: Fix low-speed CONFIGREG delay calculation
      ARM: dts: stm32: Disable LAN8710 EDPD on DHCOM
      ARM: dts: stm32: Fix touchscreen IRQ line assignment on DHCOM

Mario Kleiner (1):
      serial: 8250_pci: Avoid irq sharing for MSI(-X) interrupts.

Mark Rutland (2):
      arm64: stacktrace: avoid tracing arch_stack_walk()
      arm64: fix compat syscall return truncation

Masami Hiramatsu (1):
      tracing: Reject string operand in the histogram expression

Mathieu Desnoyers (2):
      tracepoint: static call: Compare data on transition from 2->1 callees
      tracepoint: Fix static call function vs data state mismatch

Matt Roper (1):
      drm/i915: Correct SFC_DONE register offset

Matteo Croce (1):
      virt_wifi: fix error on connect

Matthias Schiffer (1):
      gpio: tqmx86: really make IRQ optional

Maxim Devaev (2):
      usb: gadget: f_hid: added GET_IDLE and SET_IDLE handlers
      usb: gadget: f_hid: idle uses the highest byte for duration

Maxime Chevallier (1):
      ARM: dts: imx6qdl-sr-som: Increase the PHY reset duration to 10ms

Michael Walle (1):
      arm64: dts: ls1028: sl28: fix networking for variant 2

Mike Tipton (3):
      interconnect: Zero initial BW after sync-state
      interconnect: Always call pre_aggregate before aggregate
      interconnect: qcom: icc-rpmh: Ensure floor BW is enforced for all nodes

Nikos Liolios (1):
      ALSA: hda/realtek: Fix headset mic for Acer SWIFT SF314-56 (ALC256)

Oleksandr Suvorov (1):
      ARM: dts: colibri-imx6ull: limit SDIO clock to 25MHz

Oleksij Rempel (1):
      net: dsa: qca: ar9331: reorder MDIO write sequence

Pali Rohár (1):
      arm64: dts: armada-3720-turris-mox: remove mrvl,i2c-fast-mode

Paolo Bonzini (2):
      KVM: x86: accept userspace interrupt only if no event is injected
      KVM: Do not leak memory for duplicate debugfs directories

Pavel Skripkin (6):
      net: xfrm: fix memory leak in xfrm_user_rcv_msg
      net: pegasus: fix uninit-value in get_interrupt_interval
      net: fec: fix use-after-free in fec_drv_remove
      net: vxge: fix use-after-free in vxge_device_unregister
      staging: rtl8712: get rid of flush_scheduled_work
      staging: rtl8712: error handling refactoring

Pawel Laszczak (1):
      usb: cdns3: Fixed incorrect gadget state

Peter Zijlstra (1):
      sched/rt: Fix double enqueue caused by rt_effective_prio

Phil Elwell (1):
      usb: gadget: f_hid: fixed NULL pointer dereference

Prarit Bhargava (1):
      alpha: Send stop IPI to send to online CPUs

Qiang.zhang (1):
      USB: usbtmc: Fix RCU stall warning

Rafael J. Wysocki (1):
      Revert "ACPICA: Fix memory leak caused by _CID repair function"

Rasmus Villemoes (1):
      Revert "gpio: mpc8xxx: change the gpio interrupt flags."

Sean Christopherson (1):
      KVM: x86/mmu: Fix per-cpu counter corruption on 32-bit builds

Shirish S (1):
      drm/amdgpu/display: fix DMUB firmware version info

Shreyansh Chouhan (1):
      reiserfs: check directory items on read from disk

Steve Bennett (1):
      net: phy: micrel: Fix detection of ksz87xx switch

Steve French (1):
      smb3: rc uninitialized in one fallocate path

Steven Rostedt (VMware) (1):
      tracing / histogram: Give calculation hist_fields a size

Takashi Iwai (2):
      ALSA: seq: Fix racy deletion of subscriber
      ALSA: usb-audio: Fix superfluous autosuspend recovery

Tero Kristo (1):
      ARM: omap2+: hwmod: fix potential NULL pointer access

Tetsuo Handa (1):
      Bluetooth: defer cleanup of resources in hci_unregister_dev()

Theodore Ts'o (1):
      ext4: fix potential htree corruption when growing large_dir directories

Thomas Gleixner (1):
      timers: Move clearing of base::timer_running under base:: Lock

Tony Lindgren (1):
      bus: ti-sysc: Fix gpt12 system timer issue with reserved status

Tyler Hicks (4):
      optee: Clear stale cache entries during initialization
      optee: Fix memory leak when failing to register shm pages
      optee: Refuse to load the driver under the kdump kernel
      tpm_ftpm_tee: Free and unregister TEE shared memory during kexec

Vladimir Oltean (6):
      arm64: dts: ls1028a: fix node name for the sysclk
      arm64: dts: armada-3720-turris-mox: fixed indices for the SDHC controllers
      net: dsa: sja1105: overwrite dynamic FDB entries with static ones in .port_fdb_add
      net: dsa: sja1105: invalidate dynamic FDB entries learned concurrently with statically added ones
      net: dsa: sja1105: be stateless with FDB entries on SJA1105P/Q/R/S/SJA1110 too
      net: dsa: sja1105: match FDB entries regardless of inner/outer VLAN tag

Wang Hai (1):
      net: natsemi: Fix missing pci_disable_device() in probe and remove

Wei Shuyu (1):
      md/raid10: properly indicate failure when ending a failed write request

Wesley Cheng (1):
      usb: dwc3: gadget: Avoid runtime resume if disabling pullup

Will Deacon (1):
      arm64: vdso: Avoid ISB after reading from cntvct_el0

Willy Tarreau (1):
      USB: serial: ch341: fix character loss at high transfer rates

Xiangyang Zhang (1):
      staging: rtl8723bs: Fix a resource leak in sd_int_dpc

Xin Long (1):
      sctp: move the active_key update after sh_keys is added

Xiu Jianfeng (1):
      selinux: correct the return value when loads initial sids

Yang Yingliang (2):
      ARM: imx: add missing iounmap()
      ARM: imx: add missing clk_disable_unprepare()

Yu Kuai (2):
      blk-iolatency: error out if blk_get_queue() failed in iolatency_set_limit()
      reiserfs: add check for root_inode in reiserfs_fill_super

Yunsheng Lin (1):
      net: sched: fix lockdep_set_class() typo error for sch->seqlock

Zhang Qilong (3):
      dmaengine: stm32-dma: Fix PM usage counter imbalance in stm32 dma ops
      dmaengine: stm32-dmamux: Fix PM usage counter unbalance in stm32 dmamux ops
      usb: gadget: remove leaked entry from udc driver list

Zheyu Ma (1):
      pcmcia: i82092: fix a null pointer dereference bug

Zhiyong Tao (1):
      serial: 8250_mtk: fix uart corruption issue when rx power off

chihhao.chen (1):
      ALSA: usb-audio: fix incorrect clock source setting

