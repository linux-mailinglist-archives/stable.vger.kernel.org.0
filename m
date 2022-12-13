Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAE5264BB8C
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 19:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236444AbiLMSGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 13:06:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236427AbiLMSGG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 13:06:06 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BAB0248EE;
        Tue, 13 Dec 2022 10:06:01 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id s5so18889138edc.12;
        Tue, 13 Dec 2022 10:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qiovmh5Z7knoae7e8jOski8fcgmYieRzZZhaPyBaFp0=;
        b=fmSfnPu865PWYkJWv9TPusPr7Eh40Mk3iSfmFyoYew3hiWb4y/JFQ4dbu2aM+kiiUJ
         oB6EWtcrhC+Q5hryNqs1wvTh7ziBAKZQV86+2xAUSzy2NpPicjpIZzbV5u6XA9AB11q3
         y5V6j4zxwGduSLgkDeuXVDiYsihP/e8XFbtr9HJafMSvc3gZdhNBfSQBzylMr5DNk/m0
         MoBibAQQqQKqUklRwzkojjmexaqO2aYwbvBT4mV7AXtOcPqAI69COWx7ZsFkcpBz+Fmu
         NPEtwmzT6YjoX8qNMFCY+/PyHQKDJ7gqwp6eLMv2J4CTW+GyWWwfHDYZniP9fGJB92o+
         BBBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qiovmh5Z7knoae7e8jOski8fcgmYieRzZZhaPyBaFp0=;
        b=oPkiPtSE6fzscTjLgGVGnynDW9C8GDPo2J/11HbO9PafKLfmbCfcOzZXBDy9oDMvS5
         dJlvsaA+fwpfeUdUfgdZUc8pavXC9J6/bqPoKKAESrzZ8bzW5SoOI+/hIP6zxQlBjs6F
         ODjPPS5d10Pp4Q8ucrmStDynI8GGtfJvq2R19bHSN4tQDsrxrZgewjn6yVa/r2Pjz287
         74fQQlLlhFC5Pb5zBIWp0Ghs0WKnkXA0xGXbbjeFdAR9D+RtLOrWEOwD1UU1w4gIwnIP
         11bvmJTmMGnLiYdguo9FCOPj01ShDcBFE8RF7a4nMAtHMMwJYQn0C/AXhIoKa6CAAGTj
         8/Zw==
X-Gm-Message-State: ANoB5plydTnuPk+D/+soDud+ByX6mmkGRjUL2/BdSeLOZCIJjuKeVWso
        21+65ZT8CnB4nl2Wj8bilQhEPrwB74jqGztvHAjj7/E0l4c=
X-Google-Smtp-Source: AA0mqf62zVyCFbaQs9SItdtohq3S4E9cHiKPMYVlKw6yjUwrnqSMMz0l/T885Yux03sgFLbK0S9Y9jE5AyfsVxb1B4s=
X-Received: by 2002:a05:6402:25c5:b0:46c:211:f9b8 with SMTP id
 x5-20020a05640225c500b0046c0211f9b8mr21741118edb.199.1670954759483; Tue, 13
 Dec 2022 10:05:59 -0800 (PST)
MIME-Version: 1.0
References: <20221213121103.213631-1-xiubli@redhat.com> <20221213121103.213631-3-xiubli@redhat.com>
In-Reply-To: <20221213121103.213631-3-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 13 Dec 2022 19:05:47 +0100
Message-ID: <CAOi1vP-jTA38riQ+E239vz2omTmX7fQvnzf9BcmkLVU_0PyngA@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] ceph: add ceph specific member support for file_lock
To:     xiubli@redhat.com
Cc:     jlayton@kernel.org, ceph-devel@vger.kernel.org,
        mchangir@redhat.com, lhenriques@suse.de, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 13, 2022 at 1:11 PM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> When ceph releasing the file_lock it will try to get the inode pointer
> from the fl->fl_file, which the memory could already be released by
> another thread in filp_close(). Because in VFS layer the fl->fl_file
> doesn't increase the file's reference counter.
>
> Will switch to use ceph dedicate lock info to track the inode.
>
> And in ceph_fl_release_lock() we should skip all the operations if
> the fl->fl_u.ceph_fl.fl_inode is not set, which should come from
> the request file_lock. And we will set fl->fl_u.ceph_fl.fl_inode when
> inserting it to the inode lock list, which is when copying the lock.
>
> Cc: stable@vger.kernel.org
> Cc: Jeff Layton <jlayton@kernel.org>
> URL: https://tracker.ceph.com/issues/57986
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/locks.c    | 20 ++++++++++++++++++--
>  include/linux/fs.h |  3 +++
>  2 files changed, 21 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
> index b191426bf880..cf78608a3f9a 100644
> --- a/fs/ceph/locks.c
> +++ b/fs/ceph/locks.c
> @@ -34,18 +34,34 @@ static void ceph_fl_copy_lock(struct file_lock *dst, struct file_lock *src)
>  {
>         struct inode *inode = file_inode(dst->fl_file);
>         atomic_inc(&ceph_inode(inode)->i_filelock_ref);
> +       dst->fl_u.ceph.fl_inode = igrab(inode);
>  }
>
> +/*
> + * Do not use the 'fl->fl_file' in release function, which
> + * is possibly already released by another thread.
> + */
>  static void ceph_fl_release_lock(struct file_lock *fl)
>  {
> -       struct inode *inode = file_inode(fl->fl_file);
> -       struct ceph_inode_info *ci = ceph_inode(inode);
> +       struct inode *inode = fl->fl_u.ceph.fl_inode;
> +       struct ceph_inode_info *ci;
> +
> +       /*
> +        * If inode is NULL it should be a request file_lock,
> +        * nothing we can do.
> +        */
> +       if (!inode)
> +               return;
> +
> +       ci = ceph_inode(inode);
>         if (atomic_dec_and_test(&ci->i_filelock_ref)) {
>                 /* clear error when all locks are released */
>                 spin_lock(&ci->i_ceph_lock);
>                 ci->i_ceph_flags &= ~CEPH_I_ERROR_FILELOCK;
>                 spin_unlock(&ci->i_ceph_lock);
>         }
> +       fl->fl_u.ceph.fl_inode = NULL;
> +       iput(inode);
>  }
>
>  static const struct file_lock_operations ceph_fl_lock_ops = {
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 7b52fdfb6da0..6106374f5257 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1119,6 +1119,9 @@ struct file_lock {
>                         int state;              /* state of grant or error if -ve */
>                         unsigned int    debug_id;
>                 } afs;
> +               struct {
> +                       struct inode *fl_inode;

Hi Xiubo,

Nit: I think it could be just "inode", without the prefix which is
already present in the union field name.

Thanks,

                Ilya
