Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD715A96FE
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 14:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbiIAMiY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 08:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiIAMiX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 08:38:23 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8700120B8;
        Thu,  1 Sep 2022 05:38:11 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id 67so17575561vsv.2;
        Thu, 01 Sep 2022 05:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=manUgzUchMr/kk2iObdD1tVGtQFlRaB7HSsDXdMMG/8=;
        b=I/2mKscmr7L5fXvEudZ/1uzdbH26HSPc2H85U7npxYotkRLdgzIneX5nJy4QTRHm71
         9HoX40yRw63oNdxK/GbUo7ufxc4LkFOyjQ33ioiMrM9LGy4hnhM8KqVRyWTRCklgxlHC
         XF4xtaBAGnV7z/4OT6yngVRRxNHxxaxzwMAo7Q+8kegCIf5M64bVWeD1FbRLhcXQbL5X
         if23Mv4Xs+M9mav+DN3ocF1P3mVcXZN2Pg20grOXdZMBdqHm9urNORU/T5eLs0ibqn3K
         ERBTpN3aKzkMlNMt1eoBKb4XP50vuzUok8RuQ1IJANDJWowvw3D353QW7FDArvBn9nkX
         DI3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=manUgzUchMr/kk2iObdD1tVGtQFlRaB7HSsDXdMMG/8=;
        b=tIav4gKh/QnCu7mRKdu+HrxNEb96cCZQZRwNOjsT6VOEOqDx4uXsC3Ji01vvTz2eDG
         yy59mfNl+2eGns+xeOKEoEdENMlaiWZMTxuvGorue1q22kzlids2HKlPE+C50RIEvba9
         UV2D3PkMiOS0eY0o0mLsQqxAeUHmGVc1aJCuo8KFdbPWBgu5Guwr+vRmc9g20XMJHlI/
         rjOhq2AvqnBmGTvJfyvB4gLieX19irmEzufDsuppS3ALZxQPvefuNWssio5CH9uSzTtR
         WL4s2AAUvYUknSfE+1UsQVz0zwleSfyr5D/FColi2dCLNDMwu8xUAHx26HHC5QUTPRhV
         gOzQ==
X-Gm-Message-State: ACgBeo0wzwfu1aQ2/Vn1Yf7IWHslnQhUmYX32oGU+/c+ogvIXxy/9dno
        VAS2l9iAHkuIHW89WgXXwBHMFOEbdRC53wJpZUk=
X-Google-Smtp-Source: AA6agR7OMOMrQ0S5oAiOPh2AE2LxJ35YD/csQ7Sh/OhjTWjb4/+06mA1/BieVDvxIN89mLfRtb3kvVRKZ08YyEllZJc=
X-Received: by 2002:a67:b90f:0:b0:390:cb3e:efb8 with SMTP id
 q15-20020a67b90f000000b00390cb3eefb8mr7522424vsn.71.1662035890462; Thu, 01
 Sep 2022 05:38:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220901054854.2449416-1-amir73il@gmail.com> <20220901054854.2449416-7-amir73il@gmail.com>
 <CABEBQikqj+Uwae0XMHSbU7FVcrTR7cMb6zgbiRHC0PwFfB7+qw@mail.gmail.com>
 <CAOQ4uxhNV=-nVO_ezP=Lc42+Q+A+wxdiCBqhVQz8qVkBJba1iA@mail.gmail.com>
 <YxB+QmIwCgMtj1r+@kroah.com> <CAOQ4uxjxq346_dwEhrTm7_WW8nDqaQxNUCfVqDwOYAJGtmtpQQ@mail.gmail.com>
 <YxCIvDAMzWdQrpEh@kroah.com>
In-Reply-To: <YxCIvDAMzWdQrpEh@kroah.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 1 Sep 2022 15:37:59 +0300
Message-ID: <CAOQ4uxh0We9+56EJUSw_NAqd_TLLV1v0yvyY=dj645H_4M_AyQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 v2 6/7] xfs: reorder iunlink remove operation in xfs_ifree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Frank Hofmann <fhofmann@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 1, 2022 at 1:26 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Sep 01, 2022 at 01:16:33PM +0300, Amir Goldstein wrote:
> > On Thu, Sep 1, 2022 at 12:41 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Thu, Sep 01, 2022 at 12:30:13PM +0300, Amir Goldstein wrote:
> > > > On Thu, Sep 1, 2022 at 12:04 PM Frank Hofmann <fhofmann@cloudflare.com> wrote:
> > > > >
> > > > > On Thu, Sep 1, 2022 at 6:49 AM Amir Goldstein <amir73il@gmail.com> wrote:
> > > > > >
> > > > > > From: Dave Chinner <dchinner@redhat.com>
> > > > > >
> > > > > > commit 9a5280b312e2e7898b6397b2ca3cfd03f67d7be1 upstream.
> > > > > >
> > > > > > [backport for 5.10.y]
> > > > >
> > > > > Hi Amir, hi Dave,
> > > > >
> > > > > I've got no objections to backporting this change at all. We've been
> > > > > using the patch on our internal 5.15 tracker branch happily for
> > > > > several months now.
> > > > >
> > > > > Would like to highlight though that it's currently not yet merged in
> > > > > linux-stable 5.15 branch either (it's in 5.19 and mainline alright).
> > > > > If this gets queued for 5.10 then maybe it also should be for 5.15 ?
> > > > >
> > > >
> > > > Hi Frank,
> > > >
> > > > Quoting from my cover letter:
> > > >
> > > > Patches 6-7 in this 5.10.y update have not been applied to 5.15.y yet.
> > > > I pointed Leah's attention to these patches and she said she will
> > > > include them in a following 5.15.y update.
> > >
> > > And as you know, this means I can't take this series at all until that
> > > series is ready, so to help us out, in the future, just don't even send
> > > them until they are all ready together.
> > >
> >
> > What?
> >
> > You cannot take backports to 5.10.y before they are applied to 5.15.y?
> > Since when?
>
> Since always.
>
> Why would you ever want someone to upgrade from an older tree (like
> 5.10.y) to a newer one (5.15.y) and have a regression?
>

That is certainly not a goal when backporting fixes to 5.10.y, but it
can happen as a by-product of the decentralized nature of testing
backports.

But it did not bother you when xfs patches were applied to 5.4.y and
no xfs patches at all applied to 5.10.y for two years?

> So we always try to make sure patches are always applied to newer trees
> first.  Yes, sometimes we miss this and make mistakes, but it's always
> been this way and we fix that whenever it happens accidentally.
>

That is my intention.
I will try to keep to that rule in the future.
I would have waited for the patches to land in 5.15.y, but
Leah got distracted by another task so I decided to not wait,
knowing that the patches are already in her queue.

> I'll drop this series from my review queue for now until the 5.15.y
> series shows up.

Please don't drop the series.
Please drop patches 6-7 if you must
Or if you insist I can re-post patches 1-5.

Thanks,
Amir.
