Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E80627EB10
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 16:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730548AbgI3OhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 10:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730107AbgI3OhD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Sep 2020 10:37:03 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC4DC0613D0
        for <stable@vger.kernel.org>; Wed, 30 Sep 2020 07:37:02 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id w16so1930243oia.2
        for <stable@vger.kernel.org>; Wed, 30 Sep 2020 07:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=G0Tp9ZfoIo3LFv8KTFMV+VC+klgfbRR4XK02o7LaaWg=;
        b=CqAt1n/w3lJk5GCMmpiKWlsf+GaZV6lWWFJtjT9qbjuqaha/gS1VYTVDRT04+SolCf
         qVRYBh4L2Mtmftx1LUCo13PDQ18SefRTYbPueIWwU0h2/+PKUBSBcxE5tyJVGN8E4y/v
         zyTDfODLyKLFjmcpCZL9M9LcJGfYE76HI2m+0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G0Tp9ZfoIo3LFv8KTFMV+VC+klgfbRR4XK02o7LaaWg=;
        b=gFGKwcOsMNJVWvzmNtTh6F/qQL/BOBAexaFIabhX5dzN7PoAefKS6rUQtgnBWu2bjd
         DXtLGn2ngjYOKURNICphKdmNL3W12Fid7kZQAXrLC3XOwEFqydF+yK/oCxByxRuzjwOR
         rF9dRPP+1WlZEOeO3O67FBFPnCg4ESlG5YB17F6E1mVCdqq3/b0068K4lmnMyz3OGvX7
         gvFy5jFuL5WL+6R+flM+WcNZbe6RThcTO4qprT/NsrFmRCSpfB5DBzLjhFLnPiIgHvHY
         7dwkrXAH+6jmAsOn04bACow6+2htQ/4GgkPvHIT3kKbcG3rUjYQAR5QAt1ibiBPPNsc9
         sNMg==
X-Gm-Message-State: AOAM530Q/QLUFxvCgDixJ9VtM3LLzxISJCEOwNMvOhwkQSUcIOCVC80H
        KMWt1tpkJJKPljdZxcMDWe26Yg==
X-Google-Smtp-Source: ABdhPJzTiMjLvgy2FRC1XmDR8HbhENqYP8B3Y7Lyy8TxE/3R89Hg3yzwOHXz31q2A1xMooorMbRBMQ==
X-Received: by 2002:aca:1e08:: with SMTP id m8mr1492334oic.168.1601476622140;
        Wed, 30 Sep 2020 07:37:02 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id w25sm406807oth.22.2020.09.30.07.37.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 07:37:01 -0700 (PDT)
Subject: Re: [PATCH 4.14 000/166] 4.14.200-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <cc9d3436-6c8e-c25c-943b-779bb10f89da@linuxfoundation.org>
Date:   Wed, 30 Sep 2020 08:37:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/29/20 4:58 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.200 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 Oct 2020 10:59:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.200-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
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
