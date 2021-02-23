Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 018AC322C40
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 15:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbhBWO2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 09:28:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:49164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232372AbhBWO2q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Feb 2021 09:28:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DD0764E5C;
        Tue, 23 Feb 2021 14:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614090485;
        bh=xlkuquOb/jS6u0nMPZMzMbgrj1yR/pqIaCaaHa37mGU=;
        h=From:To:Cc:Subject:Date:From;
        b=ZUOCh1vjLB8ph8o1NDGBRWV3GIOTQWQ4DriXupF4U0aAfDn+S270ObycFIDvg3W0A
         /SoWJLmKUv95kqa74AhYnIkSMM3lRNYBGbL83ENUQ9jQx3WjRTqHsdo/CHD9sZ9V7a
         E47m/mxak3cn7JVU2uzK1HYRwzSLtZSPx03vpgv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.177
Date:   Tue, 23 Feb 2021 15:28:01 +0100
Message-Id: <1614090481253100@kroah.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.177 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 
 arch/arm/boot/dts/lpc32xx.dtsi                          |    3 
 arch/arm/include/asm/kexec-internal.h                   |   12 ++
 arch/arm/kernel/asm-offsets.c                           |    5 +
 arch/arm/kernel/machine_kexec.c                         |   20 +---
 arch/arm/kernel/relocate_kernel.S                       |   38 ++-------
 arch/arm/kernel/signal.c                                |   14 +--
 arch/arm/xen/enlighten.c                                |    2 
 arch/arm/xen/p2m.c                                      |    6 -
 arch/arm64/boot/dts/rockchip/rk3399.dtsi                |    2 
 arch/h8300/kernel/asm-offsets.c                         |    3 
 arch/riscv/include/asm/page.h                           |    5 -
 arch/x86/Makefile                                       |    6 -
 arch/x86/kvm/svm.c                                      |    1 
 arch/x86/xen/p2m.c                                      |   15 +--
 block/bfq-iosched.c                                     |    8 -
 drivers/block/xen-blkback/blkback.c                     |   30 +++----
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c       |   18 +---
 drivers/i2c/busses/i2c-stm32f7.c                        |   11 ++
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c |    7 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c         |    7 +
 drivers/net/wireless/mediatek/mt76/dma.c                |    8 +
 drivers/net/xen-netback/netback.c                       |    4 
 drivers/net/xen-netback/rx.c                            |    9 +-
 drivers/platform/x86/hp-wmi.c                           |   14 ++-
 drivers/scsi/qla2xxx/qla_tmpl.c                         |    9 +-
 drivers/scsi/qla2xxx/qla_tmpl.h                         |    2 
 drivers/usb/dwc3/ulpi.c                                 |   20 +++-
 drivers/xen/gntdev.c                                    |   37 ++++----
 drivers/xen/xen-scsiback.c                              |    4 
 drivers/xen/xenbus/xenbus.h                             |    1 
 drivers/xen/xenbus/xenbus_probe.c                       |    2 
 fs/overlayfs/copy_up.c                                  |   15 +--
 fs/overlayfs/inode.c                                    |    2 
 fs/overlayfs/super.c                                    |   13 +--
 include/asm-generic/vmlinux.lds.h                       |    2 
 include/linux/netdevice.h                               |    2 
 include/xen/grant_table.h                               |    1 
 include/xen/xenbus.h                                    |    2 
 kernel/bpf/stackmap.c                                   |    2 
 kernel/trace/trace.c                                    |    2 
 kernel/trace/trace_events.c                             |    3 
 net/netfilter/nf_conntrack_core.c                       |    3 
 net/netfilter/nf_flow_table_core.c                      |    4 
 net/netfilter/xt_recent.c                               |   12 ++
 net/qrtr/qrtr.c                                         |    2 
 net/qrtr/tun.c                                          |    6 +
 net/rds/rdma.c                                          |    3 
 net/sctp/proc.c                                         |   16 ++-
 net/vmw_vsock/af_vsock.c                                |   13 +--
 net/vmw_vsock/hyperv_transport.c                        |    4 
 net/vmw_vsock/virtio_transport_common.c                 |    4 
 security/commoncap.c                                    |   67 ++++++++++------
 virt/kvm/kvm_main.c                                     |    3 
 54 files changed, 302 insertions(+), 204 deletions(-)

Alain Volmat (1):
      i2c: stm32f7: fix configuration of the digital filter

Alexandre Belloni (1):
      ARM: dts: lpc32xx: Revert set default clock rate of HCLK PLL

Alexandre Ghiti (1):
      riscv: virt_addr_valid must check the address belongs to linear mapping

Amir Goldstein (1):
      ovl: skip getxattr of security labels

Arun Easi (1):
      scsi: qla2xxx: Fix crash during driver load on big endian machines

Borislav Petkov (1):
      x86/build: Disable CET instrumentation in the kernel for 32-bit too

Bui Quang Minh (1):
      bpf: Check for integer overflow when using roundup_pow_of_two()

Edwin Peer (1):
      net: watchdog: hold device global xmit lock during tx disable

Fangrui Song (1):
      firmware_loader: align .builtin_fw to 8

Felipe Balbi (1):
      usb: dwc3: ulpi: fix checkpatch warning

Florian Westphal (1):
      netfilter: conntrack: skip identical origin tuple in same zone only

Greg Kroah-Hartman (1):
      Linux 4.19.177

Hans de Goede (1):
      platform/x86: hp-wmi: Disable tablet-mode reporting by default

Jan Beulich (8):
      Xen/x86: don't bail early from clear_foreign_p2m_mapping()
      Xen/x86: also check kernel mapping in set_foreign_p2m_mapping()
      Xen/gntdev: correct dev_bus_addr handling in gntdev_map_grant_pages()
      Xen/gntdev: correct error checking in gntdev_map_grant_pages()
      xen-blkback: don't "handle" error by BUG()
      xen-netback: don't "handle" error by BUG()
      xen-scsiback: don't "handle" error by BUG()
      xen-blkback: fix error handling in xen_blkbk_map()

Jozsef Kadlecsik (1):
      netfilter: xt_recent: Fix attempt to update deleted entry

Juergen Gross (1):
      xen/netback: avoid race in xenvif_rx_ring_slots_available()

Julien Grall (1):
      arm/xen: Don't probe xenbus as part of an early initcall

Lai Jiangshan (1):
      kvm: check tlbs_dirty directly

Lin Feng (1):
      bfq-iosched: Revert "bfq: Fix computation of shallow depth"

Loic Poulain (1):
      net: qrtr: Fix port ID for control messages

Lorenzo Bianconi (1):
      mt76: dma: fix a possible memory leak in mt76_add_fragment()

Marc Zyngier (1):
      arm64: dts: rockchip: Fix PCIe DT properties on rk3399

Miklos Szeredi (3):
      ovl: perform vfs_getxattr() with mounter creds
      cap: fix conversions on getxattr
      ovl: expand warning in ovl_d_real()

Mohammad Athari Bin Ismail (1):
      net: stmmac: set TxQ mode back to DCB after disabling CBS

NeilBrown (1):
      net: fix iteration for sctp transport seq_files

Norbert Slusarek (1):
      net/vmw_vsock: improve locking in vsock_connect_timeout()

Paolo Bonzini (1):
      KVM: SEV: fix double locking due to incorrect backport

Randy Dunlap (1):
      h8300: fix PREEMPTION build, TI_PRE_COUNT undefined

Russell King (2):
      ARM: ensure the signal page contains defined contents
      ARM: kexec: fix oops after TLB are invalidated

Sabyrzhan Tasbolatov (2):
      net/rds: restrict iovecs length for RDS_CMSG_RDMA_ARGS
      net/qrtr: restrict user-controlled length in qrtr_tun_write_iter()

Serge Semin (1):
      usb: dwc3: ulpi: Replace CPU-based busyloop with Protocol-based one

Stefano Garzarella (2):
      vsock/virtio: update credit only if socket is not closed
      vsock: fix locking in vsock_shutdown()

Stefano Stabellini (1):
      xen/arm: don't ignore return errors from set_phys_to_machine

Steven Rostedt (VMware) (2):
      tracing: Do not count ftrace events in top level enable output
      tracing: Check length before giving out the filter buffer

Sven Auhagen (1):
      netfilter: flowtable: fix tcp and udp header checksum update

Victor Lu (2):
      drm/amd/display: Fix dc_sink kref count in emulated_link_detect
      drm/amd/display: Free atomic state after drm_atomic_commit

Yufeng Mo (1):
      net: hns3: add a check for queue_id in hclge_reset_vf_queue()

