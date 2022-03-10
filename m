Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 118444D43A6
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 10:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240878AbiCJJm5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 04:42:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240895AbiCJJm4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 04:42:56 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626591390FE;
        Thu, 10 Mar 2022 01:41:55 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id f38so9776621ybi.3;
        Thu, 10 Mar 2022 01:41:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tT6nf67TbLSBp2rbhJr13jOgaIDBEc469MROckwe8vc=;
        b=iS9lbCbfo2u2JazBPIIK3Y8/jaXlveAmOaC3uF755dM/grgc/4GfKLvxD1OsTa3SJD
         eURsvCGkTpyyMkyJa2slJQK9EJYoXKPOMgXt5ckSIJPK1ML5Inbb9fT/2UVUqXCJQkhY
         GkneITmnX/lKTPKV1+UO6B7+jZBd0KHOWkCGtFdlhOXCgVM9L9Pdod7CURwTb0HRrrtc
         LBLHo6j843q1Po6rQqmwGRg7SN2yoFFgYeAljKPSUtPR5EPkRiPgi2Typ96ic/MNk2r0
         kU+hP0ch15P1fvH7nv+VuN/ligEFJYDnNX0g5rrhJ4GqLPDSO+UOdOIs5xysq7sFUuIm
         4AhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tT6nf67TbLSBp2rbhJr13jOgaIDBEc469MROckwe8vc=;
        b=jj4Qb4AYKyS0lXfhmkTDdOgn/TNfKVJ//DsnOn1Z7rkT5mSUvxTIA90XdWwX/Lf/kV
         /4rgJsU+iEcWJXcHZ6wzlDGTaAqm9NL+BPdji60roHeKx5hbxXX/yuVzBcI1hwGVCKxL
         yXk1w/iMgS1IU+Ml+W3d329O5Jr1AbA8gB74BmVHwv97uPtKayuQmnU4EORcEso7Bhhs
         a+DAKHfdyqpsHRBbyV2kG9kMIDClV99Nq62ZcAvq/FE8GLqtuyifwlPyszXuQFpVnpkR
         C4R7l6U1icvX7I20pvEoime7trJdU0xPAwJ5aWLXayjRx1npcP9jDFeLy3pFWXm6Y1g8
         lQIw==
X-Gm-Message-State: AOAM531jwkxfHKup8YKWtVbAy1mjUbm7uMOCCRNJgjLL1JtArJ0DrafM
        dYCZ2ZyNIZpjHBDub4ynymb5tYyTzsHZf8H5lyU=
X-Google-Smtp-Source: ABdhPJxNOYS1Pm40lqZ2WnHaLpHailEM7oJLtLx6G5madRVza8MpeWKi/LSD1FOjRXBua1V919WpBMTwtsXKey9CdGA=
X-Received: by 2002:a25:fc26:0:b0:628:689c:df81 with SMTP id
 v38-20020a25fc26000000b00628689cdf81mr2954201ybd.183.1646905314585; Thu, 10
 Mar 2022 01:41:54 -0800 (PST)
MIME-Version: 1.0
References: <20220309155856.155540075@linuxfoundation.org> <CADVatmMODnr1vQ3VGLOACT16wLEFA6hFrTzY44VdPO2M7gX+iw@mail.gmail.com>
 <CADVatmMceoHeQqFDEJND_3GmSeQqgefeP0Z9_Zi=UTAVfZ71RQ@mail.gmail.com> <YijwKvDQxJzoYpFR@kroah.com>
In-Reply-To: <YijwKvDQxJzoYpFR@kroah.com>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Thu, 10 Mar 2022 09:41:18 +0000
Message-ID: <CADVatmMkbwBNUhjb-S6=zVhiHi7s2Exqbwq3vXPsNzCutbYR-A@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/18] 4.19.234-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>, slade@sladewatkins.com
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

On Thu, Mar 10, 2022 at 9:18 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Mar 09, 2022 at 06:15:08PM +0000, Sudip Mukherjee wrote:
> > On Wed, Mar 9, 2022 at 6:08 PM Sudip Mukherjee
> > <sudipm.mukherjee@gmail.com> wrote:
> > >
> > > Hi Greg,
> > >
> > > On Wed, Mar 9, 2022 at 4:03 PM Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > This is the start of the stable review cycle for the 4.19.234 release.
> > > > There are 18 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
> > > > Anything received after that time might be too late.
> > >
> > > My tests are still running, but just an initial result for you,
> > >
> > > x86_64 defconfig fails with:
> > > arch/x86/kernel/cpu/bugs.c: In function 'spectre_v2_select_mitigation':
> > > arch/x86/kernel/cpu/bugs.c:973:41: error: implicit declaration of
> > > function 'unprivileged_ebpf_enabled'
> > > [-Werror=implicit-function-declaration]
> > >   973 |         if (mode == SPECTRE_V2_EIBRS && unprivileged_ebpf_enabled())
> >
> > And, lots of failures in arm builds also.
> > Error:
> > arch/arm/common/secure_cntvoff.S: Assembler messages:
> > arch/arm/common/secure_cntvoff.S:24: Error: co-processor register
> > expected -- `mcr p15,0,r0,c7,r5,4'
> > arch/arm/common/secure_cntvoff.S:27: Error: co-processor register
> > expected -- `mcr p15,0,r0,c7,r5,4'
> > arch/arm/common/secure_cntvoff.S:29: Error: co-processor register
> > expected -- `mcr p15,0,r0,c7,r5,4'
> > make[1]: *** [scripts/Makefile.build:403:
> > arch/arm/common/secure_cntvoff.o] Error 1
> > make[1]: *** Waiting for unfinished jobs....
> > arch/arm/kernel/entry-common.S: Assembler messages:
> > arch/arm/kernel/entry-common.S:178: Error: co-processor register
> > expected -- `mcr p15,0,r0,c7,r5,4'
> > arch/arm/kernel/entry-common.S:187: Error: co-processor register
> > expected -- `mcr p15,0,r0,c7,r5,4'
> > make[1]: *** [scripts/Makefile.build:403:
> > arch/arm/kernel/entry-common.o] Error 1
> > make[1]: *** Waiting for unfinished jobs....
> > arch/arm/mm/cache-v7.S: Assembler messages:
> > arch/arm/mm/cache-v7.S:64: Error: co-processor register expected --
> > `mcr p15,0,r0,c7,r5,4'
> > arch/arm/mm/cache-v7.S:137: Error: co-processor register expected --
> > `mcr p15,0,r0,c7,r5,4'
> > arch/arm/mm/cache-v7.S:171: Error: co-processor register expected --
> > `mcr p15,0,r0,c7,r5,4'
> > arch/arm/mm/cache-v7.S:299: Error: co-processor register expected --
> > `mcr p15,0,r0,c7,r5,4'
> > make[1]: *** [scripts/Makefile.build:403: arch/arm/mm/cache-v7.o] Error 1
>
> All clang builds for arm are known to fail, and some arm64 clang builds
> will also fail.  I have seen initial patches for arm64, will let the
> clang developers come up with the arm fix as I have no idea how to
> handle that.  This just mirrors Linus's tree right now :)
>
> Unless this is gcc?

This is gcc version 11.2.1 20220301

Guenter has also reported the same: "Almost all arm builds, all
branches from 4.9.y to 5.16.y:"



--
Regards
Sudip
