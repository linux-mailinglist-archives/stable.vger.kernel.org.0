Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 488B7397891
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 18:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233301AbhFARA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 13:00:58 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:60828 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbhFARA6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 13:00:58 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 151Gwxcl182716;
        Tue, 1 Jun 2021 16:59:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=tKHQQ45jrEeuAMWug4Smsqv8kffMXpF7DFzJynRaygg=;
 b=RcCRpzY9YlaBF8qPjubJTIzY0Q7F7WDH5F1TVHBnnYshSaV7S2jDOGYesQPotJU/DEuX
 4UGBVodiGkv33YjPpQ1UeWJ5HbgD6GN+koJiumNLxtMscAVSN3UglHh8sGdxoRg9+CUC
 xaGnB3fpr2AIeuEtfwDISCGcFYJHT1paciaeWhamwCGJpOR1HGECQm9j1X5igo6dk3z4
 YAG5itcK54E+Eg687Rcwla8vkqlSkAdPfvY4qAwyMhGwfAA2MFEhCZcfhtPy2/4GHNkU
 OC4N364nDLgtSjjwsmNUAdRMPiq8BbCW43SI80hppnL1rFJxheJ2+6tr9tLqM5BbMqKc gg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 38ub4cp8pj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Jun 2021 16:59:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 151GoiSZ161872;
        Tue, 1 Jun 2021 16:59:09 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by userp3020.oracle.com with ESMTP id 38uycreypw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Jun 2021 16:59:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=md46dTfASo2lfQVkvM1qZNLBewdJuNKabsG+WQJQVcbEW5JaWix6+c09qK98JBSDbv44YKW9toLiCLYFYkcY673QgqiOMQMnpu/Fl5LP4d1dc97jiystH3lyWMa0OkkejYuzkm5G3Nat7LYKw3rn6L+5Scr4PEky3bCGXO6AknVFH+NygFG2aLDiOVQ1ro8J6hXa632eYw3AeJxGwSnNshjSfXOlTXtR2zZbM+0achy47J0hf7zLBQYOuuPr87zlAygH/6WUnY+7pKdxx8pg1s0GoMu35UtgSINUYujvbmyWrBqdvYDzXNwZcJvo1jpn9Ge+WJdtIhfArfJ+GgHEEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tKHQQ45jrEeuAMWug4Smsqv8kffMXpF7DFzJynRaygg=;
 b=DYjYFrKb8iG2bd6h+Ko1uf+SX0Otgn0q1FvSmCEcsHQRBOdMuvsNhYWGIKSVJlaoMgWvNNuIOEdoRf0sL400cm98lc7WKIDqjkOvGM/+jb8qb4XEALwP/66DeF2N/qycryBGl84nf4PDwVWxz/LpCYqna3yYbAB2dRAgSpEj8WC5iPZDEgh81ddRyWg9Uyzgl0iL2ClEwmsc+OPC5Le221gcrLsM4U3QjNqspYN0aTgnnzZ6pHn39snqnNTfYTeyznMZ5oUwoxYiqR0sJFoafi2pkS7qUI7sFA3Vj4k6Kdb6cZ0ZPG92ogArvluL+bmaMTMBYODwKHylfVyKfxmhGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tKHQQ45jrEeuAMWug4Smsqv8kffMXpF7DFzJynRaygg=;
 b=DVf1NJOvGcm3QH1UK34bhohQt2OISv3LvIfgkRX60JfahdLQkGn/+dRtglLRWJraATWE18QR5imzqOpGlWy+il+VPY3wIltzj9/hnCB+/U4g0slTuD0e76anwaPt5oP5N0b5K1mrck+/VgAGo6KPGWdv+MVGte+6WWIzmkDQm1M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by BYAPR10MB3349.namprd10.prod.outlook.com (2603:10b6:a03:155::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Tue, 1 Jun
 2021 16:59:04 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::4407:2ff6:c0a:5d90]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::4407:2ff6:c0a:5d90%8]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 16:59:04 +0000
Subject: Re: [PATCH v4] mm, hugetlb: Fix simple resv_huge_pages underflow on
 UFFDIO_COPY
To:     Mina Almasry <almasrymina@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>, Linux-MM <linux-mm@kvack.org>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
References: <20210528004649.85298-1-almasrymina@google.com>
 <20210531173733.615fd539396ff7a173a2bf8b@linux-foundation.org>
 <CAHS8izO_-wK8GL9iK6HiG5xJc1unMLxO0uzFF20v4HKU36R8Ug@mail.gmail.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <a4460053-07f5-9bec-e080-60f61ba931b8@oracle.com>
Date:   Tue, 1 Jun 2021 09:59:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
In-Reply-To: <CAHS8izO_-wK8GL9iK6HiG5xJc1unMLxO0uzFF20v4HKU36R8Ug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [50.38.35.18]
X-ClientProxiedBy: MW4PR03CA0159.namprd03.prod.outlook.com
 (2603:10b6:303:8d::14) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.2.112] (50.38.35.18) by MW4PR03CA0159.namprd03.prod.outlook.com (2603:10b6:303:8d::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Tue, 1 Jun 2021 16:59:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 79605c8f-97f6-450e-6232-08d9251e8fd1
X-MS-TrafficTypeDiagnostic: BYAPR10MB3349:
X-Microsoft-Antispam-PRVS: <BYAPR10MB33490300CC0732E2D0AC4FABE23E9@BYAPR10MB3349.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vo0mUEDrflSnKrvzrJkH0LcH4YoC2p1ULrYElOt22ruKn/gHR/sgIqZk4qJJPv3knW50gNXQ6ArfJhcrgjycdDpGEfPm+WMLv9sz5lw7AYsIu4nnaiAqiFVq3MF2hFErIhyaSPQKAqfD8p/o5T+o5tSxDqcTbPpuQIj3ymQh4RB7KhhIbL2kM973nkkBohlJur84MAmLdRigsWSjZlGxsp16kyTo3JB6yQu2oAnVB3Ul+fW6FqshX1yYUOobMSZW2OYRZUJr0a9WXQPp4L6LKgnnZbu1nlc3fsv77saE5tPM5+jTq4ZW1Bih59djjhvzDVA5bsPO5KNaRYUWJf5PKMKIoktFmi90pucL9ugOVnu+1JTtk+KIkH8no9Byyw8Nz8DBrm360QUyzsFfAilTcndXGWYmOmbXukpG0GSXdxS0R6oDHUvpmvYu2Q17lEFa3xkWMB8hhNClY0ltqOf9QT21DNiC2fKAilazQV9a1JiCMzBz1S3CDoLeKUWa9UmC/X9lrJhI0LO0DSMvhquohNd6M3KJDAYvoE05T/B3dk+m7WDuFgNXGegM6kU1Xq241N+hJAbIGNvx4kr80N2reJKsyUlwNBazBclSrdrOQiqd3Upc8WrSPsJt6D11vFavSO2Cy/9XS/3omqVbADsRrgTlz4xKEKjqkCkr+WLJJJQ32GnveMbzwG0+2Gl7aOmHYyuxk8Hv6mg/B2Ipu3E4sPkAWe2L5MZ2ylSP8PeKqSw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(39860400002)(376002)(136003)(346002)(26005)(86362001)(36756003)(186003)(16526019)(31696002)(5660300002)(8676002)(4326008)(66946007)(66556008)(66476007)(52116002)(16576012)(110136005)(4744005)(54906003)(6486002)(31686004)(956004)(316002)(38100700002)(38350700002)(53546011)(2616005)(44832011)(478600001)(8936002)(2906002)(14583001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Mm9mcWFXd0o0aE9VOWhyN1BvRE00SkpHOGl4eDBEUStrbk1sMWZKMU9GcnJM?=
 =?utf-8?B?QTgyN2ExdFpob081cG1SSUdJQnQ1TVBiRHIyQ3NzL3h6b1ZMMnRmTjcrWUVn?=
 =?utf-8?B?bmFFMDVXUWh2L2V1Z2tMOU56U2daRkROUEdyQmhVZ1hqUEcrbHRCU3JHR1I2?=
 =?utf-8?B?M1B3UGtiMnZFZ05SMVJSN2g0RitYdVRpMnRpcXJFSDRKanFHcFd2aDJmSzRp?=
 =?utf-8?B?VEw2dU0zWnhnRVlJRmkzWDRwclh2MHZqb2FhS000RktZdXFrSUdKUkhtVXpr?=
 =?utf-8?B?N1pVZ1JTSTFyRHN4WjkwRGlUNlQ0ckMzc1ZiQUM4N0JlSUtSRURMRXh6RzNP?=
 =?utf-8?B?QitNY0FjUW11Mkx5R0hZOVlkbi93MjR3bkw2aWp0REFNdS9yZEwxbU45Zmc2?=
 =?utf-8?B?N1U0OFVNOXk2L25acHNodDIrRHJkOHlYVzB1ZnZWUUVDKzVBczY5aklhNTVH?=
 =?utf-8?B?RlNMcFNReklJYjY4N0ZRY0Fwd2Fja05Id3ZRKzBUSnNMeFRrc0dBSUthTlNE?=
 =?utf-8?B?Uk1ZMGEwTG5WRjluZkVYcDkrbFM4ZjRWS21oVTBzRDFsbUQ1SEVNOTNneEZR?=
 =?utf-8?B?bkN3dGRTcy95VTI3WC9JS2c0bmMzZGdjQnZvVTYwUFV6cmpic0ZkL3psMXJ5?=
 =?utf-8?B?NVlJSWlWVXc3Wk1tb1MvVEtoMUlIZWtydUNGQUZ3WTUwSFZ5T0E5T3JyeU11?=
 =?utf-8?B?emRJZVhUaVRvSHhJeDl3MVg2K3hDdWVZRFlVdURPY1dMZURZaGFVTkxNTHhO?=
 =?utf-8?B?OXRxR3A5cFYvdU4zcGcvYUVlUzkvR1k4dWtoTzRZS090eldybDBpVE0wSHNG?=
 =?utf-8?B?R2tDM1Y3eGsxbFJNdFBXU0R0ZFdmYWF2Z2crZC9PV0RiWlVIMS9XSGtJMytM?=
 =?utf-8?B?YXY5eW1sWDByZ0hmU2loZWpJN29HVHpEQzIwRzdFMjJGUzlZa0JROG44WCsx?=
 =?utf-8?B?ZFEzNHVDcEpBRy9RSFErcXBiK1hPZVpyNFJ0R0VudkpnUXhTcmtkdDgvS1NQ?=
 =?utf-8?B?Vjk2czh3dmxmdU80ZkQxdFljUGgrYjBoQnNkSXdzOXVBNWVyTkpwaEludmpl?=
 =?utf-8?B?TVdWRjNxSEwvQSs5ZUlEYjROM2htdkRidFNQbCsxNDc5MW1zWTFkZVNzL1R2?=
 =?utf-8?B?a0FubDBlZ1FNNUc5eVJscS9nbHFMN3EvZ0tLTnlVRmdHRTBlTzB0T1VweDRU?=
 =?utf-8?B?Q2dmVUpCUDVIZFI0ZGcxd0w3MmZDR2JPRXZaL3FkNTFpeDdscjBkUVh2NUpX?=
 =?utf-8?B?cEU1QXJNcFhNdUJHWVJoYTFUS2hDODFTc1BJQ1ZGT1lRM1lsTDlZMmduWWF3?=
 =?utf-8?B?eG1xaHhnY3U3cFk3ZFovb0Z2R1V1eGNjV1hCNXg3NTVyR1N0T0ZNYVkvWVV1?=
 =?utf-8?B?NVR6aCsyMXJ2M05ZWEk0OTBjUFRudG1YOG9PeEY1dktqeGI0WUZqc05ndC9K?=
 =?utf-8?B?VnlGUjVER0xnM2xxVE8zRFcwYkVqWUZPdGFvOXB4dmpXRi9ucndreDg5dUt3?=
 =?utf-8?B?UjQ2RzRKcG5RUktwanltYkxGanRuaWg2WnE5WGwyNUQ5Smh6YlRmZDhjeTJx?=
 =?utf-8?B?NU9MSHhWbHJRTkFBRUE3VUl0Y25jM0NGcEZJV2pjK0lsNllDZWNBNnpNazlN?=
 =?utf-8?B?K0J0OHBRQnBMdTZDYjd0NXJTOGRFMERuRVVKeDJnOEQxOExMbXh2Y3BHanZn?=
 =?utf-8?B?WWNabGFPNTFhV3ZhQ3VyZnRzRUMvUUgreTJYd3FuRUFqcTAzSWQyWlRnNTFv?=
 =?utf-8?Q?lJU7JAyLodgM6kesVPznMHLsRJLfJmcB7Y0HLVl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79605c8f-97f6-450e-6232-08d9251e8fd1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2021 16:59:04.3638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FFA2MSgQ0bcn+Ugrc7ygxXs0ctQZlkd4DB0bFHoVhMK5+J6qSduKr0OqbHKtF4rUzSllamqZbzKWMRjZc1PVmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3349
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106010114
X-Proofpoint-GUID: 93aHjSm8ipNHQ4mjc9ROv-rbLZrKiUND
X-Proofpoint-ORIG-GUID: 93aHjSm8ipNHQ4mjc9ROv-rbLZrKiUND
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 adultscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106010115
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/31/21 7:49 PM, Mina Almasry wrote:
> On Mon, May 31, 2021 at 5:37 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>> On Thu, 27 May 2021 17:46:49 -0700 Mina Almasry <almasrymina@google.com> wrote:
>>
>>
>> Do we have a Fixes: for this, or is it an always-been-there issue?
> 
> This reproduces as far back as 4.15 kernel. Looks like always-been-there issue.
> 

Specifically,

Fixes: 8fb5debc5fcd ("userfaultfd: hugetlbfs: add hugetlb_mcopy_atomic_pte for userfaultfd support")

-- 
Mike Kravetz
