Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C432F08B3
	for <lists+stable@lfdr.de>; Sun, 10 Jan 2021 18:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbhAJRVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 12:21:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbhAJRVs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jan 2021 12:21:48 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ABADC061786;
        Sun, 10 Jan 2021 09:21:08 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id n4so15285597iow.12;
        Sun, 10 Jan 2021 09:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=hIJyoIZptCAieLkcOngS9vOsmQbskS3oUoVqKFSW/H0=;
        b=pPrGNLr0rmVEuZ0aSviPkq6K5IGW0jOojNXKgq9duwjpBYE/OcIoyXum9A24iA+0vF
         i6m7TLQeVtlQqfsJWtzjJwDWPObF0zKbiSYxGeDVNsHmEZ//zGOxJd3tR6kftMNrPhvR
         h8laJjnxV6q2gaQjtm2OpKJZP7bE1pjF5yQB+2Rbr9bcK88k6qp06qHAABJ3CiTVmJAv
         Tc/A/RXyWbnjXLm7omSO+0+gsCHgDVTQK8Gue6vtuwehRwt2Xey3kBNLLJQgTz9Qkbxg
         MDQ9+rUNFr7VLFKR1q/HOuoz9IPbWuqFVp8W0bEs5U8KYRcgKEeZ5/xn06wfa/R8uh0b
         EAOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=hIJyoIZptCAieLkcOngS9vOsmQbskS3oUoVqKFSW/H0=;
        b=AEPpd8imXd63ocyEQdmjDfpLC5bIMfEw+sCetPi5Dc13B4z/0eRmBI/KyrT4PQ94Br
         x6IK8v3wbDGKcgbDIeoQKjKoTnExbvg13qqyRY6Ivzz0quRao9uV8noSMOfo11uAWxjO
         foX4Mmu5X1DoqgczNnqGlodILBme8VC48HeGyOzxz/lvIUoiViIwtevNsRCKLKDlcGT0
         0LTZSUsB+6OkdEhdvNG2becInng9Vw/66Bwr/Y7u7lbe5G2BU6gvbWMYU2eM/V8l05tY
         gmkh2+k4M4NfC4rd42c5GX4O9wrFaMCfcFK5xl5RmbvCOpesHEcdoJdUmxuKIcu6DCF+
         YYnA==
X-Gm-Message-State: AOAM530VAxiqXiQED6E92vffckFF88fPZjHmKyJBnxNU9JJtKgTTjscY
        Tf4qlxETOmuODlsGga4MBSmPDyAcYEBZKeQw62Y=
X-Google-Smtp-Source: ABdhPJyndm6gFye1n2GP1E3cFozfIC2Y+9mGHwYOwU3Jcaf3iwfLSP8Ltd/X+wnxwrBC285APQh2UJGPiF4OI8HgvTg=
X-Received: by 2002:a05:6638:48:: with SMTP id a8mr11374868jap.138.1610299267021;
 Sun, 10 Jan 2021 09:21:07 -0800 (PST)
MIME-Version: 1.0
References: <CA+icZUUq9Skdt0ws7uqa3N9P5vwhQX6DrhfNxMvkoKMEbyWE-Q@mail.gmail.com>
 <CAHk-=whNpzmU0UQ+dXU-A8tAyiKEzfrX-ax_80UmM77Ehjzy1A@mail.gmail.com> <20210110101929.GG4035784@sasha-vm>
In-Reply-To: <20210110101929.GG4035784@sasha-vm>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Sun, 10 Jan 2021 18:20:56 +0100
Message-ID: <CA+icZUX_DBcoPP59FTOQKMJLLLUJyppouLT0oCu2Ji49HepaAg@mail.gmail.com>
Subject: Re: depmod fixes for linux-stable releases
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 10, 2021 at 11:19 AM Sasha Levin <sashal@kernel.org> wrote:
>
> On Sat, Jan 09, 2021 at 05:23:22PM -0800, Linus Torvalds wrote:
> >Ack, I think 436e980e2ed5 ("kbuild: don't hardcode depmod path") is
> >stable material even if it doesn't fix a bug.
> >
> >Not only does the fix for that commit not make sense without the
> >commit in the first place, but any environment that sets depmod
> >somewhere else might well be an environment that still wants stable
> >kernels.
> >
> >It may not be the traditional case, but there's little reason for the
> >kernel build to force that /sbin/depmod location.
>
> I'll take it, thanks!
>

Thanks for pushing (and correcting the stable-ML email-address).

- Sedat -
