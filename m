Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4E5209CEC
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 12:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403911AbgFYKdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 06:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403840AbgFYKdj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jun 2020 06:33:39 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB5CC061795
        for <stable@vger.kernel.org>; Thu, 25 Jun 2020 03:33:38 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id t194so5382444wmt.4
        for <stable@vger.kernel.org>; Thu, 25 Jun 2020 03:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=cwS7iBZ35KlWA6jBEXe+RY7hU/oltm4mf+ZLVTmBHbg=;
        b=ckSbRH6Y9xOKw8TwFf5S6Fhk1vOPMMffz1PvAsd5fQkuEUwGeqv8ZMfu7b4VseJXq+
         Q+Zwl6jtJPG6b8nC0vUNjXsuJBAHkcblkb0pQgjxdlrWuvAO3vVH5EOdN8ykR1fFNkO2
         0Y3+9hQyIHdmKpwtONksi/eq/d8zwBaAwnMZiCl2cMapDRa21bVFWnrvJmrLcOy/lGA5
         r1jIAR/pLarr4nRMPCFRPDiBFXE3KVAPa2+iPKV0c4lCbi24fnFNTvU8a5C/BFnrqmFF
         NBvqmgslp9dIo5O2WX8S0qZbHFB5FnOKAffE3NigkrXiKcASZlQGDfgOFNp/1b16IVxq
         irbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=cwS7iBZ35KlWA6jBEXe+RY7hU/oltm4mf+ZLVTmBHbg=;
        b=du3BtV7LPuhRRcH0yDXFi/ajc6R6BXOxVNGZrqARFVKB6WR/+uabMOKBoX2vkwSd1G
         dDIkUqrhqjTovMzkmY7ZtY5EKC5rgfM+527VBehWp57qRWgdjVdr6mFC7aDt3RvYdfaj
         MJ1JpBQiaiUq2fAqqJcMV1bwBHaQ58dzGEfRaBMiAIyAonc2YdJ2/OlMU780V8x+aXln
         eYg9yUfeFMULa9lBizZT8TG3KXCevdi61XIcytQTQ9AlPo8MzdNY1+QpRgqXyjS0/+5t
         i5lcrRGU00jGGeu5zlbGWX7pSfblDw2lYTsCWROS5CrOGwzCrM7lO0KkHHUXCFw2dgc+
         eQJQ==
X-Gm-Message-State: AOAM531T7ObXOjEbAUJcYcxmfsJD7FqRNB6FELwsBiOvnKqz2hCxNG9F
        YyxWn2ybL3CLuN59DI/KYnSYzw==
X-Google-Smtp-Source: ABdhPJxRQCCMvNxIjXjxszNKanKw0pTi4YzKhm6dZatNk1oJ81au17V7nolB179hYdVcODuntoi7tQ==
X-Received: by 2002:a7b:ce97:: with SMTP id q23mr2641581wmj.89.1593081217260;
        Thu, 25 Jun 2020 03:33:37 -0700 (PDT)
Received: from dell ([2.27.35.144])
        by smtp.gmail.com with ESMTPSA id t4sm5852497wmf.4.2020.06.25.03.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 03:33:36 -0700 (PDT)
Date:   Thu, 25 Jun 2020 11:33:34 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Daniel Thompson <daniel.thompson@linaro.org>
Cc:     jingoohan1@gmail.com, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Software Engineering <sbabic@denx.de>
Subject: Re: [PATCH 3/8] backlight: ili922x: Add missing kerneldoc
 descriptions for CHECK_FREQ_REG() args
Message-ID: <20200625103334.GO954398@dell>
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
> 
> I am aware, having looked it up to find out what the above actually
> means, that this is how struct spi_device is described in its own kernel
> doc but quoting at that level of detail of both overkill and confusing.

I figured that using the official description would be better than
making something up.  However if you think it's better to KISS, then I
can change it.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
