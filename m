Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7933C417D4D
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 23:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343748AbhIXVzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 17:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343675AbhIXVzL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 17:55:11 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD320C061613
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 14:53:37 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id a11so656273ilk.9
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 14:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rAuuFT2Ngui/F8mas8gY5tTXnY06Q7EANEXl6cj0B68=;
        b=SL5L/Z3vmHjYVgWQU2s5Y2YQAjLIQk5k0XfScnA/CY9NdB1Yk9Bo84aLsFPoPNqA6Q
         WGAmD/eCGXrnfTjZMhPlL9iuKiN6CyO7KSmoiD5H6eDbNsGOZ7AYtxt/Cp+nBccjBa7R
         kz9l9t4zmX3QXkAoWF4RZUkuX1t/uXNMtydqg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rAuuFT2Ngui/F8mas8gY5tTXnY06Q7EANEXl6cj0B68=;
        b=SVQ6Z6tffLS4quyEbmxSAKzKHxLS0BbeMJlhoAwDZHyXXsFHPqTry9DpAL287VTKyU
         mW4KXXYSOD21a0v6IqnX8UzGXqSPRO+rqJFHCh0OoyZEGO27j2FV6vji9SqN3qSa5gXo
         2ouBp8NWkjSJuhnqaU5sRg4pqLWInaFbCGpYfOIZ9EoTV9UrjcaHZ5KhiWmQObNXC6CL
         Jhs26/dPF6kGDVKxgOIS9O8ng0Ez1qSeRKOBrcVRoz+mlEPEwHo/yjktizxZeg8ZR18D
         0XQRT9KyXGIQIF9NfFyVgs0LC9hf59oa9XpREJqzz1ZgdhNbGG5Pg8+liX240Hh5n4/n
         lTpA==
X-Gm-Message-State: AOAM533Z7AFSqAGT9hrMn86FbLNF/KD7iyN61De/l5azoIk8dWYzjHCy
        09kiatm+rzWxynK7BiA0miBvIw==
X-Google-Smtp-Source: ABdhPJzZL2NstxUmyi7tp5Osk9K7eqTZEdCLW9CzX+RgkPdEs1/7UKkafunnjMqC8UOxt8hHCrZnBg==
X-Received: by 2002:a05:6e02:13ef:: with SMTP id w15mr10206254ilj.255.1632520417366;
        Fri, 24 Sep 2021 14:53:37 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id x9sm4696677ilg.76.2021.09.24.14.53.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 14:53:37 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/26] 4.9.284-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210924124328.336953942@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a2d3d79d-c419-68a4-be42-e0cb3ae95713@linuxfoundation.org>
Date:   Fri, 24 Sep 2021 15:53:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210924124328.336953942@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/24/21 6:43 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.284 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Sep 2021 12:43:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.284-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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


