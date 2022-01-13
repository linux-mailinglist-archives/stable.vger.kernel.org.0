Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 881CF48D23D
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 07:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiAMGIO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 01:08:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:50407 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229996AbiAMGIM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jan 2022 01:08:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642054092; x=1673590092;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=r71KFQNgQyoK3rYVJnu3TbkRAYtioAkDNv2aQJXD4zw=;
  b=k8R/0RU3IYo+aGkeWxFXnCP5m8kX7pKdaPcXpAEQgENlSsOocD7Y5ade
   1nO0zNwxtYrOuZJniqntcE2hqsnZbok9hTkwP9OdMDVnCkabml6J+AjIh
   zqLgX9zXxIuLqyPrV9hSfCzkAqxqNWBWGA1/d0PTJ2Rc7EnZpC964ByuX
   BarqolSt20ryLB22HxznRTnmrvGWEjeYvWM53ynpzSAbSjam9dC2F93lX
   b2BJq+8fBBNAv9/gdT7jgPLGOfYRCNxLgJhCkBGArucbtHajFM2HM5vXf
   9M4k+3wTY7Fi9iGBhEx79WOI9G70aLoApiv8N5vrsIGUG1G+/kD+5NDqW
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10225"; a="231282559"
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; 
   d="scan'208";a="231282559"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 22:08:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; 
   d="scan'208";a="763167714"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga006.fm.intel.com with ESMTP; 12 Jan 2022 22:08:11 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 12 Jan 2022 22:08:10 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 12 Jan 2022 22:08:10 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 12 Jan 2022 22:08:10 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 12 Jan 2022 22:08:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fmpZ7QVAx73UBUkZQC5MYt/IDnEMEQr02/S22R4fVNtL4+oHf0e1qEXHAANwK2Uw2Wd+DQH3MYzKiJ+jbeV2gU5p0tU8WgVcZiOAmjpHI1IfVN0F3QZ5mrhmdXA7J9bZTXuU6tGDUZaokQ+X8UQHQGmE1YP5A3j4iAx2x/W8ezl8XHixY1O6Qv1V4CgJ1S8nfDccXsZ2sbix0SOvY3CHnHxIPBK4YjAXp2Wb4QT4GG4LzUGI1qkUi2fKrwqTQNLY+UM10cVuI1rd8OcZioz4bfpFjELt+/Ft1efU7Xmy0NMykCmqdcE8mDO9EtV0s2RZXGBdXTSw5da+tOFLJWHYJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b2Bxx5u09Me0iigiHmqs9Qzf8Mfu3IP6AyzSSwPYobs=;
 b=kxSJ4iDOUTdPUOgDD2FJMUKl8qTDFyd3KkzP8I9868Fc1e9jbK3l3JPdWVtHaoF0jzweBRvByUGQJS9rIDU+dQblrgqv6qRDnt7VgeUvOcupNHESgPJ+A3XKXEuDxPkA4SSYVbFY7ID0h7L4FJwIkWApkS/PxTOH+nDnKVM2vzMBCMN/wMk8er8V8nxJMs2e7kkmM7hDwRnDykg2dMMU5bQSUc8BhBkHoetzUaMLjaaIY7Q7Npyo6IegSJR4eqPv7F//v1TkpaxcCLbYKzFFw8Oj60siPKswmStlvvIv+Q6d0WjJiaANdOTlOGUuBsa6TdSGWbyWeAWhAsnjpw6nsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN0PR11MB5744.namprd11.prod.outlook.com (2603:10b6:408:166::16)
 by BY5PR11MB4167.namprd11.prod.outlook.com (2603:10b6:a03:185::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Thu, 13 Jan
 2022 06:08:07 +0000
Received: from BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::a113:192a:3201:1e0]) by BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::a113:192a:3201:1e0%9]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 06:08:07 +0000
Message-ID: <cd26205a-8551-194f-58df-05f89cd4f049@intel.com>
Date:   Wed, 12 Jan 2022 22:08:02 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.4.1
Subject: Re: [PATCH v3] x86/sgx: Free backing memory after faulting the
 enclave page
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>, <linux-sgx@vger.kernel.org>
CC:     Dave Hansen <dave.hansen@linux.intel.com>,
        <stable@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <seanjc@google.com>
References: <20220108140510.76583-1-jarkko@kernel.org>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20220108140510.76583-1-jarkko@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR14CA0048.namprd14.prod.outlook.com
 (2603:10b6:300:12b::34) To BN0PR11MB5744.namprd11.prod.outlook.com
 (2603:10b6:408:166::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ca2a19b-681c-4b99-4a5f-08d9d65b116a
X-MS-TrafficTypeDiagnostic: BY5PR11MB4167:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BY5PR11MB41670D18A8AC7EE9070FAD74F8539@BY5PR11MB4167.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:227;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l3bL7KUlF5XsUiYTPNZiy5b2b8DP9x3xEx/aF2gP9BS6rX9jx7h0Xo4zJxstNOPPsMkYlSJk+op/vbVh6Bvs0GD8ihAsqR0/sdlwSnZnOv+iDs65WKICtYtwrT3AknzXrAKCfQFozyh4jzl8E2Iri19oWHL5GcrTqO0wSzG7SX48/wF5UAEkmwk2Sen9dkWpfAGe9D3hgAnVdUmBx28HMM9sCasylfexSA8ijcSexpdV8b+8nOLRzLvzsjuR87VfQgl4g6p01xfv+5mahxxF9ZGY2RBRXrf0M6qyWxw+R8Ne/fbsdE7kmZmckkahGyHnq+46hxOAxCGABxJI/VK+7aW3PpxI0w/3QkrUAKbbHVRvtyjtt2+luU1aVLrUqZ6xMYlwkRe3tEKGNDlREdpo+prEswSmkWfUQjSsepfcsr005DIgQSYFCJmb+KXtZrb6bsvjbDje9v25LL1JijpNoVa+3cmn9UzGT20RE7wxRlaOhtA5dOLhHuUrjWU6O2vSLdw0hjKHspEBxsGTefpiCFlyGAmtY/T1hDnYAQIl8wZHRfLV1I1dnIfmk1w6potm8OGJ3WQIkedeNUlqq0lwkJ2D+Ple4Kcl/W0lLajHfmHXOmd9t1/7zQuRQuvVPTBME5S9hQKm7hk4nNJyTk3FmHeGJIeOhMRA0HRcHONBKWG17OisvAKw/PcA+kum421nYwJcg8UTBcCN+BvPgTbnwP8FxC2tvyFu4M/nUtLvrbUCyqK9+HWAq7CLEfffv/Lb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(508600001)(66556008)(86362001)(6666004)(54906003)(5660300002)(26005)(4326008)(66476007)(8676002)(8936002)(31686004)(316002)(66946007)(31696002)(36756003)(45080400002)(82960400001)(7416002)(6506007)(2616005)(6512007)(53546011)(38100700002)(6486002)(44832011)(186003)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ekN5NDFRYzRRSDZiR3dxMlVEdmp2MnF2dGVvQ045YkNmNmJJMktXamdkVC9F?=
 =?utf-8?B?aFUyNDRtY0FMZW12Nkp6RXpoSVR3VkF6ZjNMRlRrcmZidVljOGNzOE1TSTcy?=
 =?utf-8?B?UkZUcWtEWjFEL1dtb3FtSWdwNUs5d3lCZmhnZlRac0hLVTZ6Z0ZlYTB6L1I1?=
 =?utf-8?B?aE5kaUhraENvYU1jSnIwaUdyMGNha05QNWV0LzBLWC9pWUFyaGVDamIyTFdw?=
 =?utf-8?B?K1FOenhBTGNxNnRsalpLVE5vY1RZRXVhcndJazVTYnNUMjYxM0N3aC9ZdWk3?=
 =?utf-8?B?MEpKWFI2Rkg5SjA1b2o3RzdLZ293cS9hZzRIUXdJc2V6SUdmNmowb0kyRkV2?=
 =?utf-8?B?WVJUcTVDN0d6aEJHbGEveCtsZjllU3k4MmVwU3l6RGdwcmM1d3YySEdhUzBZ?=
 =?utf-8?B?RjNKeGUwam5wS1l5ODc1c2ZNVTFkbWVBcDBRRmpuaU5xZjMvbDFScjZtdVU1?=
 =?utf-8?B?WU1LNzlsU1d1NW1kQ01KV28wSmJFZ1RpRFo1eU05dzFNOEZXcVN0RVloVGQv?=
 =?utf-8?B?SENCd0s2YW9ZTmNLNlp4ektMUkVwdzg3V0JEeGtUOTFaNVBTdmpHUmxDZG03?=
 =?utf-8?B?aVBiL2F2VFB5ZnlVSmJCMWFSaXFhSjI3b1IrM1MyY0FWZndleExoZk9COFhE?=
 =?utf-8?B?SmZGSHNCWllqQUFua2p1SEk5U1pFQUZXNnJpcE80YjlxMjI3Z0ZzdnFaSi9k?=
 =?utf-8?B?VXJqMlZXNDk0OGc5ZnpxWWJXamFVekdMZmNpbXR3R2tLaVdlNkpsdm12UDds?=
 =?utf-8?B?emZzdjhOR2d4ZUhVR3dVZzF3NGtudm11YU9XOHBGYnRaTXdONDNyN1F0M3JB?=
 =?utf-8?B?RG9UZzRwa2pyclBKM1VkejJTeW5YdGNHeVNvVzNnSlhGNXZ6czZRQnZSSDYx?=
 =?utf-8?B?STdxSXdDVkxkK3Q3dzlleU04Nk9NOFBEbWNvc0o5NU5iODc4U2JGOXNvMkEr?=
 =?utf-8?B?cS9yR1ZaYjF1MTJtNWhBWFEvQVJhUDhMaEE5ZzNmQmkwcG1sWHl0R3NHL0Uv?=
 =?utf-8?B?eUE0OFZzVERtV0xJa1ZjcDFGS3lZRGhCZERDNWd5ZldMcG5lMTJOOXMvQWZS?=
 =?utf-8?B?bXBqSFptL1dUamk0SXRtdGxvSG5JajdaWldCd1B5TVRYUm1BSTNTZ0o1Y1Nj?=
 =?utf-8?B?K2JEMEp6ZmJOK01SdWc4MVhlSTRZQTBsNXljU2dhdzBUYjF2WmcwUVorMk5J?=
 =?utf-8?B?a0c4ZmVIYkpZMFlpYkNheXdzSTRHYUNwWFBEdUdKNFVoZUxnNXlNeWdPVDJI?=
 =?utf-8?B?cGpMcVViWXZvTDNCQm1FUDROWURwRWdsTzVHWDlBTlp6Rlc4T3Z4SzE4allF?=
 =?utf-8?B?R0dtTGxzNDRYejR0eUYzc0JiWVRXMzQrRWV6cmI5ZVNUZ2ozcmo2K2xQeWlG?=
 =?utf-8?B?UXlUSU1TeVNJTWxadzZ3VGdGVHBwdDFnS2RBd0tCT2JvNUxZWCs2aFRIWWFt?=
 =?utf-8?B?NDNDdFozRkM2ZWxmeU9JQXJtZDZ0NTFTSnJjUkFKaGVXelpWYnREWjRWcDM2?=
 =?utf-8?B?Y0ZNcXhoQkpROXIxRk5JNkV3ck9qTmk4SS9KcWI3dC9KYmU1WDZDOEFxV1JS?=
 =?utf-8?B?aUNFZzJma3Jka3p6NW9yd0t2ejdiREd5aTMrWDN5OTI1MW10NmJGWTkzMklT?=
 =?utf-8?B?RzNEZk9SSjA0OHI5SDB6RUIxUkxCTDZWSVpkK3VwWUxWeUw0WU5wUlIrSnFY?=
 =?utf-8?B?Z1NMQkZIVWY2aGt2bzFmZ2FvbmgxcWVTSWFaWlV1VldQQnB6VExPTFpHeHdl?=
 =?utf-8?B?TFRKVVUrblBIUUMzOG1udnF3Y3dJNnVOZHZVRUxGbEZpSWhqMFh4QmV1Slo5?=
 =?utf-8?B?N2RsZTcyRlduREhwYXhzTC9IYnhNdXRCNklmNTdYeWdkZWhzanV2UlgycWNO?=
 =?utf-8?B?WWRlMUtYWUF1VU1qY3NmM2E1TXBJN2pwNUs5cXJqS0ZQMS9iVlJ0a2Z2SFli?=
 =?utf-8?B?THRsUEhjYWdUbEd2VnpDaFNodGJWOEFZZzhBNVMwNHhmU3hOdkFsQm4wNmVQ?=
 =?utf-8?B?ZmhMaUwrWS82UWpMaUEwNjViaTc1NE9uVHFVaVVBbndML2NvUS8rL2hmTVZM?=
 =?utf-8?B?Q2xzOXhCUExWYUtPT1QyQ05Mcy9uVFpDVmtpb2xZRGpaRmlZWlVIdWk5RTlo?=
 =?utf-8?B?Z0svaWxnSHUzOGttWmN5ODFuMlJUQmFFZlJEKzlQUDM1VlRPVWdjL1ZYdUls?=
 =?utf-8?B?OUxodkorcUFGVkROTmtaRVZQL3hlY0N0bnlIMWxNeEJmWVFWeGR1V3JtVjM3?=
 =?utf-8?Q?K0YSeuAxM90YGGIJyAIleCbOgeX2oSMs4QO1fXdtKU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ca2a19b-681c-4b99-4a5f-08d9d65b116a
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 06:08:07.5619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zlDyyp0cBcpBdv/mgF7KOreZcHZ18YAIklZl0P2Vn95mI82e8S3MUGZM4Hs3kyT5g8UOy+azM9j9K8aHFUWwHUhOlYybSXQD9PzcKfbx6Ao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4167
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jarkko,

On 1/8/2022 6:05 AM, Jarkko Sakkinen wrote:
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
> ---
> v3:
> * Resend.
> v2:
> * Rewrite commit message as proposed by Dave.
> * Truncate PCMD pages (Dave).
> ---
>  arch/x86/kernel/cpu/sgx/encl.c | 48 +++++++++++++++++++++++++++++++---
>  1 file changed, 44 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index 001808e3901c..ea43c10e5458 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -12,6 +12,27 @@
>  #include "encls.h"
>  #include "sgx.h"
>  
> +
> +/*
> + * Get the page number of the page in the backing storage, which stores the PCMD
> + * of the enclave page in the given page index.  PCMD pages are located after
> + * the backing storage for the visible enclave pages and SECS.
> + */
> +static inline pgoff_t sgx_encl_get_backing_pcmd_nr(struct sgx_encl *encl, pgoff_t index)
> +{
> +	return PFN_DOWN(encl->size) + 1 + (index / sizeof(struct sgx_pcmd));
> +}
> +
> +/*
> + * Free a page from the backing storage in the given page index.
> + */
> +static inline void sgx_encl_truncate_backing_page(struct sgx_encl *encl, pgoff_t index)
> +{
> +	struct inode *inode = file_inode(encl->backing);
> +
> +	shmem_truncate_range(inode, PFN_PHYS(index), PFN_PHYS(index) + PAGE_SIZE - 1);
> +}
> +
>  /*
>   * ELDU: Load an EPC page as unblocked. For more info, see "OS Management of EPC
>   * Pages" in the SDM.
> @@ -24,7 +45,10 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
>  	struct sgx_encl *encl = encl_page->encl;
>  	struct sgx_pageinfo pginfo;
>  	struct sgx_backing b;
> +	bool pcmd_page_empty;
>  	pgoff_t page_index;
> +	pgoff_t pcmd_index;
> +	u8 *pcmd_page;
>  	int ret;
>  
>  	if (secs_page)
> @@ -38,8 +62,8 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
>  
>  	pginfo.addr = encl_page->desc & PAGE_MASK;
>  	pginfo.contents = (unsigned long)kmap_atomic(b.contents);
> -	pginfo.metadata = (unsigned long)kmap_atomic(b.pcmd) +
> -			  b.pcmd_offset;
> +	pcmd_page = kmap_atomic(b.pcmd);
> +	pginfo.metadata = (unsigned long)pcmd_page + b.pcmd_offset;
>  
>  	if (secs_page)
>  		pginfo.secs = (u64)sgx_get_epc_virt_addr(secs_page);
> @@ -55,11 +79,27 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
>  		ret = -EFAULT;
>  	}
>  
> -	kunmap_atomic((void *)(unsigned long)(pginfo.metadata - b.pcmd_offset));
> +	memset(pcmd_page + b.pcmd_offset, 0, sizeof(struct sgx_pcmd));
> +
> +	/*
> +	 * The area for the PCMD in the page was zeroed above.  Check if the
> +	 * whole page is now empty meaning that all PCMD's have been zeroed:
> +	 */
> +	pcmd_page_empty = !memchr_inv(pcmd_page, 0, PAGE_SIZE);
> +
> +	kunmap_atomic(pcmd_page);
>  	kunmap_atomic((void *)(unsigned long)pginfo.contents);
>  
>  	sgx_encl_put_backing(&b, false);
>  
> +	/* Free the backing memory. */
> +	sgx_encl_truncate_backing_page(encl, page_index);
> +
> +	if (pcmd_page_empty) {
> +		pcmd_index = sgx_encl_get_backing_pcmd_nr(encl, page_index);
> +		sgx_encl_truncate_backing_page(encl, pcmd_index);
> +	}
> +
>  	return ret;
>  }
>  
> @@ -577,7 +617,7 @@ static struct page *sgx_encl_get_backing_page(struct sgx_encl *encl,
>  int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
>  			 struct sgx_backing *backing)
>  {
> -	pgoff_t pcmd_index = PFN_DOWN(encl->size) + 1 + (page_index >> 5);
> +	pgoff_t pcmd_index = sgx_encl_get_backing_pcmd_nr(encl, page_index);
>  	struct page *contents;
>  	struct page *pcmd;
>  

I applied this patch on top of commit 2056e2989bf4 ("x86/sgx: Fix NULL pointer
dereference on non-SGX systems") found on branch x86/sgx of the tip repo.

When I run the SGX selftests the new oversubscription test case is failing with
the error below:
./test_sgx
TAP version 13
1..6
# Starting 6 tests from 2 test cases.
#  RUN           enclave.unclobbered_vdso ...
#            OK  enclave.unclobbered_vdso
ok 1 enclave.unclobbered_vdso
#  RUN           enclave.unclobbered_vdso_oversubscribed ...
# main.c:330:unclobbered_vdso_oversubscribed:Expected (&self->run)->function (2) == EEXIT (4)
# main.c:330:unclobbered_vdso_oversubscribed:0x0e 0x06 0x00007f6000000fff
# main.c:338:unclobbered_vdso_oversubscribed:Expected get_op.value (0) == MAGIC (1234605616436508552)
# main.c:339:unclobbered_vdso_oversubscribed:Expected (&self->run)->function (2) == EEXIT (4)
# main.c:339:unclobbered_vdso_oversubscribed:0x0e 0x06 0x00007f6000000fff
# unclobbered_vdso_oversubscribed: Test failed at step #2
#          FAIL  enclave.unclobbered_vdso_oversubscribed
not ok 2 enclave.unclobbered_vdso_oversubscribed
#  RUN           enclave.clobbered_vdso ...
#            OK  enclave.clobbered_vdso
ok 3 enclave.clobbered_vdso
#  RUN           enclave.clobbered_vdso_and_user_function ...
#            OK  enclave.clobbered_vdso_and_user_function
ok 4 enclave.clobbered_vdso_and_user_function
#  RUN           enclave.tcs_entry ...
#            OK  enclave.tcs_entry
ok 5 enclave.tcs_entry
#  RUN           enclave.pte_permissions ...
#            OK  enclave.pte_permissions

The kernel logs also contain a splat that I have not encountered before:

------------[ cut here ]------------
ELDU returned 9 (0x9)
WARNING: CPU: 6 PID: 2470 at arch/x86/kernel/cpu/sgx/encl.c:77 sgx_encl_eldu+0x37c/0x3f0
Modules linked in: intel_rapl_msr intel_rapl_common i10nm_edac x86_pkg_temp_thermal ipmi_ssif coretemp kvm_intel kvm cmdlinepart intel_spi_pci intel_spi spi_nor ipmi_si mei_me ipmi_devintf input_leds irqbypass mtd mei ioatdma intel_pch_thermal wmi ipmi_msghandler acpi_power_meter iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi btrfs blake2b_generic zstd_compress raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 raid0 multipath linear ixgbe crct10dif_pclmul crc32_pclmul ghash_clmulni_intel hid_generic aesni_intel crypto_simd xfrm_algo usbhid cryptd ast dca hid mdio drm_vram_helper drm_ttm_helper
CPU: 6 PID: 2470 Comm: test_sgx Not tainted 5.16.0-rc1+ #24
Hardware name: Intel Corporation 
RIP: 0010:sgx_encl_eldu+0x37c/0x3f0
Code: 89 c2 48 c7 c6 e1 e9 3e 9b 48 c7 c7 e6 e9 3e 9b 44 89 95 54 ff ff ff 4c 89 85 58 ff ff ff c6 05 fc bd dd 01 01 e8 54 88 03 00 <0f> 0b 44 8b 95 54 ff ff ff 4c 8b 85 58 ff ff ff e9 46 fe ff ff 48
<snip>
Call Trace:
<TASK>
sgx_encl_load_page+0x82/0xc0
? sgx_encl_load_page+0x82/0xc0
sgx_vma_fault+0x40/0xe0
__do_fault+0x32/0x110
__handle_mm_fault+0xf84/0x1510
handle_mm_fault+0x13e/0x3f0
do_user_addr_fault+0x210/0x660
? rcu_read_lock_sched_held+0x4f/0x80
exc_page_fault+0x7b/0x270
? asm_exc_page_fault+0x8/0x30
asm_exc_page_fault+0x1e/0x30
RIP: 0033:0x7ffe7fdc3dba
<snip>

I ran the test on two systems and in both cases the test failed accompanied by
the kernel splat.

Reinette
