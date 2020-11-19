Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501712B9BF0
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 21:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbgKSUXA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 15:23:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727312AbgKSUXA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 15:23:00 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B084C0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 12:22:59 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id m6so7774718wrg.7
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 12:22:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=qez6L+rX5HpFxk5ObyJfACaoVaEEVl1rQfVpcdNYovU=;
        b=Ddc/TOE7x+gB9I82aOJBCjIlXpbLF99qRfKhFVuXubfB5AIHl8w+tMSd0DFMPw5XYd
         e4n5yA+GP63nxvAWLfPsGhXhP2GtauWIf43l7/yCBIeqH6sb7PhC2oWDYoWg9X2zAHei
         CJXQioNYYp45LvSbxrG4kOyym/VViFcuOoULhBTQ6txVuUNMh2gsb0uyhXqkzLurAfxD
         i80I7WjuCQ4JDliMCXvIlyCsblE5zcvFqmkcglOhdAguTMwoPCojPGuPGwywOtJPF6JG
         tY3M29E0TtIfcmyjmjX757g0T6X1ok7cbfdizhvyFOUIPV+uQ7w0FQhsf2rnFb585NYl
         r4Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=qez6L+rX5HpFxk5ObyJfACaoVaEEVl1rQfVpcdNYovU=;
        b=iGTvHkZEQmAOVrMR5VGKvDEDiRmBJ7kwqar5mAyqYjQNAgNbTu2iHsaSiKZzgCcPQN
         qyQeBpasBNlaemq/lUun5DXGF3HoYYINbbcQMOQY1o6OJNnLlZm1Zg/CASlrz2cj3pPy
         X+hU0a+MjrnPBeYJiWgNwxsVVucEyb1ZqdCoruhU1arqpU1oPr/ixdyN/uR/FXWqYNrd
         JNfMhFUM2r9xaoN1mKkhz0l4FmRrMXf6TKJJ7eMQD0nbmuW+FM9lTgS2AbTLtCAt92wO
         eWOtfFtyLFgAruKnlG2B/fq0R9qPmLzEqeJ1eK4z9sPDvO+Cy7Al0dv2mObfVPMmLArK
         ZmJg==
X-Gm-Message-State: AOAM5317XLq4pZw93oEqUMkoUhRESH3mSzknCZ5JiZUFhVwH+T9QuW72
        A4iWgapU+1vQr55htGk7fJA=
X-Google-Smtp-Source: ABdhPJz/1pcZ1+i32QWX3xlGQXLLbTi/oHQ1azf9vuvntSbNw9JcBySH0VC3Nul4IN5cKLKfqrJHtQ==
X-Received: by 2002:a05:6000:c7:: with SMTP id q7mr11712239wrx.137.1605817376755;
        Thu, 19 Nov 2020 12:22:56 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id q12sm1443123wmc.45.2020.11.19.12.22.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 19 Nov 2020 12:22:56 -0800 (PST)
Date:   Thu, 19 Nov 2020 20:22:54 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, sashal@kernel.org
Cc:     stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Wen Xu <wen.xu@gatech.edu>, Christoph Hellwig <hch@lst.de>
Subject: backports of afca6c5b2595 and ee457001ed6c for 4.4-stable
Message-ID: <20201119202254.chd2av6h4baifgl6@debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fcwwhiaj6vpnk5gg"
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--fcwwhiaj6vpnk5gg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg, Sasha,

These two were missing in 4.4-stable. Please add to your queue.


--
Regards
Sudip

--fcwwhiaj6vpnk5gg
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-xfs-catch-inode-allocation-state-mismatch-corruption.patch"

From 854b2d25ca306bf5524f45dd4c12be6b532e0db0 Mon Sep 17 00:00:00 2001
From: Dave Chinner <dchinner@redhat.com>
Date: Fri, 23 Mar 2018 10:22:53 -0700
Subject: [PATCH 1/2] xfs: catch inode allocation state mismatch corruption

commit ee457001ed6c6f31ddad69c24c1da8f377d8472d upstream

We recently came across a V4 filesystem causing memory corruption
due to a newly allocated inode being setup twice and being added to
the superblock inode list twice. From code inspection, the only way
this could happen is if a newly allocated inode was not marked as
free on disk (i.e. di_mode wasn't zero).

Running the metadump on an upstream debug kernel fails during inode
allocation like so:

XFS: Assertion failed: ip->i_d.di_nblocks == 0, file: fs/xfs/xfs_inod=
e.c, line: 838
 ------------[ cut here ]------------
kernel BUG at fs/xfs/xfs_message.c:114!
invalid opcode: 0000 [#1] PREEMPT SMP
CPU: 11 PID: 3496 Comm: mkdir Not tainted 4.16.0-rc5-dgc #442
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/0=
1/2014
RIP: 0010:assfail+0x28/0x30
RSP: 0018:ffffc9000236fc80 EFLAGS: 00010202
RAX: 00000000ffffffea RBX: 0000000000004000 RCX: 0000000000000000
RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffff8227211b
RBP: ffffc9000236fce8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000bec R11: f000000000000000 R12: ffffc9000236fd30
R13: ffff8805c76bab80 R14: ffff8805c77ac800 R15: ffff88083fb12e10
FS:  00007fac8cbff040(0000) GS:ffff88083fd00000(0000) knlGS:0000000000000=
000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fffa6783ff8 CR3: 00000005c6e2b003 CR4: 00000000000606e0
Call Trace:
 xfs_ialloc+0x383/0x570
 xfs_dir_ialloc+0x6a/0x2a0
 xfs_create+0x412/0x670
 xfs_generic_create+0x1f7/0x2c0
 ? capable_wrt_inode_uidgid+0x3f/0x50
 vfs_mkdir+0xfb/0x1b0
 SyS_mkdir+0xcf/0xf0
 do_syscall_64+0x73/0x1a0
 entry_SYSCALL_64_after_hwframe+0x42/0xb7

Extracting the inode number we crashed on from an event trace and
looking at it with xfs_db:

xfs_db> inode 184452204
xfs_db> p
core.magic = 0x494e
core.mode = 0100644
core.version = 2
core.format = 2 (extents)
core.nlinkv2 = 1
core.onlink = 0
.....

Confirms that it is not a free inode on disk. xfs_repair
also trips over this inode:

.....
zero length extent (off = 0, fsbno = 0) in ino 184452204
correcting nextents for inode 184452204
bad attribute fork in inode 184452204, would clear attr fork
bad nblocks 1 for inode 184452204, would reset to 0
bad anextents 1 for inode 184452204, would reset to 0
imap claims in-use inode 184452204 is free, would correct imap
would have cleared inode 184452204
.....
disconnected inode 184452204, would move to lost+found

And so we have a situation where the directory structure and the
inobt thinks the inode is free, but the inode on disk thinks it is
still in use. Where this corruption came from is not possible to
diagnose, but we can detect it and prevent the kernel from oopsing
on lookup. The reproducer now results in:

$ sudo mkdir /mnt/scratch/{0,1,2,3,4,5}{0,1,2,3,4,5}
mkdir: cannot create directory =E2=80=98/mnt/scratch/00=E2=80=99: File ex=
ists
mkdir: cannot create directory =E2=80=98/mnt/scratch/01=E2=80=99: File ex=
ists
mkdir: cannot create directory =E2=80=98/mnt/scratch/03=E2=80=99: Structu=
re needs cleaning
mkdir: cannot create directory =E2=80=98/mnt/scratch/04=E2=80=99: Input/o=
utput error
mkdir: cannot create directory =E2=80=98/mnt/scratch/05=E2=80=99: Input/o=
utput error
....

And this corruption shutdown:

[   54.843517] XFS (loop0): Corruption detected! Free inode 0xafe846c not=
 marked free on disk
[   54.845885] XFS (loop0): Internal error xfs_trans_cancel at line 1023 =
of file fs/xfs/xfs_trans.c.  Caller xfs_create+0x425/0x670
[   54.848994] CPU: 10 PID: 3541 Comm: mkdir Not tainted 4.16.0-rc5-dgc #=
443
[   54.850753] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S 1.10.2-1 04/01/2014
[   54.852859] Call Trace:
[   54.853531]  dump_stack+0x85/0xc5
[   54.854385]  xfs_trans_cancel+0x197/0x1c0
[   54.855421]  xfs_create+0x425/0x670
[   54.856314]  xfs_generic_create+0x1f7/0x2c0
[   54.857390]  ? capable_wrt_inode_uidgid+0x3f/0x50
[   54.858586]  vfs_mkdir+0xfb/0x1b0
[   54.859458]  SyS_mkdir+0xcf/0xf0
[   54.860254]  do_syscall_64+0x73/0x1a0
[   54.861193]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[   54.862492] RIP: 0033:0x7fb73bddf547
[   54.863358] RSP: 002b:00007ffdaa553338 EFLAGS: 00000246 ORIG_RAX: 0000=
000000000053
[   54.865133] RAX: ffffffffffffffda RBX: 00007ffdaa55449a RCX: 00007fb73=
bddf547
[   54.866766] RDX: 0000000000000001 RSI: 00000000000001ff RDI: 00007ffda=
a55449a
[   54.868432] RBP: 00007ffdaa55449a R08: 00000000000001ff R09: 00005623a=
8670dd0
[   54.870110] R10: 00007fb73be72d5b R11: 0000000000000246 R12: 000000000=
00001ff
[   54.871752] R13: 00007ffdaa5534b0 R14: 0000000000000000 R15: 00007ffda=
a553500
[   54.873429] XFS (loop0): xfs_do_force_shutdown(0x8) called from line 1=
024 of file fs/xfs/xfs_trans.c.  Return address = ffffffff814cd050
[   54.882790] XFS (loop0): Corruption of in-memory data detected.  Shutt=
ing down filesystem
[   54.884597] XFS (loop0): Please umount the filesystem and rectify the =
problem(s)

Note that this crash is only possible on v4 filesystemsi or v5
filesystems mounted with the ikeep mount option. For all other V5
filesystems, this problem cannot occur because we don't read inodes
we are allocating from disk - we simply overwrite them with the new
inode information.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Tested-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
[sudip: use ip->i_d.di_mode instead of VFS_I(ip)->i_mode]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 fs/xfs/xfs_icache.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index adbc1f59969a..8ba4635ef1b3 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -298,7 +298,28 @@ xfs_iget_cache_miss(
 
 	trace_xfs_iget_miss(ip);
 
-	if ((ip->i_d.di_mode == 0) && !(flags & XFS_IGET_CREATE)) {
+
+	/*
+	 * If we are allocating a new inode, then check what was returned is
+	 * actually a free, empty inode. If we are not allocating an inode,
+	 * the check we didn't find a free inode.
+	 */
+	if (flags & XFS_IGET_CREATE) {
+		if (ip->i_d.di_mode != 0) {
+			xfs_warn(mp,
+"Corruption detected! Free inode 0x%llx not marked free on disk",
+				ino);
+			error = -EFSCORRUPTED;
+			goto out_destroy;
+		}
+		if (ip->i_d.di_nblocks != 0) {
+			xfs_warn(mp,
+"Corruption detected! Free inode 0x%llx has blocks allocated!",
+				ino);
+			error = -EFSCORRUPTED;
+			goto out_destroy;
+		}
+	} else if (ip->i_d.di_mode == 0) {
 		error = -ENOENT;
 		goto out_destroy;
 	}
-- 
2.11.0


--fcwwhiaj6vpnk5gg
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-xfs-validate-cached-inodes-are-free-when-allocated.patch"

From d4482f6f2ba67866effb065c564e521ee8e85959 Mon Sep 17 00:00:00 2001
From: Dave Chinner <dchinner@redhat.com>
Date: Tue, 17 Apr 2018 17:17:34 -0700
Subject: [PATCH 2/2] xfs: validate cached inodes are free when allocated

commit afca6c5b2595fc44383919fba740c194b0b76aff upstream

A recent fuzzed filesystem image cached random dcache corruption
when the reproducer was run. This often showed up as panics in
lookup_slow() on a null inode->i_ops pointer when doing pathwalks.

BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
....
Call Trace:
 lookup_slow+0x44/0x60
 walk_component+0x3dd/0x9f0
 link_path_walk+0x4a7/0x830
 path_lookupat+0xc1/0x470
 filename_lookup+0x129/0x270
 user_path_at_empty+0x36/0x40
 path_listxattr+0x98/0x110
 SyS_listxattr+0x13/0x20
 do_syscall_64+0xf5/0x280
 entry_SYSCALL_64_after_hwframe+0x42/0xb7

but had many different failure modes including deadlocks trying to
lock the inode that was just allocated or KASAN reports of
use-after-free violations.

The cause of the problem was a corrupt INOBT on a v4 fs where the
root inode was marked as free in the inobt record. Hence when we
allocated an inode, it chose the root inode to allocate, found it in
the cache and re-initialised it.

We recently fixed a similar inode allocation issue caused by inobt
record corruption problem in xfs_iget_cache_miss() in commit
ee457001ed6c ("xfs: catch inode allocation state mismatch
corruption"). This change adds similar checks to the cache-hit path
to catch it, and turns the reproducer into a corruption shutdown
situation.

Reported-by: Wen Xu <wen.xu@gatech.edu>
Signed-Off-By: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: fix typos in comment]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
[sudip: use ip->i_d.di_mode instead of VFS_I(ip)->i_mode]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 fs/xfs/xfs_icache.c | 73 +++++++++++++++++++++++++++++++++++------------------
 1 file changed, 48 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 8ba4635ef1b3..d8cdab4bfd30 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -135,6 +135,46 @@ xfs_inode_free(
 }
 
 /*
+ * If we are allocating a new inode, then check what was returned is
+ * actually a free, empty inode. If we are not allocating an inode,
+ * then check we didn't find a free inode.
+ *
+ * Returns:
+ *	0		if the inode free state matches the lookup context
+ *	-ENOENT		if the inode is free and we are not allocating
+ *	-EFSCORRUPTED	if there is any state mismatch at all
+ */
+static int
+xfs_iget_check_free_state(
+	struct xfs_inode	*ip,
+	int			flags)
+{
+	if (flags & XFS_IGET_CREATE) {
+		/* should be a free inode */
+		if (ip->i_d.di_mode != 0) {
+			xfs_warn(ip->i_mount,
+"Corruption detected! Free inode 0x%llx not marked free! (mode 0x%x)",
+				ip->i_ino, ip->i_d.di_mode);
+			return -EFSCORRUPTED;
+		}
+
+		if (ip->i_d.di_nblocks != 0) {
+			xfs_warn(ip->i_mount,
+"Corruption detected! Free inode 0x%llx has blocks allocated!",
+				ip->i_ino);
+			return -EFSCORRUPTED;
+		}
+		return 0;
+	}
+
+	/* should be an allocated inode */
+	if (ip->i_d.di_mode == 0)
+		return -ENOENT;
+
+	return 0;
+}
+
+/*
  * Check the validity of the inode we just found it the cache
  */
 static int
@@ -183,12 +223,12 @@ xfs_iget_cache_hit(
 	}
 
 	/*
-	 * If lookup is racing with unlink return an error immediately.
+	 * Check the inode free state is valid. This also detects lookup
+	 * racing with unlinks.
 	 */
-	if (ip->i_d.di_mode == 0 && !(flags & XFS_IGET_CREATE)) {
-		error = -ENOENT;
+	error = xfs_iget_check_free_state(ip, flags);
+	if (error)
 		goto out_error;
-	}
 
 	/*
 	 * If IRECLAIMABLE is set, we've torn down the VFS inode already.
@@ -300,29 +340,12 @@ xfs_iget_cache_miss(
 
 
 	/*
-	 * If we are allocating a new inode, then check what was returned is
-	 * actually a free, empty inode. If we are not allocating an inode,
-	 * the check we didn't find a free inode.
+	 * Check the inode free state is valid. This also detects lookup
+	 * racing with unlinks.
 	 */
-	if (flags & XFS_IGET_CREATE) {
-		if (ip->i_d.di_mode != 0) {
-			xfs_warn(mp,
-"Corruption detected! Free inode 0x%llx not marked free on disk",
-				ino);
-			error = -EFSCORRUPTED;
-			goto out_destroy;
-		}
-		if (ip->i_d.di_nblocks != 0) {
-			xfs_warn(mp,
-"Corruption detected! Free inode 0x%llx has blocks allocated!",
-				ino);
-			error = -EFSCORRUPTED;
-			goto out_destroy;
-		}
-	} else if (ip->i_d.di_mode == 0) {
-		error = -ENOENT;
+	error = xfs_iget_check_free_state(ip, flags);
+	if (error)
 		goto out_destroy;
-	}
 
 	/*
 	 * Preload the radix tree so we can insert safely under the
-- 
2.11.0


--fcwwhiaj6vpnk5gg--
