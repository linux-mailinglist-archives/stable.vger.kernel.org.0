Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B64A3330EA
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 22:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbhCIV31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 16:29:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbhCIV3M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Mar 2021 16:29:12 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33CB8C06174A
        for <stable@vger.kernel.org>; Tue,  9 Mar 2021 13:29:12 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id j2so18676929wrx.9
        for <stable@vger.kernel.org>; Tue, 09 Mar 2021 13:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=CILtT+fQ3gkehmo3mOgdhSb8+h6HpmN2VSr63H81tTc=;
        b=Dawzv/g3A7MLZzJuce6BzjCoYAVag7KJsfRP5xQd1QAusziMTGdjO5Ia2WqTxaRJ8p
         zj0qVej6xKn+ANOzyZglOz70JYV+Q84dOK8U2AJjHKBPJqL1O2ZwemsYnxlRcdNMGo4h
         VFivu2edZhGTJLLrhKV9vkdvCyXHFzQB1acZsLpPtKxR5AORwQ8aKkBJpBk3Gx1Ngini
         YlpEbVvgsp20rQhDEa2HGKm3uUqZfq/QoRhfneu2MKWJyB6Tx8ukadzj982nUVDm50co
         tWFRPBfZuf5vIhyTlN+EXYylvQCLpzhwfjnTq5Ctz0qTvl6DxCgGUaBn5epwJDP80Tv0
         1hVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=CILtT+fQ3gkehmo3mOgdhSb8+h6HpmN2VSr63H81tTc=;
        b=kb69x5rnZc/wbHCtgJFXTqmaNehTMsQ7oNWwHaiCMIFseASAwCW4uy7fLnIv8u+5ww
         zwXjQSc7yNdXzaK9ETMSbSs6XRDNtch2LjKkdeCzhFYiEUNUNzIYxpXUos8xcmjVzcXe
         bYeKFlAOW0A9RJcuEsvLR4ZIbMKQuPiFzogZMtRPwrGXoszr6ESF7w4T2nZnh9dJKq8y
         edF5VFPq9YxMH/rEwKi0+S4pCRxchsujZ7MwPoetUVH57pzpkjMnsa8fctSLlElnJA37
         DW/0Bv9o48fBVoc9nMCutmIkzkdU3QgCYw04sXPCL5PTgRvkSxWtz1FO74sC3M/u/2H7
         5kxw==
X-Gm-Message-State: AOAM531O8KZPEtNXAZxSE1XAdZPMt/7P1QSPxFJTzFBBrBftRgFp+Bt8
        1yF6b9wM5r/45xYQ4anXdVYK//g9K/Nirg==
X-Google-Smtp-Source: ABdhPJxwAO7oZnap6U0aOhl3WF8tL01fbxCWCZXQnZOJPBuO2eivW3+MpchLPuyd/buquIKE//4pzg==
X-Received: by 2002:a5d:698e:: with SMTP id g14mr30019449wru.127.1615325350829;
        Tue, 09 Mar 2021 13:29:10 -0800 (PST)
Received: from debian (host-2-98-59-96.as13285.net. [2.98.59.96])
        by smtp.gmail.com with ESMTPSA id f14sm5844648wmf.7.2021.03.09.13.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 13:29:09 -0800 (PST)
Date:   Tue, 9 Mar 2021 21:29:08 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: few missing commits for 5.10-stable
Message-ID: <YEfopAGxgmMJJhzY@debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gkczKYIFLKEWnfby"
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--gkczKYIFLKEWnfby
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

These were missing in 5.10-stable and 5.11-stable.

dc22c1c058b5 ("nvme-pci: mark Kingston SKC2000 as not supporting the deepest power state")
- Not marked for stable but looks like it should be there.

778e45d7720d ("parisc: Enable -mlong-calls gcc option with CONFIG_COMPILE_TEST")

e9c6deee00e9 ("arm64: Make CPU_BIG_ENDIAN depend on ld.bfd or ld.lld 13.0.0+")
- Not marked for stable, but 5.10-stable and 5.11-stable should have the same problem.

80e9baed722c ("btrfs: export and rename qgroup_reserve_meta")
- only needed for the next patch.

4d14c5cde5c2 ("btrfs: don't flush from btrfs_delayed_inode_reserve_metadata")


--
Regards
Sudip

--gkczKYIFLKEWnfby
Content-Type: application/mbox
Content-Disposition: attachment; filename="missing_5.10.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom 5e2e6b61653e9395db8fc4b1753ecc5b2a0dc9eb Mon Sep 17 00:00:00 2001=0A=
=46rom: =3D?UTF-8?q?Zolt=3DC3=3DA1n=3D20B=3DC3=3DB6sz=3DC3=3DB6rm=3DC3=3DA9=
nyi?=3D=0A <zboszor@gmail.com>=0ADate: Sun, 21 Feb 2021 06:12:16 +0100=0ASu=
bject: [PATCH 1/5] nvme-pci: mark Kingston SKC2000 as not supporting the=0A=
 deepest power state=0AMIME-Version: 1.0=0AContent-Type: text/plain; charse=
t=3DUTF-8=0AContent-Transfer-Encoding: 8bit=0A=0Acommit dc22c1c058b5c4fe967=
a20589e36f029ee42a706 upstream=0A=0AMy 2TB SKC2000 showed the exact same sy=
mptoms that were provided=0Ain 538e4a8c57 ("nvme-pci: avoid the deepest sle=
ep state on=0AKingston A2000 SSDs"), i.e. a complete NVME lockup that neede=
d=0Acold boot to get it back.=0A=0AAccording to some sources, the A2000 is =
simply a rebadged=0ASKC2000 with a slightly optimized firmware.=0A=0AAdding=
 the SKC2000 PCI ID to the quirk list with the same workaround=0Aas the A20=
00 made my laptop survive a 5 hours long Yocto bootstrap=0Abuildfest which =
reliably triggered the SSD lockup previously.=0A=0ASigned-off-by: Zolt=C3=
=A1n B=C3=B6sz=C3=B6rm=C3=A9nyi <zboszor@gmail.com>=0ASigned-off-by: Christ=
oph Hellwig <hch@lst.de>=0A[sudip: adjust context]=0ASigned-off-by: Sudip M=
ukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/nvme/host/pci.c | 2 =
++=0A 1 file changed, 2 insertions(+)=0A=0Adiff --git a/drivers/nvme/host/p=
ci.c b/drivers/nvme/host/pci.c=0Aindex 4a33287371bd..25ffa61b72cc 100644=0A=
--- a/drivers/nvme/host/pci.c=0A+++ b/drivers/nvme/host/pci.c=0A@@ -3264,6 =
+3264,8 @@ static const struct pci_device_id nvme_id_table[] =3D {=0A 		.dr=
iver_data =3D NVME_QUIRK_DISABLE_WRITE_ZEROES, },=0A 	{ PCI_DEVICE(0x15b7, =
0x2001),   /*  Sandisk Skyhawk */=0A 		.driver_data =3D NVME_QUIRK_DISABLE_=
WRITE_ZEROES, },=0A+	{ PCI_DEVICE(0x2646, 0x2262),   /* KINGSTON SKC2000 NV=
Me SSD */=0A+		.driver_data =3D NVME_QUIRK_NO_DEEPEST_PS, },=0A 	{ PCI_DEVI=
CE(0x2646, 0x2263),   /* KINGSTON A2000 NVMe SSD  */=0A 		.driver_data =3D =
NVME_QUIRK_NO_DEEPEST_PS, },=0A 	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, 0x2001),=
=0A-- =0A2.30.1=0A=0A=0AFrom 4a537864db50e4d9eda0c28907c354879e5ad3a2 Mon S=
ep 17 00:00:00 2001=0AFrom: Helge Deller <deller@gmx.de>=0ADate: Tue, 2 Mar=
 2021 21:07:07 +0100=0ASubject: [PATCH 2/5] parisc: Enable -mlong-calls gcc=
 option with=0A CONFIG_COMPILE_TEST=0A=0Acommit 778e45d7720d663811352943dd5=
15b41f6849637 upstream=0A=0AThe kernel test robot reported multiple linkage=
 problems like this:=0A=0A    hppa64-linux-ld: init/main.o(.init.text+0x56c=
): cannot reach printk=0A    init/main.o: in function `unknown_bootoption':=
=0A    (.init.text+0x56c): relocation truncated to fit: R_PARISC_PCREL22F a=
gainst=0A	symbol `printk' defined in .text.unlikely section in kernel/print=
k/printk.o=0A=0AThere are two ways to solve it:=0Aa) Enable the -mlong-call=
 compiler option (CONFIG_MLONGCALLS),=0Ab) Add long branch stub support in =
64-bit linker.=0A=0AWhile b) is the long-term solution, this patch works ar=
ound the issue by=0Aautomatically enabling the CONFIG_MLONGCALLS option whe=
n=0ACONFIG_COMPILE_TEST is set, which indicates that a non-production kerne=
l=0A(e.g. 0-day kernel) is built.=0A=0ASigned-off-by: Helge Deller <deller@=
gmx.de>=0AReported-by: kernel test robot <lkp@intel.com>=0AFixes: 00e35f2b0=
e8a ("parisc: Enable -mlong-calls gcc option by default when !CONFIG_MODULE=
S")=0ACc: stable@vger.kernel.org # v5.6+=0ASigned-off-by: Sudip Mukherjee <=
sudipm.mukherjee@gmail.com>=0A---=0A arch/parisc/Kconfig | 7 +++++--=0A 1 f=
ile changed, 5 insertions(+), 2 deletions(-)=0A=0Adiff --git a/arch/parisc/=
Kconfig b/arch/parisc/Kconfig=0Aindex 04dc17d52ac2..14f3252f2da0 100644=0A-=
-- a/arch/parisc/Kconfig=0A+++ b/arch/parisc/Kconfig=0A@@ -201,9 +201,12 @@=
 config PREFETCH=0A 	def_bool y=0A 	depends on PA8X00 || PA7200=0A =0A+conf=
ig PARISC_HUGE_KERNEL=0A+	def_bool y if !MODULES || UBSAN || FTRACE || COMP=
ILE_TEST=0A+=0A config MLONGCALLS=0A-	def_bool y if !MODULES || UBSAN || FT=
RACE=0A-	bool "Enable the -mlong-calls compiler option for big kernels" if =
MODULES && !UBSAN && !FTRACE=0A+	def_bool y if PARISC_HUGE_KERNEL=0A+	bool =
"Enable the -mlong-calls compiler option for big kernels" if !PARISC_HUGE_K=
ERNEL=0A 	depends on PA8X00=0A 	help=0A 	  If you configure the kernel to i=
nclude many drivers built-in instead=0A-- =0A2.30.1=0A=0A=0AFrom 259b4b26f7=
a24ac2a7b981759400a93821ae21f4 Mon Sep 17 00:00:00 2001=0AFrom: Nathan Chan=
cellor <nathan@kernel.org>=0ADate: Mon, 8 Feb 2021 17:57:20 -0700=0ASubject=
: [PATCH 3/5] arm64: Make CPU_BIG_ENDIAN depend on ld.bfd or ld.lld=0A 13.0=
=2E0+=0A=0Acommit e9c6deee00e9197e75cd6aa0d265d3d45bd7cc28 upstream=0A=0ASi=
milar to commit 28187dc8ebd9 ("ARM: 9025/1: Kconfig: CPU_BIG_ENDIAN=0Adepen=
ds on !LD_IS_LLD"), ld.lld prior to 13.0.0 does not properly=0Asupport aarc=
h64 big endian, leading to the following build error when=0ACONFIG_CPU_BIG_=
ENDIAN is selected:=0A=0Ald.lld: error: unknown emulation: aarch64linuxb=0A=
=0AThis has been resolved in LLVM 13. To avoid errors like this, only allow=
=0ACONFIG_CPU_BIG_ENDIAN to be selected if using ld.bfd or ld.lld 13.0.0=0A=
and newer.=0A=0AWhile we are here, the indentation of this symbol used spac=
es since its=0Aintroduction in commit a872013d6d03 ("arm64: kconfig: allow=
=0ACPU_BIG_ENDIAN to be selected"). Change it to tabs to be consistent with=
=0Akernel coding style.=0A=0ALink: https://github.com/ClangBuiltLinux/linux=
/issues/380=0ALink: https://github.com/ClangBuiltLinux/linux/issues/1288=0A=
Link: https://github.com/llvm/llvm-project/commit/7605a9a009b5fa3bdac07e313=
1c8d82f6d08feb7=0ALink: https://github.com/llvm/llvm-project/commit/eea34aa=
e2e74e9b6fbdd5b95f479bc7f397bf387=0AReported-by: Arnd Bergmann <arnd@arndb.=
de>=0ASigned-off-by: Nathan Chancellor <nathan@kernel.org>=0AReviewed-by: N=
ick Desaulniers <ndesaulniers@google.com>=0ALink: https://lore.kernel.org/r=
/20210209005719.803608-1-nathan@kernel.org=0ASigned-off-by: Will Deacon <wi=
ll@kernel.org>=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com=
>=0A---=0A arch/arm64/Kconfig | 5 +++--=0A 1 file changed, 3 insertions(+),=
 2 deletions(-)=0A=0Adiff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig=
=0Aindex afe4bc55d4eb..c1be64228327 100644=0A--- a/arch/arm64/Kconfig=0A+++=
 b/arch/arm64/Kconfig=0A@@ -950,8 +950,9 @@ choice=0A 	  that is selected h=
ere.=0A =0A config CPU_BIG_ENDIAN=0A-       bool "Build big-endian kernel"=
=0A-       help=0A+	bool "Build big-endian kernel"=0A+	depends on !LD_IS_LL=
D || LLD_VERSION >=3D 130000=0A+	help=0A 	  Say Y if you plan on running a =
kernel with a big-endian userspace.=0A =0A config CPU_LITTLE_ENDIAN=0A-- =
=0A2.30.1=0A=0A=0AFrom aac4a91dae9f0df6fab43f099faa6bdd7a6cdf02 Mon Sep 17 =
00:00:00 2001=0AFrom: Nikolay Borisov <nborisov@suse.com>=0ADate: Mon, 22 F=
eb 2021 18:40:43 +0200=0ASubject: [PATCH 4/5] btrfs: export and rename qgro=
up_reserve_meta=0A=0Acommit 80e9baed722c853056e0c5374f51524593cb1031 upstre=
am=0A=0ASigned-off-by: Nikolay Borisov <nborisov@suse.com>=0AReviewed-by: D=
avid Sterba <dsterba@suse.com>=0ASigned-off-by: David Sterba <dsterba@suse.=
com>=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A=
 fs/btrfs/qgroup.c | 8 ++++----=0A fs/btrfs/qgroup.h | 2 ++=0A 2 files chan=
ged, 6 insertions(+), 4 deletions(-)=0A=0Adiff --git a/fs/btrfs/qgroup.c b/=
fs/btrfs/qgroup.c=0Aindex d504a9a20751..cd9b1a16489b 100644=0A--- a/fs/btrf=
s/qgroup.c=0A+++ b/fs/btrfs/qgroup.c=0A@@ -3875,8 +3875,8 @@ static int sub=
_root_meta_rsv(struct btrfs_root *root, int num_bytes,=0A 	return num_bytes=
;=0A }=0A =0A-static int qgroup_reserve_meta(struct btrfs_root *root, int n=
um_bytes,=0A-				enum btrfs_qgroup_rsv_type type, bool enforce)=0A+int btrf=
s_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,=0A+			      e=
num btrfs_qgroup_rsv_type type, bool enforce)=0A {=0A 	struct btrfs_fs_info=
 *fs_info =3D root->fs_info;=0A 	int ret;=0A@@ -3907,14 +3907,14 @@ int __b=
trfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,=0A {=0A 	i=
nt ret;=0A =0A-	ret =3D qgroup_reserve_meta(root, num_bytes, type, enforce)=
;=0A+	ret =3D btrfs_qgroup_reserve_meta(root, num_bytes, type, enforce);=0A=
 	if (ret <=3D 0 && ret !=3D -EDQUOT)=0A 		return ret;=0A =0A 	ret =3D try_=
flush_qgroup(root);=0A 	if (ret < 0)=0A 		return ret;=0A-	return qgroup_res=
erve_meta(root, num_bytes, type, enforce);=0A+	return btrfs_qgroup_reserve_=
meta(root, num_bytes, type, enforce);=0A }=0A =0A void btrfs_qgroup_free_me=
ta_all_pertrans(struct btrfs_root *root)=0Adiff --git a/fs/btrfs/qgroup.h b=
/fs/btrfs/qgroup.h=0Aindex 50dea9a2d8fb..7283e4f549af 100644=0A--- a/fs/btr=
fs/qgroup.h=0A+++ b/fs/btrfs/qgroup.h=0A@@ -361,6 +361,8 @@ int btrfs_qgrou=
p_release_data(struct btrfs_inode *inode, u64 start, u64 len);=0A int btrfs=
_qgroup_free_data(struct btrfs_inode *inode,=0A 			   struct extent_changes=
et *reserved, u64 start,=0A 			   u64 len);=0A+int btrfs_qgroup_reserve_met=
a(struct btrfs_root *root, int num_bytes,=0A+			      enum btrfs_qgroup_rsv=
_type type, bool enforce);=0A int __btrfs_qgroup_reserve_meta(struct btrfs_=
root *root, int num_bytes,=0A 				enum btrfs_qgroup_rsv_type type, bool enf=
orce);=0A /* Reserve metadata space for pertrans and prealloc type */=0A-- =
=0A2.30.1=0A=0A=0AFrom 6bb1564c5fa4cf4a817bf02732597dd90e122d57 Mon Sep 17 =
00:00:00 2001=0AFrom: Nikolay Borisov <nborisov@suse.com>=0ADate: Mon, 22 F=
eb 2021 18:40:44 +0200=0ASubject: [PATCH 5/5] btrfs: don't flush from=0A bt=
rfs_delayed_inode_reserve_metadata=0A=0Acommit 4d14c5cde5c268a2bc26addecf09=
489cb953ef64 upstream=0A=0ACalling btrfs_qgroup_reserve_meta_prealloc from=
=0Abtrfs_delayed_inode_reserve_metadata can result in flushing delalloc=0Aw=
hile holding a transaction and delayed node locks. This is deadlock=0Aprone=
=2E In the past multiple commits:=0A=0A * ae5e070eaca9 ("btrfs: qgroup: don=
't try to wait flushing if we're=0Aalready holding a transaction")=0A=0A * =
6f23277a49e6 ("btrfs: qgroup: don't commit transaction when we already=0A h=
old the handle")=0A=0ATried to solve various aspects of this but this was a=
lways a=0Awhack-a-mole game. Unfortunately those 2 fixes don't solve a dead=
lock=0Ascenario involving btrfs_delayed_node::mutex. Namely, one thread=0Ac=
an call btrfs_dirty_inode as a result of reading a file and modifying=0Aits=
 atime:=0A=0A  PID: 6963   TASK: ffff8c7f3f94c000  CPU: 2   COMMAND: "test"=
=0A  #0  __schedule at ffffffffa529e07d=0A  #1  schedule at ffffffffa529e4f=
f=0A  #2  schedule_timeout at ffffffffa52a1bdd=0A  #3  wait_for_completion =
at ffffffffa529eeea             <-- sleeps with delayed node mutex held=0A =
 #4  start_delalloc_inodes at ffffffffc0380db5=0A  #5  btrfs_start_delalloc=
_snapshot at ffffffffc0393836=0A  #6  try_flush_qgroup at ffffffffc03f04b2=
=0A  #7  __btrfs_qgroup_reserve_meta at ffffffffc03f5bb6     <-- tries to r=
eserve space and starts delalloc inodes.=0A  #8  btrfs_delayed_update_inode=
 at ffffffffc03e31aa      <-- acquires delayed node mutex=0A  #9  btrfs_upd=
ate_inode at ffffffffc0385ba8=0A #10  btrfs_dirty_inode at ffffffffc038627b=
               <-- TRANSACTIION OPENED=0A #11  touch_atime at ffffffffa4cf0=
000=0A #12  generic_file_read_iter at ffffffffa4c1f123=0A #13  new_sync_rea=
d at ffffffffa4ccdc8a=0A #14  vfs_read at ffffffffa4cd0849=0A #15  ksys_rea=
d at ffffffffa4cd0bd1=0A #16  do_syscall_64 at ffffffffa4a052eb=0A #17  ent=
ry_SYSCALL_64_after_hwframe at ffffffffa540008c=0A=0AThis will cause an asy=
nchronous work to flush the delalloc inodes to=0Ahappen which can try to ac=
quire the same delayed_node mutex:=0A=0A  PID: 455    TASK: ffff8c8085fa400=
0  CPU: 5   COMMAND: "kworker/u16:30"=0A  #0  __schedule at ffffffffa529e07=
d=0A  #1  schedule at ffffffffa529e4ff=0A  #2  schedule_preempt_disabled at=
 ffffffffa529e80a=0A  #3  __mutex_lock at ffffffffa529fdcb                 =
   <-- goes to sleep, never wakes up.=0A  #4  btrfs_delayed_update_inode at=
 ffffffffc03e3143      <-- tries to acquire the mutex=0A  #5  btrfs_update_=
inode at ffffffffc0385ba8              <-- this is the same inode that pid =
6963 is holding=0A  #6  cow_file_range_inline.constprop.78 at ffffffffc0386=
be7=0A  #7  cow_file_range at ffffffffc03879c1=0A  #8  btrfs_run_delalloc_r=
ange at ffffffffc038894c=0A  #9  writepage_delalloc at ffffffffc03a3c8f=0A =
#10  __extent_writepage at ffffffffc03a4c01=0A #11  extent_write_cache_page=
s at ffffffffc03a500b=0A #12  extent_writepages at ffffffffc03a6de2=0A #13 =
 do_writepages at ffffffffa4c277eb=0A #14  __filemap_fdatawrite_range at ff=
ffffffa4c1e5bb=0A #15  btrfs_run_delalloc_work at ffffffffc0380987         =
<-- starts running delayed nodes=0A #16  normal_work_helper at ffffffffc03b=
706c=0A #17  process_one_work at ffffffffa4aba4e4=0A #18  worker_thread at =
ffffffffa4aba6fd=0A #19  kthread at ffffffffa4ac0a3d=0A #20  ret_from_fork =
at ffffffffa54001ff=0A=0ATo fully address those cases the complete fix is t=
o never issue any=0Aflushing while holding the transaction or the delayed n=
ode lock. This=0Apatch achieves it by calling qgroup_reserve_meta directly =
which will=0Aeither succeed without flushing or will fail and return -EDQUO=
T. In the=0Alatter case that return value is going to be propagated to=0Abt=
rfs_dirty_inode which will fallback to start a new transaction. That's=0Afi=
ne as the majority of time we expect the inode will have=0ABTRFS_DELAYED_NO=
DE_INODE_DIRTY flag set which will result in directly=0Acopying the in-memo=
ry state.=0A=0AFixes: c53e9653605d ("btrfs: qgroup: try to flush qgroup spa=
ce when we get -EDQUOT")=0ACC: stable@vger.kernel.org # 5.10+=0AReviewed-by=
: Qu Wenruo <wqu@suse.com>=0ASigned-off-by: Nikolay Borisov <nborisov@suse.=
com>=0ASigned-off-by: David Sterba <dsterba@suse.com>=0A[sudip: adjust cont=
ext]=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A=
 fs/btrfs/delayed-inode.c | 3 ++-=0A fs/btrfs/inode.c         | 2 +-=0A 2 f=
iles changed, 3 insertions(+), 2 deletions(-)=0A=0Adiff --git a/fs/btrfs/de=
layed-inode.c b/fs/btrfs/delayed-inode.c=0Aindex 36e0de34ec68..4e2cce5ca7f6=
 100644=0A--- a/fs/btrfs/delayed-inode.c=0A+++ b/fs/btrfs/delayed-inode.c=
=0A@@ -627,7 +627,8 @@ static int btrfs_delayed_inode_reserve_metadata(=0A =
	 */=0A 	if (!src_rsv || (!trans->bytes_reserved &&=0A 			 src_rsv->type !=
=3D BTRFS_BLOCK_RSV_DELALLOC)) {=0A-		ret =3D btrfs_qgroup_reserve_meta_pre=
alloc(root, num_bytes, true);=0A+		ret =3D btrfs_qgroup_reserve_meta(root, =
num_bytes,=0A+					  BTRFS_QGROUP_RSV_META_PREALLOC, true);=0A 		if (ret < =
0)=0A 			return ret;=0A 		ret =3D btrfs_block_rsv_add(root, dst_rsv, num_by=
tes,=0Adiff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c=0Aindex 9b3df72ceff=
b..cbeb0cdaca7a 100644=0A--- a/fs/btrfs/inode.c=0A+++ b/fs/btrfs/inode.c=0A=
@@ -5798,7 +5798,7 @@ static int btrfs_dirty_inode(struct inode *inode)=0A =
		return PTR_ERR(trans);=0A =0A 	ret =3D btrfs_update_inode(trans, root, in=
ode);=0A-	if (ret && ret =3D=3D -ENOSPC) {=0A+	if (ret && (ret =3D=3D -ENOS=
PC || ret =3D=3D -EDQUOT)) {=0A 		/* whoops, lets try again with the full t=
ransaction */=0A 		btrfs_end_transaction(trans);=0A 		trans =3D btrfs_start=
_transaction(root, 1);=0A-- =0A2.30.1=0A=0A
--gkczKYIFLKEWnfby
Content-Type: application/mbox
Content-Disposition: attachment; filename="missing_5.11.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom 506e53a603137eecaa4f43c4e3ec7ff069a7a6c3 Mon Sep 17 00:00:00 2001=0A=
=46rom: =3D?UTF-8?q?Zolt=3DC3=3DA1n=3D20B=3DC3=3DB6sz=3DC3=3DB6rm=3DC3=3DA9=
nyi?=3D=0A <zboszor@gmail.com>=0ADate: Sun, 21 Feb 2021 06:12:16 +0100=0ASu=
bject: [PATCH 1/5] nvme-pci: mark Kingston SKC2000 as not supporting the=0A=
 deepest power state=0AMIME-Version: 1.0=0AContent-Type: text/plain; charse=
t=3DUTF-8=0AContent-Transfer-Encoding: 8bit=0A=0Acommit dc22c1c058b5c4fe967=
a20589e36f029ee42a706 upstream=0A=0AMy 2TB SKC2000 showed the exact same sy=
mptoms that were provided=0Ain 538e4a8c57 ("nvme-pci: avoid the deepest sle=
ep state on=0AKingston A2000 SSDs"), i.e. a complete NVME lockup that neede=
d=0Acold boot to get it back.=0A=0AAccording to some sources, the A2000 is =
simply a rebadged=0ASKC2000 with a slightly optimized firmware.=0A=0AAdding=
 the SKC2000 PCI ID to the quirk list with the same workaround=0Aas the A20=
00 made my laptop survive a 5 hours long Yocto bootstrap=0Abuildfest which =
reliably triggered the SSD lockup previously.=0A=0ASigned-off-by: Zolt=C3=
=A1n B=C3=B6sz=C3=B6rm=C3=A9nyi <zboszor@gmail.com>=0ASigned-off-by: Christ=
oph Hellwig <hch@lst.de>=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee=
@gmail.com>=0A---=0A drivers/nvme/host/pci.c | 2 ++=0A 1 file changed, 2 in=
sertions(+)=0A=0Adiff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/p=
ci.c=0Aindex 6bad4d4dcdf0..327d66491a98 100644=0A--- a/drivers/nvme/host/pc=
i.c=0A+++ b/drivers/nvme/host/pci.c=0A@@ -3261,6 +3261,8 @@ static const st=
ruct pci_device_id nvme_id_table[] =3D {=0A 		.driver_data =3D NVME_QUIRK_D=
ISABLE_WRITE_ZEROES, },=0A 	{ PCI_DEVICE(0x1d97, 0x2263),   /* SPCC */=0A 	=
	.driver_data =3D NVME_QUIRK_DISABLE_WRITE_ZEROES, },=0A+	{ PCI_DEVICE(0x26=
46, 0x2262),   /* KINGSTON SKC2000 NVMe SSD */=0A+		.driver_data =3D NVME_Q=
UIRK_NO_DEEPEST_PS, },=0A 	{ PCI_DEVICE(0x2646, 0x2263),   /* KINGSTON A200=
0 NVMe SSD  */=0A 		.driver_data =3D NVME_QUIRK_NO_DEEPEST_PS, },=0A 	{ PCI=
_DEVICE(PCI_VENDOR_ID_APPLE, 0x2001),=0A-- =0A2.30.1=0A=0A=0AFrom de89ad321=
f95d35e324fd741f78c62250d6256f7 Mon Sep 17 00:00:00 2001=0AFrom: Helge Dell=
er <deller@gmx.de>=0ADate: Tue, 2 Mar 2021 21:07:07 +0100=0ASubject: [PATCH=
 2/5] parisc: Enable -mlong-calls gcc option with=0A CONFIG_COMPILE_TEST=0A=
=0Acommit 778e45d7720d663811352943dd515b41f6849637 upstream=0A=0AThe kernel=
 test robot reported multiple linkage problems like this:=0A=0A    hppa64-l=
inux-ld: init/main.o(.init.text+0x56c): cannot reach printk=0A    init/main=
=2Eo: in function `unknown_bootoption':=0A    (.init.text+0x56c): relocatio=
n truncated to fit: R_PARISC_PCREL22F against=0A	symbol `printk' defined in=
 .text.unlikely section in kernel/printk/printk.o=0A=0AThere are two ways t=
o solve it:=0Aa) Enable the -mlong-call compiler option (CONFIG_MLONGCALLS)=
,=0Ab) Add long branch stub support in 64-bit linker.=0A=0AWhile b) is the =
long-term solution, this patch works around the issue by=0Aautomatically en=
abling the CONFIG_MLONGCALLS option when=0ACONFIG_COMPILE_TEST is set, whic=
h indicates that a non-production kernel=0A(e.g. 0-day kernel) is built.=0A=
=0ASigned-off-by: Helge Deller <deller@gmx.de>=0AReported-by: kernel test r=
obot <lkp@intel.com>=0AFixes: 00e35f2b0e8a ("parisc: Enable -mlong-calls gc=
c option by default when !CONFIG_MODULES")=0ACc: stable@vger.kernel.org # v=
5.6+=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A=
 arch/parisc/Kconfig | 7 +++++--=0A 1 file changed, 5 insertions(+), 2 dele=
tions(-)=0A=0Adiff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig=0Ainde=
x 278462186ac4..22cf9da1e4a7 100644=0A--- a/arch/parisc/Kconfig=0A+++ b/arc=
h/parisc/Kconfig=0A@@ -201,9 +201,12 @@ config PREFETCH=0A 	def_bool y=0A 	=
depends on PA8X00 || PA7200=0A =0A+config PARISC_HUGE_KERNEL=0A+	def_bool y=
 if !MODULES || UBSAN || FTRACE || COMPILE_TEST=0A+=0A config MLONGCALLS=0A=
-	def_bool y if !MODULES || UBSAN || FTRACE=0A-	bool "Enable the -mlong-cal=
ls compiler option for big kernels" if MODULES && !UBSAN && !FTRACE=0A+	def=
_bool y if PARISC_HUGE_KERNEL=0A+	bool "Enable the -mlong-calls compiler op=
tion for big kernels" if !PARISC_HUGE_KERNEL=0A 	depends on PA8X00=0A 	help=
=0A 	  If you configure the kernel to include many drivers built-in instead=
=0A-- =0A2.30.1=0A=0A=0AFrom 44cabaa42792bbe2b889db31fb879efdc3d203f3 Mon S=
ep 17 00:00:00 2001=0AFrom: Nathan Chancellor <nathan@kernel.org>=0ADate: M=
on, 8 Feb 2021 17:57:20 -0700=0ASubject: [PATCH 3/5] arm64: Make CPU_BIG_EN=
DIAN depend on ld.bfd or ld.lld=0A 13.0.0+=0A=0Acommit e9c6deee00e9197e75cd=
6aa0d265d3d45bd7cc28 upstream=0A=0ASimilar to commit 28187dc8ebd9 ("ARM: 90=
25/1: Kconfig: CPU_BIG_ENDIAN=0Adepends on !LD_IS_LLD"), ld.lld prior to 13=
=2E0.0 does not properly=0Asupport aarch64 big endian, leading to the follo=
wing build error when=0ACONFIG_CPU_BIG_ENDIAN is selected:=0A=0Ald.lld: err=
or: unknown emulation: aarch64linuxb=0A=0AThis has been resolved in LLVM 13=
=2E To avoid errors like this, only allow=0ACONFIG_CPU_BIG_ENDIAN to be sel=
ected if using ld.bfd or ld.lld 13.0.0=0Aand newer.=0A=0AWhile we are here,=
 the indentation of this symbol used spaces since its=0Aintroduction in com=
mit a872013d6d03 ("arm64: kconfig: allow=0ACPU_BIG_ENDIAN to be selected").=
 Change it to tabs to be consistent with=0Akernel coding style.=0A=0ALink: =
https://github.com/ClangBuiltLinux/linux/issues/380=0ALink: https://github.=
com/ClangBuiltLinux/linux/issues/1288=0ALink: https://github.com/llvm/llvm-=
project/commit/7605a9a009b5fa3bdac07e3131c8d82f6d08feb7=0ALink: https://git=
hub.com/llvm/llvm-project/commit/eea34aae2e74e9b6fbdd5b95f479bc7f397bf387=
=0AReported-by: Arnd Bergmann <arnd@arndb.de>=0ASigned-off-by: Nathan Chanc=
ellor <nathan@kernel.org>=0AReviewed-by: Nick Desaulniers <ndesaulniers@goo=
gle.com>=0ALink: https://lore.kernel.org/r/20210209005719.803608-1-nathan@k=
ernel.org=0ASigned-off-by: Will Deacon <will@kernel.org>=0ASigned-off-by: S=
udip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A arch/arm64/Kconfig | 5=
 +++--=0A 1 file changed, 3 insertions(+), 2 deletions(-)=0A=0Adiff --git a=
/arch/arm64/Kconfig b/arch/arm64/Kconfig=0Aindex 3dfb25afa616..e42da99db91f=
 100644=0A--- a/arch/arm64/Kconfig=0A+++ b/arch/arm64/Kconfig=0A@@ -952,8 +=
952,9 @@ choice=0A 	  that is selected here.=0A =0A config CPU_BIG_ENDIAN=
=0A-       bool "Build big-endian kernel"=0A-       help=0A+	bool "Build bi=
g-endian kernel"=0A+	depends on !LD_IS_LLD || LLD_VERSION >=3D 130000=0A+	h=
elp=0A 	  Say Y if you plan on running a kernel with a big-endian userspace=
=2E=0A =0A config CPU_LITTLE_ENDIAN=0A-- =0A2.30.1=0A=0A=0AFrom 64daa43f579=
a72ce974a3b6415a6f374d9becd77 Mon Sep 17 00:00:00 2001=0AFrom: Nikolay Bori=
sov <nborisov@suse.com>=0ADate: Mon, 22 Feb 2021 18:40:43 +0200=0ASubject: =
[PATCH 4/5] btrfs: export and rename qgroup_reserve_meta=0A=0Acommit 80e9ba=
ed722c853056e0c5374f51524593cb1031 upstream=0A=0ASigned-off-by: Nikolay Bor=
isov <nborisov@suse.com>=0AReviewed-by: David Sterba <dsterba@suse.com>=0AS=
igned-off-by: David Sterba <dsterba@suse.com>=0ASigned-off-by: Sudip Mukher=
jee <sudipm.mukherjee@gmail.com>=0A---=0A fs/btrfs/qgroup.c | 8 ++++----=0A=
 fs/btrfs/qgroup.h | 2 ++=0A 2 files changed, 6 insertions(+), 4 deletions(=
-)=0A=0Adiff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c=0Aindex 808370ad=
a888..14ff388fd3bd 100644=0A--- a/fs/btrfs/qgroup.c=0A+++ b/fs/btrfs/qgroup=
=2Ec=0A@@ -3841,8 +3841,8 @@ static int sub_root_meta_rsv(struct btrfs_root=
 *root, int num_bytes,=0A 	return num_bytes;=0A }=0A =0A-static int qgroup_=
reserve_meta(struct btrfs_root *root, int num_bytes,=0A-				enum btrfs_qgro=
up_rsv_type type, bool enforce)=0A+int btrfs_qgroup_reserve_meta(struct btr=
fs_root *root, int num_bytes,=0A+			      enum btrfs_qgroup_rsv_type type, =
bool enforce)=0A {=0A 	struct btrfs_fs_info *fs_info =3D root->fs_info;=0A =
	int ret;=0A@@ -3873,14 +3873,14 @@ int __btrfs_qgroup_reserve_meta(struct =
btrfs_root *root, int num_bytes,=0A {=0A 	int ret;=0A =0A-	ret =3D qgroup_r=
eserve_meta(root, num_bytes, type, enforce);=0A+	ret =3D btrfs_qgroup_reser=
ve_meta(root, num_bytes, type, enforce);=0A 	if (ret <=3D 0 && ret !=3D -ED=
QUOT)=0A 		return ret;=0A =0A 	ret =3D try_flush_qgroup(root);=0A 	if (ret =
< 0)=0A 		return ret;=0A-	return qgroup_reserve_meta(root, num_bytes, type,=
 enforce);=0A+	return btrfs_qgroup_reserve_meta(root, num_bytes, type, enfo=
rce);=0A }=0A =0A void btrfs_qgroup_free_meta_all_pertrans(struct btrfs_roo=
t *root)=0Adiff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h=0Aindex 50dea=
9a2d8fb..7283e4f549af 100644=0A--- a/fs/btrfs/qgroup.h=0A+++ b/fs/btrfs/qgr=
oup.h=0A@@ -361,6 +361,8 @@ int btrfs_qgroup_release_data(struct btrfs_inod=
e *inode, u64 start, u64 len);=0A int btrfs_qgroup_free_data(struct btrfs_i=
node *inode,=0A 			   struct extent_changeset *reserved, u64 start,=0A 			 =
  u64 len);=0A+int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int n=
um_bytes,=0A+			      enum btrfs_qgroup_rsv_type type, bool enforce);=0A in=
t __btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,=0A 		=
		enum btrfs_qgroup_rsv_type type, bool enforce);=0A /* Reserve metadata sp=
ace for pertrans and prealloc type */=0A-- =0A2.30.1=0A=0A=0AFrom 77f7e1c7c=
929b2041053df7a13328a8662bc45e4 Mon Sep 17 00:00:00 2001=0AFrom: Nikolay Bo=
risov <nborisov@suse.com>=0ADate: Mon, 22 Feb 2021 18:40:44 +0200=0ASubject=
: [PATCH 5/5] btrfs: don't flush from=0A btrfs_delayed_inode_reserve_metada=
ta=0A=0Acommit 4d14c5cde5c268a2bc26addecf09489cb953ef64 upstream=0A=0ACalli=
ng btrfs_qgroup_reserve_meta_prealloc from=0Abtrfs_delayed_inode_reserve_me=
tadata can result in flushing delalloc=0Awhile holding a transaction and de=
layed node locks. This is deadlock=0Aprone. In the past multiple commits:=
=0A=0A * ae5e070eaca9 ("btrfs: qgroup: don't try to wait flushing if we're=
=0Aalready holding a transaction")=0A=0A * 6f23277a49e6 ("btrfs: qgroup: do=
n't commit transaction when we already=0A hold the handle")=0A=0ATried to s=
olve various aspects of this but this was always a=0Awhack-a-mole game. Unf=
ortunately those 2 fixes don't solve a deadlock=0Ascenario involving btrfs_=
delayed_node::mutex. Namely, one thread=0Acan call btrfs_dirty_inode as a r=
esult of reading a file and modifying=0Aits atime:=0A=0A  PID: 6963   TASK:=
 ffff8c7f3f94c000  CPU: 2   COMMAND: "test"=0A  #0  __schedule at ffffffffa=
529e07d=0A  #1  schedule at ffffffffa529e4ff=0A  #2  schedule_timeout at ff=
ffffffa52a1bdd=0A  #3  wait_for_completion at ffffffffa529eeea             =
<-- sleeps with delayed node mutex held=0A  #4  start_delalloc_inodes at ff=
ffffffc0380db5=0A  #5  btrfs_start_delalloc_snapshot at ffffffffc0393836=0A=
  #6  try_flush_qgroup at ffffffffc03f04b2=0A  #7  __btrfs_qgroup_reserve_m=
eta at ffffffffc03f5bb6     <-- tries to reserve space and starts delalloc =
inodes.=0A  #8  btrfs_delayed_update_inode at ffffffffc03e31aa      <-- acq=
uires delayed node mutex=0A  #9  btrfs_update_inode at ffffffffc0385ba8=0A =
#10  btrfs_dirty_inode at ffffffffc038627b               <-- TRANSACTIION O=
PENED=0A #11  touch_atime at ffffffffa4cf0000=0A #12  generic_file_read_ite=
r at ffffffffa4c1f123=0A #13  new_sync_read at ffffffffa4ccdc8a=0A #14  vfs=
_read at ffffffffa4cd0849=0A #15  ksys_read at ffffffffa4cd0bd1=0A #16  do_=
syscall_64 at ffffffffa4a052eb=0A #17  entry_SYSCALL_64_after_hwframe at ff=
ffffffa540008c=0A=0AThis will cause an asynchronous work to flush the delal=
loc inodes to=0Ahappen which can try to acquire the same delayed_node mutex=
:=0A=0A  PID: 455    TASK: ffff8c8085fa4000  CPU: 5   COMMAND: "kworker/u16=
:30"=0A  #0  __schedule at ffffffffa529e07d=0A  #1  schedule at ffffffffa52=
9e4ff=0A  #2  schedule_preempt_disabled at ffffffffa529e80a=0A  #3  __mutex=
_lock at ffffffffa529fdcb                    <-- goes to sleep, never wakes=
 up.=0A  #4  btrfs_delayed_update_inode at ffffffffc03e3143      <-- tries =
to acquire the mutex=0A  #5  btrfs_update_inode at ffffffffc0385ba8        =
      <-- this is the same inode that pid 6963 is holding=0A  #6  cow_file_=
range_inline.constprop.78 at ffffffffc0386be7=0A  #7  cow_file_range at fff=
fffffc03879c1=0A  #8  btrfs_run_delalloc_range at ffffffffc038894c=0A  #9  =
writepage_delalloc at ffffffffc03a3c8f=0A #10  __extent_writepage at ffffff=
ffc03a4c01=0A #11  extent_write_cache_pages at ffffffffc03a500b=0A #12  ext=
ent_writepages at ffffffffc03a6de2=0A #13  do_writepages at ffffffffa4c277e=
b=0A #14  __filemap_fdatawrite_range at ffffffffa4c1e5bb=0A #15  btrfs_run_=
delalloc_work at ffffffffc0380987         <-- starts running delayed nodes=
=0A #16  normal_work_helper at ffffffffc03b706c=0A #17  process_one_work at=
 ffffffffa4aba4e4=0A #18  worker_thread at ffffffffa4aba6fd=0A #19  kthread=
 at ffffffffa4ac0a3d=0A #20  ret_from_fork at ffffffffa54001ff=0A=0ATo full=
y address those cases the complete fix is to never issue any=0Aflushing whi=
le holding the transaction or the delayed node lock. This=0Apatch achieves =
it by calling qgroup_reserve_meta directly which will=0Aeither succeed with=
out flushing or will fail and return -EDQUOT. In the=0Alatter case that ret=
urn value is going to be propagated to=0Abtrfs_dirty_inode which will fallb=
ack to start a new transaction. That's=0Afine as the majority of time we ex=
pect the inode will have=0ABTRFS_DELAYED_NODE_INODE_DIRTY flag set which wi=
ll result in directly=0Acopying the in-memory state.=0A=0AFixes: c53e965360=
5d ("btrfs: qgroup: try to flush qgroup space when we get -EDQUOT")=0ACC: s=
table@vger.kernel.org # 5.10+=0AReviewed-by: Qu Wenruo <wqu@suse.com>=0ASig=
ned-off-by: Nikolay Borisov <nborisov@suse.com>=0ASigned-off-by: David Ster=
ba <dsterba@suse.com>=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gm=
ail.com>=0A---=0A fs/btrfs/delayed-inode.c | 3 ++-=0A fs/btrfs/inode.c     =
    | 2 +-=0A 2 files changed, 3 insertions(+), 2 deletions(-)=0A=0Adiff --=
git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c=0Aindex f12e6a0aa=
3c7..a09912cf1852 100644=0A--- a/fs/btrfs/delayed-inode.c=0A+++ b/fs/btrfs/=
delayed-inode.c=0A@@ -627,7 +627,8 @@ static int btrfs_delayed_inode_reserv=
e_metadata(=0A 	 */=0A 	if (!src_rsv || (!trans->bytes_reserved &&=0A 			 s=
rc_rsv->type !=3D BTRFS_BLOCK_RSV_DELALLOC)) {=0A-		ret =3D btrfs_qgroup_re=
serve_meta_prealloc(root, num_bytes, true);=0A+		ret =3D btrfs_qgroup_reser=
ve_meta(root, num_bytes,=0A+					  BTRFS_QGROUP_RSV_META_PREALLOC, true);=
=0A 		if (ret < 0)=0A 			return ret;=0A 		ret =3D btrfs_block_rsv_add(root,=
 dst_rsv, num_bytes,=0Adiff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c=0Ai=
ndex 40ccb8ddab23..9b4f75568261 100644=0A--- a/fs/btrfs/inode.c=0A+++ b/fs/=
btrfs/inode.c=0A@@ -5916,7 +5916,7 @@ static int btrfs_dirty_inode(struct i=
node *inode)=0A 		return PTR_ERR(trans);=0A =0A 	ret =3D btrfs_update_inode=
(trans, root, BTRFS_I(inode));=0A-	if (ret && ret =3D=3D -ENOSPC) {=0A+	if =
(ret && (ret =3D=3D -ENOSPC || ret =3D=3D -EDQUOT)) {=0A 		/* whoops, lets =
try again with the full transaction */=0A 		btrfs_end_transaction(trans);=
=0A 		trans =3D btrfs_start_transaction(root, 1);=0A-- =0A2.30.1=0A=0A
--gkczKYIFLKEWnfby--
