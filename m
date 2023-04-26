Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49776EF15C
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 11:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239819AbjDZJoo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Apr 2023 05:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239464AbjDZJoo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 05:44:44 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80BE10EB
        for <stable@vger.kernel.org>; Wed, 26 Apr 2023 02:44:42 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3f09b4a156eso45953575e9.3
        for <stable@vger.kernel.org>; Wed, 26 Apr 2023 02:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682502281; x=1685094281;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pnSAoK/rEA3LcwvDhDtlDKtvSUZs6e8uYw0vVNixLI8=;
        b=oWT30rmc+tmrczX/SmQBHk55Bn5EhEon87rzqiEnUGLcTSwBciID1vZEWr0sCsRDQv
         1Vug4rkoJS69tQDqPvycpHPWeG/JO0OSAUuowH0uBrirPLtH2lZw8fyUOKRMinPEUAk5
         Blf12wSwR8jY0qSwdt911YWelNILtoJcaviQYef2bYs5OQ5MCEG1lPXmnKEoLCMwJj2E
         ZOJXLx8o7g0v94gaoBMCVYohHo+2/aDrRNPsa8BZLspTSBy4lHLLFiylgyE4Eo+AqGX6
         dM0ubdNKPUD5HkZ6MibrrSQwZ6hYuNpACmEIttpja64s23sLkC+CySp/u31m6z/+lo9X
         oENA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682502281; x=1685094281;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pnSAoK/rEA3LcwvDhDtlDKtvSUZs6e8uYw0vVNixLI8=;
        b=Rlejyrm/z9NkesXc1axX6MXlWR8+7fn+xvseCEl7xgONVqoa4gh59sHeFA3MOwU82t
         S+HUiNvb8uM+vTHbJ40LiYVedNy6KQF4OuNPVbf0EjquuBHAgeX4OHDrJ5+FSSouqR+4
         +AyGwVtv0wmvlJT+A/kMdnLUVN4kuTI/oBmKNDe6guRRhA7EoPCzR8bcLLMyip4PV+sC
         njWiDmeE8rcyjHhlteMeMXJI6/hwu8MKCFHfq99F/PMzBIVjsjiPxuahu2xFfCLZ0dYX
         96aYoLbTgvF4VcVcnVbDPe4RVov25mM6bOz6lFJl9KvLjCvmMn5rjVpqqi1sS85UuVXx
         BtaA==
X-Gm-Message-State: AAQBX9c9gDgLS3cDfowk5IsXMbNWqxErQ1yI8TTHK8R1g7GMxBS37hHG
        3+KsI2j2MpljMXl4BLDOthb4v/5iXgKecS4NM2o=
X-Google-Smtp-Source: AKy350ZWfF9tmAclJ0iN+XdJN1cuENb1abYOhxExKD10rZnCdW2HHC/L06+17QgHB3WzazGcU2+8zIae6rTASv7/hDg=
X-Received: by 2002:a05:600c:2295:b0:3f1:92aa:4eb8 with SMTP id
 21-20020a05600c229500b003f192aa4eb8mr11414934wmf.16.1682502280982; Wed, 26
 Apr 2023 02:44:40 -0700 (PDT)
MIME-Version: 1.0
References: <CADBnMvgH1H_+WNSdQ=hJp15v4jh0nwFZVkggeiCSWaFHtzORJQ@mail.gmail.com>
 <ZEfoC9UDzniw6mo_@kroah.com> <CADBnMviZ4Q3LpUUfnGYrM6aiPQFLD6ohC1qjetJp0RcDGTTYsg@mail.gmail.com>
 <2023042519-powdery-passerby-213a@gregkh>
In-Reply-To: <2023042519-powdery-passerby-213a@gregkh>
From:   Kristof Havasi <havasiefr@gmail.com>
Date:   Wed, 26 Apr 2023 11:44:30 +0200
Message-ID: <CADBnMviE3-DZhjO1iLgoAfBjFGFnyNTTHpLUobpAQdF5=Rt_3A@mail.gmail.com>
Subject: Re: Does v5.4 need CVE-2022-3566 and CVE-2022-3567 patches
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 25 Apr 2023 at 20:08, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Apr 25, 2023 at 06:27:24PM +0200, Kristof Havasi wrote:
> > On Tue, 25 Apr 2023 at 16:47, Greg KH <gregkh@linuxfoundation.org> wrot=
e:
> > >
> > > On Tue, Apr 25, 2023 at 04:08:30PM +0200, Kristof Havasi wrote:
> > > > Hi there,
> > > >
> > > > I was evaluating CVE-2022-3567 and CVE-2022-3566 which both
> > > > revolt around load tearing and reference an ancient Kernel commit:
> > > > > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > > >
> > > > I am not sure whether they are applicable to the v5.4.y branch as w=
ell.
> > >
> > > I do not know, what specific commits are you referring to?  CVEs mean
> > > nothing, they are not valid identifiers, sorry.
> > >
> > > And have you tried applying them to the older kernels and testing to =
see
> > > if they solve any specific issue?
> > >
> > > Or better yet, why use the older kernels, why not stick to the most
> > > recent one?  What is preventing you from switching?
> >
> > Thank you for the quick response!
> >
> > I meant the following commits:
> > f49cd2f4d6170d27a2c61f1fecb03d8a70c91f57 and
> > 364f997b5cfe1db0d63a390fe7c801fa2b3115f6
> >
> > The v5.4 kernel is used in an embedded device where due to certificatio=
n
> > processes a quick upgrade of the Kernel isn't realistic until at least
> > another year.
>
> You do realize that stable kernel updates can radically change the whole
> system (look at the changes needed for retbleed), so any update needs to
> always be properly tested.  Version numbers mean nothing, so even if we
> do take these patches, you still need to do proper testing, the same
> amount of testing you would have done for moving to a new kernel
> version.

Yes, we are working on extending the tests, that is also how I found a
regression
candidate on the v5.4 LTS branch:
https://lore.kernel.org/lkml/1473b364-777a-ede8-3ff6-36d9e1d577ad@leemhuis.=
info/

>
> > The patches are quite small, I could cherry-pick them on the latest v5.=
4 tag,
> > and the kernel builds... only for
> > f49cd2f4d6170d27a2c61f1fecb03d8a70c91f57 USER_SOCKPTR
> > isn't available in 5.4, so I sticked to `char __user *`.
>
> Note that you also need to provide backports for 5.15.y and 5.10.y as
> you do not want to upgrade to a new version and have a regression,
> right?

Thank you, I didn't know that. Sorry for that, I am still just getting fami=
liar
with the Kernel development process and tooling.

>
> > I will get a device tomorrow and try whether I can netcat between them
> > via IPv4 and v6.
> > Any other tests, which would be needed?
>
> Why does the existance of a random CVE number mean anything?  You do
> know that MITRE (the entity that deals out CVEs), refuses to give the
> kernel team new CVE numbers for bug reports, right?  So that means that
> any kernel-related CVE that you see are created by vendors who are using
> them to facilitate their internal engineering processes, not necessarily
> anything else.
>
> I gave a whole long talk about this a few years ago if you are
> interested:
>         https://kernel-recipes.org/en/2019/talks/cves-are-dead-long-live-=
the-cve/
>

OMG, thanks for the link, you summed up quite the frustration of mine from
the past days, since I had to go through 500+ CVEs and classify them,
whether they "affect" 5.4.238... The whole "versioning" and references
are so lacking. But common criteria evaluations want to see all CVEs
classified... (Don't want to start another rant on CC...)

But if we forget the whole CVE thing for a moment, if there is a commit,
in the mainline which references a 2.6 kernel commit via "Fixes",
but this commit isn't picked into the LTS streams, how should I proceed?
(Not relevant or slipped through the creeks?)

> So maybe work to see if this is a real problem or not first, before
> worrying about backporting it?

Seeing the commit merged into the mainline tree and that it looked rather
reasonable to do the ref-counting, made the impression to me that it is
a valid patch.

Thanks again for the talk and the replies, helps a lot to see how the LTS
is maintained.

Best Regards,
Krist=C3=B3f
