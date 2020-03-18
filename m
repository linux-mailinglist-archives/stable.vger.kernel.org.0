Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA031898C2
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 11:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727405AbgCRKCP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 06:02:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727281AbgCRKCP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 06:02:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E97A20767;
        Wed, 18 Mar 2020 10:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584525733;
        bh=bRr3fWgIUHDgNzVt7r2wfg3TVSrIJhPeQ8DzKW0xyiI=;
        h=Date:From:To:Cc:Subject:From;
        b=U4SOIP7QyI9RLfDa1Ooq6En/BExzJp1lfYg+ktB8gNRQPmz0flzo/7Ji6m/Eo6b+8
         K4BF+7l2FUGP47ACs6cL5Qqh94s0UNDz643wGgdmE0Xmu4H6Y1tbyov/mHZdVL13Zc
         5aYob2fgtS4QAnjpm9svzKM0OMHbxwuY/GwD6Yfw=
Date:   Wed, 18 Mar 2020 11:02:10 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.111
Message-ID: <20200318100210.GA2034956@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.111 kernel.

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

 Documentation/filesystems/porting                    |    7 ++
 Makefile                                             |    2=20
 arch/arc/include/asm/linkage.h                       |    2=20
 arch/x86/kernel/cpu/mcheck/mce_intel.c               |    9 +--
 arch/x86/kvm/emulate.c                               |    1=20
 drivers/block/virtio_blk.c                           |    8 +-
 drivers/firmware/efi/efivars.c                       |   32 ++++++++---
 drivers/firmware/efi/runtime-wrappers.c              |   53 +++-----------=
-----
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c         |    3 -
 drivers/gpu/drm/i915/gvt/vgpu.c                      |   12 +++-
 drivers/i2c/busses/i2c-gpio.c                        |    2=20
 drivers/i2c/i2c-core-acpi.c                          |   10 +++
 drivers/iommu/dma-iommu.c                            |   16 ++---
 drivers/iommu/dmar.c                                 |   21 +++++--
 drivers/iommu/intel-iommu.c                          |   13 ++--
 drivers/macintosh/windfarm_ad7417_sensor.c           |    7 ++
 drivers/macintosh/windfarm_fcu_controls.c            |    7 ++
 drivers/macintosh/windfarm_lm75_sensor.c             |   16 +++++
 drivers/macintosh/windfarm_lm87_sensor.c             |    7 ++
 drivers/macintosh/windfarm_max6690_sensor.c          |    7 ++
 drivers/macintosh/windfarm_smu_sat.c                 |    7 ++
 drivers/net/bonding/bond_alb.c                       |   20 +++----
 drivers/net/can/dev.c                                |    1=20
 drivers/net/ethernet/broadcom/bcmsysport.c           |    2=20
 drivers/net/ethernet/broadcom/bnxt/bnxt.c            |    4 -
 drivers/net/ethernet/freescale/fec_main.c            |    6 +-
 drivers/net/ethernet/sfc/efx.c                       |    1=20
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c |    3 -
 drivers/net/ipvlan/ipvlan_core.c                     |   19 +++---
 drivers/net/ipvlan/ipvlan_main.c                     |    5 -
 drivers/net/macsec.c                                 |   12 ++--
 drivers/net/macvlan.c                                |    2=20
 drivers/net/phy/phy_device.c                         |   18 +++---
 drivers/net/slip/slhc.c                              |   14 +++--
 drivers/net/team/team.c                              |    2=20
 drivers/net/usb/r8152.c                              |    8 ++
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c         |    3 -
 drivers/net/wireless/mediatek/mt76/dma.c             |    9 ++-
 drivers/pinctrl/core.c                               |    1=20
 drivers/pinctrl/meson/pinctrl-meson-gxl.c            |    4 -
 fs/cifs/dir.c                                        |    1=20
 fs/gfs2/inode.c                                      |    2=20
 fs/open.c                                            |    3 -
 include/linux/cgroup.h                               |    1=20
 include/linux/efi.h                                  |   36 ++++++++++++
 include/linux/inet_diag.h                            |   18 ++++--
 include/linux/phy.h                                  |    2=20
 include/net/fib_rules.h                              |    1=20
 kernel/cgroup/cgroup.c                               |   37 +++++++++----
 kernel/workqueue.c                                   |   14 ++---
 mm/memcontrol.c                                      |   14 -----
 net/batman-adv/bat_iv_ogm.c                          |    4 +
 net/batman-adv/bat_v_ogm.c                           |   42 ++++++++++++---
 net/batman-adv/types.h                               |    4 +
 net/core/devlink.c                                   |   33 +++++++----
 net/core/netclassid_cgroup.c                         |   47 +++++++++++++-=
--
 net/core/sock.c                                      |    5 +
 net/ieee802154/nl_policy.c                           |    6 ++
 net/ipv4/gre_demux.c                                 |   12 +++-
 net/ipv4/inet_connection_sock.c                      |   20 +++++++
 net/ipv4/inet_diag.c                                 |   44 +++++++--------
 net/ipv4/raw_diag.c                                  |    5 +
 net/ipv4/udp_diag.c                                  |    5 +
 net/ipv6/addrconf.c                                  |   49 +++++++++++++-=
---
 net/ipv6/ipv6_sockglue.c                             |   10 ++-
 net/netfilter/nf_conntrack_standalone.c              |    2=20
 net/netfilter/nf_synproxy_core.c                     |    2=20
 net/netfilter/nfnetlink_cthelper.c                   |    2=20
 net/netfilter/nft_payload.c                          |    1=20
 net/netfilter/nft_tunnel.c                           |    2=20
 net/netfilter/x_tables.c                             |    6 +-
 net/netfilter/xt_recent.c                            |    2=20
 net/netlink/af_netlink.c                             |    2=20
 net/nfc/hci/core.c                                   |   19 +++++-
 net/nfc/netlink.c                                    |    4 +
 net/packet/af_packet.c                               |   13 ++--
 net/sched/sch_fq.c                                   |    1=20
 net/sctp/diag.c                                      |    8 --
 net/smc/smc_ib.c                                     |    3 +
 net/tipc/netlink.c                                   |    3 -
 net/wireless/nl80211.c                               |    5 +
 tools/perf/bench/futex-wake.c                        |    4 -
 tools/testing/ktest/ktest.pl                         |    2=20
 tools/testing/selftests/net/fib_tests.sh             |   34 +++++++++++-
 84 files changed, 624 insertions(+), 282 deletions(-)

Al Viro (2):
      cifs_atomic_open(): fix double-put on late allocation failure
      gfs2_atomic_open(): fix O_EXCL|O_CREAT handling on cold dcache

Charles Keepax (1):
      pinctrl: core: Remove extra kref_get which blocks hogs being freed

Colin Ian King (2):
      net: systemport: fix index check to avoid an array out of bounds acce=
ss
      drm/amd/display: remove duplicated assignment to grph_obj_type

Dan Carpenter (1):
      net: nfc: fix bounds checking bugs on "pipe"

Dan Moulding (1):
      iwlwifi: mvm: Do not require PHY_SKU NVM section for 3168 devices

Daniel Drake (1):
      iommu/vt-d: Ignore devices with out-of-spec domain number

David S. Miller (1):
      phy: Revert toggling reset changes.

Dmitry Bogdanov (1):
      net: macsec: update SCI upon MAC address change.

Dmitry Yakunin (2):
      cgroup, netclassid: periodically release file_lock on classid updating
      inet_diag: return classid for all socket types

Edward Cree (1):
      sfc: detach from cb_page in efx_copy_channel()

Eric Dumazet (6):
      gre: fix uninit-value in __iptunnel_pull_header
      ipvlan: do not use cond_resched_rcu() in ipvlan_process_multicast()
      net: memcg: fix lockdep splat in inet_csk_accept()
      bonding/alb: make sure arp header is pulled before accessing it
      slip: make slhc_compress() more robust against malicious packets
      ipv6: restrict IPV6_ADDRFORM operation

Eugeniy Paltsev (1):
      ARC: define __ALIGN_STR and __ALIGN symbols for ARC

Felix Fietkau (1):
      mt76: fix array overflow on receiving too many fragments for a packet

Florian Fainelli (1):
      net: phy: Avoid multiple suspends

Greg Kroah-Hartman (1):
      Linux 4.19.111

Halil Pasic (1):
      virtio-blk: fix hw_queue stopped on arbitrary error

Hamish Martin (1):
      i2c: gpio: suppress error on probe defer

Hangbin Liu (5):
      ipv6/addrconf: call ipv6_mc_up() for non-Ethernet interface
      net/ipv6: use configured metric when add peer route
      selftests/net/fib_tests: update addr_metric_test for peer route testi=
ng
      net/ipv6: need update peer route when modify metric
      net/ipv6: remove the old peer route if change it to a new one

Hans de Goede (2):
      iommu/vt-d: quirk_ioat_snb_local_iommu: replace WARN_TAINT with pr_wa=
rn + add_taint
      iommu/vt-d: dmar: replace WARN_TAINT with pr_warn + add_taint

Heiner Kallweit (1):
      net: phy: fix MDIO bus PM PHY resuming

Hillf Danton (1):
      workqueue: don't use wq_select_unbound_cpu() for bound works

Jakub Kicinski (21):
      devlink: validate length of param values
      fib: add missing attribute validation for tun_id
      nl802154: add missing attribute validation
      nl802154: add missing attribute validation for dev_type
      can: add missing attribute validation for termination
      macsec: add missing attribute validation for port
      net: fq: add missing attribute validation for orphan mask
      team: add missing attribute validation for port ifindex
      team: add missing attribute validation for array index
      nfc: add missing attribute validation for SE API
      nfc: add missing attribute validation for deactivate target
      nfc: add missing attribute validation for vendor subcommand
      tipc: add missing attribute validation for MTU property
      devlink: validate length of region addr/len
      net: fec: validate the new settings in fec_enet_set_coalesce()
      nl80211: add missing attribute validation for critical protocol indic=
ation
      nl80211: add missing attribute validation for beacon report scanning
      nl80211: add missing attribute validation for channel switch
      netfilter: cthelper: add missing attribute validation for cthelper
      netfilter: nft_payload: add missing attribute validation for payload =
csum flags
      netfilter: nft_tunnel: add missing attribute validation for tunnels

Jiri Wiesner (1):
      ipvlan: do not add hardware address of master to its unicast filter l=
ist

Karsten Graul (2):
      net/smc: check for valid ib_client_data
      net/smc: cancel event worker during device removal

Mahesh Bandewar (3):
      ipvlan: add cond_resched_rcu() while processing muticast backlog
      ipvlan: don't deref eth hdr before checking it's set
      macvlan: add cond_resched() during multicast processing

Marc Zyngier (1):
      iommu/dma: Fix MSI reservation allocation

Michal Koutn=FD (1):
      cgroup: Iterate tasks that did not finish do_exit()

Nicolas Belin (1):
      pinctrl: meson-gxl: fix GPIOX sdio pins

Pablo Neira Ayuso (1):
      netlink: Use netlink header as base to calculate bad attribute offset

Remi Pommarel (1):
      net: stmmac: dwmac1000: Disable ACS if enhanced descs are not used

Sai Praneeth (1):
      efi: Make efi_rts_work accessible to efi page fault handler

Shakeel Butt (2):
      cgroup: memcg: net: do not associate sock with unrelated cgroup
      net: memcg: late association of sock to memcg

Steven Rostedt (VMware) (1):
      ktest: Add timeout for ssh sync testing

Sven Eckelmann (2):
      batman-adv: Don't schedule OGM for disabled interface
      batman-adv: Avoid free/alloc race when handling OGM2 buffer

Tommi Rantala (1):
      perf bench futex-wake: Restore thread count default to online CPU cou=
nt

Tony Luck (1):
      x86/mce: Fix logic and comments around MSR_PPIN_CTL

Vasily Averin (5):
      cgroup: cgroup_procs_next should increase position index
      netfilter: nf_conntrack: ct_cpu_seq_next should increase position ind=
ex
      netfilter: synproxy: synproxy_cpu_seq_next should increase position i=
ndex
      netfilter: xt_recent: recent_seq_next should increase position index
      netfilter: x_tables: xt_mttg_seq_next should increase position index

Vasundhara Volam (1):
      bnxt_en: reinitialize IRQs when MTU is modified

Vitaly Kuznetsov (1):
      KVM: x86: clear stale x86_emulate_ctxt->intercept value

Vladis Dronov (2):
      efi: Fix a race and a buffer overflow while reading efivars via sysfs
      efi: Add a sanity check to efivar_store_raw()

Willem de Bruijn (1):
      net/packet: tpacket_rcv: do not increment ring index on drop

Wolfram Sang (2):
      macintosh: windfarm: fix MODINFO regression
      i2c: acpi: put device when verifying client fails

Yonghyun Hwang (1):
      iommu/vt-d: Fix a bug in intel_iommu_iova_to_phys() for huge page

You-Sheng Yang (1):
      r8152: check disconnect status after long sleep

Zhenyu Wang (1):
      drm/i915/gvt: Fix unnecessary schedule timer when no vGPU exits

Zhenzhong Duan (1):
      iommu/vt-d: Fix the wrong printing in RHSA parsing


--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl5x8aAACgkQONu9yGCS
aT66gg//V4FY98+RXiJfAigu7rt4lVQExMrfdYhe6/MQHmMVSXYk0FUCLe4N6Syu
YOk/9iTgiZgprc3EWb35GEgh4hu1QrlRCjlxyIKuGdJSpT+5JZgKE2mO7h74l20X
XRSu4yrS/xQGwenkGdHhg4efMDHmBBGJzfe4JRtzgq9bYH78J75mw6HidKoHPjHE
EaFnCjbM/n5ZC/xzGw3dWkl+MMzv81RTs+D7pqcmXJY+RbNDVo7oqvnPKaGQI45a
PdqOpZxtr+veBN8bz31l9hJrNbE5kWf71kY1iGMwxuCgzgzBkwmPiDYCtHwhcd7L
IlATWKu1iD7jBIZarY/Py+MmP5Bpej5bngynXF96iq7uEyQBhz3vcvvDifAErIil
Y0mi1di1iogVVi5yrwa9XlF022za3idtdpLfDMWLwz1Ah0Tjz/zICzJbejFIJQwR
ly3Kudf6r7s54wNOl0tubtOQOFXhE8F2fEDtlVs/ke+jTXGtfKC3ctoLLmNVT7Dp
+CqQkM4uzUSGgQKeCT5HYtT3tpqBe1sVSBfXNRRjnWu9/FUnTNQLyoEPu4nI7dqh
vtK6+sef97BtBEoCrUTBLENMsvplBZmbleCQ8t/WffG2qN9nt8jotBwAQFg4jFHh
BURT9n9AIVJm4zCZW2HTtkApj5ZmnH6crw6Ld0GYlT7koQJNzJc=
=dorx
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
