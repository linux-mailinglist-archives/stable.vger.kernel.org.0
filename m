Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3278C6B63B6
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 08:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjCLHnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 03:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjCLHnN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 03:43:13 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7731B325;
        Sat, 11 Mar 2023 23:43:11 -0800 (PST)
Received: by mail-ua1-x933.google.com with SMTP id d12so6270716uak.10;
        Sat, 11 Mar 2023 23:43:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678606991;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ldlqQsfUkVWJcbMHgo5HY4HoalKFezeXB+mixEzm1zc=;
        b=V50Ek/RXMCYNKO8MVapt5fILhfALLOGGNXH0Pg4jDk3wVSZ7Y+yiOV3B5VNsRk+yhL
         l2vpKI4bRqbXOcZ4sm19s8DSX7ybHuGKPrCc9ZsxLzZYgARSimhH+OHoIHgcm1GPkvRa
         WyvcDbKXIcqHddqdLLUKsDmNzI135Y896piIpXs2KNf+ZNsrFNsxI9yvdhZkpqTGQc+f
         s6egUzwBm7nMk6cGi/85fY08mqCx0WGY6WhdXTBZBS9H4jWZ534KH3u2107T5pz55Ijq
         imuFIe64DzjflKrdbuoMRF4NDTSRPotQi3SDpWXWWXeSpHWrc/SIadroiz+F/oL0kihP
         URYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678606991;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ldlqQsfUkVWJcbMHgo5HY4HoalKFezeXB+mixEzm1zc=;
        b=5EX4gndpYXQQPUqpmn80wETAfS/NcQILZselIkHPEp2RN5AlaVwW9NNhG0VqUFEvOI
         3gW5PbKl3CxQ4mRa+5Tle3/jA4SoPmBYHfM58NYcUKwvpkwzLOtLN6fsAHkL1WzveX9P
         UfkcTDYd4/QndWLSF0yCGIoMeSe+LhdTzvw9Va0PBbOIpcTKNw9Xt+A0mgNZGKfTmxeq
         4iJG5/6NULD4LVvgW+KDzjsv02hKgo6n5HVUziNgHywd6kAfTVnXnjh/q88fW4V1kcIJ
         kqA7vtCR6Ybaxh4iMsBmuesy6DpolG0sqvI/a/1Rdfxmr9icyCd+04GpxY6miUHYR8jg
         Qxog==
X-Gm-Message-State: AO0yUKUMfsfuRJzCKv4VEP2cijRrLkbDunMOAuOHsoA+TQe5BmZDornb
        J0uncYK3a5OFt9TOp8LU+cTWZpcfe5Pl15XRdZHiejckBZU=
X-Google-Smtp-Source: AK7set/L21PQb0E11CyNXhRQBYZPqqDRUs6VaZSWYoZ0/R2GNrOrxk5DpfzjIxDIKgmma6+poBRfmfEGWfq1VtM/wEw=
X-Received: by 2002:a1f:4542:0:b0:401:1c83:fba3 with SMTP id
 s63-20020a1f4542000000b004011c83fba3mr19014655vka.3.1678606990738; Sat, 11
 Mar 2023 23:43:10 -0800 (PST)
MIME-Version: 1.0
References: <ZAewdAql4PBUYOG5@gmail.com> <ZAwe95meyCiv6qc4@casper.infradead.org>
 <ZAyK0KM6JmVOvQWy@sashalap> <20230311161644.GH860405@mit.edu>
 <ZAy+3f1/xfl6dWpI@sol.localdomain> <ZAzJltJaydwjCN6E@1wt.eu>
 <ZAzVbzthi8IfptFZ@sol.localdomain> <ZAzghyeiac3Zh8Hh@1wt.eu>
 <ZAzqSeus4iqCOf1O@sol.localdomain> <ZA1V4MbG6U3wP6q6@1wt.eu> <ZA1hdkrOKLG697RG@sol.localdomain>
In-Reply-To: <ZA1hdkrOKLG697RG@sol.localdomain>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 12 Mar 2023 09:42:59 +0200
Message-ID: <CAOQ4uxiJPvKh5VzoP=9xamFfU78r3J25pwW6GQyAUN7YPJk=dQ@mail.gmail.com>
Subject: Re: AUTOSEL process
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Willy Tarreau <w@1wt.eu>, "Theodore Ts'o" <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>
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

On Sun, Mar 12, 2023 at 7:41=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
...
> I mean, "patches welcome" is a bit pointless when there is nothing to pat=
ch, is
> it not?  Even Sasha's stable-tools, which he finally gave a link to, does=
 not
> include anything related to AUTOSEL.  It seems AUTOSEL is still closed so=
urce.
>
> BTW, I already did something similar "off to the side" a few years ago wh=
en I
> wrote a script to keep track of and prioritize syzbot reports from
> https://syzkaller.appspot.com/, and generate per-subsystem reminder email=
s.
>
> I eventually ended up abandoning that, because doing something off to the=
 side
> is not very effective and is hard to keep up with.  The right approach is=
 to
> make improvements to the "upstream" process (which was syzbot in that cas=
e), not
> to bolt something on to the side to try to fix it after the fact.
>
> So I hope people can understand where I'm coming from, with hoping that w=
hat the
> stable maintainers are doing can just be improved directly, without first
> building something from scratch off to the side as that is just not a goo=
d way
> to do things.  But sure, if that's the only option to get anything nontri=
vial
> changed, I'll try to do it.
>

Eric,

Did you consider working to improve or add functionality to b4?

Some of the things that you proposed sound like a natural extension of
b4 that stable maintainers could use if they turn out to be useful.

Some of the things in your wish list, b4 already does - it has a local
cache of messages from query results, it can find the latest submission
of a patch series.

When working on backporting xfs patches to LTS, I ended up trying to
improve and extend b4 [1].

My motivation was to retrieve the information provided in the pull request
and cover letters which often have much better context to understand
whether patches are stable material.

My motivation was NOT to improve automatic scripts, but I did make
some improvement to b4 that could benefit automatic scripts as well.

Alas, despite sending a pull request via github and advertising my work
and its benefits on several occasions, I got no feedback from Konstantin
nor from any other developers, so I did not pursue upstreaming.

If you find any part of this work relevant, I can try to rebase and
post my b4 patches.

Thanks,
Amir.

[1] https://github.com/mricon/b4/pull/1
