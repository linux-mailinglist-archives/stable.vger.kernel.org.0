Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7712057C3D1
	for <lists+stable@lfdr.de>; Thu, 21 Jul 2022 07:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbiGUFmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 01:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiGUFmQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 01:42:16 -0400
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E38E3B941;
        Wed, 20 Jul 2022 22:42:15 -0700 (PDT)
Received: by mail-ej1-f42.google.com with SMTP id b11so1218504eju.10;
        Wed, 20 Jul 2022 22:42:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=y556XsK+9YT7ZnqHsQO4pYXsuRIeC4AlnPZA+pHqtoE=;
        b=3rWgPtr3uNkD9zkUiWqpL/et+dxzbp/kCUzS6AzwA7e0wnAB9y2UTJYCpF9toS5EJm
         4l9x/zrfFOTcepshIqeQ9C7W+iiqmWyZHcLu+q8E4WCHdZSVu+f5CbYTXfi+GvqEYph1
         L4FB5zeUYzDscViKIeZXWV+hTZOvyjknIjkczrRbuJApbZcVeNcKjTo+/iJVrF7uwW0b
         qnUBcWbyGqJz+FgBakIxbBztZdObqA15BZ71EpE4vFX1gp8o+VHG50iFFYy8KDlzUN+2
         hcfZS9OtPxdRZsxv/M6ZOiRIep78oN0ri8J1RoSFEt+QTzleaLDIHF08nPQg5jDrY6rz
         EZbA==
X-Gm-Message-State: AJIora/orULUUbGzQwb2xNDB6xSnprKudjKopEE5Q7d8g8ojWpTG52Rt
        WcayTm7zrwuvxAnOV/JR1a4=
X-Google-Smtp-Source: AGRyM1vaqNtYojNtPQeKnELzxJ/+XJ4gg50RE4DfmX5pEXBkDub1teSONlnKDgNkkVToBUsiatOwQw==
X-Received: by 2002:a17:906:9750:b0:72f:39e7:1215 with SMTP id o16-20020a170906975000b0072f39e71215mr16551320ejy.122.1658382133592;
        Wed, 20 Jul 2022 22:42:13 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id h14-20020aa7de0e000000b0043a7404314csm444867edv.8.2022.07.20.22.42.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jul 2022 22:42:12 -0700 (PDT)
Message-ID: <6cb8a9c9-d256-5db2-e352-e8de1165950c@kernel.org>
Date:   Thu, 21 Jul 2022 07:42:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.18 000/231] 5.18.13-rc1 review
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Justin Forbes <jforbes@fedoraproject.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Slade Watkins <slade@sladewatkins.com>,
        John Harrison <John.C.Harrison@intel.com>,
        Tejas Upadhyay <tejas.upadhyay@intel.com>,
        Anusha Srivatsa <anusha.srivatsa@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
References: <20220719114714.247441733@linuxfoundation.org>
 <CA+G9fYsCL48P5zFMKUxoJ-1vwUJSWhcn17rUx=1rxOdzdw_Mmg@mail.gmail.com>
 <CAHk-=wjo-u8=yJQJQnaP41FkQw7we9A-zJH3UELx5x_1ynPDfw@mail.gmail.com>
 <YtgvLUMuz+1zpQHR@fedora64.linuxtx.org>
 <CAHk-=wiu=yk=3xzXk18o5yU6v1wn27rcrOD=vmKm_aLNz=zJ+w@mail.gmail.com>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <CAHk-=wiu=yk=3xzXk18o5yU6v1wn27rcrOD=vmKm_aLNz=zJ+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,BITCOIN_SPAM_02,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,PDS_BTC_ID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20. 07. 22, 19:28, Linus Torvalds wrote:
> [ Adding PeterZ and Jiri to the participants. ]
> 
> Looks like 5.18.13 added that commit 9bb2ec608a20 ("objtool: Update
> Retpoline validation") but I don't see 3131ef39fb03 ("x86/asm/32: Fix
> ANNOTATE_UNRET_SAFE use on 32-bit") in that list.
> 
> That said, 3131ef39fb03 should have fixed a completely different issue
> on 32-bit, not the "naked ret" thing.

Right. After applying 3131ef39fb03 on the top of 5.18.12 (or 5.18.13-rc1 
too), I'm fine:
https://build.opensuse.org/public/build/Kernel:stable/standard/i586/kernel-pae/_log

I.e. no warnings at all, the kernel compiles and runs fine -- tested in 
qemu only. It's gcc12 as can be seen in the log above.

Config:
https://github.com/openSUSE/kernel-source/blob/stable/config/i386/pae

It says:
CONFIG_CC_HAS_SLS=y
CONFIG_CC_HAS_RETURN_THUNK=y
CONFIG_SPECULATION_MITIGATIONS=y
CONFIG_PAGE_TABLE_ISOLATION=y
CONFIG_RETPOLINE=y
CONFIG_RETHUNK=y
CONFIG_CPU_UNRET_ENTRY=y
CONFIG_CPU_IBPB_ENTRY=y
CONFIG_CPU_IBRS_ENTRY=y
CONFIG_ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE=y

Patches:
https://github.com/openSUSE/kernel-source/tree/stable/patches.suse

Apart from others, it contains:
3131ef39fb03 x86/asm/32: Fix ANNOTATE_UNRET_SAFE use on 32-bit
bb06650634d3 KVM: VMX: Convert launched argument to flags
bea7e31a5cac KVM: VMX: Fix IBRS handling after vmexit
8bd200d23ec4 KVM: VMX: Flatten __vmx_vcpu_run()
07853adc29a0 KVM: VMX: Prevent RSB underflow before vmenter
fc02735b14ff KVM: VMX: Prevent guest RSB poisoning attacks with eIBRS
bf5835bcdb96 intel_idle: Disable IBRS during long idle
a09a6e2399ba objtool: Add entry UNRET validation
8faea26e6111 objtool: Re-add UNWIND_HINT_{SAVE_RESTORE}
951ddecf4356 objtool: Treat .text.__x86.* as noinstr
9bb2ec608a20 objtool: Update Retpoline validation
a149180fbcf3 x86: Add magic AMD return-thunk
15e67227c49a x86: Undo return-thunk damage
aa3d480315ba x86: Use return-thunk in asm code
d77cfe594ad5 x86/bpf: Use alternative RET encoding
7fbf47c7ce50 x86/bugs: Add AMD retbleed= boot parameter
f54d45372c6a x86/bugs: Add Cannon lake to RETBleed affected CPU list
3ebc17006888 x86/bugs: Add retbleed=ibpb
0fe4aeea9c01 x86/bugs: Do IBPB fallback check only once
2259da159fbe x86/bugs: Do not enable IBPB-on-entry when IBPB is not 
supported
e8ec1b6e08a2 x86/bugs: Enable STIBP for JMP2RET
caa0ff24d5d0 x86/bugs: Keep a per-CPU IA32_SPEC_CTRL value
c779bc1a9002 x86/bugs: Optimize SPEC_CTRL MSR writes
bcf163150cd3 x86/bugs: Remove apostrophe typo
6b80b59b3555 x86/bugs: Report AMD retbleed vulnerability
6ad0ad2bf8a6 x86/bugs: Report Intel retbleed vulnerability
166115c08a9b x86/bugs: Split spectre_v2_select_mitigation() and 
spectre_v2_user_select_mitigation()
7a05bc95ed1c x86/common: Stamp out the stepping madness
d7caac991fee x86/cpu/amd: Add Spectral Chicken
26aae8ccbc19 x86/cpu/amd: Enumerate BTC_NO
a883d624aed4 x86/cpufeatures: Move RETPOLINE flags to word 11
2dbb887e875b x86/entry: Add kernel IBRS implementation
7c81c0c9210c x86/entry: Avoid very early RET
64cbd0acb582 x86/entry: Don't call error_entry() for XENPV
2c08b9b38f5b x86/entry: Move PUSH_AND_CLEAR_REGS() back into error_entry
ee774dac0da1 x86/entry: Move PUSH_AND_CLEAR_REGS out of error_entry()
d16e0b266720 x86/entry: Remove UNTRAIN_RET from native_irq_return_ldt
1b331eeea7b8 x86/entry: Remove skip_r11rcx
520a7e80c96d x86/entry: Switch the stack after error_entry() returns
1f001e9da6bb x86/ftrace: Use alternative RET encoding
697977d8415d x86/kexec: Disable RET on kexec
af2e140f3420 x86/kvm: Fix SETcc emulation for return thunks
84e7051c0bc1 x86/kvm: fix FASTOP_SIZE when return thunks are enabled
742ab6df974a x86/kvm/vmx: Make noinstr clean
a1e2c031ec39 x86/mm: Simplify RESERVE_BRK()
d9e9d2300681 x86,objtool: Create .return_sites
f43b9876e857 x86/retbleed: Add fine grained Kconfig knobs
369ae6ffc41a x86/retpoline: Cleanup some #ifdefery
00e1533325fd x86/retpoline: Swizzle retpoline thunk
0b53c374b9ef x86/retpoline: Use -mfunction-return
0ee9073000e8 x86/sev: Avoid using __x86_return_thunk
7c693f54c873 x86/speculation: Add spectre_v2=ibrs option to support 
Kernel IBRS
4ad3278df6fe x86/speculation: Disable RRSBA behavior
9756bba28470 x86/speculation: Fill RSB on vmexit for IBRS
b2620facef48 x86/speculation: Fix RSB filling with CONFIG_RETPOLINE=n
56aa4d221f1e x86/speculation: Fix SPEC_CTRL write on SMT state change
e6aa13622ea8 x86/speculation: Fix firmware entry SPEC_CTRL handling
acac5e98ef8d x86/speculation: Remove x86_spec_ctrl_mask
bbb69e8bee1b x86/speculation: Use cached host SPEC_CTRL value for guest 
entry/exit
c27c753ea6fd x86/static_call: Serialize __static_call_fixup() properly
ee88d363d156 x86,static_call: Use alternative RET encoding
0aca53c6b522 x86/traps: Use pt_regs directly in fixup_bad_iret()
15583e514eb1 x86/vsyscall_emu/64: Don't use RET in vsyscall emulation
d147553b64ba x86/xen: Add UNTRAIN_RET
b75b7f8ef114 x86/xen: Rename SYS* entry points

Series file:
https://github.com/openSUSE/kernel-source/blob/stable/series.conf

> PeterZ, Jiri, any ideas? Limited quoting below, see thread at
> 
>    https://lore.kernel.org/all/CA+G9fYsJBBbEXowA-3kxDNqcfbtcqmxBrEnJSkCnLUsMzNfJZw@mail.gmail.com/
> 
> for more details.
> 
>                Linus
> 
> On Wed, Jul 20, 2022 at 9:37 AM Justin Forbes <jforbes@fedoraproject.org> wrote:
>>
>> On Tue, Jul 19, 2022 at 12:32:48PM -0700, Linus Torvalds wrote:
>>> On Tue, Jul 19, 2022 at 10:57 AM Naresh Kamboju
>>> <naresh.kamboju@linaro.org> wrote:
>>>>
>>>>
>>>> 2. Large number of build warnings on x86 with gcc-11,
>>>> I do not see these build warnings on mainline,
>>> ..
>>>> 'naked' return found in RETPOLINE build
>>>
>>> Hmm. Does your cross-compiler support '-mfunction-return=thunk-extern'?
>>>
>>> Your build does magic things with 'scripts/kconfig/merge_config.sh',
>>> and I'm wondering if you perhaps end up enabling CONFIG_RETHUNK with a
>>> compiler that doesn't actually support it, or something like that?
>>
>> I am seeing these 'naked' return found in RETPOLINE build on the
>> standard fedora 36 toolchain as well. No cross compiling, nothing fancy.
>> These were not seen with mainline, or with the 5.18.12-rc1 retbleed
>> patches.
>>
>> Justin

regards,
-- 
js
suse labs
