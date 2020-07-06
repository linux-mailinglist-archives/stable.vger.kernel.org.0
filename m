Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C994B2152E5
	for <lists+stable@lfdr.de>; Mon,  6 Jul 2020 09:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgGFHM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jul 2020 03:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728306AbgGFHM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jul 2020 03:12:58 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDB8C08C5DF
        for <stable@vger.kernel.org>; Mon,  6 Jul 2020 00:12:57 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id z13so39612873wrw.5
        for <stable@vger.kernel.org>; Mon, 06 Jul 2020 00:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=FoSjIG3VRw8M9fOU/dfLMuLezeTkp5UAh0BxNMHAjSU=;
        b=if9HBlA9VQz/DooWA8KmSxJ1gwN0Z/+q/abPRsudszDLAPA5Sax63WJuxR/o0W7YRW
         pY3+BOTmv9n1glV/nSTkzluey/r9TND8/Um1sbKlF7gaOJyxNkt3qpbkSHwhnPt2fgvA
         PrhvSA8l2QPunnrnOJDw73eRQ+4iGvqYbzEDWJziNcpx3AH93pN474NFD5hNkR34Avfq
         L4BIuECug2LTD7En9WA6bmt9HuCDKrCzb2FwCrCAH3wEUGUiENhaLPGCX2fuvKxC0OD9
         s5DsLrUA93+Of8tTSSH4UjB1bRwCruHx5RgHBrpx2bvmK3cJDhrrequ1c+JCNU6MxS2u
         EJuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=FoSjIG3VRw8M9fOU/dfLMuLezeTkp5UAh0BxNMHAjSU=;
        b=o1gAalzRp7RibVrOE7aShMjPSCi3LdKRJfN/r2y/r4MmmeyZDuiOUhs4ZOv/7x52Tu
         dVT1SyAoaWJtI1qZyT1mwMjOmfDVROOzVRN8iCKAM9UnJrtvu4guiqvvUpJywly7kJgD
         gCITSzSz2+fxpxoZFyDjo+FV0tSRBNqBjk8U3jsnYwUACpHmrHJvccFcl3dpAnidGEU+
         3ioCjgAsK75I2Tbzj+ePaHFh6N4eUZJlkel3u6H++LgpaosnHoNIciUuZDcGRFLmJ7tz
         W202pPLCD9yKwp4wPPPyMtUpo/zF4MK3mpsty+XSsd3rjE0CT2MJ2NpZiuxO4Vs5ffmb
         ThLg==
X-Gm-Message-State: AOAM533fU7/aOXGdYYeHdkHcT20VXd6jX648e0TnbTpm6e6Zg19yatNQ
        GtprxF4BTOl9MpR3NKLt5Sjitg==
X-Google-Smtp-Source: ABdhPJwLhBlFAKN26FXGsrKJ2/3ld4/TUj5IudfdjzM/ZuZS/dr7xAKMChCzQ/pTpQ6ikPiMmParcw==
X-Received: by 2002:a5d:610a:: with SMTP id v10mr46895795wrt.108.1594019576099;
        Mon, 06 Jul 2020 00:12:56 -0700 (PDT)
Received: from dell ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id 65sm22090235wmd.20.2020.07.06.00.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 00:12:55 -0700 (PDT)
Date:   Mon, 6 Jul 2020 08:12:53 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Daniel Thompson <daniel.thompson@linaro.org>
Cc:     jingoohan1@gmail.com, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Software Engineering <sbabic@denx.de>
Subject: Re: [PATCH 3/8] backlight: ili922x: Add missing kerneldoc
 descriptions for CHECK_FREQ_REG() args
Message-ID: <20200706071253.GA2821869@dell>
References: <20200624145721.2590327-1-lee.jones@linaro.org>
 <20200624145721.2590327-4-lee.jones@linaro.org>
 <20200625094051.u4hanl3rycczlwiy@holly.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200625094051.u4hanl3rycczlwiy@holly.lan>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 25 Jun 2020, Daniel Thompson wrote:

> On Wed, Jun 24, 2020 at 03:57:16PM +0100, Lee Jones wrote:
> > Kerneldoc syntax is used, but not complete.  Descriptions required.
> > 
> > Prevents warnings like:
> > 
> >  drivers/video/backlight/ili922x.c:116: warning: Function parameter or member 's' not described in 'CHECK_FREQ_REG'
> >  drivers/video/backlight/ili922x.c:116: warning: Function parameter or member 'x' not described in 'CHECK_FREQ_REG'
> > 
> > Cc: <stable@vger.kernel.org>
> > Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Cc: Software Engineering <sbabic@denx.de>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/video/backlight/ili922x.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/video/backlight/ili922x.c b/drivers/video/backlight/ili922x.c
> > index 9c5aa3fbb2842..8cb4b9d3c3bba 100644
> > --- a/drivers/video/backlight/ili922x.c
> > +++ b/drivers/video/backlight/ili922x.c
> > @@ -107,6 +107,8 @@
> >   *	lower frequency when the registers are read/written.
> >   *	The macro sets the frequency in the spi_transfer structure if
> >   *	the frequency exceeds the maximum value.
> > + * @s: pointer to controller side proxy for an SPI slave device
> 
> What's wrong with "a pointer to an SPI device"?

I've fixed this and applied the patch.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
