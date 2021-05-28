Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07015393BB9
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 04:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236125AbhE1C6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 22:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235967AbhE1C6w (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 22:58:52 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FEA3C061574;
        Thu, 27 May 2021 19:57:17 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id q67so2160085pfb.4;
        Thu, 27 May 2021 19:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dLqSONuk2UjwBsvx9605nBOtmEg3O5JrNPMYpVlT+Ls=;
        b=ZC9e4oDgZ0iKyMfld0FiioZqgCSjr+T8SuU/oe9pAT92PbGv7w5ygbBFraw0pyHZsL
         UiN3GicqVlS76pJM85kxzLp+rLcMjuX6KDGfpQtCVG9QnP6CGQg4yHbt2hnwpvQ3Fpz6
         Q+XFv1cjyYHsCbaJR/VRABXhs5zbGqmN2PMJ38mpscNJ7zFtsvgwxC86KtkaZQviQYa8
         99woapFLkbYDfvHiIirSYC9Jx1VY5d1otZIbLQw5P7q1+I1gA0JeGcfCE0x2nN8O3Bz3
         WI8RVVLG8lg+FKZENSjDrjlm98XwcgX6HK6gFOgKqccr40mSVYPTiOsxTe2XQMitjQuv
         9ZIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dLqSONuk2UjwBsvx9605nBOtmEg3O5JrNPMYpVlT+Ls=;
        b=Z/dmwIUOov8/Co6PPmJ42v6dpJ6U4vJ18z5vGiqgZQWdliv70/WUaZvyhOoxxocqOJ
         9Wp7VQYJ218W3lIri+FimdXKWh9IpIIpNTkUd5S1WviyV7dWwhrzoUfw5+AjzcOJI/9W
         UPD50xHLWNz613xUb6s3e6zXkAvUTK4qIcr7MzO/6+D7XKm9ZwPHl0oWvExqQYmuL/Zq
         1JpU45SSPeUQdPOacc3EBeXP7MZi3mqMWep50hYW9rrLZl1RjFfFG7ZxSKbvVP3iiSwI
         hUPqSBKBtcL/ccnuDVLLnji6ti1XBX2pTcGCjd8huExk3s2w+ULrucqYTbx/pWMukopd
         Q+Ow==
X-Gm-Message-State: AOAM5300T0Z2G+qC8zv8zL3DHqenjoCXS9IF5vFmkSyl0yRMdgdd2+nt
        deSimxn1O+dDXJsefk2cTeFOzTiiel7XVA==
X-Google-Smtp-Source: ABdhPJxwoTq9KRbrON9+hB0gvyg6CFUBFOEe4UDN2IHQ1Au7zXkMLVjFjOhejM++TMgwtKjWt5fyJA==
X-Received: by 2002:a62:90:0:b029:2db:90a5:74dc with SMTP id 138-20020a6200900000b02902db90a574dcmr1549445pfa.27.1622170635345;
        Thu, 27 May 2021 19:57:15 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id u8sm2989229pgg.51.2021.05.27.19.57.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 19:57:14 -0700 (PDT)
Subject: Re: [PATCH 5.4 0/7] 5.4.123-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210527151139.224619013@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <84f26b3a-94fa-daeb-4a89-0ef7c94d721a@gmail.com>
Date:   Thu, 27 May 2021 19:57:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210527151139.224619013@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/27/2021 8:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.123 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 May 2021 15:11:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.123-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
