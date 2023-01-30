Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA797681971
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 19:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238269AbjA3Sic (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 13:38:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238291AbjA3SiK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 13:38:10 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0488946D5E;
        Mon, 30 Jan 2023 10:37:31 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id be8so12581968plb.7;
        Mon, 30 Jan 2023 10:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wW1tsa2Hnp3P1GWVwzdIWLM1NxPlTw0S2OAEx5AhVoU=;
        b=AQXptRLJFz9FwQXcENcl6AV6MZOehry/yk0yhw4JBihaLWNOkgBRnbKYQCWwq/amr9
         jXj4JN2Pr4z+79/5BVReJOmbHFHGcs9/5MjjG/JlNPNWCBA/bNVVLYDWFvHyPjZEoPaL
         VvJkbkSrDGL/prZSRPVfdFcjdUxeeQuP825FrHYV7FiZZB+be7rj7lmfrh4i9S9KS6n9
         MqR/eDMOX0OnRnCboBXNJUxX3NwkYgPW/hbcA52VYpDX3aQInsrxWUKUaqR+ShawnuPo
         1tIGpYxshJAFOUg5CcMCqXSOZyyGPm/E92k0Sxw5U2+0AD6CW4+eORwxhuGdhIhQ3L/6
         KYig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wW1tsa2Hnp3P1GWVwzdIWLM1NxPlTw0S2OAEx5AhVoU=;
        b=XSsdho5RrclPiSStJxEps3kL/sgn4sCKvn30m/ZQtr8HLEGR+P4yKLqFB6/8YTpfc6
         RxqbR192t3E62Ll6zTNLM6LyxsEGf/8LHoh8rj/h/awccpGL+9au9UiNDQTZ4faXQ1Ty
         0z18afEyRnVLc9BZxc5fGlPNMRalV0M6WF3lxNX5mDOAYB1C49XJvbmL61y90pDkdGCI
         IbdhkEVaUR/V3Jiepfdg9lV2FzlG7B+lQVq+NuatGEg0gD6/nDpekx+QexWDXz1sk8TL
         mrXijowWvORAcjWhyZeqw+YnB03CER61/B+uZun/Pvu2pZYHroCkXcUtMvjYTz90rDom
         ZvVw==
X-Gm-Message-State: AO0yUKXGBn8eWyzRDwMyq/KYVXqAQ8+xEVwk3djz3Ux5pLwGRN2og/RY
        qb1gupbS4BI5gD3AqH9SEGM=
X-Google-Smtp-Source: AK7set/nxjDGie9fQe5omE8Qq4tphgF+RSMeOU2xClnZVYV7qhG5A1jN28MGTSmAvLl3/jkFQ44pPQ==
X-Received: by 2002:a17:90b:1a8a:b0:22b:b3df:d970 with SMTP id ng10-20020a17090b1a8a00b0022bb3dfd970mr11020832pjb.44.1675103850407;
        Mon, 30 Jan 2023 10:37:30 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d5-20020a17090a628500b0022bbad75af6sm24743804pjj.1.2023.01.30.10.37.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 10:37:29 -0800 (PST)
Message-ID: <34681bd0-2b66-fa6b-9ba1-086fb4a66969@gmail.com>
Date:   Mon, 30 Jan 2023 10:37:27 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 000/143] 5.10.166-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230130134306.862721518@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/30/23 05:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.166 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Feb 2023 13:42:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.166-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit, build tested on BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

