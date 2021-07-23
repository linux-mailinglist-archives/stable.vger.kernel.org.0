Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF143D3CDB
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 17:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235698AbhGWPNK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 11:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235701AbhGWPNF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 11:13:05 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA4CC061760
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 08:53:32 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id c7-20020a9d27870000b02904d360fbc71bso2437564otb.10
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 08:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UyEKGuYCer2kJvhDATDCaNpTpTbQhMLlxx38Fc3fJKk=;
        b=A7cifK40N4fPKoi4IZZufNm+/gT0MPn1ljws+q6fmNsfUGqcdip/Wr0VrLSGEITrTv
         2sjiGHVjShCTwT8oJtAQJw1pL34NxZmj4mJThibEhxHeSg0p553YcV0eriY9NbzWS9jC
         OkJoUco2VX0o6f/LgkfwDcNttM/lLOLPq5WLA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UyEKGuYCer2kJvhDATDCaNpTpTbQhMLlxx38Fc3fJKk=;
        b=rZCEmwmQHQwemPVRlM6rpT7+fM/UhC8JJshEsXmz24VQtvDyuLSeGWO+wilV2xUUha
         r34Su/bKb8NBJWtkVez80IMN8jtlioPPxm4BrxVsI4tHo9blcEEgNwp32gfFtVyrxqdm
         Z6gwYRwVwWpIYHDxHrjUB9j4XsLdZ40A2yQv51sNh/eLLQlec+Z5Hgzp5ljUU7Ctt54o
         kYUZRzSy7Pn1+bwWQYNhUkMeR6QNua0f8khyI8NvyGd8momxqVrLhGcYYyOWG5s+hSK0
         P1SA0eYvgiASEvFILua54wlEARxyQsXhJ879ItI8tR5J216gb1wHpvmTXPtFIy4UU2UB
         qCsg==
X-Gm-Message-State: AOAM532xwzN6pNc52nVJ2ODRGSKIDF/XqZ9jHEoSaBA5HT14nqNEhiQU
        RZxzL4z4WJ3xI+fJozO106NG+Q==
X-Google-Smtp-Source: ABdhPJxAvuBUGL3DgVcLDiosnItqrDNbcWvbny+7bfMbTcTCWkKRyvC5MEWC1qGIkn3jZTZVv7Gqlg==
X-Received: by 2002:a9d:2782:: with SMTP id c2mr3495150otb.323.1627055611698;
        Fri, 23 Jul 2021 08:53:31 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id m19sm5776817otp.55.2021.07.23.08.53.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jul 2021 08:53:31 -0700 (PDT)
Subject: Re: [PATCH 5.13 000/156] 5.13.5-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <bb8dc5a2-6f1c-fbe4-260f-3fac246a2c94@linuxfoundation.org>
Date:   Fri, 23 Jul 2021 09:53:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/22/21 10:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.5 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 24 Jul 2021 15:56:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
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
