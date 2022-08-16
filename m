Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23376595544
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 10:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbiHPIbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 04:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232963AbiHPIaE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 04:30:04 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7A9193FA
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 22:53:08 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id kb8so17035698ejc.4
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 22:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=WBv3h3wgQyY1EiVeiutsnqi3DPEWUTFH2e+SxIIu+SI=;
        b=HMgDCIXlUYJ6kJuRhk+eXtuR9vuZC+EQUek1ea7s4szj5UjzZ0duIpqooXHBusQSn3
         2C1m8fobBSmp7OoimIVuJSe5viRJfsH3IXM7JVm4shRAKMJvp9GtGyRvl5HJ4S4/A7CS
         8yKVcomowZtnMK4E6sYXaCaspJq0LI7wL44x0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=WBv3h3wgQyY1EiVeiutsnqi3DPEWUTFH2e+SxIIu+SI=;
        b=qcJa7Qd/RPrGVL07WgnYBFpA5N+KyKiVMYW3RIEi7bzgMN1Ww7yc1yrzNwcjUKQhwL
         phlSswgF4ms7FrRn8pUtB24nup39tiTKfpaAU77mNbXwvmOV5R6yk75jjPSBIP6ihZxA
         F89AQD25z6i75Tf2vrbsHkLnRvuzkPiK/G+2QHlQ6GTBfpBYchpD+FUiZAW0w99TwbBc
         pViEj11cX3ZPMM67FQW7LZqGG21+u49gtuIiaDfgF6WrekXJCCWLzUn+lNz04kWFwY42
         kvdY5mVUwvEhuh1c8ckFhY4w3QPuePsO2ZiSzTTlBBUg3dioByb3AYXcgXLGkfMjpPjF
         iggg==
X-Gm-Message-State: ACgBeo37KA/wdh5wMPycsBliwtsctNldUQTmJJ+RlB13hI0yniF4rPHh
        I4+lnM8001FGMq5tzY45sQNOgY0Rd5WfnYW2IiA=
X-Google-Smtp-Source: AA6agR5fAkiVgCgY2ctW0UhufSuuIAj2Av6pTI7+cNcVn6W+ROwfwObG4IHb/OxEYcrSjtadIZmRHA==
X-Received: by 2002:a17:907:7348:b0:731:535e:abc7 with SMTP id dq8-20020a170907734800b00731535eabc7mr12820629ejc.274.1660629187118;
        Mon, 15 Aug 2022 22:53:07 -0700 (PDT)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com. [209.85.221.47])
        by smtp.gmail.com with ESMTPSA id se28-20020a170906ce5c00b0072b41776dd1sm4879962ejb.24.2022.08.15.22.53.05
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Aug 2022 22:53:05 -0700 (PDT)
Received: by mail-wr1-f47.google.com with SMTP id z16so11298524wrh.12
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 22:53:05 -0700 (PDT)
X-Received: by 2002:adf:b343:0:b0:225:1a75:2a9a with SMTP id
 k3-20020adfb343000000b002251a752a9amr270998wrd.281.1660629185303; Mon, 15 Aug
 2022 22:53:05 -0700 (PDT)
MIME-Version: 1.0
References: <YvqaK3hxix9AaQBO@slm.duckdns.org> <YvsZ6vObgLaDeSZk@gondor.apana.org.au>
 <CAHk-=wgSNiT5qJX53RHtWECsUiFq6d6VWYNAvu71ViOEan07yw@mail.gmail.com> <cd51b422-89f3-1856-5d3b-d6e5b0029085@marcan.st>
In-Reply-To: <cd51b422-89f3-1856-5d3b-d6e5b0029085@marcan.st>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 15 Aug 2022 22:52:49 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjfLT7nL8pV8RWATpjgm0zDtUwT8UMtroqnGcXRjN8tgw@mail.gmail.com>
Message-ID: <CAHk-=wjfLT7nL8pV8RWATpjgm0zDtUwT8UMtroqnGcXRjN8tgw@mail.gmail.com>
Subject: Re: [PATCH] workqueue: Fix memory ordering race in queue_work*()
To:     Hector Martin <marcan@marcan.st>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Will Deacon <will@kernel.org>, Tejun Heo <tj@kernel.org>,
        peterz@infradead.org, jirislaby@kernel.org, maz@kernel.org,
        mark.rutland@arm.com, boqun.feng@gmail.com,
        catalin.marinas@arm.com, oneukum@suse.com,
        roman.penyaev@profitbricks.com, asahi@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 15, 2022 at 10:36 PM Hector Martin <marcan@marcan.st> wrote:
>
> These ops are documented in Documentation/atomic_bitops.txt as being
> unordered in the failure ("bit was already set" case), and that matches
> the generic implementation (which arm64 uses).

Yeah, that documentation is pure garbage. We need to fix it.

I think that "unordered on failure" was added at the same time that
the generic implementation was rewritten.

IOW, the documentation was changed to match that broken
implementation, but it's clearly completely broken.

I think I understand *why* it's broken - it looks like a "harmless"
optimization. After all, if the bitop doesn't do anything, there's
nothing to order it with.

It makes a certain amount of sense - as long as you don't think about
it too hard.

The reason it is completely and utterly broken is that it's not
actually just "the bitop doesn't do anything". Even when it doesn't
change the bit value, just the ordering of the read of the old bit
value can be meaningful, exactly for that case of "I added more work
to the queue, I need to set the bit to tell the consumers, and if I'm
the first person to set the bit I may need to wake the consumer up".


> On the other hand, Twitter just pointed out that contradicting
> documentation exists (I believe this was the source of the third party
> doc I found that claimed it's always a barrier):

It's not just that other documentation exists - it's literally that
the unordered semantics don't even make sense, and don't match reality
and history.

And nobody thought about it or caught it at the time.

The Xen people seem to have noticed at some point, and tried to
introduce a "sync_set_set()"

> So either one doc and the implementation are wrong, or the other doc is
> wrong.

That doc and the generic implementation is clearly wrong.

              Linus
