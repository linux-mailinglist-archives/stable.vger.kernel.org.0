Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5661EC1E7
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 20:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbgFBSgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 14:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgFBSgB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 14:36:01 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590ECC08C5C0
        for <stable@vger.kernel.org>; Tue,  2 Jun 2020 11:36:00 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id e4so13849354ljn.4
        for <stable@vger.kernel.org>; Tue, 02 Jun 2020 11:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ijFpZRjwoX99ihI6aAs0JBxKZ+/9IGA5AcjqDRRxjVE=;
        b=ErEmBwVZMzkC+6G17Sf/f4on+HIvZSZ8AKzHtw2WN/e8HA2YTsmF9nWW8KKw3DJLKe
         me5TqmdmNjfI5P78MUGsnW7a7Dii5HwIzqYhuYskjDyatp9sbSa71pmV8MU+CKmoKMWS
         kqSzc5ZAe9uDm/UNtKVFJjB4LyNBB/Ms7PbzE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ijFpZRjwoX99ihI6aAs0JBxKZ+/9IGA5AcjqDRRxjVE=;
        b=aSTlbJVJnrZXwtJJhRKVELg/M+FsokGPiS2G/PrFzLRGBRUuswnKjIBN6kfIWmwZ1y
         cDsWR6jGkOZGtuL0FPw3rv7gDJ3bVxnvB/u0csjhpgElVlrB2q92Ujq/eCvAHW75WCmS
         6vLgkLyDZzdORzi0tqPcuvVG52xl0Kw7AWbJb+jaopEMzC/SaZA9XTqRCUvBi5NeQ4GI
         iwkFl9vlOwB/CbXgT8adbBBny63QirttF6Rj5kKucx+wTHCqjSEruSgvBmDcVKk2rS8T
         ectKSZsd9qCPPuvy47kC+37hg3dkiCdjYbyVkVD0HMqx11egJBKZ5m5DQfuGE6wg7uYY
         Uhxw==
X-Gm-Message-State: AOAM533INe1WhS1sjAf/KtdYWntg9vrdedmBrfYO44VMx36zsplY/VIt
        ooGpSJ0q6qastFRXCBtV7WgNs2Mv8dI=
X-Google-Smtp-Source: ABdhPJxjK5sih8W+iMg2jFdl2y12XfLOELa5ItgpsWLopC2GDltsQ+lIPAeB8hjjJlTakoOLpEWsww==
X-Received: by 2002:a2e:a201:: with SMTP id h1mr229438ljm.294.1591122957986;
        Tue, 02 Jun 2020 11:35:57 -0700 (PDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id m15sm78261lfk.65.2020.06.02.11.35.56
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2020 11:35:56 -0700 (PDT)
Received: by mail-lf1-f45.google.com with SMTP id e125so6813519lfd.1
        for <stable@vger.kernel.org>; Tue, 02 Jun 2020 11:35:56 -0700 (PDT)
X-Received: by 2002:a19:4acf:: with SMTP id x198mr353040lfa.129.1591122955826;
 Tue, 02 Jun 2020 11:35:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200527165718.129307-1-briannorris@chromium.org>
 <CAGRGNgX5n=0OEi7hMrmgVZGD=orGpgvkyLrhmXVKSFYdBJ+eUw@mail.gmail.com> <CAJ-Vmomx0UFEa1w2HsGMQsZb+K8hyK=Zz9cKSo7tHv5GiMc1yw@mail.gmail.com>
In-Reply-To: <CAJ-Vmomx0UFEa1w2HsGMQsZb+K8hyK=Zz9cKSo7tHv5GiMc1yw@mail.gmail.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Tue, 2 Jun 2020 11:35:43 -0700
X-Gmail-Original-Message-ID: <CA+ASDXNicJmAKvkjD5mGFVQ+bmz8nHT_A1oqtjoS=spRSFP70A@mail.gmail.com>
Message-ID: <CA+ASDXNicJmAKvkjD5mGFVQ+bmz8nHT_A1oqtjoS=spRSFP70A@mail.gmail.com>
Subject: Re: [PATCH] Revert "ath: add support for special 0x0 regulatory domain"
To:     Adrian Chadd <adrian@freebsd.org>
Cc:     Julian Calaby <julian.calaby@gmail.com>,
        ath10k <ath10k@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Wen Gong <wgong@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 28, 2020 at 8:42 AM Adrian Chadd <adrian@freebsd.org> wrote:
> On Thu, 28 May 2020 at 05:02, Julian Calaby <julian.calaby@gmail.com> wrote:
> > On Thu, May 28, 2020 at 5:18 AM Brian Norris <briannorris@chromium.org> wrote:
> > >
> > > This reverts commit 2dc016599cfa9672a147528ca26d70c3654a5423.
> > >
> > > Users are reporting regressions in regulatory domain detection and
> > > channel availability.
> > >
> > > The problem this was trying to resolve was fixed in firmware anyway:
> >
> > Should we tell the user their firmware needs to be upgraded if it
> > reports this regulatory domain instead of completely dropping support
> > for it?

I'm not really sure how to do that properly in general, and I don't
plan to do so. I'm simply reverting a change that caused people
problems, and noting at the same time that the original problem was
resolved differently.

I don't really have a stake in this patch, because everything I care
about works correctly either way. (And AFAICT, any hardware that is
affected by this patch is somewhat broken.) I'm only posting the
revert as a community service, because Wen couldn't be bothered to do
it himself.

> Also that commit mentioned a 6174 firmware, but what about all the other older chips with a regulatory domain of 0x0 ?

My understanding was that no QCA modules *should* be shipped with a
value of 0 in this field. The instance I'm aware of was more or less a
manufacturing error I think, and we got Qualcomm to patch it over in
software. I don't think people expected anybody else to have shipped
modules with a 0 value, but apparently they did. I don't know what to
do with those, other than just leave well enough alone (i.e., $subject
revert).

> As a side note, I'd /really appreciate/ if ath10k changes were tested on a variety of ath10k hardware and firmware revisions, rather than just either the Rome or embedded radios, rather than also including peregrine, cascade, besra, etc.

Wouldn't we all love it if everybody else tested appropriately. But
Qualcomm folks can't be coordinated (trust me, I've tried), and apart
from things like KernelCI (which so far has no WiFi tests, IIUC),
there's no community testing efforts that don't involve
"${RANDOM_PERSON} boots ${PERSONAL_BOX} and see if it blows up."

This also might not be the best place to admit it, but I'll be up
front: I have no idea what peregrine, cascade, or besra are.

Brian
