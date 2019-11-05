Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3C52F06D3
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 21:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbfKEUYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 15:24:02 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:35713 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbfKEUYC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 15:24:02 -0500
Received: by mail-ed1-f65.google.com with SMTP id r16so2619864edq.2;
        Tue, 05 Nov 2019 12:24:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=XKfktDI409ME+qQztoRq4fg8/cQgqVINMQeKrpPMrnc=;
        b=FQKhwj3k4hKbZA1mrgQOZLHnG+4W8hT3gVbMNpxkDDWnJ2olouxPxA449IeeEHRJYT
         P1f8iRwRwBSD+7vT7Bg+BvPYQER+y0EpSPe9hl6KCVicdzr/JLDBAjxKZjlw4fz6D5hU
         khrMkxo1eencvHL6sjxwhajH1Qcqnb3L/y8zVMbLptdsTexTv7hIZ3gvFLdrBryIetua
         Nz5GDrwNXbaN79YDs1kL7f/LmD0HZ3c2Mr/nhX3tZQekmVTDiciczeY3N2b19HgQ7YbF
         pQl2cVGL9JF309FEcva032/QN5KeMKyU3ejYLzjVvewaF2RAFjQHHcIp41nh5V1Zu+Qb
         78yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=XKfktDI409ME+qQztoRq4fg8/cQgqVINMQeKrpPMrnc=;
        b=Q/lFm/094DAstkgymjnBcfOg72FygALK+H2V27Rq8wry9o5LXqjeJ+3xwmFfSzusSB
         jzNBIQhLBN56ZP/5lLu6aiSIjOE71CwZQrB4U/ZRlC3QljR1OAAKoVPqxDPJBuUcCnO4
         ewIRl3hT8FfP5yXoP3kGg9KPfQcH5x6jcr1YoiWO9OrmcRZTN72xCFDgUrYry6fLtHJg
         wbSNur2ak3Yf0b4dXDHhOinZ4x9ATg0PIP6BtdD682TF/9RqS5Z9ADaPq2Abs3eCofK9
         NCv6UbrjhrcTl1DZRlZchl2q7jz+rVKsBLO5/dgztJn783F264UrydIMajGRdOynKhVR
         xRHQ==
X-Gm-Message-State: APjAAAUQaO5yYnOicosK/EggI41kQe0APrhu9JUbdAIVa6XZS0gI6dr6
        TD6dR4UaPd6Gg+FhvXIg0gfno8A1SnSTXpazW6s=
X-Google-Smtp-Source: APXvYqyt1yWEaDynXsJl7oXqRJwW/uh9HMzobH6OzyDWDWqiHW4VwEYvJvizt0rX9uETjDeHjqmbXEhJOpwuif2Jnbw=
X-Received: by 2002:a17:906:8319:: with SMTP id j25mr10228438ejx.170.1572985440565;
 Tue, 05 Nov 2019 12:24:00 -0800 (PST)
MIME-Version: 1.0
References: <20191031113608.20713-1-christian.brauner@ubuntu.com> <CAK8P3a2P0djkhfHhQUGdO3YX7QGtLeF2OH1HaJmbmRq5Nuojbg@mail.gmail.com>
In-Reply-To: <CAK8P3a2P0djkhfHhQUGdO3YX7QGtLeF2OH1HaJmbmRq5Nuojbg@mail.gmail.com>
Reply-To: mtk.manpages@gmail.com
From:   "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date:   Tue, 5 Nov 2019 21:23:49 +0100
Message-ID: <CAKgNAkg4aktVXU1m0_MKt6zitqVOgqF_LJjEnGVa-5Mtb5pkdA@mail.gmail.com>
Subject: Re: [PATCH] clone3: validate stack arguments
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        GNU C Library <libc-alpha@sourceware.org>,
        Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>,
        David Howells <dhowells@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux API <linux-api@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 5 Nov 2019 at 15:25, Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Thu, Oct 31, 2019 at 12:36 PM Christian Brauner
> <christian.brauner@ubuntu.com> wrote:
> >
> > Validate the stack arguments and setup the stack depening on whether or not
> > it is growing down or up.
> >
> > Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

and
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
