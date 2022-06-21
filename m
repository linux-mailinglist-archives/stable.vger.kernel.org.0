Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 790DF5530F0
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 13:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349548AbiFULgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 07:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240753AbiFULgW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 07:36:22 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E9727B0C
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 04:36:20 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id p69so12275167ybc.5
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 04:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uy109NGVZOqUEqj/HN5Y0t40mZp/IMiopZZkWsBlk7s=;
        b=DciPG/qBcySyL8QdjZ91hqdz8NxGLHRi+rsDligXjJjIqGZLxsljBQweaAIIFQO7+A
         04UeUl94pSTbJXHqsuCoLevwd0LWadQJ9WQwcuyRFx8XRvXm9lpjThaulh3G3SqnTc/l
         whIzWH6Osa8D9pySuIl+skA5iHRKHpTIRBABHRfhnZDqDAcu6/KLKVmBRF8istBSmrr5
         MKsGLddC19ECfObAq5NP/2KthnXjxasSjgUL2W0yuM223knBgbmGDNWVJjavhB2AO3Z0
         0KCG5HZ4tL5Gn5s/7676+CN7KT+nO+9aAMqUuZ4gcL5uI5dXd/k15uv6VY/QG0EeCSj6
         cc1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uy109NGVZOqUEqj/HN5Y0t40mZp/IMiopZZkWsBlk7s=;
        b=2eMMhDKCNaV9rR2chHWvldEtuhNzVgXouEaNNBmndRN2srIIYHAMcSCA03c2cBhK91
         CMJfM3aoJ82S3TrLHQy27P0Gu9Ky1rjAu5frwzSChSV7SSLFOi+oSOmtbvCJa0O0q9lZ
         P4Y1fZzTjBpq5Qyttn+FRLeAj/15sCxcta9kfaqVnEnhkT7xHNpt8XTknCXzuWtE8XsG
         kTWfWaqQ37VVe6oHIK8tF56mpzDPiU5UWFSMKTithO7DNbi9T4iD0W/oo+3V1mVJ0H1g
         UQXv1y3F19Ahdt1QrPDs/L+aG4BA+I4Hwv2vMlhjoOxPWW3qxZwrcAB6VVXd1IK7cBfh
         SftQ==
X-Gm-Message-State: AJIora/C0mVW8VZNqgZ9evs7gD9F6nxR4BYLuwr3IT8561AdVaS8us8U
        UgqxNLYLKnPI3rqgyHgTVrVSma6/T486llXD8ez8fw==
X-Google-Smtp-Source: AGRyM1tcF++iYfbTZttOCVuR7F9KlAl8n2ir52MtJi2F8U5CjNtCVCAsJDxNYGFxGoMEhNyLf7lLtztOVyXOZZrYRNo=
X-Received: by 2002:a25:cb12:0:b0:668:be92:a574 with SMTP id
 b18-20020a25cb12000000b00668be92a574mr21688868ybg.617.1655811379693; Tue, 21
 Jun 2022 04:36:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220620124724.380838401@linuxfoundation.org> <CA+G9fYsvY-0ub_CXbb5is0vRLQ9+SaPS8Op=9mZzCkeccUN+mg@mail.gmail.com>
 <YrGHheX8D0iIz+db@kroah.com> <YrGTT/MLbCuHanhB@zx2c4.com> <YrGe64z7Al+V3bvB@kroah.com>
In-Reply-To: <YrGe64z7Al+V3bvB@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 Jun 2022 17:06:08 +0530
Message-ID: <CA+G9fYs7+kA6pzCZZNBxrwx-2-OFZfV+5Zk4B8a=uE=VUFykFg@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/106] 5.15.49-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 21 Jun 2022 at 16:05, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Jun 21, 2022 at 11:45:51AM +0200, Jason A. Donenfeld wrote:
> > On Tue, Jun 21, 2022 at 10:55:33AM +0200, Greg Kroah-Hartman wrote:
> > > On Tue, Jun 21, 2022 at 02:06:06PM +0530, Naresh Kamboju wrote:
> > > > On Mon, 20 Jun 2022 at 18:36, Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > This is the start of the stable review cycle for the 5.15.49 release.
> > > > > There are 106 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > > >
> > > > > Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
> > > > > Anything received after that time might be too late.
> > > > >
> > > > > The whole patch series can be found in one patch at:
> > > > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.49-rc1.gz
> > > > > or in the git tree and branch at:
> > > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > > > > and the diffstat can be found below.
> > > > >
> > > > > thanks,
> > > > >
> > > > > greg k-h
> > > >
> > > > Following commit causing regression while building allmodconfig for clang-13
> > > > on arm64, riscv and x86_64.
> > > >
> > > > > Linus Torvalds <torvalds@linux-foundation.org>
> > > > >     netfs: gcc-12: temporarily disable '-Wattribute-warning' for now
> > > >
> > > > fs/afs/inode.c:29:32: error: unknown warning group
> > > > '-Wattribute-warning', ignored [-Werror,-Wunknown-warning-option]
> > > > #pragma GCC diagnostic ignored "-Wattribute-warning"
> > > >                                ^
> > > > 1 error generated.
> > > >
> > > > Regressions:
> > > >   - arm64/build/clang-13-allmodconfig - Failed
> > > >   - riscv/build/clang-13-allmodconfig - Failed
> > > >   - x86_64/build/clang-13-allmodconfig - Failed
> > >
> > > Does Linus's tree also show this issue?
> >
> > Linus' tree got rid of the pragma with:
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/fs/afs/inode.c?id=874c8ca1e60b2c564a48f7e7acc40d328d5c8733
>
> That isn't going to work on 5.15.y at all without a lot of hand tweaking :(
>
> > and then a subsequent cleanup:
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/fs/afs/inode.c?id=e81fb4198e27925b151aad1450e0fd607d6733f
>
> That doesn't work on 5.18 either.
>
> I guess I'll go revert the 5.15 patch here for now and let others sort
> it all out when they want to build 5.15 with gcc-12.

Whereas clang-14 builds pass. I am considering this as a waiver.
The problem is with clang-13. you may keep the above patch which is
adding support for gcc-12.

We will stop building with clang-13 and we will upgrade our toolchains to
clang-15 (when released and current clang-nightly builds are in production)
and gcc-12 builds are running in staging. We would like to bump versions soon.

- Naresh
