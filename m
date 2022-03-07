Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 653454D0809
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 20:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245195AbiCGT6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 14:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245184AbiCGT6l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 14:58:41 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EEE364E9;
        Mon,  7 Mar 2022 11:57:46 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id s42so2656997pfg.0;
        Mon, 07 Mar 2022 11:57:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qaaoX3XGXyKcbvuJQkZ7A/pfCaFGarrrhpO5p9cLWnE=;
        b=pwWg2Z84bVFNQJurvbsE82MoCwoI1depjNMvL48Phsg3edgB1gontKdVo3RR8F+Aaa
         sxofxCYtMBKYo6UJAsUX9/dYKgCN42EhvH/g3JX3JIUjBsPZLzuE7sTcZcp6d/Zb+xw0
         qk1HjzGAnVtRQ4zVKJhe9f+274Yo7X/1EVYogCBFviT0GejFrRacbs0gChXiyleVO/S0
         8SKAM1EJLSQUep1TqYDR/NIDx8lYE7zz9q+T9RlV2+DC0XTcU9JHSelvbiBO4IXLA69A
         66yWXXrlNIKSS0nBUlLfbSbJYHqCi1gP9prCYldM0aPoxl5j7gJfstav4fy8tqfFl9Bx
         NXRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qaaoX3XGXyKcbvuJQkZ7A/pfCaFGarrrhpO5p9cLWnE=;
        b=UqB6/G3hL5OaYq3OJIQRU/aGEQwd6gxh6nDPuS3lJgETxVXSIMk3IgWZ0HkRLRmYvd
         8ct6o6Tv5ZPohBkj/8KOIrawckmBZztgG2U02wyNWONqaH98hKSA+aQMewIvkYnym+QR
         1Z/Dd6sW96kBxgwSAEVUTn8VWw0ujhQc8nKOh02v2fW0ZPvpuSu3ENIvGnKThNpXmdor
         +Fwuf3hvhvzbCMxEAHuExzMtQm/uJL9VxlYxIxRfEUOTwvy9hPkjtT9h+gtza7D6zN5L
         sZw+BaMty69+NEeyjmom72ES3/gwFPiH5SNHBnpXfpFxzcYGQkGErUBJ7/R7CbmKxabj
         s2+g==
X-Gm-Message-State: AOAM533R4m+8ttyjRhLwk0HzcWxD7CmB2bYb7f+zazTSECDLwCOC9m+5
        paA1tFuroAJBD8ZXGydYE0k=
X-Google-Smtp-Source: ABdhPJyNr/kUwXUfBHilIyzQ4PL7Gp3fTkhvskJB62P3j4blM7ZS3Y1gb+QbQwkhPX3qcA94V0SlZw==
X-Received: by 2002:a62:586:0:b0:4e1:dc81:8543 with SMTP id 128-20020a620586000000b004e1dc818543mr14494172pff.0.1646683065702;
        Mon, 07 Mar 2022 11:57:45 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u18-20020a056a00159200b004f708ecd48esm4353205pfk.149.2022.03.07.11.57.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Mar 2022 11:57:45 -0800 (PST)
Subject: Re: [PATCH 5.16 000/184] 5.16.13-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220307162147.440035361@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <35252a15-4c0f-7eb6-3331-43843a518c3f@gmail.com>
Date:   Mon, 7 Mar 2022 11:57:39 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220307162147.440035361@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
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

On 3/7/22 8:28 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.13 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Mar 2022 16:21:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.13-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h



On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
