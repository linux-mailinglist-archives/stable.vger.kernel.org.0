Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDBC51279D3
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 12:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbfLTLOy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 06:14:54 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:52911 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727177AbfLTLOy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 06:14:54 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 91e51ee0
        for <stable@vger.kernel.org>;
        Fri, 20 Dec 2019 10:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=pokwa7NyBeOJiaOaLL/PxadiX4g=; b=Ux6hSL
        TJWDqmr9s+CXLZ35AlnQtS0omY8QpUrT24OgIoU2S7iXxhVtPStFg15wNg/SbjgC
        G6oPbEXHWSYaKQpnLcKJOtOp68THChfHtNzdhq8CLyhpW6axY7ShF6T8ol3aO37W
        0Obtd+JjCZYvGqx+l7YSSp+ZubLWQxxkfjnWiIRUqiEr88TyNvmcFzoIeu+3hArM
        0yN2Ujwbr2Xd3vOl58gbMcePKs1xCT+z7qsiaTElXfasRRnRcZL2E9+bfkXPik4f
        QXTDJ3t4ZIZ033ZupplFrGALpzq568pozi/w+boxHojaM5toPS4dYD8KqG1bpl65
        2o11coLk/Dicm1Tg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b1fa6209 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <stable@vger.kernel.org>;
        Fri, 20 Dec 2019 10:18:03 +0000 (UTC)
Received: by mail-ot1-f48.google.com with SMTP id 77so11465564oty.6
        for <stable@vger.kernel.org>; Fri, 20 Dec 2019 03:14:52 -0800 (PST)
X-Gm-Message-State: APjAAAVPNnmsshnwJqFqGefuMU9i7HP8xET1Lov9fykVk7lXRaX8qb9O
        0HBQoXgRixohoIY9ZMcHCaoG8rOpvKfUh71wrCk=
X-Google-Smtp-Source: APXvYqwZS83cYEDTlmiwP/yTfn3mIayp1kUV/sB89MNpINbPW9sfvbZrj/7UzZfx0lIVbfJmkiDd6GpDUQHjbV6NDA0=
X-Received: by 2002:a9d:674f:: with SMTP id w15mr14721603otm.243.1576840491536;
 Fri, 20 Dec 2019 03:14:51 -0800 (PST)
MIME-Version: 1.0
References: <20191203205716.1228-1-Jason@zx2c4.com> <20191209154505.6183-1-Jason@zx2c4.com>
 <CAHmME9q3mcE+Am5e=R=z=kJrkjwmz_tWqt7jc1b-7DiPt0vWNw@mail.gmail.com> <20191220100756.GF2844@hirez.programming.kicks-ass.net>
In-Reply-To: <20191220100756.GF2844@hirez.programming.kicks-ass.net>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 20 Dec 2019 12:14:40 +0100
X-Gmail-Original-Message-ID: <CAHmME9rrQGN5dpP+riJ25nS=OyhxzSsQu=1KriWQV9kTTEjGPw@mail.gmail.com>
Message-ID: <CAHmME9rrQGN5dpP+riJ25nS=OyhxzSsQu=1KriWQV9kTTEjGPw@mail.gmail.com>
Subject: Re: [PATCH] x86/quirks: disable HPET on Intel Coffee Lake Refresh platforms
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     X86 ML <x86@kernel.org>, Feng Tang <feng.tang@intel.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 20, 2019 at 11:08 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Fri, Dec 20, 2019 at 02:42:59AM +0100, Jason A. Donenfeld wrote:
> > Hi,
> >
> > Thought I should give a poke here so that this doesn't slip through
> > the cracks again. Could we get this in for rc3?
>
> I think another version of this patch made it in recently, see commit:
>
>   f8edbde885bb ("x86/intel: Disable HPET on Intel Coffee Lake H platforms")

Oh, good. Glad to see it came from somewhere. Thanks.

Jason
