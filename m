Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D60B623F369
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 21:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgHGT5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 15:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727979AbgHGT5U (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Aug 2020 15:57:20 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48A2C061757
        for <stable@vger.kernel.org>; Fri,  7 Aug 2020 12:57:19 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id h19so3404219ljg.13
        for <stable@vger.kernel.org>; Fri, 07 Aug 2020 12:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LT9fXEVxD8v7QkyLZvL1Rm7ltKej7kPnvBESreG7Qak=;
        b=R8kmtmqrmhxaBq5InMpqrHoOAtLk7n/JJZ1ZzXPvCJw9u0WjEnyJnnsoogXK0t8ewh
         fRaTpoRxnQ1ruaQNFl9XYjVbJC3v8FGcOhHW98nF9P7m3Lc72yCjwF7xyy6BMahDSuCR
         y3unTDv4ZLPkpf97nZIwQmDsr/KM5bVaK8kFM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LT9fXEVxD8v7QkyLZvL1Rm7ltKej7kPnvBESreG7Qak=;
        b=bj4Rcj4pZFvGD6ETncK8nQ5uQFVY5IM1Nj+c7LJRBTxZT+z4QMaY10XA4rYFvx4LLT
         IOyu4DDgT5MxYX70V4/RMC05G0aIi6iaTAnOlq8a63WwhOpaxsifxYqyn90jcPHECncc
         zkOF1IQ09YoSb0wTNl/0RVINQPHd1xpRGQ+tls/iaUtO79iSI4xnLSeaprHp8u1aC6mj
         tS5MZauHVzJnWTPU3eiMZE47KjH86Iu7A/EzPMmLApp9yGCsFClRn8LOprT9bpaedJBw
         djfgC0pUk8OW4UhkkkdKM5fY4aFbKJKqHE3nrY+gAKg+VD6aXk3mo9HNOEy8Qs96wxHM
         3Jhg==
X-Gm-Message-State: AOAM533NbaZoEQSNTP8WHDHZwEeIFoswpH2gh7njNKD1MSa57NWsyUDe
        AcBEOlo0+E0sZLRasBL3EwmHD9Xk/X/VNQ==
X-Google-Smtp-Source: ABdhPJxr06G1njolaEp22E0+Y09uVUQ+7IObGHmWP2SxRXm7fPrEyGH/ABQl3mCGsEUKcUN9fXxfcg==
X-Received: by 2002:a2e:99cc:: with SMTP id l12mr6620754ljj.235.1596830236833;
        Fri, 07 Aug 2020 12:57:16 -0700 (PDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id u10sm4618832lfo.39.2020.08.07.12.57.14
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2020 12:57:14 -0700 (PDT)
Received: by mail-lf1-f50.google.com with SMTP id i80so1591759lfi.13
        for <stable@vger.kernel.org>; Fri, 07 Aug 2020 12:57:14 -0700 (PDT)
X-Received: by 2002:a05:6512:241:: with SMTP id b1mr7164028lfo.125.1596830233869;
 Fri, 07 Aug 2020 12:57:13 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=whf+_rWROqPUMr=Do0n1ADhkEeEFL0tY+M60TJZtdrq2A@mail.gmail.com>
 <BF4C5741-7433-4E96-B856-B25B049C9E49@amacapital.net>
In-Reply-To: <BF4C5741-7433-4E96-B856-B25B049C9E49@amacapital.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 7 Aug 2020 12:56:57 -0700
X-Gmail-Original-Message-ID: <CAHk-=whPgKZRfK_Kfo6Oo+Aek-Z_U_Dxv9Y3HuNuHb5t=jLbcA@mail.gmail.com>
Message-ID: <CAHk-=whPgKZRfK_Kfo6Oo+Aek-Z_U_Dxv9Y3HuNuHb5t=jLbcA@mail.gmail.com>
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
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 7, 2020 at 12:33 PM Andy Lutomirski <luto@amacapital.net> wrote:
>
> No one said we have to do only one ChaCha20 block per slow path hit.

Sure, doing more might be better for amortizing the cost.

But you have to be very careful about latency spikes. I would be
*really* nervous about doing a whole page at a time, when this is
called from routines that literally expect it to be less than 50
cycles.

So I would seriously suggest you look at a much smaller buffer. Maybe
not a single block, but definitely not multiple kB either.

Maybe something like 2 cachelines might be ok, but there's a reason
the current code only works with 16 bytes (or whatever) and only does
simple operations with no looping.

That's why I think you might look at a single double-round ChaCha20
instead. Maybe do it for two blocks - by the time you wrap around,
you'll have done more than a full ChaCaa20.

That would imnsho *much* better than doing some big block, and have
huge latency spikes and flush a large portion of your L1 when they
happen. Nasty nasty behavior.

I really think the whole "we can amortize it with bigger blocks" is
complete and utter garbage. It's classic "benchmarketing" crap.

             Linus
