Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E41253D68C6
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 23:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbhGZU4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 16:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbhGZU4X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 16:56:23 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149DBC061757;
        Mon, 26 Jul 2021 14:36:51 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id m10-20020a17090a34cab0290176b52c60ddso1952302pjf.4;
        Mon, 26 Jul 2021 14:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QlmZj5oGaEL7Dq8hGfu12op2HSnobyi0+crd+wB/Sb8=;
        b=YJJkY+knNH2pn19ltSNE14F0BSzAZaY74jei2QUKI1pa8+OmZUkZ7kr8S0s3HLVJ5H
         YEbvjPXaIAvUPaaC5gwOyBJC9spYs3ASMFmmj321EVgaz+4auw1h/NAZqcxMi04wjFq4
         77qvnkAXq81A3aZAz4Zpa2kAlDxP7c32RVQ3OR08JPv0Hpzn7jicGvIsUIr77JZH153m
         gXjZ/imOx1R/zcVV01g7HxGGAf/GFQYMDmTdRTnY/KJ8olL4WjW1v0r1tsX7GpOwRs6V
         C1fBG+0GktMA9BBt43UXmpVcYvZSUZ2iZIH5aQ9M8CG4r17yzD7jBVFNa0bpc2n8G+Yp
         nBKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QlmZj5oGaEL7Dq8hGfu12op2HSnobyi0+crd+wB/Sb8=;
        b=myQUYJkn2Vn0gnj/wG4faWVpJEpd+KPjonRFDP60q4ygYe/1Y7i7uIPxs/h3LXo9WO
         v5qzyVnDAtKhsP4ulZDu+Hp2VmyyYTdzz6sy5v37uzxlmbLCKw9Kbl4n4i4sPiETfBoq
         R261mO6bDoHGgOewJrlwLP/7FWW9EO8vRct57NcOHvAln3fVpRSA0Pn+tk4NMlMnnaTI
         zIfoxoX+CbJb5ExGdgKbi9GYtRhV02hs5L3L10SecZ8yMWgxMQFLecn0RFW+zNJ2EPLH
         bKh6rEuvW+DF24BFWCd8ptdz47AdA0sZofWm7TTlFly9obu92T3znuMwaO2uxDgVwNTX
         DrDg==
X-Gm-Message-State: AOAM532T63vzKyphmfGdQVdu0cXER9EgrIPa7NcBlz9a7MtoI9i//r7i
        N5Gcx749nFImy4i/aWuzLDArLwAW+y4=
X-Google-Smtp-Source: ABdhPJzL+ub4kso8INvSD6wa0BJuxmbq9mhgki/bN1FoY7vZ4yf31y9B2ZOy0lXdOLBMcsKKPWUEIA==
X-Received: by 2002:a65:61ab:: with SMTP id i11mr20207667pgv.168.1627335410249;
        Mon, 26 Jul 2021 14:36:50 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t71sm836932pgd.7.2021.07.26.14.36.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 14:36:49 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/167] 5.10.54-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210726153839.371771838@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5108506a-8051-9204-ce05-8d668f4b6fb7@gmail.com>
Date:   Mon, 26 Jul 2021 14:36:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/26/21 8:37 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.54 release.
> There are 167 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Jul 2021 15:38:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.54-rc1.gz
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
