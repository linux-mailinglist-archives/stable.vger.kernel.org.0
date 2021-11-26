Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19C6945F4BE
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 19:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239014AbhKZSj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 13:39:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238027AbhKZShz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 13:37:55 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C36C06175E;
        Fri, 26 Nov 2021 10:11:34 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id w33-20020a17090a6ba400b001a722a06212so8379562pjj.0;
        Fri, 26 Nov 2021 10:11:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=vJxL61/isUIklsbGfuI2DlV8JdwN6TK/RwNC9sAhGIU=;
        b=NpODqnkLvTEJ/L1f34SBgrJCBT/sybowYiZuUMX1PLs6NVzq2SqbZrREvhvUqhbFxq
         ToBD5llJO82sxjmd/M5BFoGYHVTbag0BqtQpDRdgiDBl53UyBPqC+RkRkytu6ASYu1aV
         prNmsNYZArLdr5NbUE+aQljML+vMfjE9aNNoNv+fNZNoylSIsluPBDyj5NLHJxi06+MC
         ra4PoBHW2zYVFMz4kypR8QXxpSSt/lr+IRi37ZWIIaxN8bbT/yhwhvLRTWprYPVkIUFv
         PlaSLaTXfOLUo6dwWAnkSTRqcSaHBdQMBenuaS3tNgCLl/n1i+rjL6qkG71MVf3HKbQf
         zkpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=vJxL61/isUIklsbGfuI2DlV8JdwN6TK/RwNC9sAhGIU=;
        b=aFBJO2WPmdU5BMKtmAiwg5ShEZmKT8AVx4icrO3F7p0Q1Rg/LJMKEGkK5u/09Glboe
         ZjZ21EQxOn/oInssroTqxrFI7DH27t0eVkKCxcuEmGDVaOrg5HvLJES/orHDXR0uqBG9
         U4kEziCOR8OBFCzNagyVdHyO3lt+tHRfh98OpAvlEAGsgYAhrjbCCse5cJgTPqoFgo61
         rMTWZLFDn0k8sKjDpFJo4Ggsg75Y3tTFj78DoI32got9GNxHpYClsaEiUe0NR8RZT6LG
         WyNqg8pz9EIlYsZVlFthlaW433IV2muwXsAluqXhfZuc4bVFXYLeamwSoEQiQiiyyTan
         jYaA==
X-Gm-Message-State: AOAM531LB3iOLHhD+ChshHx1x8A+gMYwpUQ75WuIK5Xxj5gI057iDw9i
        +6rZ6s9NQXYaY4mpryfWlF4=
X-Google-Smtp-Source: ABdhPJyxUM+GLnjRMoMmpLlyT0bxX6sefnSXlAQXA58SpflFtsvXwyro2GrxJ4E7riNuAHzPehHwwQ==
X-Received: by 2002:a17:90a:7004:: with SMTP id f4mr16958621pjk.156.1637950293600;
        Fri, 26 Nov 2021 10:11:33 -0800 (PST)
Received: from [10.230.1.174] ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id d13sm7926944pfu.196.2021.11.26.10.11.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 10:11:33 -0800 (PST)
Message-ID: <52374902-f1e7-5055-a26e-be269d10ce15@gmail.com>
Date:   Fri, 26 Nov 2021 10:11:31 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.4 000/100] 5.4.162-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211125092028.153766171@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20211125092028.153766171@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/25/2021 1:23 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.162 release.
> There are 100 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Nov 2021 09:20:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.162-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

