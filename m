Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDCA49F067
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 02:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241403AbiA1BRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 20:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241264AbiA1BRU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 20:17:20 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2A2C06173B
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 17:17:20 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id p7so15368ilp.11
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 17:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=67aBfSMnaiHMsOWw8JfgW2irvqZHBZezTTHX0wlnsc8=;
        b=iOE1Pz9agXft6boOpu/kTXZvD2K0dvcM57uHlxmGNBPAPr2LE9P4yNjBI+I8/7DGkT
         sm+Ell9Doku7LQ3sNecd0VAWHYpx6no7u+r6q8YtoHXU7i3Ce8omX1sQv8T2fEyJ9egX
         zXmws0ND8o3POhlgS1wfSGxbGeNqv1V42lB1Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=67aBfSMnaiHMsOWw8JfgW2irvqZHBZezTTHX0wlnsc8=;
        b=ouCyF9tKnT+ypH0PEGVqAAC7OXw+IU8eX0T38u64OoIm8TzskJYvOvYZY4Xeu1IkLb
         6JOIDJrfQ1yqNO4t91m1t13hilI4MHIxzT4bZesE9mIITgRaZcq7HCsjg9zi0RYBIwdS
         vfGJqH505BQXKy5wZdHCRiUobSI16JTMyxoXZl+bbBPlYpOmXu5fJFtktbFgA964btOJ
         AA1IogP4m3fBE7LnEQ70Pcxxw/uOmyYMVWp8c6EbtmNmhXVHsMKQ8p7tuindHTDthpPZ
         mUxz82O3571D9YGxvPJ6TYjB7ekAKKvkjs9Xjhsbyso5nctB0U5Wt2l+2l6RZxVo0jip
         MWIA==
X-Gm-Message-State: AOAM530bEKkqiCZcwP5FDPm1GvqHp81z+PWKyrkAvs4An2EuH3GNirX2
        bwx/B8h1kSAKnpGr5HKiWIy8dw==
X-Google-Smtp-Source: ABdhPJz/BgH3dCPMvMMAf51WAlxw0jrOeKfL7lnZzawQxi+c6UoaSx9w7VbkHgT/qXxTPSsEHzFzrA==
X-Received: by 2002:a05:6e02:b4f:: with SMTP id f15mr4479438ilu.265.1643332640067;
        Thu, 27 Jan 2022 17:17:20 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id o11sm12920539ilm.20.2022.01.27.17.17.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 17:17:19 -0800 (PST)
Subject: Re: [PATCH 5.4 00/11] 5.4.175-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, Shuah Khan <skhan@linuxfoundation.org>
References: <20220127180258.362000607@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <0daba213-c25a-ab45-74f2-24fbd7a618b3@linuxfoundation.org>
Date:   Thu, 27 Jan 2022 18:17:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220127180258.362000607@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/27/22 11:09 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.175 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.175-rc1.gz
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
