Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558944528FA
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 05:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238559AbhKPEJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 23:09:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240840AbhKPEIQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 23:08:16 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDDEEC1F6BDC
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 16:53:31 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id k1so18559484ilo.7
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 16:53:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IJxlPDTyPBy+ivM6NbsIP1P7/etUjwtMnUuEk/NmFz4=;
        b=bgtjihmji32U2GPsLIJGr/ciJjG4A7ICXoeT6BRq2fx84UQMZR8rLUN0WhQyJm+yBm
         7srArl+8BnoSPCeBmh60ENMcU1/OIhiyrQ38R3wqMYYjyDqZJFTBBDkJBdWIze3Rb49b
         phVMPrr0hTg/1Z/ofGP0dGZYe/pVVnIsXo/TI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IJxlPDTyPBy+ivM6NbsIP1P7/etUjwtMnUuEk/NmFz4=;
        b=5II7SadnNMqBTJNbkUFh1meHytZQKEU9Yr8+oF4XXmdxUnkVSrluqx1CypA/CtLgXl
         N0aEwOVRnDZ32nYFJlHIiGG0WE6jqgUcQiDLtZfoMQMpn5aIQUXOaRroBPsFga75KI6x
         Q7RdhVeWxwKHET7QK3lnstMWTxeOgjmdfnceqyizAIim2Ny1ouWx7F2Ua3e/b8gSXFRP
         OeIBKfnckrFg4x6zFyr0LGiTo7r31UeXMFCshzcHiplL/eySyPy6mqze/Iqm76aTD2+Q
         XLJTe5DdiIU4ck2zep0kL/JmoNkOq/vm1/a/l3LmiJVv4YLyQ/N6mgrWSs7tCEmHFoGQ
         BgYw==
X-Gm-Message-State: AOAM532KbF7XuKaoZSS64qIWb2XlKwWL53wyhn3KbLmpcFomiAv9jgcv
        lhEZk4Ghx/hTVt7OH1BSkeffJg==
X-Google-Smtp-Source: ABdhPJzJ1xVCDpPXzNreuWxYi+6WQBaDxUrgB5kTgDRt515BNqhluGeZRm1Q2jUWeNI7PmXSs4Kaew==
X-Received: by 2002:a05:6e02:1c2d:: with SMTP id m13mr2061536ilh.26.1637024011239;
        Mon, 15 Nov 2021 16:53:31 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id o10sm11467634ilu.49.2021.11.15.16.53.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 16:53:30 -0800 (PST)
Subject: Re: [PATCH 5.14 000/849] 5.14.19-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <d61c2a4d-944e-ac71-2aa2-5d739fe4c4d4@linuxfoundation.org>
Date:   Mon, 15 Nov 2021 17:53:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/15/21 9:51 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.19 release.
> There are 849 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Nov 2021 16:52:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
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

