Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2690746A589
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 20:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244950AbhLFTXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 14:23:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348367AbhLFTXw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 14:23:52 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CFB5C061746;
        Mon,  6 Dec 2021 11:20:23 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id j5-20020a17090a318500b001a6c749e697so451002pjb.1;
        Mon, 06 Dec 2021 11:20:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=x3N2412fzQ8zw/DhmHNSvTfe3uqJUP4r2Qcfq1jFijE=;
        b=GN7zo7F8y0xfl6SWfQ4RwZkD+9Ns3XF1UnvyN2UsH2ZKtvDyQqbQy/DgwBkHBOJSz+
         /DAsADFXYnpx6kgCCNyZDr2CzdGUiYrqumVOt39SIZXD1BsOjDBvsTq+2TIiUA4hFAIL
         U7A7NCtfq1vcHQk/kZte9OkaC/gcQgHr6Sowftn5wtOiqO3Rya9JuY1nEUn4//J7iQvd
         aVrdEiwL3gFVZWG9PVuN8HjDv6xJJP3+VFJGF1Ni4HC/n1UBr3T66NF4fzFJsGCOV+Ah
         L0tatESrIG2gDgBEsVxkqWLbqEGvYxU4subqf12GUtjNBUMeXxnHWg9TvaNrSBClebvE
         BMjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x3N2412fzQ8zw/DhmHNSvTfe3uqJUP4r2Qcfq1jFijE=;
        b=Ln4Ww5YNxTKyXy1VpS76N3tNXxR/S2yA3nPGFdYWcA/Lz4fM2TtbBo2VhO1hGJa2PR
         U4AX7JaO1ZR8okvyBWO/duOc2HSNlsxHiXYatFQW3hf1VoF7fSRIwBj6Zlq0IZHqdEaP
         QFXpvd61PqsEXl2a6eFamQxqYwo79iNWALmqn+AorY0chDOjBtemXXLBtlVvbYXdNUCq
         BIFZHdA6+Yzxl1sd7e6Vw9yx3g3dm/u/YHm0M/8+2mUGix7J9S0jmgW0gw4UzWskGQ2X
         ym2OMpY/h3cbx30h6khlY8X+LHb3XE7dnKPYXB/Oy6HgPj6hjhQL9RBefYSe4c+9Dx1Q
         YHvQ==
X-Gm-Message-State: AOAM5306KmuUlj0QaiSkZy6I/ElFV7vuip/zZVjYetL/inrpIKsQ/+Bu
        I7NtbayaxTdJJXthxTh+vheoDJsuB5A=
X-Google-Smtp-Source: ABdhPJyxR4blC7/F8hVf8KFbg36PnXDyoBMMQiVwm3Mo1h1VWWAAXdHanmiqlnxEuGATjYxeGQug5A==
X-Received: by 2002:a17:902:ce8f:b0:141:f85a:e0de with SMTP id f15-20020a170902ce8f00b00141f85ae0demr45569830plg.69.1638818422623;
        Mon, 06 Dec 2021 11:20:22 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y10sm12373934pfl.21.2021.12.06.11.20.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Dec 2021 11:20:21 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.10 000/130] 5.10.84-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211206145559.607158688@linuxfoundation.org>
Message-ID: <ef62c484-b842-65e8-94bc-6b30bdf39525@gmail.com>
Date:   Mon, 6 Dec 2021 11:20:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/6/21 6:55 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.84 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.84-rc1.gz
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
