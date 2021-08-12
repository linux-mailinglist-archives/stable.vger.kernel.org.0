Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A555A3EA9BD
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 19:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234360AbhHLRsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 13:48:20 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:42106 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234302AbhHLRsU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Aug 2021 13:48:20 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17CDv2Vc030865;
        Thu, 12 Aug 2021 10:47:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=subject : from :
 to : cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=vnufXC7Q22nFAW4w5UdwuBB9P8R5FjLCphOWPMdBw5Q=;
 b=gEXPOuvd2LAL5heqzi4msEvguY0Dmc7y5ALIbwfBQKRLTDhOwi7VfajoKiTKoxiaZS1f
 bTQYf1kOaU0TD0HImlGPk6DtjFZgH6xbN+sMqoV1KzkzwvFylhOnF995FPgNYKJQYpWJ
 GLRGPv4QK3sII//0r1aIZWAeibkG+zgyVaOQmqJCd4ZtWfaucGR4lT5yOHhnLXJxi2eb
 m5VE7Xfu/zfY2M7k2WFB5A07Ha4kAVwb9SpJ1mRNcNa7uJ8Ozb9wxKCFa//ve9Cx1ZaV
 TfKCEqdI9LS1zeFUdtJwhqB6m+iqtNJQwj+DMXoBLbIp06h1ZY4/wdLKvPAUVoAZl7pE Fg== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by mx0a-0064b401.pphosted.com with ESMTP id 3ad4wug6ek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Aug 2021 10:47:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oYBr/KevHBxo9BOuckpkAw+tND3dR5EDAfktJmHgg8odWeCe0SSFnxY3ys2Wfdlt3+Lj3PTVUUyTZJM/I9KWVB4Bx78P0ONuO+7IvZnk10brzA+WBt8c5h2Xg4haW0QD68ay60JPJSIPBArRz/nxF4HzCKPA8m4+0bwTID03SytJ49chLHkYcaCg15mdRYuCXo6WvQQaVveRbwJ5P2fAuvlZOUcKFAH30U+C9O7fSpYFNKUX5bGcAucIgNdVg6ScUu13xeFKHUU+lG6WS80OCpIDshoEDhDkCpQN/wJtjKrhaP3IyO40s0FsTrFxXIIwDtR4Jq7zTdUJTuxlfu7tIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vnufXC7Q22nFAW4w5UdwuBB9P8R5FjLCphOWPMdBw5Q=;
 b=KZdsWS1cUvKte2QYld7IraAGahZtZXraBAvLCOmCkoFEUg+4v34OQ6w4V+AM5SLWhWOxrY/U/2MI2hLQacgfoLHuAFDCK/c9mq25nAMQ0bvTkY5i8YHyFn1e5KBYDrpSBHlJdSiKDZ5ZlaLy3pKU9AfooA9uiMsQ1ll3EF+RwoXbxBXXZSrbk9wDdVopjV2/O1DA2WTnh5Z7hnJBWe6gJ/OxsB5maEd422MHRx9aTm+oior0RNhLYsjAVJ/2er9WdSQZRuDYbNI6Y/PFL+C/Q7jendpPq+ePuMj4SX2vZfKvKIsoOMMgZWfMG0Wm4/VhgDmdStaDJCgOAoBbzj0xbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM4PR11MB5325.namprd11.prod.outlook.com (2603:10b6:5:390::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Thu, 12 Aug
 2021 17:47:50 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3%9]) with mapi id 15.20.4415.018; Thu, 12 Aug 2021
 17:47:50 +0000
Subject: Re: [PATCH] KVM: X86: MMU: Use the correct inherited permissions to
 get shadow page
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     pbonzini@redhat.com
References: <20210812174140.2370680-1-ovidiu.panait@windriver.com>
Message-ID: <fb7c6587-1237-a2f7-baac-80dc94e49d51@windriver.com>
Date:   Thu, 12 Aug 2021 20:47:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210812174140.2370680-1-ovidiu.panait@windriver.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: VI1PR03CA0070.eurprd03.prod.outlook.com
 (2603:10a6:803:50::41) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:2f07:6000:7c00:efcd:1e42:774:d85c] (2a02:2f07:6000:7c00:efcd:1e42:774:d85c) by VI1PR03CA0070.eurprd03.prod.outlook.com (2603:10a6:803:50::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15 via Frontend Transport; Thu, 12 Aug 2021 17:47:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6316b32a-ee15-4800-35b9-08d95db94d84
X-MS-TrafficTypeDiagnostic: DM4PR11MB5325:
X-Microsoft-Antispam-PRVS: <DM4PR11MB53259C377DC2B6B18466F4D4FEF99@DM4PR11MB5325.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V1xH91BLO8Pt6q967jxDOeILo1fMVfTncno5sYIjwZkzzSU0/GCiIy1KQZAYWH59WL98jYbbVpACl/i4xLaqq6n55YNFNBR89eKBukOkbyV+3rfn7HfDqsHxrMsB59jngCvjkZt4+MhUf+Zs1d0nIiukN/ODgCN/I/Y2sRyAxXp3xw1VrMgZT63usSoiDt6e6PthIr+UpUjSpcLAbH3h0dVmmPqkWGGH7X4isS3NVOjMLy3P1ymI0bBj487cFQ9Rmn7c0D0ktAX+4dpWPYzvdS+BoTA/Z+5h6Hki7zSN7gU1vx+EMmUaG/NA6VEEa9rZ7hCa02WgkZizXtyK7M9RSGLL6DSU53QQwIa5yh4nBKxFbnnNDdbkilcCGz+dl7/RtgqbJKO3nIGZsHAYxeOBbqF5RGrwJtqZwivAR7XtNVwqkubqh2vyZQLWdS+D7sd3V6iJW4m1HEY3TD3JG+ZhIewhn3JdywqIhE1tTqobpvfpF6kYPbHkgzRHuc8uWV4SB4nXEDLeQM6O5OyMitNDqKhNwKIcXpa+9K8J7rfETaqwcJ6uphW+yFSVkYro2n7syYLJ07J+BASuBpTEML+M3HsUKzB06jU9mujyoBWOAp/XRMxViGlqlpqAhS1QIiiqjrY6p7rBiRBBH/UP5IHzHzodU/y9Mozqs+jULr4xobShVw7ZH7bl9lJfPV7yEtYEU5qdaAC8uzZa7m73wSVcrFjvWdSAjlBdtvjkJ+A0a/wjzTuUnAwDtYdoEJ4mk2B7HndccfcDe7fBtnn/+ykOPcApWjR/DGKbZzwHoA1cAreP8UgFno6ph+fDSjVjcAtQNP421/5HLQpiyVPWRB1Gsyd8tMpDolQv9ePrmpxrUdM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(366004)(39850400004)(53546011)(6916009)(6486002)(2906002)(186003)(8676002)(4326008)(5660300002)(8936002)(316002)(66946007)(66476007)(66556008)(44832011)(31686004)(2616005)(36756003)(86362001)(966005)(83380400001)(38100700002)(478600001)(6666004)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WmhiOFpEMG5VZWdjRnFhNnZDVkVBZjZ5alpKTUJYYjNGalhud0VsWXpXQnVz?=
 =?utf-8?B?T3A4VkN3d1FIODEvNlRVaklIb25JVCtHOWl2eStsaGFYNnZkN2FGa2g3SWpY?=
 =?utf-8?B?ckRTWUdKdGkyeWlRY1ozQkNwdUFnNTA4Z1VSMkJjNVVyQU45MVNNRDhUM1Nm?=
 =?utf-8?B?bjRnWkNtVlV4RXU5NDZ3c1FhbERqc1FwVE5CNHI3aWpzY1dUL0ZVRmEvTUJF?=
 =?utf-8?B?OVNzRVF3L2QxWHFESHd1MForbzliSDRGQXc5VlFJN2E1MDNIQkhMQ2owY1Bs?=
 =?utf-8?B?T3pYOERKRnBPNzZCbEtQVjh6UkVDRG1wc3ZKR29TMWxlZGZXWVoyRlBDdzNj?=
 =?utf-8?B?U2hibTQ0TWlncTRqSGZ0RXZ5cVJjOU9rREhzVnZIVk9ITzh1K0s3c0hZNnNx?=
 =?utf-8?B?cFB1NTVvSTBURmRzbUdjZUhSWWRNQndCY2RReEh0Z051cEZOSTAzclhRYk5P?=
 =?utf-8?B?Y3lieHEvT1k5QzV1d2pYd2h6SkJIMG9UdDA5UERQa3ZmdlJBdlE0K1VhQ2Iw?=
 =?utf-8?B?dFVNTk5Hb1ZiamFjUmpFblJkT0Y0ZlRmTEJZQkd4aVo5U2t0Wk5QRDc4Wkty?=
 =?utf-8?B?ek53a3poQ2RVQjRsbzJsTDRmb1lJKytzMlpsc29LOFR1OFU2NjkxOGczWFZt?=
 =?utf-8?B?azRRQ0N3OUc2bGdKN21lcWRWOFRtOHNteG42Y3JXTmVqcEhVMHV4U21majBl?=
 =?utf-8?B?VXJlUC9GOTNiSkVWenRLRFEyUmk4dEdUR0dDSStQRW13Tzk3K2p5UlRoSUVn?=
 =?utf-8?B?OGFseDdoUGREQkRTZ2pOMFVkdnJJa3dJVnNDQnM0Z2ZGUE1VNms2OGpSaS9s?=
 =?utf-8?B?OHc4RFBjNTh3c3JQRyt3K1BZWWRxd1J5VmNNOGZlcldkUlh2TzZrTW56T0Rs?=
 =?utf-8?B?QzVDOWRuS3JaQUpJb2NDTVBzMGE3RDREUmx3MDcrbll4Ui8xL2I5cm5aZTF4?=
 =?utf-8?B?b25YK3dqM2gvTHBYN3Bwb3NhUW93bVpxLzM3eHVGWE9QZXlEdGpTMk1MTzFz?=
 =?utf-8?B?aDdLSk1BNGJUcytTTHZ5ckVIOGYwaXRBbHM3YTZRSk1zYVJiYlpzN1R5MUta?=
 =?utf-8?B?eEkzVkNudlZwT3hlcDdnWjBJb0pDRmUwSGxKYzJkRXJJb2F3WFZsdzdROWdX?=
 =?utf-8?B?OEVseGFoRzMwNmpIaVdTeW11a2Rma1lIVTVibXdkY1VuVkYvOUw5Mm42cjY1?=
 =?utf-8?B?Z3d1VzRzUjdpL2JxM2JhSUZudHB6OTNPN2thTSs3amR0WmRaVUFZQW9TVTU0?=
 =?utf-8?B?N0dUVmQ5eDN3TU45SFBRNmd6bVZhbTBmWHJwR1dTQ3d2V0FuL3ZkTVZVbDk3?=
 =?utf-8?B?VUluam4yR3Rqa1FGMXU1OGJhY25OTW5MMlp6TFgzcjF6SjA1SDl4c3ZHNGRN?=
 =?utf-8?B?QXZRcUJmZmZ4N2JKZGhwN3RBMkF5ejZqODEzNTA2Ym5Sc3NhaWo1WFZaWDUx?=
 =?utf-8?B?WXdqdlVlbmsvZW1Hb3M4U0ozREdBQnB1em9FdGlJRS84L2QwQmJPK3VRRUwz?=
 =?utf-8?B?YUNSR3VlL1BiNUEra2JoaFZzMWY0U3d5d21mZmt4dnRHOVR2R0c5YWVwaXhC?=
 =?utf-8?B?Z09XOUVVYmpESzNsMzFmK3B6TEhNYUNRbGE4dFJCbHN1eEZjaUp1MTlSQUgz?=
 =?utf-8?B?N1dycUk3TGlaanFhM0p4TkdqaUp3R3R2WnFxZW5kS0VMMmxSYlNxOUlHQzJ1?=
 =?utf-8?B?bFVEQTRrSzg2NzFWNXhUVHJuak9rR2ZsMUMveWNHTUtzYVBjWEJLQTU5TWVk?=
 =?utf-8?B?cGZqOVh2T2hIbk9HNWM5TUZkdFdUWVdjY3QwUFA0OURPZThPOUhHQzJ2TlJU?=
 =?utf-8?B?aitVTGhXM1prem93Nm5NUTF6ekpZRitQT1ZpMDVyUm9kK2Q0QnFhRUljK1o5?=
 =?utf-8?Q?wcA55TlD9OyUD?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6316b32a-ee15-4800-35b9-08d95db94d84
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2021 17:47:50.1404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lYuciU48roG5J+hJHYpNKzSNH3z0gSA6/OnyHK52d51CE+NNdeZIQs2TBdKaWP6P3IOBOKar5XKxH8hqGbDKFDLj21s5n/MiqnjjHudwUVE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5325
X-Proofpoint-ORIG-GUID: nlrIMsoEbPS4CbLXbmJvAHBu4iBt3n0Q
X-Proofpoint-GUID: nlrIMsoEbPS4CbLXbmJvAHBu4iBt3n0Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-12_05,2021-08-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108120115
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/12/21 8:41 PM, Ovidiu Panait wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
>
> commit b1bd5cba3306691c771d558e94baa73e8b0b96b7 upstream.

I forgot to mention that this is for 4.19 branch, sorry for that.


Ovidiu

>
> When computing the access permissions of a shadow page, use the effective
> permissions of the walk up to that point, i.e. the logic AND of its parents'
> permissions.  Two guest PxE entries that point at the same table gfn need to
> be shadowed with different shadow pages if their parents' permissions are
> different.  KVM currently uses the effective permissions of the last
> non-leaf entry for all non-leaf entries.  Because all non-leaf SPTEs have
> full ("uwx") permissions, and the effective permissions are recorded only
> in role.access and merged into the leaves, this can lead to incorrect
> reuse of a shadow page and eventually to a missing guest protection page
> fault.
>
> For example, here is a shared pagetable:
>
>     pgd[]   pud[]        pmd[]            virtual address pointers
>                       /->pmd1(u--)->pte1(uw-)->page1 <- ptr1 (u--)
>          /->pud1(uw-)--->pmd2(uw-)->pte2(uw-)->page2 <- ptr2 (uw-)
>     pgd-|           (shared pmd[] as above)
>          \->pud2(u--)--->pmd1(u--)->pte1(uw-)->page1 <- ptr3 (u--)
>                       \->pmd2(uw-)->pte2(uw-)->page2 <- ptr4 (u--)
>
>    pud1 and pud2 point to the same pmd table, so:
>    - ptr1 and ptr3 points to the same page.
>    - ptr2 and ptr4 points to the same page.
>
> (pud1 and pud2 here are pud entries, while pmd1 and pmd2 here are pmd entries)
>
> - First, the guest reads from ptr1 first and KVM prepares a shadow
>    page table with role.access=u--, from ptr1's pud1 and ptr1's pmd1.
>    "u--" comes from the effective permissions of pgd, pud1 and
>    pmd1, which are stored in pt->access.  "u--" is used also to get
>    the pagetable for pud1, instead of "uw-".
>
> - Then the guest writes to ptr2 and KVM reuses pud1 which is present.
>    The hypervisor set up a shadow page for ptr2 with pt->access is "uw-"
>    even though the pud1 pmd (because of the incorrect argument to
>    kvm_mmu_get_page in the previous step) has role.access="u--".
>
> - Then the guest reads from ptr3.  The hypervisor reuses pud1's
>    shadow pmd for pud2, because both use "u--" for their permissions.
>    Thus, the shadow pmd already includes entries for both pmd1 and pmd2.
>
> - At last, the guest writes to ptr4.  This causes no vmexit or pagefault,
>    because pud1's shadow page structures included an "uw-" page even though
>    its role.access was "u--".
>
> Any kind of shared pagetable might have the similar problem when in
> virtual machine without TDP enabled if the permissions are different
> from different ancestors.
>
> In order to fix the problem, we change pt->access to be an array, and
> any access in it will not include permissions ANDed from child ptes.
>
> The test code is: https://lore.kernel.org/kvm/20210603050537.19605-1-jiangshanlai@gmail.com/
> Remember to test it with TDP disabled.
>
> The problem had existed long before the commit 41074d07c78b ("KVM: MMU:
> Fix inherited permissions for emulated guest pte updates"), and it
> is hard to find which is the culprit.  So there is no fixes tag here.
>
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> Message-Id: <20210603052455.21023-1-jiangshanlai@gmail.com>
> Cc: stable@vger.kernel.org
> Fixes: cea0f0e7ea54 ("[PATCH] KVM: MMU: Shadow page table caching")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> [OP: - apply arch/x86/kvm/mmu/* changes to arch/x86/kvm
>       - apply documentation changes to Documentation/virtual/kvm/mmu.txt
>       - adjusted context in arch/x86/kvm/paging_tmpl.h]
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> ---
> Note: The backport was validated by running the kvm-unit-tests testcase [1]
> mentioned in the commit message (the testcase fails without the patch and
> passes with the patch applied).
>
> [1] https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/commit/47fd6bc54674fb1d8a29c55305042689e8692522
>
>   Documentation/virtual/kvm/mmu.txt |  4 ++--
>   arch/x86/kvm/paging_tmpl.h        | 14 +++++++++-----
>   2 files changed, 11 insertions(+), 7 deletions(-)
>
> diff --git a/Documentation/virtual/kvm/mmu.txt b/Documentation/virtual/kvm/mmu.txt
> index e507a9e0421e..851a8abcadce 100644
> --- a/Documentation/virtual/kvm/mmu.txt
> +++ b/Documentation/virtual/kvm/mmu.txt
> @@ -152,8 +152,8 @@ Shadow pages contain the following information:
>       shadow pages) so role.quadrant takes values in the range 0..3.  Each
>       quadrant maps 1GB virtual address space.
>     role.access:
> -    Inherited guest access permissions in the form uwx.  Note execute
> -    permission is positive, not negative.
> +    Inherited guest access permissions from the parent ptes in the form uwx.
> +    Note execute permission is positive, not negative.
>     role.invalid:
>       The page is invalid and should not be used.  It is a root page that is
>       currently pinned (by a cpu hardware register pointing to it); once it is
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index 8220190b0605..9e15818de973 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -93,8 +93,8 @@ struct guest_walker {
>   	gpa_t pte_gpa[PT_MAX_FULL_LEVELS];
>   	pt_element_t __user *ptep_user[PT_MAX_FULL_LEVELS];
>   	bool pte_writable[PT_MAX_FULL_LEVELS];
> -	unsigned pt_access;
> -	unsigned pte_access;
> +	unsigned int pt_access[PT_MAX_FULL_LEVELS];
> +	unsigned int pte_access;
>   	gfn_t gfn;
>   	struct x86_exception fault;
>   };
> @@ -388,13 +388,15 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>   		}
>   
>   		walker->ptes[walker->level - 1] = pte;
> +
> +		/* Convert to ACC_*_MASK flags for struct guest_walker.  */
> +		walker->pt_access[walker->level - 1] = FNAME(gpte_access)(pt_access ^ walk_nx_mask);
>   	} while (!is_last_gpte(mmu, walker->level, pte));
>   
>   	pte_pkey = FNAME(gpte_pkeys)(vcpu, pte);
>   	accessed_dirty = have_ad ? pte_access & PT_GUEST_ACCESSED_MASK : 0;
>   
>   	/* Convert to ACC_*_MASK flags for struct guest_walker.  */
> -	walker->pt_access = FNAME(gpte_access)(pt_access ^ walk_nx_mask);
>   	walker->pte_access = FNAME(gpte_access)(pte_access ^ walk_nx_mask);
>   	errcode = permission_fault(vcpu, mmu, walker->pte_access, pte_pkey, access);
>   	if (unlikely(errcode))
> @@ -433,7 +435,8 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>   	}
>   
>   	pgprintk("%s: pte %llx pte_access %x pt_access %x\n",
> -		 __func__, (u64)pte, walker->pte_access, walker->pt_access);
> +		 __func__, (u64)pte, walker->pte_access,
> +		 walker->pt_access[walker->level - 1]);
>   	return 1;
>   
>   error:
> @@ -602,7 +605,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
>   {
>   	struct kvm_mmu_page *sp = NULL;
>   	struct kvm_shadow_walk_iterator it;
> -	unsigned direct_access, access = gw->pt_access;
> +	unsigned int direct_access, access;
>   	int top_level, ret;
>   	gfn_t gfn, base_gfn;
>   
> @@ -634,6 +637,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
>   		sp = NULL;
>   		if (!is_shadow_present_pte(*it.sptep)) {
>   			table_gfn = gw->table_gfn[it.level - 2];
> +			access = gw->pt_access[it.level - 2];
>   			sp = kvm_mmu_get_page(vcpu, table_gfn, addr, it.level-1,
>   					      false, access);
>   		}
