Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D73E36D7019
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 00:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236616AbjDDWZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 18:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236581AbjDDWZX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 18:25:23 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13533C3F;
        Tue,  4 Apr 2023 15:25:20 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id r7-20020a17090b050700b002404be7920aso33630140pjz.5;
        Tue, 04 Apr 2023 15:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680647120; x=1683239120;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HwDt+QHR3G6KkEjiSwaa5nmxSev2Xa6CmRhkLHnTpLs=;
        b=cEUbepfW0H/pwW8jjtKj0uOANsdtOCbKdHoh3qXms/eb44MXSAEJ3VNP3Z8Tl1WBRQ
         L7IciPTH2PGoxPGwtqWjCw74aqycAE9lB0+YcAUSRS16soiUbmIH01KWxfMw4+iASZVm
         7Htl7veMh3AmciUGnBXXQBNvt/5BbJImuI9G9hrS20nmGmQWu9kw0k0iU5vqi5vuYvUM
         hdkXwbFHWK5q+IlWZnmym07KiNbNELqCHFfKFXI+LUFAFGETHHIvIB9C0OFEF2Josbal
         ycGDl6ri5RJou0SF2+Wdkwj6qJfyvLUPIi+sFtB/EdobkxZKJEFKjcO7mvdDuv85PwaL
         Lg1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680647120; x=1683239120;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HwDt+QHR3G6KkEjiSwaa5nmxSev2Xa6CmRhkLHnTpLs=;
        b=ebWNKgIV1tyMpyajI0dvS9Q8507+ux5HtP4cPqXCH9kPo2R49sa6Iu60ntHBQIWXQx
         sYhYpcre7qZ9t4KzGH/uVJNMnVZoSjkZuhzZQv9v0YBKEwL3lvuNB/jYDomU0a2FRaAL
         wk+yqVOAGIGfUEgS6eZtMe4pwWFJEvjUIL3zMicr2hZrYylHeGjgzoOtT6Z/HIqrZ2C+
         W2lEZe82iM5voNDtyPS+3pntcjoxQ3VpaheYxXhXfJkL/dYBol2KKoGxbla6nU5t/CeP
         Cz6QmWAK5U0Mex8JkVDQf7dt1VKVHfL2x49w7/HE7/kcNSJs/voj58fPtAZVgFS0K11E
         kz+w==
X-Gm-Message-State: AAQBX9ehKzFMDJA+C27p249DWPVrj6zdV7yptZ/VSg56W7LPnkEihu4l
        MQmtINwbJNHHYhzUJvI73tAv5g57JRSZ9A==
X-Google-Smtp-Source: AKy350b4Q6M9UaQYFaFPe0p1j62qT4Q9VlD4DOjzroEbTCPnQ5rxj5BldOKhCSwlQMc7lMyPV/OjpQ==
X-Received: by 2002:a17:902:e5cf:b0:19e:6eb0:a746 with SMTP id u15-20020a170902e5cf00b0019e6eb0a746mr5254799plf.26.1680647120356;
        Tue, 04 Apr 2023 15:25:20 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id jl12-20020a170903134c00b0019edb3ae415sm8838604plb.14.2023.04.04.15.25.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 15:25:19 -0700 (PDT)
Message-ID: <0106c049-9ee4-5367-11fa-79aadc5a3654@gmail.com>
Date:   Tue, 4 Apr 2023 15:25:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 6.1 000/179] 6.1.23-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230404183150.381314754@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230404183150.381314754@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/4/2023 11:32 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.23 release.
> There are 179 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Apr 2023 18:31:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.23-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
