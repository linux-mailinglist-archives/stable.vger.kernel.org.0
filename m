Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4CD85626A3
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 01:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbiF3XLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 19:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbiF3XK7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 19:10:59 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5FB318387
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 16:10:55 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id z191so679261iof.6
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 16:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dIDh9igH0WqMYoPcwQ8EGzvnaGjeYWJFBEtd9j2Fyzs=;
        b=SSIJrzT/S7ZASlrmwkoFJJcrWh/Dq4pARNQMXnoKF8Wa+ErUya32YLkV8SZ1MMS77j
         Khajrplnj5Q4VEB8dFb847dgNr0lEcgczjAxjpH7IY0wnaAYQHRV2SSrEs5djH0PrmoK
         N2FF3HcNqNh56Cbl12M+vbFHdYtKlj60rEKWk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dIDh9igH0WqMYoPcwQ8EGzvnaGjeYWJFBEtd9j2Fyzs=;
        b=iI1rD9pBPAQ+Rshxq87/GyfIP9NM3MEDAohptMWyUfhnySzxGqcUHbW/Br35W8+OGa
         BX8Dk3ylkBmDBwTCaHM13rq1KLIeRU9H8xLxYnAtukUgOZhdkORZq9YpLXVFTr0AibqS
         +09jqyGsXZBxAlWDVu1DXrm/7TyylcEFwpk/CowrhYpGJdhoYLMcPdqKu0n3hcglvis2
         ESstUoMCw/xeU9sIJ+k64j6/y7EVGS2n+sAUglsUIbw69aijbZ6ZSlFMXa01dru8VO4b
         wrmow2kmDjvdLveDvKvNqivuTRJzhNsZhlNDQdWP4psUvnxSqz7iT4lpgQitsvj9NSos
         a3eQ==
X-Gm-Message-State: AJIora9Meuz5IluLnpcE3oSV8ktNg07Q7nEf0RplMg3DHR6gqrH+v7Ya
        Im3BL/AOyJ9ZERk/7dP2fLLSEw==
X-Google-Smtp-Source: AGRyM1u00uLDy8eRhHKVoChkdeqL/K9JLx+6pobuXh9XaYLwq7oErcwj0v1wlFgkx7u8UBdT4AfxAQ==
X-Received: by 2002:a5e:a70f:0:b0:675:6d6c:8e05 with SMTP id b15-20020a5ea70f000000b006756d6c8e05mr5929382iod.158.1656630655338;
        Thu, 30 Jun 2022 16:10:55 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id m9-20020a02cdc9000000b00331fdc68ccesm8987851jap.140.2022.06.30.16.10.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 16:10:55 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/16] 5.4.203-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220630133230.936488203@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <65d8226d-f7db-7b6d-057f-11df9e14c092@linuxfoundation.org>
Date:   Thu, 30 Jun 2022 17:10:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220630133230.936488203@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/30/22 7:46 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.203 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.203-rc1.gz
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
