Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4391A692A4E
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 23:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbjBJWj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 17:39:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233201AbjBJWjz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 17:39:55 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14CC91B55B
        for <stable@vger.kernel.org>; Fri, 10 Feb 2023 14:39:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MT1XMbFwlBe+C+UTRaaSTErsYQwdTCZB51m9UHIWR/wNCkrNTwyEk1xffMMfKS0Skdh3Qo0lUtRnU/s56T0M5elIUFV2WycbtM26XlPH1XmOhyRYZQV/EWfNTPmnfUOTPreYSmM56RfHDkpdIchHMFAKJPQZZQxDWzR5EQVVzcwOHa4UlkrsOeIeLUHuqD+P4+HA6/aHk1bX1sjqunNBhPiccCkXrDEm89NCF88PfXtDUsFm18/UPa7SsSqWpxDAWy7O/VAukZliWixexPEJge5kYAjGtWtK8S2FSMAZWh2szHN/MqoGRaRZ5t506MM3MSCjwR40EI3jTj7g9Us/UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EvqU1lfhzea+WYLmngNfkWOFpa2UJ9L0wXYiXzLQitM=;
 b=NB1bjcFOVIDvRCxc7gwvWXa+HJ5WgTtYWzqwT+Sz8uFu6OadbNZxnScrLWKiy7y3VQdKCJaNa2UGD52TrenFmZdv3DE9oK6P5XBAfXJg2Z2VoDEipnU6ZX7zgetGTRnLHAyLeOnjzB8jUuMqUWcXqAqFIWH1J73MqD9Fz6OA9zQ5OHJ/s+FLUWboQX0shSVkg+lG5rzOmb4AAbtpogvXsBDCnjx2cXCDXcDncGZ2+9Pk53sUJHTLkZsaSDVE0myMBYco+pPLXnMFmN3ltg3IgaDLXLUVZP7ZWaTaOcqjcpdmWnqZ017pislbf1RxT/fyCd4++N2lpvAU0xuOcumL/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EvqU1lfhzea+WYLmngNfkWOFpa2UJ9L0wXYiXzLQitM=;
 b=uv3WEah2JGqxvfTZb3vIbTFDP+NNFfcfACmZDdOyH2qCoa6wDMnxSN1S9GKGXnbEzjKa4ki/3mh0lH2A3J/sZnR1z1Ipva8Jg0gdfRhHeTrPWZsIQtxTYpihZyjIGFh4WSQI64AtDZyKwn48+87mVxdAf0cCQbsg20ShulZAMG4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA0PR12MB4447.namprd12.prod.outlook.com (2603:10b6:806:9b::23)
 by SA1PR12MB8096.namprd12.prod.outlook.com (2603:10b6:806:326::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Fri, 10 Feb
 2023 22:39:50 +0000
Received: from SA0PR12MB4447.namprd12.prod.outlook.com
 ([fe80::5060:7b44:5902:a742]) by SA0PR12MB4447.namprd12.prod.outlook.com
 ([fe80::5060:7b44:5902:a742%7]) with mapi id 15.20.6086.017; Fri, 10 Feb 2023
 22:39:50 +0000
Message-ID: <a549761b-2cff-e309-7a4f-e2a6e130acb0@amd.com>
Date:   Fri, 10 Feb 2023 16:39:44 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] x86/sev: Adjust the alignment of vaddr_end
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>, bp@alien8.de
Cc:     tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
        hpa@zytor.com, brijesh.singh@amd.com, michael.roth@amd.com,
        thomas.lendacky@amd.com, venu.busireddy@oracle.com,
        Jason@zx2c4.com, x86@kernel.org,
        Nikunj Dadhania <nikunj.dadhania@amd.com>,
        stable@vger.kernel.org
References: <20230210165854.12146-1-papaluri@amd.com>
 <cd7749f1-3b68-37d6-d90c-a090ac380322@intel.com>
From:   "Paluri, PavanKumar" <papaluri@amd.com>
In-Reply-To: <cd7749f1-3b68-37d6-d90c-a090ac380322@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR19CA0021.namprd19.prod.outlook.com
 (2603:10b6:610:4d::31) To SA0PR12MB4447.namprd12.prod.outlook.com
 (2603:10b6:806:9b::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB4447:EE_|SA1PR12MB8096:EE_
X-MS-Office365-Filtering-Correlation-Id: b4441daf-28e6-4027-65aa-08db0bb7b7bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BaJFw5ITaDuoK19sVW9l2c8scrqjeS/PHb5MhinhGLK6tQLuqx+AbFbQ06bv4+TJNYiqyBYE8DlwLhNXgRAixlcgFc9k1xg2cV9ZBDqBCl3q1TAJVNNFSOGycU12JeiD7UfjC/wFnYc2GPe0CoQ3kS9o7TyeLeUEpNFwKELlRBPd5GVdA+Gsak/LzBK0KfAIArpRQvcMPolL5Cl/aMdrJh2YAzEzt5VfeeUbdu3DJ4AAIhIj2FeAPzqZiZTXSsANg9qykXF9M+ZOLf39ORNXdwoNSP9t5d51SPn0LLkaSp4zDshtvYJCFviNgzMdFxTjkH9deXXvHJjFARxakJ6e4mkSIxgFfsturqW+0ZMpr53WlvWgoUNAL3oMsk6Lq3R7uIAmXe/D/YGmIOaK531yDiSQgKOI/AjWnxoTH2IGA0tC7zGafgRVsrWUb9oBu12U3ATlsRloWNXInnBsWtF2EMBO8xIgu23prNX4y1lub5Mavx7680I7g5W9cxOY0wgvi69dlv7I3miKwb8lFsC37VimdLAVTplR8Q/40EFPZwLod5KMoXh9lPK+qVUPag5C1Wytdb5+AoZb/e5dHOExLnEwoIEGassiNJEnC5Hi5esa3/swYzcYy7nZKnrpM0vmwx26UmUXJUFR47fzmT3F77FjRDaPBx8kJKmttv3y8FKbuvahRaiqBkeh6o/hJSwHSRqDAfl1TeVM648Wt7m+WA+Qk7Rl4eDGzSTaRdJNwrQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4447.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(376002)(39860400002)(136003)(396003)(451199018)(7416002)(6666004)(2616005)(186003)(66899018)(26005)(6512007)(53546011)(38100700002)(6506007)(5660300002)(83380400001)(66556008)(31696002)(36756003)(41300700001)(8936002)(31686004)(66476007)(66946007)(4326008)(2906002)(316002)(8676002)(6486002)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UEZHK0NSVDl5dzBDTE8zWDcvR2dweGhDcm9hZ1FiQ2t4TURxVHBiYll5T3RX?=
 =?utf-8?B?M2tvQXhuRjhCY2ppWkZ0cXp0R05ZRDQ5bGs2TFF0Y3F3T3pKOUhHUmNKUGlC?=
 =?utf-8?B?MlY4eVlYWjEyWEpCYm15VzNjZjFpYWgwekJMVHpTUGhBTUs4ekUrM2Y2ZTJt?=
 =?utf-8?B?VkhsTzFPbkJVeWJoRDk4N0pTbnZQMC9iVC8xWU1ubUxpdFpkdFMzenRmTjVU?=
 =?utf-8?B?T2NJeHVLVHdsbVV0MmFlSFFSejRwTXRTVEZuT0g1TEtoM0k3ZzJkNWhFMS91?=
 =?utf-8?B?ZlJuc1BRRTN3Nlp1VTZzK0dCbVNJRG52M2lyNDMvWHhTMzY4UmFuT3dwSEdp?=
 =?utf-8?B?a2lXS2FBMk9VakhFcWZkOVZZSXpBeUpIZG9IandiZzJ5dXlmWUFHSHlOeFp0?=
 =?utf-8?B?US9BTDU3NWlUNzF2bG9ESDV6K2REcEllL0o4L0poQXJqakhoT0IwZG4wTnpS?=
 =?utf-8?B?YTNIMkhDWFNGOUh1bTVjdHhGVENIM2NHckliRkdKSHJ0K3FWSkhqZndRaWxs?=
 =?utf-8?B?bmQ1UEQ4T1UwUTAyY24vZDV3N0E2UWhORzRWS1FZWDlKMzNyNEhjZUJXTklt?=
 =?utf-8?B?djhFUTZGTnZ5dHN4ZjhDYnJEeGRLUlhVMFhpOGM3enhvSzJCMlM4V2RYenpX?=
 =?utf-8?B?R2s3Vjl5K2crdzNIa095RWZoTkJ2WWl2Mk9lRThoM3poUE51dm9OZmpGRzZK?=
 =?utf-8?B?RHBIYWV0YWt0K0hTdmhzNVFRM3pKSHhLK3hxdVVPa042Wi85eGFuQkwyb3RL?=
 =?utf-8?B?WGN2WkFJTWhMWTgzUk95Y1FYMFdQQ3V4bzlHeWZDbW5JODRGQU5nRlViakxi?=
 =?utf-8?B?Tzdadm1ZL0QzNDNIRktHd1dKWlUvRVlpMG03ekZVak5jNldYN290b3Z6aU1h?=
 =?utf-8?B?cE14cG13Z1ZITE1YZHhSTFZhaVBROFkvNmF2Wmdic043WVgyVXNQNDhFa3hO?=
 =?utf-8?B?clIwc05XOVV0NFF5U2hCSVFTMk5Ub284UjMrZjB0ZlFjOHFaRTdQOWV2cWpN?=
 =?utf-8?B?VGZVRG4zVWtCK2hmcWdvL2lucXNsZkMvREpIZlYybUYrNjQ1QkhKY2ZCU21Y?=
 =?utf-8?B?a0VkakpzR0FqR29kbytRUXIrOGxuVDEzcTBzWk0veTRudjNNYU9TSEFxV2pO?=
 =?utf-8?B?M1F1dElVNkVhaWZnaSs5QTV1Z3gzQU0wMDNBS0JUMldNSXI4a2g3RHZkTzVU?=
 =?utf-8?B?TmF2bExUekYwVXF0dWlEUUNONmFKMEVJbFpMZUx4d1hUMFBjbk1od0J0UXJJ?=
 =?utf-8?B?dG5MeXo0RTkrdVpMeEo2eGhRdUNjeHp3L1dEM1M2MmtkakxROXpGVnZRelJy?=
 =?utf-8?B?bG04NnNmTGJnNTROMFJDZVYwTUhtQ0F6bW9nZjVTVFJjZ0p1ZEo4L29PZDVU?=
 =?utf-8?B?cWVYTE9MTlJqNjJjUnJvcFdIeVErcDhmUFY0cTkxZFR5QVlRVzB1cWFJd0I0?=
 =?utf-8?B?QzNOMklhaFJmRjJBaFJwVUQza2RRSTdPVWVKZlFTNjVJMmFnMzlmSGNBdnRs?=
 =?utf-8?B?Wkxwclc2VXNXTGFESDZoUTREUlZDSklFMUhUUmdVelZRVHVNZUFQMGM4ekN0?=
 =?utf-8?B?T0tZcHZPRDh6VExROXUwSXJVQU03M3d3TUFiSS9NMDlMMDdmVWo1ZHg1SkE4?=
 =?utf-8?B?TUxQb21TcmJwdTFxL3grelFhQmk2dnZheXJaTTlNMCtvOFdVZmlRMHlsQUc2?=
 =?utf-8?B?clV3ajRpRVFpb2NVZURVa0RiQVpPSXpyNjYyOVJPaE5NZ1IvS0FJcWczczBr?=
 =?utf-8?B?Yk55UTdaSjZJVnlvRzkxOENCTlNwd3QvODdpbU5Va21HNm9QQVJNUWN1K2k5?=
 =?utf-8?B?V2hBVFZyRDRqQUo0bHZRZElKUElVd1ZLd0RWR1ZTVXhqejdXRHI1aDByUnEv?=
 =?utf-8?B?clVhNzhQeHEwQ21CMFlXOGo0UFp0YW9mUHNlamkxSkJDWkpQRE9ocURmWDNM?=
 =?utf-8?B?b1VpaFBpbkMzUml1a2ppK0cwZm9YY21ia3FXdGdoZjU5cS8xVllycmYyb1BW?=
 =?utf-8?B?VWJQVFJoLzE5K1JSckFDcjNJbWE1R000UHJQbFM0Q1hzOWZLeFcxb2J5Q3Ex?=
 =?utf-8?B?aHVranNqUE9EKzdhUjlqd0IyNVFxS091SjhEUDEvWU9lcjlDNTRIRGMrWUp3?=
 =?utf-8?Q?HQtE3NjudeWWN2/G3N8crOmd6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4441daf-28e6-4027-65aa-08db0bb7b7bd
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4447.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 22:39:49.9650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LGMifQZJHimGyCc3I7ixVBjgZM5j4MvKROG5btcOj5qqnr7ZdklsU2QR2vsn3wiQ86BlLVF8J7/UdIwZ2lu65w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8096
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Dave,

On 2/10/2023 11:38 AM, Dave Hansen wrote:
> On 2/10/23 08:58, Pavan Kumar Paluri wrote:
>> --- a/arch/x86/kernel/sev.c
>> +++ b/arch/x86/kernel/sev.c
>> @@ -648,8 +648,8 @@ static void pvalidate_pages(unsigned long vaddr, unsigned int npages, bool valid
>>  	unsigned long vaddr_end;
>>  	int rc;
>>  
>> -	vaddr = vaddr & PAGE_MASK;
>> -	vaddr_end = vaddr + (npages << PAGE_SHIFT);
>> +	vaddr_end = PAGE_ALIGN(vaddr + (npages << PAGE_SHIFT));
>> +	vaddr = PAGE_ALIGN_DOWN(vaddr);
> 
> Could you folks please go take a look at all of the callers that call
> into pvalidate_pages() and set_pages_state()?
> 
> I think part of the problem here is that the API is quite inconsistent.
> There have been a few bugs in this area.  Ideally, if you have an
> interface that deals in 'pages', then the addresses should be aligned
> already before hitting that interface.

I agree
> 
> But, there are messes like this:
> 
> static inline void __init snp_memcpy(void *dst, void *src, size_t sz,
>                                      unsigned long paddr, bool decrypt)
> {
>         unsigned long npages = PAGE_ALIGN(sz) >> PAGE_SHIFT;
> 	...
> 	early_snp_set_memory_shared((unsigned long)__va(paddr), paddr,
> 				    npages);
> 
> That's taking a theoretically unaligned 'paddr', page-aligning the size,
> then passing the result into an 'npages' interface.  That makes zero
> sense if, for instance, it tried to do:
> 
> 	paddr = 0x0fff
> 	sz = 2
> 
> That would pass along:
> 
> 	paddr = 0x0fff
> 	npages = 1
> 
> npages (the effective end address) is aligned, but paddr is not.
> 
> We can keep on hacking around these bugs as they present themselves
> one-by-one.  Could you look a bit more widely, please, and see if
> there's something more fundamental that should be done?

We will try to fix paddr and vaddr alignments before they begin to touch
the interfaces.

Thanks,
Pavan
