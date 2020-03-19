Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD92618BD62
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 18:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbgCSRCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 13:02:36 -0400
Received: from foss.arm.com ([217.140.110.172]:39122 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727877AbgCSRCf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 13:02:35 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1F32130E;
        Thu, 19 Mar 2020 10:02:35 -0700 (PDT)
Received: from [10.37.12.142] (unknown [10.37.12.142])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 71AD33F305;
        Thu, 19 Mar 2020 10:02:33 -0700 (PDT)
Subject: Re: [PATCH] arm64: compat: Fix syscall number of compat_clock_getres
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "# 3.4.x" <stable@vger.kernel.org>
References: <20200319141138.19343-1-vincenzo.frascino@arm.com>
 <CAKwvOdnnsE2FyqajP4_FrwpgekptfLJsr3J9EgB3Ac37NgZszQ@mail.gmail.com>
From:   Vincenzo Frascino <vincenzo.frascino@arm.com>
Message-ID: <9b8a7e8f-57e6-3a81-a8c6-10ca59267ea8@arm.com>
Date:   Thu, 19 Mar 2020 17:03:02 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAKwvOdnnsE2FyqajP4_FrwpgekptfLJsr3J9EgB3Ac37NgZszQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Nick,

On 3/19/20 3:39 PM, Nick Desaulniers wrote:
> On Thu, Mar 19, 2020 at 7:11 AM Vincenzo Frascino
> <vincenzo.frascino@arm.com> wrote:
[...]

> 
> This seems to match up with the glibc sources:
> https://sourceware.org/git/?p=glibc.git;a=blob;f=sysdeps/unix/sysv/linux/arm/arch-syscall.h;h=c6554a8a6a6e7fe3359f1272f619c3da7c90629b;hb=HEAD#l27
> Here's bionic's headers for good measure:
> https://android.googlesource.com/platform/bionic/+/refs/heads/master/libc/kernel/uapi/asm-arm/asm/unistd-common.h#240
> 
> I assume the _compat_ prefixes are the aarch32 syscall numbers?
> Otherwise here's the list for aarch64:
> https://sourceware.org/git/?p=glibc.git;a=blob;f=sysdeps/unix/sysv/linux/aarch64/arch-syscall.h;h=c8471947b9c209be6add1e528f892f1a6c54f966;hb=HEAD
> 
> Looks like 247 was __NR_io_cancel; that's a subtle bug I'm glad was noticed!
> 

Yes, very subtle, I agree!

Thank you for the information provided.

> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> 
>>  #define __NR_compat_clock_gettime64    403
>>  #define __NR_compat_clock_getres_time64        406
>>
>> --
>> 2.25.1
>>
>> --
>> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
>> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
>> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20200319141138.19343-1-vincenzo.frascino%40arm.com.
> 
> 
> 

-- 
Regards,
Vincenzo
