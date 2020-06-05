Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBE61F02D4
	for <lists+stable@lfdr.de>; Sat,  6 Jun 2020 00:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbgFEWTL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 18:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728306AbgFEWTL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 18:19:11 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5257EC08C5C3
        for <stable@vger.kernel.org>; Fri,  5 Jun 2020 15:19:11 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id o13so8847482otl.5
        for <stable@vger.kernel.org>; Fri, 05 Jun 2020 15:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8mu33PrUuZ+3kMf9sxuSzyPe8VLIGEEmxjelDnG52AM=;
        b=fyy5newW8d0s+UuczWfb5XvZUdoLFSYgujaF8mWZJ5Gf0H5cXoLA5iCZtuqNKfyLhi
         gRGwxJjHvLmSvdSCwj7yeLMbbiNhYl1Sy3xMRPUfadXUpgMeiE8HVaW+epR1TX1o2jlo
         0EF+HcKWguqrfyMv7C9ta2WybysXFWqUroQZI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8mu33PrUuZ+3kMf9sxuSzyPe8VLIGEEmxjelDnG52AM=;
        b=GII2L4UBHkFylIVQDiuYKWxWPbflZoa/ev7zMaUtVKMwh+k+t4/7n0sydj5oRFWo6n
         2P0SEKBUT9rFzU120oZj8k5MYRN8A6aHHAOO7S15mOVLTOAfeTBl+pi8VHipDYsaaXct
         eSNAtToDpjEM8DshaS85IHuJsXyHb4ndUAZePcqxxmLvBR+JuZA1umfFxYdaq7rGQRj+
         7LQQTN35bt+iq/vS8eHQqeD8oGAfu/R6RaFrM5ZsWBgZb0cMVc6Xe9hr8ldsworIBi8S
         UUcQKEzIDpMurfbRWWsrhznkQD7PvtBgJkY4nsbkc76NXyJg5jd7W/++1uUye3/8DqY2
         mU3A==
X-Gm-Message-State: AOAM531qJbUZvedFhcQv7vy0/1DDhzgQL/fjNFSNmPYDH2vqZTrIrck5
        i4l7Kf169Orr5F7jlppvtrJogw==
X-Google-Smtp-Source: ABdhPJxpIKFRYzWzhdETc4mNG/8jq4y78etvvYmHPuGOAOvzkhNcp2Rc+4xlpIiNdtQQAPCsklgEVQ==
X-Received: by 2002:a9d:6c4e:: with SMTP id g14mr6009456otq.229.1591395550601;
        Fri, 05 Jun 2020 15:19:10 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id j2sm183819otk.61.2020.06.05.15.19.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2020 15:19:10 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/28] 4.19.127-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, skhan@linuxfoundation.org
References: <20200605140252.338635395@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <60a4a595-aa2e-cc34-e219-b33635d7e5c3@linuxfoundation.org>
Date:   Fri, 5 Jun 2020 16:19:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200605140252.338635395@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/5/20 8:15 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.127 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Jun 2020 13:54:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.127-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

