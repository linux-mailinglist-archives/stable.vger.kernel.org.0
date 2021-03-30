Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC3C34DD76
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 03:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbhC3B1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 21:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbhC3B1g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 21:27:36 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B79C061762
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 18:27:35 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id k25so14733229iob.6
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 18:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ieH4cGJ057jdP494AB113ZHjlRAQvNqA8HxgvQRjqJM=;
        b=gQhroBIXUv+44b3EvYpR1En8ktk+bbxfQu0TdEOIt9PFTqDEanl1koN/5O4+pFHiax
         /uPZZUTaFbz8Lh3R+2WlZLn18X53jqS/rAoHAg8v2wRG7NgjKq1aZ8wCfJWOXFc1YZnu
         z2iccbcRBSnnwNQsLagc5CuWR/PkhW2XftnsM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ieH4cGJ057jdP494AB113ZHjlRAQvNqA8HxgvQRjqJM=;
        b=rYc2MYy2DZAxEj9aN2JFdYPkpx76KqmZbigbQH2GnHXd0FEsV/Sr4f8UBTlo6KVCoh
         yfTh0qjzpRAiGjwuChN9cvGqgktuSuCqgf4Lh1QkZS/cogy4VhYYX/BTUNtpujKu9SWF
         WmfILg3NT87Nj2XnB1jB0fkPu4JXmTk0LrTnMtkrmu5j6C/aOzALtIiqqF2Ol/KgpgNp
         Y1ShB+PkPYTQfMgVOOmmcHpGp1iyNMwH02r3UUzva23XPqkQQd3TRGorsMz7PZDgQTi0
         ckPND/1VXF9THMW5AxqiC7swb+JKRD62NNHw7IkdjPfUWa20UkVaRrps4517gR928y+u
         lcWQ==
X-Gm-Message-State: AOAM530+q82lWoauvsAd+4I1TrxEnIT65f/DwWPltGyFG5Kf94mACNh8
        gpryc2fZ55mb9NI2o2rEd4bllQ==
X-Google-Smtp-Source: ABdhPJyJ0eSPRXLbKTS6MyvnMvORGl76AQRyD3bDeZ9O/nBmn7PaklOJseMSdCIxCLM+qNsxpqx6ug==
X-Received: by 2002:a02:3b10:: with SMTP id c16mr4777602jaa.48.1617067654663;
        Mon, 29 Mar 2021 18:27:34 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id x3sm6214336ilg.2.2021.03.29.18.27.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 18:27:34 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/72] 4.19.184-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210329075610.300795746@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e8025442-6325-1f4b-894e-b554b7458254@linuxfoundation.org>
Date:   Mon, 29 Mar 2021 19:27:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210329075610.300795746@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/29/21 1:57 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.184 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Mar 2021 07:55:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.184-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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

