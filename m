Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7EA2B310A
	for <lists+stable@lfdr.de>; Sat, 14 Nov 2020 22:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgKNVkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Nov 2020 16:40:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgKNVkI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Nov 2020 16:40:08 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8277C0613D1
        for <stable@vger.kernel.org>; Sat, 14 Nov 2020 13:40:07 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id a9so18307651lfh.2
        for <stable@vger.kernel.org>; Sat, 14 Nov 2020 13:40:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mtgfuBsKaXsJcS3VyrNrM24pb1hiSB38AWDX8iQwSqE=;
        b=dFQVkF5J20UTcZKIYlhNZbgab9w4q1RcvptVBtINtyF82vwmBfx1T9f/azNWYB6EZh
         XmnkVIUzGmkCZffGvucZuE+9ulu5ppneeHnhjhHthgMJtOwaxHxrzwcQXyfJs6hN+iCh
         NVUOoYL3P2oE0Paguwenw23w/O2UKvOuPJgFg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mtgfuBsKaXsJcS3VyrNrM24pb1hiSB38AWDX8iQwSqE=;
        b=O98MJ5QfoP2Hki5ZBOVlPtz1+5VTgtpMjLxjNpHFJWxct0eCI0ob/j9OKI31hfbkTp
         xRgw6kExKEjyqw3zx1MDNzriIeRs+k2zFTIAthwrQRGxqsk6eWVNMEMinARE/tRBr8qG
         T84KmhsADjdj39sIWZgBt+kiSM5hHE0CQwOHAkkFM4o+xe4UP2j/jmaA4/9EE25s6Yq+
         GW3tWTOzQTrbmsQ5nR5FzQpOwEzvTlF+OGC8owgDdhEc1/AhfxbsffI7hhTEque7qNvX
         1S8odP88vy/cEzbrDCdTw94nZKfceChCfHHTfjbwn9/fmoQZpnvAcrFb/f584etAwN0+
         2p3g==
X-Gm-Message-State: AOAM533d2CWrkwY6JqJVgyBFIXkNPBxSpAB4UpDyDD80d1dBJCl/GYNr
        0Cz+nCfdtb9xfFYexXzLWgQK1kdljOpmPg==
X-Google-Smtp-Source: ABdhPJy4Cpb2HIbvoY6Hps1eG8zpAn1JFwHF7uB2v16EMITiMKI7FsKLNMkyMO4Sqk4rpWSpfgTe4g==
X-Received: by 2002:a19:c005:: with SMTP id q5mr2827368lff.400.1605390005409;
        Sat, 14 Nov 2020 13:40:05 -0800 (PST)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com. [209.85.208.174])
        by smtp.gmail.com with ESMTPSA id 130sm2087657lfd.51.2020.11.14.13.40.03
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Nov 2020 13:40:04 -0800 (PST)
Received: by mail-lj1-f174.google.com with SMTP id l10so15216939lji.4
        for <stable@vger.kernel.org>; Sat, 14 Nov 2020 13:40:03 -0800 (PST)
X-Received: by 2002:a2e:a375:: with SMTP id i21mr3137262ljn.421.1605390003621;
 Sat, 14 Nov 2020 13:40:03 -0800 (PST)
MIME-Version: 1.0
References: <20201113225115.b24faebc85f710d5aff55aa7@linux-foundation.org> <20201114065146.3H6OX7gIF%akpm@linux-foundation.org>
In-Reply-To: <20201114065146.3H6OX7gIF%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 14 Nov 2020 13:39:47 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj847SudR-kt+46fT3+xFFgiwpgThvm7DJWGdi4cVrbnQ@mail.gmail.com>
Message-ID: <CAHk-=wj847SudR-kt+46fT3+xFFgiwpgThvm7DJWGdi4cVrbnQ@mail.gmail.com>
Subject: Re: [patch 03/14] mm/vmscan: fix NR_ISOLATED_FILE corruption on 64-bit
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     a.sahrawat@samsung.com, Linux-MM <linux-mm@kvack.org>,
        maninder1.s@samsung.com, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.com>, mm-commits@vger.kernel.org,
        Nick Piggin <npiggin@gmail.com>,
        stable <stable@vger.kernel.org>, v.narang@samsung.com,
        Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I've applied this patch, but I have to say that I absolutely detest it.

This is very fragile, and I think the problem is the nasty interface.

Why don't we have simple wrappers that internally do that "mod", but
actually expose "inc" and "dec" instead, and make it much harder to
have these kinds of problems?

The function name is horrible too: "mod_node_page_state()"?  It's not
like that really even describes what it does. It doesn't modify any
page state what-so-ever, what it does is to update some node counters.

Did somebody mis-understand what "stat" stands for? It's not some odd
shortening of "state" (like "creat"). It's shorthand for "statistics".
Because that completely nonsensical "state" naming shows up in all of
those helper functions too.

And the "page" part of the name is misleading too, since it's not even
about page statistics, and the people who have a page need to
literally do "page_pgdat()" on that page in order to pass in the
"struct pglist_data" that the function wants.

To make matters worse, we have the double underscore versions too,
which have that magical "we know interrupts are disabled"
optimization, so we duplicate all of this horror.

So I really think this whole area would be ripe for some major
interface cleanups, both in naming and in interfaces.

A _small_ step would have been to avoid the "mod" thing.

            Linus

On Fri, Nov 13, 2020 at 10:51 PM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> From: Nicholas Piggin <npiggin@gmail.com>
> Subject: mm/vmscan: fix NR_ISOLATED_FILE corruption on 64-bit
>
> -       mod_node_page_state(zone->zone_pgdat, NR_ISOLATED_FILE, -nr_reclaimed);
> +       mod_node_page_state(zone->zone_pgdat, NR_ISOLATED_FILE,
> +                           -(long)nr_reclaimed);
...
>         mod_node_page_state(zone->zone_pgdat, NR_ISOLATED_FILE,
> -                           -stat.nr_lazyfree_fail);
> +                           -(long)stat.nr_lazyfree_fail);
