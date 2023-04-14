Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61ED86E18E0
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 02:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjDNAOb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 20:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjDNAOa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 20:14:30 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E75D5FD0;
        Thu, 13 Apr 2023 17:13:49 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id c10-20020a17090abf0a00b0023d1bbd9f9eso20106471pjs.0;
        Thu, 13 Apr 2023 17:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681431191; x=1684023191;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=WJQn8xlUXGO8WXDwuesuglKEx8PEVVyreK/tNf7kaQ8=;
        b=C2Ylhbi83oEcJ+Pl6mYnd5e/4cYbF7z7TIhJoV60QIIHSzNak/9XG5hfI5PrvadNyd
         nSIFxi2Ihdt9V91JfnQbi+hyFTP9wWie05OBgCoJRuZYtYUVoUBRWjWzB2MOXtnvkhpX
         WNqEzBdGtqw1OK7+Nv0GCjEkR5B6z/Jj6WqjBDzQWCE/CCcqZ6w0/WH8hyGhRq0B7jQu
         lQPnedLfThkA7MxOOwc/i8QmJc+jpEvAlqAjqUQs2k2DU6RZXd+H1BFv5oF9kgMJRRSR
         bwiX/QsTEGNj3M+oA+0+o4k7mbeMgvgUl0VjHnwCAzj0K8U5smnGgVlN7vRyxvd2PCLA
         O3zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681431191; x=1684023191;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WJQn8xlUXGO8WXDwuesuglKEx8PEVVyreK/tNf7kaQ8=;
        b=TRxP5FjBkqKOdX3kBQmWl/B+pPvjOSgvO0tEee29SNVFuB93zrubvb8N41NbxQG6ve
         ryyg/n/gc9dC+ic52BJwhsenkTPkSKJ2MG9d5aKak38YEMdm1o9RsBgZk/m6IflQEDZq
         ADU2EMMBW/0Ow4RS7DiI6+SXgvWxvZC7ek2yfikvF9TaziT3mTXrifWI1igvHwm8nFDr
         2D9m7VeuZe308m5ue1UJPJkjBnZy9J0M4wc/tjEB6S5BLRC8IpCm4je855SsPt5GZuVd
         VBA6QR30vX3l+x6DPgTyMn9lVoDAhJjNvBOw7n3W7i3ajP+RF7JCmZu4yV7Z50njLtGb
         VZFA==
X-Gm-Message-State: AAQBX9cJnQu3QTu8mhh5j1L+Bxn+jN04MQvq43R96mWiuwjEcmQlCbu4
        op0i+bO5HmvTqDRLHhQ86uM=
X-Google-Smtp-Source: AKy350ZNzGuilfrbZYFX/ozYgyPOUjmKHTLeRWP3lNOGxrmFegL4vBQnImajURZ3gYAVkmhnC6zC0w==
X-Received: by 2002:a17:90b:e90:b0:246:fd10:a652 with SMTP id fv16-20020a17090b0e9000b00246fd10a652mr3591599pjb.33.1681431191463;
        Thu, 13 Apr 2023 17:13:11 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id oa4-20020a17090b1bc400b002469a865810sm3745477pjb.28.2023.04.13.17.13.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Apr 2023 17:13:10 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <c19781d1-8cb9-ee38-9892-b4bc9016dd38@roeck-us.net>
Date:   Thu, 13 Apr 2023 17:13:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 5.10 5.4 4.19 4.14] watchdog: sbsa_wdog: Make sure the
 timeout programming is within the limits
Content-Language: en-US
To:     "Tyler Hicks (Microsoft)" <code@tyhicks.com>,
        stable@vger.kernel.org
Cc:     George Cherian <george.cherian@marvell.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        linux-watchdog@vger.kernel.org
References: <20230413204823.724485-1-code@tyhicks.com>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230413204823.724485-1-code@tyhicks.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/13/23 13:48, Tyler Hicks (Microsoft) wrote:
> From: George Cherian <george.cherian@marvell.com>
> 
> [ Upstream commit 000987a38b53c172f435142a4026dd71378ca464 ]
> 
> Make sure to honour the max_hw_heartbeat_ms while programming the timeout
> value to WOR. Clamp the timeout passed to sbsa_gwdt_set_timeout() to
> make sure the programmed value is within the permissible range.
> 
> Fixes: abd3ac7902fb ("watchdog: sbsa: Support architecture version 1")
> 
> Signed-off-by: George Cherian <george.cherian@marvell.com>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> Link: https://lore.kernel.org/r/20230209021117.1512097-1-george.cherian@marvell.com
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
> Signed-off-by: Tyler Hicks (Microsoft) <code@tyhicks.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
> 
> The Fixes line in the original commit is incorrect. This commit fixes a
> bug that goes all the way back to v4.6 commit 57d2caaabfc7 ("Watchdog:
> introduce ARM SBSA watchdog driver") when only 32-bit Watchdog Offset
> Registers (WOR) were supported.
> 
> Without this fix, there's a truncation on the first argument, of u32
> type, passed to writel() in the following situation situation:
> 
> Generic Watchdog architecture version is 1 (WOR is 32-bit)
> action is 1
> timeout is 240s
> CNTFRQ_EL0 is 25000050 Hz
> wdd.max_hw_heartbeat_ms is 171s
> 
> 25000050 * 240 = 6000012000  <--- requires 33 bits to store
> 6000012000 & 0xFFFFFFFF = 1705044704  <--- truncated value written to WOR
> 1705044704 / 25000050 = 68.2s  <--- timeout incorrectly set to 68.2s
> 
> The timeout from userspace is greater than wdd.max_hw_heartbeat_ms so
> the watchdog core pings at 69s (240 - 171) which results in
> intermittent and unexpected panics (action=1).
> 
> With this patch applied, the timeout passed to writel() never exceeds
> 32-bits and the watchdog core + systemd keeps the watchdog happy.
> 
> I've validated this fix on real hardware running a linux-5.10.y stable
> kernel. Please apply this patch to 5.10 through 4.14. Thanks!
> 
> Tyler
> 
>   drivers/watchdog/sbsa_gwdt.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/watchdog/sbsa_gwdt.c b/drivers/watchdog/sbsa_gwdt.c
> index f0f1e3b2e463..4cbe6ba52754 100644
> --- a/drivers/watchdog/sbsa_gwdt.c
> +++ b/drivers/watchdog/sbsa_gwdt.c
> @@ -121,6 +121,7 @@ static int sbsa_gwdt_set_timeout(struct watchdog_device *wdd,
>   	struct sbsa_gwdt *gwdt = watchdog_get_drvdata(wdd);
>   
>   	wdd->timeout = timeout;
> +	timeout = clamp_t(unsigned int, timeout, 1, wdd->max_hw_heartbeat_ms / 1000);
>   
>   	if (action)
>   		writel(gwdt->clk * timeout,

