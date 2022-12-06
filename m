Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDBBD644989
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 17:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235636AbiLFQlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 11:41:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235637AbiLFQkk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 11:40:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D96AE48;
        Tue,  6 Dec 2022 08:39:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D399B81A6D;
        Tue,  6 Dec 2022 16:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6717BC433C1;
        Tue,  6 Dec 2022 16:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670344790;
        bh=2VrfCUc4r66X5IDmkeojvF+siWDQnFPRp8MtVxuSF8E=;
        h=From:To:Cc:Subject:Date:From;
        b=XwelcQY8WIpDPiSXjVJC1xYf7JZcMFhFT6aO/i98lR2d0DGfaR6bl7J901vY3TLrD
         0tdFNrzmYo4vJhEd6HInha1ST7/REc3QrxHIU4EmqwFkTWAOivnbicoWN/MA7Lj9ZE
         35DZUWULu8lXopQXtOysOyz+K7q28ZY+wbVxXlLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 6.0 000/125] 6.0.12-rc3 review
Date:   Tue,  6 Dec 2022 17:39:48 +0100
Message-Id: <20221206163445.868107856@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.12-rc3.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.0.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.0.12-rc3
X-KernelTest-Deadline: 2022-12-08T16:34+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 6.0.12 release.
There are 125 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 08 Dec 2022 16:34:27 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.12-rc3.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.0.12-rc3

Linus Torvalds <torvalds@linux-foundation.org>
    proc: proc_skip_spaces() shouldn't think it is working on C strings

Linus Torvalds <torvalds@linux-foundation.org>
    proc: avoid integer type confusion in get_proc_long

Jann Horn <jannh@google.com>
    ipc/sem: Fix dangling sem_array access in semtimedop race

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/bpf/32: Fix Oops on tail call tests

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    Input: raydium_ts_i2c - fix memory leak in raydium_i2c_send()

Jan Dabros <jsd@semihalf.com>
    char: tpm: Protect tpm_pm_suspend with locks

Conor Dooley <conor.dooley@microchip.com>
    Revert "clocksource/drivers/riscv: Events are stopped during CPU suspend"

Vishal Verma <vishal.l.verma@intel.com>
    ACPI: HMAT: Fix initiator registration for single-initiator systems

Vishal Verma <vishal.l.verma@intel.com>
    ACPI: HMAT: remove unnecessary variable initialization

Andrew Lunn <andrew@lunn.ch>
    i2c: imx: Only DMA messages with I2C_M_DMA_SAFE flag set

Wang Yufen <wangyufen@huawei.com>
    i2c: qcom-geni: fix error return code in geni_i2c_gpi_xfer

Yuan Can <yuancan@huawei.com>
    i2c: npcm7xx: Fix error handling in npcm_i2c_init()

Ricardo Ribalda <ribalda@chromium.org>
    i2c: Restore initial power state if probe fails

SeongJae Park <sj@kernel.org>
    mm/damon/sysfs: fix wrong empty schemes assumption under online tuning in damon_sysfs_set_schemes()

Yajun Deng <yajun.deng@linux.dev>
    mm/damon: introduce struct damos_access_pattern

Ido Schimmel <idosch@nvidia.com>
    ipv4: Fix route deletion when nexthop info is not specified

David Ahern <dsahern@kernel.org>
    ipv4: Handle attempt to delete multipath route when fib_info contains an nh reference

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    iommu/vt-d: Fix PCI device refcount leak in dmar_dev_scope_init()

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    iommu/vt-d: Fix PCI device refcount leak in has_external_pci()

Caleb Sander <csander@purestorage.com>
    nvme: fix SRCU protection of nvme_ns_head list

Guo Ren <guoren@kernel.org>
    riscv: kexec: Fixup irq controller broken in kexec crash path

Jisheng Zhang <jszhang@kernel.org>
    riscv: fix race when vmap stack overflow

Alexandre Ghiti <alexghiti@rivosinc.com>
    riscv: Sync efi page table's kernel mappings before switching

Maxim Korotkov <korotkov.maxim.s@gmail.com>
    pinctrl: single: Fix potential division by zero

Hui Tang <tanghui20@huawei.com>
    ASoC: tlv320adc3xxx: Fix build error for implicit function declaration

Mark Brown <broonie@kernel.org>
    ASoC: ops: Fix bounds check for _sx controls

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Free buffers when a used dynamic event is removed

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Fix race where histograms can be called before the event

Daniel Bristot de Oliveira <bristot@kernel.org>
    tracing/osnoise: Fix duration type

Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
    drm/i915: Never return 0 if not all requests retired

Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
    drm/i915: Fix negative value passed as remaining time

Leo Liu <leo.liu@amd.com>
    drm/amdgpu: enable Vangogh VCN indirect sram mode

Lee Jones <lee@kernel.org>
    drm/amdgpu: temporarily disable broken Clang builds due to blown stack-frame

Lee Jones <lee@kernel.org>
    Kconfig.debug: provide a little extra FRAME_WARN leeway when KASAN is enabled

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci: Fix voltage switch delay

Wenchao Chen <wenchao.chen@unisoc.com>
    mmc: sdhci-sprd: Fix no reset data and command after voltage switch

Sebastian Falbesoner <sebastian.falbesoner@gmail.com>
    mmc: sdhci-esdhc-imx: correct CQHCI exit halt state check

Christian Löhle <CLoehle@hyperstone.com>
    mmc: core: Fix ambiguous TRIM and DISCARD arg

Gaosheng Cui <cuigaosheng1@huawei.com>
    mmc: mtk-sd: Fix missing clk_disable_unprepare in msdc_of_clock_parse()

Ye Bin <yebin10@huawei.com>
    mmc: mmc_test: Fix removal of debugfs file

Goh, Wei Sheng <wei.sheng.goh@intel.com>
    net: stmmac: Set MAC's flow control register to reflect current settings

Gavin Shan <gshan@redhat.com>
    mm: migrate: fix THP's mapcount on isolation

Linus Torvalds <torvalds@linux-foundation.org>
    v4l2: don't fall back to follow_pfn() if pin_user_pages_fast() fails

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: intel: Save and restore pins in "direct IRQ" mode

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/bugs: Make sure MSR_SPEC_CTRL is updated properly upon resume from S3

ZhangPeng <zhangpeng362@huawei.com>
    nilfs2: fix NULL pointer dereference in nilfs_palloc_commit_free_entry()

Tiezhu Yang <yangtiezhu@loongson.cn>
    tools/vm/slabinfo-gnuplot: use "grep -E" instead of "egrep"

Steven Rostedt (Google) <rostedt@goodmis.org>
    error-injection: Add prompt for function error injection

Ziyang Xuan <william.xuanziyang@huawei.com>
    can: can327: can327_feed_frame_to_netdev(): fix potential skb leak when netdev is down

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: dice: fix regression for Lexicon I-ONIX FW810S

Björn Töpel <bjorn@rivosinc.com>
    riscv: mm: Proper page permissions after initmem free

Jisheng Zhang <jszhang@kernel.org>
    riscv: vdso: fix section overlapping under some conditions

Yuan Can <yuancan@huawei.com>
    hwmon: (asus-ec-sensors) Add checks for devm_kcalloc

Yang Yingliang <yangyingliang@huawei.com>
    hwmon: (coretemp) fix pci device refcount leak in nv1a_ram_new()

Phil Auld <pauld@redhat.com>
    hwmon: (coretemp) Check for null before removing sysfs attrs

Marc Dionne <marc.dionne@auristor.com>
    afs: Fix server->active leak in afs_put_server

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: ethernet: renesas: ravb: Fix promiscuous mode after system resumed

Zhengchao Shao <shaozhengchao@huawei.com>
    sctp: fix memory leak in sctp_stream_outq_migrate()

Willem de Bruijn <willemb@google.com>
    packet: do not set TP_STATUS_CSUM_VALID on CHECKSUM_COMPLETE

Chris Mi <cmi@nvidia.com>
    net/mlx5: Lag, Fix for loop when checking lag

Shigeru Yoshida <syoshida@redhat.com>
    net: tun: Fix use-after-free in tun_detach()

David Howells <dhowells@redhat.com>
    afs: Fix fileserver probe RTT handling

Yang Yingliang <yangyingliang@huawei.com>
    net: mdiobus: fix unbalanced node reference count

YueHaibing <yuehaibing@huawei.com>
    net: hsr: Fix potential use-after-free

Xin Long <lucien.xin@gmail.com>
    tipc: re-fetch skb cb after tipc_msg_validate

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix sleep in atomic at close time

Menglong Dong <imagedong@tencent.com>
    mptcp: don't orphan ssk in mptcp_close()

Jerry Ray <jerry.ray@microchip.com>
    dsa: lan9303: Correct stat name

M Chetan Kumar <m.chetan.kumar@linux.intel.com>
    net: wwan: iosm: fix incorrect skb length

M Chetan Kumar <m.chetan.kumar@linux.intel.com>
    net: wwan: iosm: fix crash in peek throughput test

M Chetan Kumar <m.chetan.kumar@linux.intel.com>
    net: wwan: iosm: fix dma_alloc_coherent incompatible pointer type

M Chetan Kumar <m.chetan.kumar@linux.intel.com>
    net: wwan: iosm: fix kernel test robot reported error

Yuri Karpov <YKarpov@ispras.ru>
    net: ethernet: nixge: fix NULL dereference

Wang Hai <wanghai38@huawei.com>
    net/9p: Fix a potential socket leak in p9_socket_open

Yuan Can <yuancan@huawei.com>
    net: net_netdev: Fix error handling in ntb_netdev_init_module()

Zhang Changzhong <zhangchangzhong@huawei.com>
    net: ethernet: ti: am65-cpsw: fix error handling in am65_cpsw_nuss_probe()

Yang Yingliang <yangyingliang@huawei.com>
    net: phy: fix null-ptr-deref while probe() failed

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mac8021: fix possible oob access in ieee80211_get_rate_duration

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: don't allow multi-BSSID in S1G

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: fix buffer overflow in elem comparison

Izabela Bakollari <ibakolla@redhat.com>
    aquantia: Do not purge addresses when setting the number of rings

Duoming Zhou <duoming@zju.edu.cn>
    qlcnic: fix sleep-in-atomic-context bugs caused by msleep

Amir Goldstein <amir73il@gmail.com>
    vfs: fix copy_file_range() averts filesystem freeze protection

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    can: m_can: Add check for devm_clk_get

Zhang Changzhong <zhangchangzhong@huawei.com>
    can: m_can: pci: add missing m_can_class_free_dev() in probe/remove methods

Zhang Changzhong <zhangchangzhong@huawei.com>
    can: etas_es58x: es58x_init_netdev(): free netdev when register_candev()

Zhang Changzhong <zhangchangzhong@huawei.com>
    can: cc770: cc770_isa_probe(): add missing free_cc770dev()

Zhang Changzhong <zhangchangzhong@huawei.com>
    can: sja1000_isa: sja1000_isa_probe(): add missing free_sja1000dev()

Roi Dayan <roid@nvidia.com>
    net/mlx5e: Fix use-after-free when reverting termination table

YueHaibing <yuehaibing@huawei.com>
    net/mlx5: Fix uninitialized variable bug in outlen_write()

Chris Mi <cmi@nvidia.com>
    net/mlx5: E-switch, Fix duplicate lag creation

Chris Mi <cmi@nvidia.com>
    net/mlx5: E-switch, Destroy legacy fdb table when needed

YueHaibing <yuehaibing@huawei.com>
    net/mlx5: DR, Fix uninitialized var warning

Wang Hai <wanghai38@huawei.com>
    e100: Fix possible use after free in e100_xmit_prepare

Yuan Can <yuancan@huawei.com>
    iavf: Fix error handling in iavf_init_module()

Yuan Can <yuancan@huawei.com>
    fm10k: Fix error handling in fm10k_init_module()

Shang XiaoJing <shangxiaojing@huawei.com>
    i40e: Fix error handling in i40e_init_module()

Shang XiaoJing <shangxiaojing@huawei.com>
    ixgbevf: Fix resource leak in ixgbevf_init_module()

Shazad Hussain <quic_shazhuss@quicinc.com>
    clk: qcom: gcc-sc8280xp: add cxo as parent for three ufs ref clks

Yang Yingliang <yangyingliang@huawei.com>
    of: property: decrement node refcount in of_fwnode_get_reference_args()

Wei Yongjun <weiyongjun1@huawei.com>
    nvmem: rmem: Fix return value check in rmem_read()

Xu Kuohai <xukuohai@huawei.com>
    bpf: Do not copy spin lock field from user in bpf_selem_alloc

Joe Korty <joe.korty@concurrent-rt.com>
    clocksource/drivers/arm_arch_timer: Fix XGene-1 TVAL register math error

Gaosheng Cui <cuigaosheng1@huawei.com>
    hwmon: (ibmpex) Fix possible UAF when ibmpex_register_bmc() fails

Yang Yingliang <yangyingliang@huawei.com>
    hwmon: (i5500_temp) fix missing pci_disable_device()

Ninad Malwade <nmalwade@nvidia.com>
    hwmon: (ina3221) Fix shunt sum critical calculation

Derek Nguyen <derek.nguyen@collins.com>
    hwmon: (ltc2947) fix temperature scaling

Hou Tao <houtao1@huawei.com>
    libbpf: Handle size overflow for ringbuf mmap

Michael Grzeschik <m.grzeschik@pengutronix.de>
    ARM: at91: rm9200: fix usb device clock id

Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    scripts/faddr2line: Fix regression in name resolution on ppc64le

Hou Tao <houtao1@huawei.com>
    bpf, perf: Use subprog name when reporting subprog ksymbol

Jiri Olsa <jolsa@kernel.org>
    libbpf: Use correct return pointer in attach_raw_tp

Paul Gazzillo <paul@pgazz.com>
    iio: light: rpr0521: add missing Kconfig dependencies

Wei Yongjun <weiyongjun1@huawei.com>
    iio: health: afe4404: Fix oob read in afe4404_[read|write]_raw

Wei Yongjun <weiyongjun1@huawei.com>
    iio: health: afe4403: Fix oob read in afe4403_read_raw

Stephen Boyd <swboyd@chromium.org>
    clk: qcom: gdsc: Remove direct runtime PM calls

Johan Hovold <johan+linaro@kernel.org>
    clk: qcom: gdsc: add missing error handling

David Virag <virag.david003@gmail.com>
    clk: samsung: exynos7885: Correct "div4" clock parents

lyndonli <Lyndon.Li@amd.com>
    drm/amd/pm: update driver if header for smu_13_0_7

Kenneth Feng <kenneth.feng@amd.com>
    drm/amd/pm: update driver-if header for smu_v13_0_10

Yang Wang <KevinYang.Wang@amd.com>
    drm/amd/pm: add smu_v13_0_10 driver if version

Christian König <christian.koenig@amd.com>
    drm/amdgpu: fix userptr HMM range handling v2

Christian König <christian.koenig@amd.com>
    drm/amdgpu: cleanup error handling in amdgpu_cs_parser_bos

Christian König <christian.koenig@amd.com>
    drm/amdgpu: move setting the job resources

ChenXiaoSong <chenxiaosong2@huawei.com>
    btrfs: qgroup: fix sleep from invalid context bug in btrfs_qgroup_inherit()


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/at91rm9200.dtsi                  |   2 +-
 arch/powerpc/net/bpf_jit_comp32.c                  |  52 ++++-----
 arch/riscv/include/asm/asm.h                       |   1 +
 arch/riscv/include/asm/efi.h                       |   6 +-
 arch/riscv/include/asm/pgalloc.h                   |  11 +-
 arch/riscv/kernel/entry.S                          |  13 +++
 arch/riscv/kernel/machine_kexec.c                  |  35 ++++++
 arch/riscv/kernel/setup.c                          |   9 +-
 arch/riscv/kernel/traps.c                          |  18 ++++
 arch/riscv/kernel/vdso/Makefile                    |   1 +
 arch/x86/include/asm/nospec-branch.h               |   2 +-
 arch/x86/kernel/cpu/bugs.c                         |  21 ++--
 arch/x86/kernel/process.c                          |   2 +-
 drivers/acpi/numa/hmat.c                           |  27 +++--
 drivers/char/tpm/tpm-interface.c                   |   5 +-
 drivers/clk/at91/at91rm9200.c                      |   2 +-
 drivers/clk/qcom/gcc-sc8280xp.c                    |   6 ++
 drivers/clk/qcom/gdsc.c                            |  70 +++---------
 drivers/clk/qcom/gdsc.h                            |   2 -
 drivers/clk/samsung/clk-exynos7885.c               |   4 +-
 drivers/clocksource/arm_arch_timer.c               |   7 +-
 drivers/clocksource/timer-riscv.c                  |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |  12 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c        |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h        |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |  60 ++++-------
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c            |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c            |  17 +++
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.h            |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |  53 +++-------
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h            |  14 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c            |   3 +
 drivers/gpu/drm/amd/display/Kconfig                |   7 ++
 .../pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_0.h | 111 +++++++++++++------
 .../pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_7.h | 117 ++++++++++++++-------
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h       |   5 +-
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c     |   3 +-
 drivers/gpu/drm/i915/gt/intel_gt.c                 |   9 +-
 drivers/gpu/drm/i915/gt/intel_gt_requests.c        |   2 +-
 drivers/hwmon/asus-ec-sensors.c                    |   2 +
 drivers/hwmon/coretemp.c                           |   9 +-
 drivers/hwmon/i5500_temp.c                         |   2 +-
 drivers/hwmon/ibmpex.c                             |   1 +
 drivers/hwmon/ina3221.c                            |   4 +-
 drivers/hwmon/ltc2947-core.c                       |   2 +-
 drivers/i2c/busses/i2c-imx.c                       |   6 +-
 drivers/i2c/busses/i2c-npcm7xx.c                   |  11 +-
 drivers/i2c/busses/i2c-qcom-geni.c                 |   1 -
 drivers/i2c/i2c-core-base.c                        |   9 +-
 drivers/iio/health/afe4403.c                       |   5 +-
 drivers/iio/health/afe4404.c                       |  12 ++-
 drivers/iio/light/Kconfig                          |   2 +
 drivers/input/touchscreen/raydium_i2c_ts.c         |   4 +-
 drivers/iommu/intel/dmar.c                         |   1 +
 drivers/iommu/intel/iommu.c                        |   4 +-
 drivers/media/common/videobuf2/frame_vector.c      |  68 +++---------
 drivers/mmc/core/core.c                            |   9 +-
 drivers/mmc/core/mmc_test.c                        |   3 +-
 drivers/mmc/host/mtk-sd.c                          |   6 +-
 drivers/mmc/host/sdhci-esdhc-imx.c                 |   2 +-
 drivers/mmc/host/sdhci-sprd.c                      |   4 +-
 drivers/mmc/host/sdhci.c                           |  61 +++++++++--
 drivers/mmc/host/sdhci.h                           |   2 +
 drivers/net/can/can327.c                           |   4 +-
 drivers/net/can/cc770/cc770_isa.c                  |  10 +-
 drivers/net/can/m_can/m_can.c                      |   2 +-
 drivers/net/can/m_can/m_can_pci.c                  |   9 +-
 drivers/net/can/sja1000/sja1000_isa.c              |  10 +-
 drivers/net/can/usb/etas_es58x/es58x_core.c        |   5 +-
 drivers/net/dsa/lan9303-core.c                     |   2 +-
 .../net/ethernet/aquantia/atlantic/aq_ethtool.c    |   5 +-
 drivers/net/ethernet/aquantia/atlantic/aq_main.c   |   4 +-
 drivers/net/ethernet/aquantia/atlantic/aq_main.h   |   2 +
 drivers/net/ethernet/intel/e100.c                  |   5 +-
 drivers/net/ethernet/intel/fm10k/fm10k_main.c      |  10 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  11 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   9 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   8 ++
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   7 ++
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |   9 +-
 .../mellanox/mlx5/core/steering/dr_table.c         |   5 +-
 drivers/net/ethernet/ni/nixge.c                    |  29 ++---
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c    |   4 +-
 drivers/net/ethernet/renesas/ravb_main.c           |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   2 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  12 ++-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   2 +-
 drivers/net/mdio/fwnode_mdio.c                     |   2 +-
 drivers/net/ntb_netdev.c                           |   9 +-
 drivers/net/phy/phy_device.c                       |   2 +
 drivers/net/tun.c                                  |   4 +-
 drivers/net/wwan/iosm/iosm_ipc_mux_codec.c         |  26 ++---
 drivers/net/wwan/iosm/iosm_ipc_protocol.h          |   2 +-
 drivers/nvme/host/core.c                           |   2 +-
 drivers/nvme/host/multipath.c                      |   3 +
 drivers/nvmem/rmem.c                               |   4 +-
 drivers/of/property.c                              |   4 +-
 drivers/pinctrl/intel/pinctrl-intel.c              |  27 ++++-
 drivers/pinctrl/pinctrl-single.c                   |   2 +-
 fs/afs/fs_probe.c                                  |   4 +-
 fs/afs/server.c                                    |   2 +-
 fs/btrfs/qgroup.c                                  |   9 +-
 fs/ksmbd/vfs.c                                     |   6 +-
 fs/nfsd/vfs.c                                      |   4 +-
 fs/nilfs2/dat.c                                    |   7 ++
 fs/read_write.c                                    |  19 +++-
 include/linux/damon.h                              |  37 ++++---
 include/linux/fs.h                                 |   8 ++
 include/linux/mmc/mmc.h                            |   2 +-
 include/net/sctp/stream_sched.h                    |   2 +
 ipc/sem.c                                          |   3 +-
 kernel/bpf/bpf_local_storage.c                     |   2 +-
 kernel/events/core.c                               |   2 +-
 kernel/sysctl.c                                    |  30 +++---
 kernel/trace/trace_dynevent.c                      |   2 +
 kernel/trace/trace_events.c                        |  11 +-
 kernel/trace/trace_events_hist.c                   |   3 +
 kernel/trace/trace_osnoise.c                       |   6 +-
 lib/Kconfig.debug                                  |   9 +-
 mm/compaction.c                                    |  22 ++--
 mm/damon/core.c                                    |  31 +++---
 mm/damon/dbgfs.c                                   |  27 +++--
 mm/damon/lru_sort.c                                |  46 ++++----
 mm/damon/reclaim.c                                 |  23 ++--
 mm/damon/sysfs.c                                   |  63 +++++++++--
 net/9p/trans_fd.c                                  |   4 +-
 net/hsr/hsr_forward.c                              |   5 +-
 net/ipv4/fib_semantics.c                           |  10 +-
 net/mac80211/airtime.c                             |   3 +
 net/mptcp/protocol.c                               |  13 ++-
 net/mptcp/subflow.c                                |   6 +-
 net/packet/af_packet.c                             |   6 +-
 net/sctp/stream.c                                  |  25 +++--
 net/sctp/stream_sched.c                            |   5 +
 net/sctp/stream_sched_prio.c                       |  19 ++++
 net/sctp/stream_sched_rr.c                         |   5 +
 net/tipc/crypto.c                                  |   3 +
 net/wireless/scan.c                                |  10 +-
 scripts/faddr2line                                 |   7 +-
 sound/firewire/dice/dice-stream.c                  |  12 ++-
 sound/soc/codecs/tlv320adc3xxx.c                   |   3 +
 sound/soc/soc-ops.c                                |   2 +-
 tools/lib/bpf/libbpf.c                             |   2 +-
 tools/lib/bpf/ringbuf.c                            |  12 ++-
 tools/testing/selftests/net/fib_nexthops.sh        |  16 +++
 tools/vm/slabinfo-gnuplot.sh                       |   4 +-
 151 files changed, 1153 insertions(+), 629 deletions(-)


