Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01281386F57
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 03:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345906AbhERBhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 21:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237906AbhERBhE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 21:37:04 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D239C061756
        for <stable@vger.kernel.org>; Mon, 17 May 2021 18:35:47 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id i9so11568231lfe.13
        for <stable@vger.kernel.org>; Mon, 17 May 2021 18:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3Y4UC937pcRi6mdp2HazCoUPjtNxk9PJkqRxwraum1Y=;
        b=gqVqIx8Ym2P95cU1nEwsXDnOMInJKjvLvl6PdHm+m4USuWxwS7QapJ/4AnjrYoQgjp
         Ul+p1xz0jsBYnf7HxkvT5KEQQnHy9T/2McLKcqfpIWocA0q+0ATrVtMzn0XcOX6uS6dk
         /MUMbUdum0s43SXkfV0oQ3/kVHBjAyHYj0f2I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3Y4UC937pcRi6mdp2HazCoUPjtNxk9PJkqRxwraum1Y=;
        b=Mopts66WUAIsWibkvNWwHVU872CFSkQCh5U+EG+I7pNXQKVvdKPRxPgMt9QYFdNrnQ
         05kHBEWRC1Uu7B3x9k/3IcRySrJDwRq0IllfIkyQMyAp8uNq8Ni9K9q2nggbcy5a6Beo
         37STFAwcWGF/TtAeOLdDflHccNKiLK/S8Ll0iyJH1UtZnwoAiz/rcg3xFYw6H40uC+a/
         KP2fYQV48Caijc6OzPhWWR44ncYL+TWU6X5OMeXH/dJ5KLRUgZ8DgUh6wdLAHME/evT7
         OJptZRImL1b3r7GQc+j/9N/KJ2U0l1i//fY411xp4jxbLhXdZxbNgtOGMLVaJGCIbE6x
         7h6g==
X-Gm-Message-State: AOAM532zRCYtAocs1bvnZ1HtT4HRzkq+VTZKBRFBALiIcevAeG6XDttS
        as72m4G80s/YRGCOdRmNN5QMnovNGK2ZtSsO
X-Google-Smtp-Source: ABdhPJwnV9soSWchaqKXd3mulrCsTQu7rBcftZzgSC4+fG4C6sxqeC05CoZg6SA0BxRA2LRNxluvog==
X-Received: by 2002:ac2:5e69:: with SMTP id a9mr2137536lfr.387.1621301745696;
        Mon, 17 May 2021 18:35:45 -0700 (PDT)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id d15sm2123330lfa.137.2021.05.17.18.35.44
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 18:35:45 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id q7so10265762lfr.6
        for <stable@vger.kernel.org>; Mon, 17 May 2021 18:35:44 -0700 (PDT)
X-Received: by 2002:a05:6512:36c5:: with SMTP id e5mr2066552lfs.41.1621301740633;
 Mon, 17 May 2021 18:35:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210518010940.1485417-1-sashal@kernel.org> <20210518010940.1485417-5-sashal@kernel.org>
In-Reply-To: <20210518010940.1485417-5-sashal@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 17 May 2021 18:35:24 -0700
X-Gmail-Original-Message-ID: <CAHk-=whw9_rp0NYTsCqcGnUkcV5Qgv7FTxADtPrdq4KFmsj+Lg@mail.gmail.com>
Message-ID: <CAHk-=whw9_rp0NYTsCqcGnUkcV5Qgv7FTxADtPrdq4KFmsj+Lg@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.12 5/5] tty: vt: always invoke
 vc->vc_sw->con_resize callback
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        syzbot <syzbot+1f29e126cf461c4de3b3@syzkaller.appspotmail.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 17, 2021 at 6:09 PM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>
> [ Upstream commit ffb324e6f874121f7dce5bdae5e05d02baae7269 ]

So I think the commit is fine, and yes, it should be applied to
stable, but it's one of those "there were three different patches in
as many days to fix the problem, and this is the right one, but maybe
stable should hold off for a while to see that there aren't any
problem reports".

I don't think there will be any problems from this, but while the
patch is tiny, it's conceptually quite a big change to something that
people haven't really touched for a long time.

So use your own judgement, but it might be a good idea to wait a week
before backporting this to see if anything screams.

          Linus
