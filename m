Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE94F58E1BA
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 23:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiHIVVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 17:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiHIVVb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 17:21:31 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE6261D50;
        Tue,  9 Aug 2022 14:21:30 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id u12so9866675qtk.0;
        Tue, 09 Aug 2022 14:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=3x84CjJLSxD5J9pQq42M4UgOWJWyBUZwmsveFma/mGc=;
        b=QnZ1PxAw0LGnA+450wdpzgl67koyjIjhjr/ZO6yes/QUkbksS7TUWf2gzAodbLPGkR
         boHcwSszO4+kITu+5ZCiesVMp9/IGEKrrKXPvhNZFTYeuWgJzAXpLIQoXwpJXKY5w87V
         bIaTQDQdUaEGSLCaPMkLUAoqgo+hSxfVwhtYQ1RNqqCvyBW3+8RyyDMGV0hHTRaZ+Xkw
         tDsXS6094UAXNhglFZjSClniHR8CBQgA5pf7aQrug3zCgfg93Hj0E+8HBp/JHAJoUATY
         J6CsXhVyOzizf8rsgn1KjVBb1l0Wn0q4LgVFdDzVmL9Fw/cwOxyL3+Q5s/otu/m+kR1L
         +4aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=3x84CjJLSxD5J9pQq42M4UgOWJWyBUZwmsveFma/mGc=;
        b=mHtbRhp/wdRurlYbLomqAIVWi2dRyRv8+uwSc3o2Q3+rfq6scWjyqFAsCLneh6V5pP
         L09uuMNKKSlussxF4uufVbXyAC9tVzPPnYj3ZLF/VXGOQzBwefmGvpE5UlaIOL/0BSHp
         BzYO5UppqbnGGQg6rJkW75snLvRFXFihSrEOJyJJLH/0NlI9uHHog4ULThQh4sSdXbRU
         7kVYAUnux6sxQKvgHXouMIsvGexEKD4Yrv/Nuy3dq2IFVmHKmnoV4ToebHazyxbgYuBO
         Sik5rwDYCiExXYOH2WkzbpFiVLUSfxNbg499eioaMTjwcc8RJZLL+hvYwrlLSKXP42yO
         A8ew==
X-Gm-Message-State: ACgBeo0L7Buvo149agIngku/qpKVIP0UjRd9hua0JMvQzV1RO0U/FbaW
        vKA83+ACUfcYOrO8faQGyZc=
X-Google-Smtp-Source: AA6agR4FM0x3F7gcGUjZCrGg8BkbSbLHOKWQJOB8BSnjTRoeHUpMyd6K1QHOYpA3HZa5woUarR79wg==
X-Received: by 2002:a05:622a:110f:b0:31e:e0ae:a734 with SMTP id e15-20020a05622a110f00b0031ee0aea734mr22065060qty.495.1660080089370;
        Tue, 09 Aug 2022 14:21:29 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r1-20020a05620a298100b006b906c7ba98sm11811158qkp.85.2022.08.09.14.21.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 14:21:26 -0700 (PDT)
Message-ID: <85595636-833e-4aa4-1bd9-b7be0485b40e@gmail.com>
Date:   Tue, 9 Aug 2022 14:21:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.15 00/30] 5.15.60-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220809175514.276643253@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220809175514.276643253@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/9/22 11:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.60 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.60-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels and build tested 
with BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
