Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7085595257
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 08:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiHPGFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 02:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbiHPGEx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 02:04:53 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0BB2E19E6
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 16:37:34 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id 53-20020a9d0838000000b006371d896343so6439018oty.10
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 16:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=WimWIitHM+CoAiZjqWervXOqU1A1SYwiQJuQcOIMF/M=;
        b=TnJFtS8DxYH4QBrBFIqGb73w+tlNoqpHU0e9IOuZ+VydJKMh931RwCFwIAMiLfCTXJ
         wRa+UmVjmHcQugDfdNr/c/6mhW1+smCg1ShhKFsubLraxqCVbIOP9Z2nC4yOOJCUKGC3
         6zhQagB6eb/Wg3th1qoh/QUUDexch2GzoHmXo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=WimWIitHM+CoAiZjqWervXOqU1A1SYwiQJuQcOIMF/M=;
        b=5CzMCpCuT5sVqH8D8JwUDHH28/fmEgKYA+NGeYytFSeN1OQKFRKbP6P9cdXtARsKg9
         zLorCjwz/HmJGu0rBtI9fr3m2liu1JOs/cJIB+/a2SRqjEMGT/IeJjNoJ+8HdZ9oCR+x
         plW9N+8z3biOpjeagJH5SxDa3kuBj1shMrQa3/0yr1M8CO6sMpb0upsbJtBpzKWcrO5n
         UMHrql5tRZAFtDA7/JxWXEV1XZbRoFkNvz6tw4yTvd0/EMXFvLgqn2cQkgBM9HOrhngO
         Og3rDMFBHuXZrUfoinhGzXAxKHruMR8HNEm4b8+XFUaKQ4WQeBHf9b0v4/oV4ZitI0/g
         tBlw==
X-Gm-Message-State: ACgBeo3PjxiS4jZ1jHHgJ0Kc2+dyZsN/Q8uFih6scr2EvztNunYZzyV7
        uQjSyCeFc5LO74OoONUe3U2SJQ==
X-Google-Smtp-Source: AA6agR7kA0AUc2Nr6rVsJG+kVhELuwpKGP3btJqVltsKUy4hK2Go5nbTPfL/r20FJrhD7OxOBhEdLw==
X-Received: by 2002:a05:6830:25c2:b0:638:ca5c:bc66 with SMTP id d2-20020a05683025c200b00638ca5cbc66mr270191otu.208.1660606653183;
        Mon, 15 Aug 2022 16:37:33 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id s131-20020acac289000000b0034378294973sm1865765oif.30.2022.08.15.16.37.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Aug 2022 16:37:32 -0700 (PDT)
Subject: Re: [PATCH 5.18 0000/1095] 5.18.18-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <4ff6c94e-9d9d-2ab2-aa84-0174734af9d7@linuxfoundation.org>
Date:   Mon, 15 Aug 2022 17:37:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
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

On 8/15/22 11:49 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.18 release.
> There are 1095 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Aug 2022 18:01:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
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
