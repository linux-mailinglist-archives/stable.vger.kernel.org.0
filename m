Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC8712EA86
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 20:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbgABTdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 14:33:05 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:35688 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728135AbgABTdF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 14:33:05 -0500
Received: by mail-qk1-f196.google.com with SMTP id z76so32505686qka.2;
        Thu, 02 Jan 2020 11:33:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u9dwbogJdW6Yh1Ee8VSFJGnuy/iuVNRbfD1Fa4yAvYY=;
        b=JT0FLN0ZXha1caOUYbQA5kD/HcHTUSlb62XEjpUkqHR/9zHvqWkyZe/uhLoYygbTzF
         DAd+YJcowk3agIzwHK2Ye5qtXHoQAykOI2TfvlkoMCLKgMJ9lypSfRrAojtSioX2Ht1x
         EXyZhRVfJRXlFpjniP5Xro68S7oT4ZPUMyeVVhq7AyCrMeJB9o5xcwKHvSq3Xw5i12qu
         QTDT5i8b2jVFp60ZkZdkb6/kVfRZUEkMrmcm6cz29d2h1htgFq6E7P+dB3WquF/5Tti6
         SvNyxXv4sqAKY4UW9M9+SdTa8y9/nBwnWEQ+dMleE0AxCmz9awUpUUyUuITq4/5iufrt
         7oEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u9dwbogJdW6Yh1Ee8VSFJGnuy/iuVNRbfD1Fa4yAvYY=;
        b=baxyaAOODVoBV3sIvdSHl/6XM/RQW3BIxqvcQUAgT2GktPCzyZOm7P05qFb5dkcjD7
         H1Hmw/6IqlPtrK3J+BAceQQ0mee6fGLYVqXPRKBHPQ67fl4dlVcrAhNeM7WdheKjFZ2Y
         y4PR74EDpzuy2kn+U4eZrnFlO9hDQo0PQ4F5sF8V2nvPOA1HbNsLv2yqF8ieB0JnoMCB
         fYD75O1QrLop3fgiPBgRcZil5mkC9sg1Kghvy/MZR61rjmHr11nquHmKZLiVlymSQ1uX
         +JM2rIfeSOidcS4V0QmEa2RBLD0u7Iua8yVy3a0FJ1bxShzD3uLcwbzcMeBDBGxon1MT
         n/Jg==
X-Gm-Message-State: APjAAAWN7Px/TyeHl8m18jjplVeMFnZQVaD64jQSS/T9Zv7GYHucSfaN
        6P0SDxBZbL852WmdI8/ehyWUgOmZrgsmOgs3U1k=
X-Google-Smtp-Source: APXvYqyFmmxk9SA4wFTWWe4jAnqIFTv5urCIxOy0EjJq4Ol6TlHWI/y56dLg++S1Ps5KvG2pZxfPTVEWHJBe0glxgOU=
X-Received: by 2002:ae9:ed47:: with SMTP id c68mr65365242qkg.136.1577993584811;
 Thu, 02 Jan 2020 11:33:04 -0800 (PST)
MIME-Version: 1.0
References: <20200102172413.654385-1-amanieu@gmail.com> <20200102172413.654385-2-amanieu@gmail.com>
 <20200102175011.q7afo45nc2togtfh@wittgenstein> <CAK8P3a3a88e=hkzYG5mj=NuVQWMtyougkKzBznnn2y9ZoZfEGg@mail.gmail.com>
In-Reply-To: <CAK8P3a3a88e=hkzYG5mj=NuVQWMtyougkKzBznnn2y9ZoZfEGg@mail.gmail.com>
From:   "Amanieu d'Antras" <amanieu@gmail.com>
Date:   Thu, 2 Jan 2020 20:32:53 +0100
Message-ID: <CA+y5pbTwsN6dUWQ+hAWpuo4c7418GV1RdpmKFiJW+cEu+ibGJw@mail.gmail.com>
Subject: Re: [PATCH 1/7] arm64: Move __ARCH_WANT_SYS_CLONE3 definition to uapi headers
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christian Brauner <christian@brauner.io>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 2, 2020 at 8:25 PM Arnd Bergmann <arnd@arndb.de> wrote:
> On Thu, Jan 2, 2020 at 6:50 PM Christian Brauner
> <christian.brauner@ubuntu.com> wrote:
> > On Thu, Jan 02, 2020 at 06:24:07PM +0100, Amanieu d'Antras wrote:
> > > Previously this was only defined in the internal headers which
> > > resulted in __NR_clone3 not being defined in the user headers.
> > >
> > > Signed-off-by: Amanieu d'Antras <amanieu@gmail.com>
> > > Cc: linux-arm-kernel@lists.infradead.org
> > > Cc: <stable@vger.kernel.org> # 5.3.x
> > > ---
> > >  arch/arm64/include/asm/unistd.h      | 1 -
> > >  arch/arm64/include/uapi/asm/unistd.h | 1 +
> > >  2 files changed, 1 insertion(+), 1 deletion(-)
>
> Good catch, this is clearly needed, but please make the patch change
> every copy of asm/unistd.h that defines this, not just the arm64 one.

Actually __ARCH_WANT_SYS_CLONE3 only needs to be in the uapi headers
for architectures that use the asm-generic/unistd.h header, which uses
it to guard the definition of __NR_clone3. Architectures not using the
asm-generic header don't need this define to export __NR_clone3. The
only other architecture with clone3 that uses the asm-generic header
is riscv, which already defines __ARCH_WANT_SYS_CLONE3 in the uapi
headers.
