Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEE55F2A70
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbiJCHgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbiJCHew (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:34:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0212152FE9;
        Mon,  3 Oct 2022 00:22:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1CE8B80E94;
        Mon,  3 Oct 2022 07:21:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 156A7C433D6;
        Mon,  3 Oct 2022 07:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781707;
        bh=3oAEM6Lq1EgZbx0mIW6cd0cUzqfsLxMyDRxpLxaod6E=;
        h=From:To:Cc:Subject:Date:From;
        b=opYYClWjmNBSlUAbVlxTBU4LRy2sQF4BASO4bpBA9UmKswjakJbot81mt9y0ytqor
         +N1LhniLFFLFwGFx9sfg2r2FzgdWuyvpaXpHNLcBETZj8RVMjqRkztvjiqqfpO3Oa5
         dePXJKG42mxc1Pncak67RzKy7jSSLhKUg0YW8JOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: [PATCH 5.10 00/52] 5.10.147-rc1 review
Date:   Mon,  3 Oct 2022 09:11:07 +0200
Message-Id: <20221003070718.687440096@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.147-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.147-rc1
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

This is the start of the stable review cycle for the 5.10.147 release.
There are 52 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.147-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.147-rc1

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda/hdmi: fix warning about PCM count when used with SOF

Nadav Amit <namit@vmware.com>
    x86/alternative: Fix race in try_get_desc()

Jim Mattson <jmattson@google.com>
    KVM: x86: Hide IA32_PLATFORM_DCA_CAP[31:0] from the guest

Florian Fainelli <f.fainelli@gmail.com>
    clk: iproc: Do not rely on node name for correct PLL setup

Han Xu <han.xu@nxp.com>
    clk: imx: imx6sx: remove the SET_RATE_PARENT flag for QSPI clocks

Wang Yufen <wangyufen@huawei.com>
    selftests: Fix the if conditions of in test_extra_filter()

Junxiao Chang <junxiao.chang@intel.com>
    net: stmmac: power up/down serdes in stmmac_open/release

Michael Kelley <mikelley@microsoft.com>
    nvme: Fix IOC_PR_CLEAR and IOC_PR_RELEASE ioctls for nvme devices

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    nvme: add new line after variable declatation

Rafael Mendonca <rafaelmendsr@gmail.com>
    cxgb4: fix missing unlock on ETHOFLD desc collect fail path

Hangyu Hua <hbh25y@gmail.com>
    net: sched: act_ct: fix possible refcount leak in tcf_ct_init()

Peilin Ye <peilin.ye@bytedance.com>
    usbnet: Fix memory leak in usbnet_disconnect()

Yang Yingliang <yangyingliang@huawei.com>
    Input: melfas_mip4 - fix return value check in mip4_probe()

Brian Norris <briannorris@chromium.org>
    Revert "drm: bridge: analogix/dp: add panel prepare/unprepare in suspend/resume time"

Martin Povišer <povik+lin@cutebit.org>
    ASoC: tas2770: Reinit regcache on reset

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

Richard Zhu <hongxing.zhu@nxp.com>
    reset: imx7: Fix the iMX8MP PCIe PHY PERST support

YuTong Chang <mtwget@gmail.com>
    ARM: dts: am33xx: Fix MMCHS0 dma properties

Yu Kuai <yukuai3@huawei.com>
    scsi: hisi_sas: Revert "scsi: hisi_sas: Limit max hw sectors for v3 HW"

Tianyu Lan <Tianyu.Lan@microsoft.com>
    swiotlb: max mapping size takes min align mask into account

Nicolas Dufresne <nicolas.dufresne@collabora.com>
    media: rkvdec: Disable H.264 error detection

Hangyu Hua <hbh25y@gmail.com>
    media: dvb_vb2: fix possible out of bound access

Minchan Kim <minchan@kernel.org>
    mm: fix madivse_pageout mishandling on non-LRU page

Alistair Popple <apopple@nvidia.com>
    mm/migrate_device.c: flush TLB while holding PTL

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

Yang Shi <shy828301@gmail.com>
    powerpc/64s/radix: don't need to broadcast IPI for radix pmd collapse flush

Alexander Couzens <lynxis@fe80.eu>
    net: mt7531: only do PLL once after the reset

ChenXiaoSong <chenxiaosong2@huawei.com>
    ntfs: fix BUG_ON in ntfs_lookup_inode_by_name()

Linus Walleij <linus.walleij@linaro.org>
    ARM: dts: integrator: Tag PCI host with device_type

Aidan MacDonald <aidanmacdonald.0x0@gmail.com>
    clk: ingenic-tcu: Properly enable registers before accessing timers

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

Filipe Manana <fdmanana@suse.com>
    btrfs: fix hang during unmount when stopping a space reclaim worker

Mohan Kumar <mkumard@nvidia.com>
    ALSA: hda: Fix Nvidia dp infoframe

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/hdmi: let new platforms assign the pcm slot dynamically

Dmitry Osipenko <digetx@gmail.com>
    ALSA: hda/tegra: Reset hardware

Dmitry Osipenko <digetx@gmail.com>
    ALSA: hda/tegra: Use clk_bulk helpers

Gil Fine <gil.fine@intel.com>
    thunderbolt: Add support for Intel Maple Ridge single port controller

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Add support for Intel Maple Ridge


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/boot/dts/am33xx-l4.dtsi                   |  3 +-
 arch/arm/boot/dts/integratorap.dts                 |  1 +
 arch/powerpc/mm/book3s64/radix_pgtable.c           |  9 ---
 arch/x86/kernel/alternative.c                      | 45 +++++------
 arch/x86/kvm/cpuid.c                               |  2 -
 drivers/ata/libata-core.c                          |  4 +
 drivers/clk/bcm/clk-iproc-pll.c                    | 12 ++-
 drivers/clk/imx/clk-imx6sx.c                       |  4 +-
 drivers/clk/ingenic/tcu.c                          | 15 ++--
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c | 13 ----
 drivers/input/keyboard/snvs_pwrkey.c               |  2 +-
 drivers/input/touchscreen/melfas_mip4.c            |  2 +-
 drivers/media/dvb-core/dvb_vb2.c                   | 11 +++
 drivers/mmc/host/mmc_hsq.c                         |  2 +-
 drivers/mmc/host/moxart-mmc.c                      | 17 +----
 drivers/net/dsa/mt7530.c                           | 15 ++--
 drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c     | 28 ++++---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 23 +++---
 drivers/net/usb/qmi_wwan.c                         |  1 +
 drivers/net/usb/usbnet.c                           |  7 +-
 drivers/nvme/host/core.c                           |  9 ++-
 drivers/reset/reset-imx7.c                         |  1 +
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |  7 --
 drivers/soc/sunxi/sunxi_sram.c                     | 27 +++----
 drivers/staging/media/rkvdec/rkvdec-h264.c         |  4 +-
 drivers/thunderbolt/icm.c                          | 12 +++
 drivers/thunderbolt/nhi.h                          |  2 +
 drivers/thunderbolt/switch.c                       |  1 +
 drivers/usb/storage/unusual_uas.h                  | 21 ++++++
 drivers/usb/typec/ucsi/ucsi.c                      |  2 -
 fs/btrfs/disk-io.c                                 | 25 ++++++
 fs/ntfs/super.c                                    |  3 +-
 kernel/dma/swiotlb.c                               | 13 +++-
 mm/madvise.c                                       |  7 +-
 mm/migrate.c                                       |  5 +-
 mm/page_alloc.c                                    | 65 +++++++++++++---
 net/sched/act_ct.c                                 |  5 +-
 sound/pci/hda/hda_tegra.c                          | 88 +++++++---------------
 sound/pci/hda/patch_hdmi.c                         | 47 ++++++++++--
 sound/soc/codecs/tas2770.c                         |  3 +
 tools/testing/selftests/net/reuseport_bpf.c        |  2 +-
 42 files changed, 346 insertions(+), 223 deletions(-)


