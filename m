Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58D453748D3
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 21:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233287AbhEETqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 15:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232712AbhEETqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 15:46:01 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8233C061574;
        Wed,  5 May 2021 12:45:04 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id m11so2725133pfc.11;
        Wed, 05 May 2021 12:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WdWRuURhdSCNCPBKk/uClJ6VTdaDbNbIlQLKB5FSSZU=;
        b=N4iPwl94hwcjbZYk7TfGHiDtxjrI37b0Kn2lHE+u3SYZr5BBLreDBNe5qqVlymo5Ns
         9WpdBi3PuPWLUKDhg6QHuICKvGNLQP/KPqoPCxa/OIp9WewV1BHeneJPp4drL6/mcT1f
         tmSNn2xPvVO3MxOqG/iA+/e0EcY6yjuM7iKV11eJ1uVNrWVd+SsVq7noo+yLwIsf05j8
         lwdF1wEeJD+5dBxZi0Nzr67UTjS7WBAvhXfExOiweiLPZyVnpFIWo6SnC1QkN7wz0O3C
         nuJQnBOEaNEhMsqY0SNLi2EFqwXLTCxKSJB0dd9hCghoaUtzv7NfLy4JLr6duBcH4PCs
         AoVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WdWRuURhdSCNCPBKk/uClJ6VTdaDbNbIlQLKB5FSSZU=;
        b=uVYySiBiWByIdsyBm4bPqq4Z/h/6y/7xGXXQcQ+/gG937AlvEVZbsHkvNbXQUHpz1B
         T7glFxbKarhqEodZh03CAtcY+DXKvt5fevbn1LIYE2QArSktTp8FAJUXWgYxskTvhExb
         0hV1D96J+hgqTwPJXBwzD9LHPFf3RsPapspAyi1eyenyUH6PFeWZerozASXy4+o3jyC7
         Vp5M5mukqSdPCgXSRmtBOCum6ZQNipaPvh2JiQ8kim6dGJpo/q3ejCQHjaXCWwZ3bQZy
         8VcL59SUDCn2Nckq2cqkwODnutpouQoyXkIFurTypuKnSALxxli7g94Jhd+1UG7vWUo5
         nxiA==
X-Gm-Message-State: AOAM5328qMclVsLxRdsfntZO1zZbHze0eZ0eeZPoVjVubLeJB42m5f7r
        8Kz0cpuCUPxmO1esmERa7EDG3l72JCU=
X-Google-Smtp-Source: ABdhPJw99rjrKTXTzVSJOVKthVjlL760kVVU6FH1oOrRsV7COt7dOCn9zUMNONvXd1mUiyYwcedEvQ==
X-Received: by 2002:a62:1602:0:b029:28e:e994:a37b with SMTP id 2-20020a6216020000b029028ee994a37bmr402232pfw.31.1620243903914;
        Wed, 05 May 2021 12:45:03 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q8sm46274pgn.22.2021.05.05.12.44.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 12:45:03 -0700 (PDT)
Subject: Re: [PATCH 5.12 00/17] 5.12.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210505112324.956720416@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ff83cbad-e1d6-20c5-f1e9-1509335fa981@gmail.com>
Date:   Wed, 5 May 2021 12:44:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210505112324.956720416@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/5/21 5:05 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.2 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 May 2021 11:23:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
