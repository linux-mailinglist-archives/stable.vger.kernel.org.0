Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D4B34D63E
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 19:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbhC2Rt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 13:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbhC2RtL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 13:49:11 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383DFC061574;
        Mon, 29 Mar 2021 10:49:11 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id l76so9886257pga.6;
        Mon, 29 Mar 2021 10:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=alD74IFAXQEwKYTbtkg5WVYKect/IaprUkdk5NWf3Qo=;
        b=jO4n+ehyarH3mbYFi7EGWu63AM28SP3fHpsAfbCi1F3/yU33oVbfjgssgD2Nu8vFkO
         emGc9LfbW1N0ZDtiYBqwITkBg3pET2D0rb5yD3HwJwI12oT2Z7TFSgI7G3NMa+HOyRx9
         skj+OiJ0ClcOZdZYm1o3LO5PhtO3AxW4K32aYy3h0z+CO8LkYG5xgrDcyxbnjEYOapSW
         tjMjZ5V9BDJ2NSK29aKwYmRonl+tv4R6mcROyptkvsLEqmKBiujomJF8Kaa/HIPNwryQ
         QSXGhzJYWdH9DK4FCKDVxTqyzfVLgJWQ8950Z+EDAuwtRD1Q6EbnXcMyk9NE2HBJS4cz
         mIjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=alD74IFAXQEwKYTbtkg5WVYKect/IaprUkdk5NWf3Qo=;
        b=jwsuf7xHW1+8Q+TuGTDOeXKth9HX4sh8lkQRN9xdvanRcwFcLiSo4fF++eiSimX8TK
         5RM5oUUqX7nTSilhN+KyD2BAY4DX5W41hElbeuDXBd2cHGnWmZZWFUb5MD8rfkknZ5lM
         g192zXry1QDnE9+7mGhvEOB57V/lSF09YAZIlKnzNpTLLIDXIUDsdr8BKZRhs9dOmYre
         4mFQroQKxFlWkgmfdQbOOMWKYfPRQAX7cPJH6Ox+j9sr7jzYDqlzDC2FFIbdt5dxjg6m
         MtQLUE3TB7rkAXQHvzeWjmgS1eNgCjTu1URC5yoehGxMKnNUw9Em3EW67MM2NTPNDH8i
         6fUg==
X-Gm-Message-State: AOAM532DifG4FeUouNCxTV+BWkCVGbpHhjXRQGtLGyFSxiszDeMW7T2N
        DcWDG4niXDZjf7tMVU0T1pj52jd2xWM=
X-Google-Smtp-Source: ABdhPJz4vQGopnrBSqxGq3ta5AYh+YkIBUEzgGwh7xwl/UB5WFllQWo7wTN9tCTKOfQLuf2uFCP++Q==
X-Received: by 2002:a62:17ce:0:b029:1fc:9b43:dbc5 with SMTP id 197-20020a6217ce0000b02901fc9b43dbc5mr27021106pfx.75.1617040150347;
        Mon, 29 Mar 2021 10:49:10 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id gb1sm123385pjb.21.2021.03.29.10.49.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 10:49:09 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/219] 5.10.27-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210329101340.196712908@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e31d6712-d6df-7cb1-fe43-ebfee4ca796e@gmail.com>
Date:   Mon, 29 Mar 2021 10:49:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210329101340.196712908@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/29/21 3:14 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.27 release.
> There are 219 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Mar 2021 10:13:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.27-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
