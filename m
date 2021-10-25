Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 401AF4399B5
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 17:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233778AbhJYPKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 11:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233750AbhJYPKl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 11:10:41 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402B4C061745;
        Mon, 25 Oct 2021 08:08:19 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id e59-20020a9d01c1000000b00552c91a99f7so15389951ote.6;
        Mon, 25 Oct 2021 08:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0i9A8W66RFfBxdwNrTea1JXD72yIeM0GMxTmhvajXzI=;
        b=Y9llym05CJNRQ4jxpxDaR2gD631VYUba9ycrHfstKAtdUaajLETDiy+aYqUGH0KvGs
         TZO75zSbPaolMidx53Sowec0wE+WpNfVCyAK1ZfTOboSTAQZ30LEvo1pmS2neGzBbLCm
         G+OFbV9B0DqtTJLIgtRPHaYRrocy0tZKOgfzPawcpxMR1HGTtJf5EfgWajbwvXZ9RXbj
         29kdJm1eNAOBmnZURd0LFOht8ngPHd3IUdwCu/R7Z0VSb8rp9P27wRe0AMaxdCYdJjfB
         XYch3wr7Z1Tkje8dntQ9PfT+4suaV+MU74Srx2gK0URI07ddquee8UBcNOQJH8P5HJNp
         JwUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0i9A8W66RFfBxdwNrTea1JXD72yIeM0GMxTmhvajXzI=;
        b=cm4ylJQA53VUi+swZyIzq6XXzgDdMGa8OLln6HI+DvjNdTSjShdI6VAE0E9w/nBQQJ
         JoCOJ2ZYEhqhdvbx/xr3+6YQZjrowgsj4q+rvp1IawfhjXElFrMOXRVIza/es+yuCl46
         8uunSSF3xAk7v6bHtWoC6PZmA9PcYbvoqDhiRhL1w6QE5G5O4gq/IyW2CssndKZBYqdE
         XoyRWWNs3uvskZQZEVfxetZe0kOlEvaaOZ2XNaxpy3nCRyuyhl1iAISKrfW8OIu/LZF0
         Yg0tH2a3VCWs6llNPxgsKTMnY43sghexD8OvkVXfDCZuMJmblD3HCiI7Ii+wY05pXZg2
         FtRA==
X-Gm-Message-State: AOAM532MP4r3UbGzQGe4r0AeyZ59Qa2Ok8pHxto8VGn5B+PBiwVTqRqw
        LAYhzuJKyNk1TZ+X33ki/Fa1Xvec1hSU3A==
X-Google-Smtp-Source: ABdhPJxj15twYNELKFv/DvQbdqi+sVmeml8x+5y/g9KL7w8MF4JoHUTULMHW1GL4blBmCwzKP5txLA==
X-Received: by 2002:a05:6830:3116:: with SMTP id b22mr14638515ots.212.1635174498674;
        Mon, 25 Oct 2021 08:08:18 -0700 (PDT)
Received: from ?IPV6:2603:8090:2005:39b3::101e? (2603-8090-2005-39b3-0000-0000-0000-101e.res6.spectrum.com. [2603:8090:2005:39b3::101e])
        by smtp.gmail.com with ESMTPSA id 95sm3597553otr.2.2021.10.25.08.08.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 08:08:18 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <e9098c0e-e1fe-5d65-c111-1607d0a6a1a7@lwfinger.net>
Date:   Mon, 25 Oct 2021 10:08:16 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 2/2] staging: r8712u: fix control-message timeout
Content-Language: en-US
To:     Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        linux-staging@lists.linux.dev, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20211025120910.6339-1-johan@kernel.org>
 <20211025120910.6339-3-johan@kernel.org>
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <20211025120910.6339-3-johan@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/25/21 07:09, Johan Hovold wrote:
> USB control-message timeouts are specified in milliseconds and should
> specifically not vary with CONFIG_HZ.
> 
> Fixes: 2865d42c78a9 ("staging: r8712u: Add the new driver to the mainline kernel")
> Cc: stable@vger.kernel.org      # 2.6.37
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>   drivers/staging/rtl8712/usb_ops_linux.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

> 
> diff --git a/drivers/staging/rtl8712/usb_ops_linux.c b/drivers/staging/rtl8712/usb_ops_linux.c
> index 655497cead12..f984a5ab2c6f 100644
> --- a/drivers/staging/rtl8712/usb_ops_linux.c
> +++ b/drivers/staging/rtl8712/usb_ops_linux.c
> @@ -494,7 +494,7 @@ int r8712_usbctrl_vendorreq(struct intf_priv *pintfpriv, u8 request, u16 value,
>   		memcpy(pIo_buf, pdata, len);
>   	}
>   	status = usb_control_msg(udev, pipe, request, reqtype, value, index,
> -				 pIo_buf, len, HZ / 2);
> +				 pIo_buf, len, 500);
>   	if (status > 0) {  /* Success this control transfer. */
>   		if (requesttype == 0x01) {
>   			/* For Control read transfer, we have to copy the read
> 

