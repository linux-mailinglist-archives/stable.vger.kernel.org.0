Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 685BC4ACD3C
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 02:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236292AbiBHBFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 20:05:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbiBGXHO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 18:07:14 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5CCC061355;
        Mon,  7 Feb 2022 15:07:12 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id n32so15620596pfv.11;
        Mon, 07 Feb 2022 15:07:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YeK0s/k/9pNB9D6r0CRpg3ac/FaJeNmKInmrsAsFjmY=;
        b=ECxEn2Z2v+SN4kCHup14sZ3Fb/Ob76MlGGG6KrMz9PT/cJuYZ61wl11Zv6olyGnxkA
         yX0yVsAFmEkHMTsOreBmEH0QmzqbtIpP6AzhOWTnM2mSbvKJ0XwK+EvuwDv54mswGTEn
         MPq7Fb/sobvB9vtZyACKIXlwk69xEMlEqDlFpyEkwKxVOtPmomOB582oirLhb5kmhyJZ
         NFpuqIxhUkLtIsY4EakUYHL6wNGYD1UDdjtvsxMyDwD77q3R2KkO0sbDcKhkoxTF91kk
         Fow6dwb6jm1PQWJY6zHMlNCMdr5kpS93IbSBU5VNOuJWIyxNLM4PCIdkq7REDUvy1/dE
         rYCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YeK0s/k/9pNB9D6r0CRpg3ac/FaJeNmKInmrsAsFjmY=;
        b=FUQMuYdBXZ6NxJTLUdr3cOimpQqHj4Xk7124A0AMfovJ6m/U/JSvw8gHMUyBGZJFCs
         ZPnyT/fIB5KUTI0BLjC2YvY6r+OxURA0DS2VhcDAWW/MLG7MXNrEkp/+4UM87j9Bptqy
         RH0LWcz9NFoqmVwnjwDd1IXPRabtVKsEjXuE45msN00GdBiuR8E+3Q5NtnaX8cVA9hde
         /HG/GoVzRSkl0vDgXgzI8Rk4xwbz8wfDXuERz7i51duWgjYVappBmd2bKgLIOiuzUcIQ
         ULLAVrZg8Cc+7p0zj4QgXuN2B7ZmpMB/BlArL8C2bIRPKy1VAP2L8PqffyCBp8cIg17i
         va9w==
X-Gm-Message-State: AOAM5305MLAFCQR0SFnZOn1hqwa084TI0W6JxIBZSfgZiNlyD6NkFRq+
        OVpls82iAK2X0dzdG8gkAj0=
X-Google-Smtp-Source: ABdhPJyeZKtilM7wGlP/mYZPrv8TE5IJher4fie3qEjrmG//+nxytVQLrvBiNaDr+p/xQrISHpcaqQ==
X-Received: by 2002:a63:690a:: with SMTP id e10mr1275538pgc.599.1644275232000;
        Mon, 07 Feb 2022 15:07:12 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id lk8sm389693pjb.40.2022.02.07.15.07.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 15:07:11 -0800 (PST)
Subject: Re: [PATCH 4.9 00/48] 4.9.300-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220207103752.341184175@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d87dbbc2-15a3-1e45-bf85-2f51ef67d3e0@gmail.com>
Date:   Mon, 7 Feb 2022 15:07:07 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220207103752.341184175@linuxfoundation.org>
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

On 2/7/22 3:05 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.300 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.300-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
