Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB435F3565
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 20:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiJCSPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 14:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiJCSOx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 14:14:53 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9890B101D;
        Mon,  3 Oct 2022 11:14:49 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id k12so7039094qkj.8;
        Mon, 03 Oct 2022 11:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=+hsPUimDYDiwuT0nRdu8wXIodqSgvz856Uo3Q87+AUA=;
        b=nHVp9OvjX1fqor1+Rs/a2wW+zSZSv5lC+/7lkbcZD9dXqDnji79+FiPTvEOcr2p16M
         RjQFxfrnEFgK1BCX40kRZM+Vm9JhWHdOsWPRFPCJ3zMs+qwewNtX7WlMwuI3scIdz4RS
         +BYvFkpyOjPd38Gen1HkObCxpGqBhjsPlD0hvqcNNLyGm9XmDW6nXHiOxyEcnmfje9tl
         CAVkQI3IjWdjS7vF1K4u5fipMGZVwj25tSaB4OMIQ1w2+EAQTCRsZ2ZFb64rkH2DVYOl
         +/KKmL0hn4XIKwklm26nt7JiyMspvgogenpLXt0EcmPKyGDaqjUorG76aBuVCXgHs53X
         nxUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=+hsPUimDYDiwuT0nRdu8wXIodqSgvz856Uo3Q87+AUA=;
        b=ULWv96zjut5+4HmwH6y3YB7snmcFb/uyEKNQ+LSkraqtUtUPPnEwerm28ubHGnfhfD
         qyfGWKiJ9JL/8WAeANWw9N5N8PEgOapLcPDwQSFdm6twqU1ZizdKXwa+Ww2SOwuz6Y4d
         YeyJdc8TkRxJdNJvs+5fO2XDYxUT3bp8s2psF2FVVrWUbf3xJv3zNPWFQIHy4au9wf8E
         8mcVGPqFAPIZ8Vogy57lfuGALvdEtmQ8Z4FJoZYo/EB1Gs+GPI2MnJ2d5I1GgbJEu/Z3
         oICFjUfWAOeVUYfHKmpbhxzxLtohYBri0l2ncfF92bpm2a2M1tvVjyz0XyTIkijIlr9s
         rMQA==
X-Gm-Message-State: ACrzQf3nVsvokFj0Wzp7iQZF0Gi/N7L+md1zDv/SsFiHyaui4sqjqhaK
        +u9c5ww6WMEO/j3WY/WXyTU=
X-Google-Smtp-Source: AMsMyM7h3ubkLOrH90jeol8OgDHxaKq4Ei2ZnEpbMRqs/JM9XfmYjzqzJ5GeAaoNAQdzTCAvptyYmQ==
X-Received: by 2002:a05:620a:28c1:b0:6ce:b23c:dcac with SMTP id l1-20020a05620a28c100b006ceb23cdcacmr14547985qkp.123.1664820888460;
        Mon, 03 Oct 2022 11:14:48 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 16-20020ac84e90000000b0035d4b13363fsm10757759qtp.48.2022.10.03.11.14.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 11:14:47 -0700 (PDT)
Message-ID: <0ce768eb-fa74-d387-20f5-e28aba521ea0@gmail.com>
Date:   Mon, 3 Oct 2022 11:14:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.10 00/52] 5.10.147-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
References: <20221003070718.687440096@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221003070718.687440096@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/3/22 00:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.147 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.147-rc1.gz
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
