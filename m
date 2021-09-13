Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466CB408EAB
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240585AbhIMNgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:36:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:52252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242505AbhIMN3h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:29:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E19E61356;
        Mon, 13 Sep 2021 13:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539460;
        bh=sC7AEFihWtv9fFrMGPNfe3v+ArMbTxTNcLaBr54x5/8=;
        h=From:To:Cc:Subject:Date:From;
        b=zpEMDosLIalWO/CJDIoik+Ey7L6aeYyqMEGW4sjjpi22Y/oDKQsdPCS4XWH/RuIF2
         h5KZ000BK89UL/IFK5noH+H+HocY80u4nmINlswEZOZRAf45lFvy65FyT00doGxJvy
         KggXcw++wgfWXc3cDy5kIypU+pu358w7b/Jr8M4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 000/236] 5.10.65-rc1 review
Date:   Mon, 13 Sep 2021 15:11:45 +0200
Message-Id: <20210913131100.316353015@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.65-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.65-rc1
X-KernelTest-Deadline: 2021-09-15T13:11+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.65 release.
There are 236 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 15 Sep 2021 13:10:21 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.65-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.65-rc1

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

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: dts: at91: add pinctrl-{names, 0} for all gpios

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Unconditionally clear nested.pi_pending on nested VM-Enter

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: VMX: avoid running vmx_handle_exit_irqoff in case of emulation

Zelin Deng <zelin.deng@linux.alibaba.com>
    KVM: x86: Update vCPU's hv_clock before back to guest when tsc_offset is adjusted

Halil Pasic <pasic@linux.ibm.com>
    KVM: s390: index kvm->arch.idle_mask by vcpu_idx

Sean Christopherson <seanjc@google.com>
    Revert "KVM: x86: mmu: Add guest physical address check in translate_gpa()"

Babu Moger <babu.moger@amd.com>
    x86/resctrl: Fix a maybe-uninitialized build warning treated as error

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd/ibs: Extend PERF_PMU_CAP_NO_EXCLUDE to IBS Op

Nguyen Dinh Phi <phind.uet@gmail.com>
    tty: Fix data race between tiocsti() and flush_to_ldisc()

Pavel Begunkov <asml.silence@gmail.com>
    bio: fix page leak bio_add_hw_page failure

Jens Axboe <axboe@kernel.dk>
    io_uring: IORING_OP_WRITE needs hash_reg_file set

Lukas Hannen <lukas.hannen@opensource.tttech-industrial.com>
    time: Handle negative seconds correctly in timespec64_to_ns()

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: guarantee to write dirty data when enabling checkpoint back

Justin M. Forbes <jforbes@fedoraproject.org>
    iwlwifi Add support for ax201 in Samsung Galaxy Book Flex2 Alpha

Douglas Anderson <dianders@chromium.org>
    ASoC: rt5682: Remove unused variable in rt5682_i2c_remove()

Eric Dumazet <edumazet@google.com>
    ipv4: fix endianness issue in inet_rtm_getroute_build_skb()

Sunil Goutham <sgoutham@marvell.com>
    octeontx2-af: Set proper errorcode for IPv4 checksum errors

Subbaraya Sundeep <sbhatta@marvell.com>
    octeontx2-af: Fix static code analyzer reported issues

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

Sudarsana Reddy Kalluru <skalluru@marvell.com>
    atlantic: Fix driver resume flow.

Dan Carpenter <dan.carpenter@oracle.com>
    ath6kl: wmi: fix an error code in ath6kl_wmi_sync_point()

Brett Creeley <brett.creeley@intel.com>
    ice: Only lock to update netdev dev_addr

Abhishek Naik <abhishek.naik@intel.com>
    iwlwifi: skip first element in the WTAS ACPI table

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: follow the new inclusive terminology

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ASoC: wcd9335: Disable irq on slave ports in the remove function

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ASoC: wcd9335: Fix a memory leak in the error handling path of the probe function

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ASoC: wcd9335: Fix a double irq free in the remove function

Andy Duan <fugang.duan@nxp.com>
    tty: serial: fsl_lpuart: fix the wrong mapbase value

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    usb: bdc: Fix a resource leak in the error handling path of 'bdc_probe()'

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    usb: bdc: Fix an error handling path in 'bdc_probe()' when no suitable DMA config is available

Evgeny Novikov <novikov@ispras.ru>
    usb: ehci-orion: Handle errors of clk_prepare_enable() in probe

Sergey Shtylyov <s.shtylyov@omp.ru>
    i2c: xlp9xx: fix main IRQ check

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

Tony Lindgren <tony@atomide.com>
    mmc: sdhci: Fix issue with uninitialized dma_slave_config

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: Skylake: Fix module resource and format selection

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: Skylake: Leave data as is when invoking TLV IPCs

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: kbl_da7219_max98927: Fix format selection for max98373

Dan Carpenter <dan.carpenter@oracle.com>
    rsi: fix an error code in rsi_probe()

Dan Carpenter <dan.carpenter@oracle.com>
    rsi: fix error code in rsi_load_9116_firmware()

Bob Peterson <rpeterso@redhat.com>
    gfs2: init system threads before freeze lock

Sergey Shtylyov <s.shtylyov@omp.ru>
    i2c: hix5hd2: fix IRQ check

Tian Tao <tiantao6@hisilicon.com>
    i2c: fix platform_get_irq.cocci warnings

Sergey Shtylyov <s.shtylyov@omp.ru>
    i2c: s3c2410: fix IRQ check

Sergey Shtylyov <s.shtylyov@omp.ru>
    i2c: iop3xx: fix deferred probing

Pavel Skripkin <paskripkin@gmail.com>
    Bluetooth: add timeout sanity check to hci_inquiry

Kevin Mitchell <kevmitch@arista.com>
    lkdtm: replace SCSI_DISPATCH_CMD with SCSI_QUEUE_RQ

Xu Yu <xuyu@linux.alibaba.com>
    mm/swap: consider max pages in iomap_swapfile_add_extent

Nadezda Lutovinova <lutovinova@ispras.ru>
    usb: gadget: mv_u3d: request_irq() after initializing UDC

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    firmware: raspberrypi: Fix a leak in 'rpi_firmware_get()'

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    firmware: raspberrypi: Keep count of all consumers

Sergey Shtylyov <s.shtylyov@omp.ru>
    i2c: synquacer: fix deferred probing

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    clk: staging: correct reference to config IOMEM to config HAS_IOMEM

Pali Rohár <pali@kernel.org>
    arm64: dts: marvell: armada-37xx: Extend PCIe MEM space

J. Bruce Fields <bfields@redhat.com>
    nfsd4: Fix forced-expiry locking

Benjamin Coddington <bcodding@redhat.com>
    lockd: Fix invalid lockowner cast after vfs_test_lock

Thomas Gleixner <tglx@linutronix.de>
    locking/local_lock: Add missing owner initialization

Peter Zijlstra <peterz@infradead.org>
    locking/lockdep: Mark local_lock_t

Chih-Kang Chang <gary.chang@realtek.com>
    mac80211: Fix insufficient headroom issue for AMSDU

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Re-build libbpf.so when libbpf.map changes

Sergey Shtylyov <s.shtylyov@omp.ru>
    usb: phy: tahvo: add IRQ check

Sergey Shtylyov <s.shtylyov@omp.ru>
    usb: host: ohci-tmio: add IRQ check

Valentin Schneider <valentin.schneider@arm.com>
    PM: cpu: Make notifier chain use a raw_spinlock_t

Kai-Heng Feng <kai.heng.feng@canonical.com>
    Bluetooth: Move shutdown callback before flushing tx and rx queue

Juhee Kang <claudiajkang@gmail.com>
    samples: pktgen: add missing IPv6 option to pktgen scripts

Leon Romanovsky <leon@kernel.org>
    devlink: Clear whole devlink_flash_notify struct

Ilya Leoshkevich <iii@linux.ibm.com>
    selftests/bpf: Fix test_core_autosize on big-endian machines

Geert Uytterhoeven <geert+renesas@glider.be>
    usb: gadget: udc: renesas_usb3: Fix soc_device_match() abuse

Sergey Shtylyov <s.shtylyov@omp.ru>
    usb: phy: twl6030: add IRQ checks

Sergey Shtylyov <s.shtylyov@omp.ru>
    usb: phy: fsl-usb: add IRQ check

Sergey Shtylyov <s.shtylyov@omp.ru>
    usb: gadget: udc: s3c2410: add IRQ check

Sergey Shtylyov <s.shtylyov@omp.ru>
    usb: gadget: udc: at91: add IRQ check

Sergey Shtylyov <s.shtylyov@omp.ru>
    usb: dwc3: qcom: add IRQ check

Sergey Shtylyov <s.shtylyov@omp.ru>
    usb: dwc3: meson-g12a: add IRQ check

Douglas Anderson <dianders@chromium.org>
    ASoC: rt5682: Properly turn off regulators if wrong device ID

Stephen Boyd <swboyd@chromium.org>
    ASoC: rt5682: Implement remove callback

Parav Pandit <parav@nvidia.com>
    net/mlx5: Fix unpublish devlink parameters

Aya Levin <ayal@nvidia.com>
    net/mlx5: Register to devlink ingress VLAN filter trap

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    drm/msm/dsi: Fix some reference counted resource leaks

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    Bluetooth: fix repeated calls to sco_sock_kill

Curtis Malainey <cujomalainey@chromium.org>
    ASoC: Intel: Fix platform ID matching

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Fix violation of cpuset locking rule

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Miscellaneous code cleanup

William Breathitt Gray <vilhelm.gray@gmail.com>
    counter: 104-quad-8: Return error when invalid mode during ceiling_write

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    arm64: dts: exynos: correct GIC CPU interfaces address range on Exynos7

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: make dpu_hw_ctl_clear_all_blendstages clear necessary LMs

David Heidelberg <david@ixit.cz>
    drm/msm/mdp4: move HW revision detection to earlier phase

David Heidelberg <david@ixit.cz>
    drm/msm/mdp4: refactor HW revision detection into read_mdp_hw_revision

Jose Blanquicet <josebl@microsoft.com>
    selftests/bpf: Fix bpf-iter-tcp4 test to print correctly the dest IP

Lukasz Luba <lukasz.luba@arm.com>
    PM: EM: Increase energy calculation precision

Colin Ian King <colin.king@canonical.com>
    Bluetooth: increase BTNAMSIZ to 21 chars to fix potential buffer overflow

Sven Eckelmann <sven@narfation.org>
    debugfs: Return error during {full/open}_proxy_open() on rmmod

Stephan Gerhold <stephan@gerhold.net>
    soc: qcom: smsm: Fix missed interrupts if state changes while masked

Matthew Cover <werekraken@gmail.com>
    bpf, samples: Add missing mprog-disable to xdp_redirect_cpu's optstring

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

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    net/mlx5: Fix missing return value in mlx5_devlink_eswitch_inline_mode_set()

Leon Romanovsky <leon@kernel.org>
    devlink: Break parameter notification sequence to be before/after unload/load driver

Biju Das <biju.das.jz@bp.renesas.com>
    arm64: dts: renesas: hihope-rzg2-ex: Add EtherAVB internal rx delay

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: renesas: rzg2: Convert EtherAVB to explicit delay handling

Tedd Ho-Jeong An <tedd.an@intel.com>
    Bluetooth: mgmt: Fix wrong opcode in the response for add_adv cmd

Pavel Skripkin <paskripkin@gmail.com>
    net: cipso: fix warnings in netlbl_cipsov4_add_std

Marek Vasut <marex@denx.de>
    drm: mxsfb: Clear FIFO_CLEAR bit

Marek Vasut <marex@denx.de>
    drm: mxsfb: Increase number of outstanding requests on V4 and newer HW

Marek Vasut <marex@denx.de>
    drm: mxsfb: Enable recovery on underflow

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Fix a partition bug with hotplug

Maxim Mikityanskiy <maximmi@nvidia.com>
    net/mlx5e: Block LRO if firmware asks for tunneled LRO

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

Colin Ian King <colin.king@canonical.com>
    6lowpan: iphc: Fix an off-by-one check of array index

Dan Carpenter <dan.carpenter@oracle.com>
    Bluetooth: sco: prevent information leak in sco_conn_defer_accept()

Yizhuo <yzhai003@ucr.edu>
    media: atomisp: fix the uninitialized use and rename "retvalue"

Philipp Zabel <p.zabel@pengutronix.de>
    media: coda: fix frame_mem_ctrl for YUV420 and YVU420 formats

Dan Carpenter <dan.carpenter@oracle.com>
    media: rockchip/rga: fix error handling in probe

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: rockchip/rga: use pm_runtime_resume_and_get()

Pavel Skripkin <paskripkin@gmail.com>
    media: go7007: remove redundant initialization

Pavel Skripkin <paskripkin@gmail.com>
    media: go7007: fix memory leak in go7007_usb_probe

Dongliang Mu <mudongliangabcd@gmail.com>
    media: dvb-usb: Fix error handling in dvb_usb_i2c_init

Dongliang Mu <mudongliangabcd@gmail.com>
    media: dvb-usb: fix uninit-value in vp702x_read_mac_addr

Dongliang Mu <mudongliangabcd@gmail.com>
    media: dvb-usb: fix uninit-value in dvb_usb_adapter_dvb_init

Leon Romanovsky <leon@kernel.org>
    ionic: cleanly release devlink instance

Zhen Lei <thunder.leizhen@huawei.com>
    driver core: Fix error return code in really_probe()

Zhen Lei <thunder.leizhen@huawei.com>
    firmware: fix theoretical UAF race with firmware cache and resume

Colin Ian King <colin.king@canonical.com>
    gfs2: Fix memory leak of object lsi on error return path

Martynas Pumputis <m@lambda.lt>
    libbpf: Fix removal of inner map in bpf_object__create_map

Bjorn Andersson <bjorn.andersson@linaro.org>
    soc: qcom: rpmhpd: Use corner in power_off

Stefan Assmann <sassmann@kpanic.de>
    i40e: improve locking of mac_filter_hash

Geert Uytterhoeven <geert@linux-m68k.org>
    arm64: dts: renesas: r8a77995: draak: Remove bogus adv7511w properties

Dylan Hung <dylan_hung@aspeedtech.com>
    ARM: dts: aspeed-g6: Fix HVI3C function-group in pinctrl dtsi

Shuyi Cheng <chengshuyi@linux.alibaba.com>
    libbpf: Fix the possible memory leak on error

Haiyue Wang <haiyue.wang@intel.com>
    gve: fix the wrong AdminQ buffer overflow check

Steven Price <steven.price@arm.com>
    drm/of: free the iterator object on failure

He Fengqing <hefengqing@huawei.com>
    bpf: Fix potential memleak and UAF in the verifier.

Kuniyuki Iwashima <kuniyu@amazon.co.jp>
    bpf: Fix a typo of reuseport map in bpf.h.

Julia Lawall <Julia.Lawall@inria.fr>
    drm/of: free the right object

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: cxd2880-spi: Fix an error handling path

Geert Uytterhoeven <geert+renesas@glider.be>
    soc: rockchip: ROCKCHIP_GRF should not default to y, unconditionally

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    leds: is31fl32xx: Fix missing error code in is31fl32xx_parse_dt()

Krzysztof Hałasa <khalasa@piap.pl>
    media: TDA1997x: enable EDID support

Zhang Qilong <zhangqilong3@huawei.com>
    ASoC: mediatek: mt8183: Fix Unbalanced pm_runtime_enable in mt8183_afe_pcm_dev_probe

Harshvardhan Jha <harshvardhan.jha@oracle.com>
    drm/gma500: Fix end of loop tests for list_for_each_entry

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

Eric Biggers <ebiggers@google.com>
    blk-crypto: fix check for too-large dun_bytes

Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nokia.com>
    spi: davinci: invoke chipselect callback

Borislav Petkov <bp@alien8.de>
    x86/mce: Defer processing of early errors

Stefan Berger <stefanb@linux.ibm.com>
    tpm: ibmvtpm: Avoid error message when process gets signal while waiting

Stefan Berger <stefanb@linux.ibm.com>
    certs: Trigger creation of RSA module signing key if it's not an RSA key

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - use proper type for vf_mask

Chen-Yu Tsai <wenst@chromium.org>
    irqchip/gic-v3: Fix priority comparison when non-secure priorities are used

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    spi: coldfire-qspi: Use clk_disable_unprepare in the remove function

Pavel Skripkin <paskripkin@gmail.com>
    block: nbd: add sanity check for first_minor

Phong Hoang <phong.hoang.wz@renesas.com>
    clocksource/drivers/sh_cmt: Fix wrong setting if don't request IRQ for clock source channel

Hongbo Li <herberthbli@tencent.com>
    lib/mpi: use kcalloc in mpi_resize

Huacai Chen <chenhuacai@loongson.cn>
    irqchip/loongson-pch-pic: Improve edge triggered interrupt support

Zhen Lei <thunder.leizhen@huawei.com>
    genirq/timings: Fix error return code in irq_timings_test_irqs()

Tony Lindgren <tony@atomide.com>
    spi: spi-pic32: Fix issue with uninitialized dma_slave_config

Tony Lindgren <tony@atomide.com>
    spi: spi-fsl-dspi: Fix issue with uninitialized dma_slave_config

Ming Lei <ming.lei@redhat.com>
    block: return ELEVATOR_DISCARD_MERGE if possible

Geert Uytterhoeven <geert@linux-m68k.org>
    m68k: Fix invalid RMW_INSNS on CPUs that lack CAS

Yanfei Xu <yanfei.xu@windriver.com>
    rcu: Fix stall-warning deadlock due to non-release of rcu_node ->lock

Paul E. McKenney <paulmck@kernel.org>
    rcu: Add lockdep_assert_irqs_disabled() to rcu_sched_clock_irq() and callees

Yanfei Xu <yanfei.xu@windriver.com>
    rcu: Fix to include first blocked task in stall warning

Quentin Perret <qperret@google.com>
    sched: Fix UCLAMP_FLAG_IDLE setting

Mika Penttilä <mika.penttila@gmail.com>
    sched/numa: Fix is_core_idle()

Pavel Skripkin <paskripkin@gmail.com>
    m68k: emu: Fix invalid free in nfeth_cleanup()

Peter Robinson <pbrobinson@gmail.com>
    power: supply: cw2015: use dev_err_probe to allow deferred probe

Harald Freudenberger <freude@linux.ibm.com>
    s390/ap: fix state machine hang after failure to enable irq

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/debug: fix debug area life cycle

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/debug: keep debug data on resize

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: fix misleading rc in clp_set_pci_fn()

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

Ben Hutchings <ben.hutchings@mind.be>
    crypto: omap - Fix inconsistent locking of device lists

Damien Le Moal <damien.lemoal@wdc.com>
    libata: fix ata_host_start()

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: fix wrong offset index for APKA master key valid state

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: add dev_busid sysfs entry for each subchannel

Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
    power: supply: max17042_battery: fix typo in MAx17042_TOFF

Dmitry Osipenko <digetx@gmail.com>
    power: supply: smb347-charger: Add missing pin control activation

Amit Engel <amit.engel@dell.com>
    nvmet: pass back cntlid on successful completion

Ruozhu Li <liruozhu@huawei.com>
    nvme-rdma: don't update queue count when failing to set io queues

Ruozhu Li <liruozhu@huawei.com>
    nvme-tcp: don't update queue count when failing to set io queues

Chunguang Xu <brookxu@tencent.com>
    blk-throtl: optimize IOPS throttle for large IO scenarios

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

Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
    EDAC/mce_amd: Do not load edac_mce_amd module on guests

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

Dmitry Osipenko <digetx@gmail.com>
    regulator: tps65910: Silence deferred probe error

Jeongtae Park <jeongtae.park@gmail.com>
    regmap: fix the offset of register error log

Peter Zijlstra <peterz@infradead.org>
    locking/mutex: Fix HANDOFF condition


-------------

Diffstat:

 Documentation/fault-injection/provoke-crashes.rst  |   2 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi           |   4 +-
 arch/arm/boot/dts/at91-sam9x60ek.dts               |  16 +-
 arch/arm/boot/dts/at91-sama5d3_xplained.dts        |  29 ++++
 arch/arm/boot/dts/at91-sama5d4_xplained.dts        |  19 +++
 arch/arm/boot/dts/meson8.dtsi                      |   5 +
 arch/arm/boot/dts/meson8b-ec100.dts                |   4 +-
 arch/arm/boot/dts/meson8b-mxq.dts                  |   4 +-
 arch/arm/boot/dts/meson8b-odroidc1.dts             |   4 +-
 arch/arm64/boot/dts/exynos/exynos7.dtsi            |   2 +-
 .../boot/dts/marvell/armada-3720-turris-mox.dts    |  17 ++
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi       |  11 +-
 .../arm64/boot/dts/renesas/beacon-renesom-som.dtsi |   3 +-
 arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi    |   3 +-
 arch/arm64/boot/dts/renesas/r8a774a1.dtsi          |   2 +
 arch/arm64/boot/dts/renesas/r8a774b1.dtsi          |   2 +
 arch/arm64/boot/dts/renesas/r8a774c0.dtsi          |   1 +
 arch/arm64/boot/dts/renesas/r8a774e1.dtsi          |   2 +
 arch/arm64/boot/dts/renesas/r8a77995-draak.dts     |   4 -
 arch/m68k/Kconfig.cpu                              |   8 +-
 arch/m68k/emu/nfeth.c                              |   4 +-
 arch/s390/include/asm/kvm_host.h                   |   1 +
 arch/s390/kernel/debug.c                           | 176 +++++++++++++--------
 arch/s390/kvm/interrupt.c                          |  12 +-
 arch/s390/kvm/kvm-s390.c                           |   2 +-
 arch/s390/kvm/kvm-s390.h                           |   2 +-
 arch/s390/mm/kasan_init.c                          |  41 +++--
 arch/s390/pci/pci.c                                |   7 +-
 arch/s390/pci/pci_clp.c                            |  33 ++--
 arch/x86/events/amd/ibs.c                          |   1 +
 arch/x86/include/asm/mce.h                         |   1 +
 arch/x86/kernel/cpu/mce/core.c                     |  11 +-
 arch/x86/kernel/cpu/resctrl/monitor.c              |   6 +
 arch/x86/kvm/mmu/mmu.c                             |   6 -
 arch/x86/kvm/vmx/nested.c                          |   7 +-
 arch/x86/kvm/vmx/vmx.c                             |   3 +
 arch/x86/kvm/x86.c                                 |   4 +
 block/bfq-iosched.c                                |   3 +
 block/bio.c                                        |  15 +-
 block/blk-crypto.c                                 |   2 +-
 block/blk-merge.c                                  |  18 +--
 block/blk-throttle.c                               |  32 ++++
 block/blk.h                                        |   2 +
 block/elevator.c                                   |   3 +
 block/mq-deadline.c                                |   2 +
 certs/Makefile                                     |   8 +
 drivers/ata/libata-core.c                          |   2 +-
 drivers/base/dd.c                                  |  16 +-
 drivers/base/firmware_loader/main.c                |  20 +--
 drivers/base/regmap/regmap.c                       |   2 +-
 drivers/bcma/main.c                                |   6 +-
 drivers/block/nbd.c                                |  10 ++
 drivers/char/tpm/tpm_ibmvtpm.c                     |  26 +--
 drivers/char/tpm/tpm_ibmvtpm.h                     |   2 +-
 drivers/clk/mvebu/kirkwood.c                       |   1 +
 drivers/clocksource/sh_cmt.c                       |  30 ++--
 drivers/counter/104-quad-8.c                       |   5 +-
 drivers/crypto/mxs-dcp.c                           |  45 ++++--
 drivers/crypto/omap-aes.c                          |   8 +-
 drivers/crypto/omap-des.c                          |   8 +-
 drivers/crypto/omap-sham.c                         |  14 +-
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
 drivers/edac/mce_amd.c                             |   3 +
 drivers/firmware/raspberrypi.c                     |  46 +++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c            |  54 +++----
 drivers/gpu/drm/drm_of.c                           |   6 +-
 drivers/gpu/drm/gma500/oaktrail_lvds.c             |   2 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c         |  10 +-
 drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c           |  68 ++++----
 drivers/gpu/drm/msm/dsi/dsi.c                      |   6 +-
 drivers/gpu/drm/mxsfb/mxsfb_drv.c                  |   3 +
 drivers/gpu/drm/mxsfb/mxsfb_drv.h                  |   1 +
 drivers/gpu/drm/mxsfb/mxsfb_kms.c                  |  40 +++++
 drivers/gpu/drm/mxsfb/mxsfb_regs.h                 |   9 ++
 drivers/gpu/drm/panfrost/panfrost_device.c         |   3 +-
 drivers/i2c/busses/i2c-highlander.c                |   2 +-
 drivers/i2c/busses/i2c-hix5hd2.c                   |   4 +-
 drivers/i2c/busses/i2c-iop3xx.c                    |   6 +-
 drivers/i2c/busses/i2c-mt65xx.c                    |   2 +-
 drivers/i2c/busses/i2c-s3c2410.c                   |   2 +-
 drivers/i2c/busses/i2c-synquacer.c                 |   2 +-
 drivers/i2c/busses/i2c-xlp9xx.c                    |   2 +-
 drivers/irqchip/irq-gic-v3.c                       |  23 ++-
 drivers/irqchip/irq-loongson-pch-pic.c             |  19 ++-
 drivers/leds/leds-is31fl32xx.c                     |   1 +
 drivers/leds/leds-lt3593.c                         |   5 +-
 drivers/leds/trigger/ledtrig-audio.c               |  37 ++++-
 drivers/md/bcache/super.c                          |  16 +-
 drivers/media/i2c/tda1997x.c                       |   1 +
 drivers/media/platform/coda/coda-bit.c             |  18 ++-
 drivers/media/platform/qcom/venus/venc.c           |   2 +
 drivers/media/platform/rockchip/rga/rga-buf.c      |   3 +-
 drivers/media/platform/rockchip/rga/rga.c          |  29 +++-
 drivers/media/spi/cxd2880-spi.c                    |   7 +-
 drivers/media/usb/dvb-usb/dvb-usb-i2c.c            |   9 +-
 drivers/media/usb/dvb-usb/dvb-usb-init.c           |   2 +-
 drivers/media/usb/dvb-usb/nova-t-usb2.c            |   6 +-
 drivers/media/usb/dvb-usb/vp702x.c                 |  12 +-
 drivers/media/usb/em28xx/em28xx-input.c            |   1 -
 drivers/media/usb/go7007/go7007-driver.c           |  26 ---
 drivers/media/usb/go7007/go7007-usb.c              |   2 +-
 drivers/misc/lkdtm/core.c                          |   2 +-
 drivers/mmc/host/dw_mmc.c                          |   1 +
 drivers/mmc/host/moxart-mmc.c                      |   1 +
 drivers/mmc/host/sdhci.c                           |   1 +
 .../net/ethernet/aquantia/atlantic/aq_pci_func.c   |   3 +
 drivers/net/ethernet/google/gve/gve_adminq.c       |   6 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  23 ++-
 drivers/net/ethernet/intel/ice/ice_main.c          |  13 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  16 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |  52 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |   6 -
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  15 ++
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   5 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |  18 +--
 .../net/ethernet/pensando/ionic/ionic_devlink.c    |  14 +-
 drivers/net/ethernet/qualcomm/qca_spi.c            |   2 +-
 drivers/net/ethernet/qualcomm/qca_uart.c           |   2 +-
 drivers/net/wireless/ath/ath6kl/wmi.c              |   4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |  32 ++--
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h       |  10 +-
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |   2 +-
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h    |   8 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |  12 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |  10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  13 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |  24 +--
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   1 +
 drivers/net/wireless/rsi/rsi_91x_hal.c             |   4 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c             |   1 +
 drivers/nvme/host/rdma.c                           |   4 +-
 drivers/nvme/host/tcp.c                            |   4 +-
 drivers/nvme/target/fabrics-cmd.c                  |   9 +-
 drivers/pci/pci.c                                  |  25 ++-
 drivers/power/supply/axp288_fuel_gauge.c           |   4 +-
 drivers/power/supply/cw2015_battery.c              |   4 +-
 drivers/power/supply/max17042_battery.c            |   2 +-
 drivers/power/supply/smb347-charger.c              |  10 ++
 drivers/regulator/tps65910-regulator.c             |  10 +-
 drivers/regulator/vctrl-regulator.c                |  73 +++++----
 drivers/s390/cio/css.c                             |  17 ++
 drivers/s390/crypto/ap_bus.c                       |  25 +--
 drivers/s390/crypto/ap_bus.h                       |  10 +-
 drivers/s390/crypto/ap_queue.c                     |  20 +--
 drivers/s390/crypto/zcrypt_ccamisc.c               |   8 +-
 drivers/soc/qcom/rpmhpd.c                          |   5 +-
 drivers/soc/qcom/smsm.c                            |  11 +-
 drivers/soc/rockchip/Kconfig                       |   4 +-
 drivers/spi/spi-coldfire-qspi.c                    |   2 +-
 drivers/spi/spi-davinci.c                          |   8 +-
 drivers/spi/spi-fsl-dspi.c                         |   1 +
 drivers/spi/spi-pic32.c                            |   1 +
 drivers/spi/spi-sprd-adi.c                         |   2 +-
 drivers/spi/spi-zynq-qspi.c                        |   8 +-
 drivers/staging/clocking-wizard/Kconfig            |   2 +-
 .../staging/media/atomisp/i2c/atomisp-mt9m114.c    |  11 +-
 drivers/tty/serial/fsl_lpuart.c                    |   2 +-
 drivers/tty/tty_io.c                               |   4 +-
 drivers/usb/dwc3/dwc3-meson-g12a.c                 |   2 +
 drivers/usb/dwc3/dwc3-qcom.c                       |   4 +
 drivers/usb/gadget/udc/at91_udc.c                  |   4 +-
 drivers/usb/gadget/udc/bdc/bdc_core.c              |  30 ++--
 drivers/usb/gadget/udc/mv_u3d_core.c               |  19 +--
 drivers/usb/gadget/udc/renesas_usb3.c              |  17 +-
 drivers/usb/gadget/udc/s3c2410_udc.c               |   4 +
 drivers/usb/host/ehci-orion.c                      |   8 +-
 drivers/usb/host/ohci-tmio.c                       |   3 +
 drivers/usb/phy/phy-fsl-usb.c                      |   2 +
 drivers/usb/phy/phy-tahvo.c                        |   4 +-
 drivers/usb/phy/phy-twl6030-usb.c                  |   5 +
 drivers/video/backlight/pwm_bl.c                   |  54 ++++---
 drivers/video/fbdev/core/fbmem.c                   |   6 +
 fs/cifs/cifs_unicode.c                             |   9 +-
 fs/debugfs/file.c                                  |   8 +-
 fs/f2fs/file.c                                     |   5 +-
 fs/f2fs/super.c                                    |  11 +-
 fs/fcntl.c                                         |   5 +-
 fs/fuse/file.c                                     |   9 +-
 fs/gfs2/ops_fstype.c                               |  43 +++++
 fs/gfs2/super.c                                    |  61 +------
 fs/io_uring.c                                      |   1 +
 fs/iomap/swapfile.c                                |   6 +
 fs/isofs/inode.c                                   |  27 ++--
 fs/isofs/isofs.h                                   |   1 -
 fs/isofs/joliet.c                                  |   4 +-
 fs/lockd/svclock.c                                 |   2 +-
 fs/nfsd/nfs4state.c                                |   4 +-
 fs/udf/misc.c                                      |  13 +-
 fs/udf/super.c                                     |  75 ++++-----
 fs/udf/udf_sb.h                                    |   2 -
 fs/udf/unicode.c                                   |   4 +-
 include/linux/blkdev.h                             |  16 ++
 include/linux/energy_model.h                       |  16 ++
 include/linux/hrtimer.h                            |   5 -
 include/linux/local_lock_internal.h                |  39 +++--
 include/linux/lockdep.h                            |  15 +-
 include/linux/lockdep_types.h                      |  18 ++-
 include/linux/mlx5/mlx5_ifc.h                      |   3 +-
 include/linux/power/max17042_battery.h             |   2 +-
 include/linux/time64.h                             |   9 +-
 include/soc/bcm2835/raspberrypi-firmware.h         |   2 +
 include/uapi/linux/bpf.h                           |   2 +-
 kernel/bpf/verifier.c                              |  31 ++--
 kernel/cgroup/cpuset.c                             |  95 ++++++-----
 kernel/cpu_pm.c                                    |  50 ++++--
 kernel/irq/timings.c                               |   2 +
 kernel/locking/lockdep.c                           |  16 +-
 kernel/locking/mutex.c                             |  15 +-
 kernel/power/energy_model.c                        |   4 +-
 kernel/rcu/tree.c                                  |   4 +
 kernel/rcu/tree_plugin.h                           |   1 +
 kernel/rcu/tree_stall.h                            |  34 +++-
 kernel/sched/core.c                                |  25 ++-
 kernel/sched/deadline.c                            |   8 +-
 kernel/sched/fair.c                                |   2 +-
 kernel/sched/sched.h                               |   2 +
 kernel/time/hrtimer.c                              |  92 ++++++++---
 kernel/time/posix-cpu-timers.c                     |   2 -
 kernel/time/tick-internal.h                        |   3 +
 lib/mpi/mpiutil.c                                  |   2 +-
 net/6lowpan/debugfs.c                              |   3 +-
 net/bluetooth/cmtp/cmtp.h                          |   2 +-
 net/bluetooth/hci_core.c                           |  14 ++
 net/bluetooth/mgmt.c                               |   2 +-
 net/bluetooth/sco.c                                |  11 +-
 net/core/devlink.c                                 |  36 +++--
 net/ipv4/route.c                                   |  48 ++++--
 net/ipv4/tcp_ipv4.c                                |   5 +-
 net/ipv6/route.c                                   |   5 +-
 net/mac80211/tx.c                                  |   4 +-
 net/netlabel/netlabel_cipso_v4.c                   |   8 +-
 net/sched/sch_cbq.c                                |   2 +-
 samples/bpf/xdp_redirect_cpu_user.c                |   2 +-
 samples/pktgen/pktgen_sample04_many_flows.sh       |  12 +-
 samples/pktgen/pktgen_sample05_flow_per_thread.sh  |  12 +-
 security/integrity/ima/Kconfig                     |   1 -
 security/integrity/ima/ima_mok.c                   |   2 +-
 sound/soc/codecs/rt5682-i2c.c                      |  20 +++
 sound/soc/codecs/wcd9335.c                         |  23 ++-
 sound/soc/intel/boards/kbl_da7219_max98927.c       |  55 +------
 sound/soc/intel/common/soc-acpi-intel-cml-match.c  |   2 +-
 sound/soc/intel/common/soc-acpi-intel-kbl-match.c  |   2 +-
 sound/soc/intel/skylake/skl-topology.c             |  25 ++-
 sound/soc/mediatek/mt8183/mt8183-afe-pcm.c         |  43 +++--
 tools/include/uapi/linux/bpf.h                     |   2 +-
 tools/lib/bpf/Makefile                             |  10 +-
 tools/lib/bpf/libbpf.c                             |  16 +-
 tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c  |   2 +-
 .../selftests/bpf/progs/test_core_autosize.c       |  20 ++-
 264 files changed, 2074 insertions(+), 1184 deletions(-)


