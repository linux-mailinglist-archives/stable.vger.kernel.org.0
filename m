Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E28549C725
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 11:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239670AbiAZKJ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 05:09:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239673AbiAZKJ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 05:09:58 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06199C06161C;
        Wed, 26 Jan 2022 02:09:58 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id 23so69759962ybf.7;
        Wed, 26 Jan 2022 02:09:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7LJmkqx4m9I9FZkfX+gZzMXkM3z5C8Pv8aqIIJbEzT8=;
        b=V5G4qbF22+1Fs9Q4Zo9geljkHy+RC8EdMa9bGqSGcpzdt3shqQn3grGCj7/zszDogK
         KN2agWCoIbSjZSIqxAavbEj3zPuFgGcz3qgEV8TpKJKV9ZuUiB85+5v0lDVU/J0uxfUs
         ysiFi41DjqxhpCVxJTXo517RsnZ34xHN5PDAU3kYCObvoYPN7ZGADVBwa/fibDyiFgfb
         2T+ryINYmqIKBs6dv0MZWC1nan46+BWEqCpneixkj43c7ydQEzYKl/N2y9NO/f4oA2Ep
         vFf8I7A5uuumJraT++tbiJZDKAStdFu2ZmXm6pshppw44C2aYmmgI8ZzwdqdCWPCE0Vm
         erWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7LJmkqx4m9I9FZkfX+gZzMXkM3z5C8Pv8aqIIJbEzT8=;
        b=jSeBqX5YmGTcSR5pFvRT1lUFA0g7ENZubqnwYjv12H03iztKk870MN5l7DIMOr8ePs
         26AkfWycTUeDqXAF3MZTzpbhUrw/nPT25ctW2wqi8u/RQdR20In3f1PtJw6yglVa2ZhI
         inADEXWOFjDORMBuyIeV8OI2aSbidGqYrU4n8iHR4FHMxuJYoY1Ih5/eRvqIa+ijxqe5
         5wcWyDef8G968fk+SmqV042uAUzV7h0ymZjkntnKBvazBaQHzyMGR+rnkOzqoFYXTts2
         itnf8PcG2sejcfPmKlp+jQxEhungjUpxVc+rAd79eCOck5H/2yblGaI5rcxONkBiNdja
         /SXA==
X-Gm-Message-State: AOAM533Ad73RKa4HZ5m/nDBGCVVnBULAABb+uYDvy4ncqv/r4tqdc7h8
        22x+qN4UKBidlNzRNRfmC1BLVCeQdUnMN5rM+7A=
X-Google-Smtp-Source: ABdhPJxnrt2ZUwS5L+/eQtWvS1BXqQqmM14zcLHtVSAVJiSqXvkUNUhxSaWuNQiCgCi+NUDmPIyimFxLEKFXNx8k70o=
X-Received: by 2002:a25:90a:: with SMTP id 10mr33159024ybj.407.1643191797143;
 Wed, 26 Jan 2022 02:09:57 -0800 (PST)
MIME-Version: 1.0
References: <20220114081542.698002137@linuxfoundation.org> <20220114081542.746291845@linuxfoundation.org>
In-Reply-To: <20220114081542.746291845@linuxfoundation.org>
From:   Jack Wang <jack.wang.usish@gmail.com>
Date:   Wed, 26 Jan 2022 11:09:46 +0100
Message-ID: <CA+res+S1GcDzM6hnmar+s1k3ggswURZ+_8BqweifShCTjVJ2aQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 01/25] md: revert io stats accounting
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Guoqing Jiang <jiangguoqing@kylinos.cn>,
        Song Liu <song@kernel.org>,
        Guillaume Morin <guillaume@morinfr.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Greg Kroah-Hartman <gregkh@linuxfoundation.org> =E4=BA=8E2022=E5=B9=B41=E6=
=9C=8814=E6=97=A5=E5=91=A8=E4=BA=94 19:57=E5=86=99=E9=81=93=EF=BC=9A
>
> From: Guoqing Jiang <jgq516@gmail.com>
>
> commit ad3fc798800fb7ca04c1dfc439dba946818048d8 upstream.
>
> The commit 41d2d848e5c0 ("md: improve io stats accounting") could cause
> double fault problem per the report [1], and also it is not correct to
> change ->bi_end_io if md don't own it, so let's revert it.
>
> And io stats accounting will be replemented in later commits.
>
> [1]. https://lore.kernel.org/linux-raid/3bf04253-3fad-434a-63a7-20214e38c=
f26@gmail.com/T/#t
>
> Fixes: 41d2d848e5c0 ("md: improve io stats accounting")
> Signed-off-by: Guoqing Jiang <jiangguoqing@kylinos.cn>
> Signed-off-by: Song Liu <song@kernel.org>
> [GM: backport to 5.10-stable]
> Signed-off-by: Guillaume Morin <guillaume@morinfr.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/md/md.c |   57 +++++++++++--------------------------------------=
-------
>  drivers/md/md.h |    1
>  2 files changed, 12 insertions(+), 46 deletions(-)
>
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -459,34 +459,12 @@ check_suspended:
>  }
>  EXPORT_SYMBOL(md_handle_request);
>
> -struct md_io {
> -       struct mddev *mddev;
> -       bio_end_io_t *orig_bi_end_io;
> -       void *orig_bi_private;
> -       unsigned long start_time;
> -       struct hd_struct *part;
> -};
> -
> -static void md_end_io(struct bio *bio)
> -{
> -       struct md_io *md_io =3D bio->bi_private;
> -       struct mddev *mddev =3D md_io->mddev;
> -
> -       part_end_io_acct(md_io->part, bio, md_io->start_time);
> -
> -       bio->bi_end_io =3D md_io->orig_bi_end_io;
> -       bio->bi_private =3D md_io->orig_bi_private;
> -
> -       mempool_free(md_io, &mddev->md_io_pool);
> -
> -       if (bio->bi_end_io)
> -               bio->bi_end_io(bio);
> -}
> -
>  static blk_qc_t md_submit_bio(struct bio *bio)
>  {
>         const int rw =3D bio_data_dir(bio);
> +       const int sgrp =3D op_stat_group(bio_op(bio));
>         struct mddev *mddev =3D bio->bi_disk->private_data;
> +       unsigned int sectors;
>
>         if (mddev =3D=3D NULL || mddev->pers =3D=3D NULL) {
>                 bio_io_error(bio);
> @@ -507,26 +485,21 @@ static blk_qc_t md_submit_bio(struct bio
>                 return BLK_QC_T_NONE;
>         }
>
> -       if (bio->bi_end_io !=3D md_end_io) {
> -               struct md_io *md_io;
> -
> -               md_io =3D mempool_alloc(&mddev->md_io_pool, GFP_NOIO);
> -               md_io->mddev =3D mddev;
> -               md_io->orig_bi_end_io =3D bio->bi_end_io;
> -               md_io->orig_bi_private =3D bio->bi_private;
> -
> -               bio->bi_end_io =3D md_end_io;
> -               bio->bi_private =3D md_io;
> -
> -               md_io->start_time =3D part_start_io_acct(mddev->gendisk,
> -                                                      &md_io->part, bio)=
;
> -       }
> -
> +       /*
> +        * save the sectors now since our bio can
> +        * go away inside make_request
> +        */
> +       sectors =3D bio_sectors(bio);
This code snip is not inside the original patch, and it's not in
latest upstream too.
>         /* bio could be mergeable after passing to underlayer */
>         bio->bi_opf &=3D ~REQ_NOMERGE;
>
>         md_handle_request(mddev, bio);
>
> +       part_stat_lock();
> +       part_stat_inc(&mddev->gendisk->part0, ios[sgrp]);
> +       part_stat_add(&mddev->gendisk->part0, sectors[sgrp], sectors);
> +       part_stat_unlock();
> +
same here, this code snip is not inside the original patch, and it's
not in latest upstream too.

I think would be good keep it as the upstream version.

Best!
Jinpu Wang @ IONOS
>         return BLK_QC_T_NONE;
>  }
>
> @@ -5636,7 +5609,6 @@ static void md_free(struct kobject *ko)
>
>         bioset_exit(&mddev->bio_set);
>         bioset_exit(&mddev->sync_set);
> -       mempool_exit(&mddev->md_io_pool);
>         kfree(mddev);
>  }
>
> @@ -5732,11 +5704,6 @@ static int md_alloc(dev_t dev, char *nam
>                  */
>                 mddev->hold_active =3D UNTIL_STOP;
>
> -       error =3D mempool_init_kmalloc_pool(&mddev->md_io_pool, BIO_POOL_=
SIZE,
> -                                         sizeof(struct md_io));
> -       if (error)
> -               goto abort;
> -
>         error =3D -ENOMEM;
>         mddev->queue =3D blk_alloc_queue(NUMA_NO_NODE);
>         if (!mddev->queue)
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -487,7 +487,6 @@ struct mddev {
>         struct bio_set                  sync_set; /* for sync operations =
like
>                                                    * metadata and bitmap =
writes
>                                                    */
> -       mempool_t                       md_io_pool;
>
>         /* Generic flush handling.
>          * The last to finish preflush schedules a worker to submit
>
>
