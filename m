Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32DC965094A
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 10:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbiLSJXW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 04:23:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiLSJXU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 04:23:20 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C8463D3
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 01:23:18 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id m29so12522140lfo.11
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 01:23:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3WWCw8hdgDshNdgiNAFFAXmAR/wW6qe9G0Pb3oL4LAU=;
        b=o+qtjQLd4EY4gReAdX0jgULzx/e1a738K2vkez4SWc/4ERvg50kTaHBYJ5PqvDqJur
         pVbSYzCvaxezHAArOalVK6uvw1oBzmR9OmSBYJMrVV3gEiAuXb80yN1K/wILdPuNgdrG
         RPCoB8QNLoiDL6uE7WWTqUlzWagLGNVZ/87j+peK237uGVCV8S0pfVPx08EQS5uKWvao
         0Ikape2zHvxqFmqB+rCxNevJjdmox2Z6pdT7vBB0vzfSlVKyk3oy4JywXCwNCVIHhZd6
         iE983i3JHs0sDT+ycAF+FjEMSLj7w3RXb62VUi/hFc0T2iA2ox6hLPcPapEjTYQkporD
         y8YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3WWCw8hdgDshNdgiNAFFAXmAR/wW6qe9G0Pb3oL4LAU=;
        b=x7apCnQqn0Q18ynN6CzrZFQZVKs6m3w7dftftYdwvpLeiKkbD83ZBe/8LG6YTgR2J9
         XTKsx5kncQAzPO3hqgz4J6Uv2qpnCMH57OHYjAPKJ5yMC4lkQWd0AMAeMZMdg5UUHtnZ
         3DbO8w05VxFa4wUn0ImiH+rGqdzPyxLNtZ2wpImM4kjxJw2DI/b6Afz5D6M0I3JQXs6K
         YZI1NhLpt9v3e0NZSUAOK+Tg2D/7eLD0VMJzFQeBs7SVRpFyuYh2bwQeayVCTa7D2DDL
         phGEIhnnkX1HYcpDcynUnFtpL9F2UURnCXtmnykoZyttAznTRf5tKmjBxCUvNgC+BY87
         MAhg==
X-Gm-Message-State: ANoB5plrbHY8bbrK3b57im5x25HBYuHPLA+/6rFFP0EwcbUAuOXz4qij
        0RNB86G68ZRGsQ28qFKD3o4uQ9cjUKXPxiQOpeZOqg==
X-Google-Smtp-Source: AA0mqf6HT6kUBWDHx4SUPlQotkPIIcJ6MTX6Yt9W2/y6/Am47sbQfk0syldgyvZdDNtYksHvhuCieG5slbFTHRDbs5A=
X-Received: by 2002:a05:6512:4029:b0:4b5:5ae8:e513 with SMTP id
 br41-20020a056512402900b004b55ae8e513mr9084613lfb.100.1671441797150; Mon, 19
 Dec 2022 01:23:17 -0800 (PST)
MIME-Version: 1.0
References: <166431556706.3511882.843791619431401636.b4-ty@mit.edu>
 <20221216034116.869864-1-jun.nie@linaro.org> <Y5wGZG05uicAPscI@mit.edu>
In-Reply-To: <Y5wGZG05uicAPscI@mit.edu>
From:   Jun Nie <jun.nie@linaro.org>
Date:   Mon, 19 Dec 2022 17:23:18 +0800
Message-ID: <CABymUCOzpfivVMcyx_Ut7kznx-ARi=VTx4qzGytg69njbeq_-A@mail.gmail.com>
Subject: Re: [PATCH v1] ext4: Remove deprecated noacl/nouser_xattr options
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     stable@vger.kernel.org, djwong@kernel.org, jack@suse.cz,
        jlayton@kernel.org, lczerner@redhat.com,
        linux-ext4@vger.kernel.org, xuyang2018.jy@fujitsu.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Theodore Ts'o <tytso@mit.edu> =E4=BA=8E2022=E5=B9=B412=E6=9C=8816=E6=97=A5=
=E5=91=A8=E4=BA=94 13:47=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, Dec 16, 2022 at 11:41:16AM +0800, Jun Nie wrote:
> > This patch[1] is needed on linux-5.15.y because the panic[2] is also fo=
und on
> > linux-5.15.y when debugging bug[3]. Back ported patch[4] is confirmed t=
o fix
> > the bug on linux-5.15.y in the latest test of page[3]. Maybe back port =
on more
> > branches is needed per patch comments.
>
> This is not a proper fix for the syzkaller report being reported here:
>
> https://syzkaller.appspot.com/bug?id=3D3613786cb88c93aa1c6a279b1df6a7b201=
347d08
>
> It's true that the reproducer will no longer trigger, but that's just
> because the reproducer is just exiting early because it is passing in
> a mount option which is no longer being accepted.  In fact, that mount
> option is completely unneeded and it's a failing of syzkaller that it
> doesn't adequately minimize the reproducer by trying to remove various
> random mount options that are not actually needed.  For example,
> running the reproducer will trigger warnings like this:
>
>         EXT4-fs: Ignoring removed nobh option
>
> If we modify the kernel to simply ignore nouser_xattr, then the
> reproducer will still trigger.  So this is not the right patch to
> backport.
>
> It's important that people who are trying to fix syzkaller bugs
> understand what is fundamentally going on, instead of using blunt
> force patches that simple paper over the issue.  Please remember that
> syzkaller is supposed to help us improve the kernel, and it's not just
> about trying to reduce the count of open syzkaller reports for its own
> sake.  (This is really much more of a quality of implementation issue,
> since this is not something that would really ever trigger in real
> life, nor is it really a security issue --- despite some people
> thinking that all syzkaller reports are actually security issues, and
> we must run around like chickens with their heads cut off and until
> they are all fixed.)
>
>
> The real root cause of the problem is that the file system is getting
> mounted with these mount options:
>
> nouser_xattr,acl,debug_want_extra_isize=3D0x0000000000000080,lazytime,nob=
h,quota
>
> Of which nouser_attr, acl, nobh, and quota are completely pointless.
> It's also **super** unfortunate that the reproducer isn't written in
> C, but this horrible psuedo-assimply language:
>
>   memcpy(
>       (void*)0x20000000,
>       "\x6e\x6f\x75\x73\x65\x72\x5f\x78\x61\x74\x74\x72\x2c\x61\x63\x6c\x=
2c\x64"
>       "\x65\x62\x75\x67\x5f\x77\x61\x6e\x74\x5f\x65\x78\x74\x72\x61\x5f\x=
69\x73"
>       "\x69\x7a\x65\x3d\x30\x78\x30\x30\x30\x30\x30\x30\x30\x30\x30\x30\x=
30\x30"
>       "\x30\x30\x38\x30\x2c\x6c\x61\x7a\x79\x74\x69\x6d\x65\x2c\x6e\x6f\x=
62\x68"
>       "\x2c\x71\x75\x6f\x74\x61\x2c\x00\x3d\x93\x09\x61\x36\x5d\x73\x58\x=
9c",
>       89);
>
>       ...
>   syz_mount_image(0x20000440, 0x20000480, 0x1e, 0x20000000, 2, 0x427,
>                                                 ^^^^^^^^^^
>                   0x200004c0);
>
> (And again, this is stuff that I've complained to the syzkaller team
> for years and years and years as being fundamentally developer hostile
> and disrespects the time of upstream maintainers.  ARGH!!!!)
>
> Anyway.....  So now let's look at the stack trace:
>
>  ext4_xattr_block_set+0x8f8/0x3820 fs/ext4/xattr.c:1971
>  ext4_xattr_move_to_block fs/ext4/xattr.c:2603 [inline]
>  ext4_xattr_make_inode_space fs/ext4/xattr.c:2672 [inline]
>  ext4_expand_extra_isize_ea+0x1591/0x1f30 fs/ext4/xattr.c:2764
>  __ext4_expand_extra_isize+0x29e/0x3d0 fs/ext4/inode.c:5826
>  ext4_try_to_expand_extra_isize fs/ext4/inode.c:5869 [inline]
>  __ext4_mark_inode_dirty+0x4bf/0x7a0 fs/ext4/inode.c:5947
>  ext4_dirty_inode+0xbc/0x100 fs/ext4/inode.c:5979
>  __mark_inode_dirty+0x1f9/0x9d0 fs/fs-writeback.c:2431
>  mark_inode_dirty_sync include/linux/fs.h:2429 [inline]
>  iput+0x155/0x7d0 fs/inode.c:1686
>  dentry_unlink_inode+0x349/0x430 fs/dcache.c:376
>  __dentry_kill+0x3e2/0x5d0 fs/dcache.c:582
>  shrink_dentry_list+0x379/0x4d0 fs/dcache.c:1176
>  shrink_dcache_parent+0xcd/0x350
>  do_one_tree fs/dcache.c:1657 [inline]
>  shrink_dcache_for_umount+0x7c/0x1a0 fs/dcache.c:1674
>  generic_shutdown_super+0x69/0x2d0 fs/super.c:447
>  kill_block_super+0x80/0xe0 fs/super.c:1395
>
> Because lazytime is enabled, after running the reproducer under
> strace, what happens is that inode #12 gets touched so its access time
> is modified, but because lazytime is enabled, we don't actually update
> the on-disk until we actually unmount the superblock.  That's why
> generic_shutdown_super() is in the stack trace.
>
> At that point, when we shrink the dentry cache, when we eject the
> inode from memory, iput() needs to update the on-disk inode with the
> updated atime.  So far, so good.  But then we call ext4_dirty_inode(),
> and then that interacts with the "debug_want_extra_isize-=3D128" mount
> option.  So at this point, we try to expand inode's extra isize space,
> and in order to do that we have to move some extended attributes.
>
> Unfortunately, how ext4 currently does this is a bit stupid, and it
> reads the contents of the ea_inode into memory, deletes the ea_inode
> and then creates a new ea_inode.  That works, but it's horribly
> inefficient, and **that's*** what we should actually fix.

Hi Theodore,

Thanks for the detailed explanation here! I am new in syzkaller task force
 and not familiar with ext4 subsystem. So my reply here may be stupid
as a new comer in ext4 side.

Do you mean we have a chance to expand ea_inode in place for some
cases? If so, a new ea_inode with larger space should be created
to hold expanded ea_inode data, thus data have to be copied and written
out through memory in my mind. Or anything other than CPU/memory can
utilized for this to avoid memory usage, such as DMA?
>
> Unfortunately, because we try to create a new ea_inode, when
> ext4_xattr_block_set() calls the static function (which gets inlined)
> ext4_xattr_inode_create(), and at that point, the call to
> ext4_new_inode trips over the fact that the file system is being
> unmoutned, and sb->s_root has already been set to NULL.
>
per general understanding of a subsystem uninitialization, a flag shall be
marked to reject further operation on the sub-system and flush the pending
operation, then free the resource. In such a general method, current
handling to create a new ea_inode should not crash even it is stupid.
sb->s_root seems to be a key global resource in ext4 subsystem per my
understanding, and should not be set as NULL until the last step of unmount
 operation.

Please help teach me what is wrong in my understanding.


> So this is what actually goes *boom*:
>
>         ea_inode =3D ext4_new_inode(handle, inode->i_sb->s_root->d_inode,
>                                           ^^^^^^^^^^^^^^^^^^^ NULL ptr, o=
ops!
>                                   S_IFREG | 0600, NULL, inode->i_ino + 1,=
 owner,
>                                   EXT4_EA_INODE_FL);
>
>
> We can prove this is the issue by using the following debugging patch,
> which prevents the reproducer from triggering after prining the "fs
> being unmouinted" message:
>
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -2697,6 +2697,13 @@ int ext4_expand_extra_isize_ea(struct inode *inode=
, int new_extra_isize,
>         int s_min_extra_isize =3D le16_to_cpu(sbi->s_es->s_min_extra_isiz=
e);
>         int isize_diff; /* How much do we need to grow i_extra_isize */
>
> +       pr_err("ext4_expand_extra_isize_ea ino %lu new_extra_isize %d cur=
r %d\n",
> +              inode->i_ino, new_extra_isize, EXT4_I(inode)->i_extra_isiz=
e);
> +       if (inode->i_sb->s_root =3D=3D NULL) {
> +               pr_err("ext4_expand_extra_isize_ea: fs being unmounted\n"=
);
> +               return -EINVAL;
> +       }
> +
>  retry:
>         isize_diff =3D new_extra_isize - EXT4_I(inode)->i_extra_isize;
>         if (EXT4_I(inode)->i_extra_isize >=3D new_extra_isize)
>
> Fixing this the clean and proper way, which is by making
> ext4_xattr_move_to_block() more intelligent/efficient, is left as an
> exercise to the reader.
>
> Cheers,
>
>                                                 - Ted
>
> P.S.  Note that this fix is actually needed for the current upstream
> kernel; the reproducer will trigger in 6.1, although we need to either
> modify the reproducer to drop the completely pointless nouser_xattr
> mount option (which is a bit painful since the !@?! mount options is
> obfuscated by virtue of being in hex for no particular good reason) or
> by hacking the kernel to ignore that mount options, via a patch like
> this:
>
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1658,6 +1658,7 @@ static const struct fs_parameter_spec ext4_param_sp=
ecs[] =3D {
>         fsparam_flag    ("oldalloc",            Opt_removed),
>         fsparam_flag    ("orlov",               Opt_removed),
>         fsparam_flag    ("user_xattr",          Opt_user_xattr),
> +       fsparam_flag    ("nouser_xattr",        Opt_removed),
>         fsparam_flag    ("acl",                 Opt_acl),
>         fsparam_flag    ("norecovery",          Opt_noload),
>         fsparam_flag    ("noload",              Opt_noload),
>
