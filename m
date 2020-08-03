Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A8123AE06
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 22:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgHCUP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 16:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgHCUP3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Aug 2020 16:15:29 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1FAC06174A;
        Mon,  3 Aug 2020 13:15:29 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id t23so26123413qto.3;
        Mon, 03 Aug 2020 13:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wIzAc23M6SmVRHfzbQTJsd5meKdIF3mKB2ogEoSxK28=;
        b=Mb3JcqW+XFn1zZNLDNtYzvQ7fYRa2tYUzI3gZFDWNUWde5OcP26V0oh+PjD35OCSzB
         bzMPfV03KjMF0FQBDerQ64AKSYaoszLeYaXvJK0c2834Apz3yejXmA+jjGn9DCQ++cbt
         PJDN6Oi3rIRwOLAUF4YqK7/UbjnycJ1TK3UGqO2C3liIo2HQiUA03NRBMMQDpvBAQrbC
         IOL7zWOem7AHl2unr256yMU8jaPwjG4/WPHVtoLmGLQp46VGFMlnLhTIzAgCw3gEtz2/
         aWgH35uAWnE/OxW9pXO4WeDglTwikPls/ndMJJT+REEG3d7QoMRrRkpbl2QrssGKrPQ2
         5T7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=wIzAc23M6SmVRHfzbQTJsd5meKdIF3mKB2ogEoSxK28=;
        b=hKP4Xo/RDag1qtCxG2oVm16XUhsq2E2g+6gw6/Hi+N2RtKE39kuxMlXIv9Evrzp/tF
         hcPRVnXc8MW4EK9vzFSFuqOL6zmC1mlvquZFyprT+NWJCw7RHjnbeFQaT/g21mi/JZ0M
         vpOBSnCNkI8T8CpC57EOOzawQc+cZYJNnIVxJZujoUdVeEFMImRwnnscgYcEsVZSN3/l
         1tfmQsmAnrNjCUzStDxRi/dv+rxn68Tb/mEPK6aUpmfbcEazEodN86tpLHDvBKJ55PXv
         qYeD1R0NRdIqRHtOFwWoOEuIPXSPzKML3GYQ1MDnXQmlsrvxhchh0TdpJ7YheCTzXq8I
         p4CQ==
X-Gm-Message-State: AOAM532EcO/jrNTmxuwxZSAQfWHQ/2HnfkWVhvj7LraC2CBgzu7DVEL6
        gKLKH0Va0l1vGHMNV1Xt1UQoxLmN3Uc=
X-Google-Smtp-Source: ABdhPJyE3PI+Fi7IC9HkU//5shrXJxzaX2PctnEZrfdsFCsLRS9ySPu20CHEHgpiFEUf6cFiR/O54w==
X-Received: by 2002:aed:29a1:: with SMTP id o30mr19112481qtd.249.1596485728209;
        Mon, 03 Aug 2020 13:15:28 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id w20sm4846226qki.108.2020.08.03.13.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 13:15:27 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Mon, 3 Aug 2020 16:15:25 -0400
To:     Andi Kleen <ak@linux.intel.com>
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Jian Cai <jiancai@google.com>,
        =?utf-8?B?RsSBbmctcnXDrCBTw7JuZw==?= <maskray@google.com>,
        Luis Lozano <llozano@google.com>,
        Manoj Gupta <manojgupta@google.com>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        James Morse <james.morse@arm.com>,
        Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, x86@kernel.org,
        clang-built-linux@googlegroups.com, linux-arch@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Michal Marek <michal.lkml@markovi.net>
Subject: Re: [PATCH v5 13/36] vmlinux.lds.h: add PGO and AutoFDO input
 sections
Message-ID: <20200803201525.GA1351390@rani.riverdale.lan>
References: <20200731230820.1742553-1-keescook@chromium.org>
 <20200731230820.1742553-14-keescook@chromium.org>
 <20200801035128.GB2800311@rani.riverdale.lan>
 <20200803190506.GE1299820@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200803190506.GE1299820@tassilo.jf.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 03, 2020 at 12:05:06PM -0700, Andi Kleen wrote:
> > However, the history of their being together comes from
> > 
> >   9bebe9e5b0f3 ("kbuild: Fix .text.unlikely placement")
> > 
> > which seems to indicate there was some problem with having them separated out,
> > although I don't quite understand what the issue was from the commit message.
> 
> Separating it out is less efficient. Gives worse packing for the hot part
> if they are not aligned to 64byte boundaries, which they are usually not. 
> 
> It also improves packing of the cold part, but that probably doesn't matter.
> 
> -Andi

Why is that? Both .text and .text.hot have alignment of 2^4 (default
function alignment on x86) by default, so it doesn't seem like it should
matter for packing density.  Avoiding interspersing cold text among
regular/hot text seems like it should be a net win.

That old commit doesn't reference efficiency -- it says there was some
problem with matching when they were separated out, but there were no
wildcard section names back then.

commit 9bebe9e5b0f3109a14000df25308c2971f872605
Author: Andi Kleen <ak@linux.intel.com>
Date:   Sun Jul 19 18:01:19 2015 -0700

    kbuild: Fix .text.unlikely placement
    
    When building a kernel with .text.unlikely text the unlikely text for
    each translation unit was put next to the main .text code in the
    final vmlinux.
    
    The problem is that the linker doesn't allow more specific submatches
    of a section name in a different linker script statement after the
    main match.
    
    So we need to move them all into one line. With that change
    .text.unlikely is at the end of everything again.
    
    I also moved .text.hot into the same statement though, even though
    that's not strictly needed.
    
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Michal Marek <mmarek@suse.com>

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 8bd374d3cf21..1781e54ea6d3 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -412,12 +412,10 @@
  * during second ld run in second ld pass when generating System.map */
 #define TEXT_TEXT							\
 		ALIGN_FUNCTION();					\
-		*(.text.hot)						\
-		*(.text .text.fixup)					\
+		*(.text.hot .text .text.fixup .text.unlikely)		\
 		*(.ref.text)						\
 	MEM_KEEP(init.text)						\
 	MEM_KEEP(exit.text)						\
-		*(.text.unlikely)
 
 
 /* sched.text is aling to function alignment to secure we have same
