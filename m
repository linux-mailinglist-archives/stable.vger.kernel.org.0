Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E307F66471D
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 18:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbjAJRQj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 12:16:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbjAJRQi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 12:16:38 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2086.outbound.protection.outlook.com [40.107.237.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712FB271A9;
        Tue, 10 Jan 2023 09:16:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XFp3mmYzMf+V67z3yMgrKh2WTVjmgAziBhCp92cXPdMGVz02IMvqQrixH1BHFUI4lcH6FqfMpXLRHLRMeOVtrjHtS6A8w9NTVvLZvDUoxcnWWlq8wN1F4VXhpdGFlxXYDquvij+L+t/1hz08E96pZQYxuvbq/SYoK1yEXci1wL74LnJWX0ZyGNcYarUQeSLSjXXQ/VEpWUHt9V3RpONmg8Y+35vbylR4Bh31T68+s/n6vAHplKMyvpR/4A98/gpRJz+MBiVZgxYV4u2WsU7yfg0sCEYp1ygCAgA5KOVCKqTegrpt2gynBLYPqKCLer1hZbWjKHclQvkViAxyBzSUxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CySotVvQVx7uZp996yp3s3RdxWgYqVVVDIFNPXi9rHs=;
 b=AAiR0kOZEgVPDV4CPNsNLZqV5NU06KEtUaI7lhC+Lt56pn/fPDHpoHOuyNa1oLZ0MwzKaGyovfeAUqUC4ni4ZqGCOCG3f5mAm7AuTT14vz6MdXfy1QnnsQbB9AhCYZU9Vd08Yx+UZ7fY7jUZiGFjrAIC8AyzKBLG0M69ECh4mHrkomUInO2OsFFeH9aaHYcbTN9Am8JTCamKIXnJCX6iK2vThVYDL1Wv3ixkFDNFrX78UKH9ait7TPae3avJYUdx9NG82zNONHn+NNrvykqS1avARB8c5y8dtwV0mlWyZMpAtwpYX3xzB4/MmRhhugQ7AYPMMvFiVGZ9as+qTZP50Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CySotVvQVx7uZp996yp3s3RdxWgYqVVVDIFNPXi9rHs=;
 b=wQd8XavsSbdPReZJ7wGRPUaKZ6GvlbQdIugQxqh0W/3+FzTmsMb+8FuX9mOxjfryutqr0bjTDmwfE/qFCAsNPk0csJeSxIh9gCxIKBVCA465zwqOGq1toIuCkOzUJaeRSbXoebDXd2aZnvIUMgFzoHnIU5Vki0/FrmShWdwsBYE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by SJ0PR12MB6853.namprd12.prod.outlook.com (2603:10b6:a03:47b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 17:16:33 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7%4]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 17:16:33 +0000
Message-ID: <d6c2455c-aff5-a135-2610-53dd6b586b59@amd.com>
Date:   Tue, 10 Jan 2023 11:16:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] KVM: sev: Fix int overflow in send|recieve_update_data
 ioctls
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, Andy Nguyen <theflow@google.com>,
        David Rientjes <rientjes@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230109160808.3618132-1-pgonda@google.com>
 <74745684-785e-71b2-288e-91fbcf1b555b@amd.com>
 <CAMkAt6q_E-+VV=KOs9LbDzawirWR7M4xL2pCF9fR2kMuBuFM-A@mail.gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <CAMkAt6q_E-+VV=KOs9LbDzawirWR7M4xL2pCF9fR2kMuBuFM-A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR06CA0016.namprd06.prod.outlook.com
 (2603:10b6:208:23d::21) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|SJ0PR12MB6853:EE_
X-MS-Office365-Filtering-Correlation-Id: a56a3be6-af81-4976-5b38-08daf32e6c02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bjKm84j57SDRRFyRhRn11rbc1CNLI6HrBrcvQQa2SArP97t6WrgrVrC6ss1OovsSfN+Z2W/add/ROTznE3utNqoKWdiUCbYWOJb6/K93ALwXryD1qGteFdhXivUxLZGOpgxLKHwuyYG5L/BN/jNkU7sc6sLsLtuloh3w91OlbfxiN3mj+vLtsNRLnsv58AV5A8kVjPLcssGpFIfG6ywy3pn2ZiU8QNoaoeTjmA5AE5yPACoR+S+oQNkePnNXoQDyIMDNIg0ZY5Jd3/qRloti1OzbmKlHzv2CtoFVgvyhCC7vaSu9Xbi1sdd+eNAs08H5jWHcea56f/orCT1SJQ+RqwdtDlzzWcpv3YcfNYsmOdo89wdETQHMERl7TYWiyugK/+w3KPousJi8SUVaGn3dFsJEOMBmyrUKXtanLHAImcKtuEfl3nkM2n4B7VaSh+C11SJ+4y18BbCRdp9Eit6EG2iaztOTkyG/MgjXRulwz955OiBcXMV8fPctK3iMf2EEaa7wm849oGATlsKUCvWVx/iw727Z+YzjdzwGnsoJxWprs1Ah2mGI5FqRijfra1AB00PJ9UNqhESf9iRH6mbqSmoYcbr1V/RR9OCEFCpyMaIclydTK7VmSiRbvUYB4+3vW1J24UmlYjp0RRVUsRfenpm4aKVkHGKlWcK3aM7ORPTsLiIGdX8V6TfNEQDf6wYtz+nVLA6OVDjqNcb3KJHUN4I+HzeHnUIxZUXDOn1koZM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(396003)(39860400002)(136003)(376002)(451199015)(66946007)(41300700001)(316002)(54906003)(2616005)(4326008)(66476007)(36756003)(66556008)(8676002)(6916009)(86362001)(31696002)(38100700002)(8936002)(5660300002)(83380400001)(2906002)(6506007)(53546011)(31686004)(26005)(6486002)(6512007)(478600001)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UENTMk5DOWNoakpSNHk3SFlia2pVZHJCUnpGWk5ic01YMmJ5NUR1V3BiMWZL?=
 =?utf-8?B?bDRKSlVhQ1llNmhsQ1hqSEh6cUVYOUxKbjJ3WTI1U3pJeHczbEhIRlNadEw3?=
 =?utf-8?B?MW5QVnhsM3dSelZ5MHZnaXg2VnJHSE53NDcrcklMck9tVFVZTmc5ZE9jSzVy?=
 =?utf-8?B?cGF2R3FBWHlxWGhCTWdVMng1N21kbitXM3U2YUJCVUZqMHBmbDFzU1VKd2Zs?=
 =?utf-8?B?S002TjZkMjZZLzd6czFub2N2RzhnRGdkdmRlTStmMjFVbStxNlAwUGNpUzB0?=
 =?utf-8?B?UHFKWm9NaHdDc2twUUJueG0xMXJRbVhZOHRBWEloVHlIMDlCSTNXWWw0eUVW?=
 =?utf-8?B?Rk9MK0lsK0FIdkFHOUJ5RDduVzFYdytTZVIySTl1bElURWlwUWdQNDZ3QUZH?=
 =?utf-8?B?TWExMkoyZFVTcXhIL0lkNmRZcFhDMEl3bXZmWVJpV0JlTG1nbmFEUDd1bmo0?=
 =?utf-8?B?Rjhib0RBV0J1aDhzUzJyVHhZaXducVc4UE03emp6d1BUZmRuaUNIWFZsT25S?=
 =?utf-8?B?bkFhZWJwaC9MeCtWbkZ6K05KK0NxYXRMbURSdXZDemsvbTZWRlVpM0lIZ3ZO?=
 =?utf-8?B?RjVjSUM2VHkwSzhsZEJMbU12SlhVODE3ZzBQYjNra3QrV0dkS3YxeElkZ2xT?=
 =?utf-8?B?S01UMG5LMVdEYzcvZUhiQUgxRDQvTHE4cWNGb3E0YUNGU2hBWVJuWDhxTmJV?=
 =?utf-8?B?eTRRVy9uYlhlRkVMMXZ0S2laSHRqS2h3REFoei82d1YrOUhFRWFhRy9GNU5y?=
 =?utf-8?B?SXB5bGJMeWVQMHFuQk5yemJFL1k4Q3hHMFJZNU9SQ3hTcExFU25NRUlxVVFm?=
 =?utf-8?B?c0FucFRsT081WlB3d0J6anFhc3grL0dNTGdVMU9XODdhRHNPUDYrVFM4aUFT?=
 =?utf-8?B?STA4OUpGVlVaZzBEck0zaWdGTFl3ak04allyWTZyUDhkK1JxSlNGUTJPWEgw?=
 =?utf-8?B?bDIwTk5ZYncySjlrNElaUDIwUFFUTnhDK1Q5YW5FeU8vQWdMU0t5ZzN0cldV?=
 =?utf-8?B?L2JucGhsdytrSFIzRXFnTDZ4RUtFanZBL3YrUWdwVEt2MlJuZXlLTlE3THFP?=
 =?utf-8?B?TStHY2tJMFBjNHA0dS9FT3F2NkRwNXpiZTdjaFM2SHk5eUlLZUpmbG10dlNm?=
 =?utf-8?B?RkpRcVdKRVlTR3R0UUpxcUM5bEx6aG5BczVXZ1ZIT3JCa0xUckV6YTc1WE5L?=
 =?utf-8?B?UjU5ZGhYWFVjYllqeDBQeFY1REJMMlRVcktvRnpoNENuQjIzSHRtOHpnNm13?=
 =?utf-8?B?Q3lHQnlKcU81SW54UlZqeHVYeFJrTCtYc2ZUUWc4TGJtcFVxVStKOEVIWDly?=
 =?utf-8?B?YVRXdnJvckNKWkdkVmIxTEdEVE5yMWdCZzlIT0pNaHc2WlQyTy9rclVucldE?=
 =?utf-8?B?MEdFcEJIUVRQcG9CSTlqbHg1NkhUaFc1a2VadGJNdHo5L0JJeHZIZ3JhUXJJ?=
 =?utf-8?B?S3lyUWowT0taa1RJOGhTZ3IyS3c2RnBWL1laVDhsRi95am5nYmJKZkFnVHZM?=
 =?utf-8?B?TVpCaTFnSmZWYjdHODZTRWZXRXhVZkxHY1ZVcUlST0tzRmZpMGlySXJVK1F6?=
 =?utf-8?B?Mzh1NGoycnExSnA5N1lHQnpES3dSaEJWM2RwTHNPTWU2NGdYK3ZyN0hpZHR4?=
 =?utf-8?B?QnlyQ0MzMFB1OGFHcjY3MVFQemJVSHNkL29XV2tBQUNSVitJYlFWN1dNUldI?=
 =?utf-8?B?d2pqSGdDTGxob0VnYTNFNy9wOVRCWnkyNHlORjBVRUFkUHd1MzUzK0xsMTdV?=
 =?utf-8?B?RFZPak90bkdPS3NjMzUxMVdTcUJaTFE3djhQNnNieGlBaWFmTW5rdUFLbmpV?=
 =?utf-8?B?dTJ2Y05WZUEyclRFWitkT2E3clNRR1MwcC9hTzVMenEzQndFWTNFNlpyUlp1?=
 =?utf-8?B?aldpdWFKM01ncjd5Sit1ckoyazc3Y2p1MzNoaHZxUEh5QjdJTlpOSGNpbU0y?=
 =?utf-8?B?UElscFJNUDRmYTV5cUNFamZhd0NDRDdEWXF1Kzg3eHlCNHE4dVp6ME5naWp3?=
 =?utf-8?B?VlQxNjJCa05lc0NucVVMWW1UWDBSN2hRSXFKMC83U0I0ZFlIVlErS2VRNFVJ?=
 =?utf-8?B?TjhVeXVLUkJDVllMalA4Y1lFSTJNRG9uT25GTncyTFd3aUJ4dGZMZUE0NWww?=
 =?utf-8?Q?dOmE6u2qyrEdnITjrlW4Xms9g?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a56a3be6-af81-4976-5b38-08daf32e6c02
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 17:16:33.4672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sMDbQGpkhhKucKxUM4xa3RV9sEUEgQHCvcKJNpgo9/QucfvPf3Dh46aJ2uPZEiIZ4wu14G2pUTB4bgmLbqS0rA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6853
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/10/23 10:44, Peter Gonda wrote:
>>>
>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>> index 273cba809328..9451de72f917 100644
>>> --- a/arch/x86/kvm/svm/sev.c
>>> +++ b/arch/x86/kvm/svm/sev.c
>>> @@ -1294,7 +1294,7 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>>
>>>        /* Check if we are crossing the page boundary */
>>>        offset = params.guest_uaddr & (PAGE_SIZE - 1);
>>> -     if ((params.guest_len + offset > PAGE_SIZE))
>>> +     if (params.guest_len > PAGE_SIZE || (params.guest_len + offset > PAGE_SIZE))
>>
>> I see the original if statement had double parentheses, which looks
>> strange. Should this if (and the one below) be:
>>
>>          if (params.guest_len > PAGE_SIZE || (params.guest_len + offset) > PAGE_SIZE)
> 
> Isn't the order of operations here: '+' and then '>'. So is the patch
> correct and matches the old conditional? I am fine adding additional

But what was the purpose of them in the old conditional? They weren't
necessary.

But, yes, that order of operations is correct and those are both before
'||'. So the extra parentheses around the second condition check are still
strange then, right?

Given that, then:

	if (params.guest_len > PAGE_SIZE || params.guest_len + offset > PAGE_SIZE)

> () for clarity though.

I do like the look and clarity of the parentheses around the addition.

Thanks,
Tom
