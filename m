Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9975964F2D3
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 21:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbiLPU5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 15:57:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiLPU5s (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 15:57:48 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D29C183AF;
        Fri, 16 Dec 2022 12:57:47 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id cg5so3657392qtb.12;
        Fri, 16 Dec 2022 12:57:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0Tq44ENuJNTwNFqV9Umj3g0CTs/gvpy1jjgL0KsglCw=;
        b=IurxWDwzhju0yBrCTyOjro6yRV+2x3oVogyEeOBs9mb9OyX3S54MsG2tXZZZzqy6Wz
         jqLIQfzxU7+P8ouz2cGWJfh8/BkI9nS7epLVMN08AcnLOrbPUT6tHk6Yg5Kb3bIL7/b+
         qr8TEBVE0xSKu8zsLYExFns/mNl8UQRTMeZlzajjzdqg533vrzT/mX+gc1VXTdCA6gNb
         SubFY4Or6E7z5CV4DgxUAD1h6Il24ZoUNf5hc8nF4yoHRlHat6Hey4Ge3+zyz35ZieBy
         4DkyuIkmE9TFfciT/bJxrSAdIgSZZBAWgM4yl5VxFDt8Y691UmaR1tkA82EcgCHzdFoi
         NjNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0Tq44ENuJNTwNFqV9Umj3g0CTs/gvpy1jjgL0KsglCw=;
        b=ReEAxs+CI1pS8o3HJfsgbtzFVWh7VIPXHOGgl9/TMdP9YhC0IxjAYqxFomoXHm4+TH
         WZiQ5T/HnOgTpcdik8bZ2ar1YhXOj5RWPXo2G7kMdaDKNLut5/7yeAm4V48S7X7Xhud2
         tYCGHNJ+e6+LgUl8b2HZcwQ1HvLy2bE+woJJGdTz8Wir8lJnYsqwvWykThGCrtOPbGNm
         RIPnB8v70klnf+Q+y90r4+E9Js8dgPOLL1UiGLhQK+fAGh8gh13WXjoC2NuKLDyGmKN/
         355zOT8AcSt873/Eh05dwzPH4/z67HdOg6/9lOpxJAuZDvrff41RrcyNG4VauJQ+cEN4
         mcmw==
X-Gm-Message-State: ANoB5pmXe+YE5HzNX8Czo7lB8ygXLLTGqZV81uV5m7REFdy0TJs4s4Fd
        H/9tBbRzW2Mqewclm2THosw=
X-Google-Smtp-Source: AA0mqf547f2Hu4M5uur7kbkgW7Yfu1GZG7SjCWDfA5Y3kln7IVH82UEcT0Y+FDNOxl2JPHC1jFYVAQ==
X-Received: by 2002:a05:622a:5149:b0:3a5:5f3d:f866 with SMTP id ew9-20020a05622a514900b003a55f3df866mr48127319qtb.42.1671224266631;
        Fri, 16 Dec 2022 12:57:46 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b4-20020ac86bc4000000b0039a610a04b1sm1899334qtt.37.2022.12.16.12.57.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 12:57:46 -0800 (PST)
Message-ID: <c8509fb4-6e09-cb1f-c49a-dc1e4473beea@gmail.com>
Date:   Fri, 16 Dec 2022 12:57:41 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.0 00/16] 6.0.14-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221215172908.162858817@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221215172908.162858817@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/15/22 10:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.14 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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

