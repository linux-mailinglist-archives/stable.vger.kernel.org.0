Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5C5B369277
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 14:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235557AbhDWMxI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 08:53:08 -0400
Received: from mail-eopbgr760084.outbound.protection.outlook.com ([40.107.76.84]:18434
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230521AbhDWMxH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Apr 2021 08:53:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HQ6IX/Gadw23geWeYfaiIJf9Gr1EsJDjkIJDLMrlUUMjVPUuQREJPEg04bItM+0rS+GC7Kdbjm73aFYmLhoXL69IN4bg0BRZbwE9VlcZ7RVpTFEl1loKT/cWMgniLM8mwjZT1QbdTXpxNjcNw9coUS4uzSw5U2KSvh4wd14prOy7EsO/bFYRSfN7xei1EnInjT4EHRmKPUAYXAYRHRP7QPGJCISnwPglhI7TIFzfifGb7mINaf2BMcseV5f8P4RhZdUf0N8hm7+HACNp1XkT2mpmmDTr9MHL/ydxmIEnese8K+VrfT616mOZ44R42qh0FA4TnLBswrCSAD5ANgCZvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E3kbO3EK/UOB3QrHQg1YwgV2pbcarnUwz0vNHQ4w48c=;
 b=KmxVvBcOPtIUPvU8zKloc/8Caifn5+i/UN9k3dtqQytb5CCeDu1jG+ShP6NkdojWGJlWjvQOrzSNvmMB+C3FsVlCTbLcB+HcZvgiArJlEa3khr74HVdpEwcxGdkF4GtzWuehveoccQt81WP8s5uGL7ZUZaKoC6CHbnQL1CKmv7zM/o2jYmSH6ZCuH4SWhA4mAmQg7X3CnZ1+7cSWsH3EnGKt4OLD61DLDQr0kHPFvtaTaDJebKQ/qZxdozTzswuBAQmWaXXianWOpbgPuhSkWqNoDqOgMkFaHpCmjHJjNmHT7KiNm5nwF0umCUmo4443MJRN6Suo2zzrLGZJcG9GZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E3kbO3EK/UOB3QrHQg1YwgV2pbcarnUwz0vNHQ4w48c=;
 b=UDbOURqRzeXvWdufCuXupQFzX3zAlYVEQ8EXSpq+CsOQ76coxtjoUdzGL+edKV8Vi+q3e+r0m1Ib+pDDJG2RTjXQ/bQMVDT0RWB/usG63kzNTVA0m2BGV6f0Xh34WEK/NsGkDQ/Q9h2G5R9z2VQOlD1XVE2wuWZWhJKzwcxHyAE=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MWHPR12MB1248.namprd12.prod.outlook.com (2603:10b6:300:12::21)
 by MWHPR12MB1789.namprd12.prod.outlook.com (2603:10b6:300:112::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Fri, 23 Apr
 2021 12:52:29 +0000
Received: from MWHPR12MB1248.namprd12.prod.outlook.com
 ([fe80::f07c:dc0f:e7e8:416c]) by MWHPR12MB1248.namprd12.prod.outlook.com
 ([fe80::f07c:dc0f:e7e8:416c%4]) with mapi id 15.20.4065.024; Fri, 23 Apr 2021
 12:52:29 +0000
Date:   Fri, 23 Apr 2021 20:52:08 +0800
From:   Huang Rui <ray.huang@amd.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        Jason Bagavatsingham <jason.bagavatsingham@gmail.com>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        "Fontenot, Nathan" <Nathan.Fontenot@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Borislav Petkov <bp@suse.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        Stable <stable@vger.kernel.org>
Subject: Re: [PATCH v3] x86, sched: Fix the AMD CPPC maximum perf on some
 specific generations
Message-ID: <20210423125208.GA688865@hr-amd>
References: <20210423023928.688767-1-ray.huang@amd.com>
 <CAJZ5v0iH0-YL-yVPSA2oJF7PGfQs5Tcv5ktH43xMLPAKysDXPw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAJZ5v0iH0-YL-yVPSA2oJF7PGfQs5Tcv5ktH43xMLPAKysDXPw@mail.gmail.com>
X-Originating-IP: [58.247.170.245]
X-ClientProxiedBy: HK2PR0302CA0001.apcprd03.prod.outlook.com
 (2603:1096:202::11) To MWHPR12MB1248.namprd12.prod.outlook.com
 (2603:10b6:300:12::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from hr-amd (58.247.170.245) by HK2PR0302CA0001.apcprd03.prod.outlook.com (2603:1096:202::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.16 via Frontend Transport; Fri, 23 Apr 2021 12:52:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 79353791-4971-4014-6e45-08d90656a77d
X-MS-TrafficTypeDiagnostic: MWHPR12MB1789:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR12MB1789E75FE86F2025BA2F5DAEEC459@MWHPR12MB1789.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lDhNOqmSBOQ+y5UrvGGOLadBJXP4IYENcC9DNKFT6LJNU7d8g5zXWD5pRWmSFnLNfdOtQWlbmNkvp4ugUegQDQDylVgPGTS1+8LulMFPRBH2NYxLrBohhQlf+kuG34uZkGfXzq5LrLO3sbVAOSxGowtI/J/GRHm1lAw+YWpCq0qo7rEQMN2xBbAWejr16a/hG/EIsNbYUnij5av0G3SSdTnumQ9iLbCkw6SKSC1/67EzuTsiOKP1dJA13+ho6LyNojMW7/zO0y8iIOW1J7giiVK4HLuTDhvvzyoWAe2EGPK/qnRLq2tHRFdcSo7D9gaILOlyT6nT3qxoE5VUdGwPBB5Ru4yKLVSXUd2vEJ2RRTdfinUAWLc9q1FC8y2OxJy0yaM6P+XKbuGJedMEMcoi1j5/GL3ob6dcw/Q5a8S0tgPNdIZcMoJTZDIxo3lZuq5Ga3u59SYN8UwUpxieC2dyTVSOgci/86d1MNFwdBTNxdqhlq4I1OyJ4+uqLPvjKa7CdiPDnlEkQ+IAx2AxwwI5pf9a9yBUwhBZSPEvMQi7uv1f8rAm8Bc63x1AxYa2/t7XdA5wP+EChhiGuK6AZb8hzKMh0gE3vaygntpzI6Umpm/NJtxyb99ubpzv101r7XJr+XwlwzDGkinoyIThPftLlprx7QiuxRYENvTujm2jnBuLGT0MmUJluqqRL0fDfoS6eI/C3u3bURxv9vFs17WlO1v0ar+qdVTL9kroffqNPRQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39850400004)(136003)(366004)(376002)(396003)(478600001)(16526019)(33656002)(316002)(83380400001)(55016002)(6666004)(66556008)(5660300002)(66946007)(54906003)(8676002)(4326008)(6496006)(8936002)(66476007)(956004)(53546011)(38100700002)(38350700002)(86362001)(6916009)(9686003)(52116002)(186003)(2906002)(26005)(1076003)(45080400002)(33716001)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?bOaCw4LoXaZkcKpA4gyhZ+jx47h1ktJOgS8ZudBB2jduW3BCLtXNDYdyac8+?=
 =?us-ascii?Q?HfnopXGtcUT7KSPi7JJwJawiK0smsqURknT9Ep1tTjzIF5HlJtyDt1vT4HbY?=
 =?us-ascii?Q?2XB8D1rlkOvE/bLCkPYBQm/dDkF+KJtwpWrlVoJVmjvpVUdzeNdxB97mDKNA?=
 =?us-ascii?Q?8SHWvKhY6Jm0Ac19jEcrrdRWW/0FmzMcZ1CPWhbTLw6grgXODbnGD486y2MM?=
 =?us-ascii?Q?FIyi723qeX+Kz+CSEdsFSivffcZuVvUa2rUfYi0+uMfjAOfzPaqUdPIGWNbI?=
 =?us-ascii?Q?0yE1w7Sh3i/aoxwYE22auxg4Tk0RUPcjmWy+HoCR+9lGXSK2x4H4E3UPmOSW?=
 =?us-ascii?Q?fsTByNe3jAWnRCS4xV9FvLtFGuCD1mcinDSaB2ijls8Cx0frPJa8UDrfBKvL?=
 =?us-ascii?Q?ejN4Ieg5zMSadz8Eg2D62MdFvjd9Vq1W3fZ0qc2l5BfycCCy1OZwx9ej+Ab1?=
 =?us-ascii?Q?V/0WcsowbyJAcMpqFQgFR92nIMFpdPX+AaF4KZ/+XhuNwRUpcwo025mcp6Zt?=
 =?us-ascii?Q?ZQ98G9R0QaZCSBqgeLnOboYFfxfrPKMEfqUEe9Y6uGbwc/oPvK0sxv+4LyHv?=
 =?us-ascii?Q?vFwSiGFSV2lSPteGAKqr5G1EaEJ49SoAzJEgLhV8BdpgWhhC9P/TBrVay2U7?=
 =?us-ascii?Q?3W4bId9KHbWOxCKEY6otiafcMHncUFfJmD4WpiE77kqKwos/RXE9bMbJywqw?=
 =?us-ascii?Q?H/YXaYMXJxvhzZAUXyaomwFTLcMl1usW9AMfLs5fQjW0NAFp7Cj6ifVuPH5g?=
 =?us-ascii?Q?OfeRIwGu1AWCPb3erjRu1f6wpjbeW6wYeZQo7AWqUSbmxAnM/9tHB00CDxne?=
 =?us-ascii?Q?NWSgwFwWCEPoWQ1YY5e21CzTYDzG3GjV0KKtBqADFT9607e4a7NAsBxFcSew?=
 =?us-ascii?Q?hH6cz321CR/I6u+DcQVkhJ9YonzoDFCOzYpXEQLbjcSWFM8wfYY/hid2PDNt?=
 =?us-ascii?Q?f5J+8UN7TAP6RzxABKx33u1zMNh67dP+7ZZ2KaMriga5b5qDzL/9yUUxiq2T?=
 =?us-ascii?Q?VqJxBofXG2BPnp/0A4Z93fgVwUkyRG+eksjdcnRqrl7r2mbZv2nVssaMzsp4?=
 =?us-ascii?Q?s8hEInmmhDuWipn+GUViygBoAuebN3kTj2sJKtle+Eyonex6fNVUWKdJahd3?=
 =?us-ascii?Q?fTc1Z3veVrjpqXBYnK2tu93nIagQfoav05wlb0RnQZxOYGVp8D2XpMlRtErX?=
 =?us-ascii?Q?2Lg1CnPueohtB222B7FdJsNp+0fEfauj81DSdKBMgNiDcpSJEzKsZ3lq7EW9?=
 =?us-ascii?Q?MsxyxelpyXauOo22hHmKqUPQp+wjjlbNPBAIrFlRxUGgaOVH5sL+y9bRX0GY?=
 =?us-ascii?Q?udwdBCmi0gEsqIiJTmsxw2K3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79353791-4971-4014-6e45-08d90656a77d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 12:52:29.8304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WrSS6knrC1iPMiznyXbvFX4vfMmw6VED48oaQZ++Id2Av6C8KNtrYktSEzfD0a14khP5UlaOM7SmdWjPaByHjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1789
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 23, 2021 at 08:09:49PM +0800, Rafael J. Wysocki wrote:
> On Fri, Apr 23, 2021 at 4:40 AM Huang Rui <ray.huang@amd.com> wrote:
> >
> > Some AMD Ryzen generations has different calculation method on maximum
> > perf. 255 is not for all asics, some specific generations should use 166
> > as the maximum perf. Otherwise, it will report incorrect frequency value
> > like below:
> >
> > ~ =1B$B"*=1B(B lscpu | grep MHz
> > CPU MHz:                         3400.000
> > CPU max MHz:                     7228.3198
> > CPU min MHz:                     2200.0000
> >
> > Fixes: 41ea667227ba ("x86, sched: Calculate frequency invariance for AM=
D systems")
> > Fixes: 3c55e94c0ade ("cpufreq: ACPI: Extend frequency tables to cover b=
oost frequencies")
> >
> > Reported-by: Jason Bagavatsingham <jason.bagavatsingham@gmail.com>
> > Tested-by: Jason Bagavatsingham <jason.bagavatsingham@gmail.com>
> > Bugzilla: https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3=
A%2F%2Fbugzilla.kernel.org%2Fshow_bug.cgi%3Fid%3D211791&amp;data=3D04%7C01%=
7Cray.huang%40amd.com%7Ce9ed877387fc4b7431e108d90650b98f%7C3dd8961fe4884e60=
8e11a82d994e183d%7C0%7C0%7C637547766057950380%7CUnknown%7CTWFpbGZsb3d8eyJWI=
joiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sd=
ata=3DR%2FSBLaYOhTjrli%2BT054EytKeh8VmN7ryOQuQW4mgz6M%3D&amp;reserved=3D0
> > Signed-off-by: Huang Rui <ray.huang@amd.com>
> > Cc: Alex Deucher <alexander.deucher@amd.com>
> > Cc: Nathan Fontenot <nathan.fontenot@amd.com>
> > Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Cc: Borislav Petkov <bp@suse.de>
> > Cc: x86@kernel.org
> > Cc: stable@vger.kernel.org
> > ---
> >
> > Changes from V1 -> V2:
> > - Enhance the commit message.
> > - Move amd_get_highest_perf() into amd.c.
> > - Refine the implementation of switch-case.
> > - Cc stable mail list.
> >
> > Changes from V2 -> V3:
> > - Move the update into cppc_get_perf_caps() to correct the highest perf=
 value in
> >   the API.
> >
> > ---
> >  arch/x86/include/asm/processor.h |  2 ++
> >  arch/x86/kernel/cpu/amd.c        | 22 ++++++++++++++++++++++
> >  drivers/acpi/cppc_acpi.c         |  8 ++++++--
> >  3 files changed, 30 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/pr=
ocessor.h
> > index f1b9ed5efaa9..908bcaea1361 100644
> > --- a/arch/x86/include/asm/processor.h
> > +++ b/arch/x86/include/asm/processor.h
> > @@ -804,8 +804,10 @@ DECLARE_PER_CPU(u64, msr_misc_features_shadow);
> >
> >  #ifdef CONFIG_CPU_SUP_AMD
> >  extern u32 amd_get_nodes_per_socket(void);
> > +extern u32 amd_get_highest_perf(void);
> >  #else
> >  static inline u32 amd_get_nodes_per_socket(void)       { return 0; }
> > +static inline u32 amd_get_highest_perf(void)           { return 0; }
> >  #endif
> >
> >  static inline uint32_t hypervisor_cpuid_base(const char *sig, uint32_t=
 leaves)
> > diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> > index 347a956f71ca..aadb691d9357 100644
> > --- a/arch/x86/kernel/cpu/amd.c
> > +++ b/arch/x86/kernel/cpu/amd.c
> > @@ -1170,3 +1170,25 @@ void set_dr_addr_mask(unsigned long mask, int dr)
> >                 break;
> >         }
> >  }
> > +
> > +u32 amd_get_highest_perf(void)
> > +{
> > +       struct cpuinfo_x86 *c =3D &boot_cpu_data;
> > +       u32 cppc_max_perf =3D 225;
> > +
> > +       switch (c->x86) {
> > +       case 0x17:
> > +               if ((c->x86_model >=3D 0x30 && c->x86_model < 0x40) ||
> > +                   (c->x86_model >=3D 0x70 && c->x86_model < 0x80))
> > +                       cppc_max_perf =3D 166;
> > +               break;
> > +       case 0x19:
> > +               if ((c->x86_model >=3D 0x20 && c->x86_model < 0x30) ||
> > +                   (c->x86_model >=3D 0x40 && c->x86_model < 0x70))
> > +                       cppc_max_perf =3D 166;
> > +               break;
> > +       }
> > +
> > +       return cppc_max_perf;
> > +}
> > +EXPORT_SYMBOL_GPL(amd_get_highest_perf);
> > diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
> > index 69057fcd2c04..58e72b6e222f 100644
> > --- a/drivers/acpi/cppc_acpi.c
> > +++ b/drivers/acpi/cppc_acpi.c
> > @@ -1107,8 +1107,12 @@ int cppc_get_perf_caps(int cpunum, struct cppc_p=
erf_caps *perf_caps)
> >                 }
> >         }
> >
> > -       cpc_read(cpunum, highest_reg, &high);
> > -       perf_caps->highest_perf =3D high;
> > +       if (boot_cpu_data.x86_vendor =3D=3D X86_VENDOR_AMD) {
>=20
> This is a generic arch-independent file.
>=20
> Can we avoid adding the x86-specific check here?

OK, I see, it will be used by ARM as well.

Can I rollback to implementation of V2:

https://lore.kernel.org/r/20210421023807.1540290-1-ray.huang@amd.com

If stick to add quirk in cppc_acpi.c and avoid x86-specific check at the
same time here, the code will not be straight forward. Or will you have any
other good idea?

Thanks,
Ray
