Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E23984ADC2B
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 16:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379706AbiBHPNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 10:13:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379725AbiBHPNN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 10:13:13 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9325FC061576
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 07:13:10 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id f18so4747951lfj.12
        for <stable@vger.kernel.org>; Tue, 08 Feb 2022 07:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/9sKVsOnc0cVS/8zSZ6ugv07iRnjigV6S3zogn8KAC4=;
        b=y91GP3EZwetiQxMDhlIjjv1c5AykdxJ9Y1SiEXTEOftWxlju22wr2p5GIX3gSBN7iX
         tFN8XytqW4DUsP8zFMkTGIqM3c6Jw5VCyBqDZYVkicU8hynDjraLo+tHNiMnpr0cydL6
         x1QHnY6wlwhPbyUo7ucsdSNimadY0DmegaLo6NOqVBLy7t6N3f2QLwHoo5VGoUUUF0zm
         dPyCzyiPYgXzAbB1NORdIAnathOKKdqwx0iUSjSk/vDCRq0kmSWWDIeT+SD9WTJVOqSj
         ezBdEl4YkT2ZSQFrKnldxcyJypYejHxI2V/XNuCVR5rIF59sb9TRJ3K5ZUJpCvoYAsmr
         PTNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/9sKVsOnc0cVS/8zSZ6ugv07iRnjigV6S3zogn8KAC4=;
        b=M7X/S2DMMsOt2Kzn6U7S8BHMnogcFcMeRcClp/655+jg9vrKlVkUDTRhiIGl2tHjKZ
         oT2XE6iQud9p58WvvX0fSor1hkXvxATOPcY1Fc5BHBPTmQx8nqWH7YOEivkQTR7+87jt
         1EZFPXGsYQ4ywxGxxGcFobhCtDzlthsWO9rKxwLkw9GNdGlYynrYAMhZW5inZ190xEfl
         6NzhLrP+B2HHvrJl8IlOeBwIOd4Y5fenEzfuiuxa+GEaygqr8BJWSayUMHpguQHBLSAE
         UbnHXB3EMADq+EQoH0u5LC6k6qHBMyILxNWTzP8KcyelKXZe7cm7jK/nsQyw2NpuOopA
         rUiw==
X-Gm-Message-State: AOAM532QSYI2end73eYu/x/hGA9Dj0nwJJ5KUYvEUmEYW3aAcdXUqFhd
        GL0nqBFxigRuQKsUFfhBoQh9wsW+PxkCcrKgzbpWyw==
X-Google-Smtp-Source: ABdhPJyNaIalMELpU7nV+Rc098C+S/9d3w1YEoJ5s6tRsR+iyYvZ0Ifdgwyu9N/cr3jjwp+NttkpZxdZ1gPMnzGz+8I=
X-Received: by 2002:a05:6512:3da8:: with SMTP id k40mr981439lfv.358.1644333188959;
 Tue, 08 Feb 2022 07:13:08 -0800 (PST)
MIME-Version: 1.0
References: <5e5f2e45d0a14a55a8b7a9357846114b@hyperstone.com>
 <7c4757cc707740e580c61c39f963a04d@hyperstone.com> <CAPDyKFr0YXCwL-8F9M7mkpNzSQpzw6gNUq2zaiJEXj1jNxUbrg@mail.gmail.com>
 <5c66833d-4b35-2c76-db54-0306e08843e5@intel.com> <79d44b0c54e048b0a9cc86319a24cc19@hyperstone.com>
 <bc706a6ab08c4fe2834ba0c05a804672@hyperstone.com> <b047d374-c282-8c63-32c1-2135eec11fb6@intel.com>
In-Reply-To: <b047d374-c282-8c63-32c1-2135eec11fb6@intel.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Tue, 8 Feb 2022 16:12:32 +0100
Message-ID: <CAPDyKFrhBdOO5O2Ef1Ny9BuvDCm6vt9TAL1rO=Qsx23xgb6LZA@mail.gmail.com>
Subject: Re: [PATCHv2] mmc: block: fix read single on recovery logic
To:     Adrian Hunter <adrian.hunter@intel.com>,
        =?UTF-8?Q?Christian_L=C3=B6hle?= <CLoehle@hyperstone.com>
Cc:     "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 8 Feb 2022 at 07:37, Adrian Hunter <adrian.hunter@intel.com> wrote:
>
> On 04/02/2022 17:11, Christian L=C3=B6hle wrote:
> > On reads with MMC_READ_MULTIPLE_BLOCK that fail,
> > the recovery handler will use MMC_READ_SINGLE_BLOCK for
> > each of the blocks, up to MMC_READ_SINGLE_RETRIES times each.
> > The logic for this is fixed to never report unsuccessful reads
> > as success to the block layer.
> >
> > On command error with retries remaining, blk_update_request was
> > called with whatever value error was set last to.
> > In case it was last set to BLK_STS_OK (default), the read will be
> > reported as success, even though there was no data read from the device=
.
> > This could happen on a CRC mismatch for the response,
> > a card rejecting the command (e.g. again due to a CRC mismatch).
> > In case it was last set to BLK_STS_IOERR, the error is reported correct=
ly,
> > but no retries will be attempted.
> >
> > Fixes: 81196976ed946c ("mmc: block: Add blk-mq support")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Christian Loehle <cloehle@hyperstone.com>
>
> Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>

Applied for fixes, thanks to both of you!

Kind regards
Uffe


>
> > ---
> > v2:
> >   - Do not allow data error retries
> >   - Actually retry MMC_READ_SINGLE_RETRIES times instead of
> >   MMC_READ_SINGLE_RETRIES-1
> >
> >
> >  drivers/mmc/core/block.c | 28 ++++++++++++++--------------
> >  1 file changed, 14 insertions(+), 14 deletions(-)
> >
> > diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
> > index 4e61b28a002f..8d718aa56d33 100644
> > --- a/drivers/mmc/core/block.c
> > +++ b/drivers/mmc/core/block.c
> > @@ -1682,31 +1682,31 @@ static void mmc_blk_read_single(struct mmc_queu=
e *mq, struct request *req)
> >       struct mmc_card *card =3D mq->card;
> >       struct mmc_host *host =3D card->host;
> >       blk_status_t error =3D BLK_STS_OK;
> > -     int retries =3D 0;
> >
> >       do {
> >               u32 status;
> >               int err;
> > +             int retries =3D 0;
> >
> > -             mmc_blk_rw_rq_prep(mqrq, card, 1, mq);
> > +             while (retries++ <=3D MMC_READ_SINGLE_RETRIES) {
> > +                     mmc_blk_rw_rq_prep(mqrq, card, 1, mq);
> >
> > -             mmc_wait_for_req(host, mrq);
> > +                     mmc_wait_for_req(host, mrq);
> >
> > -             err =3D mmc_send_status(card, &status);
> > -             if (err)
> > -                     goto error_exit;
> > -
> > -             if (!mmc_host_is_spi(host) &&
> > -                 !mmc_ready_for_data(status)) {
> > -                     err =3D mmc_blk_fix_state(card, req);
> > +                     err =3D mmc_send_status(card, &status);
> >                       if (err)
> >                               goto error_exit;
> > -             }
> >
> > -             if (mrq->cmd->error && retries++ < MMC_READ_SINGLE_RETRIE=
S)
> > -                     continue;
> > +                     if (!mmc_host_is_spi(host) &&
> > +                         !mmc_ready_for_data(status)) {
> > +                             err =3D mmc_blk_fix_state(card, req);
> > +                             if (err)
> > +                                     goto error_exit;
> > +                     }
> >
> > -             retries =3D 0;
> > +                     if (!mrq->cmd->error)
> > +                             break;
> > +             }
> >
> >               if (mrq->cmd->error ||
> >                   mrq->data->error ||
> >
>
