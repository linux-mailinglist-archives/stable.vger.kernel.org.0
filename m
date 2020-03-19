Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2CD18B746
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbgCSNP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:15:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729461AbgCSNPz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:15:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51216206D7;
        Thu, 19 Mar 2020 13:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623753;
        bh=44tAXdqB0IoMAI/gtsTT8ovufPZ/YTqKppLq7YUIRIk=;
        h=From:To:Cc:Subject:Date:From;
        b=pFBp7Z3pQc6AhRBdn4Mq3x1jg52xR8jXR2xA0POQT080oJrbf/UsZzFMqXEqGoDJZ
         +SfBJTdaKoYnJRmghnrX/g+AmC9SmQt5Vw5n3KFVN7Lw8ktlN0hflq7tyFCcYOH85v
         EbbH0yQc0YRZ549uvGwvPmA31lvkRhamUzam+cYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/99] 4.14.174-rc1 review
Date:   Thu, 19 Mar 2020 14:02:38 +0100
Message-Id: <20200319123941.630731708@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.174-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.174-rc1
X-KernelTest-Deadline: 2020-03-21T12:40+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.174 release.
There are 99 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 21 Mar 2020 12:37:04 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.174-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.174-rc1

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

Taehee Yoo <ap420073@gmail.com>
    net: rmnet: fix NULL pointer dereference in rmnet_newlink()

Luo bin <luobin9@huawei.com>
    hinic: fix a bug of setting hw_ioctxt

yangerkun <yangerkun@huawei.com>
    slip: not call free_netdev before rtnl_unlock in slip_open

Linus Torvalds <torvalds@linux-foundation.org>
    signal: avoid double atomic counter increments for user accounting

Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
    mac80211: rx: avoid RCU list traversal under mutex

Marek Vasut <marex@denx.de>
    net: ks8851-ml: Fix IRQ handling and locking

Daniele Palmas <dnlplm@gmail.com>
    net: usb: qmi_wwan: restore mtu min/max values after raw_ip switch

Igor Druzhinin <igor.druzhinin@citrix.com>
    scsi: libfc: free response frame from GPN_ID

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
    batman-adv: Don't schedule OGM for disabled interface

Sven Eckelmann <sven@narfation.org>
    batman-adv: Avoid free/alloc race when handling OGM buffer

Sven Eckelmann <sven@narfation.org>
    batman-adv: Avoid free/alloc race when handling OGM2 buffer

Sven Eckelmann <sven@narfation.org>
    batman-adv: Fix duplicated OGMs on NETDEV_UP

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

Matthias Schiffer <mschiffer@universe-factory.net>
    batman-adv: update data pointers after skb_cow()

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

Vladis Dronov <vdronov@redhat.com>
    efi: Add a sanity check to efivar_store_raw()

Karsten Graul <kgraul@linux.ibm.com>
    net/smc: check for valid ib_client_data

Eric Dumazet <edumazet@google.com>
    ipv6: restrict IPV6_ADDRFORM operation

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: acpi: put device when verifying client fails

Daniel Drake <drake@endlessm.com>
    iommu/vt-d: Ignore devices with out-of-spec domain number

Zhenzhong Duan <zhenzhong.duan@gmail.com>
    iommu/vt-d: Fix the wrong printing in RHSA parsing

Jakub Kicinski <kuba@kernel.org>
    netfilter: nft_payload: add missing attribute validation for payload csum flags

Jakub Kicinski <kuba@kernel.org>
    netfilter: cthelper: add missing attribute validation for cthelper

Jakub Kicinski <kuba@kernel.org>
    nl80211: add missing attribute validation for channel switch

Jakub Kicinski <kuba@kernel.org>
    nl80211: add missing attribute validation for beacon report scanning

Jakub Kicinski <kuba@kernel.org>
    nl80211: add missing attribute validation for critical protocol indication

Charles Keepax <ckeepax@opensource.cirrus.com>
    pinctrl: core: Remove extra kref_get which blocks hogs being freed

Nicolas Belin <nbelin@baylibre.com>
    pinctrl: meson-gxl: fix GPIOX sdio pins

Yonghyun Hwang <yonghyun@google.com>
    iommu/vt-d: Fix a bug in intel_iommu_iova_to_phys() for huge page

Hans de Goede <hdegoede@redhat.com>
    iommu/vt-d: dmar: replace WARN_TAINT with pr_warn + add_taint

Marc Zyngier <maz@kernel.org>
    iommu/dma: Fix MSI reservation allocation

Tony Luck <tony.luck@intel.com>
    x86/mce: Fix logic and comments around MSR_PPIN_CTL

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

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ktest: Add timeout for ssh sync testing

Colin Ian King <colin.king@canonical.com>
    drm/amd/display: remove duplicated assignment to grph_obj_type

Hillf Danton <hdanton@sina.com>
    workqueue: don't use wq_select_unbound_cpu() for bound works

Hans de Goede <hdegoede@redhat.com>
    iommu/vt-d: quirk_ioat_snb_local_iommu: replace WARN_TAINT with pr_warn + add_taint

Halil Pasic <pasic@linux.ibm.com>
    virtio-blk: fix hw_queue stopped on arbitrary error

Dan Moulding <dmoulding@me.com>
    iwlwifi: mvm: Do not require PHY_SKU NVM section for 3168 devices

Michal Koutný <mkoutny@suse.com>
    cgroup: Iterate tasks that did not finish do_exit()

Vasily Averin <vvs@virtuozzo.com>
    cgroup: cgroup_procs_next should increase position index

Mahesh Bandewar <maheshb@google.com>
    ipvlan: don't deref eth hdr before checking it's set

Paolo Abeni <pabeni@redhat.com>
    ipvlan: egress mcast packets are not exceptional

Jiri Wiesner <jwiesner@suse.com>
    ipvlan: do not add hardware address of master to its unicast filter list

Dmitry Yakunin <zeil@yandex-team.ru>
    inet_diag: return classid for all socket types

Mahesh Bandewar <maheshb@google.com>
    macvlan: add cond_resched() during multicast processing

Jakub Kicinski <kuba@kernel.org>
    net: fec: validate the new settings in fec_enet_set_coalesce()

Eric Dumazet <edumazet@google.com>
    slip: make slhc_compress() more robust against malicious packets

Eric Dumazet <edumazet@google.com>
    bonding/alb: make sure arp header is pulled before accessing it

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: fix MDIO bus PM PHY resuming

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
    can: add missing attribute validation for termination

Jakub Kicinski <kuba@kernel.org>
    nl802154: add missing attribute validation for dev_type

Jakub Kicinski <kuba@kernel.org>
    nl802154: add missing attribute validation

Jakub Kicinski <kuba@kernel.org>
    fib: add missing attribute validation for tun_id

Eric Dumazet <edumazet@google.com>
    net: memcg: fix lockdep splat in inet_csk_accept()

Shakeel Butt <shakeelb@google.com>
    net: memcg: late association of sock to memcg

Shakeel Butt <shakeelb@google.com>
    cgroup: memcg: net: do not associate sock with unrelated cgroup

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: reinitialize IRQs when MTU is modified

Edward Cree <ecree@solarflare.com>
    sfc: detach from cb_page in efx_copy_channel()

You-Sheng Yang <vicamo.yang@canonical.com>
    r8152: check disconnect status after long sleep

Willem de Bruijn <willemb@google.com>
    net/packet: tpacket_rcv: do not increment ring index on drop

Dan Carpenter <dan.carpenter@oracle.com>
    net: nfc: fix bounds checking bugs on "pipe"

Dmitry Bogdanov <dbogdanov@marvell.com>
    net: macsec: update SCI upon MAC address change.

Pablo Neira Ayuso <pablo@netfilter.org>
    netlink: Use netlink header as base to calculate bad attribute offset

Eric Dumazet <edumazet@google.com>
    ipvlan: do not use cond_resched_rcu() in ipvlan_process_multicast()

Mahesh Bandewar <maheshb@google.com>
    ipvlan: add cond_resched_rcu() while processing muticast backlog

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


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |  4 +
 Documentation/filesystems/porting                  |  7 ++
 Makefile                                           |  4 +-
 arch/arc/include/asm/linkage.h                     |  2 +
 arch/arm/kernel/vdso.c                             |  2 +
 arch/arm/lib/copy_from_user.S                      |  2 +-
 arch/x86/events/amd/uncore.c                       | 14 ++--
 arch/x86/kernel/cpu/mcheck/mce_intel.c             |  9 ++-
 arch/x86/kvm/emulate.c                             |  1 +
 drivers/acpi/acpi_watchdog.c                       | 12 ++-
 drivers/block/virtio_blk.c                         |  8 +-
 drivers/firmware/efi/efivars.c                     | 32 +++++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c       |  3 +-
 drivers/hid/hid-apple.c                            |  3 +-
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c           |  8 ++
 drivers/i2c/i2c-core-acpi.c                        | 10 ++-
 drivers/iommu/dma-iommu.c                          | 16 ++--
 drivers/iommu/dmar.c                               | 21 +++--
 drivers/iommu/intel-iommu.c                        | 13 +--
 drivers/net/bonding/bond_alb.c                     | 20 ++---
 drivers/net/can/dev.c                              |  1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  4 +-
 drivers/net/ethernet/freescale/fec_main.c          |  6 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c   |  1 +
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h   |  2 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_if.h    |  1 +
 drivers/net/ethernet/micrel/ks8851_mll.c           | 14 ++--
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c |  5 ++
 drivers/net/ethernet/sfc/efx.c                     |  1 +
 drivers/net/ipvlan/ipvlan_core.c                   | 19 +++--
 drivers/net/ipvlan/ipvlan_main.c                   |  5 +-
 drivers/net/macsec.c                               | 12 +--
 drivers/net/macvlan.c                              |  2 +
 drivers/net/phy/phy_device.c                       | 18 +++--
 drivers/net/slip/slhc.c                            | 14 +++-
 drivers/net/slip/slip.c                            |  3 +
 drivers/net/team/team.c                            |  2 +
 drivers/net/usb/qmi_wwan.c                         |  3 +
 drivers/net/usb/r8152.c                            |  8 ++
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       |  3 +-
 drivers/pinctrl/core.c                             |  1 -
 drivers/pinctrl/meson/pinctrl-meson-gxl.c          |  4 +-
 drivers/scsi/libfc/fc_disc.c                       |  2 +
 fs/cifs/dir.c                                      |  1 -
 fs/gfs2/inode.c                                    |  2 +-
 fs/jbd2/transaction.c                              |  8 +-
 fs/open.c                                          |  3 -
 include/linux/cgroup.h                             |  1 +
 include/linux/inet_diag.h                          | 18 +++--
 include/linux/phy.h                                |  2 +
 include/net/fib_rules.h                            |  1 +
 kernel/cgroup/cgroup.c                             | 37 ++++++---
 kernel/signal.c                                    | 23 +++---
 kernel/workqueue.c                                 | 14 ++--
 mm/memcontrol.c                                    | 14 +---
 mm/slub.c                                          |  9 +++
 net/batman-adv/bat_iv_ogm.c                        | 94 +++++++++++++++++-----
 net/batman-adv/bat_v.c                             | 11 ++-
 net/batman-adv/bat_v_ogm.c                         | 42 ++++++++--
 net/batman-adv/debugfs.c                           | 46 ++++++++++-
 net/batman-adv/debugfs.h                           | 11 +++
 net/batman-adv/fragmentation.c                     |  2 +
 net/batman-adv/hard-interface.c                    | 51 ++++++++++--
 net/batman-adv/originator.c                        |  4 +-
 net/batman-adv/originator.h                        |  4 +-
 net/batman-adv/routing.c                           | 10 +--
 net/batman-adv/translation-table.c                 | 84 +++++++++++++++----
 net/batman-adv/types.h                             | 18 +++--
 net/core/netclassid_cgroup.c                       | 47 ++++++++---
 net/core/sock.c                                    |  5 +-
 net/ieee802154/nl_policy.c                         |  6 ++
 net/ipv4/cipso_ipv4.c                              |  7 +-
 net/ipv4/gre_demux.c                               | 12 ++-
 net/ipv4/inet_connection_sock.c                    | 20 +++++
 net/ipv4/inet_diag.c                               | 44 +++++-----
 net/ipv4/raw_diag.c                                |  5 +-
 net/ipv4/udp_diag.c                                |  5 +-
 net/ipv6/addrconf.c                                |  4 +
 net/ipv6/ipv6_sockglue.c                           | 10 ++-
 net/mac80211/rx.c                                  |  2 +-
 net/netfilter/nfnetlink_cthelper.c                 |  2 +
 net/netfilter/nft_payload.c                        |  1 +
 net/netlink/af_netlink.c                           |  2 +-
 net/nfc/hci/core.c                                 | 19 ++++-
 net/nfc/netlink.c                                  |  3 +
 net/packet/af_packet.c                             | 13 +--
 net/sched/sch_fq.c                                 |  1 +
 net/sctp/sctp_diag.c                               |  8 +-
 net/smc/smc_ib.c                                   |  2 +
 net/wireless/nl80211.c                             |  5 ++
 net/wireless/reg.c                                 |  2 +-
 tools/testing/ktest/ktest.pl                       |  2 +-
 92 files changed, 764 insertions(+), 295 deletions(-)


