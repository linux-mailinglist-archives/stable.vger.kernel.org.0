Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF77A422EB9
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 19:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235351AbhJERJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 13:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235238AbhJERJN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 13:09:13 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A786C061749;
        Tue,  5 Oct 2021 10:07:23 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id k26so93771pfi.5;
        Tue, 05 Oct 2021 10:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B05M7p2z56b3Fz9xSboQeRMo1WViu9Pk/5djZoh8UYI=;
        b=bbvqOckQ53HrWLKWD7OzhZ8KHG6Wq1xeGTDSA7y9orDLL6dnv6W2iTAsA3KVkI/A5R
         QKJjT8qvrjKluSIzA34rV8Fa5Y/+dzByu5afHi6xkQfK73nEmpnvr9JGrCcusWt1q4Qb
         del+u3PqNPINyF0A1GWbSXd4eeLkhxqNQ+326KUb+lFbu6N8dqakCxt8i+Nrz3nE0tZM
         aS4GtSn/Xt8gadCBjlE2xFVckrHS4nSpfOMfUNc09mfLIL90m1nd07XWfLZP8wTvI4ue
         JXMl/fjr+i/kSELs6ESXxxl6D9aIUL9zlGy0tT1Mgamaha+mXV+IPLb/zmmWAw0+AwER
         v6Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B05M7p2z56b3Fz9xSboQeRMo1WViu9Pk/5djZoh8UYI=;
        b=Mq4L8uXQpzmmfh9Igv2XwS9UthbDAy+Xfe3ZXOL4YqLQArO9ZlyJfUWJSwkzHpBrsM
         KEXC37LGRTMSnJIodVzIr6kOHrGtIb9AEwbzrU02d0mG8pJG+xhDxqVoCJnzigAb6GGZ
         ma+v9YiRP14k9Uc0yUDWHKvuDJwtZe9RbJg5bHjwl9tGS4SJ50kJdHn3yLlMAGoLXmIM
         YIMp7y3m02zBodmoeZD5OHxyUBff9znaAppy0K0cMCzq5NRPrCxngFr5gKDtsYD5cv6j
         akWE270hfM3tbGfDkN/kcM7O5FJ8L2AzLMu8KtkLSE58mLCKc4bydTPvOXdtY6HTZjrv
         UMuw==
X-Gm-Message-State: AOAM531PfIdA8nf0Vt6Htu3KX/8SXwOl9sNnqDdwq4E1KKuySQJ9NeIv
        1jbID9lcH11Xf4evacJ7ASUFXMF3lWc=
X-Google-Smtp-Source: ABdhPJyveo9V3+gwaU9d0qeJ/Nd+aXs2wejdHP32fRhNmL+KYY7LDkArG+i62Y4UmzOcFIw59K1uGg==
X-Received: by 2002:a63:3d4c:: with SMTP id k73mr16488851pga.44.1633453642183;
        Tue, 05 Oct 2021 10:07:22 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r8sm18043171pgp.30.2021.10.05.10.07.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 10:07:21 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/53] 5.4.151-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211005083256.183739807@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <029ffc61-239f-5e9c-548a-2105a45ee342@gmail.com>
Date:   Tue, 5 Oct 2021 10:07:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211005083256.183739807@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/5/21 1:38 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.151 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.151-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
