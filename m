Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC44945D0A4
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 23:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345580AbhKXXAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 18:00:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243700AbhKXXAn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 18:00:43 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18888C061574
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 14:57:33 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id g14so17139667edb.8
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 14:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mariadb.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kZ/Cy6oKXJuBsBkSEe6ykahv0AudUP/LRivoV/mGkv8=;
        b=h6z6PNmew3L4EmqJUapMfQ73aM5Al6Ba8eOAJne3KmFdTj+9v3dIY0888+LVi6HgH/
         RGesLXW9XCNayvrRP+Zr0FR9FYv7KAT5y+wGzw7/09dI1SIjE0Ru0TNkB2XLHSELQZB+
         KOtfTyGGgIY4xWB0efZL6NOemCCtdXSRTgCrMrUI9/62iuEaLtBjnj3LbChvbTTdqVhQ
         Ja5tgqB3wD/Vm7n66s/mxMWeaevH5sfarctFry44bmyIxE4i0Rhj+b4sfxAeWVEbKoSn
         e/Ss3/NGDfYpzJGlx3WoPodQjnWCVa1lRGaISALPwm3uZPEqeNG6OoGmUBnRt5vzjCYD
         wNIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kZ/Cy6oKXJuBsBkSEe6ykahv0AudUP/LRivoV/mGkv8=;
        b=68ayVyxCEkcKHMq/DbyFZI1MiWM+Lz+3UJiDg3OoW0eOhx3DBf5bXZ97Hrw/tahznx
         i6069Gm040Zms9ISem+JIqAikJVJmTA0MVViB+xA/RJe1yQv4TMAaSRKnFvfiy/WGCdo
         gkE93IXVQYQegEx5K9Hxxp25vERKGEPsfsuD7n2owazcJDiOjW5FJmYhvD37qtgbG9DV
         Fak8zrvF2F0SDo9vauLTX/g8j52UmqYo/hhvhz+h17pNDZmgIW0O1SVscDkuU3cxlbTz
         FShKk7pPelVb+xYDEv+cRdBRQiu1/YQCwEpJ6ivq7Fa0TSCtPNsh0c8flwbRxdQlVX5O
         lNKQ==
X-Gm-Message-State: AOAM531+srt8iu3MWDyv/nwZ1KEQhUpfkMKWx6GGsGZCNSUj8M6icP60
        LePUxKL62ZYsTUVO1bQI4snxIIiPspM4pnOrQsGLjg==
X-Google-Smtp-Source: ABdhPJwCs5NYY9EfCsQ1LswfyhANXYbQm96NTJsvs5s8M3oFoYX9ZbguIlfrjP1n+0r1RIbD1X3X7+YlLgVzYWGTcs0=
X-Received: by 2002:a05:6402:90c:: with SMTP id g12mr31022237edz.217.1637794651674;
 Wed, 24 Nov 2021 14:57:31 -0800 (PST)
MIME-Version: 1.0
References: <c6d6bffe-1770-c51d-11c6-c5483bde1766@kernel.dk>
 <bd7289c8-0b01-4fcf-e584-273d372f8343@kernel.dk> <6d0ca779-3111-bc5e-88c0-22a98a6974b8@kernel.dk>
 <281147cc-7da4-8e45-2d6f-3f7c2a2ca229@kernel.dk> <c92f97e5-1a38-e23f-f371-c00261cacb6d@kernel.dk>
 <CABVffEN0LzLyrHifysGNJKpc_Szn7qPO4xy7aKvg7LTNc-Fpng@mail.gmail.com>
 <00d6e7ad-5430-4fca-7e26-0774c302be57@kernel.dk> <CABVffEM79CZ+4SW0+yP0+NioMX=sHhooBCEfbhqs6G6hex2YwQ@mail.gmail.com>
 <3aaac8b2-e2f6-6a84-1321-67409b2a3dce@kernel.dk> <98f8a00f-c634-4a1a-4eba-f97be5b2e801@kernel.dk>
 <YZ5lvtfqsZEllUJq@kroah.com> <c0a7ac89-2a8c-b1e3-00c2-96ee259582b4@kernel.dk>
In-Reply-To: <c0a7ac89-2a8c-b1e3-00c2-96ee259582b4@kernel.dk>
From:   Daniel Black <daniel@mariadb.org>
Date:   Thu, 25 Nov 2021 09:57:20 +1100
Message-ID: <CABVffEOXe=mhyW_-Ynz4Z9g_UxvVAms662vQjN9UBfF9NhWu8g@mail.gmail.com>
Subject: Re: uring regression - lost write request
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 25, 2021 at 3:22 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 11/24/21 9:18 AM, Greg Kroah-Hartman wrote:
> > On Wed, Nov 24, 2021 at 09:10:25AM -0700, Jens Axboe wrote:
> >> On 11/24/21 8:28 AM, Jens Axboe wrote:
> >>> On 11/23/21 8:27 PM, Daniel Black wrote:
> >>>> On Mon, Nov 15, 2021 at 7:55 AM Jens Axboe <axboe@kernel.dk> wrote:

> >>>> I'm getting the same reproducer on 5.14.20
> >>>> (https://bugzilla.redhat.com/show_bug.cgi?id=2018882#c3) though the
> >>>> backport change logs indicate 5.14.19 has the patch.
> >>>>
> >>>> Anything missing?
> >>>
> >>> We might also need another patch that isn't in stable, I'm attaching
> >>> it here. Any chance you can run 5.14.20/21 with this applied? If not,
> >>> I'll do some sanity checking here and push it to -stable.
> >>
> >> Looks good to me - Greg, would you mind queueing this up for
> >> 5.14-stable?
> >
> > 5.14 is end-of-life and not getting any more releases (the front page of
> > kernel.org should show that.)
>
> Oh, well I guess that settles that...

Certainly does. Thanks for looking and finding the patch.

> > If this needs to go anywhere else, please let me know.
>
> Should be fine, previous 5.10 isn't affected and 5.15 is fine too as it
> already has the patch.

Thank you

https://github.com/MariaDB/server/commit/de7db5517de11a58d57d2a41d0bc6f38b6f92dd8

On Thu, Nov 25, 2021 at 9:52 AM Stefan Metzmacher <metze@samba.org> wrote:
> Are 5.11 and 5.13 are affected,

Yes.

> these are hwe kernels for ubuntu,
> I may need to open a bug for them...

Yes please.
