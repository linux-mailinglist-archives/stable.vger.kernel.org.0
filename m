Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8CF44D5D44
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 09:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiCKI21 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 03:28:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiCKI20 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 03:28:26 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6674E1B8FE9;
        Fri, 11 Mar 2022 00:27:24 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id kx6-20020a17090b228600b001bf859159bfso10490260pjb.1;
        Fri, 11 Mar 2022 00:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=kvy2ZkmTrtHQAJp/Vr2hGyo4bE3FY4ZyOIyzrNj926I=;
        b=OWeOtD3VYstJ2XehgBLTyUp9dDLuoLrDpzx+7bN0qiMvWEqXNSNtdfWmPP1IykMefq
         ECiFby4tO1qmx+UyU3WKV2P3cB0Y9h0fmE+i5ZoPOUy82n6pq/FDAWseFILMRfa4KX6T
         tj61LYpkxzmXlgOXF5E87NHZkpWKWSinIT4GqFTCX1RaKAi9E3rccUC+nGHIq8BnjCLi
         uPb1Ltmb1IjUdFaDVLQ9TcXdrAalP2Ox2GzA476++xHUb1eMezd81QgbmHHuUqzxPNyF
         oKRO0QklwDf9FSkOiMGYKFXz+j6N/mdlLGjEMeCU5oayO0IgojvSV4s11UdIZ+uQ4UOm
         32Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kvy2ZkmTrtHQAJp/Vr2hGyo4bE3FY4ZyOIyzrNj926I=;
        b=trmzwzuMXzOmsxsnVsq5H/MfnwQCroNXF4H+bILVgYnBs/dwDLCSDXzjCMRJo6Txwt
         P3003qUn2xKUivwketqwr63ABwTWyxvSQ6dg3dsTgRLL3pRlujsAt63vbvPbn7cVbsDp
         /syijHhpuWc0il+rkovrRdPavX91kIWJSAQ7QdTUL73p/Qm1SY92qX4XjlgvP9I80Ik2
         vI2aNJUo/k/R/3iZdYMjclABadsul8I9z3QzZQDGuIt3rqZwdfk7I5dE4+V39iIxB99w
         XPe5hpK2AEV3iT0HZUzw/h5HY7/l1gkfQFayHzeUH6jm9N4shF7UCyiB5rIdCYCe8H6X
         V9kA==
X-Gm-Message-State: AOAM533F6kgfdVOl05SjxIIkaxkCDaLL075FG7F2bpWjS/GHeuBj/7lL
        9w2XuZrzwlOK1rYjPqYNcOY=
X-Google-Smtp-Source: ABdhPJws478NcESgDbJbIBZA53nsuBacLMdmt6WeekWzy7EjQptOKR27IeFh/s7JwR66d7TAT9Amfg==
X-Received: by 2002:a17:90a:c252:b0:1bc:52a8:cac8 with SMTP id d18-20020a17090ac25200b001bc52a8cac8mr20352841pjx.61.1646987243955;
        Fri, 11 Mar 2022 00:27:23 -0800 (PST)
Received: from [192.168.43.80] (subs02-180-214-232-15.three.co.id. [180.214.232.15])
        by smtp.gmail.com with ESMTPSA id m17-20020a639411000000b0038011819be9sm7799132pge.41.2022.03.11.00.27.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Mar 2022 00:27:23 -0800 (PST)
Message-ID: <25c2365f-feb0-d614-2c63-8874eace733f@gmail.com>
Date:   Fri, 11 Mar 2022 15:27:16 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.15 00/58] 5.15.28-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220310140812.983088611@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220310140812.983088611@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/03/22 21.18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.28 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0)
and powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
