Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E221578999
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 20:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235941AbiGRSeX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 14:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234674AbiGRSeW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 14:34:22 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A033A8
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 11:34:21 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id oy13so22852326ejb.1
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 11:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uKNO/2jKtYxtHpiKjjZWFyfX1vgvMagozZ10mRTcyRY=;
        b=IBilH2yk53/8G11w0puh2eRVbRH56qZC4Tjg3Pq7xlpPa17Nee9c7J7l1O2yx6UVN0
         z3xxHnOh5QjU9uN/l6evyV0y+yYqZOk6RJ/fGPflrU720VaN8nL55cKT5RMTIrXLfAFu
         hmXxGCVcHQ+wDwrb4zsbvFrKF9iDVqdEu3NLQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uKNO/2jKtYxtHpiKjjZWFyfX1vgvMagozZ10mRTcyRY=;
        b=bpg2P4OEykiE8xuIi7dFTWZ9pfDCX8IValK1V4XumjnUEa31mNXbLk/ep3k9nKZzLE
         Zq3X2BcPuG4oHxhg/QHOvkFn8wATjCkQXYfC8RAMWtdZyc5EXpLSc3Q1Jz88sALZocsv
         2hpgp/liFcT62Wi8l7oDNLEnSDc4Gay2dsVb/zR1cXUFAWOw5w03KB+Wt1DVv0WrgMGJ
         d9VfRsQDs1QIoGdEOodnxjppHPx7ABlCvLG0D3N9LhY88MRAnkjZpbBV88nRKrgwr5Ub
         k+71baZAg7EeDRh9FiokpPxCwjmY40huBwrKJZQSH7LEdQ3+ZYLFy7bsheCpsqMFiqKV
         sPnA==
X-Gm-Message-State: AJIora97zppEnhXyXU09ZZkUneL4mfDbPtkm3Tdf89Ut8vgi3oYFf9tp
        cLX3pKCRQeikBKQPbH9MRit8AhPhLBG8JP/F
X-Google-Smtp-Source: AGRyM1tW+4sqorjrZC+8Clz7Gq9rhXcU/h6eTd95m/k3IXAe6SkWvvStHqITqlRImzAEWzSKbACTQw==
X-Received: by 2002:a17:907:7295:b0:72b:8207:bdc2 with SMTP id dt21-20020a170907729500b0072b8207bdc2mr27024917ejc.753.1658169259996;
        Mon, 18 Jul 2022 11:34:19 -0700 (PDT)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com. [209.85.221.44])
        by smtp.gmail.com with ESMTPSA id x18-20020a170906297200b00728f6d4d0d7sm5767365ejd.67.2022.07.18.11.34.19
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jul 2022 11:34:19 -0700 (PDT)
Received: by mail-wr1-f44.google.com with SMTP id e15so13071432wro.5
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 11:34:19 -0700 (PDT)
X-Received: by 2002:a5d:544b:0:b0:21d:70cb:b4a2 with SMTP id
 w11-20020a5d544b000000b0021d70cbb4a2mr23607916wrv.281.1658169258764; Mon, 18
 Jul 2022 11:34:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220715194550.793957-1-cascardo@canonical.com>
 <YtVG8VBmFikS6GMn@worktop.programming.kicks-ass.net> <YtWKK2ZLib1R7itI@zn.tnic>
In-Reply-To: <YtWKK2ZLib1R7itI@zn.tnic>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 18 Jul 2022 11:34:02 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiWQOsxqE+tvZi_MjzGaqfG6Xo5AhbYXtiLWcKVVvbycQ@mail.gmail.com>
Message-ID: <CAHk-=wiWQOsxqE+tvZi_MjzGaqfG6Xo5AhbYXtiLWcKVVvbycQ@mail.gmail.com>
Subject: Re: [PATCH] efi/x86: use naked RET on mixed mode call wrapper
To:     Borislav Petkov <bp@suse.de>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi <linux-efi@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        stable <stable@vger.kernel.org>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 18, 2022 at 9:28 AM Borislav Petkov <bp@suse.de> wrote:
>
> So I'm being told we need to untrain on return from EFI to protect the
> kernel from it.

Why would we have to protect the kernel from EFI?

If we can't trust EFI, then the machine is already compromised. We
just *called* an EFI routine, if EFI is untrusted, it did something
random.

I mean, it could have already done something bad at boot time when it
loaded the kernel.

So no, let's not "protect ourselves from EFI".

             Linus
