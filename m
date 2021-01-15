Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCFCD2F874D
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 22:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725781AbhAOVOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 16:14:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbhAOVOi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 16:14:38 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C34C0613D3
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 13:13:57 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id o11so9930847ote.4
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 13:13:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2yS+/mPCIhMqui9syG37qyuAui4P2Wj3yJ3qSWKhmpg=;
        b=Ss2edRKTV6ENACuZ0SzgIE91XETZDvgmQ7apPjcJVdFRl6mqHdTU1yFWmsWP7Bcfk6
         PzXJoBAIPXjGPEzb4FcmZ0XLsXJxofOPEySLTwxrMYg2EBQtszJnFv362gdgWeocXMMz
         uyAEj/CbWSKqGCPLrLNGTwid5wPKCYDUd+FhU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2yS+/mPCIhMqui9syG37qyuAui4P2Wj3yJ3qSWKhmpg=;
        b=sctteRe7Od6kUtNYdLktVBI4NF15csaqjNPGnRlSg0R57Zc/Hofwl8GoWMn9eFB94L
         qc1QfPcdNeF5qeoEP0oQpWRXgZj9QAmNxVje1kjByw1tY+Qx7nsHSxiX9KBI09YkA8GY
         BBc0Rd3eW7UStN3byJY9SZFcmvJvejYKGA4bP8pAOqgtjxHfnpYoaRInR608+7377vjF
         M8GZ7RPsQdOe5/z1tgxVXvDcN3IZJB/qkR4GAIcKvQ9JY/Kvevol/Az1BOjvQnzRZLeY
         wwxJjIgjEzbMJbNTYsfCwcxwMgkwuYd3bYyDopKsf3kAmVPi0YI7pKFgym3aiS0/cd+g
         SdBw==
X-Gm-Message-State: AOAM530Ea6sZc74HU/GX5twQBVfQLMvQ3hoJtlbJCovtg59Vo1mSw52O
        XsN6xy4rxekOq31yLzO5Nke7aD4aEeMnjA==
X-Google-Smtp-Source: ABdhPJxWmt1jJRJOvhUe7JK/UEFonxtjfSwIaYLZL7NjB7SCwG9r2IkSrIKs/As9RLeAflnpHzLrDg==
X-Received: by 2002:a05:6830:19da:: with SMTP id p26mr9481121otp.80.1610745237254;
        Fri, 15 Jan 2021 13:13:57 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id c14sm2042681otp.19.2021.01.15.13.13.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jan 2021 13:13:56 -0800 (PST)
Subject: Re: [PATCH 5.4 00/62] 5.4.90-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210115121958.391610178@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <3b993bdb-965a-5474-151f-cad765f8de3d@linuxfoundation.org>
Date:   Fri, 15 Jan 2021 14:13:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210115121958.391610178@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/15/21 5:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.90 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Jan 2021 12:19:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.90-rc1.gz
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
