Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5D3E39E887
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 22:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhFGUlR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 16:41:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54430 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbhFGUlR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Jun 2021 16:41:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 157KUrM0135397;
        Mon, 7 Jun 2021 20:38:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=st1vmdQ/TLv2aJ1rbsT8/ndzVzauLSexX38lbS+rM7Y=;
 b=zyy0w+RwvSbmrd/mLsI3y6517KbVUcKFAC7qoOLXyNia5quQfzKXa1rKN0qbyl6B2sBu
 2w95O/N+bPZayZUjlfwLmvYwP9lEchmiyw0/i/tZqVCHAFtuiKZ0GU33B2ZowF1rqB9W
 cJrpb8EgozEkdKJsn8rpR/V6kVGnS62XPmZxWV9Ou18UC4Wh4UG1dMAC6Ry1yhBl+Qut
 NZWpnKhfVRMwytFzawX9DFgFDJv4CqLv1U1t2w5cLLwreIR8YtrjheDMt2OgmjecLRFr
 lSdODniTp/0VbE/a46UkAtx2MmXdGF6Lk65uWAknIEjxKYtgVXjIGucL8I3qUPgc3mbp fQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 3914qujkqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Jun 2021 20:38:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 157KUuSC031753;
        Mon, 7 Jun 2021 20:38:58 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by aserp3030.oracle.com with ESMTP id 38yyaacb4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Jun 2021 20:38:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X5QGzxtUBpyIBmTGgFJeZIG22P4d16qfBlVWGDxk7QKBNC0APbvVSgi74oS5gBzs9tLQGfWNmnN9yuyTwZC4ThqmZzliBr1iISCZbQusRVRA/CxYgiD/4a/2gbVf91b2Q35BHYkDbiIypdR+H/j7lPEK2dr9DABZLz0NRxbLJv/59DKvlaFvrKVrWe8tpp7j/WDkS0VZz33sNYu0+Wi/twM4frwMcPzk/J28Z24i25ntsxsMrJweV7Xi3K3FaNY7NQaZ5Z+hn+gpEtmEVoH7B8+Kn4ujiFvlj6hj5BQiqZkp2ueSZwj6XOQm6d0BaLZVU0hAWoNiGLPa92by9S8TiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=st1vmdQ/TLv2aJ1rbsT8/ndzVzauLSexX38lbS+rM7Y=;
 b=UKXYvWv0/Ub/MmLttAO9r7c8Kc0o7DmgqivwrEXEzejHuWBqJwuElqE34W23mdd1zZrd+TvkcKHLuYQf/z/Mr2xhuG7nLD38pTShBZGSOMLZBUR0ebEs/nLZLz2Jo/FiW4zNwm9jFOAB0CHxUpq81Wab4KlXnGrWy9N1k1uVoTzhAAYHFHu/EnzzE5y8/L1ICgb4LrKxuvixrHpRWZ7vuiRN8PoVjLw3ojZ2Fa9+wDLc9LrmEcOdjxcMLALx3LBdP+O7h4fn9lvraMffmMEihzICLH2i08Q4fWUbSNSizq+WcswbbQdTaVsP3pDbSk9JsOiQzJsDGLCyVXMf9QfgEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=st1vmdQ/TLv2aJ1rbsT8/ndzVzauLSexX38lbS+rM7Y=;
 b=KV4sH5ERygatBobZILczPjGxOKUo0a9MGLSzjYUm2OvX4WETkqCDd/Lx02zmttRkZLW6l5KHBcog0od8Z7QbhdalDqHSO/LcRbuf4mArWolJRxjYgPE37WEno983TF2QbIOjTH05g18aZmmmv6iPeS9xgqUNBEwBKvqN74N11Uo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by BY5PR10MB4148.namprd10.prod.outlook.com (2603:10b6:a03:211::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Mon, 7 Jun
 2021 20:38:56 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::4407:2ff6:c0a:5d90]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::4407:2ff6:c0a:5d90%9]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 20:38:56 +0000
Subject: Re: [Patch v2] mm/hugetlb: expand restore_reserve_on_error
 functionality
To:     Linux-MM <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Cc:     Mina Almasry <almasrymina@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Michal Hocko <mhocko@suse.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
References: <20210604235904.48761-1-mike.kravetz@oracle.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <06c2b59d-478d-4a34-ed24-bc756ffa5b9c@oracle.com>
Date:   Mon, 7 Jun 2021 13:38:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
In-Reply-To: <20210604235904.48761-1-mike.kravetz@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [50.38.35.18]
X-ClientProxiedBy: MWHPR2001CA0017.namprd20.prod.outlook.com
 (2603:10b6:301:15::27) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.2.112] (50.38.35.18) by MWHPR2001CA0017.namprd20.prod.outlook.com (2603:10b6:301:15::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend Transport; Mon, 7 Jun 2021 20:38:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 61e70952-1444-45be-59b3-08d929f4458f
X-MS-TrafficTypeDiagnostic: BY5PR10MB4148:
X-Microsoft-Antispam-PRVS: <BY5PR10MB4148A613190D5869D1657173E2389@BY5PR10MB4148.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DriSMp+KmvDEFVcQCq9Bpz/1JZ5VyPe4Cl9WSuHFqiVf8R+D5L2lklUal5c3BJ2EAJ6VoOeeBnyPT3wkRHhTxBoMtXM0pOdCaxNGLiIm73ea4AWtdvS69uf9AVqhJoXhFBHOR8aL8Or3FmjuFqB3gmmfkMUrtJa8nYLoNT9XtXO57OWgm8dFUAmEmiiQAhmUvbpi0uAQiFz1I+MKSJOgQyYEGasX7oOUW76Nh2K1dxF35gOCgSPkBifmkygMJCY6Vh8uzwXm31ACowpcuN2kheA9Zv+85zfhTa2Cqi+GTUpahIPTp37qtOY7qoKOKNEaDmN03b28zmGHh08NT6tH7IlsFNQnTiXv+HtMQp1d/l+ZK3RDlujaGshlv8i0SQPkr5WQ4RMaqpoJ7ud3WlAITt4o6sgTwT95iDe/ufEo2aEEb4fd4+/Ho6+ViAsAT5M3Nrwoe76FWNehNfwl+Q7ZWyTeJMK3FdGzgSvAOBsKsMbjD3CwzO+urfAmwkPxs7zyyAzAQh+l227cUkGgblqRIaHp1iLRpuo9iZFFQ/rTqGh0bB13hyXOyWPkCmgIjT0eID3FBulvN9xlqBrR90Tf1qYYpQIUO5xclKAUnKKe+tPe13+E4xrlEOz+3mmbBubhWLEvyr5AxccCv1yyVXD5E7kk2eoWBnFjSQVTAWMKFxmne/Pz+SKNZhWmom5C8ZA5uDEmff9wFYlj6/j+VWKVrJqv2/zkTTpiJg0atksd3HM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(376002)(346002)(396003)(7416002)(478600001)(52116002)(956004)(558084003)(2906002)(2616005)(31696002)(38100700002)(54906003)(316002)(16576012)(4326008)(16526019)(186003)(86362001)(66946007)(36756003)(44832011)(66476007)(66556008)(5660300002)(8676002)(6486002)(8936002)(31686004)(38350700002)(110136005)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZGJod2NhdG1mbndRSEFvaE9WMXl1WGJzVm95NlpOeURaT0hHOFZSUTR1M0hl?=
 =?utf-8?B?clZpNDNIMFVYcDBzY3F5TkgwLzQvZ1hseHh2SStaTDRIeU15Wi96K0p2d0s5?=
 =?utf-8?B?RXo5TkY0K3l0d1g3b2tTQXRuaUkzY3BicXRmL0dFWmFwREw1OUExaHBUUzFF?=
 =?utf-8?B?YnVYaVJUQ0hTdEExUkZhL1d4dldZbkU5OVJFazNyRW5wVm9JYUdWOXFFWG5z?=
 =?utf-8?B?NWQrUWdmOFc4Y0ZZSTdwRUQ1a1NjRTZFTEhoQWg5c0EyQS83R0x3Y2RBNy93?=
 =?utf-8?B?bDJrNmQ5WXpURFlBa1VFR2hPNzh0cTd4UVRLQUQxS1BhWVFwRGxKNG1kZ01y?=
 =?utf-8?B?UHo2ME5sOWZGcDREUGxCZVU2aDMyanNWdGUxTkhONFpicTQ2NVlhL0RaZHZC?=
 =?utf-8?B?WUhaeU9CbkJkNVYzZm84TjhsRmFZbTRmckZqbDgzaWpsZ25RVXVmNXpYd2JC?=
 =?utf-8?B?SkdnSFlINUhlMzZDVnBPQUxidzNBZmkxM1FlMllCWUtYRmM0TTdKTy9YWVd1?=
 =?utf-8?B?N2dFR0hEZ0ZXSlQ0clhJb1M0VVphd1k4RUxzcmN5MEFiY1pHTzBWbFk2amVt?=
 =?utf-8?B?ck1raFVVVU5yY2kva3pieE11eWhPVGlJSkdJRjM3QkVPNFQxOE1QWUdkVDk1?=
 =?utf-8?B?UlpLVG5mNGVpYURrWjlYZkJDeDVONEg5R3poRHllcFo4T2JxY3F4VDBMK3BD?=
 =?utf-8?B?SXJUZm44cExjUmQ0MFB4a2U1T21QWFpDcDZzNktkQnI4ZDhRU2dVcXVwNzZT?=
 =?utf-8?B?UlhxNnJaRVFWQ0o3M1cvYWVHT0hWb3NJMlNGWEkxRyt6R2hDNmxMUy9iNGhK?=
 =?utf-8?B?OVJ6cTNacUFJWis5b0xJRVR4ZUQyaU9Ub2c0OVorRG5SVkNEaGVYWDk5cStx?=
 =?utf-8?B?NVc1YkRjcFh4WmRibWFRUlpaelJPSk1xaEZSU3YvK2drUFFDSEROQjQ3WmVt?=
 =?utf-8?B?SGNETjQ4K2FVMFkyVGhVQ3pPNUEvdW1xWWplQm9CY20wNTJZbE54V2ZuamMr?=
 =?utf-8?B?bk9Bb0lLdVhLZUZmZVJRQlltU2ZOUFRnVk1GN0s0V053L2w3NE13NHU3dEFN?=
 =?utf-8?B?aGdaN3JvT0I0RUx0VjdsaFhxVkFWZitKdjluZG9HTS84KzROWThlVFFzRE4y?=
 =?utf-8?B?bnl0N2VYckJGUU9iVCtOYlpSc1R4WlFnQm44WjhkWkZOTkFZWHEvWXdFUDVh?=
 =?utf-8?B?YU1TR1Y4K1NaZ2NpZXl1MjE4amxBbGtiRGVkVFhMVFlISldrZGxVUGgwL2xK?=
 =?utf-8?B?akJwSTVLVTNaY0toQjdSaVBoeVBGaFBUb3g3SHVLWi90N3dkQVVBZG56dnpH?=
 =?utf-8?B?WUlhejM4amVHOWFmQXlHaGhpeldFNUI1YlBDenBhaE9GUTlxai9MMzNjRDhL?=
 =?utf-8?B?S1oxUjlZK0JNMDNSeVFtQ0dDOGplRVFTQmp3TkVTSzlJQUZRNjV4eStxcUlN?=
 =?utf-8?B?cG9HcXcyWllWc1pxbjV0ejZBTWJXSkdFYU82ZVRCUVp1M3pyNTVLUHhoOEwy?=
 =?utf-8?B?NzRDL3d4Q0Exdno0N2RRVmlUTGY5bXM0N0lFdVJncHZlQytFWHJjMW1YU3FD?=
 =?utf-8?B?Z3ZNTjVkQmVCWFRtMWwzWGNvZmx1Z0J0SkY2UmZDdjhJYXVWMkxHNnB4MGdO?=
 =?utf-8?B?MmV3TGFzejVlVHJ4eDBFeFd6SjZXK2xSbUlYOE5zRjRsU2xoVFZycHJ0L3VT?=
 =?utf-8?B?VnV5MU5NTVlocUNZTFQzUUV0SWowM2JQcGswcTFMemFSekdnL0lVekorbG1Z?=
 =?utf-8?Q?HPml8j2NVBqXbaFvEdwJmAMYsXfg9KaOM6X/GSV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61e70952-1444-45be-59b3-08d929f4458f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 20:38:56.7139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H4ExIEU7BFGEKJwwLZIDszUmzYc7J3z/IxqAJ3LqH4InLWnW/qVEvIjIOnv1dovXTgp5tkq92CVO5T2tpsoZyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4148
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=929 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106070138
X-Proofpoint-ORIG-GUID: BdbRxjUlBvikJ9X8wI_fSVrUk6tx_nHf
X-Proofpoint-GUID: BdbRxjUlBvikJ9X8wI_fSVrUk6tx_nHf
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 spamscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106070138
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

My apologies!

I sent the original patch as v2.  Please disregard.  I will send v3.
-- 
Mike Kravetz
