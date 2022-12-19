Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A411650AEC
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 12:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbiLSLrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 06:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbiLSLq7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 06:46:59 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4C0126;
        Mon, 19 Dec 2022 03:46:57 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 470913775A;
        Mon, 19 Dec 2022 11:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1671450416; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8PLpq08hYS32a9hTgPMGH96ayJ7ZKf8bRnkNOAy+CBM=;
        b=aqwd3+4Mt00ehjYm/09J8Oi5FAg+RKrJnqP9a71MYPZvbJpNkt2jND7swlxqQn1ZxJRgsT
        ebNjcDUdV8yuwIV3dZpuuxMG2tEo7KgLpxHdcR8tTbdRZiplHtyBDmm+vxJUAIJRbrfFyq
        dlOZIm9wqfwzFtHIQti+Eim4eRyPSIA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1671450416;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8PLpq08hYS32a9hTgPMGH96ayJ7ZKf8bRnkNOAy+CBM=;
        b=Zfq4kZ+8AwUQ9g2w6Wdd2trKtoTdpVLFRnDOcOxMoHkJp7/dVswcVDITMFXaeiiFHbpWJm
        e3CWoCCod3z6nOBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 30B4813910;
        Mon, 19 Dec 2022 11:46:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id IkYrDDBPoGPEYwAAMHmgww
        (envelope-from <jack@suse.cz>); Mon, 19 Dec 2022 11:46:56 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 8DEE0A0732; Mon, 19 Dec 2022 12:46:55 +0100 (CET)
Date:   Mon, 19 Dec 2022 12:46:55 +0100
From:   Jan Kara <jack@suse.cz>
To:     Jun Nie <jun.nie@linaro.org>
Cc:     Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org,
        djwong@kernel.org, jack@suse.cz, jlayton@kernel.org,
        lczerner@redhat.com, linux-ext4@vger.kernel.org,
        xuyang2018.jy@fujitsu.com
Subject: Re: [PATCH v1] ext4: Remove deprecated noacl/nouser_xattr options
Message-ID: <20221219114655.y2nqyli7y4p2ob5h@quack3>
References: <166431556706.3511882.843791619431401636.b4-ty@mit.edu>
 <20221216034116.869864-1-jun.nie@linaro.org>
 <Y5wGZG05uicAPscI@mit.edu>
 <CABymUCOzpfivVMcyx_Ut7kznx-ARi=VTx4qzGytg69njbeq_-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABymUCOzpfivVMcyx_Ut7kznx-ARi=VTx4qzGytg69njbeq_-A@mail.gmail.com>
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 19-12-22 17:23:18, Jun Nie wrote:
> Theodore Ts'o <tytso@mit.edu> 于2022年12月16日周五 13:47写道：
> >
> > On Fri, Dec 16, 2022 at 11:41:16AM +0800, Jun Nie wrote:
> > > This patch[1] is needed on linux-5.15.y because the panic[2] is also found on
> > > linux-5.15.y when debugging bug[3]. Back ported patch[4] is confirmed to fix
> > > the bug on linux-5.15.y in the latest test of page[3]. Maybe back port on more
> > > branches is needed per patch comments.
> >
> > This is not a proper fix for the syzkaller report being reported here:
> >
> > https://syzkaller.appspot.com/bug?id=3613786cb88c93aa1c6a279b1df6a7b201347d08
> >
> > It's true that the reproducer will no longer trigger, but that's just
> > because the reproducer is just exiting early because it is passing in
> > a mount option which is no longer being accepted.  In fact, that mount
> > option is completely unneeded and it's a failing of syzkaller that it
> > doesn't adequately minimize the reproducer by trying to remove various
> > random mount options that are not actually needed.  For example,
> > running the reproducer will trigger warnings like this:
> >
> >         EXT4-fs: Ignoring removed nobh option
> >
> > If we modify the kernel to simply ignore nouser_xattr, then the
> > reproducer will still trigger.  So this is not the right patch to
> > backport.
> >
> > It's important that people who are trying to fix syzkaller bugs
> > understand what is fundamentally going on, instead of using blunt
> > force patches that simple paper over the issue.  Please remember that
> > syzkaller is supposed to help us improve the kernel, and it's not just
> > about trying to reduce the count of open syzkaller reports for its own
> > sake.  (This is really much more of a quality of implementation issue,
> > since this is not something that would really ever trigger in real
> > life, nor is it really a security issue --- despite some people
> > thinking that all syzkaller reports are actually security issues, and
> > we must run around like chickens with their heads cut off and until
> > they are all fixed.)
> >
> >
> > The real root cause of the problem is that the file system is getting
> > mounted with these mount options:
> >
> > nouser_xattr,acl,debug_want_extra_isize=0x0000000000000080,lazytime,nobh,quota
> >
> > Of which nouser_attr, acl, nobh, and quota are completely pointless.
> > It's also **super** unfortunate that the reproducer isn't written in
> > C, but this horrible psuedo-assimply language:
> >
> >   memcpy(
> >       (void*)0x20000000,
> >       "\x6e\x6f\x75\x73\x65\x72\x5f\x78\x61\x74\x74\x72\x2c\x61\x63\x6c\x2c\x64"
> >       "\x65\x62\x75\x67\x5f\x77\x61\x6e\x74\x5f\x65\x78\x74\x72\x61\x5f\x69\x73"
> >       "\x69\x7a\x65\x3d\x30\x78\x30\x30\x30\x30\x30\x30\x30\x30\x30\x30\x30\x30"
> >       "\x30\x30\x38\x30\x2c\x6c\x61\x7a\x79\x74\x69\x6d\x65\x2c\x6e\x6f\x62\x68"
> >       "\x2c\x71\x75\x6f\x74\x61\x2c\x00\x3d\x93\x09\x61\x36\x5d\x73\x58\x9c",
> >       89);
> >
> >       ...
> >   syz_mount_image(0x20000440, 0x20000480, 0x1e, 0x20000000, 2, 0x427,
> >                                                 ^^^^^^^^^^
> >                   0x200004c0);
> >
> > (And again, this is stuff that I've complained to the syzkaller team
> > for years and years and years as being fundamentally developer hostile
> > and disrespects the time of upstream maintainers.  ARGH!!!!)
> >
> > Anyway.....  So now let's look at the stack trace:
> >
> >  ext4_xattr_block_set+0x8f8/0x3820 fs/ext4/xattr.c:1971
> >  ext4_xattr_move_to_block fs/ext4/xattr.c:2603 [inline]
> >  ext4_xattr_make_inode_space fs/ext4/xattr.c:2672 [inline]
> >  ext4_expand_extra_isize_ea+0x1591/0x1f30 fs/ext4/xattr.c:2764
> >  __ext4_expand_extra_isize+0x29e/0x3d0 fs/ext4/inode.c:5826
> >  ext4_try_to_expand_extra_isize fs/ext4/inode.c:5869 [inline]
> >  __ext4_mark_inode_dirty+0x4bf/0x7a0 fs/ext4/inode.c:5947
> >  ext4_dirty_inode+0xbc/0x100 fs/ext4/inode.c:5979
> >  __mark_inode_dirty+0x1f9/0x9d0 fs/fs-writeback.c:2431
> >  mark_inode_dirty_sync include/linux/fs.h:2429 [inline]
> >  iput+0x155/0x7d0 fs/inode.c:1686
> >  dentry_unlink_inode+0x349/0x430 fs/dcache.c:376
> >  __dentry_kill+0x3e2/0x5d0 fs/dcache.c:582
> >  shrink_dentry_list+0x379/0x4d0 fs/dcache.c:1176
> >  shrink_dcache_parent+0xcd/0x350
> >  do_one_tree fs/dcache.c:1657 [inline]
> >  shrink_dcache_for_umount+0x7c/0x1a0 fs/dcache.c:1674
> >  generic_shutdown_super+0x69/0x2d0 fs/super.c:447
> >  kill_block_super+0x80/0xe0 fs/super.c:1395
> >
> > Because lazytime is enabled, after running the reproducer under
> > strace, what happens is that inode #12 gets touched so its access time
> > is modified, but because lazytime is enabled, we don't actually update
> > the on-disk until we actually unmount the superblock.  That's why
> > generic_shutdown_super() is in the stack trace.
> >
> > At that point, when we shrink the dentry cache, when we eject the
> > inode from memory, iput() needs to update the on-disk inode with the
> > updated atime.  So far, so good.  But then we call ext4_dirty_inode(),
> > and then that interacts with the "debug_want_extra_isize-=128" mount
> > option.  So at this point, we try to expand inode's extra isize space,
> > and in order to do that we have to move some extended attributes.
> >
> > Unfortunately, how ext4 currently does this is a bit stupid, and it
> > reads the contents of the ea_inode into memory, deletes the ea_inode
> > and then creates a new ea_inode.  That works, but it's horribly
> > inefficient, and **that's*** what we should actually fix.
> 
> Hi Theodore,
> 
> Thanks for the detailed explanation here! I am new in syzkaller task force
>  and not familiar with ext4 subsystem. So my reply here may be stupid
> as a new comer in ext4 side.
> 
> Do you mean we have a chance to expand ea_inode in place for some
> cases? If so, a new ea_inode with larger space should be created
> to hold expanded ea_inode data, thus data have to be copied and written
> out through memory in my mind. Or anything other than CPU/memory can
> utilized for this to avoid memory usage, such as DMA?

There are two things you seem to be mixing together so let me explain in a
bit more detail:

There is normal inode which has some extented attributes. In the filesystem
image created by syzbot, *headers* of these extended attributes are stored
in the inode. The actual extended attribute content is stored in other
inodes - so called ea_inodes. The mount option "debug_want_extra_isize" asks
the kernel to make more space in the inode itself (say for higher precision
time stamps) so we have now less space for extended attribute headers and
we need to move them to an external block. How we currently do it is that
we read the whole extended attribute in memory, delete the extended
attribute, and then pretend the user called setxattr(2) to store the
extended atribute header in the freshly allocated block and the attribute
data itself in the newly allocated ea_inode. This works but it is
inefficient as we could have just moved the extended attribute header from
the inode into the newly allocated block, keep the ea_inode and be done
with it...

> > Unfortunately, because we try to create a new ea_inode, when
> > ext4_xattr_block_set() calls the static function (which gets inlined)
> > ext4_xattr_inode_create(), and at that point, the call to
> > ext4_new_inode trips over the fact that the file system is being
> > unmoutned, and sb->s_root has already been set to NULL.
> >
> per general understanding of a subsystem uninitialization, a flag shall be
> marked to reject further operation on the sub-system and flush the pending
> operation, then free the resource. In such a general method, current
> handling to create a new ea_inode should not crash even it is stupid.
> sb->s_root seems to be a key global resource in ext4 subsystem per my
> understanding, and should not be set as NULL until the last step of unmount
>  operation.
> 
> Please help teach me what is wrong in my understanding.

Well, sb->s_root is important but actually not that much because it just
speaks about how the filesystem is attached to the overall directory
hierarchy. In particular while sb->s_root is set, it pins corresponding
inode in memory so we cannot fully cleanup the filesystem. So I think
clearing sb->s_root during unmount process is fine where it is. It is the
ea_inode handling that should be tweaked to avoid issues.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
