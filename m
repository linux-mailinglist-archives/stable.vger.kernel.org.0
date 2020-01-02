Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B829112E163
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 01:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727393AbgABAxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 19:53:48 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42353 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgABAxs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jan 2020 19:53:48 -0500
Received: by mail-qt1-f195.google.com with SMTP id j5so33763195qtq.9;
        Wed, 01 Jan 2020 16:53:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tXOgMh5GY5IXaTFYal/T2G14yEmfZPT1gYq2BJqVKdE=;
        b=TRwALXtzVy9QuTWJnFKRDCzuFhh8GyF19wHnAnll6DhXxS9pXJ+Ch7tRRN5C3fCDkv
         1IbVxAPIpgnQf4LD8wiy1TDG81Q0AMvgBzDmAqIBNMlcme+Lqwqzchw3cQ4KEWjb/yic
         fu0VP9depSWuKpHSYfAvSLmUA01hktReyYnPL2GeINj7lFlAlcRmoYAvCwtwdFFKa3Un
         qkskgM7rErT/9W1if+hA2UColo9MUAJzPr4zstlCqI5DuumejQ07HVmGStE48ZunKHMK
         ySKCpnNUPL/FwI/iuhjqJpqNMes5lbQunBMZ0i7gZIZ4kHb3kgWRylctP67cddWJDk6C
         WJKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=tXOgMh5GY5IXaTFYal/T2G14yEmfZPT1gYq2BJqVKdE=;
        b=Od3B8LvVI4C3pCpTJHZL+R8e5beh9TPo1Z0/WENdNvd/DxeU3YEa8IaQlvQwG88i4t
         AutUacgGywso8hkEPWIb8JO5sHHqBDlt5i+yI1PGjqw+jCM9yo0kUjMpHNMDUQ+GlRER
         bh+CFkkdYVrhL4CNFKUokCWuKwFxSh02n9eCN2frqjdn95hMgbWXdGlEilIfn5HQvs/Q
         ONT64qYvXTGRoHoWUKGRdPAwLEuHcDcqr3Ztu0HjytfyWOBP0DfRHB5nrry3sne1RcRF
         5O6V66+FCKbtN90Hg0snjnUkgDNTZtVOocX/iiq3UHQopf8VPNlkkN47ch8jtBzyYSy2
         0o3g==
X-Gm-Message-State: APjAAAUIaij4mdEHZ9W/4gYJngctddFgPnfo6ku7a0wZKYHEtL8UuPn9
        J7agRIqVhe1g8/4Jol6ZWbg=
X-Google-Smtp-Source: APXvYqzv9WjuhqYUPRh2uv1+yV26UBaEJTdz/v7WbzHkn416mRJ1ENYUceG5RPo86wsHXJqm8esF2w==
X-Received: by 2002:ac8:3526:: with SMTP id y35mr55451559qtb.97.1577926427230;
        Wed, 01 Jan 2020 16:53:47 -0800 (PST)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id g18sm14628275qki.13.2020.01.01.16.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jan 2020 16:53:47 -0800 (PST)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Wed, 1 Jan 2020 19:53:45 -0500
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Paul Burton <paulburton@kernel.org>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Christian Brauner <christian.brauner@canonical.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: [PATCH] MIPS: Don't declare __current_thread_info globally
Message-ID: <20200102005343.GA495913@rani.riverdale.lan>
References: <20200101175916.558284-1-paulburton@kernel.org>
 <CAK8P3a2a1aY9G+Nh9fy+NU=YA_m1dxm-4SCHgydVO5kcydh77g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAK8P3a2a1aY9G+Nh9fy+NU=YA_m1dxm-4SCHgydVO5kcydh77g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 01, 2020 at 09:51:02PM +0100, Arnd Bergmann wrote:
> On Wed, Jan 1, 2020 at 6:57 PM Paul Burton <paulburton@kernel.org> wrote:
> > diff --git a/arch/mips/include/asm/thread_info.h b/arch/mips/include/asm/thread_info.h
> > index 4993db40482c..aceefc3f9a1a 100644
> > --- a/arch/mips/include/asm/thread_info.h
> > +++ b/arch/mips/include/asm/thread_info.h
> > @@ -50,10 +50,10 @@ struct thread_info {
> >  }
> >
> >  /* How to get the thread information struct from C.  */
> > -register struct thread_info *__current_thread_info __asm__("$28");
> > -
> >  static inline struct thread_info *current_thread_info(void)
> >  {
> > +       register struct thread_info *__current_thread_info __asm__("$28");
> > +
> >         return __current_thread_info;
> >  }
> 
> This looks like a nice fix, but are you sure it doesn't allow the compiler to
> reuse $28 for another purpose in the kernel under register pressure,
> which would break current_thread_info()?
> 
> I see in the MIPS ABI document that $28 is preserved across function
> calls, but I don't see any indication that a function is not allowed
> to modify it and later restore the original content.
> 
>         Arnd

The compiler can already do that even with a global definition.

The doc since gcc 9 [1] says:

"Accesses to the variable may be optimized as usual and the register
remains available for allocation and use in any computations, provided
that observable values of the variable are not affected."

and

"Furthermore, since the register is not reserved exclusively for the
variable, accessing it from handlers of asynchronous signals may observe
unrelated temporary values residing in the register."

I'm not sure if this was a change in gcc 9 or simply the doc was wrong
earlier.

Should there be a -ffixed-28 cflag for MIPS? alpha and hexagon seem to
have that and they also keep current_thread_info in a register.

Also, commit fe92da0f355e9 ("MIPS: Changed current_thread_info() to an
equivalent supported by both clang and GCC") moved this from local to
global because local apparently didn't work on clang?

[1] https://gcc.gnu.org/onlinedocs/gcc-9.1.0/gcc/Global-Register-Variables.html
