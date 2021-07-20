Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0593CF0DE
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 02:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347863AbhGTADB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 20:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244666AbhGSXu0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 19:50:26 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0AEC0613A8
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 17:29:05 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id a132so11913839oib.6
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 17:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K9hlFT7XN9rDzlqLkCTqQZQKsdldq2qTv8vpb0ZPDu0=;
        b=AyFR+DDdy/gDS1GogjMjC80sHdqWbTJqltHhCtcircYskN67OB+OWTKJ3SS+h8xUYD
         w2QXoTF5CA4/CU0d1lECQLxNbJFGCNbAs3SKGWCbBZ//MnCeUtuatvzVOOdamXtOIkF3
         UQ4r34gQLU2RZwoefsMp0PhHRUTLk7b+kqH4E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K9hlFT7XN9rDzlqLkCTqQZQKsdldq2qTv8vpb0ZPDu0=;
        b=NSjTYvDy28cieco34GJDwhxFkkSD0nULWHdpWvf2b+35pKIJotmwQtE6JqWXvyaYaS
         SUmp4+UuINyUPlQWMRwkp+87Vfp7R1aszGQ4kyBEuhuLt/x4ZMkrotU1096llS7mlnjB
         xFvI6ILC9S2wrDQnxqNQnOZQU5brYQMEoGUu9xuDVxAP8kf9b2JJbaad0c1CqauQqNOM
         /tmbMBJSH9KJ57bAtCspAoOWG2L3H2yaPbeaSoZynZCUzz1PdLsYxPLzA/wF4poIme4j
         eUku1VPiBQkAUVZ8MfWBtKf/e4++tLofuAya+L7Kp5wSorL6Y2HcFedDgPyFpHzgwtKZ
         vHDg==
X-Gm-Message-State: AOAM530jbrGCowJrC9O4cDzJnlnKqAugbNj5tm3h/sBwqY+N/sydNnxZ
        n/lbs8ee04DoG2xq1+lsduGvkA==
X-Google-Smtp-Source: ABdhPJx5cZCdQiqJiAaL6oqJ8M/Y7oeIq5EEANev3JMcHM5BnJSoC41yixG8KwGrHh32UO/8dqnZow==
X-Received: by 2002:a54:4515:: with SMTP id l21mr3322848oil.54.1626740944502;
        Mon, 19 Jul 2021 17:29:04 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id r1sm3646738ooi.21.2021.07.19.17.29.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jul 2021 17:29:04 -0700 (PDT)
Subject: Re: [PATCH 5.12 000/289] 5.12.19-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210719183557.768945788@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <9a549bf3-c522-8a18-6c41-5b1dbd85e221@linuxfoundation.org>
Date:   Mon, 19 Jul 2021 18:29:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210719183557.768945788@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/19/21 12:36 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.19 release.
> There are 289 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 18:35:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.19-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
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

