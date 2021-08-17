Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754B53EEFC6
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 17:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241120AbhHQP4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 11:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240908AbhHQPzA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Aug 2021 11:55:00 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6FBC061148;
        Tue, 17 Aug 2021 08:53:02 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id w17so40245554ybl.11;
        Tue, 17 Aug 2021 08:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ad+Zsolc7/8Flifj/AFvAVLtDzWy59b2zVil2HRHIfY=;
        b=uXIYrmWqUVATINK0+T74EITcdbYWYbFb7vjVzCpDrX1xCD9Zq9ksMufGyAtmni1aYO
         5ztAepsqv/Rkr/DsvgpDbJdx+uqFdDnov+fn3WJ4m3tOIYpgbNL1SpYSI13iAtRXgGd6
         KAOh93KIcCsA7t6aDTaw1eQ27QRAR2WkvnC3f5Kugrfi/BEtFq4x4kQ5SUEEZ8nvmekc
         dxMxlJCOMCc8V1Nsrp6DFjPLuuXPQjeW2NN5QjsWkgPpZ2uHdQnMcGI+qB+n+6QwdVxW
         /FJHGSCagikqtWCi59Bicm9+Ahj6Ryqd3+tKvjymHwUzUVupecL+pmLThDYEA0RE4L12
         0rTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ad+Zsolc7/8Flifj/AFvAVLtDzWy59b2zVil2HRHIfY=;
        b=E+4aIEttAiIQRq2EN/qxUObvphnEc/Q7daEDKfuaZt6Hl1rRXv+HtpE9eKq/G9FvnD
         WBzm35Tzm4bPk3x2L5w2+Qaz3eFTtiZsFBNsfCc3vqrBYQ6aYikkPYyFNMtTc2/Au0dO
         0a6gQF1ZXuUaQRaSSsmfTbRLXUxWBJK4M8f4wo4PQ0X9LOJzHONwdCgT+PiQrixocwQA
         XLR1eg9+J/E19LnFNZR5AjhcUFIdJmepCHieuQwxxA4ApNia3y+PmF1gybYcELVxWHeI
         h68qgFO5HxV9Q3UECtnlQKQjRNJLlwxF87PIzbmc+bU54869qBOsUCBSjEywV9g7hj5X
         vugg==
X-Gm-Message-State: AOAM530n2rS2ZlgtWDlc2zz6BIZdL6IuIQw5cAnRBZwTfEPlXp71kWS+
        Da0vLWe9FPGsU+m4Ft9zRWayJdCY1P6hLe9InLw=
X-Google-Smtp-Source: ABdhPJzvkicTLAwRwgM/tdXvwY2iNi9uWyE181/sF7TFLANZTMGYtcGAUPEnhrZJFvo5xohswxLqYgZfG8Q9UK5CVz4=
X-Received: by 2002:a25:1546:: with SMTP id 67mr5436971ybv.331.1629215582066;
 Tue, 17 Aug 2021 08:53:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210813150522.623322501@linuxfoundation.org> <20210813150523.032839314@linuxfoundation.org>
 <20210813193158.GA21328@duo.ucw.cz> <26feedff-0fb4-01db-c809-81c932336b47@redhat.com>
In-Reply-To: <26feedff-0fb4-01db-c809-81c932336b47@redhat.com>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Tue, 17 Aug 2021 16:52:26 +0100
Message-ID: <CADVatmNm83ZdwJzMzZSEF-SPjSV4OmjByLpnYAubZSkY7f9uMw@mail.gmail.com>
Subject: Re: [PATCH 5.10 12/19] vboxsf: Make vboxsf_dir_create() return the
 handle for the created file
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 15, 2021 at 2:57 PM Hans de Goede <hdegoede@redhat.com> wrote:
>
> Hi,
>
> On 8/13/21 9:31 PM, Pavel Machek wrote:
> > Hi!
> >
> >> commit ab0c29687bc7a890d1a86ac376b0b0fd78b2d9b6 upstream
> >>
> >> Make vboxsf_dir_create() optionally return the vboxsf-handle for
> >> the created file. This is a preparation patch for adding atomic_open
> >> support.
> >
> > Follow up commits using this functionality are in 5.13 but not in
> > 5.10, so I believe we don't need this in 5.10, either?
> >
> > (Plus someone familiar with the code should check if we need "vboxsf:
> > Honor excl flag to the dir-inode create op" in 5.10; it may have same
> > problem).
>
> Actually those follow up commits fix an actual bug, so I was expecting
> the person who did the backport to also submit the rest of the set.

I only track Greg's failed messages when I find time for stable and
this one was one of those. So, no idea who has originally requested
this and why were the other two not requested.

-- 
Regards
Sudip
