Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B405110ACEE
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 10:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfK0Jwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 04:52:51 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39413 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfK0Jwv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 04:52:51 -0500
Received: by mail-wr1-f67.google.com with SMTP id y11so22770026wrt.6
        for <stable@vger.kernel.org>; Wed, 27 Nov 2019 01:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=IXigVW9m7N6y5OzCDOZwKicJWd+Y0PXbtispgzIwDv4=;
        b=llzQzaT2ycE04Hst8/Cy57J4p64D5+8mLqOIgg9LNFLlGf/9re8W2W9oeu3W3nknZM
         jdzOWggjb7aL5Y0k/1yF2kE7VHHMKScU0RIpnq/6OMHstlOMucu0BAf6sX1FBoQ8wwPw
         /1SjP08Ccyh9RSV8bZlqrJWBuqK+gH3OnCSSfGjPwh8MbJR9KvaEZtCzoqYd6BSKrvXq
         6q+LU5qHr2sF/5nF8/UrmcNzRqgJV60M0L1vpjo+UvIQTqPRatJVFBPbMRsOS4KMBqoI
         fgO0tG/mKRmWbF2i51giPNrW/fWq8x8HhhkUhLbR1jbdPqwIYYHYo27Ws8h0sqnDVNuv
         L0LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=IXigVW9m7N6y5OzCDOZwKicJWd+Y0PXbtispgzIwDv4=;
        b=a3RZ4bWXxVJ8e660qKcHbiSWgKluxOAn8c7rcSJeVAw+/qSnj/tKuhHCoUWNGOFjjp
         PF8FwzPd/hJZnywrDzO8hTbuWis6NGSxfSHqSi9ASAcdeawUQIr2v/keFDClIO5hcDEX
         sRZ9+ZZNsOnVaYefsjs/pn0hKZ/CZfQc7BQJYe5Dmb21/6hOpJCE6fDkPP8rykTM1LES
         gLQA7GuXdVdBH6qNVI6dZAP8lRkBLLrMa0/ypjPtdd1GE3SmJXovVop4mijVkJGbNHTM
         K15bV0EgKUg7xVeoMKRtxM5z2FIuY+CMX9z8TiTDIBKbDKQjcKuGvRz+560kOnPlH7g0
         Be/Q==
X-Gm-Message-State: APjAAAVuTfl5RCD6d7i+RxP5ZIEZnpoJqKZnfYY65Ojd3HsvRswV0Hap
        h+vRET+pBvsGYIdH4QuMfJSs5CFoV5E=
X-Google-Smtp-Source: APXvYqwlRnyNjF42vaEftK4//OJ7obxIhrOumdxLLDylE3LEf8RACwCG6RfA3/aVYW9XM3PLbFlYWA==
X-Received: by 2002:a5d:4a8c:: with SMTP id o12mr25212799wrq.43.1574848367362;
        Wed, 27 Nov 2019 01:52:47 -0800 (PST)
Received: from dell ([185.80.132.160])
        by smtp.gmail.com with ESMTPSA id d20sm19882488wra.4.2019.11.27.01.52.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 01:52:46 -0800 (PST)
Date:   Wed, 27 Nov 2019 09:52:34 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.19 2/3] media: siano: Use kmemdup instead of
 duplicating its function
Message-ID: <20191127095234.GL3296@dell>
References: <20191127072210.30715-1-lee.jones@linaro.org>
 <20191127072210.30715-2-lee.jones@linaro.org>
 <20191127075802.GA1822469@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191127075802.GA1822469@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 27 Nov 2019, Greg KH wrote:

> On Wed, Nov 27, 2019 at 07:22:09AM +0000, Lee Jones wrote:
> > From: Wen Yang <wen.yang99@zte.com.cn>
> > 
> > [ Upstream commit 0f4bb10857e22a657e6c8cca5d1d54b641e94628 ]
> > 
> > kmemdup has implemented the function that kmalloc() + memcpy().
> > We prefer to kmemdup rather than code opened implementation.
> > 
> > This issue was detected with the help of coccinelle.
> > 
> > Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
> > CC: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
> > CC: linux-kernel@vger.kernel.org
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/media/usb/siano/smsusb.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
> > index 3071d9bc77f4..38ea773eac97 100644
> > --- a/drivers/media/usb/siano/smsusb.c
> > +++ b/drivers/media/usb/siano/smsusb.c
> > @@ -225,10 +225,9 @@ static int smsusb_sendrequest(void *context, void *buffer, size_t size)
> >  		return -ENOENT;
> >  	}
> >  
> > -	phdr = kmalloc(size, GFP_KERNEL);
> > +	phdr = kmemdup(buffer, size, GFP_KERNEL);
> >  	if (!phdr)
> >  		return -ENOMEM;
> > -	memcpy(phdr, buffer, size);
> >  
> >  	pr_debug("sending %s(%d) size: %d\n",
> >  		  smscore_translate_msg(phdr->msg_type), phdr->msg_type,
> 
> Why does this patch qualify for stable inclusion?

I'm guessing this question is rhetorical. :)

Please drop the patch.

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
