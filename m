Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B561B4B77
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 19:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgDVRUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 13:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726006AbgDVRUL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 13:20:11 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733DCC03C1A9;
        Wed, 22 Apr 2020 10:20:11 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id p25so1414621pfn.11;
        Wed, 22 Apr 2020 10:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kKcesp6qmf5FNzpaYA3INqLgOOg1x3Ai8a2NGucJe0Y=;
        b=eulBV6VZFoAYrkvPdHJuhN6hWH+zrxQfQrWxXVQc5nUOyt4+6FYhtRWB7Y23BP1fuq
         FgDvdGLaluCfqEr3+kDKU2fruaAV98O507p21whHp69JOA3Jc1jxuWwISlzWtpr8GfXt
         El/+wy4rro419MguZVf41GEYDboQyiamLMRSnpbkthEvleuNQ5A3UZFgMAzhqAhKD827
         4RbdFpLdJxnVGeLRxbG2Dg1AU5tCIaiiNLLE+vjsLvlfcWnUbKfvyACLNLqhfAvtXXu1
         4d1GZBGAuKo4ovqoml+lBlta9QUuPOHMLFLmRGyAFC5q8NC7WSF2JfLw0QSgLE50sL9r
         6HUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kKcesp6qmf5FNzpaYA3INqLgOOg1x3Ai8a2NGucJe0Y=;
        b=mxGPVik2+FNMIxVQc3IUgQKBCSC2Fx1esLnenTfzCZDGcne1CUTWi0j80QBnem4aMJ
         WMXHsIdSxEzT/cGfCTUZYuI96nkDtvziFyoLnZGgAfPtDPBH8YeVVRVtjakWKrzmJZ1c
         8lGVNszunIA01S/aOJDsBCQLlyEy852JszViORl0JY0DuF4MN74442TtJQi8NV9PwIss
         0kA+58vL/bt6KOE0dQG7BwGAAcdSXNF0dpEFN3d/5fkEJq3Ug8ip/m6ecYRgq8nrojJW
         UlslNJSx3RIVyC+7NzcgF7x2EDOYf+8rvMeheui73JJPE5RGXVeuZdqVlg1oypUX09tl
         +8Xg==
X-Gm-Message-State: AGi0PuY3h36AL6Qb90eDJ8NDkVjnv47ilq17P/VnzRIx9uq2bpcd/mRW
        XMI6mv8elhHi1zYr2OfTOB0tMWIfo2BHCQ==
X-Google-Smtp-Source: APiQypJPVg7GYiSS/0Ov6/4EBEk2zjkAZ0/+GrKMa2RUJd2d2KLDyCNR9vC1Yimyepp386lyyW86KA==
X-Received: by 2002:a63:6a84:: with SMTP id f126mr116473pgc.14.1587576010289;
        Wed, 22 Apr 2020 10:20:10 -0700 (PDT)
Received: from ?IPv6:2604:4080:1012:8d30:9eb6:d0ff:fe8b:175f? ([2604:4080:1012:8d30:9eb6:d0ff:fe8b:175f])
        by smtp.gmail.com with ESMTPSA id 128sm55876pfy.5.2020.04.22.10.20.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 10:20:09 -0700 (PDT)
Subject: Re: [PATCH] Input: xpad - Add custom init packet for Xbox One S
 controllers
To:     LuK1337 <priv.luk@gmail.com>
Cc:     stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Richard Fontana <rfontana@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <92b71dc5-ddd5-7ffd-65f8-65a6610dfe43@gmail.com>
 <20200422075206.18229-1-priv.luk@gmail.com>
From:   Cameron Gutman <aicommander@gmail.com>
Message-ID: <8015c173-79e5-4627-c955-0b87e17f3034@gmail.com>
Date:   Wed, 22 Apr 2020 10:20:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200422075206.18229-1-priv.luk@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/22/20 12:52 AM, LuK1337 wrote:
> From: Łukasz Patron <priv.luk@gmail.com>
> 
> Sending [ 0x05, 0x20, 0x00, 0x0f, 0x06 ] packet for
> Xbox One S controllers fixes an issue where controller
> is stuck in Bluetooth mode and not sending any inputs.
> 
> Signed-off-by: Łukasz Patron <priv.luk@gmail.com>
> Cc: stable@vger.kernel.org

LGTM. Tested working on both of my Xbox One S gamepads:
- idVendor=045e, idProduct=02ea, bcdDevice= 3.01
- idVendor=045e, idProduct=02ea, bcdDevice= 4.08

Reviewed-by: Cameron Gutman <aicommander@gmail.com>

> ---
>  drivers/input/joystick/xpad.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
> index 6b40a1c68f9f..c77cdb3b62b5 100644
> --- a/drivers/input/joystick/xpad.c
> +++ b/drivers/input/joystick/xpad.c
> @@ -458,6 +458,16 @@ static const u8 xboxone_fw2015_init[] = {
>  	0x05, 0x20, 0x00, 0x01, 0x00
>  };
>  
> +/*
> + * This packet is required for Xbox One S (0x045e:0x02ea)
> + * and Xbox One Elite Series 2 (0x045e:0x0b00) pads to
> + * initialize the controller that was previously used in
> + * Bluetooth mode.
> + */
> +static const u8 xboxone_s_init[] = {
> +	0x05, 0x20, 0x00, 0x0f, 0x06
> +};
> +
>  /*
>   * This packet is required for the Titanfall 2 Xbox One pads
>   * (0x0e6f:0x0165) to finish initialization and for Hori pads
> @@ -516,6 +526,8 @@ static const struct xboxone_init_packet xboxone_init_packets[] = {
>  	XBOXONE_INIT_PKT(0x0e6f, 0x0165, xboxone_hori_init),
>  	XBOXONE_INIT_PKT(0x0f0d, 0x0067, xboxone_hori_init),
>  	XBOXONE_INIT_PKT(0x0000, 0x0000, xboxone_fw2015_init),
> +	XBOXONE_INIT_PKT(0x045e, 0x02ea, xboxone_s_init),
> +	XBOXONE_INIT_PKT(0x045e, 0x0b00, xboxone_s_init),
>  	XBOXONE_INIT_PKT(0x0e6f, 0x0000, xboxone_pdp_init1),
>  	XBOXONE_INIT_PKT(0x0e6f, 0x0000, xboxone_pdp_init2),
>  	XBOXONE_INIT_PKT(0x24c6, 0x541a, xboxone_rumblebegin_init),
> 

