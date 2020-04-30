Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC4F61C090D
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 23:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgD3VV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 17:21:28 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:47175 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbgD3VV2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Apr 2020 17:21:28 -0400
Received: from mail-qk1-f172.google.com ([209.85.222.172]) by
 mrelayeu.kundenserver.de (mreue109 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MuDPf-1jBNG71Vt7-00uWP3; Thu, 30 Apr 2020 23:21:26 +0200
Received: by mail-qk1-f172.google.com with SMTP id f83so5308qke.13;
        Thu, 30 Apr 2020 14:21:25 -0700 (PDT)
X-Gm-Message-State: AGi0PuZLjELzTWCpsdZK53t3PU6uDx+0RdnkSuBI+ycvrTkqjrc4KS01
        EMSKSmL3OMm3z5QIdkfBKs9CpxYC0G2jpkkQEXY=
X-Google-Smtp-Source: APiQypIM11fY5RukZEVskEhyZDGMXYivz+/2X4b8sNT4+8pTwghkf6LXKjfZLRy0kYFGgiYsJ6BjS/duAU2Haf7MBAg=
X-Received: by 2002:a37:63d0:: with SMTP id x199mr510171qkb.3.1588281684906;
 Thu, 30 Apr 2020 14:21:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200429190119.43595-1-arnd@arndb.de> <20200430211516.gkwaefjrzj2dypmr@cantor>
In-Reply-To: <20200430211516.gkwaefjrzj2dypmr@cantor>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 30 Apr 2020 23:21:08 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1xk9b9Ntsf302EUP2Sp+yWe5UEsbf973=xmYRkiN1KuQ@mail.gmail.com>
Message-ID: <CAK8P3a1xk9b9Ntsf302EUP2Sp+yWe5UEsbf973=xmYRkiN1KuQ@mail.gmail.com>
Subject: Re: [PATCH] efi/tpm: fix section mismatch warning
To:     Jerry Snitselaar <jsnitsel@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Ard Biesheuvel <ardb@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Dave Young <dyoung@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Lukas Wunner <lukas@wunner.de>, Lyude Paul <lyude@redhat.com>,
        Matthew Garrett <mjg59@google.com>,
        Octavian Purdila <octavian.purdila@intel.com>,
        Peter Jones <pjones@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Scott Talbert <swt@techie.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi <linux-efi@vger.kernel.org>,
        linux-integrity@vger.kernel.org,
        "# 3.4.x" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:cr9KKu2LzmYO4FyXYSmEGdwrhb3TUuPv7wwpXok6SayZxWAEtpW
 Kg7fXrBcjPhPDwtYLYxsj6ck4avLe4TULZjN5nfoVet9GIOS9bwvQAYTcDl9Ed6VzSFyD0p
 +Q4TfY6necup2e5iyPCZct2+pXX4AVp/znnntHGuV8Hqdzcjs4zD/wIHPtN0clCdtb5OBs0
 SsrwgmG9k42Se6oBdh4nQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:kiT/7gSypmQ=:AXmJggU5tYltmKHVgans+n
 DFN0z8QNYROJEbdlU5d9AI5drTeTKYNiPKZ5s1dA/0q2EBFUqm5amVd0u/4bV7wTBeWu/KqF9
 IJIGxXKUFB8HvM/aD6YNFZpNTwZGOyjTn7P2yEYiGGx38pvzMNxNEkhufYopIzGaV5KQ3E28G
 Qdzzg04YCVF9w/27Bj+x1oAW9NHIP8qAtSTcJEq0wHLZe4R3ofrSbAaZfWhq55YibpxDvSiMu
 Z9FjSnytPAbCMW28ZoVt/Bosvxgp6OMT+BIFiKhMK6ek/uqLCIohL6Cstbm//HZ0y4mKKavv3
 h5rT9dYGiv+UCmGiSv9EtgvZUFVqzg+d8VBf1J8JRFB9EXSuVD2nPrI19EmbqginKm0/+ZQgW
 UvrHHDJxiYCWsK84p314tqJqIWPnEpsVLjZcwKrAujkffPGleWwxbpQlG5PX2vu+VVvZFUWL+
 b614eK7/sIdvz30uukGsAc3GSSHDdH4DEx7CrdIn9Yn3A7TW1vhMk7ktntxrwKcmQ3/yL8Old
 BZb+HrSDDqqffjiuRoiDvGNA3cd9EinPfOud6yZwHOFsAuDKEj8Bm4Xpk+DuJUlK0nUcuONwS
 EWhaTH90QwPiS2HIh/ilA1s9bgQniqT4KelvuM7rHQMEsGosolcSovCMrlN2ylmq0svhQwAAS
 e/bgfpP7y0+RdO3CNnI9Du7LejaM7Dqoou5N78dIdHXHBXmerZLnfyhtF3p7koInrO2vJSOAD
 XqZcGQy3rAvDyXMG1hSC231/Q+omomanjqR2AC56rycMaFIO6+NaQiT1zQmOh8gq0BD/XiEUD
 1BD7Gu6BKWhCNuq4F68rvxSxBqoOqg9P2psWAfif+8YCJhHZvI=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 30, 2020 at 11:15 PM Jerry Snitselaar <jsnitsel@redhat.com> wrote:
>
> On Wed Apr 29 20, Arnd Bergmann wrote:
> >Building with gcc-10 causes a harmless warning about a section mismatch:
> >
> >WARNING: modpost: vmlinux.o(.text.unlikely+0x5e191): Section mismatch in reference from the function tpm2_calc_event_log_size() to the function .init.text:early_memunmap()
> >The function tpm2_calc_event_log_size() references
> >the function __init early_memunmap().
> >This is often because tpm2_calc_event_log_size lacks a __init
> >annotation or the annotation of early_memunmap is wrong.
> >
> >Add the missing annotation.
> >
> >Fixes: e658c82be556 ("efi/tpm: Only set 'efi_tpm_final_log_size' after successful event log parsing")
> >Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Minor thing, but should the Fixes be c46f3405692d ("tpm: Reserve the TPM final events table")? Or what am I missing
> about e658c82be556 that causes this? Just trying to understand what I did. :)

You are right, I misread the git history. Can you fix it up when applying the
patch, or should I resend it?

       Arnd
