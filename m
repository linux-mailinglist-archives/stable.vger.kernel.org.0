Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A22B91D0D05
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733252AbgEMJtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:49:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733245AbgEMJta (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:49:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 733C923128;
        Wed, 13 May 2020 09:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363367;
        bh=pX9b/CPOZNSVCeih+n1gUU01tejWXMbjTqFlxikT6d8=;
        h=From:To:Cc:Subject:Date:From;
        b=IhHq3a6eAg3sGTNKuOk1N7UyoDDg+8tavdz2pkH9Yswh54rtiOJ2IWat7uYypJnct
         bWAA7YIHs4BP1jEl2vzojknQQeAJfgHgVn9OxJFYxMpRZpM7bPoUkjGCARVp+ebN9e
         3g2FGG2BK/IvnoDStEkwFqtDKM3KNS7W3YrOS2nU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 00/90] 5.4.41-rc1 review
Date:   Wed, 13 May 2020 11:43:56 +0200
Message-Id: <20200513094408.810028856@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.41-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.41-rc1
X-KernelTest-Deadline: 2020-05-15T09:44+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.41 release.
There are 90 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 15 May 2020 09:41:20 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.41-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.41-rc1

Amir Goldstein <amir73il@gmail.com>
    fanotify: merge duplicate events on parent and child

Amir Goldstein <amir73il@gmail.com>
    fsnotify: replace inode pointer with an object id

Christoph Hellwig <hch@lst.de>
    bdi: add a ->dev_name field to struct backing_dev_info

Christoph Hellwig <hch@lst.de>
    bdi: move bdi_dev_name out of line

Yafang Shao <laoar.shao@gmail.com>
    mm, memcg: fix error return value of mem_cgroup_css_alloc()

Ivan Delalande <colona@arista.com>
    scripts/decodecode: fix trapping instruction formatting

Julia Lawall <Julia.Lawall@inria.fr>
    iommu/virtio: Reverse arguments to list_add

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Fix stack offset tracking for indirect CFAs

Arnd Bergmann <arnd@arndb.de>
    netfilter: nf_osf: avoid passing pointer to local var

Guillaume Nault <gnault@redhat.com>
    netfilter: nat: never update the UDP checksum when it's 0

Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
    arch/x86/kvm/svm/sev.c: change flag passed to GUP fast in sev_pin_memory()

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    KVM: x86: Fixes posted interrupt check for IRQs delivery modes

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/unwind/orc: Fix premature unwind stoppage due to IRET frames

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/unwind/orc: Fix error path for bad ORC entry type

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/unwind/orc: Prevent unwinding before ORC initialization

Miroslav Benes <mbenes@suse.cz>
    x86/unwind/orc: Don't skip the first frame for inactive tasks

Jann Horn <jannh@google.com>
    x86/entry/64: Fix unwind hints in rewind_stack_do_exit()

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/entry/64: Fix unwind hints in kernel exit path

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/entry/64: Fix unwind hints in register clearing code

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    batman-adv: Fix refcnt leak in batadv_v_ogm_process

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    batman-adv: Fix refcnt leak in batadv_store_throughput_override

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    batman-adv: Fix refcnt leak in batadv_show_throughput_override

George Spelvin <lkml@sdf.org>
    batman-adv: fix batadv_nc_random_weight_tq

Tejun Heo <tj@kernel.org>
    iocost: protect iocg->abs_vdebt with iocg->waitq.lock

Vincent Chen <vincent.chen@sifive.com>
    riscv: set max_pfn to the PFN of the last page

Luis Chamberlain <mcgrof@kernel.org>
    coredump: fix crash when umh is disabled

Oscar Carter <oscar.carter@gmx.com>
    staging: gasket: Check the return value of gasket_get_bar_index()

Luis Henriques <lhenriques@suse.com>
    ceph: demote quotarealm lookup warning to a debug message

Jeff Layton <jlayton@kernel.org>
    ceph: fix endianness bug when handling MDS session feature bits

Henry Willard <henry.willard@oracle.com>
    mm: limit boost_watermark on small zones

David Hildenbrand <david@redhat.com>
    mm/page_alloc: fix watchdog soft lockups during set_zone_contiguous()

Khazhismel Kumykov <khazhy@google.com>
    eventpoll: fix missing wakeup for ovflist in ep_poll_callback

Roman Penyaev <rpenyaev@suse.de>
    epoll: atomically remove wait entry on wake up

Oleg Nesterov <oleg@redhat.com>
    ipc/mqueue.c: change __do_notify() to bypass check_kill_permission()

H. Nikolaus Schaller <hns@goldelico.com>
    drm: ingenic-drm: add MODULE_DEVICE_TABLE

Mark Rutland <mark.rutland@arm.com>
    arm64: hugetlb: avoid potential NULL dereference

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Fix 32bit PC wrap-around

Marc Zyngier <maz@kernel.org>
    KVM: arm: vgic: Fix limit condition when writing to GICD_I[CS]ACTIVER

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: VMX: Explicitly clear RFLAGS.CF and RFLAGS.ZF in VM-Exit RSB path

Christian Borntraeger <borntraeger@de.ibm.com>
    KVM: s390: Remove false WARN_ON_ONCE for the PQAP instruction

Jason A. Donenfeld <Jason@zx2c4.com>
    crypto: arch/nhpoly1305 - process in explicit 4k chunks

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Add a vmalloc_sync_mappings() for safe measure

Oliver Neukum <oneukum@suse.com>
    USB: serial: garmin_gps: add sanity checking for data length

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    usb: chipidea: msm: Ensure proper controller reset using role switch API

Oliver Neukum <oneukum@suse.com>
    USB: uas: add quirk for LaCie 2Big Quadra

Jason Gerecke <killertofu@gmail.com>
    HID: wacom: Report 2nd-gen Intuos Pro S center button status over BT

Alan Stern <stern@rowland.harvard.edu>
    HID: usbhid: Fix race between usbhid_close() and usbhid_stop()

Jason Gerecke <killertofu@gmail.com>
    Revert "HID: wacom: generic: read the number of expected touches on a per collection basis"

Jere Leppänen <jere.leppanen@nokia.com>
    sctp: Fix bundling of SHUTDOWN with COOKIE-ACK

Jason Gerecke <jason.gerecke@wacom.com>
    HID: wacom: Read HID_DG_CONTACTMAX directly for non-generic devices

Dan Carpenter <dan.carpenter@oracle.com>
    net: mvpp2: cls: Prevent buffer overflow in mvpp2_ethtool_cls_rule_del()

Dan Carpenter <dan.carpenter@oracle.com>
    net: mvpp2: prevent buffer overflow in mvpp22_rss_ctx()

Moshe Shemesh <moshe@mellanox.com>
    net/mlx5: Fix command entry leak in Internal Error State

Moshe Shemesh <moshe@mellanox.com>
    net/mlx5: Fix forced completion access non initialized command entry

Erez Shitrit <erezsh@mellanox.com>
    net/mlx5: DR, On creation set CQ's arm_db member to right value

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix VLAN acceleration handling in bnxt_fix_features().

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Return error when allocating zero size context memory.

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Improve AER slot reset.

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Reduce BNXT_MSIX_VEC_MAX value to supported CQs per PF.

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix VF anti-spoof filter setup.

Toke Høiland-Jørgensen <toke@redhat.com>
    tunnel: Propagate ECT(1) when decapsulating as recommended by RFC6040

Tuong Lien <tuong.t.lien@dektech.com.au>
    tipc: fix partial topology connection closure

Eric Dumazet <edumazet@google.com>
    sch_sfq: validate silly quantum values

Eric Dumazet <edumazet@google.com>
    sch_choke: avoid potential panic in choke_reset()

Qiushi Wu <wu000273@umn.edu>
    nfp: abm: fix a memory leak bug

Matt Jolly <Kangie@footclan.ninja>
    net: usb: qmi_wwan: add support for DW5816e

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    net/tls: Fix sk_psock refcnt leak when in tls_data_ready()

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    net/tls: Fix sk_psock refcnt leak in bpf_exec_tx_verdict()

Anthony Felice <tony.felice@timesys.com>
    net: tc35815: Fix phydev supported/advertising mask

Willem de Bruijn <willemb@google.com>
    net: stricter validation of untrusted gso packets

Eric Dumazet <edumazet@google.com>
    net_sched: sch_skbprio: add message validation to skbprio_change()

Tariq Toukan <tariqt@mellanox.com>
    net/mlx4_core: Fix use of ENOSPC around mlx4_counter_alloc()

Scott Dial <scott@scottdial.com>
    net: macsec: preserve ingress frame ordering

Dejin Zheng <zhengdejin5@gmail.com>
    net: macb: fix an issue about leak related system resources

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: Do not leave DSA master with NULL netdev_ops

Roman Mashak <mrv@mojatatu.com>
    neigh: send protocol value in neighbor create notification

Jiri Pirko <jiri@mellanox.com>
    mlxsw: spectrum_acl_tcam: Position vchunk in a vregion list properly

David Ahern <dsahern@kernel.org>
    ipv6: Use global sernum for dst validation with nexthop objects

Eric Dumazet <edumazet@google.com>
    fq_codel: fix TCA_FQ_CODEL_DROP_BATCH_SIZE sanity checks

Julia Lawall <Julia.Lawall@inria.fr>
    dp83640: reverse arguments to list_add_tail

Jakub Kicinski <kuba@kernel.org>
    devlink: fix return value after hitting end in region read

Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
    tty: xilinx_uartps: Fix missing id assignment to the console

Nicolas Pitre <nico@fluxnic.net>
    vt: fix unicode console freeing with a common interface

Evan Quan <evan.quan@amd.com>
    drm/amdgpu: drop redundant cg/pg ungate on runpm enter

Evan Quan <evan.quan@amd.com>
    drm/amdgpu: move kfd suspend after ip_suspend_phase1

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    net: macb: Fix runtime PM refcounting

Masami Hiramatsu <mhiramat@kernel.org>
    tracing/kprobes: Fix a double initialization typo

Sagi Grimberg <sagi@grimberg.me>
    nvme: fix possible hang when ns scanning fails during error recovery

Christoph Hellwig <hch@lst.de>
    nvme: refactor nvme_identify_ns_descs error handling

Matt Jolly <Kangie@footclan.ninja>
    USB: serial: qcserial: Add DW5816e support


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/crypto/nhpoly1305-neon-glue.c             |   2 +-
 arch/arm64/crypto/nhpoly1305-neon-glue.c           |   2 +-
 arch/arm64/kvm/guest.c                             |   7 ++
 arch/arm64/mm/hugetlbpage.c                        |   2 +
 arch/riscv/mm/init.c                               |   3 +-
 arch/s390/kvm/priv.c                               |   4 +-
 arch/x86/crypto/nhpoly1305-avx2-glue.c             |   2 +-
 arch/x86/crypto/nhpoly1305-sse2-glue.c             |   2 +-
 arch/x86/entry/calling.h                           |  40 +++----
 arch/x86/entry/entry_64.S                          |   9 +-
 arch/x86/include/asm/kvm_host.h                    |   4 +-
 arch/x86/include/asm/unwind.h                      |   2 +-
 arch/x86/kernel/unwind_orc.c                       |  61 ++++++++---
 arch/x86/kvm/svm.c                                 |   2 +-
 arch/x86/kvm/vmx/vmenter.S                         |   3 +
 block/blk-iocost.c                                 | 117 +++++++++++++--------
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   7 +-
 drivers/gpu/drm/ingenic/ingenic-drm.c              |   1 +
 drivers/hid/usbhid/hid-core.c                      |  37 +++++--
 drivers/hid/usbhid/usbhid.h                        |   1 +
 drivers/hid/wacom_sys.c                            |   4 +-
 drivers/hid/wacom_wac.c                            |  88 ++++------------
 drivers/iommu/virtio-iommu.c                       |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  20 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   1 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h  |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c    |  10 +-
 drivers/net/ethernet/cadence/macb_main.c           |  24 ++---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c     |   3 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   2 +
 drivers/net/ethernet/mellanox/mlx4/main.c          |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   6 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |  14 ++-
 .../ethernet/mellanox/mlxsw/spectrum_acl_tcam.c    |  12 ++-
 drivers/net/ethernet/netronome/nfp/abm/main.c      |   1 +
 drivers/net/ethernet/toshiba/tc35815.c             |   2 +-
 drivers/net/macsec.c                               |   3 +-
 drivers/net/phy/dp83640.c                          |   2 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/nvme/host/core.c                           |  28 +++--
 drivers/staging/gasket/gasket_core.c               |   4 +
 drivers/tty/serial/xilinx_uartps.c                 |   1 +
 drivers/tty/vt/vt.c                                |   9 +-
 drivers/usb/chipidea/ci_hdrc_msm.c                 |   2 +-
 drivers/usb/serial/garmin_gps.c                    |   4 +-
 drivers/usb/serial/qcserial.c                      |   1 +
 drivers/usb/storage/unusual_uas.h                  |   7 ++
 fs/ceph/mds_client.c                               |   8 +-
 fs/ceph/quota.c                                    |   4 +-
 fs/coredump.c                                      |   8 ++
 fs/eventpoll.c                                     |  61 ++++++-----
 fs/notify/fanotify/fanotify.c                      |   9 +-
 fs/notify/inotify/inotify_fsnotify.c               |   4 +-
 fs/notify/inotify/inotify_user.c                   |   2 +-
 include/linux/backing-dev-defs.h                   |   1 +
 include/linux/backing-dev.h                        |   9 +-
 include/linux/fsnotify_backend.h                   |   7 +-
 include/linux/virtio_net.h                         |  26 ++++-
 include/net/inet_ecn.h                             |  57 +++++++++-
 include/net/ip6_fib.h                              |   4 +
 include/net/net_namespace.h                        |   7 ++
 ipc/mqueue.c                                       |  34 ++++--
 kernel/trace/trace.c                               |  13 +++
 kernel/trace/trace_kprobe.c                        |   2 +-
 kernel/umh.c                                       |   5 +
 mm/backing-dev.c                                   |  13 ++-
 mm/memcontrol.c                                    |  15 +--
 mm/page_alloc.c                                    |   9 ++
 net/batman-adv/bat_v_ogm.c                         |   2 +-
 net/batman-adv/network-coding.c                    |   9 +-
 net/batman-adv/sysfs.c                             |   3 +-
 net/core/devlink.c                                 |   5 +
 net/core/neighbour.c                               |   6 +-
 net/dsa/master.c                                   |   3 +-
 net/ipv6/route.c                                   |  25 +++++
 net/netfilter/nf_nat_proto.c                       |   4 +-
 net/netfilter/nfnetlink_osf.c                      |  12 ++-
 net/sched/sch_choke.c                              |   3 +-
 net/sched/sch_fq_codel.c                           |   2 +-
 net/sched/sch_sfq.c                                |   9 ++
 net/sched/sch_skbprio.c                            |   3 +
 net/sctp/sm_statefuns.c                            |   6 +-
 net/tipc/topsrv.c                                  |   5 +-
 net/tls/tls_sw.c                                   |   7 +-
 scripts/decodecode                                 |   2 +-
 tools/cgroup/iocost_monitor.py                     |   7 +-
 tools/objtool/check.c                              |   2 +-
 virt/kvm/arm/hyp/aarch32.c                         |   8 +-
 virt/kvm/arm/vgic/vgic-mmio.c                      |   4 +-
 90 files changed, 648 insertions(+), 346 deletions(-)


