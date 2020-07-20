Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0927D227346
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 01:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgGTXuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 19:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbgGTXuK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 19:50:10 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66BE6C0619D2
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 16:50:10 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id 18so13680332otv.6
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 16:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K6pANJbBIpZEsh1nQyh0JxNSkniZqlV6WQFGpOqrBB0=;
        b=KP8zbU3YvI+0BVknkJUveCvpB7HyaZRRRgG2NHoPNiB0In6TWi/R9UpKDhMxQzNENB
         jAXdIZic/5H9TNLXPgZs7xjLGYS+pYvuFdVPrJ29W2HEiEa4tq6wbs+QPSVea56Yz2SJ
         KhOZNjsOew49k4U2hWD7aPXD1nzbN6/41RvKA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K6pANJbBIpZEsh1nQyh0JxNSkniZqlV6WQFGpOqrBB0=;
        b=pCnDgS35EzmQ+uaB4SRtlHf8sKsePzbPZdWPRZlcp4V1mlDSmVt2FVthijSz5gcQvx
         /0vCSQ0Swi2qw/VlatErhkhYbyUeh2EJjRddQnMlew4pYnGliM2g67/+MHQ1qWaJPibu
         K4EHgyRMp/4muWwcUbq/JWwDs/VFXIu+Qqf+QQT2meUPnT9tfgy3MXsbRWUuz8N4W1Dq
         9kEAcn5OH8J4/R8Yzr7f5RZ3ipBrv2W0I4b72DbxN7RpT2SejiRpYHjM73zGYu9N880s
         r063kLKqbdmj2yl1BUmTKevBNF8NrorL76Oj6mhpQBvBoT+IulkAn/DR41VpAwvDn32o
         IfQw==
X-Gm-Message-State: AOAM5314PC5fSUT6ONH3tx2Uf3pwvBYpPOT5hJNjWbO2SKeHhRqv3Eu0
        zPhlkDBKXhM9aCV9Bjo+1YL2vg==
X-Google-Smtp-Source: ABdhPJzTk+0gVu0yhsMbxg6GE7fosczEpFrAss0oSAuZms4ImOHB7Z7U5TwfixOgc3i5YTWvYUGHFA==
X-Received: by 2002:a9d:674a:: with SMTP id w10mr20151416otm.305.1595289009715;
        Mon, 20 Jul 2020 16:50:09 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id c7sm280422otm.19.2020.07.20.16.50.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2020 16:50:09 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/86] 4.9.231-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200720152753.138974850@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <513ce41e-9a8d-f9aa-eb45-f37add7399ad@linuxfoundation.org>
Date:   Mon, 20 Jul 2020 17:50:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200720152753.138974850@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/20/20 9:35 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.231 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Jul 2020 15:27:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.231-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
