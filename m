Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70ED6431C95
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233321AbhJRNmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:42:39 -0400
Received: from mail-mw2nam12on2073.outbound.protection.outlook.com ([40.107.244.73]:2113
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233597AbhJRNki (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:40:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lKlDOSFXrlx0+mNMm6pg7IRD/BzGbZDf0pGxjHziSOVuQ/Mwk65vjC3fo7tY5XpzzpPlNNlxAnilua2gO3ZqqFJ+9/EqFYHUWRtN6Tf9zycmNUT14n5medFq/lPuXtM6OKUYx2qATFvtruNBdg54ZBAb+MmLtze1poSfIoSejl9v4XBM5y9uxMN1z2IrDdojN0IgAw/8anpG808ofdWpNdqk75oHTATKl1l3Z9j5SSmwHFOdXLhjfLCmj3Q034Mk75FK0blNY4nlBHlBpO/tqx9weCz7gWm+VyYUnR0YUpA1td9Bnl2n1IrRUuKOz+rsrywmJ9pXTK14TCRAVOOcyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DZWV3KTWoA/QbtYtv60CjLg0iVYrKsiiz+qTOc1VhqM=;
 b=I+b68O96RhQnqC27KuRPzIpTH8qgFvNc7vJeftswI300iVTei/5ZSnxGvNhekWJRFtB0289fE7ECPuibs0qhxzLZJuAtYt2/nYRbsEZpc2VMNkMXPrcxzGgiWAUWYrAtLLIv4Vg17B1Y9d3v2E6AkHeJbRhwOszDbz0S0V28U/vIjF6NlACosWC2C1j5yxd2TYUdad/33TU0HlhffJTcjgrf0RMHWpMfWFWkPyWwSGAMePpVi8UX77wDGHxnO1X5r0vvQWkbWtHs2BLTDW9OIATB9glEVA5oMl5iDni/OCxLTSK1Ht7X7HESv9WYP7yLE74Nx309kCqSpGVgJ2sS2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZWV3KTWoA/QbtYtv60CjLg0iVYrKsiiz+qTOc1VhqM=;
 b=WATcO7gDI3Ee66JAGIZ/iNxLpRhL3wUI6wNP+iebB0PooiNlqBz1ke9K7lciXh7vxvYgF1mQbylB/rMMijZGw7MU8RQakCZZ0eZZmJaEt1oZp+XWRKSpDDV3dMjyjfYOiRKguK70arUIu+057O/rY4eHDaseBA4jzI2h2zODPOM=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from CO6PR12MB5427.namprd12.prod.outlook.com (2603:10b6:5:358::13)
 by CO6PR12MB5425.namprd12.prod.outlook.com (2603:10b6:303:13e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Mon, 18 Oct
 2021 13:38:27 +0000
Received: from CO6PR12MB5427.namprd12.prod.outlook.com
 ([fe80::d82f:e8c3:96ac:5465]) by CO6PR12MB5427.namprd12.prod.outlook.com
 ([fe80::d82f:e8c3:96ac:5465%8]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 13:38:27 +0000
Message-ID: <7955cd39-d659-fa0b-039b-87554f43c682@amd.com>
Date:   Mon, 18 Oct 2021 09:38:23 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [PATCH] drm/amd/display: Fully switch to dmub for all dcn21 asics
Content-Language: en-US
To:     Roman.Li@amd.com, amd-gfx@lists.freedesktop.org,
        Alexander.Deucher@amd.com, Mario.Limonciello@amd.com,
        rodrigo.siqueira@amd.com
Cc:     stable@vger.kernel.org
References: <1634337100-12682-1-git-send-email-Roman.Li@amd.com>
From:   Harry Wentland <harry.wentland@amd.com>
In-Reply-To: <1634337100-12682-1-git-send-email-Roman.Li@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQXPR0101CA0032.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:15::45) To CO6PR12MB5427.namprd12.prod.outlook.com
 (2603:10b6:5:358::13)
MIME-Version: 1.0
Received: from [192.168.50.4] (198.200.67.104) by YQXPR0101CA0032.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:15::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend Transport; Mon, 18 Oct 2021 13:38:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65434f66-84d5-488d-b60d-08d9923c9045
X-MS-TrafficTypeDiagnostic: CO6PR12MB5425:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR12MB54253214194F73DC1E0EF5DE8CBC9@CO6PR12MB5425.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vlmn7DRptKpTL2B6n5K9k2yJkoQUoBNIZab5NAGa8GaTdAowtdTexDJPpdwygUOL+6mzXPCgzDjnc52GqiU5yKaAr5UdkzgDOFh1c0zuQe6sx5WoAJiEdwxkhrh0eCI70xylWUb9bve8Cb0lMb9CnFPc7eT/Le80NIjYiLy4fCs5VMW4CkkGSDTOnFN1izvu2XsX3GRTfARTJG0Ejo5EawotSeSjtCppHLffRf4zIP4/L+FnU/PaSBVwbCLoBXBKmucmZHTMBAoK7fDLrl8arA63/MTn5RyqTLwb9fbYtK6Q9tsm7CNxjc0e0kPgJCz9DaBSyaFHfdpsZnDgPFCc9/FUZykTPVgdP+Wom9ZNlG5nzWwk0RD/HpF2IRZJcww8dDQQbcr3rdQWX3oqdkhtE+WHMDfA5bWn2nbkP+W3TZ2PsaMu1SN/UU0C7IXb5HsNGgpao/q+UrxotPQrffm1Ja75wSc5L7+gDPX44DwolPLg06brVY8YkrfICO6p9lpd5yjRB/9eKcDTWThUGyo7iK57lX1e7wvIUGw+lMyo1LnjzN9lVnDkZTXDdvDiEfx40f90fHRHu6x0wrBP/DMK6z81RSxf1SY1oKDd35FM3y8cJJHU5kQsp9eePZMQOkZHtSOkvclBGcii7Wf8hdASJoqOexK9bXQEKpHckdoaxmLncPAAsqU+MDUDxrA0Jm16kwWoaPYk2tnqBNn59oezlE779u7DLsQeZ455CKsBXP+W4JVkUjfU9tltvAAjmtlF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5427.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(16576012)(6486002)(66946007)(2906002)(8676002)(83380400001)(186003)(36756003)(44832011)(86362001)(53546011)(956004)(31696002)(6636002)(4326008)(66556008)(38100700002)(508600001)(316002)(5660300002)(66476007)(26005)(2616005)(966005)(4001150100001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bnJwc1N1RytNSi84QlpVYUgydGoySHErT05kZ2t1eXdYbUVKdUFadUhoQXJn?=
 =?utf-8?B?c3RoVWdZYkpoam9Sb0dxNm5kMTdBNDY5cWIyVVBzcjcxSmtTMnpjdU1PdHZ6?=
 =?utf-8?B?K0hLd3ZCRWViTm01ZmVHZjRXOUY5UjVDK3NISXNCMGR4aE52RUMxMmJrYWNt?=
 =?utf-8?B?VUh4Y1N6ai9EKzJ4dXk2VjdHc2YrYU1vd3lxQVYvRVNsUjZBWERvZ3Jpczhu?=
 =?utf-8?B?VHpYQkJrYlpveGsyR3NIb0NaOXBGcHdlMzRuZk1YNGx0UVorU1RmZ1d6eFUy?=
 =?utf-8?B?TTBGV0tnV2JHNk0rU3BzUjdxcW5ibDR1TWVQN1NDM3dYY1FzdTlZc3VDV2ll?=
 =?utf-8?B?Uy9NN0ZIU1k4OGQ4NW93M3FJOWRxM1RsQ1BlKzRGZ2pvL3NkNVRwMjdHSnJE?=
 =?utf-8?B?Mlk3cTlYazgwYzQ2eW9nWGFFcTU2Q0M3VnZjSVhTWnVPeHdWWGVPVXgvSnJN?=
 =?utf-8?B?YVc0RnNjNGVZUVNyeDF5Q3paZW1QYWNML0l5YmgvazVvTlBEbXpWbkFCVzNh?=
 =?utf-8?B?Rm1EUTdkS2tENWNxRTRzUVVTaUhZT1dwYXdOcyt4NXhYS0gya2lJcU5McFor?=
 =?utf-8?B?cXYyclNqZEs5UGhOdFJ3YlBQSHN4cEJYTk0zeDdNRlFLcllHaE1UUXp5aEhs?=
 =?utf-8?B?aytjalAzSWFxRjMxMGVmM01uRzRxeTlRTmFnSmFEYUtvdXIyUXBmSTJmTjc4?=
 =?utf-8?B?RkhDbkQvaWpRemw2ZVo5SUwrNVNraU1pMWRDWlcvbi8xdFlEL0VtKzBkMzZu?=
 =?utf-8?B?K0QraDIwcHJRSVdOUmRqOUY4MzVKb3lXZnk2VzgreVlPamlsZGoxQXBBWEs1?=
 =?utf-8?B?SmJOeTIzbmw3MnR6UDgrS3lRbVBUbTI5czhQZ3NNdGRMaDFVRGxyWmdFRDhS?=
 =?utf-8?B?N2hDSGpJOHRaN3dKUHh3N2xIQnJ6ZitvYzlsYktpejBRSk8xL1ZvMWdTTmNS?=
 =?utf-8?B?ZysyZmdNeGZvUUNSRUZVWk1xTEtSSGEwOVJsaXpXTVMwSUFpWFFqUjg0RG9Y?=
 =?utf-8?B?OFZIWlBUVU40aGFycXc0VElpdXNiR1NSRWgxVEFWeVlsYUJSUVIzY0ZDeWFR?=
 =?utf-8?B?RWF2L3E1c0VBNjNiSU10ZlozUjVheVdpTE1iWWZENzhibGRBZ1JPektYY0d6?=
 =?utf-8?B?Q1F0ODU1WWcxYXV1YlZNZ3hRZCtSZVdIdDdNdGNmU0JzNVo1MUxPUFl0R2Zl?=
 =?utf-8?B?Vi9aWXoxWmNiVkF2TGl5ZVZYSVdKcXcyQ0dLZGo1ZDNyUTF2VUdjSXlaS0lh?=
 =?utf-8?B?eFlVZzZaTUhoWTJ2WE5ORXd6WXh5anpQOWloNVJFR1ZZSDJZVFdIQUxpRTRs?=
 =?utf-8?B?NUtka2RMdlRMNm1GNDdTSzRSTERSRGlRelo5Wlp1bUV1VGJSQUI0Qk92a3gx?=
 =?utf-8?B?emtCdVpick9Fa1NNa1JKTFU4NzRILzFpTVRlZklJeGVZdnpmVkFXbWhCTWM5?=
 =?utf-8?B?emxnNFBYajl4VXFkS0VqeUpHcGRsVnBybk5IQVhTSkFyNVR3ajNwSEErcWJh?=
 =?utf-8?B?MVBXMmdMVGpycEc2cVVRc1ZyTjRQTnNHTmlaYUc2eVF1ZnFFVWJKbTJiL1E0?=
 =?utf-8?B?eFZmc1ZBTHdVUHNqbUdKUGdEWjhGZURmR0xTK3dYMXh0cTVwbkFUSHk2cUVN?=
 =?utf-8?B?UnFkU1AwRXV3OExSZFlPeGEvcDlTYS93WU5TTEcxM05YZGk0bDU1WGRVM2xa?=
 =?utf-8?B?NEJXRC90Tkc4U1RMdS9MN0RsTk5seDVkajZsT1FObnFpdmltQU0vWWpqSlRN?=
 =?utf-8?Q?FyCNYKx4PEjMv2yhvn5BPVriaro8tANYY2GWG/B?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65434f66-84d5-488d-b60d-08d9923c9045
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5427.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 13:38:26.9141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Nab+X0FynPAilIYsBac7QUqbB3QN3FOQ/kkF63bKB/Vn7GZ2+WnwTNdW7TIxomxqZ9sME2Y4s40s+YKyjqpNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5425
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-10-15 18:31, Roman.Li@amd.com wrote:
> From: Roman Li <Roman.Li@amd.com>
> 
> [Why]
> On renoir usb-c port stops functioning on resume after f/w update.
> New dmub firmware caused regression due to conflict with dmcu.
> With new dmub f/w dmcu is superseded and should be disabled.
> 
> [How]
> - Disable dmcu for all dcn21.
> 
> Check dmesg for dmub f/w version.
> The old firmware (before regression):
> [drm] DMUB hardware initialized: version=0x00000001
> All other versions require that patch for renoir.
> 
> Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1735
> Cc: stable@vger.kernel.org
> Signed-off-by: Roman Li <Roman.Li@amd.com>

Reviewed-by: Harry Wentland <harry.wentland@amd.com>

Harry

> ---
>  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> index ff54550..e56f73e 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> @@ -1356,8 +1356,7 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
>  		switch (adev->ip_versions[DCE_HWIP][0]) {
>  		case IP_VERSION(2, 1, 0):
>  			init_data.flags.gpu_vm_support = true;
> -			if (ASICREV_IS_GREEN_SARDINE(adev->external_rev_id))
> -				init_data.flags.disable_dmcu = true;
> +			init_data.flags.disable_dmcu = true;
>  			break;
>  		case IP_VERSION(1, 0, 0):
>  		case IP_VERSION(1, 0, 1):
> 

