Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96DD64B7350
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241134AbiBOP4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:56:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241067AbiBOP41 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:56:27 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C306FA6452;
        Tue, 15 Feb 2022 07:56:16 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id p9so12351056wra.12;
        Tue, 15 Feb 2022 07:56:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=L8pD5pTeZRDlCwsrtjOaMUOCMqHiT6qC1hC1m5nk1Nw=;
        b=ggddP0PPikdQWCi0iGr+20aK6yQ6gvPybEbWMhCG9D8nbvd0GX9hpItLzKrU6F8Thw
         H9nLWnxPIBS7sr6kwBlhq0FGC1vexgJ/WsnD20DN8IUagXRl8TUQx4gaIBhAumi4jBHo
         O7wIMptdVJLtZZJBC70WnQKWV+0hcKnWg+6cjdWkrzG2Oo5q4dHH2X/EWVHVTzv4Z5vk
         s/Er5qyoKN/Dc2KkYqFazDyS/zZEp4aQElcs+V/fgTb9q4pgOmRFcNlD5xzlcZqVA03r
         vG7vQ1pRK5g94dVdkEwWoEqV/kxmntgF2bJww1WTYJBoLvsajSFY05EaFZ/gjdjmGMac
         8Deg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L8pD5pTeZRDlCwsrtjOaMUOCMqHiT6qC1hC1m5nk1Nw=;
        b=Z4eL6aLFCfRBcH3fDiNscaJF2/x15/POJni0pTwsvep+ZmSpnfC+3tx8ytsIk9kG5r
         tFs8NzxXx4O4M5Ain6c59VBHcY8MEybtWfEvlTsONI6e3Z3ToVT5B8h78mCHTxUq77uM
         c0UzKVw4/LSqgLq0xQByfy98mQ1pfbiXVuyeKLybB+Q1WMipXmtVGTY1K97m1/iTmXlq
         1QfCu4cc8LhVxelyJmTPjJSYiAV/G8RGQF6WYi9LXAQHiVBuRzcWiz6J1vTZ1UIIBl48
         TmoMdoZXHWM5AgGNi7d47VlPLp7IDl6VS1Q4Mhm7KQE2321I0q6jCeJta5zFTz2RFVZC
         4CbA==
X-Gm-Message-State: AOAM531gfZMwm355W9UDObfEwnkd+2yriWToX0ln7zwk4FuTTGiEsAdz
        oLQQ4k7ufeBNVStM8TaSNq0=
X-Google-Smtp-Source: ABdhPJyaTXX/oYARKTiObf9aX6tUeT9wQGHNWODjX+ABwp6AdVfMoKGLK3kd5yQqmVdNF4rCcsKlWQ==
X-Received: by 2002:adf:e109:: with SMTP id t9mr3872501wrz.73.1644940575420;
        Tue, 15 Feb 2022 07:56:15 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id t16sm6793301wmq.43.2022.02.15.07.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 07:56:15 -0800 (PST)
Date:   Tue, 15 Feb 2022 15:56:13 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/172] 5.15.24-rc1 review
Message-ID: <YgvNHRKKl2fI1LQc@debian>
References: <20220214092506.354292783@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Feb 14, 2022 at 10:24:18AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.24 release.
> There are 172 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220213): 62 configs -> no new failure
arm (gcc version 11.2.1 20220213): 100 configs -> no new failure
arm64 (gcc version 11.2.1 20220213): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220213): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/764
[2]. https://openqa.qa.codethink.co.uk/tests/766
[3]. https://openqa.qa.codethink.co.uk/tests/767

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

