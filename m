Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 810873BA252
	for <lists+stable@lfdr.de>; Fri,  2 Jul 2021 16:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbhGBOtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Jul 2021 10:49:47 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:39931 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232930AbhGBOtq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Jul 2021 10:49:46 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 42E475C012A;
        Fri,  2 Jul 2021 10:47:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 02 Jul 2021 10:47:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=auSwHk3r7cardj7nXW1L5fB3OAn
        30noyQVw1mcZGr9Q=; b=V/8AwNrJUywwVXvYKt3hQCTA8It1gLXPikT9vbxM6Of
        C7/nAjUOj+0i1lgPewifcC+ilTMkAAbpO2bMVyURWOcaOEiaMGEnzm5/XgH/79ca
        Daff3fUicVrnaxd8FoOElj5HXxIIe9S56/0ZwTQGVYffYcwYoAwIZ7h9DGc8P4zY
        5Ya/IKvs5l7uq+fZtteM1sBNCKDFzoX7AM2k93xQzgYJGrWnL+OUnc5Am5BlciXy
        Uu5CKcvdfmmR8qTTpLSMZoGm1Mfo6fnObCijNUK+A3eDN8yp5eVzaDCQOKpNIlA3
        nqNLiNz0gk8bGl7OENPaw+Eztx/DG57j9o8j0ep7SYw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=auSwHk
        3r7cardj7nXW1L5fB3OAn30noyQVw1mcZGr9Q=; b=GY4j7zzTMxFDAfebXv51jm
        IL8PJ3+ry6Tx1NetN/t1wMpQp1ElMe1GiKJEWKhbE4tCeTAzC7S+yiKBZcHuxl67
        LYtrABgbzeAX8U1n//SQpTgsfhE3lkz8Z3fUnJS0w7bPo26cxu45O5LdreUaoOH/
        SCN2ksVN5LmL7Y/UvTP0cy84eZezqPm4ylDnum4RehPGWB9gYNp28R3GiOzGt+UQ
        ECoIMCZNR+d3AmMg90It40KKoqrx0Ia+RCDxCElSu2ovtq1mBc4nvurdWnHJ/2ke
        ngujDLHrZH8z9QT72r6ue47SJKfsTXQlPoRNrdTtc8/8bUyH9AtrQtvmVfx8yHSQ
        ==
X-ME-Sender: <xms:8SbfYITgam-VN7unJtp6X9aqwjgnSYeuy0EwCoxTuhrOO7HNCreWyg>
    <xme:8SbfYFxM3i_vPd1DzX_9e_uJMD5LU6Z_1GOgcr9o0TOA_cwG--6zB8wcBOVlK9cwo
    EE40IEQinfbgQ>
X-ME-Received: <xmr:8SbfYF2DcT5GdcJ3Q98cJRO2CqiSbMAsQmWWH3bq-KRvrFfDiYS5KKUy5f7hwBUNa2_mUaozrhf1MGLI9alXyJArxaeHyaIA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeeikedgjeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:8SbfYMDo-ZYe6T5FzWweEFMEsKFXLuzHybeQe8y5jdWgiPx26JKLiQ>
    <xmx:8SbfYBheyBytZpgq3oeIK516jgpnEuO6kKLP742S-ETpy5bTXBvhAQ>
    <xmx:8SbfYIo84FSjI67s3HiK6UkTh5P00kir1fV3bG82Pe92yJ1_7WHHCg>
    <xmx:8ibfYMVuIQeOnYOs-Ha2z5-M75d_NXWFY8kK41xGRgcna_HJg0YLYw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 2 Jul 2021 10:47:13 -0400 (EDT)
Date:   Fri, 2 Jul 2021 16:47:11 +0200
From:   Greg KH <greg@kroah.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/6] USB: serial: cp210x: fix control-characters error
 handling
Message-ID: <YN8m7wk0dfSLi+c5@kroah.com>
References: <20210702134227.24621-1-johan@kernel.org>
 <20210702134227.24621-2-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210702134227.24621-2-johan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 02, 2021 at 03:42:22PM +0200, Johan Hovold wrote:
> In the unlikely event that setting the software flow-control characters
> fails the other flow-control settings should still be updated.
> 
> Fixes: 7748feffcd80 ("USB: serial: cp210x: add support for software flow control")
> Cc: stable@vger.kernel.org	# 5.11
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/usb/serial/cp210x.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
> index 09b845d0da41..b41e2c7649fb 100644
> --- a/drivers/usb/serial/cp210x.c
> +++ b/drivers/usb/serial/cp210x.c
> @@ -1217,9 +1217,7 @@ static void cp210x_set_flow_control(struct tty_struct *tty,
>  		chars.bXonChar = START_CHAR(tty);
>  		chars.bXoffChar = STOP_CHAR(tty);
>  
> -		ret = cp210x_set_chars(port, &chars);
> -		if (ret)
> -			return;
> +		cp210x_set_chars(port, &chars);

What's the odds that someone tries to add the error checking back in
here, in a few years?  Can you put a comment here saying why you are not
checking it?

thanks,

greg k-h
