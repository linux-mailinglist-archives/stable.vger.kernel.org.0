Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1DA56150F
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 10:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiF3I27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 04:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233986AbiF3I2w (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 04:28:52 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2585921D;
        Thu, 30 Jun 2022 01:28:50 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id q28so5329123vsp.7;
        Thu, 30 Jun 2022 01:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c909AEUy9E7Zbz41KLBzO/9DCIqSP3ZLzaMiB7c+/cM=;
        b=BfG6CJM5QG4nMCCDyZHuGrZEmWOl87fJf/cIbT8DhuEf2YQn/YKreQj60uAkqdHpAN
         xTToDxhV6/C1Znm5tu5sYwmCgUJJFgRJYe6fg2oej8tMpV3SjX4Z+SZ+AsA5W73SzBSO
         yrOQ1kHscNzPnAp1X/N9HpH3j5Kd6RTs6Mc3ChFd/TlInN4FSmoQGPcwrgHq/5OHNFth
         n5mC1qFmDyB5wHed4zf6bXwGoebfq02vgZRg0+zHVVsQcohcAT6iWsqsp7T1J/S6obU9
         LzzbEvcIbPimHmThDyzx2SFp9hBoNpkvRgJv8cGRX8r6raqkWEDr+lZMt1/GbS+G1dx1
         acrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c909AEUy9E7Zbz41KLBzO/9DCIqSP3ZLzaMiB7c+/cM=;
        b=wqnz3fAkXRIvEdRl63E5PpSc7iz1QoRFXCFQknWVuu8GHsI2B/+xa81xLhdtW9gz4t
         ITLfytaygMAYglqV0QFUgtwhRq7kaMcsA3zrLuKUQMWW4tu2wiKu66daK0GqkMUgXP9M
         TrbAMbxvl0lLWIUuyzTZ+mVeELxhsouNgaIhiv8UJjmLdCpWRaIRIcf6ibEhd2J/xbDi
         s1r69+s7tDPG5e0q2Xl4okDsPPtgA0rKYuP6175AmUKqqmb4cfRNmcRk0mJ5PN9oNF5b
         mr5eqfkvEmJqupqx6xTJdu34NcOtXQa76E//QM0/PwPxw7QQ0CO7PYdidib4XjBTNYHc
         XR0w==
X-Gm-Message-State: AJIora+3o12N8QXhS233JOde3GURIqY3lkkODOvyAu5a8TszrFXwFeVt
        D8uhHQ/0sreSap7LcPSp1ShtmYhcwEmPbstS5GM=
X-Google-Smtp-Source: AGRyM1vLn1ssULQZUxL3vL9rR/NOzeZSjqgzJRHDCrQNAbj7JQENrYjkz8KFhn45cXkVc90dpK9HvKQj4T35vmKtaUs=
X-Received: by 2002:a67:fa01:0:b0:354:3136:c62e with SMTP id
 i1-20020a67fa01000000b003543136c62emr6531798vsq.2.1656577729251; Thu, 30 Jun
 2022 01:28:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220630054321.3008933-1-amir73il@gmail.com> <Yr1QSpmzHRyH4heo@kroah.com>
In-Reply-To: <Yr1QSpmzHRyH4heo@kroah.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 30 Jun 2022 11:28:37 +0300
Message-ID: <CAOQ4uxioAJ5dLS53rJbJOHgtyYjHtUv-2_WKruQKfqJZe-1g4A@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add Amir as xfs maintainer for 5.10.y
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        stable <stable@vger.kernel.org>
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

On Thu, Jun 30, 2022 at 10:27 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Jun 30, 2022 at 08:43:21AM +0300, Amir Goldstein wrote:
> > This is an attempt to direct the bots and human that are testing
> > LTS 5.10.y towards the maintainer of xfs in the 5.10.y tree.
> >
> > This is not an upstream MAINTAINERS entry and 5.15.y and 5.4.y will
> > have their own LTS xfs maintainer entries.
> >
> > Update Darrick's email address from upstream and add Amir as xfs
> > maintaier for the 5.10.y tree.
> >
> > Suggested-by: Darrick J. Wong <djwong@kernel.org>
> > Link: https://lore.kernel.org/linux-xfs/Yrx6%2F0UmYyuBPjEr@magnolia/
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >
> > Greg,
> >
> > We decided to try and fork MAINTAINERS.
> >
> > I don't know if this was attempted before and I don't know if you
> > think that is a good idea, but the rationale is that at least some
> > of the scripts that report bugs on LTS, will be running get_maintainer.pl
> > on the LTS branch they are testing.
> >
> > The scripts that run get_maintainer.pl on master can be tought to
> > do the right thing for LTS reporting.
> > This seems easier and more practical then teaching the scripts to
> > parse LTS specific entries in upstream MAINTAINERS.
> >
> > You have another patch like that coming fro Leah for 5.15.y.
> >
> > Thanks,
> > Amir.
> >
> >  MAINTAINERS | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 7c118b507912..4d10e79030a9 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -19246,7 +19246,8 @@ F:    arch/x86/xen/*swiotlb*
> >  F:   drivers/xen/*swiotlb*
> >
> >  XFS FILESYSTEM
> > -M:   Darrick J. Wong <darrick.wong@oracle.com>
> > +M:   Amir Goldstein <amir73il@gmail.com>
> > +M:   Darrick J. Wong <djwong@kernel.org>
> >  M:   linux-xfs@vger.kernel.org
> >  L:   linux-xfs@vger.kernel.org
> >  S:   Supported
>
> I'll apply this, but really, no one will ever notice it.
>
> All new patches, and work, goes on on Linus's tree and you have to
> submit matches for it to be considered for older stable kernels as you
> know.  So there's not much for old MAINTAINERS entries here.
>
> But hey, I could be wrong let's try it and see what happens :)

Just to be clear, this meant not for CCing stable xfs maintainers on
fix patches that developers send upstream.

This is only so bots running on LTS and distro kernels find xfs bugs
are advised to CC the xfs stable maintainers.

Thanks,
Amir.

P.S. You have an xfs backport series for both 5.10 and 5.15
in your inbox...
