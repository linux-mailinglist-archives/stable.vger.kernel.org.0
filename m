Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4169329B36
	for <lists+stable@lfdr.de>; Tue,  2 Mar 2021 11:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238131AbhCBBRi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 20:17:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238022AbhCAWmv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 17:42:51 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3418C061756;
        Mon,  1 Mar 2021 14:42:05 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id h4so12520427pgf.13;
        Mon, 01 Mar 2021 14:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1ob8ilTZ7fP9ToPkDnHmOh76ZPv3/u0He/IF/nnRVeI=;
        b=dJ8JWaVZFsf3n8+suDuOq51RKULy7AKpEAqg2ElrcKW2SaMeFxEV7kJFhIXDnbtG7u
         ZTOfnCR7fKVsNsl1b8pzxq98AdlYZkCZtrdU0hAEwdALFNNAXNKTmxQSEjvIe2l65A/8
         8QMUtNqrhLgPvQAcCEezG+XJtpbzOdl+YR5me1opaGBTgINZD/8kaeIRyXbFYHGIV3ON
         Wxiqoa13IRrYdPmMmq2otpwBoghkSqGncqXStv39KwtHh0+16+g2eruCZLkrU+gLRYly
         SLy2IyQq7COWBtMnXQBmj863uGmSxEk2wTo5F7IH8YNXIpqWg1gF894uP6vixQaxqgO+
         aIVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1ob8ilTZ7fP9ToPkDnHmOh76ZPv3/u0He/IF/nnRVeI=;
        b=pnAFH1jUYTfkLedgPonDtWdOoKihBZMPxkYGjzK5EJ28WpmKUGdrjQ9LA5CPxUD/ul
         LdYBOLLBBWkmOEPu5cxKRPj2RdNtHjq6cWRn+v0m8WCAFtQ8z3pBthAcmjnDo4Q0u8T4
         /Hza7d+7FZSttDdIE/WfQAY+A5wxCSoWoUH/sl3LbcyrTQ05no8xj+yVoQbXywwsREfL
         8vQTxaZ2cwQJGHc1KWzMiBzS1d9cuyzpMamSlIjXvkw9HEd+NcAGGojEFism/tVNLCWc
         KBb75YbP9zVHohGo7GZsUktCQXArR0lUyOD/poYlR8XmMcVzZthDR4wl9K1mjs6kwSXd
         19Pg==
X-Gm-Message-State: AOAM533qv5eTWuVe/FBUVBR+cpnvzbXwA/dgFtPtUyRfSYIak6o55xuM
        PbxAWKsEkxZMEE9xsD15q43/pptHCT8=
X-Google-Smtp-Source: ABdhPJzTWja55mzBZOErTVLVKh6gqoPvAaLHmLmtRFCk2u7wVugZR5fLk3b8x3mDi1xjlG44KiAf/Q==
X-Received: by 2002:a62:8606:0:b029:1ed:55db:22b7 with SMTP id x6-20020a6286060000b02901ed55db22b7mr471641pfd.75.1614638524807;
        Mon, 01 Mar 2021 14:42:04 -0800 (PST)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id m12sm447370pjk.47.2021.03.01.14.42.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Mar 2021 14:42:04 -0800 (PST)
Subject: Re: [PATCH 5.10 000/661] 5.10.20-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210301193642.707301430@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7241e62c-3e7e-1c50-da45-c613fa1f0246@gmail.com>
Date:   Mon, 1 Mar 2021 14:42:02 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210301193642.707301430@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/1/21 11:37 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.20 release.
> There are 661 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Mar 2021 19:34:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.20-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
