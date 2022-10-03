Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7802F5F29CA
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbiJCHZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbiJCHYM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:24:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE844B4A3;
        Mon,  3 Oct 2022 00:17:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 501BF60F9C;
        Mon,  3 Oct 2022 07:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3796AC433C1;
        Mon,  3 Oct 2022 07:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781477;
        bh=oKC0vIg49WetTCDWhe6vhupdChzBcV4Acudleq5sGf0=;
        h=From:To:Cc:Subject:Date:From;
        b=Y66WkqKhGgSKTrrtNUoHFyaXfsX4++YGOF6ox+PHjIdJx3/Xi6s7pGdlloathnoiu
         jY3T144pXrohBUGs172cUD5wjXJZP1EcNp63pxDM82TDi7SexmeM4UTuoj0gBK/DFp
         WFyM4zRDB2v2Ik4UhzPkuTS9JYRzEusnBW+MME8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: [PATCH 5.15 00/83] 5.15.72-rc1 review
Date:   Mon,  3 Oct 2022 09:10:25 +0200
Message-Id: <20221003070721.971297651@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.72-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.72-rc1
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

This is the start of the stable review cycle for the 5.15.72 release.
There are 83 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.72-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.72-rc1

Ian Rogers <irogers@google.com>
    perf evsel: Add tool event helpers

John Garry <john.garry@huawei.com>
    perf pmu: Fix alias events list

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gem: Really move i915_gem_context.link under ref protection

Nadav Amit <namit@vmware.com>
    x86/alternative: Fix race in try_get_desc()

Florian Fischer <florian.fischer@muhq.space>
    perf list: Print all available tool events

Wei Li <liwei391@huawei.com>
    perf tools: Enhance the matching of sub-commands abbreviations

James Clark <james.clark@arm.com>
    perf tools: Check vmlinux/kallsyms arguments in all tools

Jin Yao <yao.jin@linux.intel.com>
    perf list: Display hybrid PMU events with cpu type

Ian Rogers <irogers@google.com>
    perf parse-events: Identify broken modifiers

Ian Rogers <irogers@google.com>
    perf parse-events: Add new "metric-id" term

Ian Rogers <irogers@google.com>
    perf parse-events: Add const to evsel name

Ian Rogers <irogers@google.com>
    perf metric: Only add a referenced metric once

Ian Rogers <irogers@google.com>
    perf metric: Add documentation and rename a variable.

Jim Mattson <jmattson@google.com>
    KVM: x86: Hide IA32_PLATFORM_DCA_CAP[31:0] from the guest

Florian Fainelli <f.fainelli@gmail.com>
    clk: iproc: Do not rely on node name for correct PLL setup

Han Xu <han.xu@nxp.com>
    clk: imx: imx6sx: remove the SET_RATE_PARENT flag for QSPI clocks

Al Viro <viro@zeniv.linux.org.uk>
    don't use __kernel_write() on kmap_local_page()

Stefan Roesch <shr@fb.com>
    fs: split off setxattr_copy and do_setxattr function from setxattr

Angus Chen <angus.chen@jaguarmicro.com>
    vdpa/ifcvf: fix the calculation of queuepair

Wang Yufen <wangyufen@huawei.com>
    selftests: Fix the if conditions of in test_extra_filter()

Lukas Wunner <lukas@wunner.de>
    net: phy: Don't WARN for PHY_UP state in mdio_bus_phy_resume()

Junxiao Chang <junxiao.chang@intel.com>
    net: stmmac: power up/down serdes in stmmac_open/release

Hans de Goede <hdegoede@redhat.com>
    wifi: mac80211: fix regression with non-QoS drivers

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

Pali Rohár <pali@kernel.org>
    gpio: mvebu: Fix check for pwm support on non-A8K platforms

Yang Yingliang <yangyingliang@huawei.com>
    Input: melfas_mip4 - fix return value check in mip4_probe()

Brian Norris <briannorris@chromium.org>
    Revert "drm: bridge: analogix/dp: add panel prepare/unprepare in suspend/resume time"

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

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: imx-card: Fix refcount issue with of_node_put

Samuel Holland <samuel@sholland.org>
    soc: sunxi: sram: Fix debugfs info for A64 SRAM C

Samuel Holland <samuel@sholland.org>
    soc: sunxi: sram: Fix probe function ordering issues

Cai Huoqing <caihuoqing@baidu.com>
    soc: sunxi_sram: Make use of the helper function devm_platform_ioremap_resource()

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

Tianyu Lan <Tianyu.Lan@microsoft.com>
    swiotlb: max mapping size takes min align mask into account

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: v4l2-compat-ioctl32.c: zero buffer passed to v4l2_compat_get_array_args()

Nicolas Dufresne <nicolas.dufresne@collabora.com>
    media: rkvdec: Disable H.264 error detection

Hangyu Hua <hbh25y@gmail.com>
    media: dvb_vb2: fix possible out of bound access

Shuai Xue <xueshuai@linux.alibaba.com>
    mm,hwpoison: check mm when killing accessing process

Minchan Kim <minchan@kernel.org>
    mm: fix madivse_pageout mishandling on non-LRU page

Alistair Popple <apopple@nvidia.com>
    mm/migrate_device.c: flush TLB while holding PTL

Binyi Han <dantengknight@gmail.com>
    mm: fix dereferencing possible ERR_PTR

Maurizio Lombardi <mlombard@redhat.com>
    mm: prevent page_frag_alloc() from corrupting the memory

Mel Gorman <mgorman@techsingularity.net>
    mm/page_alloc: fix race condition between build_all_zonelists and page allocation

Wenchao Chen <wenchao.chen@unisoc.com>
    mmc: hsq: Fix data stomping during mmc recovery

Sergei Antonov <saproj@gmail.com>
    mmc: moxart: fix 4-bit bus width and remove 8-bit bus width

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

ChenXiaoSong <chenxiaosong2@huawei.com>
    ntfs: fix BUG_ON in ntfs_lookup_inode_by_name()

Linus Walleij <linus.walleij@linaro.org>
    ARM: dts: integrator: Tag PCI host with device_type

Jarkko Sakkinen <jarkko@kernel.org>
    x86/sgx: Do not fail on incomplete sanitization on premature stop of ksgxd

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

Ming Lei <ming.lei@redhat.com>
    cgroup: cgroup_get_from_id() must check the looked-up kn is a directory

Shakeel Butt <shakeelb@google.com>
    cgroup: reduce dependency on cgroup_mutex

Alexander Sergeyev <sergeev917@gmail.com>
    ALSA: hda/realtek: fix speakers and micmute on HP 855 G8

Mohan Kumar <mkumard@nvidia.com>
    ALSA: hda: Fix Nvidia dp infoframe

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Fix hang at HD-audio codec unbinding due to refcount saturation

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Do disconnect jacks at codec unbind


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/am33xx-l4.dtsi                   |   3 +-
 arch/arm/boot/dts/am5748.dtsi                      |   4 +
 arch/arm/boot/dts/integratorap.dts                 |   1 +
 arch/arm64/boot/dts/qcom/sm8350.dtsi               |   2 +-
 arch/powerpc/mm/book3s64/radix_pgtable.c           |   9 --
 arch/x86/kernel/alternative.c                      |  45 ++++---
 arch/x86/kernel/cpu/sgx/main.c                     |  15 ++-
 arch/x86/kvm/cpuid.c                               |   2 -
 drivers/ata/libata-core.c                          |   4 +
 drivers/clk/bcm/clk-iproc-pll.c                    |  12 +-
 drivers/clk/imx/clk-imx6sx.c                       |   4 +-
 drivers/clk/ingenic/tcu.c                          |  15 +--
 drivers/firmware/arm_scmi/scmi_pm_domain.c         |  26 ----
 drivers/gpio/gpio-mvebu.c                          |  15 +--
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |   4 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  27 +++-
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c |  13 --
 drivers/gpu/drm/bridge/lontium-lt8912b.c           |  13 +-
 drivers/gpu/drm/i915/gem/i915_gem_context.c        |   8 +-
 drivers/gpu/drm/i915/gt/intel_engine_types.h       |  15 +++
 .../gpu/drm/i915/gt/intel_execlists_submission.c   |  21 ++-
 drivers/input/keyboard/snvs_pwrkey.c               |   2 +-
 drivers/input/touchscreen/melfas_mip4.c            |   2 +-
 drivers/media/dvb-core/dvb_vb2.c                   |  11 ++
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |   2 +
 drivers/mmc/host/mmc_hsq.c                         |   2 +-
 drivers/mmc/host/moxart-mmc.c                      |  17 +--
 drivers/net/can/c_can/c_can.h                      |  17 ++-
 drivers/net/can/c_can/c_can_main.c                 |  11 +-
 drivers/net/dsa/mt7530.c                           |  15 ++-
 drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c     |  28 ++--
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c |   4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  23 ++--
 drivers/net/phy/phy_device.c                       |  10 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/usb/usbnet.c                           |   7 +-
 drivers/nvme/host/core.c                           |   6 +-
 drivers/reset/reset-imx7.c                         |   1 +
 drivers/soc/sunxi/sunxi_sram.c                     |  27 ++--
 drivers/staging/media/rkvdec/rkvdec-h264.c         |   4 +-
 drivers/thunderbolt/switch.c                       |   1 +
 drivers/usb/storage/unusual_uas.h                  |  21 +++
 drivers/usb/typec/ucsi/ucsi.c                      |   2 -
 drivers/vdpa/ifcvf/ifcvf_base.c                    |   4 +-
 drivers/vdpa/vdpa_user/vduse_dev.c                 |   9 +-
 fs/coredump.c                                      |  38 +++++-
 fs/internal.h                                      |  27 ++++
 fs/ntfs/super.c                                    |   3 +-
 fs/read_write.c                                    |  22 +--
 fs/xattr.c                                         |  84 ++++++++----
 kernel/cgroup/cgroup.c                             |  54 +++++---
 kernel/dma/swiotlb.c                               |  13 +-
 mm/damon/dbgfs.c                                   |  19 ++-
 mm/madvise.c                                       |   7 +-
 mm/memory-failure.c                                |   3 +
 mm/migrate.c                                       |   5 +-
 mm/page_alloc.c                                    |  65 +++++++--
 mm/secretmem.c                                     |   2 +-
 net/mac80211/tx.c                                  |   4 +
 net/sched/act_ct.c                                 |   5 +-
 sound/pci/hda/hda_bind.c                           |   6 +-
 sound/pci/hda/hda_jack.c                           |  11 ++
 sound/pci/hda/hda_jack.h                           |   1 +
 sound/pci/hda/patch_hdmi.c                         |  23 +++-
 sound/pci/hda/patch_realtek.c                      |  12 ++
 sound/soc/codecs/tas2770.c                         |   3 +
 sound/soc/fsl/imx-card.c                           |   4 +
 tools/perf/Documentation/perf-list.txt             |   4 +
 tools/perf/builtin-annotate.c                      |   4 +
 tools/perf/builtin-c2c.c                           |   9 +-
 tools/perf/builtin-kmem.c                          |   2 +-
 tools/perf/builtin-kvm.c                           |   9 +-
 tools/perf/builtin-list.c                          |  42 ++++--
 tools/perf/builtin-lock.c                          |   5 +-
 tools/perf/builtin-mem.c                           |   5 +-
 tools/perf/builtin-probe.c                         |   5 +
 tools/perf/builtin-record.c                        |   4 +
 tools/perf/builtin-sched.c                         |   8 +-
 tools/perf/builtin-script.c                        |   7 +-
 tools/perf/builtin-stat.c                          |   4 +-
 tools/perf/builtin-timechart.c                     |   3 +-
 tools/perf/builtin-top.c                           |   4 +
 tools/perf/util/evsel.c                            |  59 ++++++--
 tools/perf/util/evsel.h                            |  14 ++
 tools/perf/util/metricgroup.c                      |  78 +++++++++--
 tools/perf/util/metricgroup.h                      |   2 +-
 tools/perf/util/parse-events-hybrid.c              |  34 +++--
 tools/perf/util/parse-events-hybrid.h              |   6 +-
 tools/perf/util/parse-events.c                     | 148 +++++++++++++++------
 tools/perf/util/parse-events.h                     |  13 +-
 tools/perf/util/parse-events.l                     |   1 +
 tools/perf/util/parse-events.y                     |  10 ++
 tools/perf/util/pfm.c                              |   3 +-
 tools/perf/util/pmu.c                              |  40 +++++-
 tools/perf/util/pmu.h                              |   4 +-
 tools/testing/selftests/net/reuseport_bpf.c        |   2 +-
 97 files changed, 1022 insertions(+), 407 deletions(-)


