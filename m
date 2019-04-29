Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA808E6F7
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 17:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbfD2Pyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 11:54:54 -0400
Received: from mail-eopbgr70047.outbound.protection.outlook.com ([40.107.7.47]:34823
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728501AbfD2Pyy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Apr 2019 11:54:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qjiTlkAM33fp2QjO5kHcXeoz0i1pKbUEn3CVLD6/ZKs=;
 b=T6M1z0SblQIjus7IkWYSzqwDFhhTD0n9hxTo/VE8ugu5OlkIn0Et5EKMcCTUD7Y3GYv9cVSIsaX4YjbmCk4soZnL0JnpbSb+zEruwYsPhl3MwFb8M8Ekrn0xfMTWEvwONZ1ovk9fa5hrxBRfLI1pw4babf7CRW/nX2LY9TR1Kfk=
Received: from VI1PR0401MB2463.eurprd04.prod.outlook.com (10.168.64.146) by
 VI1PR0401MB2461.eurprd04.prod.outlook.com (10.168.64.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.13; Mon, 29 Apr 2019 15:52:36 +0000
Received: from VI1PR0401MB2463.eurprd04.prod.outlook.com
 ([fe80::2cba:efb0:12d5:243c]) by VI1PR0401MB2463.eurprd04.prod.outlook.com
 ([fe80::2cba:efb0:12d5:243c%8]) with mapi id 15.20.1835.018; Mon, 29 Apr 2019
 15:52:36 +0000
From:   Diana Madalina Craciun <diana.craciun@nxp.com>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "msuchanek@suse.de" <msuchanek@suse.de>,
        "npiggin@gmail.com" <npiggin@gmail.com>,
        "christophe.leroy@c-s.fr" <christophe.leroy@c-s.fr>
Subject: Re: [PATCH stable v4.4 00/52] powerpc spectre backports for 4.4
Thread-Topic: [PATCH stable v4.4 00/52] powerpc spectre backports for 4.4
Thread-Index: AQHU+E1z2mBCCSiQTEOS/sCRx65mjA==
Date:   Mon, 29 Apr 2019 15:52:36 +0000
Message-ID: <VI1PR0401MB2463EBDC80FC55672AC146CDFF390@VI1PR0401MB2463.eurprd04.prod.outlook.com>
References: <20190421142037.21881-1-mpe@ellerman.id.au>
 <VI1PR0401MB2463F6397FDC281DFDFF61FBFF220@VI1PR0401MB2463.eurprd04.prod.outlook.com>
 <87lfzuabxr.fsf@concordia.ellerman.id.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=diana.craciun@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8611d661-0221-455d-b474-08d6ccbab330
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0401MB2461;
x-ms-traffictypediagnostic: VI1PR0401MB2461:
x-microsoft-antispam-prvs: <VI1PR0401MB24612861253C06C5BDC2482DFF390@VI1PR0401MB2461.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(396003)(136003)(346002)(39860400002)(54524002)(199004)(189003)(446003)(478600001)(81156014)(8676002)(14444005)(71190400001)(71200400001)(14454004)(7736002)(305945005)(81166006)(316002)(54906003)(66066001)(8936002)(110136005)(76176011)(86362001)(2201001)(74316002)(256004)(68736007)(76116006)(6506007)(66946007)(66476007)(66556008)(64756008)(66446008)(97736004)(486006)(73956011)(476003)(91956017)(2906002)(30864003)(26005)(102836004)(53546011)(186003)(6116002)(2501003)(3846002)(53946003)(55016002)(6436002)(229853002)(33656002)(99286004)(53936002)(4326008)(25786009)(7696005)(52536014)(6246003)(19627235002)(9686003)(5660300002)(2004002)(579004)(559001)(569006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0401MB2461;H:VI1PR0401MB2463.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lGhMyPxEGsmaa5li23p6sz+OXWl9K+LlowsBDBN8rqIpJEs8TjSzJBSnq2OysoK17V2btZ6LGeIh6INN+1mjHk/EHYfD7KQcDct4QCsZbYRer+7/pgCKFjK1z7bNGZ+L0PtpOwF3Rfiuh1B8DMV8oMzsR8vIZOQE7VGBx0HWmb8Vd9Q0RT08m2IvRp/pIzFFnKIfkI/2KRxVzu5OjZwgiHOgU5SInuQujkakAOM43pVsuTOLSnIXgBFrtUVV8LNfttFtISzMOW+NTq1xJbd5ScTVAV2Co+7C09VbRiXHFCyOYSQDAMthC9E+jkah2b9W6OBjq2ndnS6m57SZbTVYxpFU2VfZrUYLjb964wXkBEKiI2BcdLARdbVfPCovE4tMN5sFTrWry5ThQ6qQ8y6q9kxqUk38sOcctZ1EphE32X4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8611d661-0221-455d-b474-08d6ccbab330
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 15:52:36.0239
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2461
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/28/2019 9:19 AM, Michael Ellerman wrote:=0A=
> Diana Madalina Craciun <diana.craciun@nxp.com> writes:=0A=
>> Hi Michael,=0A=
>>=0A=
>> There are some missing NXP Spectre v2 patches. I can send them=0A=
>> separately if the series will be accepted. I have merged them, but I did=
=0A=
>> not test them, I was sick today and incapable of doing that.=0A=
> No worries, there's no rush :)=0A=
>=0A=
> Sorry I missed them, I thought I had a list that included everything.=0A=
> Which commits was it I missed?=0A=
>=0A=
> I guess post them as a reply to this thread? That way whether the series=
=0A=
> is merged by Greg or not, there's a record here of what the backports=0A=
> look like.=0A=
=0A=
I have sent them as a separate series, but mentioning them here as well:=0A=
=0A=
Diana Craciun (8):=0A=
  powerpc/fsl: Enable runtime patching if nospectre_v2 boot arg is used=0A=
  powerpc/fsl: Flush branch predictor when entering KVM=0A=
  powerpc/fsl: Emulate SPRN_BUCSR register=0A=
  powerpc/fsl: Flush the branch predictor at each kernel entry (32 bit)=0A=
  powerpc/fsl: Sanitize the syscall table for NXP PowerPC 32 bit=0A=
    platforms=0A=
  powerpc/fsl: Fixed warning: orphan section `__btb_flush_fixup'=0A=
  powerpc/fsl: Add FSL_PPC_BOOK3E as supported arch for nospectre_v2=0A=
    boot arg=0A=
  Documentation: Add nospectre_v1 parameter=0A=
=0A=
regards=0A=
=0A=
> cheers=0A=
>=0A=
>> On 4/21/2019 5:21 PM, Michael Ellerman wrote:=0A=
>>> -----BEGIN PGP SIGNED MESSAGE-----=0A=
>>> Hash: SHA1=0A=
>>>=0A=
>>> Hi Greg/Sasha,=0A=
>>>=0A=
>>> Please queue up these powerpc patches for 4.4 if you have no objections=
.=0A=
>>>=0A=
>>> cheers=0A=
>>>=0A=
>>>=0A=
>>> Christophe Leroy (1):=0A=
>>>   powerpc/fsl: Fix the flush of branch predictor.=0A=
>>>=0A=
>>> Diana Craciun (10):=0A=
>>>   powerpc/64: Disable the speculation barrier from the command line=0A=
>>>   powerpc/64: Make stf barrier PPC_BOOK3S_64 specific.=0A=
>>>   powerpc/64: Make meltdown reporting Book3S 64 specific=0A=
>>>   powerpc/fsl: Add barrier_nospec implementation for NXP PowerPC Book3E=
=0A=
>>>   powerpc/fsl: Add infrastructure to fixup branch predictor flush=0A=
>>>   powerpc/fsl: Add macro to flush the branch predictor=0A=
>>>   powerpc/fsl: Fix spectre_v2 mitigations reporting=0A=
>>>   powerpc/fsl: Add nospectre_v2 command line argument=0A=
>>>   powerpc/fsl: Flush the branch predictor at each kernel entry (64bit)=
=0A=
>>>   powerpc/fsl: Update Spectre v2 reporting=0A=
>>>=0A=
>>> Mauricio Faria de Oliveira (4):=0A=
>>>   powerpc/rfi-flush: Differentiate enabled and patched flush types=0A=
>>>   powerpc/pseries: Fix clearing of security feature flags=0A=
>>>   powerpc: Move default security feature flags=0A=
>>>   powerpc/pseries: Restore default security feature flags on setup=0A=
>>>=0A=
>>> Michael Ellerman (29):=0A=
>>>   powerpc/xmon: Add RFI flush related fields to paca dump=0A=
>>>   powerpc/pseries: Support firmware disable of RFI flush=0A=
>>>   powerpc/powernv: Support firmware disable of RFI flush=0A=
>>>   powerpc/rfi-flush: Move the logic to avoid a redo into the debugfs=0A=
>>>     code=0A=
>>>   powerpc/rfi-flush: Make it possible to call setup_rfi_flush() again=
=0A=
>>>   powerpc/rfi-flush: Always enable fallback flush on pseries=0A=
>>>   powerpc/pseries: Add new H_GET_CPU_CHARACTERISTICS flags=0A=
>>>   powerpc/rfi-flush: Call setup_rfi_flush() after LPM migration=0A=
>>>   powerpc: Add security feature flags for Spectre/Meltdown=0A=
>>>   powerpc/pseries: Set or clear security feature flags=0A=
>>>   powerpc/powernv: Set or clear security feature flags=0A=
>>>   powerpc/64s: Move cpu_show_meltdown()=0A=
>>>   powerpc/64s: Enhance the information in cpu_show_meltdown()=0A=
>>>   powerpc/powernv: Use the security flags in pnv_setup_rfi_flush()=0A=
>>>   powerpc/pseries: Use the security flags in pseries_setup_rfi_flush()=
=0A=
>>>   powerpc/64s: Wire up cpu_show_spectre_v1()=0A=
>>>   powerpc/64s: Wire up cpu_show_spectre_v2()=0A=
>>>   powerpc/64s: Fix section mismatch warnings from setup_rfi_flush()=0A=
>>>   powerpc/64: Use barrier_nospec in syscall entry=0A=
>>>   powerpc: Use barrier_nospec in copy_from_user()=0A=
>>>   powerpc64s: Show ori31 availability in spectre_v1 sysfs file not v2=
=0A=
>>>   powerpc/64: Add CONFIG_PPC_BARRIER_NOSPEC=0A=
>>>   powerpc/64: Call setup_barrier_nospec() from setup_arch()=0A=
>>>   powerpc/asm: Add a patch_site macro & helpers for patching=0A=
>>>     instructions=0A=
>>>   powerpc/64s: Add new security feature flags for count cache flush=0A=
>>>   powerpc/64s: Add support for software count cache flush=0A=
>>>   powerpc/pseries: Query hypervisor for count cache flush settings=0A=
>>>   powerpc/powernv: Query firmware for count cache flush settings=0A=
>>>   powerpc/security: Fix spectre_v2 reporting=0A=
>>>=0A=
>>> Michael Neuling (1):=0A=
>>>   powerpc: Avoid code patching freed init sections=0A=
>>>=0A=
>>> Michal Suchanek (5):=0A=
>>>   powerpc/64s: Add barrier_nospec=0A=
>>>   powerpc/64s: Add support for ori barrier_nospec patching=0A=
>>>   powerpc/64s: Patch barrier_nospec in modules=0A=
>>>   powerpc/64s: Enable barrier_nospec based on firmware settings=0A=
>>>   powerpc/64s: Enhance the information in cpu_show_spectre_v1()=0A=
>>>=0A=
>>> Nicholas Piggin (2):=0A=
>>>   powerpc/64s: Improve RFI L1-D cache flush fallback=0A=
>>>   powerpc/64s: Add support for a store forwarding barrier at kernel=0A=
>>>     entry/exit=0A=
>>>=0A=
>>>  arch/powerpc/Kconfig                         |   7 +-=0A=
>>>  arch/powerpc/include/asm/asm-prototypes.h    |  21 +=0A=
>>>  arch/powerpc/include/asm/barrier.h           |  21 +=0A=
>>>  arch/powerpc/include/asm/code-patching-asm.h |  18 +=0A=
>>>  arch/powerpc/include/asm/code-patching.h     |   2 +=0A=
>>>  arch/powerpc/include/asm/exception-64s.h     |  35 ++=0A=
>>>  arch/powerpc/include/asm/feature-fixups.h    |  40 ++=0A=
>>>  arch/powerpc/include/asm/hvcall.h            |   5 +=0A=
>>>  arch/powerpc/include/asm/paca.h              |   3 +-=0A=
>>>  arch/powerpc/include/asm/ppc-opcode.h        |   1 +=0A=
>>>  arch/powerpc/include/asm/ppc_asm.h           |  11 +=0A=
>>>  arch/powerpc/include/asm/security_features.h |  92 ++++=0A=
>>>  arch/powerpc/include/asm/setup.h             |  23 +-=0A=
>>>  arch/powerpc/include/asm/uaccess.h           |  18 +-=0A=
>>>  arch/powerpc/kernel/Makefile                 |   1 +=0A=
>>>  arch/powerpc/kernel/asm-offsets.c            |   3 +-=0A=
>>>  arch/powerpc/kernel/entry_64.S               |  69 +++=0A=
>>>  arch/powerpc/kernel/exceptions-64e.S         |  27 +-=0A=
>>>  arch/powerpc/kernel/exceptions-64s.S         |  98 +++--=0A=
>>>  arch/powerpc/kernel/module.c                 |  10 +-=0A=
>>>  arch/powerpc/kernel/security.c               | 433 +++++++++++++++++++=
=0A=
>>>  arch/powerpc/kernel/setup_32.c               |   2 +=0A=
>>>  arch/powerpc/kernel/setup_64.c               |  50 +--=0A=
>>>  arch/powerpc/kernel/vmlinux.lds.S            |  33 +-=0A=
>>>  arch/powerpc/lib/code-patching.c             |  29 ++=0A=
>>>  arch/powerpc/lib/feature-fixups.c            | 218 +++++++++-=0A=
>>>  arch/powerpc/mm/mem.c                        |   2 +=0A=
>>>  arch/powerpc/mm/tlb_low_64e.S                |   7 +=0A=
>>>  arch/powerpc/platforms/powernv/setup.c       |  99 +++--=0A=
>>>  arch/powerpc/platforms/pseries/mobility.c    |   3 +=0A=
>>>  arch/powerpc/platforms/pseries/pseries.h     |   2 +=0A=
>>>  arch/powerpc/platforms/pseries/setup.c       |  88 +++-=0A=
>>>  arch/powerpc/xmon/xmon.c                     |   2 +=0A=
>>>  33 files changed, 1345 insertions(+), 128 deletions(-)=0A=
>>>  create mode 100644 arch/powerpc/include/asm/asm-prototypes.h=0A=
>>>  create mode 100644 arch/powerpc/include/asm/code-patching-asm.h=0A=
>>>  create mode 100644 arch/powerpc/include/asm/security_features.h=0A=
>>>  create mode 100644 arch/powerpc/kernel/security.c=0A=
>>>=0A=
>>> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig=0A=
>>> index 58a1fa979655..01b6c00a7060 100644=0A=
>>> - --- a/arch/powerpc/Kconfig=0A=
>>> +++ b/arch/powerpc/Kconfig=0A=
>>> @@ -136,7 +136,7 @@ config PPC=0A=
>>>  	select GENERIC_SMP_IDLE_THREAD=0A=
>>>  	select GENERIC_CMOS_UPDATE=0A=
>>>  	select GENERIC_TIME_VSYSCALL_OLD=0A=
>>> - -	select GENERIC_CPU_VULNERABILITIES	if PPC_BOOK3S_64=0A=
>>> +	select GENERIC_CPU_VULNERABILITIES	if PPC_BARRIER_NOSPEC=0A=
>>>  	select GENERIC_CLOCKEVENTS=0A=
>>>  	select GENERIC_CLOCKEVENTS_BROADCAST if SMP=0A=
>>>  	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST=0A=
>>> @@ -162,6 +162,11 @@ config PPC=0A=
>>>  	select ARCH_HAS_DMA_SET_COHERENT_MASK=0A=
>>>  	select HAVE_ARCH_SECCOMP_FILTER=0A=
>>>  =0A=
>>> +config PPC_BARRIER_NOSPEC=0A=
>>> +    bool=0A=
>>> +    default y=0A=
>>> +    depends on PPC_BOOK3S_64 || PPC_FSL_BOOK3E=0A=
>>> +=0A=
>>>  config GENERIC_CSUM=0A=
>>>  	def_bool CPU_LITTLE_ENDIAN=0A=
>>>  =0A=
>>> diff --git a/arch/powerpc/include/asm/asm-prototypes.h b/arch/powerpc/i=
nclude/asm/asm-prototypes.h=0A=
>>> new file mode 100644=0A=
>>> index 000000000000..8944c55591cf=0A=
>>> - --- /dev/null=0A=
>>> +++ b/arch/powerpc/include/asm/asm-prototypes.h=0A=
>>> @@ -0,0 +1,21 @@=0A=
>>> +#ifndef _ASM_POWERPC_ASM_PROTOTYPES_H=0A=
>>> +#define _ASM_POWERPC_ASM_PROTOTYPES_H=0A=
>>> +/*=0A=
>>> + * This file is for prototypes of C functions that are only called=0A=
>>> + * from asm, and any associated variables.=0A=
>>> + *=0A=
>>> + * Copyright 2016, Daniel Axtens, IBM Corporation.=0A=
>>> + *=0A=
>>> + * This program is free software; you can redistribute it and/or=0A=
>>> + * modify it under the terms of the GNU General Public License=0A=
>>> + * as published by the Free Software Foundation; either version 2=0A=
>>> + * of the License, or (at your option) any later version.=0A=
>>> + */=0A=
>>> +=0A=
>>> +/* Patch sites */=0A=
>>> +extern s32 patch__call_flush_count_cache;=0A=
>>> +extern s32 patch__flush_count_cache_return;=0A=
>>> +=0A=
>>> +extern long flush_count_cache;=0A=
>>> +=0A=
>>> +#endif /* _ASM_POWERPC_ASM_PROTOTYPES_H */=0A=
>>> diff --git a/arch/powerpc/include/asm/barrier.h b/arch/powerpc/include/=
asm/barrier.h=0A=
>>> index b9e16855a037..e7cb72cdb2ba 100644=0A=
>>> - --- a/arch/powerpc/include/asm/barrier.h=0A=
>>> +++ b/arch/powerpc/include/asm/barrier.h=0A=
>>> @@ -92,4 +92,25 @@ do {									\=0A=
>>>  #define smp_mb__after_atomic()      smp_mb()=0A=
>>>  #define smp_mb__before_spinlock()   smp_mb()=0A=
>>>  =0A=
>>> +#ifdef CONFIG_PPC_BOOK3S_64=0A=
>>> +#define NOSPEC_BARRIER_SLOT   nop=0A=
>>> +#elif defined(CONFIG_PPC_FSL_BOOK3E)=0A=
>>> +#define NOSPEC_BARRIER_SLOT   nop; nop=0A=
>>> +#endif=0A=
>>> +=0A=
>>> +#ifdef CONFIG_PPC_BARRIER_NOSPEC=0A=
>>> +/*=0A=
>>> + * Prevent execution of subsequent instructions until preceding branch=
es have=0A=
>>> + * been fully resolved and are no longer executing speculatively.=0A=
>>> + */=0A=
>>> +#define barrier_nospec_asm NOSPEC_BARRIER_FIXUP_SECTION; NOSPEC_BARRIE=
R_SLOT=0A=
>>> +=0A=
>>> +// This also acts as a compiler barrier due to the memory clobber.=0A=
>>> +#define barrier_nospec() asm (stringify_in_c(barrier_nospec_asm) ::: "=
memory")=0A=
>>> +=0A=
>>> +#else /* !CONFIG_PPC_BARRIER_NOSPEC */=0A=
>>> +#define barrier_nospec_asm=0A=
>>> +#define barrier_nospec()=0A=
>>> +#endif /* CONFIG_PPC_BARRIER_NOSPEC */=0A=
>>> +=0A=
>>>  #endif /* _ASM_POWERPC_BARRIER_H */=0A=
>>> diff --git a/arch/powerpc/include/asm/code-patching-asm.h b/arch/powerp=
c/include/asm/code-patching-asm.h=0A=
>>> new file mode 100644=0A=
>>> index 000000000000..ed7b1448493a=0A=
>>> - --- /dev/null=0A=
>>> +++ b/arch/powerpc/include/asm/code-patching-asm.h=0A=
>>> @@ -0,0 +1,18 @@=0A=
>>> +/* SPDX-License-Identifier: GPL-2.0+ */=0A=
>>> +/*=0A=
>>> + * Copyright 2018, Michael Ellerman, IBM Corporation.=0A=
>>> + */=0A=
>>> +#ifndef _ASM_POWERPC_CODE_PATCHING_ASM_H=0A=
>>> +#define _ASM_POWERPC_CODE_PATCHING_ASM_H=0A=
>>> +=0A=
>>> +/* Define a "site" that can be patched */=0A=
>>> +.macro patch_site label name=0A=
>>> +	.pushsection ".rodata"=0A=
>>> +	.balign 4=0A=
>>> +	.global \name=0A=
>>> +\name:=0A=
>>> +	.4byte	\label - .=0A=
>>> +	.popsection=0A=
>>> +.endm=0A=
>>> +=0A=
>>> +#endif /* _ASM_POWERPC_CODE_PATCHING_ASM_H */=0A=
>>> diff --git a/arch/powerpc/include/asm/code-patching.h b/arch/powerpc/in=
clude/asm/code-patching.h=0A=
>>> index 840a5509b3f1..a734b4b34d26 100644=0A=
>>> - --- a/arch/powerpc/include/asm/code-patching.h=0A=
>>> +++ b/arch/powerpc/include/asm/code-patching.h=0A=
>>> @@ -28,6 +28,8 @@ unsigned int create_cond_branch(const unsigned int *a=
ddr,=0A=
>>>  				unsigned long target, int flags);=0A=
>>>  int patch_branch(unsigned int *addr, unsigned long target, int flags);=
=0A=
>>>  int patch_instruction(unsigned int *addr, unsigned int instr);=0A=
>>> +int patch_instruction_site(s32 *addr, unsigned int instr);=0A=
>>> +int patch_branch_site(s32 *site, unsigned long target, int flags);=0A=
>>>  =0A=
>>>  int instr_is_relative_branch(unsigned int instr);=0A=
>>>  int instr_is_branch_to_addr(const unsigned int *instr, unsigned long a=
ddr);=0A=
>>> diff --git a/arch/powerpc/include/asm/exception-64s.h b/arch/powerpc/in=
clude/asm/exception-64s.h=0A=
>>> index 9bddbec441b8..3ed536bec462 100644=0A=
>>> - --- a/arch/powerpc/include/asm/exception-64s.h=0A=
>>> +++ b/arch/powerpc/include/asm/exception-64s.h=0A=
>>> @@ -50,6 +50,27 @@=0A=
>>>  #define EX_PPR		88	/* SMT thread status register (priority) */=0A=
>>>  #define EX_CTR		96=0A=
>>>  =0A=
>>> +#define STF_ENTRY_BARRIER_SLOT						\=0A=
>>> +	STF_ENTRY_BARRIER_FIXUP_SECTION;				\=0A=
>>> +	nop;								\=0A=
>>> +	nop;								\=0A=
>>> +	nop=0A=
>>> +=0A=
>>> +#define STF_EXIT_BARRIER_SLOT						\=0A=
>>> +	STF_EXIT_BARRIER_FIXUP_SECTION;					\=0A=
>>> +	nop;								\=0A=
>>> +	nop;								\=0A=
>>> +	nop;								\=0A=
>>> +	nop;								\=0A=
>>> +	nop;								\=0A=
>>> +	nop=0A=
>>> +=0A=
>>> +/*=0A=
>>> + * r10 must be free to use, r13 must be paca=0A=
>>> + */=0A=
>>> +#define INTERRUPT_TO_KERNEL						\=0A=
>>> +	STF_ENTRY_BARRIER_SLOT=0A=
>>> +=0A=
>>>  /*=0A=
>>>   * Macros for annotating the expected destination of (h)rfid=0A=
>>>   *=0A=
>>> @@ -66,16 +87,19 @@=0A=
>>>  	rfid=0A=
>>>  =0A=
>>>  #define RFI_TO_USER							\=0A=
>>> +	STF_EXIT_BARRIER_SLOT;						\=0A=
>>>  	RFI_FLUSH_SLOT;							\=0A=
>>>  	rfid;								\=0A=
>>>  	b	rfi_flush_fallback=0A=
>>>  =0A=
>>>  #define RFI_TO_USER_OR_KERNEL						\=0A=
>>> +	STF_EXIT_BARRIER_SLOT;						\=0A=
>>>  	RFI_FLUSH_SLOT;							\=0A=
>>>  	rfid;								\=0A=
>>>  	b	rfi_flush_fallback=0A=
>>>  =0A=
>>>  #define RFI_TO_GUEST							\=0A=
>>> +	STF_EXIT_BARRIER_SLOT;						\=0A=
>>>  	RFI_FLUSH_SLOT;							\=0A=
>>>  	rfid;								\=0A=
>>>  	b	rfi_flush_fallback=0A=
>>> @@ -84,21 +108,25 @@=0A=
>>>  	hrfid=0A=
>>>  =0A=
>>>  #define HRFI_TO_USER							\=0A=
>>> +	STF_EXIT_BARRIER_SLOT;						\=0A=
>>>  	RFI_FLUSH_SLOT;							\=0A=
>>>  	hrfid;								\=0A=
>>>  	b	hrfi_flush_fallback=0A=
>>>  =0A=
>>>  #define HRFI_TO_USER_OR_KERNEL						\=0A=
>>> +	STF_EXIT_BARRIER_SLOT;						\=0A=
>>>  	RFI_FLUSH_SLOT;							\=0A=
>>>  	hrfid;								\=0A=
>>>  	b	hrfi_flush_fallback=0A=
>>>  =0A=
>>>  #define HRFI_TO_GUEST							\=0A=
>>> +	STF_EXIT_BARRIER_SLOT;						\=0A=
>>>  	RFI_FLUSH_SLOT;							\=0A=
>>>  	hrfid;								\=0A=
>>>  	b	hrfi_flush_fallback=0A=
>>>  =0A=
>>>  #define HRFI_TO_UNKNOWN							\=0A=
>>> +	STF_EXIT_BARRIER_SLOT;						\=0A=
>>>  	RFI_FLUSH_SLOT;							\=0A=
>>>  	hrfid;								\=0A=
>>>  	b	hrfi_flush_fallback=0A=
>>> @@ -226,6 +254,7 @@ END_FTR_SECTION_NESTED(ftr,ftr,943)=0A=
>>>  #define __EXCEPTION_PROLOG_1(area, extra, vec)				\=0A=
>>>  	OPT_SAVE_REG_TO_PACA(area+EX_PPR, r9, CPU_FTR_HAS_PPR);		\=0A=
>>>  	OPT_SAVE_REG_TO_PACA(area+EX_CFAR, r10, CPU_FTR_CFAR);		\=0A=
>>> +	INTERRUPT_TO_KERNEL;						\=0A=
>>>  	SAVE_CTR(r10, area);						\=0A=
>>>  	mfcr	r9;							\=0A=
>>>  	extra(vec);							\=0A=
>>> @@ -512,6 +541,12 @@ label##_relon_hv:						\=0A=
>>>  #define _MASKABLE_EXCEPTION_PSERIES(vec, label, h, extra)		\=0A=
>>>  	__MASKABLE_EXCEPTION_PSERIES(vec, label, h, extra)=0A=
>>>  =0A=
>>> +#define MASKABLE_EXCEPTION_OOL(vec, label)				\=0A=
>>> +	.globl label##_ool;						\=0A=
>>> +label##_ool:								\=0A=
>>> +	EXCEPTION_PROLOG_1(PACA_EXGEN, SOFTEN_TEST_PR, vec);		\=0A=
>>> +	EXCEPTION_PROLOG_PSERIES_1(label##_common, EXC_STD);=0A=
>>> +=0A=
>>>  #define MASKABLE_EXCEPTION_PSERIES(loc, vec, label)			\=0A=
>>>  	. =3D loc;							\=0A=
>>>  	.globl label##_pSeries;						\=0A=
>>> diff --git a/arch/powerpc/include/asm/feature-fixups.h b/arch/powerpc/i=
nclude/asm/feature-fixups.h=0A=
>>> index 7068bafbb2d6..145a37ab2d3e 100644=0A=
>>> - --- a/arch/powerpc/include/asm/feature-fixups.h=0A=
>>> +++ b/arch/powerpc/include/asm/feature-fixups.h=0A=
>>> @@ -184,6 +184,22 @@ label##3:					       	\=0A=
>>>  	FTR_ENTRY_OFFSET label##1b-label##3b;		\=0A=
>>>  	.popsection;=0A=
>>>  =0A=
>>> +#define STF_ENTRY_BARRIER_FIXUP_SECTION			\=0A=
>>> +953:							\=0A=
>>> +	.pushsection __stf_entry_barrier_fixup,"a";	\=0A=
>>> +	.align 2;					\=0A=
>>> +954:							\=0A=
>>> +	FTR_ENTRY_OFFSET 953b-954b;			\=0A=
>>> +	.popsection;=0A=
>>> +=0A=
>>> +#define STF_EXIT_BARRIER_FIXUP_SECTION			\=0A=
>>> +955:							\=0A=
>>> +	.pushsection __stf_exit_barrier_fixup,"a";	\=0A=
>>> +	.align 2;					\=0A=
>>> +956:							\=0A=
>>> +	FTR_ENTRY_OFFSET 955b-956b;			\=0A=
>>> +	.popsection;=0A=
>>> +=0A=
>>>  #define RFI_FLUSH_FIXUP_SECTION				\=0A=
>>>  951:							\=0A=
>>>  	.pushsection __rfi_flush_fixup,"a";		\=0A=
>>> @@ -192,10 +208,34 @@ label##3:					       	\=0A=
>>>  	FTR_ENTRY_OFFSET 951b-952b;			\=0A=
>>>  	.popsection;=0A=
>>>  =0A=
>>> +#define NOSPEC_BARRIER_FIXUP_SECTION			\=0A=
>>> +953:							\=0A=
>>> +	.pushsection __barrier_nospec_fixup,"a";	\=0A=
>>> +	.align 2;					\=0A=
>>> +954:							\=0A=
>>> +	FTR_ENTRY_OFFSET 953b-954b;			\=0A=
>>> +	.popsection;=0A=
>>> +=0A=
>>> +#define START_BTB_FLUSH_SECTION			\=0A=
>>> +955:							\=0A=
>>> +=0A=
>>> +#define END_BTB_FLUSH_SECTION			\=0A=
>>> +956:							\=0A=
>>> +	.pushsection __btb_flush_fixup,"a";	\=0A=
>>> +	.align 2;							\=0A=
>>> +957:						\=0A=
>>> +	FTR_ENTRY_OFFSET 955b-957b;			\=0A=
>>> +	FTR_ENTRY_OFFSET 956b-957b;			\=0A=
>>> +	.popsection;=0A=
>>>  =0A=
>>>  #ifndef __ASSEMBLY__=0A=
>>>  =0A=
>>> +extern long stf_barrier_fallback;=0A=
>>> +extern long __start___stf_entry_barrier_fixup, __stop___stf_entry_barr=
ier_fixup;=0A=
>>> +extern long __start___stf_exit_barrier_fixup, __stop___stf_exit_barrie=
r_fixup;=0A=
>>>  extern long __start___rfi_flush_fixup, __stop___rfi_flush_fixup;=0A=
>>> +extern long __start___barrier_nospec_fixup, __stop___barrier_nospec_fi=
xup;=0A=
>>> +extern long __start__btb_flush_fixup, __stop__btb_flush_fixup;=0A=
>>>  =0A=
>>>  #endif=0A=
>>>  =0A=
>>> diff --git a/arch/powerpc/include/asm/hvcall.h b/arch/powerpc/include/a=
sm/hvcall.h=0A=
>>> index 449bbb87c257..b57db9d09db9 100644=0A=
>>> - --- a/arch/powerpc/include/asm/hvcall.h=0A=
>>> +++ b/arch/powerpc/include/asm/hvcall.h=0A=
>>> @@ -292,10 +292,15 @@=0A=
>>>  #define H_CPU_CHAR_L1D_FLUSH_ORI30	(1ull << 61) // IBM bit 2=0A=
>>>  #define H_CPU_CHAR_L1D_FLUSH_TRIG2	(1ull << 60) // IBM bit 3=0A=
>>>  #define H_CPU_CHAR_L1D_THREAD_PRIV	(1ull << 59) // IBM bit 4=0A=
>>> +#define H_CPU_CHAR_BRANCH_HINTS_HONORED	(1ull << 58) // IBM bit 5=0A=
>>> +#define H_CPU_CHAR_THREAD_RECONFIG_CTRL	(1ull << 57) // IBM bit 6=0A=
>>> +#define H_CPU_CHAR_COUNT_CACHE_DISABLED	(1ull << 56) // IBM bit 7=0A=
>>> +#define H_CPU_CHAR_BCCTR_FLUSH_ASSIST	(1ull << 54) // IBM bit 9=0A=
>>>  =0A=
>>>  #define H_CPU_BEHAV_FAVOUR_SECURITY	(1ull << 63) // IBM bit 0=0A=
>>>  #define H_CPU_BEHAV_L1D_FLUSH_PR	(1ull << 62) // IBM bit 1=0A=
>>>  #define H_CPU_BEHAV_BNDS_CHK_SPEC_BAR	(1ull << 61) // IBM bit 2=0A=
>>> +#define H_CPU_BEHAV_FLUSH_COUNT_CACHE	(1ull << 58) // IBM bit 5=0A=
>>>  =0A=
>>>  #ifndef __ASSEMBLY__=0A=
>>>  #include <linux/types.h>=0A=
>>> diff --git a/arch/powerpc/include/asm/paca.h b/arch/powerpc/include/asm=
/paca.h=0A=
>>> index 45e2aefece16..08e5df3395fa 100644=0A=
>>> - --- a/arch/powerpc/include/asm/paca.h=0A=
>>> +++ b/arch/powerpc/include/asm/paca.h=0A=
>>> @@ -199,8 +199,7 @@ struct paca_struct {=0A=
>>>  	 */=0A=
>>>  	u64 exrfi[13] __aligned(0x80);=0A=
>>>  	void *rfi_flush_fallback_area;=0A=
>>> - -	u64 l1d_flush_congruence;=0A=
>>> - -	u64 l1d_flush_sets;=0A=
>>> +	u64 l1d_flush_size;=0A=
>>>  #endif=0A=
>>>  };=0A=
>>>  =0A=
>>> diff --git a/arch/powerpc/include/asm/ppc-opcode.h b/arch/powerpc/inclu=
de/asm/ppc-opcode.h=0A=
>>> index 7ab04fc59e24..faf1bb045dee 100644=0A=
>>> - --- a/arch/powerpc/include/asm/ppc-opcode.h=0A=
>>> +++ b/arch/powerpc/include/asm/ppc-opcode.h=0A=
>>> @@ -147,6 +147,7 @@=0A=
>>>  #define PPC_INST_LWSYNC			0x7c2004ac=0A=
>>>  #define PPC_INST_SYNC			0x7c0004ac=0A=
>>>  #define PPC_INST_SYNC_MASK		0xfc0007fe=0A=
>>> +#define PPC_INST_ISYNC			0x4c00012c=0A=
>>>  #define PPC_INST_LXVD2X			0x7c000698=0A=
>>>  #define PPC_INST_MCRXR			0x7c000400=0A=
>>>  #define PPC_INST_MCRXR_MASK		0xfc0007fe=0A=
>>> diff --git a/arch/powerpc/include/asm/ppc_asm.h b/arch/powerpc/include/=
asm/ppc_asm.h=0A=
>>> index 160bb2311bbb..d219816b3e19 100644=0A=
>>> - --- a/arch/powerpc/include/asm/ppc_asm.h=0A=
>>> +++ b/arch/powerpc/include/asm/ppc_asm.h=0A=
>>> @@ -821,4 +821,15 @@ END_FTR_SECTION_NESTED(CPU_FTR_HAS_PPR,CPU_FTR_HAS=
_PPR,945)=0A=
>>>  	.long 0x2400004c  /* rfid				*/=0A=
>>>  #endif /* !CONFIG_PPC_BOOK3E */=0A=
>>>  #endif /*  __ASSEMBLY__ */=0A=
>>> +=0A=
>>> +#ifdef CONFIG_PPC_FSL_BOOK3E=0A=
>>> +#define BTB_FLUSH(reg)			\=0A=
>>> +	lis reg,BUCSR_INIT@h;		\=0A=
>>> +	ori reg,reg,BUCSR_INIT@l;	\=0A=
>>> +	mtspr SPRN_BUCSR,reg;		\=0A=
>>> +	isync;=0A=
>>> +#else=0A=
>>> +#define BTB_FLUSH(reg)=0A=
>>> +#endif /* CONFIG_PPC_FSL_BOOK3E */=0A=
>>> +=0A=
>>>  #endif /* _ASM_POWERPC_PPC_ASM_H */=0A=
>>> diff --git a/arch/powerpc/include/asm/security_features.h b/arch/powerp=
c/include/asm/security_features.h=0A=
>>> new file mode 100644=0A=
>>> index 000000000000..759597bf0fd8=0A=
>>> - --- /dev/null=0A=
>>> +++ b/arch/powerpc/include/asm/security_features.h=0A=
>>> @@ -0,0 +1,92 @@=0A=
>>> +/* SPDX-License-Identifier: GPL-2.0+ */=0A=
>>> +/*=0A=
>>> + * Security related feature bit definitions.=0A=
>>> + *=0A=
>>> + * Copyright 2018, Michael Ellerman, IBM Corporation.=0A=
>>> + */=0A=
>>> +=0A=
>>> +#ifndef _ASM_POWERPC_SECURITY_FEATURES_H=0A=
>>> +#define _ASM_POWERPC_SECURITY_FEATURES_H=0A=
>>> +=0A=
>>> +=0A=
>>> +extern unsigned long powerpc_security_features;=0A=
>>> +extern bool rfi_flush;=0A=
>>> +=0A=
>>> +/* These are bit flags */=0A=
>>> +enum stf_barrier_type {=0A=
>>> +	STF_BARRIER_NONE	=3D 0x1,=0A=
>>> +	STF_BARRIER_FALLBACK	=3D 0x2,=0A=
>>> +	STF_BARRIER_EIEIO	=3D 0x4,=0A=
>>> +	STF_BARRIER_SYNC_ORI	=3D 0x8,=0A=
>>> +};=0A=
>>> +=0A=
>>> +void setup_stf_barrier(void);=0A=
>>> +void do_stf_barrier_fixups(enum stf_barrier_type types);=0A=
>>> +void setup_count_cache_flush(void);=0A=
>>> +=0A=
>>> +static inline void security_ftr_set(unsigned long feature)=0A=
>>> +{=0A=
>>> +	powerpc_security_features |=3D feature;=0A=
>>> +}=0A=
>>> +=0A=
>>> +static inline void security_ftr_clear(unsigned long feature)=0A=
>>> +{=0A=
>>> +	powerpc_security_features &=3D ~feature;=0A=
>>> +}=0A=
>>> +=0A=
>>> +static inline bool security_ftr_enabled(unsigned long feature)=0A=
>>> +{=0A=
>>> +	return !!(powerpc_security_features & feature);=0A=
>>> +}=0A=
>>> +=0A=
>>> +=0A=
>>> +// Features indicating support for Spectre/Meltdown mitigations=0A=
>>> +=0A=
>>> +// The L1-D cache can be flushed with ori r30,r30,0=0A=
>>> +#define SEC_FTR_L1D_FLUSH_ORI30		0x0000000000000001ull=0A=
>>> +=0A=
>>> +// The L1-D cache can be flushed with mtspr 882,r0 (aka SPRN_TRIG2)=0A=
>>> +#define SEC_FTR_L1D_FLUSH_TRIG2		0x0000000000000002ull=0A=
>>> +=0A=
>>> +// ori r31,r31,0 acts as a speculation barrier=0A=
>>> +#define SEC_FTR_SPEC_BAR_ORI31		0x0000000000000004ull=0A=
>>> +=0A=
>>> +// Speculation past bctr is disabled=0A=
>>> +#define SEC_FTR_BCCTRL_SERIALISED	0x0000000000000008ull=0A=
>>> +=0A=
>>> +// Entries in L1-D are private to a SMT thread=0A=
>>> +#define SEC_FTR_L1D_THREAD_PRIV		0x0000000000000010ull=0A=
>>> +=0A=
>>> +// Indirect branch prediction cache disabled=0A=
>>> +#define SEC_FTR_COUNT_CACHE_DISABLED	0x0000000000000020ull=0A=
>>> +=0A=
>>> +// bcctr 2,0,0 triggers a hardware assisted count cache flush=0A=
>>> +#define SEC_FTR_BCCTR_FLUSH_ASSIST	0x0000000000000800ull=0A=
>>> +=0A=
>>> +=0A=
>>> +// Features indicating need for Spectre/Meltdown mitigations=0A=
>>> +=0A=
>>> +// The L1-D cache should be flushed on MSR[HV] 1->0 transition (hyperv=
isor to guest)=0A=
>>> +#define SEC_FTR_L1D_FLUSH_HV		0x0000000000000040ull=0A=
>>> +=0A=
>>> +// The L1-D cache should be flushed on MSR[PR] 0->1 transition (kernel=
 to userspace)=0A=
>>> +#define SEC_FTR_L1D_FLUSH_PR		0x0000000000000080ull=0A=
>>> +=0A=
>>> +// A speculation barrier should be used for bounds checks (Spectre var=
iant 1)=0A=
>>> +#define SEC_FTR_BNDS_CHK_SPEC_BAR	0x0000000000000100ull=0A=
>>> +=0A=
>>> +// Firmware configuration indicates user favours security over perform=
ance=0A=
>>> +#define SEC_FTR_FAVOUR_SECURITY		0x0000000000000200ull=0A=
>>> +=0A=
>>> +// Software required to flush count cache on context switch=0A=
>>> +#define SEC_FTR_FLUSH_COUNT_CACHE	0x0000000000000400ull=0A=
>>> +=0A=
>>> +=0A=
>>> +// Features enabled by default=0A=
>>> +#define SEC_FTR_DEFAULT \=0A=
>>> +	(SEC_FTR_L1D_FLUSH_HV | \=0A=
>>> +	 SEC_FTR_L1D_FLUSH_PR | \=0A=
>>> +	 SEC_FTR_BNDS_CHK_SPEC_BAR | \=0A=
>>> +	 SEC_FTR_FAVOUR_SECURITY)=0A=
>>> +=0A=
>>> +#endif /* _ASM_POWERPC_SECURITY_FEATURES_H */=0A=
>>> diff --git a/arch/powerpc/include/asm/setup.h b/arch/powerpc/include/as=
m/setup.h=0A=
>>> index 7916b56f2e60..d299479c770b 100644=0A=
>>> - --- a/arch/powerpc/include/asm/setup.h=0A=
>>> +++ b/arch/powerpc/include/asm/setup.h=0A=
>>> @@ -8,6 +8,7 @@ extern void ppc_printk_progress(char *s, unsigned short=
 hex);=0A=
>>>  =0A=
>>>  extern unsigned int rtas_data;=0A=
>>>  extern unsigned long long memory_limit;=0A=
>>> +extern bool init_mem_is_free;=0A=
>>>  extern unsigned long klimit;=0A=
>>>  extern void *zalloc_maybe_bootmem(size_t size, gfp_t mask);=0A=
>>>  =0A=
>>> @@ -36,8 +37,28 @@ enum l1d_flush_type {=0A=
>>>  	L1D_FLUSH_MTTRIG	=3D 0x8,=0A=
>>>  };=0A=
>>>  =0A=
>>> - -void __init setup_rfi_flush(enum l1d_flush_type, bool enable);=0A=
>>> +void setup_rfi_flush(enum l1d_flush_type, bool enable);=0A=
>>>  void do_rfi_flush_fixups(enum l1d_flush_type types);=0A=
>>> +#ifdef CONFIG_PPC_BARRIER_NOSPEC=0A=
>>> +void setup_barrier_nospec(void);=0A=
>>> +#else=0A=
>>> +static inline void setup_barrier_nospec(void) { };=0A=
>>> +#endif=0A=
>>> +void do_barrier_nospec_fixups(bool enable);=0A=
>>> +extern bool barrier_nospec_enabled;=0A=
>>> +=0A=
>>> +#ifdef CONFIG_PPC_BARRIER_NOSPEC=0A=
>>> +void do_barrier_nospec_fixups_range(bool enable, void *start, void *en=
d);=0A=
>>> +#else=0A=
>>> +static inline void do_barrier_nospec_fixups_range(bool enable, void *s=
tart, void *end) { };=0A=
>>> +#endif=0A=
>>> +=0A=
>>> +#ifdef CONFIG_PPC_FSL_BOOK3E=0A=
>>> +void setup_spectre_v2(void);=0A=
>>> +#else=0A=
>>> +static inline void setup_spectre_v2(void) {};=0A=
>>> +#endif=0A=
>>> +void do_btb_flush_fixups(void);=0A=
>>>  =0A=
>>>  #endif /* !__ASSEMBLY__ */=0A=
>>>  =0A=
>>> diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/=
asm/uaccess.h=0A=
>>> index 05f1389228d2..e51ce5a0e221 100644=0A=
>>> - --- a/arch/powerpc/include/asm/uaccess.h=0A=
>>> +++ b/arch/powerpc/include/asm/uaccess.h=0A=
>>> @@ -269,6 +269,7 @@ do {								\=0A=
>>>  	__chk_user_ptr(ptr);					\=0A=
>>>  	if (!is_kernel_addr((unsigned long)__gu_addr))		\=0A=
>>>  		might_fault();					\=0A=
>>> +	barrier_nospec();					\=0A=
>>>  	__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\=0A=
>>>  	(x) =3D (__typeof__(*(ptr)))__gu_val;			\=0A=
>>>  	__gu_err;						\=0A=
>>> @@ -283,6 +284,7 @@ do {								\=0A=
>>>  	__chk_user_ptr(ptr);					\=0A=
>>>  	if (!is_kernel_addr((unsigned long)__gu_addr))		\=0A=
>>>  		might_fault();					\=0A=
>>> +	barrier_nospec();					\=0A=
>>>  	__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\=0A=
>>>  	(x) =3D (__force __typeof__(*(ptr)))__gu_val;			\=0A=
>>>  	__gu_err;						\=0A=
>>> @@ -295,8 +297,10 @@ do {								\=0A=
>>>  	unsigned long  __gu_val =3D 0;					\=0A=
>>>  	__typeof__(*(ptr)) __user *__gu_addr =3D (ptr);		\=0A=
>>>  	might_fault();							\=0A=
>>> - -	if (access_ok(VERIFY_READ, __gu_addr, (size)))			\=0A=
>>> +	if (access_ok(VERIFY_READ, __gu_addr, (size))) {		\=0A=
>>> +		barrier_nospec();					\=0A=
>>>  		__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\=0A=
>>> +	}								\=0A=
>>>  	(x) =3D (__force __typeof__(*(ptr)))__gu_val;				\=0A=
>>>  	__gu_err;							\=0A=
>>>  })=0A=
>>> @@ -307,6 +311,7 @@ do {								\=0A=
>>>  	unsigned long __gu_val;					\=0A=
>>>  	__typeof__(*(ptr)) __user *__gu_addr =3D (ptr);	\=0A=
>>>  	__chk_user_ptr(ptr);					\=0A=
>>> +	barrier_nospec();					\=0A=
>>>  	__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\=0A=
>>>  	(x) =3D (__force __typeof__(*(ptr)))__gu_val;			\=0A=
>>>  	__gu_err;						\=0A=
>>> @@ -323,8 +328,10 @@ extern unsigned long __copy_tofrom_user(void __use=
r *to,=0A=
>>>  static inline unsigned long copy_from_user(void *to,=0A=
>>>  		const void __user *from, unsigned long n)=0A=
>>>  {=0A=
>>> - -	if (likely(access_ok(VERIFY_READ, from, n)))=0A=
>>> +	if (likely(access_ok(VERIFY_READ, from, n))) {=0A=
>>> +		barrier_nospec();=0A=
>>>  		return __copy_tofrom_user((__force void __user *)to, from, n);=0A=
>>> +	}=0A=
>>>  	memset(to, 0, n);=0A=
>>>  	return n;=0A=
>>>  }=0A=
>>> @@ -359,21 +366,27 @@ static inline unsigned long __copy_from_user_inat=
omic(void *to,=0A=
>>>  =0A=
>>>  		switch (n) {=0A=
>>>  		case 1:=0A=
>>> +			barrier_nospec();=0A=
>>>  			__get_user_size(*(u8 *)to, from, 1, ret);=0A=
>>>  			break;=0A=
>>>  		case 2:=0A=
>>> +			barrier_nospec();=0A=
>>>  			__get_user_size(*(u16 *)to, from, 2, ret);=0A=
>>>  			break;=0A=
>>>  		case 4:=0A=
>>> +			barrier_nospec();=0A=
>>>  			__get_user_size(*(u32 *)to, from, 4, ret);=0A=
>>>  			break;=0A=
>>>  		case 8:=0A=
>>> +			barrier_nospec();=0A=
>>>  			__get_user_size(*(u64 *)to, from, 8, ret);=0A=
>>>  			break;=0A=
>>>  		}=0A=
>>>  		if (ret =3D=3D 0)=0A=
>>>  			return 0;=0A=
>>>  	}=0A=
>>> +=0A=
>>> +	barrier_nospec();=0A=
>>>  	return __copy_tofrom_user((__force void __user *)to, from, n);=0A=
>>>  }=0A=
>>>  =0A=
>>> @@ -400,6 +413,7 @@ static inline unsigned long __copy_to_user_inatomic=
(void __user *to,=0A=
>>>  		if (ret =3D=3D 0)=0A=
>>>  			return 0;=0A=
>>>  	}=0A=
>>> +=0A=
>>>  	return __copy_tofrom_user(to, (__force const void __user *)from, n);=
=0A=
>>>  }=0A=
>>>  =0A=
>>> diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefil=
e=0A=
>>> index ba336930d448..22ed3c32fca8 100644=0A=
>>> - --- a/arch/powerpc/kernel/Makefile=0A=
>>> +++ b/arch/powerpc/kernel/Makefile=0A=
>>> @@ -44,6 +44,7 @@ obj-$(CONFIG_PPC_BOOK3S_64)	+=3D cpu_setup_power.o=0A=
>>>  obj-$(CONFIG_PPC_BOOK3S_64)	+=3D mce.o mce_power.o=0A=
>>>  obj64-$(CONFIG_RELOCATABLE)	+=3D reloc_64.o=0A=
>>>  obj-$(CONFIG_PPC_BOOK3E_64)	+=3D exceptions-64e.o idle_book3e.o=0A=
>>> +obj-$(CONFIG_PPC_BARRIER_NOSPEC) +=3D security.o=0A=
>>>  obj-$(CONFIG_PPC64)		+=3D vdso64/=0A=
>>>  obj-$(CONFIG_ALTIVEC)		+=3D vecemu.o=0A=
>>>  obj-$(CONFIG_PPC_970_NAP)	+=3D idle_power4.o=0A=
>>> diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/as=
m-offsets.c=0A=
>>> index d92705e3a0c1..de3c29c51503 100644=0A=
>>> - --- a/arch/powerpc/kernel/asm-offsets.c=0A=
>>> +++ b/arch/powerpc/kernel/asm-offsets.c=0A=
>>> @@ -245,8 +245,7 @@ int main(void)=0A=
>>>  	DEFINE(PACA_IN_MCE, offsetof(struct paca_struct, in_mce));=0A=
>>>  	DEFINE(PACA_RFI_FLUSH_FALLBACK_AREA, offsetof(struct paca_struct, rfi=
_flush_fallback_area));=0A=
>>>  	DEFINE(PACA_EXRFI, offsetof(struct paca_struct, exrfi));=0A=
>>> - -	DEFINE(PACA_L1D_FLUSH_CONGRUENCE, offsetof(struct paca_struct, l1d_=
flush_congruence));=0A=
>>> - -	DEFINE(PACA_L1D_FLUSH_SETS, offsetof(struct paca_struct, l1d_flush_=
sets));=0A=
>>> +	DEFINE(PACA_L1D_FLUSH_SIZE, offsetof(struct paca_struct, l1d_flush_si=
ze));=0A=
>>>  #endif=0A=
>>>  	DEFINE(PACAHWCPUID, offsetof(struct paca_struct, hw_cpu_id));=0A=
>>>  	DEFINE(PACAKEXECSTATE, offsetof(struct paca_struct, kexec_state));=0A=
>>> diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry=
_64.S=0A=
>>> index 59be96917369..6d36a4fb4acf 100644=0A=
>>> - --- a/arch/powerpc/kernel/entry_64.S=0A=
>>> +++ b/arch/powerpc/kernel/entry_64.S=0A=
>>> @@ -25,6 +25,7 @@=0A=
>>>  #include <asm/page.h>=0A=
>>>  #include <asm/mmu.h>=0A=
>>>  #include <asm/thread_info.h>=0A=
>>> +#include <asm/code-patching-asm.h>=0A=
>>>  #include <asm/ppc_asm.h>=0A=
>>>  #include <asm/asm-offsets.h>=0A=
>>>  #include <asm/cputable.h>=0A=
>>> @@ -36,6 +37,7 @@=0A=
>>>  #include <asm/hw_irq.h>=0A=
>>>  #include <asm/context_tracking.h>=0A=
>>>  #include <asm/tm.h>=0A=
>>> +#include <asm/barrier.h>=0A=
>>>  #ifdef CONFIG_PPC_BOOK3S=0A=
>>>  #include <asm/exception-64s.h>=0A=
>>>  #else=0A=
>>> @@ -75,6 +77,11 @@ END_FTR_SECTION_IFSET(CPU_FTR_TM)=0A=
>>>  	std	r0,GPR0(r1)=0A=
>>>  	std	r10,GPR1(r1)=0A=
>>>  	beq	2f			/* if from kernel mode */=0A=
>>> +#ifdef CONFIG_PPC_FSL_BOOK3E=0A=
>>> +START_BTB_FLUSH_SECTION=0A=
>>> +	BTB_FLUSH(r10)=0A=
>>> +END_BTB_FLUSH_SECTION=0A=
>>> +#endif=0A=
>>>  	ACCOUNT_CPU_USER_ENTRY(r10, r11)=0A=
>>>  2:	std	r2,GPR2(r1)=0A=
>>>  	std	r3,GPR3(r1)=0A=
>>> @@ -177,6 +184,15 @@ system_call:			/* label this so stack traces look =
sane */=0A=
>>>  	clrldi	r8,r8,32=0A=
>>>  15:=0A=
>>>  	slwi	r0,r0,4=0A=
>>> +=0A=
>>> +	barrier_nospec_asm=0A=
>>> +	/*=0A=
>>> +	 * Prevent the load of the handler below (based on the user-passed=0A=
>>> +	 * system call number) being speculatively executed until the test=0A=
>>> +	 * against NR_syscalls and branch to .Lsyscall_enosys above has=0A=
>>> +	 * committed.=0A=
>>> +	 */=0A=
>>> +=0A=
>>>  	ldx	r12,r11,r0	/* Fetch system call handler [ptr] */=0A=
>>>  	mtctr   r12=0A=
>>>  	bctrl			/* Call handler */=0A=
>>> @@ -440,6 +456,57 @@ _GLOBAL(ret_from_kernel_thread)=0A=
>>>  	li	r3,0=0A=
>>>  	b	.Lsyscall_exit=0A=
>>>  =0A=
>>> +#ifdef CONFIG_PPC_BOOK3S_64=0A=
>>> +=0A=
>>> +#define FLUSH_COUNT_CACHE	\=0A=
>>> +1:	nop;			\=0A=
>>> +	patch_site 1b, patch__call_flush_count_cache=0A=
>>> +=0A=
>>> +=0A=
>>> +#define BCCTR_FLUSH	.long 0x4c400420=0A=
>>> +=0A=
>>> +.macro nops number=0A=
>>> +	.rept \number=0A=
>>> +	nop=0A=
>>> +	.endr=0A=
>>> +.endm=0A=
>>> +=0A=
>>> +.balign 32=0A=
>>> +.global flush_count_cache=0A=
>>> +flush_count_cache:=0A=
>>> +	/* Save LR into r9 */=0A=
>>> +	mflr	r9=0A=
>>> +=0A=
>>> +	.rept 64=0A=
>>> +	bl	.+4=0A=
>>> +	.endr=0A=
>>> +	b	1f=0A=
>>> +	nops	6=0A=
>>> +=0A=
>>> +	.balign 32=0A=
>>> +	/* Restore LR */=0A=
>>> +1:	mtlr	r9=0A=
>>> +	li	r9,0x7fff=0A=
>>> +	mtctr	r9=0A=
>>> +=0A=
>>> +	BCCTR_FLUSH=0A=
>>> +=0A=
>>> +2:	nop=0A=
>>> +	patch_site 2b patch__flush_count_cache_return=0A=
>>> +=0A=
>>> +	nops	3=0A=
>>> +=0A=
>>> +	.rept 278=0A=
>>> +	.balign 32=0A=
>>> +	BCCTR_FLUSH=0A=
>>> +	nops	7=0A=
>>> +	.endr=0A=
>>> +=0A=
>>> +	blr=0A=
>>> +#else=0A=
>>> +#define FLUSH_COUNT_CACHE=0A=
>>> +#endif /* CONFIG_PPC_BOOK3S_64 */=0A=
>>> +=0A=
>>>  /*=0A=
>>>   * This routine switches between two different tasks.  The process=0A=
>>>   * state of one is saved on its kernel stack.  Then the state=0A=
>>> @@ -503,6 +570,8 @@ BEGIN_FTR_SECTION=0A=
>>>  END_FTR_SECTION_IFSET(CPU_FTR_ARCH_207S)=0A=
>>>  #endif=0A=
>>>  =0A=
>>> +	FLUSH_COUNT_CACHE=0A=
>>> +=0A=
>>>  #ifdef CONFIG_SMP=0A=
>>>  	/* We need a sync somewhere here to make sure that if the=0A=
>>>  	 * previous task gets rescheduled on another CPU, it sees all=0A=
>>> diff --git a/arch/powerpc/kernel/exceptions-64e.S b/arch/powerpc/kernel=
/exceptions-64e.S=0A=
>>> index 5cc93f0b52ca..48ec841ea1bf 100644=0A=
>>> - --- a/arch/powerpc/kernel/exceptions-64e.S=0A=
>>> +++ b/arch/powerpc/kernel/exceptions-64e.S=0A=
>>> @@ -295,7 +295,8 @@ END_FTR_SECTION_IFSET(CPU_FTR_EMB_HV)=0A=
>>>  	andi.	r10,r11,MSR_PR;		/* save stack pointer */	    \=0A=
>>>  	beq	1f;			/* branch around if supervisor */   \=0A=
>>>  	ld	r1,PACAKSAVE(r13);	/* get kernel stack coming from usr */\=0A=
>>> - -1:	cmpdi	cr1,r1,0;		/* check if SP makes sense */	    \=0A=
>>> +1:	type##_BTB_FLUSH		\=0A=
>>> +	cmpdi	cr1,r1,0;		/* check if SP makes sense */	    \=0A=
>>>  	bge-	cr1,exc_##n##_bad_stack;/* bad stack (TODO: out of line) */ \=0A=
>>>  	mfspr	r10,SPRN_##type##_SRR0;	/* read SRR0 before touching stack */=
=0A=
>>>  =0A=
>>> @@ -327,6 +328,30 @@ END_FTR_SECTION_IFSET(CPU_FTR_EMB_HV)=0A=
>>>  #define SPRN_MC_SRR0	SPRN_MCSRR0=0A=
>>>  #define SPRN_MC_SRR1	SPRN_MCSRR1=0A=
>>>  =0A=
>>> +#ifdef CONFIG_PPC_FSL_BOOK3E=0A=
>>> +#define GEN_BTB_FLUSH			\=0A=
>>> +	START_BTB_FLUSH_SECTION		\=0A=
>>> +		beq 1f;			\=0A=
>>> +		BTB_FLUSH(r10)			\=0A=
>>> +		1:		\=0A=
>>> +	END_BTB_FLUSH_SECTION=0A=
>>> +=0A=
>>> +#define CRIT_BTB_FLUSH			\=0A=
>>> +	START_BTB_FLUSH_SECTION		\=0A=
>>> +		BTB_FLUSH(r10)		\=0A=
>>> +	END_BTB_FLUSH_SECTION=0A=
>>> +=0A=
>>> +#define DBG_BTB_FLUSH CRIT_BTB_FLUSH=0A=
>>> +#define MC_BTB_FLUSH CRIT_BTB_FLUSH=0A=
>>> +#define GDBELL_BTB_FLUSH GEN_BTB_FLUSH=0A=
>>> +#else=0A=
>>> +#define GEN_BTB_FLUSH=0A=
>>> +#define CRIT_BTB_FLUSH=0A=
>>> +#define DBG_BTB_FLUSH=0A=
>>> +#define MC_BTB_FLUSH=0A=
>>> +#define GDBELL_BTB_FLUSH=0A=
>>> +#endif=0A=
>>> +=0A=
>>>  #define NORMAL_EXCEPTION_PROLOG(n, intnum, addition)			    \=0A=
>>>  	EXCEPTION_PROLOG(n, intnum, GEN, addition##_GEN(n))=0A=
>>>  =0A=
>>> diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel=
/exceptions-64s.S=0A=
>>> index 938a30fef031..10e7cec9553d 100644=0A=
>>> - --- a/arch/powerpc/kernel/exceptions-64s.S=0A=
>>> +++ b/arch/powerpc/kernel/exceptions-64s.S=0A=
>>> @@ -36,6 +36,7 @@ BEGIN_FTR_SECTION						\=0A=
>>>  END_FTR_SECTION_IFSET(CPU_FTR_REAL_LE)				\=0A=
>>>  	mr	r9,r13 ;					\=0A=
>>>  	GET_PACA(r13) ;						\=0A=
>>> +	INTERRUPT_TO_KERNEL ;					\=0A=
>>>  	mfspr	r11,SPRN_SRR0 ;					\=0A=
>>>  0:=0A=
>>>  =0A=
>>> @@ -292,7 +293,9 @@ ALT_FTR_SECTION_END_IFSET(CPU_FTR_HVMODE)=0A=
>>>  	. =3D 0x900=0A=
>>>  	.globl decrementer_pSeries=0A=
>>>  decrementer_pSeries:=0A=
>>> - -	_MASKABLE_EXCEPTION_PSERIES(0x900, decrementer, EXC_STD, SOFTEN_TES=
T_PR)=0A=
>>> +	SET_SCRATCH0(r13)=0A=
>>> +	EXCEPTION_PROLOG_0(PACA_EXGEN)=0A=
>>> +	b	decrementer_ool=0A=
>>>  =0A=
>>>  	STD_EXCEPTION_HV(0x980, 0x982, hdecrementer)=0A=
>>>  =0A=
>>> @@ -319,6 +322,7 @@ ALT_FTR_SECTION_END_IFSET(CPU_FTR_HVMODE)=0A=
>>>  	OPT_GET_SPR(r9, SPRN_PPR, CPU_FTR_HAS_PPR);=0A=
>>>  	HMT_MEDIUM;=0A=
>>>  	std	r10,PACA_EXGEN+EX_R10(r13)=0A=
>>> +	INTERRUPT_TO_KERNEL=0A=
>>>  	OPT_SAVE_REG_TO_PACA(PACA_EXGEN+EX_PPR, r9, CPU_FTR_HAS_PPR);=0A=
>>>  	mfcr	r9=0A=
>>>  	KVMTEST(0xc00)=0A=
>>> @@ -607,6 +611,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_CFAR)=0A=
>>>  =0A=
>>>  	.align	7=0A=
>>>  	/* moved from 0xe00 */=0A=
>>> +	MASKABLE_EXCEPTION_OOL(0x900, decrementer)=0A=
>>>  	STD_EXCEPTION_HV_OOL(0xe02, h_data_storage)=0A=
>>>  	KVM_HANDLER_SKIP(PACA_EXGEN, EXC_HV, 0xe02)=0A=
>>>  	STD_EXCEPTION_HV_OOL(0xe22, h_instr_storage)=0A=
>>> @@ -1564,6 +1569,21 @@ END_FTR_SECTION_IFSET(CPU_FTR_VSX)=0A=
>>>  	blr=0A=
>>>  #endif=0A=
>>>  =0A=
>>> +	.balign 16=0A=
>>> +	.globl stf_barrier_fallback=0A=
>>> +stf_barrier_fallback:=0A=
>>> +	std	r9,PACA_EXRFI+EX_R9(r13)=0A=
>>> +	std	r10,PACA_EXRFI+EX_R10(r13)=0A=
>>> +	sync=0A=
>>> +	ld	r9,PACA_EXRFI+EX_R9(r13)=0A=
>>> +	ld	r10,PACA_EXRFI+EX_R10(r13)=0A=
>>> +	ori	31,31,0=0A=
>>> +	.rept 14=0A=
>>> +	b	1f=0A=
>>> +1:=0A=
>>> +	.endr=0A=
>>> +	blr=0A=
>>> +=0A=
>>>  	.globl rfi_flush_fallback=0A=
>>>  rfi_flush_fallback:=0A=
>>>  	SET_SCRATCH0(r13);=0A=
>>> @@ -1571,39 +1591,37 @@ END_FTR_SECTION_IFSET(CPU_FTR_VSX)=0A=
>>>  	std	r9,PACA_EXRFI+EX_R9(r13)=0A=
>>>  	std	r10,PACA_EXRFI+EX_R10(r13)=0A=
>>>  	std	r11,PACA_EXRFI+EX_R11(r13)=0A=
>>> - -	std	r12,PACA_EXRFI+EX_R12(r13)=0A=
>>> - -	std	r8,PACA_EXRFI+EX_R13(r13)=0A=
>>>  	mfctr	r9=0A=
>>>  	ld	r10,PACA_RFI_FLUSH_FALLBACK_AREA(r13)=0A=
>>> - -	ld	r11,PACA_L1D_FLUSH_SETS(r13)=0A=
>>> - -	ld	r12,PACA_L1D_FLUSH_CONGRUENCE(r13)=0A=
>>> - -	/*=0A=
>>> - -	 * The load adresses are at staggered offsets within cachelines,=0A=
>>> - -	 * which suits some pipelines better (on others it should not=0A=
>>> - -	 * hurt).=0A=
>>> - -	 */=0A=
>>> - -	addi	r12,r12,8=0A=
>>> +	ld	r11,PACA_L1D_FLUSH_SIZE(r13)=0A=
>>> +	srdi	r11,r11,(7 + 3) /* 128 byte lines, unrolled 8x */=0A=
>>>  	mtctr	r11=0A=
>>>  	DCBT_STOP_ALL_STREAM_IDS(r11) /* Stop prefetch streams */=0A=
>>>  =0A=
>>>  	/* order ld/st prior to dcbt stop all streams with flushing */=0A=
>>>  	sync=0A=
>>> - -1:	li	r8,0=0A=
>>> - -	.rept	8 /* 8-way set associative */=0A=
>>> - -	ldx	r11,r10,r8=0A=
>>> - -	add	r8,r8,r12=0A=
>>> - -	xor	r11,r11,r11	// Ensure r11 is 0 even if fallback area is not=0A=
>>> - -	add	r8,r8,r11	// Add 0, this creates a dependency on the ldx=0A=
>>> - -	.endr=0A=
>>> - -	addi	r10,r10,128 /* 128 byte cache line */=0A=
>>> +=0A=
>>> +	/*=0A=
>>> +	 * The load adresses are at staggered offsets within cachelines,=0A=
>>> +	 * which suits some pipelines better (on others it should not=0A=
>>> +	 * hurt).=0A=
>>> +	 */=0A=
>>> +1:=0A=
>>> +	ld	r11,(0x80 + 8)*0(r10)=0A=
>>> +	ld	r11,(0x80 + 8)*1(r10)=0A=
>>> +	ld	r11,(0x80 + 8)*2(r10)=0A=
>>> +	ld	r11,(0x80 + 8)*3(r10)=0A=
>>> +	ld	r11,(0x80 + 8)*4(r10)=0A=
>>> +	ld	r11,(0x80 + 8)*5(r10)=0A=
>>> +	ld	r11,(0x80 + 8)*6(r10)=0A=
>>> +	ld	r11,(0x80 + 8)*7(r10)=0A=
>>> +	addi	r10,r10,0x80*8=0A=
>>>  	bdnz	1b=0A=
>>>  =0A=
>>>  	mtctr	r9=0A=
>>>  	ld	r9,PACA_EXRFI+EX_R9(r13)=0A=
>>>  	ld	r10,PACA_EXRFI+EX_R10(r13)=0A=
>>>  	ld	r11,PACA_EXRFI+EX_R11(r13)=0A=
>>> - -	ld	r12,PACA_EXRFI+EX_R12(r13)=0A=
>>> - -	ld	r8,PACA_EXRFI+EX_R13(r13)=0A=
>>>  	GET_SCRATCH0(r13);=0A=
>>>  	rfid=0A=
>>>  =0A=
>>> @@ -1614,39 +1632,37 @@ END_FTR_SECTION_IFSET(CPU_FTR_VSX)=0A=
>>>  	std	r9,PACA_EXRFI+EX_R9(r13)=0A=
>>>  	std	r10,PACA_EXRFI+EX_R10(r13)=0A=
>>>  	std	r11,PACA_EXRFI+EX_R11(r13)=0A=
>>> - -	std	r12,PACA_EXRFI+EX_R12(r13)=0A=
>>> - -	std	r8,PACA_EXRFI+EX_R13(r13)=0A=
>>>  	mfctr	r9=0A=
>>>  	ld	r10,PACA_RFI_FLUSH_FALLBACK_AREA(r13)=0A=
>>> - -	ld	r11,PACA_L1D_FLUSH_SETS(r13)=0A=
>>> - -	ld	r12,PACA_L1D_FLUSH_CONGRUENCE(r13)=0A=
>>> - -	/*=0A=
>>> - -	 * The load adresses are at staggered offsets within cachelines,=0A=
>>> - -	 * which suits some pipelines better (on others it should not=0A=
>>> - -	 * hurt).=0A=
>>> - -	 */=0A=
>>> - -	addi	r12,r12,8=0A=
>>> +	ld	r11,PACA_L1D_FLUSH_SIZE(r13)=0A=
>>> +	srdi	r11,r11,(7 + 3) /* 128 byte lines, unrolled 8x */=0A=
>>>  	mtctr	r11=0A=
>>>  	DCBT_STOP_ALL_STREAM_IDS(r11) /* Stop prefetch streams */=0A=
>>>  =0A=
>>>  	/* order ld/st prior to dcbt stop all streams with flushing */=0A=
>>>  	sync=0A=
>>> - -1:	li	r8,0=0A=
>>> - -	.rept	8 /* 8-way set associative */=0A=
>>> - -	ldx	r11,r10,r8=0A=
>>> - -	add	r8,r8,r12=0A=
>>> - -	xor	r11,r11,r11	// Ensure r11 is 0 even if fallback area is not=0A=
>>> - -	add	r8,r8,r11	// Add 0, this creates a dependency on the ldx=0A=
>>> - -	.endr=0A=
>>> - -	addi	r10,r10,128 /* 128 byte cache line */=0A=
>>> +=0A=
>>> +	/*=0A=
>>> +	 * The load adresses are at staggered offsets within cachelines,=0A=
>>> +	 * which suits some pipelines better (on others it should not=0A=
>>> +	 * hurt).=0A=
>>> +	 */=0A=
>>> +1:=0A=
>>> +	ld	r11,(0x80 + 8)*0(r10)=0A=
>>> +	ld	r11,(0x80 + 8)*1(r10)=0A=
>>> +	ld	r11,(0x80 + 8)*2(r10)=0A=
>>> +	ld	r11,(0x80 + 8)*3(r10)=0A=
>>> +	ld	r11,(0x80 + 8)*4(r10)=0A=
>>> +	ld	r11,(0x80 + 8)*5(r10)=0A=
>>> +	ld	r11,(0x80 + 8)*6(r10)=0A=
>>> +	ld	r11,(0x80 + 8)*7(r10)=0A=
>>> +	addi	r10,r10,0x80*8=0A=
>>>  	bdnz	1b=0A=
>>>  =0A=
>>>  	mtctr	r9=0A=
>>>  	ld	r9,PACA_EXRFI+EX_R9(r13)=0A=
>>>  	ld	r10,PACA_EXRFI+EX_R10(r13)=0A=
>>>  	ld	r11,PACA_EXRFI+EX_R11(r13)=0A=
>>> - -	ld	r12,PACA_EXRFI+EX_R12(r13)=0A=
>>> - -	ld	r8,PACA_EXRFI+EX_R13(r13)=0A=
>>>  	GET_SCRATCH0(r13);=0A=
>>>  	hrfid=0A=
>>>  =0A=
>>> diff --git a/arch/powerpc/kernel/module.c b/arch/powerpc/kernel/module.=
c=0A=
>>> index 9547381b631a..ff009be97a42 100644=0A=
>>> - --- a/arch/powerpc/kernel/module.c=0A=
>>> +++ b/arch/powerpc/kernel/module.c=0A=
>>> @@ -67,7 +67,15 @@ int module_finalize(const Elf_Ehdr *hdr,=0A=
>>>  		do_feature_fixups(powerpc_firmware_features,=0A=
>>>  				  (void *)sect->sh_addr,=0A=
>>>  				  (void *)sect->sh_addr + sect->sh_size);=0A=
>>> - -#endif=0A=
>>> +#endif /* CONFIG_PPC64 */=0A=
>>> +=0A=
>>> +#ifdef CONFIG_PPC_BARRIER_NOSPEC=0A=
>>> +	sect =3D find_section(hdr, sechdrs, "__spec_barrier_fixup");=0A=
>>> +	if (sect !=3D NULL)=0A=
>>> +		do_barrier_nospec_fixups_range(barrier_nospec_enabled,=0A=
>>> +				  (void *)sect->sh_addr,=0A=
>>> +				  (void *)sect->sh_addr + sect->sh_size);=0A=
>>> +#endif /* CONFIG_PPC_BARRIER_NOSPEC */=0A=
>>>  =0A=
>>>  	sect =3D find_section(hdr, sechdrs, "__lwsync_fixup");=0A=
>>>  	if (sect !=3D NULL)=0A=
>>> diff --git a/arch/powerpc/kernel/security.c b/arch/powerpc/kernel/secur=
ity.c=0A=
>>> new file mode 100644=0A=
>>> index 000000000000..58f0602a92b9=0A=
>>> - --- /dev/null=0A=
>>> +++ b/arch/powerpc/kernel/security.c=0A=
>>> @@ -0,0 +1,433 @@=0A=
>>> +// SPDX-License-Identifier: GPL-2.0+=0A=
>>> +//=0A=
>>> +// Security related flags and so on.=0A=
>>> +//=0A=
>>> +// Copyright 2018, Michael Ellerman, IBM Corporation.=0A=
>>> +=0A=
>>> +#include <linux/kernel.h>=0A=
>>> +#include <linux/debugfs.h>=0A=
>>> +#include <linux/device.h>=0A=
>>> +#include <linux/seq_buf.h>=0A=
>>> +=0A=
>>> +#include <asm/debug.h>=0A=
>>> +#include <asm/asm-prototypes.h>=0A=
>>> +#include <asm/code-patching.h>=0A=
>>> +#include <asm/security_features.h>=0A=
>>> +#include <asm/setup.h>=0A=
>>> +=0A=
>>> +=0A=
>>> +unsigned long powerpc_security_features __read_mostly =3D SEC_FTR_DEFA=
ULT;=0A=
>>> +=0A=
>>> +enum count_cache_flush_type {=0A=
>>> +	COUNT_CACHE_FLUSH_NONE	=3D 0x1,=0A=
>>> +	COUNT_CACHE_FLUSH_SW	=3D 0x2,=0A=
>>> +	COUNT_CACHE_FLUSH_HW	=3D 0x4,=0A=
>>> +};=0A=
>>> +static enum count_cache_flush_type count_cache_flush_type =3D COUNT_CA=
CHE_FLUSH_NONE;=0A=
>>> +=0A=
>>> +bool barrier_nospec_enabled;=0A=
>>> +static bool no_nospec;=0A=
>>> +static bool btb_flush_enabled;=0A=
>>> +#ifdef CONFIG_PPC_FSL_BOOK3E=0A=
>>> +static bool no_spectrev2;=0A=
>>> +#endif=0A=
>>> +=0A=
>>> +static void enable_barrier_nospec(bool enable)=0A=
>>> +{=0A=
>>> +	barrier_nospec_enabled =3D enable;=0A=
>>> +	do_barrier_nospec_fixups(enable);=0A=
>>> +}=0A=
>>> +=0A=
>>> +void setup_barrier_nospec(void)=0A=
>>> +{=0A=
>>> +	bool enable;=0A=
>>> +=0A=
>>> +	/*=0A=
>>> +	 * It would make sense to check SEC_FTR_SPEC_BAR_ORI31 below as well.=
=0A=
>>> +	 * But there's a good reason not to. The two flags we check below are=
=0A=
>>> +	 * both are enabled by default in the kernel, so if the hcall is not=
=0A=
>>> +	 * functional they will be enabled.=0A=
>>> +	 * On a system where the host firmware has been updated (so the ori=
=0A=
>>> +	 * functions as a barrier), but on which the hypervisor (KVM/Qemu) ha=
s=0A=
>>> +	 * not been updated, we would like to enable the barrier. Dropping th=
e=0A=
>>> +	 * check for SEC_FTR_SPEC_BAR_ORI31 achieves that. The only downside =
is=0A=
>>> +	 * we potentially enable the barrier on systems where the host firmwa=
re=0A=
>>> +	 * is not updated, but that's harmless as it's a no-op.=0A=
>>> +	 */=0A=
>>> +	enable =3D security_ftr_enabled(SEC_FTR_FAVOUR_SECURITY) &&=0A=
>>> +		 security_ftr_enabled(SEC_FTR_BNDS_CHK_SPEC_BAR);=0A=
>>> +=0A=
>>> +	if (!no_nospec)=0A=
>>> +		enable_barrier_nospec(enable);=0A=
>>> +}=0A=
>>> +=0A=
>>> +static int __init handle_nospectre_v1(char *p)=0A=
>>> +{=0A=
>>> +	no_nospec =3D true;=0A=
>>> +=0A=
>>> +	return 0;=0A=
>>> +}=0A=
>>> +early_param("nospectre_v1", handle_nospectre_v1);=0A=
>>> +=0A=
>>> +#ifdef CONFIG_DEBUG_FS=0A=
>>> +static int barrier_nospec_set(void *data, u64 val)=0A=
>>> +{=0A=
>>> +	switch (val) {=0A=
>>> +	case 0:=0A=
>>> +	case 1:=0A=
>>> +		break;=0A=
>>> +	default:=0A=
>>> +		return -EINVAL;=0A=
>>> +	}=0A=
>>> +=0A=
>>> +	if (!!val =3D=3D !!barrier_nospec_enabled)=0A=
>>> +		return 0;=0A=
>>> +=0A=
>>> +	enable_barrier_nospec(!!val);=0A=
>>> +=0A=
>>> +	return 0;=0A=
>>> +}=0A=
>>> +=0A=
>>> +static int barrier_nospec_get(void *data, u64 *val)=0A=
>>> +{=0A=
>>> +	*val =3D barrier_nospec_enabled ? 1 : 0;=0A=
>>> +	return 0;=0A=
>>> +}=0A=
>>> +=0A=
>>> +DEFINE_SIMPLE_ATTRIBUTE(fops_barrier_nospec,=0A=
>>> +			barrier_nospec_get, barrier_nospec_set, "%llu\n");=0A=
>>> +=0A=
>>> +static __init int barrier_nospec_debugfs_init(void)=0A=
>>> +{=0A=
>>> +	debugfs_create_file("barrier_nospec", 0600, powerpc_debugfs_root, NUL=
L,=0A=
>>> +			    &fops_barrier_nospec);=0A=
>>> +	return 0;=0A=
>>> +}=0A=
>>> +device_initcall(barrier_nospec_debugfs_init);=0A=
>>> +#endif /* CONFIG_DEBUG_FS */=0A=
>>> +=0A=
>>> +#ifdef CONFIG_PPC_FSL_BOOK3E=0A=
>>> +static int __init handle_nospectre_v2(char *p)=0A=
>>> +{=0A=
>>> +	no_spectrev2 =3D true;=0A=
>>> +=0A=
>>> +	return 0;=0A=
>>> +}=0A=
>>> +early_param("nospectre_v2", handle_nospectre_v2);=0A=
>>> +void setup_spectre_v2(void)=0A=
>>> +{=0A=
>>> +	if (no_spectrev2)=0A=
>>> +		do_btb_flush_fixups();=0A=
>>> +	else=0A=
>>> +		btb_flush_enabled =3D true;=0A=
>>> +}=0A=
>>> +#endif /* CONFIG_PPC_FSL_BOOK3E */=0A=
>>> +=0A=
>>> +#ifdef CONFIG_PPC_BOOK3S_64=0A=
>>> +ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute =
*attr, char *buf)=0A=
>>> +{=0A=
>>> +	bool thread_priv;=0A=
>>> +=0A=
>>> +	thread_priv =3D security_ftr_enabled(SEC_FTR_L1D_THREAD_PRIV);=0A=
>>> +=0A=
>>> +	if (rfi_flush || thread_priv) {=0A=
>>> +		struct seq_buf s;=0A=
>>> +		seq_buf_init(&s, buf, PAGE_SIZE - 1);=0A=
>>> +=0A=
>>> +		seq_buf_printf(&s, "Mitigation: ");=0A=
>>> +=0A=
>>> +		if (rfi_flush)=0A=
>>> +			seq_buf_printf(&s, "RFI Flush");=0A=
>>> +=0A=
>>> +		if (rfi_flush && thread_priv)=0A=
>>> +			seq_buf_printf(&s, ", ");=0A=
>>> +=0A=
>>> +		if (thread_priv)=0A=
>>> +			seq_buf_printf(&s, "L1D private per thread");=0A=
>>> +=0A=
>>> +		seq_buf_printf(&s, "\n");=0A=
>>> +=0A=
>>> +		return s.len;=0A=
>>> +	}=0A=
>>> +=0A=
>>> +	if (!security_ftr_enabled(SEC_FTR_L1D_FLUSH_HV) &&=0A=
>>> +	    !security_ftr_enabled(SEC_FTR_L1D_FLUSH_PR))=0A=
>>> +		return sprintf(buf, "Not affected\n");=0A=
>>> +=0A=
>>> +	return sprintf(buf, "Vulnerable\n");=0A=
>>> +}=0A=
>>> +#endif=0A=
>>> +=0A=
>>> +ssize_t cpu_show_spectre_v1(struct device *dev, struct device_attribut=
e *attr, char *buf)=0A=
>>> +{=0A=
>>> +	struct seq_buf s;=0A=
>>> +=0A=
>>> +	seq_buf_init(&s, buf, PAGE_SIZE - 1);=0A=
>>> +=0A=
>>> +	if (security_ftr_enabled(SEC_FTR_BNDS_CHK_SPEC_BAR)) {=0A=
>>> +		if (barrier_nospec_enabled)=0A=
>>> +			seq_buf_printf(&s, "Mitigation: __user pointer sanitization");=0A=
>>> +		else=0A=
>>> +			seq_buf_printf(&s, "Vulnerable");=0A=
>>> +=0A=
>>> +		if (security_ftr_enabled(SEC_FTR_SPEC_BAR_ORI31))=0A=
>>> +			seq_buf_printf(&s, ", ori31 speculation barrier enabled");=0A=
>>> +=0A=
>>> +		seq_buf_printf(&s, "\n");=0A=
>>> +	} else=0A=
>>> +		seq_buf_printf(&s, "Not affected\n");=0A=
>>> +=0A=
>>> +	return s.len;=0A=
>>> +}=0A=
>>> +=0A=
>>> +ssize_t cpu_show_spectre_v2(struct device *dev, struct device_attribut=
e *attr, char *buf)=0A=
>>> +{=0A=
>>> +	struct seq_buf s;=0A=
>>> +	bool bcs, ccd;=0A=
>>> +=0A=
>>> +	seq_buf_init(&s, buf, PAGE_SIZE - 1);=0A=
>>> +=0A=
>>> +	bcs =3D security_ftr_enabled(SEC_FTR_BCCTRL_SERIALISED);=0A=
>>> +	ccd =3D security_ftr_enabled(SEC_FTR_COUNT_CACHE_DISABLED);=0A=
>>> +=0A=
>>> +	if (bcs || ccd) {=0A=
>>> +		seq_buf_printf(&s, "Mitigation: ");=0A=
>>> +=0A=
>>> +		if (bcs)=0A=
>>> +			seq_buf_printf(&s, "Indirect branch serialisation (kernel only)");=
=0A=
>>> +=0A=
>>> +		if (bcs && ccd)=0A=
>>> +			seq_buf_printf(&s, ", ");=0A=
>>> +=0A=
>>> +		if (ccd)=0A=
>>> +			seq_buf_printf(&s, "Indirect branch cache disabled");=0A=
>>> +	} else if (count_cache_flush_type !=3D COUNT_CACHE_FLUSH_NONE) {=0A=
>>> +		seq_buf_printf(&s, "Mitigation: Software count cache flush");=0A=
>>> +=0A=
>>> +		if (count_cache_flush_type =3D=3D COUNT_CACHE_FLUSH_HW)=0A=
>>> +			seq_buf_printf(&s, " (hardware accelerated)");=0A=
>>> +	} else if (btb_flush_enabled) {=0A=
>>> +		seq_buf_printf(&s, "Mitigation: Branch predictor state flush");=0A=
>>> +	} else {=0A=
>>> +		seq_buf_printf(&s, "Vulnerable");=0A=
>>> +	}=0A=
>>> +=0A=
>>> +	seq_buf_printf(&s, "\n");=0A=
>>> +=0A=
>>> +	return s.len;=0A=
>>> +}=0A=
>>> +=0A=
>>> +#ifdef CONFIG_PPC_BOOK3S_64=0A=
>>> +/*=0A=
>>> + * Store-forwarding barrier support.=0A=
>>> + */=0A=
>>> +=0A=
>>> +static enum stf_barrier_type stf_enabled_flush_types;=0A=
>>> +static bool no_stf_barrier;=0A=
>>> +bool stf_barrier;=0A=
>>> +=0A=
>>> +static int __init handle_no_stf_barrier(char *p)=0A=
>>> +{=0A=
>>> +	pr_info("stf-barrier: disabled on command line.");=0A=
>>> +	no_stf_barrier =3D true;=0A=
>>> +	return 0;=0A=
>>> +}=0A=
>>> +=0A=
>>> +early_param("no_stf_barrier", handle_no_stf_barrier);=0A=
>>> +=0A=
>>> +/* This is the generic flag used by other architectures */=0A=
>>> +static int __init handle_ssbd(char *p)=0A=
>>> +{=0A=
>>> +	if (!p || strncmp(p, "auto", 5) =3D=3D 0 || strncmp(p, "on", 2) =3D=
=3D 0 ) {=0A=
>>> +		/* Until firmware tells us, we have the barrier with auto */=0A=
>>> +		return 0;=0A=
>>> +	} else if (strncmp(p, "off", 3) =3D=3D 0) {=0A=
>>> +		handle_no_stf_barrier(NULL);=0A=
>>> +		return 0;=0A=
>>> +	} else=0A=
>>> +		return 1;=0A=
>>> +=0A=
>>> +	return 0;=0A=
>>> +}=0A=
>>> +early_param("spec_store_bypass_disable", handle_ssbd);=0A=
>>> +=0A=
>>> +/* This is the generic flag used by other architectures */=0A=
>>> +static int __init handle_no_ssbd(char *p)=0A=
>>> +{=0A=
>>> +	handle_no_stf_barrier(NULL);=0A=
>>> +	return 0;=0A=
>>> +}=0A=
>>> +early_param("nospec_store_bypass_disable", handle_no_ssbd);=0A=
>>> +=0A=
>>> +static void stf_barrier_enable(bool enable)=0A=
>>> +{=0A=
>>> +	if (enable)=0A=
>>> +		do_stf_barrier_fixups(stf_enabled_flush_types);=0A=
>>> +	else=0A=
>>> +		do_stf_barrier_fixups(STF_BARRIER_NONE);=0A=
>>> +=0A=
>>> +	stf_barrier =3D enable;=0A=
>>> +}=0A=
>>> +=0A=
>>> +void setup_stf_barrier(void)=0A=
>>> +{=0A=
>>> +	enum stf_barrier_type type;=0A=
>>> +	bool enable, hv;=0A=
>>> +=0A=
>>> +	hv =3D cpu_has_feature(CPU_FTR_HVMODE);=0A=
>>> +=0A=
>>> +	/* Default to fallback in case fw-features are not available */=0A=
>>> +	if (cpu_has_feature(CPU_FTR_ARCH_207S))=0A=
>>> +		type =3D STF_BARRIER_SYNC_ORI;=0A=
>>> +	else if (cpu_has_feature(CPU_FTR_ARCH_206))=0A=
>>> +		type =3D STF_BARRIER_FALLBACK;=0A=
>>> +	else=0A=
>>> +		type =3D STF_BARRIER_NONE;=0A=
>>> +=0A=
>>> +	enable =3D security_ftr_enabled(SEC_FTR_FAVOUR_SECURITY) &&=0A=
>>> +		(security_ftr_enabled(SEC_FTR_L1D_FLUSH_PR) ||=0A=
>>> +		 (security_ftr_enabled(SEC_FTR_L1D_FLUSH_HV) && hv));=0A=
>>> +=0A=
>>> +	if (type =3D=3D STF_BARRIER_FALLBACK) {=0A=
>>> +		pr_info("stf-barrier: fallback barrier available\n");=0A=
>>> +	} else if (type =3D=3D STF_BARRIER_SYNC_ORI) {=0A=
>>> +		pr_info("stf-barrier: hwsync barrier available\n");=0A=
>>> +	} else if (type =3D=3D STF_BARRIER_EIEIO) {=0A=
>>> +		pr_info("stf-barrier: eieio barrier available\n");=0A=
>>> +	}=0A=
>>> +=0A=
>>> +	stf_enabled_flush_types =3D type;=0A=
>>> +=0A=
>>> +	if (!no_stf_barrier)=0A=
>>> +		stf_barrier_enable(enable);=0A=
>>> +}=0A=
>>> +=0A=
>>> +ssize_t cpu_show_spec_store_bypass(struct device *dev, struct device_a=
ttribute *attr, char *buf)=0A=
>>> +{=0A=
>>> +	if (stf_barrier && stf_enabled_flush_types !=3D STF_BARRIER_NONE) {=
=0A=
>>> +		const char *type;=0A=
>>> +		switch (stf_enabled_flush_types) {=0A=
>>> +		case STF_BARRIER_EIEIO:=0A=
>>> +			type =3D "eieio";=0A=
>>> +			break;=0A=
>>> +		case STF_BARRIER_SYNC_ORI:=0A=
>>> +			type =3D "hwsync";=0A=
>>> +			break;=0A=
>>> +		case STF_BARRIER_FALLBACK:=0A=
>>> +			type =3D "fallback";=0A=
>>> +			break;=0A=
>>> +		default:=0A=
>>> +			type =3D "unknown";=0A=
>>> +		}=0A=
>>> +		return sprintf(buf, "Mitigation: Kernel entry/exit barrier (%s)\n", =
type);=0A=
>>> +	}=0A=
>>> +=0A=
>>> +	if (!security_ftr_enabled(SEC_FTR_L1D_FLUSH_HV) &&=0A=
>>> +	    !security_ftr_enabled(SEC_FTR_L1D_FLUSH_PR))=0A=
>>> +		return sprintf(buf, "Not affected\n");=0A=
>>> +=0A=
>>> +	return sprintf(buf, "Vulnerable\n");=0A=
>>> +}=0A=
>>> +=0A=
>>> +#ifdef CONFIG_DEBUG_FS=0A=
>>> +static int stf_barrier_set(void *data, u64 val)=0A=
>>> +{=0A=
>>> +	bool enable;=0A=
>>> +=0A=
>>> +	if (val =3D=3D 1)=0A=
>>> +		enable =3D true;=0A=
>>> +	else if (val =3D=3D 0)=0A=
>>> +		enable =3D false;=0A=
>>> +	else=0A=
>>> +		return -EINVAL;=0A=
>>> +=0A=
>>> +	/* Only do anything if we're changing state */=0A=
>>> +	if (enable !=3D stf_barrier)=0A=
>>> +		stf_barrier_enable(enable);=0A=
>>> +=0A=
>>> +	return 0;=0A=
>>> +}=0A=
>>> +=0A=
>>> +static int stf_barrier_get(void *data, u64 *val)=0A=
>>> +{=0A=
>>> +	*val =3D stf_barrier ? 1 : 0;=0A=
>>> +	return 0;=0A=
>>> +}=0A=
>>> +=0A=
>>> +DEFINE_SIMPLE_ATTRIBUTE(fops_stf_barrier, stf_barrier_get, stf_barrier=
_set, "%llu\n");=0A=
>>> +=0A=
>>> +static __init int stf_barrier_debugfs_init(void)=0A=
>>> +{=0A=
>>> +	debugfs_create_file("stf_barrier", 0600, powerpc_debugfs_root, NULL, =
&fops_stf_barrier);=0A=
>>> +	return 0;=0A=
>>> +}=0A=
>>> +device_initcall(stf_barrier_debugfs_init);=0A=
>>> +#endif /* CONFIG_DEBUG_FS */=0A=
>>> +=0A=
>>> +static void toggle_count_cache_flush(bool enable)=0A=
>>> +{=0A=
>>> +	if (!enable || !security_ftr_enabled(SEC_FTR_FLUSH_COUNT_CACHE)) {=0A=
>>> +		patch_instruction_site(&patch__call_flush_count_cache, PPC_INST_NOP)=
;=0A=
>>> +		count_cache_flush_type =3D COUNT_CACHE_FLUSH_NONE;=0A=
>>> +		pr_info("count-cache-flush: software flush disabled.\n");=0A=
>>> +		return;=0A=
>>> +	}=0A=
>>> +=0A=
>>> +	patch_branch_site(&patch__call_flush_count_cache,=0A=
>>> +			  (u64)&flush_count_cache, BRANCH_SET_LINK);=0A=
>>> +=0A=
>>> +	if (!security_ftr_enabled(SEC_FTR_BCCTR_FLUSH_ASSIST)) {=0A=
>>> +		count_cache_flush_type =3D COUNT_CACHE_FLUSH_SW;=0A=
>>> +		pr_info("count-cache-flush: full software flush sequence enabled.\n"=
);=0A=
>>> +		return;=0A=
>>> +	}=0A=
>>> +=0A=
>>> +	patch_instruction_site(&patch__flush_count_cache_return, PPC_INST_BLR=
);=0A=
>>> +	count_cache_flush_type =3D COUNT_CACHE_FLUSH_HW;=0A=
>>> +	pr_info("count-cache-flush: hardware assisted flush sequence enabled\=
n");=0A=
>>> +}=0A=
>>> +=0A=
>>> +void setup_count_cache_flush(void)=0A=
>>> +{=0A=
>>> +	toggle_count_cache_flush(true);=0A=
>>> +}=0A=
>>> +=0A=
>>> +#ifdef CONFIG_DEBUG_FS=0A=
>>> +static int count_cache_flush_set(void *data, u64 val)=0A=
>>> +{=0A=
>>> +	bool enable;=0A=
>>> +=0A=
>>> +	if (val =3D=3D 1)=0A=
>>> +		enable =3D true;=0A=
>>> +	else if (val =3D=3D 0)=0A=
>>> +		enable =3D false;=0A=
>>> +	else=0A=
>>> +		return -EINVAL;=0A=
>>> +=0A=
>>> +	toggle_count_cache_flush(enable);=0A=
>>> +=0A=
>>> +	return 0;=0A=
>>> +}=0A=
>>> +=0A=
>>> +static int count_cache_flush_get(void *data, u64 *val)=0A=
>>> +{=0A=
>>> +	if (count_cache_flush_type =3D=3D COUNT_CACHE_FLUSH_NONE)=0A=
>>> +		*val =3D 0;=0A=
>>> +	else=0A=
>>> +		*val =3D 1;=0A=
>>> +=0A=
>>> +	return 0;=0A=
>>> +}=0A=
>>> +=0A=
>>> +DEFINE_SIMPLE_ATTRIBUTE(fops_count_cache_flush, count_cache_flush_get,=
=0A=
>>> +			count_cache_flush_set, "%llu\n");=0A=
>>> +=0A=
>>> +static __init int count_cache_flush_debugfs_init(void)=0A=
>>> +{=0A=
>>> +	debugfs_create_file("count_cache_flush", 0600, powerpc_debugfs_root,=
=0A=
>>> +			    NULL, &fops_count_cache_flush);=0A=
>>> +	return 0;=0A=
>>> +}=0A=
>>> +device_initcall(count_cache_flush_debugfs_init);=0A=
>>> +#endif /* CONFIG_DEBUG_FS */=0A=
>>> +#endif /* CONFIG_PPC_BOOK3S_64 */=0A=
>>> diff --git a/arch/powerpc/kernel/setup_32.c b/arch/powerpc/kernel/setup=
_32.c=0A=
>>> index ad8c9db61237..5a9f035bcd6b 100644=0A=
>>> - --- a/arch/powerpc/kernel/setup_32.c=0A=
>>> +++ b/arch/powerpc/kernel/setup_32.c=0A=
>>> @@ -322,6 +322,8 @@ void __init setup_arch(char **cmdline_p)=0A=
>>>  		ppc_md.setup_arch();=0A=
>>>  	if ( ppc_md.progress ) ppc_md.progress("arch: exit", 0x3eab);=0A=
>>>  =0A=
>>> +	setup_barrier_nospec();=0A=
>>> +=0A=
>>>  	paging_init();=0A=
>>>  =0A=
>>>  	/* Initialize the MMU context management stuff */=0A=
>>> diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup=
_64.c=0A=
>>> index 9eb469bed22b..6bb731ababc6 100644=0A=
>>> - --- a/arch/powerpc/kernel/setup_64.c=0A=
>>> +++ b/arch/powerpc/kernel/setup_64.c=0A=
>>> @@ -736,6 +736,8 @@ void __init setup_arch(char **cmdline_p)=0A=
>>>  	if (ppc_md.setup_arch)=0A=
>>>  		ppc_md.setup_arch();=0A=
>>>  =0A=
>>> +	setup_barrier_nospec();=0A=
>>> +=0A=
>>>  	paging_init();=0A=
>>>  =0A=
>>>  	/* Initialize the MMU context management stuff */=0A=
>>> @@ -873,9 +875,6 @@ static void do_nothing(void *unused)=0A=
>>>  =0A=
>>>  void rfi_flush_enable(bool enable)=0A=
>>>  {=0A=
>>> - -	if (rfi_flush =3D=3D enable)=0A=
>>> - -		return;=0A=
>>> - -=0A=
>>>  	if (enable) {=0A=
>>>  		do_rfi_flush_fixups(enabled_flush_types);=0A=
>>>  		on_each_cpu(do_nothing, NULL, 1);=0A=
>>> @@ -885,11 +884,15 @@ void rfi_flush_enable(bool enable)=0A=
>>>  	rfi_flush =3D enable;=0A=
>>>  }=0A=
>>>  =0A=
>>> - -static void init_fallback_flush(void)=0A=
>>> +static void __ref init_fallback_flush(void)=0A=
>>>  {=0A=
>>>  	u64 l1d_size, limit;=0A=
>>>  	int cpu;=0A=
>>>  =0A=
>>> +	/* Only allocate the fallback flush area once (at boot time). */=0A=
>>> +	if (l1d_flush_fallback_area)=0A=
>>> +		return;=0A=
>>> +=0A=
>>>  	l1d_size =3D ppc64_caches.dsize;=0A=
>>>  	limit =3D min(safe_stack_limit(), ppc64_rma_size);=0A=
>>>  =0A=
>>> @@ -902,34 +905,23 @@ static void init_fallback_flush(void)=0A=
>>>  	memset(l1d_flush_fallback_area, 0, l1d_size * 2);=0A=
>>>  =0A=
>>>  	for_each_possible_cpu(cpu) {=0A=
>>> - -		/*=0A=
>>> - -		 * The fallback flush is currently coded for 8-way=0A=
>>> - -		 * associativity. Different associativity is possible, but it=0A=
>>> - -		 * will be treated as 8-way and may not evict the lines as=0A=
>>> - -		 * effectively.=0A=
>>> - -		 *=0A=
>>> - -		 * 128 byte lines are mandatory.=0A=
>>> - -		 */=0A=
>>> - -		u64 c =3D l1d_size / 8;=0A=
>>> - -=0A=
>>>  		paca[cpu].rfi_flush_fallback_area =3D l1d_flush_fallback_area;=0A=
>>> - -		paca[cpu].l1d_flush_congruence =3D c;=0A=
>>> - -		paca[cpu].l1d_flush_sets =3D c / 128;=0A=
>>> +		paca[cpu].l1d_flush_size =3D l1d_size;=0A=
>>>  	}=0A=
>>>  }=0A=
>>>  =0A=
>>> - -void __init setup_rfi_flush(enum l1d_flush_type types, bool enable)=
=0A=
>>> +void setup_rfi_flush(enum l1d_flush_type types, bool enable)=0A=
>>>  {=0A=
>>>  	if (types & L1D_FLUSH_FALLBACK) {=0A=
>>> - -		pr_info("rfi-flush: Using fallback displacement flush\n");=0A=
>>> +		pr_info("rfi-flush: fallback displacement flush available\n");=0A=
>>>  		init_fallback_flush();=0A=
>>>  	}=0A=
>>>  =0A=
>>>  	if (types & L1D_FLUSH_ORI)=0A=
>>> - -		pr_info("rfi-flush: Using ori type flush\n");=0A=
>>> +		pr_info("rfi-flush: ori type flush available\n");=0A=
>>>  =0A=
>>>  	if (types & L1D_FLUSH_MTTRIG)=0A=
>>> - -		pr_info("rfi-flush: Using mttrig type flush\n");=0A=
>>> +		pr_info("rfi-flush: mttrig type flush available\n");=0A=
>>>  =0A=
>>>  	enabled_flush_types =3D types;=0A=
>>>  =0A=
>>> @@ -940,13 +932,19 @@ void __init setup_rfi_flush(enum l1d_flush_type t=
ypes, bool enable)=0A=
>>>  #ifdef CONFIG_DEBUG_FS=0A=
>>>  static int rfi_flush_set(void *data, u64 val)=0A=
>>>  {=0A=
>>> +	bool enable;=0A=
>>> +=0A=
>>>  	if (val =3D=3D 1)=0A=
>>> - -		rfi_flush_enable(true);=0A=
>>> +		enable =3D true;=0A=
>>>  	else if (val =3D=3D 0)=0A=
>>> - -		rfi_flush_enable(false);=0A=
>>> +		enable =3D false;=0A=
>>>  	else=0A=
>>>  		return -EINVAL;=0A=
>>>  =0A=
>>> +	/* Only do anything if we're changing state */=0A=
>>> +	if (enable !=3D rfi_flush)=0A=
>>> +		rfi_flush_enable(enable);=0A=
>>> +=0A=
>>>  	return 0;=0A=
>>>  }=0A=
>>>  =0A=
>>> @@ -965,12 +963,4 @@ static __init int rfi_flush_debugfs_init(void)=0A=
>>>  }=0A=
>>>  device_initcall(rfi_flush_debugfs_init);=0A=
>>>  #endif=0A=
>>> - -=0A=
>>> - -ssize_t cpu_show_meltdown(struct device *dev, struct device_attribut=
e *attr, char *buf)=0A=
>>> - -{=0A=
>>> - -	if (rfi_flush)=0A=
>>> - -		return sprintf(buf, "Mitigation: RFI Flush\n");=0A=
>>> - -=0A=
>>> - -	return sprintf(buf, "Vulnerable\n");=0A=
>>> - -}=0A=
>>>  #endif /* CONFIG_PPC_BOOK3S_64 */=0A=
>>> diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vm=
linux.lds.S=0A=
>>> index 072a23a17350..876ac9d52afc 100644=0A=
>>> - --- a/arch/powerpc/kernel/vmlinux.lds.S=0A=
>>> +++ b/arch/powerpc/kernel/vmlinux.lds.S=0A=
>>> @@ -73,14 +73,45 @@ SECTIONS=0A=
>>>  	RODATA=0A=
>>>  =0A=
>>>  #ifdef CONFIG_PPC64=0A=
>>> +	. =3D ALIGN(8);=0A=
>>> +	__stf_entry_barrier_fixup : AT(ADDR(__stf_entry_barrier_fixup) - LOAD=
_OFFSET) {=0A=
>>> +		__start___stf_entry_barrier_fixup =3D .;=0A=
>>> +		*(__stf_entry_barrier_fixup)=0A=
>>> +		__stop___stf_entry_barrier_fixup =3D .;=0A=
>>> +	}=0A=
>>> +=0A=
>>> +	. =3D ALIGN(8);=0A=
>>> +	__stf_exit_barrier_fixup : AT(ADDR(__stf_exit_barrier_fixup) - LOAD_O=
FFSET) {=0A=
>>> +		__start___stf_exit_barrier_fixup =3D .;=0A=
>>> +		*(__stf_exit_barrier_fixup)=0A=
>>> +		__stop___stf_exit_barrier_fixup =3D .;=0A=
>>> +	}=0A=
>>> +=0A=
>>>  	. =3D ALIGN(8);=0A=
>>>  	__rfi_flush_fixup : AT(ADDR(__rfi_flush_fixup) - LOAD_OFFSET) {=0A=
>>>  		__start___rfi_flush_fixup =3D .;=0A=
>>>  		*(__rfi_flush_fixup)=0A=
>>>  		__stop___rfi_flush_fixup =3D .;=0A=
>>>  	}=0A=
>>> - -#endif=0A=
>>> +#endif /* CONFIG_PPC64 */=0A=
>>>  =0A=
>>> +#ifdef CONFIG_PPC_BARRIER_NOSPEC=0A=
>>> +	. =3D ALIGN(8);=0A=
>>> +	__spec_barrier_fixup : AT(ADDR(__spec_barrier_fixup) - LOAD_OFFSET) {=
=0A=
>>> +		__start___barrier_nospec_fixup =3D .;=0A=
>>> +		*(__barrier_nospec_fixup)=0A=
>>> +		__stop___barrier_nospec_fixup =3D .;=0A=
>>> +	}=0A=
>>> +#endif /* CONFIG_PPC_BARRIER_NOSPEC */=0A=
>>> +=0A=
>>> +#ifdef CONFIG_PPC_FSL_BOOK3E=0A=
>>> +	. =3D ALIGN(8);=0A=
>>> +	__spec_btb_flush_fixup : AT(ADDR(__spec_btb_flush_fixup) - LOAD_OFFSE=
T) {=0A=
>>> +		__start__btb_flush_fixup =3D .;=0A=
>>> +		*(__btb_flush_fixup)=0A=
>>> +		__stop__btb_flush_fixup =3D .;=0A=
>>> +	}=0A=
>>> +#endif=0A=
>>>  	EXCEPTION_TABLE(0)=0A=
>>>  =0A=
>>>  	NOTES :kernel :notes=0A=
>>> diff --git a/arch/powerpc/lib/code-patching.c b/arch/powerpc/lib/code-p=
atching.c=0A=
>>> index d5edbeb8eb82..570c06a00db6 100644=0A=
>>> - --- a/arch/powerpc/lib/code-patching.c=0A=
>>> +++ b/arch/powerpc/lib/code-patching.c=0A=
>>> @@ -14,12 +14,25 @@=0A=
>>>  #include <asm/page.h>=0A=
>>>  #include <asm/code-patching.h>=0A=
>>>  #include <asm/uaccess.h>=0A=
>>> +#include <asm/setup.h>=0A=
>>> +#include <asm/sections.h>=0A=
>>>  =0A=
>>>  =0A=
>>> +static inline bool is_init(unsigned int *addr)=0A=
>>> +{=0A=
>>> +	return addr >=3D (unsigned int *)__init_begin && addr < (unsigned int=
 *)__init_end;=0A=
>>> +}=0A=
>>> +=0A=
>>>  int patch_instruction(unsigned int *addr, unsigned int instr)=0A=
>>>  {=0A=
>>>  	int err;=0A=
>>>  =0A=
>>> +	/* Make sure we aren't patching a freed init section */=0A=
>>> +	if (init_mem_is_free && is_init(addr)) {=0A=
>>> +		pr_debug("Skipping init section patching addr: 0x%px\n", addr);=0A=
>>> +		return 0;=0A=
>>> +	}=0A=
>>> +=0A=
>>>  	__put_user_size(instr, addr, 4, err);=0A=
>>>  	if (err)=0A=
>>>  		return err;=0A=
>>> @@ -32,6 +45,22 @@ int patch_branch(unsigned int *addr, unsigned long t=
arget, int flags)=0A=
>>>  	return patch_instruction(addr, create_branch(addr, target, flags));=
=0A=
>>>  }=0A=
>>>  =0A=
>>> +int patch_branch_site(s32 *site, unsigned long target, int flags)=0A=
>>> +{=0A=
>>> +	unsigned int *addr;=0A=
>>> +=0A=
>>> +	addr =3D (unsigned int *)((unsigned long)site + *site);=0A=
>>> +	return patch_instruction(addr, create_branch(addr, target, flags));=
=0A=
>>> +}=0A=
>>> +=0A=
>>> +int patch_instruction_site(s32 *site, unsigned int instr)=0A=
>>> +{=0A=
>>> +	unsigned int *addr;=0A=
>>> +=0A=
>>> +	addr =3D (unsigned int *)((unsigned long)site + *site);=0A=
>>> +	return patch_instruction(addr, instr);=0A=
>>> +}=0A=
>>> +=0A=
>>>  unsigned int create_branch(const unsigned int *addr,=0A=
>>>  			   unsigned long target, int flags)=0A=
>>>  {=0A=
>>> diff --git a/arch/powerpc/lib/feature-fixups.c b/arch/powerpc/lib/featu=
re-fixups.c=0A=
>>> index 3af014684872..7bdfc19a491d 100644=0A=
>>> - --- a/arch/powerpc/lib/feature-fixups.c=0A=
>>> +++ b/arch/powerpc/lib/feature-fixups.c=0A=
>>> @@ -21,7 +21,7 @@=0A=
>>>  #include <asm/page.h>=0A=
>>>  #include <asm/sections.h>=0A=
>>>  #include <asm/setup.h>=0A=
>>> - -=0A=
>>> +#include <asm/security_features.h>=0A=
>>>  =0A=
>>>  struct fixup_entry {=0A=
>>>  	unsigned long	mask;=0A=
>>> @@ -115,6 +115,120 @@ void do_feature_fixups(unsigned long value, void =
*fixup_start, void *fixup_end)=0A=
>>>  }=0A=
>>>  =0A=
>>>  #ifdef CONFIG_PPC_BOOK3S_64=0A=
>>> +void do_stf_entry_barrier_fixups(enum stf_barrier_type types)=0A=
>>> +{=0A=
>>> +	unsigned int instrs[3], *dest;=0A=
>>> +	long *start, *end;=0A=
>>> +	int i;=0A=
>>> +=0A=
>>> +	start =3D PTRRELOC(&__start___stf_entry_barrier_fixup),=0A=
>>> +	end =3D PTRRELOC(&__stop___stf_entry_barrier_fixup);=0A=
>>> +=0A=
>>> +	instrs[0] =3D 0x60000000; /* nop */=0A=
>>> +	instrs[1] =3D 0x60000000; /* nop */=0A=
>>> +	instrs[2] =3D 0x60000000; /* nop */=0A=
>>> +=0A=
>>> +	i =3D 0;=0A=
>>> +	if (types & STF_BARRIER_FALLBACK) {=0A=
>>> +		instrs[i++] =3D 0x7d4802a6; /* mflr r10		*/=0A=
>>> +		instrs[i++] =3D 0x60000000; /* branch patched below */=0A=
>>> +		instrs[i++] =3D 0x7d4803a6; /* mtlr r10		*/=0A=
>>> +	} else if (types & STF_BARRIER_EIEIO) {=0A=
>>> +		instrs[i++] =3D 0x7e0006ac; /* eieio + bit 6 hint */=0A=
>>> +	} else if (types & STF_BARRIER_SYNC_ORI) {=0A=
>>> +		instrs[i++] =3D 0x7c0004ac; /* hwsync		*/=0A=
>>> +		instrs[i++] =3D 0xe94d0000; /* ld r10,0(r13)	*/=0A=
>>> +		instrs[i++] =3D 0x63ff0000; /* ori 31,31,0 speculation barrier */=0A=
>>> +	}=0A=
>>> +=0A=
>>> +	for (i =3D 0; start < end; start++, i++) {=0A=
>>> +		dest =3D (void *)start + *start;=0A=
>>> +=0A=
>>> +		pr_devel("patching dest %lx\n", (unsigned long)dest);=0A=
>>> +=0A=
>>> +		patch_instruction(dest, instrs[0]);=0A=
>>> +=0A=
>>> +		if (types & STF_BARRIER_FALLBACK)=0A=
>>> +			patch_branch(dest + 1, (unsigned long)&stf_barrier_fallback,=0A=
>>> +				     BRANCH_SET_LINK);=0A=
>>> +		else=0A=
>>> +			patch_instruction(dest + 1, instrs[1]);=0A=
>>> +=0A=
>>> +		patch_instruction(dest + 2, instrs[2]);=0A=
>>> +	}=0A=
>>> +=0A=
>>> +	printk(KERN_DEBUG "stf-barrier: patched %d entry locations (%s barrie=
r)\n", i,=0A=
>>> +		(types =3D=3D STF_BARRIER_NONE)                  ? "no" :=0A=
>>> +		(types =3D=3D STF_BARRIER_FALLBACK)              ? "fallback" :=0A=
>>> +		(types =3D=3D STF_BARRIER_EIEIO)                 ? "eieio" :=0A=
>>> +		(types =3D=3D (STF_BARRIER_SYNC_ORI))            ? "hwsync"=0A=
>>> +		                                           : "unknown");=0A=
>>> +}=0A=
>>> +=0A=
>>> +void do_stf_exit_barrier_fixups(enum stf_barrier_type types)=0A=
>>> +{=0A=
>>> +	unsigned int instrs[6], *dest;=0A=
>>> +	long *start, *end;=0A=
>>> +	int i;=0A=
>>> +=0A=
>>> +	start =3D PTRRELOC(&__start___stf_exit_barrier_fixup),=0A=
>>> +	end =3D PTRRELOC(&__stop___stf_exit_barrier_fixup);=0A=
>>> +=0A=
>>> +	instrs[0] =3D 0x60000000; /* nop */=0A=
>>> +	instrs[1] =3D 0x60000000; /* nop */=0A=
>>> +	instrs[2] =3D 0x60000000; /* nop */=0A=
>>> +	instrs[3] =3D 0x60000000; /* nop */=0A=
>>> +	instrs[4] =3D 0x60000000; /* nop */=0A=
>>> +	instrs[5] =3D 0x60000000; /* nop */=0A=
>>> +=0A=
>>> +	i =3D 0;=0A=
>>> +	if (types & STF_BARRIER_FALLBACK || types & STF_BARRIER_SYNC_ORI) {=
=0A=
>>> +		if (cpu_has_feature(CPU_FTR_HVMODE)) {=0A=
>>> +			instrs[i++] =3D 0x7db14ba6; /* mtspr 0x131, r13 (HSPRG1) */=0A=
>>> +			instrs[i++] =3D 0x7db04aa6; /* mfspr r13, 0x130 (HSPRG0) */=0A=
>>> +		} else {=0A=
>>> +			instrs[i++] =3D 0x7db243a6; /* mtsprg 2,r13	*/=0A=
>>> +			instrs[i++] =3D 0x7db142a6; /* mfsprg r13,1    */=0A=
>>> +	        }=0A=
>>> +		instrs[i++] =3D 0x7c0004ac; /* hwsync		*/=0A=
>>> +		instrs[i++] =3D 0xe9ad0000; /* ld r13,0(r13)	*/=0A=
>>> +		instrs[i++] =3D 0x63ff0000; /* ori 31,31,0 speculation barrier */=0A=
>>> +		if (cpu_has_feature(CPU_FTR_HVMODE)) {=0A=
>>> +			instrs[i++] =3D 0x7db14aa6; /* mfspr r13, 0x131 (HSPRG1) */=0A=
>>> +		} else {=0A=
>>> +			instrs[i++] =3D 0x7db242a6; /* mfsprg r13,2 */=0A=
>>> +		}=0A=
>>> +	} else if (types & STF_BARRIER_EIEIO) {=0A=
>>> +		instrs[i++] =3D 0x7e0006ac; /* eieio + bit 6 hint */=0A=
>>> +	}=0A=
>>> +=0A=
>>> +	for (i =3D 0; start < end; start++, i++) {=0A=
>>> +		dest =3D (void *)start + *start;=0A=
>>> +=0A=
>>> +		pr_devel("patching dest %lx\n", (unsigned long)dest);=0A=
>>> +=0A=
>>> +		patch_instruction(dest, instrs[0]);=0A=
>>> +		patch_instruction(dest + 1, instrs[1]);=0A=
>>> +		patch_instruction(dest + 2, instrs[2]);=0A=
>>> +		patch_instruction(dest + 3, instrs[3]);=0A=
>>> +		patch_instruction(dest + 4, instrs[4]);=0A=
>>> +		patch_instruction(dest + 5, instrs[5]);=0A=
>>> +	}=0A=
>>> +	printk(KERN_DEBUG "stf-barrier: patched %d exit locations (%s barrier=
)\n", i,=0A=
>>> +		(types =3D=3D STF_BARRIER_NONE)                  ? "no" :=0A=
>>> +		(types =3D=3D STF_BARRIER_FALLBACK)              ? "fallback" :=0A=
>>> +		(types =3D=3D STF_BARRIER_EIEIO)                 ? "eieio" :=0A=
>>> +		(types =3D=3D (STF_BARRIER_SYNC_ORI))            ? "hwsync"=0A=
>>> +		                                           : "unknown");=0A=
>>> +}=0A=
>>> +=0A=
>>> +=0A=
>>> +void do_stf_barrier_fixups(enum stf_barrier_type types)=0A=
>>> +{=0A=
>>> +	do_stf_entry_barrier_fixups(types);=0A=
>>> +	do_stf_exit_barrier_fixups(types);=0A=
>>> +}=0A=
>>> +=0A=
>>>  void do_rfi_flush_fixups(enum l1d_flush_type types)=0A=
>>>  {=0A=
>>>  	unsigned int instrs[3], *dest;=0A=
>>> @@ -151,10 +265,110 @@ void do_rfi_flush_fixups(enum l1d_flush_type typ=
es)=0A=
>>>  		patch_instruction(dest + 2, instrs[2]);=0A=
>>>  	}=0A=
>>>  =0A=
>>> - -	printk(KERN_DEBUG "rfi-flush: patched %d locations\n", i);=0A=
>>> +	printk(KERN_DEBUG "rfi-flush: patched %d locations (%s flush)\n", i,=
=0A=
>>> +		(types =3D=3D L1D_FLUSH_NONE)       ? "no" :=0A=
>>> +		(types =3D=3D L1D_FLUSH_FALLBACK)   ? "fallback displacement" :=0A=
>>> +		(types &  L1D_FLUSH_ORI)        ? (types & L1D_FLUSH_MTTRIG)=0A=
>>> +							? "ori+mttrig type"=0A=
>>> +							: "ori type" :=0A=
>>> +		(types &  L1D_FLUSH_MTTRIG)     ? "mttrig type"=0A=
>>> +						: "unknown");=0A=
>>> +}=0A=
>>> +=0A=
>>> +void do_barrier_nospec_fixups_range(bool enable, void *fixup_start, vo=
id *fixup_end)=0A=
>>> +{=0A=
>>> +	unsigned int instr, *dest;=0A=
>>> +	long *start, *end;=0A=
>>> +	int i;=0A=
>>> +=0A=
>>> +	start =3D fixup_start;=0A=
>>> +	end =3D fixup_end;=0A=
>>> +=0A=
>>> +	instr =3D 0x60000000; /* nop */=0A=
>>> +=0A=
>>> +	if (enable) {=0A=
>>> +		pr_info("barrier-nospec: using ORI speculation barrier\n");=0A=
>>> +		instr =3D 0x63ff0000; /* ori 31,31,0 speculation barrier */=0A=
>>> +	}=0A=
>>> +=0A=
>>> +	for (i =3D 0; start < end; start++, i++) {=0A=
>>> +		dest =3D (void *)start + *start;=0A=
>>> +=0A=
>>> +		pr_devel("patching dest %lx\n", (unsigned long)dest);=0A=
>>> +		patch_instruction(dest, instr);=0A=
>>> +	}=0A=
>>> +=0A=
>>> +	printk(KERN_DEBUG "barrier-nospec: patched %d locations\n", i);=0A=
>>>  }=0A=
>>> +=0A=
>>>  #endif /* CONFIG_PPC_BOOK3S_64 */=0A=
>>>  =0A=
>>> +#ifdef CONFIG_PPC_BARRIER_NOSPEC=0A=
>>> +void do_barrier_nospec_fixups(bool enable)=0A=
>>> +{=0A=
>>> +	void *start, *end;=0A=
>>> +=0A=
>>> +	start =3D PTRRELOC(&__start___barrier_nospec_fixup),=0A=
>>> +	end =3D PTRRELOC(&__stop___barrier_nospec_fixup);=0A=
>>> +=0A=
>>> +	do_barrier_nospec_fixups_range(enable, start, end);=0A=
>>> +}=0A=
>>> +#endif /* CONFIG_PPC_BARRIER_NOSPEC */=0A=
>>> +=0A=
>>> +#ifdef CONFIG_PPC_FSL_BOOK3E=0A=
>>> +void do_barrier_nospec_fixups_range(bool enable, void *fixup_start, vo=
id *fixup_end)=0A=
>>> +{=0A=
>>> +	unsigned int instr[2], *dest;=0A=
>>> +	long *start, *end;=0A=
>>> +	int i;=0A=
>>> +=0A=
>>> +	start =3D fixup_start;=0A=
>>> +	end =3D fixup_end;=0A=
>>> +=0A=
>>> +	instr[0] =3D PPC_INST_NOP;=0A=
>>> +	instr[1] =3D PPC_INST_NOP;=0A=
>>> +=0A=
>>> +	if (enable) {=0A=
>>> +		pr_info("barrier-nospec: using isync; sync as speculation barrier\n"=
);=0A=
>>> +		instr[0] =3D PPC_INST_ISYNC;=0A=
>>> +		instr[1] =3D PPC_INST_SYNC;=0A=
>>> +	}=0A=
>>> +=0A=
>>> +	for (i =3D 0; start < end; start++, i++) {=0A=
>>> +		dest =3D (void *)start + *start;=0A=
>>> +=0A=
>>> +		pr_devel("patching dest %lx\n", (unsigned long)dest);=0A=
>>> +		patch_instruction(dest, instr[0]);=0A=
>>> +		patch_instruction(dest + 1, instr[1]);=0A=
>>> +	}=0A=
>>> +=0A=
>>> +	printk(KERN_DEBUG "barrier-nospec: patched %d locations\n", i);=0A=
>>> +}=0A=
>>> +=0A=
>>> +static void patch_btb_flush_section(long *curr)=0A=
>>> +{=0A=
>>> +	unsigned int *start, *end;=0A=
>>> +=0A=
>>> +	start =3D (void *)curr + *curr;=0A=
>>> +	end =3D (void *)curr + *(curr + 1);=0A=
>>> +	for (; start < end; start++) {=0A=
>>> +		pr_devel("patching dest %lx\n", (unsigned long)start);=0A=
>>> +		patch_instruction(start, PPC_INST_NOP);=0A=
>>> +	}=0A=
>>> +}=0A=
>>> +=0A=
>>> +void do_btb_flush_fixups(void)=0A=
>>> +{=0A=
>>> +	long *start, *end;=0A=
>>> +=0A=
>>> +	start =3D PTRRELOC(&__start__btb_flush_fixup);=0A=
>>> +	end =3D PTRRELOC(&__stop__btb_flush_fixup);=0A=
>>> +=0A=
>>> +	for (; start < end; start +=3D 2)=0A=
>>> +		patch_btb_flush_section(start);=0A=
>>> +}=0A=
>>> +#endif /* CONFIG_PPC_FSL_BOOK3E */=0A=
>>> +=0A=
>>>  void do_lwsync_fixups(unsigned long value, void *fixup_start, void *fi=
xup_end)=0A=
>>>  {=0A=
>>>  	long *start, *end;=0A=
>>> diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c=0A=
>>> index 22d94c3e6fc4..1efe5ca5c3bc 100644=0A=
>>> - --- a/arch/powerpc/mm/mem.c=0A=
>>> +++ b/arch/powerpc/mm/mem.c=0A=
>>> @@ -62,6 +62,7 @@=0A=
>>>  #endif=0A=
>>>  =0A=
>>>  unsigned long long memory_limit;=0A=
>>> +bool init_mem_is_free;=0A=
>>>  =0A=
>>>  #ifdef CONFIG_HIGHMEM=0A=
>>>  pte_t *kmap_pte;=0A=
>>> @@ -381,6 +382,7 @@ void __init mem_init(void)=0A=
>>>  void free_initmem(void)=0A=
>>>  {=0A=
>>>  	ppc_md.progress =3D ppc_printk_progress;=0A=
>>> +	init_mem_is_free =3D true;=0A=
>>>  	free_initmem_default(POISON_FREE_INITMEM);=0A=
>>>  }=0A=
>>>  =0A=
>>> diff --git a/arch/powerpc/mm/tlb_low_64e.S b/arch/powerpc/mm/tlb_low_64=
e.S=0A=
>>> index 29d6987c37ba..5486d56da289 100644=0A=
>>> - --- a/arch/powerpc/mm/tlb_low_64e.S=0A=
>>> +++ b/arch/powerpc/mm/tlb_low_64e.S=0A=
>>> @@ -69,6 +69,13 @@ END_FTR_SECTION_IFSET(CPU_FTR_EMB_HV)=0A=
>>>  	std	r15,EX_TLB_R15(r12)=0A=
>>>  	std	r10,EX_TLB_CR(r12)=0A=
>>>  #ifdef CONFIG_PPC_FSL_BOOK3E=0A=
>>> +START_BTB_FLUSH_SECTION=0A=
>>> +	mfspr r11, SPRN_SRR1=0A=
>>> +	andi. r10,r11,MSR_PR=0A=
>>> +	beq 1f=0A=
>>> +	BTB_FLUSH(r10)=0A=
>>> +1:=0A=
>>> +END_BTB_FLUSH_SECTION=0A=
>>>  	std	r7,EX_TLB_R7(r12)=0A=
>>>  #endif=0A=
>>>  	TLB_MISS_PROLOG_STATS=0A=
>>> diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/plat=
forms/powernv/setup.c=0A=
>>> index c57afc619b20..e14b52c7ebd8 100644=0A=
>>> - --- a/arch/powerpc/platforms/powernv/setup.c=0A=
>>> +++ b/arch/powerpc/platforms/powernv/setup.c=0A=
>>> @@ -37,53 +37,99 @@=0A=
>>>  #include <asm/smp.h>=0A=
>>>  #include <asm/tm.h>=0A=
>>>  #include <asm/setup.h>=0A=
>>> +#include <asm/security_features.h>=0A=
>>>  =0A=
>>>  #include "powernv.h"=0A=
>>>  =0A=
>>> +=0A=
>>> +static bool fw_feature_is(const char *state, const char *name,=0A=
>>> +			  struct device_node *fw_features)=0A=
>>> +{=0A=
>>> +	struct device_node *np;=0A=
>>> +	bool rc =3D false;=0A=
>>> +=0A=
>>> +	np =3D of_get_child_by_name(fw_features, name);=0A=
>>> +	if (np) {=0A=
>>> +		rc =3D of_property_read_bool(np, state);=0A=
>>> +		of_node_put(np);=0A=
>>> +	}=0A=
>>> +=0A=
>>> +	return rc;=0A=
>>> +}=0A=
>>> +=0A=
>>> +static void init_fw_feat_flags(struct device_node *np)=0A=
>>> +{=0A=
>>> +	if (fw_feature_is("enabled", "inst-spec-barrier-ori31,31,0", np))=0A=
>>> +		security_ftr_set(SEC_FTR_SPEC_BAR_ORI31);=0A=
>>> +=0A=
>>> +	if (fw_feature_is("enabled", "fw-bcctrl-serialized", np))=0A=
>>> +		security_ftr_set(SEC_FTR_BCCTRL_SERIALISED);=0A=
>>> +=0A=
>>> +	if (fw_feature_is("enabled", "inst-l1d-flush-ori30,30,0", np))=0A=
>>> +		security_ftr_set(SEC_FTR_L1D_FLUSH_ORI30);=0A=
>>> +=0A=
>>> +	if (fw_feature_is("enabled", "inst-l1d-flush-trig2", np))=0A=
>>> +		security_ftr_set(SEC_FTR_L1D_FLUSH_TRIG2);=0A=
>>> +=0A=
>>> +	if (fw_feature_is("enabled", "fw-l1d-thread-split", np))=0A=
>>> +		security_ftr_set(SEC_FTR_L1D_THREAD_PRIV);=0A=
>>> +=0A=
>>> +	if (fw_feature_is("enabled", "fw-count-cache-disabled", np))=0A=
>>> +		security_ftr_set(SEC_FTR_COUNT_CACHE_DISABLED);=0A=
>>> +=0A=
>>> +	if (fw_feature_is("enabled", "fw-count-cache-flush-bcctr2,0,0", np))=
=0A=
>>> +		security_ftr_set(SEC_FTR_BCCTR_FLUSH_ASSIST);=0A=
>>> +=0A=
>>> +	if (fw_feature_is("enabled", "needs-count-cache-flush-on-context-swit=
ch", np))=0A=
>>> +		security_ftr_set(SEC_FTR_FLUSH_COUNT_CACHE);=0A=
>>> +=0A=
>>> +	/*=0A=
>>> +	 * The features below are enabled by default, so we instead look to s=
ee=0A=
>>> +	 * if firmware has *disabled* them, and clear them if so.=0A=
>>> +	 */=0A=
>>> +	if (fw_feature_is("disabled", "speculation-policy-favor-security", np=
))=0A=
>>> +		security_ftr_clear(SEC_FTR_FAVOUR_SECURITY);=0A=
>>> +=0A=
>>> +	if (fw_feature_is("disabled", "needs-l1d-flush-msr-pr-0-to-1", np))=
=0A=
>>> +		security_ftr_clear(SEC_FTR_L1D_FLUSH_PR);=0A=
>>> +=0A=
>>> +	if (fw_feature_is("disabled", "needs-l1d-flush-msr-hv-1-to-0", np))=
=0A=
>>> +		security_ftr_clear(SEC_FTR_L1D_FLUSH_HV);=0A=
>>> +=0A=
>>> +	if (fw_feature_is("disabled", "needs-spec-barrier-for-bound-checks", =
np))=0A=
>>> +		security_ftr_clear(SEC_FTR_BNDS_CHK_SPEC_BAR);=0A=
>>> +}=0A=
>>> +=0A=
>>>  static void pnv_setup_rfi_flush(void)=0A=
>>>  {=0A=
>>>  	struct device_node *np, *fw_features;=0A=
>>>  	enum l1d_flush_type type;=0A=
>>> - -	int enable;=0A=
>>> +	bool enable;=0A=
>>>  =0A=
>>>  	/* Default to fallback in case fw-features are not available */=0A=
>>>  	type =3D L1D_FLUSH_FALLBACK;=0A=
>>> - -	enable =3D 1;=0A=
>>>  =0A=
>>>  	np =3D of_find_node_by_name(NULL, "ibm,opal");=0A=
>>>  	fw_features =3D of_get_child_by_name(np, "fw-features");=0A=
>>>  	of_node_put(np);=0A=
>>>  =0A=
>>>  	if (fw_features) {=0A=
>>> - -		np =3D of_get_child_by_name(fw_features, "inst-l1d-flush-trig2");=
=0A=
>>> - -		if (np && of_property_read_bool(np, "enabled"))=0A=
>>> - -			type =3D L1D_FLUSH_MTTRIG;=0A=
>>> +		init_fw_feat_flags(fw_features);=0A=
>>> +		of_node_put(fw_features);=0A=
>>>  =0A=
>>> - -		of_node_put(np);=0A=
>>> +		if (security_ftr_enabled(SEC_FTR_L1D_FLUSH_TRIG2))=0A=
>>> +			type =3D L1D_FLUSH_MTTRIG;=0A=
>>>  =0A=
>>> - -		np =3D of_get_child_by_name(fw_features, "inst-l1d-flush-ori30,30,=
0");=0A=
>>> - -		if (np && of_property_read_bool(np, "enabled"))=0A=
>>> +		if (security_ftr_enabled(SEC_FTR_L1D_FLUSH_ORI30))=0A=
>>>  			type =3D L1D_FLUSH_ORI;=0A=
>>> - -=0A=
>>> - -		of_node_put(np);=0A=
>>> - -=0A=
>>> - -		/* Enable unless firmware says NOT to */=0A=
>>> - -		enable =3D 2;=0A=
>>> - -		np =3D of_get_child_by_name(fw_features, "needs-l1d-flush-msr-hv-1=
-to-0");=0A=
>>> - -		if (np && of_property_read_bool(np, "disabled"))=0A=
>>> - -			enable--;=0A=
>>> - -=0A=
>>> - -		of_node_put(np);=0A=
>>> - -=0A=
>>> - -		np =3D of_get_child_by_name(fw_features, "needs-l1d-flush-msr-pr-0=
-to-1");=0A=
>>> - -		if (np && of_property_read_bool(np, "disabled"))=0A=
>>> - -			enable--;=0A=
>>> - -=0A=
>>> - -		of_node_put(np);=0A=
>>> - -		of_node_put(fw_features);=0A=
>>>  	}=0A=
>>>  =0A=
>>> - -	setup_rfi_flush(type, enable > 0);=0A=
>>> +	enable =3D security_ftr_enabled(SEC_FTR_FAVOUR_SECURITY) && \=0A=
>>> +		 (security_ftr_enabled(SEC_FTR_L1D_FLUSH_PR)   || \=0A=
>>> +		  security_ftr_enabled(SEC_FTR_L1D_FLUSH_HV));=0A=
>>> +=0A=
>>> +	setup_rfi_flush(type, enable);=0A=
>>> +	setup_count_cache_flush();=0A=
>>>  }=0A=
>>>  =0A=
>>>  static void __init pnv_setup_arch(void)=0A=
>>> @@ -91,6 +137,7 @@ static void __init pnv_setup_arch(void)=0A=
>>>  	set_arch_panic_timeout(10, ARCH_PANIC_TIMEOUT);=0A=
>>>  =0A=
>>>  	pnv_setup_rfi_flush();=0A=
>>> +	setup_stf_barrier();=0A=
>>>  =0A=
>>>  	/* Initialize SMP */=0A=
>>>  	pnv_smp_init();=0A=
>>> diff --git a/arch/powerpc/platforms/pseries/mobility.c b/arch/powerpc/p=
latforms/pseries/mobility.c=0A=
>>> index 8dd0c8edefd6..c773396d0969 100644=0A=
>>> - --- a/arch/powerpc/platforms/pseries/mobility.c=0A=
>>> +++ b/arch/powerpc/platforms/pseries/mobility.c=0A=
>>> @@ -314,6 +314,9 @@ void post_mobility_fixup(void)=0A=
>>>  		printk(KERN_ERR "Post-mobility device tree update "=0A=
>>>  			"failed: %d\n", rc);=0A=
>>>  =0A=
>>> +	/* Possibly switch to a new RFI flush type */=0A=
>>> +	pseries_setup_rfi_flush();=0A=
>>> +=0A=
>>>  	return;=0A=
>>>  }=0A=
>>>  =0A=
>>> diff --git a/arch/powerpc/platforms/pseries/pseries.h b/arch/powerpc/pl=
atforms/pseries/pseries.h=0A=
>>> index 8411c27293e4..e7d80797384d 100644=0A=
>>> - --- a/arch/powerpc/platforms/pseries/pseries.h=0A=
>>> +++ b/arch/powerpc/platforms/pseries/pseries.h=0A=
>>> @@ -81,4 +81,6 @@ extern struct pci_controller_ops pseries_pci_controll=
er_ops;=0A=
>>>  =0A=
>>>  unsigned long pseries_memory_block_size(void);=0A=
>>>  =0A=
>>> +void pseries_setup_rfi_flush(void);=0A=
>>> +=0A=
>>>  #endif /* _PSERIES_PSERIES_H */=0A=
>>> diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/plat=
forms/pseries/setup.c=0A=
>>> index dd2545fc9947..9cc976ff7fec 100644=0A=
>>> - --- a/arch/powerpc/platforms/pseries/setup.c=0A=
>>> +++ b/arch/powerpc/platforms/pseries/setup.c=0A=
>>> @@ -67,6 +67,7 @@=0A=
>>>  #include <asm/eeh.h>=0A=
>>>  #include <asm/reg.h>=0A=
>>>  #include <asm/plpar_wrappers.h>=0A=
>>> +#include <asm/security_features.h>=0A=
>>>  =0A=
>>>  #include "pseries.h"=0A=
>>>  =0A=
>>> @@ -499,37 +500,87 @@ static void __init find_and_init_phbs(void)=0A=
>>>  	of_pci_check_probe_only();=0A=
>>>  }=0A=
>>>  =0A=
>>> - -static void pseries_setup_rfi_flush(void)=0A=
>>> +static void init_cpu_char_feature_flags(struct h_cpu_char_result *resu=
lt)=0A=
>>> +{=0A=
>>> +	/*=0A=
>>> +	 * The features below are disabled by default, so we instead look to =
see=0A=
>>> +	 * if firmware has *enabled* them, and set them if so.=0A=
>>> +	 */=0A=
>>> +	if (result->character & H_CPU_CHAR_SPEC_BAR_ORI31)=0A=
>>> +		security_ftr_set(SEC_FTR_SPEC_BAR_ORI31);=0A=
>>> +=0A=
>>> +	if (result->character & H_CPU_CHAR_BCCTRL_SERIALISED)=0A=
>>> +		security_ftr_set(SEC_FTR_BCCTRL_SERIALISED);=0A=
>>> +=0A=
>>> +	if (result->character & H_CPU_CHAR_L1D_FLUSH_ORI30)=0A=
>>> +		security_ftr_set(SEC_FTR_L1D_FLUSH_ORI30);=0A=
>>> +=0A=
>>> +	if (result->character & H_CPU_CHAR_L1D_FLUSH_TRIG2)=0A=
>>> +		security_ftr_set(SEC_FTR_L1D_FLUSH_TRIG2);=0A=
>>> +=0A=
>>> +	if (result->character & H_CPU_CHAR_L1D_THREAD_PRIV)=0A=
>>> +		security_ftr_set(SEC_FTR_L1D_THREAD_PRIV);=0A=
>>> +=0A=
>>> +	if (result->character & H_CPU_CHAR_COUNT_CACHE_DISABLED)=0A=
>>> +		security_ftr_set(SEC_FTR_COUNT_CACHE_DISABLED);=0A=
>>> +=0A=
>>> +	if (result->character & H_CPU_CHAR_BCCTR_FLUSH_ASSIST)=0A=
>>> +		security_ftr_set(SEC_FTR_BCCTR_FLUSH_ASSIST);=0A=
>>> +=0A=
>>> +	if (result->behaviour & H_CPU_BEHAV_FLUSH_COUNT_CACHE)=0A=
>>> +		security_ftr_set(SEC_FTR_FLUSH_COUNT_CACHE);=0A=
>>> +=0A=
>>> +	/*=0A=
>>> +	 * The features below are enabled by default, so we instead look to s=
ee=0A=
>>> +	 * if firmware has *disabled* them, and clear them if so.=0A=
>>> +	 */=0A=
>>> +	if (!(result->behaviour & H_CPU_BEHAV_FAVOUR_SECURITY))=0A=
>>> +		security_ftr_clear(SEC_FTR_FAVOUR_SECURITY);=0A=
>>> +=0A=
>>> +	if (!(result->behaviour & H_CPU_BEHAV_L1D_FLUSH_PR))=0A=
>>> +		security_ftr_clear(SEC_FTR_L1D_FLUSH_PR);=0A=
>>> +=0A=
>>> +	if (!(result->behaviour & H_CPU_BEHAV_BNDS_CHK_SPEC_BAR))=0A=
>>> +		security_ftr_clear(SEC_FTR_BNDS_CHK_SPEC_BAR);=0A=
>>> +}=0A=
>>> +=0A=
>>> +void pseries_setup_rfi_flush(void)=0A=
>>>  {=0A=
>>>  	struct h_cpu_char_result result;=0A=
>>>  	enum l1d_flush_type types;=0A=
>>>  	bool enable;=0A=
>>>  	long rc;=0A=
>>>  =0A=
>>> - -	/* Enable by default */=0A=
>>> - -	enable =3D true;=0A=
>>> +	/*=0A=
>>> +	 * Set features to the defaults assumed by init_cpu_char_feature_flag=
s()=0A=
>>> +	 * so it can set/clear again any features that might have changed aft=
er=0A=
>>> +	 * migration, and in case the hypercall fails and it is not even call=
ed.=0A=
>>> +	 */=0A=
>>> +	powerpc_security_features =3D SEC_FTR_DEFAULT;=0A=
>>>  =0A=
>>>  	rc =3D plpar_get_cpu_characteristics(&result);=0A=
>>> - -	if (rc =3D=3D H_SUCCESS) {=0A=
>>> - -		types =3D L1D_FLUSH_NONE;=0A=
>>> +	if (rc =3D=3D H_SUCCESS)=0A=
>>> +		init_cpu_char_feature_flags(&result);=0A=
>>>  =0A=
>>> - -		if (result.character & H_CPU_CHAR_L1D_FLUSH_TRIG2)=0A=
>>> - -			types |=3D L1D_FLUSH_MTTRIG;=0A=
>>> - -		if (result.character & H_CPU_CHAR_L1D_FLUSH_ORI30)=0A=
>>> - -			types |=3D L1D_FLUSH_ORI;=0A=
>>> +	/*=0A=
>>> +	 * We're the guest so this doesn't apply to us, clear it to simplify=
=0A=
>>> +	 * handling of it elsewhere.=0A=
>>> +	 */=0A=
>>> +	security_ftr_clear(SEC_FTR_L1D_FLUSH_HV);=0A=
>>>  =0A=
>>> - -		/* Use fallback if nothing set in hcall */=0A=
>>> - -		if (types =3D=3D L1D_FLUSH_NONE)=0A=
>>> - -			types =3D L1D_FLUSH_FALLBACK;=0A=
>>> +	types =3D L1D_FLUSH_FALLBACK;=0A=
>>>  =0A=
>>> - -		if (!(result.behaviour & H_CPU_BEHAV_L1D_FLUSH_PR))=0A=
>>> - -			enable =3D false;=0A=
>>> - -	} else {=0A=
>>> - -		/* Default to fallback if case hcall is not available */=0A=
>>> - -		types =3D L1D_FLUSH_FALLBACK;=0A=
>>> - -	}=0A=
>>> +	if (security_ftr_enabled(SEC_FTR_L1D_FLUSH_TRIG2))=0A=
>>> +		types |=3D L1D_FLUSH_MTTRIG;=0A=
>>> +=0A=
>>> +	if (security_ftr_enabled(SEC_FTR_L1D_FLUSH_ORI30))=0A=
>>> +		types |=3D L1D_FLUSH_ORI;=0A=
>>> +=0A=
>>> +	enable =3D security_ftr_enabled(SEC_FTR_FAVOUR_SECURITY) && \=0A=
>>> +		 security_ftr_enabled(SEC_FTR_L1D_FLUSH_PR);=0A=
>>>  =0A=
>>>  	setup_rfi_flush(types, enable);=0A=
>>> +	setup_count_cache_flush();=0A=
>>>  }=0A=
>>>  =0A=
>>>  static void __init pSeries_setup_arch(void)=0A=
>>> @@ -549,6 +600,7 @@ static void __init pSeries_setup_arch(void)=0A=
>>>  	fwnmi_init();=0A=
>>>  =0A=
>>>  	pseries_setup_rfi_flush();=0A=
>>> +	setup_stf_barrier();=0A=
>>>  =0A=
>>>  	/* By default, only probe PCI (can be overridden by rtas_pci) */=0A=
>>>  	pci_add_flags(PCI_PROBE_ONLY);=0A=
>>> diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c=0A=
>>> index 786bf01691c9..83619ebede93 100644=0A=
>>> - --- a/arch/powerpc/xmon/xmon.c=0A=
>>> +++ b/arch/powerpc/xmon/xmon.c=0A=
>>> @@ -2144,6 +2144,8 @@ static void dump_one_paca(int cpu)=0A=
>>>  	DUMP(p, slb_cache_ptr, "x");=0A=
>>>  	for (i =3D 0; i < SLB_CACHE_ENTRIES; i++)=0A=
>>>  		printf(" slb_cache[%d]:        =3D 0x%016lx\n", i, p->slb_cache[i]);=
=0A=
>>> +=0A=
>>> +	DUMP(p, rfi_flush_fallback_area, "px");=0A=
>>>  #endif=0A=
>>>  	DUMP(p, dscr_default, "llx");=0A=
>>>  #ifdef CONFIG_PPC_BOOK3E=0A=
>>> - -- =0A=
>>> 2.20.1=0A=
>>>=0A=
>>> -----BEGIN PGP SIGNATURE-----=0A=
>>>=0A=
>>> iQIcBAEBAgAGBQJcvHWhAAoJEFHr6jzI4aWA6nsP/0YskmAfLovcUmERQ7+bIjq6=0A=
>>> IcS1T466dvy6MlqeBXU4x8pVgInWeHKEC9XJdkM1lOeib/SLW7Hbz4kgJeOGwFGY=0A=
>>> lOTaexrxvsBqPm7f6GC0zbl9obEIIIIUs+TielFQANBgqm+q8Wio+XXPP9bpKeKY=0A=
>>> agSpQ3nwL/PYixznbNmN/lP9py5p89LQ0IBcR7dDBGGWJtD/AXeZ9hslsZxPbPtI=0A=
>>> nZJ0vdnjuoB2z+hCxfKWlYfLwH0VfoTpqP5x3ALCkvbBr67e8bf6EK8+trnvhyQ8=0A=
>>> iLY4bp1pm2epAI0/3NfyEiDMsGjVJ6IFlkyhDkHJgJNu0BGcGOSX2GpyU3juviAK=0A=
>>> c95FtBft/i8AwigOMCivg2mN5edYjsSiPoEItwT5KWqgByJsdr5i5mYVx8cUjMOz=0A=
>>> iAxLZCdg+UHZYuCBCAO2ZI1G9bVXI1Pa3btMspiCOOOsYGjXGf0oFfKQ+7957hUO=0A=
>>> ftYYJoGHlMHiHR1OPas6T3lk6YKF9uvfIDTE3OKw2obHbbRz3u82xoWMRGW503MN=0A=
>>> 7WpkpAP7oZ9RgqIWFVhatWy5f+7GFL0akEi4o2tsZHhYlPau7YWo+nToTd87itwt=0A=
>>> GBaWJipzge4s13VkhAE+jWFO35Fvwi8uNZ7UgpuKMBECEjkGbtzBTq2MjSF5G8wc=0A=
>>> yPEod5jby/Iqb7DkGPVG=0A=
>>> =3D6DnF=0A=
>>> -----END PGP SIGNATURE-----=0A=
>>>=0A=
=0A=
