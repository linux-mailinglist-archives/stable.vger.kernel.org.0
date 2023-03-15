Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 032176BB4E8
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 14:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbjCONmh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 09:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbjCONmf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 09:42:35 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2116.outbound.protection.outlook.com [40.107.21.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A00F87A3A
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 06:42:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gps+ie/glwhwEUeUibbCRoGsHiuDXfVaJStHYQy3RSCA9Ak9mPglUQwmD09n0tDDFj3bH99jbwlYL6CSU4kE0scOsG8L1lSSscgzRr7V+H7Vb9/UbX12IgfPDrKIyLjWiHR2JlGULIhEm8c0wPxLYGazbIA5/WTBHQ/IfqxrCDfT8h7sgsoQL4LpHBWKXm4rolBPJKLIMzOdrq0sqCo5ScJD2ZCvh75Q0nDi20HQVGkTDeTEP5wnZDCBORUjM/sfyEIeyK/Ih4AmiyFIy0+GD4ih0U2F9R6K4Ie7UJBvU1HXXk5zjogX5V77xhG+F+pkNdPak0aHhCfwqiIEdOU/BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YdmYK0NZjVgrzspHcrkJkj8mIasZTgCOMYHreTp8b6E=;
 b=FzUgtP7v7nWU27M4+hcQIyX8tkGWYnq7R85YDbuycFlj6lMW7eO+zZeNSNHiJzcuc9+H7TSSLfSslKq/EtAXR0R7JITtjAU9NNic7MrdXylbwUW3gbiECiWMY2+lO8vTvEKNR4yj+KtBbRvVsTQP1KIdZ4AJ6EJE4lmhmb2S6O/TfqabXFqe9xMK7nG59YxKnfoLlPPkKJ5EESZX2UjBPd7vY+CGSKDxXe7zNq8YLywv1JiBKlqoX6uGmKyUE7nVDR6QETVe5tEXdckhTapr3r8orjNmbSp5mR9cTr//BDCea11qkXJ4kI1ucf33U5SgoToF3knLDwo9vrHhOEBYDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YdmYK0NZjVgrzspHcrkJkj8mIasZTgCOMYHreTp8b6E=;
 b=N807SfDKqNvQlmpr1HreJfKri/rsoyY1/06dq84ztHu+D9KdsOS4aqI0lFdQ1HOJosWDO/1L29GOgzVabS6ILq1HNLWbTDv4nA2QEaWFWsicVF+NxSc6yErbVNW0dRbj3obpdOtcsj5ryElTHeadAKrXjeCXyIGE5roGV76TmlIzXjeSNAV7Tz/HhMwfOK0H46WUBfPbZs4d2ooMsmE2etg1wmLvPaozsr7gQ/VgGfpxQZ5EZcrz3oGCA+2z+9hI4ouYvQ8AZajdcx2AplNx/pDkCnjFh5Bftf+iwhrpR7p6HiRjo2StyqkcnQ4gKXsKcex14MJqX1MUpfideEFpRg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uipath.com;
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com (2603:10a6:803:b1::28)
 by DU0PR02MB9989.eurprd02.prod.outlook.com (2603:10a6:10:447::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 13:42:28 +0000
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::224e:d6bd:a174:9605]) by VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::224e:d6bd:a174:9605%6]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 13:42:28 +0000
Message-ID: <b8668d09-cfa6-5d94-1e84-f2cdff9b207e@uipath.com>
Date:   Wed, 15 Mar 2023 15:41:49 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.10.y v2 2/3] KVM: VMX: Introduce
 vmx_msr_bitmap_l01_changed() helper
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
References: <20230315090528.4180-1-alexandru.matei@uipath.com>
 <20230315090528.4180-3-alexandru.matei@uipath.com>
Content-Language: en-US
From:   Alexandru Matei <alexandru.matei@uipath.com>
In-Reply-To: <20230315090528.4180-3-alexandru.matei@uipath.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR09CA0107.eurprd09.prod.outlook.com
 (2603:10a6:803:78::30) To VI1PR02MB4527.eurprd02.prod.outlook.com
 (2603:10a6:803:b1::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR02MB4527:EE_|DU0PR02MB9989:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cd116a1-461a-4617-3a11-08db255b1e43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FcFa5tlICZmgGh25zxHFjQCrhcwHlXpe2NHhChVdp2JyePqKxJSbw3o0cAPA5DjqSbEz4VBMGsGTF4TXdh9ASEPiKshHAJ9EoSi7tLmG8Zo5eqwiTB0LLmYf4rcEYjObuLMKHS9l6O58ReCCR1Mmj/nUgZ+y13MwqWZ77I7NWMMVA7viDq8epeqeGDUxxHmPkVleVrFzL05+ZcceRm3Cj7/6vwOWOpbrJfSETeabw0C/g0tCv1sVWvQSqQUwXt7GiQe+xqlfafteSqR8P27W20doWo6yf/KEOAC5A+F4TjjYr9+WsJx8TNCzdthAnY9icVZhK45BV21vJlVA+mErRPnLehr2prIQXCvzOCrKdVrX5B/MxrjUKgVyE3cLSIdR1+Yw87vlkaa+lPpfP1Jb0gjGO7kxrn2CUzeubZAtrSEafJoj+TsVtLPZXeuXcfwebk0v7+3GFyLn0bXGrd4WbCUxxbCRwjfiztRZGGV9JW9o31dOGLyv8n7loF/8NQ45LhourNJq4kZaikuorV6YpWqCmIDw3Ar7a5JY9qJlngwIMM0k0eCfQs2GvlSN1jH0dyVeb0YiGkki+khtn2Hy3jTZfosr8zyxZJQGJXmH6O3HOcOJXSTWF/ll1O5qtoBt6Mp0rFS6Um6zdr1DTz8v22Gx0JUMcnmmzEnWbnQov3ZCdyCQtyU0wFoz3PhK8R2kl6OBZhBwSrJyNXjjN8tCs8oStNTr6Nukkh/JvzsOOEs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(346002)(39860400002)(376002)(396003)(451199018)(6486002)(31686004)(2906002)(2616005)(6666004)(107886003)(44832011)(36756003)(6506007)(478600001)(53546011)(6512007)(5660300002)(8936002)(54906003)(316002)(186003)(26005)(31696002)(41300700001)(83380400001)(86362001)(4326008)(6916009)(8676002)(66476007)(66946007)(66556008)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K2Q1bGZyY2ZHV2Y1eTFhUFJRVmZUWDg2bUZRaDRFMjNIQndHT3dYUXllREVU?=
 =?utf-8?B?NEtlYis2VDhld05XeDI1TDZMTTNlYVQ3S1RIRnU3czNXdXZNZ09oK3BwTXZt?=
 =?utf-8?B?TnRvVUJTV1hUQnlXZFVIWG8vU0xQRm5UcDVvK1dMLzVlbjdUMEFCVjY4TzB0?=
 =?utf-8?B?UzBLYTRwV2pPR2djcGhTS0NKdWNMbEhtZFdjZGpIbXFzay80eURqUDdCeTBx?=
 =?utf-8?B?Zlp5M3NKWkJ0SDBjeWhDSjcvd0JDWXJhMEpWQkRhN2hvbTNSNzVzV3YzM1Uy?=
 =?utf-8?B?aE1WMjhqRklWYituQ2p4K21QNXc0TFMvU0YzS1pUcWsrU0pvYitQMG4zcDhu?=
 =?utf-8?B?RnVaalRNY3JCdmZ3VlQrMmZoSDZXMEV3OVBwSjU4WXdXU2FrL2ViUXdnWE9K?=
 =?utf-8?B?ckdNVUozdE15dk0zeUlEM1FYOXNUbFhSM1BYVlBtcXFDNG1RYW90cExUVUNL?=
 =?utf-8?B?STNPaWkxYm1MVnhvSTY1bzFzVU5VcjgvRDFrMk1UeDU1R1dYY0xlbWlLcndy?=
 =?utf-8?B?bjNkWXRmNGNvc3FtbVFpOCswWTNzU1hUZUo2ZnNDM0ZlOE1JaEpxWExhTzlm?=
 =?utf-8?B?MTBmVGdmWE8xT3ZlOFRzd3Y2WW1sc0hWbFZhS3pxSko2aUhBTlB3eXI5ZUVG?=
 =?utf-8?B?Szk3NVE0Uy9UQ3REbmVnUExsWDlwLzJDVW9YUmVoTWJ5VlBjYk8vRmdBdGto?=
 =?utf-8?B?T084NFBsekwzN21tSml6NDhiT0dkK0xrTndXZ2ZkR3FzMURkbFlVaFZXOGJv?=
 =?utf-8?B?TERrRUNKYUxienFqcHBrdWpLVW1hUXBvQjIzSkNKMGNDL3VCK1dZcmJ3ci9V?=
 =?utf-8?B?cE5GR2lxdnZsQVhjd092c1BaUTlBVVpwZ0VlRzB6TkFMWGZsTUhyaldNR3l3?=
 =?utf-8?B?Zm5RUjNKeGJQY3dRMnBiQXhkYnJhMVkrK0tETHpVVkp2c0VkRTlXcVdWRG0v?=
 =?utf-8?B?a0M4VElVeUVmWm92RGdoTDYrWk1XMzBabVJidzJRMW5oNnJTMzVNWkljVnZz?=
 =?utf-8?B?d1NoZzFISmkxRmdIMG9oWXM3SlhsQjBiMDcveEZBRXFhVUUyR2JBcit3REZ3?=
 =?utf-8?B?UDdMdmlNMFZ5V1E3bUpVSU00MHo1UURidUg4QjByS3pKdWRPemJNT29NYTdM?=
 =?utf-8?B?aHI2d0szejA4TmUvT3Z6ZGxuaWEyQ0NpWHpmM0MvMXFkUEVjeTN5cHVuYUdx?=
 =?utf-8?B?Q0VwMWdFcy95eG5GUzI1bG9DemYwVldrOStPc0xqdWtjV3NTQi96eVFkQ3NJ?=
 =?utf-8?B?VmU0Y3JIOE1GK0JBaTBNM21HTFRZVGZWM3d5dmNPbWlwUzAxN3VPTFVWWDlJ?=
 =?utf-8?B?OVJHN2RaNTdVMnlyNXozd0UyL1A5TTlZRFpxandDYWd1T0FGN3d3YzdVaVFi?=
 =?utf-8?B?ZElOR0JnSHkwOWp3Wm1tdEVRcU0yeFluc1JGMUNDNEdBcnEzSmcvVEE4SWVD?=
 =?utf-8?B?MWdNUnlwQmhPUnhib3ZOdGhneDZydmpYaFVVN1dLMHc4UitqNER2ZnFTZ010?=
 =?utf-8?B?OVNHb3VwWGhIVHJHeWFMWldCbWhzSFZlT1FhTzFReUFLZWV1OExvRXAzOFVL?=
 =?utf-8?B?d05xSHFGeEFyYllWSnM4VWpQNjZxVjlyRjFHUDQyMDhQcmRodnBXcStkOFh6?=
 =?utf-8?B?emEybVFrM0VZbUhJNGJXSkRQMC9wZHYzVG0xMjZVVndSWFNSU1c5U3pIOGgz?=
 =?utf-8?B?R0dWQ0hrelQyZDE2b095TFZGQ1FRMTZhTk5zVnloY3RmT3dvUkFSZ2ozWEc2?=
 =?utf-8?B?YWNMdnV6MjRIWmdRckhYbzRvS3JBSnJTSDNLRFg3M21xK1ZsaGtpK1A3NmtV?=
 =?utf-8?B?S0RjUFJkRDlDSm9jMFhHQzNYeFNKeVMrY2NHcWcyY1N5aSsvaThDSHFMWGs5?=
 =?utf-8?B?T3N3dGZzUERhcWNHdHlWc2hlSTdmVjkzNm9jN0VhZ0FFWWZhd25FYWc3WTZt?=
 =?utf-8?B?NXdVRVdUYjJqdjBhVVEvWnp0YXZwRWRTNUhiODNxOG5POWNlTjl4RTF3bDQ2?=
 =?utf-8?B?N3NRR2dQOTBqTi9sdUo4UW0zVmNxbU9xRVVoR0RCOGhLSUtDT0ZEaVQvelZJ?=
 =?utf-8?B?Tm9LQTR1V1BQVEpwOFFqUllHMTNLTGRjNkN0Q0lCcUQ3MVVvZFBRdVFSR0hP?=
 =?utf-8?B?U3d5MFE1NlQ2Sm1aRW5WZSs0dmRFZ1VUekh3TFY4emZnNGN2YmFXWUt6aGk5?=
 =?utf-8?B?dmc9PQ==?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cd116a1-461a-4617-3a11-08db255b1e43
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 13:42:28.6155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tX7cSDARcN58aDuCJdEqjn/JxDlHxs9Euhv5XpguxCKKPT7j+/2in7BrV5QBpcqbmhgt8jopXNEMysNRid0GZTy7Apuk2sHnyrISNWLa7zs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR02MB9989
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

This patch appeared in the queue without the last Signed-off-by line.

Alex

On 3/15/2023 11:05 AM, Alexandru Matei wrote:
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> commit b84155c38076b36d625043a06a2f1c90bde62903 upstream.
> 
> In preparation to enabling 'Enlightened MSR Bitmap' feature for Hyper-V
> guests move MSR bitmap update tracking to a dedicated helper.
> 
> Note: vmx_msr_bitmap_l01_changed() is called when MSR bitmap might be
> updated. KVM doesn't check if the bit we're trying to set is already set
> (or the bit it's trying to clear is already cleared). Such situations
> should not be common and a few false positives should not be a problem.
> 
> No functional change intended.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Message-Id: <20211129094704.326635-3-vkuznets@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Alexandru Matei <alexandru.matei@uipath.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index eefd6387a99d..ee05c0e1cb2a 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3785,6 +3785,17 @@ static void vmx_set_msr_bitmap_write(ulong *msr_bitmap, u32 msr)
>  		__set_bit(msr & 0x1fff, msr_bitmap + 0xc00 / f);
>  }
>  
> +static void vmx_msr_bitmap_l01_changed(struct vcpu_vmx *vmx)
> +{
> +	/*
> +	 * When KVM is a nested hypervisor on top of Hyper-V and uses
> +	 * 'Enlightened MSR Bitmap' feature L0 needs to know that MSR
> +	 * bitmap has changed.
> +	 */
> +	if (static_branch_unlikely(&enable_evmcs))
> +		evmcs_touch_msr_bitmap();
> +}
> +
>  static __always_inline void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu,
>  							  u32 msr, int type)
>  {
> @@ -3794,8 +3805,7 @@ static __always_inline void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu,
>  	if (!cpu_has_vmx_msr_bitmap())
>  		return;
>  
> -	if (static_branch_unlikely(&enable_evmcs))
> -		evmcs_touch_msr_bitmap();
> +	vmx_msr_bitmap_l01_changed(vmx);
>  
>  	/*
>  	 * Mark the desired intercept state in shadow bitmap, this is needed
> @@ -3840,8 +3850,7 @@ static __always_inline void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu,
>  	if (!cpu_has_vmx_msr_bitmap())
>  		return;
>  
> -	if (static_branch_unlikely(&enable_evmcs))
> -		evmcs_touch_msr_bitmap();
> +	vmx_msr_bitmap_l01_changed(vmx);
>  
>  	/*
>  	 * Mark the desired intercept state in shadow bitmap, this is needed
