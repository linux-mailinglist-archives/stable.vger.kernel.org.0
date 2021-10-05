Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6334220F0
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 10:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232919AbhJEIk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 04:40:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:51088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233329AbhJEIkR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 04:40:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97F516120C;
        Tue,  5 Oct 2021 08:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633423107;
        bh=nVwBWkl/b1iUIlFVQ4w1cjap3ghUFk3YeF15xKSdMtI=;
        h=From:To:Cc:Subject:Date:From;
        b=CzpBYvODxErKfmAQZIS0GHVyTDlBxlp1tMgnmlkmhVnYZVjA1YtE21S8ULr/L7Phx
         ilQ/AYb0bnnAEz5rBba7ukOkC3rLzgv+aGy0ldG/NfJLeC9k4v3YAmKhSJmmbQbGjJ
         EBE0rTkxEh5X/TvgcGCpIfsGJ5JNV0EZz5Y2JxhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/53] 5.4.151-rc2 review
Date:   Tue,  5 Oct 2021 10:38:25 +0200
Message-Id: <20211005083256.183739807@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.151-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.151-rc2
X-KernelTest-Deadline: 2021-10-07T08:32+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.151 release.
There are 53 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.151-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.151-rc2

Anirudh Rayabharam <mail@anirudhrb.com>
    HID: usbhid: free raw_report buffers in usbhid_stop

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: Fix oversized kvmalloc() calls

F.A.Sulaiman <asha.16@itfac.mrt.ac.lk>
    HID: betop: fix slab-out-of-bounds Write in betop_probe

Dan Carpenter <dan.carpenter@oracle.com>
    crypto: ccp - fix resource leaks in ccp_run_aes_gcm_cmd()

Dongliang Mu <mudongliangabcd@gmail.com>
    usb: hso: remove the bailout parameter

Dongliang Mu <mudongliangabcd@gmail.com>
    usb: hso: fix error handling code of hso_create_net_device

Oliver Neukum <oneukum@suse.com>
    hso: fix bailout in error case of probe

sumiyawang <sumiyawang@tencent.com>
    libnvdimm/pmem: Fix crash triggered when I/O in-flight during unbind

Rob Herring <robh@kernel.org>
    PCI: Fix pci_host_bridge struct device release/free handling

Leon Yu <leoyu@nvidia.com>
    net: stmmac: don't attach interface until resume finishes

Eric Dumazet <edumazet@google.com>
    net: udp: annotate data race around udp_sk(sk)->corkflag

Andrej Shadura <andrew.shadura@collabora.co.uk>
    HID: u2fzero: ignore incomplete packets without data

yangerkun <yangerkun@huawei.com>
    ext4: fix potential infinite loop in ext4_dx_readdir()

Jeffle Xu <jefflexu@linux.alibaba.com>
    ext4: fix reserved space counter leakage

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

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Update event constraints for ICX

Eric Dumazet <edumazet@google.com>
    af_unix: fix races in sk_peer_pid and sk_peer_cred accesses

Vlad Buslov <vladbu@nvidia.com>
    net: sched: flower: protect fl_walk() with rcu

Jian Shen <shenjian15@huawei.com>
    net: hns3: do not allow call hns3_nic_net_open repeatedly

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    scsi: csiostor: Add module softdep on cxgb4

Jens Axboe <axboe@kernel.dk>
    Revert "block, bfq: honor already-setup queue merges"

Jiri Benc <jbenc@redhat.com>
    selftests, bpf: test_lwt_ip_encap: Really disable rp_filter

Jacob Keller <jacob.e.keller@intel.com>
    e100: fix buffer overrun in e100_get_regs

Jacob Keller <jacob.e.keller@intel.com>
    e100: fix length calculation in e100_get_regs_len

Xiao Liang <shaw.leon@gmail.com>
    net: ipv4: Fix rtnexthop len when RTA_FLOW is present

Paul Fertser <fercerpav@gmail.com>
    hwmon: (tmp421) fix rounding for negative values

Paul Fertser <fercerpav@gmail.com>
    hwmon: (tmp421) report /PVLD condition as fault

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

Andrea Claudi <aclaudi@redhat.com>
    ipvs: check that ip_vs_conn_tab_bits is between 8 and 20

Charlene Liu <Charlene.Liu@amd.com>
    drm/amd/display: Pass PCI deviceid into DC

Zelin Deng <zelin.deng@linux.alibaba.com>
    x86/kvmclock: Move this_cpu_pvti into kvmclock.h

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix use-after-free in CCMP/GCMP RX

Jonathan Hsu <jonathan.hsu@mediatek.com>
    scsi: ufs: Fix illegal offset in UPIU event trace

Nadezda Lutovinova <lutovinova@ispras.ru>
    hwmon: (w83791d) Fix NULL pointer dereference by removing unnecessary structure field

Nadezda Lutovinova <lutovinova@ispras.ru>
    hwmon: (w83792d) Fix NULL pointer dereference by removing unnecessary structure field

Nadezda Lutovinova <lutovinova@ispras.ru>
    hwmon: (w83793) Fix NULL pointer dereference by removing unnecessary structure field

Eric Biggers <ebiggers@google.com>
    fs-verity: fix signed integer overflow with i_size near S64_MAX

Pawel Laszczak <pawell@cadence.com>
    usb: cdns3: fix race condition before setting doorbell

James Morse <james.morse@arm.com>
    cpufreq: schedutil: Destroy mutex before kobject_put() frees the memory

Kevin Hao <haokexin@gmail.com>
    cpufreq: schedutil: Use kobject release() method to free sugov_tunables

Igor Matheus Andrade Torrente <igormtorrente@gmail.com>
    tty: Fix out-of-bound vmalloc access in imageblit


-------------

Diffstat:

 Makefile                                          |  4 +-
 arch/x86/events/intel/core.c                      |  1 +
 arch/x86/include/asm/kvmclock.h                   | 14 +++++
 arch/x86/kernel/kvmclock.c                        | 13 +----
 block/bfq-iosched.c                               | 16 ++----
 drivers/cpufreq/cpufreq_governor_attr_set.c       |  2 +-
 drivers/crypto/ccp/ccp-ops.c                      | 14 ++---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  1 +
 drivers/hid/hid-betopff.c                         | 13 +++--
 drivers/hid/hid-u2fzero.c                         |  4 +-
 drivers/hid/usbhid/hid-core.c                     | 13 ++++-
 drivers/hwmon/mlxreg-fan.c                        | 12 +++--
 drivers/hwmon/tmp421.c                            | 33 ++++--------
 drivers/hwmon/w83791d.c                           | 29 ++++-------
 drivers/hwmon/w83792d.c                           | 28 ++++------
 drivers/hwmon/w83793.c                            | 26 ++++------
 drivers/ipack/devices/ipoctal.c                   | 63 +++++++++++++++++------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c   |  5 ++
 drivers/net/ethernet/intel/e100.c                 | 22 +++++---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  4 +-
 drivers/net/usb/hso.c                             | 33 ++++++++----
 drivers/net/wireless/mac80211_hwsim.c             |  4 +-
 drivers/nvdimm/pmem.c                             |  4 +-
 drivers/pci/probe.c                               | 36 +++++++------
 drivers/pci/remove.c                              |  2 +-
 drivers/scsi/csiostor/csio_init.c                 |  1 +
 drivers/scsi/ufs/ufshcd.c                         |  3 +-
 drivers/tty/vt/vt.c                               | 21 +++++++-
 drivers/usb/cdns3/gadget.c                        | 14 +++++
 fs/binfmt_elf.c                                   |  2 +-
 fs/debugfs/inode.c                                |  2 +-
 fs/ext4/dir.c                                     |  6 +--
 fs/ext4/inode.c                                   |  5 ++
 fs/ext4/super.c                                   | 16 ++++--
 fs/verity/enable.c                                |  2 +-
 fs/verity/open.c                                  |  2 +-
 include/net/ip_fib.h                              |  2 +-
 include/net/nexthop.h                             |  2 +-
 include/net/sock.h                                |  2 +
 kernel/sched/cpufreq_schedutil.c                  | 16 ++++--
 net/core/sock.c                                   | 32 +++++++++---
 net/ipv4/fib_semantics.c                          | 16 +++---
 net/ipv4/udp.c                                    | 10 ++--
 net/ipv6/route.c                                  |  5 +-
 net/ipv6/udp.c                                    |  2 +-
 net/mac80211/mesh_ps.c                            |  3 +-
 net/mac80211/tx.c                                 | 12 +++++
 net/mac80211/wpa.c                                |  6 +++
 net/netfilter/ipset/ip_set_hash_gen.h             |  4 +-
 net/netfilter/ipvs/ip_vs_conn.c                   |  4 ++
 net/sched/cls_flower.c                            |  6 +++
 net/sctp/input.c                                  |  2 +-
 net/unix/af_unix.c                                | 34 +++++++++---
 tools/testing/selftests/bpf/test_lwt_ip_encap.sh  | 13 +++--
 54 files changed, 412 insertions(+), 229 deletions(-)


