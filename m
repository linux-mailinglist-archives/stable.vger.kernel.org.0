Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68E7C321761
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbhBVMrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:47:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:53740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231140AbhBVMnm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:43:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF23B64F06;
        Mon, 22 Feb 2021 12:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997664;
        bh=2BVza5D6jGHwnspcGJsbUW8zwKdFtzxF8A5Zkr96258=;
        h=From:To:Cc:Subject:Date:From;
        b=dfmjr9IEmDjmv7XAcC8YJJsY4Jfgu722bL9w5HtHGf9tyL9WSVV82R5oFUeanVyKI
         qUTSRaMIwit6k9xC8wSV7dRCtboAUn29tm3aF8HkEhGZt3GieBywjfbHsdes+aHPCH
         CxjBBMPtm019ZCJph2x7JV7vHhCHSRod1wCEJy0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: [PATCH 4.9 00/49] 4.9.258-rc1 review
Date:   Mon, 22 Feb 2021 13:35:58 +0100
Message-Id: <20210222121022.546148341@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.258-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.258-rc1
X-KernelTest-Deadline: 2021-02-24T12:10+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.258 release.
There are 49 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.258-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.258-rc1

Lai Jiangshan <laijs@linux.alibaba.com>
    kvm: check tlbs_dirty directly

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Fix crash during driver load on big endian machines

Jan Beulich <jbeulich@suse.com>
    xen-blkback: fix error handling in xen_blkbk_map()

Jan Beulich <jbeulich@suse.com>
    xen-scsiback: don't "handle" error by BUG()

Jan Beulich <jbeulich@suse.com>
    xen-netback: don't "handle" error by BUG()

Jan Beulich <jbeulich@suse.com>
    xen-blkback: don't "handle" error by BUG()

Stefano Stabellini <stefano.stabellini@xilinx.com>
    xen/arm: don't ignore return errors from set_phys_to_machine

Jan Beulich <jbeulich@suse.com>
    Xen/gntdev: correct error checking in gntdev_map_grant_pages()

Jan Beulich <jbeulich@suse.com>
    Xen/gntdev: correct dev_bus_addr handling in gntdev_map_grant_pages()

Jan Beulich <jbeulich@suse.com>
    Xen/x86: also check kernel mapping in set_foreign_p2m_mapping()

Jan Beulich <jbeulich@suse.com>
    Xen/x86: don't bail early from clear_foreign_p2m_mapping()

Vasily Gorbik <gor@linux.ibm.com>
    tracing: Avoid calling cc-option -mrecord-mcount for every Makefile

Greg Thelen <gthelen@google.com>
    tracing: Fix SKIP_STACK_VALIDATION=1 build due to bad merge with -mrecord-mcount

Andi Kleen <ak@linux.intel.com>
    trace: Use -mcount-record for dynamic ftrace

Borislav Petkov <bp@suse.de>
    x86/build: Disable CET instrumentation in the kernel for 32-bit too

Stefano Garzarella <sgarzare@redhat.com>
    vsock: fix locking in vsock_shutdown()

Stefano Garzarella <sgarzare@redhat.com>
    vsock/virtio: update credit only if socket is not closed

Edwin Peer <edwin.peer@broadcom.com>
    net: watchdog: hold device global xmit lock during tx disable

Norbert Slusarek <nslusarek@gmx.net>
    net/vmw_vsock: improve locking in vsock_connect_timeout()

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    usb: dwc3: ulpi: Replace CPU-based busyloop with Protocol-based one

Felipe Balbi <balbi@kernel.org>
    usb: dwc3: ulpi: fix checkpatch warning

Randy Dunlap <rdunlap@infradead.org>
    h8300: fix PREEMPTION build, TI_PRE_COUNT undefined

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: skip identical origin tuple in same zone only

Juergen Gross <jgross@suse.com>
    xen/netback: avoid race in xenvif_rx_ring_slots_available()

Jozsef Kadlecsik <kadlec@mail.kfki.hu>
    netfilter: xt_recent: Fix attempt to update deleted entry

Bui Quang Minh <minhquangbui99@gmail.com>
    bpf: Check for integer overflow when using roundup_pow_of_two()

Roman Gushchin <guro@fb.com>
    memblock: do not start bottom-up allocations with kernel_end

Alexandre Belloni <alexandre.belloni@bootlin.com>
    ARM: dts: lpc32xx: Revert set default clock rate of HCLK PLL

Amir Goldstein <amir73il@gmail.com>
    ovl: skip getxattr of security labels

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Check length before giving out the filter buffer

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Do not count ftrace events in top level enable output

Phillip Lougher <phillip@squashfs.org.uk>
    squashfs: add more sanity checks in xattr id lookup

Phillip Lougher <phillip@squashfs.org.uk>
    squashfs: add more sanity checks in inode lookup

Phillip Lougher <phillip@squashfs.org.uk>
    squashfs: add more sanity checks in id lookup

Thomas Gleixner <tglx@linutronix.de>
    futex: Cure exit race

Peter Zijlstra <peterz@infradead.org>
    futex: Change locking rules

Thomas Gleixner <tglx@linutronix.de>
    futex: Ensure the correct return value from futex_lock_pi()

Theodore Ts'o <tytso@mit.edu>
    memcg: fix a crash in wb_workfn when a device disappears

Qian Cai <cai@lca.pw>
    include/trace/events/writeback.h: fix -Wstringop-truncation warnings

Tobin C. Harding <tobin@kernel.org>
    lib/string: Add strscpy_pad() function

Dave Wysochanski <dwysocha@redhat.com>
    SUNRPC: Handle 0 length opaque XDR object data properly

Dave Wysochanski <dwysocha@redhat.com>
    SUNRPC: Move simple_get_bytes and simple_get_netobj into private header

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: guard against device removal in reprobe

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: pcie: add a NULL check in iwl_pcie_txq_unmap

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: take mutex for calling iwl_mvm_get_sync_time()

Cong Wang <cong.wang@bytedance.com>
    af_key: relax availability checks for skb size calculation

Sibi Sankar <sibis@codeaurora.org>
    remoteproc: qcom_q6v5_mss: Validate MBA firmware size before load

Steven Rostedt (VMware) <rostedt@goodmis.org>
    fgraph: Initialize tracing_graph_pause at task creation

Johannes Weiner <hannes@cmpxchg.org>
    mm: memcontrol: fix NULL pointer crash in test_clear_page_writeback()


-------------

Diffstat:

 Makefile                                           |  11 +-
 arch/arm/boot/dts/lpc32xx.dtsi                     |   3 -
 arch/arm/xen/p2m.c                                 |   6 +-
 arch/h8300/kernel/asm-offsets.c                    |   3 +
 arch/x86/Makefile                                  |   6 +-
 arch/x86/xen/p2m.c                                 |  15 +-
 drivers/block/xen-blkback/blkback.c                |  30 +--
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |   3 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   3 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |   5 +
 drivers/net/xen-netback/netback.c                  |   4 +-
 drivers/net/xen-netback/rx.c                       |   9 +-
 drivers/remoteproc/qcom_q6v5_pil.c                 |   6 +
 drivers/scsi/qla2xxx/qla_tmpl.c                    |   9 +-
 drivers/scsi/qla2xxx/qla_tmpl.h                    |   2 +-
 drivers/usb/dwc3/ulpi.c                            |  20 +-
 drivers/xen/gntdev.c                               |  33 ++-
 drivers/xen/xen-scsiback.c                         |   4 +-
 fs/fs-writeback.c                                  |   2 +-
 fs/overlayfs/copy_up.c                             |  15 +-
 fs/squashfs/export.c                               |  41 +++-
 fs/squashfs/id.c                                   |  40 +++-
 fs/squashfs/squashfs_fs_sb.h                       |   1 +
 fs/squashfs/super.c                                |   6 +-
 fs/squashfs/xattr.h                                |  10 +-
 fs/squashfs/xattr_id.c                             |  66 +++++-
 include/linux/backing-dev.h                        |  10 +
 include/linux/ftrace.h                             |   4 +-
 include/linux/memcontrol.h                         |  33 ++-
 include/linux/netdevice.h                          |   2 +
 include/linux/string.h                             |   4 +
 include/linux/sunrpc/xdr.h                         |   3 +-
 include/trace/events/writeback.h                   |  35 ++--
 include/xen/grant_table.h                          |   1 +
 kernel/bpf/stackmap.c                              |   2 +
 kernel/futex.c                                     | 233 +++++++++++++++++----
 kernel/trace/ftrace.c                              |   2 -
 kernel/trace/trace.c                               |   2 +-
 kernel/trace/trace_events.c                        |   3 +-
 lib/string.c                                       |  47 ++++-
 mm/backing-dev.c                                   |   1 +
 mm/memblock.c                                      |  48 +----
 mm/memcontrol.c                                    |  43 ++--
 mm/page-writeback.c                                |  14 +-
 net/key/af_key.c                                   |   6 +-
 net/netfilter/nf_conntrack_core.c                  |   3 +-
 net/netfilter/xt_recent.c                          |  12 +-
 net/sunrpc/auth_gss/auth_gss.c                     |  30 +--
 net/sunrpc/auth_gss/auth_gss_internal.h            |  45 ++++
 net/sunrpc/auth_gss/gss_krb5_mech.c                |  31 +--
 net/vmw_vsock/af_vsock.c                           |  13 +-
 net/vmw_vsock/virtio_transport_common.c            |   4 +-
 scripts/Makefile.build                             |   3 +
 virt/kvm/kvm_main.c                                |   3 +-
 54 files changed, 681 insertions(+), 309 deletions(-)


