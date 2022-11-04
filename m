Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4100F619F8F
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 19:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbiKDSRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 14:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbiKDSRx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 14:17:53 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8914AF02
        for <stable@vger.kernel.org>; Fri,  4 Nov 2022 11:17:52 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id d59-20020a17090a6f4100b00213202d77e1so8962434pjk.2
        for <stable@vger.kernel.org>; Fri, 04 Nov 2022 11:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6KFWNlsWHLlbpfNSbjVDmIu/B57JgdZJqGkhbrbgxCo=;
        b=Lw57TQgZxKbMdC1vleHou0/1gYVsgX1iKRpjGG/aiz9MTVR+ox4zJ4dWO16IfwSG8s
         YvSi8AK1qlo4uAr7rH8c23PkykvRcmIXt20SmHDvnFYkxHs40xV+7AD2k5b1Z6GOy3Ho
         7p5ERRNO5pj9cySPUG6o0MRHXtcvg8wK3as1BSjuwxWeiE6HLCNWOzjOZW9G6SkAKql8
         kar2aw4AlmtOVn5mtE/0BTByI7r9tR6M91gziIt2zLNcOtf2ruCr2ZTQTzPc9wL0J9ZN
         vSnTgL7mcQyecRqsb84HqMJvhzePJPnDLTZYSXX6tPuygVjmXIODhMbWDxOn7/HoEQoG
         fBXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6KFWNlsWHLlbpfNSbjVDmIu/B57JgdZJqGkhbrbgxCo=;
        b=mVNzV/rseR2cqs0NGn/MG5bpOoJJWh1wAKMtMeTV/bvxb4uwhTiGUqFbUJe91F1WiJ
         rUd4IR5z6D7zgbSm/VD9iggKqyzcpL3T3g01JXUpweThqsl6YCoGLk2WIr853Zd+ZewY
         C7Rlvxqsp4wmHBALTuQzbtfhRlvjcilL8i6jPiKcz1Z2y8xlTrvRxV6oaQCh/lnpcZYT
         FVV32YrpsW3t7+QRwBD19bNTbHGlkPN3E9pHK3f6OybI2Skc4/PwH1kHAAjXj3Pmyd1X
         BxsVTEAag6f2b9pac1+ba690IySk9n3CDvfR0ehm17QHVapPxhKattpF8EFypmGcsDYs
         fbQw==
X-Gm-Message-State: ACrzQf1/iuB+NxMGpp+sz9wmFg0i22C+y97fMfNc566ISFkyaWyH/Oxb
        l1NsFCKaMO1+KntmEo+5yUBRvA==
X-Google-Smtp-Source: AMsMyM7V7NFp9hp0rs74Mv+0h9xWe0uyJ79OrNuQJ21IcutcUWPQsr/wUaYIBIlmb/8L8Yf+fg2S4g==
X-Received: by 2002:a17:902:db02:b0:187:4736:f783 with SMTP id m2-20020a170902db0200b001874736f783mr15749458plx.155.1667585871933;
        Fri, 04 Nov 2022 11:17:51 -0700 (PDT)
Received: from google.com ([2620:15c:2d1:203:6c2f:891:6157:b874])
        by smtp.gmail.com with ESMTPSA id e1-20020a170902b78100b0017f7628cbddsm81187pls.30.2022.11.04.11.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 11:17:51 -0700 (PDT)
Date:   Fri, 4 Nov 2022 11:17:45 -0700
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        jslaby@suse.cz
Subject: Re: Linux 4.14.297
Message-ID: <20221104181745.ahtjvjvk5qk7vu37@google.com>
References: <166732705422181@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166732705422181@kroah.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 01, 2022 at 07:24:13PM +0100, Greg Kroah-Hartman wrote:
> I'm announcing the release of the 4.14.297 kernel.
> 
> All users of the 4.14 kernel series must upgrade.
> 
> The updated 4.14.y git tree can be found at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
> and can be browsed at the normal kernel.org git web browser:
> 	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

Hi Greg and stable tree maintainers,
Please consider cherry-picking
commit 95b980d62d52 ("linux/bits.h: make BIT(), GENMASK(), and friends available in assembly")
back to 4.19.y and 4.14.y. It first landed in v5.3-rc1 and applies
cleanly to both branches. I did not find any fixups to 95b980d62d52,
FWIW.

Otherwise users upgrading to this point release of linux-4.14.y still on
versions of the GNU assembler older than v1.28 will observe assembler
errors when building this series. See the link below for the error
messages.

Please see
https://lore.kernel.org/llvm/20221103210748.1343090-1-ndesaulniers@google.com/
for more info.

> 
> thanks,
> 
> greg k-h
> 
> ------------
> 
>  Documentation/admin-guide/hw-vuln/spectre.rst   |    8 
>  Documentation/admin-guide/kernel-parameters.txt |   13 
>  Makefile                                        |    2 
>  arch/x86/entry/calling.h                        |   68 +++
>  arch/x86/entry/entry_32.S                       |    2 
>  arch/x86/entry/entry_64.S                       |   38 +-
>  arch/x86/entry/entry_64_compat.S                |   12 
>  arch/x86/include/asm/cpu_device_id.h            |  168 +++++++++
>  arch/x86/include/asm/cpufeatures.h              |   16 
>  arch/x86/include/asm/intel-family.h             |    6 
>  arch/x86/include/asm/msr-index.h                |   14 
>  arch/x86/include/asm/nospec-branch.h            |   48 +-
>  arch/x86/kernel/cpu/amd.c                       |   21 -
>  arch/x86/kernel/cpu/bugs.c                      |  415 +++++++++++++++++++-----
>  arch/x86/kernel/cpu/common.c                    |   68 ++-
>  arch/x86/kernel/cpu/match.c                     |   44 ++
>  arch/x86/kernel/cpu/scattered.c                 |    1 
>  arch/x86/kernel/process.c                       |    2 
>  arch/x86/kvm/svm.c                              |    1 
>  arch/x86/kvm/vmx.c                              |   51 ++
>  drivers/base/cpu.c                              |    8 
>  drivers/cpufreq/acpi-cpufreq.c                  |    1 
>  drivers/cpufreq/amd_freq_sensitivity.c          |    1 
>  drivers/idle/intel_idle.c                       |   45 ++
>  include/linux/cpu.h                             |    2 
>  include/linux/mod_devicetable.h                 |    4 
>  tools/arch/x86/include/asm/cpufeatures.h        |    1 
>  27 files changed, 898 insertions(+), 162 deletions(-)
> 
> Alexandre Chartre (2):
>       x86/bugs: Report AMD retbleed vulnerability
>       x86/bugs: Add AMD retbleed= boot parameter
> 
> Andrew Cooper (1):
>       x86/cpu/amd: Enumerate BTC_NO
> 
> Daniel Sneddon (1):
>       x86/speculation: Add RSB VM Exit protections
> 
> Greg Kroah-Hartman (1):
>       Linux 4.14.297
> 
> Ingo Molnar (1):
>       x86/cpufeature: Fix various quality problems in the <asm/cpu_device_hd.h> header
> 
> Josh Poimboeuf (8):
>       x86/speculation: Fix RSB filling with CONFIG_RETPOLINE=n
>       x86/speculation: Fix firmware entry SPEC_CTRL handling
>       x86/speculation: Fix SPEC_CTRL write on SMT state change
>       x86/speculation: Use cached host SPEC_CTRL value for guest entry/exit
>       x86/speculation: Remove x86_spec_ctrl_mask
>       KVM: VMX: Prevent guest RSB poisoning attacks with eIBRS
>       KVM: VMX: Fix IBRS handling after vmexit
>       x86/speculation: Fill RSB on vmexit for IBRS
> 
> Kan Liang (1):
>       x86/cpufeature: Add facility to check for min microcode revisions
> 
> Mark Gross (1):
>       x86/cpu: Add a steppings field to struct x86_cpu_id
> 
> Nathan Chancellor (1):
>       x86/speculation: Use DECLARE_PER_CPU for x86_spec_ctrl_current
> 
> Pawan Gupta (5):
>       x86/speculation: Add spectre_v2=ibrs option to support Kernel IBRS
>       x86/speculation: Add LFENCE to RSB fill sequence
>       x86/bugs: Add Cannon lake to RETBleed affected CPU list
>       x86/speculation: Disable RRSBA behavior
>       x86/bugs: Warn when "ibrs" mitigation is selected on Enhanced IBRS parts
> 
> Peter Zijlstra (9):
>       x86/entry: Remove skip_r11rcx
>       x86/cpufeatures: Move RETPOLINE flags to word 11
>       x86/bugs: Keep a per-CPU IA32_SPEC_CTRL value
>       x86/bugs: Optimize SPEC_CTRL MSR writes
>       x86/bugs: Split spectre_v2_select_mitigation() and spectre_v2_user_select_mitigation()
>       x86/bugs: Report Intel retbleed vulnerability
>       entel_idle: Disable IBRS during long idle
>       x86/speculation: Change FILL_RETURN_BUFFER to work with objtool
>       x86/common: Stamp out the stepping madness
> 
> Suraj Jitindar Singh (1):
>       Revert "x86/cpu: Add a steppings field to struct x86_cpu_id"
> 
> Thadeu Lima de Souza Cascardo (1):
>       x86/entry: Add kernel IBRS implementation
> 
> Thomas Gleixner (2):
>       x86/devicetable: Move x86 specific macro out of generic code
>       x86/cpu: Add consistent CPU match macros
> 
> 
