Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29C2819BA1F
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 04:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387591AbgDBCGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 22:06:23 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44132 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733029AbgDBCGW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 22:06:22 -0400
Received: by mail-lj1-f193.google.com with SMTP id p14so1523440lji.11
        for <stable@vger.kernel.org>; Wed, 01 Apr 2020 19:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xQMUHcx5ZJebHuFeNsiV5oTqPrmJdOW/j745+2PrxT0=;
        b=FEz92/cjgu/KjeUfKUAamLHbiMYZP/JE8iQyr8PNIMC5adYQCca21soCJysmTW8le/
         u+EmuDxNfwEIB6iFxacesqUbrDJuUXTQH1CifqeNvpd7zFcILB7eKw8/Qk1LJLcobXrc
         6HoPfDxgcA61kzOR0e4ZTAsOnzIaIrzLDUVEs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xQMUHcx5ZJebHuFeNsiV5oTqPrmJdOW/j745+2PrxT0=;
        b=o8HoTDpDptoHkwtN74sJxxIcYvbePYpp7mnMXZy4XeM4OnsfEIYPYk3BPzdav6ij9C
         eq/0kOuY0jydYUSIzNt6s5lepEUwyK6XGDqhARdi8gmKsXiseFw25o9dTdLNY7baToY2
         kqcQiQYFrEoNBHirnyxHiY9QcpdocpfUNqYzLlLbFq5Fs63TrpZJRIQBEQYciBMyGMz5
         f5wRYH/l5UNVm1lpiTwezqPQWNuC2icSZiQoXirJ0vm4fqlVJq0FWBewMqt1PWec9C1+
         c54T3TGi2vWv8YjKkxUfMaijNumCxNz3/fkctoHUXgtaONUgajQxalplgHR287KC6Gzf
         fDVw==
X-Gm-Message-State: AGi0Puai3a87Viegb6PH+SnJiiZ/au2KvsaHPGiuLIpzhUbagbH9RIz3
        rQ+3Rok/aUivm09R/1DThpx4PF0yQVM=
X-Google-Smtp-Source: APiQypKAXRxB5xdemfuFnI685o/f4oplB/DcznR9EtDkg6L5RVkbq7VCaQVF2GKCvZP7KLPFAkXwiA==
X-Received: by 2002:a2e:b5d1:: with SMTP id g17mr569331ljn.139.1585793178504;
        Wed, 01 Apr 2020 19:06:18 -0700 (PDT)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com. [209.85.208.169])
        by smtp.gmail.com with ESMTPSA id h9sm2105719ljk.96.2020.04.01.19.06.16
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2020 19:06:18 -0700 (PDT)
Received: by mail-lj1-f169.google.com with SMTP id t17so1518374ljc.12
        for <stable@vger.kernel.org>; Wed, 01 Apr 2020 19:06:16 -0700 (PDT)
X-Received: by 2002:a19:7f96:: with SMTP id a144mr643180lfd.31.1585793175190;
 Wed, 01 Apr 2020 19:06:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200324215049.GA3710@pi3.com.pl> <202003291528.730A329@keescook>
 <87zhbvlyq7.fsf_-_@x220.int.ebiederm.org> <CAG48ez3nYr7dj340Rk5-QbzhsFq0JTKPf2MvVJ1-oi1Zug1ftQ@mail.gmail.com>
 <CAHk-=wjz0LEi68oGJSQzZ--3JTFF+dX2yDaXDRKUpYxtBB=Zfw@mail.gmail.com>
 <CAHk-=wgM3qZeChs_1yFt8p8ye1pOaM_cX57BZ_0+qdEPcAiaCQ@mail.gmail.com> <CAG48ez1f82re_V=DzQuRHpy7wOWs1iixrah4GYYxngF1v-moZw@mail.gmail.com>
In-Reply-To: <CAG48ez1f82re_V=DzQuRHpy7wOWs1iixrah4GYYxngF1v-moZw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 1 Apr 2020 19:05:59 -0700
X-Gmail-Original-Message-ID: <CAHk-=whks0iE1f=Ka0_vo2PYg774P7FA8Y30YrOdUBGRH-ch9A@mail.gmail.com>
Message-ID: <CAHk-=whks0iE1f=Ka0_vo2PYg774P7FA8Y30YrOdUBGRH-ch9A@mail.gmail.com>
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
        stable <stable@vger.kernel.org>, Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        kasan-dev <kasan-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 1, 2020 at 6:36 PM Jann Horn <jannh@google.com> wrote:
>
> Since the read is already protected by the tasklist_lock, an
> alternative might be to let the execve path also take that lock to
> protect the sequence number update,

No.

tasklist_lock is aboue the hottest lock there is in all of the kernel.

We're not doing stupid things for theoretical issues.

Stop this crazy argument.

A comment - sure. 64-bit atomics or very expensive locks? Not a chance.

                   Linus
