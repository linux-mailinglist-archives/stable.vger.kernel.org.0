Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A63048A34C
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 23:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242241AbiAJW5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 17:57:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242139AbiAJW5o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 17:57:44 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F84C061748
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 14:57:44 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id 2so8668587ilj.4
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 14:57:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=olwjzzolkxTZm6VoWqPk/AeFvkT22BoZEg2TAOI6eFE=;
        b=aYlJzOla5lf6n2hsOcoQt0qkmbz0fribuscBOwZAWabXqODKR6KnSDSZVxAF6Z+vxQ
         R7SYoSxbFl6ARYuqvdDxilArVfzGf6HlS9pdFXRsybtwkoC6VYW2tdjg7WFovO7plfOK
         o71KmNMPwV2PkfmDv1X2daRfiFBC9Tk+z3tTE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=olwjzzolkxTZm6VoWqPk/AeFvkT22BoZEg2TAOI6eFE=;
        b=0D3iFrv2VCzobriycSvMBEWDpdRl6ZUTlyskFzX8diUrgts7a3Ntg/qbC5GVmdViXa
         oftqT3w9/++ILwjNmctnPRwKtO7so32ijYAGyyt21sEhoIBXmhRMDfZO+Cbsx0y5wPBX
         phjfD49BbMu+z9sCDwxMmD+rA8ezoWZ1YxxD19xxpIImQ+toIQ1BvdbM+hUmKIjJMguw
         WuQXCUW9JU2MjMZsYqEThqi8WEJnRqiani2SitwaFqkqWvSxCPeOq7TnoL4fGT7seQdg
         yTWFY3FMunk/MXEcgsTnwCU52udT5KLPdYAbNx8dhG6g0lsdN+DEywhiKDUsVNAL8hx7
         Wrcw==
X-Gm-Message-State: AOAM532Jfq642G77cQsBNpVapZOT99wUUw5YqJv0jcXoyfO4SUSC9bki
        18JnVK/e6xATNLvTUDImV5k+bg==
X-Google-Smtp-Source: ABdhPJzMrbZqD8dxBt5pa33XJyLG0UrH4oeHM4Fjvdki9nRSlulS2lsZz9dIsOJgwD2jTHmh0mv2RA==
X-Received: by 2002:a05:6e02:12c6:: with SMTP id i6mr1048477ilm.204.1641855464153;
        Mon, 10 Jan 2022 14:57:44 -0800 (PST)
Received: from [192.168.1.128] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id o14sm4976518ioo.36.2022.01.10.14.57.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 14:57:43 -0800 (PST)
Subject: Re: [PATCH 5.4 00/34] 5.4.171-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220110071815.647309738@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <de625b1e-7a9c-3953-d80f-379befa1736c@linuxfoundation.org>
Date:   Mon, 10 Jan 2022 15:57:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220110071815.647309738@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/10/22 12:22 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.171 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.171-rc1.gz
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
