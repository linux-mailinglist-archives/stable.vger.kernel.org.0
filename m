Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C95B818B5AD
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729996AbgCSNUh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:20:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729711AbgCSNUf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:20:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DB042098B;
        Thu, 19 Mar 2020 13:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624034;
        bh=9FhS4WoRomzdaZirV/g0kUW243kaPNjpofYoUHvYWVc=;
        h=From:To:Cc:Subject:Date:From;
        b=bMHZDawqcrft2DgL6y9BvZyCJ0Mo8bSL8SdseNfboJchcAdaejFAvekTZCHcvM8fv
         FjFjcxP8qJDv5L8jgWEgIHC60qL5CNZm5Eor/o7XIvWH2depVy/jF6nyS1AF23EqIF
         XavXDP1h/mfP2Q1s0yxHZIUumYxB/dTZF9R277hc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/48] 4.19.112-rc1 review
Date:   Thu, 19 Mar 2020 14:03:42 +0100
Message-Id: <20200319123902.941451241@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.112-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.112-rc1
X-KernelTest-Deadline: 2020-03-21T12:39+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.112 release.
There are 48 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 21 Mar 2020 12:37:04 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.112-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.112-rc1

Matteo Croce <mcroce@redhat.com>
    ipv4: ensure rcu_read_lock() in cipso_v4_error()

Waiman Long <longman@redhat.com>
    efi: Fix debugobjects warning on 'efi_rts_work'

Chen-Tsung Hsieh <chentsung@chromium.org>
    HID: google: add moonball USB id

Jann Horn <jannh@google.com>
    mm: slub: add missing TID bump in kmem_cache_alloc_bulk()

Kees Cook <keescook@chromium.org>
    ARM: 8958/1: rename missed uaccess .fixup section

Florian Fainelli <f.fainelli@gmail.com>
    ARM: 8957/1: VDSO: Match ARMv8 timer in cntvct_functional()

Carl Huang <cjhuang@codeaurora.org>
    net: qrtr: fix len of skb_put_padto in qrtr_node_enqueue

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    driver core: Fix creation of device links with PM-runtime flags

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    driver core: Remove device link creation limitation

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    driver core: Add device link flag DL_FLAG_AUTOPROBE_CONSUMER

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    driver core: Make driver core own stateful device links

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    driver core: Fix adding device links to probing suppliers

Yong Wu <yong.wu@mediatek.com>
    driver core: Remove the link if there is no driver with AUTO flag

Faiz Abbas <faiz_abbas@ti.com>
    mmc: sdhci-omap: Fix Tuning procedure for temperatures < -20C

Faiz Abbas <faiz_abbas@ti.com>
    mmc: sdhci-omap: Don't finish_mrq() on a command error during tuning

Navid Emamdoost <navid.emamdoost@gmail.com>
    wimax: i2400: Fix memory leak in i2400m_op_rfkill_sw_toggle

Navid Emamdoost <navid.emamdoost@gmail.com>
    wimax: i2400: fix memory leak

Qian Cai <cai@lca.pw>
    jbd2: fix data races at struct journal_head

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
    hinic: fix a bug of setting hw_ioctxt

Luo bin <luobin9@huawei.com>
    hinic: fix a irq affinity bug

yangerkun <yangerkun@huawei.com>
    slip: not call free_netdev before rtnl_unlock in slip_open

Linus Torvalds <torvalds@linux-foundation.org>
    signal: avoid double atomic counter increments for user accounting

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

Kai-Heng Feng <kai.heng.feng@canonical.com>
    HID: i2c-hid: add Trekstor Surfbook E11B to descriptor override

Mansour Behabadi <mansour@oxplot.com>
    HID: apple: Add support for recent firmware on Magic Keyboards

Jean Delvare <jdelvare@suse.de>
    ACPI: watchdog: Allow disabling WDAT at boot

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Allow host controllers to require R1B for CMD6

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for erase/trim/discard

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for eMMC sleep command

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: sdhci-omap: Fix busy detection by enabling MMC_CAP_NEED_RSP_BUSY

Faiz Abbas <faiz_abbas@ti.com>
    mmc: host: Fix Kconfig warnings on keystone_defconfig

Faiz Abbas <faiz_abbas@ti.com>
    mmc: sdhci-omap: Workaround errata regarding SDR104/HS200 tuning failures (i929)

Faiz Abbas <faiz_abbas@ti.com>
    mmc: sdhci-omap: Add platform specific reset callback

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Default to generic_cmd6_time as timeout in __mmc_switch()

Kim Phillips <kim.phillips@amd.com>
    perf/amd/uncore: Replace manual sampling check with CAP_NO_INTERRUPT flag


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   4 +
 Documentation/driver-api/device_link.rst           |  63 +++--
 Makefile                                           |   4 +-
 arch/arm/kernel/vdso.c                             |   2 +
 arch/arm/lib/copy_from_user.S                      |   2 +-
 arch/x86/events/amd/uncore.c                       |  14 +-
 drivers/acpi/acpi_watchdog.c                       |  12 +-
 drivers/base/core.c                                | 293 +++++++++++++++------
 drivers/base/dd.c                                  |   2 +-
 drivers/base/power/runtime.c                       |   4 +-
 drivers/firmware/efi/runtime-wrappers.c            |   2 +-
 drivers/hid/hid-apple.c                            |   3 +-
 drivers/hid/hid-google-hammer.c                    |   2 +
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c           |   8 +
 drivers/mmc/core/core.c                            |   5 +-
 drivers/mmc/core/mmc.c                             |   7 +-
 drivers/mmc/core/mmc_ops.c                         |  27 +-
 drivers/mmc/host/Kconfig                           |   2 +
 drivers/mmc/host/sdhci-omap.c                      | 151 ++++++++++-
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c   |   1 +
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h   |   2 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_if.h    |   1 +
 drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h    |   1 +
 drivers/net/ethernet/huawei/hinic/hinic_rx.c       |   5 +-
 drivers/net/ethernet/micrel/ks8851_mll.c           |  14 +-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c | 186 +++++++------
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h |   3 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c   |   7 +-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c    |   8 -
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h    |   1 -
 drivers/net/ethernet/sfc/ptp.c                     |  38 ++-
 drivers/net/slip/slip.c                            |   3 +
 drivers/net/usb/qmi_wwan.c                         |   3 +
 drivers/net/wimax/i2400m/op-rfkill.c               |   1 +
 drivers/scsi/libfc/fc_disc.c                       |   2 +
 fs/jbd2/transaction.c                              |   8 +-
 include/linux/device.h                             |   7 +-
 include/linux/mmc/host.h                           |   1 +
 kernel/signal.c                                    |  23 +-
 mm/slub.c                                          |   9 +
 net/ipv4/cipso_ipv4.c                              |   7 +-
 net/mac80211/rx.c                                  |   2 +-
 net/qrtr/qrtr.c                                    |   2 +-
 net/wireless/reg.c                                 |   2 +-
 45 files changed, 672 insertions(+), 273 deletions(-)


