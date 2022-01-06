Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F1048662A
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 15:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240154AbiAFOiA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 09:38:00 -0500
Received: from mail-bn8nam08on2046.outbound.protection.outlook.com ([40.107.100.46]:63200
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237699AbiAFOiA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jan 2022 09:38:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jf0JuJzJdtUANt5icPbJhIFmNs01Ws03vHsdehXt12Js1vNFhuS1hokarEmUYpyxvMe3nooLmCAe48HKbFyS35iILbajy9Mc1+3DPvf+A0N7SwDvlI5JZF9YFPPAgDAaee9nWC6w/ce2o+vB4abGBx4gjRI9SCRGiFVWaEmKEiIY/PrpKGT9qd+nAxXYywWxaOFMvOeGbC3Ea8Lf+qEua034cpHK3l7woiojdRrMY2ge6l+nV9Bw5oaWP/zin/NSvkatTo3UhvuqfSlMpGjqRvL84RzwgPRkWqEKb5qUiNm/KpuK9PKJZl50yohPXlAclzR7I2zzlX8XwGvTocZDAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GeSYsfzbpkE2GQspTJPNZ64bn7WqGQgLN4WLWbJm1n4=;
 b=CQhccmnqqzimsFhGSK01XgW2dH0nKcZNl+PslVjklgqwyl8plsXqNumFQjIdSxjZjdJT2uhZwjuihSiYdPELh8UwunHR6ieaR1sBfQaLiO3BbaTOdRwE/quRBTO8PdL54FiNVSs7bTwZtDxP/fitTI4KFc8/QgwHUEKlipS9scg3gl4ROhqx+rjc1L1XK1+tLJ4K5g/vNHhDo+IucScToFdfVaxXqiL7F2TQsvO1OVPf1T6dm1OFtP3BJH1MSbeUQQVJ1kX49xhFJODfttBhZb1adKcAgJN658Ha8dtthUx4vVyGY3C+V7M9qD5SiVMXEVr6OARU7iAwtSYF2P67zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GeSYsfzbpkE2GQspTJPNZ64bn7WqGQgLN4WLWbJm1n4=;
 b=2BtoxIMGP59NPWAo4Ghb/T79NqErsOYkReifg5Ji98vkLD/9cu1XGCmI9n6HDTlA95PJD+9z470RX/+9bIMATOnogq8sYiA7CbjL/86BKCoq9ltAcpI8Bo5x0eVhd5BD5CznADo5V0XdiNKS5bXY1+Q3ALDL80CBv9sLSp+8ZPQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB2504.namprd12.prod.outlook.com (2603:10b6:4:b5::19) by
 DM6PR12MB4155.namprd12.prod.outlook.com (2603:10b6:5:221::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4867.9; Thu, 6 Jan 2022 14:37:55 +0000
Received: from DM5PR12MB2504.namprd12.prod.outlook.com
 ([fe80::f02e:2cba:7c63:e368]) by DM5PR12MB2504.namprd12.prod.outlook.com
 ([fe80::f02e:2cba:7c63:e368%4]) with mapi id 15.20.4844.017; Thu, 6 Jan 2022
 14:37:55 +0000
Date:   Thu, 6 Jan 2022 22:37:32 +0800
From:   Huang Rui <ray.huang@amd.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yuan, Perry" <Perry.Yuan@amd.com>,
        "Su, Jinzhou (Joe)" <Jinzhou.Su@amd.com>,
        "Du, Xiaojian" <Xiaojian.Du@amd.com>,
        kernel test robot <lkp@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86, sched: Fix the undefined reference building
 error of init_freq_invariance_cppc
Message-ID: <Ydb+rHXsXqxzmR0V@amd.com>
References: <20220106074306.2712090-1-ray.huang@amd.com>
 <20220106074306.2712090-2-ray.huang@amd.com>
 <Ydbdq6lXPKFG98MY@zn.tnic>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ydbdq6lXPKFG98MY@zn.tnic>
X-ClientProxiedBy: HK0PR01CA0063.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::27) To DM5PR12MB2504.namprd12.prod.outlook.com
 (2603:10b6:4:b5::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6cfd79c0-bf86-4314-10da-08d9d1222029
X-MS-TrafficTypeDiagnostic: DM6PR12MB4155:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4155F662CE8857C54C8A0973EC4C9@DM6PR12MB4155.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hsHoM9b3/MDF85+ASEC/CH0WH+TF+9YbEgssBvMudgIBl4ouzC5tUQ/m+l7m0quWFEXiRiO4uyBu+Ubl3leyhqKOL+nrLUCp5lZZVIdMCAfvzaiF3qcyuGMPvRrIkpsfusVQj86dIud6VGxwSSeLutKbyWQfbyqnRwsavV6tVInMqcn1Ar7AO54Y0MtTZFAsDo182Aebg2jIUAID826zNf17VSojsVR5qbWCizyfdlOGMvIJjsdeAaNDwdWVNQN7EqT1JQS8fT7w8X88cPKcOI9PEkfy6cxBd/8JTTu2h2d2nDP8duKtJ/ry1FKIPpmX83EBLNn5QioGbnGQycqasOT/R5yqlWKvAtDEy0K8lTmXpu/0TtZTfznf8awD+0DCB0acbPfj9UC8CVkXW9fjKtxEmky0xRP54mI0XHVYqizc0Gvd8vv8lH4TizuN6cK1L9pYI1uI6UyREd11YOkgJoS1MIKx+4/t9o80qIBxBLGJBuNu7G66a8SFoj/3Oj17Z2xTKTuWIG98HPERLMPsQS0keN4/Ck1pCV0CyP2/EpTgszxmdj3BgMvaG0xbTPKh3q+SCYObJIJUpTtsmCyYYxomYmcZToFgDcjnAXA9S9SE0iP07koL5X5BKr1wOMAAaWxIbznCbfZCwIdZAENOKw1YqRkybRxzJtDqJp34qvbg9Wb1dt+WhG4E+m57r+NRPuM5p9w15sm7Pg/AKBYaHAR/hF/yHh08XSU6bZoFWZGWQeAI8v7D4mTZpsiUGEJW9oK7BWlyARmhLtLTFJwBJO9nXqK3dKLrdiWHX9mnt7A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB2504.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(6486002)(38100700002)(6666004)(83380400001)(5660300002)(316002)(508600001)(86362001)(6512007)(36756003)(26005)(7416002)(45080400002)(2616005)(2906002)(66556008)(66476007)(54906003)(66946007)(186003)(966005)(8676002)(8936002)(6506007)(6916009)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m3L7S/BatX6jAMtqreVnIaP+BnT7ay4FWdcLOXr8SJL6ZcliybJANS4uep+S?=
 =?us-ascii?Q?vhkNm5rAdFOJiU3Obg+6ZHzLi9SMMo8oL05A5vvwN0G9gx6CbhOi4BqRGvTo?=
 =?us-ascii?Q?rv617FUFFFTvUH9zBOgkJn5ne6mBGIOH3rH9UDQLR17V0NyvjU2Mp61SHZWK?=
 =?us-ascii?Q?TfqtvkWbbtiSsNbRvPb0YRMlPKScJFZyBvmPrmR/zPRtl7yfjvTj2/zPQKpC?=
 =?us-ascii?Q?uy2mHNVRs3YZX/sk8cX58f25jKcnC2b601ty0v6ZUayO43GLD1j9bh6D7L1a?=
 =?us-ascii?Q?7KdIjtuUUS4pAiy6KW4fN4r1XUMddEllGqz79eE7R66oQPx0nCPKysx4Szzx?=
 =?us-ascii?Q?1net09fiIDla4Jkm9iqjb+H5aOPjxKX/JLbNHIxlrCa5em81JpUcOjobJXsO?=
 =?us-ascii?Q?KyfWnVOravvi7799MmAfqTO0wcv7pHTjExELvKlBORVY/SdXRdM/ldDKGzod?=
 =?us-ascii?Q?v53iCp0FVxRgDCETzYktua0GCGEvoewFWR9JnGXLlnu9Mokc2tT4NfRTKwnq?=
 =?us-ascii?Q?wo0rvmIKkve1m1RS7lrzi0SL1QWI+aXS/gFkYYCU1KZdTbkqX21QV3p17CIV?=
 =?us-ascii?Q?P5nC7K58e9F/U2mxL7p8a/bwi47EBjqNihmZCD8gq+0Mcd5auSa3UyYGu1Xo?=
 =?us-ascii?Q?swvY7JNHbC8y6mB0voH7CIothv4oWUkP4+o9+I9nPXziu501eJrznESvWkKU?=
 =?us-ascii?Q?IZVcokAya7ZtmSpKrTjvWETpt6V/8cZEJ+J+RuRA7v5KIwhVZN0eHZ4RU8wZ?=
 =?us-ascii?Q?Dsb2hhY78Nb72O8xxUDuJAAOSxwnON4RQf56RohkWS5s4Ch+t9PZ9GosRQVG?=
 =?us-ascii?Q?kQfTeYk4EhUE5OqxLZ2HJXMFWHfWn7NVDp8mAWRfXNZtJsRGpwdVw8+nu71M?=
 =?us-ascii?Q?MQKZI6gsml/UtREroRd/dC1ZSd/vxy3ddfQkRWGgYSvgkmeAPjLRK8RHNSvN?=
 =?us-ascii?Q?+lGntusDVElJQ0iMvzJp+kW7NJRjRZ0aQIq+cpU6XT1w2mzilUcvjaggwBxF?=
 =?us-ascii?Q?XREQXAHPSF7TpezzuePWkDLAZ0J/ruYChKn/0jJnzunbt6KGO2QXcqpF7dI4?=
 =?us-ascii?Q?rdIwhAovLjmXoey3AS+S7elPjWtuC5RUz4I5FL9Os5DeFIBcktlGcIMDyzBr?=
 =?us-ascii?Q?L9aKr1VmtQcMRdZMDu1KuPdt+vzENsHvqJJgLFxqh61ge2SU7FYG64ZsBSNh?=
 =?us-ascii?Q?MoI/Q/HEf2yoNlUCB90QLO2sxGHqaG9IaW6MCV9kVMryRCCKffE5E7Zj8fnn?=
 =?us-ascii?Q?emWOjVdiSYBUeQWk4Eh4CMQdVWZ0ujoFOl5YRwAUkVHyuRm5SMAkFjooHjPR?=
 =?us-ascii?Q?ka63lRA0E5I7XqQ2VOq1iQJl1rTlryiWgvTtUDjm+e4QPWvSIKeZcId8OLCG?=
 =?us-ascii?Q?FkiZ2uwasjUKqbPqpkHOKdLW1uY//KALoPzoMufkzL7NRTrKrW7gn/eDkoci?=
 =?us-ascii?Q?fo9XWhbUg8Ud979owx369QS4AF1q7QLRCc2pkwAZbeEexQ1+SV2Gqw4JIW6K?=
 =?us-ascii?Q?6gAlE94cIfhZON2GwQAcdfVAToIznz4WJ8F0uLwKBJEecHol9iVf56sWRIWK?=
 =?us-ascii?Q?kcHeOwS+Op0Skx3FxZ/dzEeozPFRQLBRQHy4qJEz0OafU9eoh0HLoppZmg8R?=
 =?us-ascii?Q?6sooBW4qVUM+URm9U3Oi8Ws=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cfd79c0-bf86-4314-10da-08d9d1222029
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB2504.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 14:37:55.0791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Defx7PqjKQwMYLBCosdWjzaBb2lzKtbM6a//WlmnYgLb1G/lr9S8k3ZvsoVSDbjlKASYoUnKtSsoyU+NhaR8wQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4155
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 06, 2022 at 08:16:43PM +0800, Borislav Petkov wrote:
> On Thu, Jan 06, 2022 at 03:43:06PM +0800, Huang Rui wrote:
> > The init_freq_invariance_cppc function is implemented in smpboot and depends on
> > CONFIG_SMP.
> > 
> >   MODPOST vmlinux.symvers
> >   MODINFO modules.builtin.modinfo
> >   GEN     modules.builtin
> >   LD      .tmp_vmlinux.kallsyms1
> > ld: drivers/acpi/cppc_acpi.o: in function `acpi_cppc_processor_probe':
> > /home/ray/brahma3/linux/drivers/acpi/cppc_acpi.c:819: undefined reference to `init_freq_invariance_cppc'
> > make: *** [Makefile:1161: vmlinux] Error 1
> > 
> > See https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Flkml%2F484af487-7511-647e-5c5b-33d4429acdec%40infradead.org%2F&amp;data=04%7C01%7Cray.huang%40amd.com%7C4c696d3f23ac4479dda108d9d10e6a53%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637770682133383506%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=9lC2az1xGeYn7fNputkUMsy7PIhmkqW8jdpDUsaWthI%3D&amp;reserved=0.
> > 
> > Fixes: 41ea667227ba ("x86, sched: Calculate frequency invariance for AMD systems")
> > Reported-by: kernel test robot <lkp@intel.com>
> > Reported-by: Randy Dunlap <rdunlap@infradead.org>
> > Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > Signed-off-by: Huang Rui <ray.huang@amd.com>
> > Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: x86@kernel.org
> > Cc: stable@vger.kernel.org
> > ---
> >  arch/x86/include/asm/topology.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
> > index cc164777e661..2f0b6be8eaab 100644
> > --- a/arch/x86/include/asm/topology.h
> > +++ b/arch/x86/include/asm/topology.h
> > @@ -221,7 +221,7 @@ static inline void arch_set_max_freq_ratio(bool turbo_disabled)
> >  }
> >  #endif
> >  
> > -#ifdef CONFIG_ACPI_CPPC_LIB
> > +#if defined(CONFIG_ACPI_CPPC_LIB) && defined(CONFIG_SMP)
> >  void init_freq_invariance_cppc(void);
> >  #define init_freq_invariance_cppc init_freq_invariance_cppc
> >  #endif
> > -- 
> 
> Well, since that function is in smpboot.c then the logic should be that
> CPPC depends on functionality in smpboot.c for proper operation.
> 
> IOW, ACPI_CPPC_LIB should have "depends on CONFIG_SMP" in Kconfig, no?
> 
> Instead of adding more ifdeffery around...
> 

Hmm, yes, that's fine. I will modify it in V2.

Thanks,
Ray
