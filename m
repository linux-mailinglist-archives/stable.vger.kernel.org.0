Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8C2E522704
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 00:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237034AbiEJWnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 18:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237031AbiEJWnJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 18:43:09 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68FE215E77E
        for <stable@vger.kernel.org>; Tue, 10 May 2022 15:43:08 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id v66so715085oib.3
        for <stable@vger.kernel.org>; Tue, 10 May 2022 15:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fno4ztKLyIHMvV98/mKFzluz/Vsoo50U/JqjK1ApCs8=;
        b=UgUruhX44BMbM2I3P7RQLz0Mk4Vo+ez1eb12JTdV2oOOOY7/AScPqnFiulRxqv0k9k
         OPWXAiz/CiYZ0KHcBjPXXqASDR/c5blPr8fMiNkTm+ogJZnlRvUSls9S1fn4juLSELk/
         DKl95HwGFWFjFKWTFccIK2QWFfzEfjdJ//Dy4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fno4ztKLyIHMvV98/mKFzluz/Vsoo50U/JqjK1ApCs8=;
        b=k9k18EqfiotPpetOf2QiaAirNKNwoLoNLvkSvvytAnjXBHhVtjbByp989PLX6e+Eye
         7AGCX/DS7SLgExO8MUr3xnOI/yFY1iTxWyYOoeFh9/n8Drw7TWzcN1XcdwlpuLX3Z8I1
         xtUkRXuzPUsfI98PkN1g0zZZkivAKOOvBjJvxieT3NmXDUJTJTvaK2RS/ibkpl4M1kjI
         sRL/IXHOjUgZtXI0SeZ1hharJGKSLXw42BOqxxEwzkN/JLgRxVDyPTyCYN/+KiCdSWnX
         iOpaze3PQJFksHuyluOr4tXVX+iD0vV1dXHn2j9DLR0VUKAMIeVPpZsiWrSrcgrABFR3
         iwOg==
X-Gm-Message-State: AOAM530xp0FTvigvpWDrt32L4+L/9nES3q/A5e687SkAjPazfnT7a2Ri
        1GIBCADik4rNlfIHBaSRrfxwVw==
X-Google-Smtp-Source: ABdhPJyosDNRRg69gdLTQHqgbIDNTpCfSOmD6okKr6/9emid6GIyS9H3jZV6RJ8Eo+wY1ny3UQeaeQ==
X-Received: by 2002:a05:6808:2198:b0:326:8121:5ac4 with SMTP id be24-20020a056808219800b0032681215ac4mr1125835oib.207.1652222587729;
        Tue, 10 May 2022 15:43:07 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id c22-20020a056830349600b006060322126csm174018otu.60.2022.05.10.15.43.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 15:43:07 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/70] 5.10.115-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220510130732.861729621@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <4dc35ddf-21f9-c313-8b1b-d5cdc9db877b@linuxfoundation.org>
Date:   Tue, 10 May 2022 16:43:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220510130732.861729621@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/10/22 7:07 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.115 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.115-rc1.gz
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
