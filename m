Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77E91424013
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 16:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238334AbhJFOaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 10:30:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231356AbhJFOaH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 10:30:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0A0861056;
        Wed,  6 Oct 2021 14:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633530495;
        bh=vlaffp/3jPTTwJhK+GCUGUvE60SQIwuWU3Kt2xtR1q4=;
        h=From:To:Cc:Subject:Date:From;
        b=VpXo9JZXLeMg8X22TismGsvKiPAV2IOcjH6WCXCkHKUwfyNZE9PrBX/kh0b43Y5YX
         7m9dXfQHM8i7RZWNFzqB4jeo+dmb3K+tHynKXn8fQ1fW5jnIEN5rLJy/GnFiBxZndc
         ezgqGR/QxO7nmsEeQpJ3v+K/oM/T01AKBe6TdQgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.71
Date:   Wed,  6 Oct 2021 16:28:11 +0200
Message-Id: <1633530492253198@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.71 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 
 arch/mips/net/bpf_jit.c                                 |   57 +++++--
 arch/x86/events/intel/core.c                            |    1 
 arch/x86/include/asm/kvm_page_track.h                   |    2 
 arch/x86/include/asm/kvmclock.h                         |   14 +
 arch/x86/kernel/kvmclock.c                              |   13 -
 arch/x86/kvm/ioapic.c                                   |   10 -
 arch/x86/kvm/mmu/page_track.c                           |    4 
 arch/x86/kvm/svm/nested.c                               |    1 
 arch/x86/kvm/vmx/evmcs.c                                |   12 +
 arch/x86/kvm/vmx/vmx.c                                  |    9 -
 arch/x86/kvm/x86.c                                      |    7 
 arch/x86/net/bpf_jit_comp.c                             |   53 ++++--
 block/bfq-iosched.c                                     |   16 -
 drivers/acpi/nfit/core.c                                |   12 +
 drivers/cpufreq/cpufreq_governor_attr_set.c             |    2 
 drivers/crypto/ccp/ccp-ops.c                            |   14 -
 drivers/gpio/gpio-pca953x.c                             |   11 -
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c                   |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c       |    1 
 drivers/gpu/drm/i915/i915_request.c                     |   11 -
 drivers/hid/hid-betopff.c                               |   13 +
 drivers/hid/hid-u2fzero.c                               |    4 
 drivers/hid/usbhid/hid-core.c                           |   13 +
 drivers/hwmon/mlxreg-fan.c                              |   12 +
 drivers/hwmon/pmbus/mp2975.c                            |    2 
 drivers/hwmon/tmp421.c                                  |   71 ++++----
 drivers/hwmon/w83791d.c                                 |   29 +--
 drivers/hwmon/w83792d.c                                 |   28 +--
 drivers/hwmon/w83793.c                                  |   26 +--
 drivers/infiniband/core/cma.c                           |   28 ++-
 drivers/infiniband/hw/hns/hns_roce_alloc.c              |    4 
 drivers/infiniband/hw/hns/hns_roce_cq.c                 |   35 ++--
 drivers/infiniband/hw/hns/hns_roce_hem.c                |   18 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c              |   30 +--
 drivers/infiniband/hw/hns/hns_roce_mr.c                 |   10 -
 drivers/infiniband/hw/hns/hns_roce_pd.c                 |    2 
 drivers/infiniband/hw/hns/hns_roce_qp.c                 |   61 ++++---
 drivers/infiniband/hw/hns/hns_roce_srq.c                |   37 ++--
 drivers/ipack/devices/ipoctal.c                         |   63 +++++--
 drivers/media/rc/ir_toy.c                               |   21 ++
 drivers/net/dsa/mv88e6xxx/chip.c                        |   17 +-
 drivers/net/dsa/mv88e6xxx/chip.h                        |    1 
 drivers/net/dsa/mv88e6xxx/global1.c                     |    2 
 drivers/net/dsa/mv88e6xxx/port.c                        |    2 
 drivers/net/ethernet/freescale/enetc/enetc_pf.c         |    3 
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c         |    5 
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c      |  105 ++++++++-----
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c  |    7 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c |   19 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c   |   52 +++---
 drivers/net/ethernet/intel/e100.c                       |   22 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c        |    2 
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c           |    8 
 drivers/net/ethernet/micrel/Makefile                    |    6 
 drivers/net/ethernet/micrel/ks8851_common.c             |    8 
 drivers/net/phy/bcm7xxx.c                               |  114 +++++++++++++-
 drivers/net/usb/hso.c                                   |    6 
 drivers/net/usb/smsc95xx.c                              |    3 
 drivers/net/wireless/mac80211_hwsim.c                   |    4 
 drivers/nvme/host/core.c                                |    4 
 drivers/nvme/host/nvme.h                                |    6 
 drivers/nvme/host/pci.c                                 |    3 
 drivers/scsi/csiostor/csio_init.c                       |    1 
 drivers/scsi/qla2xxx/qla_def.h                          |    1 
 drivers/scsi/qla2xxx/qla_isr.c                          |    2 
 drivers/scsi/qla2xxx/qla_nvme.c                         |   40 ++--
 drivers/scsi/ufs/ufshcd.c                               |    3 
 drivers/tty/vt/vt.c                                     |   21 ++
 drivers/usb/cdns3/gadget.c                              |   14 +
 fs/binfmt_elf.c                                         |    2 
 fs/debugfs/inode.c                                      |    2 
 fs/ext4/dir.c                                           |    6 
 fs/ext4/extents.c                                       |   19 +-
 fs/ext4/fast_commit.c                                   |    6 
 fs/ext4/inode.c                                         |    5 
 fs/ext4/super.c                                         |   16 +
 fs/verity/enable.c                                      |    2 
 fs/verity/open.c                                        |    2 
 include/linux/bpf.h                                     |    2 
 include/net/ip_fib.h                                    |    2 
 include/net/nexthop.h                                   |    2 
 include/net/sock.h                                      |    2 
 kernel/bpf/bpf_struct_ops.c                             |    7 
 kernel/bpf/core.c                                       |    2 
 kernel/entry/kvm.c                                      |    4 
 kernel/rseq.c                                           |   13 +
 kernel/sched/cpufreq_schedutil.c                        |   16 +
 mm/util.c                                               |    4 
 net/core/sock.c                                         |   32 +++
 net/ipv4/fib_semantics.c                                |   16 +
 net/ipv4/udp.c                                          |   10 -
 net/ipv6/route.c                                        |    5 
 net/ipv6/udp.c                                          |    2 
 net/mac80211/mesh_ps.c                                  |    3 
 net/mac80211/tx.c                                       |   12 +
 net/mac80211/wpa.c                                      |    6 
 net/mptcp/mptcp_diag.c                                  |    2 
 net/mptcp/protocol.h                                    |    2 
 net/mptcp/subflow.c                                     |    2 
 net/mptcp/syncookies.c                                  |   13 -
 net/mptcp/token.c                                       |   11 -
 net/mptcp/token_test.c                                  |   14 -
 net/netfilter/ipset/ip_set_hash_gen.h                   |    4 
 net/netfilter/ipvs/ip_vs_conn.c                         |    4 
 net/netfilter/nf_conntrack_core.c                       |   70 ++++----
 net/netfilter/nf_tables_api.c                           |    2 
 net/sched/cls_flower.c                                  |    6 
 net/sctp/input.c                                        |    2 
 net/unix/af_unix.c                                      |   34 +++-
 sound/pci/hda/patch_realtek.c                           |  129 ++++++++++++++++
 sound/soc/soc-dapm.c                                    |   13 +
 tools/testing/selftests/bpf/Makefile                    |    3 
 tools/testing/selftests/bpf/test_lwt_ip_encap.sh        |   13 -
 114 files changed, 1203 insertions(+), 563 deletions(-)

Aaro Koskinen (1):
      smsc95xx: fix stalled rx after link change

Andrea Claudi (1):
      ipvs: check that ip_vs_conn_tab_bits is between 8 and 20

Andrej Shadura (1):
      HID: u2fzero: ignore incomplete packets without data

Andrew Lunn (3):
      dsa: mv88e6xxx: 6161: Use chip wide MAX MTU
      dsa: mv88e6xxx: Fix MTU definition
      dsa: mv88e6xxx: Include tagger overhead when setting MTU for DSA and CPU ports

Andrey Gusakov (1):
      gpio: pca953x: do not ignore i2c errors

Anirudh Rayabharam (1):
      HID: usbhid: free raw_report buffers in usbhid_stop

Arnd Bergmann (1):
      net: ks8851: fix link error

Cameron Berkenpas (1):
      ALSA: hda/realtek: Quirks to enable speaker output for Lenovo Legion 7i 15IMHG05, Yoga 7i 14ITL5/15ITL5, and 13s Gen2 laptops.

Charlene Liu (1):
      drm/amd/display: Pass PCI deviceid into DC

Chen Jingwen (1):
      elf: don't use MAP_FIXED_NOREPLACE for elf interpreter mappings

Chih-Kang Chang (1):
      mac80211: Fix ieee80211_amsdu_aggregate frag_tail bug

Christoph Lameter (1):
      IB/cma: Do not send IGMP leaves for sendonly Multicast groups

Dan Carpenter (1):
      crypto: ccp - fix resource leaks in ccp_run_aes_gcm_cmd()

Dongliang Mu (1):
      usb: hso: remove the bailout parameter

Eric Biggers (1):
      fs-verity: fix signed integer overflow with i_size near S64_MAX

Eric Dumazet (3):
      af_unix: fix races in sk_peer_pid and sk_peer_cred accesses
      net: udp: annotate data race around udp_sk(sk)->corkflag
      netfilter: conntrack: serialize hash resizes and cleanups

F.A.Sulaiman (1):
      HID: betop: fix slab-out-of-bounds Write in betop_probe

Feng Zhou (1):
      ixgbe: Fix NULL pointer dereference in ixgbe_xdp_setup

Florian Fainelli (1):
      net: phy: bcm7xxx: Fixed indirect MMD operations

Florian Westphal (1):
      mptcp: don't return sockets in foreign netns

Greg Kroah-Hartman (1):
      Linux 5.10.71

Guangbin Huang (1):
      net: hns3: fix always enable rx vlan filter problem after selftest

Haimin Zhang (1):
      KVM: x86: Handle SRCU initialization failure during page track init

Hawking Zhang (1):
      drm/amdgpu: correct initial cp_hqd_quantum for gfx9

Hou Tao (2):
      bpf: Handle return value of BPF_PROG_TYPE_STRUCT_OPS prog
      ext4: limit the number of blocks in one ADD_RANGE TLV

Huazhong Tan (1):
      net: hns3: fix prototype warning

Igor Matheus Andrade Torrente (1):
      tty: Fix out-of-bound vmalloc access in imageblit

Jacob Keller (2):
      e100: fix length calculation in e100_get_regs_len
      e100: fix buffer overrun in e100_get_regs

James Morse (1):
      cpufreq: schedutil: Destroy mutex before kobject_put() frees the memory

Jason Gunthorpe (1):
      RDMA/cma: Do not change route.addr.src_addr.ss_family

Jeffle Xu (1):
      ext4: fix reserved space counter leakage

Jens Axboe (1):
      Revert "block, bfq: honor already-setup queue merges"

Jia He (1):
      ACPI: NFIT: Use fallback node id when numa info in NFIT table is incorrect

Jian Shen (3):
      net: hns3: do not allow call hns3_nic_net_open repeatedly
      net: hns3: fix mixed flag HCLGE_FLAG_MQPRIO_ENABLE and HCLGE_FLAG_DCB_ENABLE
      net: hns3: fix show wrong state when add existing uc mac address

Jiri Benc (2):
      selftests, bpf: Fix makefile dependencies on libbpf
      selftests, bpf: test_lwt_ip_encap: Really disable rp_filter

Johan Hovold (5):
      ipack: ipoctal: fix stack information leak
      ipack: ipoctal: fix tty registration race
      ipack: ipoctal: fix tty-registration error handling
      ipack: ipoctal: fix missing allocation-failure check
      ipack: ipoctal: fix module reference leak

Johannes Berg (3):
      mac80211: fix use-after-free in CCMP/GCMP RX
      mac80211: mesh: fix potentially unaligned access
      mac80211-hwsim: fix late beacon hrtimer handling

Jonathan Hsu (1):
      scsi: ufs: Fix illegal offset in UPIU event trace

Jozsef Kadlecsik (1):
      netfilter: ipset: Fix oversized kvmalloc() calls

Kan Liang (1):
      perf/x86/intel: Update event constraints for ICX

Keith Busch (1):
      nvme: add command id quirk for apple controllers

Kevin Hao (1):
      cpufreq: schedutil: Use kobject release() method to free sugov_tunables

Linus Torvalds (1):
      mm: don't allow oversized kvmalloc() calls

Lorenz Bauer (1):
      bpf: Exempt CAP_BPF from checks against bpf_jit_limit

Lorenzo Bianconi (1):
      mac80211: limit injected vht mcs/nss in ieee80211_parse_tx_radiotap

Matthew Auld (1):
      drm/i915/request: fix early tracepoints

Maxim Levitsky (1):
      KVM: x86: nSVM: don't copy virt_ext from vmcb12

Nadezda Lutovinova (3):
      hwmon: (w83793) Fix NULL pointer dereference by removing unnecessary structure field
      hwmon: (w83792d) Fix NULL pointer dereference by removing unnecessary structure field
      hwmon: (w83791d) Fix NULL pointer dereference by removing unnecessary structure field

Nirmoy Das (1):
      debugfs: debugfs_create_file_size(): use IS_ERR to check for error

Pablo Neira Ayuso (1):
      netfilter: nf_tables: Fix oversized kvmalloc() calls

Paul Fertser (3):
      hwmon: (tmp421) handle I2C errors
      hwmon: (tmp421) report /PVLD condition as fault
      hwmon: (tmp421) fix rounding for negative values

Pawel Laszczak (1):
      usb: cdns3: fix race condition before setting doorbell

Peng Li (1):
      net: hns3: reconstruct function hns3_self_test

Piotr Krysiuk (1):
      bpf, mips: Validate conditional branch offsets

Rahul Lakkireddy (1):
      scsi: csiostor: Add module softdep on cxgb4

Ritesh Harjani (1):
      ext4: fix loff_t overflow in ext4_max_bitmap_size()

Saurav Kashyap (1):
      scsi: qla2xxx: Changes to support kdump kernel for NVMe BFS

Sean Christopherson (1):
      KVM: rseq: Update rseq when processing NOTIFY_RESUME on xfer to KVM guest

Sean Young (1):
      media: ir_toy: prevent device from hanging during transmit

Shuming Fan (1):
      ASoC: dapm: use component prefix when checking widget names

Tao Liu (1):
      RDMA/cma: Fix listener leak in rdma_cma_listen_on_all() failure

Theodore Ts'o (1):
      ext4: add error checking to ext4_ext_replay_set_iblocks()

Vadim Pasternak (2):
      hwmon: (mlxreg-fan) Return non-zero value when fan current state is enforced from sysfs
      hwmon: (pmbus/mp2975) Add missed POUT attribute for page 1 mp2975 controller

Vitaly Kuznetsov (2):
      KVM: x86: Fix stack-out-of-bounds memory access from ioapic_write_indirect()
      KVM: nVMX: Filter out all unsupported controls when eVMCS was activated

Vlad Buslov (1):
      net: sched: flower: protect fl_walk() with rcu

Vladimir Oltean (1):
      net: enetc: fix the incorrect clearing of IF_MODE bits

Xiao Liang (1):
      net: ipv4: Fix rtnexthop len when RTA_FLOW is present

Xin Long (1):
      sctp: break out if skb_header_pointer returns NULL in sctp_rcv_ootb

Yixing Liu (1):
      RDMA/hns: Fix inaccurate prints

Yonglong Liu (1):
      net: hns3: keep MAC pause mode when multiple TCs are enabled

Zelin Deng (1):
      x86/kvmclock: Move this_cpu_pvti into kvmclock.h

yangerkun (1):
      ext4: fix potential infinite loop in ext4_dx_readdir()

