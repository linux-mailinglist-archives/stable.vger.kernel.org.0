Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F30D1A6BA4
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 19:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387438AbgDMRtM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 13:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387436AbgDMRtL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 13:49:11 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9791C0A3BDC;
        Mon, 13 Apr 2020 10:49:10 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id x4so10073890wmj.1;
        Mon, 13 Apr 2020 10:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WT8RpNA0P+GqDuq/DyS+L+6ZT/1lo/cn+dTgGXIpD78=;
        b=DI6aEomb/BXc6SfxFnQlVQo+tmkqg4/JH7mWJ02QKEPDvVT8si2J4K4iWaa8HrbiVG
         AZ5zKrauwCZn+UxinpmGQAfBZ9SOrGjeQyyE3Qy6S6KvRkfk40OAGaPAN6AjBnxuPYia
         cT2/yVvotVuHyE75pEhV0UCtwv8K2DyCW53di/ECstDUURwguj3SUe3ny68EFDU83u/O
         ol6cA3MklZSvAn4pVYrmi+udUBX2kiHcZjjdyQgXcUxm93UvQTdxo7YqGfRelanItcFy
         AqeroG+vhFOGIQ5xC6O6wCRrCuoNr755h7qlzOSVcivex3rCGETVc0Gwmf05JjsPAszS
         Xlcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WT8RpNA0P+GqDuq/DyS+L+6ZT/1lo/cn+dTgGXIpD78=;
        b=aZvCycgwa6knHtaAF4RwysQfxSgTPuYei6wxG7gamYXDZwA7R8IhSDQsdU4VaDhrNC
         5Iy4PLD7FXucTxKyHlh4W4QK4wyK7+Tk40wX75Ja/3zmVGHyhOXzTCf1GAeTQcciN/y4
         wOWsEpA2NvBftCwRQF4JMrqME1FY/PvlmRHSRwxrTM1Ksvmb9Z1vdBlSSGR0tqrs/jP6
         1krpJT9RKaBrWEZzhE2+m16fFmC0X/1dBZZEHV7yJtFqInc2qQvjcnuBjl01ogjhTxRP
         YMk5ifQ+4YLtOUOi6bzbwlnB+WX3QOeaBZDe9aov82IgYO0QVBcQ5oMp/Hr6xERWMIqJ
         z5Vg==
X-Gm-Message-State: AGi0PuZCf21kX7XwNumjhcYdZvXbdx759sCYcN+RQu4YyvVSbvIPRUtS
        FRs+uwMuLCtbtSA+HuTU2Hlj6OHYbin/QcsQLInUjdPn
X-Google-Smtp-Source: APiQypKijTsqeDp9flz+rvwjuFRJgzih5dOlUl923r/R/fXsWD/UuRvPQiIx6fhd+c8ClPZAGmtIGgB3/u4XfRPLJdc=
X-Received: by 2002:a1c:6344:: with SMTP id x65mr19974588wmb.56.1586800149445;
 Mon, 13 Apr 2020 10:49:09 -0700 (PDT)
MIME-Version: 1.0
References: <f4eaf0ca-6cd6-c224-9205-bf64ca533ff5@molgen.mpg.de> <dcc4851e-0ab5-683a-2cf2-687d64a3c9da@molgen.mpg.de>
In-Reply-To: <dcc4851e-0ab5-683a-2cf2-687d64a3c9da@molgen.mpg.de>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Mon, 13 Apr 2020 13:48:58 -0400
Message-ID: <CADnq5_OXdpEebFY3+kyQb-WEw0Rb6cqoOFKGqgxaigU5hean1g@mail.gmail.com>
Subject: Re: [regression 5.7-rc1] System does not power off, just halts
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Prike Liang <Prike.Liang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        regressions@leemhuis.info, David Airlie <airlied@linux.ie>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "for 3.8" <stable@vger.kernel.org>, Huang Rui <ray.huang@amd.com>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        Mengbing Wang <Mengbing.Wang@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 13, 2020 at 1:47 PM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>
> Dear Prike, dear Alex, dear Linux folks,
>
>
> Am 13.04.20 um 10:44 schrieb Paul Menzel:
>
> > A regression between causes a system with the AMD board MSI B350M MORTA=
R
> > (MS-7A37) with an AMD Ryzen 3 2200G not to power off any more but just
> > to halt.
> >
> > The regression is introduced in 9ebe5422ad6c..b032227c6293. I am in the
> > process to bisect this, but maybe somebody already has an idea.
>
> I found the Easter egg:
>
> > commit 487eca11a321ef33bcf4ca5adb3c0c4954db1b58
> > Author: Prike Liang <Prike.Liang@amd.com>
> > Date:   Tue Apr 7 20:21:26 2020 +0800
> >
> >     drm/amdgpu: fix gfx hang during suspend with video playback (v2)
> >
> >     The system will be hang up during S3 suspend because of SMU is pend=
ing
> >     for GC not respose the register CP_HQD_ACTIVE access request.This i=
ssue
> >     root cause of accessing the GC register under enter GFX CGGPG and c=
an
> >     be fixed by disable GFX CGPG before perform suspend.
> >
> >     v2: Use disable the GFX CGPG instead of RLC safe mode guard.
> >
> >     Signed-off-by: Prike Liang <Prike.Liang@amd.com>
> >     Tested-by: Mengbing Wang <Mengbing.Wang@amd.com>
> >     Reviewed-by: Huang Rui <ray.huang@amd.com>
> >     Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> >     Cc: stable@vger.kernel.org
>
> It reverts cleanly on top of 5.7-rc1, and this fixes the issue.
>
> Greg, please do not apply this to the stable series. The commit message
> doesn=E2=80=99t even reference a issue/bug report, and doesn=E2=80=99t gi=
ve a detailed
> problem description. What system is it?
>
> Dave, Alex, how to proceed? Revert? I created issue 1094 [1].

Already fixed:
https://patchwork.freedesktop.org/patch/361195/

Alex

>
>
> Kind regards,
>
> Paul
>
>
> [1]: https://gitlab.freedesktop.org/drm/amd/-/issues/1094
> _______________________________________________
> amd-gfx mailing list
> amd-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/amd-gfx
