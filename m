Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E386A128F
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 23:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjBWWHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 17:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBWWHW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 17:07:22 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764A9144B0;
        Thu, 23 Feb 2023 14:07:21 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id i10so5805584plr.9;
        Thu, 23 Feb 2023 14:07:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BZyheY4w/jC+3OShGK3OJX0UE6qFWtZ/dPR7eSYAETk=;
        b=Iv01k5+nCxWPbMEk4LTKpsRMcbuSombDKdAotP1jhNS4DXcG0SbQ6LPyBugGv43I1O
         1/hpKpDY6XI1y8g3BdIyyW7QrLGcfy2pDYdcLULsm6oYQC6BkxfSAdYuXPV2mWmAQp00
         1xqIGiFJHQ1wM5qrOaYBEETn3cM0muq02ojxZyLUHr7i1kOEvLgGbMJPq3Uuc5bU6cZ8
         7TgQUmLzmDE8lRNKo6HmiOZHzVzJqek6EtVAaql/P47oC7lwDK9uxiQsV7QTh+yCX/p0
         iaEY8osqqo5QvnGxPUkEt9z7NYwBbCtMrXp1w0abQOzhtVcDyHqtm9IZYhOcwZAjke8y
         M7KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BZyheY4w/jC+3OShGK3OJX0UE6qFWtZ/dPR7eSYAETk=;
        b=3f2YrOxQzBptu3y/kglRYuHA1MfWWV2f83YSl1TLTt4HBw5g1Xit2uG9dlDTp74si9
         uENaOOJy4oVaak884RDnFIV6tef+EUM4n2d1hy1yWNVTz68980z/WG0T4g49tyIFussG
         29z2XhO1z8RXEdb0kSriKTOC/GhcHpQIvsE5CnZZQhCfqKP03X7Oh7bAHz6HPkoSyhYU
         rbV9hFAhq6HFZukCPUhqV1vJk5QCHLqm0c+bSe2WL4w1pAAF+J+u60ky2rBoIqJK9xQU
         TC/Xwcl5ceK5pL6+BsOxxVFUPvBQ5k31HlJpwW7MBtkkKs6WEr+GKoDJYE0RpBOSjtbW
         5Bew==
X-Gm-Message-State: AO0yUKWq82Sb6LiRE5O9/qaTmjUGJ2Y47PvTDxWnKPqL7ifdzM2DLnCR
        YGXhbmX+UGgLNXnBdhe+i4w=
X-Google-Smtp-Source: AK7set9lWhL8yaXx0ayujGP7JFfb6CycmZAeaWDJGbkds31VdxUqPqbuWsqkjHfhy3m+YfacGaF3HQ==
X-Received: by 2002:a05:6a20:1587:b0:cb:f76c:ce55 with SMTP id h7-20020a056a20158700b000cbf76cce55mr6891105pzj.52.1677190040921;
        Thu, 23 Feb 2023 14:07:20 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c2-20020aa78c02000000b00593adee79efsm6149602pfd.55.2023.02.23.14.07.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 14:07:20 -0800 (PST)
Message-ID: <7aaea7d3-f55f-5fb3-c0e7-96f930c6be27@gmail.com>
Date:   Thu, 23 Feb 2023 14:07:17 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.1 00/47] 6.1.14-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230223141545.280864003@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230223141545.280864003@linuxfoundation.org>
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

On 2/23/23 06:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.14 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.14-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

