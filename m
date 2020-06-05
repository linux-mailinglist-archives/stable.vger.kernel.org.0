Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67F071F02C0
	for <lists+stable@lfdr.de>; Sat,  6 Jun 2020 00:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbgFEWLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 18:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728256AbgFEWLw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 18:11:52 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45017C08C5C3
        for <stable@vger.kernel.org>; Fri,  5 Jun 2020 15:11:52 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id o7so8830833oti.9
        for <stable@vger.kernel.org>; Fri, 05 Jun 2020 15:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8V5hic85NTB4BCMrwgvie7KOwB1pB6CZu7nqNX+a3YA=;
        b=SU9DQBp86kYcCXakYR/iEltre6dJMGNiAKuyOP/xU5Qn8CgHbZ3DejtlDImhLt6Jes
         BGH4gNcAUt0RK/oz8ZXGqj1eOPJanev1F4mXzfzVrdIzhz18FfHYRubmC/I7o4th22U9
         VXbj0MyqTIF3UzBwovLMxah9GJqc3YYatEyF0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8V5hic85NTB4BCMrwgvie7KOwB1pB6CZu7nqNX+a3YA=;
        b=RoGgrSKm15FycH45q9WV36B4ePpFJGSuZDMAEDl5JBW5vl9JG9/Ydn2H5uAWAmL9Jn
         2ZUH8zmsgX69PiPevmRWlC4zlrOw1DCSsnKjwWiqV5JNhSwGVpVkkqWIcdwK7hH162Rm
         oVKoXpoxhpBGfcB8++KCThL3PyShLpAHtos0OfNm+vTRPv+Lnp18Q0TRxKjYCRtfOuEh
         HeDbilAgoupS7kawy/ZrVDW1xdvJEE+kCG69ZLl/MqB8ktbNXdnd4uksUJ/eZJ3K+3Qi
         eLcE85SLpS1QRCkiz5mj8rTdqLXPC93KoPjOfxZNfxOakb1WhV4+X5GAeoaDm0xR5JY0
         sH1g==
X-Gm-Message-State: AOAM532RAWFdPp1qvtb/61PVZCTFDJbZycJgLfJ0yPMCPfx9nMPP4Fv2
        sqw8S3FeFUCdhFvs8WlKEaZ0Ug==
X-Google-Smtp-Source: ABdhPJxEzMZ/BxdaHLB5o03WPB71MwVAbSenenf167qBSXxJ3tXee/kwm3LZSEsGbUa19Qm4DItFkw==
X-Received: by 2002:a9d:6a87:: with SMTP id l7mr9005247otq.265.1591395111455;
        Fri, 05 Jun 2020 15:11:51 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id q65sm950420oia.13.2020.06.05.15.11.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2020 15:11:50 -0700 (PDT)
Subject: Re: [PATCH 5.7 00/14] 5.7.1-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200605135951.018731965@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <ca04681a-77a3-09b8-d399-a27f1e48ba75@linuxfoundation.org>
Date:   Fri, 5 Jun 2020 16:11:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200605135951.018731965@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/5/20 8:14 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.7.1 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Jun 2020 13:54:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

