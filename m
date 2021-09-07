Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4280C402D06
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 18:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343837AbhIGQnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 12:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238089AbhIGQnw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 12:43:52 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11289C061575;
        Tue,  7 Sep 2021 09:42:46 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id f65so5038918pfb.10;
        Tue, 07 Sep 2021 09:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SZIQY2jeaisbXv5Qb528dcglvGXsiAr6+8cdcczJBv8=;
        b=PZd51H4/gcCq4PAveHUGRLFYVtCcRrj9TJHCNoU21r/71jPUgi+N4tyPo4eJMw2D40
         DMa8bO3vXv2nCOKBR4QrmB/LwlepQGaT4o5eon18G73UKxpjwAN1KAe/M2Ez4W47P+kO
         OG2nVLH69oxGPoRWCAO51fDtrwU6V22vwpMv0g54DxN9HpJA6J9lAYaow0YCX9kfyHxx
         hl7E7/5RWn6A/SYI6ffOYXRzhVT9YZcwiv5hA0xbqj07cHpQSuDHIVesw596PCEhqYqp
         DUdIKqWNUoeVQcxdoT6VaRXQA+0xQg5ExfsUMKq9n1zRuvXe7MllH2ZYPV7sZ73wWSBr
         Sl2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SZIQY2jeaisbXv5Qb528dcglvGXsiAr6+8cdcczJBv8=;
        b=FrrbyFe1QMyZyOV47LX3Mh0YL216RuCTeCrv8D9dNIvO92q1ZxZ03uMC13YARP4wsz
         BMYwFRGdQrZUXdwyzwVROgKh/Q9VhJ+7FQrAQWCfiHe22n+NClI8xBwWXhmYf0mg65YB
         HWV/IHYo0Kx42mNYMN48bM7YQgZvDLWK6qQ85EvpLifHRtgDeQAb/COmVheQKnvI+Axe
         e2vTEnLXLFdcdLo0/NK1pL+Kn8d5LyVp/XbPpFTLHFhGFDjtERR/KzlYE80DtHjhRLli
         +MUx5mWLCwnqo5V6ZoXj/1BIHA9G+y1GuNQaX6QTthOz68MfO9qyECpxeCXcgxXIe6xz
         oLlQ==
X-Gm-Message-State: AOAM531qzEa1Qulg1GuHctafqx6dW10+X4QWIX2Hj25yEBdeoyoc0j/4
        t3csGnrRatphqtNnrrZgEFA=
X-Google-Smtp-Source: ABdhPJw+3rMrhpMdSPPJXR/0Tif/doZ9t1hA3Y8Bh+lX3/LteJYbxtzYpx22pJs8R1wNcVx617DGXw==
X-Received: by 2002:a65:6487:: with SMTP id e7mr17592515pgv.27.1631032965467;
        Tue, 07 Sep 2021 09:42:45 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l12sm11065456pff.182.2021.09.07.09.42.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Sep 2021 09:42:45 -0700 (PDT)
Message-ID: <6d9fc76e-319a-3254-4889-c4b0fc60a6d4@gmail.com>
Date:   Tue, 7 Sep 2021 09:42:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH 5.13 00/24] 5.13.15-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210906125449.112564040@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210906125449.112564040@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/6/2021 5:55 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.15 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Sep 2021 12:54:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
