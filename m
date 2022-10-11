Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33A1B5FB9EB
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 19:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiJKRw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 13:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJKRwY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 13:52:24 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F23DEA3;
        Tue, 11 Oct 2022 10:52:22 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id 10so13986432pli.0;
        Tue, 11 Oct 2022 10:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=R48OeXZvREqyrXFZCw2bLXmeDWzvQgbf0zkDfFVgRa4=;
        b=DGGB3olI3Vtino4yAPk/8iMu5UIsbi0qRdeResJvhjNigOcM3LSU9FmKpjG2IsOBVt
         U+FVrxn8PCXuextjxg5WvesOSjxns08z/kk4pTQj06XL4mC3dq7hcUl0KLAIlkQBSgM2
         wK5MSgZdadebSZ2zPxkiE9ANAkqAORzUP/LlneUCV+3PuqoVaudhXTgPoBF42eQ1jead
         aqVQVrpHVD+fD2WWILKWGaI3dzYrzAvrc+SZmeuyyo4AVR1rxOcrIU9nOkNGiuhRdz82
         OQ+7xBoYVXwHLxC4gPKVVDA98MLwwyolP2SCQ7mHrg7A5VI9PW7vHXH5SrVYD/5SNs30
         BUSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R48OeXZvREqyrXFZCw2bLXmeDWzvQgbf0zkDfFVgRa4=;
        b=yTTyMOmG9nlKLTIJwUQCeFwsCIrxxi0YMwcqYxlHJ7leCVZZc07ssFgaRiKDuUQHsl
         vIvIO/Q4A6vPSfe+mDMHurkBiQlHjbe6c1TdCTxOUco0cgsjZ8jHW//+ZPLEiLUgrndv
         hLTYOI41m13wz+CgKU633Z7EZdc1+D68pBEUXVy5+zz5r7bvDoxYimrVJAux4KrcXqTh
         5p74fPeX3NG2MbLXEn8yN2jMRTzAqQKqoV7CzASagBgGYmI5G+X/2dtM84Ux3nV6CCVi
         8rkyTtsYG/9SNCJlCU2XzH/CA9RnSpibIll37/Zq9ZQ/iBisB3q4WVkg+oVtQYF7ce4M
         QzRw==
X-Gm-Message-State: ACrzQf2oSWtgCq26QRxmEaTvRMTz6y5PB+gu0/GRr2Lw+vVmUp5UEoRw
        3OjLQx2ZIV8OsT0i3js7MuAscMDaeukif6SwMGI=
X-Google-Smtp-Source: AMsMyM6HDFV4MZuxefuWVNV2r7OhU99Lj88ZicMHXMjyIKS4yBGdWae5R3jko9XOT5i/uyrpxT2uZFbScrfTQ+H/JZg=
X-Received: by 2002:a17:902:6a87:b0:181:c6c6:1d38 with SMTP id
 n7-20020a1709026a8700b00181c6c61d38mr14778379plk.74.1665510742025; Tue, 11
 Oct 2022 10:52:22 -0700 (PDT)
MIME-Version: 1.0
References: <20221010191226.167997210@linuxfoundation.org>
In-Reply-To: <20221010191226.167997210@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Tue, 11 Oct 2022 10:52:11 -0700
Message-ID: <CAJq+SaA3b+CfnzCohKNeQC4ua02vMjxNzFmmtAtSOMHyMcv-WA@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/35] 5.15.73-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
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

> This is the start of the stable review cycle for the 5.15.73 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 Oct 2022 19:12:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.73-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

5.15.73-rc2 compiled and booted on my x86_64 and arm64 test system. No
errors or regressions.

Tested-by: Allen Pais  <apais@microsoft.com>
