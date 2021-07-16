Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 183AE3CB7E2
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 15:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237892AbhGPNg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 09:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239904AbhGPNg0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Jul 2021 09:36:26 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A902C06175F;
        Fri, 16 Jul 2021 06:33:31 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id h24-20020a9d64180000b029036edcf8f9a6so9879708otl.3;
        Fri, 16 Jul 2021 06:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J8zZyCyzqQ3uGMERkdBrsKlmNQvpnHyyK4MC4H/8Gs0=;
        b=szOqrPYWTtGxAz3qMYwJfT8jxLNorrIF1OyeLWF+guxoNYtIffKOZfyNlnSxoDxeos
         4kzbEIksSStV/JHdLtigogeK+o07bE1yhwf07IlirRLfWuma6YvXkpSYP0LL2A0xax2w
         55u9ZAL4Zwt7VuqNWwE8CV7GZiR2U5nu1uxTGNjBfRVAJu+/8h7v+ZUquk7t/Yr/1+Nw
         o4Q2uYGJJMi5EIayOSsyh7vU6vdzoBeYCSQeBqjPd88BZDal46TiuOCWxorBPtrK0/hd
         lsVVeKQMV22rWaVxWHI/bxxLpdIj1iQIH2Bc7xsSt+WlqBWpbBsGNzSrgMqxZKiolTVa
         ar2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J8zZyCyzqQ3uGMERkdBrsKlmNQvpnHyyK4MC4H/8Gs0=;
        b=SYqeIsGSsJa4Ct+HUN8SkB3SBMbRJF1MP78v9pyS5uxkGe/CsyUax91m4I/UIQwGq2
         MtPWgRMBEnO97xvtVYn9E9XrFcLqFn8vOnaEs7DjFpPQLD9WK8I5zoc/m9LXaOb1F3p7
         uqYy4ugDPn2qW0sTRHCqpeXpJTsyy2upxAysM65ufse+AQ6ptSQW/sBa7ikMy63G2DCI
         uX0vrCcammF48Dv9ip4fSPBTjVTXq85XOD1ZJRh1Uiz1bbsnBlFTMrXckETykU4CEu8u
         CNjXJEmp6ufqWr9XQ5jkOQjqKLrpdWAPIg1tVC4QD9BlVM/LNfv4+VcJdR6du2eZ1ur3
         9S2A==
X-Gm-Message-State: AOAM530nXbL6U+7ULWOVvV7guGNFbKhuO9od5TrDwpVgbLTieL5pbip8
        CLbVOS/ZHhpaCmkC+PqO7RKE8y6sP54=
X-Google-Smtp-Source: ABdhPJzKBqJehrxIeL0AH//yLbx/rhisEl//AMmq2eKqQCVcAO0Eevy3/h8BYIpeLMklbwM2KrRiVA==
X-Received: by 2002:a05:6830:2783:: with SMTP id x3mr2678021otu.37.1626442410034;
        Fri, 16 Jul 2021 06:33:30 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t16sm868115otm.63.2021.07.16.06.33.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jul 2021 06:33:29 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH 5.10 000/215] 5.10.51-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20210715182558.381078833@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <53f95a72-996a-ace3-9d34-60f23f4813b3@roeck-us.net>
Date:   Fri, 16 Jul 2021 06:33:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/15/21 11:36 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.51 release.
> There are 215 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Jul 2021 18:21:07 +0000.
> Anything received after that time might be too late.
> 


Building ia64:defconfig ... failed
--------------
Error log:
<stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
mm/page_alloc.c:6270:20: error: conflicting types for 'memmap_init'; have 'void(void)'
  6270 | void __init __weak memmap_init(void)
       |                    ^~~~~~~~~~~
In file included from include/linux/pgtable.h:6,
                  from include/linux/mm.h:33,
                  from mm/page_alloc.c:19:
arch/ia64/include/asm/pgtable.h:523:17: note: previous declaration of 'memmap_init' with type 'void(long unsigned int,  int,  long unsigned int,  long unsigned int)'
   523 |     extern void memmap_init (unsigned long size, int nid, unsigned long zone,
       |                 ^~~~~~~~~~~

I'll send a complete summary later, after builds are complete.

Guenter
