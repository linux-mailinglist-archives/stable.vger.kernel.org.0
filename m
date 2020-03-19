Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D208E18B9DB
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 15:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbgCSO7V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 10:59:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:38076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726785AbgCSO7V (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 10:59:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C37520663;
        Thu, 19 Mar 2020 14:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584629959;
        bh=alXmxA1gwAqzeUBwNzGXUh5hEEWtgsL80G3zBUhrR3g=;
        h=From:To:Cc:Subject:Date:From;
        b=EFIWeGdJvHbvZx0GE4ut+OOC9g1IBEux3f5GeHEDM6BFQ6bRxvP2Qc3eWDI7JJ0x9
         rngjknq1oJk2RXiGXBQ8qZIe3rUptJwgZKfbyF/parsbWAI0DCMKwjQiRZxVSMRgC6
         S9FvpFt8qDSLYvQ2TAHWtBstl23Ye8D4xva1UrBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.5 00/64] 5.5.11-rc1 review
Date:   Thu, 19 Mar 2020 15:59:16 +0100
Message-Id: <20200319145826.910131145@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.5.11-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.5.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.5.11-rc1
X-KernelTest-Deadline: 2020-03-21T14:58+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.5.11 release.
There are 64 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 21 Mar 2020 14:57:53 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.11-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.5.11-rc1

Matteo Croce <mcroce@redhat.com>
    ipv4: ensure rcu_read_lock() in cipso_v4_error()

Ard Biesheuvel <ardb@kernel.org>
    ARM: 8961/2: Fix Kbuild issue caused by per-task stack protector GCC plugin

Tony Fischetti <tony.fischetti@gmail.com>
    HID: add ALWAYS_POLL quirk to lenovo pixart mouse

Chen-Tsung Hsieh <chentsung@chromium.org>
    HID: google: add moonball USB id

Jann Horn <jannh@google.com>
    mm: slub: add missing TID bump in kmem_cache_alloc_bulk()

Kees Cook <keescook@chromium.org>
    ARM: 8958/1: rename missed uaccess .fixup section

Florian Fainelli <f.fainelli@gmail.com>
    ARM: 8957/1: VDSO: Match ARMv8 timer in cntvct_functional()

Ming Lei <ming.lei@redhat.com>
    blk-mq: insert flush request to the front of dispatch queue

Qian Cai <cai@lca.pw>
    jbd2: fix data races at struct journal_head

Andrew Lunn <andrew@lunn.ch>
    net: dsa: mv88e6xxx: Fix masking of egress port

Amit Cohen <amitc@mellanox.com>
    mlxsw: pci: Wait longer before accessing the device after reset

Alex Maftei (amaftei) <amaftei@solarflare.com>
    sfc: fix timestamp reconstruction at 16-bit rollover points

Taehee Yoo <ap420073@gmail.com>
    net: rmnet: fix packet forwarding in rmnet bridge mode

Taehee Yoo <ap420073@gmail.com>
    net: rmnet: fix bridge mode bugs

Taehee Yoo <ap420073@gmail.com>
    net: rmnet: use upper/lower device infrastructure

Taehee Yoo <ap420073@gmail.com>
    net: rmnet: do not allow to change mux id if mux id is duplicated

Taehee Yoo <ap420073@gmail.com>
    net: rmnet: remove rcu_read_lock in rmnet_force_unassociate_device()

Taehee Yoo <ap420073@gmail.com>
    net: rmnet: fix suspicious RCU usage

Taehee Yoo <ap420073@gmail.com>
    net: rmnet: fix NULL pointer dereference in rmnet_changelink()

Taehee Yoo <ap420073@gmail.com>
    net: rmnet: fix NULL pointer dereference in rmnet_newlink()

Luo bin <luobin9@huawei.com>
    hinic: fix a bug of rss configuration

Luo bin <luobin9@huawei.com>
    hinic: fix a bug of setting hw_ioctxt

Luo bin <luobin9@huawei.com>
    hinic: fix a irq affinity bug

Antoine Tenart <antoine.tenart@bootlin.com>
    net: phy: mscc: fix firmware paths

yangerkun <yangerkun@huawei.com>
    slip: not call free_netdev before rtnl_unlock in slip_open

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    net: bcmgenet: Clear ID_MODE_DIS in EXT_RGMII_OOB_CTRL when not needed

Linus Torvalds <torvalds@linux-foundation.org>
    signal: avoid double atomic counter increments for user accounting

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: add dt_binding_check to PHONY in a correct place

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: add dtbs_check to PHONY

Jens Axboe <axboe@kernel.dk>
    io_uring: pick up link work on submit reference drop

Monk Liu <Monk.Liu@amd.com>
    drm/amdgpu: fix memory leak during TDR test(v2)

Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
    io_uring: fix poll_list race for SETUP_IOPOLL|SETUP_SQPOLL

Ming Lei <ming.lei@redhat.com>
    blk-mq: insert passthrough request into hctx->dispatch directly

Esben Haabendal <esben@geanix.com>
    net: ll_temac: Handle DMA halt condition caused by buffer underrun

Esben Haabendal <esben@geanix.com>
    net: ll_temac: Fix RX buffer descriptor handling on GFP_ATOMIC pressure

Esben Haabendal <esben@geanix.com>
    net: ll_temac: Add more error handling of dma_map_single() calls

Esben Haabendal <esben@geanix.com>
    net: ll_temac: Fix race condition causing TX hang

Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
    mac80211: rx: avoid RCU list traversal under mutex

Marek Vasut <marex@denx.de>
    net: ks8851-ml: Fix IRQ handling and locking

Daniele Palmas <dnlplm@gmail.com>
    net: usb: qmi_wwan: restore mtu min/max values after raw_ip switch

Igor Druzhinin <igor.druzhinin@citrix.com>
    scsi: libfc: free response frame from GPN_ID

Johannes Berg <johannes.berg@intel.com>
    cfg80211: check reg_rule for NULL in handle_channel_custom()

Tom Zanussi <zanussi@kernel.org>
    tracing: Fix number printing bug in print_synth_event()

Michael Ellerman <mpe@ellerman.id.au>
    selftests/rseq: Fix out-of-tree compilation

Heidi Fahim <heidifahim@google.com>
    kunit: run kunit_tool from any directory

Nathan Chancellor <natechancellor@gmail.com>
    MIPS: vdso: Wrap -mexplicit-relocs in cc-option

Greentime Hu <greentime.hu@sifive.com>
    riscv: set pmp configuration if kernel is running in M-mode

Hanno Zulla <kontakt@hanno.de>
    HID: hid-bigbenff: fix race condition for scheduled work during removal

Hanno Zulla <kontakt@hanno.de>
    HID: hid-bigbenff: call hid_hw_stop() in case of error

Hanno Zulla <kontakt@hanno.de>
    HID: hid-bigbenff: fix general protection fault caused by double kfree

Victor Kamensky <kamensky@cisco.com>
    mips: vdso: add build time check that no 'jalr t9' calls left

Paul Burton <paulburton@kernel.org>
    MIPS: Disable VDSO time functionality on microMIPS

Victor Kamensky <kamensky@cisco.com>
    mips: vdso: fix 'jalr t9' crash in vdso code

Kai-Heng Feng <kai.heng.feng@canonical.com>
    HID: i2c-hid: add Trekstor Surfbook E11B to descriptor override

Mika Westerberg <mika.westerberg@linux.intel.com>
    ACPI: watchdog: Set default timeout in probe

Mansour Behabadi <mansour@oxplot.com>
    HID: apple: Add support for recent firmware on Magic Keyboards

Jean Delvare <jdelvare@suse.de>
    ACPI: watchdog: Allow disabling WDAT at boot

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for erase/trim/discard

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for eMMC sleep command

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: sdhci-omap: Fix busy detection by enabling MMC_CAP_NEED_RSP_BUSY

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: sdhci-tegra: Fix busy detection by enabling MMC_CAP_NEED_RSP_BUSY

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Allow host controllers to require R1B for CMD6

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Default to generic_cmd6_time as timeout in __mmc_switch()

Linus Walleij <linus.walleij@linaro.org>
    pinctrl: qcom: ssbi-gpio: Fix fwspec parsing bug


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   4 +
 Makefile                                           |   7 +-
 arch/arm/Makefile                                  |   4 +-
 arch/arm/boot/compressed/Makefile                  |   4 +-
 arch/arm/kernel/vdso.c                             |   2 +
 arch/arm/lib/copy_from_user.S                      |   2 +-
 arch/mips/vdso/Makefile                            |  28 ++-
 arch/riscv/include/asm/csr.h                       |  12 ++
 arch/riscv/kernel/head.S                           |   6 +
 block/blk-flush.c                                  |   2 +-
 block/blk-mq-sched.c                               |  44 ++++-
 block/blk-mq.c                                     |  18 +-
 block/blk-mq.h                                     |   3 +-
 drivers/acpi/acpi_watchdog.c                       |  12 +-
 drivers/gpu/drm/amd/powerplay/smu_v11_0.c          |   6 +-
 drivers/hid/hid-apple.c                            |   3 +-
 drivers/hid/hid-bigbenff.c                         |  31 ++-
 drivers/hid/hid-google-hammer.c                    |   2 +
 drivers/hid/hid-ids.h                              |   2 +
 drivers/hid/hid-quirks.c                           |   1 +
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c           |   8 +
 drivers/mmc/core/core.c                            |   5 +-
 drivers/mmc/core/mmc.c                             |   7 +-
 drivers/mmc/core/mmc_ops.c                         |  27 ++-
 drivers/mmc/host/sdhci-omap.c                      |   3 +
 drivers/mmc/host/sdhci-tegra.c                     |   3 +
 drivers/net/dsa/mv88e6xxx/global1.c                |   4 +-
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |   1 +
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c   |   1 +
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h   |   2 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_if.h    |   1 +
 drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h    |   1 +
 drivers/net/ethernet/huawei/hinic/hinic_main.c     |   3 +-
 drivers/net/ethernet/huawei/hinic/hinic_rx.c       |   5 +-
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h       |   2 +-
 drivers/net/ethernet/micrel/ks8851_mll.c           |  14 +-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c | 186 +++++++++---------
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h |   3 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c   |   7 +-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c    |   8 -
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h    |   1 -
 drivers/net/ethernet/sfc/ptp.c                     |  38 +++-
 drivers/net/ethernet/xilinx/ll_temac.h             |   4 +
 drivers/net/ethernet/xilinx/ll_temac_main.c        | 209 +++++++++++++++++----
 drivers/net/phy/mscc.c                             |   4 +-
 drivers/net/slip/slip.c                            |   3 +
 drivers/net/usb/qmi_wwan.c                         |   3 +
 drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c           |   2 +-
 drivers/scsi/libfc/fc_disc.c                       |   2 +
 drivers/watchdog/wdat_wdt.c                        |  23 +++
 fs/io_uring.c                                      |  67 +++----
 fs/jbd2/transaction.c                              |   8 +-
 include/linux/mmc/host.h                           |   1 +
 kernel/signal.c                                    |  23 ++-
 kernel/trace/trace_events_hist.c                   |  32 +++-
 mm/slub.c                                          |   9 +
 net/ipv4/cipso_ipv4.c                              |   7 +-
 net/mac80211/rx.c                                  |   2 +-
 net/wireless/reg.c                                 |   2 +-
 tools/testing/kunit/kunit.py                       |  12 ++
 tools/testing/selftests/rseq/Makefile              |   2 +-
 61 files changed, 664 insertions(+), 274 deletions(-)


