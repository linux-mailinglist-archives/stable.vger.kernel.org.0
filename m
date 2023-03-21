Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E65E6C3A4A
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 20:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjCUTVC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 15:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjCUTVC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 15:21:02 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20804FF0C;
        Tue, 21 Mar 2023 12:20:39 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id c19so19242805qtn.13;
        Tue, 21 Mar 2023 12:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679426438;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4A1X8DSIXCYAuOVZx3RnCB5u8at26anAgkpP7Mq9w28=;
        b=fsdsLU8DCXjJVvgFV85Ke4ZB7uwjYESWn4NK2Grj772hkmFIsvvJpZxP29vNUanffA
         pSYuR62rztsntYmQdyJQIZ+5a5bxZA+Cc9wZT+ioPlslSZcx5RjakzHxiLAisIL6YJVW
         vPQw+H2cYMK203jM5zenY2eeKbYNlA5AbTtet2vVjDWTUBQEJFDej/SeOSxjeq7b+9yr
         d078vyjbtTbK3tCOBk0m0AgFsh4pFmskHtGNC8mKJdsOMvd4ZEY/G6dsT1oXCMt7F/1I
         jdvUL/sl42crEAOY7wpWRySDvRvNQBWEUxNQzmuppqxoE+JClRMt4ck3YChHrqpoU42Z
         E/Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679426438;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4A1X8DSIXCYAuOVZx3RnCB5u8at26anAgkpP7Mq9w28=;
        b=U2FEHgoZ175jSlyY9XUknHFSDnt41DYpiO19ng7qwO8K7zivHx6E5Wu2P1HEUu5sOd
         NtCwyKfrKmtkyFBXudh5EsvGf3ysul3bw1AoCdOUBIrT5x25Qxn7GeBI7ZheHdjNwga0
         3BySUepmXhtUaYlGxPO+ZKrVHweW36pp/1vhu2+8FNYKi0MYel7AxqXl78kxRJSJ3wdz
         u9JZeeanvVPYLnSXeQJ+2o0WvqEimCOY+5uuGZfahhoh2kTQqx31J4A6dmBKyhn/MRUb
         nzweHZYawDLq8p42tPnvJTBtEKSbrgrCHZJSX4Vaw/yr7/MUKA21EASiXgIGcwmrl2sx
         KFeA==
X-Gm-Message-State: AO0yUKXNDaOVJNjYngjfVNwBobw2T/iAibUEtHRsWLKFmsY+2BPsq9Sn
        G/FmyMst1N7H0ZrATnOamI0=
X-Google-Smtp-Source: AK7set8loF1+hW+VViWeDj7w2xu00cQHiNQqltuCYAYPi2E5wn965efpgQpenrkn6vyIk508/ACg/A==
X-Received: by 2002:ac8:7f10:0:b0:3ba:18c2:99e7 with SMTP id f16-20020ac87f10000000b003ba18c299e7mr1726278qtk.45.1679426438541;
        Tue, 21 Mar 2023 12:20:38 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o16-20020ac86990000000b003bf9f9f1844sm8701774qtq.71.2023.03.21.12.20.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 12:20:37 -0700 (PDT)
Message-ID: <8f95d89f-ce6d-5067-bcdd-158fffb8f0ab@gmail.com>
Date:   Tue, 21 Mar 2023 12:20:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.2 000/214] 6.2.8-rc3 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230321180749.921141176@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230321180749.921141176@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/21/23 11:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.8 release.
> There are 214 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Mar 2023 18:07:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.8-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

