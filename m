Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCD6E12E1CE
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 04:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727516AbgABDCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 22:02:32 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:44101 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727509AbgABDCc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jan 2020 22:02:32 -0500
Received: by mail-ot1-f67.google.com with SMTP id h9so52592777otj.11;
        Wed, 01 Jan 2020 19:02:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Fsf4Kv4GKfEO6/i6UJSN8gP+gZz4MfI3CR+WieAs89w=;
        b=vIBadxwjvV/v/SLLefWz19+1AioDTALvEnFaP8rT95BPmtN3e/62j76b1AOORG48Qe
         IDRXd+Xn+DAvBi7BY4A2BoUsUDhOYPA2wTwCW9bLcOGsVAgjRzd0910Z/na4RFILuHWS
         J1a+YJq0keFdCwqEOd+rz6C0zUZLekApIqb9XNDErzrJKaKjqaIBWuo0wLgV4p7wuuy8
         m/jfmtsJh2BpuCR4QdYB9/YRgPhbWtCCELjI9A42EHfX2CuG496gcAF5iqwsVOwRVQEq
         kZhJeb4E2Lz1tQZPYSZvfzqxBf7mWqh1TExjAXqitiBtYF+eS63SV1Ox26gC7H+B/+B8
         pqNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Fsf4Kv4GKfEO6/i6UJSN8gP+gZz4MfI3CR+WieAs89w=;
        b=pl1LlwxnZzk7k9b30XD2447vxNUFkSKDbgiTihwyf8+k4P1ta1S0rvtoFU+G5Q8pvQ
         F3sjmhJEAZq74X+k7jz6OatZZlqKyb96Pj7aDbIIB27yYchtsCr2PSe4mSyOKefJkAov
         XFiXkVYS41kDXQ9GsPXEpqx0M67ITVphnpx0lr5bRbrmLPNj1+hNmbUGPBdDtZGiof4Y
         WMGhsojrqDVP6eL3AsCzthXlxw6XO8ZbF96lmJguAEsk2dszBPsTNjgXjZEgh5xMTorg
         Gf0L3FX9y/RzLx3Jogkz5ctr9lV1T608or8R4bTO4sX5N46xILrJoCHs686nD9LwOFz3
         hHVw==
X-Gm-Message-State: APjAAAVCGvWx6gcK5te6G8iXMnrtAkTnNk1DESaB2BL1jO14dWdBJvW+
        coZ5BODNNIvlSEx9FSIrDrw=
X-Google-Smtp-Source: APXvYqzoLpLSXZFPvEA4NYFeyEPZZRJGs7+UcTKd38N7T/VHbUGey27aXUQ8MAS5JAtnEFArNcgiMQ==
X-Received: by 2002:a05:6830:15a:: with SMTP id j26mr85700884otp.137.1577934151509;
        Wed, 01 Jan 2020 19:02:31 -0800 (PST)
Received: from ubuntu-m2-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id o20sm15235472oie.23.2020.01.01.19.02.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 01 Jan 2020 19:02:30 -0800 (PST)
Date:   Wed, 1 Jan 2020 20:02:29 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     Arnd Bergmann <arnd@arndb.de>, Paul Burton <paulburton@kernel.org>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Christian Brauner <christian.brauner@canonical.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] MIPS: Don't declare __current_thread_info globally
Message-ID: <20200102030229.GA4478@ubuntu-m2-xlarge-x86>
References: <20200101175916.558284-1-paulburton@kernel.org>
 <CAK8P3a2a1aY9G+Nh9fy+NU=YA_m1dxm-4SCHgydVO5kcydh77g@mail.gmail.com>
 <20200102005343.GA495913@rani.riverdale.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200102005343.GA495913@rani.riverdale.lan>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 01, 2020 at 07:53:45PM -0500, Arvind Sankar wrote:
> On Wed, Jan 01, 2020 at 09:51:02PM +0100, Arnd Bergmann wrote:
> > On Wed, Jan 1, 2020 at 6:57 PM Paul Burton <paulburton@kernel.org> wrote:
> > > diff --git a/arch/mips/include/asm/thread_info.h b/arch/mips/include/asm/thread_info.h
> > > index 4993db40482c..aceefc3f9a1a 100644
> > > --- a/arch/mips/include/asm/thread_info.h
> > > +++ b/arch/mips/include/asm/thread_info.h
> > > @@ -50,10 +50,10 @@ struct thread_info {
> > >  }
> > >
> > >  /* How to get the thread information struct from C.  */
> > > -register struct thread_info *__current_thread_info __asm__("$28");
> > > -
> > >  static inline struct thread_info *current_thread_info(void)
> > >  {
> > > +       register struct thread_info *__current_thread_info __asm__("$28");
> > > +
> > >         return __current_thread_info;
> > >  }
> > 
> > This looks like a nice fix, but are you sure it doesn't allow the compiler to
> > reuse $28 for another purpose in the kernel under register pressure,
> > which would break current_thread_info()?
> > 
> > I see in the MIPS ABI document that $28 is preserved across function
> > calls, but I don't see any indication that a function is not allowed
> > to modify it and later restore the original content.
> > 
> >         Arnd
> 
> The compiler can already do that even with a global definition.
> 
> The doc since gcc 9 [1] says:
> 
> "Accesses to the variable may be optimized as usual and the register
> remains available for allocation and use in any computations, provided
> that observable values of the variable are not affected."
> 
> and
> 
> "Furthermore, since the register is not reserved exclusively for the
> variable, accessing it from handlers of asynchronous signals may observe
> unrelated temporary values residing in the register."
> 
> I'm not sure if this was a change in gcc 9 or simply the doc was wrong
> earlier.
> 
> Should there be a -ffixed-28 cflag for MIPS? alpha and hexagon seem to
> have that and they also keep current_thread_info in a register.
> 
> Also, commit fe92da0f355e9 ("MIPS: Changed current_thread_info() to an
> equivalent supported by both clang and GCC") moved this from local to
> global because local apparently didn't work on clang?
> 
> [1] https://gcc.gnu.org/onlinedocs/gcc-9.1.0/gcc/Global-Register-Variables.html

Yeah this patch appears to break booting malta_defconfig in QEMU when
built with clang; additionally, there are a TON of warnings about this
variable being uninitialized:

../arch/mips/include/asm/thread_info.h:57:9: warning: variable '__current_thread_info' is uninitialized when used here [-Wuninitialized]
        return __current_thread_info;
               ^~~~~~~~~~~~~~~~~~~~~
../arch/mips/include/asm/thread_info.h:55:52: note: initialize the variable '__current_thread_info' to silence this warning
        register struct thread_info *__current_thread_info __asm__("$28");
                                                          ^
                                                           = NULL
1 warning generated.

Seems like this is expected according to that previous commit? I
noticed there is another instance in arch/mips but it doesn't appear to
affect everything.

https://github.com/ClangBuiltLinux/linux/issues/606

Cheers,
Nathan
