Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 814F7253FEC
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 09:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgH0H5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 03:57:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728391AbgH0HyY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Aug 2020 03:54:24 -0400
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71E6722CF7;
        Thu, 27 Aug 2020 07:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598514863;
        bh=awYibhA4t5ZtQZw3w3TIiaHR9uOvXpyWJPnRkXljvkY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=VyTg38LFRqJvBykurOAVgcyjZFl8Dej4Y9E51FKYn4lg3yqaEHQzXimTjSmTO6reK
         qTnisWe2HgXA675FPlFMAdSvGkBBJ9gmrHgeufWWRp7CkLH62cFVkr5xqSQDuMxwpH
         AykRuAp6MOyJ3UU/afkB6jI6cKW2r0r4RGJwGBYw=
Received: by mail-ot1-f52.google.com with SMTP id k2so3701044ots.4;
        Thu, 27 Aug 2020 00:54:23 -0700 (PDT)
X-Gm-Message-State: AOAM530nMZDyB90wVjCeMevWdZi+55D776R1NP1NXnzRNqJRvKT6VQ6r
        wfjGyEOIXCo16oc5dVkyd68RlwEAlqVGhkgfw6c=
X-Google-Smtp-Source: ABdhPJzka/lf5uRZNedGeD8+aWitXVwNl94o7ceaCS2qOGuAlEmCCdA7zvmUAgTQPMrO41TFr0qmffUFl2snH+2ek34=
X-Received: by 2002:a9d:5189:: with SMTP id y9mr7216308otg.77.1598514862803;
 Thu, 27 Aug 2020 00:54:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAMj1kXEUQdmQDCDXPBNb3hRrbui=HVyDjCDoiFwDr+mDSjP43A@mail.gmail.com>
 <20200826114952.GA2375@gondor.apana.org.au> <CAMj1kXGjytfJEbLMbz50it3okQfiLScHB5YK2FMqR5CsmFEBbg@mail.gmail.com>
 <20200826120832.GA2996@gondor.apana.org.au> <CAOq732JaP=4X9Yh_KjER5_ctQWoauxzXTZqyFP9KsLSxvVH8=w@mail.gmail.com>
 <20200826130010.GA3232@gondor.apana.org.au> <c27e5303-48d9-04a4-4e73-cfea5470f357@gmail.com>
 <20200826141907.GA5111@gondor.apana.org.au> <4bb6d926-a249-8183-b3d9-05b8e1b7808a@gmail.com>
 <CAMj1kXEn507bEt+eT6q7MpCwNH=oAZsTkFRz0t=kPEV0QxFsOQ@mail.gmail.com>
 <20200826221913.GA16175@gondor.apana.org.au> <BL0PR11MB329980406FA0A14A8EF61A07B9550@BL0PR11MB3299.namprd11.prod.outlook.com>
In-Reply-To: <BL0PR11MB329980406FA0A14A8EF61A07B9550@BL0PR11MB3299.namprd11.prod.outlook.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 27 Aug 2020 09:54:11 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFX_viiR4S8DiDrcS09o2NFQsZGmizdLc9xjrWOrhgjaA@mail.gmail.com>
Message-ID: <CAMj1kXFX_viiR4S8DiDrcS09o2NFQsZGmizdLc9xjrWOrhgjaA@mail.gmail.com>
Subject: Re: Issue with iwd + Linux 5.8.3 + WPA Enterprise
To:     Caleb Jorden <caljorden@hotmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Denis Kenzior <denkenz@gmail.com>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Sasha Levin <sashal@kernel.org>,
        "iwd@lists.01.org" <iwd@lists.01.org>,
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

On Thu, 27 Aug 2020 at 06:56, Caleb Jorden <caljorden@hotmail.com> wrote:
>
> I can tell you all assumed this, but just by way as a quick update on the original issue:
>
> I have confirmed that Herbert's patch (crypto: af_alg - Work around empty control messages without MSG_MORE) does indeed fix the original iwd 1.8 + WPA Enterprise issue.
>
> Thank you!
>
> Caleb Jorden
>

Thanks for confirming.

> ________________________________________
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Thursday, August 27, 2020 3:49 AM
> To: Ard Biesheuvel
> Cc: Denis Kenzior; Andrew Zaborowski; Paul Menzel; Caleb Jorden; Sasha Levin; iwd@lists.01.org; # 3.4.x; Greg KH; LKML; David S. Miller; Linux Crypto Mailing List
> Subject: Re: Issue with iwd + Linux 5.8.3 + WPA Enterprise
>
> On Wed, Aug 26, 2020 at 05:42:27PM +0200, Ard Biesheuvel wrote:
> >
> > I still get a failure in aes_siv_encrypt(), which does not occur with
> > the kernel side fix applied.
>
> Where is this test from? I can't find it in the ell git tree.
>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
