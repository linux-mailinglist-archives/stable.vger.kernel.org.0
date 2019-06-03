Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4153F33861
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 20:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfFCSl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 14:41:58 -0400
Received: from mail-ua1-f68.google.com ([209.85.222.68]:38852 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726653AbfFCSl5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 14:41:57 -0400
Received: by mail-ua1-f68.google.com with SMTP id j2so2987594uaq.5
        for <stable@vger.kernel.org>; Mon, 03 Jun 2019 11:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VsSotgwA1nxU4EAySnnvJ5ZgB7iMM3DB2x56bZwTUg8=;
        b=a09cCL26+bNOhQdoUo4x1wwzRc4g9+ZUKrcQIliCV1lVo86BnM7yonXBOHs3n8ThUp
         tBeLLscjAUtngd30ZkAshMl1RND5mQUFk5hVmajXhWgn0Q6ATNrv0OJKmvUbmJLKJjZp
         7PN3dXgD7aCNGHhYS/nSswGo8LZlcgEqVC4Fc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VsSotgwA1nxU4EAySnnvJ5ZgB7iMM3DB2x56bZwTUg8=;
        b=JLvfuYbiesoIduZl3IWZcwca3hUxQcbA/0PqSCWUsU+qYG00TyZJxgXVmCNg4e17sC
         fkdEC5FkU47u8QQ4KQD/pTcJHKvpJ5xv3OjdZMrLlVbGZmJjOATtofPDNfZUJPBIPMT+
         m1mpgBiAzWVS9JmDaxz7Zwio9cJ9w8wtGWifvhkfEcpMyWcC+isYTFZI2N0l2h7E7A8/
         XFMPzgHQTyzKBJ4P7YGfrkFdzHN7ow9y1DT89TWwcrGCjF2ZpU0P1CDc9Bu8wK8plnGn
         ak/18xGBPYs24TUBUBxZ617T5CXgEEumipCJCbTHGF8XSCcdaujfhSsWZxnPP17NqF30
         eaSA==
X-Gm-Message-State: APjAAAVyWoDcH3ZOb8/CZFxM0EV+Mo0H3OHoufTadcUsusu/A+2eJdZQ
        0BZlEQeHIBztBU6kprMbnfQaunk4h1Y=
X-Google-Smtp-Source: APXvYqwM4WePtp3U6k1CsL5fif5EF8UXfMXH1mafcEiMOejQfm4hET2MLr9QdWmUMao3MJ4LtlxYfw==
X-Received: by 2002:a9f:366b:: with SMTP id s40mr13488899uad.121.1559587315785;
        Mon, 03 Jun 2019 11:41:55 -0700 (PDT)
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com. [209.85.217.48])
        by smtp.gmail.com with ESMTPSA id 185sm3420101vst.8.2019.06.03.11.41.55
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 11:41:55 -0700 (PDT)
Received: by mail-vs1-f48.google.com with SMTP id n21so6140627vsp.12
        for <stable@vger.kernel.org>; Mon, 03 Jun 2019 11:41:55 -0700 (PDT)
X-Received: by 2002:a67:ec5a:: with SMTP id z26mr9662027vso.144.1559587314889;
 Mon, 03 Jun 2019 11:41:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190429204040.18725-1-dianders@chromium.org> <CAPDyKFp0fQ+3CS-DadE9rO-9Npzve-nztY9hRaMdX7Pw9sUZMw@mail.gmail.com>
 <CAD=FV=XMph_CE3pFZGP+5d0K2FgbPbheF1oX72TfZn_dpf8SQA@mail.gmail.com>
In-Reply-To: <CAD=FV=XMph_CE3pFZGP+5d0K2FgbPbheF1oX72TfZn_dpf8SQA@mail.gmail.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Mon, 3 Jun 2019 11:41:42 -0700
X-Gmail-Original-Message-ID: <CAD=FV=U7_ek_z7UfaDn9My8UfZfpNom04OJHowoH-sNsGZQnxA@mail.gmail.com>
Message-ID: <CAD=FV=U7_ek_z7UfaDn9My8UfZfpNom04OJHowoH-sNsGZQnxA@mail.gmail.com>
Subject: Re: [PATCH v2] mmc: dw_mmc: Disable SDIO interrupts while suspended
 to fix suspend/resume
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Jaehoon Chung <jh80.chung@samsung.com>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Heiko Stuebner <heiko@sntech.de>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Guenter Roeck <groeck@chromium.org>,
        Brian Norris <briannorris@chromium.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Sonny Rao <sonnyrao@chromium.org>,
        Emil Renner Berthing <emil.renner.berthing@gmail.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Ryan Case <ryandcase@chromium.org>,
        "# 4.0+" <stable@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ulf,

On Tue, May 28, 2019 at 3:49 PM Doug Anderson <dianders@chromium.org> wrote:
>
> > 1) As kind of stated above, did you consider a solution where the core
> > simply disables the SDIO IRQ in case it isn't enabled for system
> > wakeup? In this way all host drivers would benefit.
>
> I can give it a shot if you can give me a bunch of specific advice,
> but I only have access to a few devices doing anything with SDIO and
> they are all using Marvell or Broadcom on dw_mmc.
>
> In general I have no idea how SDIO wakeup (plumbed through the SD
> controller) would work.  As per below the only way I've seen it done
> is totally out-of-band.  ...and actually, I'm not sure I've actually
> ever seen even the out of band stuff truly work on a system myself.
> It's always been one of those "we should support wake on WiFi" but
> never made it all the way to implementation.  In any case, if there
> are examples of people plumbing wakeup through the SD controller I'd
> need to figure out how to not break them.  Just doing a solution for
> dw_mmc means I don't have to worry about this since dw_mmc definitely
> doesn't support SDIO wakeup.
>
> Maybe one way to get a more generic solution is if you had an idea for
> a patch that would work for many host controllers then you could post
> it and I could test to confirm that it's happy on dw_mmc?  ...similar
> to when you switched dw_mmc away from the old kthread-based SDIO
> stuff?

Unless you have time to help dig into all the possibilities here to
help understand how this should behave across all the different host
controllers / wakeup setups, maybe we could just land ${SUBJECT} patch
for now and when there is more clarity we can revisit?

Thanks!

-Doug
