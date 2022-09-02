Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D29745ABABC
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 00:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbiIBWRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 18:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbiIBWQ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 18:16:59 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 952BEAF0E0
        for <stable@vger.kernel.org>; Fri,  2 Sep 2022 15:16:57 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id k2so1884713ilu.9
        for <stable@vger.kernel.org>; Fri, 02 Sep 2022 15:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=dcZR9Da5synONYsfv6BX3VmjpoYWheBsB/L6GCmbJhM=;
        b=FxzlalIJ53cSaHZ8U3mRv/wFCu5A/pH3mLdB6wr7fqMkh12fSfEbqqLgxHZXPoC0AL
         5lZ6/NrYprwu3fL+/Q5XQmVh5tWIB+T38YM5+MC7dTk2eyu6g5ZcFQXhEuLa21Tz5S8/
         5vP0++y9TCBIPbTpYXWoMgmM7RkmhfUBRQn7I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=dcZR9Da5synONYsfv6BX3VmjpoYWheBsB/L6GCmbJhM=;
        b=5bKZdlJpNiY/HkDpd0fbrmARQQQfn5nOD2qAekUvLgix2RRB29UVIX914n2TWx3iI4
         C0LKPr5gLeFOKo4amseB0nYbfguD2jLcvDJQ1YoloFBANbrVNk4V7VEpWtKqSr5QYX23
         9DLO7VQfZzkYj57Htzz0XhTP1ebtwrkXwTt4aVvlvuyEBqMeW7JNJNJhSQpwI0/Vx27z
         BGkPYNYgWJSknWKSdw21GHsCiJo4AfBU7F4L48Jq+/fQK2Lc3yzy/LCdRLz7fRPBJj7F
         hYVKMeM26zVQXc87YuFYJ5Nc7VI0mu2UoTCJO/uTL0FEcox6n67UzvkPNmRMJQlP6NcP
         t5kw==
X-Gm-Message-State: ACgBeo1XIWE0F8rOwqcSoYReyelGfiKhSc0aYnnjCJg8RMoHe4FpWiCv
        tx2OBf6+rapRM0eBFjWwjFUDJg==
X-Google-Smtp-Source: AA6agR44Wb2McJNJDAdIOCveucmlLsKCNahB2tcM+FuZSfePOAUB5B27TD0e0KVFPb/5I2Ba4taPnQ==
X-Received: by 2002:a05:6e02:15c4:b0:2e1:986c:91a1 with SMTP id q4-20020a056e0215c400b002e1986c91a1mr20565141ilu.22.1662157016979;
        Fri, 02 Sep 2022 15:16:56 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id a15-20020a92d34f000000b002eab1925fd4sm1248056ilh.73.2022.09.02.15.16.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 15:16:56 -0700 (PDT)
Message-ID: <cdfc29b3-3054-55ae-aa5d-e5b35fc2ae05@linuxfoundation.org>
Date:   Fri, 2 Sep 2022 16:16:55 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.4 00/77] 5.4.212-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220902121403.569927325@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20220902121403.569927325@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/2/22 06:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.212 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.212-rc1.gz
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
