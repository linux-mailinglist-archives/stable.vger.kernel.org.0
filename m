Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9703FB11D
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 08:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbhH3GXb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 02:23:31 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:46382 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232091AbhH3GXa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 02:23:30 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17U5hjE2026235;
        Mon, 30 Aug 2021 06:22:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=dp3335obk6p2cbLou1AApvVc+Pju2QLAXSx4xIcQdQk=;
 b=E5B83ct2nubWdMENJWGTWfE1CeBBzFoW0/s9OkFTiOxPcL0MiPody8AAfDETQXEJ9z7I
 XFSpgoEzZA7LCudPViirgCtAYjRFQzK0foeAjcKAXmmHKwAWhat1s7f751nNIATEjAuL
 mDyRaS12sVmsKYcehLL0mgpCJVZqI/FgG2TcBcsJs7I/yMp5bGpNJaPVCnbWhjZnYoXz
 /N0dqmpdYpFmQvK8JKM6HlYt4ckkLelPPoZkQyNtvgzrJ0vzvQmN6H1hlG45cFBBMwKn
 affiQYYfgIkrjWC8KSpkgfyUBwDqD1pB+fDvCIP3QBpaFPPGl5ul+k5RU58F+dzJitO7 rg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=dp3335obk6p2cbLou1AApvVc+Pju2QLAXSx4xIcQdQk=;
 b=mmv3Ocxs3EHIFM1fX04/JJhUulvokR5XDZ+LfI2w8oHTpYsmd/Vn96x1wmO47CRQfKwm
 /K0/Es4Fl3M/CP6+N+jRfhoIXneZ8b6ixsnMUJSbYOSKP9MJwAh0fQePgEFbynDBUDBn
 DLT3cu995zXJsJM7C3HW2bU5hHRWbFEBAyjDDe0RcJotoxRMAj6a11BfBbgXuBHN8Ugf
 GuaTP2MTALJ+eATuQqwgnOLOc4sAy+K2oytMEWXuAhPZID0LRb3tGlHoF+RR3M25OYmO
 oWnu4SlPVNLXXriXfJbD973pumQj/Fvnsa2tAmXx5Tz/8iCaSUGsYeYCO8mff/zu83Dv UQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3arbymgnx8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Aug 2021 06:22:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17U6JkHU051859;
        Mon, 30 Aug 2021 06:22:31 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by userp3020.oracle.com with ESMTP id 3aqxwqtx3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Aug 2021 06:22:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MsbinGgPhyI3gznBSDHHtrBuDLsG4T3PLzKStfzkb+FVgmxcqBV8tk8Hs4OJLbqdMsa780Z6IOkXqIkjom9caUDTnrS98urXeydmRp/7tBattihvOYg6M4uj/uuI3VpzN623zX57QRu3xTB/91TEH39v8zxPBREOCw5V0RT9bz7lM5YOc0q1/HNToGCcOqYmxYZhDsUoY5Kz7NdfCgXthVVOiI3W3ae9nS8BuWXJlMNeWYmkAqe8Ym2VCFlEyb28pgEAbxdFt+TNFCjVhP3xk0s/I+cDzy+B56iTtw2I4A6Ss1dUgUCj0P5WBlQCoyR8rVQO6kWh+Y6X3HUbLUUSlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dp3335obk6p2cbLou1AApvVc+Pju2QLAXSx4xIcQdQk=;
 b=oJVdD+h/IYo+fXtDHvCrxp7RZ9mGmVEuA7moxwaY8ZmMLkVuZw1/uGBVGvUbaJTEALdW1CaVyhxyvojBma5HQ/IpsnV48qDIcb8Y4sBN3pLI13t7adYW+DvQShoNuZ1o9+GAtFIGwpNx5vxZXOc0C+uPFz75PKRnqVO6c7fiwtZC/XLBblKYKYzjH09drzIdIV6YsDhzDJQ16y2jaiquhu5onCmT316Mmvjw1SLP8c8038i6XBeikeDRbLYaBKn59uKqoqyS9XssAqB+rRNf7TGeK+6DEXUDGDPC+nuOYg2S3e3CWGSpZjBFOMtqNcaiDdACiLpy4tmpbOfasBUc9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dp3335obk6p2cbLou1AApvVc+Pju2QLAXSx4xIcQdQk=;
 b=WoTED6WGDDHrBIxRMD3WkDDvcOEcCl7dVb/p0umtl38C217XOVzZETHmKudLr88THeZHS1gTnCb1wBT0ulJHWIbiCU47oTTrvZw66Fp8wJ2psuXlFnxZuA+aBjcZddtlY2AFNJr1wFNQS9Bu9eM1imAT8iLeeEloTQS0tldbnBc=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
 by MN2PR10MB4013.namprd10.prod.outlook.com (2603:10b6:208:185::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Mon, 30 Aug
 2021 06:22:29 +0000
Received: from MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a]) by MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a%5]) with mapi id 15.20.4436.024; Mon, 30 Aug 2021
 06:22:29 +0000
Subject: Re: [PATCH stable-5.4.y] btrfs: fix race between marking inode needs
 to be logged and log syncing
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
References: <2f474ee209a89b42c2471aab71a0df038f7e8d4c.1629969541.git.anand.jain@oracle.com>
 <YSsvSQR0qHhLeI6C@kroah.com>
 <3b67845a-9d24-95d8-9dcf-845df319c0a6@oracle.com>
 <YSxy5yPpWMKClYCK@kroah.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <a0868a8e-7078-94b3-53ee-43d7739e562e@oracle.com>
Date:   Mon, 30 Aug 2021 14:22:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <YSxy5yPpWMKClYCK@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0178.apcprd06.prod.outlook.com
 (2603:1096:1:1e::32) To MN2PR10MB4128.namprd10.prod.outlook.com
 (2603:10b6:208:1d2::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.10.109] (39.109.186.25) by SG2PR06CA0178.apcprd06.prod.outlook.com (2603:1096:1:1e::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Mon, 30 Aug 2021 06:22:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 375ddbf2-4fbb-4746-4c6a-08d96b7e8b1d
X-MS-TrafficTypeDiagnostic: MN2PR10MB4013:
X-Microsoft-Antispam-PRVS: <MN2PR10MB4013DA15E8A8F2AA1851E171E5CB9@MN2PR10MB4013.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q3lBi/pv6gDj7hux21V8U0aJpUm5bEoZGGQjkb4nYCO5DDzWmneXcWxatrvxYjOXRlS7W6TZb4kHw5uD5xUewsJugfhYz/yHClWXiXS8V8hnR8Kjf/Hb87ogG3018Sw90/REnOoqNcOxXweCohyDylZPIJMlXJ7+xyHFneF5EHcrQGD8xRKf9DI02W8DXVdi+VhdlkF9TdjIXb47Wbrox1iE8Ptq2MqdbEDqoHJWvXejHRDXOOQbs5qsLILjXK9u15o323zBg8CebhSWtvK63KHU6st7MJc9/HyV7JMbyHI+4yVivOPYslEXeSunKybFrW8crwS2XjoyqJFbtvPOaTgwKDGwWBfrR96yIwfKTesHg/IU1UrDXrgMJ7aS3jRLzHBF90sarLVTB3CDTdAueTCAtRYUfKdpFraPzHKAXCrIA1Ik51Jq0m8rRfn24f3yswlgTb/P1umzOPeerLVvdgn5xe0RSfM6m9ynUTm6aECxVD5wB5PrbffrzfInPpuvjVbp9gn0egLi+/N008dbhLnK+qNJDb56NMFyzI7gAf2Q8YkDVqs6CcwttsHaE5Y1tjIaasH8rGEQNadlUPCvUpAYiUTx3N17ZT2fYiVOKVszeNZH/GaI2AMeLNx4wWimlkBAHZurZxS76XfpprhmMhDWAhIjmSKSH/cw6DLnNSAKDjYpKisIr21mvZU+nOPsYKx2Q/V0rL1nrZyghd5dXLwvsvCxLu/e96O7aORM7Ypm7pITo2MzCTCCaSts3sL4UdlsiVJMsqupBy78tj0aJZslznMUVyZQgi/7j9456VNo7Qu5cPjj106xslaMSVC0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(346002)(39860400002)(396003)(376002)(31696002)(8936002)(38100700002)(6486002)(31686004)(44832011)(86362001)(53546011)(5660300002)(36756003)(26005)(66476007)(66556008)(956004)(4744005)(66946007)(6666004)(15974865002)(2906002)(316002)(16576012)(2616005)(4326008)(6916009)(186003)(8676002)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TThLbWR6cklOYk8zUk9kWlpZeEVuWjdKYTR5dG5NbzV3SUJSSWdHdy9rRmJD?=
 =?utf-8?B?Z1kzZkVMVk1GUVNEU0dtNkNwbHVteTN2T1NHNkhzbytUT0ZVMXhhVENUZ2h4?=
 =?utf-8?B?RVBUaHVYUWFJYWpDeGdtcG9OU2dnOXRsNVp4QkRvRXhxVEtZbjZ3cHlJNmFs?=
 =?utf-8?B?S3JMd2JseFhPS0VEaUtDbU81M1FXREtkam91NVlEeHVCU3VpekptNjhlVldY?=
 =?utf-8?B?amlpU3lCOFdjSUk0eTJnekJlUUJ2YkRIT2Y1dzhOSVBYeDU5c2IrVzdYNjhZ?=
 =?utf-8?B?LzlnQnkrRFFBd1ZMT05hZ0oraXBDNDNJUjZoL212YXhyVW0yeWpob2JkQkhP?=
 =?utf-8?B?aU5FRVFIdjczOU1taTBoUGtNTThuZzZBT1ErMVVrMDZtTjhGNVVSOXpMUHVY?=
 =?utf-8?B?eUdrbFpZaHdMSmJtbEtFRVRtTUordlVlaEwvS28xcG9aUEJGMzh4RFpua3FI?=
 =?utf-8?B?dDhKUUoxU1o5T2kwMWxDdTlnSTdJNVVEeW82UTlFRnIzaUxKcHc2NHZKeWxq?=
 =?utf-8?B?K2pDQWxJUm5sekw4Q1VxbmVja2dMWGZiSzA4NXdtelRVRTZQSWp1Y0hHTnRs?=
 =?utf-8?B?K2RObjc5YWY1Mmx3SCtIUUdmTGg4UllTK0VBYkVwdXI2bXkyT1cxdVJoNGlm?=
 =?utf-8?B?dUxWVWZGUzZ1ZlJ6ckNPYjNjNFgrcFdXUVFUUDVpZFN5cnA5eG5QRlJpY0k3?=
 =?utf-8?B?a2loTFdDcS9YZFVGbXdxZGovekx3RkxWUmNlcGlCTUp5eEZIalE4T29WTE9Z?=
 =?utf-8?B?RElOUFc2QVUyM0xrZ3lHRTdmV0Y1UDhyOXVYd01RNkZ0SWFEakg5OTRnL0g2?=
 =?utf-8?B?dDRIR1B1UGxBcUpXMjhGVXpsNVN2VEpCd2dwcWFydjZCU1ZvUWlzaVpMSnNX?=
 =?utf-8?B?N2YzeDdNbzJYdkRENTROQTlHaHJxWjNmTXhsb1pYSXQycTVuQTBPUU9XcnRz?=
 =?utf-8?B?NGQ3SmcwOTNQMTljRzBwUURDUDBwQU5VNlp4TGJ1TmhhUXN4MmhGMnRET2JC?=
 =?utf-8?B?K3lFK2FaTGhLQjQvRTBjK1p0aXZ4S3J1ZU03QjladUpXK01veFNwY2N3NWRr?=
 =?utf-8?B?aEh4Q3ZpMWZJRzI3cDZOM2hadTZydDVFeHRBNjBrc29ITjNqRWd3cmZpUER0?=
 =?utf-8?B?OGRZOW9CbTA2L0Rhd3Y3MlVhWGltUXVxOXIyQ0VxRnRBU1ZrYUZKbGRnLzlh?=
 =?utf-8?B?REk2ZGc5QUR5QW9EOVNtblU2VzduTXB5THIyclFrY1U3NlZySi92aTV5Rm14?=
 =?utf-8?B?OEZ4SXorY3hDVmlWd0xjcktIemluR01QTjZMM0ZnQWRUa1diU1FSVmx3S09C?=
 =?utf-8?B?NEhzZENkc3lrWm1LVFBkNmdZNzAxaHJNODhzem5OaGxBVDJuZDFIUXNWNDh0?=
 =?utf-8?B?QXpqNkxnUVB4MFV1SUl6Y0lLTVRLU3ZLcFFHdTlqeC9JTnNlU0w1cEFTV3p2?=
 =?utf-8?B?Q0NUK0VsRmxXOVBvUVhKYXlydEpHSjNoQVBGdjlSQk43RjdqQUVyamdRc0M4?=
 =?utf-8?B?a0FCekUrTmEzWTJEaGdBNlJ2S3MwYk8xQm8wUXQyRmh6M1l2SkZWZE9uVGlF?=
 =?utf-8?B?anljTHNLc3FDN1lwbjZ0LytQTnl5ZVQ3QzBnWmVSOVFzbFRsRERnK2U1b2Yr?=
 =?utf-8?B?Y2toNkNiWjFLTWZmM1k0emd2R2MxdlhTVC84WFZpanFlcE5nNXlwV1BkZUNO?=
 =?utf-8?B?akFIVXV0WHF1aElicG1JUW96Wnhva1p6MVRzK0JpVXpxUkRLa29GSURzcnRr?=
 =?utf-8?Q?WNKRqzA2eHaBB/s4fC9oCeXMtX5zT4NQtpX78oL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 375ddbf2-4fbb-4746-4c6a-08d96b7e8b1d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2021 06:22:29.4387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uKY9Gu9CLnUbf4gJtTRPZAi+SUvBuB2Hh1yd7Zu9RwukecUs1x+4Jw21DWNgXL1W/7rLMCAjCIphahRjh/05lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4013
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10091 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108300044
X-Proofpoint-ORIG-GUID: TmcOQuJCwE8fr2ScRC4POpEuSXSLcHEZ
X-Proofpoint-GUID: TmcOQuJCwE8fr2ScRC4POpEuSXSLcHEZ
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 30/08/2021 13:55, Greg KH wrote:
> On Mon, Aug 30, 2021 at 05:28:57AM +0800, Anand Jain wrote:
>> On 29/08/2021 14:55, Greg KH wrote:
>>> On Sat, Aug 28, 2021 at 06:37:28AM +0800, Anand Jain wrote:
>>>> From: Filipe Manana <fdmanana@suse.com>
>>>>
>>>> commit bc0939fcfab0d7efb2ed12896b1af3d819954a14 upstream.
>>>
>>> 5.10 also needs this, can you provide a working backport for that as
>>> well so that no one would get a regression if they moved to a newer
>>> kernel release?  Then we could take this patch.
>>
>> Ok, will do. Why are we keen on stable-5.10.y only, while there are
>> other stable releases in between?
> 
> There are no other stable releases in between that are currently
> supported.  Please see the front page of www.kernel.org for the active
> list.

  Ah. Thx. I was confused by the stable-5.x.y branches in the repo.

-Anand
