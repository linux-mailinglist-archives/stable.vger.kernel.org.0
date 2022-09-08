Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5972E5B12FD
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 05:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiIHDk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 23:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiIHDk2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 23:40:28 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2042.outbound.protection.outlook.com [40.107.96.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4954F75CF9
        for <stable@vger.kernel.org>; Wed,  7 Sep 2022 20:40:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=flIITja9iCUI6L1UdWhjQHEa5oYQxBBllkdtQlQwBFDg6LbkLp7WCrbScTY49Rmemkkuw6656bvIj3Rdx0CR9bwVv4W0JbnUdpVGvAjh4ADtsCUhhs0yxqOgB/RhM4pDzydJ/0ME2olzjeVl9ruuCxNPIHzi//iI2Ni8Fve4YciYyIsnxdH4lz9u/O19vVVeJiROtpp4mC+FJYCOSMEAnPvVt79Lez/N/YM6eNQ/5JBC5X281Dx5zIRrNemAi5mrj640o623SKzQZE22uApqq+jxEO18d7VCCUgO1xbnBjFQNG+3PAHsrlfu4JaPnTaVr3AjYQA0KYEvrCf9Oh114Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f0J5DrK1IxLsz+xsB0JQQsCVsGX8P957IK2n7FXD+fM=;
 b=kMhpJ/TGUc3dkME/sjpDnHvRwR+/e7EX5PV6yXr9VAqPlDslL4quo4KuOtqM+9Xn4znHf6fMbNzY+C6FLoss/jTmlbILL8n1lGCFbeq7rWnevhWIJ41fkFWVOpqoTMUT08UBO0Ctj+Vz6Ph/HE1sHqvIgdnK2a2zE/zjHlvCZB7BWBfSpt7Hyc3ztrvM98deruSBAoWoSIHawHAYCiGrO995uUOv7ft6kHygibZjdQa9bOgf7pvoSKEalbJT30RU4BKQgX+kqenLm9+/EDs1lFbWdxsQQFrB/Ivru7zOUFc0OYY3A9iKbPYxXYsPgYfQdbuTmsg+3J0cbi5LZx8baw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f0J5DrK1IxLsz+xsB0JQQsCVsGX8P957IK2n7FXD+fM=;
 b=wn7U1TPSv0BVpi2z8Kxr9yuDOz2cKJJ7Zuuby0cJ9t360aj8laHnr4ZGft6inNBqYjqk+10z3OKCVMrsD+mvMO3u3bILFwcOijWJYX4MgD3/DOq42hScaIWcYwxSVfqf81iAiC7ydojNP04N7b06OKmRy1WBpEDbBVKAH69trYw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BYAPR12MB4614.namprd12.prod.outlook.com (2603:10b6:a03:a6::22)
 by BL3PR12MB6596.namprd12.prod.outlook.com (2603:10b6:208:38f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Thu, 8 Sep
 2022 03:40:23 +0000
Received: from BYAPR12MB4614.namprd12.prod.outlook.com
 ([fe80::2925:100a:f0b9:9ad8]) by BYAPR12MB4614.namprd12.prod.outlook.com
 ([fe80::2925:100a:f0b9:9ad8%3]) with mapi id 15.20.5612.014; Thu, 8 Sep 2022
 03:40:23 +0000
Message-ID: <b3b786b1-2f72-4f5e-f011-8acf06867d0e@amd.com>
Date:   Thu, 8 Sep 2022 09:10:12 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH] drm/amdgpu: Don't enable LTR if not supported
Content-Language: en-US
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     amd-gfx@lists.freedesktop.org, Alexander.Deucher@amd.com,
        wielkiegie@gmail.com, helgaas@kernel.org, stable@vger.kernel.org,
        Hawking.Zhang@amd.com
References: <20220908032344.1682187-1-lijo.lazar@amd.com>
 <CADnq5_MQ64piXz-CJeEn2e4yi_kwePYCea_sTxdFUAb+j8wu5Q@mail.gmail.com>
From:   "Lazar, Lijo" <lijo.lazar@amd.com>
In-Reply-To: <CADnq5_MQ64piXz-CJeEn2e4yi_kwePYCea_sTxdFUAb+j8wu5Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0033.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:22::8) To BYAPR12MB4614.namprd12.prod.outlook.com
 (2603:10b6:a03:a6::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB4614:EE_|BL3PR12MB6596:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c9fa33c-3a33-4769-610d-08da914bdc6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sPgA7f0YoZMdYgknG3dSbEpphUdF9Y3D3VUkp89jlZF0P0aeC3VUCZPIdGop+0DSsjv+Io60kFZb4K7Ek5Xt4arBTu/YGY+t8sD4xvcj+GpRvGp+iNzlVKTvbrNQgprrxiYmcCrKTM5QtkNIVj2UOJpUzelaPsJTOXuS8MUmmmxeDXcrph9bkMN2NJ8TpDRaVYuUGXCLUVpEwjva1Fd+ARfvcc8uHrXC4MJnSu/M4jFuvNPSNYnIVz+ZhC9SWk0KB5MqeTug+wKfmAER4HAym1Mm0oakbAHItL+rEcnmOe33+4gIXQf0x7sh6X24UfevwNQ6Wkz74i7tV+zivKyQslzE5YHE0eqbaJr3pFxk2UD+VBy2OG0XpSoJizuFvF7h4ZqNAtuAJSFEN16cx+Vv3Tky1/hTzP44lZzAldjvPaKUp+64F/94KiHg0z44Qlv233ob3B0V0dkNrx1crSUjKi/6zkEihHh5TnLqjZELynKweIhgvHqu/MpRZ4Wgsq6QzpZL1HXcFRnw9QbVNuypaUZTOpllaMAIqaWQeg8f9NnBFq8f7fO6ychpRAOjmqq4wvHjV8JJa5bu7Al8C6YGQa2GbTxVYXvPDot4+vPRpCHhaOMwvWjgvOw/9JBixlojNxEyeyOTeXu7Juver+XwwoWYjiloGWOZBMGwt1cuU9LQqIvuJ75kCaDgSXQvJeZoiubRhFBRCdvzVHVxyxjmUfd+lKEg6CU2IKhkXY66bCST1MRGZt4u/t/RT/GkjpE1x8qDks21PnjL5YGNc/aEXL9gspSRaDQJ2D7f1O+U4pnR5pF2s22ewQzPrHMKvftBu+NyaAaI2fvjY5Tj+iGg4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4614.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(396003)(376002)(346002)(136003)(8676002)(83380400001)(86362001)(6916009)(66946007)(8936002)(5660300002)(66556008)(53546011)(26005)(966005)(6506007)(478600001)(6486002)(41300700001)(186003)(2616005)(4326008)(45080400002)(6666004)(66476007)(316002)(31696002)(31686004)(6512007)(36756003)(2906002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V1JjZUVvVG1IY2V6K3o2ZlZBd2RaVmczaEZoNFl3eWpERXFVR2c2bmFuWWEz?=
 =?utf-8?B?UjlJeGVkRWplNmE4NlIxb0FTSDN1SkZkMnU4QXR6WXdjaHcwN0hEVm1LckVo?=
 =?utf-8?B?a3EvekNNWno5L1pKVC9OdEQyVzlSeXl6aTZIMEpmVnU3UWJMK3dxeTF1eXln?=
 =?utf-8?B?bFY3R2ZFbFZwMEMzRnE1aTRBaHdyQWI0Qzk1YUtHRVVCVVVoZEpLRyt0b0JN?=
 =?utf-8?B?QmVVQjN2dExGdFg1S08razdrNEIxaFJNYnkwbXJDMmlDL1VlRXVIR1RIQ3pM?=
 =?utf-8?B?TTVJbmpBZ21iNytPTFp4NUFGRjByaDd0a2loM1JZaXJ2bzRpU1M4dDl0VG1m?=
 =?utf-8?B?OVM3N2NVeG52RjUrYk5UNkdWcStnMHo3eHhPNkZvS0IrdElWZzBGZHNuMjNC?=
 =?utf-8?B?cWRibGFQeVgvb3NyQVlqOVlhODQ5MG9UUHBQQ1Z4eWgvek4yVkVDNm1aZE9J?=
 =?utf-8?B?ek91V2dTWFJnM21xb1E3a2ZDTmpQT1VQVitPTXE3c0laQTM1Z1pBdzUxMWpL?=
 =?utf-8?B?Zjd4UHRFVlc3L0svUDQrLzBiNVBJWWY3cVhPSm9DTzk1VHRFNHZvRjZ2anpo?=
 =?utf-8?B?MVpJTWhLVk0vVEgremNBNlVwaHlIeHFPQjZwYU44TEhKY1VqQnVZeHJUcVBx?=
 =?utf-8?B?dC93amVtUS80RUxDUFAwdmJrb2ppRWNRa3UzRVZ1WDNmakUwdlpZWkUrbTJH?=
 =?utf-8?B?TUl0VVhXTmsrQVJtb0N5bERGMkM3bnRvRGx1RkpkSW9PMXJ4TS9NY3hVRXR1?=
 =?utf-8?B?L1dJcmw3WDBaOWtoR1Fnd1VYSElSYzNWQ1MwTDdZL29lVzlZam1ja2V0Z3lB?=
 =?utf-8?B?QkVBMDRsTHJyYTY0QlhvdTExTUQrYVhJWC9rcHQ2VzN6QklaRk13ZXdmbG4y?=
 =?utf-8?B?ZGc5NUt6OXV6NWxUNU8raXJadjdMMmRhWmQrTGZGZGFoM2hSN2k0ZnBqQTFZ?=
 =?utf-8?B?NThDMnhDYlREaWJnQzg2K2JhU2J0Z1E5cWZGNkQxUVU1dFlXdzhBeFhYa3R2?=
 =?utf-8?B?M3J6TlZZVUx4U1hKNTlicTdtTTZONytTVWc5QkdOZW4vcm1GY1JuajU1ajll?=
 =?utf-8?B?QVhtblRpQmxERmtoMlBTNGZWZ013NUYreFF3WVYwYTZvaGlQVytBTFFRUjNN?=
 =?utf-8?B?NEZVRlB6NjY5YlVHa3YwSHlKWmwyQjlaUDlvMURUN0ZUamJDUndIRHdmRDJ5?=
 =?utf-8?B?L0Z3U1VoTkxWZzVxeXlKbGFsUy9zOFJEOSttVnZyeUxHTkszclpvVSttR1Qz?=
 =?utf-8?B?YUlGcWV3ak5XbmRQdHRPb3I0OUVNbUJLblYyM0dkL0R5Q2lYTkwwa1NSNFNC?=
 =?utf-8?B?WUNDNi8rYnJESE9VcnN0WlhhRXJBZUZER29GVEp0dUZsbUNhczl3QmRBOHNO?=
 =?utf-8?B?bTBlQkx5VU92V3hLeGxEZjU2MWl5eHZPL2czWXNvZTcyRnROcTZIY1hNVit3?=
 =?utf-8?B?OFEwaFVpQTI4ZmRlVGpZVDJTVkhtT0pUdkZpYTFPWXEwaWg5VXcya2NWMktK?=
 =?utf-8?B?dHBuZE5tNVllV2UrTzh1TzYyVjQ2dTVYWE1TdDdER0R2aTlDNGRnR1B0b1FK?=
 =?utf-8?B?dDlyV0hDaW4wK1RLVlhyWWV6UW9XTllrYXN2c0pDaXpDNUFJbVVlNllRL01o?=
 =?utf-8?B?L202OGI5aHg1RnNuVUI2UWR4K1VFOFoyVy9na3NhZnd2TVl5NHM4YzQzOCtQ?=
 =?utf-8?B?Qkkxay9STXhMY1lKeXhXZmtiK1ZYejkyOEpQdnJkYXBMNG5zVERTK21wUHRQ?=
 =?utf-8?B?R3owSnZKTmhrNVpBckxhUytWTTRMSnRUNkhORkRmeWhrZkZvOUlRSldnMGhV?=
 =?utf-8?B?SHB1K2gyV3N6RmVLVlM4NG5yUmkzNlpwcXY2UENKSm1NcklBYmZHVzRZYUp2?=
 =?utf-8?B?UEZHejdqbW5xMmtlQmwzOU1WRFRZVUg4Z1JyK0NOZ01wL2FsUkJTWDhMVkFy?=
 =?utf-8?B?c0ZmdU0wRmZYWTJIdGtHZXY1aDJvWE1GcFlldnEzYUNxL1JjdDZ0YUt3N09G?=
 =?utf-8?B?Q2pzUEU2Y2lFa1ZhNFJNaWgrbHVwZEV6ekJ4K2ZGL3hRLzV3d2FiU2dsVGZL?=
 =?utf-8?B?WkozWUlUMjJYcTgvRXBYaEwvR3FXTmVGamhVcmFFNkY2cC9EaFNnSGM4SzRn?=
 =?utf-8?Q?ydUDDEfUY0HpvsTs2/2n4+tu3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c9fa33c-3a33-4769-610d-08da914bdc6e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4614.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 03:40:23.7048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +WTzRdIhQvdOXQ9oHcTKwFSx+RkX8ta4SgciC1rDAck9WKllaAcnu5lWEuLJcG4t
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6596
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/8/2022 8:58 AM, Alex Deucher wrote:
> On Wed, Sep 7, 2022 at 11:24 PM Lijo Lazar <lijo.lazar@amd.com> wrote:
>>
>> As per PCIE Base Spec r4.0 Section 6.18
>> 'Software must not enable LTR in an Endpoint unless the Root Complex
>> and all intermediate Switches indicate support for LTR.'
>>
>> This fixes the Unsupported Request error reported through AER during
>> ASPM enablement.
>>
>> Link: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugzilla.kernel.org%2Fshow_bug.cgi%3Fid%3D216455&amp;data=05%7C01%7Clijo.lazar%40amd.com%7Cc190635e13f047625b4508da914a47a5%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637982045476774989%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=mNq7A7oT2VwZVc7WtYyWj0BRAXV5MzNLir0o4%2BKiWYU%3D&amp;reserved=0
>>
>> The error was unnoticed before and got visible because of the commit
>> referenced below. This doesn't fix anything in the commit below, rather
>> fixes the issue in amdgpu exposed by the commit. The reference is only
>> to associate this commit with below one so that both go together.
>>
>> Fixes: 8795e182b02d ("PCI/portdrv: Don't disable AER reporting in get_port_device_capability()")
>>
>> Reported-by: Gustaw Smolarczyk <wielkiegie@gmail.com>
>> Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
>> Cc: stable@vger.kernel.org
>> ---
> 
> Even though the ASPM code in si.c, cik.c, and vi.c doesn't mess with
> LTR, it still sets up ASPM so shouldn't it be protected with
> CONFIG_PCIEASPM as well?
> 

Yes, but it is only a compilation improvement and unrelated to this 
patch. We don't access any ASPM related kernel variables in those 
sequences. ltr_path variable used under this patch is declared under 
ASPM config.

Runtime protection is already there -
0ab5d711ec74 (drm/amd: Refactor `amdgpu_aspm` to be evaluated per device)

Thanks,
Lijo

> Alex
> 
>>   drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c | 9 ++++++++-
>>   drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c | 9 ++++++++-
>>   drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c | 9 ++++++++-
>>   3 files changed, 24 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c b/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
>> index b465baa26762..aa761ff3a5fa 100644
>> --- a/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
>> +++ b/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
>> @@ -380,6 +380,7 @@ static void nbio_v2_3_enable_aspm(struct amdgpu_device *adev,
>>                  WREG32_PCIE(smnPCIE_LC_CNTL, data);
>>   }
>>
>> +#ifdef CONFIG_PCIEASPM
>>   static void nbio_v2_3_program_ltr(struct amdgpu_device *adev)
>>   {
>>          uint32_t def, data;
>> @@ -401,9 +402,11 @@ static void nbio_v2_3_program_ltr(struct amdgpu_device *adev)
>>          if (def != data)
>>                  WREG32_PCIE(smnBIF_CFG_DEV0_EPF0_DEVICE_CNTL2, data);
>>   }
>> +#endif
>>
>>   static void nbio_v2_3_program_aspm(struct amdgpu_device *adev)
>>   {
>> +#ifdef CONFIG_PCIEASPM
>>          uint32_t def, data;
>>
>>          def = data = RREG32_PCIE(smnPCIE_LC_CNTL);
>> @@ -459,7 +462,10 @@ static void nbio_v2_3_program_aspm(struct amdgpu_device *adev)
>>          if (def != data)
>>                  WREG32_PCIE(smnPCIE_LC_CNTL6, data);
>>
>> -       nbio_v2_3_program_ltr(adev);
>> +       /* Don't bother about LTR if LTR is not enabled
>> +        * in the path */
>> +       if (adev->pdev->ltr_path)
>> +               nbio_v2_3_program_ltr(adev);
>>
>>          def = data = RREG32_SOC15(NBIO, 0, mmRCC_BIF_STRAP3);
>>          data |= 0x5DE0 << RCC_BIF_STRAP3__STRAP_VLINK_ASPM_IDLE_TIMER__SHIFT;
>> @@ -483,6 +489,7 @@ static void nbio_v2_3_program_aspm(struct amdgpu_device *adev)
>>          data &= ~PCIE_LC_CNTL3__LC_DSC_DONT_ENTER_L23_AFTER_PME_ACK_MASK;
>>          if (def != data)
>>                  WREG32_PCIE(smnPCIE_LC_CNTL3, data);
>> +#endif
>>   }
>>
>>   static void nbio_v2_3_apply_lc_spc_mode_wa(struct amdgpu_device *adev)
>> diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c b/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c
>> index f7f6ddebd3e4..37615a77287b 100644
>> --- a/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c
>> +++ b/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c
>> @@ -282,6 +282,7 @@ static void nbio_v6_1_init_registers(struct amdgpu_device *adev)
>>                          mmBIF_BX_DEV0_EPF0_VF0_HDP_MEM_COHERENCY_FLUSH_CNTL) << 2;
>>   }
>>
>> +#ifdef CONFIG_PCIEASPM
>>   static void nbio_v6_1_program_ltr(struct amdgpu_device *adev)
>>   {
>>          uint32_t def, data;
>> @@ -303,9 +304,11 @@ static void nbio_v6_1_program_ltr(struct amdgpu_device *adev)
>>          if (def != data)
>>                  WREG32_PCIE(smnBIF_CFG_DEV0_EPF0_DEVICE_CNTL2, data);
>>   }
>> +#endif
>>
>>   static void nbio_v6_1_program_aspm(struct amdgpu_device *adev)
>>   {
>> +#ifdef CONFIG_PCIEASPM
>>          uint32_t def, data;
>>
>>          def = data = RREG32_PCIE(smnPCIE_LC_CNTL);
>> @@ -361,7 +364,10 @@ static void nbio_v6_1_program_aspm(struct amdgpu_device *adev)
>>          if (def != data)
>>                  WREG32_PCIE(smnPCIE_LC_CNTL6, data);
>>
>> -       nbio_v6_1_program_ltr(adev);
>> +       /* Don't bother about LTR if LTR is not enabled
>> +        * in the path */
>> +       if (adev->pdev->ltr_path)
>> +               nbio_v6_1_program_ltr(adev);
>>
>>          def = data = RREG32_PCIE(smnRCC_BIF_STRAP3);
>>          data |= 0x5DE0 << RCC_BIF_STRAP3__STRAP_VLINK_ASPM_IDLE_TIMER__SHIFT;
>> @@ -385,6 +391,7 @@ static void nbio_v6_1_program_aspm(struct amdgpu_device *adev)
>>          data &= ~PCIE_LC_CNTL3__LC_DSC_DONT_ENTER_L23_AFTER_PME_ACK_MASK;
>>          if (def != data)
>>                  WREG32_PCIE(smnPCIE_LC_CNTL3, data);
>> +#endif
>>   }
>>
>>   const struct amdgpu_nbio_funcs nbio_v6_1_funcs = {
>> diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c b/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
>> index 11848d1e238b..19455a725939 100644
>> --- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
>> +++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
>> @@ -673,6 +673,7 @@ struct amdgpu_nbio_ras nbio_v7_4_ras = {
>>   };
>>
>>
>> +#ifdef CONFIG_PCIEASPM
>>   static void nbio_v7_4_program_ltr(struct amdgpu_device *adev)
>>   {
>>          uint32_t def, data;
>> @@ -694,9 +695,11 @@ static void nbio_v7_4_program_ltr(struct amdgpu_device *adev)
>>          if (def != data)
>>                  WREG32_PCIE(smnBIF_CFG_DEV0_EPF0_DEVICE_CNTL2, data);
>>   }
>> +#endif
>>
>>   static void nbio_v7_4_program_aspm(struct amdgpu_device *adev)
>>   {
>> +#ifdef CONFIG_PCIEASPM
>>          uint32_t def, data;
>>
>>          if (adev->ip_versions[NBIO_HWIP][0] == IP_VERSION(7, 4, 4))
>> @@ -755,7 +758,10 @@ static void nbio_v7_4_program_aspm(struct amdgpu_device *adev)
>>          if (def != data)
>>                  WREG32_PCIE(smnPCIE_LC_CNTL6, data);
>>
>> -       nbio_v7_4_program_ltr(adev);
>> +       /* Don't bother about LTR if LTR is not enabled
>> +        * in the path */
>> +       if (adev->pdev->ltr_path)
>> +               nbio_v7_4_program_ltr(adev);
>>
>>          def = data = RREG32_PCIE(smnRCC_BIF_STRAP3);
>>          data |= 0x5DE0 << RCC_BIF_STRAP3__STRAP_VLINK_ASPM_IDLE_TIMER__SHIFT;
>> @@ -779,6 +785,7 @@ static void nbio_v7_4_program_aspm(struct amdgpu_device *adev)
>>          data &= ~PCIE_LC_CNTL3__LC_DSC_DONT_ENTER_L23_AFTER_PME_ACK_MASK;
>>          if (def != data)
>>                  WREG32_PCIE(smnPCIE_LC_CNTL3, data);
>> +#endif
>>   }
>>
>>   const struct amdgpu_nbio_funcs nbio_v7_4_funcs = {
>> --
>> 2.25.1
>>
