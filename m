Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3896C4E3D84
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 12:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234128AbiCVLZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 07:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234146AbiCVLZV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 07:25:21 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E6524F30;
        Tue, 22 Mar 2022 04:23:54 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id s8so17841872pfk.12;
        Tue, 22 Mar 2022 04:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Get97nmJWj6t/BClc197v83rCyrHxMbhNdPluKzodY8=;
        b=eYcmMiuzIrj/0NRF/DLMxlt3XBWRgQnDmCgxYSZcHMky+u75BbPTPqZ3ccYKcRqlgJ
         AyeDjM7Id5Gwwqp3596MFkkntCLfGzb4Kuh14ym2bscMN5fg6WSdFPMhH0qMi3Y2Mj5Q
         wsY2yZEJPO5+F9wbDvZcBwvCeUPf3HBbdjpbr6wbsFSV9/7IT/U0BRE/+7+BatRoyUB5
         9rB+z5Vpaqr5AcJMjkZah4yx+KsC9De9/S8jP/JKVvjxOzP1JkgYVRppZVBIwhwHlIe4
         2ZuYlH80EZZc8Z4vriegE6ALGKmCGLevHa/ua/JuBebSTes3sMc0EKcHbE/EUhM+l5io
         NGEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Get97nmJWj6t/BClc197v83rCyrHxMbhNdPluKzodY8=;
        b=GlIl3HBnxoSwuO+VExVG4sgChFx/+KFoFoZvg0V5ddAza64VgGJxvM2hHzLknToWWl
         x896aSqmbIoXXBC8nE9UNk6k50ZAYKDc+9DzrtkTR+h13hXxRdBFkG0uxR1GWJOhdjjE
         TMqWCsxpK6lcjtLSK2tkXdOL0wbZmZRP3/7wYJH0yRfgZLnjQkPdB4Olc7tcqhI7fcjH
         F3XZGo2tA4SG6YbUlr9nclxml8f8Yb/s8qAUGEzeL35m8OGuGrAXLbWoQqzbCtTjDt38
         LRlfpAF66MTQ0uZ8M6Us6x4wAaXiKtd6xdaf4RPGTUT0ZQ2udsphW/y8HQraQGTjjkK0
         huUA==
X-Gm-Message-State: AOAM532veFuIdP50XAGrzvkNcEvY8k0ECPYqglqv2PRhM/yMldMLHrOD
        RaUm7nKFx/CzjOwJR/NN6Zc=
X-Google-Smtp-Source: ABdhPJyIpADUcrHJQelYR6EKjyiA/G9wxqkoRn+anhtph+uz4A9N64GN5U2l3Dntk41mmM3Dt4R/PQ==
X-Received: by 2002:a05:6a00:1516:b0:4f6:fad6:f0a7 with SMTP id q22-20020a056a00151600b004f6fad6f0a7mr29344565pfu.21.1647948233709;
        Tue, 22 Mar 2022 04:23:53 -0700 (PDT)
Received: from [192.168.43.80] (subs32-116-206-28-14.three.co.id. [116.206.28.14])
        by smtp.gmail.com with ESMTPSA id z23-20020aa79597000000b004fa3634907csm20211926pfj.72.2022.03.22.04.23.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 04:23:53 -0700 (PDT)
Message-ID: <c029d653-9805-bb3f-1bf5-2559f19d8c19@gmail.com>
Date:   Tue, 22 Mar 2022 18:23:47 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.16 00/37] 5.16.17-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220321133221.290173884@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220321133221.290173884@linuxfoundation.org>
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

On 21/03/22 20.52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.17 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0)
and powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
