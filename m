Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB1AF6966
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 15:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfKJORL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Nov 2019 09:17:11 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40955 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbfKJORK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Nov 2019 09:17:10 -0500
Received: by mail-wr1-f67.google.com with SMTP id i10so11864677wrs.7
        for <stable@vger.kernel.org>; Sun, 10 Nov 2019 06:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/gsTXRLdcmbPIrBJTR08AIIElFXvOM/gj2w8ksdg+3s=;
        b=djFNIcLYJniF/kYHxazOvCnVViSEFx4WGm/DB+qje56mYNRO8twZ9tLgT9WLxztVa+
         BKPqIChCQR9Vav8VB6mCUq6J6MO5Jy+kpO9aNa9sPINL30kxsqyQeDXO9PYhVANtbgoN
         +FrPlMSkaEKIsvsQJnkTjdWbnlGqowPQFt751T5qEe8ew0nLCxSI3tVjuO5BzVfQyuDQ
         hm4wXJXS2qEm06KaqjgY5Sl/nBfEktp5cocsUIIoqEWvEsbBGIste8jc/hUCwiOV8jkm
         2LExVIbO4w05YBNX2b06COaaAEK/KgjXmaD6+Zo451e9xEZOyDxcEdNV1hOGVqOidkxf
         oLFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/gsTXRLdcmbPIrBJTR08AIIElFXvOM/gj2w8ksdg+3s=;
        b=VNSILb7bW8o9vzcCI8u4x5cJ2beaYomsDv7IYn2aAGWYHykkA6YM/JaZkhswqnGWBn
         6ADSgzuQXuEc+9EFuGhblwE1ofdXjxR6da6gG6z6J5J+XGoArauqe3VTIrPtCRCDEwNh
         UsMjyAHMzBgD6H25lCD73KUu2UXMA49A5FlV8Jcv5gl/PeMCYH86sBbXh54GZ9x46b5L
         g4UGTssN6CW7LlMsxfIOrZ3dABqQtV/FwBEuxGwDE2zb60mNPImt+Mm9tc+9HbTnC8Tt
         PT5ZihziYEk2QZogw3tOuO2OQJaMQd6jG430DaZseA6oTO8xQID3+E/A2R6C5ze/pOgq
         Q2yg==
X-Gm-Message-State: APjAAAVKkXgOwTKhpYCgjrEzLiw9hXGDLjaT+wM1/z5//sFrsGSM1g17
        WAUTidvrN8mqfp6a8tag0iOHbQJjGxYgZRk4qYhBwXY7Sm40AKwC
X-Google-Smtp-Source: APXvYqyUUQm4IaolEARn85QDGFZgvuBIQiiwRvhvum1THFJXOyDlniXRJB2WjCnc4uJIqhA7FspZXrAt/zP0vHsgflY=
X-Received: by 2002:adf:ec42:: with SMTP id w2mr15841958wrn.32.1573395428010;
 Sun, 10 Nov 2019 06:17:08 -0800 (PST)
MIME-Version: 1.0
References: <20191110024013.29782-1-sashal@kernel.org> <20191110024013.29782-133-sashal@kernel.org>
 <CAKv+Gu-PawCS_Wq3Hm+gm_f=6-ihXarkQqP9prkj4CLt=pAnvg@mail.gmail.com> <20191110132726.GN4787@sasha-vm>
In-Reply-To: <20191110132726.GN4787@sasha-vm>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sun, 10 Nov 2019 14:16:57 +0000
Message-ID: <CAKv+Gu_Pg-j6C0iRqa8wSr+=vk3rMQ=KHFykZGNGWMfcYfAjtg@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.19 133/191] efi: honour memory reservations
 passed via a linux specific config table
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        linux-efi <linux-efi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 10 Nov 2019 at 13:27, Sasha Levin <sashal@kernel.org> wrote:
>
> On Sun, Nov 10, 2019 at 08:33:47AM +0100, Ard Biesheuvel wrote:
> >On Sun, 10 Nov 2019 at 03:44, Sasha Levin <sashal@kernel.org> wrote:
> >>
> >> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >>
> >> [ Upstream commit 71e0940d52e107748b270213a01d3b1546657d74 ]
> >>
> >> In order to allow the OS to reserve memory persistently across a
> >> kexec, introduce a Linux-specific UEFI configuration table that
> >> points to the head of a linked list in memory, allowing each kernel
> >> to add list items describing memory regions that the next kernel
> >> should treat as reserved.
> >>
> >> This is useful, e.g., for GICv3 based ARM systems that cannot disable
> >> DMA access to the LPI tables, forcing them to reuse the same memory
> >> region again after a kexec reboot.
> >>
> >> Tested-by: Jeremy Linton <jeremy.linton@arm.com>
> >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >> Signed-off-by: Sasha Levin <sashal@kernel.org>
> >
> >NAK
> >
> >This doesn't belong in -stable, and I'd be interested in understanding
> >how this got autoselected, and how I can prevent this from happening
> >again in the future.
>
> It was selected because it's part of a fix for a real issue reported by
> users:
>

For my understanding, are you saying your AI is reading launchpad bug
reports etc? Because it is marked AUTOSEL.

> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1806766
>

That pages mentions

"""
2 upstream patch series are required to fix this:
 https://<email address hidden>/msg10328.html
Which provides an EFI facility consumed by:
 https://lkml.org/lkml/2018/9/21/1066
There were also some follow-on fixes to deal with ARM-specific
problems associated with this usage:
 https://www.spinics.net/lists/arm-kernel/msg685751.html
"""

and without the other patches, we only add bugs and don't fix any.

> Besides ubuntu, it is also carried by:
>
> SUSE: https://www.suse.com/support/update/announcement/2019/suse-su-20191530-1/
> CentOS: https://koji.mbox.centos.org/koji/buildinfo?buildID=4558
>
> As a way to resolve the reported bug.
>

Backporting a feature/fix like this requires careful consideration of
the patches involved, and doing actual testing on hardware.

> Any reason this *shouldn't* be in stable?

Yes. By itself, it causes crashes at early boot and does not actually
solve the problem.

> I'm aware that there might be
> dependencies that are not obvious to me, but the solution here is to
> take those dependencies as well rather than ignore the process
> completely.
>

This is not a bugfix. kexec/kdump never worked correctly on the
hardware involved, and backporting a feature like that goes way beyond
what I am willing to accept for stable backports affecting the EFI
subsystem.
