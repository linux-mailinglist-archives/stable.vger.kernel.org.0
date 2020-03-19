Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8056D18B7D0
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbgCSNK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:10:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727345AbgCSNK2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:10:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFF3F2145D;
        Thu, 19 Mar 2020 13:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623427;
        bh=Vx2xi/DRW2kcc7cTT/7poelu4Z9hp/UMPNMvqQG5O5I=;
        h=From:To:Cc:Subject:Date:From;
        b=hetTUdIWuz7c8DqHFhREhwc1YISAr7cOfrgMuJ263rVjJVFNOHN2QANk5YEvssleS
         d90KRSFq/9csjcL7yIiJ7YKWb8640G+LqRWyyywpKjSmDA7TzEAVCNq4JEhlfOpigi
         RkMLEYMtt2Botsy90HOTUtPQ1mfR9Ye8wQMr5MAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 00/90] 4.9.217-rc1 review
Date:   Thu, 19 Mar 2020 13:59:22 +0100
Message-Id: <20200319123928.635114118@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.217-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.217-rc1
X-KernelTest-Deadline: 2020-03-21T12:39+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.217 release.
There are 90 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 21 Mar 2020 12:37:04 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.217-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.217-rc1

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

Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
    mac80211: rx: avoid RCU list traversal under mutex

Marek Vasut <marex@denx.de>
    net: ks8851-ml: Fix IRQ handling and locking

Johannes Berg <johannes.berg@intel.com>
    cfg80211: check reg_rule for NULL in handle_channel_custom()

Kai-Heng Feng <kai.heng.feng@canonical.com>
    HID: i2c-hid: add Trekstor Surfbook E11B to descriptor override

Mansour Behabadi <mansour@oxplot.com>
    HID: apple: Add support for recent firmware on Magic Keyboards

Jean Delvare <jdelvare@suse.de>
    ACPI: watchdog: Allow disabling WDAT at boot

Kim Phillips <kim.phillips@amd.com>
    perf/amd/uncore: Replace manual sampling check with CAP_NO_INTERRUPT flag

Sven Eckelmann <sven@narfation.org>
    batman-adv: Use explicit tvlv padding for ELP packets

Sven Eckelmann <sven@narfation.org>
    batman-adv: Avoid probe ELP information leak

Matthias Schiffer <mschiffer@universe-factory.net>
    batman-adv: update data pointers after skb_cow()

Sven Eckelmann <sven@narfation.org>
    batman-adv: Don't schedule OGM for disabled interface

Sven Eckelmann <sven@narfation.org>
    batman-adv: Avoid free/alloc race when handling OGM buffer

Sven Eckelmann <sven@narfation.org>
    batman-adv: Avoid free/alloc race when handling OGM2 buffer

Sven Eckelmann <sven@narfation.org>
    batman-adv: Fix duplicated OGMs on NETDEV_UP

Sven Eckelmann <sven@narfation.org>
    batman-adv: Prevent duplicated gateway_node entry

Linus Lüssing <linus.luessing@c0d3.blue>
    batman-adv: Fix multicast TT issues with bogus ROAM flags

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
    batman-adv: Fix internal interface indices types

Sven Eckelmann <sven@narfation.org>
    batman-adv: Fix lock for ogm cnt access in batadv_iv_ogm_calc_tq

Sven Eckelmann <sven.eckelmann@openmesh.com>
    batman-adv: Fix check of retrieved orig_gw in batadv_v_gw_is_eligible

Sven Eckelmann <sven.eckelmann@open-mesh.com>
    batman-adv: Always initialize fragment header priority

Sven Eckelmann <sven.eckelmann@openmesh.com>
    batman-adv: Avoid spurious warnings from bat_v neigh_cmp implementation

Linus Lüssing <linus.luessing@c0d3.blue>
    batman-adv: fix TT sync flag inconsistencies

Sven Eckelmann <sven@narfation.org>
    batman-adv: Accept only filled wifi station info

Sven Eckelmann <sven@narfation.org>
    batman-adv: Use default throughput value on cfg80211 error

Sven Eckelmann <sven@narfation.org>
    batman-adv: Fix rx packet/bytes stats on local ARP reply

Sven Eckelmann <sven@narfation.org>
    batman-adv: Initialize gw sel_class via batadv_algo

Linus Lüssing <linus.luessing@c0d3.blue>
    batman-adv: Fix transmission of final, 16th fragment

Sven Eckelmann <sven@narfation.org>
    batman-adv: Fix double free during fragment merge error

Vladis Dronov <vdronov@redhat.com>
    efi: Add a sanity check to efivar_store_raw()

Eric Dumazet <edumazet@google.com>
    ipv6: restrict IPV6_ADDRFORM operation

Daniel Drake <drake@endlessm.com>
    iommu/vt-d: Ignore devices with out-of-spec domain number

Zhenzhong Duan <zhenzhong.duan@gmail.com>
    iommu/vt-d: Fix the wrong printing in RHSA parsing

qize wang <wangqize888888888@gmail.com>
    mwifiex: Fix heap overflow in mmwifiex_process_tdls_action_frame()

Jakub Kicinski <kuba@kernel.org>
    netfilter: cthelper: add missing attribute validation for cthelper

Jakub Kicinski <kuba@kernel.org>
    nl80211: add missing attribute validation for channel switch

Jakub Kicinski <kuba@kernel.org>
    nl80211: add missing attribute validation for beacon report scanning

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

Al Viro <viro@zeniv.linux.org.uk>
    cifs_atomic_open(): fix double-put on late allocation failure

Colin Ian King <colin.king@canonical.com>
    drm/amd/display: remove duplicated assignment to grph_obj_type

Hillf Danton <hdanton@sina.com>
    workqueue: don't use wq_select_unbound_cpu() for bound works

Hans de Goede <hdegoede@redhat.com>
    iommu/vt-d: quirk_ioat_snb_local_iommu: replace WARN_TAINT with pr_warn + add_taint

Halil Pasic <pasic@linux.ibm.com>
    virtio-blk: fix hw_queue stopped on arbitrary error

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: fix MDIO bus PM PHY resuming

Shakeel Butt <shakeelb@google.com>
    cgroup: memcg: net: do not associate sock with unrelated cgroup

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
    net: fq: add missing attribute validation for orphan mask

Jakub Kicinski <kuba@kernel.org>
    macsec: add missing attribute validation for port

Jakub Kicinski <kuba@kernel.org>
    nl802154: add missing attribute validation for dev_type

Jakub Kicinski <kuba@kernel.org>
    nl802154: add missing attribute validation

Jakub Kicinski <kuba@kernel.org>
    fib: add missing attribute validation for tun_id

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: reinitialize IRQs when MTU is modified

You-Sheng Yang <vicamo.yang@canonical.com>
    r8152: check disconnect status after long sleep

Dan Carpenter <dan.carpenter@oracle.com>
    net: nfc: fix bounds checking bugs on "pipe"

Dmitry Bogdanov <dbogdanov@marvell.com>
    net: macsec: update SCI upon MAC address change.

Hangbin Liu <liuhangbin@gmail.com>
    ipv6/addrconf: call ipv6_mc_up() for non-Ethernet interface

Eric Dumazet <edumazet@google.com>
    gre: fix uninit-value in __iptunnel_pull_header

Dmitry Yakunin <zeil@yandex-team.ru>
    cgroup, netclassid: periodically release file_lock on classid updating

Florian Fainelli <f.fainelli@gmail.com>
    net: phy: Avoid multiple suspends

David S. Miller <davem@davemloft.net>
    phy: Revert toggling reset changes.

Petr Malat <oss@malat.biz>
    NFS: Remove superfluous kmap in nfs_readdir_xdr_to_array


-------------

Diffstat:

 Documentation/filesystems/porting            |   7 ++
 Documentation/kernel-parameters.txt          |   4 +
 Makefile                                     |   4 +-
 arch/arc/include/asm/linkage.h               |   2 +
 arch/arm/kernel/vdso.c                       |   2 +
 arch/arm/lib/copy_from_user.S                |   2 +-
 arch/x86/events/amd/uncore.c                 |  14 +--
 arch/x86/kvm/emulate.c                       |   1 +
 drivers/acpi/acpi_watchdog.c                 |  12 ++-
 drivers/block/virtio_blk.c                   |   8 +-
 drivers/firmware/efi/efivars.c               |  32 ++++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c |   3 +-
 drivers/hid/hid-apple.c                      |   3 +-
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c     |   8 ++
 drivers/iommu/dmar.c                         |  21 ++--
 drivers/iommu/intel-iommu.c                  |  13 ++-
 drivers/net/bonding/bond_alb.c               |  20 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.c    |   4 +-
 drivers/net/ethernet/freescale/fec_main.c    |   6 +-
 drivers/net/ethernet/micrel/ks8851_mll.c     |  14 +--
 drivers/net/ipvlan/ipvlan_core.c             |  19 ++--
 drivers/net/ipvlan/ipvlan_main.c             |   5 +-
 drivers/net/macsec.c                         |  12 ++-
 drivers/net/macvlan.c                        |   2 +
 drivers/net/phy/phy_device.c                 |  18 ++--
 drivers/net/slip/slhc.c                      |  14 ++-
 drivers/net/team/team.c                      |   2 +
 drivers/net/usb/r8152.c                      |   6 ++
 drivers/net/wireless/marvell/mwifiex/tdls.c  |  70 +++++++++++--
 fs/cifs/dir.c                                |   1 -
 fs/gfs2/inode.c                              |   2 +-
 fs/jbd2/transaction.c                        |   8 +-
 fs/nfs/dir.c                                 |   2 -
 fs/open.c                                    |   3 -
 include/linux/phy.h                          |   2 +
 include/net/fib_rules.h                      |   1 +
 kernel/cgroup.c                              |   4 +
 kernel/signal.c                              |  23 +++--
 kernel/workqueue.c                           |  14 +--
 mm/memcontrol.c                              |   4 +
 mm/slub.c                                    |   9 ++
 net/batman-adv/bat_iv_ogm.c                  | 105 +++++++++++++++----
 net/batman-adv/bat_v.c                       |  25 +++--
 net/batman-adv/bat_v_elp.c                   |  22 ++--
 net/batman-adv/bat_v_ogm.c                   |  42 ++++++--
 net/batman-adv/debugfs.c                     |  40 +++++++
 net/batman-adv/debugfs.h                     |  11 ++
 net/batman-adv/distributed-arp-table.c       |   5 +-
 net/batman-adv/fragmentation.c               |  22 ++--
 net/batman-adv/gateway_client.c              |  11 +-
 net/batman-adv/gateway_common.c              |   5 +
 net/batman-adv/hard-interface.c              |  51 +++++++--
 net/batman-adv/originator.c                  |   4 +-
 net/batman-adv/originator.h                  |   4 +-
 net/batman-adv/routing.c                     |  11 +-
 net/batman-adv/soft-interface.c              |   1 -
 net/batman-adv/translation-table.c           | 149 ++++++++++++++++++++++-----
 net/batman-adv/types.h                       |  22 +++-
 net/core/netclassid_cgroup.c                 |  47 +++++++--
 net/ieee802154/nl_policy.c                   |   6 ++
 net/ipv4/cipso_ipv4.c                        |   7 +-
 net/ipv4/gre_demux.c                         |  12 ++-
 net/ipv6/addrconf.c                          |   4 +
 net/ipv6/ipv6_sockglue.c                     |  10 +-
 net/mac80211/rx.c                            |   2 +-
 net/netfilter/nfnetlink_cthelper.c           |   2 +
 net/nfc/hci/core.c                           |  19 +++-
 net/nfc/netlink.c                            |   3 +
 net/sched/sch_fq.c                           |   1 +
 net/wireless/nl80211.c                       |   5 +
 net/wireless/reg.c                           |   2 +-
 71 files changed, 809 insertions(+), 242 deletions(-)


