Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEEB45DCEC
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 16:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239206AbhKYPMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 10:12:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbhKYPKx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 10:10:53 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55778C0613DD
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 07:07:42 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id o13so12269003wrs.12
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 07:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=pB4n2TNbnUB7ciz0SA/lUO366pPT7mjGih2Fx1aGofw=;
        b=IbShBeTT/lv9mQqambnmEqwjXe0MpdAs6z6NgdU/gHUc73m4/UlXLGZ1A1a9+nd6Z+
         g7OSyrwMVCq6ZAUaUgvCrUXIKbLCAdNCECM5MUsOmyS4GxoXD9f8Bb84Ji5gIu9hXhs8
         pcurmsReX8aj8xXDCzj4oY8K9X8P6kZHMml7/Mq17syN4k7gxzMF3xn/nJt9vRQ2ILWz
         arlKQ/4ht9sACz2tHgFnV8l5cGzIPwZOFrnsZ4uldqluMN3Jgv0RFk89a+zr3c6QdUdq
         jE8OTcma6ZIHFitQBu6/93boJqEoUK6b9o8Jym8ywV/KoyZhhvJzZdjtscx/cCIsdKea
         QUxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=pB4n2TNbnUB7ciz0SA/lUO366pPT7mjGih2Fx1aGofw=;
        b=J62gxxjotUjWxTg10cNFCY03qAfcdvuDGiwSYw0fzTIid7l49c3i+AjaQ3AOQRvz2p
         3CVrROqcxeJ0DmY5YcMXbCCRvYnCUQbc/TYjQ4N2CzyM6jAFtGHy+Kj88wJ8zl9NuDCy
         8Pu6v1QzdkehlID5mZuOZXJ8lO6pJzA5sVcyJzL6nq4SDQEK5uWdZJb0Tje2YEgyEbGG
         OrL+IqMGbKrtKqTBwYu/7CuotNfcHpridWw5h+I3TnfmCW4GXcSfH21y2dr0i9aW2/x7
         EZ5pa3S2KQ3+wf1qTzzIIJfwAKJAVGye4M1kZypk+DqWKedf8+53l+O7Yf8SGzY1l3wO
         jmxw==
X-Gm-Message-State: AOAM531Q3XAmGneuV9sf/vYds7J75dQdlJwS/ig3AbxaChodurosMK/2
        NmnrYvIzC7G82i/TV9l3NkNRdQ==
X-Google-Smtp-Source: ABdhPJx3YL510Cj/37/QGg5Q7AMo+amXTbYcnmyA1WeW+lBxhz/aIskseo+kfjUJb9UP6s2S4Ipigw==
X-Received: by 2002:a5d:4d81:: with SMTP id b1mr7493208wru.366.1637852859655;
        Thu, 25 Nov 2021 07:07:39 -0800 (PST)
Received: from google.com ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id az15sm3123405wmb.0.2021.11.25.07.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 07:07:39 -0800 (PST)
Date:   Thu, 25 Nov 2021 15:07:37 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     devel@driverdev.osuosl.org, arve@android.com,
        stable@vger.kernel.org, riandrews@android.com, labbott@redhat.com,
        sumit.semwal@linaro.org
Subject: Re: [PATCH 1/1] staging: ion: Prevent incorrect reference counting
 behavour
Message-ID: <YZ+muS7vC5iNs/kq@google.com>
References: <20211125142004.686650-1-lee.jones@linaro.org>
 <20211125145004.GN6514@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211125145004.GN6514@kadam>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 25 Nov 2021, Dan Carpenter wrote:

> On Thu, Nov 25, 2021 at 02:20:04PM +0000, Lee Jones wrote:
> > Supply additional checks in order to prevent unexpected results.
> > 
> > Fixes: b892bf75b2034 ("ion: Switch ion to use dma-buf")
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> > Should be back-ported from v4.9 and earlier.
> > 
> >  drivers/staging/android/ion/ion.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
> > index 806e9b30b9dc8..402b74f5d7e69 100644
> > --- a/drivers/staging/android/ion/ion.c
> > +++ b/drivers/staging/android/ion/ion.c
> > @@ -29,6 +29,7 @@
> >  #include <linux/export.h>
> >  #include <linux/mm.h>
> >  #include <linux/mm_types.h>
> > +#include <linux/overflow.h>
> >  #include <linux/rbtree.h>
> >  #include <linux/slab.h>
> >  #include <linux/seq_file.h>
> > @@ -509,6 +510,10 @@ static void *ion_handle_kmap_get(struct ion_handle *handle)
> >  	void *vaddr;
> >  
> >  	if (handle->kmap_cnt) {
> > +		if (check_add_overflow(handle->kmap_cnt,
> > +				       (unsigned int) 1, &handle->kmap_cnt))
>                                                          ^^^^^^^^^^^^^^^^^
> 
> > +			return ERR_PTR(-EOVERFLOW);
> > +
> >  		handle->kmap_cnt++;
>                 ^^^^^^^^^^^^^^^^^^^
> This will not do what you want at all.  It's a double increment on the
> success path and it leave handle->kmap_cnt overflowed on failure path.

I read the helper to take copies of the original variables.

#define __unsigned_add_overflow(a, b, d) ({     \
        typeof(a) __a = (a);                    \
        typeof(b) __b = (b);                    \
        typeof(d) __d = (d);                    \
        (void) (&__a == &__b);                  \
        (void) (&__a == __d);                   \
        *__d = __a + __b;                       \
        *__d < __a;                             \
})

Maybe I misread it.

So the original patch [0] was better?

[0] https://lore.kernel.org/stable/20211125120234.67987-1-lee.jones@linaro.org/

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
