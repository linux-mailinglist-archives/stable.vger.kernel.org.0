Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B29E257106F
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 04:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbiGLCox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 22:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiGLCow (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 22:44:52 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E2802AC66
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 19:44:51 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id p128so6699408iof.1
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 19:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=t1sn7pNRfZCkRDVgtSmbu6HGFZX8SAOX67e3ULzE54Q=;
        b=VlAIAI8cHonD15U4bJcCvqDEgtqlF6oOk0fjQe2sAW1d4HCb7Z4ibpljhAwib8qeUJ
         wzss+wJ9a7i1ZSBcQSkvsVMehs/FboWRoLoixNmnOpcEDcp4GQ6XPFy4O40ZrDxf58xc
         zdMcZ52ZmAphUZaukYTnMK+8A3RriPK1LM0Y8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t1sn7pNRfZCkRDVgtSmbu6HGFZX8SAOX67e3ULzE54Q=;
        b=QaWIJaHTj4poUJKSdc7tGANBeiGNC6WT7B2F5lV1LvukQWx8pAz0DE0gKaieFvxBzn
         +N3z8sOZVzz92DUXBS12FQLXTCpcsHlm/8WuKNlyy+OZ8jU3E4RZG59SJ0CWyZhKln0x
         V6aIwpgY97uDfXakr8D8SmpAVbCAqWMvEta9Eaw7TzRg2/R+DDs8qHXZ+ZaahrLHS/5l
         zNPjppv+Ux2dSFFnklnrHkZKCerf5cBIdcSS5lZ8j568SDSxjXH7daKm61heRHQ/3fbq
         DU/GCmyPUeNrJrD1g18ABVGPB7orgb3NDtNlO74RHhh2H9/frxvGOvgRW5hN5Rpzfiz0
         geuA==
X-Gm-Message-State: AJIora8OZ8dFExcntQB7e5x4fRotwVzwZ2mRbs52H/oNX0dQ62L5gvDi
        M/PhVM4RRrbFhlBYedTy/aNDVQ==
X-Google-Smtp-Source: AGRyM1vlbL1t1WoCVQFMHEOgbJDNQhkcinx7Dqf8QbJz30xyEmJw5l1blqP9YNU2GP0swWpKXfuS1Q==
X-Received: by 2002:a05:6638:d86:b0:33c:cb11:b028 with SMTP id l6-20020a0566380d8600b0033ccb11b028mr11840162jaj.68.1657593890980;
        Mon, 11 Jul 2022 19:44:50 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id o2-20020a022202000000b0033ebd47834fsm3612166jao.128.2022.07.11.19.44.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 19:44:50 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/31] 4.19.252-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220711090537.841305347@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <f6bb0c43-6aab-3853-b2f3-0a11bb01b378@linuxfoundation.org>
Date:   Mon, 11 Jul 2022 20:44:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220711090537.841305347@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/11/22 3:06 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.252 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jul 2022 09:05:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.252-rc1.gz
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
