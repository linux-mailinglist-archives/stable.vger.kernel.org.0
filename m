Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA545076B8
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 19:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354697AbiDSRph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 13:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234643AbiDSRpg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 13:45:36 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96EF369D9
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 10:42:53 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id g21so18387471iom.13
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 10:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4aH3gKWL2+XEPvC8NucpuidR5DgS4elyTzSSEh3Z93U=;
        b=ZWY2pdxoeqFhH6vQY4NOEN3NdXLOR5jLi12fAlHDlh9+Hats311D+d1DuOjmuFCExb
         v+repEHJiECIxxQRNSpVdNRHZGMocf4+cLoSvgoF4qhxh6vFi+TGSBlOktXn3FBybq3z
         G2szLshEKuCFJ3IMZMgyY+DKcok1Q0ZgCw15c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4aH3gKWL2+XEPvC8NucpuidR5DgS4elyTzSSEh3Z93U=;
        b=We6LXvMWxVpn8zPSs470BSWFdr8NNSFU0eJi1yppzMhHqv+qtWCwenBu1PF+txtMnB
         8R0CIsnyVsr20Brd76qmdNYv1+6QLdRHFgukGa8kTqMfB4MT1pRimw0mYjCGNATEoppv
         5sUedCXtb0G1MsEGO2Jx05ka8+S+mx6TpxNLxqPjH3ZhP/cQ36FogIhSsSyisMfmZ/3/
         E7crJrMHEFfrQgxqUE5MeH5L0W4C6Yy9jSfsGKTE2fFO6ljoWU2aXI2q95TptFLRS1Bw
         D65ee/jZg3G21fpMj0ZHWdAW88Qai7ItzDpmYrCE+5hiwboQTKZC7yHfK7zyJM5DwOyc
         yzxg==
X-Gm-Message-State: AOAM5307lh8uukEqyLstePk79VDwfZYSKmi41qANQF1c31IO9IFA3XRA
        T+3BLYiexj5wcUj3Jg69Ji28Zw==
X-Google-Smtp-Source: ABdhPJwz3UL7uxqGCVC3aGSpKQJcx/rjFi5+Wiv+gXGJkvDMYJyy00cvs9UDKSrTrLkLrKUl8DfdRg==
X-Received: by 2002:a05:6638:4128:b0:323:62b4:30c3 with SMTP id ay40-20020a056638412800b0032362b430c3mr8640514jab.318.1650390173239;
        Tue, 19 Apr 2022 10:42:53 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id x9-20020a6b6a09000000b006549545c9d5sm4360759iog.42.2022.04.19.10.42.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Apr 2022 10:42:52 -0700 (PDT)
Subject: Re: [PATCH 5.15 000/189] 5.15.35-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220419073048.315594917@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <54615348-2663-f7f7-6996-16c33855a7f4@linuxfoundation.org>
Date:   Tue, 19 Apr 2022 11:42:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220419073048.315594917@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/19/22 1:32 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.35 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Apr 2022 07:30:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.35-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

