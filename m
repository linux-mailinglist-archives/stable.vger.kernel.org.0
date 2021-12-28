Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1310B480D60
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 22:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237367AbhL1VaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 16:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236326AbhL1VaN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 16:30:13 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62363C061574
        for <stable@vger.kernel.org>; Tue, 28 Dec 2021 13:30:13 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id v10so15203054ilj.3
        for <stable@vger.kernel.org>; Tue, 28 Dec 2021 13:30:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sJpLTpP4QDI6cfN8o3Q88KiR7SnhcBIGx0jwnSt1In4=;
        b=hmLRZsM3ffY25FkK7SAmoUymwLcavpa3tgE8X+u6r4mUgSjdffrxxYxvs7ksPthgB7
         o/45yeKvjQbsiqU03JZW7r17TCwdjdAWFXJNjLmcn0FWt7JX8GQmHcxYjwPk43QF+Cu7
         ta8vgSrnO+aag1PCVNEw+rVB9vNSaCpJpjGpQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sJpLTpP4QDI6cfN8o3Q88KiR7SnhcBIGx0jwnSt1In4=;
        b=v4nRFY6ou4R5jH7duKFjxuKeqcd7uiYSyBBvRcgl314t7yztR4d80HthTLBG5yvu+G
         54vfuAR6oxzr48IBHeKEHOE+ADJYritasLcIgjqK9OfRfysC5YySqltu8UphpFQ6vYjT
         A8HE0GNTCPe8LfPFE/PjV8lXAkD/6cpsaIL7joTQygeB2JXvgxnSOnKiwOyq0F+9pKIb
         CQ4JZ5+6+VaS89bN5ANIF+50LtIl+yHbk0RXpZHfMTnnKCx2WvQcW1AEnGZiUvBBdewU
         fexyIboOWUmqboA26qrqnUju8busRshGSiQKTwxlTQB9EKsgA5ZnngleqtARaFiK1BD5
         bpmQ==
X-Gm-Message-State: AOAM530bsxo+aTYx7jYkM3GP+FOaPJMkegwraKx0b40S70E1gyZ2expy
        RKJJMzOc7MGqNUtPw6yp7tOL+A==
X-Google-Smtp-Source: ABdhPJz/tzUsDxpl0TvrnLEgzd8CH7dMUYnFUxxnA37lA6qqUmAUPJZL98jW0rAdTdnw/bIKg2m9tg==
X-Received: by 2002:a05:6e02:1d86:: with SMTP id h6mr10395171ila.265.1640727012777;
        Tue, 28 Dec 2021 13:30:12 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id y15sm6606908ill.15.2021.12.28.13.30.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Dec 2021 13:30:12 -0800 (PST)
Subject: Re: [PATCH 4.9 00/19] 4.9.295-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211227151316.558965545@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <5bd74040-d49b-c428-712f-f1371e96907b@linuxfoundation.org>
Date:   Tue, 28 Dec 2021 14:30:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211227151316.558965545@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/27/21 8:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.295 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Dec 2021 15:13:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.295-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
