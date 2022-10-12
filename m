Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7AA5FC58B
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 14:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiJLMmr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 08:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiJLMmr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 08:42:47 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2079.outbound.protection.outlook.com [40.107.220.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D33BC90DE;
        Wed, 12 Oct 2022 05:42:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JB8Gl1IRTAqgo6m/EdBjspTfR3Y9h03li872OrDFJVVG81XbY0F5Ix8NPKIbHhBn02fURGneg+i3/EKU3Xpj3lMzPHiGsj8/UOcxWA6DEKqPuNc17iIvew9kf5s4eHiAw3h6uwB+Jm+8jYEEMgUxtep7jJWfRWL2AXCd8c7XCPPhVxNGAJncMVAMHOL4AkZWGMhL5mMD3icHOC2bR3E/3Yp8i2TKojJ4FhCdg2/pgQ0FjbHqCL4zcBydgTE/xrD/bgcLvUrIQAZMg2FRm0HuJC+Vj+srKZBLvssmqNtgbTQYj1yWWXLB3ivXXoV40RfvupUU2bpmzG2z73uP1PiZRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VD93p044ff7lTrk9QAjCPDYxpdDlJMiFRNNCfLJ3TyE=;
 b=T1IemTBKfnEf6Tb+b5QjJ+WIOHNqQvQQJNoE2X/hATTMvjRY8QwXaDFeJ951a8gx8NVLxHNV97a3skkSYfO+4oR5qWa+Ejam8iKteuFRA3QQG3qqLAdzCOi8WQEutWpH8FF+Nj23Okq+8ZRDV5esXO9LuOto+pMVYqbTRF8mD1b7KSxAA0aCQuazfMUzSThg+yKB45KwjERczRSBzT44yAkB14Yf89+wuBd1d9SsVmAxhBILyttTwLwEPIuu6H1ZXh0tRqlJK1u1u2KNYKYdTm0ioSXWsJqXqoryaVP+q4sdDSFRORmvzLFw5SF4h6zYrppxS3iJKDTdJ293HxlrDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VD93p044ff7lTrk9QAjCPDYxpdDlJMiFRNNCfLJ3TyE=;
 b=aYSmuyqdRtf74Yva8o8+Wvn+/1b5YTIMT3uTLuEibDXUGB20upVb+BzooVurfNL63eNtuqzMvt/jEwdRssgaZbUtpt4NFocrn/29Kn5cyAtafc+KkZ6nuorMl3R4SP5Rq/useCUEZYU6EAvcrs04dq1fJQdXCadhM6OvDq4nrWw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by PH7PR12MB5759.namprd12.prod.outlook.com (2603:10b6:510:1d2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.36; Wed, 12 Oct
 2022 12:42:34 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::76ec:6acf:dd4d:76a3]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::76ec:6acf:dd4d:76a3%9]) with mapi id 15.20.5676.030; Wed, 12 Oct 2022
 12:42:34 +0000
Message-ID: <4e1bfb2e-cd9a-6b41-520e-dbf3746a2af8@amd.com>
Date:   Wed, 12 Oct 2022 07:42:32 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] crypto: ccp: Add support for TEE for PCI ID 0x14CA
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Thomas, Rijo-john" <Rijo-john.Thomas@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Allen, John" <John.Allen@amd.com>
References: <20220928184506.13981-1-mario.limonciello@amd.com>
 <MN0PR12MB61017C926551A7F6D908F6ADE25F9@MN0PR12MB6101.namprd12.prod.outlook.com>
 <Y0aJhAmgF1mpxqNL@gondor.apana.org.au>
Content-Language: en-US
From:   Mario Limonciello <mario.limonciello@amd.com>
In-Reply-To: <Y0aJhAmgF1mpxqNL@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR01CA0015.prod.exchangelabs.com (2603:10b6:805:b6::28)
 To MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|PH7PR12MB5759:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bb49f2f-c7f9-4614-f1e0-08daac4f3ca6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BjRariAPIe39D4ZUw0GlVJCeIFDxVSdrPEYLo4PYiX6+b8OSvy8iBtU6li1Ldwe75LZHsjt5vVAvzTNurcPmu1pf4XOj16+KoHI9bmxdz0kwl5rSBy+FnBBksTHLtYlBQgFEuGB9c977rq0DXn1XljelytkObrYb1YYJvD+cQJrKv0DaViKTFSrpt5GBdbi0n2x5zFcj3qy6e/VUM0qIWByVDelRkzyJaFnhc53ekI8+DkF0/eFfow4Gg8wVSbECQCzTZznzgkL77ktc+5yIyrO4cswtC9t3MRK06LCPjnLLvAxo8hU7iP8LxCjrhm8nEcC3o6iiqte40R58azcBSsncaWMKieShvfdK9UmpTbR4XP+0ze91pbmVX5K7BC4sUtOezaEc5H9q6uesS0tY6R6/3GAE6oqcX2Xy6+6433mL020u0CJxxUA4JIIjQtQn0mT+BbWxlvjq9H8p5BRF1pLVeMV4mfNjqqiI2U9iI5SgIOb2GhwMKRV+lDmaZfSRDp/Fia6KfI/ibAMLJWYs57hOCDZO426jdHHLsc026yZM0j3kQH8mzaMl8ilEGaZsQwLm0ToqD6dd2Dq91TX2bRMgz7W4ENJoo0zY8Q+Tbl+YBoZ4OGdeXBws/0R+Etjsszq8sTngWXmMrzH3IodbbklVY7IkYmVKMfhjmVEPiDQiJ2Db7+DPHNKmNPtEEz0BaYOkfKEgzBSvLrVLW1zREgsl8mTh6jKUSNxfMiY0suqj8Xd9U6pAMVV3Nv42vLfCku6Cb2/IREYHnBwXh9DXG6mZcCzhvu9NL4XZ8pK32RA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(346002)(396003)(39860400002)(136003)(451199015)(2616005)(186003)(31686004)(8936002)(2906002)(6506007)(5660300002)(86362001)(36756003)(478600001)(6916009)(38100700002)(44832011)(53546011)(54906003)(83380400001)(31696002)(26005)(66946007)(316002)(66556008)(8676002)(4326008)(6486002)(4744005)(66476007)(6512007)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QlJZMS9wK0dNRWlZejNXRS9mMTMyZWNYODFSdGNiK0F1ay9hWXV4WS8zYkQ0?=
 =?utf-8?B?dVFJRnkwR2hIbnJ3UE5iUGtYMnY1Y3lOS1NqQ0FxYlZraVZiNzMxRFk0dDlo?=
 =?utf-8?B?NmY4R3hwaml6M2FqRHpOTWh5SEJ2MUFoVXdDR2xvWVNOWmppV0F5Z21zdGdV?=
 =?utf-8?B?b29Fc0kwcXpRUVRFZWI1dmNLelcwM3lwL3IwVXNlQjhzeGlBb3BqOWxzV3hE?=
 =?utf-8?B?RUNCMUpFWVUxdzU4dlZRYVdaaXVzYlJjaHo2T05ESzVEQmxWandHaXdUR09U?=
 =?utf-8?B?SU9jSnZVVVVoMklTNUszdktDa3VsemRuV0xhWnVHM0pJTUluWlVnOTFTUEk1?=
 =?utf-8?B?ZlJmVzhCRlR1NWZQTEVqdGsvSk9FdkpSRU1vdFc1SnROYStiVGdxTFBScDc1?=
 =?utf-8?B?eDQreTJlT2FpVmJGN3dNUkdTQ3ljWXkwV1IwSGYwQ2R2dXBLSWp5ZUd5ZXhy?=
 =?utf-8?B?TWVIQXI1akdqWGg2V1dROE14djdJRDVDOGh4OENiN1lNQVArMmFOblp2SDRV?=
 =?utf-8?B?WHZwVVkxdWROeVNDUDl4TGM4ZjF3U3QrMkRIS2sxdUF4MkYwN0Z5MWtxM01F?=
 =?utf-8?B?bnhDZkZJR1hmZjhlUTBWUUFpajk2QVhCY3ZVRkVCSXBKREZ5NEVhTmNIVU5s?=
 =?utf-8?B?eHphWDVPUXRaVEYzNldraDFObXFtM3BQcFhPbS9pcnZzZVVYYmpSRGtWV3c0?=
 =?utf-8?B?MVl1UUIyVDAvWFlSVkZsWnFJc2ZOaGJIVms1MHNxTUhOSUdLQ3pPUlV1d3RI?=
 =?utf-8?B?clhsQW5MZDJ1RHlyVFpiQkR5QlVkTlI5c1VrWWVXdk5BSExkYTVXNzJnalRt?=
 =?utf-8?B?aVJYS2tPZWtrYnJkMGZDK1RMQ0tuYjA1dTQvczV2Z0RkcmdJTlVEZTNsKzdw?=
 =?utf-8?B?dngySy9GSUgwNGg1UUNQNDFjcWhJRkxnY2ZaREVkOXQ0UnJyYlhXU0tsSkE0?=
 =?utf-8?B?RlhsQ3pTaERma09UN1g3NTY2UjRabWZkS2Y3Z3RydTI2YmRJaFJJczh0QmN3?=
 =?utf-8?B?MnNsaXQ1ZTdtblNKTWoxaDhJNW5XNU1PTEpFbVlWZFZLODYyNktMa1RFakZa?=
 =?utf-8?B?WVBvTDVXRGtNaE8wdUdBQk5vSUpXOTdDbE5GZkpNdWNna0hmTC9QNzdMVk1o?=
 =?utf-8?B?eDVIMFNmWHFzTUdYMkVYbVFsY1c3VWVqZ2lOdHc5RWFhT3NUVlhRVk95MXVG?=
 =?utf-8?B?eUFUdUNOQlc3bW1OcUV6K1lwRzgxbnA5RE1qdEFtTHoyTC96cldzYlQ5TUw2?=
 =?utf-8?B?MFVMRDRvd0I3c3RyVURzZUJaVGFoQzVXUjFJckNQdTlIdHhFVFg5cFVITkVp?=
 =?utf-8?B?NnVLQU9IQnMxSGJLNGFJUFBEM2gweU1UdkRTWWtxbUdMOFRxWC9PWHVqd1By?=
 =?utf-8?B?SnNQemJJM29PbjRSNWxuckVtZ1Jkc3JhYmZkQ0RRZlgvKyt2S1lwSEZYL1k1?=
 =?utf-8?B?WHFKdGJGVVJleHBBcUt3LzhqQis1K3JLNnQ3SU5KeWdmbWJSM0JvUkQvWUJW?=
 =?utf-8?B?VG5Zc25mSjFFd3lDMDZwaGlUdGxLVkFpeE1ialRzRnF4ek9IQXpRWlhqc2xJ?=
 =?utf-8?B?V001ZkFHUFVpMWY2cThpNzk4a2tqRTlzZlRSSEtNSThnaEptMUg0WE5NNHJy?=
 =?utf-8?B?NFIyM3VEdFRkSGQ5MDU1ZlAzY3dZN2dPQnhWazhEKzl1MnltUmJYMEZTYWp2?=
 =?utf-8?B?emRENVlGR2xMbE1DL1lya3g0bXZud3Z2eHlGVDZyMmduRzN6NzBFU2pJVXJ4?=
 =?utf-8?B?M2wxVnRqa1EzaURlRmoyUS8xYmxESUZkVGtrOHJGNCtPRTUyYlREMklibVVW?=
 =?utf-8?B?OEZjaTJjOWU3S1FKRzFidDdOQnpnZ2dhSG8vU2N3eFVHQkJnMFZlZHdYSHZ2?=
 =?utf-8?B?SHVoVHNXRE5GQlJIb1JnUG5IZEhmUVNxL3pwbGwzdS9ZaDQvbUlSYUtDNm1H?=
 =?utf-8?B?cnNqMmZ1VWI5QWh5bWFISit1S2FkZXJ1T016S0ZLZnJsUzJxUG51a2xleFl0?=
 =?utf-8?B?QmxXelZGb2tkN0VPbWEzR3R5Q2Frb0xPVnJhVkovSzlTTUs2ZjBoQ3RReTBk?=
 =?utf-8?B?cFIyaUdQbTBuQkt1eWZGS3pneEFCZW5rbG8rQnBqc216c3VLUkxPVHU4YTNW?=
 =?utf-8?Q?H2M85Ik/+nEZbsppKwNsm5T7h?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bb49f2f-c7f9-4614-f1e0-08daac4f3ca6
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 12:42:34.8032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +echtYFIPF8QzbBFS6usijur+/X/CdOrCJAY7QwPEattCXLvvCR2jw1js8/dsoemvRbhYFRcOzG8jlh+/+7NvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5759
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/12/22 04:31, Herbert Xu wrote:
> On Fri, Oct 07, 2022 at 08:24:06PM +0000, Limonciello, Mario wrote:
>>
>> I noticed you sent out the 6.1 PR already.  So I Just wanted to make sure this
>> didn't get overlooked as it's already got a T-b/A-b.
> 
> Hi Mario:
> 
> This didn't make the deadline for inclusion in my 6.1 PR.  Is there
> any reason why it has to go in this merge window rather than the next?
> 
> Thanks,

Some other maintainers take new IDs as fixes.  Particularly when they're 
good candidates for cc stable.

The main reason I wanted to see it sooner is so that it has more time to 
percolate to the various downstream distros so that errors stemming from 
the lack of this ID declaration aren't prevalent when using this SOC.
