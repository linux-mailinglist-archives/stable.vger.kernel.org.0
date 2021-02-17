Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76B431DFB8
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 20:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhBQTjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 14:39:21 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:41178 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232666AbhBQTjU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 14:39:20 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HJYFiw073287;
        Wed, 17 Feb 2021 19:38:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=lpMtBpC+WzqiPoHCCPx06/mvdXnLp3LFyR4ZBNti+Vk=;
 b=LU9jPPwoF4Z877J/fuuL3ZXZhKUFtfcysT6vIkxxwvtO9850Ix7L1XEqARrAWzNwrP8J
 YQupxbn3CfHWpt2nJaVN7qIf8pceTglSi9fXTpzaqdbUiGo7JLga/wYMRO6EdS1Njr5Q
 DbwClExaEUnrRYvXGljGL2UQrJP9ETpDwauBqYuUbMAjfGtwE+LcWSasUQiHJu9kHWjD
 xmf0oc6muwo4cnQ7/BusgDlJWOyb68uwwcDm/cqGJRIG2ErngW1kedL05RNMqhOGrK4T
 ICLiMoVJsMgVo/h4Zs7CQcBrbKpYFm4NZBoIvKYa9ZAEq1wskVUpFvgp9Z66yUR27xE+ CQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 36p7dnkjbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 19:38:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HJaOYZ191047;
        Wed, 17 Feb 2021 19:38:20 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by aserp3030.oracle.com with ESMTP id 36prbpvdjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 19:38:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qihiadu6+goEQqj1siymRrX2nQ2OPDFiPTuS+/0DAevd4WY32LKXfk0zp0UJuSH0f9MZeISzaPLF3vyw76wEx4gYs7vFYJZvcYgHQM+VyfxCV5HKKhfdni+skO8TmZnh/uHEtB0kJYv29bZXPnt49sJDxpGYVm1bfwY2t4c/WeMQYBc088AYeDzGdTj2TpUlrr2wdHss7R0k+yNbjHZRdx9K92BURrTbhg51AXh91qTZ9GQcllcGXAko1f8dt1F6r8TLGLGNH5FU3mdiiQEEEWyaaUpbzlkWyilmO7BI+UQMe1CKQ5rZMVTgaPJiTPyRWtLTN2JA+o0bX7tpFvNBvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lpMtBpC+WzqiPoHCCPx06/mvdXnLp3LFyR4ZBNti+Vk=;
 b=N96dwtZ6e8mAybwpJczNr4r1eQQosheDEQeNqv9HGH/R0/vYw5fQhjK3lL5p64zhtRIiMNsNwllwfouhnMHHB4bi1bTbLaGRscRk06PcXvTD5KD42/k7PwC2JXqW7lbMCndloiezGzI7AO4o4lut80QjSb1UolEaXE7AX95kw0ziaDC4MJIRQsHsBE3cGAXL31uCWe4caeFbYLlJOrkptDp8Jc+9XbdZK7E/eZJDWwR24nJ8tv5FheQluUuPE4Pl2u/4ausA1tBfka3OLl+9AG1X7KKORZCLlS06Atk2m4p7lVcT8BgovoKBeHUzogMwgkMw0YybkY7kKbwch3vFbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lpMtBpC+WzqiPoHCCPx06/mvdXnLp3LFyR4ZBNti+Vk=;
 b=p0dz+YVkyT/VJ3aAHFe+6r2cYjPKT7mwJJU41XXvDSLpsqrpGpl8RYTxV5VcF1KP4xnoE8YKMQy1aGLia8THlmNuOqJsIEKWXKFPpfNzrBrngBWBeJw87eBTm4BjAuduZqhSTPMqrEZzyDsl8qus5NY3kih4moSqz8i+16cuZn0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by BYAPR10MB2824.namprd10.prod.outlook.com (2603:10b6:a03:8c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.31; Wed, 17 Feb
 2021 19:38:18 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::e035:c568:ac66:da00]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::e035:c568:ac66:da00%4]) with mapi id 15.20.3846.041; Wed, 17 Feb 2021
 19:38:18 +0000
Subject: Re: [PATCH 1/2] hugetlb: fix update_and_free_page contig page struct
 assumption
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Zi Yan <ziy@nvidia.com>, Davidlohr Bueso <dbueso@suse.de>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Oscar Salvador <osalvador@suse.de>,
        Joao Martins <joao.m.martins@oracle.com>,
        stable@vger.kernel.org
References: <20210217184926.33567-1-mike.kravetz@oracle.com>
 <20210217110252.185c7f5cd5a87c3f7b0c0144@linux-foundation.org>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <1da7b36c-f86a-90e9-cfa2-4ce49bd6f1d1@oracle.com>
Date:   Wed, 17 Feb 2021 11:38:15 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
In-Reply-To: <20210217110252.185c7f5cd5a87c3f7b0c0144@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [50.38.35.18]
X-ClientProxiedBy: MWHPR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:300:95::12) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.2.112] (50.38.35.18) by MWHPR13CA0026.namprd13.prod.outlook.com (2603:10b6:300:95::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.12 via Frontend Transport; Wed, 17 Feb 2021 19:38:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e342d90-d5e6-4e25-4a19-08d8d37b9381
X-MS-TrafficTypeDiagnostic: BYAPR10MB2824:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB2824316AF58EAB1F6EFC5B1CE2869@BYAPR10MB2824.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T9ABwtvMxE6WrE/2VOSmTif5EsxCUwTqi5oX9l8PshjsomuBf9izn/35cdM46sO9DYoSbQLUUHHk4tNGzkM0JTRgc6N+2IWVw7lRNpSum3GAqQTmdqaGjLJX58C8BwxqaIryF3ILTzTVunkYMc2nWL9sbuB8wuKsSyW7m5TsXDU7lbCU8jcVNhCnSRUUX2e3NQemlX4JKbB3uYc0SjGx8x4iFh7a+8rSM2R1yPS6x1UXYfPF9lDzXJQG3C9ZluJr4IqLZHVSbVnC4iRGkyokyP5Chg1RSbxzl2Ixy28O01jGYaMtmLrPAAD3i1F5lO8zcUVkUaKjlOrG+bOCeHGktlOqEamKaHMPodIl2bCwvJgM/naj8rjnCMXlPoWnqhxom9SH1B+que7++UbComQRwS5NXpQrIxLcYw+7r6JbKYndqpkuFjAOv7OsmcYRKAxhdJ0LTp/drL1FvujCxpKGvp6MFwZqT2UC/bDRL4eBctV3QqITHRM/TxdoGt7Z7EnfDcvieyVgSaqeNFiVGLRvFyqO1UJSJrhr04GZf3YWtw2Cm6dlALwv4grzkbGgRePEoOQelXOxbw3k2EQBRaJiqojXP7hESoHAsGIY+PCTxGm7f/OULF4y/Db5mqNjAszf3TfaBhF34DgR+KbNjvQwJJaiIU8ZUED4K+Bf2xlZDYNpREp7hXgWYVSukm8Hhmml
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(396003)(366004)(346002)(478600001)(4326008)(31696002)(16526019)(83380400001)(31686004)(52116002)(966005)(5660300002)(186003)(956004)(6486002)(2616005)(2906002)(53546011)(66476007)(8676002)(66556008)(8936002)(36756003)(26005)(54906003)(86362001)(15650500001)(44832011)(6916009)(316002)(16576012)(66946007)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UGQ4R0MwSDJNNFBvNTAxY0hOSDlIbGJocGdMcmlheVBlQTNrS1NoK0l0OHZ5?=
 =?utf-8?B?Y043ZUN5S2E2SE4vSUtiQW53Z2t6bmFQNzNzY2V0R0Z3eCtnQThsZG95THZR?=
 =?utf-8?B?Zm5Vb3VCdzlscXVrQlZqQTV6NEZkL0d3dnFCVTZSTlp3bE10QXZuRnhhazBQ?=
 =?utf-8?B?MUtXWDNlekVhb0pZSVlRTjRpQVJqTkk0U2ltR252TWFXWCszMVUxRlZxN3pl?=
 =?utf-8?B?VUs1dG03K3BvMDNIWWlYQjRzZjZKblBpckhaZzg4dGJpb08yQlNoVlZKeG9X?=
 =?utf-8?B?OHdWQzI2MU1UYm8wYjluZXJ0Y0ZhQVdLK3VtQmxRMWM3cmdPdnZIb0E3ZllI?=
 =?utf-8?B?UGtiUjlJWjY0N1RLWmk5bHUvcE9pMHlSaVVsY3BlMmRteHJ1Y1ZBVUxkY1Bv?=
 =?utf-8?B?TFphWlE2WmhrYWNVNXpiUEc4WTg4U2Q2SUxyV3N5elRvakRQb3VCc2szeHI3?=
 =?utf-8?B?OWNsbmk1NHFtaURyRzIyL3JDVGlYQ0Y3Nm4yQUFEUS9MVG9PUFlMK0VrVHpY?=
 =?utf-8?B?SDgyVGtoT0poR3NKS01yRHhZc0psekxhKzJiTUtZSlB6b3gzYmg4cHU2Yjk2?=
 =?utf-8?B?L1lyRjQyTEYzOHhNbEV3ZHV6VTlNWGtoZXBDY2JxQnBOSXJ5UDNjSzhuRll1?=
 =?utf-8?B?UkJibWpzNkRpeG52aTRwNGxWVmVnS2pyaHBvMFFHdWxNR1ZkQ3pZY2J6Mm9W?=
 =?utf-8?B?MGQvcVpoNGkxcUdNOFIvZHBacW4rUmVkSitEWTFRd1ZWbUl2N1haQ0xrNFZM?=
 =?utf-8?B?b0I5YU8wUi90VDBnY0xkNVdQWVg4Sm04TnhrVCsxR3VUQWdlV0Ywa010cHps?=
 =?utf-8?B?OVIxSUkxbEZnK0VTM3ZBekxMYTc2dHJXSFV2MkxWMlhxbHZOd2V2aHVaTzFm?=
 =?utf-8?B?VVF6bExvMlFMYXJiT0UzUEZrSU13QlVGUmpvc3lqajQ1Q0RsVGh4MXg0Y2N3?=
 =?utf-8?B?UmVsSFBkdGFyZGlSQ3ZLRGZrbWZMV1VkNmlUckJPMk5vNTVzdXJMejFxSnUw?=
 =?utf-8?B?SHR6OXVRTEFMQVk4d2xxd0ZxVHVFOTJzWlVKWUsxcTQzdUtpMDd4RHFRSGtr?=
 =?utf-8?B?czU1NFlaUzlEbUZUQi9IMUN6MDV0MXpsdzAzVXRXcnZJaUsyK1pOYXUyYkF2?=
 =?utf-8?B?aEFkb0IrLzdWMGc3R2VaalFXeWZFcVM5TjUxZ3ZUR1JiSXpxbUcvNEc5ekhz?=
 =?utf-8?B?bVp0dEJoK2NpZzFDSjhsNkxIL2hHTWo3ZElhTkhXQWVPd2VCcXhuUUNYR01D?=
 =?utf-8?B?SnR2NnY4c1JUUzgrYUZtTDIyRHlqczdiaUdjaG4yRWV0SE50RStIL3RUUnlr?=
 =?utf-8?B?WklQMlFzSm1PNUVOZFRnaFA4VUhsNGRNMWRRY09MK1lLL1p3MXpSbEp2RmZn?=
 =?utf-8?B?SWo0RFl2TWM0Y1RUbGlReC91SCs4eWRMa1NjMlZGa3BSbWlyK0NkTWdrOUJp?=
 =?utf-8?B?cnlwMkRSYThuUFk3bzBJMUU4SUJyejk4NllXc2Q2OGZDNUcvZTdTcjVBQi9P?=
 =?utf-8?B?NkRSN1duQk5ZNU8zOGRVVG5sWnBFNFo0TUFCLy9TUHM4SXVZRG85QWVIdVhz?=
 =?utf-8?B?bFJMVE4yZmhKZFpqMkZ0MmJaL1NQcHBjWDZSVmtRSEtVSGpnU0JuL3g1ektr?=
 =?utf-8?B?WWttYW5pUmtPdXF2aVU2R2pDcEg1SEJiVW5wMkpma01hbGxjN1AwMmpBQXZm?=
 =?utf-8?B?VTlwZC92Mk9GZXhKYUp4MTBkQlpXZnhlMHorSUlocWVuT0dQOWVqVmlaU0k0?=
 =?utf-8?Q?cu/smyVibKeqeozQbBBWF+8tEuiqCHYUAZ3CFla?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e342d90-d5e6-4e25-4a19-08d8d37b9381
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2021 19:38:18.3242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RHmTpt4VoDBYLZr4qQ/UFfnP+s99hioG//MWJf8Frx+AT+z/sDdZV1G+Hk67JG0oy2I0URKqR2cUr7JJx7ScpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2824
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170143
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 adultscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170143
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/17/21 11:02 AM, Andrew Morton wrote:
> On Wed, 17 Feb 2021 10:49:25 -0800 Mike Kravetz <mike.kravetz@oracle.com> wrote:
> 
>> page structs are not guaranteed to be contiguous for gigantic pages.  The
>> routine update_and_free_page can encounter a gigantic page, yet it assumes
>> page structs are contiguous when setting page flags in subpages.
>>
>> If update_and_free_page encounters non-contiguous page structs, we can
>> see “BUG: Bad page state in process …” errors.
>>
>> Non-contiguous page structs are generally not an issue.  However, they can
>> exist with a specific kernel configuration and hotplug operations.  For
>> example: Configure the kernel with CONFIG_SPARSEMEM and
>> !CONFIG_SPARSEMEM_VMEMMAP.  Then, hotplug add memory for the area where the
>> gigantic page will be allocated.
>> Zi Yan outlined steps to reproduce here [1].
>>
>> [1] https://lore.kernel.org/linux-mm/16F7C58B-4D79-41C5-9B64-A1A1628F4AF2@nvidia.com/
>>
>> Fixes: 944d9fec8d7a ("hugetlb: add support for gigantic page allocation at runtime")
> 
> June 2014.  That's a long lurk time for a bug.  I wonder if some later
> commit revealed it.
> 
> I guess it doesn't matter a lot, but some -stable kernel maintainers
> might wonder if they really need this fix...

I am not sure how common a CONFIG_SPARSEMEM and !CONFIG_SPARSEMEM_VMEMMAP
config is.  On the more popular architectures, this is not the default.
But, you can build a kernel with such options.  And, then you need to
hotplug memory add and allocate a gigantic page there.

It is unlikely to happen, but possible since Zi could force the BUG.

The copy_huge_page_from_user bug requires the same non-normal configuration
and is just as unlikely to occurr.  But, since it can overwrite somewhat
random pages I would feel better if it was fixed.
-- 
Mike Kravetz
