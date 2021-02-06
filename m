Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7EE311C57
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 10:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbhBFJIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Feb 2021 04:08:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhBFJH6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Feb 2021 04:07:58 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B284C06174A
        for <stable@vger.kernel.org>; Sat,  6 Feb 2021 01:07:18 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id bl23so16496062ejb.5
        for <stable@vger.kernel.org>; Sat, 06 Feb 2021 01:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jq6wvABpdZowSwO47hMROpomTRzkeFebhk1vOkTPzU8=;
        b=o6xz+g7uCJcF+xkunBm69SHy9TJ9pVMDPdcmxRrB7EtAifix1Hq+tob+EqX/HUjL6B
         qR3xzmB2E84gscHp/FefDnKW+Iz2i0DQZXk3rpI17oSXIYKGpjNhFydJUd0jy6BAGyQm
         +BGO3xRNxRwjPwnVkmBl+Rz4vKGIFfsADzwalLMzBHNaPLQXdqnGILVzZJscED+hsaDK
         IoubdNuZW0cFZnMZK2hI4TwqFlnWsCIIOKefTxFEfY9U+rbr77cX582+RxlB2zVrtHaA
         SQkjBsq35/Ydiilh6nKcQ73Mi2yRYtp7UfS+/ilw2er+sD19mjmi5XA8Pr2U8enyeJzj
         YHGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jq6wvABpdZowSwO47hMROpomTRzkeFebhk1vOkTPzU8=;
        b=riJ1nSyEOTvHQpUcsCoGZBEFyjb+XDINsdML5JaBd+vzPyZH+8IqW/pnq2fJdZEWWy
         rLHmF5kANmhjtPuZL2MZ/Z2o7s720EEpgjke8Jm0alczWDbjojYm8bWCRJEXCV97qWQY
         FHkkyFzctpWOKeqWDsEH6L+HAI4vfpD3hSY+AXIh6fNIHkK7j9mHc0uteoYntjyGL45D
         +I+1TcOhdxCQhZPZf1yqn6UazjbWVqvGFGUti2SNB7CX9rnDaXqxNlkpVxv3kaDrzi7b
         3f5tCG7f+GHyVXkSlIjL/AqOb18vB2Lrznqh1l/dUukvfD4rdAFx5/tuzG/isduHhnSv
         8row==
X-Gm-Message-State: AOAM532HaxsfGbMNa9NFHuj2SX/2puK9zgzxZF8681nv4sKPYTHU9b0s
        c8jibRuK4NzKxuJOSETP3f/OIY8S+jE65S+5xzE=
X-Google-Smtp-Source: ABdhPJxSr9RulNyYez1PC78FyutXiM9bbPMGCbgA42VayjmZuuVODn63zHZj8Y8hWYZLJeA5F3rDx7b9VDejCTOAGDE=
X-Received: by 2002:a17:906:8690:: with SMTP id g16mr7908879ejx.113.1612602436668;
 Sat, 06 Feb 2021 01:07:16 -0800 (PST)
MIME-Version: 1.0
References: <CAEncD4esY38Z-Z9t=KOXriZczry7htCYfCh7+B=eC_kUds5miQ@mail.gmail.com>
 <YB4/ESyrjZJ1uMQK@kroah.com> <CAEncD4f6pceioDQghmwReRhmHPPMjFMmfJj_Xi_NBzsum17PYQ@mail.gmail.com>
 <YB5VcQTUbpe6lSVQ@kroah.com>
In-Reply-To: <YB5VcQTUbpe6lSVQ@kroah.com>
From:   Dave Pawson <dave.pawson@gmail.com>
Date:   Sat, 6 Feb 2021 09:07:05 +0000
Message-ID: <CAEncD4due+HgyOTiyDqz2JtAda=jeFkzLyuFU+H1OksiS8_PbA@mail.gmail.com>
Subject: Re: How to help with new kernel?
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

And I thought I was old fashioned <grin/>
<guess>
  top posting is more common than inline
</guess>

Thanks Greg.

On Sat, 6 Feb 2021 at 08:38, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> A: http://en.wikipedia.org/wiki/Top_post
> Q: Were do I find info about this thing called top-posting?
> A: Because it messes up the order in which people normally read text.
> Q: Why is top-posting such a bad thing?
> A: Top-posting.
> Q: What is the most annoying thing in e-mail?
>
> A: No.
> Q: Should I include quotations after my reply?
>
> http://daringfireball.net/2007/07/on_top
>
> On Sat, Feb 06, 2021 at 08:31:30AM +0000, Dave Pawson wrote:
> > Kernel how to you mention?
> > http://www.kroah.com/lkn/  is that the one?
>
> Yes.
>
> > Guessing that is more up to date than the O'Reilly one?
>
> Should be identical.
>
> Also see kernelnewbies.org, it has a lot of good tutorials and
> information to help you get started.
>
> good luck!
>
> greg k-h



-- 
Dave Pawson
XSLT XSL-FO FAQ.
Docbook FAQ.
