Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6996B11AB
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 20:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbjCHTEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 14:04:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbjCHTED (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 14:04:03 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6776DCF9BB;
        Wed,  8 Mar 2023 11:03:33 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id 16so10219176pge.11;
        Wed, 08 Mar 2023 11:03:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678302213;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bpVeJlxzr9a+pZzvYi0QKS84eR0eQKkGn5sJ0lCFKf4=;
        b=CgPAjPUgs6c57H71wf5NngCtu8lwZ5XxSFP7kG/knf3c1DKG/8MWb4cSbBXRAVmQXp
         99BRyQI5z5lIy+zElFWvjpIQGKQe8YY5XZFwYAftvJ9dVfEtS4IP/av8pXU2VtQNq5qn
         FXxo/VKx0LdXRsXQMGsr8K8DfZixTgvg9RyJQVfRERvfiZVotCnzXLp9dVXUIEZUljtI
         nA+IT5F+IeiKea0V+/IQLcjc/bkfHs5ORNi3cL3Bs+hYtFSqC/z/5GY2T0VmeKd71zRZ
         8LzEFwlejzXdAtvyCWMy2X6EwyMGEJlOo+dx6PDwj4tbiVTwEzre+L43Nqxt3GiMHOOF
         bRVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678302213;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bpVeJlxzr9a+pZzvYi0QKS84eR0eQKkGn5sJ0lCFKf4=;
        b=yZUmM4g0Bb/8MFEdlUwcgXdiHlcEEJVob5yzN0CkmBmlzO/d61Yl2eFCo29Ow2fhiD
         BiZ6LkWiw8pAXBW3YYhmzdD6ub6rf4ouUlAjnGuOorzNvLp6RFdq3gcwVTNSZ61Uzghc
         Vz0yIkkI2zjfKZ29UhCgOI/8ryG0qO3bX3cNCPVRVg2XrWM5AWCNJ6zLcU+9WCZERrpv
         S6DKq08+y107Tz06rUl0v64PpOyukqK4nFJLENKXoK9cMRF8cpqN4NVDwx/3ZuOIz1AI
         mwlu910nHUftiaU6tX7HNzk46XeFFa1C9qjsrEGcHPQI0R7GJSyct4pbm+uB8mGnITbX
         fbwQ==
X-Gm-Message-State: AO0yUKUzaB9sKRXMyFHYK/MLtv0FjMoXkLmX/glnu3EzCVsW3If9lr2d
        Q3uHfs3zt9qhg3V8aqaUlW4W727BeHo=
X-Google-Smtp-Source: AK7set/U0j1v/yI0bLmQYxFkDRAOdx2IIZqC3tp4CvTeNaOmgIpC8hFw2x1qAFDp5q7dRZH5JWYszg==
X-Received: by 2002:aa7:9a50:0:b0:61d:e10f:4e70 with SMTP id x16-20020aa79a50000000b0061de10f4e70mr2118523pfj.0.1678302212713;
        Wed, 08 Mar 2023 11:03:32 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j14-20020a62e90e000000b005a8de0f4c76sm10045378pfh.17.2023.03.08.11.03.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 11:03:31 -0800 (PST)
Message-ID: <fa38ef6e-034f-7232-1f06-dccd565aa7cd@gmail.com>
Date:   Wed, 8 Mar 2023 11:03:29 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.15 000/570] 5.15.99-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230308091759.112425121@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230308091759.112425121@linuxfoundation.org>
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

On 3/8/23 01:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.99 release.
> There are 570 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Mar 2023 09:16:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.99-rc2.gz
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

