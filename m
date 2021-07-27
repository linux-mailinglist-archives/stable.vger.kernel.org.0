Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C16373D799C
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 17:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbhG0PWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 11:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbhG0PWN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 11:22:13 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2888BC061757
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 08:22:13 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id q15so21280649ybu.2
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 08:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jlekstrand-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GgDEfe0zbOFECOvF5LtxR80/Jw1kTHtzvcNrB8t419k=;
        b=utS/uh64yKWhWVJXBtQUuI+R3df/5ogtum9ukX4plgOJUusV0Kk2rYaTtbRdDX2NgA
         efTL+nkbhIdIQ+5SR/W5Gb3Wch7V8OzOAGvAWlAJoxi4gBzfpJuGtoF6kixun9aSr2Ls
         3HNeIuAzHACegotFF86D/XmNr7TPxUOe7/CqOzoJSuOMZBX+xd/27zulKN1JyprYDvtV
         Yqew5/s+tYKk2rUZHuredQhsBW3YvEtSnB2DqSWtCHr/db514wlzWGT7OY6ly7fjpUTY
         xNEIrJx2RQ9AjnNCBzIsca2Pr/650HTupRQvnuZJNe/w9T8fWbRxAaeod2mqBnhI4naT
         fVVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GgDEfe0zbOFECOvF5LtxR80/Jw1kTHtzvcNrB8t419k=;
        b=Puwv5/wPrsIKRn6OT0fWuTrClKIhHQPp47/oTUXjeYL5L8O61KTFAt1RDD+7SLgOnb
         Y6JVHLyO6J6hruB/2a1Xajf/BN9dAs4jaLWY30RJ5vNJuvcKPk51y5tMyd42+WeF5HB1
         ay/mQwwB9qvla/ZIRLdhNuxnr1znH6tI54ERE4uLlRmG7HsR2+WGC1TSOli0MOHxuhEV
         T/2yJoBxHVA/QlK+GLIoNav4w+Mhnn8y1L6+/Xd5QSm1Agv3sQSGTKGCNlZdwCn3unCn
         NDKYS56CVvq5YvuxI07m2UeBjzLhH7T6obKQRAz7HphwPnQF80o0J0yT2Qf3SORJFV7h
         cabQ==
X-Gm-Message-State: AOAM5321iT4CHRGgVsuG1zmrd7sjbeguOq9dKAjU3GmCSwXWuh2VYhO1
        yoyWsPPnECO3L219kZUrrchKZRJ6hQBoHgYguRcbI4oiEANvCw==
X-Google-Smtp-Source: ABdhPJyOzIy73aYDSgmKJaEteIb9ZVcNi5XWIFBIYg80ATpv8Xt+y3Zh3/Wh7WaGf0mexMYk7BSDnaS9YFTgIZ8BrQI=
X-Received: by 2002:a25:b708:: with SMTP id t8mr10882235ybj.139.1627399332292;
 Tue, 27 Jul 2021 08:22:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210726231548.3511743-1-jason@jlekstrand.net>
 <YP+WQ4Ej2jyHjIeO@kroah.com> <CAKMK7uFpmd=Or2uRfh8vrdnmeJLUFkz0HbC44ueNyv59P-T-mA@mail.gmail.com>
In-Reply-To: <CAKMK7uFpmd=Or2uRfh8vrdnmeJLUFkz0HbC44ueNyv59P-T-mA@mail.gmail.com>
From:   Jason Ekstrand <jason@jlekstrand.net>
Date:   Tue, 27 Jul 2021 10:22:01 -0500
Message-ID: <CAOFGe97sM_GgZV=BCx8HnrJ2q4UD8eGcsZky2RzhALd9W7gw=A@mail.gmail.com>
Subject: Re: [PATCH] Revert "drm/i915/gem: Asynchronous cmdparser"
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Jon Bloomfield <jon.bloomfield@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 27, 2021 at 5:41 AM Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>
> On Tue, Jul 27, 2021 at 7:15 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, Jul 26, 2021 at 06:15:48PM -0500, Jason Ekstrand wrote:
> > > commit 93b713304188844b8514074dc13ffd56d12235d3 upstream.  This version
> > > applies to the 5.10 tree.
> >
> > I do not see that commit id in Linus's tree, are you sure it is correct?
>
> 3761baae908a ("Revert "drm/i915: Propagate errors on awaiting already
> signaled fences"")
>
> Jason, you need to pick the sha1 from drm-intel-fixes, which
> cherry-picks. Confuses -stable otherwise.

Sorry.  Do you want me to re-send with correct reference SHAs?

--Jason

> Aside from that confusion, they're all there in -rc3.
> -Daniel
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> http://blog.ffwll.ch
