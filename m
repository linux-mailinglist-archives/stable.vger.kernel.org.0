Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA37E3679E7
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 08:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234734AbhDVG3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 02:29:31 -0400
Received: from mail-dm6nam12on2079.outbound.protection.outlook.com ([40.107.243.79]:3265
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229547AbhDVG3T (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Apr 2021 02:29:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MHyss035x0OtMjtDPkakv5eAcB6DlLFSMx7munOzi95tZy06Xy3ImiVrxVFOj9qjo6dr/bbyV0cLNATu6Hp2i9CO0uuspPP0XbVplb4BucZtnS/kvhUnpKAgYPd00BSMS2TM3RkYqaK/YtWeJKuJhwm+avcR4bTCHLdVxegQ0nvLDXnqwPsnupIKpy7HBaOL4BVfdMggLHM283ugeRm/ug8WRPNc1Bo2EUIMdwNWpbQGhkOOyCjptetpilhhkCkgt3B/j3wki0qr6CthDjz8mM8xEElKlwhzy+i6iKmI3WOEl8OgpaguM4TyUY7oIqr7z3Wvh3PHMFQSioQdX5z3eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AVsKNxIj/Qqls/jHtk8ybXcMpGxmAX5Zt0z91T77qb0=;
 b=ZbYWOUN5BfPGmzAvoVMkzuyH/PZ5qSNoE5xaQXjAH/u70sNhGooQYF5TaKElcv0gOkys3EAG1IDSXOGbd4hfKT6MzjuOfSh+yjg0Nth7FZ9vgm2LONpF21Pa1q31rkzfIszojcVSmCNVXMGaXi6s8w1VXxp4Uid0r0HxqU/2304pSZJCpeN20HNtUZPmqewKHqWlag9kRqOZ6J1nsIX0p9UefHZP/F4S7dWzd+ah3PUqBdnIQvKXtuQXFi/DWyzbFKpccq5FGPtHDmufk3gchYtMfr/v/bVckkYeMIaR25FeAwc0yyifu/DezHBuUtIOm2GMSP2qYyIFZWbxzacl9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AVsKNxIj/Qqls/jHtk8ybXcMpGxmAX5Zt0z91T77qb0=;
 b=e/jFODTFykqre4CP2pmKKAucXDldSuSKOh5neVdPwi7WsG4HaR5kJuiBVVqS5NlKh+scMOZW1CAU8GNLLhZNUeDrz78cYSbfEr1GYRhqexh/tOJfCwxBjgb96MiDnlkszhWNdoUc3PfD7+IDk08kjmWiw2lfs7DL386iNE9pdgc=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from MWHPR12MB1248.namprd12.prod.outlook.com (2603:10b6:300:12::21)
 by MWHPR12MB1520.namprd12.prod.outlook.com (2603:10b6:301:f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Thu, 22 Apr
 2021 06:28:31 +0000
Received: from MWHPR12MB1248.namprd12.prod.outlook.com
 ([fe80::f07c:dc0f:e7e8:416c]) by MWHPR12MB1248.namprd12.prod.outlook.com
 ([fe80::f07c:dc0f:e7e8:416c%4]) with mapi id 15.20.4065.020; Thu, 22 Apr 2021
 06:28:31 +0000
Date:   Thu, 22 Apr 2021 14:29:21 +0800
From:   Huang Rui <ray.huang@amd.com>
To:     "Fontenot, Nathan" <Nathan.Fontenot@amd.com>
Cc:     "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        Jason Bagavatsingham <jason.bagavatsingham@gmail.com>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Borislav Petkov <bp@suse.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] x86, sched: Fix the AMD CPPC maximum perf on some
 specific generations
Message-ID: <20210422062921.GA3687816@hr-amd>
References: <20210421023807.1540290-1-ray.huang@amd.com>
 <f1ae7cfb-ae34-3684-b191-c9a1f7f14240@amd.com>
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f1ae7cfb-ae34-3684-b191-c9a1f7f14240@amd.com>
X-Originating-IP: [58.247.170.245]
X-ClientProxiedBy: HK0PR03CA0114.apcprd03.prod.outlook.com
 (2603:1096:203:b0::30) To MWHPR12MB1248.namprd12.prod.outlook.com
 (2603:10b6:300:12::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from hr-amd (58.247.170.245) by HK0PR03CA0114.apcprd03.prod.outlook.com (2603:1096:203:b0::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Thu, 22 Apr 2021 06:28:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13ce9bbd-7573-4eee-ba6c-08d90557d915
X-MS-TrafficTypeDiagnostic: MWHPR12MB1520:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR12MB152059EC89828FE1ED1B9578EC469@MWHPR12MB1520.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cfeqEFebmsoijdwgpBFJtIBACGaTJpwQSidjsJYs6cQOVZnNmsedSqV7TJtEg1lTRevxLwLEh1vVmVRLGYEtH4RTpXr/5B7rZMMNx7Z18NQ1rAPJJtG8aHkYhSSlwAs5bj5QCKfLnHVbXYJlsA2BcrFORocSmQwgO4ogskRED7XecRdO9YDwncf0eregpj4+wecXnqk7jYnCwZ7F0X+5ENK4XNCoLKX/G0H4zaCn9ggJSSLsK9yypkr7y2D3+jfa/Mapp1yAAFaDsLcn53lyAMezGW2QNmHwt1j6gUMI69qsxcSpqetc/app0UCuppI+bucvVmVkxb3JUENrnOUu7AbVJxac/RealLT+3xXxZ/xeRBo6FH+MEqGaGEuCMBD/ecmT4Khqduv5aFZuUBfzxOnsWqMK5QFNLE1XEwtdMHlOXGDFh7lL36hjDOzRCtcj/+MKLlduTZawNRB0DW3MpMsV6yOTHJxvNhxn+cBGlW2LkkTaWrWDPwoMW685XMyDG2f0W2J48Xd8mqDb4hl8zyXVlv8lN8EjcKxr5atTN6MaFqDQtTg3AXFNVCliztHPEqeF8TnzSan5ZCCNOaXnYOeLp+ndG4gIuqkvEFPhVEl1rRawz64IcI8615hZHqjq7i9G77QcjpNEcs2PmOSINNnI0UZ5Hko6Vvgse8zKOyyJ7pMErxs67vbanPdi9cV8FzePZpBEZcrDSdqT11MGhljhWWknj+h5EmMa4LheSzc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(136003)(376002)(346002)(5660300002)(53546011)(8676002)(956004)(54906003)(33716001)(52116002)(8936002)(9686003)(6666004)(66476007)(4326008)(26005)(6636002)(66946007)(478600001)(316002)(66556008)(16526019)(38100700002)(186003)(83380400001)(1076003)(966005)(33656002)(6862004)(6496006)(55016002)(2906002)(38350700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?gb2312?B?ZXd4NGNmK1lmeXU3UlhQOWcwcmxZRHQ0SVRyK0lsQlcvdGJ2YitJVEhpSWJP?=
 =?gb2312?B?U0o2a21rZncwT0Y2dVBmUTJYTTh2MGlzY21rSE92RVFUeGFmMlJNaUlRT0kr?=
 =?gb2312?B?eVRFQUZkY1BOTzgwR3VXYTF6WEJHTFpmdEh5OWphK1NXQmlFOG5tZzBYdE04?=
 =?gb2312?B?NXZKeTl2YVlpL3VCYU9MTUh0OXg2QzlTMk9xclF2TDZHK0lnWXByZzlsK0t3?=
 =?gb2312?B?Mzl6bUFQZkhqOEtrRDRtVFY4VCthTXo3blczZ0MwMjB0a1p5czFobnpjN2tx?=
 =?gb2312?B?VXorNG5UVm1Zem9DRFEzbjNaWE5NeS9mYTFhVFk5a2RzU0ZVazI2Rlp4ejRG?=
 =?gb2312?B?NnVzR1c4V3ZQTWplTFVHVFBTMVFlc1o3RnA3R0RYTXZMR2FzUjYwcXJ2bjlQ?=
 =?gb2312?B?UTJVVERoeWovcWpRWTlyOEhoV0RsNUh6VkpVYUhIcWswRGtHTVNScFFCRkZu?=
 =?gb2312?B?RkZSa3hFRlJoYmV6eWVndUE1ZXVhWDlUVkhOUndRV1ppUTB5WTBxaWcyK2l1?=
 =?gb2312?B?SEdTczdBWHRKTFJZczRPYjVyZnV5MnBSckMvWmIwTmtIdDZLZnFmK3JMMW9l?=
 =?gb2312?B?NVFJdHI4elg4VkpLOSttZGpxd1Z6NGVRc0FCUmR0MzdqMXp0RVdvbkp1Rkt5?=
 =?gb2312?B?eXlxZnJUV3hCY3VCUmlFYjZQMGJpQjVtbER0YWJtaHJja1psdWZuMEJjYVQr?=
 =?gb2312?B?b0ZScDNlK01jL2ZkZ21sMU9nQ3JZR2VGY0VxQ1VKWjdQdFFrdElMdll2SUZ3?=
 =?gb2312?B?N05uTGFlaFptcktmczJSd3hZU2hXRGtERkxlOEpseDA5anRIOFhpcTYrT1lU?=
 =?gb2312?B?cThFRmorK05pbmRJZWR1Y1FxU01ENXZTaHl3SzlKSTlmODlhK2RJeDR4REQx?=
 =?gb2312?B?cEVEZUkzcFAwSXFTSkpacjIzSEMybS9HUUhubFh5cjdRbnJOZWs3TUpTZ0hV?=
 =?gb2312?B?YW4wdFZkRDFndW9iTVhhMzdiYmlEY1NiQVlORlVZYkNIL0NuUHc3M01GOStD?=
 =?gb2312?B?R1NzZ0hXbUdtYjJtV1YxQUhIMlZCanJiZGxuVyt6TE9aT0N6U0x6V1J4M0RZ?=
 =?gb2312?B?b0VpS3M4dW02S09kWjN4UVRZWEhGYzJ5elluNlpXUTJGUFF3eEl0RWxJbVM1?=
 =?gb2312?B?T1BTNFYvODl3ckxtdUtWejhobXlINlR4UzhxS1B4SFhWZEh4QmRGQndKTG4x?=
 =?gb2312?B?bDd1aFJUMEtqaDdpVXI1N0U4dVhRTEROZTVQNlk2SHIwQjlsc2grMjJ3d3hE?=
 =?gb2312?B?amRZaHJyR1czaHVPNWFPZnFXRTYydkI3bkgrcmVXL1hxc1VCOWJLTUdCMStp?=
 =?gb2312?B?YkFNUFI1aFV2bDdjQURMUmxORVo5eUZKblhVbGJidUlFbi9wS3U0RFEwL04x?=
 =?gb2312?B?ZytpYjhOckw2YkhucVR3S0hqK0ZBTGFnOG9zZ0ozWStESDZ5Q1cxUVcvUnlw?=
 =?gb2312?B?RFgvLzdqTHJ2MklidEtzdTM0ZmNLaG1Bekp6MXRQdkVIQTFsK1ZmcFBveTFu?=
 =?gb2312?B?aE9hdSt0cnh3ZTZJZ2R6b25WbER5THZFUUNJNlFyVzBhOGZRTHBlMDNUQVV2?=
 =?gb2312?B?TnMvTUplbHliSURvUjVmTjBWMWhRamcxVmk4Tm9Fd1dVeUNGRVJUbjEyUFRX?=
 =?gb2312?B?d2poME1leldkYTcvSk1hQzlYSWJqVHhlYjhYYzZ3bXM0dlJvbXhEanVHY014?=
 =?gb2312?B?ak1Sc29kaE1URTFCV3Z6SzhLZzJBOEp4SXlMc2VDaFJwUCtEZkNKL25salZE?=
 =?gb2312?Q?Dn1Snf7NjnU0iLHdm/Yl1hPpSf5nPgOcHQzxHXf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13ce9bbd-7573-4eee-ba6c-08d90557d915
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 06:28:31.7037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9CWtU18efGpQloPtOqZjmL//SpLM29KPkJvmWckeqISLcIf11XEF+wpWQ8QCSt15FVszgltmPLYvZe9i6hwsXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1520
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 21, 2021 at 09:42:15PM +0800, Fontenot, Nathan wrote:
> On 4/20/2021 9:38 PM, Huang Rui wrote:
> > Some AMD Ryzen generations has different calculation method on maximum
> > perf. 255 is not for all asics, some specific generations should use 166
> > as the maximum perf. Otherwise, it will report incorrect frequency value
> > like below:
> > 
> > ~ ¡ú lscpu | grep MHz
> > CPU MHz:                         3400.000
> > CPU max MHz:                     7228.3198
> > CPU min MHz:                     2200.0000
> > 
> > Fixes: 41ea667227ba ("x86, sched: Calculate frequency invariance for AMD systems")
> > Fixes: 3c55e94c0ade ("cpufreq: ACPI: Extend frequency tables to cover boost frequencies")
> > 
> > Reported-by: Jason Bagavatsingham <jason.bagavatsingham@gmail.com>
> > Tested-by: Jason Bagavatsingham <jason.bagavatsingham@gmail.com>
> > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=211791
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
> > diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> > index f1b9ed5efaa9..908bcaea1361 100644
> > --- a/arch/x86/include/asm/processor.h
> > +++ b/arch/x86/include/asm/processor.h
> > @@ -804,8 +804,10 @@ DECLARE_PER_CPU(u64, msr_misc_features_shadow);
> >  
> >  #ifdef CONFIG_CPU_SUP_AMD
> >  extern u32 amd_get_nodes_per_socket(void);
> > +extern u32 amd_get_highest_perf(void);
> >  #else
> >  static inline u32 amd_get_nodes_per_socket(void)	{ return 0; }
> > +static inline u32 amd_get_highest_perf(void)		{ return 0; }
> >  #endif
> >  
> >  static inline uint32_t hypervisor_cpuid_base(const char *sig, uint32_t leaves)
> > diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> > index 347a956f71ca..aadb691d9357 100644
> > --- a/arch/x86/kernel/cpu/amd.c
> > +++ b/arch/x86/kernel/cpu/amd.c
> > @@ -1170,3 +1170,25 @@ void set_dr_addr_mask(unsigned long mask, int dr)
> >  		break;
> >  	}
> >  }
> > +
> > +u32 amd_get_highest_perf(void)
> > +{
> > +	struct cpuinfo_x86 *c = &boot_cpu_data;
> > +	u32 cppc_max_perf = 225;
> > +
> > +	switch (c->x86) {
> > +	case 0x17:
> > +		if ((c->x86_model >= 0x30 && c->x86_model < 0x40) ||
> > +		    (c->x86_model >= 0x70 && c->x86_model < 0x80))
> > +			cppc_max_perf = 166;
> > +		break;
> > +	case 0x19:
> > +		if ((c->x86_model >= 0x20 && c->x86_model < 0x30) ||
> > +		    (c->x86_model >= 0x40 && c->x86_model < 0x70))
> > +			cppc_max_perf = 166;
> > +		break;
> > +	}
> > +
> > +	return cppc_max_perf;
> > +}
> > +EXPORT_SYMBOL_GPL(amd_get_highest_perf);
> 
> Should this be an update to cpp_get_perf_caps()?
> 
> This approach would ensure that all callers have the correct value
> and remove the need to fix up individual callers to use this new
> routine to get the correct value.
> 

It's a good idea to modify cppc_get_perf_caps() to correct the right
highest perf. I would like to keep amd_get_highest_perf() function in amd.c
as well because it can be called in other spaces without querying an ACPI
register in case only wants to get highest perf value.

---

diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index 69057fcd2c04..58e72b6e222f 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -1107,8 +1107,12 @@ int cppc_get_perf_caps(int cpunum, struct cppc_perf_caps *perf_caps)
                }
        }

-       cpc_read(cpunum, highest_reg, &high);
-       perf_caps->highest_perf = high;
+       if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
+               perf_caps->highest_perf = amd_get_highest_perf();
+       } else {
+               cpc_read(cpunum, highest_reg, &high);
+               perf_caps->highest_perf = high;
+       }

        cpc_read(cpunum, lowest_reg, &low);
        perf_caps->lowest_perf = low;

---

Thanks,
Ray
