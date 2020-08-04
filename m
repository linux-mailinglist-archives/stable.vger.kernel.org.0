Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA9123B46D
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 07:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgHDFcd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 01:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbgHDFcc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 01:32:32 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A48AC06174A
        for <stable@vger.kernel.org>; Mon,  3 Aug 2020 22:32:32 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id s15so9935691pgc.8
        for <stable@vger.kernel.org>; Mon, 03 Aug 2020 22:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SYIRLxV49LREgpupMxZqNaA5o9fHAoeWk6pTwu6HNpo=;
        b=Ph8ZuBGUk+/4Umvi3tBIzf/QoNeRTzEty93PfC99H5oKffGm5XPBIYydB/2qEjwx+J
         SZlumfSOoM+FB4ii86QCn1PTMJ9NjJY1FZUj2o/u1krMTrrJozPlGsMuZcNXIvRjpPcJ
         +81DI4YxL4IU6lFGb0Pbpc9mW8IlwPMik2dCyLkBcwktamtjKAinHZrEX//ZHUbKngp2
         MSXGzP8/tmQLmOFB7W5dB+57aIme9PO1DVII/zySdREQiWkYF7MCpIOIHFgUVx2svIar
         11zh2B8Q9ICjj9GH1pCF3bU70VMzSX8LQhVIliff5lguiHIeRZXh+NE4la6L3y3/ChSK
         Id9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SYIRLxV49LREgpupMxZqNaA5o9fHAoeWk6pTwu6HNpo=;
        b=m6rDcGBBGGGUXjVJ6iL3lJ9f295/k4ZREXf+YU+u+YVSfvcKMqIz1s4Gd8y6oyahWJ
         DLgd3jYa8ntMGhgHcVcP99k662ydfOIsTXcVdhyI4xFin8Kmz1U35ST9nKd8dWu8es5a
         BSKHk4mGwI4rrMC2QstIPX4K8WJGG/lgPKvcw61PbosgixBdCnooIRxQSbZNvskRKNJn
         soWUd1KGoU31GWUAJopf4t8t8zFsoNnnz/wfLlj+sWIvL2BTaP/dGavnoI8Ne+bAGtVx
         DfdNvWTkGXwE9ATFLPtfQX7iCQU3VdniMdOAZBpwkKHGXBJ7REIs/TYEaXIO7J0TRsSS
         acpg==
X-Gm-Message-State: AOAM532MBEDU9QKBkgsdkBdM7ILTyq/aIOUGKaQ18M3SzkyrMJqNd6hs
        ZyhrvBNUjgpxocUUYt7FI9qnhfxjIjIWnA==
X-Google-Smtp-Source: ABdhPJxWvObT/t8li1vTJ4ytGrVaTvI1LGmfrOyEDh3/xDuiqI+q1VkKOlVYIQvexku7wtDA6xXYXw==
X-Received: by 2002:a63:cf0e:: with SMTP id j14mr10344966pgg.119.1596519151489;
        Mon, 03 Aug 2020 22:32:31 -0700 (PDT)
Received: from google.com ([2620:15c:2ce:0:a6ae:11ff:fe11:4abb])
        by smtp.gmail.com with ESMTPSA id go12sm1117217pjb.2.2020.08.03.22.32.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 22:32:30 -0700 (PDT)
Date:   Mon, 3 Aug 2020 22:32:27 -0700
From:   =?utf-8?B?RsSBbmctcnXDrCBTw7JuZw==?= <maskray@google.com>
To:     Andi Kleen <ak@linux.intel.com>
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        Kees Cook <keescook@chromium.org>,
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
Message-ID: <20200804053227.k7zyozzrw5mhv6qi@google.com>
References: <20200731230820.1742553-1-keescook@chromium.org>
 <20200731230820.1742553-14-keescook@chromium.org>
 <20200801035128.GB2800311@rani.riverdale.lan>
 <20200803190506.GE1299820@tassilo.jf.intel.com>
 <20200803201525.GA1351390@rani.riverdale.lan>
 <20200804044532.GC1321588@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200804044532.GC1321588@tassilo.jf.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-08-03, Andi Kleen wrote:
>> Why is that? Both .text and .text.hot have alignment of 2^4 (default
>> function alignment on x86) by default, so it doesn't seem like it should
>> matter for packing density.  Avoiding interspersing cold text among
>
>You may lose part of a cache line on each unit boundary. Linux has
>a lot of units, some of them small. All these bytes add up.
>
>It's bad for TLB locality too. Sadly with all the fine grained protection
>changes the 2MB coverage is eroding anyways, but this makes it even worse.

> Gives worse packing for the hot part
> if they are not aligned to 64byte boundaries, which they are usually
> not.

I do not see how the 64-byte argument is related to this patch.
If a function requires 64-byte alignment to be efficient, the compiler
should communicate this fact by setting the alignment of its containing
section to 64 bytes or above.

If a text section has a 16-byte alignment, the linker can reorder it to
an address which is a multiple of 16 but not a multiple of 64.

I agree with your other statement that having a single input section
description might be helpful. With more than one input section
descrition, the linker has to respect the ordering requirement. With
just one input section description, the linker has more freedom ordering
sections if profitable. For example, LLD performs two ordering
heuristics as my previous reply mentions.

It'd be good if someone can measure the benefit. Personally I don't
think this kind of ordering has significant benefit. (For
arm/aarch64/powerpc there might be some size benefit due to fewer range
extension thunks)

>> regular/hot text seems like it should be a net win.
>
>>
>> That old commit doesn't reference efficiency -- it says there was some
>> problem with matching when they were separated out, but there were no
>> wildcard section names back then.
>
>It was about efficiency.
>
>-Andi
>
>-- 
>You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
>To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
>To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20200804044532.GC1321588%40tassilo.jf.intel.com.
