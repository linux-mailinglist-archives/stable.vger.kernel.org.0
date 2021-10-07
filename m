Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5B4424D1C
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 08:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237220AbhJGGPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 02:15:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231190AbhJGGPB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Oct 2021 02:15:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA9D76113E;
        Thu,  7 Oct 2021 06:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633587188;
        bh=hoWcbKmCee+tZccYlHHSWMaGw5WawKbGfcdUeTIX9WA=;
        h=From:To:Cc:Subject:Date:From;
        b=EhCHat5bA1sz4tPajUgD+FRA22boCE0d4btyH3JO5jo3PK7QeG5XZhlO3lTy4a5iZ
         Cs2csC/EmFqfkd8hiq+ta9WT5TwEzBW7EL+XfU0FpEVhPqQWFiaNPbzWGqKEMHEHWz
         AfjdiAZeWOCu2uiJ/iz//rq7FbKyvSmCW6K1Xo4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.14.10
Date:   Thu,  7 Oct 2021 08:13:05 +0200
Message-Id: <163358718522341@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.14.10 kernel.

All users of the 5.14 kernel series must upgrade.

The updated 5.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 
 arch/m68k/kernel/entry.S                                |    2 
 arch/mips/net/bpf_jit.c                                 |   57 +++++--
 arch/nios2/Kconfig.debug                                |    3 
 arch/nios2/kernel/setup.c                               |    2 
 arch/s390/include/asm/ccwgroup.h                        |    2 
 arch/x86/crypto/aesni-intel_glue.c                      |    2 
 arch/x86/events/intel/core.c                            |    1 
 arch/x86/include/asm/kvm_page_track.h                   |    2 
 arch/x86/include/asm/kvmclock.h                         |   14 +
 arch/x86/kernel/kvmclock.c                              |   13 -
 arch/x86/kvm/cpuid.c                                    |    4 
 arch/x86/kvm/emulate.c                                  |    1 
 arch/x86/kvm/ioapic.c                                   |   10 -
 arch/x86/kvm/mmu/page_track.c                           |    4 
 arch/x86/kvm/svm/nested.c                               |    1 
 arch/x86/kvm/svm/sev.c                                  |   92 +++++++----
 arch/x86/kvm/vmx/evmcs.c                                |   12 +
 arch/x86/kvm/vmx/nested.c                               |    6 
 arch/x86/kvm/vmx/vmx.c                                  |   11 -
 arch/x86/kvm/x86.c                                      |   10 +
 arch/x86/net/bpf_jit_comp.c                             |   66 +++++---
 block/bfq-iosched.c                                     |   16 -
 drivers/acpi/nfit/core.c                                |   12 +
 drivers/base/core.c                                     |   36 +++-
 drivers/block/nbd.c                                     |   29 ++-
 drivers/cpufreq/cpufreq_governor_attr_set.c             |    2 
 drivers/crypto/ccp/ccp-ops.c                            |   14 -
 drivers/gpio/gpio-pca953x.c                             |   11 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c              |   15 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c             |   31 +++
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c               |   62 ++-----
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h                |    9 -
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c                   |    2 
 drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c                  |    8 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c       |    2 
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c        |   15 -
 drivers/gpu/drm/i915/gt/intel_rps.c                     |    2 
 drivers/gpu/drm/i915/gvt/scheduler.c                    |    4 
 drivers/gpu/drm/i915/i915_request.c                     |   11 -
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c                  |    8 
 drivers/hid/hid-betopff.c                               |   13 +
 drivers/hid/hid-u2fzero.c                               |    4 
 drivers/hid/usbhid/hid-core.c                           |   13 +
 drivers/hwmon/mlxreg-fan.c                              |   12 +
 drivers/hwmon/occ/common.c                              |   17 --
 drivers/hwmon/pmbus/mp2975.c                            |    2 
 drivers/hwmon/tmp421.c                                  |   71 ++++----
 drivers/hwmon/w83791d.c                                 |   29 +--
 drivers/hwmon/w83792d.c                                 |   28 +--
 drivers/hwmon/w83793.c                                  |   26 +--
 drivers/infiniband/core/cma.c                           |   51 +++++-
 drivers/infiniband/core/cma_priv.h                      |    1 
 drivers/infiniband/hw/hfi1/ipoib_tx.c                   |    8 
 drivers/infiniband/hw/hns/hns_roce_cq.c                 |   31 ++-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c              |   13 -
 drivers/infiniband/hw/irdma/cm.c                        |    4 
 drivers/infiniband/hw/irdma/hw.c                        |   14 +
 drivers/infiniband/hw/irdma/i40iw_if.c                  |    2 
 drivers/infiniband/hw/irdma/main.h                      |    1 
 drivers/infiniband/hw/irdma/user.h                      |    2 
 drivers/infiniband/hw/irdma/utils.c                     |    2 
 drivers/infiniband/hw/irdma/verbs.c                     |    9 -
 drivers/interconnect/qcom/sdm660.c                      |   11 -
 drivers/ipack/devices/ipoctal.c                         |   63 +++++--
 drivers/media/platform/s5p-jpeg/jpeg-core.c             |   18 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.h             |   28 +--
 drivers/media/rc/ir_toy.c                               |   21 ++
 drivers/mmc/host/renesas_sdhi_core.c                    |    2 
 drivers/net/dsa/mv88e6xxx/chip.c                        |   17 +-
 drivers/net/dsa/mv88e6xxx/chip.h                        |    1 
 drivers/net/dsa/mv88e6xxx/global1.c                     |    2 
 drivers/net/dsa/mv88e6xxx/port.c                        |    2 
 drivers/net/ethernet/freescale/enetc/enetc_pf.c         |    3 
 drivers/net/ethernet/hisilicon/hns3/hnae3.h             |    1 
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c         |   16 -
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c      |  105 ++++++++-----
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c  |   21 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c  |   29 +--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c |   19 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c   |   33 ----
 drivers/net/ethernet/intel/e100.c                       |   22 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c        |    2 
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c           |    8 
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c          |   47 +++--
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h            |    1 
 drivers/net/ethernet/micrel/Makefile                    |    6 
 drivers/net/ethernet/micrel/ks8851_common.c             |    8 
 drivers/net/ethernet/pensando/ionic/ionic_stats.c       |    9 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c       |    4 
 drivers/net/mhi/net.c                                   |    6 
 drivers/net/phy/bcm7xxx.c                               |  114 +++++++++++++-
 drivers/net/phy/mdio_bus.c                              |    4 
 drivers/net/usb/hso.c                                   |    6 
 drivers/net/usb/smsc95xx.c                              |    3 
 drivers/net/wireless/mac80211_hwsim.c                   |    4 
 drivers/nvme/host/core.c                                |    4 
 drivers/nvme/host/nvme.h                                |    6 
 drivers/nvme/host/pci.c                                 |    3 
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c                |   37 ++++
 drivers/platform/x86/intel-hid.c                        |   27 ++-
 drivers/ptp/ptp_kvm_x86.c                               |    9 -
 drivers/s390/cio/ccwgroup.c                             |   10 -
 drivers/s390/net/qeth_core.h                            |    1 
 drivers/s390/net/qeth_core_main.c                       |   19 --
 drivers/s390/net/qeth_l2_main.c                         |    1 
 drivers/s390/net/qeth_l3_main.c                         |    1 
 drivers/scsi/csiostor/csio_init.c                       |    1 
 drivers/scsi/elx/libefc/efc_device.c                    |    7 
 drivers/scsi/elx/libefc/efc_fabric.c                    |    3 
 drivers/scsi/qla2xxx/qla_def.h                          |    1 
 drivers/scsi/qla2xxx/qla_isr.c                          |    2 
 drivers/scsi/qla2xxx/qla_nvme.c                         |   40 ++--
 drivers/scsi/ufs/ufshcd-pci.c                           |   78 +++++++++
 drivers/scsi/ufs/ufshcd.c                               |    6 
 drivers/scsi/ufs/ufshcd.h                               |    1 
 drivers/staging/media/hantro/hantro_drv.c               |    2 
 drivers/staging/media/sunxi/cedrus/cedrus_video.c       |    2 
 drivers/tty/vt/vt.c                                     |   21 ++
 drivers/watchdog/Kconfig                                |    2 
 fs/binfmt_elf.c                                         |    2 
 fs/debugfs/inode.c                                      |    2 
 fs/ext4/dir.c                                           |    6 
 fs/ext4/extents.c                                       |   19 +-
 fs/ext4/fast_commit.c                                   |    6 
 fs/ext4/inode.c                                         |    5 
 fs/ext4/super.c                                         |   21 +-
 fs/verity/enable.c                                      |    2 
 fs/verity/open.c                                        |    2 
 include/linux/bpf.h                                     |    2 
 include/linux/fwnode.h                                  |   11 -
 include/net/ip_fib.h                                    |    2 
 include/net/nexthop.h                                   |    2 
 include/net/sock.h                                      |    2 
 include/sound/rawmidi.h                                 |    1 
 include/uapi/sound/asound.h                             |    1 
 kernel/bpf/bpf_struct_ops.c                             |    7 
 kernel/bpf/core.c                                       |    2 
 kernel/sched/cpufreq_schedutil.c                        |   16 +
 kernel/sched/debug.c                                    |    8 
 kernel/sched/fair.c                                     |    6 
 lib/Kconfig.kasan                                       |    2 
 mm/util.c                                               |    4 
 net/core/sock.c                                         |   32 +++
 net/ipv4/fib_semantics.c                                |   16 +
 net/ipv4/udp.c                                          |   10 -
 net/ipv6/route.c                                        |    5 
 net/ipv6/udp.c                                          |    2 
 net/mac80211/mesh_ps.c                                  |    3 
 net/mac80211/rate.c                                     |    4 
 net/mac80211/tx.c                                       |   12 +
 net/mac80211/wpa.c                                      |    6 
 net/mptcp/mptcp_diag.c                                  |    2 
 net/mptcp/pm_netlink.c                                  |    4 
 net/mptcp/protocol.h                                    |    2 
 net/mptcp/subflow.c                                     |    2 
 net/mptcp/syncookies.c                                  |   13 -
 net/mptcp/token.c                                       |   11 -
 net/mptcp/token_test.c                                  |   14 -
 net/netfilter/ipset/ip_set_hash_gen.h                   |    4 
 net/netfilter/ipvs/ip_vs_conn.c                         |    4 
 net/netfilter/nf_conntrack_core.c                       |   70 ++++----
 net/netfilter/nf_tables_api.c                           |   30 ++-
 net/netfilter/nft_compat.c                              |   17 +-
 net/netfilter/xt_LOG.c                                  |   10 +
 net/netfilter/xt_NFLOG.c                                |   10 +
 net/sched/cls_flower.c                                  |    6 
 net/sctp/input.c                                        |    2 
 net/unix/af_unix.c                                      |   34 +++-
 sound/core/rawmidi.c                                    |    9 +
 sound/firewire/motu/amdtp-motu.c                        |    7 
 sound/pci/hda/patch_realtek.c                           |  129 ++++++++++++++++
 sound/soc/fsl/fsl_esai.c                                |   16 +
 sound/soc/fsl/fsl_micfil.c                              |   15 +
 sound/soc/fsl/fsl_sai.c                                 |   14 +
 sound/soc/fsl/fsl_spdif.c                               |   14 +
 sound/soc/fsl/fsl_xcvr.c                                |   15 +
 sound/soc/mediatek/common/mtk-afe-fe-dai.c              |   19 +-
 sound/soc/sof/imx/imx8.c                                |    9 -
 sound/soc/sof/imx/imx8m.c                               |    9 -
 sound/soc/sof/xtensa/core.c                             |    4 
 tools/lib/bpf/linker.c                                  |    8 
 tools/objtool/special.c                                 |   38 +++-
 tools/perf/arch/x86/util/iostat.c                       |    2 
 tools/perf/builtin-stat.c                               |    2 
 tools/perf/tests/dwarf-unwind.c                         |   39 +++-
 tools/testing/selftests/bpf/Makefile                    |    3 
 tools/testing/selftests/bpf/test_lwt_ip_encap.sh        |   13 -
 188 files changed, 1839 insertions(+), 861 deletions(-)

Aaro Koskinen (1):
      smsc95xx: fix stalled rx after link change

Adrian Hunter (1):
      scsi: ufs: ufs-pci: Fix Intel LKF link stability

Al Viro (1):
      m68k: Update ->thread.esp0 before calling syscall_trace() in ret_from_signal

Alexandra Winter (2):
      s390/qeth: Fix deadlock in remove_discipline
      s390/qeth: fix deadlock during failing recovery

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

Basavaraj Natikar (1):
      HID: amd_sfh: Fix potential NULL pointer dereference - take 2

Cameron Berkenpas (1):
      ALSA: hda/realtek: Quirks to enable speaker output for Lenovo Legion 7i 15IMHG05, Yoga 7i 14ITL5/15ITL5, and 13s Gen2 laptops.

Charlene Liu (1):
      drm/amd/display: Pass PCI deviceid into DC

Chen Jingwen (1):
      elf: don't use MAP_FIXED_NOREPLACE for elf interpreter mappings

Chenyi Qiang (1):
      KVM: nVMX: Fix nested bus lock VM exit

Chih-Kang Chang (1):
      mac80211: Fix ieee80211_amsdu_aggregate frag_tail bug

Christoph Lameter (1):
      IB/cma: Do not send IGMP leaves for sendonly Multicast groups

Dan Carpenter (1):
      crypto: ccp - fix resource leaks in ccp_run_aes_gcm_cmd()

Daniele Palmas (1):
      drivers: net: mhi: fix error path in mhi_net_newlink

David Collins (1):
      pinctrl: qcom: spmi-gpio: correct parent irqspec translation

Davide Caratti (1):
      mptcp: allow changing the 'backup' bit when no sockets are open

Dongliang Mu (1):
      usb: hso: remove the bailout parameter

Eddie James (1):
      hwmon: (occ) Fix P10 VRM temp sensors

Eric Biggers (1):
      fs-verity: fix signed integer overflow with i_size near S64_MAX

Eric Dumazet (3):
      af_unix: fix races in sk_peer_pid and sk_peer_cred accesses
      net: udp: annotate data race around udp_sk(sk)->corkflag
      netfilter: conntrack: serialize hash resizes and cleanups

Evgeny Novikov (1):
      HID: amd_sfh: Fix potential NULL pointer dereference

F.A.Sulaiman (1):
      HID: betop: fix slab-out-of-bounds Write in betop_probe

Felix Fietkau (1):
      Revert "mac80211: do not use low data rates for data frames with no ack flag"

Feng Zhou (1):
      ixgbe: Fix NULL pointer dereference in ixgbe_xdp_setup

Florian Fainelli (1):
      net: phy: bcm7xxx: Fixed indirect MMD operations

Florian Westphal (3):
      netfilter: nf_tables: unlink table before deleting it
      netfilter: log: work around missing softdep backend module
      mptcp: don't return sockets in foreign netns

Greg Kroah-Hartman (1):
      Linux 5.14.10

Guangbin Huang (2):
      net: hns3: fix always enable rx vlan filter problem after selftest
      net: hns3: disable firmware compatible features when uninstall PF

Guchun Chen (2):
      drm/amdgpu: avoid over-handle of fence driver fini in s3 test (v2)
      drm/amdgpu: stop scheduler when calling hw_fini (v2)

Guo Zhi (1):
      RDMA/hfi1: Fix kernel pointer leak

Haimin Zhang (1):
      KVM: x86: Handle SRCU initialization failure during page track init

Hawking Zhang (1):
      drm/amdgpu: correct initial cp_hqd_quantum for gfx9

Hou Tao (2):
      bpf: Handle return value of BPF_PROG_TYPE_STRUCT_OPS prog
      ext4: limit the number of blocks in one ADD_RANGE TLV

Ian Rogers (1):
      perf test: Fix DWARF unwind for optimized builds.

Igor Matheus Andrade Torrente (1):
      tty: Fix out-of-bound vmalloc access in imageblit

Jackie Liu (1):
      watchdog/sb_watchdog: fix compilation problem due to COMPILE_TEST

Jacob Keller (2):
      e100: fix length calculation in e100_get_regs_len
      e100: fix buffer overrun in e100_get_regs

James Morse (1):
      cpufreq: schedutil: Destroy mutex before kobject_put() frees the memory

James Smart (1):
      scsi: elx: efct: Fix void-pointer-to-enum-cast warning for efc_nport_topology

Jaroslav Kysela (1):
      ALSA: rawmidi: introduce SNDRV_RAWMIDI_IOCTL_USER_PVERSION

Jason Gunthorpe (3):
      RDMA/cma: Do not change route.addr.src_addr.ss_family
      RDMA/cma: Ensure rdma_addr_cancel() happens before issuing more requests
      RDMA/hns: Work around broken constant propagation in gcc 8

Jeffle Xu (1):
      ext4: fix reserved space counter leakage

Jens Axboe (1):
      Revert "block, bfq: honor already-setup queue merges"

Jernej Skrabec (1):
      media: hantro: Fix check for single irq

Jia He (1):
      ACPI: NFIT: Use fallback node id when numa info in NFIT table is incorrect

Jian Shen (5):
      net: hns3: do not allow call hns3_nic_net_open repeatedly
      net: hns3: remove tc enable checking
      net: hns3: don't rollback when destroy mqprio fail
      net: hns3: fix mixed flag HCLGE_FLAG_MQPRIO_ENABLE and HCLGE_FLAG_DCB_ENABLE
      net: hns3: fix show wrong state when add existing uc mac address

Jiri Benc (2):
      selftests, bpf: Fix makefile dependencies on libbpf
      selftests, bpf: test_lwt_ip_encap: Really disable rp_filter

Johan Almbladh (1):
      bpf, x86: Fix bpf mapping of atomic fetch implementation

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

Josip Pavic (1):
      drm/amd/display: initialize backlight_ramping_override to false

José Expósito (1):
      platform/x86/intel: hid: Add DMI switches allow list

Jozsef Kadlecsik (1):
      netfilter: ipset: Fix oversized kvmalloc() calls

Kan Liang (1):
      perf/x86/intel: Update event constraints for ICX

Keith Busch (1):
      nvme: add command id quirk for apple controllers

Kevin Hao (1):
      cpufreq: schedutil: Use kobject release() method to free sugov_tunables

Kumar Kartikeya Dwivedi (1):
      libbpf: Fix segfault in static linker for objects without BTF

Lama Kayal (1):
      net/mlx4_en: Resolve bad operstate value

Like Xu (2):
      perf iostat: Use system-wide mode if the target cpu_list is unspecified
      perf iostat: Fix Segmentation fault from NULL 'struct perf_counts_values *'

Likun Gao (1):
      drm/amdgpu: adjust fence driver enable sequence

Linus Torvalds (3):
      kvm: fix objtool relocation warning
      mm: don't allow oversized kvmalloc() calls
      objtool: print out the symbol type when complaining about it

Lorenz Bauer (1):
      bpf: Exempt CAP_BPF from checks against bpf_jit_limit

Lorenzo Bianconi (1):
      mac80211: limit injected vht mcs/nss in ieee80211_parse_tx_radiotap

Marco Elver (1):
      kasan: fix Kconfig check of CC_HAS_WORKING_NOSANITIZE_ADDRESS

Matthew Auld (1):
      drm/i915/request: fix early tracepoints

Maxim Levitsky (1):
      KVM: x86: nSVM: don't copy virt_ext from vmcb12

Mel Gorman (1):
      sched/fair: Null terminate buffer when updating tunable_scaling

Michal Koutný (1):
      sched/fair: Add ancestors of unthrottled undecayed cfs_rq

Mingwei Zhang (1):
      KVM: SVM: fix missing sev_decommission in sev_receive_start

Nadezda Lutovinova (3):
      hwmon: (w83793) Fix NULL pointer dereference by removing unnecessary structure field
      hwmon: (w83792d) Fix NULL pointer dereference by removing unnecessary structure field
      hwmon: (w83791d) Fix NULL pointer dereference by removing unnecessary structure field

Nick Desaulniers (1):
      nbd: use shifts rather than multiplies

Nicolas Dufresne (1):
      media: cedrus: Fix SUNXI tile size calculation

Nirmoy Das (1):
      debugfs: debugfs_create_file_size(): use IS_ERR to check for error

Pablo Neira Ayuso (1):
      netfilter: nf_tables: Fix oversized kvmalloc() calls

Paul Fertser (3):
      hwmon: (tmp421) handle I2C errors
      hwmon: (tmp421) report /PVLD condition as fault
      hwmon: (tmp421) fix rounding for negative values

Peng Li (1):
      net: hns3: reconstruct function hns3_self_test

Peter Gonda (3):
      KVM: SEV: Update svm_vm_copy_asid_from for SEV-ES
      KVM: SEV: Acquire vcpu mutex when updating VMSA
      KVM: SEV: Allow some commands for mirror VM

Peter Ujfalusi (2):
      ASoC: SOF: imx: imx8: Bar index is only valid for IRAM and SRAM types
      ASoC: SOF: imx: imx8m: Bar index is only valid for IRAM and SRAM types

Peter Zijlstra (1):
      objtool: Teach get_alt_entry() about more relocation types

Piotr Krysiuk (1):
      bpf, mips: Validate conditional branch offsets

Praful Swarnakar (1):
      drm/amd/display: Fix Display Flicker on embedded panels

Prike Liang (1):
      drm/amdgpu: force exit gfxoff on sdma resume for rmb s0ix

Rahul Lakkireddy (1):
      scsi: csiostor: Add module softdep on cxgb4

Randy Dunlap (3):
      media: s5p-jpeg: rename JPEG marker constants to prevent build warnings
      NIOS2: fix kconfig unmet dependency warning for SERIAL_CORE_CONSOLE
      NIOS2: setup.c: drop unused variable 'dram_start'

Ritesh Harjani (1):
      ext4: fix loff_t overflow in ext4_max_bitmap_size()

Saravana Kannan (3):
      driver core: fw_devlink: Add support for FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD
      net: mdiobus: Set FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD for mdiobus parents
      driver core: fw_devlink: Improve handling of cyclic dependencies

Saurav Kashyap (1):
      scsi: qla2xxx: Changes to support kdump kernel for NVMe BFS

Sean Christopherson (3):
      KVM: x86: Clear KVM's cached guest CR3 at RESET/INIT
      KVM: x86: Swap order of CPUID entry "index" vs. "significant flag" checks
      KVM: SEV: Pin guest memory for write for RECEIVE_UPDATE_DATA

Sean Young (1):
      media: ir_toy: prevent device from hanging during transmit

Shannon Nelson (1):
      ionic: fix gathering of debug stats

Shawn Guo (2):
      interconnect: qcom: sdm660: Fix id of slv_cnoc_mnoc_cfg
      interconnect: qcom: sdm660: Correct NOC_QOS_PRIORITY shift and mask

Shengjiu Wang (5):
      ASoC: fsl_sai: register platform component before registering cpu dai
      ASoC: fsl_esai: register platform component before registering cpu dai
      ASoC: fsl_micfil: register platform component before registering cpu dai
      ASoC: fsl_spdif: register platform component before registering cpu dai
      ASoC: fsl_xcvr: register platform component before registering cpu dai

Shreyansh Chouhan (1):
      crypto: aesni - xts_crypt() return if walk.nbytes is 0

Simon Ser (1):
      drm/amdgpu: check tiling flags when creating FB on GFX8-

Sindhu Devale (4):
      RDMA/irdma: Skip CQP ring during a reset
      RDMA/irdma: Validate number of CQ entries on create CQ
      RDMA/irdma: Report correct WC error when transport retry counter is exceeded
      RDMA/irdma: Report correct WC error when there are MW bind errors

Takashi Sakamoto (1):
      ALSA: firewire-motu: fix truncated bytes in message tracepoints

Tao Liu (1):
      RDMA/cma: Fix listener leak in rdma_cma_listen_on_all() failure

Tejas Upadhyay (1):
      drm/i915: Remove warning from the rps worker

Theodore Ts'o (1):
      ext4: add error checking to ext4_ext_replay_set_iblocks()

Trevor Wu (1):
      ASoC: mediatek: common: handle NULL case in suspend/resume function

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

Wenpeng Liang (2):
      RDMA/hns: Fix the size setting error when copying CQE in clean_cq()
      RDMA/hns: Add the check of the CQE size of the user space

Wolfram Sang (1):
      mmc: renesas_sdhi: fix regression with hard reset on old SDHIs

Wong Vee Khee (1):
      net: stmmac: fix EEE init issue when paired with EEE capable PHYs

Xiao Liang (1):
      net: ipv4: Fix rtnexthop len when RTA_FLOW is present

Xin Long (1):
      sctp: break out if skb_header_pointer returns NULL in sctp_rcv_ootb

Yong Zhi (1):
      ASoC: SOF: Fix DSP oops stack dump output contents

Zelin Deng (2):
      x86/kvmclock: Move this_cpu_pvti into kvmclock.h
      ptp: Fix ptp_kvm_getcrosststamp issue for x86 ptp_kvm

Zhenzhong Duan (1):
      KVM: VMX: Fix a TSX_CTRL_CPUID_CLEAR field mask issue

Zhi A Wang (1):
      drm/i915/gvt: fix the usage of ww lock in gvt scheduler.

yangerkun (2):
      ext4: fix potential infinite loop in ext4_dx_readdir()
      ext4: flush s_error_work before journal destroy in ext4_fill_super

