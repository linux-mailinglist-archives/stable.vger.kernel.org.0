Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 154B752AC52
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 21:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235222AbiEQT65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 15:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233668AbiEQT64 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 15:58:56 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8225F522C2
        for <stable@vger.kernel.org>; Tue, 17 May 2022 12:58:55 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id j28so237946eda.13
        for <stable@vger.kernel.org>; Tue, 17 May 2022 12:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:in-reply-to:cc:from:content-transfer-encoding;
        bh=mXJ7G3pcDBgEYT231EA5HD8x5zociQQwV3WUSPIB2ds=;
        b=nSUQMuEI2xHqeSbHfwRKYzwbd1V0p7cZl2C+veGiM3JkwXor6dUmkxgzwWjVYNSNup
         WeSOovvuUb48whuk6WJPDWtvmkoby5UgOKdl6coQf3j449ENU/gKb6dAreFHN713eEm4
         nezG7t9LdDc6uWdRf9zx2uNoXl0DgiZ30dN+L0pGVjEdGp5iMaVb+5JlTawTjlmxnbWF
         mdNhlqDP6q55eaJNJa4WN/h3rcM/udibAWGzIVJctg/WYcjdGLEjl91kWTM0VZgtvmu/
         R40ZG9pc5SjxDaEk8vRjRFLeOqruGbzeNt5hL7tB3uGcX5pCCHHlIPbjYSEKo5bDPg/F
         CNIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:in-reply-to:cc:from
         :content-transfer-encoding;
        bh=mXJ7G3pcDBgEYT231EA5HD8x5zociQQwV3WUSPIB2ds=;
        b=f1X4dUAN3Z060kOYH+qi0RACr5yn70myFIeeMXl3NEbfGPrc9GMnbXR/UCMdQWkctP
         lQ71cby1lBJDfPWXBy8C6D7kaZGNBn79Loxb/pgwjQQpGaAvubGzwfEpJB0LGI8JsIdY
         ROvZ82D3gEdD5nSmF96SA/i4+UXwRG6ak8SyH4XnkhDQNXdGdJC3l7iPQbpm0g2Y+f89
         5ip/m3uxeFgzQ0Enta3GdvFkDKJ1dFGKvr7xL9EQ0kcxBdKfAxgUpVhxTKwTUqN+fcsK
         WOZcTCf6ow3kmsCHqlRCRMQalMO+6HNnX6+ZCHeigku6gLInmjLk26zzf5lo7zHgGgS0
         GVgw==
X-Gm-Message-State: AOAM5332Lbt4b0ZaZNY34nDspfU47Ic0lvzyDiQnUsEdymM5EeetkRAf
        /gH0y7Ua8OWY24XEJkjJjgU=
X-Google-Smtp-Source: ABdhPJydxHDbx8WlKZIM9n+9FS4epjFiT45egbiXxDzWwLRT845F//NOfBUeciwimzMeJoBRDgrPIg==
X-Received: by 2002:a05:6402:2c3:b0:42a:ad46:aa33 with SMTP id b3-20020a05640202c300b0042aad46aa33mr14654414edx.385.1652817534019;
        Tue, 17 May 2022 12:58:54 -0700 (PDT)
Received: from [192.168.1.110] ([178.233.88.73])
        by smtp.gmail.com with ESMTPSA id vf3-20020a170907238300b006f3ef214ddasm82974ejb.64.2022.05.17.12.58.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 May 2022 12:58:53 -0700 (PDT)
Message-ID: <fde0dc8a-a861-3c8e-1316-cfa81affc19e@gmail.com>
Date:   Tue, 17 May 2022 22:58:40 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] ASoC: ops: Fix the bounds checking in
 snd_soc_put_volsw_sx and snd_soc_put_xr_sx
Content-Language: en-US
To:     Mark Brown <broonie@kernel.org>
References: <c2163c71-2f71-9011-3966-baeab8e8dc8f@gmail.com>
 <20220517011201.23530-1-tannayir@gmail.com> <YoOdauC5Q8POpHLe@sirena.org.uk>
 <2f331adf-6f95-06c1-a366-ea81b5bf6ec2@gmail.com>
 <YoPnhDRMwoT42vS7@sirena.org.uk>
In-Reply-To: <YoPnhDRMwoT42vS7@sirena.org.uk>
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org,
        Marek Vasut <marex@denx.de>
From:   =?UTF-8?Q?Tan_Nay=c4=b1r?= <tannayir@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I've debugged the kernel again after applying the fix in
698813ba8c58 ("ASoC: ops: Fix bounds check for _sx controls")
but it didn't fix the problem.

The commit message in your fix states this:
 > For _sx controls the semantics of the max field is not the usual one, max
 > is the number of steps rather than the maximum value. This means that our
 > check in snd_soc_put_volsw_sx() needs to just check against the maximum
 > value.

For some reason, this is not the case on my end.
Both the $platform_max and $max fields are set to the maximum value
of the range that is specified inside the codec code which is -84 to 40
and not the number of steps.
This was also the reason behind my patch to the bounds check.
