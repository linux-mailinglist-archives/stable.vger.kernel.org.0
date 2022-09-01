Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD055A9B6A
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 17:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbiIAPUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 11:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233758AbiIAPUA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 11:20:00 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A888FE2;
        Thu,  1 Sep 2022 08:19:53 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id 67so18095396vsv.2;
        Thu, 01 Sep 2022 08:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=SiNEe1T6tIZZaB/fQAnCMzDO9razDORz9dh9TLLjdxM=;
        b=K+1rRZWR85MvucMTAQMD5VXjqu4rZpNAWiva0cmsR5mKelC6M+B3/F3p7V+V8fL6qN
         MpCsmXg6DBh4eJB63PW8ffAALtovHN4IHm5sn5DY+zepS+pfFMn8XLjhLIahnH211lVT
         jIIBFq23nh5S0EDaiXM9ACB0AWnNdlaIhtGVS7IkMguE6MG+xyuhi86Y7O5T9y74sWd0
         SsH5viw6ffCOTNDGPPnalC6dzZCrytQyeBG6Bp4Mgw+2SIJiYGOgiPOX+HIvZu8iUvFj
         0sq7VYD49hRfs0UkzoSWspPXSD4DgKYpReUy8Ry9OBV2EkZsapXgpb/aWsuWNdky8K7m
         sYVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=SiNEe1T6tIZZaB/fQAnCMzDO9razDORz9dh9TLLjdxM=;
        b=PrF1BMbrXnSGW6Y75ycF+IgpjzJmlOJkG12rA7XRJdF0h2LbWSrCnK7A97RaJPXfmo
         h9tXJtnpIgJzWYQ0MMX6ARkN6CNwiV5wUaGRb+b6YV/82Om/u78E5gXLexDyB7gFalxB
         vhxKJpajNAN4wFF7SITv6ULXArvCWOqyTo0QjcxyGqvkYMKz8fbLa4IGYmi1n/0bJHgA
         p6T8nKT6KSVZB6MWP5p+OC/NmskED4lrhIkkjT4ghkYOT5mUyYwxo4S4/n+dpN7pYzt6
         jxUPrY6uhz13FHewwDCpbWDvXF2HLhRhi0wIOPa8bi2DXE20UJoReFFrsLVPlCYUmMlv
         Yspg==
X-Gm-Message-State: ACgBeo1GmHQf5pNXyuRpCMHXJmNf0/pW6YrVNWH5PiVj0HhShOnUfDSC
        B7ujBlE3/KoMfUWOScOMvTOIi4zXkp44Ca4yvQQ=
X-Google-Smtp-Source: AA6agR6B3udINLIqOpSb6q/M+L13xru6eM/q6S3bySQeYD5Wx47mjcwRw/u41OQHLEt9eJKnkz00n9l48DjPTqk0ayY=
X-Received: by 2002:a67:a649:0:b0:390:88c5:6a91 with SMTP id
 r9-20020a67a649000000b0039088c56a91mr9259872vsh.3.1662045592576; Thu, 01 Sep
 2022 08:19:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220901054854.2449416-1-amir73il@gmail.com> <20220901054854.2449416-7-amir73il@gmail.com>
 <CABEBQikqj+Uwae0XMHSbU7FVcrTR7cMb6zgbiRHC0PwFfB7+qw@mail.gmail.com>
 <CAOQ4uxhNV=-nVO_ezP=Lc42+Q+A+wxdiCBqhVQz8qVkBJba1iA@mail.gmail.com>
 <YxB+QmIwCgMtj1r+@kroah.com> <CAOQ4uxjxq346_dwEhrTm7_WW8nDqaQxNUCfVqDwOYAJGtmtpQQ@mail.gmail.com>
 <YxCIvDAMzWdQrpEh@kroah.com> <CAOQ4uxh0We9+56EJUSw_NAqd_TLLV1v0yvyY=dj645H_4M_AyQ@mail.gmail.com>
 <YxCulVd4dESBjCUM@kroah.com>
In-Reply-To: <YxCulVd4dESBjCUM@kroah.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 1 Sep 2022 18:19:41 +0300
Message-ID: <CAOQ4uxhZyCHU1LweuLGYRK9z3SvycmpR+B6XFE=_G0ZVkY7VgA@mail.gmail.com>
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

On Thu, Sep 1, 2022 at 4:07 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Sep 01, 2022 at 03:37:59PM +0300, Amir Goldstein wrote:
> > On Thu, Sep 1, 2022 at 1:26 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Thu, Sep 01, 2022 at 01:16:33PM +0300, Amir Goldstein wrote:
> > > > On Thu, Sep 1, 2022 at 12:41 PM Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > On Thu, Sep 01, 2022 at 12:30:13PM +0300, Amir Goldstein wrote:
> > > > > > On Thu, Sep 1, 2022 at 12:04 PM Frank Hofmann <fhofmann@cloudflare.com> wrote:
> > > > > > >
> > > > > > > On Thu, Sep 1, 2022 at 6:49 AM Amir Goldstein <amir73il@gmail.com> wrote:
> > > > > > > >
> > > > > > > > From: Dave Chinner <dchinner@redhat.com>
> > > > > > > >
> > > > > > > > commit 9a5280b312e2e7898b6397b2ca3cfd03f67d7be1 upstream.
> > > > > > > >
> > > > > > > > [backport for 5.10.y]
> > > > > > >
> > > > > > > Hi Amir, hi Dave,
> > > > > > >
> > > > > > > I've got no objections to backporting this change at all. We've been
> > > > > > > using the patch on our internal 5.15 tracker branch happily for
> > > > > > > several months now.
> > > > > > >
> > > > > > > Would like to highlight though that it's currently not yet merged in
> > > > > > > linux-stable 5.15 branch either (it's in 5.19 and mainline alright).
> > > > > > > If this gets queued for 5.10 then maybe it also should be for 5.15 ?
> > > > > > >
> > > > > >
> > > > > > Hi Frank,
> > > > > >
> > > > > > Quoting from my cover letter:
> > > > > >
> > > > > > Patches 6-7 in this 5.10.y update have not been applied to 5.15.y yet.
> > > > > > I pointed Leah's attention to these patches and she said she will
> > > > > > include them in a following 5.15.y update.
> > > > >
> > > > > And as you know, this means I can't take this series at all until that
> > > > > series is ready, so to help us out, in the future, just don't even send
> > > > > them until they are all ready together.
> > > > >
> > > >
> > > > What?
> > > >
> > > > You cannot take backports to 5.10.y before they are applied to 5.15.y?
> > > > Since when?
> > >
> > > Since always.
> > >
> > > Why would you ever want someone to upgrade from an older tree (like
> > > 5.10.y) to a newer one (5.15.y) and have a regression?
> > >
> >
> > That is certainly not a goal when backporting fixes to 5.10.y, but it
> > can happen as a by-product of the decentralized nature of testing
> > backports.
> >
> > But it did not bother you when xfs patches were applied to 5.4.y and
> > no xfs patches at all applied to 5.10.y for two years?
>
> I've been bothered by xfs patches for so long that really, I didn't care
> as the maintainers didn't seem bothered either :)
>
> But now that everything is working properly, let's do it correctly
> please.
>
> > > So we always try to make sure patches are always applied to newer trees
> > > first.  Yes, sometimes we miss this and make mistakes, but it's always
> > > been this way and we fix that whenever it happens accidentally.
> > >
> >
> > That is my intention.
> > I will try to keep to that rule in the future.
> > I would have waited for the patches to land in 5.15.y, but
> > Leah got distracted by another task so I decided to not wait,
> > knowing that the patches are already in her queue.
> >
> > > I'll drop this series from my review queue for now until the 5.15.y
> > > series shows up.
> >
> > Please don't drop the series.
> > Please drop patches 6-7 if you must
> > Or if you insist I can re-post patches 1-5.
>
> Please resend as just the correct ones that you want so I know what to
> pick exactly.
>

Posted v3 with patches 1-5.

Thanks,
Amir.
