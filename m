Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB0B45DD2A
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 16:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236247AbhKYPUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 10:20:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237206AbhKYPSz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 10:18:55 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4DA0C06175B
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 07:15:43 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id v11so12333578wrw.10
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 07:15:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Zj416Vf8zsYBbJCqFaMVME/6Ft5bARpxqJrpdaCk4II=;
        b=oP1d48T1p3nLFpm7ZSg2PWxfhBYYNWCv/ZV1tAnAhS19Wr2988wIl2RVJbdtkPUCuP
         R0NaNGR5cn7AGwyQ3JFyzOOO3YOReU/zQ8K/HxeIwH7c5o+wVcjMovbMTQPDUAmVPeRa
         lRCW9SEmfGTun59BFjVM6xJlbWGo1CLE2s8Zo4mtasCOvTCnC5/Httl2dvADqe0sBKLo
         JGWhkAvfyCo2xSUihb60qWtwq5QATQvrMsVoZjBaHA5lmesx79iAc6nRj5Yq6d7MDH41
         57Qerq6P33Am67qyUG2fh36wuZ7zuyhEnNIy1gf5AOrzAOfZgorwIOLrEk4itNvAvnrp
         lDbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Zj416Vf8zsYBbJCqFaMVME/6Ft5bARpxqJrpdaCk4II=;
        b=bzP6PNdNRNYdof/Tm7fRSRRCBHlDJg4VZCpZ5kTCRTO4sno3xv3vJQki75Ximsd7mP
         uZbA0oKtGgMsNXdtQmVupwF+BtUuTXTDV8jEvrvYaS0P6TkEs4qxym4nnnbDgspCc1lJ
         xeG8XroakV7o3lVAbw81aTqmqJfTQD4NSRS49X8blR3Dw3RPfq3FqeGAphT88sE8yGNa
         r27akTqAESiuL7tRjwtEW4eoXPcfBmvMG08dK7lqCcl8ulYpkUKMEySq3pMsjl2jSWST
         PuuAUCYy/WL6cUbWA2URVpYZrlzCh6qW/1/3Lr/5ekVS1Omnz6TpR4MUR28GV4NNMidZ
         cTog==
X-Gm-Message-State: AOAM532nhFc5mOACDbRZJeEoch6oqgMaqabgMKhL27dlfnv6sj0VCtFT
        Ev7VxW6xjYePtdpRWtzKeHhl0g==
X-Google-Smtp-Source: ABdhPJxZQ1dDUlRDRcJUlqWVWaidS/zH2a4V8OQdxM4LXyajSGenH+8rxPuNjo+rKeddxNmgBF+Ljw==
X-Received: by 2002:a05:6000:181:: with SMTP id p1mr7436769wrx.292.1637853342240;
        Thu, 25 Nov 2021 07:15:42 -0800 (PST)
Received: from google.com ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id f13sm3956882wmq.29.2021.11.25.07.15.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 07:15:41 -0800 (PST)
Date:   Thu, 25 Nov 2021 15:15:40 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     devel@driverdev.osuosl.org, arve@android.com,
        stable@vger.kernel.org, riandrews@android.com, labbott@redhat.com,
        sumit.semwal@linaro.org
Subject: Re: [PATCH 1/1] staging: ion: Prevent incorrect reference counting
 behavour
Message-ID: <YZ+onFjtf5l311Xa@google.com>
References: <20211125142004.686650-1-lee.jones@linaro.org>
 <20211125145004.GN6514@kadam>
 <YZ+muS7vC5iNs/kq@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YZ+muS7vC5iNs/kq@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 25 Nov 2021, Lee Jones wrote:

> On Thu, 25 Nov 2021, Dan Carpenter wrote:
> 
> > On Thu, Nov 25, 2021 at 02:20:04PM +0000, Lee Jones wrote:
> > > Supply additional checks in order to prevent unexpected results.
> > > 
> > > Fixes: b892bf75b2034 ("ion: Switch ion to use dma-buf")
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > > Should be back-ported from v4.9 and earlier.
> > > 
> > >  drivers/staging/android/ion/ion.c | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > > 
> > > diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
> > > index 806e9b30b9dc8..402b74f5d7e69 100644
> > > --- a/drivers/staging/android/ion/ion.c
> > > +++ b/drivers/staging/android/ion/ion.c
> > > @@ -29,6 +29,7 @@
> > >  #include <linux/export.h>
> > >  #include <linux/mm.h>
> > >  #include <linux/mm_types.h>
> > > +#include <linux/overflow.h>
> > >  #include <linux/rbtree.h>
> > >  #include <linux/slab.h>
> > >  #include <linux/seq_file.h>
> > > @@ -509,6 +510,10 @@ static void *ion_handle_kmap_get(struct ion_handle *handle)
> > >  	void *vaddr;
> > >  
> > >  	if (handle->kmap_cnt) {
> > > +		if (check_add_overflow(handle->kmap_cnt,
> > > +				       (unsigned int) 1, &handle->kmap_cnt))
> >                                                          ^^^^^^^^^^^^^^^^^
> > 
> > > +			return ERR_PTR(-EOVERFLOW);
> > > +
> > >  		handle->kmap_cnt++;
> >                 ^^^^^^^^^^^^^^^^^^^
> > This will not do what you want at all.  It's a double increment on the
> > success path and it leave handle->kmap_cnt overflowed on failure path.
> 
> I read the helper to take copies of the original variables.
> 
> #define __unsigned_add_overflow(a, b, d) ({     \
>         typeof(a) __a = (a);                    \
>         typeof(b) __b = (b);                    \
>         typeof(d) __d = (d);                    \
>         (void) (&__a == &__b);                  \
>         (void) (&__a == __d);                   \
>         *__d = __a + __b;                       \
>         *__d < __a;                             \
> })
> 
> Maybe I misread it.

I think I see now.

Copies are taken, but because 'd' is a pointer, dereferencing the copy
is just like dereferencing the original, thus the memory address
provided by 'd' is written to, updating the variable.

In this case, you're right, this is not what I was trying to achieve.

> So the original patch [0] was better?
> 
> [0] https://lore.kernel.org/stable/20211125120234.67987-1-lee.jones@linaro.org/

Greg, are you able to take the original patch for v4.4 and v4.9 please?

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
