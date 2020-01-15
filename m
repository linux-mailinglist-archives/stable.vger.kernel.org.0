Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8CFA13CD42
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 20:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgAOTmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 14:42:06 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:39746 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgAOTmG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 14:42:06 -0500
Received: by mail-lf1-f68.google.com with SMTP id y1so13654143lfb.6
        for <stable@vger.kernel.org>; Wed, 15 Jan 2020 11:42:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IaRwIBTidRg+FeQMjaWJXF4LpWPIm2ptNeGHjO7tn9s=;
        b=Jws/Fhg/9IKJk9+nS1RTqQGl/D/R2qUDHpS3GKFKtCU0aMrpgYvxxwk+s7k/EB3PQG
         PvYHuYbuMYFbFlZxmS9QO1Dbd5gN7atnObLK9kI8sUR0ADxQryVnxUBd63vqDyd6qx16
         WmkdXjfC8d3E/yNKayDZNJMSD7y4f95VjoUt4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IaRwIBTidRg+FeQMjaWJXF4LpWPIm2ptNeGHjO7tn9s=;
        b=U4vb7xNt5pQiSWvFmp8vmVKbDxrv9bN3fZscBZ9vvBxUEwIXpN1E2U8KL77fPDM/Aw
         HLSMgCLm6VbPfHsrHVGSP4ltCn9dTJF/NZGNnebtZ641pG8VmS7GFBX139fIHZ1TkGP0
         INxe7lIJLISPzmAW5UJJzjXn5SW5NMUfd+xX1QABg5Ht1A7WtJjRnE0N7swJygrflxTC
         UI+txk9tNHVoPnVZoyReLFNgH59LD4heaOx1dY9Zx18SIYqmpVddx2NgdjdhBo5p5awj
         7gCvF0RCDQpc5MSAR7g3uB/Vd1yVQKM2oo84PbQKXcaXvBefkGbK7emTyw/QQUiSzaMc
         H+6Q==
X-Gm-Message-State: APjAAAWgozmRG7BIJy9bVGoXHpD3BwNdLO314ltoWQoa0Yuz8CBF+eOH
        L1eis/am6cfuTi/iO40x24XsKBYOy+E=
X-Google-Smtp-Source: APXvYqxsvPs8Vav578LKpFNSSQoTZe+HLysOSZx2zB5WWNVzpv9O2mrfQrhgOu0dA0+0x4bEk56XLw==
X-Received: by 2002:a19:5513:: with SMTP id n19mr270415lfe.205.1579117323445;
        Wed, 15 Jan 2020 11:42:03 -0800 (PST)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id i1sm9705814lji.71.2020.01.15.11.42.02
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2020 11:42:02 -0800 (PST)
Received: by mail-lf1-f50.google.com with SMTP id r14so13674027lfm.5
        for <stable@vger.kernel.org>; Wed, 15 Jan 2020 11:42:02 -0800 (PST)
X-Received: by 2002:a19:22cc:: with SMTP id i195mr314766lfi.148.1579117322138;
 Wed, 15 Jan 2020 11:42:02 -0800 (PST)
MIME-Version: 1.0
References: <CACMCwJK-2DHZDA_F5Z3wsEUEKJSc3uOwwPD4HRoYGW7A+kA75w@mail.gmail.com>
 <20200113154739.GB11244@42.do-not-panic.com> <CACMCwJL8tu+GHPeRADR_12xhcYSiDv+Yxdy=yLqMxEsn=P9zFA@mail.gmail.com>
 <20200115021545.GD11244@42.do-not-panic.com> <CACMCwJLJCA2iXS0QMKKAWQv252oUcmfsNvwDNP5+4Z_9VB-rTg@mail.gmail.com>
 <20200115185812.GH11244@42.do-not-panic.com>
In-Reply-To: <20200115185812.GH11244@42.do-not-panic.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 15 Jan 2020 11:41:46 -0800
X-Gmail-Original-Message-ID: <CAHk-=whOC9dakUZ_BzHq2d5oKXXGnrKf+M-4gZ8U+=F_OX4+Ew@mail.gmail.com>
Message-ID: <CAHk-=whOC9dakUZ_BzHq2d5oKXXGnrKf+M-4gZ8U+=F_OX4+Ew@mail.gmail.com>
Subject: Re: Fix built-in early-load Intel microcode alignment
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Jari Ruusu <jari.ruusu@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Fenghua Yu <fenghua.yu@intel.com>, johannes.berg@intel.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Lutomirski <luto@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 15, 2020 at 10:58 AM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> But *how? Why is there a 50/50 chance of it being aligned to
> 16 bytes if 8 bytes are currently specified?

What?

It's trivial.

Address 256 is 4-byte aligned. But it's also 8-byte aligned. And
16-byte aligned. And..

So if you ask for 8-byte alignment, and you already had that address
(or were just below it), you'll get 8-byte alignment. But it will
_also_ be 16-byte aligned just by happenstance.

And yes, exactly half of the addresses that are 8-byte aligned are
also 16-byte aligned, so you have a 50/50 chance of getting the bigger
alignment simply by random chance.

In fact, often you probably have a _better_ than 50/50 chance of
getting the bigger alignment, since many other things are aligned too,
and the starting address likely isn't very random. So it might have
started out with a bigger alignment even before you asked for just
8-byte aligned data from the linker.

(Of course, the reverse may be true too - there may be cases you were
coimpletely mis-aligned, and asking for 8-byte alignment will never
give you any more aligned memory, but I suspect aligned data is a lot
more common than unaligned data is)

              Linus
