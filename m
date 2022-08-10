Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF4058EE6E
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 16:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiHJOfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 10:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232252AbiHJOe6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 10:34:58 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6853030542
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 07:34:57 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id o2so12276515iof.8
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 07:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=zOpFSGb2VJQXNmtIaTiRcV9CKzkjJSm7+ANpt+73aIk=;
        b=ZCv+A/c3FbAETOJui9SLA1d91bZbxLWN+W146M9wCkanQie8OahBPp6mSQecPJalb7
         ce/+pPKSADVm8VqoqtluClC4DyAOI8BkJTfjAIe0A+avwUXlHXULXhF3Y/B1z+aP+f69
         Y74wzaRykIZaeoWyCIPoDV4/+VTn7jCeWPYJM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=zOpFSGb2VJQXNmtIaTiRcV9CKzkjJSm7+ANpt+73aIk=;
        b=LA2aSt5QwLzkVUiDj7aq4pMaMRGFna9e0A+HAnXYL/+f2771qpeOjd1SlpK0HYI88Y
         VOZ8FbQVhJRX8Fvp6Cjq9RfAqiM2sZyo5/+gXZwjaidN/aMlCpC/KUe8T9fnUk5EePHd
         vkha1B0rKHZ4t5TxLFKH/0tdvhZ3WOggh9FE8mf2/bpECZ4OxLJZZ+u6BdvNQj4IzKtF
         yRl/kXag69Q00gbS04EsjTmDILAypVGDUZkK/TV8UZpefH96gMK01x6sBBCzOOzNUo+e
         CYjLk6ozIVJPaGVs5VC8rgRuu+OD7vHRqGSSY+9JE004K1gtxtFK2Wr6VvJZtteoK10f
         fDFQ==
X-Gm-Message-State: ACgBeo3KbxiLCtP+y9tkkSDyQfmQC8iOVCDRJKg91XCcLW8sGSF8jkQr
        OvJz++fPoCL174qsM+lcim2mZQ==
X-Google-Smtp-Source: AA6agR5llW6FcQMaVHqSDbPohi4M9+jjDZz0dt22qqN9xL4PCVT381d8l4dU5KINBrh97Q/WFWzGeg==
X-Received: by 2002:a05:6638:349f:b0:342:fed4:1423 with SMTP id t31-20020a056638349f00b00342fed41423mr7048541jal.318.1660142096831;
        Wed, 10 Aug 2022 07:34:56 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id w11-20020a056638030b00b0033f1fb23d9asm7492040jap.137.2022.08.10.07.34.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 07:34:55 -0700 (PDT)
Subject: Re: [PATCH 5.15 00/30] 5.15.60-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220809175514.276643253@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e583ee1a-5f72-4c85-384c-027c4340ef56@linuxfoundation.org>
Date:   Wed, 10 Aug 2022 08:34:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220809175514.276643253@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/9/22 12:00 PM, Greg Kroah-Hartman wrote:
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
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
