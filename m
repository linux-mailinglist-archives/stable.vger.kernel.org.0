Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCFF1B17A5
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 22:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgDTU4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 16:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgDTU4x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Apr 2020 16:56:53 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7CA7C061A0C
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 13:56:52 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id w20so5334264ljj.0
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 13:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+YMKp9wPvX7FbDR3+6WEIzSglLbYUecdGkyUsv5KulQ=;
        b=FcXT9x/jUah+X0xgwFiqlUqBQvX1G3RiMhY/gwPoHmmY/XQlinet+aCVntYoTSXix0
         nYnC67xrDgLTWaT5S4DrH+GUnhJL1ZtDCuTvhpZ7ZxXg/ozncV3EsUCU+SCShBpzLktB
         /uVd+li/PDjb4APhJ2J6DiaYwIXndtCUke1hE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+YMKp9wPvX7FbDR3+6WEIzSglLbYUecdGkyUsv5KulQ=;
        b=p+D8AIwgTGk4rUzLroZZhgrxNJHA8WoPkmjPkFxvfmoR0MX/QbGoAiLYz673AKmeLU
         8Hd7vdrzZImIpy6SulPQd3quktGGSzTICW32v8JTsmlyjBOU8RyMIJCm76448OomDA5+
         Br+BSN1tyvHcZOcvikb5zawhjlhhrKtiPilcqACVLZN7IXK306flbxAJTS4DOGIEdEcg
         0RKLKQzkW/k7ZFBcvGZkRjcYdGi3ctETv7C/PUwCmsB5SXwrRM8zxGL1KTA2V+VInp7U
         ZnqZin5y7s6tynr2jP+YSpaP9f7/xQEYmwfzf/f+Gj7sX+7D/6tNBze28t5dtZNf2XyK
         F8BQ==
X-Gm-Message-State: AGi0PuYvmNuo3eEP63lKf72I9PZuTcFkggw2L7duRA7voIGhx8JZ7il+
        f6gQFWg7OAXo6yHRDK2qHWviOPPxRqs=
X-Google-Smtp-Source: APiQypLle5a/VXYewYj2w6Q8tXGsSmQsVA0ZGjU3MUAET62aeiCPK65KHsVowwuXS5x3/V6jaRBy6Q==
X-Received: by 2002:a2e:164e:: with SMTP id 14mr10468806ljw.253.1587416210218;
        Mon, 20 Apr 2020 13:56:50 -0700 (PDT)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id b28sm385718lfo.46.2020.04.20.13.56.48
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 13:56:49 -0700 (PDT)
Received: by mail-lf1-f48.google.com with SMTP id f8so9228726lfe.12
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 13:56:48 -0700 (PDT)
X-Received: by 2002:a19:946:: with SMTP id 67mr9797282lfj.142.1587416208523;
 Mon, 20 Apr 2020 13:56:48 -0700 (PDT)
MIME-Version: 1.0
References: <67FF611B-D10E-4BAF-92EE-684C83C9107E@amacapital.net>
 <CAHk-=wjePyyiNZo0oufYSn0s46qMYHoFyyNKhLOm5MXnKtfLcg@mail.gmail.com>
 <CAPcyv4jQ3s_ZVRvw6jAmm3vcebc-Ucf7FHYP3_nTybwdfQeG8Q@mail.gmail.com>
 <CAHk-=wjSqtXAqfUJxFtWNwmguFASTgB0dz1dT3V-78Quiezqbg@mail.gmail.com>
 <CAPcyv4hrfZsg48Gw_s7xTLLhjLTk_U+PV0MsLnG+xh3652xFCQ@mail.gmail.com>
 <CAHk-=wgcc=5kiph7o+aBZoWBCbu=9nQDQtD41DvuRRrqixohUA@mail.gmail.com>
 <CAPcyv4iTaBNPMwqUwas+J4rxd867QL7JnQBYB8NKnYaTA-R_Tw@mail.gmail.com>
 <CAHk-=wgOUOveRe8=iFWw0S1LSDEjSfQ-4bM64eiXdGj4n7Omng@mail.gmail.com>
 <20200420202332.GA30160@agluck-desk2.amr.corp.intel.com> <CAHk-=whNL-P71xQRsahpYrzKquvz3WwqPCUVPT+1TUmWZ+67TQ@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F7F5FB1C0@ORSMSX115.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F7F5FB1C0@ORSMSX115.amr.corp.intel.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 20 Apr 2020 13:56:32 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg9Qk=b5h0y=s9vUoLxAD0Nz5BrsU7g0=-ZiUFO9q3EmQ@mail.gmail.com>
Message-ID: <CAHk-=wg9Qk=b5h0y=s9vUoLxAD0Nz5BrsU7g0=-ZiUFO9q3EmQ@mail.gmail.com>
Subject: Re: [PATCH] x86/memcpy: Introduce memcpy_mcsafe_fast
To:     "Luck, Tony" <tony.luck@intel.com>
Cc:     "Williams, Dan J" <dan.j.williams@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>,
        stable <stable@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Tsaur, Erwin" <erwin.tsaur@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 20, 2020 at 1:45 PM Luck, Tony <tony.luck@intel.com> wrote:
>
> Another X86 vendor seems to be adding something like that. See MCOMMIT
> in https://www.amd.com/system/files/TechDocs/24594.pdf

That sounds potentially very expensive.

Particularly, as you say, something like the kernel (or
virtualization) may want to at least test for it cheaply on entry or
switch or whatever.

I do think you want the mcommit kind of thing for writing, but I think
the intel model of (no longer pcommit) using a writeback instruction
with a range, and then just sfence is better than a "commit
everything" thing.

But that's just for writing things, and that's fundamentally very
different from the read side errors.

So for the read-side you'd want some kind of "lfence and report"
instruction for the "did I see load errors". Very cheap like lfence,
so that there wouldn't really be a cost for the people if somebody
_really_ want to get notified immediately.

And again, it might just be part of any serializing instruction. I
don't care that much, although overloading "serializing instruction"
even more sounds like a bad idea.

               Linus
