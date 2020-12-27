Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370262E32AB
	for <lists+stable@lfdr.de>; Sun, 27 Dec 2020 21:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgL0UNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Dec 2020 15:13:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726123AbgL0UNA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Dec 2020 15:13:00 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33665C061795
        for <stable@vger.kernel.org>; Sun, 27 Dec 2020 12:12:20 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id s26so19835023lfc.8
        for <stable@vger.kernel.org>; Sun, 27 Dec 2020 12:12:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ASNmgMMwfzw0LbrYHtLnhPGdwLHLSLekD8OCrKhQBS0=;
        b=BYaAyo5dGZ2AVajdkz7XJpp87lRLqPcUThVTo4lD3YD5OauF4LnkAOIra7E7n4G/9q
         T7MpcJLXkjoX64GXVD0UrN+L8ckt2LCePtd9QynxUmxbZD2vNYa7t/+eaEJ20pBj0C1o
         uNCXBsFV0vquG0IBR/Xq4jM9V+W+kodBhXqLQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ASNmgMMwfzw0LbrYHtLnhPGdwLHLSLekD8OCrKhQBS0=;
        b=YXvqGzih8SSVeVEn5j/6hrbv/PBzmEHS/+ANkDGtvioHfHQ0DhZu0VgkmnSK5pQi9W
         pXn4ZEyHMFWtfZfsI2A3Ud/Z/9tkV4oz0cGsslomQorEDT+HxVLdR64ZsqcbMFJCXL6w
         d/5DQqrth0W5R9DnvmZGHdGcxF9kHU4zDY2pXehLZ42iUo1kmn6gVdGXXaHXVLCZN8aM
         s+MBN/j0S62o/joynJ/N5pCIo+aksljY2bWBHtJ+xCMO0Rhy5Dup8wURJFYi5gPQOiRe
         QV2Jdd/b23UgRJovkGI/n4sAQmL35/ykgU2xFAzT/NAl79AdLbWKI9+BuecLTs3uWW7r
         dcWg==
X-Gm-Message-State: AOAM532JBy7cptdJPmCkjqwfx+HkmysoWPZo+6KBs9Qrk1HUHwj870sx
        mWb7eklWES+Ez0KLzbANJt0x1k5mUbuUqw==
X-Google-Smtp-Source: ABdhPJzXhDZHpKswMB8zoiQi7Gv7IALENo2CEoqhe+P4IaXMdDPo8FsBTm0demV/2dLNzUwwAFtOAg==
X-Received: by 2002:a2e:b538:: with SMTP id z24mr21566041ljm.478.1609099938176;
        Sun, 27 Dec 2020 12:12:18 -0800 (PST)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id o11sm6108215ljp.5.2020.12.27.12.12.16
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Dec 2020 12:12:16 -0800 (PST)
Received: by mail-lf1-f42.google.com with SMTP id y19so19729458lfa.13
        for <stable@vger.kernel.org>; Sun, 27 Dec 2020 12:12:16 -0800 (PST)
X-Received: by 2002:a2e:9b13:: with SMTP id u19mr19433416lji.48.1609099936085;
 Sun, 27 Dec 2020 12:12:16 -0800 (PST)
MIME-Version: 1.0
References: <16089960203931@kroah.com> <5ab86253-7703-e892-52b7-e6a8af579822@iki.fi>
 <CAHk-=wgtU5+7jPuPtDEpwhTuUUkA3CBN=V92Jg0Ag0=3LhfKqA@mail.gmail.com>
 <b45f1065-2da9-08c0-26f2-e5b69e780bc6@iki.fi> <CAHk-=wgy6NQrTMwiEWpHUPvW-nfgX7XrBrsxQ6TkRy6NasSFQg@mail.gmail.com>
In-Reply-To: <CAHk-=wgy6NQrTMwiEWpHUPvW-nfgX7XrBrsxQ6TkRy6NasSFQg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 27 Dec 2020 12:12:00 -0800
X-Gmail-Original-Message-ID: <CAHk-=whF=+EzrxP=3zNMH-1L2Nfs7fNoSufqDwOdRQo5qyMwfw@mail.gmail.com>
Message-ID: <CAHk-=whF=+EzrxP=3zNMH-1L2Nfs7fNoSufqDwOdRQo5qyMwfw@mail.gmail.com>
Subject: Re: LXC broken with 5.10-stable?, ok with 5.9-stable (Re: Linux 5.10.3)
To:     Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Christoph Hellwig <hch@lst.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 27, 2020 at 11:05 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sun, Dec 27, 2020 at 10:39 AM Jussi Kivilinna <jussi.kivilinna@iki.fi> wrote:
> >
> > 5.10.3 with patch compiles fine, but does not solve the issue.
>
> Duh. adding the read_iter only fixes kernel_read(). For splice, it also needs a
>
>         .splice_read = generic_file_splice_read,
>
> in the file operations, something like this...

Ok, I verified that patch with the test-case in the bugzilla, and it
seems trivially fine.

So it's committed as 14e3e989f6a5 ("proc mountinfo: make splice
available again") now.

             Linus
