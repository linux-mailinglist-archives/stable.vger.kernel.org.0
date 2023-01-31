Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36735682BC5
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 12:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjAaLro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 06:47:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbjAaLrn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 06:47:43 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19BB59EC2;
        Tue, 31 Jan 2023 03:47:38 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id c10-20020a05600c0a4a00b003db0636ff84so10405004wmq.0;
        Tue, 31 Jan 2023 03:47:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MTasx+tlHSopiV3GgQaWxu+fMhhwtK7KYGbCTFrTiwE=;
        b=Zk07LbMH+ffyrTNolAHT85QHTSNPLto6Mk/P1NaUS3M7rJTPTxduKP9/zAElTmwb5K
         P9/H7V8nS/R5Ent6b7fHWfAFIg0iet22oYXj2a+WcBVMinePSDKUcW7hyGo8JNSHogYX
         MfwOshywVefrWIROSPXzsthA5RYHqa70x+XqOfJEtqBO0L3VGSpJ5fUJBRR3DuVHU28Z
         WzUGVfOYZ2lnReBUTB//cDWDeBpcyRTYisD+2YyYw7kJ/MqlmXbv0GiR57P81NViMwjm
         knT10d8y2nmDJGmnaVZpdDwRZnYzOc9dHZU2JNy5WQF7hlAIknQ1umzndYK6twm5tkO8
         mdGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MTasx+tlHSopiV3GgQaWxu+fMhhwtK7KYGbCTFrTiwE=;
        b=gcLg4J8jtC+6r9zBL0a0g6x1CRW+9meDzjbGcf3YAAqOzjRIOEYP/Rkqq+1HDInlPy
         A/5M06eudg4OWJCvuTck0VLlKs4+YSyISat9cPj1GguWainH1jT+eUNW3l1dPMaQ6N0e
         pnXQYyy5uaCwT/s6YtEG8paOGnj1jdoQcFjpefRs1SFb9/2pKppPRImqmEU5II1vmxPd
         Z94ZZU8MP4hK+kEz+8T3IqGTDul2X7XcNyNGEqmPQRmgCKsufi0QiOyMzJhuNfLjRSzk
         vTOomg3HoIC4IjWgMczDLcGe2xmHNFbKkpq8J66SrqV2MT9ggtftbihTZWAIJ5Mix0Wr
         ACFQ==
X-Gm-Message-State: AO0yUKXfZLuf1CCZ5OcXE9rb0dmsOSDZb5bYxW2tkWsRkNscOlCE0GGq
        xvsUgOX75N3LPvmOXK5zl/Q=
X-Google-Smtp-Source: AK7set9VtwxuHBLBgumjxHbl8Vwl7nDPKcUiYwUfzxWl/SUMAenoyZH4a2HvuTskZF5GiegUlkXCgQ==
X-Received: by 2002:a05:600c:35d6:b0:3dc:443e:3a8b with SMTP id r22-20020a05600c35d600b003dc443e3a8bmr13228816wmq.16.1675165656509;
        Tue, 31 Jan 2023 03:47:36 -0800 (PST)
Received: from debian ([2a10:d582:3bb:0:63f8:f640:f53e:dd47])
        by smtp.gmail.com with ESMTPSA id o16-20020a05600c379000b003dc49e0132asm10220566wmr.1.2023.01.31.03.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 03:47:36 -0800 (PST)
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
X-Google-Original-From: Sudip Mukherjee <sudip@debian>
Date:   Tue, 31 Jan 2023 11:47:34 +0000
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/204] 5.15.91-rc1 review
Message-ID: <Y9j/1k4gm4B03WPV@debian>
References: <20230130134316.327556078@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
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

On Mon, Jan 30, 2023 at 02:49:25PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.91 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Feb 2023 13:42:39 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230113):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2768
[2]. https://openqa.qa.codethink.co.uk/tests/2771
[3]. https://openqa.qa.codethink.co.uk/tests/2775

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
