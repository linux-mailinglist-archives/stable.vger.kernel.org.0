Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 393B337F597
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 12:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232864AbhEMK3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 06:29:23 -0400
Received: from mail-bn8nam12on2043.outbound.protection.outlook.com ([40.107.237.43]:26727
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232808AbhEMK3M (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 06:29:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MNVi812qqYmefNvMYmbPdSfQGwQvpSi+VpNVrXPJnNjqfw/6v5MHXUVDKQhuYsBJ1XHIrUb32s81jSC1ZWFxa728Eyz6FaU5IUurlfiHPPG8mpn8hnRKkPDDzg7qdcWC4HIhR1kMICUmauJr5/no24Blzv/NKzDQ6iR1hFugYUW9sFhcE/2hg7e3cxUVKn/+byWr9kA4rYtc3vFVnvKm2PYJluJbYmFDTVjSfvyjHkTTUjhVmrnxmzPkmPRJs7Q3VQ57SDocN7+96fxenZ26fJteY0r4NYdsW5dI9XtTXrabJ8Q3nChfTzMAlqARYEOE6RcmteyKpSJ6RyC5Tuduog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J3YxYfPRbRbbgPMFbq6F4TjhrzzP6oNpyva1CFAGpkc=;
 b=VkcQv5JLXlydzX0D+IgiahLlScqn/F88RTCsG1rok0P/gj3kruVlimauzuBxSKphyS+fQ+e1FK8w/APx1XrfyHP+HpTZSSvBWuioZvWHODHCWeSutPyYPqOG2EP8KA6aJLmBXwZ9j2xiJRsOx+SgrNH1AAbuyTlXQu3ptAhTGZpjM0u3j7avmctW3CEYdttZtVdSpQxC0+H4CS8+pIt0bCKLxDfamqTw2+cDXbzwaO+i6Si++3Trl+vfdbR4np3uCNMB4X0jzKe3VNOnWbvLHYfxD9O3hxkYKQgs4d7EOz3XaFJQLcjMhiZpRqQL8/QEOPDZG0RKS33Avd8dk5F6SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J3YxYfPRbRbbgPMFbq6F4TjhrzzP6oNpyva1CFAGpkc=;
 b=oBhAaUG94+lwQN+lpeJm2z2QGi0kJVJXtXS3NwHer3PGKFlBqF2F+XJVIfI4QBKWQ5qCOqIKOELFxLlY0DnFJAOY7YpSvEayKnlvUh73JGxTuAY5GIMca9hxfKlnr6UtitFrDLp370Djm6AyAb+KuMw+BbG7AP9P9vK2lFkgU5k=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MWHPR12MB1248.namprd12.prod.outlook.com (10.169.206.21) by
 MWHPR12MB1791.namprd12.prod.outlook.com (10.175.55.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4108.29; Thu, 13 May 2021 10:27:56 +0000
Received: from MWHPR12MB1248.namprd12.prod.outlook.com
 ([fe80::f07c:dc0f:e7e8:416c]) by MWHPR12MB1248.namprd12.prod.outlook.com
 ([fe80::f07c:dc0f:e7e8:416c%4]) with mapi id 15.20.4129.026; Thu, 13 May 2021
 10:27:56 +0000
Date:   Thu, 13 May 2021 18:27:46 +0800
From:   Huang Rui <ray.huang@amd.com>
To:     Ingo Molnar <mingo@kernel.org>
Cc:     Alexander Monakov <amonakov@ispras.ru>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        Jason Bagavatsingham <jason.bagavatsingham@gmail.com>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        "Fontenot, Nathan" <Nathan.Fontenot@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Borislav Petkov <bp@suse.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v4] x86, sched: Fix the AMD CPPC maximum perf on some
 specific generations
Message-ID: <20210513102746.GB1621127@hr-amd>
References: <20210425073451.2557394-1-ray.huang@amd.com>
 <alpine.LNX.2.20.13.2105130130590.10864@monopod.intra.ispras.ru>
 <YJxdttrorwdlpX33@gmail.com>
 <20210513042420.GA1621127@hr-amd>
 <YJz7fp17T1cyed4j@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJz7fp17T1cyed4j@gmail.com>
X-Originating-IP: [165.204.134.251]
X-ClientProxiedBy: HK2PR06CA0018.apcprd06.prod.outlook.com
 (2603:1096:202:2e::30) To MWHPR12MB1248.namprd12.prod.outlook.com
 (2603:10b6:300:12::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from hr-amd (165.204.134.251) by HK2PR06CA0018.apcprd06.prod.outlook.com (2603:1096:202:2e::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 13 May 2021 10:27:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 638c7d51-3a9c-47b7-70dc-08d915f9c5c4
X-MS-TrafficTypeDiagnostic: MWHPR12MB1791:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR12MB1791B099B8E7322AA3EF7BEAEC519@MWHPR12MB1791.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SNt4Uk7xS9llROTGW+PQvT3IVFL8ryIXgHuo/95BSFT0iYptphWilaRwIECnnyqphfSzgvk9qHfoB98GRQGTCRZsUQTGZXJQvI+ynG3c6ljnsfYgjgWvT2JHgQ5aS+V2gw+vVBek9cdBcZWWI/8WWVoM2mIfq/X2o1evCdR4Jc6BSiTvo0jKzcnSexScG3NqPe+SZYRvrpO6qpDT37aYzx1OfIj3zu5CwhR4g5SCJ0UoLKroFmmA+/PBFrHfhC6jX0Q7ghqfl+HBlLtG0AwxIBvONQiJ2oB9HhiMfrkZYrLZgtv45ET/dbGeFK0UnqqlFWhRJ+Kufv1jMDCpb6z7a2GzucMJ9DrG7v9mmcw1BHbb7yrQ+TZrQyuyJB6/akChG6xpVsGkq1XRAmiT9VF9g3/vThFdb5oToqAppkTzxcwccB/yhJntgs6CFjgOeSj5WlpBhnf38x14vz6NlSS0F2OOq5BiHLxSApUCdEEzEJzyXQKjZrtngxhgOTAqf69vukRu0jvoJ+a/CuqVwd9o8VodJujJz8kdrwxEcMhfciCxvNW4rNfpklxggDLTRkT8eDFkxWSTwSAAg8pJ7BmPdo0FEu4cfFQ4MsRQyn/f2L0dM9otDLFaPPvAZsfvtVlW7puxKByYbkilwSIwK18DSIJAhTq5DjNcRzjIPoEv9Ps=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(366004)(396003)(6916009)(6666004)(5660300002)(956004)(54906003)(1076003)(16526019)(186003)(8676002)(316002)(83380400001)(478600001)(33716001)(38100700002)(86362001)(38350700002)(26005)(6496006)(66946007)(52116002)(7416002)(55016002)(2906002)(66476007)(66556008)(33656002)(4326008)(9686003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?v5b860bNKzLWnGO1NCs5ZkanMVWnDoTmPuizWjsEOml92Mdn17gRTTdcv2PZ?=
 =?us-ascii?Q?cNF3e55HKsrql2MKqvw3tBrYGwFhj4jqJ33DxsWTbkUIGKmaHCbnf3RPswH2?=
 =?us-ascii?Q?+eQyjZ/2ms07TK0ImdnkAXO+PTg4pUzjYem6nxobKY5qJ2ZHBmG8nUccfVuv?=
 =?us-ascii?Q?7/LNO30sYiqF2M+MkyopPoJZrECwwvxRTsShpa6DIlk5fHeTsEI+xXBQtziP?=
 =?us-ascii?Q?rsk4FY9o0fTOVLQzRhVDnT4dPQ08QgHn2x72sm2jcudh77qS3J0d/z3I+bnh?=
 =?us-ascii?Q?4j/cKqB2IG0KrTo7KtehZDUVSL5g1AhtER3JLIebe4NW4ARCg3ZBgo502aFc?=
 =?us-ascii?Q?SYe4mMaDkxO4u8IXtXSmvQ7w8RwbYWI/IAPjLwML7IMMU0WYCVe5q72iYzQS?=
 =?us-ascii?Q?HikSMyN2AEQPTzBdET6GES77TzPTqbTgGVxgFN+SiIh4KGDhC3ghV5yAkMBp?=
 =?us-ascii?Q?0q9BNqte7L1lyMpxo/7CNLpWnMBXeg6/J3Vf2/RNG34dWhxKrPj2J7NY3/Xh?=
 =?us-ascii?Q?48B2F+wVVe0d8fA6WaJWt1LswN5iNwMX/FokX1dn2kL7pipF56lhqeKjLKo2?=
 =?us-ascii?Q?4Fo5qQTGYWATH3fakqEBTlq+nM+q8K6XmkSgd86AphDplyf7w8t+WDIkeDyU?=
 =?us-ascii?Q?Ktf4qJlAzGqqV2T1ffm++DM1YrRcBkSzYONXJAxNkS+NMRa2z4y+IThv6+LX?=
 =?us-ascii?Q?V9Y8xzsNwS/8qiAbaSdCo8S7okJBrRgwW0CvjwuiefrzZwexZIQmzxhrOrio?=
 =?us-ascii?Q?Uh6Qm70c8bSbwvGJcuo4FOtGfIro1MO9OPrK+GqSFmPchv1nLn59kE50I6mN?=
 =?us-ascii?Q?PitofmdmWKfnkBWceoTolfGgpSvcz9hpb/V+PKpH6DHN5PazytrHqH/38cY8?=
 =?us-ascii?Q?xdQ/YcZaf5KMyYm0v2Ytwx5fQ8WwiYV5ZKclzHshlSxyZB5hEvC2lPcVIm9i?=
 =?us-ascii?Q?GjQa2RMZ/a2oxlbkxt0gAeH54BsUTrFLjpWR4YS0RD/CWLJLybAe5251VhRr?=
 =?us-ascii?Q?Vduj8Mr6bfNMUKP2/bZS/1e7pLR3jXf0ThztOdsVtffNuIVjoYBWp4uS9yjM?=
 =?us-ascii?Q?klZiASbbRW+vu25MYB3uFxUL+qZxuNyJhXEPBSV7jYqluRumLT+ttSWIxZKL?=
 =?us-ascii?Q?5hn0ceGG+/Wz7ir1PZCbOhZhQ5UTbr7wfS9uaFhJ5dvldOHixYl9braiLU3e?=
 =?us-ascii?Q?hRnLPTOxO3JkPeXBbndItSNOzDv2tfYCrKYoWyIxmHFzjmmnRfpAVGHJtSVw?=
 =?us-ascii?Q?c+HMxD+l3nTkRj5iGKvjNDAeM/RmrvK1RVqHGNQcVuYb6K6rzdPk29MFJfbg?=
 =?us-ascii?Q?WUKQSMaKe9ggCKVFXSl+7/RG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 638c7d51-3a9c-47b7-70dc-08d915f9c5c4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2021 10:27:56.1150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1q6E8Y+Xc4PlJWq6zyPQM2OIvK1r+k7p3cm2F84zD+Lucin7I810DLiNmtapam2jIqQiBv4euOyGq2UUBkkKpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1791
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 13, 2021 at 06:12:14PM +0800, Ingo Molnar wrote:
> 
> * Huang Rui <ray.huang@amd.com> wrote:
> 
> > On Thu, May 13, 2021 at 06:59:02AM +0800, Ingo Molnar wrote:
> > > 
> > > * Alexander Monakov <amonakov@ispras.ru> wrote:
> > > 
> > > > On Sun, 25 Apr 2021, Huang Rui wrote:
> > > > 
> > > > > Some AMD Ryzen generations has different calculation method on maximum
> > > > > perf. 255 is not for all asics, some specific generations should use 166
> > > > > as the maximum perf. Otherwise, it will report incorrect frequency value
> > > > > like below:
> > > > 
> > > > The commit message says '255', but the code:
> > > > 
> > > > > --- a/arch/x86/kernel/cpu/amd.c
> > > > > +++ b/arch/x86/kernel/cpu/amd.c
> > > > > @@ -1170,3 +1170,19 @@ void set_dr_addr_mask(unsigned long mask, int dr)
> > > > >  		break;
> > > > >  	}
> > > > >  }
> > > > > +
> > > > > +u32 amd_get_highest_perf(void)
> > > > > +{
> > > > > +	struct cpuinfo_x86 *c = &boot_cpu_data;
> > > > > +
> > > > > +	if (c->x86 == 0x17 && ((c->x86_model >= 0x30 && c->x86_model < 0x40) ||
> > > > > +			       (c->x86_model >= 0x70 && c->x86_model < 0x80)))
> > > > > +	    return 166;
> > > > > +
> > > > > +	if (c->x86 == 0x19 && ((c->x86_model >= 0x20 && c->x86_model < 0x30) ||
> > > > > +			       (c->x86_model >= 0x40 && c->x86_model < 0x70)))
> > > > > +	    return 166;
> > > > > +
> > > > > +	return 225;
> > > > > +}
> > > > 
> > > > says 225? This is probably a typo? In any case they are out of sync.
> > > > 
> > > > Alexander
> > > 
> > > Ugh - that's indeed a good question ...
> > > 
> > 
> > Ah sorry! It's my typo. It should be 255 (confirmed in the ucode).
> > 
> > Alexander, thanks a lot to catch this!
> > 
> > Ingo, would you mind to update it from 225 -> 255 while you apply this
> > patch or let me know if you want me to send v5?
> 
> No need to send v5, done!
> 
> I have a system that appears to be affected by this bug:
> 
>   kepler:~> lscpu | grep -i mhz
>   CPU MHz:                         4000.000
>   CPU max MHz:                     7140.6250
>   CPU min MHz:                     2200.0000
> 
> So I should be able to confirm after a reboot.
> 

Thanks! Please feel free to let me know whether it's able to fix your
machine. :-)

Thanks,
Ray
