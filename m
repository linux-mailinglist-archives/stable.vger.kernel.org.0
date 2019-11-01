Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFECEC4D3
	for <lists+stable@lfdr.de>; Fri,  1 Nov 2019 15:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfKAOhB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Nov 2019 10:37:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35778 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726840AbfKAOhA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Nov 2019 10:37:00 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iQY2q-0004CJ-Es; Fri, 01 Nov 2019 14:36:56 +0000
Received: from ben by deadeye with local (Exim 4.92.2)
        (envelope-from <ben@decadent.org.uk>)
        id 1iQY2q-0006Bs-7y; Fri, 01 Nov 2019 14:36:56 +0000
Message-ID: <631985498707641410dc918537e5542c36910b5f.camel@decadent.org.uk>
Subject: Linux 3.16.76
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc:     lwn@lwn.net
Date:   Fri, 01 Nov 2019 14:36:55 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-5WFpcKYFlIG4pupIH3/U"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-5WFpcKYFlIG4pupIH3/U
Content-Type: multipart/mixed; boundary="=-bi1/Cp80qL9Ej+YCxqV7"


--=-bi1/Cp80qL9Ej+YCxqV7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.16.76 kernel.

All users of the 3.16 kernel series should upgrade.

The updated 3.16.y git tree can be found at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
.git linux-3.16.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.gi=
t

The diff from 3.16.75 is attached to this message.

Ben.

------------

 Makefile                                    |  2 +-
 arch/arc/kernel/unwind.c                    |  9 ++-
 arch/arm/mach-rpc/dma.c                     |  5 +-
 arch/parisc/kernel/ptrace.c                 | 28 +++++----
 arch/powerpc/kernel/exceptions-64s.S        |  9 ++-
 arch/powerpc/kernel/swsusp_32.S             | 73 +++++++++++++++++++---
 arch/powerpc/platforms/powermac/sleep.S     | 68 +++++++++++++++++++--
 arch/s390/include/asm/facility.h            | 21 ++++---
 arch/x86/kernel/ptrace.c                    |  4 +-
 arch/x86/kernel/tls.c                       |  9 ++-
 arch/x86/kvm/pmu.c                          |  4 +-
 crypto/ghash-generic.c                      |  8 ++-
 drivers/crypto/talitos.c                    | 13 ++++
 drivers/edac/edac_mc_sysfs.c                | 16 ++---
 drivers/edac/edac_module.h                  |  2 +-
 drivers/gpio/gpio-omap.c                    |  2 +
 drivers/input/mouse/trackpoint.h            |  3 +-
 drivers/media/v4l2-core/v4l2-ctrls.c        |  9 ++-
 drivers/memstick/core/memstick.c            | 13 ++--
 drivers/misc/vmw_vmci/vmci_context.c        | 80 ++++++++++++++-----------
 drivers/misc/vmw_vmci/vmci_handle_array.c   | 38 ++++++++----
 drivers/misc/vmw_vmci/vmci_handle_array.h   | 29 +++++----
 drivers/net/bonding/bond_main.c             | 37 +++++++-----
 drivers/net/caif/caif_hsi.c                 |  2 +-
 drivers/net/wireless/ath/carl9170/usb.c     | 39 ++++++------
 drivers/net/wireless/mwifiex/fw.h           | 12 +++-
 drivers/net/wireless/mwifiex/main.h         |  1 +
 drivers/net/wireless/mwifiex/scan.c         | 21 ++++---
 drivers/net/wireless/mwifiex/sta_ioctl.c    |  4 +-
 drivers/net/wireless/mwifiex/wmm.c          |  2 +-
 drivers/pci/pci.c                           |  7 +++
 drivers/s390/cio/qdio_main.c                |  1 +
 drivers/s390/cio/qdio_setup.c               |  2 +
 drivers/s390/cio/qdio_thinint.c             |  5 +-
 drivers/tty/serial/cpm_uart/cpm_uart_core.c | 17 ++++--
 drivers/usb/gadget/u_ether.c                |  6 +-
 drivers/usb/serial/ftdi_sio.c               |  1 +
 drivers/usb/serial/ftdi_sio_ids.h           |  6 ++
 drivers/usb/serial/option.c                 |  3 +
 fs/coda/file.c                              | 70 +++++++++++++++++++++-
 fs/ecryptfs/crypto.c                        | 12 ++--
 fs/nfs/inode.c                              |  1 +
 fs/nfs/nfs4file.c                           |  2 +-
 fs/udf/inode.c                              | 93 +++++++++++++++++++------=
----
 include/linux/vmw_vmci_defs.h               | 11 +++-
 kernel/padata.c                             | 12 ++++
 kernel/pid_namespace.c                      |  2 +-
 lib/scatterlist.c                           |  9 +--
 mm/mmu_notifier.c                           |  2 +-
 net/9p/trans_virtio.c                       |  8 ++-
 net/bridge/br_stp_bpdu.c                    |  3 +-
 net/core/neighbour.c                        |  2 +
 net/ipv4/igmp.c                             |  8 +--
 net/key/af_key.c                            |  8 ++-
 net/xfrm/xfrm_user.c                        | 19 ++++++
 sound/core/seq/seq_clientmgr.c              | 11 +++-
 56 files changed, 641 insertions(+), 243 deletions(-)

Andreas Fritiofson (1):
      USB: serial: ftdi_sio: add ID for isodebug v1

Anirudh Gupta (1):
      xfrm: Fix xfrm sel prefix length validation

Arnd Bergmann (1):
      ARC: hide unused function unw_hdr_alloc

Ben Hutchings (1):
      Linux 3.16.76

Boris Brezillon (1):
      media: v4l2: Test type instead of cfg->type in v4l2_ctrl_new_custom()

Brian Norris (2):
      mwifiex: Don't abort on small, spec-compliant vendor IEs
      mwifiex: fix 802.11n/WPA detection

Christian Lamparter (1):
      carl9170: fix misuse of device driver API

Christophe Leroy (4):
      tty: serial: cpm_uart - fix init when SMC is relocated
      crypto: talitos - check AES key size
      powerpc/32s: fix suspend/resume when IBATs 4-7 are used
      lib/scatterlist: Fix mapping iterator when sg->offset is greater than=
 PAGE_SIZE

Cong Wang (1):
      bonding: validate ip header before check IPPROTO_IGMP

Dan Carpenter (1):
      eCryptfs: fix a couple type promotion bugs

Daniel Jordan (1):
      padata: use smp_mb in padata_reorder to avoid orphaned padata jobs

Dianzhang Chen (2):
      x86/ptrace: Fix possible spectre-v1 in ptrace_get_debugreg()
      x86/tls: Fix possible spectre-v1 in do_get_thread_area()

Eiichi Tsukata (1):
      EDAC: Fix global-out-of-bounds write when setting edac_mc_poll_msec

Eric Biggers (1):
      crypto: ghash - fix unaligned memory access in ghash_setkey()

Eric Dumazet (1):
      igmp: fix memory leak in igmpv3_del_delrec()

Eric W. Biederman (1):
      signal/pid_namespace: Fix reboot_pid_ns to use send_sig not force_sig

Heiko Carstens (1):
      s390: fix stfle zero padding

Helge Deller (1):
      parisc: Fix kernel panic due invalid values in IAOQ0 or IAOQ1

Jan Harkes (1):
      coda: pass the host file in vma->vm_file on mmap

Jean-Philippe Brucker (1):
      mm/mmu_notifier: use hlist_add_head_rcu()

Jeremy Sowden (1):
      af_key: fix leaks in key_pol_get_resp and dump_sp.

Julian Wiedmann (3):
      s390/qdio: handle PENDING state for QEBSM devices
      s390/qdio: (re-)initialize tiqdio list entries
      s390/qdio: don't touch the dsci in tiqdio_add_input_queues()

J=C3=B6rgen Storvist (2):
      USB: serial: option: add GosunCn ZTE WeLink ME3630
      USB: serial: option: add support for GosunCn ME3630 RNDIS mode

Kiruthika Varadarajan (1):
      usb: gadget: ether: Fix race between gether_disconnect and rx_submit

Like Xu (1):
      KVM: x86/vPMU: refine kvm_pmu err msg when event creation failed

Lorenzo Bianconi (1):
      net: neigh: fix multiple neigh timer scheduling

Mika Westerberg (1):
      PCI: Do not poll for PME if the device is in D3cold

Nicolas Dichtel (1):
      xfrm: fix sa selector validation

Nikolay Aleksandrov (1):
      net: bridge: stp: don't cache eth dest pointer before skb pull

Ravi Bangoria (1):
      powerpc/watchpoint: Restore NV GPRs while returning from exception

Russell King (2):
      ARM: riscpc: fix DMA
      gpio: omap: fix lack of irqstatus_raw0 for OMAP4

Steven J. Magnani (1):
      udf: Fix incorrect final NOT_ALLOCATED (hole) extent length

Taehee Yoo (1):
      caif-hsi: fix possible deadlock in cfhsi_exit_module()

Takashi Iwai (1):
      ALSA: seq: Break too long mutex context in the write loop

Trond Myklebust (1):
      NFSv4: Handle the special Linux file open access mode

Vishnu DASA (1):
      VMCI: Fix integer overflow in VMCI handle arrays

Wang Hai (1):
      memstick: Fix error cleanup path of memstick_init

YueHaibing (2):
      9p/virtio: Add cleanup path in p9_virtio_init
      Input: psmouse - fix build error of multiple definition

--=20
Ben Hutchings
Reality is just a crutch for people who can't handle science fiction.



--=-bi1/Cp80qL9Ej+YCxqV7
Content-Type: text/x-diff; charset="UTF-8"; name="linux-3.16.76.patch"
Content-Disposition: attachment; filename="linux-3.16.76.patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/Makefile b/Makefile
index 44181a4e18f4..44d0302480fd 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 16
-SUBLEVEL =3D 75
+SUBLEVEL =3D 76
 EXTRAVERSION =3D
 NAME =3D Museum of Fishiegoodies
=20
diff --git a/arch/arc/kernel/unwind.c b/arch/arc/kernel/unwind.c
index 9bfbd0a01b95..48ab76b1055a 100644
--- a/arch/arc/kernel/unwind.c
+++ b/arch/arc/kernel/unwind.c
@@ -183,11 +183,6 @@ static void *__init unw_hdr_alloc_early(unsigned long =
sz)
 				       MAX_DMA_ADDRESS);
 }
=20
-static void *unw_hdr_alloc(unsigned long sz)
-{
-	return kmalloc(sz, GFP_KERNEL);
-}
-
 static void init_unwind_table(struct unwind_table *table, const char *name=
,
 			      const void *core_start, unsigned long core_size,
 			      const void *init_start, unsigned long init_size,
@@ -368,6 +363,10 @@ static void init_unwind_hdr(struct unwind_table *table=
,
 }
=20
 #ifdef CONFIG_MODULES
+static void *unw_hdr_alloc(unsigned long sz)
+{
+	return kmalloc(sz, GFP_KERNEL);
+}
=20
 static struct unwind_table *last_table;
=20
diff --git a/arch/arm/mach-rpc/dma.c b/arch/arm/mach-rpc/dma.c
index 6d3517dc4772..82aac38fa2cf 100644
--- a/arch/arm/mach-rpc/dma.c
+++ b/arch/arm/mach-rpc/dma.c
@@ -131,7 +131,7 @@ static irqreturn_t iomd_dma_handle(int irq, void *dev_i=
d)
 	} while (1);
=20
 	idma->state =3D ~DMA_ST_AB;
-	disable_irq(irq);
+	disable_irq_nosync(irq);
=20
 	return IRQ_HANDLED;
 }
@@ -174,6 +174,9 @@ static void iomd_enable_dma(unsigned int chan, dma_t *d=
ma)
 				DMA_FROM_DEVICE : DMA_TO_DEVICE);
 		}
=20
+		idma->dma_addr =3D idma->dma.sg->dma_address;
+		idma->dma_len =3D idma->dma.sg->length;
+
 		iomd_writeb(DMA_CR_C, dma_base + CR);
 		idma->state =3D DMA_ST_AB;
 	}
diff --git a/arch/parisc/kernel/ptrace.c b/arch/parisc/kernel/ptrace.c
index e842ee233db4..c847cf07d4c0 100644
--- a/arch/parisc/kernel/ptrace.c
+++ b/arch/parisc/kernel/ptrace.c
@@ -155,6 +155,9 @@ long arch_ptrace(struct task_struct *child, long reques=
t,
 		if ((addr & (sizeof(unsigned long)-1)) ||
 		     addr >=3D sizeof(struct pt_regs))
 			break;
+		if (addr =3D=3D PT_IAOQ0 || addr =3D=3D PT_IAOQ1) {
+			data |=3D 3; /* ensure userspace privilege */
+		}
 		if ((addr >=3D PT_GR1 && addr <=3D PT_GR31) ||
 				addr =3D=3D PT_IAOQ0 || addr =3D=3D PT_IAOQ1 ||
 				(addr >=3D PT_FR0 && addr <=3D PT_FR31 + 4) ||
@@ -188,16 +191,18 @@ long arch_ptrace(struct task_struct *child, long requ=
est,
=20
 static compat_ulong_t translate_usr_offset(compat_ulong_t offset)
 {
-	if (offset < 0)
-		return sizeof(struct pt_regs);
-	else if (offset <=3D 32*4)	/* gr[0..31] */
-		return offset * 2 + 4;
-	else if (offset <=3D 32*4+32*8)	/* gr[0..31] + fr[0..31] */
-		return offset + 32*4;
-	else if (offset < sizeof(struct pt_regs)/2 + 32*4)
-		return offset * 2 + 4 - 32*8;
+	compat_ulong_t pos;
+
+	if (offset < 32*4)	/* gr[0..31] */
+		pos =3D offset * 2 + 4;
+	else if (offset < 32*4+32*8)	/* fr[0] ... fr[31] */
+		pos =3D (offset - 32*4) + PT_FR0;
+	else if (offset < sizeof(struct pt_regs)/2 + 32*4) /* sr[0] ... ipsw */
+		pos =3D (offset - 32*4 - 32*8) * 2 + PT_SR0 + 4;
 	else
-		return sizeof(struct pt_regs);
+		pos =3D sizeof(struct pt_regs);
+
+	return pos;
 }
=20
 long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
@@ -241,9 +246,12 @@ long compat_arch_ptrace(struct task_struct *child, com=
pat_long_t request,
 			addr =3D translate_usr_offset(addr);
 			if (addr >=3D sizeof(struct pt_regs))
 				break;
+			if (addr =3D=3D PT_IAOQ0+4 || addr =3D=3D PT_IAOQ1+4) {
+				data |=3D 3; /* ensure userspace privilege */
+			}
 			if (addr >=3D PT_FR0 && addr <=3D PT_FR31 + 4) {
 				/* Special case, fp regs are 64 bits anyway */
-				*(__u64 *) ((char *) task_regs(child) + addr) =3D data;
+				*(__u32 *) ((char *) task_regs(child) + addr) =3D data;
 				ret =3D 0;
 			}
 			else if ((addr >=3D PT_GR1+4 && addr <=3D PT_GR31+4) ||
diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exc=
eptions-64s.S
index 7d8a755f5558..1bb6d24a935b 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -1630,7 +1630,7 @@ END_MMU_FTR_SECTION_IFCLR(MMU_FTR_SLB)
 	addi	r3,r1,STACK_FRAME_OVERHEAD
 	bl	do_page_fault
 	cmpdi	r3,0
-	beq+	12f
+	beq+	ret_from_except_lite
 	bl	save_nvgprs
 	mr	r5,r3
 	addi	r3,r1,STACK_FRAME_OVERHEAD
@@ -1645,7 +1645,12 @@ END_MMU_FTR_SECTION_IFCLR(MMU_FTR_SLB)
 	ld      r5,_DSISR(r1)
 	addi    r3,r1,STACK_FRAME_OVERHEAD
 	bl      do_break
-12:	b       ret_from_except_lite
+	/*
+	 * do_break() may have changed the NV GPRS while handling a breakpoint.
+	 * If so, we need to restore them with their updated values. Don't use
+	 * ret_from_except_lite here.
+	 */
+	b       ret_from_except
=20
=20
 /* We have a page fault that hash_page could handle but HV refused
diff --git a/arch/powerpc/kernel/swsusp_32.S b/arch/powerpc/kernel/swsusp_3=
2.S
index ba4dee3d233f..884d1c3a187b 100644
--- a/arch/powerpc/kernel/swsusp_32.S
+++ b/arch/powerpc/kernel/swsusp_32.S
@@ -23,11 +23,19 @@
 #define SL_IBAT2	0x48
 #define SL_DBAT3	0x50
 #define SL_IBAT3	0x58
-#define SL_TB		0x60
-#define SL_R2		0x68
-#define SL_CR		0x6c
-#define SL_LR		0x70
-#define SL_R12		0x74	/* r12 to r31 */
+#define SL_DBAT4	0x60
+#define SL_IBAT4	0x68
+#define SL_DBAT5	0x70
+#define SL_IBAT5	0x78
+#define SL_DBAT6	0x80
+#define SL_IBAT6	0x88
+#define SL_DBAT7	0x90
+#define SL_IBAT7	0x98
+#define SL_TB		0xa0
+#define SL_R2		0xa8
+#define SL_CR		0xac
+#define SL_LR		0xb0
+#define SL_R12		0xb4	/* r12 to r31 */
 #define SL_SIZE		(SL_R12 + 80)
=20
 	.section .data
@@ -112,6 +120,41 @@ _GLOBAL(swsusp_arch_suspend)
 	mfibatl	r4,3
 	stw	r4,SL_IBAT3+4(r11)
=20
+BEGIN_MMU_FTR_SECTION
+	mfspr	r4,SPRN_DBAT4U
+	stw	r4,SL_DBAT4(r11)
+	mfspr	r4,SPRN_DBAT4L
+	stw	r4,SL_DBAT4+4(r11)
+	mfspr	r4,SPRN_DBAT5U
+	stw	r4,SL_DBAT5(r11)
+	mfspr	r4,SPRN_DBAT5L
+	stw	r4,SL_DBAT5+4(r11)
+	mfspr	r4,SPRN_DBAT6U
+	stw	r4,SL_DBAT6(r11)
+	mfspr	r4,SPRN_DBAT6L
+	stw	r4,SL_DBAT6+4(r11)
+	mfspr	r4,SPRN_DBAT7U
+	stw	r4,SL_DBAT7(r11)
+	mfspr	r4,SPRN_DBAT7L
+	stw	r4,SL_DBAT7+4(r11)
+	mfspr	r4,SPRN_IBAT4U
+	stw	r4,SL_IBAT4(r11)
+	mfspr	r4,SPRN_IBAT4L
+	stw	r4,SL_IBAT4+4(r11)
+	mfspr	r4,SPRN_IBAT5U
+	stw	r4,SL_IBAT5(r11)
+	mfspr	r4,SPRN_IBAT5L
+	stw	r4,SL_IBAT5+4(r11)
+	mfspr	r4,SPRN_IBAT6U
+	stw	r4,SL_IBAT6(r11)
+	mfspr	r4,SPRN_IBAT6L
+	stw	r4,SL_IBAT6+4(r11)
+	mfspr	r4,SPRN_IBAT7U
+	stw	r4,SL_IBAT7(r11)
+	mfspr	r4,SPRN_IBAT7L
+	stw	r4,SL_IBAT7+4(r11)
+END_MMU_FTR_SECTION_IFSET(MMU_FTR_USE_HIGH_BATS)
+
 #if  0
 	/* Backup various CPU config stuffs */
 	bl	__save_cpu_setup
@@ -277,27 +320,41 @@ END_FTR_SECTION_IFSET(CPU_FTR_ALTIVEC)
 	mtibatu	3,r4
 	lwz	r4,SL_IBAT3+4(r11)
 	mtibatl	3,r4
-#endif
-
 BEGIN_MMU_FTR_SECTION
-	li	r4,0
+	lwz	r4,SL_DBAT4(r11)
 	mtspr	SPRN_DBAT4U,r4
+	lwz	r4,SL_DBAT4+4(r11)
 	mtspr	SPRN_DBAT4L,r4
+	lwz	r4,SL_DBAT5(r11)
 	mtspr	SPRN_DBAT5U,r4
+	lwz	r4,SL_DBAT5+4(r11)
 	mtspr	SPRN_DBAT5L,r4
+	lwz	r4,SL_DBAT6(r11)
 	mtspr	SPRN_DBAT6U,r4
+	lwz	r4,SL_DBAT6+4(r11)
 	mtspr	SPRN_DBAT6L,r4
+	lwz	r4,SL_DBAT7(r11)
 	mtspr	SPRN_DBAT7U,r4
+	lwz	r4,SL_DBAT7+4(r11)
 	mtspr	SPRN_DBAT7L,r4
+	lwz	r4,SL_IBAT4(r11)
 	mtspr	SPRN_IBAT4U,r4
+	lwz	r4,SL_IBAT4+4(r11)
 	mtspr	SPRN_IBAT4L,r4
+	lwz	r4,SL_IBAT5(r11)
 	mtspr	SPRN_IBAT5U,r4
+	lwz	r4,SL_IBAT5+4(r11)
 	mtspr	SPRN_IBAT5L,r4
+	lwz	r4,SL_IBAT6(r11)
 	mtspr	SPRN_IBAT6U,r4
+	lwz	r4,SL_IBAT6+4(r11)
 	mtspr	SPRN_IBAT6L,r4
+	lwz	r4,SL_IBAT7(r11)
 	mtspr	SPRN_IBAT7U,r4
+	lwz	r4,SL_IBAT7+4(r11)
 	mtspr	SPRN_IBAT7L,r4
 END_MMU_FTR_SECTION_IFSET(MMU_FTR_USE_HIGH_BATS)
+#endif
=20
 	/* Flush all TLBs */
 	lis	r4,0x1000
diff --git a/arch/powerpc/platforms/powermac/sleep.S b/arch/powerpc/platfor=
ms/powermac/sleep.S
index 1c2802fabd57..c856cd7fcdc4 100644
--- a/arch/powerpc/platforms/powermac/sleep.S
+++ b/arch/powerpc/platforms/powermac/sleep.S
@@ -37,10 +37,18 @@
 #define SL_IBAT2	0x48
 #define SL_DBAT3	0x50
 #define SL_IBAT3	0x58
-#define SL_TB		0x60
-#define SL_R2		0x68
-#define SL_CR		0x6c
-#define SL_R12		0x70	/* r12 to r31 */
+#define SL_DBAT4	0x60
+#define SL_IBAT4	0x68
+#define SL_DBAT5	0x70
+#define SL_IBAT5	0x78
+#define SL_DBAT6	0x80
+#define SL_IBAT6	0x88
+#define SL_DBAT7	0x90
+#define SL_IBAT7	0x98
+#define SL_TB		0xa0
+#define SL_R2		0xa8
+#define SL_CR		0xac
+#define SL_R12		0xb0	/* r12 to r31 */
 #define SL_SIZE		(SL_R12 + 80)
=20
 	.section .text
@@ -125,6 +133,41 @@ _GLOBAL(low_sleep_handler)
 	mfibatl	r4,3
 	stw	r4,SL_IBAT3+4(r1)
=20
+BEGIN_MMU_FTR_SECTION
+	mfspr	r4,SPRN_DBAT4U
+	stw	r4,SL_DBAT4(r1)
+	mfspr	r4,SPRN_DBAT4L
+	stw	r4,SL_DBAT4+4(r1)
+	mfspr	r4,SPRN_DBAT5U
+	stw	r4,SL_DBAT5(r1)
+	mfspr	r4,SPRN_DBAT5L
+	stw	r4,SL_DBAT5+4(r1)
+	mfspr	r4,SPRN_DBAT6U
+	stw	r4,SL_DBAT6(r1)
+	mfspr	r4,SPRN_DBAT6L
+	stw	r4,SL_DBAT6+4(r1)
+	mfspr	r4,SPRN_DBAT7U
+	stw	r4,SL_DBAT7(r1)
+	mfspr	r4,SPRN_DBAT7L
+	stw	r4,SL_DBAT7+4(r1)
+	mfspr	r4,SPRN_IBAT4U
+	stw	r4,SL_IBAT4(r1)
+	mfspr	r4,SPRN_IBAT4L
+	stw	r4,SL_IBAT4+4(r1)
+	mfspr	r4,SPRN_IBAT5U
+	stw	r4,SL_IBAT5(r1)
+	mfspr	r4,SPRN_IBAT5L
+	stw	r4,SL_IBAT5+4(r1)
+	mfspr	r4,SPRN_IBAT6U
+	stw	r4,SL_IBAT6(r1)
+	mfspr	r4,SPRN_IBAT6L
+	stw	r4,SL_IBAT6+4(r1)
+	mfspr	r4,SPRN_IBAT7U
+	stw	r4,SL_IBAT7(r1)
+	mfspr	r4,SPRN_IBAT7L
+	stw	r4,SL_IBAT7+4(r1)
+END_MMU_FTR_SECTION_IFSET(MMU_FTR_USE_HIGH_BATS)
+
 	/* Backup various CPU config stuffs */
 	bl	__save_cpu_setup
=20
@@ -325,22 +368,37 @@ _GLOBAL(core99_wake_up)
 	mtibatl	3,r4
=20
 BEGIN_MMU_FTR_SECTION
-	li	r4,0
+	lwz	r4,SL_DBAT4(r1)
 	mtspr	SPRN_DBAT4U,r4
+	lwz	r4,SL_DBAT4+4(r1)
 	mtspr	SPRN_DBAT4L,r4
+	lwz	r4,SL_DBAT5(r1)
 	mtspr	SPRN_DBAT5U,r4
+	lwz	r4,SL_DBAT5+4(r1)
 	mtspr	SPRN_DBAT5L,r4
+	lwz	r4,SL_DBAT6(r1)
 	mtspr	SPRN_DBAT6U,r4
+	lwz	r4,SL_DBAT6+4(r1)
 	mtspr	SPRN_DBAT6L,r4
+	lwz	r4,SL_DBAT7(r1)
 	mtspr	SPRN_DBAT7U,r4
+	lwz	r4,SL_DBAT7+4(r1)
 	mtspr	SPRN_DBAT7L,r4
+	lwz	r4,SL_IBAT4(r1)
 	mtspr	SPRN_IBAT4U,r4
+	lwz	r4,SL_IBAT4+4(r1)
 	mtspr	SPRN_IBAT4L,r4
+	lwz	r4,SL_IBAT5(r1)
 	mtspr	SPRN_IBAT5U,r4
+	lwz	r4,SL_IBAT5+4(r1)
 	mtspr	SPRN_IBAT5L,r4
+	lwz	r4,SL_IBAT6(r1)
 	mtspr	SPRN_IBAT6U,r4
+	lwz	r4,SL_IBAT6+4(r1)
 	mtspr	SPRN_IBAT6L,r4
+	lwz	r4,SL_IBAT7(r1)
 	mtspr	SPRN_IBAT7U,r4
+	lwz	r4,SL_IBAT7+4(r1)
 	mtspr	SPRN_IBAT7L,r4
 END_MMU_FTR_SECTION_IFSET(MMU_FTR_USE_HIGH_BATS)
=20
diff --git a/arch/s390/include/asm/facility.h b/arch/s390/include/asm/facil=
ity.h
index 0aa6a7ed95a3..81ae12261291 100644
--- a/arch/s390/include/asm/facility.h
+++ b/arch/s390/include/asm/facility.h
@@ -33,6 +33,18 @@ static inline int test_facility(unsigned long nr)
 	return __test_facility(nr, &S390_lowcore.stfle_fac_list);
 }
=20
+static inline unsigned long __stfle_asm(u64 *stfle_fac_list, int size)
+{
+	register unsigned long reg0 asm("0") =3D size - 1;
+
+	asm volatile(
+		".insn s,0xb2b00000,0(%1)" /* stfle */
+		: "+d" (reg0)
+		: "a" (stfle_fac_list)
+		: "memory", "cc");
+	return reg0;
+}
+
 /**
  * stfle - Store facility list extended
  * @stfle_fac_list: array where facility list can be stored
@@ -52,13 +64,8 @@ static inline void stfle(u64 *stfle_fac_list, int size)
 	memcpy(stfle_fac_list, &S390_lowcore.stfl_fac_list, 4);
 	if (S390_lowcore.stfl_fac_list & 0x01000000) {
 		/* More facility bits available with stfle */
-		register unsigned long reg0 asm("0") =3D size - 1;
-
-		asm volatile(".insn s,0xb2b00000,0(%1)" /* stfle */
-			     : "+d" (reg0)
-			     : "a" (stfle_fac_list)
-			     : "memory", "cc");
-		nr =3D (reg0 + 1) * 8; /* # bytes stored by stfle */
+		nr =3D __stfle_asm(stfle_fac_list, size);
+		nr =3D min_t(unsigned long, (nr + 1) * 8, size * 8);
 	}
 	memset((char *) stfle_fac_list + nr, 0, size * 8 - nr);
 	preempt_enable();
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 8072696aa20f..619f0c77f203 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -24,6 +24,7 @@
 #include <linux/rcupdate.h>
 #include <linux/export.h>
 #include <linux/context_tracking.h>
+#include <linux/nospec.h>
=20
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -707,7 +708,8 @@ static unsigned long ptrace_get_debugreg(struct task_st=
ruct *tsk, int n)
 	unsigned long val =3D 0;
=20
 	if (n < HBP_NUM) {
-		struct perf_event *bp =3D thread->ptrace_bps[n];
+		int index =3D array_index_nospec(n, HBP_NUM);
+		struct perf_event *bp =3D thread->ptrace_bps[index];
=20
 		if (bp)
 			val =3D bp->hw.info.address;
diff --git a/arch/x86/kernel/tls.c b/arch/x86/kernel/tls.c
index 7fc5e843f247..9f03c7e07a2b 100644
--- a/arch/x86/kernel/tls.c
+++ b/arch/x86/kernel/tls.c
@@ -4,6 +4,7 @@
 #include <linux/user.h>
 #include <linux/regset.h>
 #include <linux/syscalls.h>
+#include <linux/nospec.h>
=20
 #include <asm/uaccess.h>
 #include <asm/desc.h>
@@ -177,6 +178,7 @@ int do_get_thread_area(struct task_struct *p, int idx,
 		       struct user_desc __user *u_info)
 {
 	struct user_desc info;
+	int index;
=20
 	if (idx =3D=3D -1 && get_user(idx, &u_info->entry_number))
 		return -EFAULT;
@@ -184,8 +186,11 @@ int do_get_thread_area(struct task_struct *p, int idx,
 	if (idx < GDT_ENTRY_TLS_MIN || idx > GDT_ENTRY_TLS_MAX)
 		return -EINVAL;
=20
-	fill_user_desc(&info, idx,
-		       &p->thread.tls_array[idx - GDT_ENTRY_TLS_MIN]);
+	index =3D idx - GDT_ENTRY_TLS_MIN;
+	index =3D array_index_nospec(index,
+			GDT_ENTRY_TLS_MAX - GDT_ENTRY_TLS_MIN + 1);
+
+	fill_user_desc(&info, idx, &p->thread.tls_array[index]);
=20
 	if (copy_to_user(u_info, &info, sizeof(info)))
 		return -EFAULT;
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index cbecaa90399c..803e5bfef09d 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -187,8 +187,8 @@ static void reprogram_counter(struct kvm_pmc *pmc, u32 =
type,
 						 intr ? kvm_perf_overflow_intr :
 						 kvm_perf_overflow, pmc);
 	if (IS_ERR(event)) {
-		printk_once("kvm: pmu event creation failed %ld\n",
-				PTR_ERR(event));
+		pr_debug_ratelimited("kvm_pmu: event creation failed %ld for pmc->idx =
=3D %d\n",
+			    PTR_ERR(event), pmc->idx);
 		return;
 	}
=20
diff --git a/crypto/ghash-generic.c b/crypto/ghash-generic.c
index bac70995e064..241f05348e93 100644
--- a/crypto/ghash-generic.c
+++ b/crypto/ghash-generic.c
@@ -45,6 +45,7 @@ static int ghash_setkey(struct crypto_shash *tfm,
 			const u8 *key, unsigned int keylen)
 {
 	struct ghash_ctx *ctx =3D crypto_shash_ctx(tfm);
+	be128 k;
=20
 	if (keylen !=3D GHASH_BLOCK_SIZE) {
 		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
@@ -53,7 +54,12 @@ static int ghash_setkey(struct crypto_shash *tfm,
=20
 	if (ctx->gf128)
 		gf128mul_free_4k(ctx->gf128);
-	ctx->gf128 =3D gf128mul_init_4k_lle((be128 *)key);
+
+	BUILD_BUG_ON(sizeof(k) !=3D GHASH_BLOCK_SIZE);
+	memcpy(&k, key, GHASH_BLOCK_SIZE); /* avoid violating alignment rules */
+	ctx->gf128 =3D gf128mul_init_4k_lle(&k);
+	memzero_explicit(&k, GHASH_BLOCK_SIZE);
+
 	if (!ctx->gf128)
 		return -ENOMEM;
=20
diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 0d3f3af79bde..45485d975b71 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1335,6 +1335,18 @@ static int ablkcipher_setkey(struct crypto_ablkciphe=
r *cipher,
 	return 0;
 }
=20
+static int ablkcipher_aes_setkey(struct crypto_ablkcipher *cipher,
+				  const u8 *key, unsigned int keylen)
+{
+	if (keylen =3D=3D AES_KEYSIZE_128 || keylen =3D=3D AES_KEYSIZE_192 ||
+	    keylen =3D=3D AES_KEYSIZE_256)
+		return ablkcipher_setkey(cipher, key, keylen);
+
+	crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+
+	return -EINVAL;
+}
+
 static void common_nonsnoop_unmap(struct device *dev,
 				  struct talitos_edesc *edesc,
 				  struct ablkcipher_request *areq)
@@ -2170,6 +2182,7 @@ static struct talitos_alg_template driver_algs[] =3D =
{
 				.min_keysize =3D AES_MIN_KEY_SIZE,
 				.max_keysize =3D AES_MAX_KEY_SIZE,
 				.ivsize =3D AES_BLOCK_SIZE,
+				.setkey =3D ablkcipher_aes_setkey,
 			}
 		},
 		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 0cfe126f15fa..afa292546266 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -26,7 +26,7 @@
 static int edac_mc_log_ue =3D 1;
 static int edac_mc_log_ce =3D 1;
 static int edac_mc_panic_on_ue;
-static int edac_mc_poll_msec =3D 1000;
+static unsigned int edac_mc_poll_msec =3D 1000;
=20
 /* Getter functions for above */
 int edac_mc_get_log_ue(void)
@@ -45,30 +45,30 @@ int edac_mc_get_panic_on_ue(void)
 }
=20
 /* this is temporary */
-int edac_mc_get_poll_msec(void)
+unsigned int edac_mc_get_poll_msec(void)
 {
 	return edac_mc_poll_msec;
 }
=20
 static int edac_set_poll_msec(const char *val, struct kernel_param *kp)
 {
-	unsigned long l;
+	unsigned int i;
 	int ret;
=20
 	if (!val)
 		return -EINVAL;
=20
-	ret =3D kstrtoul(val, 0, &l);
+	ret =3D kstrtouint(val, 0, &i);
 	if (ret)
 		return ret;
=20
-	if (l < 1000)
+	if (i < 1000)
 		return -EINVAL;
=20
-	*((unsigned long *)kp->arg) =3D l;
+	*((unsigned int *)kp->arg) =3D i;
=20
 	/* notify edac_mc engine to reset the poll period */
-	edac_mc_reset_delay_period(l);
+	edac_mc_reset_delay_period(i);
=20
 	return 0;
 }
@@ -82,7 +82,7 @@ MODULE_PARM_DESC(edac_mc_log_ue,
 module_param(edac_mc_log_ce, int, 0644);
 MODULE_PARM_DESC(edac_mc_log_ce,
 		 "Log correctable error to console: 0=3Doff 1=3Don");
-module_param_call(edac_mc_poll_msec, edac_set_poll_msec, param_get_int,
+module_param_call(edac_mc_poll_msec, edac_set_poll_msec, param_get_uint,
 		  &edac_mc_poll_msec, 0644);
 MODULE_PARM_DESC(edac_mc_poll_msec, "Polling period in milliseconds");
=20
diff --git a/drivers/edac/edac_module.h b/drivers/edac/edac_module.h
index f2118bfcf8df..9fbe6a95c96d 100644
--- a/drivers/edac/edac_module.h
+++ b/drivers/edac/edac_module.h
@@ -32,7 +32,7 @@ extern int edac_mc_get_log_ue(void);
 extern int edac_mc_get_log_ce(void);
 extern int edac_mc_get_panic_on_ue(void);
 extern int edac_get_poll_msec(void);
-extern int edac_mc_get_poll_msec(void);
+extern unsigned int edac_mc_get_poll_msec(void);
=20
 unsigned edac_dimm_info_location(struct dimm_info *dimm, char *buf,
 				 unsigned len);
diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 00f29aa1fb9d..bc6b3b3a7af7 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -1568,6 +1568,8 @@ static struct omap_gpio_reg_offs omap4_gpio_regs =3D =
{
 	.clr_dataout =3D		OMAP4_GPIO_CLEARDATAOUT,
 	.irqstatus =3D		OMAP4_GPIO_IRQSTATUS0,
 	.irqstatus2 =3D		OMAP4_GPIO_IRQSTATUS1,
+	.irqstatus_raw0 =3D	OMAP4_GPIO_IRQSTATUSRAW0,
+	.irqstatus_raw1 =3D	OMAP4_GPIO_IRQSTATUSRAW1,
 	.irqenable =3D		OMAP4_GPIO_IRQSTATUSSET0,
 	.irqenable2 =3D		OMAP4_GPIO_IRQSTATUSSET1,
 	.set_irqenable =3D	OMAP4_GPIO_IRQSTATUSSET0,
diff --git a/drivers/input/mouse/trackpoint.h b/drivers/input/mouse/trackpo=
int.h
index 2d7be0435957..d0e0136dcf0c 100644
--- a/drivers/input/mouse/trackpoint.h
+++ b/drivers/input/mouse/trackpoint.h
@@ -148,7 +148,8 @@ struct trackpoint_data
 #ifdef CONFIG_MOUSE_PS2_TRACKPOINT
 int trackpoint_detect(struct psmouse *psmouse, bool set_properties);
 #else
-inline int trackpoint_detect(struct psmouse *psmouse, bool set_properties)
+static inline int trackpoint_detect(struct psmouse *psmouse,
+				    bool set_properties)
 {
 	return -ENOSYS;
 }
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core=
/v4l2-ctrls.c
index 55c683254102..08de53c6aa1c 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1747,16 +1747,15 @@ struct v4l2_ctrl *v4l2_ctrl_new_custom(struct v4l2_=
ctrl_handler *hdl,
 		v4l2_ctrl_fill(cfg->id, &name, &type, &min, &max, &step,
 								&def, &flags);
=20
-	is_menu =3D (cfg->type =3D=3D V4L2_CTRL_TYPE_MENU ||
-		   cfg->type =3D=3D V4L2_CTRL_TYPE_INTEGER_MENU);
+	is_menu =3D (type =3D=3D V4L2_CTRL_TYPE_MENU ||
+		   type =3D=3D V4L2_CTRL_TYPE_INTEGER_MENU);
 	if (is_menu)
 		WARN_ON(step);
 	else
 		WARN_ON(cfg->menu_skip_mask);
-	if (cfg->type =3D=3D V4L2_CTRL_TYPE_MENU && qmenu =3D=3D NULL)
+	if (type =3D=3D V4L2_CTRL_TYPE_MENU && !qmenu) {
 		qmenu =3D v4l2_ctrl_get_menu(cfg->id);
-	else if (cfg->type =3D=3D V4L2_CTRL_TYPE_INTEGER_MENU &&
-		 qmenu_int =3D=3D NULL) {
+	} else if (type =3D=3D V4L2_CTRL_TYPE_INTEGER_MENU && !qmenu_int) {
 		handler_set_err(hdl, -EINVAL);
 		return NULL;
 	}
diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memst=
ick.c
index a0547dbf9806..b99feb19baeb 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -626,13 +626,18 @@ static int __init memstick_init(void)
 		return -ENOMEM;
=20
 	rc =3D bus_register(&memstick_bus_type);
-	if (!rc)
-		rc =3D class_register(&memstick_host_class);
+	if (rc)
+		goto error_destroy_workqueue;
=20
-	if (!rc)
-		return 0;
+	rc =3D class_register(&memstick_host_class);
+	if (rc)
+		goto error_bus_unregister;
+
+	return 0;
=20
+error_bus_unregister:
 	bus_unregister(&memstick_bus_type);
+error_destroy_workqueue:
 	destroy_workqueue(workqueue);
=20
 	return rc;
diff --git a/drivers/misc/vmw_vmci/vmci_context.c b/drivers/misc/vmw_vmci/v=
mci_context.c
index f866a4baecb5..b9da2c6cc981 100644
--- a/drivers/misc/vmw_vmci/vmci_context.c
+++ b/drivers/misc/vmw_vmci/vmci_context.c
@@ -28,6 +28,9 @@
 #include "vmci_driver.h"
 #include "vmci_event.h"
=20
+/* Use a wide upper bound for the maximum contexts. */
+#define VMCI_MAX_CONTEXTS 2000
+
 /*
  * List of current VMCI contexts.  Contexts can be added by
  * vmci_ctx_create() and removed via vmci_ctx_destroy().
@@ -124,19 +127,22 @@ struct vmci_ctx *vmci_ctx_create(u32 cid, u32 priv_fl=
ags,
 	/* Initialize host-specific VMCI context. */
 	init_waitqueue_head(&context->host_context.wait_queue);
=20
-	context->queue_pair_array =3D vmci_handle_arr_create(0);
+	context->queue_pair_array =3D
+		vmci_handle_arr_create(0, VMCI_MAX_GUEST_QP_COUNT);
 	if (!context->queue_pair_array) {
 		error =3D -ENOMEM;
 		goto err_free_ctx;
 	}
=20
-	context->doorbell_array =3D vmci_handle_arr_create(0);
+	context->doorbell_array =3D
+		vmci_handle_arr_create(0, VMCI_MAX_GUEST_DOORBELL_COUNT);
 	if (!context->doorbell_array) {
 		error =3D -ENOMEM;
 		goto err_free_qp_array;
 	}
=20
-	context->pending_doorbell_array =3D vmci_handle_arr_create(0);
+	context->pending_doorbell_array =3D
+		vmci_handle_arr_create(0, VMCI_MAX_GUEST_DOORBELL_COUNT);
 	if (!context->pending_doorbell_array) {
 		error =3D -ENOMEM;
 		goto err_free_db_array;
@@ -211,7 +217,7 @@ static int ctx_fire_notification(u32 context_id, u32 pr=
iv_flags)
 	 * We create an array to hold the subscribers we find when
 	 * scanning through all contexts.
 	 */
-	subscriber_array =3D vmci_handle_arr_create(0);
+	subscriber_array =3D vmci_handle_arr_create(0, VMCI_MAX_CONTEXTS);
 	if (subscriber_array =3D=3D NULL)
 		return VMCI_ERROR_NO_MEM;
=20
@@ -630,20 +636,26 @@ int vmci_ctx_add_notification(u32 context_id, u32 rem=
ote_cid)
=20
 	spin_lock(&context->lock);
=20
-	list_for_each_entry(n, &context->notifier_list, node) {
-		if (vmci_handle_is_equal(n->handle, notifier->handle)) {
-			exists =3D true;
-			break;
+	if (context->n_notifiers < VMCI_MAX_CONTEXTS) {
+		list_for_each_entry(n, &context->notifier_list, node) {
+			if (vmci_handle_is_equal(n->handle, notifier->handle)) {
+				exists =3D true;
+				break;
+			}
 		}
-	}
=20
-	if (exists) {
-		kfree(notifier);
-		result =3D VMCI_ERROR_ALREADY_EXISTS;
+		if (exists) {
+			kfree(notifier);
+			result =3D VMCI_ERROR_ALREADY_EXISTS;
+		} else {
+			list_add_tail_rcu(&notifier->node,
+					  &context->notifier_list);
+			context->n_notifiers++;
+			result =3D VMCI_SUCCESS;
+		}
 	} else {
-		list_add_tail_rcu(&notifier->node, &context->notifier_list);
-		context->n_notifiers++;
-		result =3D VMCI_SUCCESS;
+		kfree(notifier);
+		result =3D VMCI_ERROR_NO_MEM;
 	}
=20
 	spin_unlock(&context->lock);
@@ -728,8 +740,7 @@ static int vmci_ctx_get_chkpt_doorbells(struct vmci_ctx=
 *context,
 					u32 *buf_size, void **pbuf)
 {
 	struct dbell_cpt_state *dbells;
-	size_t n_doorbells;
-	int i;
+	u32 i, n_doorbells;
=20
 	n_doorbells =3D vmci_handle_arr_get_size(context->doorbell_array);
 	if (n_doorbells > 0) {
@@ -867,7 +878,8 @@ int vmci_ctx_rcv_notifications_get(u32 context_id,
 	spin_lock(&context->lock);
=20
 	*db_handle_array =3D context->pending_doorbell_array;
-	context->pending_doorbell_array =3D vmci_handle_arr_create(0);
+	context->pending_doorbell_array =3D
+		vmci_handle_arr_create(0, VMCI_MAX_GUEST_DOORBELL_COUNT);
 	if (!context->pending_doorbell_array) {
 		context->pending_doorbell_array =3D *db_handle_array;
 		*db_handle_array =3D NULL;
@@ -949,12 +961,11 @@ int vmci_ctx_dbell_create(u32 context_id, struct vmci=
_handle handle)
 		return VMCI_ERROR_NOT_FOUND;
=20
 	spin_lock(&context->lock);
-	if (!vmci_handle_arr_has_entry(context->doorbell_array, handle)) {
-		vmci_handle_arr_append_entry(&context->doorbell_array, handle);
-		result =3D VMCI_SUCCESS;
-	} else {
+	if (!vmci_handle_arr_has_entry(context->doorbell_array, handle))
+		result =3D vmci_handle_arr_append_entry(&context->doorbell_array,
+						      handle);
+	else
 		result =3D VMCI_ERROR_DUPLICATE_ENTRY;
-	}
=20
 	spin_unlock(&context->lock);
 	vmci_ctx_put(context);
@@ -1090,15 +1101,16 @@ int vmci_ctx_notify_dbell(u32 src_cid,
 			if (!vmci_handle_arr_has_entry(
 					dst_context->pending_doorbell_array,
 					handle)) {
-				vmci_handle_arr_append_entry(
+				result =3D vmci_handle_arr_append_entry(
 					&dst_context->pending_doorbell_array,
 					handle);
-
-				ctx_signal_notify(dst_context);
-				wake_up(&dst_context->host_context.wait_queue);
-
+				if (result =3D=3D VMCI_SUCCESS) {
+					ctx_signal_notify(dst_context);
+					wake_up(&dst_context->host_context.wait_queue);
+				}
+			} else {
+				result =3D VMCI_SUCCESS;
 			}
-			result =3D VMCI_SUCCESS;
 		}
 		spin_unlock(&dst_context->lock);
 	}
@@ -1125,13 +1137,11 @@ int vmci_ctx_qp_create(struct vmci_ctx *context, st=
ruct vmci_handle handle)
 	if (context =3D=3D NULL || vmci_handle_is_invalid(handle))
 		return VMCI_ERROR_INVALID_ARGS;
=20
-	if (!vmci_handle_arr_has_entry(context->queue_pair_array, handle)) {
-		vmci_handle_arr_append_entry(&context->queue_pair_array,
-					     handle);
-		result =3D VMCI_SUCCESS;
-	} else {
+	if (!vmci_handle_arr_has_entry(context->queue_pair_array, handle))
+		result =3D vmci_handle_arr_append_entry(
+			&context->queue_pair_array, handle);
+	else
 		result =3D VMCI_ERROR_DUPLICATE_ENTRY;
-	}
=20
 	return result;
 }
diff --git a/drivers/misc/vmw_vmci/vmci_handle_array.c b/drivers/misc/vmw_v=
mci/vmci_handle_array.c
index 344973a0fb0a..917e18a8af95 100644
--- a/drivers/misc/vmw_vmci/vmci_handle_array.c
+++ b/drivers/misc/vmw_vmci/vmci_handle_array.c
@@ -16,24 +16,29 @@
 #include <linux/slab.h>
 #include "vmci_handle_array.h"
=20
-static size_t handle_arr_calc_size(size_t capacity)
+static size_t handle_arr_calc_size(u32 capacity)
 {
-	return sizeof(struct vmci_handle_arr) +
+	return VMCI_HANDLE_ARRAY_HEADER_SIZE +
 	    capacity * sizeof(struct vmci_handle);
 }
=20
-struct vmci_handle_arr *vmci_handle_arr_create(size_t capacity)
+struct vmci_handle_arr *vmci_handle_arr_create(u32 capacity, u32 max_capac=
ity)
 {
 	struct vmci_handle_arr *array;
=20
+	if (max_capacity =3D=3D 0 || capacity > max_capacity)
+		return NULL;
+
 	if (capacity =3D=3D 0)
-		capacity =3D VMCI_HANDLE_ARRAY_DEFAULT_SIZE;
+		capacity =3D min((u32)VMCI_HANDLE_ARRAY_DEFAULT_CAPACITY,
+			       max_capacity);
=20
 	array =3D kmalloc(handle_arr_calc_size(capacity), GFP_ATOMIC);
 	if (!array)
 		return NULL;
=20
 	array->capacity =3D capacity;
+	array->max_capacity =3D max_capacity;
 	array->size =3D 0;
=20
 	return array;
@@ -44,27 +49,34 @@ void vmci_handle_arr_destroy(struct vmci_handle_arr *ar=
ray)
 	kfree(array);
 }
=20
-void vmci_handle_arr_append_entry(struct vmci_handle_arr **array_ptr,
-				  struct vmci_handle handle)
+int vmci_handle_arr_append_entry(struct vmci_handle_arr **array_ptr,
+				 struct vmci_handle handle)
 {
 	struct vmci_handle_arr *array =3D *array_ptr;
=20
 	if (unlikely(array->size >=3D array->capacity)) {
 		/* reallocate. */
 		struct vmci_handle_arr *new_array;
-		size_t new_capacity =3D array->capacity * VMCI_ARR_CAP_MULT;
-		size_t new_size =3D handle_arr_calc_size(new_capacity);
+		u32 capacity_bump =3D min(array->max_capacity - array->capacity,
+					array->capacity);
+		size_t new_size =3D handle_arr_calc_size(array->capacity +
+						       capacity_bump);
+
+		if (array->size >=3D array->max_capacity)
+			return VMCI_ERROR_NO_MEM;
=20
 		new_array =3D krealloc(array, new_size, GFP_ATOMIC);
 		if (!new_array)
-			return;
+			return VMCI_ERROR_NO_MEM;
=20
-		new_array->capacity =3D new_capacity;
+		new_array->capacity +=3D capacity_bump;
 		*array_ptr =3D array =3D new_array;
 	}
=20
 	array->entries[array->size] =3D handle;
 	array->size++;
+
+	return VMCI_SUCCESS;
 }
=20
 /*
@@ -74,7 +86,7 @@ struct vmci_handle vmci_handle_arr_remove_entry(struct vm=
ci_handle_arr *array,
 						struct vmci_handle entry_handle)
 {
 	struct vmci_handle handle =3D VMCI_INVALID_HANDLE;
-	size_t i;
+	u32 i;
=20
 	for (i =3D 0; i < array->size; i++) {
 		if (vmci_handle_is_equal(array->entries[i], entry_handle)) {
@@ -109,7 +121,7 @@ struct vmci_handle vmci_handle_arr_remove_tail(struct v=
mci_handle_arr *array)
  * Handle at given index, VMCI_INVALID_HANDLE if invalid index.
  */
 struct vmci_handle
-vmci_handle_arr_get_entry(const struct vmci_handle_arr *array, size_t inde=
x)
+vmci_handle_arr_get_entry(const struct vmci_handle_arr *array, u32 index)
 {
 	if (unlikely(index >=3D array->size))
 		return VMCI_INVALID_HANDLE;
@@ -120,7 +132,7 @@ vmci_handle_arr_get_entry(const struct vmci_handle_arr =
*array, size_t index)
 bool vmci_handle_arr_has_entry(const struct vmci_handle_arr *array,
 			       struct vmci_handle entry_handle)
 {
-	size_t i;
+	u32 i;
=20
 	for (i =3D 0; i < array->size; i++)
 		if (vmci_handle_is_equal(array->entries[i], entry_handle))
diff --git a/drivers/misc/vmw_vmci/vmci_handle_array.h b/drivers/misc/vmw_v=
mci/vmci_handle_array.h
index b5f3a7f98cf1..0fc58597820e 100644
--- a/drivers/misc/vmw_vmci/vmci_handle_array.h
+++ b/drivers/misc/vmw_vmci/vmci_handle_array.h
@@ -17,32 +17,41 @@
 #define _VMCI_HANDLE_ARRAY_H_
=20
 #include <linux/vmw_vmci_defs.h>
+#include <linux/limits.h>
 #include <linux/types.h>
=20
-#define VMCI_HANDLE_ARRAY_DEFAULT_SIZE 4
-#define VMCI_ARR_CAP_MULT 2	/* Array capacity multiplier */
-
 struct vmci_handle_arr {
-	size_t capacity;
-	size_t size;
+	u32 capacity;
+	u32 max_capacity;
+	u32 size;
+	u32 pad;
 	struct vmci_handle entries[];
 };
=20
-struct vmci_handle_arr *vmci_handle_arr_create(size_t capacity);
+#define VMCI_HANDLE_ARRAY_HEADER_SIZE				\
+	offsetof(struct vmci_handle_arr, entries)
+/* Select a default capacity that results in a 64 byte sized array */
+#define VMCI_HANDLE_ARRAY_DEFAULT_CAPACITY			6
+/* Make sure that the max array size can be expressed by a u32 */
+#define VMCI_HANDLE_ARRAY_MAX_CAPACITY				\
+	((U32_MAX - VMCI_HANDLE_ARRAY_HEADER_SIZE - 1) /	\
+	sizeof(struct vmci_handle))
+
+struct vmci_handle_arr *vmci_handle_arr_create(u32 capacity, u32 max_capac=
ity);
 void vmci_handle_arr_destroy(struct vmci_handle_arr *array);
-void vmci_handle_arr_append_entry(struct vmci_handle_arr **array_ptr,
-				  struct vmci_handle handle);
+int vmci_handle_arr_append_entry(struct vmci_handle_arr **array_ptr,
+				 struct vmci_handle handle);
 struct vmci_handle vmci_handle_arr_remove_entry(struct vmci_handle_arr *ar=
ray,
 						struct vmci_handle
 						entry_handle);
 struct vmci_handle vmci_handle_arr_remove_tail(struct vmci_handle_arr *arr=
ay);
 struct vmci_handle
-vmci_handle_arr_get_entry(const struct vmci_handle_arr *array, size_t inde=
x);
+vmci_handle_arr_get_entry(const struct vmci_handle_arr *array, u32 index);
 bool vmci_handle_arr_has_entry(const struct vmci_handle_arr *array,
 			       struct vmci_handle entry_handle);
 struct vmci_handle *vmci_handle_arr_get_handles(struct vmci_handle_arr *ar=
ray);
=20
-static inline size_t vmci_handle_arr_get_size(
+static inline u32 vmci_handle_arr_get_size(
 	const struct vmci_handle_arr *array)
 {
 	return array->size;
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_mai=
n.c
index 9285ec6007a8..89a15afa2e7a 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3700,8 +3700,8 @@ static u32 bond_rr_gen_slave_id(struct bonding *bond)
 static int bond_xmit_roundrobin(struct sk_buff *skb, struct net_device *bo=
nd_dev)
 {
 	struct bonding *bond =3D netdev_priv(bond_dev);
-	struct iphdr *iph =3D ip_hdr(skb);
 	struct slave *slave;
+	int slave_cnt;
 	u32 slave_id;
=20
 	/* Start with the curr_active_slave that joined the bond as the
@@ -3710,23 +3710,32 @@ static int bond_xmit_roundrobin(struct sk_buff *skb=
, struct net_device *bond_dev
 	 * send the join/membership reports.  The curr_active_slave found
 	 * will send all of this type of traffic.
 	 */
-	if (iph->protocol =3D=3D IPPROTO_IGMP && skb->protocol =3D=3D htons(ETH_P=
_IP)) {
-		slave =3D rcu_dereference(bond->curr_active_slave);
-		if (slave && bond_slave_can_tx(slave))
-			bond_dev_queue_xmit(bond, skb, slave->dev);
-		else
-			bond_xmit_slave_id(bond, skb, 0);
-	} else {
-		int slave_cnt =3D ACCESS_ONCE(bond->slave_cnt);
+	if (skb->protocol =3D=3D htons(ETH_P_IP)) {
+		int noff =3D skb_network_offset(skb);
+		struct iphdr *iph;
=20
-		if (likely(slave_cnt)) {
-			slave_id =3D bond_rr_gen_slave_id(bond);
-			bond_xmit_slave_id(bond, skb, slave_id % slave_cnt);
-		} else {
-			dev_kfree_skb_any(skb);
+		if (unlikely(!pskb_may_pull(skb, noff + sizeof(*iph))))
+			goto non_igmp;
+
+		iph =3D ip_hdr(skb);
+		if (iph->protocol =3D=3D IPPROTO_IGMP) {
+			slave =3D rcu_dereference(bond->curr_active_slave);
+			if (slave && bond_slave_can_tx(slave))
+				bond_dev_queue_xmit(bond, skb, slave->dev);
+			else
+				bond_xmit_slave_id(bond, skb, 0);
+			return NETDEV_TX_OK;
 		}
 	}
=20
+non_igmp:
+	slave_cnt =3D ACCESS_ONCE(bond->slave_cnt);
+	if (likely(slave_cnt)) {
+		slave_id =3D bond_rr_gen_slave_id(bond);
+		bond_xmit_slave_id(bond, skb, slave_id % slave_cnt);
+	} else {
+		dev_kfree_skb_any(skb);
+	}
 	return NETDEV_TX_OK;
 }
=20
diff --git a/drivers/net/caif/caif_hsi.c b/drivers/net/caif/caif_hsi.c
index b3b922adc0e4..e10834ca88b2 100644
--- a/drivers/net/caif/caif_hsi.c
+++ b/drivers/net/caif/caif_hsi.c
@@ -1467,7 +1467,7 @@ static void __exit cfhsi_exit_module(void)
 	rtnl_lock();
 	list_for_each_safe(list_node, n, &cfhsi_list) {
 		cfhsi =3D list_entry(list_node, struct cfhsi, list);
-		unregister_netdev(cfhsi->ndev);
+		unregister_netdevice(cfhsi->ndev);
 	}
 	rtnl_unlock();
 }
diff --git a/drivers/net/wireless/ath/carl9170/usb.c b/drivers/net/wireless=
/ath/carl9170/usb.c
index c9f93310c0d6..eaccefcc41ad 100644
--- a/drivers/net/wireless/ath/carl9170/usb.c
+++ b/drivers/net/wireless/ath/carl9170/usb.c
@@ -128,6 +128,8 @@ static struct usb_device_id carl9170_usb_ids[] =3D {
 };
 MODULE_DEVICE_TABLE(usb, carl9170_usb_ids);
=20
+static struct usb_driver carl9170_driver;
+
 static void carl9170_usb_submit_data_urb(struct ar9170 *ar)
 {
 	struct urb *urb;
@@ -967,32 +969,28 @@ static int carl9170_usb_init_device(struct ar9170 *ar=
)
=20
 static void carl9170_usb_firmware_failed(struct ar9170 *ar)
 {
-	struct device *parent =3D ar->udev->dev.parent;
-	struct usb_device *udev;
-
-	/*
-	 * Store a copy of the usb_device pointer locally.
-	 * This is because device_release_driver initiates
-	 * carl9170_usb_disconnect, which in turn frees our
-	 * driver context (ar).
+	/* Store a copies of the usb_interface and usb_device pointer locally.
+	 * This is because release_driver initiates carl9170_usb_disconnect,
+	 * which in turn frees our driver context (ar).
 	 */
-	udev =3D ar->udev;
+	struct usb_interface *intf =3D ar->intf;
+	struct usb_device *udev =3D ar->udev;
=20
 	complete(&ar->fw_load_wait);
+	/* at this point 'ar' could be already freed. Don't use it anymore */
+	ar =3D NULL;
=20
 	/* unbind anything failed */
-	if (parent)
-		device_lock(parent);
-
-	device_release_driver(&udev->dev);
-	if (parent)
-		device_unlock(parent);
+	usb_lock_device(udev);
+	usb_driver_release_interface(&carl9170_driver, intf);
+	usb_unlock_device(udev);
=20
-	usb_put_dev(udev);
+	usb_put_intf(intf);
 }
=20
 static void carl9170_usb_firmware_finish(struct ar9170 *ar)
 {
+	struct usb_interface *intf =3D ar->intf;
 	int err;
=20
 	err =3D carl9170_parse_firmware(ar);
@@ -1010,7 +1008,7 @@ static void carl9170_usb_firmware_finish(struct ar917=
0 *ar)
 		goto err_unrx;
=20
 	complete(&ar->fw_load_wait);
-	usb_put_dev(ar->udev);
+	usb_put_intf(intf);
 	return;
=20
 err_unrx:
@@ -1053,7 +1051,6 @@ static int carl9170_usb_probe(struct usb_interface *i=
ntf,
 		return PTR_ERR(ar);
=20
 	udev =3D interface_to_usbdev(intf);
-	usb_get_dev(udev);
 	ar->udev =3D udev;
 	ar->intf =3D intf;
 	ar->features =3D id->driver_info;
@@ -1095,15 +1092,14 @@ static int carl9170_usb_probe(struct usb_interface =
*intf,
 	atomic_set(&ar->rx_anch_urbs, 0);
 	atomic_set(&ar->rx_pool_urbs, 0);
=20
-	usb_get_dev(ar->udev);
+	usb_get_intf(intf);
=20
 	carl9170_set_state(ar, CARL9170_STOPPED);
=20
 	err =3D request_firmware_nowait(THIS_MODULE, 1, CARL9170FW_NAME,
 		&ar->udev->dev, GFP_KERNEL, ar, carl9170_usb_firmware_step2);
 	if (err) {
-		usb_put_dev(udev);
-		usb_put_dev(udev);
+		usb_put_intf(intf);
 		carl9170_free(ar);
 	}
 	return err;
@@ -1132,7 +1128,6 @@ static void carl9170_usb_disconnect(struct usb_interf=
ace *intf)
=20
 	carl9170_release_firmware(ar);
 	carl9170_free(ar);
-	usb_put_dev(udev);
 }
=20
 #ifdef CONFIG_PM
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifi=
ex/fw.h
index f58c6f1fba0c..a482f319b21a 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -1398,9 +1398,10 @@ struct mwifiex_ie_types_wmm_queue_status {
 struct ieee_types_vendor_header {
 	u8 element_id;
 	u8 len;
-	u8 oui[4];	/* 0~2: oui, 3: oui_type */
-	u8 oui_subtype;
-	u8 version;
+	struct {
+		u8 oui[3];
+		u8 oui_type;
+	} __packed oui;
 } __packed;
=20
 struct ieee_types_wmm_parameter {
@@ -1414,6 +1415,9 @@ struct ieee_types_wmm_parameter {
 	 *   Version     [1]
 	 */
 	struct ieee_types_vendor_header vend_hdr;
+	u8 oui_subtype;
+	u8 version;
+
 	u8 qos_info_bitmap;
 	u8 reserved;
 	struct ieee_types_wmm_ac_parameters ac_params[IEEE80211_NUM_ACS];
@@ -1431,6 +1435,8 @@ struct ieee_types_wmm_info {
 	 *   Version     [1]
 	 */
 	struct ieee_types_vendor_header vend_hdr;
+	u8 oui_subtype;
+	u8 version;
=20
 	u8 qos_info_bitmap;
 } __packed;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwi=
fiex/main.h
index 1398afa84064..60281e7e76bf 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -94,6 +94,7 @@ enum {
=20
 #define MWIFIEX_MIN_TX_PENDING_TO_CANCEL_SCAN		2
=20
+#define WPA_GTK_OUI_OFFSET				2
 #define RSN_GTK_OUI_OFFSET				2
=20
 #define MWIFIEX_OUI_NOT_PRESENT			0
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwi=
fiex/scan.c
index 6d50ecc18839..b73af01c84d5 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -151,7 +151,8 @@ mwifiex_is_wpa_oui_present(struct mwifiex_bssdescriptor=
 *bss_desc, u32 cipher)
 	if (((bss_desc->bcn_wpa_ie) &&
 	     ((*(bss_desc->bcn_wpa_ie)).vend_hdr.element_id =3D=3D
 	      WLAN_EID_VENDOR_SPECIFIC))) {
-		iebody =3D (struct ie_body *) bss_desc->bcn_wpa_ie->data;
+		iebody =3D (struct ie_body *)((u8 *)bss_desc->bcn_wpa_ie->data +
+					    WPA_GTK_OUI_OFFSET);
 		oui =3D &mwifiex_wpa_oui[cipher][0];
 		ret =3D mwifiex_search_oui_in_ie(iebody, oui);
 		if (ret)
@@ -1284,21 +1285,25 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_=
adapter *adapter,
 			break;
=20
 		case WLAN_EID_VENDOR_SPECIFIC:
-			if (element_len + 2 < sizeof(vendor_ie->vend_hdr))
-				return -EINVAL;
-
 			vendor_ie =3D (struct ieee_types_vendor_specific *)
 					current_ptr;
=20
-			if (!memcmp
-			    (vendor_ie->vend_hdr.oui, wpa_oui,
-			     sizeof(wpa_oui))) {
+			/* 802.11 requires at least 3-byte OUI. */
+			if (element_len < sizeof(vendor_ie->vend_hdr.oui.oui))
+				return -EINVAL;
+
+			/* Not long enough for a match? Skip it. */
+			if (element_len < sizeof(wpa_oui))
+				break;
+
+			if (!memcmp(&vendor_ie->vend_hdr.oui, wpa_oui,
+				    sizeof(wpa_oui))) {
 				bss_entry->bcn_wpa_ie =3D
 					(struct ieee_types_vendor_specific *)
 					current_ptr;
 				bss_entry->wpa_offset =3D (u16)
 					(current_ptr - bss_entry->beacon_buf);
-			} else if (!memcmp(vendor_ie->vend_hdr.oui, wmm_oui,
+			} else if (!memcmp(&vendor_ie->vend_hdr.oui, wmm_oui,
 				    sizeof(wmm_oui))) {
 				if (total_ie_len =3D=3D
 				    sizeof(struct ieee_types_wmm_parameter) ||
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireles=
s/mwifiex/sta_ioctl.c
index da7f7d2fcb1f..1ac6b2870273 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -1318,7 +1318,7 @@ mwifiex_set_gen_ie_helper(struct mwifiex_private *pri=
v, u8 *ie_data_ptr,
 	pvendor_ie =3D (struct ieee_types_vendor_header *) ie_data_ptr;
 	/* Test to see if it is a WPA IE, if not, then it is a gen IE */
 	if (((pvendor_ie->element_id =3D=3D WLAN_EID_VENDOR_SPECIFIC) &&
-	     (!memcmp(pvendor_ie->oui, wpa_oui, sizeof(wpa_oui)))) ||
+	     (!memcmp(&pvendor_ie->oui, wpa_oui, sizeof(wpa_oui)))) ||
 	    (pvendor_ie->element_id =3D=3D WLAN_EID_RSN)) {
=20
 		/* IE is a WPA/WPA2 IE so call set_wpa function */
@@ -1343,7 +1343,7 @@ mwifiex_set_gen_ie_helper(struct mwifiex_private *pri=
v, u8 *ie_data_ptr,
 		 */
 		pvendor_ie =3D (struct ieee_types_vendor_header *) ie_data_ptr;
 		if ((pvendor_ie->element_id =3D=3D WLAN_EID_VENDOR_SPECIFIC) &&
-		    (!memcmp(pvendor_ie->oui, wps_oui, sizeof(wps_oui)))) {
+		    (!memcmp(&pvendor_ie->oui, wps_oui, sizeof(wps_oui)))) {
 			priv->wps.session_enable =3D true;
 			dev_dbg(priv->adapter->dev,
 				"info: WPS Session Enabled.\n");
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwif=
iex/wmm.c
index d3671d009f6c..67cefd06b7b0 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -241,7 +241,7 @@ mwifiex_wmm_setup_queue_priorities(struct mwifiex_priva=
te *priv,
=20
 	dev_dbg(priv->adapter->dev, "info: WMM Parameter IE: version=3D%d, "
 		"qos_info Parameter Set Count=3D%d, Reserved=3D%#x\n",
-		wmm_ie->vend_hdr.version, wmm_ie->qos_info_bitmap &
+		wmm_ie->version, wmm_ie->qos_info_bitmap &
 		IEEE80211_WMM_IE_AP_QOSINFO_PARAM_SET_CNT_MASK,
 		wmm_ie->reserved);
=20
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 8490e0e1ed07..0d40f2e7e1fa 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1680,6 +1680,13 @@ static void pci_pme_list_scan(struct work_struct *wo=
rk)
 			 */
 			if (bridge && bridge->current_state !=3D PCI_D0)
 				continue;
+			/*
+			 * If the device is in D3cold it should not be
+			 * polled either.
+			 */
+			if (pme_dev->dev->current_state =3D=3D PCI_D3cold)
+				continue;
+
 			pci_pme_wakeup(pme_dev->dev, NULL);
 		} else {
 			list_del(&pme_dev->list);
diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index 90f93c2be8cd..dae0196a61b6 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -752,6 +752,7 @@ static int get_outbound_buffer_frontier(struct qdio_q *=
q)
=20
 	switch (state) {
 	case SLSB_P_OUTPUT_EMPTY:
+	case SLSB_P_OUTPUT_PENDING:
 		/* the adapter got it */
 		DBF_DEV_EVENT(DBF_INFO, q->irq_ptr,
 			"out empty:%1d %02x", q->nr, count);
diff --git a/drivers/s390/cio/qdio_setup.c b/drivers/s390/cio/qdio_setup.c
index 2c707f8a3521..74114fe842f3 100644
--- a/drivers/s390/cio/qdio_setup.c
+++ b/drivers/s390/cio/qdio_setup.c
@@ -100,6 +100,7 @@ static int __qdio_allocate_qs(struct qdio_q **irq_ptr_q=
s, int nr_queues)
 			return -ENOMEM;
 		}
 		irq_ptr_qs[i] =3D q;
+		INIT_LIST_HEAD(&q->entry);
 	}
 	return 0;
 }
@@ -128,6 +129,7 @@ static void setup_queues_misc(struct qdio_q *q, struct =
qdio_irq *irq_ptr,
 	q->mask =3D 1 << (31 - i);
 	q->nr =3D i;
 	q->handler =3D handler;
+	INIT_LIST_HEAD(&q->entry);
 }
=20
 static void setup_storage_lists(struct qdio_q *q, struct qdio_irq *irq_ptr=
,
diff --git a/drivers/s390/cio/qdio_thinint.c b/drivers/s390/cio/qdio_thinin=
t.c
index 30e9fbbff051..debe69adfc70 100644
--- a/drivers/s390/cio/qdio_thinint.c
+++ b/drivers/s390/cio/qdio_thinint.c
@@ -80,7 +80,6 @@ void tiqdio_add_input_queues(struct qdio_irq *irq_ptr)
 	mutex_lock(&tiq_list_lock);
 	list_add_rcu(&irq_ptr->input_qs[0]->entry, &tiq_list);
 	mutex_unlock(&tiq_list_lock);
-	xchg(irq_ptr->dsci, 1 << 7);
 }
=20
 void tiqdio_remove_input_queues(struct qdio_irq *irq_ptr)
@@ -88,14 +87,14 @@ void tiqdio_remove_input_queues(struct qdio_irq *irq_pt=
r)
 	struct qdio_q *q;
=20
 	q =3D irq_ptr->input_qs[0];
-	/* if establish triggered an error */
-	if (!q || !q->entry.prev || !q->entry.next)
+	if (!q)
 		return;
=20
 	mutex_lock(&tiq_list_lock);
 	list_del_rcu(&q->entry);
 	mutex_unlock(&tiq_list_lock);
 	synchronize_rcu();
+	INIT_LIST_HEAD(&q->entry);
 }
=20
 static inline int has_multiple_inq_on_dsci(struct qdio_irq *irq_ptr)
diff --git a/drivers/tty/serial/cpm_uart/cpm_uart_core.c b/drivers/tty/seri=
al/cpm_uart/cpm_uart_core.c
index 90592e6f918e..fae2f8f1e696 100644
--- a/drivers/tty/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
@@ -420,7 +420,16 @@ static int cpm_uart_startup(struct uart_port *port)
 			clrbits16(&pinfo->sccp->scc_sccm, UART_SCCM_RX);
 		}
 		cpm_uart_initbd(pinfo);
-		cpm_line_cr_cmd(pinfo, CPM_CR_INIT_TRX);
+		if (IS_SMC(pinfo)) {
+			out_be32(&pinfo->smcup->smc_rstate, 0);
+			out_be32(&pinfo->smcup->smc_tstate, 0);
+			out_be16(&pinfo->smcup->smc_rbptr,
+				 in_be16(&pinfo->smcup->smc_rbase));
+			out_be16(&pinfo->smcup->smc_tbptr,
+				 in_be16(&pinfo->smcup->smc_tbase));
+		} else {
+			cpm_line_cr_cmd(pinfo, CPM_CR_INIT_TRX);
+		}
 	}
 	/* Install interrupt handler. */
 	retval =3D request_irq(port->irq, cpm_uart_int, 0, "cpm_uart", port);
@@ -871,16 +880,14 @@ static void cpm_uart_init_smc(struct uart_cpm_port *p=
info)
 	         (u8 __iomem *)pinfo->tx_bd_base - DPRAM_BASE);
=20
 /*
- *  In case SMC1 is being relocated...
+ *  In case SMC is being relocated...
  */
-#if defined (CONFIG_I2C_SPI_SMC1_UCODE_PATCH)
 	out_be16(&up->smc_rbptr, in_be16(&pinfo->smcup->smc_rbase));
 	out_be16(&up->smc_tbptr, in_be16(&pinfo->smcup->smc_tbase));
 	out_be32(&up->smc_rstate, 0);
 	out_be32(&up->smc_tstate, 0);
 	out_be16(&up->smc_brkcr, 1);              /* number of break chars */
 	out_be16(&up->smc_brkec, 0);
-#endif
=20
 	/* Set up the uart parameters in the
 	 * parameter ram.
@@ -894,8 +901,6 @@ static void cpm_uart_init_smc(struct uart_cpm_port *pin=
fo)
 	out_be16(&up->smc_brkec, 0);
 	out_be16(&up->smc_brkcr, 1);
=20
-	cpm_line_cr_cmd(pinfo, CPM_CR_INIT_TRX);
-
 	/* Set UART mode, 8 bit, no parity, one stop.
 	 * Enable receive and transmit.
 	 */
diff --git a/drivers/usb/gadget/u_ether.c b/drivers/usb/gadget/u_ether.c
index c02d037cb16c..629bebbdc1df 100644
--- a/drivers/usb/gadget/u_ether.c
+++ b/drivers/usb/gadget/u_ether.c
@@ -202,11 +202,12 @@ rx_submit(struct eth_dev *dev, struct usb_request *re=
q, gfp_t gfp_flags)
 		out =3D dev->port_usb->out_ep;
 	else
 		out =3D NULL;
-	spin_unlock_irqrestore(&dev->lock, flags);
=20
 	if (!out)
+	{
+		spin_unlock_irqrestore(&dev->lock, flags);
 		return -ENOTCONN;
-
+	}
=20
 	/* Padding up to RX_EXTRA handles minor disagreements with host.
 	 * Normally we use the USB "terminate on short read" convention;
@@ -227,6 +228,7 @@ rx_submit(struct eth_dev *dev, struct usb_request *req,=
 gfp_t gfp_flags)
=20
 	if (dev->port_usb->is_fixed)
 		size =3D max_t(size_t, size, dev->port_usb->fixed_out_len);
+	spin_unlock_irqrestore(&dev->lock, flags);
=20
 	skb =3D alloc_skb(size + NET_IP_ALIGN, gfp_flags);
 	if (skb =3D=3D NULL) {
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 3f89153bc122..8db5a3533ca7 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1037,6 +1037,7 @@ static const struct usb_device_id id_table_combined[]=
 =3D {
 	{ USB_DEVICE(AIRBUS_DS_VID, AIRBUS_DS_P8GR) },
 	/* EZPrototypes devices */
 	{ USB_DEVICE(EZPROTOTYPES_VID, HJELMSLUND_USB485_ISO_PID) },
+	{ USB_DEVICE_INTERFACE_NUMBER(UNJO_VID, UNJO_ISODEBUG_V1_PID, 1) },
 	{ }					/* Terminating entry */
 };
=20
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_si=
o_ids.h
index 5258cec99219..3ed504675fac 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1542,3 +1542,9 @@
 #define CHETCO_SEASMART_DISPLAY_PID	0xA5AD /* SeaSmart NMEA2000 Display */
 #define CHETCO_SEASMART_LITE_PID	0xA5AE /* SeaSmart Lite USB Adapter */
 #define CHETCO_SEASMART_ANALOG_PID	0xA5AF /* SeaSmart Analog Adapter */
+
+/*
+ * Unjo AB
+ */
+#define UNJO_VID			0x22B7
+#define UNJO_ISODEBUG_V1_PID		0x150D
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 0ec4a883b614..304602d20f68 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1466,6 +1466,8 @@ static const struct usb_device_id option_ids[] =3D {
 	  .driver_info =3D (kernel_ulong_t)&net_intf4_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0414, 0xff, 0xff, 0xff) =
},
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0417, 0xff, 0xff, 0xff) =
},
+	{ USB_DEVICE_INTERFACE_CLASS(ZTE_VENDOR_ID, 0x0601, 0xff) },	/* GosunCn Z=
TE WeLink ME3630 (RNDIS mode) */
+	{ USB_DEVICE_INTERFACE_CLASS(ZTE_VENDOR_ID, 0x0602, 0xff) },	/* GosunCn Z=
TE WeLink ME3630 (MBIM mode) */
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1008, 0xff, 0xff, 0xff),
 	  .driver_info =3D (kernel_ulong_t)&net_intf4_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1010, 0xff, 0xff, 0xff),
@@ -1669,6 +1671,7 @@ static const struct usb_device_id option_ids[] =3D {
 		.driver_info =3D (kernel_ulong_t)&net_intf2_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1428, 0xff, 0xff, 0xff),=
  /* Telewell TW-LTE 4G v2 */
 		.driver_info =3D (kernel_ulong_t)&net_intf2_blacklist },
+	{ USB_DEVICE_INTERFACE_CLASS(ZTE_VENDOR_ID, 0x1476, 0xff) },	/* GosunCn Z=
TE WeLink ME3630 (ECM/NCM mode) */
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1533, 0xff, 0xff, 0xff) =
},
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1534, 0xff, 0xff, 0xff) =
},
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1535, 0xff, 0xff, 0xff) =
},
diff --git a/fs/coda/file.c b/fs/coda/file.c
index 9e83b7790212..0ffb0483655c 100644
--- a/fs/coda/file.c
+++ b/fs/coda/file.c
@@ -26,6 +26,13 @@
 #include "coda_linux.h"
 #include "coda_int.h"
=20
+struct coda_vm_ops {
+	atomic_t refcnt;
+	struct file *coda_file;
+	const struct vm_operations_struct *host_vm_ops;
+	struct vm_operations_struct vm_ops;
+};
+
 static ssize_t
 coda_file_read(struct file *coda_file, char __user *buf, size_t count, lof=
f_t *ppos)
 {
@@ -93,6 +100,34 @@ coda_file_write(struct file *coda_file, const char __us=
er *buf, size_t count, lo
 	return ret;
 }
=20
+static void
+coda_vm_open(struct vm_area_struct *vma)
+{
+	struct coda_vm_ops *cvm_ops =3D
+		container_of(vma->vm_ops, struct coda_vm_ops, vm_ops);
+
+	atomic_inc(&cvm_ops->refcnt);
+
+	if (cvm_ops->host_vm_ops && cvm_ops->host_vm_ops->open)
+		cvm_ops->host_vm_ops->open(vma);
+}
+
+static void
+coda_vm_close(struct vm_area_struct *vma)
+{
+	struct coda_vm_ops *cvm_ops =3D
+		container_of(vma->vm_ops, struct coda_vm_ops, vm_ops);
+
+	if (cvm_ops->host_vm_ops && cvm_ops->host_vm_ops->close)
+		cvm_ops->host_vm_ops->close(vma);
+
+	if (atomic_dec_and_test(&cvm_ops->refcnt)) {
+		vma->vm_ops =3D cvm_ops->host_vm_ops;
+		fput(cvm_ops->coda_file);
+		kfree(cvm_ops);
+	}
+}
+
 static int
 coda_file_mmap(struct file *coda_file, struct vm_area_struct *vma)
 {
@@ -100,6 +135,8 @@ coda_file_mmap(struct file *coda_file, struct vm_area_s=
truct *vma)
 	struct coda_inode_info *cii;
 	struct file *host_file;
 	struct inode *coda_inode, *host_inode;
+	struct coda_vm_ops *cvm_ops;
+	int ret;
=20
 	cfi =3D CODA_FTOC(coda_file);
 	BUG_ON(!cfi || cfi->cfi_magic !=3D CODA_MAGIC);
@@ -108,6 +145,13 @@ coda_file_mmap(struct file *coda_file, struct vm_area_=
struct *vma)
 	if (!host_file->f_op->mmap)
 		return -ENODEV;
=20
+	if (WARN_ON(coda_file !=3D vma->vm_file))
+		return -EIO;
+
+	cvm_ops =3D kmalloc(sizeof(struct coda_vm_ops), GFP_KERNEL);
+	if (!cvm_ops)
+		return -ENOMEM;
+
 	coda_inode =3D file_inode(coda_file);
 	host_inode =3D file_inode(host_file);
=20
@@ -121,6 +165,7 @@ coda_file_mmap(struct file *coda_file, struct vm_area_s=
truct *vma)
 	 * the container file on us! */
 	else if (coda_inode->i_mapping !=3D host_inode->i_mapping) {
 		spin_unlock(&cii->c_lock);
+		kfree(cvm_ops);
 		return -EBUSY;
 	}
=20
@@ -129,7 +174,29 @@ coda_file_mmap(struct file *coda_file, struct vm_area_=
struct *vma)
 	cfi->cfi_mapcount++;
 	spin_unlock(&cii->c_lock);
=20
-	return host_file->f_op->mmap(host_file, vma);
+	vma->vm_file =3D get_file(host_file);
+	ret =3D host_file->f_op->mmap(host_file, vma);
+
+	if (ret) {
+		/* if ->mmap fails, our caller will put coda_file so we
+		 * should drop the reference to the host_file that we got.
+		 */
+		fput(host_file);
+		kfree(cvm_ops);
+	} else {
+		/* here we add redirects for the open/close vm_operations */
+		cvm_ops->host_vm_ops =3D vma->vm_ops;
+		if (vma->vm_ops)
+			cvm_ops->vm_ops =3D *vma->vm_ops;
+
+		cvm_ops->vm_ops.open =3D coda_vm_open;
+		cvm_ops->vm_ops.close =3D coda_vm_close;
+		cvm_ops->coda_file =3D coda_file;
+		atomic_set(&cvm_ops->refcnt, 1);
+
+		vma->vm_ops =3D &cvm_ops->vm_ops;
+	}
+	return ret;
 }
=20
 int coda_open(struct inode *coda_inode, struct file *coda_file)
@@ -239,4 +306,3 @@ const struct file_operations coda_file_operations =3D {
 	.fsync		=3D coda_fsync,
 	.splice_read	=3D coda_file_splice_read,
 };
-
diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 31b148f3e772..c6eccbf34be7 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1042,8 +1042,10 @@ int ecryptfs_read_and_validate_header_region(struct =
inode *inode)
=20
 	rc =3D ecryptfs_read_lower(file_size, 0, ECRYPTFS_SIZE_AND_MARKER_BYTES,
 				 inode);
-	if (rc < ECRYPTFS_SIZE_AND_MARKER_BYTES)
-		return rc >=3D 0 ? -EINVAL : rc;
+	if (rc < 0)
+		return rc;
+	else if (rc < ECRYPTFS_SIZE_AND_MARKER_BYTES)
+		return -EINVAL;
 	rc =3D ecryptfs_validate_marker(marker);
 	if (!rc)
 		ecryptfs_i_size_init(file_size, inode);
@@ -1401,8 +1403,10 @@ int ecryptfs_read_and_validate_xattr_region(struct d=
entry *dentry,
 	rc =3D ecryptfs_getxattr_lower(ecryptfs_dentry_to_lower(dentry),
 				     ECRYPTFS_XATTR_NAME, file_size,
 				     ECRYPTFS_SIZE_AND_MARKER_BYTES);
-	if (rc < ECRYPTFS_SIZE_AND_MARKER_BYTES)
-		return rc >=3D 0 ? -EINVAL : rc;
+	if (rc < 0)
+		return rc;
+	else if (rc < ECRYPTFS_SIZE_AND_MARKER_BYTES)
+		return -EINVAL;
 	rc =3D ecryptfs_validate_marker(marker);
 	if (!rc)
 		ecryptfs_i_size_init(file_size, inode);
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 4801b2956c97..5181cecbcacc 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -893,6 +893,7 @@ int nfs_open(struct inode *inode, struct file *filp)
 	nfs_fscache_open_file(inode, filp);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(nfs_open);
=20
 int nfs_release(struct inode *inode, struct file *filp)
 {
diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
index a816f0627a6c..761d82f0c696 100644
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -34,7 +34,7 @@ nfs4_file_open(struct inode *inode, struct file *filp)
 	dprintk("NFS: open file(%pd2)\n", dentry);
=20
 	if ((openflags & O_ACCMODE) =3D=3D 3)
-		openflags--;
+		return nfs_open(inode, filp);
=20
 	/* We can't create new files here */
 	openflags &=3D ~(O_CREAT|O_EXCL);
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 28b5d30a7181..b2be3678d209 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -482,13 +482,15 @@ static struct buffer_head *udf_getblk(struct inode *i=
node, long block,
 	return NULL;
 }
=20
-/* Extend the file by 'blocks' blocks, return the number of extents added =
*/
+/* Extend the file with new blocks totaling 'new_block_bytes',
+ * return the number of extents added
+ */
 static int udf_do_extend_file(struct inode *inode,
 			      struct extent_position *last_pos,
 			      struct kernel_long_ad *last_ext,
-			      sector_t blocks)
+			      loff_t new_block_bytes)
 {
-	sector_t add;
+	uint32_t add;
 	int count =3D 0, fake =3D !(last_ext->extLength & UDF_EXTENT_LENGTH_MASK)=
;
 	struct super_block *sb =3D inode->i_sb;
 	struct kernel_lb_addr prealloc_loc =3D {};
@@ -498,7 +500,7 @@ static int udf_do_extend_file(struct inode *inode,
=20
 	/* The previous extent is fake and we should not extend by anything
 	 * - there's nothing to do... */
-	if (!blocks && fake)
+	if (!new_block_bytes && fake)
 		return 0;
=20
 	iinfo =3D UDF_I(inode);
@@ -529,13 +531,12 @@ static int udf_do_extend_file(struct inode *inode,
 	/* Can we merge with the previous extent? */
 	if ((last_ext->extLength & UDF_EXTENT_FLAG_MASK) =3D=3D
 					EXT_NOT_RECORDED_NOT_ALLOCATED) {
-		add =3D ((1 << 30) - sb->s_blocksize -
-			(last_ext->extLength & UDF_EXTENT_LENGTH_MASK)) >>
-			sb->s_blocksize_bits;
-		if (add > blocks)
-			add =3D blocks;
-		blocks -=3D add;
-		last_ext->extLength +=3D add << sb->s_blocksize_bits;
+		add =3D (1 << 30) - sb->s_blocksize -
+			(last_ext->extLength & UDF_EXTENT_LENGTH_MASK);
+		if (add > new_block_bytes)
+			add =3D new_block_bytes;
+		new_block_bytes -=3D add;
+		last_ext->extLength +=3D add;
 	}
=20
 	if (fake) {
@@ -547,28 +548,27 @@ static int udf_do_extend_file(struct inode *inode,
 				last_ext->extLength, 1);
=20
 	/* Managed to do everything necessary? */
-	if (!blocks)
+	if (!new_block_bytes)
 		goto out;
=20
 	/* All further extents will be NOT_RECORDED_NOT_ALLOCATED */
 	last_ext->extLocation.logicalBlockNum =3D 0;
 	last_ext->extLocation.partitionReferenceNum =3D 0;
-	add =3D (1 << (30-sb->s_blocksize_bits)) - 1;
-	last_ext->extLength =3D EXT_NOT_RECORDED_NOT_ALLOCATED |
-				(add << sb->s_blocksize_bits);
+	add =3D (1 << 30) - sb->s_blocksize;
+	last_ext->extLength =3D EXT_NOT_RECORDED_NOT_ALLOCATED | add;
=20
 	/* Create enough extents to cover the whole hole */
-	while (blocks > add) {
-		blocks -=3D add;
+	while (new_block_bytes > add) {
+		new_block_bytes -=3D add;
 		err =3D udf_add_aext(inode, last_pos, &last_ext->extLocation,
 				   last_ext->extLength, 1);
 		if (err)
 			return err;
 		count++;
 	}
-	if (blocks) {
+	if (new_block_bytes) {
 		last_ext->extLength =3D EXT_NOT_RECORDED_NOT_ALLOCATED |
-			(blocks << sb->s_blocksize_bits);
+			new_block_bytes;
 		err =3D udf_add_aext(inode, last_pos, &last_ext->extLocation,
 				   last_ext->extLength, 1);
 		if (err)
@@ -599,6 +599,24 @@ static int udf_do_extend_file(struct inode *inode,
 	return count;
 }
=20
+/* Extend the final block of the file to final_block_len bytes */
+static void udf_do_extend_final_block(struct inode *inode,
+				      struct extent_position *last_pos,
+				      struct kernel_long_ad *last_ext,
+				      uint32_t final_block_len)
+{
+	struct super_block *sb =3D inode->i_sb;
+	uint32_t added_bytes;
+
+	added_bytes =3D final_block_len -
+		      (last_ext->extLength & (sb->s_blocksize - 1));
+	last_ext->extLength +=3D added_bytes;
+	UDF_I(inode)->i_lenExtents +=3D added_bytes;
+
+	udf_write_aext(inode, last_pos, &last_ext->extLocation,
+			last_ext->extLength, 1);
+}
+
 static int udf_extend_file(struct inode *inode, loff_t newsize)
 {
=20
@@ -608,10 +626,12 @@ static int udf_extend_file(struct inode *inode, loff_=
t newsize)
 	int8_t etype;
 	struct super_block *sb =3D inode->i_sb;
 	sector_t first_block =3D newsize >> sb->s_blocksize_bits, offset;
+	unsigned long partial_final_block;
 	int adsize;
 	struct udf_inode_info *iinfo =3D UDF_I(inode);
 	struct kernel_long_ad extent;
-	int err;
+	int err =3D 0;
+	int within_final_block;
=20
 	if (iinfo->i_alloc_type =3D=3D ICBTAG_FLAG_AD_SHORT)
 		adsize =3D sizeof(struct short_ad);
@@ -621,18 +641,8 @@ static int udf_extend_file(struct inode *inode, loff_t=
 newsize)
 		BUG();
=20
 	etype =3D inode_bmap(inode, first_block, &epos, &eloc, &elen, &offset);
+	within_final_block =3D (etype !=3D -1);
=20
-	/* File has extent covering the new size (could happen when extending
-	 * inside a block)? */
-	if (etype !=3D -1)
-		return 0;
-	if (newsize & (sb->s_blocksize - 1))
-		offset++;
-	/* Extended file just to the boundary of the last file block? */
-	if (offset =3D=3D 0)
-		return 0;
-
-	/* Truncate is extending the file by 'offset' blocks */
 	if ((!epos.bh && epos.offset =3D=3D udf_file_entry_alloc_offset(inode)) |=
|
 	    (epos.bh && epos.offset =3D=3D sizeof(struct allocExtDesc))) {
 		/* File has no extents at all or has empty last
@@ -646,7 +656,22 @@ static int udf_extend_file(struct inode *inode, loff_t=
 newsize)
 				      &extent.extLength, 0);
 		extent.extLength |=3D etype << 30;
 	}
-	err =3D udf_do_extend_file(inode, &epos, &extent, offset);
+
+	partial_final_block =3D newsize & (sb->s_blocksize - 1);
+
+	/* File has extent covering the new size (could happen when extending
+	 * inside a block)?
+	 */
+	if (within_final_block) {
+		/* Extending file within the last file block */
+		udf_do_extend_final_block(inode, &epos, &extent,
+					  partial_final_block);
+	} else {
+		loff_t add =3D ((loff_t)offset << sb->s_blocksize_bits) |
+			     partial_final_block;
+		err =3D udf_do_extend_file(inode, &epos, &extent, add);
+	}
+
 	if (err < 0)
 		goto out;
 	err =3D 0;
@@ -751,6 +776,7 @@ static sector_t inode_getblk(struct inode *inode, secto=
r_t block,
 	/* Are we beyond EOF? */
 	if (etype =3D=3D -1) {
 		int ret;
+		loff_t hole_len;
 		isBeyondEOF =3D 1;
 		if (count) {
 			if (c)
@@ -766,7 +792,8 @@ static sector_t inode_getblk(struct inode *inode, secto=
r_t block,
 			startnum =3D (offset > 0);
 		}
 		/* Create extents for the hole between EOF and offset */
-		ret =3D udf_do_extend_file(inode, &prev_epos, laarr, offset);
+		hole_len =3D (loff_t)offset << inode->i_blkbits;
+		ret =3D udf_do_extend_file(inode, &prev_epos, laarr, hole_len);
 		if (ret < 0) {
 			brelse(prev_epos.bh);
 			brelse(cur_epos.bh);
diff --git a/include/linux/vmw_vmci_defs.h b/include/linux/vmw_vmci_defs.h
index 65ac54c61c18..7023432013e8 100644
--- a/include/linux/vmw_vmci_defs.h
+++ b/include/linux/vmw_vmci_defs.h
@@ -75,9 +75,18 @@ enum {
=20
 /*
  * A single VMCI device has an upper limit of 128MB on the amount of
- * memory that can be used for queue pairs.
+ * memory that can be used for queue pairs. Since each queue pair
+ * consists of at least two pages, the memory limit also dictates the
+ * number of queue pairs a guest can create.
  */
 #define VMCI_MAX_GUEST_QP_MEMORY (128 * 1024 * 1024)
+#define VMCI_MAX_GUEST_QP_COUNT  (VMCI_MAX_GUEST_QP_MEMORY / PAGE_SIZE / 2=
)
+
+/*
+ * There can be at most PAGE_SIZE doorbells since there is one doorbell
+ * per byte in the doorbell bitmap page.
+ */
+#define VMCI_MAX_GUEST_DOORBELL_COUNT PAGE_SIZE
=20
 /*
  * Queues with pre-mapped data pages must be small, so that we don't pin
diff --git a/kernel/padata.c b/kernel/padata.c
index 3ecda3294690..9978b5712fce 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -272,7 +272,12 @@ static void padata_reorder(struct parallel_data *pd)
 	 * The next object that needs serialization might have arrived to
 	 * the reorder queues in the meantime, we will be called again
 	 * from the timer function if no one else cares for it.
+	 *
+	 * Ensure reorder_objects is read after pd->lock is dropped so we see
+	 * an increment from another task in padata_do_serial.  Pairs with
+	 * smp_mb__after_atomic in padata_do_serial.
 	 */
+	smp_mb();
 	if (atomic_read(&pd->reorder_objects)
 			&& !(pinst->flags & PADATA_RESET))
 		mod_timer(&pd->timer, jiffies + HZ);
@@ -341,6 +346,13 @@ void padata_do_serial(struct padata_priv *padata)
 	list_add_tail(&padata->list, &pqueue->reorder.list);
 	spin_unlock(&pqueue->reorder.lock);
=20
+	/*
+	 * Ensure the atomic_inc of reorder_objects above is ordered correctly
+	 * with the trylock of pd->lock in padata_reorder.  Pairs with smp_mb
+	 * in padata_reorder.
+	 */
+	smp_mb__after_atomic();
+
 	put_cpu();
=20
 	padata_reorder(pd);
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index d550f930027c..685c6a05e192 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -304,7 +304,7 @@ int reboot_pid_ns(struct pid_namespace *pid_ns, int cmd=
)
 	}
=20
 	read_lock(&tasklist_lock);
-	force_sig(SIGKILL, pid_ns->child_reaper);
+	send_sig(SIGKILL, pid_ns->child_reaper, 1);
 	read_unlock(&tasklist_lock);
=20
 	do_exit(0);
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 3a8e8e8fb2a5..d2524fce58f3 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -459,17 +459,18 @@ static bool sg_miter_get_next_page(struct sg_mapping_=
iter *miter)
 {
 	if (!miter->__remaining) {
 		struct scatterlist *sg;
-		unsigned long pgoffset;
=20
 		if (!__sg_page_iter_next(&miter->piter))
 			return false;
=20
 		sg =3D miter->piter.sg;
-		pgoffset =3D miter->piter.sg_pgoffset;
=20
-		miter->__offset =3D pgoffset ? 0 : sg->offset;
+		miter->__offset =3D miter->piter.sg_pgoffset ? 0 : sg->offset;
+		miter->piter.sg_pgoffset +=3D miter->__offset >> PAGE_SHIFT;
+		miter->__offset &=3D PAGE_SIZE - 1;
 		miter->__remaining =3D sg->offset + sg->length -
-				(pgoffset << PAGE_SHIFT) - miter->__offset;
+				     (miter->piter.sg_pgoffset << PAGE_SHIFT) -
+				     miter->__offset;
 		miter->__remaining =3D min_t(unsigned long, miter->__remaining,
 					   PAGE_SIZE - miter->__offset);
 	}
diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index 41cefdf0aadd..f8d7f107c453 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -224,7 +224,7 @@ static int do_mmu_notifier_register(struct mmu_notifier=
 *mn,
 	 * thanks to mm_take_all_locks().
 	 */
 	spin_lock(&mm->mmu_notifier_mm->lock);
-	hlist_add_head(&mn->hlist, &mm->mmu_notifier_mm->list);
+	hlist_add_head_rcu(&mn->hlist, &mm->mmu_notifier_mm->list);
 	spin_unlock(&mm->mmu_notifier_mm->lock);
=20
 	mm_drop_all_locks(mm);
diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 421245314be5..99efce32dc05 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -718,10 +718,16 @@ static struct p9_trans_module p9_virtio_trans =3D {
 /* The standard init function */
 static int __init p9_virtio_init(void)
 {
+	int rc;
+
 	INIT_LIST_HEAD(&virtio_chan_list);
=20
 	v9fs_register_trans(&p9_virtio_trans);
-	return register_virtio_driver(&p9_virtio_drv);
+	rc =3D register_virtio_driver(&p9_virtio_drv);
+	if (rc)
+		v9fs_unregister_trans(&p9_virtio_trans);
+
+	return rc;
 }
=20
 static void __exit p9_virtio_cleanup(void)
diff --git a/net/bridge/br_stp_bpdu.c b/net/bridge/br_stp_bpdu.c
index bdb459d21ad8..483ab2cc3029 100644
--- a/net/bridge/br_stp_bpdu.c
+++ b/net/bridge/br_stp_bpdu.c
@@ -140,7 +140,6 @@ void br_send_tcn_bpdu(struct net_bridge_port *p)
 void br_stp_rcv(const struct stp_proto *proto, struct sk_buff *skb,
 		struct net_device *dev)
 {
-	const unsigned char *dest =3D eth_hdr(skb)->h_dest;
 	struct net_bridge_port *p;
 	struct net_bridge *br;
 	const unsigned char *buf;
@@ -169,7 +168,7 @@ void br_stp_rcv(const struct stp_proto *proto, struct s=
k_buff *skb,
 	if (p->state =3D=3D BR_STATE_DISABLED)
 		goto out;
=20
-	if (!ether_addr_equal(dest, br->group_addr))
+	if (!ether_addr_equal(eth_hdr(skb)->h_dest, br->group_addr))
 		goto out;
=20
 	if (p->flags & BR_BPDU_GUARD) {
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 6678f3959eb2..9137f30c78b8 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -995,6 +995,7 @@ int __neigh_event_send(struct neighbour *neigh, struct =
sk_buff *skb)
=20
 			atomic_set(&neigh->probes,
 				   NEIGH_VAR(neigh->parms, UCAST_PROBES));
+			neigh_del_timer(neigh);
 			neigh->nud_state     =3D NUD_INCOMPLETE;
 			neigh->updated =3D now;
 			next =3D now + max(NEIGH_VAR(neigh->parms, RETRANS_TIME),
@@ -1011,6 +1012,7 @@ int __neigh_event_send(struct neighbour *neigh, struc=
t sk_buff *skb)
 		}
 	} else if (neigh->nud_state & NUD_STALE) {
 		neigh_dbg(2, "neigh %p is delayed\n", neigh);
+		neigh_del_timer(neigh);
 		neigh->nud_state =3D NUD_DELAY;
 		neigh->updated =3D jiffies;
 		neigh_add_timer(neigh, jiffies +
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 1ea0cf8ac4f5..c64d9f100a04 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -1178,12 +1178,8 @@ static void igmpv3_del_delrec(struct in_device *in_d=
ev, struct ip_mc_list *im)
 		im->interface =3D pmc->interface;
 		im->crcount =3D in_dev->mr_qrv ?: IGMP_Unsolicited_Report_Count;
 		if (im->sfmode =3D=3D MCAST_INCLUDE) {
-			im->tomb =3D pmc->tomb;
-			pmc->tomb =3D NULL;
-
-			im->sources =3D pmc->sources;
-			pmc->sources =3D NULL;
-
+			swap(im->tomb, pmc->tomb);
+			swap(im->sources, pmc->sources);
 			for (psf =3D im->sources; psf; psf =3D psf->sf_next)
 				psf->sf_crcount =3D im->crcount;
 		}
diff --git a/net/key/af_key.c b/net/key/af_key.c
index 3b102a4d3933..76cdd633b4a6 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2437,8 +2437,10 @@ static int key_pol_get_resp(struct sock *sk, struct =
xfrm_policy *xp, const struc
 		goto out;
 	}
 	err =3D pfkey_xfrm_policy2msg(out_skb, xp, dir);
-	if (err < 0)
+	if (err < 0) {
+		kfree_skb(out_skb);
 		goto out;
+	}
=20
 	out_hdr =3D (struct sadb_msg *) out_skb->data;
 	out_hdr->sadb_msg_version =3D hdr->sadb_msg_version;
@@ -2689,8 +2691,10 @@ static int dump_sp(struct xfrm_policy *xp, int dir, =
int count, void *ptr)
 		return PTR_ERR(out_skb);
=20
 	err =3D pfkey_xfrm_policy2msg(out_skb, xp, dir);
-	if (err < 0)
+	if (err < 0) {
+		kfree_skb(out_skb);
 		return err;
+	}
=20
 	out_hdr =3D (struct sadb_msg *) out_skb->data;
 	out_hdr->sadb_msg_version =3D pfk->dump.msg_version;
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index b0f84a040f32..7cd22947bdb6 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -149,6 +149,25 @@ static int verify_newsa_info(struct xfrm_usersa_info *=
p,
=20
 	err =3D -EINVAL;
 	switch (p->family) {
+	case AF_INET:
+		break;
+
+	case AF_INET6:
+#if IS_ENABLED(CONFIG_IPV6)
+		break;
+#else
+		err =3D -EAFNOSUPPORT;
+		goto out;
+#endif
+
+	default:
+		goto out;
+	}
+
+	switch (p->sel.family) {
+	case AF_UNSPEC:
+		break;
+
 	case AF_INET:
 		if (p->sel.prefixlen_d > 32 || p->sel.prefixlen_s > 32)
 			goto out;
diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmgr.=
c
index f6396e012a0f..049d61e77f66 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -1014,7 +1014,7 @@ static ssize_t snd_seq_write(struct file *file, const=
 char __user *buf,
 {
 	struct snd_seq_client *client =3D file->private_data;
 	int written =3D 0, len;
-	int err;
+	int err, handled;
 	struct snd_seq_event event;
=20
 	if (!(snd_seq_file_flags(file) & SNDRV_SEQ_LFLG_OUTPUT))
@@ -1027,6 +1027,8 @@ static ssize_t snd_seq_write(struct file *file, const=
 char __user *buf,
 	if (!client->accept_output || client->pool =3D=3D NULL)
 		return -ENXIO;
=20
+ repeat:
+	handled =3D 0;
 	/* allocate the pool now if the pool is not allocated yet */=20
 	mutex_lock(&client->ioctl_mutex);
 	if (client->pool->size > 0 && !snd_seq_write_pool_allocated(client)) {
@@ -1086,12 +1088,19 @@ static ssize_t snd_seq_write(struct file *file, con=
st char __user *buf,
 						   0, 0, &client->ioctl_mutex);
 		if (err < 0)
 			break;
+		handled++;
=20
 	__skip_event:
 		/* Update pointers and counts */
 		count -=3D len;
 		buf +=3D len;
 		written +=3D len;
+
+		/* let's have a coffee break if too many events are queued */
+		if (++handled >=3D 200) {
+			mutex_unlock(&client->ioctl_mutex);
+			goto repeat;
+		}
 	}
=20
  out:
=0D
--=-bi1/Cp80qL9Ej+YCxqV7--

--=-5WFpcKYFlIG4pupIH3/U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl28QwcACgkQ57/I7JWG
EQmHjhAAmopxnSjwZBhgYF/HnGp/OB+eU2eIieRz2jyGtSfCzN/lh2pHwL4xtoz1
hsHg9fjMCgfpYN2TZi0uhQXMGSbBP3W/whIfD+2l7ag/ZfWKJg8c5nD/33VfQw0C
so9xsVGzJGG96vL2fYZeiArhxIhhmmNEOSJz1a4swndX8Xhr+x8hr7KKvXQxl7AS
fm7uM6pgJmcTVhcwC8vUNt3xPdmxR62wxr1jZOkWoBzUhj2maL96vzHkhfAM75OI
0QotcICJr0AJPEJnYNAbZDON7N9De646dSZZHsT8TXRKcJud1YQJlpeb7/4F4N15
1dkAw48QjSMMHqRzhAgsHSK8tLijWTiQlwBAQEGvCH9jQ3OrrFUPJ60ja1rh98cO
aCToa3FhPq1xY8hqPdcRyYwf8AGRrqauPbtVmKJXvV2ZN/OSxvWU6P/O1VDgZr1H
IVjoptYeo8Um+W4XDef15EcrNdBpRDIqmRjdvaTlta3Kni0/fcOouPZj2XVlJ326
r0tEtz9PjIfMkfPmdUs8yxR5fut90ZWOeItn3GUXMQuXFvkcv/UpVR6IA750bhEf
SKL47gsub5LNE+luwyS5iLhZN3uzVsURFTzAiVYrd5U3FDd/5w+qspdlvkfgrwFT
7DIB22LCd2M5P+zedzGr3fF7Cg7cZm1xKW1Wgv693uxugiaip+w=
=pWX+
-----END PGP SIGNATURE-----

--=-5WFpcKYFlIG4pupIH3/U--
