Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADC9336B1F
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 05:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhCKE1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 23:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbhCKE1b (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 23:27:31 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F63C061574;
        Wed, 10 Mar 2021 20:27:31 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id n10so12853633pgl.10;
        Wed, 10 Mar 2021 20:27:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dnvZsVGYoV6b36V+gQHP4wJ1jrXvkrRSflx6BXkt3as=;
        b=XoZF6bbzldAfLbqUOfjVda/PK+XcmgtntLcPcNGvkYJMjUUrgsTAcQli3g3dK9Wr3k
         nN4MKKTDSdVhEdqgJrcUrLQsX+T41LwkPtqmAo86hLcXo2nTaAQKjPqCKvO4ORZLtF00
         pIKA5lL6W/OwEEh3VG66+sH1GEoTAoGTX0/pDRJswWjo/yFiwr6eyB0EiHiVmf9p139E
         iXmnVTX+y0ef7RdukbXsKvk+hLT6mFSCDiyvZow4hV5/MGzmAcqJ8ablYemXhDpxkg5t
         sjmLppgp0Z2oqaHyhYMbmgwAEI61snT3p6lLSX3OPj9bBwTzty9GN3M0wIOKiXTgc0o9
         Hnzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dnvZsVGYoV6b36V+gQHP4wJ1jrXvkrRSflx6BXkt3as=;
        b=IofL2saT3Ym4k943ti5ofHGDBGfu1awd8NinaL+74Q+psx8tlGHyTKpI3PS4zJQR8z
         gl8AYX9HwQr2QIfD3EmSa2W/azHD6jdHKyb6BrJvUbhEQdWSGNfR6BRWSI1nG0xOnRvF
         BwHOAbvb6ZZZDNSa8c3JKgZhM/vUCflBXFpAaqYfGRwUyfmvDICdbVDsBjdTdUA05vcY
         acb/rSXT7uf2CxZua4AwUHHnkkCfgrcMDrGiJQZqYfMNMJ0NpWYD07JaT1j2pCalZmS+
         t399tAp44wXBwM1bhngtbBVp3G12fehk/Uu92/BEpSWIV0IcUG9A6iTLgqy2vx1DqkYl
         eaeA==
X-Gm-Message-State: AOAM531lqwIzNjZKhl6OrKah7hA/MDb9RnlQ7EewJVhQjdI6oKghU1D7
        Uj8xCPcxbkqsEa5mfWtLpq8TmOCbeAA=
X-Google-Smtp-Source: ABdhPJyYdueLP9mElLdy2/vn8wKbZxU3sNeFFszJ82SyKlkFFjjP1w/Osq/5k8DuYGCfSs2CHdT+wQ==
X-Received: by 2002:a62:1d06:0:b029:1fb:94fb:4940 with SMTP id d6-20020a621d060000b02901fb94fb4940mr6002289pfd.6.1615436850557;
        Wed, 10 Mar 2021 20:27:30 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 3sm778894pjk.26.2021.03.10.20.27.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 20:27:30 -0800 (PST)
Subject: Re: [PATCH 4.9 00/11] 4.9.261-rc1 review
To:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210310132320.393957501@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <dd235a40-7570-52c9-0e17-7be771c84ddd@gmail.com>
Date:   Wed, 10 Mar 2021 20:27:28 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210310132320.393957501@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/10/2021 5:24 AM, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 4.9.261 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.261-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
