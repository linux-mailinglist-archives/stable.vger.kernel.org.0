Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91161422FE6
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 20:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234701AbhJESZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 14:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232869AbhJESZW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 14:25:22 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B72C06174E
        for <stable@vger.kernel.org>; Tue,  5 Oct 2021 11:23:32 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id y17so316285ilb.9
        for <stable@vger.kernel.org>; Tue, 05 Oct 2021 11:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=na80cm/xXJaN3w1jwQi8PxEvi7ju29iCsJLHTVI1DjE=;
        b=BgVSEVGuKQ2B0AWjc5WdAtRV4yzgf0DlZxJBPXniLeQngvmNYg+5Ef1G9/1peo1AjQ
         ucKTBMJY9t779crpoVHD2Nm9dMbkYjcDyOYLkXazIY9iSj7MvfOnejPMaMiiTBuqr2At
         CoaeF3fPyjXqpayvjaQXGWLG2Bmq4B1ex/KGI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=na80cm/xXJaN3w1jwQi8PxEvi7ju29iCsJLHTVI1DjE=;
        b=kr7G0hw0EjEXO/fwUWUwntJaJvnLW+9o+wwZqnk/XBt4qdXPqg+LwJ1uSeeUI7IU8S
         KtnzssraQtCbZQdevQr3jFTUQTUZ8Ojr1eKpLa9VR6ZVgEZXGwhWsvg87D035W/nt8DH
         BB18llYAi6llYxkZ9K54nKRqhnmxXIjvi36i/ewqypQEvkIaweQTuFUlQzr5yCSmbYVq
         y7If4lBujsMC1xqWAi6er9jFY7kok1eJi9L8igp0Xk0Bo7gvOQr23N64eiyfy9JWxbBx
         +6pgQ83LzPxBnAq48UErWPkUUAl2sH/DCXJALZlNjH4wEUrQBbhttoEdYlVWKFQfzwme
         MnXA==
X-Gm-Message-State: AOAM531gqiAclD8f74pdqZ5W3L6BzKaQ3kKoY7q/uU0v1BPvf83pd0ww
        L65SJWTQlqSuBvNbc0stpYmbbNwz+SPzjw==
X-Google-Smtp-Source: ABdhPJy39xzp+WWHqdQxowHBz6hv9Uf+zM8FDOfU9Oz8lyxp0+lQ1aY/cyW5GNMs+EYoJ+xpO3zrgQ==
X-Received: by 2002:a05:6e02:8ad:: with SMTP id a13mr4405577ilt.136.1633458211342;
        Tue, 05 Oct 2021 11:23:31 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id c11sm11127583ile.22.2021.10.05.11.23.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 11:23:31 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/95] 4.19.209-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211005083300.523409586@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <07b44a7e-b488-801f-025e-c875e8ebe3eb@linuxfoundation.org>
Date:   Tue, 5 Oct 2021 12:23:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211005083300.523409586@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/5/21 2:38 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.209 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.209-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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

