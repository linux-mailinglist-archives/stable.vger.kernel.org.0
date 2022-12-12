Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97CDD64A1E9
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbiLLNrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:47:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232959AbiLLNqk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:46:40 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6260511153
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:46:35 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BC984Tc025561;
        Mon, 12 Dec 2022 13:46:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=vvf7KPWX8h6hEgMS+pMv5yUfacGwyCS6HbsUqUh36RQ=;
 b=bwG0hRfYzbBKuxW5XhYJdQgLPe0V7FR+1GCMnHtI5Xl9PfU4y5uycBfjl4Y+xMJJ4l0F
 +DEsXJPrJ17HSDTkvaryKUooaKTRApfHnqa9Ebp5n/cWy27pA0YxADtud9mbZ3/Yl69q
 T7wtU4OuNbo3NEwAqL0Fkhx2Z2FcLz6FiCXrorHWMYNvEDqk1Trq/3EdPbivSfHqLkIK
 h3a65SLvUOVgxialk305ioEHqLapr/5HfKRorQtMfZ86S/4amVBKaDWrQyhlQU9aBAkN
 0dVqXap49T0+Br+Cg7Rxi+nybvIFrf/UQpSm3JrN4Om7EAVQu7FGKvc1z0yXUWHmpLLp FA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mcgw2ardj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Dec 2022 13:46:24 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BCBwB4T009132;
        Mon, 12 Dec 2022 13:46:24 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mcgj41j17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Dec 2022 13:46:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WjV31YipdKiTBM4sXut96KPkECCz6fcbikFJE41RUwUdtf5cUpXeSeqvHM9Q1KkjdTyGhuy/Nfr8cchNK6XcO/2YGcL8V8g85ezd4kHbOATwSGCW1dwjzYCW4NTjfXSaWsX2xs/fBz1ARCv5BjzE9NmobhkdWDoUJo6BoBlneicTfkw99mK4kNjAe/5a5+HL4BHSx8L+k0OakYRS0vEZTG8C7keaaz5KC/5Sgfb4bVQxdM2fq7lOO5yRHOFzKHaf/WZ/pYDLWhYMNx2EGiKnadO2xNfiTkpV2EepHedJOsv9SKJgEYuwYH2uZAUcDGTyKHKLVi38Bd2XTyzsoouovg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vvf7KPWX8h6hEgMS+pMv5yUfacGwyCS6HbsUqUh36RQ=;
 b=WawA3iACvigJHNba5fph8vnWPY9so+1XTGKlL9FbYTd3JZUifPRQQ+WeuodcrfhZsfkcxWrMYtO2HpN72/hAe3HYkxKBX06uVZ9dNQYeAFdmNvzat+qLmjgrspHCiyfp2kI+WBaIu5ckr2fPwJUSONqXENOhSHjfsL0ts7ZbaErKG/4h4p/SCknnY13NqfPQGGZa+5xJlCaSvS+PWS8Zjdm1Hg06Px18WlUuo8F0/7oojNI2Zig6fW70fDNZpMDsvgLuUpmZgHA4IYO0UX4ujO7XrzqLH9V2MoRWKBvfCKaSg3Jqp+7nSVN39PZGYR3Bet4C9wagXIaOtUyhoQFhGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vvf7KPWX8h6hEgMS+pMv5yUfacGwyCS6HbsUqUh36RQ=;
 b=WU4xNJyjsyoaBRs9Afn3ytJzP+AQ/MlJa+feICENOv7O8VQ6PEelaYrZ5U/9WKa/Q5ZypN5cbnrfS9AokqyPI9RXZeg0BRpEfM+B6XaJHdFCPd1NGdvKuDMGhi16SX9EfM5BceY+Uctglqwrfx8HsJzMgd8EJivahFqivtIpMwA=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by CH0PR10MB4987.namprd10.prod.outlook.com (2603:10b6:610:c1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 13:46:21 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::1717:5a07:63ca:fdab]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::1717:5a07:63ca:fdab%9]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 13:46:21 +0000
Message-ID: <e2565faa-4853-2d90-4fa2-e97fe26a96f6@oracle.com>
Date:   Mon, 12 Dec 2022 19:16:11 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 5.15 122/123] io_uring: move to separate directory
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20221212130926.811961601@linuxfoundation.org>
 <20221212130932.488197218@linuxfoundation.org>
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20221212130932.488197218@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0177.apcprd04.prod.outlook.com
 (2603:1096:4:14::15) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|CH0PR10MB4987:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d7859bf-6854-4f7b-1fcd-08dadc47409d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9Iz3AHGaJb19Aih7RlmSmMJHt78SLy6CUEj0U/kzhsbXWopT2DnduTt0TJh0fT06l31ZIY3gDDYXBkEahFacEVpXhw0jgRViXfYhcirlwQEPwjxjH+4UHqTHY7G3AsfHgSl2kBlNGkcuoHul8OqExy3YeE+KM1Eco/DByCCstFN49jTCOg39k57FL19K6YNnnER6gpzRCJeoy3JOO2eq6FumW7RmzvA7CtOPtueq0gtb0053WrWaUAZscy7I46N4JLxG7PWKB/ZkDDPKw4vOap8/iZibqLYJf6d6uKN/xzbRxhtV+L+WQH8F3bWnJIyT00/SP0CghLLbOFR6STYKRsSjowkdshFq0U5k4Ngl8dpO9As52WQZrrmPUw5DnRuWyjGrJXCyoWsHTy+vKpflxtjPLJHJHu5JLrephrlqPJh+hwNTlc65qHO9zW7wYBszIMrKUBDWRFoj4Wlyi14k/B2UcYezNQHUVdwzfahXssQpS1v+b7FuXmb4+vvOAEX2k8fPK/NvI5/mBx6dmXN2fi5zqhLOSLBT4ukVB4oUvQcf8WV9SEyNVMnvpDeGLudDIWmDk0Guzk48kWJjA3Vw7H7QxE/Slu2QEE8XHUiP4bTxCPLVDvv+nje9AntZ7YQHF/6UE0IDy/HCfn9sj8pOd8EWgLQ+eKUXz63ONjG4sV5R50v64Gnx5OiX2fUSwABToEmyEekF8ALI9IRLHGVbg5TRjK/gOvx47K8dDm3F/f7mUkbgq8AvsVR2Lt0mNyGKEkEFjC7nupq93xN36EXWDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(366004)(396003)(346002)(376002)(451199015)(83380400001)(2616005)(186003)(31686004)(41300700001)(31696002)(36756003)(53546011)(6506007)(6666004)(107886003)(478600001)(26005)(2906002)(6512007)(5660300002)(38100700002)(966005)(8936002)(66476007)(66556008)(6486002)(86362001)(8676002)(66946007)(54906003)(316002)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aEg5QUVDY08xVFI2dm81dU5CWVd5cGdlWm5SR2ExV042NlhaNEIvMUFkRld2?=
 =?utf-8?B?VFZYOVp0T1hKLzUrUnVrY0pOSFA4NDdzZVM5RkdDdGdWWVEwUjZ3eTJEcDdt?=
 =?utf-8?B?ZTcraDhycGxVbjV4QXRxb0ZodVVhc0pxenp5c2U4YTlqZ2V3K2hKU3dGVnNP?=
 =?utf-8?B?V1ZhUlRaWVRVU2M4cFZhd0NYaWtWOUtKekVBdHlZRmgxOFk4cjJ6U1YydVdJ?=
 =?utf-8?B?RzY3d0x4Zy9XdElUZGE1bXdVWEhheEhmWkJHdHB1MEkxamhTQ25sZytqaDFy?=
 =?utf-8?B?VlNHR2liMjRGTmM4UEc3M0dKN0JDRFBYRDFaL2hrK1cwTXBoSDJRWWZuYk1J?=
 =?utf-8?B?SnhMWjRyM0tWOHlYNlBmYStpMDdkMVl5R3RnaWdJZUlxcCtnZzR6b0tRQVQr?=
 =?utf-8?B?UjVVSW93YitsMlFPYkhxOXlvNm80dFpWcEFWdWdwdWZ5OHhQbnBRd05UbDFn?=
 =?utf-8?B?WG9WSEVBbmwwT29yMUJvdVgzQk42NDd5ZDBGOHFpSDNXa2pqbFdReXdOSm56?=
 =?utf-8?B?aDRFbmw4b1NKYmFIUUlvbVRQeC9vQjUwQ2E4Z2J1SWh4TUJ4M24wZUlmRlhy?=
 =?utf-8?B?b1NVRGN5VVA2WHA0M0tHYm11eXYvdkRjQ3crR0gzaC9OSlloNDFaTWVnSXpO?=
 =?utf-8?B?aXphT09Oc2RMcFBtSTVmUklxWkVFTmpERm83MHZrcENaZEQ0UTNlQjVmMUpO?=
 =?utf-8?B?ajR0ek1ENzJNTTl2eVg3Z1ZUeDR5a0oxMkJ0TENtVjJZeUpDVjJmblk1SE5z?=
 =?utf-8?B?U0JLamZXTWx6YTViM1p0akFNWWVxQXoyQ2I2MjZERTdVUW5lY3F2RTB6cXVS?=
 =?utf-8?B?dFB5dGt6b1NMY29WVnJzaFdjRVV4OXJRNjJWWEFYUXUrZndBSmZhKzQ3c0cv?=
 =?utf-8?B?ajJMVVNIUjZJSTB5N3B4ZUphQ2lmWXh2WXd3Mk4wRjVhL2FzTXRVdnpHT3B6?=
 =?utf-8?B?Rmx6SzQ3YUQyTWhiYXpESFhxOUdNQkgzTW82akhIOEw3QWh0eG44N25qTFYz?=
 =?utf-8?B?d01OUWt6ODM4ME9kOVlKcDAycm9NaVJVcWVwVFdjenRzRStZcExxYUNpZS9O?=
 =?utf-8?B?RjhrdlZkZ1NXMitnNjNQUFRneS96OG9hNDczOVllRlJaU09hRkt2Sms1WWpQ?=
 =?utf-8?B?NkNPcm1RSTdQdk8vMDJ5WEJKRDA2L0ROOGFZRDlSQzRPT3RpMkJtS2E1N2c3?=
 =?utf-8?B?TkU0bnJXVkU3MFRLY29QZjV0T0l6eldZTUFjbWViVmoraldySm05VGxmd2lB?=
 =?utf-8?B?VmtadWF2cU4vU3JTcStCMlFJSURaUzZCbkNmRk5OQnhGdjMxQ0lmaW96bk5I?=
 =?utf-8?B?OXhoaFdzVFA0dWNVRHFadEhqRGsxTG54RWgvRVBCSVMrNTFJckFXN2lMYTVK?=
 =?utf-8?B?Tm9ZZ0xaUVZWdlhZSk5CU250b2hpY1laOG12VDl6Z0pTQndTclRBYlRGTC9z?=
 =?utf-8?B?WmRqQlkrNEVSdDZlMjFTY2tIbXFUWTF5angrQkRpMDlNNXBGUFFRSVFiUWgr?=
 =?utf-8?B?bjRzMVRENjNWclBnSGpCazlxRXJLVVpEam5XWm51Zmt4VmdWNjYwck9qL2dp?=
 =?utf-8?B?eE1FSWhHV3dyQ1ZES0ZYbHgxYjdXc3hlVUlWcGJEUzdmMVoyVkErL2xvU01q?=
 =?utf-8?B?bTBiQWlGMVhHM05uL013VkZmRDdYMGcvc0dsUVJYTDVZUzh6eGRPc2xxYnZQ?=
 =?utf-8?B?SnpuNEY2UjVTUHN6OUNnQ2NyNzVOU2hCTm4yZFZLWmRORHdBdGsrZjZJVHVh?=
 =?utf-8?B?SDRtMENjR3BPbHYvSUFkMWJGeU9lWm8vVTY3NHRVVVdadEZRVktSU1RyMmZw?=
 =?utf-8?B?dU9LRjRBQUgrNEZJRlNETmEwR0NRU3B5Y2pFTmhWZ3doVFdMSjZVdGdZYU1n?=
 =?utf-8?B?TlljQmtIRFZFVEhnaWpvNDF3cm1rRCtEQU0wblorbS90a0VkMHMvaEZldDRT?=
 =?utf-8?B?dXhtQjV6N01maE1rSnhhNllvRzdKTTgyS3k0MHZuNDU2dVpiNVU2Z1RqMmRR?=
 =?utf-8?B?UWlmZDhiN3hZeFlVZlNHNERSbm5va2ZBRllSbVoxVTNLbkFVRkxMOGkvTjVD?=
 =?utf-8?B?ajlIYmZwM1M3WHN5eTJpckhNMnpQclNsR0kzVStvKzNkbDNhMmN0WXVPUTBk?=
 =?utf-8?B?d2dpM28wODhuOUl0SHJ3dW13K2ZIYzBtWVR5cHJnUS81dnJZVG8xdGpxZlp4?=
 =?utf-8?Q?5MieAIx0xAV/ZkW4l6yYLro=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d7859bf-6854-4f7b-1fcd-08dadc47409d
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 13:46:21.3673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mZ8EbSpKblGwEltFT9yA57uqSHz66+lheUdalaWE9qI4685+/LhQ4e4Sd+M3Yb7CzSlZjrCuLMus6hOh5+hjuqPs2z7AnKRIszxZ4oXKBmY+YnpuEOJux4H9JEYj+GWd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4987
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-12_02,2022-12-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212120127
X-Proofpoint-ORIG-GUID: tlltth_1a16xNIDuWllaKB3c1ihud8ir
X-Proofpoint-GUID: tlltth_1a16xNIDuWllaKB3c1ihud8ir
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/12/22 6:48 pm, Greg Kroah-Hartman wrote:
> From: Jens Axboe <axboe@kernel.dk>
> 
> [ Upstream commit ed29b0b4fd835b058ddd151c49d021e28d631ee6 ]
> 
> In preparation for splitting io_uring up a bit, move it into its own
> top level directory. It didn't really belong in fs/ anyway, as it's
> not a file system only API.
> 
> This adds io_uring/ and moves the core files in there, and updates the
> MAINTAINERS file for the new location.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Stable-dep-of: 998b30c3948e ("io_uring: Fix a null-ptr-deref in io_tctx_exit_cb()")

Hi,

Just wanted to add a note: This change moved io_uring code to a 
different folder, this change is brought in to backport 998b30c3948e 
("io_uring: Fix a null-ptr-deref in io_tctx_exit_cb()") for which we 
have a backport provided by Jens here: 
https://lore.kernel.org/all/24918edb-e6eb-a093-51cf-519c7ece88a3@kernel.dk/

I am not sure which is the preferred way, but just want to inform about 
this.

Thanks,
Harshit


> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   MAINTAINERS                 | 7 +------
>   Makefile                    | 1 +
>   fs/Makefile                 | 2 --
>   io_uring/Makefile           | 6 ++++++
>   {fs => io_uring}/io-wq.c    | 0
>   {fs => io_uring}/io-wq.h    | 0
>   {fs => io_uring}/io_uring.c | 2 +-
>   kernel/sched/core.c         | 2 +-
>   8 files changed, 10 insertions(+), 10 deletions(-)
>   create mode 100644 io_uring/Makefile
>   rename {fs => io_uring}/io-wq.c (100%)
>   rename {fs => io_uring}/io-wq.h (100%)
>   rename {fs => io_uring}/io_uring.c (99%)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index edc32575828b..1cf05aee91af 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7244,9 +7244,6 @@ F:	include/linux/fs.h
>   F:	include/linux/fs_types.h
>   F:	include/uapi/linux/fs.h
>   F:	include/uapi/linux/openat2.h
> -X:	fs/io-wq.c
> -X:	fs/io-wq.h
> -X:	fs/io_uring.c
>   
>   FINTEK F75375S HARDWARE MONITOR AND FAN CONTROLLER DRIVER
>   M:	Riku Voipio <riku.voipio@iki.fi>
> @@ -9818,9 +9815,7 @@ L:	io-uring@vger.kernel.org
>   S:	Maintained
>   T:	git git://git.kernel.dk/linux-block
>   T:	git git://git.kernel.dk/liburing
> -F:	fs/io-wq.c
> -F:	fs/io-wq.h
> -F:	fs/io_uring.c
> +F:	io_uring/
>   F:	include/linux/io_uring.h
>   F:	include/uapi/linux/io_uring.h
>   F:	tools/io_uring/
> diff --git a/Makefile b/Makefile
> index 0acea54c2ffd..e6570933dcfa 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1152,6 +1152,7 @@ export MODULES_NSDEPS := $(extmod_prefix)modules.nsdeps
>   ifeq ($(KBUILD_EXTMOD),)
>   core-y			+= kernel/ certs/ mm/ fs/ ipc/ security/ crypto/
>   core-$(CONFIG_BLOCK)	+= block/
> +core-$(CONFIG_IO_URING)	+= io_uring/
>   
>   vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, \
>   		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
> diff --git a/fs/Makefile b/fs/Makefile
> index 84c5e4cdfee5..d504be65a210 100644
> --- a/fs/Makefile
> +++ b/fs/Makefile
> @@ -32,8 +32,6 @@ obj-$(CONFIG_TIMERFD)		+= timerfd.o
>   obj-$(CONFIG_EVENTFD)		+= eventfd.o
>   obj-$(CONFIG_USERFAULTFD)	+= userfaultfd.o
>   obj-$(CONFIG_AIO)               += aio.o
> -obj-$(CONFIG_IO_URING)		+= io_uring.o
> -obj-$(CONFIG_IO_WQ)		+= io-wq.o
>   obj-$(CONFIG_FS_DAX)		+= dax.o
>   obj-$(CONFIG_FS_ENCRYPTION)	+= crypto/
>   obj-$(CONFIG_FS_VERITY)		+= verity/
> diff --git a/io_uring/Makefile b/io_uring/Makefile
> new file mode 100644
> index 000000000000..3680425df947
> --- /dev/null
> +++ b/io_uring/Makefile
> @@ -0,0 +1,6 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Makefile for io_uring
> +
> +obj-$(CONFIG_IO_URING)		+= io_uring.o
> +obj-$(CONFIG_IO_WQ)		+= io-wq.o
> diff --git a/fs/io-wq.c b/io_uring/io-wq.c
> similarity index 100%
> rename from fs/io-wq.c
> rename to io_uring/io-wq.c
> diff --git a/fs/io-wq.h b/io_uring/io-wq.h
> similarity index 100%
> rename from fs/io-wq.h
> rename to io_uring/io-wq.h
> diff --git a/fs/io_uring.c b/io_uring/io_uring.c
> similarity index 99%
> rename from fs/io_uring.c
> rename to io_uring/io_uring.c
> index c2fdde6fdda3..1279b5c5c959 100644
> --- a/fs/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -85,7 +85,7 @@
>   
>   #include <uapi/linux/io_uring.h>
>   
> -#include "internal.h"
> +#include "../fs/internal.h"
>   #include "io-wq.h"
>   
>   #define IORING_MAX_ENTRIES	32768
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 85be684687b0..bb684fe1b96e 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -21,7 +21,7 @@
>   #include <asm/tlb.h>
>   
>   #include "../workqueue_internal.h"
> -#include "../../fs/io-wq.h"
> +#include "../../io_uring/io-wq.h"
>   #include "../smpboot.h"
>   
>   #include "pelt.h"
