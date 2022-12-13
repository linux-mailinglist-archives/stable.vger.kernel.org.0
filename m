Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E838F64ABED
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 01:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233880AbiLMACd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 19:02:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233874AbiLMACb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 19:02:31 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 593E81C919
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 16:02:30 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id h17so4249039ila.6
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 16:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G1HKnkT2H1E5a9tRBc8kxtai75M4h/8ugB4lCGNkHko=;
        b=A7BikBRZ71ECNAJ/PTktlFLR8u+Jzt1pNlpgn05vR6UHQRq63Brxjq5ncggdt7z30K
         YheQV0pNHlLTcqhdvRAmpX9mDodYLBNB8MDHJ3ZNvjwKsjm/NVmna1iQ8svKzyiCU0FC
         maj4g3dqA8U92+H8hU7kSGTutFULGeMyXrbWY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G1HKnkT2H1E5a9tRBc8kxtai75M4h/8ugB4lCGNkHko=;
        b=tOYWM58RRsBeteWJ/bMIvADBVuK8wBQJob1YA/573+V4uP3e34n0KeuYFKKQQW7yFT
         KQd1SeYrXJSHXIpx2NecEna9WlRmdfJMol3Dctd2mt63J2GbpskYDHhNcXq/UamG220K
         Jvp0L/OL0Krzxx+qc+Nt3iF5h+UncHpaeSlu7R4bUcyYmQeWHvIbzmRa/BqyfrSzGKE4
         DK4SnP7bNhb3wPher2pyZlTHJfmGUiSr8mKnDt1rM3mbfqmfUX1U59og2hHg3kLqS+zH
         FWw59znb70Pi1Xw/1OJAgDasp7wSWx9p1UXnzI3sasaS0FnHQUQVEdwmDlUv1+ZnmnV6
         XgLw==
X-Gm-Message-State: ANoB5pk57OiwaA35YOuO7Aa82/3Y64NuZPOZ8THYgq+jpMwH1ZbFPbLC
        QgK2q4SwmMQ3o5aCG4TzXQB2WA==
X-Google-Smtp-Source: AA0mqf4Q0wuXsyq6H5PwttLVTJytpXdak9Dl5Wa69CZAdQ6IaPvaV4JBYQBSnQ0v4CoTfrpYvGh5Uw==
X-Received: by 2002:a92:cbd0:0:b0:300:4c9:f52f with SMTP id s16-20020a92cbd0000000b0030004c9f52fmr1955672ilq.0.1670889749621;
        Mon, 12 Dec 2022 16:02:29 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id e18-20020a022112000000b0038a06a14b37sm362765jaa.103.2022.12.12.16.02.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 16:02:28 -0800 (PST)
Message-ID: <cf988a45-cbd9-be77-3160-803bb4cb6c0a@linuxfoundation.org>
Date:   Mon, 12 Dec 2022 17:02:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.4 00/67] 5.4.227-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20221212130917.599345531@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221212130917.599345531@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/12/22 06:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.227 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.227-rc1.gz
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
