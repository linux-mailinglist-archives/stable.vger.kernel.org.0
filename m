Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87D4F13812F
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 12:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728749AbgAKLpH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 06:45:07 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34924 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729436AbgAKLpG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jan 2020 06:45:06 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iqFCQ-0007Fe-1n; Sat, 11 Jan 2020 11:45:02 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1iqFCP-007mNi-Ga; Sat, 11 Jan 2020 11:45:01 +0000
Date:   Sat, 11 Jan 2020 11:45:01 +0000
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc:     lwn@lwn.net
Subject: Linux 3.16.81
Message-ID: <lsq.1578743059.186526847@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="aM3YZ0Iwxop3KEKx"
Content-Disposition: inline
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--aM3YZ0Iwxop3KEKx
Content-Type: multipart/mixed; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.16.81 kernel.

All users of the 3.16 kernel series should upgrade.

The updated 3.16.y git tree can be found at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.16.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git

The diff from 3.16.80 is attached to this message.

Ben.

------------

 Makefile                                          |   2 +-
 arch/arm/Kconfig                                  |   6 +-
 arch/arm64/Kconfig                                |   5 +-
 arch/arm64/include/asm/page.h                     |   2 +
 arch/arm64/include/asm/shmparam.h                 |   2 +-
 arch/arm64/kernel/entry.S                         |   2 +-
 arch/arm64/kernel/kgdb.c                          |  15 +-
 arch/arm64/kernel/traps.c                         |   8 +-
 arch/arm64/mm/fault.c                             |  36 +++--
 arch/tile/lib/atomic_asm_32.S                     |   3 +-
 arch/x86/include/asm/atomic.h                     |  36 +----
 arch/x86/include/asm/atomic64_64.h                |   8 +-
 arch/x86/include/asm/barrier.h                    |   4 +-
 crypto/cts.c                                      |   8 +-
 drivers/dma/qcom_bam_dma.c                        |  14 ++
 drivers/hid/hid-core.c                            |   3 +
 drivers/hid/hid-ids.h                             |   2 +
 drivers/hid/hid-sony.c                            |   6 +
 drivers/media/usb/cpia2/cpia2_v4l.c               |   3 +-
 drivers/mmc/card/block.c                          |   7 +-
 drivers/mmc/core/core.c                           |  10 +-
 drivers/mmc/core/debugfs.c                        |   2 +-
 drivers/mmc/core/mmc.c                            |  13 +-
 drivers/mmc/core/mmc_ops.c                        |   2 +-
 drivers/net/can/usb/kvaser_usb.c                  |   6 +-
 drivers/net/ethernet/qlogic/qla3xxx.c             |   9 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  16 +-
 drivers/net/wireless/mwifiex/cfg80211.c           |  17 ++-
 drivers/net/wireless/mwifiex/ioctl.h              |   1 +
 drivers/net/wireless/mwifiex/sta_ioctl.c          |  23 ++-
 drivers/scsi/libsas/sas_discover.c                |  11 +-
 drivers/staging/android/ashmem.c                  |   4 +-
 drivers/staging/android/ion/ion_carveout_heap.c   |   2 +-
 drivers/staging/android/uapi/ashmem.h             |   1 +
 drivers/staging/goldfish/goldfish_audio.c         |   1 +
 drivers/usb/dwc3/gadget.c                         |   6 +
 drivers/usb/gadget/composite.c                    |   2 +
 drivers/usb/gadget/configfs.c                     |   2 +
 drivers/usb/gadget/rndis.c                        |   6 +
 drivers/usb/gadget/u_serial.c                     |  12 +-
 drivers/usb/host/xhci-hub.c                       |   8 +
 drivers/usb/host/xhci-ring.c                      |  15 +-
 drivers/usb/host/xhci.h                           |   2 +
 drivers/usb/renesas_usbhs/mod_gadget.c            |   5 +-
 drivers/video/fbdev/goldfishfb.c                  |   2 +-
 fs/ext4/inode.c                                   |  15 ++
 fs/ext4/super.c                                   |  59 +++++---
 fs/readdir.c                                      |  40 +++++
 include/asm-generic/fixmap.h                      |  12 +-
 include/linux/swap.h                              |   1 -
 include/net/inet_connection_sock.h                |   5 -
 kernel/power/Makefile                             |   3 +-
 kernel/power/block_io.c                           | 103 -------------
 kernel/power/power.h                              |   9 --
 kernel/power/swap.c                               | 177 +++++++++++++++++-----
 kernel/sched/fair.c                               |  14 +-
 kernel/sched/sched.h                              |   2 -
 kernel/trace/trace_uprobe.c                       |   9 +-
 mm/page_io.c                                      |   2 +-
 mm/rmap.c                                         |   2 +-
 net/ceph/messenger.c                              |  12 +-
 net/dccp/ipv4.c                                   |   8 +-
 net/dccp/ipv6.c                                   |   2 +-
 net/ipv4/inet_diag.c                              |  18 ++-
 net/ipv4/tcp_ipv4.c                               |   7 +-
 net/ipv6/tcp_ipv6.c                               |   2 +-
 net/wireless/nl80211.c                            |  16 +-
 scripts/setlocalversion                           |   2 +-
 sound/core/compress_offload.c                     |  13 ++
 69 files changed, 532 insertions(+), 351 deletions(-)

Adrian Bunk (1):
      mwifiex: Fix NL80211_TX_POWER_LIMITED

Amitkumar Karwar (1):
      mwifiex: don't follow AP if country code received from EEPROM

Andreas Ziegler (1):
      tracing/uprobes: Fix output for multiple string arguments

Ard Biesheuvel (1):
      arm64/kernel: fix incorrect EL0 check in inv_entry macro

Arnd Bergmann (1):
      ARM: 8458/1: bL_switcher: add GIC dependency

Baolin Wang (1):
      usb: gadget: Add the gserial port checking in gs_start_tx()

Ben Hutchings (4):
      net: qlogic: Fix error paths in ql_alloc_large_buffers()
      ext4: Introduce ext4_clamp_want_extra_isize()
      Revert "sched/fair: Fix bandwidth timer clock drift condition"
      Linux 3.16.81

Bhadram Varka (1):
      stmmac: copy unicast mac address to MAC registers

Chaotian Jing (1):
      mmc: mmc: fix switch timeout issue caused by jiffies precision

Christoffer Dall (1):
      video: fbdev: Set pixclock = 0 in goldfishfb

Christoph Hellwig (1):
      suspend: simplify block I/O handling

Chuanxiao Dong (1):
      mmc: debugfs: Add a restriction to mmc debugfs clock setting

Colin Cross (1):
      mmc: block: Allow more than 8 partitions per card

Dmitry Vyukov (1):
      locking/x86: Remove the unused atomic_inc_short() methd

Dong Aisheng (1):
      mmc: core: fix using wrong io voltage if mmc_select_hs200 fails

Eric Biggers (2):
      crypto: cts - fix crash on short inputs
      arm64: support keyctl() system call in 32-bit mode

Eric Dumazet (2):
      tcp/dccp: drop SYN packets if accept queue is full
      net: diag: support v4mapped sockets in inet_diag_find_one_icsk()

Ezequiel Garcia (1):
      arm64: kconfig: drop CONFIG_RTC_LIB dependency

Ganapathi Bhat (1):
      mwifiex: fix possible heap overflow in mwifiex_process_country_ie()

Greg Hackmann (1):
      staging: goldfish: audio: fix compiliation on arm

Ilya Dryomov (1):
      libceph: handle an empty authorize reply

James Morse (3):
      arm64: mm: Add trace_irqflags annotations to do_debug_exception()
      arm64: kernel: Include _AC definition in page.h
      PM / Hibernate: Call flush_icache_range() on pages restored in-place

Jason Yan (1):
      scsi: libsas: stop discovering if oob mode is disconnected

Jeffrey Hugo (1):
      dmaengine: qcom: bam_dma: Fix resource leak

Johannes Berg (1):
      cfg80211: size various nl80211 messages correctly

Konstantin Khlebnikov (1):
      mm/rmap: replace BUG_ON(anon_vma->degree) with VM_WARN_ON

Laura Abbott (1):
      staging: ashmem: Avoid deadlock with mmap/shrink

Linus Torvalds (2):
      Make filldir[64]() verify the directory entry filename is valid
      filldir[64]: remove WARN_ON_ONCE() for bad directory entries

Lorenzo Pieralisi (1):
      ARM: 8510/1: rework ARM_CPU_SUSPEND dependencies

Mark Rutland (1):
      asm-generic: Fix local variable shadow in __set_fixmap_offset

Mathias Nyman (2):
      xhci: Fix port resume done detection for SS ports with LPM enabled
      xhci: fix USB3 device initiated resume race with roothub autosuspend

Navid Emamdoost (1):
      net: qlogic: Fix memory leak in ql_alloc_large_buffers

Peter Chen (1):
      usb: gadget: composite: fix dereference after null check coverify warning

Peter Zijlstra (2):
      x86/atomic: Fix smp_mb__{before,after}_atomic()
      locking,x86: Kill atomic_or_long()

Philip Oberstaller (1):
      usb: gadget: serial: fix re-ordering of tx data

Qiao Zhou (1):
      arm64: traps: disable irq in die()

Rajmal Menariya (1):
      staging: ion: Set minimum carveout heap allocation order to PAGE_SHIFT

Ravindra Lokhande (1):
      ALSA: compress: add support for 32bit calls in a 64bit kernel

Roderick Colenbrander (2):
      HID: sony: Update device ids
      HID: sony: Support DS4 dongle

Roger Quadros (1):
      usb: dwc3: gadget: Fix suspend/resume during device mode

Rom Lemarchand (1):
      staging: ashmem: Add missing include

Russell King (1):
      mmc: core: shut up "voltage-ranges unspecified" pr_info()

Theodore Ts'o (1):
      ext4: add more paranoia checking in ext4_expand_extra_isize handling

Will Deacon (2):
      arm64: debug: Don't propagate UNKNOWN FAR into si_code for debug signals
      arm64: debug: Ensure debug handlers check triggering exception level

Winter Wang (1):
      usb: gadget: configfs: add mutex lock before unregister gadget

Wolfram Sang (2):
      mmc: sanitize 'bus width' in debug output
      kbuild: setlocalversion: print error to STDERR

Xerox Lin (1):
      usb: gadget: rndis: free response queue during REMOTE_NDIS_RESET_MSG

Xiaolong Huang (1):
      can: kvaser_usb: kvaser_usb_leaf: Fix some info-leaks to USB devices

Yoshihiro Shimoda (1):
      usb: renesas_usbhs: gadget: fix unused-but-set-variable warning

YueHaibing (1):
      media: cpia2: Fix use-after-free in cpia2_exit

Yury Norov (1):
      arm64: fix COMPAT_SHMLBA definition for large pages


--FL5UXtIhxfXey3p5
Content-Type: text/x-diff; charset=UTF-8; name="linux-3.16.81.patch"
Content-Disposition: attachment; filename="linux-3.16.81.patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/Makefile b/Makefile
index 05ef2a1167fc..f749333fdeed 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 16
-SUBLEVEL =3D 80
+SUBLEVEL =3D 81
 EXTRAVERSION =3D
 NAME =3D Museum of Fishiegoodies
=20
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 290f02ee0157..ac1fdb21ed06 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1485,8 +1485,7 @@ config BIG_LITTLE
=20
 config BL_SWITCHER
 	bool "big.LITTLE switcher support"
-	depends on BIG_LITTLE && MCPM && HOTPLUG_CPU
-	select ARM_CPU_SUSPEND
+	depends on BIG_LITTLE && MCPM && HOTPLUG_CPU && ARM_GIC
 	select CPU_PM
 	help
 	  The big.LITTLE "switcher" provides the core functionality to
@@ -2201,7 +2200,8 @@ config ARCH_SUSPEND_POSSIBLE
 	def_bool y
=20
 config ARM_CPU_SUSPEND
-	def_bool PM_SLEEP
+	def_bool PM_SLEEP || BL_SWITCHER
+	depends on ARCH_SUSPEND_POSSIBLE
=20
 config ARCH_HIBERNATION_POSSIBLE
 	bool
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 2e882e5174ab..dda9de57921f 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -60,7 +60,6 @@ config ARM64
 	select PERF_USE_VMALLOC
 	select POWER_RESET
 	select POWER_SUPPLY
-	select RTC_LIB
 	select SPARSE_IRQ
 	select SYSCTL_EXCEPTION_TRACE
 	help
@@ -353,6 +352,10 @@ config SYSVIPC_COMPAT
 	def_bool y
 	depends on COMPAT && SYSVIPC
=20
+config KEYS_COMPAT
+	def_bool y
+	depends on COMPAT && KEYS
+
 endmenu
=20
 menu "Power management options"
diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
index 46bf66628b6a..a4bba9099c6c 100644
--- a/arch/arm64/include/asm/page.h
+++ b/arch/arm64/include/asm/page.h
@@ -19,6 +19,8 @@
 #ifndef __ASM_PAGE_H
 #define __ASM_PAGE_H
=20
+#include <linux/const.h>
+
 /* PAGE_SHIFT determines the page size */
 #ifdef CONFIG_ARM64_64K_PAGES
 #define PAGE_SHIFT		16
diff --git a/arch/arm64/include/asm/shmparam.h b/arch/arm64/include/asm/shm=
param.h
index 4df608a8459e..e368a55ebd22 100644
--- a/arch/arm64/include/asm/shmparam.h
+++ b/arch/arm64/include/asm/shmparam.h
@@ -21,7 +21,7 @@
  * alignment value. Since we don't have aliasing D-caches, the rest of
  * the time we can safely use PAGE_SIZE.
  */
-#define COMPAT_SHMLBA	0x4000
+#define COMPAT_SHMLBA	(4 * PAGE_SIZE)
=20
 #include <asm-generic/shmparam.h>
=20
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 67738737be9d..e100ec3b8b48 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -187,7 +187,7 @@ END(vectors)
  * Invalid mode handlers
  */
 	.macro	inv_entry, el, reason, regsize =3D 64
-	kernel_entry el, \regsize
+	kernel_entry \el, \regsize
 	mov	x0, sp
 	mov	x1, #\reason
 	mrs	x2, esr_el1
diff --git a/arch/arm64/kernel/kgdb.c b/arch/arm64/kernel/kgdb.c
index 75c9cf1aafee..fb482988428e 100644
--- a/arch/arm64/kernel/kgdb.c
+++ b/arch/arm64/kernel/kgdb.c
@@ -215,22 +215,31 @@ int kgdb_arch_handle_exception(int exception_vector, =
int signo,
=20
 static int kgdb_brk_fn(struct pt_regs *regs, unsigned int esr)
 {
+	if (user_mode(regs))
+		return DBG_HOOK_ERROR;
+
 	kgdb_handle_exception(1, SIGTRAP, 0, regs);
-	return 0;
+	return DBG_HOOK_HANDLED;
 }
=20
 static int kgdb_compiled_brk_fn(struct pt_regs *regs, unsigned int esr)
 {
+	if (user_mode(regs))
+		return DBG_HOOK_ERROR;
+
 	compiled_break =3D 1;
 	kgdb_handle_exception(1, SIGTRAP, 0, regs);
=20
-	return 0;
+	return DBG_HOOK_HANDLED;
 }
=20
 static int kgdb_step_brk_fn(struct pt_regs *regs, unsigned int esr)
 {
+	if (user_mode(regs))
+		return DBG_HOOK_ERROR;
+
 	kgdb_handle_exception(1, SIGTRAP, 0, regs);
-	return 0;
+	return DBG_HOOK_HANDLED;
 }
=20
 static struct break_hook kgdb_brkpt_hook =3D {
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index d368cc98bcdb..a81da68aa65a 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -178,10 +178,12 @@ void die(const char *str, struct pt_regs *regs, int e=
rr)
 {
 	struct thread_info *thread =3D current_thread_info();
 	int ret;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&die_lock, flags);
=20
 	oops_enter();
=20
-	raw_spin_lock_irq(&die_lock);
 	console_verbose();
 	bust_spinlocks(1);
 	ret =3D __die(str, err, thread, regs);
@@ -191,13 +193,15 @@ void die(const char *str, struct pt_regs *regs, int e=
rr)
=20
 	bust_spinlocks(0);
 	add_taint(TAINT_DIE, LOCKDEP_NOW_UNRELIABLE);
-	raw_spin_unlock_irq(&die_lock);
 	oops_exit();
=20
 	if (in_interrupt())
 		panic("Fatal exception in interrupt");
 	if (panic_on_oops)
 		panic("Fatal exception");
+
+	raw_spin_unlock_irqrestore(&die_lock, flags);
+
 	if (ret !=3D NOTIFY_STOP)
 		do_exit(SIGSEGV);
 }
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index ca1b882bc9e1..f8275a6c97cf 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -512,24 +512,38 @@ void __init hook_debug_fault_code(int nr,
 	debug_fault_info[nr].name	=3D name;
 }
=20
-asmlinkage int __exception do_debug_exception(unsigned long addr,
+asmlinkage int __exception do_debug_exception(unsigned long addr_if_watchp=
oint,
 					      unsigned int esr,
 					      struct pt_regs *regs)
 {
 	const struct fault_info *inf =3D debug_fault_info + DBG_ESR_EVT(esr);
+	unsigned long pc =3D instruction_pointer(regs);
 	struct siginfo info;
+	int rv;
=20
-	if (!inf->fn(addr, esr, regs))
-		return 1;
+	/*
+	 * Tell lockdep we disabled irqs in entry.S. Do nothing if they were
+	 * already disabled to preserve the last enabled/disabled addresses.
+	 */
+	if (interrupts_enabled(regs))
+		trace_hardirqs_off();
=20
-	pr_alert("Unhandled debug exception: %s (0x%08x) at 0x%016lx\n",
-		 inf->name, esr, addr);
+	if (!inf->fn(addr_if_watchpoint, esr, regs)) {
+		rv =3D 1;
+	} else {
+		pr_alert("Unhandled debug exception: %s (0x%08x) at 0x%016lx\n",
+			 inf->name, esr, pc);
+
+		info.si_signo =3D inf->sig;
+		info.si_errno =3D 0;
+		info.si_code  =3D inf->code;
+		info.si_addr  =3D (void __user *)pc;
+		arm64_notify_die("", regs, &info, 0);
+		rv =3D 0;
+	}
=20
-	info.si_signo =3D inf->sig;
-	info.si_errno =3D 0;
-	info.si_code  =3D inf->code;
-	info.si_addr  =3D (void __user *)addr;
-	arm64_notify_die("", regs, &info, 0);
+	if (interrupts_enabled(regs))
+		trace_hardirqs_on();
=20
-	return 0;
+	return rv;
 }
diff --git a/arch/tile/lib/atomic_asm_32.S b/arch/tile/lib/atomic_asm_32.S
index 6bda3132cd61..9025bf3017a3 100644
--- a/arch/tile/lib/atomic_asm_32.S
+++ b/arch/tile/lib/atomic_asm_32.S
@@ -24,8 +24,7 @@
  * has an opportunity to return -EFAULT to the user if needed.
  * The 64-bit routines just return a "long long" with the value,
  * since they are only used from kernel space and don't expect to fault.
- * Support for 16-bit ops is included in the framework but we don't provide
- * any (x86_64 has an atomic_inc_short(), so we might want to some day).
+ * Support for 16-bit ops is included in the framework but we don't provid=
e any.
  *
  * Note that the caller is advised to issue a suitable L1 or L2
  * prefetch on the address being manipulated to avoid extra stalls.
diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index 2888394200d6..d67862c05131 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -49,7 +49,7 @@ static inline void atomic_add(int i, atomic_t *v)
 {
 	asm volatile(LOCK_PREFIX "addl %1,%0"
 		     : "+m" (v->counter)
-		     : "ir" (i));
+		     : "ir" (i) : "memory");
 }
=20
 /**
@@ -63,7 +63,7 @@ static inline void atomic_sub(int i, atomic_t *v)
 {
 	asm volatile(LOCK_PREFIX "subl %1,%0"
 		     : "+m" (v->counter)
-		     : "ir" (i));
+		     : "ir" (i) : "memory");
 }
=20
 /**
@@ -89,7 +89,7 @@ static inline int atomic_sub_and_test(int i, atomic_t *v)
 static inline void atomic_inc(atomic_t *v)
 {
 	asm volatile(LOCK_PREFIX "incl %0"
-		     : "+m" (v->counter));
+		     : "+m" (v->counter) :: "memory");
 }
=20
 /**
@@ -101,7 +101,7 @@ static inline void atomic_inc(atomic_t *v)
 static inline void atomic_dec(atomic_t *v)
 {
 	asm volatile(LOCK_PREFIX "decl %0"
-		     : "+m" (v->counter));
+		     : "+m" (v->counter) :: "memory");
 }
=20
 /**
@@ -205,34 +205,6 @@ static inline int __atomic_add_unless(atomic_t *v, int=
 a, int u)
 	return c;
 }
=20
-/**
- * atomic_inc_short - increment of a short integer
- * @v: pointer to type int
- *
- * Atomically adds 1 to @v
- * Returns the new value of @u
- */
-static inline short int atomic_inc_short(short int *v)
-{
-	asm(LOCK_PREFIX "addw $1, %0" : "+m" (*v));
-	return *v;
-}
-
-#ifdef CONFIG_X86_64
-/**
- * atomic_or_long - OR of two long integers
- * @v1: pointer to type unsigned long
- * @v2: pointer to type unsigned long
- *
- * Atomically ORs @v1 and @v2
- * Returns the result of the OR
- */
-static inline void atomic_or_long(unsigned long *v1, unsigned long v2)
-{
-	asm(LOCK_PREFIX "orq %1, %0" : "+m" (*v1) : "r" (v2));
-}
-#endif
-
 /* These are x86-specific, used by some header files */
 #define atomic_clear_mask(mask, addr)				\
 	asm volatile(LOCK_PREFIX "andl %0,%1"			\
diff --git a/arch/x86/include/asm/atomic64_64.h b/arch/x86/include/asm/atom=
ic64_64.h
index 46e9052bbd28..0d9c33210c8e 100644
--- a/arch/x86/include/asm/atomic64_64.h
+++ b/arch/x86/include/asm/atomic64_64.h
@@ -44,7 +44,7 @@ static inline void atomic64_add(long i, atomic64_t *v)
 {
 	asm volatile(LOCK_PREFIX "addq %1,%0"
 		     : "=3Dm" (v->counter)
-		     : "er" (i), "m" (v->counter));
+		     : "er" (i), "m" (v->counter) : "memory");
 }
=20
 /**
@@ -58,7 +58,7 @@ static inline void atomic64_sub(long i, atomic64_t *v)
 {
 	asm volatile(LOCK_PREFIX "subq %1,%0"
 		     : "=3Dm" (v->counter)
-		     : "er" (i), "m" (v->counter));
+		     : "er" (i), "m" (v->counter) : "memory");
 }
=20
 /**
@@ -85,7 +85,7 @@ static inline void atomic64_inc(atomic64_t *v)
 {
 	asm volatile(LOCK_PREFIX "incq %0"
 		     : "=3Dm" (v->counter)
-		     : "m" (v->counter));
+		     : "m" (v->counter) : "memory");
 }
=20
 /**
@@ -98,7 +98,7 @@ static inline void atomic64_dec(atomic64_t *v)
 {
 	asm volatile(LOCK_PREFIX "decq %0"
 		     : "=3Dm" (v->counter)
-		     : "m" (v->counter));
+		     : "m" (v->counter) : "memory");
 }
=20
 /**
diff --git a/arch/x86/include/asm/barrier.h b/arch/x86/include/asm/barrier.h
index 4c8f35c2b924..971c7ab666b3 100644
--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -167,8 +167,8 @@ do {									\
 #endif
=20
 /* Atomic operations are already serializing on x86 */
-#define smp_mb__before_atomic()	barrier()
-#define smp_mb__after_atomic()	barrier()
+#define smp_mb__before_atomic()	do { } while (0)
+#define smp_mb__after_atomic()	do { } while (0)
=20
 /*
  * Stop RDTSC speculation. This is needed when you need to use RDTSC
diff --git a/crypto/cts.c b/crypto/cts.c
index bd9405820e8a..b4ef246995f9 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -137,8 +137,8 @@ static int crypto_cts_encrypt(struct blkcipher_desc *de=
sc,
 	lcldesc.info =3D desc->info;
 	lcldesc.flags =3D desc->flags;
=20
-	if (tot_blocks =3D=3D 1) {
-		err =3D crypto_blkcipher_encrypt_iv(&lcldesc, dst, src, bsize);
+	if (tot_blocks <=3D 1) {
+		err =3D crypto_blkcipher_encrypt_iv(&lcldesc, dst, src, nbytes);
 	} else if (nbytes <=3D bsize * 2) {
 		err =3D cts_cbc_encrypt(ctx, desc, dst, src, 0, nbytes);
 	} else {
@@ -232,8 +232,8 @@ static int crypto_cts_decrypt(struct blkcipher_desc *de=
sc,
 	lcldesc.info =3D desc->info;
 	lcldesc.flags =3D desc->flags;
=20
-	if (tot_blocks =3D=3D 1) {
-		err =3D crypto_blkcipher_decrypt_iv(&lcldesc, dst, src, bsize);
+	if (tot_blocks <=3D 1) {
+		err =3D crypto_blkcipher_decrypt_iv(&lcldesc, dst, src, nbytes);
 	} else if (nbytes <=3D bsize * 2) {
 		err =3D cts_cbc_decrypt(ctx, desc, dst, src, 0, nbytes);
 	} else {
diff --git a/drivers/dma/qcom_bam_dma.c b/drivers/dma/qcom_bam_dma.c
index 82c923146e49..1e6ee8be9e91 100644
--- a/drivers/dma/qcom_bam_dma.c
+++ b/drivers/dma/qcom_bam_dma.c
@@ -539,7 +539,21 @@ static void bam_dma_terminate_all(struct bam_chan *bch=
an)
=20
 	/* remove all transactions, including active transaction */
 	spin_lock_irqsave(&bchan->vc.lock, flag);
+	/*
+	 * If we have transactions queued, then some might be committed to the
+	 * hardware in the desc fifo.  The only way to reset the desc fifo is
+	 * to do a hardware reset (either by pipe or the entire block).
+	 * bam_chan_init_hw() will trigger a pipe reset, and also reinit the
+	 * pipe.  If the pipe is left disabled (default state after pipe reset)
+	 * and is accessed by a connected hardware engine, a fatal error in
+	 * the BAM will occur.  There is a small window where this could happen
+	 * with bam_chan_init_hw(), but it is assumed that the caller has
+	 * stopped activity on any attached hardware engine.  Make sure to do
+	 * this first so that the BAM hardware doesn't cause memory corruption
+	 * by accessing freed resources.
+	 */
 	if (bchan->curr_txd) {
+		bam_chan_init_hw(bchan, bchan->curr_txd->dir);
 		list_add(&bchan->curr_txd->vd.node, &bchan->vc.desc_issued);
 		bchan->curr_txd =3D NULL;
 	}
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 7e4da6d0af06..38b1cad80322 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1932,6 +1932,9 @@ static const struct hid_device_id hid_have_special_dr=
iver[] =3D {
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS3_CONTROL=
LER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS4_CONTROLLER) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS4_CONTROL=
LER) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS4_CONTROLLER_2)=
 },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS4_CONTROL=
LER_2) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS4_CONTROLLER_DO=
NGLE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_VAIO_VGX_MOUSE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_VAIO_VGP_MOUSE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_STEELSERIES, USB_DEVICE_ID_STEELSERIES_SRW=
S1) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 5e3a4ef4a3de..ee038da80188 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -876,6 +876,8 @@
 #define USB_DEVICE_ID_SONY_PS3_BDREMOTE		0x0306
 #define USB_DEVICE_ID_SONY_PS3_CONTROLLER	0x0268
 #define USB_DEVICE_ID_SONY_PS4_CONTROLLER	0x05c4
+#define USB_DEVICE_ID_SONY_PS4_CONTROLLER_2	0x09cc
+#define USB_DEVICE_ID_SONY_PS4_CONTROLLER_DONGLE	0x0ba0
 #define USB_DEVICE_ID_SONY_NAVIGATION_CONTROLLER	0x042f
 #define USB_DEVICE_ID_SONY_BUZZ_CONTROLLER		0x0002
 #define USB_DEVICE_ID_SONY_WIRELESS_BUZZ_CONTROLLER	0x1000
diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index 3bd8bd394c7e..8b535495adbf 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -1998,6 +1998,12 @@ static const struct hid_device_id sony_devices[] =3D=
 {
 		.driver_data =3D DUALSHOCK4_CONTROLLER_USB },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS4_CONTROL=
LER),
 		.driver_data =3D DUALSHOCK4_CONTROLLER_BT },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS4_CONTROLLER_2),
+		.driver_data =3D DUALSHOCK4_CONTROLLER_USB },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS4_CONTROL=
LER_2),
+		.driver_data =3D DUALSHOCK4_CONTROLLER_BT },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS4_CONTROLLER_DO=
NGLE),
+		.driver_data =3D DUALSHOCK4_CONTROLLER_USB },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, sony_devices);
diff --git a/drivers/media/usb/cpia2/cpia2_v4l.c b/drivers/media/usb/cpia2/=
cpia2_v4l.c
index 82c9470833ac..cb86a7ae71bf 100644
--- a/drivers/media/usb/cpia2/cpia2_v4l.c
+++ b/drivers/media/usb/cpia2/cpia2_v4l.c
@@ -1249,8 +1249,7 @@ static int __init cpia2_init(void)
 	LOG("%s v%s\n",
 	    ABOUT, CPIA_VERSION);
 	check_parameters();
-	cpia2_usb_init();
-	return 0;
+	return cpia2_usb_init();
 }
=20
=20
diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 0604d6742b0c..65a0a8f0f50d 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -168,11 +168,7 @@ static struct mmc_blk_data *mmc_blk_get(struct gendisk=
 *disk)
=20
 static inline int mmc_get_devidx(struct gendisk *disk)
 {
-	int devmaj =3D MAJOR(disk_devt(disk));
-	int devidx =3D MINOR(disk_devt(disk)) / perdev_minors;
-
-	if (!devmaj)
-		devidx =3D disk->first_minor / perdev_minors;
+	int devidx =3D disk->first_minor / perdev_minors;
 	return devidx;
 }
=20
@@ -2169,6 +2165,7 @@ static struct mmc_blk_data *mmc_blk_alloc_req(struct =
mmc_card *card,
 	md->disk->queue =3D md->queue.queue;
 	md->disk->driverfs_dev =3D parent;
 	set_disk_ro(md->disk, md->read_only || default_ro);
+	md->disk->flags =3D GENHD_FL_EXT_DEVT;
 	if (area_type & MMC_BLK_DATA_AREA_RPMB)
 		md->disk->flags |=3D GENHD_FL_NO_PART_SCAN;
=20
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 2b051b32f38f..965844a9c1ce 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -973,7 +973,7 @@ static inline void mmc_set_ios(struct mmc_host *host)
 		"width %u timing %u\n",
 		 mmc_hostname(host), ios->clock, ios->bus_mode,
 		 ios->power_mode, ios->chip_select, ios->vdd,
-		 ios->bus_width, ios->timing);
+		 1 << ios->bus_width, ios->timing);
=20
 	if (ios->clock > 0)
 		mmc_set_ungated(host);
@@ -1181,8 +1181,12 @@ int mmc_of_parse_voltage(struct device_node *np, u32=
 *mask)
=20
 	voltage_ranges =3D of_get_property(np, "voltage-ranges", &num_ranges);
 	num_ranges =3D num_ranges / sizeof(*voltage_ranges) / 2;
-	if (!voltage_ranges || !num_ranges) {
-		pr_info("%s: voltage-ranges unspecified\n", np->full_name);
+	if (!voltage_ranges) {
+		pr_debug("%s: voltage-ranges unspecified\n", np->full_name);
+		return -EINVAL;
+	}
+	if (!num_ranges) {
+		pr_err("%s: voltage-ranges empty\n", np->full_name);
 		return -EINVAL;
 	}
=20
diff --git a/drivers/mmc/core/debugfs.c b/drivers/mmc/core/debugfs.c
index c63d39ff4d1d..c50dad20a9ce 100644
--- a/drivers/mmc/core/debugfs.c
+++ b/drivers/mmc/core/debugfs.c
@@ -195,7 +195,7 @@ static int mmc_clock_opt_set(void *data, u64 val)
 	struct mmc_host *host =3D data;
=20
 	/* We need this check due to input value is u64 */
-	if (val > host->f_max)
+	if (val !=3D 0 && (val > host->f_max || val < host->f_min))
 		return -EINVAL;
=20
 	mmc_claim_host(host);
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 008ea4c52290..a5ec5726150d 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -935,7 +935,7 @@ static int mmc_select_bus_width(struct mmc_card *card)
 			break;
 		} else {
 			pr_warn("%s: switch to bus width %d failed\n",
-				mmc_hostname(host), ext_csd_bits[idx]);
+				mmc_hostname(host), 1 << bus_width);
 		}
 	}
=20
@@ -1079,8 +1079,10 @@ static int mmc_select_hs400(struct mmc_card *card)
 static int mmc_select_hs200(struct mmc_card *card)
 {
 	struct mmc_host *host =3D card->host;
+	unsigned int old_signal_voltage;
 	int err =3D -EINVAL;
=20
+	old_signal_voltage =3D host->ios.signal_voltage;
 	if (card->mmc_avail_type & EXT_CSD_CARD_TYPE_HS200_1_2V)
 		err =3D __mmc_set_signal_voltage(host, MMC_SIGNAL_VOLTAGE_120);
=20
@@ -1089,7 +1091,7 @@ static int mmc_select_hs200(struct mmc_card *card)
=20
 	/* If fails try again during next card power cycle */
 	if (err)
-		goto err;
+		return err;
=20
 	/*
 	 * Set the bus width(4 or 8) with host's support and
@@ -1104,7 +1106,12 @@ static int mmc_select_hs200(struct mmc_card *card)
 		if (!err)
 			mmc_set_timing(host, MMC_TIMING_MMC_HS200);
 	}
-err:
+
+	if (err) {
+		/* fall back to the old signal voltage, if fails report error */
+		if (__mmc_set_signal_voltage(host, old_signal_voltage))
+			err =3D -EIO;
+	}
 	return err;
 }
=20
diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index f51b5ba3bbea..ae3288285b50 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -470,7 +470,7 @@ int __mmc_switch(struct mmc_card *card, u8 set, u8 inde=
x, u8 value,
 		timeout_ms =3D MMC_OPS_TIMEOUT_MS;
=20
 	/* Must check status to be sure of no errors. */
-	timeout =3D jiffies + msecs_to_jiffies(timeout_ms);
+	timeout =3D jiffies + msecs_to_jiffies(timeout_ms) + 1;
 	do {
 		if (send_status) {
 			err =3D __mmc_send_status(card, &status, ignore_crc);
diff --git a/drivers/net/can/usb/kvaser_usb.c b/drivers/net/can/usb/kvaser_=
usb.c
index e4d9e8be982f..7ca388cb7202 100644
--- a/drivers/net/can/usb/kvaser_usb.c
+++ b/drivers/net/can/usb/kvaser_usb.c
@@ -586,7 +586,7 @@ static int kvaser_usb_simple_msg_async(struct kvaser_us=
b_net_priv *priv,
 		return -ENOMEM;
 	}
=20
-	buf =3D kmalloc(sizeof(struct kvaser_msg), GFP_ATOMIC);
+	buf =3D kzalloc(sizeof(struct kvaser_msg), GFP_ATOMIC);
 	if (!buf) {
 		usb_free_urb(urb);
 		return -ENOMEM;
@@ -1109,7 +1109,7 @@ static int kvaser_usb_set_opt_mode(const struct kvase=
r_usb_net_priv *priv)
 	struct kvaser_msg *msg;
 	int rc;
=20
-	msg =3D kmalloc(sizeof(*msg), GFP_KERNEL);
+	msg =3D kzalloc(sizeof(*msg), GFP_KERNEL);
 	if (!msg)
 		return -ENOMEM;
=20
@@ -1240,7 +1240,7 @@ static int kvaser_usb_flush_queue(struct kvaser_usb_n=
et_priv *priv)
 	struct kvaser_msg *msg;
 	int rc;
=20
-	msg =3D kmalloc(sizeof(*msg), GFP_KERNEL);
+	msg =3D kzalloc(sizeof(*msg), GFP_KERNEL);
 	if (!msg)
 		return -ENOMEM;
=20
diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/q=
logic/qla3xxx.c
index b5d6bc1a8b00..da0f24cd43a2 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -2758,6 +2758,9 @@ static int ql_alloc_large_buffers(struct ql3_adapter =
*qdev)
 	int err;
=20
 	for (i =3D 0; i < qdev->num_large_buffers; i++) {
+		lrg_buf_cb =3D &qdev->lrg_buf[i];
+		memset(lrg_buf_cb, 0, sizeof(struct ql_rcv_buf_cb));
+
 		skb =3D netdev_alloc_skb(qdev->ndev,
 				       qdev->lrg_buffer_len);
 		if (unlikely(!skb)) {
@@ -2768,11 +2771,7 @@ static int ql_alloc_large_buffers(struct ql3_adapter=
 *qdev)
 			ql_free_large_buffers(qdev);
 			return -ENOMEM;
 		} else {
-
-			lrg_buf_cb =3D &qdev->lrg_buf[i];
-			memset(lrg_buf_cb, 0, sizeof(struct ql_rcv_buf_cb));
 			lrg_buf_cb->index =3D i;
-			lrg_buf_cb->skb =3D skb;
 			/*
 			 * We save some space to copy the ethhdr from first
 			 * buffer
@@ -2789,10 +2788,12 @@ static int ql_alloc_large_buffers(struct ql3_adapte=
r *qdev)
 				netdev_err(qdev->ndev,
 					   "PCI mapping failed with error: %d\n",
 					   err);
+				dev_kfree_skb_irq(skb);
 				ql_free_large_buffers(qdev);
 				return -ENOMEM;
 			}
=20
+			lrg_buf_cb->skb =3D skb;
 			dma_unmap_addr_set(lrg_buf_cb, mapaddr, map);
 			dma_unmap_len_set(lrg_buf_cb, maplen,
 					  qdev->lrg_buffer_len -
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/ne=
t/ethernet/stmicro/stmmac/stmmac_main.c
index 60d78a8c141c..fd35371ffae5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2388,6 +2388,20 @@ static int stmmac_ioctl(struct net_device *dev, stru=
ct ifreq *rq, int cmd)
 	return ret;
 }
=20
+static int stmmac_set_mac_address(struct net_device *ndev, void *addr)
+{
+	struct stmmac_priv *priv =3D netdev_priv(ndev);
+	int ret =3D 0;
+
+	ret =3D eth_mac_addr(ndev, addr);
+	if (ret)
+		return ret;
+
+	priv->hw->mac->set_umac_addr(priv->ioaddr, ndev->dev_addr, 0);
+
+	return ret;
+}
+
 #ifdef CONFIG_STMMAC_DEBUG_FS
 static struct dentry *stmmac_fs_dir;
 static struct dentry *stmmac_rings_status;
@@ -2587,7 +2601,7 @@ static const struct net_device_ops stmmac_netdev_ops =
=3D {
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller =3D stmmac_poll_controller,
 #endif
-	.ndo_set_mac_address =3D eth_mac_addr,
+	.ndo_set_mac_address =3D stmmac_set_mac_address,
 };
=20
 /**
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless=
/mwifiex/cfg80211.c
index ca688991c4c1..658adfd189d7 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -343,11 +343,20 @@ mwifiex_cfg80211_set_tx_power(struct wiphy *wiphy,
 	struct mwifiex_power_cfg power_cfg;
 	int dbm =3D MBM_TO_DBM(mbm);
=20
-	if (type =3D=3D NL80211_TX_POWER_FIXED) {
+	switch (type) {
+	case NL80211_TX_POWER_FIXED:
 		power_cfg.is_power_auto =3D 0;
+		power_cfg.is_power_fixed =3D 1;
 		power_cfg.power_level =3D dbm;
-	} else {
+		break;
+	case NL80211_TX_POWER_LIMITED:
+		power_cfg.is_power_auto =3D 0;
+		power_cfg.is_power_fixed =3D 0;
+		power_cfg.power_level =3D dbm;
+		break;
+	case NL80211_TX_POWER_AUTOMATIC:
 		power_cfg.is_power_auto =3D 1;
+		break;
 	}
=20
 	priv =3D mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
@@ -2908,6 +2917,10 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter=
 *adapter)
 	wiphy->cipher_suites =3D mwifiex_cipher_suites;
 	wiphy->n_cipher_suites =3D ARRAY_SIZE(mwifiex_cipher_suites);
=20
+	if (adapter->region_code)
+		wiphy->regulatory_flags |=3D REGULATORY_DISABLE_BEACON_HINTS |
+					   REGULATORY_COUNTRY_IE_IGNORE;
+
 	memcpy(wiphy->perm_addr, priv->curr_addr, ETH_ALEN);
 	wiphy->signal_type =3D CFG80211_SIGNAL_TYPE_MBM;
 	wiphy->flags |=3D WIPHY_FLAG_HAVE_AP_SME |
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mw=
ifiex/ioctl.h
index 1b576722671d..f5d96096472a 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -245,6 +245,7 @@ struct mwifiex_ds_encrypt_key {
=20
 struct mwifiex_power_cfg {
 	u32 is_power_auto;
+	u32 is_power_fixed;
 	u32 power_level;
 };
=20
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireles=
s/mwifiex/sta_ioctl.c
index 1ac6b2870273..5326a0095601 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -223,6 +223,14 @@ static int mwifiex_process_country_ie(struct mwifiex_p=
rivate *priv,
 			  "11D: skip setting domain info in FW\n");
 		return 0;
 	}
+
+	if (country_ie_len >
+	    (IEEE80211_COUNTRY_STRING_LEN + MWIFIEX_MAX_TRIPLET_802_11D)) {
+		wiphy_dbg(priv->wdev->wiphy,
+			  "11D: country_ie_len overflow!, deauth AP\n");
+		return -EINVAL;
+	}
+
 	memcpy(priv->adapter->country_code, &country_ie[2], 2);
=20
 	domain_info->country_code[0] =3D country_ie[2];
@@ -266,7 +274,9 @@ int mwifiex_bss_start(struct mwifiex_private *priv, str=
uct cfg80211_bss *bss,
 	priv->scan_block =3D false;
=20
 	if (bss) {
-		mwifiex_process_country_ie(priv, bss);
+		if (adapter->region_code =3D=3D 0x00 &&
+		    mwifiex_process_country_ie(priv, bss))
+			return -EINVAL;
=20
 		/* Allocate and fill new bss descriptor */
 		bss_desc =3D kzalloc(sizeof(struct mwifiex_bssdescriptor),
@@ -659,6 +669,9 @@ int mwifiex_set_tx_power(struct mwifiex_private *priv,
 	txp_cfg =3D (struct host_cmd_ds_txpwr_cfg *) buf;
 	txp_cfg->action =3D cpu_to_le16(HostCmd_ACT_GEN_SET);
 	if (!power_cfg->is_power_auto) {
+		u16 dbm_min =3D power_cfg->is_power_fixed ?
+			      dbm : priv->min_tx_power_level;
+
 		txp_cfg->mode =3D cpu_to_le32(1);
 		pg_tlv =3D (struct mwifiex_types_power_group *)
 			 (buf + sizeof(struct host_cmd_ds_txpwr_cfg));
@@ -673,7 +686,7 @@ int mwifiex_set_tx_power(struct mwifiex_private *priv,
 		pg->last_rate_code =3D 0x03;
 		pg->modulation_class =3D MOD_CLASS_HR_DSSS;
 		pg->power_step =3D 0;
-		pg->power_min =3D (s8) dbm;
+		pg->power_min =3D (s8) dbm_min;
 		pg->power_max =3D (s8) dbm;
 		pg++;
 		/* Power group for modulation class OFDM */
@@ -681,7 +694,7 @@ int mwifiex_set_tx_power(struct mwifiex_private *priv,
 		pg->last_rate_code =3D 0x07;
 		pg->modulation_class =3D MOD_CLASS_OFDM;
 		pg->power_step =3D 0;
-		pg->power_min =3D (s8) dbm;
+		pg->power_min =3D (s8) dbm_min;
 		pg->power_max =3D (s8) dbm;
 		pg++;
 		/* Power group for modulation class HTBW20 */
@@ -689,7 +702,7 @@ int mwifiex_set_tx_power(struct mwifiex_private *priv,
 		pg->last_rate_code =3D 0x20;
 		pg->modulation_class =3D MOD_CLASS_HT;
 		pg->power_step =3D 0;
-		pg->power_min =3D (s8) dbm;
+		pg->power_min =3D (s8) dbm_min;
 		pg->power_max =3D (s8) dbm;
 		pg->ht_bandwidth =3D HT_BW_20;
 		pg++;
@@ -698,7 +711,7 @@ int mwifiex_set_tx_power(struct mwifiex_private *priv,
 		pg->last_rate_code =3D 0x20;
 		pg->modulation_class =3D MOD_CLASS_HT;
 		pg->power_step =3D 0;
-		pg->power_min =3D (s8) dbm;
+		pg->power_min =3D (s8) dbm_min;
 		pg->power_max =3D (s8) dbm;
 		pg->ht_bandwidth =3D HT_BW_40;
 	}
diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_d=
iscover.c
index 60de66252fa2..b200edc665a5 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -97,12 +97,21 @@ static int sas_get_port_device(struct asd_sas_port *por=
t)
 		else
 			dev->dev_type =3D SAS_SATA_DEV;
 		dev->tproto =3D SAS_PROTOCOL_SATA;
-	} else {
+	} else if (port->oob_mode =3D=3D SAS_OOB_MODE) {
 		struct sas_identify_frame *id =3D
 			(struct sas_identify_frame *) dev->frame_rcvd;
 		dev->dev_type =3D id->dev_type;
 		dev->iproto =3D id->initiator_bits;
 		dev->tproto =3D id->target_bits;
+	} else {
+		/* If the oob mode is OOB_NOT_CONNECTED, the port is
+		 * disconnected due to race with PHY down. We cannot
+		 * continue to discover this port
+		 */
+		sas_put_device(dev);
+		pr_warn("Port %016llx is disconnected when discovering\n",
+			SAS_ADDR(port->attached_sas_addr));
+		return -ENODEV;
 	}
=20
 	sas_init_dev(dev);
diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ash=
mem.c
index 031fbd59876b..5dbc68da8727 100644
--- a/drivers/staging/android/ashmem.c
+++ b/drivers/staging/android/ashmem.c
@@ -434,7 +434,9 @@ ashmem_shrink_scan(struct shrinker *shrink, struct shri=
nk_control *sc)
 	if (!(sc->gfp_mask & __GFP_FS))
 		return SHRINK_STOP;
=20
-	mutex_lock(&ashmem_mutex);
+	if (!mutex_trylock(&ashmem_mutex))
+		return -1;
+
 	list_for_each_entry_safe(range, next, &ashmem_lru_list, lru) {
 		loff_t start =3D range->pgstart * PAGE_SIZE;
 		loff_t end =3D (range->pgend + 1) * PAGE_SIZE;
diff --git a/drivers/staging/android/ion/ion_carveout_heap.c b/drivers/stag=
ing/android/ion/ion_carveout_heap.c
index dcb6f2196c87..6b9bf9a0816b 100644
--- a/drivers/staging/android/ion/ion_carveout_heap.c
+++ b/drivers/staging/android/ion/ion_carveout_heap.c
@@ -168,7 +168,7 @@ struct ion_heap *ion_carveout_heap_create(struct ion_pl=
atform_heap *heap_data)
 	if (!carveout_heap)
 		return ERR_PTR(-ENOMEM);
=20
-	carveout_heap->pool =3D gen_pool_create(12, -1);
+	carveout_heap->pool =3D gen_pool_create(PAGE_SHIFT, -1);
 	if (!carveout_heap->pool) {
 		kfree(carveout_heap);
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/staging/android/uapi/ashmem.h b/drivers/staging/androi=
d/uapi/ashmem.h
index ba4743c71d6b..13df42d200b7 100644
--- a/drivers/staging/android/uapi/ashmem.h
+++ b/drivers/staging/android/uapi/ashmem.h
@@ -13,6 +13,7 @@
 #define _UAPI_LINUX_ASHMEM_H
=20
 #include <linux/ioctl.h>
+#include <linux/types.h>
=20
 #define ASHMEM_NAME_LEN		256
=20
diff --git a/drivers/staging/goldfish/goldfish_audio.c b/drivers/staging/go=
ldfish/goldfish_audio.c
index cbd456770af0..aba53cf9bc7a 100644
--- a/drivers/staging/goldfish/goldfish_audio.c
+++ b/drivers/staging/goldfish/goldfish_audio.c
@@ -26,6 +26,7 @@
 #include <linux/sched.h>
 #include <linux/dma-mapping.h>
 #include <linux/uaccess.h>
+#include <linux/slab.h>
 #include <linux/goldfish.h>
=20
 MODULE_AUTHOR("Google, Inc.");
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 1f45a444c07f..732e909c1c65 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2955,6 +2955,9 @@ void dwc3_gadget_complete(struct dwc3 *dwc)
=20
 int dwc3_gadget_suspend(struct dwc3 *dwc)
 {
+	if (!dwc->gadget_driver)
+		return 0;
+
 	__dwc3_gadget_ep_disable(dwc->eps[0]);
 	__dwc3_gadget_ep_disable(dwc->eps[1]);
=20
@@ -2968,6 +2971,9 @@ int dwc3_gadget_resume(struct dwc3 *dwc)
 	struct dwc3_ep		*dep;
 	int			ret;
=20
+	if (!dwc->gadget_driver)
+		return 0;
+
 	/* Start with SuperSpeed Default */
 	dwc3_gadget_ep0_desc.wMaxPacketSize =3D cpu_to_le16(512);
=20
diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 020ffcee5b02..f4f620aff510 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1729,6 +1729,8 @@ composite_setup(struct usb_gadget *gadget, const stru=
ct usb_ctrlrequest *ctrl)
 			break;
=20
 		case USB_RECIP_ENDPOINT:
+			if (!cdev->config)
+				break;
 			endp =3D ((w_index & 0x80) >> 3) | (w_index & 0x0f);
 			list_for_each_entry(f, &cdev->config->functions, list) {
 				if (test_bit(endp, f->endpoints))
diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index 451296b2b71f..3589be72f598 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -1551,7 +1551,9 @@ void unregister_gadget_item(struct config_item *item)
 {
 	struct gadget_info *gi =3D to_gadget_info(item);
=20
+	mutex_lock(&gi->lock);
 	unregister_gadget(gi);
+	mutex_unlock(&gi->lock);
 }
 EXPORT_SYMBOL_GPL(unregister_gadget_item);
=20
diff --git a/drivers/usb/gadget/rndis.c b/drivers/usb/gadget/rndis.c
index 95d2324f6977..0c513e638db9 100644
--- a/drivers/usb/gadget/rndis.c
+++ b/drivers/usb/gadget/rndis.c
@@ -686,6 +686,12 @@ static int rndis_reset_response(int configNr, rndis_re=
set_msg_type *buf)
 	rndis_reset_cmplt_type *resp;
 	rndis_resp_t *r;
 	struct rndis_params *params =3D rndis_per_dev_params + configNr;
+	u8 *xbuf;
+	u32 length;
+
+	/* drain the response queue */
+	while ((xbuf =3D rndis_get_next_response(configNr, &length)))
+		rndis_free_response(configNr, xbuf);
=20
 	r =3D rndis_add_response(configNr, sizeof(rndis_reset_cmplt_type));
 	if (!r)
diff --git a/drivers/usb/gadget/u_serial.c b/drivers/usb/gadget/u_serial.c
index ad0aca812002..771d3d8ffaa3 100644
--- a/drivers/usb/gadget/u_serial.c
+++ b/drivers/usb/gadget/u_serial.c
@@ -116,6 +116,7 @@ struct gs_port {
 	int write_allocated;
 	struct gs_buf		port_write_buf;
 	wait_queue_head_t	drain_wait;	/* wait while writes drain */
+	bool                    write_busy;
=20
 	/* REVISIT this state ... */
 	struct usb_cdc_line_coding port_line_coding;	/* 8-N-1 etc */
@@ -362,11 +363,16 @@ __acquires(&port->port_lock)
 */
 {
 	struct list_head	*pool =3D &port->write_pool;
-	struct usb_ep		*in =3D port->port_usb->in;
+	struct usb_ep		*in;
 	int			status =3D 0;
 	bool			do_tty_wake =3D false;
=20
-	while (!list_empty(pool)) {
+	if (!port->port_usb)
+		return status;
+
+	in =3D port->port_usb->in;
+
+	while (!port->write_busy && !list_empty(pool)) {
 		struct usb_request	*req;
 		int			len;
=20
@@ -396,9 +402,11 @@ __acquires(&port->port_lock)
 		 * NOTE that we may keep sending data for a while after
 		 * the TTY closed (dev->ioport->port_tty is NULL).
 		 */
+		port->write_busy =3D true;
 		spin_unlock(&port->port_lock);
 		status =3D usb_ep_queue(in, req, GFP_ATOMIC);
 		spin_lock(&port->port_lock);
+		port->write_busy =3D false;
=20
 		if (status) {
 			pr_debug("%s: %s %s err %d\n",
diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index dc3270e48dfb..79dabb14c2bf 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -612,6 +612,14 @@ static u32 xhci_get_port_status(struct usb_hcd *hcd,
 			status |=3D USB_PORT_STAT_C_BH_RESET << 16;
 		if ((raw_port_status & PORT_CEC))
 			status |=3D USB_PORT_STAT_C_CONFIG_ERROR << 16;
+
+		/* USB3 remote wake resume signaling completed */
+		if (bus_state->port_remote_wakeup & (1 << wIndex) &&
+		    (raw_port_status & PORT_PLS_MASK) !=3D XDEV_RESUME &&
+		    (raw_port_status & PORT_PLS_MASK) !=3D XDEV_RECOVERY) {
+			bus_state->port_remote_wakeup &=3D ~(1 << wIndex);
+			usb_hcd_end_port_resume(&hcd->self, wIndex);
+		}
 	}
=20
 	if (hcd->speed !=3D HCD_USB3) {
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 1a308f971a7e..ae3b2b5fa9f6 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1605,9 +1605,6 @@ static void handle_port_status(struct xhci_hcd *xhci,
 		usb_hcd_resume_root_hub(hcd);
 	}
=20
-	if (hcd->speed =3D=3D HCD_USB3 && (temp & PORT_PLS_MASK) =3D=3D XDEV_INAC=
TIVE)
-		bus_state->port_remote_wakeup &=3D ~(1 << faked_port_index);
-
 	if ((temp & PORT_PLC) && (temp & PORT_PLS_MASK) =3D=3D XDEV_RESUME) {
 		xhci_dbg(xhci, "port resume event for port %d\n", port_id);
=20
@@ -1626,6 +1623,7 @@ static void handle_port_status(struct xhci_hcd *xhci,
 			bus_state->port_remote_wakeup |=3D 1 << faked_port_index;
 			xhci_test_and_clear_bit(xhci, port_array,
 					faked_port_index, PORT_PLC);
+			usb_hcd_start_port_resume(&hcd->self, faked_port_index);
 			xhci_set_link_state(xhci, port_array, faked_port_index,
 						XDEV_U0);
 			/* Need to wait until the next link state change
@@ -1645,10 +1643,13 @@ static void handle_port_status(struct xhci_hcd *xhc=
i,
 		}
 	}
=20
-	if ((temp & PORT_PLC) && (temp & PORT_PLS_MASK) =3D=3D XDEV_U0 &&
-			DEV_SUPERSPEED(temp)) {
+	if ((temp & PORT_PLC) &&
+	    DEV_SUPERSPEED(temp) &&
+	    ((temp & PORT_PLS_MASK) =3D=3D XDEV_U0 ||
+	     (temp & PORT_PLS_MASK) =3D=3D XDEV_U1 ||
+	     (temp & PORT_PLS_MASK) =3D=3D XDEV_U2)) {
 		xhci_dbg(xhci, "resume SS port %d finished\n", port_id);
-		/* We've just brought the device into U0 through either the
+		/* We've just brought the device into U0/1/2 through either the
 		 * Resume state after a device remote wakeup, or through the
 		 * U3Exit state after a host-initiated resume.  If it's a device
 		 * initiated remote wake, don't pass up the link state change,
@@ -1660,8 +1661,6 @@ static void handle_port_status(struct xhci_hcd *xhci,
 		if (slot_id && xhci->devs[slot_id])
 			xhci_ring_device(xhci, slot_id);
 		if (bus_state->port_remote_wakeup & (1 << faked_port_index)) {
-			bus_state->port_remote_wakeup &=3D
-				~(1 << faked_port_index);
 			xhci_test_and_clear_bit(xhci, port_array,
 					faked_port_index, PORT_PLC);
 			usb_wakeup_notification(hcd->self.root_hub,
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index bd191fbfdf40..0c5f2018b30b 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -283,10 +283,12 @@ struct xhci_op_regs {
  */
 #define PORT_PLS_MASK	(0xf << 5)
 #define XDEV_U0		(0x0 << 5)
+#define XDEV_U1		(0x1 << 5)
 #define XDEV_U2		(0x2 << 5)
 #define XDEV_U3		(0x3 << 5)
 #define XDEV_INACTIVE	(0x6 << 5)
 #define XDEV_POLLING	(0x7 << 5)
+#define XDEV_RECOVERY	(0x8 << 5)
 #define XDEV_COMP_MODE  (0xa << 5)
 #define XDEV_RESUME	(0xf << 5)
 /* true: port has power (see HCC_PPC) */
diff --git a/drivers/usb/renesas_usbhs/mod_gadget.c b/drivers/usb/renesas_u=
sbhs/mod_gadget.c
index b64f88b658ed..669b72812812 100644
--- a/drivers/usb/renesas_usbhs/mod_gadget.c
+++ b/drivers/usb/renesas_usbhs/mod_gadget.c
@@ -611,14 +611,11 @@ static int usbhsg_ep_disable(struct usb_ep *ep)
 	struct usbhsg_uep *uep =3D usbhsg_ep_to_uep(ep);
 	struct usbhs_pipe *pipe;
 	unsigned long flags;
-	int ret =3D 0;
=20
 	spin_lock_irqsave(&uep->lock, flags);
 	pipe =3D usbhsg_uep_to_pipe(uep);
-	if (!pipe) {
-		ret =3D -EINVAL;
+	if (!pipe)
 		goto out;
-	}
=20
 	usbhsg_pipe_disable(uep);
 	usbhs_pipe_free(pipe);
diff --git a/drivers/video/fbdev/goldfishfb.c b/drivers/video/fbdev/goldfis=
hfb.c
index 7f6c9e6cfc6c..db015bb707fb 100644
--- a/drivers/video/fbdev/goldfishfb.c
+++ b/drivers/video/fbdev/goldfishfb.c
@@ -234,7 +234,7 @@ static int goldfish_fb_probe(struct platform_device *pd=
ev)
 	fb->fb.var.activate	=3D FB_ACTIVATE_NOW;
 	fb->fb.var.height	=3D readl(fb->reg_base + FB_GET_PHYS_HEIGHT);
 	fb->fb.var.width	=3D readl(fb->reg_base + FB_GET_PHYS_WIDTH);
-	fb->fb.var.pixclock	=3D 10000;
+	fb->fb.var.pixclock	=3D 0;
=20
 	fb->fb.var.red.offset =3D 11;
 	fb->fb.var.red.length =3D 5;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 20b4175a701f..5e07fcdef52f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5094,10 +5094,25 @@ static int ext4_expand_extra_isize(struct inode *in=
ode,
 {
 	struct ext4_inode *raw_inode;
 	struct ext4_xattr_ibody_header *header;
+	unsigned int inode_size =3D EXT4_INODE_SIZE(inode->i_sb);
+	struct ext4_inode_info *ei =3D EXT4_I(inode);
=20
 	if (EXT4_I(inode)->i_extra_isize >=3D new_extra_isize)
 		return 0;
=20
+	/* this was checked at iget time, but double check for good measure */
+	if ((EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize > inode_size) ||
+	    (ei->i_extra_isize & 3)) {
+		EXT4_ERROR_INODE(inode, "bad extra_isize %u (inode size %u)",
+				 ei->i_extra_isize,
+				 EXT4_INODE_SIZE(inode->i_sb));
+		return -EIO;
+	}
+	if ((new_extra_isize < ei->i_extra_isize) ||
+	    (new_extra_isize < 4) ||
+	    (new_extra_isize > inode_size - EXT4_GOOD_OLD_INODE_SIZE))
+		return -EINVAL;	/* Should never happen */
+
 	raw_inode =3D ext4_raw_inode(&iloc);
=20
 	header =3D IHDR(inode, raw_inode);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 282ebfd9d9f7..7410cca5bf39 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3423,6 +3423,40 @@ int ext4_calculate_overhead(struct super_block *sb)
 	return 0;
 }
=20
+static void ext4_clamp_want_extra_isize(struct super_block *sb)
+{
+	struct ext4_sb_info *sbi =3D EXT4_SB(sb);
+	struct ext4_super_block *es =3D sbi->s_es;
+	unsigned def_extra_isize =3D sizeof(struct ext4_inode) -
+						EXT4_GOOD_OLD_INODE_SIZE;
+
+	if (sbi->s_inode_size =3D=3D EXT4_GOOD_OLD_INODE_SIZE) {
+		sbi->s_want_extra_isize =3D 0;
+		return;
+	}
+	if (sbi->s_want_extra_isize < 4) {
+		sbi->s_want_extra_isize =3D def_extra_isize;
+		if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
+				       EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE)) {
+			if (sbi->s_want_extra_isize <
+			    le16_to_cpu(es->s_want_extra_isize))
+				sbi->s_want_extra_isize =3D
+					le16_to_cpu(es->s_want_extra_isize);
+			if (sbi->s_want_extra_isize <
+			    le16_to_cpu(es->s_min_extra_isize))
+				sbi->s_want_extra_isize =3D
+					le16_to_cpu(es->s_min_extra_isize);
+		}
+	}
+	/* Check if enough inode space is available */
+	if ((sbi->s_want_extra_isize > sbi->s_inode_size) ||
+	    (EXT4_GOOD_OLD_INODE_SIZE + sbi->s_want_extra_isize >
+							sbi->s_inode_size)) {
+		sbi->s_want_extra_isize =3D def_extra_isize;
+		ext4_msg(sb, KERN_INFO,
+			 "required extra inode space not available");
+	}
+}
=20
 static ext4_fsblk_t ext4_calculate_resv_clusters(struct super_block *sb)
 {
@@ -4245,30 +4279,7 @@ static int ext4_fill_super(struct super_block *sb, v=
oid *data, int silent)
 	if (ext4_setup_super(sb, es, sb->s_flags & MS_RDONLY))
 		sb->s_flags |=3D MS_RDONLY;
=20
-	/* determine the minimum size of new large inodes, if present */
-	if (sbi->s_inode_size > EXT4_GOOD_OLD_INODE_SIZE) {
-		sbi->s_want_extra_isize =3D sizeof(struct ext4_inode) -
-						     EXT4_GOOD_OLD_INODE_SIZE;
-		if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
-				       EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE)) {
-			if (sbi->s_want_extra_isize <
-			    le16_to_cpu(es->s_want_extra_isize))
-				sbi->s_want_extra_isize =3D
-					le16_to_cpu(es->s_want_extra_isize);
-			if (sbi->s_want_extra_isize <
-			    le16_to_cpu(es->s_min_extra_isize))
-				sbi->s_want_extra_isize =3D
-					le16_to_cpu(es->s_min_extra_isize);
-		}
-	}
-	/* Check if enough inode space is available */
-	if (EXT4_GOOD_OLD_INODE_SIZE + sbi->s_want_extra_isize >
-							sbi->s_inode_size) {
-		sbi->s_want_extra_isize =3D sizeof(struct ext4_inode) -
-						       EXT4_GOOD_OLD_INODE_SIZE;
-		ext4_msg(sb, KERN_INFO, "required extra inode space not"
-			 "available");
-	}
+	ext4_clamp_want_extra_isize(sb);
=20
 	err =3D ext4_reserve_clusters(sbi, ext4_calculate_resv_clusters(sb));
 	if (err) {
diff --git a/fs/readdir.c b/fs/readdir.c
index 33fd92208cb7..e1d49dd81ee7 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -50,6 +50,40 @@ int iterate_dir(struct file *file, struct dir_context *c=
tx)
 }
 EXPORT_SYMBOL(iterate_dir);
=20
+/*
+ * POSIX says that a dirent name cannot contain NULL or a '/'.
+ *
+ * It's not 100% clear what we should really do in this case.
+ * The filesystem is clearly corrupted, but returning a hard
+ * error means that you now don't see any of the other names
+ * either, so that isn't a perfect alternative.
+ *
+ * And if you return an error, what error do you use? Several
+ * filesystems seem to have decided on EUCLEAN being the error
+ * code for EFSCORRUPTED, and that may be the error to use. Or
+ * just EIO, which is perhaps more obvious to users.
+ *
+ * In order to see the other file names in the directory, the
+ * caller might want to make this a "soft" error: skip the
+ * entry, and return the error at the end instead.
+ *
+ * Note that this should likely do a "memchr(name, 0, len)"
+ * check too, since that would be filesystem corruption as
+ * well. However, that case can't actually confuse user space,
+ * which has to do a strlen() on the name anyway to find the
+ * filename length, and the above "soft error" worry means
+ * that it's probably better left alone until we have that
+ * issue clarified.
+ */
+static int verify_dirent_name(const char *name, int len)
+{
+	if (!len)
+		return -EIO;
+	if (memchr(name, '/', len))
+		return -EIO;
+	return 0;
+}
+
 /*
  * Traditional linux readdir() handling..
  *
@@ -157,6 +191,9 @@ static int filldir(void * __buf, const char * name, int=
 namlen, loff_t offset,
 	int reclen =3D ALIGN(offsetof(struct linux_dirent, d_name) + namlen + 2,
 		sizeof(long));
=20
+	buf->error =3D verify_dirent_name(name, namlen);
+	if (unlikely(buf->error))
+		return buf->error;
 	buf->error =3D -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
 		return -EINVAL;
@@ -240,6 +277,9 @@ static int filldir64(void * __buf, const char * name, i=
nt namlen, loff_t offset,
 	int reclen =3D ALIGN(offsetof(struct linux_dirent64, d_name) + namlen + 1,
 		sizeof(u64));
=20
+	buf->error =3D verify_dirent_name(name, namlen);
+	if (unlikely(buf->error))
+		return buf->error;
 	buf->error =3D -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
 		return -EINVAL;
diff --git a/include/asm-generic/fixmap.h b/include/asm-generic/fixmap.h
index f23174fb9ec4..10889b63af8f 100644
--- a/include/asm-generic/fixmap.h
+++ b/include/asm-generic/fixmap.h
@@ -67,12 +67,12 @@ static inline unsigned long virt_to_fix(const unsigned =
long vaddr)
 #endif
=20
 /* Return a pointer with offset calculated */
-#define __set_fixmap_offset(idx, phys, flags)		      \
-({							      \
-	unsigned long addr;				      \
-	__set_fixmap(idx, phys, flags);			      \
-	addr =3D fix_to_virt(idx) + ((phys) & (PAGE_SIZE - 1)); \
-	addr;						      \
+#define __set_fixmap_offset(idx, phys, flags)				\
+({									\
+	unsigned long ________addr;					\
+	__set_fixmap(idx, phys, flags);					\
+	________addr =3D fix_to_virt(idx) + ((phys) & (PAGE_SIZE - 1));	\
+	________addr;							\
 })
=20
 #define set_fixmap_offset(idx, phys) \
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 7f0a39d83b5d..1c19cf11338c 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -395,7 +395,6 @@ extern void end_swap_bio_write(struct bio *bio, int err=
);
 extern int __swap_writepage(struct page *page, struct writeback_control *w=
bc,
 	void (*end_write_func)(struct bio *, int));
 extern int swap_set_page_dirty(struct page *page);
-extern void end_swap_bio_read(struct bio *bio, int err);
=20
 int add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
 		unsigned long nr_pages, sector_t start_block);
diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connecti=
on_sock.h
index 5fbe6568c3cf..0e87152edaf1 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -287,11 +287,6 @@ static inline int inet_csk_reqsk_queue_len(const struc=
t sock *sk)
 	return reqsk_queue_len(&inet_csk(sk)->icsk_accept_queue);
 }
=20
-static inline int inet_csk_reqsk_queue_young(const struct sock *sk)
-{
-	return reqsk_queue_len_young(&inet_csk(sk)->icsk_accept_queue);
-}
-
 static inline int inet_csk_reqsk_queue_is_full(const struct sock *sk)
 {
 	return reqsk_queue_is_full(&inet_csk(sk)->icsk_accept_queue);
diff --git a/kernel/power/Makefile b/kernel/power/Makefile
index 29472bff11ef..cb880a14cc39 100644
--- a/kernel/power/Makefile
+++ b/kernel/power/Makefile
@@ -7,8 +7,7 @@ obj-$(CONFIG_VT_CONSOLE_SLEEP)	+=3D console.o
 obj-$(CONFIG_FREEZER)		+=3D process.o
 obj-$(CONFIG_SUSPEND)		+=3D suspend.o
 obj-$(CONFIG_PM_TEST_SUSPEND)	+=3D suspend_test.o
-obj-$(CONFIG_HIBERNATION)	+=3D hibernate.o snapshot.o swap.o user.o \
-				   block_io.o
+obj-$(CONFIG_HIBERNATION)	+=3D hibernate.o snapshot.o swap.o user.o
 obj-$(CONFIG_PM_AUTOSLEEP)	+=3D autosleep.o
 obj-$(CONFIG_PM_WAKELOCKS)	+=3D wakelock.o
=20
diff --git a/kernel/power/block_io.c b/kernel/power/block_io.c
deleted file mode 100644
index 9a58bc258810..000000000000
--- a/kernel/power/block_io.c
+++ /dev/null
@@ -1,103 +0,0 @@
-/*
- * This file provides functions for block I/O operations on swap/file.
- *
- * Copyright (C) 1998,2001-2005 Pavel Machek <pavel@ucw.cz>
- * Copyright (C) 2006 Rafael J. Wysocki <rjw@sisk.pl>
- *
- * This file is released under the GPLv2.
- */
-
-#include <linux/bio.h>
-#include <linux/kernel.h>
-#include <linux/pagemap.h>
-#include <linux/swap.h>
-
-#include "power.h"
-
-/**
- *	submit - submit BIO request.
- *	@rw:	READ or WRITE.
- *	@off	physical offset of page.
- *	@page:	page we're reading or writing.
- *	@bio_chain: list of pending biod (for async reading)
- *
- *	Straight from the textbook - allocate and initialize the bio.
- *	If we're reading, make sure the page is marked as dirty.
- *	Then submit it and, if @bio_chain =3D=3D NULL, wait.
- */
-static int submit(int rw, struct block_device *bdev, sector_t sector,
-		struct page *page, struct bio **bio_chain)
-{
-	const int bio_rw =3D rw | REQ_SYNC;
-	struct bio *bio;
-
-	bio =3D bio_alloc(__GFP_WAIT | __GFP_HIGH, 1);
-	bio->bi_iter.bi_sector =3D sector;
-	bio->bi_bdev =3D bdev;
-	bio->bi_end_io =3D end_swap_bio_read;
-
-	if (bio_add_page(bio, page, PAGE_SIZE, 0) < PAGE_SIZE) {
-		printk(KERN_ERR "PM: Adding page to bio failed at %llu\n",
-			(unsigned long long)sector);
-		bio_put(bio);
-		return -EFAULT;
-	}
-
-	lock_page(page);
-	bio_get(bio);
-
-	if (bio_chain =3D=3D NULL) {
-		submit_bio(bio_rw, bio);
-		wait_on_page_locked(page);
-		if (rw =3D=3D READ)
-			bio_set_pages_dirty(bio);
-		bio_put(bio);
-	} else {
-		if (rw =3D=3D READ)
-			get_page(page);	/* These pages are freed later */
-		bio->bi_private =3D *bio_chain;
-		*bio_chain =3D bio;
-		submit_bio(bio_rw, bio);
-	}
-	return 0;
-}
-
-int hib_bio_read_page(pgoff_t page_off, void *addr, struct bio **bio_chain)
-{
-	return submit(READ, hib_resume_bdev, page_off * (PAGE_SIZE >> 9),
-			virt_to_page(addr), bio_chain);
-}
-
-int hib_bio_write_page(pgoff_t page_off, void *addr, struct bio **bio_chai=
n)
-{
-	return submit(WRITE, hib_resume_bdev, page_off * (PAGE_SIZE >> 9),
-			virt_to_page(addr), bio_chain);
-}
-
-int hib_wait_on_bio_chain(struct bio **bio_chain)
-{
-	struct bio *bio;
-	struct bio *next_bio;
-	int ret =3D 0;
-
-	if (bio_chain =3D=3D NULL)
-		return 0;
-
-	bio =3D *bio_chain;
-	if (bio =3D=3D NULL)
-		return 0;
-	while (bio) {
-		struct page *page;
-
-		next_bio =3D bio->bi_private;
-		page =3D bio->bi_io_vec[0].bv_page;
-		wait_on_page_locked(page);
-		if (!PageUptodate(page) || PageError(page))
-			ret =3D -EIO;
-		put_page(page);
-		bio_put(bio);
-		bio =3D next_bio;
-	}
-	*bio_chain =3D NULL;
-	return ret;
-}
diff --git a/kernel/power/power.h b/kernel/power/power.h
index c60f13b5270a..d8b40d4a7f88 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -163,15 +163,6 @@ extern void swsusp_close(fmode_t);
 extern int swsusp_unmark(void);
 #endif
=20
-/* kernel/power/block_io.c */
-extern struct block_device *hib_resume_bdev;
-
-extern int hib_bio_read_page(pgoff_t page_off, void *addr,
-		struct bio **bio_chain);
-extern int hib_bio_write_page(pgoff_t page_off, void *addr,
-		struct bio **bio_chain);
-extern int hib_wait_on_bio_chain(struct bio **bio_chain);
-
 struct timeval;
 /* kernel/power/swsusp.c */
 extern void swsusp_show_speed(struct timeval *, struct timeval *,
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index aaa3261dea5d..59f3b18b57b4 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -35,6 +35,14 @@
=20
 #define HIBERNATE_SIG	"S1SUSPEND"
=20
+/*
+ * When reading an {un,}compressed image, we may restore pages in place,
+ * in which case some architectures need these pages cleaning before they
+ * can be executed. We don't know which pages these may be, so clean the l=
ot.
+ */
+static bool clean_pages_on_read;
+static bool clean_pages_on_decompress;
+
 /*
  *	The swap map is a data structure used for keeping track of each page
  *	written to a swap partition.  It consists of many swap_map_page
@@ -211,7 +219,87 @@ int swsusp_swap_in_use(void)
  */
=20
 static unsigned short root_swap =3D 0xffff;
-struct block_device *hib_resume_bdev;
+static struct block_device *hib_resume_bdev;
+
+struct hib_bio_batch {
+	atomic_t		count;
+	wait_queue_head_t	wait;
+	int			error;
+};
+
+static void hib_init_batch(struct hib_bio_batch *hb)
+{
+	atomic_set(&hb->count, 0);
+	init_waitqueue_head(&hb->wait);
+	hb->error =3D 0;
+}
+
+static void hib_end_io(struct bio *bio, int error)
+{
+	struct hib_bio_batch *hb =3D bio->bi_private;
+	const int uptodate =3D test_bit(BIO_UPTODATE, &bio->bi_flags);
+	struct page *page =3D bio->bi_io_vec[0].bv_page;
+
+	if (!uptodate || error) {
+		printk(KERN_ALERT "Read-error on swap-device (%u:%u:%Lu)\n",
+				imajor(bio->bi_bdev->bd_inode),
+				iminor(bio->bi_bdev->bd_inode),
+				(unsigned long long)bio->bi_iter.bi_sector);
+
+		if (!error)
+			error =3D -EIO;
+	}
+
+	if (bio_data_dir(bio) =3D=3D WRITE)
+		put_page(page);
+	else if (clean_pages_on_read)
+		flush_icache_range((unsigned long)page_address(page),
+				   (unsigned long)page_address(page) + PAGE_SIZE);
+
+	if (error && !hb->error)
+		hb->error =3D error;
+	if (atomic_dec_and_test(&hb->count))
+		wake_up(&hb->wait);
+
+	bio_put(bio);
+}
+
+static int hib_submit_io(int rw, pgoff_t page_off, void *addr,
+		struct hib_bio_batch *hb)
+{
+	struct page *page =3D virt_to_page(addr);
+	struct bio *bio;
+	int error =3D 0;
+
+	bio =3D bio_alloc(__GFP_WAIT | __GFP_HIGH, 1);
+	bio->bi_iter.bi_sector =3D page_off * (PAGE_SIZE >> 9);
+	bio->bi_bdev =3D hib_resume_bdev;
+
+	if (bio_add_page(bio, page, PAGE_SIZE, 0) < PAGE_SIZE) {
+		printk(KERN_ERR "PM: Adding page to bio failed at %llu\n",
+			(unsigned long long)bio->bi_iter.bi_sector);
+		bio_put(bio);
+		return -EFAULT;
+	}
+
+	if (hb) {
+		bio->bi_end_io =3D hib_end_io;
+		bio->bi_private =3D hb;
+		atomic_inc(&hb->count);
+		submit_bio(rw, bio);
+	} else {
+		error =3D submit_bio_wait(rw, bio);
+		bio_put(bio);
+	}
+
+	return error;
+}
+
+static int hib_wait_io(struct hib_bio_batch *hb)
+{
+	wait_event(hb->wait, atomic_read(&hb->count) =3D=3D 0);
+	return hb->error;
+}
=20
 /*
  * Saving part
@@ -221,7 +309,7 @@ static int mark_swapfiles(struct swap_map_handle *handl=
e, unsigned int flags)
 {
 	int error;
=20
-	hib_bio_read_page(swsusp_resume_block, swsusp_header, NULL);
+	hib_submit_io(READ_SYNC, swsusp_resume_block, swsusp_header, NULL);
 	if (!memcmp("SWAP-SPACE",swsusp_header->sig, 10) ||
 	    !memcmp("SWAPSPACE2",swsusp_header->sig, 10)) {
 		memcpy(swsusp_header->orig_sig,swsusp_header->sig, 10);
@@ -230,7 +318,7 @@ static int mark_swapfiles(struct swap_map_handle *handl=
e, unsigned int flags)
 		swsusp_header->flags =3D flags;
 		if (flags & SF_CRC32_MODE)
 			swsusp_header->crc32 =3D handle->crc32;
-		error =3D hib_bio_write_page(swsusp_resume_block,
+		error =3D hib_submit_io(WRITE_SYNC, swsusp_resume_block,
 					swsusp_header, NULL);
 	} else {
 		printk(KERN_ERR "PM: Swap header not found!\n");
@@ -270,10 +358,10 @@ static int swsusp_swap_check(void)
  *	write_page - Write one page to given swap location.
  *	@buf:		Address we're writing.
  *	@offset:	Offset of the swap page we're writing to.
- *	@bio_chain:	Link the next write BIO here
+ *	@hb:		bio completion batch
  */
=20
-static int write_page(void *buf, sector_t offset, struct bio **bio_chain)
+static int write_page(void *buf, sector_t offset, struct hib_bio_batch *hb)
 {
 	void *src;
 	int ret;
@@ -281,13 +369,13 @@ static int write_page(void *buf, sector_t offset, str=
uct bio **bio_chain)
 	if (!offset)
 		return -ENOSPC;
=20
-	if (bio_chain) {
+	if (hb) {
 		src =3D (void *)__get_free_page(__GFP_WAIT | __GFP_NOWARN |
 		                              __GFP_NORETRY);
 		if (src) {
 			copy_page(src, buf);
 		} else {
-			ret =3D hib_wait_on_bio_chain(bio_chain); /* Free pages */
+			ret =3D hib_wait_io(hb); /* Free pages */
 			if (ret)
 				return ret;
 			src =3D (void *)__get_free_page(__GFP_WAIT |
@@ -297,14 +385,14 @@ static int write_page(void *buf, sector_t offset, str=
uct bio **bio_chain)
 				copy_page(src, buf);
 			} else {
 				WARN_ON_ONCE(1);
-				bio_chain =3D NULL;	/* Go synchronous */
+				hb =3D NULL;	/* Go synchronous */
 				src =3D buf;
 			}
 		}
 	} else {
 		src =3D buf;
 	}
-	return hib_bio_write_page(offset, src, bio_chain);
+	return hib_submit_io(WRITE_SYNC, offset, src, hb);
 }
=20
 static void release_swap_writer(struct swap_map_handle *handle)
@@ -347,7 +435,7 @@ static int get_swap_writer(struct swap_map_handle *hand=
le)
 }
=20
 static int swap_write_page(struct swap_map_handle *handle, void *buf,
-				struct bio **bio_chain)
+		struct hib_bio_batch *hb)
 {
 	int error =3D 0;
 	sector_t offset;
@@ -355,7 +443,7 @@ static int swap_write_page(struct swap_map_handle *hand=
le, void *buf,
 	if (!handle->cur)
 		return -EINVAL;
 	offset =3D alloc_swapdev_block(root_swap);
-	error =3D write_page(buf, offset, bio_chain);
+	error =3D write_page(buf, offset, hb);
 	if (error)
 		return error;
 	handle->cur->entries[handle->k++] =3D offset;
@@ -364,15 +452,15 @@ static int swap_write_page(struct swap_map_handle *ha=
ndle, void *buf,
 		if (!offset)
 			return -ENOSPC;
 		handle->cur->next_swap =3D offset;
-		error =3D write_page(handle->cur, handle->cur_swap, bio_chain);
+		error =3D write_page(handle->cur, handle->cur_swap, hb);
 		if (error)
 			goto out;
 		clear_page(handle->cur);
 		handle->cur_swap =3D offset;
 		handle->k =3D 0;
=20
-		if (bio_chain && low_free_pages() <=3D handle->reqd_free_pages) {
-			error =3D hib_wait_on_bio_chain(bio_chain);
+		if (hb && low_free_pages() <=3D handle->reqd_free_pages) {
+			error =3D hib_wait_io(hb);
 			if (error)
 				goto out;
 			/*
@@ -444,23 +532,24 @@ static int save_image(struct swap_map_handle *handle,
 	int ret;
 	int nr_pages;
 	int err2;
-	struct bio *bio;
+	struct hib_bio_batch hb;
 	struct timeval start;
 	struct timeval stop;
=20
+	hib_init_batch(&hb);
+
 	printk(KERN_INFO "PM: Saving image data pages (%u pages)...\n",
 		nr_to_write);
 	m =3D nr_to_write / 10;
 	if (!m)
 		m =3D 1;
 	nr_pages =3D 0;
-	bio =3D NULL;
 	do_gettimeofday(&start);
 	while (1) {
 		ret =3D snapshot_read_next(snapshot);
 		if (ret <=3D 0)
 			break;
-		ret =3D swap_write_page(handle, data_of(*snapshot), &bio);
+		ret =3D swap_write_page(handle, data_of(*snapshot), &hb);
 		if (ret)
 			break;
 		if (!(nr_pages % m))
@@ -468,7 +557,7 @@ static int save_image(struct swap_map_handle *handle,
 			       nr_pages / m * 10);
 		nr_pages++;
 	}
-	err2 =3D hib_wait_on_bio_chain(&bio);
+	err2 =3D hib_wait_io(&hb);
 	do_gettimeofday(&stop);
 	if (!ret)
 		ret =3D err2;
@@ -579,7 +668,7 @@ static int save_image_lzo(struct swap_map_handle *handl=
e,
 	int ret =3D 0;
 	int nr_pages;
 	int err2;
-	struct bio *bio;
+	struct hib_bio_batch hb;
 	struct timeval start;
 	struct timeval stop;
 	size_t off;
@@ -588,6 +677,8 @@ static int save_image_lzo(struct swap_map_handle *handl=
e,
 	struct cmp_data *data =3D NULL;
 	struct crc_data *crc =3D NULL;
=20
+	hib_init_batch(&hb);
+
 	/*
 	 * We'll limit the number of threads for compression to limit memory
 	 * footprint.
@@ -673,7 +764,6 @@ static int save_image_lzo(struct swap_map_handle *handl=
e,
 	if (!m)
 		m =3D 1;
 	nr_pages =3D 0;
-	bio =3D NULL;
 	do_gettimeofday(&start);
 	for (;;) {
 		for (thr =3D 0; thr < nr_threads; thr++) {
@@ -747,7 +837,7 @@ static int save_image_lzo(struct swap_map_handle *handl=
e,
 			     off +=3D PAGE_SIZE) {
 				memcpy(page, data[thr].cmp + off, PAGE_SIZE);
=20
-				ret =3D swap_write_page(handle, page, &bio);
+				ret =3D swap_write_page(handle, page, &hb);
 				if (ret)
 					goto out_finish;
 			}
@@ -758,7 +848,7 @@ static int save_image_lzo(struct swap_map_handle *handl=
e,
 	}
=20
 out_finish:
-	err2 =3D hib_wait_on_bio_chain(&bio);
+	err2 =3D hib_wait_io(&hb);
 	do_gettimeofday(&stop);
 	if (!ret)
 		ret =3D err2;
@@ -905,7 +995,7 @@ static int get_swap_reader(struct swap_map_handle *hand=
le,
 			return -ENOMEM;
 		}
=20
-		error =3D hib_bio_read_page(offset, tmp->map, NULL);
+		error =3D hib_submit_io(READ_SYNC, offset, tmp->map, NULL);
 		if (error) {
 			release_swap_reader(handle);
 			return error;
@@ -918,7 +1008,7 @@ static int get_swap_reader(struct swap_map_handle *han=
dle,
 }
=20
 static int swap_read_page(struct swap_map_handle *handle, void *buf,
-				struct bio **bio_chain)
+		struct hib_bio_batch *hb)
 {
 	sector_t offset;
 	int error;
@@ -929,7 +1019,7 @@ static int swap_read_page(struct swap_map_handle *hand=
le, void *buf,
 	offset =3D handle->cur->entries[handle->k];
 	if (!offset)
 		return -EFAULT;
-	error =3D hib_bio_read_page(offset, buf, bio_chain);
+	error =3D hib_submit_io(READ_SYNC, offset, buf, hb);
 	if (error)
 		return error;
 	if (++handle->k >=3D MAP_PAGE_ENTRIES) {
@@ -967,27 +1057,29 @@ static int load_image(struct swap_map_handle *handle,
 	int ret =3D 0;
 	struct timeval start;
 	struct timeval stop;
-	struct bio *bio;
+	struct hib_bio_batch hb;
 	int err2;
 	unsigned nr_pages;
=20
+	hib_init_batch(&hb);
+
+	clean_pages_on_read =3D true;
 	printk(KERN_INFO "PM: Loading image data pages (%u pages)...\n",
 		nr_to_read);
 	m =3D nr_to_read / 10;
 	if (!m)
 		m =3D 1;
 	nr_pages =3D 0;
-	bio =3D NULL;
 	do_gettimeofday(&start);
 	for ( ; ; ) {
 		ret =3D snapshot_write_next(snapshot);
 		if (ret <=3D 0)
 			break;
-		ret =3D swap_read_page(handle, data_of(*snapshot), &bio);
+		ret =3D swap_read_page(handle, data_of(*snapshot), &hb);
 		if (ret)
 			break;
 		if (snapshot->sync_read)
-			ret =3D hib_wait_on_bio_chain(&bio);
+			ret =3D hib_wait_io(&hb);
 		if (ret)
 			break;
 		if (!(nr_pages % m))
@@ -995,7 +1087,7 @@ static int load_image(struct swap_map_handle *handle,
 			       nr_pages / m * 10);
 		nr_pages++;
 	}
-	err2 =3D hib_wait_on_bio_chain(&bio);
+	err2 =3D hib_wait_io(&hb);
 	do_gettimeofday(&stop);
 	if (!ret)
 		ret =3D err2;
@@ -1047,6 +1139,10 @@ static int lzo_decompress_threadfn(void *data)
 		d->unc_len =3D LZO_UNC_SIZE;
 		d->ret =3D lzo1x_decompress_safe(d->cmp + LZO_HEADER, d->cmp_len,
 		                               d->unc, &d->unc_len);
+		if (clean_pages_on_decompress)
+			flush_icache_range((unsigned long)d->unc,
+					   (unsigned long)d->unc + d->unc_len);
+
 		atomic_set(&d->stop, 1);
 		wake_up(&d->done);
 	}
@@ -1066,7 +1162,7 @@ static int load_image_lzo(struct swap_map_handle *han=
dle,
 	unsigned int m;
 	int ret =3D 0;
 	int eof =3D 0;
-	struct bio *bio;
+	struct hib_bio_batch hb;
 	struct timeval start;
 	struct timeval stop;
 	unsigned nr_pages;
@@ -1079,6 +1175,8 @@ static int load_image_lzo(struct swap_map_handle *han=
dle,
 	struct dec_data *data =3D NULL;
 	struct crc_data *crc =3D NULL;
=20
+	hib_init_batch(&hb);
+
 	/*
 	 * We'll limit the number of threads for decompression to limit memory
 	 * footprint.
@@ -1110,6 +1208,8 @@ static int load_image_lzo(struct swap_map_handle *han=
dle,
 	}
 	memset(crc, 0, offsetof(struct crc_data, go));
=20
+	clean_pages_on_decompress =3D true;
+
 	/*
 	 * Start the decompression threads.
 	 */
@@ -1189,7 +1289,6 @@ static int load_image_lzo(struct swap_map_handle *han=
dle,
 	if (!m)
 		m =3D 1;
 	nr_pages =3D 0;
-	bio =3D NULL;
 	do_gettimeofday(&start);
=20
 	ret =3D snapshot_write_next(snapshot);
@@ -1198,7 +1297,7 @@ static int load_image_lzo(struct swap_map_handle *han=
dle,
=20
 	for(;;) {
 		for (i =3D 0; !eof && i < want; i++) {
-			ret =3D swap_read_page(handle, page[ring], &bio);
+			ret =3D swap_read_page(handle, page[ring], &hb);
 			if (ret) {
 				/*
 				 * On real read error, finish. On end of data,
@@ -1225,7 +1324,7 @@ static int load_image_lzo(struct swap_map_handle *han=
dle,
 			if (!asked)
 				break;
=20
-			ret =3D hib_wait_on_bio_chain(&bio);
+			ret =3D hib_wait_io(&hb);
 			if (ret)
 				goto out_finish;
 			have +=3D asked;
@@ -1280,7 +1379,7 @@ static int load_image_lzo(struct swap_map_handle *han=
dle,
 		 * Wait for more data while we are decompressing.
 		 */
 		if (have < LZO_CMP_PAGES && asked) {
-			ret =3D hib_wait_on_bio_chain(&bio);
+			ret =3D hib_wait_io(&hb);
 			if (ret)
 				goto out_finish;
 			have +=3D asked;
@@ -1429,7 +1528,7 @@ int swsusp_check(void)
 	if (!IS_ERR(hib_resume_bdev)) {
 		set_blocksize(hib_resume_bdev, PAGE_SIZE);
 		clear_page(swsusp_header);
-		error =3D hib_bio_read_page(swsusp_resume_block,
+		error =3D hib_submit_io(READ_SYNC, swsusp_resume_block,
 					swsusp_header, NULL);
 		if (error)
 			goto put;
@@ -1437,7 +1536,7 @@ int swsusp_check(void)
 		if (!memcmp(HIBERNATE_SIG, swsusp_header->sig, 10)) {
 			memcpy(swsusp_header->sig, swsusp_header->orig_sig, 10);
 			/* Reset swap signature now */
-			error =3D hib_bio_write_page(swsusp_resume_block,
+			error =3D hib_submit_io(WRITE_SYNC, swsusp_resume_block,
 						swsusp_header, NULL);
 		} else {
 			error =3D -EINVAL;
@@ -1481,10 +1580,10 @@ int swsusp_unmark(void)
 {
 	int error;
=20
-	hib_bio_read_page(swsusp_resume_block, swsusp_header, NULL);
+	hib_submit_io(READ_SYNC, swsusp_resume_block, swsusp_header, NULL);
 	if (!memcmp(HIBERNATE_SIG,swsusp_header->sig, 10)) {
 		memcpy(swsusp_header->sig,swsusp_header->orig_sig, 10);
-		error =3D hib_bio_write_page(swsusp_resume_block,
+		error =3D hib_submit_io(WRITE_SYNC, swsusp_resume_block,
 					swsusp_header, NULL);
 	} else {
 		printk(KERN_ERR "PM: Cannot find swsusp signature!\n");
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 773135f534ef..e17c063a8028 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3163,7 +3163,6 @@ void __refill_cfs_bandwidth_runtime(struct cfs_bandwi=
dth *cfs_b)
 	now =3D sched_clock_cpu(smp_processor_id());
 	cfs_b->runtime =3D cfs_b->quota;
 	cfs_b->runtime_expires =3D now + ktime_to_ns(cfs_b->period);
-	cfs_b->expires_seq++;
 }
=20
 static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
@@ -3186,7 +3185,6 @@ static int assign_cfs_rq_runtime(struct cfs_rq *cfs_r=
q)
 	struct task_group *tg =3D cfs_rq->tg;
 	struct cfs_bandwidth *cfs_b =3D tg_cfs_bandwidth(tg);
 	u64 amount =3D 0, min_amount, expires;
-	int expires_seq;
=20
 	/* note: this is a positive sum as runtime_remaining <=3D 0 */
 	min_amount =3D sched_cfs_bandwidth_slice() - cfs_rq->runtime_remaining;
@@ -3212,7 +3210,6 @@ static int assign_cfs_rq_runtime(struct cfs_rq *cfs_r=
q)
 			cfs_b->idle =3D 0;
 		}
 	}
-	expires_seq =3D cfs_b->expires_seq;
 	expires =3D cfs_b->runtime_expires;
 	raw_spin_unlock(&cfs_b->lock);
=20
@@ -3222,10 +3219,8 @@ static int assign_cfs_rq_runtime(struct cfs_rq *cfs_=
rq)
 	 * spread between our sched_clock and the one on which runtime was
 	 * issued.
 	 */
-	if (cfs_rq->expires_seq !=3D expires_seq) {
-		cfs_rq->expires_seq =3D expires_seq;
+	if ((s64)(expires - cfs_rq->runtime_expires) > 0)
 		cfs_rq->runtime_expires =3D expires;
-	}
=20
 	return cfs_rq->runtime_remaining > 0;
 }
@@ -3251,9 +3246,12 @@ static void expire_cfs_rq_runtime(struct cfs_rq *cfs=
_rq)
 	 * has not truly expired.
 	 *
 	 * Fortunately we can check determine whether this the case by checking
-	 * whether the global deadline(cfs_b->expires_seq) has advanced.
+	 * whether the global deadline has advanced. It is valid to compare
+	 * cfs_b->runtime_expires without any locks since we only care about
+	 * exact equality, so a partial write will still work.
 	 */
-	if (cfs_rq->expires_seq =3D=3D cfs_b->expires_seq) {
+
+	if (cfs_rq->runtime_expires !=3D cfs_b->runtime_expires) {
 		/* extend local deadline, drift is bounded above by 2 ticks */
 		cfs_rq->runtime_expires +=3D TICK_NSEC;
 	} else {
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 41e3547263d4..a4f5c7540cf2 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -187,7 +187,6 @@ struct cfs_bandwidth {
 	u64 quota, runtime;
 	s64 hierarchal_quota;
 	u64 runtime_expires;
-	int expires_seq;
=20
 	int idle, timer_active;
 	struct hrtimer period_timer, slack_timer;
@@ -377,7 +376,6 @@ struct cfs_rq {
=20
 #ifdef CONFIG_CFS_BANDWIDTH
 	int runtime_enabled;
-	int expires_seq;
 	u64 runtime_expires;
 	s64 runtime_remaining;
=20
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index d32caa3e1d28..37bec1879062 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -151,7 +151,14 @@ static void FETCH_FUNC_NAME(memory, string)(struct pt_=
regs *regs,
=20
 	ret =3D strncpy_from_user(dst, src, maxlen);
 	if (ret =3D=3D maxlen)
-		dst[--ret] =3D '\0';
+		dst[ret - 1] =3D '\0';
+	else if (ret >=3D 0)
+		/*
+		 * Include the terminating null byte. In this case it
+		 * was copied by strncpy_from_user but not accounted
+		 * for in ret.
+		 */
+		ret++;
=20
 	if (ret < 0) {	/* Failed to fetch string */
 		((u8 *)get_rloc_data(dest))[0] =3D '\0';
diff --git a/mm/page_io.c b/mm/page_io.c
index 955db8b0d497..98131dff2323 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -69,7 +69,7 @@ void end_swap_bio_write(struct bio *bio, int err)
 	bio_put(bio);
 }
=20
-void end_swap_bio_read(struct bio *bio, int err)
+static void end_swap_bio_read(struct bio *bio, int err)
 {
 	const int uptodate =3D test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct page *page =3D bio->bi_io_vec[0].bv_page;
diff --git a/mm/rmap.c b/mm/rmap.c
index d3d26ce2903c..84114323c5f8 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -403,7 +403,7 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma =3D avc->anon_vma;
=20
-		BUG_ON(anon_vma->degree);
+		VM_WARN_ON(anon_vma->degree);
 		put_anon_vma(anon_vma);
=20
 		list_del(&avc->same_vma);
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index a1edd9bd70ad..edd56cc3108f 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1984,15 +1984,19 @@ static int process_connect(struct ceph_connection *=
con)
 	dout("process_connect on %p tag %d\n", con, (int)con->in_tag);
=20
 	if (con->auth_reply_buf) {
+		int len =3D le32_to_cpu(con->in_reply.authorizer_len);
+
 		/*
 		 * Any connection that defines ->get_authorizer()
 		 * should also define ->verify_authorizer_reply().
 		 * See get_connect_authorizer().
 		 */
-		ret =3D con->ops->verify_authorizer_reply(con, 0);
-		if (ret < 0) {
-			con->error_msg =3D "bad authorize reply";
-			return ret;
+		if (len) {
+			ret =3D con->ops->verify_authorizer_reply(con, 0);
+			if (ret < 0) {
+				con->error_msg =3D "bad authorize reply";
+				return ret;
+			}
 		}
 	}
=20
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index ca9f3d8c0c69..789bccbb30bf 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -621,13 +621,7 @@ int dccp_v4_conn_request(struct sock *sk, struct sk_bu=
ff *skb)
 	if (inet_csk_reqsk_queue_is_full(sk))
 		goto drop;
=20
-	/*
-	 * Accept backlog is full. If we have already queued enough
-	 * of warm entries in syn queue, drop request. It is better than
-	 * clogging syn queue with openreqs with exponentially increasing
-	 * timeout.
-	 */
-	if (sk_acceptq_is_full(sk) && inet_csk_reqsk_queue_young(sk) > 1)
+	if (sk_acceptq_is_full(sk))
 		goto drop;
=20
 	req =3D inet_reqsk_alloc(&dccp_request_sock_ops);
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index c3ed865d262f..664229a90817 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -391,7 +391,7 @@ static int dccp_v6_conn_request(struct sock *sk, struct=
 sk_buff *skb)
 	if (inet_csk_reqsk_queue_is_full(sk))
 		goto drop;
=20
-	if (sk_acceptq_is_full(sk) && inet_csk_reqsk_queue_young(sk) > 1)
+	if (sk_acceptq_is_full(sk))
 		goto drop;
=20
 	req =3D inet6_reqsk_alloc(&dccp6_request_sock_ops);
diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index 4eeba4e497a0..ed0a661c2e24 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -318,12 +318,18 @@ int inet_diag_dump_one_icsk(struct inet_hashinfo *has=
hinfo, struct sk_buff *in_s
 	}
 #if IS_ENABLED(CONFIG_IPV6)
 	else if (req->sdiag_family =3D=3D AF_INET6) {
-		sk =3D inet6_lookup(net, hashinfo,
-				  (struct in6_addr *)req->id.idiag_dst,
-				  req->id.idiag_dport,
-				  (struct in6_addr *)req->id.idiag_src,
-				  req->id.idiag_sport,
-				  req->id.idiag_if);
+		if (ipv6_addr_v4mapped((struct in6_addr *)req->id.idiag_dst) &&
+		    ipv6_addr_v4mapped((struct in6_addr *)req->id.idiag_src))
+			sk =3D inet_lookup(net, hashinfo, req->id.idiag_dst[3],
+					 req->id.idiag_dport, req->id.idiag_src[3],
+					 req->id.idiag_sport, req->id.idiag_if);
+		else
+			sk =3D inet6_lookup(net, hashinfo,
+					  (struct in6_addr *)req->id.idiag_dst,
+					  req->id.idiag_dport,
+					  (struct in6_addr *)req->id.idiag_src,
+					  req->id.idiag_sport,
+					  req->id.idiag_if);
 	}
 #endif
 	else {
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index d3a4cb33f5f0..d803c8df378e 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1292,12 +1292,7 @@ int tcp_v4_conn_request(struct sock *sk, struct sk_b=
uff *skb)
 			goto drop;
 	}
=20
-	/* Accept backlog is full. If we have already queued enough
-	 * of warm entries in syn queue, drop request. It is better than
-	 * clogging syn queue with openreqs with exponentially increasing
-	 * timeout.
-	 */
-	if (sk_acceptq_is_full(sk) && inet_csk_reqsk_queue_young(sk) > 1) {
+	if (sk_acceptq_is_full(sk)) {
 		NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_LISTENOVERFLOWS);
 		goto drop;
 	}
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 4370371e0aa6..0eb27c808bfa 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1009,7 +1009,7 @@ static int tcp_v6_conn_request(struct sock *sk, struc=
t sk_buff *skb)
 			goto drop;
 	}
=20
-	if (sk_acceptq_is_full(sk) && inet_csk_reqsk_queue_young(sk) > 1) {
+	if (sk_acceptq_is_full(sk)) {
 		NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_LISTENOVERFLOWS);
 		goto drop;
 	}
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index cafec3788750..8de2f98e0e2b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10463,7 +10463,7 @@ static void nl80211_send_mlme_event(struct cfg80211=
_registered_device *rdev,
 	struct sk_buff *msg;
 	void *hdr;
=20
-	msg =3D nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	msg =3D nlmsg_new(100 + len, gfp);
 	if (!msg)
 		return;
=20
@@ -10602,7 +10602,7 @@ void nl80211_send_connect_result(struct cfg80211_re=
gistered_device *rdev,
 	struct sk_buff *msg;
 	void *hdr;
=20
-	msg =3D nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	msg =3D nlmsg_new(100 + req_ie_len + resp_ie_len, gfp);
 	if (!msg)
 		return;
=20
@@ -10642,7 +10642,7 @@ void nl80211_send_roamed(struct cfg80211_registered=
_device *rdev,
 	struct sk_buff *msg;
 	void *hdr;
=20
-	msg =3D nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	msg =3D nlmsg_new(100 + req_ie_len + resp_ie_len, gfp);
 	if (!msg)
 		return;
=20
@@ -10680,7 +10680,7 @@ void nl80211_send_disconnected(struct cfg80211_regi=
stered_device *rdev,
 	struct sk_buff *msg;
 	void *hdr;
=20
-	msg =3D nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	msg =3D nlmsg_new(100 + ie_len, GFP_KERNEL);
 	if (!msg)
 		return;
=20
@@ -10757,7 +10757,7 @@ void cfg80211_notify_new_peer_candidate(struct net_=
device *dev, const u8 *addr,
=20
 	trace_cfg80211_notify_new_peer_candidate(dev, addr);
=20
-	msg =3D nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	msg =3D nlmsg_new(100 + ie_len, gfp);
 	if (!msg)
 		return;
=20
@@ -11133,7 +11133,7 @@ int nl80211_send_mgmt(struct cfg80211_registered_de=
vice *rdev,
 	struct sk_buff *msg;
 	void *hdr;
=20
-	msg =3D nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	msg =3D nlmsg_new(100 + len, gfp);
 	if (!msg)
 		return -ENOMEM;
=20
@@ -11176,7 +11176,7 @@ void cfg80211_mgmt_tx_status(struct wireless_dev *w=
dev, u64 cookie,
=20
 	trace_cfg80211_mgmt_tx_status(wdev, cookie, ack);
=20
-	msg =3D nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	msg =3D nlmsg_new(100 + len, gfp);
 	if (!msg)
 		return;
=20
@@ -11886,7 +11886,7 @@ void cfg80211_ft_event(struct net_device *netdev,
 	if (!ft_event->target_ap)
 		return;
=20
-	msg =3D nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	msg =3D nlmsg_new(100 + ft_event->ric_ies_len, GFP_KERNEL);
 	if (!msg)
 		return;
=20
diff --git a/scripts/setlocalversion b/scripts/setlocalversion
index 63d91e22ed7c..966dd3924ea9 100755
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -143,7 +143,7 @@ fi
 if test -e include/config/auto.conf; then
 	. include/config/auto.conf
 else
-	echo "Error: kernelrelease not valid - run 'make prepare' to update it"
+	echo "Error: kernelrelease not valid - run 'make prepare' to update it" >=
&2
 	exit 1
 fi
=20
diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index bbb42b34e2fb..604a23a611f0 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -38,6 +38,7 @@
 #include <linux/uio.h>
 #include <linux/uaccess.h>
 #include <linux/module.h>
+#include <linux/compat.h>
 #include <sound/core.h>
 #include <sound/initval.h>
 #include <sound/compress_params.h>
@@ -864,6 +865,15 @@ static long snd_compr_ioctl(struct file *f, unsigned i=
nt cmd, unsigned long arg)
 	return retval;
 }
=20
+/* support of 32bit userspace on 64bit platforms */
+#ifdef CONFIG_COMPAT
+static long snd_compr_ioctl_compat(struct file *file, unsigned int cmd,
+						unsigned long arg)
+{
+	return snd_compr_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
+}
+#endif
+
 static const struct file_operations snd_compr_file_ops =3D {
 		.owner =3D	THIS_MODULE,
 		.open =3D		snd_compr_open,
@@ -871,6 +881,9 @@ static const struct file_operations snd_compr_file_ops =
=3D {
 		.write =3D	snd_compr_write,
 		.read =3D		snd_compr_read,
 		.unlocked_ioctl =3D snd_compr_ioctl,
+#ifdef CONFIG_COMPAT
+		.compat_ioctl =3D snd_compr_ioctl_compat,
+#endif
 		.mmap =3D		snd_compr_mmap,
 		.poll =3D		snd_compr_poll,
 };

--FL5UXtIhxfXey3p5--

--aM3YZ0Iwxop3KEKx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl4ZtT0ACgkQ57/I7JWG
EQmrUA/9FZQio7VWV4fRpAkS5NTOvPagmrzWGgnCutBRIYUFywPuZ8he9TEN0Qev
0PpLKSuF2i8I0Y1A98ceeSAskNHjD3+0UYjSM1uHhtzuyYwJQ5r9StNMrO/vp7lW
8BVnMwqpY7Z9zcjp2OcY0uXyv656EAI6O5idf9NMJ7/PpT6Awd7vlkWcW+wNp+L0
vQcvZGI3FhL95U2wW7RBUj2CuYNZJKwHlVuUIj2uAI+MzUpBz0NDHKenRNc1l8Zf
E4Yd1B1pSuPyxAATtQn0kXjDUXGnML+bk1dO1NPKimlcAheZ+P7LLb8PKNIgYfZD
P/WhmsurdQmp/qvmpTEAXEs6sk289iHhiVO2GrVUNFgM3+A6ffvGg45GI5EH8s9E
QHVNhbB096WbogEcYCgT2rYYKTjOjp0A27kTKdpOhdOGzaL++CGN96d4ZG0mcE0e
QNswS4HQXUCf0wbamWK0OA81zvO60DMxk+HCw0DuDFsY9GxMu8eR5WaoE7yqqAVr
xlWelAJkuH757/QNSV4JjPIlQlKI25hZBCv52uDiMPeSRVB5scmHpVruJjalZhJE
YDK8Rz0u3G9A6sRRyUpdoinfb9QIby65ZOGajvaaztLCpX0r9aBNVJnQE4Laz3NL
/6Vp2f5CvN0EqvKPT6xu0Xxyhc+4hSnPAIdShFmpHqmQzFH2Eus=
=6P6Y
-----END PGP SIGNATURE-----

--aM3YZ0Iwxop3KEKx--
