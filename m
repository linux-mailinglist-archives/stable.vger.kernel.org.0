Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD8E23F319
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 21:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgHGTdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 15:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgHGTdg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Aug 2020 15:33:36 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E52C061756
        for <stable@vger.kernel.org>; Fri,  7 Aug 2020 12:33:36 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id k13so1555851plk.13
        for <stable@vger.kernel.org>; Fri, 07 Aug 2020 12:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=Fe3n4VKi5pnRtKW300kvfqgX0VVWYhsFPHjehF7XRBE=;
        b=SMyQBWpI+mFMexUmvNUQ28U0pv88RirS8gjAfM49Uoh1VeLhRMEj+Pw5CjTQrZl/jP
         JqNoQgH1b5XtWnBkkyn7npXU2rdHlMhHXwXhnkR2iqgOJ/f8Zj7b2vcHcMX+gAAP+79U
         YtuqK/upQCc+AU6mqIPKaBzRSi/HN+dSTUoQWoayMGgO/kw8OaL6IY5ZrbyICGxy13zY
         BD9y44/sfeZRxATKzbPF6qBzZb7DsQCHvWlahjeKxDQXZEli0oa3DyNlFpGXCYcp/g6V
         Yq3Moi0FzBVpvZOwqQnniWK+UhsgVD/0L6FTsEgBLN2Zv9vwt4taM4Mlu3T3Xtr95428
         DvQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=Fe3n4VKi5pnRtKW300kvfqgX0VVWYhsFPHjehF7XRBE=;
        b=J5YF7VlhN9JpMaiOlXYXMXDYDQT6+JkA6Ep1IW++n0lSGPSGfPwGl4FaUv7gZWmwkB
         posn6WCguc0IxjcZSdb+TPyz2tDvo0qkVhu82qWd1LzjOLXBX7teC7J1nBJelzVGij0W
         ErxFkY2SIpeAZDHrK/vT+Q/QlJNPVxcawUwxRZ2ZZfTkjzM4ian4hSxqGJC2JtG0HWKZ
         4UBXfaJ0egTZ+xfJS+/DUBJC1G8oxggEYd2TjUyI+Ft/UrCh0wM8elNR76cNcxIUIoSF
         4RzQM8xVfS/rV/et4cmVLHmb31ux5nNvIrv3Bn6cY7J/05uPza8p7gmDI1iFrMuJQCMP
         mNHw==
X-Gm-Message-State: AOAM533EeEPCZgXMo9fOjyHyU00dLaGXJwUPjfLCeB41UodoJt8msp/p
        okHtqrv5ZzDlKkwHgAGrY2rVTg==
X-Google-Smtp-Source: ABdhPJzRVqrlSAkjcool3cxdgTtmDIV9HWgXynw2vZLeHB8tQBAN8NsSacGsykGS8/IoYPQPIgRoQw==
X-Received: by 2002:a17:902:9042:: with SMTP id w2mr14304485plz.9.1596828815729;
        Fri, 07 Aug 2020 12:33:35 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:431:59:d011:24a4? ([2601:646:c200:1ef2:431:59:d011:24a4])
        by smtp.gmail.com with ESMTPSA id o192sm15611184pfg.81.2020.08.07.12.33.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2020 12:33:34 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: Flaw in "random32: update the net random state on interrupt and activity"
Date:   Fri, 7 Aug 2020 12:33:33 -0700
Message-Id: <BF4C5741-7433-4E96-B856-B25B049C9E49@amacapital.net>
References: <CAHk-=whf+_rWROqPUMr=Do0n1ADhkEeEFL0tY+M60TJZtdrq2A@mail.gmail.com>
Cc:     Willy Tarreau <w@1wt.eu>, Marc Plumb <lkml.mplumb@gmail.com>,
        Theodore Ts'o <tytso@mit.edu>, Netdev <netdev@vger.kernel.org>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        stable <stable@vger.kernel.org>
In-Reply-To: <CAHk-=whf+_rWROqPUMr=Do0n1ADhkEeEFL0tY+M60TJZtdrq2A@mail.gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: iPhone Mail (17G68)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Aug 7, 2020, at 12:21 PM, Linus Torvalds <torvalds@linux-foundation.org=
> wrote:
>=20
> =EF=BB=BFOn Fri, Aug 7, 2020 at 12:08 PM Andy Lutomirski <luto@amacapital.=
net> wrote:
>> 4 cycles per byte on Core 2
>=20
> I took the reference C implementation as-is, and just compiled it with
> O2, so my numbers may not be what some heavily optimized case does.
>=20
> But it was way more than that, even when amortizing for "only need to
> do it every 8 cases". I think the 4 cycles/byte might be some "zero
> branch mispredicts" case when you've fully unrolled the thing, but
> then you'll be taking I$ misses out of the wazoo, since by definition
> this won't be in your L1 I$ at all (only called every 8 times).
>=20
> Sure, it might look ok on microbenchmarks where it does stay hot the
> cache all the time, but that's not realistic. I

No one said we have to do only one ChaCha20 block per slow path hit.  In fac=
t, the more we reduce the number of rounds, the more time we spend on I$ mis=
ses, branch mispredictions, etc, so reducing rounds may be barking up the wr=
ong tree entirely.  We probably don=E2=80=99t want to have more than one pag=
e=20

I wonder if AES-NI adds any value here.  AES-CTR is almost a drop-in replace=
ment for ChaCha20, and maybe the performance for a cache-cold short run is b=
etter.=
