Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6CE4576A8
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 19:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbhKSStR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 13:49:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbhKSStR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 13:49:17 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9D3C061574;
        Fri, 19 Nov 2021 10:46:15 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id h24so8602429pjq.2;
        Fri, 19 Nov 2021 10:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T2aeOTBg5hjgQvkFJRIpNPgnR1WJc1bK4snmF+0yoKE=;
        b=PnLzSSFbhURpPRy/zM/JtdFDN5rU+t/PGJUgc+sPgz8ZsBeBhbjMLxNEvKJpbawlcy
         0qDUt0AaXqSkr4Iu9CeeYLFqf5M/OWvb3Wj3lr1f+bZhn8asetjpGhbYHrrs/TxHnsiB
         sGmJg0GzlkTg6Og2OFcfPrwtTR1MHAeN1sO8MKXZKvXZvgnHE1Fa0EgAnunpoSR06zF1
         W0SCK1Vu7R7xFezoClfbBooFliyVh4oxF59OvQvbKU6RSjlJ2msbB5mryN0pJdmA225I
         WsRDTf5VV40CjhkYA+BJYwdC4EBhFCNXgIGGBEwqL/g5VMQmcnC7nIizOpeFcgKwpEIW
         9KwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T2aeOTBg5hjgQvkFJRIpNPgnR1WJc1bK4snmF+0yoKE=;
        b=u+UvQm/qNIJwtnIPIhgXLY5YHBa6a8fyw75rcgAXIZHFhYkkAZrpmto+KlLuLrmXRe
         Uyyo80w2IEqve2mi3KjnlV+9SlExhAiDb0F6FZm6Rfa0ZVW9/wTIE7DQNvfRd5RaEhOi
         jkDogRtqnq7c5HlGebbwUXGm0c22zNOrHGLCg7MFKeHf9V8Lc2gHe7/4nTOhFme/WcmQ
         ldbLUDHQ8YFbLcwovFJp6rKgRefWcCCwRC8XQ46vWcDVBC+EG104z+INzA7AuZgMfrT1
         8vVd9oOmZvv/QTeUuBZYqYyFV4XoZHrjtuAgcENi12Eji50fv7FGD0NKDQioa42+ePtC
         YWaw==
X-Gm-Message-State: AOAM532C35KBqlfKuIK80O4l0f+hFgzk35ie/F/DeAwgZe7KIJfGP5me
        wXa9Kas5TAJ+TiGaNySfjGwgxKKAeZs=
X-Google-Smtp-Source: ABdhPJxYYp2RPgMaPWUZbVZhNDfyATtb7n+OaDAP7QN92NFNqO7f/0qeuRHm3Rmn8q46JPMRMoZ3EQ==
X-Received: by 2002:a17:902:f092:b0:141:ccb6:897 with SMTP id p18-20020a170902f09200b00141ccb60897mr80045480pla.89.1637347574126;
        Fri, 19 Nov 2021 10:46:14 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b19sm411422pfv.63.2021.11.19.10.46.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Nov 2021 10:46:13 -0800 (PST)
Subject: Re: [PATCH 5.10 00/21] 5.10.81-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211119171443.892729043@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5000691b-db08-2081-e7d6-c5c065aebc64@gmail.com>
Date:   Fri, 19 Nov 2021 10:46:10 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211119171443.892729043@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/19/21 9:37 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.81 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Nov 2021 17:14:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.81-rc1.gz
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
