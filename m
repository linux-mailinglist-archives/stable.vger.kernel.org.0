Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 413CB4735F1
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 21:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242896AbhLMUbD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 15:31:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242902AbhLMUbB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 15:31:01 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F0B0C061748
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 12:31:01 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id a23-20020a9d4717000000b0056c15d6d0caso18680016otf.12
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 12:31:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Vx4DgpKwXYLRyQtyPwKpxXH7HX64rLNuZzcL69veMN8=;
        b=gz1+IY3hZOzkYQ5nE5/Ug+BAAfikWEd0ZE8Eoj28rIYvqYY7pTmfbMjCUtfRNGX/E1
         kqJD9yt8RTIX6Pv3uDelIVgPV9DF8Pe4BmdyT2kgiJSh0aJPkBAqDx8vZHAgrDe2NPMO
         zEP9AAqRCdwS403/FXiC7jIxEC0xQJXKvF5so=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vx4DgpKwXYLRyQtyPwKpxXH7HX64rLNuZzcL69veMN8=;
        b=8Hn6nK8rJ5vj486CqFNlOt2D1rzGwLV8piMQCiP5ul8bj6q/Mw0wAvoUerv6vt8Y5y
         RfESlreKx0uPDiJ3R8Wtkfs9rue8JTxJUk3MS7uixm9ELBrx8XTQpzDW87KFRje7b1e4
         4p+Sxol0kFePyaicbxl6hFKK3rR1vVxajsc4pcgejIfxq1rQYgUe7CSpSLBwEN0PUHDy
         EohdnzLe7hKy4rgxjyVPlkNxWigMjMXRCk5BRiqlD96rG65T35Wn3perySBEVSHWn9OX
         sXh1esdkyLkZleIrOq9svOy25s5gJXdOZTTvUXnGsyIQe/v7pVj3w5MlCK5pHoKr5EHl
         6FaQ==
X-Gm-Message-State: AOAM531P4C0tT6VkhPG5T6juB/n+0ISCQKteP/JhcvK55hjLEs8T+rCX
        uwlmQdFTh6gHaJOU3/VsJ26CEQ==
X-Google-Smtp-Source: ABdhPJzQH5Cr+HPyv0+zGjfQ3BewhWHUdoI9MOS0kbdKvtKXhJnGNGObcQ7ap0P/aJhQ8a9M/rC9PQ==
X-Received: by 2002:a9d:7a42:: with SMTP id z2mr703438otm.362.1639427460745;
        Mon, 13 Dec 2021 12:31:00 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id j20sm2859895oig.52.2021.12.13.12.30.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 12:31:00 -0800 (PST)
Subject: Re: [PATCH 4.19 00/74] 4.19.221-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211213092930.763200615@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <cdb87933-1411-85bc-c520-a7c609f70508@linuxfoundation.org>
Date:   Mon, 13 Dec 2021 13:30:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211213092930.763200615@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/13/21 2:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.221 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.221-rc1.gz
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
