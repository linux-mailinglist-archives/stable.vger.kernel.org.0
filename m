Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEF0F4D0C49
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 00:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344022AbiCGXur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 18:50:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344037AbiCGXul (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 18:50:41 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49FF24F02
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 15:49:29 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id l1so3354303ilv.3
        for <stable@vger.kernel.org>; Mon, 07 Mar 2022 15:49:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=v8EgM3T4UQTB5yUI0lflaivPtAYu3R9eYXESkt6E+LE=;
        b=N0nDn3GbWfRU2xJrNRq51kEZzZZ2JRjgbUV5k722waGto8ccawCClvrSiSh3pWuQwi
         lXoWSHM4Ci2MIOK2zGbJZHot7GcQmX+1o8MFvqSUD9uRJU343wl4FE7nbX4X1HCGN5bM
         f5V7CJvR6A5GAk8xMxO2iIBe2tHnIRHl3mkQI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v8EgM3T4UQTB5yUI0lflaivPtAYu3R9eYXESkt6E+LE=;
        b=fBGgEPN3HZd7qp+pnZ2gMSkxRnUWgQYeLNqWEdVFGRdREreXLwuSfYT8e6Cq9OxdXs
         zwuGld+LkGAqaMVPQTNd57JszavuBW9TgbhF0q2l/t8VLB3nCWDLabKf4U4NRynKfmxf
         FfjLfkKTuPifb9V2TX4GMAmy+LpHb03eQ3Mf+OcdtHFtnDR6akHqEMNzCw4oYt74dexZ
         3Kr2mUgtPTbmdcAgPtNaoTnkPCzFg28OKwQuchwhnkCmpfQJ9SeVoWdX6RIFjKRt2FnK
         68P6b6GOqz3dV42RVsJYMArCsB112NBlBu7sDhADqSWRY6Al5+fDzsRxlcPSEf0OLuDW
         aInQ==
X-Gm-Message-State: AOAM533t1W8VjHgpxNLVkZHlMl2pwnBB1gtSmiGfizQiesLIs2EWnBNL
        nqac/MrfeJSH6cGiweiUp4Ip2g==
X-Google-Smtp-Source: ABdhPJw0cltGgBxFBwzl1GayR1ZaZvC7yjmngtkAEGSqpohxY2x5mZG9cPiVdTfAWlA8Hg4rIsiLJA==
X-Received: by 2002:a05:6e02:174a:b0:2c4:691c:b746 with SMTP id y10-20020a056e02174a00b002c4691cb746mr12337093ill.29.1646696969237;
        Mon, 07 Mar 2022 15:49:29 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id u9-20020a5d8189000000b006415781ebe5sm9758419ion.5.2022.03.07.15.49.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Mar 2022 15:49:28 -0800 (PST)
Subject: Re: [PATCH 5.16 000/184] 5.16.13-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220307162147.440035361@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <6faacb78-3fa7-5374-65ae-88c6a00f5210@linuxfoundation.org>
Date:   Mon, 7 Mar 2022 16:49:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220307162147.440035361@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/7/22 9:28 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.13 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Mar 2022 16:21:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.13-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
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
