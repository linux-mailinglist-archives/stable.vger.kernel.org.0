Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D03EF3161EC
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 10:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbhBJJSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 04:18:23 -0500
Received: from mail-qt1-f182.google.com ([209.85.160.182]:43609 "EHLO
        mail-qt1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbhBJJO7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 04:14:59 -0500
Received: by mail-qt1-f182.google.com with SMTP id d3so996873qtr.10;
        Wed, 10 Feb 2021 01:14:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k2foprN11jPvL8F6T6kuwwDYHPt232FzT4lVXv/dAAs=;
        b=XxLBwCn0Czm5ili8QdkM/Rh6RBf14N81oVagPDjO6Ho2IS4ggnqH3ragxXUKgxnBJX
         NlKOI3zAK2iG2frcZnZ0Xohcp271h+lI13IH91S5abU0FXEHA63L1331GnZmPRv7nSs8
         07DEkB9bw46vqHZ8G3vn0xguQUeljy2yrQTtnL0BDpPnY3E7Bn+U39FSEaoMZQtX0gta
         SQb7tJfcEg52A8CapR6AC5bhTbO+xSLMcc+dlPYWkChpoq23ayPgCt4Qecpy9/EOVqJw
         rpMUWShaFHFv0k8UJ0/R0UiwxPfgTOClwHxICckL5sFXTsEu94cTFO4PH/BiUrwN1brw
         gBqw==
X-Gm-Message-State: AOAM530b0x4HRYwVESyJ2qif0uY4VggnEEP6gATSjOqpIR+gRSzso+v5
        /LGBMbNmztPMLbXyinzHeVoh+3TYF/ek9r5W+SE=
X-Google-Smtp-Source: ABdhPJyiJTAt0q8MYJ8vdhT20PD2qMYb5gC/dcGBc9RoF5fw3VnDIJB3XMvy/JS7UcST5bgkskSxAf3+LSqjikwm7iY=
X-Received: by 2002:ac8:4e8b:: with SMTP id 11mr1808204qtp.292.1612948457651;
 Wed, 10 Feb 2021 01:14:17 -0800 (PST)
MIME-Version: 1.0
References: <20210208181157.1324550-1-paul@crapouillou.net> <20210208192902.GR920417@kernel.org>
In-Reply-To: <20210208192902.GR920417@kernel.org>
From:   Namhyung Kim <namhyung@kernel.org>
Date:   Wed, 10 Feb 2021 18:14:06 +0900
Message-ID: <CAM9d7ciG7p4KKTdLgHTUJHS03VpQuou8Ns3VWAZYB9S9kyr4nw@mail.gmail.com>
Subject: Re: [PATCH] perf stat: Use nftw() instead of ftw()
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Paul Cercueil <paul@crapouillou.net>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        od@zcrc.me, linux-kernel <linux-kernel@vger.kernel.org>,
        "stable # 4 . 5" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Tue, Feb 9, 2021 at 4:29 AM Arnaldo Carvalho de Melo <acme@kernel.org> wrote:
>
> Em Mon, Feb 08, 2021 at 06:11:57PM +0000, Paul Cercueil escreveu:
> > ftw() has been obsolete for about 12 years now.
> >
> > Fixes: bb1c15b60b98 ("perf stat: Support regex pattern in --for-each-cgroup")
> > CC: stable@vger.kernel.org
> > Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> > ---
> >
> > Notes:
> >     NOTE: Not runtime-tested, I have no idea what I need to do in perf
> >     to test this. But at least it compiles now with my uClibc-based
> >     toolchain.
>
> Seems safe from reading the nftw() man page, the only typeflag that this
> code is using is FTW_D and that is present in both ftw() and nftw().
>
> Applying,

Didn't notice it was obsolete.

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
