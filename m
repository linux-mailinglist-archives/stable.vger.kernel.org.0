Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9147A311385
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 22:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbhBEV1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 16:27:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbhBEPAc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 10:00:32 -0500
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C59C061786;
        Fri,  5 Feb 2021 08:38:37 -0800 (PST)
Received: by mail-ua1-x933.google.com with SMTP id p19so2310934uad.7;
        Fri, 05 Feb 2021 08:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=I57FiQkDQ+xhVoz0anMGzaM3+FzzYkjie2v/Yi2uB3w=;
        b=dd6MYgRnwCqIWamtBY8PPs1TbchkdtCoTsmd3cmxscyyn9EKnkOiC6d0o2f+8VPORq
         I3/A5Rnpi9KTV5mQqw9wPkf0DTJSqUudQ0fPlStPLcI2qjK6Mkdv80h6MAoskuQd8Bmw
         iXAfBHzFn9gh6oHFDKv1ketOdUKnTY5fp6syB8Of8WZUR/o6SgsihZvTLVdyydgsXWAQ
         c6dtuT7JzeRwK6h0pDY3UYP38tclR3i2Kvs7FDB8xqes0xMBtTq5kGJh4XIeP72L6jOb
         CIxKy8TiNk8o03Rw7sf6hCE/ew3YMwx3YSmALaHQgzct9hT9AwSbVn/HQbCFkzoa6698
         mtvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=I57FiQkDQ+xhVoz0anMGzaM3+FzzYkjie2v/Yi2uB3w=;
        b=WpD15HDL2Dc7kpOzFg63BHuMzkXN8YqRRbk92OwgN6MZ37SA+/S0K0uTNDr0CO160s
         heAMRp0o1vUFgRjxcqcFYuFqwuSj1D4+fCDplDCvHr7hUY2IGeXhqwe0VzdB5iaQW96n
         +M1/0fkUdCwwzX+/b7wkHm4KtRcm6+duhvb/8/q0UrNNeOpkaz1lPa0Y5tDDJsyx3lsk
         rCJXgOmfgk5SQnjt+M+RPLNuiX7O+FRDRJ4lmA7YPwXKDWLlKfKBj4f+pI8YKQBBeUn4
         kMEfxZ6Y4akBy6y6xIX/OuytyO/Q8uesOs3U9BBTWtniayq6Otw/6sHydNsDNm/oRr1N
         W2jw==
X-Gm-Message-State: AOAM531pzNZGjaQvQzXYrfpLm0AXTgPGEZJO8vnPCbUvPGwnf0i/xf6j
        zY14L83MJA/r2z8x+eW9oITzDox2dofKzAA7ww4RVaCDNbl1gA==
X-Google-Smtp-Source: ABdhPJxXSn+EpSOusnsHf6NXEqgBAY2zdEq25/ycqgSkeVmZ7ME1vWs7sB+tCZM8qIKXe1d6nho1dSJyWVQDu2bt06w=
X-Received: by 2002:a25:7706:: with SMTP id s6mr6758693ybc.3.1612536734191;
 Fri, 05 Feb 2021 06:52:14 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=o4b9RfQ5omd911pLH3WFbiC1-ghF43kRZ5-4SV+PeS=g@mail.gmail.com>
 <20210205144248.13508-1-aaptel@suse.com>
In-Reply-To: <20210205144248.13508-1-aaptel@suse.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 5 Feb 2021 06:52:03 -0800
Message-ID: <CANT5p=p7Ah_yFsmpj7VCzuoszpf6WiU+G8jws24njXgM_gv_mQ@mail.gmail.com>
Subject: Re: [PATCH v4] cifs: report error instead of invalid when
 revalidating a dentry fails
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Steve French <smfrench@gmail.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good to me.
Maybe change the FYI in the cifs_dbg line above to VFS?

On Fri, Feb 5, 2021 at 6:42 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote:
>
> From: Aurelien Aptel <aaptel@suse.com>
>
> Assuming
> - //HOST/a is mounted on /mnt
> - //HOST/b is mounted on /mnt/b
>
> On a slow connection, running 'df' and killing it while it's
> processing /mnt/b can make cifs_get_inode_info() returns -ERESTARTSYS.
>
> This triggers the following chain of events:
> =3D> the dentry revalidation fail
> =3D> dentry is put and released
> =3D> superblock associated with the dentry is put
> =3D> /mnt/b is unmounted
>
> This patch makes cifs_d_revalidate() return the error instead of 0
> (invalid) when cifs_revalidate_dentry() fails, except for ENOENT (file
> deleted) and ESTALE (file recreated).
>
> Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> Suggested-by: Shyam Prasad N <nspmangalore@gmail.com>
> CC: stable@vger.kernel.org
>
> ---
>  fs/cifs/dir.c | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index 68900f1629bff..97ac363b5df16 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -737,6 +737,7 @@ static int
>  cifs_d_revalidate(struct dentry *direntry, unsigned int flags)
>  {
>         struct inode *inode;
> +       int rc;
>
>         if (flags & LOOKUP_RCU)
>                 return -ECHILD;
> @@ -746,8 +747,25 @@ cifs_d_revalidate(struct dentry *direntry, unsigned =
int flags)
>                 if ((flags & LOOKUP_REVAL) && !CIFS_CACHE_READ(CIFS_I(ino=
de)))
>                         CIFS_I(inode)->time =3D 0; /* force reval */
>
> -               if (cifs_revalidate_dentry(direntry))
> -                       return 0;
> +               rc =3D cifs_revalidate_dentry(direntry);
> +               if (rc) {
> +                       cifs_dbg(FYI, "cifs_revalidate_dentry failed with=
 rc=3D%d", rc);
> +                       switch (rc) {
> +                       case -ENOENT:
> +                       case -ESTALE:
> +                               /*
> +                                * Those errors mean the dentry is invali=
d
> +                                * (file was deleted or recreated)
> +                                */
> +                               return 0;
> +                       default:
> +                               /*
> +                                * Otherwise some unexpected error happen=
ed
> +                                * report it as-is to VFS layer
> +                                */
> +                               return rc;
> +                       }
> +               }
>                 else {
>                         /*
>                          * If the inode wasn't known to be a dfs entry wh=
en
> --
> 2.29.2
>


--=20
Regards,
Shyam
