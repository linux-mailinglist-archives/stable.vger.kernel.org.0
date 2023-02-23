Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F82C6A13D5
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 00:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbjBWXeo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 18:34:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjBWXen (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 18:34:43 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02068158A9
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 15:34:43 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id r4so3573596ila.2
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 15:34:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1677195282;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fC3HAx/KX1++Hn1KyFP5sOc2BiMUdLCRjvywyvE7h48=;
        b=hArscE9t4XpoYYS935ux1+IND3ASYeVW3+lFUDPMG6ZTtk0wg+CUC5tspXQCQgL0Yn
         zd//MNQcLGxjDka/uWJryIGbah9zAI+4yvj/4NwOKrXYsnrzJja3NXPJc8M2bBm+iZvt
         5mdU6fjBJwWT8Z0X18C04x2aNvrsXhcK5A7SI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677195282;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fC3HAx/KX1++Hn1KyFP5sOc2BiMUdLCRjvywyvE7h48=;
        b=2Ho2hMn6Eb7ChiwAYKaqcu4sjTSOyd1fDFoqJj6syndMFONGR7xa9uiTl5VurHlxo8
         FKTzbiRwqz8awY4Mrdzkb9F5eD75sraeWW3mq7eXt5TbKeUYK/QxGOoBvn/YUPRHkzfu
         ysbCKewZRDqlS1rHIvOMKNh62uEJodBAmxxYRqeEIsdJdghtvhpoj0PssMEEFOIv5jeU
         SV3IvG4qPB6oCMoAzB2tB6hK3FD6h/iXreV7mz2ALsYlCtgWa1+QP/6difFwGHISH+Pd
         Xtu9CnM84hfFHiKBGCIUzc3FXV9u1sP8NIzKndx404Z16SUuMZNglphEN1kkbHmszLOW
         AmAg==
X-Gm-Message-State: AO0yUKXLUdCH3o7faMiH5JqLn/UHMhPosgqOo+eqkb/8LZra/3TP14uG
        nwmygevVZPDvhrgOWA4gRDNfSw==
X-Google-Smtp-Source: AK7set8V6bYTfuYKvMYxOCxrmNoO8zZ1cqup75hhs2saykEZS2M4Hu2IxGaKCdi7AMZ7uYlH6cUTCg==
X-Received: by 2002:a05:6e02:1a06:b0:315:8bf9:53d8 with SMTP id s6-20020a056e021a0600b003158bf953d8mr9253021ild.2.1677195281985;
        Thu, 23 Feb 2023 15:34:41 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id r18-20020a02c6d2000000b003adab954c5asm2173294jan.153.2023.02.23.15.34.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 15:34:41 -0800 (PST)
Message-ID: <2528fcc6-3b07-2506-6aa0-c0c4e5d61e51@linuxfoundation.org>
Date:   Thu, 23 Feb 2023 16:34:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.15 00/37] 5.15.96-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20230223141542.672463796@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230223141542.672463796@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/23/23 07:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.96 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.96-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
