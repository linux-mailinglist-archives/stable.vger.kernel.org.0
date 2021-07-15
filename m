Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46FA23CADF5
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 22:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236166AbhGOUdk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 16:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235390AbhGOUdi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 16:33:38 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6F9C06175F
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 13:30:44 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id k27so9957747edk.9
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 13:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PJB6bFUtPYznQ0yKCSHqIAXQQmX0AjFyPr7ovN9miL8=;
        b=Im67BmxGxaMaPgVZhBtO/BIponTjCjCA8fnBqF5myRv3IEaMlywOavRrdFVVXwihfd
         1x7INcdl/qnBofe5TRIpFSAnpHTP0PHsADzX/kg42ESv6yTv7BFwO+OL+hQ5cdGFPzOa
         FofKuuo6LD+HNSYI2gAonm+O3uKpXzArFQuS8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PJB6bFUtPYznQ0yKCSHqIAXQQmX0AjFyPr7ovN9miL8=;
        b=ihf7UnqSdGo+9fEut9LwPp300KdqhGhX5EtzwuFgFWb3a/XPGtu8c42O3PX8ubZvy7
         SX7FYeH/UAQX7SCqsB4h2or5H96u3gVlz5ZQQMdsUk6UP0lWdvSPqcKyGY/0/fePaXOf
         4Z74Tvd+KAU8BzG73rPIauudL1Fwa2k6zbBm3Cid+qz2u9435Y9pB+EubJfULiLNyhb3
         +UqqRcog843z2k6qWIVW0m3q4F6YnHouxQenSa2mOZkDUsX3SXGnjsIpRVbigJHnnBrm
         bHhKKHM5glAHtlRZqC48Oe2x/ROlNfiHpd3tKOkrhop7E1Gn+BpbMGAu6jCV0SJwLFTV
         nYAg==
X-Gm-Message-State: AOAM530sCTROJcsyEug9Lwa1NvTQbiG6TK6ZOqM8yXJZrz+2yEYieCY+
        dgR3yZ47snYaZjOT6tbVJzHwk4tbjBXgW/yo94FJ6g==
X-Google-Smtp-Source: ABdhPJyVmRgzPKPuJ0ImlIegvXO0ivwB1RslqUW40ESA44zFiDHrhHOADTpL68BYk67zIMoEiE/LTB7Pz/CyB94RiK0=
X-Received: by 2002:aa7:dbc3:: with SMTP id v3mr9719975edt.63.1626381043367;
 Thu, 15 Jul 2021 13:30:43 -0700 (PDT)
MIME-Version: 1.0
References: <cki.8AA4B7C8B2.MU36FLBY8R@redhat.com> <CA+tGwnmVdw=B5rnz3QmHeu3jGdHr36yf4MJHR5c11w09tP9Amw@mail.gmail.com>
 <YPBw8SQ/oQQXfguv@kroah.com>
In-Reply-To: <YPBw8SQ/oQQXfguv@kroah.com>
From:   Justin Forbes <jmforbes@linuxtx.org>
Date:   Thu, 15 Jul 2021 15:30:32 -0500
Message-ID: <CAFxkdArnhDFD4rH4__DU0tKxxBd_3s4vGRVeXpZuunxU1u=m6Q@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=E2=9D=8C_FAIL=3A_Test_report_for_kernel_5=2E13=2E2_=28stable=2D?=
        =?UTF-8?Q?queue=2C_ee00910f=29?=
To:     Greg KH <greg@kroah.com>
Cc:     Veronika Kabatova <vkabatov@redhat.com>,
        CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 15, 2021 at 12:31 PM Greg KH <greg@kroah.com> wrote:
>
> On Thu, Jul 15, 2021 at 02:51:15PM +0200, Veronika Kabatova wrote:
> > On Thu, Jul 15, 2021 at 2:50 PM CKI Project <cki-project@redhat.com> wrote:
> > >
> > >
> > > Hello,
> > >
> > > We ran automated tests on a recent commit from this kernel tree:
> > >
> > >        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > >             Commit: ee00910f75ff - powerpc/powernv/vas: Release reference to tgid during window close
> > >
> > > The results of these automated tests are provided below.
> > >
> > >     Overall result: FAILED (see details below)
> > >              Merge: OK
> > >            Compile: FAILED
> > >
> > > All kernel binaries, config files, and logs are available for download here:
> > >
> > >   https://arr-cki-prod-datawarehouse-public.s3.amazonaws.com/index.html?prefix=datawarehouse-public/2021/07/15/337656806
> > >
> > > We attempted to compile the kernel for multiple architectures, but the compile
> > > failed on one or more architectures:
> > >
> > >            ppc64le: FAILED (see build-ppc64le.log.xz attachment)
> > >             x86_64: FAILED (see build-x86_64.log.xz attachment)
> > >
> >
> > Hi, looks to be introduced by
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=queue/5.13&id=07d407cc1259634b3334dd47519ecd64e6818617
>
> Are you sure?  I fixed a different build bug in that area a few hours
> ago, if you rebuild the tree it should be resolved.
>
> If not, please let me know.
>

Seeing the same issue here, there is nothing new in the tree.

Justin
