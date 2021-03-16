Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A1E33D4F4
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 14:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235158AbhCPNgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 09:36:36 -0400
Received: from mail-bn8nam11on2089.outbound.protection.outlook.com ([40.107.236.89]:24384
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234656AbhCPNg3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 09:36:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JTSjdoQKIPdbMxvua5fXsEROjIh9RnRNV3lcoSsywQlzsn8lzYxSyX2PyKAAaemtGpRTY+0qIuZqLdLK+H604RasNyKBxjq9KZcLenshO6bj2IU3IrbI26lBb5H0OJ17qKC83GI4I1PV9Oe4eZ47ZXPu1DP7FyPIwic0/FD/UEpkC8LLjho3lnNcfX6LzwTdPSram8xjlnLSe3pNK0gaKcQycYtAoKYk5JGWUay7llrplRh6F1PDiS2RfRtmmzOgGbmgu+0G2w5paBgh1XDaFsGYP9jb763f0AFPe/2JFicI9wJsVKdPTgD017K9NiQKIH/htuzWVf10zEKSqIf1gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D9/qQjsiqZdFKMAzwnL3ebuQj3GODdbrLT9J9hnKlT4=;
 b=cF49OOfmxW1/b27rnr28/UuVl9ZL9BUpQfgeg5llj4d2SctLQohN9NbBpuTF488iDPt/gWfVv55kU6iOpQDay7op5QqA49sQxt/xBdp5BkbFSmXcYUJtCLrL5Hrp5oy6mKvypuv9RduzRajxDXIZ/2InrRzVTTqJ+cstph/N+mIcKkm5oo0PnCCyc8LVoEJh2vMkCx5xAmUyqAkC4+8l7Nzrv5h54mbiXB4MtdwTEsPljmV5rgAQ7IkzfeG0+D1XaYTcgRF2IDgSxz8X9xrlc4FRJvbw64/pwxvyKF9xcebS90L+0W2bHxVvWrwBJi72W9uSMnmZZilK0dg3Uz3KPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D9/qQjsiqZdFKMAzwnL3ebuQj3GODdbrLT9J9hnKlT4=;
 b=e1qfa2hj3rRLZZI+KABqItS3OGCLPcbgq6KnKMrRfz3bEVyDI6V+U0XFLtd621xuEcGKVrRgTbrESxrzOPvBRHM/3cIEgCPcCWceInxMO6cHha22/GwZ3BCP8Ig045te5lP9gbqWyC33VZ/DkNN64x6EoZYdpn5BdIO9gjQMHow=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=amd.com;
Received: from MWHPR12MB1248.namprd12.prod.outlook.com (2603:10b6:300:12::21)
 by MW2PR12MB2457.namprd12.prod.outlook.com (2603:10b6:907:10::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 13:36:26 +0000
Received: from MWHPR12MB1248.namprd12.prod.outlook.com
 ([fe80::5094:3a69:806f:8a28]) by MWHPR12MB1248.namprd12.prod.outlook.com
 ([fe80::5094:3a69:806f:8a28%5]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 13:36:26 +0000
Date:   Tue, 16 Mar 2021 21:36:02 +0800
From:   Huang Rui <ray.huang@amd.com>
To:     Joerg Roedel <jroedel@suse.de>
Cc:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "Du, Xiaojian" <Xiaojian.Du@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] iommu/amd: Fix iommu remap panic while amd_iommu is set
 to disable
Message-ID: <20210316133602.GB2497230@hr-amd>
References: <20210311142807.705080-1-ray.huang@amd.com>
 <YFCvsort3oZGfDBy@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFCvsort3oZGfDBy@suse.de>
X-Originating-IP: [58.247.170.245]
X-ClientProxiedBy: HK2PR02CA0163.apcprd02.prod.outlook.com
 (2603:1096:201:1f::23) To MWHPR12MB1248.namprd12.prod.outlook.com
 (2603:10b6:300:12::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from hr-amd (58.247.170.245) by HK2PR02CA0163.apcprd02.prod.outlook.com (2603:1096:201:1f::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend Transport; Tue, 16 Mar 2021 13:36:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 45131a7f-96ee-4ea1-6723-08d8e8807f2c
X-MS-TrafficTypeDiagnostic: MW2PR12MB2457:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW2PR12MB2457925448E07D2028A6910EEC6B9@MW2PR12MB2457.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eqY76JzBherggukw6dRSqFOch6HS2HhnZcVdisML8v7IuqMCnd+4g3pASsfUPqD8rZ+IkRwzdJ7CnQKA6c5h/nfSFQY66U7UIEmGpAS+fPjMosREdbB5WKIYPYG1BSjFqDsm6OyblU45YXqKB85rTzQowKv0qvYaKiIiXt4GDhmRNG5UB+49TWPu+I37L52gaChrLkP+EUKwwRFmjNnXYdlQG8DBCVJ/IkbjW88WNvOkl4wa+FK19XrEGV2kVFCiIILGRLy4xBAlmBBcAG+3aG8wR7ZcKinu7mW+0vMI6YFEBw3s/ZVka2YSxn1T0nN2hW8DHnk4HpLqFSvBObzh05cdH5uHVjN3QSTied55lNsbq6CSkkaPQDsOXmYhJFc4To8yM2S3J99eDJ8FuTNBshCWh3JoAg4T7WA5cqN2IMruYqknkDbBo1EX5wnnC5cXubt2YghaTTeecHE5yUL7Mo+MWLYVgszgSGuESANa9vdOoolkIegZ3K/0RTIS4HDegJzXtLIJgYjWih7w3VQzGJhxoS4jnxrpLVQUhFO6I2ltMq+NgJrPj+X7+bM5PKw1tq1ZsO5b3h5Kg913xdpELWEm1j9yquMzaERWxsjmDCrZS1yYsL3kVDPBHLsvwVtN1NQbNTHjzgtj0KlUrru3tA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(39860400002)(346002)(376002)(8676002)(52116002)(956004)(45080400002)(6666004)(86362001)(6916009)(55016002)(33656002)(5660300002)(6496006)(26005)(1076003)(9686003)(83380400001)(4326008)(8936002)(54906003)(316002)(966005)(66946007)(66556008)(16526019)(66476007)(33716001)(186003)(2906002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?APQphYgSM3zUQEi43nh5KttVQmbOwEPUV+f0KUBxgt34u5C6cMoz8McSTP0b?=
 =?us-ascii?Q?eGvx/wxIAE2JbnYAXmlsaGruoQloKhh0KoHOqttrMQCl71nriFfvwH8SFDBA?=
 =?us-ascii?Q?cm5JURpzaWAUPjcIv5FF9R50Rbtec1kXyM2r5IFrxWT5QAVWKuFg9cxwZcdb?=
 =?us-ascii?Q?GuTGg/ljg2b4R34e/rxbyK2UTE3zf1b8JRiWQ/XbDq7t3sXDg+WPttvOD14Z?=
 =?us-ascii?Q?6hGmTGe4XLpZDlWkPRXlThGmLwIONAalsWoDqHpz76557lE8EytzOo4ntN2n?=
 =?us-ascii?Q?A4P/Qs+6ZdJSngTkYvh+CgkVwJfoe+2ii4imqI32XYopgDMgY4xigBuHQrFm?=
 =?us-ascii?Q?c7AuEbFzPBc0gnHMraAqKVfWRSa4r6qXFoWObyewGD+Zv+esy1ZICi8UGGTE?=
 =?us-ascii?Q?BIbFClk98roG/xoFXTDQt0AaDxgIuKkD1xTCocKcSCEYg1OlF0c5UQFkgLcV?=
 =?us-ascii?Q?adQm/tR911TjHdKRKvYbiDVfp+D/6XAy0/rFve6dv22cqdCFny6UMll69v5K?=
 =?us-ascii?Q?nrSyV578JXJwmHj5b8i0367qpFMCtkeffb03oGo0qwH0ZQE6RLRKWDzil0td?=
 =?us-ascii?Q?Fk9ZMpK5RtfSCI1hqN3ZL1bdfInb1cV/SAXTS/CsI+rysoLd6pQrv47HQQAn?=
 =?us-ascii?Q?CPOEo7hUoLGHWekG6JbxAxl0VcT9ovH7kNVi0RqjDqt5exx+piRZGlKaFAxY?=
 =?us-ascii?Q?QfsriBrOgtGgjZCWaelG+3Rx3st+sFNv8a/dnSrLEENyJrJSTXWUKsOa6oJA?=
 =?us-ascii?Q?RUvzNACcqiiOEroAh/cbpOwPuu6ZElRklQSQurqR+ay+FdhxodqOSqgjkOzP?=
 =?us-ascii?Q?CuuubKFIUsYnAP1P2o0xrxzkcK6sNphunJJY+mzw4rqibHO6qwAmBV+qoW6O?=
 =?us-ascii?Q?/Ugdcu4Ks19Z4AK1lHMw4B3euT5asNRs6YQAlOXRKrXAwFRCMKamiA8pDyCv?=
 =?us-ascii?Q?1ljcbbek3gc/3uKGO4b4LucjJiJ4/NIHD92djax6sNBO9gSZorl8icvrC2aC?=
 =?us-ascii?Q?AdlXDOvUIbBQTvO9awo+WlESav21xHEmLvE3eA0IKWk8FOlgMlWzIbUFdh34?=
 =?us-ascii?Q?pjmAKO5k4nbvk91zoMMnFga99ItsoHvVjx00TPzhS7W+omEUG1cjwyJK36lo?=
 =?us-ascii?Q?Hobwrp6HW34m+1L7W0TzPTJWMcB8XtjFcLE+ggDrPATg+X0CHNq3MLxpcOVX?=
 =?us-ascii?Q?ec+TbcStZ0UgHS39UibrkZ0gsb8b9qjyXsBF+pEHDefd7hkTIoMBOe0Bcqq3?=
 =?us-ascii?Q?Ip91DD0TpEcreawyxe7hyh6emhFSD1AJeUWa6wfy23mKLrzrHXG9cTzjeXQH?=
 =?us-ascii?Q?RmxvgpCppniIXjF7rqeC9YZW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45131a7f-96ee-4ea1-6723-08d8e8807f2c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 13:36:26.2338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gWhcpp2ieIdyFSFA1nTKstLyiLfKcTJiaRM+k3dk+CoBdtoHTHK09HGE2nvVaL0Z32DVx6fBnTP+NzGaDllsqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2457
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 16, 2021 at 09:16:34PM +0800, Joerg Roedel wrote:
> Hi Huang,
> 
> On Thu, Mar 11, 2021 at 10:28:07PM +0800, Huang Rui wrote:
> > diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> > index f0adbc48fd17..a08e885403b7 100644
> > --- a/drivers/iommu/amd/iommu.c
> > +++ b/drivers/iommu/amd/iommu.c
> > @@ -3862,7 +3862,7 @@ static int irq_remapping_select(struct irq_domain *d, struct irq_fwspec *fwspec,
> >  	else if (x86_fwspec_is_hpet(fwspec))
> >  		devid = get_hpet_devid(fwspec->param[0]);
> >  
> > -	if (devid < 0)
> > +	if (devid < 0 || !amd_iommu_rlookup_table)
> >  		return 0;
> 
> The problem is deeper than this fix suggests. I prepared other fixes for
> this particular problem. Please find them here:
> 

Thanks for the comments. Could you please elaborate this?

Do you mean while amd_iommu=off, we won't prepare the IVRS, and even
needn't get all ACPI talbes. Because they are never be used and the next
state will always goes into IOMMU_CMDLINE_DISABLED, am I right?

Thanks,
Ray

> 	https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgit.kernel.org%2Fpub%2Fscm%2Flinux%2Fkernel%2Fgit%2Fjoro%2Flinux.git%2Flog%2F%3Fh%3Diommu-fixes&amp;data=04%7C01%7Cray.huang%40amd.com%7Cce731dda3b444ac9a14108d8e87dbb3e%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637514974013915073%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=NVahf1tIfgno%2BNWPu8hY4DygiGWdKXBJ8G6OsD%2BHC14%3D&amp;reserved=0
> 
> Regards,
> 
> 	Joerg
