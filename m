Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB5962392B
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 02:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbiKJBul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 20:50:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbiKJBuk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 20:50:40 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E01286C4
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 17:50:40 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id o13so360215ilc.7
        for <stable@vger.kernel.org>; Wed, 09 Nov 2022 17:50:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c/phn+ucH2E5hiYwyWGqEcynq1CJyuXRI/MGTCfo55A=;
        b=TfYZg884i8XgJmxMu0km7Lf0jW7T5OjXUFSTukx1NYoRMCMtUP8ChfOQPflNg/o47X
         ULZPg3hCVBHRH7tpXlAAThHokoJYvodSqDlaDBRctKWKjgAGBRyeJmc9cswjnN3BB3mD
         hNgZ90rezKSi2AgmwchVihmPgjk53vjqh0V+I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c/phn+ucH2E5hiYwyWGqEcynq1CJyuXRI/MGTCfo55A=;
        b=D3FHIIIn9tD7EGPMbmF01M84EzoCWMbS4soGe3xHKAw226eVvZqtgvCckjuK6/hAXr
         h6Rsnm7lvviUplLzzumzsgyDkqEYNRR/ZxEwYowkYxs7ZGPCEZ4GaawOr/YqAO5geEUz
         /8HWko90SlkqyPHAV0aDqA1MhSzfHWEeJ5U2S6dGDOrE9SRGQQ0Elt6Epj1zu3t+44OG
         hWesc16MHFtXLQJ4qudaMVdORMOcUUsXbpHsiLue2IAhkLGH7b7ZHYde5W0iYE8yX4JG
         8AO6w3blW4tch8+l9VGZphIBc+3pgihMveXd3W0lnzzjzmqF44xgnrtCvCwjfzLK9fG9
         4DXg==
X-Gm-Message-State: ACrzQf2iUrAbi3vYSP1Z8WDQEwyLBF6bCOFHvuyJpNrNIsowwIOBi9VX
        a9pHaEz6j0KbDMpoOgoAlf0IEg==
X-Google-Smtp-Source: AMsMyM56Qd8pkxkQ9+Hc0MKeAlvKU8omVvSe5nU+nKpDdXeoy3SYIPKNvgyBxg7HYfv6Igi2r4k6+w==
X-Received: by 2002:a92:c706:0:b0:300:f49f:29b2 with SMTP id a6-20020a92c706000000b00300f49f29b2mr14424142ilp.207.1668045039602;
        Wed, 09 Nov 2022 17:50:39 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id o15-20020a056602124f00b006bba42f7822sm5990373iou.52.2022.11.09.17.50.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 17:50:39 -0800 (PST)
Message-ID: <1bb739d5-4b5a-181e-b6aa-528beea8efda@linuxfoundation.org>
Date:   Wed, 9 Nov 2022 18:50:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.15 000/144] 5.15.78-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, Shuah Khan <skhan@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/8/22 06:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.78 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.78-rc1.gz
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
