Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58F2A49F065
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 02:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344888AbiA1BQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 20:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344873AbiA1BQu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 20:16:50 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CF7C06173B
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 17:16:50 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id s18so5890471ioa.12
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 17:16:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=spM+jXxnNn52lDoAfnlFKO1BZGYlppu7Ysu4NSLneIM=;
        b=AZ0l3LnEfBmmxq5NGPxepOBu3qEUYKYS04CzAnTdIY0ZXHwdBhJMSI8hDzvBrAC/dY
         rQnlr84OOY2UMcHDn9Rbb42aGpGXbwCDSYwi+ZhCU74Kq+eNYNv+lVFYUt1j2iWY8fZm
         ToDfnLy0jcdsKUDmPL+Xrew/QjnsUiqCOOq10=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=spM+jXxnNn52lDoAfnlFKO1BZGYlppu7Ysu4NSLneIM=;
        b=U+ZMygVUh1G7h9e5yOdz3a93UPj3UZECaumKGXi4z7PJf06JwFgxv2eGq4Fep5+/F3
         hsNnZo9bw4b88xPZEsggTP8scSx2d2lqj9vqivgJ/raYouAXK3bK+R8nPa/+LLG084kT
         kTOptryTYX0iTIqG8iUF+hYrPRo0LruyEyin7tbWLpJUSdYL4D39tgUe85mYg+QDPti6
         knUdQeMxtzdaGWYa/6nM1fMAu5+G4iNnRbw4djfqTsyi1gNASV+WYfiofWmEfrls/FWS
         VtzeQsLqQ7V4ZK3G1/CYFhmO7nkPBy60knDxDcCZYDuSEpagxKq2Cz4PWgL/ExX1fqms
         M8ug==
X-Gm-Message-State: AOAM530kpuqPlKs5lKPJJqFMhBb0/Rb56eDWgqNZjsmKgIw83r3ZLwNF
        iZIXMLye7rGffujNngLcDHHeiQ==
X-Google-Smtp-Source: ABdhPJx7FMO6eytPOxkRAladEq5X6KbVrxjV1uJGdjpuL+IEIiDnMl9lnk8ug6bFxIFAZb1hQU9h4w==
X-Received: by 2002:a05:6602:1483:: with SMTP id a3mr3917025iow.8.1643332609693;
        Thu, 27 Jan 2022 17:16:49 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id u17sm2191216ilk.49.2022.01.27.17.16.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 17:16:49 -0800 (PST)
Subject: Re: [PATCH 5.10 0/6] 5.10.95-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, Shuah Khan <skhan@linuxfoundation.org>
References: <20220127180258.131170405@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <50001ec6-0600-2cdc-2fb2-2b972688a207@linuxfoundation.org>
Date:   Thu, 27 Jan 2022 18:16:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220127180258.131170405@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/27/22 11:09 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.95 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.95-rc1.gz
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
