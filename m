Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A0D370163
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 21:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbhD3TlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 15:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233188AbhD3TlN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Apr 2021 15:41:13 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB04C06174A;
        Fri, 30 Apr 2021 12:40:24 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 12so111446891lfq.13;
        Fri, 30 Apr 2021 12:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wr3TJWjpkmXIK0mmqtUjTMHf0hJ6LevoMO/vPiujiS0=;
        b=C9xke+WVC4FuSBch1oqd9Eay6aIRdFjN9thDN8ixRLOBbVsp4TfjhVOOsAUIwYB4nq
         iv1y0TLHWgCApwlWBhI91eCPAtbqgJB+xsbCl0NT//WZcFcEkbnwB/QGT9ahQcTldMus
         11N0rY7jqGdbHZzZupLuSdhKwWNFUWZDttaO6ocTtxphVh1diB5CnNQj3Y4VZONjLQc2
         ELlDgBqPzdmC3tErOTQgFZSoUFChExt75nP2aoyw4lI/wWf4AsaZHFBC/b3Lx+O5pvC3
         og6lphaMpf/zW+6IDps+5gULMHEGljpwz2UunaLLTLoQLyGXFq/vtsS7X3pf7ooZNJPa
         li/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wr3TJWjpkmXIK0mmqtUjTMHf0hJ6LevoMO/vPiujiS0=;
        b=lYWfkKtnlLx4Fp+mtB/nmZrRBz8Qqthi3hAs/ASOnyOGGpRD8fYlgtA86HG5ny1qd0
         gsbcRP+PpDBnOpHAkazKsmwdqrkAMZi1T9ldE60o+UsQyM93XAQoClD2p0vQq5Qhy9kg
         Jsa/EfK6Y++gAfvsAvxLToMIOB7NXGpqm8M/bq0C6gVRCfKiX3RToE/pUEceFYJ1qyvu
         qMG1lMclDFxaJiyNYdhB0loUydNpwXn+dVn8fsuitDAXCmwe9Nak85+PTJaKaqPNmdvc
         g2sfk9TK7Fld4EV8VxyLKZj95CxmBJlN61ZIvVFBj384In6lYurXgIwPE24FgiIs96lr
         Mm9A==
X-Gm-Message-State: AOAM5310QrrD/4rpueHLN0bbX4A7HepHxN/ruXSAzhZzhmDqynXuZSYl
        PDCZPltZihS6ufUUaY0BfbYh8kzsxml65Ied19Q=
X-Google-Smtp-Source: ABdhPJxWGNF8Xm6C0xc8l5hJbd6xKA3cSO7mn7M2P/EQse0eMG7C4Vb1cXfVh142rpyy2KX3m1xTgMj2ftZeC42+lK8=
X-Received: by 2002:a19:614e:: with SMTP id m14mr4249766lfk.395.1619811623256;
 Fri, 30 Apr 2021 12:40:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210430180843.16920-1-pc@cjr.nz>
In-Reply-To: <20210430180843.16920-1-pc@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 30 Apr 2021 14:40:12 -0500
Message-ID: <CAH2r5mvfj8Q9rKZjOBv1tyzeKAemRf41nnQKxCD3wJWGofro3w@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix automount regression of dfs links
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        David Disseldorp <ddiss@suse.de>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

FYI - Running the DFS tests now

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/3/builds/99

On Fri, Apr 30, 2021 at 1:10 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Unfortunately we can't kfree() the UNC and prefix paths in
> cifs_smb3_do_mount() because they could have come from a chased DFS
> referral (automount) and we rely on the new values set in cifs_sb->ctx
> prior to calling cifs_mount().
>
> Instead, fix smb3_parse_devname() to not leak the UNC and prefix paths
> when parsing new share paths.
>
> Cc: <stable@vger.kernel.org> # v5.11+
> Fixes: 315db9a05b7a ("cifs: fix leak in cifs_smb3_do_mount() ctx")
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> ---
>  fs/cifs/cifsfs.c     |  6 ------
>  fs/cifs/connect.c    | 10 +++++++---
>  fs/cifs/fs_context.c |  2 ++
>  3 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 8a6894577697..bfe98136f9c1 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -863,12 +863,6 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
>                 goto out;
>         }
>
> -       /* cifs_setup_volume_info->smb3_parse_devname() redups UNC & prepath */
> -       kfree(cifs_sb->ctx->UNC);
> -       cifs_sb->ctx->UNC = NULL;
> -       kfree(cifs_sb->ctx->prepath);
> -       cifs_sb->ctx->prepath = NULL;
> -
>         rc = cifs_setup_volume_info(cifs_sb->ctx, NULL, old_ctx->UNC);
>         if (rc) {
>                 root = ERR_PTR(rc);
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index becd5f807787..ee4a92cbcb29 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3159,9 +3159,13 @@ static int do_dfs_failover(const char *path, const char *full_path, struct cifs_
>  int
>  cifs_setup_volume_info(struct smb3_fs_context *ctx, const char *mntopts, const char *devname)
>  {
> -       int rc = 0;
> +       int rc;
>
> -       smb3_parse_devname(devname, ctx);
> +       rc = smb3_parse_devname(devname, ctx);
> +       if (rc) {
> +               cifs_dbg(VFS, "%s: failed to parse %s: %d\n", __func__, devname, rc);
> +               return rc;
> +       }
>
>         if (mntopts) {
>                 char *ip;
> @@ -3189,7 +3193,7 @@ cifs_setup_volume_info(struct smb3_fs_context *ctx, const char *mntopts, const c
>                 return -EINVAL;
>         }
>
> -       return rc;
> +       return 0;
>  }
>
>  static int
> diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
> index 1d6e0e15b034..b502a44e15a1 100644
> --- a/fs/cifs/fs_context.c
> +++ b/fs/cifs/fs_context.c
> @@ -476,6 +476,7 @@ smb3_parse_devname(const char *devname, struct smb3_fs_context *ctx)
>
>         /* move "pos" up to delimiter or NULL */
>         pos += len;
> +       kfree(ctx->UNC);
>         ctx->UNC = kstrndup(devname, pos - devname, GFP_KERNEL);
>         if (!ctx->UNC)
>                 return -ENOMEM;
> @@ -490,6 +491,7 @@ smb3_parse_devname(const char *devname, struct smb3_fs_context *ctx)
>         if (!*pos)
>                 return 0;
>
> +       kfree(ctx->prepath);
>         ctx->prepath = kstrdup(pos, GFP_KERNEL);
>         if (!ctx->prepath)
>                 return -ENOMEM;
> --
> 2.31.1
>


-- 
Thanks,

Steve
