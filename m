Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B76971B0B5A
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbgDTMz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:55:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728811AbgDTMpo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:45:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08CAB206E9;
        Mon, 20 Apr 2020 12:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386743;
        bh=SfY5VTNKawoKemxiN0t1dRyqfcEs/PSemQwySXle0ic=;
        h=From:To:Cc:Subject:Date:From;
        b=E4jynkmCo4Jn03jSvivyzZf6FcP/kuf4PDfCe43gJAW2Tasb67C0n+ZdB28FCkYja
         NOejPrXG5Unuw+3frDKvbkILhn0Vf2EKYtpXgMhg5IbC9+QJ17QRRiP05R/IVLkYHO
         csJqkN8QiGzF17WoQOM/JSOll95Q+bs71oA44Gtg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 00/60] 5.4.34-rc1 review
Date:   Mon, 20 Apr 2020 14:38:38 +0200
Message-Id: <20200420121500.490651540@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.34-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.34-rc1
X-KernelTest-Deadline: 2020-04-22T12:15+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.34 release.
There are 60 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 22 Apr 2020 12:10:36 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.34-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.34-rc1

John Allen <john.allen@amd.com>
    x86/microcode/AMD: Increase microcode PATCH_MAX_SIZE

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: fix hang when multiple threads try to destroy the same iscsi session

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: remove boilerplate code

Reinette Chatre <reinette.chatre@intel.com>
    x86/resctrl: Fix invalid attempt at removing the default resource group

James Morse <james.morse@arm.com>
    x86/resctrl: Preserve CDP enable over CPU hotplug

Grygorii Strashko <grygorii.strashko@ti.com>
    irqchip/ti-sci-inta: Fix processing of masked irqs

Jan Kara <jack@suse.cz>
    ext4: do not zeroout extents beyond i_disksize

Hans de Goede <hdegoede@redhat.com>
    i2c: designware: platdrv: Remove DPM_FLAG_SMART_SUSPEND flag on BYT and CHT

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu: fix the hw hang during perform system reboot and reset

Sergei Lopatin <magist3r@gmail.com>
    drm/amd/powerplay: force the trim of the mclk dpm_levels if OD is enabled

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/mlx5e: Use preactivate hook to set the indirection table

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/mlx5e: Rename hw_modify to preactivate

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/mlx5e: Encapsulate updating netdev queues into a function

Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
    mac80211_hwsim: Use kstrndup() in place of kasprintf()

Sumit Garg <sumit.garg@linaro.org>
    mac80211: fix race in ieee80211_register_hw()

Johannes Berg <johannes.berg@intel.com>
    nl80211: fix NL80211_ATTR_FTM_RESPONDER policy

Josef Bacik <josef@toxicpanda.com>
    btrfs: check commit root generation in should_ignore_root

Xiao Yang <yangx.jy@cn.fujitsu.com>
    tracing: Fix the race between registering 'snapshot' event trigger and triggering 'snapshot' operation

Vasily Averin <vvs@virtuozzo.com>
    keys: Fix proc_keys_next to increase position index

Mark Rutland <mark.rutland@arm.com>
    arm64: vdso: don't free unallocated pages

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Check mapping at creating connector controls, too

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Don't create jack controls for PCM terminals

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Don't override ignore_ctl_error value from the map

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Filter error from connector kctl ops, too

Adam Barber <barberadam995@gmail.com>
    ALSA: hda/realtek - Enable the headset mic on Asus FX505DT

Colin Ian King <colin.king@canonical.com>
    ASoC: Intel: mrfld: return error codes when an error occurs

Colin Ian King <colin.king@canonical.com>
    ASoC: Intel: mrfld: fix incorrect check on p->sink

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Don't clear flags before transfer ended

Angus Ainslie (Purism) <angus@akkea.ca>
    arm64: dts: librem5-devkit: add a vbus supply to usb0

Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
    ARM: dts: imx7-colibri: fix muxing of usbc_det pin

Claudiu Beznea <claudiu.beznea@microchip.com>
    clk: at91: usb: use proper usbs_mask

Claudiu Beznea <claudiu.beznea@microchip.com>
    clk: at91: sam9x60: fix usb clock parents

Josh Triplett <josh@joshtriplett.org>
    ext4: fix incorrect inodes per group in error message

Josh Triplett <josh@joshtriplett.org>
    ext4: fix incorrect group count in ext4_fill_super error message

Bruno Meneguele <bmeneg@redhat.com>
    net/bpfilter: remove superfluous testing message

Sven Van Asbroeck <TheSven73@gmail.com>
    pwm: pca9685: Fix PWM/GPIO inter-operation

Jin Yao <yao.jin@linux.intel.com>
    perf report: Fix no branch type statistics report issue

Dan Carpenter <dan.carpenter@oracle.com>
    acpi/nfit: improve bounds checking for 'func'

zhangyi (F) <yi.zhang@huawei.com>
    jbd2: improve comments about freeing data buffers whose page mapping is NULL

Pi-Hsun Shih <pihsun@chromium.org>
    platform/chrome: cros_ec_rpmsg: Fix race with host event

Can Guo <cang@codeaurora.org>
    scsi: ufs: Fix ufshcd_hold() caused scheduling while atomic

Amir Goldstein <amir73il@gmail.com>
    ovl: fix value of i_ino for lower hardlink corner case

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "ACPI: EC: Do not clear boot_ec_is_ecdt in acpi_ec_add()"

Florian Fainelli <f.fainelli@gmail.com>
    net: stmmac: dwmac-sunxi: Provide TX and RX fifo sizes

Parav Pandit <parav@mellanox.com>
    net/mlx5e: Fix pfnum in devlink port attribute

Dmytro Linkin <dmitrolin@mellanox.com>
    net/mlx5e: Fix nest_level for vlan pop action

Eran Ben Elisha <eranbe@mellanox.com>
    net/mlx5e: Add missing release firmware call

Moshe Shemesh <moshe@mellanox.com>
    net/mlx5: Fix frequent ioread PCI access during recovery

René van Dorst <opensource@vdorst.com>
    net: ethernet: mediatek: move mt7623 settings out off the mt7530

René van Dorst <opensource@vdorst.com>
    net: dsa: mt7530: move mt7623 settings out off the mt7530

Gilberto Bertin <me@jibi.io>
    net: tun: record RX queue in skb before do_xdp_generic()

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    net: revert default NAPI poll timeout to 2 jiffies

Wang Wenhu <wenhu.wang@vivo.com>
    net: qrtr: send msgs from local of same id as broadcast

Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
    net: phy: micrel: use genphy_read_status for KSZ9131

Tim Stallard <code@timstallard.me.uk>
    net: ipv6: do not consider routes via gateways for anycast address check

Taras Chornyi <taras.chornyi@plvision.eu>
    net: ipv4: devinet: Fix crash when add/del multicast IP with autojoin

DENG Qingfang <dqfext@gmail.com>
    net: dsa: mt7530: fix tagged frames pass-through in VLAN-unaware mode

Michael Weiß <michael.weiss@aisec.fraunhofer.de>
    l2tp: Allow management of tunnels and session in user namespace

Taehee Yoo <ap420073@gmail.com>
    hsr: check protocol version in hsr_newlink()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    amd-xgbe: Use __napi_schedule() in BH context


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/imx7-colibri.dtsi                |   9 +-
 .../boot/dts/freescale/imx8mq-librem5-devkit.dts   |   1 +
 arch/arm64/kernel/vdso.c                           |  13 +--
 arch/x86/include/asm/microcode_amd.h               |   2 +-
 arch/x86/kernel/cpu/resctrl/core.c                 |   2 +
 arch/x86/kernel/cpu/resctrl/internal.h             |   1 +
 arch/x86/kernel/cpu/resctrl/rdtgroup.c             |  16 +++-
 drivers/acpi/ec.c                                  |   6 +-
 drivers/acpi/nfit/core.c                           |  10 +-
 drivers/acpi/nfit/nfit.h                           |   1 +
 drivers/clk/at91/clk-usb.c                         |   2 +-
 drivers/clk/at91/sam9x60.c                         |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   2 +
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c   |   5 +-
 drivers/i2c/busses/i2c-designware-platdrv.c        |  14 ++-
 drivers/irqchip/irq-ti-sci-inta.c                  |   3 +-
 drivers/net/dsa/mt7530.c                           | 103 +++------------------
 drivers/net/dsa/mt7530.h                           |  17 ++--
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |   2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  24 ++++-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |   8 ++
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   7 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  49 +++++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c  |   2 +
 drivers/net/phy/micrel.c                           |   2 +-
 drivers/net/tun.c                                  |   3 +-
 drivers/net/wireless/mac80211_hwsim.c              |  12 +--
 drivers/platform/chrome/cros_ec_rpmsg.c            |  16 +++-
 drivers/pwm/pwm-pca9685.c                          |  85 +++++++++--------
 drivers/scsi/ufs/ufshcd.c                          |   5 +
 drivers/target/iscsi/iscsi_target.c                |  79 +++++-----------
 drivers/target/iscsi/iscsi_target.h                |   1 -
 drivers/target/iscsi/iscsi_target_configfs.c       |   5 +-
 drivers/target/iscsi/iscsi_target_login.c          |   5 +-
 drivers/usb/dwc3/gadget.c                          |   4 +-
 fs/btrfs/relocation.c                              |   4 +-
 fs/ext4/extents.c                                  |   8 +-
 fs/ext4/super.c                                    |   6 +-
 fs/jbd2/commit.c                                   |   7 +-
 fs/overlayfs/inode.c                               |   4 +-
 include/net/ip6_route.h                            |   1 +
 include/target/iscsi/iscsi_target_core.h           |   2 +-
 kernel/trace/trace_events_trigger.c                |  10 +-
 net/bpfilter/main.c                                |   1 -
 net/core/dev.c                                     |   3 +-
 net/hsr/hsr_netlink.c                              |  10 +-
 net/ipv4/devinet.c                                 |  13 ++-
 net/l2tp/l2tp_netlink.c                            |  16 ++--
 net/mac80211/main.c                                |  24 ++---
 net/qrtr/qrtr.c                                    |   7 +-
 net/wireless/nl80211.c                             |   6 +-
 security/keys/proc.c                               |   2 +
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/intel/atom/sst-atom-controls.c           |   2 +-
 sound/soc/intel/atom/sst/sst_pci.c                 |   2 +-
 sound/usb/mixer.c                                  |  31 ++++---
 sound/usb/mixer_maps.c                             |   4 +-
 tools/perf/builtin-report.c                        |   9 +-
 64 files changed, 372 insertions(+), 357 deletions(-)


