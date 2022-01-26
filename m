Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB7C49D46A
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 22:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbiAZVWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 16:22:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232086AbiAZVWs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 16:22:48 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E0CC06161C;
        Wed, 26 Jan 2022 13:22:48 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id l68so2808551ybl.0;
        Wed, 26 Jan 2022 13:22:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SY0GeizykbQp0sWmEDcL6vm+zpq2S6X1Nj2tMV7OyfA=;
        b=Faee7/lninHeofHlJRvsrUsWmAtXQkCIGpwWNq4cVdhnIKH/FoVqnwe1fO1V5z02Qe
         WMQgPoD9toT1d/NmeS4OjmvdUQpFCaZU4zPLnjyLnmcbeHLcseelRmcRWD5IARKKgxz0
         nY3T7iltCyWeJFnPYqBXor1Z3Z88xkWnBaE+bNHu5h6bKvfrC3zFIyOOm++VM4OM1KVT
         QkuIowu5SRYlYH7kNwJOPJTVOEgRpu3a4bg6EtolRKvTRhm9s34JFRg3RjgYfEts27+j
         PYcmRzgimnsNpFkuc/MDfiFN4XqhPHG0ajzFXjsJOVvT9n2dUCbTGeobRbHzQu/A7qDD
         2JXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SY0GeizykbQp0sWmEDcL6vm+zpq2S6X1Nj2tMV7OyfA=;
        b=hfvBe0vT5fwDt8Hu65Oqng0zZ1jimLUceIOl/L27q3KnTScVUCHBUi5GeWDhu9+47K
         VO58iSO+/iqXI7Q2E6cbQhMLau5EJSAg5xe/FBs6rj1EPP6EXDNIdB2dYEdJnd7cqw8g
         c/ctXzjVRAl5BrazUU+MQMoDd0+s8WSsSZTao29JvjWMVRlsmqc9gIXifWNX+1m9Ctd4
         +xb5Y+4ZlKV9umuW0IoE7GSUjdQV4UZ8p8UmL22nINq7qNm3GUCVHC+9KNxWS/FXOl3U
         PK1xZVbQkm3j4UuY01CLWyrPgmvPHANiMnvurhiUsiBepr0DzOtnBmoEvJWOecADEV7l
         OGLA==
X-Gm-Message-State: AOAM531QgCcovWpeHWwjXaMuxZ1Xdr8t62Dm43uxxAvxsG+idnK6KvEY
        sB5lKqP+fQRYq43xlemsDBb8/VP7Br5ptuU5CZ8=
X-Google-Smtp-Source: ABdhPJyafzx7vAkOAqjKeOVASDon0U7hIxbUz+s78QV5FhaIbQpwrW1X3zniNfMPAAt4DT7C7ZzSSnMsXoMlOcedHAk=
X-Received: by 2002:a25:d4c9:: with SMTP id m192mr1158031ybf.526.1643232167745;
 Wed, 26 Jan 2022 13:22:47 -0800 (PST)
MIME-Version: 1.0
References: <20220114081542.698002137@linuxfoundation.org> <20220114081542.746291845@linuxfoundation.org>
 <CA+res+S1GcDzM6hnmar+s1k3ggswURZ+_8BqweifShCTjVJ2aQ@mail.gmail.com> <YfFk7guenfgvrDlD@bender.morinfr.org>
In-Reply-To: <YfFk7guenfgvrDlD@bender.morinfr.org>
From:   Jack Wang <jack.wang.usish@gmail.com>
Date:   Wed, 26 Jan 2022 22:22:36 +0100
Message-ID: <CA+res+SmjdYYsvJO5t4BQ6ZXxdJibDbV_gU0Q_fNb0jzw+H3-Q@mail.gmail.com>
Subject: Re: [PATCH 5.10 01/25] md: revert io stats accounting
To:     Guillaume Morin <guillaume@morinfr.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Guoqing Jiang <jiangguoqing@kylinos.cn>,
        Song Liu <song@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Guillaume Morin <guillaume@morinfr.org> =E4=BA=8E2022=E5=B9=B41=E6=9C=8826=
=E6=97=A5=E5=91=A8=E4=B8=89 16:12=E5=86=99=E9=81=93=EF=BC=9A
>
> On 26 Jan 11:09, Jack Wang wrote:
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
> Both snippets came from the code before 41d2d848e5c0 that the patch is
> being reverted here.  As I explained in my original message, upstream is
> different because of 99dfc43ecbf6 which is not in 5.10.
oh, I missed it, you are right.
>
> > I think would be good keep it as the upstream version.
>
> If you don't include these lines, isn't this worse as it's not calling
> either part_start_io_acct or bio_start_io_acct (in 99dfc43ecbf6)?

Your patch is correct.
Sorry for the noise.

>
> --
> Guillaume Morin <guillaume@morinfr.org>
