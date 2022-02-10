Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10BB94B0242
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 02:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbiBJB3l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 20:29:41 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:59578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232476AbiBJB3l (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 20:29:41 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746FCBA6
        for <stable@vger.kernel.org>; Wed,  9 Feb 2022 17:29:43 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id i186so7599044pfe.0
        for <stable@vger.kernel.org>; Wed, 09 Feb 2022 17:29:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cdxLMgsmmoWwNr6QfX9BlZQEHtbyyDeBFlgL8Ttf6Ko=;
        b=N3Jh70Kzppxzw5ToFBbrHwsdpEYL7Ulz422DOUp85ChwME4TCxIutPfGQ4F5q67Tpl
         yjr0s3JQDx/sZk9JI3B90NAVBQTjDDmlUeHsUf1t2+VIMHEas29Vj/WnDw4V0u2+AZr4
         eTCpZw7W4nUyjncOMMZkouKFIlqqJN8EuUkaY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cdxLMgsmmoWwNr6QfX9BlZQEHtbyyDeBFlgL8Ttf6Ko=;
        b=FWkZ72AvmpIM9PWGNO3avluWl0eamjrjUzBEROBL4hBoCBL3uDcG7BqaMNEj+FWWvp
         gHxoAmTbh7zh8JJsuj8xuZlv/NXCk5t6QCKpohak/7bt+tVf0KY3Z/DjYFzXyrOblqpL
         nzXZ7ouGePwPB05eQpvFf+dCu2tKDvl0EsQyhTEX2vpTh8aDYMq+4vwEjEIFb7TJYpY1
         dPq+hu9Fjz1AUcW/HqpAdVPkynmMJmBlgdtZ9YByq5mWtEn6gZHhunQAW86NFR/to9WL
         UI4iNrUVBxAOTxjOyBwNSRr3w4LdsDvq4HV9hju8h3pFzn6Ov0iHtsZYdhnhNYxJDyh/
         eK7Q==
X-Gm-Message-State: AOAM530njV77ElY5FaxoNWYjXTVuthRecJhchhEUlaR7flfZlft+W0i5
        IBPBmDftgyhqggvrwBUSw2NW9lOo5yCSMA==
X-Google-Smtp-Source: ABdhPJxodiyAREzkXOkvY/SMzh82G1BjPwhNRwtVULqYbCK8pb81TiorkVba9Cl+gCSEui2k7UzWhw==
X-Received: by 2002:a5e:8509:: with SMTP id i9mr2520057ioj.28.1644454750744;
        Wed, 09 Feb 2022 16:59:10 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id y7sm4092385ila.7.2022.02.09.16.59.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 16:59:10 -0800 (PST)
Subject: Re: [PATCH 5.4 0/1] 5.4.179-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220209191248.688351316@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <401c0a7a-9af9-e871-32a0-0688e684c0b6@linuxfoundation.org>
Date:   Wed, 9 Feb 2022 17:59:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220209191248.688351316@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/9/22 12:14 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.179 release.
> There are 1 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.179-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
