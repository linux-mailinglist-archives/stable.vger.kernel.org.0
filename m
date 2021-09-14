Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30DE40B748
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 20:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbhINS54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 14:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbhINS5w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 14:57:52 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A0FC061574
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 11:56:35 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id j12so434370ljg.10
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 11:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cGrN7bFxVsTMQhopk72/7YCXP3j0jBNbxEncpxpEckY=;
        b=XBhw4gx6pKPX9FTE2Eo/3NvHlQRAMmv9E9aB6Bo3AatyW184lGQOMpy2MUIM0C1xMu
         zrYVIhbhax7GofDWNS57pA/zEuqz0YO6lum+nndDm7CLkzecR08Z0NS8jGmeuARX9lD+
         uARK/NNdjmoTyKLRp+oOwHgDszSkWdNeze/wo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cGrN7bFxVsTMQhopk72/7YCXP3j0jBNbxEncpxpEckY=;
        b=QhZkxGuR9qoKvB/V3ypXd80JUJP/DoX1VSh01sJIYYuZkpkiZAQEbrO8L4JNRIl+vK
         O4aWMn2VWSVU6+DxEFw0fMD7bNOz9b+/uNtnOoNZBd72qE4PDseD85AeXI/Ou3K6THUZ
         53tyvu8f5e4TDS9QlPnQRmxC4FXTUWBw7CCDhE4RIAYw4BQTlRQ5pQfuAJKhascaKPNU
         BKZePk0shC1oiS/OpwK4KcIopx9724N5CwNxWsYmx5KAmN+9lHNirQ5CIq6SqrS1JJ6j
         +lECO8vPLlja/IequnKVFYMpahPI0eL94BkBBX5VD6AFh7y4N2ur73QHyXJmLVTDB6c1
         qoqA==
X-Gm-Message-State: AOAM531KpIGq0jq303ttGPqbld/uq5FyqIbqpQlGSWQ8LaOd83OElQr1
        Z1I+J+g1lou4SBdhKezIVXNVZpMo0n2kwMKmUbc=
X-Google-Smtp-Source: ABdhPJzdnc8RFnAhkHLNK2DqLEjFHTXrZBlw4/fwpFNRgdHCeSBup2CRTrVNR8w5kLcQee5dK/bUmw==
X-Received: by 2002:a2e:9182:: with SMTP id f2mr16171105ljg.57.1631645793204;
        Tue, 14 Sep 2021 11:56:33 -0700 (PDT)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com. [209.85.208.169])
        by smtp.gmail.com with ESMTPSA id h4sm1190948lft.184.2021.09.14.11.56.31
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 11:56:32 -0700 (PDT)
Received: by mail-lj1-f169.google.com with SMTP id s3so422707ljp.11
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 11:56:31 -0700 (PDT)
X-Received: by 2002:a2e:b53a:: with SMTP id z26mr16048407ljm.95.1631645791577;
 Tue, 14 Sep 2021 11:56:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210913203201.1844253-1-ndesaulniers@google.com>
 <195b2f47-b92e-a00b-a2bc-d91bfdbd9d12@rasmusvillemoes.dk> <202109141031.AEFD06F03F@keescook>
 <CAHk-=wjac_3K+NQNO6tjQZU1KLgba==BOvHmHE2sgNSVj3j85g@mail.gmail.com>
 <CAHk-=whiQBofgis_rkniz8GBP9wZtSZdcDEffgSLO62BUGV3gg@mail.gmail.com>
 <CAKwvOdkOHxtsRGjZ2Y8x84sBaqWy8t-U3F9UbMiR7h=3_+mtqA@mail.gmail.com> <CAHk-=wjUR7FwE5LsZNaoQxrKu2TS7T-=1j8XqZK2miQuEmqf3Q@mail.gmail.com>
In-Reply-To: <CAHk-=wjUR7FwE5LsZNaoQxrKu2TS7T-=1j8XqZK2miQuEmqf3Q@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 14 Sep 2021 11:56:15 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgPupayk3GpwSMtkV5_onFzmmK2g3WmBV1EbSCj+D0eqw@mail.gmail.com>
Message-ID: <CAHk-=wgPupayk3GpwSMtkV5_onFzmmK2g3WmBV1EbSCj+D0eqw@mail.gmail.com>
Subject: Re: [PATCH 5.10] overflow.h: use new generic division helpers to
 avoid / operator
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, llvm@lists.linux.dev,
        stable <stable@vger.kernel.org>, Arnd Bergmann <arnd@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 14, 2021 at 11:48 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> There was never anything "loff_t" about bitmask at any point.

Not 'bitmask'. It's 'blksize'. Hopefully that was obvious in context.

               Linus
