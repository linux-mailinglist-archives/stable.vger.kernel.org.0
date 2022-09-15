Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D41045B92A5
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 04:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiIOC0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 22:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbiIOC0F (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 22:26:05 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DBC689CD4;
        Wed, 14 Sep 2022 19:26:04 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id cj27so454850qtb.7;
        Wed, 14 Sep 2022 19:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date;
        bh=oeaUN1Ewy8hgSfM5JJHwaQ/SAVuKwJoTHfVWUPT4pa0=;
        b=IgsjDOLO1mjY/Hk/H1QtTPnLrLlWlMCxdt9XEohRRbq60DI5JEBU46mQnYQuz68kID
         2oMsC6H11wa8UJr5BOhyAC6oER+A2gH8pemnm7tZ0qbqKaAiNryOjnCa4s3yZtQXbNjk
         Acm0tf43083j65wPQ5c4uGkJf6hKZnax3tRK0HEQDmjUjdzQfHgLdZAiv3hCWOE+NuF9
         D1lZYMFm5XR20BtgOrDznxRi4Opjh3Ex/GKm3n3MEIH6sserdJgYj7YeMC2F5NGO2UDY
         k5qP/pdVzPpVbWRiUlmQEqnKLWnBOFL1hVhqd2lmu0vX2NKlBdiRc37SKsu4JaEUnstm
         LMcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=oeaUN1Ewy8hgSfM5JJHwaQ/SAVuKwJoTHfVWUPT4pa0=;
        b=o06cxBRugmoMWENizRmsJ8qCxaZhPa0wz9+KEOO00UCSTrHEZmjmPXTbqburljjzEj
         svbsSp1pF7nTWSpF3NzJE7TYhp3z8+F3oMEd/9FuK866qfVaZrZZ4i2RTmWZMTDuv6sa
         dc8WZY/YGJNlAhjRMStW1YEtd1Ugo9H71Df0pOGbVHZHNe7VPXykgoQVAUYhTeQ82UeP
         vC37OUNUo4e2s8jbieRL0NimiqfzvqzdWuv6hUOEja/YEwNuKYru2N1Rj+LoJOjpQXBC
         2BgUoSRV/1OwrRPSEYv+DyUuQQ7985vKzg1Vte1zRsnQOeCVG5BEWfMIfkTdumpJYMNF
         s5VQ==
X-Gm-Message-State: ACgBeo1r1WX4FQMI6WKwJpp5VKDaURSQ63GtKQjDS9GY5m5/xeuyp0CU
        +HEKFzEE9lKGPjVGgtDLNsM=
X-Google-Smtp-Source: AA6agR5SG0bPeFL0h3jY2AVvOzd2zg/M4o7onhb+LIdMvSDrp0Wq9bRfBJ+djG7YNjg4LH+Tvyk7Rg==
X-Received: by 2002:a05:622a:1a84:b0:344:676d:77f4 with SMTP id s4-20020a05622a1a8400b00344676d77f4mr35300127qtc.434.1663208763205;
        Wed, 14 Sep 2022 19:26:03 -0700 (PDT)
Received: from [192.168.1.102] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id l11-20020ac8148b000000b0035a691cec8esm2533301qtj.29.2022.09.14.19.26.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Sep 2022 19:26:02 -0700 (PDT)
Message-ID: <f11e78ae-bb40-3943-f9c7-374c9a970884@gmail.com>
Date:   Wed, 14 Sep 2022 19:26:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.15 000/121] 5.15.68-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220913140357.323297659@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/13/22 07:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.68 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.68-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
