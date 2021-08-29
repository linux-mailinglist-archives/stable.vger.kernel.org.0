Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598D23FAC5C
	for <lists+stable@lfdr.de>; Sun, 29 Aug 2021 17:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbhH2PEH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Aug 2021 11:04:07 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:64770 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229824AbhH2PEG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Aug 2021 11:04:06 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17TF1Dd6023626;
        Sun, 29 Aug 2021 15:03:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=subject : from :
 to : cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=fMdtqboycR+HKnNa+LkmkoqSH/xqQhQsjbl6nX+VfOY=;
 b=sSAPVtQboRBKnGWDJf6Qu+f07wbW/RE9ct/iUaEP3Jj28qWNA7HuT0h44wpDzryhvVv0
 qEkoetlG92qSSul2/SJHqUjieW3a5Wk68Uj/vJlxfyJ9iuevKPI5VPo/WGAEhUTbkEtq
 UPBT7kqwmNNQY5wiFkE6mq2BQHIC6uczWxiKAk96EquiCJVypB65alsrzPjv28l70Jg7
 aWFA4k64eGbxecR1/tlmZN5stiDkqrpPP5rSR2/0wfIaChvBwvbXNkVyuqQJWZZEAf5U
 VxHI8JepScISUce5GvrUvC14BQOnYoIGPHOhmuHFgRx7DGdGG+19bmhSeS16nFn+7nrl 1Q== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by mx0a-0064b401.pphosted.com with ESMTP id 3ar9pjr26h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 29 Aug 2021 15:03:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TJlnGnUCKlQX6omqnfqs78IQ1JjM64C7gG9rXuwd5PKT3i8w7Q88Qv7d3wzcit4ap+FEmRKEy+OsGvbMMHUOdXBoqhiAYAUIrIc9gRAofiEVWC4C57npMI/ZtZUZtmdid2di0FO9x/EH6Yh182ONgeTgpXuwdFop0LDhx+uN+U75ITUSjiSNcA7TleUNPrtp55ZCmxG59yk7CEmx8alZrtLykPypniZcOJWzheQbf1YrNhe3V05t95pkR96CUOLryAxXhIStTNKtn5cNZkokGsHrmviBnVPlz9Fop8PvGiSaHG5tm7IOVSSppcS7p0Ex+JU5p21QixbQmIj7Dell7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fMdtqboycR+HKnNa+LkmkoqSH/xqQhQsjbl6nX+VfOY=;
 b=Knm7G42WgbkaYEq7rQlA5L6UDkS1xFXEeI8Fz4s3Aa5otMEa9bkkjP743gGKj8l3AS6U9ToFeqcOdmHVvYuMDbWM3tJ4TjolLfGW0x/3DnKa42A+MAW7caAYz7XpQ+GOLcZxEAygULVLyLFlEDCjZUSVFEMkIw93FpC++7C2TXOWqXlBcTX+aQGjM059BX8IXVcqjpFPyGdIn29beXUBYbOG6AbrVJyrCafKSNskEgnOz1Bwk8MESoUiTlDKeoZbQWgO+Ijq0YiEliqeBSaN/zm5zQKtksq8vicJPrQKBVs88DG8EvmZ0Vqr2vJ5TMIDohlgUvP/DnX2lGfJQFSecQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM8PR11MB5719.namprd11.prod.outlook.com (2603:10b6:8:10::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4457.24; Sun, 29 Aug 2021 15:03:08 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb%5]) with mapi id 15.20.4457.024; Sun, 29 Aug 2021
 15:03:08 +0000
Subject: Re: [PATCH 4.14] KVM: X86: MMU: Use the correct inherited permissions
 to get shadow page
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     pbonzini@redhat.com
References: <20210820131229.3417770-1-ovidiu.panait@windriver.com>
Message-ID: <b30ed8a7-8e5d-0ec5-ce22-f86cf850c424@windriver.com>
Date:   Sun, 29 Aug 2021 18:03:00 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210820131229.3417770-1-ovidiu.panait@windriver.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: VI1P194CA0023.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:800:be::33) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:2f07:6000:7c00:1c7f:b7d6:3463:b94f] (2a02:2f07:6000:7c00:1c7f:b7d6:3463:b94f) by VI1P194CA0023.EURP194.PROD.OUTLOOK.COM (2603:10a6:800:be::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.18 via Frontend Transport; Sun, 29 Aug 2021 15:03:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13a3dd97-cae4-4e84-00d7-08d96afe1c54
X-MS-TrafficTypeDiagnostic: DM8PR11MB5719:
X-Microsoft-Antispam-PRVS: <DM8PR11MB57191DF68F884F77D5906C05FECA9@DM8PR11MB5719.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KuCFBN0Gr/aM007kZYgyhXWA9uofiM/9ujX3FmmtK2ZOVZ7piNI34AJwejJ2eO4j+sdNI8ahAlfnMt5xVohj4TWzfI2zCAfru5fKxo+fzYTqDlAyoU8WOYzVhhJTSg1pVIIlC6JFM/3fiVwlUmQlC7DKtZ65XZ0Kso6n1zesTzwCAtclsc9YFWBco9RROryyrM7GzYrI+Zvev+HanxkQ21SUrp4HEbzNxJg1b+7oxN7a5HYH0Rm8ufE76Qy3rME74tyrB8cpU+eaQ6OJ8zCq+9156xJVpn4UX8DfH/pfyw5Cmuk3SKJ06O97LVCYUnR4jzAiiqf+cglaY2q4b0wkMsdNjv6hWWf6S8Rkdqia68BKtkiheYu/AYv0ZWsRKX1GrlU6Mqg2QrTRo3rYpKB/7gy6C0Cct7HSV0R/fTYjPM/pD/5JTXUzzYXzCA3QS9+R5eynirCmTEO96VNY77YnAAuknZTlhB+M4E1Bxb7R+iwvsUEGfcRycz10LR3RYG9F9l0NwgS5pC3Dowh/l59gEKPCMsa/IyxWn27VWBRlZyby0ovyEF6R3UBBuzZg3T4ACtuJhgJ4jNNzFO2AbCTGDoKacmeeIDbGx/vIeS+yPfz+ii6SszN+r9oQDFIUbaic7dQ2VsaAsPz7ODxkVhml7mP6HTmlgqi1J+htUxuhnUX42um0r6+SYtZqyUA4tZgI2/mFeQ2MVWRG9fxrQyu00iKQHFLhwfeamU6/6phj3TvazL9iV7nIuj5Dxeiey/R3Ota/nrlnveA9csRlBu6nUpaHljEjQGml/LZ7hisCy1neh+4s5eWzRFZ+Kd7KFbLeJWoM013mQNt1IfGXuR32hQxjpRqVvFp5UCR0EQfRGoA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39830400003)(366004)(346002)(396003)(136003)(4326008)(5660300002)(478600001)(8936002)(44832011)(66556008)(2616005)(66946007)(66476007)(6666004)(186003)(6486002)(36756003)(86362001)(38100700002)(31696002)(31686004)(316002)(2906002)(8676002)(53546011)(6916009)(966005)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TElwM0dDc1RPUnZFRWNaL0QyUEp0ck4zYzlLVFpBVWIwMm5yYzlIRVJBaFpq?=
 =?utf-8?B?UFlSc3BPenp0WUpLNXE4WXJPMG5oZ25paG1NdjZ6czhLMzR6VmdYcjdycklz?=
 =?utf-8?B?L1Q1ZGdHeU4weERrcjVRVDMwR3Npb21RNCs2NWoxUWQvNVEyZE9Oa1UvUHRB?=
 =?utf-8?B?SkhtU3JxWXJLbjJFWnRBdnViMHFoNTNsT3l5RWFhd1RmVzBoSk9UaSsvUVVB?=
 =?utf-8?B?aDVUY1cybWxJejdyZnVxNFRXWVVxS3FiV3BxNGg1TTBNUU9EMlFvZVZITjhu?=
 =?utf-8?B?UTJJdnJmajJrSWtsTno3UGN1WStmZlJ5YTRubTFVdmN5bFIyM1V1YTQwdjVL?=
 =?utf-8?B?WUx5MlJYZXZzdUlaaU40ekxiRW03ckJJcFd6UWFsdHk2Q3BRMDJNeUIvRVJI?=
 =?utf-8?B?TVk3aVNvQWFDUEVPa3hwWHR0S0pBOGVlNEdtQnR0dXdOUHhueWM1cHlGRERE?=
 =?utf-8?B?WFFaaWU2THY2ZXc2cTc4RUpUY2pRRU9IUnZNa3owK0ZuL293K2wxNVZ6cW5X?=
 =?utf-8?B?a2FRelBKVm5wMno0aXEwQWt6M1pZTGxVM3RyS1F1VkgwVHpRYjBVYWtsclQ5?=
 =?utf-8?B?MU1wajkyZ2RrdjlIK3kxTzdPcEFzNElnSDYzZkpaaWFKL2tTcmk4Y1BrUHVi?=
 =?utf-8?B?bldHY05oVFdXNHBBMGIvWlY0cS90SHZRcVlnSHdlZXNra3dJTHVUc2p4U2wr?=
 =?utf-8?B?UlA0NkhtcUZGRHdZVDU4SFJZYjlDanJvT0JTelduNUZUSFJmdzRGM0ZxSmhU?=
 =?utf-8?B?S3BPZi9YZU4vSUdsQ0dESmUxOGxUbmI0QmZzS2RpWnlnNm5qRFJYY3RxSVRU?=
 =?utf-8?B?Y1ZWS1p6andyTXRkK0g5bEZrVDVwNytTZndMTGRRSWYxOEpjUW9FMkNYdzRZ?=
 =?utf-8?B?c1UvRFNtNkYzUXR1R2tJaitWdVJQRjBvanQzN0ptL1lUb2ZVRjJ4R2NGcVla?=
 =?utf-8?B?MnZOS1BQQ3laWjdkNzlVYTJIcHhvSVo4TEs3V3FGWFFWYVk0ODdaYkVlU0tx?=
 =?utf-8?B?ZVJUc1ExbFhNaTBvdTFta2JxeGNVbVlDYVk1Z3JWQUUvb0dSMUV1MXg0eVcy?=
 =?utf-8?B?OWxqR3YzUlFVdFQ4UXJ5Vk1MN1FjMk1SUFo2WUpiSjZOaEY0WUtJTkZSbzRU?=
 =?utf-8?B?UkpSakJydU9tWEhHangxK2lCUnhnTFRMM3dNM1VpS2UxeVBnRXE5ektlY3Fk?=
 =?utf-8?B?VkFMSkVJN2k4V3pHb3dFL0M1NVhKeWZtTVJuOXRrUFlEYjltbmZISTB5cWtH?=
 =?utf-8?B?ZUtmOGFoVnNtSndhbW9XSkJCNXJqOEYreldqYW5scGMvQjg4TmRHb2tqbFBk?=
 =?utf-8?B?UU0xcmw2WSswYTNWbVBTY1FidnIyVnJrcXJxN2UzNDFPUXFJbEY3YzU3SCs4?=
 =?utf-8?B?dEdHekJkM3lwN05VR3FLbENSZ2RRbTg2UTZMRDh3TUIzYzRWU1R3UGxKM1M1?=
 =?utf-8?B?aDc2VnJveWdHZ0R6aU41b0FoMFdPRFIxTk01N1dYM1ZicnhQWm4wSG9STEVE?=
 =?utf-8?B?cFZORS9CVHRZejZnRTdxY3JKUE9wOWFyUDlpYlFteXdWWVEyTVhyR1RMcXRv?=
 =?utf-8?B?cUJlNnVXV0pCNnY2SVZ2NEhMYndvUnFGejFQQldRT3VwR0w3bDFkZjZiemNv?=
 =?utf-8?B?aU9vS2crNkVJTzBvOTRTVGxzU290ZzRzV3BrV3BVTHVVVUVNUS9vbkIwbERZ?=
 =?utf-8?B?RGVBcmdIVU5DVlI0K2ZocmVMbzdYZzNQT2NrODVaMEFOUzRnUU1HQ05VZDd5?=
 =?utf-8?B?WllMRGlTT0xqSFFwbVpzMDl3SHJOS282dGV6dGhiRlZ6eWg3WXZwUEJzSFNN?=
 =?utf-8?B?RkNRQlhadXdNeEV6RjdTcmdGWDJGUGNpeGhvb2xrWXREdjZKMVBpUzVYb3lk?=
 =?utf-8?Q?4vu2OCKvzucQE?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13a3dd97-cae4-4e84-00d7-08d96afe1c54
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2021 15:03:08.1092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1KFqTJL8akb1uV4mkbXB9z36Pu2cyv61a85ugpsoVO8PzHL1GdJYPdJniI8acQmj8PeAxuU7uba/WDgNi8Co042v7CNuxD2hFx1dz81ICJ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5719
X-Proofpoint-GUID: QGNSc1ArT59t4uQxVfOzSnhRunuZM9RW
X-Proofpoint-ORIG-GUID: QGNSc1ArT59t4uQxVfOzSnhRunuZM9RW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-29_05,2021-08-27_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 mlxscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108290095
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,


It seems that this backport missed the last 4.14 release, could it be 
considered for the next one?


Thanks!

Ovidiu

On 8/20/21 4:12 PM, Ovidiu Panait wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
>
> commit b1bd5cba3306691c771d558e94baa73e8b0b96b7 upstream.
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
>       - add vcpu parameter to gpte_access() call]
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
> index 8cf7a09bdd73..677b195f7cf1 100644
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
> +		walker->pt_access[walker->level - 1] = FNAME(gpte_access)(vcpu, pt_access ^ walk_nx_mask);
>   	} while (!is_last_gpte(mmu, walker->level, pte));
>   
>   	pte_pkey = FNAME(gpte_pkeys)(vcpu, pte);
>   	accessed_dirty = have_ad ? pte_access & PT_GUEST_ACCESSED_MASK : 0;
>   
>   	/* Convert to ACC_*_MASK flags for struct guest_walker.  */
> -	walker->pt_access = FNAME(gpte_access)(vcpu, pt_access ^ walk_nx_mask);
>   	walker->pte_access = FNAME(gpte_access)(vcpu, pte_access ^ walk_nx_mask);
>   	errcode = permission_fault(vcpu, mmu, walker->pte_access, pte_pkey, access);
>   	if (unlikely(errcode))
> @@ -432,7 +434,8 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>   	}
>   
>   	pgprintk("%s: pte %llx pte_access %x pt_access %x\n",
> -		 __func__, (u64)pte, walker->pte_access, walker->pt_access);
> +		 __func__, (u64)pte, walker->pte_access,
> +		 walker->pt_access[walker->level - 1]);
>   	return 1;
>   
>   error:
> @@ -601,7 +604,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
>   {
>   	struct kvm_mmu_page *sp = NULL;
>   	struct kvm_shadow_walk_iterator it;
> -	unsigned direct_access, access = gw->pt_access;
> +	unsigned int direct_access, access;
>   	int top_level, ret;
>   	gfn_t gfn, base_gfn;
>   
> @@ -633,6 +636,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
>   		sp = NULL;
>   		if (!is_shadow_present_pte(*it.sptep)) {
>   			table_gfn = gw->table_gfn[it.level - 2];
> +			access = gw->pt_access[it.level - 2];
>   			sp = kvm_mmu_get_page(vcpu, table_gfn, addr, it.level-1,
>   					      false, access);
>   		}
