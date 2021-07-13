Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F3E3C6880
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 04:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbhGMC3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 22:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhGMC3x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 22:29:53 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A34C0613DD;
        Mon, 12 Jul 2021 19:27:03 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id g24so11229452pji.4;
        Mon, 12 Jul 2021 19:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ccd3jOni1nAt73PXMF2OSvtEykh1CnOrwx8pXACZk6k=;
        b=qmGFMI1sGjDBTkm8iwda/B/XZ0kNpshlEEVLvzgzzhUrNy5EiZgGUmJX6/KnKdX6Cj
         zeC6afFLd6bEJ8hiHAg2RhzDD+kUcrHRQM1Pxs4IuPwgbeJjPMDa8zf0nBFwVwwoZ8at
         HTRVm5ftT8MraEh/lEveJ9H4UDdNEtk1CQG+RTVXYiB4O2QPgKKbjCPvc2ksTSRszqzz
         5ZyGZ3xeg8O8NXzG8gWlXOgYoqIwNV3Erze9MmyhfIWsPqWn1EQmpyQndy/BV2uReTqk
         eTCRGKHKvynDKnUBznYTy+os7sHUQZI4OS6TWsM8l/dmMVr8R0HC0cTHS0R+P1hJlKio
         V3eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ccd3jOni1nAt73PXMF2OSvtEykh1CnOrwx8pXACZk6k=;
        b=Fcb/bbJe84h1APBHFP5EcDP2Fkm8S3GQaeSIdl7qEFcCZ9eXn6lRQM/mvoPwV8vV22
         2sX/Oyu2OWQqPwrOsMYw994P8Me5OtBhPDJw+6grIlgXjCyQdDS18DcIyp/1K4ASf7ZJ
         V8WE07zY7f1FC/TdQyhhlsHxBbFKcIRZKy1yuFII3+rH/t4aGKPW1YV9BQRnRmmPNMow
         ojcUHRqJ51UI1uKvZMGRlJ9WR7nSVw57lrmLwpJPPq/IDOGDtAW97nuil5NvQepcWQRb
         smPR6x8fnO2bsFCrShJz2FmrCOl3yCb2cwfYui1WTQElFVHoorYLJDs/YQxJMecSUXGN
         ZzzQ==
X-Gm-Message-State: AOAM531syGkVPmCaHEMKhdnGvXIy/PpsjXnTQ6CdMJt9ndQ1/+rDbBft
        cg+29cW9TSQLNJjkvN454oazew+0PzMAtw==
X-Google-Smtp-Source: ABdhPJxEawK2k0ByIkn4lJ+4oJmDf6x0C98ymhJkGTmlhda79PRCfDe3YQgVBqzOVSy0YJ+eNqVJfA==
X-Received: by 2002:a17:90a:3fcd:: with SMTP id u13mr1919882pjm.182.1626143222949;
        Mon, 12 Jul 2021 19:27:02 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v11sm14600430pjs.13.2021.07.12.19.26.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jul 2021 19:27:02 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/598] 5.10.50-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210712184832.376480168@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <311e8b76-7c4f-5bbd-dfca-ee9d3e36f96f@gmail.com>
Date:   Mon, 12 Jul 2021 19:26:53 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210712184832.376480168@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/12/2021 11:49 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.50 release.
> There are 598 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jul 2021 18:45:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.50-rc2.gz
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
