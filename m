Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE9CB643B8C
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 03:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233086AbiLFCuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 21:50:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbiLFCuM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 21:50:12 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B5D25C44
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 18:50:09 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id q13so5974445ild.3
        for <stable@vger.kernel.org>; Mon, 05 Dec 2022 18:50:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iMpQTicsa0g7Lorw1se6GC+CBOwJ0Tti83kJiz0vrKE=;
        b=YPKqCzIbxCFpuPZIpFucvbbIeZF4SOCGRnDny64EdVfi0aCWUHbSJjd3TJcsqEAdVD
         KtrjLhB0WdRwmQCCdKC7UIo5gpYLWppg3tedZons8ioe5kZteFjX6++HlPSx9c41vCvy
         SitQkL0BnF/2oHU5emrYAGEKywWtyGvw7+vQs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iMpQTicsa0g7Lorw1se6GC+CBOwJ0Tti83kJiz0vrKE=;
        b=Zb77+DxJbj/7supOkiXF8A+FudQHu4UAtcCFAyoc92clfezk8wk1aIvF5Yb/dfsDHS
         AJYVMnNB+wpExfPyd0kGCBi/Y24wRPnWTRdY3fkigq3Se+g14+LiTiYsVKViBHqy9z2G
         SJVRrSpqebRKfK9i8Df+SsNKNBJUBD+zQbCbvRBUG42qXJ8mIboBvt1rjXNOd/RuXqTJ
         aszEV66Dki+0ON1+5b6nJFT4lunC3XXd8UpaWFNCOJEKIR3VOJIL9gFhdVnRAqD69e7c
         bRcNKwROj3Q5hLUL/kRy0CpLcOx+3jf+LoHT3PuGVISR8seZUHokIEWWICuPtiqKfpbG
         oRrg==
X-Gm-Message-State: ANoB5pl7ZRsCK5EiLLK2xafRmApeDCGgW24E5vmkhqmTmOlQMmOa9YZG
        24XV+EU4OrEn31kAo/5J75frdA==
X-Google-Smtp-Source: AA0mqf5GTKuO1UebtKV9X7SdykSWAk5ixXoxIk1I1sErvsM5Y2dukjprFEURzAz4510Rf8F1F6tECQ==
X-Received: by 2002:a05:6e02:1d17:b0:302:9392:5a01 with SMTP id i23-20020a056e021d1700b0030293925a01mr30649901ila.268.1670295008485;
        Mon, 05 Dec 2022 18:50:08 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id 125-20020a020a83000000b00372e2c4232asm6195306jaw.121.2022.12.05.18.50.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 18:50:08 -0800 (PST)
Message-ID: <59828df6-dbf4-4bd5-b165-38ceb449dab5@linuxfoundation.org>
Date:   Mon, 5 Dec 2022 19:50:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 4.19 000/105] 4.19.268-rc1 review
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
References: <20221205190803.124472741@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/5/22 12:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.268 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.268-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
