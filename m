Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 646E65A668C
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 16:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiH3OqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 10:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiH3Op7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 10:45:59 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2087.outbound.protection.outlook.com [40.107.96.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A66A2610
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 07:45:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OAVXYv/Cwv4AqULoYL/qeBkqOHIwp5pTGrIgawdiomjAPiPih5zP1IWNaj6SeAZGV6gS9wZyfQL0Hw+LSKF8e5THnyNO+GQ9ivOWxZY91ke622RwIHSCcytUsX5vy7x4aBo6MItT2/PQjLjO98a0yxj1AKWuuG/pLJWKFnnH7ZXq5tgqg5vdF3AkMMjvnXhcFpylCiE7HXvAJmNODukb4TWv2pX97bVvUzn0sKt0n/dF1vFgeKDqAjLf+o1OyowD6Qh5DSma+qy7DSIsKAYUz1fkVxEymOdjqI6SLtSJvfEgcrsug893KQ39bLFdE/eddc9ItHIcX8Oetaj3rogelg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FZQ7OKMRvB8PT80Fkq39hPxIgjXsOrrjVP8+YGHLdZQ=;
 b=DG1ZYxOUbS0zmqYBNzNa0YhmTYz1RTEVyWLaBkAn+51ziGgqiWInj6/kHphQ2hgcmXJsr5pkAGLuDAkkTyuZpjQBSXy0wg/aUs37DB6QXTdfpCrVnO0NTfWx1/Uup3zaEFuA6rpynfxQRFwYEQiDYQ31D8N+UHdeLTxo60H4dfvUyNy01Kj9fuPIBqh0V6EwkFy1v7fCeH0mHO5OW5WmSkpSruf9yvpHzSKwGIeUIimKVjPRy+dSbXLcoS/rvnj49HttkqgNtiP+qdWKvVp1CzDcqOE2l60uWfTy0fz24jfQ42dk799DObLJqwCDizrcYAHxsj/dV34MJxwYMgL8vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FZQ7OKMRvB8PT80Fkq39hPxIgjXsOrrjVP8+YGHLdZQ=;
 b=l5oiwky2w6YgJAZ4FwFQfUnYXb0kuAA6SaAOgErVPTnQEHTaVvsfnfXRs18IBslYf2MaKA9WTOkIroG3SfV4VrgKVZjvJ/VZdNSlpe/9CXzWol9bZ49h8Z1t3wm9V6oIGbeqxWj52xQCPiykNYTMPEiQkZGtWEFVtHI5XH/+gJc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BYAPR12MB4614.namprd12.prod.outlook.com (2603:10b6:a03:a6::22)
 by DM5PR1201MB0025.namprd12.prod.outlook.com (2603:10b6:4:53::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.16; Tue, 30 Aug
 2022 14:45:53 +0000
Received: from BYAPR12MB4614.namprd12.prod.outlook.com
 ([fe80::2925:100a:f0b9:9ad8]) by BYAPR12MB4614.namprd12.prod.outlook.com
 ([fe80::2925:100a:f0b9:9ad8%3]) with mapi id 15.20.5588.010; Tue, 30 Aug 2022
 14:45:53 +0000
Message-ID: <1890aec6-a92d-e9b7-a782-fd6b0e8f8595@amd.com>
Date:   Tue, 30 Aug 2022 20:15:40 +0530
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
From:   "Lazar, Lijo" <lijo.lazar@amd.com>
In-Reply-To: <CADnq5_P0=+NNk2v_VOxyjOVSnY55SY=OX40xD5Bx6etspREnfA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0102.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:27::17) To BYAPR12MB4614.namprd12.prod.outlook.com
 (2603:10b6:a03:a6::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96af6d54-ce2e-4d6f-ae5d-08da8a965673
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0025:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: buSjOziljZUkRZqRM4rFafv3h11px0etlvO+jxC5gjxiS7JeGh3E9s5nyLTErUKy9Is4onl8yUJPIPUUHd+3u3+WxniypWHZR1vX1l64LWwzErSDERdXAsWeDU1eC/aAbFWW6h2d/Oq/74XTY9MU7yN/tmf8c7WJdLgro5SrP2CnzJLyMoDW+xzQD5gtitX1YN61+OKn+dkXuOd9985qL7CHP4FgTeao0oGpv47SMsjZsv08/R4WT90U/FOg6a04IFpREbGrV656HsmNe4sgjsRu6AHRnI7vif4jzwSGn7snyjYNgPQwxWgMT5WtMxm8QnyeEiv04DrT3CcpkAGA3nSz1fU2tga+Tx8S0epqwqADkv89a5qLEsBY3mFyjyMf/RxyrryNzsYaKlE5LC2DtgminmExyPbV/DCltemfAv5C5VuOMd6Z7qa2/jr4QF8x4c2VIgEf/mEO7mU0gtPMZwio+iyzZKZGFHQU/ykUSZ4Tc3Xh6uC+YkxA/o9eF+qmZL2oTYWhqi0LJPA43TvXn0yAZx6eykxHMR2IYKiYcQPRP+qfce3qXe1beIRgQTZiRUmdxWAhywHlGIfeXjAcZ2bVwPej/j7y8Vv9Tn6gX3YYo7996CunJFgOPfMuvC/qzWZfInCY+RvT887YisC2WRrvFjQN+yYIzzGpvdb3M1JdizZQELmuhFY/5SXWO3wWMS+kKj2KHqUDyTQuS4upCHbD3m27dhVsgVRxSm/6u2GYOP3kKsNgXSHugmbXfP2l7Qtl3eKWrEX3FvvWuaUHlshtR1Mi9py/PHdlfSWNx+aSWGpzA1V85JEbXYH2/l+b
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4614.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(6916009)(316002)(8676002)(86362001)(45080400002)(36756003)(4326008)(966005)(6486002)(66556008)(31696002)(66946007)(66476007)(31686004)(5660300002)(41300700001)(478600001)(8936002)(6666004)(2616005)(6506007)(2906002)(53546011)(38100700002)(83380400001)(26005)(186003)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SlIwQU92Y0RKeVVZTFU5UENBOGJmd1lnRjh3OC9DVTVyTXBkYnhHSnB6UnBT?=
 =?utf-8?B?aVpxZnNuQTYwejUrdmRvWjBIbTlMOGovdHVsUEdkdUc5Z1I0M0o2dFpWYWpv?=
 =?utf-8?B?VlF1NFFQT1pJQlRocEwrNkxOQUV2OC9yc1A2b2pGR3NMcmJIWHhYa2JBZUgv?=
 =?utf-8?B?Q1gxa1p0MDAvY3FoazU0K3ROdVNieWlwMnEvd3VlYzVxLzQyTFArZG9RRlJt?=
 =?utf-8?B?RDRUWVhqOGtzSkZvTDEwSFN3T1A0UW53eVhMZGs2OVEvV3VDMzk1MmJEUWJP?=
 =?utf-8?B?dEJRQ2p4K0Fqbzh2Q2pzZ3JuL1EvTnVBSjBQcUVtU1lFVEY3Tzl2NjBCd1Zp?=
 =?utf-8?B?MGRYM3hQdkFnb2hwclFzUzZNSFRCQ1RWL1hSMUgxZUtzUklSdzZpMVRFT0NE?=
 =?utf-8?B?TmltODJMTVZyV2t0dE03dG1jd0JXTE5LOWpzbXl0a2tUbnVBNkpYaEg1b01z?=
 =?utf-8?B?OVhmbnVyaDZQaldYUDlBTTZ6TitMbHVyS1NydlpzeXNpT3ZHNld2WEtqR0RR?=
 =?utf-8?B?M2NwYTNxY2ZMeEdIaUR6QVU3OUFPSEdEUnlFQWRTdXoraTBBVUNVMFNzdTFH?=
 =?utf-8?B?Y0NqRnRMU01tS3U3THFYbTRZeXRNZ0VmdXg2QUxSUTQ4YU9PT2w0bzUzNFVH?=
 =?utf-8?B?cW9aQW1NcjdDcXk0cU5QZzBzeFFMTFFlOWRDTGZiTFZyYlNyQkpjT3Z1UXBx?=
 =?utf-8?B?V2xlRy84dldKNzFFeXQrMFRjaHNmNVgrajdqV2lNU1dlL2lwa3NjN1doTGZr?=
 =?utf-8?B?NElUV0tLYVNmdjNwUXVRZXlwNDJ1cWlmOWp3ZTFKN1hLOWl2M29oeFVIRThJ?=
 =?utf-8?B?d1EzYWZKaVVtc0xPQ2xVUnBzMmlldWtWb0pxN2tOdlZPWWVraXNNZG13SDdh?=
 =?utf-8?B?Uk93WDRPOGRVQkdaVnRGNFhIT05oaEtPWjBvQXM1TVJlNmdtWVNKQU04WDZo?=
 =?utf-8?B?cmRpbVJBSEtTWTBGemxKNmNqVzYxRFFuT21CSkxsMGVtM2dadGZUdmtRUXlG?=
 =?utf-8?B?U3J2SXpsWEtqekdJTDRQdUw2SU84N3pxVVhrbzhmbytIWUs5bTFhalB2T0pX?=
 =?utf-8?B?YW4rOVdqQW5rWk5kQVhPNVJFYkpMWGEyR3o0WGY5STBpMDU3dDlkR3dQSHhI?=
 =?utf-8?B?TnFYRk1KZ3FFcGQvaXlmQ21QeEJBV3R0bHBDU0FMeGhSTG12eVZXcmRpajN5?=
 =?utf-8?B?TXg2VWdFM0JyaUx0NWtZMWRxdWRtWC9JNVkwYWpOaWc4WldkZFlGK3JBQWpP?=
 =?utf-8?B?djhLSFk5dkJqcTZsVXYrdU5lZnkrSVpiQUtzdGRSRUR5bUoyUVU0VWZ0bGVs?=
 =?utf-8?B?Y0FDdHVJcm43Nkk2bS9Za3VRRkg2ZTlNZHU5dnZqaXFuL2JaR1l5dDlYV3lB?=
 =?utf-8?B?bTdqazcxRitxZk9wQ1dIRktrZ0NQQzJVOEo1OXFXVS9MbEZDODJ0NlJYd3da?=
 =?utf-8?B?dVRGbFkzQ3ZVeTBiMlFHa1Ruak5MZjE1aXp1ZTA2MjQ0RS9CcEptK1ZDY1FW?=
 =?utf-8?B?MzhTTVE3NUZodWgxNzIwU0h0dU5vb2NrcUxyUEJMNVpxWFVMN2FWeWVWa2RD?=
 =?utf-8?B?b3NVbEJIOW5vaFBqdjVjalozN2ZoMnVwdnBFRWY1cmZ2S0szbUFQOXpwcVhj?=
 =?utf-8?B?SjNPd0UxT1Zsd0ZFR1ZpQ1RITVRUQ0RienhFbktzUzI2eEhkMG50T05jYlVL?=
 =?utf-8?B?bU5qTlh6RWdGSDFNYkJrdDNlU2VxN29xaGtBbnl4d1NUNHpMdjhQQ1VIY0F1?=
 =?utf-8?B?czQyNGlzWjlEdHFnbDFtTDZGK0QzOGdBenB4eEJZSWpQQWJsWlNlZDQvZDZS?=
 =?utf-8?B?ay9MTGEwU0FxSUo3NE1jLzZyUjk3ZnFqVHFwVi9SV21TVTlyL3ZPczdxWm9Q?=
 =?utf-8?B?T3VCdDRvcG5qSXMwS0RkRTEyd2VqeGx5Y0xNcndHK2RtaHg0NEM1cVV0RlYv?=
 =?utf-8?B?NEh6TkJFQTR4a2h0ak9DQ1I0b3dvcmc3Y1dML3A0aEQ5M25tT1h5NXh5Y2pK?=
 =?utf-8?B?RHZtUWlLRTlCSUNKMzhNRmtETG1jdnRkSmJaQ2N5alRnYnVZWUlRZ1JwTjhs?=
 =?utf-8?B?SFJtZFZ1aDllbWFFQ0pYaFNIcEdJU3Yxd095MmR0SWlKVXR6MkZLd2k3RURY?=
 =?utf-8?Q?Ui2V48PdbvT3DzZC1fT7tnCDM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96af6d54-ce2e-4d6f-ae5d-08da8a965673
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4614.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 14:45:53.0245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ov4yyx9PpNAMMXnC4QSwJ6O1ZSQ4objFWu4pmbkUpQub+ZVmLE3f1dAmEIyF+ylM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0025
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 8/30/2022 7:18 PM, Alex Deucher wrote:
> On Tue, Aug 30, 2022 at 12:05 AM Lazar, Lijo <lijo.lazar@amd.com> wrote:
>>
>>
>>
>> On 8/29/2022 10:20 PM, Alex Deucher wrote:
>>> On Mon, Aug 29, 2022 at 4:18 AM Lijo Lazar <lijo.lazar@amd.com> wrote:
>>>>
>>>> HDP flush is used early in the init sequence as part of memory controller
>>>> block initialization. Hence remapping of HDP registers needed for flush
>>>> needs to happen earlier.
>>>>
>>>> This also fixes the Unsupported Request error reported through AER during
>>>> driver load. The error happens as a write happens to the remap offset
>>>> before real remapping is done.
>>>>
>>>> Link: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugzilla.kernel.org%2Fshow_bug.cgi%3Fid%3D216373&amp;data=05%7C01%7Clijo.lazar%40amd.com%7C66066549213c45b1341508da8a8e4f1b%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637974641082680316%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=ti%2FktO6Gmrio3TLDoteeJil28PY3D%2BLAinB6TU2mI9s%3D&amp;reserved=0
>>>>
>>>> The error was unnoticed before and got visible because of the commit
>>>> referenced below. This doesn't fix anything in the commit below, rather
>>>> fixes the issue in amdgpu exposed by the commit. The reference is only
>>>> to associate this commit with below one so that both go together.
>>>>
>>>> Fixes: 8795e182b02d ("PCI/portdrv: Don't disable AER reporting in get_port_device_capability()")
>>>>
>>>> Reported-by: Tom Seewald <tseewald@gmail.com>
>>>> Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
>>>> Cc: stable@vger.kernel.org
>>>
>>> How about something like the attached patch rather than these two
>>> patches?  It's a bit bigger but seems cleaner and more defensive in my
>>> opinion.
>>>
>>
>> Whenever device goes to suspend/reset and then comes back, remap offset
>> has to be set back to 0 to make sure it doesn't use the wrong offset
>> when the register assumes default values again.
>>
>> To avoid the if-check in hdp_flush (which is more frequent), another way
>> is to initialize the remap offset to default offset during early init
>> and hw fini/suspend sequences. It won't be obvious (even with this
>> patch) as to when remap offset vs default offset is used though.
> 
> On resume, the common IP is resumed first so it will always be set.
> The only case that is a problem is init because we init GMC out of
> order.  We could init common before GMC in amdgpu_device_ip_init().  I
> think that should be fine, but I wasn't sure if there might be some
> fallout from that on certain cards.
> 

There are other places where an IP order is forced like in 
amdgpu_device_ip_reinit_early_sriov(). This also may not affect this 
case as remapping is not done for VF.

Agree that a better way is to have the common IP to be inited first.

Thanks,
Lijo

> Alex
> 
>>
>> Thanks,
>> Lijo
>>
>>> Alex
>>>
>>>> ---
>>>> v2:
>>>>           Take care of IP resume cases (Alex Deucher)
>>>>           Add NULL check to nbio.funcs to cover older (GFXv8) ASICs (Felix Kuehling)
>>>>           Add more details in commit message and associate with AER patch (Bjorn
>>>> Helgaas)
>>>>
>>>>    drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 24 ++++++++++++++++++++++
>>>>    drivers/gpu/drm/amd/amdgpu/nv.c            |  6 ------
>>>>    drivers/gpu/drm/amd/amdgpu/soc15.c         |  6 ------
>>>>    drivers/gpu/drm/amd/amdgpu/soc21.c         |  6 ------
>>>>    4 files changed, 24 insertions(+), 18 deletions(-)
>>>>
>>>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
>>>> index ce7d117efdb5..e420118769a5 100644
>>>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
>>>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
>>>> @@ -2334,6 +2334,26 @@ static int amdgpu_device_init_schedulers(struct amdgpu_device *adev)
>>>>           return 0;
>>>>    }
>>>>
>>>> +/**
>>>> + * amdgpu_device_prepare_ip - prepare IPs for hardware initialization
>>>> + *
>>>> + * @adev: amdgpu_device pointer
>>>> + *
>>>> + * Any common hardware initialization sequence that needs to be done before
>>>> + * hw init of individual IPs is performed here. This is different from the
>>>> + * 'common block' which initializes a set of IPs.
>>>> + */
>>>> +static void amdgpu_device_prepare_ip(struct amdgpu_device *adev)
>>>> +{
>>>> +       /* Remap HDP registers to a hole in mmio space, for the purpose
>>>> +        * of exposing those registers to process space. This needs to be
>>>> +        * done before hw init of ip blocks to take care of HDP flush
>>>> +        * operations through registers during hw_init.
>>>> +        */
>>>> +       if (adev->nbio.funcs && adev->nbio.funcs->remap_hdp_registers &&
>>>> +           !amdgpu_sriov_vf(adev))
>>>> +               adev->nbio.funcs->remap_hdp_registers(adev);
>>>> +}
>>>>
>>>>    /**
>>>>     * amdgpu_device_ip_init - run init for hardware IPs
>>>> @@ -2376,6 +2396,8 @@ static int amdgpu_device_ip_init(struct amdgpu_device *adev)
>>>>                                   DRM_ERROR("amdgpu_vram_scratch_init failed %d\n", r);
>>>>                                   goto init_failed;
>>>>                           }
>>>> +
>>>> +                       amdgpu_device_prepare_ip(adev);
>>>>                           r = adev->ip_blocks[i].version->funcs->hw_init((void *)adev);
>>>>                           if (r) {
>>>>                                   DRM_ERROR("hw_init %d failed %d\n", i, r);
>>>> @@ -3058,6 +3080,7 @@ static int amdgpu_device_ip_reinit_early_sriov(struct amdgpu_device *adev)
>>>>                   AMD_IP_BLOCK_TYPE_IH,
>>>>           };
>>>>
>>>> +       amdgpu_device_prepare_ip(adev);
>>>>           for (i = 0; i < adev->num_ip_blocks; i++) {
>>>>                   int j;
>>>>                   struct amdgpu_ip_block *block;
>>>> @@ -3139,6 +3162,7 @@ static int amdgpu_device_ip_resume_phase1(struct amdgpu_device *adev)
>>>>    {
>>>>           int i, r;
>>>>
>>>> +       amdgpu_device_prepare_ip(adev);
>>>>           for (i = 0; i < adev->num_ip_blocks; i++) {
>>>>                   if (!adev->ip_blocks[i].status.valid || adev->ip_blocks[i].status.hw)
>>>>                           continue;
>>>> diff --git a/drivers/gpu/drm/amd/amdgpu/nv.c b/drivers/gpu/drm/amd/amdgpu/nv.c
>>>> index b3fba8dea63c..3ac7fef74277 100644
>>>> --- a/drivers/gpu/drm/amd/amdgpu/nv.c
>>>> +++ b/drivers/gpu/drm/amd/amdgpu/nv.c
>>>> @@ -1032,12 +1032,6 @@ static int nv_common_hw_init(void *handle)
>>>>           nv_program_aspm(adev);
>>>>           /* setup nbio registers */
>>>>           adev->nbio.funcs->init_registers(adev);
>>>> -       /* remap HDP registers to a hole in mmio space,
>>>> -        * for the purpose of expose those registers
>>>> -        * to process space
>>>> -        */
>>>> -       if (adev->nbio.funcs->remap_hdp_registers && !amdgpu_sriov_vf(adev))
>>>> -               adev->nbio.funcs->remap_hdp_registers(adev);
>>>>           /* enable the doorbell aperture */
>>>>           nv_enable_doorbell_aperture(adev, true);
>>>>
>>>> diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
>>>> index fde6154f2009..a0481e37d7cf 100644
>>>> --- a/drivers/gpu/drm/amd/amdgpu/soc15.c
>>>> +++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
>>>> @@ -1240,12 +1240,6 @@ static int soc15_common_hw_init(void *handle)
>>>>           soc15_program_aspm(adev);
>>>>           /* setup nbio registers */
>>>>           adev->nbio.funcs->init_registers(adev);
>>>> -       /* remap HDP registers to a hole in mmio space,
>>>> -        * for the purpose of expose those registers
>>>> -        * to process space
>>>> -        */
>>>> -       if (adev->nbio.funcs->remap_hdp_registers && !amdgpu_sriov_vf(adev))
>>>> -               adev->nbio.funcs->remap_hdp_registers(adev);
>>>>
>>>>           /* enable the doorbell aperture */
>>>>           soc15_enable_doorbell_aperture(adev, true);
>>>> diff --git a/drivers/gpu/drm/amd/amdgpu/soc21.c b/drivers/gpu/drm/amd/amdgpu/soc21.c
>>>> index 55284b24f113..16b447055102 100644
>>>> --- a/drivers/gpu/drm/amd/amdgpu/soc21.c
>>>> +++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
>>>> @@ -660,12 +660,6 @@ static int soc21_common_hw_init(void *handle)
>>>>           soc21_program_aspm(adev);
>>>>           /* setup nbio registers */
>>>>           adev->nbio.funcs->init_registers(adev);
>>>> -       /* remap HDP registers to a hole in mmio space,
>>>> -        * for the purpose of expose those registers
>>>> -        * to process space
>>>> -        */
>>>> -       if (adev->nbio.funcs->remap_hdp_registers)
>>>> -               adev->nbio.funcs->remap_hdp_registers(adev);
>>>>           /* enable the doorbell aperture */
>>>>           soc21_enable_doorbell_aperture(adev, true);
>>>>
>>>> --
>>>> 2.25.1
>>>>
