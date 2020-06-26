Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF5D220AF42
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 11:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbgFZJyK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 05:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbgFZJyK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jun 2020 05:54:10 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8BCC08C5DC
        for <stable@vger.kernel.org>; Fri, 26 Jun 2020 02:54:09 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id f18so8784559wml.3
        for <stable@vger.kernel.org>; Fri, 26 Jun 2020 02:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=e00BIFKWHJ6YcMg9EPGjuy1Mt05P2nAv4zIuOyB6gn0=;
        b=kinKxjmErW8QqeKv+vwukdSrfKkrbB8o0iVWzRuEXs3OFXf7u6MnH4Kg7U5g0REsV/
         578rsYOmgZeG/fLiyvY8FlLKUXZRVs8qlITYyAo+TY9rQJ3AB44b+px2fXUv1amtwNv3
         dTs/AyEO3EXnqNAdlLk29enj+r+Hul7vvfqB1Bqszyw69P3d5+ZJac7DwFnyxXozNo6W
         bqHkPDFe0+AxafWEWVFftHIHOz8GmAsuI9yvCKRVtTgFM6VZnzXpnl6cVx1zBeHAF4sS
         bNcRZSWzPvjS0Ut+6KDTjatPpElQI6pZt8lmx7mf5yOH7eAnHNyy5nNX41ZWheDmxfi+
         Unnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e00BIFKWHJ6YcMg9EPGjuy1Mt05P2nAv4zIuOyB6gn0=;
        b=GSRWSiyuE7y57KOP8AlRcjAsGpuWvp2uFYZiku8g5QiuEo65Aw4awBVFmQBSIVVFgw
         TPeogHLYbL/YYc1K7z0Qh5Vo9Zd7BSVcq3hsBz4DmCdUDufTVn+s4F47DdN8JdE3mSoJ
         6M9z3H+sCZ+xXrU8AUQeOZQrWQ4lKuC/3DRWpxWYMw3cc6yKKj6Vg8AaSqbcW38dJhUS
         N7PeczRNYHhOwmJ7aXicGc1r+sAkftylx3MNUGMQ4qqEajYhmb+y/mYw19mo7pRIjlsa
         b6q0ICMszcYoiar4euwpaYsb5sFj4UCVgfCm957IU2IMy9EQzediGBjyxo36yigRp038
         fjKg==
X-Gm-Message-State: AOAM530gvPijv+tVtloQYwAeyCMNq0jGF3mIx2LTwXWRw82mKUqhDQS6
        VX+6UYSCF48IAxh56zlr39FsugbXXYc=
X-Google-Smtp-Source: ABdhPJydqBupAhWSjmw8CKfQPZw6AA+9m1XpfRrVUZ2xhSaLPXAfZJjn3oquBKDEjAXfIW5EDnmb2w==
X-Received: by 2002:a1c:2982:: with SMTP id p124mr309487wmp.26.1593165248166;
        Fri, 26 Jun 2020 02:54:08 -0700 (PDT)
Received: from holly.lan (cpc141214-aztw34-2-0-cust773.18-1.cable.virginm.net. [86.9.19.6])
        by smtp.gmail.com with ESMTPSA id x7sm37219108wrr.72.2020.06.26.02.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 02:54:07 -0700 (PDT)
Date:   Fri, 26 Jun 2020 10:54:05 +0100
From:   Daniel Thompson <daniel.thompson@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     jingoohan1@gmail.com, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Software Engineering <sbabic@denx.de>
Subject: Re: [PATCH 3/8] backlight: ili922x: Add missing kerneldoc
 descriptions for CHECK_FREQ_REG() args
Message-ID: <20200626095405.nzhqsfjegj6qg2ro@holly.lan>
References: <20200624145721.2590327-1-lee.jones@linaro.org>
 <20200624145721.2590327-4-lee.jones@linaro.org>
 <20200625094051.u4hanl3rycczlwiy@holly.lan>
 <20200625103334.GO954398@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625103334.GO954398@dell>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 25, 2020 at 11:33:34AM +0100, Lee Jones wrote:
> On Thu, 25 Jun 2020, Daniel Thompson wrote:
> 
> > On Wed, Jun 24, 2020 at 03:57:16PM +0100, Lee Jones wrote:
> > > Kerneldoc syntax is used, but not complete.  Descriptions required.
> > > 
> > > Prevents warnings like:
> > > 
> > >  drivers/video/backlight/ili922x.c:116: warning: Function parameter or member 's' not described in 'CHECK_FREQ_REG'
> > >  drivers/video/backlight/ili922x.c:116: warning: Function parameter or member 'x' not described in 'CHECK_FREQ_REG'
> > > 
> > > Cc: <stable@vger.kernel.org>
> > > Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > > Cc: Software Engineering <sbabic@denx.de>
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > >  drivers/video/backlight/ili922x.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/drivers/video/backlight/ili922x.c b/drivers/video/backlight/ili922x.c
> > > index 9c5aa3fbb2842..8cb4b9d3c3bba 100644
> > > --- a/drivers/video/backlight/ili922x.c
> > > +++ b/drivers/video/backlight/ili922x.c
> > > @@ -107,6 +107,8 @@
> > >   *	lower frequency when the registers are read/written.
> > >   *	The macro sets the frequency in the spi_transfer structure if
> > >   *	the frequency exceeds the maximum value.
> > > + * @s: pointer to controller side proxy for an SPI slave device
> > 
> > What's wrong with "a pointer to an SPI device"?
> > 
> > I am aware, having looked it up to find out what the above actually
> > means, that this is how struct spi_device is described in its own kernel
> > doc but quoting at that level of detail of both overkill and confusing.
> 
> I figured that using the official description would be better than
> making something up.  However if you think it's better to KISS, then I
> can change it.

Yes, I'd strongly prefer KISS here.

I know it is an "I am the world" argument[1] but I found using such a
dogmatically accurate description out of context to be very confusing
and therefore I don't think such a comment improves readability.


Daniel.


[1]: See #3 from http://www.leany.com/logic/Adams.html
