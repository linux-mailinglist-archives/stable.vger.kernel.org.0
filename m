Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28AFF5AF05D
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 18:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234763AbiIFQ1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 12:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234881AbiIFQ0x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 12:26:53 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B0CA721D
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 08:57:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EU9yltqEtJMQ1vkN/WyESXfsGFENYYE50o6o+UCj/6FjMdAk+4JJ+YmIdbiKHJ0sGmVethxbIZI2c2pXacBYy5GRJopiygqG8SksniGdNZqV0jEGGf7zL4QVlPN+TR0TCUlnBaagHeyvccB2aIi1WXmI3YB3ittseaT/DaWVobrMIjxGD2IloIWVxfuzAxzNRkgjwF2nItvLZnHmSATSc9ExcbLPTX8wOva+A1r7fnpsPHuD/cUGWFSFUfIsnQ/OJZi0vxN7rPCcvJUM5ogr4Z2852Udp5CzPs4iPFHH86eUwlN33ubgEdsUO0FBDuqbtSLYDuNqciRBziw7xDBneg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=piq2GV3S+vg2FO/Dy3qDVudvBXd+j32ovQDYQvMMxQc=;
 b=R8y7uhiK/H+nG/0ku5Vtbdn9xdVZOVbjTfIZKvmUH0+3I4vF0VK6IYLPGeAxosV9tfH8HlxYM4/OyIujd4wuaGSo7535QD0k6csB+1thkWWLdf8bF5ouNFHS/57lste4iVZD79sLgiC/sFr9pFNLyjVwbY/P85a2rNNsfHYvu8Sl7KGys2wzj2RbgQp6Oz3Oki4mXj9Hhukjk+pYCA+0+0Z+bfqFwysUBrIPImwusBaqmR+sGPb0jUT8YWr/bf3lATHG0gfZ2IMF3s8v1d9JndsYd8a01Sdf3qMUMn4vaocXxvrXImVeVEohZeNA6I4e3VjYQziZhM99GO9BVAgFDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=piq2GV3S+vg2FO/Dy3qDVudvBXd+j32ovQDYQvMMxQc=;
 b=IlzJvzfFG9uj0Oyh9XT1RA9HlExx6HvqatZ8ofgWeDrK8x3D50PRUFOixId6+20rpr1METEVi+pvJMJUHDNENcNWI06SoDloAusP/38UYpTktnSK91Dp6dkJ/xPlHg6/ahotx4qNmZ8eLs4vAQhkWYw3wUnhLnyDbyCdFEXZAt0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BYAPR12MB4614.namprd12.prod.outlook.com (2603:10b6:a03:a6::22)
 by PH8PR12MB6868.namprd12.prod.outlook.com (2603:10b6:510:1cb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Tue, 6 Sep
 2022 15:56:50 +0000
Received: from BYAPR12MB4614.namprd12.prod.outlook.com
 ([fe80::2925:100a:f0b9:9ad8]) by BYAPR12MB4614.namprd12.prod.outlook.com
 ([fe80::2925:100a:f0b9:9ad8%3]) with mapi id 15.20.5588.016; Tue, 6 Sep 2022
 15:56:50 +0000
Message-ID: <9c0f87b0-b336-989c-b339-ac92c83b1fc1@amd.com>
Date:   Tue, 6 Sep 2022 21:26:37 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v2 1/2] drm/amdgpu: Move HDP remapping earlier during init
Content-Language: en-US
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     amd-gfx@lists.freedesktop.org, Felix.Kuehling@amd.com,
        stable@vger.kernel.org, tseewald@gmail.com, helgaas@kernel.org,
        Alexander.Deucher@amd.com, sr@denx.de, Christian.Koenig@amd.com,
        Hawking.Zhang@amd.com
References: <20220829081752.1258274-1-lijo.lazar@amd.com>
 <CADnq5_O=3u1Z4kH_5A+UsynQ31Grh-=j=3+hPWo398kfMi411w@mail.gmail.com>
 <3b2a9a8f-dedf-2781-0023-d6bd64f16d65@amd.com>
 <CADnq5_P0=+NNk2v_VOxyjOVSnY55SY=OX40xD5Bx6etspREnfA@mail.gmail.com>
 <1890aec6-a92d-e9b7-a782-fd6b0e8f8595@amd.com>
 <CADnq5_Pkpe_-SH8Wh=_s6FXDFEWvO8rr5Ls2=Q4HRXy9+eSOBQ@mail.gmail.com>
 <9ef0287a-e463-d440-58fe-0323a6eca94a@amd.com>
 <CADnq5_P1VV2zWpjtsedPCoJH_CKv+d-MuVJwxOBbdpo1fLFCjA@mail.gmail.com>
 <CADnq5_O1Z0FK99cKDmRuCoxg-hbD3LtcW1q3n4zvrB9xFo0XHw@mail.gmail.com>
 <e90fe5d6-2b19-f253-f2d9-e538c152ec75@amd.com>
 <CADnq5_NmgfsXcXdRpi3NkJKgKGGCZrY-NPmrJtuPmuarCD11OQ@mail.gmail.com>
From:   "Lazar, Lijo" <lijo.lazar@amd.com>
In-Reply-To: <CADnq5_NmgfsXcXdRpi3NkJKgKGGCZrY-NPmrJtuPmuarCD11OQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0170.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:de::12) To BYAPR12MB4614.namprd12.prod.outlook.com
 (2603:10b6:a03:a6::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5030b712-907a-4512-8c44-08da90206869
X-MS-TrafficTypeDiagnostic: PH8PR12MB6868:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jfjAbW88/gWPuhY6NfnkyZ+T5f9ho54j6tZ+wvmRVrX9C8qRNVa6DD4Cggqybygjf3ULahbkMTiInH33PViz6zoVHq7ofPTNiaUP1yQb7FBPk3uuwf7wepVZByZur1TI9XChmJBH9Ggt1YZnsk2sxn5zX0A9aDg2LRLTnc4Pm6mEpwPiDVwjK64sOtbMd2Nn5QHHi+bu9CLP+vs+t4btx1UJ1hrOmHGQ3NfyGJNoTTR5coOyoy3yLUdZIWKddAjzjdJNf9rRt/HyPd/rUCTPoi5elsO0tydUFpOsTPe6DMhR0hSyqBhP9hFZR0CH1HabVUlZIfaEfDL713YnGQq5zN8AoKvWN6E2infgE8essdFJthmvwYgMKIHTDhXZntpzPuIUhtwfapKyzm5z1WBm3qVb/cjOMH4MiQVgyZm+biO1ji+Rh61HsfIGIRcfec+b56IyxgODh8BKvP4bYKDheKwAv8pWPt6nIihVRXhZgsaiK65Ox7tCqYJNZESvhFVaPiKOIm1lCElDdv9EhBd+P45ZxmQs4uSeYNklA5h7sPwxAv6KiVg4gugqvzwCLgHyFIolnzKmF8612ASSRFABu9sn8wCsRowvTI/EBSKAf9UIxLqP83vNzxNCdtUnjreAR1xUJp0ynS6AkNN+0VwDPXvxyyu8NE+twukNJGBNK/hVsiFCuwaYPhOZJQN+I0OPnzG0bWpG9wYo5/pBfjllI4DxGP0/uBJux3A2C+a8Y2IsDGmF7mEFO4dT/ZTcGSEtGLTDTXNw1v69uiDYhhKDlwkhN8BpIov9BAePowMr0dX7eWU088QsKK7rJEXk6nTwr8jygjsQ1c5pfkrm1hgHOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4614.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(366004)(346002)(136003)(39860400002)(36756003)(66476007)(478600001)(30864003)(8936002)(66556008)(8676002)(4326008)(6916009)(316002)(966005)(66946007)(2906002)(31686004)(41300700001)(45080400002)(6486002)(2616005)(53546011)(186003)(6506007)(86362001)(6512007)(31696002)(6666004)(83380400001)(26005)(5660300002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dlYyNzJCZlFOZGIyWDBPeGxaTGlkTWVSV3l0aVBQd3NYZ29DK1pKRlpHS1lx?=
 =?utf-8?B?OFJtUkFZd0Ruby91YXpIc0ZtMlRIUmk1SUdyQnZlTzJQVHQzQ1NZWDdCMnND?=
 =?utf-8?B?ekxOK0FmRTQzd2tyMTBNSi9HdkltSmdtNjVqTzNOcTBzMlFldUFzaGhRU3Fa?=
 =?utf-8?B?OTVaV1cyeDRTZnYrK29FUTdWOFNaUVJNQWdBTDZoaEs0V29pbklxSlgyU3or?=
 =?utf-8?B?QUVRSG5LTnVRSlNjcW04RjJVR3IvbjBLU3UrZjl2aE5ZYzZzQ3Bpa29vQkdH?=
 =?utf-8?B?ejRXNGhVMDdZaEQyZjRBYjdycDN1dVBTeG1WY2Y2VVVVSWE3a3RFS0hoTGhq?=
 =?utf-8?B?cHBFcWhVanZabm1VNDBlZFY1R1pTUmtFWFdyaFVFTXg1aEtmdGs2OE8yeTFm?=
 =?utf-8?B?QmJQQnptUjMwNlVOUExqck1tMGw4TnN5djhXK0UweUZ1THpobytIT280RUV6?=
 =?utf-8?B?MFZRd1dKM2trbUhsNENuSktZR2huSGdJTVZUMmFzRU41Z25hKzVUN21zaFJH?=
 =?utf-8?B?QlYzeVZRVnlqNko3Wm1zYThoVzNUSUFMcWlXeWNTSEI1R2FiOE5PeDc2WG83?=
 =?utf-8?B?RGptTzJtU3lCNXp3ZW9LS2J3bll5ZXo0MG80MWNGYis1Z1VTWG4rclI4NytE?=
 =?utf-8?B?dkxGbmZab0ZWUWV5MTAyZkdmeUt2ZTk3MW9xdWYyalVMWHVjeUkyd3lWY2lK?=
 =?utf-8?B?SGxGbHVDNUlRMVVlMlRURllyb3l0RTRsUGdOZURFT0t6V2RtaHFHNEVOVXdi?=
 =?utf-8?B?WGdoeGVkSTVoQTkzbEZvL29kekhKdEFyRmV6VDUvdHU5clJTMUlqTzZDTHJv?=
 =?utf-8?B?YUErajcyMTgvMEhzSW9uSmpzNW1tY0c3ZlhCSUNQRnBVcXVqZ0g5YVRrUFd3?=
 =?utf-8?B?QVVEd1YzdGh6MDlmNWFXQW5zZVNhU0hDc0pyUWd6MWRoVjRYVTZSaW5GL1NQ?=
 =?utf-8?B?blJLZUcxcGh3a01NaVVOWXE2RVl1L1hjQWY1S2Z0SHdsbFZsZ3Blb2hidm1Z?=
 =?utf-8?B?S3dQT1o3TklpU0ExSDExZXJtek5Uci9LWUFYR3ZUYUx1ZEJROEhobStNMHZP?=
 =?utf-8?B?T3M3c0cxblJkRlpPUWRrR3lpSHhyckJCR1RlekMvWnQwMXEvMmNRYlpmSXFZ?=
 =?utf-8?B?dHl4UWM3ZGRPRklKRnZvZTJ2Y0crTTRvRFd1aUxnKzREZ1NVTGhLMU4rRnhj?=
 =?utf-8?B?OGdveVRnV3dYUDEzc1dHbVJyTFVVQ2dlZnh1TVNlRk1JYVlUd21HVEZLTlRX?=
 =?utf-8?B?Tlpnb1hsTEdFendLUERmQk01Nzdxa3ZYUXFSb2ZieGdxcjBqTDIyazByVFkx?=
 =?utf-8?B?a2xhbUxKdDJHMFR3REM1dHIxc3ZjRlA1cnEwcjV3aW5oNUJ2Zkx1MnVvbE1E?=
 =?utf-8?B?SThIZmVFV09meCtmRmRoZnplb25ONTgyd1Z1TnM2cXp1ZmlqWldFa1RjZG1t?=
 =?utf-8?B?ek1ZSWRaUU9qWnU0cjJiOTdsRElDdC9TVzNIeDVMY09QWVZ2ZVF5SC82cmJR?=
 =?utf-8?B?U0RGVXZYWGxIdnJkME84cmdiYnlBSmFYVngvczJxT2VOcGIxZEYyaU1JWTNO?=
 =?utf-8?B?RFZqREhuSkhVZGM3V3dPdG50cC9reWh4c2Y5dWp6YnNrLzg1QWZybWw4S0c0?=
 =?utf-8?B?dXo1MW9reHp0L082Q1AwY0Z3cXJDWkhkT2o0UTFjVjB1UEVGeUNVSlduOEY0?=
 =?utf-8?B?aWQzVU41TXVvSXpzcXQ2SC9SRUt5bXJUVDR2NlpjWlRVNGhGVzhmTHQ0NUNU?=
 =?utf-8?B?UGg4UDMvTVpPeVVUWHFqNXhmNHJuZ1NyNzdhaVR6cTQ0cXhJck5Rb2szNXNI?=
 =?utf-8?B?ckxndEFPZEdEM243UUxTa2JndVZGcUdNdG9jL0dWdXBWKzA2UzJ6bXZKU2Fz?=
 =?utf-8?B?RHF6bXlDWUROVWx0ZnRBZDBPYnBWL1M1Y1hsNVpnbFl5c0lNdGJycWQvL0p5?=
 =?utf-8?B?b3VOdUZ0Y1FEa29uSDduejFKSnVTYkZQc0lDSXJvYlJrYnZyZWdHZitRUzhJ?=
 =?utf-8?B?cGNhUUk4TW5GYUpqakFtQ0ZjTkRuS2pmREhpU0ZVUld5TDhKZ2tNTnRlVnNW?=
 =?utf-8?B?dWRxcGx1WVVXTm1xa01SQWZqUHZURlhOODhMNzBZMktYU0pyYjJ6ZWR5WWRu?=
 =?utf-8?Q?za+sD2Oi7u0CeQrNIBsUxceZh?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5030b712-907a-4512-8c44-08da90206869
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4614.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 15:56:50.0821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iIICLKL8NrckwFapu1uHbjgtRyP1qH/eth1ONlU4zwBFAEEKOQX+zPAPuFnY2yv8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6868
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/6/2022 8:55 PM, Alex Deucher wrote:
> On Mon, Sep 5, 2022 at 1:27 AM Lazar, Lijo <lijo.lazar@amd.com> wrote:
>>
>>
>>
>> On 9/2/2022 1:09 AM, Alex Deucher wrote:
>>> How about this?  We should just move HDP remap to gmc hw_init since
>>> that is mainly what uses it anyway.
>>>
>>
>> Sorry, I missed to R-B the previous version. Did you find any problem
>> when common block is initialized first?
>>
> 
> One of the users on the bug report reported an issue with that patch,
> that said, that user seems to be seeing a slightly different issue
> since he is on a gfx9 card and the original reporter was on gfx10.
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugzilla.kernel.org%2Fshow_bug.cgi%3Fid%3D216373&amp;data=05%7C01%7Clijo.lazar%40amd.com%7C5d6d4da1be4a4194b7cc08da901c0bb4%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637980747398632310%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=hHoh2YpQ2vpjsRTEqI1vIRY4YQmzfFi5%2FG%2Fnh6vNuds%3D&amp;reserved=0
> 

Yes, I see Bjorn already pointed to another potential issue in LTR 
enablement. So regardless of init-common-first patch, the new error will 
be reported and that is unrelated to the original reported error through 
AER. I still think init-common-first patch is good.

Thanks,
Lijo

> Alex
> 
> 
>> I think that patch provides a consistent IP init sequence during cold
>> init and resume.
>>
>> Thanks,
>> Lijo
>>
>>> Alex
>>>
>>> On Tue, Aug 30, 2022 at 2:05 PM Alex Deucher <alexdeucher@gmail.com> wrote:
>>>>
>>>> On Tue, Aug 30, 2022 at 12:06 PM Lazar, Lijo <lijo.lazar@amd.com> wrote:
>>>>>
>>>>>
>>>>>
>>>>> On 8/30/2022 8:39 PM, Alex Deucher wrote:
>>>>>> On Tue, Aug 30, 2022 at 10:45 AM Lazar, Lijo <lijo.lazar@amd.com> wrote:
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> On 8/30/2022 7:18 PM, Alex Deucher wrote:
>>>>>>>> On Tue, Aug 30, 2022 at 12:05 AM Lazar, Lijo <lijo.lazar@amd.com> wrote:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> On 8/29/2022 10:20 PM, Alex Deucher wrote:
>>>>>>>>>> On Mon, Aug 29, 2022 at 4:18 AM Lijo Lazar <lijo.lazar@amd.com> wrote:
>>>>>>>>>>>
>>>>>>>>>>> HDP flush is used early in the init sequence as part of memory controller
>>>>>>>>>>> block initialization. Hence remapping of HDP registers needed for flush
>>>>>>>>>>> needs to happen earlier.
>>>>>>>>>>>
>>>>>>>>>>> This also fixes the Unsupported Request error reported through AER during
>>>>>>>>>>> driver load. The error happens as a write happens to the remap offset
>>>>>>>>>>> before real remapping is done.
>>>>>>>>>>>
>>>>>>>>>>> Link: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugzilla.kernel.org%2Fshow_bug.cgi%3Fid%3D216373&amp;data=05%7C01%7Clijo.lazar%40amd.com%7C5d6d4da1be4a4194b7cc08da901c0bb4%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637980747398632310%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=hHoh2YpQ2vpjsRTEqI1vIRY4YQmzfFi5%2FG%2Fnh6vNuds%3D&amp;reserved=0
>>>>>>>>>>>
>>>>>>>>>>> The error was unnoticed before and got visible because of the commit
>>>>>>>>>>> referenced below. This doesn't fix anything in the commit below, rather
>>>>>>>>>>> fixes the issue in amdgpu exposed by the commit. The reference is only
>>>>>>>>>>> to associate this commit with below one so that both go together.
>>>>>>>>>>>
>>>>>>>>>>> Fixes: 8795e182b02d ("PCI/portdrv: Don't disable AER reporting in get_port_device_capability()")
>>>>>>>>>>>
>>>>>>>>>>> Reported-by: Tom Seewald <tseewald@gmail.com>
>>>>>>>>>>> Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
>>>>>>>>>>> Cc: stable@vger.kernel.org
>>>>>>>>>>
>>>>>>>>>> How about something like the attached patch rather than these two
>>>>>>>>>> patches?  It's a bit bigger but seems cleaner and more defensive in my
>>>>>>>>>> opinion.
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Whenever device goes to suspend/reset and then comes back, remap offset
>>>>>>>>> has to be set back to 0 to make sure it doesn't use the wrong offset
>>>>>>>>> when the register assumes default values again.
>>>>>>>>>
>>>>>>>>> To avoid the if-check in hdp_flush (which is more frequent), another way
>>>>>>>>> is to initialize the remap offset to default offset during early init
>>>>>>>>> and hw fini/suspend sequences. It won't be obvious (even with this
>>>>>>>>> patch) as to when remap offset vs default offset is used though.
>>>>>>>>
>>>>>>>> On resume, the common IP is resumed first so it will always be set.
>>>>>>>> The only case that is a problem is init because we init GMC out of
>>>>>>>> order.  We could init common before GMC in amdgpu_device_ip_init().  I
>>>>>>>> think that should be fine, but I wasn't sure if there might be some
>>>>>>>> fallout from that on certain cards.
>>>>>>>>
>>>>>>>
>>>>>>> There are other places where an IP order is forced like in
>>>>>>> amdgpu_device_ip_reinit_early_sriov(). This also may not affect this
>>>>>>> case as remapping is not done for VF.
>>>>>>>
>>>>>>> Agree that a better way is to have the common IP to be inited first.
>>>>>>
>>>>>> How about these patches?
>>>>>>
>>>>>
>>>>> Looks good to me. BTW, is nbio 7.7 for an APU (in which case hdp flush
>>>>> is not expected to be used)?
>>>>
>>>> It would be used in some cases, e.g., GPU VM passthrough where we use
>>>> the BAR rather than the carve out.
>>>>
>>>> Alex
>>>>
>>>>
>>>>>
>>>>> Thanks,
>>>>> Lijo
>>>>>
>>>>>> Alex
>>>>>>
>>>>>>
>>>>>>>
>>>>>>> Thanks,
>>>>>>> Lijo
>>>>>>>
>>>>>>>> Alex
>>>>>>>>
>>>>>>>>>
>>>>>>>>> Thanks,
>>>>>>>>> Lijo
>>>>>>>>>
>>>>>>>>>> Alex
>>>>>>>>>>
>>>>>>>>>>> ---
>>>>>>>>>>> v2:
>>>>>>>>>>>              Take care of IP resume cases (Alex Deucher)
>>>>>>>>>>>              Add NULL check to nbio.funcs to cover older (GFXv8) ASICs (Felix Kuehling)
>>>>>>>>>>>              Add more details in commit message and associate with AER patch (Bjorn
>>>>>>>>>>> Helgaas)
>>>>>>>>>>>
>>>>>>>>>>>       drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 24 ++++++++++++++++++++++
>>>>>>>>>>>       drivers/gpu/drm/amd/amdgpu/nv.c            |  6 ------
>>>>>>>>>>>       drivers/gpu/drm/amd/amdgpu/soc15.c         |  6 ------
>>>>>>>>>>>       drivers/gpu/drm/amd/amdgpu/soc21.c         |  6 ------
>>>>>>>>>>>       4 files changed, 24 insertions(+), 18 deletions(-)
>>>>>>>>>>>
>>>>>>>>>>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
>>>>>>>>>>> index ce7d117efdb5..e420118769a5 100644
>>>>>>>>>>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
>>>>>>>>>>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
>>>>>>>>>>> @@ -2334,6 +2334,26 @@ static int amdgpu_device_init_schedulers(struct amdgpu_device *adev)
>>>>>>>>>>>              return 0;
>>>>>>>>>>>       }
>>>>>>>>>>>
>>>>>>>>>>> +/**
>>>>>>>>>>> + * amdgpu_device_prepare_ip - prepare IPs for hardware initialization
>>>>>>>>>>> + *
>>>>>>>>>>> + * @adev: amdgpu_device pointer
>>>>>>>>>>> + *
>>>>>>>>>>> + * Any common hardware initialization sequence that needs to be done before
>>>>>>>>>>> + * hw init of individual IPs is performed here. This is different from the
>>>>>>>>>>> + * 'common block' which initializes a set of IPs.
>>>>>>>>>>> + */
>>>>>>>>>>> +static void amdgpu_device_prepare_ip(struct amdgpu_device *adev)
>>>>>>>>>>> +{
>>>>>>>>>>> +       /* Remap HDP registers to a hole in mmio space, for the purpose
>>>>>>>>>>> +        * of exposing those registers to process space. This needs to be
>>>>>>>>>>> +        * done before hw init of ip blocks to take care of HDP flush
>>>>>>>>>>> +        * operations through registers during hw_init.
>>>>>>>>>>> +        */
>>>>>>>>>>> +       if (adev->nbio.funcs && adev->nbio.funcs->remap_hdp_registers &&
>>>>>>>>>>> +           !amdgpu_sriov_vf(adev))
>>>>>>>>>>> +               adev->nbio.funcs->remap_hdp_registers(adev);
>>>>>>>>>>> +}
>>>>>>>>>>>
>>>>>>>>>>>       /**
>>>>>>>>>>>        * amdgpu_device_ip_init - run init for hardware IPs
>>>>>>>>>>> @@ -2376,6 +2396,8 @@ static int amdgpu_device_ip_init(struct amdgpu_device *adev)
>>>>>>>>>>>                                      DRM_ERROR("amdgpu_vram_scratch_init failed %d\n", r);
>>>>>>>>>>>                                      goto init_failed;
>>>>>>>>>>>                              }
>>>>>>>>>>> +
>>>>>>>>>>> +                       amdgpu_device_prepare_ip(adev);
>>>>>>>>>>>                              r = adev->ip_blocks[i].version->funcs->hw_init((void *)adev);
>>>>>>>>>>>                              if (r) {
>>>>>>>>>>>                                      DRM_ERROR("hw_init %d failed %d\n", i, r);
>>>>>>>>>>> @@ -3058,6 +3080,7 @@ static int amdgpu_device_ip_reinit_early_sriov(struct amdgpu_device *adev)
>>>>>>>>>>>                      AMD_IP_BLOCK_TYPE_IH,
>>>>>>>>>>>              };
>>>>>>>>>>>
>>>>>>>>>>> +       amdgpu_device_prepare_ip(adev);
>>>>>>>>>>>              for (i = 0; i < adev->num_ip_blocks; i++) {
>>>>>>>>>>>                      int j;
>>>>>>>>>>>                      struct amdgpu_ip_block *block;
>>>>>>>>>>> @@ -3139,6 +3162,7 @@ static int amdgpu_device_ip_resume_phase1(struct amdgpu_device *adev)
>>>>>>>>>>>       {
>>>>>>>>>>>              int i, r;
>>>>>>>>>>>
>>>>>>>>>>> +       amdgpu_device_prepare_ip(adev);
>>>>>>>>>>>              for (i = 0; i < adev->num_ip_blocks; i++) {
>>>>>>>>>>>                      if (!adev->ip_blocks[i].status.valid || adev->ip_blocks[i].status.hw)
>>>>>>>>>>>                              continue;
>>>>>>>>>>> diff --git a/drivers/gpu/drm/amd/amdgpu/nv.c b/drivers/gpu/drm/amd/amdgpu/nv.c
>>>>>>>>>>> index b3fba8dea63c..3ac7fef74277 100644
>>>>>>>>>>> --- a/drivers/gpu/drm/amd/amdgpu/nv.c
>>>>>>>>>>> +++ b/drivers/gpu/drm/amd/amdgpu/nv.c
>>>>>>>>>>> @@ -1032,12 +1032,6 @@ static int nv_common_hw_init(void *handle)
>>>>>>>>>>>              nv_program_aspm(adev);
>>>>>>>>>>>              /* setup nbio registers */
>>>>>>>>>>>              adev->nbio.funcs->init_registers(adev);
>>>>>>>>>>> -       /* remap HDP registers to a hole in mmio space,
>>>>>>>>>>> -        * for the purpose of expose those registers
>>>>>>>>>>> -        * to process space
>>>>>>>>>>> -        */
>>>>>>>>>>> -       if (adev->nbio.funcs->remap_hdp_registers && !amdgpu_sriov_vf(adev))
>>>>>>>>>>> -               adev->nbio.funcs->remap_hdp_registers(adev);
>>>>>>>>>>>              /* enable the doorbell aperture */
>>>>>>>>>>>              nv_enable_doorbell_aperture(adev, true);
>>>>>>>>>>>
>>>>>>>>>>> diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
>>>>>>>>>>> index fde6154f2009..a0481e37d7cf 100644
>>>>>>>>>>> --- a/drivers/gpu/drm/amd/amdgpu/soc15.c
>>>>>>>>>>> +++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
>>>>>>>>>>> @@ -1240,12 +1240,6 @@ static int soc15_common_hw_init(void *handle)
>>>>>>>>>>>              soc15_program_aspm(adev);
>>>>>>>>>>>              /* setup nbio registers */
>>>>>>>>>>>              adev->nbio.funcs->init_registers(adev);
>>>>>>>>>>> -       /* remap HDP registers to a hole in mmio space,
>>>>>>>>>>> -        * for the purpose of expose those registers
>>>>>>>>>>> -        * to process space
>>>>>>>>>>> -        */
>>>>>>>>>>> -       if (adev->nbio.funcs->remap_hdp_registers && !amdgpu_sriov_vf(adev))
>>>>>>>>>>> -               adev->nbio.funcs->remap_hdp_registers(adev);
>>>>>>>>>>>
>>>>>>>>>>>              /* enable the doorbell aperture */
>>>>>>>>>>>              soc15_enable_doorbell_aperture(adev, true);
>>>>>>>>>>> diff --git a/drivers/gpu/drm/amd/amdgpu/soc21.c b/drivers/gpu/drm/amd/amdgpu/soc21.c
>>>>>>>>>>> index 55284b24f113..16b447055102 100644
>>>>>>>>>>> --- a/drivers/gpu/drm/amd/amdgpu/soc21.c
>>>>>>>>>>> +++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
>>>>>>>>>>> @@ -660,12 +660,6 @@ static int soc21_common_hw_init(void *handle)
>>>>>>>>>>>              soc21_program_aspm(adev);
>>>>>>>>>>>              /* setup nbio registers */
>>>>>>>>>>>              adev->nbio.funcs->init_registers(adev);
>>>>>>>>>>> -       /* remap HDP registers to a hole in mmio space,
>>>>>>>>>>> -        * for the purpose of expose those registers
>>>>>>>>>>> -        * to process space
>>>>>>>>>>> -        */
>>>>>>>>>>> -       if (adev->nbio.funcs->remap_hdp_registers)
>>>>>>>>>>> -               adev->nbio.funcs->remap_hdp_registers(adev);
>>>>>>>>>>>              /* enable the doorbell aperture */
>>>>>>>>>>>              soc21_enable_doorbell_aperture(adev, true);
>>>>>>>>>>>
>>>>>>>>>>> --
>>>>>>>>>>> 2.25.1
>>>>>>>>>>>
