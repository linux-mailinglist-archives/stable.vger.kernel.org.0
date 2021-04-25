Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2598836A576
	for <lists+stable@lfdr.de>; Sun, 25 Apr 2021 09:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbhDYHTw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Apr 2021 03:19:52 -0400
Received: from mail-co1nam11on2068.outbound.protection.outlook.com ([40.107.220.68]:31585
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229480AbhDYHTv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 25 Apr 2021 03:19:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G577P7+Y6Wyel3zT+4l/glyGchWY3EbuTNYpvnKU3FFknTnU3cKhFHYeQ9lUUG5pQYl4KVV+BhnyV1Gj/CeM3+Ga7P34SSaoDGAsdxlAQek7m93fktoaPr3XYpjQ3XY2vLOkysV2ADsauzUU10mVjRJLqZ6F+9bo8KdsXk1glS3SyPNTZ1mheo5yyL5lun8EDEszOO5ub2rqtXUiJ0eOfVgZIkJBBqSDX7koqBHZm3UZ2S6gAL8o2i2kCcwqV29vZ+CYgU0fckTS2DjikLzlY5Zc29sf24UbGnO9jXG2zy5YblmhtHxju1wi2tPCEC2VlKnmeJV7jsd1nSTIwBsHLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wV+38upySxY0qjBe1Nvgpy5MbS5dQwfNPvtNSrMZy4k=;
 b=fmAWg78F9sTm806JCZyh9bnrz80162ioN2eul8U10BviZrMgfR1bsOlsM2dSnqNu7GDsxz5Q4qXb11qim8+5nijf9SVgifH/06OR12f2BbPMMV0SJ8pr57JIlX0NMdrXCbakGWcksUUtcjzy26xtCKl6P21LJY7ACazMS0xU7QBhTEIVVTYl1ieoPGza4o0D9gIEecpGwvSIPivVBJHcpdqU4rRXP0R+EhR4rIlv7QBOBj5uyOiEJbaXSx47ImK0NnGI+Q3Eicx60O80GP4OqMw1KTdwdvayzKUbyBkDq5PiMaKsaiyobbdRO2sKYiS5gc/V+XDq5u1rZgJjtnBJwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wV+38upySxY0qjBe1Nvgpy5MbS5dQwfNPvtNSrMZy4k=;
 b=LVXeYBEtum/V97CF5R6VE9cMg7fpfjEKQyn7ViaFVp0gFpvOTGt6fE3tQnW+jvUWTm4sTxtfpTCWj0SnEsW+Apjp1KlYNQguV3xd55J+hWKYxXoe1iIAXaNK+lITx+I5Pwk9JelV8MDFOTiV4yKGZKsF54G8I4gGrYsgfJ0FEPk=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MWHPR12MB1248.namprd12.prod.outlook.com (2603:10b6:300:12::21)
 by MWHPR1201MB2540.namprd12.prod.outlook.com (2603:10b6:300:e0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Sun, 25 Apr
 2021 07:19:07 +0000
Received: from MWHPR12MB1248.namprd12.prod.outlook.com
 ([fe80::f07c:dc0f:e7e8:416c]) by MWHPR12MB1248.namprd12.prod.outlook.com
 ([fe80::f07c:dc0f:e7e8:416c%4]) with mapi id 15.20.4065.026; Sun, 25 Apr 2021
 07:19:06 +0000
Date:   Sun, 25 Apr 2021 15:18:56 +0800
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
Subject: Re: [PATCH v2] x86, sched: Fix the AMD CPPC maximum perf on some
 specific generations
Message-ID: <20210425071856.GB2175798@hr-amd>
References: <20210421023807.1540290-1-ray.huang@amd.com>
 <CAJZ5v0iXzpD_DNWOroncHL+XkSznv+meQf74OiHcbQMqbAC4ug@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAJZ5v0iXzpD_DNWOroncHL+XkSznv+meQf74OiHcbQMqbAC4ug@mail.gmail.com>
X-Originating-IP: [58.247.170.245]
X-ClientProxiedBy: HK2PR02CA0157.apcprd02.prod.outlook.com
 (2603:1096:201:1f::17) To MWHPR12MB1248.namprd12.prod.outlook.com
 (2603:10b6:300:12::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from hr-amd (58.247.170.245) by HK2PR02CA0157.apcprd02.prod.outlook.com (2603:1096:201:1f::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Sun, 25 Apr 2021 07:19:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4eacde6f-33bc-4d77-2865-08d907ba6932
X-MS-TrafficTypeDiagnostic: MWHPR1201MB2540:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1201MB2540897EDF4AC24520B4C2D4EC439@MWHPR1201MB2540.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kGp/uFdiG5lkXZjGHQe1uez0ntnm+XP+Wd/cZQgFvgfRGqjuHtPNmFK7mEktJIebxq4QtGSpiJdGwkiJZLcCHrfZLONLoq+iPUdcDJxjuUEpGji8XKmaYGX4uVXXizRLaXeaPnNG1BsAcCqx3UTtnsEHxAHYdQtfTyATqsmIZu3qcfAzPUdi7+/hSlpv2hHXNohWQtWhUiVYMm1o9lUCXr1Z1hReuSJALPv3vWpdI3e0Q7Lo3xg1hynzoVcIDdpi7oXR76RzGRWDo+ijeV79yYGMurVcsdDaZMapb1ZVbIVgU/1ScZFNJ+y4dDXiUEZZHY590pY+0LubYdLWvaRA1igEfHwIIwDNCYwNXBPvA2Bf79f0xo31yBpjmYkSmzx8uQY9f2ijZ/nha4iMZ6s/oQ7ZVzyO4pDGLGDE15NSc7fuVojlNNhPEep+gTjsyqvzmiG/ouhKv5sY0r65kNNVJgRhmSlZflUQdRGXZWl8YYPyXzzPwCKq8eXDI5148IWULyi395it4yVIpY3HmcCm/0OTQD8buUHvz22+ulqpqQn/wKKT5fFSEIw/prqS+izfKUD2z7pgkAvqbTR9/N6qwZCx7IEq+mrnxnylpupUuLhBqdpGZmYfMPSEVLYQuyrNSTsKlwTVq3qdBaQF4Ze0DFWzBAjfQxwvSAWZ5YsEoLIdhy2ySflG2dp2kZQZR/Y61+RPQ1ihdAfZo6Z/1dGvmVb3evUhWbQmy2y9XhfCjcI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(346002)(396003)(136003)(52116002)(6496006)(2906002)(86362001)(9686003)(316002)(33656002)(1076003)(55016002)(5660300002)(478600001)(8936002)(8676002)(45080400002)(6916009)(66556008)(66476007)(66946007)(54906003)(4326008)(38350700002)(38100700002)(956004)(6666004)(26005)(186003)(966005)(16526019)(83380400001)(33716001)(53546011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?A9cAAGAgET4H6KDJOTWb5VkX2NYFHApkUStb2hu78FDlIqcKSljjf3vbgYjG?=
 =?us-ascii?Q?i6hvhVjPbvjYHVSyliuvMorVYZ3vk1bf8wY2IFdJfW8GwXZZvGHNOXL8WJ/z?=
 =?us-ascii?Q?u9xCIkTgWNnw2SPKd5xIBEIL6HokOp6IGDP1QTggg3eI4FJ3z1aQL7quVVJN?=
 =?us-ascii?Q?M3Zcc3p5w7g5AFlGButeIEkVSdZWxcBLWAZYugKP0P5UtcZlt8GXX4fdrYge?=
 =?us-ascii?Q?hRZrEFG54QdcOnHI+dg9lBBlk95DSt716ajZzuV1hAi0bCyJyGencO1QmVKN?=
 =?us-ascii?Q?cHl8LSD7kSTZD0tIe4+Fl5ukPIGgchBJi7qGyT/lWhV99xki4bbBW+YKUWt7?=
 =?us-ascii?Q?HUTsr7gwf2IoTvR8zc5qAh6zNyc1ourUyJNQbUatGvlLneUgF+3N0vxBRUU0?=
 =?us-ascii?Q?8BgBXlGP9nQimdPhzWrkmDDAN1AooYuSMPJR8VZZszad36eJJ8GD23+xuRM7?=
 =?us-ascii?Q?esCSbebdYHplguBMMir4X3awAPeSs6dxoZiq3eg1ibidZkbMKKh3GZi1dFo9?=
 =?us-ascii?Q?Gli7wiRb6uF9t9wRdHlIXMBITjPKWidzJWrlZc2Qpl/0t7Cr3siLb+BMeg21?=
 =?us-ascii?Q?DIOiP0k07ugXpJDRWiW4SCgNtct39Kl2pINpWcUK1Yb53wsoAmcACg89Fdaq?=
 =?us-ascii?Q?5FCNbFRnm3VQ+lVRlzELpiCpKVN28VPWxfAO9kdCaNhcpCH9KwNJKTR5V3uD?=
 =?us-ascii?Q?2Kax7ICIWA4eEoErV9jNl932LbIBzPdV3imfB7xomWLIWT54tclrAyPosSHL?=
 =?us-ascii?Q?1t1NCXP7ONMleW9P53ZQ3AcMRDSAVJTfRogNBOw7E7+QLr3HkIoutyqRaV/f?=
 =?us-ascii?Q?c4h3FoYsmwLZsC3aLxTWgb5WQqgEVSrZ9G/xOOha1JjQgBKIgN7+S23DDkPi?=
 =?us-ascii?Q?qajgXuZiuA5fYo1WGm4CO+Nxx4/gIaNF3eyI2gAB+1s+OxU5Ml6eepekD8NN?=
 =?us-ascii?Q?nvaeWlDX+rVAkg6pzJvwZt/i7bOX8stXBT2NGfksRuURduKpKXJIbt4w7kVQ?=
 =?us-ascii?Q?f1HZAPIaM8qMJRmmJ1OMszeCjEAFvOhC6ZwwMxiawpw1Xn/82Jh4rk8Jcj0s?=
 =?us-ascii?Q?WWKyDQIQWLIV+/1VcXtc/Oj0L36Rn2rOQUlPpQgZkl38lMeFxf7EIskUPHlC?=
 =?us-ascii?Q?716fNXYhqvlj6GOwmWWhrLVmnzLOTH6hnnaMMP33kNtk2h1PJbWlMJ6Gcooc?=
 =?us-ascii?Q?wJN+f77meOQxQrJybZdh8NxDJCQh9EOZKwzYL3/SWsubSUG0r+LRU37k5zpq?=
 =?us-ascii?Q?rqQHNd9iJTT31Rku6G1SQzHwSBuqetTwlH18AZADTuP3mfBjP/OtZeWl38b4?=
 =?us-ascii?Q?/nC+Q728GOn/d99SaCh86YRW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4eacde6f-33bc-4d77-2865-08d907ba6932
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2021 07:19:06.3260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iQtYCUfEHAUZ+jBoprzMNp22a3gMHjJKiZsRVMuOCwK0YbXmQyL2WIQkrJiIRD+gjBmQyfxj/HDyee1QKDcB/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB2540
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 23, 2021 at 11:19:46PM +0800, Rafael J. Wysocki wrote:
> On Wed, Apr 21, 2021 at 4:38 AM Huang Rui <ray.huang@amd.com> wrote:
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
7Cray.huang%40amd.com%7C5069cfd46dfe4f0c504208d9066b41be%7C3dd8961fe4884e60=
8e11a82d994e183d%7C0%7C0%7C637547880005034494%7CUnknown%7CTWFpbGZsb3d8eyJWI=
joiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sd=
ata=3DYSgziLlmyJlAxMQceGlx%2FB1EgN50h512ai1F4ypXoD8%3D&amp;reserved=3D0
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
> > ---
> >  arch/x86/include/asm/processor.h |  2 ++
> >  arch/x86/kernel/cpu/amd.c        | 22 ++++++++++++++++++++++
> >  arch/x86/kernel/smpboot.c        |  2 +-
> >  drivers/cpufreq/acpi-cpufreq.c   | 19 +++++++++++++++++++
> >  4 files changed, 44 insertions(+), 1 deletion(-)
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
>=20
> The extra local variable is redundant.
>=20
> > +
> > +       switch (c->x86) {
> > +       case 0x17:
> > +               if ((c->x86_model >=3D 0x30 && c->x86_model < 0x40) ||
> > +                   (c->x86_model >=3D 0x70 && c->x86_model < 0x80))
> > +                       cppc_max_perf =3D 166;
> > +               break;
>=20
> Also it would be cleaner to write this as
>=20
> if (c->x86 =3D=3D 0x17 && ((c->x86_model >=3D 0x30 && c->x86_model < 0x40=
) ||
>     (c->x86_model >=3D 0x70 && c->x86_model < 0x80))
>         return 166;
>=20
> And analogously below.
>=20
> > +       case 0x19:
> > +               if ((c->x86_model >=3D 0x20 && c->x86_model < 0x30) ||
> > +                   (c->x86_model >=3D 0x40 && c->x86_model < 0x70))
> > +                       cppc_max_perf =3D 166;
> > +               break;
> > +       }
> > +
> > +       return cppc_max_perf;
>=20
> And here
>=20
> return 225;
>=20
> > +}
> > +EXPORT_SYMBOL_GPL(amd_get_highest_perf);
> > diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> > index 02813a7f3a7c..7bec57d04a87 100644
> > --- a/arch/x86/kernel/smpboot.c
> > +++ b/arch/x86/kernel/smpboot.c
> > @@ -2046,7 +2046,7 @@ static bool amd_set_max_freq_ratio(void)
> >                 return false;
> >         }
> >
> > -       highest_perf =3D perf_caps.highest_perf;
> > +       highest_perf =3D amd_get_highest_perf();
> >         nominal_perf =3D perf_caps.nominal_perf;
> >
> >         if (!highest_perf || !nominal_perf) {
> > diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpuf=
req.c
> > index d1bbc16fba4b..3f0a19dd658c 100644
> > --- a/drivers/cpufreq/acpi-cpufreq.c
> > +++ b/drivers/cpufreq/acpi-cpufreq.c
> > @@ -630,6 +630,22 @@ static int acpi_cpufreq_blacklist(struct cpuinfo_x=
86 *c)
> >  #endif
> >
> >  #ifdef CONFIG_ACPI_CPPC_LIB
> > +
> > +static u64 get_amd_max_boost_ratio(unsigned int cpu, u64 nominal_perf)
> > +{
> > +       u64 boost_ratio, cppc_max_perf;
> > +
> > +       if (!nominal_perf)
> > +               return 0;
> > +
> > +       cppc_max_perf =3D amd_get_highest_perf();
> > +
> > +       boost_ratio =3D div_u64(cppc_max_perf << SCHED_CAPACITY_SHIFT,
> > +                             nominal_perf);
> > +
> > +       return boost_ratio;
> > +}
>=20
> The function above is not necessary if I'm not mistaken.
>=20

Yes, right.

> > +
> >  static u64 get_max_boost_ratio(unsigned int cpu)
> >  {
> >         struct cppc_perf_caps perf_caps;
> > @@ -646,6 +662,9 @@ static u64 get_max_boost_ratio(unsigned int cpu)
> >                 return 0;
> >         }
> >
> > +       if (boot_cpu_data.x86_vendor =3D=3D X86_VENDOR_AMD)
> > +               return get_amd_max_boost_ratio(cpu, perf_caps.nominal_p=
erf);
> > +
> >         highest_perf =3D perf_caps.highest_perf;
>=20
> The above can be written as
>=20
> if (boot_cpu_data.x86_vendor =3D=3D X86_VENDOR_AMD)
>         highest_perf =3D amd_get_highest_perf();
> else
>         highest_perf =3D perf_caps.highest_perf;
>=20

Thanks to simplify the implementation. Will update it in V4.

Best Regards,
Ray
