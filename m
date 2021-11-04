Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5EC445AB3
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 20:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhKDT4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 15:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbhKDT4s (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 15:56:48 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCACDC061714
        for <stable@vger.kernel.org>; Thu,  4 Nov 2021 12:54:09 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id l8so7366885ilv.3
        for <stable@vger.kernel.org>; Thu, 04 Nov 2021 12:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=U3547sQGPLTdBzBYzktrOIs+ManhydgKDTQCj9cHwhw=;
        b=Ycei0xMJl7zfFPa948iwjKhELoByhmKJ7BwXK2Pwk//WApTwXpwGMBlTVytMUBQYbk
         Rmo4o1dmkiknctUlkID85Lfw6j6ard30YOl0NaSFUT/JROvIPalcMpl4DETUpwjLAOVT
         f3a/Zy9C0OzBjiDEiwZfDCnagU/PODDrbVUaY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U3547sQGPLTdBzBYzktrOIs+ManhydgKDTQCj9cHwhw=;
        b=L6gz7PMhUIRNDT33A3+8NkEMZcPezDMXByme+WeTXZiOxuUpbywT6qrMPkVPngK7ix
         zkUKV9YpqUjhOpjS2w30YXRTjscFHztNskpDobrv0liLz1K4qj8rNXhY6IafbHZJ2GZW
         1f0iFSCXnO6o21Dp9HeRKgddO8Kj9q968mpYSj9BepSpcxQBNMU8tTnSB97x12Cu9ejF
         XTYE/n9j2NFwxQVhVQdGaCp+vl+Q2hguYybCfirMSQUEDAOFgxGHaHuZ9ZEBggPE/50f
         6uiLcpWFr3lAMZRxZWHyVyBvts6zkEys2UQmBUERYecSIpAcpP83O0AnUZA7UmabY/QR
         ZsRg==
X-Gm-Message-State: AOAM531uYnXtoruIgCwiDp6r0n9CEWImKPW4EITAJ6dO0mOEA1KcKYh5
        6rnK8ZH1ZdUVXeeDjF1llbd+fg==
X-Google-Smtp-Source: ABdhPJyskKMzzjgM9tD/4f1P+07BJEBCIWUpSdCbOrkc27PTQKR1Ucd9KMy2xveensgTwyNbXQFZqg==
X-Received: by 2002:a92:d5c5:: with SMTP id d5mr35020938ilq.307.1636055649103;
        Thu, 04 Nov 2021 12:54:09 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id g11sm1471853ile.30.2021.11.04.12.54.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 12:54:08 -0700 (PDT)
Subject: Re: [PATCH 5.15 00/12] 5.15.1-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211104141159.551636584@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <01f04914-9a79-a03a-5202-64d980967ff5@linuxfoundation.org>
Date:   Thu, 4 Nov 2021 13:54:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211104141159.551636584@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/4/21 8:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.1 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Nov 2021 14:11:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
