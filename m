Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8601144CA2C
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 21:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbhKJUMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 15:12:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbhKJUMc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 15:12:32 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5EEC061764;
        Wed, 10 Nov 2021 12:09:44 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id p18so3880898plf.13;
        Wed, 10 Nov 2021 12:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3ubNtsB/mh2b13W1yOgQi+MMV4lMAJM1Ryt/blzWJfg=;
        b=DWeJrt7Tf7OyoFjhttoAZTZ+lpLogA1sH8mfJZzX3vnosP7CSrompYqPtfF29omlfc
         hkYauxP/ApgiJEdxjZbA7fftU5kr0SZSZioYnO1X1SFQ0W1cc5DU0d4UqCluPcgg8sZ7
         gmC7a8n0tKs9Ed4bAPZx0E+xFj0D7VjIZvmmBrMfZBs45b8f+GSrF7EkX826bxSvTYN0
         BfYCPFcpLO4LUiBUgAKO9XxQYf2nU7tLHm/KjG11xdcURDjjWMa+C93Umn8rxjrJ4E53
         G3tDyN4Nu/1y6ZYnLC2XLUTm6KNDJju3sw5QqpIEJrshIWYdQK0yMHkSFG+I4HGwpCKK
         M1BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3ubNtsB/mh2b13W1yOgQi+MMV4lMAJM1Ryt/blzWJfg=;
        b=372a+wNhcNhKYoNZqVGq8zGbW6ZLO5KjscqtyTHLBhTRJuB7WwqI+VlkdQCT6OvKHR
         ewWL/y/5Uw4SgI3lDasXHjb6eTeLrfgV/WOoAOMXjjkRDSE4jfI/dD9ODVUJ+dAHcV+W
         b2gyzDE/QY/MkJKEHYrnsK3kJp7N3n/tICltcSf0JOE+HxOM210Mk+G2InOANj3HmOZ/
         1P1vsHm71FBme7s51HFhv+NoCwBuPDlByPQf3jPfXX2PV2IGmPzs2elT5lDxeSPjp35h
         mgujyqxnXXEqqyTJEWTjYQNGAeoaRNYhoJyy3NtFrsRU/JDflu1/s9xsGRDYAbKaM+rh
         jKYw==
X-Gm-Message-State: AOAM531yFb+D33E/XYrf/ZuR9biSRYT1f51mJSUKfwDP/sA7xwsyFBFe
        uzmFPi1ChQ5ZoW8ofIOeAmjLaC86vDc=
X-Google-Smtp-Source: ABdhPJwQDoNpvj2uFPxBzcew2c52+hCN0IG4BdqWtEgnyLG3LZ1Rljdve4rcoefJZwPRvR2M+p8CLA==
X-Received: by 2002:a17:90a:1bc5:: with SMTP id r5mr1863700pjr.90.1636574983418;
        Wed, 10 Nov 2021 12:09:43 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id w12sm6650570pjq.2.2021.11.10.12.09.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Nov 2021 12:09:42 -0800 (PST)
Subject: Re: [PATCH 5.10 00/21] 5.10.79-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211110182002.964190708@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9443d5ba-9b17-bd64-43a9-ff91e23c4273@gmail.com>
Date:   Wed, 10 Nov 2021 12:09:41 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211110182002.964190708@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/10/21 10:43 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.79 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.79-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
