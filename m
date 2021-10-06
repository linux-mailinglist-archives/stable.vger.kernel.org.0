Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12625423FBB
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 16:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238706AbhJFOE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 10:04:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:57860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231716AbhJFOEV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 10:04:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 851476103E;
        Wed,  6 Oct 2021 14:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633528949;
        bh=paNIdt0n1IUg0PoPinSNA3zULBsEQmPckwLqR+v0GmQ=;
        h=From:To:Cc:Subject:Date:From;
        b=nb9KHuVRu2xCr7pMCijToIfHxpzwjnv9tkMsHAfl1QT2PD5z1b5GgiNlngnrxpjFr
         sGKjF26vls+zyxygx4jKB3xUW3HlmSHgnL3ZZ4IAmLsZRaHPaWlU0c/igouqzwxXu5
         GVgmOiBONMHcgi+gjdclbvGaCiurb/apRlF8WYzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.151
Date:   Wed,  6 Oct 2021 16:02:25 +0200
Message-Id: <1633528946887@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.151 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                          |    2 
 arch/x86/events/intel/core.c                      |    1 
 arch/x86/include/asm/kvmclock.h                   |   14 ++++
 arch/x86/kernel/kvmclock.c                        |   13 ----
 block/bfq-iosched.c                               |   16 +----
 drivers/cpufreq/cpufreq_governor_attr_set.c       |    2 
 drivers/crypto/ccp/ccp-ops.c                      |   14 ++--
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    1 
 drivers/hid/hid-betopff.c                         |   13 +++-
 drivers/hid/hid-u2fzero.c                         |    4 +
 drivers/hid/usbhid/hid-core.c                     |   13 ++++
 drivers/hwmon/mlxreg-fan.c                        |   12 +++-
 drivers/hwmon/tmp421.c                            |   33 +++--------
 drivers/hwmon/w83791d.c                           |   29 +++-------
 drivers/hwmon/w83792d.c                           |   28 +++------
 drivers/hwmon/w83793.c                            |   26 +++------
 drivers/ipack/devices/ipoctal.c                   |   63 ++++++++++++++++------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c   |    5 +
 drivers/net/ethernet/intel/e100.c                 |   22 +++++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    4 -
 drivers/net/usb/hso.c                             |   33 ++++++++---
 drivers/net/wireless/mac80211_hwsim.c             |    4 -
 drivers/nvdimm/pmem.c                             |    4 -
 drivers/pci/probe.c                               |   36 ++++++------
 drivers/pci/remove.c                              |    2 
 drivers/scsi/csiostor/csio_init.c                 |    1 
 drivers/scsi/ufs/ufshcd.c                         |    3 -
 drivers/tty/vt/vt.c                               |   21 ++++++-
 drivers/usb/cdns3/gadget.c                        |   14 ++++
 fs/binfmt_elf.c                                   |    2 
 fs/debugfs/inode.c                                |    2 
 fs/ext4/dir.c                                     |    6 +-
 fs/ext4/inode.c                                   |    5 +
 fs/ext4/super.c                                   |   16 +++--
 fs/verity/enable.c                                |    2 
 fs/verity/open.c                                  |    2 
 include/net/ip_fib.h                              |    2 
 include/net/nexthop.h                             |    2 
 include/net/sock.h                                |    2 
 kernel/sched/cpufreq_schedutil.c                  |   16 +++--
 net/core/sock.c                                   |   32 +++++++++--
 net/ipv4/fib_semantics.c                          |   16 +++--
 net/ipv4/udp.c                                    |   10 +--
 net/ipv6/route.c                                  |    5 +
 net/ipv6/udp.c                                    |    2 
 net/mac80211/mesh_ps.c                            |    3 -
 net/mac80211/tx.c                                 |   12 ++++
 net/mac80211/wpa.c                                |    6 ++
 net/netfilter/ipset/ip_set_hash_gen.h             |    4 -
 net/netfilter/ipvs/ip_vs_conn.c                   |    4 +
 net/sched/cls_flower.c                            |    6 ++
 net/sctp/input.c                                  |    2 
 net/unix/af_unix.c                                |   34 +++++++++--
 tools/testing/selftests/bpf/test_lwt_ip_encap.sh  |   13 ++--
 54 files changed, 411 insertions(+), 228 deletions(-)

Andrea Claudi (1):
      ipvs: check that ip_vs_conn_tab_bits is between 8 and 20

Andrej Shadura (1):
      HID: u2fzero: ignore incomplete packets without data

Anirudh Rayabharam (1):
      HID: usbhid: free raw_report buffers in usbhid_stop

Charlene Liu (1):
      drm/amd/display: Pass PCI deviceid into DC

Chen Jingwen (1):
      elf: don't use MAP_FIXED_NOREPLACE for elf interpreter mappings

Chih-Kang Chang (1):
      mac80211: Fix ieee80211_amsdu_aggregate frag_tail bug

Dan Carpenter (1):
      crypto: ccp - fix resource leaks in ccp_run_aes_gcm_cmd()

Dongliang Mu (2):
      usb: hso: fix error handling code of hso_create_net_device
      usb: hso: remove the bailout parameter

Eric Biggers (1):
      fs-verity: fix signed integer overflow with i_size near S64_MAX

Eric Dumazet (2):
      af_unix: fix races in sk_peer_pid and sk_peer_cred accesses
      net: udp: annotate data race around udp_sk(sk)->corkflag

F.A.Sulaiman (1):
      HID: betop: fix slab-out-of-bounds Write in betop_probe

Greg Kroah-Hartman (1):
      Linux 5.4.151

Igor Matheus Andrade Torrente (1):
      tty: Fix out-of-bound vmalloc access in imageblit

Jacob Keller (2):
      e100: fix length calculation in e100_get_regs_len
      e100: fix buffer overrun in e100_get_regs

James Morse (1):
      cpufreq: schedutil: Destroy mutex before kobject_put() frees the memory

Jeffle Xu (1):
      ext4: fix reserved space counter leakage

Jens Axboe (1):
      Revert "block, bfq: honor already-setup queue merges"

Jian Shen (1):
      net: hns3: do not allow call hns3_nic_net_open repeatedly

Jiri Benc (1):
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

Kevin Hao (1):
      cpufreq: schedutil: Use kobject release() method to free sugov_tunables

Leon Yu (1):
      net: stmmac: don't attach interface until resume finishes

Lorenzo Bianconi (1):
      mac80211: limit injected vht mcs/nss in ieee80211_parse_tx_radiotap

Nadezda Lutovinova (3):
      hwmon: (w83793) Fix NULL pointer dereference by removing unnecessary structure field
      hwmon: (w83792d) Fix NULL pointer dereference by removing unnecessary structure field
      hwmon: (w83791d) Fix NULL pointer dereference by removing unnecessary structure field

Nirmoy Das (1):
      debugfs: debugfs_create_file_size(): use IS_ERR to check for error

Oliver Neukum (1):
      hso: fix bailout in error case of probe

Paul Fertser (2):
      hwmon: (tmp421) report /PVLD condition as fault
      hwmon: (tmp421) fix rounding for negative values

Pawel Laszczak (1):
      usb: cdns3: fix race condition before setting doorbell

Rahul Lakkireddy (1):
      scsi: csiostor: Add module softdep on cxgb4

Ritesh Harjani (1):
      ext4: fix loff_t overflow in ext4_max_bitmap_size()

Rob Herring (1):
      PCI: Fix pci_host_bridge struct device release/free handling

Vadim Pasternak (1):
      hwmon: (mlxreg-fan) Return non-zero value when fan current state is enforced from sysfs

Vlad Buslov (1):
      net: sched: flower: protect fl_walk() with rcu

Xiao Liang (1):
      net: ipv4: Fix rtnexthop len when RTA_FLOW is present

Xin Long (1):
      sctp: break out if skb_header_pointer returns NULL in sctp_rcv_ootb

Zelin Deng (1):
      x86/kvmclock: Move this_cpu_pvti into kvmclock.h

sumiyawang (1):
      libnvdimm/pmem: Fix crash triggered when I/O in-flight during unbind

yangerkun (1):
      ext4: fix potential infinite loop in ext4_dx_readdir()

