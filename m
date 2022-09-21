Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14EC65E5660
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 00:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiIUWy0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 18:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiIUWyZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 18:54:25 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D08A61FC
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 15:54:24 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id x13so3995139ilp.3
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 15:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=x/8HnRLgBmOTNPNzt7yFm3mlkxAz3Z4Ic1wjQRNzYzk=;
        b=EmcTiIpnYUxvTkJpz4LGDut7T+L7UtN9Lso96q4r+bfaAdeNRXnt0108U9ZGsUfxNw
         VQRhLeDIe6NVuk18PoFKAPtyzHITwlJ0K3ebd8cfGGQmTimDVwDYb+lS3Jt8Ft6Dw75N
         rrxg01dSr8Vecn07KoPfBDvCGtUkhcqYU4DO8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=x/8HnRLgBmOTNPNzt7yFm3mlkxAz3Z4Ic1wjQRNzYzk=;
        b=CfY9mnc9dB3Wf9FyPRkWIixx3kWyaVEdUSsGpSDgJSHdNCeG+2VlUzT6DAgEqmGK5c
         J5CXLjJg9uRPhiIjA5g/StXnAv2/r4xTcfnrlIu/Bk/ywgdLazH7yBf0TrQZFsT9zzDg
         IhbzEAG0qH4tKgSaYoYerPLQrT9n594HzKoUoc/9DxclCiuIubuvbiA7sOM+JPLHz+8l
         d2tklGTQnQDGy5xUsF3RXCFBVxUSTNEXvyxufH9enD0E+u1LvkFJdKjsOT10P9YNTMHs
         SY/6bnaKrHs/GqIHSYQ72zFjakrCQAtcoAbb0UCdRuEEQ7YdHGa+qK+9aKehFTG+87bl
         t94Q==
X-Gm-Message-State: ACrzQf2LX66w1t/VuGfRmkAT+GPvVB1UR45E1SjQHmhgA8mEmTbVPq3l
        YpqSvwSqZ6LObeSqV+Hz7GF5LA==
X-Google-Smtp-Source: AMsMyM4LJ96pkU5R5Qu8VSFENM9t4H8NGDg4OoCm3kEv+CY06PnRPSC3qRuMaZMPgE8N0KeJGqaNfg==
X-Received: by 2002:a05:6e02:8e8:b0:2f3:3e10:d013 with SMTP id n8-20020a056e0208e800b002f33e10d013mr229491ilt.225.1663800864192;
        Wed, 21 Sep 2022 15:54:24 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id o11-20020a92d4cb000000b002eb09a4f803sm1441872ilm.67.2022.09.21.15.54.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Sep 2022 15:54:23 -0700 (PDT)
Message-ID: <179496e9-33ff-8baa-033d-6ae401aa82ae@linuxfoundation.org>
Date:   Wed, 21 Sep 2022 16:54:22 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.19 00/39] 5.19.11-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220921164741.757857192@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20220921164741.757857192@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/21/22 10:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.11 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Sep 2022 16:47:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.11-rc2.gz
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
