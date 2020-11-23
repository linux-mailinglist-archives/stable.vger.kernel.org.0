Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7481C2C0586
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729564AbgKWMXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:23:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:60192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729534AbgKWMXL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:23:11 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1B6720728;
        Mon, 23 Nov 2020 12:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134189;
        bh=9YFcb3euWNz8S0TbxSYJvcFuziPDxC11xbBnD+Qguls=;
        h=From:To:Cc:Subject:Date:From;
        b=Il5D+Vu/FRC5O4K2rcCBd2ZJJuqGCiwyNukUNqAV5xwbfzm6kxtJz6CLTyv3QP6JJ
         iONlskyW8oAEAu8GMiYizvOfkzq24yuVncOVdaoFB/hxZcKwc1hXM/LuCGDFlQL72q
         FGregI3Uk5Sq/pPT26trLECqgH9BbF1AQ2NCKzcg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.4 00/38] 4.4.246-rc1 review
Date:   Mon, 23 Nov 2020 13:21:46 +0100
Message-Id: <20201123121804.306030358@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.246-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.246-rc1
X-KernelTest-Deadline: 2020-11-25T12:18+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.246 release.
There are 38 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 25 Nov 2020 12:17:50 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.246-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.246-rc1

Chen Yu <yu.c.chen@intel.com>
    x86/microcode/intel: Check patch signature before saving microcode for early loading

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_sf.c: fix file permission for cpum_sfb_size

Johannes Berg <johannes.berg@intel.com>
    mac80211: free sta in sta_info_insert_finish() on errors

Johannes Berg <johannes.berg@intel.com>
    mac80211: allow driver to prevent two stations w/ same address

Felix Fietkau <nbd@nbd.name>
    mac80211: minstrel: fix tx status processing corner case

Felix Fietkau <nbd@nbd.name>
    mac80211: minstrel: remove deferred sampling code

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: disable preemption around cache alias management calls

Jan Kara <jack@suse.cz>
    ext4: fix bogus warning in ext4_update_dx_flag()

Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>
    efivarfs: fix memory leak in efivarfs_create()

Fugang Duan <fugang.duan@nxp.com>
    tty: serial: imx: keep console clocks always on

Takashi Iwai <tiwai@suse.de>
    ALSA: mixart: Fix mutex deadlock

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: ctl: fix error path at adding user-defined element set

Daniel Axtens <dja@axtens.net>
    powerpc/uaccess-flush: fix corenet64_smp_defconfig build

Yicong Yang <yangyicong@hisilicon.com>
    libfs: fix error cast of negative value in simple_attr_write()

Nishanth Menon <nm@ti.com>
    regulator: ti-abb: Fix array out of bound read access on the first transition

Zhang Qilong <zhangqilong3@huawei.com>
    MIPS: Alchemy: Fix memleak in alchemy_clk_setup_cpu

Wu Bo <wubo.oduw@gmail.com>
    can: m_can: m_can_handle_state_change(): fix state change

Colin Ian King <colin.king@canonical.com>
    can: peak_usb: fix potential integer overflow on shift of a int

Alejandro Concepcion Rodriguez <alejandro@acoro.eu>
    can: dev: can_restart(): post buffer from the right context

Leo Yan <leo.yan@linaro.org>
    perf lock: Don't free "lock_seq_stat" if read_count isn't zero

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx50-evk: Fix the chip select 1 IOMUX

Sergey Matyukevich <geomatsi@gmail.com>
    arm: dts: imx6qdl-udoo: fix rgmii phy-mode for ksz9031 phy

Dan Carpenter <dan.carpenter@oracle.com>
    Input: adxl34x - clean up a data type in adxl34x_probe()

Paul Burton <paul.burton@imgtec.com>
    MIPS: Fix BUILD_ROLLBACK_PROLOGUE for microMIPS

Will Deacon <will@kernel.org>
    arm64: psci: Avoid printing in cpu_psci_cpu_die()

Jianqun Xu <jay.xu@rock-chips.com>
    pinctrl: rockchip: enable gpio pclk for rockchip_gpio_to_irq

Florian Fainelli <f.fainelli@gmail.com>
    net: Have netpoll bring-up DSA management interface

Filip Moc <dev@moc6.cz>
    net: usb: qmi_wwan: Set DTR quirk for MR400

Xin Long <lucien.xin@gmail.com>
    sctp: change to hold/put transport for proto_unreach_timer

Zhang Changzhong <zhangchangzhong@huawei.com>
    qlcnic: fix error return code in qlcnic_83xx_restart_hw()

Xie He <xie.he.0141@gmail.com>
    net: x25: Increase refcnt of "struct x25_neigh" in x25_rx_call_request

Aya Levin <ayal@nvidia.com>
    net/mlx4_core: Fix init_hca fields offset

Paul Moore <paul@paul-moore.com>
    netlabel: fix an uninitialized warning in netlbl_unlabel_staticlist()

Paul Moore <paul@paul-moore.com>
    netlabel: fix our progress tracking in netlbl_unlabel_staticlist()

Heiner Kallweit <hkallweit1@gmail.com>
    net: bridge: add missing counters to ndo_get_stats64 callback

Zhang Changzhong <zhangchangzhong@huawei.com>
    net: b44: fix error return code in b44_init_one()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    atm: nicstar: Unmap DMA on send error

Zhang Changzhong <zhangchangzhong@huawei.com>
    ah6: fix error return code in ah6_input()


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/boot/dts/imx50-evk.dts                    |  2 +-
 arch/arm/boot/dts/imx6qdl-udoo.dtsi                |  2 +-
 arch/arm64/kernel/psci.c                           |  5 +--
 arch/mips/alchemy/common/clock.c                   |  9 +++-
 arch/mips/kernel/genex.S                           |  3 +-
 arch/powerpc/kernel/ppc_ksyms.c                    |  4 +-
 arch/s390/kernel/perf_cpum_sf.c                    |  2 +-
 arch/x86/kernel/cpu/microcode/intel.c              | 49 +---------------------
 arch/xtensa/mm/cache.c                             | 14 +++++++
 drivers/atm/nicstar.c                              |  2 +
 drivers/input/misc/adxl34x.c                       |  2 +-
 drivers/net/can/dev.c                              |  2 +-
 drivers/net/can/m_can/m_can.c                      |  4 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |  4 +-
 drivers/net/ethernet/broadcom/b44.c                |  3 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c            |  6 +--
 drivers/net/ethernet/mellanox/mlx4/fw.h            |  4 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c  |  3 +-
 drivers/net/usb/qmi_wwan.c                         |  2 +-
 drivers/pinctrl/pinctrl-rockchip.c                 |  2 +
 drivers/regulator/ti-abb-regulator.c               | 12 +++++-
 drivers/tty/serial/imx.c                           | 20 ++-------
 fs/efivarfs/super.c                                |  1 +
 fs/ext4/ext4.h                                     |  3 +-
 fs/libfs.c                                         |  6 ++-
 include/net/mac80211.h                             |  6 +++
 net/bridge/br_device.c                             |  1 +
 net/core/netpoll.c                                 | 22 ++++++++--
 net/ipv6/ah6.c                                     |  3 +-
 net/mac80211/debugfs.c                             |  1 +
 net/mac80211/rc80211_minstrel.c                    | 27 +++---------
 net/mac80211/rc80211_minstrel.h                    |  1 -
 net/mac80211/sta_info.c                            | 32 ++++++++------
 net/netlabel/netlabel_unlabeled.c                  | 17 +++++---
 net/sctp/input.c                                   |  4 +-
 net/sctp/sm_sideeffect.c                           |  4 +-
 net/sctp/transport.c                               |  2 +-
 net/x25/af_x25.c                                   |  1 +
 sound/core/control.c                               |  2 +-
 sound/pci/mixart/mixart_core.c                     |  5 +--
 tools/perf/builtin-lock.c                          |  2 +-
 42 files changed, 149 insertions(+), 151 deletions(-)


