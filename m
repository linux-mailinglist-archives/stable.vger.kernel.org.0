Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED27E3A7173
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 23:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbhFNVgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 17:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232743AbhFNVgr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 17:36:47 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0DCC061574
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 14:34:44 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id w23-20020a9d5a970000b02903d0ef989477so12265500oth.9
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 14:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=F2CCCKKRYyKhK6w54cEYBR1fqEzkgZcbtv0dqGb7e4E=;
        b=ZSY1rLZwza9380Bj1Fp0oWa4bb8YnoQk5EXz7TNWNh5d8cv4M6n7xKK1+RpDJ/g8Ge
         p3D8AVsgRiuZ/BwgWxM70ma8P5kKmhx13i4xPI5tVkxFTmasVCaP1Hs7FgP9BM2mF+Hl
         W0JUdIg5CvuVly4vHNiXpdUOixQ1N1i9a+bb4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F2CCCKKRYyKhK6w54cEYBR1fqEzkgZcbtv0dqGb7e4E=;
        b=Mu2fFjW1nDUnkOgsoHbnjh6gdKLbMqUA/zm6W+YvSPKO4ge0PE/YdDf2Al4R952gde
         ZWnUHDAr5gXd5RTwayt/0OkVMUlEQoY5V8PfY4SdzVSOkPdzAWUNaBl4jgAdDiN7Oclc
         Xhw9GOvCykbZiRDtix2Iohllcu30a6/S6TYcDjJBA8wS7o/xGlF9B5JNe/AXelZ6FU9x
         oabl70Yw0qttivKLbii6HRIP7TLHnISIFL3CsFafDVsLEa8rOvuKVlk+yqEEJmjD5t/y
         Q23eY2ORlO5EFlJGl26uKq9nd9Vf6VKyG6jukvnbUUasBLudWIEiA/nOmjAL4izmAk/P
         KXHQ==
X-Gm-Message-State: AOAM530WfOe7id3ppocv3J/AL1FvbrfeFmj/ogeCwDT9qw482RtQaHCh
        OXZUhvwUIBUglDpzobMUyS2DqQ==
X-Google-Smtp-Source: ABdhPJz/dWPck9iUhsOPX0NxKOCRduFfOUt01421264WcHJ3jvBe8hSUA+/rLl88ivee9L6BaW5iTg==
X-Received: by 2002:a9d:1b05:: with SMTP id l5mr15077667otl.335.1623706483652;
        Mon, 14 Jun 2021 14:34:43 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id z6sm3325035oiz.39.2021.06.14.14.34.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 14:34:43 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/130] 5.10.44-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210614161424.091266895@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <44660c85-b4ad-0816-b60c-299595cf9ec1@linuxfoundation.org>
Date:   Mon, 14 Jun 2021 15:34:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210614161424.091266895@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/14/21 10:15 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.44 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Jun 2021 16:13:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.44-rc2.gz
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
