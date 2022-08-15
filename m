Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2F7C594EE5
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 04:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbiHPC7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 22:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbiHPC7N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 22:59:13 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30194150B9A
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 16:33:52 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id p132so10258970oif.9
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 16:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=gPuwrpWcrfiWMSNFrFWIPSzsSd1PwJumUrq/bMKe0JY=;
        b=SyVSnASSFfMuNy8g5hR68iaC3y5hAU00OSklcL0m1me1HK1ntZRqJAyUFHi/cvEYWD
         IGF9B6TABDCQ2rsSwIXBJPwvF8tWf1pcpzU3XlRr1yd7h8qiRGRAt9BoSzWQOg52IalG
         3loba6Xn31b81+b19uBY+GMvKWaqjl92/S9ws=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=gPuwrpWcrfiWMSNFrFWIPSzsSd1PwJumUrq/bMKe0JY=;
        b=4zH1YDnpz63MVcSiWxQhJ7T3ZeWRTlg6dJU/Fcx77J2ZR7pTByUG1THxFJ7hmyAjwL
         RGOcJKvtJGcBhDS4ujqavP1azS5MsoZpJ9bNQoAGKf8bLvPEdLA27LfpA5+AkdCcAXBB
         Cw+VPgWJ9oSFklL7xU9DPIW2zN89kTtNilOs+16x8vnr4hZOKbpo6TKVV22EQKcErWGz
         L6G+OCZjn8rFIrEfrCrgVeg5ehDAxJU8AKvqBlCojzrU8tjpEpWlExNEIK5uqA6EXV4i
         6NljRzI3emawhGh3U5ojX8WP/BIl+wQn91wt+WLAV4ZcCD8raBGJNo0T8PAGVesQP7tY
         xEyg==
X-Gm-Message-State: ACgBeo00JQFhFWruUqwzP13ccteqhbx+oAN+e02irCxW7/kKF/FuOEo2
        WNT5dET45173iYMYRw0Y7r+k5A==
X-Google-Smtp-Source: AA6agR6YNvfebVcFGIoPeiTgrgaoFd13p6umZWRJBzPrC5GCcW25KQUUslt6QvyU1YSk3Xmshtw0dw==
X-Received: by 2002:a05:6808:1718:b0:333:5794:5572 with SMTP id bc24-20020a056808171800b0033357945572mr7461490oib.115.1660606431514;
        Mon, 15 Aug 2022 16:33:51 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id f23-20020a056830205700b00636e9a0cce5sm2347618otp.60.2022.08.15.16.33.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Aug 2022 16:33:50 -0700 (PDT)
Subject: Re: [PATCH 5.19 0000/1157] 5.19.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <17d08af3-0ee1-5fbc-d0af-b748a432e177@linuxfoundation.org>
Date:   Mon, 15 Aug 2022 17:33:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/15/22 11:49 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.2 release.
> There are 1157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Aug 2022 18:01:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
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
