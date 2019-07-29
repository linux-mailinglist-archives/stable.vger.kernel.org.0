Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67F8A79AA8
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 23:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730013AbfG2VJw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 17:09:52 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:37276 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729327AbfG2VJw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 17:09:52 -0400
Received: by mail-io1-f65.google.com with SMTP id q22so3455986iog.4
        for <stable@vger.kernel.org>; Mon, 29 Jul 2019 14:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9YrqMlHNqZAaGdeVX5EfmeYkFQLdlx9m477jCrUkqDI=;
        b=glWb7RlNO8QHe3Kd15SImmSGdttxS5VwsK9LBdSYpUeFXTdnyopO9CQKUwsIvsFW8b
         jjY2cj9+GtlbZ0QIybP3UYT5qzWKUxwoeBtypQM9bMFhc/+y5BsL8Mp6zmFZmzlchcl9
         dl8Nr090TKl3xad3/4IdW+2o3TeGVpjzW4bken0Wm3ETbmAkXlYRX82n2x6w7PdrG+Ln
         wQNsesgvR5iPZsd0b9NGn0y2vX7ToqjAALSnmk7M3+GF3pQb/KlPgviAfm9eGux49OrT
         3KfSK3GSzd30IbwYMfqNOoNOcYUn5/zR5ok4bqmGozTAAmoJfiXDoi+EfLsrKjXEoQYS
         VrdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9YrqMlHNqZAaGdeVX5EfmeYkFQLdlx9m477jCrUkqDI=;
        b=GpWpdkZsfpliBuYidNc92pfeRMvPyiKLVeHuNv98DqXkekB5L11q4vFGgkXMNoZIbv
         A2icPi64kxT9vBD5hQn/b23Uy5r69RSytEmGbqfHMRMQtW7nPCdTDxe9LbDYV3TWmPLP
         CKLm6c7mNacuV5a91MSRHK48DYl0bwoGy6HyVjFSmKg5MtRAJxlOvMxv5aUzKPftTh60
         q/hJvDLYW4Rk90+JXN73/iVr6+L9leJ38Y6+069nA/h7gKtQfMHipeL7jURRiJxO36uo
         sb9AML0I1U8GxnDcSQhiN8PtcNSfIj4Tu012cPKwMqcDscbsw/DvoqP5xKX0qzxJsKHG
         /xuw==
X-Gm-Message-State: APjAAAWzmLG+14B2ZUXsb88zFlhF4Cql62552dcaRVG+AqPqJDpfUE8/
        oD/5hVtmuJThPJR8bK2zF3PI94ZqRjHNjYcvYrynKw==
X-Google-Smtp-Source: APXvYqxhlUj+a11+YzuMwWDnq9y2Do3Qn7frG9IgBVh7BEzf0sUkKNrCTQmU131fes0GT8rMVdTm+jm9ljeWEL5ZQro=
X-Received: by 2002:a6b:6b14:: with SMTP id g20mr73770321ioc.28.1564434591860;
 Mon, 29 Jul 2019 14:09:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190729204954.25510-1-briannorris@chromium.org>
 <20190729205452.GA22785@archlinux-threadripper> <CA+ASDXOOqOAWg9LnSPUs9d9Ai8G_4xkdUGC+CCduQQLBzC4kQA@mail.gmail.com>
In-Reply-To: <CA+ASDXOOqOAWg9LnSPUs9d9Ai8G_4xkdUGC+CCduQQLBzC4kQA@mail.gmail.com>
From:   Enrico Granata <egranata@google.com>
Date:   Mon, 29 Jul 2019 14:09:41 -0700
Message-ID: <CAPR809vmOBeJPArfjM=Fh_Kiqsew-shfF9ZpOtRJ-sU7QgUneQ@mail.gmail.com>
Subject: Re: [PATCH] driver core: platform: return -ENXIO for missing GpioInt
To:     Brian Norris <briannorris@chromium.org>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Salvatore Bellizzi <salvatore.bellizzi@linux.seppia.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Enrico Granata <egranata@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Gwendal Grignou <gwendal@chromium.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Benson Leung <bleung@chromium.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 29, 2019 at 2:03 PM Brian Norris <briannorris@chromium.org> wrote:
>
> On Mon, Jul 29, 2019 at 1:54 PM Nathan Chancellor
> <natechancellor@gmail.com> wrote:
> > On Mon, Jul 29, 2019 at 01:49:54PM -0700, Brian Norris wrote:
> > > Side note: it might have helped alleviate some of this pain if there
> > > were email notifications to the mailing list when a patch gets applied.
> > > I didn't realize (and I'm not sure if Enrico did) that v2 was already
> > > merged by the time I noted its mistakes. If I had known, I would have
> > > suggested a follow-up patch, not a v3.
> >
> > I've found this to be fairly reliable for getting notified when
> > something gets applied if it is a tree that shows up in -next.
> >
> > https://www.kernel.org/get-notifications-for-your-patches.html
>
> I didn't send the original patch. I was only debugging/reviewing
> someone else's patch, and jumped in after its authorship (as it hit
> issues in our own CI system). So it was more of a "drive-by" scenario,
> and it doesn't sound like that page addresses this situation.
>
> Brian

Your assessment sounds about right - I suspect the tl;dr is that *I*
(the original patch author) should have subscribed to that bot, so I
could figure out that v2 had already merged, and done the right thing
sending out a follow-up CL once you brought the issue to my attention.
