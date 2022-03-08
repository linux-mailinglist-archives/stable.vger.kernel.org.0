Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B80474D2135
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 20:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244966AbiCHTR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 14:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbiCHTRZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 14:17:25 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602794EA3A;
        Tue,  8 Mar 2022 11:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646766987; x=1678302987;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TVG4jMkhMV75GA6g/CgCuow6VLeINuzv2ZIMpriQu9Q=;
  b=R9dn5iwWPob6XJfrHWrZ1SrMOUkG0TS1QOnNl5KTC6ScNIE0I7icXx/2
   7rcr+1PkKw7Yt0vtfIjdCsY+CjBVnJFFx7DgS7u9jEQ8CBdHN6SYZbL0E
   lfyh7KFFk9d/Z78DNMNJTqSW3LiNGXMSPVx4erjo34VqrKqTlYgT3VOVI
   0ar8NIGVbHhC54tjYyDKsv+FkrF9tAqqTiB4TY5V5dl2D/ja2LanhMlMu
   jykTWQj+w/oGIuclmLk9jNVKmhQjCjYO0bZDfAOj05TSnKH7PhrpRBviI
   pDQBXB5qQcDdHyoJZGZQjYynbUxo3z8HBDKrDIu37Pi6hZ2JrwwX7X6sR
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="315506185"
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="315506185"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2022 11:16:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="495571338"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga003.jf.intel.com with ESMTP; 08 Mar 2022 11:16:26 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Mar 2022 11:16:26 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Tue, 8 Mar 2022 11:16:26 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Tue, 8 Mar 2022 11:16:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y5Z9dpvR4zrX6IyFBGmt+J9kSteYNo/WS9yB9ZhTEYOiG7GrdtRYiacG1nxLMJPbTkqSoOILuLbAakBWoSFXe/48kNK/7Ytcxu+eyAiD4GJbDLsCI4Z7XR8fDwXhSE6ziu1aMGe+eQxn+uo+RHYaypO1l1X1aty9c+7idmmBYujcob02doEL9+9AQCCtd9qns2tJHUAIiwM+XQM7AtxImf0VypEiZ2/4P23cvAaoJ/c8z+GqBQnf89Pz4r3Nu5/sYUnnToT6tI0QdqcV1NjWfp/12IkUIG9XMERO/4U6gMbkM+/iJnpmgtNRGNpVvbmeN13NX3g19Hlw/hbhy1Z+8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=svMKy/xG1UlDlbpls1Wzl4MfpGha87QHle6vUVPxYco=;
 b=DpxpD6Ft2Ky/8fG2mW5oxyZqTCK8x7aI16C23Opc/yd96QAUefrYlc1i0mpYhIqrYEiBawoYWd17FZjNbql8LdafzhNXb52YHnioQhsI0vzUId8TDXNmZKp9En0B9fl3OX4ohIXjptED+6zs8qKpcvgAcLgL7+FxCA4NBjG9PQDo2H/nHElt47cZcGCFZqAtknsyaRBKFeKlpHTdAH9M0LWT6fGoJqlekBWNUh/KAMVUfaA9nbQ7B3PREH1hNws9aAjQO5x0Qkp2qGn6NZyBdhkHlFfzEUUsAEqLljI6QLM0TGUWS0BCbKloOYXydsnkirWtpdlaMaum6BlXyoR4rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN0PR11MB5744.namprd11.prod.outlook.com (2603:10b6:408:166::16)
 by CH0PR11MB5250.namprd11.prod.outlook.com (2603:10b6:610:e1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 19:16:23 +0000
Received: from BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::55e4:9a32:8e6f:4774]) by BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::55e4:9a32:8e6f:4774%5]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 19:16:23 +0000
Message-ID: <d476aa51-f855-bfb8-0738-3190439a2f72@intel.com>
Date:   Tue, 8 Mar 2022 11:16:19 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.1
Subject: Re: [PATCH v6] x86/sgx: Free backing memory after faulting the
 enclave page
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>, <linux-sgx@vger.kernel.org>
CC:     Dave Hansen <dave.hansen@linux.intel.com>,
        <stable@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <seanjc@google.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
References: <20220303223859.273187-1-jarkko@kernel.org>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20220303223859.273187-1-jarkko@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR15CA0043.namprd15.prod.outlook.com
 (2603:10b6:300:ad::29) To BN0PR11MB5744.namprd11.prod.outlook.com
 (2603:10b6:408:166::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51e0acb7-b308-45cc-6948-08da01382255
X-MS-TrafficTypeDiagnostic: CH0PR11MB5250:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <CH0PR11MB5250E2AA73610DFA2FF05ADAF8099@CH0PR11MB5250.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AZCP+q9/jKKPtjGlgl+T/QjSPYyNI9KW8R9pG0tMRyjmk5JbLiHNTq3nsUTifZHevptYCUviGjAZtvHLzXKUVoZ0E8rJgvXOeiYABvOnsf+pTcxadNnP6ztyR0C1kRJ83va/5Ru8V4+wGYRfaUHsjGeZd2IzwyiVhZ98jnZHC03+yMAbPTMRQNZqQoGEBLei+46Z+Cx5FF7/h80tKEwiKPM2/Yc0u1E0ix7vWfFgMNL6HMKHuQVyHqiqAEd5Ft641Drn6smh4/vwtg8UOJGKCwp6LsQXRGBB0/1weOTU3FLUZO+6hoWQ+i0Tj7JCZmwMGvie87wyqWJ5pO/EN/ncXnye2Wbb5ZxmBhl5ddZyZlc5OlCk/bfI5LamM1jVG9F4gUtXqknYOrG6sS7y2Sew4+gTom1cESdR/Yyekbz9ZRjBKdH1jxL7JVw/UyEXF/XHZO56MAmTTq9VXi+rm965/bXcfV28md/4Kokk+CUnYHLjYZEOMUcIYZxhKrFYCTA+/oJOjNBmriAYH5IRmvuThhauVpN8Prq0z1c8mHJZwTKuBQP60cYed+a5lJa+qn4uZ7cuJ6ck7x8/l16XqX7L1M2wgtoGGkfeq00nwBfX9IRHyLHm7owdQI8TJCbZpi+PkJFnHTXeSmmvEchETLrvrMLTzn1Jt3oJR16PB2mViNh+kT5XL0XpUfk0BFeveAPML+httXzqfeJlcFPEtHGERa38XqAd6+fKM1TW6LroKcjGiFgnKiLaB8xlYT8551us
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7416002)(44832011)(6506007)(53546011)(86362001)(8936002)(2616005)(508600001)(5660300002)(6666004)(6486002)(2906002)(6512007)(186003)(26005)(4326008)(8676002)(31696002)(66476007)(66946007)(66556008)(38100700002)(82960400001)(31686004)(316002)(54906003)(36756003)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZUZPRnJkYXBHYktlVmtCT0l1aENPNlBmaU43Nis1VElzSTI1RjBrZDhWd05S?=
 =?utf-8?B?S3BGOVgzZk1RMm90S0k4emRna2NhODZabTAzYS9oMFR4Wmg4MFlnUW80c0M0?=
 =?utf-8?B?cEV6WWNpeHV6bVpCS2tITVM0VGhiZDJhZmRsVWVqZGE5d0graXdDVFE4QUYr?=
 =?utf-8?B?NGxidDJLN2xDM3RhcnBmTndENFJ6TG9NdHkvckkwbmM2cXYvRUtja2prNFNL?=
 =?utf-8?B?Smk5OU1IUitBOFE5ZiszOUswL3JWWjV1OG14WVJxMlMxeGFTbFl1b1BDZ0tV?=
 =?utf-8?B?MnNnVVBPSDJRWlVDbjNtNHRYRWUyZ3NGYlVwbEEvRnJGOFRLWVVxQUlpK1Bt?=
 =?utf-8?B?Y015ZGFhdlZ5ZFk4bUVZa3lGbVdRMTZ4RzRoSFkrQUFMYTRkVFlQQThSd0xE?=
 =?utf-8?B?dWpCK2pPck5WeFdqVUlzbnpYNGN1Mi9VemFnd2wwd3VhMll2NzNwNnF5V29Q?=
 =?utf-8?B?VmY2cVlCSE9lTVZTMHB3Y2xWdFQ5R0R1TXdLbU4wSytFZW04b3o2L041azZQ?=
 =?utf-8?B?UGdOMDlFeE5WcFBwVnpqMURhZzBhU2RYSW9MamdudlIvN0dMN1Uza1VhY0x2?=
 =?utf-8?B?Y2JjN3ltRDBaRjlvcmZCbnpodVEwWkhlcGxLNFA2UStPVEhDdFBCb1l6ZktG?=
 =?utf-8?B?MDRxUGpBa1JoWHpKUlNRN29BWGVFZndDV0p5SG8wNXY0cERGdDl6N3pJVTZt?=
 =?utf-8?B?RTE1bzlaNDR0WFFHZ0Q2UUZFTTFUTmpOY0VUOEJ3dHhnWDFjWTRGckRDLytH?=
 =?utf-8?B?bDFqQzlyTFJ4VXJ5TWFtL0lYc3NHZHZZcUx4TTlNMjA4VXpzalZkYmlvek15?=
 =?utf-8?B?ZlZwbTdRN1RsdUN3YkFqcGN6SjFNQ3FWdnh4ZVZSNUlaR0FsWnRiUU12cTJG?=
 =?utf-8?B?NXFaQ1l1L01uaThrZGhYYyswYkRIbDQ5aFloWDJVNUkwUCs2SFdNRFM0RUVC?=
 =?utf-8?B?WXlEN0g1RTE3dEZQdFJQVjh1SytmVnU5YnkyRkRNenk0cDVvZ1FNYWk5OFJr?=
 =?utf-8?B?Ry9oR05OOCtZK1BlV2h4SzNsbmw0MmRFSTI1RnlCTVRxaXBTM0N2SWRrR00x?=
 =?utf-8?B?UWp0N3ZobGV0RVZVOFBpUHVwZnAySE1pekZxWTNFeUIzS1l1NXBEbHR1Ykh6?=
 =?utf-8?B?bDg0ZGkxNVA3Rm5DS2NNZnRTOWl4dHMwcjBMVmg2dTVPTjVObTU0ZDdMSTdm?=
 =?utf-8?B?bEluODFDclk4NWx1aWlra1luSVNYZkFJVldGd1JMRjJmUlpVamFkOEFaV0N0?=
 =?utf-8?B?RjRiWlhSMVlEeE1welpvcEFYZmJ0YUY5UVVHMk5wdmNwRVdaR0p3NjBZekJu?=
 =?utf-8?B?WkJheFJuY1JzNHVNVEVBUEl1b0xCbnd1ZHMwUHo1NjE5djFKZVJySUl6YWEr?=
 =?utf-8?B?YmczMlBTNVMwVkFpVUVvcW8rTHlrRW43NmVNY0QwbUwwaDZSdlJwVWxTQk1H?=
 =?utf-8?B?SWVtbHNXbnc4RExvN3ZxcGtHNzZ0T09ENmhVTnlhdEFBcWI0SkdudW56WnJo?=
 =?utf-8?B?KzZ0NTV3Ung3Y1JoenVpQmk1MWJ6N1ZQd3p0a1JZWjZySVlVbnNMRHIvM0dZ?=
 =?utf-8?B?dk1zd09hdXpRVnlJZnFJZHp0Z1dOK1NXWkJ6TUJ5cEFVSG5UZ2ZNV0orWVc1?=
 =?utf-8?B?MExMWlJ6MlgxMXpVcERmNTZuR09HTGZDOE9hWCs3VVk1YTg1U2MxdFlUV0x1?=
 =?utf-8?B?ZGlRUjBuckhoRVJvNUhTZFFIR2pTMUhqWW8vd2N5MmIxQjdsKzY5SG8ybjZo?=
 =?utf-8?B?OUNyd0h6Q0dGdlk1THhRVk5mcmlGWHFlcWo4c3BjVTljbjNhZHNobXIvYU5s?=
 =?utf-8?B?SGRJL3Fka1VPODZ2ZlZoYytDVWlPeWRrTGc3akxTektKSkNPbVQyeUVBMXJk?=
 =?utf-8?B?b01ZRGdVVzBBL1FWREt5T2o0c255NGZ2MzdCdUdvckpGVjV3VDY4MVVxTUVp?=
 =?utf-8?B?Rlc3Ky9tc2E0NlBxbE9CM2kyK0txUkh2YThmQkpxaWlVbVZVL1YvV0ZsajlV?=
 =?utf-8?B?UFl2bUxTRDd5T3pPYmF3V2xJS1o5UWtZN0J5YWdiV0xmOUw1aWlQcEtlS0FP?=
 =?utf-8?B?dzMzL2FsZ3RieGdhZTlCRFQzb0t2N2VEa1AwMVZFMXQ5a3lhd3c0bmhqQ1lE?=
 =?utf-8?B?L3lsTVp5N2FyRDZBUS8xdVZ2R3RiL2RCNmtxVkkwNDZrZDR0V1Q0eFNFSGFt?=
 =?utf-8?B?VjJ4ejBxMVVCbWJGR2Jzc3ZJdUN3QkwvU1pzMXNvUnlLdTUyd0M1czNyNFZG?=
 =?utf-8?Q?yQP6fJD3SHERUFEt25XeTeooITkVT9HXsBVizzgqKo=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 51e0acb7-b308-45cc-6948-08da01382255
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 19:16:23.5602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F2EjFm/kzEUHwwDVa4KZL4QElsfus8Zt6R+LMTczolEt7HNNv7egrn54pwIdUFK9Hi4kLPxdreU0Ti836wsKUdmDR3bS7PlB9PmNExkS+nk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5250
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 3/3/2022 2:38 PM, Jarkko Sakkinen wrote:
> There is a limited amount of SGX memory (EPC) on each system.  When that
> memory is used up, SGX has its own swapping mechanism which is similar
> in concept but totally separate from the core mm/* code.  Instead of
> swapping to disk, SGX swaps from EPC to normal RAM.  That normal RAM
> comes from a shared memory pseudo-file and can itself be swapped by the
> core mm code.  There is a hierarchy like this:
> 
> 	EPC <-> shmem <-> disk
> 
> After data is swapped back in from shmem to EPC, the shmem backing
> storage needs to be freed.  Currently, the backing shmem is not freed.
> This effectively wastes the shmem while the enclave is running.  The
> memory is recovered when the enclave is destroyed and the backing
> storage freed.
> 
> Sort this out by freeing memory with shmem_truncate_range(), as soon as
> a page is faulted back to the EPC.  In addition, free the memory for
> PCMD pages as soon as all PCMD's in a page have been marked as unused
> by zeroing its contents.
> 
> Reported-by: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: stable@vger.kernel.org
> Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

I can reliably reproduce the issue this patch aims to solve by creating
a virtual machine that has a significant portion of its memory consumed
by EPC:

qemu-system-x86_64 -smp 4 -m 4G\
 -enable-kvm \
 -cpu host,+sgx-provisionkey \
 -object memory-backend-ram,size=2G,host-nodes=0,policy=bind,id=node0 \
 -object memory-backend-epc,id=mem0,size=1536M,prealloc=on,host-nodes=0,policy=bind \
 -numa node,nodeid=0,cpus=0-1,memdev=node0 \
 -object memory-backend-ram,size=2G,host-nodes=1,policy=bind,id=node1 \
 -object memory-backend-epc,id=mem1,size=1536M,prealloc=on,host-nodes=1,policy=bind \
 -numa node,nodeid=1,cpus=2-3,memdev=node1 \
 -M sgx-epc.0.memdev=mem0,sgx-epc.0.node=0,sgx-epc.1.memdev=mem1,sgx-epc.1.node=1 \
 ...

Before this patch, running the very stressful SGX2 over subscription test case
(unclobbered_vdso_oversubscribed_remove) in this environment always triggers 
the oom-killer but no amount of tasks killed can save the system
with it always ending deadlocked on memory:

[   58.642719] Tasks state (memory values in pages):
[   58.644324] [  pid  ]   uid  tgid total_vm      rss pgtables_bytes swapents oom_score_adj name
[   58.647237] [    195]     0   195     3153      197    45056        0         -1000 systemd-udevd
[   58.650238] [    281]     0   281  1836367        0 10817536        0             0 test_sgx
[   58.653088] Out of memory and no killable processes...
[   58.654832] Kernel panic - not syncing: System is deadlocked on memory

After applying this patch I was able to run SGX2 selftest
unclobbered_vdso_oversubscribed_remove ten times successfully.

Tested-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette


