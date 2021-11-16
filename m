Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8DBE4538ED
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 18:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239175AbhKPR6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 12:58:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239092AbhKPR6K (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 12:58:10 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42A9C061570;
        Tue, 16 Nov 2021 09:55:13 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id j5-20020a17090a318500b001a6c749e697so2614981pjb.1;
        Tue, 16 Nov 2021 09:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cBl6V9vb6+EfxBd2TrL5j483Hvm12MJk9yWlcH5uYcs=;
        b=QthAXDDzI0dITGIEVs0zN6BtiStvFlVlNpbS6CWzQRf3Ajb28Y8unpGv0xDUmWTLhk
         NsXrMdwiIf2czDqQRe+zE8TlQdXhcDn5l3EzAicVE7otAbuS6AmVLEpGyMT3IwLDpa4p
         tTdgPyRFmwwoZjXQxzS9xs5VnfocaG1eJUVxqa1/mkTKIeE/V4XGK5gWA2AuARlEFdUs
         wVVvDa+ShrjUU3bus7OXE6HKTuL1FrJ2hk2IzCqa02G7xbu4IbjRT/B2xhrEJVRPkNzY
         CXY4oGrCk72LNahdag1uSgxW4l4qwGxjRaiiX7mphovnY8TsLu8h2TCLSRrR3gbCCtND
         B5DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cBl6V9vb6+EfxBd2TrL5j483Hvm12MJk9yWlcH5uYcs=;
        b=r6lLa5musMo0iGvpA1uUOf5JItoj8T0ETXm2AYJ05QC19QuhlDYcVIkHtOXvS01aHl
         N/0XOpe8YQMkcRojeyMrJDuEi7yDABdh+Y+VYh0/J+aybQISC/wOO+nbhQ6ZCeqv9i8G
         PRUzEgXNUIbSo+PS5DK0L0wwOLbzI+iRUOi8AoqOnIzQYDZOWcwOC3USCDuwXwpcNAQ5
         at7ir2fLBrPMtl6euOkwDaBJR5edgxG6uHYkD6JxqTVsT6IOKXyMdrN8wKbrHbb+KLbm
         dJlM4X5joWiyH3G04ty9yHtTYNYbTmnOQJEOxWkU359H2xgQBcI2xk1Wb06jHy4UPlS3
         9xUg==
X-Gm-Message-State: AOAM5306ab+NWBp+onRnrTptSkXrgTvBl8wcGn+vhhKI+K1UT9bcDwtl
        XTKgJ71JwLY+Q5CuLDcsO6S071xq7ms=
X-Google-Smtp-Source: ABdhPJzrDpAfBofDDZbY6pW4egmEk52QpxaEGvKfmno88vOuwHoQbqXGzGhCTz9eY6Cpchb1MW06vQ==
X-Received: by 2002:a17:902:c745:b0:143:d220:9196 with SMTP id q5-20020a170902c74500b00143d2209196mr5137564plq.74.1637085312805;
        Tue, 16 Nov 2021 09:55:12 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b18sm2891156pjo.31.2021.11.16.09.55.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 09:55:12 -0800 (PST)
Subject: Re: [PATCH 5.4 000/353] 5.4.160-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211116142514.833707661@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <dc37fc0c-d240-0f14-fde8-63b316ca8bfc@gmail.com>
Date:   Tue, 16 Nov 2021 09:55:10 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211116142514.833707661@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/16/21 7:00 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.160 release.
> There are 353 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Nov 2021 14:24:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.160-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
