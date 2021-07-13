Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A7D3C7914
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 23:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235708AbhGMVmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 17:42:01 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:35160 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234947AbhGMVmA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 17:42:00 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16DLVInB027883;
        Tue, 13 Jul 2021 21:38:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=hZOR5rFMrZQ8owXSJpF6oH0f9W2WrjMUWWkqm7oqu1c=;
 b=Gi4V5P580hH9uzkz6N5FTXet03EDyNOdkhdbLAwmBiYNU3KD0dCgre0RIwlmn80B5ap4
 XHxMd/piehWoQ7+xt8gff1EOTvNkC0hjWf+w2DrBfPFfOJTaA4g2VNqK4R79UwaDMjw5
 RpfcykRQoIlzTuCFXo2x805lWTMWhMxo4U3+AMQzJjL2TvC0UnHVMwfTScQCxKl9zSsa
 vfmCBZheqA34LCWXjMLfF/ctefXmjATnutn0tg8p07WZGi+7XpGwtIyUtvl2Pbv9DQ7L
 Yu0xwtpZFG/p7gZ4iv6g5H3xhPf+pyhriYuNAiSgvVCEOPOIYmqwFeDfhA9kKvPE6Umd JQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39rqkb3e5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 21:38:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16DLUhCc084388;
        Tue, 13 Jul 2021 21:38:55 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by aserp3020.oracle.com with ESMTP id 39q3ccs8wx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 21:38:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eQ1C3RXUgLP6FF3EAQ80KRIqd8xa4smHnts31a3DpZDrq5jbLtsW0PoqWDQmaIrS99EbphwCy4JnIFxt9i5xBnNaz6mbmM9cCJOyx0jdwjR5ne7K1LME0ZQcG0DPfK2EtsWp9hszmZ1OvI9Ew+sI9M0/TThLsGaZi35N8VbTQxa17DUKBXyKuTLEVN4aGZaeTVtLJmDe+li1jY/3GGzdfuZ4Wo4txkYFwXyiUTKrAJscp1Jw6vE4EwlFLzzoLAXGF/ItLguYPnXp5qw0wxUEn+pQftH7OH5rx6qu51dGxLPdXmok29x8CcuhLY7yWBGDYlHqFohB/YwjqMTfwrXlRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hZOR5rFMrZQ8owXSJpF6oH0f9W2WrjMUWWkqm7oqu1c=;
 b=bfIcyWVPbeZabmoVjtsZSal87rwRPcfvpkwC7lkAhpjP8qM3DcuxaaEFy8XK7ulg6hNNvgMQvugC4J1MlCFPNUvTiknt/sBf/64terNK/vmgRo7qlDRYCnRIRROHFzEFktr/fqPrhPSp9OQdeiVINp9V9cXGi6AxxfySyGkuCXdBM3IRb2PBvMMeUg8wXoF4W2LCfL7GLuXa2tyiTrUy7v/EQog5/BzNo7gMT6Vp0DBQr2LeWsw16yQEstlOL09pOIxREM90uj3U1r81MyWLkDL5rL5lZgiy+f5TKzNXMxLmfWt907Z9dmmrjGzbJ94rwkbdcJT6z4XvcnRzJo+rMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hZOR5rFMrZQ8owXSJpF6oH0f9W2WrjMUWWkqm7oqu1c=;
 b=ZWlIA3LK+u7WNqEGblJvB1EeRPRaoXuw7d0ay5CAYo9TALzWLoXadq6rowTekP+eV0a47g8M/JSwH5OmW4eYY9kR0M8ZkxD7MYVQKEZNeGRLR20O2Y9sIDbIWNqEI9NAW9m/u80LdOlTMKvlJyVKyd1sQY8xT2KbI1pi45ZJyOs=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by SJ0PR10MB4462.namprd10.prod.outlook.com (2603:10b6:a03:2d7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Tue, 13 Jul
 2021 21:38:53 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d2a:558d:ab4a:9c2a]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d2a:558d:ab4a:9c2a%5]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 21:38:53 +0000
Subject: Re: [PATCH 5.10 569/593] hugetlb: address ref count racing in
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
References: <20210712060843.180606720@linuxfoundation.org>
 <20210712060957.472489781@linuxfoundation.org>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <150cd16f-a99b-9573-da41-2f50533ac792@oracle.com>
Date:   Tue, 13 Jul 2021 14:38:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
In-Reply-To: <20210712060957.472489781@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0361.namprd04.prod.outlook.com
 (2603:10b6:303:81::6) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.2.112] (50.38.35.18) by MW4PR04CA0361.namprd04.prod.outlook.com (2603:10b6:303:81::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Tue, 13 Jul 2021 21:38:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 204d9b1c-2d46-44ba-be98-08d946469c3a
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4462:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4462481A6291608DD6B54E44E2149@SJ0PR10MB4462.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:873;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zv48KvkxVlaTScxirSbFM6IsEitGtjC5YENH0WrWtWqKoidEdmNNlnXkCkI7vnan5j+CyQ4EVgltyMF+dI3OwuxOMAw/w6etl3XJep5o16bDijNE85JuNFn2VYvq05npvjlabQJgpf1n1x9ScEupIG7o75cOptRvvsAA4vxm6HU+pBkuamAT0jcjqxVFW8tWFmdTfXLoZHf3PydpmqeHPyXH/Otyu53gi4ojWSCixU7fguM79yT3ceMAwOuopDw9yfPGkwYnuvacQKkZwBAWWIEgmrbND8brFqIXwIdIQZxJL8pTHgnHHpbEbmrEasZn3ZFu/kLBp5U+ZF0TwX9t5cRlKVmFEnAs6wZR1ieNh6k/BOb1jJtOB4/RVDS2RLRAbkox8aU5NyfiHRwvpcB5ZbB122jgbCcrOnrApN4ilzWnhj1ebDhc+ZX6EVZ6m5TQ9R4gr+Z/Fc2ISuerLIpcI+xbrmnG5ZdUppeTBcKd1rnPTM43NNTAS1tVkAON4PnF1+55g7nNt3Kwadxg4qTA98p9bWwkoZPaA8O2lsBquyKEcU249HhMLNvOlnZQs/SweLT8FKndeZwmdlKybnZr7KShunu5Nb9Sletes+TLlu6RVOR5azRjG+PftouYPKnMlJvC1NMBkDCub84zOCVBhkW0SaCmKhYkzlE8rKzYYkTF7pDODbECABsa+MH4p+4VXi5xyXEeVf2C3jlChO3j9Kbbjsc+DZv/yMusDNfG7IGxzpHLbtEAZEuX1GBA4AJxAVF2Iez3L3d6NmJ7jhzaiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(39860400002)(376002)(396003)(366004)(4326008)(956004)(2616005)(83380400001)(8676002)(66556008)(86362001)(478600001)(66476007)(44832011)(38100700002)(26005)(2906002)(54906003)(16576012)(7416002)(52116002)(66946007)(186003)(6486002)(316002)(31686004)(8936002)(5660300002)(36756003)(38350700002)(53546011)(31696002)(4744005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aERZY2lFakhmLzd4d1k3VTR0cExSdzdxY1VjYmJwOEJ5MjlGcVhiRnhxM3JU?=
 =?utf-8?B?ellqbUtQdjYzblVVNHpYd0lOVkFhY2JERjFkOG1jbmFZRm5TWWNRcGozazhO?=
 =?utf-8?B?ZGFOSlpwYmNQWVFvRmRFdU55V0s0SkVvZVNhdW5tUVdhTkZPSzNORk5KVk56?=
 =?utf-8?B?Qk1TeVVvNVZKbERFc3VPZDJZMmdRR3BGenlxaGp1ckxBaldHUTRNL3lIY1No?=
 =?utf-8?B?Z3F6VFRNcW9HSkQyQ0pJKzJBZjRwRmMvamd3OWdQREhEMUhNL09hc3lIMWJK?=
 =?utf-8?B?YmNUSzYzRFFyMDhyNHRmZEx2L2k0N2Z0cENXTGlGNUlDaWZVVFNUaHpiQXp2?=
 =?utf-8?B?QlVLODA4cnE1MXB6M3JQMVJDNTl6R2VPUlFzM3padS9Sa2VudGQrQzJOYkds?=
 =?utf-8?B?YkNGY2x3aHEvc3hpRUxuRXNWSmtHVWRJSzdRRnhHZmlydnoxVVQ0NmxFd1Qx?=
 =?utf-8?B?T3ByQmw4dmRjaGo0anNKZ3FqM1BqVU0wamNLeVEyUXI1NjFodnI4RUgxM2Fk?=
 =?utf-8?B?RzEzUUh2THh2RHhVckRsTDhBTTNzcG1uUWNNeGJKTlBrQUsvdzc3cWoxVDQ3?=
 =?utf-8?B?OTZsTnZzUTh4Q0NENGhNZXVPZ1RMbDk5Q2kzK0w1SVBXbFV2bVVsNTU5TFI5?=
 =?utf-8?B?Wk5BdjBEekE0blBua2t2UzZMOGFRNDlFVjcrNk1LRE1yQkUzSXpibm9Wc2dC?=
 =?utf-8?B?cTUxTGRmK091S2hFUU0xc3kveUQ5WVNBYTdYN2pHSzJkaGpQdDQ3OXoyQVhk?=
 =?utf-8?B?WXVQQjE2Z3VYYkFxSGlkcWpEZkRQUEswWXdqNDA4WUdjdGtPNkVHT1ZmOENv?=
 =?utf-8?B?eFhFMVpNYTJtQnp0b0ZoY3BvejJ0Q00wMVZXZjhMUlhtQkdTRk5DMGs3SmQ3?=
 =?utf-8?B?dVRBYWZWWkNpbnJyTzR4YUZMbFcxMjB6ams0d2NESXZxdTBkU21MelFObHZt?=
 =?utf-8?B?SjdLL3NuSm5BeUU3QnR0ZUpOcXdaaHE5TnFHb1hCTncrVDhGbUE3blNCTUVE?=
 =?utf-8?B?RTc4TVl2SDlNaDVVM2lSczczYlFLWnVDTVFFUnVwQ2pIZEg0YzQ5ZzgvUTUy?=
 =?utf-8?B?N0h1SHVWRi85ZHRYNDZudHB4ZUszNXpuVDhFbXVEcXllNzh3ejF2R1FGUHJT?=
 =?utf-8?B?TEsxT3B5dkJidlZvdEN2T0hSN0FMOFBjaCs4Y3BBaXlCRWErOG1IUTQ0M08v?=
 =?utf-8?B?ZWtJNUNJTnl1NUlvdiszVWFLbFV1OFh4VmZMU2RndHp6c1lnTkFoN2dXUW50?=
 =?utf-8?B?ckJjcGZiOGJLM1NtMmNZQXgra0l2SGNzYldEbm9lTHBHLzBIYUU1aGZSV3Q2?=
 =?utf-8?B?cmh4VlNySlRvYkxFUmhLWmJGKzRUYjhnVVVTR2s2a1FuQ0ZSb1lqSHlNNlRw?=
 =?utf-8?B?THZUVXJPMXp6UFJqZ0IwT0hySmFMRi9pdzlNN2FSbHZYRzhzY0hGTEFTamV2?=
 =?utf-8?B?Y0dJQW14bndwYkJmSWh6aStzT25DSzhuRzFvOFJrZng0b1IxRk1lRHpOQ1Rl?=
 =?utf-8?B?TGlVSk9VREV2QzVXRExGVEpOQmFtMmZaSzhPZW5XMWlQc0RPTnBwVFBtNTNR?=
 =?utf-8?B?KytoWHlac0p0M2UxOE5ZUFlyYlR6cXprSjJpNFF5NlI5Z3BzUHdveXJ0eHp3?=
 =?utf-8?B?d1JtSG1NMTRSM0FaS2VDRUJUenBjLzhGU0dqU0FsMzJDQ0ZEMmNWcTA1L01S?=
 =?utf-8?B?ZENpZ2RWMXVtR3ZmVDhEV3FVTkpTc3VqY2p6YlFVR2EwYm1SKzJRV1ovVmM2?=
 =?utf-8?Q?CjhqrFL8c2/W0Y635YU0CZlsJIQj67xC0AFquNl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 204d9b1c-2d46-44ba-be98-08d946469c3a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 21:38:53.3650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZEbNaMh9Vx9wGcLFPosBN/DXlJfWfsVVtZmKyYsaO/lsF1rHERsxb+FY58mj2ycB+vgauI5KYi8s6j2eIBsAPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4462
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10044 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107130132
X-Proofpoint-ORIG-GUID: 80uie3jUNJpNqhpz-BfBlDWYME2BZZnR
X-Proofpoint-GUID: 80uie3jUNJpNqhpz-BfBlDWYME2BZZnR
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/11/21 11:12 PM, Greg Kroah-Hartman wrote:
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
