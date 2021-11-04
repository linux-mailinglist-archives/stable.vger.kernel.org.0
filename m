Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6314D445BF4
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 23:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbhKDWEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 18:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbhKDWEA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 18:04:00 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE5AC061714;
        Thu,  4 Nov 2021 15:01:22 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id f8so9520131plo.12;
        Thu, 04 Nov 2021 15:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3ZJ9OHknTBKUOmDKDGYP6Nu8yWOrkLnKy6CKvsqCuoE=;
        b=TV4NCUG2W+UvRzGZXq0S3DvEVimBV4ctmxDQ//ZNf8L0wyiUX2ryohj85YfogcDxVj
         3t5s8f2lf5+jY3AxN2tWGCuvl1RP4ZzNWPPTzM25jKJQuucLbvzCbd37mgpDTvN1kmAv
         CKx5zmHznXipgrKufhM1dbwIYAdoNB9UnzJ3/tf7aQl31hQxp8iSJ9TibZthl819gQsd
         fgRppc0RbbnEo6DCJJV1L+EKtLxb0YxEJWSK0XviIunI8WEWd2x9++eIiQKvdRNbeVnR
         5BCBrNtJLwiZBhPGIiQfBhvcTeejLPVlyaS/zuHCuuz1mFKBjxT0AZw6qcQ4diMYONs9
         MtpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3ZJ9OHknTBKUOmDKDGYP6Nu8yWOrkLnKy6CKvsqCuoE=;
        b=Kz8O7GmA0YqVCvLfZEeOs+NZD6Tj5YVBvvFemF1w2niJrRKNgI8aGPi0SvqWW9T4+A
         zZD2jShucJNX8kaOvL1QEN2K+78QaCLS70Fy1OQ2faQlk7QuMMw6K1rDZe9yriGbtvZu
         jr1T+/BxKhh3HaIVQT2w6TWEN8dnd2rHKh/7VR59aNghzfis+QJpplNlyQrvWLINtGfc
         IL0BQx6AKcDqJzOO5r/k1JQAHF4L51Y+WMs4U9V8EYQDxQlW1MCjuC+ZhU5D4iwaJKgP
         pBE4YMM62E9kOG7lWR8EjfYvVf8ls1YrNVV9z0CYztI2AM48sNYKUlYPES3c3R/HKicd
         TJ+Q==
X-Gm-Message-State: AOAM533ujgESFZsN3p4KC1a41zz9fpKvvuFyDJeJSj86xKR8z6v+toSe
        zdBLciQ8REEejnfFas1eeL+V3ccUR/8=
X-Google-Smtp-Source: ABdhPJxpZn/enNr3ZID3H78azYemLuRXVm+5EPOuuOwN7KfsY/Ht2eY4UJ6sUJ/XhdnAPmbFBcyBwg==
X-Received: by 2002:a17:90a:ec0a:: with SMTP id l10mr953485pjy.92.1636063281263;
        Thu, 04 Nov 2021 15:01:21 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id mv22sm4776107pjb.36.2021.11.04.15.01.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 15:01:20 -0700 (PDT)
Subject: Re: [PATCH 5.14 00/16] 5.14.17-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211104141159.863820939@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <dd22e11b-afa6-21ba-5d87-49f6bc6260d1@gmail.com>
Date:   Thu, 4 Nov 2021 15:01:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211104141159.863820939@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/4/21 7:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.17 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Nov 2021 14:11:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
