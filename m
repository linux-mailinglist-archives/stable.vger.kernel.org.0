Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B6D372E53
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 18:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhEDQ71 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 12:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbhEDQ71 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 May 2021 12:59:27 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2433CC061574;
        Tue,  4 May 2021 09:58:32 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id x19so14337315lfa.2;
        Tue, 04 May 2021 09:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J0hZFszxdcZH6patmSOQp22ZQfYFMoP3443q2EgmKBg=;
        b=VfiFZJCFbwQnYSSwLAuoXIc+c0qIP+cS+/iINmXZUAqUgvWcqstoZ8x9RkOMdJqaC1
         KDUdiV/cRaBB8qlt1a5Ujnh+P2YBb0KCeTODtOrJhG5NFKnxU+cKcdPyPXfIclnZzKLF
         4D9qi2T6mLC/o2B9Oy9jh5Xt2lYQR0n+dpW1GGShJ9nihiXc9jlPRQ+2H/e2EMv8mOMY
         tZkUViaIlv4KqaFtwUCkZgfEhmdAqtPCX6EzEGkzNH8KkyE9ohreoqFTa/ChsfDajvj/
         2Xq9pksRVJsnr2BYMxdjVEIiksquh3KAq+6In3Mg5/JrbQk2wDrOJ9cJThL9j5H487R+
         ddrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J0hZFszxdcZH6patmSOQp22ZQfYFMoP3443q2EgmKBg=;
        b=ldYBzGK+tAm03N7YHKiUOG3Yin3Tk3EdbZGoP8K/sOzceqWL6bw61d9cGpBKvh9rvF
         TV/0Lsgpu3X4yFBkdlKFXnzlUgGrkARsHG4yhH2jOxFa1PvbmSFX67FNNd1R1a37NVaF
         QSaTnnemVDfhpeZho911AeqkG0jEC6qvWmEgvIqyv563rO2S7kSvpbz7Qed8Xy62rBK/
         mm5QbNbcEwRpnfdMCGcMCei7bTIuXvXeLoWjiOCnX74vyxTZgiQY4uO4C48RJGX/8oT8
         p/l7CWpTqSm2f56Sa2xUhj6FXougrH8bSIMhNbBMJ/8ska4QZ4SwI7/RATE19sacYFsT
         XAEg==
X-Gm-Message-State: AOAM531PDjO+YjCJgo9pe5O6TsgvkJNc7opw5mYpTKR0Uz1kMvABoARp
        38khTZDpYTQWZlVLQjpWFY/KjXCbRq+tGJsDkeU=
X-Google-Smtp-Source: ABdhPJzVXyB3zGC7S+3Mm/Odq33J7AqYTVcC87HnELVKq1k/d/B+y5N2OC53fN74prgnkpdjk4w1zx4FZDLJB1NnOmY=
X-Received: by 2002:a05:6512:142:: with SMTP id m2mr8167511lfo.313.1620147510518;
 Tue, 04 May 2021 09:58:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210430221621.7497-1-pc@cjr.nz> <20210503145526.9705-1-pc@cjr.nz>
 <20210504012027.6deac39a@suse.de>
In-Reply-To: <20210504012027.6deac39a@suse.de>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 4 May 2021 11:58:19 -0500
Message-ID: <CAH2r5ms9OTgKgr5B=_ac4gyvCb104Cj11mu=zaWjJAiejam14w@mail.gmail.com>
Subject: Re: [PATCH v2] cifs: fix regression when mounting shares with prefix paths
To:     David Disseldorp <ddiss@suse.de>
Cc:     Paulo Alcantara <pc@cjr.nz>, CIFS <linux-cifs@vger.kernel.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

added acked-by and merged into cifs-2.6.git for-next

On Mon, May 3, 2021 at 6:20 PM David Disseldorp <ddiss@suse.de> wrote:
>
> On Mon,  3 May 2021 11:55:26 -0300, Paulo Alcantara wrote:
>
> > The commit 315db9a05b7a ("cifs: fix leak in cifs_smb3_do_mount() ctx")
> > revealed an existing bug when mounting shares that contain a prefix
> > path or DFS links.
> >
> > cifs_setup_volume_info() requires the @devname to contain the full
> > path (UNC + prefix) to update the fs context with the new UNC and
> > prepath values, however we were passing only the UNC
> > path (old_ctx->UNC) in @device thus discarding any prefix paths.
> >
> > Instead of concatenating both old_ctx->{UNC,prepath} and pass it in
> > @devname, just keep the dup'ed values of UNC and prepath in
> > cifs_sb->ctx after calling smb3_fs_context_dup(), and fix
> > smb3_parse_devname() to correctly parse and not leak the new UNC and
> > prefix paths.
> >
> > Cc: <stable@vger.kernel.org> # v5.11+
> > Fixes: 315db9a05b7a ("cifs: fix leak in cifs_smb3_do_mount() ctx")
> > Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> > ---
> >  fs/cifs/cifsfs.c     |  8 +-------
> >  fs/cifs/connect.c    | 24 ++++++++++++++++++------
> >  fs/cifs/fs_context.c |  4 ++++
> >  3 files changed, 23 insertions(+), 13 deletions(-)
> >
> > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > index 8a6894577697..d7ea9c5fe0f8 100644
> > --- a/fs/cifs/cifsfs.c
> > +++ b/fs/cifs/cifsfs.c
> > @@ -863,13 +863,7 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
> >               goto out;
> >       }
> >
> > -     /* cifs_setup_volume_info->smb3_parse_devname() redups UNC & prepath */
> > -     kfree(cifs_sb->ctx->UNC);
> > -     cifs_sb->ctx->UNC = NULL;
> > -     kfree(cifs_sb->ctx->prepath);
> > -     cifs_sb->ctx->prepath = NULL;
> > -
> > -     rc = cifs_setup_volume_info(cifs_sb->ctx, NULL, old_ctx->UNC);
> > +     rc = cifs_setup_volume_info(cifs_sb->ctx, NULL, NULL);
>
> IIUC, with the new behaviour, this call becomes pretty much an
>         if (!cifs_sb->ctx->username)
>                 root = ERR_PTR(-EINVAL);
>
> So it might be worth simplifying this further. Either way:
> Acked-by: David Disseldorp <ddiss@suse.de>
>
> Cheers, David



-- 
Thanks,

Steve
