Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A40396B66
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 04:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbhFACf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 22:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233048AbhFACfk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 22:35:40 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED25C06138D;
        Mon, 31 May 2021 19:33:59 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 22-20020a17090a0c16b0290164a5354ad0so566768pjs.2;
        Mon, 31 May 2021 19:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D2ijEB0mlvI7ttofMvaKpUu6VIfdP4tcMZTjbgP9q8w=;
        b=o0M3jlQG7tZ2l10HcqgpQb52sBfHiozsWJisy3rKpErUYbZAoYb1+C/kezHi4F/Xec
         1HwsenjHzkY749X1HHjJHkHjHJ6AxaBID9Nm3lNhvPx3SmUkMX0VTCayrnrEDoE6pEai
         np/DpHiycJQqlITmPD3syosOQ76kgSeJ+yvLyPGd/wcF1STEaZFnFX33gnGnRKjVQJed
         vmYFbP8u0NhbzCfRZrfMP4+t2UjdqW077KMANTwTwwMzO0XKKtUJBrcBtDas2nRnNBX5
         dMP6fxZIAPTqm496KjO98KfRJUPNeJrFBx1PQUiFIwg56XSghY0meZYoY+bUlhD5/x1H
         FR0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D2ijEB0mlvI7ttofMvaKpUu6VIfdP4tcMZTjbgP9q8w=;
        b=bmPwNhqH9ZKzvdW0mK3RCQibEUNa13d8lc0sIwtQex5S9eFocFmSEYxOrs5PG9fIxz
         fOJGqXueJWk4Us+Ot5NSVzgC1IEdoxHd7bv1t69BZcfBHiucqwZ7WTQjSbmTj88c7mxA
         UoDRsoyordQE9j6/5WJsGZVN2L4qBwNeUWOWCj82SS1Y3I1up4F7mHprCGEcTN5CVNvM
         qPuKUTO0OlZybmEWjE3IaHHPVamdUKJQHLfoBCv0FcwnpakE68TKmyKNUQwXPzMz+mv2
         Kmw2z6mL8wCW46QyG7+2KBizr1jGcmDHtSoQ0e5fbW4xZ0klhgw6CjV5tFYA5xSaihi+
         yG5A==
X-Gm-Message-State: AOAM5324yu1cXS3WplkmkvHKey1aABb1WJTVzzpIz5GtiQ/zXg0vQQ/N
        s/6UNOoCHZomjQSDoCP7BnQmEHaSyf+ROw==
X-Google-Smtp-Source: ABdhPJyVMbeWKYUfulmkoox0kMFj4u6Aajc+x595lAog0GVUg/GhSNL/yp2oqK66zWl9/6Y1ebRZVQ==
X-Received: by 2002:a17:902:eb05:b029:fe:e0fa:e1f1 with SMTP id l5-20020a170902eb05b02900fee0fae1f1mr10656001plb.10.1622514838707;
        Mon, 31 May 2021 19:33:58 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id y6sm5240516pjf.40.2021.05.31.19.33.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 May 2021 19:33:58 -0700 (PDT)
Subject: Re: [PATCH 5.12 000/296] 5.12.9-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210531130703.762129381@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <04177842-a3af-5155-2cbb-7b41d880784d@gmail.com>
Date:   Mon, 31 May 2021 19:33:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/31/2021 6:10 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.9 release.
> There are 296 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Jun 2021 13:06:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
