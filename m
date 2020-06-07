Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1373B1F0F82
	for <lists+stable@lfdr.de>; Sun,  7 Jun 2020 22:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgFGUVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jun 2020 16:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727786AbgFGUVS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jun 2020 16:21:18 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA691C08C5C4
        for <stable@vger.kernel.org>; Sun,  7 Jun 2020 13:21:17 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id e4so17942421ljn.4
        for <stable@vger.kernel.org>; Sun, 07 Jun 2020 13:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vwR94gDmiVuhD4hMsQgo9dWaCe9Q+3Shvhlwse4oSpQ=;
        b=eFlCDugBRnYJsqfdotXruR2B3AE0R2wPRXEZY96oKNBIo7h0O2MJdNUsTr3hYYK1Hr
         qVla+zUmGPIVdU7T6EzsKgAeVbzYI2J3qDyE9yHx6UWsYmSNe604mFk75YM+kT9CiZiH
         JbM5ELiI+/B40PVG+/dOUh83FBdzs+VIPR/pi1rUjuBU8eQ0tDnZsfLXN6W9VrP8fmCC
         ET8JW4fSydwxN8QaTpnxVjsqligducBLivhavMozEq8t+nrLZj4D/nfpc/8Ee0+gfG2v
         VQGwv/X8NMfmAtnfCotTcRxrsyxENvhPppPvcPriukuUUi/6SfOSwI5pm6Hz13Q38KZ8
         HltA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vwR94gDmiVuhD4hMsQgo9dWaCe9Q+3Shvhlwse4oSpQ=;
        b=QJfx9SoIxNdcGmqhdBzgJLUTrooe3KKhcCJPYAwe5LcMIIHxJxOag7ypiyNymrTRjT
         sYw9G/a4KxFSUFHQ40OObNifwQdDTsdp+T5nAmVECaulfE/0xVfn+aglyNCPz1Rwjot+
         Wuus5c2DWnw76NIZN1Qaj4VUAIVnZU0XtSRomtV0THg/iJZOrnr1KhsFcVYROd981yFP
         zJAwvTIWF3jII9T5MJrShPYar6qmLsr2PJ2Lda8JruvR/jPHBkoyT84maMqjDEdiMJmV
         zqpoRbqfDlNJRPtJKi8k/HL3VNDO5JvSI3RD299Wo7Vl7f6rLWQ+zKmodqNxRi5LIJkw
         ps6w==
X-Gm-Message-State: AOAM531zCiCx1X3ucYchHBOFOVAZT2ebpmyhHsvXh3Oog3SIGgN5RG0A
        U7tDlpXAnMiayFGnXE9o3jpea0L3j2vqZ6HpwAPhFw==
X-Google-Smtp-Source: ABdhPJxVvkkdzUxXowl/ZPN6X2ELJgyci660wKby/FBmOcEpkkXMOd9/vsG63pCI4b3Va2VVtaIWNcKaPfPZzoPn89E=
X-Received: by 2002:a2e:974e:: with SMTP id f14mr9213285ljj.102.1591561276084;
 Sun, 07 Jun 2020 13:21:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200605135951.018731965@linuxfoundation.org> <CA+G9fYsuzQ1BiAx74K2VGK4enUoNLe=jzpT-+AX2NB=wd4PHPw@mail.gmail.com>
 <20200607112026.GD47740@kroah.com>
In-Reply-To: <20200607112026.GD47740@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 8 Jun 2020 01:51:04 +0530
Message-ID: <CA+G9fYvXunowhCzvg3oF1Q42m1Ze1+p+B4_hV1ErYYyKKVJKUQ@mail.gmail.com>
Subject: Re: [PATCH 5.7 00/14] 5.7.1-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 7 Jun 2020 at 16:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Sat, Jun 06, 2020 at 09:19:53PM +0530, Naresh Kamboju wrote:
> > On Fri, 5 Jun 2020 at 19:46, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.7.1 release.
> > > There are 14 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >
> > > Responses should be made by Sun, 07 Jun 2020 13:54:56 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/pa=
tch-5.7.1-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git linux-5.7.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > Results from Linaro=E2=80=99s test farm.
> >
> > While running kselftest memfd_test case the kernel panic noticed on i38=
6
> > which started with kernel BUG and followed by kernel panic.
> >
> > steps to reproduce: (Not always reproducible)
> >           - cd /opt/kselftests/mainline/memfd/
> >           - ./run_fuse_test.sh || true
> >           - ./run_hugetlbfs_test.sh || true
> >
> > [  417.473220] run_hugetlbfs_t (10826): drop_caches: 3
> > [  417.491120] audit: type=3D1701 audit(1591388532.357:87503):
> > auid=3D4294967295 uid=3D0 gid=3D0 ses=3D4294967295 subj=3Dkernel pid=3D=
10829
> > comm=3D\"memfd_test\" exe=3D\"/opt/kselftests/mainline/memfd/memfd_test=
\"
> > sig=3D6 res=3D1
> > [  417.511294] BUG: kernel NULL pointer dereference, address: 00000043
> > [  417.517569] #PF: supervisor read access in kernel mode
> > [  417.522699] #PF: error_code(0x0000) - not-present page
> > [  417.527830] *pde =3D 00000000
> > [  417.530707] Oops: 0000 [#2] SMP
> > [  417.533846] CPU: 3 PID: 10829 Comm: memfd_test Tainted: G      D W
> >        5.7.1-rc1 #1
> > [  417.541845] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> > 2.0b 07/27/2017
> > [  417.549327] EIP: kmem_cache_alloc_trace+0x81/0x2b0
> > <>
> > [  931.776242] Kernel panic - not syncing: Attempted to kill init!
> > exitcode=3D0x00000009
> > [  931.783933] Kernel Offset: 0x1ce00000 from 0xc1000000 (relocation
> > range: 0xc0000000-0xf77fdfff)
> > [  931.792627] ---[ end Kernel panic - not syncing: Attempted to kill
> > init! exitcode=3D0x00000009 ]---
>
> Did you see this on Linus's tree too?

Yes.
I have noticed 4 out of 10 kselftest full runs.

>
> Is it a regression from 5.7.0?

It is a regression on Linus 's tree and the same problem was noticed on
stable-rc 5.7 branch.

- Naresh
