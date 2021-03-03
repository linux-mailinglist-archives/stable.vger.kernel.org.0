Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4DE32BC57
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447266AbhCCNse (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:48:34 -0500
Received: from mail.zx2c4.com ([104.131.123.232]:33552 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233647AbhCCMf0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Mar 2021 07:35:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1614774775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0GYsQt7abDs101BMQCcdgkKHn6RTbgjyDaRxE3tihio=;
        b=FqOoTvC8T43dYz/spYl2gbbca1X1jYgkzOsLQjCHgbFtkFSMwIUY9v5JTRbjpIhtlpgzsG
        +BK6Lq7Kz2CANFUaKQAnWRpVa6uEymoujPmMel+gua/gTYEJ1RKKOT/6PNkdvccRCCLToU
        pUIHWvZQO+yppaOee2S8JSglTuR27s0=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 1095f862 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 3 Mar 2021 12:32:55 +0000 (UTC)
Received: by mail-yb1-f176.google.com with SMTP id u3so24333988ybk.6;
        Wed, 03 Mar 2021 04:32:55 -0800 (PST)
X-Gm-Message-State: AOAM533WT63gZ04TEi1CcyleIrGab2UhdNBLTqXUvTi8thUevKPGZqIj
        dfrred9xO27YUL4eVea1C75JXUJd8odwaPDu/rQ=
X-Google-Smtp-Source: ABdhPJxG8CT1k3qC7poGwRgw+CZq5L2/qRXBeHg3lraz8t+vyF6HwVi5pC8pvdEkvSrZMqV34W472scNppsHe4LbQgU=
X-Received: by 2002:a25:c090:: with SMTP id c138mr36691226ybf.279.1614774774461;
 Wed, 03 Mar 2021 04:32:54 -0800 (PST)
MIME-Version: 1.0
References: <alpine.DEB.2.21.2103030122010.19637@angie.orcam.me.uk>
 <CAHmME9qgEMdcVgkBkvBZ9Du=ae=wEyQ4uPa+Au8+LEs5ZQCzAg@mail.gmail.com> <70eb96e1-3243-105c-b52e-c9bd3239a263@cryptogams.org>
In-Reply-To: <70eb96e1-3243-105c-b52e-c9bd3239a263@cryptogams.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 3 Mar 2021 13:32:43 +0100
X-Gmail-Original-Message-ID: <CAHmME9omx45G_UtnTnyt7LFr70Uou0JM8vboF-C=ZdD1ttBQoQ@mail.gmail.com>
Message-ID: <CAHmME9omx45G_UtnTnyt7LFr70Uou0JM8vboF-C=ZdD1ttBQoQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: mips/poly1305 - enable for all MIPS processors
To:     Andy Polyakov <appro@cryptogams.org>
Cc:     "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        George Cherian <gcherian@marvell.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 3, 2021 at 1:31 PM Andy Polyakov <appro@cryptogams.org> wrote:
>
> Hi,
>
> > I'm also CC'ing Andy on this, who wrote the original assembly, in case
> > he has some last minute objection.
>
> Just "what took you so long":-) On potentially related note cryptogams
> chacha-mips is as universal as poly1305-mips. "Universal" in sense that
> it can be compiled for all MIPS stripes.

Oh great. I didn't realize you had a ChaCha mips implementation. I'll
look into having that replace my junky mips32r2 one.

Jason
