Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23274610EF6
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 12:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbiJ1KtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 06:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbiJ1KtX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 06:49:23 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E011CEC35;
        Fri, 28 Oct 2022 03:49:21 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id t4so2993935wmj.5;
        Fri, 28 Oct 2022 03:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RwtKvIgsWQUddFyHA+7csn8T24MsDcLDATdxH1tSNJ8=;
        b=qEtykyq7ZvlO93mFb2Ywy/JBkySHuWNDYocv706zVgePaaOa/XLO5TkBMmSNDRJyXu
         hLwAGZxfH9s28CufzHSxGiRXnABebBTWkg4ByhYf+lqWoYbVSxNa1m0LL+suHYle47Rd
         7hOE/mLHwhwIWMSqXZyrcX0IQy3kod6QXmAUGbwY7qsHIUy4hhdfWlBFbHfz36O/TKTz
         zVer0OJl8rrhGR4hMjUHNgPewBLRZ5z4O5w821xK1oN8luNl19C6K2jZkxUnGxxsKFYC
         hvQTuAvOUAwYq8e0uU9FaDYXVIUUO2BaoMD5itzzgzlOf9VlAjDl9NavHqhD2z+/4QvE
         7Ofg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RwtKvIgsWQUddFyHA+7csn8T24MsDcLDATdxH1tSNJ8=;
        b=gZcVqGdBBwTtFVRO5hOsgCAPCeRMJneRNts+lMM8rxA9IBggKQ/T9Uwr/zYPdHKBii
         jFWfz+E69OCUjc7wKig2pTHLEpIwflN7Pt4SO8gkLIJFBBVD/opQYol8XwVrLuNGZVCa
         mEfSWep+mMn4TEnNrxtTG2B6fC7hwHmk0lEPQpRutR6JnTlaRobYSFO9R/YRQWBRkw6w
         GIwJhJ1Yx/ATwRstLoMSHSIWqcFfZeTR6azm09uyFSYLqHzfg7uuId8gwfwMm6tMPwFP
         5Qgg3FwAlb+antjkfZCniaFZ92ymcCigoPE74cCZ4od9zoeIBmiljpxGAlFr+uGhpo4j
         dOdw==
X-Gm-Message-State: ACrzQf1C5owqTFtPkc6JKONZZSFQp0fmVCrsHID/XpmWmVCvbrux8ESS
        TT5j7jZp08MQNsVPrL/EpHM=
X-Google-Smtp-Source: AMsMyM7jSlHdfzuiC68SehMUaVUkbXBv4TZCGrKBMpKl8QxJy4rJUWpA2XnSoh6mso4cH/fgDyQTng==
X-Received: by 2002:a05:600c:35cf:b0:3c6:e957:b403 with SMTP id r15-20020a05600c35cf00b003c6e957b403mr9488581wmq.162.1666954160237;
        Fri, 28 Oct 2022 03:49:20 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id m5-20020adffe45000000b002238ea5750csm4024602wrs.72.2022.10.28.03.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 03:49:19 -0700 (PDT)
Date:   Fri, 28 Oct 2022 11:49:18 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.4 00/53] 5.4.221-rc1 review
Message-ID: <Y1uzrvWMM/lZBlBS@debian>
References: <20221027165049.817124510@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027165049.817124510@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Oct 27, 2022 at 06:55:48PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.221 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221016):
mips: 65 configs -> no failure
arm: 106 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/2046


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
