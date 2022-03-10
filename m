Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2909B4D51DB
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 20:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244407AbiCJTdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 14:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236674AbiCJTdt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 14:33:49 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E476A9E1F
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 11:32:48 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id b9so3075755ila.8
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 11:32:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6Nojy2kuxE++/8g3r9nLewyGoXMHM/i88BIOvQXIkJY=;
        b=ItQnC3YOhz6/P7PMyE16LiXUd9kooZKHS41C4CGw/8QGfIGxZ7o+qOfYN3Bye9Z1m2
         T8ximx9VpQiahbnlWsOdzWkYinJnLNuVYwiLijDV11jvbZudwnRB5PHEjyiDs2dJlG4l
         EyeNGIXiIjYmBOh+ecQSV+kQKYTpCJI8+Et+8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6Nojy2kuxE++/8g3r9nLewyGoXMHM/i88BIOvQXIkJY=;
        b=31E5/PmC0zmZ9P5rInXbaiH1iKy08o8Tlu65YHQuCFJICFaa8L3NBPRo6zE9XjhX+J
         xfUpeqh/7f+OHMLVN5+rhBDJkHBaF4Nu2yGramLwWpxOtVUXqvseqKVTiGn9NfsV/eyJ
         uCiNaZLkzjMdIRRa54GZo1spXEaLNxsZV4wMwXWy6Wvczi/V116IUUScRI4b8nKQOnlu
         +t+kkNVp3P5RvdFY+hoa5ynVBHfRaJZk8c0w+DUrFNDokbyZZvGTDw7DZmbXps9ojJ4R
         eVfclkbR1AiWJVQqdKBbvLQ+bLbC6TxERMPHFit52Rtix/3bZa4wR06lsihdT8xg+S1M
         Q6yA==
X-Gm-Message-State: AOAM533a5QiJNGtjGZCqaKZ0JbjPn6GM4ikFT+1VBgn/gd2oAluiXGic
        ROQOIogDv24Soq9c5fpPMhLMFg==
X-Google-Smtp-Source: ABdhPJwkDf7vhM7YF5DYtH03U320g+wJJYxfQhWDICe4H7su/aegQYA0cjJEKTV4vLmW8ZbOZsq2Cw==
X-Received: by 2002:a05:6e02:1708:b0:2c2:7258:3e72 with SMTP id u8-20020a056e02170800b002c272583e72mr4925909ill.267.1646940767591;
        Thu, 10 Mar 2022 11:32:47 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id e8-20020a056602158800b0064683f99191sm2310900iow.39.2022.03.10.11.32.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 11:32:47 -0800 (PST)
Subject: Re: [PATCH 5.15 00/58] 5.15.28-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220310140812.983088611@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <3591e5ba-9a93-53c1-ca34-51ce15acbf57@linuxfoundation.org>
Date:   Thu, 10 Mar 2022 12:32:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220310140812.983088611@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/22 7:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.28 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.28-rc2.gz
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
