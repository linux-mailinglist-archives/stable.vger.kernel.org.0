Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 721526158D7
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbiKBC7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbiKBC7g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:59:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D4D222A8;
        Tue,  1 Nov 2022 19:59:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 555DEB8206C;
        Wed,  2 Nov 2022 02:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500DBC433D6;
        Wed,  2 Nov 2022 02:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357972;
        bh=UzmSYY4f7wxMhEIRhs2yu/vBBdKVDh/gCyw8/g3euQU=;
        h=From:To:Cc:Subject:Date:From;
        b=TSJEdwD/+0e09lNqxByIGsiO3NJxXAWN+74bmj11rcjSqO7TyPWfNSCfrQLb27eyH
         vv7S33zZm0jUE2xBvEhEm+qIYc96p9G9eGbCWf5gyAl8Ji0pCnGinjCzNKv/OG9VYo
         HA1Yh/uEfTUnsOfvgE1jjIj69v0F+C7R38t1Gqjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: [PATCH 5.15 000/132] 5.15.77-rc1 review
Date:   Wed,  2 Nov 2022 03:31:46 +0100
Message-Id: <20221102022059.593236470@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.77-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.77-rc1
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

This is the start of the stable review cycle for the 5.15.77 release.
There are 132 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.77-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.77-rc1

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp/udp: Fix memory leak in ipv6_renew_options().

Lukas Wunner <lukas@wunner.de>
    serial: Deassert Transmit Enable on probe in driver-specific way

Lino Sanfilippo <LinoSanfilippo@gmx.de>
    serial: core: move RS485 configuration tasks from drivers into core

Biju Das <biju.das.jz@bp.renesas.com>
    can: rcar_canfd: rcar_canfd_handle_global_receive(): fix IRQ storm on global FIFO receive

Biju Das <biju.das.jz@bp.renesas.com>
    can: rcar_canfd: fix channel specific IRQ handling for RZ/G2L

Yu Kuai <yukuai3@huawei.com>
    scsi: sd: Revert "scsi: sd: Remove a local variable"

D Scott Phillips <scott@os.amperecomputing.com>
    arm64: Add AMPERE1 to the Spectre-BHB affected list

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

Saeed Mahameed <saeedm@nvidia.com>
    net/mlx5: Print more info on pci error handlers

Tariq Toukan <tariqt@nvidia.com>
    net/mlx5: Fix possible use-after-free in async command interface

Aya Levin <ayal@nvidia.com>
    net/mlx5e: Extend SKB room check to include PTP-SQ

Hyong Youb Kim <hyonkim@cisco.com>
    net/mlx5e: Do not increment ESN when updating IPsec ESN state

Zhengchao Shao <shaozhengchao@huawei.com>
    netdevsim: remove dir in nsim_dev_debugfs_init() when creating ports dir failed

Rafał Miłecki <rafal@milecki.pl>
    net: broadcom: bcm4908_enet: update TX stats after actual transmission

Colin Ian King <colin.i.king@gmail.com>
    net: broadcom: bcm4908enet: remove redundant variable bytes

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

Rafael Mendonca <rafaelmendsr@gmail.com>
    drm/amdkfd: Fix memory leak in kfd_mem_dmamap_userptr()

Jakub Kicinski <kuba@kernel.org>
    net-memcg: avoid stalls when under memory pressure

Neal Cardwell <ncardwell@google.com>
    tcp: fix indefinite deferral of RTO with SACK reneging

Lu Wei <luwei32@huawei.com>
    tcp: fix a signed-integer-overflow bug in tcp_add_backlog()

Eric Dumazet <edumazet@google.com>
    tcp: minor optimization in tcp_add_backlog()

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

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: add the bit rate quirk for Molex cables

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: fix the SFP compliance codes check for DAC cables

Chen Zhongjin <chenzhongjin@huawei.com>
    x86/unwind/orc: Fix unreliable stack dump with gcov

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

Yang Yingliang <yangyingliang@huawei.com>
    net: netsec: fix error handling in netsec_register_mdio()

Xin Long <lucien.xin@gmail.com>
    tipc: fix a null-ptr-deref in tipc_topsrv_accept

Maxim Levitsky <mlevitsk@redhat.com>
    perf/x86/intel/lbr: Use setup_clear_cpu_cap() instead of clear_cpu_cap()

Yang Yingliang <yangyingliang@huawei.com>
    ALSA: ac97: fix possible memory leak in snd_ac97_dev_register()

Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>
    ASoC: qcom: lpass-cpu: Mark HDMI TX parity register as volatile

Yang Yingliang <yangyingliang@huawei.com>
    mtd: rawnand: intel: Add missing of_node_put() in ebu_nand_probe()

Randy Dunlap <rdunlap@infradead.org>
    arc: iounmap() arg is volatile

Lin Shengwang <linshengwang1@huawei.com>
    sched/core: Fix comparison in sched_group_cookie_match()

Peter Zijlstra <peterz@infradead.org>
    perf: Fix missing SIGTRAPs

Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>
    ASoC: qcom: lpass-cpu: mark HDMI TX registers as volatile

Gavin Shan <gshan@redhat.com>
    KVM: selftests: Fix number of pages for memory slot in memslot_modification_stress_test

Nathan Huckleberry <nhuck@google.com>
    drm/msm: Fix return type of mdp4_lvds_connector_mode_valid

Dan Carpenter <dan.carpenter@oracle.com>
    media: atomisp: prevent integer overflow in sh_css_set_black_frame()

Alexander Stein <alexander.stein@ew.tq-group.com>
    media: v4l2: Fix v4l2_i2c_subdev_set_name function documentation

Wei Yongjun <weiyongjun1@huawei.com>
    net: ieee802154: fix error return code in dgram_bind()

Xin Long <lucien.xin@gmail.com>
    ethtool: eeprom: fix null-deref on genl_info in dump

Christian Löhle <CLoehle@hyperstone.com>
    mmc: block: Remove error check of hw_reset on reset

James Smart <jsmart2021@gmail.com>
    Revert "scsi: lpfc: SLI path split: Refactor lpfc_iocbq"

James Smart <jsmart2021@gmail.com>
    Revert "scsi: lpfc: SLI path split: Refactor fast and slow paths to native SLI4"

James Smart <jsmart2021@gmail.com>
    Revert "scsi: lpfc: SLI path split: Refactor SCSI paths"

James Smart <jsmart2021@gmail.com>
    Revert "scsi: lpfc: Fix locking for lpfc_sli_iocbq_lookup()"

James Smart <jsmart2021@gmail.com>
    Revert "scsi: lpfc: Fix element offset in __lpfc_sli_release_iocbq_s4()"

James Smart <jsmart2021@gmail.com>
    Revert "scsi: lpfc: Resolve some cleanup issues following SLI path refactoring"

Heiko Carstens <hca@linux.ibm.com>
    s390/pci: add missing EX_TABLE entries to __pcistg_mio_inuser()/__pcilg_mio_inuser()

Heiko Carstens <hca@linux.ibm.com>
    s390/futex: add missing EX_TABLE entry to __futex_atomic_op()

Adrian Hunter <adrian.hunter@intel.com>
    perf auxtrace: Fix address filter symbol name match for modules

Pavel Kozlov <pavel.kozlov@synopsys.com>
    ARC: mm: fix leakage of memory allocated for PTE

Siarhei Volkau <lis8215@gmail.com>
    pinctrl: Ingenic: JZ4755 bug fixes

Christian A. Ehrhardt <lk@c--e.de>
    kernfs: fix use-after-free in __kernfs_remove

William Breathitt Gray <william.gray@linaro.org>
    counter: microchip-tcb-capture: Handle Signal1 read and Synapse

Sascha Hauer <s.hauer@pengutronix.de>
    mmc: sdhci-esdhc-imx: Propagate ESDHC_FLAG_HS400* only on 8bit bus

Patrick Thompson <ptf@google.com>
    mmc: sdhci-pci-core: Disable ES for ASUS BIOS on Jasper Lake

Matthew Ma <mahongwei@zeku.com>
    mmc: core: Fix kernel panic when remove non-standard SDIO card

Brian Norris <briannorris@chromium.org>
    mmc: sdhci_am654: 'select', not 'depends' REGMAP_MMIO

James Clark <james.clark@arm.com>
    coresight: cti: Fix hang in cti_disable_hw()

Johan Hovold <johan+linaro@kernel.org>
    drm/msm/dp: fix IRQ lifetime

Johan Hovold <johan+linaro@kernel.org>
    drm/msm/hdmi: fix memory corruption with too many bridges

Johan Hovold <johan+linaro@kernel.org>
    drm/msm/dsi: fix memory corruption with too many bridges

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu: disallow gfxoff until GC IP blocks complete s2idle resume

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

Tony O'Brien <tony.obrien@alliedtelesis.co.nz>
    mtd: rawnand: marvell: Use correct logic for nand-keep-config

Jens Glathe <jens.glathe@oldschoolsolutions.biz>
    usb: xhci: add XHCI_SPURIOUS_SUCCESS to ASM1042 despite being a V0.96 controller

Justin Chen <justinpopo6@gmail.com>
    usb: bdc: change state when port disconnected

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Don't set IMI for no_interrupt

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Stop processing more requests on IMI

Jeff Vanhoof <qjv001@motorola.com>
    usb: gadget: uvc: fix sg handling during video encode

Dan Vacura <w36195@motorola.com>
    usb: gadget: uvc: fix sg handling in error case

Hannu Hartikainen <hannu@hrtk.in>
    USB: add RESET_RESUME quirk for NVIDIA Jetson devices in RCM

Jason A. Donenfeld <Jason@zx2c4.com>
    ALSA: rme9652: use explicitly signed char

Jason A. Donenfeld <Jason@zx2c4.com>
    ALSA: au88x0: use explicitly signed char

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add quirks for M-Audio Fast Track C400/600

Steven Rostedt (Google) <rostedt@goodmis.org>
    ALSA: Use del_timer_sync() before freeing timer

Anssi Hannula <anssi.hannula@bitwise.fi>
    can: kvaser_usb: Fix possible completions during init_completion

Yang Yingliang <yangyingliang@huawei.com>
    can: j1939: transport: j1939_session_skb_drop_old(): spin_unlock_irqrestore() before kfree_skb()

Scott Mayhew <smayhew@redhat.com>
    NFSv4: Add an fattr allocation to _nfs4_discover_trunking()

Benjamin Coddington <bcodding@redhat.com>
    NFSv4: Fix free of uninitialized nfs4_label on referral lookup.


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arc/include/asm/io.h                          |   2 +-
 arch/arc/include/asm/pgtable-levels.h              |   2 +-
 arch/arc/mm/ioremap.c                              |   2 +-
 arch/arm64/include/asm/cputype.h                   |   4 +
 arch/arm64/kernel/proton-pack.c                    |   6 +
 arch/s390/include/asm/futex.h                      |   3 +-
 arch/s390/pci/pci_mmio.c                           |   8 +-
 arch/x86/events/intel/lbr.c                        |   2 +-
 arch/x86/kernel/unwind_orc.c                       |   2 +-
 drivers/base/power/domain.c                        |   4 +
 drivers/counter/microchip-tcb-capture.c            |  18 +-
 drivers/cpufreq/intel_pstate.c                     | 133 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  16 +
 drivers/gpu/drm/i915/display/intel_dp.c            |   2 +
 .../gpu/drm/msm/disp/mdp4/mdp4_lvds_connector.c    |   5 +-
 drivers/gpu/drm/msm/dp/dp_display.c                |   2 +-
 drivers/gpu/drm/msm/dsi/dsi.c                      |   6 +
 drivers/gpu/drm/msm/hdmi/hdmi.c                    |   5 +
 drivers/hwtracing/coresight/coresight-cti-core.c   |   5 -
 drivers/iio/accel/adxl372.c                        |  23 +-
 drivers/iio/light/tsl2583.c                        |   2 +-
 drivers/iio/temperature/ltc2983.c                  |  13 +-
 drivers/media/test-drivers/vivid/vivid-core.c      |  38 +-
 drivers/media/test-drivers/vivid/vivid-core.h      |   2 +
 drivers/media/test-drivers/vivid/vivid-vid-cap.c   |  27 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c          |  14 +
 drivers/mmc/core/block.c                           |  44 +-
 drivers/mmc/core/sdio_bus.c                        |   3 +-
 drivers/mmc/host/Kconfig                           |   3 +-
 drivers/mmc/host/sdhci-esdhc-imx.c                 |  14 +-
 drivers/mmc/host/sdhci-pci-core.c                  |  14 +-
 drivers/mtd/nand/raw/intel-nand-controller.c       |  19 +-
 drivers/mtd/nand/raw/marvell_nand.c                |   2 +-
 drivers/net/can/mscan/mpc5xxx_can.c                |   8 +-
 drivers/net/can/rcar/rcar_canfd.c                  |  24 +-
 drivers/net/can/spi/mcp251x.c                      |   5 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |   4 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   |   4 +-
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        |  17 +-
 drivers/net/ethernet/aquantia/atlantic/aq_macsec.c |  96 ++-
 drivers/net/ethernet/aquantia/atlantic/aq_nic.h    |   2 +
 drivers/net/ethernet/broadcom/bcm4908_enet.c       |  10 +-
 drivers/net/ethernet/broadcom/bcmsysport.c         |   3 +
 drivers/net/ethernet/cadence/macb_main.c           |   1 +
 drivers/net/ethernet/freescale/enetc/enetc.c       |   5 +
 drivers/net/ethernet/freescale/fec_main.c          |  46 +-
 drivers/net/ethernet/huawei/hinic/hinic_debugfs.c  |  18 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c  |   2 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c   |   2 +-
 drivers/net/ethernet/huawei/hinic/hinic_sriov.c    |   1 -
 drivers/net/ethernet/ibm/ehea/ehea_main.c          |   1 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     | 100 ++-
 drivers/net/ethernet/intel/i40e/i40e_type.h        |   4 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  43 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |   1 +
 drivers/net/ethernet/lantiq_etop.c                 |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h   |   9 +
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |   6 +
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |   3 -
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  55 +-
 drivers/net/ethernet/micrel/ksz884x.c              |   2 +-
 drivers/net/ethernet/socionext/netsec.c            |   2 +
 drivers/net/ethernet/socionext/sni_ave.c           |   6 +
 drivers/net/netdevsim/dev.c                        |  11 +-
 drivers/nfc/virtual_ncidev.c                       |   3 +
 drivers/pinctrl/pinctrl-ingenic.c                  |   4 +-
 drivers/scsi/lpfc/lpfc.h                           |  40 -
 drivers/scsi/lpfc/lpfc_bsg.c                       |  50 +-
 drivers/scsi/lpfc/lpfc_crtn.h                      |   3 +-
 drivers/scsi/lpfc/lpfc_ct.c                        |   8 +-
 drivers/scsi/lpfc/lpfc_els.c                       | 139 ++--
 drivers/scsi/lpfc/lpfc_hw4.h                       |   7 -
 drivers/scsi/lpfc/lpfc_init.c                      |  13 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |   4 +-
 drivers/scsi/lpfc/lpfc_nvme.c                      |  34 +-
 drivers/scsi/lpfc/lpfc_nvme.h                      |   6 +-
 drivers/scsi/lpfc/lpfc_nvmet.c                     |  83 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      | 441 ++++++-----
 drivers/scsi/lpfc/lpfc_sli.c                       | 876 ++++++++++++---------
 drivers/scsi/lpfc/lpfc_sli.h                       |  26 +-
 drivers/scsi/qla2xxx/qla_attr.c                    |  28 +-
 drivers/scsi/sd.c                                  |   3 +-
 drivers/staging/media/atomisp/pci/sh_css_params.c  |   4 +-
 drivers/tty/serial/8250/8250_omap.c                |   3 +
 drivers/tty/serial/8250/8250_pci.c                 |   9 +-
 drivers/tty/serial/8250/8250_port.c                |  12 +-
 drivers/tty/serial/fsl_lpuart.c                    |   8 +-
 drivers/tty/serial/imx.c                           |   8 +-
 drivers/tty/serial/serial_core.c                   |  61 +-
 drivers/usb/core/quirks.c                          |   9 +
 drivers/usb/dwc3/gadget.c                          |   8 +-
 drivers/usb/gadget/function/uvc_queue.c            |   8 +-
 drivers/usb/gadget/function/uvc_video.c            |  22 +-
 drivers/usb/gadget/udc/bdc/bdc_udc.c               |   1 +
 drivers/usb/host/xhci-mem.c                        |  20 +-
 drivers/usb/host/xhci-pci.c                        |  44 +-
 drivers/usb/host/xhci.c                            |  10 +-
 drivers/usb/host/xhci.h                            |   1 +
 drivers/video/fbdev/smscufx.c                      |  55 +-
 fs/binfmt_elf.c                                    |   3 +-
 fs/exec.c                                          |   4 +-
 fs/kernfs/dir.c                                    |   5 +-
 fs/nfs/nfs4namespace.c                             |   9 +-
 fs/nfs/nfs4proc.c                                  |  34 +-
 fs/nfs/nfs4state.c                                 |   9 +-
 fs/nfs/nfs4xdr.c                                   |   4 +-
 include/linux/mlx5/driver.h                        |   2 +-
 include/linux/nfs_xdr.h                            |   2 +-
 include/linux/perf_event.h                         |  19 +-
 include/media/v4l2-common.h                        |   3 +-
 include/net/sock.h                                 |   2 +-
 include/uapi/linux/videodev2.h                     |   3 +-
 kernel/events/core.c                               | 153 +++-
 kernel/events/ring_buffer.c                        |   2 +-
 kernel/power/hibernate.c                           |   2 +-
 kernel/sched/sched.h                               |  18 +-
 net/can/j1939/transport.c                          |   4 +-
 net/core/net_namespace.c                           |   7 +
 net/core/skbuff.c                                  |   2 +-
 net/ethtool/eeprom.c                               |   2 +-
 net/ieee802154/socket.c                            |   4 +-
 net/ipv4/nexthop.c                                 |   2 +-
 net/ipv4/tcp_input.c                               |   3 +-
 net/ipv4/tcp_ipv4.c                                |   7 +-
 net/ipv6/ip6_gre.c                                 |  12 +-
 net/ipv6/ip6_tunnel.c                              |  11 +-
 net/ipv6/ipv6_sockglue.c                           |   7 +
 net/ipv6/sit.c                                     |   8 +-
 net/kcm/kcmsock.c                                  |  25 +-
 net/mac802154/rx.c                                 |   5 +-
 net/openvswitch/datapath.c                         |   3 +-
 net/tipc/topsrv.c                                  |  16 +-
 sound/aoa/soundbus/i2sbus/core.c                   |   7 +-
 sound/pci/ac97/ac97_codec.c                        |   1 +
 sound/pci/au88x0/au88x0.h                          |   6 +-
 sound/pci/au88x0/au88x0_core.c                     |   2 +-
 sound/pci/rme9652/hdsp.c                           |  26 +-
 sound/pci/rme9652/rme9652.c                        |  22 +-
 sound/soc/qcom/lpass-cpu.c                         |  10 +
 sound/synth/emux/emux.c                            |   7 +-
 sound/usb/implicit.c                               |   2 +
 tools/iio/iio_utils.c                              |   4 +
 .../arch/arm64/hisilicon/hip08/metrics.json        |   6 +-
 .../arch/powerpc/power10/nest_metrics.json         |  72 +-
 tools/perf/util/auxtrace.c                         |  10 +-
 .../kvm/memslot_modification_stress_test.c         |   2 +-
 151 files changed, 2130 insertions(+), 1459 deletions(-)


