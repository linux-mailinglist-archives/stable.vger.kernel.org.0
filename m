Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5B3F6AA931
	for <lists+stable@lfdr.de>; Sat,  4 Mar 2023 11:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbjCDKhH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Mar 2023 05:37:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCDKhH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Mar 2023 05:37:07 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F1E121952
        for <stable@vger.kernel.org>; Sat,  4 Mar 2023 02:37:06 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id az36so2977990wmb.1
        for <stable@vger.kernel.org>; Sat, 04 Mar 2023 02:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677926224;
        h=content-transfer-encoding:in-reply-to:from:cc:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XI94QcKTYHDV9rRwrzYU07qI95bCmaHU6GpMtKmAHvE=;
        b=hCfz2GDyO+3d490+BUi3aiaZ9MiCHknKJiWDj2sS2TchG91f+q75O+0X/pMEg9OCLc
         53K3Me0FxwdgreNJ0xHEMut30qLPxgESPmZv4/k8ZNEMreS2LYfirkOmZW0cRKylc37N
         ctjWe7RYsLbjI1TZfkbfvalOMgkkP7ssyh40CnAQ1Ji9+VArx0y9pIpiv25f7xYGPmLE
         IId5CiG6cY0pgjrW9mGvvrSkVkm7pkXL/3lUVauZgh8Xj1CToa0Wyn/6hUFd1kxcm0J0
         qNE2EAR9MalsyLLGVxNqybxhl+LA7uAasOU/MbxrK+8VIBiFB0JyYD5Ujmc2+w5597pn
         xYjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677926224;
        h=content-transfer-encoding:in-reply-to:from:cc:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XI94QcKTYHDV9rRwrzYU07qI95bCmaHU6GpMtKmAHvE=;
        b=PH7CWKR4HNDGX4kXjakSGVXwLfOrFuWyVVucQHmCWhUypyPiKu4/Rf9AY4sudXNX5W
         DoU4POm63P3QqGYKHDOooD9z+MSoPgLiJ+Kx9pnnVzIK0UbvT5+fyJZR3Stb1s10myZL
         aE6M4ydEr0w7DDdBOt9gsPnW3m3inLqW+UdnaYzNFLC2hiGKvzxOyqOTBP2I7vTcAIGW
         5Ilc7l0WTasgELS/GUu8C+9CA29IpYsqw5p4qLZMj5b53iM+09lkGdkXVT6QbHcaW1nT
         W/FvjwNveyWgoTOWdBu0EbJz9CF469OTUaTTHD33yN1lMQY+Jyhm3j3lMLszRbhyUiBj
         yUkw==
X-Gm-Message-State: AO0yUKX1dMpgCnuwpyKctU5PNVhVZQIG7nqxAb5vfnPOiqM2IPMFtShY
        CZF7j1za/hiDQ36ANLVKIfM=
X-Google-Smtp-Source: AK7set+CBw7zAtScDDSWHEz4m6es86QQ0kRebwxaeIjbUyyD4tFuH0n8LfJwF0nmrwdbRs2RvsMJCQ==
X-Received: by 2002:a05:600c:4f92:b0:3ea:f6c4:5f28 with SMTP id n18-20020a05600c4f9200b003eaf6c45f28mr4176013wmq.36.1677926224438;
        Sat, 04 Mar 2023 02:37:04 -0800 (PST)
Received: from [192.168.0.13] ([24.133.68.190])
        by smtp.gmail.com with ESMTPSA id s25-20020a05600c319900b003db03725e86sm4833191wmp.8.2023.03.04.02.37.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Mar 2023 02:37:03 -0800 (PST)
Message-ID: <bfc0f204-a5e0-c386-c452-eee723106c94@gmail.com>
Date:   Sat, 4 Mar 2023 13:37:01 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: Please backport e6acaf25cba1 ("firmware: coreboot: framebuffer:
 Ignore reserved pixel color bits") to stable series back in 6.1.y
To:     Salvatore Bonaccorso <carnil@debian.org>
References: <ZAMYKRtk89lBUk3b@eldamar.lan>
Content-Language: en-US
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        stable <stable@vger.kernel.org>
From:   Alper Nebi Yasak <alpernebiyasak@gmail.com>
In-Reply-To: <ZAMYKRtk89lBUk3b@eldamar.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04/03/2023 13:06, Salvatore Bonaccorso wrote:
> Hi stable maintainers,
> 
> The following bugfix was in meanwhile applied to mainline, and I would
> like to request to backport it at lest back to 6.1.y. I do not know if
> it is needed earlier as well, Alper, any input on this?

It's included in the AUTOSEL series sent yesterday for 6.1 and more. I
haven't tested with earlier versions, but the problematic check is there
since the driver was first added around 4.18.

https://lore.kernel.org/stable/?q=e6acaf25cba14661211bb72181c35dd13b24f5b3


> We will want to pick it as well to properly support ChromeOS boards,
> cf. https://salsa.debian.org/kernel-team/linux/-/merge_requests/652

(Sorry for being unresponsive there, I'm away from home for a few days.)
