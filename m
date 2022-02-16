Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC39A4B9440
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 23:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236385AbiBPXAI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 18:00:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiBPXAH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 18:00:07 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2069.outbound.protection.outlook.com [40.107.102.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5EA2A0D69;
        Wed, 16 Feb 2022 14:59:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RQmapvYEmN1RmNgLHo6JL4N16A6Ytu4W20MGRxT6gUKuALyPVSdaOsl4tEA3FKyYLFeg1DLJCppDqM6gXKSCmDzTLu35piPFpC9KAvzWGuI927r+tMbfRys6/s5ENC8IfmnKtrEGpJuTjjirut4l+zN3Y0Jq+OquMi1fQlkxXiDnU9rZTmOk8Q2NHoYDsVmmxBjh9s3RFbzKWF+G8kMxNDDVhkR+outO6dgi2YCO2NchuyqyON0R9cQUKR+8eTj9qC3GwSmeU3WGUjMXOIqJxN8fqJBIG170v6/fv2QouBJl1omgU4JDvD61xhRSyCs4XsEoFcckIZgalhroVtjvPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5+BjxXUzhX9by+B2NbtMJ72ACB6YvWqdpQejX7pBOeo=;
 b=KMQeRhqIbzS/LK7DZMAdiBU+YEiX/pNxm5laqrCVqfoD1N11ueNodNBWMhb9dPCh2oR/X9XoqNFUjW/TA1KpEKv/WeEjurVew1kvrmNIj6OHxYyIwKk4sHJzNTMh1NPlcMJj/5FZInx0TluyEGbHydY+SAVQyRNGNIGfAsFdqqs56qwwdNCjrSEq2MHAHXQpEJsTxjMUfDTJqlWpGDWrlj7CdrP8BcRpOafP/nWEXv8Ef6Wi69ylfVtExZzxaWWzN8UBZaLH/0sRjWvVHuLopgTbbrURKcetgTpgFY9n9z93w2aQRfAIKg5/v6dXbKhdg8vheceBt1XZSY083E+gMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5+BjxXUzhX9by+B2NbtMJ72ACB6YvWqdpQejX7pBOeo=;
 b=lxjZNP7i+jXt8YIVOWwnyp6FH50Khdm7R/vIE+H89Q6N/qyYTd44MgZixQ/ARmiMW6Pc/PXZS7x8ajNJjrZk+rRtVM9LyW621HZ4ZX7M2sNOqbR3lwa0s/a1uu82okgK/xtiHqPqY4hbs8M1ppFYiBi5abKA2O6Ao+q4+Sw8l6A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 MWHPR12MB1679.namprd12.prod.outlook.com (2603:10b6:301:f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.14; Wed, 16 Feb 2022 22:59:50 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::74f0:93a2:5654:588c]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::74f0:93a2:5654:588c%5]) with mapi id 15.20.4975.015; Wed, 16 Feb 2022
 22:59:50 +0000
Message-ID: <5dd76348-f89c-58d9-1f6b-a6031b984330@amd.com>
Date:   Thu, 17 Feb 2022 05:59:37 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v6] KVM: SVM: Allow AVIC support on system w/ physical
 APIC ID > 255
Content-Language: en-US
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, mlevitsk@redhat.com, pbonzini@redhat.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, peterz@infradead.org, hpa@zytor.com,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com,
        stable@vger.kernel.org
References: <20220211000851.185799-1-suravee.suthikulpanit@amd.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <20220211000851.185799-1-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR02CA0152.apcprd02.prod.outlook.com
 (2603:1096:201:1f::12) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bdc0077a-ec75-4f46-8989-08d9f1a00932
X-MS-TrafficTypeDiagnostic: MWHPR12MB1679:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1679AB74FA166916A0E1FF5BF3359@MWHPR12MB1679.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7E8XM2fyD6C4kQsPeTIQ5M+1uBQYQ0fabWBCVRdT8OJsj/O04fhciBDBP2fBlVcxXk+wCA3lwkoyKxQ4eiD9ObQExvUBxA9JUfZN/xkH3MRxtwwunOPmjo/P+EmIWcOMxbg+B7o15y5y95FeSq/sp7xm7LUlAR2mvlp+WpM/ZHIbBZWN3mYXZpk3k9L1jc7oKEbyQnxF1M6xQWPsHXlZmWu+jcW98WGs4zF1OYvXpGGNyNRppIeV+79bJWxYzDFRv/1xSHRpgGxW9nrtE8I1gUsckm23lnlCu0miQX4Gd6EY43ZqsSKzAOm6R/uUHkhlj4jhg3W9vSwwx08ZwRyX4giyUh8/hyBXoHJw1dj0NmkFX7G7b9s8blDVbJ1p9TMg6xzWnX54Zr4wJLyvp60wSXIO2coZykLaQPxK+nUFi0/ulGgjhi7mBWWeKfkvPq3Fx990ycTvnE5zXWq0r5XuoCRizGPQbNWOrn9J5OqkhpWM/tSBxliiUhVWwAdaNXP/iQTiojh86ODnGd8VvIX8TPoQxgLrT+zthQroKlJD2DB9u6DvE5y9jZfmXnmIa6qUD7hTtj9tAKUfFfi/90a5Ut/wHXxSIg2+vR3iG8UGp7nDQQnVh3fQITTYGWn8HmW+hN0cNKy1zhkNKN9ZiiA6aYJTjnE7YABslNv45xSGg+AUzvR26vcCiQQfxNhY88tmdpDSpvpR/MYEOGs8/SqXKkXKZlhbMd7I1GuLd2ZAgjk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(8936002)(53546011)(66476007)(36756003)(31696002)(8676002)(86362001)(66556008)(2906002)(4326008)(6666004)(7416002)(83380400001)(66946007)(186003)(6506007)(26005)(508600001)(2616005)(6512007)(31686004)(38100700002)(6486002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MjF6MjM4cy9tZWNJbGQ2SW0rVU9sVlhHMXlSYmEyZ1VFS0ZJbVBXL0NsU2Z5?=
 =?utf-8?B?N0t6b2FWVFR4UTNRZUR1RnYzamNGeFZnYWlEbDFRbHd3U0o3c0dsQkovUi9l?=
 =?utf-8?B?MFFUVzF5YnoxWHJqdEtVQTFBamY3SWplR2FaVjVwUEhxUXFFQWxvSXdacDlH?=
 =?utf-8?B?NEFJNlBlRTJFM0JuNHZDci9PdGpTeVJ5Tzd4c0RYRkYxZmpzWmluUlVuMVdN?=
 =?utf-8?B?eWdMeVgyYlVLSkVqbENnMFIzTGlzUG90a1dOZnZra1VwWUc0ZTl2SVFmV04r?=
 =?utf-8?B?YktIdnptdUVDRGt4eDQ4UEhxVkRaaVNCUVVnQmVCZTFRVm4xanJabFkySjhH?=
 =?utf-8?B?NlBidDZsaW5sNTlucmhxUG5pNkFFL3J1T3NiRmovTlowQnVXR0F5T1QxeUxY?=
 =?utf-8?B?cTZkQWkySmFaRUdxSmdaQWNLaS9IQlVDU0VQbzRhTzZMdFpQUEhBZ3dxSWp5?=
 =?utf-8?B?bWhsdWhaWWZjZXQyT3k1MUxuNnF5RGN3aUZINWxxaGFzblNISmZLNFdKa2RS?=
 =?utf-8?B?Z01ZOWx2bUQ5Y0JkMENnNlZMMzd1OFl4YnpCVkt1VERuRlR3cXI2aGVyMmor?=
 =?utf-8?B?anhOeklvUzA2cjdJeFIzUElXS2RDMTQ1RlRzTjF0ai90VnBTSHpDcVQ0Z0gx?=
 =?utf-8?B?UXBIU1gwUFp5Y2FneGRPZDlHTXhVV2p0ck5kbFR2TTdyT2JmTmlDMUN3TWNs?=
 =?utf-8?B?aVd4WXN5RjV0RktQYnlKZkY0bnk0T2hJTzByV1lMdHRRRkxYUlo0R0srYjNE?=
 =?utf-8?B?MGNIZ2wvMVVPQ0pIM1lNaUpjWXNqa2dTTCtMVVJXRWZrTGJ0WHRxRnZhQ2FV?=
 =?utf-8?B?V0VpRXlIQVp6V01jZ3FzWDFCVUJ5dnJmZmpMMGRnNXgvODFUbUI5bFdwM3Er?=
 =?utf-8?B?S29hdkdNRE90eHg2eXpYMTVRcTlHMjd5SHdFcldIQXptV0Y1TWplM1h4ZC83?=
 =?utf-8?B?NjBNU0dtZEVGMFhVcU13MzFiSFBXWlNaazhtdEhNSENMdFprTmtISWY3ZWlX?=
 =?utf-8?B?R1dWNWZLcVVnL2ZkYlFLcmRhR1FTcjhBYk5yb2tWS2xLelVySmJFQXZUNExU?=
 =?utf-8?B?eStvOVo3MkQrMjNTYWhINEVIUVkzRFYzRkFzT25YK055WTJOQ3NGY2Y5NENl?=
 =?utf-8?B?TXgvOFFmbjQ3QTVhNUFEUkpmNWd0bGQ1dW5rODBHUjhyRUhEUXU5ZWdJU2Zn?=
 =?utf-8?B?S2ZLM3lVSVlEcjBpWTRHSkZ3MldjT2phQmxib0lVZ1ptRlZHd3VYRElRZ1FJ?=
 =?utf-8?B?WVAxUUZOZlo4S2FwY0s2TUxyU0o5OWxrZG5UeUtXODNFdEhaaTE2MkxDaVBn?=
 =?utf-8?B?bHlJUllqaGd4ajl2VjVLS1JGOWdHU1c1cXhYVUJGcVNzV1IxWEVTZi95NS9v?=
 =?utf-8?B?V0NjRlRJVVZ5eERpd04wZHd1Q2xkOGRYZm1xWWNWRmxjU2RSTFRWOVQ1WU8r?=
 =?utf-8?B?czB4YzVLdkdoVGFITENLQ3QvSTRRNmlvay9PVHZxTnlDVDQzK1VtWVp5MHpa?=
 =?utf-8?B?YXFxREQyMEpPSkttNk1hZ0xVQ2NzQVJwTURZUkh5cVI0Sko4NXVSMFVxRTFW?=
 =?utf-8?B?bmNJOU85RVhRZEJlQ0tUUGxYQk9oY2d6LzNLakNwNHpCSE1IUUVtd1dtUUR6?=
 =?utf-8?B?MWkwdGUrUzFITEVLay9SWHZvWm4xclJGQXB4aktCU1NFUmsxaHlxZnNxM3Ex?=
 =?utf-8?B?ZVhISHZHNXpvZFlVYlk3OXdoUVVubk9hUjZxdXovRk5uWU9Yd3RDYU95WTND?=
 =?utf-8?B?UUx0d0RLVTQwK1lPTlVZMHZBRVgxeStMYXUwaGI5ZVErK09Bclh0Z25MeXh2?=
 =?utf-8?B?U3lUOWY1Mk9mWE85a0IwdGc2VENRc1RwQkpjLzdxWk8rOVJod1VVK2xBQmZV?=
 =?utf-8?B?cHdRZDBTWGUxaklPcWRXTDhsWGNjTVhzM0pFaXNqSVBwSFIxTS9XVWxLVUJP?=
 =?utf-8?B?OVRKYkNBaFV3Y0RQV1F0QnlTVlIzNjVVdEF4SFMweFJiYnpuR05Ja3FPcEUy?=
 =?utf-8?B?N3ZiSWV4V1E3bDNsK2FPZXZPbWhWUEQvTUNBSjlReXhEOWdBenkvaDE5WkM1?=
 =?utf-8?B?RGhwZHJVWEJHMnVkTnJaY0tZT0IwU3ZpWUhnWFp4K3dFcXlzbXhINHBWV092?=
 =?utf-8?B?ODJ0Y3czdnk5VFg0SmV6S1FQaVcwRGF5eFpvUW93emM0RGhNeGQ4QTFCT2xy?=
 =?utf-8?Q?2BwfrjoJ97jWCp4espMwSNg=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdc0077a-ec75-4f46-8989-08d9f1a00932
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 22:59:50.5847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qmS/omZuPsJ11zJbB0ITIJCw/J6cMEgBMB2B5l+69rR3awnXGm0dEnk56ra2jkoiwjDMryoqm/eemAVBzOCotw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1679
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Paolo,

Do you have any other concerns regarding this patch?

Regards,
Suravee

On 2/11/2022 7:08 AM, Suravee Suthikulpanit wrote:
> Expand KVM's mask for the AVIC host physical ID to the full 12 bits defined
> by the architecture.  The number of bits consumed by hardware is model
> specific, e.g. early CPUs ignored bits 11:8, but there is no way for KVM
> to enumerate the "true" size.  So, KVM must allow using all bits, else it
> risks rejecting completely legal x2APIC IDs on newer CPUs.
> 
> This means KVM relies on hardware to not assign x2APIC IDs that exceed the
> "true" width of the field, but presumably hardware is smart enough to tie
> the width to the max x2APIC ID.  KVM also relies on hardware to support at
> least 8 bits, as the legacy xAPIC ID is writable by software.  But, those
> assumptions are unavoidable due to the lack of any way to enumerate the
> "true" width.
> 
> Cc: stable@vger.kernel.org
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Fixes: 44a95dae1d22 ("KVM: x86: Detect and Initialize AVIC support")
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>   arch/x86/kvm/svm/avic.c | 7 +------
>   arch/x86/kvm/svm/svm.h  | 2 +-
>   2 files changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 90364d02f22a..e4cfd8bf4f24 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -974,17 +974,12 @@ avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
>   void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   {
>   	u64 entry;
> -	/* ID = 0xff (broadcast), ID > 0xff (reserved) */
>   	int h_physical_id = kvm_cpu_get_apicid(cpu);
>   	struct vcpu_svm *svm = to_svm(vcpu);
>   
>   	lockdep_assert_preemption_disabled();
>   
> -	/*
> -	 * Since the host physical APIC id is 8 bits,
> -	 * we can support host APIC ID upto 255.
> -	 */
> -	if (WARN_ON(h_physical_id > AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
> +	if (WARN_ON(h_physical_id & ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
>   		return;
>   
>   	/*
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 47ef8f4a9358..cede59cd8999 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -565,7 +565,7 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
>   #define AVIC_LOGICAL_ID_ENTRY_VALID_BIT			31
>   #define AVIC_LOGICAL_ID_ENTRY_VALID_MASK		(1 << 31)
>   
> -#define AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK	(0xFFULL)
> +#define AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK	GENMASK_ULL(11, 0)
>   #define AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK	(0xFFFFFFFFFFULL << 12)
>   #define AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK		(1ULL << 62)
>   #define AVIC_PHYSICAL_ID_ENTRY_VALID_MASK		(1ULL << 63)
