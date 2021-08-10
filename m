Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CEFA3E80D3
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbhHJRw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:52:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235301AbhHJRu4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:50:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B58306128E;
        Tue, 10 Aug 2021 17:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617376;
        bh=2gttvSWp8t7mZT2zxLRBTWsWSUjA6HhVbYS7onP/Vi0=;
        h=From:To:Cc:Subject:Date:From;
        b=dfiWqZgwvoC8gfACR7FtYZuSxYI30xV8jkFq3vJZrh8geUqmkEPaUFfIfUNX9Fi1Y
         8pouqrQT9AeD7/2G6HPR3l12ZPRXe/HgEwkU6PgVytMoAuVGQf+NePFzhRzIzfLSqM
         Zm20G291TWMpKkJewSrbn6dOIEKLkXO3vDSBTs0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.13 000/175] 5.13.10-rc1 review
Date:   Tue, 10 Aug 2021 19:28:28 +0200
Message-Id: <20210810173000.928681411@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.10-rc1
X-KernelTest-Deadline: 2021-08-12T17:30+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.13.10 release.
There are 175 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 12 Aug 2021 17:29:30 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.10-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.13.10-rc1

Michael Zaidman <michael.zaidman@gmail.com>
    HID: ft260: fix device removal due to USB disconnect

Thomas Weißschuh <linux@weissschuh.net>
    platform/x86: gigabyte-wmi: add support for B550 Aorus Elite V2

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/display: only enable aux backlight control for OLED panels

Steve French <stfrench@microsoft.com>
    smb3: rc uninitialized in one fallocate path

Letu Ren <fantasquex@gmail.com>
    net/qla3xxx: fix schedule while atomic in ql_wait_for_drvr_lock and ql_adapter_reset

Prarit Bhargava <prarit@redhat.com>
    alpha: Send stop IPI to send to online CPUs

Harshvardhan Jha <harshvardhan.jha@oracle.com>
    net: qede: Fix end of loop tests for list_for_each_entry

Matteo Croce <mcroce@microsoft.com>
    virt_wifi: fix error on connect

Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
    reiserfs: check directory items on read from disk

Yu Kuai <yukuai3@huawei.com>
    reiserfs: add check for root_inode in reiserfs_fill_super

Christoph Hellwig <hch@lst.de>
    libata: fix ata_pio_sector for CONFIG_HIGHMEM

Qiu Wenbo <qiuwenbo@kylinos.com.cn>
    riscv: dts: fix memory size for the SiFive HiFive Unmatched

Peter Zijlstra <peterz@infradead.org>
    sched/rt: Fix double enqueue caused by rt_effective_prio

Like Xu <likexu@tencent.com>
    perf/x86/amd: Don't touch the AMD64_EVENTSEL_HOSTONLY bit inside the guest

Arnd Bergmann <arnd@arndb.de>
    soc: ixp4xx/qmgr: fix invalid __iomem access

Matt Roper <matthew.d.roper@intel.com>
    drm/i915: Correct SFC_DONE register offset

Mike Tipton <mdtipton@codeaurora.org>
    interconnect: qcom: icc-rpmh: Add BCMs to commit list in pre_aggregate

Mike Tipton <mdtipton@codeaurora.org>
    interconnect: qcom: icc-rpmh: Ensure floor BW is enforced for all nodes

Mike Tipton <mdtipton@codeaurora.org>
    interconnect: Always call pre_aggregate before aggregate

Mike Tipton <mdtipton@codeaurora.org>
    interconnect: Zero initial BW after sync-state

Dongliang Mu <mudongliangabcd@gmail.com>
    spi: meson-spicc: fix memory leak in meson_spicc_remove

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: Fix incorrect supported maximum speed

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    usb: cdnsp: Fix the IMAN_IE_SET and IMAN_IE_CLEAR macro

Colin Ian King <colin.king@canonical.com>
    interconnect: Fix undersized devress_alloc allocation

Arnd Bergmann <arnd@arndb.de>
    soc: ixp4xx: fix printing resources

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Fix per-cpu counter corruption on 32-bit builds

Paolo Bonzini <pbonzini@redhat.com>
    KVM: Do not leak memory for duplicate debugfs directories

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Fix off-by-one indexing when nullifying last used SEV VMCB

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: accept userspace interrupt only if no event is injected

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix use after free in dasd path handling

Jens Axboe <axboe@kernel.dk>
    io-wq: fix race between worker exiting and activating free worker

Wei Shuyu <wsy@dogben.com>
    md/raid10: properly indicate failure when ending a failed write request

Tero Kristo <t-kristo@ti.com>
    ARM: omap2+: hwmod: fix potential NULL pointer access

Mark Rutland <mark.rutland@arm.com>
    arm64: fix compat syscall return truncation

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    Revert "gpio: mpc8xxx: change the gpio interrupt flags."

Kevin Hilman <khilman@baylibre.com>
    bus: ti-sysc: AM3: RNG is GP only

Xiu Jianfeng <xiujianfeng@huawei.com>
    selinux: correct the return value when loads initial sids

Tyrel Datwyler <tyreld@linux.ibm.com>
    scsi: ibmvfc: Fix command state accounting and stale response detection

Zheyu Ma <zheyuma97@gmail.com>
    pcmcia: i82092: fix a null pointer dereference bug

Dmitry Safonov <0x7f454c46@gmail.com>
    net/xfrm/compat: Copy xfrm_spdattr_type_t atributes

Frederic Weisbecker <frederic@kernel.org>
    xfrm: Fix RCU vs hash_resize_mutex lock inversion

Marco Elver <elver@google.com>
    perf: Fix required permissions if sigtrap is requested

Shuo Liu <shuo.a.liu@intel.com>
    virt: acrn: Do hcall_destroy_vm() before resource release

Thomas Gleixner <tglx@linutronix.de>
    timers: Move clearing of base::timer_running under base:: Lock

Kajol Jain <kjain@linux.ibm.com>
    fpga: dfl: fme: Fix cpu hotplug issue in performance reporting

Mario Kleiner <mario.kleiner.de@gmail.com>
    serial: 8250_pci: Avoid irq sharing for MSI(-X) interrupts.

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: 8250_pci: Enumerate Elkhart Lake UARTs via dedicated driver

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Malta: Do not byte-swap accesses to the CBUS UART

Johan Hovold <johan@kernel.org>
    serial: 8250: fix handle_irq locking

Maciej W. Rozycki <macro@orcam.me.uk>
    serial: 8250: Mask out floating 16/32-bit bus bits

Zhiyong Tao <zhiyong.tao@mediatek.com>
    serial: 8250_mtk: fix uart corruption issue when rx power off

Jon Hunter <jonathanh@nvidia.com>
    serial: tegra: Only print FIFO error message when an error occurs

Mika Westerberg <mika.westerberg@linux.intel.com>
    Revert "thunderbolt: Hide authorized attribute if router does not support PCIe tunnels"

Theodore Ts'o <tytso@mit.edu>
    ext4: fix potential htree corruption when growing large_dir directories

Alex Xu (Hello71) <alex_y_xu@yahoo.ca>
    pipe: increase minimum default pipe size to 2 pages

Johan Hovold <johan@kernel.org>
    media: rtl28xxu: fix zero-length control request

Filip Schauer <filip@mg6.at>
    drivers core: Fix oops when driver probe fails

Pavel Skripkin <paskripkin@gmail.com>
    staging: rtl8712: error handling refactoring

Pavel Skripkin <paskripkin@gmail.com>
    staging: rtl8712: get rid of flush_scheduled_work

Xiangyang Zhang <xyz.sun.ok@gmail.com>
    staging: rtl8723bs: Fix a resource leak in sd_int_dpc

Tyler Hicks <tyhicks@linux.microsoft.com>
    tpm_ftpm_tee: Free and unregister TEE shared memory during kexec

Allen Pais <apais@linux.microsoft.com>
    optee: fix tee out of memory failure seen during kexec reboot

Tyler Hicks <tyhicks@linux.microsoft.com>
    optee: Refuse to load the driver under the kdump kernel

Tyler Hicks <tyhicks@linux.microsoft.com>
    optee: Fix memory leak when failing to register shm pages

Sumit Garg <sumit.garg@linaro.org>
    tee: Correct inappropriate usage of TEE_SHM_DMA_BUF flag

Jens Wiklander <jens.wiklander@linaro.org>
    tee: add tee_shm_alloc_kernel_buf()

Tyler Hicks <tyhicks@linux.microsoft.com>
    optee: Clear stale cache entries during initialization

Mark Rutland <mark.rutland@arm.com>
    arm64: stacktrace: avoid tracing arch_stack_walk()

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    tracepoint: Use rcu get state and cond sync for static call updates

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    tracepoint: Fix static call function vs data state mismatch

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    tracepoint: static call: Compare data on transition from 2->1 callees

Kamal Agrawal <kamaagra@codeaurora.org>
    tracing: Fix NULL pointer dereference in start_creating

Masami Hiramatsu <mhiramat@kernel.org>
    tracing: Reject string operand in the histogram expression

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing / histogram: Give calculation hist_fields a size

Hui Su <suhui@zeku.com>
    scripts/tracing: fix the bug that can't parse raw_trace_func

Brian Norris <briannorris@chromium.org>
    clk: fix leak on devm_clk_bulk_get_all() unwind

Dmitry Osipenko <digetx@gmail.com>
    usb: otg-fsm: Fix hrtimer list corruption

Kyle Tso <kyletso@google.com>
    usb: typec: tcpm: Keep other events when receiving FRS and Sourcing_vbus events

Claudiu Beznea <claudiu.beznea@microchip.com>
    usb: host: ohci-at91: suspend/resume ports after/before OHCI accesses

Maxim Devaev <mdevaev@gmail.com>
    usb: gadget: f_hid: idle uses the highest byte for duration

Phil Elwell <phil@raspberrypi.com>
    usb: gadget: f_hid: fixed NULL pointer dereference

Maxim Devaev <mdevaev@gmail.com>
    usb: gadget: f_hid: added GET_IDLE and SET_IDLE handlers

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: Fixed issue with ZLP

Pawel Laszczak <pawell@cadence.com>
    usb: cdns3: Fixed incorrect gadget state

Zhang Qilong <zhangqilong3@huawei.com>
    usb: gadget: remove leaked entry from udc driver list

Wesley Cheng <wcheng@codeaurora.org>
    usb: dwc3: gadget: Avoid runtime resume if disabling pullup

Wesley Cheng <wcheng@codeaurora.org>
    usb: dwc3: gadget: Use list_replace_init() before traversing lists

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Avoid unnecessary or invalid connector selection at resume

Alexander Tsoy <alexander@tsoy.me>
    ALSA: usb-audio: Add registration quirk for JBL Quantum 600

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix superfluous autosuspend recovery

Nikos Liolios <liolios.nk@gmail.com>
    ALSA: hda/realtek: Fix headset mic for Acer SWIFT SF314-56 (ALC256)

Alexander Monakov <amonakov@ispras.ru>
    ALSA: hda/realtek: add mic quirk for Acer SF314-42

Jaroslav Kysela <perex@perex.cz>
    ALSA: pcm - fix mmap capability check for the snd-dummy driver

Shirish S <shirish.s@amd.com>
    drm/amdgpu/display: fix DMUB firmware version info

Randy Dunlap <rdunlap@infradead.org>
    drm/amdgpu: fix checking pmops when PM_SLEEP is not enabled

Anirudh Rayabharam <mail@anirudhrb.com>
    firmware_loader: fix use-after-free in firmware_fallback_sysfs

Anirudh Rayabharam <mail@anirudhrb.com>
    firmware_loader: use -ETIMEDOUT instead of -EAGAIN in fw_load_sysfs_fallback

Johan Hovold <johan@kernel.org>
    USB: serial: pl2303: fix GT type detection

Johan Hovold <johan@kernel.org>
    USB: serial: pl2303: fix HX type detection

David Bauer <mail@david-bauer.net>
    USB: serial: ftdi_sio: add device ID for Auto-M3 OP-COM v2

Willy Tarreau <w@1wt.eu>
    USB: serial: ch341: fix character loss at high transfer rates

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit FD980 composition 0x1056

Qiang.zhang <qiang.zhang@windriver.com>
    USB: usbtmc: Fix RCU stall warning

Hao Xu <haoxu@linux.alibaba.com>
    io-wq: fix lack of acct->nr_workers < acct->max_workers judgement

Hao Xu <haoxu@linux.alibaba.com>
    io-wq: fix no lock protection of acct->nr_worker

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

Grygorii Strashko <grygorii.strashko@ti.com>
    net: ethernet: ti: am65-cpsw: fix crash in am65_cpsw_port_offload_fwd_mark_update()

Dan Carpenter <dan.carpenter@oracle.com>
    bnx2x: fix an error code in bnx2x_nic_load()

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: cancel sub_make_done for the install target to fix DKMS

H. Nikolaus Schaller <hns@goldelico.com>
    mips: Fix non-POSIX regexp

H. Nikolaus Schaller <hns@goldelico.com>
    x86/tools/relocs: Fix non-POSIX regexp

Huang Pei <huangpei@loongson.cn>
    MIPS: check return value of pgtable_pmd_page_ctor

Randy Dunlap <rdunlap@infradead.org>
    drm/i915: fix i915_globals_exit() section mismatch error

Yunsheng Lin <linyunsheng@huawei.com>
    net: sched: fix lockdep_set_class() typo error for sch->seqlock

Guenter Roeck <linux@roeck-us.net>
    riscv: Disable STACKPROTECTOR_PER_TASK if GCC_PLUGIN_RANDSTRUCT is enabled

Oleksij Rempel <linux@rempel-privat.de>
    net: dsa: qca: ar9331: reorder MDIO write sequence

Yangyang Li <liyangyang20@huawei.com>
    RDMA/hns: Fix the double unlock problem of poll_sem

Antoine Tenart <atenart@kernel.org>
    net: ipv6: fix returned variable type in ip6_skb_dst_mtu

Fei Qin <fei.qin@corigine.com>
    nfp: update ethtool reporting of pauseframe control

Jason Ekstrand <jason@jlekstrand.net>
    drm/i915: Call i915_globals_exit() if pci_register_device() fails

Xin Long <lucien.xin@gmail.com>
    sctp: move the active_key update after sh_keys is added

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: bridge: validate the NUD_PERMANENT bit when adding an extern_learn FDB entry

Aharon Landau <aharonl@nvidia.com>
    RDMA/mlx5: Delay emptying a cache entry when a new MR is added to it recently

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    gpio: tqmx86: really make IRQ optional

Wang Hai <wanghai38@huawei.com>
    net: natsemi: Fix missing pci_disable_device() in probe and remove

Steve Bennett <steveb@workware.net.au>
    net: phy: micrel: Fix detection of ksz87xx switch

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: sja1105: match FDB entries regardless of inner/outer VLAN tag

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: sja1105: be stateless with FDB entries on SJA1105P/Q/R/S/SJA1110 too

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: sja1105: ignore the FDB entry for unknown multicast when adding a new address

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: sja1105: invalidate dynamic FDB entries learned concurrently with statically added ones

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: sja1105: overwrite dynamic FDB entries with static ones in .port_fdb_add

Jakub Sitnicki <jakub@cloudflare.com>
    net, gro: Set inner transport header offset in tcp/udp GRO hook

Juergen Borleis <jbe@pengutronix.de>
    dmaengine: imx-dma: configure the generic DMA type to make it work

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Fix touchscreen IRQ line assignment on DHCOM

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Disable LAN8710 EDPD on DHCOM

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Prefer HW RTC on DHCOM SoM

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: videobuf2-core: dequeue if start_streaming fails

Li Manyi <limanyi@uniontech.com>
    scsi: sr: Return correct event when media event code is 3

Edmund Dea <edmund.j.dea@intel.com>
    drm/kmb: Enable LCD DMA for low TVDDCV

Marek Vasut <marex@denx.de>
    spi: imx: mx51-ecspi: Fix low-speed CONFIGREG delay calculation

Marek Vasut <marex@denx.de>
    spi: imx: mx51-ecspi: Reinstate low-speed CONFIGREG delay

Zhang Qilong <zhangqilong3@huawei.com>
    dmaengine: stm32-dmamux: Fix PM usage counter unbalance in stm32 dmamux ops

Zhang Qilong <zhangqilong3@huawei.com>
    dmaengine: stm32-dma: Fix PM usage counter imbalance in stm32 dma ops

Dmitry Osipenko <digetx@gmail.com>
    clk: tegra: Implement disable_unused() of tegra_clk_sdmmc_mux_ops

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    dmaengine: uniphier-xdmac: Use readl_poll_timeout_atomic() in atomic state

H. Nikolaus Schaller <hns@goldelico.com>
    omap5-board-common: remove not physically existing vdds_1v8_main fixed-regulator

Dario Binacchi <dariobin@libero.it>
    ARM: dts: am437x-l4: fix typo in can@0 node

Dario Binacchi <dariobin@libero.it>
    clk: stm32f4: fix post divisor setup for I2S/SAI PLLs

Jisheng Zhang <jszhang@kernel.org>
    riscv: stacktrace: Fix NULL pointer dereference

chihhao.chen <chihhao.chen@mediatek.com>
    ALSA: usb-audio: fix incorrect clock source setting

Pali Rohár <pali@kernel.org>
    arm64: dts: armada-3720-turris-mox: remove mrvl,i2c-fast-mode

Ye Bin <yebin10@huawei.com>
    ext4: fix potential uninitialized access to retval in kmmpd

Vladimir Oltean <vladimir.oltean@nxp.com>
    arm64: dts: armada-3720-turris-mox: fixed indices for the SDHC controllers

Marek Vasut <marex@denx.de>
    ARM: dts: imx: Swap M53Menlo pinctrl_power_button/pinctrl_power_out pins

Colin Ian King <colin.king@canonical.com>
    ARM: imx: fix missing 3rd argument in macro imx_mmdc_perf_init

Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
    ARM: dts: colibri-imx6ull: limit SDIO clock to 25MHz

Michael Walle <michael@walle.cc>
    arm64: dts: ls1028: sl28: fix networking for variant 2

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: fix submission race window

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: fix sequence for pci driver remove() and shutdown()

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: fix desc->vector that isn't being updated

Lucas Stach <l.stach@pengutronix.de>
    Revert "soc: imx8m: change to use platform driver"

Maxime Chevallier <maxime.chevallier@bootlin.com>
    ARM: dts: imx6qdl-sr-som: Increase the PHY reset duration to 10ms

Yang Yingliang <yangyingliang@huawei.com>
    ARM: imx: add missing clk_disable_unprepare()

Yang Yingliang <yangyingliang@huawei.com>
    ARM: imx: add missing iounmap()

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: fix setup sequence for MSIXPERM table

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: fix array index when int_handles are being used

Vladimir Oltean <vladimir.oltean@nxp.com>
    arm64: dts: ls1028a: fix node name for the sysclk

Pavel Skripkin <paskripkin@gmail.com>
    net: xfrm: fix memory leak in xfrm_user_rcv_msg

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Fix gpt12 system timer issue with reserved status

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix racy deletion of subscriber

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Revert "ACPICA: Fix memory leak caused by _CID repair function"


-------------

Diffstat:

 Makefile                                           |  13 +-
 arch/alpha/kernel/smp.c                            |   2 +-
 arch/arm/boot/dts/am437x-l4.dtsi                   |   2 +-
 arch/arm/boot/dts/imx53-m53menlo.dts               |   4 +-
 arch/arm/boot/dts/imx6qdl-sr-som.dtsi              |   8 +-
 arch/arm/boot/dts/imx6ull-colibri-wifi.dtsi        |   1 +
 arch/arm/boot/dts/omap5-board-common.dtsi          |   9 +-
 arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi      |  24 ++--
 arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi       |   5 +-
 arch/arm/mach-imx/mmdc.c                           |  17 ++-
 arch/arm/mach-omap2/omap_hwmod.c                   |  10 +-
 .../freescale/fsl-ls1028a-kontron-sl28-var2.dts    |   2 +
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi     |   2 +-
 .../boot/dts/marvell/armada-3720-turris-mox.dts    |   3 +
 arch/arm64/include/asm/ptrace.h                    |  12 +-
 arch/arm64/include/asm/syscall.h                   |  19 +--
 arch/arm64/kernel/ptrace.c                         |   2 +-
 arch/arm64/kernel/signal.c                         |   3 +-
 arch/arm64/kernel/stacktrace.c                     |   2 +-
 arch/arm64/kernel/syscall.c                        |   9 +-
 arch/mips/Makefile                                 |   2 +-
 arch/mips/include/asm/pgalloc.h                    |  17 ++-
 arch/mips/mti-malta/malta-platform.c               |   3 +-
 arch/riscv/Kconfig                                 |   1 +
 .../riscv/boot/dts/sifive/hifive-unmatched-a00.dts |   2 +-
 arch/riscv/kernel/stacktrace.c                     |   2 +-
 arch/x86/events/perf_event.h                       |   3 +-
 arch/x86/kvm/mmu/mmu.c                             |   2 +-
 arch/x86/kvm/svm/sev.c                             |   2 +-
 arch/x86/kvm/x86.c                                 |  13 +-
 arch/x86/tools/relocs.c                            |   8 +-
 block/blk-iolatency.c                              |   6 +-
 drivers/acpi/acpica/nsrepair2.c                    |   7 -
 drivers/ata/libata-sff.c                           |  35 +++--
 drivers/base/dd.c                                  |   4 +-
 drivers/base/firmware_loader/fallback.c            |  14 +-
 drivers/base/firmware_loader/firmware.h            |  10 +-
 drivers/base/firmware_loader/main.c                |   2 +
 drivers/bus/ti-sysc.c                              |  22 ++-
 drivers/char/tpm/tpm_ftpm_tee.c                    |   8 +-
 drivers/clk/clk-devres.c                           |   9 +-
 drivers/clk/clk-stm32f4.c                          |  10 +-
 drivers/clk/tegra/clk-sdmmc-mux.c                  |  10 ++
 drivers/dma/idxd/idxd.h                            |  14 ++
 drivers/dma/idxd/init.c                            |  30 ++--
 drivers/dma/idxd/irq.c                             |  27 ++--
 drivers/dma/idxd/submit.c                          |  92 +++++++++---
 drivers/dma/idxd/sysfs.c                           |   2 -
 drivers/dma/imx-dma.c                              |   2 +
 drivers/dma/stm32-dma.c                            |   4 +-
 drivers/dma/stm32-dmamux.c                         |   6 +-
 drivers/dma/uniphier-xdmac.c                       |   4 +-
 drivers/fpga/dfl-fme-perf.c                        |   2 +
 drivers/gpio/gpio-mpc8xxx.c                        |   2 +-
 drivers/gpio/gpio-tqmx86.c                         |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   6 +-
 drivers/gpu/drm/i915/i915_globals.c                |   4 +-
 drivers/gpu/drm/i915/i915_pci.c                    |   1 +
 drivers/gpu/drm/i915/i915_reg.h                    |   2 +-
 drivers/gpu/drm/kmb/kmb_drv.c                      |  14 ++
 drivers/gpu/drm/kmb/kmb_plane.c                    |  15 +-
 drivers/hid/hid-ft260.c                            |  23 +--
 drivers/infiniband/hw/hns/hns_roce_cmd.c           |   7 +-
 drivers/infiniband/hw/hns/hns_roce_main.c          |   4 +-
 drivers/infiniband/hw/mlx5/mr.c                    |   4 +-
 drivers/interconnect/core.c                        |   9 +-
 drivers/interconnect/qcom/icc-rpmh.c               |  22 ++-
 drivers/md/raid1.c                                 |   2 -
 drivers/md/raid10.c                                |   4 +-
 drivers/media/common/videobuf2/videobuf2-core.c    |  13 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            |  11 +-
 drivers/net/dsa/qca/ar9331.c                       |  14 +-
 drivers/net/dsa/sja1105/sja1105_main.c             |  94 +++++++++----
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |   3 +-
 drivers/net/ethernet/freescale/fec_main.c          |   2 +-
 drivers/net/ethernet/natsemi/natsemi.c             |   8 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.c     |   6 +-
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   2 +
 drivers/net/ethernet/qlogic/qede/qede_filter.c     |   4 +-
 drivers/net/ethernet/qlogic/qla3xxx.c              |   6 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   6 +-
 drivers/net/phy/micrel.c                           |  10 +-
 drivers/net/usb/pegasus.c                          |  14 +-
 drivers/net/wireless/virt_wifi.c                   |  52 ++++---
 drivers/pcmcia/i82092.c                            |   1 +
 drivers/platform/x86/gigabyte-wmi.c                |   1 +
 drivers/s390/block/dasd_eckd.c                     |  13 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                     |  19 ++-
 drivers/scsi/ibmvscsi/ibmvfc.h                     |   1 +
 drivers/scsi/sr.c                                  |   2 +-
 drivers/soc/imx/soc-imx8m.c                        |  84 ++---------
 drivers/soc/ixp4xx/ixp4xx-npe.c                    |  11 +-
 drivers/soc/ixp4xx/ixp4xx-qmgr.c                   |   9 +-
 drivers/spi/spi-imx.c                              |  52 ++++---
 drivers/spi/spi-meson-spicc.c                      |   2 +
 drivers/staging/rtl8712/hal_init.c                 |  30 ++--
 drivers/staging/rtl8712/rtl8712_led.c              |   8 ++
 drivers/staging/rtl8712/rtl871x_led.h              |   1 +
 drivers/staging/rtl8712/rtl871x_pwrctrl.c          |   8 ++
 drivers/staging/rtl8712/rtl871x_pwrctrl.h          |   1 +
 drivers/staging/rtl8712/usb_intf.c                 |  51 +++----
 drivers/staging/rtl8723bs/hal/sdio_ops.c           |   2 +
 drivers/tee/optee/call.c                           |  38 ++++-
 drivers/tee/optee/core.c                           |  43 +++++-
 drivers/tee/optee/optee_private.h                  |   1 +
 drivers/tee/optee/rpc.c                            |   5 +-
 drivers/tee/optee/shm_pool.c                       |  20 ++-
 drivers/tee/tee_shm.c                              |  20 ++-
 drivers/thunderbolt/switch.c                       |  15 +-
 drivers/tty/serial/8250/8250_aspeed_vuart.c        |   5 +-
 drivers/tty/serial/8250/8250_fsl.c                 |   5 +-
 drivers/tty/serial/8250/8250_mtk.c                 |   5 +
 drivers/tty/serial/8250/8250_pci.c                 |   7 +
 drivers/tty/serial/8250/8250_port.c                |  17 ++-
 drivers/tty/serial/serial-tegra.c                  |   6 +-
 drivers/usb/cdns3/cdns3-ep0.c                      |   1 +
 drivers/usb/cdns3/cdnsp-gadget.c                   |   2 +-
 drivers/usb/cdns3/cdnsp-gadget.h                   |   4 +-
 drivers/usb/cdns3/cdnsp-ring.c                     |  18 ++-
 drivers/usb/class/usbtmc.c                         |   9 +-
 drivers/usb/common/usb-otg-fsm.c                   |   6 +-
 drivers/usb/dwc3/gadget.c                          |  29 +++-
 drivers/usb/gadget/function/f_hid.c                |  44 +++++-
 drivers/usb/gadget/udc/max3420_udc.c               |  14 +-
 drivers/usb/host/ohci-at91.c                       |   9 +-
 drivers/usb/serial/ch341.c                         |   1 +
 drivers/usb/serial/ftdi_sio.c                      |   1 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   3 +
 drivers/usb/serial/option.c                        |   2 +
 drivers/usb/serial/pl2303.c                        |  42 +++---
 drivers/usb/typec/tcpm/tcpm.c                      |   4 +-
 drivers/virt/acrn/vm.c                             |  16 +--
 fs/cifs/smb2ops.c                                  |   3 +-
 fs/ext4/mmp.c                                      |   2 +-
 fs/ext4/namei.c                                    |   2 +-
 fs/io-wq.c                                         |  71 ++++++----
 fs/pipe.c                                          |  19 ++-
 fs/reiserfs/stree.c                                |  31 ++++-
 fs/reiserfs/super.c                                |   8 ++
 include/linux/serial_core.h                        |  24 ++++
 include/linux/tee_drv.h                            |   2 +
 include/linux/usb/otg-fsm.h                        |   1 +
 include/net/bluetooth/hci_core.h                   |   1 +
 include/net/ip6_route.h                            |   2 +-
 include/net/netns/xfrm.h                           |   1 +
 kernel/events/core.c                               |  25 +++-
 kernel/sched/core.c                                |  90 +++++-------
 kernel/time/timer.c                                |   6 +-
 kernel/trace/trace.c                               |   4 +-
 kernel/trace/trace_events_hist.c                   |  24 +++-
 kernel/tracepoint.c                                | 155 ++++++++++++++++++---
 net/bluetooth/hci_core.c                           |  16 +--
 net/bluetooth/hci_sock.c                           |  49 ++++---
 net/bluetooth/hci_sysfs.c                          |   3 +
 net/bridge/br.c                                    |   3 +-
 net/bridge/br_fdb.c                                |  30 +++-
 net/bridge/br_private.h                            |   2 +-
 net/ipv4/tcp_offload.c                             |   3 +
 net/ipv4/udp_offload.c                             |   4 +
 net/sched/sch_generic.c                            |   2 +-
 net/sctp/auth.c                                    |  14 +-
 net/xfrm/xfrm_compat.c                             |  49 ++++++-
 net/xfrm/xfrm_policy.c                             |  17 ++-
 net/xfrm/xfrm_user.c                               |  10 ++
 scripts/tracing/draw_functrace.py                  |   6 +-
 security/selinux/ss/policydb.c                     |  10 +-
 sound/core/pcm_native.c                            |   2 +-
 sound/core/seq/seq_ports.c                         |  39 ++++--
 sound/pci/hda/patch_realtek.c                      |   2 +
 sound/usb/card.c                                   |   2 +-
 sound/usb/clock.c                                  |   6 +
 sound/usb/mixer.c                                  |  35 +++--
 sound/usb/quirks.c                                 |   1 +
 virt/kvm/kvm_main.c                                |  18 ++-
 175 files changed, 1634 insertions(+), 744 deletions(-)


