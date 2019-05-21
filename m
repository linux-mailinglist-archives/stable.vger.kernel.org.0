Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8BF24779
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 07:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbfEUFPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 01:15:43 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:48145 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727228AbfEUFPn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 May 2019 01:15:43 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id A152C22572;
        Tue, 21 May 2019 01:15:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 21 May 2019 01:15:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=Zs2g6tIaEDwqeFSvJ6bXGDZori8
        SQskXCTnrMkz9V0o=; b=XkYC0Fn21fxBL0Y/5xlGTXf/QGhEqpLwC85P4Fk2PGK
        0KLkieW0hAY6tbhd4yXVr3IpKhelBCISBrHUPUICnqqv46bjFfGBkGHvjfn0CISx
        0s3FMtnBo1PhklLGB/4det3M2ATP7QqcGHSVfESwZXhlO5TEFe5cfxfW8AmrPfa8
        gZxIl8bj90v2HAUH+IFzoowMmXJn2QmYLA35Wyt8/aFbLbnrpamSgsyYqrle2omr
        SxO+xainrHKtUXqGRjtTLQ7Xe2yetygYEABsE2MAONgIpy/YpSEWOy498KMrVbcL
        KPi3EXLbl8EfLvy6uWb4+aXjOt39OPjeP3K4DZc11sg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Zs2g6t
        IaEDwqeFSvJ6bXGDZori8SQskXCTnrMkz9V0o=; b=xPO8jHCtWXj3rDrQEU7Kn+
        0pOJnLE5jm7t2pMh3r2MsG+k1IxzDaEY4FSM2A1e3dCOX3o+OXIXCUrsro60OFr3
        Tv4sJ393/LOMKlZGzX6ITxr1VV10yXSpoumg2+BsWjH17g+Lu19TuB3Mz5eMcyAy
        HVU7bGr3XvlF54OFITAIulQgN3AqwKrXU1eEVgvhzOCleHMHSnwf6xmn38M7UPeR
        2bRcKtswySRSYj98KuDsBxs4mAXNodjoM+BUEhxtJy4PWFtu4nZBZ15Fn1n0IH58
        S/8mfPYDh6SArfsZhAAiNGonIUl4y0mvvX51zHW/D0q2SuJKCsrMdvLKgnmrst0A
        ==
X-ME-Sender: <xms:fInjXOO0wwQHk0J41lr-xuKWbnTSuzCtcO1Qowc70EMzshaL7Z7Eqw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtledgleefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:fInjXEbu7SiHIpzIVFdLVV2ucgC0nog-8XQblkluBQ5pk6eKeCkhAA>
    <xmx:fInjXCpgZ8JXC9_J1e9wIhVzBqnFsav38Yo8PCYoDlP-vUPM-yPC3w>
    <xmx:fInjXIYx7KH-uRJwMxK9NKW4-urnXhKcjVi1bH2aoWdhc-5BCGTFDw>
    <xmx:fYnjXKROHSiJEbHDppq7-CQZOUklbNVZdxFCBR_d1R3oH7MTJgtw6Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4EED310323;
        Tue, 21 May 2019 01:15:40 -0400 (EDT)
Date:   Tue, 21 May 2019 07:15:37 +0200
From:   Greg KH <greg@kroah.com>
To:     Janusz Krzysztofik <jmkrzyszt@gmail.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/9] media: ov6650: Fix MODDULE_DESCRIPTION
Message-ID: <20190521051537.GA8325@kroah.com>
References: <20190520225007.2308-1-jmkrzyszt@gmail.com>
 <20190520225007.2308-2-jmkrzyszt@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520225007.2308-2-jmkrzyszt@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 21, 2019 at 12:49:59AM +0200, Janusz Krzysztofik wrote:
> Commit 23a52386fabe ("media: ov6650: convert to standalone v4l2
> subdevice") converted the driver from a soc_camera sensor to a
> standalone V4L subdevice driver.  Unfortunately, module description was
> not updated to reflect the change.  Fix it.
> 
> While being at it, update email address of the module author.
> 
> Fixes: 23a52386fabe ("media: ov6650: convert to standalone v4l2 subdevice")
> Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
> cc: stable@vger.kernel.org
> ---
>  drivers/media/i2c/ov6650.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/i2c/ov6650.c b/drivers/media/i2c/ov6650.c
> index 1b972e591b48..a3d00afcb0c8 100644
> --- a/drivers/media/i2c/ov6650.c
> +++ b/drivers/media/i2c/ov6650.c
> @@ -1045,6 +1045,6 @@ static struct i2c_driver ov6650_i2c_driver = {
>  
>  module_i2c_driver(ov6650_i2c_driver);
>  
> -MODULE_DESCRIPTION("SoC Camera driver for OmniVision OV6650");
> -MODULE_AUTHOR("Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>");
> +MODULE_DESCRIPTION("V4L2 subdevice driver for OmniVision OV6650 camera sensor");
> +MODULE_AUTHOR("Janusz Krzysztofik <jmkrzyszt@gmail.com");
>  MODULE_LICENSE("GPL v2");
> -- 
> 2.21.0
> 

is this _really_ a patch that meets the stable kernel requirements?
Same for this whole series...

thanks,

greg k-h
