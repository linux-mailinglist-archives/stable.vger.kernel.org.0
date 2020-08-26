Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B512533E3
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 17:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgHZPml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 11:42:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727106AbgHZPmj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 11:42:39 -0400
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A308214F1;
        Wed, 26 Aug 2020 15:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598456559;
        bh=RHa9zBLgw9IpfI7JnYGtkrslv1jtDxLIc9cYeU/LmxM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=zTPtES8x2UWsCaI6kOj9nlniMNWuIzrJD1UT96WMiFp6xVX6hAhsHYjM5ndQD83N+
         G8Duj3cj5wgQSHoHBb7it+ZNAr319loUQIumqckWjoZAmXispngrIm866+JJelvobX
         MxmXWZZ3J1yE53x3t73Qs3oyiOEXPGQD3Ct1xkG0=
Received: by mail-oi1-f180.google.com with SMTP id z22so1908871oid.1;
        Wed, 26 Aug 2020 08:42:39 -0700 (PDT)
X-Gm-Message-State: AOAM532hGxfVXbOznas8h8okLE3EW0yIjpgqp+mVAROOHf/CkFHGf+mi
        zaNgk+wfQ2QK3BOk/CMHPEhWR/7DasRSxq6iaVo=
X-Google-Smtp-Source: ABdhPJzAvAC3orjViJOSzoyVcXXcCbOYl8M/eBC8YnZBbaXn68xbTd4Ss7RJC5vq85k/RVC1Tc8NT8NeKeBh2EKIkwo=
X-Received: by 2002:aca:d8c5:: with SMTP id p188mr3975859oig.47.1598456558363;
 Wed, 26 Aug 2020 08:42:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200826055150.2753.90553@ml01.vlan13.01.org> <b34f7644-a495-4845-0a00-0aebf4b9db52@molgen.mpg.de>
 <CAMj1kXEUQdmQDCDXPBNb3hRrbui=HVyDjCDoiFwDr+mDSjP43A@mail.gmail.com>
 <20200826114952.GA2375@gondor.apana.org.au> <CAMj1kXGjytfJEbLMbz50it3okQfiLScHB5YK2FMqR5CsmFEBbg@mail.gmail.com>
 <20200826120832.GA2996@gondor.apana.org.au> <CAOq732JaP=4X9Yh_KjER5_ctQWoauxzXTZqyFP9KsLSxvVH8=w@mail.gmail.com>
 <20200826130010.GA3232@gondor.apana.org.au> <c27e5303-48d9-04a4-4e73-cfea5470f357@gmail.com>
 <20200826141907.GA5111@gondor.apana.org.au> <4bb6d926-a249-8183-b3d9-05b8e1b7808a@gmail.com>
In-Reply-To: <4bb6d926-a249-8183-b3d9-05b8e1b7808a@gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 26 Aug 2020 17:42:27 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEn507bEt+eT6q7MpCwNH=oAZsTkFRz0t=kPEV0QxFsOQ@mail.gmail.com>
Message-ID: <CAMj1kXEn507bEt+eT6q7MpCwNH=oAZsTkFRz0t=kPEV0QxFsOQ@mail.gmail.com>
Subject: Re: Issue with iwd + Linux 5.8.3 + WPA Enterprise
To:     Denis Kenzior <denkenz@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
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

On Wed, 26 Aug 2020 at 17:33, Denis Kenzior <denkenz@gmail.com> wrote:
>
> Hi Herbert,
>
> On 8/26/20 9:19 AM, Herbert Xu wrote:
> > On Wed, Aug 26, 2020 at 08:57:17AM -0500, Denis Kenzior wrote:
> >>
> >> I'm just waking up now, so I might seem dense, but for my education, can you
> >> tell me why we need to set MSG_MORE when we issue just a single sendmsg
> >> followed immediately by recv/recvmsg? ell/iwd operates on small buffers, so
> >> we don't really feed the kernel data in multiple send operations.  You can
> >> see this in the ell git tree link referenced in Andrew's reply.
> >
> > You obviously don't need MSG_MORE if you're doing a single sendmsg.
> >
> > The problematic code is in l_cipher_set_iv.  It does a sendmsg(2)
> > that expects to be followed by more sendmsg(2) calls before a
> > recvmsg(2).  That's the one that needs a MSG_MORE.
> >
>
> Gotcha.  I fixed the set_iv part now in ell:
> https://git.kernel.org/pub/scm/libs/ell/ell.git/commit/?id=87c76bbc85fe286925cbdb53d733fc9f9fd2ed12
>

Interestingly, that change alone (without the kernel side fix that
Herbert just provided) is not sufficient to make the self tests work
again.

I still get a failure in aes_siv_encrypt(), which does not occur with
the kernel side fix applied.
