Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6B0419D86
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236016AbhI0Rxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237231AbhI0RxT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 13:53:19 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC96C061770;
        Mon, 27 Sep 2021 10:49:46 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id g14so16596123pfm.1;
        Mon, 27 Sep 2021 10:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GowznGyJHBfEdnrox6XeXHzKCwLxA57FV9V0/ZJadf4=;
        b=IBK/yAQqXoksGm/mD2MKMI7IxQ+rSI8ipPRl1j8vJzhhTOnczD6l/MWx5PMQTOwkNX
         qcFedtOCnOMTUzJB5o8M4S2jVj/I2VrNzqMtqWDZ2ZrUs9TuhhpimcehvqiIby/y47dc
         oTOlXwZlX8o3dh4uwsjwUG149xFxhfDpjwq10FlONTvm0gbEW0HpL594nvQVuG8of+74
         bV5Nu/X+Mpe/5w7jps4+xkSEVQF6A6TFJnM9eps80/pDMRk9T1oIH8rIUDV4IRHz7Iax
         B8SPJtxE68uaZpvegPXeY/AL2Fw+VTXtNaytM1PGg8Le85kH7FS19r8EGL5NIYJnVNG+
         SKRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GowznGyJHBfEdnrox6XeXHzKCwLxA57FV9V0/ZJadf4=;
        b=HKQuOr1pd5AEoSPkz7xIE8uKFYus7A3HfGkoWqUjTy6lgtVXjUKptU00V9VyInGFsg
         vrY3kgVcmsb1ik9xZK2hBukVB1H3iRUyU40g2tp8tmyAumaNqaJgERjz85YDbANfe5X3
         2v3+1njlH6WyRIntMd5nXY1ILLqP1TrFcaayMwhEJf6/12Qa0ljK1J2Gffg2Q1RMPibE
         kvwbweqbKn7bQuSG1hUEz3ZbOldU1Val4K/+dLomyR7alVclR3c+pKmZYQJZGtzdViwE
         Vxtq4/NLioLXKrSUHrsGnvqZMePAvjKVR19HE0PSO+/CUECByocgvAEQHBf15t/8cra7
         kfug==
X-Gm-Message-State: AOAM532qmbc/VeRw+xX+WB2kLREhQLbpwOYQ7i0dfhO+hdiSt4SkFRPL
        CPi7jywX1g8sJuUbLa0BMKWVRd9Ua6A=
X-Google-Smtp-Source: ABdhPJzM1oC3zlz9ypXtLwwso8UW898VgojHbyo3QiNGp8gNQRQLvO5944MkRD+y8IiaVS/k1FK0YQ==
X-Received: by 2002:aa7:8f2b:0:b0:43e:393:e855 with SMTP id y11-20020aa78f2b000000b0043e0393e855mr943043pfr.18.1632764985766;
        Mon, 27 Sep 2021 10:49:45 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c16sm17354597pfo.163.2021.09.27.10.49.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 10:49:45 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/68] 5.4.150-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210927170219.901812470@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5af6dd41-d00e-98fb-1a40-d42c1a7d77a8@gmail.com>
Date:   Mon, 27 Sep 2021 10:49:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210927170219.901812470@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/27/21 10:01 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.150 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Sep 2021 17:02:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.150-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
