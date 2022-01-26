Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE30749C9DB
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 13:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234366AbiAZMh2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 07:37:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241407AbiAZMhY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 07:37:24 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D559C06161C;
        Wed, 26 Jan 2022 04:37:24 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id i62so24552305ybg.5;
        Wed, 26 Jan 2022 04:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mGkdpjPQS3p/r4eKPClAoEvWiNhDgwz+9Z76WPB1ajA=;
        b=FL8AJJEIxFATfAFusMZosYP9jZz4IKpVENfsuiTrrsZKS8MCFkjQkPGV/tz7aCoj6+
         qCwB5WAqsaKOLpXueWt4Xsbac4Sst/JgdLt9xsqKvd3zyMY7AFaO/KBiUTfSD6kctzeK
         Lggt3N5m7JuMoDA3bft3krbzkyphkF3ZzCJaLbaR+vcmjMM+4hMnSfJyIiHHHM/TMrRC
         CMC1Jo3k7qLZQ/UCxu3LyfiBeqeoxq8PWIMRvczcid0KSSx4WQ5AUNX8LeZQ4lVkeabU
         PBv3cl7eRIF07Bo1NgBahRSsYhpZxq4tF0YziUDUFHxU76p7clMdZAIB34r+Z7yHgeHb
         9k/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mGkdpjPQS3p/r4eKPClAoEvWiNhDgwz+9Z76WPB1ajA=;
        b=FqK/7/X61+yksivV5Y+b/maJ7ehOXGYNIDT4XGbIRmMVbt7CEuJSRCDS6TMpyw0OFC
         mCYm45Gy0XzDY+df7KcKlwfQxpmxPlfNAHU9eCZQmUZFbKFSBya4S/XVlCRNpf7LaC9S
         EOmvh7z6WioEPlqUXQuulaptkQD4DQig8TKufZbb6dcbEXOSghD4mgAsGiMFLj+xXY+q
         A1kYWed/jr1MLwpD980oUVtHyjbCeNZ8YXtOyMZO17xaptPZ3LNqKlkl/jd9fmI+imb/
         tn158mAnGDCyH6Anc/6PhlxWAPyc6533bt23+UgDOq4Vl1IWk6QHiHv6+5A6PG/gn6qO
         rIKw==
X-Gm-Message-State: AOAM532gZZDlCyAmZngLGQ9/ydhcHu0LAMIp25mjtuaXNjbVI9v5GhJ0
        5FOjC4eA9rU1dZE6rHe5SFYn5Mh5GyRjeafYAhZzYEkc9zQ=
X-Google-Smtp-Source: ABdhPJy1+l94JaxBT0T+J5dhXnhrBCXP0cmboOh2bUx+JpzxFYUt4ETjIvYyD0/SAbmgznfdtAzYHjRdTB4chMOkt6k=
X-Received: by 2002:a5b:982:: with SMTP id c2mr35553308ybq.103.1643200643623;
 Wed, 26 Jan 2022 04:37:23 -0800 (PST)
MIME-Version: 1.0
References: <20220114081542.698002137@linuxfoundation.org> <20220114081542.746291845@linuxfoundation.org>
 <CA+res+S1GcDzM6hnmar+s1k3ggswURZ+_8BqweifShCTjVJ2aQ@mail.gmail.com> <YfEztOTIhGjm3Hvs@kroah.com>
In-Reply-To: <YfEztOTIhGjm3Hvs@kroah.com>
From:   Jack Wang <jack.wang.usish@gmail.com>
Date:   Wed, 26 Jan 2022 13:37:12 +0100
Message-ID: <CA+res+RpQuedYu3hhRo5kBcs3tQrKc+7eyiFbVUAVG2h68cYkg@mail.gmail.com>
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

Greg Kroah-Hartman <gregkh@linuxfoundation.org> =E4=BA=8E2022=E5=B9=B41=E6=
=9C=8826=E6=97=A5=E5=91=A8=E4=B8=89 12:42=E5=86=99=E9=81=93=EF=BC=9A
>
> On Wed, Jan 26, 2022 at 11:09:46AM +0100, Jack Wang wrote:
> > Hi,
> >
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org> =E4=BA=8E2022=E5=B9=B41=
=E6=9C=8814=E6=97=A5=E5=91=A8=E4=BA=94 19:57=E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > From: Guoqing Jiang <jgq516@gmail.com>
> > >
> > > commit ad3fc798800fb7ca04c1dfc439dba946818048d8 upstream.
> > >
> > > The commit 41d2d848e5c0 ("md: improve io stats accounting") could cau=
se
> > > double fault problem per the report [1], and also it is not correct t=
o
> > > change ->bi_end_io if md don't own it, so let's revert it.
> > >
> > > And io stats accounting will be replemented in later commits.
> > >
> > > [1]. https://lore.kernel.org/linux-raid/3bf04253-3fad-434a-63a7-20214=
e38cf26@gmail.com/T/#t
> > >
> > > Fixes: 41d2d848e5c0 ("md: improve io stats accounting")
> > > Signed-off-by: Guoqing Jiang <jiangguoqing@kylinos.cn>
> > > Signed-off-by: Song Liu <song@kernel.org>
> > > [GM: backport to 5.10-stable]
> > > Signed-off-by: Guillaume Morin <guillaume@morinfr.org>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > >  drivers/md/md.c |   57 +++++++++++----------------------------------=
-----------
> > >  drivers/md/md.h |    1
> > >  2 files changed, 12 insertions(+), 46 deletions(-)
> > >
> > > --- a/drivers/md/md.c
> > > +++ b/drivers/md/md.c
> > > @@ -459,34 +459,12 @@ check_suspended:
> > >  }
> > >  EXPORT_SYMBOL(md_handle_request);
> > >
> > > -struct md_io {
> > > -       struct mddev *mddev;
> > > -       bio_end_io_t *orig_bi_end_io;
> > > -       void *orig_bi_private;
> > > -       unsigned long start_time;
> > > -       struct hd_struct *part;
> > > -};
> > > -
> > > -static void md_end_io(struct bio *bio)
> > > -{
> > > -       struct md_io *md_io =3D bio->bi_private;
> > > -       struct mddev *mddev =3D md_io->mddev;
> > > -
> > > -       part_end_io_acct(md_io->part, bio, md_io->start_time);
> > > -
> > > -       bio->bi_end_io =3D md_io->orig_bi_end_io;
> > > -       bio->bi_private =3D md_io->orig_bi_private;
> > > -
> > > -       mempool_free(md_io, &mddev->md_io_pool);
> > > -
> > > -       if (bio->bi_end_io)
> > > -               bio->bi_end_io(bio);
> > > -}
> > > -
> > >  static blk_qc_t md_submit_bio(struct bio *bio)
> > >  {
> > >         const int rw =3D bio_data_dir(bio);
> > > +       const int sgrp =3D op_stat_group(bio_op(bio));
> > >         struct mddev *mddev =3D bio->bi_disk->private_data;
> > > +       unsigned int sectors;
> > >
> > >         if (mddev =3D=3D NULL || mddev->pers =3D=3D NULL) {
> > >                 bio_io_error(bio);
> > > @@ -507,26 +485,21 @@ static blk_qc_t md_submit_bio(struct bio
> > >                 return BLK_QC_T_NONE;
> > >         }
> > >
> > > -       if (bio->bi_end_io !=3D md_end_io) {
> > > -               struct md_io *md_io;
> > > -
> > > -               md_io =3D mempool_alloc(&mddev->md_io_pool, GFP_NOIO)=
;
> > > -               md_io->mddev =3D mddev;
> > > -               md_io->orig_bi_end_io =3D bio->bi_end_io;
> > > -               md_io->orig_bi_private =3D bio->bi_private;
> > > -
> > > -               bio->bi_end_io =3D md_end_io;
> > > -               bio->bi_private =3D md_io;
> > > -
> > > -               md_io->start_time =3D part_start_io_acct(mddev->gendi=
sk,
> > > -                                                      &md_io->part, =
bio);
> > > -       }
> > > -
> > > +       /*
> > > +        * save the sectors now since our bio can
> > > +        * go away inside make_request
> > > +        */
> > > +       sectors =3D bio_sectors(bio);
> > This code snip is not inside the original patch, and it's not in
> > latest upstream too.
> > >         /* bio could be mergeable after passing to underlayer */
> > >         bio->bi_opf &=3D ~REQ_NOMERGE;
> > >
> > >         md_handle_request(mddev, bio);
> > >
> > > +       part_stat_lock();
> > > +       part_stat_inc(&mddev->gendisk->part0, ios[sgrp]);
> > > +       part_stat_add(&mddev->gendisk->part0, sectors[sgrp], sectors)=
;
> > > +       part_stat_unlock();
> > > +
> > same here, this code snip is not inside the original patch, and it's
> > not in latest upstream too.
>
> Is it a problem?
Not sure, might cause some confusion regarding io stats.
>
> > I think would be good keep it as the upstream version.
>
> Can you send a revert of this commit (it is in 5.10.92), and a backport
> of the correct fix?
>
sure, I just sent an incremental fix for the backport itself.
is it ok?

Thanks!


> thanks,
>
> greg k-h
