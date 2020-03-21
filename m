Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65C1418DF0D
	for <lists+stable@lfdr.de>; Sat, 21 Mar 2020 10:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgCUJ0J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Mar 2020 05:26:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726933AbgCUJ0I (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Mar 2020 05:26:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 329032070A;
        Sat, 21 Mar 2020 09:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584782766;
        bh=RLMyQYAR/pTCRbBalIaCE4ZdABn3+DQWLsypR1+/inE=;
        h=Date:From:To:Cc:Subject:From;
        b=MeW74/s0Lk9wKqHDiMZOMOd14LdWTd1D9JivdXdh6gaZ04zGUb0seQqxZhXULORAp
         PicOh6gK0Xi8Pp4fXFJPqQW8PPzTxEg7Zobt1FeVCk00/2r4pbnWwnufGXhFn8+WTx
         kuDDOLQMrkDNhaxfRuvuN2pe5+1A/mT35Wwh3jJ4=
Date:   Sat, 21 Mar 2020 10:26:03 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.217
Message-ID: <20200321092603.GA887303@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.217 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/filesystems/porting            |    7 +
 Documentation/kernel-parameters.txt          |    4=20
 Makefile                                     |    2=20
 arch/arc/include/asm/linkage.h               |    2=20
 arch/arm/kernel/vdso.c                       |    2=20
 arch/arm/lib/copy_from_user.S                |    2=20
 arch/x86/events/amd/uncore.c                 |   14 +-
 arch/x86/kvm/emulate.c                       |    1=20
 drivers/acpi/acpi_watchdog.c                 |   12 +-
 drivers/block/virtio_blk.c                   |    8 -
 drivers/firmware/efi/efivars.c               |   32 ++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c |    3=20
 drivers/hid/hid-apple.c                      |    3=20
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c     |    8 +
 drivers/iommu/dmar.c                         |   21 ++-
 drivers/iommu/intel-iommu.c                  |   13 +-
 drivers/net/bonding/bond_alb.c               |   20 +--
 drivers/net/ethernet/broadcom/bnxt/bnxt.c    |    4=20
 drivers/net/ethernet/freescale/fec_main.c    |    6 -
 drivers/net/ethernet/micrel/ks8851_mll.c     |   14 +-
 drivers/net/ipvlan/ipvlan_core.c             |   19 +--
 drivers/net/ipvlan/ipvlan_main.c             |    5=20
 drivers/net/macsec.c                         |   12 +-
 drivers/net/macvlan.c                        |    2=20
 drivers/net/phy/phy_device.c                 |   18 +--
 drivers/net/slip/slhc.c                      |   14 +-
 drivers/net/team/team.c                      |    2=20
 drivers/net/usb/r8152.c                      |    6 +
 drivers/net/wireless/marvell/mwifiex/tdls.c  |   70 +++++++++++-
 fs/cifs/dir.c                                |    1=20
 fs/gfs2/inode.c                              |    2=20
 fs/jbd2/transaction.c                        |    8 -
 fs/nfs/dir.c                                 |    2=20
 fs/open.c                                    |    3=20
 include/linux/phy.h                          |    2=20
 include/net/fib_rules.h                      |    1=20
 kernel/cgroup.c                              |    4=20
 kernel/signal.c                              |   23 ++--
 kernel/workqueue.c                           |   14 +-
 mm/memcontrol.c                              |    4=20
 mm/slub.c                                    |    9 +
 net/batman-adv/bat_iv_ogm.c                  |  105 +++++++++++++++----
 net/batman-adv/bat_v.c                       |   25 ++--
 net/batman-adv/bat_v_elp.c                   |   22 ++-
 net/batman-adv/bat_v_ogm.c                   |   42 ++++++-
 net/batman-adv/debugfs.c                     |   40 +++++++
 net/batman-adv/debugfs.h                     |   11 +
 net/batman-adv/distributed-arp-table.c       |    5=20
 net/batman-adv/fragmentation.c               |   22 ++-
 net/batman-adv/gateway_client.c              |   11 +
 net/batman-adv/gateway_common.c              |    5=20
 net/batman-adv/hard-interface.c              |   51 +++++++--
 net/batman-adv/originator.c                  |    4=20
 net/batman-adv/originator.h                  |    4=20
 net/batman-adv/routing.c                     |   11 +
 net/batman-adv/soft-interface.c              |    1=20
 net/batman-adv/translation-table.c           |  149 ++++++++++++++++++++++=
-----
 net/batman-adv/types.h                       |   22 +++
 net/core/netclassid_cgroup.c                 |   47 ++++++--
 net/ieee802154/nl_policy.c                   |    6 +
 net/ipv4/cipso_ipv4.c                        |    7 +
 net/ipv4/gre_demux.c                         |   12 +-
 net/ipv6/addrconf.c                          |    4=20
 net/ipv6/ipv6_sockglue.c                     |   10 +
 net/mac80211/rx.c                            |    2=20
 net/netfilter/nfnetlink_cthelper.c           |    2=20
 net/nfc/hci/core.c                           |   19 ++-
 net/nfc/netlink.c                            |    3=20
 net/sched/sch_fq.c                           |    1=20
 net/wireless/nl80211.c                       |    5=20
 net/wireless/reg.c                           |    2=20
 71 files changed, 808 insertions(+), 241 deletions(-)

Al Viro (2):
      cifs_atomic_open(): fix double-put on late allocation failure
      gfs2_atomic_open(): fix O_EXCL|O_CREAT handling on cold dcache

Colin Ian King (1):
      drm/amd/display: remove duplicated assignment to grph_obj_type

Dan Carpenter (1):
      net: nfc: fix bounds checking bugs on "pipe"

Daniel Drake (1):
      iommu/vt-d: Ignore devices with out-of-spec domain number

David S. Miller (1):
      phy: Revert toggling reset changes.

Dmitry Bogdanov (1):
      net: macsec: update SCI upon MAC address change.

Dmitry Yakunin (1):
      cgroup, netclassid: periodically release file_lock on classid updating

Eric Dumazet (5):
      gre: fix uninit-value in __iptunnel_pull_header
      ipvlan: do not use cond_resched_rcu() in ipvlan_process_multicast()
      slip: make slhc_compress() more robust against malicious packets
      bonding/alb: make sure arp header is pulled before accessing it
      ipv6: restrict IPV6_ADDRFORM operation

Eugeniy Paltsev (1):
      ARC: define __ALIGN_STR and __ALIGN symbols for ARC

Florian Fainelli (2):
      net: phy: Avoid multiple suspends
      ARM: 8957/1: VDSO: Match ARMv8 timer in cntvct_functional()

Greg Kroah-Hartman (1):
      Linux 4.9.217

Halil Pasic (1):
      virtio-blk: fix hw_queue stopped on arbitrary error

Hangbin Liu (1):
      ipv6/addrconf: call ipv6_mc_up() for non-Ethernet interface

Hans de Goede (2):
      iommu/vt-d: quirk_ioat_snb_local_iommu: replace WARN_TAINT with pr_wa=
rn + add_taint
      iommu/vt-d: dmar: replace WARN_TAINT with pr_warn + add_taint

Heiner Kallweit (1):
      net: phy: fix MDIO bus PM PHY resuming

Hillf Danton (1):
      workqueue: don't use wq_select_unbound_cpu() for bound works

Jakub Kicinski (14):
      fib: add missing attribute validation for tun_id
      nl802154: add missing attribute validation
      nl802154: add missing attribute validation for dev_type
      macsec: add missing attribute validation for port
      net: fq: add missing attribute validation for orphan mask
      team: add missing attribute validation for port ifindex
      team: add missing attribute validation for array index
      nfc: add missing attribute validation for SE API
      nfc: add missing attribute validation for vendor subcommand
      net: fec: validate the new settings in fec_enet_set_coalesce()
      nl80211: add missing attribute validation for critical protocol indic=
ation
      nl80211: add missing attribute validation for beacon report scanning
      nl80211: add missing attribute validation for channel switch
      netfilter: cthelper: add missing attribute validation for cthelper

Jann Horn (1):
      mm: slub: add missing TID bump in kmem_cache_alloc_bulk()

Jean Delvare (1):
      ACPI: watchdog: Allow disabling WDAT at boot

Jiri Wiesner (1):
      ipvlan: do not add hardware address of master to its unicast filter l=
ist

Johannes Berg (1):
      cfg80211: check reg_rule for NULL in handle_channel_custom()

Kai-Heng Feng (1):
      HID: i2c-hid: add Trekstor Surfbook E11B to descriptor override

Kees Cook (1):
      ARM: 8958/1: rename missed uaccess .fixup section

Kim Phillips (1):
      perf/amd/uncore: Replace manual sampling check with CAP_NO_INTERRUPT =
flag

Linus L=FCssing (5):
      batman-adv: Fix transmission of final, 16th fragment
      batman-adv: fix TT sync flag inconsistencies
      batman-adv: Fix TT sync flags for intermediate TT responses
      batman-adv: Avoid storing non-TT-sync flags on singular entries too
      batman-adv: Fix multicast TT issues with bogus ROAM flags

Linus Torvalds (1):
      signal: avoid double atomic counter increments for user accounting

Madhuparna Bhowmik (1):
      mac80211: rx: avoid RCU list traversal under mutex

Mahesh Bandewar (3):
      ipvlan: add cond_resched_rcu() while processing muticast backlog
      ipvlan: don't deref eth hdr before checking it's set
      macvlan: add cond_resched() during multicast processing

Mansour Behabadi (1):
      HID: apple: Add support for recent firmware on Magic Keyboards

Marek Lindner (1):
      batman-adv: prevent TT request storms by not sending inconsistent TT =
TLVLs

Marek Vasut (1):
      net: ks8851-ml: Fix IRQ handling and locking

Matteo Croce (1):
      ipv4: ensure rcu_read_lock() in cipso_v4_error()

Matthias Schiffer (1):
      batman-adv: update data pointers after skb_cow()

Paolo Abeni (1):
      ipvlan: egress mcast packets are not exceptional

Petr Malat (1):
      NFS: Remove superfluous kmap in nfs_readdir_xdr_to_array

Qian Cai (1):
      jbd2: fix data races at struct journal_head

Shakeel Butt (1):
      cgroup: memcg: net: do not associate sock with unrelated cgroup

Sven Eckelmann (20):
      batman-adv: Fix double free during fragment merge error
      batman-adv: Initialize gw sel_class via batadv_algo
      batman-adv: Fix rx packet/bytes stats on local ARP reply
      batman-adv: Use default throughput value on cfg80211 error
      batman-adv: Accept only filled wifi station info
      batman-adv: Avoid spurious warnings from bat_v neigh_cmp implementati=
on
      batman-adv: Always initialize fragment header priority
      batman-adv: Fix check of retrieved orig_gw in batadv_v_gw_is_eligible
      batman-adv: Fix lock for ogm cnt access in batadv_iv_ogm_calc_tq
      batman-adv: Fix internal interface indices types
      batman-adv: Avoid race in TT TVLV allocator helper
      batman-adv: Fix debugfs path for renamed hardif
      batman-adv: Fix debugfs path for renamed softif
      batman-adv: Prevent duplicated gateway_node entry
      batman-adv: Fix duplicated OGMs on NETDEV_UP
      batman-adv: Avoid free/alloc race when handling OGM2 buffer
      batman-adv: Avoid free/alloc race when handling OGM buffer
      batman-adv: Don't schedule OGM for disabled interface
      batman-adv: Avoid probe ELP information leak
      batman-adv: Use explicit tvlv padding for ELP packets

Vasundhara Volam (1):
      bnxt_en: reinitialize IRQs when MTU is modified

Vitaly Kuznetsov (1):
      KVM: x86: clear stale x86_emulate_ctxt->intercept value

Vladis Dronov (2):
      efi: Fix a race and a buffer overflow while reading efivars via sysfs
      efi: Add a sanity check to efivar_store_raw()

Yonghyun Hwang (1):
      iommu/vt-d: Fix a bug in intel_iommu_iova_to_phys() for huge page

You-Sheng Yang (1):
      r8152: check disconnect status after long sleep

Zhenzhong Duan (1):
      iommu/vt-d: Fix the wrong printing in RHSA parsing

qize wang (1):
      mwifiex: Fix heap overflow in mmwifiex_process_tdls_action_frame()


--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl513agACgkQONu9yGCS
aT5acBAA1zQdnaztkus9G/3EMiVfFSMvDHc+iqeE64taed7jlrP3IsZ7ZrWYt1/B
BLrw6TPNjq9KOjBsbNk9Y4+5WCsONEoHHgjh7MwInWRrKMQWAegKwIb2QEnTaQwY
NycgJc26yxo+fHfCmd29nbFzF7kuS7EHXYPOibr23M2DsgjHCcuzS0/9yi33staj
8lLEvcZxOnrHHQuwV7r0KvQUy9UKVJvD5gdUoq6m3pk8RiybIAl3ScZeYAHD6nqJ
tIXLhrTqskcL0ntvAalc4x/pSW1ZO0yWpSx9VZl/Z68hFcvXUz23XiYUGccDSNTv
Jr6adWF/xMQktFdZGTVnZCx4CWJJBm24Vh8OKny4r4UmujfxzOIBNjpa7/cxR308
HtSxVKXtEP64Y7jQ/zAsHMarV7edBg9MHPgibIv67ZisFC7loLfyeIZGI9mQEiLC
hRuKSZzWnT2DYfegbj3kyDgXZ6styi08bGPVUTdXkhx0ANc+WAWz12ca5PKMtDjS
zur/MBrxb6fSH/lsMX8sPrh3Py0XnuEGlICYgcw4/ehyH22vyrC4M1AUQD7N8VK+
gDLyXTOwUp3w0b3mlLH0e6h+JcLBxRJS3vr+VvV+rodKpr+YFrhYMrOxmMqVWn4E
Jw936SW2RnIR/hXY36C4njCroPtBbEgc9ojnzezu/t8fjRPoh6Y=
=pjNV
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
