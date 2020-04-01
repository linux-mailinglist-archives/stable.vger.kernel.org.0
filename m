Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8ACD19B93E
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 02:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733060AbgDBABi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 20:01:38 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:38302 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733017AbgDBABh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 20:01:37 -0400
Received: by mail-lf1-f66.google.com with SMTP id c5so1240899lfp.5
        for <stable@vger.kernel.org>; Wed, 01 Apr 2020 17:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/BfWZS5+9as5lD6vEMwl/6xxGz06a9gloYkQ+RKeiao=;
        b=JfE6FWMW0WrTIHwAtwqL3bo+qhTInr5LXI005KEawz6BRmX/rJrge8UmPsiMK5pPpc
         uTi9rFGFrfCf6pGgobgz2x2SN1yInjn8O4MwUNtnjY4Fxxg3pNbTXYvif4DrVZeLWFYk
         NwMooEZifjvk8bHNwWTVKU9ykqNbijKLOcb/k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/BfWZS5+9as5lD6vEMwl/6xxGz06a9gloYkQ+RKeiao=;
        b=jrpIRXaDLH76tfulnMtEzCCArAX7rsFIDIOTWQFvwk+SS1YWH+BaoykjkRtCsEg0NF
         SSC0XRPbm9th97KknpQi3fptHxhlMaqiwxblIrHiqMpGMDwUAwEjO3SlcJL/tAUyAVuj
         FgmTOzlzynhj2wKOCHfTeJqbYRJ5R86d2GLM43h0nUyMqyuRWtsf17ptDk4osZEkKqCo
         ydBJYOnQ50Q/PQ228+mb/KZ49s9/s8NuOt8GEvUbAaxGwmARdIMjjrX+/VFLpo2iaRO8
         aZG7U3OB4ghkps/DM1wcxKnvwnE6+5Foj9bGlLXbAqH7lKw1pGdIyn7INGYTSxB2PjgN
         Id3w==
X-Gm-Message-State: AGi0PubySfTbw6rml6k5lSgAhrVa8XzBTRc87k+tB61AatPvoPK4lurz
        jB0OdOAxq+5MZl9OCCiywWd+OrIIlDk=
X-Google-Smtp-Source: APiQypI+CLLAJW2SsmG+e0AsTLG0bPXBbJBQeEx1CdmXiEaR76/ryn+CjyNw3cAh59pAyp1pHRAAqA==
X-Received: by 2002:a19:240a:: with SMTP id k10mr429947lfk.30.1585785695380;
        Wed, 01 Apr 2020 17:01:35 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id b198sm2666582lfg.11.2020.04.01.17.01.34
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2020 17:01:35 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id e7so1267215lfq.1
        for <stable@vger.kernel.org>; Wed, 01 Apr 2020 17:01:34 -0700 (PDT)
X-Received: by 2002:a2e:b4cb:: with SMTP id r11mr371604ljm.201.1585785358260;
 Wed, 01 Apr 2020 16:55:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200324215049.GA3710@pi3.com.pl> <202003291528.730A329@keescook>
 <87zhbvlyq7.fsf_-_@x220.int.ebiederm.org> <CAG48ez3nYr7dj340Rk5-QbzhsFq0JTKPf2MvVJ1-oi1Zug1ftQ@mail.gmail.com>
 <CAHk-=wjz0LEi68oGJSQzZ--3JTFF+dX2yDaXDRKUpYxtBB=Zfw@mail.gmail.com>
In-Reply-To: <CAHk-=wjz0LEi68oGJSQzZ--3JTFF+dX2yDaXDRKUpYxtBB=Zfw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 1 Apr 2020 16:55:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgM3qZeChs_1yFt8p8ye1pOaM_cX57BZ_0+qdEPcAiaCQ@mail.gmail.com>
Message-ID: <CAHk-=wgM3qZeChs_1yFt8p8ye1pOaM_cX57BZ_0+qdEPcAiaCQ@mail.gmail.com>
Subject: Re: [PATCH] signal: Extend exec_id to 64bits
To:     Jann Horn <jannh@google.com>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andrea Parri <parri.andrea@gmail.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Jade Alglave <j.alglave@ucl.ac.uk>,
        Luc Maranget <luc.maranget@inria.fr>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Akira Yokosawa <akiyks@gmail.com>,
        Daniel Lustig <dlustig@nvidia.com>,
        Adam Zabrocki <pi3@pi3.com.pl>,
        kernel list <linux-kernel@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 1, 2020 at 4:51 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> It's literally testing a sequence counter for equality. If you get
> tearing in the high bits on the write (or the read), you'd still need
> to have the low bits turn around 4G times to get a matching value.

Put another way: first you'd have to work however many weeks to do 4
billion execve() calls, and then you need to hit basically a
single-instruction race to take advantage of it.

Good luck with that. If you have that kind of God-like capability,
whoever you're attacking stands no chance in the first place.

                  Linus
