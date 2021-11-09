Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC8944B28F
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 19:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242339AbhKISSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 13:18:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242154AbhKISSL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 13:18:11 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E348C061764
        for <stable@vger.kernel.org>; Tue,  9 Nov 2021 10:15:25 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id x19-20020a9d7053000000b0055c8b39420bso11540484otj.1
        for <stable@vger.kernel.org>; Tue, 09 Nov 2021 10:15:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eHftxZF+h7FGn5aWqsKA2PrPkorZ2cW+1dqWZe4zqD4=;
        b=LcVDHaOQmLzUwsxIgioAygdznbeQ5dfN4VEOWUZaTo5368ycM/iJcFuV+UwfLPbPsu
         z8JWAd+IIsnlfbbuTQi7g1J+unolgi1SgXTdKJrx3HVUFHQWjFRdsu7/+JiAeUrstSag
         UoM8EWKCiCdZuHLEBCRqwwEmtAtykHJjhZqN4Swki87x5GLnH2afGVgWn4pYQsa09GhM
         p//e2w2VJ28ey2Q7BzqRlzy8m6x7Hm5Yap3SwQ5g0wEKljS9Hb4u3KwAPolzMbUnyUan
         WBjBd7wQP3D09/BLAwvPlnGp/mblkyWA+DPqyzk9Wn6Gutff6RF30GUCc6K5xQH695Iw
         q3IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:to:cc:references:from:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eHftxZF+h7FGn5aWqsKA2PrPkorZ2cW+1dqWZe4zqD4=;
        b=BV8rdI59Nlw8dpNDctoJFmt/vxiRLRG1EulJ3dlJsP6Ew8VRwU57FawJ1QTefmcIfg
         rAe5lYC8+vyePBjZxdgzZDdPGb1wnxhQLLVhNfR2aJb1QupcnXQH8CUZ/1LDiK8XYlio
         LDPQpoXF/BoPJgUmAhuqrrluumUf6vWeUcu1yE9jsjoee0+v5wbXPmaRsw2v9pYIXNE7
         El0Orv8xbHoIPQSzNutAQnRUAdqMessUCWKYNHWaEc9BShDIHT72flxcaLemDTI/Yhtx
         6xkDrqbYr8T+yXoxtY5UgP1OZw1Z9QBro/ea7tEhZsWC9unv7IM/FUzrZ/tm7w4ngUuZ
         qiGg==
X-Gm-Message-State: AOAM53268iiFF78jBtLZwgA4x+UkbYcKfa9a9gIBsbj7zjV5ImK8pTh4
        bHP90srYn7kPqcbce5335LY=
X-Google-Smtp-Source: ABdhPJwV2Wo7tgwMPSSbQHSp+4l/JWtSatqtZKImA7RSOdGygyRXZ2noxqSvXiHF6iyzrUXEGyQIJQ==
X-Received: by 2002:a05:6830:290b:: with SMTP id z11mr7799269otu.200.1636481724622;
        Tue, 09 Nov 2021 10:15:24 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r3sm2166233oti.51.2021.11.09.10.15.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Nov 2021 10:15:20 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     Petr Mladek <pmladek@suse.com>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@google.com>
Cc:     Yi Fan <yfa@google.com>, shreyas.joshi@biamp.com,
        Joshua Levasseur <jlevasseur@google.com>, sashal@kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        wklin@google.com, mfaltesek@google.com
References: <YYqZdkLBAC8mtRSC@alley>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] printk/console: Allow to disable console output by using
 console="" or console=null
Message-ID: <a46e9a26-5b9f-f14c-26be-0b4d41fa7429@roeck-us.net>
Date:   Tue, 9 Nov 2021 10:15:12 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YYqZdkLBAC8mtRSC@alley>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/9/21 7:53 AM, Petr Mladek wrote:
> The commit 48021f98130880dd74 ("printk: handle blank console arguments
> passed in.") prevented crash caused by empty console= parameter value.
> 
> Unfortunately, this value is widely used on Chromebooks to disable
> the console output. The above commit caused performance regression
> because the messages were pushed on slow console even though nobody
> was watching it.
> 

We actually had to revert this patch on Chromebooks, so we'll have to revert
it again from stable releases after it gets there. The problem is two-fold:

First, it is used in Chromebooks to disable the default console in production
images; that default console may be set in a devicetree file, and this patch
doesn't really disable it. In other words, Chromebooks use "console=" to
implement "mute_console" as suggested below, and this patch does not address
that use case.

Second, the patch causes some unexplained problems with dm-verity, which
inexplicably fails on some Chromebooks when the patch is in place.
We never tracked down the root cause because the patch doesn't work
for us anyway.

Guenter

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
>      + 4.4, 4.9, 4.14, 4.19, 5.4
> 
> Please, use the original upstream commit for stable release:
> 
>     + 5.10
> 
> It should fix the problem reported at
> https://www.spinics.net/lists/stable/msg509616.html
> 
> kernel/printk/printk.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index b55dfb3e801f..6d3e1f4961fb 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -2032,8 +2032,15 @@ static int __init console_setup(char *str)
>   	char *s, *options, *brl_options = NULL;
>   	int idx;
>   
> -	if (str[0] == 0)
> +	/*
> +	 * console="" or console=null have been suggested as a way to
> +	 * disable console output. Use ttynull that has been created
> +	 * for exacly this purpose.
> +	 */
> +	if (str[0] == 0 || strcmp(str, "null") == 0) {
> +		__add_preferred_console("ttynull", 0, NULL, NULL);
>   		return 1;
> +	}
>   
>   	if (_braille_console_setup(&str, &brl_options))
>   		return 1;
> 

