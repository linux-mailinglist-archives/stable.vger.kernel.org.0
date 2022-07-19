Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B224257A576
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 19:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237992AbiGSRfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 13:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239427AbiGSRfR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 13:35:17 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E65326FC;
        Tue, 19 Jul 2022 10:35:15 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d7so757625plr.9;
        Tue, 19 Jul 2022 10:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=IBhYJx7MOZc8UOT8af8832kyCAhuDTJxhL+CZ9cN2uQ=;
        b=TS42HtKumzHqE5bZOwU//19iTX+EaIDN4lasTjM/qA2p0f0JHQgpMEoFtqVWUdByPw
         skPmzNZ5fev+bhzFnPvXjTKOAEWtv9AfkGgwgZUyANQZUY0SFAZ+evwrZyaxsynNCXxZ
         zd1ZE2kanuSO0IF0FR+hpffFuWzdPlrnM/xCeZQMFa452TN7NTkDiSRd5tsW7ul7qxL4
         uOQYGZv8z1H7ujyYDwJ4owP1IuwzkrT+3RpjFFH7gotrVZiIREjwZKV8ne1RPnQ+Gxal
         CGtc7jF236sDHm7U2VA6FHAeJs+TmSRgK0pO6izwLBU+TK4YJy6T26ktzRYntWOOUOGA
         ctug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IBhYJx7MOZc8UOT8af8832kyCAhuDTJxhL+CZ9cN2uQ=;
        b=Gd0ZdZIiVuLITvizoIjPsK8QmVhYqQAL1sL/11DJFVffRaEZmg4qtgC3X8XM1wRXHR
         uoGg6sXzRUxXLLoCkpiylM7U3teCoI5vpJqlYy85Hb76QUAU/KaYFCbmcP5QUIR62pyb
         wTg1+4GgVw4cnLoUCxG0aurX7e/jGAEQjTESUG/J4GjtTtuCIp2PH2VE8/Q1GtdAtmnL
         zv5PCK7MqKNWAz16lxgycv8p6bbHJPNT0sKBrEAvc5gcPBI7P/W8ApVMHqbNiQJ2/w+z
         8PUtC1HnWV1LALZCBYJXjWfxJ+TH919xfnrnm6l9tZ9HJTMNPKneym3kkWSU3iqgc7Bq
         z4sQ==
X-Gm-Message-State: AJIora8++1G63+uGSM6578b0u/NSNrc2/1Mp7UhHy0dQ6mUKiOyYJKHI
        9NAZ9PC82/XSp4lxAjN+bsE=
X-Google-Smtp-Source: AGRyM1t44MFiWQ5KW3otO41MsJtQIOehmc/u77zz8xrhzjbCZois7fkyDkLYaC06u/V2ldTmBhh2GA==
X-Received: by 2002:a17:902:f68f:b0:16c:2ab9:9bdb with SMTP id l15-20020a170902f68f00b0016c2ab99bdbmr34327793plg.23.1658252114692;
        Tue, 19 Jul 2022 10:35:14 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id pg15-20020a17090b1e0f00b001ef89019352sm3133395pjb.3.2022.07.19.10.35.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jul 2022 10:35:14 -0700 (PDT)
Message-ID: <157b6c32-1646-6f7c-9429-70cec6ade3e7@gmail.com>
Date:   Tue, 19 Jul 2022 10:35:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH 4.9 00/28] 4.9.324-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220719114455.701304968@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220719114455.701304968@linuxfoundation.org>
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



On 7/19/2022 4:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.324 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.324-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels and built tested 
with BMIPS_GENERIC (bmips_stb_defconfig):

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
