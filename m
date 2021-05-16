Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF91381D01
	for <lists+stable@lfdr.de>; Sun, 16 May 2021 07:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233028AbhEPF32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 May 2021 01:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbhEPF31 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 May 2021 01:29:27 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6920C061573;
        Sat, 15 May 2021 22:28:12 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id pf4-20020a17090b1d84b029015ccffe0f2eso3852605pjb.0;
        Sat, 15 May 2021 22:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NA/OuPh7y3nBq4fiIAatzLA6oIbKvh9mNka2mUm7JVk=;
        b=KNR1ij96BfvwR8fCNNsjyMfVp2OFr9vXF3UdEu+aHR2RpnYf6pmOnItoxr4KLFPIip
         0HXCqRmcwYmkzEuuxe94gHQ5mAP5RoJOG1pw5/FRpDG759CSnIiKrRt29IMz5ScsyT7T
         8PJUZtzbfHap9TITnkNA+rIKdP4Ec8gGhxRMFfaQObQgdFDp582Jc3xjxlGvxjnsHiYh
         5o9edi1MylBcrq4y4nRthkWcWzvkbQkqstB2GvrwkaZDmF6hn4fAbYjF9UnGj3mOJVNa
         ywfx4oF0fE02mRm0RPsdCDsth7w2AK4OaJkxupPYMYroX0XMIVhz5G0wA64gjNHyWJbD
         p6yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NA/OuPh7y3nBq4fiIAatzLA6oIbKvh9mNka2mUm7JVk=;
        b=gRWRWm1MQKorVFFvvV8CbMzHpFol8jqgQr/Tg07bBGb4cGkyJEN+8hc+fR40klC4p9
         5s9XXFsldD7rbqvmfBZOtBRhSKvgJ9iGIs55ja1gwqH5mmFPylVacBVypAOiKOdFMR1/
         FeFg9TeDaenakRDi8mBOhBEsNsz3FjwattElUKr9F27VxMhnsPeie6nS5xKvMt8R96SS
         npXVML9pE8cezn5egJoG6YN8oqvrCS7JJPfDCCYo/YDSg9kp6f6qaSl/4PQ5lkv7qxIV
         TUABUSsHxfb14gRjXGD16nZTES74hmYOLE82wt1qmZIJn+HW1AoBj8q07q+GiJUeMRND
         dNEA==
X-Gm-Message-State: AOAM530rcW+KvXmvVYD/wY4oRVrm10jnsmzUZlEaGGIzUi3FB6AaCxE4
        Wgc9ZFerBhli9HNkIqsdM+v+UTfrE6WCIaygSUMmlkkXNL8=
X-Google-Smtp-Source: ABdhPJwiuCTb+tflDAxzXHYoPovTD5lDdbRxxGbYIWHZ5pQubjRNOPiWnkWF+AzW9n3G/C2DWO+ZMEkXT8emPq+PrLw=
X-Received: by 2002:a17:902:b406:b029:ec:fbf2:4114 with SMTP id
 x6-20020a170902b406b02900ecfbf24114mr54345810plr.32.1621142892027; Sat, 15
 May 2021 22:28:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210512144819.664462530@linuxfoundation.org> <20210512144820.931257479@linuxfoundation.org>
 <20210515195221.GA4103@amd>
In-Reply-To: <20210515195221.GA4103@amd>
From:   Alexandru Ardelean <ardeleanalex@gmail.com>
Date:   Sun, 16 May 2021 08:28:00 +0300
Message-ID: <CA+U=DsqgFx0GVgnkAQNFVgUjBWMAVaD2ryhKtuF7oVHFbyYh9g@mail.gmail.com>
Subject: Re: [PATCH 5.10 036/530] iio:adc:ad7476: Fix remove handling
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Michael Hennerich <michael.hennerich@analog.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 15, 2021 at 10:52 PM Pavel Machek <pavel@denx.de> wrote:
>
> Hi!
> >
> > commit 6baee4bd63f5fdf1716f88e95c21a683e94fe30d upstream.
> >
> > This driver was in an odd half way state between devm based cleanup
> > and manual cleanup (most of which was missing).
> > I would guess something went wrong with a rebase or similar.
> > Anyhow, this basically finishes the job as a precursor to improving
> > the regulator handling.
>
> I don't think this is correct:
>
> > --- a/drivers/iio/adc/ad7476.c
> > +++ b/drivers/iio/adc/ad7476.c
> > @@ -316,25 +316,15 @@ static int ad7476_probe(struct spi_devic
> >       spi_message_init(&st->msg);
> >       spi_message_add_tail(&st->xfer, &st->msg);
> >
> > -     ret = iio_triggered_buffer_setup(indio_dev, NULL,
> > -                     &ad7476_trigger_handler, NULL);
> > +     ret = devm_iio_triggered_buffer_setup(&spi->dev, indio_dev, NULL,
> > +                                           &ad7476_trigger_handler, NULL);
> >       if (ret)
> > -             goto error_disable_reg;
> > +             return ret;
> >
> >       if (st->chip_info->reset)
> >               st->chip_info->reset(st);
> >
> > -     ret = iio_device_register(indio_dev);
> > -     if (ret)
> > -             goto error_ring_unregister;
> > -     return 0;
> > -
> > -error_ring_unregister:
> > -     iio_triggered_buffer_cleanup(indio_dev);
> > -error_disable_reg:
> > -     regulator_disable(st->reg);
> > -
>
> Regulator_disable is now removed, but we still use regulator_enable,
> and we still need to keep it balanced.

Yes, but that's what this block does:
    ret = devm_add_action_or_reset(&spi->dev, ad7476_reg_disable,
                       st);
    if (ret)
        return ret;

It registers a device-managed action to disable the regulator on error
or remove.
That ad7476_reg_disable() hook was implemented on commit:
4bb2b8f94ace3 ("iio: adc: ad7476: implement devm_add_action_or_reset")

But for some reason it wasn't done correctly, as this part [in this
patch] wasn't included in the 4bb2b8f94ace3  commit.

>
> > -     return ret;
> > +     return devm_iio_device_register(&spi->dev, indio_dev);
> >  }
>
> Best regards,
>                                                                 Pavel
>
> --
> DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
