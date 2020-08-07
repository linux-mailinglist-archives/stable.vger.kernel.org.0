Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 145DB23F3C1
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 22:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgHGUYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 16:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgHGUYl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Aug 2020 16:24:41 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F22DC061756
        for <stable@vger.kernel.org>; Fri,  7 Aug 2020 13:24:40 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id x24so1634577lfe.11
        for <stable@vger.kernel.org>; Fri, 07 Aug 2020 13:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zAEfhaBLFHweOFHJGO1LUi9iEaryA05hJDqBMYtLh6Q=;
        b=FAnH9wp+lzAaIg0WLPx6/RG2l8zTqq+0ckpSbJjHs/J+JanKf5kyn16IV6IOsD99Gh
         7F8vnPHBj4Td3aQ16qLvGe8Jt5UG53byKM0I03OJXyc9T5Pf9Tuj6+XRpkoaH9/63/ot
         LVsacVn6XT+fAqtBms2PHxM25U7jnMxiehVjc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zAEfhaBLFHweOFHJGO1LUi9iEaryA05hJDqBMYtLh6Q=;
        b=DKELsnSI4tOTGWNUvj71fcopvxGm8duFYTzgmDaKs6BPAOLQboXSuo6ZTwsBqwgyQn
         JIySkjavAi6bMVDddfYozRGhuDLCXGNttpKK8UsCfDJ+JrcWjTUYpg6gU4Rif2N/V/Um
         SnlvQzsQEjQYtPYfq/ODcLvPDNiAPI8J0LQKI3AbmTDMXAIAf7Kk8nr27+1dR2YwIs6V
         uIUJPwbn96nDyEyLj3IR+v4POaTC+uQUOwKSiCZVVxE3DZfiHSAacVAHm9UW/HBbxbus
         94zmTbDBfJ2rPW097KWTaCxF4WKDXnsMjaajhjtxMNFxPDIxAKwpCZ6Voe5PXWr8eUeZ
         E8eA==
X-Gm-Message-State: AOAM532DNUVvcBpbHR/YRgL8i8/vhGvI4zZ2dKN6zqcrhtZQLvDswVAz
        /hRsBCXudcruo8wrSnfrNU62Fttx+VJ2uQ==
X-Google-Smtp-Source: ABdhPJyLDdvj3jQZleZrW0rWluKLoHfmsDNUWWI586cQBjaZ/HrySIdsVJBGZl3T3zhG+MqLIyHgMw==
X-Received: by 2002:ac2:5223:: with SMTP id i3mr7306103lfl.57.1596831878790;
        Fri, 07 Aug 2020 13:24:38 -0700 (PDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id 204sm4707509lfm.86.2020.08.07.13.24.37
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2020 13:24:37 -0700 (PDT)
Received: by mail-lf1-f45.google.com with SMTP id v15so1634470lfg.6
        for <stable@vger.kernel.org>; Fri, 07 Aug 2020 13:24:37 -0700 (PDT)
X-Received: by 2002:ac2:58d5:: with SMTP id u21mr7050787lfo.31.1596831877024;
 Fri, 07 Aug 2020 13:24:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=whPgKZRfK_Kfo6Oo+Aek-Z_U_Dxv9Y3HuNuHb5t=jLbcA@mail.gmail.com>
 <57399571-280E-48CF-8F72-516F7178748C@amacapital.net>
In-Reply-To: <57399571-280E-48CF-8F72-516F7178748C@amacapital.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 7 Aug 2020 13:24:20 -0700
X-Gmail-Original-Message-ID: <CAHk-=whL2Uz7V8OGvZBN0aW0cgn3xTQhPu-jb-Aikn65nkt4Dw@mail.gmail.com>
Message-ID: <CAHk-=whL2Uz7V8OGvZBN0aW0cgn3xTQhPu-jb-Aikn65nkt4Dw@mail.gmail.com>
Subject: Re: Flaw in "random32: update the net random state on interrupt and activity"
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Willy Tarreau <w@1wt.eu>, Marc Plumb <lkml.mplumb@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Netdev <netdev@vger.kernel.org>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 7, 2020 at 1:16 PM Andy Lutomirski <luto@amacapital.net> wrote:
>
> I think this will come down to actual measurements :).

Numbers talk, bullshit walks.

But:

> If the cost of one block of cache-cold ChaCha20 is 100 cycles of actual c=
omputation and 200 cycles of various cache misses, then let=E2=80=99s do mo=
re than one block.

That's *completely* nonsensical thinking and crazy talk.

If the issue is latency (and for a lot of networking, that literally
*is* the issue), your mental model is completely insane.

"Oh, it's so expensive that we should queue *more*" is classic
throughput thinking, and it's wrong.

If you have performance problems, you should look really really hard
at fixing latency.

Because fixing latency helps throughput. But fixing throughput _hurts_ late=
ncy.

It really is that simple. Latency is the much more important thing to optim=
ize.

Nobody cares about "bulk TCP sequence numbers". Sure, you'll find
benchmarks for it, because it's a lot easier to benchmark throughput.
But what people _care_ about is generally latency.

              Linus
