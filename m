Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B98928B12
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387620AbfEWTwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:52:13 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:39009 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388476AbfEWTwK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 15:52:10 -0400
Received: by mail-yb1-f196.google.com with SMTP id a3so2735330ybr.6
        for <stable@vger.kernel.org>; Thu, 23 May 2019 12:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fA7pnk6/3muIMVE9C0+J0SxYty4W61Wxbz06ALMjdr4=;
        b=d52LHJ/J7aaf6lYwns2H7AIHvEnriGRUOOIxUjKeIJHrakQLz9oXH+IbEsaXKio7Ts
         pc3+dpVRIE7tNBIRWw4eZ2og/1WkXz3RY8VeHTHBQgpH19dzQcrBW01C7YOQRIlj2XcK
         key05JqVvqsq69a6bKQYcQm92i5pj+R/p9A215PUQAtrhgPyT5/qywKEZsdKzVDmeZE+
         qoD7zuznZkiI/j6Gx31TSIpwmkRFkIir0gJu5ws4hI0eG2Z+5ooVsUjRFjm89KXeD6KD
         ALmcSw5+wRDiVqZPwd3uWPDgy7FxQSD8c4/F0fYrLejTwoyKi3M8rmsXFb+0ZlJ1GhSB
         zw7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fA7pnk6/3muIMVE9C0+J0SxYty4W61Wxbz06ALMjdr4=;
        b=eLKGNm006M1GEAEmtL85iFhdZ3qG8solrDDmsnSIL4moq8hIVCZxc3HrevaSNjnBo4
         qywrT+71/mHMql20cVpAwkuzDmN/zQthWbixoYNfiq7zBedksIepW+X3mulXeeKfqMSM
         ecfwMok2fembgOO6cIoVz2SXFHVcoKthJlDLxK21kZeDPK78H6xXXpvIMvaTbTLHTauy
         vplHNiB2twmkm+nKabheMSoaAIh/Zh6uVeDNcRj2iFtpnH7Dm00BZUaHTyvHOa1thw3f
         3mKwbhGi/a40jCJrkZSPRwVn04oHbBu9pIdfrU0vbeksbRAXF+cU09l/+mkvTHXvE79i
         hEIQ==
X-Gm-Message-State: APjAAAVCBqBptuBzET2S7s/TcY17Q3GExiZB7e61y7jh9TbK0K1GS9ev
        dInqzcjsfRsHwEMQ2RjykUxrIm9Mh1QiNaO2j2o=
X-Google-Smtp-Source: APXvYqzgOvefg28g5fUfQixE0FngDBXI4uQG1IML51sm1cizMv2fcB0c4WH8RkWRyOxgO5CGG0l1+GiktDEkXZuqybY=
X-Received: by 2002:a25:b202:: with SMTP id i2mr10892978ybj.439.1558641129831;
 Thu, 23 May 2019 12:52:09 -0700 (PDT)
MIME-Version: 1.0
References: <1558603746191117@kroah.com>
In-Reply-To: <1558603746191117@kroah.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 23 May 2019 22:51:58 +0300
Message-ID: <CAOQ4uxip8H45S-UmWhNowv9sQUTYzcDMVCZxw=6AvFN-4c1Uvw@mail.gmail.com>
Subject: Re: Patch "ovl: fix missing upper fs freeze protection on copy up for
 ioctl" has been added to the 4.19-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 23, 2019 at 12:30 PM <gregkh@linuxfoundation.org> wrote:
>
>
> This is a note to let you know that I've just added the patch titled
>
>     ovl: fix missing upper fs freeze protection on copy up for ioctl
>
> to the 4.19-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>
> The filename of the patch is:
>      ovl-fix-missing-upper-fs-freeze-protection-on-copy-up-for-ioctl.patch
> and it can be found in the queue-4.19 subdirectory.
>
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
>
>
> From 3428030da004a1128cbdcf93dc03e16f184d845b Mon Sep 17 00:00:00 2001
> From: Amir Goldstein <amir73il@gmail.com>
> Date: Tue, 22 Jan 2019 07:01:39 +0200
> Subject: ovl: fix missing upper fs freeze protection on copy up for ioctl
>
> From: Amir Goldstein <amir73il@gmail.com>
>
> commit 3428030da004a1128cbdcf93dc03e16f184d845b upstream.
>
> Generalize the helper ovl_open_maybe_copy_up() and use it to copy up file
> with data before FS_IOC_SETFLAGS ioctl.
>
> The FS_IOC_SETFLAGS ioctl is a bit of an odd ball in vfs, which probably
> caused the confusion.  File may be open O_RDONLY, but ioctl modifies the
> file.  VFS does not call mnt_want_write_file() nor lock inode mutex, but
> fs-specific code for FS_IOC_SETFLAGS does.  So ovl_ioctl() calls
> mnt_want_write_file() for the overlay file, and fs-specific code calls
> mnt_want_write_file() for upper fs file, but there was no call for
> ovl_want_write() for copy up duration which prevents overlayfs from copying
> up on a frozen upper fs.
>
> Fixes: dab5ca8fd9dd ("ovl: add lsattr/chattr support")
> Cc: <stable@vger.kernel.org> # v4.19
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Acked-by: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>  fs/overlayfs/copy_up.c   |    6 +++---
>  fs/overlayfs/file.c      |    5 ++---
>  fs/overlayfs/overlayfs.h |    2 +-
>  3 files changed, 6 insertions(+), 7 deletions(-)
>
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -878,14 +878,14 @@ static bool ovl_open_need_copy_up(struct
>         return true;
>  }
>
> -int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags)
> +int ovl_maybe_copy_up(struct dentry *dentry, int flags)
>  {
>         int err = 0;
>
> -       if (ovl_open_need_copy_up(dentry, file_flags)) {
> +       if (ovl_open_need_copy_up(dentry, flags)) {
>                 err = ovl_want_write(dentry);
>                 if (!err) {
> -                       err = ovl_copy_up_flags(dentry, file_flags);
> +                       err = ovl_copy_up_flags(dentry, flags);
>                         ovl_drop_write(dentry);
>                 }
>         }
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -116,11 +116,10 @@ static int ovl_real_fdget(const struct f
>
>  static int ovl_open(struct inode *inode, struct file *file)
>  {
> -       struct dentry *dentry = file_dentry(file);
>         struct file *realfile;
>         int err;
>
> -       err = ovl_open_maybe_copy_up(dentry, file->f_flags);
> +       err = ovl_maybe_copy_up(file_dentry(file), file->f_flags);
>         if (err)
>                 return err;
>
> @@ -390,7 +389,7 @@ static long ovl_ioctl(struct file *file,
>                 if (ret)
>                         return ret;
>
> -               ret = ovl_copy_up_with_data(file_dentry(file));
> +               ret = ovl_maybe_copy_up(file_dentry(file), O_WRONLY);
>                 if (!ret) {
>                         ret = ovl_real_ioctl(file, cmd, arg);
>
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -411,7 +411,7 @@ extern const struct file_operations ovl_
>  int ovl_copy_up(struct dentry *dentry);
>  int ovl_copy_up_with_data(struct dentry *dentry);
>  int ovl_copy_up_flags(struct dentry *dentry, int flags);
> -int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags);
> +int ovl_maybe_copy_up(struct dentry *dentry, int flags);
>  int ovl_copy_xattr(struct dentry *old, struct dentry *new);
>  int ovl_set_attr(struct dentry *upper, struct kstat *stat);
>  struct ovl_fh *ovl_encode_real_fh(struct dentry *real, bool is_upper);
>
>
> Patches currently in stable-queue which might be from amir73il@gmail.com are
>
> queue-4.19/ovl-fix-missing-upper-fs-freeze-protection-on-copy-up-for-ioctl.patch

This patch is fine for stable, but I have a process question.
All these patches from overlayfs 5.2-rc1 are also v4.9 stable candidates:

1. acf3062a7e1c - ovl: relax WARN_ON() for overlapping layers use case
2. 98487de318a6 - ovl: check the capability before cred overridden
3. d989903058a8 - ovl: do not generate duplicate fsnotify events for "fake" path
4. 9e46b840c705 - ovl: support stacked SEEK_HOLE/SEEK_DATA

#2 wasn't properly marked for stable, but the other are marked with
Fixes: and Reported-by:

Are those marks not sufficient to get selected for stable trees these days?

I must admit that #1 in borderline stable. Not sure if eliminating an unjust
WARN_ON qualified, but syzbot did report a bug..

Just asking in order to improve the process, but in any case,
please pick those patches for v4.9+ (unless anyone objects?)
They all already have LTP/xfstests/syzkaller tests that cover them.

Thanks,
Amir.
