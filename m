Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEB85ABE93
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 12:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbiICKr6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Sep 2022 06:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiICKr5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Sep 2022 06:47:57 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC7A694EE3;
        Sat,  3 Sep 2022 03:47:56 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id bz13so1790019wrb.2;
        Sat, 03 Sep 2022 03:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=VFSZ2rBYb+KjxEeMGLXPm/i3JuUmN3UHMiZjHzMKqcA=;
        b=EitfbJWYQ4pqbHvWARQ9sm9Bytw9iCffC0MXi5qLi4mLWgQk9yLxsINMhLl/tM6COn
         iZ28njIxnfS0NMa8g5ygX7dgnizj7Pzez85imGyAPjpxmWLNcj0LzEkET9kBHog7otMs
         tv3dZGc18aVJeH21RSzRcL/e9BBgvy1OO4yJYMiFruNRONHGNbMZWQL0J+1CASjY2aIp
         Q2P2uj5lnxviYhSvUnjPFY6mCIHNVvZCUAqZy70N9TAr8+jpyldgOw6g//XFhRSkJ9qb
         JU0K7om8JKiOP8hIC9dczqRVSBnL80D3Ijgc+28DdVkvPkpmUva36cKmv5VZSxD0JhOT
         /pNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=VFSZ2rBYb+KjxEeMGLXPm/i3JuUmN3UHMiZjHzMKqcA=;
        b=SWSTiVABphkM618JBNOjwjh9K1P7jmRhDKWS4RiCpTe4X3eaOOnv6xviNrBkBGbDPk
         EjDmdtW+N6MkeYcJPbsdcnUwLr7JI7mB8NQzI+mOozSlQ9k3niHGHJxWFS4SFCxh9l0a
         BCPzaxb5Lez2FT39KSc/RBc2bSke8Yrm9ZPgIvSwIdef18IDOPYd5O8l0UmH32Sr8ac6
         a2JjJu8GmjimOPXxfXFQ8PJ0clS2X/y6WCO510ZgUnsD5XygWMxHc5P/SBja9m9got12
         HzUht0Z4SoyAT7db1IM+A60IXoVfeQLoc1DMuSqjY1J1aQIRZI0IuvjQPp/MhsY8yZ6D
         FKew==
X-Gm-Message-State: ACgBeo0QBQeRldlGTH/Sx16SKQa2LIzlKiC2w5CiEudQovHqRuj8z5X6
        XtbpxXNbiKuitt1KlDR+cyw=
X-Google-Smtp-Source: AA6agR6ULIaCYLT3ivzX5QQI1awRSMA5ZDFRRDl3auydFue+EgytWCk49yGXyufr022liA98UmbJsw==
X-Received: by 2002:adf:dec9:0:b0:226:e033:c048 with SMTP id i9-20020adfdec9000000b00226e033c048mr14342636wrn.577.1662202074960;
        Sat, 03 Sep 2022 03:47:54 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id d5-20020adfa345000000b00228610d8efcsm862352wrb.35.2022.09.03.03.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Sep 2022 03:47:54 -0700 (PDT)
Date:   Sat, 3 Sep 2022 11:47:52 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/73] 5.15.65-rc1 review
Message-ID: <YxMw2C/Jl7SxNH5+@debian>
References: <20220902121404.435662285@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
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

On Fri, Sep 02, 2022 at 02:18:24PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.65 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220819):
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

Note:
x86_64 allmodconfig failed with gcc-12 with the error:

drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c: In function 'ipc_protocol_dl_td_process':
drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c:406:13: error: the comparison will always evaluate as 'true' for the address of 'cb' will never be NULL [-Werror=address]
  406 |         if (!IPC_CB(skb)) {
      |             ^
In file included from drivers/net/wwan/iosm/iosm_ipc_imem.h:9,
                 from drivers/net/wwan/iosm/iosm_ipc_protocol.h:9,
                 from drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c:6:
./include/linux/skbuff.h:794:33: note: 'cb' declared here
  794 |         char                    cb[48] __aligned(8);

It will need dbbc7d04c549 ("net: wwan: iosm: remove pointless null check").


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/1757
[2]. https://openqa.qa.codethink.co.uk/tests/1760
[3]. https://openqa.qa.codethink.co.uk/tests/1762

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
