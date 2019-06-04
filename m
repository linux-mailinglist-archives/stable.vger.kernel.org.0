Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14EFB34E13
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 18:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727757AbfFDQ4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 12:56:55 -0400
Received: from conssluserg-02.nifty.com ([210.131.2.81]:54727 "EHLO
        conssluserg-02.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727709AbfFDQ4y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 12:56:54 -0400
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43]) (authenticated)
        by conssluserg-02.nifty.com with ESMTP id x54GuV6L015738;
        Wed, 5 Jun 2019 01:56:32 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-02.nifty.com x54GuV6L015738
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1559667392;
        bh=AWQM1259hlpLE+Q6HQ1rPP/ecAKabyKp++FNUsm3vM8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=AeJgD3Hehs6eDX/f6fMXAcW1K2o9fLZmoDVPaiO+j4eVnCFnUsNx8YxcyyB1OQlC8
         S6feXBXsR4KQZGW8dTt53RoyT/7zpRU8dVqHDKn2K2Auh7+hkrF1ORVWGGrJjYK9Jo
         RpDqCL7/brBaSJ3qT6VFepJPTHuudNiIQHTGlo98E7TjUHqGIaD9bJclNFhEDJASnd
         1Hkn7h2eCidaHSoUszMR6NahV/5DvYxaOoTrmyl+NgnC6aL3K2ra3F7dN+iNDEcTK0
         dSWeI2eMQz8izXEThaAkssaSoeBlTrK6OSBBJ9KKBAcPN5ubx1Y8CCPUYgNUh9EsL7
         Ct4s5nOHG+Wsw==
X-Nifty-SrcIP: [209.85.217.43]
Received: by mail-vs1-f43.google.com with SMTP id u124so3375877vsu.2;
        Tue, 04 Jun 2019 09:56:31 -0700 (PDT)
X-Gm-Message-State: APjAAAWzJmZDPORYQVrVLFHFSPSV842TxlGMI+PSYsExm6cQwq1LsgjS
        RyvnjwunhKSof09gZwTC3RHHXkljni2VaE/5zss=
X-Google-Smtp-Source: APXvYqziG67UCmWZotaA3vRTF/UlR6i3eFISA8tVsgriIAz81VPvXjMWqG/0DTyBqd2pWmiKytVJybjGXfSP6OSC1f4=
X-Received: by 2002:a67:b109:: with SMTP id w9mr5796256vsl.155.1559667390772;
 Tue, 04 Jun 2019 09:56:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190603104902.23799-1-yamada.masahiro@socionext.com>
 <863c29c5f0214c008fbcbb2aac517a5c@AcuMS.aculab.com> <CAK7LNARHR=xv_YxQCkCM7PtW3vpNfXOgZrez0c4HbMX6C-8-uA@mail.gmail.com>
 <810dd6ae018b4a31b70d26fb6b29e48d@AcuMS.aculab.com> <CAK7LNAR_A1d5keiCRthNioW3nqkNadJkaCyMR3a5S8WS0jhgNQ@mail.gmail.com>
 <96b710063de5464ea347bfa1e03308b5@AcuMS.aculab.com>
In-Reply-To: <96b710063de5464ea347bfa1e03308b5@AcuMS.aculab.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Wed, 5 Jun 2019 01:55:54 +0900
X-Gmail-Original-Message-ID: <CAK7LNARfX_Vk+iW_B3XTOmoEx-43WENNtEk4vNCv-PWk9R2r3A@mail.gmail.com>
Message-ID: <CAK7LNARfX_Vk+iW_B3XTOmoEx-43WENNtEk4vNCv-PWk9R2r3A@mail.gmail.com>
Subject: Re: [PATCH] kbuild: use more portable 'command -v' for cc-cross-prefix
To:     David Laight <David.Laight@aculab.com>
Cc:     "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Alexey Brodkin <abrodkin@synopsys.com>,
        "linux-snps-arc@lists.infradead.org" 
        <linux-snps-arc@lists.infradead.org>,
        linux-stable <stable@vger.kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 4, 2019 at 6:01 PM David Laight <David.Laight@aculab.com> wrote:
>
> From: Masahiro Yamada
> > Sent: 04 June 2019 04:31
> ...
> > > > > You could use:
> > > > >         $(shell sh -c "command -v $(c)gcc")
> > > > > or maybe:
> > > > >         $(shell command$${x:+} -v $(c)gcc)
> > > >
> > > >
> > > > How about this?
> > > >
> > > >           $(shell : ~; command -v $(c)gcc)
> > >
> > > Overcomplicated ....
> > >
> > > I've not looked at the list of 'special characters' in make,
> > > but I suspect any variable expansion is enough.
> > > Since ${x:+} always expands to the empty string (whether or
> > > not 'x' is defined) it can't have any unfortunate side effects.
> >
> >
> > Probably, my eyes are used to Makefile.
> > ":" is a no-op command, and it is used everywhere in kernel Makefiles
> > in the form of "@:'
> >
> > It depends on people which solution seems simpler.
> > So, this argument tends to end up with bikesheding.
>
> I am fully aware of ':', it is a shell builtin that always return success.
> Usually used when you want the side-effects of substitutions without
> executing anything (eg : ${foo:=bar} ), to change the result of a
> sequence of shell commands or as a dummy (eg while :; do :; done; )
> Very annoyingly bash parses !: as something other than 'not true'.
>
> $(shell command$${x:+} -v $(c)gcc) will be marginally faster
> because it is less parsing.
>

I will use this:

$(shell command -v $(c)gcc 2>/dev/null)

Make does not handle redirection by itself.

'2>/dev/null' is easy to understand,
and might be useful as extra safety.




-- 
Best Regards
Masahiro Yamada
