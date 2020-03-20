Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 573CC18C705
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 06:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725446AbgCTFaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 01:30:15 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:37503 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbgCTFaN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Mar 2020 01:30:13 -0400
Received: by mail-oi1-f193.google.com with SMTP id w13so5338296oih.4
        for <stable@vger.kernel.org>; Thu, 19 Mar 2020 22:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+thAp6yyX7UKE9dtUxDENsQxMtVNf3sefwYHyrkPjH0=;
        b=EZIUuPizsyWJamEo8OnXltTQLT0zbEnN7i0eoveXQdd8aAXB0sTHgk0h0j2aPv3xdl
         PvlcmCU9Qqo6UPCU0YGJjPZHZklXi0mnfTFFSMmLJO2+8XQJhgG2+SrUYGqJLbRUs34w
         MHA/fMaS5ydEyWuSCzaNeVFjEQP3llaZOTs2mjgeihPn7LkbpRz5ycvSOPlzm6gBjn0W
         OaxQcy9AeArJqrxxJWa3gm8Z8TuZZTaY8qlWeFQ/x5EcXXheQhyOAhxkq6P9XBi6DkuI
         q84xSlpwp6t9y/DeFQzUxsQx2V8ge6Z5qW1kL9lgqfzvKq4NqI8zeJih0o6Bvzr7ePwC
         XgPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+thAp6yyX7UKE9dtUxDENsQxMtVNf3sefwYHyrkPjH0=;
        b=VQwAufLm8mNKPg9D4/VYQaHdC/smqtGyihI7k0ppKLaErzxg2dxaLZaJ/jHEZzQB1D
         KNIob8+lMiaidAqZFDJlAWdfq0tRteOFUzgzU2YD+zP34j29O32TR7SUJ3PfrjtwwNF6
         0TbagdLV7MJ5gGHELYBl7DTBvYsU8C31wJy7uANmN+SCY4l79fG6NApB+nJlWmybWXn/
         EcQV8S3qh5FMIKJ92rW73stlS7Ny4LBiGrZsh1+yyjsXPEu8Ie2OwPJXFfH0G6gL/CFp
         yh5pbM0O2r3io122fvhi7UwoBPm4vZBe+rp1bG1rOhiKof3RWiIZqeqm8KETb+cFGaX+
         CRuA==
X-Gm-Message-State: ANhLgQ3hYfwmuupWq965NHAQUGbGGqaiqxryd4Oq/rbnzFNaG62OzYDq
        xEW6rgazftZcwhl75tZjKpS/g64r9Cej7cP7RBZjdA==
X-Google-Smtp-Source: ADFU+vs9ry2XYsgdK4314uO1jxo2AlhedtLaVepDUfyzcjwnRtJPqD/97uig5eK0Wc99bItxHnujbp8fjRWMCAR3xjM=
X-Received: by 2002:aca:f541:: with SMTP id t62mr5236270oih.172.1584682212108;
 Thu, 19 Mar 2020 22:30:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200317065452.236670-1-saravanak@google.com> <CAGETcx-uZ3YJHCYqFm3so8-woTvL3SSDY2deNonthTetcE+mXQ@mail.gmail.com>
 <20200319073927.GA3442166@kroah.com>
In-Reply-To: <20200319073927.GA3442166@kroah.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Thu, 19 Mar 2020 22:29:36 -0700
Message-ID: <CAGETcx-3oeJOvpCYj==RJuBU9HP8F0ZNr0YLvUHGHF52b=F7HA@mail.gmail.com>
Subject: Re: [PATCH v1 0/6] Fix device links functional breakage in 4.19.99
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 19, 2020 at 12:39 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Mar 18, 2020 at 12:10:43PM -0700, Saravana Kannan wrote:
> > On Mon, Mar 16, 2020 at 11:54 PM Saravana Kannan <saravanak@google.com> wrote:
> > >
> > > As mentioned in an earlier email thread [1], 4.19.99 broke the ability
> > > to create stateful and stateless device links between the same set of
> > > devices when it pulled in a valid bug fix [2]. While the fix was valid,
> > > it removes a functionality that was present before the bug fix.
> > >
> > > This patch series attempts to fix that by pulling in more patches from
> > > upstream. I've just done compilation testing so far. But wanted to send
> > > out a v1 to see if this patch list was acceptable before I fixed up the
> > > commit text format to match what's needed for stable mailing list.
> > >
> > > Some of the patches are new functionality, but for a first pass, it was
> > > easier to pull these in than try and fix the conflicts. If these patches
> > > are okay to pull into stable, then all I need to do is fix the commit
> > > text.
> >
> > I took a closer look at all the patches. Everyone of them is a bug fix
> > except Patch 4/6. But Patch 4/6 is a fairly minimal change and I think
> > it's easier/cleaner to just pick it up too instead of trying to
> > resolve merge conflicts in the stable branch.
> >
> > 1/6 - Fixes what appears to be a memory leak bug in upstream.
> > 2/6 - Fixes error in initial state of the device link if it's created
> > under some circumstances.
> > 3/6 - Fixes a ref count bug in upstream. Looks like it can lead to memory leaks?
> > 4/6 - Adds a minor feature to kick off a probe attempt of a consumer
> > 5/6 - Fixes the break in functionality that happened in 4.19.99
> > 6/6 - Fixes bug in 5/6 (upstream bug)
> >
> > Greg
> >
> > Do these patches look okay for you to pull into 4.19 stable? If so,
> > please let me know if you need me to send v2 with commit fix up.
> >
> > The only fix up needed is to these patches at this point is changing
> > "(cherry picked from commit ...)" with "[ Upstream commit ... ]". The
> > SHAs themselves are the correct SHAs from upstream.
>
> These all look good to me, now all queued up, thanks.

Awesome, thanks!

-Saravana
