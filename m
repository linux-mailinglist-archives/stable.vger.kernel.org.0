Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1D749AA06
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323972AbiAYDaE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:30:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3415626AbiAYBua (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 20:50:30 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B299C0617A3
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 17:50:30 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id x3so857687ilm.3
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 17:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3jhBRWHQNamXlYPBdc1CFvgeSD0QFYLzzXCmb4u+ou4=;
        b=EZwSloF2BAaFAFMhHRnns0PNwj1fvX1d5iNioOXIkIS2PKPfhQNq6uWRrYA+ljEeYb
         b5wqZ35/8xQPb9rbPwJS1wnUHnOLFT/ib+If5bHOh7lW7ebuPqxkkZo2AjCW8gftuoP8
         odlmeTzB7rJdydQulOlq2i7rEFyfuNNdckpZw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3jhBRWHQNamXlYPBdc1CFvgeSD0QFYLzzXCmb4u+ou4=;
        b=1Rkztf/MLrkIEtcWyr1a68VXCYxwD4x2z5fg11Kr1KpaqepWfR2a1IciVux+4ohtth
         o0IZ/vvwU9RdjTXJ1FJ9JPaCFGQG+Lv3764KgQIijTnDMltP/oBVbLd5v0Meq3kAZQ4B
         NjDNNEgBdyu092j3xQe/jdq2vRQ9CtQ2/rZDauxsQVsjcq/U6n7Ur6VBXK9zicEPvUj2
         bQjVkXlIPsotHEC8Z0k8vMfQzegofSRTSDmyZp5670yxMAYY+6Z8tM4vL3czsGPl+NT4
         wvtB7ftrv2O24c64sfuELt9/FPyxlw8LRWJlzfgHlwl1lvWMhYDv/l71B3V82JTdV6kX
         LEWA==
X-Gm-Message-State: AOAM532dueL1VlymWrjJp45ALjSBQF2YOrsPSxy9fg/x04MSWlSgDgPc
        3c/pAFWk03m/unWc6ZppsVIhGQ==
X-Google-Smtp-Source: ABdhPJx/b7XlfMk7FyQXR15E7kG7OCe8QrefLQNKdqFZVkBL1QEWC5REENh6IeYSiFL/mXSUfM85cA==
X-Received: by 2002:a05:6e02:15c5:: with SMTP id q5mr10570389ilu.218.1643075429510;
        Mon, 24 Jan 2022 17:50:29 -0800 (PST)
Received: from ?IPv6:2601:282:8200:4c:b48b:eb27:e282:37fe? ([2601:282:8200:4c:b48b:eb27:e282:37fe])
        by smtp.gmail.com with ESMTPSA id p11sm7838255iov.38.2022.01.24.17.50.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 17:50:29 -0800 (PST)
Subject: Re: [PATCH 4.19 000/239] 4.19.226-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <5021ad87-6aa8-049c-7b59-42cb5f1306c6@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 18:50:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/24/22 11:40 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.226 release.
> There are 239 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.226-rc1.gz
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
