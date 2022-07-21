Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D967F57D630
	for <lists+stable@lfdr.de>; Thu, 21 Jul 2022 23:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiGUVlN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 17:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbiGUVlN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 17:41:13 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F398244A;
        Thu, 21 Jul 2022 14:41:12 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id y15so3001812plp.10;
        Thu, 21 Jul 2022 14:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=PTVNzQ//TVV0ByVNgnx0mt68VkWro/T090AiSqqzd4U=;
        b=Jsqaslf6ARBPOf+Hx5KpSlF4iIvOH/KIU14oZY6/vnMefaX0Td23Xq+wN1MWhY5/DX
         iGYD1iXr1xUZRNefLlxQbB4GuIxwSWnTBi+ASqfMmpyPSvL4AJ6z2e++eh+AKlzvzENy
         4DFO5QaC6w7Mu5er6Pw7FGoKWZtYT44C7cBzmNcCZ3GL2bU6tBic6ujtG+g53RdVxMiQ
         44em3615IzcaZP+ib39zsysq0b9VsSd6IZkVwtqyrR6LyQ+rdc2VyrN+zym5wKE7kpm1
         zBy2F0J4KI7DHZW6KNUSeR0aMlVNZgi7fXYuUgENRP6mY43aUD4jJpecGwEkfCItubVu
         vCtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PTVNzQ//TVV0ByVNgnx0mt68VkWro/T090AiSqqzd4U=;
        b=aJgk8VpH34II4+uef5lSAwF9/jP9GROeH7oG2v0Xng/AXsScwH/Nkr4WpT8LuuRSmI
         VG35Goy4ibJb/OCMreTG3lbvGYesL+TCChmaM6NljzeFgCLVVetAHpRJ0bX4AhSFXfMg
         +ownXW/jHONNLZ9VI8oeijLH/797dHA8VsfjET8qKlzHHA09t940/1ACxgUDETyapCSl
         hCbUZbsmu7mbdl442cTefXX6ONWqE9MNYCMqGR8jcaR5rK8BvK1dsuSIvjUIUYi8mhvF
         rI90L/ML6E3x8dCJ1wojFq3vMU8MFjcjCJHETLxEadc98lX8ubXIs75Oknrzt5Er/RUu
         1sSw==
X-Gm-Message-State: AJIora+pEn5b6ejD6fFR2yFXRqxSLIZJAx2FujuF+Id/LvN1ATviUm55
        dCEwNOH2uVwf+8qXE897Yac=
X-Google-Smtp-Source: AGRyM1twR4wFhF5EPu5gS75HaBFza7A5bRvsrvSKyHkDVLxAxhNzdgaci3VilT+rjP7D0a4jAibBdQ==
X-Received: by 2002:a17:90b:1d12:b0:1f1:8d48:abaa with SMTP id on18-20020a17090b1d1200b001f18d48abaamr14036490pjb.96.1658439671488;
        Thu, 21 Jul 2022 14:41:11 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id e16-20020a63db10000000b0041981461f5dsm1924154pgg.90.2022.07.21.14.41.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jul 2022 14:41:10 -0700 (PDT)
Message-ID: <e8963a3d-f7d1-1805-4cb5-27710d0fdcbf@gmail.com>
Date:   Thu, 21 Jul 2022 14:41:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.18 000/227] 5.18.13-rc3 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220721182818.743726259@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220721182818.743726259@linuxfoundation.org>
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

On 7/21/22 11:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.13 release.
> There are 227 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 23 Jul 2022 18:26:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.13-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels and build tested on BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
