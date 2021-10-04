Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 150B4420E34
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236571AbhJDNW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:22:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236060AbhJDNU5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:20:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E47C61BBF;
        Mon,  4 Oct 2021 13:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352936;
        bh=T3N3wNOfC8IDHT7X7PhuA7yThcM3MehuEdKS8DE/szg=;
        h=From:To:Cc:Subject:Date:From;
        b=y+e11XnJsq74Gysm389WUz3OGqWP6ZtHpfQuMjgU2OULVwgibeSTu9VbBKhhys6TX
         dLWnCMCMZJCeBJ3daXh+P40ZSGY5gZk60Yyv4iwA5k67ynDJwJlY6PU5LegNQO2utO
         uOK2/YX81WcprzZH/zlxUM7jL+H1/wl08LoP+sGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 00/93] 5.10.71-rc1 review
Date:   Mon,  4 Oct 2021 14:51:58 +0200
Message-Id: <20211004125034.579439135@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.71-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.71-rc1
X-KernelTest-Deadline: 2021-10-06T12:50+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.71 release.
There are 93 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 06 Oct 2021 12:50:17 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.71-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.71-rc1

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: Fix oversized kvmalloc() calls

Eric Dumazet <edumazet@google.com>
    netfilter: conntrack: serialize hash resizes and cleanups

Haimin Zhang <tcs_kernel@tencent.com>
    KVM: x86: Handle SRCU initialization failure during page track init

Yanfei Xu <yanfei.xu@windriver.com>
    net: mdiobus: Fix memory leak in __mdiobus_register

Anirudh Rayabharam <mail@anirudhrb.com>
    HID: usbhid: free raw_report buffers in usbhid_stop

Linus Torvalds <torvalds@linux-foundation.org>
    mm: don't allow oversized kvmalloc() calls

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: Fix oversized kvmalloc() calls

F.A.Sulaiman <asha.16@itfac.mrt.ac.lk>
    HID: betop: fix slab-out-of-bounds Write in betop_probe

Dan Carpenter <dan.carpenter@oracle.com>
    crypto: ccp - fix resource leaks in ccp_run_aes_gcm_cmd()

Dongliang Mu <mudongliangabcd@gmail.com>
    usb: hso: remove the bailout parameter

Shuming Fan <shumingf@realtek.com>
    ASoC: dapm: use component prefix when checking widget names

Eric Dumazet <edumazet@google.com>
    net: udp: annotate data race around udp_sk(sk)->corkflag

Andrej Shadura <andrew.shadura@collabora.co.uk>
    HID: u2fzero: ignore incomplete packets without data

yangerkun <yangerkun@huawei.com>
    ext4: fix potential infinite loop in ext4_dx_readdir()

Theodore Ts'o <tytso@mit.edu>
    ext4: add error checking to ext4_ext_replay_set_iblocks()

Jeffle Xu <jefflexu@linux.alibaba.com>
    ext4: fix reserved space counter leakage

Hou Tao <houtao1@huawei.com>
    ext4: limit the number of blocks in one ADD_RANGE TLV

Ritesh Harjani <riteshh@linux.ibm.com>
    ext4: fix loff_t overflow in ext4_max_bitmap_size()

Johan Hovold <johan@kernel.org>
    ipack: ipoctal: fix module reference leak

Johan Hovold <johan@kernel.org>
    ipack: ipoctal: fix missing allocation-failure check

Johan Hovold <johan@kernel.org>
    ipack: ipoctal: fix tty-registration error handling

Johan Hovold <johan@kernel.org>
    ipack: ipoctal: fix tty registration race

Johan Hovold <johan@kernel.org>
    ipack: ipoctal: fix stack information leak

Nirmoy Das <nirmoy.das@amd.com>
    debugfs: debugfs_create_file_size(): use IS_ERR to check for error

Chen Jingwen <chenjingwen6@huawei.com>
    elf: don't use MAP_FIXED_NOREPLACE for elf interpreter mappings

Keith Busch <kbusch@kernel.org>
    nvme: add command id quirk for apple controllers

Vadim Pasternak <vadimp@nvidia.com>
    hwmon: (pmbus/mp2975) Add missed POUT attribute for page 1 mp2975 controller

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Update event constraints for ICX

Eric Dumazet <edumazet@google.com>
    af_unix: fix races in sk_peer_pid and sk_peer_cred accesses

Vlad Buslov <vladbu@nvidia.com>
    net: sched: flower: protect fl_walk() with rcu

Florian Fainelli <f.fainelli@gmail.com>
    net: phy: bcm7xxx: Fixed indirect MMD operations

Guangbin Huang <huangguangbin2@huawei.com>
    net: hns3: fix always enable rx vlan filter problem after selftest

Peng Li <lipeng321@huawei.com>
    net: hns3: reconstruct function hns3_self_test

Huazhong Tan <tanhuazhong@huawei.com>
    net: hns3: fix prototype warning

Jian Shen <shenjian15@huawei.com>
    net: hns3: fix show wrong state when add existing uc mac address

Jian Shen <shenjian15@huawei.com>
    net: hns3: fix mixed flag HCLGE_FLAG_MQPRIO_ENABLE and HCLGE_FLAG_DCB_ENABLE

Yonglong Liu <liuyonglong@huawei.com>
    net: hns3: keep MAC pause mode when multiple TCs are enabled

Jian Shen <shenjian15@huawei.com>
    net: hns3: do not allow call hns3_nic_net_open repeatedly

Feng Zhou <zhoufeng.zf@bytedance.com>
    ixgbe: Fix NULL pointer dereference in ixgbe_xdp_setup

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    scsi: csiostor: Add module softdep on cxgb4

Jens Axboe <axboe@kernel.dk>
    Revert "block, bfq: honor already-setup queue merges"

Arnd Bergmann <arnd@arndb.de>
    net: ks8851: fix link error

Jiri Benc <jbenc@redhat.com>
    selftests, bpf: test_lwt_ip_encap: Really disable rp_filter

Jiri Benc <jbenc@redhat.com>
    selftests, bpf: Fix makefile dependencies on libbpf

Lorenz Bauer <lmb@cloudflare.com>
    bpf: Exempt CAP_BPF from checks against bpf_jit_limit

Yixing Liu <liuyixing1@huawei.com>
    RDMA/hns: Fix inaccurate prints

Jacob Keller <jacob.e.keller@intel.com>
    e100: fix buffer overrun in e100_get_regs

Jacob Keller <jacob.e.keller@intel.com>
    e100: fix length calculation in e100_get_regs_len

Andrew Lunn <andrew@lunn.ch>
    dsa: mv88e6xxx: Include tagger overhead when setting MTU for DSA and CPU ports

Andrew Lunn <andrew@lunn.ch>
    dsa: mv88e6xxx: Fix MTU definition

Andrew Lunn <andrew@lunn.ch>
    dsa: mv88e6xxx: 6161: Use chip wide MAX MTU

Matthew Auld <matthew.auld@intel.com>
    drm/i915/request: fix early tracepoints

Aaro Koskinen <aaro.koskinen@iki.fi>
    smsc95xx: fix stalled rx after link change

Xiao Liang <shaw.leon@gmail.com>
    net: ipv4: Fix rtnexthop len when RTA_FLOW is present

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: fix the incorrect clearing of IF_MODE bits

Paul Fertser <fercerpav@gmail.com>
    hwmon: (tmp421) fix rounding for negative values

Paul Fertser <fercerpav@gmail.com>
    hwmon: (tmp421) report /PVLD condition as fault

Florian Westphal <fw@strlen.de>
    mptcp: don't return sockets in foreign netns

Xin Long <lucien.xin@gmail.com>
    sctp: break out if skb_header_pointer returns NULL in sctp_rcv_ootb

Johannes Berg <johannes.berg@intel.com>
    mac80211-hwsim: fix late beacon hrtimer handling

Johannes Berg <johannes.berg@intel.com>
    mac80211: mesh: fix potentially unaligned access

Lorenzo Bianconi <lorenzo@kernel.org>
    mac80211: limit injected vht mcs/nss in ieee80211_parse_tx_radiotap

Chih-Kang Chang <gary.chang@realtek.com>
    mac80211: Fix ieee80211_amsdu_aggregate frag_tail bug

Vadim Pasternak <vadimp@nvidia.com>
    hwmon: (mlxreg-fan) Return non-zero value when fan current state is enforced from sysfs

Piotr Krysiuk <piotras@gmail.com>
    bpf, mips: Validate conditional branch offsets

Tao Liu <thomas.liu@ucloud.cn>
    RDMA/cma: Fix listener leak in rdma_cma_listen_on_all() failure

Christoph Lameter <cl@gentwo.de>
    IB/cma: Do not send IGMP leaves for sendonly Multicast groups

Hou Tao <houtao1@huawei.com>
    bpf: Handle return value of BPF_PROG_TYPE_STRUCT_OPS prog

Andrea Claudi <aclaudi@redhat.com>
    ipvs: check that ip_vs_conn_tab_bits is between 8 and 20

Hawking Zhang <Hawking.Zhang@amd.com>
    drm/amdgpu: correct initial cp_hqd_quantum for gfx9

Charlene Liu <Charlene.Liu@amd.com>
    drm/amd/display: Pass PCI deviceid into DC

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/cma: Do not change route.addr.src_addr.ss_family

Sean Young <sean@mess.org>
    media: ir_toy: prevent device from hanging during transmit

Sean Christopherson <seanjc@google.com>
    KVM: rseq: Update rseq when processing NOTIFY_RESUME on xfer to KVM guest

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: nVMX: Filter out all unsupported controls when eVMCS was activated

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: nSVM: don't copy virt_ext from vmcb12

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: Fix stack-out-of-bounds memory access from ioapic_write_indirect()

Zelin Deng <zelin.deng@linux.alibaba.com>
    x86/kvmclock: Move this_cpu_pvti into kvmclock.h

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix use-after-free in CCMP/GCMP RX

Jonathan Hsu <jonathan.hsu@mediatek.com>
    scsi: ufs: Fix illegal offset in UPIU event trace

Andrey Gusakov <andrey.gusakov@cogentembedded.com>
    gpio: pca953x: do not ignore i2c errors

Nadezda Lutovinova <lutovinova@ispras.ru>
    hwmon: (w83791d) Fix NULL pointer dereference by removing unnecessary structure field

Nadezda Lutovinova <lutovinova@ispras.ru>
    hwmon: (w83792d) Fix NULL pointer dereference by removing unnecessary structure field

Nadezda Lutovinova <lutovinova@ispras.ru>
    hwmon: (w83793) Fix NULL pointer dereference by removing unnecessary structure field

Paul Fertser <fercerpav@gmail.com>
    hwmon: (tmp421) handle I2C errors

Eric Biggers <ebiggers@google.com>
    fs-verity: fix signed integer overflow with i_size near S64_MAX

Jia He <justin.he@arm.com>
    ACPI: NFIT: Use fallback node id when numa info in NFIT table is incorrect

Cameron Berkenpas <cam@neo-zeon.de>
    ALSA: hda/realtek: Quirks to enable speaker output for Lenovo Legion 7i 15IMHG05, Yoga 7i 14ITL5/15ITL5, and 13s Gen2 laptops.

Pawel Laszczak <pawell@cadence.com>
    usb: cdns3: fix race condition before setting doorbell

James Morse <james.morse@arm.com>
    cpufreq: schedutil: Destroy mutex before kobject_put() frees the memory

Saurav Kashyap <skashyap@marvell.com>
    scsi: qla2xxx: Changes to support kdump kernel for NVMe BFS

Kevin Hao <haokexin@gmail.com>
    cpufreq: schedutil: Use kobject release() method to free sugov_tunables

Igor Matheus Andrade Torrente <igormtorrente@gmail.com>
    tty: Fix out-of-bound vmalloc access in imageblit


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/mips/net/bpf_jit.c                            |  57 ++++++---
 arch/x86/events/intel/core.c                       |   1 +
 arch/x86/include/asm/kvm_page_track.h              |   2 +-
 arch/x86/include/asm/kvmclock.h                    |  14 +++
 arch/x86/kernel/kvmclock.c                         |  13 +--
 arch/x86/kvm/ioapic.c                              |  10 +-
 arch/x86/kvm/mmu/page_track.c                      |   4 +-
 arch/x86/kvm/svm/nested.c                          |   1 -
 arch/x86/kvm/vmx/evmcs.c                           |  12 +-
 arch/x86/kvm/vmx/vmx.c                             |   9 +-
 arch/x86/kvm/x86.c                                 |   7 +-
 arch/x86/net/bpf_jit_comp.c                        |  53 ++++++---
 block/bfq-iosched.c                                |  16 +--
 drivers/acpi/nfit/core.c                           |  12 ++
 drivers/cpufreq/cpufreq_governor_attr_set.c        |   2 +-
 drivers/crypto/ccp/ccp-ops.c                       |  14 ++-
 drivers/gpio/gpio-pca953x.c                        |  11 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   1 +
 drivers/gpu/drm/i915/i915_request.c                |  11 +-
 drivers/hid/hid-betopff.c                          |  13 ++-
 drivers/hid/hid-u2fzero.c                          |   4 +-
 drivers/hid/usbhid/hid-core.c                      |  13 ++-
 drivers/hwmon/mlxreg-fan.c                         |  12 +-
 drivers/hwmon/pmbus/mp2975.c                       |   2 +-
 drivers/hwmon/tmp421.c                             |  71 +++++++-----
 drivers/hwmon/w83791d.c                            |  29 ++---
 drivers/hwmon/w83792d.c                            |  28 ++---
 drivers/hwmon/w83793.c                             |  26 ++---
 drivers/infiniband/core/cma.c                      |  28 ++++-
 drivers/infiniband/hw/hns/hns_roce_alloc.c         |   4 +-
 drivers/infiniband/hw/hns/hns_roce_cq.c            |  35 +++---
 drivers/infiniband/hw/hns/hns_roce_hem.c           |  18 +--
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  30 ++---
 drivers/infiniband/hw/hns/hns_roce_mr.c            |  10 +-
 drivers/infiniband/hw/hns/hns_roce_pd.c            |   2 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |  61 +++++-----
 drivers/infiniband/hw/hns/hns_roce_srq.c           |  37 +++---
 drivers/ipack/devices/ipoctal.c                    |  63 +++++++---
 drivers/media/rc/ir_toy.c                          |  21 +++-
 drivers/net/dsa/mv88e6xxx/chip.c                   |  17 +--
 drivers/net/dsa/mv88e6xxx/chip.h                   |   1 +
 drivers/net/dsa/mv88e6xxx/global1.c                |   2 +
 drivers/net/dsa/mv88e6xxx/port.c                   |   2 +
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |   3 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   5 +
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 105 +++++++++++------
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c |   7 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  19 ++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |  52 ++++-----
 drivers/net/ethernet/intel/e100.c                  |  22 ++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c   |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   8 +-
 drivers/net/ethernet/micrel/Makefile               |   6 +-
 drivers/net/ethernet/micrel/ks8851_common.c        |   8 ++
 drivers/net/phy/bcm7xxx.c                          | 114 +++++++++++++++++-
 drivers/net/phy/mdio_bus.c                         |   1 +
 drivers/net/usb/hso.c                              |   6 +-
 drivers/net/usb/smsc95xx.c                         |   3 +
 drivers/net/wireless/mac80211_hwsim.c              |   4 +-
 drivers/nvme/host/core.c                           |   4 +-
 drivers/nvme/host/nvme.h                           |   6 +
 drivers/nvme/host/pci.c                            |   3 +-
 drivers/scsi/csiostor/csio_init.c                  |   1 +
 drivers/scsi/qla2xxx/qla_def.h                     |   1 -
 drivers/scsi/qla2xxx/qla_isr.c                     |   2 +
 drivers/scsi/qla2xxx/qla_nvme.c                    |  40 +++----
 drivers/scsi/ufs/ufshcd.c                          |   3 +-
 drivers/tty/vt/vt.c                                |  21 +++-
 drivers/usb/cdns3/gadget.c                         |  14 +++
 fs/binfmt_elf.c                                    |   2 +-
 fs/debugfs/inode.c                                 |   2 +-
 fs/ext4/dir.c                                      |   6 +-
 fs/ext4/extents.c                                  |  19 ++-
 fs/ext4/fast_commit.c                              |   6 +
 fs/ext4/inode.c                                    |   5 +
 fs/ext4/super.c                                    |  16 ++-
 fs/verity/enable.c                                 |   2 +-
 fs/verity/open.c                                   |   2 +-
 include/linux/bpf.h                                |   2 +
 include/net/ip_fib.h                               |   2 +-
 include/net/nexthop.h                              |   2 +-
 include/net/sock.h                                 |   2 +
 kernel/bpf/bpf_struct_ops.c                        |   7 +-
 kernel/bpf/core.c                                  |   2 +-
 kernel/entry/kvm.c                                 |   4 +-
 kernel/rseq.c                                      |  13 ++-
 kernel/sched/cpufreq_schedutil.c                   |  16 ++-
 mm/util.c                                          |   4 +
 net/core/sock.c                                    |  32 ++++-
 net/ipv4/fib_semantics.c                           |  16 +--
 net/ipv4/udp.c                                     |  10 +-
 net/ipv6/route.c                                   |   5 +-
 net/ipv6/udp.c                                     |   2 +-
 net/mac80211/mesh_ps.c                             |   3 +-
 net/mac80211/tx.c                                  |  12 ++
 net/mac80211/wpa.c                                 |   6 +
 net/mptcp/mptcp_diag.c                             |   2 +-
 net/mptcp/protocol.h                               |   2 +-
 net/mptcp/subflow.c                                |   2 +-
 net/mptcp/syncookies.c                             |  13 +--
 net/mptcp/token.c                                  |  11 +-
 net/mptcp/token_test.c                             |  14 ++-
 net/netfilter/ipset/ip_set_hash_gen.h              |   4 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |   4 +
 net/netfilter/nf_conntrack_core.c                  |  70 +++++------
 net/netfilter/nf_tables_api.c                      |   2 +-
 net/sched/cls_flower.c                             |   6 +
 net/sctp/input.c                                   |   2 +-
 net/unix/af_unix.c                                 |  34 +++++-
 sound/pci/hda/patch_realtek.c                      | 129 +++++++++++++++++++++
 sound/soc/soc-dapm.c                               |  13 ++-
 tools/testing/selftests/bpf/Makefile               |   3 +-
 tools/testing/selftests/bpf/test_lwt_ip_encap.sh   |  13 ++-
 115 files changed, 1205 insertions(+), 564 deletions(-)


