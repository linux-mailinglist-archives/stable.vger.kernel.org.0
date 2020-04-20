Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D773D1B1714
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 22:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgDTU15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 16:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgDTU15 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Apr 2020 16:27:57 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1625C061A0C
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 13:27:56 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id x23so9172927lfq.1
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 13:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7lXVFlCuhZRlNIKPWno7jyPJtjBUewfnSNmf8ZBkjkU=;
        b=cn88vqLJ3iqpfoPaMzWrtCIV4M8jcHhWWu71rGqbgTe5Q/UQn2kwB72nwO+wt0ZsxV
         Fe0cMAvboICZetRhUSad49xM+2KRg2LEkiMxaySpZdfmgaSTauF8lNCz7NT6nkAP+jvT
         GCDKi7YV6yK0o0sTidFCFjCHDaGmRz+vbXKJo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7lXVFlCuhZRlNIKPWno7jyPJtjBUewfnSNmf8ZBkjkU=;
        b=q3KMzrBWOiI65fcCioc+8DZVEadb2NcPFyc/4SPAcjxbPvsggPOlkgbmqm0tML6D8H
         vVIAJtFmFs3hQfXoYJt9oEyxkEB8ENUBMUmeAYkaZuonpa8i3k0UO5YinJLaBQIEdUyj
         HCc3vFED6KwdG4y2qXH7lZPyD5/LHFFW7vdCGKMjBme1KvYekV4hDmdhnQJ7z9EWFsQh
         wP9B8ZEs23mCjztHGyPpfhrHY4NF6EXTc70dBXD+h6V4b/GJVPfYmJz3oDViqQzZ+275
         ywHIdSYHxghVnqG0kW7+2+nbOQjqFkKP8qZezTbnm5ApPQEskeGricOykq9uR17ja5RC
         lEqA==
X-Gm-Message-State: AGi0Pua9Eydr4aroiyL8D9UZeYJNPlG5BhpD3DmXOp8gQZTGnyibTeIj
        sdtR7euQ0LdlXAsUaCeP8TnMymAMpwo=
X-Google-Smtp-Source: APiQypKF9Nu5k+VygaZgU43EsWPaYpYCY2JlKzXiNPZ6Wxx0Jx6kyPGKbiVj3CyJqW6QSyZChMGViQ==
X-Received: by 2002:a19:ee06:: with SMTP id g6mr11662005lfb.90.1587414474201;
        Mon, 20 Apr 2020 13:27:54 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id u13sm390620lji.27.2020.04.20.13.27.52
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 13:27:53 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id m2so9143694lfo.6
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 13:27:52 -0700 (PDT)
X-Received: by 2002:a05:6512:405:: with SMTP id u5mr11369327lfk.192.1587414472376;
 Mon, 20 Apr 2020 13:27:52 -0700 (PDT)
MIME-Version: 1.0
References: <67FF611B-D10E-4BAF-92EE-684C83C9107E@amacapital.net>
 <CAHk-=wjePyyiNZo0oufYSn0s46qMYHoFyyNKhLOm5MXnKtfLcg@mail.gmail.com>
 <CAPcyv4jQ3s_ZVRvw6jAmm3vcebc-Ucf7FHYP3_nTybwdfQeG8Q@mail.gmail.com>
 <CAHk-=wjSqtXAqfUJxFtWNwmguFASTgB0dz1dT3V-78Quiezqbg@mail.gmail.com>
 <CAPcyv4hrfZsg48Gw_s7xTLLhjLTk_U+PV0MsLnG+xh3652xFCQ@mail.gmail.com>
 <CAHk-=wgcc=5kiph7o+aBZoWBCbu=9nQDQtD41DvuRRrqixohUA@mail.gmail.com>
 <CAPcyv4iTaBNPMwqUwas+J4rxd867QL7JnQBYB8NKnYaTA-R_Tw@mail.gmail.com>
 <CAHk-=wgOUOveRe8=iFWw0S1LSDEjSfQ-4bM64eiXdGj4n7Omng@mail.gmail.com> <20200420202332.GA30160@agluck-desk2.amr.corp.intel.com>
In-Reply-To: <20200420202332.GA30160@agluck-desk2.amr.corp.intel.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 20 Apr 2020 13:27:36 -0700
X-Gmail-Original-Message-ID: <CAHk-=whNL-P71xQRsahpYrzKquvz3WwqPCUVPT+1TUmWZ+67TQ@mail.gmail.com>
Message-ID: <CAHk-=whNL-P71xQRsahpYrzKquvz3WwqPCUVPT+1TUmWZ+67TQ@mail.gmail.com>
Subject: Re: [PATCH] x86/memcpy: Introduce memcpy_mcsafe_fast
To:     "Luck, Tony" <tony.luck@intel.com>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>,
        stable <stable@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 20, 2020 at 1:23 PM Luck, Tony <tony.luck@intel.com> wrote:
>
> I think they do. If the result of the wrong data has already
> been sent out the network before you process the signal, then you
> will need far smarter application software than has ever been written
> to hunt it down and stop the spread of the bogus result.

Bah. That's a completely red herring argument.

By "asynchronous" I don't mean "hours later".

Make it be "interrupts are enabled, before serializing instruction".

Yes, we want bounded error handling latency. But that doesn't mean "synchronous"

           Linus
