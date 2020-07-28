Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E85722FEE8
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 03:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgG1BbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 21:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbgG1BbX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 21:31:23 -0400
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA092C0619D2
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 18:31:23 -0700 (PDT)
Received: by mail-oo1-xc42.google.com with SMTP id s190so3508035ooa.13
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 18:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=85PU/jeMBPu5Upo6UlF9JkPgAyG/TgNDI2puYp9FnuM=;
        b=RfG/PYmyP3MrH8UgvY59xXT43rK8K6jxBfyj3ny8PFYkBkhY9QibvYkB6zi7MRm88C
         UvBlHM5OiF9Q1JBxtVpkHFWf01zVjdcZ12B2MNSz9rfP5shebjPn315qhA02U79Hunuv
         cQeC2p6EwohTKWu+CFLf2+BTz+tPLYjtKgT1M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=85PU/jeMBPu5Upo6UlF9JkPgAyG/TgNDI2puYp9FnuM=;
        b=qdVMcWqtpM0R90h31RZ6o1E53xuMnXA2mKRrEPK4y02gu968hAv2lTiXvoYArD2GEK
         NBmGh4k9hw2PMACrPowHnLR83U1eGXj7ZPp3QMFBPKmb9vYmxCYcQ1XoawBYIvox2S3+
         xrJ7mb1YbEQPDvQgTWPrbQQHctiu0R5lHJ3vvFCj+yx43Q4A/lOcd39CDJ3nj5gyXP9P
         MD+MO15SzHG0eL0iX6798/zoCZSQxUqQ+wWRQEmnZdNIKUIBnsJQ9hkf7aRCXC6VB6RV
         XdUk7FjMGtfdSvFGIkyfRynafQ5rZoNtFXYZsNYbmaIhMFkk4o5TCBXRskojqm9x4hQH
         +TrA==
X-Gm-Message-State: AOAM530FZOjBnpkF22Fumqnt/saOy4nepquLFaW/RmJdR6U7WmGUBUtL
        sYnFF0Ezq2Gl8b9sP5Dj7CkwnA==
X-Google-Smtp-Source: ABdhPJyTn7S/tuMTZD6FUbhNh3F/gzDuxavwvcuLVVLhUX0JpFMq8XGVsq71+W60ALcKrnkct9aH0w==
X-Received: by 2002:a4a:aac8:: with SMTP id e8mr10248748oon.64.1595899882847;
        Mon, 27 Jul 2020 18:31:22 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id e203sm2102281oia.17.2020.07.27.18.31.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2020 18:31:22 -0700 (PDT)
Subject: Re: [PATCH 5.7 000/179] 5.7.11-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <63f634e5-e2bb-fea4-90da-774790ced38d@linuxfoundation.org>
Date:   Mon, 27 Jul 2020 19:31:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/27/20 8:02 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.7.11 release.
> There are 179 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Jul 2020 13:48:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
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
