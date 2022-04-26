Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C74951050B
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 19:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiDZRSD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 13:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353659AbiDZRPy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 13:15:54 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A953C710;
        Tue, 26 Apr 2022 10:12:21 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id iq10so5622269pjb.0;
        Tue, 26 Apr 2022 10:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Xex1L+qhJCY3xuEM8rnY77RhjLIAitywaBH8FnXN2NE=;
        b=bxXsJwIQmg2ku7et4j8+xq9nMg00udwIkyvPh9/9E/YjIyflfTwylCbsEfjDeJT5M+
         CwMfZEUY6uRG3oP8T7x8URYwmIyq9akC3TPlTUhzWkNN7GHYJ3vCRUrrpRb9ejan+nc7
         rsH505UOI3MmkMuYRrvvdLfK4/1gbhOGFH2jPkSNyqzO/qMdGaet/DwzRAdkB2T9kVCk
         kj1XvRZXdJwZug6iiQQcoHvWgFrcvOIAoX+QR+3K54Mj/suX5EkmG5WfvBmroRPBGQDy
         48Y0ATvVxJrHZl6T5NAISRCpMmfQ1gS0LLIcJwr3CX0Pkfo2NlAARLHQppCw/KbZFX4M
         60Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Xex1L+qhJCY3xuEM8rnY77RhjLIAitywaBH8FnXN2NE=;
        b=c56nqED83kCRf4MBoKOj5MXTDjf65zzaKu/hH2XoD5cCB4Yq39AunLscnpg5n5zRu9
         F61JKoH/uYuTsxckz//TY+DOaxnAXobH4Q0oH44dNuohshx2UioMHFeLRQkgqdGVtpww
         PIXH/VHCnzqEkqLv7J4oyDFtX9zsiXkx0RZwTpAvDw35y1HjTDwZj5fJqFfQ/A45ykA9
         QHSme+oCmCpFYyKeuoHqBsrZYDBAJdeoqf58aCHooX6utcKCk4J7lufJJPMqsldd/4gp
         PEkLVpswbuPIvv+9f8VCJafrw/L07Hs5Fq5sg/DySbUOGKjAXNV4CVEagzi8VPJxia0m
         BfqA==
X-Gm-Message-State: AOAM530MzURGZGwkJfCzPYSTL/KmpgZQf+OYzML8423/Qyvjpd7As/hj
        ncDu79VHi/tzQn+mpyXMqIU=
X-Google-Smtp-Source: ABdhPJxu8MceZNAOZTO63BsuWJu133Vs0KS3r76F9XhsDtYfhid4pivBZxd0ZvAvKPlpmG9QgmN2Mw==
X-Received: by 2002:a17:902:e8cf:b0:156:36e0:6bcb with SMTP id v15-20020a170902e8cf00b0015636e06bcbmr23470774plg.105.1650993140487;
        Tue, 26 Apr 2022 10:12:20 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i23-20020a056a00225700b0050d38d0f58dsm9035602pfu.213.2022.04.26.10.12.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 10:12:20 -0700 (PDT)
Message-ID: <53ab8f7d-bf13-c285-b67c-d7e224b581a0@gmail.com>
Date:   Tue, 26 Apr 2022 10:12:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.10 00/86] 5.10.113-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220426081741.202366502@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220426081741.202366502@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/26/22 01:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.113 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.113-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
