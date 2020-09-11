Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C712675CC
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 00:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbgIKWU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 18:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbgIKWUy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Sep 2020 18:20:54 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EEFDC061573
        for <stable@vger.kernel.org>; Fri, 11 Sep 2020 15:20:54 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id a2so9614532otr.11
        for <stable@vger.kernel.org>; Fri, 11 Sep 2020 15:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JlSOuUP84PheRPChzmseazUp+fXQJKe9ypAXFppY72s=;
        b=IUodJOctpkhuq7ptHwiSKLo1rYUSVMIOuR2MEITfL8B2KUQ/fYLWGVsospw0WQnY1D
         2295foSiOHZnGI0/VMVEaUVScw2MPXCcM+mmiA+wn6+OXyxYpNbaMff5I2Lf9bgKueor
         L/LQe3LdzU3X9SuT8w0wNo5ttvLCxRPviHejQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JlSOuUP84PheRPChzmseazUp+fXQJKe9ypAXFppY72s=;
        b=DFAXKqYQ47BJpG8+r8A+g8qJQDtJOc6kRlbo+of6VfA8JZC6ade3KGso4s+C4o4Fxo
         PPRn+2qLVs+GelbI3ASW6MOFzmEiCXIQJTNM4m1FO8u9FtAHyWleAtIQ4csY4bMOjkXT
         Zaoi4oe8sGqnCemE9Rhgbfqn3MdAU/saSUe/TKzcFV8XTMLpy2f6048vIYgCYkTSqj/3
         A+yCBk9Uc5nD2MTwE5KewiOTeKJmKUSAs8cqxUNqpMECPyXio7z7jy+bIlF9J+zcznuk
         w012Y+YDWDyYIWVAUfOo/5V0F7Ag1p8OlaYhJjocY20ExP0LRdC1iKZMRUDVhdKPhYp3
         bR2w==
X-Gm-Message-State: AOAM532rgBUsCJcRdPMHqBubRr1nYPNJbgwT6pdzAYMVDiTnvCVqX/2g
        ZRf3wcKnO1cMJM18mJcCBAZ84hhbl/1zZw==
X-Google-Smtp-Source: ABdhPJzL4BAMCBFoVMiKiE+2s6hu4suwUbwsAFCZOjz956p2atJDZtvAonycYzS8hCb+VKciPypqvg==
X-Received: by 2002:a9d:a65:: with SMTP id 92mr2601480otg.282.1599862853828;
        Fri, 11 Sep 2020 15:20:53 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id 81sm582963otf.18.2020.09.11.15.20.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 15:20:53 -0700 (PDT)
Subject: Re: [PATCH 5.4 0/8] 5.4.65-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200911125420.580564179@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <3ea817bf-fe93-6c4f-bcc8-23a06e08c6f0@linuxfoundation.org>
Date:   Fri, 11 Sep 2020 16:20:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200911125420.580564179@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/11/20 6:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.65 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 13 Sep 2020 12:54:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.65-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
