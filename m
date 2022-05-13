Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7243526BB3
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 22:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384461AbiEMUjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 16:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384318AbiEMUjx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 16:39:53 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F90F1B774E
        for <stable@vger.kernel.org>; Fri, 13 May 2022 13:39:52 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id l15so6542775ilh.3
        for <stable@vger.kernel.org>; Fri, 13 May 2022 13:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AgneOWNLNaDtGXKOaYtAUw+5LQ9MQcrbEn39kRsvLbE=;
        b=ZuykElIEJYI+JQT72JM81djwF7ZE/e13oi+35zGC4JcXbkUH4crZRYYTPW1ZnUjoV6
         t+WInmtMQ/R9Wm6idPbAXnOshJmZguVfcThvWXLDpw+i3pPAOH+5L/C3umcL+qYH3Jwo
         +XuokYsPb7Qg/+s7oigVZ8LOaB/VVZ1CHTQak=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AgneOWNLNaDtGXKOaYtAUw+5LQ9MQcrbEn39kRsvLbE=;
        b=wL/rd01feRciItLctPqOjWtOElWL0pbZYG6V0ENgVGloKhILi3KYSq7BW+2Pz/pyB6
         XkMszN1G5RhT33rGeCynOMm41OAYhQh0YGCqDf+cJapofC7Gf28fr3aAdeSNOFq/Zqgw
         StwdAJM/iI4LQa3xUq9pNdk4vtFFrDICDOF/U8N1ABAcTvM+FdGHq7Skv63AjJoCi/E/
         R1tBErzP6o9lD7H/hU7hiLnjd3CaeogBTrBrbA5VuY4fxZIuq+t/ZZnCufpHlK6wifXY
         7RxFfCRhFUTvNgHnU/pRxeg7yc7jzSxwQSEvs+BaXpGxMLyaQmHXCK8JSruRxlkseBH2
         a5yQ==
X-Gm-Message-State: AOAM531oAF/hF35By5oCvA5CCba4dm2bqvuQ9lhfuAihmYRrKyn0YJ+H
        MR4MZrXd1NNC1n1vYvkof8srJg==
X-Google-Smtp-Source: ABdhPJxGgWVbz+lqrCbqtE50vSWt0/z44lc11y5ayxWpykAO+GVqNyj73+S9FbvyLiPNCrPltjWmSw==
X-Received: by 2002:a92:c54a:0:b0:2cf:41d6:52ee with SMTP id a10-20020a92c54a000000b002cf41d652eemr3431513ilj.257.1652474391945;
        Fri, 13 May 2022 13:39:51 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id t18-20020a026412000000b0032b3a781766sm926820jac.42.2022.05.13.13.39.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 May 2022 13:39:51 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/15] 4.19.243-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220513142227.897535454@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <583edb6a-0785-2ea2-cc3e-bd7194149551@linuxfoundation.org>
Date:   Fri, 13 May 2022 14:39:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220513142227.897535454@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/13/22 8:23 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.243 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.243-rc1.gz
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
