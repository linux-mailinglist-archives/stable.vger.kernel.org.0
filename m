Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 313C847EE5
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 11:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbfFQJ45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 05:56:57 -0400
Received: from mail-ua1-f65.google.com ([209.85.222.65]:32924 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727518AbfFQJ45 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 05:56:57 -0400
Received: by mail-ua1-f65.google.com with SMTP id f20so3268104ual.0
        for <stable@vger.kernel.org>; Mon, 17 Jun 2019 02:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z21QKZpzsWJkFspGJCXR4viBrbkp3V/wOshkxeqXaxI=;
        b=MNKpsEs1beQt75Tov9jUiJFRyiPLXJaln9C0KBxgTAxzAlgNP6cX/TNLKM6l2Jofwj
         6Guj8leyIsjloknHm7GBi1hDP9UIWI+VhYxhTrKqfJbuKq7kNJ2S0SlZ43eVEwAXBSWp
         vfxbPWJdKgryQrf5oGXodEYRSBY8DmMbWHrA/cHCMkEtoqvM5tpe8R1fOMUD1zdrQ633
         eJLtDsUEsSjxzxb+Tq+qOdagy3NMJx4rR4T32zMrRJK0SniCE5UurXnHzuvFCyST5zb4
         EUYmsb7FZMUmHaQnIFg5ni/VVYLGhI7D7e9UbNO276GfSnSKtSvMdjz6yOR2JyH/XRKu
         DUDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z21QKZpzsWJkFspGJCXR4viBrbkp3V/wOshkxeqXaxI=;
        b=kzFK8Hhz1h2q3RwNnnaQ5C3KQ05HobG85H/PHqw00RjrSV/t2VKlNsrB0pRp/yzgvq
         4v5C5m+xlHFmdugfTYebT2Z9IBSFEAqI7ycoj9GYV/FCE614LpU0s2Y6E1AtrJiNcZie
         6SDAkpII/FjSDiVMv21ZdETncyGeoNF56umIJRCw3nqeyybcxrdx4FRyD2GUVN5I2eau
         JWh5pvfQinxVxUtnxdmmsq+E+28QBkq64nrzETsXJBGtoNQpzGs050n3/SCs+sKGAx9B
         wPGKSCVAy5MeaRkDWsZa9xE35QYmcWixV9K6H0NvwWdXoJQRtgspWfP8h5dLptx9dxwW
         WVxA==
X-Gm-Message-State: APjAAAWDx1uK+uT+tCWMEI/HDpEBTjYpO2OkySSuVHHsBZdHKcyQAGZf
        dlA8vDXKmd/uYAGDxAnIxU2aXg6H1PsetKweA69yPQ==
X-Google-Smtp-Source: APXvYqy381/fRbd9bXkgblOOPVYXW1nYN3mo42IzEV5wHEtqrkzbdvVLm3v545vuGR4I13Dk0fokOYR5CIpPiIH9bTg=
X-Received: by 2002:ab0:4108:: with SMTP id j8mr1472261uad.104.1560765415986;
 Mon, 17 Jun 2019 02:56:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190611123221.11580-1-ulf.hansson@linaro.org>
 <CAD=FV=XBVRsdiOD0vhgTvMXmqm=fzy9Bzd_x=E1TNPBsT_D-tQ@mail.gmail.com>
 <CAPDyKFqR-xSKdYZYBTK5kKOt1dk7dx_BjedHiDOKs7-X4od=dg@mail.gmail.com>
 <CAD=FV=WODbZa1fBrLbJBsd77xn5ekHWjks-ydxOSzjdBK83Rmg@mail.gmail.com>
 <CAPDyKFpqk4ZcVTqifnbnW1WgNfx9ZNebCttUPcK_e9KWqpDMjQ@mail.gmail.com> <CAD=FV=Ujb=_jEFMdxLPW6tYwb9DZo5-RZ8BVuyq5DdFQ5jJbQw@mail.gmail.com>
In-Reply-To: <CAD=FV=Ujb=_jEFMdxLPW6tYwb9DZo5-RZ8BVuyq5DdFQ5jJbQw@mail.gmail.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Mon, 17 Jun 2019 11:56:20 +0200
Message-ID: <CAPDyKFoyq5__e-2ZSZMzMzBg3X=7zou6wQ4J6o57a0CfTvEO7g@mail.gmail.com>
Subject: Re: [PATCH] mmc: core: Prevent processing SDIO IRQs when the card is suspended
To:     Doug Anderson <dianders@chromium.org>
Cc:     Linux MMC List <linux-mmc@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Brian Norris <briannorris@chromium.org>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Guenter Roeck <groeck@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 14 Jun 2019 at 17:42, Doug Anderson <dianders@chromium.org> wrote:
>
> Hi,
>
> On Fri, Jun 14, 2019 at 4:56 AM Ulf Hansson <ulf.hansson@linaro.org> wrote:
> >
> > > I was more worried about the safety of mmc_card_set_suspended()
> > > itself.  That is:
> > >
> > > #define mmc_card_set_suspended(c) ((c)->state |= MMC_STATE_SUSPENDED)
> > >
> > > ...so it's doing a read-modify-write of "state".  Is that safe to do
> > > without any type of locking?
> >
> > In this case, yes I think so.
> >
> > The point is, it really doesn't matter if the reader (work or thread),
> > reads a non-updated value, because the synchronization is managed by
> > the later mmc_claim_host() and the cancel_delayed_work_sync().
>
> If this were just an "int" then perhaps, but this is a bitfield.  So
> if someone else updates the bitfield at the same time then we can
> fully clobber their modification or they can clobber ours, right?
>
> task 1: load "state" from memory into CPU register on cpu0
> task 2: load "state" from memory into CPU register on cpu1
> task 1: OR in MMC_CARD_REMOVED
> task 1: write "state" from CPU register on cpu0
> task 2: OR in MMC_STATE_SUSPENDED
> task 2: write "state" from CPU register on cpu1
>
> ...so now we've clobbered MMC_CARD_REMOVED.  ...or am I just being
> paranoid here and everything else in "state" is somehow guaranteed to
> not be touched at the same time this function is running?

I understand your concern. It's not obvious by looking at the code,
but yes, there should be no other writing to the "state" at the same
time mmc_sdio_supend() is running.

MMC_CARD_REMOVED for example, is set from  _mmc_detect_card_removed(),
but because the detect work (mmc_recan()) has been disabled and the
block device driver has been suspended, it can't be called.

Anyway, perhaps we get reasons to add a lock to the card struct when
going forward, but at this point I think we are fine.

Kind regards
Uffe
