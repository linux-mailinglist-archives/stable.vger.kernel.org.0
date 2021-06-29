Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F7B3B7A41
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 00:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234907AbhF2WJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 18:09:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234110AbhF2WJo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Jun 2021 18:09:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20E3661DA0;
        Tue, 29 Jun 2021 22:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625004436;
        bh=fmp8wmZQF2vIRO+xFm7Nvra1PR4LnpIAkBTiTehJT3o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nrB0a94FK3sQIbeh7lETKfmvrJttKPEQrj5xRfo12lycZTTFCtX1i+jpDEDGvU8/2
         0f5kTVnG+5FdiPDlI+Tmw3sgYzU/rJIMac0UzKDgp3h22Ds4rR0/xSshu2SN6okQFD
         mOvmROZTJoX0+C+CbBw1CT00UHu8X1qxSfJX+HUmTsCBrjoxz1pMIz/fV93iQVTUpX
         tRe7FtJhZCySyBSV4v2IiYMf02sc7RMnF3wiK05SokgAY/OMXmQXQxHfxgLbCjr5Dg
         X1u4X4D029EiNgT+GOEY+/wzP38h/VeVOzFYr+VLY/WleZtcahwOXjpdYFXLzzxGXn
         dJTp0/SKz+MKQ==
Date:   Tue, 29 Jun 2021 18:07:15 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH 4.9 00/71] 4.9.274-rc1 review
Message-ID: <YNuZkw3Ko4b6PUEb@sashalap>
References: <20210628144003.34260-1-sashal@kernel.org>
 <ecff1d13-9535-f12b-4efc-e214d7bd51e7@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ecff1d13-9535-f12b-4efc-e214d7bd51e7@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 29, 2021 at 07:11:10AM -0700, Guenter Roeck wrote:
>On 6/28/21 7:38 AM, Sasha Levin wrote:
>>
>>This is the start of the stable review cycle for the 4.9.274 release.
>>There are 71 patches in this series, all will be posted as a response
>>to this one.  If anyone has any issues with these being applied, please
>>let me know.
>>
>>Responses should be made by Wed 30 Jun 2021 02:39:51 PM UTC.
>>Anything received after that time might be too late.
>>
>
>Build reference: v4.9.273-71-ga12e33370009
>gcc version: arc-elf-gcc (GCC) 10.3.0
>
>
>Building arc:tb10x_defconfig ... failed
>--------------
>Error log:
>In file included from include/asm-generic/signal.h:10,
>                 from arch/arc/include/uapi/asm/signal.h:25,
>                 from include/uapi/linux/signal.h:4,
>                 from include/linux/signal.h:6,
>                 from include/linux/sched.h:37,
>                 from arch/arc/kernel/asm-offsets.c:9:
>arch/arc/include/uapi/asm/sigcontext.h:20:25: error: field 'v2abi' has incomplete type
>
>---
>
>Building arcv2:defconfig ... failed
>--------------
>Error log:
>In file included from include/asm-generic/signal.h:10,
>                 from arch/arc/include/uapi/asm/signal.h:25,
>                 from include/uapi/linux/signal.h:4,
>                 from include/linux/signal.h:6,
>                 from include/linux/sched.h:37,
>                 from arch/arc/kernel/asm-offsets.c:9:
>arch/arc/include/uapi/asm/sigcontext.h:20:25: error: field 'v2abi' has incomplete type

Thanks! I'll drop 96f1b00138cb ("ARCv2: save ABI registers across signal
handling") from 4.9 and 4.4, and will re-push -rc1.

-- 
Thanks,
Sasha
