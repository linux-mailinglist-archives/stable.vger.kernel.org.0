Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 990433AD197
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 19:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234237AbhFRR7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 13:59:33 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:47230 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230318AbhFRR73 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 13:59:29 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15IHjsME002602;
        Fri, 18 Jun 2021 17:57:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=vY1FS+qlZadQeSxQgRGWmrEe+2MyCSD84PZnafxWsX8=;
 b=Per/8DqEG7v2c+LOOR1FTC2sHge/o5FkMUPJOmqzm4HeDa5kYzP4fZYBNmGW/DG9GyAi
 MOPtStGFFtt8APtgQW+6l6Voa5w12z2LnxNgTKHPJ02UxvAI6eb8CuD0gO95JM4rCNlp
 wyC0k5lPIVC8YwpHn2RMxzu/a+POxob3h8JyZC+J9vmtZth3oKOnixtfFf3TlHEkIXps
 EIrWH6P1zAJLegXL1s8179bSq+iI/1s71TOtSgzIQ5HRjYYT/41LSGlzFS3MxzEviFtD
 XH1fjjhc+kBetFlpIk8vrescQsUhHJuH7OKHBQy3dfaX+lhsofxPm+x9F+A5Hskovv0R cg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39904880ru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 17:57:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15IHjdWS018546;
        Fri, 18 Jun 2021 17:57:12 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by userp3020.oracle.com with ESMTP id 396wb03s84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 17:57:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gX60Nf6ls5uxSIky4qRYNbIuZdgAFm16nymN0ZSf3Iyxzvd9+zvtzZuGWGCJBgmUo+03Ks6h/Qav7maHhm9xYzUQ+bsTf5UmD0pJyO3bzjemPhAV1TLdnhoD5BPBMRCV8PTAS3xP0/7JGGzbo6aGjY6M0bSorl7sIZK/5/MZo13JYbMf74AIdCawbhLn5CbFvYJH/6doVRzWX5j4XRKekv47F2eekVSzHjktJc3iKntWttM2zEiC07lShvM2SXd8fBUzkeDM+aJIUBi+FABstXVrJSAyUNEQJ+Otsv1RWNG7bd3j/bJSFq8REHARG6z3kpHjLWHRI/IDCyZLKH4dmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vY1FS+qlZadQeSxQgRGWmrEe+2MyCSD84PZnafxWsX8=;
 b=g8HtxDUf3+6p0MYhuit7sZTA1ci1FsWoOZkgyltQy3cJzlZHl38v/Ol+iEZzdJVoECf4i68ra42kZMyt8DDtJ/5KcXsVaark0ml6cr1ohYGgwAtj4Bqd2ZToEJe559lgMlY4EavTVid+e+AN+5Kr3JVaS48wPY2tFl/ws/Tx1d0ojTYydBCNo2hOgj0keIXzghYvALxGEqWbKmpguwDj81icYxyZh/RTuMF9aVvvpDzbM57DyOKJlRQkNbgl0BwfA7f+C48giLKD7TUSGHcdLoI8gvW2SQHUZmXiZF8T4QLXDLN8MoCywPeyUXSd00ZX1CedUMGu5sGZyWXEvfooyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vY1FS+qlZadQeSxQgRGWmrEe+2MyCSD84PZnafxWsX8=;
 b=bghg06rezyVU8C4lt/KKVbjBkoK1LI294640Dlf8Zg04IexIGI5KINLgQuabhNSW/BXZrZ+4I75m9Y+K8od9Wxt1oxlgyaIgny/gqb9bTGe/b8a+rP8TXHDu2Ets/M+YsmTQ+F5bWJJcrdKpAAdlEoJQzLXtXZ3oRAQmFP9WmMw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4682.namprd10.prod.outlook.com (2603:10b6:806:110::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18; Fri, 18 Jun
 2021 17:57:10 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4242.021; Fri, 18 Jun 2021
 17:57:10 +0000
Subject: Re: [PATCH v3 2/2] blk-zoned: allow BLKREPORTZONE without
 CAP_SYS_ADMIN
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Shaun Tancheff <shaun@tancheff.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jens Axboe <axboe@fb.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210614122303.154378-1-Niklas.Cassel@wdc.com>
 <20210614122303.154378-3-Niklas.Cassel@wdc.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <07d2d0ab-0dbe-3ef1-b127-c7a9eee43612@oracle.com>
Date:   Fri, 18 Jun 2021 12:57:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210614122303.154378-3-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SN4PR0501CA0015.namprd05.prod.outlook.com
 (2603:10b6:803:40::28) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.28] (70.114.128.235) by SN4PR0501CA0015.namprd05.prod.outlook.com (2603:10b6:803:40::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.7 via Frontend Transport; Fri, 18 Jun 2021 17:57:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 691ad019-0742-4258-f798-08d932827e80
X-MS-TrafficTypeDiagnostic: SA2PR10MB4682:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB46824436488BF2A7A1410BCEE60D9@SA2PR10MB4682.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vkmZncBF1BSFb62Ob3Rk+VOW2SdMCoCSSxCxzmO5ECYPfSr7zOUVgVmJRzDB8dxOBAhvbo+SwQjNxXe995Jz6EAx8h8WavjqCD5RofmBnG9Eeoevd+PVU/E4YHCHteAYDCu+D53OaL5lMiLrjhy6YHp+dyKtjcl6GQZbH5rfe7W7F4rdrhG9xdTmsGe8kzYM8HsR1+1KGa8mdJO/ARFtYWGY6CHu09xim8VcrWYD43AFIQD18hwetMiPOblSK87r0ijwBkfaU4OkLsw4Xub6FmsEXlx1ArMpn2XJkSLZ9d1wosb8EF/KF/kC4hSnGWpL9LlKzSlatsoqQYKpqwsvgl4ugVU3O+yqaKBkXi03iuo3Bh6NF104ZOCl6lDucCvH7KYIjcIGMd81COAkJKk9xtW7L7WLxeZQJ/WgAcD9RzkTcvDgy60A53+PN1+tOi0h3MaED2xJ3SFs4vLZs9BXPViu3FfNSkjE8WTqFkfMeMdWkWK3G73ll194O4QiTMpTQPY13wkTw8dGm8ecXgb0Ov/chALVukxs0BayfVX9GItws9jczgeLwe0HJmZkisT+s+KR3kT8/+R2CIAkaia/PK+bUuSpWPaZoN4Z5GZvYWVBUzNAQLfuvPUoKOA1urh1kW5+BilGMtkGOBOTWeUZIdOdk3Vdz45pUgwgTwoGfiaVXIC2lAjRSvblcbcJ23ni
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(396003)(136003)(366004)(6486002)(8676002)(16576012)(478600001)(110136005)(956004)(8936002)(38100700002)(31686004)(54906003)(2906002)(86362001)(36756003)(36916002)(53546011)(66556008)(316002)(26005)(44832011)(83380400001)(5660300002)(2616005)(31696002)(4326008)(186003)(66476007)(66946007)(16526019)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MGdSazlmOHdaOG1RZkRqalcrQVR6N0x5Zkh3M2lkSGZKbkFiWVdsUm5Sek9S?=
 =?utf-8?B?ZGt1QkQrYTdtd042ZVhEdnlJTVRnYUlGUERSbzRrK1hvSkcwSldHWUQ1OXlj?=
 =?utf-8?B?ZEE3VHhPY2VTaEpqOUtGYmdSWllkMnFqU0RPSndiTytvNmpMY2xES2Y5Z0lR?=
 =?utf-8?B?WmVVVWtjZFhmK0NvYjJoVGU0ZHhIWmFxRXdYamVzb08rQ1h4YWx3N2lEQkEw?=
 =?utf-8?B?TTR4TVdkQ3lGYW5ZbmJPanA2NE82bnAyYTlSeDZWVUlFdUFvK0FNNTF5aXlO?=
 =?utf-8?B?VzBCTjRYUEV0eVIwTXdGU0lGUGR0ejF5Qk8vMG1lWHJDLzRwVW9Hd25udGtt?=
 =?utf-8?B?RkJqNHAvaWZ1WXZlMnA4L21QMHRUZUFCWUh5RTBiNSs4UjkvM1JlRmR2dW9k?=
 =?utf-8?B?TXZ0YkgrRWsyYnNER1hXcERnV215SHpuUngzYSt3T3VGbDhVU1BUK2gydlU2?=
 =?utf-8?B?d0laYVI0Z0JZTFBtaVo4WTczdWF5UzJXTWFRTnhJejB6WjRGOUI0TmJwMnM0?=
 =?utf-8?B?aElTWjFyWFVLWSt2OVQzWGEyOUNrVEFZOGZmUFhFU25mNEJ6ZCtpZ0x2MGpC?=
 =?utf-8?B?SDJzbDVlL3FzajZNTGtSbGE3VFdFdFJKZ2xQT0J3Tlc5cy9GUCtoeHJYRSs0?=
 =?utf-8?B?SDdMdGQwR0tTMGt6eVpzUElWUTJKSnkxdFRWaFZNRGJ4QjVMRVk2NTAvbTNC?=
 =?utf-8?B?MHNHbnVFYUVsb1V1VEsvWmY2bmlwcjJDMVlvVUlUYndrNWRmQURwSHF0TDVQ?=
 =?utf-8?B?U0wxdzJVYmZWMXVCdDZ5ZVdsZUoyRW0yamZSdnpNd0pSR2pKOEU5Y1hTRXFu?=
 =?utf-8?B?UktPeTRtSXhscmhBcFVhQzRRb1F3d2txQ1hEUGY0YkkxL1NFc21mM3Rhc3RX?=
 =?utf-8?B?cWRaeDEvaHAxMmszclVVRnkrSUFuc0ZwYW5keldNbFNUQjRIb000MG5rZGd0?=
 =?utf-8?B?K0tpMVM3eEVzRlNRN29HenFJc3FvNnRTTzRXUnFPeGVFamVHNExYUXJzRnda?=
 =?utf-8?B?VzlXdDBlNE9sNXg2YkxFeTFkVWhXcnRqcWhOaTJJcjIweVRMUG5JN2dqSTRU?=
 =?utf-8?B?ZmlOUU9GVGI5MEo5eFppTDVDTCtid3QxNEg1WG1Yci9mZ1ZuMFRkd3JNMjFz?=
 =?utf-8?B?Tk9EUjdLcFR2QjU5T3RudTM5em5wMVQ1MnM1YWErTnVZdUZxZXBHQUROYnov?=
 =?utf-8?B?MXZ1eXFnYTlvMjBuOVlHRnBOeldKZ1VsY0w1OFVKRmVnV0hGaGRRTEFEdCtB?=
 =?utf-8?B?Z2FyVHFwOHJULzYxdzNydWFwc1BPbFd4eHlxWHBYN0lrNXVUcDZNZWJ0L2ow?=
 =?utf-8?B?T2RBbVpIakFJYUdZWkF2RTZrak85TmlEM1VjTTBaRDEzMlVCaURiUzQvaXRC?=
 =?utf-8?B?ellBcFVNWDBqTkRZVFl5TC9ycU5HaTV1VnV6aHJvWDdPUEdmZzJtS0tVdnJP?=
 =?utf-8?B?LzdPSVB0NmNVVjFFZ0wvakR5aTQybnlScWZ0R1pBZDdUR2ZWVjRyb1M1NXRh?=
 =?utf-8?B?U0pUYldNc2N6eVl1aFhsSlBoSlFiMUwyQ1JBUzFZZ0gwWWZIR21Tb3ZOYXk5?=
 =?utf-8?B?Zmt0S2xDUFREMWg5eXBvVkkvMFVsQmsvb05hS3pScWswaUZlVWhiUUZhdjYz?=
 =?utf-8?B?Z1IrQThQUHQvWUhoa0VzYzZLempkckxVRnRKMmo5aHE2WEFScnpXbDJZK2N1?=
 =?utf-8?B?WE5pNFBhdTBMY1RGNW1jaVBCNnlocEVGSytqYzZoLzNTYzc5UGNrcVgvWkdp?=
 =?utf-8?Q?bI/yTKia8UtNpOsZU5+DuUZYlblp8CyGsEvaMXv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 691ad019-0742-4258-f798-08d932827e80
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2021 17:57:09.9903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rtBEbkLl5begTFCVVX3/qyUyGNFvkC5Ew7QmsL92jszYmnX66JbQs0yYQE6uqiwjPXVO+3rB35VGw2CdWm63AHtG226RL7NOpTiMqUCiDxg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4682
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10019 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 suspectscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106180104
X-Proofpoint-ORIG-GUID: 11uJMdPFQTQSeZ5c_2AxBCq1KAeIjhZe
X-Proofpoint-GUID: 11uJMdPFQTQSeZ5c_2AxBCq1KAeIjhZe
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/14/21 7:23 AM, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> A user space process should not need the CAP_SYS_ADMIN capability set
> in order to perform a BLKREPORTZONE ioctl.
> 
> Getting the zone report is required in order to get the write pointer.
> Neither read() nor write() requires CAP_SYS_ADMIN, so it is reasonable
> that a user space process that can read/write from/to the device, also
> can get the write pointer. (Since e.g. writes have to be at the write
> pointer.)
> 
> Fixes: 3ed05a987e0f ("blk-zoned: implement ioctls")
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> Cc: stable@vger.kernel.org # v4.10+
> ---
> Changes since v2:
> -Drop the FMODE_READ check. Right now it is possible to open() the device with
> O_WRONLY and get the zone report from that fd. Therefore adding a FMODE_READ
> check on BLKREPORTZONE would break existing applications. Instead, just remove
> the existing CAP_SYS_ADMIN check.
> 
>   block/blk-zoned.c | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 0789e6e9f7db..457eceabed2e 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -288,9 +288,6 @@ int blkdev_report_zones_ioctl(struct block_device *bdev, fmode_t mode,
>   	if (!blk_queue_is_zoned(q))
>   		return -ENOTTY;
>   
> -	if (!capable(CAP_SYS_ADMIN))
> -		return -EACCES;
> -
>   	if (copy_from_user(&rep, argp, sizeof(struct blk_zone_report)))
>   		return -EFAULT;
>   
> 

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
-- 
Himanshu Madhani                                Oracle Linux Engineering
