Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3518C2DFB5
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 16:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfE2O1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 10:27:13 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43010 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727087AbfE2O1N (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 May 2019 10:27:13 -0400
Received: by mail-wr1-f67.google.com with SMTP id l17so1927773wrm.10;
        Wed, 29 May 2019 07:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:openpgp:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PwNkBrQv1wNUrppZVJDTx6Vf584sbVV+YeNCp+f2S9M=;
        b=dm16LjnZxom401BvzSjHBl2qBPtdiVGoxTb4+xJjMZIa5FDFdcEJn4mAWXi1xDuVzf
         esvDzSKnbvD/ACR+SNKGOIMfb7+ofQYbGbn91UYsfNxbYr9uVW5PD4rVyh/9EyHkSJdG
         2mmtuc0G8ebXIG1QJWULLQrNUD+3FmwKCKBv7enGnREddFX1ZFYyz4kCvUpwF6Da+Bd2
         34i09nbg/VzOA3DSf9V7lXyIUEwZRrafNoou//4eXtovrInTjfPxKelpXOYm+Ya6oL9a
         Q52yTfPs+TY6m6AK+qbxHA6ucCFQqYFhiBbx7fWxT/BQJIUgLAuGm1YnqgGaEB5A5nLv
         6nGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:openpgp
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=PwNkBrQv1wNUrppZVJDTx6Vf584sbVV+YeNCp+f2S9M=;
        b=OUMizmc1E149+G8YqLWYxZV4/LypVHqXA1e5EwsmfUQYfQ0Yc56xK5bVO6qgDSqPEp
         XpEVq87JiLFGYwPBKoY469oJMAOBzvhuz0i7mpHgXpKDLaWh6aMwhQHxVHcYI4ZM/X07
         Ooi6ZDtjRh8rtkZXTgd3/uj9JQE6CIMb5fR65A7+spZqx5tAho/1A07FmqdsfVwcqp0u
         gLFVhAiod68aruEhEHl2IQIGPD8HnORQltEJgAIJsbKnePKLkenk9PcD5mQxthst2I8h
         qPuioOORHUel/UENSetPtjZcBe6DyIk3N8EIKj7C0VyYk8ZrirFuuozRpOnoz3gB8bHQ
         AcJg==
X-Gm-Message-State: APjAAAWvw7L799+NdkgeG238S68ZxN8Ggq2HmuJ6BYXDpkMuaJ2DEpWN
        MyanVB9fmUvRaChFiNUJbW1CpVI3ths=
X-Google-Smtp-Source: APXvYqy7ntzjQBvsKAMAGgrp852raE1nrNtCC8Cgvy9+CG9QO9+LF2J4+AGiOoBEtvL97DGo3wMilw==
X-Received: by 2002:adf:e845:: with SMTP id d5mr18493394wrn.154.1559140030763;
        Wed, 29 May 2019 07:27:10 -0700 (PDT)
Received: from [10.32.224.40] (red-hat-inc.vlan560.asr1.mad1.gblx.net. [159.63.51.90])
        by smtp.gmail.com with ESMTPSA id a139sm9287027wmd.18.2019.05.29.07.27.09
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 07:27:09 -0700 (PDT)
Subject: Re: [PATCH v2] MIPS: Treat Loongson Extensions as ASEs
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>, linux-mips@vger.kernel.org
Cc:     paul.burton@mips.com, Huacai Chen <chenhc@lemote.com>,
        Yunqiang Su <ysu@wavecomp.com>, stable@vger.kernel.org
References: <20190529084259.8511-1-jiaxun.yang@flygoat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Openpgp: url=http://pgp.mit.edu/pks/lookup?op=get&search=0xE3E32C2CDEADC0DE
Message-ID: <c247ff0a-45f6-4c1f-4aa8-38c7d9a0a78b@amsat.org>
Date:   Wed, 29 May 2019 16:27:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190529084259.8511-1-jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jiaxun,

On 5/29/19 10:42 AM, Jiaxun Yang wrote:
> Recently, binutils had split Loongson-3 Extensions into four ASEs:
> MMI, CAM, EXT, EXT2. This patch do the samething in kernel and expose
> them in cpuinfo so applications can probe supported ASEs at runtime.
> 
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> Cc: Huacai Chen <chenhc@lemote.com>
> Cc: Yunqiang Su <ysu@wavecomp.com>
> Cc: stable@vger.kernel.org # v4.14+
> ---
>  arch/mips/include/asm/cpu-features.h | 16 ++++++++++++++++
>  arch/mips/include/asm/cpu.h          |  4 ++++
>  arch/mips/kernel/cpu-probe.c         |  6 ++++++
>  arch/mips/kernel/proc.c              |  4 ++++
>  4 files changed, 30 insertions(+)
> 
> diff --git a/arch/mips/include/asm/cpu-features.h b/arch/mips/include/asm/cpu-features.h
> index 6998a9796499..4e2bea8875f5 100644
> --- a/arch/mips/include/asm/cpu-features.h
> +++ b/arch/mips/include/asm/cpu-features.h
> @@ -397,6 +397,22 @@
>  #define cpu_has_dsp3		__ase(MIPS_ASE_DSP3)
>  #endif
>  
> +#ifndef cpu_has_loongson_mmi
> +#define cpu_has_loongson_mmi		__ase(MIPS_ASE_LOONGSON_MMI)
> +#endif
> +
> +#ifndef cpu_has_loongson_cam
> +#define cpu_has_loongson_cam		__ase(MIPS_ASE_LOONGSON_CAM)
> +#endif
> +
> +#ifndef cpu_has_loongson_ext
> +#define cpu_has_loongson_ext		__ase(MIPS_ASE_LOONGSON_EXT)
> +#endif
> +
> +#ifndef cpu_has_loongson_ext2
> +#define cpu_has_loongson_ext2		__ase(MIPS_ASE_LOONGSON_EXT2)
> +#endif
> +
>  #ifndef cpu_has_mipsmt
>  #define cpu_has_mipsmt		__isa_lt_and_ase(6, MIPS_ASE_MIPSMT)
>  #endif
> diff --git a/arch/mips/include/asm/cpu.h b/arch/mips/include/asm/cpu.h
> index 6ad7d3cabd91..cc15670ef43a 100644
> --- a/arch/mips/include/asm/cpu.h
> +++ b/arch/mips/include/asm/cpu.h
> @@ -438,5 +438,9 @@ enum cpu_type_enum {
>  #define MIPS_ASE_MSA		0x00000100 /* MIPS SIMD Architecture */
>  #define MIPS_ASE_DSP3		0x00000200 /* Signal Processing ASE Rev 3*/
>  #define MIPS_ASE_MIPS16E2	0x00000400 /* MIPS16e2 */
> +#define MIPS_ASE_LOONGSON_MMI	0x00000800 /* Loongson MultiMedia extensions Instructions */
> +#define MIPS_ASE_LOONGSON_CAM	0x00001000 /* Loongson CAM */
> +#define MIPS_ASE_LOONGSON_EXT	0x00002000 /* Loongson EXTensions */
> +#define MIPS_ASE_LOONGSON_EXT2	0x00004000 /* Loongson EXTensions R2 */
>  
>  #endif /* _ASM_CPU_H */
> diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
> index 6126b77d5a62..f349be1cf5b8 100644
> --- a/arch/mips/kernel/cpu-probe.c
> +++ b/arch/mips/kernel/cpu-probe.c
> @@ -1577,6 +1577,8 @@ static inline void cpu_probe_legacy(struct cpuinfo_mips *c, unsigned int cpu)
>  			__cpu_name[cpu] = "ICT Loongson-3";
>  			set_elf_platform(cpu, "loongson3a");
>  			set_isa(c, MIPS_CPU_ISA_M64R1);
> +			c->ases |= (MIPS_ASE_LOONGSON_MMI | MIPS_ASE_LOONGSON_CAM |
> +				MIPS_ASE_LOONGSON_EXT);
>  			break;
>  		case PRID_REV_LOONGSON3B_R1:
>  		case PRID_REV_LOONGSON3B_R2:
> @@ -1584,6 +1586,8 @@ static inline void cpu_probe_legacy(struct cpuinfo_mips *c, unsigned int cpu)
>  			__cpu_name[cpu] = "ICT Loongson-3";
>  			set_elf_platform(cpu, "loongson3b");
>  			set_isa(c, MIPS_CPU_ISA_M64R1);
> +			c->ases |= (MIPS_ASE_LOONGSON_MMI | MIPS_ASE_LOONGSON_CAM |
> +				MIPS_ASE_LOONGSON_EXT);
>  			break;
>  		}
>  
> @@ -1950,6 +1954,8 @@ static inline void cpu_probe_loongson(struct cpuinfo_mips *c, unsigned int cpu)
>  		decode_configs(c);
>  		c->options |= MIPS_CPU_FTLB | MIPS_CPU_TLBINV | MIPS_CPU_LDPTE;
>  		c->writecombine = _CACHE_UNCACHED_ACCELERATED;
> +		c->ases |= (MIPS_ASE_LOONGSON_MMI | MIPS_ASE_LOONGSON_CAM |
> +			MIPS_ASE_LOONGSON_EXT | MIPS_ASE_LOONGSON_EXT2);

You announce the Loongson 2E/2F as supporting the EXTensions R2 ASE, are
you sure this is correct?

Regards,

Phil.

>  		break;
>  	default:
>  		panic("Unknown Loongson Processor ID!");
> diff --git a/arch/mips/kernel/proc.c b/arch/mips/kernel/proc.c
> index b2de408a259e..f8d36710cd58 100644
> --- a/arch/mips/kernel/proc.c
> +++ b/arch/mips/kernel/proc.c
> @@ -124,6 +124,10 @@ static int show_cpuinfo(struct seq_file *m, void *v)
>  	if (cpu_has_eva)	seq_printf(m, "%s", " eva");
>  	if (cpu_has_htw)	seq_printf(m, "%s", " htw");
>  	if (cpu_has_xpa)	seq_printf(m, "%s", " xpa");
> +	if (cpu_has_loongson_mmi)	seq_printf(m, "%s", " loongson-mmi");
> +	if (cpu_has_loongson_cam)	seq_printf(m, "%s", " loongson-cam");
> +	if (cpu_has_loongson_ext)	seq_printf(m, "%s", " loongson-ext");
> +	if (cpu_has_loongson_ext2)	seq_printf(m, "%s", " loongson-ext2");
>  	seq_printf(m, "\n");
>  
>  	if (cpu_has_mmips) {
> 
