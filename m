Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 522C93FBEF9
	for <lists+stable@lfdr.de>; Tue, 31 Aug 2021 00:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238851AbhH3W2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 18:28:49 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:50810 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238843AbhH3W2s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 18:28:48 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17ULx0kL017654;
        Mon, 30 Aug 2021 22:27:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=X9nwhfAbqp7cYnTAPuaKnobv0XOMclV/9RbVnpZeIRc=;
 b=loGvAlKfzaL1aYyBtD/IJz7gBjKY9TYuf4tbJbzl5tUrrzvH9TAXv7H60w0VPpAohbk/
 IDBAtcdgV9zKKHYSX1nQB0BdtFXVMkyv2xwmleamgcEJc+z6cHIidwWDdJh0o+4zyq9J
 0rKlLOUlpVTa5jW//xXA/AORQvELm54nFmY9Dk89HNtJBU7Lx64ozNMSpualmRMaoxxz
 g5wv5PFIPhXYsO4ZZ+03tduFH8zxwpLe2P/Up3oKlS2/LW8idBkWyIHVm1PSqZ7HYpnK
 /E5asTtJl4QQWapH1FK/G8UNzc9BWMg1bcCQooXmQYS+79wsa43Uyxs0rlELzkgedLaZ nw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=X9nwhfAbqp7cYnTAPuaKnobv0XOMclV/9RbVnpZeIRc=;
 b=NHg0W8JR+ZSjvH4Q76ZHgJbIpEIita8O+6invD5vlxPUjTkSihfZPJEhyyCVA26+bPHC
 RrfcgM091fTI03dOCKRrpO2DqzpiYP7R+rUMZwB/25GNu6EcF73SIAyNyLpfO8MXnqTV
 iGGIvGKtKX4bvhi+ZNnGusAXZqNKXAJR9hBsfIPJscSKmSh+9pDDcfH+FlYYXQzVFfPD
 NuOHg+eiEBLCEZJlcM1uXiRSuvYbtsWCTiLwyZ1ALsl1G/iQ0C4qVshu+ft0iY0+e7P9
 8EnL79Qv9YTVRsLsiwKHT6n5gRCRJLsuS6K5HI9RUaEm5ppevKRPJ1zQmmRYUOZhNxP8 Xg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3arc1a2tq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Aug 2021 22:27:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17UMGAvY079133;
        Mon, 30 Aug 2021 22:27:42 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by userp3030.oracle.com with ESMTP id 3arpf34byb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Aug 2021 22:27:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cznJloVXrYp/y8FcNIeRWPFyU8dsWS7EY5wH4OKjDRmLHAsqxdSPlCf5U3P65KCbOlP4k+g9PK26lKe/cITzGxJRilyRPr6pFVwnxtfwmhdAWa3dN0Tf8uBm1tsXtEGukIr4dGU3w6S/pNOifQ+jJRz/GrmMoQIbZBNiEcwHvh2/+DCFN1AMLoP2KOTNnD7r/GBzBJUwlqkNR1FwYmPV05b3K+TloZmJ6g+GHxT+0XQCE09nYU3NbbPKEpe3n80AUPCI08OSSJgtZTSG9qRoIKk2OKktpOFtUyB6cnLGKkXy/baVssKzIsIM+KYfx/t5+FqvSkmIdpzCfR/zxiL+aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X9nwhfAbqp7cYnTAPuaKnobv0XOMclV/9RbVnpZeIRc=;
 b=OD0wlwHGJmaw2tdqiIxJ7hgeBKnh3OmeH57bflCgIbd7asRVSvyHCuG8Qs9sc9AKpFkKCO3f7L5gb8JJE4YT1NTCu7Cyp5NSU5ek9JqXqge6aNxHAJkkFG92bhoAK9ESuJUtJVfOYJFtEZgMw/17gstZGnjnnjTUhZqjXqcexAaLg2KxtWzNQw3bfrnf9UBKcAFtK0ixv3Fbk6vjOKrWhJfkQ+bp3ORSzArDjwJDKT+hBXwoDiDqGbUg1KKH+7E95SCUTt5PZLJtAV5BGEGVdL8ILzNDZKVWRBbjISV3FEd5uM3aDT27m42j8VFQv+w6Fh8YMwbH9A7NmqHlrI1gnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X9nwhfAbqp7cYnTAPuaKnobv0XOMclV/9RbVnpZeIRc=;
 b=TtFovIkUuUVCCfsLIppSZ+Z3DfLjMqjqn1F9OiAd3cGzAUoapUePpxP/geCRJnLjWJy0N2lfiK61wKmwxYk8cqsCJIG1e/VFy7hD9gMMtq9cEtl0Z5rdBCQq8RZfgzKWs23YRnbxz1Ov6g8HsOWtJWveo+nlQMZd4dO7GtkyGIg=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
 by MN2PR10MB4287.namprd10.prod.outlook.com (2603:10b6:208:1da::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Mon, 30 Aug
 2021 22:27:40 +0000
Received: from MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a]) by MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a%5]) with mapi id 15.20.4436.024; Mon, 30 Aug 2021
 22:27:40 +0000
Subject: Re: [PATCH 4/7] btrfs: qgroup: try to flush qgroup space when we get
 -EDQUOT
From:   Anand Jain <anand.jain@oracle.com>
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
 <5fe24e8e-0f59-216d-a230-3f26c086b8a3@oracle.com>
Message-ID: <99d3d022-c5b7-5bd7-2340-f61bffee76e7@oracle.com>
Date:   Tue, 31 Aug 2021 06:27:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <5fe24e8e-0f59-216d-a230-3f26c086b8a3@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR0601CA0019.apcprd06.prod.outlook.com (2603:1096:3::29)
 To MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.10.109] (39.109.186.25) by SG2PR0601CA0019.apcprd06.prod.outlook.com (2603:1096:3::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Mon, 30 Aug 2021 22:27:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9df39404-8c9f-47ad-f404-08d96c0560bb
X-MS-TrafficTypeDiagnostic: MN2PR10MB4287:
X-Microsoft-Antispam-PRVS: <MN2PR10MB428724D6E9C8CAE69B475258E5CB9@MN2PR10MB4287.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LKwTLK6YMVj4kFoSVb42jN0Isxm5fjmT4rvc9h0WmOmZED8P9V7GMB+e8atfWLEiVs3T5rW7/jR0h9hp6pDEBsDUoswdxX0RGE+IJBBaNN57mAayVybFhS73QXENrKtSYkMSRMbWEijDf+jnmdZk/OXJMF+csA8gxDV54FDazQMn+jSvzF3nbxOYD6BdLapt3Lv678tInIp0QSuTH2lcvbGlxrJAHrj9zFKde33dAbMyyNAx4C5twcQdR0m5XaH6a+Evuz6WRgHY7sWYgR1QitmKx5/ICYI8FjPtmHG+q4IALlm3ssWUQ70H4f4DUSlfZ1OFD9lVYR7n1eJzRijfK9k9HatDnyLMDt4eqaGZypRiPeSnKZ0rfJEiDnax48uZwqMYD0bpS5Pztc7WuFQScBqtN+EI9SB8550+zVpcQQuK7DIvKox0BP5bKx/ipH98sfqh6szTrEr8Yj3wbLD/l2AOzBlbaOZa5NYaQYo5yTFMdYFE5Cb3HK90xXsilO38v8DB7WsIwznpzHWRFw0t0UTIKx4BdrgKZhh81XnzsGPbLf4y7l8cXsQUYxzTrcBhbujWf9Ut1Cvr1sZC2S5rjcVeFCOV95fPULPtiOPecPMAnMT6bVSS8Z61J00cDRe1oylvJ38W6+I7uOTxV3s63lZJVunMHyOMXXnwwNL0oDcdYJ2qUxbICfMTWpmmuVtEnOaa5wlMpPRW5eT2Huer33uPnZpbmGXRQR7w6NiSDrI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(376002)(346002)(136003)(83380400001)(6666004)(38100700002)(6486002)(86362001)(2616005)(186003)(54906003)(8936002)(16576012)(6916009)(316002)(44832011)(31686004)(26005)(53546011)(66476007)(5660300002)(66946007)(2906002)(66556008)(4326008)(956004)(36756003)(31696002)(478600001)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TUcralA3a284VXBlQzNkeXdzTHVodUIzUjhYaVYxeEVtSFh1cUNVV0s1cmp3?=
 =?utf-8?B?aHhjZVhJUTN4ckNDc1pySWNVb1ZUN3pRUHlmbmhBWWdnTzVsTmduT2pIbVdH?=
 =?utf-8?B?SlUrOXIzMitVaU5DL1hpeGVYUkRTNnp3UFFjeFd5ekVsQkFBLy9GRzAzZzcx?=
 =?utf-8?B?RzJZYnBHM1F2cFA4VktzUWJKZlJjRDl3dWZjOHU5WWx5VGxyZ0JmcnhFSXcz?=
 =?utf-8?B?K2dFMEt5cHR5V1ZLNjY4c1Q0Wmx6TjRWVnRGMFZNMG9jaWszd2wrd3UvVlFa?=
 =?utf-8?B?dG1TRVBxYTl3cGM0aVVYMEVsOHNoRUQ1eG80YzFYQkhxM01BWVRBSkVnVFpP?=
 =?utf-8?B?M1hxZDVXMDI2NTA1ZVp0RHFUZUw5SlF3bVJEdnRVTWIrVTVpaitvWisxbDN3?=
 =?utf-8?B?S3FPSmt0dzdHQWR6ZWpsVHhPazVKU08rWXFWVmFUSzZ1M0VnZ3o3eTM2MXBV?=
 =?utf-8?B?T214RkRFaGc4WjVmdUJCcHNQTTZLQndRUHhNUHl0WFo4cUtrQ2k4UTV0cGQv?=
 =?utf-8?B?ZE5OTDA2WXA2UU43VjRCTSt1bUJIRG4rVmZhdnFVWTNId3hZUXlWMHN4VWww?=
 =?utf-8?B?K1ByQUR6ZU90bVR1SkhZQ0tNV0twK0ppdnZmdHZqM1FjK1NZMWhuUWp0MG1E?=
 =?utf-8?B?aXVjS3NSMGR4bXpoSUlsSVppcVdwOGNhL0J4S3JYZC9VZndOTW9OeWlkY2Nl?=
 =?utf-8?B?US93MjhRd3FuRlRzSVlOb2FCUkpTTmVrbUkrQWNJeFBUKy8wZ3VWQ3ZOV0JW?=
 =?utf-8?B?a3p1dGpjZjZiSWdiMExYaS8rZ2UySjRSMXl6Nnd4Z1h4SW5JT2p3eG55bGMv?=
 =?utf-8?B?THFBdHBaV2ZjMVVBWUVlS0xzalBsSnpDdGlJbDJ1U3JIR3YrSWhVSzl3U3RT?=
 =?utf-8?B?MThtSWtHckxJZi9hUVJtb3U0cTMyQ3RYRmtmazBWVHVQbzR3SGpDb3NlMm5S?=
 =?utf-8?B?RlVaN1VSUnZqUWUrTjNsSCt3L0tiRmF4L3IwSUZiUEdYaElpNFFMTzRpcG81?=
 =?utf-8?B?RDBKZS9PV0FhYXVxZ01PNzFRY0V2NGxjdThNcitNbktiRTIzQzcvV0Z1WTJ2?=
 =?utf-8?B?L0p0bFlPTE9qWml1SGhJUzNSTWxjcVVDelNSMEpwMUUwV1dYZXFSeitnTTRt?=
 =?utf-8?B?SUcyengrT25LZERUVnp2bzYwR0VGM0tVN2xaVml0WUZZUzd3alllQkEycjJp?=
 =?utf-8?B?MDhuK1BZSzdqeEtKdmZCZFovK1F6OUhCVDhHWG13MTBYT0M5RHZwRVZ6U1VC?=
 =?utf-8?B?WjhkT25UMlFDaVo0YTZ3dmJKS0hrcW5GeGZORWpFL3JBTUVuVzRxMzNnZklD?=
 =?utf-8?B?OU9WdWVhQ01NWUpEY0ZFZnE0OGhIMHErejZDNmI1MlBIYXJzb0JSRDEvZUY1?=
 =?utf-8?B?VjRCcFZwbm5NR2t6MHVLL3NMWlJOWDhBckErOXJFWVdjWEM0YzZyUllyVFlk?=
 =?utf-8?B?RjFqbTBaTys0Z0huNFR4RXZGT1dyRW93M2lCZTFiM1dleDV6NDNhTE5SWk9t?=
 =?utf-8?B?RGlHUitkWDZmQmNTOUN5dWdpSGwrMmhYY2loZzZxcTNLN2g3VDlHVHNRbHpQ?=
 =?utf-8?B?RDRMY3JmLytkWFFvczV4SXF1VGM1QVJGY2ZZdzdVaFhCZ3pPQWswYzRjWDhn?=
 =?utf-8?B?ZEhXaFdTSUovRklEZUwyMEt2VUtvanNwcmw5VkZ0b2IyV1dkeDZiR3l4c29P?=
 =?utf-8?B?ZmQxMnNUUU0vT21XVHV1TFZLalJzNFlUbWJIK3I4bDBpTlM2ZVhOeDY2azlv?=
 =?utf-8?Q?WHjrtGuo9ika0INKcuVqESOQzXXe3nHqAEwvr4L?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9df39404-8c9f-47ad-f404-08d96c0560bb
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2021 22:27:40.5034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IJVnXHOVqbtAuK/5924/PhVPtcimuUNw+IZMtOijda9UstRRYPLn+9UgF9Z/u2unCICmCUe8LHrboTS8sUdVWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4287
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10092 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108300141
X-Proofpoint-GUID: q49LCMSMSbin8iBMDfyctOrQFGcUfiDO
X-Proofpoint-ORIG-GUID: q49LCMSMSbin8iBMDfyctOrQFGcUfiDO
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 13/08/2021 19:06, Anand Jain wrote:
> 
> 
> On 13/08/2021 18:56, Greg KH wrote:
>> On Fri, Aug 13, 2021 at 06:41:53PM +0800, Anand Jain wrote:
>>>
>>>
>>> On 13/08/2021 18:39, Qu Wenruo wrote:
>>>>
>>>>
>>>> On 2021/8/13 下午6:30, Anand Jain wrote:
>>>>>
>>>>>
>>>>> On 13/08/2021 18:26, Qu Wenruo wrote:
>>>>>>
>>>>>>
>>>>>> On 2021/8/13 下午5:55, Anand Jain wrote:
>>>>>>> From: Qu Wenruo <wqu@suse.com>
>>>>>>>
>>>>>>> commit c53e9653605dbf708f5be02902de51831be4b009 upstream
>>>>>>
>>>>>> This lacks certain upstream fixes for it:
>>>>>>
>>>>>> f9baa501b4fd6962257853d46ddffbc21f27e344 btrfs: fix deadlock when
>>>>>> cloning inline extents and using qgroups
>>>>>>
>>>>>> 4d14c5cde5c268a2bc26addecf09489cb953ef64 btrfs: don't flush from
>>>>>> btrfs_delayed_inode_reserve_metadata
>>>>>>
>>>>>> 6f23277a49e68f8a9355385c846939ad0b1261e7 btrfs: qgroup: don't commit
>>>>>> transaction when we already hold the handle
>>>>>>
>>>>>> All these fixes are to ensure we don't try to flush in context 
>>>>>> where we
>>>>>> shouldn't.
>>>>>>
>>>>>> Without them, it can hit various deadlock.
>>>>>>
>>>>>
>>>>> Qu,
>>>>>
>>>>>      Thanks for taking a look. I will send it in v2.
>>>>
>>>> I guess you only need to add the missing fixes?
>>>
>>>    Yeah, maybe it's better to send it as a new set.
>>
>> So should I drop the existing patches and wait for a whole new series,
>> or will you send these as an additional set?
> 
>   Greg, I am sending it as an additional set.
> 


>> And at least one of the above commits needs to go to the 5.10.y tree, I
>> did not check them all...
> 
>   I need to look into it.

We don't need 1/7 in 5.10.y it was a preparatory patch in 5.4.y
  [PATCH 1/7] btrfs: make qgroup_free_reserved_data take btrfs_inode

The rest of the patches (in patchset 1 and 2) are already in the 
stable-5.10.y.

Thx, Anand


> 
> Thanks, Anand
> 
>> thanks,
>>
>> greg k-h
>>
