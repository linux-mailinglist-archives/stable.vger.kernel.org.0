Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7955C573BD5
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 19:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbiGMRP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 13:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiGMRP0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 13:15:26 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB7F2BB1F;
        Wed, 13 Jul 2022 10:15:25 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id 185so11339153vse.6;
        Wed, 13 Jul 2022 10:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FNhWWVuVJ8AgLU34I59QylRUnNfYnm28cwECwrsC7kk=;
        b=bOi9XDyKvc7me8eleJ9IUJZuABmfK/z6GZRMKLAPpKX6w5q8Kbo1zev1g/Gday0Yi1
         eKQAVDwxSCnEO43apQQ5rTqLl0eqV8om8jyTuFR94GxmjPi2F9atsn3M6TJHyKvtRxmp
         rFRYyKR5zHU844fnkrZ7UqMRr+dH+5mP2z8mxWBwHW3dg5FviEDII59byo6Xii/0kl26
         qvdkbtv1RYlvb1Jh0HGflG9AYerjMrZFBEliHftUoaMlatJaXVHIsnd79GuI2Kc3rX6Z
         j8jlnFHFXjJFr3pJlsi0bOATQS+Xbgxtgr52fAOp0+N5aYMKBCgYkpjRkeYPUyC7401L
         E0hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FNhWWVuVJ8AgLU34I59QylRUnNfYnm28cwECwrsC7kk=;
        b=ja9dPMTRZ5mVan7aewS3JBhSndcOyaXZayXEBGTok1t4DpG7o2nUSTI7jiiNU2xUgf
         QBcZl44Ew0uuy8ienIZW5mYNy+N+cLAwq/OvkRbmUSyPLrDmmAYRZgPP6M17p4JyCdch
         7yJaMfKPOCD4PcfNIHlbpVrgvCEd28MjmNkEcet0STHAXrlRLHKsTOvJE60axuQQk1WU
         pia2BNy4eRzWzZONsDxsVX5K5OzLCJbvT5k7srJr1KTEQJ9GQ0TG7qOLRnDxwnbr7WzB
         PHm1JxZHDN9kBI1VV/6kDn/rUDHXzl8mPv4TIOzEtXpwwHQ1t1+KvWK1GG7YdRNFoRSL
         0Xwg==
X-Gm-Message-State: AJIora97YMaCD4sDvAsPOM1g73V+lSeIKGxZqoN9460se7s+rZbqc9T9
        mxWig678Fy1e/TG3RggktD/LUA1PYQ7Dqzt88ic=
X-Google-Smtp-Source: AGRyM1u/seuYA2B7iAhAWjtIi4U7nsJzuoj4k9nY8IfNCS5f9L4mt03GqyiBiB+ZhsK/ZsuLQMMEbMcC2gaMqZcFAuE=
X-Received: by 2002:a67:e311:0:b0:357:58a3:6878 with SMTP id
 j17-20020a67e311000000b0035758a36878mr1991841vsf.2.1657732524580; Wed, 13 Jul
 2022 10:15:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220712071513.420542604@linuxfoundation.org>
In-Reply-To: <20220712071513.420542604@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Wed, 13 Jul 2022 10:15:14 -0700
Message-ID: <CAJq+SaAHdBsi9CawLnxi6ftXc7g48_J3h4VL_U1sz7Hnncz5KQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/226] 5.15.54-rc3 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Guenter Roeck <linux@roeck-us.net>, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> This is the start of the stable review cycle for the 5.15.54 release.
> There are 226 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 14 Jul 2022 07:13:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.54-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
> Pseudo-Shortlog of commits:
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 5.15.54-rc3
>
> Hangbin Liu <liuhangbin@gmail.com>
>     selftests/net: fix section name when using xdp_dummy.o
>

Compiled and booted on x86 and arm64 machines.. No dmesg regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>
