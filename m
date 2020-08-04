Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2863C23BDB7
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 18:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbgHDQHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 12:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728745AbgHDQGx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 12:06:53 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35577C06174A;
        Tue,  4 Aug 2020 09:06:53 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id cs12so1079776qvb.2;
        Tue, 04 Aug 2020 09:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m06IKFD+Y+zyRLVsGx/ScdWAMYbWtM8lfzX3TLDLqQM=;
        b=k59NGMArZW/IVO5lr7VYQgHpHOKABoRYVH38jJDnL76HtOxMU2WW97srBYNJZXvEnM
         CCSnkcKxJTchNS0UFV0HmDnGK0YonaUICzlqNZD4jahfj8pxq2H9dL4YDEO+4SQhEFNe
         j873vmvHK52C+04qxmB9RF4SkRifztnBM87cifTAPPYhWQ3QZpsKZIKearzQ6cVADQVn
         36xs8pwoKmlu+9xubKS0claygFJRomudE6cTBrc1gWJJl8aPalo+ofIM0ZEtwBvLEjfv
         5oYtbZbYpahkW6zv2S7hsB1rHZ/Cvq3VR5bCYi37c5iSprz7jXwa2aTiXclrBFdF/bHO
         2U3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=m06IKFD+Y+zyRLVsGx/ScdWAMYbWtM8lfzX3TLDLqQM=;
        b=DJvutGGuB26tABMUwFz7jhLLtNx0mPMKfFJwR2O19CChEJvpfB60Vgw70ujsWLROFF
         hTn7nKCK4YiVBbLeLNx2CnxbcyHzxMpPvXXMpBOZG/mDAClL5XHKzt9pdwoiHe3afjbJ
         zuYp01+1wmp5bY2bYa+F2h/3+VgonslPk3nPnsp705vZhJv37DlQpMNchXI3DtEIpxS5
         LaubGF6VV+nTB+N0A784dNtJCOrREKFvTadsrcEMB62pZo4wb587cuRt/D8M92cLMi2+
         CDJ3LDSpP7LwHTsKw4dS0JNEfYe70zXy1RT0N2ceDURRMy8pXMGnnaWIOfWFbau5K0YG
         x64A==
X-Gm-Message-State: AOAM531TZtJ/kn5A4/PoX4zkiMl11MISbK9TEMxckMOKFkeZ9SHuP66m
        Ng2wpgPD0k/KN0OMUI9MVAk=
X-Google-Smtp-Source: ABdhPJw2bGYPIUfHRQvq5E7+uSyeqHN5wJTlNWr7pWF5NPqZbUp6h4AcE6QeqyvyFrZTPl2dPt4rGw==
X-Received: by 2002:a0c:99c8:: with SMTP id y8mr17347027qve.57.1596557212233;
        Tue, 04 Aug 2020 09:06:52 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id l13sm23581582qth.77.2020.08.04.09.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 09:06:51 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Tue, 4 Aug 2020 12:06:49 -0400
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
Message-ID: <20200804160649.GA2409491@rani.riverdale.lan>
References: <20200731230820.1742553-1-keescook@chromium.org>
 <20200731230820.1742553-14-keescook@chromium.org>
 <20200801035128.GB2800311@rani.riverdale.lan>
 <20200803190506.GE1299820@tassilo.jf.intel.com>
 <20200803201525.GA1351390@rani.riverdale.lan>
 <20200804044532.GC1321588@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200804044532.GC1321588@tassilo.jf.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 03, 2020 at 09:45:32PM -0700, Andi Kleen wrote:
> > Why is that? Both .text and .text.hot have alignment of 2^4 (default
> > function alignment on x86) by default, so it doesn't seem like it should
> > matter for packing density.  Avoiding interspersing cold text among
> 
> You may lose part of a cache line on each unit boundary. Linux has 
> a lot of units, some of them small. All these bytes add up.

Separating out .text.unlikely, which isn't aligned, slightly _reduces_
this loss, but not by much -- just over 1K on a defconfig. More
importantly, it moves cold code out of line (~320k on a defconfig),
giving better code density for the hot code.

For .text and .text.hot, you lose the alignment padding on every
function boundary, not unit boundary, because of the 16-byte alignment.
Whether .text.hot and .text are arranged by translation unit or not
makes no difference.

With *(.text.hot) *(.text) you get HHTT, with *(.text.hot .text) you get
HTHT, but in both cases the individual chunks are already aligned to 16
bytes. If .text.hot _had_ different alignment requirements to .text, the
HHTT should actually give better packing in general, I think.

> 
> It's bad for TLB locality too. Sadly with all the fine grained protection
> changes the 2MB coverage is eroding anyways, but this makes it even worse.
> 

Yes, that could be true for .text.hot, depending on whether the hot
functions are called from all over the kernel (in which case putting
them together ought to be better) or mostly from regular text within the
unit in which they appeared (in which case it would be better together
with that code).
