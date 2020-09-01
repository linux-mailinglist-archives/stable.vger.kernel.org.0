Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0792F25A15C
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 00:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbgIAWVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 18:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbgIAWVd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 18:21:33 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2251C061244
        for <stable@vger.kernel.org>; Tue,  1 Sep 2020 15:21:32 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id i4so2595056ota.2
        for <stable@vger.kernel.org>; Tue, 01 Sep 2020 15:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9sdyF6sknnMonxVkT3RxfZbkTai4U5uWBnm7ioMmgSA=;
        b=aNH8dEmtAAvDI0rdMQyBL5J8aKdCZlWSyxLBDR4BDzoyQ/DVR9iXxa/slWiGN9E9MS
         oJY9g+n+6dhZbcANwB7zH/YHHeMwYNqkbNpo9VY5WyrkTrAyDAXctl4mfLxA0Ou6AYWr
         imuWZ36tWhci64u015VYfNNsQiW/mCC5Zwn3o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9sdyF6sknnMonxVkT3RxfZbkTai4U5uWBnm7ioMmgSA=;
        b=YmL0TBhlsOVW0+LSECXp0Gnwl/z1B/XlaxKGoIsMM1VsCqw9cizwnNOPuBIwZQNa59
         vCcfqh38VwOl8kFauGGmkAqBp/IkNrlvH3QewsLAkgypXa+Temeab/Ou8fla4UBUT/74
         cPap4ju8+zYvAR8ZPKYinf5msn5+cY937GDKPdKDQ2q5bRWWu4hvZTdwy+gXvt4Lo1q7
         BFtr4/RMCzBFACfVO3qBXn5sHc2D+Pw3kYnsCiqtr0DadNm4N6Cp/Lmp/6Q4SMor3sUI
         l9/MJ1d1kqVuCjfFjV4DHInOri9exYIxU6Z4Ev0oWmlVRF8Gx/7cA9CeN3j0KoVJ8cr3
         01xQ==
X-Gm-Message-State: AOAM532o1I7NJKJABwVNOC+DqRvxkIG86lb+995lJSdekm7BWQOFr4bf
        60d8X47frWR6vdvarft6EJejiw==
X-Google-Smtp-Source: ABdhPJyCkLs+KYIvJ3Q/pdfGbhcOB6ilSGR0J6hp3rM//k/J7gNGWQmcipkj02sGP7CNHRQlX4VVIw==
X-Received: by 2002:a9d:7b48:: with SMTP id f8mr3058285oto.297.1598998892406;
        Tue, 01 Sep 2020 15:21:32 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id w19sm416228otq.70.2020.09.01.15.21.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 15:21:31 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/214] 5.4.62-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <4fe1bfa6-8d3a-15f9-5b22-701b9915a95f@linuxfoundation.org>
Date:   Tue, 1 Sep 2020 16:21:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/1/20 9:08 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.62 release.
> There are 214 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 03 Sep 2020 15:09:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.62-rc1.gz
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
