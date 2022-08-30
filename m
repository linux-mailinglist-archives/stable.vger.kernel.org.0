Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D44455A5A87
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 06:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbiH3EFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 00:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiH3EFU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 00:05:20 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBD621800
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 21:05:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQdRTLoeWWN1MsFfxwYMypyqQ27ewJep/vZw8ggHh3ehyq6k2EvjjBrttgO5maaQ4piwiFZOgRGL1446FcY4wcwY7W7CYC+jmlRcEH6NrHV2Ioqrkcz976wTrLnwEcNC2b7B1bi+qc/djz/iXUJwDKQjwwa5Ieb//PSrzttMV0L2xOlYXbKqG6rMAoF1XKivJYAS0MEiKbLA/LSyHgrSim8layE6RQ69Vi4QgXIXG3PFUlWNSH57CfySDUQq+QhybAxVK2KlTCrA/B0xMon7y42aYm1xG8R/32CPQdyWb5r5HDPFcknqj4Pwy46HVdMLcwNOgmL+2wwzi4JDTX2WCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QYEVpdDU6fsSjyPoAalXdt/GEfyMFugfBhKwwzCgJ6Q=;
 b=Grj79o0lif+eFRZKngRCZPokXL05K//xo0k5r104VXxu7kFG7+0ggC6wPOsYfKngRMvfDff+p5NKEsDt+gmDFe3p89yH0Mvj4KTyO52shBWyNPhFVRLD0q49OYhbXQB5C2K0buwOfMHdb+PffwjE4GDj73fnYtLEDsPdka4zekQSNfImPcvqOkBD1I5pbH5p8qNrQWI02oIT8UWfjMWm/uRnSW2JHGz6Vx33Vpdqy/rVAqFV/SoOVmhoRBhg4eWiE5lNvPywg5h3vNQR/b3pUsHLYKZGNzyqvnNFySuik1Q9kV/M6L0ookh0dDtRv3bxPAlaQJkd8HJ+geH28FVp+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QYEVpdDU6fsSjyPoAalXdt/GEfyMFugfBhKwwzCgJ6Q=;
 b=n7y/mgDND1q36QKduvZBkHMPjn7lMtbg+/pmb7LdmRyc2HT5flHgjcrgmq/I8gqa+vCtUNolO2D813fR5aJ/6g/shtAXn07p9iR6MAa6pftnyABqJdGozkJNzpkwwshlrxN9+sttt4BQwhSB29278ySJqJkWAY/T8KcdpzNCnVg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BYAPR12MB4614.namprd12.prod.outlook.com (2603:10b6:a03:a6::22)
 by DM5PR12MB1577.namprd12.prod.outlook.com (2603:10b6:4:f::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.14; Tue, 30 Aug 2022 04:04:54 +0000
Received: from BYAPR12MB4614.namprd12.prod.outlook.com
 ([fe80::2925:100a:f0b9:9ad8]) by BYAPR12MB4614.namprd12.prod.outlook.com
 ([fe80::2925:100a:f0b9:9ad8%3]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 04:04:54 +0000
Message-ID: <3b2a9a8f-dedf-2781-0023-d6bd64f16d65@amd.com>
Date:   Tue, 30 Aug 2022 09:34:43 +0530
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
From:   "Lazar, Lijo" <lijo.lazar@amd.com>
In-Reply-To: <CADnq5_O=3u1Z4kH_5A+UsynQ31Grh-=j=3+hPWo398kfMi411w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0169.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:de::13) To BYAPR12MB4614.namprd12.prod.outlook.com
 (2603:10b6:a03:a6::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2f043da-775a-4e19-f810-08da8a3ccb51
X-MS-TrafficTypeDiagnostic: DM5PR12MB1577:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0NsDJiOLrWVzQ8bcHrDJZEwSTpdrr4GPiy6m908Ofdr5jHA/t1JOctOfpnoqbkfEeXKKBFmO1ZTlF8SvAFaPP2Kh01/POS2yCsfRk9GYtu7iz7TGL5Af7l6SPlhtYsvjacU+J/yUzQmOYzaW5EIedl5V+iTV3McalieE45guDR+6aZUBoMW0LrjfpkUKZ4n+TCCxGwFR5pI7jYnqaTrm9XjdnH4z6k0X+EXTRm34j6oD+sOG7ab0l5MwzjjGvXZoDkDyNvYVMRZIXA5u8qBSfOed7nCPDsNOkdiLhc3/4OxuXS/h4Sweg4IKtVQce/Fn5mxLhEHNJdu6Gi/W4gdqDh9vqmZkY4EEZnwfBDFEWeKM1Whp8Mzy8yu3uI5AfeNA0lm0LSft4xD5oi1z8XmjTwrDZyaI/Q+Gx08klcz63yLe0pBeBolzOJeMhE6vZJx+uZ52VJNnlqn0abWseZopqZN4OJpEUUrPE4q+8/fxxYb2tgkr8fl+VITom8zQEcQfyXVCTYqN9Q0TQKU1C1i5+IyNKoFbVPUK4B/slVdMfsFSj6P4eZTg44UBvPxNE9F3KKsx2d53MwwxM3jvqbwZC7jk3On5c+U2wmiBixMc6r2jdUUK7gDcYdqM4J+v3KuBUtuWS2kkU1Tt5KKfdJAYdSZ8q6tPar6pUad4qR+bl5Uc14ykTYJMgGL9Q4IiJ7Ovf2oFxog/i56O0SumrgBKtxv4NNkE5rVxphwCqv3X8jsvmpmKzC2FezbWxZkW2e1QoifE7NYqOQ6iPNr+36wTZHO1AgeX4L/MocTGOxm0V5ge2yGJwjCjkKo5jQGE2EgT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4614.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(31686004)(316002)(26005)(6916009)(966005)(66476007)(8676002)(86362001)(45080400002)(66556008)(6486002)(4326008)(66946007)(31696002)(5660300002)(478600001)(36756003)(41300700001)(8936002)(6666004)(2616005)(38100700002)(6506007)(53546011)(2906002)(83380400001)(186003)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cmFsRGJubWF5dEl2dkFlOW81bHRDNGF1bllQY2NNVFBXMXA2ZXRNZVdCVU9m?=
 =?utf-8?B?Ym1TSDduKzVzS3JKbVVuaXI5YnVveXlGWVlaYTlndHYwd1dvSEg1OFBrTFVx?=
 =?utf-8?B?R0NrVlFhOGpUcEpDTHRBdFltTGtxN2xtNkxLYW1NMmJYL05ERGlncm9reE84?=
 =?utf-8?B?VUJXN1BJS0tTQm44UHBEd2RIVmZjU00xM2RQeCtpekR3TldTYWVSUGhUOERv?=
 =?utf-8?B?dEViMkI2SXZVdkNLLzJCdHY1bWFINnlrVXhWZFpldTFwMU1aazc3Y2RNODRw?=
 =?utf-8?B?UU1ZWlI3cGhTYXVZK0x0S1hQcUw1amw2eEpkTm43azAzVFVCVFdENUNFbTlU?=
 =?utf-8?B?VzlJMnExbTdhZ1YyaEtuNW1xa3RReFpvcU40dEJPcW5LSllZS2hXcDZ2T3M3?=
 =?utf-8?B?dEZHNXZsbGdGS1NhdE1wUmNFWTFldktZOWY2cGp3bjlHWERNNG5OR1c3cksy?=
 =?utf-8?B?L2xXbzBqU3RYVkg3WmV4Q01BR0VLSFhqdHNBM0dyQTdYakV1WkxFTVNwSHVE?=
 =?utf-8?B?TitQWlBDMG9KM3lRelgyRW1hWk11K1FxR3oxTU9TT2Q1TlJxaXJUYmRoODdH?=
 =?utf-8?B?WXpFQnkzSWJKc2FlMjhoeS91UzJ4aFQwdWlxMkU4OE1KV2ZaaTFVWk9LYStM?=
 =?utf-8?B?dFpLck5YMEIweDNpOTVkZEpOM3ZDVkQ2Q0JvMjhXQUx3blNUeXpyUXYwaDRD?=
 =?utf-8?B?ZmN5Sk9pYVIrY1FYQzZKRHMvdWxJUUVucVdBVlBhaTBTL3JqaTRQSG9IQjla?=
 =?utf-8?B?WkJkOGswanRoOHBKbDlhT0tKeWFISVRLemhidDhkd1duVHZOWm1NSHFvTitO?=
 =?utf-8?B?Y1czZjNvd1JOQ1ZQR2dRRi94VHk3d1RCYVNDb2E5OHJqdXRLRWlaY2hOeWl4?=
 =?utf-8?B?V3FCU1l4bmswUUg1Z0h6TzA1UHJPNkR2aHZpSDVmakRkbS9ZZ3VZRk5YUU0v?=
 =?utf-8?B?YlJUTDdjZzFYOHFsbnd6d002aUFmMENzWU1SRitWWngxQXJkUGhVMEExY2hj?=
 =?utf-8?B?UXQyRjZ3VnlRaWtwKzNLRGpqaDZaeGNVWGhrNFhBTnFBWVFZelFtaHdsU3NV?=
 =?utf-8?B?VHFiZ0tjS0NxeEpxZ3lWOGM3OHRZMFh2eUp5a09tNm1qUkxMSUo4ZkswbWl1?=
 =?utf-8?B?NlF6SFpLRCtkVC9qZTlWeStyQ2FJZ0NzRDN1akJjMnB1dnhGcFEwNVNxbk5W?=
 =?utf-8?B?ZGNENFREUmpvZTI0VkFvZ0NNRHNoSnVVOXZTRW9OdXVVSUpwakNTYkR2WWt2?=
 =?utf-8?B?THE2L1l2KzIwanZIVlkyT0FibmREWVlYNUdtNG5ZRmtkejhPVzBIVmpsNzJQ?=
 =?utf-8?B?bU4xMFljZllhQlczOUE5YStlUWRiUGh2UFh1L1ltS3F6RmpUa2xTclpCK09y?=
 =?utf-8?B?WllNeDdYbzhUeGo1ZkV0b1ZoUUtWam1qc1Q5b2V1SzdJdjhvZ2wrMk1ZTXdl?=
 =?utf-8?B?dW9jbk15UWFueDdSdkJmR0Y2N1FZem1hYWppUTFGb2tuUG4zQzRyUUhLbE41?=
 =?utf-8?B?QlhoYU1sdzlmRCtHcEs5ZzZxL1dOK0tqbWdNOU5XaTJKVUxjUm9RbUNoZHpp?=
 =?utf-8?B?b2lNMnJLRXl4bXBJN0pMd0lFb05PM1ROSW51VWZtUmNJUm56Z25LeVQydzZa?=
 =?utf-8?B?NkZCZ2o3MVMvZVJoZ1ZZQ24yNXpUVTJLbUpkd1V0djdvQUlEVUlNSWc4MS8y?=
 =?utf-8?B?dnhTamlYY0tJL1grRGY2TFlCWGFWM3Vzb3dwZnE4aW5pM2RVajZhVko1cFdP?=
 =?utf-8?B?RlJkN1I1MHlRVDU3MVJNeno0eW9uZ1JOTm9UMmhpbzN3dmtYenE0Wjgwb0dD?=
 =?utf-8?B?ZmZZcjQ2UlhUUVpEb29nN2NQNUZGelZnM1ZFV3gvQm1meUpaZ3JteUlGazdy?=
 =?utf-8?B?N04ya1AxUmVZZHpsUUxjUHYrajhOSmh2Z3p4aFVGZ2MzakdVSjdRVEhMT2Zm?=
 =?utf-8?B?R3EzNHAvN2NNclFrV3VLRzRXSHFsWUEvTnJIVzZVVXVySFpnVVZVT1EvNUhK?=
 =?utf-8?B?TU16TGc0Q0FnL1FaRlF6NG5USTNyZHVwa01ia0g1aW55ck8yeG12YkJnOERD?=
 =?utf-8?B?eC9qaVVVb0VuM1lacFRuUGlBbFlEYnBpdGVoWUE5Uk5hckxueVZRb1pBeTRj?=
 =?utf-8?Q?2CKmHieKl9JzFf8h6Ca5Jfd+3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2f043da-775a-4e19-f810-08da8a3ccb51
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4614.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 04:04:54.3913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c5+CuZ4Rpb6Y8F1nYvlsYOiCHk+ix1AlLz08SWhHyfmNpd5xMFd288WeO++X/xZL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1577
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 8/29/2022 10:20 PM, Alex Deucher wrote:
> On Mon, Aug 29, 2022 at 4:18 AM Lijo Lazar <lijo.lazar@amd.com> wrote:
>>
>> HDP flush is used early in the init sequence as part of memory controller
>> block initialization. Hence remapping of HDP registers needed for flush
>> needs to happen earlier.
>>
>> This also fixes the Unsupported Request error reported through AER during
>> driver load. The error happens as a write happens to the remap offset
>> before real remapping is done.
>>
>> Link: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugzilla.kernel.org%2Fshow_bug.cgi%3Fid%3D216373&amp;data=05%7C01%7Clijo.lazar%40amd.com%7C0882d00080124386814a08da89de9bcd%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637973886457404198%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=dC%2BCY22cfix1VCcQINrvNWI5XW%2BYV5lleJX3Ju9A6Iw%3D&amp;reserved=0
>>
>> The error was unnoticed before and got visible because of the commit
>> referenced below. This doesn't fix anything in the commit below, rather
>> fixes the issue in amdgpu exposed by the commit. The reference is only
>> to associate this commit with below one so that both go together.
>>
>> Fixes: 8795e182b02d ("PCI/portdrv: Don't disable AER reporting in get_port_device_capability()")
>>
>> Reported-by: Tom Seewald <tseewald@gmail.com>
>> Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
>> Cc: stable@vger.kernel.org
> 
> How about something like the attached patch rather than these two
> patches?  It's a bit bigger but seems cleaner and more defensive in my
> opinion.
> 

Whenever device goes to suspend/reset and then comes back, remap offset 
has to be set back to 0 to make sure it doesn't use the wrong offset 
when the register assumes default values again.

To avoid the if-check in hdp_flush (which is more frequent), another way 
is to initialize the remap offset to default offset during early init 
and hw fini/suspend sequences. It won't be obvious (even with this 
patch) as to when remap offset vs default offset is used though.

Thanks,
Lijo

> Alex
> 
>> ---
>> v2:
>>          Take care of IP resume cases (Alex Deucher)
>>          Add NULL check to nbio.funcs to cover older (GFXv8) ASICs (Felix Kuehling)
>>          Add more details in commit message and associate with AER patch (Bjorn
>> Helgaas)
>>
>>   drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 24 ++++++++++++++++++++++
>>   drivers/gpu/drm/amd/amdgpu/nv.c            |  6 ------
>>   drivers/gpu/drm/amd/amdgpu/soc15.c         |  6 ------
>>   drivers/gpu/drm/amd/amdgpu/soc21.c         |  6 ------
>>   4 files changed, 24 insertions(+), 18 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
>> index ce7d117efdb5..e420118769a5 100644
>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
>> @@ -2334,6 +2334,26 @@ static int amdgpu_device_init_schedulers(struct amdgpu_device *adev)
>>          return 0;
>>   }
>>
>> +/**
>> + * amdgpu_device_prepare_ip - prepare IPs for hardware initialization
>> + *
>> + * @adev: amdgpu_device pointer
>> + *
>> + * Any common hardware initialization sequence that needs to be done before
>> + * hw init of individual IPs is performed here. This is different from the
>> + * 'common block' which initializes a set of IPs.
>> + */
>> +static void amdgpu_device_prepare_ip(struct amdgpu_device *adev)
>> +{
>> +       /* Remap HDP registers to a hole in mmio space, for the purpose
>> +        * of exposing those registers to process space. This needs to be
>> +        * done before hw init of ip blocks to take care of HDP flush
>> +        * operations through registers during hw_init.
>> +        */
>> +       if (adev->nbio.funcs && adev->nbio.funcs->remap_hdp_registers &&
>> +           !amdgpu_sriov_vf(adev))
>> +               adev->nbio.funcs->remap_hdp_registers(adev);
>> +}
>>
>>   /**
>>    * amdgpu_device_ip_init - run init for hardware IPs
>> @@ -2376,6 +2396,8 @@ static int amdgpu_device_ip_init(struct amdgpu_device *adev)
>>                                  DRM_ERROR("amdgpu_vram_scratch_init failed %d\n", r);
>>                                  goto init_failed;
>>                          }
>> +
>> +                       amdgpu_device_prepare_ip(adev);
>>                          r = adev->ip_blocks[i].version->funcs->hw_init((void *)adev);
>>                          if (r) {
>>                                  DRM_ERROR("hw_init %d failed %d\n", i, r);
>> @@ -3058,6 +3080,7 @@ static int amdgpu_device_ip_reinit_early_sriov(struct amdgpu_device *adev)
>>                  AMD_IP_BLOCK_TYPE_IH,
>>          };
>>
>> +       amdgpu_device_prepare_ip(adev);
>>          for (i = 0; i < adev->num_ip_blocks; i++) {
>>                  int j;
>>                  struct amdgpu_ip_block *block;
>> @@ -3139,6 +3162,7 @@ static int amdgpu_device_ip_resume_phase1(struct amdgpu_device *adev)
>>   {
>>          int i, r;
>>
>> +       amdgpu_device_prepare_ip(adev);
>>          for (i = 0; i < adev->num_ip_blocks; i++) {
>>                  if (!adev->ip_blocks[i].status.valid || adev->ip_blocks[i].status.hw)
>>                          continue;
>> diff --git a/drivers/gpu/drm/amd/amdgpu/nv.c b/drivers/gpu/drm/amd/amdgpu/nv.c
>> index b3fba8dea63c..3ac7fef74277 100644
>> --- a/drivers/gpu/drm/amd/amdgpu/nv.c
>> +++ b/drivers/gpu/drm/amd/amdgpu/nv.c
>> @@ -1032,12 +1032,6 @@ static int nv_common_hw_init(void *handle)
>>          nv_program_aspm(adev);
>>          /* setup nbio registers */
>>          adev->nbio.funcs->init_registers(adev);
>> -       /* remap HDP registers to a hole in mmio space,
>> -        * for the purpose of expose those registers
>> -        * to process space
>> -        */
>> -       if (adev->nbio.funcs->remap_hdp_registers && !amdgpu_sriov_vf(adev))
>> -               adev->nbio.funcs->remap_hdp_registers(adev);
>>          /* enable the doorbell aperture */
>>          nv_enable_doorbell_aperture(adev, true);
>>
>> diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
>> index fde6154f2009..a0481e37d7cf 100644
>> --- a/drivers/gpu/drm/amd/amdgpu/soc15.c
>> +++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
>> @@ -1240,12 +1240,6 @@ static int soc15_common_hw_init(void *handle)
>>          soc15_program_aspm(adev);
>>          /* setup nbio registers */
>>          adev->nbio.funcs->init_registers(adev);
>> -       /* remap HDP registers to a hole in mmio space,
>> -        * for the purpose of expose those registers
>> -        * to process space
>> -        */
>> -       if (adev->nbio.funcs->remap_hdp_registers && !amdgpu_sriov_vf(adev))
>> -               adev->nbio.funcs->remap_hdp_registers(adev);
>>
>>          /* enable the doorbell aperture */
>>          soc15_enable_doorbell_aperture(adev, true);
>> diff --git a/drivers/gpu/drm/amd/amdgpu/soc21.c b/drivers/gpu/drm/amd/amdgpu/soc21.c
>> index 55284b24f113..16b447055102 100644
>> --- a/drivers/gpu/drm/amd/amdgpu/soc21.c
>> +++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
>> @@ -660,12 +660,6 @@ static int soc21_common_hw_init(void *handle)
>>          soc21_program_aspm(adev);
>>          /* setup nbio registers */
>>          adev->nbio.funcs->init_registers(adev);
>> -       /* remap HDP registers to a hole in mmio space,
>> -        * for the purpose of expose those registers
>> -        * to process space
>> -        */
>> -       if (adev->nbio.funcs->remap_hdp_registers)
>> -               adev->nbio.funcs->remap_hdp_registers(adev);
>>          /* enable the doorbell aperture */
>>          soc21_enable_doorbell_aperture(adev, true);
>>
>> --
>> 2.25.1
>>
