Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA9CA5A032A
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 23:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239870AbiHXVOQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 17:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236881AbiHXVOP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 17:14:15 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA98B7B7B9;
        Wed, 24 Aug 2022 14:14:14 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id c187-20020a1c35c4000000b003a30d88fe8eso1608380wma.2;
        Wed, 24 Aug 2022 14:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=n6h5dnlYAN6xjqaZV/JfvIewvF3SlfpjiiXVkEnl52o=;
        b=BjMFQ2Ul2rCcfCmvFBf11V1TzQyzTLQ1QBA8EyOvmIztGT23qjseCmb6kTV30a2ivq
         VsIuZKgj1gZD4nyDa9mf1PiSM1xaJL1O2TDhVPf/CNX15xJRzpRyTgSCX6ixERm51XEz
         MwWtHKkEnyh5Kzqt//MUqWixzdlingZGi6GSd8z9mXCYYLrQQY9ogd6uWWmVEr/hkzsR
         EEMaANiTc6cjvbvChRjlO7JFVZwhyijExWsIHFhJ8y/k82GGr1pgdcJQISl3RHKtVj/Z
         7aK/zIPkaU66UI86LFO/BBC9rAGWhjdLHp+QNBGmEJJ1sTvU6w87IpX+Kt1Kay6U0zfV
         GUBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=n6h5dnlYAN6xjqaZV/JfvIewvF3SlfpjiiXVkEnl52o=;
        b=SSdajadbemp/GnD8ZyZEOy0c9NskRkN2A17eK5uZ6wUPR9I1A/Xk4RGGY+crcCpmQS
         fthYkAfPqoOTT0m5UUwo7q5H8CAZ9PG+7I78pBIfi0sKl3gOSgvHnLCNpRvPuKtZ9s/E
         g3gLbsX6C+ME3xrv2/VaugTWQjXHzeBzD5MWSSRsxpMwop1Y0IHsvGn/VEMr7mmoQcWj
         np57LYyKljxElzCHCI6Ty+zwX20FwIP5nQpSjGX+pukFdSl+7r5+uK0FAiHWcHMjHisQ
         fRrS1FZR88PJN8c3TRqJak0fIl2j6NGJlq5l5z4NQ/uzprs5RAw25lU3zJNPGVy/O5Sd
         phBA==
X-Gm-Message-State: ACgBeo14alqDx1Lrio6brapDx2ym7DV8q/Yo1OGyJ4bc9Q9lOkKdGssV
        6emgvEj/181Ksvz2FqYs254=
X-Google-Smtp-Source: AA6agR7NXz4kTFaSdmDwIR/XMipDuaPGYj3dcVqLId1lNpYCJVj7taKb+6gAkWSasKagCoz5bWEXIA==
X-Received: by 2002:a05:600c:3551:b0:3a5:dcf3:1001 with SMTP id i17-20020a05600c355100b003a5dcf31001mr6171441wmq.58.1661375653314;
        Wed, 24 Aug 2022 14:14:13 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id l4-20020a05600002a400b002250fcfe2ddsm20562669wry.14.2022.08.24.14.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 14:14:12 -0700 (PDT)
Date:   Wed, 24 Aug 2022 22:14:09 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.19 000/362] 5.19.4-rc2 review
Message-ID: <YwaUoTo4oc+NziAA@debian>
References: <20220824065936.861377531@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220824065936.861377531@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, Aug 24, 2022 at 09:01:14AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.4 release.
> There are 362 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Aug 2022 06:58:34 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20220819):
mips: 59 configs -> 1 failure
arm: 99 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> fails
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Note:
csky and mips allmodconfig fails with gcc-12, passes with gcc-11.
Already reported for mainline.

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
Note: drm warning on rpi4b, already reported for mainline.
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/1697
[2]. https://openqa.qa.codethink.co.uk/tests/1701
[3]. https://openqa.qa.codethink.co.uk/tests/1703

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
