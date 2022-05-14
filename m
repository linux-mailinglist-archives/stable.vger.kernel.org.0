Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54759526E68
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 09:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbiENDiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 23:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbiENDiK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 23:38:10 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30BBB2276;
        Fri, 13 May 2022 20:38:05 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id h24so3848785pgh.12;
        Fri, 13 May 2022 20:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=gm0On4lnJS/sRBa+8jwfvD+08e90uUP8y268pyYk0Kw=;
        b=C7D9g0C4/TudlmtK5Alwxe4nxrBQjaLu2T2GjRChzzptx98j299QCaPCc46hy9jzVX
         sE24h7J4TBEsPuonhisBI0zAN75ekuOkelnaIgyt2QqDluDh2++05E6/Ng0TIt2bCOa9
         rYShcYStRttTDkQOpV5zChrT0VxIePQWFvjWIkMRsj59FrZYweb6pBG30lB4p46lbtYs
         TxdCN1cAx+s/TazJsupdUJ6rm5k32bY+JMdnHC4SL3kYwiWw62bUUIRKUWVDTknwWYBx
         8bd3XcTGH/6Ymyf7sAh2nASn/7osDsEd3lcE5Xrl0WH4F6afWaSORGE5IykYkUWsRiYp
         lNjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=gm0On4lnJS/sRBa+8jwfvD+08e90uUP8y268pyYk0Kw=;
        b=uVvAEJyzO/jnF3yR2TuQN0KrZ+JPeCWM9zDLBncBS4uOwu4+pBXrdsgPw4Q365l/Y2
         qiu7Tz8bx63jHCDtEfvHZye5TGpHtk7+NRn9MVd1mKUMHC+ESTm8devOopp52Mx3L/9X
         iKsLb6gHXI/TRdPnOPyG9pqj73nr7sVpZZLfIeT9IMIICWpSmYOQcAYbCwKgOtbtopj/
         lCVWYvd8IYAfz5n6+v4UwpBRfZgKnKZjd6ZUqbWn1ZFwT69cJ47FSl0FqHkUMBrv3+Jn
         xfgJ4yoyIu3awyyU+rRituIlJcaqZhcJdozDMw2+qVPffwdgFjD4dmbo1CSDrtAP4LCc
         th9w==
X-Gm-Message-State: AOAM531ON4ShG2uQ/keVYAdXY7KR92DolHT9eAsneTvxgyw7mx4Y4K4a
        +qR+Shzn7oH70xv/OKg+JXE=
X-Google-Smtp-Source: ABdhPJyUEhaimf/tRpG4Y3TkJhbjIpFiBgMMFh7xIzxagvH5OXcBUPehicxIiuQYh01y0wjiJsajSg==
X-Received: by 2002:a63:6a42:0:b0:3b4:276c:8c3 with SMTP id f63-20020a636a42000000b003b4276c08c3mr6404484pgc.337.1652499485421;
        Fri, 13 May 2022 20:38:05 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id ca8-20020a17090af30800b001dd01a5be02sm4285852pjb.41.2022.05.13.20.38.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 May 2022 20:38:04 -0700 (PDT)
Message-ID: <0333986a-5991-f54a-8671-1df6c97e794a@gmail.com>
Date:   Fri, 13 May 2022 20:38:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.17 00/12] 5.17.8-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220513142228.651822943@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20220513142228.651822943@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/13/22 07:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.8 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
