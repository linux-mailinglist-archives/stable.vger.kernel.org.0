Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0992F866C
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 21:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732510AbhAOUOf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 15:14:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729312AbhAOUOc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 15:14:32 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E1BC0613D3
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 12:13:51 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id l23so5849683pjg.1
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 12:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Gb2K8a9/AUSvvfvrbCs7WHO9VXw0fMuK9BslVxQRn/0=;
        b=ox+MuupIi1HIGJ4Lu7BzfYbNnXQ9689uRP0fxZbbYeRWoQWVIv5A6iDzOAv+Lf3ohz
         qKC1BGqtw2uyD1BjT+l8ymojNpEyo+b+Lw9oYg2TdqBxy1tr+1LUE7aOs/iNVbEOK9W8
         kkDyCFVqt2JvOJys6pye6c1ZYVf5exnzyJpkR6bVglnp0ZwcBCOIPnQBexksjXQm9bdX
         JngSmQhIadBHDzWWhbCUMd85gfS/UpogWlts0JfTE0EsWNvOql5q/CE/XbXTaNY2nb0H
         mggiEJTc7lchKIPK50VZzARpi0MRYNno9SVy+mv0DPMtYZROkiB+ruHYPfIs1rWxcIN0
         bwAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Gb2K8a9/AUSvvfvrbCs7WHO9VXw0fMuK9BslVxQRn/0=;
        b=V1Xz+JQf5J0HZ6hoTvGFpopMX00c80dZDALujqZMJYGES9LGDj7xp9b/faauxn1I2/
         N4bGLsTZIWtyIHzjfQpIE4GgIgN3B7pUXTtAQfJS0paeLvRX7/AVZOOLa2uINueBzxg9
         9ropEFhf1wQN7oxjSdQCPO9uV3yED3O4O855mblsCSQyauB22+xblxYy1zB7iRGRrqtz
         KymNB+p3Zv+PlrWrfyntjk+Nhx51ii+UQ4OKTEoEZ0fnnZ2vJDWADNUdCGwzKNnvIYh4
         p5C/fPeUpZ+140E2FwGDyllDr3T6xXvIgv5cR5Zhb0guQeq7ya1KAj5j4iQDWMnNKY1m
         +aJg==
X-Gm-Message-State: AOAM530y6Jz7m5p3Klp5HR/EuW12RLkxguirD4KBz9TQxMA87lJ6qzMX
        +H6bRwIsRcNPvnFqHC0irtaq7Q==
X-Google-Smtp-Source: ABdhPJwEy4qrdpiIwQ69TYq3HbseCL07DGtLTG+q46XfBrmFaDHSGzoORVM5MwqyY0NAdmKJqV1W1A==
X-Received: by 2002:a17:90a:ac2:: with SMTP id r2mr10180034pje.145.1610741630370;
        Fri, 15 Jan 2021 12:13:50 -0800 (PST)
Received: from google.com ([2620:15c:2ce:0:a6ae:11ff:fe11:4abb])
        by smtp.gmail.com with ESMTPSA id z13sm9163495pjz.42.2021.01.15.12.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 12:13:45 -0800 (PST)
Date:   Fri, 15 Jan 2021 12:13:42 -0800
From:   Fangrui Song <maskray@google.com>
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-mips@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] mips: vdso: fix DWARF2 warning
Message-ID: <20210115201342.76nssqtbs4kttgts@google.com>
References: <20210115191330.2319352-1-anders.roxell@linaro.org>
 <20210115192803.GA3828660@ubuntu-m3-large-x86>
 <CADYN=9Kt597LsfW=Aq6v+kWr+ja+55_+Z3s5mFaJULa+9J4EfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CADYN=9Kt597LsfW=Aq6v+kWr+ja+55_+Z3s5mFaJULa+9J4EfA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2021-01-15, Anders Roxell wrote:
>On Fri, 15 Jan 2021 at 20:28, Nathan Chancellor
><natechancellor@gmail.com> wrote:
>>
>> On Fri, Jan 15, 2021 at 08:13:30PM +0100, Anders Roxell wrote:
>> > When building mips tinyconifg the following warning show up
>> >
>> > make --silent --keep-going --jobs=8 O=/home/anders/src/kernel/next/out/builddir ARCH=mips CROSS_COMPILE=mips-linux-gnu- HOSTCC=clang CC=clang
>> > /srv/src/kernel/next/arch/mips/vdso/elf.S:14:1: warning: DWARF2 only supports one section per compilation unit
>> > .pushsection .note.Linux, "a",@note ; .balign 4 ; .long 2f - 1f ; .long 4484f - 3f ; .long 0 ; 1:.asciz "Linux" ; 2:.balign 4 ; 3:
>> > ^
>> > /srv/src/kernel/next/arch/mips/vdso/elf.S:34:2: warning: DWARF2 only supports one section per compilation unit
>> >  .section .mips_abiflags, "a"
>> >  ^
>> >
>> > Rework so the mips vdso Makefile adds flag '-no-integrated-as' unless
>> > LLVM_IAS is defined.
>> >
>> > Link: https://github.com/ClangBuiltLinux/linux/issues/1256
>> > Cc: stable@vger.kernel.org # v4.19+
>> > Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
>> > Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
>>
>> I believe this is the better solution:
>>
>> https://lore.kernel.org/r/20210115192622.3828545-1-natechancellor@gmail.com/
>
>Yes, I agree.
>
>Cheers,
>Anders

http://lore.kernel.org/r/20201202010850.jibrjpyu6xgkff5p@google.com
Personally I'd drop DWARF v2 as an option.
