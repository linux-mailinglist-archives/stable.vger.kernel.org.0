Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267293CAED4
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 00:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbhGOWCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 18:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbhGOWCx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 18:02:53 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4F4C06175F;
        Thu, 15 Jul 2021 14:59:59 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id jx7-20020a17090b46c7b02901757deaf2c8so5245516pjb.0;
        Thu, 15 Jul 2021 14:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LgRikEli+/avgIwH+NnboKsPZ+6R8HRC38xPaFWuCr8=;
        b=kZh3vAl+f0WgVsJMzR3pTx+dCgm5ZY0V7NIvxKOo/9+zAFrZcWDKt/YKDLZk2L9aHH
         pCiWTIazb6gHurbAMF6fSru/NgMUcXH6BK917dDzZo6kzw1/C9z5+VHUK9kzOvZxiYSc
         I08vnMj3cOjvYKwPCLhbWOsdSbPMSGBFXLLPeCvUxSUV7xnH6EFmjcQLiIzXf0g5/FVL
         PvKMSwLRFtibMtBLb23jY6v6D7srwOkN2DplfomTa00AKLOZaBoZNN9UnBS2wjuWJPS/
         ANZwqMEhNb90TMsM4F7qjwku1EMusD9LUDXPm9lgQWlM+S2Zj9sWFt20hiSD1diR3mET
         L5NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LgRikEli+/avgIwH+NnboKsPZ+6R8HRC38xPaFWuCr8=;
        b=YDU5MiAcTZeGxxueHxvjbxJ8zeN64r8cal20Yx4x9Hp18FazSPVWih5ku0FESd1Nxx
         Trvq6HepBl5LexG8NfIfrJHMbEpmcf9tjPZiYXAjA+V8FYz7B7Kc7dzmsI9sUfshg9uc
         38aUll52CEPVbBqC1OkaoWi79Pw9IfgRqBL9U0njxKkE4H0HIAEAgXescizlZ11ijw/z
         DCrjQsVueBSgI3yPpZBdVsHmvJuCBCuVeZ9l5vl+9zakrpmk5/uhh6LDZ3ScoKuLEsul
         PWZGm01bnEW0kzWwTqNfePQMPK2/0BKHNLO0UaLxYkCVVm+83aoGtNROc6xFNZTvuwoR
         LI2Q==
X-Gm-Message-State: AOAM531V5oxRhaeGm6r8GGV9/7gVTScbqgd/icRfLPGvUYVmomwr1+W5
        pYLcULio6/OdQNz2BoR8A724/cp+6s+dGA==
X-Google-Smtp-Source: ABdhPJw3Ur/laHKM7WbDvH73mC0otoELe44/BziYWh8+aatVmT6XIxwugf3d2DQnNM38Cv7kH/jBWA==
X-Received: by 2002:a17:90a:74c5:: with SMTP id p5mr6184164pjl.117.1626386398106;
        Thu, 15 Jul 2021 14:59:58 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f5sm7647886pfn.134.2021.07.15.14.59.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jul 2021 14:59:57 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/122] 5.4.133-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210715182448.393443551@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8dbe6ac8-a655-22ad-8af4-2323c3ea9379@gmail.com>
Date:   Thu, 15 Jul 2021 14:59:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210715182448.393443551@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/15/21 11:37 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.133 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Jul 2021 18:21:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.133-rc1.gz
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
