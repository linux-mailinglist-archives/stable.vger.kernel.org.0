Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D74C4328F8
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 23:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbhJRVUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 17:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhJRVUv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 17:20:51 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC51C06161C;
        Mon, 18 Oct 2021 14:18:39 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id kk10so13128447pjb.1;
        Mon, 18 Oct 2021 14:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=whn6ElcSPtvDWMaZcHna4NLQGucnXh773vssx95SaXg=;
        b=U3Zq/SO6Mvpo0ucY8KLXAOZeZzg1RL9qb2J51WIvqJ4ElmtdQqXDGG6LKDEZqny/RD
         Jri1ImAOeEf4uKsJO2Wep3ZAeGPdgJRpooEl31l434Ly+KOfA51rY9TVXtOUYOh9p7uK
         jpIO4ZpaD2Uw5/dK1FTbAXgfW3zKksJU62J+cQnj6FBN8TY+YmZRw8X62VcXFQdhgVVv
         0VBSQ0n2VpCB/Q0fMjPQHFkNCstqO61reRHdD/6MVtdS/5XZzvMIosYOCdoOz7mD0N/J
         1Z+7qlUROObHfJpsRQSqPDGUW1PSRly4lCmeR6091iYOmkdo2OaOU79wHwElvGAsBMoS
         YKpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=whn6ElcSPtvDWMaZcHna4NLQGucnXh773vssx95SaXg=;
        b=xCh8POWMDla7eur6PP2/ZJHDgd6IPwp7vxAYRSbCX6hbLWHpfI8cN3lkKnJtClB45B
         GlN8Rd7bxWpic0UnsspsMaMwVCYeMU0fg+sGUH6k6cwTcWXMVm8/l2w6f2ELzgVAIvPY
         /Wg0WRngQ7MYwBk/WUVekL2JytuzIz9PclLYJh8kz+l2mLzYNVNFLuCE+1xzfKMNQD64
         RCFlFH15N4/XeUZXsvXAFBdRyQIvjU5vjNNw6Rr3BzmwMC6YdQVy5EKmG2Hqv5yw0k0k
         569Z34ELkXLJMxBKl7uDzqsSPRRk/OwzJeopW/xrRNfZdbZ2dUosMrmrudL7VrPTJidd
         6Dww==
X-Gm-Message-State: AOAM530ZxyuqocNBtlM82zd1w6tGxwl5NKqEL0iC7/3Bqqe/evUeorv5
        xqeJ/T+Hs9vU2zuf1MAg9ZdXLQ7JCKI=
X-Google-Smtp-Source: ABdhPJwUp+rqMdKaKHS2VCWPGKnofGXfCx3XP69QeSfxPuO9PZCmeYrZAbzI1p4rx6/FVG0gNrQ5pA==
X-Received: by 2002:a17:902:e0d5:b0:13f:25a0:d26b with SMTP id e21-20020a170902e0d500b0013f25a0d26bmr29742458pla.53.1634591919010;
        Mon, 18 Oct 2021 14:18:39 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q1sm10141721pgt.90.2021.10.18.14.18.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 14:18:38 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/103] 5.10.75-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211018132334.702559133@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1251692e-ef14-21f0-f863-acd718bc634e@gmail.com>
Date:   Mon, 18 Oct 2021 14:18:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/18/21 6:23 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.75 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Oct 2021 13:23:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.75-rc1.gz
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
