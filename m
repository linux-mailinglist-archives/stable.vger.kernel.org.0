Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0CEC150948
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 16:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbgBCPL6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 10:11:58 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50523 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728800AbgBCPL5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Feb 2020 10:11:57 -0500
Received: by mail-wm1-f68.google.com with SMTP id a5so16305389wmb.0
        for <stable@vger.kernel.org>; Mon, 03 Feb 2020 07:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=10knLupHMqEpgP8COf2Z7ZaOZSp04mKff+ekSwBxxho=;
        b=m1TPVvGc4/0Di91loBU1fx40PngrXZV3RmtMXQwng7gbLrcFo5pER+2Devadv35vE5
         SNdw9CG6c9hGdyik3GPRkLlqgKjcZLx7S+XNsZKOVN9jWtzH48cFriI+z7mbfLzYfQNn
         2Lgb0v0Kh2OPa4AIifYG7ixaH1xp33A+vKguI/QnHMNpsWmz0McsrgV3Rp+xQdmw023H
         ohpaX8T9l5uUZIRwGQdc5lDxaJIZnr8dgoDdimqykuHIo0AYieViOkVjeSJZPB67trSx
         HwmjSIuSC2dBgDvZB3rR7wAqkRNunzUAzurqrWGWp2+zDeitVBeqdXoP5gA8BYi6OS/b
         Hefg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=10knLupHMqEpgP8COf2Z7ZaOZSp04mKff+ekSwBxxho=;
        b=D5NUVKz7jzEES2N/cK9aDAJiHCE1f6mBJWK7026yPZfvLfa9OhKm9pCis0u8BB6nib
         wfi5DHD+9owzCnsPoyaEInbK2dn7XvnDKwnJRAkbhC98X8tJessuQyo2f5+EdonJu5X5
         QOufeyTKLL9rRo5M7myXLiRK35eGZDQGj7PQEY5jFXEy2sLafD60ZcsQ30GzZQKEmePn
         X/pJ67WhS04EvX0GSR+tv+NvgMYt2/gJ5fBdoBv90GT6GYs5Rk52jmDGnGIooALxwpNE
         gdqNnAGBF4GfwpEzASqbkuLYIMjuWkOAQ4zWfqOTonbJn4LqA7hnWvKmidChT068jxLN
         CGuw==
X-Gm-Message-State: APjAAAXC7tZ1NlY+TQuff9rRlgheOd16unZ5H6TTTvEbsTXm7sJyGKkf
        UHqGdR9WleqH8O05LpmzWam0qA==
X-Google-Smtp-Source: APXvYqxY1XGUX6kA63UZ+k9EtOdPU9xCyzWL2gtWssT8Uoj5LsIGIEcm4B0qCnQvGZmzL8O3nZlqTg==
X-Received: by 2002:a7b:c1d6:: with SMTP id a22mr29207137wmj.134.1580742714891;
        Mon, 03 Feb 2020 07:11:54 -0800 (PST)
Received: from dell ([2.27.35.227])
        by smtp.gmail.com with ESMTPSA id z133sm24980737wmb.7.2020.02.03.07.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 07:11:54 -0800 (PST)
Date:   Mon, 3 Feb 2020 15:12:08 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] media: si470x-i2c: Move free() past last use of
 'radio'
Message-ID: <20200203151208.GD15069@dell>
References: <20200203132130.12748-1-lee.jones@linaro.org>
 <20200203143245.GA3220000@kroah.com>
 <20200203145831.GA3238182@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200203145831.GA3238182@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 03 Feb 2020, Greg KH wrote:

> On Mon, Feb 03, 2020 at 02:32:45PM +0000, Greg KH wrote:
> > On Mon, Feb 03, 2020 at 01:21:30PM +0000, Lee Jones wrote:
> > > A pointer to 'struct si470x_device' is currently used after free:
> > > 
> > >   drivers/media/radio/si470x/radio-si470x-i2c.c:462:25-30: ERROR: reference
> > >     preceded by free on line 460
> > > 
> > > Shift the call to free() down past its final use.
> > > 
> > > NB: Not sending to Mainline, since the problem does not exist there.
> > 
> > It doesn't exist there because of a bad merge?  What commit caused the
> > problem?
> 
> Ah, found it, it was 2df200ab234a ("media: si470x-i2c: add missed
> operations in remove")

I was about to follow up with a v2:

  "NB: Cauased during the backporting of upstream commit 2df200ab234a
   ("media: si470x-i2c: add missed operations in remove").  This issue does
   not exist in Mainline since the kfree() was removed in v5.0 as part of
   commit f86c51b66bf6 ("media: si470x-i2c: Use managed resource helpers")."

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
