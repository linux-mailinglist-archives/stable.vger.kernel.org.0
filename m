Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1AA322BD1
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 15:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbhBWOAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 09:00:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:60956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232342AbhBWOAm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Feb 2021 09:00:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E42964E5C;
        Tue, 23 Feb 2021 14:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614088801;
        bh=K1M72ddrvgiIbVfo2NJxljpq/Bex51dQRb49Hq/gVO4=;
        h=From:To:Cc:Subject:Date:From;
        b=0nWiujSzKKH3d9meBsQN/vBNeqMKK7aVXfyw7xaMAJPt27HYaFdFgSvghszPOr6HL
         fFTH4DfQ833gBTtaiFBm+3Jv94b0mhaCX5Z4ut6RCH1A2IuGt0uxpjZF89naSPnHOd
         pvkyeBn4Fp+5G1tVXSKzNgWEeBWgjgqvtjmBCLd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.258
Date:   Tue, 23 Feb 2021 14:59:55 +0100
Message-Id: <1614088795172206@kroah.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.258 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                |    9 +++-
 arch/arm/xen/p2m.c                      |    6 +-
 arch/h8300/kernel/asm-offsets.c         |    3 +
 arch/x86/Makefile                       |    6 +-
 arch/x86/xen/p2m.c                      |   15 +++----
 drivers/block/xen-blkback/blkback.c     |   28 +++++++------
 drivers/net/wireless/iwlwifi/mvm/ops.c  |    3 -
 drivers/net/wireless/iwlwifi/pcie/tx.c  |    5 ++
 drivers/net/xen-netback/netback.c       |    4 -
 drivers/scsi/qla2xxx/qla_tmpl.c         |    9 ++--
 drivers/scsi/qla2xxx/qla_tmpl.h         |    2 
 drivers/usb/dwc3/ulpi.c                 |   20 +++++++--
 drivers/xen/gntdev.c                    |   33 ++++++++++------
 drivers/xen/xen-scsiback.c              |    4 -
 fs/fs-writeback.c                       |    2 
 fs/squashfs/export.c                    |   41 ++++++++++++++++---
 fs/squashfs/id.c                        |   40 +++++++++++++++----
 fs/squashfs/squashfs_fs_sb.h            |    1 
 fs/squashfs/super.c                     |    6 +-
 fs/squashfs/xattr.h                     |   10 ++++
 fs/squashfs/xattr_id.c                  |   66 +++++++++++++++++++++++++++-----
 include/linux/backing-dev.h             |   10 ++++
 include/linux/ftrace.h                  |    4 +
 include/linux/netdevice.h               |    2 
 include/linux/string.h                  |    4 +
 include/linux/sunrpc/xdr.h              |    3 -
 include/trace/events/writeback.h        |   35 ++++++++--------
 include/xen/grant_table.h               |    1 
 kernel/trace/ftrace.c                   |    2 
 kernel/trace/trace_events.c             |    3 -
 lib/string.c                            |   47 +++++++++++++++++++---
 mm/backing-dev.c                        |    1 
 mm/memblock.c                           |   49 ++---------------------
 net/key/af_key.c                        |    6 +-
 net/netfilter/xt_recent.c               |   12 ++++-
 net/sunrpc/auth_gss/auth_gss.c          |   30 --------------
 net/sunrpc/auth_gss/auth_gss_internal.h |   45 +++++++++++++++++++++
 net/sunrpc/auth_gss/gss_krb5_mech.c     |   31 ---------------
 net/vmw_vsock/af_vsock.c                |    8 ++-
 scripts/Makefile.build                  |    3 +
 virt/kvm/kvm_main.c                     |    3 -
 41 files changed, 388 insertions(+), 224 deletions(-)

Andi Kleen (1):
      trace: Use -mcount-record for dynamic ftrace

Arun Easi (1):
      scsi: qla2xxx: Fix crash during driver load on big endian machines

Borislav Petkov (1):
      x86/build: Disable CET instrumentation in the kernel for 32-bit too

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

Greg Kroah-Hartman (1):
      Linux 4.4.258

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

Johannes Berg (1):
      iwlwifi: mvm: guard against device removal in reprobe

Jozsef Kadlecsik (1):
      netfilter: xt_recent: Fix attempt to update deleted entry

Lai Jiangshan (1):
      kvm: check tlbs_dirty directly

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

Stefano Garzarella (1):
      vsock: fix locking in vsock_shutdown()

Stefano Stabellini (1):
      xen/arm: don't ignore return errors from set_phys_to_machine

Steven Rostedt (VMware) (2):
      tracing: Do not count ftrace events in top level enable output
      fgraph: Initialize tracing_graph_pause at task creation

Theodore Ts'o (1):
      memcg: fix a crash in wb_workfn when a device disappears

Tobin C. Harding (1):
      lib/string: Add strscpy_pad() function

Vasily Gorbik (1):
      tracing: Avoid calling cc-option -mrecord-mcount for every Makefile

