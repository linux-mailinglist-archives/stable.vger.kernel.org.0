Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF9C103FE9
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 16:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729644AbfKTPkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 10:40:15 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52486 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729354AbfKTPkO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 10:40:14 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5T-0004YF-6g; Wed, 20 Nov 2019 15:40:11 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5S-0004FT-Cg; Wed, 20 Nov 2019 15:40:10 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     torvalds@linux-foundation.org, Guenter Roeck <linux@roeck-us.net>,
        akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>
Date:   Wed, 20 Nov 2019 15:37:10 +0000
Message-ID: <lsq.1574264230.280218497@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 00/83] 3.16.78-rc1 review
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 3.16.78 release.
There are 83 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Nov 22 15:37:10 UTC 2019.
Anything received after that time might be too late.

All the patches have also been committed to the linux-3.16.y-rc branch of
https://git.kernel.org/pub/scm/linux/kernel/git/bwh/linux-stable-rc.git .
A shortlog and diffstat can be found below.

Ben.

-------------

Alan Stern (1):
      USB: core: Fix races in character device registration and deregistraion
         [303911cfc5b95d33687d9046133ff184cf5043ff]

Andreas Koop (1):
      mmc: mmc_spi: Enable stable writes
         [3a6ffb3c8c3274a39dc8f2514526e645c5d21753]

Bandan Das (1):
      x86/apic: Do not initialize LDR and DFR for bigsmp
         [bae3a8d3308ee69a7dbdf145911b18dfda8ade0d]

Björn Gerhart (1):
      hwmon: (nct6775) Fix register address and added missed tolerance for nct6106
         [f3d43e2e45fd9d44ba52d20debd12cd4ee9c89bf]

Charles Keepax (1):
      ALSA: compress: Fix regression on compressed capture streams
         [4475f8c4ab7b248991a60d9c02808dbb813d6be8]

Christophe JAILLET (3):
      ipv6: Fix the link time qualifier of 'ping_v6_proc_exit_net()'
         [d23dbc479a8e813db4161a695d67da0e36557846]
      net: seeq: Fix the function used to release some memory in an error handling path
         [e1e54ec7fb55501c33b117c111cb0a045b8eded2]
      sctp: Fix the link time qualifier of 'sctp_ctrlsock_exit()'
         [b456d72412ca8797234449c25815e82f4e1426c0]

Cong Wang (1):
      sch_hhf: ensure quantum and hhf_non_hh_weight are non-zero
         [d4d6ec6dac07f263f06d847d6f732d6855522845]

Dave Wysochanski (1):
      cifs: use cifsInodeInfo->open_file_lock while iterating to avoid a panic
         [cb248819d209d113e45fed459773991518e8e80b]

Dirk Morris (1):
      netfilter: conntrack: Use consistent ct id hash calculation
         [656c8e9cc1badbc18eefe6ba01d33ebbcae61b9a]

Dou Liyang (1):
      x86/apic: Drop logical_smp_processor_id() inline
         [8f1561680f42a5491b371b513f1ab8197f31fd62]

Eric Dumazet (2):
      mld: fix memory leak in mld_del_delrec()
         [a84d016479896b5526a2cc54784e6ffc41c9d6f6]
      net/packet: fix race in tpacket_snd()
         [32d3182cd2cd29b2e7e04df7b0db350fbe11289f]

Fuqian Huang (1):
      KVM: x86: work around leak of uninitialized stack contents
         [541ab2aeb28251bf7135c7961f3a6080eebcc705]

Gustavo A. R. Silva (1):
      sh: kernel: hw_breakpoint: Fix missing break in switch statement
         [1ee1119d184bb06af921b48c3021d921bbd85bac]

Hans de Goede (1):
      x86/sysfb_efi: Add quirks for some devices with swapped width and height
         [d02f1aa39189e0619c3525d5cd03254e61bf606a]

Hans van Kranenburg (2):
      btrfs: alloc_chunk: fix more DUP stripe size handling
         [baf92114c7e6dd6124aa3d506e4bc4b694da3bc3]
      btrfs: partially apply b8b93addde
         [b8b93addde1e0192b045da8995e296fc1e40c80f]

Henk van der Laan (1):
      usb-storage: Add new JMS567 revision to unusual_devs
         [08d676d1685c2a29e4d0e1b0242324e564d4589e]

Hillf Danton (1):
      keys: Fix missing null pointer check in request_key_auth_describe()
         [d41a3effbb53b1bcea41e328d16a4d046a508381]

Ian Abbott (2):
      staging: comedi: dt3000: Fix rounding up of timer divisor
         [8e2a589a3fc36ce858d42e767c3bcd8fc62a512b]
      staging: comedi: dt3000: Fix signed integer overflow 'divider * base'
         [b4d98bc3fc93ec3a58459948a2c0e0c9b501cd88]

Jan Beulich (1):
      x86/apic/32: Avoid bogus LDR warnings
         [fe6f85ca121e9c74e7490fe66b0c5aae38e332c3]

Jann Horn (1):
      sched/fair: Don't free p->numa_faults with concurrent readers
         [16d51a590a8ce3befb1308e0e7ab77f3b661af33]

Jia-Ju Bai (1):
      net: sched: Fix a possible null-pointer dereference in dequeue_func()
         [051c7b39be4a91f6b7d8c4548444e4b850f1f56c]

Jiri Pirko (1):
      net: fix ifindex collision during namespace removal
         [55b40dbf0e76b4bfb9d8b3a16a0208640a9a45df]

Juergen Gross (1):
      xen/swiotlb: fix condition for calling xen_destroy_contiguous_region()
         [50f6393f9654c561df4cdcf8e6cfba7260143601]

Kai-Heng Feng (2):
      USB: storage: ums-realtek: Update module parameter description for auto_delink_en
         [f6445b6b2f2bb1745080af4a0926049e8bca2617]
      USB: storage: ums-realtek: Whitelist auto-delink support
         [1902a01e2bcc3abd7c9a18dc05e78c7ab4a53c54]

Kees Cook (1):
      libata: zpodd: Fix small read overflow in zpodd_get_mech_type()
         [71d6c505b4d9e6f76586350450e785e3d452b346]

Kefeng Wang (1):
      hpet: Fix division by zero in hpet_time_div()
         [0c7d37f4d9b8446956e97b7c5e61173cdb7c8522]

Liangyan (1):
      sched/fair: Don't assign runtime for throttled cfs_rq
         [5e2d2cc2588bd3307ce3937acbc2ed03c830a861]

Mikulas Patocka (1):
      dm table: fix invalid memory accesses with too high sector number
         [1cfd5d3399e87167b7f9157ef99daa0e959f395d]

Nadav Amit (1):
      VMCI: Release resource if the work is already queued
         [ba03a9bbd17b149c373c0ea44017f35fc2cd0f28]

Nathan Chancellor (1):
      net: tc35815: Explicitly check NET_IP_ALIGN is not zero in tc35815_rx
         [125b7e0949d4e72b15c2b1a1590f8cece985a918]

Neal Cardwell (1):
      tcp: fix tcp_ecn_withdraw_cwr() to clear TCP_ECN_QUEUE_CWR
         [af38d07ed391b21f7405fa1f936ca9686787d6d2]

Nigel Croxon (1):
      md/raid: raid5 preserve the writeback action after the parity check
         [b2176a1dfb518d870ee073445d27055fea64dfb8]

Nikolay Aleksandrov (1):
      net: bridge: mcast: don't delete permanent entries when fast leave is enabled
         [5c725b6b65067909548ac9ca9bc777098ec9883d]

Oliver Neukum (2):
      USB: cdc-wdm: fix race between write and disconnect due to flag abuse
         [1426bd2c9f7e3126e2678e7469dca9fd9fc6dd3e]
      usb: cdc-acm: make sure a refcount is taken early enough
         [c52873e5a1ef72f845526d9f6a50704433f9c625]

Ondrej Mosnacek (1):
      selinux: fix memory leak in policydb_init()
         [45385237f65aeee73641f1ef737d7273905a233f]

Paolo Bonzini (1):
      KVM: nVMX: handle page fault in vmread
         [f7eea636c3d505fe6f1d1066234f1aaf7171b681]

Pavel Shilovsky (2):
      CIFS: Fix use after free of file info structures
         [1a67c415965752879e2e9fad407bc44fc7f25f23]
      SMB3: Fix deadlock in validate negotiate hits reconnect
         [e99c63e4d86d3a94818693147b469fa70de6f945]

Peter Zijlstra (1):
      tty/ldsem, locking/rwsem: Add missing ACQUIRE to read_failed sleep loop
         [952041a8639a7a3a73a2b6573cb8aa8518bc39f8]

Phong Tran (1):
      usb: wusbcore: fix unbalanced get/put cluster_id
         [f90bf1ece48a736097ea224430578fe586a9544c]

Qian Cai (1):
      asm-generic: fix -Wtype-limits compiler warnings
         [cbedfe11347fe418621bd188d58a206beb676218]

Qu Wenruo (1):
      btrfs: volumes: Cleanup stripe size calculation
         [793ff2c88c6397b3531c08cc4f920619b56a9def]

Ricardo Neri (1):
      ptrace,x86: Make user_64bit_mode() available to 32-bit builds
         [e27c310af5c05cf876d9cad006928076c27f54d4]

Robert Hodaszi (1):
      Revert "cfg80211: fix processing world regdomain when non modular"
         [0d31d4dbf38412f5b8b11b4511d07b840eebe8cb]

Ryan Kennedy (1):
      usb: pci-quirks: Correct AMD PLL quirk detection
         [f3dccdaade4118070a3a47bef6b18321431f9ac6]

Sean Christopherson (1):
      x86/retpoline: Don't clobber RFLAGS during CALL_NOSPEC on i386
         [b63f20a778c88b6a04458ed6ffc69da953d3a109]

Sebastian Mayr (1):
      uprobes/x86: Fix detection of 32-bit user mode
         [9212ec7d8357ea630031e89d0d399c761421c83b]

Stefan Haberland (1):
      s390/dasd: fix endless loop after read unit address configuration
         [41995342b40c418a47603e1321256d2c4a2ed0fb]

Stephane Grosjean (1):
      can: peak_usb: fix potential double kfree_skb()
         [fee6a8923ae0d318a7f7950c6c6c28a96cea099b]

Steve French (1):
      smb3: send CAP_DFS capability during session setup
         [8d33096a460d5b9bd13300f01615df5bb454db10]

Subash Abhinov Kasiviswanathan (1):
      net: Fix null de-reference of device refcount
         [10cc514f451a0f239aa34f91bc9dc954a9397840]

Sudarsana Reddy Kalluru (1):
      bnx2x: Disable multi-cos feature.
         [d1f0b5dce8fda09a7f5f04c1878f181d548e42f5]

Suzuki K Poulose (1):
      usb: yurex: Fix use-after-free in yurex_delete
         [fc05481b2fcabaaeccf63e32ac1baab54e5b6963]

Sven Eckelmann (1):
      batman-adv: Only read OGM tvlv_len after buffer len check
         [a15d56a60760aa9dbe26343b9a0ac5228f35d445]

Takashi Iwai (2):
      ALSA: hda - Fix potential endless loop at applying quirks
         [333f31436d3db19f4286f8862a00ea1d8d8420a1]
      ALSA: seq: Fix potential concurrent access to the deleted pool
         [75545304eba6a3d282f923b96a466dc25a81e359]

Thadeu Lima de Souza Cascardo (1):
      alarmtimer: Use EOPNOTSUPP instead of ENOTSUPP
         [f18ddc13af981ce3c7b7f26925f099e7c6929aba]

Tiwei Bie (1):
      vhost/test: fix build for vhost test
         [264b563b8675771834419057cbe076c1a41fb666]

Tomas Bortoli (1):
      can: peak_usb: pcan_usb_pro: Fix info-leaks to USB devices
         [ead16e53c2f0ed946d82d4037c630e2f60f4ab69]

Tony Lindgren (1):
      USB: serial: option: Add Motorola modem UARTs
         [6caf0be40a707689e8ff8824fdb96ef77685b1ba]

Trond Myklebust (1):
      NFSv4: Fix a potential sleep while atomic in nfs4_do_reclaim()
         [c77e22834ae9a11891cb613bd9a551be1b94f2bc]

Ulf Hansson (1):
      mmc: core: Fix init of SD cards reporting an invalid VDD range
         [72741084d903e65e121c27bd29494d941729d4a1]

Vidya Sagar (1):
      PCI: tegra: Enable Relaxed Ordering only for Tegra20 & Tegra30
         [7be142caabc4780b13a522c485abc806de5c4114]

Wenwen Wang (3):
      ALSA: firewire: fix a memory leak bug
         [1be3c1fae6c1e1f5bb982b255d2034034454527a]
      ALSA: hda - Fix a memory leak bug
         [cfef67f016e4c00a2f423256fc678a6967a9fc09]
      sound: fix a memory leak bug
         [c7cd7c748a3250ca33509f9235efab9c803aca09]

Will Deacon (1):
      arm64: compat: Allow single-byte watchpoints on all addresses
         [849adec41203ac5837c40c2d7e08490ffdef3c2c]

Xin Long (2):
      sctp: fix the transport error_count check
         [a1794de8b92ea6bc2037f445b296814ac826693e]
      sctp: use transport pf_retrans in sctp_do_8_2_transport_strike
         [10eb56c582c557c629271f1ee31e15e7a9b2558b]

Yang Yingliang (1):
      tun: fix use-after-free when register netdev failed
         [77f22f92dff8e7b45c7786a430626d38071d4670]

Yoshiaki Okamoto (1):
      USB: serial: option: Add support for ZTE MF871A
         [7e7ae38bf928c5cfa6dd6e9a2cf8b42c84a27c92]

Yoshihiro Shimoda (1):
      usb: host: ohci: fix a race condition between shutdown and irq
         [a349b95d7ca0cea71be4a7dac29830703de7eb62]

Yunfeng Ye (1):
      genirq: Prevent NULL pointer dereference in resend_irqs()
         [eddf3e9c7c7e4d0707c68d1bb22cc6ec8aef7d4a]

ZhangXiaoxu (2):
      dm btree: fix order of block initialization in btree_split_beneath
         [e4f9d6013820d1eba1432d51dd1c5795759aa77f]
      dm space map metadata: fix missing store of apply_bops() return value
         [ae148243d3f0816b37477106c05a2ec7d5f32614]

Zhenzhong Duan (1):
      x86/speculation/mds: Apply more accurate check on hypervisor platform
         [517c3ba00916383af6411aec99442c307c23f684]

 Makefile                                           |  4 +-
 arch/arm64/kernel/hw_breakpoint.c                  |  7 +--
 arch/sh/kernel/hw_breakpoint.c                     |  1 +
 arch/x86/include/asm/nospec-branch.h               |  2 +-
 arch/x86/include/asm/ptrace.h                      |  6 ++-
 arch/x86/include/asm/smp.h                         | 10 -----
 arch/x86/kernel/apic/apic.c                        | 25 ++++++-----
 arch/x86/kernel/apic/bigsmp_32.c                   | 24 +----------
 arch/x86/kernel/cpu/bugs.c                         |  4 +-
 arch/x86/kernel/sysfb_efi.c                        | 46 ++++++++++++++++++++
 arch/x86/kernel/uprobes.c                          | 17 +++++---
 arch/x86/kvm/vmx.c                                 |  7 ++-
 arch/x86/kvm/x86.c                                 |  7 +++
 drivers/ata/libata-zpodd.c                         |  2 +-
 drivers/char/hpet.c                                |  3 +-
 drivers/hwmon/nct6775.c                            |  3 +-
 drivers/md/dm-table.c                              |  5 ++-
 drivers/md/persistent-data/dm-btree.c              | 31 +++++++-------
 drivers/md/persistent-data/dm-space-map-metadata.c |  2 +-
 drivers/md/raid5.c                                 | 10 ++++-
 drivers/misc/vmw_vmci/vmci_doorbell.c              |  6 ++-
 drivers/mmc/card/queue.c                           |  5 +++
 drivers/mmc/core/sd.c                              |  6 +++
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |  8 ++--
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c        |  2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |  2 +-
 drivers/net/ethernet/seeq/sgiseeq.c                |  7 +--
 drivers/net/ethernet/toshiba/tc35815.c             |  2 +-
 drivers/net/tun.c                                  | 17 +++++---
 drivers/pci/host/pci-tegra.c                       |  7 ++-
 drivers/s390/block/dasd_alias.c                    | 22 +++++++---
 drivers/staging/comedi/drivers/dt3000.c            |  8 ++--
 drivers/tty/tty_ldsem.c                            |  5 +--
 drivers/usb/class/cdc-acm.c                        | 18 ++++----
 drivers/usb/class/cdc-wdm.c                        | 16 +++++--
 drivers/usb/core/file.c                            | 10 ++---
 drivers/usb/host/hwa-hc.c                          |  2 +-
 drivers/usb/host/ohci-hcd.c                        | 13 +++++-
 drivers/usb/host/pci-quirks.c                      | 31 ++++++++------
 drivers/usb/misc/yurex.c                           |  2 +-
 drivers/usb/serial/option.c                        |  6 +++
 drivers/usb/storage/realtek_cr.c                   | 15 ++++---
 drivers/usb/storage/unusual_devs.h                 |  2 +-
 drivers/vhost/test.c                               | 13 ++++--
 drivers/xen/swiotlb-xen.c                          |  4 +-
 fs/btrfs/volumes.c                                 | 22 +++++-----
 fs/cifs/file.c                                     | 33 ++++++--------
 fs/cifs/smb2pdu.c                                  |  7 ++-
 fs/exec.c                                          |  2 +-
 fs/nfs/nfs4_fs.h                                   |  3 +-
 fs/nfs/nfs4client.c                                |  5 ++-
 fs/nfs/nfs4state.c                                 | 27 +++++++++---
 include/asm-generic/getorder.h                     | 50 +++++++++-------------
 include/linux/sched.h                              |  4 +-
 include/sound/compress_driver.h                    |  5 +--
 kernel/fork.c                                      |  2 +-
 kernel/irq/resend.c                                |  2 +
 kernel/sched/fair.c                                | 37 +++++++++++++---
 kernel/time/alarmtimer.c                           |  8 ++--
 net/batman-adv/bat_iv_ogm.c                        | 18 +++++---
 net/bridge/br_multicast.c                          |  3 ++
 net/core/dev.c                                     |  4 ++
 net/ipv4/tcp_input.c                               |  2 +-
 net/ipv6/mcast.c                                   |  5 ++-
 net/ipv6/ping.c                                    |  2 +-
 net/netfilter/nf_conntrack_core.c                  | 16 +++----
 net/packet/af_packet.c                             |  7 +++
 net/sched/sch_codel.c                              |  3 +-
 net/sched/sch_hhf.c                                |  2 +-
 net/sctp/protocol.c                                |  2 +-
 net/sctp/sm_sideeffect.c                           |  4 +-
 net/wireless/reg.c                                 |  2 +-
 security/keys/request_key_auth.c                   |  6 +++
 security/selinux/ss/policydb.c                     |  6 ++-
 sound/core/compress_offload.c                      | 16 ++++---
 sound/core/seq/seq_clientmgr.c                     |  3 +-
 sound/core/seq/seq_fifo.c                          | 17 ++++++++
 sound/core/seq/seq_fifo.h                          |  2 +
 sound/firewire/packets-buffer.c                    |  2 +-
 sound/pci/hda/hda_auto_parser.c                    |  4 +-
 sound/pci/hda/hda_generic.c                        |  2 +-
 sound/sound_core.c                                 |  3 +-
 82 files changed, 497 insertions(+), 286 deletions(-)

-- 
Ben Hutchings
Theory and practice are closer in theory than in practice - John Levine

