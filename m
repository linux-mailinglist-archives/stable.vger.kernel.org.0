Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9B860B9D4
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234238AbiJXUV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234115AbiJXUVO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:21:14 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04002E9EE;
        Mon, 24 Oct 2022 11:37:37 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id o8so7053644qvw.5;
        Mon, 24 Oct 2022 11:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NsOYGIUT5OQzMr3XU7j9OzU4X9Z5Q8a75HtiI04Iq+Q=;
        b=awD+XySz2X/mFuau4ULWST9bDE26l/q8QL+HCd+70G8p8ruezYaCGkaXWEldSnSepy
         96fOenZaVPpuPkHULkWzJPF3fLetHr3BqTTVLxiQp81kJAj2Gy1CsO/G79kpTCS8ut7S
         T5t236O9orSW1d8Uu/qPkFIoCI7NL1j0GheqOkwResSWbPc1z3fpaBVT5dCTVG3YeOze
         aZczS7Pw+RxExieAUFf5rsJLNU0NZibP7bEMjCsqnmYZmGsQlF+VqIESktvztuHhnuMS
         mutqjuu9+DF9bwDUlfobdj2+JIh6XpywlP5xzFroTZbXVHw1ecO/JX9PHCz3ZTM7xdHs
         s+dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NsOYGIUT5OQzMr3XU7j9OzU4X9Z5Q8a75HtiI04Iq+Q=;
        b=Q0xI+uBWJZ6yMoX96B+NHVTayBIBQaKi5+9hE/1wuiwqgkHXCiRAt/XhoJNfS5wT8E
         E9dG/J6q734irVhriN8Xth+Dn6YCQQ0kTwI9rwDDZwlRoEiTRopFVHhotp3ErvCAZc5A
         mEBWQdJrWLikT+Ug8uOFY/i/Fh8G4ba/cc1tUiWh/kiHAvLTzy0q0wfye/gvYire8Pw1
         9Lz8ltFFOr8pTG8105ilhIhWsFVGF3v0oeN6ufvQE68sbsDnk2lqGt7yoIMjYJB13PZL
         db9DxVKqRv8wvIc9h+mCtwx/las8j/cE2l24D56aGAeOkcZXcsLWs+nBblFvfm8DNLUa
         tY/w==
X-Gm-Message-State: ACrzQf2nYfVCXhiSXuOj0As+DukSDbZzFkQEoHLTvgpd8aVaW1VMMb7v
        e2auLPaWP3oiXq3GTTrQ0MU=
X-Google-Smtp-Source: AMsMyM6xFkXrK9g75ZgTuSfsY1SdpMsKp8/o+06I3sn6KMELhuAgVuzB9waaOPACIOB+8hgtUzfRxA==
X-Received: by 2002:a0c:ab53:0:b0:4b8:65c9:3ea4 with SMTP id i19-20020a0cab53000000b004b865c93ea4mr19830306qvb.5.1666636591160;
        Mon, 24 Oct 2022 11:36:31 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d2-20020ac80602000000b0039853b7b771sm306068qth.80.2022.10.24.11.36.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 11:36:30 -0700 (PDT)
Message-ID: <dfc45fb1-e357-c3e4-679c-0ec4f97b50cc@gmail.com>
Date:   Mon, 24 Oct 2022 11:36:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.15 000/530] 5.15.75-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
References: <20221024113044.976326639@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
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

On 10/24/22 04:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.75 release.
> There are 530 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.75-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

