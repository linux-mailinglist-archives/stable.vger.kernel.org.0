Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631003FAEB6
	for <lists+stable@lfdr.de>; Sun, 29 Aug 2021 23:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234631AbhH2VaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Aug 2021 17:30:06 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:41058 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231800AbhH2VaG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Aug 2021 17:30:06 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17TEOV92026248;
        Sun, 29 Aug 2021 21:29:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=TAPnvasaW/OAzBVqJEW8s27ZXEXCOUshtqk9qpgP9as=;
 b=IwowbwedOLdmHvBOOsiDN8KF678K6XMCkydPfDokDf/aazBIYS08hZC1h16V8KoJBBmg
 6DoETrLX+mWezWvWqOoRJP5U5dS3OrYtqne9CG+a4H0lM36HuwFoevAMYtVThZZd3Dxm
 LkBPzGh8nZlcOGQcpGyKdePS3ijWLM3d64T4ZI+pl47X5WrTRktmVx7OXXv2DznwazMd
 0ZIPXouNt5GGyRVRb87yd3k4LCBIRhd0o+EXK5cnW+KS3YXtgJ5M51o6b6+jzQHrMSym
 58YUUEizI3EvwUs8edKOZhKkB3aNH8+jKXKw3NBD0dC9W5jdr3kipyLFozSaKbs/Tolx Vg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=TAPnvasaW/OAzBVqJEW8s27ZXEXCOUshtqk9qpgP9as=;
 b=xk6vrrFHzNaRdirNgCNLbeVpXSbZ+hWMfENt37pJR8e2WDZYVdVl1WrFDD3+tVKrhnqW
 seL6VG67Uq+QskwBkHVJ20orLaMnRhCwcwwkfnqkZWBVnLqglOIIyD9BiJ4mMGJBmhsO
 Y/3iT+oAjLn0150uwqhk9NeZYGupTLZBeiSQOG17iBV/yAtzPXRMCbZDLME0YWWX0Rsv
 /DNpPP/GJfoy7h3iN1SY+ok/xrJiqI8qaxlORwUAl7glOa/fS4ETsibHLEJooFiGzwzl
 iSsBnT1P4fv6ezfHW8P3eoi3mxPlBescKDF9NkqsKEHrIhJuYV4yJGph0j7fLzrw9DTz gA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3arbymg79w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Aug 2021 21:29:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17TLBW2c036779;
        Sun, 29 Aug 2021 21:29:08 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by aserp3020.oracle.com with ESMTP id 3aqcy1t2ec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Aug 2021 21:29:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MoN7eBSHmMSGyQVwo7FB1hccMS9djW0HMIHqSQ4ot45SnpfOzz8px3j6qlDbmpd39v7NyGHZ/H/uFK94FwzU2Tv13or0KNuKRMANCZFFrM1OE4dxYtcwNfzJVdTRr23I3AopnILzhpQWFnLkx+rDEzMuPoHFPZJ+GHxf0Df/H8jPQKca8DpsW5bRoIdwHgBFIxX/Y7DVA0DYTdI6qXI0T5gyjPmbX1rOVgxxB0H5R/E1AGQZU5nGIgwrCI1bbXAfnYHfBqdIE6aPGidCWVNJJLp29vKegM0NZs5vrdt6UUIr0cUYk101IelYsRcGdPwO2XpQ+0YPyDTCn3sMHwHPmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TAPnvasaW/OAzBVqJEW8s27ZXEXCOUshtqk9qpgP9as=;
 b=VsZODSNFJls0kHx2bZe169Z43VBO50JsfR8ZwNntDBgL2aP3yGQBRpWtmdENG9tjmAaAAQ0bWLfKBArHDZpQMJJXTpdMGd7Rpvus7pdqCZn9Y7T7J0hu+xXjlNTwouZmEDMXMCXV8qpvfaCwzPxFmZtjGvhSGXfUf7lUEh9Je97OFttTogq12NbG492v1h59rvAQoTBl7wkd5rw84HcbgbAuB8JI6xEoWbikz80CO2fSSrSBcRhbYzlPjv38a6+mqHB6lqr3ih/+RZvcGeYHbtxMoO4sIFuqq8Er+xJYWQJw9ANSWjKiIexk8fuDOn/6yWSzpCYAcgmCnuzYdnHLuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TAPnvasaW/OAzBVqJEW8s27ZXEXCOUshtqk9qpgP9as=;
 b=pxKKiCX5cj6PwQpOd6gTDhvorO5KP6bcBjTBeTpusgBk99Xf2A5yGMCjC5ROUziu4TiH5odsJmLYUNmGYlo8PUJDTl5cjPY4UfvDNTrn4FhSTUjgcOgab3CpQjwkKpE3i60s9ARsRJfWF4aXGpe4ifWjzr+C7OcoYxLdTocBUe8=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
 by MN2PR10MB3773.namprd10.prod.outlook.com (2603:10b6:208:1b6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Sun, 29 Aug
 2021 21:29:05 +0000
Received: from MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a]) by MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a%5]) with mapi id 15.20.4436.024; Sun, 29 Aug 2021
 21:29:05 +0000
Subject: Re: [PATCH stable-5.4.y] btrfs: fix race between marking inode needs
 to be logged and log syncing
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
References: <2f474ee209a89b42c2471aab71a0df038f7e8d4c.1629969541.git.anand.jain@oracle.com>
 <YSsvSQR0qHhLeI6C@kroah.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <3b67845a-9d24-95d8-9dcf-845df319c0a6@oracle.com>
Date:   Mon, 30 Aug 2021 05:28:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <YSsvSQR0qHhLeI6C@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR0401CA0005.apcprd04.prod.outlook.com
 (2603:1096:3:1::15) To MN2PR10MB4128.namprd10.prod.outlook.com
 (2603:10b6:208:1d2::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.10.109] (39.109.186.25) by SG2PR0401CA0005.apcprd04.prod.outlook.com (2603:1096:3:1::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Sun, 29 Aug 2021 21:29:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0fcd8dc3-029d-4600-5f4d-08d96b3406f1
X-MS-TrafficTypeDiagnostic: MN2PR10MB3773:
X-Microsoft-Antispam-PRVS: <MN2PR10MB3773729BA9052084003546CCE5CA9@MN2PR10MB3773.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: feiXHsz6B6HwT/pAU2KlB8ywk4nDkv9gNWx39MMn9jmzhwGsc2HDg11O8GiQciilzoiyeb3OONUCRm8TCyuAQrx1vXCpq/MczGOuUFx1hrhI6HTx0fm1fkCN8yi3GQyA3rpu0XqApyigG1G26lTN1tBvjDEvSU6O23PF/I5HpEdaRWwv1/4hBAU5fmlg3jU/WAwNY7VcAsz2M5atOb93qeZ47rgqOIHbglqn/BcqsiCAOcy7FqhgU128rvIQ2cXhziYXmpkTOpYdGS2I/BdGyaPoiddIJhU/a9AT8nNwXrGqKcL9zrNpLt8pGnv4tEsoJ6jji0ipI5jsIE0itEPI7QffKloI0cU7a3qGQZGSEHUPt6XlNk+Za3sigg6ANOkfCfjSnPS+XFLLqMDbQHdtZhcQwRqe2vQTgtKfoBXeRvU5vjqPO8HJMqPeMyPJnrg8+Zi6zUZ2smP/Z7Np5OMRebkOMty9Q0oFzJhKRKgmZcr8rNBi1QKmo4pHcbQfRSIxfmi10+ec7lpRSSEhPbRZu5IEDCsvHbKfbSpgZ0jaTvmrLJ4zfzRkH31f87g5zlwjhDo8CEBL7ClxzFE9OZp/NhSukyAwsbKfScDjKyoG970Y1CK+mm7gWlxWY8pmXb7tcBr/W6C9v846i9qw2wAwfY5vlLERrMe88vpg+dOWTqDhkxbFbQ/yGwbrtuAiXBFV1bDX8FoXLdVNzcKi+eNq5qcVMfOOux/JUkwwXbEABgo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(346002)(39860400002)(366004)(376002)(31686004)(4326008)(6666004)(478600001)(26005)(316002)(2906002)(16576012)(8936002)(186003)(36756003)(86362001)(38100700002)(31696002)(5660300002)(66556008)(53546011)(4744005)(6486002)(6916009)(44832011)(956004)(2616005)(66476007)(66946007)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K3ZYYWRFK3hIdmlGYnk4eU1VYVd4UEVoSEFqenh2QldNNEhvWmk0RzFtOXZF?=
 =?utf-8?B?NlFMUHByWnZjTlhZV1d0dkRhQm5TZ0F1K092c1NQTTZ0K3hrQWRNRFhLYUVp?=
 =?utf-8?B?TDltbjJOa0VjcGN0YmVITWgyUmE0R2hRVXB3OXpUVmxYNWlJQzJsSDVoZHlE?=
 =?utf-8?B?QkdaVUpPSU9wQU54SkpRZkZXMVY0QW9NMEUydG8wQzUwcGNoT1pMN3o3djVT?=
 =?utf-8?B?VEdSUFhRYndCVCs3MjFZUEtvL2pQbENrUmdsVktiRWs4aHpRWXIzdWl1b21r?=
 =?utf-8?B?UTdPa0lFLzNjaDlSOXVyVmlocTFMQzBDakZsSldSMncrNVJmWjB5YlkxRlF3?=
 =?utf-8?B?b2h2dTVLTE1FbTJYMGdJeUVNdFdvWE9IZEkwejR0elo0SHlwTWhhUy9IUXB4?=
 =?utf-8?B?UWRBMEdRRHNLWHFaSjVNanAxdFpURVFvV0RGQTcwZm9ISU5tTk5PWEN1TXI0?=
 =?utf-8?B?cVk1VHZHQXQvaVBEb2hxbmhrbjBqSWt1bDdNM25taE96VTRRekJTaDFqNWFG?=
 =?utf-8?B?UUROWFRWSTk0MUR2YUUvSlNVTGc0NE9LRi8vRkhnVDVHZ2RLREVFZE0vOUxL?=
 =?utf-8?B?Z1daUW9HZksrT0lVaU9COWNSS1ViRTIybDBVdEtGT29USkJvWm0vbFU3L1B4?=
 =?utf-8?B?dGxMQVV0b0RBdG42cWxTaG1NRVFkdDNDMFBobFlyOUlNTnB0bHBjOFZMa0lT?=
 =?utf-8?B?M1NaWkxNd29ESXhqYWUwQWZiNFg5aS9TSGxzRlFrNVNGVFU2aTRZQ3JrQWF2?=
 =?utf-8?B?MTBZSUIzSUZJSVppTDA0UE11UUYvTG5tN1R1NW8zbjBGanE5aHByNS9kL3Zh?=
 =?utf-8?B?S1NVbjdJbTFIbFYya1NIK1dKVmRsL28wS0xEakNjWDFZMXFwOEcyNEFFdkc5?=
 =?utf-8?B?T1ZVNngzRHFLQkRMMHRaS2NLY0doVUZhazJla2I4YnNZS2pwSGYyK0FyTHR6?=
 =?utf-8?B?VWJaamkrcllwb1NBRWVLVHZKaTJQWmdpQnhzWFNRMGJIRW1GN3BWT0MrK0dy?=
 =?utf-8?B?MWlydnp5UjA2eGxnWHp5L1N4blJZODdpR2Z6TTZkbmpESEY4UDZLeFd3K2Vh?=
 =?utf-8?B?bkttUklVb3JEMHhvQTY4bGdxSFNWOTJoVkJtbmtwa2xlQUp3U0EwemNscDQ5?=
 =?utf-8?B?ZVVzQWxmdjhNWk10Z2tsUktocHZIM05WMzRpQWJmc3p0bjZvNXM5YzZyYk96?=
 =?utf-8?B?ZktwaEJUYStrWlVMaFNJSFNvZ09mZkNGYTJTc2locWFNNklxWVVVK3YrNjRP?=
 =?utf-8?B?cGlBYld0dnZUQUdkVkJFZXh5S3Jydk1NM0JBNzZ0emMrRWNaREpDWVUzOE1q?=
 =?utf-8?B?ZjNQMkNSWmFzVEMrTVhQOWhJRnVON0VCVWVvR1RBQVJqWitkREpQL2hSRmRx?=
 =?utf-8?B?bkdzU1lxc2xQNUdpWWc0clFGalZ3bnlmUHVrcTRhazdzdHNIQ3JQbTlGWWRW?=
 =?utf-8?B?TnR5WWEwUkM2WjdqcitPcFM1WXpKWkVOWGZkc2haM3dMN1dRV1Y5bjNxY0pI?=
 =?utf-8?B?YjhFdU5pdS8zWThuY0JNb2UxNnZURmVpakt0OXhka3l4VEhYemx6TDErd0N3?=
 =?utf-8?B?bGlic1lQbGlrVlNtWHlFSVRnVXkzczRaWnIzRGt6dDI0eUdsQXk0Wk4yS21y?=
 =?utf-8?B?Q0F5ZDVlR3dteUZQTDMrTHMrbEFZVHZIVHZhenhEOHJlQWpaZ0N2QTNrTHVh?=
 =?utf-8?B?SGYzWnB3elg4OWE3S0JrcTZ2YUJIRWFDVHBvZCtTenlvRTNmU2FuamxnNVNC?=
 =?utf-8?Q?wjmuINEW1+qgtjI7VrTZ66RDuewV9XmASc8Tk+Q?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fcd8dc3-029d-4600-5f4d-08d96b3406f1
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2021 21:29:05.2481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o3p2w+mVRct9VpbQpGqSuyRtPXMng4tiFqN1AHqALEqMjS7nHo6u9LPBoLUEOuTyV0jCtDqnRTjR7O2ul8eakw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3773
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10091 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108290137
X-Proofpoint-ORIG-GUID: erSdHsUfXtGyuFlOgh-kL1J1BggBlWt5
X-Proofpoint-GUID: erSdHsUfXtGyuFlOgh-kL1J1BggBlWt5
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29/08/2021 14:55, Greg KH wrote:
> On Sat, Aug 28, 2021 at 06:37:28AM +0800, Anand Jain wrote:
>> From: Filipe Manana <fdmanana@suse.com>
>>
>> commit bc0939fcfab0d7efb2ed12896b1af3d819954a14 upstream.
> 
> 5.10 also needs this, can you provide a working backport for that as
> well so that no one would get a regression if they moved to a newer
> kernel release?  Then we could take this patch.

Ok, will do. Why are we keen on stable-5.10.y only, while there are
other stable releases in between?

I just found that this patch applies conflict-free for the stable-5.4.y
to stable-5.8.y, you may consider integrating.

I will send a separate backport for stable-5.10.y.

Thanks, Anand

> 
> thanks,
> 
> greg k-h
> 

