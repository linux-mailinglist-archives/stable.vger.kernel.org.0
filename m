Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D915ACD72
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731579AbfIHMth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:49:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:39616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731555AbfIHMtg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:49:36 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A52B218AF;
        Sun,  8 Sep 2019 12:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946975;
        bh=7oDFNL8EfZut0Psa7/EqF+RPWlc/tWu6gzBaK2OFQIE=;
        h=From:To:Cc:Subject:Date:From;
        b=R3wp1BA1p8enVL0pF9cXFpaVRSntIBAR/3MdZbaXKaIZgBUmb4fWeaPAjYQuIOv6g
         FuKDnEUwbMpxCjPKgp4swMJJqLofScNLL8F3Hw1e1Hva94e1/6yL3W1ChypXJfyUjH
         cXPvGswnIkgo74geMiPQhCQfk9f6sqgO9Z66FsR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.2 00/94] 5.2.14-stable review
Date:   Sun,  8 Sep 2019 13:40:56 +0100
Message-Id: <20190908121150.420989666@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.2.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.14-rc1
X-KernelTest-Deadline: 2019-09-10T12:11+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.2.14 release.
There are 94 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue 10 Sep 2019 12:09:36 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.14-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.2.14-rc1

Jan Kaisrlik <ja.kaisrlik@gmail.com>
    Revert "mmc: core: do not retry CMD6 in __mmc_switch()"

John S. Gruber <JohnSGruber@gmail.com>
    x86/boot: Preserve boot_params.secure_boot from sanitizing

Linus Torvalds <torvalds@linux-foundation.org>
    Revert "x86/apic: Include the LDR when clearing out APIC registers"

Luis Henriques <lhenriques@suse.com>
    libceph: allow ceph_buffer_put() to receive a NULL ceph_buffer

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    x86/boot/compressed/64: Fix missing initialization in find_trampoline_placement()

Andre Przywara <andre.przywara@arm.com>
    KVM: arm/arm64: VGIC: Properly initialise private IRQ affinity

Linus Walleij <linus.walleij@linaro.org>
    gpio: Fix irqchip initialization order

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Fix stack-out-of-bounds in bnxt_qplib_rcfw_send_message

YueHaibing <yuehaibing@huawei.com>
    afs: use correct afs_call_type in yfs_fs_store_opaque_acl2

Marc Dionne <marc.dionne@auristor.com>
    afs: Fix possible oops in afs_lookup trace event

David Howells <dhowells@redhat.com>
    afs: Fix leak in afs_lookup_cell_rcu()

Andrew Jones <drjones@redhat.com>
    KVM: arm/arm64: Only skip MMIO insn once

Luis Henriques <lhenriques@suse.com>
    ceph: fix buffer free while holding i_ceph_lock in fill_inode()

Luis Henriques <lhenriques@suse.com>
    ceph: fix buffer free while holding i_ceph_lock in __ceph_build_xattrs_blob()

Luis Henriques <lhenriques@suse.com>
    ceph: fix buffer free while holding i_ceph_lock in __ceph_setxattr()

Nicolai Hähnle <nicolai.haehnle@amd.com>
    drm/amdgpu: prevent memory leaks in AMDGPU_CS ioctl

Vitaly Kuznetsov <vkuznets@redhat.com>
    selftests/kvm: make platform_info_test pass on AMD

Paolo Bonzini <pbonzini@redhat.com>
    selftests: kvm: fix state save/load on processors without XSAVE

Wenwen Wang <wenwen@cs.uga.edu>
    infiniband: hfi1: fix memory leaks

Wenwen Wang <wenwen@cs.uga.edu>
    infiniband: hfi1: fix a memory leak bug

Wenwen Wang <wenwen@cs.uga.edu>
    IB/mlx4: Fix memory leaks

zhengbin <zhengbin13@huawei.com>
    RDMA/cma: fix null-ptr-deref Read in cma_cleanup

Guilherme G. Piccoli <gpiccoli@canonical.com>
    nvme: Fix cntlid validation when not using NVMEoF

Anton Eidelman <anton@lightbitslabs.com>
    nvme-multipath: fix possible I/O hang when paths are updated

Vitaly Kuznetsov <vkuznets@redhat.com>
    Tools: hv: kvp: eliminate 'may be used uninitialized' warning

Dexuan Cui <decui@microsoft.com>
    Input: hyperv-keyboard: Use in-place iterator API in the channel callback

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Mitigate high memory pre-allocation by SCSI-MQ

Kirill A. Shutemov <kirill@shutemov.name>
    x86/boot/compressed/64: Fix boot on machines with broken E820 table

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    HID: cp2112: prevent sleeping function called from invalid context

Even Xu <even.xu@intel.com>
    HID: intel-ish-hid: ipc: add EHL device id

Andrea Righi <andrea.righi@canonical.com>
    kprobes: Fix potential deadlock in kprobe_optimizer()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    sched/core: Schedule new worker even if PI-blocked

Tho Vu <tho.vu.wh@rvc.renesas.com>
    ravb: Fix use-after-free ravb_tstamp_skb

Wenwen Wang <wenwen@cs.uga.edu>
    wimax/i2400m: fix a memory leak bug

Stephen Hemminger <stephen@networkplumber.org>
    net: cavium: fix driver name

Thomas Falcon <tlfalcon@linux.ibm.com>
    ibmvnic: Unmap DMA address of TX descriptor buffers after use

Wenwen Wang <wenwen@cs.uga.edu>
    net: kalmia: fix memory leaks

Wenwen Wang <wenwen@cs.uga.edu>
    cx82310_eth: fix a memory leak bug

Darrick J. Wong <darrick.wong@oracle.com>
    vfs: fix page locking deadlocks when deduping files

Wenwen Wang <wenwen@cs.uga.edu>
    lan78xx: Fix memory leaks

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    clk: Fix potential NULL dereference in clk_fetch_parent_index()

Stephen Boyd <sboyd@kernel.org>
    clk: Fix falling back to legacy parent string matching

Wenwen Wang <wenwen@cs.uga.edu>
    net: myri10ge: fix memory leaks

Wenwen Wang <wenwen@cs.uga.edu>
    liquidio: add cleanup in octeon_setup_iq()

Paolo Bonzini <pbonzini@redhat.com>
    selftests: kvm: fix vmx_set_nested_state_test

Paolo Bonzini <pbonzini@redhat.com>
    selftests: kvm: provide common function to enable eVMCS

Paolo Bonzini <pbonzini@redhat.com>
    selftests: kvm: do not try running the VM in vmx_set_nested_state_test

Wenwen Wang <wenwen@cs.uga.edu>
    cxgb4: fix a memory leak bug

Dmitry Fomichev <dmitry.fomichev@wdc.com>
    scsi: target: tcmu: avoid use-after-free after command timeout

Bill Kuzeja <William.Kuzeja@stratus.com>
    scsi: qla2xxx: Fix gnl.l memory leak on adapter init failure

Alexandre Courbot <acourbot@chromium.org>
    drm/mediatek: set DMA max segment size

Alexandre Courbot <acourbot@chromium.org>
    drm/mediatek: use correct device to import PRIME buffers

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_flow_offload: skip tcp rst and fin packets

YueHaibing <yuehaibing@huawei.com>
    gpio: Fix build error of function redefinition

Thomas Falcon <tlfalcon@linux.ibm.com>
    ibmveth: Convert multicast list size for little-endian system

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: serialize cmd reply with concurrent timeout

Fabian Henneke <fabian.henneke@gmail.com>
    Bluetooth: hidp: Let hidp_send_message return number of queued bytes

Harish Bandi <c-hbandi@codeaurora.org>
    Bluetooth: hci_qca: Send VS pre shutdown command.

Matthias Kaehlcke <mka@chromium.org>
    Bluetooth: btqca: Add a short delay before downloading the NVM

Nathan Chancellor <natechancellor@gmail.com>
    net: tc35815: Explicitly check NET_IP_ALIGN is not zero in tc35815_rx

Dexuan Cui <decui@microsoft.com>
    hv_netvsc: Fix a warning of suspicious RCU usage

Taehee Yoo <ap420073@gmail.com>
    ixgbe: fix possible deadlock in ixgbe_service_task()

Jakub Kicinski <jakub.kicinski@netronome.com>
    tools: bpftool: fix error message (prog -> object)

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_flow_table: teardown flow timeout race

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_flow_table: conntrack picks up expired flows

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: use-after-free in failing rule with bound set

Fuqian Huang <huangfq.daxian@gmail.com>
    net: tundra: tsi108: use spin_lock_irqsave instead of spin_lock_irq in IRQ context

Marek Szyprowski <m.szyprowski@samsung.com>
    clk: samsung: exynos542x: Move MSCL subsystem clocks to its sub-CMU

Sylwester Nawrocki <s.nawrocki@samsung.com>
    clk: samsung: exynos5800: Move MAU subsystem clocks to MAU sub-CMU

Sylwester Nawrocki <s.nawrocki@samsung.com>
    clk: samsung: Change signature of exynos5_subcmus_init() function

Aya Levin <ayal@mellanox.com>
    net/mlx5e: Fix error flow of CQE recovery on tx reporter

Florian Westphal <fw@strlen.de>
    netfilter: nf_flow_table: fix offload for flows that are subject to xfrm

Andrii Nakryiko <andriin@fb.com>
    libbpf: set BTF FD for prog only when there is supported .BTF.ext data

Andrii Nakryiko <andriin@fb.com>
    libbpf: fix erroneous multi-closing of BTF FD

Sven Eckelmann <sven@narfation.org>
    batman-adv: Fix netlink dumping of all mcast_flags buckets

Ka-Cheong Poon <ka-cheong.poon@oracle.com>
    net/rds: Fix info leak in rds6_inc_info_copy()

Davide Caratti <dcaratti@redhat.com>
    net/sched: pfifo_fast: fix wrong dereference when qdisc is reset

Davide Caratti <dcaratti@redhat.com>
    net/sched: pfifo_fast: fix wrong dereference in pfifo_fast_enqueue

Vladimir Oltean <olteanv@gmail.com>
    net: dsa: tag_8021q: Future-proof the reserved fields in the custom VID

Marco Hartmann <marco.hartmann@nxp.com>
    Add genphy_c45_config_aneg() function to phy-c45.c

Vladimir Oltean <olteanv@gmail.com>
    net/sched: cbs: Set default link speed to 10 Mbps in cbs_set_port_rate

Vladimir Oltean <olteanv@gmail.com>
    taprio: Set default link speed to 10 Mbps in taprio_set_picos_per_byte

Vladimir Oltean <olteanv@gmail.com>
    taprio: Fix kernel panic in taprio_destroy

Hayes Wang <hayeswang@realtek.com>
    r8152: remove calling netif_napi_del

Hayes Wang <hayeswang@realtek.com>
    Revert "r8152: napi hangup fix after disconnect"

John Hurley <john.hurley@netronome.com>
    nfp: flower: handle neighbour events on internal ports

John Hurley <john.hurley@netronome.com>
    nfp: flower: prevent ingress block binds on internal ports

Eric Dumazet <edumazet@google.com>
    tcp: remove empty skb from write queue in error cases

Willem de Bruijn <willemb@google.com>
    tcp: inherit timestamp on mtu probe

Chen-Yu Tsai <wens@csie.org>
    net: stmmac: dwmac-rk: Don't fail if phy regulator is absent

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: fix a NULL pointer deref in ipt action

Vlad Buslov <vladbu@mellanox.com>
    net: sched: act_sample: fix psample group handling on overwrite

Feng Sun <loyou85@gmail.com>
    net: fix skb use after free in netpoll

Eric Dumazet <edumazet@google.com>
    mld: fix memory leak in mld_del_delrec()


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/x86/boot/compressed/pgtable_64.c              |  13 +-
 arch/x86/include/asm/bootparam_utils.h             |   1 +
 arch/x86/kernel/apic/apic.c                        |   4 -
 drivers/bluetooth/btqca.c                          |  24 +++
 drivers/bluetooth/btqca.h                          |   7 +
 drivers/bluetooth/hci_qca.c                        |   3 +
 drivers/clk/clk.c                                  |  49 +++++--
 drivers/clk/samsung/clk-exynos5-subcmu.c           |  16 +-
 drivers/clk/samsung/clk-exynos5-subcmu.h           |   2 +-
 drivers/clk/samsung/clk-exynos5250.c               |   7 +-
 drivers/clk/samsung/clk-exynos5420.c               | 162 ++++++++++++++-------
 drivers/gpio/gpiolib.c                             |  30 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |   9 +-
 drivers/gpu/drm/mediatek/mtk_drm_drv.c             |  49 ++++++-
 drivers/gpu/drm/mediatek/mtk_drm_drv.h             |   2 +
 drivers/hid/hid-cp2112.c                           |   8 +-
 drivers/hid/intel-ish-hid/ipc/hw-ish.h             |   1 +
 drivers/hid/intel-ish-hid/ipc/pci-ish.c            |   1 +
 drivers/infiniband/core/cma.c                      |   6 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c         |   8 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h         |  11 +-
 drivers/infiniband/hw/hfi1/fault.c                 |  12 +-
 drivers/infiniband/hw/mlx4/mad.c                   |   4 +-
 drivers/input/serio/hyperv-keyboard.c              |  35 +----
 drivers/mmc/core/mmc_ops.c                         |   2 +-
 drivers/net/ethernet/cavium/common/cavium_ptp.c    |   2 +-
 .../net/ethernet/cavium/liquidio/request_manager.c |   4 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c |   4 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |   9 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  11 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   5 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   1 -
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |   2 +-
 .../net/ethernet/netronome/nfp/flower/offload.c    |   7 +-
 .../ethernet/netronome/nfp/flower/tunnel_conf.c    |   8 +-
 drivers/net/ethernet/renesas/ravb_main.c           |   8 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c     |   6 +-
 drivers/net/ethernet/toshiba/tc35815.c             |   2 +-
 drivers/net/ethernet/tundra/tsi108_eth.c           |   5 +-
 drivers/net/hyperv/netvsc_drv.c                    |   9 +-
 drivers/net/phy/phy-c45.c                          |  26 ++++
 drivers/net/phy/phy.c                              |   2 +-
 drivers/net/usb/cx82310_eth.c                      |   3 +-
 drivers/net/usb/kalmia.c                           |   6 +-
 drivers/net/usb/lan78xx.c                          |   8 +-
 drivers/net/usb/r8152.c                            |   5 +-
 drivers/net/wimax/i2400m/fw.c                      |   4 +-
 drivers/nvme/host/core.c                           |   4 +-
 drivers/nvme/host/multipath.c                      |   1 +
 drivers/s390/net/qeth_core.h                       |   1 +
 drivers/s390/net/qeth_core_main.c                  |  20 +++
 drivers/scsi/lpfc/lpfc.h                           |   1 +
 drivers/scsi/lpfc/lpfc_attr.c                      |  15 ++
 drivers/scsi/lpfc/lpfc_init.c                      |  10 +-
 drivers/scsi/lpfc/lpfc_sli4.h                      |   5 +
 drivers/scsi/qla2xxx/qla_attr.c                    |   2 +
 drivers/scsi/qla2xxx/qla_os.c                      |  11 +-
 drivers/target/target_core_user.c                  |   9 +-
 fs/afs/cell.c                                      |   4 +
 fs/afs/dir.c                                       |   3 +-
 fs/afs/yfsclient.c                                 |   2 +-
 fs/ceph/caps.c                                     |   5 +-
 fs/ceph/inode.c                                    |   7 +-
 fs/ceph/snap.c                                     |   4 +-
 fs/ceph/super.h                                    |   2 +-
 fs/ceph/xattr.c                                    |  19 ++-
 fs/read_write.c                                    |  49 ++++++-
 include/linux/ceph/buffer.h                        |   3 +-
 include/linux/gpio.h                               |  24 ---
 include/linux/phy.h                                |   1 +
 include/net/act_api.h                              |   4 +-
 include/net/netfilter/nf_tables.h                  |   9 +-
 include/net/psample.h                              |   1 +
 kernel/kprobes.c                                   |   8 +-
 kernel/sched/core.c                                |   5 +-
 net/batman-adv/multicast.c                         |   2 +-
 net/bluetooth/hidp/core.c                          |   9 +-
 net/core/netpoll.c                                 |   6 +-
 net/dsa/tag_8021q.c                                |   2 +
 net/ipv4/tcp.c                                     |  30 ++--
 net/ipv4/tcp_output.c                              |   3 +-
 net/ipv6/mcast.c                                   |   5 +-
 net/netfilter/nf_flow_table_core.c                 |  43 ++++--
 net/netfilter/nf_flow_table_ip.c                   |  43 ++++++
 net/netfilter/nf_tables_api.c                      |  15 +-
 net/netfilter/nft_flow_offload.c                   |   9 +-
 net/psample/psample.c                              |   2 +-
 net/rds/recv.c                                     |   5 +-
 net/sched/act_bpf.c                                |   2 +-
 net/sched/act_connmark.c                           |   2 +-
 net/sched/act_csum.c                               |   2 +-
 net/sched/act_gact.c                               |   2 +-
 net/sched/act_ife.c                                |   2 +-
 net/sched/act_ipt.c                                |  11 +-
 net/sched/act_mirred.c                             |   2 +-
 net/sched/act_nat.c                                |   2 +-
 net/sched/act_pedit.c                              |   2 +-
 net/sched/act_police.c                             |   2 +-
 net/sched/act_sample.c                             |   8 +-
 net/sched/act_simple.c                             |   2 +-
 net/sched/act_skbedit.c                            |   2 +-
 net/sched/act_skbmod.c                             |   2 +-
 net/sched/act_tunnel_key.c                         |   2 +-
 net/sched/act_vlan.c                               |   2 +-
 net/sched/sch_cbs.c                                |  19 ++-
 net/sched/sch_generic.c                            |  19 ++-
 net/sched/sch_taprio.c                             |  31 ++--
 tools/bpf/bpftool/common.c                         |   2 +-
 tools/hv/hv_kvp_daemon.c                           |   2 +-
 tools/lib/bpf/libbpf.c                             |  15 +-
 tools/testing/selftests/kvm/include/evmcs.h        |   2 +
 tools/testing/selftests/kvm/lib/x86_64/processor.c |  16 +-
 tools/testing/selftests/kvm/lib/x86_64/vmx.c       |  20 +++
 tools/testing/selftests/kvm/x86_64/evmcs_test.c    |  15 +-
 tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c  |  12 +-
 .../selftests/kvm/x86_64/platform_info_test.c      |   2 +-
 .../kvm/x86_64/vmx_set_nested_state_test.c         |  32 ++--
 virt/kvm/arm/mmio.c                                |   7 +
 virt/kvm/arm/vgic/vgic-init.c                      |  30 ++--
 121 files changed, 872 insertions(+), 421 deletions(-)


