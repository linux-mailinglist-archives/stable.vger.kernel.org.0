Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2FF1408C6B
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236206AbhIMNTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:19:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236903AbhIMNSJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:18:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1ED6560724;
        Mon, 13 Sep 2021 13:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539013;
        bh=AC7UAen498o0S7hqGu7+29ch6BQe3OvO0MKxr3O/Zxg=;
        h=From:To:Cc:Subject:Date:From;
        b=A6EJcwTpXMIbHMZYxTFHuTdsueY3+GAnLz9qof5zGdz1cMWIExFg+GlsanJG8moag
         I1pbqAW+WvsJvrnybYb6GKS3umEMIe/pxEMxO4bpigJKCL7q2yu+d5NzeXsEmHYGtG
         8VTa8L4jxjaGFwUPdcghZnXYTR56k3m8woJg+Joc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 000/144] 5.4.146-rc1 review
Date:   Mon, 13 Sep 2021 15:13:01 +0200
Message-Id: <20210913131047.974309396@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.146-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.146-rc1
X-KernelTest-Deadline: 2021-09-15T13:10+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.146 release.
There are 144 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 15 Sep 2021 13:10:21 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.146-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.146-rc1

Linus Walleij <linus.walleij@linaro.org>
    clk: kirkwood: Fix a clocking boot regression

Daniel Thompson <daniel.thompson@linaro.org>
    backlight: pwm_bl: Improve bootloader/kernel device handover

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    fbmem: don't allow too huge resolutions

THOBY Simon <Simon.THOBY@viveris.fr>
    IMA: remove the dependency on CRYPTO_MD5

Austin Kim <austin.kim@lge.com>
    IMA: remove -Wmissing-prototypes warning

Miklos Szeredi <mszeredi@redhat.com>
    fuse: flush extending writes

Miklos Szeredi <mszeredi@redhat.com>
    fuse: truncate pagecache on atomic_o_trunc

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Unconditionally clear nested.pi_pending on nested VM-Enter

Zelin Deng <zelin.deng@linux.alibaba.com>
    KVM: x86: Update vCPU's hv_clock before back to guest when tsc_offset is adjusted

Halil Pasic <pasic@linux.ibm.com>
    KVM: s390: index kvm->arch.idle_mask by vcpu_idx

Babu Moger <babu.moger@amd.com>
    x86/resctrl: Fix a maybe-uninitialized build warning treated as error

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd/ibs: Extend PERF_PMU_CAP_NO_EXCLUDE to IBS Op

Nguyen Dinh Phi <phind.uet@gmail.com>
    tty: Fix data race between tiocsti() and flush_to_ldisc()

Lukas Hannen <lukas.hannen@opensource.tttech-industrial.com>
    time: Handle negative seconds correctly in timespec64_to_ns()

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix pointer arithmetic mask tightening under state pruning

Lorenz Bauer <lmb@cloudflare.com>
    bpf: verifier: Allocate idmap scratch in verifier env

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix leakage due to insufficient speculative store bypass mitigation

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Introduce BPF nospec instruction for mitigating Spectre v4

Eric Dumazet <edumazet@google.com>
    ipv4: fix endianness issue in inet_rtm_getroute_build_skb()

Subbaraya Sundeep <sbhatta@marvell.com>
    octeontx2-af: Fix loop in free and unmap counter

Stefan Wahren <stefan.wahren@i2se.com>
    net: qualcomm: fix QCA7000 checksum handling

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    net: sched: Fix qdisc_rate_table refcount leak when get tcf_block failed

Eric Dumazet <edumazet@google.com>
    ipv4: make exception cache less predictible

Eric Dumazet <edumazet@google.com>
    ipv6: make exception cache less predictible

Ahmad Fatoum <a.fatoum@pengutronix.de>
    brcmfmac: pcie: fix oops on failure to resume and reprobe

Zenghui Yu <yuzenghui@huawei.com>
    bcma: Fix memory leak for internally-handled cores

Dan Carpenter <dan.carpenter@oracle.com>
    ath6kl: wmi: fix an error code in ath6kl_wmi_sync_point()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ASoC: wcd9335: Disable irq on slave ports in the remove function

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ASoC: wcd9335: Fix a memory leak in the error handling path of the probe function

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ASoC: wcd9335: Fix a double irq free in the remove function

Andy Duan <fugang.duan@nxp.com>
    tty: serial: fsl_lpuart: fix the wrong mapbase value

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    usb: bdc: Fix an error handling path in 'bdc_probe()' when no suitable DMA config is available

Evgeny Novikov <novikov@ispras.ru>
    usb: ehci-orion: Handle errors of clk_prepare_enable() in probe

Sergey Shtylyov <s.shtylyov@omp.ru>
    i2c: mt65xx: fix IRQ check

Len Baker <len.baker@gmx.com>
    CIFS: Fix a potencially linear read overflow

Andrey Ignatov <rdna@fb.com>
    bpf: Fix possible out of bound write in narrow load handling

Tony Lindgren <tony@atomide.com>
    mmc: moxart: Fix issue with uninitialized dma_slave_config

Tony Lindgren <tony@atomide.com>
    mmc: dw_mmc: Fix issue with uninitialized dma_slave_config

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: Skylake: Fix module resource and format selection

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: Skylake: Leave data as is when invoking TLV IPCs

Dan Carpenter <dan.carpenter@oracle.com>
    rsi: fix an error code in rsi_probe()

Dan Carpenter <dan.carpenter@oracle.com>
    rsi: fix error code in rsi_load_9116_firmware()

Sergey Shtylyov <s.shtylyov@omp.ru>
    i2c: s3c2410: fix IRQ check

Sergey Shtylyov <s.shtylyov@omp.ru>
    i2c: iop3xx: fix deferred probing

Pavel Skripkin <paskripkin@gmail.com>
    Bluetooth: add timeout sanity check to hci_inquiry

Xu Yu <xuyu@linux.alibaba.com>
    mm/swap: consider max pages in iomap_swapfile_add_extent

Nadezda Lutovinova <lutovinova@ispras.ru>
    usb: gadget: mv_u3d: request_irq() after initializing UDC

J. Bruce Fields <bfields@redhat.com>
    nfsd4: Fix forced-expiry locking

Benjamin Coddington <bcodding@redhat.com>
    lockd: Fix invalid lockowner cast after vfs_test_lock

Chih-Kang Chang <gary.chang@realtek.com>
    mac80211: Fix insufficient headroom issue for AMSDU

Sergey Shtylyov <s.shtylyov@omp.ru>
    usb: phy: tahvo: add IRQ check

Sergey Shtylyov <s.shtylyov@omp.ru>
    usb: host: ohci-tmio: add IRQ check

Kai-Heng Feng <kai.heng.feng@canonical.com>
    Bluetooth: Move shutdown callback before flushing tx and rx queue

Geert Uytterhoeven <geert+renesas@glider.be>
    usb: gadget: udc: renesas_usb3: Fix soc_device_match() abuse

Sergey Shtylyov <s.shtylyov@omp.ru>
    usb: phy: twl6030: add IRQ checks

Sergey Shtylyov <s.shtylyov@omp.ru>
    usb: phy: fsl-usb: add IRQ check

Sergey Shtylyov <s.shtylyov@omp.ru>
    usb: gadget: udc: at91: add IRQ check

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    drm/msm/dsi: Fix some reference counted resource leaks

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    Bluetooth: fix repeated calls to sco_sock_kill

William Breathitt Gray <vilhelm.gray@gmail.com>
    counter: 104-quad-8: Return error when invalid mode during ceiling_write

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    arm64: dts: exynos: correct GIC CPU interfaces address range on Exynos7

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: make dpu_hw_ctl_clear_all_blendstages clear necessary LMs

Lukasz Luba <lukasz.luba@arm.com>
    PM: EM: Increase energy calculation precision

Colin Ian King <colin.king@canonical.com>
    Bluetooth: increase BTNAMSIZ to 21 chars to fix potential buffer overflow

Sven Eckelmann <sven@narfation.org>
    debugfs: Return error during {full/open}_proxy_open() on rmmod

Stephan Gerhold <stephan@gerhold.net>
    soc: qcom: smsm: Fix missed interrupts if state changes while masked

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI: PM: Enable PME if it can be signaled from D3cold

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI: PM: Avoid forcing PCI_D0 for wakeup reasons inconsistently

Colin Ian King <colin.king@canonical.com>
    media: venus: venc: Fix potential null pointer dereference on pointer fmt

Dongliang Mu <mudongliangabcd@gmail.com>
    media: em28xx-input: fix refcount bug in em28xx_usb_disconnect

Hans de Goede <hdegoede@redhat.com>
    leds: trigger: audio: Add an activate callback to ensure the initial brightness is set

Andy Shevchenko <andy.shevchenko@gmail.com>
    leds: lt3593: Put fwnode in any case during ->probe()

Sergey Shtylyov <s.shtylyov@omp.ru>
    i2c: highlander: add IRQ check

Pavel Skripkin <paskripkin@gmail.com>
    net: cipso: fix warnings in netlbl_cipsov4_add_std

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Fix a partition bug with hotplug

Maxim Mikityanskiy <maximmi@nvidia.com>
    net/mlx5e: Prohibit inner indir TIRs in IPoIB

Anand Moon <linux.amoon@gmail.com>
    ARM: dts: meson8b: ec100: Fix the pwm regulator supply properties

Anand Moon <linux.amoon@gmail.com>
    ARM: dts: meson8b: mxq: Fix the pwm regulator supply properties

Anand Moon <linux.amoon@gmail.com>
    ARM: dts: meson8b: odroidc1: Fix the pwm regulator supply properties

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    ARM: dts: meson8: Use a higher default GPU clock frequency

Martin KaFai Lau <kafai@fb.com>
    tcp: seq_file: Avoid skipping sk during tcp_seek_last_pos

Kai-Heng Feng <kai.heng.feng@canonical.com>
    drm/amdgpu/acp: Make PM domain really work

Guillaume Nault <gnault@redhat.com>
    netns: protect netns ID lookups with RCU

Colin Ian King <colin.king@canonical.com>
    6lowpan: iphc: Fix an off-by-one check of array index

Dan Carpenter <dan.carpenter@oracle.com>
    Bluetooth: sco: prevent information leak in sco_conn_defer_accept()

Philipp Zabel <p.zabel@pengutronix.de>
    media: coda: fix frame_mem_ctrl for YUV420 and YVU420 formats

Pavel Skripkin <paskripkin@gmail.com>
    media: go7007: remove redundant initialization

Dongliang Mu <mudongliangabcd@gmail.com>
    media: dvb-usb: Fix error handling in dvb_usb_i2c_init

Dongliang Mu <mudongliangabcd@gmail.com>
    media: dvb-usb: fix uninit-value in vp702x_read_mac_addr

Dongliang Mu <mudongliangabcd@gmail.com>
    media: dvb-usb: fix uninit-value in dvb_usb_adapter_dvb_init

Bjorn Andersson <bjorn.andersson@linaro.org>
    soc: qcom: rpmhpd: Use corner in power_off

Geert Uytterhoeven <geert@linux-m68k.org>
    arm64: dts: renesas: r8a77995: draak: Remove bogus adv7511w properties

Dylan Hung <dylan_hung@aspeedtech.com>
    ARM: dts: aspeed-g6: Fix HVI3C function-group in pinctrl dtsi

He Fengqing <hefengqing@huawei.com>
    bpf: Fix potential memleak and UAF in the verifier.

Kuniyuki Iwashima <kuniyu@amazon.co.jp>
    bpf: Fix a typo of reuseport map in bpf.h.

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: cxd2880-spi: Fix an error handling path

Geert Uytterhoeven <geert+renesas@glider.be>
    soc: rockchip: ROCKCHIP_GRF should not default to y, unconditionally

Krzysztof Hałasa <khalasa@piap.pl>
    media: TDA1997x: enable EDID support

Wei Yongjun <weiyongjun1@huawei.com>
    drm/panfrost: Fix missing clk_disable_unprepare() on error in panfrost_clk_init()

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/i10nm: Fix NVDIMM detection

Quanyang Wang <quanyang.wang@windriver.com>
    spi: spi-zynq-qspi: use wait_for_completion_timeout to make zynq_qspi_exec_mem_op not interruptible

Chunyan Zhang <chunyan.zhang@unisoc.com>
    spi: sprd: Fix the wrong WDG_LOAD_VAL

Chen-Yu Tsai <wenst@chromium.org>
    regulator: vctrl: Avoid lockdep warning in enable/disable ops

Chen-Yu Tsai <wenst@chromium.org>
    regulator: vctrl: Use locked regulator_get_voltage in probe path

Stefan Berger <stefanb@linux.ibm.com>
    certs: Trigger creation of RSA module signing key if it's not an RSA key

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - use proper type for vf_mask

Pavel Skripkin <paskripkin@gmail.com>
    block: nbd: add sanity check for first_minor

Phong Hoang <phong.hoang.wz@renesas.com>
    clocksource/drivers/sh_cmt: Fix wrong setting if don't request IRQ for clock source channel

Hongbo Li <herberthbli@tencent.com>
    lib/mpi: use kcalloc in mpi_resize

Zhen Lei <thunder.leizhen@huawei.com>
    genirq/timings: Fix error return code in irq_timings_test_irqs()

Tony Lindgren <tony@atomide.com>
    spi: spi-pic32: Fix issue with uninitialized dma_slave_config

Tony Lindgren <tony@atomide.com>
    spi: spi-fsl-dspi: Fix issue with uninitialized dma_slave_config

Quentin Perret <qperret@google.com>
    sched: Fix UCLAMP_FLAG_IDLE setting

Pavel Skripkin <paskripkin@gmail.com>
    m68k: emu: Fix invalid free in nfeth_cleanup()

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/debug: fix debug area life cycle

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/kasan: fix large PMD pages address alignment check

Stian Skjelstad <stian.skjelstad@gmail.com>
    udf_get_extendedattr() had no boundary checks.

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    fcntl: fix potential deadlock for &fasync_struct.fa_lock

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - do not export adf_iov_putmsg()

Marco Chiappero <marco.chiappero@intel.com>
    crypto: qat - fix naming for init/shutdown VF to PF notifications

Marco Chiappero <marco.chiappero@intel.com>
    crypto: qat - fix reuse of completion variable

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - handle both source of interrupt in VF ISR

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - do not ignore errors from enable_vf2pf_comms()

Damien Le Moal <damien.lemoal@wdc.com>
    libata: fix ata_host_start()

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: add dev_busid sysfs entry for each subchannel

Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
    power: supply: max17042_battery: fix typo in MAx17042_TOFF

Amit Engel <amit.engel@dell.com>
    nvmet: pass back cntlid on successful completion

Ruozhu Li <liruozhu@huawei.com>
    nvme-rdma: don't update queue count when failing to set io queues

Ruozhu Li <liruozhu@huawei.com>
    nvme-tcp: don't update queue count when failing to set io queues

Christoph Hellwig <hch@lst.de>
    bcache: add proper error unwinding in bcache_device_init

Pali Rohár <pali@kernel.org>
    isofs: joliet: Fix iocharset=utf8 mount option

Pali Rohár <pali@kernel.org>
    udf: Fix iocharset=utf8 mount option

Jan Kara <jack@suse.cz>
    udf: Check LVID earlier

Thomas Gleixner <tglx@linutronix.de>
    hrtimer: Ensure timerfd notification for HIGHRES=n

Thomas Gleixner <tglx@linutronix.de>
    hrtimer: Avoid double reprogramming in __hrtimer_start_range_ns()

Frederic Weisbecker <frederic@kernel.org>
    posix-cpu-timers: Force next expiration recalc after itimer reset

Sergey Senozhatsky <senozhatsky@chromium.org>
    rcu/tree: Handle VM stoppage in stall detection

Dietmar Eggemann <dietmar.eggemann@arm.com>
    sched/deadline: Fix missing clock update in migrate_task_rq_dl()

Tony Lindgren <tony@atomide.com>
    crypto: omap-sham - clear dma flags only after omap_sham_update_dma_stop()

Hans de Goede <hdegoede@redhat.com>
    power: supply: axp288_fuel_gauge: Report register-address on readb / writeb errors

Quentin Perret <qperret@google.com>
    sched/deadline: Fix reset_on_fork reporting of DL tasks

Sean Anderson <sean.anderson@seco.com>
    crypto: mxs-dcp - Check for DMA mapping errors

Jeongtae Park <jeongtae.park@gmail.com>
    regmap: fix the offset of register error log

Peter Zijlstra <peterz@infradead.org>
    locking/mutex: Fix HANDOFF condition


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi           |   4 +-
 arch/arm/boot/dts/meson8.dtsi                      |   5 +
 arch/arm/boot/dts/meson8b-ec100.dts                |   4 +-
 arch/arm/boot/dts/meson8b-mxq.dts                  |   4 +-
 arch/arm/boot/dts/meson8b-odroidc1.dts             |   4 +-
 arch/arm/net/bpf_jit_32.c                          |   3 +
 arch/arm64/boot/dts/exynos/exynos7.dtsi            |   2 +-
 arch/arm64/boot/dts/renesas/r8a77995-draak.dts     |   4 -
 arch/arm64/net/bpf_jit_comp.c                      |  13 ++
 arch/m68k/emu/nfeth.c                              |   4 +-
 arch/mips/net/ebpf_jit.c                           |   3 +
 arch/powerpc/net/bpf_jit_comp64.c                  |   6 +
 arch/riscv/net/bpf_jit_comp.c                      |   4 +
 arch/s390/include/asm/kvm_host.h                   |   1 +
 arch/s390/kernel/debug.c                           | 102 ++++++------
 arch/s390/kvm/interrupt.c                          |  12 +-
 arch/s390/kvm/kvm-s390.c                           |   2 +-
 arch/s390/kvm/kvm-s390.h                           |   2 +-
 arch/s390/mm/kasan_init.c                          |  41 +++--
 arch/s390/net/bpf_jit_comp.c                       |   5 +
 arch/sparc/net/bpf_jit_comp_64.c                   |   3 +
 arch/x86/events/amd/ibs.c                          |   1 +
 arch/x86/kernel/cpu/resctrl/monitor.c              |   6 +
 arch/x86/kvm/vmx/nested.c                          |   7 +-
 arch/x86/kvm/x86.c                                 |   4 +
 arch/x86/net/bpf_jit_comp.c                        |   7 +
 arch/x86/net/bpf_jit_comp32.c                      |   6 +
 certs/Makefile                                     |   8 +
 drivers/ata/libata-core.c                          |   2 +-
 drivers/base/regmap/regmap.c                       |   2 +-
 drivers/bcma/main.c                                |   6 +-
 drivers/block/nbd.c                                |  10 ++
 drivers/clk/mvebu/kirkwood.c                       |   1 +
 drivers/clocksource/sh_cmt.c                       |  30 ++--
 drivers/counter/104-quad-8.c                       |   5 +-
 drivers/crypto/mxs-dcp.c                           |  45 +++--
 drivers/crypto/omap-sham.c                         |   2 +-
 .../crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c   |   4 +-
 drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c |   4 +-
 drivers/crypto/qat/qat_common/adf_common_drv.h     |   8 +-
 drivers/crypto/qat/qat_common/adf_init.c           |   5 +-
 drivers/crypto/qat/qat_common/adf_isr.c            |   7 +-
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c      |   3 +-
 drivers/crypto/qat/qat_common/adf_vf2pf_msg.c      |  12 +-
 drivers/crypto/qat/qat_common/adf_vf_isr.c         |   7 +-
 .../qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c    |   4 +-
 drivers/edac/i10nm_base.c                          |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c            |  54 +++---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c         |  10 +-
 drivers/gpu/drm/msm/dsi/dsi.c                      |   6 +-
 drivers/gpu/drm/panfrost/panfrost_device.c         |   3 +-
 drivers/i2c/busses/i2c-highlander.c                |   2 +-
 drivers/i2c/busses/i2c-iop3xx.c                    |   6 +-
 drivers/i2c/busses/i2c-mt65xx.c                    |   2 +-
 drivers/i2c/busses/i2c-s3c2410.c                   |   2 +-
 drivers/leds/leds-lt3593.c                         |   5 +-
 drivers/leds/trigger/ledtrig-audio.c               |  37 ++++-
 drivers/md/bcache/super.c                          |  16 +-
 drivers/media/i2c/tda1997x.c                       |   1 +
 drivers/media/platform/coda/coda-bit.c             |  18 +-
 drivers/media/platform/qcom/venus/venc.c           |   2 +
 drivers/media/spi/cxd2880-spi.c                    |   7 +-
 drivers/media/usb/dvb-usb/dvb-usb-i2c.c            |   9 +-
 drivers/media/usb/dvb-usb/dvb-usb-init.c           |   2 +-
 drivers/media/usb/dvb-usb/nova-t-usb2.c            |   6 +-
 drivers/media/usb/dvb-usb/vp702x.c                 |  12 +-
 drivers/media/usb/em28xx/em28xx-input.c            |   1 -
 drivers/media/usb/go7007/go7007-driver.c           |  26 ---
 drivers/mmc/host/dw_mmc.c                          |   1 +
 drivers/mmc/host/moxart-mmc.c                      |   1 +
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |   6 -
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |  10 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |  18 +-
 drivers/net/ethernet/qualcomm/qca_spi.c            |   2 +-
 drivers/net/ethernet/qualcomm/qca_uart.c           |   2 +-
 drivers/net/wireless/ath/ath6kl/wmi.c              |   4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   2 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c             |   4 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c             |   1 +
 drivers/nvme/host/rdma.c                           |   4 +-
 drivers/nvme/host/tcp.c                            |   4 +-
 drivers/nvme/target/fabrics-cmd.c                  |   9 +-
 drivers/pci/pci.c                                  |  25 ++-
 drivers/power/supply/axp288_fuel_gauge.c           |   4 +-
 drivers/power/supply/max17042_battery.c            |   2 +-
 drivers/regulator/vctrl-regulator.c                |  73 ++++----
 drivers/s390/cio/css.c                             |  17 ++
 drivers/soc/qcom/rpmhpd.c                          |   5 +-
 drivers/soc/qcom/smsm.c                            |  11 +-
 drivers/soc/rockchip/Kconfig                       |   4 +-
 drivers/spi/spi-fsl-dspi.c                         |   1 +
 drivers/spi/spi-pic32.c                            |   1 +
 drivers/spi/spi-sprd-adi.c                         |   2 +-
 drivers/spi/spi-zynq-qspi.c                        |   8 +-
 drivers/tty/serial/fsl_lpuart.c                    |   2 +-
 drivers/tty/tty_io.c                               |   4 +-
 drivers/usb/gadget/udc/at91_udc.c                  |   4 +-
 drivers/usb/gadget/udc/bdc/bdc_core.c              |   3 +-
 drivers/usb/gadget/udc/mv_u3d_core.c               |  19 ++-
 drivers/usb/gadget/udc/renesas_usb3.c              |  17 +-
 drivers/usb/host/ehci-orion.c                      |   8 +-
 drivers/usb/host/ohci-tmio.c                       |   3 +
 drivers/usb/phy/phy-fsl-usb.c                      |   2 +
 drivers/usb/phy/phy-tahvo.c                        |   4 +-
 drivers/usb/phy/phy-twl6030-usb.c                  |   5 +
 drivers/video/backlight/pwm_bl.c                   |  54 +++---
 drivers/video/fbdev/core/fbmem.c                   |   6 +
 fs/cifs/cifs_unicode.c                             |   9 +-
 fs/debugfs/file.c                                  |   8 +-
 fs/fcntl.c                                         |   5 +-
 fs/fuse/file.c                                     |   9 +-
 fs/iomap/swapfile.c                                |   6 +
 fs/isofs/inode.c                                   |  27 ++-
 fs/isofs/isofs.h                                   |   1 -
 fs/isofs/joliet.c                                  |   4 +-
 fs/lockd/svclock.c                                 |   2 +-
 fs/nfsd/nfs4state.c                                |   4 +-
 fs/udf/misc.c                                      |  13 +-
 fs/udf/super.c                                     |  75 ++++-----
 fs/udf/udf_sb.h                                    |   2 -
 fs/udf/unicode.c                                   |   4 +-
 include/linux/bpf_verifier.h                       |  11 +-
 include/linux/energy_model.h                       |  16 ++
 include/linux/filter.h                             |  15 ++
 include/linux/hrtimer.h                            |   5 -
 include/linux/power/max17042_battery.h             |   2 +-
 include/linux/time64.h                             |   9 +-
 include/uapi/linux/bpf.h                           |   2 +-
 kernel/bpf/core.c                                  |  18 +-
 kernel/bpf/disasm.c                                |  16 +-
 kernel/bpf/verifier.c                              | 183 +++++++++------------
 kernel/cgroup/cpuset.c                             |   7 +
 kernel/irq/timings.c                               |   2 +
 kernel/locking/mutex.c                             |  15 +-
 kernel/power/energy_model.c                        |   4 +-
 kernel/rcu/tree_stall.h                            |  18 ++
 kernel/sched/core.c                                |  25 ++-
 kernel/sched/deadline.c                            |   8 +-
 kernel/sched/sched.h                               |   2 +
 kernel/time/hrtimer.c                              |  92 ++++++++---
 kernel/time/posix-cpu-timers.c                     |   2 -
 kernel/time/tick-internal.h                        |   3 +
 lib/mpi/mpiutil.c                                  |   2 +-
 net/6lowpan/debugfs.c                              |   3 +-
 net/bluetooth/cmtp/cmtp.h                          |   2 +-
 net/bluetooth/hci_core.c                           |  14 ++
 net/bluetooth/sco.c                                |  11 +-
 net/core/net_namespace.c                           |  28 ++--
 net/ipv4/route.c                                   |  48 ++++--
 net/ipv4/tcp_ipv4.c                                |   5 +-
 net/ipv6/route.c                                   |   5 +-
 net/mac80211/tx.c                                  |   4 +-
 net/netlabel/netlabel_cipso_v4.c                   |   8 +-
 net/sched/sch_cbq.c                                |   2 +-
 security/integrity/ima/Kconfig                     |   1 -
 security/integrity/ima/ima_mok.c                   |   2 +-
 sound/soc/codecs/wcd9335.c                         |  23 ++-
 sound/soc/intel/skylake/skl-topology.c             |  25 ++-
 tools/include/uapi/linux/bpf.h                     |   2 +-
 161 files changed, 1105 insertions(+), 720 deletions(-)


