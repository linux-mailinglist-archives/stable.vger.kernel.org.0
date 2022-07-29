Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC3B2584DCB
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 11:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235431AbiG2JGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 05:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235547AbiG2JGE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 05:06:04 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D09184EE1;
        Fri, 29 Jul 2022 02:06:03 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id b26so5242148wrc.2;
        Fri, 29 Jul 2022 02:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=aoZulIv3y36JRZIiQsGvDhyRsXj2GJggkkB5mXQFhe8=;
        b=QoRLfjAHO6sKauqQzX4lw5ZbE7Y7BXHOewDqAIwlu5yYl26PtUP/NLemRAHi92RAO0
         Oy24HCq/rZ1a8ZIHzsBSBT6efHc+ip362E1NWf81a3+VfmLMLZJWMBY+jl/S4r60r8pR
         JtsaGmuqxVmLKfGmclgdxivdwUZtPu9JHPqkr2nTxfhLn9wIoVo93UwWrgeC3ZtrivhI
         V6ikdSKKzucBC9yMTOHad0Vhoff73dl1uSkP6Otb99LYWRM9/Bd37tQoJ3dnk9/NkdEH
         IRZlugnpt/A9ea3lR3bmDOlNRC6YggOs8PnofXPnOv+STYVbuWNWIyfBzyz2zv5NGX8+
         WoBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=aoZulIv3y36JRZIiQsGvDhyRsXj2GJggkkB5mXQFhe8=;
        b=vnM57saCvSuIfVnm7lq/rsKl5s2P9CUHCK0lz0snk6qs/hvo9f/X6jNWtjHP/R2VP/
         GG+k5LYT66AuUoBNAzwunLzpHnyGX714yDLPZdWIPr+h1g+2uPHe8/OrSsssof8p1ET1
         0/2hCyQ6N0Kl3o5OAECVHB0KZIn2obK5eHJgPuBEOlXt6Obe3hvey8/BU7fx0C5ChNiR
         xQr1L2oqm61POGf/fjkEGQ+GRYxq+eNihSgsLhbR/HyzWOXmg+U73hLOOaDpn+ZZI+3F
         BSGfP3tPD/4ia5hQYJxRpXhhplRslogg5y9qbJGe+yZCCQWMe218iqU0N+xlE3YT/Cow
         ZLOQ==
X-Gm-Message-State: ACgBeo0zOO1PIPqoxEh5g5iG9KRoauIsbQ16RJB1asLuGM5D0JsxA3m6
        4+YHkJoNdW+m0NCCfe1+C0+Vl6Ik4P8TaQ==
X-Google-Smtp-Source: AA6agR7hYytTH2onaLqWvkQZ7NjcLI16AUUpKqMsUJSJq0W3JSLa/aw8cJ2NpQ2GJm3inAswNS9oFw==
X-Received: by 2002:adf:f108:0:b0:21e:8132:a3d3 with SMTP id r8-20020adff108000000b0021e8132a3d3mr1793420wro.337.1659085561716;
        Fri, 29 Jul 2022 02:06:01 -0700 (PDT)
Received: from debian ([2402:3a80:1968:2207:9bad:2dcb:1b0c:a3b7])
        by smtp.gmail.com with ESMTPSA id p4-20020a7bcc84000000b003a325bd8517sm4176078wma.5.2022.07.29.02.05.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 02:06:01 -0700 (PDT)
Date:   Fri, 29 Jul 2022 10:05:45 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/101] 5.10.134-rc2 review
Message-ID: <YuOi6UdE5lsCcUwR@debian>
References: <20220728150340.045826831@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728150340.045826831@linuxfoundation.org>
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

On Thu, Jul 28, 2022 at 05:05:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.134 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 30 Jul 2022 15:03:14 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220724):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/1584
[2]. https://openqa.qa.codethink.co.uk/tests/1587


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
