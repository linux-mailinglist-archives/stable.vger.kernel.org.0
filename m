Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBF82F9166
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 09:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbhAQIg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 03:36:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728360AbhAQIdq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 03:33:46 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1694BC061575
        for <stable@vger.kernel.org>; Sun, 17 Jan 2021 00:33:06 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id o13so19628773lfr.3
        for <stable@vger.kernel.org>; Sun, 17 Jan 2021 00:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rS05PqujD46wPlETHvUTHQy5R286NPht4QhaRgf48EQ=;
        b=r7ra7Ho/FA53vb/fCguBB8fLBBudQPj2QUk6JHH1ln9FICIQLpnxzIMfIaPePXD4m6
         G58sru/yDNgg9YOgfFQbR8Fs4yrMcbGp0LMZ6a7mh6Ea0yUVJJu3gza3VYpOIWxZ4rH4
         j2YTWAFHo5s9lxCOdbXrw70g0hlQPN6bYMjQOs20iecIHDG6MrCKqhHnCYoZt5TwPN76
         3MPhzRBQHK5RDTjmGKjK0Fqt9MN/X1Hfnw8JVRpnTYal8lj/ao9CtcA3OAysWwTreKrn
         kEWsm7mvAwruYzQGPi8cZJTmHq7v4r9Yfikc4m4R/BnuOSLjo+H+fwyR9fUotPT8y6fQ
         xF9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rS05PqujD46wPlETHvUTHQy5R286NPht4QhaRgf48EQ=;
        b=JyDgn8a3nFSFEYhmargrUY9bFwGWkVGFqkKvzfppREkGX47lQJzAwK4+m70nvikrxJ
         LqkPuBDhxdnCEXTwhQj6YCAl7be7j3jh14ZwRhWKlY2LjCiYRoHQ8Elq8nbWqEbhRWa6
         zn+YJ+hC01OLreePkxLu7pwXTLWl/LrbgzKb5ooIljbPoyEFPKK+mOec3KmdMG5W/0+F
         PAKgsVM7T/PDI+FUXtO/waDfvTRG82k2W7EtC5opm88jICw0Az8pT3imsT6Qig2+CN4N
         aWS+KEkmSg9i9sSjzkTxqMRCD2G3RM8Ntc75t21sEdxXjE/KaqzHbDi2HNSiufea+i5r
         UusQ==
X-Gm-Message-State: AOAM530dHzwFEgGbLDxMauCDVAnhz1kTO2f+SN9leUab4PZL0h7F18uh
        2L7Jqg6Tg7qFaUrbFHJwA4Kk/bJPBcGDv7sQGkg=
X-Google-Smtp-Source: ABdhPJz7VqsIrMMOjAep/WzDSsIAJ+SuvUiQIYWsAtdJhFio8VszaL3K9HwS5Ua6X0tE0IiszVfVCWnBR4vza3bfWCA=
X-Received: by 2002:a19:e8a:: with SMTP id 132mr8551544lfo.108.1610872384283;
 Sun, 17 Jan 2021 00:33:04 -0800 (PST)
MIME-Version: 1.0
References: <20210117045228.118959-1-dong.menglong@zte.com.cn> <YAPzmuGEKw/iRIvF@kroah.com>
In-Reply-To: <YAPzmuGEKw/iRIvF@kroah.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Sun, 17 Jan 2021 16:32:53 +0800
Message-ID: <CADxym3b_vtBbZzXHU6Q4vQw1FiF2c3jKGq2W5GxYkhRLW3ts1Q@mail.gmail.com>
Subject: Re: [PATCH] coredump: fix core_pattern parse error
To:     Greg KH <greg@kroah.com>
Cc:     2225233704@qq.com, Menglong Dong <dong.menglong@zte.com.cn>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Wise <pabs3@bonedaddy.net>, Jakub Wilk <jwilk@jwilk.net>,
        Neil Horman <nhorman@tuxdriver.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm so sorry! I just send this patch by mistake~

On Sun, Jan 17, 2021 at 4:21 PM Greg KH <greg@kroah.com> wrote:
>
[...]
>
> What is the git commit id of this, and what stable trees do you want it
> merged to?

I just wanted to make a test, and never expect that 'git send-email'
add CC automatically

Sorry! (sincerely)
Menglong Dong
