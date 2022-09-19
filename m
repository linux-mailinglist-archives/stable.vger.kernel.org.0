Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84EBD5BC24C
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 06:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiISEm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 00:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiISEm0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 00:42:26 -0400
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF1DD18E2E;
        Sun, 18 Sep 2022 21:42:25 -0700 (PDT)
Received: by mail-ej1-f44.google.com with SMTP id sb3so32098486ejb.9;
        Sun, 18 Sep 2022 21:42:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=aIXQs/kCXdFiwu/6JpfokiTAoeAtHE/zFsQTYIbiR34=;
        b=SAadA1Zh2DJkX7nJT9AI16c3FSh0mAwFm17m/gjNrCeu44LqDxxh89tROXNPBIYbCx
         ewXJWtA6nsCIpKqblR6Wpuwhqjgrzp04nFxT5R/7WvBneMzJRDdJO0KQQbuUXHRIJErz
         dTRKydvkBjIWYHWK/2I8hFGhxKz1XeMvJad+rdGTjgSuShkgDp9kuimYCdiZhLanjB4J
         UHj22sxpAS6Y1tlmLHMnxcdIAbGjec+CauMVNPo0Hyby1ySrsjGcHP7iI+oFeDE7YuVN
         MrkEt2tk4Ngsv08w1VIVkMTUujgqFJGz5oYUl7hPGNHgAL6yX/CJXjBlRHsVx5BDCG+2
         2OYA==
X-Gm-Message-State: ACrzQf2RYgpj6PWh62JqzY/K9M6lm1I4vmIFxPe/RpLRQM2RvZ04xlwa
        gKR7zdSrjykQgNym2LB2PHI=
X-Google-Smtp-Source: AMsMyM4Z5rPr2EhqcjK3OLll0P8NevM9QOCejeRkX5p8AownGJFXQPSuSMC2s69avWHHHzd3ycT6Uw==
X-Received: by 2002:a17:906:ee8e:b0:730:3646:d178 with SMTP id wt14-20020a170906ee8e00b007303646d178mr11696974ejb.426.1663562544234;
        Sun, 18 Sep 2022 21:42:24 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id x3-20020a170906710300b007317f017e64sm14898707ejj.134.2022.09.18.21.42.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Sep 2022 21:42:23 -0700 (PDT)
Message-ID: <8fa701a1-3f34-9152-daf6-1618dd0e7727@kernel.org>
Date:   Mon, 19 Sep 2022 06:42:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH 1/2] serial: 8250: Let drivers request full 16550A feature
 probing
Content-Language: en-US
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Josh Triplett <josh@joshtriplett.org>,
        Anders Blomdell <anders.blomdell@control.lth.se>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <alpine.DEB.2.21.2209162317180.19473@angie.orcam.me.uk>
 <alpine.DEB.2.21.2209171043270.31781@angie.orcam.me.uk>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <alpine.DEB.2.21.2209171043270.31781@angie.orcam.me.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 17. 09. 22, 12:07, Maciej W. Rozycki wrote:
> --- linux-macro.orig/include/linux/serial_core.h
> +++ linux-macro/include/linux/serial_core.h
> @@ -414,7 +414,7 @@ struct uart_icount {
>   	__u32	buf_overrun;
>   };
>   
> -typedef unsigned int __bitwise upf_t;
> +typedef __u64 __bitwise upf_t;

Why __u64 and not u64?

>   typedef unsigned int __bitwise upstat_t;
>   
>   struct uart_port {
> @@ -522,6 +522,7 @@ struct uart_port {
>   #define UPF_FIXED_PORT		((__force upf_t) (1 << 29))
>   #define UPF_DEAD		((__force upf_t) (1 << 30))
>   #define UPF_IOREMAP		((__force upf_t) (1 << 31))
> +#define UPF_FULL_PROBE		((__force upf_t) (1ULL << 32))

This looks like a perfect time to switch them all to BIT_ULL().

thanks,
-- 
js
suse labs

