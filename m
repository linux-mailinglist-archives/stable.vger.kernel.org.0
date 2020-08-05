Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE0223D414
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 01:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgHEXD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 19:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbgHEXD4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 19:03:56 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A82EAC061575
        for <stable@vger.kernel.org>; Wed,  5 Aug 2020 16:03:55 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id x6so10447034pgx.12
        for <stable@vger.kernel.org>; Wed, 05 Aug 2020 16:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:mime-version:subject:from:in-reply-to:cc
         :date:message-id:references:to;
        bh=uLBYUTnw9Z+74Aj4SR5Qjaxb4nMHXf9QCuupJPejSUc=;
        b=g+hrT99ZtYzguhFzzkZ4UR5OiG5nV7TPkFPrKp4hoI45WLAVypnJsCBSaHmqvf3Je+
         SVEcomvCFFdlIbAsb4RIhJv53ZMr6GaL1PBk0f/Jh8vZlfpsYls0J/uufLtAx3Tj1hTB
         VyOwo5m7gALv1CzVeTIvUqt7YTcVWOscyTx6KhJLxJcIHwIfm4AOE3UrqVbsn+e+yvmK
         Tq8geHbroBgMPEy6Uyc2aMzN9CqRieE6LsJBNjzFa2wGT+XKIQTbSyGFir4UVD4/GZum
         hMxJiR4JH+RM235vcBAN21860fGWD5D5N8UXnG3uyPLXMLLIniR17gyoFJodhFgD+Twe
         HUJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:mime-version:subject
         :from:in-reply-to:cc:date:message-id:references:to;
        bh=uLBYUTnw9Z+74Aj4SR5Qjaxb4nMHXf9QCuupJPejSUc=;
        b=JEWdKwX+fZjvTjdFRcu9eP4+eNyYgNgUw/UA20khHXhxHD9iUK+Kmu+QrcWwCb5vfg
         mNO90fu900Gs/QdyLxR/J/PUks0ej1TAAySMB9UCCF2lqLJTRiN07MoopdfINxAugUKS
         bA8JnpFtB0+vBIN5KtnyRW7ytpeMY5xey0XAi1/StjsgVZj9NU96gV4MFpbxQbe7z+GH
         KcJT3oqNn6+BZSIyOh77Pilk4QOdGD/Vj2SJ9ZNnAMCRc0ofWTBg5Co0KwMcFacdpafH
         Hjf0DmrcHdnVB2oxIaJlrDGrIiUrlzAuT6h8ToMF6NUlyxg0k6nrod2+VpEOP5b1pvb8
         Jw3Q==
X-Gm-Message-State: AOAM533bI7Dnh0o/5NxIZcbsA2q6+6hJ4ESLCCghZD3LOWzKdm9mIzdr
        2EA24NbS0sq1JVdhmBgRaSFKAg==
X-Google-Smtp-Source: ABdhPJy0cWmM7VcSKZcB6RJLl2odCIeq1tlznOYQIVXKJ/MNA6YEiJdiR6e/aTbUOlh3Q2kjt8TZSg==
X-Received: by 2002:a63:4714:: with SMTP id u20mr4999261pga.104.1596668634635;
        Wed, 05 Aug 2020 16:03:54 -0700 (PDT)
Received: from [192.168.0.248] (c-67-180-165-146.hsd1.ca.comcast.net. [67.180.165.146])
        by smtp.gmail.com with ESMTPSA id e26sm4439271pfj.197.2020.08.05.16.03.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2020 16:03:53 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (1.0)
Subject: Re: Flaw in "random32: update the net random state on interrupt and activity"
From:   Andy Lutomirski <luto@amacapital.net>
In-Reply-To: <20200805220550.GA785826@mit.edu>
Cc:     Marc Plumb <lkml.mplumb@gmail.com>, Willy Tarreau <w@1wt.eu>,
        netdev@vger.kernel.org, aksecurity@gmail.com,
        torvalds@linux-foundation.org, edumazet@google.com,
        Jason@zx2c4.com, luto@kernel.org, keescook@chromium.org,
        tglx@linutronix.de, peterz@infradead.org, stable@vger.kernel.org
Date:   Wed, 5 Aug 2020 16:03:52 -0700
Message-Id: <4FAC5E1F-870F-47E3-BBE8-6172FDA15738@amacapital.net>
References: <20200805220550.GA785826@mit.edu>
To:     tytso@mit.edu
X-Mailer: iPhone Mail (17G68)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


>> On Aug 5, 2020, at 3:06 PM, tytso@mit.edu wrote:
>>=20
>> =EF=BB=BFOn Wed, Aug 05, 2020 at 09:06:40AM -0700, Marc Plumb wrote:
>> Isn't get_random_u32 the function you wrote to do that? If this needs to b=
e
>> cryptographically secure, that's an existing option that's safe.
>> The fundamental question is: Why is this attack on net_rand_state problem=
?
>> It's Working as Designed. Why is it a major enough problem to risk harmin=
g
>> cryptographically important functions?
>=20
> I haven't looked at the users of net_rand_state, but historically, the
> networking subsystem has a expressed a (perceived?) need for *very* fast
> mostly-random-but-if-doens't-have-to-be-perfect-numbers-our-benchmarks-
> are-way-more-important numbers.   As in, if there are extra cache line
> misses, our benchmarks would suffer and that's not acceptable.
>=20
> One of the problems here is that it's not sufficient for the average case
> to be fast, but once in every N operations, we need to do something that
> requires Real Crypto, and so that Nth time, there would be an extra lag
> and that would be the end of the world (at least as far as networking
> benchmarks are concerned, anyway).

I respectfully disagree with the supposed network people :). I=E2=80=99m wor=
king, slowly, on a patch set to make this genuinely fast. =20

>  So in other words, it's not enough for
> the average time to run get_random_u32() to be fast, they care about the 9=
5th or
> 99th percentile number of get_random_u32() to be fast as well.
>=20
> An example of this would be for TCP sequence number generation; it's
> not *really* something that needs to be secure, and if we rekey the
> RNG every 5 minutes, so long as the best case attack takes at most,
> say, an hour, if the worst the attacker can do is to be able to carry
> out an man-in-the-middle attack without being physically in between
> the source and the destination --- well, if you *really* cared about
> security the TCP connection would be protected using TLS anyway.  See
> RFC 1948 (later updated by RFC 6528) for an argument along these
> lines.
>=20
>> This whole thing is making the fundamental mistake of all amateur
>> cryptographers of trying to create your own cryptographic primitive. You'=
re
>> trying to invent a secure stream cipher. Either don't try to make
>> net_rand_state secure, or use a known secure primitive.
>=20
> Well, technically it's not supposed to be a secure cryptographic
> primitive.  net_rand_state is used in the call prandom_u32(), so the
> only supposed guarantee is PSEUDO random.
>=20
> That being said, a quick "get grep prandom_u32" shows that there are a
> *huge* number of uses of prandom_u32() and whether they are all
> appropriate uses of prandom_u32(), or kernel developers are using it
> because "I haz a ne3D for spE3d" but in fact it's for a security
> critical application is a pretty terrifying question.  If we start
> seeing CVE's getting filed caused by inappropriate uses of
> prandom_u32, to be honest, it won't surprise me.
>=20
>                       - Ted
