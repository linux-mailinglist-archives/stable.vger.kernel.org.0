Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7D175F2AB8
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbiJCHjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232106AbiJCHjK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:39:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD394623C;
        Mon,  3 Oct 2022 00:24:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59B8260FA6;
        Mon,  3 Oct 2022 07:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E10C433C1;
        Mon,  3 Oct 2022 07:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781838;
        bh=4kHP4fzJTaNpiHoYAxliLR6aZ0e/YvPzyL70B1OkrpQ=;
        h=From:To:Cc:Subject:Date:From;
        b=c7ebP9d2hKUmmyBCk2AdbPZYc7ooC2sVxZwzDpoEfPCsXxI+uzg7CdBMoyCidcC5e
         zJ52XbL41zTtOzKHNblxSWZj0TCg0fV/zha3yDQqR3KN3u2SqwbeLdUp4S1+D7hZ6D
         ZSwhMP/s+eTfCMArswbeLFagxLZh/DnFKdenaTk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: [PATCH 5.4 00/30] 5.4.216-rc1 review
Date:   Mon,  3 Oct 2022 09:11:42 +0200
Message-Id: <20221003070716.269502440@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.216-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.216-rc1
X-KernelTest-Deadline: 2022-10-05T07:07+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.216 release.
There are 30 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.216-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.216-rc1

Florian Fainelli <f.fainelli@gmail.com>
    clk: iproc: Do not rely on node name for correct PLL setup

Han Xu <han.xu@nxp.com>
    clk: imx: imx6sx: remove the SET_RATE_PARENT flag for QSPI clocks

Wang Yufen <wangyufen@huawei.com>
    selftests: Fix the if conditions of in test_extra_filter()

Michael Kelley <mikelley@microsoft.com>
    nvme: Fix IOC_PR_CLEAR and IOC_PR_RELEASE ioctls for nvme devices

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    nvme: add new line after variable declatation

Peilin Ye <peilin.ye@bytedance.com>
    usbnet: Fix memory leak in usbnet_disconnect()

Yang Yingliang <yangyingliang@huawei.com>
    Input: melfas_mip4 - fix return value check in mip4_probe()

Brian Norris <briannorris@chromium.org>
    Revert "drm: bridge: analogix/dp: add panel prepare/unprepare in suspend/resume time"

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

YuTong Chang <mtwget@gmail.com>
    ARM: dts: am33xx: Fix MMCHS0 dma properties

Faiz Abbas <faiz_abbas@ti.com>
    ARM: dts: Move am33xx and am43xx mmc nodes to sdhci-omap driver

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

Sergei Antonov <saproj@gmail.com>
    mmc: moxart: fix 4-bit bus width and remove 8-bit bus width

Niklas Cassel <niklas.cassel@wdc.com>
    libata: add ATA_HORKAGE_NOLPM for Pioneer BDR-207M and BDR-205

Sasha Levin <sashal@kernel.org>
    Revert "net: mvpp2: debugfs: fix memory leak when using debugfs_lookup()"

ChenXiaoSong <chenxiaosong2@huawei.com>
    ntfs: fix BUG_ON in ntfs_lookup_inode_by_name()

Linus Walleij <linus.walleij@linaro.org>
    ARM: dts: integrator: Tag PCI host with device_type

Aidan MacDonald <aidanmacdonald.0x0@gmail.com>
    clk: ingenic-tcu: Properly enable registers before accessing timers

Frank Wunderlich <frank-w@public-files.de>
    net: usb: qmi_wwan: Add new usb-id for Dell branded EM7455

Hongling Zeng <zenghongling@kylinos.cn>
    uas: ignore UAS for Thinkplus chips

Hongling Zeng <zenghongling@kylinos.cn>
    usb-storage: Add Hiksemi USB3-FW to IGNORE_UAS

Hongling Zeng <zenghongling@kylinos.cn>
    uas: add no-uas quirk for Hiksemi usb_disk


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/boot/dts/am335x-baltos.dtsi               |  2 +-
 arch/arm/boot/dts/am335x-boneblack-common.dtsi     |  1 +
 arch/arm/boot/dts/am335x-boneblack-wireless.dts    |  1 -
 arch/arm/boot/dts/am335x-boneblue.dts              |  1 -
 arch/arm/boot/dts/am335x-bonegreen-wireless.dts    |  1 -
 arch/arm/boot/dts/am335x-evm.dts                   |  3 +-
 arch/arm/boot/dts/am335x-evmsk.dts                 |  2 +-
 arch/arm/boot/dts/am335x-lxm.dts                   |  2 +-
 arch/arm/boot/dts/am335x-moxa-uc-2100-common.dtsi  |  2 +-
 arch/arm/boot/dts/am335x-moxa-uc-8100-me-t.dts     |  2 +-
 arch/arm/boot/dts/am335x-pepper.dts                |  4 +-
 arch/arm/boot/dts/am335x-phycore-som.dtsi          |  2 +-
 arch/arm/boot/dts/am33xx-l4.dtsi                   |  9 +--
 arch/arm/boot/dts/am33xx.dtsi                      |  3 +-
 arch/arm/boot/dts/am4372.dtsi                      |  3 +-
 arch/arm/boot/dts/am437x-cm-t43.dts                |  2 +-
 arch/arm/boot/dts/am437x-gp-evm.dts                |  4 +-
 arch/arm/boot/dts/am437x-l4.dtsi                   |  5 +-
 arch/arm/boot/dts/am437x-sk-evm.dts                |  2 +-
 arch/arm/boot/dts/integratorap.dts                 |  1 +
 drivers/ata/libata-core.c                          |  4 ++
 drivers/clk/bcm/clk-iproc-pll.c                    | 12 ++--
 drivers/clk/imx/clk-imx6sx.c                       |  4 +-
 drivers/clk/ingenic/tcu.c                          | 15 ++---
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c | 13 -----
 drivers/input/touchscreen/melfas_mip4.c            |  2 +-
 drivers/media/dvb-core/dvb_vb2.c                   | 11 ++++
 drivers/mmc/host/moxart-mmc.c                      | 17 +-----
 drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c |  4 +-
 drivers/net/usb/qmi_wwan.c                         |  1 +
 drivers/net/usb/usbnet.c                           |  7 ++-
 drivers/nvme/host/core.c                           |  9 ++-
 drivers/soc/sunxi/sunxi_sram.c                     | 27 ++++-----
 drivers/usb/storage/unusual_uas.h                  | 21 +++++++
 fs/ntfs/super.c                                    |  3 +-
 mm/madvise.c                                       |  7 ++-
 mm/migrate.c                                       |  5 +-
 mm/page_alloc.c                                    | 65 ++++++++++++++++++----
 tools/testing/selftests/net/reuseport_bpf.c        |  2 +-
 40 files changed, 173 insertions(+), 112 deletions(-)


