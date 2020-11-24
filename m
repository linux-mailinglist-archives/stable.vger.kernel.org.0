Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEEBB2C1A18
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 01:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730576AbgKXAcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 19:32:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730564AbgKXAcK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 19:32:10 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75005C061A4D
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 16:32:10 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id k8so7074571ilr.4
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 16:32:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9QNZdMH/PA/pHLZjUKOEtHevUVMx4kRepNcO/cQUXhQ=;
        b=dC7wwsHNtSDev28owu/2qGWi0qbPfBTq/MOGpMRMcG2AKSME+jwKn+xsopuiDLsHu8
         NGQVouczYF4EVujpdBvlFMGwBgDxOoD9KxH2msv8W3KNV+taIrY1ADU6VVlVYbe+/0UA
         LL2+toKC1BphKy0rgxfKOBbNC5lZsmD83HFUk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9QNZdMH/PA/pHLZjUKOEtHevUVMx4kRepNcO/cQUXhQ=;
        b=ObUqGrp+/OqUQ1tgH5WUONGO6FK4BpjkvgUu1452+leAr8j7F7FpK46RVwf7iAqWuX
         XOENFYfeaMjtKzIkglWIuk3f4S9rVvQdQvFvlVdzEx77br73SSGTrxGl3Qr/aurM4zkU
         ybKJ6dwaO2DIHsrV/rbcIR53A45vfR5fQxArTXzgQ1/l4q07BCXVDSIiXYYqA/rnpUUE
         mtGgQnRxfD7Pi0Lzsdk35J55IgSMlod/SrVs2dL7fg8fwd36qAS/y3kvsJJ7A9QcISa7
         +/90EvPywmhD5qOfG3YliwAzBefkpuQempLCz27GN0PODaJ976rdPRGXmTPGjAHI2D+E
         jpgg==
X-Gm-Message-State: AOAM5305STE0NZdQgL1cERdQZN6LWesYIHf8IbApauxSJJF7wr7C4Bfb
        iGg0udYDPFOfXNz4jTmjsty6MA==
X-Google-Smtp-Source: ABdhPJxTHJJtMKoBLyeYEsr0bepf7XZ7HOvjtnBC8nCDkhdrb4Wu8TrQUJNOCnWiepzKs2ToSBOaGQ==
X-Received: by 2002:a92:d04:: with SMTP id 4mr2132128iln.210.1606177929916;
        Mon, 23 Nov 2020 16:32:09 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id t11sm8351052ils.37.2020.11.23.16.32.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2020 16:32:09 -0800 (PST)
Subject: Re: [PATCH 4.19 00/91] 4.19.160-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <b0f29578-e9e4-a08e-7c0e-20d16ffae8da@linuxfoundation.org>
Date:   Mon, 23 Nov 2020 17:32:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/23/20 5:21 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.160 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Nov 2020 12:17:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.160-rc1.gz
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
