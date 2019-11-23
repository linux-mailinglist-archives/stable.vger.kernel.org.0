Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D204E107ED3
	for <lists+stable@lfdr.de>; Sat, 23 Nov 2019 15:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfKWOXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Nov 2019 09:23:42 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47066 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726524AbfKWOXl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Nov 2019 09:23:41 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iYWK1-0006YR-PC; Sat, 23 Nov 2019 14:23:37 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iYWK1-0001x1-AW; Sat, 23 Nov 2019 14:23:37 +0000
Date:   Sat, 23 Nov 2019 14:23:37 +0000
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc:     lwn@lwn.net
Subject: Linux 3.16.78
Message-ID: <lsq.1574518957.15298187@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="24zk1gE8NUlDmwG9"
Content-Disposition: inline
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.12.2 (2019-09-21)
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--24zk1gE8NUlDmwG9
Content-Type: multipart/mixed; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.16.78 kernel.

All users of the 3.16 kernel series should upgrade.

The updated 3.16.y git tree can be found at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
=2Egit linux-3.16.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

The diff from 3.16.77 is attached to this message.

Ben.

------------

 Makefile                                           |  2 +-
 arch/arm64/kernel/hw_breakpoint.c                  |  7 +--
 arch/sh/kernel/hw_breakpoint.c                     |  1 +
 arch/x86/include/asm/nospec-branch.h               |  2 +-
 arch/x86/include/asm/ptrace.h                      |  6 ++-
 arch/x86/include/asm/smp.h                         | 10 -----
 arch/x86/kernel/apic/apic.c                        | 25 ++++++-----
 arch/x86/kernel/apic/bigsmp_32.c                   | 24 +----------
 arch/x86/kernel/cpu/bugs.c                         |  4 +-
 arch/x86/kernel/sysfb_efi.c                        | 46 ++++++++++++++++++=
++
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
 include/asm-generic/getorder.h                     | 50 +++++++++---------=
----
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
 82 files changed, 496 insertions(+), 285 deletions(-)

Alan Stern (1):
      USB: core: Fix races in character device registration and deregistrai=
on

Andreas Koop (1):
      mmc: mmc_spi: Enable stable writes

Bandan Das (1):
      x86/apic: Do not initialize LDR and DFR for bigsmp

Ben Hutchings (1):
      Linux 3.16.78

Bj=F6rn Gerhart (1):
      hwmon: (nct6775) Fix register address and added missed tolerance for =
nct6106

Charles Keepax (1):
      ALSA: compress: Fix regression on compressed capture streams

Christophe JAILLET (3):
      net: seeq: Fix the function used to release some memory in an error h=
andling path
      ipv6: Fix the link time qualifier of 'ping_v6_proc_exit_net()'
      sctp: Fix the link time qualifier of 'sctp_ctrlsock_exit()'

Cong Wang (1):
      sch_hhf: ensure quantum and hhf_non_hh_weight are non-zero

Dave Wysochanski (1):
      cifs: use cifsInodeInfo->open_file_lock while iterating to avoid a pa=
nic

Dirk Morris (1):
      netfilter: conntrack: Use consistent ct id hash calculation

Dou Liyang (1):
      x86/apic: Drop logical_smp_processor_id() inline

Eric Dumazet (2):
      net/packet: fix race in tpacket_snd()
      mld: fix memory leak in mld_del_delrec()

Fuqian Huang (1):
      KVM: x86: work around leak of uninitialized stack contents

Gustavo A. R. Silva (1):
      sh: kernel: hw_breakpoint: Fix missing break in switch statement

Hans de Goede (1):
      x86/sysfb_efi: Add quirks for some devices with swapped width and hei=
ght

Hans van Kranenburg (2):
      btrfs: partially apply b8b93addde
      btrfs: alloc_chunk: fix more DUP stripe size handling

Henk van der Laan (1):
      usb-storage: Add new JMS567 revision to unusual_devs

Hillf Danton (1):
      keys: Fix missing null pointer check in request_key_auth_describe()

Hodaszi, Robert (1):
      Revert "cfg80211: fix processing world regdomain when non modular"

Ian Abbott (2):
      staging: comedi: dt3000: Fix signed integer overflow 'divider * base'
      staging: comedi: dt3000: Fix rounding up of timer divisor

Jan Beulich (1):
      x86/apic/32: Avoid bogus LDR warnings

Jann Horn (1):
      sched/fair: Don't free p->numa_faults with concurrent readers

Jia-Ju Bai (1):
      net: sched: Fix a possible null-pointer dereference in dequeue_func()

Jiri Pirko (1):
      net: fix ifindex collision during namespace removal

Juergen Gross (1):
      xen/swiotlb: fix condition for calling xen_destroy_contiguous_region()

Kai-Heng Feng (2):
      USB: storage: ums-realtek: Update module parameter description for au=
to_delink_en
      USB: storage: ums-realtek: Whitelist auto-delink support

Kees Cook (1):
      libata: zpodd: Fix small read overflow in zpodd_get_mech_type()

Kefeng Wang (1):
      hpet: Fix division by zero in hpet_time_div()

Liangyan (1):
      sched/fair: Don't assign runtime for throttled cfs_rq

Mikulas Patocka (1):
      dm table: fix invalid memory accesses with too high sector number

Nadav Amit (1):
      VMCI: Release resource if the work is already queued

Nathan Chancellor (1):
      net: tc35815: Explicitly check NET_IP_ALIGN is not zero in tc35815_rx

Neal Cardwell (1):
      tcp: fix tcp_ecn_withdraw_cwr() to clear TCP_ECN_QUEUE_CWR

Nigel Croxon (1):
      md/raid: raid5 preserve the writeback action after the parity check

Nikolay Aleksandrov (1):
      net: bridge: mcast: don't delete permanent entries when fast leave is=
 enabled

Oliver Neukum (2):
      usb: cdc-acm: make sure a refcount is taken early enough
      USB: cdc-wdm: fix race between write and disconnect due to flag abuse

Ondrej Mosnacek (1):
      selinux: fix memory leak in policydb_init()

Paolo Bonzini (1):
      KVM: nVMX: handle page fault in vmread

Pavel Shilovsky (2):
      SMB3: Fix deadlock in validate negotiate hits reconnect
      CIFS: Fix use after free of file info structures

Peter Zijlstra (1):
      tty/ldsem, locking/rwsem: Add missing ACQUIRE to read_failed sleep lo=
op

Phong Tran (1):
      usb: wusbcore: fix unbalanced get/put cluster_id

Qian Cai (1):
      asm-generic: fix -Wtype-limits compiler warnings

Qu Wenruo (1):
      btrfs: volumes: Cleanup stripe size calculation

Ricardo Neri (1):
      ptrace,x86: Make user_64bit_mode() available to 32-bit builds

Ryan Kennedy (1):
      usb: pci-quirks: Correct AMD PLL quirk detection

Sean Christopherson (1):
      x86/retpoline: Don't clobber RFLAGS during CALL_NOSPEC on i386

Sebastian Mayr (1):
      uprobes/x86: Fix detection of 32-bit user mode

Stefan Haberland (1):
      s390/dasd: fix endless loop after read unit address configuration

Stephane Grosjean (1):
      can: peak_usb: fix potential double kfree_skb()

Steve French (1):
      smb3: send CAP_DFS capability during session setup

Subash Abhinov Kasiviswanathan (1):
      net: Fix null de-reference of device refcount

Sudarsana Reddy Kalluru (1):
      bnx2x: Disable multi-cos feature.

Suzuki K Poulose (1):
      usb: yurex: Fix use-after-free in yurex_delete

Sven Eckelmann (1):
      batman-adv: Only read OGM tvlv_len after buffer len check

Takashi Iwai (2):
      ALSA: seq: Fix potential concurrent access to the deleted pool
      ALSA: hda - Fix potential endless loop at applying quirks

Thadeu Lima de Souza Cascardo (1):
      alarmtimer: Use EOPNOTSUPP instead of ENOTSUPP

Tiwei Bie (1):
      vhost/test: fix build for vhost test

Tomas Bortoli (1):
      can: peak_usb: pcan_usb_pro: Fix info-leaks to USB devices

Tony Lindgren (1):
      USB: serial: option: Add Motorola modem UARTs

Trond Myklebust (1):
      NFSv4: Fix a potential sleep while atomic in nfs4_do_reclaim()

Ulf Hansson (1):
      mmc: core: Fix init of SD cards reporting an invalid VDD range

Vidya Sagar (1):
      PCI: tegra: Enable Relaxed Ordering only for Tegra20 & Tegra30

Wenwen Wang (3):
      sound: fix a memory leak bug
      ALSA: firewire: fix a memory leak bug
      ALSA: hda - Fix a memory leak bug

Will Deacon (1):
      arm64: compat: Allow single-byte watchpoints on all addresses

Xin Long (2):
      sctp: fix the transport error_count check
      sctp: use transport pf_retrans in sctp_do_8_2_transport_strike

Yang Yingliang (1):
      tun: fix use-after-free when register netdev failed

Yoshiaki Okamoto (1):
      USB: serial: option: Add support for ZTE MF871A

Yoshihiro Shimoda (1):
      usb: host: ohci: fix a race condition between shutdown and irq

Yunfeng Ye (1):
      genirq: Prevent NULL pointer dereference in resend_irqs()

ZhangXiaoxu (2):
      dm btree: fix order of block initialization in btree_split_beneath
      dm space map metadata: fix missing store of apply_bops() return value

Zhenzhong Duan (1):
      x86/speculation/mds: Apply more accurate check on hypervisor platform


--h31gzZEtNLTqOjlF
Content-Type: text/x-diff; charset=UTF-8; name="linux-3.16.78.patch"
Content-Disposition: attachment; filename="linux-3.16.78.patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/Makefile b/Makefile
index db0000d44ed7..1c577cc5ad59 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 16
-SUBLEVEL =3D 77
+SUBLEVEL =3D 78
 EXTRAVERSION =3D
 NAME =3D Museum of Fishiegoodies
=20
diff --git a/arch/arm64/kernel/hw_breakpoint.c b/arch/arm64/kernel/hw_break=
point.c
index df1cf15377b4..d2244bdccccf 100644
--- a/arch/arm64/kernel/hw_breakpoint.c
+++ b/arch/arm64/kernel/hw_breakpoint.c
@@ -501,13 +501,14 @@ int arch_validate_hwbkpt_settings(struct perf_event *=
bp)
 			/* Aligned */
 			break;
 		case 1:
-			/* Allow single byte watchpoint. */
-			if (info->ctrl.len =3D=3D ARM_BREAKPOINT_LEN_1)
-				break;
 		case 2:
 			/* Allow halfword watchpoints and breakpoints. */
 			if (info->ctrl.len =3D=3D ARM_BREAKPOINT_LEN_2)
 				break;
+		case 3:
+			/* Allow single byte watchpoint. */
+			if (info->ctrl.len =3D=3D ARM_BREAKPOINT_LEN_1)
+				break;
 		default:
 			return -EINVAL;
 		}
diff --git a/arch/sh/kernel/hw_breakpoint.c b/arch/sh/kernel/hw_breakpoint.c
index 2197fc584186..000cc3343867 100644
--- a/arch/sh/kernel/hw_breakpoint.c
+++ b/arch/sh/kernel/hw_breakpoint.c
@@ -160,6 +160,7 @@ int arch_bp_generic_fields(int sh_len, int sh_type,
 	switch (sh_type) {
 	case SH_BREAKPOINT_READ:
 		*gen_type =3D HW_BREAKPOINT_R;
+		break;
 	case SH_BREAKPOINT_WRITE:
 		*gen_type =3D HW_BREAKPOINT_W;
 		break;
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/no=
spec-branch.h
index 9c6d043e7e30..0b0dfa9c2b2e 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -151,7 +151,7 @@
 	"    	lfence;\n"					\
 	"       jmp    902b;\n"					\
 	"       .align 16\n"					\
-	"903:	addl   $4, %%esp;\n"				\
+	"903:	lea    4(%%esp), %%esp;\n"			\
 	"       pushl  %[thunk_target];\n"			\
 	"       ret;\n"						\
 	"       .align 16\n"					\
diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 6205f0c434db..85476dc8f56c 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -118,9 +118,9 @@ static inline int v8086_mode(struct pt_regs *regs)
 #endif
 }
=20
-#ifdef CONFIG_X86_64
 static inline bool user_64bit_mode(struct pt_regs *regs)
 {
+#ifdef CONFIG_X86_64
 #ifndef CONFIG_PARAVIRT
 	/*
 	 * On non-paravirt systems, this is the only long mode CPL 3
@@ -131,8 +131,12 @@ static inline bool user_64bit_mode(struct pt_regs *reg=
s)
 	/* Headers are too twisted for this to go in paravirt.h. */
 	return regs->cs =3D=3D __USER_CS || regs->cs =3D=3D pv_info.extra_user_64=
bit_cs;
 #endif
+#else /* !CONFIG_X86_64 */
+	return false;
+#endif
 }
=20
+#ifdef CONFIG_X86_64
 #define current_user_stack_pointer()	this_cpu_read(old_rsp)
 /* ia32 vs. x32 difference */
 #define compat_user_stack_pointer()	\
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index eb7fac9ef8a4..8c43d5581f0c 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -203,16 +203,6 @@ extern int safe_smp_processor_id(void);
 #endif
=20
 #ifdef CONFIG_X86_LOCAL_APIC
-
-#ifndef CONFIG_X86_64
-static inline int logical_smp_processor_id(void)
-{
-	/* we don't want to mark this access volatile - bad code generation */
-	return GET_APIC_LOGICAL_ID(apic_read(APIC_LDR));
-}
-
-#endif
-
 extern int hard_smp_processor_id(void);
=20
 #else /* CONFIG_X86_LOCAL_APIC */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index fb2cce787f79..e695094220ac 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1339,16 +1339,21 @@ void setup_local_APIC(void)
 	apic->init_apic_ldr();
=20
 #ifdef CONFIG_X86_32
-	/*
-	 * APIC LDR is initialized.  If logical_apicid mapping was
-	 * initialized during get_smp_config(), make sure it matches the
-	 * actual value.
-	 */
-	i =3D early_per_cpu(x86_cpu_to_logical_apicid, cpu);
-	WARN_ON(i !=3D BAD_APICID && i !=3D logical_smp_processor_id());
-	/* always use the value from LDR */
-	early_per_cpu(x86_cpu_to_logical_apicid, cpu) =3D
-		logical_smp_processor_id();
+	if (apic->dest_logical) {
+		int logical_apicid, ldr_apicid;
+
+		/*
+		 * APIC LDR is initialized.  If logical_apicid mapping was
+		 * initialized during get_smp_config(), make sure it matches
+		 * the actual value.
+		 */
+		logical_apicid =3D early_per_cpu(x86_cpu_to_logical_apicid, cpu);
+		ldr_apicid =3D GET_APIC_LOGICAL_ID(apic_read(APIC_LDR));
+		if (logical_apicid !=3D BAD_APICID)
+			WARN_ON(logical_apicid !=3D ldr_apicid);
+		/* Always use the value from LDR. */
+		early_per_cpu(x86_cpu_to_logical_apicid, cpu) =3D ldr_apicid;
+	}
=20
 	/*
 	 * Some NUMA implementations (NUMAQ) don't initialize apicid to
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp=
_32.c
index e4840aa7a255..9e7eda2b48b8 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -42,32 +42,12 @@ static int bigsmp_early_logical_apicid(int cpu)
 	return early_per_cpu(x86_cpu_to_apicid, cpu);
 }
=20
-static inline unsigned long calculate_ldr(int cpu)
-{
-	unsigned long val, id;
-
-	val =3D apic_read(APIC_LDR) & ~APIC_LDR_MASK;
-	id =3D per_cpu(x86_bios_cpu_apicid, cpu);
-	val |=3D SET_APIC_LOGICAL_ID(id);
-
-	return val;
-}
-
 /*
- * Set up the logical destination ID.
- *
- * Intel recommends to set DFR, LDR and TPR before enabling
- * an APIC.  See e.g. "AP-388 82489DX User's Manual" (Intel
- * document number 292116).  So here it goes...
+ * bigsmp enables physical destination mode
+ * and doesn't use LDR and DFR
  */
 static void bigsmp_init_apic_ldr(void)
 {
-	unsigned long val;
-	int cpu =3D smp_processor_id();
-
-	apic_write(APIC_DFR, APIC_DFR_FLAT);
-	val =3D calculate_ldr(cpu);
-	apic_write(APIC_LDR, val);
 }
=20
 static void bigsmp_setup_apic_routing(void)
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 884ce92cfc0f..1ff1f10e8c80 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1349,12 +1349,10 @@ static ssize_t itlb_multihit_show_state(char *buf)
=20
 static ssize_t mds_show_state(char *buf)
 {
-#ifdef CONFIG_HYPERVISOR_GUEST
-	if (x86_hyper) {
+	if (boot_cpu_has(X86_FEATURE_HYPERVISOR)) {
 		return sprintf(buf, "%s; SMT Host state unknown\n",
 			       mds_strings[mds_mitigation]);
 	}
-#endif
=20
 	if (boot_cpu_has(X86_BUG_MSBDS_ONLY)) {
 		return sprintf(buf, "%s; SMT %s\n", mds_strings[mds_mitigation],
diff --git a/arch/x86/kernel/sysfb_efi.c b/arch/x86/kernel/sysfb_efi.c
index 5da924bbf0a0..7cd61011ed26 100644
--- a/arch/x86/kernel/sysfb_efi.c
+++ b/arch/x86/kernel/sysfb_efi.c
@@ -216,9 +216,55 @@ static const struct dmi_system_id efifb_dmi_system_tab=
le[] __initconst =3D {
 	{},
 };
=20
+/*
+ * Some devices have a portrait LCD but advertise a landscape resolution (=
and
+ * pitch). We simply swap width and height for these devices so that we can
+ * correctly deal with some of them coming with multiple resolutions.
+ */
+static const struct dmi_system_id efifb_dmi_swap_width_height[] __initcons=
t =3D {
+	{
+		/*
+		 * Lenovo MIIX310-10ICR, only some batches have the troublesome
+		 * 800x1280 portrait screen. Luckily the portrait version has
+		 * its own BIOS version, so we match on that.
+		 */
+		.matches =3D {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "MIIX 310-10ICR"),
+			DMI_EXACT_MATCH(DMI_BIOS_VERSION, "1HCN44WW"),
+		},
+	},
+	{
+		/* Lenovo MIIX 320-10ICR with 800x1280 portrait screen */
+		.matches =3D {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_VERSION,
+					"Lenovo MIIX 320-10ICR"),
+		},
+	},
+	{
+		/* Lenovo D330 with 800x1280 or 1200x1920 portrait screen */
+		.matches =3D {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_VERSION,
+					"Lenovo ideapad D330-10IGM"),
+		},
+	},
+	{},
+};
+
 __init void sysfb_apply_efi_quirks(void)
 {
 	if (screen_info.orig_video_isVGA !=3D VIDEO_TYPE_EFI ||
 	    !(screen_info.capabilities & VIDEO_CAPABILITY_SKIP_QUIRKS))
 		dmi_check_system(efifb_dmi_system_table);
+
+	if (screen_info.orig_video_isVGA =3D=3D VIDEO_TYPE_EFI &&
+	    dmi_check_system(efifb_dmi_swap_width_height)) {
+		u16 temp =3D screen_info.lfb_width;
+
+		screen_info.lfb_width =3D screen_info.lfb_height;
+		screen_info.lfb_height =3D temp;
+		screen_info.lfb_linelength =3D 4 * screen_info.lfb_width;
+	}
 }
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 5d1cbfe4ae58..4260c69ad7b9 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -455,9 +455,12 @@ struct uprobe_xol_ops {
 	void	(*abort)(struct arch_uprobe *, struct pt_regs *);
 };
=20
-static inline int sizeof_long(void)
+static inline int sizeof_long(struct pt_regs *regs)
 {
-	return is_ia32_task() ? 4 : 8;
+	/*
+	 * Check registers for mode as in_xxx_syscall() does not apply here.
+	 */
+	return user_64bit_mode(regs) ? 8 : 4;
 }
=20
 static int default_pre_xol_op(struct arch_uprobe *auprobe, struct pt_regs =
*regs)
@@ -468,9 +471,9 @@ static int default_pre_xol_op(struct arch_uprobe *aupro=
be, struct pt_regs *regs)
=20
 static int push_ret_address(struct pt_regs *regs, unsigned long ip)
 {
-	unsigned long new_sp =3D regs->sp - sizeof_long();
+	unsigned long new_sp =3D regs->sp - sizeof_long(regs);
=20
-	if (copy_to_user((void __user *)new_sp, &ip, sizeof_long()))
+	if (copy_to_user((void __user *)new_sp, &ip, sizeof_long(regs)))
 		return -EFAULT;
=20
 	regs->sp =3D new_sp;
@@ -503,7 +506,7 @@ static int default_post_xol_op(struct arch_uprobe *aupr=
obe, struct pt_regs *regs
 		long correction =3D utask->vaddr - utask->xol_vaddr;
 		regs->ip +=3D correction;
 	} else if (auprobe->defparam.fixups & UPROBE_FIX_CALL) {
-		regs->sp +=3D sizeof_long(); /* Pop incorrect return address */
+		regs->sp +=3D sizeof_long(regs); /* Pop incorrect return address */
 		if (push_ret_address(regs, utask->vaddr + auprobe->defparam.ilen))
 			return -ERESTART;
 	}
@@ -612,7 +615,7 @@ static int branch_post_xol_op(struct arch_uprobe *aupro=
be, struct pt_regs *regs)
 	 * "call" insn was executed out-of-line. Just restore ->sp and restart.
 	 * We could also restore ->ip and try to call branch_emulate_op() again.
 	 */
-	regs->sp +=3D sizeof_long();
+	regs->sp +=3D sizeof_long(regs);
 	return -ERESTART;
 }
=20
@@ -903,7 +906,7 @@ bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe=
, struct pt_regs *regs)
 unsigned long
 arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct p=
t_regs *regs)
 {
-	int rasize =3D sizeof_long(), nleft;
+	int rasize =3D sizeof_long(regs), nleft;
 	unsigned long orig_ret_vaddr =3D 0; /* clear high bits for 32-bit apps */
=20
 	if (copy_from_user(&orig_ret_vaddr, (void __user *)regs->sp, rasize))
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 00dd9ea13c22..a1dbb20b768b 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -6426,6 +6426,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 	unsigned long exit_qualification =3D vmcs_readl(EXIT_QUALIFICATION);
 	u32 vmx_instruction_info =3D vmcs_read32(VMX_INSTRUCTION_INFO);
 	gva_t gva =3D 0;
+	struct x86_exception e;
=20
 	if (!nested_vmx_check_permission(vcpu) ||
 	    !nested_vmx_check_vmcs12(vcpu))
@@ -6452,8 +6453,10 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 				vmx_instruction_info, &gva))
 			return 1;
 		/* _system ok, as nested_vmx_check_permission verified cpl=3D0 */
-		kvm_write_guest_virt_system(vcpu, gva, &field_value,
-					    (is_long_mode(vcpu) ? 8 : 4), NULL);
+		if (kvm_write_guest_virt_system(vcpu, gva, &field_value,
+						(is_long_mode(vcpu) ? 8 : 4),
+						&e))
+			kvm_inject_page_fault(vcpu, &e);
 	}
=20
 	nested_vmx_succeed(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f9e374b696b9..48cfac1a78de 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4329,6 +4329,13 @@ static int emulator_write_std(struct x86_emulate_ctx=
t *ctxt, gva_t addr, void *v
 int kvm_write_guest_virt_system(struct kvm_vcpu *vcpu, gva_t addr, void *v=
al,
 				unsigned int bytes, struct x86_exception *exception)
 {
+	/*
+	 * FIXME: this should call handle_emulation_failure if X86EMUL_IO_NEEDED
+	 * is returned, but our callers are not ready for that and they blindly
+	 * call kvm_inject_page_fault.  Ensure that they at least do not leak
+	 * uninitialized kernel stack memory into cr2 and error code.
+	 */
+	memset(exception, 0, sizeof(*exception));
 	return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
 					   PFERR_WRITE_MASK, exception);
 }
diff --git a/drivers/ata/libata-zpodd.c b/drivers/ata/libata-zpodd.c
index 0ad96c647541..424cf89f960e 100644
--- a/drivers/ata/libata-zpodd.c
+++ b/drivers/ata/libata-zpodd.c
@@ -55,7 +55,7 @@ static enum odd_mech_type zpodd_get_mech_type(struct ata_=
device *dev)
 	unsigned int ret;
 	struct rm_feature_desc *desc =3D (void *)(buf + 8);
 	struct ata_taskfile tf;
-	static const char cdb[] =3D {  GPCMD_GET_CONFIGURATION,
+	static const char cdb[ATAPI_CDB_LEN] =3D {  GPCMD_GET_CONFIGURATION,
 			2,      /* only 1 feature descriptor requested */
 			0, 3,   /* 3, removable medium feature */
 			0, 0, 0,/* reserved */
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 978a782f5e30..6b70161077f8 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -570,8 +570,7 @@ static inline unsigned long hpet_time_div(struct hpets =
*hpets,
 	unsigned long long m;
=20
 	m =3D hpets->hp_tick_freq + (dis >> 1);
-	do_div(m, dis);
-	return (unsigned long)m;
+	return div64_ul(m, dis);
 }
=20
 static int
diff --git a/drivers/hwmon/nct6775.c b/drivers/hwmon/nct6775.c
index fc842ec066e1..23412f34f601 100644
--- a/drivers/hwmon/nct6775.c
+++ b/drivers/hwmon/nct6775.c
@@ -598,7 +598,7 @@ static const u16 NCT6106_REG_TARGET[] =3D { 0x111, 0x12=
1, 0x131 };
 static const u16 NCT6106_REG_WEIGHT_TEMP_SEL[] =3D { 0x168, 0x178, 0x188 };
 static const u16 NCT6106_REG_WEIGHT_TEMP_STEP[] =3D { 0x169, 0x179, 0x189 =
};
 static const u16 NCT6106_REG_WEIGHT_TEMP_STEP_TOL[] =3D { 0x16a, 0x17a, 0x=
18a };
-static const u16 NCT6106_REG_WEIGHT_DUTY_STEP[] =3D { 0x16b, 0x17b, 0x17c =
};
+static const u16 NCT6106_REG_WEIGHT_DUTY_STEP[] =3D { 0x16b, 0x17b, 0x18b =
};
 static const u16 NCT6106_REG_WEIGHT_TEMP_BASE[] =3D { 0x16c, 0x17c, 0x18c =
};
 static const u16 NCT6106_REG_WEIGHT_DUTY_BASE[] =3D { 0x16d, 0x17d, 0x18d =
};
=20
@@ -3339,6 +3339,7 @@ static int nct6775_probe(struct platform_device *pdev)
 		data->REG_FAN_TIME[0] =3D NCT6106_REG_FAN_STOP_TIME;
 		data->REG_FAN_TIME[1] =3D NCT6106_REG_FAN_STEP_UP_TIME;
 		data->REG_FAN_TIME[2] =3D NCT6106_REG_FAN_STEP_DOWN_TIME;
+		data->REG_TOLERANCE_H =3D NCT6106_REG_TOLERANCE_H;
 		data->REG_PWM[0] =3D NCT6106_REG_PWM;
 		data->REG_PWM[1] =3D NCT6106_REG_FAN_START_OUTPUT;
 		data->REG_PWM[2] =3D NCT6106_REG_FAN_STOP_OUTPUT;
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index b010f9600d87..ae43b5126f9f 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1158,7 +1158,7 @@ void dm_table_event(struct dm_table *t)
 }
 EXPORT_SYMBOL(dm_table_event);
=20
-sector_t dm_table_get_size(struct dm_table *t)
+inline sector_t dm_table_get_size(struct dm_table *t)
 {
 	return t->num_targets ? (t->highs[t->num_targets - 1] + 1) : 0;
 }
@@ -1183,6 +1183,9 @@ struct dm_target *dm_table_find_target(struct dm_tabl=
e *t, sector_t sector)
 	unsigned int l, n =3D 0, k =3D 0;
 	sector_t *node;
=20
+	if (unlikely(sector >=3D dm_table_get_size(t)))
+		return &t->targets[t->num_targets];
+
 	for (l =3D 0; l < t->depth; l++) {
 		n =3D get_child(n, k);
 		node =3D get_node(t, l, n);
diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-=
data/dm-btree.c
index 715dc21d18c4..5490eac824b5 100644
--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -533,39 +533,40 @@ static int btree_split_beneath(struct shadow_spine *s=
, uint64_t key)
=20
 	new_parent =3D shadow_current(s);
=20
+	pn =3D dm_block_data(new_parent);
+	size =3D le32_to_cpu(pn->header.flags) & INTERNAL_NODE ?
+		sizeof(__le64) : s->info->value_type.size;
+
+	/* create & init the left block */
 	r =3D new_block(s->info, &left);
 	if (r < 0)
 		return r;
=20
+	ln =3D dm_block_data(left);
+	nr_left =3D le32_to_cpu(pn->header.nr_entries) / 2;
+
+	ln->header.flags =3D pn->header.flags;
+	ln->header.nr_entries =3D cpu_to_le32(nr_left);
+	ln->header.max_entries =3D pn->header.max_entries;
+	ln->header.value_size =3D pn->header.value_size;
+	memcpy(ln->keys, pn->keys, nr_left * sizeof(pn->keys[0]));
+	memcpy(value_ptr(ln, 0), value_ptr(pn, 0), nr_left * size);
+
+	/* create & init the right block */
 	r =3D new_block(s->info, &right);
 	if (r < 0) {
 		unlock_block(s->info, left);
 		return r;
 	}
=20
-	pn =3D dm_block_data(new_parent);
-	ln =3D dm_block_data(left);
 	rn =3D dm_block_data(right);
-
-	nr_left =3D le32_to_cpu(pn->header.nr_entries) / 2;
 	nr_right =3D le32_to_cpu(pn->header.nr_entries) - nr_left;
=20
-	ln->header.flags =3D pn->header.flags;
-	ln->header.nr_entries =3D cpu_to_le32(nr_left);
-	ln->header.max_entries =3D pn->header.max_entries;
-	ln->header.value_size =3D pn->header.value_size;
-
 	rn->header.flags =3D pn->header.flags;
 	rn->header.nr_entries =3D cpu_to_le32(nr_right);
 	rn->header.max_entries =3D pn->header.max_entries;
 	rn->header.value_size =3D pn->header.value_size;
-
-	memcpy(ln->keys, pn->keys, nr_left * sizeof(pn->keys[0]));
 	memcpy(rn->keys, pn->keys + nr_left, nr_right * sizeof(pn->keys[0]));
-
-	size =3D le32_to_cpu(pn->header.flags) & INTERNAL_NODE ?
-		sizeof(__le64) : s->info->value_type.size;
-	memcpy(value_ptr(ln, 0), value_ptr(pn, 0), nr_left * size);
 	memcpy(value_ptr(rn, 0), value_ptr(pn, nr_left),
 	       nr_right * size);
=20
diff --git a/drivers/md/persistent-data/dm-space-map-metadata.c b/drivers/m=
d/persistent-data/dm-space-map-metadata.c
index 8114a29839c4..35a7ac8499c3 100644
--- a/drivers/md/persistent-data/dm-space-map-metadata.c
+++ b/drivers/md/persistent-data/dm-space-map-metadata.c
@@ -248,7 +248,7 @@ static int out(struct sm_metadata *smm)
 	}
=20
 	if (smm->recursion_count =3D=3D 1)
-		apply_bops(smm);
+		r =3D apply_bops(smm);
=20
 	smm->recursion_count--;
=20
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 1dae2b025159..3293f1857559 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3385,7 +3385,7 @@ static void handle_parity_checks6(struct r5conf *conf=
, struct stripe_head *sh,
 		/* now write out any block on a failed drive,
 		 * or P or Q if they were recomputed
 		 */
-		BUG_ON(s->uptodate < disks - 1); /* We don't need Q to recover */
+		dev =3D NULL;
 		if (s->failed =3D=3D 2) {
 			dev =3D &sh->dev[s->failed_num[1]];
 			s->locked++;
@@ -3410,6 +3410,14 @@ static void handle_parity_checks6(struct r5conf *con=
f, struct stripe_head *sh,
 			set_bit(R5_LOCKED, &dev->flags);
 			set_bit(R5_Wantwrite, &dev->flags);
 		}
+		if (WARN_ONCE(dev && !test_bit(R5_UPTODATE, &dev->flags),
+			      "%s: disk%td not up to date\n",
+			      mdname(conf->mddev),
+			      dev - (struct r5dev *) &sh->dev)) {
+			clear_bit(R5_LOCKED, &dev->flags);
+			clear_bit(R5_Wantwrite, &dev->flags);
+			s->locked--;
+		}
 		clear_bit(STRIPE_DEGRADED, &sh->state);
=20
 		set_bit(STRIPE_INSYNC, &sh->state);
diff --git a/drivers/misc/vmw_vmci/vmci_doorbell.c b/drivers/misc/vmw_vmci/=
vmci_doorbell.c
index a8cee33ae8d2..305a3449e946 100644
--- a/drivers/misc/vmw_vmci/vmci_doorbell.c
+++ b/drivers/misc/vmw_vmci/vmci_doorbell.c
@@ -318,7 +318,8 @@ int vmci_dbell_host_context_notify(u32 src_cid, struct =
vmci_handle handle)
=20
 	entry =3D container_of(resource, struct dbell_entry, resource);
 	if (entry->run_delayed) {
-		schedule_work(&entry->work);
+		if (!schedule_work(&entry->work))
+			vmci_resource_put(resource);
 	} else {
 		entry->notify_cb(entry->client_data);
 		vmci_resource_put(resource);
@@ -366,7 +367,8 @@ static void dbell_fire_entries(u32 notify_idx)
 		    atomic_read(&dbell->active) =3D=3D 1) {
 			if (dbell->run_delayed) {
 				vmci_resource_get(&dbell->resource);
-				schedule_work(&dbell->work);
+				if (!schedule_work(&dbell->work))
+					vmci_resource_put(&dbell->resource);
 			} else {
 				dbell->notify_cb(dbell->client_data);
 			}
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 6ceede0a0bf7..35e387114abf 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -16,6 +16,7 @@
 #include <linux/kthread.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
+#include <linux/backing-dev.h>
=20
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
@@ -204,6 +205,10 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_ca=
rd *card,
 	if (!mq->queue)
 		return -ENOMEM;
=20
+	if (mmc_host_is_spi(host) && host->use_spi_crc)
+		mq->queue->backing_dev_info.capabilities |=3D
+			BDI_CAP_STABLE_WRITES;
+
 	mq->mqrq_cur =3D mqrq_cur;
 	mq->mqrq_prev =3D mqrq_prev;
 	mq->queue->queuedata =3D mq;
diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index aff8a7e0edd3..06a206b8aaf7 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -1242,6 +1242,12 @@ int mmc_attach_sd(struct mmc_host *host)
 			goto err;
 	}
=20
+	/*
+	 * Some SD cards claims an out of spec VDD voltage range. Let's treat
+	 * these bits as being in-valid and especially also bit7.
+	 */
+	ocr &=3D ~0x7FFF;
+
 	rocr =3D mmc_select_voltage(host, ocr);
=20
 	/*
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can=
/usb/peak_usb/pcan_usb_core.c
index 3f79814f51ce..524be31ec83e 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -572,16 +572,16 @@ static int peak_usb_ndo_stop(struct net_device *netde=
v)
 	dev->state &=3D ~PCAN_USB_STATE_STARTED;
 	netif_stop_queue(netdev);
=20
+	close_candev(netdev);
+
+	dev->can.state =3D CAN_STATE_STOPPED;
+
 	/* unlink all pending urbs and free used memory */
 	peak_usb_unlink_all_urbs(dev);
=20
 	if (dev->adapter->dev_stop)
 		dev->adapter->dev_stop(dev);
=20
-	close_candev(netdev);
-
-	dev->can.state =3D CAN_STATE_STOPPED;
-
 	/* can set bus off now */
 	if (dev->adapter->dev_set_bus) {
 		int err =3D dev->adapter->dev_set_bus(dev, 0);
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c b/drivers/net/can/=
usb/peak_usb/pcan_usb_pro.c
index f7f796a2c50b..9c4270185d6f 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
@@ -508,7 +508,7 @@ static int pcan_usb_pro_drv_loaded(struct peak_usb_devi=
ce *dev, int loaded)
 	u8 *buffer;
 	int err;
=20
-	buffer =3D kmalloc(PCAN_USBPRO_FCT_DRVLD_REQ_LEN, GFP_KERNEL);
+	buffer =3D kzalloc(PCAN_USBPRO_FCT_DRVLD_REQ_LEN, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
=20
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/=
ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 09f6325d13c3..d44f22a487ab 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -1914,7 +1914,7 @@ u16 bnx2x_select_queue(struct net_device *dev, struct=
 sk_buff *skb,
 	}
=20
 	/* select a non-FCoE queue */
-	return fallback(dev, skb) % (BNX2X_NUM_ETH_QUEUES(bp) * bp->max_cos);
+	return fallback(dev, skb) % (BNX2X_NUM_ETH_QUEUES(bp));
 }
=20
 void bnx2x_set_num_queues(struct bnx2x *bp)
diff --git a/drivers/net/ethernet/seeq/sgiseeq.c b/drivers/net/ethernet/see=
q/sgiseeq.c
index 69e4fd21adb4..201fe167f681 100644
--- a/drivers/net/ethernet/seeq/sgiseeq.c
+++ b/drivers/net/ethernet/seeq/sgiseeq.c
@@ -792,15 +792,16 @@ static int sgiseeq_probe(struct platform_device *pdev)
 		printk(KERN_ERR "Sgiseeq: Cannot register net device, "
 		       "aborting.\n");
 		err =3D -ENODEV;
-		goto err_out_free_page;
+		goto err_out_free_attrs;
 	}
=20
 	printk(KERN_INFO "%s: %s %pM\n", dev->name, sgiseeqstr, dev->dev_addr);
=20
 	return 0;
=20
-err_out_free_page:
-	free_page((unsigned long) sp->srings);
+err_out_free_attrs:
+	dma_free_attrs(&pdev->dev, sizeof(*sp->srings), sp->srings,
+		       sp->srings_dma, DMA_ATTR_NON_CONSISTENT);
 err_out_free_dev:
 	free_netdev(dev);
=20
diff --git a/drivers/net/ethernet/toshiba/tc35815.c b/drivers/net/ethernet/=
toshiba/tc35815.c
index 970d716989e1..470bd471b0ae 100644
--- a/drivers/net/ethernet/toshiba/tc35815.c
+++ b/drivers/net/ethernet/toshiba/tc35815.c
@@ -1528,7 +1528,7 @@ tc35815_rx(struct net_device *dev, int limit)
 			pci_unmap_single(lp->pci_dev,
 					 lp->rx_skbs[cur_bd].skb_dma,
 					 RX_BUF_SIZE, PCI_DMA_FROMDEVICE);
-			if (!HAVE_DMA_RXALIGN(lp) && NET_IP_ALIGN)
+			if (!HAVE_DMA_RXALIGN(lp) && NET_IP_ALIGN !=3D 0)
 				memmove(skb->data, skb->data - NET_IP_ALIGN,
 					pkt_len);
 			data =3D skb_put(skb, pkt_len);
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 1bbcb278e6df..c61d61f4537c 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -528,7 +528,8 @@ static void tun_detach_all(struct net_device *dev)
 		module_put(THIS_MODULE);
 }
=20
-static int tun_attach(struct tun_struct *tun, struct file *file, bool skip=
_filter)
+static int tun_attach(struct tun_struct *tun, struct file *file,
+		      bool skip_filter, bool publish_tun)
 {
 	struct tun_file *tfile =3D file->private_data;
 	int err;
@@ -561,7 +562,8 @@ static int tun_attach(struct tun_struct *tun, struct fi=
le *file, bool skip_filte
 	}
 	tfile->queue_index =3D tun->numqueues;
 	tfile->socket.sk->sk_shutdown &=3D ~RCV_SHUTDOWN;
-	rcu_assign_pointer(tfile->tun, tun);
+	if (publish_tun)
+		rcu_assign_pointer(tfile->tun, tun);
 	rcu_assign_pointer(tun->tfiles[tun->numqueues], tfile);
 	tun->numqueues++;
=20
@@ -1599,7 +1601,8 @@ static int tun_set_iff(struct net *net, struct file *=
file, struct ifreq *ifr)
 		if (err < 0)
 			return err;
=20
-		err =3D tun_attach(tun, file, ifr->ifr_flags & IFF_NOFILTER);
+		err =3D tun_attach(tun, file, ifr->ifr_flags & IFF_NOFILTER,
+				 true);
 		if (err < 0)
 			return err;
=20
@@ -1678,13 +1681,17 @@ static int tun_set_iff(struct net *net, struct file=
 *file, struct ifreq *ifr)
 				       NETIF_F_HW_VLAN_STAG_TX);
=20
 		INIT_LIST_HEAD(&tun->disabled);
-		err =3D tun_attach(tun, file, false);
+		err =3D tun_attach(tun, file, false, false);
 		if (err < 0)
 			goto err_free_flow;
=20
 		err =3D register_netdevice(tun->dev);
 		if (err < 0)
 			goto err_detach;
+		/* free_netdev() won't check refcnt, to aovid race
+		 * with dev_put() we need publish tun after registration.
+		 */
+		rcu_assign_pointer(tfile->tun, tun);
=20
 		if (device_create_file(&tun->dev->dev, &dev_attr_tun_flags) ||
 		    device_create_file(&tun->dev->dev, &dev_attr_owner) ||
@@ -1848,7 +1855,7 @@ static int tun_set_queue(struct file *file, struct if=
req *ifr)
 		ret =3D security_tun_dev_attach_queue(tun->security);
 		if (ret < 0)
 			goto unlock;
-		ret =3D tun_attach(tun, file, false);
+		ret =3D tun_attach(tun, file, false, true);
 	} else if (ifr->ifr_flags & IFF_DETACH_QUEUE) {
 		tun =3D rtnl_dereference(tfile->tun);
 		if (!tun || !(tun->flags & TUN_TAP_MQ) || tfile->detached)
diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c
index 0407b1d6bab8..c774b3fac49a 100644
--- a/drivers/pci/host/pci-tegra.c
+++ b/drivers/pci/host/pci-tegra.c
@@ -615,12 +615,15 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NVIDIA, 0x0bf1,=
 tegra_pcie_fixup_class);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NVIDIA, 0x0e1c, tegra_pcie_fixup_cla=
ss);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NVIDIA, 0x0e1d, tegra_pcie_fixup_cla=
ss);
=20
-/* Tegra PCIE requires relaxed ordering */
+/* Tegra20 and Tegra30 PCIE requires relaxed ordering */
 static void tegra_pcie_relax_enable(struct pci_dev *dev)
 {
 	pcie_capability_set_word(dev, PCI_EXP_DEVCTL, PCI_EXP_DEVCTL_RELAX_EN);
 }
-DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, tegra_pcie_relax_enable);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x0bf0, tegra_pcie_relax_ena=
ble);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x0bf1, tegra_pcie_relax_ena=
ble);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x0e1c, tegra_pcie_relax_ena=
ble);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x0e1d, tegra_pcie_relax_ena=
ble);
=20
 static int tegra_pcie_setup(int nr, struct pci_sys_data *sys)
 {
diff --git a/drivers/s390/block/dasd_alias.c b/drivers/s390/block/dasd_alia=
s.c
index 9ce22828d71e..6fc756bfa64e 100644
--- a/drivers/s390/block/dasd_alias.c
+++ b/drivers/s390/block/dasd_alias.c
@@ -396,6 +396,20 @@ suborder_not_supported(struct dasd_ccw_req *cqr)
 	char msg_format;
 	char msg_no;
=20
+	/*
+	 * intrc values ENODEV, ENOLINK and EPERM
+	 * will be optained from sleep_on to indicate that no
+	 * IO operation can be started
+	 */
+	if (cqr->intrc =3D=3D -ENODEV)
+		return 1;
+
+	if (cqr->intrc =3D=3D -ENOLINK)
+		return 1;
+
+	if (cqr->intrc =3D=3D -EPERM)
+		return 1;
+
 	sense =3D dasd_get_sense(&cqr->irb);
 	if (!sense)
 		return 0;
@@ -460,12 +474,8 @@ static int read_unit_address_configuration(struct dasd=
_device *device,
 	lcu->flags &=3D ~NEED_UAC_UPDATE;
 	spin_unlock_irqrestore(&lcu->lock, flags);
=20
-	do {
-		rc =3D dasd_sleep_on(cqr);
-		if (rc && suborder_not_supported(cqr))
-			return -EOPNOTSUPP;
-	} while (rc && (cqr->retries > 0));
-	if (rc) {
+	rc =3D dasd_sleep_on(cqr);
+	if (rc && !suborder_not_supported(cqr)) {
 		spin_lock_irqsave(&lcu->lock, flags);
 		lcu->flags |=3D NEED_UAC_UPDATE;
 		spin_unlock_irqrestore(&lcu->lock, flags);
diff --git a/drivers/staging/comedi/drivers/dt3000.c b/drivers/staging/come=
di/drivers/dt3000.c
index 4ab4de005924..44a0a4739dd7 100644
--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -379,9 +379,9 @@ static irqreturn_t dt3k_interrupt(int irq, void *d)
 static int dt3k_ns_to_timer(unsigned int timer_base, unsigned int *nanosec,
 			    unsigned int round_mode)
 {
-	int divider, base, prescale;
+	unsigned int divider, base, prescale;
=20
-	/* This function needs improvment */
+	/* This function needs improvement */
 	/* Don't know if divider=3D=3D0 works. */
=20
 	for (prescale =3D 0; prescale < 16; prescale++) {
@@ -395,7 +395,7 @@ static int dt3k_ns_to_timer(unsigned int timer_base, un=
signed int *nanosec,
 			divider =3D (*nanosec) / base;
 			break;
 		case TRIG_ROUND_UP:
-			divider =3D (*nanosec) / base;
+			divider =3D DIV_ROUND_UP(*nanosec, base);
 			break;
 		}
 		if (divider < 65536) {
@@ -405,7 +405,7 @@ static int dt3k_ns_to_timer(unsigned int timer_base, un=
signed int *nanosec,
 	}
=20
 	prescale =3D 15;
-	base =3D timer_base * (1 << prescale);
+	base =3D timer_base * (prescale + 1);
 	divider =3D 65535;
 	*nanosec =3D divider * base;
 	return (prescale << 16) | (divider);
diff --git a/drivers/tty/tty_ldsem.c b/drivers/tty/tty_ldsem.c
index 82544588797f..faa8f26c2438 100644
--- a/drivers/tty/tty_ldsem.c
+++ b/drivers/tty/tty_ldsem.c
@@ -137,8 +137,7 @@ static void __ldsem_wake_readers(struct ld_semaphore *s=
em)
=20
 	list_for_each_entry_safe(waiter, next, &sem->read_wait, list) {
 		tsk =3D waiter->task;
-		smp_mb();
-		waiter->task =3D NULL;
+		smp_store_release(&waiter->task, NULL);
 		wake_up_process(tsk);
 		put_task_struct(tsk);
 	}
@@ -234,7 +233,7 @@ down_read_failed(struct ld_semaphore *sem, long count, =
long timeout)
 	for (;;) {
 		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
=20
-		if (!waiter.task)
+		if (!smp_load_acquire(&waiter.task))
 			break;
 		if (!timeout)
 			break;
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index d49c24bff722..1c9be3b1d4df 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1371,13 +1371,6 @@ static int acm_probe(struct usb_interface *intf,
 		goto alloc_fail;
 	}
=20
-	minor =3D acm_alloc_minor(acm);
-	if (minor =3D=3D ACM_TTY_MINORS) {
-		dev_err(&intf->dev, "no more free acm devices\n");
-		kfree(acm);
-		return -ENODEV;
-	}
-
 	ctrlsize =3D usb_endpoint_maxp(epctrl);
 	readsize =3D usb_endpoint_maxp(epread) *
 				(quirks =3D=3D SINGLE_RX_URB ? 1 : 2);
@@ -1385,6 +1378,16 @@ static int acm_probe(struct usb_interface *intf,
 	acm->writesize =3D usb_endpoint_maxp(epwrite) * 20;
 	acm->control =3D control_interface;
 	acm->data =3D data_interface;
+
+	usb_get_intf(acm->control); /* undone in destruct() */
+
+	minor =3D acm_alloc_minor(acm);
+	if (minor < 0) {
+		dev_err(&intf->dev, "no more free acm devices\n");
+		kfree(acm);
+		return -ENODEV;
+	}
+
 	acm->minor =3D minor;
 	acm->dev =3D usb_dev;
 	acm->ctrl_caps =3D ac_management_function;
@@ -1540,7 +1543,6 @@ static int acm_probe(struct usb_interface *intf,
 	usb_driver_claim_interface(&acm_driver, data_interface, acm);
 	usb_set_intfdata(data_interface, acm);
=20
-	usb_get_intf(control_interface);
 	tty_dev =3D tty_port_register_device(&acm->port, acm_tty_driver, minor,
 			&control_interface->dev);
 	if (IS_ERR(tty_dev)) {
diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index cd53568e6e3f..3442814d7037 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -576,10 +576,20 @@ static int wdm_flush(struct file *file, fl_owner_t id)
 {
 	struct wdm_device *desc =3D file->private_data;
=20
-	wait_event(desc->wait, !test_bit(WDM_IN_USE, &desc->flags));
+	wait_event(desc->wait,
+			/*
+			 * needs both flags. We cannot do with one
+			 * because resetting it would cause a race
+			 * with write() yet we need to signal
+			 * a disconnect
+			 */
+			!test_bit(WDM_IN_USE, &desc->flags) ||
+			test_bit(WDM_DISCONNECTING, &desc->flags));
=20
 	/* cannot dereference desc->intf if WDM_DISCONNECTING */
-	if (desc->werr < 0 && !test_bit(WDM_DISCONNECTING, &desc->flags))
+	if (test_bit(WDM_DISCONNECTING, &desc->flags))
+		return -ENODEV;
+	if (desc->werr < 0)
 		dev_err(&desc->intf->dev, "Error in flush path: %d\n",
 			desc->werr);
=20
@@ -967,8 +977,6 @@ static void wdm_disconnect(struct usb_interface *intf)
 	spin_lock_irqsave(&desc->iuspin, flags);
 	set_bit(WDM_DISCONNECTING, &desc->flags);
 	set_bit(WDM_READ, &desc->flags);
-	/* to terminate pending flushes */
-	clear_bit(WDM_IN_USE, &desc->flags);
 	spin_unlock_irqrestore(&desc->iuspin, flags);
 	wake_up_all(&desc->wait);
 	mutex_lock(&desc->rlock);
diff --git a/drivers/usb/core/file.c b/drivers/usb/core/file.c
index b3de806085f0..097977c0359f 100644
--- a/drivers/usb/core/file.c
+++ b/drivers/usb/core/file.c
@@ -191,9 +191,10 @@ int usb_register_dev(struct usb_interface *intf,
 		intf->minor =3D minor;
 		break;
 	}
-	up_write(&minor_rwsem);
-	if (intf->minor < 0)
+	if (intf->minor < 0) {
+		up_write(&minor_rwsem);
 		return -EXFULL;
+	}
=20
 	/* create a usb class device for this usb interface */
 	snprintf(name, sizeof(name), class_driver->name, minor - minor_base);
@@ -206,12 +207,11 @@ int usb_register_dev(struct usb_interface *intf,
 				      MKDEV(USB_MAJOR, minor), class_driver,
 				      "%s", temp);
 	if (IS_ERR(intf->usb_dev)) {
-		down_write(&minor_rwsem);
 		usb_minors[minor] =3D NULL;
 		intf->minor =3D -1;
-		up_write(&minor_rwsem);
 		retval =3D PTR_ERR(intf->usb_dev);
 	}
+	up_write(&minor_rwsem);
 	return retval;
 }
 EXPORT_SYMBOL_GPL(usb_register_dev);
@@ -237,12 +237,12 @@ void usb_deregister_dev(struct usb_interface *intf,
 		return;
=20
 	dev_dbg(&intf->dev, "removing %d minor\n", intf->minor);
+	device_destroy(usb_class->class, MKDEV(USB_MAJOR, intf->minor));
=20
 	down_write(&minor_rwsem);
 	usb_minors[intf->minor] =3D NULL;
 	up_write(&minor_rwsem);
=20
-	device_destroy(usb_class->class, MKDEV(USB_MAJOR, intf->minor));
 	intf->usb_dev =3D NULL;
 	intf->minor =3D -1;
 	destroy_usb_class();
diff --git a/drivers/usb/host/hwa-hc.c b/drivers/usb/host/hwa-hc.c
index 1931a2b029eb..6c688090be90 100644
--- a/drivers/usb/host/hwa-hc.c
+++ b/drivers/usb/host/hwa-hc.c
@@ -173,7 +173,7 @@ static int hwahc_op_start(struct usb_hcd *usb_hcd)
 	return result;
=20
 error_set_cluster_id:
-	wusb_cluster_id_put(wusbhc->cluster_id);
+	wusb_cluster_id_put(addr);
 error_cluster_id_get:
 	goto out;
=20
diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index a21a36500fd7..d4869c1c2f28 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -392,8 +392,7 @@ static void ohci_usb_reset (struct ohci_hcd *ohci)
  * other cases where the next software may expect clean state from the
  * "firmware".  this is bus-neutral, unlike shutdown() methods.
  */
-static void
-ohci_shutdown (struct usb_hcd *hcd)
+static void _ohci_shutdown(struct usb_hcd *hcd)
 {
 	struct ohci_hcd *ohci;
=20
@@ -408,6 +407,16 @@ ohci_shutdown (struct usb_hcd *hcd)
 	ohci_writel(ohci, ohci->fminterval, &ohci->regs->fminterval);
 }
=20
+static void ohci_shutdown(struct usb_hcd *hcd)
+{
+	struct ohci_hcd	*ohci =3D hcd_to_ohci(hcd);
+	unsigned long flags;
+
+	spin_lock_irqsave(&ohci->lock, flags);
+	_ohci_shutdown(hcd);
+	spin_unlock_irqrestore(&ohci->lock, flags);
+}
+
 static int check_ed(struct ohci_hcd *ohci, struct ed *ed)
 {
 	return (hc32_to_cpu(ohci, ed->hwINFO) & ED_IN) !=3D 0
diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index 67733f044c22..f4cd032db24c 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -188,7 +188,7 @@ int usb_amd_find_chipset_info(void)
 {
 	unsigned long flags;
 	struct amd_chipset_info info;
-	int ret;
+	int need_pll_quirk =3D 0;
=20
 	spin_lock_irqsave(&amd_lock, flags);
=20
@@ -202,21 +202,28 @@ int usb_amd_find_chipset_info(void)
 	spin_unlock_irqrestore(&amd_lock, flags);
=20
 	if (!amd_chipset_sb_type_init(&info)) {
-		ret =3D 0;
 		goto commit;
 	}
=20
-	/* Below chipset generations needn't enable AMD PLL quirk */
-	if (info.sb_type.gen =3D=3D AMD_CHIPSET_UNKNOWN ||
-			info.sb_type.gen =3D=3D AMD_CHIPSET_SB600 ||
-			info.sb_type.gen =3D=3D AMD_CHIPSET_YANGTZE ||
-			(info.sb_type.gen =3D=3D AMD_CHIPSET_SB700 &&
-			info.sb_type.rev > 0x3b)) {
+	switch (info.sb_type.gen) {
+	case AMD_CHIPSET_SB700:
+		need_pll_quirk =3D info.sb_type.rev <=3D 0x3B;
+		break;
+	case AMD_CHIPSET_SB800:
+	case AMD_CHIPSET_HUDSON2:
+	case AMD_CHIPSET_BOLTON:
+		need_pll_quirk =3D 1;
+		break;
+	default:
+		need_pll_quirk =3D 0;
+		break;
+	}
+
+	if (!need_pll_quirk) {
 		if (info.smbus_dev) {
 			pci_dev_put(info.smbus_dev);
 			info.smbus_dev =3D NULL;
 		}
-		ret =3D 0;
 		goto commit;
 	}
=20
@@ -235,7 +242,7 @@ int usb_amd_find_chipset_info(void)
 		}
 	}
=20
-	ret =3D info.probe_result =3D 1;
+	need_pll_quirk =3D info.probe_result =3D 1;
 	printk(KERN_DEBUG "QUIRK: Enable AMD PLL fix\n");
=20
 commit:
@@ -246,7 +253,7 @@ int usb_amd_find_chipset_info(void)
=20
 		/* Mark that we where here */
 		amd_chipset.probe_count++;
-		ret =3D amd_chipset.probe_result;
+		need_pll_quirk =3D amd_chipset.probe_result;
=20
 		spin_unlock_irqrestore(&amd_lock, flags);
=20
@@ -262,7 +269,7 @@ int usb_amd_find_chipset_info(void)
 		spin_unlock_irqrestore(&amd_lock, flags);
 	}
=20
-	return ret;
+	return need_pll_quirk;
 }
 EXPORT_SYMBOL_GPL(usb_amd_find_chipset_info);
=20
diff --git a/drivers/usb/misc/yurex.c b/drivers/usb/misc/yurex.c
index 1c9d08157708..093f1cc5faf1 100644
--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -96,7 +96,6 @@ static void yurex_delete(struct kref *kref)
=20
 	dev_dbg(&dev->interface->dev, "%s\n", __func__);
=20
-	usb_put_dev(dev->udev);
 	if (dev->cntl_urb) {
 		usb_kill_urb(dev->cntl_urb);
 		kfree(dev->cntl_req);
@@ -112,6 +111,7 @@ static void yurex_delete(struct kref *kref)
 				dev->int_buffer, dev->urb->transfer_dma);
 		usb_free_urb(dev->urb);
 	}
+	usb_put_dev(dev->udev);
 	kfree(dev);
 }
=20
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 304602d20f68..9d4d27bbd102 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1109,6 +1109,11 @@ static const struct usb_device_id option_ids[] =3D {
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x7B) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x7C) },
=20
+	/* Motorola devices */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x22b8, 0x2a70, 0xff, 0xff, 0xff) },	/* m=
dm6600 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x22b8, 0x2e0a, 0xff, 0xff, 0xff) },	/* m=
dm9600 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x22b8, 0x4281, 0x0a, 0x00, 0xfc) },	/* m=
dm ram dl */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x22b8, 0x900e, 0xff, 0xff, 0xff) },	/* m=
dm qc dl */
=20
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V640) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V620) },
@@ -1672,6 +1677,7 @@ static const struct usb_device_id option_ids[] =3D {
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1428, 0xff, 0xff, 0xff),=
  /* Telewell TW-LTE 4G v2 */
 		.driver_info =3D (kernel_ulong_t)&net_intf2_blacklist },
 	{ USB_DEVICE_INTERFACE_CLASS(ZTE_VENDOR_ID, 0x1476, 0xff) },	/* GosunCn Z=
TE WeLink ME3630 (ECM/NCM mode) */
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1481, 0xff, 0x00, 0x00) =
}, /* ZTE MF871A */
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1533, 0xff, 0xff, 0xff) =
},
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1534, 0xff, 0xff, 0xff) =
},
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1535, 0xff, 0xff, 0xff) =
},
diff --git a/drivers/usb/storage/realtek_cr.c b/drivers/usb/storage/realtek=
_cr.c
index 56bfef517f68..37e24f6807f0 100644
--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -47,7 +47,7 @@ MODULE_VERSION("1.03");
=20
 static int auto_delink_en =3D 1;
 module_param(auto_delink_en, int, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(auto_delink_en, "enable auto delink");
+MODULE_PARM_DESC(auto_delink_en, "auto delink mode (0=3Dfirmware, 1=3Dsoft=
ware [default])");
=20
 #ifdef CONFIG_REALTEK_AUTOPM
 static int ss_en =3D 1;
@@ -1001,12 +1001,15 @@ static int init_realtek_cr(struct us_data *us)
 			goto INIT_FAIL;
 	}
=20
-	if (CHECK_FW_VER(chip, 0x5888) || CHECK_FW_VER(chip, 0x5889) ||
-	    CHECK_FW_VER(chip, 0x5901))
-		SET_AUTO_DELINK(chip);
-	if (STATUS_LEN(chip) =3D=3D 16) {
-		if (SUPPORT_AUTO_DELINK(chip))
+	if (CHECK_PID(chip, 0x0138) || CHECK_PID(chip, 0x0158) ||
+	    CHECK_PID(chip, 0x0159)) {
+		if (CHECK_FW_VER(chip, 0x5888) || CHECK_FW_VER(chip, 0x5889) ||
+				CHECK_FW_VER(chip, 0x5901))
 			SET_AUTO_DELINK(chip);
+		if (STATUS_LEN(chip) =3D=3D 16) {
+			if (SUPPORT_AUTO_DELINK(chip))
+				SET_AUTO_DELINK(chip);
+		}
 	}
 #ifdef CONFIG_REALTEK_AUTOPM
 	if (ss_en)
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusu=
al_devs.h
index 2249d85bd910..9ca02d89a641 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1987,7 +1987,7 @@ UNUSUAL_DEV(  0x14cd, 0x6600, 0x0201, 0x0201,
 		US_FL_IGNORE_RESIDUE ),
=20
 /* Reported by Michael B=C3=BCsch <m@bues.ch> */
-UNUSUAL_DEV(  0x152d, 0x0567, 0x0114, 0x0116,
+UNUSUAL_DEV(  0x152d, 0x0567, 0x0114, 0x0117,
 		"JMicron",
 		"USB to ATA/ATAPI Bridge",
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index d9c501eaa6c3..0ba67d1a3613 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -23,6 +23,12 @@
  * Using this limit prevents one virtqueue from starving others. */
 #define VHOST_TEST_WEIGHT 0x80000
=20
+/* Max number of packets transferred before requeueing the job.
+ * Using this limit prevents one virtqueue from starving others with
+ * pkts.
+ */
+#define VHOST_TEST_PKT_WEIGHT 256
+
 enum {
 	VHOST_TEST_VQ =3D 0,
 	VHOST_TEST_VQ_MAX =3D 1,
@@ -81,10 +87,8 @@ static void handle_vq(struct vhost_test *n)
 		}
 		vhost_add_used_and_signal(&n->dev, vq, head, 0);
 		total_len +=3D len;
-		if (unlikely(total_len >=3D VHOST_TEST_WEIGHT)) {
-			vhost_poll_queue(&vq->poll);
+		if (unlikely(vhost_exceeds_weight(vq, 0, total_len)))
 			break;
-		}
 	}
=20
 	mutex_unlock(&vq->mutex);
@@ -116,7 +120,8 @@ static int vhost_test_open(struct inode *inode, struct =
file *f)
 	dev =3D &n->dev;
 	vqs[VHOST_TEST_VQ] =3D &n->vqs[VHOST_TEST_VQ];
 	n->vqs[VHOST_TEST_VQ].handle_kick =3D handle_vq_kick;
-	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX);
+	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX,
+		       VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT);
=20
 	f->private_data =3D n;
=20
diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 73c1254e3943..fc495167b8de 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -372,8 +372,8 @@ xen_swiotlb_free_coherent(struct device *hwdev, size_t =
size, void *vaddr,
 	/* Convert the size to actually allocated. */
 	size =3D 1UL << (order + PAGE_SHIFT);
=20
-	if (((dev_addr + size - 1 <=3D dma_mask)) ||
-	    range_straddles_page_boundary(phys, size))
+	if (!WARN_ON((dev_addr + size - 1 > dma_mask) ||
+		     range_straddles_page_boundary(phys, size)))
 		xen_destroy_contiguous_region(phys, order);
=20
 	xen_free_coherent_pages(hwdev, size, vaddr, (dma_addr_t)phys, attrs);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4aa1a20fc5d7..0ff553ed19b0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -27,6 +27,7 @@
 #include <linux/kthread.h>
 #include <linux/raid/pq.h>
 #include <linux/semaphore.h>
+#include <linux/sizes.h>
 #include <asm/div64.h>
 #include "ctree.h"
 #include "extent_map.h"
@@ -4270,21 +4271,18 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_h=
andle *trans,
 	/*
 	 * Use the number of data stripes to figure out how big this chunk
 	 * is really going to be in terms of logical address space,
-	 * and compare that answer with the max chunk size
+	 * and compare that answer with the max chunk size. If it's higher,
+	 * we try to reduce stripe_size.
 	 */
 	if (stripe_size * data_stripes > max_chunk_size) {
-		u64 mask =3D (1ULL << 24) - 1;
-		stripe_size =3D max_chunk_size;
-		do_div(stripe_size, data_stripes);
-
-		/* bump the answer up to a 16MB boundary */
-		stripe_size =3D (stripe_size + mask) & ~mask;
-
-		/* but don't go higher than the limits we found
-		 * while searching for free extents
+		/*
+		 * Reduce stripe_size, round it up to a 16MB boundary again and
+		 * then use it, unless it ends up being even bigger than the
+		 * previous value we had already.
 		 */
-		if (stripe_size > devices_info[ndevs-1].max_avail)
-			stripe_size =3D devices_info[ndevs-1].max_avail;
+		stripe_size =3D min(round_up(div_u64(max_chunk_size,
+						   data_stripes), SZ_16M),
+				  stripe_size);
 	}
=20
 	/* align to BTRFS_STRIPE_LEN */
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 0ff4c7b49c7b..4fb2a62299f4 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -398,10 +398,11 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_file=
, bool wait_oplock_handler)
 	bool oplock_break_cancelled;
=20
 	spin_lock(&tcon->open_file_lock);
-
+	spin_lock(&cifsi->open_file_lock);
 	spin_lock(&cifs_file->file_info_lock);
 	if (--cifs_file->count > 0) {
 		spin_unlock(&cifs_file->file_info_lock);
+		spin_unlock(&cifsi->open_file_lock);
 		spin_unlock(&tcon->open_file_lock);
 		return;
 	}
@@ -414,9 +415,7 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_file, =
bool wait_oplock_handler)
 	cifs_add_pending_open_locked(&fid, cifs_file->tlink, &open);
=20
 	/* remove it from the lists */
-	spin_lock(&cifsi->open_file_lock);
 	list_del(&cifs_file->flist);
-	spin_unlock(&cifsi->open_file_lock);
 	list_del(&cifs_file->tlist);
=20
 	if (list_empty(&cifsi->openFileList)) {
@@ -432,6 +431,7 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_file, =
bool wait_oplock_handler)
 		cifs_set_oplock_level(cifsi, 0);
 	}
=20
+	spin_unlock(&cifsi->open_file_lock);
 	spin_unlock(&tcon->open_file_lock);
=20
 	oplock_break_cancelled =3D wait_oplock_handler ?
@@ -1756,13 +1756,12 @@ struct cifsFileInfo *find_readable_file(struct cifs=
InodeInfo *cifs_inode,
 {
 	struct cifsFileInfo *open_file =3D NULL;
 	struct cifs_sb_info *cifs_sb =3D CIFS_SB(cifs_inode->vfs_inode.i_sb);
-	struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb);
=20
 	/* only filter by fsuid on multiuser mounts */
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
 		fsuid_only =3D false;
=20
-	spin_lock(&tcon->open_file_lock);
+	spin_lock(&cifs_inode->open_file_lock);
 	/* we could simply get the first_list_entry since write-only entries
 	   are always at the end of the list but since the first entry might
 	   have a close pending, we go through the whole list */
@@ -1774,7 +1773,7 @@ struct cifsFileInfo *find_readable_file(struct cifsIn=
odeInfo *cifs_inode,
 				/* found a good file */
 				/* lock it so it will not be closed on us */
 				cifsFileInfo_get(open_file);
-				spin_unlock(&tcon->open_file_lock);
+				spin_unlock(&cifs_inode->open_file_lock);
 				return open_file;
 			} /* else might as well continue, and look for
 			     another, or simply have the caller reopen it
@@ -1782,7 +1781,7 @@ struct cifsFileInfo *find_readable_file(struct cifsIn=
odeInfo *cifs_inode,
 		} else /* write only file */
 			break; /* write only files are last so must be done */
 	}
-	spin_unlock(&tcon->open_file_lock);
+	spin_unlock(&cifs_inode->open_file_lock);
 	return NULL;
 }
=20
@@ -1791,7 +1790,6 @@ struct cifsFileInfo *find_writable_file(struct cifsIn=
odeInfo *cifs_inode,
 {
 	struct cifsFileInfo *open_file, *inv_file =3D NULL;
 	struct cifs_sb_info *cifs_sb;
-	struct cifs_tcon *tcon;
 	bool any_available =3D false;
 	int rc;
 	unsigned int refind =3D 0;
@@ -1807,16 +1805,15 @@ struct cifsFileInfo *find_writable_file(struct cifs=
InodeInfo *cifs_inode,
 	}
=20
 	cifs_sb =3D CIFS_SB(cifs_inode->vfs_inode.i_sb);
-	tcon =3D cifs_sb_master_tcon(cifs_sb);
=20
 	/* only filter by fsuid on multiuser mounts */
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
 		fsuid_only =3D false;
=20
-	spin_lock(&tcon->open_file_lock);
+	spin_lock(&cifs_inode->open_file_lock);
 refind_writable:
 	if (refind > MAX_REOPEN_ATT) {
-		spin_unlock(&tcon->open_file_lock);
+		spin_unlock(&cifs_inode->open_file_lock);
 		return NULL;
 	}
 	list_for_each_entry(open_file, &cifs_inode->openFileList, flist) {
@@ -1828,7 +1825,7 @@ struct cifsFileInfo *find_writable_file(struct cifsIn=
odeInfo *cifs_inode,
 			if (!open_file->invalidHandle) {
 				/* found a good writable file */
 				cifsFileInfo_get(open_file);
-				spin_unlock(&tcon->open_file_lock);
+				spin_unlock(&cifs_inode->open_file_lock);
 				return open_file;
 			} else {
 				if (!inv_file)
@@ -1847,7 +1844,7 @@ struct cifsFileInfo *find_writable_file(struct cifsIn=
odeInfo *cifs_inode,
 		cifsFileInfo_get(inv_file);
 	}
=20
-	spin_unlock(&tcon->open_file_lock);
+	spin_unlock(&cifs_inode->open_file_lock);
=20
 	if (inv_file) {
 		rc =3D cifs_reopen_file(inv_file, false);
@@ -1861,7 +1858,7 @@ struct cifsFileInfo *find_writable_file(struct cifsIn=
odeInfo *cifs_inode,
 			cifsFileInfo_put(inv_file);
 			++refind;
 			inv_file =3D NULL;
-			spin_lock(&tcon->open_file_lock);
+			spin_lock(&cifs_inode->open_file_lock);
 			goto refind_writable;
 		}
 	}
@@ -3508,17 +3505,15 @@ static int cifs_readpage(struct file *file, struct =
page *page)
 static int is_inode_writable(struct cifsInodeInfo *cifs_inode)
 {
 	struct cifsFileInfo *open_file;
-	struct cifs_tcon *tcon =3D
-		cifs_sb_master_tcon(CIFS_SB(cifs_inode->vfs_inode.i_sb));
=20
-	spin_lock(&tcon->open_file_lock);
+	spin_lock(&cifs_inode->open_file_lock);
 	list_for_each_entry(open_file, &cifs_inode->openFileList, flist) {
 		if (OPEN_FMODE(open_file->f_flags) & FMODE_WRITE) {
-			spin_unlock(&tcon->open_file_lock);
+			spin_unlock(&cifs_inode->open_file_lock);
 			return 1;
 		}
 	}
-	spin_unlock(&tcon->open_file_lock);
+	spin_unlock(&cifs_inode->open_file_lock);
 	return 0;
 }
=20
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 9e432368485d..ac1dd5564896 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -171,7 +171,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *t=
con)
 	if (tcon =3D=3D NULL)
 		return 0;
=20
-	if (smb2_command =3D=3D SMB2_TREE_CONNECT)
+	if (smb2_command =3D=3D SMB2_TREE_CONNECT || smb2_command =3D=3D SMB2_IOC=
TL)
 		return 0;
=20
 	if (tcon->tidStatus =3D=3D CifsExiting) {
@@ -646,7 +646,12 @@ SMB2_sess_setup(const unsigned int xid, struct cifs_se=
s *ses,
 	else
 		req->SecurityMode =3D 0;
=20
+#ifdef CONFIG_CIFS_DFS_UPCALL
+	req->Capabilities =3D cpu_to_le32(SMB2_GLOBAL_CAP_DFS);
+#else
 	req->Capabilities =3D 0;
+#endif /* DFS_UPCALL */
+
 	req->Channel =3D 0; /* MBZ */
=20
 	iov[0].iov_base =3D (char *)req;
diff --git a/fs/exec.c b/fs/exec.c
index 2acff9b648c0..077f85439264 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1589,7 +1589,7 @@ static int do_execve_common(struct filename *filename,
 	current->fs->in_exec =3D 0;
 	current->in_execve =3D 0;
 	acct_update_integrals(current);
-	task_numa_free(current);
+	task_numa_free(current, false);
 	free_bprm(bprm);
 	putname(filename);
 	if (displaced)
diff --git a/fs/nfs/nfs4_fs.h b/fs/nfs/nfs4_fs.h
index b8ea4a26998c..d2b17432f15c 100644
--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -419,7 +419,8 @@ static inline void nfs4_schedule_session_recovery(struc=
t nfs4_session *session,
=20
 extern struct nfs4_state_owner *nfs4_get_state_owner(struct nfs_server *, =
struct rpc_cred *, gfp_t);
 extern void nfs4_put_state_owner(struct nfs4_state_owner *);
-extern void nfs4_purge_state_owners(struct nfs_server *);
+extern void nfs4_purge_state_owners(struct nfs_server *, struct list_head =
*);
+extern void nfs4_free_state_owners(struct list_head *head);
 extern struct nfs4_state * nfs4_get_open_state(struct inode *, struct nfs4=
_state_owner *);
 extern void nfs4_put_open_state(struct nfs4_state *);
 extern void nfs4_close_state(struct nfs4_state *, fmode_t);
diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index 1b171b81e7db..7696a3857e72 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -682,9 +682,12 @@ int nfs41_walk_client_list(struct nfs_client *new,
=20
 static void nfs4_destroy_server(struct nfs_server *server)
 {
+	LIST_HEAD(freeme);
+
 	nfs_server_return_all_delegations(server);
 	unset_pnfs_layoutdriver(server);
-	nfs4_purge_state_owners(server);
+	nfs4_purge_state_owners(server, &freeme);
+	nfs4_free_state_owners(&freeme);
 }
=20
 /*
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 80c499433269..6d8d618069ad 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -598,24 +598,39 @@ void nfs4_put_state_owner(struct nfs4_state_owner *sp)
 /**
  * nfs4_purge_state_owners - Release all cached state owners
  * @server: nfs_server with cached state owners to release
+ * @head: resulting list of state owners
  *
  * Called at umount time.  Remaining state owners will be on
  * the LRU with ref count of zero.
+ * Note that the state owners are not freed, but are added
+ * to the list @head, which can later be used as an argument
+ * to nfs4_free_state_owners.
  */
-void nfs4_purge_state_owners(struct nfs_server *server)
+void nfs4_purge_state_owners(struct nfs_server *server, struct list_head *=
head)
 {
 	struct nfs_client *clp =3D server->nfs_client;
 	struct nfs4_state_owner *sp, *tmp;
-	LIST_HEAD(doomed);
=20
 	spin_lock(&clp->cl_lock);
 	list_for_each_entry_safe(sp, tmp, &server->state_owners_lru, so_lru) {
-		list_move(&sp->so_lru, &doomed);
+		list_move(&sp->so_lru, head);
 		nfs4_remove_state_owner_locked(sp);
 	}
 	spin_unlock(&clp->cl_lock);
+}
=20
-	list_for_each_entry_safe(sp, tmp, &doomed, so_lru) {
+/**
+ * nfs4_purge_state_owners - Release all cached state owners
+ * @head: resulting list of state owners
+ *
+ * Frees a list of state owners that was generated by
+ * nfs4_purge_state_owners
+ */
+void nfs4_free_state_owners(struct list_head *head)
+{
+	struct nfs4_state_owner *sp, *tmp;
+
+	list_for_each_entry_safe(sp, tmp, head, so_lru) {
 		list_del(&sp->so_lru);
 		nfs4_free_state_owner(sp);
 	}
@@ -1719,12 +1734,13 @@ static int nfs4_do_reclaim(struct nfs_client *clp, =
const struct nfs4_state_recov
 	struct nfs4_state_owner *sp;
 	struct nfs_server *server;
 	struct rb_node *pos;
+	LIST_HEAD(freeme);
 	int status =3D 0;
=20
 restart:
 	rcu_read_lock();
 	list_for_each_entry_rcu(server, &clp->cl_superblocks, client_link) {
-		nfs4_purge_state_owners(server);
+		nfs4_purge_state_owners(server, &freeme);
 		spin_lock(&clp->cl_lock);
 		for (pos =3D rb_first(&server->state_owners);
 		     pos !=3D NULL;
@@ -1752,6 +1768,7 @@ static int nfs4_do_reclaim(struct nfs_client *clp, co=
nst struct nfs4_state_recov
 		spin_unlock(&clp->cl_lock);
 	}
 	rcu_read_unlock();
+	nfs4_free_state_owners(&freeme);
 	return 0;
 }
=20
diff --git a/include/asm-generic/getorder.h b/include/asm-generic/getorder.h
index 65e4468ac53d..52fbf236a90e 100644
--- a/include/asm-generic/getorder.h
+++ b/include/asm-generic/getorder.h
@@ -6,24 +6,6 @@
 #include <linux/compiler.h>
 #include <linux/log2.h>
=20
-/*
- * Runtime evaluation of get_order()
- */
-static inline __attribute_const__
-int __get_order(unsigned long size)
-{
-	int order;
-
-	size--;
-	size >>=3D PAGE_SHIFT;
-#if BITS_PER_LONG =3D=3D 32
-	order =3D fls(size);
-#else
-	order =3D fls64(size);
-#endif
-	return order;
-}
-
 /**
  * get_order - Determine the allocation order of a memory size
  * @size: The size for which to get the order
@@ -42,19 +24,27 @@ int __get_order(unsigned long size)
  * to hold an object of the specified size.
  *
  * The result is undefined if the size is 0.
- *
- * This function may be used to initialise variables with compile time
- * evaluations of constants.
  */
-#define get_order(n)						\
-(								\
-	__builtin_constant_p(n) ? (				\
-		((n) =3D=3D 0UL) ? BITS_PER_LONG - PAGE_SHIFT :	\
-		(((n) < (1UL << PAGE_SHIFT)) ? 0 :		\
-		 ilog2((n) - 1) - PAGE_SHIFT + 1)		\
-	) :							\
-	__get_order(n)						\
-)
+static inline __attribute_const__ int get_order(unsigned long size)
+{
+	if (__builtin_constant_p(size)) {
+		if (!size)
+			return BITS_PER_LONG - PAGE_SHIFT;
+
+		if (size < (1UL << PAGE_SHIFT))
+			return 0;
+
+		return ilog2((size) - 1) - PAGE_SHIFT + 1;
+	}
+
+	size--;
+	size >>=3D PAGE_SHIFT;
+#if BITS_PER_LONG =3D=3D 32
+	return fls(size);
+#else
+	return fls64(size);
+#endif
+}
=20
 #endif	/* __ASSEMBLY__ */
=20
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 754a7cb0699e..bcd8b1664301 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1671,7 +1671,7 @@ struct task_struct {
 extern void task_numa_fault(int last_node, int node, int pages, int flags);
 extern pid_t task_numa_group_id(struct task_struct *p);
 extern void set_numabalancing_state(bool enabled);
-extern void task_numa_free(struct task_struct *p);
+extern void task_numa_free(struct task_struct *p, bool final);
 extern bool should_numa_migrate_memory(struct task_struct *p, struct page =
*page,
 					int src_nid, int dst_cpu);
 #else
@@ -1686,7 +1686,7 @@ static inline pid_t task_numa_group_id(struct task_st=
ruct *p)
 static inline void set_numabalancing_state(bool enabled)
 {
 }
-static inline void task_numa_free(struct task_struct *p)
+static inline void task_numa_free(struct task_struct *p, bool final)
 {
 }
 static inline bool should_numa_migrate_memory(struct task_struct *p,
diff --git a/include/sound/compress_driver.h b/include/sound/compress_drive=
r.h
index d81bc1396142..b20d1547be1b 100644
--- a/include/sound/compress_driver.h
+++ b/include/sound/compress_driver.h
@@ -176,10 +176,7 @@ static inline void snd_compr_drain_notify(struct snd_c=
ompr_stream *stream)
 	if (snd_BUG_ON(!stream))
 		return;
=20
-	if (stream->direction =3D=3D SND_COMPRESS_PLAYBACK)
-		stream->runtime->state =3D SNDRV_PCM_STATE_SETUP;
-	else
-		stream->runtime->state =3D SNDRV_PCM_STATE_PREPARED;
+	stream->runtime->state =3D SNDRV_PCM_STATE_SETUP;
=20
 	wake_up(&stream->runtime->sleep);
 }
diff --git a/kernel/fork.c b/kernel/fork.c
index 7dc86b50f925..2efc7a650c54 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -242,7 +242,7 @@ void __put_task_struct(struct task_struct *tsk)
 	WARN_ON(atomic_read(&tsk->usage));
 	WARN_ON(tsk =3D=3D current);
=20
-	task_numa_free(tsk);
+	task_numa_free(tsk, true);
 	security_task_free(tsk);
 	exit_creds(tsk);
 	delayacct_tsk_free(tsk);
diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c
index 7a5237a1bce5..7f8456d07954 100644
--- a/kernel/irq/resend.c
+++ b/kernel/irq/resend.c
@@ -37,6 +37,8 @@ static void resend_irqs(unsigned long arg)
 		irq =3D find_first_bit(irqs_resend, nr_irqs);
 		clear_bit(irq, irqs_resend);
 		desc =3D irq_to_desc(irq);
+		if (!desc)
+			continue;
 		local_irq_disable();
 		desc->handle_irq(irq, desc);
 		local_irq_enable();
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f967ff776e5b..ea2d33aa1f55 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1747,13 +1747,23 @@ static void task_numa_group(struct task_struct *p, =
int cpupid, int flags,
 	return;
 }
=20
-void task_numa_free(struct task_struct *p)
+/*
+ * Get rid of NUMA staticstics associated with a task (either current or d=
ead).
+ * If @final is set, the task is dead and has reached refcount zero, so we=
 can
+ * safely free all relevant data structures. Otherwise, there might be
+ * concurrent reads from places like load balancing and procfs, and we sho=
uld
+ * reset the data back to default state without freeing ->numa_faults.
+ */
+void task_numa_free(struct task_struct *p, bool final)
 {
 	struct numa_group *grp =3D p->numa_group;
-	void *numa_faults =3D p->numa_faults_memory;
+	unsigned long *numa_faults =3D p->numa_faults_memory;
 	unsigned long flags;
 	int i;
=20
+	if (!numa_faults)
+		return;
+
 	if (grp) {
 		spin_lock_irqsave(&grp->lock, flags);
 		for (i =3D 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++)
@@ -1767,11 +1777,17 @@ void task_numa_free(struct task_struct *p)
 		put_numa_group(grp);
 	}
=20
-	p->numa_faults_memory =3D NULL;
-	p->numa_faults_buffer_memory =3D NULL;
-	p->numa_faults_cpu=3D NULL;
-	p->numa_faults_buffer_cpu =3D NULL;
-	kfree(numa_faults);
+	if (final) {
+		p->numa_faults_memory =3D NULL;
+		p->numa_faults_buffer_memory =3D NULL;
+		p->numa_faults_cpu =3D NULL;
+		p->numa_faults_buffer_cpu =3D NULL;
+		kfree(numa_faults);
+	} else {
+		p->total_numa_faults =3D 0;
+		for (i =3D 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++)
+			numa_faults[i] =3D 0;
+	}
 }
=20
 /*
@@ -3255,6 +3271,8 @@ static void __account_cfs_rq_runtime(struct cfs_rq *c=
fs_rq, u64 delta_exec)
 	if (likely(cfs_rq->runtime_remaining > 0))
 		return;
=20
+	if (cfs_rq->throttled)
+		return;
 	/*
 	 * if we're unable to extend our runtime we resched so that the active
 	 * hierarchy can be throttled
@@ -3434,6 +3452,11 @@ static u64 distribute_cfs_runtime(struct cfs_bandwid=
th *cfs_b,
 		if (!cfs_rq_throttled(cfs_rq))
 			goto next;
=20
+		/* By the above check, this should never be true */
+#ifdef CONFIG_SCHED_DEBUG
+		WARN_ON_ONCE(cfs_rq->runtime_remaining > 0);
+#endif
+
 		runtime =3D -cfs_rq->runtime_remaining + 1;
 		if (runtime > remaining)
 			runtime =3D remaining;
diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 8c65c236f26a..c3fc69986850 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -533,7 +533,7 @@ static int alarm_timer_create(struct k_itimer *new_time=
r)
 	struct alarm_base *base;
=20
 	if (!alarmtimer_get_rtcdev())
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
=20
 	if (!capable(CAP_WAKE_ALARM))
 		return -EPERM;
@@ -576,7 +576,7 @@ static void alarm_timer_get(struct k_itimer *timr,
 static int alarm_timer_del(struct k_itimer *timr)
 {
 	if (!rtcdev)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
=20
 	if (alarm_try_to_cancel(&timr->it.alarm.alarmtimer) < 0)
 		return TIMER_RETRY;
@@ -600,7 +600,7 @@ static int alarm_timer_set(struct k_itimer *timr, int f=
lags,
 	ktime_t exp;
=20
 	if (!rtcdev)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
=20
 	if (flags & ~TIMER_ABSTIME)
 		return -EINVAL;
@@ -761,7 +761,7 @@ static int alarm_timer_nsleep(const clockid_t which_clo=
ck, int flags,
 	struct restart_block *restart;
=20
 	if (!alarmtimer_get_rtcdev())
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
=20
 	if (flags & ~TIMER_ABSTIME)
 		return -EINVAL;
diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index 12090b307e9c..b5783804c90f 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -395,13 +395,19 @@ static uint8_t batadv_hop_penalty(uint8_t tq,
 }
=20
 /* is there another aggregated packet here? */
-static int batadv_iv_ogm_aggr_packet(int buff_pos, int packet_len,
-				     __be16 tvlv_len)
+static bool
+batadv_iv_ogm_aggr_packet(int buff_pos, int packet_len,
+			  const struct batadv_ogm_packet *ogm_packet)
 {
 	int next_buff_pos =3D 0;
=20
-	next_buff_pos +=3D buff_pos + BATADV_OGM_HLEN;
-	next_buff_pos +=3D ntohs(tvlv_len);
+	/* check if there is enough space for the header */
+	next_buff_pos +=3D buff_pos + sizeof(*ogm_packet);
+	if (next_buff_pos > packet_len)
+		return false;
+
+	/* check if there is enough space for the optional TVLV */
+	next_buff_pos +=3D ntohs(ogm_packet->tvlv_len);
=20
 	return (next_buff_pos <=3D packet_len) &&
 	       (next_buff_pos <=3D BATADV_MAX_AGGREGATION_BYTES);
@@ -429,7 +435,7 @@ static void batadv_iv_ogm_send_to_if(struct batadv_forw=
_packet *forw_packet,
=20
 	/* adjust all flags and log packets */
 	while (batadv_iv_ogm_aggr_packet(buff_pos, forw_packet->packet_len,
-					 batadv_ogm_packet->tvlv_len)) {
+					 batadv_ogm_packet)) {
 		/* we might have aggregated direct link packets with an
 		 * ordinary base packet
 		 */
@@ -1745,7 +1751,7 @@ static int batadv_iv_ogm_receive(struct sk_buff *skb,
=20
 	/* unpack the aggregated packets and process them one by one */
 	while (batadv_iv_ogm_aggr_packet(ogm_offset, skb_headlen(skb),
-					 ogm_packet->tvlv_len)) {
+					 ogm_packet)) {
 		batadv_iv_ogm_process(skb, ogm_offset, if_incoming);
=20
 		ogm_offset +=3D BATADV_OGM_HLEN;
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 7725dd99fdc6..231b0a1e1a99 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1471,6 +1471,9 @@ br_multicast_leave_group(struct net_bridge *br,
 			if (p->port !=3D port)
 				continue;
=20
+			if (p->state & MDB_PERMANENT)
+				break;
+
 			rcu_assign_pointer(*pp, p->next);
 			hlist_del_init(&p->mglist);
 			del_timer(&p->timer);
diff --git a/net/core/dev.c b/net/core/dev.c
index 89c31f085ea2..4c821b721713 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6278,6 +6278,8 @@ int register_netdevice(struct net_device *dev)
 	ret =3D notifier_to_errno(ret);
 	if (ret) {
 		rollback_registered(dev);
+		rcu_barrier();
+
 		dev->reg_state =3D NETREG_UNREGISTERED;
 	}
 	/*
@@ -7207,6 +7209,8 @@ static void __net_exit default_device_exit(struct net=
 *net)
=20
 		/* Push remaining network devices to init_net */
 		snprintf(fb_name, IFNAMSIZ, "dev%d", dev->ifindex);
+		if (__dev_get_by_name(&init_net, fb_name))
+			snprintf(fb_name, IFNAMSIZ, "dev%%d");
 		err =3D dev_change_net_namespace(dev, &init_net, fb_name);
 		if (err) {
 			pr_emerg("%s: failed to move %s to init_net: %d\n",
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index e605b1fd116b..a42b6671d542 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -214,7 +214,7 @@ static inline void TCP_ECN_accept_cwr(struct tcp_sock *=
tp, const struct sk_buff
=20
 static inline void TCP_ECN_withdraw_cwr(struct tcp_sock *tp)
 {
-	tp->ecn_flags &=3D ~TCP_ECN_DEMAND_CWR;
+	tp->ecn_flags &=3D ~TCP_ECN_QUEUE_CWR;
 }
=20
 static inline void TCP_ECN_check_ce(struct tcp_sock *tp, const struct sk_b=
uff *skb)
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 5c2113badee3..48c799273a97 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -807,12 +807,13 @@ static void mld_del_delrec(struct inet6_dev *idev, st=
ruct ifmcaddr6 *im)
 		im->idev =3D pmc->idev;
 		im->mca_crcount =3D idev->mc_qrv;
 		if (im->mca_sfmode =3D=3D MCAST_INCLUDE) {
-			im->mca_tomb =3D pmc->mca_tomb;
-			im->mca_sources =3D pmc->mca_sources;
+			swap(im->mca_tomb, pmc->mca_tomb);
+			swap(im->mca_sources, pmc->mca_sources);
 			for (psf =3D im->mca_sources; psf; psf =3D psf->sf_next)
 				psf->sf_crcount =3D im->mca_crcount;
 		}
 		in6_dev_put(pmc->idev);
+		ip6_mc_clear_src(pmc);
 		kfree(pmc);
 	}
 	spin_unlock_bh(&im->mca_lock);
diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index 50bb5e5c99c1..c91652477194 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -230,7 +230,7 @@ static int __net_init ping_v6_proc_init_net(struct net =
*net)
 	return ping_proc_register(net, &ping_v6_seq_afinfo);
 }
=20
-static void __net_init ping_v6_proc_exit_net(struct net *net)
+static void __net_exit ping_v6_proc_exit_net(struct net *net)
 {
 	return ping_proc_unregister(net, &ping_v6_seq_afinfo);
 }
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack=
_core.c
index 170681b21d25..5c991ce35123 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -240,13 +240,12 @@ EXPORT_SYMBOL_GPL(nf_ct_invert_tuple);
  * table location, we assume id gets exposed to userspace.
  *
  * Following nf_conn items do not change throughout lifetime
- * of the nf_conn after it has been committed to main hash table:
+ * of the nf_conn:
  *
  * 1. nf_conn address
- * 2. nf_conn->ext address
- * 3. nf_conn->master address (normally NULL)
- * 4. tuple
- * 5. the associated net namespace
+ * 2. nf_conn->master address (normally NULL)
+ * 3. the associated net namespace
+ * 4. the original direction tuple
  */
 u32 nf_ct_get_id(const struct nf_conn *ct)
 {
@@ -256,9 +255,10 @@ u32 nf_ct_get_id(const struct nf_conn *ct)
 	net_get_random_once(&ct_id_seed, sizeof(ct_id_seed));
=20
 	a =3D (unsigned long)ct;
-	b =3D (unsigned long)ct->master ^ net_hash_mix(nf_ct_net(ct));
-	c =3D (unsigned long)ct->ext;
-	d =3D (unsigned long)siphash(&ct->tuplehash, sizeof(ct->tuplehash),
+	b =3D (unsigned long)ct->master;
+	c =3D (unsigned long)nf_ct_net(ct);
+	d =3D (unsigned long)siphash(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
+				   sizeof(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple),
 				   &ct_id_seed);
 #ifdef CONFIG_64BIT
 	return siphash_4u64((u64)a, (u64)b, (u64)c, (u64)d, &ct_id_seed);
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 0777d98d3dec..2ba9b1a03229 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2286,6 +2286,13 @@ static int tpacket_snd(struct packet_sock *po, struc=
t msghdr *msg)
=20
 	mutex_lock(&po->pg_vec_lock);
=20
+	/* packet_sendmsg() check on tx_ring.pg_vec was lockless,
+	 * we need to confirm it under protection of pg_vec_lock.
+	 */
+	if (unlikely(!po->tx_ring.pg_vec)) {
+		err =3D -EBUSY;
+		goto out;
+	}
 	if (likely(saddr =3D=3D NULL)) {
 		dev	=3D packet_cached_dev_get(po);
 		proto	=3D po->num;
diff --git a/net/sched/sch_codel.c b/net/sched/sch_codel.c
index ebdb01fbdd24..ac28ce7c8c07 100644
--- a/net/sched/sch_codel.c
+++ b/net/sched/sch_codel.c
@@ -68,7 +68,8 @@ static struct sk_buff *dequeue(struct codel_vars *vars, s=
truct Qdisc *sch)
 {
 	struct sk_buff *skb =3D __skb_dequeue(&sch->q);
=20
-	prefetch(&skb->end); /* we'll need skb_shinfo() */
+	if (skb)
+		prefetch(&skb->end); /* we'll need skb_shinfo() */
 	return skb;
 }
=20
diff --git a/net/sched/sch_hhf.c b/net/sched/sch_hhf.c
index 33cf9e5ae352..2facd536d7a8 100644
--- a/net/sched/sch_hhf.c
+++ b/net/sched/sch_hhf.c
@@ -560,7 +560,7 @@ static int hhf_change(struct Qdisc *sch, struct nlattr =
*opt)
 		new_hhf_non_hh_weight =3D nla_get_u32(tb[TCA_HHF_NON_HH_WEIGHT]);
=20
 	non_hh_quantum =3D (u64)new_quantum * new_hhf_non_hh_weight;
-	if (non_hh_quantum > INT_MAX)
+	if (non_hh_quantum =3D=3D 0 || non_hh_quantum > INT_MAX)
 		return -EINVAL;
=20
 	sch_tree_lock(sch);
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index eccd9ebc5ebd..17cf4a4d4832 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1314,7 +1314,7 @@ static int __net_init sctp_ctrlsock_init(struct net *=
net)
 	return status;
 }
=20
-static void __net_init sctp_ctrlsock_exit(struct net *net)
+static void __net_exit sctp_ctrlsock_exit(struct net *net)
 {
 	/* Free the control endpoint.  */
 	inet_ctl_sock_destroy(net->sctp.ctl_sock);
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 4bfa6070ae68..5e30bdce1d21 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -504,8 +504,8 @@ static void sctp_do_8_2_transport_strike(sctp_cmd_seq_t=
 *commands,
 	 * see SCTP Quick Failover Draft, section 5.1
 	 */
 	if ((transport->state =3D=3D SCTP_ACTIVE) &&
-	   (asoc->pf_retrans < transport->pathmaxrxt) &&
-	   (transport->error_count > asoc->pf_retrans)) {
+	   (transport->error_count < transport->pathmaxrxt) &&
+	   (transport->error_count > transport->pf_retrans)) {
=20
 		sctp_assoc_control_transport(asoc, transport,
 					     SCTP_TRANSPORT_PF,
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 22a6387b3bcc..659e32ec2e31 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1913,7 +1913,7 @@ static void reg_process_pending_hints(void)
=20
 	/* When last_request->processed becomes true this will be rescheduled */
 	if (lr && !lr->processed) {
-		reg_process_hint(lr);
+		pr_debug("Pending regulatory request, waiting for it to be processed...\=
n");
 		return;
 	}
=20
diff --git a/security/keys/request_key_auth.c b/security/keys/request_key_a=
uth.c
index ac4a90b494e6..6aff292ca167 100644
--- a/security/keys/request_key_auth.c
+++ b/security/keys/request_key_auth.c
@@ -58,6 +58,9 @@ static void request_key_auth_describe(const struct key *k=
ey,
 {
 	struct request_key_auth *rka =3D key->payload.data;
=20
+	if (!rka)
+		return;
+
 	seq_puts(m, "key:");
 	seq_puts(m, key->description);
 	if (key_is_instantiated(key))
@@ -75,6 +78,9 @@ static long request_key_auth_read(const struct key *key,
 	size_t datalen;
 	long ret;
=20
+	if (!rka)
+		return -EKEYREVOKED;
+
 	datalen =3D rka->callout_len;
 	ret =3D datalen;
=20
diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
index 9c5cdc2caaef..bf953e976c33 100644
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -261,6 +261,8 @@ static int rangetr_cmp(struct hashtab *h, const void *k=
1, const void *k2)
 	return v;
 }
=20
+static int (*destroy_f[SYM_NUM]) (void *key, void *datum, void *datap);
+
 /*
  * Initialize a policy database structure.
  */
@@ -304,8 +306,10 @@ static int policydb_init(struct policydb *p)
 out:
 	hashtab_destroy(p->filename_trans);
 	hashtab_destroy(p->range_tr);
-	for (i =3D 0; i < SYM_NUM; i++)
+	for (i =3D 0; i < SYM_NUM; i++) {
+		hashtab_map(p->symtab[i].table, destroy_f[i], NULL);
 		hashtab_destroy(p->symtab[i].table);
+	}
 	return rc;
 }
=20
diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index 53cd5d69293e..bbb42b34e2fb 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -549,10 +549,7 @@ snd_compr_set_params(struct snd_compr_stream *stream, =
unsigned long arg)
 		stream->metadata_set =3D false;
 		stream->next_track =3D false;
=20
-		if (stream->direction =3D=3D SND_COMPRESS_PLAYBACK)
-			stream->runtime->state =3D SNDRV_PCM_STATE_SETUP;
-		else
-			stream->runtime->state =3D SNDRV_PCM_STATE_PREPARED;
+		stream->runtime->state =3D SNDRV_PCM_STATE_SETUP;
 	} else {
 		return -EPERM;
 	}
@@ -668,8 +665,17 @@ static int snd_compr_start(struct snd_compr_stream *st=
ream)
 {
 	int retval;
=20
-	if (stream->runtime->state !=3D SNDRV_PCM_STATE_PREPARED)
+	switch (stream->runtime->state) {
+	case SNDRV_PCM_STATE_SETUP:
+		if (stream->direction !=3D SND_COMPRESS_CAPTURE)
+			return -EPERM;
+		break;
+	case SNDRV_PCM_STATE_PREPARED:
+		break;
+	default:
 		return -EPERM;
+	}
+
 	retval =3D stream->ops->trigger(stream, SNDRV_PCM_TRIGGER_START);
 	if (!retval)
 		stream->runtime->state =3D SNDRV_PCM_STATE_RUNNING;
diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmgr.c
index 049d61e77f66..f6e8b2e60eec 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -1911,8 +1911,7 @@ static int snd_seq_ioctl_get_client_pool(struct snd_s=
eq_client *client,
 	if (cptr->type =3D=3D USER_CLIENT) {
 		info.input_pool =3D cptr->data.user.fifo_pool_size;
 		info.input_free =3D info.input_pool;
-		if (cptr->data.user.fifo)
-			info.input_free =3D snd_seq_unused_cells(cptr->data.user.fifo->pool);
+		info.input_free =3D snd_seq_fifo_unused_cells(cptr->data.user.fifo);
 	} else {
 		info.input_pool =3D 0;
 		info.input_free =3D 0;
diff --git a/sound/core/seq/seq_fifo.c b/sound/core/seq/seq_fifo.c
index 9acbed1ac982..d9f5428ee995 100644
--- a/sound/core/seq/seq_fifo.c
+++ b/sound/core/seq/seq_fifo.c
@@ -278,3 +278,20 @@ int snd_seq_fifo_resize(struct snd_seq_fifo *f, int po=
olsize)
=20
 	return 0;
 }
+
+/* get the number of unused cells safely */
+int snd_seq_fifo_unused_cells(struct snd_seq_fifo *f)
+{
+	unsigned long flags;
+	int cells;
+
+	if (!f)
+		return 0;
+
+	snd_use_lock_use(&f->use_lock);
+	spin_lock_irqsave(&f->lock, flags);
+	cells =3D snd_seq_unused_cells(f->pool);
+	spin_unlock_irqrestore(&f->lock, flags);
+	snd_use_lock_free(&f->use_lock);
+	return cells;
+}
diff --git a/sound/core/seq/seq_fifo.h b/sound/core/seq/seq_fifo.h
index 062c446e7867..5d38a0d7f0cd 100644
--- a/sound/core/seq/seq_fifo.h
+++ b/sound/core/seq/seq_fifo.h
@@ -68,5 +68,7 @@ int snd_seq_fifo_poll_wait(struct snd_seq_fifo *f, struct=
 file *file, poll_table
 /* resize pool in fifo */
 int snd_seq_fifo_resize(struct snd_seq_fifo *f, int poolsize);
=20
+/* get the number of unused cells safely */
+int snd_seq_fifo_unused_cells(struct snd_seq_fifo *f);
=20
 #endif
diff --git a/sound/firewire/packets-buffer.c b/sound/firewire/packets-buffe=
r.c
index ea1506679c66..3b09b8ef3a09 100644
--- a/sound/firewire/packets-buffer.c
+++ b/sound/firewire/packets-buffer.c
@@ -37,7 +37,7 @@ int iso_packets_buffer_init(struct iso_packets_buffer *b,=
 struct fw_unit *unit,
 	packets_per_page =3D PAGE_SIZE / packet_size;
 	if (WARN_ON(!packets_per_page)) {
 		err =3D -EINVAL;
-		goto error;
+		goto err_packets;
 	}
 	pages =3D DIV_ROUND_UP(count, packets_per_page);
=20
diff --git a/sound/pci/hda/hda_auto_parser.c b/sound/pci/hda/hda_auto_parse=
r.c
index dabe41975a9d..e3d30cef17ad 100644
--- a/sound/pci/hda/hda_auto_parser.c
+++ b/sound/pci/hda/hda_auto_parser.c
@@ -787,6 +787,8 @@ static void apply_fixup(struct hda_codec *codec, int id=
, int action, int depth)
 	while (id >=3D 0) {
 		const struct hda_fixup *fix =3D codec->fixup_list + id;
=20
+		if (++depth > 10)
+			break;
 		if (fix->chained_before)
 			apply_fixup(codec, fix->chain_id, action, depth + 1);
=20
@@ -826,8 +828,6 @@ static void apply_fixup(struct hda_codec *codec, int id=
, int action, int depth)
 		}
 		if (!fix->chained || fix->chained_before)
 			break;
-		if (++depth > 10)
-			break;
 		id =3D fix->chain_id;
 	}
 }
diff --git a/sound/pci/hda/hda_generic.c b/sound/pci/hda/hda_generic.c
index caeca8371c9b..b92bca9c53d9 100644
--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -5431,7 +5431,7 @@ int snd_hda_parse_generic_codec(struct hda_codec *cod=
ec)
=20
 	err =3D snd_hda_parse_pin_defcfg(codec, &spec->autocfg, NULL, 0);
 	if (err < 0)
-		return err;
+		goto error;
=20
 	err =3D snd_hda_gen_parse_auto_config(codec, &spec->autocfg);
 	if (err < 0)
diff --git a/sound/sound_core.c b/sound/sound_core.c
index 11e953a1fa45..7ecc2249bfa9 100644
--- a/sound/sound_core.c
+++ b/sound/sound_core.c
@@ -287,7 +287,8 @@ static int sound_insert_unit(struct sound_unit **list, =
const struct file_operati
 				goto retry;
 			}
 			spin_unlock(&sound_loader_lock);
-			return -EBUSY;
+			r =3D -EBUSY;
+			goto fail;
 		}
 	}
=20

--h31gzZEtNLTqOjlF--

--24zk1gE8NUlDmwG9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl3ZQOkACgkQ57/I7JWG
EQmWThAAjpsX1Mg0Q3Tmt68ndUkMTx6QPtSHpmanDFRPE6qpEynrtQEawBtmCT4X
6P7CxKakhjdzlGSug2eR0TICnzT4OjcEHBdbBmWF1bq0nyE31xEyKUKC/esMlhGd
vwBtSB+vX4md0rA54/ej7AE1C91ZOELMmpq18P1ZkAEjRflQMzDu62KbMyS0Y5Tw
F6dpulQDwNZBYAq/PBzcmJ8uXFDmVxjOdg/bwOHDyWaQY2tpCjYwFSTY2tC2y1RA
tibvwtaQ0c3owM9s/7UAVKttkYJe5TkEtM9jCnWJDrX5eU4KtO6eirRzhZHvVn9v
sZ3ioP4/xsvm7mbOsW58YHmQc53+xwCBsRkOe7TuhjDj1cWdZg4DVJyjK6mfLU0A
gDHr5WWHbriw7eggewyF7gwHD7n2X3gQYM7eMyL4hHvC9xQCkkCIr0mhFe63tCJm
BEeLQIDPUDwbgGEk82LQ4S5u5PpnBIWTfjiJZVN3tAd3wjIKHzoH7JiKuMUHzOWR
S3tS0YsQnHXil7lw7h+nokBetGTR37K+VMMeXmK5Xwr19HrJF8Iwi+5mAXaph+kk
quMFt0jfeMeqDLHVixrXGwGvFEfAkrs5K32bBkXgjTdHcBisUw3OBZlfcLAqk0NE
qK217Q/3Zvq7kJBdp6qRfyAFGDw/q489YEw4MsvcZ6jaX0Kyxb8=
=oPtv
-----END PGP SIGNATURE-----

--24zk1gE8NUlDmwG9--
