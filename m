Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B5237ED97
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 00:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387784AbhELUj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 16:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377957AbhELTJu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 15:09:50 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0BEC06138C
        for <stable@vger.kernel.org>; Wed, 12 May 2021 12:07:03 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id y9so30960190ljn.6
        for <stable@vger.kernel.org>; Wed, 12 May 2021 12:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KxJ9uaXZvbS8c8+acrei5sFlVZujSQwdEe/iJoxF4ZA=;
        b=P27WLfqGIynRw2dzKu+xvzPSmKAQhoUYokRc7EJu4KrmvJfkq6hmutzpKRYhROi/D/
         KkwmSDhJDB6Puxe+9afp2p//vv/Xt10XWQEiOIhEAhVBAumzN//+a8VUUwvTa8xQUCp2
         7PpJD/X+l8kj5Ee6IMn2CUbwvXvSrdcpn0SUqWVhTe5rkdJNc94KbC8PKO/Hxaf/tVEX
         ajhHMJOegtSGMaabhWmj+vH/jieKwRyE9vfhtcCnDhneUW7Q6VyrY1umSS0zxeCkzG+W
         9yCKEi/2YMyqGNc34xi0nrwUMqeaw1XpKpSIAwjQVWB1hYb1HElAycDJB+1o+8lom/uX
         sHmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KxJ9uaXZvbS8c8+acrei5sFlVZujSQwdEe/iJoxF4ZA=;
        b=D4LLycPyjEXIdD3MGAl5D82sShS9VJ2Ryun2XHeMuBIiqXXOmWrZ9n6J7LHDDfY3+D
         zbJLceG99lXw19mAfRNPnlGyWTDuMgLvBt4y939t/6+CG7rG8L53ik7VsGDtCcZ6KG5S
         ts4RD348Ie8TWk1z+Un/ugP3+LkXzcGrBYSflR4ZiIHEnjSqIkK7qL/IqQqj+3PymCqc
         MaYtjxUeFS4rd+h1lYMpRT8mLadMd7itV+IGn8gHEWILmk0qhqE2F3Y6FxdL4Dvly6b9
         DJ4qtcZ//VRLEFrQXHOC+/3ox/HdTYNqEEBqIPyASD1ScBep6SJ3rkiKDxvOlUAR4n2I
         +9uQ==
X-Gm-Message-State: AOAM532m/8coLM48iIH3LF+EBTQixf45any0LK7blJReSqjA/KNMtc+D
        VlTMAvj73W9+0RxEVmdgbyHUfpdZA7wzIqOpLN1I8w==
X-Google-Smtp-Source: ABdhPJyrLTsEjIoDfv08kxQgbArTSDCnmyLQqsDffIooqEoY0KuxYulP9+OV8dVDEqPvFYKid1V/Dgc8TisvRXvHp0M=
X-Received: by 2002:a2e:8681:: with SMTP id l1mr30394356lji.494.1620846421446;
 Wed, 12 May 2021 12:07:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200925161916.204667-1-pgonda@google.com> <20201005130729.GD827657@kroah.com>
 <CAMkAt6qgbO4CqQVxLKU_Tf6bN3numdJHdkc-rck26V68+Y1j9Q@mail.gmail.com>
 <alpine.DEB.2.23.453.2010061100120.51232@chino.kir.corp.google.com>
 <X/MRdPz/POas6FFf@kroah.com> <ef6fed57-cbb7-ed8b-6925-cea0fd55df85@google.com>
 <X/QAGHyUfBcsIChZ@kroah.com> <1da58ef-5995-a928-9b14-f0c064ea64fe@google.com>
In-Reply-To: <1da58ef-5995-a928-9b14-f0c064ea64fe@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Wed, 12 May 2021 13:06:49 -0600
Message-ID: <CAMkAt6p2qT9V8jipWSxBbHPP2WN7KR0b=A3eDgFmD33x_GLoCg@mail.gmail.com>
Subject: Re: [PATCH 00/30 for 5.4] Backport unencrypted non-blocking DMA allocations
To:     David Rientjes <rientjes@google.com>
Cc:     Greg KH <greg@kroah.com>, stable@vger.kernel.org,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Christoph Hellwig <hch@lst.de>, nsaenzjulienne@suse.de,
        geert@linux-m68k.org, sjhuang@iluvatar.ai
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reviving this thread.

This is repro-able on 5.4 LTS guests as long as
CONFIG_DEBUG_ATOMIC_SLEEP is set. I am not sure if this can be
classified as a regression or not since I think this issue would have
shown up on all SEV guests using NVMe boot disks since the start of
SEV. So it seems like a regression to me.

Currently I know of Ubuntu20.04.01 being based on 5.4. I have also
sent this backport to 4.19 which is close to the 4.18 which RHEL8 is
based on. I do not know what prevents the distros from using a more
recent kernel but that seems like their choice. I was just hoping to
get these backport submitted into LTS to show the issue and help any
distro wanting to backport these changes to prevent it. Greg is there
more information I can help provide as justification?

On Mon, Jan 4, 2021 at 11:38 PM David Rientjes <rientjes@google.com> wrote:
>
> On Tue, 5 Jan 2021, Greg KH wrote:
>
> > > I think it can be considered a bug fix.
> > >
> > > Today, if you boot an SEV encrypted guest running 5.4 and it requires
> > > atomic DMA allocations, you'll get the "sleeping function called from
> > > invalid context" bugs.  We see this in our Cloud because there is a
> > > reliance on atomic allocations through the DMA API by the NVMe driver.
> > > Likely nobody else has triggered this because they don't have such driver
> > > dependencies.
> > >
> > > No previous kernel version worked properly since SEV guest support was
> > > introduced in 4.14.
> >
> > So since this has never worked, it is not a regression that is being
> > fixed, but rather, a "new feature".  And because of that, if you want it
> > to work properly, please use a new kernel that has all of these major
> > changes in it.
> >
>
> Hmm, maybe :)  AMD shipped guest support in 4.14 and host support in 4.16
> for the SEV feature.  In turns out that a subset of drivers (for Google,
> NVMe) would run into scheduling while atomic bugs because they do
> GFP_ATOMIC allocations through the DMA API and that uses
> set_memory_decrypted() for SEV which can block.  I'd argue that's a bug in
> the SEV feature for a subset of configs.
>
> So this never worked correctly for a subset of drivers until I added
> atomic DMA pools in 5.7, which was the preferred way of fixing it.  But
> SEV as a feature works for everybody not using this subset of drivers.  I
> wouldn't say that the fix is a "new feature" because it's the means by
> which we provide unencrypted DMA memory for atomic allocators that can't
> make the transition from encrypted to unecrypted during allocation because
> of their context; it specifically addresses the bug.
>
> > What distro that is based on 5.4 that follows the upstream stable trees
> > have not already included these patches in their releases?  And what
> > prevents them from using a newer kernel release entirely for this new
> > feature their customers are requesting?
> >
>
> I'll defer this to Peter who would have a far better understanding of the
> base kernel versions that our customers use with SEV.
>
> Thanks
