Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0CDC47B61C
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 00:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232922AbhLTXSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 18:18:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232904AbhLTXSS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 18:18:18 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061ABC061574
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 15:18:18 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id x15so8800684ilc.5
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 15:18:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Pox1RC5WSO1kXxEQqYY2EJ3dpzzFatAucKbW3L7gPAM=;
        b=R/Z/vIcayj1vP09PrYjV/ysdZNjKVc/Yf4ZqagAKw6OdIYJc4OJsfDzIwmhuCz16PT
         Br4e2N6t+8R1NaqDbCP4pa1CGwd5fP+x/28qn+5NdayJ4FMbKODllG2d2txmJDUBIFQb
         wNr6tcVpLDDTqixKBU7iydXIdQGM0suWq/aDY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Pox1RC5WSO1kXxEQqYY2EJ3dpzzFatAucKbW3L7gPAM=;
        b=CN1rVsIEK23azuZlMZvbzp/z3+Q97SrXlALYtzuSLADb5xzUbfkFPuyq9F9nQdVf9d
         hEKxN+J+aCe2VHFVoyOwNulQA/SI7FCC48uTY4Y3byiyc5z6NOsWy7REwpYrRJEbwEP/
         SyeBiDvG5RZjHQJ+LSVe3g7p0RxbLAU+H51cKcbq7JFczc+wjiQ33z+mv5QDkE1ZDZh5
         V6rd0tkuVCvozOo9jNE0WwRB3gwMNIjpBl9PtZsBQInWgOKOW01+UC+VqI1aSHDrWC0H
         AD8YM8Z7HYoj5JEOOsJjMUFEHd4UfS/5Kw/cW8NDnLvgnWvp0N776pcAJFNvmY45+BlS
         9Rmg==
X-Gm-Message-State: AOAM532aZ4v5riDJbpoj76hJkQ+eEyFUI/YcIXAIS7m9TBEJXawhq5lH
        nxv9IeedTlIfz1CdCTvZrG4huw==
X-Google-Smtp-Source: ABdhPJx2Pvg+bub1Aj+HCxeK5dmr/EQfZba6CU4H0Kgd3CvdMOMUMFSdtPaxfT83UHyKytN0t/u6Gw==
X-Received: by 2002:a92:3608:: with SMTP id d8mr165096ila.322.1640042297442;
        Mon, 20 Dec 2021 15:18:17 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id r1sm9196037ilo.38.2021.12.20.15.18.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Dec 2021 15:18:17 -0800 (PST)
Subject: Re: [PATCH 5.4 00/71] 5.4.168-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <3d7b3466-164c-4f66-f423-032c9622f966@linuxfoundation.org>
Date:   Mon, 20 Dec 2021 16:18:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/20/21 7:33 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.168 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.168-rc1.gz
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
