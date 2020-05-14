Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702421D2A9E
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 10:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgENItS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 04:49:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbgENItS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 04:49:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDAFF206B6;
        Thu, 14 May 2020 08:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589446157;
        bh=VgxOPhdB8rnPH2goWAZaOtKHDUzTTjLIhHGQm7HsrDY=;
        h=Subject:To:Cc:From:Date:From;
        b=0DuHTlYZwQ93UvumRLMEUN2jDw/sfCj3oJseovBYhs5WsTlr5xI9RrN1LtnojElXU
         7RujWwraB1rkseT/7Q0KuMTJYhwExOnf3dho3peRu6NQmVADd6/a1lQvgS0p2cCH09
         38MXNdX/MoST5KQlWCI2WSnHHUbVMPqZsbPQOM04=
Subject: Linux 4.19.123
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Thu, 14 May 2020 10:48:53 +0200
Message-ID: <1589446133208105@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.123 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                        |    2 
 arch/arm64/kvm/guest.c                          |    7 +
 arch/arm64/mm/hugetlbpage.c                     |    2 
 arch/x86/entry/calling.h                        |   40 +++++-----
 arch/x86/entry/entry_64.S                       |    9 +-
 arch/x86/include/asm/unwind.h                   |    2 
 arch/x86/kernel/unwind_orc.c                    |   61 +++++++++++-----
 arch/x86/kvm/vmx.c                              |   91 +++++++++++++-----------
 drivers/hid/usbhid/hid-core.c                   |   37 +++++++--
 drivers/hid/usbhid/usbhid.h                     |    1 
 drivers/hid/wacom_sys.c                         |    4 -
 drivers/net/ethernet/broadcom/bnxt/bnxt.c       |   18 +++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h       |    1 
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c |    9 --
 drivers/net/ethernet/mellanox/mlx4/main.c       |    4 -
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c   |    6 +
 drivers/net/macsec.c                            |    3 
 drivers/net/phy/dp83640.c                       |    2 
 drivers/net/usb/qmi_wwan.c                      |    1 
 drivers/staging/gasket/gasket_core.c            |    4 +
 drivers/tty/vt/vt.c                             |    9 +-
 drivers/usb/serial/garmin_gps.c                 |    4 -
 drivers/usb/serial/qcserial.c                   |    1 
 drivers/usb/storage/unusual_uas.h               |    7 +
 fs/coredump.c                                   |    8 ++
 include/linux/virtio_net.h                      |   26 ++++++
 ipc/mqueue.c                                    |   34 ++++++--
 kernel/trace/trace.c                            |   13 +++
 kernel/trace/trace_kprobe.c                     |    2 
 kernel/umh.c                                    |    5 +
 mm/page_alloc.c                                 |    1 
 net/batman-adv/bat_v_ogm.c                      |    2 
 net/batman-adv/network-coding.c                 |    9 --
 net/batman-adv/sysfs.c                          |    3 
 net/netfilter/nf_nat_proto_udp.c                |    5 -
 net/netfilter/nfnetlink_osf.c                   |   12 +--
 net/sched/sch_choke.c                           |    3 
 net/sched/sch_fq_codel.c                        |    2 
 net/sched/sch_sfq.c                             |    9 ++
 net/sched/sch_skbprio.c                         |    3 
 net/sctp/sm_statefuns.c                         |    6 -
 net/tipc/topsrv.c                               |    5 -
 scripts/decodecode                              |    2 
 tools/objtool/check.c                           |    2 
 virt/kvm/arm/hyp/aarch32.c                      |    8 +-
 virt/kvm/arm/vgic/vgic-mmio.c                   |    4 -
 46 files changed, 334 insertions(+), 155 deletions(-)

Alan Stern (1):
      HID: usbhid: Fix race between usbhid_close() and usbhid_stop()

Arnd Bergmann (1):
      netfilter: nf_osf: avoid passing pointer to local var

David Hildenbrand (1):
      mm/page_alloc: fix watchdog soft lockups during set_zone_contiguous()

Eric Dumazet (4):
      fq_codel: fix TCA_FQ_CODEL_DROP_BATCH_SIZE sanity checks
      net_sched: sch_skbprio: add message validation to skbprio_change()
      sch_choke: avoid potential panic in choke_reset()
      sch_sfq: validate silly quantum values

George Spelvin (1):
      batman-adv: fix batadv_nc_random_weight_tq

Greg Kroah-Hartman (1):
      Linux 4.19.123

Guillaume Nault (1):
      netfilter: nat: never update the UDP checksum when it's 0

Ivan Delalande (1):
      scripts/decodecode: fix trapping instruction formatting

Jann Horn (1):
      x86/entry/64: Fix unwind hints in rewind_stack_do_exit()

Jason Gerecke (1):
      HID: wacom: Read HID_DG_CONTACTMAX directly for non-generic devices

Jere Leppänen (1):
      sctp: Fix bundling of SHUTDOWN with COOKIE-ACK

Josh Poimboeuf (6):
      x86/entry/64: Fix unwind hints in register clearing code
      x86/entry/64: Fix unwind hints in kernel exit path
      x86/unwind/orc: Prevent unwinding before ORC initialization
      x86/unwind/orc: Fix error path for bad ORC entry type
      x86/unwind/orc: Fix premature unwind stoppage due to IRET frames
      objtool: Fix stack offset tracking for indirect CFAs

Julia Lawall (1):
      dp83640: reverse arguments to list_add_tail

Luis Chamberlain (1):
      coredump: fix crash when umh is disabled

Marc Zyngier (2):
      KVM: arm: vgic: Fix limit condition when writing to GICD_I[CS]ACTIVER
      KVM: arm64: Fix 32bit PC wrap-around

Mark Rutland (1):
      arm64: hugetlb: avoid potential NULL dereference

Masami Hiramatsu (1):
      tracing/kprobes: Fix a double initialization typo

Matt Jolly (2):
      USB: serial: qcserial: Add DW5816e support
      net: usb: qmi_wwan: add support for DW5816e

Michael Chan (3):
      bnxt_en: Fix VLAN acceleration handling in bnxt_fix_features().
      bnxt_en: Improve AER slot reset.
      bnxt_en: Fix VF anti-spoof filter setup.

Miroslav Benes (1):
      x86/unwind/orc: Don't skip the first frame for inactive tasks

Moshe Shemesh (2):
      net/mlx5: Fix forced completion access non initialized command entry
      net/mlx5: Fix command entry leak in Internal Error State

Nicolas Pitre (1):
      vt: fix unicode console freeing with a common interface

Oleg Nesterov (1):
      ipc/mqueue.c: change __do_notify() to bypass check_kill_permission()

Oliver Neukum (2):
      USB: uas: add quirk for LaCie 2Big Quadra
      USB: serial: garmin_gps: add sanity checking for data length

Oscar Carter (1):
      staging: gasket: Check the return value of gasket_get_bar_index()

Scott Dial (1):
      net: macsec: preserve ingress frame ordering

Sean Christopherson (2):
      KVM: VMX: Explicitly reference RCX as the vmx_vcpu pointer in asm blobs
      KVM: VMX: Mark RCX, RDX and RSI as clobbered in vmx_vcpu_run()'s asm blob

Steven Rostedt (VMware) (1):
      tracing: Add a vmalloc_sync_mappings() for safe measure

Tariq Toukan (1):
      net/mlx4_core: Fix use of ENOSPC around mlx4_counter_alloc()

Tuong Lien (1):
      tipc: fix partial topology connection closure

Willem de Bruijn (1):
      net: stricter validation of untrusted gso packets

Xiyu Yang (3):
      batman-adv: Fix refcnt leak in batadv_show_throughput_override
      batman-adv: Fix refcnt leak in batadv_store_throughput_override
      batman-adv: Fix refcnt leak in batadv_v_ogm_process

