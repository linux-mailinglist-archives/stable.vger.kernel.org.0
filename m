Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 298AA695396
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 23:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjBMWG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 17:06:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbjBMWG6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 17:06:58 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0119E1F901;
        Mon, 13 Feb 2023 14:06:57 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id h4so7213929pll.9;
        Mon, 13 Feb 2023 14:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kvpUXbdttADA6sdXNiBxDIAzea4kHoWcT4D+ic16X5M=;
        b=d+RrvJ6R/yq+GgNUC3a+QDgCiO33flLciJVg8SGuJd1Suylg/hB9Z2A2U28awXyEeb
         RQwlH1Gmepic6kUOy/mVPgh9cZacno9SjQjrFP4JrYRQjAkuTGVyNI+EBunbJO+HdSP+
         eZnL7iPgM4/38igRTw3jK5B+NjPP1GUTXNa0SQ2wlq5qUR/e8y762/QcpCeoOcIuuS+Q
         2ICKz/1o7mgD4WaGT0naGAqo50mck1VrvYW+71/8W7gGekFL84nLcxjP/VkctrZZhWuy
         if6N2u0xjRTYhHiYTZ27+uQx/2LwPJPUbWs5yWy2q479BYDTs24S+IZOTfdgplD+Fwfv
         8bBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kvpUXbdttADA6sdXNiBxDIAzea4kHoWcT4D+ic16X5M=;
        b=G8APwjC1fSD5+i5au2czc2Lqi49luuKPd3eQph9vujbL3BTj7pc6K8AV4xFOIO1RFE
         hK+Gj1ZUBP5qmb6o+3xJ0s4VkgZZ5wEAw/PEBW8KVNuonszF5KIlo4uWMwgzcZY7RhdK
         xJ6fPUh1AnhLkrV2bZBWBSLW793WV2/kTdrUw+Pl4f35cy4shitdUNx5puleost1F7nH
         5Bwa+jp0dF8WLmmCNfynl4FBQqQywMtRSMM3uhzL5RkXJYpoa086bBgvcw818mRwG8pC
         JMtqNSifSb4VHhDjtn6rAXzIIKfppIhOVIwIETzjAlW1UpIl0/YU0Esiin19Vh78QiaF
         FABw==
X-Gm-Message-State: AO0yUKWDAzzJRfLIpDxtSnHfvYfbi/LhaFMaOdwNgklCyZhM2vWvNmby
        WViXOIfkQ3L51bPtleQGnp5iN0hwNfmicjxhRFe5y6Aq3bA=
X-Google-Smtp-Source: AK7set8HL2L34StpQU+/q4nxQXJiYu0X2grhVoj/aXiQ020gBeNUnWEgOGYvGVt27l6N9y+X6998Gykfi3p5ajiJHag=
X-Received: by 2002:a17:90a:a418:b0:233:f958:1e38 with SMTP id
 y24-20020a17090aa41800b00233f9581e38mr1156172pjp.44.1676326017553; Mon, 13
 Feb 2023 14:06:57 -0800 (PST)
MIME-Version: 1.0
References: <20230213144742.219399167@linuxfoundation.org>
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Mon, 13 Feb 2023 14:06:46 -0800
Message-ID: <CAJq+SaAnGWbUCJr8_eeOod+YS62v4QVfBmMCbMaWEHw27krtdQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/114] 6.1.12-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> This is the start of the stable review cycle for the 6.1.12 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.12-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
