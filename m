Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEB7A5E5DED
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 10:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiIVIuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 04:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiIVIuO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 04:50:14 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6616661DB3;
        Thu, 22 Sep 2022 01:50:13 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id n10so14304170wrw.12;
        Thu, 22 Sep 2022 01:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=IbHmDlkI8PWGiRIhKV3Nxtu4KGb99fNIelKZ9TKdJDo=;
        b=SUmPm7gc5cElvH2/gCaFcawYNGdwCmOM+TAHUa54w1AnkH3QpQw/I99c/X3XF3HTKD
         f2B423MOCSfM8brtXVPlYWB4h7CoZHz1YYNlh8wbCgPw5py+5XG8Jktg7bZvCXBF0OfE
         S+BD0Lk4J9d5erkJ2xaOioVtfRN2+gnn5k6KhcOT5fVHBT72aGQoQ/DMvFjQtxjHabmI
         NEARBo6WOjSnM1FEBjotCTh3jqqRFUnCScllPHhpx8uQolX3o2rOaOTyzoHr9yWoFPqN
         KOZbWX0ZgwzoAHyAkwEUmI2X8eyYlTw16HQ/0c91DpXY9lBrh8pPucL7iX65b+9OCG6m
         3ntg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=IbHmDlkI8PWGiRIhKV3Nxtu4KGb99fNIelKZ9TKdJDo=;
        b=i45zlvi/mgEmZiqeUwPoGjgBEDVC8mT6XR1T2Ky0AS3Gm1xqrFoS62KmmnRug6NuYp
         yOve6i6Bc3d5udwmZYBTVcvnbe1iXh61Sybz7W7MpXDBPydlixRjBK1roREZw6PbriO4
         7HWvTVG79YYhLTKGxjCrvCm8akq4mPm1QelU+F7cC5LSwnyb5R9KyrtJxK7WsnTtchI1
         bA5F2SMm66kFSj9FCp4Pp2pjWc6G77mMr873JewBPdRSLd6tBNulPSjx1/rbtGfwcfvN
         SDN9gnal6ISdxn4hRFLfZhd2I5DhTc6HtGzUeSNpfk1Ce5k1AVBWyHRtNclzwB3UZMlG
         mi7A==
X-Gm-Message-State: ACrzQf2ncl3MOWvahWgw5bSNu8EOWjGgd0+GrZ9xvhfLe5K0spXKGHQ0
        a/XMDNmH8oxsv9/4sH6CY/0=
X-Google-Smtp-Source: AMsMyM7xahyZpM0t4vES63vBpiRq9Ej2ySYFoIw99YR3jqJB7+IsC71lJRf4bcZlxD8qlqE9fU8PPA==
X-Received: by 2002:a5d:5c06:0:b0:22a:7b52:cda6 with SMTP id cc6-20020a5d5c06000000b0022a7b52cda6mr1220476wrb.485.1663836611695;
        Thu, 22 Sep 2022 01:50:11 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.8.191])
        by smtp.gmail.com with ESMTPSA id x12-20020adfffcc000000b0022ac672654dsm4434722wrs.58.2022.09.22.01.50.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 01:50:11 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Varsha Teratipally <teratipally@google.com>,
        Christian Brauner <brauner@kernel.org>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 5.10] xfs: fix up non-directory creation in SGID directories
Date:   Thu, 22 Sep 2022 11:49:56 +0300
Message-Id: <20220922084956.74262-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 01ea173e103edd5ec41acec65b9261b87e123fc2 upstream.

XFS always inherits the SGID bit if it is set on the parent inode, while
the generic inode_init_owner does not do this in a few cases where it can
create a possible security problem, see commit 0fa3ecd87848
("Fix up non-directory creation in SGID directories") for details.

Switch XFS to use the generic helper for the normal path to fix this,
just keeping the simple field inheritance open coded for the case of the
non-sgid case with the bsdgrpid mount option.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-off-by: Darrick J. Wong <djwong@kernel.org>
---

Hi Greg,

This is an old debt of a patch that was dropped during review of my
batch of 5.10.y xfs backports from v5.12 [1].

Recently, Varsha requested the inclusion of this fix in 5.10.y
and Darrick has Acked it [2].

I have another series of SGID related fixes that also apply to 5.15.y
which I am collaborating on testing with Leah, but as both Christian and
Christoph commented in the original patch review [3], this fix from
v5.12 is independent of the rest of the SGID fixes and is well worth
backporting.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-xfs/20220606143255.685988-1-amir73il@gmail.com/
[2] https://lore.kernel.org/linux-xfs/YyIDzPTn99XLTCFp@magnolia/
[3] https://lore.kernel.org/linux-xfs/20220608082654.GA16753@lst.de/

 fs/xfs/xfs_inode.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 929ed3bc5619..19008838df76 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -802,6 +802,7 @@ xfs_ialloc(
 	xfs_buf_t	**ialloc_context,
 	xfs_inode_t	**ipp)
 {
+	struct inode	*dir = pip ? VFS_I(pip) : NULL;
 	struct xfs_mount *mp = tp->t_mountp;
 	xfs_ino_t	ino;
 	xfs_inode_t	*ip;
@@ -847,18 +848,17 @@ xfs_ialloc(
 		return error;
 	ASSERT(ip != NULL);
 	inode = VFS_I(ip);
-	inode->i_mode = mode;
 	set_nlink(inode, nlink);
-	inode->i_uid = current_fsuid();
 	inode->i_rdev = rdev;
 	ip->i_d.di_projid = prid;
 
-	if (pip && XFS_INHERIT_GID(pip)) {
-		inode->i_gid = VFS_I(pip)->i_gid;
-		if ((VFS_I(pip)->i_mode & S_ISGID) && S_ISDIR(mode))
-			inode->i_mode |= S_ISGID;
+	if (dir && !(dir->i_mode & S_ISGID) &&
+	    (mp->m_flags & XFS_MOUNT_GRPID)) {
+		inode->i_uid = current_fsuid();
+		inode->i_gid = dir->i_gid;
+		inode->i_mode = mode;
 	} else {
-		inode->i_gid = current_fsgid();
+		inode_init_owner(inode, dir, mode);
 	}
 
 	/*
-- 
2.25.1

