Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 931D25F518C
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 11:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbiJEJJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 05:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbiJEJJG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 05:09:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D70F77EB0;
        Wed,  5 Oct 2022 02:08:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53815B81D4A;
        Wed,  5 Oct 2022 09:08:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB760C433C1;
        Wed,  5 Oct 2022 09:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664960912;
        bh=uKVAjYgwdfX4WDmVrq4vADTobh4hvCcTZ0XklElhUnY=;
        h=From:To:Cc:Subject:Date:From;
        b=Sc0vt9vvHIQbGo4TB3VpDP0uRQzOU4ltKc+FdQ9pu0T1jPF8RqssauMhfUlqAIWn3
         ojIDfF4US0RQpPiKyKTvbJzBXzr9aJcRRSq756Zs5M1ouw+stFeo7SJAXgEu23Vj9G
         S8m+nl+1Kxrj+PnC9SoBjGq4FHlFeVd8wCw7Ie78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.72
Date:   Wed,  5 Oct 2022 11:08:23 +0200
Message-Id: <166496090322122@kroah.com>
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

I'm announcing the release of the 5.15.72 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                   |    2 
 arch/arm/boot/dts/am33xx-l4.dtsi                           |    3 
 arch/arm/boot/dts/am5748.dtsi                              |    4 
 arch/arm/boot/dts/integratorap.dts                         |    1 
 arch/arm64/boot/dts/qcom/sm8350.dtsi                       |    2 
 arch/x86/kernel/alternative.c                              |   45 +++---
 arch/x86/kernel/cpu/sgx/main.c                             |   15 +-
 arch/x86/kvm/cpuid.c                                       |    2 
 drivers/ata/libata-core.c                                  |    4 
 drivers/clk/bcm/clk-iproc-pll.c                            |   12 +
 drivers/clk/imx/clk-imx6sx.c                               |    4 
 drivers/clk/ingenic/tcu.c                                  |   15 --
 drivers/firmware/arm_scmi/scmi_pm_domain.c                 |   26 ----
 drivers/gpio/gpio-mvebu.c                                  |   15 --
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c                   |    4 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                 |   27 ++++
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c         |   13 --
 drivers/gpu/drm/bridge/lontium-lt8912b.c                   |   13 +-
 drivers/gpu/drm/i915/gem/i915_gem_context.c                |    8 -
 drivers/gpu/drm/i915/gt/intel_engine_types.h               |   15 ++
 drivers/gpu/drm/i915/gt/intel_execlists_submission.c       |   21 +++
 drivers/input/keyboard/snvs_pwrkey.c                       |    2 
 drivers/input/touchscreen/melfas_mip4.c                    |    2 
 drivers/media/dvb-core/dvb_vb2.c                           |   11 +
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c              |    2 
 drivers/mmc/host/mmc_hsq.c                                 |    2 
 drivers/mmc/host/moxart-mmc.c                              |   17 --
 drivers/net/can/c_can/c_can.h                              |   17 ++
 drivers/net/can/c_can/c_can_main.c                         |   11 -
 drivers/net/dsa/mt7530.c                                   |   15 +-
 drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c             |   28 ++--
 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c |    4 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c          |   23 ++-
 drivers/net/phy/phy_device.c                               |   10 -
 drivers/net/usb/qmi_wwan.c                                 |    1 
 drivers/net/usb/usbnet.c                                   |    7 -
 drivers/nvme/host/core.c                                   |    6 
 drivers/reset/reset-imx7.c                                 |    1 
 drivers/soc/sunxi/sunxi_sram.c                             |   27 +---
 drivers/staging/media/rkvdec/rkvdec-h264.c                 |    4 
 drivers/thunderbolt/switch.c                               |    1 
 drivers/usb/storage/unusual_uas.h                          |   21 +++
 drivers/usb/typec/ucsi/ucsi.c                              |    2 
 drivers/vdpa/ifcvf/ifcvf_base.c                            |    4 
 drivers/vdpa/vdpa_user/vduse_dev.c                         |    9 +
 fs/internal.h                                              |   24 +++
 fs/ntfs/super.c                                            |    3 
 fs/xattr.c                                                 |   84 +++++++++----
 kernel/cgroup/cgroup.c                                     |   54 ++++----
 kernel/dma/swiotlb.c                                       |   13 +-
 mm/damon/dbgfs.c                                           |   19 ++
 mm/madvise.c                                               |    7 -
 mm/memory-failure.c                                        |    3 
 mm/migrate.c                                               |    5 
 mm/page_alloc.c                                            |   65 ++++++++--
 mm/secretmem.c                                             |    2 
 net/mac80211/tx.c                                          |    4 
 net/sched/act_ct.c                                         |    5 
 sound/pci/hda/hda_bind.c                                   |    6 
 sound/pci/hda/hda_jack.c                                   |   11 +
 sound/pci/hda/hda_jack.h                                   |    1 
 sound/pci/hda/patch_hdmi.c                                 |   23 ++-
 sound/pci/hda/patch_realtek.c                              |   12 +
 sound/soc/codecs/tas2770.c                                 |    3 
 sound/soc/fsl/imx-card.c                                   |    4 
 tools/testing/selftests/net/reuseport_bpf.c                |    2 
 66 files changed, 561 insertions(+), 267 deletions(-)

Aidan MacDonald (1):
      clk: ingenic-tcu: Properly enable registers before accessing timers

Alexander Couzens (1):
      net: mt7531: only do PLL once after the reset

Alexander Sergeyev (1):
      ALSA: hda/realtek: fix speakers and micmute on HP 855 G8

Alistair Popple (1):
      mm/migrate_device.c: flush TLB while holding PTL

Angus Chen (1):
      vdpa/ifcvf: fix the calculation of queuepair

Binyi Han (1):
      mm: fix dereferencing possible ERR_PTR

Bokun Zhang (1):
      drm/amdgpu: Add amdgpu suspend-resume code path under SRIOV

Brian Norris (1):
      Revert "drm: bridge: analogix/dp: add panel prepare/unprepare in suspend/resume time"

Cai Huoqing (1):
      soc: sunxi_sram: Make use of the helper function devm_platform_ioremap_resource()

ChenXiaoSong (1):
      ntfs: fix BUG_ON in ntfs_lookup_inode_by_name()

Chris Wilson (2):
      drm/i915/gt: Restrict forced preemption to the active context
      drm/i915/gem: Really move i915_gem_context.link under ref protection

Florian Fainelli (1):
      clk: iproc: Do not rely on node name for correct PLL setup

Francesco Dolcini (1):
      drm/bridge: lt8912b: fix corrupted image output

Frank Wunderlich (1):
      net: usb: qmi_wwan: Add new usb-id for Dell branded EM7455

Greg Kroah-Hartman (2):
      mm/damon/dbgfs: fix memory leak when using debugfs_lookup()
      Linux 5.15.72

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

Hongling Zeng (3):
      uas: add no-uas quirk for Hiksemi usb_disk
      usb-storage: Add Hiksemi USB3-FW to IGNORE_UAS
      uas: ignore UAS for Thinkplus chips

Jarkko Sakkinen (1):
      x86/sgx: Do not fail on incomplete sanitization on premature stop of ksgxd

Jim Mattson (1):
      KVM: x86: Hide IA32_PLATFORM_DCA_CAP[31:0] from the guest

Johan Hovold (1):
      arm64: dts: qcom: sm8350: fix UFS PHY serdes size

Junxiao Chang (1):
      net: stmmac: power up/down serdes in stmmac_open/release

Linus Walleij (1):
      ARM: dts: integrator: Tag PCI host with device_type

Lukas Wunner (1):
      net: phy: Don't WARN for PHY_UP state in mdio_bus_phy_resume()

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

Michael Kelley (1):
      nvme: Fix IOC_PR_CLEAR and IOC_PR_RELEASE ioctls for nvme devices

Minchan Kim (1):
      mm: fix madivse_pageout mishandling on non-LRU page

Ming Lei (1):
      cgroup: cgroup_get_from_id() must check the looked-up kn is a directory

Mohan Kumar (1):
      ALSA: hda: Fix Nvidia dp infoframe

Nadav Amit (1):
      x86/alternative: Fix race in try_get_desc()

Nicolas Dufresne (1):
      media: rkvdec: Disable H.264 error detection

Niklas Cassel (1):
      libata: add ATA_HORKAGE_NOLPM for Pioneer BDR-207M and BDR-205

Pali Rohár (1):
      gpio: mvebu: Fix check for pwm support on non-A8K platforms

Peilin Ye (1):
      usbnet: Fix memory leak in usbnet_disconnect()

Peng Wu (1):
      net/mlxbf_gige: Fix an IS_ERR() vs NULL bug in mlxbf_gige_mdio_probe

Philippe Schenker (2):
      drm/bridge: lt8912b: add vsync hsync
      drm/bridge: lt8912b: set hdmi or dvi mode

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

Sergei Antonov (1):
      mmc: moxart: fix 4-bit bus width and remove 8-bit bus width

Shakeel Butt (1):
      cgroup: reduce dependency on cgroup_mutex

Shengjiu Wang (1):
      ASoC: imx-card: Fix refcount issue with of_node_put

Shuai Xue (1):
      mm,hwpoison: check mm when killing accessing process

Stefan Roesch (1):
      fs: split off setxattr_copy and do_setxattr function from setxattr

Takashi Iwai (2):
      ALSA: hda: Do disconnect jacks at codec unbind
      ALSA: hda: Fix hang at HD-audio codec unbinding due to refcount saturation

Tianyu Lan (1):
      swiotlb: max mapping size takes min align mask into account

Ulf Hansson (1):
      Revert "firmware: arm_scmi: Add clock management to the SCMI power domain"

Wang Yufen (1):
      selftests: Fix the if conditions of in test_extra_filter()

Wenchao Chen (1):
      mmc: hsq: Fix data stomping during mmc recovery

Yang Yingliang (1):
      Input: melfas_mip4 - fix return value check in mip4_probe()

YuTong Chang (1):
      ARM: dts: am33xx: Fix MMCHS0 dma properties

