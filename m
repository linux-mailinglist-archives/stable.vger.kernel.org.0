Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC012F24DC
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 02:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404153AbhALAZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 19:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404161AbhAKXlU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 18:41:20 -0500
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 900B4C061794
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 15:40:39 -0800 (PST)
Received: by mail-oo1-xc30.google.com with SMTP id n127so163656ooa.13
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 15:40:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H1wwg5CvCf7+UEe8B5Bp1chsw68hTnOjBG43X7pn23M=;
        b=ikIYTVERJPZSUok48ou3dw1bmkwNmpv773xO01ynbyHeE7OqPzjzpRJkhyAVGQkINK
         QqXwYM6HZRCtq+Tir4GS380MD7xe7woJcQq3fAzUIPZKaf/ntA0rKCg71OSqdwFSK4kF
         kxsKfkBymNRJ0mJ6FAb4GrEZv5UIM0ijppOIs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H1wwg5CvCf7+UEe8B5Bp1chsw68hTnOjBG43X7pn23M=;
        b=r8vBLznDLAB9EHvvE5aQ+ARaxud1ic9K0g/O6hhWmtvsnbhRL9lSECkdXu0KN7telE
         GBudhjJE+609gqGkTcpopbiae82/uEeW+wLh+Yuvmr4cDc6uevatwVkyzlJBeZKnBnzM
         xv+Rc+oS3Nb+FbA01QUTdZdt07sagEXZhM0GgS9KhsX6eG76HYryoizfEk2BT2/24cBL
         01dVr6CxZCuD1xMKzOj3hySPK1W9Rg5STb3SrQXVcEcqXBf2c6EwE74q+0nIsH1KNb66
         7IOi4C3LOZWOjidlLga64FZxfbzaiDhGk09yM8aeG+nnL8td1OVw29e+T3SiGXoLJW6b
         FpGA==
X-Gm-Message-State: AOAM530GqkhYKMtk32MiDQzgYTEf0moxmVOj6HhReanyXr3czxAhna67
        Wv91peTiEn4LBgKl3+6CfI2ktQ==
X-Google-Smtp-Source: ABdhPJyOcuOLlV3PwTS9fVcnA3sfs1kObBUVwLXJz+H+i+N/c/S8wY9NuZA/VZh3kQCInxfoK9immg==
X-Received: by 2002:a05:6820:441:: with SMTP id p1mr1075219oou.21.1610408438999;
        Mon, 11 Jan 2021 15:40:38 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id r25sm283261otp.23.2021.01.11.15.40.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jan 2021 15:40:38 -0800 (PST)
Subject: Re: [PATCH 4.9 00/45] 4.9.251-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210111130033.676306636@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <635dc346-908b-963d-a690-712525ddd157@linuxfoundation.org>
Date:   Mon, 11 Jan 2021 16:40:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210111130033.676306636@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/11/21 6:00 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.251 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jan 2021 13:00:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.251-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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
