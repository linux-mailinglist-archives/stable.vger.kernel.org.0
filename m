Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B67502C064B
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730612AbgKWM3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:29:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:40138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730617AbgKWM3h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:29:37 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 480FB20888;
        Mon, 23 Nov 2020 12:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134574;
        bh=3ucvmtTkzvGFNSIxje5KGISqq9VMpXHofgiAaS8qmw0=;
        h=From:To:Cc:Subject:Date:From;
        b=OTk6/7yoAByNbnW/IskP14fP8jZlXMbw2H5req81uaVPA6Ts7CKyNlPji2Le7Ggjq
         PcmLLYkEP9AyherO9SfD3so88XSQLAHjszFeXZVFEPV+xk4kh1g0bv/ztkBKpQrM4Q
         DI8eEIui7RoMALIlRAV9FdKv0U2+A3v84EWmKfoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.19 00/91] 4.19.160-rc1 review
Date:   Mon, 23 Nov 2020 13:21:20 +0100
Message-Id: <20201123121809.285416732@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.160-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.160-rc1
X-KernelTest-Deadline: 2020-11-25T12:18+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.160 release.
There are 91 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 25 Nov 2020 12:17:50 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.160-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.160-rc1

Gerald Schaefer <gerald.schaefer@linux.ibm.com>
    mm/userfaultfd: do not access vma->vm_mm after calling handle_userfault()

Chen Yu <yu.c.chen@intel.com>
    x86/microcode/intel: Check patch signature before saving microcode for early loading

Mickaël Salaün <mic@linux.microsoft.com>
    seccomp: Set PF_SUPERPRIV when checking capability

Mickaël Salaün <mic@linux.microsoft.com>
    ptrace: Set PF_SUPERPRIV when checking capability

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

Sean Nyekjaer <sean@geanix.com>
    regulator: pfuze100: limit pfuze-support-disable-sw to pfuze{100,200}

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

PeiSen Hou <pshou@realtek.com>
    ALSA: hda/realtek: Add some Clove SSID in the ALC293(ALC1220)

Takashi Iwai <tiwai@suse.de>
    ALSA: mixart: Fix mutex deadlock

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: ctl: fix error path at adding user-defined element set

Joakim Tjernlund <joakim.tjernlund@infinera.com>
    ALSA: usb-audio: Add delay quirk for all Logitech USB devices

Dan Carpenter <dan.carpenter@oracle.com>
    ALSA: firewire: Clean up a locking issue in copy_resp_to_buf()

Samuel Thibault <samuel.thibault@ens-lyon.org>
    speakup: Do not let the line discipline be used several times

Yicong Yang <yangyicong@hisilicon.com>
    libfs: fix error cast of negative value in simple_attr_write()

Arvind Sankar <nivedita@alum.mit.edu>
    efi/x86: Free efi_pgd with free_pages()

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: revert "xfs: fix rmap key and record comparison functions"

Luo Meng <luomeng12@huawei.com>
    fail_function: Remove a redundant mutex unlock

Nishanth Menon <nm@ti.com>
    regulator: ti-abb: Fix array out of bound read access on the first transition

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: strengthen rmap record flags checking

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix the minrecs logic when dealing with inode root child blocks

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: kvaser_usb_hydra: Fix KCAN bittiming limits

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    drm/sun4i: dw-hdmi: fix error return code in sun8i_dw_hdmi_bind()

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

Yi-Hung Wei <yihung.wei@gmail.com>
    ip_tunnels: Set tunnel option flag when tunnel metadata is present

Leo Yan <leo.yan@linaro.org>
    perf lock: Don't free "lock_seq_stat" if read_count isn't zero

Necip Fazil Yildiran <fazilyildiran@gmail.com>
    Input: resistive-adc-touch - fix kconfig dependency on IIO_BUFFER

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx50-evk: Fix the chip select 1 IOMUX

Sergey Matyukevich <geomatsi@gmail.com>
    arm: dts: imx6qdl-udoo: fix rgmii phy-mode for ksz9031 phy

Nenad Peric <nperic@gmail.com>
    arm64: dts: allwinner: h5: OrangePi Prime: Fix ethernet node

Randy Dunlap <rdunlap@infradead.org>
    MIPS: export has_transparent_hugepage() for modules

Dan Carpenter <dan.carpenter@oracle.com>
    Input: adxl34x - clean up a data type in adxl34x_probe()

Chen-Yu Tsai <wens@csie.org>
    arm64: dts: allwinner: a64: bananapi-m64: Enable RGMII RX/TX delay on PHY

Chen-Yu Tsai <wens@csie.org>
    ARM: dts: sun8i: a83t: Enable both RGMII RX/TX delay on Ethernet PHY

Chen-Yu Tsai <wens@csie.org>
    ARM: dts: sun8i: h3: orangepi-plus2e: Enable RGMII RX/TX delay on Ethernet PHY

Chen-Yu Tsai <wens@csie.org>
    Revert "arm: sun8i: orangepi-pc-plus: Set EMAC activity LEDs to active high"

Jernej Skrabec <jernej.skrabec@siol.net>
    ARM: dts: sun8i: r40: bananapi-m2-ultra: Fix ethernet node

Jernej Skrabec <jernej.skrabec@siol.net>
    arm64: dts: allwinner: h5: OrangePi PC2: Fix ethernet node

Jernej Skrabec <jernej.skrabec@siol.net>
    arm64: dts: allwinner: a64: Pine64 Plus: Fix ethernet node

Darrick J. Wong <darrick.wong@oracle.com>
    vfs: remove lockdep bogosity in __sb_start_write

Will Deacon <will@kernel.org>
    arm64: psci: Avoid printing in cpu_psci_cpu_die()

Hans de Goede <hdegoede@redhat.com>
    ACPI: button: Add DMI quirk for Medion Akoya E2228T

Aaron Lewis <aaronlewis@google.com>
    selftests: kvm: Fix the segment descriptor layout to match the actual layout

Can Guo <cang@codeaurora.org>
    scsi: ufs: Fix unbalanced scsi_block_reqs_cnt caused by ufshcd_hold()

Jianqun Xu <jay.xu@rock-chips.com>
    pinctrl: rockchip: enable gpio pclk for rockchip_gpio_to_irq

Joel Stanley <joel@jms.id.au>
    net: ftgmac100: Fix crash when removing driver

Joel Stanley <joel@jms.id.au>
    net/ncsi: Fix netlink registration

Filip Moc <dev@moc6.cz>
    net: usb: qmi_wwan: Set DTR quirk for MR400

Vladyslav Tarasiuk <vladyslavt@nvidia.com>
    net/mlx5: Disable QoS when min_rates on all VFs are zero

Ryan Sharpelletti <sharpelletti@google.com>
    tcp: only postpone PROBE_RTT if RTT is < current min_rtt estimate

Xin Long <lucien.xin@gmail.com>
    sctp: change to hold/put transport for proto_unreach_timer

Zhang Changzhong <zhangchangzhong@huawei.com>
    qlcnic: fix error return code in qlcnic_83xx_restart_hw()

Zhang Changzhong <zhangchangzhong@huawei.com>
    qed: fix error return code in qed_iwarp_ll2_start()

Dongli Zhang <dongli.zhang@oracle.com>
    page_frag: Recover from memory pressure

Xie He <xie.he.0141@gmail.com>
    net: x25: Increase refcnt of "struct x25_neigh" in x25_rx_call_request

Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
    net: qualcomm: rmnet: Fix incorrect receive packet handling during cleanup

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

Sven Van Asbroeck <thesven73@gmail.com>
    lan743x: prevent entire kernel HANG on open, for some platforms

Sven Van Asbroeck <thesven73@gmail.com>
    lan743x: fix issue causing intermittent kernel log warnings

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
 arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts       |  2 +-
 arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dts   |  2 +-
 arch/arm/boot/dts/sun8i-h3-orangepi-pc-plus.dts    |  5 --
 arch/arm/boot/dts/sun8i-h3-orangepi-plus2e.dts     |  2 +-
 arch/arm/boot/dts/sun8i-r40-bananapi-m2-ultra.dts  |  2 +-
 .../boot/dts/allwinner/sun50i-a64-bananapi-m64.dts |  2 +-
 .../boot/dts/allwinner/sun50i-a64-pine64-plus.dts  |  2 +-
 .../boot/dts/allwinner/sun50i-h5-orangepi-pc2.dts  |  2 +-
 .../dts/allwinner/sun50i-h5-orangepi-prime.dts     |  2 +-
 arch/arm64/kernel/psci.c                           |  5 +-
 arch/mips/alchemy/common/clock.c                   |  9 +++-
 arch/mips/mm/tlb-r4k.c                             |  1 +
 arch/s390/kernel/perf_cpum_sf.c                    |  2 +-
 arch/x86/kernel/cpu/microcode/intel.c              | 63 ++++------------------
 arch/x86/platform/efi/efi_64.c                     | 24 +++++----
 arch/xtensa/mm/cache.c                             | 14 +++++
 drivers/acpi/button.c                              | 13 ++++-
 drivers/atm/nicstar.c                              |  2 +
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c              |  1 +
 drivers/iio/accel/kxcjk-1013.c                     | 51 ++++++++++++++++--
 drivers/input/misc/adxl34x.c                       |  2 +-
 drivers/input/touchscreen/Kconfig                  |  1 +
 drivers/net/can/dev.c                              |  2 +-
 drivers/net/can/m_can/m_can.c                      |  4 +-
 drivers/net/can/ti_hecc.c                          | 13 +++--
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |  2 +-
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
 drivers/net/ethernet/microchip/lan743x_main.c      | 13 ++---
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c        | 12 +++--
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c  |  3 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c   |  5 ++
 drivers/net/geneve.c                               |  3 +-
 drivers/net/usb/qmi_wwan.c                         |  2 +-
 drivers/pinctrl/pinctrl-rockchip.c                 |  2 +
 drivers/regulator/core.c                           | 38 +++++++------
 drivers/regulator/pfuze100-regulator.c             | 13 +++--
 drivers/regulator/ti-abb-regulator.c               | 12 ++++-
 drivers/s390/block/dasd.c                          |  6 +++
 drivers/scsi/ufs/ufshcd.c                          |  6 +--
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c       |  1 +
 drivers/staging/speakup/spk_ttyio.c                | 12 ++++-
 drivers/tty/serial/imx.c                           | 20 ++-----
 fs/efivarfs/super.c                                |  1 +
 fs/ext4/ext4.h                                     |  3 +-
 fs/libfs.c                                         |  6 ++-
 fs/super.c                                         | 33 ++----------
 fs/xfs/libxfs/xfs_rmap_btree.c                     | 16 +++---
 fs/xfs/scrub/bmap.c                                |  8 +--
 fs/xfs/scrub/btree.c                               | 45 +++++++++-------
 include/net/ip_tunnels.h                           |  7 +--
 kernel/fail_function.c                             |  5 +-
 kernel/ptrace.c                                    | 16 ++----
 kernel/seccomp.c                                   |  5 +-
 mm/huge_memory.c                                   |  9 ++--
 mm/page_alloc.c                                    |  5 ++
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
 net/ncsi/ncsi-manage.c                             |  5 --
 net/ncsi/ncsi-netlink.c                            | 22 ++------
 net/ncsi/ncsi-netlink.h                            |  3 --
 net/netlabel/netlabel_unlabeled.c                  | 17 ++++--
 net/sctp/input.c                                   |  4 +-
 net/sctp/sm_sideeffect.c                           |  4 +-
 net/sctp/transport.c                               |  2 +-
 net/x25/af_x25.c                                   |  1 +
 sound/core/control.c                               |  2 +-
 sound/firewire/fireworks/fireworks_transaction.c   |  4 +-
 sound/pci/hda/patch_realtek.c                      | 50 ++++++++++++++++-
 sound/pci/mixart/mixart_core.c                     |  5 +-
 sound/soc/qcom/lpass-platform.c                    |  5 +-
 sound/usb/quirks.c                                 | 10 ++--
 tools/perf/builtin-lock.c                          |  2 +-
 tools/testing/selftests/kvm/include/x86.h          |  2 +-
 tools/testing/selftests/kvm/lib/x86.c              |  3 +-
 94 files changed, 529 insertions(+), 379 deletions(-)


