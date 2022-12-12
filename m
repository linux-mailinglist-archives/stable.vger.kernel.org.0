Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33B0C64AB40
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 00:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbiLLXPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 18:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232244AbiLLXPG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 18:15:06 -0500
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEB163B2;
        Mon, 12 Dec 2022 15:15:05 -0800 (PST)
Received: by mail-vs1-xe2e.google.com with SMTP id h26so12961772vsr.5;
        Mon, 12 Dec 2022 15:15:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V48MVKkpHJu7tVHw5UPSyY7rRxcwN3LhwuDRtIvk8io=;
        b=TirRS5W0oF99cVHtue2G5wruRhFSNEBMA0RvKK7R/rVUjBIMRpuq5f7xpkd6Orbt8Y
         z411b6w/Cua/PTgGciAl3pGh6CkYSZewCm9aawzWQuMhyCiF5JjcsvuSRDfDFMQtP//p
         +w78F6rAb2cPp3T0Tr9o7GWA52wQhbSwWpLEohFABfthO3GzupeeAy+vl+qZC6SVJmlr
         zKwlVSrS3Rfg7CSgGTq8Y3prbUfaYir+fEeoHVqU2dMofE/MrFsNroBaaBJxxywdauss
         EZKblUwtf287onCTefsWPqqxjNUWt7SaSIHFW5v4y9PnRI7O0+G/1sF02nAuvNRX8c7V
         e61Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V48MVKkpHJu7tVHw5UPSyY7rRxcwN3LhwuDRtIvk8io=;
        b=kvcoztnw6Sq77KwvfRlRLmIQ7BkyLrzCxy+M7i1syb7Pq+JOvFlL7hOVQy0eKzCcyv
         tM00qjbwAhnSlhIDUtUXFR6yefKcjgPJf3nGlAZoawbLsElwDnM3lizkSaTNy1HPy4UK
         Hd++YmWrrEKi/uZpbK6Kc5wRKLKdvIGO68nY7/96eUYH2h+Pr08Yb8xlPH5joLWiHchg
         pfVfjXDyvOMfV3JV20BeoVMJrNZACkQIjaGsQGHHPYijW93sNAOQjH1YZbL+RASjmtLi
         6XJtpXxpqgMpI5Rr9r5fuLJDWXHBel/axX0uR3g9/rG9E8hivomqvWM02OYZaunwGL1O
         cfEg==
X-Gm-Message-State: ANoB5pk6jaCWPnS6KsSZv+iI2VzIx9xlbmKQcySGLJsUdK7EeaFKIA4x
        1gj4SYUvowu5kUyfmblL3IYgYC/j0TVSsQ==
X-Google-Smtp-Source: AA0mqf724J0mpSGaVZ8djr+B7n0KXo1suwu+clUsF5GgAokepedmw8v4XSG1/H8xPUhQnDx+T8PzPg==
X-Received: by 2002:a05:6102:5709:b0:3a7:a0fa:91f2 with SMTP id dg9-20020a056102570900b003a7a0fa91f2mr8033503vsb.0.1670886904664;
        Mon, 12 Dec 2022 15:15:04 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i22-20020a05620a075600b006ffb452b10asm25924qki.13.2022.12.12.15.14.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 15:15:03 -0800 (PST)
Message-ID: <2625238b-81bc-d098-4cc5-ca2e2318a7bc@gmail.com>
Date:   Mon, 12 Dec 2022 15:14:56 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.0 000/157] 6.0.13-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221212130934.337225088@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/12/22 05:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.13 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

