Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 695E5536345
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 15:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244826AbiE0NVE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 09:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242354AbiE0NVD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 09:21:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8818012E301;
        Fri, 27 May 2022 06:21:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0642861C18;
        Fri, 27 May 2022 13:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB72C385A9;
        Fri, 27 May 2022 13:20:59 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="gAconhhG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1653657656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N+0wxHmueW5PC6Ruhk71jM9anOT1ArAHVn1hq5ZBoTo=;
        b=gAconhhG+s5OEFBNojX/Dv8XERWyEqqQgvLVdGk3ldiawbflA55TyjOeGfLCH9cM97InIR
        QlGBGnCQ6c/7P6Fmw3mtmh+KPg4xxXOwrFzDiBQBKLVebVycSQBJd8UDHuo3R7fjzhzRw0
        kBrpSx6cemK50G6hKahN7RcoAfgJNlo=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 16dba200 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 27 May 2022 13:20:55 +0000 (UTC)
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-3003cb4e064so46930397b3.3;
        Fri, 27 May 2022 06:20:55 -0700 (PDT)
X-Gm-Message-State: AOAM5301EQKwwPyZlWXSsMAbfl5OXH3O5z9n1OyGoTZPHYDXdd3pf3TA
        d+R4xsWheVUNg8PPLUu16Zj+KN+sW39s0TfFBak=
X-Google-Smtp-Source: ABdhPJxDoIQYBw0u5FNf+G4Ms58Dp1JfZMgNq9wGrzUMKtd/kA+5h8kZAEKXLqN65ZZrJa4NTDcMD5uBZ9Rlw5brQuU=
X-Received: by 2002:a0d:cd04:0:b0:300:4784:caa3 with SMTP id
 p4-20020a0dcd04000000b003004784caa3mr15250404ywd.231.1653657654222; Fri, 27
 May 2022 06:20:54 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7110:6403:b0:17b:2ce3:1329 with HTTP; Fri, 27 May 2022
 06:20:53 -0700 (PDT)
In-Reply-To: <ffa404b7427043fda4b9f4a20ea0f068@AcuMS.aculab.com>
References: <YpCGQvpirQWaAiRF@zx2c4.com> <20220527081106.63227-1-Jason@zx2c4.com>
 <ffa404b7427043fda4b9f4a20ea0f068@AcuMS.aculab.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 27 May 2022 15:20:53 +0200
X-Gmail-Original-Message-ID: <CAHmME9osMkustaPdiGmJ02A+5gTPvEy1EJwi5ump7REJXb1-TQ@mail.gmail.com>
Message-ID: <CAHmME9osMkustaPdiGmJ02A+5gTPvEy1EJwi5ump7REJXb1-TQ@mail.gmail.com>
Subject: Re: [PATCH crypto v2] crypto: blake2s - remove shash module
To:     David Laight <David.Laight@aculab.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        gaochao <gaochao49@huawei.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi David,

On 5/27/22, David Laight <David.Laight@aculab.com> wrote:
> From: Jason A. Donenfeld
>> Sent: 27 May 2022 09:11
>>
>> BLAKE2s has no use as an shash, with no users of it. Just remove all of
>> this unnecessary plumbing. Removing this shash was something we talked
>> about back when we were making BLAKE2s a built-in, but I simply never
>> got around to doing it. So this completes that project.
> ...
>> diff --git a/lib/crypto/blake2s.c b/lib/crypto/blake2s.c
>> index c71c09621c09..716da32cf4dc 100644
>> --- a/lib/crypto/blake2s.c
>> +++ b/lib/crypto/blake2s.c
>> @@ -16,16 +16,43 @@
>>  #include <linux/init.h>
>>  #include <linux/bug.h>
>>
>> +static inline void blake2s_set_lastblock(struct blake2s_state *state)
>> +{
>> +	state->f[0] = -1;
>> +}
>> +
>>  void blake2s_update(struct blake2s_state *state, const u8 *in, size_t
>> inlen)
>>  {
>> -	__blake2s_update(state, in, inlen, false);
>> +	const size_t fill = BLAKE2S_BLOCK_SIZE - state->buflen;
>> +
>> +	if (unlikely(!inlen))
>> +		return;
>
> Does this happen often enough to optimise for?
> The zero length memcpy() should be fine.
> (though pedants might worry about in == NULL)
>

I don't know and don't care here. This is a straight copy and paste
for the removal. It is not the place for random performance
optimizations.

I have now witnessed you have random performance optimization ideas in
at least 7 threads, usually unrelated to whatever the topic is. As I
keep telling you every time: SEND A PATCH. Those capital letters are
intentional: I care about the same things you do, so please send a
patch so that all that stuff actually happens. Talk is cheap.

Jason
