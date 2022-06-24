Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7EB559808
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 12:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiFXKmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 06:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiFXKmF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 06:42:05 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259AC7C85B;
        Fri, 24 Jun 2022 03:42:04 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id r20so2598752wra.1;
        Fri, 24 Jun 2022 03:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UajsaCs7iVQ9eUEm1xzalhGESy62aCqF8z0v/6nHuOs=;
        b=Cu/dTt9sIDG3li9iLvsu1inUPjDaXkS5ztcCpx7kLrJmcQhJZ2J4hgdY3HjOemYp5W
         JwvxRSPnsXqdjv9xNktDWxdxPUdnZTyxLiwEP5oOFdBZqcYP6ADdAqBiTqaId7nrPix2
         Yw0lt8frjhyir8j2jOnrVpD6+Yt2tKKB/tqxK/u13No0YA6vww69UIMVSPyf0OftvEqG
         HKBCSaS+FGQd0e3pZ5GVA97R9GPnJJX8Izx7U3+zKIJlIhDcKFuPETv4wv8gRY7I7/d5
         w3IB6JNeWiqQ9Rr1vp+BluGw8y3Hl7B4pkH3tH6WKNyWxB1DC0vxSrpR7b2FO2OISyaw
         P5wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UajsaCs7iVQ9eUEm1xzalhGESy62aCqF8z0v/6nHuOs=;
        b=XouVsOBjCvKcwNBkCzwvCkJALwD8kpPUkQGNpvu6IMzzSp6vqfjr9BnLlaqkAAm31x
         6f3GURHRtl7cuJC7SyBEhWH7PGU1yGyZUWWwb1Y7vyVgDTrXL6VUZsBncSkn6kmWSVro
         1EHB96iWTx+4eLq6Mn4agKqRwB4WlN/VAv3zhohQq+V34s/QpqSm0LeEHNIhd+lXczRJ
         LHviEAZx4fFJJMNZUplXIEO+V9x1GHijovaGO3yiQF8VS0xPKHi+3sOQNp8w8E759pwd
         58e4xu94LYCX/QfELieQFWzGHHHTOI8KMOKJsp/2m01dPeOZCCUrZgawggUKk4u/hxIR
         h/YQ==
X-Gm-Message-State: AJIora+c6FBVVTof2DZ52TZQ9L6wNfrp3pHVJj6T22D+6lYMvPYh/fHW
        ZMCByN1CswoGtwV/P90+ONI=
X-Google-Smtp-Source: AGRyM1tf1rDSbdDFg1fIY0Qongow8sR9COLgzKhsbZpUUXuHBZJQUkop3k0HIZIBzNu6pAhthxbJig==
X-Received: by 2002:a5d:5145:0:b0:21b:940d:45d1 with SMTP id u5-20020a5d5145000000b0021b940d45d1mr12346207wrt.308.1656067322587;
        Fri, 24 Jun 2022 03:42:02 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id o42-20020a05600c512a00b0039c5cecf206sm2609295wms.4.2022.06.24.03.42.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 03:42:02 -0700 (PDT)
Date:   Fri, 24 Jun 2022 11:42:00 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 0/9] 5.15.50-rc1 review
Message-ID: <YrWU+KY7eNHwmgV7@debian>
References: <20220623164322.288837280@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623164322.288837280@linuxfoundation.org>
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

On Thu, Jun 23, 2022 at 06:44:43PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.50 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220621):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1381
[2]. https://openqa.qa.codethink.co.uk/tests/1386
[3]. https://openqa.qa.codethink.co.uk/tests/1389

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

