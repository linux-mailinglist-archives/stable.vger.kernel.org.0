Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E622F5F292B
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiJCHPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiJCHOL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:14:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9C943E5B;
        Mon,  3 Oct 2022 00:13:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5DCAB80E67;
        Mon,  3 Oct 2022 07:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51B1C433C1;
        Mon,  3 Oct 2022 07:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781178;
        bh=QSAwQO5dZTURMbXIvu1AtvsyEzCpVR5CDBiyLp56e/Y=;
        h=From:To:Cc:Subject:Date:From;
        b=Bc/OJXg9eixhTyiv9El2nmiGwwQn+Vh7H++ZpkUjs13Rh4TO7TY+UQqW0iV+xbtHI
         H8pTCIKm+wFD5iffuhW8fyUjaT2/73N49tg9WBlGznkI4LKYeXhXTXxGRyeOJG/2fJ
         yqSknx6suE+lvqnFtcKWJILlb0Sqd4dTaWG+4jE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: [PATCH 5.19 000/101] 5.19.13-rc1 review
Date:   Mon,  3 Oct 2022 09:09:56 +0200
Message-Id: <20221003070724.490989164@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.19.13-rc1
X-KernelTest-Deadline: 2022-10-05T07:07+00:00
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

This is the start of the stable review cycle for the 5.19.13 release.
There are 101 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.13-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.19.13-rc1

Levi Yun <ppbuk5246@gmail.com>
    damon/sysfs: fix possible memleak on damon_sysfs_add_target

Nadav Amit <namit@vmware.com>
    x86/alternative: Fix race in try_get_desc()

Borislav Petkov <bp@suse.de>
    x86/cacheinfo: Add a cpu_llc_shared_mask() UP variant

Jim Mattson <jmattson@google.com>
    KVM: x86: Hide IA32_PLATFORM_DCA_CAP[31:0] from the guest

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf tests record: Fail the test if the 'errs' counter is not zero

Zhengjun Xing <zhengjun.xing@linux.intel.com>
    perf test: Fix test case 87 ("perf record tests") for hybrid systems

Daniel Golle <daniel@makrotopia.org>
    net: ethernet: mtk_eth_soc: fix mask of RX_DMA_GET_SPORT{,_V2}

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: fix tagged VLAN refusal while under a VLAN-unaware bridge

Peng Fan <peng.fan@nxp.com>
    clk: imx93: drop of_match_ptr

Florian Fainelli <f.fainelli@gmail.com>
    clk: iproc: Do not rely on node name for correct PLL setup

Ashutosh Dixit <ashutosh.dixit@intel.com>
    drm/i915/gt: Perf_limit_reasons are only available for Gen11+

Han Xu <han.xu@nxp.com>
    clk: imx: imx6sx: remove the SET_RATE_PARENT flag for QSPI clocks

Al Viro <viro@zeniv.linux.org.uk>
    don't use __kernel_write() on kmap_local_page()

Eli Cohen <elic@nvidia.com>
    vdpa/mlx5: Fix MQ to support non power of two num queues

Suwan Kim <suwan.kim027@gmail.com>
    virtio-blk: Fix WARN_ON_ONCE in virtio_queue_rq()

Angus Chen <angus.chen@jaguarmicro.com>
    vdpa/ifcvf: fix the calculation of queuepair

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: xsk: drop power of 2 ring size restriction for AF_XDP

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: xsk: change batched Tx descriptor cleaning

Wang Yufen <wangyufen@huawei.com>
    selftests: Fix the if conditions of in test_extra_filter()

Lukas Wunner <lukas@wunner.de>
    net: phy: Don't WARN for PHY_UP state in mdio_bus_phy_resume()

Junxiao Chang <junxiao.chang@intel.com>
    net: stmmac: power up/down serdes in stmmac_open/release

Paweł Lenkow <pawel.lenkow@camlingroup.com>
    wifi: mac80211: fix memory corruption in minstrel_ht_update_rates()

Hans de Goede <hdegoede@redhat.com>
    wifi: mac80211: fix regression with non-QoS drivers

Tamizh Chelvam Raja <quic_tamizhr@quicinc.com>
    wifi: cfg80211: fix MCS divisor value

Michael Kelley <mikelley@microsoft.com>
    nvme: Fix IOC_PR_CLEAR and IOC_PR_RELEASE ioctls for nvme devices

Peng Wu <wupeng58@huawei.com>
    net/mlxbf_gige: Fix an IS_ERR() vs NULL bug in mlxbf_gige_mdio_probe

Rafael Mendonca <rafaelmendsr@gmail.com>
    cxgb4: fix missing unlock on ETHOFLD desc collect fail path

Hangyu Hua <hbh25y@gmail.com>
    net: sched: act_ct: fix possible refcount leak in tcf_ct_init()

Peilin Ye <peilin.ye@bytedance.com>
    usbnet: Fix memory leak in usbnet_disconnect()

Zhengjun Xing <zhengjun.xing@linux.intel.com>
    perf parse-events: Remove "not supported" hybrid cache events

Zhengjun Xing <zhengjun.xing@linux.intel.com>
    perf print-events: Fix "perf list" can not display the PMU prefix for some hybrid cache events

Ian Rogers <irogers@google.com>
    perf parse-events: Break out tracepoint and printing

Pali Rohár <pali@kernel.org>
    gpio: mvebu: Fix check for pwm support on non-A8K platforms

Yang Yingliang <yangyingliang@huawei.com>
    Input: melfas_mip4 - fix return value check in mip4_probe()

Brian Norris <briannorris@chromium.org>
    Revert "drm: bridge: analogix/dp: add panel prepare/unprepare in suspend/resume time"

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    net: macb: Fix ZynqMP SGMII non-wakeup source resume failure

Francesco Dolcini <francesco.dolcini@toradex.com>
    drm/bridge: lt8912b: fix corrupted image output

Philippe Schenker <philippe.schenker@toradex.com>
    drm/bridge: lt8912b: set hdmi or dvi mode

Philippe Schenker <philippe.schenker@toradex.com>
    drm/bridge: lt8912b: add vsync hsync

Martin Povišer <povik+lin@cutebit.org>
    ASoC: tas2770: Reinit regcache on reset

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: sm8350: fix UFS PHY serdes size

Conor Dooley <conor.dooley@microchip.com>
    clk: microchip: mpfs: make the rtc's ahb clock critical

Conor Dooley <conor.dooley@microchip.com>
    clk: microchip: mpfs: fix clk_cfg array bounds violation

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: imx-card: Fix refcount issue with of_node_put

Samuel Holland <samuel@sholland.org>
    soc: sunxi: sram: Fix debugfs info for A64 SRAM C

Samuel Holland <samuel@sholland.org>
    soc: sunxi: sram: Fix probe function ordering issues

Samuel Holland <samuel@sholland.org>
    soc: sunxi: sram: Prevent the driver from being unbound

Samuel Holland <samuel@sholland.org>
    soc: sunxi: sram: Actually claim SRAM regions

Romain Naour <romain.naour@skf.com>
    ARM: dts: am5748: keep usb4_tm disabled

Richard Zhu <hongxing.zhu@nxp.com>
    reset: imx7: Fix the iMX8MP PCIe PHY PERST support

YuTong Chang <mtwget@gmail.com>
    ARM: dts: am33xx: Fix MMCHS0 dma properties

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: v4l2-compat-ioctl32.c: zero buffer passed to v4l2_compat_get_array_args()

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    media: mediatek: vcodec: Drop platform_get_resource(IORESOURCE_IRQ)

Nicolas Dufresne <nicolas.dufresne@collabora.com>
    media: rkvdec: Disable H.264 error detection

Hangyu Hua <hbh25y@gmail.com>
    media: dvb_vb2: fix possible out of bound access

Shuai Xue <xueshuai@linux.alibaba.com>
    mm,hwpoison: check mm when killing accessing process

Doug Berger <opendmb@gmail.com>
    mm/hugetlb: correct demote page offset logic

Sergei Antonov <saproj@gmail.com>
    mm: bring back update_mmu_cache() to finish_fault()

Minchan Kim <minchan@kernel.org>
    mm: fix madivse_pageout mishandling on non-LRU page

Alistair Popple <apopple@nvidia.com>
    mm/migrate_device.c: copy pte dirty bit to page

Alistair Popple <apopple@nvidia.com>
    mm/migrate_device.c: add missing flush_cache_page()

Alistair Popple <apopple@nvidia.com>
    mm/migrate_device.c: flush TLB while holding PTL

Binyi Han <dantengknight@gmail.com>
    mm: fix dereferencing possible ERR_PTR

Zi Yan <ziy@nvidia.com>
    mm/page_isolation: fix isolate_single_pageblock() isolation behavior

Maurizio Lombardi <mlombard@redhat.com>
    mm: prevent page_frag_alloc() from corrupting the memory

Mel Gorman <mgorman@techsingularity.net>
    mm/page_alloc: fix race condition between build_all_zonelists and page allocation

Yang Shi <shy828301@gmail.com>
    mm: gup: fix the fast GUP race against THP collapse

Wenchao Chen <wenchao.chen@unisoc.com>
    mmc: hsq: Fix data stomping during mmc recovery

Sergei Antonov <saproj@gmail.com>
    mmc: moxart: fix 4-bit bus width and remove 8-bit bus width

Menglong Dong <imagedong@tencent.com>
    mptcp: fix unreleased socket in accept queue

Menglong Dong <imagedong@tencent.com>
    mptcp: factor out __mptcp_close() without socket lock

Florian Westphal <fw@strlen.de>
    mm: fix BUG splat with kvmalloc + GFP_ATOMIC

Niklas Cassel <niklas.cassel@wdc.com>
    libata: add ATA_HORKAGE_NOLPM for Pioneer BDR-207M and BDR-205

Maxime Coquelin <maxime.coquelin@redhat.com>
    vduse: prevent uninitialized memory accesses

Bokun Zhang <Bokun.Zhang@amd.com>
    drm/amdgpu: Add amdgpu suspend-resume code path under SRIOV

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Restrict forced preemption to the active context

Yang Shi <shy828301@gmail.com>
    powerpc/64s/radix: don't need to broadcast IPI for radix pmd collapse flush

Ulf Hansson <ulf.hansson@linaro.org>
    Revert "firmware: arm_scmi: Add clock management to the SCMI power domain"

Alexander Couzens <lynxis@fe80.eu>
    net: mt7531: only do PLL once after the reset

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    mm/damon/dbgfs: fix memory leak when using debugfs_lookup()

Kees Cook <keescook@chromium.org>
    x86/uaccess: avoid check_object_size() in copy_from_user_nmi()

ChenXiaoSong <chenxiaosong2@huawei.com>
    ntfs: fix BUG_ON in ntfs_lookup_inode_by_name()

Linus Walleij <linus.walleij@linaro.org>
    ARM: dts: integrator: Tag PCI host with device_type

Christoph Hellwig <hch@lst.de>
    frontswap: don't call ->init if no ops are registered

Jarkko Sakkinen <jarkko@kernel.org>
    x86/sgx: Do not fail on incomplete sanitization on premature stop of ksgxd

Alexander Wetzel <alexander@wetzel-home.de>
    wifi: mac80211: ensure vif queues are operational after start

Aidan MacDonald <aidanmacdonald.0x0@gmail.com>
    clk: ingenic-tcu: Properly enable registers before accessing timers

Marc Kleine-Budde <mkl@pengutronix.de>
    can: c_can: don't cache TX messages for C_CAN cores

Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
    Input: snvs_pwrkey - fix SNVS_HPVIDR1 register address

Frank Wunderlich <frank-w@public-files.de>
    net: usb: qmi_wwan: Add new usb-id for Dell branded EM7455

Mario Limonciello <mario.limonciello@amd.com>
    thunderbolt: Explicitly reset plug events delay back to USB4 spec value

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: typec: ucsi: Remove incorrect warning

Hongling Zeng <zenghongling@kylinos.cn>
    uas: ignore UAS for Thinkplus chips

Hongling Zeng <zenghongling@kylinos.cn>
    usb-storage: Add Hiksemi USB3-FW to IGNORE_UAS

Hongling Zeng <zenghongling@kylinos.cn>
    uas: add no-uas quirk for Hiksemi usb_disk

William Breathitt Gray <william.gray@linaro.org>
    counter: 104-quad-8: Fix skipped IRQ lines during events configuration

William Breathitt Gray <william.gray@linaro.org>
    counter: 104-quad-8: Implement and utilize register structures

William Breathitt Gray <william.gray@linaro.org>
    counter: 104-quad-8: Utilize iomap interface

Adrian Hunter <adrian.hunter@intel.com>
    perf record: Fix cpu mask bit setting for mixed mmaps

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    tools/perf: Fix out of bound access to cpu mask array

Heiko Stuebner <heiko@sntech.de>
    riscv: make t-head erratas depend on MMU


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/am33xx-l4.dtsi                   |   3 +-
 arch/arm/boot/dts/am5748.dtsi                      |   4 +
 arch/arm/boot/dts/integratorap.dts                 |   1 +
 arch/arm64/boot/dts/qcom/sm8350.dtsi               |   2 +-
 arch/powerpc/mm/book3s64/radix_pgtable.c           |   9 -
 arch/riscv/Kconfig.erratas                         |   2 +-
 arch/x86/include/asm/smp.h                         |  25 +-
 arch/x86/kernel/alternative.c                      |  45 +-
 arch/x86/kernel/cpu/sgx/main.c                     |  15 +-
 arch/x86/kvm/cpuid.c                               |   2 -
 arch/x86/lib/usercopy.c                            |   2 +-
 drivers/ata/libata-core.c                          |   4 +
 drivers/block/virtio_blk.c                         |  11 +-
 drivers/clk/bcm/clk-iproc-pll.c                    |  12 +-
 drivers/clk/imx/clk-imx6sx.c                       |   4 +-
 drivers/clk/imx/clk-imx93.c                        |   2 +-
 drivers/clk/ingenic/tcu.c                          |  15 +-
 drivers/clk/microchip/clk-mpfs.c                   |  11 +-
 drivers/counter/104-quad-8.c                       | 209 +++---
 drivers/firmware/arm_scmi/scmi_pm_domain.c         |  26 -
 drivers/gpio/gpio-mvebu.c                          |  15 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |   4 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  27 +-
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c |  13 -
 drivers/gpu/drm/bridge/lontium-lt8912b.c           |  13 +-
 drivers/gpu/drm/i915/gt/intel_engine_types.h       |  15 +
 .../gpu/drm/i915/gt/intel_execlists_submission.c   |  21 +-
 drivers/gpu/drm/i915/gt/intel_gt_sysfs_pm.c        |  15 +-
 drivers/input/keyboard/snvs_pwrkey.c               |   2 +-
 drivers/input/touchscreen/melfas_mip4.c            |   2 +-
 drivers/media/dvb-core/dvb_vb2.c                   |  11 +
 .../platform/mediatek/vcodec/mtk_vcodec_enc_drv.c  |   9 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |   2 +
 drivers/mmc/host/mmc_hsq.c                         |   2 +-
 drivers/mmc/host/moxart-mmc.c                      |  17 +-
 drivers/net/can/c_can/c_can.h                      |  17 +-
 drivers/net/can/c_can/c_can_main.c                 |  11 +-
 drivers/net/dsa/mt7530.c                           |  15 +-
 drivers/net/ethernet/cadence/macb_main.c           |   4 +
 drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c     |  28 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |   2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           | 163 ++---
 drivers/net/ethernet/intel/ice/ice_xsk.h           |   7 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |   4 +-
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c |   4 +-
 drivers/net/ethernet/mscc/ocelot.c                 |   7 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  23 +-
 drivers/net/phy/phy_device.c                       |  10 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/usb/usbnet.c                           |   7 +-
 drivers/nvme/host/core.c                           |   6 +-
 drivers/reset/reset-imx7.c                         |   1 +
 drivers/soc/sunxi/sunxi_sram.c                     |  23 +-
 drivers/staging/media/rkvdec/rkvdec-h264.c         |   4 +-
 drivers/thunderbolt/switch.c                       |   1 +
 drivers/usb/storage/unusual_uas.h                  |  21 +
 drivers/usb/typec/ucsi/ucsi.c                      |   2 -
 drivers/vdpa/ifcvf/ifcvf_base.c                    |   4 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |  17 +-
 drivers/vdpa/vdpa_user/vduse_dev.c                 |   9 +-
 fs/coredump.c                                      |  38 +-
 fs/internal.h                                      |   3 +
 fs/ntfs/super.c                                    |   3 +-
 fs/read_write.c                                    |  22 +-
 mm/damon/dbgfs.c                                   |  19 +-
 mm/damon/sysfs.c                                   |   2 +-
 mm/frontswap.c                                     |   3 +
 mm/gup.c                                           |  34 +-
 mm/hugetlb.c                                       |  14 +-
 mm/khugepaged.c                                    |  10 +-
 mm/madvise.c                                       |   7 +-
 mm/memory-failure.c                                |   3 +
 mm/memory.c                                        |  14 +-
 mm/migrate_device.c                                |  16 +-
 mm/page_alloc.c                                    |  65 +-
 mm/page_isolation.c                                |  25 +-
 mm/secretmem.c                                     |   2 +-
 mm/util.c                                          |   4 +
 net/mac80211/rc80211_minstrel_ht.c                 |   6 +-
 net/mac80211/tx.c                                  |   4 +
 net/mac80211/util.c                                |   4 +-
 net/mptcp/protocol.c                               |  16 +-
 net/mptcp/protocol.h                               |   2 +
 net/mptcp/subflow.c                                |  33 +-
 net/sched/act_ct.c                                 |   5 +-
 net/wireless/util.c                                |   4 +-
 sound/soc/codecs/tas2770.c                         |   3 +
 sound/soc/fsl/imx-card.c                           |   4 +
 tools/perf/builtin-list.c                          |   2 +-
 tools/perf/builtin-lock.c                          |   1 +
 tools/perf/builtin-record.c                        |  28 +-
 tools/perf/builtin-timechart.c                     |   1 +
 tools/perf/builtin-trace.c                         |   1 +
 tools/perf/tests/perf-record.c                     |   2 +-
 tools/perf/tests/shell/record.sh                   |   2 +-
 tools/perf/util/Build                              |   2 +
 tools/perf/util/parse-events-hybrid.c              |  21 +-
 tools/perf/util/parse-events.c                     | 734 ++-------------------
 tools/perf/util/parse-events.h                     |  32 +-
 tools/perf/util/print-events.c                     | 533 +++++++++++++++
 tools/perf/util/print-events.h                     |  22 +
 tools/perf/util/trace-event-info.c                 |  96 +++
 tools/perf/util/tracepoint.c                       |  63 ++
 tools/perf/util/tracepoint.h                       |  25 +
 tools/testing/selftests/net/reuseport_bpf.c        |   2 +-
 106 files changed, 1628 insertions(+), 1271 deletions(-)


