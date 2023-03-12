Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3310D6B63C8
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 09:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbjCLIEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 04:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjCLIEg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 04:04:36 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81ECE311FF;
        Sun, 12 Mar 2023 00:04:35 -0800 (PST)
Received: by mail-ua1-x936.google.com with SMTP id f20so6306315uam.3;
        Sun, 12 Mar 2023 00:04:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678608274;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qfKEOLAKbj2XxL1hjifvx1HBaIqseG2a+SMKBfbB8Q8=;
        b=NvsU8KZWHVok2krusvOYBl8VJ3SZToWl4IxQ3YaoT7DGH0G3CMa5K5qFkov1HFnJ40
         DJnpSMmpU3UnzQ2hfZ+TNK4vUbcYOdwTYcSW1WwJrzwMW/39NtIuEZveMUEENX2Cc2bK
         LX0BC+F9QDH1QzLIS3NtbmBK42mhPmTzjxPb1UMEnbIbH9uT/MqSJIVXgHnktPMONZR/
         Qz+BGvVhKLNsZ7UUk5LvWhlA+i82C1262+QZ4sHzoIbI1PQsOXttEihAGWwXf8qN0RWa
         OWWyx/u145+FXyG5KBD6tgCeYKViW/l8YUH1ikTMAVqIFeC6fM88HVMvryt8S25paj/z
         Lnbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678608274;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qfKEOLAKbj2XxL1hjifvx1HBaIqseG2a+SMKBfbB8Q8=;
        b=aeVYZqntbsVvM6W1nOVJTNIoSLYkKjQU9aulBgW4q1dD0VeE4B64rvovm4toQRGJUY
         g/LaCkveR7YnOzeeq1+EG+NR3XHewPzW9EWYVVldpcaOCSpM13Vq+5/5QSM8mLmjydEe
         vWloRqQn5PqkQ/xpeSviLNc41JFmduekTMFPGisPez49ttV5Hp4Yl9fBQ45sf8/y7gQ8
         tyCUt1kAq7SOWt4h3adZjgvQ4ubl4dimH1sp3Nqar+aEszyI2ZYVxOf94KrgiyQJdKRi
         lQbWLKzzNksX/F8GwoYtBFMCkDz1wgtAF0+ufIvxvibe5LWExqwMsHUVN/XJ3rMSZ5F1
         FwaQ==
X-Gm-Message-State: AO0yUKXXHGa3z1KzEpRbGHqSyCuAX7poYF/ej2AkT9g+xYTCJZHLRVIG
        L6LZAIacbG91tPfTveOc4se+d3nFiwKd8weBK8A=
X-Google-Smtp-Source: AK7set9zGF5d+FIDYqhziPYi6klNOORn4sUp17ULW6w/0eIBU5yc6eBlG5zDiOogTJ0L2HUTYH6bHAmCBiJH8vjcE44=
X-Received: by 2002:a9f:3001:0:b0:68b:817b:eec8 with SMTP id
 h1-20020a9f3001000000b0068b817beec8mr19598266uab.0.1678608274574; Sun, 12 Mar
 2023 00:04:34 -0800 (PST)
MIME-Version: 1.0
References: <Y/zswi91axMN8OsA@sol.localdomain> <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <ZATC3djtr9/uPX+P@duo.ucw.cz> <ZAewdAql4PBUYOG5@gmail.com>
 <ZAwe95meyCiv6qc4@casper.infradead.org> <ZAyK0KM6JmVOvQWy@sashalap>
 <20230311161644.GH860405@mit.edu> <ZAy+3f1/xfl6dWpI@sol.localdomain>
 <ZAzH8Ve05SRLYPnR@sashalap> <ZAzOgw8Ui4kh1Z3D@sol.localdomain> <ZAzvPR1zev3tFJoH@sashalap>
In-Reply-To: <ZAzvPR1zev3tFJoH@sashalap>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 12 Mar 2023 10:04:23 +0200
Message-ID: <CAOQ4uxhgHp7Eh4HC7ceqzyWp2PyD_G7-o-DukfA90WN456gDeQ@mail.gmail.com>
Subject: Re: AUTOSEL process
To:     Sasha Levin <sashal@kernel.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org,
        Leah Rumancik <leah.rumancik@gmail.com>,
        "Luis R. Chamberlain" <mcgrof@gmail.com>
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

On Sat, Mar 11, 2023 at 11:25=E2=80=AFPM Sasha Levin <sashal@kernel.org> wr=
ote:
>
> On Sat, Mar 11, 2023 at 10:54:59AM -0800, Eric Biggers wrote:
...
> >And yes, I am interested in contributing, but as I mentioned I think you=
 need to
> >first acknowledge that there is a problem, fix your attitude of immediat=
ely
> >pushing back on everything, and make it easier for people to contribute.
>
> I don't think we disagree that the process is broken: this is one of the
> reasons we went away from trying to support 6 year LTS kernels.
>
> However, we are not pushing back on ideas, we are asking for a hand in
> improving the process: we've been getting drive-by comments quite often,
> but when it comes to be doing the actual work people are quite reluctant
> to help.
>
> If you want to sit down and scope out initial set of work around tooling
> to help here I'm more than happy to do that: I'm planning to be both in
> OSS and LPC if you want to do it in person, along with anyone else
> interested in helping out.
>

Sasha,

Will you be able to attend a session on AUTOSEL on the overlap day
of LSFMM and OSS (May 10) or earlier?

We were going to discuss the topic of filesystems and stable trees [1] anyw=
ay
and I believe the discussion can be even more productive with you around.

I realize that the scope of AUTOSEL is wider than backporting filesystem fi=
xes,
but somehow, most of the developers on this thread are fs developers.

BTW, the story of filesystem testing in stable trees has also been improvin=
g
since your last appearance in LSFMM.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-fsdevel/CACzhbgSZUCn-az1e9uCh0+AO314+yq6M=
JTTbFt0Hj8SGCiaWjw@mail.gmail.com/
