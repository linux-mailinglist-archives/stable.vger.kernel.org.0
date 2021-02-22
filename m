Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C35321646
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbhBVMUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:20:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:45328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230503AbhBVMRZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:17:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F8AE64F0F;
        Mon, 22 Feb 2021 12:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996228;
        bh=2Gau3hsrpzSjewch1qzgvjNRiykxHSSPDscwRr///SI=;
        h=From:To:Cc:Subject:Date:From;
        b=N38+84VTaMnyx/Q/aEBJbXq23YYfygJf0wtIm40rHlF2tT2icHIjsl9otdhFJFbXi
         RteaQVktXQOh9/EtQzjQgGs+Nu6xUfw3C1yhL+RyaMmtZnypvnOLFXwproHpzAk4eA
         pLNhJ/XAQAKV0kyaUdJEBFJbvyNrVlUWnOdWKUoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/50] 4.19.177-rc1 review
Date:   Mon, 22 Feb 2021 13:12:51 +0100
Message-Id: <20210222121019.925481519@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.177-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.177-rc1
X-KernelTest-Deadline: 2021-02-24T12:10+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.177 release.
There are 50 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.177-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.177-rc1

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

Loic Poulain <loic.poulain@linaro.org>
    net: qrtr: Fix port ID for control messages

Paolo Bonzini <pbonzini@redhat.com>
    KVM: SEV: fix double locking due to incorrect backport

Borislav Petkov <bp@suse.de>
    x86/build: Disable CET instrumentation in the kernel for 32-bit too

Miklos Szeredi <mszeredi@redhat.com>
    ovl: expand warning in ovl_d_real()

Sabyrzhan Tasbolatov <snovitoll@gmail.com>
    net/qrtr: restrict user-controlled length in qrtr_tun_write_iter()

Sabyrzhan Tasbolatov <snovitoll@gmail.com>
    net/rds: restrict iovecs length for RDS_CMSG_RDMA_ARGS

Stefano Garzarella <sgarzare@redhat.com>
    vsock: fix locking in vsock_shutdown()

Stefano Garzarella <sgarzare@redhat.com>
    vsock/virtio: update credit only if socket is not closed

Edwin Peer <edwin.peer@broadcom.com>
    net: watchdog: hold device global xmit lock during tx disable

Norbert Slusarek <nslusarek@gmx.net>
    net/vmw_vsock: improve locking in vsock_connect_timeout()

NeilBrown <neilb@suse.de>
    net: fix iteration for sctp transport seq_files

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    usb: dwc3: ulpi: Replace CPU-based busyloop with Protocol-based one

Felipe Balbi <balbi@kernel.org>
    usb: dwc3: ulpi: fix checkpatch warning

Randy Dunlap <rdunlap@infradead.org>
    h8300: fix PREEMPTION build, TI_PRE_COUNT undefined

Alain Volmat <alain.volmat@foss.st.com>
    i2c: stm32f7: fix configuration of the digital filter

Fangrui Song <maskray@google.com>
    firmware_loader: align .builtin_fw to 8

Yufeng Mo <moyufeng@huawei.com>
    net: hns3: add a check for queue_id in hclge_reset_vf_queue()

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: skip identical origin tuple in same zone only

Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
    net: stmmac: set TxQ mode back to DCB after disabling CBS

Juergen Gross <jgross@suse.com>
    xen/netback: avoid race in xenvif_rx_ring_slots_available()

Sven Auhagen <sven.auhagen@voleatech.de>
    netfilter: flowtable: fix tcp and udp header checksum update

Jozsef Kadlecsik <kadlec@mail.kfki.hu>
    netfilter: xt_recent: Fix attempt to update deleted entry

Bui Quang Minh <minhquangbui99@gmail.com>
    bpf: Check for integer overflow when using roundup_pow_of_two()

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: dma: fix a possible memory leak in mt76_add_fragment()

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: kexec: fix oops after TLB are invalidated

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: ensure the signal page contains defined contents

Alexandre Belloni <alexandre.belloni@bootlin.com>
    ARM: dts: lpc32xx: Revert set default clock rate of HCLK PLL

Lin Feng <linf@wangsu.com>
    bfq-iosched: Revert "bfq: Fix computation of shallow depth"

Alexandre Ghiti <alex@ghiti.fr>
    riscv: virt_addr_valid must check the address belongs to linear mapping

Victor Lu <victorchengchi.lu@amd.com>
    drm/amd/display: Free atomic state after drm_atomic_commit

Victor Lu <victorchengchi.lu@amd.com>
    drm/amd/display: Fix dc_sink kref count in emulated_link_detect

Amir Goldstein <amir73il@gmail.com>
    ovl: skip getxattr of security labels

Miklos Szeredi <mszeredi@redhat.com>
    cap: fix conversions on getxattr

Miklos Szeredi <mszeredi@redhat.com>
    ovl: perform vfs_getxattr() with mounter creds

Hans de Goede <hdegoede@redhat.com>
    platform/x86: hp-wmi: Disable tablet-mode reporting by default

Marc Zyngier <maz@kernel.org>
    arm64: dts: rockchip: Fix PCIe DT properties on rk3399

Julien Grall <jgrall@amazon.com>
    arm/xen: Don't probe xenbus as part of an early initcall

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Check length before giving out the filter buffer

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Do not count ftrace events in top level enable output


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/boot/dts/lpc32xx.dtsi                     |  3 -
 arch/arm/include/asm/kexec-internal.h              | 12 ++++
 arch/arm/kernel/asm-offsets.c                      |  5 ++
 arch/arm/kernel/machine_kexec.c                    | 20 +++----
 arch/arm/kernel/relocate_kernel.S                  | 38 ++++--------
 arch/arm/kernel/signal.c                           | 14 +++--
 arch/arm/xen/enlighten.c                           |  2 -
 arch/arm/xen/p2m.c                                 |  6 +-
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           |  2 +-
 arch/h8300/kernel/asm-offsets.c                    |  3 +
 arch/riscv/include/asm/page.h                      |  5 +-
 arch/x86/Makefile                                  |  6 +-
 arch/x86/kvm/svm.c                                 |  1 -
 arch/x86/xen/p2m.c                                 | 15 +++--
 block/bfq-iosched.c                                |  8 +--
 drivers/block/xen-blkback/blkback.c                | 30 +++++-----
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  | 18 +++---
 drivers/i2c/busses/i2c-stm32f7.c                   | 11 +++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  7 +++
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |  7 ++-
 drivers/net/wireless/mediatek/mt76/dma.c           |  8 ++-
 drivers/net/xen-netback/netback.c                  |  4 +-
 drivers/net/xen-netback/rx.c                       |  9 ++-
 drivers/platform/x86/hp-wmi.c                      | 14 +++--
 drivers/scsi/qla2xxx/qla_tmpl.c                    |  9 +--
 drivers/scsi/qla2xxx/qla_tmpl.h                    |  2 +-
 drivers/usb/dwc3/ulpi.c                            | 20 +++++--
 drivers/xen/gntdev.c                               | 37 ++++++------
 drivers/xen/xen-scsiback.c                         |  4 +-
 drivers/xen/xenbus/xenbus.h                        |  1 -
 drivers/xen/xenbus/xenbus_probe.c                  |  2 +-
 fs/overlayfs/copy_up.c                             | 15 ++---
 fs/overlayfs/inode.c                               |  2 +
 fs/overlayfs/super.c                               | 13 +++--
 include/asm-generic/vmlinux.lds.h                  |  2 +-
 include/linux/netdevice.h                          |  2 +
 include/xen/grant_table.h                          |  1 +
 include/xen/xenbus.h                               |  2 -
 kernel/bpf/stackmap.c                              |  2 +
 kernel/trace/trace.c                               |  2 +-
 kernel/trace/trace_events.c                        |  3 +-
 net/netfilter/nf_conntrack_core.c                  |  3 +-
 net/netfilter/nf_flow_table_core.c                 |  4 +-
 net/netfilter/xt_recent.c                          | 12 +++-
 net/qrtr/qrtr.c                                    |  2 +-
 net/qrtr/tun.c                                     |  6 ++
 net/rds/rdma.c                                     |  3 +
 net/sctp/proc.c                                    | 16 ++++--
 net/vmw_vsock/af_vsock.c                           | 13 ++---
 net/vmw_vsock/hyperv_transport.c                   |  4 --
 net/vmw_vsock/virtio_transport_common.c            |  4 +-
 security/commoncap.c                               | 67 ++++++++++++++--------
 virt/kvm/kvm_main.c                                |  3 +-
 54 files changed, 303 insertions(+), 205 deletions(-)


