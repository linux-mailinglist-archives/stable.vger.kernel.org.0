Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54962558C75
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 02:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbiFXAvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 20:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbiFXAvL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 20:51:11 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C0B3ED1F
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 17:51:10 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id k7so496747ils.8
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 17:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=x5Avj5gf7IuZFuLm4nE8WagAZKu44Qt1uYxBdsmd6Cc=;
        b=iiR0T1ZtgIW+7lswPRy6SwgMzAqfm9Ox7sCKb4ig1pmTUQFXvuXYrhabmMKbs3jGVO
         ftuj4SgTbHVn/doVw5s/+Ri5XLaCK8+LLyNjOXvzPUXSBUuJHNciZHf/p3i+QOJ6xFND
         aOGtc/VlfV3qTQptwhnxiGTyn0sttwLLp3TZA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x5Avj5gf7IuZFuLm4nE8WagAZKu44Qt1uYxBdsmd6Cc=;
        b=kn2vNzMl8nqWTIHt4g7WuMy2qMph8PQo2/dhkno7eGg7fwQEEDiq484FjrqYxRMRrK
         uQL6H3fkPCY1Y5SHu8oCekrth64rB+WFYH+0lR2OKk48uqgUTNSTc5CU/lYy3NDtuwtb
         bTt97oGXnBZ8+7QaWVpYw/2Pf2gbIDpUu8yuXqAG4NYp4CvDUwCKbCouUNIoMMpJQorC
         OsP2XkSfAtWXZt7pUiQdShSUeMONPE5cZgNgnt810+gN8p3SiFmc2kBxw3cpopJrn/cD
         tfCh4et6Lab8p0a4W5kiA2IZuOh8f2bnPIfAI7KwH8iRwUDWoxQhh0gpBqJ1JSUTks6A
         YZ+Q==
X-Gm-Message-State: AJIora8IzzbpvFVIzvG+bwZBbLenrU3pTqcowsRMUCq0kv/FHec7P9iX
        mhIMMGQMYp5XZqoYvOU/AkJc0w==
X-Google-Smtp-Source: AGRyM1v2WPZt9A8jUfbTph8eGhhixLgmE4juqztX9I4AWJkTYx/smRra+JHWEjXUhzoERSwcAxWeEA==
X-Received: by 2002:a05:6e02:154b:b0:2d3:d112:5a0a with SMTP id j11-20020a056e02154b00b002d3d1125a0amr6942745ilu.131.1656031869878;
        Thu, 23 Jun 2022 17:51:09 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id h6-20020a92c086000000b002d176be6912sm498539ile.33.2022.06.23.17.51.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jun 2022 17:51:09 -0700 (PDT)
Subject: Re: [PATCH 5.18 00/11] 5.18.7-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220623164322.315085512@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <3a73dda8-d9b6-9eb5-34c3-832127d55352@linuxfoundation.org>
Date:   Thu, 23 Jun 2022 18:51:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220623164322.315085512@linuxfoundation.org>
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

On 6/23/22 10:45 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.7 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.7-rc1.gz
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

