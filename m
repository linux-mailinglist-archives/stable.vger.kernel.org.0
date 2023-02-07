Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC79568E038
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 19:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjBGSj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 13:39:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbjBGSjw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 13:39:52 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2048.outbound.protection.outlook.com [40.107.237.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A11C315560;
        Tue,  7 Feb 2023 10:39:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eKQfHoXkx7HwfCYvvOXFW/jSMl7pSuixLCayMOjVrdWI1G3YTzkD/QYPbXXnypc+tVbqoYW+wNv/tgfUmSd/gXKV1ri+m9HxqV/QvOl2iNqPNsUBG9lyVWwBmD9dJLE0kP4u9R3e5dTXIBGeDaQM9WKMhSrllI4DN30Pu7hwZzTYMqyziEALTYJvs1tbGymR9IAhZzVNqJZ17CuPs8mw2lWsTnwS03LPUy3Ks9njrYrajVv0MAVmkYnwx7AD1MwnR8m7QTLPR+b+7Tx6a12mJc8NX2c0xUl0MyqHURv1GtNbu+rj9MeWzoSZ8n4fTzQBjuQR08g8qj5CRZ3OYMlVnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TONsVX6q1qeKmBlewlmdGt2M4V/a/5kFPYBSBZFtLdk=;
 b=coFEMmSGUjgcfHnDfZASXWsDAmzMKyNbGCR20SQXGvO8Z1Yi8sD+1JE+MnPvT5a4uda4axqd6of+0ntsr5PSzM66F2V3/LMctlKDjkdz5zUbsmJ8Pa3IdXdyFw2ONVDpYcQ+QHu18mGmVZdKXEPM1lLtV0vEHnHoI7WIq61/gI22RTuZKEzqcqPDnNuWlzB82bJpuzFP8EUruMti7/rZnavlcQJYn42w9WhsPXD0jJC+3JCkaG9/hqPX3b8K4b/6JA1YyNVd03L4xw7op272VKCk3mPLy6dYo/cvbAd0+t0gXf6FZG+bYwNGqMe5u77q9JgWXE+5SQDalRdEug1FSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TONsVX6q1qeKmBlewlmdGt2M4V/a/5kFPYBSBZFtLdk=;
 b=o8k19OX5j2JUvF2/xdeun2x4brLIHYgNG8Og4+n9IyeJwBFoc8PDLhwB4UyJYa7KYja8IMOPlLuXcTGdgUHGt7MQJeGDK4t8LhB2bnuu64tjEW8sdWGmzuoqLuEIEiADmmcOPN/blebjqqK4+rR4hOoGp76YYwT9X8hxgLUWNTk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by CY8PR12MB8215.namprd12.prod.outlook.com (2603:10b6:930:77::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Tue, 7 Feb
 2023 18:39:48 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::6cc0:9c7a:bd00:441c]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::6cc0:9c7a:bd00:441c%5]) with mapi id 15.20.6064.036; Tue, 7 Feb 2023
 18:39:48 +0000
Message-ID: <cd13ba15-b1a9-0475-96a8-5500015d8510@amd.com>
Date:   Tue, 7 Feb 2023 12:39:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH V2] KVM: sev: Fix potential overflow
 send|recieve_update_data
To:     Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org
Cc:     Andy Nguyen <theflow@google.com>,
        David Rientjes <rientjes@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230207171354.4012821-1-pgonda@google.com>
Content-Language: en-US
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230207171354.4012821-1-pgonda@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR06CA0007.namprd06.prod.outlook.com
 (2603:10b6:208:23d::12) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|CY8PR12MB8215:EE_
X-MS-Office365-Filtering-Correlation-Id: 78df30c6-561b-4eb3-5e06-08db093ab01f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5PovsyilkLJo47v5B8rIybUEhf4LlostBZ8tJ5YKxWRk7FETof0tD5fDoIBC2eCjzbrWNzsvjA+GRutajPXy5/pb5+jqIvVQDIz8/9ltc/legUaAiw7GgRf6ox3fk0pcE428OrDmYnQKpnFoTMrFQXDz3pqdbsGmu+HPRA/c/B0Lwyh3vCNar5u2dlpRWCaBL9oWSoLt00I967L2ho6nKDGi3lCVmg8wxxPcKmL6YO8I8eGEzUGYz3nhX+qgsSe3AjRFR6M6peZVPWMpuQSlPztKwNBR9fKiR/uQcRBCyN+VEkVD5raZkyuVH7zcww6dG/rDSeiK/PwU+tjnytLqL/aKN+3IZvhIPTbv+y3grh61jGsmxpGLE98Q4OOmPhIhyOIw6LwHvPH/4/z8PvKD9BjXzY/YSxe4rFBF/RxPM/qkMvqY/5Sdb9ATDWxF7cAXpAjcIOVqJQdoLfmmOWoPBUauyiV3zVT5mj3OyQLCXG5RpQ9VVBVRMI3oY+8ZislBsifEcSREKZVddw0YU1cADdkL3d8SF9FMXsF7U1XzST0DnpEH0W7ffiq0XDlMnP1mBXNeHb5rzAwIZO2oZKznA5PdSLdU7HEc0UAbHNe/HREHCcS3OZzWnemQ7Kn7n50jCPRz0Peq78kF97kTGIWxSg8Ue9mB0sHLsBxxsZJu2mtqy1yIxZ8TTTMEuz2xvRoTVzOkWIrKtrizA+FP6fyXrFCbeD12Twl0EuIRc0+z6oI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(136003)(366004)(396003)(39860400002)(451199018)(31686004)(66476007)(54906003)(66556008)(316002)(66946007)(4326008)(36756003)(86362001)(31696002)(38100700002)(26005)(2616005)(186003)(6512007)(8676002)(478600001)(2906002)(83380400001)(8936002)(41300700001)(5660300002)(6486002)(6666004)(53546011)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZktUSnJOcGh5ZzZBdFlhbm5vbXhMYWJIdDZ5UUJiWUo1dFY2ZHlDQXA0czRV?=
 =?utf-8?B?bm9rRko0M09XamRXemtHSWdsUU5kazRzNEJhS2hrSEhtckJ1dHBPcWVoNkdB?=
 =?utf-8?B?R0NkeCt3T2k4Y2lnSE5kc3ZZT1M4MGJ2TS9xVXdiNTNGTlZ0blhMcmI3YUta?=
 =?utf-8?B?NHdjcExDbittSXR6NHI3UFlHY2FKclVZYld1WVRSeVVacnhvcGJqZzdVMWlv?=
 =?utf-8?B?Z0F1NTZ5RXBvd2UwWkQ0UVk3NGo3Q2Q3aDcrRjNCZmtHS1B6TjFIQzh4ZUlT?=
 =?utf-8?B?cXYzcEJFTEVGQkU5dW91NGFFUHhiYjMzYTFuZG90bkxFcHFZR25ueTVyU1hK?=
 =?utf-8?B?bThMa09qRDFoNTR1dFZxRTdwSndoYXVHb2J2V2F1YnNVTmZrK0pKL05WOVJW?=
 =?utf-8?B?REoya1kwWGhCS0FmVlZyejBLMEdRYlQzR2h1eE1zeDdUZ01FV3F2V3llcFBr?=
 =?utf-8?B?c25ScE1GdWVtc05Eb1plUmtKcGphTTVCbHlRcTljNHdnLzR2TG92NGlzUVNl?=
 =?utf-8?B?SXJUWW85dFkwZUhiVWxrdHdUc2ZZdzEzeE5pUlRjdmR4UUNQeFRGK21IejF4?=
 =?utf-8?B?ZEtZUk1lend0dHZMbHphdVlYdDdlOFpZMDVoQzE4c2F1S203WlljYnlKMm1u?=
 =?utf-8?B?ZzhNSUdvZHVEZjNDYjRIWkhyeFJFcytabE0xSEFHdTBjdVdVbHNBOGtLQUVY?=
 =?utf-8?B?UHBORk93dnJqQ0RMRHBNbmhMOFlaWjBycXZGWlJpWms3TTcvTThORUxrYXNs?=
 =?utf-8?B?aTZHQmd3NUhub1dFVnRFNlcyVVNZaGpTTjF6QzExRml1TDFzVEpKYWd2d1cv?=
 =?utf-8?B?QWJRU1RzVnF5aE5Xb3FnWVo5MjV5S2MxVEtMNDFBNXkxbWJFeWxVOE0wZnE5?=
 =?utf-8?B?QXFObU1BUjRmMjRpYXRiN3VNT1FlZmF4YUpoc3haTzViN3Q4OWpTa1BFN2po?=
 =?utf-8?B?V2tzcGU4UUJLS2RENUlzNEovU1RRUS8wclVWSjNiaEJMYk9NM2xXNFZOYURE?=
 =?utf-8?B?YzdlUnJScmlqbmN4cE5yMFpnaEg3aTZXMm1XMlBUTDBXczJZT3MwK29hUmti?=
 =?utf-8?B?YlBKbHF4d3pOMUpxelJSR25XOE1qeExxQVdnZ1ljcU01UXFJZ1AzUGRNejI4?=
 =?utf-8?B?SjJHOWVUdUIxMWJqYUNLdkI4UFdIc2R5UmNacFdZVHQ5N3dVdnEwMEppS3Nh?=
 =?utf-8?B?aThSS2ovTWZVQi9aMkdIYm4rdHBpS3FEZkk2YW96UW93SG5teHZsQlVjUmpY?=
 =?utf-8?B?c2F0Z1N1QndONlNnbGhqT1d3aXpRTE9QaXZTc2JMM3RDOWZ2QW5UazgzSGdE?=
 =?utf-8?B?N3N0QWJRYVNFd3luSHFrdWFMWTYvUWFURjFJVmEveTlXOUNlNTNtalREREY1?=
 =?utf-8?B?S3l2Y2QvVzFzcGV0T2htQzRRSDZJUkIxKzdtZElvWXhMWlRKaGJoMTBmY0M4?=
 =?utf-8?B?UWlWaCtlUTdRS0VWbUVIdGRVZFRQbExRLzJWcFdqSEJ3SllmMFRxRkQvV3Ri?=
 =?utf-8?B?VzVZMzkvVDVLY2lONGU5VGJ1d05EWU1jVUlHY1ljMHJoVmlvRXFhS0Jad2Er?=
 =?utf-8?B?d1o0NkV1NWZXWm0zQmZCdklIQUdpTnZ5ZEdBbzJtRnJ1RFBONDdqdkluOFZQ?=
 =?utf-8?B?UDNNRExRVEUycjFNMXRsTWg0NlIyU01xNUY1MXZqczhDV2ZvenQzSFlBaXFF?=
 =?utf-8?B?b0RFOVBQMXdGbFk2N3hUaUNpS3lpd2xnOEZkMHFJNnZkbzJmdTEyZG50WWNY?=
 =?utf-8?B?ZnJmdXgrZmE4b3VzaE44Lzk4OGlvZS9qR0dwWXJMTE9HK29odlBKTGdEUGJn?=
 =?utf-8?B?STVTbEdhQWtsL3ZqeU9rUXNleVlKN011b2c1cFliSkdVNE9icWQyZXZjdFlK?=
 =?utf-8?B?WUNrcExFTC90Ykx0ZDlVOWZoRnJvdzkybjFpZi9qMUVOck1jZVFlWWdJNDBp?=
 =?utf-8?B?cGxqU3pGbkhSdUVGUmxBckRyaW1MZ3hwclNpOG02UDFiZ1ZId1BIbzFLaGdV?=
 =?utf-8?B?aW5tOW9CWXprQnZ3OTRNL3plQzE5U3ZVTlVtYWhhSytoMGppSFE4RzhJakhQ?=
 =?utf-8?B?QzAyL29BTHZJNFczdS9HVnhYM3JTelBhV1VDb0g0b2NkN1hETHNGdU85dHlQ?=
 =?utf-8?Q?vl4faB8/AneevxH/ZQX41O5tT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78df30c6-561b-4eb3-5e06-08db093ab01f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 18:39:48.2239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i8YuhyZq8BPR6UTVwWSTlX1S94Bf4R39VGKzIJWeG0zsqG+wf3uyURC2cFqDWeQw7ZE43qSsR3enxUVlpDyOkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8215
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/7/23 11:13, Peter Gonda wrote:
> KVM_SEV_SEND_UPDATE_DATA and KVM_SEV_RECEIVE_UPDATE_DATA have an integer
> overflow issue. Params.guest_len and offset are both 32bite wide, with a
> large params.guest_len the check to confirm a page boundary is not
> crossed can falsely pass:
> 
>      /* Check if we are crossing the page boundary *
>      offset = params.guest_uaddr & (PAGE_SIZE - 1);
>      if ((params.guest_len + offset > PAGE_SIZE))
> 
> Add an additional check to this conditional to confirm that
> params.guest_len itself is not greater than PAGE_SIZE.
> 
> The current code is can only overflow with a params.guest_len of greater
> than 0xfffff000. And the FW spec says these commands fail with lengths
> greater than 16KB. So this issue should not be a security concern
> 
> Fixes: 15fb7de1a7f5 ("KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command")
> Fixes: d3d1af85e2c7 ("KVM: SVM: Add KVM_SEND_UPDATE_DATA command")
> Reported-by: Andy Nguyen <theflow@google.com>
> Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: kvm@vger.kernel.org
> Cc: stable@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
> 
> V2
>   * Updated conditional based on feedback from Tom.
> 
> ---
>   arch/x86/kvm/svm/sev.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 273cba809328..3d74facaead8 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1294,7 +1294,7 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   
>   	/* Check if we are crossing the page boundary */
>   	offset = params.guest_uaddr & (PAGE_SIZE - 1);
> -	if ((params.guest_len + offset > PAGE_SIZE))
> +	if (params.guest_len > PAGE_SIZE || (params.guest_len + offset) > PAGE_SIZE)
>   		return -EINVAL;
>   
>   	/* Pin guest memory */
> @@ -1474,7 +1474,7 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   
>   	/* Check if we are crossing the page boundary */
>   	offset = params.guest_uaddr & (PAGE_SIZE - 1);
> -	if ((params.guest_len + offset > PAGE_SIZE))
> +	if (params.guest_len > PAGE_SIZE || (params.guest_len + offset) > PAGE_SIZE)
>   		return -EINVAL;
>   
>   	hdr = psp_copy_user_blob(params.hdr_uaddr, params.hdr_len);
