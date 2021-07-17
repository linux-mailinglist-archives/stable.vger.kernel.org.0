Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756593CC003
	for <lists+stable@lfdr.de>; Sat, 17 Jul 2021 02:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhGQAMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 20:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237801AbhGQAMO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Jul 2021 20:12:14 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5BBC061760
        for <stable@vger.kernel.org>; Fri, 16 Jul 2021 17:09:18 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id p3so9872662ilg.8
        for <stable@vger.kernel.org>; Fri, 16 Jul 2021 17:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nT6S9XBlod+MaEKyHLtG4hQxDplBs0InR27BBmersIE=;
        b=TnssCoU7H8DLqkj+IfVRC6uPokevlwUScIhHIPyfbByZpuWu9WFQ6q09TFYPqvLU5E
         m9yzxCsw/m3PzwXNpUKyeaXjxNVRN1Iq/aYmNZW5y6RpFgxUJgTwrwxuScy5E7lyg4ba
         2jOcMNm9cLVGdxSGTsTlm2a2/9D2rqetZf9l0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nT6S9XBlod+MaEKyHLtG4hQxDplBs0InR27BBmersIE=;
        b=hOKujOzvcYwooTzQg9/4HVOz3yp9795Zw0Jqzbu1X0vWYetn2f6HKHT4PPf5gfX9it
         0/onopuGlpzHFySU432EapMgwv+j/dg5Yn+EKjG6c+JTPWNrLlw4J4dU6OShXEShVPKE
         Iy6wwU23WwLTkOYtNj6fVjnwlrQ1Rr1mh64Aps308Gyr5sDiqP6Q5c+1xKbFc6BcN6WQ
         UOomJeqm/Twmp5o7tz7+JsUap33AuB+RQAlAZn8/s/626iENiE61/GFYQYLzCpSKbvtl
         4aOc1R50n6+iE6hQXl3rTSYsXL82xttIz9hvXFPlU38OOTOwcog/Z41iaxlSuXcro0cu
         Jb/A==
X-Gm-Message-State: AOAM53371SwrnToG02imWCPLHLSB9z018fbSJNw8o+htYyuHQhVC9aoq
        cEESYOyLP/L0s5HXtSF3BHVzgw==
X-Google-Smtp-Source: ABdhPJz797rMjUEDul8OZGxRD9FdEc3+1rXKerZS9FMTM30/Nw2K69SlTELOz6LfPHdDW7SU5tbxlg==
X-Received: by 2002:a92:2a10:: with SMTP id r16mr7921659ile.223.1626480557941;
        Fri, 16 Jul 2021 17:09:17 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id y13sm5706088ioa.51.2021.07.16.17.09.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jul 2021 17:09:17 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/119] 5.4.133-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210716182029.878765454@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <44d62c5a-ace5-6e77-2f20-7e6ae903ee4c@linuxfoundation.org>
Date:   Fri, 16 Jul 2021 18:09:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210716182029.878765454@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/16/21 12:28 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.133 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Jul 2021 18:16:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.133-rc2.gz
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
