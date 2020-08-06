Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75A1923E23D
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 21:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgHFTcc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 15:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbgHFTcb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 15:32:31 -0400
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA1FC061575
        for <stable@vger.kernel.org>; Thu,  6 Aug 2020 12:32:31 -0700 (PDT)
Received: by mail-oo1-xc41.google.com with SMTP id z10so6927330ooi.10
        for <stable@vger.kernel.org>; Thu, 06 Aug 2020 12:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NMtEtRWa1Ph/hgihSbCj1KJKI/E8qY3VELHB6UZTdgc=;
        b=VCGYUSclUfOZl7vC4H5liHx7E+/cNBrNj8GBNv6sZWqT0A7vpBxz4c73r38xclb+Gj
         bVJoGbc7NtmxdmZDC8jaefAsfm2fwIx0ZDmnPVLU3nQC2iThAKh0RRPICZPlUAbSpW5t
         1Gaoj78H7hEu2Tw2757YUX6ErwruQX64fL4Hs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NMtEtRWa1Ph/hgihSbCj1KJKI/E8qY3VELHB6UZTdgc=;
        b=p6t6Zlh17/qXa8FZGEIHxclvV3JUWx/KzZ9LaC5IWEWcMCK657z0IFELrVnUTAXM5Q
         J/axZqny2DXXBaxH7YJnnErHJxThCWMDhz60NriYTeviAs3x5gAbO18RGt4hMbj4lKhv
         t2Mfh2yqd2NVpxrzM7Kt9Z+x9PPvCQ6KY/GIucZFm2d0rxURYfxwNASCW4SlPqm3ssiN
         U/4FlfzTPMvH8jEKmPkJuTAxyTcIkUE6fyS4LPydcPXGNznFFPDTpwzBmVKrQty2gtbp
         XYenYmUVGAQj4d2DPU5stAq2esxAB6Eq0yijuleEF50wrqjNY5Mcs8eAGVzYk0ugwqH9
         hByQ==
X-Gm-Message-State: AOAM5318mX8ytekURiOoRSVDgqHO6qVgI/kp8Vf6xzNZ5Fp42IiETeeC
        jGqqrOVpXGVuLrrdM6FTmZDCzg==
X-Google-Smtp-Source: ABdhPJxStsoqhs60G3cKrgFfrCvuP22hIVoczjy/r8HluulCmLb7pGDkNZlNxE9LzC09WdQDTmNF+g==
X-Received: by 2002:a4a:e9bb:: with SMTP id t27mr9422822ood.18.1596742350342;
        Thu, 06 Aug 2020 12:32:30 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id n26sm1293933oie.1.2020.08.06.12.32.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 12:32:29 -0700 (PDT)
Subject: Re: [PATCH 5.4 0/9] 5.4.57-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200805153507.053638231@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <cf890bb2-931b-7906-21d2-a263e863590e@linuxfoundation.org>
Date:   Thu, 6 Aug 2020 13:32:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200805153507.053638231@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/5/20 9:52 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.57 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Aug 2020 15:34:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.57-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
