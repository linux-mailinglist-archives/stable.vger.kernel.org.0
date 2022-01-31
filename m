Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1572C4A522D
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 23:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbiAaWQg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 17:16:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbiAaWQf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 17:16:35 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E9EDC06173B
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 14:16:35 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id n17so18865554iod.4
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 14:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=idMe0CYKd36wXcwKiFBZN8raa7mfZgWtRdtJAhVNoII=;
        b=gGwFDNyOpZfWJH7JNQ2bEA54/FEsQGVFI7hCLJsKMvzx11MN4zZtY81YP/WmwqSjPe
         HU+HNtcLOAY1+2L75eyHDvvWWnXY2pX/5h3FpDIeSls9elTLmYVcc/N/d/CyS3A3/sBm
         F4d7lEaiI33XKw5e1w6qvt4yzNKqV8mYshuwc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=idMe0CYKd36wXcwKiFBZN8raa7mfZgWtRdtJAhVNoII=;
        b=5r3RPxuCbuRhxqnOAtcg2jHtntMlp6R2ZDNcRkw+oPR/tAC5T/27M6x/2W/QdTNIH/
         jNre+PIFjgzlqyU+6rHTuCAbU/bQlASN474tg74eOQkTpgdkbJPGUAMoLELjtNwv/MkU
         8bE3I8B0Z7vBpsqkNAvfXAwRkcRN9lsuETxylGqpaQoQ39bqDsohnbqnnyvQXvgq/1MN
         k9Zf85/56pM8e/cHwWO+vi3uhk2Cu9iYB5zow5rMQybukJr6Rf094DFAXdTXZdW+VFA4
         hT1l1kQowpMdzfpRvrlAAV7BB8kO1PbW4SmLrsR/289nHA2uij/mGrT9HOZd1q5S8uKv
         S9Fg==
X-Gm-Message-State: AOAM530+au5GhRor/42+BaGDaRpTrRnhoJRXtDYWAyvv0YDLD/PZJfdx
        5vYG4+2c6oTNCEq4dCSGlu1KUA==
X-Google-Smtp-Source: ABdhPJzikJ5cRwa6CBePapdnCAuUU2cvBMrq5dkCc/9+FK1zcJfcSclmEW0xI5xuLPdFNPdHxVl11Q==
X-Received: by 2002:a05:6602:340a:: with SMTP id n10mr184365ioz.76.1643667394666;
        Mon, 31 Jan 2022 14:16:34 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id e11sm14158697ioq.41.2022.01.31.14.16.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 14:16:34 -0800 (PST)
Subject: Re: [PATCH 5.15 000/171] 5.15.19-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, Shuah Khan <skhan@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <fa68934f-57ce-54c5-4b60-5a6e13b41524@linuxfoundation.org>
Date:   Mon, 31 Jan 2022 15:16:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/31/22 3:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.19 release.
> There are 171 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Feb 2022 10:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.19-rc1.gz
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
