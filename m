Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4624F3695A1
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 17:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhDWPIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 11:08:36 -0400
Received: from mail-dm6nam08on2046.outbound.protection.outlook.com ([40.107.102.46]:64480
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229995AbhDWPId (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Apr 2021 11:08:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j3rIBOgX7AaNlbmvj3/QcVwYAihUkOwrHGk9ZLxy5dklecezi2u7zfoHJrzdHek7cN/UBRFPZ2YYGYYHiTSR++8McqKq/lWSi8BjLAb6tZUj7KDjZ3h5wxTa2Buwxt6vGE8BszOyrxSDzP4Ry8OL9mu2V8cZM5nJ4ceLgQQj9TtmjSqqogiAXVRjJwV2adSDskf2tCCdKUasb7E3hA7Wsw7HZiihKsTQ3ZLvAKTsIRfa5EcYfXEcRVCkqVq0fsiVvyJKQAAgRmsGXP1wKEvT4NFARy4BgLpZOrXvaNW+OGQoF8N+HtAms19eN/vdCFsF8nLG1tmxQ4zLnNqagjn4Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ioaSO5bnv96k/z6pqQCvjki8yXV6x9ifyJ2hSJMlgjs=;
 b=OkIAP49Z3NZuqtnftkDKm+kLbglXY8B/F8GysSiUQtzkjDGEoviB6TooHVwIRTlahhVi/XP5v9+p+PwAr+LL+1RA1SpVo6f48xC41PgsO98epydISzg0qYZkRmRJX8B49nKocrl+SnM1jZf0aasY1+h/du6SI40qR3DUQQELmLF676zmVT7moI/5cZK6Xmxkj9kg9kQBFe2cXNGRrUU7n+b7FnWHd73/EmkN87YyFPZbFphpEpsG+UWoh2QoEp6/MNW9sUtp9LGXN4jGs4AVXnvI5QEUADIRk2hZ36+oKy7hnwLPQtSkB5BVlQiI+J3us1deWTTbt5wxVtIqwQaAyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ioaSO5bnv96k/z6pqQCvjki8yXV6x9ifyJ2hSJMlgjs=;
 b=i4UEgKN6nORI+UzmJRLinQ+NO5DXgHWvCvHi8S5Sr2j5rT49MNJIC/cPZsXkxSAG2ZtrL9eFWrISD2K8dlPQrzM7f8boqzAPhIMkZNErRGS81T0YKoYmXhSlGJXXWt24x5+cKG/S1VOZBv8NvLf1ficeJkcKgmhNV2R3s8b0Gok=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MWHPR12MB1248.namprd12.prod.outlook.com (2603:10b6:300:12::21)
 by MW3PR12MB4380.namprd12.prod.outlook.com (2603:10b6:303:5a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Fri, 23 Apr
 2021 15:07:53 +0000
Received: from MWHPR12MB1248.namprd12.prod.outlook.com
 ([fe80::f07c:dc0f:e7e8:416c]) by MWHPR12MB1248.namprd12.prod.outlook.com
 ([fe80::f07c:dc0f:e7e8:416c%4]) with mapi id 15.20.4065.024; Fri, 23 Apr 2021
 15:07:53 +0000
Date:   Fri, 23 Apr 2021 23:07:28 +0800
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
Message-ID: <20210423150728.GB688865@hr-amd>
References: <20210423023928.688767-1-ray.huang@amd.com>
 <CAJZ5v0iH0-YL-yVPSA2oJF7PGfQs5Tcv5ktH43xMLPAKysDXPw@mail.gmail.com>
 <20210423125208.GA688865@hr-amd>
 <CAJZ5v0i3QUbhRqBKDuNzYoxy254Kq-36G30cVWLazQo+uUhJTw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0i3QUbhRqBKDuNzYoxy254Kq-36G30cVWLazQo+uUhJTw@mail.gmail.com>
X-Originating-IP: [58.247.170.245]
X-ClientProxiedBy: HK2PR02CA0155.apcprd02.prod.outlook.com
 (2603:1096:201:1f::15) To MWHPR12MB1248.namprd12.prod.outlook.com
 (2603:10b6:300:12::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from hr-amd (58.247.170.245) by HK2PR02CA0155.apcprd02.prod.outlook.com (2603:1096:201:1f::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Fri, 23 Apr 2021 15:07:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b7043e3-89c8-467a-56d5-08d906699182
X-MS-TrafficTypeDiagnostic: MW3PR12MB4380:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR12MB4380FB273AC7AA2658389E6CEC459@MW3PR12MB4380.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3idY4dnDjsIwQB0lKwzoFUhNLtQlvlF+GeTdGFmMjUPAm/mGTJa8Lsgdwjw7JcWMRQEEwcnFpvCTyPTnItPMWifnkVKcdPQHUC4/vZgdnPIXM74J9LXvzvxT1GSVWojSK9VOoG5DGemFH3Lon86mRCqydMeiYhLBj83NwpyK4Tw/BS++BkRYuY8lW8q3+Zsg4dYEBE4CoRgM7hs5WhuCCEfFjQbgDpax0j+Z2hCTv82ZgF3komhSRComUSLWrPSJUQuHBdSmfuzF2HL25843e/6gvmwCphjYs3a8UXNEsByUIPf5Gy8fT2BfZ20SnKWZW4zIZMei7YexptNEIOO0qyrCncl3W7ov2xTr4f4rc/MgN/WK6gMxr2hDEAEAh8DtD0cfXKSxwiGr1sdKHJOidDd7xZVNuAcngweFM3pABDbgE8xVCiWZstY5LTX/VxDzsxlbR+W1ljobGrba01rm1FZcFp0Qg2p+4hPl+qSJfsYbulFpSZXBjGbVMABVUatI7tYQUfnI84DsuSGNyNGe2MFYRvOcOkNtN8lroUAmopIxVCWdlxLkZG2H9/oXWUap9v/yyhZq+aYUGQL8x+f3Fd1mPEPAb2j6GC6+/XNDh0kjPRT0zY3is8YuQr8ctjRyfh3Co4nXg3ClpwGlrylifOlbNr/Simz0Rbw270yWYRIOwCCG60nfhtKBSCPEdE92x7wJmYcxX/PO1oa0ZZl2wFdbsmaH69rEoIgMxROEzJs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39860400002)(366004)(136003)(6916009)(8676002)(6666004)(4326008)(33656002)(316002)(6496006)(38100700002)(5660300002)(52116002)(8936002)(38350700002)(966005)(186003)(16526019)(33716001)(45080400002)(55016002)(86362001)(956004)(54906003)(1076003)(53546011)(83380400001)(66556008)(2906002)(9686003)(66946007)(26005)(66476007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?GSCCBWyoYTAwRkwrvn2aUfdKRZaCrDNeFiWKZEtjRrDX8D4X+iRuzWMeZnHM?=
 =?us-ascii?Q?qdqJ80L/M4QGP0Zx+o4DrRq+wZsjrxPHazD4S7ZDSIGhLWDfaaNpezYM507p?=
 =?us-ascii?Q?jWAKye5nbHlJwo6zeDqmi5+gxFFTddTZF67ZxRrpWck9x76JHnBvlAbGQZwQ?=
 =?us-ascii?Q?VtIudOfFgzazdscorqIP5PukoeY4oMnhohh9VR1TC9lCJYbDJucftY+RptKz?=
 =?us-ascii?Q?YlsbiYxGReIHebpYeut2Rnlarkr1iO/niHwZksig9urxaCmrRk6kRuyJDzQ1?=
 =?us-ascii?Q?0M78ckDoXRB1xLe7U35Rf3gbmEzRElyi8IcRpYX3Duez7afucSux3hJ52jcS?=
 =?us-ascii?Q?KEkC99elbYWYYlzmy4I1SPIjFkAyVzUR0h1jbuY4ewfBE64iy5PFjVEImJam?=
 =?us-ascii?Q?M89PLaJnCRBAWNShM0F3b57hcBiE3qVBTEEvDi/aCtU0TxLQoNqMdqfDMd2D?=
 =?us-ascii?Q?nzzVFK/6kqzPcQKwxdYP8OirNuYpNn8cFOCiskhgjKBUpvQ1Rlf29k2OMtRX?=
 =?us-ascii?Q?qHGfEs21yo9k9yHh2tTzXmsTdzMEqDDnB1EMlQojbJDPZjhJvfB96skm3vrd?=
 =?us-ascii?Q?8V2+0/tihUTA100czcdT7KXaN8XToS5Qf6ChZrl0zabSYV8OjU8ED9xKmAfH?=
 =?us-ascii?Q?nFphBerrscGxexJzHypS4nkusCWRt9/i3f2rxXGXiRfaDWQ7GdHoea/SLB38?=
 =?us-ascii?Q?j2Soz4kvTxd91XrvTqIsaLG7yVUI9G3cRCz2fq55ipsxpB2jluUJz79hn/6f?=
 =?us-ascii?Q?s4Pp9wdSA4wY2q76kVYNvOlbnY8pexHhRm72ZpEXi1O30vpEp458aDtBPr+w?=
 =?us-ascii?Q?mgZTKA1jOIHfQ8T2cWIsxWfIRbpASmC/PyMYKrloOvSq35Z90d8Q8GfkfNne?=
 =?us-ascii?Q?pjH4pYPAbQVcO9QaqB9RWhtBnPgsdxN1rwz/Qznj6ZrzJCSohKiIGcAz6/bp?=
 =?us-ascii?Q?hI7jTWTWMtEnMr5CLSRUMFaQX016/zsiZcEswKOaD71kkk7PM53JsTWXvcwa?=
 =?us-ascii?Q?IFSvR74ZCg1uH2W+JNPU2Fkq9GyW4TcUFAGecoDFrWhTNu0oP/yS1fx5F7eZ?=
 =?us-ascii?Q?zwPLZQ/f7u9RI/xRafN+QBwsPNFF2W9GvyNEUyNkqPU2ybkOx3t9a6vCFeW/?=
 =?us-ascii?Q?QC9zNNXevW6iEy5dMKbdisbEX9nycVcnYHB1RqOKYbD9pX8ZW+TT3WHKGFMm?=
 =?us-ascii?Q?6REAwR/Ico2qTWaMcigaajyjzwKyYtgVHnlFufy6Ghu9eRewCg28SyRGPIHw?=
 =?us-ascii?Q?FimXOFrQHAC/ti0uFnbSYiOnTqMjtXBk0QpncYSzixTGfdcGD9S8ucYCcqCB?=
 =?us-ascii?Q?CCn8avvINxm0rGnqqsEX4jnX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b7043e3-89c8-467a-56d5-08d906699182
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 15:07:53.4465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FcJn+UxmV2IIMF22f/KTxRS1WV2dqeevzUI6Kwt8RjfQaob6re6a+jfINv6Qm3n1f+c+sh1xrsnP20S/kHUcvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4380
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 23, 2021 at 09:53:37PM +0800, Rafael J. Wysocki wrote:
> On Fri, Apr 23, 2021 at 2:52 PM Huang Rui <ray.huang@amd.com> wrote:
> >
> > On Fri, Apr 23, 2021 at 08:09:49PM +0800, Rafael J. Wysocki wrote:
> > > On Fri, Apr 23, 2021 at 4:40 AM Huang Rui <ray.huang@amd.com> wrote:
> > > >
> > > > Some AMD Ryzen generations has different calculation method on maximum
> > > > perf. 255 is not for all asics, some specific generations should use 166
> > > > as the maximum perf. Otherwise, it will report incorrect frequency value
> > > > like below:
> > > >
> > > > ~  $B"* (B lscpu | grep MHz
> > > > CPU MHz:                         3400.000
> > > > CPU max MHz:                     7228.3198
> > > > CPU min MHz:                     2200.0000
> > > >
> > > > Fixes: 41ea667227ba ("x86, sched: Calculate frequency invariance for AMD systems")
> > > > Fixes: 3c55e94c0ade ("cpufreq: ACPI: Extend frequency tables to cover boost frequencies")
> > > >
> > > > Reported-by: Jason Bagavatsingham <jason.bagavatsingham@gmail.com>
> > > > Tested-by: Jason Bagavatsingham <jason.bagavatsingham@gmail.com>
> > > > Bugzilla: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugzilla.kernel.org%2Fshow_bug.cgi%3Fid%3D211791&amp;data=04%7C01%7Cray.huang%40amd.com%7C9c4d68e3c053401c4b4108d9065f38b7%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637547828334533410%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=AEMijLiBtz7Tf%2F8Uh1XEd4QUclZUfafyEy48yMf4JSw%3D&amp;reserved=0
> > > > Signed-off-by: Huang Rui <ray.huang@amd.com>
> > > > Cc: Alex Deucher <alexander.deucher@amd.com>
> > > > Cc: Nathan Fontenot <nathan.fontenot@amd.com>
> > > > Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > Cc: Borislav Petkov <bp@suse.de>
> > > > Cc: x86@kernel.org
> > > > Cc: stable@vger.kernel.org
> > > > ---
> > > >
> > > > Changes from V1 -> V2:
> > > > - Enhance the commit message.
> > > > - Move amd_get_highest_perf() into amd.c.
> > > > - Refine the implementation of switch-case.
> > > > - Cc stable mail list.
> > > >
> > > > Changes from V2 -> V3:
> > > > - Move the update into cppc_get_perf_caps() to correct the highest perf value in
> > > >   the API.
> > > >
> > > > ---
> > > >  arch/x86/include/asm/processor.h |  2 ++
> > > >  arch/x86/kernel/cpu/amd.c        | 22 ++++++++++++++++++++++
> > > >  drivers/acpi/cppc_acpi.c         |  8 ++++++--
> > > >  3 files changed, 30 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> > > > index f1b9ed5efaa9..908bcaea1361 100644
> > > > --- a/arch/x86/include/asm/processor.h
> > > > +++ b/arch/x86/include/asm/processor.h
> > > > @@ -804,8 +804,10 @@ DECLARE_PER_CPU(u64, msr_misc_features_shadow);
> > > >
> > > >  #ifdef CONFIG_CPU_SUP_AMD
> > > >  extern u32 amd_get_nodes_per_socket(void);
> > > > +extern u32 amd_get_highest_perf(void);
> > > >  #else
> > > >  static inline u32 amd_get_nodes_per_socket(void)       { return 0; }
> > > > +static inline u32 amd_get_highest_perf(void)           { return 0; }
> > > >  #endif
> > > >
> > > >  static inline uint32_t hypervisor_cpuid_base(const char *sig, uint32_t leaves)
> > > > diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> > > > index 347a956f71ca..aadb691d9357 100644
> > > > --- a/arch/x86/kernel/cpu/amd.c
> > > > +++ b/arch/x86/kernel/cpu/amd.c
> > > > @@ -1170,3 +1170,25 @@ void set_dr_addr_mask(unsigned long mask, int dr)
> > > >                 break;
> > > >         }
> > > >  }
> > > > +
> > > > +u32 amd_get_highest_perf(void)
> > > > +{
> > > > +       struct cpuinfo_x86 *c = &boot_cpu_data;
> > > > +       u32 cppc_max_perf = 225;
> > > > +
> > > > +       switch (c->x86) {
> > > > +       case 0x17:
> > > > +               if ((c->x86_model >= 0x30 && c->x86_model < 0x40) ||
> > > > +                   (c->x86_model >= 0x70 && c->x86_model < 0x80))
> > > > +                       cppc_max_perf = 166;
> > > > +               break;
> > > > +       case 0x19:
> > > > +               if ((c->x86_model >= 0x20 && c->x86_model < 0x30) ||
> > > > +                   (c->x86_model >= 0x40 && c->x86_model < 0x70))
> > > > +                       cppc_max_perf = 166;
> > > > +               break;
> > > > +       }
> > > > +
> > > > +       return cppc_max_perf;
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(amd_get_highest_perf);
> > > > diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
> > > > index 69057fcd2c04..58e72b6e222f 100644
> > > > --- a/drivers/acpi/cppc_acpi.c
> > > > +++ b/drivers/acpi/cppc_acpi.c
> > > > @@ -1107,8 +1107,12 @@ int cppc_get_perf_caps(int cpunum, struct cppc_perf_caps *perf_caps)
> > > >                 }
> > > >         }
> > > >
> > > > -       cpc_read(cpunum, highest_reg, &high);
> > > > -       perf_caps->highest_perf = high;
> > > > +       if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
> > >
> > > This is a generic arch-independent file.
> > >
> > > Can we avoid adding the x86-specific check here?
> >
> > OK, I see, it will be used by ARM as well.
> >
> > Can I rollback to implementation of V2:
> >
> > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fr%2F20210421023807.1540290-1-ray.huang%40amd.com&amp;data=04%7C01%7Cray.huang%40amd.com%7C9c4d68e3c053401c4b4108d9065f38b7%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637547828334533410%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=Pk0VKl7iSaKz%2FYQx7YfT5D1XP%2FZRfQTW6moE%2F5sS1c0%3D&amp;reserved=0
> 
> This would work IMO, but it can be simplified somewhat AFAICS.
> 
> The obvious drawback is that amd_get_highest_perf() would need to be
> called directly wherever the CPPC highest perf is needed and the
> vendor may be AMD.

Should I send V4 to continue review (fallback to V2 actually) or you can
comment it on V2 directly?

> 
> > If stick to add quirk in cppc_acpi.c and avoid x86-specific check at the
> > same time here, the code will not be straight forward. Or will you have any
> > other good idea?
> 
> Not at the moment, sorry.

No problem, thanks for your time and comments. :-)

Thanks,
Ray
