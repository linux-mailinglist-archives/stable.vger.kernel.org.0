Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7583CF0E7
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 02:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237937AbhGTADX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 20:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349219AbhGSXwY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 19:52:24 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DFE8C061574
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 17:33:02 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id b24-20020a9d60d80000b02904d14e47202cso2649100otk.4
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 17:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4cied0e7SWPRlTwXlatMsADeUvpwx3t61EYsWi64Us0=;
        b=L8ycv7aXHkVjrfuYF25WVzpZnJtGGl+At24aolHZbcmW1EzjCuoBhiYPugTIQb5IJY
         IGTxF10ozs5Lt5E7wlCNgUqWyI/oe1Fq52x7HiwretLG9aVEIzfk2RYd4XB9p5uiQ6en
         DB/iVB2OUL0QSsQoyrDSSLX+3Zwo9U1BTqDRg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4cied0e7SWPRlTwXlatMsADeUvpwx3t61EYsWi64Us0=;
        b=hzAOTsJOmwd2Co2L1Srkc6XhpmJOgNjlEXhKtAPmfnkxtCRlT+7oZixGbx876ApW54
         CDNFm7ex82omtJ7/DWOIZucuLwUiK+9AbBFo8bJDMZdEOfQRde9SD6k/amBvg+XFhDPD
         IGrn7TA7HsZF6LhNZS6v0dOEhmcWsgvBcVeLIlyX6vGmoSGQcZY1y1pa3ymVwL0VPnAk
         3vsua3SLgvDABk22quPiT8fZpo6ZpB36aIs1RaQg2S7nG+3OoSfsQJTu2nJUW9ywWh0a
         0OQ95Pmkd7ZO2JVhy8wbjNfgcNxF5UbrVaQ0xMQZPT5LgHv1LhrHq0/Q6rGhjG+auzaq
         btqA==
X-Gm-Message-State: AOAM53133NbpP7Y9XpfStXa33li/JnVvsfe6EVogxm3G7XrR47F+XdnK
        J6a6uUnXvoMdJJ2stz2nVHxDpA==
X-Google-Smtp-Source: ABdhPJzWLAplRkuJlG9zgG8nsg+/8hbutrHOINMxFWUw7ZEThhdChfa9Uo/VYsckYLoy+eBazITLIg==
X-Received: by 2002:a05:6830:19cd:: with SMTP id p13mr19770896otp.362.1626741181805;
        Mon, 19 Jul 2021 17:33:01 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id d81sm2874980oob.13.2021.07.19.17.33.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jul 2021 17:33:01 -0700 (PDT)
Subject: Re: [PATCH 4.4 000/188] 4.4.276-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <3cb4816e-9b09-1df7-bb50-42eedb1770dc@linuxfoundation.org>
Date:   Mon, 19 Jul 2021 18:33:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/19/21 8:49 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.276 release.
> There are 188 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 14:47:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.276-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
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
