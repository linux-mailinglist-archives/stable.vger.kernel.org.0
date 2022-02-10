Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 100974B1588
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 19:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240811AbiBJStM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 13:49:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiBJStL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 13:49:11 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8BD3CE9;
        Thu, 10 Feb 2022 10:49:12 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id r19so11841919pfh.6;
        Thu, 10 Feb 2022 10:49:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xyY6RXsZc0sRZI2dIx6Yfgcp+cHl3kx4JYS5Tt67YQs=;
        b=C1zGoNnSTm6BqNQAjEbBkEPT6xD4cNvVJHTEkTMbh05aidR1CHJy+XnCrqIgBSUQdn
         v2AyQwrK70vySC0SB/bP6wSJ10P9OYAgf63WRorqLgBgs1ihs3iU84wy/obpLL9PHK48
         PL7HTdJOaMlfNdR4sSVQxK+PgS3lRo1LF3lRB6HybRtpPpPUhZz02/kp3BBxLWkDpfBb
         20ZBybLD9lRkj6maX9bJvpoRw+Wosr3o6d3nBl4byicuCzPpYnrfoafDRHPxnWXDmQQL
         V4voKMnfZvDHn45xgZ1iSd2uAM4ieabggbtE1ojvDpjCo/VS5aPgY1NIITPaRKxvmKLX
         dzow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xyY6RXsZc0sRZI2dIx6Yfgcp+cHl3kx4JYS5Tt67YQs=;
        b=S9wKrCoZb/RdTsHYpZFTDSe+RahEBaDlIhGWyyzGzZ6b23K0y4N14UHT2wpuCBdSay
         cC+0GVUswK8Rk7w2Pk+9lSaHH2gKRNhn1vrrchMDEMZSjMR5mL5OnpkF/AMAa+p90NeI
         TyXUrnjX4OJFBLWStlAgbd1p2UljyFD4NwcMfiN9YIhpmpg+fDCuljhu/pWTi9cpbToP
         3hNC1gI6OI+SZmZt/P7HSS1yfBQbrJU82Woh4hVgCRYJ0c9zkg7ZOmOHgXrrWeLBnVTf
         +q8KI++UVAAxDQ5hIWxlL49QtRASoUmIUf4pPuLjT5gxT/QM/vmfd1qnZWvFHzvoZ8MD
         tpcQ==
X-Gm-Message-State: AOAM533zUgwF9PR1PPeWh1kfUhVDD5IFspNAIb7eH1M2Z/2QQD3L3hH/
        iFvUdLNjxsdpHgIav+8hVWI=
X-Google-Smtp-Source: ABdhPJy+/KWlRA6IHo8GTBHk3tTIiTULQnZdhqd8U09vUpqlMzlag4GuHB797vXz29LbFT3sEv4UFw==
X-Received: by 2002:a05:6a00:cc8:: with SMTP id b8mr8759818pfv.5.1644518952298;
        Thu, 10 Feb 2022 10:49:12 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a29sm16951278pgl.24.2022.02.10.10.49.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 10:49:11 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.16 0/5] 5.16.9-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220209191249.887150036@linuxfoundation.org>
Message-ID: <c9f0cf42-a454-7544-14f8-99c3eaef73d1@gmail.com>
Date:   Thu, 10 Feb 2022 10:49:08 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220209191249.887150036@linuxfoundation.org>
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



On 2/9/2022 11:14 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.9 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.9-rc1.gz
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

