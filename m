Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 512D85F518F
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 11:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbiJEJKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 05:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbiJEJJX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 05:09:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325BF78206;
        Wed,  5 Oct 2022 02:08:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EA2B615EB;
        Wed,  5 Oct 2022 09:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B38AC433C1;
        Wed,  5 Oct 2022 09:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664960921;
        bh=9dHwMxiCUI+Q4BDweDrVabmrH2d2tT/R4b6uqBejfeo=;
        h=From:To:Cc:Subject:Date:From;
        b=axlhiGwNIcz+MCobkthE6K0BxvQxXu+Iy9aMcGNJV8bI/KHklabOWZk2v1liymZIZ
         +U+gZfeIf3SVOa2J3wb5/F3iNlLhqEq0CPIZ4IwauaqPHqKDXl+nF9t18dMH/w0eHs
         1MxkAq3nt03NUK03y0/0eyeuDmvls43AYieIRn7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.19.14
Date:   Wed,  5 Oct 2022 11:08:37 +0200
Message-Id: <166496091861123@kroah.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
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

I'm announcing the release of the 5.19.14 kernel.

All users of the 5.19 kernel series must upgrade.

The updated 5.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                    |    2 
 arch/arm/boot/dts/am33xx-l4.dtsi                            |    3 
 arch/arm/boot/dts/am5748.dtsi                               |    4 
 arch/arm/boot/dts/integratorap.dts                          |    1 
 arch/arm64/boot/dts/qcom/sm8350.dtsi                        |    2 
 arch/powerpc/mm/book3s64/radix_pgtable.c                    |    9 
 arch/riscv/Kconfig.erratas                                  |    2 
 arch/x86/include/asm/smp.h                                  |   25 
 arch/x86/kernel/alternative.c                               |   45 
 arch/x86/kernel/cpu/sgx/main.c                              |   15 
 arch/x86/kvm/cpuid.c                                        |    2 
 arch/x86/lib/usercopy.c                                     |    2 
 drivers/ata/libata-core.c                                   |    4 
 drivers/block/virtio_blk.c                                  |   11 
 drivers/clk/bcm/clk-iproc-pll.c                             |   12 
 drivers/clk/imx/clk-imx6sx.c                                |    4 
 drivers/clk/imx/clk-imx93.c                                 |    2 
 drivers/clk/ingenic/tcu.c                                   |   15 
 drivers/clk/microchip/clk-mpfs.c                            |   11 
 drivers/counter/104-quad-8.c                                |  209 +--
 drivers/firmware/arm_scmi/scmi_pm_domain.c                  |   26 
 drivers/gpio/gpio-mvebu.c                                   |   15 
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c                    |    4 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                  |   27 
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c          |   13 
 drivers/gpu/drm/bridge/lontium-lt8912b.c                    |   13 
 drivers/gpu/drm/i915/gt/intel_engine_types.h                |   15 
 drivers/gpu/drm/i915/gt/intel_execlists_submission.c        |   21 
 drivers/gpu/drm/i915/gt/intel_gt_sysfs_pm.c                 |   15 
 drivers/input/keyboard/snvs_pwrkey.c                        |    2 
 drivers/input/touchscreen/melfas_mip4.c                     |    2 
 drivers/media/dvb-core/dvb_vb2.c                            |   11 
 drivers/media/platform/mediatek/vcodec/mtk_vcodec_enc_drv.c |    9 
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c               |    2 
 drivers/mmc/host/mmc_hsq.c                                  |    2 
 drivers/mmc/host/moxart-mmc.c                               |   17 
 drivers/net/can/c_can/c_can.h                               |   17 
 drivers/net/can/c_can/c_can_main.c                          |   11 
 drivers/net/dsa/mt7530.c                                    |   15 
 drivers/net/ethernet/cadence/macb_main.c                    |    4 
 drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c              |   28 
 drivers/net/ethernet/intel/ice/ice_txrx.c                   |    2 
 drivers/net/ethernet/intel/ice/ice_xsk.c                    |  163 +-
 drivers/net/ethernet/intel/ice/ice_xsk.h                    |    7 
 drivers/net/ethernet/mediatek/mtk_eth_soc.h                 |    4 
 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c  |    4 
 drivers/net/ethernet/mscc/ocelot.c                          |    7 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c           |   23 
 drivers/net/phy/phy_device.c                                |   10 
 drivers/net/usb/qmi_wwan.c                                  |    1 
 drivers/net/usb/usbnet.c                                    |    7 
 drivers/nvme/host/core.c                                    |    6 
 drivers/reset/reset-imx7.c                                  |    1 
 drivers/soc/sunxi/sunxi_sram.c                              |   23 
 drivers/staging/media/rkvdec/rkvdec-h264.c                  |    4 
 drivers/thunderbolt/switch.c                                |    1 
 drivers/usb/storage/unusual_uas.h                           |   21 
 drivers/usb/typec/ucsi/ucsi.c                               |    2 
 drivers/vdpa/ifcvf/ifcvf_base.c                             |    4 
 drivers/vdpa/mlx5/net/mlx5_vnet.c                           |   17 
 drivers/vdpa/vdpa_user/vduse_dev.c                          |    9 
 fs/ntfs/super.c                                             |    3 
 mm/damon/dbgfs.c                                            |   19 
 mm/damon/sysfs.c                                            |    2 
 mm/frontswap.c                                              |    3 
 mm/gup.c                                                    |   34 
 mm/hugetlb.c                                                |   14 
 mm/khugepaged.c                                             |   10 
 mm/madvise.c                                                |    7 
 mm/memory-failure.c                                         |    3 
 mm/memory.c                                                 |   14 
 mm/migrate_device.c                                         |   16 
 mm/page_alloc.c                                             |   65 -
 mm/page_isolation.c                                         |   25 
 mm/secretmem.c                                              |    2 
 mm/util.c                                                   |    4 
 net/mac80211/rc80211_minstrel_ht.c                          |    6 
 net/mac80211/tx.c                                           |    4 
 net/mac80211/util.c                                         |    4 
 net/mptcp/protocol.c                                        |   16 
 net/mptcp/protocol.h                                        |    2 
 net/mptcp/subflow.c                                         |   33 
 net/sched/act_ct.c                                          |    5 
 net/wireless/util.c                                         |    4 
 sound/soc/codecs/tas2770.c                                  |    3 
 sound/soc/fsl/imx-card.c                                    |    4 
 tools/perf/builtin-list.c                                   |    2 
 tools/perf/builtin-lock.c                                   |    1 
 tools/perf/builtin-record.c                                 |   28 
 tools/perf/builtin-timechart.c                              |    1 
 tools/perf/builtin-trace.c                                  |    1 
 tools/perf/tests/perf-record.c                              |    2 
 tools/perf/tests/shell/record.sh                            |    2 
 tools/perf/util/Build                                       |    2 
 tools/perf/util/parse-events-hybrid.c                       |   21 
 tools/perf/util/parse-events.c                              |  734 ------------
 tools/perf/util/parse-events.h                              |   32 
 tools/perf/util/print-events.c                              |  533 ++++++++
 tools/perf/util/print-events.h                              |   22 
 tools/perf/util/trace-event-info.c                          |   96 +
 tools/perf/util/tracepoint.c                                |   63 +
 tools/perf/util/tracepoint.h                                |   25 
 tools/testing/selftests/net/reuseport_bpf.c                 |    2 
 103 files changed, 1577 insertions(+), 1257 deletions(-)

Adrian Hunter (1):
      perf record: Fix cpu mask bit setting for mixed mmaps

Aidan MacDonald (1):
      clk: ingenic-tcu: Properly enable registers before accessing timers

Alexander Couzens (1):
      net: mt7531: only do PLL once after the reset

Alexander Wetzel (1):
      wifi: mac80211: ensure vif queues are operational after start

Alistair Popple (3):
      mm/migrate_device.c: flush TLB while holding PTL
      mm/migrate_device.c: add missing flush_cache_page()
      mm/migrate_device.c: copy pte dirty bit to page

Angus Chen (1):
      vdpa/ifcvf: fix the calculation of queuepair

Arnaldo Carvalho de Melo (1):
      perf tests record: Fail the test if the 'errs' counter is not zero

Ashutosh Dixit (1):
      drm/i915/gt: Perf_limit_reasons are only available for Gen11+

Athira Rajeev (1):
      tools/perf: Fix out of bound access to cpu mask array

Binyi Han (1):
      mm: fix dereferencing possible ERR_PTR

Bokun Zhang (1):
      drm/amdgpu: Add amdgpu suspend-resume code path under SRIOV

Borislav Petkov (1):
      x86/cacheinfo: Add a cpu_llc_shared_mask() UP variant

Brian Norris (1):
      Revert "drm: bridge: analogix/dp: add panel prepare/unprepare in suspend/resume time"

ChenXiaoSong (1):
      ntfs: fix BUG_ON in ntfs_lookup_inode_by_name()

Chris Wilson (1):
      drm/i915/gt: Restrict forced preemption to the active context

Christoph Hellwig (1):
      frontswap: don't call ->init if no ops are registered

Conor Dooley (2):
      clk: microchip: mpfs: fix clk_cfg array bounds violation
      clk: microchip: mpfs: make the rtc's ahb clock critical

Daniel Golle (1):
      net: ethernet: mtk_eth_soc: fix mask of RX_DMA_GET_SPORT{,_V2}

Doug Berger (1):
      mm/hugetlb: correct demote page offset logic

Eli Cohen (1):
      vdpa/mlx5: Fix MQ to support non power of two num queues

Florian Fainelli (1):
      clk: iproc: Do not rely on node name for correct PLL setup

Florian Westphal (1):
      mm: fix BUG splat with kvmalloc + GFP_ATOMIC

Francesco Dolcini (1):
      drm/bridge: lt8912b: fix corrupted image output

Frank Wunderlich (1):
      net: usb: qmi_wwan: Add new usb-id for Dell branded EM7455

Greg Kroah-Hartman (2):
      mm/damon/dbgfs: fix memory leak when using debugfs_lookup()
      Linux 5.19.14

Han Xu (1):
      clk: imx: imx6sx: remove the SET_RATE_PARENT flag for QSPI clocks

Hangyu Hua (2):
      media: dvb_vb2: fix possible out of bound access
      net: sched: act_ct: fix possible refcount leak in tcf_ct_init()

Hans Verkuil (1):
      media: v4l2-compat-ioctl32.c: zero buffer passed to v4l2_compat_get_array_args()

Hans de Goede (1):
      wifi: mac80211: fix regression with non-QoS drivers

Heikki Krogerus (1):
      usb: typec: ucsi: Remove incorrect warning

Heiko Stuebner (1):
      riscv: make t-head erratas depend on MMU

Hongling Zeng (3):
      uas: add no-uas quirk for Hiksemi usb_disk
      usb-storage: Add Hiksemi USB3-FW to IGNORE_UAS
      uas: ignore UAS for Thinkplus chips

Ian Rogers (1):
      perf parse-events: Break out tracepoint and printing

Jarkko Sakkinen (1):
      x86/sgx: Do not fail on incomplete sanitization on premature stop of ksgxd

Jim Mattson (1):
      KVM: x86: Hide IA32_PLATFORM_DCA_CAP[31:0] from the guest

Johan Hovold (1):
      arm64: dts: qcom: sm8350: fix UFS PHY serdes size

Junxiao Chang (1):
      net: stmmac: power up/down serdes in stmmac_open/release

Kees Cook (1):
      x86/uaccess: avoid check_object_size() in copy_from_user_nmi()

Levi Yun (1):
      damon/sysfs: fix possible memleak on damon_sysfs_add_target

Linus Walleij (1):
      ARM: dts: integrator: Tag PCI host with device_type

Lukas Wunner (1):
      net: phy: Don't WARN for PHY_UP state in mdio_bus_phy_resume()

Maciej Fijalkowski (2):
      ice: xsk: change batched Tx descriptor cleaning
      ice: xsk: drop power of 2 ring size restriction for AF_XDP

Marc Kleine-Budde (1):
      can: c_can: don't cache TX messages for C_CAN cores

Mario Limonciello (1):
      thunderbolt: Explicitly reset plug events delay back to USB4 spec value

Martin Povišer (1):
      ASoC: tas2770: Reinit regcache on reset

Maurizio Lombardi (1):
      mm: prevent page_frag_alloc() from corrupting the memory

Maxime Coquelin (1):
      vduse: prevent uninitialized memory accesses

Mel Gorman (1):
      mm/page_alloc: fix race condition between build_all_zonelists and page allocation

Menglong Dong (2):
      mptcp: factor out __mptcp_close() without socket lock
      mptcp: fix unreleased socket in accept queue

Michael Kelley (1):
      nvme: Fix IOC_PR_CLEAR and IOC_PR_RELEASE ioctls for nvme devices

Minchan Kim (1):
      mm: fix madivse_pageout mishandling on non-LRU page

Nadav Amit (1):
      x86/alternative: Fix race in try_get_desc()

Nicolas Dufresne (1):
      media: rkvdec: Disable H.264 error detection

Niklas Cassel (1):
      libata: add ATA_HORKAGE_NOLPM for Pioneer BDR-207M and BDR-205

Nícolas F. R. A. Prado (1):
      media: mediatek: vcodec: Drop platform_get_resource(IORESOURCE_IRQ)

Pali Rohár (1):
      gpio: mvebu: Fix check for pwm support on non-A8K platforms

Paweł Lenkow (1):
      wifi: mac80211: fix memory corruption in minstrel_ht_update_rates()

Peilin Ye (1):
      usbnet: Fix memory leak in usbnet_disconnect()

Peng Fan (1):
      clk: imx93: drop of_match_ptr

Peng Wu (1):
      net/mlxbf_gige: Fix an IS_ERR() vs NULL bug in mlxbf_gige_mdio_probe

Philippe Schenker (2):
      drm/bridge: lt8912b: add vsync hsync
      drm/bridge: lt8912b: set hdmi or dvi mode

Radhey Shyam Pandey (1):
      net: macb: Fix ZynqMP SGMII non-wakeup source resume failure

Rafael Mendonca (1):
      cxgb4: fix missing unlock on ETHOFLD desc collect fail path

Richard Zhu (1):
      reset: imx7: Fix the iMX8MP PCIe PHY PERST support

Romain Naour (1):
      ARM: dts: am5748: keep usb4_tm disabled

Samuel Holland (4):
      soc: sunxi: sram: Actually claim SRAM regions
      soc: sunxi: sram: Prevent the driver from being unbound
      soc: sunxi: sram: Fix probe function ordering issues
      soc: sunxi: sram: Fix debugfs info for A64 SRAM C

Sebastian Krzyszkowiak (1):
      Input: snvs_pwrkey - fix SNVS_HPVIDR1 register address

Sergei Antonov (2):
      mmc: moxart: fix 4-bit bus width and remove 8-bit bus width
      mm: bring back update_mmu_cache() to finish_fault()

Shengjiu Wang (1):
      ASoC: imx-card: Fix refcount issue with of_node_put

Shuai Xue (1):
      mm,hwpoison: check mm when killing accessing process

Suwan Kim (1):
      virtio-blk: Fix WARN_ON_ONCE in virtio_queue_rq()

Tamizh Chelvam Raja (1):
      wifi: cfg80211: fix MCS divisor value

Ulf Hansson (1):
      Revert "firmware: arm_scmi: Add clock management to the SCMI power domain"

Vladimir Oltean (1):
      net: mscc: ocelot: fix tagged VLAN refusal while under a VLAN-unaware bridge

Wang Yufen (1):
      selftests: Fix the if conditions of in test_extra_filter()

Wenchao Chen (1):
      mmc: hsq: Fix data stomping during mmc recovery

William Breathitt Gray (3):
      counter: 104-quad-8: Utilize iomap interface
      counter: 104-quad-8: Implement and utilize register structures
      counter: 104-quad-8: Fix skipped IRQ lines during events configuration

Yang Shi (2):
      powerpc/64s/radix: don't need to broadcast IPI for radix pmd collapse flush
      mm: gup: fix the fast GUP race against THP collapse

Yang Yingliang (1):
      Input: melfas_mip4 - fix return value check in mip4_probe()

YuTong Chang (1):
      ARM: dts: am33xx: Fix MMCHS0 dma properties

Zhengjun Xing (3):
      perf print-events: Fix "perf list" can not display the PMU prefix for some hybrid cache events
      perf parse-events: Remove "not supported" hybrid cache events
      perf test: Fix test case 87 ("perf record tests") for hybrid systems

Zi Yan (1):
      mm/page_isolation: fix isolate_single_pageblock() isolation behavior

