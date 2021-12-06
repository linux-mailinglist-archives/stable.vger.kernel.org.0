Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9B346AB19
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353383AbhLFWA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 17:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344022AbhLFWAN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 17:00:13 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D51AC061D7F
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 13:56:37 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id b187so14646522iof.11
        for <stable@vger.kernel.org>; Mon, 06 Dec 2021 13:56:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+Vm//Lx+aIdsjZjxdzSTkuvn/DNh9S7l1rAsKe3E6ls=;
        b=f1QyWYSDzBRjOoEoyzWcXtKcu8KkLxL72AK72LWueqrYQSTGzOQUI+XywzsOQPGJzy
         1ycTR+ubVXegKN/jiEPiOFvuNQ/T95GYF3jKKac8LtLVn/7KwoUaizZmwpCItPGHazeo
         22FZcj8B9ywrPu2kkwGzJw7XPoJLjV0/z/elI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+Vm//Lx+aIdsjZjxdzSTkuvn/DNh9S7l1rAsKe3E6ls=;
        b=Rj6OJwAUfLUlfrHGhStq20X/6Wn3EY3YI7ghovI7NxpMlLKouHeEZ5lBEg/z4ov8ND
         E8k7KG/WhXEcJA/nn16T/YyXRPZGGcWmOTeqb73JfcujlP9wohUtXTHrAie64Ud5RJLq
         cGXkZNN4aAQK+E6LwkMueS6tVBPlGESvZBXEFYGW9uZtZCKDBZFeSmRj8Y+bfhw+4sEV
         3TDC72Wo1SbKbNOaGRERet5Zwo5Zu6Jf4rGkbt4vefJKznBqSiBa6W4eAl7qPRLJU610
         IiVQF2+EM9r1qbXvbHzo0fBl+7w9AZ5PAAW1EYMsQeBV0Z4afFqKdL/0NXQ2ZCBwS/pF
         qcYA==
X-Gm-Message-State: AOAM530jFnFRHF/oZD+npGwu9nN6Vc6Wfe6Cx3Hqz54Yeh/PZWt2Vsu9
        zIJP9+z3PQZgp5vWEr3/b9Mcxg==
X-Google-Smtp-Source: ABdhPJzv5w98Lt9Awh7vKEMSY5nTg6mhQ9Ru/pUuoqN0XFHS+EKfF9WV2iRgIkbhq09Tz02wgzukZg==
X-Received: by 2002:a05:6638:1481:: with SMTP id j1mr46577571jak.59.1638827796738;
        Mon, 06 Dec 2021 13:56:36 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id d2sm7751695ilv.73.2021.12.06.13.56.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Dec 2021 13:56:36 -0800 (PST)
Subject: Re: [PATCH 5.10 000/130] 5.10.84-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <9f23a0eb-969e-3d9b-56e0-ac0a272525fd@linuxfoundation.org>
Date:   Mon, 6 Dec 2021 14:56:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/6/21 7:55 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.84 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.84-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
