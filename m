Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 841E81A75CB
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 10:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436559AbgDNIWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 04:22:09 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:33221 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2436547AbgDNIV4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 04:21:56 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id D102D5800F6;
        Tue, 14 Apr 2020 04:21:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 14 Apr 2020 04:21:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=K
        9NNGyZC3pe81UCb1QBdT9lxusbIOSuDYCMZGd3QvZY=; b=rKYrGrZiQ+j6FJO52
        iSkryG9dNJ5xdrkn96G/3EeAN0q/9nIeBIKScyX/bjUSuP5RharNdU2JBgX3V13h
        dGm5DPjvouo3d/VtMmg/Rs9OnOfXNmzvby9b+vwD+fxFcpe0P8TEwfUY/ThhO9u7
        thz3jiX0LJyCjcmH48jR2z5Xv+6lCR7FfjeGHmyum2MhREQotT+EmcAzXR2T04Af
        EgRWsOtRQ7UW1n/F4UtJTOvomJXkvIRpYqeHoKkFjR/TJvv1QNnWLRybCh6As6bk
        gqE3ZFnqqDcpX46s2OUZM5nQj0slUVojKaBDlXWgzhnatdiqnxrW8T7LIs/jHanB
        vAbjg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=K9NNGyZC3pe81UCb1QBdT9lxusbIOSuDYCMZGd3Qv
        ZY=; b=X5upAqVGP/jJNnDVewMt9pXltZ5l5C4o0uzAROA3hdKyE/2GPyX52DbLV
        ydvcDHWHvlYIY/TvderSu4Ne0OXuUOWgTUitW+PbgBquuOEpihu8LD4eyKEKyte3
        jswqjCQerHgV2wprahLFBYMBRPgo9S8cmpOMVBnXeUkB9HiOVFF0QiNWktAM3RMw
        9qZOQJe8E8hzbmJbUhPmXugmvxHT6uzetsmIKPSOcAIiRwIfmTXK/YWESLTVMLG4
        lHUBvN2z736+/VYel2cSnypzlhlmwXC7WLclG99se3rnsCDMcwuC/KFaTXv4DUtS
        x2zT4fzyvwBPC8pewzyEuTu0Y2n7Q==
X-ME-Sender: <xms:oHKVXusMLZbM2B0tIBqUesHKVf4dc-FOZqXPNcGnO4bWi0Cr92dTfQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfedugddtvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepfhhrvggvuggvsh
    hkthhophdrohhrghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfu
    ihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtoh
    hm
X-ME-Proxy: <xmx:oHKVXvAt5ALrBjpPUj6IRVOnCzS0lw4tpvWLLN5CQ2wnYGXqcAAULQ>
    <xmx:oHKVXhk48uBc81zn02KWktBSC8r4-MsUDClwkdLMkRHog2vIcVartQ>
    <xmx:oHKVXggTM2EuAuvvsJhYJFn13DuF0Ma3tVjwio0EMfT-YqB2tUuisQ>
    <xmx:oXKVXvmtBT2B6gQqJaARzl1tNz6065WPfpkTfcxvX1ODSkL1esYTiA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A0A2D3060060;
        Tue, 14 Apr 2020 04:21:51 -0400 (EDT)
Date:   Tue, 14 Apr 2020 10:21:50 +0200
From:   Greg KH <greg@kroah.com>
To:     Alex Deucher <alexdeucher@gmail.com>
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
Subject: Re: [regression 5.7-rc1] System does not power off, just halts
Message-ID: <20200414082150.GD4149624@kroah.com>
References: <f4eaf0ca-6cd6-c224-9205-bf64ca533ff5@molgen.mpg.de>
 <dcc4851e-0ab5-683a-2cf2-687d64a3c9da@molgen.mpg.de>
 <CADnq5_OXdpEebFY3+kyQb-WEw0Rb6cqoOFKGqgxaigU5hean1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADnq5_OXdpEebFY3+kyQb-WEw0Rb6cqoOFKGqgxaigU5hean1g@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 13, 2020 at 01:48:58PM -0400, Alex Deucher wrote:
> On Mon, Apr 13, 2020 at 1:47 PM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
> >
> > Dear Prike, dear Alex, dear Linux folks,
> >
> >
> > Am 13.04.20 um 10:44 schrieb Paul Menzel:
> >
> > > A regression between causes a system with the AMD board MSI B350M MORTAR
> > > (MS-7A37) with an AMD Ryzen 3 2200G not to power off any more but just
> > > to halt.
> > >
> > > The regression is introduced in 9ebe5422ad6c..b032227c6293. I am in the
> > > process to bisect this, but maybe somebody already has an idea.
> >
> > I found the Easter egg:
> >
> > > commit 487eca11a321ef33bcf4ca5adb3c0c4954db1b58
> > > Author: Prike Liang <Prike.Liang@amd.com>
> > > Date:   Tue Apr 7 20:21:26 2020 +0800
> > >
> > >     drm/amdgpu: fix gfx hang during suspend with video playback (v2)
> > >
> > >     The system will be hang up during S3 suspend because of SMU is pending
> > >     for GC not respose the register CP_HQD_ACTIVE access request.This issue
> > >     root cause of accessing the GC register under enter GFX CGGPG and can
> > >     be fixed by disable GFX CGPG before perform suspend.
> > >
> > >     v2: Use disable the GFX CGPG instead of RLC safe mode guard.
> > >
> > >     Signed-off-by: Prike Liang <Prike.Liang@amd.com>
> > >     Tested-by: Mengbing Wang <Mengbing.Wang@amd.com>
> > >     Reviewed-by: Huang Rui <ray.huang@amd.com>
> > >     Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > >     Cc: stable@vger.kernel.org
> >
> > It reverts cleanly on top of 5.7-rc1, and this fixes the issue.
> >
> > Greg, please do not apply this to the stable series. The commit message
> > doesn’t even reference a issue/bug report, and doesn’t give a detailed
> > problem description. What system is it?
> >
> > Dave, Alex, how to proceed? Revert? I created issue 1094 [1].
> 
> Already fixed:
> https://patchwork.freedesktop.org/patch/361195/

Any reason that doesn't have a cc: stable tag on it?

And is it committed to any tree at the moment?

thanks,

greg k-h
