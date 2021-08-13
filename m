Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB903EB45F
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 13:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239933AbhHMLHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 07:07:30 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:15000 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229597AbhHMLH3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 07:07:29 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17DB678w006036;
        Fri, 13 Aug 2021 11:06:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=BMWsYk+j8e2Hq3c9m0S6dQHZAg1uu58KUtBB2rhFD0A=;
 b=T4AWDlqZbGwwBjKnC3Ct4Qz5x44wBdfvYFlNl97Zgg86laS7uKYXBCyboyMsIP/QWX8T
 N7FnH22Ccihn0OtjKo5REfXtvGN3njvYD/exXeUPkXMQse70XGBsOOW0BRYNRUGsdo3K
 l5PbHRCN0syUdLOJJu0bkpGxUVLJ+ybkE1e9llQhvuKWlXnsuKih/L2mIL1peFAgyTos
 IU+Z42En/nWt7D15+5sTZQmQYLqhy5Rx3cK7bGQtfeFiBqd53kCzXxq2sdDWmI0lweJm
 w1YiX1UQ1kcPVN1DN3au9X+ou7gnTnVLkjJI9717KhoFJvCmabCVyMMMQpK4i11EbrwQ Bg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=BMWsYk+j8e2Hq3c9m0S6dQHZAg1uu58KUtBB2rhFD0A=;
 b=xwpcZwCdQDwtm7VFjySCy+Iwu/H60IlUEnd17PVQD57iEuKKAYmhVx66JKvVUD5GLEhc
 NSM+rWiNnPY5RZjXZqdmbDpPZ/DHkwIYlFX86i+zny59UksFvdYsahaez+Mqp9U6zRH8
 5fBit2sr+sojv/r/ponB7qOi121RoVPPCkcL6rscZA5zURcnDKuGIW4KxIHojnqClTwM
 zW0AJbUX4p70tvCRNFXFekhKBGVpRdlcbt56DMQUlZAM62ipizjsnH6mdlB2OMrEJqh3
 yO+TAVP3DUffcl13sBhSOIFgQFoXg7Molqyl6ptwH1dDIorXzfMvurrDisummhZnCPfu PA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ad2ajjkak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 11:06:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17DB6Sge080405;
        Fri, 13 Aug 2021 11:06:47 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by userp3020.oracle.com with ESMTP id 3aa3y06fnk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 11:06:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f1X8QcUiSYAsevRudIYe9flKs9qgp4m5nmY7OojzGG2BKC2TFXVFxEf+jmBvpUot2+OrlnQKFLWHVofXMEQtFzeWD+u0VPp00YM20uJHidDm7mCoxm7LeGQ37XkidICId3OdHlgVBO5E2CtEaIUCU4vIG00C3h7ODxrHFgXfRlEl2xeMYAMl7KBRBtnTFBrzaDnxHGCju/zrfaWBEdMlve0zISz9T5lU6mV752YLbUQezhkAGYFHox8Ca0IRbYDYB1KP9BFOcw8piB8+RnDQnZAmoOrkY3+bk8NUUey8C8w6F9Xq4XJOSCop/Z4F5QjHy/7IUWU8eOK74WaecKOf6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BMWsYk+j8e2Hq3c9m0S6dQHZAg1uu58KUtBB2rhFD0A=;
 b=awAgHQVOCVjjLJmbSakwneqlJJshwqY7wioNb58bQwIgRQ3fgpSArtrnKUvNSPiOeSj7k33pSX6jWkf1Z52RbYNyZ0kt9RV5iVxCgkC4ZrYREgZBu0XU/6g5jjXglPpa0A+Xo/vksnA9Id6q57foc0PYavoE+u6cbocEaJUcZ6zZouO2ciJT9vzncs1eMXqnRoaNIBIBiRZ2HPYlgEMvFiFFgCI4xgHGCIC4Y38UBS4KalaiZ2Yc241lHJk9WvQGMWrV8QlXMqiTSJKa9CbNSkm9fkvmWTz2hl3PLlQSNDdQPQJZheCLLwH/n8IIWkJGeI7YqYBIxXZddws58VffOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BMWsYk+j8e2Hq3c9m0S6dQHZAg1uu58KUtBB2rhFD0A=;
 b=a3E4q76boT+v1EoJbF5sFWoXTsD2ER0RXSB6RsjQTDa9tf9jXVzhrv8Eo8hpM0xqhRF9urpAaZyG0tO0RO7Zr51Aiu201YUZRLDq7UI/DYLdwO+AmvoUESiBq8NLhvgizRfponeuXWel3e0Tk1UJH1neFQbOwHy8zb7c+eErtLU=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
 by BL0PR10MB2804.namprd10.prod.outlook.com (2603:10b6:208:77::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Fri, 13 Aug
 2021 11:06:44 +0000
Received: from MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a]) by MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a%5]) with mapi id 15.20.4415.019; Fri, 13 Aug 2021
 11:06:44 +0000
Subject: Re: [PATCH 4/7] btrfs: qgroup: try to flush qgroup space when we get
 -EDQUOT
To:     Greg KH <greg@kroah.com>
Cc:     Qu Wenruo <wqu@suse.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
References: <cover.1628845854.git.anand.jain@oracle.com>
 <740e4978ebebfc08491db3f52264f7b5ba60ed96.1628845854.git.anand.jain@oracle.com>
 <0711671b-b08c-ee78-7271-b756dd1b579e@gmx.com>
 <b49529b9-3f1c-be5f-f95a-dadceae057ec@oracle.com>
 <6f45f8c6-03df-b2e0-cfda-85fd0b41212a@suse.com>
 <26649302-ce62-798d-4a9c-6a46ab1e25ec@oracle.com>
 <YRZP4Jh0FNHrma5/@kroah.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <5fe24e8e-0f59-216d-a230-3f26c086b8a3@oracle.com>
Date:   Fri, 13 Aug 2021 19:06:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <YRZP4Jh0FNHrma5/@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SGAP274CA0014.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::26)
 To MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.10.109] (39.109.186.25) by SGAP274CA0014.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Fri, 13 Aug 2021 11:06:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd287479-0c50-4a6e-7d91-08d95e4a6fae
X-MS-TrafficTypeDiagnostic: BL0PR10MB2804:
X-Microsoft-Antispam-PRVS: <BL0PR10MB28042A9D0B70AAE0F105EA9FE5FA9@BL0PR10MB2804.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eH42mYOu1UCWe00JgWDady+8LlRnY/yQIelDbW0w6Jh9Zpa/MICyIZeri7rLar/Em2gAwjnbkQa52K5u9jM6gtkg99k0UvmWSLex0izwBZLJ8Vv+DzhzunH3CxBq7Tkw5vFpGuTYs3nFDKVgLt4XYoTHWYaa0koqAeLyZ0156lmArBf6EKmXYXBCGJJeHM0W+wE47uJZb3lp9tHp6qa22LLJQ/9Ch9E7tejwHupaPedTP7igFdWCEtoFSkwAcXGk+yXjaafOeYX9YnlEvWWsqNJOiZs5nQj7gQNBFbafRupOjt8IcQrHfb/3140TSiLjBxkVmtUTQ3jeQvmHPWeM7jXwlozAPAzBBxA/OTqIX9Rnr748bKuyJPPxGiFldPQ7VFKp3S78zZZu21G+lp4c++m5/OqIad4/P7fa0PBvsgRlilLUS4sdzf1NUajzIPpbuaXJ4DkIB8WPMnj9uY/za+q6zm05bCXYWCUSBAz5w7s/KM24uCBrTGCaFsm+YtNZe/dLgtjqa2lpDhOETSmoTFa6zFog8vuvAIihJ7VVo7ioau6PXXkhAcWslKuVlAB8vk1Byp2s6XsibSaV9oo5+mDpZFxh9xeptiDqkNKqC5kwjuc9uYsMqtbxQG/CBtCs3Ndu8+IpwObpoRIWLNmLAg7DSs9Cfxu53KZIdye5TlMqUFXKhsimiDKRZDVy4+DWgtVuB5+SZaVRbpfKN79Qp1KwwRkCK5aYpbVodiNhXQA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(39860400002)(376002)(346002)(136003)(38100700002)(6666004)(44832011)(16576012)(6486002)(6916009)(2616005)(5660300002)(54906003)(316002)(478600001)(86362001)(8676002)(4326008)(66946007)(186003)(956004)(83380400001)(66476007)(66556008)(26005)(31686004)(2906002)(31696002)(36756003)(8936002)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z0cyczRxMzJVZW1aYWoxZzd3MGdIczU5THRqd1Q4a2VaVVpDZis4M0J6YTZv?=
 =?utf-8?B?VGFvTDJ5a0pSd0thQkxyeExoalFKUmcyV1Izc0FIM3FSNUQ2Uk9Jekd2SDU0?=
 =?utf-8?B?bksrRmRsMFFsaGJYMlNPSjRwTTY4bkVIRWJwN1ZqWVg5L2VsUUEwb2JYb0l5?=
 =?utf-8?B?ajlqUjllL0pLUFdzcDUvZ2p4OVR3MDNvV0lxWWRHZDJHQ040UHNXYVBmNjh4?=
 =?utf-8?B?akpkS2ZOVHp6WEhEcUswQzc4MmJDaEg3TUxONVl2WFVGOU83VFpFV3MrMHpT?=
 =?utf-8?B?b1dvbUt5Y0dOMFNjd1FvaEs0NU1oSlNhSnVuYUhjTGJ3NjRHL0w0dU5GR0dv?=
 =?utf-8?B?YzNCNW1FSmNZTkwyckV0VTRnOXhyaExlMGNKQkw3U0tuOGtzaUV3azB3WVZI?=
 =?utf-8?B?bkhvS0YxSzRidUhQdktxUEh6eVJIdFV2NXJiRzh1bXB2YnJ1OUZaUU52alFm?=
 =?utf-8?B?NGFuemxFWit0R08wU2xxMWJIVHhSa3lTMlVpcFl0c1ZkR0V2bm5ic1JuUko0?=
 =?utf-8?B?b2t3V2pVNHdHQmRuLytSMWFsaXhFQmx4Q0M5SVpOYm8vWDk4V1BxSnVudUxJ?=
 =?utf-8?B?YWhXNk8wUzNncythem1ZNTdoU0tpOTJhMjB5Wk50eGx3enNEMjNiQi9UZkl4?=
 =?utf-8?B?cEk0aitSaUVGUGhNM1hrTnAvcmVYYWNhRkdOeWdZYzUrRndzdDR1MHpvNTMr?=
 =?utf-8?B?M3U3MmNmcHpjenFRMkt6K20xQ0NyaHhWY3lWMHA0R3ZNTm42YXBDR2lyNVFR?=
 =?utf-8?B?cm9yblhGNGNsVWFTS2RGS1VBRTJhdExFMEUwUHBTYWtJZE5uazQ0UGdaVTlY?=
 =?utf-8?B?a3FFMTY5MFd5SzVoQW05elV2bVF4V01pWUh3NlFXNDZsV2lYWXh0N2EySklK?=
 =?utf-8?B?MExFQUJvMUNPQVExSVc0aUEvYTVSNlhpQnR2eWYvcWNGQnkwcUtDOXMzbkFY?=
 =?utf-8?B?QW5iemdYci83bzRhSmc3U3JSV3k4NGZYRk5GeDlRNWdhN1JCQ3Q4UnNnNFRu?=
 =?utf-8?B?bWR1TUNLZjZ3OXJPdzNraGViL3ZQME9PelE5ZFRZckh6UGU1anJwL3F3bjBL?=
 =?utf-8?B?cE5aZnUzc1VuRkpYcEVZQURwSURHYXl2dmwzckxtM2VCWUU2V3phazZod3V5?=
 =?utf-8?B?N25oWnF5NCtYcnZaSENHUDIrZHQzQVc0SEVvNm1JUmI5c3FOVzUrVjc3TE9u?=
 =?utf-8?B?Z1c5WTQzT2lUNmhiUmdNL3ZPaVUxY1lyY2V0YWUvS3pKcXA0NHk3VUp1VDdG?=
 =?utf-8?B?d2FLOC9UOVlFREloelllNVhmMmY1ZFV5dFNlQ2FSVm9FSUY0QlBvNDRPMGpr?=
 =?utf-8?B?T214UmswaEJpOFF1NmZlQzZHSk14V0RLQUl2ZWRwdlZFOUNaOU9ucktsVmZV?=
 =?utf-8?B?UnVFZGN0WFF6Mk9lanVHU01qaHJzVlllTC9vTWZsS1FqeWRKbS9teUt4QmxP?=
 =?utf-8?B?d0pJZ09CSjViQ2swWEw4K1BPazV4bG8wUFF5aldxdlZiNVZyYVg3c01nZjgr?=
 =?utf-8?B?VERhaHpaNE9xRFRWZVphZnVGc3Zqemd2Qkxpd0pKRWwvK2Y1ckIyRHljVW5w?=
 =?utf-8?B?ZTlZT20zRnJlMStSalJKcjNTSjZOZUhnVmV2TERBOHJVQmRUY0Vwc0c5TWoy?=
 =?utf-8?B?V1hDeXFiYzFkQUtGdEdFeCt5aVVSZDNINWRuS0Nody9kMkJPdmhzZmxHMFJY?=
 =?utf-8?B?aVRDK0hLRUREcHBBYm9tSHlIRVNQVmdMZllKa1RaVVlSU3d5c1FFWE5EZ2d3?=
 =?utf-8?Q?mYZBeH/LWdYAXmtHE68O2K4fFk2kMAGRXUkxt5m?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd287479-0c50-4a6e-7d91-08d95e4a6fae
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2021 11:06:44.4630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mY9dWq9IIj9kluV3U2BeCPyvhkPWAUmU5cEVVPEiuuFlOk4CDqJ7O3JhAkEJ3dUoawzLHCsAag+BVqPW4SfrIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2804
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10074 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130067
X-Proofpoint-ORIG-GUID: 7Hwj3D4ChhnqYB3dRcxUVP_U2DNMeZFM
X-Proofpoint-GUID: 7Hwj3D4ChhnqYB3dRcxUVP_U2DNMeZFM
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 13/08/2021 18:56, Greg KH wrote:
> On Fri, Aug 13, 2021 at 06:41:53PM +0800, Anand Jain wrote:
>>
>>
>> On 13/08/2021 18:39, Qu Wenruo wrote:
>>>
>>>
>>> On 2021/8/13 下午6:30, Anand Jain wrote:
>>>>
>>>>
>>>> On 13/08/2021 18:26, Qu Wenruo wrote:
>>>>>
>>>>>
>>>>> On 2021/8/13 下午5:55, Anand Jain wrote:
>>>>>> From: Qu Wenruo <wqu@suse.com>
>>>>>>
>>>>>> commit c53e9653605dbf708f5be02902de51831be4b009 upstream
>>>>>
>>>>> This lacks certain upstream fixes for it:
>>>>>
>>>>> f9baa501b4fd6962257853d46ddffbc21f27e344 btrfs: fix deadlock when
>>>>> cloning inline extents and using qgroups
>>>>>
>>>>> 4d14c5cde5c268a2bc26addecf09489cb953ef64 btrfs: don't flush from
>>>>> btrfs_delayed_inode_reserve_metadata
>>>>>
>>>>> 6f23277a49e68f8a9355385c846939ad0b1261e7 btrfs: qgroup: don't commit
>>>>> transaction when we already hold the handle
>>>>>
>>>>> All these fixes are to ensure we don't try to flush in context where we
>>>>> shouldn't.
>>>>>
>>>>> Without them, it can hit various deadlock.
>>>>>
>>>>
>>>> Qu,
>>>>
>>>>      Thanks for taking a look. I will send it in v2.
>>>
>>> I guess you only need to add the missing fixes?
>>
>>    Yeah, maybe it's better to send it as a new set.
> 
> So should I drop the existing patches and wait for a whole new series,
> or will you send these as an additional set?

  Greg, I am sending it as an additional set.

> And at least one of the above commits needs to go to the 5.10.y tree, I
> did not check them all...

  I need to look into it.

Thanks, Anand

> thanks,
> 
> greg k-h
> 
