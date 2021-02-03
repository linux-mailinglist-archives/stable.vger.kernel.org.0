Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A6930D637
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 10:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233155AbhBCJYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 04:24:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233449AbhBCJWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 04:22:23 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42818C0613D6
        for <stable@vger.kernel.org>; Wed,  3 Feb 2021 01:22:08 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id m20so14257308ilj.13
        for <stable@vger.kernel.org>; Wed, 03 Feb 2021 01:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=bV/3Iy33Mu/vmQh1erBMuoZAsO1B/cuqnlyDi9fAN4c=;
        b=Wz0r3sVHvXzSEclqSl5wB2uYtoYH93PG9dktmb7yD89WgANTIgWSb3y4uscxDO2eqV
         tMgIqOVPsRY3HYlFn/C5KInxBLKRV9ggHSlMjfIn4RDQvzbcY72+n1/TuqKaQU1X/Q4v
         /Q/qa7rtLDPzrallTfuGzJUFrnegUYKDzx/SpbqDo5se8AgEezNILOOimGrpslcMETZJ
         c9YU5ZDkxT0ahlYUZvEzt2g4M7Bp56oOUVX4gmQ0R5jj3ZKLbku2af/M1noAp6+Qpgv5
         WHpta8uFuL6qVnSmj4dFEtssgn5EDkFce1Jp/dMRGvsqHlTHBdz0iesq7I/44vF0w3TF
         7kMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=bV/3Iy33Mu/vmQh1erBMuoZAsO1B/cuqnlyDi9fAN4c=;
        b=UbKShIXoaX6G5t4pRrI/H3XB/tiZriMWOldl7kcXxc0CeduM5eX2qIAG2XbkIodyMZ
         hlgimiJwvtzg6ZTyiiV9m7IsGV0GDcOjsw/WJ5G0L/+1/U7qeApyaBq3sTc0pbdrK25h
         a0j4vK4AJLSqVCXF67S62gTVYUJbeymzWjblmG+5ZWSXxtL0mY1Xle6MK/WkFNkXZhwT
         NHV2GzyOdQ31bMBU6M3fXn31SfyPu/I6Wrp6yMVY2Jtst6j+T8xHdA3DmUpJhl78/TYe
         A4wTI8IF4k97/iyKj5sZ8lbCgx3V5i/bumXxZfIrLjNuDgA0mN64I6TmMrDlE57av462
         S3xA==
X-Gm-Message-State: AOAM533EzxM918iMhN0MWvipmDcECiwcwYovf4/45XBvfGvV1biErvE9
        cDAmop62QB3XTYhQw2dEyEM8sK524pgpaVyK0Ew=
X-Google-Smtp-Source: ABdhPJzMb8iBQ5zHw5sLx4Vg0N3uL4Ew/7M30ps5RZtkpZIccvLEvc4ChZgj4kBGOBUm1tDIBeLw7bfFolxtJBmdHMI=
X-Received: by 2002:a92:c5c8:: with SMTP id s8mr1875401ilt.186.1612344127755;
 Wed, 03 Feb 2021 01:22:07 -0800 (PST)
MIME-Version: 1.0
References: <CA+icZUVysDKMQxw4Fxp5SzBxau1Rpy7rra-a09TY-nzwgh54SQ@mail.gmail.com>
 <YBlONpmGoM0/qG7R@kroah.com>
In-Reply-To: <YBlONpmGoM0/qG7R@kroah.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Wed, 3 Feb 2021 10:21:56 +0100
Message-ID: <CA+icZUXeK4_5A8YzkuQUcP9jhZKvYrCtWbcgToV-FDE+VY=BvQ@mail.gmail.com>
Subject: Re: [stable-5.10.y] Pick up "x86/entry: Remove put_ret_addr_in_rdi
 THUNK macro argument"
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 2, 2021 at 2:06 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Feb 01, 2021 at 08:50:52PM +0100, Sedat Dilek wrote:
> > Hi,
> >
> > you have in Linux 5.10.13-rc1:
> >
> > "x86/entry: Emit a symbol for register restoring thunk"
> >
> > While that discussion Boris and Peter recommended to remove unused code via:
> >
> > "x86/entry: Remove put_ret_addr_in_rdi THUNK macro argument"
> > ( upstream commit 0bab9cb2d980d7c075cffb9216155f7835237f98 )
> >
> > OK, this has no CC:stable but I have both as a series in my local Git
> > and both were git-pulled from [1].
> > What do you think?
>
> What bug is this fixing that requires this in 5.10?
>

Commit 0bab9cb2d980d7c075cffb9216155f7835237f98 removed unused logic.

So-to-say:
Fixes: 320100a5ffe5 ("x86/entry: Remove the TRACE_IRQS cruft")

The commit was first introduced with Linux v5.8-rc1:

$ git describe --contains 320100a5ffe5
v5.8-rc1~21^2~28

As Linux v5.10.y is an LTS IMHO I hoped it is worth removing unused code.
You better know the rules for stable-linux, so I leave it to you, Greg.

- Sedat -
