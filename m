Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 257EF651C6E
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 09:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiLTIjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 03:39:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiLTIjW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 03:39:22 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4341A1
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 00:39:21 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id s196so7894284pgs.3
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 00:39:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E4wqUrpS76oGgY7oLcT4HTWSwOO2LEgnMgar0bldX7Y=;
        b=AvmAEsqkAEDIe79u4m3ELnuztMH4/KAyAXaR7+DSHBM0CbBY1xmUMyxZ0yaXIjXyTJ
         J7gKSKOf4naLlCFWBRlx0ZAg33/Ae0OuYrv6TCFNocpiqWIuK0ZDLGbHGEJMNVfqPqBS
         Ps8wsGYA6sI3xrRIkoTE4P+6ili1o17nwogciVnGwhblsdjdVHLLRKaANlCwDO7Fne6y
         /OG7PpRaRmP8klrZwqsxDG7AfvVwGRQK8zYjYvmRMpAmWeDiyWqvjaM0yxfnxFNM29gu
         eK4EvWWuR7h6dps0Bq/qNQ3j+aQy8u/UckjKbamauKXo0JmrQSTIpRgU6RBqli/ajE/g
         g6Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E4wqUrpS76oGgY7oLcT4HTWSwOO2LEgnMgar0bldX7Y=;
        b=Wi9eXKyEu+FfYcVQs8vT/WYYXdnmDBBiJOToQ0btfwP//Gxmwj11cIIm5fKS/B7zYx
         IwP0xjmkdYurotEH0dIjzeR/g4j25GCOzIwAOXy8+sU9+gk0yFrZvZnJpNWkIgssQsIB
         s6j1R3AOKTVr6jpEWmQFatcZnw+6e7kYIMy3kUnMWU4eYffEDLowTTapgBnxY7gBNcAu
         wKv5JWDcMj6xSjUJpZQkNzUP82rTHzM6drkVKh4/hkkOmVdxiwvVMR4MnLRX33utWBZE
         hcYMJ63+VudYQDcDucZMf/4IeKj1W6RGjk95D9RYpUokdKgAxzSTzCddnAavl9sJQOUl
         cRAA==
X-Gm-Message-State: ANoB5pmlwxN9DzyVe+bN/tF2EYa4MmVJWIAtiKZhwchMSHYGFcmR6+Xs
        mCnYoVDCQ5tshoQOXykB9Io+vg==
X-Google-Smtp-Source: AA0mqf7K1JJTdernGS6g9VGuY+9BUiAEgGYbfMArIt1TLaO+f769AF22VH1sxHjOCKssMxQVd2qi7w==
X-Received: by 2002:a05:6a00:1c89:b0:576:e33e:cd63 with SMTP id y9-20020a056a001c8900b00576e33ecd63mr41223534pfw.30.1671525560638;
        Tue, 20 Dec 2022 00:39:20 -0800 (PST)
Received: from niej-dt-7B47 (80.251.214.228.16clouds.com. [80.251.214.228])
        by smtp.gmail.com with ESMTPSA id y5-20020a623205000000b00575448ab0e9sm7981430pfy.123.2022.12.20.00.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 00:39:19 -0800 (PST)
Date:   Tue, 20 Dec 2022 16:39:27 +0800
From:   Jun Nie <jun.nie@linaro.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     stable@vger.kernel.org, djwong@kernel.org, jack@suse.cz,
        jlayton@kernel.org, lczerner@redhat.com,
        linux-ext4@vger.kernel.org, xuyang2018.jy@fujitsu.com
Subject: Re: [PATCH v1] ext4: Remove deprecated noacl/nouser_xattr options
Message-ID: <Y6F0vw1ZhuHPTlzQ@niej-dt-7B47>
References: <166431556706.3511882.843791619431401636.b4-ty@mit.edu>
 <20221216034116.869864-1-jun.nie@linaro.org>
 <Y5wGZG05uicAPscI@mit.edu>
 <CABymUCOzpfivVMcyx_Ut7kznx-ARi=VTx4qzGytg69njbeq_-A@mail.gmail.com>
 <Y6CUJ29YOWtLyeVA@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6CUJ29YOWtLyeVA@mit.edu>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 19, 2022 at 11:41:11AM -0500, Theodore Ts'o wrote:
> On Mon, Dec 19, 2022 at 05:23:18PM +0800, Jun Nie wrote:
> > 
> > Do you mean we have a chance to expand ea_inode in place for some
> > cases? If so, a new ea_inode with larger space should be created
> > to hold expanded ea_inode data, thus data have to be copied and written
> > out through memory in my mind. Or anything other than CPU/memory can
> > utilized for this to avoid memory usage, such as DMA?
> 
> There are two inodes in question here.  The first is the base inode,
> which in this case is /file0.  The second is the ea_inode which stores
> the value of one of the extended attributes.  In the syzkaller fuzzed
> file system, there is an ea_inode field which is already created; it
> contains a value which is too large to fit in the inode or the
> extended attribute block; but that's OK, because we can put it in a
> ea_inode.  Unfortunately, we are unnecessarily created and deleting
> the ea_inode (which contains the xattr *value*) when we move the xattr
> from in-inode storage to the external xattr block.
> 
> Extended attributes can be stored either in the on-disk inode, or in
> an extended attribute block.  The storage in the on-disk inode is
> limited, but extended attributes stored don't require a random access
> 4k read as in the case of the extended attribute block.  So we try to
> store extended attributes in the inode if possible --- especially the
> ones which might be accessed frequently, such as a POSIX ACL or a
> SELinux security id.
> 
> The ext4 inode is composed of two portions.  The base 128 byte inode,
> which is always present, and which is what was originally used in
> ext2.  And the "extra inode fields", which are these fields as
> currently defined at the end of struct ext4_inode:
> 
> 	__le16	i_extra_isize;
> 	__le16	i_checksum_hi;	/* crc32c(uuid+inum+inode) BE */
> 	__le32  i_ctime_extra;  /* extra Change time      (nsec << 2 | epoch) */
> 	__le32  i_mtime_extra;  /* extra Modification time(nsec << 2 | epoch) */
> 	__le32  i_atime_extra;  /* extra Access time      (nsec << 2 | epoch) */
> 	__le32  i_crtime;       /* File Creation time */
> 	__le32  i_crtime_extra; /* extra FileCreationtime (nsec << 2 | epoch) */
> 	__le32  i_version_hi;	/* high 32 bits for 64-bit version */
> 	__le32	i_projid;	/* Project ID */
> 
> The i_extra_isize is the field that is always present for inodes
> larger than 128 bytes and for which the ext4 file system feature
> EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE is enabled.  The i_extra_isize
> field tells us how many of the fields beyond the first 128 are
> present.  These fields are necessary for various "advanced" (newer
> than ext2) ext4 features, including metadata checksums, support for
> dates beyond 2038 and sub-second timestamp granularity, file creation
> time, 64-bit i_version, and the project id for project quotas.
> Everything beyond i_extra_isize is used for in-inode extended
> attributes.
> 
> Now, what if we need to add extra space for new ext4 features?  Well,
> ext4 has a way of expanding the extra inode fields, and one of the
> ways to trigger this is via the debugging mount option,
> debug_want_extra_isize.  In this particular syzbot reproducer, the
> mount option, "debug_want_extra_isize=128" sets the i_extra_isize
> field to maximum allowable size for a 256 byte inode size, and this
> means that all extended attributes should be ejected out from in-inode
> storage to the external extended attribute block.  We do this on a
> best efforts bases, when a modified inode is written back to the disk.
> 
> The lazytime mount option delays inode updates until the very last
> minute.  The reason for this is to avoid multiple writes to the inode
> table blocks.  This improves performance by reducing random 4k writes,
> and for flash based storage, reducing flash wearout for flash-based
> storage.  For hard drives (HDD's), it reducing random 4k writes
> reduces the need to perform Adjacent Track Interference (ATI)
> mitigations.  ATI mitigations can significantly increase the 99.9
> percentile tail latency on file system operations, and decreasing tail
> latency can be worth $$$ for some use cases[1].
> 
> [1] https://research.google/pubs/pub44830
> 
> The downside of using lazytime updates is that on a crash, the inode
> timestamps might not get updated --- but very often, this is not a big
> deal.  And normally, when some other inode in the same inode table
> block is updated, we take that opportunity to update all of the
> timestamps that were deferred.  Or, in the worst case, this will get
> delayed until the file system is unounted.
> 
> Now, back to the extra space expansion.  Eexpanding to allow extra
> inode fields to be used in the future is a "nice to have" sort of
> thing.  It can fail for a number of reasons, including there not being
> enough space in the extended attribute block to evict the extended
> attributes in the inode; or if the file system is full, we might not
> be able to allocate an external block for the extended attribute block
> in the first place.
> 
> So it's OK for us to simply pass on making space for the extra inode
> fields if it turns out we happen to be in the process of unmounting
> file system.  However, that doesn't fix the performance problem of
> unnecessarily deleting and creating the ea_inode when moving the xattr
> from the inode to the exernal xattr block.  So fixing that performance
> issue is the ideal solution.  Simply passing on the extra_isize
> expansion is the second best issue.  Backporting an unrelated fix[2]
> which papers over the problem by disallowing the mount option
> nouser_xattr is the worst option, since it doesn't actually fix the
> underlying file system bug.
> 
> [2] commit 2d544ec923dbe5 ("ext4: remove deprecated noacl/nouser_xattr
> options")
> 
> Backporting [2] will shut up the syzbot reproducer, yes.  But that's
> because the syzbot reproducer was inadequately minimized.  *This*
> reproducer, which is a easier for a human to understand and which is
> appropriately minimized will trigger exact same issue, with or without
> 
> #!/bin/bash -vx
> #
> # This reproduces an ext4 bug caused by an unfortunate interaction
> # between lazytime updates happening when a file system is being
> # unmounted and expand_extra_isize
> #
> # Initially discovered via syzkaller:
> # https://syzkaller.appspot.com/bug?id=3613786cb88c93aa1c6a279b1df6a7b201347d08
> #
> img=/tmp/foo.img
> dir=/mnt 
> file=$dir/file0
> 
> rm -f $img
> mke2fs -Fq -t ext4 -I 256 -O ea_inode -b 1024 $img 200k
> mount $img $dir
> v=$(dd if=/dev/zero bs=2000 count=1 2>/dev/null | tr '\0' =)
> touch $file
> attr -q -s test -V $v $file
> umount $dir
> mount -o debug_want_extra_isize=128,lazytime /tmp/foo.img $dir
> cat $file
> umount $dir
> 
> This is why your proposal to backport commit 2d544ec923dbe5 is not the
> right answer.
> 
> > per general understanding of a subsystem uninitialization, a flag
> > shall be marked to reject further operation on the sub-system and
> > flush the pending operation, then free the resource. In such a
> > general method, current handling to create a new ea_inode should not
> > crash even it is stupid.  sb->s_root seems to be a key global
> > resource in ext4 subsystem per my understanding, and should not be
> > set as NULL until the last step of unmount operation.
> 
> That's true in general.  And yes, simply bypassing the extra_isize
> expansion when the file system is being unmounted is certainly better
> that backporting the unrelated commit[2].  But the true correct fix is
> to optimize how we migrate the xattr from the in-inode storage to the
> external xattr block.
> 
> This is also at *best* P2 bug, since (a) it's not real security issue;
> just a null pointer derference, and there is no way this could be
> leveraged into any kind of denial of service or privilege escalation
> attack, and (b) it requires root access, and use of a debugging option
> to enable a code path which is in practice never used in production.
> It is a syzkaller report, and unfortunately, there seems to be this
> assumption that all syzkaller issues are P0 or P1 issues that must be
> remediated right away.  Which is not the case in this instance.  It's
> a real bug, and so it should be fixed; but it's not a high priority
> bug.
> 
> That being said, if you'd like ot become more experienced in a portion
> of ext4 internals, I'd certainly invite you to try to understand how
> ext4 extended attributes are managed, and try your hand at fixing this
> bug.
> 
> Best regards,
> 
> 						- Ted

Thanks for the elabration of the logic here. I guess below change is similiar
with what we are expecting. There are 2 question in the change I do not have
anwser yet.

But for the crash with NULL sb->s_root, below change does not impact anything
because all functions are still called. So I guess the protection with
rejecting further request during umount is still needed. Or I still missed
something?


 fs/ext4/xattr.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 7decaaf27e82..546808dbbdd6 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2551,9 +2551,8 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
 
 	is = kzalloc(sizeof(struct ext4_xattr_ibody_find), GFP_NOFS);
 	bs = kzalloc(sizeof(struct ext4_xattr_block_find), GFP_NOFS);
-	buffer = kvmalloc(value_size, GFP_NOFS);
 	b_entry_name = kmalloc(entry->e_name_len + 1, GFP_NOFS);
-	if (!is || !bs || !buffer || !b_entry_name) {
+	if (!is || !bs || !b_entry_name) {
 		error = -ENOMEM;
 		goto out;
 	}
@@ -2565,14 +2564,21 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
 
 	/* Save the entry name and the entry value */
 	if (entry->e_value_inum) {
+		buffer = kvmalloc(value_size, GFP_NOFS);
+		if (!buffer) {
+			error = -ENOMEM;
+			goto out;
+		}
+
 		error = ext4_xattr_inode_get(inode, entry, buffer, value_size);
 		if (error)
 			goto out;
 	} else {
 		size_t value_offs = le16_to_cpu(entry->e_value_offs);
-		memcpy(buffer, (void *)IFIRST(header) + value_offs, value_size);
+		buffer = (void *)IFIRST(header) + value_offs;
 	}
 
+	/* Can we reuse entry->e_name with assumption of \0 for all e_name? */
 	memcpy(b_entry_name, entry->e_name, entry->e_name_len);
 	b_entry_name[entry->e_name_len] = '\0';
 	i.name = b_entry_name;
@@ -2585,11 +2591,6 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
 	if (error)
 		goto out;
 
-	/* Remove the chosen entry from the inode */
-	error = ext4_xattr_ibody_set(handle, inode, &i, is);
-	if (error)
-		goto out;
-
 	i.value = buffer;
 	i.value_len = value_size;
 	error = ext4_xattr_block_find(inode, &i, bs);
@@ -2597,13 +2598,18 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
 		goto out;
 
 	/* Add entry which was removed from the inode into the block */
+	/* Can this function remove in inode xattr automatically? */
 	error = ext4_xattr_block_set(handle, inode, &i, bs);
 	if (error)
 		goto out;
-	error = 0;
+
+	/* Remove the chosen entry from the inode */
+	error = ext4_xattr_ibody_set(handle, inode, &i, is);
+
 out:
 	kfree(b_entry_name);
-	kvfree(buffer);
+	if (entry->e_value_inum && buffer)
+		kvfree(buffer);
 	if (is)
 		brelse(is->iloc.bh);
 	if (bs)
