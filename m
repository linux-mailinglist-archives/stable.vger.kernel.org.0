Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7642736A54B
	for <lists+stable@lfdr.de>; Sun, 25 Apr 2021 09:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbhDYHMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Apr 2021 03:12:51 -0400
Received: from mail-dm6nam12on2064.outbound.protection.outlook.com ([40.107.243.64]:40065
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229480AbhDYHMu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 25 Apr 2021 03:12:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i4iLS/Oseb0G9sv4Jmy48DbH+uR2DiEvEtd6jHbMkp7ptdtg+u9WFtJXl5Qs4wq2gF4UsBtbm4K/5hk/1Js+cm+oJC5urIgGUhRBpOyOAwaSOgYb25BroS6BNrzJC19nd10KyGI9TJXht0/rMVXGv7lKlXBzaf5RFyt2rsSdEq2RxIpM4Q63mMIagIdOW/lKnSPHgjE9w87DyMBP9KRVXW0saRG8ebixkUK8y7I0c0HjOZkBWDTeay8n9VYAs72GGuwpsU1WLlZn0REhxamlw6EMFXax9taKFWLPf8sT3gREMCVbTYBwZIFmP2QNoiGOYeHR/7VofOlUynORuwzoNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ntPUbZuVMYvNOVAtTlqCZEAXTK4RbRlTRv/+1+OgtEU=;
 b=dVRJ7NyNjtBCH4/y80+y8aS7eAR9soVBLolMj8UkTy3LlT4HInFlxQSYEkA6xQHd2elsvBTuJQrrWBBhdwXBqa/lxvN4SuwE6UaVvxvms+GFOkXfzrajSAXnTAma/zjOzliN9RuXHShhA7GI6na9uWoYd4/igRNLm0qyIoeYA/nUOPwsUr5u9Ju7h38Mc/QF5PtqJvya30bxXosLajfg4mHVcQxwBw0x7ACPy6ImydBLelN7Vp9l+7i3EJvXa3bsu13+t4N0GBp2jEaeC6S4wEG9Qt5edFmZWRrcaxYf9LbxvHxVYwq9VUMZsVD+fdEzrVxVYb7X76x7pbl4fozsZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ntPUbZuVMYvNOVAtTlqCZEAXTK4RbRlTRv/+1+OgtEU=;
 b=o8vkfp0eLBG2ZkfqzvkQv71NZJlg2tyVaOJTHhd7Mj/dHnN8zqolzBdELwFHOvyT48UAqE9JeuVPYZmSNjKKzyq2ghxdya6LWyqRMwXmzkjZEtyK06ZqOpKhsZZjViWaWXaS7C1cCs8WrfBkyqPg6Z3mm0MWZoLfP/c9lJ5vbR8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MWHPR12MB1248.namprd12.prod.outlook.com (2603:10b6:300:12::21)
 by MWHPR12MB1312.namprd12.prod.outlook.com (2603:10b6:300:11::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Sun, 25 Apr
 2021 07:12:04 +0000
Received: from MWHPR12MB1248.namprd12.prod.outlook.com
 ([fe80::f07c:dc0f:e7e8:416c]) by MWHPR12MB1248.namprd12.prod.outlook.com
 ([fe80::f07c:dc0f:e7e8:416c%4]) with mapi id 15.20.4065.026; Sun, 25 Apr 2021
 07:12:03 +0000
Date:   Sun, 25 Apr 2021 15:11:53 +0800
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
Message-ID: <20210425071153.GA2175798@hr-amd>
References: <20210423023928.688767-1-ray.huang@amd.com>
 <CAJZ5v0iH0-YL-yVPSA2oJF7PGfQs5Tcv5ktH43xMLPAKysDXPw@mail.gmail.com>
 <20210423125208.GA688865@hr-amd>
 <CAJZ5v0i3QUbhRqBKDuNzYoxy254Kq-36G30cVWLazQo+uUhJTw@mail.gmail.com>
 <20210423150728.GB688865@hr-amd>
 <CAJZ5v0hqVSd=F+H3hf9d8cxiVS3UgebEdvxAG_ZYj9Dk8a-N2w@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0hqVSd=F+H3hf9d8cxiVS3UgebEdvxAG_ZYj9Dk8a-N2w@mail.gmail.com>
X-Originating-IP: [58.247.170.245]
X-ClientProxiedBy: HKAPR04CA0001.apcprd04.prod.outlook.com
 (2603:1096:203:d0::11) To MWHPR12MB1248.namprd12.prod.outlook.com
 (2603:10b6:300:12::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from hr-amd (58.247.170.245) by HKAPR04CA0001.apcprd04.prod.outlook.com (2603:1096:203:d0::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend Transport; Sun, 25 Apr 2021 07:12:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f438102-167c-4fac-08ad-08d907b96d42
X-MS-TrafficTypeDiagnostic: MWHPR12MB1312:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR12MB131250C36A7B699F48514CF5EC439@MWHPR12MB1312.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KB3uU/IqGEhbF5/WwdFvO1MvJBhHFAW60vl0HnIh3rZtAd7cLma0Xi7mtPZi78ZcazxJAklUfLZP1hmu5DmYFvtMXpy6D6FdvZgelOqraQMd9Kdvn7T8Ou8AcVGg983XRmqT3+L2CIlnLJEvAUd2UjNW9aDMbg5S3Cy00Sug+dePr1lwOkOTcPuYzAXCqvm7ov4oH9cgmFd1vfz/mcqJrnCMlG9nvKp0CRmwvArP3TM8jfn1rotO+5HAjUk8+P+G7UTW+jptiuGVXRWbkb+gQZg7ISLkv+1lHKGtDywnDR0NfonVwH/qDPdu43+92GJe4+I6iq9iNjRxc7QF1BmjP2Kkl1O84RABkhaIu13wof8rzKy9pPQh2RBb1v1vneBqOvytlUMrAaeicv/lDL3+SxBhpSW5R8L4FdsDD3D45G2U8aomGQDmdizza5CQtUwSf1mHEx1Efz0KYQ4XiM8pKDAjcUlLI8KiEXTyXuu6D2R3AbUfhi9b1SsrlpfHonJzrpVeCcD3X4bVYPeF7n/CIngFHulZK777k45iAlQp0YzZqAUcv5O4WYUq1Xiu/3nHKEZLMikyH+FfuZgIV++UIYNTTZbvC5aYUv2s7GReNWhyK3lT7vcnBnrsMYb/eNfZCdiBcL2yqK/8bZu6oJVlALjU5qZwe5q8I3EPo3N54ly3EkadYsco6WZJQ8NX/s4zyp7lZ5k8PL7GNYLqJFi28RzAa42wNaQXpsAe/HETW/g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(6496006)(966005)(26005)(478600001)(83380400001)(66476007)(66946007)(66556008)(6916009)(316002)(186003)(9686003)(86362001)(956004)(33656002)(5660300002)(53546011)(45080400002)(52116002)(54906003)(6666004)(4326008)(38100700002)(38350700002)(1076003)(16526019)(55016002)(8676002)(2906002)(8936002)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?RV/R8W/ju6Fhw3dVFnB63JplmOhbzu+ssNjR3kFwle3NOKs03t/+BEx+BsMc?=
 =?us-ascii?Q?vBQtvNXGIxyx5Ayrfyq1g7nNWKSkgqr3JuWnvJc7TyjGcBwBkLVvDEpnFbeD?=
 =?us-ascii?Q?sARV4qQLhZ9mFSbLKQy0iIKJAO6mLZtfoSFlWUAPwbU5C52aBUenR7G6eots?=
 =?us-ascii?Q?FOrLtWNvaT+FDPe507UdXDjVLU+nJ14wJ+9xagr6KLfJmvSB+zTBvQxoXilZ?=
 =?us-ascii?Q?V/uI0xZwHR6n4p99D4BKjVMq0TFcyDv+P05V04RTxoIBrPJN33wtkxeEkA2o?=
 =?us-ascii?Q?rpSWpbG68MF2rcUjj7RuPdVK7Cm3JVKPPaXoqEpQ/PSKSXXiD9OokxFN3zH+?=
 =?us-ascii?Q?tOp+dK6gw6Pg2tf7BRrQYnIidhq1l3ykiUQEcaT1SAL2Q+uJ/g2EUjYySYUQ?=
 =?us-ascii?Q?gqwqnr5T/ELMR8CoRQ1hF+1/ND7VNbkrRhjkwbeOYXJ8s1QLwb6RBFo9bRhr?=
 =?us-ascii?Q?0L7l/v0UglIbvs30oLBtyeEXd49pMZn1sv+1oBUQUJYZpJ8E1XPrEchIP9yN?=
 =?us-ascii?Q?rfYQoDCjkTBTf5UyQcDX30lq203J7OoTtBqbFkN8SC65fxfiDUGXTvh7cMsT?=
 =?us-ascii?Q?ceha/GQfvKZS40bEbLwiHUU0rM7FCdn/KV6MqPh4zPjQCx1Wo6ZME3nUbu+j?=
 =?us-ascii?Q?VCWavxyIofjVAx0H+aPmXeq6x/CwvTm4wcdi+ChK2hoOUbFYtSOGR9dGBwGQ?=
 =?us-ascii?Q?RCtpwg+lIGBYv/KqAK2HKvcNcnc3KMnvRqAU6ApdzHyACnzHhkPOLItyNIuc?=
 =?us-ascii?Q?6qMxnvSzfbBB13J2OJe//8FwceYJB1FCLf9/xtF4fvA3txO/BFl9l6musVE5?=
 =?us-ascii?Q?vOEzgEGo+vcgKbsHxQFJeFHNw8Jjf5DvNKBzIpRwBxJ58FfS+8S4RVLDKuzQ?=
 =?us-ascii?Q?8Wg43uw10V6ITkRuilIejTEp5I9LMrlqtJEInayGFKaJUPJZr0QlBSGoBpdg?=
 =?us-ascii?Q?gKZ8INHOSFE5KoHoPlQ7hg42RVpTDkae8lEgqOwGuq2OFzRPiRWfAtcdG1/E?=
 =?us-ascii?Q?Wjm4JpYngDPSZoc5ZDho/u55pmAV0FRvehlBwjMxro4sHW7fmephwayBAV27?=
 =?us-ascii?Q?/doNsAq9vmcShIpsKVg6xxhNCUdR0MldXgCUpnuYUCgOjYpeQXhCfqeyFvnb?=
 =?us-ascii?Q?lyXYPrHWqaT87Tr2jD8Bnp3q3GWWejiDI+3oFqBf9PDmwiXB4EGBJ+G8xFyY?=
 =?us-ascii?Q?cv5hBnezjBOnSBU5SGZL8+KWamO5lvfq6oo2THi1mUV8iUU/Aty6pGp8OD8r?=
 =?us-ascii?Q?d4pPgYU2zpD4Qm45ibENoAyXFaYW7BmQHwFPbHBl9O9Vay8TC/Mp/2rw01XJ?=
 =?us-ascii?Q?9VXTjv1gg5yzuiCW6j+17zx1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f438102-167c-4fac-08ad-08d907b96d42
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2021 07:12:03.7282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9yNxKTeL1P1xWukBJ/LDKdfcCdxNAXGdiB8X4vwjHoWTH2ENyhizcD/CCdegt2JOOJ1VHw4dhtBQn0gAaHUdKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1312
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 23, 2021 at 11:20:37PM +0800, Rafael J. Wysocki wrote:
> On Fri, Apr 23, 2021 at 5:07 PM Huang Rui <ray.huang@amd.com> wrote:
> >
> > On Fri, Apr 23, 2021 at 09:53:37PM +0800, Rafael J. Wysocki wrote:
> > > On Fri, Apr 23, 2021 at 2:52 PM Huang Rui <ray.huang@amd.com> wrote:
> > > >
> > > > On Fri, Apr 23, 2021 at 08:09:49PM +0800, Rafael J. Wysocki wrote:
> > > > > On Fri, Apr 23, 2021 at 4:40 AM Huang Rui <ray.huang@amd.com> wrote:
> > > > > >
> > > > > > Some AMD Ryzen generations has different calculation method on maximum
> > > > > > perf. 255 is not for all asics, some specific generations should use 166
> > > > > > as the maximum perf. Otherwise, it will report incorrect frequency value
> > > > > > like below:
> > > > > >
> > > > > > ~  $B"* (B lscpu | grep MHz
> > > > > > CPU MHz:                         3400.000
> > > > > > CPU max MHz:                     7228.3198
> > > > > > CPU min MHz:                     2200.0000
> > > > > >
> > > > > > Fixes: 41ea667227ba ("x86, sched: Calculate frequency invariance for AMD systems")
> > > > > > Fixes: 3c55e94c0ade ("cpufreq: ACPI: Extend frequency tables to cover boost frequencies")
> > > > > >
> > > > > > Reported-by: Jason Bagavatsingham <jason.bagavatsingham@gmail.com>
> > > > > > Tested-by: Jason Bagavatsingham <jason.bagavatsingham@gmail.com>
> > > > > > Bugzilla: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugzilla.kernel.org%2Fshow_bug.cgi%3Fid%3D211791&amp;data=04%7C01%7Cray.huang%40amd.com%7C5e4ef90268394256017508d9066b6011%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637547880536218729%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=6UKHrjewjid2pnAFJTXen1xPVSwIAOkcDdiQMfORZmw%3D&amp;reserved=0
> > > > > > Signed-off-by: Huang Rui <ray.huang@amd.com>
> > > > > > Cc: Alex Deucher <alexander.deucher@amd.com>
> > > > > > Cc: Nathan Fontenot <nathan.fontenot@amd.com>
> > > > > > Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > > > Cc: Borislav Petkov <bp@suse.de>
> > > > > > Cc: x86@kernel.org
> > > > > > Cc: stable@vger.kernel.org
> > > > > > ---
> > > > > >
> > > > > > Changes from V1 -> V2:
> > > > > > - Enhance the commit message.
> > > > > > - Move amd_get_highest_perf() into amd.c.
> > > > > > - Refine the implementation of switch-case.
> > > > > > - Cc stable mail list.
> > > > > >
> > > > > > Changes from V2 -> V3:
> > > > > > - Move the update into cppc_get_perf_caps() to correct the highest perf value in
> > > > > >   the API.
> > > > > >
> > > > > > ---
> > > > > >  arch/x86/include/asm/processor.h |  2 ++
> > > > > >  arch/x86/kernel/cpu/amd.c        | 22 ++++++++++++++++++++++
> > > > > >  drivers/acpi/cppc_acpi.c         |  8 ++++++--
> > > > > >  3 files changed, 30 insertions(+), 2 deletions(-)
> > > > > >
> > > > > > diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> > > > > > index f1b9ed5efaa9..908bcaea1361 100644
> > > > > > --- a/arch/x86/include/asm/processor.h
> > > > > > +++ b/arch/x86/include/asm/processor.h
> > > > > > @@ -804,8 +804,10 @@ DECLARE_PER_CPU(u64, msr_misc_features_shadow);
> > > > > >
> > > > > >  #ifdef CONFIG_CPU_SUP_AMD
> > > > > >  extern u32 amd_get_nodes_per_socket(void);
> > > > > > +extern u32 amd_get_highest_perf(void);
> > > > > >  #else
> > > > > >  static inline u32 amd_get_nodes_per_socket(void)       { return 0; }
> > > > > > +static inline u32 amd_get_highest_perf(void)           { return 0; }
> > > > > >  #endif
> > > > > >
> > > > > >  static inline uint32_t hypervisor_cpuid_base(const char *sig, uint32_t leaves)
> > > > > > diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> > > > > > index 347a956f71ca..aadb691d9357 100644
> > > > > > --- a/arch/x86/kernel/cpu/amd.c
> > > > > > +++ b/arch/x86/kernel/cpu/amd.c
> > > > > > @@ -1170,3 +1170,25 @@ void set_dr_addr_mask(unsigned long mask, int dr)
> > > > > >                 break;
> > > > > >         }
> > > > > >  }
> > > > > > +
> > > > > > +u32 amd_get_highest_perf(void)
> > > > > > +{
> > > > > > +       struct cpuinfo_x86 *c = &boot_cpu_data;
> > > > > > +       u32 cppc_max_perf = 225;
> > > > > > +
> > > > > > +       switch (c->x86) {
> > > > > > +       case 0x17:
> > > > > > +               if ((c->x86_model >= 0x30 && c->x86_model < 0x40) ||
> > > > > > +                   (c->x86_model >= 0x70 && c->x86_model < 0x80))
> > > > > > +                       cppc_max_perf = 166;
> > > > > > +               break;
> > > > > > +       case 0x19:
> > > > > > +               if ((c->x86_model >= 0x20 && c->x86_model < 0x30) ||
> > > > > > +                   (c->x86_model >= 0x40 && c->x86_model < 0x70))
> > > > > > +                       cppc_max_perf = 166;
> > > > > > +               break;
> > > > > > +       }
> > > > > > +
> > > > > > +       return cppc_max_perf;
> > > > > > +}
> > > > > > +EXPORT_SYMBOL_GPL(amd_get_highest_perf);
> > > > > > diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
> > > > > > index 69057fcd2c04..58e72b6e222f 100644
> > > > > > --- a/drivers/acpi/cppc_acpi.c
> > > > > > +++ b/drivers/acpi/cppc_acpi.c
> > > > > > @@ -1107,8 +1107,12 @@ int cppc_get_perf_caps(int cpunum, struct cppc_perf_caps *perf_caps)
> > > > > >                 }
> > > > > >         }
> > > > > >
> > > > > > -       cpc_read(cpunum, highest_reg, &high);
> > > > > > -       perf_caps->highest_perf = high;
> > > > > > +       if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
> > > > >
> > > > > This is a generic arch-independent file.
> > > > >
> > > > > Can we avoid adding the x86-specific check here?
> > > >
> > > > OK, I see, it will be used by ARM as well.
> > > >
> > > > Can I rollback to implementation of V2:
> > > >
> > > > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fr%2F20210421023807.1540290-1-ray.huang%40amd.com&amp;data=04%7C01%7Cray.huang%40amd.com%7C5e4ef90268394256017508d9066b6011%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637547880536218729%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=jytSyFAHiOc3JdkHyTkD86Vsp9%2FT9e2OENqOTkDtt5M%3D&amp;reserved=0
> > >
> > > This would work IMO, but it can be simplified somewhat AFAICS.
> > >
> > > The obvious drawback is that amd_get_highest_perf() would need to be
> > > called directly wherever the CPPC highest perf is needed and the
> > > vendor may be AMD.
> >
> > Should I send V4 to continue review (fallback to V2 actually) or you can
> > comment it on V2 directly?
> 
> Done, thanks!

Thank you!

Ray
