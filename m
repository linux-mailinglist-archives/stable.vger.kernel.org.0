Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5166149D46D
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 22:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbiAZVYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 16:24:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbiAZVYa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 16:24:30 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B882BC06161C
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 13:24:30 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id c6so2686315ybk.3
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 13:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+7Qd5CzM43w0jCTZE4F7b/QrzNLYHUABMaihvwjvcsM=;
        b=aTxwjiEW9EQjDW0nUuZ697qSlg5QybJWLStATxtXBrDfC0a4HCq28y6faBfIeooRkZ
         pZ2X8sJEFWwXTJiSxyXW4BTU6IHwP9DMgRigoYvrK2qt+3JohaakKrE2MmDdJjJZpRUL
         /bgB/xTo857TtK2qCh6MJXOz3kiqyFJIG3R3yn6Ort7hwqon4uIin6ouki6eH0MilaEd
         3Ijt3aGdhIvu+ZTeX2p+eG657hVkuCSnZvoU+W88h6ciuu2xhg7VM49vtXF5GVW5cnw2
         MgZXlBwxx2+GI5DNPXsJajB35uVUXLvSvgTQKCrp/SgfGgoQx6/XdRPpKu5IQzwYvc9m
         KdQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+7Qd5CzM43w0jCTZE4F7b/QrzNLYHUABMaihvwjvcsM=;
        b=bvbzDDP2rq0RdZl598tg3vOGtbsgLIbrFoQSA3CqOvSlCl0BWlUDFdRjpmyqxxOq+d
         kLxi5yGiF0Wed8o6YJO9iKK0/kz3QTtpTUptlM0LQUPtdkH0tFWNL2AVm7WztO8rgGbk
         kg8XhpLb63yK91q49J9ZeADkwMsumgdvu9Wh2yfoUZmaElqrWzYGwKpzIt6SY7cN6+D4
         x6CZxSBmBJeuJjnGND/S3HwCnuDbcBoXsqcuI5dqDXhy7n+P14R9bESAnWJ0C0BZwqwt
         ZJOc00HPSsvblbe2UKCL1RyYyzcga3cRXXgE36G6qjW2Ca0k/0YvoFtDG1JOP1lzNOvh
         PUFA==
X-Gm-Message-State: AOAM532LkPbGLptMnnB08SNLTQxfiyNxscHg5PHH9t+CCSFvA0oIf2kr
        U+U3PGnF2H0IwEGHuDExEsvOwYGrvXTm2/z/nhA=
X-Google-Smtp-Source: ABdhPJxIdM2JbV8aZT+ILT+CUUfy/BOagInedokpOiw4h/PnyugEVnRSxR0Gf5tHSgM7P4/Ly6VOhletIqDrEj5d1q0=
X-Received: by 2002:a25:c03:: with SMTP id 3mr1298631ybm.242.1643232270046;
 Wed, 26 Jan 2022 13:24:30 -0800 (PST)
MIME-Version: 1.0
References: <20220126123414.46953-1-jinpu.wang@ionos.com>
In-Reply-To: <20220126123414.46953-1-jinpu.wang@ionos.com>
From:   Jack Wang <jack.wang.usish@gmail.com>
Date:   Wed, 26 Jan 2022 22:24:19 +0100
Message-ID: <CA+res+SkOGeFfahWyjtJc5omQ2frA=Uu29W3pf6UsfjGL9kztQ@mail.gmail.com>
Subject: Re: [stable-5.10] MD: Fix up backport of MD io stats revert
To:     Jack Wang <jinpu.wang@ionos.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        stable <stable@vger.kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Song Liu <song@kernel.org>,
        Guillaume Morin <guillaume@morinfr.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Jack Wang <jinpu.wang@ionos.com> =E4=BA=8E2022=E5=B9=B41=E6=9C=8826=E6=97=
=A5=E5=91=A8=E4=B8=89 22:14=E5=86=99=E9=81=93=EF=BC=9A
>
> The backport to 5.10.92:
> commit c39d68ab3836 ("md: revert io stats accounting") is slightly
> different with upstream, remove unrelated change to be in sync
> with upstream.

Please ignore this, the backport in 5.10.92 is correct
>
> Cc: Guoqing Jiang <guoqing.jiang@linux.dev>
> Cc: Song Liu <song@kernel.org>
> Cc: Guillaume Morin <guillaume@morinfr.org>
> Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/md/md.c | 10 ----------
>  1 file changed, 10 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index cc3876500c4b..887f07beed1b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -485,21 +485,11 @@ static blk_qc_t md_submit_bio(struct bio *bio)
>                 return BLK_QC_T_NONE;
>         }
>
> -       /*
> -        * save the sectors now since our bio can
> -        * go away inside make_request
> -        */
> -       sectors =3D bio_sectors(bio);
>         /* bio could be mergeable after passing to underlayer */
>         bio->bi_opf &=3D ~REQ_NOMERGE;
>
>         md_handle_request(mddev, bio);
>
> -       part_stat_lock();
> -       part_stat_inc(&mddev->gendisk->part0, ios[sgrp]);
> -       part_stat_add(&mddev->gendisk->part0, sectors[sgrp], sectors);
> -       part_stat_unlock();
> -
>         return BLK_QC_T_NONE;
>  }
>
> --
> 2.25.1
>
