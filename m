Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0889018B82C
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbgCSNFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:05:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727464AbgCSNFp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:05:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF3BA20732;
        Thu, 19 Mar 2020 13:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623143;
        bh=xw0y8WrS6V588VNVtxeTZmZ/HUfkptxGbM8w1n7hFbU=;
        h=From:To:Cc:Subject:Date:From;
        b=JK5pefrAs016XmxmzXprUA7HBXRzoKGOv/cJlQQD5RhEwog6+P5K1u41a2pfcvxr7
         QMM1Bqc/4+tQOAJ/m0P5kEG6Em0UmdHygnbQKVUR9KF+IqPrpUI2qo9EqoMwWVYUj/
         s9qZS5LtY9wvNpOx20CJ4CSCm58ZC6dPkCbISuRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.4 00/93] 4.4.217-rc1 review
Date:   Thu, 19 Mar 2020 13:59:04 +0100
Message-Id: <20200319123924.795019515@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.217-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.217-rc1
X-KernelTest-Deadline: 2020-03-21T12:39+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.217 release.
There are 93 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 21 Mar 2020 12:37:04 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.217-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.217-rc1

Matteo Croce <mcroce@redhat.com>
    ipv4: ensure rcu_read_lock() in cipso_v4_error()

Jann Horn <jannh@google.com>
    mm: slub: add missing TID bump in kmem_cache_alloc_bulk()

Kees Cook <keescook@chromium.org>
    ARM: 8958/1: rename missed uaccess .fixup section

Florian Fainelli <f.fainelli@gmail.com>
    ARM: 8957/1: VDSO: Match ARMv8 timer in cntvct_functional()

Qian Cai <cai@lca.pw>
    jbd2: fix data races at struct journal_head

Linus Torvalds <torvalds@linux-foundation.org>
    signal: avoid double atomic counter increments for user accounting

Marek Vasut <marex@denx.de>
    net: ks8851-ml: Fix IRQ handling and locking

Kim Phillips <kim.phillips@amd.com>
    perf/amd/uncore: Replace manual sampling check with CAP_NO_INTERRUPT flag

Sven Eckelmann <sven@narfation.org>
    batman-adv: Don't schedule OGM for disabled interface

Sven Eckelmann <sven@narfation.org>
    batman-adv: Avoid free/alloc race when handling OGM buffer

Sven Eckelmann <sven@narfation.org>
    batman-adv: Only read OGM tvlv_len after buffer len check

Sven Eckelmann <sven@narfation.org>
    batman-adv: Reduce tt_global hash refcnt only for removed entry

Sven Eckelmann <sven@narfation.org>
    batman-adv: Reduce tt_local hash refcnt only for removed entry

Sven Eckelmann <sven@narfation.org>
    batman-adv: Reduce claim hash refcnt only for removed entry

Sven Eckelmann <sven@narfation.org>
    batman-adv: Prevent duplicated tvlv handler

Sven Eckelmann <sven@narfation.org>
    batman-adv: Prevent duplicated global TT entry

Sven Eckelmann <sven@narfation.org>
    batman-adv: Prevent duplicated nc_node entry

Sven Eckelmann <sven@narfation.org>
    batman-adv: Prevent duplicated gateway_node entry

Linus Lüssing <linus.luessing@c0d3.blue>
    batman-adv: Avoid storing non-TT-sync flags on singular entries too

Sven Eckelmann <sven@narfation.org>
    batman-adv: Fix debugfs path for renamed softif

Sven Eckelmann <sven@narfation.org>
    batman-adv: Fix debugfs path for renamed hardif

Marek Lindner <mareklindner@neomailbox.ch>
    batman-adv: prevent TT request storms by not sending inconsistent TT TLVLs

Linus Lüssing <linus.luessing@c0d3.blue>
    batman-adv: Fix TT sync flags for intermediate TT responses

Sven Eckelmann <sven@narfation.org>
    batman-adv: Avoid race in TT TVLV allocator helper

Sven Eckelmann <sven@narfation.org>
    batman-adv: Fix skbuff rcsum on packet reroute

Matthias Schiffer <mschiffer@universe-factory.net>
    batman-adv: update data pointers after skb_cow()

Sven Eckelmann <sven@narfation.org>
    batman-adv: Fix internal interface indices types

Sven Eckelmann <sven@narfation.org>
    batman-adv: Fix lock for ogm cnt access in batadv_iv_ogm_calc_tq

Linus Lüssing <linus.luessing@c0d3.blue>
    batman-adv: fix TT sync flag inconsistencies

Sven Eckelmann <sven@narfation.org>
    batman-adv: Fix rx packet/bytes stats on local ARP reply

Linus Lüssing <linus.luessing@c0d3.blue>
    batman-adv: Fix transmission of final, 16th fragment

Sven Eckelmann <sven@narfation.org>
    batman-adv: Fix double free during fragment merge error

Sven Eckelmann <sven@narfation.org>
    batman-adv: Add missing refcnt for last_candidate

Sven Eckelmann <sven@narfation.org>
    batman-adv: Fix speedy join in gateway client mode

Sven Eckelmann <sven@narfation.org>
    batman-adv: Free last_bonding_candidate on release of orig_node

Sven Eckelmann <sven@narfation.org>
    batman-adv: Fix reference leak in batadv_find_router

Sven Eckelmann <sven@narfation.org>
    batman-adv: Fix non-atomic bla_claim::backbone_gw access

Simon Wunderlich <sw@simonwunderlich.de>
    batman-adv: lock crc access in bridge loop avoidance

Sven Eckelmann <sven@narfation.org>
    batman-adv: Fix orig_node_vlan leak on orig_node_release

Sven Eckelmann <sven@narfation.org>
    batman-adv: Avoid nullptr dereference in dat after vlan_insert_tag

Sven Eckelmann <sven@narfation.org>
    batman-adv: Avoid nullptr dereference in bla after vlan_insert_tag

Sven Eckelmann <sven@narfation.org>
    batman-adv: Clean up untagged vlan when destroying via rtnl-link

Sven Eckelmann <sven@narfation.org>
    batman-adv: Fix ICMP RR ethernet access after skb_linearize

Sven Eckelmann <sven@narfation.org>
    batman-adv: Fix use-after-free/double-free of tt_req_node

Florian Westphal <fw@strlen.de>
    batman-adv: fix skb deref after free

Linus Lüssing <linus.luessing@c0d3.blue>
    batman-adv: Avoid duplicate neigh_node additions

Sven Eckelmann <sven@narfation.org>
    batman-adv: Fix reference counting of vlan object for tt_local_entry

Sven Eckelmann <sven@narfation.org>
    batman-adv: Drop reference to netdevice on last reference

Sven Eckelmann <sven@narfation.org>
    batman-adv: Deactivate TO_BE_ACTIVATED hardif on shutdown

Marek Lindner <mareklindner@neomailbox.ch>
    batman-adv: init neigh node last seen field

Sven Eckelmann <sven.eckelmann@open-mesh.com>
    batman-adv: Fix integer overflow in batadv_iv_ogm_calc_tq

Sven Eckelmann <sven@narfation.org>
    batman-adv: Fix unexpected free of bcast_own on add_if error

Andrew Lunn <andrew@lunn.ch>
    batman-adv: Avoid endless loop in bat-on-bat netdevice check

Sven Eckelmann <sven@narfation.org>
    batman-adv: Only put orig_node_vlan list reference when removed

Sven Eckelmann <sven@narfation.org>
    batman-adv: Only put gw_node list reference when removed

Sven Eckelmann <sven@narfation.org>
    batman-adv: Fix invalid read while copying bat_iv.bcast_own

Vladis Dronov <vdronov@redhat.com>
    efi: Add a sanity check to efivar_store_raw()

Eric Dumazet <edumazet@google.com>
    ipv6: restrict IPV6_ADDRFORM operation

qize wang <wangqize888888888@gmail.com>
    mwifiex: Fix heap overflow in mmwifiex_process_tdls_action_frame()

Daniel Drake <drake@endlessm.com>
    iommu/vt-d: Ignore devices with out-of-spec domain number

Zhenzhong Duan <zhenzhong.duan@gmail.com>
    iommu/vt-d: Fix the wrong printing in RHSA parsing

Jakub Kicinski <kuba@kernel.org>
    netfilter: cthelper: add missing attribute validation for cthelper

Jakub Kicinski <kuba@kernel.org>
    nl80211: add missing attribute validation for channel switch

Jakub Kicinski <kuba@kernel.org>
    nl80211: add missing attribute validation for critical protocol indication

Yonghyun Hwang <yonghyun@google.com>
    iommu/vt-d: Fix a bug in intel_iommu_iova_to_phys() for huge page

Hans de Goede <hdegoede@redhat.com>
    iommu/vt-d: dmar: replace WARN_TAINT with pr_warn + add_taint

Vladis Dronov <vdronov@redhat.com>
    efi: Fix a race and a buffer overflow while reading efivars via sysfs

Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
    ARC: define __ALIGN_STR and __ALIGN symbols for ARC

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: clear stale x86_emulate_ctxt->intercept value

Al Viro <viro@zeniv.linux.org.uk>
    gfs2_atomic_open(): fix O_EXCL|O_CREAT handling on cold dcache

Colin Ian King <colin.king@canonical.com>
    drm/amd/display: remove duplicated assignment to grph_obj_type

Hans de Goede <hdegoede@redhat.com>
    iommu/vt-d: quirk_ioat_snb_local_iommu: replace WARN_TAINT with pr_warn + add_taint

Jakub Kicinski <kuba@kernel.org>
    net: fq: add missing attribute validation for orphan mask

Eric Dumazet <edumazet@google.com>
    bonding/alb: make sure arp header is pulled before accessing it

Eric Dumazet <edumazet@google.com>
    slip: make slhc_compress() more robust against malicious packets

Jakub Kicinski <kuba@kernel.org>
    net: fec: validate the new settings in fec_enet_set_coalesce()

Mahesh Bandewar <maheshb@google.com>
    macvlan: add cond_resched() during multicast processing

Mahesh Bandewar <maheshb@google.com>
    ipvlan: don't deref eth hdr before checking it's set

Eric Dumazet <edumazet@google.com>
    ipvlan: do not use cond_resched_rcu() in ipvlan_process_multicast()

Paolo Abeni <pabeni@redhat.com>
    ipvlan: egress mcast packets are not exceptional

Jiri Wiesner <jwiesner@suse.com>
    ipvlan: do not add hardware address of master to its unicast filter list

Mahesh Bandewar <maheshb@google.com>
    ipvlan: add cond_resched_rcu() while processing muticast backlog

Jakub Kicinski <kuba@kernel.org>
    nfc: add missing attribute validation for vendor subcommand

Jakub Kicinski <kuba@kernel.org>
    nfc: add missing attribute validation for SE API

Jakub Kicinski <kuba@kernel.org>
    team: add missing attribute validation for array index

Jakub Kicinski <kuba@kernel.org>
    team: add missing attribute validation for port ifindex

Jakub Kicinski <kuba@kernel.org>
    nl802154: add missing attribute validation for dev_type

Jakub Kicinski <kuba@kernel.org>
    nl802154: add missing attribute validation

Jakub Kicinski <kuba@kernel.org>
    fib: add missing attribute validation for tun_id

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: reinitialize IRQs when MTU is modified

Dan Carpenter <dan.carpenter@oracle.com>
    net: nfc: fix bounds checking bugs on "pipe"

You-Sheng Yang <vicamo.yang@canonical.com>
    r8152: check disconnect status after long sleep

Petr Malat <oss@malat.biz>
    NFS: Remove superfluous kmap in nfs_readdir_xdr_to_array


-------------

Diffstat:

 Makefile                                     |   4 +-
 arch/arc/include/asm/linkage.h               |   2 +
 arch/arm/kernel/vdso.c                       |   2 +
 arch/arm/lib/copy_from_user.S                |   2 +-
 arch/x86/kernel/cpu/perf_event_amd_uncore.c  |  16 +-
 arch/x86/kvm/emulate.c                       |   1 +
 drivers/firmware/efi/efivars.c               |  32 +++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c |   3 +-
 drivers/iommu/dmar.c                         |  21 ++-
 drivers/iommu/intel-iommu.c                  |  13 +-
 drivers/net/bonding/bond_alb.c               |  20 +--
 drivers/net/ethernet/broadcom/bnxt/bnxt.c    |   4 +-
 drivers/net/ethernet/freescale/fec_main.c    |   6 +-
 drivers/net/ethernet/micrel/ks8851_mll.c     |  14 +-
 drivers/net/ipvlan/ipvlan_core.c             |  19 +-
 drivers/net/ipvlan/ipvlan_main.c             |   5 +-
 drivers/net/macvlan.c                        |   2 +
 drivers/net/slip/slhc.c                      |  14 +-
 drivers/net/team/team.c                      |   2 +
 drivers/net/usb/r8152.c                      |   6 +
 drivers/net/wireless/mwifiex/tdls.c          |  70 +++++++-
 fs/gfs2/inode.c                              |   2 +-
 fs/jbd2/transaction.c                        |   8 +-
 fs/nfs/dir.c                                 |   2 -
 include/net/fib_rules.h                      |   1 +
 kernel/signal.c                              |  23 ++-
 mm/slub.c                                    |   9 +
 net/batman-adv/bat_iv_ogm.c                  | 115 +++++++++----
 net/batman-adv/bridge_loop_avoidance.c       | 152 +++++++++++++---
 net/batman-adv/debugfs.c                     |  40 +++++
 net/batman-adv/debugfs.h                     |  11 ++
 net/batman-adv/distributed-arp-table.c       |  15 +-
 net/batman-adv/fragmentation.c               |  14 +-
 net/batman-adv/gateway_client.c              |  18 +-
 net/batman-adv/hard-interface.c              |  89 ++++++++--
 net/batman-adv/hard-interface.h              |   6 +-
 net/batman-adv/main.c                        |   8 +-
 net/batman-adv/network-coding.c              |  33 ++--
 net/batman-adv/originator.c                  |  26 ++-
 net/batman-adv/originator.h                  |   4 +-
 net/batman-adv/routing.c                     | 111 +++++++++---
 net/batman-adv/send.c                        |   4 +-
 net/batman-adv/soft-interface.c              |   9 +
 net/batman-adv/translation-table.c           | 249 ++++++++++++++++++---------
 net/batman-adv/types.h                       |  23 ++-
 net/ieee802154/nl_policy.c                   |   6 +
 net/ipv4/cipso_ipv4.c                        |   7 +-
 net/ipv6/ipv6_sockglue.c                     |  10 +-
 net/netfilter/nfnetlink_cthelper.c           |   2 +
 net/nfc/hci/core.c                           |  19 +-
 net/nfc/netlink.c                            |   3 +
 net/sched/sch_fq.c                           |   1 +
 net/wireless/nl80211.c                       |   3 +
 53 files changed, 963 insertions(+), 318 deletions(-)


