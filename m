Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276BC454D9A
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 20:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240307AbhKQTFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 14:05:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240306AbhKQTFx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 14:05:53 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8093C061570;
        Wed, 17 Nov 2021 11:02:54 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so6025205pjc.4;
        Wed, 17 Nov 2021 11:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rMY8qG0cTAr/XL80xfJt/iFlXy7f1UseUxBfTLe6U/I=;
        b=AxatOd3X7fIQqikggpApX3VZvXK9NrVQUsi/0FyMN1kcaN4maODrlMWOaPp7wBtnRV
         ZFvFK3U2Hoxt6oYePxn244HPdoEMVprC/lp3oPXNg/k4YgfkX8fbTtZovudLc5NXP+c5
         25u4e7XAQwYUC/BJuM/GqqSbc9noNq1NFDozRyxHdEvzhWIA0F5pajiG/fM203zB7kmw
         zLUxeEv13oCs3UfZmqgz0WXhjXa0M9ojIc7uXzo8EG3duBJZE164lYmY/9jqJ8HI+Xpp
         Vnz6r99PN8pcL99JdAFUCAWSUFmKHNH3wHdf0LWxVvaM5uPW7KmiAKIX8TKkyuE32Tz7
         wcrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rMY8qG0cTAr/XL80xfJt/iFlXy7f1UseUxBfTLe6U/I=;
        b=Pd/JLiZBcyUA8KU2n2hEEO7nzlNc7f5a2iDx/RotQFOsUw85xk5NNaVTl0Kw5Nc2Be
         0z5J7Bl9vg71zVUGnYct9SLPeKsasX7UYM765Vf4O1OILtJXCFjNieaUZwJjU1HfqSmW
         Wocfi+PN5MMsq7cVZe4k49twXUd3X9zwcn3InUNoJnbO0HK2CYP20zAaaSs09g7aE7WG
         kpd/mKsAoGhzHk9QOXQqpc8ZHO9AtXDN1lJgCoN53WFPTezDI3YUSdE/9vZyYNj5DN/s
         W2abexPO62dd/eTmV8ba3oq2hcQfnHM6/gauFh+lAuo2PJx232jCiJRSqSvEdL33h5id
         4vFA==
X-Gm-Message-State: AOAM531q9vijvYZ6aB+AfSq7sdwkA0F1xfWdJVxcQMuZx70dGTI+1WQj
        NwDeTKBgzH3t8BzNEje1t1Wfx6VZGGY=
X-Google-Smtp-Source: ABdhPJwomMbvuPw79ubWdCN2tNq4Exc56IOz3PPUglHowPI1WBefwmzRIIifJ1/0x7spBJSQotygdQ==
X-Received: by 2002:a17:90a:8a82:: with SMTP id x2mr2323528pjn.187.1637175773867;
        Wed, 17 Nov 2021 11:02:53 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id fs21sm5047629pjb.1.2021.11.17.11.02.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 11:02:53 -0800 (PST)
Subject: Re: [PATCH 5.10 000/569] 5.10.80-rc4 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211117144602.341592498@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0f0a5139-ee4a-d30c-630b-55254e6537d1@gmail.com>
Date:   Wed, 17 Nov 2021 11:02:51 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211117144602.341592498@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/17/21 6:46 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.80 release.
> There are 569 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Nov 2021 14:44:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.80-rc4.gz
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
