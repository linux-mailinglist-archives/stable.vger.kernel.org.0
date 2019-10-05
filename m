Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 384CECCCB6
	for <lists+stable@lfdr.de>; Sat,  5 Oct 2019 22:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725801AbfJEUmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Oct 2019 16:42:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59184 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725795AbfJEUmv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Oct 2019 16:42:51 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iGqt6-0002bU-4d; Sat, 05 Oct 2019 21:42:48 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iGqt5-0005iB-Uq; Sat, 05 Oct 2019 21:42:47 +0100
Message-ID: <37e9bc3e4bbb12590a8ed00ebf53cd6d3a984f6b.camel@decadent.org.uk>
Subject: Linux 3.16.75
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc:     lwn@lwn.net
Date:   Sat, 05 Oct 2019 21:42:47 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-Be6Yhz239CV6wofnxdsP"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-Be6Yhz239CV6wofnxdsP
Content-Type: multipart/mixed; boundary="=-cUpQWZnzk1bmzd7MlVy8"


--=-cUpQWZnzk1bmzd7MlVy8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.16.75 kernel.

All users of the 3.16 kernel series should upgrade.

The updated 3.16.y git tree can be found at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
.git linux-3.16.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.gi=
t

The diff from 3.16.74 is attached to this message.

Ben.

------------

 Makefile                                          |  2 +-
 arch/arm64/kvm/guest.c                            | 49 ++++++++++++---
 arch/mips/mm/tlbex.c                              | 29 ++++++---
 arch/powerpc/perf/core-book3s.c                   |  8 ++-
 arch/powerpc/perf/power8-pmu.c                    |  3 +
 arch/s390/crypto/aes_s390.c                       | 10 +--
 arch/s390/crypto/des_s390.c                       |  9 +--
 arch/x86/kernel/apic/apic.c                       |  3 +-
 arch/x86/kernel/cpu/bugs.c                        | 11 +++-
 block/blk-mq-tag.c                                |  2 +-
 crypto/crypto_user.c                              |  3 +
 drivers/ata/libata-core.c                         |  9 ++-
 drivers/gpio/Kconfig                              |  1 +
 drivers/gpu/drm/gma500/cdv_intel_lvds.c           |  3 +
 drivers/gpu/drm/gma500/intel_bios.c               |  3 +
 drivers/gpu/drm/gma500/psb_drv.h                  |  1 +
 drivers/hwmon/pmbus/pmbus_core.c                  | 34 ++++++++--
 drivers/i2c/busses/i2c-acorn.c                    |  1 +
 drivers/i2c/i2c-dev.c                             |  1 +
 drivers/input/misc/uinput.c                       | 22 ++++++-
 drivers/md/bcache/bset.c                          | 16 ++++-
 drivers/md/bcache/bset.h                          | 34 +++++-----
 drivers/misc/genwqe/card_dev.c                    |  2 +
 drivers/misc/genwqe/card_utils.c                  |  4 ++
 drivers/net/bonding/bond_main.c                   |  6 +-
 drivers/net/can/flexcan.c                         |  2 +-
 drivers/net/ethernet/dec/tulip/de4x5.c            |  1 -
 drivers/net/ethernet/emulex/benet/be_ethtool.c    | 30 ++++++---
 drivers/net/ethernet/mellanox/mlx4/mcg.c          |  2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c |  3 +-
 drivers/parisc/ccio-dma.c                         |  4 +-
 drivers/parisc/sba_iommu.c                        |  3 +-
 drivers/s390/net/qeth_l2_main.c                   |  2 +-
 drivers/s390/scsi/zfcp_ext.h                      |  1 +
 drivers/s390/scsi/zfcp_scsi.c                     |  9 +++
 drivers/s390/scsi/zfcp_sysfs.c                    | 55 +++++++++++++++--
 drivers/s390/scsi/zfcp_unit.c                     |  8 ++-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c                  |  2 +-
 drivers/scsi/ufs/ufshcd-pltfrm.c                  | 11 ++--
 drivers/scsi/vmw_pvscsi.c                         |  6 +-
 drivers/spi/spi-bitbang.c                         |  2 +-
 drivers/staging/usbip/stub_dev.c                  | 75 ++++++++++++++++---=
----
 drivers/target/target_core_iblock.c               |  2 +-
 drivers/tty/serial/max310x.c                      |  2 +-
 drivers/tty/serial/sh-sci.c                       |  7 +++
 drivers/usb/core/config.c                         |  4 +-
 drivers/usb/core/quirks.c                         |  6 ++
 drivers/usb/host/xhci.c                           |  2 +-
 drivers/usb/misc/rio500.c                         | 17 ++++-
 drivers/usb/serial/pl2303.c                       |  1 +
 drivers/usb/serial/pl2303.h                       |  3 +
 drivers/usb/storage/unusual_realtek.h             |  5 ++
 fs/btrfs/file.c                                   | 12 ++++
 fs/btrfs/reada.c                                  |  7 +++
 fs/cifs/cifsfs.c                                  |  1 +
 fs/cifs/cifsglob.h                                |  5 ++
 fs/cifs/file.c                                    | 12 +++-
 fs/cifs/smb2maperror.c                            |  2 +-
 fs/configfs/dir.c                                 | 14 ++---
 fs/ocfs2/dcache.c                                 | 12 ++++
 include/linux/sched.h                             |  4 ++
 kernel/cpu.c                                      |  3 +
 kernel/cred.c                                     |  9 +++
 kernel/events/core.c                              |  5 +-
 kernel/events/ring_buffer.c                       | 33 ++++++++--
 kernel/ptrace.c                                   | 20 +++++-
 kernel/signal.c                                   |  2 +
 kernel/trace/trace.c                              | 10 +--
 lib/mpi/mpi-pow.c                                 |  6 +-
 mm/huge_memory.c                                  |  2 +
 net/can/af_can.c                                  | 24 +++++++-
 net/core/dev.c                                    |  2 +-
 net/core/neighbour.c                              |  7 +++
 net/core/pktgen.c                                 | 11 ++++
 net/ipv4/igmp.c                                   | 53 +++++++++++-----
 net/ipv6/ip6_flowlabel.c                          |  7 ++-
 net/iucv/af_iucv.c                                | 33 +++++++---
 net/llc/llc_output.c                              |  2 +
 net/rds/ib_rdma.c                                 | 10 +--
 net/sched/sch_netem.c                             | 13 ++--
 net/sctp/endpointola.c                            |  8 +--
 net/wireless/core.c                               |  2 +-
 security/apparmor/policy_unpack.c                 |  2 +-
 sound/core/seq/oss/seq_oss_ioctl.c                |  2 +-
 sound/core/seq/oss/seq_oss_rw.c                   |  2 +-
 sound/soc/codecs/cs42xx8.c                        |  1 +
 86 files changed, 671 insertions(+), 198 deletions(-)

Alan Stern (1):
      USB: Fix slab-out-of-bounds write in usb_get_bos_descriptor

Alejandro Jimenez (1):
      x86/speculation: Allow guests to use SSBD even if host does not

Alexandra Winter (1):
      s390/qeth: fix VLAN attribute in bridge_hostnotify udev event

Andrea Arcangeli (1):
      coredump: fix race condition between collapse_huge_page() and core du=
mping

Andrea Parri (1):
      sbitmap: fix improper use of smp_mb__before_atomic()

Andrey Smirnov (1):
      Input: uinput - add compat ioctl number translation for UI_*_FF_UPLOA=
D

Ben Hutchings (1):
      Linux 3.16.75

Carsten Schmid (1):
      usb: xhci: avoid null pointer deref when bos field is NULL

Chris Packham (1):
      USB: serial: pl2303: add Allied Telesis VT-Kit3

Colin Ian King (3):
      scsi: bnx2fc: fix incorrect cast to u64 on shift operation
      x86/apic: Fix integer overflow on 10 bit left shift of cpu_khz
      ALSA: seq: fix incorrect order of dest_client/dest_ports arguments

Coly Li (1):
      bcache: fix stack corruption by PRECEDING_KEY()

Dan Carpenter (1):
      genwqe: Prevent an integer overflow in the ioctl

Dave Martin (1):
      KVM: arm64: Filter out invalid core register IDs in KVM_GET_REG_LIST

Dmitry Korotin (1):
      MIPS: Add missing EHB in mtc0 -> mfc0 sequence.

Eiichi Tsukata (1):
      tracing/snapshot: Resize spare buffer if size changed

Eric Biggers (2):
      cfg80211: fix memory leak of wiphy device name
      crypto: user - prevent operating on larval algorithms

Eric Dumazet (6):
      ipv4/igmp: fix another memory leak in igmpv3_del_delrec()
      ipv4/igmp: fix build error if !CONFIG_IP_MULTICAST
      llc: fix skb leak in llc_build_and_send_ui_pkt()
      net-gro: fix use-after-free read in napi_gro_frags()
      ipv6: flowlabel: fl6_sock_lookup() must use atomic_inc_not_zero
      neigh: fix use-after-free read in pneigh_get_next

Eric W. Biederman (1):
      signal/ptrace: Don't leak unitialized kernel memory with PTRACE_PEEK_=
SIGINFO

Filipe Manana (2):
      Btrfs: fix race between ranged fsync and writeback of adjacent ranges
      Btrfs: fix race between readahead and device replace/removal

Geert Uytterhoeven (1):
      cpu/speculation: Warn on unsupported mitigations=3D parameter

George G. Davis (1):
      serial: sh-sci: disable DMA for uart_console

Hans de Goede (1):
      libata: Extend quirks for the ST1000LM024 drives with NOLPM quirk

Harald Freudenberger (1):
      s390/crypto: fix possible sleep during spinlock aquired

Herbert Xu (1):
      lib/mpi: Fix karactx leak in mpi_powm

Ivan Vecera (1):
      be2net: Fix number of Rx queues used for flow hashing

Jakub Kicinski (1):
      net: netem: fix backlog accounting for corrupted GSO frames

Jan Kara (1):
      scsi: vmw_pscsi: Fix use-after-free in pvscsi_queue_lck()

Jan Stancek (1):
      powerpc/perf: add missing put_cpu_var in power_pmu_event_init

Jann Horn (2):
      ptrace: restore smp_rmb() in __ptrace_may_access()
      apparmor: enforce nullbyte at end of tag string

Jisheng Zhang (1):
      net: stmmac: fix reset gpio free missing

Joakim Zhang (1):
      can: flexcan: fix timeout when set small bitrate

Joe Burmeister (1):
      tty: max310x: Fix external crystal register setup

John David Anglin (1):
      parisc: Use implicit space register selection for loading the coheren=
ce index of I/O pdirs

Julian Wiedmann (2):
      net/af_iucv: remove GFP_DMA restriction for HiperTransport
      net/af_iucv: always register net_device notifier

Kai-Heng Feng (1):
      USB: usb-storage: Add new ID to ums-realtek

Kees Cook (1):
      net: tulip: de4x5: Drop redundant MODULE_DEVICE_TABLE()

Marco Zatta (1):
      USB: Fix chipmunk-like voice when using Logitech C270 for recording a=
udio.

Maximilian Luz (1):
      USB: Add LPM quirk for Surface Dock GigE adapter

Naohiro Aota (1):
      btrfs: start readahead also in seed devices

Oliver Neukum (1):
      USB: rio500: fix memory leak in close after disconnect

Paolo Abeni (1):
      pktgen: do not sleep with the thread lock held.

Patrik Jakobsson (1):
      drm/gma500/cdv: Check vbt config bits when detecting lvds panels

Peter Zijlstra (2):
      perf/ring_buffer: Add ordering to rb->nest increment
      perf/core: Fix perf_sample_regs_user() mm check

Petr Oros (1):
      be2net: fix link failure after ethtool offline test

Randy Dunlap (1):
      gpio: fix gpio-adp5588 build errors

Ravi Bangoria (2):
      powerpc/perf: Fix MMCRA corruption by bhrb_filter
      perf/ioctl: Add check for the sample_period value

Robert Hancock (1):
      hwmon: (pmbus/core) Treat parameters as paged if on multiple pages

Roberto Bergantinos Corpas (1):
      CIFS: cifs_read_allocate_pages: don't iterate through whole page arra=
y on ENOMEM

Roman Bolshakov (1):
      scsi: target/iblock: Fix overrun in WRITE SAME emulation

Ronnie Sahlberg (1):
      cifs: add spinlock for the openFileList to cifsInodeInfo

Russell King (1):
      i2c: acorn: fix i2c warning

S.j. Wang (1):
      ASoC: cs42xx8: Add regcache mask dirty

Sahitya Tummala (1):
      configfs: Fix use-after-free when accessing sd->s_dentry

Shuah Khan (2):
      usbip: usbip_host: fix BUG: sleeping function called from invalid con=
text
      usbip: usbip_host: fix stub_dev lock context imbalance regression

Stanley Chu (1):
      scsi: ufs: Avoid runtime suspend possibly being blocked forever

Steffen Maier (2):
      scsi: zfcp: fix missing zfcp_port reference put on -EBUSY from port_r=
emove
      scsi: zfcp: fix to prevent port_remove with pure auto scan LUNs (only=
 sdevs)

Steve French (1):
      SMB3: retry on STATUS_INSUFFICIENT_RESOURCES instead of failing write

WANG Cong (2):
      igmp: acquire pmc lock for ip_mc_clear_src()
      igmp: add a missing spin_lock_init()

Wengang Wang (1):
      fs/ocfs2: fix race in ocfs2_dentry_attach_lock()

Willem de Bruijn (1):
      can: purge socket error queue on sock destruct

Xin Long (1):
      sctp: change to hold sk after auth shkey is created successfully

Yabin Cui (1):
      perf/ring_buffer: Fix exposing a temporarily decreased data_head

Yingjoe Chen (1):
      i2c: dev: fix potential memory leak in i2cdev_ioctl_rdwr

YueHaibing (4):
      spi: bitbang: Fix NULL pointer dereference in spi_unregister_master
      can: af_can: Fix error path of can_init()
      bonding: Always enable vlan tx offload
      bonding: Add vlan tx offload to hw_enc_features

Yunjian Wang (1):
      net/mlx4_core: Change the error print to info print

Zhenliang Wei (1):
      kernel/signal.c: trace_signal_deliver when signal_group_exit

Zhu Yanjun (1):
      net: rds: fix memory leak in rds_ib_flush_mr_pool

--=20
Ben Hutchings
The most exhausting thing in life is being insincere.
                                                 - Anne Morrow Lindberg



--=-cUpQWZnzk1bmzd7MlVy8
Content-Type: text/x-diff; charset="UTF-8"; name="linux-3.16.75.patch"
Content-Disposition: attachment; filename="linux-3.16.75.patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/Makefile b/Makefile
index e4979fd42baa..44181a4e18f4 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 16
-SUBLEVEL =3D 74
+SUBLEVEL =3D 75
 EXTRAVERSION =3D
 NAME =3D Museum of Fishiegoodies
=20
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 10b8838c5ee0..c9d02850f260 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -46,9 +46,8 @@ static u64 core_reg_offset_from_id(u64 id)
 	return id & ~(KVM_REG_ARCH_MASK | KVM_REG_SIZE_MASK | KVM_REG_ARM_CORE);
 }
=20
-static int validate_core_offset(const struct kvm_one_reg *reg)
+static int core_reg_size_from_offset(u64 off)
 {
-	u64 off =3D core_reg_offset_from_id(reg->id);
 	int size;
=20
 	switch (off) {
@@ -78,13 +77,26 @@ static int validate_core_offset(const struct kvm_one_re=
g *reg)
 		return -EINVAL;
 	}
=20
-	if (KVM_REG_SIZE(reg->id) =3D=3D size &&
-	    IS_ALIGNED(off, size / sizeof(__u32)))
-		return 0;
+	if (IS_ALIGNED(off, size / sizeof(__u32)))
+		return size;
=20
 	return -EINVAL;
 }
=20
+static int validate_core_offset(const struct kvm_one_reg *reg)
+{
+	u64 off =3D core_reg_offset_from_id(reg->id);
+	int size =3D core_reg_size_from_offset(off);
+
+	if (size < 0)
+		return -EINVAL;
+
+	if (KVM_REG_SIZE(reg->id) !=3D size)
+		return -EINVAL;
+
+	return 0;
+}
+
 static int get_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *r=
eg)
 {
 	/*
@@ -197,10 +209,33 @@ unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu)
 int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 {
 	unsigned int i;
-	const u64 core_reg =3D KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_COR=
E;
=20
 	for (i =3D 0; i < sizeof(struct kvm_regs) / sizeof(__u32); i++) {
-		if (put_user(core_reg | i, uindices))
+		u64 reg =3D KVM_REG_ARM64 | KVM_REG_ARM_CORE | i;
+		int size =3D core_reg_size_from_offset(i);
+
+		if (size < 0)
+			continue;
+
+		switch (size) {
+		case sizeof(__u32):
+			reg |=3D KVM_REG_SIZE_U32;
+			break;
+
+		case sizeof(__u64):
+			reg |=3D KVM_REG_SIZE_U64;
+			break;
+
+		case sizeof(__uint128_t):
+			reg |=3D KVM_REG_SIZE_U128;
+			break;
+
+		default:
+			WARN_ON(1);
+			continue;
+		}
+
+		if (put_user(reg, uindices))
 			return -EFAULT;
 		uindices++;
 	}
diff --git a/arch/mips/mm/tlbex.c b/arch/mips/mm/tlbex.c
index b2e89a1aad68..04c86cfffe6f 100644
--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -374,6 +374,7 @@ static struct work_registers build_get_work_registers(u=
32 **p)
 static void build_restore_work_registers(u32 **p)
 {
 	if (scratch_reg >=3D 0) {
+		uasm_i_ehb(p);
 		UASM_i_MFC0(p, 1, c0_kscratch(), scratch_reg);
 		return;
 	}
@@ -665,10 +666,12 @@ static void build_restore_pagemask(u32 **p, struct ua=
sm_reloc **r,
 			uasm_i_mtc0(p, 0, C0_PAGEMASK);
 			uasm_il_b(p, r, lid);
 		}
-		if (scratch_reg >=3D 0)
+		if (scratch_reg >=3D 0) {
+			uasm_i_ehb(p);
 			UASM_i_MFC0(p, 1, c0_kscratch(), scratch_reg);
-		else
+		} else {
 			UASM_i_LW(p, 1, scratchpad_offset(0), 0);
+		}
 	} else {
 		/* Reset default page size */
 		if (PM_DEFAULT_MASK >> 16) {
@@ -906,10 +909,12 @@ build_get_pgd_vmalloc64(u32 **p, struct uasm_label **=
l, struct uasm_reloc **r,
 		uasm_i_jr(p, ptr);
=20
 		if (mode =3D=3D refill_scratch) {
-			if (scratch_reg >=3D 0)
+			if (scratch_reg >=3D 0) {
+				uasm_i_ehb(p);
 				UASM_i_MFC0(p, 1, c0_kscratch(), scratch_reg);
-			else
+			} else {
 				UASM_i_LW(p, 1, scratchpad_offset(0), 0);
+			}
 		} else {
 			uasm_i_nop(p);
 		}
@@ -1215,6 +1220,7 @@ build_fast_tlb_refill_handler (u32 **p, struct uasm_l=
abel **l,
 	UASM_i_MTC0(p, odd, C0_ENTRYLO1); /* load it */
=20
 	if (c0_scratch_reg >=3D 0) {
+		uasm_i_ehb(p);
 		UASM_i_MFC0(p, scratch, c0_kscratch(), c0_scratch_reg);
 		build_tlb_write_entry(p, l, r, tlb_random);
 		uasm_l_leave(l, *p);
@@ -1466,12 +1472,14 @@ static void build_setup_pgd(void)
 		uasm_i_dinsm(&p, a0, 0, 29, 64 - 29);
 		uasm_l_tlbl_goaround1(&l, p);
 		UASM_i_SLL(&p, a0, a0, 11);
-		uasm_i_jr(&p, 31);
 		UASM_i_MTC0(&p, a0, C0_CONTEXT);
+		uasm_i_jr(&p, 31);
+		uasm_i_ehb(&p);
 	} else {
 		/* PGD in c0_KScratch */
-		uasm_i_jr(&p, 31);
 		UASM_i_MTC0(&p, a0, c0_kscratch(), pgd_reg);
+		uasm_i_jr(&p, 31);
+		uasm_i_ehb(&p);
 	}
 #else
 #ifdef CONFIG_SMP
@@ -1485,13 +1493,16 @@ static void build_setup_pgd(void)
 	UASM_i_LA_mostly(&p, a2, pgdc);
 	UASM_i_SW(&p, a0, uasm_rel_lo(pgdc), a2);
 #endif /* SMP */
-	uasm_i_jr(&p, 31);
=20
 	/* if pgd_reg is allocated, save PGD also to scratch register */
-	if (pgd_reg !=3D -1)
+	if (pgd_reg !=3D -1) {
 		UASM_i_MTC0(&p, a0, c0_kscratch(), pgd_reg);
-	else
+		uasm_i_jr(&p, 31);
+		uasm_i_ehb(&p);
+	} else {
+		uasm_i_jr(&p, 31);
 		uasm_i_nop(&p);
+	}
 #endif
 	if (p >=3D tlbmiss_handler_setup_pgd_end)
 		panic("tlbmiss_handler_setup_pgd space exceeded");
diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3=
s.c
index 9970a504903f..0c612a36542f 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -1726,6 +1726,7 @@ static int power_pmu_event_init(struct perf_event *ev=
ent)
 	int n;
 	int err;
 	struct cpu_hw_events *cpuhw;
+	u64 bhrb_filter;
=20
 	if (!ppmu)
 		return -ENOENT;
@@ -1822,11 +1823,14 @@ static int power_pmu_event_init(struct perf_event *=
event)
 	err =3D power_check_constraints(cpuhw, events, cflags, n + 1);
=20
 	if (has_branch_stack(event)) {
-		cpuhw->bhrb_filter =3D ppmu->bhrb_filter_map(
+		bhrb_filter =3D ppmu->bhrb_filter_map(
 					event->attr.branch_sample_type);
=20
-		if(cpuhw->bhrb_filter =3D=3D -1)
+		if (bhrb_filter =3D=3D -1) {
+			put_cpu_var(cpu_hw_events);
 			return -EOPNOTSUPP;
+		}
+		cpuhw->bhrb_filter =3D bhrb_filter;
 	}
=20
 	put_cpu_var(cpu_hw_events);
diff --git a/arch/powerpc/perf/power8-pmu.c b/arch/powerpc/perf/power8-pmu.=
c
index fc6b5282bce1..71e630d9558b 100644
--- a/arch/powerpc/perf/power8-pmu.c
+++ b/arch/powerpc/perf/power8-pmu.c
@@ -175,6 +175,7 @@
 #define	POWER8_MMCRA_IFM1		0x0000000040000000UL
 #define	POWER8_MMCRA_IFM2		0x0000000080000000UL
 #define	POWER8_MMCRA_IFM3		0x00000000C0000000UL
+#define	POWER8_MMCRA_BHRB_MASK		0x00000000C0000000UL
=20
 #define ONLY_PLM \
 	(PERF_SAMPLE_BRANCH_USER        |\
@@ -666,6 +667,8 @@ static u64 power8_bhrb_filter_map(u64 branch_sample_typ=
e)
=20
 static void power8_config_bhrb(u64 pmu_bhrb_filter)
 {
+	pmu_bhrb_filter &=3D POWER8_MMCRA_BHRB_MASK;
+
 	/* Enable BHRB filter in PMU */
 	mtspr(SPRN_MMCRA, (mfspr(SPRN_MMCRA) | pmu_bhrb_filter));
 }
diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 1f272b24fc0b..941dd9415b6a 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -25,7 +25,7 @@
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include "crypt_s390.h"
=20
 #define AES_KEYLEN_128		1
@@ -33,7 +33,7 @@
 #define AES_KEYLEN_256		4
=20
 static u8 *ctrblk;
-static DEFINE_SPINLOCK(ctrblk_lock);
+static DEFINE_MUTEX(ctrblk_lock);
 static char keylen_flag;
=20
 struct s390_aes_ctx {
@@ -785,7 +785,7 @@ static int ctr_aes_crypt(struct blkcipher_desc *desc, l=
ong func,
 	if (!walk->nbytes)
 		return ret;
=20
-	if (spin_trylock(&ctrblk_lock))
+	if (mutex_trylock(&ctrblk_lock))
 		ctrptr =3D ctrblk;
=20
 	memcpy(ctrptr, walk->iv, AES_BLOCK_SIZE);
@@ -801,7 +801,7 @@ static int ctr_aes_crypt(struct blkcipher_desc *desc, l=
ong func,
 					       n, ctrptr);
 			if (ret < 0 || ret !=3D n) {
 				if (ctrptr =3D=3D ctrblk)
-					spin_unlock(&ctrblk_lock);
+					mutex_unlock(&ctrblk_lock);
 				return -EIO;
 			}
 			if (n > AES_BLOCK_SIZE)
@@ -819,7 +819,7 @@ static int ctr_aes_crypt(struct blkcipher_desc *desc, l=
ong func,
 			memcpy(ctrbuf, ctrptr, AES_BLOCK_SIZE);
 		else
 			memcpy(walk->iv, ctrptr, AES_BLOCK_SIZE);
-		spin_unlock(&ctrblk_lock);
+		mutex_unlock(&ctrblk_lock);
 	} else {
 		if (!nbytes)
 			memcpy(walk->iv, ctrptr, AES_BLOCK_SIZE);
diff --git a/arch/s390/crypto/des_s390.c b/arch/s390/crypto/des_s390.c
index 9e05cc453a40..b4733d80521e 100644
--- a/arch/s390/crypto/des_s390.c
+++ b/arch/s390/crypto/des_s390.c
@@ -17,6 +17,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/crypto.h>
+#include <linux/mutex.h>
 #include <crypto/algapi.h>
 #include <crypto/des.h>
=20
@@ -25,7 +26,7 @@
 #define DES3_KEY_SIZE	(3 * DES_KEY_SIZE)
=20
 static u8 *ctrblk;
-static DEFINE_SPINLOCK(ctrblk_lock);
+static DEFINE_MUTEX(ctrblk_lock);
=20
 struct s390_des_ctx {
 	u8 iv[DES_BLOCK_SIZE];
@@ -394,7 +395,7 @@ static int ctr_desall_crypt(struct blkcipher_desc *desc=
, long func,
 	if (!walk->nbytes)
 		return ret;
=20
-	if (spin_trylock(&ctrblk_lock))
+	if (mutex_trylock(&ctrblk_lock))
 		ctrptr =3D ctrblk;
=20
 	memcpy(ctrptr, walk->iv, DES_BLOCK_SIZE);
@@ -410,7 +411,7 @@ static int ctr_desall_crypt(struct blkcipher_desc *desc=
, long func,
 					       n, ctrptr);
 			if (ret < 0 || ret !=3D n) {
 				if (ctrptr =3D=3D ctrblk)
-					spin_unlock(&ctrblk_lock);
+					mutex_unlock(&ctrblk_lock);
 				return -EIO;
 			}
 			if (n > DES_BLOCK_SIZE)
@@ -428,7 +429,7 @@ static int ctr_desall_crypt(struct blkcipher_desc *desc=
, long func,
 			memcpy(ctrbuf, ctrptr, DES_BLOCK_SIZE);
 		else
 			memcpy(walk->iv, ctrptr, DES_BLOCK_SIZE);
-		spin_unlock(&ctrblk_lock);
+		mutex_unlock(&ctrblk_lock);
 	} else {
 		if (!nbytes)
 			memcpy(walk->iv, ctrptr, DES_BLOCK_SIZE);
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 23604cda2178..fb2cce787f79 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1403,7 +1403,8 @@ void setup_local_APIC(void)
 		if (queued) {
 			if (cpu_has_tsc && cpu_khz) {
 				rdtscll(ntsc);
-				max_loops =3D (cpu_khz << 10) - (ntsc - tsc);
+				max_loops =3D (long long)cpu_khz << 10;
+				max_loops -=3D ntsc - tsc;
 			} else
 				max_loops--;
 		}
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index f9e23ee19bcb..0340dfdbce7d 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -959,6 +959,16 @@ static enum ssb_mitigation __init __ssb_select_mitigat=
ion(void)
 		break;
 	}
=20
+	/*
+	 * If SSBD is controlled by the SPEC_CTRL MSR, then set the proper
+	 * bit in the mask to allow guests to use the mitigation even in the
+	 * case where the host does not enable it.
+	 */
+	if (static_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) ||
+	    static_cpu_has(X86_FEATURE_AMD_SSBD)) {
+		x86_spec_ctrl_mask |=3D SPEC_CTRL_SSBD;
+	}
+
 	/*
 	 * We have three CPU feature flags that are in play here:
 	 *  - X86_BUG_SPEC_STORE_BYPASS - CPU is susceptible.
@@ -976,7 +986,6 @@ static enum ssb_mitigation __init __ssb_select_mitigati=
on(void)
 			x86_amd_ssb_disable();
 		} else {
 			x86_spec_ctrl_base |=3D SPEC_CTRL_SSBD;
-			x86_spec_ctrl_mask |=3D SPEC_CTRL_SSBD;
 			wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
 		}
 	}
diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 7f9b41f7ad8a..d9675a199c6d 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -499,7 +499,7 @@ static void bt_update_count(struct blk_mq_bitmap_tags *=
bt,
 		 * Pairs with the memory barrier in bt_clear_tag() to ensure
 		 * that the batch size is updated before the wait counts.
 		 */
-		smp_mb__before_atomic();
+		smp_mb();
 		for (i =3D 0; i < BT_WAIT_QUEUES; i++)
 			atomic_set(&bt->bs[i].wait_cnt, 1);
 	}
diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index 0d651d87cd7c..4e9be2e02090 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -53,6 +53,9 @@ static struct crypto_alg *crypto_alg_match(struct crypto_=
user_alg *p, int exact)
 	list_for_each_entry(q, &crypto_alg_list, cra_list) {
 		int match =3D 0;
=20
+		if (crypto_is_larval(q))
+			continue;
+
 		if ((q->cra_flags ^ p->cru_type) & p->cru_mask)
 			continue;
=20
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index dddba3bb56fa..00d441ebfa91 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4176,9 +4176,12 @@ static const struct ata_blacklist_entry ata_device_b=
lacklist [] =3D {
 	{ "ST3320[68]13AS",	"SD1[5-9]",	ATA_HORKAGE_NONCQ |
 						ATA_HORKAGE_FIRMWARE_WARN },
=20
-	/* drives which fail FPDMA_AA activation (some may freeze afterwards) */
-	{ "ST1000LM024 HN-M101MBB", "2AR10001",	ATA_HORKAGE_BROKEN_FPDMA_AA },
-	{ "ST1000LM024 HN-M101MBB", "2BA30001",	ATA_HORKAGE_BROKEN_FPDMA_AA },
+	/* drives which fail FPDMA_AA activation (some may freeze afterwards)
+	   the ST disks also have LPM issues */
+	{ "ST1000LM024 HN-M101MBB", "2AR10001",	ATA_HORKAGE_BROKEN_FPDMA_AA |
+						ATA_HORKAGE_NOLPM, },
+	{ "ST1000LM024 HN-M101MBB", "2BA30001",	ATA_HORKAGE_BROKEN_FPDMA_AA |
+						ATA_HORKAGE_NOLPM, },
 	{ "VB0250EAVER",	"HPG7",		ATA_HORKAGE_BROKEN_FPDMA_AA },
=20
 	/* Blacklist entries taken from Silicon Image 3124/3132
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 53a2f65fb166..208df29d5c78 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -654,6 +654,7 @@ config GPIO_ADP5588
 config GPIO_ADP5588_IRQ
 	bool "Interrupt controller support for ADP5588"
 	depends on GPIO_ADP5588=3Dy
+	select GPIOLIB_IRQCHIP
 	help
 	  Say yes here to enable the adp5588 to be used as an interrupt
 	  controller. It requires the driver to be built in the kernel.
diff --git a/drivers/gpu/drm/gma500/cdv_intel_lvds.c b/drivers/gpu/drm/gma5=
00/cdv_intel_lvds.c
index 8ecc920fc26d..a9b17be0ad34 100644
--- a/drivers/gpu/drm/gma500/cdv_intel_lvds.c
+++ b/drivers/gpu/drm/gma500/cdv_intel_lvds.c
@@ -620,6 +620,9 @@ void cdv_intel_lvds_init(struct drm_device *dev,
 	int pipe;
 	u8 pin;
=20
+	if (!dev_priv->lvds_enabled_in_vbt)
+		return;
+
 	pin =3D GMBUS_PORT_PANEL;
 	if (!lvds_is_present_in_vbt(dev, &pin)) {
 		DRM_DEBUG_KMS("LVDS is not present in VBT\n");
diff --git a/drivers/gpu/drm/gma500/intel_bios.c b/drivers/gpu/drm/gma500/i=
ntel_bios.c
index d3497348c4d5..d6784f8c3a27 100644
--- a/drivers/gpu/drm/gma500/intel_bios.c
+++ b/drivers/gpu/drm/gma500/intel_bios.c
@@ -436,6 +436,9 @@ parse_driver_features(struct drm_psb_private *dev_priv,
 	if (driver->lvds_config =3D=3D BDB_DRIVER_FEATURE_EDP)
 		dev_priv->edp.support =3D 1;
=20
+	dev_priv->lvds_enabled_in_vbt =3D driver->lvds_config !=3D 0;
+	DRM_DEBUG_KMS("LVDS VBT config bits: 0x%x\n", driver->lvds_config);
+
 	/* This bit means to use 96Mhz for DPLL_A or not */
 	if (driver->primary_lfp_id)
 		dev_priv->dplla_96mhz =3D true;
diff --git a/drivers/gpu/drm/gma500/psb_drv.h b/drivers/gpu/drm/gma500/psb_=
drv.h
index 55ebe2bd88dd..db55eabc6390 100644
--- a/drivers/gpu/drm/gma500/psb_drv.h
+++ b/drivers/gpu/drm/gma500/psb_drv.h
@@ -533,6 +533,7 @@ struct drm_psb_private {
 	int lvds_ssc_freq;
 	bool is_lvds_on;
 	bool is_mipi_on;
+	bool lvds_enabled_in_vbt;
 	u32 mipi_ctrl_display;
=20
 	unsigned int core_freq;
diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_c=
ore.c
index 1b0b4125f8a5..3f41309ab905 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -987,14 +987,15 @@ static int pmbus_add_sensor_attrs_one(struct i2c_clie=
nt *client,
 				      const struct pmbus_driver_info *info,
 				      const char *name,
 				      int index, int page,
-				      const struct pmbus_sensor_attr *attr)
+				      const struct pmbus_sensor_attr *attr,
+				      bool paged)
 {
 	struct pmbus_sensor *base;
 	int ret;
=20
 	if (attr->label) {
 		ret =3D pmbus_add_label(data, name, index, attr->label,
-				      attr->paged ? page + 1 : 0);
+				      paged ? page + 1 : 0);
 		if (ret)
 			return ret;
 	}
@@ -1026,6 +1027,30 @@ static int pmbus_add_sensor_attrs_one(struct i2c_cli=
ent *client,
 	return 0;
 }
=20
+static bool pmbus_sensor_is_paged(const struct pmbus_driver_info *info,
+				  const struct pmbus_sensor_attr *attr)
+{
+	int p;
+
+	if (attr->paged)
+		return true;
+
+	/*
+	 * Some attributes may be present on more than one page despite
+	 * not being marked with the paged attribute. If that is the case,
+	 * then treat the sensor as being paged and add the page suffix to the
+	 * attribute name.
+	 * We don't just add the paged attribute to all such attributes, in
+	 * order to maintain the un-suffixed labels in the case where the
+	 * attribute is only on page 0.
+	 */
+	for (p =3D 1; p < info->pages; p++) {
+		if (info->func[p] & attr->func)
+			return true;
+	}
+	return false;
+}
+
 static int pmbus_add_sensor_attrs(struct i2c_client *client,
 				  struct pmbus_data *data,
 				  const char *name,
@@ -1039,14 +1064,15 @@ static int pmbus_add_sensor_attrs(struct i2c_client=
 *client,
 	index =3D 1;
 	for (i =3D 0; i < nattrs; i++) {
 		int page, pages;
+		bool paged =3D pmbus_sensor_is_paged(info, attrs);
=20
-		pages =3D attrs->paged ? info->pages : 1;
+		pages =3D paged ? info->pages : 1;
 		for (page =3D 0; page < pages; page++) {
 			if (!(info->func[page] & attrs->func))
 				continue;
 			ret =3D pmbus_add_sensor_attrs_one(client, data, info,
 							 name, index, page,
-							 attrs);
+							 attrs, paged);
 			if (ret)
 				return ret;
 			index++;
diff --git a/drivers/i2c/busses/i2c-acorn.c b/drivers/i2c/busses/i2c-acorn.=
c
index 9d7be5af2bf2..6618db75fa25 100644
--- a/drivers/i2c/busses/i2c-acorn.c
+++ b/drivers/i2c/busses/i2c-acorn.c
@@ -83,6 +83,7 @@ static struct i2c_algo_bit_data ioc_data =3D {
=20
 static struct i2c_adapter ioc_ops =3D {
 	.nr			=3D 0,
+	.name			=3D "ioc",
 	.algo_data		=3D &ioc_data,
 };
=20
diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
index 69640fa51cb8..0c2e3edf290f 100644
--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -300,6 +300,7 @@ static noinline int i2cdev_ioctl_rdrw(struct i2c_client=
 *client,
 			    rdwr_pa[i].buf[0] < 1 ||
 			    rdwr_pa[i].len < rdwr_pa[i].buf[0] +
 					     I2C_SMBUS_BLOCK_MAX) {
+				i++;
 				res =3D -EINVAL;
 				break;
 			}
diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
index 08cf73e92cb3..5e3f9da0b828 100644
--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -908,13 +908,31 @@ static long uinput_ioctl(struct file *file, unsigned =
int cmd, unsigned long arg)
=20
 #ifdef CONFIG_COMPAT
=20
-#define UI_SET_PHYS_COMPAT	_IOW(UINPUT_IOCTL_BASE, 108, compat_uptr_t)
+/*
+ * These IOCTLs change their size and thus their numbers between
+ * 32 and 64 bits.
+ */
+#define UI_SET_PHYS_COMPAT		\
+	_IOW(UINPUT_IOCTL_BASE, 108, compat_uptr_t)
+#define UI_BEGIN_FF_UPLOAD_COMPAT	\
+	_IOWR(UINPUT_IOCTL_BASE, 200, struct uinput_ff_upload_compat)
+#define UI_END_FF_UPLOAD_COMPAT		\
+	_IOW(UINPUT_IOCTL_BASE, 201, struct uinput_ff_upload_compat)
=20
 static long uinput_compat_ioctl(struct file *file,
 				unsigned int cmd, unsigned long arg)
 {
-	if (cmd =3D=3D UI_SET_PHYS_COMPAT)
+	switch (cmd) {
+	case UI_SET_PHYS_COMPAT:
 		cmd =3D UI_SET_PHYS;
+		break;
+	case UI_BEGIN_FF_UPLOAD_COMPAT:
+		cmd =3D UI_BEGIN_FF_UPLOAD;
+		break;
+	case UI_END_FF_UPLOAD_COMPAT:
+		cmd =3D UI_END_FF_UPLOAD;
+		break;
+	}
=20
 	return uinput_ioctl_handler(file, cmd, arg, compat_ptr(arg));
 }
diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
index 545416415305..7ab5c2b83bc5 100644
--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -823,12 +823,22 @@ unsigned bch_btree_insert_key(struct btree_keys *b, s=
truct bkey *k,
 	struct bset *i =3D bset_tree_last(b)->data;
 	struct bkey *m, *prev =3D NULL;
 	struct btree_iter iter;
+	struct bkey preceding_key_on_stack =3D ZERO_KEY;
+	struct bkey *preceding_key_p =3D &preceding_key_on_stack;
=20
 	BUG_ON(b->ops->is_extents && !KEY_SIZE(k));
=20
-	m =3D bch_btree_iter_init(b, &iter, b->ops->is_extents
-				? PRECEDING_KEY(&START_KEY(k))
-				: PRECEDING_KEY(k));
+	/*
+	 * If k has preceding key, preceding_key_p will be set to address
+	 *  of k's preceding key; otherwise preceding_key_p will be set
+	 * to NULL inside preceding_key().
+	 */
+	if (b->ops->is_extents)
+		preceding_key(&START_KEY(k), &preceding_key_p);
+	else
+		preceding_key(k, &preceding_key_p);
+
+	m =3D bch_btree_iter_init(b, &iter, preceding_key_p);
=20
 	if (b->ops->insert_fixup(b, k, &iter, replace_key))
 		return status;
diff --git a/drivers/md/bcache/bset.h b/drivers/md/bcache/bset.h
index 5f6728d5d4dd..100ec0b7a869 100644
--- a/drivers/md/bcache/bset.h
+++ b/drivers/md/bcache/bset.h
@@ -417,20 +417,26 @@ static inline bool bch_cut_back(const struct bkey *wh=
ere, struct bkey *k)
 	return __bch_cut_back(where, k);
 }
=20
-#define PRECEDING_KEY(_k)					\
-({								\
-	struct bkey *_ret =3D NULL;				\
-								\
-	if (KEY_INODE(_k) || KEY_OFFSET(_k)) {			\
-		_ret =3D &KEY(KEY_INODE(_k), KEY_OFFSET(_k), 0);	\
-								\
-		if (!_ret->low)					\
-			_ret->high--;				\
-		_ret->low--;					\
-	}							\
-								\
-	_ret;							\
-})
+/*
+ * Pointer '*preceding_key_p' points to a memory object to store preceding
+ * key of k. If the preceding key does not exist, set '*preceding_key_p' t=
o
+ * NULL. So the caller of preceding_key() needs to take care of memory
+ * which '*preceding_key_p' pointed to before calling preceding_key().
+ * Currently the only caller of preceding_key() is bch_btree_insert_key(),
+ * and it points to an on-stack variable, so the memory release is handled
+ * by stackframe itself.
+ */
+static inline void preceding_key(struct bkey *k, struct bkey **preceding_k=
ey_p)
+{
+	if (KEY_INODE(k) || KEY_OFFSET(k)) {
+		(**preceding_key_p) =3D KEY(KEY_INODE(k), KEY_OFFSET(k), 0);
+		if (!(*preceding_key_p)->low)
+			(*preceding_key_p)->high--;
+		(*preceding_key_p)->low--;
+	} else {
+		(*preceding_key_p) =3D NULL;
+	}
+}
=20
 static inline bool bch_ptr_invalid(struct btree_keys *b, const struct bkey=
 *k)
 {
diff --git a/drivers/misc/genwqe/card_dev.c b/drivers/misc/genwqe/card_dev.=
c
index ceac798c1d9c..6c0a5ce19722 100644
--- a/drivers/misc/genwqe/card_dev.c
+++ b/drivers/misc/genwqe/card_dev.c
@@ -779,6 +779,8 @@ static int genwqe_pin_mem(struct genwqe_file *cfile, st=
ruct genwqe_mem *m)
=20
 	if ((m->addr =3D=3D 0x0) || (m->size =3D=3D 0))
 		return -EINVAL;
+	if (m->size > ULONG_MAX - PAGE_SIZE - (m->addr & ~PAGE_MASK))
+		return -EINVAL;
=20
 	map_addr =3D (m->addr & PAGE_MASK);
 	map_size =3D round_up(m->size + (m->addr & ~PAGE_MASK), PAGE_SIZE);
diff --git a/drivers/misc/genwqe/card_utils.c b/drivers/misc/genwqe/card_ut=
ils.c
index bcde07267b95..691afde695a5 100644
--- a/drivers/misc/genwqe/card_utils.c
+++ b/drivers/misc/genwqe/card_utils.c
@@ -571,6 +571,10 @@ int genwqe_user_vmap(struct genwqe_dev *cd, struct dma=
_mapping *m, void *uaddr,
 	/* determine space needed for page_list. */
 	data =3D (unsigned long)uaddr;
 	offs =3D offset_in_page(data);
+	if (size > ULONG_MAX - PAGE_SIZE - offs) {
+		m->size =3D 0;	/* mark unused and not added */
+		return -EINVAL;
+	}
 	m->nr_pages =3D DIV_ROUND_UP(offs + size, PAGE_SIZE);
=20
 	m->page_list =3D kcalloc(m->nr_pages,
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_mai=
n.c
index 54516a8502a6..9285ec6007a8 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1083,7 +1083,9 @@ static void bond_compute_features(struct bonding *bon=
d)
=20
 done:
 	bond_dev->vlan_features =3D vlan_features;
-	bond_dev->hw_enc_features =3D enc_features;
+	bond_dev->hw_enc_features =3D enc_features |
+				    NETIF_F_HW_VLAN_CTAG_TX |
+				    NETIF_F_HW_VLAN_STAG_TX;
 	bond_dev->hard_header_len =3D max_hard_header_len;
 	bond_dev->gso_max_segs =3D gso_max_segs;
 	netif_set_gso_max_size(bond_dev, gso_max_size);
@@ -4038,13 +4040,13 @@ void bond_setup(struct net_device *bond_dev)
 	bond_dev->features |=3D NETIF_F_NETNS_LOCAL;
=20
 	bond_dev->hw_features =3D BOND_VLAN_FEATURES |
-				NETIF_F_HW_VLAN_CTAG_TX |
 				NETIF_F_HW_VLAN_CTAG_RX |
 				NETIF_F_HW_VLAN_CTAG_FILTER;
=20
 	bond_dev->hw_features &=3D ~(NETIF_F_ALL_CSUM & ~NETIF_F_HW_CSUM);
 	bond_dev->hw_features |=3D NETIF_F_GSO_UDP_TUNNEL;
 	bond_dev->features |=3D bond_dev->hw_features;
+	bond_dev->features |=3D NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX=
;
 }
=20
 /*
diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 7c06df557e37..3c33462cdc7c 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -157,7 +157,7 @@
=20
 #define FLEXCAN_MB_CODE_MASK		(0xf0ffffff)
=20
-#define FLEXCAN_TIMEOUT_US             (50)
+#define FLEXCAN_TIMEOUT_US		(250)
=20
 /*
  * FLEXCAN hardware feature flags
diff --git a/drivers/net/ethernet/dec/tulip/de4x5.c b/drivers/net/ethernet/=
dec/tulip/de4x5.c
index c05b66dfcc30..e401149b972c 100644
--- a/drivers/net/ethernet/dec/tulip/de4x5.c
+++ b/drivers/net/ethernet/dec/tulip/de4x5.c
@@ -2107,7 +2107,6 @@ static struct eisa_driver de4x5_eisa_driver =3D {
 		.remove  =3D de4x5_eisa_remove,
         }
 };
-MODULE_DEVICE_TABLE(eisa, de4x5_eisa_ids);
 #endif
=20
 #ifdef CONFIG_PCI
diff --git a/drivers/net/ethernet/emulex/benet/be_ethtool.c b/drivers/net/e=
thernet/emulex/benet/be_ethtool.c
index e2da4d20dd3d..9ac2b9f29730 100644
--- a/drivers/net/ethernet/emulex/benet/be_ethtool.c
+++ b/drivers/net/ethernet/emulex/benet/be_ethtool.c
@@ -779,7 +779,7 @@ static void be_self_test(struct net_device *netdev, str=
uct ethtool_test *test,
 			 u64 *data)
 {
 	struct be_adapter *adapter =3D netdev_priv(netdev);
-	int status;
+	int status, cnt;
 	u8 link_status =3D 0;
=20
 	if (adapter->function_caps & BE_FUNCTION_CAPS_SUPER_NIC) {
@@ -790,6 +790,9 @@ static void be_self_test(struct net_device *netdev, str=
uct ethtool_test *test,
=20
 	memset(data, 0, sizeof(u64) * ETHTOOL_TESTS_NUM);
=20
+	/* check link status before offline tests */
+	link_status =3D netif_carrier_ok(netdev);
+
 	if (test->flags & ETH_TEST_FL_OFFLINE) {
 		if (be_loopback_test(adapter, BE_MAC_LOOPBACK, &data[0]) !=3D 0)
 			test->flags |=3D ETH_TEST_FL_FAILED;
@@ -810,13 +813,26 @@ static void be_self_test(struct net_device *netdev, s=
truct ethtool_test *test,
 		test->flags |=3D ETH_TEST_FL_FAILED;
 	}
=20
-	status =3D be_cmd_link_status_query(adapter, NULL, &link_status, 0);
-	if (status) {
-		test->flags |=3D ETH_TEST_FL_FAILED;
-		data[4] =3D -1;
-	} else if (!link_status) {
+	/* link status was down prior to test */
+	if (!link_status) {
 		test->flags |=3D ETH_TEST_FL_FAILED;
 		data[4] =3D 1;
+		return;
+	}
+
+	for (cnt =3D 10; cnt; cnt--) {
+		status =3D be_cmd_link_status_query(adapter, NULL, &link_status,
+						  0);
+		if (status) {
+			test->flags |=3D ETH_TEST_FL_FAILED;
+			data[4] =3D -1;
+			break;
+		}
+
+		if (link_status)
+			break;
+
+		msleep_interruptible(500);
 	}
 }
=20
@@ -962,7 +978,7 @@ static int be_get_rxnfc(struct net_device *netdev, stru=
ct ethtool_rxnfc *cmd,
 		cmd->data =3D be_get_rss_hash_opts(adapter, cmd->flow_type);
 		break;
 	case ETHTOOL_GRXRINGS:
-		cmd->data =3D adapter->num_rx_qs - 1;
+		cmd->data =3D adapter->num_rx_qs;
 		break;
 	default:
 		return -EINVAL;
diff --git a/drivers/net/ethernet/mellanox/mlx4/mcg.c b/drivers/net/etherne=
t/mellanox/mlx4/mcg.c
index 1e459a59dc72..21d6e4420d44 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mcg.c
+++ b/drivers/net/ethernet/mellanox/mlx4/mcg.c
@@ -1329,7 +1329,7 @@ int mlx4_flow_steer_promisc_add(struct mlx4_dev *dev,=
 u8 port,
 	rule.port =3D port;
 	rule.qpn =3D qpn;
 	INIT_LIST_HEAD(&rule.list);
-	mlx4_err(dev, "going promisc on %x\n", port);
+	mlx4_info(dev, "going promisc on %x\n", port);
=20
 	return  mlx4_flow_attach(dev, &rule, regid_p);
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/ne=
t/ethernet/stmicro/stmmac/stmmac_mdio.c
index a5b1e1b776fe..45dcffb88773 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -159,7 +159,8 @@ int stmmac_mdio_reset(struct mii_bus *bus)
 		reset_gpio =3D data->reset_gpio;
 		active_low =3D data->active_low;
=20
-		if (!gpio_request(reset_gpio, "mdio-reset")) {
+		if (!devm_gpio_request(priv->device, reset_gpio,
+				      "mdio-reset")) {
 			gpio_direction_output(reset_gpio, active_low ? 1 : 0);
 			udelay(data->delays[0]);
 			gpio_set_value(reset_gpio, active_low ? 0 : 1);
diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index 0f2b2123d523..8f85dc9eeacb 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -563,8 +563,6 @@ ccio_io_pdir_entry(u64 *pdir_ptr, space_t sid, unsigned=
 long vba,
 	/* We currently only support kernel addresses */
 	BUG_ON(sid !=3D KERNEL_SPACE);
=20
-	mtsp(sid,1);
-
 	/*
 	** WORD 1 - low order word
 	** "hints" parm includes the VALID bit!
@@ -595,7 +593,7 @@ ccio_io_pdir_entry(u64 *pdir_ptr, space_t sid, unsigned=
 long vba,
 	** Grab virtual index [0:11]
 	** Deposit virt_idx bits into I/O PDIR word
 	*/
-	asm volatile ("lci %%r0(%%sr1, %1), %0" : "=3Dr" (ci) : "r" (vba));
+	asm volatile ("lci %%r0(%1), %0" : "=3Dr" (ci) : "r" (vba));
 	asm volatile ("extru %1,19,12,%0" : "+r" (ci) : "r" (ci));
 	asm volatile ("depw  %1,15,12,%0" : "+r" (pa) : "r" (ci));
=20
diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index ad21a240f644..fe83884cc434 100644
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -573,8 +573,7 @@ sba_io_pdir_entry(u64 *pdir_ptr, space_t sid, unsigned =
long vba,
 	pa =3D virt_to_phys(vba);
 	pa &=3D IOVP_MASK;
=20
-	mtsp(sid,1);
-	asm("lci 0(%%sr1, %1), %0" : "=3Dr" (ci) : "r" (vba));
+	asm("lci 0(%1), %0" : "=3Dr" (ci) : "r" (vba));
 	pa |=3D (ci >> PAGE_SHIFT) & 0xff;  /* move CI (8 bits) into lowest byte =
*/
=20
 	pa |=3D SBA_PDIR_VALID_BIT;	/* set "valid" bit */
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_mai=
n.c
index 7d589cebfc7f..506a6976ad69 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1956,7 +1956,7 @@ static void qeth_bridgeport_an_set_cb(void *priv,
=20
 	l2entry =3D (struct qdio_brinfo_entry_l2 *)entry;
 	code =3D IPA_ADDR_CHANGE_CODE_MACADDR;
-	if (l2entry->addr_lnid.lnid)
+	if (l2entry->addr_lnid.lnid < VLAN_N_VID)
 		code |=3D IPA_ADDR_CHANGE_CODE_VLANID;
 	qeth_bridge_emit_host_event(card, anev_reg_unreg, code,
 		(struct net_if_token *)&l2entry->nit,
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index cfe2a3b2d3b2..25e35261987b 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -160,6 +160,7 @@ extern const struct attribute_group *zfcp_port_attr_gro=
ups[];
 extern struct mutex zfcp_sysfs_port_units_mutex;
 extern struct device_attribute *zfcp_sysfs_sdev_attrs[];
 extern struct device_attribute *zfcp_sysfs_shost_attrs[];
+bool zfcp_sysfs_port_is_removing(const struct zfcp_port *const port);
=20
 /* zfcp_unit.c */
 extern int zfcp_unit_add(struct zfcp_port *, u64);
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 9e9f0ad00bef..f9dbbd0bca70 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -145,6 +145,15 @@ static int zfcp_scsi_slave_alloc(struct scsi_device *s=
dev)
=20
 	zfcp_sdev->erp_action.port =3D port;
=20
+	mutex_lock(&zfcp_sysfs_port_units_mutex);
+	if (zfcp_sysfs_port_is_removing(port)) {
+		/* port is already gone */
+		mutex_unlock(&zfcp_sysfs_port_units_mutex);
+		put_device(&port->dev); /* undo zfcp_get_port_by_wwpn() */
+		return -ENXIO;
+	}
+	mutex_unlock(&zfcp_sysfs_port_units_mutex);
+
 	unit =3D zfcp_unit_find(port, zfcp_scsi_dev_lun(sdev));
 	if (unit)
 		put_device(&unit->dev);
diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.=
c
index 672b57219e11..091dd40ef165 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -235,6 +235,53 @@ static ZFCP_DEV_ATTR(adapter, port_rescan, S_IWUSR, NU=
LL,
=20
 DEFINE_MUTEX(zfcp_sysfs_port_units_mutex);
=20
+static void zfcp_sysfs_port_set_removing(struct zfcp_port *const port)
+{
+	lockdep_assert_held(&zfcp_sysfs_port_units_mutex);
+	atomic_set(&port->units, -1);
+}
+
+bool zfcp_sysfs_port_is_removing(const struct zfcp_port *const port)
+{
+	lockdep_assert_held(&zfcp_sysfs_port_units_mutex);
+	return atomic_read(&port->units) =3D=3D -1;
+}
+
+static bool zfcp_sysfs_port_in_use(struct zfcp_port *const port)
+{
+	struct zfcp_adapter *const adapter =3D port->adapter;
+	unsigned long flags;
+	struct scsi_device *sdev;
+	bool in_use =3D true;
+
+	mutex_lock(&zfcp_sysfs_port_units_mutex);
+	if (atomic_read(&port->units) > 0)
+		goto unlock_port_units_mutex; /* zfcp_unit(s) under port */
+
+	spin_lock_irqsave(adapter->scsi_host->host_lock, flags);
+	__shost_for_each_device(sdev, adapter->scsi_host) {
+		const struct zfcp_scsi_dev *zsdev =3D sdev_to_zfcp(sdev);
+
+		if (sdev->sdev_state =3D=3D SDEV_DEL ||
+		    sdev->sdev_state =3D=3D SDEV_CANCEL)
+			continue;
+		if (zsdev->port !=3D port)
+			continue;
+		/* alive scsi_device under port of interest */
+		goto unlock_host_lock;
+	}
+
+	/* port is about to be removed, so no more unit_add or slave_alloc */
+	zfcp_sysfs_port_set_removing(port);
+	in_use =3D false;
+
+unlock_host_lock:
+	spin_unlock_irqrestore(adapter->scsi_host->host_lock, flags);
+unlock_port_units_mutex:
+	mutex_unlock(&zfcp_sysfs_port_units_mutex);
+	return in_use;
+}
+
 static ssize_t zfcp_sysfs_port_remove_store(struct device *dev,
 					    struct device_attribute *attr,
 					    const char *buf, size_t count)
@@ -257,15 +304,11 @@ static ssize_t zfcp_sysfs_port_remove_store(struct de=
vice *dev,
 	else
 		retval =3D 0;
=20
-	mutex_lock(&zfcp_sysfs_port_units_mutex);
-	if (atomic_read(&port->units) > 0) {
+	if (zfcp_sysfs_port_in_use(port)) {
 		retval =3D -EBUSY;
-		mutex_unlock(&zfcp_sysfs_port_units_mutex);
+		put_device(&port->dev); /* undo zfcp_get_port_by_wwpn() */
 		goto out;
 	}
-	/* port is about to be removed, so no more unit_add */
-	atomic_set(&port->units, -1);
-	mutex_unlock(&zfcp_sysfs_port_units_mutex);
=20
 	write_lock_irq(&adapter->port_list_lock);
 	list_del(&port->list);
diff --git a/drivers/s390/scsi/zfcp_unit.c b/drivers/s390/scsi/zfcp_unit.c
index 39f5446f7216..3f5477969189 100644
--- a/drivers/s390/scsi/zfcp_unit.c
+++ b/drivers/s390/scsi/zfcp_unit.c
@@ -122,7 +122,7 @@ int zfcp_unit_add(struct zfcp_port *port, u64 fcp_lun)
 	int retval =3D 0;
=20
 	mutex_lock(&zfcp_sysfs_port_units_mutex);
-	if (atomic_read(&port->units) =3D=3D -1) {
+	if (zfcp_sysfs_port_is_removing(port)) {
 		/* port is already gone */
 		retval =3D -ENODEV;
 		goto out;
@@ -166,8 +166,14 @@ int zfcp_unit_add(struct zfcp_port *port, u64 fcp_lun)
 	write_lock_irq(&port->unit_list_lock);
 	list_add_tail(&unit->list, &port->unit_list);
 	write_unlock_irq(&port->unit_list_lock);
+	/*
+	 * lock order: shost->scan_mutex before zfcp_sysfs_port_units_mutex
+	 * due to      zfcp_unit_scsi_scan() =3D> zfcp_scsi_slave_alloc()
+	 */
+	mutex_unlock(&zfcp_sysfs_port_units_mutex);
=20
 	zfcp_unit_scsi_scan(unit);
+	return retval;
=20
 out:
 	mutex_unlock(&zfcp_sysfs_port_units_mutex);
diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_=
hwi.c
index 512aed3ae4f1..254228dd4f30 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -828,7 +828,7 @@ static void bnx2fc_process_unsol_compl(struct bnx2fc_rp=
ort *tgt, u16 wqe)
 			((u64)err_entry->data.err_warn_bitmap_hi << 32) |
 			(u64)err_entry->data.err_warn_bitmap_lo;
 		for (i =3D 0; i < BNX2FC_NUM_ERR_BITS; i++) {
-			if (err_warn_bit_map & (u64) (1 << i)) {
+			if (err_warn_bit_map & ((u64)1 << i)) {
 				err_warn =3D i;
 				break;
 			}
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-plt=
frm.c
index 5e4623225422..c38c8c2680a0 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -150,22 +150,19 @@ static int ufshcd_pltfrm_probe(struct platform_device=
 *pdev)
 		goto out;
 	}
=20
-	pm_runtime_set_active(&pdev->dev);
-	pm_runtime_enable(&pdev->dev);
-
 	err =3D ufshcd_init(dev, &hba, mmio_base, irq);
 	if (err) {
 		dev_err(dev, "Intialization failed\n");
-		goto out_disable_rpm;
+		goto out;
 	}
=20
 	platform_set_drvdata(pdev, hba);
=20
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+
 	return 0;
=20
-out_disable_rpm:
-	pm_runtime_disable(&pdev->dev);
-	pm_runtime_set_suspended(&pdev->dev);
 out:
 	return err;
 }
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index c88e1468aad7..dfa4e1752dea 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -754,6 +754,7 @@ static int pvscsi_queue_lck(struct scsi_cmnd *cmd, void=
 (*done)(struct scsi_cmnd
 	struct pvscsi_adapter *adapter =3D shost_priv(host);
 	struct pvscsi_ctx *ctx;
 	unsigned long flags;
+	unsigned char op;
=20
 	spin_lock_irqsave(&adapter->hw_lock, flags);
=20
@@ -766,13 +767,14 @@ static int pvscsi_queue_lck(struct scsi_cmnd *cmd, vo=
id (*done)(struct scsi_cmnd
 	}
=20
 	cmd->scsi_done =3D done;
+	op =3D cmd->cmnd[0];
=20
 	dev_dbg(&cmd->device->sdev_gendev,
-		"queued cmd %p, ctx %p, op=3D%x\n", cmd, ctx, cmd->cmnd[0]);
+		"queued cmd %p, ctx %p, op=3D%x\n", cmd, ctx, op);
=20
 	spin_unlock_irqrestore(&adapter->hw_lock, flags);
=20
-	pvscsi_kick_io(adapter, cmd->cmnd[0]);
+	pvscsi_kick_io(adapter, op);
=20
 	return 0;
 }
diff --git a/drivers/spi/spi-bitbang.c b/drivers/spi/spi-bitbang.c
index fecdda270c5d..40cfaa84590b 100644
--- a/drivers/spi/spi-bitbang.c
+++ b/drivers/spi/spi-bitbang.c
@@ -462,7 +462,7 @@ int spi_bitbang_start(struct spi_bitbang *bitbang)
 	if (ret)
 		spi_master_put(master);
=20
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(spi_bitbang_start);
=20
diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_=
dev.c
index c9183c960a06..592659894f94 100644
--- a/drivers/staging/usbip/stub_dev.c
+++ b/drivers/staging/usbip/stub_dev.c
@@ -342,9 +342,17 @@ static int stub_probe(struct usb_device *udev)
 	const char *udev_busid =3D dev_name(&udev->dev);
 	struct bus_id_priv *busid_priv;
 	int rc =3D 0;
+	char save_status;
=20
 	dev_dbg(&udev->dev, "Enter probe\n");
=20
+	/* Not sure if this is our device. Allocate here to avoid
+	 * calling alloc while holding busid_table lock.
+	 */
+	sdev =3D stub_device_alloc(udev);
+	if (!sdev)
+		return -ENOMEM;
+
 	/* check we should claim or not by busid_table */
 	busid_priv =3D get_busid_priv(udev_busid);
 	if (!busid_priv || (busid_priv->status =3D=3D STUB_BUSID_REMOV) ||
@@ -359,6 +367,9 @@ static int stub_probe(struct usb_device *udev)
 		 * See driver_probe_device() in driver/base/dd.c
 		 */
 		rc =3D -ENODEV;
+		if (!busid_priv)
+			goto sdev_free;
+
 		goto call_put_busid_priv;
 	}
=20
@@ -378,12 +389,6 @@ static int stub_probe(struct usb_device *udev)
 		goto call_put_busid_priv;
 	}
=20
-	/* ok, this is my device */
-	sdev =3D stub_device_alloc(udev);
-	if (!sdev) {
-		rc =3D -ENOMEM;
-		goto call_put_busid_priv;
-	}
=20
 	dev_info(&udev->dev,
 		"usbip-host: register new device (bus %u dev %u)\n",
@@ -393,9 +398,16 @@ static int stub_probe(struct usb_device *udev)
=20
 	/* set private data to usb_device */
 	dev_set_drvdata(&udev->dev, sdev);
+
 	busid_priv->sdev =3D sdev;
 	busid_priv->udev =3D udev;
=20
+	save_status =3D busid_priv->status;
+	busid_priv->status =3D STUB_BUSID_ALLOC;
+
+	/* release the busid_lock */
+	put_busid_priv(busid_priv);
+
 	/*
 	 * Claim this hub port.
 	 * It doesn't matter what value we pass as owner
@@ -413,10 +425,8 @@ static int stub_probe(struct usb_device *udev)
 		dev_err(&udev->dev, "stub_add_files for %s\n", udev_busid);
 		goto err_files;
 	}
-	busid_priv->status =3D STUB_BUSID_ALLOC;
=20
-	rc =3D 0;
-	goto call_put_busid_priv;
+	return 0;
=20
 err_files:
 	usb_hub_release_port(udev->parent, udev->portnum,
@@ -426,23 +436,30 @@ static int stub_probe(struct usb_device *udev)
 	usb_put_dev(udev);
 	kthread_stop_put(sdev->ud.eh);
=20
+	/* we already have busid_priv, just lock busid_lock */
+	spin_lock(&busid_priv->busid_lock);
 	busid_priv->sdev =3D NULL;
-	stub_device_free(sdev);
+	busid_priv->status =3D save_status;
+	spin_unlock(&busid_priv->busid_lock);
+	/* lock is released - go to free */
+	goto sdev_free;
=20
 call_put_busid_priv:
+	/* release the busid_lock */
 	put_busid_priv(busid_priv);
+
+sdev_free:
+	stub_device_free(sdev);
+
 	return rc;
 }
=20
 static void shutdown_busid(struct bus_id_priv *busid_priv)
 {
-	if (busid_priv->sdev && !busid_priv->shutdown_busid) {
-		busid_priv->shutdown_busid =3D 1;
-		usbip_event_add(&busid_priv->sdev->ud, SDEV_EVENT_REMOVED);
+	usbip_event_add(&busid_priv->sdev->ud, SDEV_EVENT_REMOVED);
=20
-		/* wait for the stop of the event handler */
-		usbip_stop_eh(&busid_priv->sdev->ud);
-	}
+	/* wait for the stop of the event handler */
+	usbip_stop_eh(&busid_priv->sdev->ud);
 }
=20
 /*
@@ -469,11 +486,16 @@ static void stub_disconnect(struct usb_device *udev)
 	/* get stub_device */
 	if (!sdev) {
 		dev_err(&udev->dev, "could not get device");
-		goto call_put_busid_priv;
+		/* release busid_lock */
+		put_busid_priv(busid_priv);
+		return;
 	}
=20
 	dev_set_drvdata(&udev->dev, NULL);
=20
+	/* release busid_lock before call to remove device files */
+	put_busid_priv(busid_priv);
+
 	/*
 	 * NOTE: rx/tx threads are invoked for each usb_device.
 	 */
@@ -484,27 +506,36 @@ static void stub_disconnect(struct usb_device *udev)
 				  (struct usb_dev_state *) udev);
 	if (rc) {
 		dev_dbg(&udev->dev, "unable to release port\n");
-		goto call_put_busid_priv;
+		return;
 	}
=20
 	/* If usb reset is called from event handler */
 	if (busid_priv->sdev->ud.eh =3D=3D current)
-		goto call_put_busid_priv;
+		return;
+
+	/* we already have busid_priv, just lock busid_lock */
+	spin_lock(&busid_priv->busid_lock);
+	if (!busid_priv->shutdown_busid)
+		busid_priv->shutdown_busid =3D 1;
+	/* release busid_lock */
+	spin_unlock(&busid_priv->busid_lock);
=20
 	/* shutdown the current connection */
 	shutdown_busid(busid_priv);
=20
 	usb_put_dev(sdev->udev);
=20
+	/* we already have busid_priv, just lock busid_lock */
+	spin_lock(&busid_priv->busid_lock);
 	/* free sdev */
 	busid_priv->sdev =3D NULL;
 	stub_device_free(sdev);
=20
 	if (busid_priv->status =3D=3D STUB_BUSID_ALLOC)
 		busid_priv->status =3D STUB_BUSID_ADDED;
-
-call_put_busid_priv:
-	put_busid_priv(busid_priv);
+	/* release busid_lock */
+	spin_unlock(&busid_priv->busid_lock);
+	return;
 }
=20
 #ifdef CONFIG_PM
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_co=
re_iblock.c
index 7ee927d9c3ac..f9d811a9146c 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -490,7 +490,7 @@ iblock_execute_write_same(struct se_cmd *cmd)
=20
 		/* Always in 512 byte units for Linux/Block */
 		block_lba +=3D sg->length >> IBLOCK_LBA_SHIFT;
-		sectors -=3D 1;
+		sectors -=3D sg->length >> IBLOCK_LBA_SHIFT;
 	}
=20
 	iblock_submit_bios(&list, WRITE);
diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index 8ccab7cf437c..df326936982f 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -568,7 +568,7 @@ static int max310x_set_ref_clk(struct max310x_port *s, =
unsigned long freq,
 	}
=20
 	/* Configure clock source */
-	clksrc =3D xtal ? MAX310X_CLKSRC_CRYST_BIT : MAX310X_CLKSRC_EXTCLK_BIT;
+	clksrc =3D MAX310X_CLKSRC_EXTCLK_BIT | (xtal ? MAX310X_CLKSRC_CRYST_BIT :=
 0);
=20
 	/* Configure PLL */
 	if (pllcfg) {
diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index 0dc1d1ac4a9a..dd77c3aee947 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -1600,6 +1600,13 @@ static void sci_request_dma(struct uart_port *port)
=20
 	dev_dbg(port->dev, "%s: port %d\n", __func__, port->line);
=20
+	/*
+	 * DMA on console may interfere with Kernel log messages which use
+	 * plain putchar(). So, simply don't use it with a console.
+	 */
+	if (uart_console(port))
+		return;
+
 	if (s->cfg->dma_slave_tx <=3D 0 || s->cfg->dma_slave_rx <=3D 0)
 		return;
=20
diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
index cee00dc829b6..52dfe4936a0f 100644
--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -897,8 +897,8 @@ int usb_get_bos_descriptor(struct usb_device *dev)
=20
 	/* Get BOS descriptor */
 	ret =3D usb_get_descriptor(dev, USB_DT_BOS, 0, bos, USB_DT_BOS_SIZE);
-	if (ret < USB_DT_BOS_SIZE) {
-		dev_err(ddev, "unable to get BOS descriptor\n");
+	if (ret < USB_DT_BOS_SIZE || bos->bLength < USB_DT_BOS_SIZE) {
+		dev_err(ddev, "unable to get BOS descriptor or descriptor too short\n");
 		if (ret >=3D 0)
 			ret =3D -ENOMSG;
 		kfree(bos);
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index dd480d33fdbc..33772a954df6 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -64,9 +64,15 @@ static const struct usb_device_id usb_quirk_list[] =3D {
 	/* Microsoft LifeCam-VX700 v2.0 */
 	{ USB_DEVICE(0x045e, 0x0770), .driver_info =3D USB_QUIRK_RESET_RESUME },
=20
+	/* Microsoft Surface Dock Ethernet (RTL8153 GigE) */
+	{ USB_DEVICE(0x045e, 0x07c6), .driver_info =3D USB_QUIRK_NO_LPM },
+
 	/* Cherry Stream G230 2.0 (G85-231) and 3.0 (G85-232) */
 	{ USB_DEVICE(0x046a, 0x0023), .driver_info =3D USB_QUIRK_RESET_RESUME },
=20
+	/* Logitech HD Webcam C270 */
+	{ USB_DEVICE(0x046d, 0x0825), .driver_info =3D USB_QUIRK_RESET_RESUME },
+
 	/* Logitech HD Pro Webcams C920, C920-C, C925e and C930e */
 	{ USB_DEVICE(0x046d, 0x082d), .driver_info =3D USB_QUIRK_DELAY_INIT },
 	{ USB_DEVICE(0x046d, 0x0841), .driver_info =3D USB_QUIRK_DELAY_INIT },
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 40f8ff381c44..c8abf2cfe088 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4178,7 +4178,6 @@ int xhci_set_usb2_hardware_lpm(struct usb_hcd *hcd,
 	pm_addr =3D port_array[port_num] + PORTPMSC;
 	pm_val =3D readl(pm_addr);
 	hlpm_addr =3D port_array[port_num] + PORTHLPMC;
-	field =3D le32_to_cpu(udev->bos->ext_cap->bmAttributes);
=20
 	xhci_dbg(xhci, "%s port %d USB2 hardware LPM\n",
 			enable ? "enable" : "disable", port_num + 1);
@@ -4190,6 +4189,7 @@ int xhci_set_usb2_hardware_lpm(struct usb_hcd *hcd,
 			 * default one which works with mixed HIRD and BESL
 			 * systems. See XHCI_DEFAULT_BESL definition in xhci.h
 			 */
+			field =3D le32_to_cpu(udev->bos->ext_cap->bmAttributes);
 			if ((field & USB_BESL_SUPPORT) &&
 			    (field & USB_BESL_BASELINE_VALID))
 				hird =3D USB_GET_BESL_BASELINE(field);
diff --git a/drivers/usb/misc/rio500.c b/drivers/usb/misc/rio500.c
index 57c4632ddd0a..6e761fabffca 100644
--- a/drivers/usb/misc/rio500.c
+++ b/drivers/usb/misc/rio500.c
@@ -103,9 +103,22 @@ static int close_rio(struct inode *inode, struct file =
*file)
 {
 	struct rio_usb_data *rio =3D &rio_instance;
=20
-	rio->isopen =3D 0;
+	/* against disconnect() */
+	mutex_lock(&rio500_mutex);
+	mutex_lock(&(rio->lock));
=20
-	dev_info(&rio->rio_dev->dev, "Rio closed.\n");
+	rio->isopen =3D 0;
+	if (!rio->present) {
+		/* cleanup has been delayed */
+		kfree(rio->ibuf);
+		kfree(rio->obuf);
+		rio->ibuf =3D NULL;
+		rio->obuf =3D NULL;
+	} else {
+		dev_info(&rio->rio_dev->dev, "Rio closed.\n");
+	}
+	mutex_unlock(&(rio->lock));
+	mutex_unlock(&rio500_mutex);
 	return 0;
 }
=20
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index a2809d51a308..c31b21fe83e1 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -100,6 +100,7 @@ static const struct usb_device_id id_table[] =3D {
 	{ USB_DEVICE(SANWA_VENDOR_ID, SANWA_PRODUCT_ID) },
 	{ USB_DEVICE(ADLINK_VENDOR_ID, ADLINK_ND6530_PRODUCT_ID) },
 	{ USB_DEVICE(SMART_VENDOR_ID, SMART_PRODUCT_ID) },
+	{ USB_DEVICE(AT_VENDOR_ID, AT_VTKIT3_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
=20
diff --git a/drivers/usb/serial/pl2303.h b/drivers/usb/serial/pl2303.h
index c5f519a91177..ecc5042305ba 100644
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -158,3 +158,6 @@
 #define SMART_VENDOR_ID	0x0b8c
 #define SMART_PRODUCT_ID	0x2303
=20
+/* Allied Telesis VT-Kit3 */
+#define AT_VENDOR_ID		0x0caa
+#define AT_VTKIT3_PRODUCT_ID	0x3001
diff --git a/drivers/usb/storage/unusual_realtek.h b/drivers/usb/storage/un=
usual_realtek.h
index f5fc3271e19c..e2c5491a411b 100644
--- a/drivers/usb/storage/unusual_realtek.h
+++ b/drivers/usb/storage/unusual_realtek.h
@@ -28,6 +28,11 @@ UNUSUAL_DEV(0x0bda, 0x0138, 0x0000, 0x9999,
 		"USB Card Reader",
 		USB_SC_DEVICE, USB_PR_DEVICE, init_realtek_cr, 0),
=20
+UNUSUAL_DEV(0x0bda, 0x0153, 0x0000, 0x9999,
+		"Realtek",
+		"USB Card Reader",
+		USB_SC_DEVICE, USB_PR_DEVICE, init_realtek_cr, 0),
+
 UNUSUAL_DEV(0x0bda, 0x0158, 0x0000, 0x9999,
 		"Realtek",
 		"USB Card Reader",
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 15934d342b5f..8598807181a4 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1888,6 +1888,18 @@ int btrfs_sync_file(struct file *file, loff_t start,=
 loff_t end, int datasync)
 	bool full_sync =3D 0;
 	u64 len;
=20
+	/*
+	 * If the inode needs a full sync, make sure we use a full range to
+	 * avoid log tree corruption, due to hole detection racing with ordered
+	 * extent completion for adjacent ranges, and assertion failures during
+	 * hole detection.
+	 */
+	if (test_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
+		     &BTRFS_I(inode)->runtime_flags)) {
+		start =3D 0;
+		end =3D LLONG_MAX;
+	}
+
 	/*
 	 * The range length can be represented by u64, we have to do the typecast=
s
 	 * to avoid signed overflow if it's [0, LLONG_MAX] eg. from fsync()
diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 20408c6b665a..c22ce1a337be 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -764,16 +764,23 @@ static void __reada_start_machine(struct btrfs_fs_inf=
o *fs_info)
 	u64 total =3D 0;
 	int i;
=20
+again:
 	do {
 		enqueued =3D 0;
+		mutex_lock(&fs_devices->device_list_mutex);
 		list_for_each_entry(device, &fs_devices->devices, dev_list) {
 			if (atomic_read(&device->reada_in_flight) <
 			    MAX_IN_FLIGHT)
 				enqueued +=3D reada_start_machine_dev(fs_info,
 								    device);
 		}
+		mutex_unlock(&fs_devices->device_list_mutex);
 		total +=3D enqueued;
 	} while (enqueued && total < 10000);
+	if (fs_devices->seed) {
+		fs_devices =3D fs_devices->seed;
+		goto again;
+	}
=20
 	if (enqueued =3D=3D 0)
 		return;
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 048c0e09f57c..1c43254b980e 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -260,6 +260,7 @@ cifs_alloc_inode(struct super_block *sb)
 	cifs_inode->uniqueid =3D 0;
 	cifs_inode->createtime =3D 0;
 	cifs_inode->epoch =3D 0;
+	spin_lock_init(&cifs_inode->open_file_lock);
 #ifdef CONFIG_CIFS_SMB2
 	generate_random_uuid(cifs_inode->lease_key);
 #endif
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index ff85c3129e9d..a13450937bce 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1116,6 +1116,7 @@ struct cifsInodeInfo {
 	struct rw_semaphore lock_sem;	/* protect the fields above */
 	/* BB add in lists for dirty pages i.e. write caching info for oplock */
 	struct list_head openFileList;
+	spinlock_t	open_file_lock;	/* protects openFileList */
 	__u32 cifsAttrs; /* e.g. DOS archive bit, sparse, compressed, system */
 	unsigned int oplock;		/* oplock/lease level we have */
 	unsigned int epoch;		/* used to track lease state changes */
@@ -1485,10 +1486,14 @@ require use of the stronger protocol */
  *  tcp_ses_lock protects:
  *	list operations on tcp and SMB session lists
  *  tcon->open_file_lock protects the list of open files hanging off the t=
con
+ *  inode->open_file_lock protects the openFileList hanging off the inode
  *  cfile->file_info_lock protects counters and fields in cifs file struct
  *  f_owner.lock protects certain per file struct operations
  *  mapping->page_lock protects certain per page operations
  *
+ *  Note that the cifs_tcon.open_file_lock should be taken before
+ *  not after the cifsInodeInfo.open_file_lock
+ *
  *  Semaphores
  *  ----------
  *  sesSem     operations on smb session
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 9b3d28b79329..0ff4c7b49c7b 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -337,10 +337,12 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file *=
file,
 	list_add(&cfile->tlist, &tcon->openFileList);
=20
 	/* if readable file instance put first in list*/
+	spin_lock(&cinode->open_file_lock);
 	if (file->f_mode & FMODE_READ)
 		list_add(&cfile->flist, &cinode->openFileList);
 	else
 		list_add_tail(&cfile->flist, &cinode->openFileList);
+	spin_unlock(&cinode->open_file_lock);
 	spin_unlock(&tcon->open_file_lock);
=20
 	if (fid->purge_cache)
@@ -412,7 +414,9 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_file, =
bool wait_oplock_handler)
 	cifs_add_pending_open_locked(&fid, cifs_file->tlink, &open);
=20
 	/* remove it from the lists */
+	spin_lock(&cifsi->open_file_lock);
 	list_del(&cifs_file->flist);
+	spin_unlock(&cifsi->open_file_lock);
 	list_del(&cifs_file->tlist);
=20
 	if (list_empty(&cifsi->openFileList)) {
@@ -1850,10 +1854,10 @@ struct cifsFileInfo *find_writable_file(struct cifs=
InodeInfo *cifs_inode,
 		if (!rc)
 			return inv_file;
 		else {
-			spin_lock(&tcon->open_file_lock);
+			spin_lock(&cifs_inode->open_file_lock);
 			list_move_tail(&inv_file->flist,
 					&cifs_inode->openFileList);
-			spin_unlock(&tcon->open_file_lock);
+			spin_unlock(&cifs_inode->open_file_lock);
 			cifsFileInfo_put(inv_file);
 			++refind;
 			inv_file =3D NULL;
@@ -2744,7 +2748,9 @@ cifs_read_allocate_pages(struct cifs_readdata *rdata,=
 unsigned int nr_pages)
 	}
=20
 	if (rc) {
-		for (i =3D 0; i < nr_pages; i++) {
+		unsigned int nr_page_failed =3D i;
+
+		for (i =3D 0; i < nr_page_failed; i++) {
 			put_page(rdata->pages[i]);
 			rdata->pages[i] =3D NULL;
 		}
diff --git a/fs/cifs/smb2maperror.c b/fs/cifs/smb2maperror.c
index c28e3b946e6a..2edf9d0755ef 100644
--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -455,7 +455,7 @@ static const struct status_to_posix_error smb2_error_ma=
p_table[] =3D {
 	{STATUS_FILE_INVALID, -EIO, "STATUS_FILE_INVALID"},
 	{STATUS_ALLOTTED_SPACE_EXCEEDED, -EIO,
 	"STATUS_ALLOTTED_SPACE_EXCEEDED"},
-	{STATUS_INSUFFICIENT_RESOURCES, -EREMOTEIO,
+	{STATUS_INSUFFICIENT_RESOURCES, -EAGAIN,
 				"STATUS_INSUFFICIENT_RESOURCES"},
 	{STATUS_DFS_EXIT_PATH_FOUND, -EIO, "STATUS_DFS_EXIT_PATH_FOUND"},
 	{STATUS_DEVICE_DATA_ERROR, -EIO, "STATUS_DEVICE_DATA_ERROR"},
diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 668dcabc5695..0166b55bbe76 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -58,15 +58,13 @@ static void configfs_d_iput(struct dentry * dentry,
 	if (sd) {
 		/* Coordinate with configfs_readdir */
 		spin_lock(&configfs_dirent_lock);
-		/* Coordinate with configfs_attach_attr where will increase
-		 * sd->s_count and update sd->s_dentry to new allocated one.
-		 * Only set sd->dentry to null when this dentry is the only
-		 * sd owner.
-		 * If not do so, configfs_d_iput may run just after
-		 * configfs_attach_attr and set sd->s_dentry to null
-		 * even it's still in use.
+		/*
+		 * Set sd->s_dentry to null only when this dentry is the one
+		 * that is going to be killed.  Otherwise configfs_d_iput may
+		 * run just after configfs_attach_attr and set sd->s_dentry to
+		 * NULL even it's still in use.
 		 */
-		if (atomic_read(&sd->s_count) <=3D 2)
+		if (sd->s_dentry =3D=3D dentry)
 			sd->s_dentry =3D NULL;
=20
 		spin_unlock(&configfs_dirent_lock);
diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index 92edcfc23c1c..8fc6e8016433 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -310,6 +310,18 @@ int ocfs2_dentry_attach_lock(struct dentry *dentry,
=20
 out_attach:
 	spin_lock(&dentry_attach_lock);
+	if (unlikely(dentry->d_fsdata && !alias)) {
+		/* d_fsdata is set by a racing thread which is doing
+		 * the same thing as this thread is doing. Leave the racing
+		 * thread going ahead and we return here.
+		 */
+		spin_unlock(&dentry_attach_lock);
+		iput(dl->dl_inode);
+		ocfs2_lock_res_free(&dl->dl_lockres);
+		kfree(dl);
+		return 0;
+	}
+
 	dentry->d_fsdata =3D dl;
 	dl->dl_count++;
 	spin_unlock(&dentry_attach_lock);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f3e261e82a94..754a7cb0699e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2439,6 +2439,10 @@ static inline void mmdrop(struct mm_struct * mm)
  * followed by taking the mmap_sem for writing before modifying the
  * vmas or anything the coredump pretends not to change from under it.
  *
+ * It also has to be called when mmgrab() is used in the context of
+ * the process, but then the mm_count refcount is transferred outside
+ * the context of the process to run down_write() on that pinned mm.
+ *
  * NOTE: find_extend_vma() called from GUP context is the only place
  * that can modify the "mm" (notably the vm_start/end) under mmap_sem
  * for reading and outside the context of the process, so it is also
diff --git a/kernel/cpu.c b/kernel/cpu.c
index ccfcd542efeb..0d3fa337bce8 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -804,6 +804,9 @@ static int __init mitigations_parse_cmdline(char *arg)
 		cpu_mitigations =3D CPU_MITIGATIONS_OFF;
 	else if (!strcmp(arg, "auto"))
 		cpu_mitigations =3D CPU_MITIGATIONS_AUTO;
+	else
+		pr_crit("Unsupported mitigations=3D%s, system may still be vulnerable\n"=
,
+			arg);
=20
 	return 0;
 }
diff --git a/kernel/cred.c b/kernel/cred.c
index e0573a43c7df..0e99e0ae681b 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -439,6 +439,15 @@ int commit_creds(struct cred *new)
 		if (task->mm)
 			set_dumpable(task->mm, suid_dumpable);
 		task->pdeath_signal =3D 0;
+		/*
+		 * If a task drops privileges and becomes nondumpable,
+		 * the dumpability change must become visible before
+		 * the credential change; otherwise, a __ptrace_may_access()
+		 * racing with this change may be able to attach to a task it
+		 * shouldn't be able to attach to (as if the task had dropped
+		 * privileges without becoming nondumpable).
+		 * Pairs with a read barrier in __ptrace_may_access().
+		 */
 		smp_wmb();
 	}
=20
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 3beed0ea98d9..1373a6307cc2 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3823,6 +3823,9 @@ static int perf_event_period(struct perf_event *event=
, u64 __user *arg)
 	if (perf_event_check_period(event, value))
 		return -EINVAL;
=20
+	if (!event->attr.freq && (value & (1ULL << 63)))
+		return -EINVAL;
+
 	task =3D ctx->task;
 	pe.value =3D value;
=20
@@ -4581,7 +4584,7 @@ static void perf_sample_regs_user(struct perf_regs_us=
er *regs_user,
 				  struct pt_regs *regs)
 {
 	if (!user_mode(regs)) {
-		if (current->mm)
+		if (!(current->flags & PF_KTHREAD))
 			regs =3D task_pt_regs(current);
 		else
 			regs =3D NULL;
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index fe88f61c9109..8496a2fb5cfd 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -47,14 +47,30 @@ static void perf_output_put_handle(struct perf_output_h=
andle *handle)
 	unsigned long head;
=20
 again:
+	/*
+	 * In order to avoid publishing a head value that goes backwards,
+	 * we must ensure the load of @rb->head happens after we've
+	 * incremented @rb->nest.
+	 *
+	 * Otherwise we can observe a @rb->head value before one published
+	 * by an IRQ/NMI happening between the load and the increment.
+	 */
+	barrier();
 	head =3D local_read(&rb->head);
=20
 	/*
-	 * IRQ/NMI can happen here, which means we can miss a head update.
+	 * IRQ/NMI can happen here and advance @rb->head, causing our
+	 * load above to be stale.
 	 */
=20
-	if (!local_dec_and_test(&rb->nest))
+	/*
+	 * If this isn't the outermost nesting, we don't have to update
+	 * @rb->user_page->data_head.
+	 */
+	if (local_read(&rb->nest) > 1) {
+		local_dec(&rb->nest);
 		goto out;
+	}
=20
 	/*
 	 * Since the mmap() consumer (userspace) can run on a different CPU:
@@ -86,9 +102,18 @@ static void perf_output_put_handle(struct perf_output_h=
andle *handle)
 	rb->user_page->data_head =3D head;
=20
 	/*
-	 * Now check if we missed an update -- rely on previous implied
-	 * compiler barriers to force a re-read.
+	 * We must publish the head before decrementing the nest count,
+	 * otherwise an IRQ/NMI can publish a more recent head value and our
+	 * write will (temporarily) publish a stale value.
+	 */
+	barrier();
+	local_set(&rb->nest, 0);
+
+	/*
+	 * Ensure we decrement @rb->nest before we validate the @rb->head.
+	 * Otherwise we cannot be sure we caught the 'last' nested update.
 	 */
+	barrier();
 	if (unlikely(head !=3D local_read(&rb->head))) {
 		local_inc(&rb->nest);
 		goto again;
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 22beef3e2160..bdfb57365e9e 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -324,6 +324,16 @@ static int __ptrace_may_access(struct task_struct *tas=
k, unsigned int mode)
 	return -EPERM;
 ok:
 	rcu_read_unlock();
+	/*
+	 * If a task drops privileges and becomes nondumpable (through a syscall
+	 * like setresuid()) while we are trying to access it, we must ensure
+	 * that the dumpability is read after the credentials; otherwise,
+	 * we may be able to attach to a task that we shouldn't be able to
+	 * attach to (as if the task had dropped privileges without becoming
+	 * nondumpable).
+	 * Pairs with a write barrier in commit_creds().
+	 */
+	smp_rmb();
 	mm =3D task->mm;
 	if (mm &&
 	    ((get_dumpable(mm) !=3D SUID_DUMP_USER) &&
@@ -711,6 +721,10 @@ static int ptrace_peek_siginfo(struct task_struct *chi=
ld,
 	if (arg.nr < 0)
 		return -EINVAL;
=20
+	/* Ensure arg.off fits in an unsigned long */
+	if (arg.off > ULONG_MAX)
+		return 0;
+
 	if (arg.flags & PTRACE_PEEKSIGINFO_SHARED)
 		pending =3D &child->signal->shared_pending;
 	else
@@ -718,18 +732,20 @@ static int ptrace_peek_siginfo(struct task_struct *ch=
ild,
=20
 	for (i =3D 0; i < arg.nr; ) {
 		siginfo_t info;
-		s32 off =3D arg.off + i;
+		unsigned long off =3D arg.off + i;
+		bool found =3D false;
=20
 		spin_lock_irq(&child->sighand->siglock);
 		list_for_each_entry(q, &pending->list, list) {
 			if (!off--) {
+				found =3D true;
 				copy_siginfo(&info, &q->info);
 				break;
 			}
 		}
 		spin_unlock_irq(&child->sighand->siglock);
=20
-		if (off >=3D 0) /* beyond the end of the list */
+		if (!found) /* beyond the end of the list */
 			break;
=20
 #ifdef CONFIG_COMPAT
diff --git a/kernel/signal.c b/kernel/signal.c
index f3d2701f37ef..6816d3ae6f46 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2277,6 +2277,8 @@ int get_signal(struct ksignal *ksig)
 	if (signal_group_exit(signal)) {
 		ksig->info.si_signo =3D signr =3D SIGKILL;
 		sigdelset(&current->pending.signal, SIGKILL);
+		trace_signal_deliver(SIGKILL, SEND_SIG_NOINFO,
+				&sighand->action[SIGKILL - 1]);
 		recalc_sigpending();
 		goto fatal;
 	}
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5a4d78fe4bb9..c1b53a5c491b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5102,11 +5102,13 @@ tracing_snapshot_write(struct file *filp, const cha=
r __user *ubuf, size_t cnt,
 			break;
 		}
 #endif
-		if (!tr->allocated_snapshot) {
+		if (tr->allocated_snapshot)
+			ret =3D resize_buffer_duplicate_size(&tr->max_buffer,
+					&tr->trace_buffer, iter->cpu_file);
+		else
 			ret =3D alloc_snapshot(tr);
-			if (ret < 0)
-				break;
-		}
+		if (ret < 0)
+			break;
 		local_irq_disable();
 		/* Now, we're going to swap */
 		if (iter->cpu_file =3D=3D RING_BUFFER_ALL_CPUS)
diff --git a/lib/mpi/mpi-pow.c b/lib/mpi/mpi-pow.c
index e24388a863a7..dc26594984ef 100644
--- a/lib/mpi/mpi-pow.c
+++ b/lib/mpi/mpi-pow.c
@@ -36,6 +36,7 @@
 int mpi_powm(MPI res, MPI base, MPI exp, MPI mod)
 {
 	mpi_ptr_t mp_marker =3D NULL, bp_marker =3D NULL, ep_marker =3D NULL;
+	struct karatsuba_ctx karactx =3D {};
 	mpi_ptr_t xp_marker =3D NULL;
 	mpi_ptr_t tspace =3D NULL;
 	mpi_ptr_t rp, ep, mp, bp;
@@ -163,13 +164,11 @@ int mpi_powm(MPI res, MPI base, MPI exp, MPI mod)
 		int c;
 		mpi_limb_t e;
 		mpi_limb_t carry_limb;
-		struct karatsuba_ctx karactx;
=20
 		xp =3D xp_marker =3D mpi_alloc_limb_space(2 * (msize + 1));
 		if (!xp)
 			goto enomem;
=20
-		memset(&karactx, 0, sizeof karactx);
 		negative_result =3D (ep[0] & 1) && base->sign;
=20
 		i =3D esize - 1;
@@ -293,8 +292,6 @@ int mpi_powm(MPI res, MPI base, MPI exp, MPI mod)
 		if (mod_shift_cnt)
 			mpihelp_rshift(rp, rp, rsize, mod_shift_cnt);
 		MPN_NORMALIZE(rp, rsize);
-
-		mpihelp_release_karatsuba_ctx(&karactx);
 	}
=20
 	if (negative_result && rsize) {
@@ -311,6 +308,7 @@ int mpi_powm(MPI res, MPI base, MPI exp, MPI mod)
 leave:
 	rc =3D 0;
 enomem:
+	mpihelp_release_karatsuba_ctx(&karactx);
 	if (assign_rp)
 		mpi_assign_limb_space(res, rp, size);
 	if (mp_marker)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 498110500479..129d537affd0 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2428,6 +2428,8 @@ static void collapse_huge_page(struct mm_struct *mm,
 	 * handled by the anon_vma lock + PG_lock.
 	 */
 	down_write(&mm->mmap_sem);
+	if (!mmget_still_valid(mm))
+		goto out;
 	if (unlikely(khugepaged_test_exit(mm)))
 		goto out;
=20
diff --git a/net/can/af_can.c b/net/can/af_can.c
index 9c72b6501665..a579dc17bb3e 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -114,6 +114,7 @@ EXPORT_SYMBOL(can_ioctl);
 static void can_sock_destruct(struct sock *sk)
 {
 	skb_queue_purge(&sk->sk_receive_queue);
+	skb_queue_purge(&sk->sk_error_queue);
 }
=20
 static const struct can_proto *can_get_proto(int protocol)
@@ -899,6 +900,8 @@ static struct notifier_block can_netdev_notifier __read=
_mostly =3D {
=20
 static __init int can_init(void)
 {
+	int err;
+
 	/* check for correct padding to be able to use the structs similarly */
 	BUILD_BUG_ON(offsetof(struct can_frame, can_dlc) !=3D
 		     offsetof(struct canfd_frame, len) ||
@@ -924,12 +927,29 @@ static __init int can_init(void)
 	can_init_proc();
=20
 	/* protocol register */
-	sock_register(&can_family_ops);
-	register_netdevice_notifier(&can_netdev_notifier);
+	err =3D sock_register(&can_family_ops);
+	if (err)
+		goto out_sock;
+	err =3D register_netdevice_notifier(&can_netdev_notifier);
+	if (err)
+		goto out_notifier;
+
 	dev_add_pack(&can_packet);
 	dev_add_pack(&canfd_packet);
=20
 	return 0;
+
+out_notifier:
+	sock_unregister(PF_CAN);
+out_sock:
+	kmem_cache_destroy(rcv_cache);
+
+	if (stats_timer)
+		del_timer_sync(&can_stattimer);
+
+	can_remove_proc();
+
+	return err;
 }
=20
 static __exit void can_exit(void)
diff --git a/net/core/dev.c b/net/core/dev.c
index 5fdda6aa5d1e..89c31f085ea2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4239,7 +4239,6 @@ static struct sk_buff *napi_frags_skb(struct napi_str=
uct *napi)
 	skb_reset_mac_header(skb);
 	skb_gro_reset_offset(skb);
=20
-	eth =3D skb_gro_header_fast(skb, 0);
 	if (unlikely(skb_gro_header_hard(skb, hlen))) {
 		eth =3D skb_gro_header_slow(skb, hlen, 0);
 		if (unlikely(!eth)) {
@@ -4247,6 +4246,7 @@ static struct sk_buff *napi_frags_skb(struct napi_str=
uct *napi)
 			return NULL;
 		}
 	} else {
+		eth =3D (const struct ethhdr *)skb->data;
 		gro_pull_from_frag0(skb, hlen);
 		NAPI_GRO_CB(skb)->frag0 +=3D hlen;
 		NAPI_GRO_CB(skb)->frag0_len -=3D hlen;
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index be085a7b48df..6678f3959eb2 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2649,6 +2649,7 @@ static void *neigh_get_idx_any(struct seq_file *seq, =
loff_t *pos)
 }
=20
 void *neigh_seq_start(struct seq_file *seq, loff_t *pos, struct neigh_tabl=
e *tbl, unsigned int neigh_seq_flags)
+	__acquires(tbl->lock)
 	__acquires(rcu_bh)
 {
 	struct neigh_seq_state *state =3D seq->private;
@@ -2659,6 +2660,7 @@ void *neigh_seq_start(struct seq_file *seq, loff_t *p=
os, struct neigh_table *tbl
=20
 	rcu_read_lock_bh();
 	state->nht =3D rcu_dereference_bh(tbl->nht);
+	read_lock(&tbl->lock);
=20
 	return *pos ? neigh_get_idx_any(seq, pos) : SEQ_START_TOKEN;
 }
@@ -2692,8 +2694,13 @@ void *neigh_seq_next(struct seq_file *seq, void *v, =
loff_t *pos)
 EXPORT_SYMBOL(neigh_seq_next);
=20
 void neigh_seq_stop(struct seq_file *seq, void *v)
+	__releases(tbl->lock)
 	__releases(rcu_bh)
 {
+	struct neigh_seq_state *state =3D seq->private;
+	struct neigh_table *tbl =3D state->tbl;
+
+	read_unlock(&tbl->lock);
 	rcu_read_unlock_bh();
 }
 EXPORT_SYMBOL(neigh_seq_stop);
diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index d585bc9109b4..b0d59f036da2 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -3055,7 +3055,13 @@ static int pktgen_wait_thread_run(struct pktgen_thre=
ad *t)
=20
 		if_unlock(t);
=20
+		/* note: 't' will still be around even after the unlock/lock
+		 * cycle because pktgen_thread threads are only cleared at
+		 * net exit
+		 */
+		mutex_unlock(&pktgen_thread_lock);
 		msleep_interruptible(100);
+		mutex_lock(&pktgen_thread_lock);
=20
 		if (signal_pending(current))
 			goto signal;
@@ -3072,6 +3078,10 @@ static int pktgen_wait_all_threads_run(struct pktgen=
_net *pn)
 	struct pktgen_thread *t;
 	int sig =3D 1;
=20
+	/* prevent from racing with rmmod */
+	if (!try_module_get(THIS_MODULE))
+		return sig;
+
 	mutex_lock(&pktgen_thread_lock);
=20
 	list_for_each_entry(t, &pn->pktgen_threads, th_list) {
@@ -3085,6 +3095,7 @@ static int pktgen_wait_all_threads_run(struct pktgen_=
net *pn)
 			t->control |=3D (T_STOP);
=20
 	mutex_unlock(&pktgen_thread_lock);
+	module_put(THIS_MODULE);
 	return sig;
 }
=20
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 680ce5f4fb65..1ea0cf8ac4f5 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -192,6 +192,17 @@ static void ip_ma_put(struct ip_mc_list *im)
 	     pmc !=3D NULL;					\
 	     pmc =3D rtnl_dereference(pmc->next_rcu))
=20
+static void ip_sf_list_clear_all(struct ip_sf_list *psf)
+{
+	struct ip_sf_list *next;
+
+	while (psf) {
+		next =3D psf->sf_next;
+		kfree(psf);
+		psf =3D next;
+	}
+}
+
 #ifdef CONFIG_IP_MULTICAST
=20
 /*
@@ -614,6 +625,13 @@ static void igmpv3_clear_zeros(struct ip_sf_list **pps=
f)
 	}
 }
=20
+static void kfree_pmc(struct ip_mc_list *pmc)
+{
+	ip_sf_list_clear_all(pmc->sources);
+	ip_sf_list_clear_all(pmc->tomb);
+	kfree(pmc);
+}
+
 static void igmpv3_send_cr(struct in_device *in_dev)
 {
 	struct ip_mc_list *pmc, *pmc_prev, *pmc_next;
@@ -650,7 +668,7 @@ static void igmpv3_send_cr(struct in_device *in_dev)
 			else
 				in_dev->mc_tomb =3D pmc_next;
 			in_dev_put(pmc->interface);
-			kfree(pmc);
+			kfree_pmc(pmc);
 		} else
 			pmc_prev =3D pmc;
 	}
@@ -1106,6 +1124,7 @@ static void igmpv3_add_delrec(struct in_device *in_de=
v, struct ip_mc_list *im)
 	pmc =3D kzalloc(sizeof(*pmc), GFP_KERNEL);
 	if (!pmc)
 		return;
+	spin_lock_init(&pmc->lock);
 	spin_lock_bh(&im->lock);
 	pmc->interface =3D im->interface;
 	in_dev_hold(in_dev);
@@ -1160,12 +1179,16 @@ static void igmpv3_del_delrec(struct in_device *in_=
dev, struct ip_mc_list *im)
 		im->crcount =3D in_dev->mr_qrv ?: IGMP_Unsolicited_Report_Count;
 		if (im->sfmode =3D=3D MCAST_INCLUDE) {
 			im->tomb =3D pmc->tomb;
+			pmc->tomb =3D NULL;
+
 			im->sources =3D pmc->sources;
+			pmc->sources =3D NULL;
+
 			for (psf =3D im->sources; psf; psf =3D psf->sf_next)
 				psf->sf_crcount =3D im->crcount;
 		}
 		in_dev_put(pmc->interface);
-		kfree(pmc);
+		kfree_pmc(pmc);
 	}
 	spin_unlock_bh(&im->lock);
 }
@@ -1186,21 +1209,18 @@ static void igmpv3_clear_delrec(struct in_device *i=
n_dev)
 		nextpmc =3D pmc->next;
 		ip_mc_clear_src(pmc);
 		in_dev_put(pmc->interface);
-		kfree(pmc);
+		kfree_pmc(pmc);
 	}
 	/* clear dead sources, too */
 	rcu_read_lock();
 	for_each_pmc_rcu(in_dev, pmc) {
-		struct ip_sf_list *psf, *psf_next;
+		struct ip_sf_list *psf;
=20
 		spin_lock_bh(&pmc->lock);
 		psf =3D pmc->tomb;
 		pmc->tomb =3D NULL;
 		spin_unlock_bh(&pmc->lock);
-		for (; psf; psf =3D psf_next) {
-			psf_next =3D psf->sf_next;
-			kfree(psf);
-		}
+		ip_sf_list_clear_all(psf);
 	}
 	rcu_read_unlock();
 }
@@ -1880,21 +1900,20 @@ static int ip_mc_add_src(struct in_device *in_dev, =
__be32 *pmca, int sfmode,
=20
 static void ip_mc_clear_src(struct ip_mc_list *pmc)
 {
-	struct ip_sf_list *psf, *nextpsf;
+	struct ip_sf_list *tomb, *sources;
=20
-	for (psf =3D pmc->tomb; psf; psf =3D nextpsf) {
-		nextpsf =3D psf->sf_next;
-		kfree(psf);
-	}
+	spin_lock_bh(&pmc->lock);
+	tomb =3D pmc->tomb;
 	pmc->tomb =3D NULL;
-	for (psf =3D pmc->sources; psf; psf =3D nextpsf) {
-		nextpsf =3D psf->sf_next;
-		kfree(psf);
-	}
+	sources =3D pmc->sources;
 	pmc->sources =3D NULL;
 	pmc->sfmode =3D MCAST_EXCLUDE;
 	pmc->sfcount[MCAST_INCLUDE] =3D 0;
 	pmc->sfcount[MCAST_EXCLUDE] =3D 1;
+	spin_unlock_bh(&pmc->lock);
+
+	ip_sf_list_clear_all(tomb);
+	ip_sf_list_clear_all(sources);
 }
=20
=20
diff --git a/net/ipv6/ip6_flowlabel.c b/net/ipv6/ip6_flowlabel.c
index d8e8008aa7a4..ff443ed82337 100644
--- a/net/ipv6/ip6_flowlabel.c
+++ b/net/ipv6/ip6_flowlabel.c
@@ -255,9 +255,9 @@ struct ip6_flowlabel * fl6_sock_lookup(struct sock *sk,=
 __be32 label)
 	rcu_read_lock_bh();
 	for_each_sk_fl_rcu(np, sfl) {
 		struct ip6_flowlabel *fl =3D sfl->fl;
-		if (fl->label =3D=3D label) {
+
+		if (fl->label =3D=3D label && atomic_inc_not_zero(&fl->users)) {
 			fl->lastuse =3D jiffies;
-			atomic_inc(&fl->users);
 			rcu_read_unlock_bh();
 			return fl;
 		}
@@ -619,7 +619,8 @@ int ipv6_flowlabel_opt(struct sock *sk, char __user *op=
tval, int optlen)
 						goto done;
 					}
 					fl1 =3D sfl->fl;
-					atomic_inc(&fl1->users);
+					if (!atomic_inc_not_zero(&fl1->users))
+						fl1 =3D NULL;
 					break;
 				}
 			}
diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index 086049f5abd3..b1d9ff9f1c3e 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -568,7 +568,6 @@ static struct sock *iucv_sock_alloc(struct socket *sock=
, int proto, gfp_t prio)
=20
 	sk->sk_destruct =3D iucv_sock_destruct;
 	sk->sk_sndtimeo =3D IUCV_CONN_TIMEOUT;
-	sk->sk_allocation =3D GFP_DMA;
=20
 	sock_reset_flag(sk, SOCK_ZAPPED);
=20
@@ -762,6 +761,7 @@ static int iucv_sock_bind(struct socket *sock, struct s=
ockaddr *addr,
 		memcpy(iucv->src_user_id, iucv_userid, 8);
 		sk->sk_state =3D IUCV_BOUND;
 		iucv->transport =3D AF_IUCV_TRANS_IUCV;
+		sk->sk_allocation |=3D GFP_DMA;
 		if (!iucv->msglimit)
 			iucv->msglimit =3D IUCV_QUEUELEN_DEFAULT;
 		goto done_unlock;
@@ -786,6 +786,8 @@ static int iucv_sock_autobind(struct sock *sk)
 		return -EPROTO;
=20
 	memcpy(iucv->src_user_id, iucv_userid, 8);
+	iucv->transport =3D AF_IUCV_TRANS_IUCV;
+	sk->sk_allocation |=3D GFP_DMA;
=20
 	write_lock_bh(&iucv_sk_list.lock);
 	__iucv_auto_name(iucv);
@@ -1737,6 +1739,8 @@ static int iucv_callback_connreq(struct iucv_path *pa=
th,
=20
 	niucv =3D iucv_sk(nsk);
 	iucv_sock_init(nsk, sk);
+	niucv->transport =3D AF_IUCV_TRANS_IUCV;
+	nsk->sk_allocation |=3D GFP_DMA;
=20
 	/* Set the new iucv_sock */
 	memcpy(niucv->dst_name, ipuser + 8, 8);
@@ -2395,6 +2399,13 @@ static int afiucv_iucv_init(void)
 	return err;
 }
=20
+static void afiucv_iucv_exit(void)
+{
+	device_unregister(af_iucv_dev);
+	driver_unregister(&af_iucv_driver);
+	pr_iucv->iucv_unregister(&af_iucv_handler, 0);
+}
+
 static int __init afiucv_init(void)
 {
 	int err;
@@ -2428,11 +2439,18 @@ static int __init afiucv_init(void)
 		err =3D afiucv_iucv_init();
 		if (err)
 			goto out_sock;
-	} else
-		register_netdevice_notifier(&afiucv_netdev_notifier);
+	}
+
+	err =3D register_netdevice_notifier(&afiucv_netdev_notifier);
+	if (err)
+		goto out_notifier;
+
 	dev_add_pack(&iucv_packet_type);
 	return 0;
=20
+out_notifier:
+	if (pr_iucv)
+		afiucv_iucv_exit();
 out_sock:
 	sock_unregister(PF_IUCV);
 out_proto:
@@ -2446,12 +2464,11 @@ static int __init afiucv_init(void)
 static void __exit afiucv_exit(void)
 {
 	if (pr_iucv) {
-		device_unregister(af_iucv_dev);
-		driver_unregister(&af_iucv_driver);
-		pr_iucv->iucv_unregister(&af_iucv_handler, 0);
+		afiucv_iucv_exit();
 		symbol_put(iucv_if);
-	} else
-		unregister_netdevice_notifier(&afiucv_netdev_notifier);
+	}
+
+	unregister_netdevice_notifier(&afiucv_netdev_notifier);
 	dev_remove_pack(&iucv_packet_type);
 	sock_unregister(PF_IUCV);
 	proto_unregister(&iucv_proto);
diff --git a/net/llc/llc_output.c b/net/llc/llc_output.c
index 94425e421213..9e4b6bcf6920 100644
--- a/net/llc/llc_output.c
+++ b/net/llc/llc_output.c
@@ -72,6 +72,8 @@ int llc_build_and_send_ui_pkt(struct llc_sap *sap, struct=
 sk_buff *skb,
 	rc =3D llc_mac_hdr_init(skb, skb->dev->dev_addr, dmac);
 	if (likely(!rc))
 		rc =3D dev_queue_xmit(skb);
+	else
+		kfree_skb(skb);
 	return rc;
 }
=20
diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
index a985158d95d5..e297a6f8723d 100644
--- a/net/rds/ib_rdma.c
+++ b/net/rds/ib_rdma.c
@@ -663,12 +663,14 @@ static int rds_ib_flush_mr_pool(struct rds_ib_mr_pool=
 *pool,
 		wait_clean_list_grace();
=20
 		list_to_llist_nodes(pool, &unmap_list, &clean_nodes, &clean_tail);
-		if (ibmr_ret)
+		if (ibmr_ret) {
 			*ibmr_ret =3D llist_entry(clean_nodes, struct rds_ib_mr, llnode);
-
+			clean_nodes =3D clean_nodes->next;
+		}
 		/* more than one entry in llist nodes */
-		if (clean_nodes->next)
-			llist_add_batch(clean_nodes->next, clean_tail, &pool->clean_list);
+		if (clean_nodes)
+			llist_add_batch(clean_nodes, clean_tail,
+					&pool->clean_list);
=20
 	}
=20
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index fdfa47401464..996b919d82c7 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -440,8 +440,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qd=
isc *sch)
 	struct netem_skb_cb *cb;
 	struct sk_buff *skb2;
 	struct sk_buff *segs =3D NULL;
-	unsigned int len =3D 0, last_len, prev_len =3D qdisc_pkt_len(skb);
-	int nb =3D 0;
+	unsigned int prev_len =3D qdisc_pkt_len(skb);
 	int count =3D 1;
 	int rc =3D NET_XMIT_SUCCESS;
 	int rc_drop =3D NET_XMIT_DROP;
@@ -495,6 +494,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qd=
isc *sch)
 			segs =3D netem_segment(skb, sch);
 			if (!segs)
 				return rc_drop;
+			qdisc_skb_cb(segs)->pkt_len =3D segs->len;
 		} else {
 			segs =3D skb;
 		}
@@ -575,6 +575,11 @@ static int netem_enqueue(struct sk_buff *skb, struct Q=
disc *sch)
=20
 finish_segs:
 	if (segs) {
+		unsigned int len, last_len;
+		int nb =3D 0;
+
+		len =3D skb->len;
+
 		while (segs) {
 			skb2 =3D segs->next;
 			segs->next =3D NULL;
@@ -590,9 +595,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qd=
isc *sch)
 			}
 			segs =3D skb2;
 		}
-		sch->q.qlen +=3D nb;
-		if (nb > 1)
-			qdisc_tree_reduce_backlog(sch, 1 - nb, prev_len - len);
+		qdisc_tree_reduce_backlog(sch, -nb, prev_len - len);
 	}
 	return NET_XMIT_SUCCESS;
 }
diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
index 9da76ba4d10f..3550f0784306 100644
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -126,10 +126,6 @@ static struct sctp_endpoint *sctp_endpoint_init(struct=
 sctp_endpoint *ep,
 	/* Initialize the bind addr area */
 	sctp_bind_addr_init(&ep->base.bind_addr, 0);
=20
-	/* Remember who we are attached to.  */
-	ep->base.sk =3D sk;
-	sock_hold(ep->base.sk);
-
 	/* Create the lists of associations.  */
 	INIT_LIST_HEAD(&ep->asocs);
=20
@@ -165,6 +161,10 @@ static struct sctp_endpoint *sctp_endpoint_init(struct=
 sctp_endpoint *ep,
 	ep->auth_hmacs_list =3D auth_hmacs;
 	ep->auth_chunk_list =3D auth_chunks;
=20
+	/* Remember who we are attached to.  */
+	ep->base.sk =3D sk;
+	sock_hold(ep->base.sk);
+
 	return ep;
=20
 nomem_hmacs:
diff --git a/net/wireless/core.c b/net/wireless/core.c
index e2813667d590..7e9181480c57 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -386,7 +386,7 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops,=
 int sizeof_priv)
 				   &rdev->rfkill_ops, rdev);
=20
 	if (!rdev->rfkill) {
-		kfree(rdev);
+		wiphy_free(&rdev->wiphy);
 		return NULL;
 	}
=20
diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_u=
npack.c
index 25ce8e3d6ede..2e05474e52ad 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -177,7 +177,7 @@ static bool unpack_nameX(struct aa_ext *e, enum aa_code=
 code, const char *name)
 		char *tag =3D NULL;
 		size_t size =3D unpack_u16_chunk(e, &tag);
 		/* if a name is specified it must match. otherwise skip tag */
-		if (name && (!size || strcmp(name, tag)))
+		if (name && (!size || tag[size-1] !=3D '\0' || strcmp(name, tag)))
 			goto fail;
 	} else if (name) {
 		/* if a name is specified and there is no name tag fail */
diff --git a/sound/core/seq/oss/seq_oss_ioctl.c b/sound/core/seq/oss/seq_os=
s_ioctl.c
index 5b8520177b0e..7d72e3d48ad5 100644
--- a/sound/core/seq/oss/seq_oss_ioctl.c
+++ b/sound/core/seq/oss/seq_oss_ioctl.c
@@ -62,7 +62,7 @@ static int snd_seq_oss_oob_user(struct seq_oss_devinfo *d=
p, void __user *arg)
 	if (copy_from_user(ev, arg, 8))
 		return -EFAULT;
 	memset(&tmpev, 0, sizeof(tmpev));
-	snd_seq_oss_fill_addr(dp, &tmpev, dp->addr.port, dp->addr.client);
+	snd_seq_oss_fill_addr(dp, &tmpev, dp->addr.client, dp->addr.port);
 	tmpev.time.tick =3D 0;
 	if (! snd_seq_oss_process_event(dp, (union evrec *)ev, &tmpev)) {
 		snd_seq_oss_dispatch(dp, &tmpev, 0, 0);
diff --git a/sound/core/seq/oss/seq_oss_rw.c b/sound/core/seq/oss/seq_oss_r=
w.c
index 6a7b6aceeca9..499f3e8f4949 100644
--- a/sound/core/seq/oss/seq_oss_rw.c
+++ b/sound/core/seq/oss/seq_oss_rw.c
@@ -174,7 +174,7 @@ insert_queue(struct seq_oss_devinfo *dp, union evrec *r=
ec, struct file *opt)
 	memset(&event, 0, sizeof(event));
 	/* set dummy -- to be sure */
 	event.type =3D SNDRV_SEQ_EVENT_NOTEOFF;
-	snd_seq_oss_fill_addr(dp, &event, dp->addr.port, dp->addr.client);
+	snd_seq_oss_fill_addr(dp, &event, dp->addr.client, dp->addr.port);
=20
 	if (snd_seq_oss_process_event(dp, rec, &event))
 		return 0; /* invalid event - no need to insert queue */
diff --git a/sound/soc/codecs/cs42xx8.c b/sound/soc/codecs/cs42xx8.c
index a25bc6061a30..344d9a085ac1 100644
--- a/sound/soc/codecs/cs42xx8.c
+++ b/sound/soc/codecs/cs42xx8.c
@@ -557,6 +557,7 @@ static int cs42xx8_runtime_resume(struct device *dev)
 	msleep(5);
=20
 	regcache_cache_only(cs42xx8->regmap, false);
+	regcache_mark_dirty(cs42xx8->regmap);
=20
 	ret =3D regcache_sync(cs42xx8->regmap);
 	if (ret) {
=0D
--=-cUpQWZnzk1bmzd7MlVy8--

--=-Be6Yhz239CV6wofnxdsP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl2ZAEcACgkQ57/I7JWG
EQmFAw//RGYvCLDxnRQM+9ysDmHxn3PsM6GJ492WfP7Bwld6LbqOEpq3RT6p5F6A
rHGksYvcnZFbFVJubmDcwSa04lVWkRH8jHmqaX823TXL/0CMz7K5nIRVt10j6KUT
rNMStTBE2x3wgJFAWTz8LD2xryJ/GqVop1/6bevDKQwtqh2bR/r1TpLp+Z8CXMx6
PGoNeiYe+0SVS5dVcYOZQ8xnxSn//7U8CQyLP8MMZqJChyxOm4CC8B9Vlg0PeGyh
VjUotOA0mYwtIkH0wYyxPOzEtRQ7gx9KjQJWFEAQxRNigCmsxyp/2M5+QnS68LlA
Ug3e5BzlJNrZ/Fg4q4zdv2l6iWEtQwg5CwJQEVOnFarUlRCbojT8v+RXLCV7dkzJ
HwQPSedUT9mlBBwsishSC02F3qzNYDolzJEMOzD12Jucx7SsDm80lesUNCgg7kuK
/byJ78UrDm4VETZZfak+l9X+wtgzcwH3y9hUJ2JDfXbhlVyU1dMqKM6WEyeyq9wu
1ZgDzn+xxo7fyse1b7b5TYWT/thNpTRE2r8N+ev+aKtXHnVqEwUU1eyZScXQKMkH
yoGc5fDKtOuct3ruzEKzSJGjnR0zO9V2gh+1r2x3MoCiWLfsaGNAbKureWq5jDF8
XaJcoz8GV6nTAE5c2fcSh+oSqaPBu+/gIVt17/yK1U2jp1aAJvk=
=zXJc
-----END PGP SIGNATURE-----

--=-Be6Yhz239CV6wofnxdsP--
