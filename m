Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 370375FEDDB
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 14:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbiJNMMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 08:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiJNMMS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 08:12:18 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ADF21BF224;
        Fri, 14 Oct 2022 05:12:17 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id bk15so7220132wrb.13;
        Fri, 14 Oct 2022 05:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AO4bDhLZiQktrbRs5YLc9ITdrN4vuj28utA0a40IlZ0=;
        b=pNTvam1XVQeHBKC+AVp9PnN37NG+s6tp/c5ByE57luMrSjvvaYrS8tZVM6vYIfqhR1
         0/9Ij31q6SziDSDlBnPjlBSOuZjskiVZQNPoZinVIxwTLv8ZfyoZ6RQ6hEgYi3OWXiuq
         ORQmD+QCPp0ddxxu1IaBC3i/iTBiEuB2LXRHH3ocquqH0maDEZNmgbA64qEFvb59WuUJ
         58MKIcvY5eD1/8iVyMCSr5z+m4fG1WWJ3YrqIY5B1O438TS6whdqxAVI6PNHZh2yjD09
         gQ9AZutKy3sGbhzNXP1Cazb5icNYmUObVgwMp7Ol4O59gr2pokscS6xW3XMS2clbKjEU
         PGWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AO4bDhLZiQktrbRs5YLc9ITdrN4vuj28utA0a40IlZ0=;
        b=F8pJz2nxUlibDcBdoQBPzbOGWAhXW9ak1hieeJpLGK7TZUmFbwP/9hQDKBLgfe+8zJ
         d/P4fH/kWA4SQOWv9Yr76igUVSEawRV6hRHmZ5J1gluIScNbt8R05JFDLV7HNuY9qsa4
         BPvuQz01R54G/L6yq5WGtfJdfBVWiqHMmZHE9uC6hatB2OvkI64/RrDMjFw4MPjO2oQM
         AnExsQTH0bZpho0mIEylWeRqUN2DnONhNlRE+OgC1pemcWjikuE/szk7AIEC4IZHoFxT
         hXbvy9mITCpFQ6VdPSw/Gywnf2aMBJ/MnkOxhe17KZbBR2eIkQukxtlIRBwBHc1zqBoU
         l/SA==
X-Gm-Message-State: ACrzQf3yCuWik5UW9HFvS/PM6LdCGzqJFq26Gmm7sOxMD8izrRK0QjUi
        1Kh0Nm1SGPVX+n3Kh1j3pVJKT/166lA=
X-Google-Smtp-Source: AMsMyM7n0va8LzEXzGZ6Uf1iSR3wSBoihIPHBaTJeLuvEXD7G4oet51W0R5F97E5d33Eq/FKRA7B/w==
X-Received: by 2002:a05:6000:61b:b0:231:1b8:172 with SMTP id bn27-20020a056000061b00b0023101b80172mr3269680wrb.372.1665749535939;
        Fri, 14 Oct 2022 05:12:15 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id az25-20020a05600c601900b003b497138093sm1995801wmb.47.2022.10.14.05.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 05:12:15 -0700 (PDT)
Date:   Fri, 14 Oct 2022 13:12:14 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.19 00/33] 5.19.16-rc1 review
Message-ID: <Y0lSHr5kY5VenCfk@debian>
References: <20221013175145.236739253@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013175145.236739253@linuxfoundation.org>
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

On Thu, Oct 13, 2022 at 07:52:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.16 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
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

[1]. https://openqa.qa.codethink.co.uk/tests/1990
[2]. https://openqa.qa.codethink.co.uk/tests/1996
[3]. https://openqa.qa.codethink.co.uk/tests/1999

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
