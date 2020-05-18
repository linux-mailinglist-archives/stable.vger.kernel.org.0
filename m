Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D13041D74FB
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 12:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgERKRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 06:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726274AbgERKRW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 06:17:22 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FD0C061A0C
        for <stable@vger.kernel.org>; Mon, 18 May 2020 03:17:21 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id j5so11188350wrq.2
        for <stable@vger.kernel.org>; Mon, 18 May 2020 03:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ezIC3rgxZpZmcEA9eSxG3VLT7UU285aW6tWQms4EHtg=;
        b=C8C5zD1I1W5jSS8WqSdPxpBDFB2O8lAIIRi5XhZjHhyOh7zvPARM/9eqc2ZzOGCKi5
         +Uq5zrHd4ex2leqf0LiNLSVAAEgEW2cljoQ4fqH+WSHjyEPaloX5aw/2zRQzFUPh9Y0U
         wQ8ZfUsU/R0W+D1J17VLXFoAIyZz4J8mxv3aQqQpJttVF6XwuFaahAz5zwOEA0ehj0OX
         /1o691ebxspExPzWtNDvB2FJMN9UHvUQXuH8TzueDKv7sWxAp4eiSeQxeOxj3jfqVWiz
         noSZaIti+rh7pEmqEzqZYq391u1ZhqtkfjnU1Hu6nx7nfn0+13KSJn+GJBJ50p8GijtW
         da+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ezIC3rgxZpZmcEA9eSxG3VLT7UU285aW6tWQms4EHtg=;
        b=qjq/nzobkIlGpsjXiQv5RfEZ47xNECxTFGAdOPQFE8C6xbz2IAv6CsguCUKcr7F7jM
         R//fc1oSYLORg98zzDfubhvBZOEk8NBIHK8Vj0ePCv5EvGGYsSu6sG+tWRTcu274hPLB
         Bah1BWVIglabkrzFW76lMfjU0JAec/2pHwc8Yy/l/Va8TW1C2DjCkJs1QBRsjWs3XtNU
         asvq1VVxTIJfhFJ9I+2xFHr0ZUytjEe1kOORa5jjkpyY4i9vQX+S//8686h4kLHg2pcd
         u17V/CkEjsxq1ZFNVflpY324PIsLVG06Iaf3l0M8OtxF3Hpb03HYe6rKlatOfzOspADl
         cHLQ==
X-Gm-Message-State: AOAM532ptJS9bW4NfOcA6YKlMog5TwT+YmgBc79ZV0RCRWIWv6b2FNk0
        FKb42f1BtkqZcNLe7yyYvSB1HA==
X-Google-Smtp-Source: ABdhPJwe/BU6KIzlVadxpPxIh01ch3Nl8hZwsgBsRLR873BTjX2svnI4X03o95tceSQUTy/dCy07Mg==
X-Received: by 2002:adf:8023:: with SMTP id 32mr20030708wrk.247.1589797040079;
        Mon, 18 May 2020 03:17:20 -0700 (PDT)
Received: from dell ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id l5sm16363917wrr.72.2020.05.18.03.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 03:17:19 -0700 (PDT)
Date:   Mon, 18 May 2020 11:17:14 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org,
        Markus Elfring <elfring@users.sourceforge.net>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4.4 04/16] crypto: talitos - Delete an error message for
 a failed memory allocation in talitos_edesc_alloc()
Message-ID: <20200518101714.GQ271301@dell>
References: <20200423204014.784944-1-lee.jones@linaro.org>
 <20200423204014.784944-5-lee.jones@linaro.org>
 <20200513093603.GC830571@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200513093603.GC830571@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 13 May 2020, Greg KH wrote:

> On Thu, Apr 23, 2020 at 09:40:02PM +0100, Lee Jones wrote:
> > From: Markus Elfring <elfring@users.sourceforge.net>
> > 
> > [ Upstream commit 0108aab1161532c9b62a0d05b8115f4d0b529831 ]
> > 
> > Omit an extra message for a memory allocation failure in this function.
> > 
> > This issue was detected by using the Coccinelle software.
> > 
> > Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> > Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>
> > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/crypto/talitos.c | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> > index 1c8857e7db894..f3d0a33f4ddb4 100644
> > --- a/drivers/crypto/talitos.c
> > +++ b/drivers/crypto/talitos.c
> > @@ -1287,7 +1287,6 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
> >  		if (iv_dma)
> >  			dma_unmap_single(dev, iv_dma, ivsize, DMA_TO_DEVICE);
> >  
> > -		dev_err(dev, "could not allocate edescriptor\n");
> 
> Not really stable material, also missing from 4.9 and 4.14 trees.

This doesn't apply to 4.9 or 4.14.

Looks like it was already removed in:

 4.9: 	   47fbc54bbe52709fbdc50f5578acf964962942b2
 4.14:	   c3f5e4efce3e2ece7f31826a14849e60d342bde1

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
