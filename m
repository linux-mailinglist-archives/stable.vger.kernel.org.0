Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C09B542338
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 08:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbiFHE4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 00:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232879AbiFHE4Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 00:56:16 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC903878A
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 18:28:15 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id h7so7955409ila.10
        for <stable@vger.kernel.org>; Tue, 07 Jun 2022 18:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WPijXcOAJ6XYRcZ9ka9sQPzTk0BtKIqM1P1ASLgj9js=;
        b=NycSVoWJnqmcDVER30H6N68HhCf7F3zW3dbmLA5zlCuKMgs+Ke5AL6KamFUFCo5t6B
         0BI2xXdkAYKZxiZf1F2PcW4CAwzqmsfIatlOxQpx5nwSAbJNnsP71H5mE2Lyuc7OstaO
         Ur7psqSPUVZcxg6NPYypP9zoCE0Yo0kg0Sb0o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WPijXcOAJ6XYRcZ9ka9sQPzTk0BtKIqM1P1ASLgj9js=;
        b=rz8xJJgW4sR++Os4QmwLHZG1kQd9N+VsPqS87UeSHGaUZ74cv1ko0CTOslGFnyYAlr
         DTIGOkKcIG4UrglObdoPBGbs/BWzouBElmoUNHK3h0hnqyBPr1a3XxjlgvVpecxKalGL
         0aMl6cWfeQyPu3611a711wHe1jAQ0yOj4zIxlO0xooypEeoN2dJMUS0K6KVW4K1/E/VX
         /sQ2nB9g/yDPoDcr1qoZQfwyj9KwCFYCfPxs1CJpSuTO4p9y16bAnh4c7PG4/qIAw18n
         ZeD9//KD4m2UIlUWodGFPtn9YPzRKXSYpH/kql8geDXPb8oCzS3CBgLt1tl76+FYLeOs
         hkjg==
X-Gm-Message-State: AOAM531gy0xYGWBsKahi7eqwFaQG9BG6d3JpK+qsG2UTUO4q7ehjRe0f
        XiePxjBpxygjbzWNTt6Cb9L8pg==
X-Google-Smtp-Source: ABdhPJyu8ZhzJOL7Nf0dJbd8DBUHgX6vRBd/wZg+VhAp+dX48qSeGtA6/DJ8wgy4CWcUQI9GSWDF4A==
X-Received: by 2002:a05:6e02:2147:b0:2d3:b134:7e5c with SMTP id d7-20020a056e02214700b002d3b1347e5cmr17338819ilv.17.1654651694637;
        Tue, 07 Jun 2022 18:28:14 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id q1-20020a056638344100b00331d764e5b5sm1107695jav.97.2022.06.07.18.28.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jun 2022 18:28:14 -0700 (PDT)
Subject: Re: [PATCH 5.17 000/772] 5.17.14-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e75d88e8-cb08-a69a-87ce-0e93ac9f923f@linuxfoundation.org>
Date:   Tue, 7 Jun 2022 19:28:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/7/22 10:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.14 release.
> There are 772 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jun 2022 16:48:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
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
