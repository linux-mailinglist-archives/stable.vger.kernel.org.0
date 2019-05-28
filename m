Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 909E12C8D5
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 16:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbfE1Oaj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 10:30:39 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:46390 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbfE1Oaj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 May 2019 10:30:39 -0400
Received: by mail-oi1-f194.google.com with SMTP id 203so14384608oid.13
        for <stable@vger.kernel.org>; Tue, 28 May 2019 07:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lpp7ccSUbaTg2wXqVqozx7r8Gn8naMF1nG94XiI2Q9g=;
        b=HnCwTxfsJnlmsP08ZQ0PdvAHAod51xM4PwwImHTeKCfsDkMxvnk8KQjmWr3woHeiRP
         ia25bF/13+tiyXaUnwL8jdenYbMjGUugUhu0LQ2RHBL+mLpvZ3mO+c3JEcidpBEmuOwy
         +mo6su5gYPLNYOGjy9udW4Q8oG/7Kr23n6VOKjjsAELPF429CpkCLl8tCkkxfE7Zq6nV
         YRqUhdG12U5Il4Ks5xCsNTve69Zm0LlKz3hxqCX8oKYkeb2/5r60zBODPJptLQJq/gKu
         ylbLk70QH4pVt7WfaNdqYC77dbU9hw9Q6+ew1kakZMvKb7keONqGPA5nBvnHAzMSIOfq
         pFgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lpp7ccSUbaTg2wXqVqozx7r8Gn8naMF1nG94XiI2Q9g=;
        b=nUZCygzq5bTw0wKFmdjIdYnJVhS4HTmkIzA5vH/Ly11z9DHX0pLsKsH0xtxjr9Oxwh
         +UFxTR/41gHFVeFvAh8+KWpRunv1yoq8th2raRY02bAyLZofPFS0MAv6JWug9eNY9aP3
         BYHrG0jIb3iQMfM66JWSdkP8V3nmCuFkOm/Gsot98vAsnFiiY3WOVqXMM8gwDYqsbXuT
         SIvrAKcuqy0q4wxQEYrmsIENDe8KoK0Ob5txUB4ZWQOjR8mTAseWdYV463AU3dpnI91D
         0lsmiSGt4ZV+7tGKFfiGgWPfpF66Tcddk59SKazljtTw8G6iHtDZF3VM0VsLhwo6BmWB
         yMEA==
X-Gm-Message-State: APjAAAXoahbvmslC4hR6I31EklReE7XAFEbrY5U65fqqRjw/6RgV/GG2
        A4He7TdPjobFp7t7h7ie77Ci5O3Q7hqBU+nSp6z2kA==
X-Google-Smtp-Source: APXvYqwtRY1qZkkr7pOUSUxZXKWWl1KraL9oQkS+ZtGpNkzeRus8PXqAm1up7i9MOE3zDldklzMklrWSokbuG6ekzcM=
X-Received: by 2002:aca:418a:: with SMTP id o132mr2810723oia.16.1559053838114;
 Tue, 28 May 2019 07:30:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190528124152.191773-1-lenaptr@google.com> <CAKv+Gu-Bzb6bucFXgW+EgU2bh9Kp-rAJWq5TSNrk7n_rMGkx9g@mail.gmail.com>
In-Reply-To: <CAKv+Gu-Bzb6bucFXgW+EgU2bh9Kp-rAJWq5TSNrk7n_rMGkx9g@mail.gmail.com>
From:   Elena Petrova <lenaptr@google.com>
Date:   Tue, 28 May 2019 15:30:27 +0100
Message-ID: <CABvBcwYuimLrM3fDK5tjHT3G3=nHLd=rUiPSCCWqAyPK4E_3SA@mail.gmail.com>
Subject: Re: [PATCH] arm64 sha1-ce finup: correct digest for empty data
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Yep, sha2 also has the bug, I'll be sending the fix soon, thanks!

On Tue, 28 May 2019 at 14:03, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On Tue, 28 May 2019 at 14:42, Elena Petrova <lenaptr@google.com> wrote:
> >
> > The sha1-ce finup implementation for ARM64 produces wrong digest
> > for empty input (len=0). Expected: da39a3ee..., result: 67452301...
> > (initial value of SHA internal state). The error is in sha1_ce_finup:
> > for empty data `finalize` will be 1, so the code is relying on
> > sha1_ce_transform to make the final round. However, in
> > sha1_base_do_update, the block function will not be called when
> > len == 0.
> >
> > Fix it by setting finalize to 0 if data is empty.
> >
> > Fixes: 07eb54d306f4 ("crypto: arm64/sha1-ce - move SHA-1 ARMv8 implementation to base layer")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Elena Petrova <lenaptr@google.com>
>
> Thanks for the fix
>
> Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> It looks like the sha224/256 suffers from the same issue. Would you
> mind sending out a fix for that as well? Thanks.
>
> > ---
> >  arch/arm64/crypto/sha1-ce-glue.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/crypto/sha1-ce-glue.c b/arch/arm64/crypto/sha1-ce-glue.c
> > index eaa7a8258f1c..0652f5f07ed1 100644
> > --- a/arch/arm64/crypto/sha1-ce-glue.c
> > +++ b/arch/arm64/crypto/sha1-ce-glue.c
> > @@ -55,7 +55,7 @@ static int sha1_ce_finup(struct shash_desc *desc, const u8 *data,
> >                          unsigned int len, u8 *out)
> >  {
> >         struct sha1_ce_state *sctx = shash_desc_ctx(desc);
> > -       bool finalize = !sctx->sst.count && !(len % SHA1_BLOCK_SIZE);
> > +       bool finalize = !sctx->sst.count && !(len % SHA1_BLOCK_SIZE) && len;
> >
> >         if (!crypto_simd_usable())
> >                 return crypto_sha1_finup(desc, data, len, out);
> > --
> > 2.22.0.rc1.257.g3120a18244-goog
> >
