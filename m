Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0925A60B7C0
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbiJXTc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233165AbiJXTbv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:31:51 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7458A3472C;
        Mon, 24 Oct 2022 11:02:22 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id a18so6598373qko.0;
        Mon, 24 Oct 2022 11:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0AjZetwXQvFyjj5rKhKIL62qpGJ5ZqUWEelD4zxLAHY=;
        b=hAzkIsnj/tlvt9iPucOxSeNI+Xr/rkQ3MOdwedNdN2uKXHlhTLyjqFgbbmMzwGradY
         1gIqMOMQcU9/MAZ3OKa7dela4Y85F/4O8qtzeSy4WKmmZJpAtK6u7eEQT11YbXPqSofn
         29CM1n6/6/cqMyXq2kF77hmqL3lyQ4kEfZKsKVCFr+8WXFbw/R333ksNp0nPRd62qb/4
         +prAFztYiKmlw+6iHZPtcRMfvclEPm+8WQ3OulCnBmzJerHo9PFDX8eWRz/qfpo4oRIi
         37jv2eYpLhRF32CP8O///inipK1+JfuDel6Fv9+cuLivmxO3PfNVphF0asybCuuuwr1x
         kjAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0AjZetwXQvFyjj5rKhKIL62qpGJ5ZqUWEelD4zxLAHY=;
        b=Ce73rA0zCejiOq9iYFFAkx7A2Lx7X9+jp4UhASJvZBvi60cXCjElvV8gA8JxIBzxGi
         2NaVDklnTparMAcFh9DU7uNdfchlBSluR+mCqDVY0bNrFtOwLWEUPZ1iUQGJbdlpP/SU
         yOBGIHC08wE4wijr8PUQBF823IjdnJVkktMtM3mJA/jthYn3a+lOAy8VuWBuHKxUgH7p
         f2L2fRvQE5nT/2gLVhUY3GdJkSFHSg0BoznBNfhLt6m5cnjqKq8DWaK7Y9cud1dabs6u
         MPtpiBi3jbVFktT8wF69wwVen6iwoLKzpHi7koTLrVviEqWmp3LENCvOq5J1Sf8OI7TI
         EY7g==
X-Gm-Message-State: ACrzQf27UL3xa3jN2p4ip6YATJdunZUHXwkL1UKIjUyySRvsNPhjnLPW
        E2EMyToJEqrqkHrCQmDbl8c=
X-Google-Smtp-Source: AMsMyM5iVLa+j7+/WKxEYbCrr50S4qHEe5ZrOzkPzfJXkdmBwZdaMqWnAk9anHXQ4WIKlSLa5xcf9g==
X-Received: by 2002:a05:620a:22cc:b0:6ee:3e43:ac40 with SMTP id o12-20020a05620a22cc00b006ee3e43ac40mr24110693qki.454.1666634478109;
        Mon, 24 Oct 2022 11:01:18 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id e7-20020ac85987000000b0039cbb50951asm340123qte.24.2022.10.24.11.01.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 11:01:17 -0700 (PDT)
Message-ID: <7083ebdf-46e4-3e94-a47a-c2d38782245e@gmail.com>
Date:   Mon, 24 Oct 2022 11:01:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.10 000/390] 5.10.150-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
References: <20221024113022.510008560@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
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

On 10/24/22 04:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.150 release.
> There are 390 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.150-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

