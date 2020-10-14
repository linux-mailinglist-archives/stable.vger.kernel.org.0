Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDFEE28DCB6
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 11:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729857AbgJNJTl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 05:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729983AbgJNJTj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Oct 2020 05:19:39 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF51C008654
        for <stable@vger.kernel.org>; Tue, 13 Oct 2020 18:24:27 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id k1so74068ilc.10
        for <stable@vger.kernel.org>; Tue, 13 Oct 2020 18:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KiZcakbvkbCHsSIpfq37GbfBUxqbiIE2aR7l+yA05Aw=;
        b=ZMnwUwt7ao1Kpi1C273z2/+AdAiOIyVPDbClc7jJzD5aab6wKKFfSDHEdKOAPYKC5a
         ryxqTQh/61CuzRliakRgCJ3Ec3hMuhy9wOugzNy6sl5YvuvMNj2jsROW+sI5NhxZS5aw
         ltle6K3o+w8+6lAZAi2qJIxcsPsakY6CFHRDo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KiZcakbvkbCHsSIpfq37GbfBUxqbiIE2aR7l+yA05Aw=;
        b=Gr8o8+k2t/zRptxwwZ2lnA/eAfibYbEE7/Xcm82ml4WHhyVzoCIjj9wmbpKuL8J9Hv
         RPWK0QqtAARDv4O1WSxZLoiE8U2F9ei8VAd3MrOipdPEB+G00hykC7HFc0HHyMFIdA/h
         IYmDZhlfiLT/prq5rcWZFqd3wbZsE9gch7dMiW/7DYx/7S1OGNXKgJ0yGsAN36PmIz7c
         Gd4fqBfeMrwWEF4kEL4KW/oUKje2lLjMr4Hjxj34ys/hYelpbd+Qv5ejFQXQ+u71UsYO
         Y4NxLO/Vd+QVoiKFM3xtoiCheSM6/3eUbaOn9RVTFsHiTDzaJs01a719TdVDBxKaBrRf
         cjPw==
X-Gm-Message-State: AOAM533B5PyX+xFuHEqffW3J08g/OuZXdRL2Qb+mFf9TYUTazmpgW082
        o7EzX8v/aXdD+PS9kW3OjFzMXTvJkRVX2Q==
X-Google-Smtp-Source: ABdhPJzek7ejnHJIVGx+ecHmkFXZ9kbkgJE/LtfL94AOTz/cZ1oKb6n2tG6M+5AER4+a4EGoPgtPRg==
X-Received: by 2002:a05:6e02:1045:: with SMTP id p5mr2051536ilj.87.1602638666955;
        Tue, 13 Oct 2020 18:24:26 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id z200sm1524560iof.47.2020.10.13.18.24.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2020 18:24:26 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/85] 5.4.71-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20201012132632.846779148@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <0e7900f5-c079-c378-2703-697cfeb12b90@linuxfoundation.org>
Date:   Tue, 13 Oct 2020 19:24:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201012132632.846779148@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/12/20 7:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.71 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Oct 2020 13:26:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.71-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
