Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F92E1B27AF
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 15:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbgDUNXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 09:23:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:57622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728864AbgDUNXy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 09:23:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D6F02078C;
        Tue, 21 Apr 2020 13:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587475433;
        bh=ASH9ZxaXsbgHfSrdPX5RIWVfQMBPX/tL0k3v6Qii86c=;
        h=Date:From:To:Cc:Subject:From;
        b=1YcAdAjnLoIG2aflRqc2ASYSuP1JsKGFU8BpZiFqSzuBWuluBzUeSvkUsbvrjc8Lh
         dwi/Lkm/TIn3Q3gIGDozClG0D4iC9yAWYq98DmjMPJ86QTVWel5ap/07o+tDhP5yKz
         8SM9D5SuAeY3LkYbLUqvGs6yOQdXEqksIVlGDps0=
Date:   Tue, 21 Apr 2020 15:23:50 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.117
Message-ID: <20200421132350.GA795448@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.117 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                          |    2=20
 arch/x86/include/asm/microcode_amd.h              |    2=20
 arch/x86/kernel/cpu/intel_rdt.c                   |    2=20
 arch/x86/kernel/cpu/intel_rdt.h                   |    1=20
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c          |   16 +++-
 arch/x86/kvm/cpuid.c                              |    3=20
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c  |    5 +
 drivers/net/dsa/mt7530.c                          |   18 +++-
 drivers/net/dsa/mt7530.h                          |    7 +
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c          |    2=20
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c |    2=20
 drivers/net/wireless/ath/wil6210/debugfs.c        |   29 -------
 drivers/net/wireless/ath/wil6210/interrupt.c      |   12 ++-
 drivers/net/wireless/ath/wil6210/main.c           |    5 +
 drivers/net/wireless/ath/wil6210/txrx.c           |    4 -
 drivers/net/wireless/ath/wil6210/txrx_edma.c      |   14 ++-
 drivers/net/wireless/ath/wil6210/wil6210.h        |    3=20
 drivers/net/wireless/ath/wil6210/wmi.c            |    2=20
 drivers/net/wireless/mac80211_hwsim.c             |   12 +--
 drivers/pwm/pwm-pca9685.c                         |   85 ++++++++++++-----=
-----
 drivers/scsi/ufs/ufshcd.c                         |    5 +
 drivers/target/iscsi/iscsi_target.c               |   79 +++++------------=
---
 drivers/target/iscsi/iscsi_target.h               |    1=20
 drivers/target/iscsi/iscsi_target_configfs.c      |    5 +
 drivers/target/iscsi/iscsi_target_login.c         |    5 -
 drivers/usb/dwc3/gadget.c                         |   18 ++--
 fs/btrfs/relocation.c                             |    4 -
 fs/ext4/extents.c                                 |    8 +-
 fs/ext4/super.c                                   |    6 -
 fs/jbd2/commit.c                                  |    7 +
 fs/overlayfs/inode.c                              |    4 -
 include/net/ip6_route.h                           |    1=20
 include/target/iscsi/iscsi_target_core.h          |    2=20
 kernel/trace/trace_events_trigger.c               |   10 --
 mm/vmalloc.c                                      |    8 +-
 net/core/dev.c                                    |    3=20
 net/hsr/hsr_netlink.c                             |   10 ++
 net/ipv4/devinet.c                                |   13 ++-
 net/qrtr/qrtr.c                                   |    7 +
 security/keys/proc.c                              |    2=20
 sound/soc/intel/atom/sst-atom-controls.c          |    2=20
 sound/soc/intel/atom/sst/sst_pci.c                |    2=20
 sound/usb/mixer.c                                 |   31 ++++----
 sound/usb/mixer_maps.c                            |    4 -
 44 files changed, 251 insertions(+), 212 deletions(-)

Alexei Avshalom Lazar (1):
      wil6210: add general initialization/size checks

Amir Goldstein (1):
      ovl: fix value of i_ino for lower hardlink corner case

Austin Kim (1):
      mm/vmalloc.c: move 'area->pages' after if statement

Can Guo (1):
      scsi: ufs: Fix ufshcd_hold() caused scheduling while atomic

Colin Ian King (2):
      ASoC: Intel: mrfld: fix incorrect check on p->sink
      ASoC: Intel: mrfld: return error codes when an error occurs

DENG Qingfang (1):
      net: dsa: mt7530: fix tagged frames pass-through in VLAN-unaware mode

Dedy Lansky (2):
      wil6210: check rx_buff_mgmt before accessing it
      wil6210: make sure Rx ring sizes are correlated

Florian Fainelli (1):
      net: stmmac: dwmac-sunxi: Provide TX and RX fifo sizes

Greg Kroah-Hartman (1):
      Linux 4.19.117

James Morse (1):
      x86/resctrl: Preserve CDP enable over CPU hotplug

Jan Kara (1):
      ext4: do not zeroout extents beyond i_disksize

Jim Mattson (1):
      kvm: x86: Host feature SSBD doesn't imply guest feature SPEC_CTRL_SSBD

John Allen (1):
      x86/microcode/AMD: Increase microcode PATCH_MAX_SIZE

Josef Bacik (1):
      btrfs: check commit root generation in should_ignore_root

Josh Triplett (2):
      ext4: fix incorrect group count in ext4_fill_super error message
      ext4: fix incorrect inodes per group in error message

Karthick Gopalasubramanian (1):
      wil6210: remove reset file from debugfs

Konstantin Khlebnikov (1):
      net: revert default NAPI poll timeout to 2 jiffies

Maurizio Lombardi (2):
      scsi: target: remove boilerplate code
      scsi: target: fix hang when multiple threads try to destroy the same =
iscsi session

Maya Erez (1):
      wil6210: ignore HALP ICR if already handled

Reinette Chatre (1):
      x86/resctrl: Fix invalid attempt at removing the default resource gro=
up

Sasha Levin (1):
      usb: dwc3: gadget: don't enable interrupt when disabling endpoint

Sebastian Andrzej Siewior (1):
      amd-xgbe: Use __napi_schedule() in BH context

Sergei Lopatin (1):
      drm/amd/powerplay: force the trim of the mclk dpm_levels if OD is ena=
bled

Sven Van Asbroeck (1):
      pwm: pca9685: Fix PWM/GPIO inter-operation

Taehee Yoo (1):
      hsr: check protocol version in hsr_newlink()

Takashi Iwai (4):
      ALSA: usb-audio: Filter error from connector kctl ops, too
      ALSA: usb-audio: Don't override ignore_ctl_error value from the map
      ALSA: usb-audio: Don't create jack controls for PCM terminals
      ALSA: usb-audio: Check mapping at creating connector controls, too

Taras Chornyi (1):
      net: ipv4: devinet: Fix crash when add/del multicast IP with autojoin

Thinh Nguyen (1):
      usb: dwc3: gadget: Don't clear flags before transfer ended

Tim Stallard (1):
      net: ipv6: do not consider routes via gateways for anycast address ch=
eck

Tuomas Tynkkynen (1):
      mac80211_hwsim: Use kstrndup() in place of kasprintf()

Vasily Averin (1):
      keys: Fix proc_keys_next to increase position index

Wang Wenhu (1):
      net: qrtr: send msgs from local of same id as broadcast

Xiao Yang (1):
      tracing: Fix the race between registering 'snapshot' event trigger an=
d triggering 'snapshot' operation

zhangyi (F) (1):
      jbd2: improve comments about freeing data buffers whose page mapping =
is NULL


--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6e8+QACgkQONu9yGCS
aT4UuxAAqOgpfIhEsFQOZX4E9USXTHE5EVOBCzSVciHo601KldK9ccNXpA7MLmmk
vORHb+gxCUsRhIGjSrqumAYrWRhKrgsbopJJ5H0A+3lkIrIeLUgBXkamZ1X96tmc
Sab6hKL6ftBP5iX5w5Q0XJpyqvW57d2wWu8IMxrAtGMSITevSr79tnpAQc3EX85X
xmCKGJlDUen/TfVfcDP7+SkyAK4SNgmHmHI/o+WjCMhUQjYwunS9hpmz/TRmrMia
h2Gcvv8JeKpCGrCV5q5X6rC829THH18Yxzrc1F2I2uUovSCGF4/9W/6HLJtvHhO2
rYbq6hvibmyDv9LziprSX+tGjjqGdTzP4YKTj+rwArGI2LGeAw+Ao8nMVj2u9SEE
jA3mFbFuZE4LvUps+8mYBM+GOgj/f9MSW94oP74cUE4GYe44arEqwKbmJJOc/Fts
huEP+u9ZJ/UfKpnEwUlGjPAcal1nJmRCBaPkGVvJD4gTYkAKpBWZjDye5AF9aEMK
JsVulOf1fo/WnafBes093+qc2M74x50YR8L81R22DWvlJvHvI5MLWs5F6bTymfo3
3Ffryl4spuNHZnTwxulgBiFfGBkHWczUXZygzQs4rkqsGBm+2uKePaCNrqG1XDI/
LKe3tZGUQ298+opzk0n48EXh2vpVPQukpWuMcrEjfelon/TL1q8=
=0qB/
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
