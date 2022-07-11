Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B14E56FE33
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 12:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbiGKKFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 06:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234617AbiGKKEQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 06:04:16 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C366E8B0;
        Mon, 11 Jul 2022 02:30:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N3o9yAhmSPGmA5IdKSzw3wNSx4fu7br7tpT/WRcjEHRwbrd4emS2pY1JpJI8qlS35eaGW1EultJOA5Ox1Cclt+CnXI/zWBoly/jDZ297TEQGQbzhYzDXks1mcu+IEKwukffEOcYVFisRmuq+X9jcmBiOWPfpm6sDJ3AnfZvQfEo+jbOhaK3+flYVdfnneGtJbw5OW6jhVe53/m9cJyk7RQQBaC+LKnj6GWbyivBRwd0kteBpNfn//OCmQ95+IDVCdZePrPOBq/CUPASH6YxmTHU+NkF1XXSwjULaUymye5PRf0arLtSI3lFVO2tJcHRBs9KhQ8Z2pjpyNZezTZh+TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qwPfqc7V2ijCGGSLUumfbTBgCntt/PmZBUBmnQw6TNI=;
 b=WDlop36CpOkCQ3DtljshCrJis2TIqe5xrHU5bnW+sLAEKCtgxPsdXGhkBb+FUw+7HzM/fuAYziBY8dYfc8nRqI/iBdCwT2bR1vfDggIWp+i1rMyxREJB/OZQXI/ND6TDVzXAcJKfRIp20TY7HgAl9P3Tgqj36+nr7px+DGLouVIRxViV4KmfwDq/jfP+rdjugFFci6vpVx2Fu9BTp0b6I+yqb38bINKXN3V9itfkBgArWOW32SSwWRBJyYTsMYgLIpuymCaMb6kmyBttMQUFJZ0LjZ0U93yWk9Owox+Y+Xw+IK12XZXR953+jTls5I+nBpjFMXKyOa/0blHmdkznrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qwPfqc7V2ijCGGSLUumfbTBgCntt/PmZBUBmnQw6TNI=;
 b=wrt0A0EDJZx/lcMHlMHfhqAV3i3d6acneMTUZDeuBxtDn+Yq3vOCOMWFWrFmpnO19h2NVB0VTLW9arkw6s1XXYFBxOywjqtkQOAohmjzqJoi9G/raYLLinDL37NqGDrzWbmRJy/Hspuej+edO3uzxDCKS7i+3EuzTabEZZC7te8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3587.namprd12.prod.outlook.com (2603:10b6:408:43::13)
 by BL0PR12MB2497.namprd12.prod.outlook.com (2603:10b6:207:4c::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15; Mon, 11 Jul
 2022 09:29:58 +0000
Received: from BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::905:1701:3b51:7e39]) by BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::905:1701:3b51:7e39%2]) with mapi id 15.20.5417.025; Mon, 11 Jul 2022
 09:29:58 +0000
Message-ID: <8c73c2b5-f70e-f343-7ca4-e1db420d5419@amd.com>
Date:   Mon, 11 Jul 2022 11:29:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.15 138/230] drm/amdgpu: bind to any 0x1002 PCI diplay
 class device
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
References: <20220711090604.055883544@linuxfoundation.org>
 <20220711090607.978575207@linuxfoundation.org>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
In-Reply-To: <20220711090607.978575207@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0044.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::7) To BN8PR12MB3587.namprd12.prod.outlook.com
 (2603:10b6:408:43::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2f06995-8771-4cd4-2531-08da631fec33
X-MS-TrafficTypeDiagnostic: BL0PR12MB2497:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 21V+dznrbBNdmap0dQUokNFYbBXGs2wurUZPCIaG/g63VcHTxKVV3CcuX3wGdrOT9VOhG4HGYIN/yayGdgJQg19RSkzmW1hn+Z7hLJb84ORu2p+LuXWomsSPeqcXBOOy83jotxO/xC6/+q33nO4yzoo51nIdRXRGKP80vx3AxOdsPTXZjTwJlLYTI6DCNq8BfMjrw7D9iVESdtGA/rllgE/e9TpRX/2PrnLlD2vZHqFtUgSoP/b+iLjGRQGx/lBefUdaCxiAKHNzJCssEAfsJ/tQ6dBXAUGsn+7W37wJQ0/mA1qh5i5clkGgFPbKb/1Pxf+PkA8f2X70Fd/Ge90skrondEgvpDWncJrmYoDUFn7sTXA4EpvLmh90et2nbCC4qxCcQ1iDTBykTGRB8aXPQaUdQj9i0f2MQl2387oLA+vu79pYDwjN2szX5cYw45UoZmPSSNSW0YSdDf3sMQm1dUAxuR/Qa7O7ArV4RApY1cp9UwbaWXegWKniUoEDFQc8/cl8YIycGj4/TlRQuC+QB+1JxRT7pLeKmW/OulEkW28SyTwo5iXuTR1xZ1Ie4TW1Ub/dnY5s399NIZeFbAB7s0YYoOr8rlSw+1R8uS/qEsVEDY7qyySjtxCoUbs7IsPdGje73ibFuC2pTfNffjMrB/uhxTkH4uC3l9r53WB41FVrstVgctSotnFXxuxjo0KI9AweqGme1R2bo29aofbSx/ewbGHt6nI1s7FZmzeVXIseeLUPXynfwxSKn4kDMBjaeLua4ZsPZ+Bh4PHkoYRVc3qnrmy0Il1PUCBhz4k2czFMsS6Bf6bou4JYwhmgnBypalt0FDTOtipvyi5bnTLl1dPoxQJq8WRj6dTuTWxiqmc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3587.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(346002)(396003)(136003)(39860400002)(478600001)(66946007)(6486002)(31686004)(6666004)(4326008)(36756003)(41300700001)(8676002)(2906002)(5660300002)(8936002)(110136005)(316002)(38100700002)(66556008)(66476007)(6512007)(2616005)(186003)(26005)(31696002)(86362001)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bUI1UTJjekUzSGFLR28vdjE2QzRCVWIrUlJBNEZEUkxna2lmM0o3djBGZVUy?=
 =?utf-8?B?YVhqUDAyRzkvajd5VGtCYklWUnRxaXU5SUgvYU0vQ1pFZWl4UUdUVURZRmtz?=
 =?utf-8?B?S1RwcHFyblVqdFg5c1FnL1pkWVB1YnhKN09IN1dWVWt0UXo3Q3FpV0JLdDlF?=
 =?utf-8?B?ckpTU2JqMGFmTi96R2ZBQUlwbVFNdWZMekpLWUQ4SVBsREFGZDRad1hwUEds?=
 =?utf-8?B?NjRwMmVIdlE0L0NoaVQ3SFBGZmFkOU1NenJKbUtITGszb3hSM3RpWHNZbTZ6?=
 =?utf-8?B?K0NEbUQ2Q0Y5NUJYR3NtWnVyWVNBeHB2TE5tcFlWWThRblVoOUtaZHlHSVR1?=
 =?utf-8?B?OW5mU3RlZmU1aGU4OVc4Y2tBelB1OHBKYm9TZWFPRDVBOVAwYkRMZkZpTlRi?=
 =?utf-8?B?N1ltaFRKSThoMms2MWk3RTl3Wmh3WTVOUk5ydHpteXQ4T2l0RXJUaEJGZEIr?=
 =?utf-8?B?VkNiZGR4NzVPdnlycEFFNTdWWnVXNTRNejhvTFlTUkdhMjN4VnNYY0lsdXJW?=
 =?utf-8?B?THg1YzJUWFU1SllMaFhUbTAzUGc4L3NWWG9NRFNPODByZFUrSThuTlloUk1B?=
 =?utf-8?B?bWhFNHJyNWZBNi83VG13RkZ3SlQ1QklPandMWC9RSVdJZ2ZxdU9wUHdHTzV2?=
 =?utf-8?B?d3JsbFlZUkxmMHUrT3Q2ajV2SXBxVFYrZ3ZOV0NkQ3orcFBxempwVFY4UlNH?=
 =?utf-8?B?V1pjODQxTzVUNFp3WHZZTXZ6V1ZUTEdFVjNhY3ZDNzRYeXhQaUkvOHgrbEpF?=
 =?utf-8?B?ZnRjRzBpZUd4eXRCWVlzRjJKdjBtNnpBNExMQ3lVQ1FDTS9TWWNNRVQrRkN1?=
 =?utf-8?B?ZllHYkk5NmZFMm01VWFqZ0RrNlc5aFZkbVNNbUpzVFNic1MzR3BLbVlvNXBC?=
 =?utf-8?B?d2hpMUVueWJUcU1IVkM1SkNHZWE5UUx6WGdSbCtxbFN0WG05Z2ZPKzQ5MUZr?=
 =?utf-8?B?MG1hdnRjMGR2NnpFdEI4SGVnVWcxY3VpT0VQN1hGd1Z2V2NKQ1VoeVpOSzRs?=
 =?utf-8?B?VzRSUnM2MG9ocGNmN252SjI2N1ZjbXp4dmxSQzhNb0ZWeEFoK01uc2JkYjVS?=
 =?utf-8?B?OEYrL09QeUpLYWN0VWJFTDBielp5MGozSFd6ek14M0J4bGxSMHNDRm12emlr?=
 =?utf-8?B?NFRlV2RXRWhMWDNqcm1EaEJIT0dxSXhqZTZjY0tXMmdJamYwWURFQXBjOUx4?=
 =?utf-8?B?cHEwU1F5NXc1clVhdjY0RUpFRE1hSlhrS0orVE1KbWU5VnQzaHc4czNoQWNG?=
 =?utf-8?B?WGdVd3NhZzlyL1RIQlhYUnNqeDNvV0EwSXpoYVdOdlhERXc4QmJvWWhiSWFj?=
 =?utf-8?B?b3VNTTBPSnY2R21sTitYRU5hbEk4enJBSno1RkNDb0ZKbE52cXNuL29hdmdl?=
 =?utf-8?B?aTdLWkJiZTJzcEFIODYvcHhSb3JIL1h3SFpMcm83b0d1WUxsWEFyRFc4WlhN?=
 =?utf-8?B?UlByaWdSUGR1RGp2RGpyV3YwRktEYnlJR1JxNmJaS0RGSXk1d1RKbUdxZi9E?=
 =?utf-8?B?ZzhHTGQvMW9Gb1RzWEdBOFluT1F6ZEovaDBTQ2lCVGdSck1hY3BJZldiRzUy?=
 =?utf-8?B?Y1lCRnJDTTdOZWdJUk1ob3NXOTBkR3FQU2lrRi8yQzF5a21pallsSjkrZTli?=
 =?utf-8?B?K1o5bVhnVGw5ZnI3WThqc0YxNHUxNy90Wi9zK1RjVmxQZDJXODd1dW1GK1lW?=
 =?utf-8?B?SloxS1YwcWdSdWtDMjhHZFd4aGlNcVladjR2ZHRpTHVmTk5lQXJZY2JzTVFW?=
 =?utf-8?B?b3F0R2NmZXJQU05kT2VFOHgvRDlRMW9OdGpvSGRZakVhZjgzdHo5NkNxSENl?=
 =?utf-8?B?Si9WRFlvcThIM2dWNkxKQ3liWFViakJseFRERks2M29sZVZ5bm9WVzRGMW0y?=
 =?utf-8?B?RW5TM1JNb1dINVBHSEVnU21DZWtqUkdZZHhGME1PMG82TkNaV2FmcE5QUmZ1?=
 =?utf-8?B?NXg2WEZwKzUxMy9XdFR0ai9wSElJQmc4OENrK0VHVlV5cWxYbHZIU2ZEdU5Z?=
 =?utf-8?B?cnUyVTNkSmYvTGRSRjQ2akZKSXFUb1lKb0FiYnFHT2RNdVd6Z3A1UHpod3Fj?=
 =?utf-8?B?Z2VSU1oxWjQ5K3Z0OHV6WDFyRFVTK2RJZGFqVjIxRXBHRXdvTUlrempMTWx1?=
 =?utf-8?Q?oeoyNVyU2HM3Q4kP1TlQJOzyz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2f06995-8771-4cd4-2531-08da631fec33
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3587.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 09:29:58.6913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fX/Korh0Oq3EKeS8J2VxVY7odImJ4gXZtlKyR02hBQtV6+hBM4KZaY7i5IDkKQxo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2497
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg & Alex

why is that patch picked up for stable? Or are we backporting IP based 
discovery?

If yes, is that wise? IIRC we had quite a number of typos etc.. in the 
initial patches.

Regards,
Christian.

Am 11.07.22 um 11:06 schrieb Greg Kroah-Hartman:
> From: Alex Deucher <alexander.deucher@amd.com>
>
> [ Upstream commit eb4fd29afd4aa1c98d882800ceeee7d1f5262803 ]
>
> Bind to all 0x1002 GPU devices.
>
> For now we explicitly return -ENODEV for generic bindings.
> Remove this check once IP discovery based checking is in place.
>
> v2: rebase (Alex)
>
> Reviewed-by: Christian König <christian.koenig@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
> index f65b4b233ffb..c294081022bd 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
> @@ -1952,6 +1952,16 @@ static const struct pci_device_id pciidlist[] = {
>   	{0x1002, 0x7424, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BEIGE_GOBY},
>   	{0x1002, 0x743F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BEIGE_GOBY},
>   
> +	{ PCI_DEVICE(0x1002, PCI_ANY_ID),
> +	  .class = PCI_CLASS_DISPLAY_VGA << 8,
> +	  .class_mask = 0xffffff,
> +	  .driver_data = 0 },
> +
> +	{ PCI_DEVICE(0x1002, PCI_ANY_ID),
> +	  .class = PCI_CLASS_DISPLAY_OTHER << 8,
> +	  .class_mask = 0xffffff,
> +	  .driver_data = 0 },
> +
>   	{0, 0, 0}
>   };
>   
> @@ -1999,6 +2009,11 @@ static int amdgpu_pci_probe(struct pci_dev *pdev,
>   			return -ENODEV;
>   	}
>   
> +	if (flags == 0) {
> +		DRM_INFO("Unsupported asic.  Remove me when IP discovery init is in place.\n");
> +		return -ENODEV;
> +	}
> +
>   	if (amdgpu_virtual_display ||
>   	    amdgpu_device_asic_has_dc_support(flags & AMD_ASIC_MASK))
>   		supports_atomic = true;

