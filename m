Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B56C457FE3
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 18:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhKTRnp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Nov 2021 12:43:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhKTRnp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Nov 2021 12:43:45 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB16C061574;
        Sat, 20 Nov 2021 09:40:41 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so11488240pjb.5;
        Sat, 20 Nov 2021 09:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=rUhOkzknqOIAuwgBd+D7yuwd9NAl7+ukGtBffK8W9V8=;
        b=bhxq/ahlwSxZS4sb0hvBKu2l7OY3q6724v2gATnxS39h2kNXUhS8fag31FUtCpW6YR
         EEJTUs2gxV8q8MqtMQaFguL2sSbgiDTxn4y+66xHK1aUuo6hU7zGh79qfinmbIsZItwe
         KSFVttzZQf17Jb2eAJV1WHEh1t4C58+dPvLOAVYMAwfI6KM+I3I3RXG8EWoSdXFkgxVT
         6bOmvPJI49S8151JE49pH1HUHbDQ9hBbLvjbuDXazV0AOf4Th2Gf5EQUhhHL/9hPlIp7
         Bc/Z1kLCkGIK8ppD3MVVcEDSNmdULMoPSnTZs+LJLEFTIfOfl063UQEDbEPndcPaDn47
         qOEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rUhOkzknqOIAuwgBd+D7yuwd9NAl7+ukGtBffK8W9V8=;
        b=xg3Or+qc5ULC6Lo72p/m/SDE1cvoQHrWYkYlWvHU4+2MSXQ6wlQwdahaHDHYIBO3zW
         KUblr1KW4IecHQPKN2AtbSWyo+QBcG4Et0HNMYFpvqpDF9KVeSe2pqoqv5+jYIP/6Yop
         oGmtNqrt0X2tjNjs1ggzqyO+4OWpBqsPF6VVcZNXMH0xYcVjbxW2VSXs2n1PSWgwhhTn
         7XgQ8E/IsiGqoOyxwfFNqTY/JFBkBP7FDi98ULP+aZJaJqH9a0prCb1S/VgJfMB2nNdT
         zIWbO19HCjNhBM7y/2ImJTMIas/6pOWd9wEH3JoGImeHozR467K0Yv3WBaLfoZKX1nlD
         hxoQ==
X-Gm-Message-State: AOAM531bwkkLuJW+yydLVNp8lI+km7hiQY02Mm+WFWFzask+Jzc5zs5M
        fN50IpIRmgqaw83oBMfyaExhGz1SrF0ubgwX
X-Google-Smtp-Source: ABdhPJy2Szy3i39M0bqfqp/A/f0znpS5TjDqMtKtw4mJD7iR6H4uzIJMZY/lNMsRA0yjjb2vNpIbPw==
X-Received: by 2002:a17:90b:2412:: with SMTP id nr18mr12681505pjb.233.1637430041143;
        Sat, 20 Nov 2021 09:40:41 -0800 (PST)
Received: from ?IPV6:2601:206:8000:2834::19b? ([2601:206:8000:2834::19b])
        by smtp.gmail.com with ESMTPSA id h8sm3773734pfh.10.2021.11.20.09.40.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Nov 2021 09:40:40 -0800 (PST)
Message-ID: <18d74793-55a0-61c2-eddc-e308152a7dbf@gmail.com>
Date:   Sat, 20 Nov 2021 09:40:38 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 5.15 00/20] 5.15.4-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20211119171444.640508836@linuxfoundation.org>
From:   Scott Bruce <smbruce@gmail.com>
In-Reply-To: <20211119171444.640508836@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/19/21 09:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.4 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Nov 2021 17:14:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------

Built and tested on my x86_64/Cezanne laptop, no obvious regressions 
over about a day's use.

Tested-By: Scott Bruce <smbruce@gmail.com>
