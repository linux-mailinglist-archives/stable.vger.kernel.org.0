Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0AD6CF17E
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 19:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjC2RzG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 13:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjC2RzF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 13:55:05 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BBE6A6;
        Wed, 29 Mar 2023 10:55:04 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id z19so15714634plo.2;
        Wed, 29 Mar 2023 10:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680112503; x=1682704503;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nFMskmbDwPlyi0rZMeVPTGVdXdnjVvoj5ddZvdjzimg=;
        b=M0oRUUq3AEXq9SjE4Tww/aJLDdp4yDXUCOOuy9Tp4jTCX9DQw0oByObXolZ2A3c4hp
         qLXpUdZs7hYIqsghvbuZiVhDkkf/EGw815TZl38xuyplkMu0sXKjJKRMqq/Yw4/TJoen
         mCVemyoH61OHEUgohv3tKTO0En0hUmS/bn7k+2mCnAUeRkX2RdqdH5/3FxzuZMlWpaA/
         8XFNjSK1Iq2mPNqY3CZ+pazPcCFM1hRG9hUaPKbEUf/QYWKaNdPqUDxlyZgYpsI6v1/C
         8eOSHYeSu1qNOIyiGiWfRzyql0uQUASdD9OAygLFmy+EklLQo+2D60VHyXv7HwWrCoLr
         44eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680112503; x=1682704503;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nFMskmbDwPlyi0rZMeVPTGVdXdnjVvoj5ddZvdjzimg=;
        b=WOgdIG/ukoirQnLtPwK9WCjmeW3U69CcLCv55ooYdSjfSlGSSONTPZU61Pr7akszeV
         OFh6TZk2Lp7r8+cgJqfwz8oNkBiwsULKi34sMfWfhDvFVH16I7nRih5hs1L7PenZKoVX
         qQLBea3kgUYXhTTHcGH4CSZAT5YqFlrblE7J1IxYCkQoYsJgKj1TPjzbhf/TU2kJeBFG
         znzvFjP9HXmrE5AVGwIOYldlO9jVr5gRFiGCf694JoQ5YO2gr9xrewD9d8GTF4yT8Zfz
         neU160AjD2f5eZmxZsiVEgua76WU+OpgueBOzmL0VLB/0g1GAR5r+B+txSwsGIVRkfJ9
         e1vw==
X-Gm-Message-State: AO0yUKW0BwKtig+a/ucGQiGKaoaPsh7QliTgJ0to0YdtaJwWIEA4qkTI
        WoJWv6PBV8awfGPl0aAMuWU=
X-Google-Smtp-Source: AK7set8Y6YQ8WF/DlbZ0mclLLM8Wb2iN3vrmxB6+UI99d2kpfyLc27k3rfTfXobkoiYzONoLMI3ohQ==
X-Received: by 2002:a05:6a20:be10:b0:d8:cb1a:f4e5 with SMTP id ge16-20020a056a20be1000b000d8cb1af4e5mr18322789pzb.23.1680112503609;
        Wed, 29 Mar 2023 10:55:03 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j11-20020a62e90b000000b005825b8e0540sm5682278pfh.204.2023.03.29.10.55.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Mar 2023 10:55:02 -0700 (PDT)
Message-ID: <6c54bcdc-b65b-1738-4d99-51b5d98e996c@gmail.com>
Date:   Wed, 29 Mar 2023 10:55:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 6.2 000/240] 6.2.9-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230328142619.643313678@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/28/23 07:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.9 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Mar 2023 14:25:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
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

