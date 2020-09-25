Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7A2279222
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 22:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbgIYUdQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 16:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728088AbgIYUUx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 16:20:53 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C8DC0610D0
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 13:01:21 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id m12so3490440otr.0
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 13:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=13KCg8BltWDl2P2uAh3ad/NLBiwXIfX09whbVzH0rhQ=;
        b=KyhNDaO56Q2soQI8eddWWSj2arCDdVlIbNxWH3hoWS5+yvzk/0luIa9qvWuHK0rnv9
         SKnK3gNJqqr2o4VHrgQJYBtAEv13wGoBOvFkmsbpPyovJ3p2X30wy/TeL2+/JMWq06DL
         3Dd+gXXERpr3x5CNIffmI+gaWt0w/kJWodshw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=13KCg8BltWDl2P2uAh3ad/NLBiwXIfX09whbVzH0rhQ=;
        b=ZogXNBAGHqHDDN835OZTW3QAJujDha1uayoXxEhsAZZC40so8z19rZMOMRQ2e3NuOS
         BhmSflTnM20TUNSOgm/zKfjO0Hj6ykP5Bemg6CC3bcdl2ZHOvb6t7/XXS5E9k3a++S03
         /Sa/0rwmhy9mxuR3Q7/8Z8t5ipwScX9Bi83yypWaDQriWlE74bzrpe+E8Jiue70No480
         bWaVB1EtJU4oQm7Haynhc5oJNLDNoQxQ44K9eDS/7TknNQHd1SVohf9xHclNeIzUdgEN
         nR5r3HifPRPtn6mahoDuDgBU3imXqYxcGrVX5jDuhhoGDEuf4JgCGO8diXr8Va88sTxD
         xUYQ==
X-Gm-Message-State: AOAM5324D7Jt2WCulkp+CSpNG8ih7DtgosFN5NdX+PLPM4yepV2kts/Y
        Oj5sAw8A2fQkKua130rECbKOSg==
X-Google-Smtp-Source: ABdhPJznruHXqFPpZcdEAOlYUYpi2fpDXGv8s1MyHRMedukCmAsm335Q9oinmiVyZZoD5KG2Ymnw4g==
X-Received: by 2002:a9d:7d16:: with SMTP id v22mr1359470otn.372.1601064080164;
        Fri, 25 Sep 2020 13:01:20 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id i23sm46566oos.17.2020.09.25.13.01.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 13:01:19 -0700 (PDT)
Subject: Re: [PATCH 5.8 00/56] 5.8.12-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <da7b88bb-5e4d-a992-be18-e60e0a75558b@linuxfoundation.org>
Date:   Fri, 25 Sep 2020 14:01:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/25/20 6:47 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.12 release.
> There are 56 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Sep 2020 12:47:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
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
