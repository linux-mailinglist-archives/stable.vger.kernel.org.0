Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F2038751F
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 11:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347360AbhERJav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 05:30:51 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:39787 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240100AbhERJar (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 05:30:47 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailnew.nyi.internal (Postfix) with ESMTP id A978A580729;
        Tue, 18 May 2021 05:29:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 18 May 2021 05:29:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=MbOekwFYh3ZNeYFAq9oXcP4VD4r
        kLeeLk7e8qTQg8A0=; b=vmLvarEmJTonv5iZmlSHzdECI66NDgZ7mQSO1pduGJB
        0L8MwWonFM75R2Y1ojOXrpz35lg73SfTUxqco44sw9v5fki4AgLRKjZmuMARH6xY
        fTkZNAKHGENkgF6soydGHby51P8Vkh5r1bbZfVWbk1qfnXnjYBO/TOXWCJPGlLHx
        lVNeaOcnH1kwLCd+O2MKwH7bFaKskpuugrVYocDHJTm6yjy+79EAABzyhB12rfJl
        KmnEmzxkHNgWD2xcGzi0JPIrGlWE0MVMI901jyR2qvBI+mn9UAR5pm7rlDClmnxo
        4an7WtZqyxJoMZaSAu6Dc150jJjLY4yTyX8WpYSJzmw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=MbOekw
        FYh3ZNeYFAq9oXcP4VD4rkLeeLk7e8qTQg8A0=; b=HZRSQRuhsrBwNQc3uu4/eR
        yHE13lVaOILcJxJ9RCexhFCfcWMSz0QuJqXhys94tdn5BnsndiZCdaWynkpkKfz5
        uD9mIpzEXhMfX1vXZECjhUb4gyGaBQxjKzC/o5L+YjoXs+giHL9ccVs9sIYg7fiC
        mmI6kH3vI97rTJyQjThJV6tS4Tk1jud8V9SPGyUs/dS+rTI10Fz4RZv83rk70rYM
        +/ZLuFwruDmX0oUYDgxwGpz/cQzTs3zJ3BXPpD/AT/o3nnCJGjs8mJITQiqy8vTm
        VTb4gglXUuiY8GbZHRFsV1JCg/iXbWZ8o0nzhM6RFPgrXvnuA7ItzJIYyihBQIgw
        ==
X-ME-Sender: <xms:-YijYLiZkzfOG7MoOPKrNM2NN-n_bWM0NxqVU_nDxDrprnlthAG0pQ>
    <xme:-YijYIDfidNA3b-_9eWcOFS3cgg9IKZoSyoj7agmQAUadaJSIHSLaiRaF9A3tt_8g
    -w2wamqK7NcLw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeijedgudehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:-YijYLGB4fFKDtxJVvYkC27fh4y1nQboCP-47EAYVr0P5A8w5mNPsQ>
    <xmx:-YijYISqmOm0EbXVaEE0JbPOqJf8VKEE7-pU8AK0O-1vXSzq0vamoA>
    <xmx:-YijYIz2JoUA8tVy2YaVQVIjIK1Wfi7y3L9egY7n23bjBWvTmUGdWQ>
    <xmx:-YijYEd0_WH0bhaMWqosimcJaV2Z_m2tg6vbUTWSQjp5dHZf4MEzdw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Tue, 18 May 2021 05:29:28 -0400 (EDT)
Date:   Tue, 18 May 2021 11:29:26 +0200
From:   Greg KH <greg@kroah.com>
To:     Patryk Duda <pdk@semihalf.com>
Cc:     Benson Leung <bleung@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        linux-kernel@vger.kernel.org, upstream@semihalf.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] platform/chrome: cros_ec_proto: Send command again when
 timeout occurs
Message-ID: <YKOI9ndTg8s1uUvx@kroah.com>
References: <20210518090925.15480-1-pdk@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210518090925.15480-1-pdk@semihalf.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 18, 2021 at 11:09:25AM +0200, Patryk Duda wrote:
> Sometimes kernel is trying to probe Fingerprint MCU (FPMCU) when it
> hasn't initialized SPI yet. This can happen because FPMCU is restarted
> during system boot and kernel can send message in short window
> eg. between sysjump to RW and SPI initialization.
> 
> Cc: <stable@vger.kernel.org> # 4.4+
> Signed-off-by: Patryk Duda <pdk@semihalf.com>
> ---
> Fingerprint MCU is rebooted during system startup by AP firmware (coreboot).
> During cold boot kernel can query FPMCU in a window just after jump to RW
> section of firmware but before SPI is initialized. The window was
> shortened to <1ms, but it can't be eliminated completly.
> 
> Communication with FPMCU (and all devices based on EC) is bi-directional.
> When kernel sends message, EC will send EC_SPI* status codes. When EC is
> not able to process command one of bytes will be eg. EC_SPI_NOT_READY.
> This mechanism won't work when SPI is not initailized on EC side. In fact,
> buffer is filled with 0xFF bytes, so from kernel perspective device is not
> responding. To avoid this problem, we can query device once again. We are
> already waiting EC_MSG_DEADLINE_MS for response, so we can send command
> immediately.
> 
> Best regards,
> Patryk
>  drivers/platform/chrome/cros_ec_proto.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/platform/chrome/cros_ec_proto.c b/drivers/platform/chrome/cros_ec_proto.c
> index aa7f7aa77297..3384631d21e2 100644
> --- a/drivers/platform/chrome/cros_ec_proto.c
> +++ b/drivers/platform/chrome/cros_ec_proto.c
> @@ -279,6 +279,18 @@ static int cros_ec_host_command_proto_query(struct cros_ec_device *ec_dev,
>  	msg->insize = sizeof(struct ec_response_get_protocol_info);
>  
>  	ret = send_command(ec_dev, msg);
> +	/*
> +	 * Send command once again when timeout occurred.
> +	 * Fingerprint MCU (FPMCU) is restarted during system boot which
> +	 * introduces small window in which FPMCU won't respond for any
> +	 * messages sent by kernel. There is no need to wait before next
> +	 * attempt because we waited at least EC_MSG_DEADLINE_MS.
> +	 */
> +	if (ret == -ETIMEDOUT) {
> +		dev_warn(ec_dev->dev,
> +			 "Timeout to get response from EC. Retrying.\n");

If a user sees this, what can they do?  No need to spam the kernel logs,
just retry.

> +		ret = send_command(ec_dev, msg);

But wait, why just retry once?  Why not 10 times?  100?  1000?  How
about a simple loop here instead, with a "sane" number of retries as a
max.

thanks,

greg k-h
