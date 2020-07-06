Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBDC82152E9
	for <lists+stable@lfdr.de>; Mon,  6 Jul 2020 09:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbgGFHN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jul 2020 03:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728832AbgGFHN1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jul 2020 03:13:27 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92C0C08C5DF
        for <stable@vger.kernel.org>; Mon,  6 Jul 2020 00:13:26 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id o11so39638020wrv.9
        for <stable@vger.kernel.org>; Mon, 06 Jul 2020 00:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=RMGnvxquvbu4QyMyyHqPaCsBLX3LZtSdXGrqjMwfS7E=;
        b=AAikv23ZIqKM8pfJvjReSBC3OGv4L4hsLmToMzvt7T4/lJmoiQ+k4CdAGRb0cV7S2W
         5X8g98k0ELBNX7r3ltxzvzV7Us/w7LOjcAmp/SXbx8utOSJSEuFc7U0259FgO+PDubaM
         k24kALm57sxDO8COLitP2s3SUPG757vsPnwL9+lCTMT28+RB1XbGNbSOw46k+xJDdaBB
         VuFjAMTV3L6YEJCKAgb19Z1QDdVmigQUrNGym9PJiCpMP5CfkmNXCk2xvhJegjTQQ3vX
         WUTgp7t8gDULlaBYcJc9JBvRnTkdKprktwjq6xQVSs0pSfm931CCLVe8qirXmhGyS+aQ
         R6Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=RMGnvxquvbu4QyMyyHqPaCsBLX3LZtSdXGrqjMwfS7E=;
        b=AaAjVLqDihbpjS5388O6EhXQmh86BgpWD1zOU74Gte+YG+552YUQlYsCqRQ6TmMO/s
         uixglAp9BiROpLWurB6PUq5yasqjE3o1WnY/cBkzIcR61VjYQTNAL7oB7gEjQL2gf0yW
         /ojL0DB9216xNups4/GuPVn7mWXZc44lMTgk9yQiw3q4mXNd0e2NWTjAJJty1J0tVHsa
         ZnJd90Mq4IwBl1kP3bZIK2dRcIzZoGn5ADKi8REPY83VX9Yt99MD5AGCGDWEcNkft3ea
         mkFq9MXX3ibY6gyfex84x9PCYSC7JZInnXTnwqscUOyccO+bEi213SSSKgLfcljUUYNT
         hXxg==
X-Gm-Message-State: AOAM531RmzcYdGzUx0IOsZbpukypRJsNcUtsMN3jtclZutnb+UvB/VV2
        wajBq65wnBmOPpk6UaIIJ/qPow==
X-Google-Smtp-Source: ABdhPJzbRa4dAsAzugKpjzOIhWptwA1zAERFnuxhOgrcEveqI1bRWNiT7yGNRTf9jNNznRD5lbePTw==
X-Received: by 2002:adf:ed02:: with SMTP id a2mr46518594wro.110.1594019605697;
        Mon, 06 Jul 2020 00:13:25 -0700 (PDT)
Received: from dell ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id d13sm22969218wrq.89.2020.07.06.00.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 00:13:24 -0700 (PDT)
Date:   Mon, 6 Jul 2020 08:13:22 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Daniel Thompson <daniel.thompson@linaro.org>
Cc:     jingoohan1@gmail.com, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Software Engineering <sbabic@denx.de>
Subject: Re: [PATCH 5/8] backlight: ili922x: Add missing kerneldoc
 description for ili922x_reg_dump()'s arg
Message-ID: <20200706071322.GB2821869@dell>
References: <20200624145721.2590327-1-lee.jones@linaro.org>
 <20200624145721.2590327-6-lee.jones@linaro.org>
 <20200625094318.h6t22gkgi5d7wbv4@holly.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200625094318.h6t22gkgi5d7wbv4@holly.lan>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 25 Jun 2020, Daniel Thompson wrote:

> On Wed, Jun 24, 2020 at 03:57:18PM +0100, Lee Jones wrote:
> > Kerneldoc syntax is used, but not complete.  Descriptions required.
> > 
> > Prevents warnings like:
> > 
> >  drivers/video/backlight/ili922x.c:298: warning: Function parameter or member 'spi' not described in 'ili922x_reg_dump'
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
> > index cd41433b87aeb..26193f38234e7 100644
> > --- a/drivers/video/backlight/ili922x.c
> > +++ b/drivers/video/backlight/ili922x.c
> > @@ -295,6 +295,8 @@ static int ili922x_write(struct spi_device *spi, u8 reg, u16 value)
> >  #ifdef DEBUG
> >  /**
> >   * ili922x_reg_dump - dump all registers
> > + *
> > + * @spi: pointer to the controller side proxy for an SPI slave device
> 
> Similar to previous... and I also noticed that there are several other
> existing @spi descriptions in this file and it would be good to make
> them consistent.

I've fixed this and applied the patch.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
