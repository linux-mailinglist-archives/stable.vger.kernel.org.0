Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B37049EFF5
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 01:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344715AbiA1Awr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 19:52:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344693AbiA1Awo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 19:52:44 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C593C061714;
        Thu, 27 Jan 2022 16:52:44 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id my12-20020a17090b4c8c00b001b528ba1cd7so4933394pjb.1;
        Thu, 27 Jan 2022 16:52:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=kJNJijaZP88bXaGh2neEJJTBJFiP0w2gHmp/ePTGmfE=;
        b=Po0m9GwR4K5QGnYFsOD9VIGezFAmYKv8sSEdSQs73gaOb8zTj652zlhO0OM0JocENu
         phKz4ktlibQH+zFL1blG7oFD1ZlZx30uYh2CObrVThOm0EbY6jbHrT3i0WaiDRjwAjnd
         sx/umYh1v7K/ChixkoP0/+6F70WfrHLDGsyNw6mBg1sXbh+pb/Qa3EXYkfmcB8ehA6vv
         lc2uYUtw4O3Rq+62BuvhdYq3sBgKRkT+S8+wnbikPY/tf239JndUPit6GRzjXeTSt0tQ
         nQQ6BoTFj2M9V6Gk66qnPqIXLBRaP/RcF8FmYSYMJW+hRrbHTwGgcxjOgT1xhsJyI3PO
         JstQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kJNJijaZP88bXaGh2neEJJTBJFiP0w2gHmp/ePTGmfE=;
        b=EqUwkshUGUua1HcEukLKXabq8D3KFEowqDofeLjzhlClA80a16hrbk7PZaUVu0z1vy
         /KNfIlEFoBNLps7MLZAIV0ZcEGbyDfyZI8fkuzmUZTwuWqNSaVPnHj2aGzTHJpl96WVj
         Oh6UKwmnjigrDjfJa/wTR1oj7wzyo3KG1Zn6DpyviCyaOvqfB4i6N9Bzy7JN8rzKw/+T
         fXwawa5fp4tgImveRelpYugOidRa13srMULZmOZKomSPtTPmQECfaDbYkNXpuWhYLzEW
         hzgQB/7nxWy3vkSVupq7md2+4lElUacZj+fEmmQzs0WyCczYSDSZxYQgb1V+SL04jp8q
         Qykg==
X-Gm-Message-State: AOAM530jG4Ip362UFGFrTZptgBkHlVEUKEVES905PrJAMD+MUM1QOdlu
        EgMD6BMfu+n5YIDZgaDjWiA=
X-Google-Smtp-Source: ABdhPJyZvcGvnXTFOj9DXoRU8MIzgborilNzBKzkr9QYRaOpCf2XP6lo3DCpe2B59JJJvtpYn+yK7g==
X-Received: by 2002:a17:902:6b02:: with SMTP id o2mr5684636plk.56.1643331163740;
        Thu, 27 Jan 2022 16:52:43 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id z124sm6529852pfb.166.2022.01.27.16.52.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 16:52:42 -0800 (PST)
Message-ID: <6bf2f177-93f9-c1fb-ac06-ffe946a72abf@gmail.com>
Date:   Thu, 27 Jan 2022 16:52:40 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.15 00/12] 5.15.18-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com
References: <20220127180259.078563735@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220127180259.078563735@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/27/2022 10:09 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.18 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
