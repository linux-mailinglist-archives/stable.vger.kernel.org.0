Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C64027EF2C
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 18:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731077AbgI3Q2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 12:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI3Q2x (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Sep 2020 12:28:53 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C48C061755
        for <stable@vger.kernel.org>; Wed, 30 Sep 2020 09:28:53 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id u8so2921625lff.1
        for <stable@vger.kernel.org>; Wed, 30 Sep 2020 09:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v+misetaEJ1mwAT301R0A9ZIkFxdOGA996KoWa9fftk=;
        b=Sh6cwwahX+/y+BSWSCbArvYObCc1HWuntrcLxuME+7ufy6lS8eVNK//JaRPTKxHkMW
         /vI8TjEolAzzydnudtc2FOmU3njVteq6rwfp7z26pcwIJ/RgtV+gmPoQq2+bX1bE0ivo
         27/jAYWu30gafN/4p4RpUq/aWe96VB6akyMRA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v+misetaEJ1mwAT301R0A9ZIkFxdOGA996KoWa9fftk=;
        b=linXjR2AuT1BOSzGEHBbqE7CYFlPwjB/Aqj18MS4Dx8WARTSFUiPoRifHkQsoDoG1e
         9/QvEoNdOp+oGKQ3VjLlwINHhgud8RkBRRpf+ru9z3dwWdamKuYss3/uzwOhWOd3fgVo
         eRWRq9jhOfY708aadpeibNOaBzDVAXtn4zjaPQ9rGACeHN1HbmCpI6oT6CkSxFzKUmju
         h5a0dkc94Ifn+Uwb6kP2gZPHkknWFuewkvNdTYO3g4prUm0c9ySUv8UhfuAkDf6RfLmY
         S1tnTp8ioZjX4pOuLFB0Qw4+rl7g/ttweeJfSO4bB5kP/8x8zYh3hw6vhBDmOWagxa0y
         vy/w==
X-Gm-Message-State: AOAM533uTJwRqbJoqB8GWhl5PdUXxxCYJol1ssOZjYGxuj3p1aXzOrwM
        nUu7L/5H8Fks2moZmf4rnBPwnBjrQZtvUw==
X-Google-Smtp-Source: ABdhPJxDzpEwYb6wFm+ZHDypf0Y48hcYTCqNRd91KV/BRfAAgUXD6u8BHQ6BlecNWD6jWmHZG2bALA==
X-Received: by 2002:a19:3c8:: with SMTP id 191mr1072304lfd.594.1601483331713;
        Wed, 30 Sep 2020 09:28:51 -0700 (PDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id b21sm246082lfb.52.2020.09.30.09.28.49
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 09:28:50 -0700 (PDT)
Received: by mail-lf1-f52.google.com with SMTP id b12so2890658lfp.9
        for <stable@vger.kernel.org>; Wed, 30 Sep 2020 09:28:49 -0700 (PDT)
X-Received: by 2002:ac2:5594:: with SMTP id v20mr1237100lfg.344.1601483329141;
 Wed, 30 Sep 2020 09:28:49 -0700 (PDT)
MIME-Version: 1.0
References: <160087928642.3520.17063139768910633998.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAPcyv4iPuRWSv_do_h8stU0-SiWxtKkQWvzBEU+78fDE6VffmA@mail.gmail.com>
 <20200930050455.GA6810@zn.tnic> <CAPcyv4j=eyVMbcnrGDGaPe4AVXy5pJwa6EapH3ePh+JdF6zxnQ@mail.gmail.com>
 <20200930162403.GI6810@zn.tnic>
In-Reply-To: <20200930162403.GI6810@zn.tnic>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 30 Sep 2020 09:28:33 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjmtMDW2oUfGrXTKcESqEHx1vWCqO65o051UNL-cX9AAg@mail.gmail.com>
Message-ID: <CAHk-=wjmtMDW2oUfGrXTKcESqEHx1vWCqO65o051UNL-cX9AAg@mail.gmail.com>
Subject: Re: [PATCH v9 0/2] Renovate memcpy_mcsafe with copy_mc_to_{user, kernel}
To:     Borislav Petkov <bp@alien8.de>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        stable <stable@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        0day robot <lkp@intel.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 30, 2020 at 9:24 AM Borislav Petkov <bp@alien8.de> wrote:
>
> Ok, I'll try to queue them but pls respin soonish. That is, if Linus
> cuts -rc8 we have plenty of time but he didn't sound 100% on the -rc8
> thing.

Oh, it's pretty much 100%.

I can't imagine what would make me skip an rc8 at this point.
Everything looks good right now (but not rc7, we had a stupid bug),
but I'd rather wait a week than fins another silly bug the day after
release (like happened in rc7)..

We're talking literal "biblical burning bushes telling me to do a
release" kind of events to skip rc8 by now.

           Linus
