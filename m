Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3384E7BC2
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 01:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234139AbiCYXZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 19:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234133AbiCYXZB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 19:25:01 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE85E27681C
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 16:23:25 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id q11so10625925iod.6
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 16:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ttttrUqB1D8bGTFwn85qoVzd/nW54V82/Iz+e4dnWp0=;
        b=Y6t9t4YmAfH3ofj7+Rh8oyqsIJXZEQnmZRxidwxF7zwknm+jWsJqpefyZsrrIrAi9e
         u+DsmDhsRIui+WdUIx4mQQumG9S5vSe2g/7y2Cjz8lX1fX5Da/1pc5f0XF2OYeJgR2gJ
         eBHnqD9nAPN+Cr0sXMRBQRkK/KOWzZ/R6CyTQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ttttrUqB1D8bGTFwn85qoVzd/nW54V82/Iz+e4dnWp0=;
        b=lauOjJ9/JUW8Bj7t2jxFQTTYSwyDuLrgCzfPJVmIYsujpJ4ACww/o1zVcUTdjFMZLv
         hMLpvLOIcYSm0lB0qHA0OohgoJcAyE69YB9vWydNYNTtyf/l4E0tOJsHjgI/1/lwJGz+
         m+vWtFoynjyFhol36BrKkn2EJpw61u1j9PG+qalAQyL91357Qvij/K3pLRinv/KA3M5Y
         xp9e+RVgtTltkEcvWNhc2xyqUGyTCYH4VSb8jTUo67TIHrfAOePzqv59w8xK8ipfJ6TF
         X9OjFcoVZDMuLiq5j1d0mSIIhLNdS68aNCaNiEr702PVRYZaPZfFKZtN35YJan0iH/py
         HEQg==
X-Gm-Message-State: AOAM530tMwepcOR5XroqAGoeMY7uPgMN/KOkj92an07Ih0TtDld21tKJ
        F47JlxgTTFhChJZo50TVXk9SBg==
X-Google-Smtp-Source: ABdhPJyqJyQ2qixWuTKoSzo/fvjpkAQcbP8rj49kZ0fqLWNP/tZJB4wG2OPrp57EXnSZJ14eAUWG/A==
X-Received: by 2002:a6b:d60a:0:b0:63a:be64:c652 with SMTP id w10-20020a6bd60a000000b0063abe64c652mr741769ioa.27.1648250605238;
        Fri, 25 Mar 2022 16:23:25 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id e15-20020a92194f000000b002c25e778042sm3594619ilm.73.2022.03.25.16.23.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 16:23:24 -0700 (PDT)
Subject: Re: [PATCH 5.16 00/37] 5.16.18-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220325150420.046488912@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <c5861145-1c14-7e52-eb6b-8238bee9e343@linuxfoundation.org>
Date:   Fri, 25 Mar 2022 17:23:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220325150420.046488912@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/25/22 9:14 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.18 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
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
