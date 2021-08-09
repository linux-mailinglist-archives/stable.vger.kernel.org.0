Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666323E49BF
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 18:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232707AbhHIQXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 12:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhHIQXj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 12:23:39 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB485C0613D3
        for <stable@vger.kernel.org>; Mon,  9 Aug 2021 09:23:18 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id m18so13174153ljo.1
        for <stable@vger.kernel.org>; Mon, 09 Aug 2021 09:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fr1TL9AwSbRlFhElFariCtghFhLvrP2HPM19Xp8HZ2s=;
        b=E/87ssLExCiNkH7OTdg9OwZYbYD3VtUeH3/c3nOThUfoJ2S6oN+thlbMvS57nPzEMk
         Pcv4WFEcAjWT9tqNA5QZ4BHlGTXVzoNk6VnNX8xWRGsyZPuPMe8F5hLqobAS5ONOi5q0
         rHU6Icc8B2UzF+2SFndT3hHO1fRjcBbe8yRno=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fr1TL9AwSbRlFhElFariCtghFhLvrP2HPM19Xp8HZ2s=;
        b=ScqFPokpSq++HwOjPbFZ2xqIMwqemHV8MKcSn2OjxJtZRdagOCfM0yAsHpecFiblBf
         eQum0z0J9QC+xg6UYYYUnP5kJuwd7OsKpQ3Os8hBg/md0L/Lhi9OZ5uV3R7WTMxY/R74
         gTRoiHV9Kbit9yfcldgbebr9wIp8cICXiZwpplfAWAIjBYDTlMNZ5k8RyRM7ezXwnxFp
         QkXAr/UVd74ccaY0vvJmMixvcouAidhDtx4GkXrI7h9OKkHrG8jFy0PloYIAKgcsovm0
         xhLpTymF+rlDelHWIlRF7CXkFePXr1iUczyHxMdcoTd+ZNcipOjpSe4jVMPPFtKE+ioC
         Sknw==
X-Gm-Message-State: AOAM531JfizCid+qCbfRJrpcNg48DzauVQwwyovpVWXumgKa55TLdZJ8
        Y1h0m79TCufT5Pwzu3pplrKK0O2ITD7X5jnP
X-Google-Smtp-Source: ABdhPJy5msSv3lcdUZCvrFGeW7lsS+yUx8CP7w7zg4HpBnBWRlXdSBLsR+KdezzEJN8ddqkSB5WAXg==
X-Received: by 2002:a2e:3919:: with SMTP id g25mr16241501lja.382.1628526197019;
        Mon, 09 Aug 2021 09:23:17 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id q12sm9832lfr.175.2021.08.09.09.23.16
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 09:23:16 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id w20so8484826lfu.7
        for <stable@vger.kernel.org>; Mon, 09 Aug 2021 09:23:16 -0700 (PDT)
X-Received: by 2002:a05:6512:114c:: with SMTP id m12mr17469071lfg.40.1628526196188;
 Mon, 09 Aug 2021 09:23:16 -0700 (PDT)
MIME-Version: 1.0
References: <162850274511123@kroah.com>
In-Reply-To: <162850274511123@kroah.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 9 Aug 2021 09:23:00 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg9Ar-XBVQ860-TLA-eo8N=UYO8DQ5Ye0rBBuiwzv_N_A@mail.gmail.com>
Message-ID: <CAHk-=wg9Ar-XBVQ860-TLA-eo8N=UYO8DQ5Ye0rBBuiwzv_N_A@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] pipe: increase minimum default pipe size
 to 2 pages" failed to apply to 4.4-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 9, 2021 at 2:52 AM <gregkh@linuxfoundation.org> wrote:
>
> The patch below does not apply to the 4.4-stable tree.

It shouldn't.

The pipe buffer accounting and soft limits that introduced the whole
"limp along with limited pipe buffers" behavior that this fixes was
introduced by

> Fixes: 759c01142a ("pipe: limit the per-user amount of pages allocated in pipes")

..which made it into 4.5.

So 4.4 is unaffected and doesn't want this patch.

            Linus
