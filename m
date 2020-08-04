Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5E323B232
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 03:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728867AbgHDBTl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 21:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgHDBTk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Aug 2020 21:19:40 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806FBC06174A
        for <stable@vger.kernel.org>; Mon,  3 Aug 2020 18:19:40 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id p8so5090756pgn.13
        for <stable@vger.kernel.org>; Mon, 03 Aug 2020 18:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yLe9ughSSWWsyDhsI7ztPaWolRKsxiUjg5w5lMi5jv0=;
        b=lCrMugQUVSPuyKgDXCz53qjx8GpRoloxBAlY5KPxbmQ12O72BOerb0UFBL4jyWCZRr
         YG2/z1jkquu3Dh32tC8iEO4WNJCj7lRufInMQ8f4t5RYS0p/W80vJLslkmt+Zg82l2kU
         sh5JzBBuyuzHRtnRFi98hxZrc0Vpeyofp94flLPq9R4TczJuwAaUa75N+I2WiyKEADGh
         J1n2uqRVPrLq0A7jsM/UehNHwvhX/sPpSH4R1dAjlb6f9YC0Pb/sgSa9Vv4cvGAGrWJW
         LZvSpMWaEtD2YIJWWq/dAVqLCM1hK/KDENo7+dSia+AQHXEomiTC+DTfD9Lzd3Z84DUv
         ge9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yLe9ughSSWWsyDhsI7ztPaWolRKsxiUjg5w5lMi5jv0=;
        b=IuUDNFrHHDHeikIOLFdtghFk/YnbxwF+nRC5N0K4Ijj4PUswggL4QLvg3U7uY3R1Wb
         RzV16BPFTwKYMcNm1l+35Tw6LnvZL2YDIFFU3SnNMPb7Tdp4zjGmFMN9jtoE5l+SB+3W
         RAzqC/boEhiFcYLYi7j3I6jwEy/zy/2lLgx6Ukg3KGboyzLMlcupgwxTc3aZXUNefntB
         zWIDyHqHWwSELic/MFbszCrjr+F98HnW4wl5uyU03Z+YnVzT8RpYo1CjKXC4Nla++cwX
         gAKU4dLOW5MJFWccR4bkRXkd4ahyAchS/19lyTqb3k+IszuSCCvb02jp9GwCuXgzO1rQ
         GTxw==
X-Gm-Message-State: AOAM5315sQSSBJmTXj8U+maCHqLAIYa72DuH7vcEe5jXZfXPMsYX1EWK
        n4fGkmzpzieG/xpT3crgRRTQZw==
X-Google-Smtp-Source: ABdhPJw1aC/ZBhM8ma32FF1cdfeNt3UNq3X8Np+PVxOtcg04d9iH5iUgJhrh8gVOdwwfq82yIjRsgw==
X-Received: by 2002:a63:454d:: with SMTP id u13mr16807380pgk.309.1596503979605;
        Mon, 03 Aug 2020 18:19:39 -0700 (PDT)
Received: from google.com ([2620:15c:2ce:0:a6ae:11ff:fe11:4abb])
        by smtp.gmail.com with ESMTPSA id q82sm7823264pfc.139.2020.08.03.18.19.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 18:19:38 -0700 (PDT)
Date:   Mon, 3 Aug 2020 18:19:35 -0700
From:   =?utf-8?B?RsSBbmctcnXDrCBTw7JuZw==?= <maskray@google.com>
To:     Arvind Sankar <nivedita@alum.mit.edu>,
        Kees Cook <keescook@chromium.org>
Cc:     Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Jian Cai <jiancai@google.com>,
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
Message-ID: <20200804011935.b4asdxdxwvwic7js@google.com>
References: <20200731230820.1742553-1-keescook@chromium.org>
 <20200731230820.1742553-14-keescook@chromium.org>
 <20200801035128.GB2800311@rani.riverdale.lan>
 <20200803190506.GE1299820@tassilo.jf.intel.com>
 <20200803201525.GA1351390@rani.riverdale.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200803201525.GA1351390@rani.riverdale.lan>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-08-03, Arvind Sankar wrote:
>On Mon, Aug 03, 2020 at 12:05:06PM -0700, Andi Kleen wrote:
>> > However, the history of their being together comes from
>> >
>> >   9bebe9e5b0f3 ("kbuild: Fix .text.unlikely placement")
>> >
>> > which seems to indicate there was some problem with having them separated out,
>> > although I don't quite understand what the issue was from the commit message.
>>
>> Separating it out is less efficient. Gives worse packing for the hot part
>> if they are not aligned to 64byte boundaries, which they are usually not.
>>
>> It also improves packing of the cold part, but that probably doesn't matter.
>>
>> -Andi
>
>Why is that? Both .text and .text.hot have alignment of 2^4 (default
>function alignment on x86) by default, so it doesn't seem like it should
>matter for packing density.  Avoiding interspersing cold text among
>regular/hot text seems like it should be a net win.
>
>That old commit doesn't reference efficiency -- it says there was some
>problem with matching when they were separated out, but there were no
>wildcard section names back then.

I just want to share some context. GNU ld's internal linker script does
impose a particular input section order by specifying separate input section descriptions:

   .text           :
   {
     *(.text.unlikely .text.*_unlikely .text.unlikely.*)
     *(.text.exit .text.exit.*)
     *(.text.startup .text.startup.*)
     *(.text.hot .text.hot.*)
     *(SORT(.text.sorted.*))   # binutils 5fa5f8f5fe494ba4fe98c11899a5464cd164ec75, invented for GCC's call graph profiling. LLVM doesn't use it
     *(.text .stub .text.* .gnu.linkonce.t.*)
     ...

This order is a bit arbitrary. gold and LLD have -z keep-text-section-prefix. With the option,
there can be several output sections, with the '.unlikely'/'.exit'/'.startup'/etc suffix.
This has the advantage that the hot/unlikely/exit/etc attribution of a particular function is more obvious:

   [ 2] .text             PROGBITS        000000000040007c 00007c 000003 00  AX  0   0  4
   [ 3] .text.startup     PROGBITS        000000000040007f 00007f 000001 00  AX  0   0  1
   [ 4] .text.exit        PROGBITS        0000000000400080 000080 000002 00  AX  0   0  1
   [ 5] .text.unlikely    PROGBITS        0000000000400082 000082 000001 00  AX  0   0  1 
   ...

In our case we only need one output section.......

If we place all text sections in one input section description:

     *(.text.unlikely .text.*_unlikely .text.exit .text.exit.* .text.startup .text.startup.* .text.hot .text.hot.* ... )

In many cases the input sections are laid out in the input order. In LLD there are two ordering cases:

* If clang PGO (-fprofile-use=) is enabled, .llvm.call-graph-profile will be created automatically.
   LLD can perform reordering **within an input section description**. The ordering is quite complex,
   you can read https://github.com/llvm/llvm-project/blob/master/lld/ELF/CallGraphSort.cpp#L9 if you are curious:)

   I don't know the performance improvement of this heuristic. (I don't think the original paper
   cgo2017-hfsort-final1.pdf took ThinLTO into account, so the result might not
   reflect realistic work loads where both ThinLTO and PGO are used) This, if matters, likely only matters
   for very large executable, not the case for the kernel.
* On some RISC architectures (ARM/AArch64/PowerPC),
   the ordered sections (due to either .llvm.call-graph-profile or
   --symbol-reordering-file=; the two can't be used together) are placed in a
   suitable place in the input section description
   ( http://reviews.llvm.org/D44969 )


In summary, using one (large) input section description may have some
performance improvement with LLD but I don't think it will be significant.
There may be some size improvement for ARM/AArch64/PowerPC if someone wants to test.

>commit 9bebe9e5b0f3109a14000df25308c2971f872605
>Author: Andi Kleen <ak@linux.intel.com>
>Date:   Sun Jul 19 18:01:19 2015 -0700
>
>    kbuild: Fix .text.unlikely placement
>
>    When building a kernel with .text.unlikely text the unlikely text for
>    each translation unit was put next to the main .text code in the
>    final vmlinux.
>
>    The problem is that the linker doesn't allow more specific submatches
>    of a section name in a different linker script statement after the
>    main match.
>
>    So we need to move them all into one line. With that change
>    .text.unlikely is at the end of everything again.
>
>    I also moved .text.hot into the same statement though, even though
>    that's not strictly needed.
>
>    Signed-off-by: Andi Kleen <ak@linux.intel.com>
>    Signed-off-by: Michal Marek <mmarek@suse.com>
>
>diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
>index 8bd374d3cf21..1781e54ea6d3 100644
>--- a/include/asm-generic/vmlinux.lds.h
>+++ b/include/asm-generic/vmlinux.lds.h
>@@ -412,12 +412,10 @@
>  * during second ld run in second ld pass when generating System.map */
> #define TEXT_TEXT							\
> 		ALIGN_FUNCTION();					\
>-		*(.text.hot)						\
>-		*(.text .text.fixup)					\
>+		*(.text.hot .text .text.fixup .text.unlikely)		\
> 		*(.ref.text)						\
> 	MEM_KEEP(init.text)						\
> 	MEM_KEEP(exit.text)						\
>-		*(.text.unlikely)
>
>
> /* sched.text is aling to function alignment to secure we have same
