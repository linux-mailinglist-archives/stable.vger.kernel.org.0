Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC5625713
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 19:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbfEURzf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 13:55:35 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:46948 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728055AbfEURzf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 May 2019 13:55:35 -0400
Received: by mail-lf1-f65.google.com with SMTP id l26so13741753lfh.13;
        Tue, 21 May 2019 10:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IfC90GLWAL5buzqpB3Hhmc94gWiD9YxrxMTKQ1rMyRM=;
        b=j0FisOER1y/L+6LkfBt8YXZO/d0LHxfgfibIXMagQRz8eZuFtPr0xsdxx2UDbih1BO
         t+M6Fpu2GA34I8qh+suppEju4J9ej11udj/cd4wftrK1/goHeAqOU/EQBZU75bBqx6yY
         0pisnKM4YolPLuFaAjssSdxnSsVc68/sveBiOMX1FOUvDdnCBqoIYbxGB6l9wp8dgPkb
         2KrXe+32kRCKSQvlRIrK2Y7KT2Trc97RFF628Lv9HMLvyqS91s/hZ54WeduaZyBqBtsZ
         xE3rlPeLNnTTRLi2YHNPDY6trmPtfDlBjcf1Do0NcWfe4gCpZbc8rd4v0YRs728qYpdC
         aA4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IfC90GLWAL5buzqpB3Hhmc94gWiD9YxrxMTKQ1rMyRM=;
        b=RHXjkAmgleZDVpD9w8kauGgZX2t3iXs6fHEqNvZCW4fd97pZlhmrRj2mQMpZ6msI9B
         GKEK9oRiNYMzYjz1BQOyO6iLJowOof8/xcnhfn/HQFB9dtVyH1BgJkoYBOt8JmV4EklL
         mIWb0nxQ86Q3E3taRrJjomYSG+kcQ4uvXoo+MAClXSbNCiuQAY+8jDmZdrOGdYnBW+yX
         fJ1uShNtXOa+RAMQBBHvP3L/mn5kMKLwKfNY5voThk1CtD5KjV+RHRqALwOT+GlbkVC/
         6lDjfih0PTaRfOyqUbn9zkaYG0+PXeQ0TMlyNpXic+p9ITRT3G2WnF0H6OL+UZhDMgK8
         8hVw==
X-Gm-Message-State: APjAAAVvZgtgS//Mz9Bo0+F5O0M/3g2qZ8UFGtI7G8OGjpbu/eur/ber
        G8WkMhMINqhk6++zZqVYKQc=
X-Google-Smtp-Source: APXvYqwO6dtTEgUYcoodZ/ORFTKcLy5c4fhJsQj3OtLXPCDDB+PojqiaceAFBupQdJWkjIAB8kaKXQ==
X-Received: by 2002:ac2:50c4:: with SMTP id h4mr22359011lfm.105.1558461333023;
        Tue, 21 May 2019 10:55:33 -0700 (PDT)
Received: from z50.localnet (109241207190.gdansk.vectranet.pl. [109.241.207.190])
        by smtp.gmail.com with ESMTPSA id s6sm4741081lje.89.2019.05.21.10.55.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 10:55:32 -0700 (PDT)
From:   Janusz Krzysztofik <jmkrzyszt@gmail.com>
To:     Greg KH <greg@kroah.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/9] media: ov6650: Fix MODDULE_DESCRIPTION
Date:   Tue, 21 May 2019 19:55:30 +0200
Message-ID: <1658715.gUuAbo05IQ@z50>
In-Reply-To: <20190521051537.GA8325@kroah.com>
References: <20190520225007.2308-1-jmkrzyszt@gmail.com> <20190520225007.2308-2-jmkrzyszt@gmail.com> <20190521051537.GA8325@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tuesday, May 21, 2019 7:15:37 AM CEST Greg KH wrote:
> On Tue, May 21, 2019 at 12:49:59AM +0200, Janusz Krzysztofik wrote:
> > Commit 23a52386fabe ("media: ov6650: convert to standalone v4l2
> > subdevice") converted the driver from a soc_camera sensor to a
> > standalone V4L subdevice driver.  Unfortunately, module description was
> > not updated to reflect the change.  Fix it.
> > 
> > While being at it, update email address of the module author.
> > 
> > Fixes: 23a52386fabe ("media: ov6650: convert to standalone v4l2 subdevice")
> > Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
> > cc: stable@vger.kernel.org
> > ---
> >  drivers/media/i2c/ov6650.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/ov6650.c b/drivers/media/i2c/ov6650.c
> > index 1b972e591b48..a3d00afcb0c8 100644
> > --- a/drivers/media/i2c/ov6650.c
> > +++ b/drivers/media/i2c/ov6650.c
> > @@ -1045,6 +1045,6 @@ static struct i2c_driver ov6650_i2c_driver = {
> >  
> >  module_i2c_driver(ov6650_i2c_driver);
> >  
> > -MODULE_DESCRIPTION("SoC Camera driver for OmniVision OV6650");
> > -MODULE_AUTHOR("Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>");
> > +MODULE_DESCRIPTION("V4L2 subdevice driver for OmniVision OV6650 camera sensor");
> > +MODULE_AUTHOR("Janusz Krzysztofik <jmkrzyszt@gmail.com");
> >  MODULE_LICENSE("GPL v2");
> 
> is this _really_ a patch that meets the stable kernel requirements?
> Same for this whole series...

Hi Greg,

My bad, I'm sorry.  Please ignore the whole series, and I'll be more careful
in the future.

Thanks,
Janusz

> 
> thanks,
> 
> greg k-h
> 




