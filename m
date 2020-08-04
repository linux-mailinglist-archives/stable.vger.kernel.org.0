Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A106F23C0CC
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 22:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgHDUgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 16:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbgHDUgo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 16:36:44 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C281C06174A
        for <stable@vger.kernel.org>; Tue,  4 Aug 2020 13:36:44 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id v6so20823961ota.13
        for <stable@vger.kernel.org>; Tue, 04 Aug 2020 13:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=seeOjLMrqpVnUq6/RwDe6n5PWXIo5DZNlxCTXS/G8bk=;
        b=ZoRg0WrJH3iB9ea0HU4t2VDqDb1oVNqSzfgWiT2wNsrX/662A1GnDaKCAOkF4gG9aF
         2TZhEVmK4LEcG5cUJlzOOqUXWRE307OWk/81K/wBatW5vTMVB99P01PILIY7GpDQZ+I5
         4AMmesrG1U5S+06ZTwpaHAWKmZp8o0GWuFhsY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=seeOjLMrqpVnUq6/RwDe6n5PWXIo5DZNlxCTXS/G8bk=;
        b=H9FqJlJkUHjf1w4lbkTahTIpuKj+QthhzVsFXavau3nKTmO3imxQbO3GHwmj6ZbNjX
         /skzYlkPxIybrb+a1g6UsTaoyCIGZ49uVv8LvJU1VHZoDXuVyzVaiFax7UC8N8cUnuPe
         EGmm7pisPm+PmXG3KHzV7aGIjfiqRC7m/t/M1dvyLN9YkGQSPMOtRVeku0gmS+BHT6xK
         eqLPzYSHK2budSKInpbl66aZz1/w6lqW9r09dxoNFTMKL8VbMM/Rniblrx6I1Z/PxjuR
         Xwcu6vUqa/8NIp2PIe56k8paib19gKvv9NGe4L14eSAClFSeDWvXUr3rA3AdNRmxutqz
         B+Ng==
X-Gm-Message-State: AOAM532KvMLByBQPdm8/PVSbKHepTHTOZOnRNlLAjDHg7WuOUyDeqt1T
        CJ2FO2UBIcQWbs7ZRKZ+5dER+EUMeIk=
X-Google-Smtp-Source: ABdhPJyR78mYsK+sdEf560Iu4wBFXC24d+YOycJqoDxw40JDCH1mSgyi5AvrHCIIw3jU2718T2UaMw==
X-Received: by 2002:a05:6830:4b1:: with SMTP id l17mr13932923otd.297.1596573403256;
        Tue, 04 Aug 2020 13:36:43 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id y67sm3717782oig.46.2020.08.04.13.36.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2020 13:36:42 -0700 (PDT)
Subject: Re: [PATCH 4.14 00/47] 4.14.192-rc3 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, skhan@linuxfoundation.org
References: <20200804085215.362760089@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <ac9f888b-72f8-5fd7-1db0-132af7322042@linuxfoundation.org>
Date:   Tue, 4 Aug 2020 14:36:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200804085215.362760089@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/4/20 2:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.192 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Aug 2020 08:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.192-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
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




