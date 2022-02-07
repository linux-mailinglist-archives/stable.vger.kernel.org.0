Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A40DF4ACB3D
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 22:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237029AbiBGV0L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 16:26:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238977AbiBGV0K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 16:26:10 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE2EC06173B
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 13:26:10 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id c188so18657541iof.6
        for <stable@vger.kernel.org>; Mon, 07 Feb 2022 13:26:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7EoFUgOgWrG5ECK0ratgBPQfrtcQ8+zDvDGtD3h4kLs=;
        b=Wh47ewf5v2c0r0u1dUoerKcQVLzeRHIxoUgAjEVWUpOwQc024QhiHZyEV9F99kQ8jS
         MEGixfZ+qzZOMzjsbkZeTySGGvnIBW8vgyJdXmLy2+LCfvYZEp9Xhgo9PiVBpPTF2BIG
         QMu1sSMsZqe+JAUJ0Dfop76rX1b7IlSQf8bY0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7EoFUgOgWrG5ECK0ratgBPQfrtcQ8+zDvDGtD3h4kLs=;
        b=kiZgrW5cR045BuAC4K8871YKHFjYjaO7KA5w8ZmnCfX5/d0RdbgVXpS5f7RfpEra9L
         JPHWHnVjs1f9YpTmsvYVMpIrGUzkkXd+Hv5tEkLVsIGcDVpS36gcUDENAYda+btu01Sv
         ru0LCkCxUXTVE9lvUPkygkKvYZrAn3SH0kyJwEPG8hB/4q4l2ilH2h9+RkECQBGd6oTD
         7nAmPTlOEmUEWqU13OQ4Jh5XszP9+4FgeyHQjJBMrZCnsc5YLUTEhbcv9x+SPq6QBOfh
         OCIVnsdIbAOeFG7ugKohuXuPRp0dI2jOmRxPeLP7dTLEyppST2O8EiTGtb9+Mjk+FG8Z
         xJDg==
X-Gm-Message-State: AOAM530GPJzSoDSo1fC2kUnz3yaduExWXQakVnkFuw3mI5E7/WHFocJY
        l/il8032GO0IWlUHc8Sd0HNcnQ==
X-Google-Smtp-Source: ABdhPJx23gpPSXFy2gfipTdevsv055tCHx6Dig6RRO0hSk6L965mGHz3uYIqozArCFAV5a+usKFbdA==
X-Received: by 2002:a5e:c20b:: with SMTP id v11mr673361iop.197.1644269169467;
        Mon, 07 Feb 2022 13:26:09 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id a4sm5943980ili.80.2022.02.07.13.26.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 13:26:09 -0800 (PST)
Subject: Re: [PATCH 4.19 00/86] 4.19.228-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220207103757.550973048@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <8ff351cc-5cbe-44fd-a339-d9febf8d5ced@linuxfoundation.org>
Date:   Mon, 7 Feb 2022 14:26:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220207103757.550973048@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/7/22 4:05 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.228 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.228-rc1.gz
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
