Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85D3B18DF09
	for <lists+stable@lfdr.de>; Sat, 21 Mar 2020 10:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbgCUJZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Mar 2020 05:25:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727028AbgCUJZq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Mar 2020 05:25:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35C972070A;
        Sat, 21 Mar 2020 09:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584782744;
        bh=PJqcruhBQe/aUW+8bGmUZlOBE8j6kfRtwllofDA4Zis=;
        h=Date:From:To:Cc:Subject:From;
        b=Mpu6W29aPySz4tf/z0VTDIifV1/nzX5pRJuPUWrjRUQk2MQLK1/J2owgeaqzO6A3P
         ZcR40JsEVz/2xRxVBq2mxNozYlbsruhhA5nPcCLtJ5GseovwCiWXN+C17MS6TyrV+o
         2WIRGiXmiHc3aWZ7RFfkp5KY4840FmswiNXpqrHs=
Date:   Sat, 21 Mar 2020 10:25:41 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.217
Message-ID: <20200321092541.GA887193@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.217 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                     |    2 
 arch/arc/include/asm/linkage.h               |    2 
 arch/arm/kernel/vdso.c                       |    2 
 arch/arm/lib/copy_from_user.S                |    2 
 arch/x86/kernel/cpu/perf_event_amd_uncore.c  |   16 -
 arch/x86/kvm/emulate.c                       |    1 
 drivers/firmware/efi/efivars.c               |   32 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c |    3 
 drivers/iommu/dmar.c                         |   21 +-
 drivers/iommu/intel-iommu.c                  |   13 -
 drivers/net/bonding/bond_alb.c               |   20 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c    |    4 
 drivers/net/ethernet/freescale/fec_main.c    |    6 
 drivers/net/ethernet/micrel/ks8851_mll.c     |   14 -
 drivers/net/ipvlan/ipvlan_core.c             |   19 +-
 drivers/net/ipvlan/ipvlan_main.c             |    5 
 drivers/net/macvlan.c                        |    2 
 drivers/net/slip/slhc.c                      |   14 +
 drivers/net/team/team.c                      |    2 
 drivers/net/usb/r8152.c                      |    6 
 drivers/net/wireless/mwifiex/tdls.c          |   70 ++++++-
 fs/gfs2/inode.c                              |    2 
 fs/jbd2/transaction.c                        |    8 
 fs/nfs/dir.c                                 |    2 
 include/net/fib_rules.h                      |    1 
 kernel/signal.c                              |   23 +-
 mm/slub.c                                    |    9 
 net/batman-adv/bat_iv_ogm.c                  |  115 +++++++++---
 net/batman-adv/bridge_loop_avoidance.c       |  152 +++++++++++++---
 net/batman-adv/debugfs.c                     |   40 ++++
 net/batman-adv/debugfs.h                     |   11 +
 net/batman-adv/distributed-arp-table.c       |   15 +
 net/batman-adv/fragmentation.c               |   14 -
 net/batman-adv/gateway_client.c              |   18 +
 net/batman-adv/hard-interface.c              |   89 ++++++++-
 net/batman-adv/hard-interface.h              |    6 
 net/batman-adv/main.c                        |    8 
 net/batman-adv/network-coding.c              |   33 +--
 net/batman-adv/originator.c                  |   26 ++
 net/batman-adv/originator.h                  |    4 
 net/batman-adv/routing.c                     |  111 +++++++++---
 net/batman-adv/send.c                        |    4 
 net/batman-adv/soft-interface.c              |    9 
 net/batman-adv/translation-table.c           |  249 ++++++++++++++++++---------
 net/batman-adv/types.h                       |   23 +-
 net/ieee802154/nl_policy.c                   |    6 
 net/ipv4/cipso_ipv4.c                        |    7 
 net/ipv6/ipv6_sockglue.c                     |   10 -
 net/netfilter/nfnetlink_cthelper.c           |    2 
 net/nfc/hci/core.c                           |   19 +-
 net/nfc/netlink.c                            |    3 
 net/sched/sch_fq.c                           |    1 
 net/wireless/nl80211.c                       |    3 
 53 files changed, 962 insertions(+), 317 deletions(-)

Al Viro (1):
      gfs2_atomic_open(): fix O_EXCL|O_CREAT handling on cold dcache

Andrew Lunn (1):
      batman-adv: Avoid endless loop in bat-on-bat netdevice check

Colin Ian King (1):
      drm/amd/display: remove duplicated assignment to grph_obj_type

Dan Carpenter (1):
      net: nfc: fix bounds checking bugs on "pipe"

Daniel Drake (1):
      iommu/vt-d: Ignore devices with out-of-spec domain number

Eric Dumazet (4):
      ipvlan: do not use cond_resched_rcu() in ipvlan_process_multicast()
      slip: make slhc_compress() more robust against malicious packets
      bonding/alb: make sure arp header is pulled before accessing it
      ipv6: restrict IPV6_ADDRFORM operation

Eugeniy Paltsev (1):
      ARC: define __ALIGN_STR and __ALIGN symbols for ARC

Florian Fainelli (1):
      ARM: 8957/1: VDSO: Match ARMv8 timer in cntvct_functional()

Florian Westphal (1):
      batman-adv: fix skb deref after free

Greg Kroah-Hartman (1):
      Linux 4.4.217

Hans de Goede (2):
      iommu/vt-d: quirk_ioat_snb_local_iommu: replace WARN_TAINT with pr_warn + add_taint
      iommu/vt-d: dmar: replace WARN_TAINT with pr_warn + add_taint

Jakub Kicinski (12):
      fib: add missing attribute validation for tun_id
      nl802154: add missing attribute validation
      nl802154: add missing attribute validation for dev_type
      team: add missing attribute validation for port ifindex
      team: add missing attribute validation for array index
      nfc: add missing attribute validation for SE API
      nfc: add missing attribute validation for vendor subcommand
      net: fec: validate the new settings in fec_enet_set_coalesce()
      net: fq: add missing attribute validation for orphan mask
      nl80211: add missing attribute validation for critical protocol indication
      nl80211: add missing attribute validation for channel switch
      netfilter: cthelper: add missing attribute validation for cthelper

Jann Horn (1):
      mm: slub: add missing TID bump in kmem_cache_alloc_bulk()

Jiri Wiesner (1):
      ipvlan: do not add hardware address of master to its unicast filter list

Kees Cook (1):
      ARM: 8958/1: rename missed uaccess .fixup section

Kim Phillips (1):
      perf/amd/uncore: Replace manual sampling check with CAP_NO_INTERRUPT flag

Linus Lüssing (5):
      batman-adv: Avoid duplicate neigh_node additions
      batman-adv: Fix transmission of final, 16th fragment
      batman-adv: fix TT sync flag inconsistencies
      batman-adv: Fix TT sync flags for intermediate TT responses
      batman-adv: Avoid storing non-TT-sync flags on singular entries too

Linus Torvalds (1):
      signal: avoid double atomic counter increments for user accounting

Mahesh Bandewar (3):
      ipvlan: add cond_resched_rcu() while processing muticast backlog
      ipvlan: don't deref eth hdr before checking it's set
      macvlan: add cond_resched() during multicast processing

Marek Lindner (2):
      batman-adv: init neigh node last seen field
      batman-adv: prevent TT request storms by not sending inconsistent TT TLVLs

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

Simon Wunderlich (1):
      batman-adv: lock crc access in bridge loop avoidance

Sven Eckelmann (37):
      batman-adv: Fix invalid read while copying bat_iv.bcast_own
      batman-adv: Only put gw_node list reference when removed
      batman-adv: Only put orig_node_vlan list reference when removed
      batman-adv: Fix unexpected free of bcast_own on add_if error
      batman-adv: Fix integer overflow in batadv_iv_ogm_calc_tq
      batman-adv: Deactivate TO_BE_ACTIVATED hardif on shutdown
      batman-adv: Drop reference to netdevice on last reference
      batman-adv: Fix reference counting of vlan object for tt_local_entry
      batman-adv: Fix use-after-free/double-free of tt_req_node
      batman-adv: Fix ICMP RR ethernet access after skb_linearize
      batman-adv: Clean up untagged vlan when destroying via rtnl-link
      batman-adv: Avoid nullptr dereference in bla after vlan_insert_tag
      batman-adv: Avoid nullptr dereference in dat after vlan_insert_tag
      batman-adv: Fix orig_node_vlan leak on orig_node_release
      batman-adv: Fix non-atomic bla_claim::backbone_gw access
      batman-adv: Fix reference leak in batadv_find_router
      batman-adv: Free last_bonding_candidate on release of orig_node
      batman-adv: Fix speedy join in gateway client mode
      batman-adv: Add missing refcnt for last_candidate
      batman-adv: Fix double free during fragment merge error
      batman-adv: Fix rx packet/bytes stats on local ARP reply
      batman-adv: Fix lock for ogm cnt access in batadv_iv_ogm_calc_tq
      batman-adv: Fix internal interface indices types
      batman-adv: Fix skbuff rcsum on packet reroute
      batman-adv: Avoid race in TT TVLV allocator helper
      batman-adv: Fix debugfs path for renamed hardif
      batman-adv: Fix debugfs path for renamed softif
      batman-adv: Prevent duplicated gateway_node entry
      batman-adv: Prevent duplicated nc_node entry
      batman-adv: Prevent duplicated global TT entry
      batman-adv: Prevent duplicated tvlv handler
      batman-adv: Reduce claim hash refcnt only for removed entry
      batman-adv: Reduce tt_local hash refcnt only for removed entry
      batman-adv: Reduce tt_global hash refcnt only for removed entry
      batman-adv: Only read OGM tvlv_len after buffer len check
      batman-adv: Avoid free/alloc race when handling OGM buffer
      batman-adv: Don't schedule OGM for disabled interface

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

