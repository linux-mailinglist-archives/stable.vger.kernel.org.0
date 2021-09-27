Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C09341A377
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 00:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238034AbhI0XAu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 19:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237772AbhI0XAu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 19:00:50 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C76C061575
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 15:59:11 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id q14so21154588ils.5
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 15:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vwSbvNE8SFizMBN9MdufQScN0qnWB45/icxok2QC3vc=;
        b=NQKNt/hcDLBvDewYKq5qLZKO6H4ZeoPmqga71BE10kwp2KQIRs/KoUR0Mx+mNCaNHj
         yybVqUYLJmMt9XJ6cf+s+IUN6T5A2wKtPudUdTYF9k7bQ/7hAYoE/jIojApWzrV+WqlB
         LB3Js/R0zKFNSVSf1RLs5+ouZvJbqA/zTX7Lk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vwSbvNE8SFizMBN9MdufQScN0qnWB45/icxok2QC3vc=;
        b=1eRdFz97hArmtkXQnmo7ZQTuO+IY8oggygNNPb8sxRjIQYjlv6gCEejQYWbEVq1Ltu
         +xuV08nxhF40tUfM5t/Zsi3peTcYiw4U2VZeoa+Nbp5Hxz3IxrTvvD21tzgddFGYMXL8
         4TGTHN4toG/xoLHIigaqNd4Oo7a3DKqn/FJcr0KzD9744fyRDTUhNeAEyzwHFVE6GcHp
         0ozolbIIy2kJdGJxaQC0N/2ja0ix6+mcGnY1e0vZ28tmAnUZB7rtN+eR0diBFk5cxeS9
         rdfmSYrKMnnNsABcXu8T8DV1dKL2TVgSjduV1GyKkdc5x4qb4kktEork4iqKlAhYkXkW
         gxGg==
X-Gm-Message-State: AOAM533GLDD+P/wQ3Fd7B5L1ixsmfdNomPY9G7LF7B1RdMdCMj8WSYHf
        uc6z8NdIrDAXMYHUWVqMm9lWYw==
X-Google-Smtp-Source: ABdhPJwBEuIvATf8ZvtYH+QFdkZFKFsiI2ouqWydcEp+plseXhkKTPhPawEJPSFK5qJG1770GsSaiQ==
X-Received: by 2002:a05:6e02:1003:: with SMTP id n3mr1776667ilj.279.1632783550994;
        Mon, 27 Sep 2021 15:59:10 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id s18sm9777762iov.53.2021.09.27.15.59.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 15:59:10 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/68] 5.4.150-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210927170219.901812470@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <001c370d-3532-d91f-b742-a0f85145b13c@linuxfoundation.org>
Date:   Mon, 27 Sep 2021 16:59:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210927170219.901812470@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/27/21 11:01 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.150 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Sep 2021 17:02:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.150-rc1.gz
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


