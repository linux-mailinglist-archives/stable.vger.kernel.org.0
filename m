Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8796F1A7BCB
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 15:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502564AbgDNNIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 09:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730314AbgDNNIC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 09:08:02 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E57C061A0C;
        Tue, 14 Apr 2020 06:08:01 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id h2so12882097wmb.4;
        Tue, 14 Apr 2020 06:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NTg88EBEg4qOXVBL74JDWDn01n0VKUHWmo8g8ottwjk=;
        b=doeIn3Si97S/MngUsuOx9N4xLfiWQ81AHOxJsgpJhSAaWdJ2Vx25UzrTmv1oMFjUT5
         2QrtYy8fiNH4Kn3zuur6CtddJ+sA9PjIDuvapuo+7hezmgeX1gCLq8q/cvM0dqtWRJ+s
         RRbl7AO5mYAqbZIYfFOfsLhszvuoM1XdzCh6gHiYb2MIgUpFnlvCr3wmp+TG3kxnoWi2
         KTfOQAqt+s4VSLVL7pdljX4nIVsSCXJW1iUCV2XueyHuhYle+s3TZXZVNctwVQ/UWr18
         WrkPmWYC/UlioNHys+m0chulDlp4tIJTjsliPfReuZdcpT6juGkIrPquN6zRthwd3wzu
         0ZSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NTg88EBEg4qOXVBL74JDWDn01n0VKUHWmo8g8ottwjk=;
        b=kfmPpT/MOie0nZYLux8VUwp+gTfDh681xjPGEzrFoKV9KZOCzHAEmEpLaQXTa2NP50
         /gkQnzkL2QSH33IP6DUpt5Th8tiLlsBX2oVlzOhd6Jr9DZwfMgY5ZS1ypMxOhmPyEjjG
         qy7S8X638prKM3gg+8Q5ilm+DCn3X0KQ85DXR7FOyd8KKSaQ3br8MFUBZVkIzRNJ4Zh3
         wFaLnqKZQvE+2g3jxlGI9gElg9G90Bbt5SAA/5Ri7qlgjMM3zakwI+9pIdb6Gn3JcDNw
         /sYLAXVWPBhM+NKcSG7OEhdiHn2KMuhn/G5fECeOhKY2sCFaIedWOfmoaLHqtvX/0pFg
         aupA==
X-Gm-Message-State: AGi0Pub/NVKjxacGwySPhgQsoKhj0S8OXxnu/Yd4Wb2hpUUuC+xJ5o7W
        o/720RD1VLGPLbL3SgZnau6Sc92Y1yFlhKudm3I=
X-Google-Smtp-Source: APiQypLRdOptdfBucYqQMnGBtfQiQYTTSA5SWpTYFLPJ+tWQQHwbFT4r0uERcCDlgiqUc8evR7fd9G2UXxUjtwOwvAI=
X-Received: by 2002:a7b:cc8e:: with SMTP id p14mr23079662wma.70.1586869680226;
 Tue, 14 Apr 2020 06:08:00 -0700 (PDT)
MIME-Version: 1.0
References: <f4eaf0ca-6cd6-c224-9205-bf64ca533ff5@molgen.mpg.de>
 <dcc4851e-0ab5-683a-2cf2-687d64a3c9da@molgen.mpg.de> <CADnq5_OXdpEebFY3+kyQb-WEw0Rb6cqoOFKGqgxaigU5hean1g@mail.gmail.com>
 <20200414082150.GD4149624@kroah.com>
In-Reply-To: <20200414082150.GD4149624@kroah.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Tue, 14 Apr 2020 09:07:49 -0400
Message-ID: <CADnq5_NCnHFO9kZY-8L34B3uVX5aghXO8+gXNC_cPMOnP7UGAg@mail.gmail.com>
Subject: Re: [regression 5.7-rc1] System does not power off, just halts
To:     Greg KH <greg@kroah.com>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Prike Liang <Prike.Liang@amd.com>,
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

On Tue, Apr 14, 2020 at 4:21 AM Greg KH <greg@kroah.com> wrote:
>
> On Mon, Apr 13, 2020 at 01:48:58PM -0400, Alex Deucher wrote:
> > On Mon, Apr 13, 2020 at 1:47 PM Paul Menzel <pmenzel@molgen.mpg.de> wro=
te:
> > >
> > > Dear Prike, dear Alex, dear Linux folks,
> > >
> > >
> > > Am 13.04.20 um 10:44 schrieb Paul Menzel:
> > >
> > > > A regression between causes a system with the AMD board MSI B350M M=
ORTAR
> > > > (MS-7A37) with an AMD Ryzen 3 2200G not to power off any more but j=
ust
> > > > to halt.
> > > >
> > > > The regression is introduced in 9ebe5422ad6c..b032227c6293. I am in=
 the
> > > > process to bisect this, but maybe somebody already has an idea.
> > >
> > > I found the Easter egg:
> > >
> > > > commit 487eca11a321ef33bcf4ca5adb3c0c4954db1b58
> > > > Author: Prike Liang <Prike.Liang@amd.com>
> > > > Date:   Tue Apr 7 20:21:26 2020 +0800
> > > >
> > > >     drm/amdgpu: fix gfx hang during suspend with video playback (v2=
)
> > > >
> > > >     The system will be hang up during S3 suspend because of SMU is =
pending
> > > >     for GC not respose the register CP_HQD_ACTIVE access request.Th=
is issue
> > > >     root cause of accessing the GC register under enter GFX CGGPG a=
nd can
> > > >     be fixed by disable GFX CGPG before perform suspend.
> > > >
> > > >     v2: Use disable the GFX CGPG instead of RLC safe mode guard.
> > > >
> > > >     Signed-off-by: Prike Liang <Prike.Liang@amd.com>
> > > >     Tested-by: Mengbing Wang <Mengbing.Wang@amd.com>
> > > >     Reviewed-by: Huang Rui <ray.huang@amd.com>
> > > >     Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > > >     Cc: stable@vger.kernel.org
> > >
> > > It reverts cleanly on top of 5.7-rc1, and this fixes the issue.
> > >
> > > Greg, please do not apply this to the stable series. The commit messa=
ge
> > > doesn=E2=80=99t even reference a issue/bug report, and doesn=E2=80=99=
t give a detailed
> > > problem description. What system is it?
> > >
> > > Dave, Alex, how to proceed? Revert? I created issue 1094 [1].
> >
> > Already fixed:
> > https://patchwork.freedesktop.org/patch/361195/
>
> Any reason that doesn't have a cc: stable tag on it?
>
> And is it committed to any tree at the moment?

It's going out in my -fixes pull this week with a stable tag.

Alex

>
> thanks,
>
> greg k-h
