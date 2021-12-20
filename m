Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98B6247B618
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 00:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbhLTXRu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 18:17:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232867AbhLTXRs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 18:17:48 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE506C061574
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 15:17:48 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id k21so15420258ioh.4
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 15:17:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bUaJ8TI2uYzpoThJGSZhPUPN54V00RYXP19sZvv/qaY=;
        b=AHHXXrxDW2cVII9frd24N4SB7NpwTEc0v0vkTHpqvlwvqqERBIHHPFr4dQbgXMNKPh
         zJ4hnZ62alGoUs6/uOthfu9i/rrHc998TLGpdQWPFId3n08tDlZQkzjACC5tArBRnY8o
         lPHMZhoc7NEsVnoOaCIbU3UVfHXYogiT+QTQk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bUaJ8TI2uYzpoThJGSZhPUPN54V00RYXP19sZvv/qaY=;
        b=TXOwfW6UahKQtD6Opsspnz5plEjJTMjrxWS8Fn09ZCdutJW1q8KGAtNhuO6p4+LOm/
         QufdkaOZARW7XSAKV8588pPqJCU29zfwFgR6g3YS/Gc3XubcyevhtkLPIuyXreYQ0WMz
         ldqa93k2R6ULOIioK075v8GbGwXTLmHiBbY7PvM8xsFTKVBMcj49D0VXg085swaiJdC6
         Ej5/vgQV3Mo027JVJ5nnCHI5cbwo9LA6eMTEUUbxLJ3XSE6OW6fRrBKXEG3xvJk7R3wj
         xUewUhv/1d1IJqNaqDZFGsYEzD7t+oXaYb/zimPSkK2gx/aPYt5B4SU9U7a+OgVIZDTC
         QSQQ==
X-Gm-Message-State: AOAM533sNsTsKwLE0y4EQ92rSRXikOg55teclAJn2U7A1OQNN5gSJl/Q
        6jetlKnmgh38Jci3NWXfT0dCcA==
X-Google-Smtp-Source: ABdhPJz3tfwtFCKjqlYDFqFr+0wtePeirKYgTtDDxPk61b+fUEpGXCMojgUThFCKLGojJyYhSXXEMQ==
X-Received: by 2002:a05:6638:3823:: with SMTP id i35mr259808jav.213.1640042268164;
        Mon, 20 Dec 2021 15:17:48 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id j5sm6557816ilo.77.2021.12.20.15.17.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Dec 2021 15:17:47 -0800 (PST)
Subject: Re: [PATCH 5.10 00/99] 5.10.88-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a47195a5-f717-9966-5589-0ae415670410@linuxfoundation.org>
Date:   Mon, 20 Dec 2021 16:17:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/20/21 7:33 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.88 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.88-rc1.gz
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
