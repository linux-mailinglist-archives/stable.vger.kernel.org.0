Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7894A1B4EF3
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 23:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbgDVVNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 17:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgDVVNg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 17:13:36 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC273C03C1A9;
        Wed, 22 Apr 2020 14:13:36 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id d24so1432559pll.8;
        Wed, 22 Apr 2020 14:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=fixRxJ6fU1zb5iKNn2T+pA04ZuYBb0t9f+U1RUIbv2A=;
        b=Rw93AsTXDGj9lS/6gFbgXJTJ5+HgxYGocMJ+9qUd/CRUbZEQaxGAu3Ramu/WOl+m2y
         ttmGhOvPwqWwX0OeKH8WsuIDNCwohdx/F2no/VwtuMfMhCKpucczQqClFUj30N+ycXSh
         HZONV2vnBY6CTuFdWlNkMqDQ9iCiqsBTotOkikjD8uSLMj2FD7hvq2qqbXkMCdwf264Z
         jH16IEaunNoNJwHjOqeZgwSERTzRKlw+RwwpXNrCgluHGbGvDgjuq0z/eNYvOZ8szT86
         +x5/XcVdiW8SHqjUynL0e+YV8tTXTcJotKlWUn4GjarNFNhoIIDMaAeXZWVj5lOCFc/1
         3qfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=fixRxJ6fU1zb5iKNn2T+pA04ZuYBb0t9f+U1RUIbv2A=;
        b=oC7OLBAnR+hNB2p1rIQSivXtKZyDYOp4+qBFleNt8h7bQh87At/cyNEDeWtYB8liw3
         sVmewUsyS6tKIXZmZkh5wvUh2CnjVUnGmeg8awJGS/6EAPloO9VC8FmCVMnZHDm793dy
         xQ0GzX3B+nINBEGdj8S0WvKD+N0f3d7BWDLdzel0hcuSy9WQ8E+REUjEqgcgE4wc4bJn
         PKT9oGHDzcLik3KYkYu8omu8QsGiQICY1th8TCSQZzIOuxJ2j8Ae8uP3Iw+C5/W2Pn9s
         NygsIw2fO7ADUhpE5TvaOIQj25fDhzebLRA/S1f0mxlRdFj0VLQiMwgVvCF4PzV09ngm
         AW2g==
X-Gm-Message-State: AGi0PuaUXjx8Ik0PMITYQr/UhxyETOfxcKiwb1uCsMmgAKI8enYQvZnR
        zKV2rLevh2ohF5NeZX6SBb8=
X-Google-Smtp-Source: APiQypLB3ZbzOoPxbh2y95mT4/1+kvo8XBOEUxWmzrWokQzJY9a+V24VOVmECS0b8eNl85q151rPZg==
X-Received: by 2002:a17:90a:2023:: with SMTP id n32mr741941pjc.150.1587590015909;
        Wed, 22 Apr 2020 14:13:35 -0700 (PDT)
Received: from dtor-ws ([2620:15c:202:201:3c2a:73a9:c2cf:7f45])
        by smtp.gmail.com with ESMTPSA id d12sm197155pfq.36.2020.04.22.14.13.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 14:13:35 -0700 (PDT)
Date:   Wed, 22 Apr 2020 14:13:33 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Cameron Gutman <aicommander@gmail.com>
Cc:     LuK1337 <priv.luk@gmail.com>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Richard Fontana <rfontana@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: xpad - Add custom init packet for Xbox One S
 controllers
Message-ID: <20200422211333.GG125362@dtor-ws>
References: <92b71dc5-ddd5-7ffd-65f8-65a6610dfe43@gmail.com>
 <20200422075206.18229-1-priv.luk@gmail.com>
 <8015c173-79e5-4627-c955-0b87e17f3034@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8015c173-79e5-4627-c955-0b87e17f3034@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 22, 2020 at 10:20:08AM -0700, Cameron Gutman wrote:
> On 4/22/20 12:52 AM, LuK1337 wrote:
> > From: Łukasz Patron <priv.luk@gmail.com>
> > 
> > Sending [ 0x05, 0x20, 0x00, 0x0f, 0x06 ] packet for
> > Xbox One S controllers fixes an issue where controller
> > is stuck in Bluetooth mode and not sending any inputs.
> > 
> > Signed-off-by: Łukasz Patron <priv.luk@gmail.com>
> > Cc: stable@vger.kernel.org
> 
> LGTM. Tested working on both of my Xbox One S gamepads:
> - idVendor=045e, idProduct=02ea, bcdDevice= 3.01
> - idVendor=045e, idProduct=02ea, bcdDevice= 4.08
> 
> Reviewed-by: Cameron Gutman <aicommander@gmail.com>

Applied, thank you.

> 
> > ---
> >  drivers/input/joystick/xpad.c | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> > 
> > diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
> > index 6b40a1c68f9f..c77cdb3b62b5 100644
> > --- a/drivers/input/joystick/xpad.c
> > +++ b/drivers/input/joystick/xpad.c
> > @@ -458,6 +458,16 @@ static const u8 xboxone_fw2015_init[] = {
> >  	0x05, 0x20, 0x00, 0x01, 0x00
> >  };
> >  
> > +/*
> > + * This packet is required for Xbox One S (0x045e:0x02ea)
> > + * and Xbox One Elite Series 2 (0x045e:0x0b00) pads to
> > + * initialize the controller that was previously used in
> > + * Bluetooth mode.
> > + */
> > +static const u8 xboxone_s_init[] = {
> > +	0x05, 0x20, 0x00, 0x0f, 0x06
> > +};
> > +
> >  /*
> >   * This packet is required for the Titanfall 2 Xbox One pads
> >   * (0x0e6f:0x0165) to finish initialization and for Hori pads
> > @@ -516,6 +526,8 @@ static const struct xboxone_init_packet xboxone_init_packets[] = {
> >  	XBOXONE_INIT_PKT(0x0e6f, 0x0165, xboxone_hori_init),
> >  	XBOXONE_INIT_PKT(0x0f0d, 0x0067, xboxone_hori_init),
> >  	XBOXONE_INIT_PKT(0x0000, 0x0000, xboxone_fw2015_init),
> > +	XBOXONE_INIT_PKT(0x045e, 0x02ea, xboxone_s_init),
> > +	XBOXONE_INIT_PKT(0x045e, 0x0b00, xboxone_s_init),
> >  	XBOXONE_INIT_PKT(0x0e6f, 0x0000, xboxone_pdp_init1),
> >  	XBOXONE_INIT_PKT(0x0e6f, 0x0000, xboxone_pdp_init2),
> >  	XBOXONE_INIT_PKT(0x24c6, 0x541a, xboxone_rumblebegin_init),
> > 
> 

-- 
Dmitry
