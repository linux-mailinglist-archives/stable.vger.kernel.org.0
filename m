Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAD2257F8F8
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 07:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbiGYFfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 01:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiGYFfS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 01:35:18 -0400
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05550627E;
        Sun, 24 Jul 2022 22:35:17 -0700 (PDT)
Received: by mail-ej1-f49.google.com with SMTP id ez10so18438181ejc.13;
        Sun, 24 Jul 2022 22:35:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bEKUptPwiXE23qqaRIyGBuZTcUTnqL9SwX/wsk/4AXE=;
        b=ouqyfzdOqIFF2S9G/+SDFxWBHRJiM3TLsdJCcca3nfxJAjni3C0QDEkPxtyEOwwa/+
         zk8WCg6Bhqs6NytdwJkDu3OvqO8XiovSm4OIvt7OR6brBZofFUrWVf9nFJGL/SNw+Z32
         o+Eqj1zKlvsL/54DeNjbf0g82Ur3qNMq3NLzBiiGZ1ZrQQbNuvi95xtzzJdUVsrB7GLV
         WhkIka82zcdYjagpQYM5Dam2U1LGvkUrSvZXbNHp7gBoXI5+7DeBGXGzmZK4s9pKJQzT
         eqFaXIuhjVUzuz9vzW9Ic6oD2mnkhq2N2+I6vx6l6Mbt1rhoSFqinNlkkhy890FY2hEN
         F7MQ==
X-Gm-Message-State: AJIora+kQHzsca9g8tQwhhmCTwglMVXTkvJV0jdGiM0lUrJXhBf25NX+
        txga0mDP9VQxzv5w4mOSUAc5yxdhjtw=
X-Google-Smtp-Source: AGRyM1sNUqcU6aDoQDJuIAsAIoMj0aqBgbOyozpf56nbqklJZ3jrlgZwgw8q0xdE1DkLAOuEaWa7GA==
X-Received: by 2002:a17:907:7d89:b0:72b:9eb4:a8c7 with SMTP id oz9-20020a1709077d8900b0072b9eb4a8c7mr8624711ejc.167.1658727315458;
        Sun, 24 Jul 2022 22:35:15 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id e26-20020a170906315a00b0072fa24c2ecbsm4219390eje.94.2022.07.24.22.35.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Jul 2022 22:35:15 -0700 (PDT)
Message-ID: <544401cc-97ad-c9b6-16e0-ea74d2695fd4@kernel.org>
Date:   Mon, 25 Jul 2022 07:35:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH AUTOSEL 5.18 28/54] tty: Add N_CAN327 line discipline ID
 for ELM327 based CAN driver
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Max Staudt <max@enpas.org>, Marc Kleine-Budde <mkl@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20220720011031.1023305-1-sashal@kernel.org>
 <20220720011031.1023305-28-sashal@kernel.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20220720011031.1023305-28-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20. 07. 22, 3:10, Sasha Levin wrote:
> From: Max Staudt <max@enpas.org>
> 
> [ Upstream commit ec5ad331680c96ef3dd30dc297b206988023b9e1 ]
> 
> The actual driver will be added via the CAN tree.

Hmm, it's a new driver (ldisc). Should it really go to stable?

> Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Max Staudt <max@enpas.org>
> Link: https://lore.kernel.org/r/20220618180134.9890-1-max@enpas.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   include/uapi/linux/tty.h | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/tty.h b/include/uapi/linux/tty.h
> index 9d0f06bfbac3..68aeae2addec 100644
> --- a/include/uapi/linux/tty.h
> +++ b/include/uapi/linux/tty.h
> @@ -38,8 +38,9 @@
>   #define N_NULL		27	/* Null ldisc used for error handling */
>   #define N_MCTP		28	/* MCTP-over-serial */
>   #define N_DEVELOPMENT	29	/* Manual out-of-tree testing */
> +#define N_CAN327	30	/* ELM327 based OBD-II interfaces */
>   
>   /* Always the newest line discipline + 1 */
> -#define NR_LDISCS	30
> +#define NR_LDISCS	31
>   
>   #endif /* _UAPI_LINUX_TTY_H */


-- 
js
suse labs
