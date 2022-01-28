Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48BF549F072
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 02:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235157AbiA1BTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 20:19:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbiA1BTN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 20:19:13 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33675C061714
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 17:19:13 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id p63so5059260iod.11
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 17:19:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FpJ041YGFzawtPEE8PWXQZqe8kPrnkBMAyOtztAhIb4=;
        b=hyS7GRnMIgdorpHp3YbAOf0THSIhl5BaSjibjEgDF7PiTyKCbQmOc7ftVhBnwJvmSs
         cb4Z0uDd1TF3gO0llJg1gCRaWfawBXvAkODXp2QZnnrZcxuosE3Wp8tc2vleB1mwbJFv
         ygLOk3fWltBe8PViIDC3OH/K/0OPA2LKKrtRg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FpJ041YGFzawtPEE8PWXQZqe8kPrnkBMAyOtztAhIb4=;
        b=kauDVWdsSqMHLCDL6ukJPVQRC5/sYfSyL3+bh8x7nyThbEKnyAKNV4YHeJWTYIY5XB
         GUyzTUKac9eNBYQ8QAMbantm7nYIcWo4cZxbxqNYqfM7dD6SCoHx7QOR/dF8XupTmPwH
         v2tIR6BJq5Z4mEobf69bPcLlIqDiGXI3+Jen7LnmVvU7Uh8D8FTBqQqL24X6nWcxeO1m
         uHqombxxR7p0ueD69EEXCxXo6Cn8hGG623EfT++88ik8N/XNpp7rb6W4j0JUecDpHidq
         eL8SuGiD+fG095fDxUQS2nUVIAygemYfTCFIgPGS1MoRGGNHfT1as4ATB8B0X/GWlhyI
         N8uA==
X-Gm-Message-State: AOAM530jcOg2Yo9P2ZusPicdnq4x/AXlt2JWFdjyA/D7w7N6XTfLEULI
        6NaIhAP4kYWTn2Z871Ndg9BnNA==
X-Google-Smtp-Source: ABdhPJwaRW0i76NqS1xHVhyTFRerrQ7EZmHCmRPxj9ywsdrOPQmkZCDGBjmOrE1jbA7+W8N4aPK/aA==
X-Received: by 2002:a02:c894:: with SMTP id m20mr3449860jao.136.1643332752686;
        Thu, 27 Jan 2022 17:19:12 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id c9sm12886358ile.38.2022.01.27.17.19.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 17:19:12 -0800 (PST)
Subject: Re: [PATCH 4.4 0/1] 4.4.301-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, Shuah Khan <skhan@linuxfoundation.org>
References: <20220127180256.347004543@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <57a3ede3-f1d7-d600-1a5a-e2b9c8766349@linuxfoundation.org>
Date:   Thu, 27 Jan 2022 18:19:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220127180256.347004543@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/27/22 11:08 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.301 release.
> There are 1 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.301-rc1.gz
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
