Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7E940938A
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344544AbhIMOVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:21:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345748AbhIMOUF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:20:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00A2560EC0;
        Mon, 13 Sep 2021 13:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540782;
        bh=fwSSXNtD3dpJX+z9+pJzOUZu4eUx5reIgfYHbwXxaFY=;
        h=From:To:Cc:Subject:Date:From;
        b=Dp0RfGWm5ocP3H9zukrv6sMAG3uGCyx9uj9KTYX1oNX30RJzN1bNKy/MjLyqV9Hme
         ER18alv8rkJQKM0LkAe7trgXRL727HFIc0VxPBOWobpq1375CKLjWqmnXnpFiAl7Wc
         YQi5TCGVx2sMQrfkrw+0v7EMdMSyDOjYY6n4us1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.14 000/334] 5.14.4-rc1 review
Date:   Mon, 13 Sep 2021 15:10:54 +0200
Message-Id: <20210913131113.390368911@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.4-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.14.4-rc1
X-KernelTest-Deadline: 2021-09-15T13:11+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.14.4 release.
There are 334 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 15 Sep 2021 13:10:21 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.4-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.14.4-rc1

Linus Walleij <linus.walleij@linaro.org>
    clk: kirkwood: Fix a clocking boot regression

Helge Deller <deller@gmx.de>
    parisc: Fix unaligned-access crash in bootloader

Daniel Thompson <daniel.thompson@linaro.org>
    backlight: pwm_bl: Improve bootloader/kernel device handover

Julio Faracco <jcfaracco@gmail.com>
    bootconfig: Fix missing return check of xbc_node_compose_key function

Niklas Schnelle <schnelle@linux.ibm.com>
    RDMA/mlx5: Fix number of allocated XLT entries

Aubrey Li <aubrey.li@intel.com>
    ACPI: PRM: Find PRMT table before parsing it

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    fbmem: don't allow too huge resolutions

THOBY Simon <Simon.THOBY@viveris.fr>
    IMA: remove the dependency on CRYPTO_MD5

Austin Kim <austin.kim@lge.com>
    IMA: remove -Wmissing-prototypes warning

Miklos Szeredi <mszeredi@redhat.com>
    fuse: wait for writepages in syncfs

Miklos Szeredi <mszeredi@redhat.com>
    fuse: flush extending writes

Miklos Szeredi <mszeredi@redhat.com>
    fuse: truncate pagecache on atomic_o_trunc

Adrian Ratiu <adrian.ratiu@collabora.com>
    char: tpm: Kconfig: remove bad i2c cr50 select

Xiao Ni <xni@redhat.com>
    md/raid10: Remove unnecessary rcu_dereference in raid10_handle_discard

Jens Axboe <axboe@kernel.dk>
    io-wq: check max_worker limits if a worker transitions bound state

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: dts: at91: add pinctrl-{names, 0} for all gpios

Marc Zyngier <maz@kernel.org>
    KVM: arm64: vgic: Resample HW pending state on deactivation

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Unregister HYP sections from kmemleak in protected mode

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Unconditionally clear nested.pi_pending on nested VM-Enter

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: VMX: avoid running vmx_handle_exit_irqoff in case of emulation

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Avoid collision with !PRESENT SPTEs in TDP MMU lpage stats

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: clamp host mapping level to max_level in kvm_mmu_max_mapping_level

Zelin Deng <zelin.deng@linux.alibaba.com>
    KVM: x86: Update vCPU's hv_clock before back to guest when tsc_offset is adjusted

Halil Pasic <pasic@linux.ibm.com>
    KVM: s390: index kvm->arch.idle_mask by vcpu_idx

Sean Christopherson <seanjc@google.com>
    Revert "KVM: x86: mmu: Add guest physical address check in translate_gpa()"

Alexander Antonov <alexander.antonov@linux.intel.com>
    perf/x86/intel/uncore: Fix IIO cleanup mapping procedure for SNR/ICX

Nguyen Dinh Phi <phind.uet@gmail.com>
    tty: Fix data race between tiocsti() and flush_to_ldisc()

Steve French <stfrench@microsoft.com>
    smb3: fix posix extensions mount option

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: Do not leak EDEADLK to dgetents64 for STATUS_USER_SESSION_DELETED

Guoqing Jiang <jiangguoqing@kylinos.cn>
    raid1: ensure write behind bio has less than BIO_MAX_VECS sectors

Pavel Begunkov <asml.silence@gmail.com>
    bio: fix page leak bio_add_hw_page failure

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fail links of cancelled timeouts

Jens Axboe <axboe@kernel.dk>
    io_uring: io_uring_complete() trace should take an integer

Jens Axboe <axboe@kernel.dk>
    io_uring: IORING_OP_WRITE needs hash_reg_file set

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: limit fixed table size by RLIMIT_NOFILE

Lars Poeschel <poeschel@lemonage.de>
    auxdisplay: hd44780: Fix oops on module unloading

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
    octeontx2-af: Fix mailbox errors in nix_rss_flowkey_cfg

Subbaraya Sundeep <sbhatta@marvell.com>
    octeontx2-af: Fix loop in free and unmap counter

Stefan Wahren <stefan.wahren@i2se.com>
    net: qualcomm: fix QCA7000 checksum handling

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    net: sched: Fix qdisc_rate_table refcount leak when get tcf_block failed

Maxim Mikityanskiy <maximmi@nvidia.com>
    sch_htb: Fix inconsistency when leaf qdisc creation fails

Dan Carpenter <dan.carpenter@oracle.com>
    net: qrtr: make checks in qrtr_endpoint_post() stricter

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

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add lowlatency module option

Dan Carpenter <dan.carpenter@oracle.com>
    ath6kl: wmi: fix an error code in ath6kl_wmi_sync_point()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: phy: marvell10g: fix broken PHY interrupts for anyone after us in the driver probe list

Brett Creeley <brett.creeley@intel.com>
    ice: Only lock to update netdev dev_addr

Jacob Keller <jacob.e.keller@intel.com>
    ice: restart periodic outputs around time changes

Jacob Keller <jacob.e.keller@intel.com>
    ice: add lock around Tx timestamp tracker flush

Jacob Keller <jacob.e.keller@intel.com>
    ice: fix Tx queue iteration for Tx timestamp enablement

Mihai Carabas <mihai.carabas@oracle.com>
    misc/pvpanic: fix set driver data

Dmytro Linkin <dlinkin@nvidia.com>
    net/mlx5e: Use correct eswitch for stack devices with lag

Maor Dickman <maord@nvidia.com>
    net/mlx5: E-Switch, Set vhca id valid flag when creating indir fwd group

Roi Dayan <roid@nvidia.com>
    net/mlx5e: Fix possible use-after-free deleting fdb rule

Leon Romanovsky <leon@kernel.org>
    net/mlx5: Remove all auxiliary devices at the unregister event

Dima Chumak <dchumak@nvidia.com>
    net/mlx5: Lag, fix multipath lag activation

Abhishek Naik <abhishek.naik@intel.com>
    iwlwifi: skip first element in the WTAS ACPI table

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

Yang Yingliang <yangyingliang@huawei.com>
    octeontx2-pf: cn10k: Fix error return code in otx2_set_flowkey_cfg()

Sergey Shtylyov <s.shtylyov@omp.ru>
    i2c: xlp9xx: fix main IRQ check

Sergey Shtylyov <s.shtylyov@omp.ru>
    i2c: mt65xx: fix IRQ check

Len Baker <len.baker@gmx.com>
    CIFS: Fix a potencially linear read overflow

Vitaly Kuznetsov <vkuznets@redhat.com>
    hv_utils: Set the maximum packet size for VSS driver to the length of the receive buffer

Andrey Ignatov <rdna@fb.com>
    bpf: Fix possible out of bound write in narrow load handling

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: wm_adsp: Put debugfs_remove_recursive back in

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
    m68k: coldfire: return success for clk_enable(NULL)

Geetha sowjanya <gakula@marvell.com>
    octeontx2-af: cn10k: Use FLIT0 register instead of FLIT1

Sunil Goutham <sgoutham@marvell.com>
    octeontx2-pf: Fix algorithm index in MCAM rules with RSS action

Sunil Goutham <sgoutham@marvell.com>
    octeontx2-pf: Don't install VLAN offload rule if netdev is down

Geetha sowjanya <gakula@marvell.com>
    octeontx2-af: Check capability flag while freeing ipolicer memory

Naveen Mamindlapalli <naveenm@marvell.com>
    octeontx2-pf: send correct vlan priority mask to npc_install_flow_req

Subbaraya Sundeep <sbhatta@marvell.com>
    octeontx2-af: cn10k: Fix SDP base channel number

Dan Carpenter <dan.carpenter@oracle.com>
    rsi: fix an error code in rsi_probe()

Dan Carpenter <dan.carpenter@oracle.com>
    rsi: fix error code in rsi_load_9116_firmware()

Wei Yongjun <weiyongjun1@huawei.com>
    drm/exynos: g2d: fix missing unlock on error in g2d_runqueue_worker()

Bob Peterson <rpeterso@redhat.com>
    gfs2: init system threads before freeze lock

Sergey Shtylyov <s.shtylyov@omp.ru>
    i2c: hix5hd2: fix IRQ check

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

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_rpmsg: Check -EPROBE_DEFER for getting clocks

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    hwmon: remove amd_energy driver in Makefile

Chris Packham <chris.packham@alliedtelesis.co.nz>
    hwmon: (pmbus/bpa-rs600) Don't use rated limits as warn limits

Sergey Shtylyov <s.shtylyov@omp.ru>
    i2c: synquacer: fix deferred probing

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    clk: staging: correct reference to config IOMEM to config HAS_IOMEM

Pali Rohár <pali@kernel.org>
    arm64: dts: marvell: armada-37xx: Extend PCIe MEM space

J. Bruce Fields <bfields@redhat.com>
    nfsd4: Fix forced-expiry locking

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix a NULL pointer deref in trace_svc_stats_latency()

Benjamin Coddington <bcodding@redhat.com>
    lockd: Fix invalid lockowner cast after vfs_test_lock

Thomas Gleixner <tglx@linutronix.de>
    locking/local_lock: Add missing owner initialization

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

Voon Weifeng <weifeng.voon@intel.com>
    net: stmmac: fix INTR TBU status affecting irq count statistic

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
    usb: misc: brcmstb-usb-pinmap: add IRQ check

Dan Carpenter <dan.carpenter@oracle.com>
    mac80211: remove unnecessary NULL check in ieee80211_register_hw()

Sergey Shtylyov <s.shtylyov@omp.ru>
    usb: gadget: udc: s3c2410: add IRQ check

Sergey Shtylyov <s.shtylyov@omp.ru>
    usb: gadget: udc: at91: add IRQ check

Sergey Shtylyov <s.shtylyov@omp.ru>
    usb: dwc3: qcom: add IRQ check

Sergey Shtylyov <s.shtylyov@omp.ru>
    usb: dwc3: meson-g12a: add IRQ check

Rob Clark <robdclark@chromium.org>
    drm/bridge: ti-sn65dsi86: Avoid creating multiple connectors

Douglas Anderson <dianders@chromium.org>
    ASoC: rt5682: Properly turn off regulators if wrong device ID

Parav Pandit <parav@nvidia.com>
    net/mlx5: Fix unpublish devlink parameters

Kuogee Hsieh <khsieh@codeaurora.org>
    drm/msm/dp: replug event is converted into an unplug followed by an plug events

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

Kuogee Hsieh <khsieh@codeaurora.org>
    drm/msm/dp: update is_connected status base on sink count at dp_pm_resume()

David Heidelberg <david@ixit.cz>
    drm/msm/mdp4: move HW revision detection to earlier phase

David Heidelberg <david@ixit.cz>
    drm/msm/mdp4: refactor HW revision detection into read_mdp_hw_revision

Wei Li <liwei391@huawei.com>
    drm/msm: Fix error return code in msm_drm_init()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    leds: lgm-sso: Propagate error codes from callee to caller

Jose Blanquicet <josebl@microsoft.com>
    selftests/bpf: Fix bpf-iter-tcp4 test to print correctly the dest IP

Lukasz Luba <lukasz.luba@arm.com>
    PM: EM: Increase energy calculation precision

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: don't disable multicast flooding to the CPU even without an IGMP querier

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: mt7530: remove the .port_set_mrouter implementation

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: stop syncing the bridge mcast_router attribute at join time

Vignesh Raghavendra <vigneshr@ti.com>
    net: ti: am65-cpsw-nuss: fix RX IRQ state after .ndo_stop()

Robert Foss <robert.foss@linaro.org>
    drm: bridge: it66121: Check drm_bridge_attach retval

Alex Elder <elder@linaro.org>
    arm64: dts: qcom: sm8350: fix IPA interconnects

Sibi Sankar <sibis@codeaurora.org>
    arm64: dts: qcom: sc7280: Fixup the cpufreq node

Colin Ian King <colin.king@canonical.com>
    Bluetooth: increase BTNAMSIZ to 21 chars to fix potential buffer overflow

Sven Eckelmann <sven@narfation.org>
    debugfs: Return error during {full/open}_proxy_open() on rmmod

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: tag_sja1105: optionally build as module when switch driver is module if PTP is enabled

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: build tag_8021q.c as part of DSA core

Stephan Gerhold <stephan@gerhold.net>
    soc: qcom: smsm: Fix missed interrupts if state changes while masked

Matthew Cover <werekraken@gmail.com>
    bpf, samples: Add missing mprog-disable to xdp_redirect_cpu's optstring

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI: PM: Enable PME if it can be signaled from D3cold

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI: PM: Avoid forcing PCI_D0 for wakeup reasons inconsistently

CK Hu <ck.hu@mediatek.com>
    soc: mmsys: mediatek: add mask to mmsys routes

Mansur Alisha Shaik <mansur@codeaurora.org>
    media: venus: helper: do not set constrained parameters for UBWC

Colin Ian King <colin.king@canonical.com>
    media: venus: venc: Fix potential null pointer dereference on pointer fmt

Zhen Lei <thunder.leizhen@huawei.com>
    media: venus: hfi: fix return value check in sys_get_prop_image_version()

Wei Yongjun <weiyongjun1@huawei.com>
    media: omap3isp: Fix missing unlock in isp_subdev_notifier_complete()

Dongliang Mu <mudongliangabcd@gmail.com>
    media: em28xx-input: fix refcount bug in em28xx_usb_disconnect

Hans de Goede <hdegoede@redhat.com>
    leds: trigger: audio: Add an activate callback to ensure the initial brightness is set

Andy Shevchenko <andy.shevchenko@gmail.com>
    leds: rt8515: Put fwnode in any case during ->probe()

Andy Shevchenko <andy.shevchenko@gmail.com>
    leds: lt3593: Put fwnode in any case during ->probe()

Andy Shevchenko <andy.shevchenko@gmail.com>
    leds: lgm-sso: Don't spam logs when probe is deferred

Andy Shevchenko <andy.shevchenko@gmail.com>
    leds: lgm-sso: Put fwnode in any case during ->probe()

Sergey Shtylyov <s.shtylyov@omp.ru>
    i2c: highlander: add IRQ check

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    net/mlx5: Fix missing return value in mlx5_devlink_eswitch_inline_mode_set()

Douglas Anderson <dianders@chromium.org>
    drm/bridge: ti-sn65dsi86: Add some 100 us delays

Douglas Anderson <dianders@chromium.org>
    drm/bridge: ti-sn65dsi86: Fix power off sequence

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    drm/bridge: ti-sn65dsi86: Wrap panel with panel-bridge

Douglas Anderson <dianders@chromium.org>
    drm/bridge: ti-sn65dsi86: Improve probe errors with dev_err_probe()

Douglas Anderson <dianders@chromium.org>
    drm/bridge: ti-sn65dsi86: Don't read EDID blob over DDC

Leon Romanovsky <leon@kernel.org>
    devlink: Break parameter notification sequence to be before/after unload/load driver

Biju Das <biju.das.jz@bp.renesas.com>
    arm64: dts: renesas: hihope-rzg2-ex: Add EtherAVB internal rx delay

Quentin Monnet <quentin@isovalent.com>
    tools: Free BTF objects at various locations

Quentin Monnet <quentin@isovalent.com>
    libbpf: Return non-null error on failures in libbpf_find_prog_btf_id()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    lib/test_scanf: Handle n_bits == 0 in random tests

Luben Tuikov <luben.tuikov@amd.com>
    drm/amd/pm: Fix a bug in semaphore double-lock

Tedd Ho-Jeong An <tedd.an@intel.com>
    Bluetooth: mgmt: Fix wrong opcode in the response for add_adv cmd

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    drm: rcar-du: Don't put reference to drm_device in rcar_du_remove()

Leon Romanovsky <leon@kernel.org>
    net: ti: am65-cpsw-nuss: fix wrong devlink release order

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

Luben Tuikov <luben.tuikov@amd.com>
    drm/amd/pm: Fix a bug communicating with the SMU (v5)

Kai-Heng Feng <kai.heng.feng@canonical.com>
    drm/amdgpu/acp: Make PM domain really work

Colin Ian King <colin.king@canonical.com>
    6lowpan: iphc: Fix an off-by-one check of array index

Jun Miao <jun.miao@windriver.com>
    Bluetooth: btusb: Fix a unspported condition to set available debug features

Dan Carpenter <dan.carpenter@oracle.com>
    Bluetooth: sco: prevent information leak in sco_conn_defer_accept()

Yizhuo <yzhai003@ucr.edu>
    media: atomisp: fix the uninitialized use and rename "retvalue"

Philipp Zabel <p.zabel@pengutronix.de>
    media: coda: fix frame_mem_ctrl for YUV420 and YVU420 formats

Dan Carpenter <dan.carpenter@oracle.com>
    media: rockchip/rga: fix error handling in probe

Dan Carpenter <dan.carpenter@oracle.com>
    media: v4l2-subdev: fix some NULL vs IS_ERR() checks

Pavel Skripkin <paskripkin@gmail.com>
    media: go7007: remove redundant initialization

Pavel Skripkin <paskripkin@gmail.com>
    media: go7007: fix memory leak in go7007_usb_probe

Oleksij Rempel <linux@rempel-privat.de>
    net: usb: asix: ax88772: add missing stop

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

John Fastabend <john.fastabend@gmail.com>
    bpf, selftests: Fix test_maps now that sockmap supports UDP

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sm8250: fix usb2 qmp phy node

Colin Ian King <colin.king@canonical.com>
    gfs2: Fix memory leak of object lsi on error return path

Martynas Pumputis <m@lambda.lt>
    libbpf: Fix removal of inner map in bpf_object__create_map

Bjorn Andersson <bjorn.andersson@linaro.org>
    soc: qcom: rpmhpd: Use corner in power_off

Judy Hsiao <judyhsiao@chromium.org>
    arm64: dts: qcom: sc7180: Set adau wakeup delay to 80 ms

Stefan Assmann <sassmann@kpanic.de>
    i40e: improve locking of mac_filter_hash

Geert Uytterhoeven <geert@linux-m68k.org>
    arm64: dts: renesas: r8a77995: draak: Remove bogus adv7511w properties

Andrew Jeffery <andrew@aj.id.au>
    ARM: dts: everest: Add phase corrections for eMMC

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

Eugen Hristev <eugen.hristev@microchip.com>
    media: atmel: atmel-sama5d2-isc: fix YUYV format

Marek Vasut <marex@denx.de>
    ASoC: tlv320aic32x4: Fix TAS2505/TAS2521 channel count

Zhang Qilong <zhangqilong3@huawei.com>
    ASoC: mediatek: mt8183: Fix Unbalanced pm_runtime_enable in mt8183_afe_pcm_dev_probe

Zhang Qilong <zhangqilong3@huawei.com>
    ASoC: mediatek: mt8192:Fix Unbalanced pm_runtime_enable in mt8192_afe_pcm_dev_probe

Harshvardhan Jha <harshvardhan.jha@oracle.com>
    drm/gma500: Fix end of loop tests for list_for_each_entry

Wei Yongjun <weiyongjun1@huawei.com>
    drm/panfrost: Fix missing clk_disable_unprepare() on error in panfrost_clk_init()

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

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/i10nm: Fix NVDIMM detection

Stefan Berger <stefanb@linux.ibm.com>
    tpm: ibmvtpm: Avoid error message when process gets signal while waiting

Stefan Berger <stefanb@linux.ibm.com>
    certs: Trigger creation of RSA module signing key if it's not an RSA key

Geert Uytterhoeven <geert@linux-m68k.org>
    m68k: Fix asm register constraints for atomic ops

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - use proper type for vf_mask

Chen-Yu Tsai <wenst@chromium.org>
    irqchip/gic-v3: Fix priority comparison when non-secure priorities are used

Sven Peter <sven@svenpeter.dev>
    irqchip/apple-aic: Fix irq_disable from within irq handlers

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    spi: coldfire-qspi: Use clk_disable_unprepare in the remove function

Pavel Skripkin <paskripkin@gmail.com>
    block: nbd: add sanity check for first_minor

Hou Tao <houtao1@huawei.com>
    nbd: do del_gendisk() asynchronously for NBD_DESTROY_ON_DISCONNECT

Phong Hoang <phong.hoang.wz@renesas.com>
    clocksource/drivers/sh_cmt: Fix wrong setting if don't request IRQ for clock source channel

Hongbo Li <herberthbli@tencent.com>
    lib/mpi: use kcalloc in mpi_resize

Huacai Chen <chenhuacai@kernel.org>
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

Yanfei Xu <yanfei.xu@windriver.com>
    rcu: Fix to include first blocked task in stall warning

Quentin Perret <qperret@google.com>
    sched: Fix UCLAMP_FLAG_IDLE setting

Mika Penttilä <mika.penttila@gmail.com>
    sched/numa: Fix is_core_idle()

Mian Yousaf Kaukab <ykaukab@suse.de>
    crypto: ecc - handle unaligned input buffer in ecc_swap_digits

Ard Biesheuvel <ardb@kernel.org>
    crypto: x86/aes-ni - add missing error checks in XTS code

Pavel Skripkin <paskripkin@gmail.com>
    m68k: emu: Fix invalid free in nfeth_cleanup()

Peter Robinson <pbrobinson@gmail.com>
    power: supply: cw2015: use dev_err_probe to allow deferred probe

Valentin Schneider <valentin.schneider@arm.com>
    sched/debug: Don't update sched_domain debug directories before sched_debug_init()

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/smp: enable DAT before CPU restart callback is called

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

Jens Axboe <axboe@kernel.dk>
    io-wq: remove GFP_ATOMIC allocation off schedule out path

Stian Skjelstad <stian.skjelstad@gmail.com>
    udf_get_extendedattr() had no boundary checks.

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    fcntl: fix potential deadlock for &fasync_struct.fa_lock

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    fcntl: fix potential deadlocks for &fown_struct.lock

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    crypto: tcrypt - Fix missing return value check

Kai Ye <yekai13@huawei.com>
    crypto: hisilicon/sec - modify the hardware endian configuration

Kai Ye <yekai13@huawei.com>
    crypto: hisilicon/sec - fix the abnormal exiting process

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

Valentin Schneider <valentin.schneider@arm.com>
    sched/topology: Skip updating masks for non-online nodes

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

Baokun Li <libaokun1@huawei.com>
    nbd: add the check to prevent overflow in __nbd_ioctl()

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
 arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts       |   2 +-
 arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi           |   4 +-
 arch/arm/boot/dts/at91-sam9x60ek.dts               |  16 +-
 arch/arm/boot/dts/at91-sama5d3_xplained.dts        |  29 +++
 arch/arm/boot/dts/at91-sama5d4_xplained.dts        |  19 ++
 arch/arm/boot/dts/meson8.dtsi                      |   5 +
 arch/arm/boot/dts/meson8b-ec100.dts                |   4 +-
 arch/arm/boot/dts/meson8b-mxq.dts                  |   4 +-
 arch/arm/boot/dts/meson8b-odroidc1.dts             |   4 +-
 arch/arm64/boot/dts/exynos/exynos7.dtsi            |   2 +-
 .../boot/dts/marvell/armada-3720-turris-mox.dts    |  17 ++
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi       |  11 +-
 .../arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi |   2 +-
 arch/arm64/boot/dts/qcom/sc7280.dtsi               |   6 +-
 arch/arm64/boot/dts/qcom/sm8250.dtsi               |   2 +-
 arch/arm64/boot/dts/qcom/sm8350.dtsi               |   8 +-
 arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi    |   1 +
 arch/arm64/boot/dts/renesas/r8a77995-draak.dts     |   4 -
 arch/arm64/kvm/arm.c                               |   7 +
 arch/arm64/kvm/vgic/vgic-v2.c                      |  36 +--
 arch/arm64/kvm/vgic/vgic-v3.c                      |  36 +--
 arch/arm64/kvm/vgic/vgic.c                         |  38 +++
 arch/arm64/kvm/vgic/vgic.h                         |   2 +
 arch/m68k/Kconfig.cpu                              |   8 +-
 arch/m68k/coldfire/clk.c                           |   2 +-
 arch/m68k/emu/nfeth.c                              |   4 +-
 arch/m68k/include/asm/atomic.h                     |   4 +-
 arch/parisc/boot/compressed/misc.c                 |   2 +-
 arch/s390/include/asm/kvm_host.h                   |   1 +
 arch/s390/include/asm/lowcore.h                    |   3 +-
 arch/s390/include/asm/processor.h                  |   2 +
 arch/s390/kernel/asm-offsets.c                     |   1 +
 arch/s390/kernel/debug.c                           | 176 ++++++++-----
 arch/s390/kernel/entry.S                           |  11 +-
 arch/s390/kernel/ipl.c                             |   3 -
 arch/s390/kernel/machine_kexec.c                   |   1 -
 arch/s390/kernel/setup.c                           |   9 +-
 arch/s390/kernel/smp.c                             |  31 ++-
 arch/s390/kvm/interrupt.c                          |  12 +-
 arch/s390/kvm/kvm-s390.c                           |   2 +-
 arch/s390/kvm/kvm-s390.h                           |   2 +-
 arch/s390/mm/kasan_init.c                          |  41 ++-
 arch/s390/pci/pci.c                                |   7 +-
 arch/s390/pci/pci_clp.c                            |  33 ++-
 arch/x86/crypto/aesni-intel_glue.c                 |   5 +
 arch/x86/events/intel/uncore_snbep.c               |  40 ++-
 arch/x86/include/asm/mce.h                         |   1 +
 arch/x86/kernel/cpu/mce/core.c                     |  11 +-
 arch/x86/kvm/mmu/mmu.c                             |  19 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         |  20 +-
 arch/x86/kvm/vmx/nested.c                          |   7 +-
 arch/x86/kvm/vmx/vmx.c                             |   3 +
 arch/x86/kvm/x86.c                                 |   4 +
 block/bfq-iosched.c                                |   3 +
 block/bio.c                                        |  15 +-
 block/blk-crypto.c                                 |   2 +-
 block/blk-merge.c                                  |  18 +-
 block/blk-throttle.c                               |  32 +++
 block/blk.h                                        |   2 +
 block/elevator.c                                   |   3 +
 block/mq-deadline.c                                |   2 +
 certs/Makefile                                     |   8 +
 crypto/ecc.h                                       |   5 +-
 crypto/tcrypt.c                                    |  29 ++-
 drivers/acpi/prmt.c                                |  10 +-
 drivers/ata/libata-core.c                          |   2 +-
 drivers/auxdisplay/hd44780.c                       |   2 +-
 drivers/base/dd.c                                  |  16 +-
 drivers/base/firmware_loader/main.c                |  20 +-
 drivers/base/regmap/regmap.c                       |   2 +-
 drivers/bcma/main.c                                |   6 +-
 drivers/block/nbd.c                                |  86 ++++++-
 drivers/bluetooth/btusb.c                          |  18 +-
 drivers/char/tpm/Kconfig                           |   1 -
 drivers/char/tpm/tpm_ibmvtpm.c                     |  26 +-
 drivers/char/tpm/tpm_ibmvtpm.h                     |   2 +-
 drivers/clk/mvebu/kirkwood.c                       |   1 +
 drivers/clocksource/sh_cmt.c                       |  30 ++-
 drivers/counter/104-quad-8.c                       |   5 +-
 drivers/crypto/hisilicon/sec2/sec.h                |   5 -
 drivers/crypto/hisilicon/sec2/sec_main.c           |  34 +--
 drivers/crypto/mxs-dcp.c                           |  45 +++-
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
 drivers/firmware/raspberrypi.c                     |  10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c            |  54 ++--
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c             | 286 +++++++++++++++++----
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.h             |   3 +-
 drivers/gpu/drm/bridge/ite-it66121.c               |   2 +
 drivers/gpu/drm/bridge/ti-sn65dsi86.c              |  97 ++++---
 drivers/gpu/drm/drm_of.c                           |   6 +-
 drivers/gpu/drm/exynos/exynos_drm_g2d.c            |   3 +-
 drivers/gpu/drm/gma500/oaktrail_lvds.c             |   2 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c         |  10 +-
 drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c           |  68 ++---
 drivers/gpu/drm/msm/dp/dp_display.c                |  31 ++-
 drivers/gpu/drm/msm/dsi/dsi.c                      |   6 +-
 drivers/gpu/drm/msm/msm_drv.c                      |   1 +
 drivers/gpu/drm/mxsfb/mxsfb_drv.c                  |   3 +
 drivers/gpu/drm/mxsfb/mxsfb_drv.h                  |   1 +
 drivers/gpu/drm/mxsfb/mxsfb_kms.c                  |  40 +++
 drivers/gpu/drm/mxsfb/mxsfb_regs.h                 |   9 +
 drivers/gpu/drm/panfrost/panfrost_device.c         |   3 +-
 drivers/gpu/drm/rcar-du/rcar_du_drv.c              |   2 -
 drivers/hv/hv_snapshot.c                           |   1 +
 drivers/hwmon/Makefile                             |   1 -
 drivers/hwmon/pmbus/bpa-rs600.c                    |  25 --
 drivers/i2c/busses/i2c-highlander.c                |   2 +-
 drivers/i2c/busses/i2c-hix5hd2.c                   |   2 +-
 drivers/i2c/busses/i2c-iop3xx.c                    |   6 +-
 drivers/i2c/busses/i2c-mt65xx.c                    |   2 +-
 drivers/i2c/busses/i2c-s3c2410.c                   |   2 +-
 drivers/i2c/busses/i2c-synquacer.c                 |   2 +-
 drivers/i2c/busses/i2c-xlp9xx.c                    |   2 +-
 drivers/infiniband/hw/mlx5/mr.c                    |   2 +-
 drivers/irqchip/irq-apple-aic.c                    |   2 +-
 drivers/irqchip/irq-gic-v3.c                       |  23 +-
 drivers/irqchip/irq-loongson-pch-pic.c             |  19 +-
 drivers/leds/blink/leds-lgm-sso.c                  |  23 +-
 drivers/leds/flash/leds-rt8515.c                   |   4 +-
 drivers/leds/leds-is31fl32xx.c                     |   1 +
 drivers/leds/leds-lt3593.c                         |   5 +-
 drivers/leds/trigger/ledtrig-audio.c               |  37 ++-
 drivers/md/bcache/super.c                          |  16 +-
 drivers/md/raid1.c                                 |  19 ++
 drivers/md/raid10.c                                |  14 +-
 drivers/media/i2c/tda1997x.c                       |   1 +
 drivers/media/platform/atmel/atmel-sama5d2-isc.c   |  17 ++
 drivers/media/platform/coda/coda-bit.c             |  18 +-
 drivers/media/platform/omap3isp/isp.c              |   4 +-
 drivers/media/platform/qcom/venus/helpers.c        |   3 +
 drivers/media/platform/qcom/venus/hfi_msgs.c       |   2 +-
 drivers/media/platform/qcom/venus/venc.c           |   2 +
 drivers/media/platform/rcar-vin/rcar-v4l2.c        |   4 +-
 drivers/media/platform/rockchip/rga/rga.c          |  27 +-
 drivers/media/platform/vsp1/vsp1_entity.c          |   4 +-
 drivers/media/spi/cxd2880-spi.c                    |   7 +-
 drivers/media/usb/dvb-usb/dvb-usb-i2c.c            |   9 +-
 drivers/media/usb/dvb-usb/dvb-usb-init.c           |   2 +-
 drivers/media/usb/dvb-usb/nova-t-usb2.c            |   6 +-
 drivers/media/usb/dvb-usb/vp702x.c                 |  12 +-
 drivers/media/usb/em28xx/em28xx-input.c            |   1 -
 drivers/media/usb/go7007/go7007-driver.c           |  26 --
 drivers/media/usb/go7007/go7007-usb.c              |   2 +-
 drivers/misc/lkdtm/core.c                          |   2 +-
 drivers/misc/pvpanic/pvpanic.c                     |   2 +
 drivers/mmc/host/dw_mmc.c                          |   1 +
 drivers/mmc/host/moxart-mmc.c                      |   1 +
 drivers/mmc/host/sdhci.c                           |   1 +
 drivers/net/dsa/b53/b53_common.c                   |  10 -
 drivers/net/dsa/b53/b53_priv.h                     |   2 -
 drivers/net/dsa/bcm_sf2.c                          |   1 -
 drivers/net/dsa/mt7530.c                           |  13 -
 drivers/net/dsa/mv88e6xxx/chip.c                   |  18 --
 .../net/ethernet/aquantia/atlantic/aq_pci_func.c   |   3 +
 drivers/net/ethernet/google/gve/gve_adminq.c       |   6 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  23 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  13 +-
 drivers/net/ethernet/intel/ice/ice_ptp.c           |  55 +++-
 drivers/net/ethernet/marvell/octeontx2/af/common.h |   2 -
 .../net/ethernet/marvell/octeontx2/af/rvu_cn10k.c  |  35 ++-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   9 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  22 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |   2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  16 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   3 +
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    |   1 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |   6 -
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c   |  15 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.h   |   4 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  18 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  18 ++
 .../ethernet/mellanox/mlx5/core/esw/indir_table.c  |   1 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   5 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |  18 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag.c      |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c   |   8 +
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h   |   2 +
 .../net/ethernet/pensando/ionic/ionic_devlink.c    |  14 +-
 drivers/net/ethernet/qualcomm/qca_spi.c            |   2 +-
 drivers/net/ethernet/qualcomm/qca_uart.c           |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c   |   5 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |  47 ++--
 drivers/net/ethernet/ti/am65-cpsw-nuss.h           |   2 +
 drivers/net/phy/marvell10g.c                       |   8 +
 drivers/net/usb/asix_devices.c                     |   1 +
 drivers/net/wireless/ath/ath6kl/wmi.c              |   4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |  14 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   1 +
 drivers/net/wireless/rsi/rsi_91x_hal.c             |   4 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c             |   1 +
 drivers/nvme/host/rdma.c                           |   4 +-
 drivers/nvme/host/tcp.c                            |   4 +-
 drivers/nvme/target/fabrics-cmd.c                  |   9 +-
 drivers/pci/pci.c                                  |  25 +-
 drivers/power/supply/axp288_fuel_gauge.c           |   4 +-
 drivers/power/supply/cw2015_battery.c              |   4 +-
 drivers/power/supply/max17042_battery.c            |   2 +-
 drivers/power/supply/smb347-charger.c              |  10 +
 drivers/regulator/tps65910-regulator.c             |  10 +-
 drivers/regulator/vctrl-regulator.c                |  73 +++---
 drivers/s390/cio/css.c                             |  17 ++
 drivers/s390/crypto/ap_bus.c                       |  25 +-
 drivers/s390/crypto/ap_bus.h                       |  10 +-
 drivers/s390/crypto/ap_queue.c                     |  20 +-
 drivers/s390/crypto/zcrypt_ccamisc.c               |   8 +-
 drivers/soc/mediatek/mt8183-mmsys.h                |  21 +-
 drivers/soc/mediatek/mtk-mmsys.c                   |   7 +-
 drivers/soc/mediatek/mtk-mmsys.h                   | 133 +++++++---
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
 drivers/staging/media/tegra-video/vi.c             |   4 +-
 drivers/tty/serial/fsl_lpuart.c                    |   2 +-
 drivers/tty/tty_io.c                               |   4 +-
 drivers/usb/dwc3/dwc3-meson-g12a.c                 |   2 +
 drivers/usb/dwc3/dwc3-qcom.c                       |   4 +
 drivers/usb/gadget/udc/at91_udc.c                  |   4 +-
 drivers/usb/gadget/udc/bdc/bdc_core.c              |  30 +--
 drivers/usb/gadget/udc/mv_u3d_core.c               |  19 +-
 drivers/usb/gadget/udc/renesas_usb3.c              |  17 +-
 drivers/usb/gadget/udc/s3c2410_udc.c               |   4 +
 drivers/usb/host/ehci-orion.c                      |   8 +-
 drivers/usb/host/ohci-tmio.c                       |   3 +
 drivers/usb/misc/brcmstb-usb-pinmap.c              |   2 +
 drivers/usb/phy/phy-fsl-usb.c                      |   2 +
 drivers/usb/phy/phy-tahvo.c                        |   4 +-
 drivers/usb/phy/phy-twl6030-usb.c                  |   5 +
 drivers/video/backlight/pwm_bl.c                   |  54 ++--
 drivers/video/fbdev/core/fbmem.c                   |   6 +
 fs/cifs/cifs_unicode.c                             |   9 +-
 fs/cifs/fs_context.c                               |  11 +-
 fs/cifs/readdir.c                                  |  23 +-
 fs/debugfs/file.c                                  |   8 +-
 fs/f2fs/file.c                                     |   5 +-
 fs/f2fs/super.c                                    |  11 +-
 fs/fcntl.c                                         |  18 +-
 fs/fuse/file.c                                     |  30 ++-
 fs/fuse/fuse_i.h                                   |  19 ++
 fs/fuse/inode.c                                    |  60 +++++
 fs/gfs2/ops_fstype.c                               |  43 ++++
 fs/gfs2/super.c                                    |  61 +----
 fs/io-wq.c                                         | 105 +++++---
 fs/io_uring.c                                      |   5 +
 fs/iomap/swapfile.c                                |   6 +
 fs/isofs/inode.c                                   |  27 +-
 fs/isofs/isofs.h                                   |   1 -
 fs/isofs/joliet.c                                  |   4 +-
 fs/lockd/svclock.c                                 |   2 +-
 fs/nfsd/nfs4state.c                                |   4 +-
 fs/udf/misc.c                                      |  13 +-
 fs/udf/super.c                                     |  75 +++---
 fs/udf/udf_sb.h                                    |   2 -
 fs/udf/unicode.c                                   |   4 +-
 include/linux/blkdev.h                             |  16 ++
 include/linux/energy_model.h                       |  16 ++
 include/linux/hrtimer.h                            |   5 -
 include/linux/local_lock_internal.h                |  42 +--
 include/linux/mlx5/mlx5_ifc.h                      |   3 +-
 include/linux/power/max17042_battery.h             |   2 +-
 include/linux/sunrpc/svc.h                         |   1 +
 include/linux/time64.h                             |   9 +-
 include/net/dsa.h                                  |   2 -
 include/net/pkt_cls.h                              |   3 +-
 include/trace/events/io_uring.h                    |   6 +-
 include/trace/events/sunrpc.h                      |   8 +-
 include/uapi/linux/bpf.h                           |   2 +-
 kernel/bpf/verifier.c                              |  31 ++-
 kernel/cgroup/cpuset.c                             |  95 ++++---
 kernel/cpu_pm.c                                    |  50 +++-
 kernel/irq/timings.c                               |   2 +
 kernel/locking/mutex.c                             |  15 +-
 kernel/power/energy_model.c                        |   4 +-
 kernel/rcu/tree_stall.h                            |  26 +-
 kernel/sched/core.c                                |  25 +-
 kernel/sched/deadline.c                            |   8 +-
 kernel/sched/debug.c                               |   7 +
 kernel/sched/fair.c                                |   2 +-
 kernel/sched/sched.h                               |   2 +
 kernel/sched/topology.c                            |  65 +++++
 kernel/time/hrtimer.c                              |  92 +++++--
 kernel/time/posix-cpu-timers.c                     |   2 -
 kernel/time/tick-internal.h                        |   3 +
 lib/mpi/mpiutil.c                                  |   2 +-
 lib/test_scanf.c                                   |   4 +-
 net/6lowpan/debugfs.c                              |   3 +-
 net/bluetooth/cmtp/cmtp.h                          |   2 +-
 net/bluetooth/hci_core.c                           |  22 +-
 net/bluetooth/mgmt.c                               |   2 +-
 net/bluetooth/sco.c                                |  11 +-
 net/core/devlink.c                                 |  36 ++-
 net/dsa/Kconfig                                    |  13 +-
 net/dsa/Makefile                                   |   3 +-
 net/dsa/dsa_priv.h                                 |   2 -
 net/dsa/port.c                                     |  21 --
 net/dsa/slave.c                                    |   6 -
 net/dsa/tag_8021q.c                                |   2 -
 net/ipv4/route.c                                   |  48 ++--
 net/ipv4/tcp_ipv4.c                                |   5 +-
 net/ipv6/route.c                                   |   5 +-
 net/mac80211/main.c                                |   2 +-
 net/mac80211/tx.c                                  |   4 +-
 net/netlabel/netlabel_cipso_v4.c                   |   8 +-
 net/qrtr/qrtr.c                                    |   8 +-
 net/sched/sch_cbq.c                                |   2 +-
 net/sched/sch_htb.c                                |  97 ++++---
 net/sunrpc/svc.c                                   |  15 ++
 samples/bpf/xdp_redirect_cpu_user.c                |   2 +-
 samples/pktgen/pktgen_sample04_many_flows.sh       |  12 +-
 samples/pktgen/pktgen_sample05_flow_per_thread.sh  |  12 +-
 security/integrity/ima/Kconfig                     |   1 -
 security/integrity/ima/ima_mok.c                   |   2 +-
 sound/soc/codecs/rt5682-i2c.c                      |  15 +-
 sound/soc/codecs/tlv320aic32x4.c                   |   2 +-
 sound/soc/codecs/wcd9335.c                         |  23 +-
 sound/soc/codecs/wm_adsp.c                         |   2 +
 sound/soc/fsl/fsl_rpmsg.c                          |  20 +-
 sound/soc/intel/boards/kbl_da7219_max98927.c       |  55 +---
 sound/soc/intel/common/soc-acpi-intel-cml-match.c  |   2 +-
 sound/soc/intel/common/soc-acpi-intel-kbl-match.c  |   2 +-
 sound/soc/intel/skylake/skl-topology.c             |  25 +-
 sound/soc/mediatek/mt8183/mt8183-afe-pcm.c         |  43 ++--
 sound/soc/mediatek/mt8192/mt8192-afe-pcm.c         |  27 +-
 sound/usb/card.c                                   |   4 +
 sound/usb/pcm.c                                    |   3 +-
 sound/usb/usbaudio.h                               |   1 +
 tools/bootconfig/main.c                            |   4 +-
 tools/bpf/bpftool/prog.c                           |   5 +-
 tools/include/uapi/linux/bpf.h                     |   2 +-
 tools/lib/bpf/Makefile                             |  10 +-
 tools/lib/bpf/libbpf.c                             |  20 +-
 tools/perf/util/bpf-event.c                        |   4 +-
 tools/perf/util/bpf_counter.c                      |   3 +-
 tools/testing/selftests/bpf/prog_tests/btf.c       |   1 +
 tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c  |   2 +-
 .../selftests/bpf/progs/test_core_autosize.c       |  20 +-
 tools/testing/selftests/bpf/test_maps.c            |   4 +-
 365 files changed, 3272 insertions(+), 1796 deletions(-)


