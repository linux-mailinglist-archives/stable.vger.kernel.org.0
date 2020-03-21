Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 162F118DF11
	for <lists+stable@lfdr.de>; Sat, 21 Mar 2020 10:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbgCUJ0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Mar 2020 05:26:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726933AbgCUJ0b (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Mar 2020 05:26:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EC362070A;
        Sat, 21 Mar 2020 09:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584782790;
        bh=OU96HeqqjZdGBSjpHFdH+OGntbzr9oJRo8W2LDI7ZuY=;
        h=Date:From:To:Cc:Subject:From;
        b=GtrhLyQPwhpcJiVUbNic8e6pMDP8RFsjjmSI94PLRjQhYLwqCknU9JQkn5B6fK+tf
         bWy1yHsEDE0QH++UgluX9Z5X1zZ3har6q7W9UeiAfLKUVYZKccH7Kd7VEhqhwW+rya
         mPK8cZhdgUJiKvjAiEb4WH5T3HTmuSXnPGaPW+fc=
Date:   Sat, 21 Mar 2020 10:26:27 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.174
Message-ID: <20200321092627.GA887411@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.174 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt    |    4=20
 Documentation/filesystems/porting                  |    7 +
 Makefile                                           |    2=20
 arch/arc/include/asm/linkage.h                     |    2=20
 arch/arm/kernel/vdso.c                             |    2=20
 arch/arm/lib/copy_from_user.S                      |    2=20
 arch/x86/events/amd/uncore.c                       |   14 +--
 arch/x86/kernel/cpu/mcheck/mce_intel.c             |    9 +-
 arch/x86/kvm/emulate.c                             |    1=20
 drivers/acpi/acpi_watchdog.c                       |   12 ++
 drivers/block/virtio_blk.c                         |    8 +
 drivers/firmware/efi/efivars.c                     |   32 +++++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c       |    3=20
 drivers/hid/hid-apple.c                            |    3=20
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c           |    8 +
 drivers/i2c/i2c-core-acpi.c                        |   10 ++
 drivers/iommu/dma-iommu.c                          |   16 +--
 drivers/iommu/dmar.c                               |   21 +++-
 drivers/iommu/intel-iommu.c                        |   13 +-
 drivers/net/bonding/bond_alb.c                     |   20 ++--
 drivers/net/can/dev.c                              |    1=20
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |    4=20
 drivers/net/ethernet/freescale/fec_main.c          |    6 -
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c   |    1=20
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h   |    2=20
 drivers/net/ethernet/huawei/hinic/hinic_hw_if.h    |    1=20
 drivers/net/ethernet/micrel/ks8851_mll.c           |   14 +--
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c |    5 +
 drivers/net/ethernet/sfc/efx.c                     |    1=20
 drivers/net/ipvlan/ipvlan_core.c                   |   19 ++--
 drivers/net/ipvlan/ipvlan_main.c                   |    5 -
 drivers/net/macsec.c                               |   12 +-
 drivers/net/macvlan.c                              |    2=20
 drivers/net/phy/phy_device.c                       |   18 ++--
 drivers/net/slip/slhc.c                            |   14 ++-
 drivers/net/slip/slip.c                            |    3=20
 drivers/net/team/team.c                            |    2=20
 drivers/net/usb/qmi_wwan.c                         |    3=20
 drivers/net/usb/r8152.c                            |    8 +
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       |    3=20
 drivers/pinctrl/core.c                             |    1=20
 drivers/pinctrl/meson/pinctrl-meson-gxl.c          |    4=20
 drivers/scsi/libfc/fc_disc.c                       |    2=20
 fs/cifs/dir.c                                      |    1=20
 fs/gfs2/inode.c                                    |    2=20
 fs/jbd2/transaction.c                              |    8 -
 fs/open.c                                          |    3=20
 include/linux/cgroup.h                             |    1=20
 include/linux/inet_diag.h                          |   18 ++--
 include/linux/phy.h                                |    2=20
 include/net/fib_rules.h                            |    1=20
 kernel/cgroup/cgroup.c                             |   37 ++++++--
 kernel/signal.c                                    |   23 +++--
 kernel/workqueue.c                                 |   14 +--
 mm/memcontrol.c                                    |   14 ---
 mm/slub.c                                          |    9 ++
 net/batman-adv/bat_iv_ogm.c                        |   94 ++++++++++++++++=
-----
 net/batman-adv/bat_v.c                             |   11 +-
 net/batman-adv/bat_v_ogm.c                         |   42 +++++++--
 net/batman-adv/debugfs.c                           |   46 ++++++++++
 net/batman-adv/debugfs.h                           |   11 ++
 net/batman-adv/fragmentation.c                     |    2=20
 net/batman-adv/hard-interface.c                    |   51 +++++++++--
 net/batman-adv/originator.c                        |    4=20
 net/batman-adv/originator.h                        |    4=20
 net/batman-adv/routing.c                           |   10 +-
 net/batman-adv/translation-table.c                 |   84 ++++++++++++++--=
--
 net/batman-adv/types.h                             |   18 ++--
 net/core/netclassid_cgroup.c                       |   47 ++++++++--
 net/core/sock.c                                    |    5 -
 net/ieee802154/nl_policy.c                         |    6 +
 net/ipv4/cipso_ipv4.c                              |    7 +
 net/ipv4/gre_demux.c                               |   12 ++
 net/ipv4/inet_connection_sock.c                    |   20 ++++
 net/ipv4/inet_diag.c                               |   44 ++++-----
 net/ipv4/raw_diag.c                                |    5 -
 net/ipv4/udp_diag.c                                |    5 -
 net/ipv6/addrconf.c                                |    4=20
 net/ipv6/ipv6_sockglue.c                           |   10 +-
 net/mac80211/rx.c                                  |    2=20
 net/netfilter/nfnetlink_cthelper.c                 |    2=20
 net/netfilter/nft_payload.c                        |    1=20
 net/netlink/af_netlink.c                           |    2=20
 net/nfc/hci/core.c                                 |   19 +++-
 net/nfc/netlink.c                                  |    3=20
 net/packet/af_packet.c                             |   13 +-
 net/sched/sch_fq.c                                 |    1=20
 net/sctp/sctp_diag.c                               |    8 -
 net/smc/smc_ib.c                                   |    2=20
 net/wireless/nl80211.c                             |    5 +
 net/wireless/reg.c                                 |    2=20
 tools/testing/ktest/ktest.pl                       |    2=20
 92 files changed, 763 insertions(+), 294 deletions(-)

Al Viro (2):
      cifs_atomic_open(): fix double-put on late allocation failure
      gfs2_atomic_open(): fix O_EXCL|O_CREAT handling on cold dcache

Charles Keepax (1):
      pinctrl: core: Remove extra kref_get which blocks hogs being freed

Colin Ian King (1):
      drm/amd/display: remove duplicated assignment to grph_obj_type

Dan Carpenter (1):
      net: nfc: fix bounds checking bugs on "pipe"

Dan Moulding (1):
      iwlwifi: mvm: Do not require PHY_SKU NVM section for 3168 devices

Daniel Drake (1):
      iommu/vt-d: Ignore devices with out-of-spec domain number

Daniele Palmas (1):
      net: usb: qmi_wwan: restore mtu min/max values after raw_ip switch

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

Florian Fainelli (2):
      net: phy: Avoid multiple suspends
      ARM: 8957/1: VDSO: Match ARMv8 timer in cntvct_functional()

Greg Kroah-Hartman (1):
      Linux 4.14.174

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

Igor Druzhinin (1):
      scsi: libfc: free response frame from GPN_ID

Jakub Kicinski (16):
      fib: add missing attribute validation for tun_id
      nl802154: add missing attribute validation
      nl802154: add missing attribute validation for dev_type
      can: add missing attribute validation for termination
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
      netfilter: nft_payload: add missing attribute validation for payload =
csum flags

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

Karsten Graul (1):
      net/smc: check for valid ib_client_data

Kees Cook (1):
      ARM: 8958/1: rename missed uaccess .fixup section

Kim Phillips (1):
      perf/amd/uncore: Replace manual sampling check with CAP_NO_INTERRUPT =
flag

Linus L=FCssing (1):
      batman-adv: Fix TT sync flags for intermediate TT responses

Linus Torvalds (1):
      signal: avoid double atomic counter increments for user accounting

Luo bin (1):
      hinic: fix a bug of setting hw_ioctxt

Madhuparna Bhowmik (1):
      mac80211: rx: avoid RCU list traversal under mutex

Mahesh Bandewar (3):
      ipvlan: add cond_resched_rcu() while processing muticast backlog
      macvlan: add cond_resched() during multicast processing
      ipvlan: don't deref eth hdr before checking it's set

Mansour Behabadi (1):
      HID: apple: Add support for recent firmware on Magic Keyboards

Marc Zyngier (1):
      iommu/dma: Fix MSI reservation allocation

Marek Lindner (1):
      batman-adv: prevent TT request storms by not sending inconsistent TT =
TLVLs

Marek Vasut (1):
      net: ks8851-ml: Fix IRQ handling and locking

Matteo Croce (1):
      ipv4: ensure rcu_read_lock() in cipso_v4_error()

Matthias Schiffer (1):
      batman-adv: update data pointers after skb_cow()

Michal Koutn=FD (1):
      cgroup: Iterate tasks that did not finish do_exit()

Nicolas Belin (1):
      pinctrl: meson-gxl: fix GPIOX sdio pins

Pablo Neira Ayuso (1):
      netlink: Use netlink header as base to calculate bad attribute offset

Paolo Abeni (1):
      ipvlan: egress mcast packets are not exceptional

Qian Cai (1):
      jbd2: fix data races at struct journal_head

Shakeel Butt (2):
      cgroup: memcg: net: do not associate sock with unrelated cgroup
      net: memcg: late association of sock to memcg

Steven Rostedt (VMware) (1):
      ktest: Add timeout for ssh sync testing

Sven Eckelmann (12):
      batman-adv: Avoid spurious warnings from bat_v neigh_cmp implementati=
on
      batman-adv: Always initialize fragment header priority
      batman-adv: Fix check of retrieved orig_gw in batadv_v_gw_is_eligible
      batman-adv: Fix lock for ogm cnt access in batadv_iv_ogm_calc_tq
      batman-adv: Fix internal interface indices types
      batman-adv: Avoid race in TT TVLV allocator helper
      batman-adv: Fix debugfs path for renamed hardif
      batman-adv: Fix debugfs path for renamed softif
      batman-adv: Fix duplicated OGMs on NETDEV_UP
      batman-adv: Avoid free/alloc race when handling OGM2 buffer
      batman-adv: Avoid free/alloc race when handling OGM buffer
      batman-adv: Don't schedule OGM for disabled interface

Taehee Yoo (1):
      net: rmnet: fix NULL pointer dereference in rmnet_newlink()

Tony Luck (1):
      x86/mce: Fix logic and comments around MSR_PPIN_CTL

Vasily Averin (1):
      cgroup: cgroup_procs_next should increase position index

Vasundhara Volam (1):
      bnxt_en: reinitialize IRQs when MTU is modified

Vitaly Kuznetsov (1):
      KVM: x86: clear stale x86_emulate_ctxt->intercept value

Vladis Dronov (2):
      efi: Fix a race and a buffer overflow while reading efivars via sysfs
      efi: Add a sanity check to efivar_store_raw()

Willem de Bruijn (1):
      net/packet: tpacket_rcv: do not increment ring index on drop

Wolfram Sang (1):
      i2c: acpi: put device when verifying client fails

Yonghyun Hwang (1):
      iommu/vt-d: Fix a bug in intel_iommu_iova_to_phys() for huge page

You-Sheng Yang (1):
      r8152: check disconnect status after long sleep

Zhenzhong Duan (1):
      iommu/vt-d: Fix the wrong printing in RHSA parsing

yangerkun (1):
      slip: not call free_netdev before rtnl_unlock in slip_open


--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl513cMACgkQONu9yGCS
aT4DnQ//Tpojg3lSNwiyW6WXP90Bg7HrdJMBe3pJqMq9RrY0jQX0ZUN4zS/zK2vm
8KMap2xfxylMNfOhW6SlF+aQNCA6eYiaMDzqZIJTvw91ANd1Sa0IyY7TXdR/Nl6W
cSOHiHt+lSIVuiQoxT5dp4jAsSOvoLa0s/hJ5SYnryi8gvC+laU1rOeksqjHSQ6M
0uxC0FeoqSu1ZlW4yuNvNlidrVbZ859jcrrcnkiXaVBAVdsvU487XrMVUz5++2fB
OwUwGu4lkcun+j4NZAstT0QrxTH+BxkVhg0nYUoNrBszaQTBHK55svvieUNx3J1b
tCMpPu79Y7W/GGmzuxmxtS+IBGjHmgS8rMTWHr4qBvICOxKUVXC8S0UFnJQBCWJE
ST/Y4DAsR+PKmIutx8IztXZYSyaREuYwMNqqGMRvP3l7AhzreFkaFKaonEon47Ol
yeyssM1Z3HDlWi0LKMSjXaqUDTBFExwLivkDoMtYl7NjKjr228n4vmo97fMg4o0o
RHBZvlwOdQOzgP9cC0gMVWwksVs+3bCwDQLLE+wabi2lInrxog5o4ihh+sy0X8+G
2ekbiyoHJ8EoNrXual6vP7SX6g9p6IDUeU6gwNJlroKfVND3DmnM9MUf5LpmWCtj
9Eq7IyIkxkZyOdBGXDap4kOvbWdDZ1G4uB64XtgElxHPVQHKHnY=
=Oe73
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
