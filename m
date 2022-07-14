Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C50CB57450C
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 08:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbiGNG2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 02:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiGNG2q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 02:28:46 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2065.outbound.protection.outlook.com [40.107.22.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA1CF641B;
        Wed, 13 Jul 2022 23:28:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QqTqMTAFVOS6hELOasuAtCMQchggV2oG+GQ3DA59npH9S3NWZABjJULmcLN03J0VbyFCbFrEs6ywmFPfYTrYNfBvdWhGCEv4xDrk3JHviqSzIYYuvXbbBIOghWIjggqILRASOE6wh8BGcqa2PCfhP1vOgsCzbkz+Cr4nlmS7XAuCiaeVTdxqHsBfL/WQG6uszaj1RcSSgx+36NjgmAC0anPZzss8ttKq5NYW3SYQLqcwaXF1Hl+3OnmEOBtypzBMPSrKjrYDx2aQ9PCTOTC9tvmPbYszL4KwRy6h8GGrEfVGdjoyV9vOc9NccTNtwlkmw4fdoglztKd/hiV59gAAIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oFcPL/umJ+5KuC79w/CHfNJulm3P2EJlDY+FDAewpq0=;
 b=dxsPRA72J3RfPqWljx0tqjPV2SnmQteChvkV+9aMGI3Iq9EpSXhibRuXbZyI47QB4bL2gq3+lk3Wbt53eqF+FIoEvuqn3NbqQkb3JXEBMP1L5uyWmyhUNigguIJNjCLKzdVyDNQlIC4QghSPpCiTJs+mpS3GS1tObZUrVtPc3FmceqT+ml/cRLzALW5HB6paFq4801kLV0j5xr5RGNm1724jxPg5jg8Ft+BuItUOCsTcO4/0yYNwKjH3vu8vvQCOK04nI+8TErktnLgIy551kfbyc/YxGDWrdxWD3RrwoEZL/x5KYHinM7j3Ze7gWowBhPv0cknmYO/6GeMphhL3dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oFcPL/umJ+5KuC79w/CHfNJulm3P2EJlDY+FDAewpq0=;
 b=e1zpRprIVfpu1tHbrNsGB4l26KcpRtYbmgWcPeRnUV69vWNrc0TG2xd2uTRmwsHXAYyvnjG0XVFd4oj4NaOtSFzx5bPoVOYZ5J5Sdzo23iXHu8jjYfNpr9/GLujW7wJzMWN8+ORa0vPatAczdW/SWGl1kFZ/84S10/VbTTDBXrOvYuvcnCjiNTR6OG6j4Eg3ZUQZRWbxzNjcKGIgzLOBB5E0GWsIKMbYjgO8zvYm7g+YXk3EznjYvOKDxel86DZFBi2yGyj/TXRyu9DnpF5bDkRC0wL2ATf2xlE1dq+svzTr+NYTYXDF5ccqBKD0ubk6v8t4RZ1vPcUf+htKk9RU0g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25)
 by DU2PR04MB8886.eurprd04.prod.outlook.com (2603:10a6:10:2e1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Thu, 14 Jul
 2022 06:28:41 +0000
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::60ad:4d78:a28a:7df4]) by VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::60ad:4d78:a28a:7df4%4]) with mapi id 15.20.5438.014; Thu, 14 Jul 2022
 06:28:41 +0000
Message-ID: <76b421cd-7a91-ebac-6f48-8a00eaf3c6f5@suse.com>
Date:   Thu, 14 Jul 2022 08:28:38 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] Subject: x86/PAT: Report PAT on CPUs that support PAT
 without MTRR
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Jane Chu <jane.chu@oracle.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        xen-devel@lists.xenproject.org,
        Chuck Zmudzinski <brchuckz@aol.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz.ref@aol.com>
 <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz@aol.com>
 <ec4b2791-886f-4d52-ab39-b0c07489c4ca@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <ec4b2791-886f-4d52-ab39-b0c07489c4ca@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P192CA0040.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:82::17) To VE1PR04MB6560.eurprd04.prod.outlook.com
 (2603:10a6:803:122::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 890d6b25-ecc9-4cfc-1720-08da656217f1
X-MS-TrafficTypeDiagnostic: DU2PR04MB8886:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xsijC1C5/aUsdXTY9sq5FG0lG4MSm/AnyXkF/LQslEiba4ExCq/GuZdGF4vUyo00eT5eFsbVpm4ZVKcfN+E21Aj+SR7pLqAk+nKFZ/M/li4tpiKWnQ2fMFL/tPdhKEtDJ+YtaIJ2LEMF6EbKEIHUHl3Awoi8eCBL2awkLDOpU5GaFEDP1WTeJUBrC9rJeUrg76AQD7bKja+g2M4oTHdDSjJoeTKu6hcJ6W7veO/8z3S7/r/6fQVGnCDP4shdKPiW8nPDJcabMqp4IHs/1VXd9VxPgfxixFjQureMx8/TXZWAiQipOX7JifibNPi+HcVLAS7sjnXSOLruROiOjYklKA0b25g6mXfdWztlEKpFOftur721LJ2klV62aZEPWQHqwrv5RWwfCtxWDnuHJbGahQidS1HVM4EmgWt8+dNDhWtaUbcKRAVlESD8fix1JzLBUUV7tsAp9D5DLILw1l5qAtSSCKI2Vf7ldAbxamuMvHhMLtzAzvze/igG8kUf4/ZgskN2NwioHob2NTDXK3M5aGuI2nxLmrlW7JhJN9upLE190UCq8xC9nJLBV6zQIKED2tPxHNItB99ZL+6o7qRIzGWhGffI/7bIhlIOQib9Pl5pXhnOTbWEFmVPd1hFPwgBYJIzyul8CAVEFwKCrbVzRAWzdDOAK9rvv8oeo6QZBuXkpgxvCUBwp7mMjhd7Jmsezaih1ucMJZKWsYHY79WNf8whV+MyCzWMFIdlBMK/9HhztKtxOZm4S66adgzMGIbYrM4SdByyyI/wdpGf+vXzG/IUicvZg5jvO2LOnDb/8vi5UQVwTMt14j8+eU3nItxEedpd4hKCiKsOC/bLsVuRRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6560.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(376002)(39860400002)(346002)(136003)(66476007)(6512007)(478600001)(41300700001)(8936002)(6862004)(2906002)(6666004)(6506007)(6486002)(86362001)(53546011)(8676002)(7416002)(26005)(2616005)(38100700002)(36756003)(186003)(66946007)(31696002)(54906003)(66556008)(4326008)(316002)(37006003)(31686004)(6636002)(83380400001)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eWk2QjhDUzhTa0VOa2craVdWbGRyU29Kb3R4em9WVzF2Y1E2cnFCYTlteHNu?=
 =?utf-8?B?Q0VYUXRsVktTeGhYZmtyWVZlcGgzaVdQczNLMlFmdk5rVDJPclVObmxVZDZ6?=
 =?utf-8?B?bURoaXdVeitYOVFscmdKNTV6aTg3cmFhdzNITFhyWHNubjZ5UERPZzBsaXJO?=
 =?utf-8?B?b0Rla1hZRDhZSUdocUxiMXIzS0lxZjJselhJc3l6M29xZzhiME4xSGFWSTI3?=
 =?utf-8?B?dEkvMyt1R0V0N1lIeTc2emZkVTMxeXdTWVRtRnczYVFJYVhlMHQra28zTFdt?=
 =?utf-8?B?d3J1QnZ1ejVYNXVnMVhkOVIwZEpvbnBqNGljVlZld1I2aUY2TmIvM1ZGcXho?=
 =?utf-8?B?YVIwZkhPSlVmWUxNSWpwVWtpeVo2bmt3bWZSZW1OcVFnYVJIQVdBSmlieDht?=
 =?utf-8?B?NkhVMytZWlZVc2tsc2NtZWRWaTFSSlprTE1FRHhFMkMyMGtEYVk0ODdqb1Fm?=
 =?utf-8?B?TEg2T1dRSVN1cWNTM2lFS3phKzVtbTRUaVBYc2pNT0k5WGx1TGluVUdLSlcy?=
 =?utf-8?B?cE5lemlTMm9NeGRWYkcwZnRaQ0JIUm03UFlVbGRlS1FtL2d2RmpwMzR0aHJ3?=
 =?utf-8?B?Z2NsZEliYnVaTTY4QmRvWE1BQVhYVktDeUc3Q2lhQmhmYkF1bm9HN1JaZ0tt?=
 =?utf-8?B?RDJVdFhpTHRhSE9Fb3hJVHBKSzhVWTU2aWZRZ3kwQmlXUE50MFVWMDJWcHds?=
 =?utf-8?B?SERad3VZZExKVkhCWi91V1FnQnpVY1luM3c0bWN4NXUvcmVDTk9mQ0p3bnl1?=
 =?utf-8?B?ZWFDb3ZWQmptQmE3NjFTR21DS2xkbGx2emsrdzEwc1dpSzNscEFQNGhkTUxH?=
 =?utf-8?B?aWNtL2syUzZrMUlQRnFRdE9uc0xpRTk5WG9vV1BDSFFLbXhzdkRSOWVZREl0?=
 =?utf-8?B?RTZwajk5UHNzWTVTUThnOWlKcnJDQjBUZW9BdW1WOGs3cmordE9hRnQzRVRU?=
 =?utf-8?B?L1NRTXQwQVdiU1pJWEYyQXlzVjYyZG5HMDlZcUJFQmpNc1k5VkcwT2pvK09w?=
 =?utf-8?B?WHluOVNndWRWc2NzVmk4bWxOYmg3UEdNalltM2c1K3gwMmhyOVVwcUVjcjRu?=
 =?utf-8?B?NXJNOFQ1amRHTEVlQU84STBlZy80OFRnMUlCTzNsajRjOVJJQ3RZZ2JIQzJr?=
 =?utf-8?B?UTc0UDhlNUR6bTRKSm0xUXYxQVA0OThpa1p5WGI4K1pzWHIrWHRHZEd2a3A3?=
 =?utf-8?B?bzVtOHg0ZmZTTFNiV3NLQ2lNQSsyMVgxc1RuWHk1cHlOOTFEQmU3VzU1T1k0?=
 =?utf-8?B?YUxLMlh6ajdzdUxGaEhpQkNFcUxCb3FnZWRsc3NJWWVERU1hYkk2d3ZsWFQ5?=
 =?utf-8?B?bFg5ZDF3Ymd2ZUtUamRyYlVlNWtWZnlmZkdaUFhLbHRVMkxMcmtzM2taQjEr?=
 =?utf-8?B?RlRRaWJKalNuUW1uTDRZN0xZZ3BDMndNeE96YStaTEZaK2lSampEalFUK1hK?=
 =?utf-8?B?OFBCS3BJRGVCcnpidnhGVHZpblhEVHYrYkdDaFVBWnNGOG9pSUVtUytCQy90?=
 =?utf-8?B?cy9HK3AzT21QL0huSFN3TU9uamFiNXlTQ1h3M09EblN6N0dRNDZTUXM5c09W?=
 =?utf-8?B?aXlBem1HUXJML0Q5UEJSOWw4Vk83Nm5WS3hsM3Y4MVZMWHJrK09haGpub3B0?=
 =?utf-8?B?U2s1Wk1yNHVsdlpyU3BOYkhHbUVyc1A1UERhUW5qU0NCNGdmbjRjaFZrUzlR?=
 =?utf-8?B?U0hveVdHdzJIUmhhbSt2QXhZMVgxNjY2VGdzd1NUb01ScE5zVUl5aHZydk9j?=
 =?utf-8?B?blJjdVVnbUc4RkRkL0tMT0UwREtjd3FPeTVrSTkva1NMUTAvNURLc0ZZU1lQ?=
 =?utf-8?B?anhkbHVrQVNpZzhGVHVXN0JobFFYL1M3S28wSjREVnJVSzErRHJuL3EyQXM1?=
 =?utf-8?B?YzR0MGloczhSUUtHUG1HT3NqbnFUemxBU3VPaXJVYm5MRUJyNFpHNFVUZitN?=
 =?utf-8?B?VThKRll5bVA4cnp3RWp2WHhHdW5nSTJJcVRCbGE2cWdFYlEvWklzTnErNWJn?=
 =?utf-8?B?aWlxaSt4cDM1cEM3S0VoeHdLRSsrb2xITWJLa25Oa01wK0VvZEZCYm1ud0hS?=
 =?utf-8?B?V1pEMjlkdDJ6ZDBuWWM0N1Y5djdZa3F1ZmFlbGhEK3lTSmJBb0kva0VENjla?=
 =?utf-8?Q?1OfHrm4/BrJi2eCBAzceTDWXT?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 890d6b25-ecc9-4cfc-1720-08da656217f1
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6560.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2022 06:28:41.1254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h0f4nX/qECLf+7es3I6k417KQ63N3bJPznCqljoopr5NSkP6kPu79/8H+6vl5zgAX0asfyRqrn37OSr0EUrvLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8886
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14.07.2022 07:40, Juergen Gross wrote:
> On 13.07.22 03:36, Chuck Zmudzinski wrote:
>> @@ -292,7 +294,7 @@ void init_cache_modes(void)
>>   		rdmsrl(MSR_IA32_CR_PAT, pat);
>>   	}
>>   
>> -	if (!pat) {
>> +	if (!pat || pat_force_disabled) {
> 
> Can we just remove this modification and ...
> 
>>   		/*
>>   		 * No PAT. Emulate the PAT table that corresponds to the two
>>   		 * cache bits, PWT (Write Through) and PCD (Cache Disable).
>> @@ -313,6 +315,16 @@ void init_cache_modes(void)
>>   		 */
>>   		pat = PAT(0, WB) | PAT(1, WT) | PAT(2, UC_MINUS) | PAT(3, UC) |
>>   		      PAT(4, WB) | PAT(5, WT) | PAT(6, UC_MINUS) | PAT(7, UC);
>> +	} else if (!pat_bp_enabled) {
> 
> ... use
> 
> +	} else if (!pat_bp_enabled && !pat_force_disabled) {
> 
> here?
> 
> This will result in the desired outcome in all cases IMO: If PAT wasn't
> disabled via "nopat" and the PAT MSR has a non-zero value (from BIOS or
> Hypervisor) and PAT has been disabled implicitly (e.g. due to lack of
> MTRR), then PAT will be set to "enabled" again.

Just to mention it explicitly: If the value _read_ from the MSR is zero,
we're hosed anyway, as then we can only express a single memory type (UC)
in all PTEs. The zero case we mean to deal with is when reading the MSR
wasn't valid to try.

Jan
