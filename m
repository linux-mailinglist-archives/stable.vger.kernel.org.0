Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74D064CEC40
	for <lists+stable@lfdr.de>; Sun,  6 Mar 2022 17:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbiCFQiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Mar 2022 11:38:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbiCFQiC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Mar 2022 11:38:02 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18452654D;
        Sun,  6 Mar 2022 08:37:08 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2268Js2H006652;
        Sun, 6 Mar 2022 16:37:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=+ux9CD9wRGZ88RcLDmJF+M7jPdrABz86AWKVfHaXqhA=;
 b=KHDFLRmXaw0hokZwErMhdLHeXrLfDE6IJe2DHd1dN55hA8BSuXCqS8rx09OaGTkwPteg
 hVTJzsTYbNeq9FtRvrIndrBG8I5uLRO5KbOqLxgqsqDQZwE6GCyO5IWYfdijZI8K0wgA
 5nfC+WzrXqLZLWrTQbj4/DGDPrOl60i1I5lqyfR1O7pEhcT/MjSKFfnnZkT/YFKHlC3t
 RLB3qpdCIXIBsfBvx1Pr/HysND4UFKMslgcm9ULa1nR6YGjmVy2kNl19ELd/v1oZlsPU
 JnOg0WIRdD7DZv2A1FMi5x9QKJsnDm2Tl99m60i9Hm63BtBqGOjAnarCKjym7NHkfbCF Bg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekxn2a240-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 06 Mar 2022 16:37:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 226GRpGE042616;
        Sun, 6 Mar 2022 16:37:03 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2045.outbound.protection.outlook.com [104.47.74.45])
        by userp3020.oracle.com with ESMTP id 3em1agy3jk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 06 Mar 2022 16:37:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iyO130WtzFd1DX+4gxsU+EA1dTVZXNqrdzmJs9pPtDIvFid0tQzuBhWD5eeKjlRzi26jUFmQWlAErIwYrEFeYN9tFq5WRM9qD1vlc8H+BmfpWcNGXOkFOTlA10tdEVsCRQigt3cOV1JiMbyPWO9KgCcZhtd6SlH9RBN8XAaabWH9VD3gFfmqyj5V2NRfz1xECmMH7sLICJPqPd3P93UubN5Mq4BACh/e6LA3fTtzWCDx8UDGQ3e576d5eXzCYymkCeXTFA8IPfQuY7KvjdOXqO5GY3gztyoQ3DitKs8QYxoaP8QhaW7Pfa59qqJuKbzetJS11mdzZh5o7aqgkxlPLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ux9CD9wRGZ88RcLDmJF+M7jPdrABz86AWKVfHaXqhA=;
 b=FeEAT1tRD825bEluIyMvtfp+vzIT4TVjUwz+8EgHmDsJHtbNHZG5ncyfJks7xKiGuHijBe6x8Z8nvnQKfqSmr30Waql1es2MESmM57NfXL3iuKDZcC6IiXtrZnLAB4+2lFKyy5xTyoORMfUJoZOu+8Wg7OoBar3hbaRnzeuJotFLcNVLmByrMxYqvfOWohOMJDcirNN9erCnJMnipNPZ2FT53A/FEo99AMB3lYYy+nQ2+h9+mKtnHGXuG6+Kd3H41fXsmjCFQTeG8M463cQBIW2R/MoSbHIHu545iB5xskP7v8OGr9d9UZ9gPYvc2w3AVpr/0Rdg4tt8dH7RFWsgBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ux9CD9wRGZ88RcLDmJF+M7jPdrABz86AWKVfHaXqhA=;
 b=JfnHn0bt/BbKZ5fWG3qnN7OjDeFiYzgKpQv3Bs30/+SU6MfnK1bZxpuKhhbIk7v7fii9i64sgmNoJ7we4kR5eimWQBn9EaJztkU4KqXKGIbigKjVdn/n0xNqsO00Znxk6NiysTAll+6fHaNbv30i63XyQ0d9XtxhXYLHhTWPdZM=
Received: from CO1PR10MB4627.namprd10.prod.outlook.com (2603:10b6:303:9d::24)
 by BYAPR10MB3590.namprd10.prod.outlook.com (2603:10b6:a03:11a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Sun, 6 Mar
 2022 16:36:56 +0000
Received: from CO1PR10MB4627.namprd10.prod.outlook.com
 ([fe80::7d11:e9f1:aa03:b145]) by CO1PR10MB4627.namprd10.prod.outlook.com
 ([fe80::7d11:e9f1:aa03:b145%4]) with mapi id 15.20.5038.026; Sun, 6 Mar 2022
 16:36:56 +0000
Message-ID: <8fa2dbee-75a9-6194-05c6-3208e6be36dc@oracle.com>
Date:   Sun, 6 Mar 2022 19:36:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] btrfs: unlock the newly allocated extent buffer in
 btrfs_alloc_tree_block()
Content-Language: en-US
To:     Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Cc:     Hao Sun <sunhao.th@gmail.com>, linux-btrfs@vger.kernel.org,
        stable@vger.kernel.org
References: <20210914065759.38793-1-wqu@suse.com>
From:   Denis Efremov <denis.e.efremov@oracle.com>
In-Reply-To: <20210914065759.38793-1-wqu@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6PR10CA0099.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:8c::40) To CO1PR10MB4627.namprd10.prod.outlook.com
 (2603:10b6:303:9d::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e3fb95a-a570-4d1e-c846-08d9ff8f86f6
X-MS-TrafficTypeDiagnostic: BYAPR10MB3590:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB35905030013211A3970BD832D3079@BYAPR10MB3590.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jnHzYwavYqJokHyG5KP8SFrx7oE0Bp60JnQoZLSOHls5Z1JfJr6jvwYEutW4Y6Jk8ag+JwcB4X+fN/VQ8qwKRW6w2UwlSRmN7VhCIK45P2i3AygsurA16fJqAnlLiyADnjgvLfNZBzI/3PaSSYIx8hpUNR6mrvCsCsMBV+70OkV7yGQE6m1dtws7LuLgPXAxUZq2Pr3uFy/mNq361UztvuccfYRXK73EkTotJVaUdLNATf2Z5ZFu8wCXb8lHwionntcQtqXiLuYOsba4zImaHzHE2Az05z38oDzsmkqzhXozjMLQfPUJdaDQkluoIHUnmKSBG1NQ7nir+Fgcu5u7qbmOUYQefX3Ku14gu9I0tZg7Rll4ZmaoOtp7b4rzHNATwj2ou1tCZgDxr1x3CStHV6/35gh4ZzWs5VChO7LMKt3L7CDEmvjEDX4d1axvWjLRTJqTRn8jaWO4W0K6dEEv//5zfRf7KpBF5686KW/Zy/lq5CgJCa87+LSi/bXgdD0XxtCfKEv2ZctXBSckJcVsMl+XWBd9Ueb2R+nGMx9ikQbNaG4NsMBAtBtolLDRy3g3WMBG07ghuLWleZcLdVRnEwViyq3u1M8e5WdM9Jt2w6CqQ4HFhrhtfEHqsImwqF9+fq4Wt20X9gSPXjV+/Yrzt9sIFIDw9CgK8/msM7l1h/ge0cU7jfbI8NuovNVHfeIOLiy3i2LKwV1ENxeMwePL0077njU2Ekr+5Q/zlGJAsqzyCjjnP7UKwJ6nEq4KR1V1wwWAdZsI0fnePnIgHc0A05xkYqKUrQREetQRp7VsSfcVHiii83cKLtZDz4CXJkFW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4627.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(8676002)(4326008)(66476007)(66556008)(8936002)(31686004)(5660300002)(110136005)(2906002)(966005)(6486002)(36756003)(508600001)(6506007)(6666004)(6512007)(53546011)(2616005)(316002)(83380400001)(38100700002)(86362001)(186003)(31696002)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VTdEOFRIb0doRUJ1R2haZTVFcEQxV2p2RzN3d3lFMTVpZldzZUFyQ1hwb0Jw?=
 =?utf-8?B?L2JkZVVDWm9rRWY5bXRweFhvbktnSkhQM01wV2djaDZMTHRNQUExY01zc3lU?=
 =?utf-8?B?RDRuSDFmL0s5a2M2dGp5MmpNV2Fxb2xKaHlDZ21QRHdVREhSL3p4NDhXMTky?=
 =?utf-8?B?MDBHUEpaajNBek5ZQW15Mm5uRmIvZmNWMEFCNnB2VFdXcVRGazhuMHJUTWJ3?=
 =?utf-8?B?LytUNEVXQnAyakozL2JJT0xYMlVpR3puMVJoY3BQVDh5ekkxeUtWak5vaTFr?=
 =?utf-8?B?SDN3aHNkV0Y2NzJhdTRTdjVQZERydjJQWnViK3RLQ2NjaHhtVnJTRlBuZHBk?=
 =?utf-8?B?K2pYVDUwRDAyNHBTelZjNHB6aUowWkxMWlprUTNweDlNWUpMZlZSTENqUXZX?=
 =?utf-8?B?U3psa3IwVk5JcXZqUS9ENzJUY0huVG5pM2wyVUg2OGVObDAyS29tYXNwKzZ4?=
 =?utf-8?B?R3IyZkJnUDQ1NTJMMGJxMXVsRHZsSi80Y1M0dmRnNkxOejU2dzViS2Z3b0ZG?=
 =?utf-8?B?d0xjMm96NnM1cWRmcnVwejM0L0RqM1g5T3BnbGtSQzFFOThJdTNaQnhqei9X?=
 =?utf-8?B?aEdkVmZGQTlRMlp6enhwVHpSM0x2WHgvakt4M2RNUmdONDh6c25VZzA2ZTAv?=
 =?utf-8?B?WTk4eUZpQ2pLbnQ0Yy9nMjI4amMvSElKZi9UU0RBSzdDa0hTSVRjamlRZjZC?=
 =?utf-8?B?bXpBQ0ViR1RCL0c1dTltKzVLVXo4WG52cDlmdnpOODI3enFscmEwOUR4Tm1J?=
 =?utf-8?B?Wmc2TFFML0ZlaWRnVGRTcGh1ZGJpcjllNzZRenJOdnpKYmFxK1B4RHhYSEZx?=
 =?utf-8?B?SXBFcnpJU21pazlDQStUdXNRY2ZwWStUVlhWdjNXSjMrQzF2c29rdHpDRFpJ?=
 =?utf-8?B?UDgwaS9VcnZRSUtXSE16eXhNOE50TW5nZ0pHRGpvUmlzSFMwc3V1VHZjTFNi?=
 =?utf-8?B?WTVta1pTRFBRUGJVQ29jb1hnSDRlWTRyWm1UQ3pxeUVlQ0FSU2NkOWNBYkZx?=
 =?utf-8?B?akg1L3hGQjFwdUc3T2M1VWpnYkdsRjFBa0d4bUZSMXMyeUdBUTlCeTIyMElj?=
 =?utf-8?B?dEsvR2h5YkJ4MWtXcjFFYm5mY1RGbm1PY1RJVEthSitoQ3cyWFl1eDlBdmUw?=
 =?utf-8?B?YkFWYmovRzlyVWZ0Z1R2a0FYT1ptdmxHc3dGVDRmeTAvOGdZMmFjWW1NM016?=
 =?utf-8?B?SFZnOXNIWmU0OGVKektucUZwRzgrMTFhc1g2NlowV2loR2pQK24xWXRlOGdK?=
 =?utf-8?B?ZjIvR0Z3UXNPWElpR3doZFk0emJ2NlE0UnJFRVJvWURTYUVncHdEcVFFYSt5?=
 =?utf-8?B?cS9ZdUV1N1VrUFgrMmRSNTVqZ3YvakFWdlAvNnFSeXlPZCtVeGdIV01mNTB2?=
 =?utf-8?B?R3NIT2kvN0I3LzRlWWdnSGR3c29VRnhCZ2lYZlFvQlJicFhoTllnT3pGQnVK?=
 =?utf-8?B?c2UrSk9hWExzS3NnUlhOZUk4TGpEcDNWOWRXVjV4YkNtR05RNEQvZTlYNlZM?=
 =?utf-8?B?UEcrWkZlUkNCbGtTbGJEempaV1p1QXV2eWdWRS93UjVmME0rY0czSzN5TFNm?=
 =?utf-8?B?emhnNDhNcGJOZS9aa2VBL0JweDZwbzBLYW0reXdZcUlWMVJuaCtHY3RBOGRC?=
 =?utf-8?B?bjBxZUVOU2d1aTVSajdidFRWVE9HVUVhb0Z6MWw3dExVWmtEVVViY0pvMGdu?=
 =?utf-8?B?d3lWOGZQNllmeUkzTVRMM3ROakI0TzJOZ1gyQVJoS2ZHNllwNTFIbmVZSmVO?=
 =?utf-8?B?MlptNnB1NTVWclVkaDJTSkJRcFhFSnN5ZFZqWVg0VEMwV2JxNExoWTBLc3h3?=
 =?utf-8?B?Q2VUYWloVWNLakFSOUNYUnNmdmw5Tkc1amlhWXM1L1Y0b3FxTURVUzNxcFZE?=
 =?utf-8?B?bjZYaHZnS3prRlNObWdvcHIzTDBZZUJlTTJQby90T2J1MWZBQ2VpU0kzVUZ2?=
 =?utf-8?B?L2RVY3BhWENxWG11OWF4cjRWY2JlUkpEUXZ2cDhxdDhBREFqUHJWUmo4OVNv?=
 =?utf-8?B?WGgwbW8xVXNjRkttRHdvUzBRK3M0MlQzT3ZnS0dyajhsU0k4amdGc2V0MWxq?=
 =?utf-8?B?S2Uzamh0cEFlY0doNFhmSUNiVVJrYUNYdjJkMWFRV2Y5VHBvWkUyVTYwVGlO?=
 =?utf-8?B?ejNvSWFuU1gvOURJbmMwTW9tdUcxK3hnSnd1U2ZqUlFsRGtTM2JBaDVoRVpy?=
 =?utf-8?B?eTFsYitLT1Y2aDVWWEpEMTQ4NkNVWXFIOFhQQ00yMFg2NU92bmVNMEllYWw5?=
 =?utf-8?B?U2x2WVFjZ3B0UVhHajBaZ2VDTjlBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e3fb95a-a570-4d1e-c846-08d9ff8f86f6
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4627.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2022 16:36:56.2330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6dvC+AZVKhj4liBPYUcD/I/QgIys4OCGs/87+OQrNyq41Kg7/A424aQEVPau9jRBPR6yg65fvmwm03SpLjLhhXMYABIizWsRL7/FNnMYtXw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3590
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10278 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203060112
X-Proofpoint-ORIG-GUID: wSlsOzZCZCmf01qp8NEhXLL30bncOLYr
X-Proofpoint-GUID: wSlsOzZCZCmf01qp8NEhXLL30bncOLYr
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,


On 9/14/21 09:57, Qu Wenruo wrote:
> [BUG]
...
> 
>   ================================================
>   WARNING: lock held when returning to user space!
>   5.15.0-rc1 #16 Not tainted
>   ------------------------------------------------
>   syz-executor/7579 is leaving the kernel with locks still held!
>   1 lock held by syz-executor/7579:
>    #0: ffff888104b73da8 (btrfs-tree-01/1){+.+.}-{3:3}, at:
>   __btrfs_tree_lock+0x2e/0x1a0 fs/btrfs/locking.c:112
> 
> [CAUSE]
> In btrfs_alloc_tree_block(), after btrfs_init_new_buffer(), the new
> extent buffer @buf is locked, but if later operations like adding
> delayed tree ref fails, we just free @buf without unlocking it,
> resulting above warning.

This patch fixes CVE-2021-4149. Commit 19ea40dddf18
"btrfs: unlock newly allocated extent buffer after error" upstream.
The patch was backported to kernels 5.15, 5.10, 5.4 because it contains
"CC: stable@vger.kernel.org # 5.4+" in the commit message.

However, it looks to me like kernels 4.9, 4.14, 4.19 are also vulnerable.
In v4.9 kernel there is btrfs_init_new_buffer() call:
btrfs_alloc_tree_block(...)
{
	...
	buf = btrfs_init_new_buffer(trans, root, ins.objectid, level);
	...
out_free_buf:                                                                    
        free_extent_buffer(buf);
	...
}

and btrfs_init_new_buffer() contains btrfs_tree_lock(buf) inside it.

The patch can be cherry-picked to v4.9 kernel without a conflict.

Probably, the error was introduced in the commit 67b7859e9bfa
"btrfs: handle ENOMEM in btrfs_alloc_tree_block" It's in the kernel
since v4.1

Can you confirm that kernels v4.9, 4.14, 4.19 are also vulnerable?

Thanks,
Denis

> 
> [FIX]
> Unlock @buf in out_free_buf: tag.
> 
> Reported-by: Hao Sun <sunhao.th@gmail.com>
> Link: https://lore.kernel.org/linux-btrfs/CACkBjsZ9O6Zr0KK1yGn=1rQi6Crh1yeCRdTSBxx9R99L4xdn-Q@mail.gmail.com/
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index c88e7727a31a..8aa981ffe7b7 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4898,6 +4898,7 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
>  out_free_delayed:
>  	btrfs_free_delayed_extent_op(extent_op);
>  out_free_buf:
> +	btrfs_tree_unlock(buf);
>  	free_extent_buffer(buf);
>  out_free_reserved:
>  	btrfs_free_reserved_extent(fs_info, ins.objectid, ins.offset, 0);
