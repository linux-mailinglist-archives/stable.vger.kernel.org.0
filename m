Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8FE32B044
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344680AbhCCAyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:54:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383537AbhCBWi5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 17:38:57 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B55C061788;
        Tue,  2 Mar 2021 14:38:17 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id i10so5628186pfk.4;
        Tue, 02 Mar 2021 14:38:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=16ZsYeV/ZdwWP3DCpSIRW9ueEChomR6vgL2YdoWwzwA=;
        b=H2d5kSfv+pw836sRSAVCES3eU6Mva3juAldmt+kabEIZXIUBAcc6Md3/QB2pTKaujJ
         G44djHwrNUAYMlBViFeLDM3YpuRyv6vzHp4SI2WU8fRZjho6C5UZTbuuY0RnAyiiCYHJ
         uUf7qXc3rTB2RaQZ5ctoupmX+07bC+nj0silk619ptEQ6o5KVEfGizNFm/iUcgxfFPnZ
         lwdOyV6vFCC0q/SgAqM3cEL03lb0OtGvRnOZDPttYQNS+6H7IW+a3j40O7XEUxxGWlRb
         3Q2UWaBn7j6tP5ifZBQ9+JpKCy8ba4zknTundlx/LAdOfIa+lSPtyIh0ZN5y07p+P7fJ
         sRhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=16ZsYeV/ZdwWP3DCpSIRW9ueEChomR6vgL2YdoWwzwA=;
        b=NemGJezmRUznShf4XUxlFJXsC1wpS9YNTIY/O1q0KCorb1GELUNsGTZr8KPTxnzkni
         yGSu4f+zIo8EdUHzIrxnhWq3Ib5g2RRSCmcbiDUYEIqzktE1Xt3mFyOC63diaykGJCH0
         WrANBJ9MetGqkegNQpWbfuwp7zY5qhpfW9XdGzZfgHzT8LtLewCt32peKpqGFyCHpVCa
         atSqGdrGaa0wLfTHetF/SytEfO+qcwK2PH2D024bMVDqeu0Lnp8nt2w4NO7i4nMcbGHL
         fbtyBsRfynhaUKytRN1rjeR4lHpVyv85aYpW832mBDRvZug5HS01lTlfFzgLw2IG90aq
         aBnw==
X-Gm-Message-State: AOAM532pUcm3q/oLWZcoVjRSj9mvc8ou6pi9H3IEeMLp8HmB+7zT+tN4
        X1xIIAuZBmFJXfef+V3S2UcjNpbb7Y4=
X-Google-Smtp-Source: ABdhPJy/PoQitzmFU7THgSQysUFTtdfwwm2EHOuLzpD4xUOmczvel0jcOLnwJIEjTU7Tt4jfQw9pDQ==
X-Received: by 2002:aa7:9010:0:b029:1ee:253b:ebca with SMTP id m16-20020aa790100000b02901ee253bebcamr47090pfo.53.1614724696559;
        Tue, 02 Mar 2021 14:38:16 -0800 (PST)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 8sm4654737pjl.55.2021.03.02.14.38.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Mar 2021 14:38:16 -0800 (PST)
Subject: Re: [PATCH 4.9 000/134] 4.9.259-rc3 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210302192532.615945247@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8cb35629-5815-2bef-6859-1de4cfd60196@gmail.com>
Date:   Tue, 2 Mar 2021 14:38:13 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210302192532.615945247@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/2/21 11:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.259 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Mar 2021 19:25:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.259-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernel:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
