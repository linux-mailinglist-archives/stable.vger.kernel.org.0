Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA393C7912
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 23:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235310AbhGMVlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 17:41:36 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:6404 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234947AbhGMVlg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 17:41:36 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16DLVD2R027822;
        Tue, 13 Jul 2021 21:38:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=S7Yyu4nBeOP4Z+p1Kp0iwwAjOJ8s6RXKKl7j4YouwTw=;
 b=pQ2oDJl63JJ5QGtvk5S5tSrDR2yrRG865vTNsw0nQR1vKY+3dILyHac0Gx7RpKQ5G2Mc
 kpi3TYMopMgWexbSUWgUw9eD70XO/vf4Rv2BvqxuunNxNKhphBRmYpAOyPD0h0k89MG8
 UiZ1i/sjxgkU6E7G6G3siIF+wXTZx1rRP8Jqsxaz/U+cf3hT0M/0rUwfWOYP8e7QGi3n
 vqKDmzKVHEv/77yIkxCQfmgSN+4i0HFpWst8EoDI8I9sULRkvkBtJuz0hGq3VWRM2CwB
 +ZA3sQ/cagb6l5ZNmmS7bdvbuTe4zC5ILjEk8UXS10YRQSFc7vxVvhtTrS2mhDzrYEZr 5A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39rqkb3e51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 21:38:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16DLUZ5b162158;
        Tue, 13 Jul 2021 21:38:31 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by userp3030.oracle.com with ESMTP id 39q0p5w081-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 21:38:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eZUsogtr10ANEUCVSLROZoAmomS3DhdEmPJD5RuqaFy8MqbxSJQlBr86cM3lcZ4HBLKBl8G7l029TztgYkiGLEZlLU+fCull00m5XLbl8mJUugnyymJwEzAlfN28r6yCdzIskxd3442ob3UNhvBkxi8O8YjuMYGAIkiyIETc36bVK7nxLNZ8xoFa2mF782ZGREbhGbYwDd5Yw0402uRPt+9ruJBQDUGuX9+1SxJJb62zJc8o1Z/94ygzCXotxzMS9yyNUD5OYb/xKdCzuUzoFNGDmGq3UIqaNSdOJR3IgIYJooXbHj1quU2N3e/PaSoCupvUWKHJLuqFB9uQC5fe2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S7Yyu4nBeOP4Z+p1Kp0iwwAjOJ8s6RXKKl7j4YouwTw=;
 b=beyIdFQSDfeXJL/uikbV1llCitkIWt+EoCKL0KffcjGRtqibAHBn9EiKGk4qC5Hgo2bMGweSJuyiolXltMCjULPbztQfEyekGY6ZZmqwSQoEFXqyogGM563n/uY7qwbWp5ssCuDI4WFV+vXSLezck9HJXUFKxkKyciHdyR7rGp9WeNRcRD8NRBwGrDsHqKrkEVUiv9Xgl3mW9hINdxQmSWynjQPte2SVbQJ1IyG07NYcj/8wEGxbmraKwNOSNTmYA2xcDkFM/X5xXN6ucvEgke2KJfGwx6s8CYRmiiVsNb8/6mqw2UZI2tilw6cSfToXA5wpJB+HlQ0/+vIamDlEiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S7Yyu4nBeOP4Z+p1Kp0iwwAjOJ8s6RXKKl7j4YouwTw=;
 b=aEfkYvAhGHFNOZNgOsaFPCpG/qdnh9krqR4ORppjLJTLpw4AbbGzhO0OiXX8CWNLoSeZN1GUuOw6VbPtOyhcqOSoIKtRlq+70vRFWFjxQzvn3bbtFo2ih/d1kIU/q5qEvmCpBrkiNfOz4kRUpUNN+MvoNdLscNhI9SOukPJ0HOw=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by BY5PR10MB4116.namprd10.prod.outlook.com (2603:10b6:a03:203::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Tue, 13 Jul
 2021 21:38:28 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d2a:558d:ab4a:9c2a]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d2a:558d:ab4a:9c2a%5]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 21:38:28 +0000
Subject: Re: [PATCH 5.13 768/800] hugetlb: address ref count racing in
 prep_compound_gigantic_page
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Youquan Song <youquan.song@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Jan Kara <jack@suse.cz>, John Hubbard <jhubbard@nvidia.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@kernel.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
References: <20210712060912.995381202@linuxfoundation.org>
 <20210712061048.520052935@linuxfoundation.org>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <96dcbea1-0b68-47f2-8954-fa36b61fdb0f@oracle.com>
Date:   Tue, 13 Jul 2021 14:38:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
In-Reply-To: <20210712061048.520052935@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0364.namprd04.prod.outlook.com
 (2603:10b6:303:81::9) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.2.112] (50.38.35.18) by MW4PR04CA0364.namprd04.prod.outlook.com (2603:10b6:303:81::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Tue, 13 Jul 2021 21:38:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74d3b30c-a7e4-4e72-d059-08d946468d63
X-MS-TrafficTypeDiagnostic: BY5PR10MB4116:
X-Microsoft-Antispam-PRVS: <BY5PR10MB4116AC0CAC82637B71969028E2149@BY5PR10MB4116.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:873;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PVdEBmFlhsACg+lH8GoV5cA5DGItFI61cLYZBtgl0DbVY9+x4lBhqPAhMRuvFuLLMNbIK15wWNEKnbAfwYTJDndmIntyJyeEEaDleIhfQfeK7RNoHyH6jNvryqqGjVdYXHB6jlWqzTztq1FYjLbdSyaAS/srnSU6m5rxEUZwVfwizBly2wKJit9gKh5hVQsAP2fOL+cn4VRnRS4jvvQDK4IxhbVYEn+v0VtICe4/lJTUC72UVH/qwRKiyvrwPzhU3p9C6XaZx7w08TAML8bJFZiZrg05DGgSR1ynCLE21zZL9KpW7dM0O8WqDlKNZyb9suRqmtF1mNEhI36iQR1v5AhIARwsxwj/R0oQjSLjxbXQTNW9fMTqM9SA45cfwsmYF1Wk3qpXQRVDXjD5JdfJaaB8jU8uWPnW4v+CeQUmqfkQTP+nSvMwyvptx8h0xMUGqgPGHcKljuPiTWSXSkWiTFlSXBk7FdAm4KioI4PPMfxSaTYN1oAU0RY75Vq8evx3jVvmBu0j9PVTS2OQj5GTV6e+wRuyOhrqrA7juyi6H16aImwiolecJjAz7Zc5cX/JTIngy5INx+egXATfmygyD/N7EAy84sA0FSmdImvKKu6AkbUxda56AL46WYjDV1UE7n6DVAkUARDsNgeQoaTgQAy6i36d5n5pfUDzTEdYX6ZNJaEahkv7fmjoFTEG9K47nD4KkQl68z6b9ekcmxHRBv2zX+zYyJ0fDotpI7kjFZxONdcIGYZ2zA1ewsPpRkl0C/mVhep46w8V2W0FPAY3wA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(39860400002)(396003)(136003)(6486002)(31686004)(38350700002)(186003)(2906002)(8676002)(31696002)(38100700002)(53546011)(4744005)(5660300002)(26005)(8936002)(86362001)(4326008)(54906003)(7416002)(52116002)(83380400001)(66946007)(66476007)(316002)(36756003)(66556008)(16576012)(44832011)(478600001)(956004)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NnNUUTVzMEtEYytsTVBlNGRZa0hMek1VdlJkU1dYUjhxNVNsRHRuWXJqQVFa?=
 =?utf-8?B?UE1ZeE1PYVBqVmV4VnhINzFVWUw0REd2TElPMzJvOHF1cHhlWEV2U2RYN0tD?=
 =?utf-8?B?czZDUkdqbzNKQzhUYk9hTExLRlBIUXdwSGpsZUcvSm53Y1BuVkxrWFpxSUo5?=
 =?utf-8?B?VnNzTTc0VC9BN1lTSHF5UHRmU0dZRUZTSE0wTWZBelZnMFdFNUNWWlU0NE5R?=
 =?utf-8?B?djNZL3JlMDEyKzRFUHRuM2NqMXFEL05wYmZCOTFLRWFzdkF2WnQzVEEyYVR3?=
 =?utf-8?B?cFFsRWkvTEs3NVoycG5GQ2FzZ3AwQ0RtOGN5d2FDS0VZUWRncVdzd1JLam4y?=
 =?utf-8?B?RGwyUUZNcDFxazZBMktoOElDdngrYlQ1MHRzUy8zSjEwOFhEUkJUczR2RUpx?=
 =?utf-8?B?Z2h0b2ZPeWwybWVNalMyZ0QxMytzNFpWREVkUkx3T2VNeStFZXcvSUgyQ3hN?=
 =?utf-8?B?RnFHS0pPd003UHE0a0Urbng4LzdDTC9xRUs3U2xIOC9oTE05dzV1WDRLK0tS?=
 =?utf-8?B?d2oxalJwZjJLNmhSUXprdmhPQzVCMWdjb21LYnRYZ0hJTEhaVDloRG5IaHRU?=
 =?utf-8?B?OVlsTzhMU0NVdnAvNjFETHBMY3h6UFV4b095NWZQazM2TzdVTjlsVGFuMHBP?=
 =?utf-8?B?RXVKR0FqS0JkR2taVUxmUUdDbW9MZVhHQUZSQkFGZ0FVZnhiYithWUliRmN5?=
 =?utf-8?B?bHp2K3BuT2VTYUlTRHh3YkttZlR0SlN0RnRnZzNZTVR3NGNiSFZDcVowTk5Q?=
 =?utf-8?B?STY4UW5HcmlHMnM4dmdJYm9BdmdFSENoZlVraHlFU0lxRHdxZEtZaW1oOWFk?=
 =?utf-8?B?a1pMcTc4S3FiSzgrVUg0RXBkUkpUYXNCZStYeTRXTW1pNGVtY0hCcTZoazA4?=
 =?utf-8?B?eS9mOWlDMDZhUXhSVnJkUys4RWQzZ2h0aXdkT2dvYUY5OGxXWHZoR3l2Z29q?=
 =?utf-8?B?cGVCNDJtWi9UTWQ0eVFJZTkxTzlTUmYvOURGWUpSS2VJUVQ1NXlJNm1Yemxm?=
 =?utf-8?B?ejZldDRzWmZ4MDZLR3hOckxyZTVRc1pESHBmaUU4WWpWWDZvK0U2d3hRSHVz?=
 =?utf-8?B?YklDNWVvQjBIOFBxTnpPOXdoYXd5ZFlmN0JKSnprcTVZT1hyNjlmeUdJajJ6?=
 =?utf-8?B?MzBrZkgyU2hWdTlocWVEMlY0a01pM0xmK2VWelUralJaVy81bzBBNHYxa3N6?=
 =?utf-8?B?elJQa1p0QUNvYmF0R3NUZDNwVzgrcDBrdXlzTlJwOWZ3cGMzOFR2Q3JHbi80?=
 =?utf-8?B?OS9qMWw1WWtKc0l1Y0VmRERISm4xYUp0UDRMTHkxbmlaTWN0SmhqWUN5M0xm?=
 =?utf-8?B?UzZkaWNIZXZOUHBiYXFZVnVBTjJnUGZYQ0t5Zk1HUzNTL0hjNGtPQUFjeDJ6?=
 =?utf-8?B?WmJ3V01mdVp1czMwK0tQNnNNcC9LK1FNM3plSGx6S21VN1JPZnl4T2RBbVZ2?=
 =?utf-8?B?WW1EN2VkLzFFTnpHSjYzeUlPTXd3WUVYcXI5L1RKVnZvS21HQWptWEZDZlhr?=
 =?utf-8?B?dlRUdDFnbHV5OG5KVnBFdGcrYXY1Nko4MmNYbXN1UDNnRU5DVzVDZE5kZUVU?=
 =?utf-8?B?KzB2UktqSk9QQk15b2ZENXlZOWJOSzRGdXZCZlFEZUdMSE1odFJLYjlkNlUw?=
 =?utf-8?B?K28yZ2pPaU1vc2ZqYURvQS9uSkk1WTVKYXZrSC9WbFlJOTg5dWcwajBLRHYv?=
 =?utf-8?B?a1lEcnloOFFSSEtJcHV5VXBWQXorQ2U1b3RZLzVxZVJJcjZYMmZDZndFNGts?=
 =?utf-8?Q?JHllqhx00zo+WmYc3bJTDaJsnpBVqxUAQJ0R8ar?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74d3b30c-a7e4-4e72-d059-08d946468d63
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 21:38:28.4375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uTWPmN9xDyNET+hnKIhtH70a7MUwH6s0fSEJbPKZIsoROlFllt4+LWYCJ09YNzLyZnBH5KNTthYQr0CFVfYs0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4116
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10044 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107130132
X-Proofpoint-ORIG-GUID: 2ckQbrfGUXPLp55iVoRVQ1k5CR6qo81H
X-Proofpoint-GUID: 2ckQbrfGUXPLp55iVoRVQ1k5CR6qo81H
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/11/21 11:13 PM, Greg Kroah-Hartman wrote:
> From: Mike Kravetz <mike.kravetz@oracle.com>
> 
> [ Upstream commit 7118fc2906e2925d7edb5ed9c8a57f2a5f23b849 ]
> 

Please do not add or the requisite patch to stable tree.

Although this is a real potential issue, it was only found during code
inspection.  It has existed for more than 10 years and I am unaware of
anyone hitting this in actual use.  In addition, this proposed fix will
likely be updated/simplified based on more discussions.
-- 
Mike Kravetz
