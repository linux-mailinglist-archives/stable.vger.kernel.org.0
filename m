Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A882C061A
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730346AbgKWM1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:27:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:37708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730335AbgKWM1l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:27:41 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60F442076E;
        Mon, 23 Nov 2020 12:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134459;
        bh=Qat97L+bWeVV8OLI72pI8zhvdPOZgyFsDyBpeqVopEQ=;
        h=From:To:Cc:Subject:Date:From;
        b=IgYfyPVR1uICz8YgyM/NZ6tbFw/J8/cy3Z6T+Vdd9hlGGyPxhYCrXwVOqnQzNTDEb
         +/PMgug3fHPLAUznxtsbW2P2XXSmi/KtlG4rdJHgxRE6aGSOFs0Sr0xSEe7z1R7VkS
         jJw6m2q/irgkFsLAIidNpGxfrwwVykPtKW6nnhbE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.14 00/60] 4.14.209-rc1 review
Date:   Mon, 23 Nov 2020 13:21:42 +0100
Message-Id: <20201123121805.028396732@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.209-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.209-rc1
X-KernelTest-Deadline: 2020-11-25T12:18+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.209 release.
There are 60 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 25 Nov 2020 12:17:50 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.209-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.209-rc1

Chen Yu <yu.c.chen@intel.com>
    x86/microcode/intel: Check patch signature before saving microcode for early loading

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix null pointer dereference for ERP requests

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_sf.c: fix file permission for cpum_sfb_size

Johannes Berg <johannes.berg@intel.com>
    mac80211: free sta in sta_info_insert_finish() on errors

Felix Fietkau <nbd@nbd.name>
    mac80211: minstrel: fix tx status processing corner case

Felix Fietkau <nbd@nbd.name>
    mac80211: minstrel: remove deferred sampling code

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: disable preemption around cache alias management calls

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    regulator: workaround self-referent regulators

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    regulator: avoid resolve_supply() infinite recursion

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    regulator: fix memory leak with repeated set_machine_constraints()

Hans de Goede <hdegoede@redhat.com>
    iio: accel: kxcjk1013: Add support for KIOX010A ACPI DSM for setting tablet-mode

Hans de Goede <hdegoede@redhat.com>
    iio: accel: kxcjk1013: Replace is_smo8500_device with an acpi_type enum

Jan Kara <jack@suse.cz>
    ext4: fix bogus warning in ext4_update_dx_flag()

Brian O'Keefe <bokeefe@alum.wpi.edu>
    staging: rtl8723bs: Add 024c:0627 to the list of SDIO device-ids

Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>
    efivarfs: fix memory leak in efivarfs_create()

Fugang Duan <fugang.duan@nxp.com>
    tty: serial: imx: keep console clocks always on

Takashi Iwai <tiwai@suse.de>
    ALSA: mixart: Fix mutex deadlock

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: ctl: fix error path at adding user-defined element set

Samuel Thibault <samuel.thibault@ens-lyon.org>
    speakup: Do not let the line discipline be used several times

Daniel Axtens <dja@axtens.net>
    powerpc/uaccess-flush: fix missing includes in kup-radix.h

Yicong Yang <yangyicong@hisilicon.com>
    libfs: fix error cast of negative value in simple_attr_write()

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: revert "xfs: fix rmap key and record comparison functions"

Nishanth Menon <nm@ti.com>
    regulator: ti-abb: Fix array out of bound read access on the first transition

Zhang Qilong <zhangqilong3@huawei.com>
    MIPS: Alchemy: Fix memleak in alchemy_clk_setup_cpu

Srinivasa Rao Mandadapu <srivasam@codeaurora.org>
    ASoC: qcom: lpass-platform: Fix memory leak

Wu Bo <wubo.oduw@gmail.com>
    can: m_can: m_can_handle_state_change(): fix state change

Colin Ian King <colin.king@canonical.com>
    can: peak_usb: fix potential integer overflow on shift of a int

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcba_usb: mcba_usb_start_xmit(): first fill skb, then pass to can_put_echo_skb()

Zhang Qilong <zhangqilong3@huawei.com>
    can: ti_hecc: Fix memleak in ti_hecc_probe

Alejandro Concepcion Rodriguez <alejandro@acoro.eu>
    can: dev: can_restart(): post buffer from the right context

Anant Thazhemadam <anant.thazhemadam@gmail.com>
    can: af_can: prevent potential access of uninitialized member in canfd_rcv()

Anant Thazhemadam <anant.thazhemadam@gmail.com>
    can: af_can: prevent potential access of uninitialized member in can_rcv()

Leo Yan <leo.yan@linaro.org>
    perf lock: Don't free "lock_seq_stat" if read_count isn't zero

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx50-evk: Fix the chip select 1 IOMUX

Sergey Matyukevich <geomatsi@gmail.com>
    arm: dts: imx6qdl-udoo: fix rgmii phy-mode for ksz9031 phy

Randy Dunlap <rdunlap@infradead.org>
    MIPS: export has_transparent_hugepage() for modules

Dan Carpenter <dan.carpenter@oracle.com>
    Input: adxl34x - clean up a data type in adxl34x_probe()

Darrick J. Wong <darrick.wong@oracle.com>
    vfs: remove lockdep bogosity in __sb_start_write

Will Deacon <will@kernel.org>
    arm64: psci: Avoid printing in cpu_psci_cpu_die()

Jianqun Xu <jay.xu@rock-chips.com>
    pinctrl: rockchip: enable gpio pclk for rockchip_gpio_to_irq

Joel Stanley <joel@jms.id.au>
    net: ftgmac100: Fix crash when removing driver

Ryan Sharpelletti <sharpelletti@google.com>
    tcp: only postpone PROBE_RTT if RTT is < current min_rtt estimate

Filip Moc <dev@moc6.cz>
    net: usb: qmi_wwan: Set DTR quirk for MR400

Vladyslav Tarasiuk <vladyslavt@nvidia.com>
    net/mlx5: Disable QoS when min_rates on all VFs are zero

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

Florian Fainelli <f.fainelli@gmail.com>
    net: Have netpoll bring-up DSA management interface

Tobias Waldekranz <tobias@waldekranz.com>
    net: dsa: mv88e6xxx: Avoid VTU corruption on 6097

Heiner Kallweit <hkallweit1@gmail.com>
    net: bridge: add missing counters to ndo_get_stats64 callback

Zhang Changzhong <zhangchangzhong@huawei.com>
    net: b44: fix error return code in b44_init_one()

Ido Schimmel <idosch@nvidia.com>
    mlxsw: core: Use variable timeout for EMAD retries

Wang Hai <wanghai38@huawei.com>
    inet_diag: Fix error path to cancel the meseage in inet_req_diag_fill()

Wang Hai <wanghai38@huawei.com>
    devlink: Add missing genlmsg_cancel() in devlink_nl_sb_port_pool_fill()

Edwin Peer <edwin.peer@broadcom.com>
    bnxt_en: read EEPROM A2h address using page 0

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    atm: nicstar: Unmap DMA on send error

Zhang Changzhong <zhangchangzhong@huawei.com>
    ah6: fix error return code in ah6_input()


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/boot/dts/imx50-evk.dts                    |  2 +-
 arch/arm/boot/dts/imx6qdl-udoo.dtsi                |  2 +-
 arch/arm64/kernel/psci.c                           |  5 +-
 arch/mips/alchemy/common/clock.c                   |  9 +++-
 arch/mips/mm/tlb-r4k.c                             |  1 +
 arch/powerpc/include/asm/book3s/64/kup-radix.h     |  1 +
 arch/s390/kernel/perf_cpum_sf.c                    |  2 +-
 arch/x86/kernel/cpu/microcode/intel.c              | 63 ++++------------------
 arch/xtensa/mm/cache.c                             | 14 +++++
 drivers/atm/nicstar.c                              |  2 +
 drivers/iio/accel/kxcjk-1013.c                     | 51 ++++++++++++++++--
 drivers/input/misc/adxl34x.c                       |  2 +-
 drivers/net/can/dev.c                              |  2 +-
 drivers/net/can/m_can/m_can.c                      |  4 +-
 drivers/net/can/ti_hecc.c                          | 13 +++--
 drivers/net/can/usb/mcba_usb.c                     |  4 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |  4 +-
 drivers/net/dsa/mv88e6xxx/global1_vtu.c            | 59 ++++++++++++++++----
 drivers/net/ethernet/broadcom/b44.c                |  3 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |  2 +-
 drivers/net/ethernet/faraday/ftgmac100.c           |  4 ++
 drivers/net/ethernet/mellanox/mlx4/fw.c            |  6 +--
 drivers/net/ethernet/mellanox/mlx4/fw.h            |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  | 15 +++---
 drivers/net/ethernet/mellanox/mlxsw/core.c         |  3 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c  |  3 +-
 drivers/net/usb/qmi_wwan.c                         |  2 +-
 drivers/pinctrl/pinctrl-rockchip.c                 |  2 +
 drivers/regulator/core.c                           | 38 +++++++------
 drivers/regulator/ti-abb-regulator.c               | 12 ++++-
 drivers/s390/block/dasd.c                          |  6 +++
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c       |  1 +
 drivers/staging/speakup/spk_ttyio.c                |  9 ++++
 drivers/tty/serial/imx.c                           | 20 ++-----
 fs/efivarfs/super.c                                |  1 +
 fs/ext4/ext4.h                                     |  3 +-
 fs/libfs.c                                         |  6 ++-
 fs/super.c                                         | 33 ++----------
 fs/xfs/libxfs/xfs_rmap_btree.c                     | 16 +++---
 net/bridge/br_device.c                             |  1 +
 net/can/af_can.c                                   | 38 +++++++++----
 net/core/devlink.c                                 |  6 ++-
 net/core/netpoll.c                                 | 22 ++++++--
 net/ipv4/inet_diag.c                               |  4 +-
 net/ipv4/tcp_bbr.c                                 |  2 +-
 net/ipv6/ah6.c                                     |  3 +-
 net/mac80211/rc80211_minstrel.c                    | 27 ++--------
 net/mac80211/rc80211_minstrel.h                    |  1 -
 net/mac80211/sta_info.c                            | 14 ++---
 net/netlabel/netlabel_unlabeled.c                  | 17 ++++--
 net/sctp/input.c                                   |  4 +-
 net/sctp/sm_sideeffect.c                           |  4 +-
 net/sctp/transport.c                               |  2 +-
 net/x25/af_x25.c                                   |  1 +
 sound/core/control.c                               |  2 +-
 sound/pci/mixart/mixart_core.c                     |  5 +-
 sound/soc/qcom/lpass-platform.c                    |  5 +-
 tools/perf/builtin-lock.c                          |  2 +-
 59 files changed, 343 insertions(+), 250 deletions(-)


