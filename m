Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78043EB427
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 12:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239559AbhHMKmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 06:42:39 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:33426 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239165AbhHMKmi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 06:42:38 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17DAbbCq015699;
        Fri, 13 Aug 2021 10:42:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Ghu0uZqr5VlxtfNEJCcnBWHlKFCj7N0PGhvErvSr47Q=;
 b=DRJuppjP9Wu1wlYQOP6t6bVVgNPY2DMhQThsj1lxy9gZX/09sgmeUKcGQeKPNuOJIYqS
 rM0fHxReHNBnSKpvTarEL/qNhk/akZI3O25uAsPocOKPNRZ4L9D70ikz2C5Ksma1R7rX
 6/pLN/gSpAjD4oZsHoraZbO+mtFXRnfzTAVyIc10UwueI1FtSezEWDo2+zJXCUGS7l6H
 Ui6NbkOSpl0KHocT6kp+8X8iOkCWZr1ei44HY0aEt5DEulMUw3FOVh1jSvYBf0Pz9dfa
 ibW9EUkgPAwAueYV4CQTE92OS07muM2EQsYlz3nhysZDdVKbWlvaj0UUiu/t41eOK/zO PA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Ghu0uZqr5VlxtfNEJCcnBWHlKFCj7N0PGhvErvSr47Q=;
 b=e6hXrRSBj/6xUwVvN5h4fjbj1+fwYIBzmUV0eO5Mz2F6BHXpSE826P92YH21Nu04/yrb
 kZHaUwID4ptbGXqkQfW/QZgicmzkd8mbZ0wpXf+KuEXBr2evwwTAbU05KxxXJA1Mmf4F
 LeVOWN85Zg8VPM+FL1kbP2L5BEhbAl2sX/gzo5IfRx+MLiaDNx7OOjRhfLuBDwmqzrT5
 EpNpsRVY7nRxob7sWdSz2GZFM25WzBnuQoo0HyLejxBpWCAEhTud74Jzl0Swry4tODLB
 hhfVti+QEvFACn2DV71IlO4JEn79/R1Co+TXmb4f+2S1XF4zmpBzZRQLCWeTEiywjsuu bw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ad13van53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 10:42:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17DAYeXe166724;
        Fri, 13 Aug 2021 10:42:05 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2049.outbound.protection.outlook.com [104.47.74.49])
        by aserp3030.oracle.com with ESMTP id 3abx40ghkj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 10:42:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b5i89oVLEb4xJDSgyA+iqc7FCKidfc4Bji+qOgDFzZaTPIpUggjppni0YaeKg9Mrsl/Nr4G1TUnLG+wn05W16jCO39ZmVyQ+27AhZZG/4hRmyAscQY8y57UWJPK8VLm1b0a995nxZXx2UxyfKlkRUOt+HLDMN5BgC6fumv0yOcu15cyAxbYeG/Kyvam2iMqut8ewOHoc/k+fzOhokJ7fdqsFqqKb4oWW33ZxaKwYoEbAJNB0elfaC4JC+vlQNBxbDpH1kxW2JGDwb3ypjIv5SEuy0Cl63ZYKD48XIrSrG2dglBiu1uKzwpoDQTjp8AW4vnT1xcwbwHlCzbBCAmV1kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ghu0uZqr5VlxtfNEJCcnBWHlKFCj7N0PGhvErvSr47Q=;
 b=D9JBr2FexSkMTNX+e45Ce+T3HCCqBFd/THEzRDe3W9M22tL3ezTz3x+JEWOqSwhoNWh17KoEPHeDlpCKuZgTje9LO682P956MHO0/KIRF6ZUBi/QbsKIJ0CN5P3Tp96sVEvQ/8uft9FYz6M4Vhw0FVmfxnH7awHvhyQryNBCbQamq3D1i54KNwmufSUsQBqlAwZSEgU6cR6UlewF0EBDsj5WHbgsmT/nE05JF3p6OdodmexuxHdJEXzmoBFUsfrPjjpw/muIrRSXiJ8cEFTDCSq2MaTE7Y8pQcP0aKBvg5t17ZjfGrv+ZL90GIYVgjpiPUydF/kwZnoNnzjKdG5HAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ghu0uZqr5VlxtfNEJCcnBWHlKFCj7N0PGhvErvSr47Q=;
 b=XCyqFzTcjA8OuuQbmQyxMXapyDAcX5+IAv6KtRJ/RzGFXtCQiVL9t6SA4vjfDgSNXu98icNkUNeigXqXORTbkrWNscU4jyXT/edQTB+TPyKFZ+YjB6cDZ16BOxChK8TW3DNT3/pyRPPpPlaKmHffx7QoT9kkQcD1xjbQjPfnNP4=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
 by MN2PR10MB4141.namprd10.prod.outlook.com (2603:10b6:208:1df::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Fri, 13 Aug
 2021 10:42:01 +0000
Received: from MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a]) by MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a%5]) with mapi id 15.20.4415.019; Fri, 13 Aug 2021
 10:42:01 +0000
Subject: Re: [PATCH 4/7] btrfs: qgroup: try to flush qgroup space when we get
 -EDQUOT
To:     Qu Wenruo <wqu@suse.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
References: <cover.1628845854.git.anand.jain@oracle.com>
 <740e4978ebebfc08491db3f52264f7b5ba60ed96.1628845854.git.anand.jain@oracle.com>
 <0711671b-b08c-ee78-7271-b756dd1b579e@gmx.com>
 <b49529b9-3f1c-be5f-f95a-dadceae057ec@oracle.com>
 <6f45f8c6-03df-b2e0-cfda-85fd0b41212a@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <26649302-ce62-798d-4a9c-6a46ab1e25ec@oracle.com>
Date:   Fri, 13 Aug 2021 18:41:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <6f45f8c6-03df-b2e0-cfda-85fd0b41212a@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR01CA0112.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::16) To MN2PR10MB4128.namprd10.prod.outlook.com
 (2603:10b6:208:1d2::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.10.109] (39.109.186.25) by SG2PR01CA0112.apcprd01.prod.exchangelabs.com (2603:1096:4:40::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Fri, 13 Aug 2021 10:41:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c2be077-d35e-4443-ed18-08d95e46fbfa
X-MS-TrafficTypeDiagnostic: MN2PR10MB4141:
X-Microsoft-Antispam-PRVS: <MN2PR10MB4141583D6E3B513038F460C3E5FA9@MN2PR10MB4141.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9+OuVwSGIh+DLkO8sxjWgPkaj9haOugVvzH4D9WQiqgOnrUmQ0GbylEDzVXnVHKyTlT2ETNisUKGHc15/bObjowJCbfI3mpruuCmHWSRwMm3EB3QJvWpzvHUWtsCK2vHkzaPORAffxlgM4eYhpxsWyW7I1cTYbInU5GHxe6cEEmscLN3y1xTY/6yONLroSEOfENGNYzcczUSAU5zw4ITyM3rCqTJ7+csreBiJnDSV0K5xDLw0Ij7LLkLOTLCnmyVxnr77Rs2NtUD17sN+h/WOSZPKsWdLATZLKiaQ8q90NHXpiadTnaegUbI6YV2CUBUyCqtHG3uJ7FZ+JALas8dUNyIaY77bEaPR9+cy1YCvjVZ892UinNGXS6jdCkO6obPovpcQPNdiETPScltvy92R+P2AhTV+GfVJ4EHOrl6io94tXoMJCcJhc4QSyTOtIc7J1R3f3zofmnYvg+ugBvDbKIgLQMF3Z+3zfkRsy/NFB3HhsQvdy96hIyQ/zJhns819zsQJvxeIFuTD+AmQ+UKhycWGWVcRCM3VSFyakiJuVSCxy42NNq0NiyOaNfUW1e4Pyz22zd4cpDHr97KYbpm8SoDz9hPJZPqFRYj6HqXD5o0j5uGyws0b/4O7WAfzNg13HcFZGRZAu8AvC9NBrk8Gh1rYRZtC3RraSqHJs3AR0NeeeTbEIFe3+7iN59kWpP3MUMSE5CJafpzO00hXWFSDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(66556008)(36756003)(5660300002)(66476007)(8676002)(8936002)(38100700002)(86362001)(2906002)(508600001)(53546011)(44832011)(186003)(31696002)(26005)(6666004)(83380400001)(316002)(16576012)(4326008)(110136005)(54906003)(2616005)(31686004)(66946007)(956004)(30864003)(4001150100001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2w5VnNCWGRQYXdlenVnK3ZmS1ZBMExKaHFrYkpqSkUyOEdTU2E4Q3hrMU11?=
 =?utf-8?B?eTdDTncwSGVDSllwZkZOVkV2cHN6UDB0ZDNXL3kxcGQ5MHY4SzlJVlFnSk9S?=
 =?utf-8?B?Ni9qWjBPd3RWUUVUTWxKV1loZ2V1cjU5VHZsUDJiTVJVYkJ3ZUJsdDVWZWxt?=
 =?utf-8?B?NktGODhBaWk1OFl1bFh3YVdkZGJsQlR3S2lHbzV6OG9KTG9aZDNUNllqQ0JR?=
 =?utf-8?B?bll2ejBiVDlEd3FRRjVZcjFJdHhxUVV5TEVUMk5YdzNkWG02M29uRVB4S0w3?=
 =?utf-8?B?NW9CMmYyYnF4VUlQSUJDTHFwMUlEbEpSVjV4VHJqY2JQS3JJRHlsYUJPYzg0?=
 =?utf-8?B?Q2JUbCtKc2lhQzdURHM3eGowU21FR1V5TzJSZldOUGRiZHZ1TTdLMWhBY3dT?=
 =?utf-8?B?b3BmeU1xbUxDbDl3ZDI3OVdvVFlQVndWUk9NUDVubHhnOVVjS2Z6R01UM2Jl?=
 =?utf-8?B?MDFhNjJwb2NDZUpnV0dLdE1jeHBxWXBvT21SSnRQUjdBcnBDQ2FoK2tkaFdK?=
 =?utf-8?B?eDRUOG1tc0RVM05ZbEpCOFV5eEZPTUR0OHhqYnNWR3E0WkxEdDF2YU83TXVj?=
 =?utf-8?B?b0RwK2hjdHhqdXBXVzM1R3cveGhZOFhtNHRQTzdxZFRnWkQrZEFFR1hiUlk2?=
 =?utf-8?B?MzRLdE5YVE96czJ4OURTa0Q2K0VGTHROVVdHeW1PakNId1pHODZJelBtejJI?=
 =?utf-8?B?b2NnWGxBTDVUUGN3VHlPMGRMTUsxbENhdDhXRkZ0RVl3YnhsYURBQ0dXb080?=
 =?utf-8?B?WHVsb2pNK2w3NXE3SjhCQkNKWFh0aGRvTW4vMmtiMTRSN2w5VEZvSEt4dGZm?=
 =?utf-8?B?MFYzWVhJU1BVNFNqWkJ6eExmS3E4dGxGUTlTWXNXQit4UkZiZGdiZVJpR2N5?=
 =?utf-8?B?VEkvWmZLMklnV01XTjVFQ1FBRXhud1JHQVNaeERvbDRRaEhuWUMyTWdRbnFs?=
 =?utf-8?B?ZlFFN1Nrb0c0Y250VnNqalE1aWN3SWREVEtnS2lobWNoNnFhb1o1SHNHb1pv?=
 =?utf-8?B?RjRjUXgzdWp5dkdHNENFS3MxMmkvV2dDeVUrcGRSSjRHUG1iOU91WG5DNXl2?=
 =?utf-8?B?V0hQSXZPaEd6V3RPOUlGRlQxdWc0d0xZc1RtZ29ZdHlzWTNIWm0za0VWcEp5?=
 =?utf-8?B?TWRiRFM2QnYzL1N3MGhFeFRta1FJTG4yckRMRTJqcS9BcDc3Qk93M2c3dkw5?=
 =?utf-8?B?WVNuSHZtUGJuQWlhMDQvS0hveW1QUHp2V08vWUtnZjdTYkVhWnlPcU0yMG1p?=
 =?utf-8?B?NHB1ZlI0dHJvdXdvZVkzSVhNcmRvYWYrb0poTjdKRk1HOGtvVVFyY3JUSnhD?=
 =?utf-8?B?OFl4cWgwOVFTb0FhSHFLWVpuNy9Qc21taVE0YlVBWEhPOXdMWm94aURUQ0F4?=
 =?utf-8?B?YkFBcnFXelpVMUU5SzhUUjhidnlFazE0dTdDemFvYUJacjA0UGZ6Q1lHMjVz?=
 =?utf-8?B?YlVTS0ZxL1E1TWxXTWlHYmZHcFAvcUpjM0dIOFVIUGlyTSthNmtINW85QzAw?=
 =?utf-8?B?RVQ3Z1VSWW1GNjZQaVgybGJBenp6blVCVXFmbFMrVDZwOGtvZW9jZEhTUGVp?=
 =?utf-8?B?NTJBenByMU93TGl6VVFPWllMZ0dtK3hadUMzcXM3WmJ4dXY0eXdRQXBJSTY4?=
 =?utf-8?B?b1psbFp6U3NwaktaZ2xGa3VsRWJSN0Q5K1BKRE1hOHNMa1FtMUd2OWo1S21O?=
 =?utf-8?B?QW1oL3c2emEraEhIejJJeWVWdlVrV0xsS1dlRXZqbHV6MzBqemM0dUNBNFJM?=
 =?utf-8?Q?AeFX3hAyq8a6xcj9ByJUZIYV/N8rKglVKa3cyi+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c2be077-d35e-4443-ed18-08d95e46fbfa
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2021 10:42:01.8669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6UTyy7ZhzFRCY4KSHCwDKAeC9RXO06GVl9OOMaF3A67k6Q+J1q4YRYiCKYg7SuSi4lBtQkJ2hm3Ilop8y20IeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10074 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108130063
X-Proofpoint-ORIG-GUID: JOXc66YVUhF0UWwxp9nRBXIQQ0qLczJY
X-Proofpoint-GUID: JOXc66YVUhF0UWwxp9nRBXIQQ0qLczJY
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 13/08/2021 18:39, Qu Wenruo wrote:
> 
> 
> On 2021/8/13 下午6:30, Anand Jain wrote:
>>
>>
>> On 13/08/2021 18:26, Qu Wenruo wrote:
>>>
>>>
>>> On 2021/8/13 下午5:55, Anand Jain wrote:
>>>> From: Qu Wenruo <wqu@suse.com>
>>>>
>>>> commit c53e9653605dbf708f5be02902de51831be4b009 upstream
>>>
>>> This lacks certain upstream fixes for it:
>>>
>>> f9baa501b4fd6962257853d46ddffbc21f27e344 btrfs: fix deadlock when
>>> cloning inline extents and using qgroups
>>>
>>> 4d14c5cde5c268a2bc26addecf09489cb953ef64 btrfs: don't flush from
>>> btrfs_delayed_inode_reserve_metadata
>>>
>>> 6f23277a49e68f8a9355385c846939ad0b1261e7 btrfs: qgroup: don't commit
>>> transaction when we already hold the handle
>>>
>>> All these fixes are to ensure we don't try to flush in context where we
>>> shouldn't.
>>>
>>> Without them, it can hit various deadlock.
>>>
>>
>> Qu,
>>
>>     Thanks for taking a look. I will send it in v2.
> 
> I guess you only need to add the missing fixes?

   Yeah, maybe it's better to send it as a new set.

Thx.
Anand

> Thanks,
> Qu
>>
>> -Anand
>>
>>
>>> Thanks,
>>> Qu
>>>>
>>>> [PROBLEM]
>>>> There are known problem related to how btrfs handles qgroup reserved
>>>> space.  One of the most obvious case is the the test case btrfs/153,
>>>> which do fallocate, then write into the preallocated range.
>>>>
>>>>    btrfs/153 1s ... - output mismatch (see 
>>>> xfstests-dev/results//btrfs/153.out.bad)
>>>>        --- tests/btrfs/153.out     2019-10-22 15:18:14.068965341 +0800
>>>>        +++ xfstests-dev/results//btrfs/153.out.bad      2020-07-01 
>>>> 20:24:40.730000089 +0800
>>>>        @@ -1,2 +1,5 @@
>>>>         QA output created by 153
>>>>        +pwrite: Disk quota exceeded
>>>>        +/mnt/scratch/testfile2: Disk quota exceeded
>>>>        +/mnt/scratch/testfile2: Disk quota exceeded
>>>>         Silence is golden
>>>>        ...
>>>>        (Run 'diff -u xfstests-dev/tests/btrfs/153.out 
>>>> xfstests-dev/results//btrfs/153.out.bad'  to see the entire diff)
>>>>
>>>> [CAUSE]
>>>> Since commit c6887cd11149 ("Btrfs: don't do nocow check unless we 
>>>> have to"),
>>>> we always reserve space no matter if it's COW or not.
>>>>
>>>> Such behavior change is mostly for performance, and reverting it is not
>>>> a good idea anyway.
>>>>
>>>> For preallcoated extent, we reserve qgroup data space for it already,
>>>> and since we also reserve data space for qgroup at buffered write time,
>>>> it needs twice the space for us to write into preallocated space.
>>>>
>>>> This leads to the -EDQUOT in buffered write routine.
>>>>
>>>> And we can't follow the same solution, unlike data/meta space check,
>>>> qgroup reserved space is shared between data/metadata.
>>>> The EDQUOT can happen at the metadata reservation, so doing NODATACOW
>>>> check after qgroup reservation failure is not a solution.
>>>>
>>>> [FIX]
>>>> To solve the problem, we don't return -EDQUOT directly, but every time
>>>> we got a -EDQUOT, we try to flush qgroup space:
>>>>
>>>> - Flush all inodes of the root
>>>>    NODATACOW writes will free the qgroup reserved at 
>>>> run_dealloc_range().
>>>>    However we don't have the infrastructure to only flush NODATACOW
>>>>    inodes, here we flush all inodes anyway.
>>>>
>>>> - Wait for ordered extents
>>>>    This would convert the preallocated metadata space into per-trans
>>>>    metadata, which can be freed in later transaction commit.
>>>>
>>>> - Commit transaction
>>>>    This will free all per-trans metadata space.
>>>>
>>>> Also we don't want to trigger flush multiple times, so here we 
>>>> introduce
>>>> a per-root wait list and a new root status, to ensure only one thread
>>>> starts the flushing.
>>>>
>>>> Fixes: c6887cd11149 ("Btrfs: don't do nocow check unless we have to")
>>>> Reviewed-by: Josef Bacik <josef@toxicpanda.com>
>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>> Reviewed-by: David Sterba <dsterba@suse.com>
>>>> Signed-off-by: David Sterba <dsterba@suse.com>
>>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>>> ---
>>>>   fs/btrfs/ctree.h   |   3 ++
>>>>   fs/btrfs/disk-io.c |   1 +
>>>>   fs/btrfs/qgroup.c  | 100 
>>>> +++++++++++++++++++++++++++++++++++++++++----
>>>>   3 files changed, 96 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>>>> index 7960359dbc70..5448dc62e915 100644
>>>> --- a/fs/btrfs/ctree.h
>>>> +++ b/fs/btrfs/ctree.h
>>>> @@ -945,6 +945,8 @@ enum {
>>>>       BTRFS_ROOT_DEAD_TREE,
>>>>       /* The root has a log tree. Used only for subvolume roots. */
>>>>       BTRFS_ROOT_HAS_LOG_TREE,
>>>> +    /* Qgroup flushing is in progress */
>>>> +    BTRFS_ROOT_QGROUP_FLUSHING,
>>>>   };
>>>>
>>>>   /*
>>>> @@ -1097,6 +1099,7 @@ struct btrfs_root {
>>>>       spinlock_t qgroup_meta_rsv_lock;
>>>>       u64 qgroup_meta_rsv_pertrans;
>>>>       u64 qgroup_meta_rsv_prealloc;
>>>> +    wait_queue_head_t qgroup_flush_wait;
>>>>
>>>>       /* Number of active swapfiles */
>>>>       atomic_t nr_swapfiles;
>>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>>> index e6aa94a583e9..e3bcab38a166 100644
>>>> --- a/fs/btrfs/disk-io.c
>>>> +++ b/fs/btrfs/disk-io.c
>>>> @@ -1154,6 +1154,7 @@ static void __setup_root(struct btrfs_root 
>>>> *root, struct btrfs_fs_info *fs_info,
>>>>       mutex_init(&root->log_mutex);
>>>>       mutex_init(&root->ordered_extent_mutex);
>>>>       mutex_init(&root->delalloc_mutex);
>>>> +    init_waitqueue_head(&root->qgroup_flush_wait);
>>>>       init_waitqueue_head(&root->log_writer_wait);
>>>>       init_waitqueue_head(&root->log_commit_wait[0]);
>>>>       init_waitqueue_head(&root->log_commit_wait[1]);
>>>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>>>> index 50c45b4fcfd4..b312ac645e08 100644
>>>> --- a/fs/btrfs/qgroup.c
>>>> +++ b/fs/btrfs/qgroup.c
>>>> @@ -3479,17 +3479,58 @@ static int qgroup_unreserve_range(struct 
>>>> btrfs_inode *inode,
>>>>   }
>>>>
>>>>   /*
>>>> - * Reserve qgroup space for range [start, start + len).
>>>> + * Try to free some space for qgroup.
>>>>    *
>>>> - * This function will either reserve space from related qgroups or 
>>>> doing
>>>> - * nothing if the range is already reserved.
>>>> + * For qgroup, there are only 3 ways to free qgroup space:
>>>> + * - Flush nodatacow write
>>>> + *   Any nodatacow write will free its reserved data space at 
>>>> run_delalloc_range().
>>>> + *   In theory, we should only flush nodatacow inodes, but it's not 
>>>> yet
>>>> + *   possible, so we need to flush the whole root.
>>>>    *
>>>> - * Return 0 for successful reserve
>>>> - * Return <0 for error (including -EQUOT)
>>>> + * - Wait for ordered extents
>>>> + *   When ordered extents are finished, their reserved metadata is 
>>>> finally
>>>> + *   converted to per_trans status, which can be freed by later commit
>>>> + *   transaction.
>>>>    *
>>>> - * NOTE: this function may sleep for memory allocation.
>>>> + * - Commit transaction
>>>> + *   This would free the meta_per_trans space.
>>>> + *   In theory this shouldn't provide much space, but any more 
>>>> qgroup space
>>>> + *   is needed.
>>>>    */
>>>> -int btrfs_qgroup_reserve_data(struct btrfs_inode *inode,
>>>> +static int try_flush_qgroup(struct btrfs_root *root)
>>>> +{
>>>> +    struct btrfs_trans_handle *trans;
>>>> +    int ret;
>>>> +
>>>> +    /*
>>>> +     * We don't want to run flush again and again, so if there is a 
>>>> running
>>>> +     * one, we won't try to start a new flush, but exit directly.
>>>> +     */
>>>> +    if (test_and_set_bit(BTRFS_ROOT_QGROUP_FLUSHING, &root->state)) {
>>>> +        wait_event(root->qgroup_flush_wait,
>>>> +            !test_bit(BTRFS_ROOT_QGROUP_FLUSHING, &root->state));
>>>> +        return 0;
>>>> +    }
>>>> +
>>>> +    ret = btrfs_start_delalloc_snapshot(root);
>>>> +    if (ret < 0)
>>>> +        goto out;
>>>> +    btrfs_wait_ordered_extents(root, U64_MAX, 0, (u64)-1);
>>>> +
>>>> +    trans = btrfs_join_transaction(root);
>>>> +    if (IS_ERR(trans)) {
>>>> +        ret = PTR_ERR(trans);
>>>> +        goto out;
>>>> +    }
>>>> +
>>>> +    ret = btrfs_commit_transaction(trans);
>>>> +out:
>>>> +    clear_bit(BTRFS_ROOT_QGROUP_FLUSHING, &root->state);
>>>> +    wake_up(&root->qgroup_flush_wait);
>>>> +    return ret;
>>>> +}
>>>> +
>>>> +static int qgroup_reserve_data(struct btrfs_inode *inode,
>>>>               struct extent_changeset **reserved_ret, u64 start,
>>>>               u64 len)
>>>>   {
>>>> @@ -3542,6 +3583,34 @@ int btrfs_qgroup_reserve_data(struct 
>>>> btrfs_inode *inode,
>>>>       return ret;
>>>>   }
>>>>
>>>> +/*
>>>> + * Reserve qgroup space for range [start, start + len).
>>>> + *
>>>> + * This function will either reserve space from related qgroups or 
>>>> do nothing
>>>> + * if the range is already reserved.
>>>> + *
>>>> + * Return 0 for successful reservation
>>>> + * Return <0 for error (including -EQUOT)
>>>> + *
>>>> + * NOTE: This function may sleep for memory allocation, dirty page 
>>>> flushing and
>>>> + *     commit transaction. So caller should not hold any dirty page 
>>>> locked.
>>>> + */
>>>> +int btrfs_qgroup_reserve_data(struct btrfs_inode *inode,
>>>> +            struct extent_changeset **reserved_ret, u64 start,
>>>> +            u64 len)
>>>> +{
>>>> +    int ret;
>>>> +
>>>> +    ret = qgroup_reserve_data(inode, reserved_ret, start, len);
>>>> +    if (ret <= 0 && ret != -EDQUOT)
>>>> +        return ret;
>>>> +
>>>> +    ret = try_flush_qgroup(inode->root);
>>>> +    if (ret < 0)
>>>> +        return ret;
>>>> +    return qgroup_reserve_data(inode, reserved_ret, start, len);
>>>> +}
>>>> +
>>>>   /* Free ranges specified by @reserved, normally in error path */
>>>>   static int qgroup_free_reserved_data(struct btrfs_inode *inode,
>>>>               struct extent_changeset *reserved, u64 start, u64 len)
>>>> @@ -3712,7 +3781,7 @@ static int sub_root_meta_rsv(struct btrfs_root 
>>>> *root, int num_bytes,
>>>>       return num_bytes;
>>>>   }
>>>>
>>>> -int __btrfs_qgroup_reserve_meta(struct btrfs_root *root, int 
>>>> num_bytes,
>>>> +static int qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
>>>>                   enum btrfs_qgroup_rsv_type type, bool enforce)
>>>>   {
>>>>       struct btrfs_fs_info *fs_info = root->fs_info;
>>>> @@ -3739,6 +3808,21 @@ int __btrfs_qgroup_reserve_meta(struct 
>>>> btrfs_root *root, int num_bytes,
>>>>       return ret;
>>>>   }
>>>>
>>>> +int __btrfs_qgroup_reserve_meta(struct btrfs_root *root, int 
>>>> num_bytes,
>>>> +                enum btrfs_qgroup_rsv_type type, bool enforce)
>>>> +{
>>>> +    int ret;
>>>> +
>>>> +    ret = qgroup_reserve_meta(root, num_bytes, type, enforce);
>>>> +    if (ret <= 0 && ret != -EDQUOT)
>>>> +        return ret;
>>>> +
>>>> +    ret = try_flush_qgroup(root);
>>>> +    if (ret < 0)
>>>> +        return ret;
>>>> +    return qgroup_reserve_meta(root, num_bytes, type, enforce);
>>>> +}
>>>> +
>>>>   void btrfs_qgroup_free_meta_all_pertrans(struct btrfs_root *root)
>>>>   {
>>>>       struct btrfs_fs_info *fs_info = root->fs_info;
>>>>
>>
> 
