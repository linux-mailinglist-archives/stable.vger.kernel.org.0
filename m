Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC60214F29
	for <lists+stable@lfdr.de>; Sun,  5 Jul 2020 22:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgGEULO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jul 2020 16:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728145AbgGEULO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jul 2020 16:11:14 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F99C061794
        for <stable@vger.kernel.org>; Sun,  5 Jul 2020 13:11:13 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id u25so21452567lfm.1
        for <stable@vger.kernel.org>; Sun, 05 Jul 2020 13:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bli7823nzgPd4+zzTvhEWYIQlQOolCEdTUm/wr04xHI=;
        b=R7tVqK4S06XyeSJoTsJjrNQfFwww4cEHoPm/CtrrugENTDy1vqCVO+sDyMGWTFks1W
         5RawwMRBiS/INbOjWFg3B9vdk7NUoOnjuO+5/kBRz+Eb+sT5BIBi86j23t13MrcW941E
         tjh8GC9eV5hPjYuXImtn6v1yDp1zlaW2xJOOU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bli7823nzgPd4+zzTvhEWYIQlQOolCEdTUm/wr04xHI=;
        b=NpTj2BUun8I7BeBCyfwsPJCAfLWSS6g8ljfgLNuGqYQQZiMskBX28qPmYOAM3OH3/C
         ZgUnsWfEC1wrnJj9IIMBmq2F3vtsK0fwCpNvTNYaLy4P4nnBqUNXMTPDD80GnHXdkpSo
         f9b46/k0hlfaGeURB6ylAe6ImslAOj0rtSoz58yLiCRx8vNKVWp4Vv/kkpkCfLEWU2Af
         YO1idvbBAkGPKtARZ5FPHI/HAAQ6m3euZHGNM2JKNXekCHAW+/cJFoPEKC8IfmFs7Uml
         gFRF0xFWxSLOjeYAQU5Gec1kAtdmqUZn1Cpx3liPShJ75Y4G8J0+NzLSdwERF2YzBgja
         pEBQ==
X-Gm-Message-State: AOAM5304cDl6vaJP9kdeY7lWvKQGr5AWWq0fyqQJasyTxpy7vSF9fibv
        aV0fh0CEPyYb7ojBMm4BK5J8EydptUk=
X-Google-Smtp-Source: ABdhPJyRwZFsOKtqMOpz/0yJJ5YZRi3BAf8L4LCdAc2Ag5WlgpSmEKkORcyyRi1yqy6UvZPZvOHbmg==
X-Received: by 2002:a19:8608:: with SMTP id i8mr15425461lfd.54.1593979872037;
        Sun, 05 Jul 2020 13:11:12 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id y69sm8356001lfa.86.2020.07.05.13.11.10
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 13:11:10 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id b25so39315844ljp.6
        for <stable@vger.kernel.org>; Sun, 05 Jul 2020 13:11:10 -0700 (PDT)
X-Received: by 2002:a2e:9b42:: with SMTP id o2mr24759339ljj.102.1593979869955;
 Sun, 05 Jul 2020 13:11:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200702232638.2946421-1-keescook@chromium.org>
 <20200702232638.2946421-5-keescook@chromium.org> <CAHk-=wiZi-v8Xgu_B3wV0B4RQYngKyPeONdiXNgrHJFU5jbe1w@mail.gmail.com>
 <202007030848.265EA58@keescook>
In-Reply-To: <202007030848.265EA58@keescook>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 5 Jul 2020 13:10:54 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgEkTsNRvEM9W_JiVN6t70SnPuP=-1=LyhLS_BJ25Q4sQ@mail.gmail.com>
Message-ID: <CAHk-=wgEkTsNRvEM9W_JiVN6t70SnPuP=-1=LyhLS_BJ25Q4sQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] kprobes: Do not expose probe addresses to non-CAP_SYSLOG
To:     Kees Cook <keescook@chromium.org>
Cc:     Dominik Czarnota <dominik.czarnota@trailofbits.com>,
        stable <stable@vger.kernel.org>, Jessica Yu <jeyu@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Will Deacon <will@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matteo Croce <mcroce@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 3, 2020 at 8:50 AM Kees Cook <keescook@chromium.org> wrote:
>
> With 67 kthreads on a booted system, this patch does not immediately
> blow up...

Did you try making read/write inc/dec that thing too? Or does that
just blow up with tons of warnings?

                 Linus
