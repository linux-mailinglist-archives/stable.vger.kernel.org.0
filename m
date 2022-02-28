Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90F654C6571
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 10:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbiB1JJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 04:09:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233731AbiB1JJn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 04:09:43 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA4E149CAD
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 01:09:04 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id f38so7244948ybi.3
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 01:09:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FiyRI5DHlb96l/+rmBXOae4F7ATJ/xLo/4ohoO57pkc=;
        b=cdKByohAsWXJXwPllDc7pyrfXAVLilSsZKbLHuCjxbOyvB0D8A+9rZpwdn3Ok3JVdy
         PMne06PyJIyLBNmyxaAAbL3PIWzSkzQ2rTLaihsWtB/oZZmnuOCpgC+R0EUohg9BUTX9
         1Zx/pyDlo8vGUrXneQhecsXYiesuPwo6XRzNYQ3zTU2lVUuRukRyKQBbyKSX8ExV9iEJ
         AAIy0Sz7kf+zKkLoXLKUA1pQm7UYHb49/LL+dNqz1DWEHFk60qIJC8M2GOK++nRL36qR
         mBsHrQvFixzpSEB6IVw63u3qpS0j/IzueLYptj1un7eNwjT+GacOaCx3yOHEMIs/qXFG
         i0Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FiyRI5DHlb96l/+rmBXOae4F7ATJ/xLo/4ohoO57pkc=;
        b=HxHaolJlKUrLGrDBXvRccW6VzdL+JFfH4Y82N8Ouo0SUo1UZI8auLgw006QW38jHgO
         CN7P2YzVwSG+Py4ECmW6Go9gBoihsWp9YpCGAmRpHSrAh1g2GK4pOvcBrjADFMzcORq6
         EaqTEx5jJ68oZpkIQRLODLeUwoGu9+a2XVySjKaavOS8Z4Zs+pJSGCzPPKhHF6ppjyb+
         DwHWRvSsLYD23b9z+XE6pUyATxdaDgaFQW6PXpbpTG88Q2ULLSyY6d4e+pQ13PDe9g3T
         SajW8jk1lNa9gYhvnHjxzNykZpO72fBVGBr9C8yoHPhsKjfE3lxyJRNTXUiuYv+r4s2R
         8gMQ==
X-Gm-Message-State: AOAM531rsc9QT9t2/llIivghYnDQwKyfYIan9Z5XA+yNWkMU80AOSQHN
        ZJOwnTWyFIOanwT2+KCzMT83lIFSB+T7IC9Xty1oOQ==
X-Google-Smtp-Source: ABdhPJxi5xP1NReREnqaUApMZPGYKwblM7pKFPpW8ybZdTK+TGL3WH1MfRBRieseBU2tUW8obscPn0cMtmzcquy83zg=
X-Received: by 2002:a25:5047:0:b0:61a:ea8e:cc6d with SMTP id
 e68-20020a255047000000b0061aea8ecc6dmr17403314ybb.65.1646039343950; Mon, 28
 Feb 2022 01:09:03 -0800 (PST)
MIME-Version: 1.0
References: <20220223080400.139367-1-gilad@benyossef.com> <Yhbjq3cVsMVUQLio@sol.localdomain>
 <YhblA1qQ9XLb2nmO@sol.localdomain> <CAOtvUMfFhQABmmZe7EH-o=ULEChm_t=KY7ORBRgm94O=1MiuFw@mail.gmail.com>
 <YhfWzLBq2A2nr5Ey@sol.localdomain> <CAOtvUMcDcouMPmVUYpYEPdxPS+7_r9S_OXz1FR5tQJM6hWzRmA@mail.gmail.com>
In-Reply-To: <CAOtvUMcDcouMPmVUYpYEPdxPS+7_r9S_OXz1FR5tQJM6hWzRmA@mail.gmail.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Mon, 28 Feb 2022 11:09:05 +0200
Message-ID: <CAOtvUMdX2N9XcBV81rSKz=orZ-3XHWW8ChXnuKAeiAsQy5P_Vg@mail.gmail.com>
Subject: Re: [PATCH] crypto: drbg: fix crypto api abuse
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        stable <stable@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Sun, Feb 27, 2022 at 12:12 PM Gilad Ben-Yossef <gilad@benyossef.com> wro=
te:
...


>
> I think the right thing to do right now is to verify that we indeed
> have a general issue and not something specific to one singular
> platform
> So the question becomes - do indeed the DMA api forbits aliased
> mappings and if so, under what conditions?
>
> Any ideas on how to check this?

OK, I've looked into this further and I think I was wrong.
The DMA api doesn't like overlapping writable mappings, but it seems
an overlapping read-only and writable mapping are fine.
If so I can indeed resolve this in the driver code by better
specifying DMA direction. Let me give this a go and let's drop this
patch in the meantime.

Thank you and sorry for the noise.

Gilad

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
