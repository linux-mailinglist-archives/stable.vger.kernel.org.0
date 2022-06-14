Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA5C54AE33
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 12:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353186AbiFNKWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 06:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241060AbiFNKWC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 06:22:02 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9B74739E;
        Tue, 14 Jun 2022 03:22:01 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id h23so16186992ejj.12;
        Tue, 14 Jun 2022 03:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=q0443Dndpen/b5Yhv4UENxJ30OUrUnM0Ufs9FbCtRME=;
        b=l2iOhfYEFerogxSBJEOr3y3bYqaALIYTxIPvczOoNKYset9y3JUXHUOdC/IiXAJpb9
         t1dqYKzwiYh+K8X0SDEBzrYJUSEpTpnpTM+A43GxDJoncrTihWD/P61Iw1BO30vA/Ato
         ZSNyeMrLFKF1tds795cURed4gOl6N4Tg/KS+dmhPQpp/kf81NbBRneHopa2Xg4Fg88Re
         LT4WVQBB1l/kuGMDxmt6M2MY3MmWHy9UIu63LvtPY6P8Wccellg+XcU6OUjocce4+kHR
         ALdviDvPdq2FyR5stqJoTTZituNX3BzWoGEWYOL61xz4VngI+o94MbWiJjb9BQfWQGDy
         0PZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q0443Dndpen/b5Yhv4UENxJ30OUrUnM0Ufs9FbCtRME=;
        b=mOxQVH1G/T/1ssJBTFHRZgmppMFXcmxLzm+eyKOe/FTXg4e1J2wsJsSjuHlFR8yR+t
         kdN+rwyosF7304AGAgq23anHY8wF+FNi0dGjIt3Ei/W/D/5gFtzypOwJaFEBNTNf9DN9
         RI7ir6xiyRRhtUzo4TsXYZV/3DUamPD+twrEhGStWvFIKxEfblAMmMUG0RZ6UfTzmUDs
         m1xIYXBmKVU+LVbMmrXbhSiOokOhchLGoyDnQkRaCrkdGSB0NXXpcYwTVEAhXkZuCgTJ
         dwdVSu9ca5bUreFSMYZJJT7dvmu3etrOlH9FPQ1fpOxvJUV1i/vxk6zgntRQgRnWoPnp
         pxqg==
X-Gm-Message-State: AOAM531sHVR/CZCdDBD3MUddQaE38jZ3pdefz7jCyOfxuT9nXdw0Bgjz
        Cu6CKM0/c1O3kMzAcj/MHXk=
X-Google-Smtp-Source: AGRyM1vQbLQJlmeisYMYUtV1YQfCfUhOGgFN/7RBT28vN1Gwig57+sy5wGm2Bc8wmKs1vDLJAjkAng==
X-Received: by 2002:a17:907:9606:b0:70a:e140:6329 with SMTP id gb6-20020a170907960600b0070ae1406329mr3585125ejc.471.1655202119941;
        Tue, 14 Jun 2022 03:21:59 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id v2-20020a170906858200b006fe921fcb2dsm4849610ejx.49.2022.06.14.03.21.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 03:21:59 -0700 (PDT)
Date:   Tue, 14 Jun 2022 11:21:57 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/251] 5.15.47-rc2 review
Message-ID: <YqhhRW4NW7R35Hq5@debian>
References: <20220613181847.216528857@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220613181847.216528857@linuxfoundation.org>
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

On Mon, Jun 13, 2022 at 08:19:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.47 release.
> There are 251 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Jun 2022 18:18:03 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220612):
mips: 62 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/1320
[2]. https://openqa.qa.codethink.co.uk/tests/1324
[3]. https://openqa.qa.codethink.co.uk/tests/1326

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

