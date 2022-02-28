Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5253C4C7C32
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 22:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbiB1VjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 16:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbiB1VjM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 16:39:12 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6031514ACB2
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 13:38:33 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id c14so11108490ilm.4
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 13:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=W6r2tBqQqFi+W5kJeIeQwgqvc9313JSqojftPaJRMNs=;
        b=YriAUHDaJ+vhmMjXjuMURPG5s0MG2rDE4RqziEd1rwzYsWZj5t2fO3axkb9P3Ettp4
         sYWrxAWDokGbWR5aNGzClxjb2JFX7wdGgva9rZQxVPEU+gzBw0ZOkD+lBvVz54ACN8mS
         d7bJ67B4ACGaBE0y2r/4HAfrS5ubTq89ViNT4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W6r2tBqQqFi+W5kJeIeQwgqvc9313JSqojftPaJRMNs=;
        b=0TOoXr2CJ3kt0ELmiRX/HBNe/kxZ+aP+P5UKWTWwhwXIfuN/9I6xdBg/AMgDgTfnpc
         FFVxMWSpvrLYr0k/oMRi+uiZ2jZOmd7fMoN9TUkDD/6e0DP2QefcmWVx8EQ9FGShlljO
         8UyL8PbcC744+UKnng1KzidVQaNhfbBnxMo2HGH8Wm7/coUt1NkiBujg5YVgbWPNSLTY
         qSdTrbQMNy+2rEE+zQTZFpuJKF+nXWTOCcjnqblshY5xB7OnBz7QpgzxT7kDPAK05dHM
         ItDVXS9E9gczWVPD9g0i3ALCAr4jl7k0tBkd98F2zoQFrk3FLNKtK+dORKOisLEG4Ofy
         QKcg==
X-Gm-Message-State: AOAM532OchzH3wyZxBxwuiY2wK+kkqx5yRi8TsZZm7uIdEZTrYGrT6E+
        0bNNXAftastyrnMfllnKUQ5aPA==
X-Google-Smtp-Source: ABdhPJz9a+UhrjtaAdZjYUY4JBpamVHmJ5J9xSHgRlVwtlfCJcte5UpMi/wF5DYRJ5Z/XLnZ0tOyHA==
X-Received: by 2002:a92:c888:0:b0:2c2:fb23:1cf with SMTP id w8-20020a92c888000000b002c2fb2301cfmr3155791ilo.301.1646084312808;
        Mon, 28 Feb 2022 13:38:32 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id o4-20020a92c044000000b002c1e884226asm7056016ilf.12.2022.02.28.13.38.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 13:38:32 -0800 (PST)
Subject: Re: [PATCH 5.16 000/164] 5.16.12-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <d5aeff38-3bb9-edac-684b-d06c52393551@linuxfoundation.org>
Date:   Mon, 28 Feb 2022 14:38:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
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

On 2/28/22 10:22 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.12 release.
> There are 164 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.12-rc1.gz
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
