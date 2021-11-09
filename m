Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB1C044B108
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 17:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234903AbhKIQV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 11:21:59 -0500
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:40917 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234118AbhKIQV7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 11:21:59 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.west.internal (Postfix) with ESMTP id 9E64C2B011F4;
        Tue,  9 Nov 2021 11:19:11 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 09 Nov 2021 11:19:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=w6h/00s3fE/I2eJ4cKpEmxU04lj
        siJquGF6dd7lneQM=; b=FBMjAAKXuPFhilEYET/+Al0Gg7ZcnoAxLtAryS2Itsm
        PFnBEJpTtecEfHPvXBaqzHPDbKDlrdvxqgt/wbfwWizWwVYM9XB9jOOgg5PBOHpo
        zOfK2W9oHMOTuZuzEiKJhfP3EbajoX92yS0i5279Q6CUxZiynZH7AxdrTetCP9aL
        2ytYCPcZNOuZHf8LxSDvZNdZ/ksEteLg9u5tKlu6ZeuslFiBxO8ICM/U7L6Uu7CM
        /lLpnSVQZdkogpxaDw9u80puLasJx+r/ES3DCSG2HPnyyg1BmsX6QIXhk+CuWPDd
        HqOtHjx6Zz7Zie/RaE9QgJWeHgYokXLDqNXFw/iyluw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=w6h/00
        s3fE/I2eJ4cKpEmxU04ljsiJquGF6dd7lneQM=; b=mpkPx3SFw0zVDkEJlXZwKO
        gDL5KhA4qdM7T7Xbt2/ZMPjYLuStFjY6PEMYt4EEeRhLfnkhM/+qHLBecJPzHsHt
        Wxwf27O+8B03nIL9WUQePMqMUdq8G+gwH0Y1zTJ2TTdnpVIiq7Bl54U1jn81USNV
        FgsgeYL5iSpY4est1xYc7T5rF/YMXKzFTB1416UCkHKMYqRzjnic6Zirtcu4Smti
        olVEIl7114DcQiIQR+B0+y9rAe3iysXdZlwx4vFyKjlIFedsSGsKbiH7PfqsV3BF
        h4ptFI+SqfGd3rVhE8RxmoyMPNkzMd3qTrWR950w/y+rPOfKsRn/EljmIprP8RYA
        ==
X-ME-Sender: <xms:f5-KYQ7q9w4rzcFUCVeY7Glkm31rD7n4VPDJhwdbR-e248twPQCsEQ>
    <xme:f5-KYR5YtUzhbDwIRVbvTCn64ZG2EW59wFxcH287LuHhPasxbpnnZ857GVXJL6m5O
    OTt2ESOuCIfXw>
X-ME-Received: <xmr:f5-KYffQac2dxKLQO2SjhycGFZ-V6Ojar3wmmnhLvYcd0zDMQaV9cVvShKYBw-IATmK8Ye01V8bi-lLFhELVlZqRoAmckJZ0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrudeggdekiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhephfegleetue
    eitdegiedutefhvdehtedtheejkeegkeejkeetkeefteevieffvdffnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghdpshhpihhnihgtshdrnhgvthenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:f5-KYVJPY6JZ4_-RSH1Fys662MdeywozgUODZzoUEi9W-yeN9YVPuw>
    <xmx:f5-KYUI2aNWXkEoFI2srKz0o8OR8Z4_0JP-Wbg2rGGtbtyBRYExCqw>
    <xmx:f5-KYWwC3T_IpR_AYcpJXfg9vOA4ivQ_o9ghdCi09QGd9I_6leRMrA>
    <xmx:f5-KYV4Ymz-67qG8qVACmSyvqDCof_k_BWkMmNTR-cnjIt5PGqmPcj45xSY>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 9 Nov 2021 11:19:10 -0500 (EST)
Date:   Tue, 9 Nov 2021 17:19:09 +0100
From:   Greg KH <greg@kroah.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@google.com>,
        Yi Fan <yfa@google.com>, shreyas.joshi@biamp.com,
        Joshua Levasseur <jlevasseur@google.com>, sashal@kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH] printk/console: Allow to disable console output by using
 console="" or console=null
Message-ID: <YYqfffh2daWMA5Pa@kroah.com>
References: <YYqZdkLBAC8mtRSC@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYqZdkLBAC8mtRSC@alley>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 09, 2021 at 04:53:26PM +0100, Petr Mladek wrote:
> The commit 48021f98130880dd74 ("printk: handle blank console arguments
> passed in.") prevented crash caused by empty console= parameter value.
> 
> Unfortunately, this value is widely used on Chromebooks to disable
> the console output. The above commit caused performance regression
> because the messages were pushed on slow console even though nobody
> was watching it.
> 
> Use ttynull driver explicitly for console="" and console=null
> parameters. It has been created for exactly this purpose.
> 
> It causes that preferred_console is set. As a result, ttySX and ttyX
> are not used as a fallback. And only ttynull console gets registered by
> default.
> 
> It still allows to register other consoles either by additional console=
> parameters or SPCR. It prevents regression because it worked this way even
> before. Also it is a sane semantic. Preventing output on all consoles
> should be done another way, for example, by introducing mute_console
> parameter.
> 
> Link: https://lore.kernel.org/r/20201006025935.GA597@jagdpanzerIV.localdomain
> Suggested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> Tested-by: Guenter Roeck <linux@roeck-us.net>
> Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Signed-off-by: Petr Mladek <pmladek@suse.com>
> Link: https://lore.kernel.org/r/20201111135450.11214-3-pmladek@suse.com
> ---
> 
> This is backport of the commit 3cffa06aeef7ece30f6b5ac0e
> ("printk/console: Allow to disable console output by using
> console="" or console=null") for stable release:
> 
>     + 4.4, 4.9, 4.14, 4.19, 5.4
> 
> Please, use the original upstream commit for stable release:
> 
>    + 5.10
> 
> It should fix the problem reported at
> https://www.spinics.net/lists/stable/msg509616.html

Thanks, now all queued up!

greg k-h
