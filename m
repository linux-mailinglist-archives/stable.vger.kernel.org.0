Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1910F2E160
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 17:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbfE2Pmo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 11:42:44 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45965 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbfE2Pmo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 May 2019 11:42:44 -0400
X-Greylist: delayed 1421 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 May 2019 11:42:42 EDT
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out02.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hW0M0-0004kL-Mp; Wed, 29 May 2019 09:19:00 -0600
Received: from ip72-206-97-68.om.om.cox.net ([72.206.97.68] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hW0Lu-0000aq-LT; Wed, 29 May 2019 09:19:00 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20190523003916.20726-2-ebiederm@xmission.com>
        <20190529131503.F2AC221871@mail.kernel.org>
Date:   Wed, 29 May 2019 10:18:50 -0500
In-Reply-To: <20190529131503.F2AC221871@mail.kernel.org> (Sasha Levin's
        message of "Wed, 29 May 2019 13:15:03 +0000")
Message-ID: <87zhn51e79.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1hW0Lu-0000aq-LT;;;mid=<87zhn51e79.fsf@xmission.com>;;;hst=in02.mta.xmission.com;;;ip=72.206.97.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+yBPPQRbR4rIZSc+oUb7PentKgOHUWF5E=
X-SA-Exim-Connect-IP: 72.206.97.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa02.xmission.com
X-Spam-Level: *****
X-Spam-Status: No, score=5.7 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,LotsOfNums_01,TR_Symld_Words,T_TM2_M_HEADER_IN_MSG,
        T_TooManySym_01,T_XMDrugObfuBody_08,XMNoVowels,XMSubLong
        autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4996]
        *  1.5 TR_Symld_Words too many words that have symbols inside
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        *  1.2 LotsOfNums_01 BODY: Lots of long strings of numbers
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
        *  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;Sasha Levin <sashal@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 5639 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 3.6 (0.1%), b_tie_ro: 2.9 (0.1%), parse: 0.71
        (0.0%), extract_message_metadata: 4.4 (0.1%), get_uri_detail_list: 2.9
        (0.1%), tests_pri_-1000: 2.4 (0.0%), tests_pri_-950: 1.03 (0.0%),
        tests_pri_-900: 0.84 (0.0%), tests_pri_-90: 44 (0.8%), check_bayes: 43
        (0.8%), b_tokenize: 11 (0.2%), b_tok_get_all: 20 (0.4%), b_comp_prob:
        2.4 (0.0%), b_tok_touch_all: 4.5 (0.1%), b_finish: 0.66 (0.0%),
        tests_pri_0: 5568 (98.8%), check_dkim_signature: 0.47 (0.0%),
        check_dkim_adsp: 5106 (90.5%), poll_dns_idle: 5103 (90.5%),
        tests_pri_10: 1.75 (0.0%), tests_pri_500: 5.0 (0.1%), rewrite_mail:
        0.00 (0.0%)
Subject: Re: [REVIEW][PATCH 01/26] signal: Correct namespace fixups of si_pid and si_uid
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sasha Levin <sashal@kernel.org> writes:

> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 6588c1e3ff014 signals: SI_USER: Masquerade si_pid when crossing pid ns boundary.
>
> The bot has tested the following trees: v5.1.4, v5.0.18, v4.19.45, v4.14.121, v4.9.178, v4.4.180, v3.18.140.
>
> v5.1.4: Build OK!
> v5.0.18: Build OK!
> v4.19.45: Failed to apply! Possible dependencies:
>     4cd2e0e70af68 ("signal: Introduce copy_siginfo_from_user and use it's return value")
>     ae7795bc6187a ("signal: Distinguish between kernel_siginfo and siginfo")
>     efc463adbccf7 ("signal: Simplify tracehook_report_syscall_exit")
>
> v4.14.121: Failed to apply! Possible dependencies:
>     212a36a17efe4 ("signal: Unify and correct copy_siginfo_from_user32")
>     3eb0f5193b497 ("signal: Ensure every siginfo we send has all bits initialized")
>     3f7c86b2382ea ("arm64: Update fault_info table with new exception types")
>     526c3ddb6aa27 ("signal/arm64: Document conflicts with SI_USER and SIGFPE,SIGTRAP,SIGBUS")
>     532826f3712b6 ("arm64: Mirror arm for unimplemented compat syscalls")
>     6b4f3d01052a4 ("usb, signal, security: only pass the cred, not the secid, to kill_pid_info_as_cred and security_task_kill")
>     92ff0674f5d80 ("arm64: mm: Rework unhandled user pagefaults to call arm64_force_sig_info")
>     ae7795bc6187a ("signal: Distinguish between kernel_siginfo and siginfo")
>     af40ff687bc9d ("arm64: signal: Ensure si_code is valid for all fault signals")
>     b713da69e4c91 ("signal: unify compat_siginfo_t")
>     ea64d5acc8f03 ("signal: Unify and correct copy_siginfo_to_user32")
>     efc463adbccf7 ("signal: Simplify tracehook_report_syscall_exit")
>
> v4.9.178: Failed to apply! Possible dependencies:
>     359566faefa85 ("kernel_wait4()/kernel_waitid(): delay copying status to userland")
>     4c48abe91be03 ("waitid(): switch copyout of siginfo to unsafe_put_user()")
>     4e2648db9c5f7 ("ARM: remove indirection of asm/mach-types.h")
>     4f4ddad395b04 ("nios2: put setup.h in uapi")
>     53d3eaa315082 ("posix_cpu_timers: Move the add_device_randomness() call to a proper place")
>     67d7ddded322d ("waitid(2): leave copyout of siginfo to syscall itself")
>     6bc51cbaa9d75 ("signal: Remove non-uapi <asm/siginfo.h>")
>     7e95a225901a5 ("move compat wait4 and waitid next to native variants")
>     80dce5e374930 ("signal/ia64: Document a conflict with SI_USER with SIGFPE")
>     8f95c90ceb541 ("sched/wait, RCU: Introduce rcuwait machinery")
>     96a8fae0fe094 ("ARM: convert to generated system call tables")
>     ae7795bc6187a ("signal: Distinguish between kernel_siginfo and siginfo")
>     b9253a43370e8 ("signal: Move copy_siginfo_to_user to <linux/signal.h>")
>     cc731525f26af ("signal: Remove kernel interal si_code magic")
>     cc9f72e474a4d ("signal/sparc: Document a conflict with SI_USER with SIGFPE")
>     ce72a16fa705f ("wait4(2)/waitid(2): separate copying rusage to userland")
>     d08477aa975e9 ("fcntl: Don't use ambiguous SIG_POLL si_codes")
>     e2bd64d92a10f ("signal/alpha: Document a conflict with SI_USER for SIGTRAP")
>     ea1b75cf91380 ("signal/mips: Document a conflict with SI_USER with SIGFPE")
>     ea64d5acc8f03 ("signal: Unify and correct copy_siginfo_to_user32")
>
> v4.4.180: Failed to apply! Possible dependencies:
>     2b5e869ecfcb3 ("MIPS: ELF: Interpret the NAN2008 file header flag")
>     4f4acc9472e54 ("parisc: Fix SIGSYS signals in compat case")
>     5050e91fa650e ("MIPS: Support sending SIG_SYS to 32bit userspace from 64bit kernel")
>     5fa393c857195 ("MIPS: Break down cacheops.h definitions")
>     6846351052e68 ("x86/signal: Add SA_{X32,IA32}_ABI sa_flags")
>     694977006a7ba ("MIPS: Use enums to make asm/pgtable-bits.h readable")
>     745f355878462 ("MIPS: mm: Unify pte_page definition")
>     780602d740fc0 ("MIPS: mm: Standardise on _PAGE_NO_READ, drop _PAGE_READ")
>     7939469da29a8 ("MIPS64: signal: Fix o32 sigaction syscall")
>     7b2cb64f91f25 ("MIPS: mm: Fix MIPS32 36b physical addressing (alchemy, netlogic)")
>     80dce5e374930 ("signal/ia64: Document a conflict with SI_USER with SIGFPE")
>     97f2645f358b4 ("tree-wide: replace config_enabled() with IS_ENABLED()")
>     a4455082dc6f0 ("x86/signals: Add missing signal_compat code for x86 features")
>     a60ae81e5e591 ("MIPS: CM: Fix mips_cm_max_vp_width for UP kernels")
>     ae7795bc6187a ("signal: Distinguish between kernel_siginfo and siginfo")
>     b1b4fad5cc678 ("MIPS: seccomp: Support compat with both O32 and N32")
>     b27873702b060 ("mips, thp: remove infrastructure for handling splitting PMDs")
>     b2edcfc814017 ("MIPS: Loongson: Add Loongson-3A R2 basic support")
>     cc731525f26af ("signal: Remove kernel interal si_code magic")
>     cc9f72e474a4d ("signal/sparc: Document a conflict with SI_USER with SIGFPE")
>     e2bd64d92a10f ("signal/alpha: Document a conflict with SI_USER for SIGTRAP")
>     ea1b75cf91380 ("signal/mips: Document a conflict with SI_USER with SIGFPE")
>     ea64d5acc8f03 ("signal: Unify and correct copy_siginfo_to_user32")
>
> v3.18.140: Failed to apply! Possible dependencies:
>     1a3d59579b9f4 ("MIPS: Tidy up FPU context switching")
>     304acb717e5b6 ("MIPS: Set `si_code' for SIGFPE signals sent from emulation too")
>     4227a2d4efc9c ("MIPS: Support for hybrid FPRs")
>     443c44032a54f ("MIPS: Always clear FCSR cause bits after emulation")
>     4a7c2371823a4 ("MIPS: Reindent R6 RI exception emulation")
>     53f037b08b5be ("ia64: Sync struct siginfo with general version")
>     5a1aca4469fdc ("MIPS: Fix FCSR Cause bit handling for correct SIGFPE issue")
>     5f9f41c474bef ("MIPS: kernel: Prepare the JR instruction for emulation on MIPS R6")
>     7c151d3d5d7a0 ("MIPS: Make use of the ERETNC instruction on MIPS R6")
>     80dce5e374930 ("signal/ia64: Document a conflict with SI_USER with SIGFPE")
>     9cc719ab3f4f6 ("MIPS: MSA: bugfix - disable MSA correctly for new threads/processes.")
>     ae7795bc6187a ("signal: Distinguish between kernel_siginfo and siginfo")
>     b0a668fb2038d ("MIPS: kernel: mips-r2-to-r6-emul: Add R2 emulator for MIPS R6")
>     cc5e9097c9aad ("arm64: add SIGSYS siginfo for compat task")
>     cc731525f26af ("signal: Remove kernel interal si_code magic")
>     e2bd64d92a10f ("signal/alpha: Document a conflict with SI_USER for SIGTRAP")
>     ea1b75cf91380 ("signal/mips: Document a conflict with SI_USER with SIGFPE")
>     ea64d5acc8f03 ("signal: Unify and correct copy_siginfo_to_user32")
>     ed2d72c1eb364 ("MIPS: Respect the FCSR exception mask for `si_code'")
>     f51246efee2b6 ("MIPS: Get rid of finish_arch_switch().")
>     fad0bfdb893ac ("MIPS: mips-r2-to-r6-emul.h: Inline empty `mipsr2_decoder'")
>
>
> How should we proceed with this patch?

I have not had any reports of anyone having problems, and this
only triggers when signals traverse a pid or a user namespace
boundary.

So while this is indeed a fix I think the usual best effort backport
will be fine.

If backporting further is desired it looks like the only real dependency
is the addition of the function siginfo_layout.  So it should not be as
difficult as the automated scripts suggests.

Eric

