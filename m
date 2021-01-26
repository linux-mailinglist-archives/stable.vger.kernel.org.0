Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A715304BED
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725792AbhAZV6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 16:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729625AbhAZSqK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 13:46:10 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2C2C061756
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 10:45:30 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id o10so24108429lfl.13
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 10:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pguE7kAo2MFIwoKv2SY5mrzXdRjuGW27qIj/VJIdu1o=;
        b=XpWfM2ddOGS78nlzGQhmJNnXW5of3S6mig2nFp7pLl9UpJh6MSsQbDSLyti1DUSpj0
         HWM9ruzLLEQgneQFksUQwS0F/u2x1/5yq21RV8qqBu2SesPxZmAbJw4lLUMxWxX1iJ/n
         av5J4ZdxmaHAm6KwSDF8FXK04djMtGmXA4hCE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pguE7kAo2MFIwoKv2SY5mrzXdRjuGW27qIj/VJIdu1o=;
        b=nIg8GMcWCCEHdhIZrit+fMQxSpxLbRyw96BJ8nG2F8XyFLDCtDyW3OEVc/1VieLhGX
         8MJhfZfXTCobm+au2ynJRgkERySWjpMtnf5BlYKffmjQVq6DNpbaGWJ/N4xchhm2xj/G
         it4mranTwmDpGoYIFjXWnnO/wFlcwTTOlC1KjTBTrZfIgDO4rX/XY4jS6ij523BGT5vt
         fhOoeTRKf43DeNx6WfCG1rz99yoLMpxTgKd1VoUb3ydW5IqednL/L5ro1jV8HklZy/dy
         crwSpfsjTt6iUwnOJNXnqhgUod3/uoR8NqHHthue67s/fuLhtV3IA81p8+cTgRV7SbvS
         H/kw==
X-Gm-Message-State: AOAM530zmWUlO1NHsdkIhvUFXyTZ9Rf5+Jp3v+qSIlUl9UeUR+gtjCng
        6pCJeXKKPDSggVK62gBlG4GwjpdKZulbvw==
X-Google-Smtp-Source: ABdhPJywN+Q+fYE4wL0ITRRVkiUbjmPegcbWHuD8Vhz3WMTlrBKB39glb1ZVjN1VkIt5ZcIRsY6sgA==
X-Received: by 2002:a05:6512:224f:: with SMTP id i15mr3327506lfu.545.1611686728378;
        Tue, 26 Jan 2021 10:45:28 -0800 (PST)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com. [209.85.208.181])
        by smtp.gmail.com with ESMTPSA id n84sm2698952lfd.176.2021.01.26.10.45.27
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 10:45:27 -0800 (PST)
Received: by mail-lj1-f181.google.com with SMTP id s18so7718335ljg.7
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 10:45:27 -0800 (PST)
X-Received: by 2002:a2e:b70b:: with SMTP id j11mr3487266ljo.61.1611686726895;
 Tue, 26 Jan 2021 10:45:26 -0800 (PST)
MIME-Version: 1.0
References: <CAHk-=wgmJ0q1URHrOb-2iCOdZ8gYybiH6LY2Gq7cosXu6kxAnA@mail.gmail.com>
 <161160687463.28991.354987542182281928@build.alporthouse.com>
 <CAHk-=wh23BXwBwBgPmt9h2EJztnzKKf=qr5r=B0Hr6BGgZ-QDA@mail.gmail.com>
 <20210125213348.GB196782@linux.ibm.com> <161161117911.29150.13853544418926100149@build.alporthouse.com>
 <20210126162440.GC196782@linux.ibm.com>
In-Reply-To: <20210126162440.GC196782@linux.ibm.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 26 Jan 2021 10:45:10 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgKbFUUhkRKvh4SHQcsUyG_kraLOTBLHUhc4GQ58ANBEw@mail.gmail.com>
Message-ID: <CAHk-=wgKbFUUhkRKvh4SHQcsUyG_kraLOTBLHUhc4GQ58ANBEw@mail.gmail.com>
Subject: Re: Linux 5.11-rc5
To:     Mike Rapoport <rppt@linux.ibm.com>, stable <stable@vger.kernel.org>
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 26, 2021 at 8:25 AM Mike Rapoport <rppt@linux.ibm.com> wrote:
>
> On Mon, Jan 25, 2021 at 09:46:19PM +0000, Chris Wilson wrote:
> >
> > CI does confirm that the revert of d3921cb8be29 brings the machines back
> > to life.
>
> I still cannot see what could possibly go wrong, so let's revert
> d3921cb8be29 for now and I'll continue to work with Chris to debug this.

Ok, reverted in my tree.

And added stable to the cc, so that they know not to pick up that
commit d3921cb8be29, despite it being marked for stable.

            Linus
