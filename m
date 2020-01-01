Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79B3C12E071
	for <lists+stable@lfdr.de>; Wed,  1 Jan 2020 21:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbgAAUvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 15:51:21 -0500
Received: from mout.kundenserver.de ([217.72.192.73]:56947 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727215AbgAAUvV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jan 2020 15:51:21 -0500
Received: from mail-qk1-f178.google.com ([209.85.222.178]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MWBGG-1jG20514Qc-00Xf5u; Wed, 01 Jan 2020 21:51:19 +0100
Received: by mail-qk1-f178.google.com with SMTP id x129so30166581qke.8;
        Wed, 01 Jan 2020 12:51:18 -0800 (PST)
X-Gm-Message-State: APjAAAWSqrOU/sHxPHKlWeKo828rBE0U0DVU7TqNMtKhhvffNl5rYXmO
        YAkB2W+/gVgELNz/hVD9tcVp3lLPgTX+09e4J2g=
X-Google-Smtp-Source: APXvYqwPUffdxOwkYrrGlQKEUjh0DqO0/sbzUbDfmtql+dmrfAoS6A5yQuvY8II40XAftlk8yxtyRvUCyFvgSLjFMYA=
X-Received: by 2002:a37:2f02:: with SMTP id v2mr61985919qkh.3.1577911877938;
 Wed, 01 Jan 2020 12:51:17 -0800 (PST)
MIME-Version: 1.0
References: <20200101175916.558284-1-paulburton@kernel.org>
In-Reply-To: <20200101175916.558284-1-paulburton@kernel.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 1 Jan 2020 21:51:02 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2a1aY9G+Nh9fy+NU=YA_m1dxm-4SCHgydVO5kcydh77g@mail.gmail.com>
Message-ID: <CAK8P3a2a1aY9G+Nh9fy+NU=YA_m1dxm-4SCHgydVO5kcydh77g@mail.gmail.com>
Subject: Re: [PATCH] MIPS: Don't declare __current_thread_info globally
To:     Paul Burton <paulburton@kernel.org>
Cc:     "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Christian Brauner <christian.brauner@canonical.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:2rtdkpAtrO0rIVNjV1PXPRT+x8s3zFerjLVvDm+ppkfNc7XJJEK
 AiDvikYtt3241DVPkLSLr+K2fHRZuP4gxEPIdDvDbezRbFeJy3JkevOYVRGXRMuDFMCvCFO
 Lnm9lg8vSVpYV57tQa7eTEcfA8H5FjNMIQkcAR9hjp1W4Bo16HE+aCdQURqu4AYV369SPZg
 JKyA1VT3AeZGpVZBE1yyw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:AqZ9YiHFvQI=:jC67QZvuDmpFXxawCRXEsa
 RrW2E3H5LRNThKJnVq2V6Tz2EuehJm5Ve9ex4cVLCvN2ayOlhTf/nDxaSh3a2GwY52ssH8yO4
 zn4oMlz+xNSqzkcwBsPU10rjsx5BweuGdgudFdSoQnKBQgqHUq3hAF6BYVDtJaGkOKMGokZla
 epXCh6sEHPoIbuBPuZ95GK/qSnulXbr2NHuy8zTp7HxL37N503i0Eg8FskyzYuhzUqHZg4fBP
 JgMVSg6mJf5o5iPjHEoMwqOlwprhvb3mVDWlKGMRsApdi8Sbcbrp7fBxn4yeFUZbM0ti+VGa7
 tt7fcVxICve2K53j+s+IIUcjofffK66rOx7NDiHoTxV2irVnCBiR29aUO8nF2MczpQmiWcq1Q
 /q/kj6LKAaBhCklOt1riFBhKWS1VAR3BmkMH0aegN7rIYNQfKD5NM+1mUjkw3Vngvpr/F33sn
 Rhe+7m0fHO6tIYTVrxsp6CDOzxeQ+dK4PUpacTpQ0TvFWXDx0eABuEhip2DwtKVGu08SdDKVI
 8regV24yt/5+HXdLNXq3u6rd01a4WGWtPE9YYAUskv4ZXQ3kT7OlZaOOzKAHW53Iv1e4+NefT
 D67Vs+DaDtqnf9Qqbi1CaoLAK9kwPtFGI2G250FH7hZ2dJHou23+RF04WvUrImUAoEkHrIbVS
 Jn+TY8XJIY9OmeDmObBsm7Vc/XtS2cppyGAjuUQZcS6inEAd/rGt1Ewka27JWuUOPAuh+Gr+c
 5vhg3wCoXv4ij6BFvxB68FgFLK2W4WKrQSEOK7I7Bx9iUjn6SBAPzqa/IYuSAEf+sbqFuCxgP
 almClZtq4DrEQAvqURUKGNu//z1TGTj204w6VeqSD4XX35MvfreohfinUWDmGqrJkC5/VmJAM
 5GOnnA/zdVa+e9DtdH7g==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 1, 2020 at 6:57 PM Paul Burton <paulburton@kernel.org> wrote:
> diff --git a/arch/mips/include/asm/thread_info.h b/arch/mips/include/asm/thread_info.h
> index 4993db40482c..aceefc3f9a1a 100644
> --- a/arch/mips/include/asm/thread_info.h
> +++ b/arch/mips/include/asm/thread_info.h
> @@ -50,10 +50,10 @@ struct thread_info {
>  }
>
>  /* How to get the thread information struct from C.  */
> -register struct thread_info *__current_thread_info __asm__("$28");
> -
>  static inline struct thread_info *current_thread_info(void)
>  {
> +       register struct thread_info *__current_thread_info __asm__("$28");
> +
>         return __current_thread_info;
>  }

This looks like a nice fix, but are you sure it doesn't allow the compiler to
reuse $28 for another purpose in the kernel under register pressure,
which would break current_thread_info()?

I see in the MIPS ABI document that $28 is preserved across function
calls, but I don't see any indication that a function is not allowed
to modify it and later restore the original content.

        Arnd
