Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F8A3E7EC5
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhHJRfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:35:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:38896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232387AbhHJRef (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:34:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EAD361051;
        Tue, 10 Aug 2021 17:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616852;
        bh=7yw3vUH1yA1IGoeBd+yyzYPLM0S4PgMbPtUnYDs0m1M=;
        h=From:To:Cc:Subject:Date:From;
        b=wCfLFni66RAF+UFXRO8ZmTHg18COsAjgbWXw8CC9YYQedtCFWdadK22CbOX0QPZbY
         OTxUi2kojEdKqE6VMzUKrV6vMLrqilzoi1Rq/hCXHK7/DLHhmW5j5cahfGTZKsJlkU
         FONSFxdr6QLJ9xoY8qXL+WglhEjpCbpdm1TD37pU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/85] 5.4.140-rc1 review
Date:   Tue, 10 Aug 2021 19:29:33 +0200
Message-Id: <20210810172948.192298392@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.140-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.140-rc1
X-KernelTest-Deadline: 2021-08-12T17:29+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.140 release.
There are 85 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 12 Aug 2021 17:29:30 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.140-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.140-rc1

Mark Rutland <mark.rutland@arm.com>
    arm64: fix compat syscall return truncation

Letu Ren <fantasquex@gmail.com>
    net/qla3xxx: fix schedule while atomic in ql_wait_for_drvr_lock and ql_adapter_reset

Prarit Bhargava <prarit@redhat.com>
    alpha: Send stop IPI to send to online CPUs

Matteo Croce <mcroce@microsoft.com>
    virt_wifi: fix error on connect

Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
    reiserfs: check directory items on read from disk

Yu Kuai <yukuai3@huawei.com>
    reiserfs: add check for root_inode in reiserfs_fill_super

Christoph Hellwig <hch@lst.de>
    libata: fix ata_pio_sector for CONFIG_HIGHMEM

Daniel Borkmann <daniel@iogearbox.net>
    bpf, selftests: Adjust few selftest result_unpriv outcomes

Like Xu <likexu@tencent.com>
    perf/x86/amd: Don't touch the AMD64_EVENTSEL_HOSTONLY bit inside the guest

Arnd Bergmann <arnd@arndb.de>
    soc: ixp4xx/qmgr: fix invalid __iomem access

Dongliang Mu <mudongliangabcd@gmail.com>
    spi: meson-spicc: fix memory leak in meson_spicc_remove

Arnd Bergmann <arnd@arndb.de>
    soc: ixp4xx: fix printing resources

Will Deacon <will@kernel.org>
    arm64: vdso: Avoid ISB after reading from cntvct_el0

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Fix per-cpu counter corruption on 32-bit builds

Paolo Bonzini <pbonzini@redhat.com>
    KVM: Do not leak memory for duplicate debugfs directories

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: accept userspace interrupt only if no event is injected

Wei Shuyu <wsy@dogben.com>
    md/raid10: properly indicate failure when ending a failed write request

Zheyu Ma <zheyuma97@gmail.com>
    pcmcia: i82092: fix a null pointer dereference bug

Thomas Gleixner <tglx@linutronix.de>
    timers: Move clearing of base::timer_running under base:: Lock

Mario Kleiner <mario.kleiner.de@gmail.com>
    serial: 8250_pci: Avoid irq sharing for MSI(-X) interrupts.

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: 8250_pci: Enumerate Elkhart Lake UARTs via dedicated driver

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Malta: Do not byte-swap accesses to the CBUS UART

Maciej W. Rozycki <macro@orcam.me.uk>
    serial: 8250: Mask out floating 16/32-bit bus bits

Zhiyong Tao <zhiyong.tao@mediatek.com>
    serial: 8250_mtk: fix uart corruption issue when rx power off

Jon Hunter <jonathanh@nvidia.com>
    serial: tegra: Only print FIFO error message when an error occurs

Theodore Ts'o <tytso@mit.edu>
    ext4: fix potential htree corruption when growing large_dir directories

Alex Xu (Hello71) <alex_y_xu@yahoo.ca>
    pipe: increase minimum default pipe size to 2 pages

Johan Hovold <johan@kernel.org>
    media: rtl28xxu: fix zero-length control request

Pavel Skripkin <paskripkin@gmail.com>
    staging: rtl8712: get rid of flush_scheduled_work

Xiangyang Zhang <xyz.sun.ok@gmail.com>
    staging: rtl8723bs: Fix a resource leak in sd_int_dpc

Tyler Hicks <tyhicks@linux.microsoft.com>
    tpm_ftpm_tee: Free and unregister TEE shared memory during kexec

Tyler Hicks <tyhicks@linux.microsoft.com>
    optee: Fix memory leak when failing to register shm pages

Jens Wiklander <jens.wiklander@linaro.org>
    tee: add tee_shm_alloc_kernel_buf()

Tyler Hicks <tyhicks@linux.microsoft.com>
    optee: Clear stale cache entries during initialization

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing / histogram: Give calculation hist_fields a size

Hui Su <suhui@zeku.com>
    scripts/tracing: fix the bug that can't parse raw_trace_func

Brian Norris <briannorris@chromium.org>
    clk: fix leak on devm_clk_bulk_get_all() unwind

Dmitry Osipenko <digetx@gmail.com>
    usb: otg-fsm: Fix hrtimer list corruption

Maxim Devaev <mdevaev@gmail.com>
    usb: gadget: f_hid: idle uses the highest byte for duration

Phil Elwell <phil@raspberrypi.com>
    usb: gadget: f_hid: fixed NULL pointer dereference

Maxim Devaev <mdevaev@gmail.com>
    usb: gadget: f_hid: added GET_IDLE and SET_IDLE handlers

Pawel Laszczak <pawell@cadence.com>
    usb: cdns3: Fixed incorrect gadget state

Alexander Tsoy <alexander@tsoy.me>
    ALSA: usb-audio: Add registration quirk for JBL Quantum 600

Alexander Monakov <amonakov@ispras.ru>
    ALSA: hda/realtek: add mic quirk for Acer SF314-42

Anirudh Rayabharam <mail@anirudhrb.com>
    firmware_loader: fix use-after-free in firmware_fallback_sysfs

Anirudh Rayabharam <mail@anirudhrb.com>
    firmware_loader: use -ETIMEDOUT instead of -EAGAIN in fw_load_sysfs_fallback

David Bauer <mail@david-bauer.net>
    USB: serial: ftdi_sio: add device ID for Auto-M3 OP-COM v2

Willy Tarreau <w@1wt.eu>
    USB: serial: ch341: fix character loss at high transfer rates

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit FD980 composition 0x1056

Qiang.zhang <qiang.zhang@windriver.com>
    USB: usbtmc: Fix RCU stall warning

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    Bluetooth: defer cleanup of resources in hci_unregister_dev()

Yu Kuai <yukuai3@huawei.com>
    blk-iolatency: error out if blk_get_queue() failed in iolatency_set_limit()

Pavel Skripkin <paskripkin@gmail.com>
    net: vxge: fix use-after-free in vxge_device_unregister

Pavel Skripkin <paskripkin@gmail.com>
    net: fec: fix use-after-free in fec_drv_remove

Pavel Skripkin <paskripkin@gmail.com>
    net: pegasus: fix uninit-value in get_interrupt_interval

Dan Carpenter <dan.carpenter@oracle.com>
    bnx2x: fix an error code in bnx2x_nic_load()

H. Nikolaus Schaller <hns@goldelico.com>
    mips: Fix non-POSIX regexp

Antoine Tenart <atenart@kernel.org>
    net: ipv6: fix returned variable type in ip6_skb_dst_mtu

Fei Qin <fei.qin@corigine.com>
    nfp: update ethtool reporting of pauseframe control

Xin Long <lucien.xin@gmail.com>
    sctp: move the active_key update after sh_keys is added

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    gpio: tqmx86: really make IRQ optional

Wang Hai <wanghai38@huawei.com>
    net: natsemi: Fix missing pci_disable_device() in probe and remove

Steve Bennett <steveb@workware.net.au>
    net: phy: micrel: Fix detection of ksz87xx switch

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: sja1105: invalidate dynamic FDB entries learned concurrently with statically added ones

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: sja1105: overwrite dynamic FDB entries with static ones in .port_fdb_add

Jakub Sitnicki <jakub@cloudflare.com>
    net, gro: Set inner transport header offset in tcp/udp GRO hook

Juergen Borleis <jbe@pengutronix.de>
    dmaengine: imx-dma: configure the generic DMA type to make it work

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: videobuf2-core: dequeue if start_streaming fails

Li Manyi <limanyi@uniontech.com>
    scsi: sr: Return correct event when media event code is 3

Marek Vasut <marex@denx.de>
    spi: imx: mx51-ecspi: Fix low-speed CONFIGREG delay calculation

Marek Vasut <marex@denx.de>
    spi: imx: mx51-ecspi: Reinstate low-speed CONFIGREG delay

H. Nikolaus Schaller <hns@goldelico.com>
    omap5-board-common: remove not physically existing vdds_1v8_main fixed-regulator

Dario Binacchi <dariobin@libero.it>
    ARM: dts: am437x-l4: fix typo in can@0 node

Dario Binacchi <dariobin@libero.it>
    clk: stm32f4: fix post divisor setup for I2S/SAI PLLs

chihhao.chen <chihhao.chen@mediatek.com>
    ALSA: usb-audio: fix incorrect clock source setting

Pali Rohár <pali@kernel.org>
    arm64: dts: armada-3720-turris-mox: remove mrvl,i2c-fast-mode

Marek Vasut <marex@denx.de>
    ARM: dts: imx: Swap M53Menlo pinctrl_power_button/pinctrl_power_out pins

Colin Ian King <colin.king@canonical.com>
    ARM: imx: fix missing 3rd argument in macro imx_mmdc_perf_init

Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
    ARM: dts: colibri-imx6ull: limit SDIO clock to 25MHz

Maxime Chevallier <maxime.chevallier@bootlin.com>
    ARM: dts: imx6qdl-sr-som: Increase the PHY reset duration to 10ms

Yang Yingliang <yangyingliang@huawei.com>
    ARM: imx: add missing clk_disable_unprepare()

Yang Yingliang <yangyingliang@huawei.com>
    ARM: imx: add missing iounmap()

Vladimir Oltean <vladimir.oltean@nxp.com>
    arm64: dts: ls1028a: fix node name for the sysclk

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix racy deletion of subscriber

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Revert "ACPICA: Fix memory leak caused by _CID repair function"


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/alpha/kernel/smp.c                            |  2 +-
 arch/arm/boot/dts/am437x-l4.dtsi                   |  2 +-
 arch/arm/boot/dts/imx53-m53menlo.dts               |  4 +-
 arch/arm/boot/dts/imx6qdl-sr-som.dtsi              |  8 ++-
 arch/arm/boot/dts/imx6ull-colibri-wifi.dtsi        |  1 +
 arch/arm/boot/dts/omap5-board-common.dtsi          |  9 +--
 arch/arm/mach-imx/mmdc.c                           | 17 +++++-
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi     |  2 +-
 .../boot/dts/marvell/armada-3720-turris-mox.dts    |  1 +
 arch/arm64/include/asm/arch_timer.h                | 21 -------
 arch/arm64/include/asm/barrier.h                   | 19 ++++++
 arch/arm64/include/asm/ptrace.h                    | 12 +++-
 arch/arm64/include/asm/syscall.h                   | 19 +++---
 arch/arm64/include/asm/vdso/gettimeofday.h         |  6 +-
 arch/arm64/kernel/ptrace.c                         |  2 +-
 arch/arm64/kernel/signal.c                         |  3 +-
 arch/arm64/kernel/syscall.c                        |  7 +--
 arch/mips/Makefile                                 |  2 +-
 arch/mips/mti-malta/malta-platform.c               |  3 +-
 arch/x86/events/perf_event.h                       |  3 +-
 arch/x86/kvm/mmu.c                                 |  2 +-
 arch/x86/kvm/x86.c                                 | 13 ++++-
 block/blk-iolatency.c                              |  6 +-
 drivers/acpi/acpica/nsrepair2.c                    |  7 ---
 drivers/ata/libata-sff.c                           | 35 ++++++++---
 drivers/base/firmware_loader/fallback.c            | 14 +++--
 drivers/base/firmware_loader/firmware.h            | 10 +++-
 drivers/base/firmware_loader/main.c                |  2 +
 drivers/char/tpm/tpm_ftpm_tee.c                    |  8 +--
 drivers/clk/clk-devres.c                           |  9 ++-
 drivers/clk/clk-stm32f4.c                          | 10 ++--
 drivers/dma/imx-dma.c                              |  2 +
 drivers/gpio/gpio-tqmx86.c                         |  6 +-
 drivers/md/raid1.c                                 |  2 -
 drivers/md/raid10.c                                |  4 +-
 drivers/media/common/videobuf2/videobuf2-core.c    | 13 ++++-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            | 11 +++-
 drivers/net/dsa/sja1105/sja1105_main.c             | 67 ++++++++++++++++++++--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |  3 +-
 drivers/net/ethernet/freescale/fec_main.c          |  2 +-
 drivers/net/ethernet/natsemi/natsemi.c             |  8 +--
 drivers/net/ethernet/neterion/vxge/vxge-main.c     |  6 +-
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |  2 +
 drivers/net/ethernet/qlogic/qla3xxx.c              |  6 +-
 drivers/net/phy/micrel.c                           | 10 ++--
 drivers/net/usb/pegasus.c                          | 14 ++++-
 drivers/net/wireless/virt_wifi.c                   | 52 ++++++++++-------
 drivers/pcmcia/i82092.c                            |  1 +
 drivers/scsi/sr.c                                  |  2 +-
 drivers/soc/ixp4xx/ixp4xx-npe.c                    | 11 ++--
 drivers/soc/ixp4xx/ixp4xx-qmgr.c                   |  9 +--
 drivers/spi/spi-imx.c                              | 52 +++++++++++------
 drivers/spi/spi-meson-spicc.c                      |  2 +
 drivers/staging/rtl8712/rtl8712_led.c              |  8 +++
 drivers/staging/rtl8712/rtl871x_led.h              |  1 +
 drivers/staging/rtl8712/rtl871x_pwrctrl.c          |  8 +++
 drivers/staging/rtl8712/rtl871x_pwrctrl.h          |  1 +
 drivers/staging/rtl8712/usb_intf.c                 |  3 +-
 drivers/staging/rtl8723bs/hal/sdio_ops.c           |  2 +
 drivers/tee/optee/call.c                           | 36 +++++++++++-
 drivers/tee/optee/core.c                           |  9 +++
 drivers/tee/optee/optee_private.h                  |  1 +
 drivers/tee/optee/shm_pool.c                       | 12 +++-
 drivers/tee/tee_shm.c                              | 18 ++++++
 drivers/tty/serial/8250/8250_mtk.c                 |  5 ++
 drivers/tty/serial/8250/8250_pci.c                 |  7 +++
 drivers/tty/serial/8250/8250_port.c                | 12 +++-
 drivers/tty/serial/serial-tegra.c                  |  6 +-
 drivers/usb/cdns3/ep0.c                            |  1 +
 drivers/usb/class/usbtmc.c                         |  9 +--
 drivers/usb/common/usb-otg-fsm.c                   |  6 +-
 drivers/usb/gadget/function/f_hid.c                | 44 ++++++++++++--
 drivers/usb/serial/ch341.c                         |  1 +
 drivers/usb/serial/ftdi_sio.c                      |  1 +
 drivers/usb/serial/ftdi_sio_ids.h                  |  3 +
 drivers/usb/serial/option.c                        |  2 +
 fs/ext4/namei.c                                    |  2 +-
 fs/pipe.c                                          | 19 +++++-
 fs/reiserfs/stree.c                                | 31 ++++++++--
 fs/reiserfs/super.c                                |  8 +++
 include/linux/tee_drv.h                            |  1 +
 include/linux/usb/otg-fsm.h                        |  1 +
 include/net/bluetooth/hci_core.h                   |  1 +
 include/net/ip6_route.h                            |  2 +-
 kernel/time/timer.c                                |  6 +-
 kernel/trace/trace_events_hist.c                   |  4 ++
 net/bluetooth/hci_core.c                           | 16 +++---
 net/bluetooth/hci_sock.c                           | 49 ++++++++++------
 net/bluetooth/hci_sysfs.c                          |  3 +
 net/ipv4/tcp_offload.c                             |  3 +
 net/ipv4/udp_offload.c                             |  4 ++
 net/sctp/auth.c                                    | 14 +++--
 scripts/tracing/draw_functrace.py                  |  6 +-
 sound/core/seq/seq_ports.c                         | 39 +++++++++----
 sound/pci/hda/patch_realtek.c                      |  1 +
 sound/usb/clock.c                                  |  6 ++
 sound/usb/quirks.c                                 |  1 +
 tools/testing/selftests/bpf/verifier/stack_ptr.c   |  2 -
 .../selftests/bpf/verifier/value_ptr_arith.c       |  8 ---
 virt/kvm/kvm_main.c                                | 18 +++++-
 101 files changed, 708 insertions(+), 281 deletions(-)


