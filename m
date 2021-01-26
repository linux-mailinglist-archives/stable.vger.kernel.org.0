Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6AA3303E96
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 14:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731311AbhAZMpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 07:45:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:52308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391826AbhAZKD6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Jan 2021 05:03:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCB69207B3;
        Tue, 26 Jan 2021 10:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611655395;
        bh=YNIQmrCrIPmamYjjDMz8NgJPrlaZDEWT//1NV6gCxXw=;
        h=From:To:Cc:Subject:Date:From;
        b=jEQClJ+loCYxhdiggbacp0M2ZKDPRKC98cjhC/sgWb+0ayFXfttqPejhlGbhQyl4H
         gLlo4CBcS349pBnZCQ1HFYSqrqTzXFwuZ86L/Zo5HoB5mm/XutlK8/Qa+OdTa6SZPi
         VR+sxO3hHxRMbf3Pr3DVvrtghSW9lBaiSXJnDsek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.10 000/203] 5.10.11-rc2 review
Date:   Tue, 26 Jan 2021 11:03:12 +0100
Message-Id: <20210126094313.589480033@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.10.11-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.11-rc2
X-KernelTest-Deadline: 2021-01-28T09:43+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.11 release.
There are 203 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 28 Jan 2021 09:42:40 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.11-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.11-rc2

Sami Tolvanen <samitolvanen@google.com>
    Commit 9bb48c82aced ("tty: implement write_iter") converted the tty layer to use write_iter. Fix the redirected_tty_write declaration also in n_tty and change the comparisons to use write_iter instead of write. also in n_tty and change the comparisons to use write_iter instead of write.

Johannes Berg <johannes@sipsolutions.net>
    fs/pipe: allow sendfile() to pipe again

Martin Kepplinger <martink@posteo.de>
    interconnect: imx8mq: Use icc_sync_state

Christoph Hellwig <hch@lst.de>
    kernfs: wire up ->splice_read and ->splice_write

Christoph Hellwig <hch@lst.de>
    kernfs: implement ->write_iter

Christoph Hellwig <hch@lst.de>
    kernfs: implement ->read_iter

KP Singh <kpsingh@kernel.org>
    bpf: Local storage helpers should check nullness of owner ptr passed

Anshuman Gupta <anshuman.gupta@intel.com>
    drm/i915/hdcp: Get conn while content_type changed

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ASoC: SOF: Intel: hda: Avoid checking jack on system suspend

Kuniyuki Iwashima <kuniyu@amazon.co.jp>
    tcp: Fix potential use-after-free due to double kfree()

Hyunwook (Wooky) Baek <baekhw@google.com>
    x86/sev-es: Handle string port IO to kernel memory properly

Pan Bian <bianpan2016@163.com>
    net: systemport: free dev before on error path

Linus Torvalds <torvalds@linux-foundation.org>
    tty: fix up hung_up_tty_write() conversion

Linus Torvalds <torvalds@linux-foundation.org>
    tty: implement write_iter

Peter Zijlstra <peterz@infradead.org>
    x86/sev: Fix nonistr violation

Douglas Anderson <dianders@chromium.org>
    pinctrl: qcom: Don't clear pending interrupts when enabling

Douglas Anderson <dianders@chromium.org>
    pinctrl: qcom: Properly clear "intr_ack_high" interrupts when unmasking

Douglas Anderson <dianders@chromium.org>
    pinctrl: qcom: No need to read-modify-write the interrupt status

Douglas Anderson <dianders@chromium.org>
    pinctrl: qcom: Allow SoCs to specify a GPIO function that's not 0

Oleksandr Mazur <oleksandr.mazur@plvision.eu>
    net: core: devlink: use right genl user_ptr when handling port param get/set

Alban Bedel <alban.bedel@aerq.com>
    net: mscc: ocelot: Fix multicast to the CPU port

Enke Chen <enchen@paloaltonetworks.com>
    tcp: fix TCP_USER_TIMEOUT with zero window

Eric Dumazet <edumazet@google.com>
    tcp: do not mess with cloned skbs in tcp_add_backlog()

Dan Carpenter <dan.carpenter@oracle.com>
    net: dsa: b53: fix an off by one in checking "vlan->vid"

Tariq Toukan <tariqt@nvidia.com>
    net: Disable NETIF_F_HW_TLS_RX when RXCSUM is disabled

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: allow offloading of bridge on top of LAG

Matteo Croce <mcroce@microsoft.com>
    ipv6: set multicast flag on the multicast route

Eric Dumazet <edumazet@google.com>
    net_sched: reject silly cell_log in qdisc_get_rtab()

Eric Dumazet <edumazet@google.com>
    net_sched: avoid shift-out-of-bounds in tcindex_set_parms()

Matteo Croce <mcroce@microsoft.com>
    ipv6: create multicast route with RTPROT_KERNEL

Guillaume Nault <gnault@redhat.com>
    udp: mask TOS bits in udp_v4_early_demux()

Eric Dumazet <edumazet@google.com>
    net_sched: gen_estimator: support large ewma log

Yuchung Cheng <ycheng@google.com>
    tcp: fix TCP socket rehash stats mis-accounting

Lecopzer Chen <lecopzer@gmail.com>
    kasan: fix incorrect arguments passing in kasan_add_zero_shadow

Lecopzer Chen <lecopzer@gmail.com>
    kasan: fix unaligned address is unhandled in kasan_remove_zero_shadow

Alexander Lobakin <alobakin@pm.me>
    skbuff: back tiny skbs with kmalloc() in __netdev_alloc_skb() too

Pan Bian <bianpan2016@163.com>
    lightnvm: fix memory leak when submit fails

Takashi Iwai <tiwai@suse.de>
    cachefiles: Drop superfluous readpages aops NULL check

Christoph Hellwig <hch@lst.de>
    nvme-pci: fix error unwind in nvme_map_data

Christoph Hellwig <hch@lst.de>
    nvme-pci: refactor nvme_unmap_data

Geert Uytterhoeven <geert+renesas@glider.be>
    sh_eth: Fix power down vs. is_opened flag ordering

Sandipan Das <sandipan@linux.ibm.com>
    selftests/powerpc: Fix exit status of pkey tests

Rasmus Villemoes <rasmus.villemoes@prevas.dk>
    net: dsa: mv88e6xxx: also read STU state in mv88e6250_g1_vtu_getnext

Yingjie Wang <wangyingjie55@126.com>
    octeontx2-af: Fix missing check bugs in rvu_cgx.c

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ASoC: SOF: Intel: fix page fault at probe if i915 init fails

Peter Zijlstra <peterz@infradead.org>
    locking/lockdep: Cure noinstr fail

Jinyang He <hejinyang@loongson.cn>
    sh: Remove unused HAVE_COPY_THREAD_TLS macro

Necip Fazil Yildiran <fazilyildiran@gmail.com>
    sh: dma: fix kconfig dependency for G2_DMA

Anshuman Gupta <anshuman.gupta@intel.com>
    drm/i915/hdcp: Update CP property in update_pipe

Kent Gibson <warthog618@gmail.com>
    tools: gpio: fix %llu warning in gpio-watch.c

Kent Gibson <warthog618@gmail.com>
    tools: gpio: fix %llu warning in gpio-event-mon.c

Guillaume Nault <gnault@redhat.com>
    netfilter: rpfilter: mask ecn bits before fib lookup

Cong Wang <cong.wang@bytedance.com>
    cls_flower: call nla_ok() before nla_next()

Yazen Ghannam <Yazen.Ghannam@amd.com>
    x86/cpu/amd: Set __max_die_per_package on AMD

Peter Zijlstra <peterz@infradead.org>
    x86/entry: Fix noinstr fail

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Only enable DFP 4:4:4->4:2:0 conversion when outputting YCbCr 4:4:4

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: s/intel_dp_sink_dpms/intel_dp_set_power/

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    driver core: Extend device_is_dependent()

Saravana Kannan <saravanak@google.com>
    driver core: Fix device link device name collision

Meng Li <Meng.Li@windriver.com>
    drivers core: Free dma_range_map when driver probe failed

JC Kuo <jckuo@nvidia.com>
    xhci: tegra: Delay for disabling LFPS detector

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: make sure TRB is fully written before giving it to the controller

Peter Chen <peter.chen@nxp.com>
    usb: cdns3: imx: fix can't create core device the second time issue

Peter Chen <peter.chen@nxp.com>
    usb: cdns3: imx: fix writing read-only memory issue

Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
    usb: bdc: Make bdc pci driver depend on BROKEN

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: udc: core: Use lock when write to soft_connect

Alan Stern <stern@rowland.harvard.edu>
    USB: gadget: dummy-hcd: Fix errors in port-reset handling

Ryan Chen <ryan_chen@aspeedtech.com>
    usb: gadget: aspeed: fix stop dma register setting.

Longfang Liu <liulongfang@huawei.com>
    USB: ehci: fix an interrupt calltrace error

Eugene Korenevsky <ekorenevsky@astralinux.ru>
    ehci: fix EHCI host controller initialization sequence

Pali Rohár <pali@kernel.org>
    serial: mvebu-uart: fix tx lost characters at power off

Wang Hui <john.wanghui@huawei.com>
    stm class: Fix module init return on allocation failure

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Alder Lake-P support

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix short read retries for non-reg files

Jens Axboe <axboe@kernel.dk>
    io_uring: fix SQPOLL IORING_OP_CLOSE cancelation state

Jens Axboe <axboe@kernel.dk>
    io_uring: iopoll requests should also wake task ->in_idle state

Shakeel Butt <shakeelb@google.com>
    mm: fix numa stats for thp migration

Shakeel Butt <shakeelb@google.com>
    mm: memcg: fix memcg file_dirty numa stat

Roman Gushchin <guro@fb.com>
    mm: memcg/slab: optimize objcg stock draining

Mike Rapoport <rppt@kernel.org>
    mm: fix initialization of struct page for holes in memory layout

Xiaoming Ni <nixiaoming@huawei.com>
    proc_sysctl: fix oops caused by incorrect command parameters

Mike Rapoport <rppt@kernel.org>
    x86/setup: don't remove E820_TYPE_RAM for pfn 0

Andy Lutomirski <luto@kernel.org>
    x86/mmx: Use KFPU_387 for MMX string operations

Borislav Petkov <bp@suse.de>
    x86/topology: Make __max_die_per_package available unconditionally

Andy Lutomirski <luto@kernel.org>
    x86/fpu: Add kernel_fpu_begin_mask() to selectively initialize state

Mathias Kresin <dev@kresin.me>
    irqchip/mips-cpu: Set IPI domain parent chip

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: do not fail __smb_send_rqst if non-fatal signals are pending

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s: fix scv entry fallback flush vs interrupt

David Lechner <david@lechnology.com>
    counter:ti-eqep: remove floor

Alexandru Ardelean <alexandru.ardelean@analog.com>
    iio: adc: ti_am335x_adc: remove omitted iio_kfifo_free()

Slaveyko Slaveykov <sis@melexis.com>
    drivers: iio: temperature: Add delay after the addressed reset command in mlx90632.c

Lars-Peter Clausen <lars@metafoo.de>
    iio: ad5504: Fix setting power-down state

Lorenzo Bianconi <lorenzo@kernel.org>
    iio: common: st_sensors: fix possible infinite loop in st_sensors_irq_thread

Krzysztof Kozlowski <krzk@kernel.org>
    i2c: sprd: depend on COMMON_CLK to fix compile tests

Adrian Hunter <adrian.hunter@intel.com>
    perf evlist: Fix id index for heterogeneous systems

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: peak_usb: fix use after free bugs

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: vxcan: vxcan_xmit: fix use after free bug

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: dev: can_restart: fix use after free bug

Hangbin Liu <liuhangbin@gmail.com>
    selftests: net: fib_tests: remove duplicate log test

Maxim Mikityanskiy <maximmi@mellanox.com>
    xsk: Clear pool even for inactive queues

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda: Balance runtime/system PM if direct-complete is disabled

Randy Dunlap <rdunlap@infradead.org>
    gpio: sifive: select IRQ_DOMAIN_HIERARCHY rather than depend on it

Hans de Goede <hdegoede@redhat.com>
    platform/x86: hp-wmi: Don't log a warning on HPWMI_RET_UNKNOWN_COMMAND errors

Hans de Goede <hdegoede@redhat.com>
    platform/x86: intel-vbtn: Drop HP Stream x360 Convertible PC 11 from allow-list

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    drm/vc4: Unify PCM card's driver_name

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: octeon: check correct size of maximum RECV_LEN packet

Christoph Hellwig <hch@lst.de>
    iov_iter: fix the uaccess area in copy_compat_iovec_from_user

John Ogness <john.ogness@linutronix.de>
    printk: fix kmsg_dump_get_buffer length calulations

John Ogness <john.ogness@linutronix.de>
    printk: ringbuffer: fix line counting

Neta Ostrovsky <netao@nvidia.com>
    RDMA/cma: Fix error flow in default_roce_mode_store

Aharon Landau <aharonl@nvidia.com>
    RDMA/umem: Avoid undefined behavior of rounddown_pow_of_two()

Jeremy Cline <jcline@redhat.com>
    drm/amdkfd: Fix out-of-bounds read in kdf_create_vcrat_image_cpu()

Song Liu <songliubraving@fb.com>
    bpf: Reject too big ctx_size_in for raw_tp test run

Mark Rutland <mark.rutland@arm.com>
    arm64: entry: remove redundant IRQ flag tracing

Ariel Marcovitch <arielmarcovitch@gmail.com>
    powerpc: Fix alignment bug within the init sections

Youling Tang <tangyouling@loongson.cn>
    powerpc: Use the common INIT_DATA_SECTION macro in vmlinux.lds.S

Jiri Olsa <jolsa@kernel.org>
    bpf: Prevent double bpf_prog_put call from bpf_tracing_prog_attach

Arnd Bergmann <arnd@arndb.de>
    crypto: omap-sham - Fix link error without crypto-engine

Jaegeuk Kim <jaegeuk@kernel.org>
    scsi: ufs: Fix tm request when non-fatal error happens

Randy Dunlap <rdunlap@infradead.org>
    scsi: ufs: ufshcd-pltfrm depends on HAS_IOMEM

Arnd Bergmann <arnd@arndb.de>
    scsi: megaraid_sas: Fix MEGASAS_IOC_FIRMWARE regression

Josef Bacik <josef@toxicpanda.com>
    btrfs: print the actual offset in btrfs_root_name

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/ucma: Do not miss ctx destruction steps in some cases

Hsin-Yi Wang <hsinyi@chromium.org>
    pinctrl: mediatek: Fix fallback call path

Billy Tsai <billy_tsai@aspeedtech.com>
    pinctrl: aspeed: g6: Fix PWMG0 pinctrl setting

Kent Gibson <warthog618@gmail.com>
    gpiolib: cdev: fix frame size warning in gpio_ioctl()

Trond Myklebust <trond.myklebust@hammerspace.com>
    nfsd: Don't set eof on a truncated READ_PLUS

Trond Myklebust <trond.myklebust@hammerspace.com>
    nfsd: Fixes for nfsd4_encode_read_plus_data()

Randy Dunlap <rdunlap@infradead.org>
    x86/xen: fix 'nopvspin' build error

Atish Patra <atish.patra@wdc.com>
    RISC-V: Fix maximum allowed phsyical memory for RV32

Atish Patra <atish.patra@wdc.com>
    RISC-V: Set current memblock limit

Ian Rogers <irogers@google.com>
    libperf tests: Fail when failing to get a tracepoint id

Ian Rogers <irogers@google.com>
    libperf tests: If a test fails return non-zero

Marcelo Diop-Gonzalez <marcelo827@gmail.com>
    io_uring: flush timeouts that should already have expired

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/kms/nv50-: fix case where notifier buffer is at offset 0

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/mmu: fix vram heap sizing

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/i2c/gm200: increase width of aux semaphore owner fields

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/privring: ack interrupts the same way as RM

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/bios: fix issue shadowing expansion ROMs

Wayne Lin <Wayne.Lin@amd.com>
    drm/amd/display: Fix to be able to stop crc calculation

Nicholas Miell <nmiell@gmail.com>
    HID: logitech-hidpp: Add product ID for MX Ergo in Bluetooth mode

Li, Roman <Roman.Li@amd.com>
    drm/amd/display: disable dcn10 pipe split by default

Victor Zhao <Victor.Zhao@amd.com>
    drm/amdgpu/psp: fix psp gfx ctrl cmds

Sagar Shrikant Kadam <sagar.kadam@sifive.com>
    riscv: defconfig: enable gpio support for HiFive Unleashed

Sagar Shrikant Kadam <sagar.kadam@sifive.com>
    dts: phy: add GPIO number and active state used for phy reset

Sagar Shrikant Kadam <sagar.kadam@sifive.com>
    dts: phy: fix missing mdio device and probe failure of vsc8541-01 device

David Woodhouse <dwmw@amazon.co.uk>
    x86/xen: Fix xen_hvm_smp_init() when vector callback not available

David Woodhouse <dwmw@amazon.co.uk>
    x86/xen: Add xen_no_vector_callback option to test PCI INTX delivery

David Woodhouse <dwmw@amazon.co.uk>
    xen: Fix event channel callback via INTX/GSI

Arnd Bergmann <arnd@arndb.de>
    arm64: make atomic helpers __always_inline

Kefeng Wang <wangkefeng.wang@huawei.com>
    riscv: cacheinfo: Fix using smp_processor_id() in preemptible

Peter Geis <pgwipeout@gmail.com>
    ALSA: hda/tegra: fix tegra-hda on tegra30 soc

Peter Geis <pgwipeout@gmail.com>
    clk: tegra30: Add hda clock default rates to clock driver

Seth Miller <miller.seth@gmail.com>
    HID: Ignore battery for Elan touchscreen on ASUS UX550

Filipe Laíns <lains@archlinux.org>
    HID: logitech-dj: add the G602 receiver

Damien Le Moal <damien.lemoal@wdc.com>
    riscv: Enable interrupts during syscalls with M-Mode

Damien Le Moal <damien.lemoal@wdc.com>
    riscv: Fix sifive serial driver

Damien Le Moal <damien.lemoal@wdc.com>
    riscv: Fix kernel time_init()

Ewan D. Milne <emilne@redhat.com>
    scsi: sd: Suppress spurious errors when WRITE SAME is being disabled

Dinghao Liu <dinghao.liu@zju.edu.cn>
    scsi: scsi_debug: Fix memleak in scsi_debug_init()

Nilesh Javali <njavali@marvell.com>
    scsi: qedi: Correct max length of CHAP secret

Can Guo <cang@codeaurora.org>
    scsi: ufs: Correct the LUN used in eh_device_reset_handler() callback

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs: Relax the condition of UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL

Dexuan Cui <decui@microsoft.com>
    x86/hyperv: Fix kexec panic/hang issues

Anthony Iliopoulos <ailiop@suse.com>
    dm integrity: select CRYPTO_SKCIPHER

Arnd Bergmann <arnd@arndb.de>
    HID: sony: select CONFIG_CRC32

Kai-Heng Feng <kai.heng.feng@canonical.com>
    HID: multitouch: Enable multi-input for Synaptics pointstick/touchpad device

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Handle TCP socket sends with kernel_sendpage() again

Shuming Fan <shumingf@realtek.com>
    ASoC: rt711: mutex between calibration and power state changes

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: haswell: Add missing pm_ops

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Check for rq->hwsp validity after acquiring RCU lock

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Prevent use of engine->wa_ctx after error

Sung Lee <sung.lee@amd.com>
    drm/amd/display: DCN2X Find Secondary Pipe properly in MPO + ODM Case

Huang Rui <ray.huang@amd.com>
    drm/amdgpu: remove gpu info firmware of green sardine

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/syncobj: Fix use-after-free

Pan Bian <bianpan2016@163.com>
    drm/atomic: put state on error path

Mikulas Patocka <mpatocka@redhat.com>
    dm integrity: conditionally disable "recalculate" feature

Mikulas Patocka <mpatocka@redhat.com>
    dm integrity: fix a crash if "recalculate" used without "internal_hash"

Hannes Reinecke <hare@suse.de>
    dm: avoid filesystem lookup in dm_get_dev_t()

Al Cooper <alcooperx@gmail.com>
    mmc: sdhci-brcmstb: Fix mmc timeout errors on S5 suspend

Alex Leibovich <alexl@marvell.com>
    mmc: sdhci-xenon: fix 1.8v regulator stabilization

Jisheng Zhang <Jisheng.Zhang@synaptics.com>
    mmc: sdhci-of-dwcmshc: fix rpmb access

Peter Collingbourne <pcc@google.com>
    mmc: core: don't initialize block size from ext_csd if not present

Paul Cercueil <paul@crapouillou.net>
    pinctrl: ingenic: Fix JZ4760 support

Eric Biggers <ebiggers@google.com>
    fs: fix lazytime expiration handling in __writeback_single_inode()

Filipe Manana <fdmanana@suse.com>
    btrfs: send: fix invalid clone operations when cloning from the same file and root

Josef Bacik <josef@toxicpanda.com>
    btrfs: don't clear ret in btrfs_start_dirty_block_groups

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix lockdep splat in btrfs_recover_relocation

Josef Bacik <josef@toxicpanda.com>
    btrfs: do not double free backref nodes on error

Josef Bacik <josef@toxicpanda.com>
    btrfs: don't get an EINTR during drop_snapshot for reloc

Hans de Goede <hdegoede@redhat.com>
    ACPI: scan: Make acpi_bus_get_device() clear return pointer on error

Ignat Korchagin <ignat@cloudflare.com>
    dm crypt: fix copy and paste bug in crypt_alloc_req_aead

Kirill Tkhai <ktkhai@virtuozzo.com>
    crypto: xor - Fix divide error in do_xor_speed()

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/via: Add minimum mute flag

Chris Chiu <chiu@endlessos.org>
    ALSA: hda/realtek - Limit int mic boost on Acer Aspire E5-575T

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: oss: Fix missing error check in snd_seq_oss_synth_make_info()

Jiaxun Yang <jiaxun.yang@flygoat.com>
    platform/x86: ideapad-laptop: Disable touchpad_switch for ELAN0634

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    platform/x86: i2c-multi-instantiate: Don't create platform device for INT3515 ACPI nodes

Mikko Perttunen <mperttunen@nvidia.com>
    i2c: bpmp-tegra: Ignore unknown I2C_M flags

Mikko Perttunen <mperttunen@nvidia.com>
    i2c: tegra: Wait for config load atomically while in ISR

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: nandsim: Fix the logic when selecting Hamming soft ECC engine

Sean Nyekjaer <sean@geanix.com>
    mtd: rawnand: gpmi: fix dst bit offset when extracting raw payload

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    scsi: target: tcmu: Fix use-after-free of se_cmd->priv


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-class-devlink      |   4 +-
 Documentation/ABI/testing/sysfs-devices-consumer   |   5 +-
 Documentation/ABI/testing/sysfs-devices-supplier   |   5 +-
 .../admin-guide/device-mapper/dm-integrity.rst     |  12 +-
 Documentation/admin-guide/kernel-parameters.txt    |   4 +
 Makefile                                           |   4 +-
 arch/arm/xen/enlighten.c                           |   2 +-
 arch/arm64/include/asm/atomic.h                    |  10 +-
 arch/arm64/kernel/signal.c                         |   7 -
 arch/arm64/kernel/syscall.c                        |   9 +-
 arch/powerpc/include/asm/exception-64s.h           |  13 ++
 arch/powerpc/include/asm/feature-fixups.h          |  10 ++
 arch/powerpc/kernel/entry_64.S                     |   2 +-
 arch/powerpc/kernel/exceptions-64s.S               |  19 +++
 arch/powerpc/kernel/vmlinux.lds.S                  |  32 +++--
 arch/powerpc/lib/feature-fixups.c                  |  24 +++-
 arch/riscv/Kconfig                                 |   6 +-
 .../riscv/boot/dts/sifive/hifive-unleashed-a00.dts |   2 +
 arch/riscv/configs/defconfig                       |   2 +
 arch/riscv/kernel/cacheinfo.c                      |  11 +-
 arch/riscv/kernel/entry.S                          |   9 ++
 arch/riscv/kernel/time.c                           |   3 +
 arch/riscv/mm/init.c                               |  16 ++-
 arch/sh/Kconfig                                    |   1 -
 arch/sh/drivers/dma/Kconfig                        |   3 +-
 arch/x86/entry/common.c                            |  10 +-
 arch/x86/hyperv/hv_init.c                          |   4 +
 arch/x86/include/asm/fpu/api.h                     |  15 ++-
 arch/x86/include/asm/mshyperv.h                    |   2 +
 arch/x86/include/asm/topology.h                    |   4 +-
 arch/x86/kernel/cpu/amd.c                          |   4 +-
 arch/x86/kernel/cpu/mshyperv.c                     |  18 +++
 arch/x86/kernel/cpu/topology.c                     |   2 +-
 arch/x86/kernel/fpu/core.c                         |   9 +-
 arch/x86/kernel/setup.c                            |  20 ++-
 arch/x86/kernel/sev-es.c                           |  14 +-
 arch/x86/lib/mmx_32.c                              |  20 ++-
 arch/x86/xen/enlighten_hvm.c                       |  11 +-
 arch/x86/xen/smp_hvm.c                             |  29 +++--
 crypto/xor.c                                       |   2 +
 drivers/acpi/scan.c                                |   2 +
 drivers/base/core.c                                |  44 +++++--
 drivers/base/dd.c                                  |   2 +
 drivers/clk/tegra/clk-tegra30.c                    |   2 +
 drivers/counter/ti-eqep.c                          |  35 -----
 drivers/crypto/Kconfig                             |   1 +
 drivers/gpio/Kconfig                               |   3 +-
 drivers/gpio/gpiolib-cdev.c                        | 145 +++++++++++----------
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   1 -
 drivers/gpu/drm/amd/amdgpu/psp_gfx_if.h            |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c              |  11 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c  |   2 +-
 .../gpu/drm/amd/display/dc/dcn10/dcn10_resource.c  |   4 +-
 .../gpu/drm/amd/display/dc/dcn20/dcn20_resource.c  |   7 +-
 drivers/gpu/drm/drm_atomic_helper.c                |   2 +-
 drivers/gpu/drm/drm_syncobj.c                      |   8 +-
 drivers/gpu/drm/i915/display/intel_ddi.c           |   8 +-
 drivers/gpu/drm/i915/display/intel_dp.c            |  33 ++---
 drivers/gpu/drm/i915/display/intel_dp.h            |   5 +-
 drivers/gpu/drm/i915/display/intel_dp_mst.c        |   2 +-
 drivers/gpu/drm/i915/display/intel_hdcp.c          |   9 ++
 drivers/gpu/drm/i915/gt/intel_breadcrumbs.c        |   9 +-
 drivers/gpu/drm/i915/gt/intel_lrc.c                |   3 +
 drivers/gpu/drm/i915/gt/intel_timeline.c           |  10 +-
 drivers/gpu/drm/i915/i915_request.h                |  37 +++++-
 drivers/gpu/drm/nouveau/dispnv50/disp.c            |   4 +-
 drivers/gpu/drm/nouveau/dispnv50/disp.h            |   2 +-
 drivers/gpu/drm/nouveau/dispnv50/wimmc37b.c        |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadow.c  |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxgm200.c |   8 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/ibus/gf100.c   |  10 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/ibus/gk104.c   |  10 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/mmu/base.c     |   6 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |   1 +
 drivers/hid/Kconfig                                |   1 +
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-input.c                            |   2 +
 drivers/hid/hid-logitech-dj.c                      |   4 +
 drivers/hid/hid-logitech-hidpp.c                   |   2 +
 drivers/hid/hid-multitouch.c                       |   4 +
 drivers/hv/vmbus_drv.c                             |   2 -
 drivers/hwtracing/intel_th/pci.c                   |   5 +
 drivers/hwtracing/stm/heartbeat.c                  |   6 +-
 drivers/i2c/busses/Kconfig                         |   1 +
 drivers/i2c/busses/i2c-octeon-core.c               |   2 +-
 drivers/i2c/busses/i2c-tegra-bpmp.c                |   2 +-
 drivers/i2c/busses/i2c-tegra.c                     |   2 +-
 drivers/iio/adc/ti_am335x_adc.c                    |   6 +-
 drivers/iio/common/st_sensors/st_sensors_trigger.c |  31 +++--
 drivers/iio/dac/ad5504.c                           |   4 +-
 drivers/iio/temperature/mlx90632.c                 |   6 +
 drivers/infiniband/core/cma_configfs.c             |   4 +-
 drivers/infiniband/core/ucma.c                     | 135 ++++++++++---------
 drivers/infiniband/core/umem.c                     |   2 +-
 drivers/interconnect/imx/imx8mq.c                  |   2 +
 drivers/irqchip/irq-mips-cpu.c                     |   7 +
 drivers/lightnvm/core.c                            |   3 +-
 drivers/md/Kconfig                                 |   1 +
 drivers/md/dm-crypt.c                              |   6 +-
 drivers/md/dm-integrity.c                          |  32 ++++-
 drivers/md/dm-table.c                              |  15 ++-
 drivers/mmc/core/queue.c                           |   4 +-
 drivers/mmc/host/sdhci-brcmstb.c                   |   6 +-
 drivers/mmc/host/sdhci-of-dwcmshc.c                |  27 ++++
 drivers/mmc/host/sdhci-xenon.c                     |   7 +-
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c         |   2 +-
 drivers/mtd/nand/raw/nandsim.c                     |   7 +-
 drivers/net/can/dev.c                              |   4 +-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |   8 +-
 drivers/net/can/vxcan.c                            |   6 +-
 drivers/net/dsa/b53/b53_common.c                   |   2 +-
 drivers/net/dsa/mv88e6xxx/global1_vtu.c            |   4 +
 drivers/net/ethernet/broadcom/bcmsysport.c         |   6 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |   6 +
 drivers/net/ethernet/mscc/ocelot.c                 |  23 +++-
 drivers/net/ethernet/mscc/ocelot_net.c             |   4 +-
 drivers/net/ethernet/renesas/sh_eth.c              |   4 +-
 drivers/nvme/host/pci.c                            | 105 +++++++++------
 drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c         |   2 +-
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c   |   4 +
 drivers/pinctrl/pinctrl-ingenic.c                  |  26 ++--
 drivers/pinctrl/qcom/pinctrl-msm.c                 |  96 +++++++++-----
 drivers/pinctrl/qcom/pinctrl-msm.h                 |   2 +
 drivers/platform/x86/hp-wmi.c                      |   3 +-
 drivers/platform/x86/i2c-multi-instantiate.c       |  31 +++--
 drivers/platform/x86/ideapad-laptop.c              |  15 ++-
 drivers/platform/x86/intel-vbtn.c                  |   6 -
 drivers/scsi/megaraid/megaraid_sas_base.c          |   6 +-
 drivers/scsi/qedi/qedi_main.c                      |   4 +-
 drivers/scsi/scsi_debug.c                          |   5 +-
 drivers/scsi/sd.c                                  |   4 +-
 drivers/scsi/ufs/Kconfig                           |   1 +
 drivers/scsi/ufs/ufshcd.c                          |  35 ++---
 drivers/target/target_core_user.c                  |  11 +-
 drivers/tty/n_tty.c                                |   7 +-
 drivers/tty/serial/mvebu-uart.c                    |  10 +-
 drivers/tty/serial/sifive.c                        |   1 +
 drivers/tty/tty_io.c                               |  51 ++++----
 drivers/usb/cdns3/cdns3-imx.c                      |  17 +--
 drivers/usb/gadget/udc/aspeed-vhub/epn.c           |   5 +-
 drivers/usb/gadget/udc/bdc/Kconfig                 |   2 +-
 drivers/usb/gadget/udc/core.c                      |  13 +-
 drivers/usb/gadget/udc/dummy_hcd.c                 |  10 +-
 drivers/usb/host/ehci-hcd.c                        |  12 ++
 drivers/usb/host/ehci-hub.c                        |   3 +
 drivers/usb/host/xhci-ring.c                       |   2 +
 drivers/usb/host/xhci-tegra.c                      |   7 +
 drivers/xen/events/events_base.c                   |  10 --
 drivers/xen/platform-pci.c                         |   1 -
 drivers/xen/xenbus/xenbus.h                        |   1 +
 drivers/xen/xenbus/xenbus_comms.c                  |   8 --
 drivers/xen/xenbus/xenbus_probe.c                  |  81 ++++++++++--
 fs/btrfs/backref.c                                 |   2 +-
 fs/btrfs/block-group.c                             |   3 +-
 fs/btrfs/disk-io.c                                 |   2 +-
 fs/btrfs/extent-tree.c                             |  10 +-
 fs/btrfs/print-tree.c                              |  10 +-
 fs/btrfs/print-tree.h                              |   2 +-
 fs/btrfs/send.c                                    |  15 +++
 fs/btrfs/volumes.c                                 |   2 +
 fs/cachefiles/rdwr.c                               |   2 -
 fs/cifs/transport.c                                |   4 +-
 fs/fs-writeback.c                                  |  24 ++--
 fs/io_uring.c                                      |  43 +++++-
 fs/kernfs/file.c                                   |  65 ++++-----
 fs/nfsd/nfs4xdr.c                                  |  14 +-
 fs/pipe.c                                          |   1 +
 fs/proc/proc_sysctl.c                              |   7 +-
 include/asm-generic/bitops/atomic.h                |   6 +-
 include/linux/device.h                             |  12 ++
 include/linux/tty.h                                |   1 +
 include/net/inet_connection_sock.h                 |   3 +
 include/net/sock.h                                 |  17 ++-
 include/xen/xenbus.h                               |   2 +-
 kernel/bpf/bpf_inode_storage.c                     |   5 +-
 kernel/bpf/syscall.c                               |   6 +-
 kernel/locking/lockdep.c                           |   2 +-
 kernel/printk/printk.c                             |   4 +-
 kernel/printk/printk_ringbuffer.c                  |   2 +-
 lib/iov_iter.c                                     |   2 +-
 mm/kasan/init.c                                    |  23 ++--
 mm/memcontrol.c                                    |   4 +-
 mm/migrate.c                                       |  23 ++--
 mm/page_alloc.c                                    |  84 +++++++-----
 net/bpf/test_run.c                                 |   3 +-
 net/core/dev.c                                     |   5 +
 net/core/devlink.c                                 |   4 +-
 net/core/gen_estimator.c                           |  11 +-
 net/core/skbuff.c                                  |   6 +-
 net/ipv4/inet_connection_sock.c                    |   1 +
 net/ipv4/netfilter/ipt_rpfilter.c                  |   2 +-
 net/ipv4/tcp.c                                     |   1 +
 net/ipv4/tcp_input.c                               |   6 +-
 net/ipv4/tcp_ipv4.c                                |  29 +++--
 net/ipv4/tcp_output.c                              |   1 +
 net/ipv4/tcp_timer.c                               |  36 +++--
 net/ipv4/udp.c                                     |   3 +-
 net/ipv6/addrconf.c                                |   3 +-
 net/sched/cls_flower.c                             |  22 ++--
 net/sched/cls_tcindex.c                            |   8 +-
 net/sched/sch_api.c                                |   3 +-
 net/sunrpc/svcsock.c                               |  86 +++++++++++-
 net/xdp/xsk.c                                      |   4 +-
 sound/core/seq/oss/seq_oss_synth.c                 |   3 +-
 sound/pci/hda/hda_codec.c                          |  24 +---
 sound/pci/hda/hda_tegra.c                          |   2 +-
 sound/pci/hda/patch_realtek.c                      |   8 ++
 sound/pci/hda/patch_via.c                          |   1 +
 sound/soc/codecs/rt711.c                           |   6 +
 sound/soc/intel/boards/haswell.c                   |   1 +
 sound/soc/sof/intel/hda-codec.c                    |  18 +--
 sound/soc/sof/intel/hda-dsp.c                      |   6 +-
 tools/gpio/gpio-event-mon.c                        |   4 +-
 tools/gpio/gpio-watch.c                            |   5 +-
 tools/lib/perf/evlist.c                            |  17 +--
 tools/lib/perf/tests/test-cpumap.c                 |   2 +-
 tools/lib/perf/tests/test-evlist.c                 |   3 +-
 tools/lib/perf/tests/test-evsel.c                  |   2 +-
 tools/lib/perf/tests/test-threadmap.c              |   2 +-
 tools/testing/selftests/net/fib_tests.sh           |   1 -
 .../testing/selftests/powerpc/mm/pkey_exec_prot.c  |   2 +-
 tools/testing/selftests/powerpc/mm/pkey_siginfo.c  |   2 +-
 222 files changed, 1642 insertions(+), 919 deletions(-)


