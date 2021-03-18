Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA5313400C8
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 09:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhCRIVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 04:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhCRIU6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Mar 2021 04:20:58 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F995C06174A
        for <stable@vger.kernel.org>; Thu, 18 Mar 2021 01:20:58 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id v4so4504789wrp.13
        for <stable@vger.kernel.org>; Thu, 18 Mar 2021 01:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ky9DcUizLpgsoR5ig6FI42nLxru2JecmiOfSf2AxVqM=;
        b=lEYVgFCa29qC0pE9Xc4nFd+oeU0FaW6hZfa5E2lFi0boIVz+ERyMEdWo9AIXpBrm3Y
         2mP1w9Xccq2t9Zm8v9BIfIrfbg3ssgjvmfUfUAV798wg48wJOXsRDVDYNDNfppehf+Ec
         gTNAQFYUnG9bY/Q3FIRUFYWB8ohGN3PfwEKsEwcwxEDOVFCCx04XXkEffSW5uNRNe5Fv
         c/dlISYc+H1XMm5ndslDb1UJUDddjx2+cCYp+HqD1MJm5Dd3qeaK2kAUw0Vw/3ITFNeg
         17n1qaMYjeY5Mm6zNIAgaUqTmnnypA/9oodWMtl5IOhK8eI+R6265edf50+8ilYztH9y
         ae8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ky9DcUizLpgsoR5ig6FI42nLxru2JecmiOfSf2AxVqM=;
        b=GgRLf7TF4b4lAn2hH/fHNEUHoiRKWW1U7gbNQIJmHBxyekuEt1EsGsJLh3iiClPG1P
         gF/zA3IvYrp6+jCS7SlCUOFC8wepp6iLvbPVPuSpsLOTQqU+XEIwGuAA9uGcj2KQpM5E
         +lPSBAu02IzRd5UFysAroQcaqo78iBGGbgEia4fAuA6xeFv0D/g/+S1+uPUiLw2/cB2S
         aZL4kk0yyf3jpMQz14JvVipNWwY1TDOmOw5oLNx7Z32tBkuTLY5G6PJ/+k/Skal5z5HK
         qVS1vFlM68JSg2JdqRFAZaJPtJcn8sxQfEVPDfrktu+5vX8OjEDGboe4O/2vql1epnod
         i7YA==
X-Gm-Message-State: AOAM533ZJZa2aiLmH/uiNw+QFWZGc2zR8txUQVd/pDLwZXZk77uOEyRz
        EBtddYI1MSWQAvScQmgU1G2QAhER+n2Q8g==
X-Google-Smtp-Source: ABdhPJxXwg+vm0HTRulbl6atRSy5R/oxu4zQ3D66v+o+BveILkGxftSAu0Ff0dR550y09dCZSxfE4A==
X-Received: by 2002:a5d:4e85:: with SMTP id e5mr8551948wru.218.1616055656787;
        Thu, 18 Mar 2021 01:20:56 -0700 (PDT)
Received: from dell ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id v7sm1391063wme.47.2021.03.18.01.20.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 01:20:56 -0700 (PDT)
Date:   Thu, 18 Mar 2021 08:20:54 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <greg@kroah.com>
Cc:     Gwendal Grignou <gwendal@chromium.org>, stable@vger.kernel.org,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] platform/chrome: cros_ec_dev - Fix security issue
Message-ID: <20210318082054.GD2916463@dell>
References: <20210317235522.2497292-1-gwendal@chromium.org>
 <20210318075443.GB2916463@dell>
 <YFMKsRWTIDeeuEEk@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YFMKsRWTIDeeuEEk@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 18 Mar 2021, Greg KH wrote:

> On Thu, Mar 18, 2021 at 07:54:43AM +0000, Lee Jones wrote:
> > On Wed, 17 Mar 2021, Gwendal Grignou wrote:
> > 
> > > commit 5d749d0bbe811c10d9048cde6dfebc761713abfd upstream.
> > > 
> > > Prevent memory scribble by checking that ioctl buffer size parameters
> > > are sane.
> > > Without this check, on 32 bits system, if .insize = 0xffffffff - 20 and
> > > .outsize the amount to scribble, we would overflow, allocate a small
> > > amounts and be able to write outside of the malloc'ed area.
> > > Adding a hard limit allows argument checking of the ioctl. With the
> > > current EC, it is expected .insize and .outsize to be at around 512 bytes
> > > or less.
> > > 
> > > Signed-off-by: Olof Johansson <olof@lixom.net>
> > > Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
> > > ---
> > >  drivers/platform/chrome/cros_ec_dev.c   | 4 ++++
> > >  drivers/platform/chrome/cros_ec_proto.c | 4 ++--
> > >  include/linux/mfd/cros_ec.h             | 6 ++++--
> > >  3 files changed, 10 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/platform/chrome/cros_ec_dev.c b/drivers/platform/chrome/cros_ec_dev.c
> > > index 2b331d5b9e799..e16d82bb36a9d 100644
> > > --- a/drivers/platform/chrome/cros_ec_dev.c
> > > +++ b/drivers/platform/chrome/cros_ec_dev.c
> > > @@ -137,6 +137,10 @@ static long ec_device_ioctl_xcmd(struct cros_ec_dev *ec, void __user *arg)
> > >  	if (copy_from_user(&u_cmd, arg, sizeof(u_cmd)))
> > >  		return -EFAULT;
> > >  
> > > +	if ((u_cmd.outsize > EC_MAX_MSG_BYTES) ||
> > > +	    (u_cmd.insize > EC_MAX_MSG_BYTES))
> > > +		return -EINVAL;
> > > +
> > >  	s_cmd = kmalloc(sizeof(*s_cmd) + max(u_cmd.outsize, u_cmd.insize),
> > >  			GFP_KERNEL);
> > >  	if (!s_cmd)
> > > diff --git a/drivers/platform/chrome/cros_ec_proto.c b/drivers/platform/chrome/cros_ec_proto.c
> > > index 5c285f2b3a650..d20190c8f0c06 100644
> > > --- a/drivers/platform/chrome/cros_ec_proto.c
> > > +++ b/drivers/platform/chrome/cros_ec_proto.c
> > > @@ -311,8 +311,8 @@ int cros_ec_query_all(struct cros_ec_device *ec_dev)
> > >  			ec_dev->max_response = EC_PROTO2_MAX_PARAM_SIZE;
> > >  			ec_dev->max_passthru = 0;
> > >  			ec_dev->pkt_xfer = NULL;
> > > -			ec_dev->din_size = EC_MSG_BYTES;
> > > -			ec_dev->dout_size = EC_MSG_BYTES;
> > > +			ec_dev->din_size = EC_PROTO2_MSG_BYTES;
> > > +			ec_dev->dout_size = EC_PROTO2_MSG_BYTES;
> > >  		} else {
> > >  			/*
> > >  			 * It's possible for a test to occur too early when
> > > diff --git a/include/linux/mfd/cros_ec.h b/include/linux/mfd/cros_ec.h
> > > index 3ab3cede28eac..93c14e9df6309 100644
> > > --- a/include/linux/mfd/cros_ec.h
> > > +++ b/include/linux/mfd/cros_ec.h
> > > @@ -50,9 +50,11 @@ enum {
> > >  					EC_MSG_TX_TRAILER_BYTES,
> > >  	EC_MSG_RX_PROTO_BYTES	= 3,
> > >  
> > > -	/* Max length of messages */
> > > -	EC_MSG_BYTES		= EC_PROTO2_MAX_PARAM_SIZE +
> > > +	/* Max length of messages for proto 2*/
> > > +	EC_PROTO2_MSG_BYTES		= EC_PROTO2_MAX_PARAM_SIZE +
> > >  					EC_MSG_TX_PROTO_BYTES,
> > 
> > Nit: Better to not tab the '=' so far and place it all on one line.
> > 
> > Checkpatch now only complains about lines exceeding 100 chars.
> > 
> > Once fixed, feel free to apply my:
> > 
> >   Acked-by: Lee Jones <lee.jones@linaro.org>
> 
> This commit is already in 4.7, and is from 2016, so I don't know why you
> are reviewing it :)

Heh!  It looked like a standard patch at first glance.

Must have skipped over the "commit" line in the commit log.

I wonder why it doesn't have my Ack on it already then?

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
