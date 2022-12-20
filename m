Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45C2F651729
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 01:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiLTAWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 19:22:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232840AbiLTAWc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 19:22:32 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20C213E97
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 16:22:20 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id d10so5584392ilc.12
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 16:22:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3OAfG6VdKk42BmKTv+3PQNhWn9BfRus8iDdWNO6vo/A=;
        b=NcxWcqqnhOvJXIi6LxVBBX+yyYwytaTYLvAXpx/lRZyreXhs0VlJQlt85tCX2xNK6c
         +ZX4FT8u6Fvzr1/v9z6QReYU5qHnpNos7MCetvQL2DiLHqmwec/pygGfozQbJ2ae+GEB
         wzzrvc+D6jF+iKxzoYn1m2Fpy2taVH04oQiyE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3OAfG6VdKk42BmKTv+3PQNhWn9BfRus8iDdWNO6vo/A=;
        b=Ux5vhLIAav+cdxXAxKEY/F1hksg48H0MnbzjitbW7rE1Rv0ruwmi9CjMvfm4mPKc/l
         UqgpwVY124SLxp1BlCNSXAptvjTealCgiN2gs4D/+JARYmtvhHdFE5dHFnLEyAGI5Da6
         3aFVXeZaqtpbnCU1H+UhanySVQvCmtw2chW08ObuCrtoEgd3Y1TBWX5Qabs5R4101V3L
         J8t7c4AABe4H0P+XNRBHmB+V1bIafWnnX9c2/GYvttEShtnGtgSkEkgU64C2V/QCoGc2
         hlh89Ymndi2lHLH+TK8LXaKj/6QpWo7Ydh7CrRJ3+4eFoOh3icxs+zxm4+RIwyoH9Fuc
         o/iA==
X-Gm-Message-State: ANoB5plEnmOQkxOWwODY+ChzcfHuKW6FR7Zs2U8fp29Ga65sFDgYBlP2
        rzMk6jQpBaFlBIADKkfV+oCvaw==
X-Google-Smtp-Source: AA0mqf6Pk/PX6xwzcGkpyjlEkp0mkdt02zSc9IVftgm8IB+fM741G0AYNBG9++wFO4ShS5nFOB/F1Q==
X-Received: by 2002:a92:cd4e:0:b0:303:1141:1044 with SMTP id v14-20020a92cd4e000000b0030311411044mr5181169ilq.1.1671495740094;
        Mon, 19 Dec 2022 16:22:20 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id n15-20020a92dd0f000000b003032a97913asm3752089ilm.17.2022.12.19.16.22.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Dec 2022 16:22:19 -0800 (PST)
Message-ID: <09c3977c-11a1-72d9-44dd-d1b10944b9b4@linuxfoundation.org>
Date:   Mon, 19 Dec 2022 17:22:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 00/18] 5.10.161-rc1 review
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
References: <20221219182940.701087296@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221219182940.701087296@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/19/22 12:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.161 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.161-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
