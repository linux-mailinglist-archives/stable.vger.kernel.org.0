Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7A72748B3
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 21:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgIVTCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 15:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbgIVTCt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 15:02:49 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9746C061755
        for <stable@vger.kernel.org>; Tue, 22 Sep 2020 12:02:48 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x14so18244425wrl.12
        for <stable@vger.kernel.org>; Tue, 22 Sep 2020 12:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fooishbar-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rm/MUGiqEj6w9zoNKJAAAmLZqiJ10V/BIIAqAEoPPYo=;
        b=nHx+oCJ4c6Paf+lALa+5KspNBYN+hXRQkk9hBttFTN+rje5X8/9FAUvaCBwnGOPWQ1
         F4R0U65sfyBNDYw+IPkqYN/j3Q/YMan4JXmbRcOW/ASi5k1hxBIiRxiCHJJqQK1aycZl
         VBAJ78k7zPaOieZI67vbAaNfJPc8l78oZiXdnreDjhWtR6rsN9vfcznLyR49mkwjUtFs
         E2jco4SRrE6jQD2v3CBXzKCrByqErFTzls6gcpddlM0Nz8pB508/uQX3YGIbykHJImTo
         tHnjh25yK6E3gcJ8UoyNvbJRSMpiFSGPo2YN4QrEg7DYjbZBzI0cK7+uQtTUwkZrNa73
         1akA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rm/MUGiqEj6w9zoNKJAAAmLZqiJ10V/BIIAqAEoPPYo=;
        b=LL5ld1vexcKEvL3acVqHGidQwUHKHeL2c2qWPa453yiVgSOo+qJXdsmc5zwytMN7q8
         JVGfn4rWOzNe+yJPyW3dWgf867ScFnrzYMaMEEQsLTtFjtA+dgphm/w5MEIHszNGG8Sx
         Yx0mWgiq+Y23RG3OG6a0jkT/MD7vv9QrEz1qiZ5j2ecwXbmWG0GXnALlP01qiWO30QKc
         POwFREC7cjQqyt5MkIHldmxyYziZF9kiIAl+tpEGLXCkc2KAJHuTQO0soAEx2FqRZ0el
         zHf30P44bjOe7tLGjY4Kk2d4TW2MLTXN9WYHvSn+dXLeX/dIsx5tqyCX0GGYr1Ozx2ES
         JToA==
X-Gm-Message-State: AOAM532vOfVPE+arBck1r0J1n32DJ//apznctIUoP34tjPWudgc2UlwB
        uGZOMiuYJ1Bk0jfIe/GzuYGh/CgdVYSH/yPw1IKG+g==
X-Google-Smtp-Source: ABdhPJwvwQBt4Q6HDn51fnSs2PQD3j8FLapI/mLE772a0J4HTg0bK9kCG9427Njb47eon1VCQkDPa5MIGFa14BvVrEY=
X-Received: by 2002:adf:e292:: with SMTP id v18mr6915557wri.256.1600801367216;
 Tue, 22 Sep 2020 12:02:47 -0700 (PDT)
MIME-Version: 1.0
References: <20180705101043.4883-1-daniel.vetter@ffwll.ch> <20180705102121.5091-1-daniel.vetter@ffwll.ch>
 <CAPj87rN48S8+pLd0ksOX4pdCTqtO=bDgjhkPxpWr_AnpVvgaSQ@mail.gmail.com>
 <20200922133636.GA2369@xpredator> <CAKMK7uHCeFan4+agMn0sr-z9UDyZwEJv0_dL-K-gA1n0=m+A2w@mail.gmail.com>
 <CAPj87rNLzFjn7xyePmEBEY8teL7TnL-HrQHXbp7C1tXDdWgeUA@mail.gmail.com> <CAKMK7uEyt0d0LidUCQL4oHZRYZdDEFhy=DnRF7WwD1S1+ackFQ@mail.gmail.com>
In-Reply-To: <CAKMK7uEyt0d0LidUCQL4oHZRYZdDEFhy=DnRF7WwD1S1+ackFQ@mail.gmail.com>
From:   Daniel Stone <daniel@fooishbar.org>
Date:   Tue, 22 Sep 2020 20:02:35 +0100
Message-ID: <CAPj87rNO+_2dBSJtaNi5PemvS3oG2uuoCwP_AmtOw3qbjUQ-ZA@mail.gmail.com>
Subject: Re: [PATCH] drm: avoid spurious EBUSY due to nonblocking atomic modesets
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     Marius Vlad <marius.vlad@collabora.com>,
        Pekka Paalanen <pekka.paalanen@collabora.co.uk>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        stable <stable@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Tue, 22 Sep 2020 at 17:02, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> On Tue, Sep 22, 2020 at 4:14 PM Daniel Stone <daniel@fooishbar.org> wrote:
> > I think we need a guarantee that this never happens if ALLOW_MODESET
> > is always used in blocking mode, plus in future a cap we can use to
> > detect that we won't be getting spurious EBUSY events.
> >
> > I really don't want to ever paper over this, because it's one of the
> > clearest indications that userspace has its timing/signalling wrong.
>
> Ok so the hang-up last time around iirc was that I broke igt by making
> a few things more synchronous. Let's hope I'm not also breaking stuff
> with the WARN_ON ...
>
> New plan:
> - make this patch here only document existing behaviour and enforce it
> with the WARN_ON
> - new uapi would be behind a flag or something, with userspace and
> everything hanging off it.
>
> Thoughts?

What do you mean by 'new uapi'? The proposal that the kernel
communicates back which object IDs have been added to the state behind
your back? That it's been made automatically blocking? Something else?

Cheers,
Daniel (the other one)
