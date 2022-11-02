Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A37C6157B8
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbiKBChf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbiKBChe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:37:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B8A2F5BA;
        Tue,  1 Nov 2022 19:37:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F087B82063;
        Wed,  2 Nov 2022 02:37:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2D7C433D6;
        Wed,  2 Nov 2022 02:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356648;
        bh=bgRfqNcWNnnWX4NHPVRjl3nYzfIlCV5LTshU8Ugj0Hg=;
        h=From:To:Cc:Subject:Date:From;
        b=dNj+kZGUvBS3nzLgby60EzRGWQjNuGmRdCYMz39TPh70vi2XbL3eX7iNMb7JlqdPR
         pkjFgwE67YJXtrWb95Tmd9GzMlomDt8fvY56ytHUp9TB+8jm6Ed4VKAYjHHbQ74UR9
         gQBO0/5hNw1ECt1DR4pA1zJeQwBGmKGK6fh/l5UE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: [PATCH 6.0 000/240] 6.0.7-rc1 review
Date:   Wed,  2 Nov 2022 03:29:35 +0100
Message-Id: <20221102022111.398283374@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.0.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.0.7-rc1
X-KernelTest-Deadline: 2022-11-04T02:21+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 6.0.7 release.
There are 240 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.7-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.0.7-rc1

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp/udp: Fix memory leak in ipv6_renew_options().

D Scott Phillips <scott@os.amperecomputing.com>
    arm64: Add AMPERE1 to the Spectre-BHB affected list

Conor Dooley <conor.dooley@microchip.com>
    riscv: fix detection of toolchain Zihintpause support

Conor Dooley <conor.dooley@microchip.com>
    riscv: fix detection of toolchain Zicbom support

Qinglin Pan <panqinglin2020@iscas.ac.cn>
    riscv: mm: add missing memcpy in kasan_init

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: survive memory pressure without crashing

Eric Dumazet <edumazet@google.com>
    kcm: do not sense pfmemalloc status in kcm_sendpage()

Eric Dumazet <edumazet@google.com>
    net: do not sense pfmemalloc status in skb_append_pagefrags()

Suresh Devarakonda <ramad@nvidia.com>
    net/mlx5: Fix crash during sync firmware reset

Roy Novich <royno@nvidia.com>
    net/mlx5: Update fw fatal reporter state on PCI handlers successful recover

Ariel Levkovich <lariel@nvidia.com>
    net/mlx5e: TC, Reject forwarding from internal port to internal port

Tariq Toukan <tariqt@nvidia.com>
    net/mlx5: Fix possible use-after-free in async command interface

Saeed Mahameed <saeedm@nvidia.com>
    net/mlx5: ASO, Create the ASO SQ with the correct timestamp format

Paul Blakey <paulb@nvidia.com>
    net/mlx5e: Update restore chain id for slow path packets

Aya Levin <ayal@nvidia.com>
    net/mlx5e: Extend SKB room check to include PTP-SQ

Rongwei Liu <rongweil@nvidia.com>
    net/mlx5: DR, Fix matcher disconnect error flow

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Wait for firmware to enable CRS before pci_restore_state

Hyong Youb Kim <hyonkim@cisco.com>
    net/mlx5e: Do not increment ESN when updating IPsec ESN state

Zhengchao Shao <shaozhengchao@huawei.com>
    netdevsim: remove dir in nsim_dev_debugfs_init() when creating ports dir failed

Zhengchao Shao <shaozhengchao@huawei.com>
    netdevsim: fix memory leak in nsim_drv_probe() when nsim_dev_resources_register() failed

Zhengchao Shao <shaozhengchao@huawei.com>
    netdevsim: fix memory leak in nsim_bus_dev_new()

Rafał Miłecki <rafal@milecki.pl>
    net: broadcom: bcm4908_enet: update TX stats after actual transmission

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    nh: fix scope used to find saddr when adding non gw nh

Florian Fainelli <f.fainelli@gmail.com>
    net: bcmsysport: Indicate MAC is in charge of PHY PM

Yang Yingliang <yangyingliang@huawei.com>
    net: ehea: fix possible memory leak in ehea_register_port()

Aaron Conole <aconole@redhat.com>
    openvswitch: switch from WARN to pr_warn

Takashi Iwai <tiwai@suse.de>
    ALSA: aoa: Fix I2S device accounting

Yang Yingliang <yangyingliang@huawei.com>
    ALSA: aoa: i2sbus: fix possible memory leak in i2sbus_add_dev()

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    net: ethernet: ave: Fix MAC to be in charge of PHY PM

Juergen Borleis <jbe@pengutronix.de>
    net: fec: limit register access on i.MX6UL

Shang XiaoJing <shangxiaojing@huawei.com>
    perf vendor events arm64: Fix incorrect Hisi hip08 L3 metrics

Sudeep Holla <sudeep.holla@arm.com>
    PM: domains: Fix handling of unavailable/disabled idle states

Jisheng Zhang <jszhang@kernel.org>
    riscv: jump_label: mark arguments as const to satisfy asm constraints

Yang Yingliang <yangyingliang@huawei.com>
    net: ksz884x: fix missing pci_disable_device() on error in pcidev_init()

Slawomir Laba <slawomirx.laba@intel.com>
    i40e: Fix flow-type by setting GL_HASH_INSET registers

Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
    i40e: Fix VF hang when reset is triggered on another VF

Slawomir Laba <slawomirx.laba@intel.com>
    i40e: Fix ethtool rx-flow-hash setting for X722

Eric Dumazet <edumazet@google.com>
    ipv6: ensure sane device mtu in tunnels

Thomas Richter <tmricht@linux.ibm.com>
    perf list: Fix PMU name pai_crypto in perf list on s390

Kajol Jain <kjain@linux.ibm.com>
    perf vendor events power10: Fix hv-24x7 metric events

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: vivid: set num_in/outputs to 0 if not supported

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: videodev2.h: V4L2_DV_BT_BLANKING_HEIGHT should check 'interlaced'

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: v4l2-dv-timings: add sanity checks for blanking values

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: vivid: dev->bitmap_cap wasn't freed in all cases

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: vivid: s_fbuf: add more sanity checks

Mario Limonciello <mario.limonciello@amd.com>
    PM: hibernate: Allow hybrid sleep to work with s2idle

Dongliang Mu <dzm91@hust.edu.cn>
    can: mcp251x: mcp251x_can_probe(): add missing unregister_candev() in error path

Dongliang Mu <dzm91@hust.edu.cn>
    can: mscan: mpc5xxx: mpc5xxx_can_probe(): add missing put_clock() in error path

Paolo Abeni <pabeni@redhat.com>
    mptcp: set msk local address earlier

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: lan966x: Stop replacing tx dcbs and dcbs_buf when changing MTU

Rafael Mendonca <rafaelmendsr@gmail.com>
    drm/amdkfd: Fix memory leak in kfd_mem_dmamap_userptr()

Jakub Kicinski <kuba@kernel.org>
    net-memcg: avoid stalls when under memory pressure

Neal Cardwell <ncardwell@google.com>
    tcp: fix indefinite deferral of RTO with SACK reneging

Lu Wei <luwei32@huawei.com>
    tcp: fix a signed-integer-overflow bug in tcp_add_backlog()

Zhang Changzhong <zhangchangzhong@huawei.com>
    net: lantiq_etop: don't free skb when returning NETDEV_TX_BUSY

Zhengchao Shao <shaozhengchao@huawei.com>
    net: fix UAF issue in nfqnl_nf_hook_drop() when ops_init() failed

Eric Dumazet <edumazet@google.com>
    kcm: annotate data-races around kcm->rx_wait

Eric Dumazet <edumazet@google.com>
    kcm: annotate data-races around kcm->rx_psock

Íñigo Huguet <ihuguet@redhat.com>
    atlantic: fix deadlock at aq_nic_stop

Ankit Nautiyal <ankit.k.nautiyal@intel.com>
    drm/i915/dp: Reset frl trained flag before restarting FRL training

Anshuman Gupta <anshuman.gupta@intel.com>
    drm/i915/dgfx: Keep PCI autosuspend control 'on' by default on all dGPU

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: add the bit rate quirk for Molex cables

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: fix the SFP compliance codes check for DAC cables

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: Yellow carp devices do not need rrc

Chang S. Bae <chang.seok.bae@intel.com>
    x86/fpu: Fix copy_xstate_to_uabi() to copy init states correctly

Douglas Anderson <dianders@chromium.org>
    drm/bridge: ps8640: Add back the 50 ms mystery delay after HPD

Chen Zhongjin <chenzhongjin@huawei.com>
    x86/unwind/orc: Fix unreliable stack dump with gcov

Anup Patel <apatel@ventanamicro.com>
    RISC-V: KVM: Fix kvm_riscv_vcpu_timer_pending() for Sstc

Andrew Jones <ajones@ventanamicro.com>
    RISC-V: Fix compilation without RISCV_ISA_ZICBOM

Andrew Jones <ajones@ventanamicro.com>
    RISC-V: KVM: Provide UAPI for Zicbom block size

Shang XiaoJing <shangxiaojing@huawei.com>
    nfc: virtual_ncidev: Fix memory leak in virtual_nci_send()

Sergiu Moga <sergiu.moga@microchip.com>
    net: macb: Specify PHY PM management done by MAC

Zhengchao Shao <shaozhengchao@huawei.com>
    net: hinic: fix the issue of double release MBOX callback of VF

Zhengchao Shao <shaozhengchao@huawei.com>
    net: hinic: fix the issue of CMDQ memory leaks

Zhengchao Shao <shaozhengchao@huawei.com>
    net: hinic: fix memory leak when reading function table

Zhengchao Shao <shaozhengchao@huawei.com>
    net: hinic: fix incorrect assignment issue in hinic_set_interrupt_cfg()

Benjamin Poirier <bpoirier@nvidia.com>
    selftests: net: Fix netdev name mismatch in cleanup

Benjamin Poirier <bpoirier@nvidia.com>
    selftests: net: Fix cross-tree inclusion of scripts

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: lan966x: Fix the rx drop counter

Yang Yingliang <yangyingliang@huawei.com>
    net: netsec: fix error handling in netsec_register_mdio()

Xin Long <lucien.xin@gmail.com>
    tipc: fix a null-ptr-deref in tipc_topsrv_accept

Paul E. McKenney <paulmck@kernel.org>
    rcu: Keep synchronize_rcu() from enabling irqs in early boot

Maxim Levitsky <mlevitsk@redhat.com>
    perf/x86/intel/lbr: Use setup_clear_cpu_cap() instead of clear_cpu_cap()

Yang Yingliang <yangyingliang@huawei.com>
    ALSA: ac97: fix possible memory leak in snd_ac97_dev_register()

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: Intel: pci-tgl: fix ADL-N descriptor

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ASoC: SOF: Intel: pci-tgl: use RPL specific firmware definitions

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ASoC: Intel: common: add ACPI matching tables for Raptor Lake

Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>
    ASoC: qcom: lpass-cpu: Mark HDMI TX parity register as volatile

Cédric Le Goater <clg@kaod.org>
    spi: aspeed: Fix window offset of CE1

Sven Schnelle <svens@linux.ibm.com>
    selftests/ftrace: fix dynamic_events dependency check

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: Intel: pci-mtl: fix firmware name

Geert Uytterhoeven <geert@linux-m68k.org>
    ASoC: codecs: tlv320adc3xxx: Wrap adc3xxx_i2c_remove() in __exit_p()

Horatiu Vultur <horatiu.vultur@microchip.com>
    pinctrl: ocelot: Fix incorrect trigger of the interrupt.

Yang Yingliang <yangyingliang@huawei.com>
    mtd: rawnand: intel: Add missing of_node_put() in ebu_nand_probe()

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    mtd: rawnand: intel: Use devm_platform_ioremap_resource_byname()

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    mtd: rawnand: intel: Remove unused nand_pa member from ebu_nand_cs

Rafał Miłecki <rafal@milecki.pl>
    mtd: core: add missing of_node_get() in dynamic partitions code

Randy Dunlap <rdunlap@infradead.org>
    arc: iounmap() arg is volatile

Stanislav Fomichev <sdf@google.com>
    bpf: prevent decl_tag from being referenced in func_proto

Lin Shengwang <linshengwang1@huawei.com>
    sched/core: Fix comparison in sched_group_cookie_match()

Peter Zijlstra <peterz@infradead.org>
    perf: Fix missing SIGTRAPs

Chang S. Bae <chang.seok.bae@intel.com>
    x86/fpu: Exclude dynamic states from init_fpstate

Chang S. Bae <chang.seok.bae@intel.com>
    x86/fpu: Fix the init_fpstate size check with the actual size

Chang S. Bae <chang.seok.bae@intel.com>
    x86/fpu: Configure init_fpstate attributes orderly

Robert Marko <robert.marko@sartura.hr>
    spi: qup: support using GPIO as chip select line

Douglas Anderson <dianders@chromium.org>
    pinctrl: qcom: Avoid glitching lines when we first mux to output

Gao Xiang <xiang@kernel.org>
    erofs: fix up inplace decompression success rate

Yue Hu <huyue2@coolpad.com>
    erofs: fix illegal unmapped accesses in z_erofs_fill_inode_lazy()

Rob Clark <robdclark@chromium.org>
    drm/msm/a6xx: Fix kvzalloc vs state_kcalloc usage

Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>
    ASoC: qcom: lpass-cpu: mark HDMI TX registers as volatile

Gavin Shan <gshan@redhat.com>
    KVM: selftests: Fix number of pages for memory slot in memslot_modification_stress_test

Randy Dunlap <rdunlap@infradead.org>
    ASoC: codec: tlv320adc3xxx: add GPIOLIB dependency

Kuogee Hsieh <quic_khsieh@quicinc.com>
    drm/msm/dp: cleared DP_DOWNSPREAD_CTRL register before start link training

Nathan Huckleberry <nhuck@google.com>
    drm/msm: Fix return type of mdp4_lvds_connector_mode_valid

Kuogee Hsieh <quic_khsieh@quicinc.com>
    drm/msm/dp: add atomic_check to bridge ops

Akhil P Oommen <quic_akhilpo@quicinc.com>
    drm/msm/a6xx: Replace kcalloc() with kvzalloc()

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    media: cedrus: Add a Kconfig dependency on RESET_CONTROLLER

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    media: sun8i-rotate: Add a Kconfig dependency on RESET_CONTROLLER

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    media: sun8i-di: Add a Kconfig dependency on RESET_CONTROLLER

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    media: sun4i-csi: Add a Kconfig dependency on RESET_CONTROLLER

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    media: sun6i-csi: Add a Kconfig dependency on RESET_CONTROLLER

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    media: sun8i-a83t-mipi-csi2: Add a Kconfig dependency on RESET_CONTROLLER

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    media: sun6i-mipi-csi2: Add a Kconfig dependency on RESET_CONTROLLER

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: sunxi: Fix some error handling path of sun6i_mipi_csi2_probe()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: sunxi: Fix some error handling path of sun8i_a83t_mipi_csi2_probe()

Dan Carpenter <dan.carpenter@oracle.com>
    media: atomisp: prevent integer overflow in sh_css_set_black_frame()

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: sun6i-mipi-csi2: Depend on PHY_SUN6I_MIPI_DPHY

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: ov8865: Fix an error handling path in ov8865_probe()

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: ar0521: Fix return value check in writing initial registers

Yang Yingliang <yangyingliang@huawei.com>
    media: ar0521: fix error return code in ar0521_power_on()

Alexander Stein <alexander.stein@ew.tq-group.com>
    media: v4l2: Fix v4l2_i2c_subdev_set_name function documentation

Ming Qian <ming.qian@nxp.com>
    media: amphion: release m2m ctx when releasing vpu instance

Wei Yongjun <weiyongjun1@huawei.com>
    net: ieee802154: fix error return code in dgram_bind()

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s/interrupt: Fix clear of PACA_IRQS_HARD_DIS when returning to soft-masked context

Manank Patel <pmanank200502@gmail.com>
    ACPI: PCC: Fix unintentional integer overflow

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    fbdev/core: Avoid uninitialized read in aperture_remove_conflicting_pci_device()

Xin Long <lucien.xin@gmail.com>
    ethtool: eeprom: fix null-deref on genl_info in dump

Heiko Carstens <hca@linux.ibm.com>
    s390/pci: add missing EX_TABLE entries to __pcistg_mio_inuser()/__pcilg_mio_inuser()

Heiko Carstens <hca@linux.ibm.com>
    s390/futex: add missing EX_TABLE entry to __futex_atomic_op()

Heiko Carstens <hca@linux.ibm.com>
    s390/uaccess: add missing EX_TABLE entries to __clear_user()

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/cio: fix out-of-bounds access on cio_ignore free

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/boot: add secure boot trailer

Adrian Hunter <adrian.hunter@intel.com>
    perf auxtrace: Fix address filter symbol name match for modules

Pavel Kozlov <pavel.kozlov@synopsys.com>
    ARC: mm: fix leakage of memory allocated for PTE

Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
    Revert "pinctrl: pinctrl-zynqmp: Add support for output-enable and bias-high-impedance"

Siarhei Volkau <lis8215@gmail.com>
    pinctrl: Ingenic: JZ4755 bug fixes

Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
    Revert "dt-bindings: pinctrl-zynqmp: Add output-enable configuration"

Christian A. Ehrhardt <lk@c--e.de>
    kernfs: fix use-after-free in __kernfs_remove

Hugh Dickins <hughd@google.com>
    mm: prep_compound_tail() clear page->private

Mel Gorman <mgorman@techsingularity.net>
    mm/huge_memory: do not clobber swp_entry_t during THP split

Waiman Long <longman@redhat.com>
    mm/kmemleak: prevent soft lockup in kmemleak_scan()'s object iteration loops

Rik van Riel <riel@surriel.com>
    mm,madvise,hugetlb: fix unexpected data loss with MADV_DONTNEED on hugetlbfs

Baolin Wang <baolin.wang@linux.alibaba.com>
    mm: migrate: fix return value if all subpages of THPs are migrated successfully

Peter Xu <peterx@redhat.com>
    mm/uffd: fix vma check on userfault for wp

William Breathitt Gray <william.gray@linaro.org>
    counter: 104-quad-8: Fix race getting function mode and direction

William Breathitt Gray <william.gray@linaro.org>
    counter: microchip-tcb-capture: Handle Signal1 read and Synapse

Sascha Hauer <s.hauer@pengutronix.de>
    mmc: sdhci-esdhc-imx: Propagate ESDHC_FLAG_HS400* only on 8bit bus

Patrick Thompson <ptf@google.com>
    mmc: sdhci-pci-core: Disable ES for ASUS BIOS on Jasper Lake

Vincent Whitchurch <vincent.whitchurch@axis.com>
    mmc: core: Fix WRITE_ZEROES CQE handling

Matthew Ma <mahongwei@zeku.com>
    mmc: core: Fix kernel panic when remove non-standard SDIO card

Christian Löhle <CLoehle@hyperstone.com>
    mmc: queue: Cancel recovery work on cleanup

Christian Löhle <CLoehle@hyperstone.com>
    mmc: block: Remove error check of hw_reset on reset

Brian Norris <briannorris@chromium.org>
    mmc: sdhci_am654: 'select', not 'depends' REGMAP_MMIO

James Clark <james.clark@arm.com>
    coresight: cti: Fix hang in cti_disable_hw()

Jean-Philippe Brucker <jean-philippe@linaro.org>
    random: use arch_get_random*_early() in random_init()

Nathan Huckleberry <nhuck@google.com>
    crypto: x86/polyval - Fix crashes when keys are not 16-byte aligned

Johan Hovold <johan+linaro@kernel.org>
    drm/msm/dp: fix bridge lifetime

Johan Hovold <johan+linaro@kernel.org>
    drm/msm/dp: fix IRQ lifetime

Johan Hovold <johan+linaro@kernel.org>
    drm/msm/dp: fix aux-bus EP lifetime

Johan Hovold <johan+linaro@kernel.org>
    drm/msm/dp: fix memory corruption with too many bridges

Johan Hovold <johan+linaro@kernel.org>
    drm/msm/hdmi: fix IRQ lifetime

Johan Hovold <johan+linaro@kernel.org>
    drm/msm/hdmi: fix memory corruption with too many bridges

Johan Hovold <johan+linaro@kernel.org>
    drm/msm/dsi: fix memory corruption with too many bridges

Johan Hovold <johan+linaro@kernel.org>
    drm/msm: fix use-after-free on probe deferral

Jesse Zhang <jesse.zhang@amd.com>
    drm/amdkfd: correct the cache info for gfx1036

Prike Liang <Prike.Liang@amd.com>
    drm/amdkfd: update gfx1037 Lx cache setting

Joaquín Ignacio Aramendía <samsagax@gmail.com>
    drm/amd/display: Revert logic for plane modifiers

Chengming Gui <Jack.Gui@amd.com>
    drm/amdgpu: fix pstate setting issue

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu: disallow gfxoff until GC IP blocks complete s2idle resume

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Remove ATC L2 access for MMHUB 2.1.x

José Roberto de Souza <jose.souza@intel.com>
    drm/i915: Extend Wa_1607297627 to Alderlake-P

Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
    drm/amdgpu: Fix for BO move issue

Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
    drm/amdgpu: Fix VRAM BO swap issue

Manish Rangankar <mrangankar@marvell.com>
    scsi: qla2xxx: Use transport-defined speed mask for supported_speeds

Miquel Raynal <miquel.raynal@bootlin.com>
    mac802154: Fix LQI recording

Bernd Edlinger <bernd.edlinger@hotmail.de>
    exec: Copy oldsighand->action under spin-lock

Li Zetao <lizetao1@huawei.com>
    fs/binfmt_elf: Fix memory leak in load_elf_binary()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: hybrid: Use known scaling factor for P-cores

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Read all MSRs on the target CPU

Hyunwoo Kim <imv4bel@gmail.com>
    fbdev: smscufx: Fix several use-after-free bugs

Helge Deller <deller@gmx.de>
    fbdev: stifb: Fall back to cfb_fillrect() on 32-bit HCRX cards

Matti Vaittinen <mazziesaccount@gmail.com>
    iio: adxl367: Fix unsafe buffer attributes

Matti Vaittinen <mazziesaccount@gmail.com>
    iio: adxl372: Fix unsafe buffer attributes

Cosmin Tanislav <cosmin.tanislav@analog.com>
    iio: temperature: ltc2983: allocate iio channels once

Shreeya Patel <shreeya.patel@collabora.com>
    iio: light: tsl2583: Fix module unloading

Matti Vaittinen <mazziesaccount@gmail.com>
    tools: iio: iio_utils: fix digit calculation

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Remove device endpoints from bandwidth list when freeing the device

Mario Limonciello <mario.limonciello@amd.com>
    xhci-pci: Set runtime PM as default policy on all xHC 1.2 or later devices

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Add quirk to reset host back to default state at shutdown

Phillip Lougher <phillip@squashfs.org.uk>
    squashfs: fix buffer release race condition in readahead code

Phillip Lougher <phillip@squashfs.org.uk>
    squashfs: fix extending readahead beyond end of file

Phillip Lougher <phillip@squashfs.org.uk>
    squashfs: fix read regression introduced in readahead code

Tony O'Brien <tony.obrien@alliedtelesis.co.nz>
    mtd: rawnand: marvell: Use correct logic for nand-keep-config

Linus Walleij <linus.walleij@linaro.org>
    mtd: parsers: bcm47xxpart: Fix halfblock reads

Mika Westerberg <mika.westerberg@linux.intel.com>
    mtd: spi-nor: core: Ignore -ENOTSUPP in spi_nor_init()

Zhang Qilong <zhangqilong3@huawei.com>
    mtd: rawnand: tegra: Fix PM disable depth imbalance in probe

Jens Glathe <jens.glathe@oldschoolsolutions.biz>
    usb: xhci: add XHCI_SPURIOUS_SUCCESS to ASM1042 despite being a V0.96 controller

Justin Chen <justinpopo6@gmail.com>
    usb: bdc: change state when port disconnected

Andrey Smirnov <andrew.smirnov@gmail.com>
    usb: dwc3: Don't switch OTG -> peripheral if extcon is present

Patrice Chotard <patrice.chotard@foss.st.com>
    usb: dwc3: st: Rely on child's compatible instead of name

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: typec: ucsi: acpi: Implement resume callback

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: typec: ucsi: Check the connection on resume

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Don't delay End Transfer on delayed_status

Wesley Cheng <quic_wcheng@quicinc.com>
    usb: dwc3: gadget: Force sending delayed status during soft disconnect

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Don't set IMI for no_interrupt

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Stop processing more requests on IMI

Joel Stanley <joel@jms.id.au>
    usb: gadget: aspeed: Fix probe regression

Jeff Vanhoof <qjv001@motorola.com>
    usb: gadget: uvc: fix sg handling during video encode

Dan Vacura <w36195@motorola.com>
    usb: gadget: uvc: fix sg handling in error case

Dan Vacura <w36195@motorola.com>
    usb: gadget: uvc: fix dropped frame after missed isoc

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "usb: gadget: uvc: limit isoc_sg to super speed gadgets"

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: gadget: uvc: limit isoc_sg to super speed gadgets

Hannu Hartikainen <hannu@hrtk.in>
    USB: add RESET_RESUME quirk for NVIDIA Jetson devices in RCM

Jason A. Donenfeld <Jason@zx2c4.com>
    ALSA: rme9652: use explicitly signed char

Jason A. Donenfeld <Jason@zx2c4.com>
    ALSA: au88x0: use explicitly signed char

Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
    ALSA: ca0106: Use snd_ctl_rename() to rename a control

Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
    ALSA: usb-audio: Use snd_ctl_rename() to rename a control

Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
    ALSA: ac97: Use snd_ctl_rename() to rename a control

Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
    ALSA: emu10k1: Use snd_ctl_rename() to rename a control

Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
    ALSA: hda/realtek: Use snd_ctl_rename() to rename a control

Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
    ALSA: control: add snd_ctl_rename()

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Add another HP ZBook G9 model quirks

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add quirks for M-Audio Fast Track C400/600

Stefan Binding <sbinding@opensource.cirrus.com>
    ALSA: hda/realtek: Add quirk for ASUS Zenbook using CS35L41

Steven Rostedt (Google) <rostedt@goodmis.org>
    ALSA: Use del_timer_sync() before freeing timer

Biju Das <biju.das.jz@bp.renesas.com>
    can: rcar_canfd: fix channel specific IRQ handling for RZ/G2L

Biju Das <biju.das.jz@bp.renesas.com>
    can: rcar_canfd: rcar_canfd_handle_global_receive(): fix IRQ storm on global FIFO receive

Anssi Hannula <anssi.hannula@bitwise.fi>
    can: kvaser_usb: Fix possible completions during init_completion

Yang Yingliang <yangyingliang@huawei.com>
    can: j1939: transport: j1939_session_skb_drop_old(): spin_unlock_irqrestore() before kfree_skb()

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    platform/x86/amd: pmc: remove CONFIG_DEBUG_FS checks


-------------

Diffstat:

 .../bindings/pinctrl/xlnx,zynqmp-pinctrl.yaml      |   4 -
 Makefile                                           |   4 +-
 arch/arc/include/asm/io.h                          |   2 +-
 arch/arc/include/asm/pgtable-levels.h              |   2 +-
 arch/arc/mm/ioremap.c                              |   2 +-
 arch/arm64/include/asm/cputype.h                   |   4 +
 arch/arm64/kernel/proton-pack.c                    |   6 +
 arch/powerpc/kernel/interrupt_64.S                 |  13 +-
 arch/riscv/Kconfig                                 |  17 ++-
 arch/riscv/Makefile                                |   6 +-
 arch/riscv/include/asm/cacheflush.h                |   8 --
 arch/riscv/include/asm/jump_label.h                |   8 +-
 arch/riscv/include/asm/kvm_vcpu_timer.h            |   1 +
 arch/riscv/include/asm/vdso/processor.h            |   2 +-
 arch/riscv/include/uapi/asm/kvm.h                  |   1 +
 arch/riscv/kvm/vcpu.c                              |  11 ++
 arch/riscv/kvm/vcpu_timer.c                        |  17 ++-
 arch/riscv/mm/cacheflush.c                         |  38 ++++++
 arch/riscv/mm/dma-noncoherent.c                    |  39 ------
 arch/riscv/mm/kasan_init.c                         |   7 +-
 arch/s390/boot/vmlinux.lds.S                       |  13 +-
 arch/s390/include/asm/futex.h                      |   3 +-
 arch/s390/lib/uaccess.c                            |   6 +-
 arch/s390/pci/pci_mmio.c                           |   8 +-
 arch/x86/crypto/polyval-clmulni_glue.c             |  19 ++-
 arch/x86/events/intel/lbr.c                        |   2 +-
 arch/x86/kernel/fpu/init.c                         |   8 --
 arch/x86/kernel/fpu/xstate.c                       |  42 +++---
 arch/x86/kernel/unwind_orc.c                       |   2 +-
 drivers/acpi/acpi_pcc.c                            |   2 +-
 drivers/base/power/domain.c                        |   4 +
 drivers/char/random.c                              |   4 +-
 drivers/counter/104-quad-8.c                       |  64 ++++++---
 drivers/counter/microchip-tcb-capture.c            |  18 ++-
 drivers/cpufreq/intel_pstate.c                     | 133 +++++++-----------
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c            |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  16 +++
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |  20 ++-
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c            |  28 ++--
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c              | 106 ++++++++++++++-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c    |  50 +------
 drivers/gpu/drm/bridge/parade-ps8640.c             |  25 +++-
 drivers/gpu/drm/i915/display/intel_dp.c            |   2 +
 drivers/gpu/drm/i915/gt/intel_workarounds.c        |   4 +-
 drivers/gpu/drm/i915/intel_runtime_pm.c            |  11 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c        |   7 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |   7 +-
 .../gpu/drm/msm/disp/mdp4/mdp4_lvds_connector.c    |   5 +-
 drivers/gpu/drm/msm/dp/dp_ctrl.c                   |  13 +-
 drivers/gpu/drm/msm/dp/dp_display.c                |  23 +++-
 drivers/gpu/drm/msm/dp/dp_drm.c                    |  34 +++++
 drivers/gpu/drm/msm/dp/dp_parser.c                 |   6 +-
 drivers/gpu/drm/msm/dp/dp_parser.h                 |   5 +-
 drivers/gpu/drm/msm/dsi/dsi.c                      |   6 +
 drivers/gpu/drm/msm/hdmi/hdmi.c                    |   7 +-
 drivers/gpu/drm/msm/msm_drv.c                      |   1 +
 drivers/hwtracing/coresight/coresight-cti-core.c   |   5 -
 drivers/iio/accel/adxl367.c                        |  23 +++-
 drivers/iio/accel/adxl372.c                        |  23 +++-
 drivers/iio/light/tsl2583.c                        |   2 +-
 drivers/iio/temperature/ltc2983.c                  |  13 +-
 drivers/media/i2c/ar0521.c                         |   8 +-
 drivers/media/i2c/ov8865.c                         |  10 +-
 drivers/media/platform/amphion/vpu_v4l2.c          |  11 +-
 drivers/media/platform/sunxi/sun4i-csi/Kconfig     |   2 +-
 drivers/media/platform/sunxi/sun6i-csi/Kconfig     |   2 +-
 .../media/platform/sunxi/sun6i-mipi-csi2/Kconfig   |   4 +-
 .../sunxi/sun6i-mipi-csi2/sun6i_mipi_csi2.c        |  20 ++-
 .../platform/sunxi/sun8i-a83t-mipi-csi2/Kconfig    |   2 +-
 .../sun8i-a83t-mipi-csi2/sun8i_a83t_mipi_csi2.c    |  23 +++-
 drivers/media/platform/sunxi/sun8i-di/Kconfig      |   2 +-
 drivers/media/platform/sunxi/sun8i-rotate/Kconfig  |   2 +-
 drivers/media/test-drivers/vivid/vivid-core.c      |  38 +++++-
 drivers/media/test-drivers/vivid/vivid-core.h      |   2 +
 drivers/media/test-drivers/vivid/vivid-vid-cap.c   |  27 +++-
 drivers/media/v4l2-core/v4l2-dv-timings.c          |  14 ++
 drivers/mmc/core/block.c                           |  44 +++---
 drivers/mmc/core/queue.c                           |   8 ++
 drivers/mmc/core/sdio_bus.c                        |   3 +-
 drivers/mmc/host/Kconfig                           |   3 +-
 drivers/mmc/host/sdhci-esdhc-imx.c                 |  14 +-
 drivers/mmc/host/sdhci-pci-core.c                  |  14 +-
 drivers/mtd/mtdcore.c                              |   2 +-
 drivers/mtd/nand/raw/intel-nand-controller.c       |  35 ++---
 drivers/mtd/nand/raw/marvell_nand.c                |   2 +-
 drivers/mtd/nand/raw/tegra_nand.c                  |   4 +-
 drivers/mtd/parsers/bcm47xxpart.c                  |   4 +-
 drivers/mtd/spi-nor/core.c                         |   4 +-
 drivers/net/can/mscan/mpc5xxx_can.c                |   8 +-
 drivers/net/can/rcar/rcar_canfd.c                  |  24 ++--
 drivers/net/can/spi/mcp251x.c                      |   5 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |   4 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   |   4 +-
 drivers/net/ethernet/amd/xgbe/xgbe-pci.c           |   5 +
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        |  19 ++-
 drivers/net/ethernet/amd/xgbe/xgbe.h               |   1 +
 drivers/net/ethernet/aquantia/atlantic/aq_macsec.c |  96 +++++++++----
 drivers/net/ethernet/aquantia/atlantic/aq_nic.h    |   2 +
 drivers/net/ethernet/broadcom/bcm4908_enet.c       |  12 +-
 drivers/net/ethernet/broadcom/bcmsysport.c         |   3 +
 drivers/net/ethernet/cadence/macb_main.c           |   1 +
 drivers/net/ethernet/freescale/enetc/enetc.c       |   5 +
 drivers/net/ethernet/freescale/fec_main.c          |  46 ++++++-
 drivers/net/ethernet/huawei/hinic/hinic_debugfs.c  |  18 ++-
 drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c  |   2 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c   |   2 +-
 drivers/net/ethernet/huawei/hinic/hinic_sriov.c    |   1 -
 drivers/net/ethernet/ibm/ehea/ehea_main.c          |   1 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     | 100 ++++++++------
 drivers/net/ethernet/intel/i40e/i40e_type.h        |   4 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  43 ++++--
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |   1 +
 drivers/net/ethernet/lantiq_etop.c                 |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h   |   9 ++
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |   6 +
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |   3 -
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  74 +++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |  17 +++
 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c  |   7 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   4 +
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |   3 +-
 drivers/net/ethernet/micrel/ksz884x.c              |   2 +-
 .../ethernet/microchip/lan966x/lan966x_ethtool.c   |  10 +-
 .../net/ethernet/microchip/lan966x/lan966x_fdma.c  |  24 +---
 drivers/net/ethernet/socionext/netsec.c            |   2 +
 drivers/net/ethernet/socionext/sni_ave.c           |   6 +
 drivers/net/netdevsim/bus.c                        |   9 +-
 drivers/net/netdevsim/dev.c                        |  31 +++--
 drivers/nfc/virtual_ncidev.c                       |   3 +
 drivers/pinctrl/pinctrl-ingenic.c                  |   4 +-
 drivers/pinctrl/pinctrl-ocelot.c                   |  17 ++-
 drivers/pinctrl/pinctrl-zynqmp.c                   |   9 --
 drivers/pinctrl/qcom/pinctrl-msm.c                 |  21 +++
 drivers/platform/x86/amd/pmc.c                     |  12 --
 drivers/s390/cio/css.c                             |   8 +-
 drivers/scsi/qla2xxx/qla_attr.c                    |  28 +++-
 drivers/spi/spi-aspeed-smc.c                       |   2 +-
 drivers/spi/spi-qup.c                              |   2 +
 drivers/staging/media/atomisp/pci/sh_css_params.c  |   4 +-
 drivers/staging/media/sunxi/cedrus/Kconfig         |   1 +
 drivers/usb/core/quirks.c                          |   9 ++
 drivers/usb/dwc3/core.c                            |  49 ++++++-
 drivers/usb/dwc3/drd.c                             |  50 -------
 drivers/usb/dwc3/dwc3-st.c                         |   2 +-
 drivers/usb/dwc3/gadget.c                          |  21 ++-
 drivers/usb/gadget/function/uvc_queue.c            |   8 +-
 drivers/usb/gadget/function/uvc_video.c            |  25 +++-
 drivers/usb/gadget/udc/aspeed-vhub/dev.c           |   1 +
 drivers/usb/gadget/udc/bdc/bdc_udc.c               |   1 +
 drivers/usb/host/xhci-mem.c                        |  20 +--
 drivers/usb/host/xhci-pci.c                        |  44 ++----
 drivers/usb/host/xhci.c                            |  10 +-
 drivers/usb/host/xhci.h                            |   1 +
 drivers/usb/typec/ucsi/ucsi.c                      |  42 ++++--
 drivers/usb/typec/ucsi/ucsi_acpi.c                 |  10 ++
 drivers/video/aperture.c                           |   5 +-
 drivers/video/fbdev/smscufx.c                      |  55 ++++----
 drivers/video/fbdev/stifb.c                        |   3 +-
 fs/binfmt_elf.c                                    |   3 +-
 fs/erofs/zdata.c                                   |   6 +-
 fs/erofs/zmap.c                                    |  17 +--
 fs/exec.c                                          |   4 +-
 fs/kernfs/dir.c                                    |   5 +-
 fs/squashfs/file.c                                 |  23 ++--
 fs/squashfs/page_actor.c                           |   3 +
 fs/squashfs/page_actor.h                           |   6 +-
 include/linux/mlx5/driver.h                        |   2 +-
 include/linux/perf_event.h                         |  19 ++-
 include/linux/userfaultfd_k.h                      |   6 +-
 include/media/v4l2-common.h                        |   3 +-
 include/net/sock.h                                 |   2 +-
 include/sound/control.h                            |   1 +
 include/sound/soc-acpi-intel-match.h               |   2 +
 include/uapi/linux/videodev2.h                     |   3 +-
 kernel/bpf/btf.c                                   |   5 +
 kernel/events/core.c                               | 151 +++++++++++++++------
 kernel/events/ring_buffer.c                        |   2 +-
 kernel/power/hibernate.c                           |   2 +-
 kernel/rcu/tree.c                                  |  10 +-
 kernel/sched/sched.h                               |  18 +--
 mm/huge_memory.c                                   |  11 +-
 mm/kmemleak.c                                      |  61 ++++++---
 mm/madvise.c                                       |  12 +-
 mm/migrate.c                                       |   7 +
 mm/page_alloc.c                                    |   1 +
 net/can/j1939/transport.c                          |   4 +-
 net/core/net_namespace.c                           |   7 +
 net/core/skbuff.c                                  |   2 +-
 net/ethtool/eeprom.c                               |   2 +-
 net/ieee802154/socket.c                            |   4 +-
 net/ipv4/nexthop.c                                 |   2 +-
 net/ipv4/tcp_input.c                               |   3 +-
 net/ipv4/tcp_ipv4.c                                |   4 +-
 net/ipv6/ip6_gre.c                                 |  12 +-
 net/ipv6/ip6_tunnel.c                              |  11 +-
 net/ipv6/ipv6_sockglue.c                           |   7 +
 net/ipv6/sit.c                                     |   8 +-
 net/kcm/kcmsock.c                                  |  25 ++--
 net/mac802154/rx.c                                 |   5 +-
 net/mptcp/protocol.c                               |   3 +-
 net/mptcp/protocol.h                               |   1 +
 net/mptcp/subflow.c                                |   7 +
 net/openvswitch/datapath.c                         |   3 +-
 net/tipc/topsrv.c                                  |  16 ++-
 sound/aoa/soundbus/i2sbus/core.c                   |   7 +-
 sound/core/control.c                               |  23 ++++
 sound/pci/ac97/ac97_codec.c                        |  33 +++--
 sound/pci/au88x0/au88x0.h                          |   6 +-
 sound/pci/au88x0/au88x0_core.c                     |   2 +-
 sound/pci/ca0106/ca0106_mixer.c                    |   2 +-
 sound/pci/emu10k1/emumixer.c                       |   2 +-
 sound/pci/hda/patch_realtek.c                      |   5 +-
 sound/pci/rme9652/hdsp.c                           |  26 ++--
 sound/pci/rme9652/rme9652.c                        |  22 +--
 sound/soc/codecs/Kconfig                           |   1 +
 sound/soc/codecs/tlv320adc3xxx.c                   |   2 +-
 sound/soc/intel/common/Makefile                    |   2 +-
 sound/soc/intel/common/soc-acpi-intel-rpl-match.c  |  51 +++++++
 sound/soc/qcom/lpass-cpu.c                         |  10 ++
 sound/soc/sof/intel/pci-mtl.c                      |   2 +-
 sound/soc/sof/intel/pci-tgl.c                      |  92 ++++++++++++-
 sound/synth/emux/emux.c                            |   7 +-
 sound/usb/implicit.c                               |   2 +
 sound/usb/mixer.c                                  |   2 +-
 tools/iio/iio_utils.c                              |   4 +
 .../arch/arm64/hisilicon/hip08/metrics.json        |   6 +-
 .../arch/powerpc/power10/nest_metrics.json         |  72 +++++-----
 .../arch/s390/cf_z16/{pai.json => pai_crypto.json} |   0
 tools/perf/util/auxtrace.c                         |  10 +-
 .../testing/selftests/drivers/net/bonding/Makefile |   4 +-
 .../drivers/net/bonding/dev_addr_lists.sh          |   2 +-
 .../drivers/net/bonding/net_forwarding_lib.sh      |   1 +
 .../drivers/net/dsa/test_bridge_fdb_stress.sh      |   4 +-
 tools/testing/selftests/drivers/net/team/Makefile  |   4 +
 .../selftests/drivers/net/team/dev_addr_lists.sh   |   6 +-
 .../testing/selftests/drivers/net/team/lag_lib.sh  |   1 +
 .../drivers/net/team/net_forwarding_lib.sh         |   1 +
 .../ftrace/test.d/dynevent/test_duplicates.tc      |   2 +-
 .../inter-event/trigger-synthetic-eprobe.tc        |   2 +-
 .../kvm/memslot_modification_stress_test.c         |   2 +-
 tools/testing/selftests/lib.mk                     |   4 +-
 246 files changed, 2260 insertions(+), 1058 deletions(-)


