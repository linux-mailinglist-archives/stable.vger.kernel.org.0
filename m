Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDFAF431CE3
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233740AbhJRNps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:45:48 -0400
Received: from mail-dm6nam10on2088.outbound.protection.outlook.com ([40.107.93.88]:63009
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234100AbhJRNnt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:43:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F+9AmYbZIsl+hTozZq7y52F04rcofxCiOolrTsLU9xabX5AHfBWfI58S7LOjaUdQPysDOY5mbe0//D4jatx5w8U55jpuoGPRHPaQEnRqGKXMaQyhpykQpUoHaIhSUvaCtQ/oSHj2DtyGqPwpHbpz7j7ZJGpPUtKhmduq+jSLMqoC5OoIAuKYjpXVIY8asLRfdrlo5jWny47gUAnsx8e2WrHIbCB1DoAY1WZbIAIHGqm0A3eikOhtNgxkR0y4styKA+qh0dx8UhBo6YA/X95V3HkOIwScfHofq990+u2bOeb9iRb6Ntv69mwFEx3f4qblDMe07VNCCOu0SgC0nLGRCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A4uIbBU4ZQiTyF3CNGxuEpCyX4I4vkBzLSk79A5hKOg=;
 b=Wxpg2JhwCMrEAftt0vNZ86e/n4ZCen4gEgCRFdGOnNoQLQ0w1SO/Qva1f9WcQ3U8f2rYr8vyYlHfWvNxfwdBinr5us+z/WOK79CutY0VJGgeAhHEM/aftmH9hGfQ/uiqrF8UpPGyifhHbMe4BAlQMQxRdfnK3Bph3W2wILv80hDbPLuLnRWl/jonIeawB5u318IRPpuNz1DporVwjS4GjoTxWCCKJ/ObgJDYSVXrz96Lc+va1I1J6hW+onc1hsLGcqouudzVQIEXbf2CtMLd0y8giOGjePqPMLQPx8TM5kZiRVscPp+5LtRKjHNbemAM4mQdyHLWwutyLrgiO/Wzdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A4uIbBU4ZQiTyF3CNGxuEpCyX4I4vkBzLSk79A5hKOg=;
 b=nHDlZDs0DQ4OERa0KTiJq0pIIHnN7pwKx6E1WKLffgMDTMNyDWQKfpFBsnKrGumyb6mttVXPU3flfCxsdD+Y2d07ldJseiifOPEQH9YZp1S2bXDVqm3ANlwKk/UfKRVcWvo0/UPRMaZd8gDoYKF4QU5PFZmRj+BUOYuGohS1+i0=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SA0PR12MB4510.namprd12.prod.outlook.com (2603:10b6:806:94::8)
 by SN6PR12MB4751.namprd12.prod.outlook.com (2603:10b6:805:df::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Mon, 18 Oct
 2021 13:41:36 +0000
Received: from SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::f909:b733:33ff:e3b1]) by SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::f909:b733:33ff:e3b1%4]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 13:41:36 +0000
Message-ID: <7076d49f-b450-d500-fdea-2ec3e59cbf80@amd.com>
Date:   Mon, 18 Oct 2021 08:41:34 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] drm/amd/display: Fully switch to dmub for all dcn21 asics
Content-Language: en-US
To:     Roman.Li@amd.com, amd-gfx@lists.freedesktop.org,
        Alexander.Deucher@amd.com, rodrigo.siqueira@amd.com
Cc:     stable@vger.kernel.org
References: <1634337100-12682-1-git-send-email-Roman.Li@amd.com>
From:   "Limonciello, Mario" <mario.limonciello@amd.com>
In-Reply-To: <1634337100-12682-1-git-send-email-Roman.Li@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0060.namprd04.prod.outlook.com
 (2603:10b6:806:120::35) To SA0PR12MB4510.namprd12.prod.outlook.com
 (2603:10b6:806:94::8)
MIME-Version: 1.0
Received: from [10.236.178.93] (165.204.77.1) by SN7PR04CA0060.namprd04.prod.outlook.com (2603:10b6:806:120::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Mon, 18 Oct 2021 13:41:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23340887-3026-4f91-44f4-08d9923d0160
X-MS-TrafficTypeDiagnostic: SN6PR12MB4751:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB475129440CCFF671371D5DC5E2BC9@SN6PR12MB4751.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vJuSDb1AqcI+xbpUzC/Qw1uPEadKNthkOBif4xBp/kOdFOZDd2T3xu1lDzhrNGiH3NU+imDN01yeuhMbQ17kpAzbgTccXmNV3X0DyNAsoyjpAoSceZJ1nbdCqkwv9d7qpOWvbhR40Arz4JmlvwmpcnsRZMTv0tab0m+laBxjOwx58fHafZs/ahdpFxTMn8VyCqroNq3sGJWdDHfaO6gjncJoDuQFW9tMsdeUJR95ML6vvRDcIbvqivcXDWmwTrkc4gTdR8Zl/7yeJ6O2x2dam2Z0N0BXC7WKm6ksyAW0LpzcrTQQo4CEqyo2jxY1s4J+Zbfv9me0Lx0e4tl30NoOoAhuzZcl6h06jw6V9pWiEnhKlFIiD6fhxAmzRqHvoArF3cgN198O+arwgdpZBsDUAajVScJ26VDCnCrL/sqxaXF8PkYov0CMfKZRV8x1HQzB+fi+YN2DfB2nKxGDYFh8qhLTLSjkqOjRSjAOCSRCeo/w/YYvcW5S1noPr+DGttRPBQb57C9oXtNcbWqtEqMnpP/FH+YhBMtKGOT0yuajf+zZZMARnmPNhaCvZSaktZudeRhwyjRKmKVLaHjZdb86Yxa3f8omc4I5C7yES0eUccq4eTURl/fOPxJh3p3z8jgj6Occ8Yxkg8tW6cZcaaSlp58OrGsKNYv1AuI4BUWBWWdn+SyOAasL5xP2VBnydCfPWhpag7YSLp33/46QhGtgzutCWDAFfICW1u0fL/H9CYugvhJxqjCq7//QHNulerTB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4510.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(16576012)(966005)(66556008)(53546011)(31686004)(66476007)(6486002)(4326008)(38100700002)(31696002)(36756003)(66946007)(186003)(86362001)(2616005)(5660300002)(26005)(508600001)(83380400001)(8676002)(316002)(8936002)(956004)(6636002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZUx2S08ybmhac01GUlpDYlNjcnBrN01FZzcwWklVK1crdGJiSDVkZ1JUcTB3?=
 =?utf-8?B?M0ZxWk1XaFUxeXBpMkd4M0JVYUdTTHNJaHRIY0MvZ2x5R2QvOWsvbzllU0gz?=
 =?utf-8?B?SW5pblZuUW4xZlU0NHc5YkpDY1RBa0hPWFZaNlhBVk5tMnUraVNJdW9QOHUy?=
 =?utf-8?B?Yk9zUGlXRE1sOEtPU1NtUkdUMytQaHM3aGRIQ29vQW9sam5ZVENFR3hNVVpB?=
 =?utf-8?B?TzJSVTd3QTlKRXNRUlg4aFg4bXB6WlFPS0s5K3ZUdjBEa28veDhLa3B4bEY3?=
 =?utf-8?B?djhMT1hUKzJMYS9ZS3JDVFB6c21aRm80OUNObVVlR1lZN29xc2h4VXJscFlF?=
 =?utf-8?B?VS9XV3JVYW1tUExHWVFKSitjVkRJY21kME52T081R0pBeWlzTm5RaUMrOEE3?=
 =?utf-8?B?blpxT3A1cGhWNDc3dHdoUkFpZ0ZUVU9NOFExcHZsb2UxZk9CM0hpazFYMGs5?=
 =?utf-8?B?K1poWnVQamhoTzlxaFhLUk55NDZ6Zk9DcWtOMWJEbHI5aDdpU3ltY3RldlRM?=
 =?utf-8?B?bHZuWUhkM0JaVFB6RFpWMzlEODlQWFVPMnlHbUd2SEJIdzdlNElrdXl4QmtD?=
 =?utf-8?B?eU1YWXhtbTM0dk1maWE5bHdtcHN4YUJKZ1NYU2NzOGMrTW5RWmdjVm95MEpV?=
 =?utf-8?B?Um9GajdkUXJ0UzNBVVNOUWZwODA4TWlUT05lQUtFbEZEaWNLQlJSbFNUTVNG?=
 =?utf-8?B?VDZVZFU3eVY2eUVVZEhpQm0rOG44QWNjU0F5cVR1K1ptYzdPZHZ6SXNrdG1X?=
 =?utf-8?B?dG43S1pVZEs2ajFDd1JwWCtZWXpMaXZ5WVQrNVZhb1ZrN1VvUnVnZjJsT3VX?=
 =?utf-8?B?T3NFQW5TakFHeTluOGtSeTRYZ1QxcHUzaGdXTzRadkpCazBBYnJxM1ZNc2ZH?=
 =?utf-8?B?cUZyMDNIQzNYWHlLM2pBZ2E2WlFVT01FdnM3VzdReTQ4UVpxejdoQWNhQXhG?=
 =?utf-8?B?V0ZtWGZCUmtyMDlPMnlhWWZUczJPQ215WnFmbFNyZ01Ha29GYnBneEhmTWtJ?=
 =?utf-8?B?Rkt5UWNWTDRheHFLYmxnOGZ0UWhMVXJHOEZyd3NScG1sMms5L0RqZkY5WTVG?=
 =?utf-8?B?cytwdVlNb1V1azVKSlpZNmYyR3cyc2J2bjV3b3FxWmFvT245Vm1ONjhLVDdE?=
 =?utf-8?B?cmVoczNuYkRMNlFxK2s3SEZqTDNoUnZIbTFYNllrSjVFcDVROWZ0ZVdIMUs5?=
 =?utf-8?B?R2xjUUV0TVFTeGZhQ3p0WDRJZFEyanR5UFRSdVRQd1RzSjRXblhJaFhoY1Rr?=
 =?utf-8?B?MzVOMjBjM05XTHRYcjhiMWl6dkZ6RS8rN29PNC9WbzRrNlptZVR0WjhjMjY1?=
 =?utf-8?B?NnY3dXlma2lMN1liMXZNcTlEUUsxTnRGZ3RNazN5SGx2V0NuS2RaVGhvNUta?=
 =?utf-8?B?SXBnMlFoQWFONjNzM2FyVjNLSWx4Q01tdmpLS0h6QUZ2U3RGTkdnUDZqNnRT?=
 =?utf-8?B?eUJwQnVxZzVJbW5mUE5JVWlZVVI2NjdkbVdnay9QcWNXODB2K3ZWNzZYZFcy?=
 =?utf-8?B?R0xYWmFEUEIvNTNkVXRGUDdkbFY1cmNQeDcyeWQzOEdHcGp2RnBGUWJUUVg2?=
 =?utf-8?B?TG1kcWYyQUcyMkRVdHlBdjZ6R1JwUFRPRmg4ZHNaVmhSQU1Rc0hBKzFoUStw?=
 =?utf-8?B?QnQwdEFqeUlEZDhyaklidlZUZWJnVTBSM0ZBM29VWnR5NGlhYUF5aG9PMWgr?=
 =?utf-8?B?OUZJQjlSa0crZTJNVGFCVnFlQWNrT25GSk51amRtZlY3ZUFCQTF4ZDV3azBz?=
 =?utf-8?Q?w7eN9jhNMBtDJZq5qG926VMm4ga4XGP2jupZDLY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23340887-3026-4f91-44f4-08d9923d0160
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4510.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 13:41:36.4597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nyPL1jcCzCKrlQrn+Q6hGbFwQD6KGF/la+q9G76K8r1N/DH6x1DqugQGkeh24r6wDxEjUN3KaD6XFgu7lmVwIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4751
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/15/2021 17:31, Roman.Li@amd.com wrote:
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

This won't backport cleanly to stable 5.15 and earlier don't use IP 
version to detect the chip.

Also - a question: *should* this go to stable?  If a user has the older 
FW what happens with this change?

> Signed-off-by: Roman Li <Roman.Li@amd.com>
> ---
>   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> index ff54550..e56f73e 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> @@ -1356,8 +1356,7 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
>   		switch (adev->ip_versions[DCE_HWIP][0]) {
>   		case IP_VERSION(2, 1, 0):
>   			init_data.flags.gpu_vm_support = true;
> -			if (ASICREV_IS_GREEN_SARDINE(adev->external_rev_id))
> -				init_data.flags.disable_dmcu = true;
> +			init_data.flags.disable_dmcu = true;
>   			break;
>   		case IP_VERSION(1, 0, 0):
>   		case IP_VERSION(1, 0, 1):
> 

