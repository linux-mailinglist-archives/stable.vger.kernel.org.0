Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACA6F16BDFB
	for <lists+stable@lfdr.de>; Tue, 25 Feb 2020 10:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729086AbgBYJzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Feb 2020 04:55:36 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:47002 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgBYJzg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Feb 2020 04:55:36 -0500
Received: by mail-pf1-f196.google.com with SMTP id k29so6884806pfp.13;
        Tue, 25 Feb 2020 01:55:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9/TmeUl6Orrpw9iJyKF2cvUy7KVXMYW9mff75+x6dlg=;
        b=j3u7m08y2p7UzNFy01ACdbJzicLjNJIvbEY9WAS5mq+9u3PvywiKG6KcsUKU7z939M
         gFIftcqkFtBEe7t90qhq94XBNYhnInkzS5+25Rf37EV3IAyKEX8Wh0IqvvpHc0zONKyB
         vjnzsHm/isvySFAT+zBuVtSMw3q8de0ckQd1rt24D471oW/KFv10SLQqk40Ay3ECfAyn
         E2LIctw1utjuKHWZu55Zz5/tubRbEZHp4aiJ/0pDcNdOVsHuIlAV5Pz88bcg9F/L38m4
         eUX4DNudeFL2cVlAmzL0U+Ld6cItm7xLK1GiJ+iVUYEOOuE5raAcgFpOPgmlfZC3xAyd
         LOPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9/TmeUl6Orrpw9iJyKF2cvUy7KVXMYW9mff75+x6dlg=;
        b=sYUPpABhwa9Aufj55H1r0r98dRBHl+DRqTchZGua6D/NkzfU5QmUrZ+7XUAEBy3Rn8
         jQ4v4AWTFoZ8vYiGtPx75XsggggMgmtY1SxUBLfETdSwY8h/MF493/F3Q8YhVxXR8wzy
         uEhhZtkHbTdA/+22wCiLVoZs8XR4saup4jD/xeVm5Swojkel9SOzvkLfC3H8tyfMVuEw
         we6ey7Y24qQGKFiKDLJJP3aDq5mc6Q/c7plr64BzYabj/Qfe/CjI7U6AfKLLEkk0Fo5f
         nN5fT4EkFOI7lr3QluKUWCaJ59tkjeG8XOjYA/AsTnxLMNJmkf4FvpobWpUx+P5nzF1S
         sXVg==
X-Gm-Message-State: APjAAAXGRJXZpPbuP4ENfvCKC+5TSUW6dMf6kD0jDABSLk9wDRbvCniZ
        L0LfSDcy67nIXwdo/tJmH/Zehm1CVsSxCcNtosk=
X-Google-Smtp-Source: APXvYqzw30KS5AwcFDpf0LcS9a3PXLWY+Y8GNLgLcjUUR/GN3NQPfrg4ufmdTSQNpFB1xo7YihEx0iWBm7wFRycE2Oc=
X-Received: by 2002:a63:798a:: with SMTP id u132mr59871900pgc.203.1582624535612;
 Tue, 25 Feb 2020 01:55:35 -0800 (PST)
MIME-Version: 1.0
References: <20200223181832.17131-1-kristian@klausen.dk> <20200224011017.C5207208C4@mail.kernel.org>
 <e700ebdc-3dce-c151-3ea5-f7ab1e4cb07f@klausen.dk> <CAHp75VcAZZ-d1BQON0ciLoCGt5=1qh4s1jLGhDdApicT+7BEGg@mail.gmail.com>
 <af54a82e-0b9f-1e88-8741-bd4a3658d8e7@klausen.dk>
In-Reply-To: <af54a82e-0b9f-1e88-8741-bd4a3658d8e7@klausen.dk>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 25 Feb 2020 11:55:27 +0200
Message-ID: <CAHp75VfGkn_oGCNyP=RWo9fHvh8YzEy6e7cDCczJefsq2HMRFw@mail.gmail.com>
Subject: Re: [PATCH v2] platform/x86: asus-wmi: Support laptops where the
 first battery is named BATT
To:     Kristian Klausen <kristian@klausen.dk>
Cc:     Sasha Levin <sashal@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 25, 2020 at 11:51 AM Kristian Klausen <kristian@klausen.dk> wrote:
> On 25.02.2020 10.30, Andy Shevchenko wrote:
> > On Mon, Feb 24, 2020 at 3:15 AM Kristian Klausen <kristian@klausen.dk> wrote:
> >> On 24.02.2020 02.10, Sasha Levin wrote:
> >>> NOTE: The patch will not be queued to stable trees until it is upstream.
> >>>
> >>> How should we proceed with this patch?
> >> The patch should only be applied to the v5.4 and v5.5 trees.
> > I'm not sure I got this right. Do we have already this change in upstream?
> > I don't see it there. So, why there is no mention of the v5.6 and
> > current upstream in above list?
>
> Sorry about that, my response does not make any sense.
> The change isn't upstream yet, and should be applied upstream first and
> the 5.4 and 5.6 tree tree if possible.

The usual pattern is to add Fixes tag and Cc: stable@.

> Was I wrong CC'ing stable@vger.kernel.org? (suggested by git send-email
> due to "Cc: stable@vger.kernel.org")

-- 
With Best Regards,
Andy Shevchenko
