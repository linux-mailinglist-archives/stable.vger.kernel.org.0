Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E08664E927
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 11:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbiLPKIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 05:08:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbiLPKIv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 05:08:51 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8233718361;
        Fri, 16 Dec 2022 02:08:50 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id w23so1798060ply.12;
        Fri, 16 Dec 2022 02:08:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vuVGiZvFz8J7abJwlLLv4bBfBMgFKLRkZEO1QR9SecQ=;
        b=D2vDQxAcbQp3xe34yuQkUv51/1m26VAWmUrIpz0GBE0LvEV60sF/U/ymfQ7bYu/7Nd
         JlpTpjkX2rwQ+xi2d/zzz2i837cLnqWdgW3fa8r7GkboAYZMl48iUMtMkzO7Q4iohRYD
         +weFT6w+wp1GegAKZ4gwIr2PqvUq8fh6kPDmdKZ1pxuf/dqQwguEQzkbEES8uQ7j630a
         OKz4EmIfrho5C4XQR/5nJpri7Dx4T0KnFaqHTDLmnqWQJ7X/jwQ9zgfXED3qCUoK5Gu4
         rcE3UEJuec3Rl29loR+auMiPQWSsZBNJB7mk/fx/R8dMq3iT1WMkULRl/LO5+CFaVPRc
         fBOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vuVGiZvFz8J7abJwlLLv4bBfBMgFKLRkZEO1QR9SecQ=;
        b=uCoYZx8JG2ojpGCd3xXpKhpF1hbZECLdVDpv3nOWHpQ1trHNUz/lmEtid8aqywHRa6
         NEQwhgUjp5uxiU7AWwOOgJfoRAyMWHJHt20TCc6dO7TcuBQv/id+QkMKzfO4gysRjrKd
         iWOUJfe+AoDm8MNbRjSPVhKruDyhVc9DBbHffCZcYxWG8FZj6Ka/QF2zFa/8n3HJNWTr
         4WInI6S5P1HuYzapCCh4aRTvDRLc876pi0M/NLHlSpbblhvqe4igxIljUumt/Fv9GEfL
         Jm+XMzcBAC60Mtp0zxo/D5xYtox9X4v9ofGjVZZjU8yPGCbIe1niqVfjcdVHFg4tZUlK
         wC2g==
X-Gm-Message-State: ANoB5pntQGnQn4SV0PIxkHlJm5K+GsRtQyBHLWdnc2Ae4Lc/4412zpZW
        purI1uQ4lOHL8aqBYV+G2OOQntOnGzgmtpDuSmU=
X-Google-Smtp-Source: AA0mqf6jKiW+QBza+9Dt6MNcGE/GIsaSNlmIGk6P9pw3Wz0D1/qkaj6+PJGiPnFa/qrlrZKiUkGcl33DyS984ewAth4=
X-Received: by 2002:a17:902:cf03:b0:186:5d7e:7ca8 with SMTP id
 i3-20020a170902cf0300b001865d7e7ca8mr79778092plg.74.1671185330002; Fri, 16
 Dec 2022 02:08:50 -0800 (PST)
MIME-Version: 1.0
References: <20221215172908.162858817@linuxfoundation.org>
In-Reply-To: <20221215172908.162858817@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Fri, 16 Dec 2022 02:08:39 -0800
Message-ID: <CAJq+SaCAg4xk=WSc8KXakTnMjqNdh=0gbLbURgiq9yR7Oj+i2g@mail.gmail.com>
Subject: Re: [PATCH 6.0 00/16] 6.0.14-rc1 review
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

> This is the start of the stable review cycle for the 6.0.14 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.14-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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
