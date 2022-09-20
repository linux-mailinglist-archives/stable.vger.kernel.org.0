Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40E3C5BE7D2
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 16:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbiITOAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 10:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbiITOAN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 10:00:13 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B121583D;
        Tue, 20 Sep 2022 07:00:12 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-11e9a7135easo4291044fac.6;
        Tue, 20 Sep 2022 07:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=anwJ1q9b14QesSLm4IQZ3eD0Se0ge7to/g7pHbX3jG0=;
        b=bjlAlEIklUV7hPttdA8fDtvgyEyudwFcvTMbEssKiC6eBOZ2O2xFGl6XCcfc1SRiIE
         P/HW32nak3/AIw3q5NBSb9foiDz5+hzuTrEbGwyWvDrVar82JqUksGtwB9Wj6YVnX5ON
         RESLXA9eGCW8TdchEApJwPj07cv5HWqFSngD1AYH4BEJAVWe/BTDL/N7y9XqF8vbEg/A
         LBJikXoE9bT7BEaOWOLwWt52owdDJjZr8s2DsRTuc7OwUSokcsYM4+onJnfGO0sEfb4r
         NVIXIqtqiYYKv4ow15IcC2xT7DYCohO9dGIrJb9rr1BrRsBURg8/M7aBsepO1/bcxuRm
         lWTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=anwJ1q9b14QesSLm4IQZ3eD0Se0ge7to/g7pHbX3jG0=;
        b=JQM3in13kfbbhOVKWwuUGpcKeOn1EydYkkJWzSGi9Sy7b/njMM0Ag5RfBQi3qq2AW4
         9UmBZcxgLqxqtHm92UpM30VVlSEM+XgcgCMYPGCXmrpM0a2tzO0JZQnl+9LjFdm7X34g
         H+IXHg3844z+UobDCcjXFZ47KHOoyFnO7aPWvOpV0N+dz0reJ1pluIWyEKk28BsYuT+M
         mWMGSv3rEf1orj5wtmkCGh1QvY8p7MQxdQAeoDudLuiRBa+w+HU9hTj8G2+3QIBzd+Uf
         FA/1z+uUCG3oJi1fGVen/oTGMtNQx9frNag1gRIxOBKZp6+i8dItvLTSxihdQUJKHu05
         ywtw==
X-Gm-Message-State: ACrzQf2lELR0fw9baA87bsRzMJyCWOqTyoJkn6XJHdY+c5g2m0AkXCEe
        Hp3QxnOCxyFJBZIqp88JDOd4PhbRQKuRM8KIFZw=
X-Google-Smtp-Source: AMsMyM7M1YKMioaUgRWcbL23K4TaHKNh67DDfmsw8bUBSbp1bz0bgqIHBrVEMt51SFoqWOPTeCbJrP/ViUnRkbqN54M=
X-Received: by 2002:a05:6870:c1c6:b0:12c:8311:8f3c with SMTP id
 i6-20020a056870c1c600b0012c83118f3cmr2206076oad.158.1663682411217; Tue, 20
 Sep 2022 07:00:11 -0700 (PDT)
MIME-Version: 1.0
References: <CACX6voDfcTQzQJj=5Q-SLi0in1hXpo=Ri28rX73Og3GTObPBWA@mail.gmail.com>
 <48bb6266-2d5c-ffcd-6982-4fd02bfdcfc3@leemhuis.info>
In-Reply-To: <48bb6266-2d5c-ffcd-6982-4fd02bfdcfc3@leemhuis.info>
From:   hazem ahmed mohamed <hazem.ahmed.abuelfotoh@gmail.com>
Date:   Tue, 20 Sep 2022 14:59:34 +0100
Message-ID: <CACX6voDhGxiyAxaEu0OL+hHFDD9kigso-YVrWTk4jcbvYZKVew@mail.gmail.com>
Subject: Re: Ext4: Buffered random writes performance regression with
 dioread_nolock enabled
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks like I replied only on Thorsten insteading of replying to all so
moving the discussion to the wider thread for better visibility.

---------- Forwarded message ---------
From: Thorsten Leemhuis <regressions@leemhuis.info>
Date: Tue, 20 Sept 2022 at 14:31
Subject: Re: Ext4: Buffered random writes performance regression with
dioread_nolock enabled
To: hazem ahmed mohamed <hazem.ahmed.abuelfotoh@gmail.com>


On 20.09.22 15:21, hazem ahmed mohamed wrote:
> Thanks Thorsten, I am surprised that we merged this commit while it
> has been showing regression since Day-0, unless there is an objection
> I will submit a revert patch until we know what's going on here.

Please keep replies online, then others can learn from the conversation
and weight in. In this particular case I'd explained that a quick revert
after all this time is likely a bad thing, as there is always a risk
that is creates regressions of its own. :-/

Ciao, Thorsten
> On 19.09.22 17:18, hazem ahmed mohamed wrote:
> >
> > I am sending this e-mail to report a performance regression that=E2=80=
=99s
> > caused by commit 244adf6426(ext4: make dioread_nolock the default) , I
> > am listing the performance regression symptoms below & our analysis
> > for the reported regression.
>
> FWIW, that patch went into v5.6-rc1~113^2~12
>
> And BTW: it seems 0-day back then noticed that 244adf6426 caused a
> performance regression as well, but it seems that was ignored:
> https://lore.kernel.org/all/20201024120829.GK31092@shao2-debian/
>
> Anyway, now to the main reason why I write this mail:
>
> [TLDR: I'm adding this regression report to the list of tracked
> regressions; all text from me you find below is based on a few templates
> paragraphs you might have encountered already already in similar form.]
>
> Thanks for the report. To be sure below issue doesn't fall through the
> cracks unnoticed, I'm adding it to regzbot, my Linux kernel regression
> tracking bot:
>
> #regzbot ^introduced 244adf6426
> #regzbot ignore-activity
>
> This isn't a regression? This issue or a fix for it are already
> discussed somewhere else? It was fixed already? You want to clarify when
> the regression started to happen? Or point out I got the title or
> something else totally wrong? Then just reply -- ideally with also
> telling regzbot about it, as explained here:
> https://linux-regtracking.leemhuis.info/tracked-regression/
>
> Reminder for developers: When fixing the issue, add 'Link:' tags
> pointing to the report (the mail this one replies to), as explained for
> in the Linux kernel's documentation; the webpage mention at the end of
> the last para explains why this is important for tracked regressions.
>
> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
>
> P.S.: As the Linux kernel's regression tracker I deal with a lot of
> reports and sometimes miss something important when writing mails like
> this. If that's the case here, don't hesitate to tell me in a public
> reply, it's in everyone's interest to set the public record straight.
