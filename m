Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8676B584218
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 16:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbiG1Op5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 10:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232864AbiG1Opr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 10:45:47 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A28117E2F
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 07:45:46 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id d4so1035627ilc.8
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 07:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/r19YZ+oMJAPX4n0+DIW5wmQ7luI3Mewl9NleSoJiyw=;
        b=ILjDHqokX2mt5HiC+/G1WZkpkDl8x4NcbTApAiZPTCjzZU1mm+7Ka6MGwP1dbleL7R
         Tl9hH/dFCzupPEYikNiHiw/Rtm/c7p1Vl2uU/6nCWxqtFFnwf8DF4AUIn26z4OachCrx
         znxpTxLGqmWBZ+hkx5x7zatsgsUuasyj106kg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/r19YZ+oMJAPX4n0+DIW5wmQ7luI3Mewl9NleSoJiyw=;
        b=3OA6S41gEHwt0RsbvZJz3WcvGqcUR8Y45JDAPeJzGyYmUhTcPMcyFQy4LZdPPPjhfH
         xdqjqx81WqmA1JuaHG9XocGpc3OxPDN8n03/GuDkMmfmfowNlNyRhTISaK4n6xKl7wLd
         PmY8bLVj1gUAE8J+uff2F/p2Lzh5s600nIzUl9SBG68LXaOO0+Kt2RmxHWo1az/uZDvV
         /FKG5UjvKzn9k6gNATVzmfG0srdYoZPtLooTbiQxeARFM3D1MfvuQcqBQ6+uzt01r0xi
         vMAkN0PsRbYl6l64nIhbFaIAx2mWkhN/YWULdCf8XS7eS0DR43KncjpbY3rfyj+JLM9w
         0QEg==
X-Gm-Message-State: AJIora9C08sbm/6cy965OA6jBYXR7h5s+43ASpLAhZ+MvIDE4sYGSBK0
        LigfTaaNEaZpBR3TkmN1xzL8zg==
X-Google-Smtp-Source: AGRyM1tUh74v4jn4ksC92cCkQHFHuTes8Q34u8WgmMLMTto7OFSQ/wprShjJIGrg+6wzyvbQoNZbXA==
X-Received: by 2002:a92:ca0f:0:b0:2de:30d:a2b8 with SMTP id j15-20020a92ca0f000000b002de030da2b8mr739948ils.15.1659019545675;
        Thu, 28 Jul 2022 07:45:45 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id x69-20020a0294cb000000b00339d892cc89sm444037jah.83.2022.07.28.07.45.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 07:45:45 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/87] 5.4.208-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220727161008.993711844@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <d4c56343-9634-932d-0b35-6705e0467835@linuxfoundation.org>
Date:   Thu, 28 Jul 2022 08:45:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220727161008.993711844@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/27/22 10:09 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.208 release.
> There are 87 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.208-rc1.gz
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
