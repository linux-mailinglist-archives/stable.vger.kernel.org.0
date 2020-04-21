Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415C71B2853
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 15:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728879AbgDUNom (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 09:44:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728807AbgDUNol (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 09:44:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BAFD206B9;
        Tue, 21 Apr 2020 13:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587476679;
        bh=mapOjVVcT9okx+feUwUTV0yXSnTWbM0PqGrNvWe8iB4=;
        h=Date:From:To:Cc:Subject:From;
        b=j0lOdR5CpxDCw5IWAoCPd+UDx4ZUpP5Jpn9PVoIStIkvFJGdCp1Chll40FsytId7w
         cXW8+OuHNulQQfHFCDqeP/fDym5h32QzlS8sLgjU75HyAOklU1EE21PfOpDxz1ayYm
         +zq187dETtT/Y+ABWnsAj0HhScW7Elaohn4bM7jI=
Date:   Tue, 21 Apr 2020 15:44:37 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.6.6
Message-ID: <20200421134437.GA798018@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.6.6 kernel.

All users of the 5.6 kernel series must upgrade.

The updated 5.6.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.6.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                                |    2=20
 arch/arm/boot/dts/imx7-colibri.dtsi                     |    9 +
 arch/arm64/boot/dts/freescale/imx8mq-librem5-devkit.dts |    1=20
 arch/arm64/kernel/vdso.c                                |   13 --
 arch/x86/include/asm/microcode_amd.h                    |    2=20
 arch/x86/kernel/cpu/resctrl/core.c                      |    2=20
 arch/x86/kernel/cpu/resctrl/internal.h                  |    1=20
 arch/x86/kernel/cpu/resctrl/rdtgroup.c                  |   16 ++
 drivers/acpi/ec.c                                       |    6=20
 drivers/acpi/nfit/core.c                                |   10 -
 drivers/acpi/nfit/nfit.h                                |    1=20
 drivers/clk/at91/clk-usb.c                              |    2=20
 drivers/clk/at91/sam9x60.c                              |    5=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c              |    2=20
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c                   |    2=20
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c        |    5=20
 drivers/gpu/drm/i915/i915_perf.c                        |   65 +---------
 drivers/gpu/drm/nouveau/nvkm/engine/sec2/gp108.c        |    3=20
 drivers/gpu/drm/nouveau/nvkm/engine/sec2/tu102.c        |   16 ++
 drivers/hid/hid-lg-g15.c                                |    6=20
 drivers/i2c/busses/i2c-designware-platdrv.c             |   14 +-
 drivers/irqchip/irq-ti-sci-inta.c                       |    3=20
 drivers/net/dsa/mt7530.c                                |  103 +----------=
-----
 drivers/net/dsa/mt7530.h                                |   17 +-
 drivers/net/dsa/ocelot/felix.c                          |    5=20
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c                |    2=20
 drivers/net/ethernet/mediatek/mtk_eth_soc.c             |   24 +++
 drivers/net/ethernet/mediatek/mtk_eth_soc.h             |    8 +
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c       |    5=20
 drivers/net/ethernet/mellanox/mlx5/core/en.h            |    7 -
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c    |   10 -
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c       |   49 +++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c        |    9 -
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c         |    5=20
 drivers/net/ethernet/mellanox/mlx5/core/health.c        |    2=20
 drivers/net/ethernet/mscc/ocelot.c                      |   84 ++++++-----=
--
 drivers/net/ethernet/mscc/ocelot.h                      |    2=20
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c       |    2=20
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c     |   11 +
 drivers/net/macsec.c                                    |    2=20
 drivers/net/phy/marvell.c                               |   46 +++----
 drivers/net/phy/micrel.c                                |    2=20
 drivers/net/tun.c                                       |    3=20
 drivers/net/wireless/mac80211_hwsim.c                   |   12 -
 drivers/platform/chrome/cros_ec_rpmsg.c                 |   16 ++
 drivers/pwm/pwm-pca9685.c                               |   85 +++++++----=
--
 drivers/scsi/ufs/ufshcd.c                               |    5=20
 drivers/target/iscsi/iscsi_target.c                     |    3=20
 drivers/usb/dwc3/gadget.c                               |    4=20
 fs/btrfs/relocation.c                                   |    4=20
 fs/ext4/extents.c                                       |    8 -
 fs/ext4/super.c                                         |    6=20
 fs/jbd2/commit.c                                        |    7 -
 fs/overlayfs/inode.c                                    |    4=20
 fs/proc/base.c                                          |   14 ++
 include/net/ip6_route.h                                 |    1=20
 include/soc/mscc/ocelot.h                               |    4=20
 kernel/rcu/tree.c                                       |    2=20
 kernel/time/namespace.c                                 |   15 ++
 kernel/trace/trace_events_trigger.c                     |   10 -
 net/bpfilter/main.c                                     |    1=20
 net/core/dev.c                                          |    3=20
 net/hsr/hsr_netlink.c                                   |   10 +
 net/ipv4/devinet.c                                      |   13 +-
 net/ipv6/icmp.c                                         |   21 +++
 net/l2tp/l2tp_netlink.c                                 |   16 +-
 net/mac80211/main.c                                     |   24 ++-
 net/qrtr/qrtr.c                                         |    7 -
 net/wireless/nl80211.c                                  |    6=20
 security/keys/proc.c                                    |    2=20
 sound/hda/Kconfig                                       |    7 -
 sound/pci/hda/patch_realtek.c                           |    1=20
 sound/soc/intel/atom/sst-atom-controls.c                |    2=20
 sound/soc/intel/atom/sst/sst_pci.c                      |    2=20
 sound/usb/mixer.c                                       |   31 ++--
 sound/usb/mixer_maps.c                                  |    4=20
 tools/perf/builtin-report.c                             |    9 -
 77 files changed, 512 insertions(+), 431 deletions(-)

Adam Barber (1):
      ALSA: hda/realtek - Enable the headset mic on Asus FX505DT

Alex Deucher (1):
      drm/amdgpu/gfx9: add gfxoff quirk

Amir Goldstein (1):
      ovl: fix value of i_ino for lower hardlink corner case

Andrei Vagin (1):
      proc, time/namespace: Show clock symbolic names in /proc/pid/timens_o=
ffsets

Angus Ainslie (Purism) (1):
      arm64: dts: librem5-devkit: add a vbus supply to usb0

Ashutosh Dixit (1):
      drm/i915/perf: Do not clear pollin for small user read buffers

Atsushi Nemoto (1):
      net: phy: micrel: use genphy_read_status for KSZ9131

Ben Skeggs (1):
      drm/nouveau/sec2/gv100-: add missing MODULE_FIRMWARE()

Bruno Meneguele (1):
      net/bpfilter: remove superfluous testing message

Can Guo (1):
      scsi: ufs: Fix ufshcd_hold() caused scheduling while atomic

Claudiu Beznea (2):
      clk: at91: sam9x60: fix usb clock parents
      clk: at91: usb: use proper usbs_mask

Clemens Gruber (1):
      net: phy: marvell: Fix pause frame negotiation

Colin Ian King (2):
      ASoC: Intel: mrfld: fix incorrect check on p->sink
      ASoC: Intel: mrfld: return error codes when an error occurs

DENG Qingfang (1):
      net: dsa: mt7530: fix tagged frames pass-through in VLAN-unaware mode

Dan Carpenter (1):
      acpi/nfit: improve bounds checking for 'func'

Dmytro Linkin (1):
      net/mlx5e: Fix nest_level for vlan pop action

Eran Ben Elisha (1):
      net/mlx5e: Add missing release firmware call

Florian Fainelli (1):
      net: stmmac: dwmac-sunxi: Provide TX and RX fifo sizes

Gilberto Bertin (1):
      net: tun: record RX queue in skb before do_xdp_generic()

Greg Kroah-Hartman (2):
      Revert "ACPI: EC: Do not clear boot_ec_is_ecdt in acpi_ec_add()"
      Linux 5.6.6

Grygorii Strashko (1):
      irqchip/ti-sci-inta: Fix processing of masked irqs

Hans de Goede (2):
      HID: lg-g15: Do not fail the probe when we fail to disable F# emulati=
on
      i2c: designware: platdrv: Remove DPM_FLAG_SMART_SUSPEND flag on BYT a=
nd CHT

James Morse (1):
      x86/resctrl: Preserve CDP enable over CPU hotplug

Jan Kara (1):
      ext4: do not zeroout extents beyond i_disksize

Jin Yao (1):
      perf report: Fix no branch type statistics report issue

Johannes Berg (1):
      nl80211: fix NL80211_ATTR_FTM_RESPONDER policy

John Allen (1):
      x86/microcode/AMD: Increase microcode PATCH_MAX_SIZE

Jose Abreu (1):
      net: stmmac: xgmac: Fix VLAN register handling

Josef Bacik (1):
      btrfs: check commit root generation in should_ignore_root

Josh Triplett (2):
      ext4: fix incorrect group count in ext4_fill_super error message
      ext4: fix incorrect inodes per group in error message

Konstantin Khlebnikov (1):
      net: revert default NAPI poll timeout to 2 jiffies

Mark Rutland (1):
      arm64: vdso: don't free unallocated pages

Maurizio Lombardi (1):
      scsi: target: iscsi: calling iscsit_stop_session() inside iscsit_clos=
e_session() has no effect

Maxim Mikityanskiy (3):
      net/mlx5e: Encapsulate updating netdev queues into a function
      net/mlx5e: Rename hw_modify to preactivate
      net/mlx5e: Use preactivate hook to set the indirection table

Michael Wei=DF (1):
      l2tp: Allow management of tunnels and session in user namespace

Moshe Shemesh (1):
      net/mlx5: Fix frequent ioread PCI access during recovery

Oleksandr Suvorov (1):
      ARM: dts: imx7-colibri: fix muxing of usbc_det pin

Parav Pandit (1):
      net/mlx5e: Fix pfnum in devlink port attribute

Paul E. McKenney (1):
      rcu: Don't acquire lock in NMI handler in rcu_nmi_enter_common()

Pi-Hsun Shih (1):
      platform/chrome: cros_ec_rpmsg: Fix race with host event

Prike Liang (1):
      drm/amdgpu: fix the hw hang during perform system reboot and reset

Reinette Chatre (1):
      x86/resctrl: Fix invalid attempt at removing the default resource gro=
up

Ren=E9 van Dorst (2):
      net: dsa: mt7530: move mt7623 settings out off the mt7530
      net: ethernet: mediatek: move mt7623 settings out off the mt7530

Sebastian Andrzej Siewior (1):
      amd-xgbe: Use __napi_schedule() in BH context

Sergei Lopatin (1):
      drm/amd/powerplay: force the trim of the mclk dpm_levels if OD is ena=
bled

Sumit Garg (1):
      mac80211: fix race in ieee80211_register_hw()

Sven Van Asbroeck (1):
      pwm: pca9685: Fix PWM/GPIO inter-operation

Taehee Yoo (2):
      hsr: check protocol version in hsr_newlink()
      net: macsec: fix using wrong structure in macsec_changelink()

Takashi Iwai (5):
      ALSA: hda: Allow setting preallocation again for x86
      ALSA: usb-audio: Filter error from connector kctl ops, too
      ALSA: usb-audio: Don't override ignore_ctl_error value from the map
      ALSA: usb-audio: Don't create jack controls for PCM terminals
      ALSA: usb-audio: Check mapping at creating connector controls, too

Taras Chornyi (1):
      net: ipv4: devinet: Fix crash when add/del multicast IP with autojoin

Thinh Nguyen (1):
      usb: dwc3: gadget: Don't clear flags before transfer ended

Tim Stallard (2):
      net: ipv6: do not consider routes via gateways for anycast address ch=
eck
      net: icmp6: do not select saddr from iif when route has prefsrc set

Tuomas Tynkkynen (1):
      mac80211_hwsim: Use kstrndup() in place of kasprintf()

Vasily Averin (1):
      keys: Fix proc_keys_next to increase position index

Vladimir Oltean (1):
      net: mscc: ocelot: fix untagged packet drops when enslaving to vlan a=
ware bridge

Wang Wenhu (1):
      net: qrtr: send msgs from local of same id as broadcast

Xiao Yang (1):
      tracing: Fix the race between registering 'snapshot' event trigger an=
d triggering 'snapshot' operation

zhangyi (F) (1):
      jbd2: improve comments about freeing data buffers whose page mapping =
is NULL


--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6e+MUACgkQONu9yGCS
aT7QURAAtTdpZJbE+MqVR8BtTU4kOOViDsK73E9Ppqo022WQj0Dnmb2G+ecEth65
770x0ZEHeJEmCR7//ICcLtmROdWx2TLk7GzsPnLlAKy/oA7lWIEkoS+LvCXhI7ru
wjVUPZqcMLS/55Ls8h9/hWqrCtpi84fr/JlJCSfvZPwkJbp+KfoB3MRQGjZAhEcr
UD6RPOqXlZEtZHNb4RTJRHuBWgc97zI2/I1ho2jmN4OGCFaovWs+1nSDxZnYkT7Q
VlMIuoSr9KPZBIh0vJoTGTKJ93eCTbjxng59TGZivpjboBenCcfCXso/nB2AF1yY
8CTM0bZyImfGCFRZb7sORWMs/fLsD0JDMmBj1dK+zcgArLpy8gP+55Ym6EqavP9e
sm2qf7LVTOlj4qtgTrx6z9UgpwTgpblz5oabjshwfa5aQuvkDRftygafXg/XO+qs
9w0zgF1IVE7GpTwy1F1Pt2CgwzED6h1JKVO+TEcxRXTG1KeLuCrmDu9KYlcKlQ5s
lpS1ec0BoactMmWXt5AJcjGkvSeITGDLOQq+qec9Epa7aQfIw3tyXm+I/6NrzhMD
DQ56iz0weJd0hH0uc9hWI4bk9ebhEHBZMloKukKXHH9dl45yAcxyKMaYfWsShtBr
Y/za0CXJuvz/nWH6Ve31V9WsfqrWZg5b2nsqYcJTefbpf19nDo0=
=75f/
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
