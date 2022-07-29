Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C1758546F
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 19:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236366AbiG2RYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 13:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbiG2RYr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 13:24:47 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066EF82F84;
        Fri, 29 Jul 2022 10:24:47 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id p1so5158690plr.11;
        Fri, 29 Jul 2022 10:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=t3eByXtJ0XeVrYLlyDivCVp5NffCEVyzgKFMHnhoveE=;
        b=Gmu8jWxm59OnKqdWuCOyYdil6Mkd+LO7XWujoUKtDx78QIZY0+Z2F2x3siVaCuHuM+
         JR+YFZn19bFMfXqLaKh2XEYoWUtpV1zT0t8GALEtCrQqf5R32Eh4Qd/DPQwgiN/55wYM
         sn4fQnkkjhKPF7v17RsJg3jtsrs1nLYJIX043ygE9QljEo5iK//xSIEWzMYTRCs3U0G6
         3vUwEj+7OuAQnD8VFcQzuOro8DTvcTD3mJCA1ptOABjxvQT22FVjDya2xOHPFM4etons
         YowpdqtHEkdRxGWWTasK+EA3jSlIsW+99CqtwH53pXXRV+wLDVNSCOIcSSMbRQyiA/WL
         UFFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=t3eByXtJ0XeVrYLlyDivCVp5NffCEVyzgKFMHnhoveE=;
        b=EkxpPQGzVuwRH6IBFXNZ39WP4eL3jwISZU5V4MMVzJBIkTdA38UrViAc4vA/Zg+qab
         mrtYLpMbUDDLR7ln4FSs1ETuX9GRBoVk1BpVwnbsRn1LvnLCmlaK/E0AVmwzGMSeXrdj
         8UOJB+hE+aghKiLdzdNiHXCvT2dLjIWs6OOCcNCfAXhteiDVAIAydlG9oubLJkDgGAdg
         I6xN0SXvaPmlltEEiueGcr0iPPZIcI9XE57J7etLKovmh11ZTcMDthZY9NiKYvMzwznt
         eLpsFkf7iCbKR3ocKbUytjEyz2gpuk2jOyrIXr2ufZapClMSRLPLfBOrX/gzaRT0xQY/
         cAOQ==
X-Gm-Message-State: ACgBeo0+JzvPqhqVLNrBM8/HLp2vTbBEXv2UscRj2QigALDhIo8YTqSD
        AYjfpG8rbgbK63hdUGIo+I4=
X-Google-Smtp-Source: AA6agR4tMKuCfO5JYkcdncSVHk3ZvSPZLm7kuXEJVHzvYFXSJiXFlWVxRf531L6Uv+1BelSJA9BpjQ==
X-Received: by 2002:a17:903:1c4:b0:16c:4e45:38a4 with SMTP id e4-20020a17090301c400b0016c4e4538a4mr4801395plh.151.1659115486411;
        Fri, 29 Jul 2022 10:24:46 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id oa15-20020a17090b1bcf00b001ef89019352sm13211566pjb.3.2022.07.29.10.24.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jul 2022 10:24:45 -0700 (PDT)
Message-ID: <b454a691-0ea3-7837-3cde-4223007ffd9c@gmail.com>
Date:   Fri, 29 Jul 2022 10:24:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.10 000/101] 5.10.134-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220728150340.045826831@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220728150340.045826831@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
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

On 7/28/22 08:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.134 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 30 Jul 2022 15:03:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.134-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
