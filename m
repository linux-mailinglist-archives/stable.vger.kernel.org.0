Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 814F03D714A
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 10:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235970AbhG0Idg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 04:33:36 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:45490 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235946AbhG0Idf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 04:33:35 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 16R8H6NI030114;
        Tue, 27 Jul 2021 01:33:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=subject : to : cc
 : references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=jKGt28Kq6NaeOqdHpx2cKxQ8Wh1fBiAZkm8FNUEwJjE=;
 b=oNfmfk6D4x3byBeDNlM8qIYvVwxi7f2V7JIQ3eLryHhPmjedDhaNHlHz8MDQt+8VOkeY
 AZIWHMCIdyjWQYhsbME4NH+nQ9lLoOie30FWCSmXLAWsfwsgiFxvYZkZ4nXcu91ETad7
 5HwmZja2nayvXCjoMoEWAySQXTZKkpPYXwhTVS5bnhx8+4+ODhM8CHCiajkyHR/PuK4P
 eLazdmS/nE95wBuPYRGsJj+0Xr3kkmXpLPw2IM38Lbzk2Fn52uF4Bg7ni5mIW3setSBc
 EPou7ozmMTytrs7dc9IUnT1FDI9/E5QbaSqCa0Lt6G174dFgXYJf1NHqK1cBOJi0YBQy Pg== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by mx0a-0064b401.pphosted.com with ESMTP id 3a23558cra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jul 2021 01:33:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EeUlRMdKZgNOXF0ludGt0WeQU7O4Rpg3Ts8W2OjdOl6YJQjZ50CLLxl5PhBZBoSIA83vP/NaMPxVRNCj/FOSG/VNmA81TwhO5V8V1UFW0oXd8j6/6qxxGX5NNkMtJREz2/yyr+PfSMfZX9cAyGgYVFjSEeLnlRxgzNFyrMNBgs3LCWqkH3NcXpjclMlbVBCTvzlxgJ4xxSUs2KVgsMEiZL5KuJVTpQhMWJftBbNSh4a7HhR00a9P3ccIMr0hvVvFPTgygpSVDH6vq4sPfDnMTHnAbvE2dBQ+9YPnhy0pHFIKAPwSDujBc3xuKjrPe5aD9HQKowAWqY59BLxXIS34Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jKGt28Kq6NaeOqdHpx2cKxQ8Wh1fBiAZkm8FNUEwJjE=;
 b=I+QhSZLSlnOYJgsu1NB2JWyut9WEkDQk0BlHrI3TeIAUp+MZE1zWyLeL45q6bufUxdkvUm5xnlTaRUlzZs4fWCuxQjTtYUmQQa70Ids7QJPaB/omM+ZktaG1LREGqur3vlgvdNo878x9K4VIefnlQjWIQR8zNAj9c/3FW+ilV9VaDv0GbEreYYtStSfjlX7Qa8a4X/bhJ9Sbjv4nXvRx6Zb9Ey3ixh5xCUS3RjezYkeH/zuuDmpmRQm5qTKxGae7j95flO7USyuNixx9xQIFgirq/JehhBuqyrgJapOID+HV8IJkoIainwJKURjm/ofJdJCkBpcuA/BMuOVKknwTVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: ziepe.ca; dkim=none (message not signed)
 header.d=none;ziepe.ca; dmarc=none action=none header.from=windriver.com;
Received: from BN9PR11MB5321.namprd11.prod.outlook.com (2603:10b6:408:136::8)
 by BN8PR11MB3539.namprd11.prod.outlook.com (2603:10b6:408:8b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Tue, 27 Jul
 2021 08:33:25 +0000
Received: from BN9PR11MB5321.namprd11.prod.outlook.com
 ([fe80::5959:e459:a5e0:5881]) by BN9PR11MB5321.namprd11.prod.outlook.com
 ([fe80::5959:e459:a5e0:5881%9]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 08:33:25 +0000
Subject: Re: [PATCH 4.19 111/120] KVM: do not assume PTE is writable after
 follow_pfn
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        David Stevens <stevensd@google.com>, 3pvd@google.com,
        Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>
References: <20210726153832.339431936@linuxfoundation.org>
 <20210726153836.031515657@linuxfoundation.org>
 <CADVatmOcg_7eQno88nu4ijX9QOoA0h2QY=hoj3TZU+tNqj0TMg@mail.gmail.com>
 <8cf86f5f-480a-7093-e890-467f290b0ed3@redhat.com>
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
Message-ID: <ff279b6f-3a08-46cd-446c-101a4e421890@windriver.com>
Date:   Tue, 27 Jul 2021 11:33:18 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <8cf86f5f-480a-7093-e890-467f290b0ed3@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: VI1PR04CA0064.eurprd04.prod.outlook.com
 (2603:10a6:802:2::35) To BN9PR11MB5321.namprd11.prod.outlook.com
 (2603:10b6:408:136::8)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:2f07:6100:9700:63f0:3852:c91d:1fad] (2a02:2f07:6100:9700:63f0:3852:c91d:1fad) by VI1PR04CA0064.eurprd04.prod.outlook.com (2603:10a6:802:2::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Tue, 27 Jul 2021 08:33:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71f65904-a20c-485e-d7d8-08d950d93391
X-MS-TrafficTypeDiagnostic: BN8PR11MB3539:
X-Microsoft-Antispam-PRVS: <BN8PR11MB3539BA9958024BA446EE732CFEE99@BN8PR11MB3539.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1060;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8d2yv3ruqgXdF0MzPi5gZ8aD6MMuJsxmf31oYUjl+QvAncH+JwUktjj/8e5V2cvgLnYYtJdFupIr0NhQDx7e5zSAkGLe9Jx8eyFrHOPRC8s3i3uwwsHyHqE1sO9YDXGjDjtT4SDk4kDhSn3bmpy8Qu+nZS8PzhoX6Bof9DFLFN9X8PiNZBraj+x0qVOAwpvYY1sjULwXsGX4iLEC4yOmuIl/O27mVDJVmmYClO5WHzCiUnDM4cKB8lmYiKNNurk9hgbyPeltkVYm6ptF1KnKBcioOhhvFhWj8dhHXvHxsFmY8HPL2Fl3Z7nuAzW0JeiluKwKCfPg0NoaA0diHr5835JTahIW/zc942UB+gKJpsHayilDFzwc+y6cvc05jQRhapdTmOuWl6jA6s6ezW3xadyQ7+isK3kR4QV0SWhNxyYZJ9Uwr4VCIDoOBW8SyZ66zzeAW8z8UaKqxqh4VIx5N6rIJczM78GY6J87YC0GG9KGW8NjkuFy7KDKr0Ezg1d4XW3hH8lLep4I7bwlwUHgY84pxxO66a1T4EUIgyCQjTVl+y3BND4Ji8qJzHgeKZ0U/fG5/iWdyQs8kAO0lIrf26+wTUsirBa7cqyaSHdZ8KNMohFDwgtYCartaBB61aOTEssoob84adIrCkBdodwdM0N06xGYj/K9ZlGwMKcyZCm0fbuw7IVS08sx77zKcIWOy2Rm1T4Oli9PMHDAXxMauDzOkIEAyvYB8N+bHXlwDnAEgJ2KtpmwytLZWo7bOi1r0vqwz3cafV74dgVfOD+nhuCWT9aHi2NORHTCIChACrO4g3wngmBhCWHmAftfRZSg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5321.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(346002)(136003)(366004)(376002)(6666004)(478600001)(966005)(31686004)(66946007)(54906003)(36756003)(2616005)(6486002)(31696002)(53546011)(8936002)(110136005)(38100700002)(316002)(44832011)(66556008)(66476007)(186003)(5660300002)(86362001)(8676002)(4326008)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NEk1L3pBSDU4ZnVDcFVrdXk5WnAzQk1LeG5RVnNMTGhWSHc2Vnk2M1JEQjNP?=
 =?utf-8?B?SS9RSXNTYmk0ZW5pQTN6S3kvT2w3TUNqbmdFKzg5MFpvdmdyL1dUSHR0MnIw?=
 =?utf-8?B?RmMrYVI2Y05Kc0NrWWxTT0xuZkM5NFBxVjI0VDczcmI0YktqTTdubEtIVVVW?=
 =?utf-8?B?K3dxbGxqZXpRN1cvajFTK2pVcVAwQkxtU3pjbFd2NnRTaHRsYUlKeUQrRG1a?=
 =?utf-8?B?bUsrZ0t1enhQK2pqNzZvWGZMZmRqOUJYcjlvOUYxMVdvWFBvYS80NkRvQ2Jw?=
 =?utf-8?B?ckJzVDJSQURGbTZoNmxscE9uenp5NFZkbU9oMW92MmNWbVVzd3pBbG1qUjNi?=
 =?utf-8?B?d1hTNDcwb0dSZjdvbFZJYnc2YngydDNtaG1oWGZEdmdEb1MwWWxYUndWUG9t?=
 =?utf-8?B?Z0dlcHM4cVVncE5sMHJkbE9rZDlTeVRRK1NkUURNVTI5ZXhkcjdtd1RRcjMz?=
 =?utf-8?B?Z3NZMFExeG0wYlY3QVUvOHN6K29NYmlnUWJBTVVTK0pjRUN2WXNXbXhXTzAr?=
 =?utf-8?B?U2FEaER3eEVMUnV2aGliY0Zuai9adFdpK1ZhOTcxWUtsbm91RTBPMGdreUcz?=
 =?utf-8?B?NlB6dHJ0R2QwbnhMbnJ2UFRZbmFhVWtNN2trRi9JZWQzMmNyUStyWDBCODRM?=
 =?utf-8?B?U3VnWFBWbXBoNGN0ekp3Qlh0SWRMOUlSVHBNMU9HMUwvUzg5ZytHVzloU21u?=
 =?utf-8?B?NUxaQjdJUmlPSmwreHVQWkxIUnJyTXI4MzN3YXNmNW90SnRldnJRMG1UVy82?=
 =?utf-8?B?QzNMcW1CNFRYeTROVExoT1lvMGxsR3ZJc3NNUWs0UExMMjNyNm9jV29IRDhF?=
 =?utf-8?B?N3Bqb0tFNmQrVXBDYzE0WVNoeHRvV2pNZVNiU0l6cGt1aEcvRkRKKzB5cHRI?=
 =?utf-8?B?L2JqdTdXT3RQbzNSVHhTQksxbmVUYjNMdmErR25jdnRqZHVUdzRKRUFnVklN?=
 =?utf-8?B?d2lvK3hDb3FOSFRUbjFvU3g3QTl5WFgxTldkSXQ5a0hsaFNYa011UkFrdUFY?=
 =?utf-8?B?MFZBajYvSzVCVUF5MkhCd25OeFBHcVJJM0pxY2trS0NOUVlzWW81YmVTM0Jo?=
 =?utf-8?B?N1NWRUQvR2xrbk10ZDNYUXcwb3EzS3NsOVY5VWRjLzlyZmRkT2hDd0k5Z1Bl?=
 =?utf-8?B?WU5zOEpmVGRoc2cvQyttckZmNFN1d0N1QWJVQ3pJb240clBxSDVsZlpESytF?=
 =?utf-8?B?QU83aGRJYnF6NHMyY0NNQW9NTFR1UWxCeURrbmtFTUNtVFhRYzJnblJ3UVRj?=
 =?utf-8?B?ZjJ3cFZxSzZtS1NzOUx0VjBVSUh3bENZbzZhc3hFS3l0a3c3d0NUUDFZRmg1?=
 =?utf-8?B?MXJTemNZNWVzWXduclFaT0VBQXdrcWQyamE5UXFKNXh0c0lOTUdQS1J0TmN1?=
 =?utf-8?B?OUNSclpHNlFkWWEwMjUzZ293eWllcFptbkk3VEIyczFwMDZPbWxIVlVpalEr?=
 =?utf-8?B?R1dJNHMxUnFTYitCY1VFKzJpWG1ZUnRNdlkwZ0hBZGJVVDdqUDhkTGpHOEd2?=
 =?utf-8?B?R1VxOUNBQ0ZScEU4WUViQ0owbXpOZEJrTDNyRVlJUDg0OU5UNEJwSWcwa1ZS?=
 =?utf-8?B?TitSK3p2WTZIdWhzT2RUYVZpZ0h6amVSZ25YNzNncEpLSnhISWZteUJFNlFY?=
 =?utf-8?B?eFZBd3d2VXZSblVYbVlMWFlDb2pRZEJOOWN4eWRvQWpYSEEvNHZzSmlVWlB6?=
 =?utf-8?B?QTJ5R2ZDNTdwc1krQTZTemdPVkMvbkUzOTBZajMvTGNYVW9IR1ZueTNONzZW?=
 =?utf-8?B?aW5ZU05FMUcySVF4bkR3MDdIVjVpbVM4RmpMblFUOStWS01SaVdRcVpTUjF4?=
 =?utf-8?B?NitSZTN4d0l0VVFZUHZLaVZGd1R3UWhsZ0s5V0tyWDlRc1hOd3F6ZjZYWWNv?=
 =?utf-8?Q?7RXU16IWLBtDz?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71f65904-a20c-485e-d7d8-08d950d93391
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5321.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 08:33:25.4211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nNehiMwflTM6hDTn91xc55JIO4pv4KWpQ1MzvkIOqit/VGloO0rYf1Uu/iZpbdB60gnvxVztGeE+SiImIL9a8ifa3HVxqkVY3onxHmdOBAI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3539
X-Proofpoint-ORIG-GUID: wjtZfI6uhkvz11hwK4oYEX87yzjShgcW
X-Proofpoint-GUID: wjtZfI6uhkvz11hwK4oYEX87yzjShgcW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-07-27_05,2021-07-27_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 adultscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1011
 mlxscore=0 mlxlogscore=888 suspectscore=0 priorityscore=1501 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107270048
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 7/27/21 1:02 AM, Paolo Bonzini wrote:

> [Please note: This e-mail is from an EXTERNAL e-mail address]
>
> On 26/07/21 23:17, Sudip Mukherjee wrote:
>> Hi Greg,
>>
>> On Mon, Jul 26, 2021 at 4:58 PM Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>>>
>>> From: Paolo Bonzini <pbonzini@redhat.com>
>>>
>>> commit bd2fae8da794b55bf2ac02632da3a151b10e664c upstream.
>>
>> The build of mips malta_kvm_defconfig fails with the error:
>> In file included from arch/mips/kvm/../../../virt/kvm/kvm_main.c:21:
>> arch/mips/kvm/../../../virt/kvm/kvm_main.c: In function 
>> 'hva_to_pfn_remapped':
>> ./include/linux/kvm_host.h:70:33: error: conversion from 'long long
>> unsigned int' to 'long unsigned int' changes value from
>> '9218868437227405314' to '2' [-Werror=overflow]
>>     70 | #define KVM_PFN_ERR_RO_FAULT    (KVM_PFN_ERR_MASK + 2)
>>        |                                 ^
>> arch/mips/kvm/../../../virt/kvm/kvm_main.c:1530:23: note: in expansion
>> of macro 'KVM_PFN_ERR_RO_FAULT'
>>   1530 |                 pfn = KVM_PFN_ERR_RO_FAULT;
>>
>> It built fine after reverting this patch.
>> gcc version 11.1.1 20210723
>
> I'll resend a version that works tomorrow (including the second patch
> too, which depends on this one for context).
>
The following upstream commit needed to be backported as well:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a9545779ee9e9e103648f6f2552e73cfe808d0f4


I have sent v2 for this patchset.


Thanks!

Ovidiu


> Paolo
>
