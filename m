Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBF4578936
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 20:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235644AbiGRSHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 14:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235616AbiGRSHq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 14:07:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F1E2ED75;
        Mon, 18 Jul 2022 11:07:45 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IHUTSd013970;
        Mon, 18 Jul 2022 18:07:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=l/382ZIWv89MHabu7YBz+U2qU0IwDqLsi4YlDpU4EYQ=;
 b=xxPVd8NTJ2GPnY/KbARDsqkhqg0DTnsoKoClW+7d+sjKGaN/2iuPtQvfGAfD98uHpg6p
 WloLntd1UpaRzT7CHl9C4P9Myc3NF8Q1KgF/NTdX0z5cT8hEGnIfEiV0oT7Xt6iJpDQw
 W5epC41tiO/G0efT6Ea7tEo5PHpnPtvo0Gz6VEyx7KNr+fVOYqC0XK8MCU766eFMuDCT
 nKtx56kgDougbVR3B1YIvBI6pMwZbjLlNDFUny6vh60ulNwb20O+8ksvfLF2Ry3iJGgG
 DXMPEHq/b1f/LQzQyKhn/BunqvQhVLrPvZrX+WR1Jq9llTEl1rxvsAWniTBvnOsFW+QF Jg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbmxs43a5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Jul 2022 18:07:17 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26IHMpIq007895;
        Mon, 18 Jul 2022 18:07:16 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1eku7ap-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Jul 2022 18:07:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EbEFQ5pf7MjoqWn897+1Sc7PfSDAuHV9BKGQngjeu+vvwhOcIJ2IE3jDBxFAl/XAStm+4Yz4ASmwNRM5fQ+lx80lEyJ0xmFMywDf7LUTXRQwNSbbhwa1LoRi6Mm5sNyAZjeeiiaRvc3JqQaXEwpjBOSYz9GmoB/8LMNs/blCbhv0iV5ceAwt2LhZtDCFA+ApFGhiSmm47FktG6OJhyZV2NY2KqW1cT8RPqvF1HjfIZWlAiZOafk6WebunCpxCO+450FQHrszkjsmTFlPA0X30phduNcWY17D5Z+HaeOxnWulw/nU8KZaPu19fk7FTzUloyjJZIdA3CX1Y/d+RYALIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l/382ZIWv89MHabu7YBz+U2qU0IwDqLsi4YlDpU4EYQ=;
 b=BQgDPfnuA0ohRkznIgG25ZnfLcZ8sBdcQuojIYfCmAG9FwsrMYbZv7DlclQbRxGwmtfUQVVoEVJ1JjoclL0/cXsZNK30/gaaN/U6D5/BNPZUfZPxWvGAqveFP9IE+lTQAvWA6aTn3alW0LyHXZbhGlLLNoRX7WwpUgpWIhcRN9oDMzuVHB36rXr07fnJKkWHExWEm5A2hWsrc6XLlNNEJ1XVeeMQ8BBRhpb70bHBYb2+QN7uFEc6N8vpPpmijjKbQS6aBIQ/ThLE9kQu2cWkCXhNNaWdIs8DobofDeUWgwJYiD8bcLhyJAT4OBOQOSynYTmYrkMUjmcHVtNjOmhFOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/382ZIWv89MHabu7YBz+U2qU0IwDqLsi4YlDpU4EYQ=;
 b=Fq5W32uNy08DoAlgSJeNVwsPV/3F/oGdZC9n1L5wqMnr7JsHi69i0wfUy1aQxOYT7OCqdNIInwcrw7CulGQEOY5pPG4EUyMcVySNwyjlU2qu1ADSzLdkVx6Umv3VVAYNEA/ZLQcbnnVmpXwlIKFQUJ3DGXBtU4OwrCjXnKIFNmQ=
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
 by BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Mon, 18 Jul
 2022 18:07:14 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::61e3:46f5:e886:d7a1]) by SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::61e3:46f5:e886:d7a1%3]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 18:07:14 +0000
Message-ID: <70bfaa1f-9a33-406f-3998-e185daea48b3@oracle.com>
Date:   Mon, 18 Jul 2022 11:07:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [merged mm-hotfixes-stable]
 revert-ocfs2-mount-shared-volume-without-ha-stack.patch removed from -mm tree
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        piaojun@huawei.com, mark@fasheh.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, heming.zhao@suse.com, ghe@suse.com,
        gechangwei@live.cn, ocfs2-devel@oss.oracle.com
References: <20220717043751.51CD1C341C0@smtp.kernel.org>
From:   Junxiao Bi <junxiao.bi@oracle.com>
In-Reply-To: <20220717043751.51CD1C341C0@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CY5PR04CA0012.namprd04.prod.outlook.com
 (2603:10b6:930:1e::11) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f48a5c60-d52b-4e81-a47a-08da68e857b2
X-MS-TrafficTypeDiagnostic: BLAPR10MB5267:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IFhgYGayK/Fa1BktszhSOmiAtgp7QN0/Gnnj5v74g/YdU3Z+Z/XQE03hd/KDk8TnGtbPs/CuEQ04/IyJ7epygYfx2jUBPcSviRmxBHXD7XwyZw3ylP4vyUvP5xmVTZGIUpPuLnt7GbAjf7pQuj69PT1gdEFTIbn7l3xjGTUbfPOk5LvVLxKLVV5v1hAge2pGYPbrijfrscQhPY6kPCGrGSveWYG01Vc8wNdfT6Hz3S9T2EAQilM7PK5CMZAp8Kq3QhnP/J6hMlZs5dWDiyxUW0PEqWVHw/rtYsuq7Dp1k/K3OINZgeOYtocAyFzaLVNzO2VFaEOnDlVaVU5FMmsZx6NVMDkOXLnVtWTGOn4BcERwer3EsNNvNZeiOlAj9RU1iRRWUv4lcsQAwP9OgTXrjg0KCVTk2j66hNmfQlt67qZl1cAexFa01qTA/LG6n147UnE9jWG5t0N8V+6etjr1WqB4BsGnH6Xofa1Ci0zqelDmJOU+D5mIocYrNbojL9olKBKhMQVo+ydTAQeaZWneVWOuw6CZeJK/6JxfaU7U2hpcGSk2+tj7+bpxSbib1tyPtwDUUE1A0JeGI3NmcYDzwYrCWUuirDVqNLZn7IU+KYhU1poip5++B8SBRQhRsi5mmEjXgO1ZUwPxwXsGhBKudzmQmGyoksgK+sGI5xnwngAq8dHVntH9liqbTJIu4QO4eJA7zgYxRY6v3s/0uC/k9IT8qQq6kR9+X5YX0E+vDltIU7QXDP7N17sUnvCXSGJH3FRrC+ltEIro6X3r8F9Kcf8JON6JcYWdVA585zHJdGjVlC2A3PuoafjAIrcszuFaI7mIn7Iw4Tuf6V4+0Ej93Ne0HjOKA72xM9fzsZGCXFY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4752.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(366004)(136003)(396003)(39860400002)(84040400005)(6506007)(26005)(6512007)(53546011)(2616005)(921005)(478600001)(8936002)(7416002)(5660300002)(6486002)(2906002)(44832011)(41300700001)(4744005)(6666004)(186003)(86362001)(38100700002)(83380400001)(31696002)(36756003)(66946007)(66556008)(31686004)(66476007)(316002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cWZRZVVVRFVQS2RJeUk1bk8yK1Z0aGZ5Q2ZXZE5lZm9CV2M3azJuNzJaL2Ft?=
 =?utf-8?B?UGx3TmJFNU1rYklrM0hHek9TU1Z3UVRlTzdBTytLZlo2TDg5SUkyZEZXNjQ2?=
 =?utf-8?B?OHJzT1d3N2VIUmhWMDB3UFNQOTJoT3pmVnhHOVROdEFNSktZZDhGamdMcnJ1?=
 =?utf-8?B?Zjg3WVFEeG56cytia0dzeWdVbHNuTFRLSWRrNWN2V1djdHM0bkFaR0JZSnZh?=
 =?utf-8?B?a3BjL0k0OU1qdzRMZVMvWUJSUXRrNUZ6RWtoRHpqZGl4S0lSR21uZytKWnBp?=
 =?utf-8?B?OXdvenVyb0ZWVVNTYVhWUFFYWUpzbFFuazlmWUJwanZlaXFtRVlab2Yzb0lB?=
 =?utf-8?B?TENGK0NWdnowQVdwSmwwY0p0dlEvVTJvc3RTVXZYa1ExcUdtd2cybFdwYmxh?=
 =?utf-8?B?dnVoM1RwWGhKMWxMUTR2NDgzK05XUXpsY1cwVTBjVGs5aTFPWnpCNFd5N0tX?=
 =?utf-8?B?YkZHSmhhR21WSGUxaUp5MnJjY3llM0pMaTd5eDV1Uk9mQUhQYmlKWkFMNXZY?=
 =?utf-8?B?OTVZVEMvNmNxTkthZzdrMTlLS215cmhCcWVEaVlWUldkbStGRlcydzJYMW8x?=
 =?utf-8?B?NDVNMDNuc2lIdGlRTFFtRjZETVFsVnpCMzBwUHcyVDA4WTVyS2ZWYmZKbDBD?=
 =?utf-8?B?V09adEtKSDdKQ1FXWkwwbk1kSEdUZGIyZFl2NGJVVjVTSFhiRVl5ejhVL1hp?=
 =?utf-8?B?NmMzdFdncnExNVlrVDNMVXFiQWJiYnB3NE52Q0RWUkdwdGJzMCtHU0lXQ1Qz?=
 =?utf-8?B?TXBscUNncE53WExCU29LYytCUkZ0dVZ3YWd6c2FwOWJ4ZGJDU2JOenVZWDZ0?=
 =?utf-8?B?U0htVWhGaUlZdjdVa21JQnQwMUxzaUc5R1BEWmoyc0sva25BZk44VzYzSEpL?=
 =?utf-8?B?WlpuTEdwYkdEVHZ4SkEweW5laE9sY1RCK2d1SUdMYTZocmI5cHpvVzZsd09Q?=
 =?utf-8?B?RzNDaEs4Y3p2cFBQRzZESmlyRFI4NVBlU2Q5bGttMTNMclFJUFpibEgxVU96?=
 =?utf-8?B?WmZjaXBsbjQ2MmFWWkVLeXpGZGV4YkRoaVpUUkpvUzJjTXAwS2JyNjhRUTFR?=
 =?utf-8?B?RUZkU2NEUFFwajRYUCtkYnJ1Ylh4d05FT1dkNWppY3lBazQxNzQvaXpRK2lY?=
 =?utf-8?B?V3NtZURaNERHdUVKOSs1VmU4UXhTZ3JSQmQwQ2JXSkNTYWhFV0FNSTJaTTRN?=
 =?utf-8?B?OHFvYlVmUHpMdXgrblA3SldKSFkzSS9HZURqRkM4Yi9aN29YYkF6OGJhQ253?=
 =?utf-8?B?aC9PT3FXYmQ0akR5L1NTdERJdWY1bkRxcWgzeHB1NFdrdFBwU2FSMjVtdS9w?=
 =?utf-8?B?R0pzY2hLdkdHYjRKVitSSDZXZU5Zc2hEUkFhYzNueDZncGY4OXRzYkhIUzUy?=
 =?utf-8?B?ZXd5Rks4bmh5ODNlRDR4Y3h6dDYvK0tuOTZKY09xcDhzZlRxVjZTd0dMcThZ?=
 =?utf-8?B?UHlheVdZY0VDL0VWVXFXcTZUOHJoUHFHUWllQjFpT2lRVUhyWUFRWHhCMkMw?=
 =?utf-8?B?SEs2YlNPYTdCN3VPdWIwR1h5ckVxeHUvTnRXWE9SQlYzR2dORFdsaDRTOUdQ?=
 =?utf-8?B?VnRScnU2c3V3RGhvNDFBUkZSL2o5OHlUWkh5cWYxZVJNN1VwUkVZbW1XWUJP?=
 =?utf-8?B?dTRSU2JZbnFYYndpOXlmVUZ4WW1ac1drS3RiMkk0UHVUZWVicVo4RHV0U1hN?=
 =?utf-8?B?NTFrZ2Y4NVdnbWRFemczWnovbTIzZEQ3TUxjYTljZGZEWmRCUld0cy9TRGQ1?=
 =?utf-8?B?MDh1Z2x1c2ZmVmNXVGN1R0E3RG5pb2xLdWtzUzlXUkxaK09PWDZ6ZmJrcEUw?=
 =?utf-8?B?MmxKWWJLVkNCZENLc0FPMEg3VkgzdXNWWkhrR0pKWVFEVjgxTFVZcVdKK1Vu?=
 =?utf-8?B?aWRFZXEzaGFrMlhmUVMxTDgyNVZnRnhnNml1TnFyWStscE1ZemRhM1FDL3Z3?=
 =?utf-8?B?Y0cxQTBTRGlEd3lvamhocHJBL1ZGdVMzS25tckt4WG1LSGRZdjM1QkVrSFN6?=
 =?utf-8?B?VjlXVURqaXh5UTI5bmZKWFNpeldSeGJFd0tsT1ZSOE1KdnJOZGFPWVVkTG45?=
 =?utf-8?B?QUJ1azJGbEp1NTgrMXVLVlIzMThEUG5Yc1BJK3FTb0lvTlZOUWNKczZjZnQy?=
 =?utf-8?Q?XxF4VuoYRzOZe2X4okQygySFq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f48a5c60-d52b-4e81-a47a-08da68e857b2
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 18:07:14.1091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UjAMrkjIrLmTtDl04t96N2V9F/IrVn3vX4KLYK6ydkgHZcRQoURW4PYN0kuyCiWbrWNxFcnH9qm2MByf6T6PiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5267
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_17,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207180077
X-Proofpoint-GUID: REkJWitHhhHkhIx9pmFTRuWfMe6yXhov
X-Proofpoint-ORIG-GUID: REkJWitHhhHkhIx9pmFTRuWfMe6yXhov
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Andrew,

Can you help fix below "From:" to "From: Junxiao Bi <junxiao.bi@oracle.com>"

Thanks,

Junxiao.

On 7/16/22 9:37 PM, Andrew Morton wrote:
> From: Junxiao Bi via Ocfs2-devel<ocfs2-devel@oss.oracle.com>
> Subject: Revert "ocfs2: mount shared volume without ha stack"
> Date: Fri, 3 Jun 2022 15:28:01 -0700
>
> This reverts commit 912f655d78c5d4ad05eac287f23a435924df7144.
>
> This commit introduced a regression that can cause mount hung.  The
> changes in __ocfs2_find_empty_slot causes that any node with none-zero
> node number can grab the slot that was already taken by node 0, so node 1
> will access the same journal with node 0, when it try to grab journal
> cluster lock, it will hung because it was already acquired by node 0.
> It's very easy to reproduce this, in one cluster, mount node 0 first, then
> node 1, you will see the following call trace from node 1.
