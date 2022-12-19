Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7E36516DA
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 00:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiLSXz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 18:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiLSXz1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 18:55:27 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB8D1055A;
        Mon, 19 Dec 2022 15:55:26 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id z8-20020a17090abd8800b00219ed30ce47so14769549pjr.3;
        Mon, 19 Dec 2022 15:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ewrt7Tu2dG2I0FDKOllwvcmNmcWnML9QPNK8CLYeRiM=;
        b=HQ4EnrT/s4nPHdWsFql5skdCrRXLk+L9dEu9OCOo2s5nq3JyYMRL82gh07objuJFUh
         suP333QZs/R69wyT2xmOMR6daoN3MbLuH3AGKrS2Xw05ZOI9OY77fOJO361p5Sq2R3uz
         urLQvJh+IckaOkmPvPTqjFxvUxijvHo2kWaMllRfCfLtf2Acam5xpJV4j65eMvmOo0rF
         RHUcqDc35LcdPZ/DJBIFLHGZPnIZiGyu73E6nlOZOljfjsIzs9JnFoHHxhwYKZ25xFtm
         A+or1LrEzvk9HcqT3p1cuAEZ+2I95zywp4xTP5waw/VFdB3ax0viEPUExD74FK+HGtwt
         /YVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ewrt7Tu2dG2I0FDKOllwvcmNmcWnML9QPNK8CLYeRiM=;
        b=eMoUXmF0leM4gOfRPyY0c/nOkVgTuxWER76sCTb+QX85EpHGDCkhHy2LIEjWePiaP5
         0PgkOPYWhrpigv0IehOgqVD0Tp5lVpwYD5lhafpZCQ2VUGbe+PJq4jMr7PmBw8up7zD9
         VXqHGjhV7BH8OrvncuAk4nAZIZtaNBhfWcd3215wE8/xeBWV02b/00GxWWztv/8jU28p
         13b4OGZ2YhnxONE2BrzQvOT0G/u+4IyyHmIgyH/cC1H7B9DyDDjOhQs7xnP6jGMflGTC
         it7srQRI5pq9Q2NJkL4OeIBQ57OMrnXVkACWaLRhcwcKaiJrgHlnqwkVB5dlQUDnNCgC
         iWAg==
X-Gm-Message-State: AFqh2ko05DAWX7Ui5AmXunv3ZTAv4REFrAqEaLKqfBIEe4rnfIWVea7R
        ADS99CzKum6MdhFUjIthIkWFC4iLgEmE1A==
X-Google-Smtp-Source: AMrXdXvhmocJXGxcf5d36b77n0hJTZQQff5bxeTe0wN+6jnURk82dg1oAL65YPAlzlcuSJqhiW7eyw==
X-Received: by 2002:a05:6a21:3a43:b0:b0:1e9b:e932 with SMTP id zu3-20020a056a213a4300b000b01e9be932mr10533668pzb.40.1671494126062;
        Mon, 19 Dec 2022 15:55:26 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x35-20020a17090a38a600b0021896fa945asm9840431pjb.15.2022.12.19.15.55.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Dec 2022 15:55:25 -0800 (PST)
Message-ID: <bbc2f1de-0fc1-27b1-3d3f-3f0b87017046@gmail.com>
Date:   Mon, 19 Dec 2022 15:55:22 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.0 00/28] 6.0.15-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221219182944.179389009@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221219182944.179389009@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/19/22 11:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.15 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.15-rc1.gz
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

