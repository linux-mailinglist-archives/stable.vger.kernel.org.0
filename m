Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947AE1D0F31
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732649AbgEMJqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:46:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732664AbgEMJqe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:46:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3612A20753;
        Wed, 13 May 2020 09:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363193;
        bh=nAclqoZM6Uq1gTtfPjMNU7ildAJRBjFx/rxDSFoFG2o=;
        h=From:To:Cc:Subject:Date:From;
        b=iRGYSfvRMsw6Rp+xXK7qOnk0G+pFJA/mcZHPsC6VYeQRqBvXUayNewfVGSz20nayc
         KTg8UcVzTfvbaII5gnQDoD1x2uZaY+FFja7tVwlhICxT0hG7VcH2R5tjxZHFZm+OC2
         M7qEjWYGod+/IEbUdGugD5y0y4tcvt3xsMq4vkj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/48] 4.19.123-rc1 review
Date:   Wed, 13 May 2020 11:44:26 +0200
Message-Id: <20200513094351.100352960@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.123-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.123-rc1
X-KernelTest-Deadline: 2020-05-15T09:44+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.123 release.
There are 48 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 15 May 2020 09:41:20 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.123-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.123-rc1

Oleg Nesterov <oleg@redhat.com>
    ipc/mqueue.c: change __do_notify() to bypass check_kill_permission()

Ivan Delalande <colona@arista.com>
    scripts/decodecode: fix trapping instruction formatting

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Fix stack offset tracking for indirect CFAs

Arnd Bergmann <arnd@arndb.de>
    netfilter: nf_osf: avoid passing pointer to local var

Guillaume Nault <gnault@redhat.com>
    netfilter: nat: never update the UDP checksum when it's 0

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

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: VMX: Mark RCX, RDX and RSI as clobbered in vmx_vcpu_run()'s asm blob

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: VMX: Explicitly reference RCX as the vmx_vcpu pointer in asm blobs

Luis Chamberlain <mcgrof@kernel.org>
    coredump: fix crash when umh is disabled

Oscar Carter <oscar.carter@gmx.com>
    staging: gasket: Check the return value of gasket_get_bar_index()

David Hildenbrand <david@redhat.com>
    mm/page_alloc: fix watchdog soft lockups during set_zone_contiguous()

Mark Rutland <mark.rutland@arm.com>
    arm64: hugetlb: avoid potential NULL dereference

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Fix 32bit PC wrap-around

Marc Zyngier <maz@kernel.org>
    KVM: arm: vgic: Fix limit condition when writing to GICD_I[CS]ACTIVER

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Add a vmalloc_sync_mappings() for safe measure

Oliver Neukum <oneukum@suse.com>
    USB: serial: garmin_gps: add sanity checking for data length

Oliver Neukum <oneukum@suse.com>
    USB: uas: add quirk for LaCie 2Big Quadra

Alan Stern <stern@rowland.harvard.edu>
    HID: usbhid: Fix race between usbhid_close() and usbhid_stop()

Jere Leppänen <jere.leppanen@nokia.com>
    sctp: Fix bundling of SHUTDOWN with COOKIE-ACK

Jason Gerecke <jason.gerecke@wacom.com>
    HID: wacom: Read HID_DG_CONTACTMAX directly for non-generic devices

Willem de Bruijn <willemb@google.com>
    net: stricter validation of untrusted gso packets

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix VF anti-spoof filter setup.

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Improve AER slot reset.

Moshe Shemesh <moshe@mellanox.com>
    net/mlx5: Fix command entry leak in Internal Error State

Moshe Shemesh <moshe@mellanox.com>
    net/mlx5: Fix forced completion access non initialized command entry

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix VLAN acceleration handling in bnxt_fix_features().

Tuong Lien <tuong.t.lien@dektech.com.au>
    tipc: fix partial topology connection closure

Eric Dumazet <edumazet@google.com>
    sch_sfq: validate silly quantum values

Eric Dumazet <edumazet@google.com>
    sch_choke: avoid potential panic in choke_reset()

Matt Jolly <Kangie@footclan.ninja>
    net: usb: qmi_wwan: add support for DW5816e

Eric Dumazet <edumazet@google.com>
    net_sched: sch_skbprio: add message validation to skbprio_change()

Tariq Toukan <tariqt@mellanox.com>
    net/mlx4_core: Fix use of ENOSPC around mlx4_counter_alloc()

Scott Dial <scott@scottdial.com>
    net: macsec: preserve ingress frame ordering

Eric Dumazet <edumazet@google.com>
    fq_codel: fix TCA_FQ_CODEL_DROP_BATCH_SIZE sanity checks

Julia Lawall <Julia.Lawall@inria.fr>
    dp83640: reverse arguments to list_add_tail

Nicolas Pitre <nico@fluxnic.net>
    vt: fix unicode console freeing with a common interface

Masami Hiramatsu <mhiramat@kernel.org>
    tracing/kprobes: Fix a double initialization typo

Matt Jolly <Kangie@footclan.ninja>
    USB: serial: qcserial: Add DW5816e support


-------------

Diffstat:

 Makefile                                        |  4 +-
 arch/arm64/kvm/guest.c                          |  7 ++
 arch/arm64/mm/hugetlbpage.c                     |  2 +
 arch/x86/entry/calling.h                        | 40 +++++------
 arch/x86/entry/entry_64.S                       |  9 +--
 arch/x86/include/asm/unwind.h                   |  2 +-
 arch/x86/kernel/unwind_orc.c                    | 61 ++++++++++++-----
 arch/x86/kvm/vmx.c                              | 91 ++++++++++++++-----------
 drivers/hid/usbhid/hid-core.c                   | 37 +++++++---
 drivers/hid/usbhid/usbhid.h                     |  1 +
 drivers/hid/wacom_sys.c                         |  4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c       | 18 +++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h       |  1 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c |  9 +--
 drivers/net/ethernet/mellanox/mlx4/main.c       |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c   |  6 +-
 drivers/net/macsec.c                            |  3 +-
 drivers/net/phy/dp83640.c                       |  2 +-
 drivers/net/usb/qmi_wwan.c                      |  1 +
 drivers/staging/gasket/gasket_core.c            |  4 ++
 drivers/tty/vt/vt.c                             |  9 ++-
 drivers/usb/serial/garmin_gps.c                 |  4 +-
 drivers/usb/serial/qcserial.c                   |  1 +
 drivers/usb/storage/unusual_uas.h               |  7 ++
 fs/coredump.c                                   |  8 +++
 include/linux/virtio_net.h                      | 26 ++++++-
 ipc/mqueue.c                                    | 34 ++++++---
 kernel/trace/trace.c                            | 13 ++++
 kernel/trace/trace_kprobe.c                     |  2 +-
 kernel/umh.c                                    |  5 ++
 mm/page_alloc.c                                 |  1 +
 net/batman-adv/bat_v_ogm.c                      |  2 +-
 net/batman-adv/network-coding.c                 |  9 +--
 net/batman-adv/sysfs.c                          |  3 +-
 net/netfilter/nf_nat_proto_udp.c                |  5 +-
 net/netfilter/nfnetlink_osf.c                   | 12 ++--
 net/sched/sch_choke.c                           |  3 +-
 net/sched/sch_fq_codel.c                        |  2 +-
 net/sched/sch_sfq.c                             |  9 +++
 net/sched/sch_skbprio.c                         |  3 +
 net/sctp/sm_statefuns.c                         |  6 +-
 net/tipc/topsrv.c                               |  5 +-
 scripts/decodecode                              |  2 +-
 tools/objtool/check.c                           |  2 +-
 virt/kvm/arm/hyp/aarch32.c                      |  8 ++-
 virt/kvm/arm/vgic/vgic-mmio.c                   |  4 +-
 46 files changed, 335 insertions(+), 156 deletions(-)


