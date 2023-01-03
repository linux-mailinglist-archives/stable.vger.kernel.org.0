Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7EB65C6D4
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 19:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbjACS7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 13:59:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238760AbjACS72 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 13:59:28 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7685F11473;
        Tue,  3 Jan 2023 10:59:28 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id jl4so27332142plb.8;
        Tue, 03 Jan 2023 10:59:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Jx76/1qwXkqVtZ8WWT7wUJXezQVggNO/8OW6AUwyjMA=;
        b=BxQMADJFAau6seEuwJ0tNqYrllJiRiRxCcYxkJHKE4QLFxmyvgp70j+Nwj8+7SIKQW
         RoeutIKxN539xK64Dsba4z9O/kv1OSYzJ/nQ4Rpk/k+J92ri8NBjcs4GxeW4Gbm9ftJy
         CHBT+SZYdVluwCJ1TKETaOtBE8FPVqvcTbn+HJ+Rl6LoIuyzeEE7AufGkOqj7EBHsEC5
         ylEPyiUuvYlGl+Tf20I/3DvGWivoHFrFLoTli7W1zSAtzjpJQLTW/SE/wjucnxuT8yRw
         L7zBC2Y+6+QklqO+MQ6JT0P5Q5vWVYK4OwCoDABydsu1lSZZ33er/6sCez33vxB59jlY
         NoJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jx76/1qwXkqVtZ8WWT7wUJXezQVggNO/8OW6AUwyjMA=;
        b=IfUoC65VoEIKSrUk4CmmrYlmKI/qbJLj54F6qU/5OG/gVaaTZDZZhfRhrj4DhdBYX9
         NyNnnGKyHzLvzZepHpNKSy1a6T/rIo+vCk3WnSDq6m5U9Ju5YV+CMgXePBUc5lS2pQAR
         sgm0+tJ6BvCS2V8UsUE0HDHVkl3lbuIhmM96EopQZc4n3AWmtgm77IbqtoSjUf5IMopX
         f7vNp+TI1j/YYjhCFmNPL+g5mZ5fdv6ANJSaIJiNCbSlyjag+Y3b5L2ALix40ssa4TGe
         S0gafSNf3voLsbbeDg0zfYp/v4qHneUux683FgLGhQinZ60Wylv7CDzdXU1ovSRQ/sgf
         Nxrw==
X-Gm-Message-State: AFqh2ko7J48iSrqDX1bb66yA6L7Mu4SXn/6Oilczvv47mGumhVA6hLeE
        dlmGaIUZKLMhaT7mPyWuOPiXVu1wp/3S+q+K6yc=
X-Google-Smtp-Source: AMrXdXvu/j0jmA7+ISM9cNRq7iszIsefcF15r6xRSMLq70F8LTW/DsCyEPgQuOn4WtfbnIAGepMvNjKhlZngso3VREM=
X-Received: by 2002:a17:903:22cc:b0:189:e81a:1520 with SMTP id
 y12-20020a17090322cc00b00189e81a1520mr2865801plg.48.1672772367982; Tue, 03
 Jan 2023 10:59:27 -0800 (PST)
MIME-Version: 1.0
References: <20230103081308.548338576@linuxfoundation.org>
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Tue, 3 Jan 2023 10:59:17 -0800
Message-ID: <CAJq+SaAQWarJebJBmRv8Kwa6hkqg7rKBKyLZphcXo096PO8mKg@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/63] 5.10.162-rc1 review
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

> This is the start of the stable review cycle for the 5.10.162 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 05 Jan 2023 08:12:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.162-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
