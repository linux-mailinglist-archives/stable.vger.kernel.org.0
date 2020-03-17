Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 182151881F5
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgCQK5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 06:57:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726980AbgCQK5c (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 06:57:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35C3620736;
        Tue, 17 Mar 2020 10:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442650;
        bh=rHNQ4i5+ZR2KztBUpwmR6czYEmjgge5LgerB0Fjrx/0=;
        h=From:To:Cc:Subject:Date:From;
        b=LLpQ4oFxO/Yupk6Zg02jKTwRbZS6tv2SbkWSlAauAvdTArzFsQw3WAYSdyhmJRdQa
         nEFN7iZGlM3X0wRXSXcUpVn5/sS8KLL9DyCAod2xmuugAO3JtB4TEqVhxAlLSwhUNH
         VtFtISPjpEG0wglnAjAq8tlfNzEOh01xAeVIJOvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/89] 4.19.111-rc1 review
Date:   Tue, 17 Mar 2020 11:54:09 +0100
Message-Id: <20200317103259.744774526@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.111-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.111-rc1
X-KernelTest-Deadline: 2020-03-19T10:33+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.111 release.
There are 89 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 19 Mar 2020 10:31:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.111-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.111-rc1

Sven Eckelmann <sven@narfation.org>
    batman-adv: Avoid free/alloc race when handling OGM2 buffer

Vladis Dronov <vdronov@redhat.com>
    efi: Add a sanity check to efivar_store_raw()

Karsten Graul <kgraul@linux.ibm.com>
    net/smc: cancel event worker during device removal

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
    netfilter: nft_tunnel: add missing attribute validation for tunnels

Jakub Kicinski <kuba@kernel.org>
    netfilter: nft_payload: add missing attribute validation for payload csum flags

Jakub Kicinski <kuba@kernel.org>
    netfilter: cthelper: add missing attribute validation for cthelper

Tommi Rantala <tommi.t.rantala@nokia.com>
    perf bench futex-wake: Restore thread count default to online CPU count

Jakub Kicinski <kuba@kernel.org>
    nl80211: add missing attribute validation for channel switch

Jakub Kicinski <kuba@kernel.org>
    nl80211: add missing attribute validation for beacon report scanning

Jakub Kicinski <kuba@kernel.org>
    nl80211: add missing attribute validation for critical protocol indication

Hamish Martin <hamish.martin@alliedtelesis.co.nz>
    i2c: gpio: suppress error on probe defer

Zhenyu Wang <zhenyuw@linux.intel.com>
    drm/i915/gvt: Fix unnecessary schedule timer when no vGPU exits

Charles Keepax <ckeepax@opensource.cirrus.com>
    pinctrl: core: Remove extra kref_get which blocks hogs being freed

Nicolas Belin <nbelin@baylibre.com>
    pinctrl: meson-gxl: fix GPIOX sdio pins

Sven Eckelmann <sven@narfation.org>
    batman-adv: Don't schedule OGM for disabled interface

Yonghyun Hwang <yonghyun@google.com>
    iommu/vt-d: Fix a bug in intel_iommu_iova_to_phys() for huge page

Hans de Goede <hdegoede@redhat.com>
    iommu/vt-d: dmar: replace WARN_TAINT with pr_warn + add_taint

Marc Zyngier <maz@kernel.org>
    iommu/dma: Fix MSI reservation allocation

Tony Luck <tony.luck@intel.com>
    x86/mce: Fix logic and comments around MSR_PPIN_CTL

Felix Fietkau <nbd@nbd.name>
    mt76: fix array overflow on receiving too many fragments for a packet

Sai Praneeth <sai.praneeth.prakhya@intel.com>
    efi: Make efi_rts_work accessible to efi page fault handler

Vladis Dronov <vdronov@redhat.com>
    efi: Fix a race and a buffer overflow while reading efivars via sysfs

Wolfram Sang <wsa@the-dreams.de>
    macintosh: windfarm: fix MODINFO regression

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

Vasily Averin <vvs@virtuozzo.com>
    netfilter: x_tables: xt_mttg_seq_next should increase position index

Vasily Averin <vvs@virtuozzo.com>
    netfilter: xt_recent: recent_seq_next should increase position index

Vasily Averin <vvs@virtuozzo.com>
    netfilter: synproxy: synproxy_cpu_seq_next should increase position index

Vasily Averin <vvs@virtuozzo.com>
    netfilter: nf_conntrack: ct_cpu_seq_next should increase position index

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
    macvlan: add cond_resched() during multicast processing

Jakub Kicinski <kuba@kernel.org>
    net: fec: validate the new settings in fec_enet_set_coalesce()

Eric Dumazet <edumazet@google.com>
    slip: make slhc_compress() more robust against malicious packets

Eric Dumazet <edumazet@google.com>
    bonding/alb: make sure arp header is pulled before accessing it

Jakub Kicinski <kuba@kernel.org>
    devlink: validate length of region addr/len

Jakub Kicinski <kuba@kernel.org>
    tipc: add missing attribute validation for MTU property

Hangbin Liu <liuhangbin@gmail.com>
    net/ipv6: remove the old peer route if change it to a new one

Hangbin Liu <liuhangbin@gmail.com>
    net/ipv6: need update peer route when modify metric

Hangbin Liu <liuhangbin@gmail.com>
    selftests/net/fib_tests: update addr_metric_test for peer route testing

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: fix MDIO bus PM PHY resuming

Jakub Kicinski <kuba@kernel.org>
    nfc: add missing attribute validation for vendor subcommand

Jakub Kicinski <kuba@kernel.org>
    nfc: add missing attribute validation for deactivate target

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

Jakub Kicinski <kuba@kernel.org>
    devlink: validate length of param values

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

Colin Ian King <colin.king@canonical.com>
    net: systemport: fix index check to avoid an array out of bounds access

Remi Pommarel <repk@triplefau.lt>
    net: stmmac: dwmac1000: Disable ACS if enhanced descs are not used

Willem de Bruijn <willemb@google.com>
    net/packet: tpacket_rcv: do not increment ring index on drop

Dan Carpenter <dan.carpenter@oracle.com>
    net: nfc: fix bounds checking bugs on "pipe"

Dmitry Bogdanov <dbogdanov@marvell.com>
    net: macsec: update SCI upon MAC address change.

Pablo Neira Ayuso <pablo@netfilter.org>
    netlink: Use netlink header as base to calculate bad attribute offset

Hangbin Liu <liuhangbin@gmail.com>
    net/ipv6: use configured metric when add peer route

Mahesh Bandewar <maheshb@google.com>
    ipvlan: don't deref eth hdr before checking it's set

Eric Dumazet <edumazet@google.com>
    ipvlan: do not use cond_resched_rcu() in ipvlan_process_multicast()

Jiri Wiesner <jwiesner@suse.com>
    ipvlan: do not add hardware address of master to its unicast filter list

Mahesh Bandewar <maheshb@google.com>
    ipvlan: add cond_resched_rcu() while processing muticast backlog

Hangbin Liu <liuhangbin@gmail.com>
    ipv6/addrconf: call ipv6_mc_up() for non-Ethernet interface

Dmitry Yakunin <zeil@yandex-team.ru>
    inet_diag: return classid for all socket types

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

 Documentation/filesystems/porting                  |  7 +++
 Makefile                                           |  4 +-
 arch/arc/include/asm/linkage.h                     |  2 +
 arch/x86/kernel/cpu/mcheck/mce_intel.c             |  9 ++--
 arch/x86/kvm/emulate.c                             |  1 +
 drivers/block/virtio_blk.c                         |  8 ++--
 drivers/firmware/efi/efivars.c                     | 32 +++++++++----
 drivers/firmware/efi/runtime-wrappers.c            | 53 ++++------------------
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c       |  3 +-
 drivers/gpu/drm/i915/gvt/vgpu.c                    | 12 +++--
 drivers/i2c/busses/i2c-gpio.c                      |  2 +-
 drivers/i2c/i2c-core-acpi.c                        | 10 +++-
 drivers/iommu/dma-iommu.c                          | 16 +++----
 drivers/iommu/dmar.c                               | 21 ++++++---
 drivers/iommu/intel-iommu.c                        | 13 ++++--
 drivers/macintosh/windfarm_ad7417_sensor.c         |  7 +++
 drivers/macintosh/windfarm_fcu_controls.c          |  7 +++
 drivers/macintosh/windfarm_lm75_sensor.c           | 16 ++++++-
 drivers/macintosh/windfarm_lm87_sensor.c           |  7 +++
 drivers/macintosh/windfarm_max6690_sensor.c        |  7 +++
 drivers/macintosh/windfarm_smu_sat.c               |  7 +++
 drivers/net/bonding/bond_alb.c                     | 20 ++++----
 drivers/net/can/dev.c                              |  1 +
 drivers/net/ethernet/broadcom/bcmsysport.c         |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  4 +-
 drivers/net/ethernet/freescale/fec_main.c          |  6 +--
 drivers/net/ethernet/sfc/efx.c                     |  1 +
 .../net/ethernet/stmicro/stmmac/dwmac1000_core.c   |  3 +-
 drivers/net/ipvlan/ipvlan_core.c                   | 19 ++++----
 drivers/net/ipvlan/ipvlan_main.c                   |  5 +-
 drivers/net/macsec.c                               | 12 +++--
 drivers/net/macvlan.c                              |  2 +
 drivers/net/phy/phy_device.c                       | 18 +++++---
 drivers/net/slip/slhc.c                            | 14 ++++--
 drivers/net/team/team.c                            |  2 +
 drivers/net/usb/r8152.c                            |  8 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       |  3 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |  9 ++--
 drivers/pinctrl/core.c                             |  1 -
 drivers/pinctrl/meson/pinctrl-meson-gxl.c          |  4 +-
 fs/cifs/dir.c                                      |  1 -
 fs/gfs2/inode.c                                    |  2 +-
 fs/open.c                                          |  3 --
 include/linux/cgroup.h                             |  1 +
 include/linux/efi.h                                | 36 +++++++++++++++
 include/linux/inet_diag.h                          | 18 +++++---
 include/linux/phy.h                                |  2 +
 include/net/fib_rules.h                            |  1 +
 kernel/cgroup/cgroup.c                             | 37 +++++++++++----
 kernel/workqueue.c                                 | 14 +++---
 mm/memcontrol.c                                    | 14 +-----
 net/batman-adv/bat_iv_ogm.c                        |  4 ++
 net/batman-adv/bat_v_ogm.c                         | 42 +++++++++++++----
 net/batman-adv/types.h                             |  4 ++
 net/core/devlink.c                                 | 33 +++++++++-----
 net/core/netclassid_cgroup.c                       | 47 +++++++++++++++----
 net/core/sock.c                                    |  5 +-
 net/ieee802154/nl_policy.c                         |  6 +++
 net/ipv4/gre_demux.c                               | 12 ++++-
 net/ipv4/inet_connection_sock.c                    | 20 ++++++++
 net/ipv4/inet_diag.c                               | 44 ++++++++----------
 net/ipv4/raw_diag.c                                |  5 +-
 net/ipv4/udp_diag.c                                |  5 +-
 net/ipv6/addrconf.c                                | 49 +++++++++++++++-----
 net/ipv6/ipv6_sockglue.c                           | 10 +++-
 net/netfilter/nf_conntrack_standalone.c            |  2 +-
 net/netfilter/nf_synproxy_core.c                   |  2 +-
 net/netfilter/nfnetlink_cthelper.c                 |  2 +
 net/netfilter/nft_payload.c                        |  1 +
 net/netfilter/nft_tunnel.c                         |  2 +
 net/netfilter/x_tables.c                           |  6 +--
 net/netfilter/xt_recent.c                          |  2 +-
 net/netlink/af_netlink.c                           |  2 +-
 net/nfc/hci/core.c                                 | 19 ++++++--
 net/nfc/netlink.c                                  |  4 ++
 net/packet/af_packet.c                             | 13 +++---
 net/sched/sch_fq.c                                 |  1 +
 net/sctp/diag.c                                    |  8 +---
 net/smc/smc_ib.c                                   |  3 ++
 net/tipc/netlink.c                                 |  3 +-
 net/wireless/nl80211.c                             |  5 ++
 tools/perf/bench/futex-wake.c                      |  4 +-
 tools/testing/ktest/ktest.pl                       |  2 +-
 tools/testing/selftests/net/fib_tests.sh           | 34 ++++++++++++--
 84 files changed, 625 insertions(+), 283 deletions(-)


