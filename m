Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7D537ABEF
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 18:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbhEKQbU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 12:31:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44126 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbhEKQbT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 12:31:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14BGEMFJ098062;
        Tue, 11 May 2021 16:30:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : from :
 subject : message-id : date : content-type : content-transfer-encoding :
 mime-version; s=corp-2020-01-29;
 bh=jJM81gODegdQCPMMUBhLnWvcW5SM/TyscW5tPJsJsI8=;
 b=xDV+D48DZXINUNCLws+pq7wRPDE32/GlVRnGi6V0NKTHWqH4sNhT3ucK3iM8jE4OsZo3
 Xj8sDp36rHl9IQdJ186FSlgY1H2ZIcinC8CWJH2EBFZxBinXXMnQ2a9yCrq+uTU/lw5+
 Cv555EN80Yd2pY1PON9ww4nYRzF+J8dU3HFoehS00vg7ZYhj88V8c5OCDH8mK3yg+iGR
 TkDA0y2lY+aJjYhoiEtcLcnmRxjtXdYoQqX+NInUY4ZDjHRu1KNCgUo8PDHlvALVo7bq
 BBTOg79Wmfw8qkScd2w9sRRqVahx1+uvdy+Bv/QyQtT0ns4dvf/RhdRL/Lw1V8UfFJ0u Mg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 38djkmfccd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 16:30:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14BGU2OB066659;
        Tue, 11 May 2021 16:30:06 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by userp3020.oracle.com with ESMTP id 38fh3x09xf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 16:30:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lXQkfIiBZBf7sSmbZYa46aFMP0FuVR99Pp8o/XBL1XJZoRzJHn/Qov7rY0y+XcVFdySYdvHY5QG9TOyVKjDo5FhKTlnLypq54YTerWRef1jE/zPpCMtv9KW/Q3L4Xeb0p+xXZSTOPHPAbcgxiMTlacEmV55VhlUGU3looliyr7AImnbkZOVCW+1sx3Zl7v91IX8Jby4HKULTisDr3xFy+kzxWZ4SqQg1mw29lPH0uIP8gy4KjRxUaZBzm41p0bIwfdvilcPxlgqOjOo4kQUAqv9pFJqI5I6EiE0b8QS1nw12Ow09iFILA+YBcR6M3wAQUZMTigQ/cv8Q2ZvvSdNtSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJM81gODegdQCPMMUBhLnWvcW5SM/TyscW5tPJsJsI8=;
 b=j/XLKQjfdlAdXt5UhzEgihk7JGAaicSqtqckLQs4naAT/dJb97Vel8+5gaYkKiczkuLosLAi2H08Sf0FqTNjDOJcnpP6BOrMjgxREJCOCH0jfDvVXl35TDJxFCzIAKuzFseeOlPBqvFs/UjGtKsbrowsqqLbsH/MCFxxrWvhXl+S/kpUFk8N50d0cbDx+N6vxkRue2cSe9LQ60hcQEWuwPZq182iAny//iVvQHkeJjuYbTukt/GeDfUgeAad7tZF3r9vqflrmYGKVyEEVdguV81ADG8rq/6xtpRxe5bKNzmlER34STegPyDHUXhg+9/YqWWOwGciieU7OC65ENFCHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJM81gODegdQCPMMUBhLnWvcW5SM/TyscW5tPJsJsI8=;
 b=r537hp9EGqPpej9ehhxcxSSa7BmI9pX3jK+QtcJ2eENMCC6mk3gFBKVU2ZnVqwigyC2ETXhKt+ycqlTYTsD4yPBNMDNecyAhh9XCGdZHOntPYIo+UqPeoL7JrdsNTfTSNOIhvWnoirYE9YxUcshZFLpdFnAzqDSOjL1xJk7H7+k=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3851.namprd10.prod.outlook.com (2603:10b6:5:1fb::17)
 by DM8PR10MB5446.namprd10.prod.outlook.com (2603:10b6:8:36::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Tue, 11 May
 2021 16:29:51 +0000
Received: from DM6PR10MB3851.namprd10.prod.outlook.com
 ([fe80::e490:f9ff:f8f3:c1e6]) by DM6PR10MB3851.namprd10.prod.outlook.com
 ([fe80::e490:f9ff:f8f3:c1e6%7]) with mapi id 15.20.4108.032; Tue, 11 May 2021
 16:29:51 +0000
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Dhaval Giani <dhaval.giani@oracle.com>,
        dmitry Vyukov <dvyukov@google.com>
From:   George Kennedy <george.kennedy@oracle.com>
Subject: 5.4.y missing upstream commit 5c4c8c95, causing: BUG: KASAN:
 use-after-free in hci_send_acl
Organization: Oracle Corporation
Message-ID: <e19ed0de-1e5c-7a1c-5f53-a32956fca1c5@oracle.com>
Date:   Tue, 11 May 2021 12:29:49 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [108.26.147.230]
X-ClientProxiedBy: SN4PR0501CA0058.namprd05.prod.outlook.com
 (2603:10b6:803:41::35) To DM6PR10MB3851.namprd10.prod.outlook.com
 (2603:10b6:5:1fb::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.246] (108.26.147.230) by SN4PR0501CA0058.namprd05.prod.outlook.com (2603:10b6:803:41::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.20 via Frontend Transport; Tue, 11 May 2021 16:29:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd0b4827-d61a-4def-cfba-08d9149a0073
X-MS-TrafficTypeDiagnostic: DM8PR10MB5446:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM8PR10MB5446038860CF269ADA1F528EE6539@DM8PR10MB5446.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:962;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BHfEaR9I3kUsCOejlZW3NR29eCA/lPBMHKkOEyU21hepxOX3IgIQzFJZ6Z+ccSmKHZoNFrc2iqmev3RW9a8yrn94AJv0Y3u/brGY6RkTsh+gw9NIqlZwU09MGNmTb9gqp6N+cmiO8U8p0nu+pBAvs+hii8yvM+VMq4dFM7xOBIusGxD4B7/VO2QMTtq8bmpUL55OsFW+xnhwS1f9jkvULi5ZpfI+sDEXBLvQkDMt5LseJM3RIQE3T7KPQKCwoXS65rNnB7GeKcqeJ0V04hQKgbzsZtt7SNQ1EItfm30YQGlXOsx/6aa6VyLsrxbIphLMEfyiptik2oObDbh49DBFvmW+qmk8cRE6uJToPBXKv3LW+NgD2BXrD0RMwntr6mxhxud6tE2zEDeryeXPApiweHY1Dlq4kNrtQpddhf4G/LgIjwXlqw8ceY4wuPMe91GoPQPSHSCKE6BXKUgtgcdlDEsmr4P43Rt6WGZwQp2BkbuPG1uHUDQb1Hx9Z8xxE0mxfIBNm4StzXzOWOC1C8vFCNZm3cTjtfjMYSJEKQGR6nkwjgxbip9j9ACxmbFqPKXvDUN0aM6g2nKDohreu0rb3yj4p40wE5X6KIFkn+q8KyiMD2fZll+B2bHUvlSx5ZcHlHa6dAE2EqkLvTlzUaXoAT1Y9VmGIf+MeIiLyBq9SRV3bYePM2LFhBCFVv1q6NKof+EQzbhqJTbQDMRibF4T7XOMTi73Pqog2Sa4nDrZ8PLuO4umgY9L6TrYi+6Jf2OGBXsvEJPapwDsR82sHMIEs08Iy6iw5vkAnRP1Kx64fAxYxmz5UAaCxuMqmGsOcQ307EhyXoMlwRxxeoVHLiGfQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3851.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(376002)(366004)(346002)(186003)(38100700002)(44832011)(16526019)(6916009)(31696002)(2906002)(36756003)(956004)(36916002)(966005)(6486002)(66946007)(2616005)(31686004)(478600001)(16576012)(54906003)(26005)(86362001)(83380400001)(8936002)(316002)(66476007)(66556008)(4326008)(5660300002)(8676002)(99710200001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SUdQUDlGaHFMQUl4L1VlMDd4NU5lVWFoWFpqc29BcWY5ZTBkOXJpWjhXWEV2?=
 =?utf-8?B?QXZtbXRMb21DMGhKZTVib0xaRFJSN1RNTklwMGlNWlN5ZUkzNGc4Yy9ValA5?=
 =?utf-8?B?MGlXOWdoN04zR2lvWkwyQlAwYlQ2aFpJeWZnckN2U2RIck5rejVFK1BrN01i?=
 =?utf-8?B?T2g5OWtGUnlmanVreVQyMWFVdENZQ3J0MGJKRkJNR2E1NmZnZXZjeDBPWTBB?=
 =?utf-8?B?dXNaTi8vK0txUXBrbzJzS3B6bWh2VHFTbUhOaHZaZTNlMzJLanlCcTNBNTJt?=
 =?utf-8?B?aHJ5cFlWYW1HS3J2eWZoZGtuTUNmVXpiNGRjLzN5UVJHU09BNzNWbFlhaVI3?=
 =?utf-8?B?OUdlTkt4WUdrc0xuS1MzQ0FDaGM2YVJWZTdyWkl6Smw2UlRic29lVTFjR0xS?=
 =?utf-8?B?Z0hTZm5mTXZVTGIzVHdMVFRYVWFMbWVIT05hZ0I2U05OTVJSZnc1N3Z6dWV2?=
 =?utf-8?B?RlJuOC9sbkl5SlA3OWhKWExNMzR4bG5SelNRTTAwWEtRSVd2VlFHdmpxVzVC?=
 =?utf-8?B?bDgzZFo3MURxbGNPVnRJZEhxbkVNSzBzelVmbERxU1NNMXVtdjJZcjhWVExq?=
 =?utf-8?B?WitZYnNjVk1IVFEyMWJrcTdKTW9KQW5IZWlrL1hIZGhrY2NRZDR4T2MrZEdE?=
 =?utf-8?B?OGVsKzQ0L2RrNzFVY1B0dmhKTDRveTVyU0Zzb3kyNnh6NGdzN2xwdE1kdnlF?=
 =?utf-8?B?VFBsWitrV0dUWG1PR1g4UWx4KzZuWHV0WWc3Z3lQTVZCMlJobmdGcVVUbWZO?=
 =?utf-8?B?SW9laWl5bTFVZVVabHVNVVdTREdOdzJWckdNL25NVm1Dd2VHYU0zVzlqZmds?=
 =?utf-8?B?RUZ2OTY3MUUrVkdWUWh2bXpPUW5oUklFZ0o2biswYXNTcGQzZ2h4bGlSS2ZJ?=
 =?utf-8?B?LzNaK0dKK3pqdmowQzZnRlRnUlBLelMzbkpOTkZMOERUYW9CQWtpYkJnTWxG?=
 =?utf-8?B?RWdZMkp2TERYdjdXcHZWN0NZcDdHblBoeGdBaURaVFpnVlRVVWN3Z0dBUEhs?=
 =?utf-8?B?d2VURDMwOXd6V1BOVTFZZWFKWXdpWkRiQnhIcHNxK0srUXdTWG1YQ29ORDJI?=
 =?utf-8?B?emZ0a2R3eGFtYjQrb1dObHoxaGl2YVUxeHRWdWVybWp6WCtvZndnK2tLY3dQ?=
 =?utf-8?B?QjBqSEV5TFl6eUk4VXR5Z1lseEJKZDdUNGsxbHhzNnFFVXM0b3k1YllQbFhh?=
 =?utf-8?B?UVM5T0lpSHVzemR6RVpKaTNhbjB4blhDRVRhRm9yV2x3dHBIOEIrK1FqRWM0?=
 =?utf-8?B?NTJYWHQ0RjErVkVGN2JhOUFyaktVdWVKUStFY2pib1cwTzh4bVNVcm9NaG51?=
 =?utf-8?B?WnhuT3NvMUxrZ0Mxa0ZPZk9rM1hpSC95dmNYTHB6eFh1TjZBUFZEamRDZWNt?=
 =?utf-8?B?RFBMVnJESDI5WFJGRHJKK0h0RkNYb1QrT1l6WGRMS0hQeG14N1ZCMjRWcS93?=
 =?utf-8?B?YVVuRzgxaWYxaCtxRTZPUHlmZ1NiK0NabVlJS3dvcllUSnFHUk1RMzFldk1X?=
 =?utf-8?B?Zmp0MDh0R1Y0aVo3dFRvY0lVVldqbjJEb3lrQ1hZc21FZDZuRDUvbTBoMWlU?=
 =?utf-8?B?YTgwVFpUZm95V3FtOUlFQ1FFZUhIOCt4QWJyL2Z3ZGZDV3BWSStmem9taXIw?=
 =?utf-8?B?UkdzcDF0MGV3bjlzNmZrbzIxdHJLdCtoY2hLMDNuQWYxRXdNQUVQSXdLQlB6?=
 =?utf-8?B?cGd0ekNVR1dzWFI4T2QramtoMVI5MkNkejNSL2JIMlhoM0NSR2JiM1FKUFN5?=
 =?utf-8?Q?aRKI/0iDnzD3M7b2akCfAMymJtFqItKFcM1bgIm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd0b4827-d61a-4def-cfba-08d9149a0073
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3851.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 16:29:51.5994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZboCqynWYpcDvB13jLZf9DjcvHp1YC4eNpFpzx5ziWlxmb++XlbrqPGVkSep1UbIqjLnoFVkHM7n9PIEUYNtn2+jWvty5inz7IskjpE2ysk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR10MB5446
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9981 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 malwarescore=0 adultscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110117
X-Proofpoint-GUID: JWba5j09uL4OmSUBt3h-58iqxePmHD5b
X-Proofpoint-ORIG-GUID: JWba5j09uL4OmSUBt3h-58iqxePmHD5b
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9981 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 suspectscore=0 clxscore=1011 bulkscore=0 adultscore=0 impostorscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110116
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

During Syzkaller reproducer testing on 5.4.y (5.4.118-rc1) the following 
crash occurred:

BUG: KASAN: use-after-free in hci_send_acl
https://syzkaller.appspot.com/bug?extid=98228e7407314d2d4ba2

We cherry-pick'd upstream commit 5c4c8c95 to 5.4.y and the crash no 
longer occurs (rebooted 10 times with the fix commit - no failures).
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5c4c8c9544099bb9043a10a5318130a943e32fc3 


The cherry-pick of upstream commit 5c4c8c95 was clean.

[  104.800617] BUG: KASAN: use-after-free in hci_send_acl+0x947/0xa30
[  104.802209] Read of size 8 at addr ffff8881023fed18 by task 
kworker/u9:2/16208
[  104.803769]
[  104.804141] CPU: 1 PID: 16208 Comm: kworker/u9:2 Not tainted 
5.4.118-rc1-syzk #1
[  104.805738] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS ?-20190213_084539-x86-ol7-builder-03.us.oracle.com-1.oci.el7 
04/01/2014
[  104.809735] Workqueue: hci0 hci_rx_work
[  104.811394] Call Trace:
[  104.825804]  dump_stack+0xd4/0x119
[  104.827555]  ? hci_send_acl+0x947/0xa30
[  104.828424]  print_address_description.constprop.6+0x20/0x220
[  104.829745]  ? hci_send_acl+0x947/0xa30
[  104.830610]  ? hci_send_acl+0x947/0xa30
[  104.831480]  __kasan_report.cold.9+0x37/0x77
[  104.832581]  ? hci_send_acl+0x947/0xa30
[  104.833420]  kasan_report+0x14/0x20
[  104.834206]  __asan_report_load8_noabort+0x14/0x20
[  104.835145]  hci_send_acl+0x947/0xa30
[  104.835867]  ? __kmalloc_reserve.isra.54+0xf0/0xf0
[  104.836813]  ? __sanitizer_cov_trace_cmp4+0x16/0x20
[  104.839089]  l2cap_send_cmd+0x726/0x960
[  104.840753]  l2cap_send_move_chan_cfm_icid+0xae/0x110
[  104.843036]  ? l2cap_send_move_chan_rsp+0x1a0/0x1a0
[  104.845255]  ? l2cap_get_chan_by_scid+0x158/0x1c0
[  104.847264]  l2cap_sig_channel+0x2f3f/0x3cf0
[  104.849131]  ? l2cap_config_rsp+0x1220/0x1220
[  104.850955]  ? probe_sched_wakeup+0x7e/0x90
[  104.852778]  ? ttwu_do_wakeup+0x35a/0x4f0
[  104.854493]  ? hci_cmd_status_evt+0x4ec0/0x4ec0
[  104.856410]  ? __kasan_check_write+0x14/0x20
[  104.858381]  ? _raw_spin_lock_irqsave+0x8e/0xf0
[  104.860429]  ? _raw_write_lock_irqsave+0xe0/0xe0
[  104.862386]  ? __kasan_check_write+0x14/0x20
[  104.864200]  ? __mutex_lock.isra.5+0x486/0xaf0
[  104.866108]  ? try_to_wake_up+0xe0/0x1640
[  104.867786]  ? ww_mutex_lock_interruptible+0xf0/0xf0
[  104.870011]  ? migrate_swap_stop+0x950/0x950
[  104.871814]  l2cap_recv_frame+0x6f7/0xc60
[  104.873603]  ? l2cap_sig_channel+0x3cf0/0x3cf0
[  104.875575]  ? __mutex_unlock_slowpath.isra.16+0x1db/0x310
[  104.877998]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
[  104.880202]  ? hci_conn_enter_active_mode+0x179/0x360
[  104.882466]  ? __ww_mutex_check_waiters+0x220/0x220
[  104.884529]  l2cap_recv_acldata+0x924/0xa50
[  104.885994]  hci_rx_work+0x824/0x970
[  104.887425]  process_one_work+0x791/0x10b0
[  104.889207]  worker_thread+0x90/0xcf0
[  104.890759]  kthread+0x332/0x3f0
[  104.892269]  ? create_worker+0x5f0/0x5f0
[  104.894132]  ? kthread_parkme+0xb0/0xb0
[  104.895774]  ret_from_fork+0x22/0x40
[  104.897513]
[  104.898224] Allocated by task 16208:
[  104.899856]  save_stack+0x21/0x90
[  104.901411]  __kasan_kmalloc.constprop.11+0xc1/0xd0
[  104.903538]  kasan_kmalloc+0x9/0x10
[  104.905124]  kmem_cache_alloc_trace+0x113/0x270
[  104.907061]  hci_chan_create+0xb8/0x3e0
[  104.908654]  l2cap_conn_add.part.40+0x26/0xd50
[  104.910623]  l2cap_connect_cfm+0x9b3/0xfc0
[  104.912532]  hci_connect_cfm+0x9c/0x140
[  104.914205]  hci_event_packet+0x5f91/0xa150
[  104.915981]  hci_rx_work+0x48a/0x970
[  104.917651]  process_one_work+0x791/0x10b0
[  104.919419]  worker_thread+0x90/0xcf0
[  104.921055]  kthread+0x332/0x3f0
[  104.922533]  ret_from_fork+0x22/0x40
[  104.924075]
[  104.924708] Freed by task 16208:
[  104.926182]  save_stack+0x21/0x90
[  104.927677]  __kasan_slab_free+0x131/0x180
[  104.929379]  kasan_slab_free+0xe/0x10
[  104.930990]  kfree+0x98/0x270
[  104.932194]  hci_chan_del+0x161/0x210
[  104.933805]  amp_destroy_logical_link+0x29/0x60
[  104.935817]  hci_event_packet+0x1f56/0xa150
[  104.937677]  hci_rx_work+0x48a/0x970
[  104.939162]  process_one_work+0x791/0x10b0
[  104.941092]  worker_thread+0x90/0xcf0
[  104.942816]  kthread+0x332/0x3f0
[  104.944241]  ret_from_fork+0x22/0x40
[  104.945839]
[  104.946554] The buggy address belongs to the object at ffff8881023fed00
[  104.946554]  which belongs to the cache kmalloc-64 of size 64
[  104.951778] The buggy address is located 24 bytes inside of
[  104.951778]  64-byte region [ffff8881023fed00, ffff8881023fed40)
[  104.956948] The buggy address belongs to the page:
[  104.959184] page:ffffea000408ff80 refcount:1 mapcount:0 
mapping:ffff888107c03600 index:0x0
[  104.962973] flags: 0x17ffffc0000200(slab)
[  104.964724] raw: 0017ffffc0000200 ffffea0004125b00 0000000a00000009 
ffff888107c03600
[  104.968106] raw: 0000000000000000 0000000080200020 00000001ffffffff 
0000000000000000
[  104.971453] page dumped because: kasan: bad access detected
[  104.973813]
[  104.974490] Memory state around the buggy address:
[  104.976750]  ffff8881023fec00: fb fb fb fb fb fb fb fb fc fc fc fc fc 
fc fc fc
[  104.979901]  ffff8881023fec80: fb fb fb fb fb fb fb fb fc fc fc fc fc 
fc fc fc
[  104.983056] >ffff8881023fed00: fb fb fb fb fb fb fb fb fc fc fc fc fc 
fc fc fc
[  104.986316]                             ^
[  104.988049]  ffff8881023fed80: fb fb fb fb fb fb fb fb fc fc fc fc fc 
fc fc fc
[  104.991889]  ffff8881023fee00: fb fb fb fb fb fb fb fb fc fc fc fc fc 
fc fc fc
[  104.995247] 
==================================================================

Thank you,
George
