Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6832AF6A19
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 17:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbfKJQ0c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Nov 2019 11:26:32 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42489 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727010AbfKJQ0c (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Nov 2019 11:26:32 -0500
Received: by mail-wr1-f68.google.com with SMTP id a15so12029233wrf.9
        for <stable@vger.kernel.org>; Sun, 10 Nov 2019 08:26:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EnozZYgq48Ub7OErRTAS6opwPFw2ErTB4hRiw3ntfu8=;
        b=cAulYa8QWiLTC+LYVwikv9Xp1DhQdoEHRTmBbVMBcK/Q60V2ZXtiiA4Un15UQ0gACg
         3k7UZ1IX9aHV8oMhci+9UWIYl+pv1bbNWsL+MNDoC5NOGhSq4CfmiiMMxLQEl624gCDc
         c7ZGX4OfFLckujkKjO3PTUvTBelBdqcakvQzqSiPf7qtlCyQT/3+KlSqaqlpgsxOGNFK
         1jF6JcZT7t7faoB1aMYHsE5DBWB/nB3VB1zXCPc+bT8pH6rEOiSNZSGC30sh3w6Oocdy
         /Xoin/AIElFI07xPeTkPOkLQz5z/3SPjGyWMkN+KohtSlJdRj/aeB9/+QMh8kLFlRJ1k
         Fsgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EnozZYgq48Ub7OErRTAS6opwPFw2ErTB4hRiw3ntfu8=;
        b=CiZqjkoJrGCMFqpLJOkBdYkne/pk9FZ9FtefXqEYq1iJ+hWcRMaXZ6kU6+MRV3IyBm
         wRsbKFsJ3wzGAMNCmxjgBcyISl/YZgAL2KZlt2mj4Fj9doyUtGirnq+UmXRfWLnVnoDa
         piRyLldBqUyko6+f5gQVNDRJSQTGAluM7udnYNAlaslnmoAcFcYwuYl0/WznV4rJv+Lz
         pC8f4yPpHHWxAv7MQmQszKUHfbkyRUqTskZl3SnfWCNTryNsmYvFdW6P94KnqNFSTB7B
         k+Q95IaSDqvszmC6hLcv4DWOTSVy1ieVR0K90WsqO4Ib4k8zooAE/CYcOFZnKWl/EpUn
         RXVQ==
X-Gm-Message-State: APjAAAVD0adKOh9/dxOK+AUD2kdFaz0bBS5juB06HXBIUi7v3PmQcnu0
        RX0hmgpqo/XoX2BqQaecgVopLogXXG3d8JNIuMORPQ==
X-Google-Smtp-Source: APXvYqz/qVyZzKKEiMD5Kn0/CYQ5KiLilJu8C+o/QOePighWGP9/mMPGB5cxpk0QCuszSvTL/cE/a/1ffSaZ3SoYRWs=
X-Received: by 2002:adf:f743:: with SMTP id z3mr16510655wrp.200.1573403187573;
 Sun, 10 Nov 2019 08:26:27 -0800 (PST)
MIME-Version: 1.0
References: <20191110024013.29782-1-sashal@kernel.org> <20191110024013.29782-133-sashal@kernel.org>
 <CAKv+Gu-PawCS_Wq3Hm+gm_f=6-ihXarkQqP9prkj4CLt=pAnvg@mail.gmail.com>
 <20191110132726.GN4787@sasha-vm> <CAKv+Gu_Pg-j6C0iRqa8wSr+=vk3rMQ=KHFykZGNGWMfcYfAjtg@mail.gmail.com>
 <20191110155655.GO4787@sasha-vm>
In-Reply-To: <20191110155655.GO4787@sasha-vm>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sun, 10 Nov 2019 16:26:15 +0000
Message-ID: <CAKv+Gu_uGKKQrkvHXhoKCY6dqEWka6qVpjXBit5Ggjbk6+_c7A@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.19 133/191] efi: honour memory reservations
 passed via a linux specific config table
To:     Sasha Levin <sashal@kernel.org>, Marc Zyngier <maz@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        linux-efi <linux-efi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

(adding Marc, the GIC maintainer)

On Sun, 10 Nov 2019 at 15:57, Sasha Levin <sashal@kernel.org> wrote:
>
> On Sun, Nov 10, 2019 at 02:16:57PM +0000, Ard Biesheuvel wrote:
> >On Sun, 10 Nov 2019 at 13:27, Sasha Levin <sashal@kernel.org> wrote:
> >>
> >> On Sun, Nov 10, 2019 at 08:33:47AM +0100, Ard Biesheuvel wrote:
> >> >On Sun, 10 Nov 2019 at 03:44, Sasha Levin <sashal@kernel.org> wrote:
> >> >>
> >> >> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >> >>
> >> >> [ Upstream commit 71e0940d52e107748b270213a01d3b1546657d74 ]
> >> >>
> >> >> In order to allow the OS to reserve memory persistently across a
> >> >> kexec, introduce a Linux-specific UEFI configuration table that
> >> >> points to the head of a linked list in memory, allowing each kernel
> >> >> to add list items describing memory regions that the next kernel
> >> >> should treat as reserved.
> >> >>
> >> >> This is useful, e.g., for GICv3 based ARM systems that cannot disable
> >> >> DMA access to the LPI tables, forcing them to reuse the same memory
> >> >> region again after a kexec reboot.
> >> >>
> >> >> Tested-by: Jeremy Linton <jeremy.linton@arm.com>
> >> >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >> >> Signed-off-by: Sasha Levin <sashal@kernel.org>
> >> >
> >> >NAK
> >> >
> >> >This doesn't belong in -stable, and I'd be interested in understanding
> >> >how this got autoselected, and how I can prevent this from happening
> >> >again in the future.
> >>
> >> It was selected because it's part of a fix for a real issue reported by
> >> users:
> >>
> >
> >For my understanding, are you saying your AI is reading launchpad bug
> >reports etc? Because it is marked AUTOSEL.
>
> Not quite. This review set was me feeding all the patches Ubuntu has on
> top of stable trees into AUTOSEL, and sending out the output for review.
> I doesn't look into launchpad bug reports on it's own, but in my
> experience one can find a bug report for mostly everything AUTOSEL
> considers to be a bug.
>

So the assumption is that taking an arbitrary subset of what Ubuntu
backported (and tested extensively), and letting that subset be chosen
by a bot is a process that improves the quality of stable trees? I'm
rather skeptical of that tbh.

> >> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1806766
> >>
> >
> >That pages mentions
> >
> >"""
> >2 upstream patch series are required to fix this:
> > https://<email address hidden>/msg10328.html
> >Which provides an EFI facility consumed by:
> > https://lkml.org/lkml/2018/9/21/1066
> >There were also some follow-on fixes to deal with ARM-specific
> >problems associated with this usage:
> > https://www.spinics.net/lists/arm-kernel/msg685751.html
> >"""
> >
> >and without the other patches, we only add bugs and don't fix any.
> >
> >> Besides ubuntu, it is also carried by:
> >>
> >> SUSE: https://www.suse.com/support/update/announcement/2019/suse-su-20191530-1/
> >> CentOS: https://koji.mbox.centos.org/koji/buildinfo?buildID=4558
> >>
> >> As a way to resolve the reported bug.
> >>
> >
> >Backporting a feature/fix like this requires careful consideration of
> >the patches involved, and doing actual testing on hardware.
> >
> >> Any reason this *shouldn't* be in stable?
> >
> >Yes. By itself, it causes crashes at early boot and does not actually
> >solve the problem.
>
> Sure, let's work on gathering all the needed patches then and testing it
> out.
>

No, let's not. This is a feature that was introduced to address a
shortcoming in some hardware that makes kexec/kdump problematic on
them. If you want kexec/kdump on that hardware, use a newer kernel.

> >> I'm aware that there might be
> >> dependencies that are not obvious to me, but the solution here is to
> >> take those dependencies as well rather than ignore the process
> >> completely.
> >>
> >
> >This is not a bugfix. kexec/kdump never worked correctly on the
> >hardware involved, and backporting a feature like that goes way beyond
> >what I am willing to accept for stable backports affecting the EFI
> >subsystem.
>
> I'm a bit confused. The bug report starts with:
>
>         [Impact]
>         kdump support isn't usable on HiSilicon D05 systems. This
>         previously worked in bionic.
>
> So it seems like it did use to work, but not anymore?
>

I have no idea what Ubuntu shipped in the previous kernel, but
labelling this as a software regression is dubious at least, and
wholly inaccurate for upstream.

> Either way, I understand that you want to keep the stable tree
> conservative, but keep in mind that the flip side of not taking fixes
> that users ask for means that distros end up having to carry them
> anyway, which means that they don't get the review and testing they
> need.
>

I'd say it is the opposite. At least the distros test their backports
on actual hardware. Taking any part of this set without testing it by
doing kexec/kdump on an affected ARM system, and regression testing it
on the hardware that got broken by it (with hundreds of cores IIRC) is
totally irresponsible, and I don't have the time or the hardware to do
the testing.

> We can argue all we want around whether it's a fix or not, but if most
> distros carry it then I think our argument is moot.
>

If someone cares enough to backport these as a coherent set, with boot
tests on the affected hardware etc, then I am not going to object.
