Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B81CD3AD194
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 19:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbhFRR7Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 13:59:24 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:41234 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230318AbhFRR7Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 13:59:24 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15IHkt3u000993;
        Fri, 18 Jun 2021 17:57:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=e0NcyZAM8kKokpn0t8fHRdI7uctCASEvFsh2npIPm2I=;
 b=qOgx3bzNpCcfQWWtLH9531ujhk3mkkFO703VqAOFu9gicIpZZLVKtv8m5ZRp7uUXXK8R
 v4XTHhsY+5NE+ciD6RF9a5IrMyQjCFW4mQBLLG4SyMEA7sSlg2M2V6ZuZbTNk+ITP0kF
 flTpUZB11R8RH5q3YiUmVCPye+wXIhJ6P66ZaXeCC2nHvZ5ksEiTpsGz23TdYAiyZNFh
 8+7yECPzzeKFUNyG0QsvcBCUXZ100AIBLcyruDtkVwe76gjbuBGo4UsHmccjoYsK9SnN
 nmK3FPuiXXBhBK8K+mEZLXj0qF+BKNtnpzqtev819gh2pxLmwp6lldw3S1UARzJ+u+VA QA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 398s5p8tt7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 17:57:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15IHjQTx166841;
        Fri, 18 Jun 2021 17:57:01 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by aserp3030.oracle.com with ESMTP id 396wawxnge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 17:57:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fh3/mSo0Zt4dbtlCNK6Gig+xQjfwLWy9/lqBCaVQbpt3uY48S8QowfnrydsQyf2aEXmyZcOSZn+j4Uk2PEaKPvrQfUP3iEDWq/6kz9W0poVfpaMqJLUot0lzzavsiOL3awR0ClBL5AxSwOXQc9mxd6CG3rh0lmWIoPXK2rbhMXeQ12Ziy+cHSDiUl4uQYKiimD2JyxvOJ1Jylkhl0vwQi4kijYgbiWnLp0Mp4iOVJJAe8+akq3ZUP8VR6WitxtRgKCwaaOYxOU5F/g9BL2ZhwPwiObgLWqkOUZcuuUXHGg6cHLtrdKuMAbfV7vHKLyK52eutH9pY6zLSeEfYjplqdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e0NcyZAM8kKokpn0t8fHRdI7uctCASEvFsh2npIPm2I=;
 b=EzGRvYsBgpSrBgrsFgRpNjNdLXscx+iznXbxPPrMTbAgadXwsDOpfuyiPPagI1cXBrvF/CD15m/J6cdjK4FGNCLW6+dDP8mIgYOm5P2Z/nVLKv4iBE3Yl+KUat7NSgABtIy9w0bFup2x4/wSbTCBL9oYw+gq9o82d7ykIi87+8CJzETnwnpYcuLgs3paZwJqP+7shJTSD/NaUetkdZ4NZWw49PL5VJc1uk2gQxOsBZBGVW0BStUPuRiWxVRkEiQmdxAOa3P7ZZ2cPJCChWeG8hi1JRnJFHQgjXnnQyDvc+38A6hF84yEO6dl7or1ttD4RTtiCQK0VoOuHeWqV/Swtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e0NcyZAM8kKokpn0t8fHRdI7uctCASEvFsh2npIPm2I=;
 b=uF0y5Rel+pNHs3dwF8WYfLTgG5gvvpNTcvpqren4jOHW4YrsTvFWGmgNeRz/WLoVRHwxLqYDIDht9ZUAU3aQYH7Ca19KtuPwF1muNHloEa61b+4oBDYsla/rQGe0GYH24G+rKLSONO4lJZmzvaOwsARmKuL39oAXyAwNmqzDunk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4682.namprd10.prod.outlook.com (2603:10b6:806:110::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18; Fri, 18 Jun
 2021 17:56:59 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4242.021; Fri, 18 Jun 2021
 17:56:59 +0000
Subject: Re: [PATCH v3 1/2] blk-zoned: allow zone management send operations
 without CAP_SYS_ADMIN
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Shaun Tancheff <shaun@tancheff.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jens Axboe <axboe@fb.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210614122303.154378-1-Niklas.Cassel@wdc.com>
 <20210614122303.154378-2-Niklas.Cassel@wdc.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <622cb1ab-f5d5-3e0a-cd0e-e5baa9691ebb@oracle.com>
Date:   Fri, 18 Jun 2021 12:56:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210614122303.154378-2-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SN4PR0501CA0005.namprd05.prod.outlook.com
 (2603:10b6:803:40::18) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.28] (70.114.128.235) by SN4PR0501CA0005.namprd05.prod.outlook.com (2603:10b6:803:40::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.7 via Frontend Transport; Fri, 18 Jun 2021 17:56:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b03c1b65-2d27-410b-c51b-08d9328277e1
X-MS-TrafficTypeDiagnostic: SA2PR10MB4682:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB46823B727FAF32B751684D0DE60D9@SA2PR10MB4682.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g9ObFlCZ35J0zRpxqIXDdL8pd5B38KHSds+wXgwUnGGzrbM4DGNiQiK6agYMlNS1p3kzOOMWbD4yBxHHkKc0cSToK4QdQqdZJm6khSHGqc9ViCY7YUutBAE6YqiSr4dkkxsQ/ufUoFSiOWtNnFGzBBSARf98JUioWAYe0KRXG51vJ2+HqeXqj89Bwh6TOR7SScABQIC6UTeg8Nzy7YbGR+InZHzSsMRMCuvUdIY619O4SmqaCZoYoEjnHEFj8GZPEN61mkJ2VcL0hMNBk/85vhpwlEjnTgKff8Zci0gUo62QI9NJmsPsm/U5XovU3cJWpLPwwOZGsCPreUdtxS2gw6F0etzMpdYZVXzJM0TUz2KsWP5ztTpq8IxZ8y8wfsohqQVuoNSTejohz4QI0k9u0Zb8ww491juDQzfT5H8xUdthXT6Zj4kT60ueKrmBkyAjxKtpqYD7bpKczvdBt/BjDGw2uemKw4IYAHUJJt4EiRW8rOWrlkaj+3JCGnpJGS3V08xaoAMd3whdL3YsoyXRNpsasP4LYf3t1hqcaaCmqzXfCnQjm1n1SSZV/VdhxqWFfYX5oNspwBuBwJxp7c3Cd3WsQS8dMXkdGSBInei7LwiaCpy/aIcJ2RhLNFKkCNZzmNQlR0S15RigCKMW9Blf0XvEpvFlOGE1IoV6EdvuHVDj14Nc5C95MH8ZheUmvtz1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(396003)(136003)(366004)(6486002)(8676002)(16576012)(478600001)(110136005)(956004)(8936002)(38100700002)(31686004)(54906003)(2906002)(86362001)(36756003)(36916002)(53546011)(66556008)(316002)(26005)(44832011)(83380400001)(5660300002)(2616005)(31696002)(4326008)(186003)(66476007)(66946007)(16526019)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bGI1aHFwd2QxamgrTjFoZ3grK1piNkVMUkNOMHV2VmFORlg2Y2I2YlV6ZXFn?=
 =?utf-8?B?VEY5eittSTZKZ004Z3BSQVcwc3lCUlZVRWx2dzY2eXpyZGNrUllVekljaDlv?=
 =?utf-8?B?NzdsU3lvejdvRkhWaytta1N3eFBuUS8zeGJHNEV1VVE0cVM5N29PSmkyZ3Q0?=
 =?utf-8?B?Z3hma0tpcFc1ZkFGcCt2dG91Yys5RS9yMlNFcG84eko5eW9HSll1bmY0SUEy?=
 =?utf-8?B?L0RGWGRVeE1uUnphYzV2NGJGNVZkN2RKWEhIZlpsL3o1TnRPTkVTQjRBRkdX?=
 =?utf-8?B?U1B3Um5NcTVDV3ZpbUFGUThrRzNpMDYrZG00dlF2M3lNRXBaYis3QVp4OFNU?=
 =?utf-8?B?OEZ3VmF2VEgwWmQ4ZnBMSFlZOXdVREJxaDgvb0FKOVNkY0txL0lVTzFmZVg3?=
 =?utf-8?B?Wk1uaWlDTW5ick1rZGxONFp3Ym1EUEVCT2lxS1JrTkFrUGV3dGd1a25Obkhx?=
 =?utf-8?B?dExLSFl6Z25JVkp6YnhaUUZYbHVmVDczK2plcUlsRURqNFRERElncUwwcU05?=
 =?utf-8?B?WERGMWJycTJBSzhkYlA3YjZGZ1pMbXJBKzExNlFzUEMrNHVEZmtCeXVyZXJz?=
 =?utf-8?B?dU9wSU1NS2tjYjFXbjRxdWpqYU5nM0w2SVkxM09LZjdjeE5ZcTIyVUc5eWcv?=
 =?utf-8?B?c2U2MEx4RjFUM241QlZybHhHVXdPcVhXZGZPbXRCekxNUDNhazVaSTZxcUIz?=
 =?utf-8?B?UENUd0JmVWEvZ3luNkJHRzhYUVd3Z0NJbmhiMWZOenVhb2Mrd1g5aDNWbC9r?=
 =?utf-8?B?ZzZPRFRId2orRGFIdk9VRzI4RE02QWgxdHduc0RObmZzSnBFV3ZweUJoRUFv?=
 =?utf-8?B?UnVFelRwVUYrcUlXM1FERmNtWmwzeThBcXdDTGw0Ums4enA0ZEdWcGZSajQ2?=
 =?utf-8?B?WG4vdUgxSG5WQlV2TVo0cytJMU5FbmVyU2FGeWd2cnpuRXVCWnZTMHNycGJO?=
 =?utf-8?B?R09iaWlSU0d4OFFuMmgrY3V2cWF0RW5uQ2kwMTdDUzI2Y3U0SlRUVy9ZZDVX?=
 =?utf-8?B?R0RMQVRNblQ3YzlhTHZBREdSa2x6QzZoTmtYMjVMdHNnT05oNkNEdHJoZ29i?=
 =?utf-8?B?RHhaa011bEdmNFNjMytxWWZGVjFRMDRMZU1UU2loUGE2RGMvU2E4djZ1dGtx?=
 =?utf-8?B?WlVPOFo1ZzcwTzc5cUJCZHF6ZFp5aEkwYXZNNEN6SmcydHpucW96NnNBcWEz?=
 =?utf-8?B?NlE5YkcwU053R1ZaTldOY00xWUNSZHF0d09ZYXhqaEwweDBGRmZEaG0xWVBP?=
 =?utf-8?B?OVFGcjRtVmMzWDhTN2lJWHBYd0xmWXRtSkJzK040SUZmcGVhWWx0azhRRE4r?=
 =?utf-8?B?S1NGTk5SNEhMRDk2YTZFcDMrQ1FKSXYvQ3ZMdVdrb3dJQ0tGZGtuUDc2TjFM?=
 =?utf-8?B?MG9OOFlFVnlXN1cwWS9pSEFicTZLRzNob1BRM3IwOTNxdk0vaVlqV1RRWmFp?=
 =?utf-8?B?ZUpTaSttWnpIRjZNazdDVHB0V21GNlBadm5PRElGRENma0hBWWVYSnV4NzV2?=
 =?utf-8?B?QXFtM05kaXdSZDhFelVGZTY2TEZYdmxQQit1VUkzYjNPbGtjSjNqSm5yaDI4?=
 =?utf-8?B?aUc4S280NHBKUFppVkRBUW9jeUUwcWZrYksvQjR5RWZTM2JhZXRSbEFydksv?=
 =?utf-8?B?RDZBaVliVDhPSFpkZVJ5V3BPMUFJL3pESGdHL0xXaFdjUW0xRStDdytEbUxZ?=
 =?utf-8?B?ZC9jRjkrM2xxVjdJWHN0eDBBcmJ6T2ZxSVQ1L1NBdURYTm5FV1JpaGdsSVRE?=
 =?utf-8?Q?Y478oMj/QokcOPlyCOkvlb5PbuZSC+QPo/qlF73?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b03c1b65-2d27-410b-c51b-08d9328277e1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2021 17:56:58.8927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3MGanOBQ3tsccyrM/4nJz9EW4gfGh9+m9LW+mR0XEYhmQPBV6ia92kbNeRrRPWm/1eNWdxC7sXDd1F7SldeHmVdG46m0FAxkYRvrCUcJy+Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4682
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10019 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106180104
X-Proofpoint-GUID: ark3hmiZvHTHL7MIyPbPvis5dkeShdcP
X-Proofpoint-ORIG-GUID: ark3hmiZvHTHL7MIyPbPvis5dkeShdcP
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/14/21 7:23 AM, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Zone management send operations (BLKRESETZONE, BLKOPENZONE, BLKCLOSEZONE
> and BLKFINISHZONE) should be allowed under the same permissions as write().
> (write() does not require CAP_SYS_ADMIN).
> 
> Additionally, other ioctls like BLKSECDISCARD and BLKZEROOUT only check if
> the fd was successfully opened with FMODE_WRITE.
> (They do not require CAP_SYS_ADMIN).
> 
> Currently, zone management send operations require both CAP_SYS_ADMIN
> and that the fd was successfully opened with FMODE_WRITE.
> 
> Remove the CAP_SYS_ADMIN requirement, so that zone management send
> operations match the access control requirement of write(), BLKSECDISCARD
> and BLKZEROOUT.
> 
> Fixes: 3ed05a987e0f ("blk-zoned: implement ioctls")
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
> Cc: stable@vger.kernel.org # v4.10+
> ---
> Changes since v2:
> -None
> 
> Note to backporter:
> Function was added as blkdev_reset_zones_ioctl() in v4.10.
> Function was renamed to blkdev_zone_mgmt_ioctl() in v5.5.
> The patch is valid both before and after the function rename.
> 
>   block/blk-zoned.c | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 250cb76ee615..0789e6e9f7db 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -349,9 +349,6 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
>   	if (!blk_queue_is_zoned(q))
>   		return -ENOTTY;
>   
> -	if (!capable(CAP_SYS_ADMIN))
> -		return -EACCES;
> -
>   	if (!(mode & FMODE_WRITE))
>   		return -EBADF;
>   
> 

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
