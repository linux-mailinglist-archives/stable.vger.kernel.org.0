Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D480C40E13E
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242593AbhIPQ2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:28:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:37000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236946AbhIPQ0v (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:26:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C055E61503;
        Thu, 16 Sep 2021 16:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809039;
        bh=CS81D4PvqvNsi1GWdY3d/mQ5YXRi/ch//9h1h838wM0=;
        h=From:To:Cc:Subject:Date:From;
        b=KXQWgXFoA8kg4sesxaj6w5xNoey+Cdu/Ix34Kxf3QMZzrYro+qBjj6Pp5u1n4JlKw
         llX+LhhUDRe8+R23Jhp8oJ31ve/3+fybmFHtDSwUs3FZZ4T04nAqL3Ic7IHsJ5ucb4
         +wL4Yl8XYlYNFsaFQWCauG8l4/kGwUFfCCdBDEu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.13 000/380] 5.13.19-rc1 review
Date:   Thu, 16 Sep 2021 17:55:57 +0200
Message-Id: <20210916155803.966362085@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.19-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.19-rc1
X-KernelTest-Deadline: 2021-09-18T15:58+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.13.19 release.
There are 380 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 18 Sep 2021 15:57:06 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.19-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.13.19-rc1

Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
    drm/panfrost: Clamp lock region to Bifrost minimum

Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
    drm/panfrost: Use u64 for size in lock_region

Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
    drm/panfrost: Simplify lock_region calculation

Kalyan Thota <kalyan_t@codeaurora.org>
    drm/msm/disp/dpu1: add safe lut config in dpu driver

Aaron Liu <aaron.liu@amd.com>
    drm/amd/display: setup system context for APUs

Jerry (Fangzhi) Zuo <Jerry.Zuo@amd.com>
    drm/amd/display: Update bounding box states (v2)

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd/display: Update number of DCN3 clock states

xinhui pan <xinhui.pan@amd.com>
    drm/amdgpu: Fix a deadlock if previous GEM object allocation fails

Andrey Grodzovsky <andrey.grodzovsky@amd.com>
    drm/amdgpu: Fix BUG_ON assert

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panfrost: Make sure MMU context lifetime is not bound to panfrost_priv

Rajkumar Subbiah <rsubbia@codeaurora.org>
    drm/dp_mst: Fix return code on sideband message failure

David Heidelberg <david@ixit.cz>
    drm/msi/mdp4: populate priv->kms in mdp4_kms_init

Thomas Zimmermann <tzimmermann@suse.de>
    drm/mgag200: Select clock in PLL update functions

Song Yoong Siang <yoong.siang.song@intel.com>
    net: stmmac: Fix overall budget calculation for rxtx_napi

Jan Hoffmann <jan@3e8.eu>
    net: dsa: lantiq_gswip: fix maximum frame length

Kees Cook <keescook@chromium.org>
    lib/test_stackinit: Fix static initializer test

Patryk Duda <pdk@semihalf.com>
    platform/chrome: cros_ec_proto: Send command again when timeout occurs

sumiyawang <sumiyawang@tencent.com>
    libnvdimm/pmem: Fix crash triggered when I/O in-flight during unbind

Vasily Averin <vvs@virtuozzo.com>
    memcg: enable accounting for pids in nested pid namespaces

Rik van Riel <riel@surriel.com>
    mm,vmscan: fix divide by zero in get_scan_count

Liu Zixian <liuzixian4@huawei.com>
    mm/hugetlb: initialize hugetlb_usage in mm_init

Li Zhijian <lizhijian@cn.fujitsu.com>
    mm/hmm: bypass devmap pte when all pfn requested flags are fulfilled

David Hildenbrand <david@redhat.com>
    mm/memory_hotplug: use "unsigned long" for PFN in zone_for_pfn_range()

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlb: fix hugetlb cgroup refcounting during vma split

Sven Schnelle <svens@linux.ibm.com>
    s390/topology: fix topology information when calling cpu hotplug notifiers

Halil Pasic <pasic@linux.ibm.com>
    s390/pv: fix the forcing of the swiotlb

Pratik R. Sampat <psampat@linux.ibm.com>
    cpufreq: powernv: Fix init_chip_info initialization in numa=off

Evgeny Novikov <novikov@ispras.ru>
    mtd: rawnand: intel: Fix error handling in probe

Saurav Kashyap <skashyap@marvell.com>
    scsi: qla2xxx: Sync queue idx with queue_pair_map idx

Saurav Kashyap <skashyap@marvell.com>
    scsi: qla2xxx: Changes to support kdump kernel

Maciej W. Rozycki <macro@orcam.me.uk>
    scsi: BusLogic: Fix missing pr_cont() use

chenying <chenying.kernel@bytedance.com>
    ovl: fix BUG_ON() in may_delete() when called from ovl_cleanup()

Petr Mladek <pmladek@suse.com>
    printk/console: Check consistent sequence number when handling race in console_unlock()

Masahiro Yamada <masahiroy@kernel.org>
    parisc: Fix compile failure when building 64-bit kernel natively

Mikulas Patocka <mpatocka@redhat.com>
    parisc: fix crash with signals and alloca

Marc Zyngier <maz@kernel.org>
    KVM: arm64: vgic: move irq->get_input_level into an ops structure

Guojia Liao <liaoguojia@huawei.com>
    net: hns3: clean up a type mismatch warning

Yang Yingliang <yangyingliang@huawei.com>
    net: w5100: check return value after calling platform_get_resource()

Haimin Zhang <tcs_kernel@tencent.com>
    fix array-index-out-of-bounds in taprio_change

王贇 <yun.wang@linux.alibaba.com>
    net: fix NULL pointer reference in cipso_v4_doi_free

Miaoqing Pan <miaoqing@codeaurora.org>
    ath9k: fix sleeping in atomic context

Zekun Shen <bruceshenzk@gmail.com>
    ath9k: fix OOB read ar9300_eeprom_restore_internal

Loic Poulain <loic.poulain@linaro.org>
    wcn36xx: Fix missing frame timestamp for beacon/probe-resp

Chengfeng Ye <cyeaa@connect.ust.hk>
    selftests/bpf: Fix potential unreleased lock

Colin Ian King <colin.king@canonical.com>
    parport: remove non-zero check on count

Yevgeny Kliteynik <kliteyn@nvidia.com>
    net/mlx5: DR, Enable QP retransmission

Wentao_Liang <Wentao_Liang_g@163.com>
    net/mlx5: DR, fix a potential use-after-free bug

Ilan Peer <ilan.peer@intel.com>
    iwlwifi: mvm: Fix scan channel flags settings

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: fw: correctly limit to monitor dump

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: fix access to BSS elements

Ilan Peer <ilan.peer@intel.com>
    iwlwifi: mvm: Fix umac scan request probe parameters

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: avoid static queue number aliasing

Zhang Qilong <zhangqilong3@huawei.com>
    iwlwifi: mvm: fix a memory leak in iwl_mvm_mac_ctxt_beacon_changed

Ilan Peer <ilan.peer@intel.com>
    iwlwifi: mvm: Do not use full SSIDs in 6GHz scan

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: free RBs during configure

J. Bruce Fields <bfields@redhat.com>
    nfsd: fix crash on LOCKT on reexported NFSv3

J. Bruce Fields <bfields@redhat.com>
    nfs: don't atempt blocking locks on nfs reexports

Sean Keely <Sean.Keely@amd.com>
    drm/amdkfd: Account for SH/SE count when setting up cu masks.

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: soc-pcm: protect BE dailink state changes in trigger

Xiaotan Luo <lxt@rock-chips.com>
    ASoC: rockchip: i2s: Fixup config for DAIFMT_DSP_A/B

Sugar Zhang <sugar.zhang@rock-chips.com>
    ASoC: rockchip: i2s: Fix regmap_ops hang

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: fix use-after-free of mtk->hcd

Shuah Khan <skhan@linuxfoundation.org>
    usbip:vhci_hcd USB port can get stuck in the disabled state

Anirudh Rayabharam <mail@anirudhrb.com>
    usbip: give back URBs for unsent unlink requests during cleanup

Nadezda Lutovinova <lutovinova@ispras.ru>
    usb: musb: musb_dsps: request_irq() after initializing musb

Nadezda Lutovinova <lutovinova@ispras.ru>
    usb: dwc3: imx8mp: request irq after initializing dwc3

Mathias Nyman <mathias.nyman@linux.intel.com>
    Revert "USB: xhci: fix U1/U2 handling for hardware with XHCI_INTEL_HOST quirk set"

Ding Hui <dinghui@sangfor.com.cn>
    cifs: fix wrong release in sess_alloc_buffer() failed path

Juhee Kang <claudiajkang@gmail.com>
    samples: pktgen: fix to print when terminated normally

Nishad Kamdar <nishadkamdar@gmail.com>
    mmc: core: Return correct emmc response in case of ioctl error

Li Zhijian <lizhijian@cn.fujitsu.com>
    selftests/bpf: Enlarge select() timeout for test_maps

Thomas Hebb <tommyhebb@gmail.com>
    mmc: rtsx_pci: Fix long reads when clock is prescaled

Manish Narani <manish.narani@xilinx.com>
    mmc: sdhci-of-arasan: Check return value of non-void funtions

Manish Narani <manish.narani@xilinx.com>
    mmc: sdhci-of-arasan: Modified SD default speed to 19MHz for ZynqMP

Marc Zyngier <maz@kernel.org>
    of: Don't allow __of_attached_node_sysfs() without CONFIG_SYSFS

Gustaw Lewandowski <gustaw.lewandowski@linux.intel.com>
    ASoC: Intel: Skylake: Fix passing loadable flag for module

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: Skylake: Fix module configuration for KPB and MIXER

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    soundwire: intel: fix potential race condition during power down

Marcos Paulo de Souza <mpdesouza@suse.com>
    btrfs: tree-log: check btrfs_lookup_data_extent return value

Filipe Manana <fdmanana@suse.com>
    btrfs: remove racy and unnecessary inode transaction update when using no-holes

Arnd Bergmann <arnd@arndb.de>
    m68knommu: only set CONFIG_ISA_DMA_API for ColdFire sub-arch

Subbaraya Sundeep <sbhatta@marvell.com>
    octeontx2-pf: Fix NIX1_RX interface backpressure

Chin-Yen Lee <timlee@realtek.com>
    rtw88: wow: fix size access error of probe request

Ping-Ke Shih <pkshih@realtek.com>
    rtw88: wow: build wow function only if CONFIG_PM is on

Chin-Yen Lee <timlee@realtek.com>
    rtw88: use read_poll_timeout instead of fixed sleep

Chris Chiu <chris.chiu@canonical.com>
    rtl8xxxu: Fix the handling of TX A-MPDU aggregation

Nathan Chancellor <nathan@kernel.org>
    drm/exynos: Always initialize mapping in exynos_drm_register_dma()

J. Bruce Fields <bfields@redhat.com>
    lockd: lockd server-side shouldn't set fl_ops

Li Jun <jun.li@nxp.com>
    usb: chipidea: host: fix port index underflow and UBSAN complains

Bob Peterson <rpeterso@redhat.com>
    gfs2: Don't call dlm after protocol is unmounted

Mark Brown <broonie@kernel.org>
    kselftest/arm64: pac: Fix skipping of tests on systems without PAC

Mark Brown <broonie@kernel.org>
    kselftest/arm64: mte: Fix misleading output when skipping tests

Eli Cohen <elic@nvidia.com>
    net: Fix offloading indirect devices dependency on qdisc order creation

Bongsu Jeon <bongsu.jeon@samsung.com>
    selftests: nci: Fix the wrong condition

Bongsu Jeon <bongsu.jeon@samsung.com>
    selftests: nci: Fix the code for next nlattr offset

Kees Cook <keescook@chromium.org>
    staging: rts5208: Fix get_ms_information() heap buffer size

Brandon Wyman <bjwyman@gmail.com>
    hwmon: (pmbus/ibm-cffps) Fix write bits for LED control

Yonghong Song <yhs@fb.com>
    selftests/bpf: Fix flaky send_signal test

Yucong Sun <fallentree@fb.com>
    selftests/bpf: Correctly display subtest skip status

Stefan Assmann <sassmann@kpanic.de>
    iavf: use mutexes for locking of critical sections

J. Bruce Fields <bfields@redhat.com>
    rpc: fix gss_svc_init cleanup on failure

Thomas Gleixner <tglx@linutronix.de>
    locking/rtmutex: Set proper wait context for lockdep

Luke Hsiao <lukehsiao@google.com>
    tcp: enable data-less, empty-cookie SYN with TFO_SERVER_COOKIE_NOT_REQD

Darrick J. Wong <djwong@kernel.org>
    iomap: pass writeback errors to the mapping

Ulrich Hecht <uli+renesas@fpond.eu>
    serial: sh-sci: fix break handling for sysrq

Rajendra Nayak <rnayak@codeaurora.org>
    opp: Don't print an error if required-opps is missing

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Fix handling of LE Enhanced Connection Complete

Sagi Grimberg <sagi@grimberg.me>
    nvme: code command_id with a genctr for use-after-free validation

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: don't check blk_mq_tag_to_rq when receiving pdu data

Raag Jadav <raagjadav@gmail.com>
    arm64: dts: ls1046a: fix eeprom entries

Tim Harvey <tharvey@gateworks.com>
    arm64: dts: imx8mm-venice-gw71xx: fix USB OTG VBUS

Tim Harvey <tharvey@gateworks.com>
    arm64: dts: imx8mm-venice-gw700x: fix invalid pmic pin config

Tim Harvey <tharvey@gateworks.com>
    arm64: dts: imx8mm-venice-gw700x: fix mp5416 pmic config

Thierry Reding <treding@nvidia.com>
    arm64: tegra: Fix compatible string for Tegra132 CPUs

Andreas Obergschwandtner <andreas.obergschwandtner@gmail.com>
    ARM: tegra: tamonten: Fix UART pad setting

Dmitry Osipenko <digetx@gmail.com>
    ARM: tegra: acer-a500: Remove bogus USB VBUS regulators

Johan Almbladh <johan.almbladh@anyfinetworks.com>
    mac80211: Fix monitor MTU limit so that A-MSDUs get through

Tuo Li <islituo@gmail.com>
    drm/display: fix possible null-pointer dereference in dcn10_set_clock()

Tuo Li <islituo@gmail.com>
    gpu: drm: amd: amdgpu: amdgpu_i2c: fix possible uninitialized-variable access in amdgpu_i2c_router_select_ddc_port()

Eran Ben Elisha <eranbe@nvidia.com>
    net/mlx5: Fix variable type to match 64bit

Kuogee Hsieh <khsieh@codeaurora.org>
    drm/msm/dp: do not end dp link training until video is ready

Kuogee Hsieh <khsieh@codeaurora.org>
    drm/msm/dp: return correct edid checksum after corrupted edid checksum read

Kuogee Hsieh <khsieh@codeaurora.org>
    drm/msm/dp: reduce link rate if failed at link training 1

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    Bluetooth: avoid circular locks in sco_sock_connect

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    Bluetooth: schedule SCO timeouts with delayed_work

Fabio Aiuto <fabioaiuto83@gmail.com>
    staging: rtl8723bs: fix right side of condition

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    drm/vmwgfx: fix potential UAF in vmwgfx_surface.c

Jussi Maki <joamaki@gmail.com>
    selftests/bpf: Fix xdp_tx.c prog section name

Roy Chan <roy.chan@amd.com>
    drm/amd/display: fix incorrect CM/TF programming sequence in dwb

Roy Chan <roy.chan@amd.com>
    drm/amd/display: fix missing writeback disablement if plane is removed

Sanjay R Mehta <sanju.mehta@amd.com>
    thunderbolt: Fix port linking by checking all adapters

Quanyang Wang <quanyang.wang@windriver.com>
    drm: xlnx: zynqmp: release reset to DP controller before accessing DP registers

Quanyang Wang <quanyang.wang@windriver.com>
    drm: xlnx: zynqmp_dpsub: Call pm_runtime_get_sync before setting pixel clock

Konrad Dybcio <konrad.dybcio@somainline.org>
    drm/msm/dsi: Fix DSI and DSI PHY regulator config from SDM660

David Heidelberg <david@ixit.cz>
    drm/msm: mdp4: drop vblank get/put from prepare/complete_commit

Nathan Chancellor <nathan@kernel.org>
    net: ethernet: stmmac: Do not use unreachable() in ipq806x_gmac_probe()

Rajendra Nayak <rnayak@codeaurora.org>
    nvmem: qfprom: Fix up qfprom_disable_fuse_blowing() ordering

Georgi Djakov <georgi.djakov@linaro.org>
    arm64: dts: qcom: sm8250: Fix epss_l3 unit address

Vinod Koul <vkoul@kernel.org>
    arm64: dts: qcom: msm8996: don't use underscore in node name

Vinod Koul <vkoul@kernel.org>
    arm64: dts: qcom: msm8994: don't use underscore in node name

Vinod Koul <vkoul@kernel.org>
    arm64: dts: qcom: sdm630: don't use underscore in node name

Vinod Koul <vkoul@kernel.org>
    arm64: dts: qcom: ipq6018: drop '0x' from unit address

Vinod Koul <vkoul@kernel.org>
    arm64: dts: qcom: sdm660: use reg value for memory node

Vinod Koul <vkoul@kernel.org>
    arm64: dts: qcom: ipq8074: fix pci node reg property

Sebastian Reichel <sebastian.reichel@collabora.com>
    ARM: dts: imx53-ppd: Fix ACHC entry

Tony Lindgren <tony@atomide.com>
    serial: 8250_omap: Handle optional overrun-throttle-ms property

Alex Elder <elder@linaro.org>
    net: ipa: fix IPA v4.9 interconnects

AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
    arm64: dts: qcom: sdm630: Fix TLMM node and pinctrl configuration

AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
    arm64: dts: qcom: sdm630: Rewrite memory map

Bob Peterson <rpeterso@redhat.com>
    gfs2: Fix glock recursion in freeze_go_xmote_bh

Evgeny Novikov <novikov@ispras.ru>
    media: tegra-cec: Handle errors of clk_prepare_enable()

Krzysztof Hałasa <khalasa@piap.pl>
    media: TDA1997x: fix tda1997x_query_dv_timings() return value

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: v4l2-dv-timings.c: fix wrong condition in two for-loops

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: imx: imx7-media-csi: Fix buffer return upon stream start failure

Umang Jain <umang.jain@ideasonboard.com>
    media: imx258: Limit the max analogue gain to 480

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: imx258: Rectify mismatch of VTS value

Ioana Ciornei <ioana.ciornei@nxp.com>
    dpaa2-switch: do not enable the DPSW at probe time

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Fix not generating RPA when required

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: update sof_pcm512x quirks

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Move "Platform Clock" routes to the maps for the matching in-/output

Vidya Sagar <vidyas@nvidia.com>
    arm64: tegra: Fix Tegra194 PCIe EP compatible string

Nicolas Ferre <nicolas.ferre@microchip.com>
    ARM: dts: at91: use the right property for shutdown controller

Yufeng Mo <moyufeng@huawei.com>
    bonding: 3ad: fix the concurrency between __bond_release_one() and bond_3ad_state_machine_handler()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_compat: use nfnetlink_unicast()

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Update AV96 adv7513 node per dtbs_check

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Set {bitclock,frame}-master phandles on ST DKx

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Set {bitclock,frame}-master phandles on DHCOM SoM

Zhen Lei <thunder.leizhen@huawei.com>
    workqueue: Fix possible memory leaks in wq_numa_init()

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    Bluetooth: skip invalid hci_sync_conn_complete_evt

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    drm: rcar-du: Shutdown the display on system shutdown

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ata: sata_dwc_460ex: No need to call phy_exit() befre phy_init()

Martynas Pumputis <m@lambda.lt>
    libbpf: Fix race when pinning maps in parallel

Juhee Kang <claudiajkang@gmail.com>
    samples: bpf: Fix tracex7 error raised on the missing argument

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    staging: ks7010: Fix the initialization of the 'sleep_status' structure

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    serial: 8250_pci: make setup_port() parameters explicitly unsigned

Jiri Slaby <jirislaby@kernel.org>
    hvsi: don't panic on tty_register_driver failure

Jiri Slaby <jirislaby@kernel.org>
    xtensa: ISS: don't panic in rs_init

Maciej W. Rozycki <macro@orcam.me.uk>
    serial: 8250: Define RX trigger levels for OxSemi 950 devices

Niklas Schnelle <schnelle@linux.ibm.com>
    s390: make PCI mio support a machine flag

Heiko Carstens <hca@linux.ibm.com>
    s390/jump_label: print real address in a case of a jump label bug

Gustavo A. R. Silva <gustavoars@kernel.org>
    flow_dissector: Fix out-of-bounds warnings

Gustavo A. R. Silva <gustavoars@kernel.org>
    ipv4: ip_output.c: Fix out-of-bounds warning in ip_copy_addrs()

Alex Elder <elder@linaro.org>
    net: ipa: fix ipa_cmd_table_valid()

Zheyu Ma <zheyuma97@gmail.com>
    video: fbdev: riva: Error out if 'pixclock' equals zero

Zheyu Ma <zheyuma97@gmail.com>
    video: fbdev: kyro: Error out if 'pixclock' equals zero

Zheyu Ma <zheyuma97@gmail.com>
    video: fbdev: asiliantfb: Error out if 'pixclock' equals zero

Jernej Skrabec <jernej.skrabec@gmail.com>
    arm64: dts: allwinner: h6: tanix-tx6: Fix regulator node names

Geert Uytterhoeven <geert+renesas@glider.be>
    drm/bridge: nwl-dsi: Avoid potential multiplication overflow on 32-bit

Johan Almbladh <johan.almbladh@anyfinetworks.com>
    bpf/tests: Do not PASS tests without actually testing the result

Johan Almbladh <johan.almbladh@anyfinetworks.com>
    bpf/tests: Fix copy-and-paste error in double word test

Anson Jacob <Anson.Jacob@amd.com>
    drm/amd/amdgpu: Update debugfs link_settings output link_rate field in hex

Oak Zeng <Oak.Zeng@amd.com>
    drm/amdgpu: Fix a printing message

Arnd Bergmann <arnd@arndb.de>
    ethtool: improve compat ioctl handling

Niklas Söderlund <niklas.soderlund@corigine.com>
    nfp: fix return statement in nfp_net_parse_meta()

Yang Yingliang <yangyingliang@huawei.com>
    media: atomisp: pci: fix error return code in atomisp_pci_probe()

Dinghao Liu <dinghao.liu@zju.edu.cn>
    media: atomisp: Fix runtime PM imbalance in atomisp_pci_probe

Evgeny Novikov <novikov@ispras.ru>
    media: platform: stm32: unprepare clocks at handling errors in probe

Ezequiel Garcia <ezequiel@collabora.com>
    media: hantro: vp8: Move noisy WARN_ON to vpu_debug

Oliver Logush <oliver.logush@amd.com>
    drm/amd/display: Fix timer_per_pixel unit error

Shuah Khan <skhan@linuxfoundation.org>
    selftests: firmware: Fix ignored return val of asprintf() warn

Eric Auger <eric.auger@redhat.com>
    misc/pvpanic-pci: Allow automatic loading

Laurentiu Tudor <laurentiu.tudor@nxp.com>
    bus: fsl-mc: fix mmio base address for child DPRCs

Laurentiu Tudor <laurentiu.tudor@nxp.com>
    bus: fsl-mc: fix arg in call to dprc_scan_objects()

Zheyu Ma <zheyuma97@gmail.com>
    tty: serial: jsm: hold port lock when reporting modem line changes

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    staging: hisilicon,hi6421-spmi-pmic.yaml: fix patternProperties

Geert Uytterhoeven <geert+renesas@glider.be>
    staging: board: Fix uninitialized spinlock when attaching genpd

Jack Pham <jackp@codeaurora.org>
    usb: gadget: composite: Allow bMaxPower=0 if self-powered

Evgeny Novikov <novikov@ispras.ru>
    USB: EHCI: ehci-mv: improve error handling in mv_ehci_enable()

Maciej Żenczykowski <maze@google.com>
    usb: gadget: u_ether: fix a potential null pointer dereference

Kelly Devilliv <kelly.devilliv@gmail.com>
    usb: host: fotg210: fix the actual_length of an iso packet

Kelly Devilliv <kelly.devilliv@gmail.com>
    usb: host: fotg210: fix the endpoint's transactional opportunities calculation

Sasha Neftin <sasha.neftin@intel.com>
    igc: Check if num of q_vectors is smaller than max before array access

Zhouyi Zhou <zhouzhouyi@gmail.com>
    rcu: Fix macro name CONFIG_TASKS_RCU_TRACE

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    drm: protect drm_master pointers in drm_lease.c

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    drm: serialize drm_file.master with a new spinlock

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    drm: avoid blocking in drm_clients_info's rcu section

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    Smack: Fix wrong semantics in smk_access_entry()

Alex Elder <elder@linaro.org>
    net: ipa: fix IPA v4.11 interconnect data

Yajun Deng <yajun.deng@linux.dev>
    netlink: Deal with ESRCH error in nlmsg_notify()

KuoHsiang Chou <kuohsiang_chou@aspeedtech.com>
    drm/ast: Disable fast reset after DRAM initial

Zheyu Ma <zheyuma97@gmail.com>
    video: fbdev: kyro: fix a DoS bug by restricting user input

David Heidelberg <david@ixit.cz>
    ARM: dts: qcom: apq8064: correct clock names

Stefan Assmann <sassmann@kpanic.de>
    iavf: fix locking of critical sections

Stefan Assmann <sassmann@kpanic.de>
    iavf: do not override the adapter state in the watchdog task

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: dac: ad5624r: Fix incorrect handling of an optional regulator.

Marek Vasut <marex@denx.de>
    net: phy: Fix data type in DP83822 dp8382x_disable_wol()

Xin Long <lucien.xin@gmail.com>
    tipc: keep the skb in rcv queue until the whole data is read

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI: Use pci_update_current_state() in pci_enable_device_flags()

Sean Anderson <sean.anderson@seco.com>
    crypto: mxs-dcp - Use sg_mapping_iter to copy data

Ani Sinha <ani@anisinha.ca>
    x86/hyperv: fix for unwanted manipulation of sched_clock when TSC marked unstable

Thomas Zimmermann <tzimmermann@suse.de>
    drm/vkms: Let shadow-plane helpers prepare the plane's FB

Martynas Pumputis <m@lambda.lt>
    libbpf: Fix reuse of pinned map on older kernel

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    media: ti-vpe: cal: fix queuing of the initial buffer

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    media: ti-vpe: cal: fix error handling in cal_camerarx_create

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: dib8000: rewrite the init prbs logic

Randy Dunlap <rdunlap@infradead.org>
    ASoC: atmel: ATMEL drivers don't need HAS_DMA

Peter Ujfalusi <peter.ujfalusi@gmail.com>
    ASoC: ti: davinci-mcasp: Fix DIT mode support

Luben Tuikov <luben.tuikov@amd.com>
    drm/amdgpu: Fix amdgpu_ras_eeprom_init()

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/omap: Follow implicit fencing in prepare_fb

Dom Cobley <popcornmix@gmail.com>
    drm/vc4: hdmi: Set HD_CTL_WHOLSMP and HD_CTL_CHALIGN_SET

Zack Rusin <zackr@vmware.com>
    drm/vmwgfx: Fix some static checker warnings

Zack Rusin <zackr@vmware.com>
    drm/vmwgfx: Fix subresource updates with new contexts

Nadav Amit <namit@vmware.com>
    userfaultfd: prevent concurrent API initialization

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: Fix 'no symbols' warning when CONFIG_TRIM_UNUSD_KSYMS=y

Oleksij Rempel <linux@rempel-privat.de>
    MIPS: Malta: fix alignment of the devicetree buffer

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: should put a page beyond EOF when preparing a write

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: deallocate compressed pages when error happens

Chao Yu <chao@kernel.org>
    f2fs: fix to unmap pages from userspace process in punch_hole()

Chao Yu <chao@kernel.org>
    f2fs: fix unexpected ENOENT comes from f2fs_map_blocks()

Chao Yu <chao@kernel.org>
    f2fs: fix to account missing .skipped_gc_rwsem

Yongqiang Niu <yongqiang.niu@mediatek.com>
    soc: mediatek: cmdq: add address shift in jump

Alexey Kardashevskiy <aik@ozlabs.ru>
    KVM: PPC: Fix clearing never mapped TCEs in realmode

Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
    clk: at91: clk-generated: Limit the requested rate to our range

Sergio Paracuellos <sergio.paracuellos@gmail.com>
    clk: ralink: avoid to set 'CLK_IS_CRITICAL' flag for gates

David Howells <dhowells@redhat.com>
    fscache: Fix cookie key hashing

Wenpeng Liang <liangwenpeng@huawei.com>
    RDMA/hns: Fix QP's resp incomplete assignment

Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    powerpc/smp: Update cpu_core_map on all PowerPc systems

Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    powerpc/smp: Fix a crash while booting kvm guest with nr_cpus=2

Hans de Goede <hdegoede@redhat.com>
    platform/x86: dell-smbios-wmi: Add missing kfree in error-exit from run_smbios_call

Junxian Huang <huangjunxian4@hisilicon.com>
    RDMA/hns: Bugfix for the missing assignment for dip_idx

Junxian Huang <huangjunxian4@hisilicon.com>
    RDMA/hns: Bugfix for data type of dip_idx

Kajol Jain <kjain@linux.ibm.com>
    powerpc/perf: Fix the check for SIAR value

Nicholas Piggin <npiggin@gmail.com>
    KVM: PPC: Book3S HV Nested: Reflect guest PMU in-use to L0 when guest SPRs are live

Alim Akhtar <alim.akhtar@samsung.com>
    scsi: ufs: ufs-exynos: Fix static checker warning

Fabiano Rosas <farosas@linux.ibm.com>
    KVM: PPC: Book3S HV: Fix copy_tofrom_guest routines

Ahmad Fatoum <a.fatoum@pengutronix.de>
    clk: imx8m: fix clock tree update of TF-A managed clocks

Lucas Stach <l.stach@pengutronix.de>
    clk: imx8mm: use correct mux type for clkout path

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    HID: thrustmaster: clean up Makefile and adapt quirks

Jim Broadus <jbroadus@gmail.com>
    HID: i2c-hid: Fix Elan touchpad regression

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Fix period data field to enable sensor

YueHaibing <yuehaibing@huawei.com>
    RDMA/hns: Fix return in hns_roce_rereg_user_mr()

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Update the virtual command related registers

Chao Yu <chao@kernel.org>
    f2fs: fix to keep compatibility of fault injection interface

Joel Stanley <joel@jms.id.au>
    powerpc/config: Renable MTD_PHYSMAP_OF

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: qedf: Fix error codes in qedf_alloc_global_queues()

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: qedi: Fix error codes in qedi_alloc_global_queues()

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: smartpqi: Fix an error code in pqi_get_raid_map()

Laurent Dufour <ldufour@linux.ibm.com>
    powerpc/numa: Consider the max NUMA node for migratable LPAR

Zhen Lei <thunder.leizhen@huawei.com>
    pinctrl: single: Fix error return code in pcs_parse_bits_in_pinctrl_entry()

Wei Li <liwei391@huawei.com>
    scsi: fdomain: Fix error return code in fdomain_probe()

Anna Schumaker <Anna.Schumaker@Netapp.com>
    sunrpc: Fix return value of get_srcport()

Olga Kornievskaia <kolga@netapp.com>
    SUNRPC query transport's source port

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC/xprtrdma: Fix reconnection locking

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Fix potential memory corruption

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4/pnfs: The layout barrier indicate a minimal value for the seqid

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4/pNFS: Always allow update of a zero valued layout barrier

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4/pNFS: Fix a layoutget livelock loop

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Put rpcrdma_reps before waking the tear-down completion

Anthony Iliopoulos <ailiop@suse.com>
    dma-debug: fix debugfs initialization order

Randy Dunlap <rdunlap@infradead.org>
    openrisc: don't printk() unconditionally

Yangtao Li <frank.li@vivo.com>
    f2fs: reduce the scope of setting fsck tag when de->name_len is zero

Nathan Chancellor <nathan@kernel.org>
    cpuidle: pseries: Mark pseries_idle_proble() as __init

Leon Romanovsky <leon@kernel.org>
    RDMA/mlx5: Delete not-available udata check

Leon Romanovsky <leon@kernel.org>
    RDMA/efa: Remove double QP type assignment

Leon Romanovsky <leon@kernel.org>
    RDMA/hns: Don't overwrite supplied QP attributes

Michal Suchanek <msuchanek@suse.de>
    powerpc/stacktrace: Include linux/delay.h

Gautham R. Shenoy <ego@linux.vnet.ibm.com>
    cpuidle: pseries: Fixup CEDE0 latency only for POWER10 onwards

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: Fix memory corruption by ufshcd_read_desc_param()

Jason Gunthorpe <jgg@ziepe.ca>
    vfio: Use config not menuconfig for VFIO_NOIOMMU

Chao Yu <chao@kernel.org>
    f2fs: fix wrong checkpoint_changed value in f2fs_remount()

Chao Yu <chao@kernel.org>
    f2fs: compress: add compress_inode to cache compressed blocks

Chao Yu <chao@kernel.org>
    f2fs: restructure f2fs page.private layout

Jaehyoung Choi <jkkkkk.choi@samsung.com>
    pinctrl: samsung: Fix pinctrl bank pin count

Colin Ian King <colin.king@canonical.com>
    scsi: BusLogic: Use %X for u32 sized integer rather than %lX

Leon Romanovsky <leon@kernel.org>
    docs: Fix infiniband uverbs minor number

Leon Romanovsky <leon@kernel.org>
    RDMA/iwcm: Release resources if iw_cm module initialization fails

Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
    IB/hfi1: Adjust pkey entry in index 0

Peter Geis <pgwipeout@gmail.com>
    clk: rockchip: drop GRF dependency for rk3328/rk3036 pll types

Christoph Hellwig <hch@lst.de>
    scsi: bsg: Remove support for SCSI_IOCTL_SEND_COMMAND

Marek Behún <kabel@kernel.org>
    pinctrl: armada-37xx: Correct PWM pins definitions

Chao Yu <chao@kernel.org>
    f2fs: quota: fix potential deadlock

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: input: do not report stylus battery state as "full"

Chao Yu <chao@kernel.org>
    f2fs: compress: fix to set zstd compress level correctly

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix masking and unmasking legacy INTx interrupts

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Increase polling delay to 1.5s while waiting for PIO response

Evan Wang <xswang@marvell.com>
    PCI: aardvark: Fix checking for PIO status

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Configure PCIe resources from 'ranges' DT property

Hyun Kwon <hyun.kwon@xilinx.com>
    PCI: xilinx-nwl: Enable the clock through CCF

Krzysztof Wilczyński <kw@linux.com>
    PCI: Return ~0 data on pciconfig_read() CAP_SYS_ADMIN failure

Marek Behún <kabel@kernel.org>
    PCI: Restrict ASMedia ASM1062 SATA Max Payload Size Supported

Stuart Hayes <stuart.w.hayes@gmail.com>
    PCI/portdrv: Enable Bandwidth Notification only if port supports it

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check for sb/cp fields correctly

David Heidelberg <david@ixit.cz>
    ARM: 9105/1: atags_to_fdt: don't warn about stack size

Hans de Goede <hdegoede@redhat.com>
    libata: add ATA_HORKAGE_NO_NCQ_TRIM for Samsung 860 and 870 SSDs

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fail links of cancelled timeouts

Jens Axboe <axboe@kernel.dk>
    io-wq: fix race between adding work and activating a free worker

Jens Axboe <axboe@kernel.dk>
    io-wq: fix wakeup race when adding new work

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix io_try_cancel_userdata race for iowq

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: add ->splice_fd_in checks

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: place fixed tables under memcg limits

Robin Gong <yibin.gong@nxp.com>
    dmaengine: imx-sdma: remove duplicated sdma_load_context

Robin Gong <yibin.gong@nxp.com>
    Revert "dmaengine: imx-sdma: refine to load context only once"

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qdio: cancel the ESTABLISH ccw after timeout

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qdio: fix roll-back after timeout on ESTABLISH ccw

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    nvmem: core: fix error handling while validating keepout regions

Sean Young <sean@mess.org>
    media: rc-loopback: return number of emitters rather than error

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: uvc: don't do DMA on stack

Wang Hai <wanghai38@huawei.com>
    VMCI: fix NULL pointer dereference when unmapping queue pair

Eddie James <eajames@linux.ibm.com>
    spi: fsi: Reduce max transfer size to 8 bytes

Brijesh Singh <brijesh.singh@amd.com>
    crypto: ccp - shutdown SEV firmware on kexec

Arne Welzel <arne.welzel@corelight.com>
    dm crypt: Avoid percpu_counter spinlock contention in crypt_page_alloc()

Kevin Hao <haokexin@gmail.com>
    cpufreq: schedutil: Use kobject release() method to free sugov_tunables

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    power: supply: max17042: handle fails of reading status register

Damien Le Moal <damien.lemoal@wdc.com>
    block: bfq: fix bfq_set_next_ioprio_data()

zhenwei pi <pizhenwei@bytedance.com>
    crypto: public_key: fix overflow during implicit conversion

Joseph Gates <jgates@squareup.com>
    wcn36xx: Ensure finish scan is not requested before start scan

Nuno Sá <nuno.sa@analog.com>
    iio: ltc2983: fix device probe

Alexandru Elisei <alexandru.elisei@arm.com>
    arm64: Do not trap PMSNEVFR_EL1

Mark Rutland <mark.rutland@arm.com>
    arm64: head: avoid over-mapping in map_memory

Will Deacon <will@kernel.org>
    arm64: mm: Fix TLBI vs ASID rollover

Marc Zyngier <maz@kernel.org>
    arm64: Move .hyp.rodata outside of the _sdata.._edata range

Iwona Winiarska <iwona.winiarska@intel.com>
    soc: aspeed: p2a-ctrl: Fix boundary check for mmap

Iwona Winiarska <iwona.winiarska@intel.com>
    soc: aspeed: lpc-ctrl: Fix boundary check for mmap

Manivannan Sadhasivam <mani@kernel.org>
    soc: qcom: aoss: Fix the out of bound usage of cooling_devs

Enric Balletbo i Serra <enric.balletbo@collabora.com>
    soc: mediatek: mmsys: Fix missing UFOE component in mt8173 table routing

Paul Cercueil <paul@crapouillou.net>
    pinctrl: ingenic: Fix bias config for X2000(E)

Paul Cercueil <paul@crapouillou.net>
    pinctrl: ingenic: Fix incorrect pull up/down info

Marc Zyngier <maz@kernel.org>
    pinctrl: stmfx: Fix hazardous u8[] to unsigned long cast

Dinh Nguyen <dinguyen@kernel.org>
    clk: socfpga: agilex: add the bypass register for s2f_usr0 clock

Dinh Nguyen <dinguyen@kernel.org>
    clk: socfpga: agilex: fix up s2f_user0_clk representation

Dinh Nguyen <dinguyen@kernel.org>
    clk: socfpga: agilex: fix the parents of the psi_ref_clk

Rolf Eike Beer <eb@emlix.com>
    tools/thermal/tmon: Add cross compiling support

Steven Rostedt (VMware) <rostedt@goodmis.org>
    selftests/ftrace: Fix requirement check of README file

jingle.wu <jingle.wu@emc.com.tw>
    Input: elan_i2c - reduce the resume time for controller in Whitebox

Colin Ian King <colin.king@canonical.com>
    ceph: fix dereference of null pointer cf

Harshvardhan Jha <harshvardhan.jha@oracle.com>
    9p/xen: Fix end of loop tests for list_for_each_entry

Juergen Gross <jgross@suse.com>
    xen: fix setting of max_pfn in shared_info

Kajol Jain <kjain@linux.ibm.com>
    powerpc/perf/hv-gpci: Fix counter value parsing

Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
    PCI/MSI: Skip masking MSI-X on Xen PV

Niklas Cassel <niklas.cassel@wdc.com>
    blk-zoned: allow BLKREPORTZONE without CAP_SYS_ADMIN

Niklas Cassel <niklas.cassel@wdc.com>
    blk-zoned: allow zone management send operations without CAP_SYS_ADMIN

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: fix double counting of split ordered extent

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    btrfs: reset replace target device to allocation state on close

Anand Jain <anand.jain@oracle.com>
    btrfs: fix upper limit for max_inline for page size 64K

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: suppress reclaim error message on EAGAIN

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: fix block group alloc_offset calculation

Josef Bacik <josef@toxicpanda.com>
    btrfs: reduce the preemptive flushing threshold to 90%

Josef Bacik <josef@toxicpanda.com>
    btrfs: wait on async extents when flushing delalloc

Josef Bacik <josef@toxicpanda.com>
    btrfs: wake up async_delalloc_pages waiters after submit

Dmitry Osipenko <digetx@gmail.com>
    rtc: tps65910: Correct driver module alias


-------------

Diffstat:

 Documentation/admin-guide/devices.txt              |   6 +-
 .../pinctrl/marvell,armada-37xx-pinctrl.txt        |   8 +-
 Documentation/filesystems/f2fs.rst                 |   4 +
 Makefile                                           |   9 +-
 arch/arm/boot/compressed/Makefile                  |   2 +
 arch/arm/boot/dts/at91-kizbox3_common.dtsi         |   2 +-
 arch/arm/boot/dts/at91-sam9x60ek.dts               |   2 +-
 arch/arm/boot/dts/at91-sama5d27_som1_ek.dts        |   2 +-
 arch/arm/boot/dts/at91-sama5d27_wlsom1_ek.dts      |   2 +-
 arch/arm/boot/dts/at91-sama5d2_icp.dts             |   2 +-
 arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts          |   2 +-
 arch/arm/boot/dts/at91-sama5d2_xplained.dts        |   2 +-
 arch/arm/boot/dts/imx53-ppd.dts                    |  23 +-
 arch/arm/boot/dts/qcom-apq8064.dtsi                |   6 +-
 arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi      |   8 +-
 arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi |   6 +-
 arch/arm/boot/dts/stm32mp15xx-dkx.dtsi             |   8 +-
 arch/arm/boot/dts/tegra20-acer-a500-picasso.dts    |  25 +-
 arch/arm/boot/dts/tegra20-tamonten.dtsi            |  14 +-
 .../boot/dts/allwinner/sun50i-h6-tanix-tx6.dts     |   4 +-
 arch/arm64/boot/dts/freescale/fsl-ls1046a-frwy.dts |   8 +-
 arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts  |   7 +-
 .../boot/dts/freescale/imx8mm-venice-gw700x.dtsi   |  64 ++---
 .../boot/dts/freescale/imx8mm-venice-gw71xx.dtsi   |   5 +-
 arch/arm64/boot/dts/nvidia/tegra132.dtsi           |   4 +-
 arch/arm64/boot/dts/nvidia/tegra194.dtsi           |   6 +-
 arch/arm64/boot/dts/qcom/ipq6018.dtsi              |   2 +-
 arch/arm64/boot/dts/qcom/ipq8074-hk01.dts          |   2 +-
 arch/arm64/boot/dts/qcom/ipq8074.dtsi              |  16 +-
 arch/arm64/boot/dts/qcom/msm8994.dtsi              |   6 +-
 arch/arm64/boot/dts/qcom/msm8996.dtsi              |   4 +-
 arch/arm64/boot/dts/qcom/sdm630.dtsi               | 257 ++++++++++++--------
 arch/arm64/boot/dts/qcom/sm8250.dtsi               |   2 +-
 arch/arm64/include/asm/el2_setup.h                 |  13 +-
 arch/arm64/include/asm/kernel-pgtable.h            |   4 +-
 arch/arm64/include/asm/mmu.h                       |  29 ++-
 arch/arm64/include/asm/tlbflush.h                  |  11 +-
 arch/arm64/kernel/head.S                           |  11 +-
 arch/arm64/kernel/vmlinux.lds.S                    |   4 +-
 arch/arm64/kvm/arch_timer.c                        |   8 +-
 arch/arm64/kvm/vgic/vgic.c                         |  14 +-
 arch/m68k/Kconfig.bus                              |   2 +-
 arch/mips/mti-malta/malta-dtshim.c                 |   2 +-
 arch/openrisc/kernel/entry.S                       |   2 +
 arch/parisc/Makefile                               |   6 +-
 arch/parisc/kernel/signal.c                        |   6 +
 arch/powerpc/configs/mpc885_ads_defconfig          |   1 +
 arch/powerpc/include/asm/pmc.h                     |   7 +
 arch/powerpc/kernel/smp.c                          |  13 +-
 arch/powerpc/kernel/stacktrace.c                   |   1 +
 arch/powerpc/kvm/book3s_64_mmu_radix.c             |   6 +-
 arch/powerpc/kvm/book3s_64_vio_hv.c                |   9 +-
 arch/powerpc/kvm/book3s_hv.c                       |  20 ++
 arch/powerpc/mm/numa.c                             |  13 +-
 arch/powerpc/perf/core-book3s.c                    |  12 +-
 arch/powerpc/perf/hv-gpci.c                        |   2 +-
 arch/s390/include/asm/setup.h                      |   2 +
 arch/s390/include/asm/smp.h                        |   1 +
 arch/s390/kernel/early.c                           |   4 +
 arch/s390/kernel/jump_label.c                      |   2 +-
 arch/s390/kernel/smp.c                             |   9 +-
 arch/s390/kernel/topology.c                        |  13 +-
 arch/s390/mm/init.c                                |   2 +-
 arch/s390/pci/pci.c                                |   5 +-
 arch/x86/kernel/cpu/mshyperv.c                     |   9 +-
 arch/x86/xen/p2m.c                                 |   4 +-
 arch/xtensa/platforms/iss/console.c                |  17 +-
 block/bfq-iosched.c                                |   2 +-
 block/blk-zoned.c                                  |   6 -
 block/bsg.c                                        |   5 +-
 drivers/ata/libata-core.c                          |   4 +
 drivers/ata/sata_dwc_460ex.c                       |  12 +-
 drivers/bus/fsl-mc/fsl-mc-bus.c                    |  26 +-
 drivers/clk/at91/clk-generated.c                   |   6 +
 drivers/clk/imx/clk-composite-8m.c                 |   3 +-
 drivers/clk/imx/clk-imx8mm.c                       |  11 +-
 drivers/clk/imx/clk-imx8mn.c                       |   7 +-
 drivers/clk/imx/clk-imx8mq.c                       |   7 +-
 drivers/clk/imx/clk.h                              |  16 +-
 drivers/clk/ralink/clk-mt7621.c                    |   9 +-
 drivers/clk/rockchip/clk-pll.c                     |   2 +-
 drivers/clk/socfpga/clk-agilex.c                   |  19 +-
 drivers/cpufreq/powernv-cpufreq.c                  |  16 +-
 drivers/cpuidle/cpuidle-pseries.c                  |  18 +-
 drivers/crypto/ccp/sev-dev.c                       |  49 ++--
 drivers/crypto/ccp/sp-pci.c                        |  12 +
 drivers/crypto/mxs-dcp.c                           |  36 +--
 drivers/dma/imx-sdma.c                             |  13 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c            |  23 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c     |   2 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c              |   2 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c              |   2 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c              |   2 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c              |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c       |  84 +++++--
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h       |   1 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   2 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  |  16 +-
 .../drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c  |  11 +-
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |  14 +-
 .../gpu/drm/amd/display/dc/dcn20/dcn20_resource.c  |   2 +-
 .../gpu/drm/amd/display/dc/dcn30/dcn30_dwb_cm.c    |  90 +++++--
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c |  12 +-
 .../gpu/drm/amd/display/dc/dcn30/dcn30_resource.c  |  42 +++-
 drivers/gpu/drm/ast/ast_drv.h                      |   6 +
 drivers/gpu/drm/ast/ast_main.c                     |   5 +
 drivers/gpu/drm/ast/ast_post.c                     |  91 +++++--
 drivers/gpu/drm/bridge/nwl-dsi.c                   |   2 +-
 drivers/gpu/drm/drm_auth.c                         |  42 +++-
 drivers/gpu/drm/drm_debugfs.c                      |   3 +-
 drivers/gpu/drm/drm_dp_mst_topology.c              |  10 +-
 drivers/gpu/drm/drm_file.c                         |   1 +
 drivers/gpu/drm/drm_lease.c                        |  81 +++++--
 drivers/gpu/drm/exynos/exynos_drm_dma.c            |   2 +
 drivers/gpu/drm/mgag200/mgag200_drv.h              |  16 ++
 drivers/gpu/drm/mgag200/mgag200_mode.c             |  20 +-
 drivers/gpu/drm/mgag200/mgag200_reg.h              |   9 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c     |   5 +
 drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c           |  17 +-
 drivers/gpu/drm/msm/dp/dp_ctrl.c                   | 134 +++++++----
 drivers/gpu/drm/msm/dp/dp_panel.c                  |   9 +-
 drivers/gpu/drm/msm/dsi/dsi_cfg.c                  |   1 -
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c         |   2 +-
 drivers/gpu/drm/omapdrm/omap_plane.c               |   3 +
 drivers/gpu/drm/panfrost/panfrost_device.h         |   8 +-
 drivers/gpu/drm/panfrost/panfrost_drv.c            |  50 +---
 drivers/gpu/drm/panfrost/panfrost_gem.c            |  20 +-
 drivers/gpu/drm/panfrost/panfrost_job.c            |   4 +-
 drivers/gpu/drm/panfrost/panfrost_mmu.c            | 191 +++++++++------
 drivers/gpu/drm/panfrost/panfrost_mmu.h            |   5 +-
 drivers/gpu/drm/panfrost/panfrost_regs.h           |   2 +
 drivers/gpu/drm/rcar-du/rcar_du_drv.c              |   8 +
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |   4 +-
 drivers/gpu/drm/vkms/vkms_plane.c                  |  38 +--
 drivers/gpu/drm/vmwgfx/ttm_memory.c                |   2 +
 drivers/gpu/drm/vmwgfx/vmwgfx_binding.c            |  20 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf.c             |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c         |   4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |   2 +
 drivers/gpu/drm/vmwgfx/vmwgfx_mob.c                |   4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_msg.c                |   6 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c           |   8 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_so.c                 |   3 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c            |   9 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_validation.c         |   4 +-
 drivers/gpu/drm/xlnx/zynqmp_disp.c                 |   3 +-
 drivers/gpu/drm/xlnx/zynqmp_dp.c                   |  22 +-
 drivers/hid/Makefile                               |   1 -
 drivers/hid/amd-sfh-hid/amd_sfh_client.c           |   2 +-
 drivers/hid/hid-input.c                            |   2 -
 drivers/hid/hid-quirks.c                           |   2 -
 drivers/hid/i2c-hid/i2c-hid-core.c                 |   5 +-
 drivers/hwmon/pmbus/ibm-cffps.c                    |   6 +-
 drivers/iio/dac/ad5624r_spi.c                      |  18 +-
 drivers/iio/temperature/ltc2983.c                  |  30 ++-
 drivers/infiniband/core/iwcm.c                     |  19 +-
 drivers/infiniband/hw/efa/efa_verbs.c              |   1 -
 drivers/infiniband/hw/hfi1/init.c                  |   7 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   4 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |   2 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c            |   4 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |  11 +-
 drivers/infiniband/hw/mlx5/qp.c                    |   3 -
 drivers/input/mouse/elan_i2c.h                     |   3 +-
 drivers/input/mouse/elan_i2c_core.c                |   1 +
 drivers/iommu/intel/pasid.h                        |  10 +-
 drivers/mailbox/mtk-cmdq-mailbox.c                 |   3 +-
 drivers/md/dm-crypt.c                              |   7 +-
 drivers/media/cec/platform/stm32/stm32-cec.c       |  26 +-
 drivers/media/cec/platform/tegra/tegra_cec.c       |  10 +-
 drivers/media/dvb-frontends/dib8000.c              |  58 +++--
 drivers/media/i2c/imx258.c                         |   4 +-
 drivers/media/i2c/tda1997x.c                       |   5 +-
 drivers/media/platform/ti-vpe/cal-camerarx.c       |   4 +-
 drivers/media/platform/ti-vpe/cal-video.c          |   2 +-
 drivers/media/rc/rc-loopback.c                     |   2 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |  34 ++-
 drivers/media/v4l2-core/v4l2-dv-timings.c          |   4 +-
 drivers/misc/pvpanic/pvpanic-pci.c                 |   2 +
 drivers/misc/vmw_vmci/vmci_queue_pair.c            |   6 +-
 drivers/mmc/core/block.c                           |   3 +-
 drivers/mmc/host/rtsx_pci_sdmmc.c                  |  36 ++-
 drivers/mmc/host/sdhci-of-arasan.c                 |  36 ++-
 drivers/mtd/nand/raw/intel-nand-controller.c       |  27 ++-
 drivers/net/bonding/bond_main.c                    |   3 +-
 drivers/net/dsa/lantiq_gswip.c                     |   3 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |   6 -
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   9 +-
 drivers/net/ethernet/intel/iavf/iavf.h             |   9 +-
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c     |  10 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        | 122 ++++++----
 drivers/net/ethernet/intel/igc/igc_main.c          |   9 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  15 ++
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   8 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |   2 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |   1 +
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |   2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-ipq806x.c    |  18 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  10 +-
 drivers/net/ethernet/wiznet/w5100.c                |   2 +
 drivers/net/ipa/ipa_cmd.c                          |  38 ++-
 drivers/net/ipa/ipa_cmd.h                          |  15 +-
 drivers/net/ipa/ipa_data-v4.11.c                   |  13 +-
 drivers/net/ipa/ipa_data-v4.9.c                    |   9 +-
 drivers/net/ipa/ipa_table.c                        |   2 +-
 drivers/net/phy/dp83822.c                          |   8 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |   3 +-
 drivers/net/wireless/ath/ath9k/hw.c                |  12 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |   5 +-
 drivers/net/wireless/ath/wcn36xx/txrx.c            |   4 +
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h         |   1 +
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |   6 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  24 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |  11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  30 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |   5 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   3 +
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |   2 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  33 ++-
 drivers/net/wireless/realtek/rtw88/Makefile        |   2 +-
 drivers/net/wireless/realtek/rtw88/fw.c            |   8 +-
 drivers/net/wireless/realtek/rtw88/fw.h            |   1 +
 drivers/net/wireless/realtek/rtw88/wow.c           |  21 +-
 drivers/nvdimm/pmem.c                              |   4 +-
 drivers/nvme/host/core.c                           |   3 +-
 drivers/nvme/host/nvme.h                           |  47 +++-
 drivers/nvme/host/pci.c                            |   2 +-
 drivers/nvme/host/rdma.c                           |   4 +-
 drivers/nvme/host/tcp.c                            |  38 ++-
 drivers/nvme/target/loop.c                         |   4 +-
 drivers/nvmem/core.c                               |   7 +-
 drivers/nvmem/qfprom.c                             |   6 +-
 drivers/of/kobj.c                                  |   2 +-
 drivers/opp/of.c                                   |  12 +-
 drivers/parport/ieee1284_ops.c                     |   2 +-
 drivers/pci/controller/pci-aardvark.c              | 268 ++++++++++++++++++++-
 drivers/pci/controller/pcie-xilinx-nwl.c           |  12 +
 drivers/pci/msi.c                                  |   3 +
 drivers/pci/pci.c                                  |   6 +-
 drivers/pci/pcie/portdrv_core.c                    |   9 +-
 drivers/pci/quirks.c                               |   1 +
 drivers/pci/syscall.c                              |   4 +-
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c        |  16 +-
 drivers/pinctrl/pinctrl-ingenic.c                  |  12 +-
 drivers/pinctrl/pinctrl-single.c                   |   1 +
 drivers/pinctrl/pinctrl-stmfx.c                    |   6 +-
 drivers/pinctrl/samsung/pinctrl-samsung.c          |   2 +-
 drivers/platform/chrome/cros_ec_proto.c            |   9 +
 drivers/platform/x86/dell/dell-smbios-wmi.c        |   1 +
 drivers/power/supply/max17042_battery.c            |   6 +-
 drivers/rtc/rtc-tps65910.c                         |   2 +-
 drivers/s390/cio/qdio_main.c                       |  82 ++++---
 drivers/scsi/BusLogic.c                            |   6 +-
 drivers/scsi/pcmcia/fdomain_cs.c                   |   4 +-
 drivers/scsi/qedf/qedf_main.c                      |  10 +-
 drivers/scsi/qedi/qedi_main.c                      |  14 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |   5 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   6 +
 drivers/scsi/smartpqi/smartpqi_init.c              |   1 +
 drivers/scsi/ufs/ufs-exynos.c                      |   4 +-
 drivers/scsi/ufs/ufs-exynos.h                      |   2 +-
 drivers/scsi/ufs/ufshcd.c                          |   8 +-
 drivers/soc/aspeed/aspeed-lpc-ctrl.c               |   2 +-
 drivers/soc/aspeed/aspeed-p2a-ctrl.c               |   2 +-
 drivers/soc/mediatek/mtk-mmsys.h                   |   4 +
 drivers/soc/qcom/qcom_aoss.c                       |   8 +-
 drivers/soundwire/intel.c                          |  23 +-
 drivers/spi/spi-fsi.c                              | 125 ++--------
 drivers/staging/board/board.c                      |   7 +-
 .../hikey9xx/hisilicon,hi6421-spmi-pmic.yaml       |   6 +-
 drivers/staging/ks7010/ks7010_sdio.c               |   2 +-
 drivers/staging/media/atomisp/pci/atomisp_v4l2.c   |   4 +-
 drivers/staging/media/hantro/hantro_g1_vp8_dec.c   |  13 +-
 .../staging/media/hantro/rk3399_vpu_hw_vp8_dec.c   |  13 +-
 drivers/staging/media/imx/imx7-media-csi.c         |  15 +-
 drivers/staging/rtl8723bs/hal/hal_com_phycfg.c     |   2 +-
 drivers/staging/rts5208/rtsx_scsi.c                |  10 +-
 drivers/thunderbolt/switch.c                       |   2 +-
 drivers/tty/hvc/hvsi.c                             |  19 +-
 drivers/tty/serial/8250/8250_omap.c                |  25 +-
 drivers/tty/serial/8250/8250_pci.c                 |   2 +-
 drivers/tty/serial/8250/8250_port.c                |   3 +-
 drivers/tty/serial/jsm/jsm_neo.c                   |   2 +
 drivers/tty/serial/jsm/jsm_tty.c                   |   3 +
 drivers/tty/serial/sh-sci.c                        |   7 +-
 drivers/usb/chipidea/host.c                        |  14 +-
 drivers/usb/dwc3/dwc3-imx8mp.c                     |  14 +-
 drivers/usb/gadget/composite.c                     |   8 +-
 drivers/usb/gadget/function/u_ether.c              |   5 +-
 drivers/usb/host/ehci-mv.c                         |  23 +-
 drivers/usb/host/fotg210-hcd.c                     |  41 ++--
 drivers/usb/host/fotg210.h                         |   5 -
 drivers/usb/host/xhci-mtk.c                        |   2 +-
 drivers/usb/host/xhci.c                            |  24 +-
 drivers/usb/musb/musb_dsps.c                       |  13 +-
 drivers/usb/usbip/vhci_hcd.c                       |  32 ++-
 drivers/vfio/Kconfig                               |   2 +-
 drivers/video/fbdev/asiliantfb.c                   |   3 +
 drivers/video/fbdev/kyro/fbdev.c                   |   8 +
 drivers/video/fbdev/riva/fbdev.c                   |   3 +
 fs/btrfs/block-group.c                             |   2 +-
 fs/btrfs/disk-io.c                                 |  48 ++--
 fs/btrfs/free-space-cache.c                        |   7 +-
 fs/btrfs/inode.c                                   |  26 +-
 fs/btrfs/ordered-data.c                            |   8 +
 fs/btrfs/space-info.c                              |  42 +++-
 fs/btrfs/tree-log.c                                |   4 +-
 fs/btrfs/volumes.c                                 |   3 +
 fs/ceph/caps.c                                     |   3 +
 fs/cifs/sess.c                                     |   2 +-
 fs/f2fs/checkpoint.c                               |   4 +-
 fs/f2fs/compress.c                                 | 190 +++++++++++++--
 fs/f2fs/data.c                                     | 122 +++++++---
 fs/f2fs/debug.c                                    |  13 +
 fs/f2fs/dir.c                                      |  22 +-
 fs/f2fs/f2fs.h                                     | 173 +++++++++++--
 fs/f2fs/file.c                                     |   4 +-
 fs/f2fs/gc.c                                       |  11 +-
 fs/f2fs/inline.c                                   |   4 +-
 fs/f2fs/inode.c                                    |  23 +-
 fs/f2fs/node.c                                     |  24 +-
 fs/f2fs/node.h                                     |  30 +--
 fs/f2fs/segment.c                                  |  25 +-
 fs/f2fs/super.c                                    | 148 ++++++++----
 fs/fscache/cookie.c                                |  14 +-
 fs/fscache/internal.h                              |   2 +
 fs/fscache/main.c                                  |  39 +++
 fs/gfs2/glops.c                                    |  17 +-
 fs/gfs2/lock_dlm.c                                 |   5 +
 fs/io-wq.c                                         |  50 ++--
 fs/io_uring.c                                      |  65 ++---
 fs/iomap/buffered-io.c                             |   2 +-
 fs/lockd/svclock.c                                 |  30 +--
 fs/nfs/export.c                                    |   2 +-
 fs/nfs/pnfs.c                                      |  16 +-
 fs/nfsd/nfs4state.c                                |  13 +-
 fs/overlayfs/dir.c                                 |   6 +-
 fs/userfaultfd.c                                   |  91 ++++---
 include/crypto/public_key.h                        |   4 +-
 include/drm/drm_auth.h                             |   1 +
 include/drm/drm_file.h                             |  18 +-
 include/kvm/arm_vgic.h                             |  28 ++-
 include/linux/ethtool.h                            |   4 -
 include/linux/exportfs.h                           |   2 +
 include/linux/f2fs_fs.h                            |   1 +
 include/linux/hugetlb.h                            |   9 +
 include/linux/hugetlb_cgroup.h                     |  12 +
 include/linux/intel-iommu.h                        |   6 +-
 include/linux/memory_hotplug.h                     |   4 +-
 include/linux/rcupdate.h                           |   2 +-
 include/linux/rtmutex.h                            |  19 +-
 include/linux/sunrpc/xprt.h                        |   1 +
 include/linux/sunrpc/xprtsock.h                    |   1 +
 include/net/bluetooth/hci_core.h                   |   4 +
 include/net/flow_offload.h                         |   1 +
 include/uapi/linux/serial_reg.h                    |   1 +
 kernel/dma/debug.c                                 |   7 +-
 kernel/fork.c                                      |   1 +
 kernel/locking/rtmutex.c                           |   2 +-
 kernel/pid_namespace.c                             |   3 +-
 kernel/printk/printk.c                             |   7 +-
 kernel/rcu/tree_plugin.h                           |   8 +-
 kernel/sched/cpufreq_schedutil.c                   |  16 +-
 kernel/workqueue.c                                 |  12 +-
 lib/test_bpf.c                                     |  13 +-
 lib/test_stackinit.c                               |  20 +-
 mm/hmm.c                                           |   5 +-
 mm/hugetlb.c                                       |   4 +-
 mm/memory_hotplug.c                                |   4 +-
 mm/vmscan.c                                        |   2 +-
 net/9p/trans_xen.c                                 |   4 +-
 net/bluetooth/hci_event.c                          | 140 ++++++++---
 net/bluetooth/hci_request.c                        |  81 +++----
 net/bluetooth/sco.c                                |  74 +++---
 net/core/flow_dissector.c                          |  12 +-
 net/core/flow_offload.c                            |  89 ++++++-
 net/ethtool/ioctl.c                                | 136 +++++++++--
 net/ipv4/ip_output.c                               |   5 +-
 net/ipv4/tcp_fastopen.c                            |   3 +-
 net/mac80211/iface.c                               |  11 +-
 net/netfilter/nf_flow_table_offload.c              |   1 +
 net/netfilter/nf_tables_offload.c                  |   1 +
 net/netfilter/nft_compat.c                         |   8 +-
 net/netlabel/netlabel_cipso_v4.c                   |   4 +-
 net/netlink/af_netlink.c                           |   4 +-
 net/sched/cls_api.c                                |   1 +
 net/sched/sch_taprio.c                             |   4 +-
 net/socket.c                                       | 125 +---------
 net/sunrpc/auth_gss/svcauth_gss.c                  |   2 +-
 net/sunrpc/xprt.c                                  |   8 +-
 net/sunrpc/xprtrdma/transport.c                    |  11 +-
 net/sunrpc/xprtrdma/verbs.c                        |  10 +-
 net/sunrpc/xprtsock.c                              |   7 +
 net/tipc/socket.c                                  |  36 ++-
 samples/bpf/test_override_return.sh                |   1 +
 samples/bpf/tracex7_user.c                         |   5 +
 .../pktgen/pktgen_sample03_burst_single_flow.sh    |   6 +-
 scripts/gen_ksymdeps.sh                            |   8 +-
 scripts/subarch.include                            |   2 +-
 security/smack/smack_access.c                      |  17 +-
 sound/soc/atmel/Kconfig                            |   1 -
 sound/soc/intel/boards/bytcr_rt5640.c              |   9 +-
 sound/soc/intel/boards/sof_pcm512x.c               |  13 +-
 sound/soc/intel/skylake/skl-messages.c             |  11 +-
 sound/soc/intel/skylake/skl-pcm.c                  |  25 +-
 sound/soc/rockchip/rockchip_i2s.c                  |  35 ++-
 sound/soc/soc-pcm.c                                | 103 ++++++--
 sound/soc/ti/davinci-mcasp.c                       | 150 ++++++++++--
 tools/lib/bpf/libbpf.c                             |  63 ++++-
 .../testing/selftests/arm64/mte/mte_common_util.c  |   2 +-
 tools/testing/selftests/arm64/pauth/pac.c          |  10 +-
 .../testing/selftests/bpf/prog_tests/send_signal.c |  16 ++
 .../selftests/bpf/prog_tests/sockopt_inherit.c     |   4 +-
 tools/testing/selftests/bpf/progs/xdp_tx.c         |   2 +-
 tools/testing/selftests/bpf/test_maps.c            |   2 +-
 tools/testing/selftests/bpf/test_progs.c           |  25 +-
 tools/testing/selftests/bpf/test_xdp_veth.sh       |   2 +-
 tools/testing/selftests/firmware/fw_namespace.c    |   3 +-
 tools/testing/selftests/ftrace/test.d/functions    |   2 +-
 tools/testing/selftests/nci/nci_dev.c              |   6 +-
 tools/thermal/tmon/Makefile                        |   2 +-
 426 files changed, 4644 insertions(+), 2448 deletions(-)


