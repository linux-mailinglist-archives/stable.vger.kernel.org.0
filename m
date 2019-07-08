Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEDDD627D2
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 19:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390822AbfGHR6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 13:58:43 -0400
Received: from mail.efficios.com ([167.114.142.138]:44812 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729052AbfGHR6n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 13:58:43 -0400
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id E2F3E1E4982;
        Mon,  8 Jul 2019 13:58:40 -0400 (EDT)
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id AxF7lMw-k6VW; Mon,  8 Jul 2019 13:58:40 -0400 (EDT)
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 03F681E497C;
        Mon,  8 Jul 2019 13:58:40 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 03F681E497C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1562608720;
        bh=eVbj5EgC4aodGosLMrOlAGQcE4mS2LxA0FIfp4QhI9o=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=mgfYD5guP/YAzMM6CSsMKGM5v01AIHcSxIK9HBu0wWlJGINzyhHuchUG/MCLlw0z6
         fQ+wHE7hAV79SXIevXGFuqjP100XpQPkl9bPECj8+HDPieKOwBieStWsQu17sFxTTU
         OEO4EUq/pKAqd4pkx6i3s6pVB5gbq912F4aCSId1LGC1cPUEO7OvKeJqc9dAHdfpfH
         hnmMZtk4ytawyFhM3Ch1+xtww0q1PK1K8Tsi0BYKuSA5efayxDQBYLM9hePvkEQdBT
         dWjzWlolafoSm63gcHMTbUrlLPS8gCoGHMiFFifOIFtGIhAa2u5yezCyemLljlg/Ha
         m8ERbZoTorfrQ==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id w5nRf0b1Ye3n; Mon,  8 Jul 2019 13:58:39 -0400 (EDT)
Received: from mail02.efficios.com (mail02.efficios.com [167.114.142.138])
        by mail.efficios.com (Postfix) with ESMTP id D2E651E4968;
        Mon,  8 Jul 2019 13:58:39 -0400 (EDT)
Date:   Mon, 8 Jul 2019 13:58:39 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     shuah <shuah@kernel.org>, Will Deacon <will.deacon@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joel Fernandes <joelaf@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Watson <davejwatson@fb.com>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kselftest <linux-kselftest@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Chris Lameter <cl@linux.com>,
        Russell King <linux@arm.linux.org.uk>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Turner <pjt@google.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        rostedt <rostedt@goodmis.org>, Ben Maurer <bmaurer@fb.com>,
        linux-api <linux-api@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        carlos <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>
Message-ID: <1154710388.12906.1562608719838.JavaMail.zimbra@efficios.com>
In-Reply-To: <20190630135613.19897-1-mathieu.desnoyers@efficios.com>
References: <20190630135613.19897-1-mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH for 5.2] rseq/selftests: Fix Thumb mode build failure on
 arm32
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.142.138]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF67 (Linux)/8.8.12_GA_3809)
Thread-Topic: rseq/selftests: Fix Thumb mode build failure on arm32
Thread-Index: gfeEiAR/gdsgXdx91k7boM6lmAv4lw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- On Jun 30, 2019, at 9:56 AM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:

> Using ".arm .inst" for the arm signature introduces build issues for
> programs compiled in Thumb mode because the assembler stays in the
> arm mode for the rest of the inline assembly. Revert to using a ".word"
> to express the signature as data instead.
> 
> The choice of signature is a valid trap instruction on arm32 little
> endian, where both code and data are little endian.
> 
> ARMv6+ big endian (BE8) generates mixed endianness code vs data:
> little-endian code and big-endian data. The data value of the signature
> needs to have its byte order reversed to generate the trap instruction.
> 
> Prior to ARMv6, -mbig-endian generates big-endian code and data
> (which match), so the endianness of the data representation of the
> signature should not be reversed. However, the choice between BE32
> and BE8 is done by the linker, so we cannot know whether code and
> data endianness will be mixed before the linker is invoked. So rather
> than try to play tricks with the linker, the rseq signature is simply
> data (not a trap instruction) prior to ARMv6 on big endian. This is
> why the signature is expressed as data (.word) rather than as
> instruction (.inst) in assembler.
> 
> Because a ".word" is used to emit the signature, it will be interpreted
> as a literal pool by a disassembler, not as an actual instruction.
> Considering that the signature is not meant to be executed except in
> scenarios where the program execution is completely bogus, this should
> not be an issue.

Now that 5.2 is out before this patch has been merged, can we please
integrate this patch through the kernel selftests or ARM tree so it
can be merged into the stable 5.2 branch ?

Thanks

Mathieu


> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Acked-by: Will Deacon <will.deacon@arm.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Joel Fernandes <joelaf@google.com>
> CC: Catalin Marinas <catalin.marinas@arm.com>
> CC: Dave Watson <davejwatson@fb.com>
> CC: Will Deacon <will.deacon@arm.com>
> CC: Shuah Khan <shuah@kernel.org>
> CC: Andi Kleen <andi@firstfloor.org>
> CC: linux-kselftest@vger.kernel.org
> CC: "H . Peter Anvin" <hpa@zytor.com>
> CC: Chris Lameter <cl@linux.com>
> CC: Russell King <linux@arm.linux.org.uk>
> CC: Michael Kerrisk <mtk.manpages@gmail.com>
> CC: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>
> CC: Paul Turner <pjt@google.com>
> CC: Boqun Feng <boqun.feng@gmail.com>
> CC: Josh Triplett <josh@joshtriplett.org>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Ben Maurer <bmaurer@fb.com>
> CC: linux-api@vger.kernel.org
> CC: Andy Lutomirski <luto@amacapital.net>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
> CC: Carlos O'Donell <carlos@redhat.com>
> CC: Florian Weimer <fweimer@redhat.com>
> ---
> tools/testing/selftests/rseq/rseq-arm.h | 61 ++++++++++++++++++---------------
> 1 file changed, 33 insertions(+), 28 deletions(-)
> 
> diff --git a/tools/testing/selftests/rseq/rseq-arm.h
> b/tools/testing/selftests/rseq/rseq-arm.h
> index 84f28f147fb6..5943c816c07c 100644
> --- a/tools/testing/selftests/rseq/rseq-arm.h
> +++ b/tools/testing/selftests/rseq/rseq-arm.h
> @@ -6,6 +6,8 @@
>  */
> 
> /*
> + * - ARM little endian
> + *
>  * RSEQ_SIG uses the udf A32 instruction with an uncommon immediate operand
>  * value 0x5de3. This traps if user-space reaches this instruction by mistake,
>  * and the uncommon operand ensures the kernel does not move the instruction
> @@ -22,36 +24,40 @@
>  * def3        udf    #243      ; 0xf3
>  * e7f5        b.n    <7f5>
>  *
> - * pre-ARMv6 big endian code:
> - * e7f5        b.n    <7f5>
> - * def3        udf    #243      ; 0xf3
> + * - ARMv6+ big endian (BE8):
>  *
>  * ARMv6+ -mbig-endian generates mixed endianness code vs data: little-endian
> - * code and big-endian data. Ensure the RSEQ_SIG data signature matches code
> - * endianness. Prior to ARMv6, -mbig-endian generates big-endian code and data
> - * (which match), so there is no need to reverse the endianness of the data
> - * representation of the signature. However, the choice between BE32 and BE8
> - * is done by the linker, so we cannot know whether code and data endianness
> - * will be mixed before the linker is invoked.
> + * code and big-endian data. The data value of the signature needs to have its
> + * byte order reversed to generate the trap instruction:
> + *
> + * Data: 0xf3def5e7
> + *
> + * Translates to this A32 instruction pattern:
> + *
> + * e7f5def3    udf    #24035    ; 0x5de3
> + *
> + * Translates to this T16 instruction pattern:
> + *
> + * def3        udf    #243      ; 0xf3
> + * e7f5        b.n    <7f5>
> + *
> + * - Prior to ARMv6 big endian (BE32):
> + *
> + * Prior to ARMv6, -mbig-endian generates big-endian code and data
> + * (which match), so the endianness of the data representation of the
> + * signature should not be reversed. However, the choice between BE32
> + * and BE8 is done by the linker, so we cannot know whether code and
> + * data endianness will be mixed before the linker is invoked. So rather
> + * than try to play tricks with the linker, the rseq signature is simply
> + * data (not a trap instruction) prior to ARMv6 on big endian. This is
> + * why the signature is expressed as data (.word) rather than as
> + * instruction (.inst) in assembler.
>  */
> 
> -#define RSEQ_SIG_CODE	0xe7f5def3
> -
> -#ifndef __ASSEMBLER__
> -
> -#define RSEQ_SIG_DATA							\
> -	({								\
> -		int sig;						\
> -		asm volatile ("b 2f\n\t"				\
> -			      "1: .inst " __rseq_str(RSEQ_SIG_CODE) "\n\t" \
> -			      "2:\n\t"					\
> -			      "ldr %[sig], 1b\n\t"			\
> -			      : [sig] "=r" (sig));			\
> -		sig;							\
> -	})
> -
> -#define RSEQ_SIG	RSEQ_SIG_DATA
> -
> +#ifdef __ARMEB__
> +#define RSEQ_SIG    0xf3def5e7      /* udf    #24035    ; 0x5de3 (ARMv6+) */
> +#else
> +#define RSEQ_SIG    0xe7f5def3      /* udf    #24035    ; 0x5de3 */
> #endif
> 
> #define rseq_smp_mb()	__asm__ __volatile__ ("dmb" ::: "memory", "cc")
> @@ -125,8 +131,7 @@ do {									\
> 		__rseq_str(table_label) ":\n\t"				\
> 		".word " __rseq_str(version) ", " __rseq_str(flags) "\n\t" \
> 		".word " __rseq_str(start_ip) ", 0x0, " __rseq_str(post_commit_offset) ", 0x0, "
> 		__rseq_str(abort_ip) ", 0x0\n\t" \
> -		".arm\n\t"						\
> -		".inst " __rseq_str(RSEQ_SIG_CODE) "\n\t"		\
> +		".word " __rseq_str(RSEQ_SIG) "\n\t"			\
> 		__rseq_str(label) ":\n\t"				\
> 		teardown						\
> 		"b %l[" __rseq_str(abort_label) "]\n\t"
> --
> 2.11.0

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
