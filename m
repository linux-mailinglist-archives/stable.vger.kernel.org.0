Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65D095FBC1E
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 22:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbiJKUe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 16:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiJKUew (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 16:34:52 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4EF9109E;
        Tue, 11 Oct 2022 13:34:47 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id r8-20020a1c4408000000b003c47d5fd475so23752wma.3;
        Tue, 11 Oct 2022 13:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zl/16QzCDZ2AvWLAr2ndKVW5E8FpF3v/4r/m2ySzBUE=;
        b=iVPn46k/4QNAi5RZHu/CEULaiQvR2SzE1ScFFShNxlG/MVLgpSFRXUbSkpdfHTWGUV
         M4V0e2mppLuDtp41sehVXwP//USjtcWNGZemT35q4CqIL17H3yHYrF47xiiU7nmNtdo4
         vRmrkcOSuyvy9+lx8V0sXRh1ErqAmQBS2+MjDsrym49zPYKL1OuhFIELvfAd+JvCDIQX
         J6m1Jou67jmI1/TcfpXVCtfvtLTixJQzOWadLFXFJvyZuN537J1uqld0zj6QmlNTYtn4
         xzMH+cZ1kefsZRLZiMzAO8/oGHpoKefj9G5fMxeQeln+4r1SLAbue4BiDpFQtXAd+7up
         +0qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zl/16QzCDZ2AvWLAr2ndKVW5E8FpF3v/4r/m2ySzBUE=;
        b=qD7DDGI1FEuk2ZyOwLNN1ii6vYqEYfGD+f05JaOXJ9omnGfnZSwIhtP3PXQ/jds/Ca
         qqIW+dZL9Hco760TUEL3Hdckmc2RQO0jVtUJ/6herCd7R0zqhqHL54A6UXh3vuhEV5iJ
         KCGZF0I6c/Z4AEji7CfqdOKANPyVOvzLE5vwIhZkf1s6aHJiG1YChssU1YTmolXA2/Nn
         icl248S1PPS/ajE+jYs4WEXf3EnbQSeWptJ6JmD9EbMVc7U1wwIKtNoGJLO+7k2gGi2P
         s4CwkX1UqXz3uD+wsISudxva/ADFPKIjC9aKdRGwCJPMS0wFbfoFjakhBN8gC7r8dABP
         DJ0g==
X-Gm-Message-State: ACrzQf0ft81UZ9phfnbNHkXHiU7ml46M36DBwYySarofej/rdsN/8zTP
        kh7PsAIn0nv2pGuRLojEGtnQqcU4m/Y=
X-Google-Smtp-Source: AMsMyM6DP5g0P32q+XoeK1zd2WumXsrAMbDUp3eiZO0EKSEwng1PhiMOSjBktBJPjVV8CXx4sFLsMg==
X-Received: by 2002:a7b:cb93:0:b0:3c5:81c5:9dc8 with SMTP id m19-20020a7bcb93000000b003c581c59dc8mr583507wmi.196.1665520486416;
        Tue, 11 Oct 2022 13:34:46 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id q18-20020a05600c2e5200b003c65c9a36dfsm6493942wmf.48.2022.10.11.13.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 13:34:46 -0700 (PDT)
Date:   Tue, 11 Oct 2022 21:34:44 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.19 00/46] 5.19.15-rc2 review
Message-ID: <Y0XTZGAa8VbOCXXo@debian>
References: <20221010191212.200768859@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221010191212.200768859@linuxfoundation.org>
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

On Mon, Oct 10, 2022 at 09:12:45PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.15 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Oct 2022 19:12:02 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20220925):
mips: 59 configs -> no failure
arm: 99 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/1972
[2]. https://openqa.qa.codethink.co.uk/tests/1976
[3]. https://openqa.qa.codethink.co.uk/tests/1980

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
