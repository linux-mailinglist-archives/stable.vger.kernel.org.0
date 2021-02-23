Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDD4322BD9
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 15:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbhBWOBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 09:01:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:33016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230267AbhBWOBO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Feb 2021 09:01:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1359564E4D;
        Tue, 23 Feb 2021 14:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614088811;
        bh=3aSF82D1uC/pnSZ3I/rR+i8pQIZCq8otmbBg6XXvSlk=;
        h=From:To:Cc:Subject:Date:From;
        b=FhQtX1mffYePdLdijuZc4msTFmfYNKOe9vlWsIxqUVF1Vp5q2L2qqr2Cwy92kNeK1
         XUUM+jAMaVBCl3WfYuUc8MMfynOhImKIjTftFWKKc5twV5MnydxtVtsuslGjulB8iQ
         5HGlQA4DOB0e4DmiXHGYD7YM7RJ5vbTRuEAWuMqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.258
Date:   Tue, 23 Feb 2021 15:00:00 +0100
Message-Id: <161408880177110@kroah.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.258 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                             |    9 
 arch/arm/boot/dts/lpc32xx.dtsi                       |    3 
 arch/arm/xen/p2m.c                                   |    6 
 arch/h8300/kernel/asm-offsets.c                      |    3 
 arch/x86/Makefile                                    |    6 
 arch/x86/xen/p2m.c                                   |   15 -
 drivers/block/xen-blkback/blkback.c                  |   30 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c |    3 
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c         |    3 
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c         |    5 
 drivers/net/xen-netback/netback.c                    |    4 
 drivers/net/xen-netback/rx.c                         |    9 
 drivers/remoteproc/qcom_q6v5_pil.c                   |    6 
 drivers/scsi/qla2xxx/qla_tmpl.c                      |    9 
 drivers/scsi/qla2xxx/qla_tmpl.h                      |    2 
 drivers/usb/dwc3/ulpi.c                              |   20 +
 drivers/xen/gntdev.c                                 |   33 +-
 drivers/xen/xen-scsiback.c                           |    4 
 fs/fs-writeback.c                                    |    2 
 fs/overlayfs/copy_up.c                               |   15 -
 fs/squashfs/export.c                                 |   41 ++-
 fs/squashfs/id.c                                     |   40 ++-
 fs/squashfs/squashfs_fs_sb.h                         |    1 
 fs/squashfs/super.c                                  |    6 
 fs/squashfs/xattr.h                                  |   10 
 fs/squashfs/xattr_id.c                               |   66 ++++-
 include/linux/backing-dev.h                          |   10 
 include/linux/ftrace.h                               |    4 
 include/linux/memcontrol.h                           |   33 ++
 include/linux/netdevice.h                            |    2 
 include/linux/string.h                               |    4 
 include/linux/sunrpc/xdr.h                           |    3 
 include/trace/events/writeback.h                     |   35 +-
 include/xen/grant_table.h                            |    1 
 kernel/bpf/stackmap.c                                |    2 
 kernel/futex.c                                       |  233 +++++++++++++++----
 kernel/trace/ftrace.c                                |    2 
 kernel/trace/trace.c                                 |    2 
 kernel/trace/trace_events.c                          |    3 
 lib/string.c                                         |   47 +++
 mm/backing-dev.c                                     |    1 
 mm/memblock.c                                        |   48 ---
 mm/memcontrol.c                                      |   43 ++-
 mm/page-writeback.c                                  |   14 -
 net/key/af_key.c                                     |    6 
 net/netfilter/nf_conntrack_core.c                    |    3 
 net/netfilter/xt_recent.c                            |   12 
 net/sunrpc/auth_gss/auth_gss.c                       |   30 --
 net/sunrpc/auth_gss/auth_gss_internal.h              |   45 +++
 net/sunrpc/auth_gss/gss_krb5_mech.c                  |   31 --
 net/vmw_vsock/af_vsock.c                             |   13 -
 net/vmw_vsock/virtio_transport_common.c              |    4 
 scripts/Makefile.build                               |    3 
 virt/kvm/kvm_main.c                                  |    3 
 54 files changed, 680 insertions(+), 308 deletions(-)

Alexandre Belloni (1):
      ARM: dts: lpc32xx: Revert set default clock rate of HCLK PLL

Amir Goldstein (1):
      ovl: skip getxattr of security labels

Andi Kleen (1):
      trace: Use -mcount-record for dynamic ftrace

Arun Easi (1):
      scsi: qla2xxx: Fix crash during driver load on big endian machines

Borislav Petkov (1):
      x86/build: Disable CET instrumentation in the kernel for 32-bit too

Bui Quang Minh (1):
      bpf: Check for integer overflow when using roundup_pow_of_two()

Cong Wang (1):
      af_key: relax availability checks for skb size calculation

Dave Wysochanski (2):
      SUNRPC: Move simple_get_bytes and simple_get_netobj into private header
      SUNRPC: Handle 0 length opaque XDR object data properly

Edwin Peer (1):
      net: watchdog: hold device global xmit lock during tx disable

Emmanuel Grumbach (1):
      iwlwifi: pcie: add a NULL check in iwl_pcie_txq_unmap

Felipe Balbi (1):
      usb: dwc3: ulpi: fix checkpatch warning

Florian Westphal (1):
      netfilter: conntrack: skip identical origin tuple in same zone only

Greg Kroah-Hartman (1):
      Linux 4.9.258

Greg Thelen (1):
      tracing: Fix SKIP_STACK_VALIDATION=1 build due to bad merge with -mrecord-mcount

Jan Beulich (8):
      Xen/x86: don't bail early from clear_foreign_p2m_mapping()
      Xen/x86: also check kernel mapping in set_foreign_p2m_mapping()
      Xen/gntdev: correct dev_bus_addr handling in gntdev_map_grant_pages()
      Xen/gntdev: correct error checking in gntdev_map_grant_pages()
      xen-blkback: don't "handle" error by BUG()
      xen-netback: don't "handle" error by BUG()
      xen-scsiback: don't "handle" error by BUG()
      xen-blkback: fix error handling in xen_blkbk_map()

Johannes Berg (2):
      iwlwifi: mvm: take mutex for calling iwl_mvm_get_sync_time()
      iwlwifi: mvm: guard against device removal in reprobe

Johannes Weiner (1):
      mm: memcontrol: fix NULL pointer crash in test_clear_page_writeback()

Jozsef Kadlecsik (1):
      netfilter: xt_recent: Fix attempt to update deleted entry

Juergen Gross (1):
      xen/netback: avoid race in xenvif_rx_ring_slots_available()

Lai Jiangshan (1):
      kvm: check tlbs_dirty directly

Norbert Slusarek (1):
      net/vmw_vsock: improve locking in vsock_connect_timeout()

Peter Zijlstra (1):
      futex: Change locking rules

Phillip Lougher (3):
      squashfs: add more sanity checks in id lookup
      squashfs: add more sanity checks in inode lookup
      squashfs: add more sanity checks in xattr id lookup

Qian Cai (1):
      include/trace/events/writeback.h: fix -Wstringop-truncation warnings

Randy Dunlap (1):
      h8300: fix PREEMPTION build, TI_PRE_COUNT undefined

Roman Gushchin (1):
      memblock: do not start bottom-up allocations with kernel_end

Serge Semin (1):
      usb: dwc3: ulpi: Replace CPU-based busyloop with Protocol-based one

Sibi Sankar (1):
      remoteproc: qcom_q6v5_mss: Validate MBA firmware size before load

Stefano Garzarella (2):
      vsock/virtio: update credit only if socket is not closed
      vsock: fix locking in vsock_shutdown()

Stefano Stabellini (1):
      xen/arm: don't ignore return errors from set_phys_to_machine

Steven Rostedt (VMware) (3):
      fgraph: Initialize tracing_graph_pause at task creation
      tracing: Do not count ftrace events in top level enable output
      tracing: Check length before giving out the filter buffer

Theodore Ts'o (1):
      memcg: fix a crash in wb_workfn when a device disappears

Thomas Gleixner (2):
      futex: Ensure the correct return value from futex_lock_pi()
      futex: Cure exit race

Tobin C. Harding (1):
      lib/string: Add strscpy_pad() function

Vasily Gorbik (1):
      tracing: Avoid calling cc-option -mrecord-mcount for every Makefile

