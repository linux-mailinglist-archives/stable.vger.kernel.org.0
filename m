Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADE841B48D
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 18:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241849AbhI1Q6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 12:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241927AbhI1Q5w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 12:57:52 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2FFBC061745;
        Tue, 28 Sep 2021 09:56:12 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id w19so19387594pfn.12;
        Tue, 28 Sep 2021 09:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gVkpcpkByORuGdzqkiVy6fun52SpWrFZIdc9L5y7xkM=;
        b=TfBUJK0JipyQb+HzLHVRWQ7koSzWvOOoNscofewT2bhH4/Y5bjWYSh4Z3sOUduE08r
         lj9fV3hRjMuF1tlXt5IoW0cH1ErdqKxVa0g+GGgD3eWbZNGOmCKWeHSZjPaOPGgqVm2S
         EI2zs+43flU8d73zWc+f09KVy7XvRkAs1ke3Ed+QJ5W/rfzPRMjaLqb0oCvK2MtlmcJb
         HLHrfiBoAFaxVG/6bAcvCQt3ynrkqvqMTa3uP6SkqJ/KKQwHJWZib/u034fou+QiWFtR
         Kq18IEPOAT5Pb0niXL2UziKeLBTimzBONw39elg1VU5gBzPaii9TNy5mzyfMwI0RXczd
         wOOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gVkpcpkByORuGdzqkiVy6fun52SpWrFZIdc9L5y7xkM=;
        b=dYwnrxGo84KX58n9jNCrSbcxNXSbKYIdXihfUFEdJ1F+hQ1jReiDJ23z9pOrXQBIK9
         6lxo6JCAFgll4jOwtHGq8H0CuH5mCTE8HPHnb5noInutc0YcTS5E3mLFX4FAZ1ikyZhW
         1KOLAtqzQUzrf1Jd1f2mAAtdz8OlNsAR8HClblDc7ueRXHYHCE8rdCxV7l0xA7hKZ3su
         VrFZMrIRDd7HLZEd/l5bh/ura9jWmVHvXBjRANVp6RoxoVeW+i9vj93kPSeDDgY9CB2m
         9YxjUkKXiQyfMeclu4Yx/xv6/6wwAEpH0azrBlQSkiJDqx1pkY++1760wRTP/si1RlKV
         pmPg==
X-Gm-Message-State: AOAM532L42NPr1RbMBLrbZcGyuzwHrjo2DLXY56Gs3cg8HFhweugLOaN
        ZBVEThxP/EJHwu9Yr1qRNDUdXBq8I2s=
X-Google-Smtp-Source: ABdhPJyGJqSvkdslfNuUfG6TPjyL1rl89IH54lFa4XUHdpmV7A1Y9LQ9T2ymZlnL4LTCPISSlpnU0w==
X-Received: by 2002:a62:d11e:0:b0:446:d705:7175 with SMTP id z30-20020a62d11e000000b00446d7057175mr6662367pfg.74.1632848171909;
        Tue, 28 Sep 2021 09:56:11 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u4sm20722232pfn.190.2021.09.28.09.56.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 09:56:11 -0700 (PDT)
Subject: Re: [PATCH 5.14 000/161] 5.14.9-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210928071739.782455217@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2b2f9b9a-9cb2-b81a-3963-29044e953f4c@gmail.com>
Date:   Tue, 28 Sep 2021 09:56:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210928071739.782455217@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/28/21 12:19 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.9 release.
> There are 161 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Sep 2021 07:17:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.9-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCNSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
