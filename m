Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7313C4EB2BE
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 19:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240220AbiC2Rgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 13:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236270AbiC2Rgo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 13:36:44 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB04C205D2
        for <stable@vger.kernel.org>; Tue, 29 Mar 2022 10:35:00 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id pv16so36638388ejb.0
        for <stable@vger.kernel.org>; Tue, 29 Mar 2022 10:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sweetwater-ai.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zL8Qb+2gKSP2c6o2DRoz5Oq4k0aSHrt0NlsFQOW67pQ=;
        b=BOgBq3juIQwFAKc4hAgJLiwRVOGTVSjvDHh2EK3sajCMpKygdODuNG6y0+hFSGcaIa
         Qd65rAj2ejL1UlKrdXnPIYCSdl5FyHF3g03b+Lwu4dELr+S96YdQFMNjyj35bTCudeEB
         QIB3gvuBYc+WW9XsLaUUJYFYbAySfwsthCKyjVOxbfpmGSqOuVsUctRimJM/qCWaL8CU
         lduSPE9cjjqAbeT4cWjwOl4lk3JeOglENj0yWdD352QfnyyZxmUaJa7rbMCD4F/dvB5h
         Eq7VgIvB0cERyEEMpXzhbtfhQGlrNuTziQvpiNbqJhYt7s5mZWXKiuFu7curSqEWctvM
         scng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zL8Qb+2gKSP2c6o2DRoz5Oq4k0aSHrt0NlsFQOW67pQ=;
        b=AS7jMcCuY3xf2BB++sjhXrgkv54aVKJp8lWnyhaXpFehQuTK/JrbJeLJC/A54D1tkS
         6NySL7O0DpDx123ItLXbCummnvjMLMTOw9fL9gXt8EEg3sdrP1Lb7YdqoUkA30eA2cKT
         ReoFCzg50nDReJ2lG8AIN8BlJL9Hte/aJDK0GwZLk9VKwVMRoFvWuV8kq+JncQ6p1gPo
         7J6UtDKhDMeviJCs8pvNvaXFXxkn77lp6JLwh/YkVaiZ+2zNIEA6hM0uDrI7ixBdQ0Pi
         N898v6mEvNplP1Yct+E8N6i7Z1cHAcvE2oQTVi+g4GRPpWSiahvOTPOFtKWCnsjBfskf
         Ns8g==
X-Gm-Message-State: AOAM530EveMuGMNlZIplXILjPGy9vnpEGyyXmNlQTHge8txCoVy9mwEw
        CHvA0ppLUGDW12vu94Pl2vShounRksVC5+ONFNSa2Q==
X-Google-Smtp-Source: ABdhPJzRQY6KZHmBGeWvlLVF+akUYt2iHYoWgMy/f3hjH6kMin6Jwj0Cd/JjJv1GykQD/uqIwQKGWmhz+xmGyNO2+Mg=
X-Received: by 2002:a17:907:3e16:b0:6df:b4f0:5cc2 with SMTP id
 hp22-20020a1709073e1600b006dfb4f05cc2mr35937852ejc.285.1648575299439; Tue, 29
 Mar 2022 10:34:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220328111828.1554086-1-sashal@kernel.org> <20220328111828.1554086-16-sashal@kernel.org>
 <YkH5mhYokPB87FtE@google.com> <YkMoCe+uX6UxfaeM@mit.edu>
In-Reply-To: <YkMoCe+uX6UxfaeM@mit.edu>
From:   Michael Brooks <m@sweetwater.ai>
Date:   Tue, 29 Mar 2022 10:34:49 -0700
Message-ID: <CAOnCY6TNVHLX06mvMZFnNwVx3yE20qnqeGY7fbTx4c2XbyVVEw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.17 16/43] random: use computational hash for
 entropy extraction
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     Eric Biggers <ebiggers@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I agree with Ted,  this patch is just to start the discussion on how
we can safely remove these locks for the improvement of safety and
security.  Both boot and interrupt benchmarks stand to benefit from a
patch like this, so it is worth a deep dive.

Feedback welcome, I am always looking for ways I can be a better
engineer, and a better hacker and a better person. And we are all here
to make the very best kernel.

Regards,
Micahel

On Tue, Mar 29, 2022 at 8:39 AM Theodore Ts'o <tytso@mit.edu> wrote:
>
> On Mon, Mar 28, 2022 at 06:08:26PM +0000, Eric Biggers wrote:
> > On Mon, Mar 28, 2022 at 07:18:00AM -0400, Sasha Levin wrote:
> > > From: "Jason A. Donenfeld" <Jason@zx2c4.com>
> > >
> > > [ Upstream commit 6e8ec2552c7d13991148e551e3325a624d73fac6 ]
> > >
> >
> > I don't think it's a good idea to start backporting random commits to random.c
> > that weren't marked for stable.  There were a lot of changes in v5.18, and
> > sometimes they relate to each other in subtle ways, so the individual commits
> > aren't necessarily safe to pick.
> >
> > IMO, you shouldn't backport any non-stable-Cc'ed commits to random.c unless
> > Jason explicitly reviews the exact sequence of commits that you're backporting.
>
> Especially this commit in general, which is making a fundamental
> change in how we extract entropy.  We should be very careful about
> taking such changes into stable; a release or two of additonal "soak"
> time would be a good idea before these go into the LTS releases in particular.
>
>                                           - Ted
