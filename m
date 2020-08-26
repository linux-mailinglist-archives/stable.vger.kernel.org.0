Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE900252F1A
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 14:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728960AbgHZM6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 08:58:16 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:41461 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730043AbgHZM6P (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 08:58:15 -0400
Received: by mail-il1-f193.google.com with SMTP id q14so1634457ilj.8;
        Wed, 26 Aug 2020 05:58:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/KmmQfwHULnlIqQl6u1SzgqJsX9j6BWCR4avQA0PcIY=;
        b=mCjr4RfYZrTnvwg1wtiV5Dqk3bZjs2Hw/15jyQl0zV8Z6B1630SDVELnfbsd3djWyH
         83Nhf8sM4AsZCKOt9AY3IBRS5o9rqUe89Fd0jKX/+D3bqwHNEDycyL4wAsboRttrNY1N
         k3HYZNqD665QGzT683pR3iMUdxbShM6QFval8a9k5du5W7o2N7PtqAOBqYaWL9VAWrIM
         oBEjnucZgn8CsYUPvIcQcxgV5/RBKDbm21lBZodxpv3N+1zf1CoOOmxowHFE7ZcDTMJ5
         scREc10dxjkoptt3dv1XIj6FnKoo01GGqNjuhBrvwYj7N+3F2ea/xfbC5wDgeGsN3UPw
         fAXA==
X-Gm-Message-State: AOAM530K81PPqPJOoLRIu32/8T6TBtqm7vSoNR+QGdUaRozzSzGjdNAc
        rM7YuCp8AAT29Pb/LES2Na7ZUofrsNi1lL5c
X-Google-Smtp-Source: ABdhPJzSa39y60rj1/s3hqpO8RiVivbI9Dctz/s6tHNYXlw7c7JSCbGkeubk29JzRI2E0ZbuWggZDw==
X-Received: by 2002:a92:6b04:: with SMTP id g4mr13592283ilc.192.1598446694641;
        Wed, 26 Aug 2020 05:58:14 -0700 (PDT)
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com. [209.85.166.179])
        by smtp.gmail.com with ESMTPSA id o1sm1310062ils.1.2020.08.26.05.58.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 05:58:14 -0700 (PDT)
Received: by mail-il1-f179.google.com with SMTP id f75so1649009ilh.3;
        Wed, 26 Aug 2020 05:58:13 -0700 (PDT)
X-Received: by 2002:a92:ca8d:: with SMTP id t13mr13377470ilo.302.1598446693534;
 Wed, 26 Aug 2020 05:58:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200826055150.2753.90553@ml01.vlan13.01.org> <b34f7644-a495-4845-0a00-0aebf4b9db52@molgen.mpg.de>
 <CAMj1kXEUQdmQDCDXPBNb3hRrbui=HVyDjCDoiFwDr+mDSjP43A@mail.gmail.com>
 <20200826114952.GA2375@gondor.apana.org.au> <CAMj1kXGjytfJEbLMbz50it3okQfiLScHB5YK2FMqR5CsmFEBbg@mail.gmail.com>
 <20200826120832.GA2996@gondor.apana.org.au>
In-Reply-To: <20200826120832.GA2996@gondor.apana.org.au>
From:   Andrew Zaborowski <andrew.zaborowski@intel.com>
Date:   Wed, 26 Aug 2020 14:58:02 +0200
X-Gmail-Original-Message-ID: <CAOq732JaP=4X9Yh_KjER5_ctQWoauxzXTZqyFP9KsLSxvVH8=w@mail.gmail.com>
Message-ID: <CAOq732JaP=4X9Yh_KjER5_ctQWoauxzXTZqyFP9KsLSxvVH8=w@mail.gmail.com>
Subject: Re: Issue with iwd + Linux 5.8.3 + WPA Enterprise
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Caleb Jorden <caljorden@hotmail.com>,
        Sasha Levin <sashal@kernel.org>, iwd@lists.01.org,
        "# 3.4.x" <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 26 Aug 2020 at 14:10, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Wed, Aug 26, 2020 at 01:59:53PM +0200, Ard Biesheuvel wrote:
> > On Wed, 26 Aug 2020 at 13:50, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > >
> > > On Wed, Aug 26, 2020 at 12:40:14PM +0200, Ard Biesheuvel wrote:
> > > >
> > > > It would be helpful if someone could explain for the non-mac80211
> > > > enlightened readers how iwd's EAP-PEAPv0 + MSCHAPv2 support relies on
> > > > the algif_aead socket interface, and which AEAD algorithms it uses. I
> > > > assume this is part of libell?
> > >
> > > I see the problem.  libell/ell/checksum.c doesn't clear the MSG_MORE
> > > flag before doing the recv(2).
> >
> > But that code uses a hash not an aead, afaict.
>
> Good point.  In that case can we please get a strace with a -s
> option that's big enough to capture the crypto data?

Running iwd's and ell's unit tests I can see that at least the
following algorithms give EINVAL errors:
ecb(aes)
cbc(aes)
ctr(aes)

The first one fails in recv() and only for some input lengths.  The
latter two fail in send().  The relevant ell code starts at
https://git.kernel.org/pub/scm/libs/ell/ell.git/tree/ell/cipher.c#n271

The tests didn't get to the point where aead is used.

Best regards
