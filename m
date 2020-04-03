Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBE4419CE91
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 04:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389900AbgDCCTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 22:19:19 -0400
Received: from pi3.com.pl ([185.238.74.129]:54200 "EHLO pi3.com.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388709AbgDCCTS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 22:19:18 -0400
X-Greylist: delayed 489 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Apr 2020 22:19:16 EDT
Received: from localhost (localhost [127.0.0.1])
        by pi3.com.pl (Postfix) with ESMTP id 00E3E4C00F6;
        Fri,  3 Apr 2020 04:11:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=pi3.com.pl; s=default;
        t=1585879865; bh=XYIvUepz8Qe+tqiBlLV256QftMp5j/ITT/q+jgi5gbI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Yor9doaDGj9M0b7Yz1AKEvFPpx70hJfGv8qsHK6uhQ34m2qrnvS8qq2DWiBfIlfjn
         ISRxGNesqBcYbW2kzAmu7wabU1kvt/1dRcy+j9rDDS5irgeeF1NyW3mMXfQ/XH+Z7Y
         vZJ4G2xCDa4ts+zSQ+3U+8GmKzSZI2WMVE45esWyqt/0qgH6t1rVBG8H4dw+EfFC1L
         j3S2lStq+A/qpGa9cMueJfWL5Kjb9qcVvs9YbFlLWZitvPGSnSpQf2zmP2tVqqfqi3
         F5gpZEjDVHWNiMBvVKCqHCaQ6RfIoNZXY1xOu3BcbuqwvADKkVIhOJkR6ldGdNBM3M
         Jd1u1exLMGA2g==
X-Virus-Scanned: Debian amavisd-new at pi3.com.pl
Received: from pi3.com.pl ([127.0.0.1])
        by localhost (pi3.com.pl [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id xnKB_2yP9xfP; Fri,  3 Apr 2020 04:11:01 +0200 (CEST)
Received: by pi3.com.pl (Postfix, from userid 1000)
        id DF1884C13C0; Fri,  3 Apr 2020 04:11:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=pi3.com.pl; s=default;
        t=1585879861; bh=XYIvUepz8Qe+tqiBlLV256QftMp5j/ITT/q+jgi5gbI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R2s9iEEfBYlPc+FPyQCksrHChkQo6pvDE4notAjx6iF14mQ+H/tHxuWb+gP5t2ka7
         ti2x8jEKLx+5wvqCuDjhefXGO/KTPoCd08Qhd4r/4cD1xFdNH/xAFsFLf6q6EgBw1k
         zwKiLJg6fLqGCdeLti4GaHfslQiXmzfF/Ue96u26V9UrvfmXK+vkd2AVPxSpCt9piY
         ZNzdun/96nJk+887Ufee75C9p94vPgdSH/pvy1V7FtmqkKc6yoSYHO1dSgKo+LKi+V
         GLp1DooSg+md4vCdFqgDTMlfwXnepXTTS05dGU2c7MC8tBFYQnSfH63ndx5UgVkQsR
         BK5Gkhf2P/KAw==
Date:   Fri, 3 Apr 2020 04:11:01 +0200
From:   Adam Zabrocki <pi3@pi3.com.pl>
To:     Jann Horn <jannh@google.com>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] signal: Extend exec_id to 64bits
Message-ID: <20200403021101.GA2608@pi3.com.pl>
References: <20200324215049.GA3710@pi3.com.pl>
 <202003291528.730A329@keescook>
 <87zhbvlyq7.fsf_-_@x220.int.ebiederm.org>
 <CAG48ez1dCPw9Dep-+GWn=SnHv1nVv4Npv1FpFxmomk6tmazB-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez1dCPw9Dep-+GWn=SnHv1nVv4Npv1FpFxmomk6tmazB-g@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 02, 2020 at 06:46:49AM +0200, Jann Horn wrote:
> On Wed, Apr 1, 2020 at 10:50 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> > Replace the 32bit exec_id with a 64bit exec_id to make it impossible
> > to wrap the exec_id counter.  With care an attacker can cause exec_id
> > wrap and send arbitrary signals to a newly exec'd parent.  This
> > bypasses the signal sending checks if the parent changes their
> > credentials during exec.
> >
> > The severity of this problem can been seen that in my limited testing
> > of a 32bit exec_id it can take as little as 19s to exec 65536 times.
> > Which means that it can take as little as 14 days to wrap a 32bit
> > exec_id.  Adam Zabrocki has succeeded wrapping the self_exe_id in 7
> > days.  Even my slower timing is in the uptime of a typical server.
> 
> FYI, if you actually optimize this, it's more like 12s to exec 1048576
> times according to my test, which means ~14 hours for 2^32 executions
> (on a single core). That's on an i7-4790 (a Haswell desktop processor
> that was launched about six years ago, in 2014).
> 

Yep, there are a few ways of optimizing it and I believe I've pointed it out 
here:
https://www.openwall.com/lists/kernel-hardening/2020/03/31/11

Thanks for doing such tests :)

I've also modified your PoC to use 'sysenter' and 'syscall' instruction. Both 
cases gave me an extra 4% speed bump (including a test for 64-bits 
"fast_execve"). I've run it under Intel(R) Xeon(R) E-2176G CPU @ 3.70GHz

As you've proven, it is possible to be done in a matter of hours.

Thanks,
Adam

> Here's my test code:
> 
> =============
> $ grep 'model name' /proc/cpuinfo | head -n1
> model name : Intel(R) Core(TM) i7-4790 CPU @ 3.60GHz
> $ cat build.sh
> #!/bin/sh
> set -e
> nasm -felf32 -o fast_execve.o fast_execve.asm
> ld -m elf_i386 -o fast_execve fast_execve.o
> gcc -o launch launch.c -Wall
> gcc -o finish finish.c -Wall
> $ cat fast_execve.asm
> bits 32
> 
> section .text
> global _start
> _start:
> ; eax = argv[0]
> ; expected to be 8 hex digits, with 'a' meaning 0x0 and 'p' meaning 0xf
> mov eax, [esp+4]
> 
> mov ebx, 0 ; loop counter
> hex_digit_loop:
> inc byte [eax+ebx]
> cmp byte [eax+ebx], 'a'+16
> jne next_exec
> mov byte [eax+ebx], 'a'
> inc ebx
> cmp ebx, 5 ;;;;;;;;;;;;;;;;;; this is N, where iteration_count=pow(16,N)
> jne hex_digit_loop
> 
> 
> ; reached pow(256,N) execs, get out
> 
> ; first make the stack big again
> mov eax, 75 ; setrlimit (32-bit ABI)
> mov ebx, 3 ; RLIMIT_STACK
> mov ecx, stacklim
> int 0x80
> 
> ; execute end helper
> mov ebx, 4 ; dirfd = 4
> jmp common_exec
> 
> next_exec:
> mov ebx, 3 ; dirfd = 3
> 
> common_exec: ; execveat() with file descriptor passed in as ebx
> mov ecx, nullval ; pathname = empty string
> lea edx, [esp+4] ; argv
> mov esi, 0 ; envp
> mov edi, 0x1000 ; flags = AT_EMPTY_PATH
> mov eax, 358 ; execveat (32-bit ABI)
> int 0x80
> int3
> 
> nullval:
> dd 0
> stacklim:
> dd 0x02000000
> dd 0xffffffff
> $ cat launch.c
> #define _GNU_SOURCE
> #include <fcntl.h>
> #include <err.h>
> #include <unistd.h>
> #include <sys/syscall.h>
> #include <sys/resource.h>
> int main(void) {
>   close(3);
>   close(4);
>   if (open("fast_execve", O_PATH) != 3)
>     err(1, "open fast_execve");
>   if (open("finish", O_PATH) != 4)
>     err(1, "open finish");
>   char *argv[] = { "aaaaaaaa", NULL };
> 
>   struct rlimit lim;
>   if (getrlimit(RLIMIT_STACK, &lim))
>     err(1, "getrlimit");
>   lim.rlim_cur = 0x4000;
>   if (setrlimit(RLIMIT_STACK, &lim))
>     err(1, "setrlimit");
> 
>   syscall(__NR_execveat, 3, "", argv, NULL, AT_EMPTY_PATH);
> }
> $ cat finish.c
> #include <stdlib.h>
> int main(void) {
>   exit(0);
> }
> $ ./build.sh
> $ time ./launch
> 
> real 0m12,075s
> user 0m0,905s
> sys 0m11,026s
> $
> =============

-- 
pi3 (pi3ki31ny) - pi3 (at) itsec pl
http://pi3.com.pl

