Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06727108948
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 08:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbfKYHie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 02:38:34 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:36190 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfKYHie (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Nov 2019 02:38:34 -0500
Received: by mail-io1-f67.google.com with SMTP id s3so15111353ioe.3;
        Sun, 24 Nov 2019 23:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cWZU06oGCt/NTMskbHFOCtlhbvDkJkmKXOKYuC8j6Rw=;
        b=ucdDkToOXC5hweutKXqitWlBQrnqFRhngV5JjuWF3uG35P5V/0pyVoQPMpimVr4GSQ
         O79X64D7XpEbN8ub3x7DDXponGOh9y0KIvu3z4BmMyttF1dHppXZZHv2EqTMK+d5qsjK
         gMxTvuH4sNPKfs0MQvC2vKRYBZpkx0EJddx3Y1AMU0JvTeWBM+luGV+XK5H8GI/55gc3
         bc+I0QZg6j9jZvoIFbVzacjr4Z16fMFqu/UIntDs1wrmStsc7jcJKxjTPSzgEviXR99y
         bpbVGGmv0XyT95ejxtrHj5WPsmja0YR09tO5DhIYA5FTXuHbroN2HT9UCj08KkONZh1N
         iYGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cWZU06oGCt/NTMskbHFOCtlhbvDkJkmKXOKYuC8j6Rw=;
        b=TjU1lAdBl70Q+KpyTYvdCKwp31c4fbasJj1uB/9HDvnBqrAPc8knCOy6WbRs/Xjtfs
         LTFW8xuw457TCVFSm3PhBl18iBCPnx29d16cCpcQM9tCSE0vFAec/pFF8wDhJsqjkvL5
         yo/4NDhjUqnO/8oZrmMMl18qz44NBu8ldhLct6SczvK+1cE9pxMthJcYiGCJSEXG4hue
         FXJ6ewUjUEsGYOdTDj2XgVVB95tFVUJZpSW6Eppx/vEKC5VXlwJGsFXvgSKFhgmY82wx
         WYODLriNhNVkir/ew0AmiAobQN2lOVLX1Ru3ntr62VGpRk36ENvqr39HBbYfXj7JJN2y
         /WBw==
X-Gm-Message-State: APjAAAUBmosf3INiI4S4l6cN1Y5FVCTxAXSjneUoljl+Lg5ivGqRPf9l
        B/pdhuI7V1qvtrPsHzuyB4BrvQuUNNPnTR/6lgM=
X-Google-Smtp-Source: APXvYqx36rKM3nwChJ+tW2AJi/h1Bm/W/azfjdiieRMCsg0dcunruIS9Zb+RDs8QLQEWUphqxzZlliaDxZV48ufiyWU=
X-Received: by 2002:a6b:6617:: with SMTP id a23mr24392886ioc.3.1574667513131;
 Sun, 24 Nov 2019 23:38:33 -0800 (PST)
MIME-Version: 1.0
References: <20191122153057.6608-1-pc@cjr.nz> <20191122153057.6608-7-pc@cjr.nz>
In-Reply-To: <20191122153057.6608-7-pc@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 25 Nov 2019 01:38:22 -0600
Message-ID: <CAH2r5mtBXg8WJWFWEuX-_4zPVrtt=_Z_B6GWis+sQXnwWgFiVA@mail.gmail.com>
Subject: Re: [PATCH 6/7] cifs: Fix retrieval of DFS referrals in cifs_mount()
To:     "Paulo Alcantara (SUSE)" <pc@cjr.nz>
Cc:     CIFS <linux-cifs@vger.kernel.org>, Stable <stable@vger.kernel.org>,
        Matthew Ruffell <matthew.ruffell@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

merged into cifs-2.6.git for-next

On Fri, Nov 22, 2019 at 9:31 AM Paulo Alcantara (SUSE) <pc@cjr.nz> wrote:
>
> Make sure that DFS referrals are sent to newly resolved root targets
> as in a multi tier DFS setup.
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> Link: https://lkml.kernel.org/r/05aa2995-e85e-0ff4-d003-5bb08bd17a22@canonical.com
> Cc: stable@vger.kernel.org
> Tested-by: Matthew Ruffell <matthew.ruffell@canonical.com>
> ---
>  fs/cifs/connect.c | 32 ++++++++++++++++++++++----------
>  1 file changed, 22 insertions(+), 10 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 668d477cc9c7..86d98d73749d 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -4776,6 +4776,17 @@ static int is_path_remote(struct cifs_sb_info *cifs_sb, struct smb_vol *vol,
>  }
>
>  #ifdef CONFIG_CIFS_DFS_UPCALL
> +static inline void set_root_tcon(struct cifs_sb_info *cifs_sb,
> +                                struct cifs_tcon *tcon,
> +                                struct cifs_tcon **root)
> +{
> +       spin_lock(&cifs_tcp_ses_lock);
> +       tcon->tc_count++;
> +       tcon->remap = cifs_remap(cifs_sb);
> +       spin_unlock(&cifs_tcp_ses_lock);
> +       *root = tcon;
> +}
> +
>  int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *vol)
>  {
>         int rc = 0;
> @@ -4877,18 +4888,10 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *vol)
>         /* Cache out resolved root server */
>         (void)dfs_cache_find(xid, ses, cifs_sb->local_nls, cifs_remap(cifs_sb),
>                              root_path + 1, NULL, NULL);
> -       /*
> -        * Save root tcon for additional DFS requests to update or create a new
> -        * DFS cache entry, or even perform DFS failover.
> -        */
> -       spin_lock(&cifs_tcp_ses_lock);
> -       tcon->tc_count++;
> -       tcon->dfs_path = root_path;
> +       kfree(root_path);
>         root_path = NULL;
> -       tcon->remap = cifs_remap(cifs_sb);
> -       spin_unlock(&cifs_tcp_ses_lock);
>
> -       root_tcon = tcon;
> +       set_root_tcon(cifs_sb, tcon, &root_tcon);
>
>         for (count = 1; ;) {
>                 if (!rc && tcon) {
> @@ -4925,6 +4928,15 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *vol)
>                         mount_put_conns(cifs_sb, xid, server, ses, tcon);
>                         rc = mount_get_conns(vol, cifs_sb, &xid, &server, &ses,
>                                              &tcon);
> +                       /*
> +                        * Ensure that DFS referrals go through new root server.
> +                        */
> +                       if (!rc && tcon &&
> +                           (tcon->share_flags & (SHI1005_FLAGS_DFS |
> +                                                 SHI1005_FLAGS_DFS_ROOT))) {
> +                               cifs_put_tcon(root_tcon);
> +                               set_root_tcon(cifs_sb, tcon, &root_tcon);
> +                       }
>                 }
>                 if (rc) {
>                         if (rc == -EACCES || rc == -EOPNOTSUPP)
> --
> 2.24.0
>


-- 
Thanks,

Steve
