Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9A360B69D
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232589AbiJXTF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233729AbiJXTFF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:05:05 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042E42250F;
        Mon, 24 Oct 2022 10:44:45 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id m6so6527487qkm.4;
        Mon, 24 Oct 2022 10:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=unDwZ00sZ6rH0gC+V3B9KQCdS9ESYoOoCdSDhEZSa1g=;
        b=bU2S2f4cGJ6F8uw/FAJGFv9XKtWGBgRxNDkzXHES3yo9uTkliQ0gBa5x9jozTJCld5
         daXZEr07YJhIVSQmtpdRjXET8y0PALuRDAC9612lX05iJbbP9qddxAXletgBnrlbPN4m
         Sc2LTkiW1hEYi0ZcR060C5YXz4vQ/DuQ1rAP0VR4zp4iwWuQDbAZFOJhQyTXTPccQtq8
         uWGhat+SZIAo/2MY/TDskbthsCMDFpmHoytGNrd8eFBhi3uJFzKE8EO3egSjH77AY36W
         NPt37yTiqWuSekSio+beyHEz1S9ckXY/o4xhn7291iHSmk40/ycCaRopgqskQ0d5nYl3
         9xpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=unDwZ00sZ6rH0gC+V3B9KQCdS9ESYoOoCdSDhEZSa1g=;
        b=GcB4/PgeRYOGxtMfnXyQhZ1ej3O5BO5ktz5Lcg0xHWrHwmr+Eg/7kjl2P5qMnVVfS3
         JCH4U7o3YyBxrTtcFJGorAYhTHo5ZSeqSWoJ0KWH5ixR4O1QD9OQ5eu5qwIC5pkbFNJP
         xjou3gYnClwAtIZTPYwKqPlkhM9Sua2yzEBVkpNHOxnIiXjF13fv+zxY0Ik71fVgqlRk
         +KX5P94ulIMJ+J0Up/hH4hRbUB8y61a9LJIt7Lc26sZxeRfRVqa75yYEtKerP2N8adQK
         29z6Mji9eRlbiKJOULyuYpEv7XKdNiz5w+ZB/o1GEMxNPjUD9I4krbfrThRZDBoTEqSY
         zY+Q==
X-Gm-Message-State: ACrzQf1adatEp+rKcUkt45BFqTLqLqXW4vvfJw8+zK8HwtOgP5HopiI9
        FQ6mf5y/5XDA49SSDl8nrco=
X-Google-Smtp-Source: AMsMyM7Anu0J0mkmKAyAJumElNE18SGBt6nfETtgJtXGiYys54lwjy/vvYVflO8qqSXLV4lfg3pw8g==
X-Received: by 2002:a37:658b:0:b0:6f6:b1d7:d7e5 with SMTP id z133-20020a37658b000000b006f6b1d7d7e5mr1699543qkb.497.1666633399469;
        Mon, 24 Oct 2022 10:43:19 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u4-20020a05620a454400b006ce2c3c48ebsm339964qkp.77.2022.10.24.10.43.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 10:43:19 -0700 (PDT)
Message-ID: <0fd92814-226b-b61d-c57d-2bb79d312594@gmail.com>
Date:   Mon, 24 Oct 2022 10:43:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.4 000/255] 5.4.220-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
References: <20221024113002.471093005@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
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

On 10/24/22 04:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.220 release.
> There are 255 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.220-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

