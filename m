Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 430E24E343F
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 00:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbiCUX2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 19:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233122AbiCUX1w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 19:27:52 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D6E375B16
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 16:23:58 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id d62so18457987iog.13
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 16:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GHF3cFazCIoxzIiOtqaFuckKc05p9fdKsgGJfNA9D2o=;
        b=LDMyjvO/V3+/QXwyYENuqy8ZBs0SlM4uwxolvAZszXia2K6axwEU2awIRBeWQGTR3T
         9TYYzFQBuOZj7ftksUNbiVySc1jeLP/c2Yt8d6zui+GTSrZNBajjn5XmcaPm8Y696sQI
         wN323Sgmvx8tw6p73QD00RSHV23Pg8Y+323gA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GHF3cFazCIoxzIiOtqaFuckKc05p9fdKsgGJfNA9D2o=;
        b=qU05Ley1RT27ige7+RuXQpmpg1ytMiHsEQQZSlIViV22R8ymQG2JGlx4HQ5uMjS7X+
         f/xgJdbb27r39ylmHnbjt+c+Gug2pK8WxK0RNZs5Z0BR0dHHHJfrevdeFSZBvs2hZySl
         +i3ELnOwlYkVs0hg2u8I31lC5dhM28p3MXQgl2B3x4Rw6+UDe+zVr7L8rht3PxnLyPTX
         kClpsZmMtqRxU99Dr55zoJKkDVIu6lUvpxUBQ83DUXA6SEcvj9myO70ZaHfIaVn76mCz
         CWKCdE8wUcE5NeVkilHoxj8cb7diB1dNmEs3v8olxmu0Y4PznKUo5duw+fe103+exWlf
         ZXAw==
X-Gm-Message-State: AOAM533Mh6dTYomLI3EiNU9ahuGyBY0MNyUUu3sNJWjrLQPBEazvjjx9
        g7FN2RPPktF17mjBfwonbYd3OQ==
X-Google-Smtp-Source: ABdhPJzwPaM9ZesW78h/QPEGfn7eux7dVCYblcA2h1hpgRCLIr2AkHNOSzQj0nHf1ee/SozCr7QEAQ==
X-Received: by 2002:a05:6638:2505:b0:319:a7f4:131e with SMTP id v5-20020a056638250500b00319a7f4131emr11758347jat.309.1647905037805;
        Mon, 21 Mar 2022 16:23:57 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id k10-20020a056e0205aa00b002c8266e72e8sm2750556ils.62.2022.03.21.16.23.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 16:23:57 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/17] 5.4.187-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220321133217.148831184@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <7917a373-c4eb-b71f-7580-ceef593e714c@linuxfoundation.org>
Date:   Mon, 21 Mar 2022 17:23:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220321133217.148831184@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/21/22 7:52 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.187 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.187-rc1.gz
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
