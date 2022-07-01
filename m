Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D34256317D
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 12:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236215AbiGAKe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 06:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236241AbiGAKe4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 06:34:56 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FE270E4E;
        Fri,  1 Jul 2022 03:34:52 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id cl1so2583727wrb.4;
        Fri, 01 Jul 2022 03:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UV84BF5cBxzD9zx/TkNLuFqo3S029h6omQw2ybz7xL0=;
        b=hrmcvAujQcgMmtFFtuUOC5QyzI7RFmwh9xGDOtbj9Hqx3uFV854Z8S+7MqBL/GCFy7
         k4ddXrGe9bzZKz58MEw7I72rFjC15U+vvGUZmVNyWv83RA+EMzCyhtiqhYy43omaurvh
         YwKfgieyfKojnjbzAuXkfkDp7kyefJEPUdV4ijf//ghhD/Iu3T1e/81ffJ4oaMzIggVO
         ejcZ6yybYfRKAmv9CfHJQizyJJAwt+6qagtvEGrC+eJtt9t8mCMhtiwtPlfy+eSbRbyo
         R1XY75QZXfktqscQiz17GRA0cuGyKIkcEodvM2KSnishrFqgaZd1lPb+L1RkKAUkgThH
         urVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UV84BF5cBxzD9zx/TkNLuFqo3S029h6omQw2ybz7xL0=;
        b=YcyM8OfrEzKChYvV7U0u5k8hLGUcZvBc/lXM5neHClW6Y/zQI187gBYKQnVQDmNNfi
         DAzuimLlCQWMAAJ9XTQZ0k2UhqRo/Aq4wYDy6EiA0iIhB/oVLWwPM8EboFQ6qzlt+wiY
         MAiuC9VydksNJG8ZpPuOXBP4Tl5L/gvinn9KT38gbo6ORgBfnzHy+FJIb6+MwYW4tjKk
         xFnfGg+K7CME2Z83vwjFDyRjoeaz1PmjW1KXZGi7TBq0N27jJQ7P4LPv3cwKVfnoPyHg
         j767NOJlvhUCBP6NHiJmDpi2Q6xim4O8woSL57STqJrYfJQRTdwS/y3wBFejfklgDT+q
         Xe8A==
X-Gm-Message-State: AJIora93vevaBauEk5tyrEABpaZI6FVlhFXqxM46Zl9FgI9x8f1cmCne
        a51tuliq2ykX7lup6LNwGo+UiSNZieU=
X-Google-Smtp-Source: AGRyM1uvwp/m0djVdzmRpWXiYsWmf9D3si4CiC7nlqzHlJLkNwO2aDhY0TEeRpRAW/OWTksPSEv7gg==
X-Received: by 2002:a5d:598c:0:b0:21d:26b6:ee94 with SMTP id n12-20020a5d598c000000b0021d26b6ee94mr12890512wri.457.1656671691525;
        Fri, 01 Jul 2022 03:34:51 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id v4-20020a7bcb44000000b0039746638d6esm9580991wmj.33.2022.07.01.03.34.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 03:34:51 -0700 (PDT)
Date:   Fri, 1 Jul 2022 11:34:49 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/12] 5.10.128-rc1 review
Message-ID: <Yr7NyXIs9KpzMZK9@debian>
References: <20220630133230.676254336@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630133230.676254336@linuxfoundation.org>
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

On Thu, Jun 30, 2022 at 03:47:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.128 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220627):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1429
[2]. https://openqa.qa.codethink.co.uk/tests/1436


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
