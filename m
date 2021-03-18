Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF1273400A8
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 09:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbhCRIJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 04:09:36 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52855 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229554AbhCRIJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Mar 2021 04:09:24 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 2FE145C0037;
        Thu, 18 Mar 2021 04:09:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 18 Mar 2021 04:09:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=F54/IICP5VR2gPCuNnv9Rt0OLXD
        +Ma8MI026O3abfeU=; b=YJIlahm1FNW0cVe3ZnjQP9GjJIg/EJUnwmUSCfFavBG
        TyDsTm6JdmXtz7DANOsAipKx7ituIxWdG2f/U25KP0AOcNVjY3l111OvyqUBc8OG
        dtNvKUCEE4+CMYJMwuN2y6BncVczMj5bSbXrT1uoL5QCFRoGUCTdSibNIinc+d8Z
        VwA/Y6X6e+IbmRE/r6xVSKiYOKeomiyWMlrXHlvOrQj0cpHQnwmKlNY78OpTwQLe
        1W/Rn3xUXNI9E0ZiD1t/opoopv3LIelwDnZnaWg0TP1YOIueMF9drEND+u3cHWSW
        xNDZSzYXCfoSmqvBgaSmw7gwh2gSre5jyZYCyeJrp7w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=F54/II
        CP5VR2gPCuNnv9Rt0OLXD+Ma8MI026O3abfeU=; b=mrrMTor6aie3VuQhnYiNHr
        cnD0IaxTSCfk8v9psAzYkUjCOBPzuWLkTfbCjWDllXcILh58AtCC/KqA2ePaqrMe
        27hxfmt/WjWObws2p5LOTf/8XsyGJZtkdLJx82wQKmaFkrcoMfemTmVocbjnAQay
        gOXF/M5hyMUraGPCNlvjcPVRUigmdDCXKMAZo8ErewQcg/NtZYzAlwwGbZ0EexTM
        SFBGqJAV/G28ZozL/KdXiB6iENFH3CgvOAU8RsLFacUSSubWatvdF+UhSrTUQv6O
        IDEZkfM6yjynhTs1O/MPPf4C7+siNLC/bnwZaBwYF5Vsvm4DkhLxHvVE8FNeumDg
        ==
X-ME-Sender: <xms:swpTYCWVVP_iX6IUmVzFUq1rqBeHVoCY3Iz8Sbo4vOCVZWRjXp1eVg>
    <xme:swpTYOnaFJGR4jjpMWhcYRhDqP2Qcsz9VCFoG1Z2JwKT3TFMEffow1hCwamDJrVoV
    m6DZJSc3WrwjA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefhedgudduhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtrodttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveehgf
    ejiedtffefhfdvgeelieegjeegieffkeeiffejfeelhfeigeethfdujeeunecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:swpTYGbjulZWXuKMNaMnfgFAaHyYb8MuoULzIHKmDCiCSe8G-bqGIQ>
    <xmx:swpTYJXiyzAqwqvxSVAQuVzJ7-2agEathVWxeGJjDWtLnGfgs_0ecA>
    <xmx:swpTYMkbAUhdB1GPxBSo_CQSGxGGgIe1A1BkIzELh6TUoMGa4iz07Q>
    <xmx:tApTYIvL4lF-4e_vVXgVoW376MOeI_yZN0-6MFvXsM6EOYAZL-Up3Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 932951080057;
        Thu, 18 Mar 2021 04:09:23 -0400 (EDT)
Date:   Thu, 18 Mar 2021 09:09:21 +0100
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Gwendal Grignou <gwendal@chromium.org>, stable@vger.kernel.org,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] platform/chrome: cros_ec_dev - Fix security issue
Message-ID: <YFMKsRWTIDeeuEEk@kroah.com>
References: <20210317235522.2497292-1-gwendal@chromium.org>
 <20210318075443.GB2916463@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318075443.GB2916463@dell>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 18, 2021 at 07:54:43AM +0000, Lee Jones wrote:
> On Wed, 17 Mar 2021, Gwendal Grignou wrote:
> 
> > commit 5d749d0bbe811c10d9048cde6dfebc761713abfd upstream.
> > 
> > Prevent memory scribble by checking that ioctl buffer size parameters
> > are sane.
> > Without this check, on 32 bits system, if .insize = 0xffffffff - 20 and
> > .outsize the amount to scribble, we would overflow, allocate a small
> > amounts and be able to write outside of the malloc'ed area.
> > Adding a hard limit allows argument checking of the ioctl. With the
> > current EC, it is expected .insize and .outsize to be at around 512 bytes
> > or less.
> > 
> > Signed-off-by: Olof Johansson <olof@lixom.net>
> > Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
> > ---
> >  drivers/platform/chrome/cros_ec_dev.c   | 4 ++++
> >  drivers/platform/chrome/cros_ec_proto.c | 4 ++--
> >  include/linux/mfd/cros_ec.h             | 6 ++++--
> >  3 files changed, 10 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/platform/chrome/cros_ec_dev.c b/drivers/platform/chrome/cros_ec_dev.c
> > index 2b331d5b9e799..e16d82bb36a9d 100644
> > --- a/drivers/platform/chrome/cros_ec_dev.c
> > +++ b/drivers/platform/chrome/cros_ec_dev.c
> > @@ -137,6 +137,10 @@ static long ec_device_ioctl_xcmd(struct cros_ec_dev *ec, void __user *arg)
> >  	if (copy_from_user(&u_cmd, arg, sizeof(u_cmd)))
> >  		return -EFAULT;
> >  
> > +	if ((u_cmd.outsize > EC_MAX_MSG_BYTES) ||
> > +	    (u_cmd.insize > EC_MAX_MSG_BYTES))
> > +		return -EINVAL;
> > +
> >  	s_cmd = kmalloc(sizeof(*s_cmd) + max(u_cmd.outsize, u_cmd.insize),
> >  			GFP_KERNEL);
> >  	if (!s_cmd)
> > diff --git a/drivers/platform/chrome/cros_ec_proto.c b/drivers/platform/chrome/cros_ec_proto.c
> > index 5c285f2b3a650..d20190c8f0c06 100644
> > --- a/drivers/platform/chrome/cros_ec_proto.c
> > +++ b/drivers/platform/chrome/cros_ec_proto.c
> > @@ -311,8 +311,8 @@ int cros_ec_query_all(struct cros_ec_device *ec_dev)
> >  			ec_dev->max_response = EC_PROTO2_MAX_PARAM_SIZE;
> >  			ec_dev->max_passthru = 0;
> >  			ec_dev->pkt_xfer = NULL;
> > -			ec_dev->din_size = EC_MSG_BYTES;
> > -			ec_dev->dout_size = EC_MSG_BYTES;
> > +			ec_dev->din_size = EC_PROTO2_MSG_BYTES;
> > +			ec_dev->dout_size = EC_PROTO2_MSG_BYTES;
> >  		} else {
> >  			/*
> >  			 * It's possible for a test to occur too early when
> > diff --git a/include/linux/mfd/cros_ec.h b/include/linux/mfd/cros_ec.h
> > index 3ab3cede28eac..93c14e9df6309 100644
> > --- a/include/linux/mfd/cros_ec.h
> > +++ b/include/linux/mfd/cros_ec.h
> > @@ -50,9 +50,11 @@ enum {
> >  					EC_MSG_TX_TRAILER_BYTES,
> >  	EC_MSG_RX_PROTO_BYTES	= 3,
> >  
> > -	/* Max length of messages */
> > -	EC_MSG_BYTES		= EC_PROTO2_MAX_PARAM_SIZE +
> > +	/* Max length of messages for proto 2*/
> > +	EC_PROTO2_MSG_BYTES		= EC_PROTO2_MAX_PARAM_SIZE +
> >  					EC_MSG_TX_PROTO_BYTES,
> 
> Nit: Better to not tab the '=' so far and place it all on one line.
> 
> Checkpatch now only complains about lines exceeding 100 chars.
> 
> Once fixed, feel free to apply my:
> 
>   Acked-by: Lee Jones <lee.jones@linaro.org>

This commit is already in 4.7, and is from 2016, so I don't know why you
are reviewing it :)

thanks,

greg k-h
