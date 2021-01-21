Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C71B12FF0B6
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 17:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732309AbhAUQmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 11:42:42 -0500
Received: from mail-bn7nam10on2041.outbound.protection.outlook.com ([40.107.92.41]:11553
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731894AbhAUQkx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Jan 2021 11:40:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=njvVdjdLZNqT5871chPevOYzO12NnpAXHLEohaCqVJbwoIcETrLcueyQI3fF+VrD66Lfebfg2tNMbs5rXh5CNkpNSZAGgotaeXr5LoCS1mdwLZgpPvrWb3Do/ZbQtvx9QtMsYW3LzSvDVNJ8FnYKc6WAovh9PPElAXdith8zmTmNDlgZJX9YRfjQG2HQFtHLYuIRIhEQVE1/SMwp1G8taM+uVbBEHl8wN1+hfD0kLQSx2Ups0x7j8rSe5y/NmKqmz2bAIxBazveF1JFDHavmIC6BW37Mrfd7h5JatYYNB+90md3pYEU+KDGJLY7VRAnCTg4ITaLO7eKgUcwzSs30Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MPQt3hpFbb7QQdU9mbXFIMVeTVt7cMSFn7823AGWdVQ=;
 b=NnlQtHEFsiIQM5ztJrpE92BrSzvx/bOzxMOIj+5AR7kJ/f8uadlSynT3cx//LcQnaDxTKRzmZfis5RUr+Lfk8pOc7RfHbItLzbOZ/kd5yCLU3i+WYl3r/oOpF7TR3JVkVKHfKVJJbZrM/rC2k6V/mmNoUVLER/Sb2l0cpkvuF8nTeuGBaPtOSM/2huHoJQqtEsHKXim7Q5KXHIosbkRmHsgk/kq09dS5AJHfFcJDxeNPIGsaoqVR/ejh17j0aR3I6Llu0j1ew3MgUVmtNFEYD19rdFoTDnEv3BD71uJP6G1qS/ygXWPsYw85QOTyNJpaNAL+ioiCDMWokXbeewfVJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MPQt3hpFbb7QQdU9mbXFIMVeTVt7cMSFn7823AGWdVQ=;
 b=LHtWAzqCCOhqyhVQa25Xz/eM/ZHMip6oHUFsRQFRpZ3tglhAlOLTOJM4BO3RvhtLKonxoXerltGG2uBQfvQcePU5vGyWU4LdznVAN7CJjqbcKdhRLPLVBMb64VhUbU+lA1UHFiBe9dULRN6ABz3g/ZQ+vqgZ6HN629c7kDm8k3s=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=amd.com;
Received: from MW3PR12MB4379.namprd12.prod.outlook.com (2603:10b6:303:5e::11)
 by MWHPR12MB1757.namprd12.prod.outlook.com (2603:10b6:300:111::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.13; Thu, 21 Jan
 2021 16:39:56 +0000
Received: from MW3PR12MB4379.namprd12.prod.outlook.com
 ([fe80::172:235e:14a4:bdc6]) by MW3PR12MB4379.namprd12.prod.outlook.com
 ([fe80::172:235e:14a4:bdc6%7]) with mapi id 15.20.3763.014; Thu, 21 Jan 2021
 16:39:56 +0000
Subject: Re: [PATCH -stable] drm/amdgpu/display: drop DCN support for aarch64
To:     Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Will Deacon <will@kernel.org>, amd-gfx@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org
References: <20210121092040.110267-1-ardb@kernel.org>
From:   Harry Wentland <harry.wentland@amd.com>
Message-ID: <dfbb1ff8-5a7d-ae15-c9e2-8911892bd0da@amd.com>
Date:   Thu, 21 Jan 2021 11:39:53 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210121092040.110267-1-ardb@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [198.200.67.155]
X-ClientProxiedBy: YTBPR01CA0015.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:14::28) To MW3PR12MB4379.namprd12.prod.outlook.com
 (2603:10b6:303:5e::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.193] (198.200.67.155) by YTBPR01CA0015.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:14::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Thu, 21 Jan 2021 16:39:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 54904067-9c52-4a48-9f1b-08d8be2b2f37
X-MS-TrafficTypeDiagnostic: MWHPR12MB1757:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR12MB1757797DDEE7894F33B366678CA10@MWHPR12MB1757.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xL4vhTqAttAowPESsQPzlI4lFSPPkPVQHoSFrV787WasE4JeDe4T9f/leYazyVuUS2xJEsMzr3/wMh35kgwKn6pVPxaIbkeOWI6ohDj1IOrTLWAIfY5mFB79E9pReAJkVHceBMZlRK/TR2PLSEdDNJtTtmGQFpGlE8KScHDwHzCRsuE/7to3F31AXx7nX1q5ET2gIOGptLG0Ni1ccmosR0E1IxZKrtehMbtzlW5E2TnB8+YchtocTNnVyySf4Bl89PBt93h2rHDrpewC6marhHtGwMmP3KkyiScz4gWo85L7vXx83zgYLQnr6zRm5PaGiDiItxl5IMQhrP+x+y9pMXUgQ9Ca5bBnHu+Ze7KLmYuOzWAshk329fpCLcHT/Z7DVhDRoMicBt2ITmzDc2MkFFr/hjv3bFKJyu0pEwph7/mPVg/PACSbtzWr71FWnKw1ch/CX1Mq0duPSMix+dtyGiXqrEp5UHoAxndMwoKcoi4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4379.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(83380400001)(4326008)(16526019)(44832011)(66556008)(956004)(8676002)(16576012)(31686004)(66946007)(6486002)(26005)(30864003)(31696002)(2906002)(66476007)(54906003)(52116002)(8936002)(86362001)(498600001)(36756003)(186003)(53546011)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NGQxcGgrWkRHbmJCOVU5N2VoeElVeDV2UkttSkMzZk04QldEdGRWam9za1N2?=
 =?utf-8?B?SW9LczhsSHBFWER1TWEyZDFyMzhUZFdZMHNvcDc2dGZFMzRiTjkrWkF6VDhN?=
 =?utf-8?B?N1l2OEo3dkVGdHdMYmVMZlZ1R0hrdWZmQmJVR2t5QjZGREZ3dmpjQmVoYnNH?=
 =?utf-8?B?eXhPSGh4VFpWTFVBZkpCN0pBZkxNenNiTkg1ZzIvWXNRZm5udER6RzByUXR3?=
 =?utf-8?B?Q3BlZlJ5YnpvWkdUYUVVRTBNUWxZZ0ZYM2V0OCt4RmxML28zK1l2dkpJaHVG?=
 =?utf-8?B?Rlk2S25lUDM2NWNTa0FTY0cxdUxqUlRkcW1aTUR1ZFMvYTZwbnRJRFhmTklK?=
 =?utf-8?B?eHlNMlVrN0R2MGNpOXI0K2VNZmk3Q1JkbUhZZkRSMnJpbGlVdkJTTDdLbHht?=
 =?utf-8?B?N1g2eExaMVhjZWpvcDZmcVpIWFhsTDlkUVZ0czE3VGhBNXZ2SFlWbDY3dE1s?=
 =?utf-8?B?aDhLaEJRY2p0amZSRm5HbDlaTnJTd0lzbXorN3FpUEo5RHRlMlFRMm5SR3hF?=
 =?utf-8?B?ZVhXNVFDVWJSLzlHZksybS9HZnJtZlNNNWdkbHkrcVRtdExldlJkbzlwY2Rs?=
 =?utf-8?B?NzNlcTVKcHlYeFFwRjYvTjZwMlhydUtwTWhHRUpUamp4VUlMUVR3S0dWdE5l?=
 =?utf-8?B?MXlhRkhZNTdTaGJIZnI3cklRK3lZWGYyeFp1bVA4dEZOV29ZeE4wQXBPNUVk?=
 =?utf-8?B?Q3pGK2g5L2h3TXlNZ2hPcVVTbnRrRFlOdlAzeFZYZVVQd2lCRVdVVXZhOXVI?=
 =?utf-8?B?d3loUWJjYm9Bck0yaW5tRXNwUDhsUWNGZi93SUx3Ym5ibzRsTS8wTmZ2cGRp?=
 =?utf-8?B?T0Nobmo5L1FrUXV0S2VIM0JhY3UzSFRJSkFEOVFLSmxpYXJxVk5kUitQQzBC?=
 =?utf-8?B?UUNUbitLWVZpeUhLNVQyOFYvRnBIMzZEbFdCSmhROTM2MFZLS0tyVDJpaXFy?=
 =?utf-8?B?aFRSS0RQRmcwVG1hRlB6bUM2cTVoSExpcjh2d3B5dnJGd1Y1R0V4RmVncDFV?=
 =?utf-8?B?OFN0VlkzZ2JNNUVZZmZadEFWMnNGcU5WTE9UWnVhd1ROME1XREhsUXhLdnJF?=
 =?utf-8?B?eW9YemdIb216Vi9OamtnbHQrcnFnemViNldQalNmTlVVL3NPdTg5ZW9qcmVh?=
 =?utf-8?B?ZFByUWtjMzlRYkk3NFl2QVErbzZsZUFZSXRxZlZ2SFM5c2krM2g1M3IyeGVN?=
 =?utf-8?B?QTNoRk9JRDlseFpsSWQ3aUYvQzFiY3JuZHRQd2JoM1RaR2lOcmpaYmZsTW1N?=
 =?utf-8?B?M0tTZ0dXclRFK3JONjJHUVN5ZHZLTUtBZGsrSGxJaVpUS0hXcGVPdFM0VnRM?=
 =?utf-8?Q?3K8Anwb5jBMtQF/JHPq83NLPJjyw4ZZZFS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54904067-9c52-4a48-9f1b-08d8be2b2f37
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4379.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 16:39:56.1126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HKWMZn0ch5y0GWcLJdHr+UGdZInJyMPr2HEx3M+yQ/aQf9QEmB1dRXZevx5o5iSnMLthk4LHUbcSF9yNYzhFiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1757
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-01-21 4:20 a.m., Ard Biesheuvel wrote:
> From: Alex Deucher <alexander.deucher@amd.com>
> 
> commit c241ed2f0ea549c18cff62a3708b43846b84dae3 upstream.
> 
>  From Ard:
> 
> "Simply disabling -mgeneral-regs-only left and right is risky, given that
> the standard AArch64 ABI permits the use of FP/SIMD registers anywhere,
> and GCC is known to use SIMD registers for spilling, and may invent
> other uses of the FP/SIMD register file that have nothing to do with the
> floating point code in question. Note that putting kernel_neon_begin()
> and kernel_neon_end() around the code that does use FP is not sufficient
> here, the problem is in all the other code that may be emitted with
> references to SIMD registers in it.
> 
> So the only way to do this properly is to put all floating point code in
> a separate compilation unit, and only compile that unit with
> -mgeneral-regs-only."
> 
> Disable support until the code can be properly refactored to support this
> properly on aarch64.
> 
> Acked-by: Will Deacon <will@kernel.org>
> Reported-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> [ardb: backport to v5.10 by reverting c38d444e44badc55 instead]
> Acked-by: Alex Deucher <alexander.deucher@amd.com> # v5.10 backport

Acked-by: Harry Wentland <harry.wentland@amd.com>

Harry

> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
> The original commit does not apply cleanly to v5.10, as it reverts a
> combination of patches, some of which are not present in v5.10.
> 
> This patch is a straight revert of c38d444e44badc55, which is the only
> change that needs to be backed out from v5.10, and amounts to the same
> thing as the original mainline commit.
> 
>   drivers/gpu/drm/amd/display/Kconfig                   |  2 +-
>   drivers/gpu/drm/amd/display/dc/calcs/Makefile         |  7 --
>   drivers/gpu/drm/amd/display/dc/clk_mgr/Makefile       |  7 --
>   drivers/gpu/drm/amd/display/dc/dcn10/Makefile         |  7 --
>   drivers/gpu/drm/amd/display/dc/dcn10/dcn10_resource.c | 81 ++++++++------------
>   drivers/gpu/drm/amd/display/dc/dcn20/Makefile         |  4 -
>   drivers/gpu/drm/amd/display/dc/dcn21/Makefile         |  4 -
>   drivers/gpu/drm/amd/display/dc/dml/Makefile           | 13 ----
>   drivers/gpu/drm/amd/display/dc/dsc/Makefile           |  5 --
>   drivers/gpu/drm/amd/display/dc/os_types.h             |  4 -
>   10 files changed, 32 insertions(+), 102 deletions(-)
> 
> diff --git a/drivers/gpu/drm/amd/display/Kconfig b/drivers/gpu/drm/amd/display/Kconfig
> index 60dfdd432aba..3c410d236c49 100644
> --- a/drivers/gpu/drm/amd/display/Kconfig
> +++ b/drivers/gpu/drm/amd/display/Kconfig
> @@ -6,7 +6,7 @@ config DRM_AMD_DC
>   	bool "AMD DC - Enable new display engine"
>   	default y
>   	select SND_HDA_COMPONENT if SND_HDA_CORE
> -	select DRM_AMD_DC_DCN if (X86 || PPC64 || (ARM64 && KERNEL_MODE_NEON)) && !(KCOV_INSTRUMENT_ALL && KCOV_ENABLE_COMPARISONS)
> +	select DRM_AMD_DC_DCN if (X86 || PPC64) && !(KCOV_INSTRUMENT_ALL && KCOV_ENABLE_COMPARISONS)
>   	help
>   	  Choose this option if you want to use the new display engine
>   	  support for AMDGPU. This adds required support for Vega and
> diff --git a/drivers/gpu/drm/amd/display/dc/calcs/Makefile b/drivers/gpu/drm/amd/display/dc/calcs/Makefile
> index 64f515d74410..4674aca8f206 100644
> --- a/drivers/gpu/drm/amd/display/dc/calcs/Makefile
> +++ b/drivers/gpu/drm/amd/display/dc/calcs/Makefile
> @@ -33,10 +33,6 @@ ifdef CONFIG_PPC64
>   calcs_ccflags := -mhard-float -maltivec
>   endif
>   
> -ifdef CONFIG_ARM64
> -calcs_rcflags := -mgeneral-regs-only
> -endif
> -
>   ifdef CONFIG_CC_IS_GCC
>   ifeq ($(call cc-ifversion, -lt, 0701, y), y)
>   IS_OLD_GCC = 1
> @@ -57,9 +53,6 @@ endif
>   CFLAGS_$(AMDDALPATH)/dc/calcs/dcn_calcs.o := $(calcs_ccflags)
>   CFLAGS_$(AMDDALPATH)/dc/calcs/dcn_calc_auto.o := $(calcs_ccflags)
>   CFLAGS_$(AMDDALPATH)/dc/calcs/dcn_calc_math.o := $(calcs_ccflags) -Wno-tautological-compare
> -CFLAGS_REMOVE_$(AMDDALPATH)/dc/calcs/dcn_calcs.o := $(calcs_rcflags)
> -CFLAGS_REMOVE_$(AMDDALPATH)/dc/calcs/dcn_calc_auto.o := $(calcs_rcflags)
> -CFLAGS_REMOVE_$(AMDDALPATH)/dc/calcs/dcn_calc_math.o := $(calcs_rcflags)
>   
>   BW_CALCS = dce_calcs.o bw_fixed.o custom_float.o
>   
> diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/Makefile b/drivers/gpu/drm/amd/display/dc/clk_mgr/Makefile
> index 1a495759a034..52b1ce775a1e 100644
> --- a/drivers/gpu/drm/amd/display/dc/clk_mgr/Makefile
> +++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/Makefile
> @@ -104,13 +104,6 @@ ifdef CONFIG_PPC64
>   CFLAGS_$(AMDDALPATH)/dc/clk_mgr/dcn21/rn_clk_mgr.o := $(call cc-option,-mno-gnu-attribute)
>   endif
>   
> -# prevent build errors:
> -# ...: '-mgeneral-regs-only' is incompatible with the use of floating-point types
> -# this file is unused on arm64, just like on ppc64
> -ifdef CONFIG_ARM64
> -CFLAGS_REMOVE_$(AMDDALPATH)/dc/clk_mgr/dcn21/rn_clk_mgr.o := -mgeneral-regs-only
> -endif
> -
>   AMD_DAL_CLK_MGR_DCN21 = $(addprefix $(AMDDALPATH)/dc/clk_mgr/dcn21/,$(CLK_MGR_DCN21))
>   
>   AMD_DISPLAY_FILES += $(AMD_DAL_CLK_MGR_DCN21)
> diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/Makefile b/drivers/gpu/drm/amd/display/dc/dcn10/Makefile
> index 733e6e6e43bd..62ad1a11bff9 100644
> --- a/drivers/gpu/drm/amd/display/dc/dcn10/Makefile
> +++ b/drivers/gpu/drm/amd/display/dc/dcn10/Makefile
> @@ -31,11 +31,4 @@ DCN10 = dcn10_init.o dcn10_resource.o dcn10_ipp.o dcn10_hw_sequencer.o \
>   
>   AMD_DAL_DCN10 = $(addprefix $(AMDDALPATH)/dc/dcn10/,$(DCN10))
>   
> -# fix:
> -# ...: '-mgeneral-regs-only' is incompatible with the use of floating-point types
> -# aarch64 does not support soft-float, so use hard-float and handle this in code
> -ifdef CONFIG_ARM64
> -CFLAGS_REMOVE_$(AMDDALPATH)/dc/dcn10/dcn10_resource.o := -mgeneral-regs-only
> -endif
> -
>   AMD_DISPLAY_FILES += $(AMD_DAL_DCN10)
> diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_resource.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_resource.c
> index a78712caf124..462d3d981ea5 100644
> --- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_resource.c
> +++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_resource.c
> @@ -1339,47 +1339,6 @@ static uint32_t read_pipe_fuses(struct dc_context *ctx)
>   	return value;
>   }
>   
> -/*
> - * Some architectures don't support soft-float (e.g. aarch64), on those
> - * this function has to be called with hardfloat enabled, make sure not
> - * to inline it so whatever fp stuff is done stays inside
> - */
> -static noinline void dcn10_resource_construct_fp(
> -	struct dc *dc)
> -{
> -	if (dc->ctx->dce_version == DCN_VERSION_1_01) {
> -		struct dcn_soc_bounding_box *dcn_soc = dc->dcn_soc;
> -		struct dcn_ip_params *dcn_ip = dc->dcn_ip;
> -		struct display_mode_lib *dml = &dc->dml;
> -
> -		dml->ip.max_num_dpp = 3;
> -		/* TODO how to handle 23.84? */
> -		dcn_soc->dram_clock_change_latency = 23;
> -		dcn_ip->max_num_dpp = 3;
> -	}
> -	if (ASICREV_IS_RV1_F0(dc->ctx->asic_id.hw_internal_rev)) {
> -		dc->dcn_soc->urgent_latency = 3;
> -		dc->debug.disable_dmcu = true;
> -		dc->dcn_soc->fabric_and_dram_bandwidth_vmax0p9 = 41.60f;
> -	}
> -
> -
> -	dc->dcn_soc->number_of_channels = dc->ctx->asic_id.vram_width / ddr4_dram_width;
> -	ASSERT(dc->dcn_soc->number_of_channels < 3);
> -	if (dc->dcn_soc->number_of_channels == 0)/*old sbios bug*/
> -		dc->dcn_soc->number_of_channels = 2;
> -
> -	if (dc->dcn_soc->number_of_channels == 1) {
> -		dc->dcn_soc->fabric_and_dram_bandwidth_vmax0p9 = 19.2f;
> -		dc->dcn_soc->fabric_and_dram_bandwidth_vnom0p8 = 17.066f;
> -		dc->dcn_soc->fabric_and_dram_bandwidth_vmid0p72 = 14.933f;
> -		dc->dcn_soc->fabric_and_dram_bandwidth_vmin0p65 = 12.8f;
> -		if (ASICREV_IS_RV1_F0(dc->ctx->asic_id.hw_internal_rev)) {
> -			dc->dcn_soc->fabric_and_dram_bandwidth_vmax0p9 = 20.80f;
> -		}
> -	}
> -}
> -
>   static bool dcn10_resource_construct(
>   	uint8_t num_virtual_links,
>   	struct dc *dc,
> @@ -1531,15 +1490,37 @@ static bool dcn10_resource_construct(
>   	memcpy(dc->dcn_ip, &dcn10_ip_defaults, sizeof(dcn10_ip_defaults));
>   	memcpy(dc->dcn_soc, &dcn10_soc_defaults, sizeof(dcn10_soc_defaults));
>   
> -#if defined(CONFIG_ARM64)
> -	/* Aarch64 does not support -msoft-float/-mfloat-abi=soft */
> -	DC_FP_START();
> -	dcn10_resource_construct_fp(dc);
> -	DC_FP_END();
> -#else
> -	/* Other architectures we build for build this with soft-float */
> -	dcn10_resource_construct_fp(dc);
> -#endif
> +	if (dc->ctx->dce_version == DCN_VERSION_1_01) {
> +		struct dcn_soc_bounding_box *dcn_soc = dc->dcn_soc;
> +		struct dcn_ip_params *dcn_ip = dc->dcn_ip;
> +		struct display_mode_lib *dml = &dc->dml;
> +
> +		dml->ip.max_num_dpp = 3;
> +		/* TODO how to handle 23.84? */
> +		dcn_soc->dram_clock_change_latency = 23;
> +		dcn_ip->max_num_dpp = 3;
> +	}
> +	if (ASICREV_IS_RV1_F0(dc->ctx->asic_id.hw_internal_rev)) {
> +		dc->dcn_soc->urgent_latency = 3;
> +		dc->debug.disable_dmcu = true;
> +		dc->dcn_soc->fabric_and_dram_bandwidth_vmax0p9 = 41.60f;
> +	}
> +
> +
> +	dc->dcn_soc->number_of_channels = dc->ctx->asic_id.vram_width / ddr4_dram_width;
> +	ASSERT(dc->dcn_soc->number_of_channels < 3);
> +	if (dc->dcn_soc->number_of_channels == 0)/*old sbios bug*/
> +		dc->dcn_soc->number_of_channels = 2;
> +
> +	if (dc->dcn_soc->number_of_channels == 1) {
> +		dc->dcn_soc->fabric_and_dram_bandwidth_vmax0p9 = 19.2f;
> +		dc->dcn_soc->fabric_and_dram_bandwidth_vnom0p8 = 17.066f;
> +		dc->dcn_soc->fabric_and_dram_bandwidth_vmid0p72 = 14.933f;
> +		dc->dcn_soc->fabric_and_dram_bandwidth_vmin0p65 = 12.8f;
> +		if (ASICREV_IS_RV1_F0(dc->ctx->asic_id.hw_internal_rev)) {
> +			dc->dcn_soc->fabric_and_dram_bandwidth_vmax0p9 = 20.80f;
> +		}
> +	}
>   
>   	pool->base.pp_smu = dcn10_pp_smu_create(ctx);
>   
> diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/Makefile b/drivers/gpu/drm/amd/display/dc/dcn20/Makefile
> index 624cb1341ef1..5fcaf78334ff 100644
> --- a/drivers/gpu/drm/amd/display/dc/dcn20/Makefile
> +++ b/drivers/gpu/drm/amd/display/dc/dcn20/Makefile
> @@ -17,10 +17,6 @@ ifdef CONFIG_PPC64
>   CFLAGS_$(AMDDALPATH)/dc/dcn20/dcn20_resource.o := -mhard-float -maltivec
>   endif
>   
> -ifdef CONFIG_ARM64
> -CFLAGS_REMOVE_$(AMDDALPATH)/dc/dcn20/dcn20_resource.o := -mgeneral-regs-only
> -endif
> -
>   ifdef CONFIG_CC_IS_GCC
>   ifeq ($(call cc-ifversion, -lt, 0701, y), y)
>   IS_OLD_GCC = 1
> diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/Makefile b/drivers/gpu/drm/amd/display/dc/dcn21/Makefile
> index 51a2f3d4c194..07684d3e375a 100644
> --- a/drivers/gpu/drm/amd/display/dc/dcn21/Makefile
> +++ b/drivers/gpu/drm/amd/display/dc/dcn21/Makefile
> @@ -13,10 +13,6 @@ ifdef CONFIG_PPC64
>   CFLAGS_$(AMDDALPATH)/dc/dcn21/dcn21_resource.o := -mhard-float -maltivec
>   endif
>   
> -ifdef CONFIG_ARM64
> -CFLAGS_REMOVE_$(AMDDALPATH)/dc/dcn21/dcn21_resource.o := -mgeneral-regs-only
> -endif
> -
>   ifdef CONFIG_CC_IS_GCC
>   ifeq ($(call cc-ifversion, -lt, 0701, y), y)
>   IS_OLD_GCC = 1
> diff --git a/drivers/gpu/drm/amd/display/dc/dml/Makefile b/drivers/gpu/drm/amd/display/dc/dml/Makefile
> index dbc7e2abe379..417331438c30 100644
> --- a/drivers/gpu/drm/amd/display/dc/dml/Makefile
> +++ b/drivers/gpu/drm/amd/display/dc/dml/Makefile
> @@ -33,10 +33,6 @@ ifdef CONFIG_PPC64
>   dml_ccflags := -mhard-float -maltivec
>   endif
>   
> -ifdef CONFIG_ARM64
> -dml_rcflags := -mgeneral-regs-only
> -endif
> -
>   ifdef CONFIG_CC_IS_GCC
>   ifeq ($(call cc-ifversion, -lt, 0701, y), y)
>   IS_OLD_GCC = 1
> @@ -64,13 +60,6 @@ CFLAGS_$(AMDDALPATH)/dc/dml/dcn20/display_mode_vba_20v2.o := $(dml_ccflags)
>   CFLAGS_$(AMDDALPATH)/dc/dml/dcn20/display_rq_dlg_calc_20v2.o := $(dml_ccflags)
>   CFLAGS_$(AMDDALPATH)/dc/dml/dcn21/display_mode_vba_21.o := $(dml_ccflags)
>   CFLAGS_$(AMDDALPATH)/dc/dml/dcn21/display_rq_dlg_calc_21.o := $(dml_ccflags)
> -CFLAGS_REMOVE_$(AMDDALPATH)/dc/dml/display_mode_vba.o := $(dml_rcflags)
> -CFLAGS_REMOVE_$(AMDDALPATH)/dc/dml/dcn20/display_mode_vba_20.o := $(dml_rcflags)
> -CFLAGS_REMOVE_$(AMDDALPATH)/dc/dml/dcn20/display_rq_dlg_calc_20.o := $(dml_rcflags)
> -CFLAGS_REMOVE_$(AMDDALPATH)/dc/dml/dcn20/display_mode_vba_20v2.o := $(dml_rcflags)
> -CFLAGS_REMOVE_$(AMDDALPATH)/dc/dml/dcn20/display_rq_dlg_calc_20v2.o := $(dml_rcflags)
> -CFLAGS_REMOVE_$(AMDDALPATH)/dc/dml/dcn21/display_mode_vba_21.o := $(dml_rcflags)
> -CFLAGS_REMOVE_$(AMDDALPATH)/dc/dml/dcn21/display_rq_dlg_calc_21.o := $(dml_rcflags)
>   endif
>   ifdef CONFIG_DRM_AMD_DC_DCN3_0
>   CFLAGS_$(AMDDALPATH)/dc/dml/dcn30/display_mode_vba_30.o := $(dml_ccflags) -Wframe-larger-than=2048
> @@ -78,8 +67,6 @@ CFLAGS_$(AMDDALPATH)/dc/dml/dcn30/display_rq_dlg_calc_30.o := $(dml_ccflags)
>   endif
>   CFLAGS_$(AMDDALPATH)/dc/dml/dml1_display_rq_dlg_calc.o := $(dml_ccflags)
>   CFLAGS_$(AMDDALPATH)/dc/dml/display_rq_dlg_helpers.o := $(dml_ccflags)
> -CFLAGS_REMOVE_$(AMDDALPATH)/dc/dml/dml1_display_rq_dlg_calc.o := $(dml_rcflags)
> -CFLAGS_REMOVE_$(AMDDALPATH)/dc/dml/display_rq_dlg_helpers.o := $(dml_rcflags)
>   
>   DML = display_mode_lib.o display_rq_dlg_helpers.o dml1_display_rq_dlg_calc.o \
>   
> diff --git a/drivers/gpu/drm/amd/display/dc/dsc/Makefile b/drivers/gpu/drm/amd/display/dc/dsc/Makefile
> index f2624a1156e5..ea29cf95d470 100644
> --- a/drivers/gpu/drm/amd/display/dc/dsc/Makefile
> +++ b/drivers/gpu/drm/amd/display/dc/dsc/Makefile
> @@ -10,10 +10,6 @@ ifdef CONFIG_PPC64
>   dsc_ccflags := -mhard-float -maltivec
>   endif
>   
> -ifdef CONFIG_ARM64
> -dsc_rcflags := -mgeneral-regs-only
> -endif
> -
>   ifdef CONFIG_CC_IS_GCC
>   ifeq ($(call cc-ifversion, -lt, 0701, y), y)
>   IS_OLD_GCC = 1
> @@ -32,7 +28,6 @@ endif
>   endif
>   
>   CFLAGS_$(AMDDALPATH)/dc/dsc/rc_calc.o := $(dsc_ccflags)
> -CFLAGS_REMOVE_$(AMDDALPATH)/dc/dsc/rc_calc.o := $(dsc_rcflags)
>   
>   DSC = dc_dsc.o rc_calc.o rc_calc_dpi.o
>   
> diff --git a/drivers/gpu/drm/amd/display/dc/os_types.h b/drivers/gpu/drm/amd/display/dc/os_types.h
> index 95cb56929e79..126c2f3a4dd3 100644
> --- a/drivers/gpu/drm/amd/display/dc/os_types.h
> +++ b/drivers/gpu/drm/amd/display/dc/os_types.h
> @@ -55,10 +55,6 @@
>   #include <asm/fpu/api.h>
>   #define DC_FP_START() kernel_fpu_begin()
>   #define DC_FP_END() kernel_fpu_end()
> -#elif defined(CONFIG_ARM64)
> -#include <asm/neon.h>
> -#define DC_FP_START() kernel_neon_begin()
> -#define DC_FP_END() kernel_neon_end()
>   #elif defined(CONFIG_PPC64)
>   #include <asm/switch_to.h>
>   #include <asm/cputable.h>
> 
