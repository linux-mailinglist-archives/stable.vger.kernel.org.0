Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540D83375D8
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 15:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232709AbhCKOhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 09:37:17 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40434 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233065AbhCKOgy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 09:36:54 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12BEU8Ri146808;
        Thu, 11 Mar 2021 14:36:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=UavA2wqND9y6nzkF8zXRP5+tk1GLuopQ3xvifXYh5/0=;
 b=L0gkuHf8yV+1yAewy6PULwZlfVqoWz3tGrvwTSKmriHBcFj2XhBGCkTKO1KkCplY4Oi4
 mCrHUky9nKvAqHP+a+5InOvWCC/ZZsC5aFwYLHJ1dMvV/ELQmKXLfYs14wTicSXNrFJz
 ELVqVkPAzzHzY5EvfoORpD/z19hgbDhahQtNoIzOCe6bxb66rs4MOOwFnWyqFZOkKnd0
 8U2mslxhdIAYAOW9+jnH0IEpFFWxSwpxNu/V9yKyCnANxlA4hQbOq+E8ng3XCQeMDqfk
 VXyh1lAFPNaUrJHVHhtHJcg7KLtehH2U2J2ttFZ5WG1OxxsA9a79Q9MyiPec9+9b9P07 ww== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 37415rese8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Mar 2021 14:36:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12BETWmh122821;
        Thu, 11 Mar 2021 14:36:47 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by userp3030.oracle.com with ESMTP id 374kp11vwr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Mar 2021 14:36:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d9sUNBTrWkg5V5hWC3oKNdfRXVm8EemAp9zGAVrcBK2tBnFZRLwN19ZWKqL3+xDsBcByZYPbYf01Sp8sRFj+LXvFlkdO6UagC+zfLAjK/pQurJgy5tcNFPCoTBqY+O96vcF+M7PoD0XCU8zdtJciOc31QgxGdL5lnJEyWeHtFu8veX8PxsR9wJrn5gQmlhZDpQW6OtGqEyTUzA4MwEnczNk2k/yolxib+YKbgGm5bb5FJKcDQkRbG4g/st2lAjKzEdrhpxf2ndHwz11N7e/q5dmG57tgV9utMh7n/YJQ23MO4my4aIzGT/HETzzx5Hojgh47xiqRAfP6CWnfDtfgUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UavA2wqND9y6nzkF8zXRP5+tk1GLuopQ3xvifXYh5/0=;
 b=CcWyGvesGvB3/T+2ULnrWCq37b+A+IpQ+EOy50o/3PwUMJ/qpvKSU4WipFyvVyi6LSktml5hGgc/FVy2Br7F9gVcaDcY6G7B1S/wYDU8Bvdc3IVDlcdP+6v8MUtEtUOLXruL1u/e7vmOV4k4CRi7IfO5pLACe7ptHCy7HjDsXTGQr1FNeuOeDLL2gzmQ30q+3WMCCVmXb9SSuU2mAhwEJyvaHRK+LtJpCLJRQuQVoopFBWS6280JlJz3KXdh2snrDDLTI6oJRnJ8QG33u/9ifTLo/ezYqnzp4rYohWkaRhEZMmu38MU7V0OmyDbLY3dfUjfTy2ZKOoPkk0KpqNJKsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UavA2wqND9y6nzkF8zXRP5+tk1GLuopQ3xvifXYh5/0=;
 b=zkKWUu+T1ROPRleyqi642glkitsBl80rCCbj4yKN2DBgz3kRpjQ9/R8kktzDkp/Wmjd1CYxPAkSsEvNiivKABF4+l7ehuWqNzBcwlzFC4QQtRjNFTyes5zvROcZQ9qhCCYvK2r6NvDKXcED0d6uTL8v1ETHRyBIqaW6bgX9RbBo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MN2PR10MB3293.namprd10.prod.outlook.com (2603:10b6:208:12b::24)
 by MN2PR10MB3422.namprd10.prod.outlook.com (2603:10b6:208:122::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.29; Thu, 11 Mar
 2021 14:36:45 +0000
Received: from MN2PR10MB3293.namprd10.prod.outlook.com
 ([fe80::b87b:5cdc:87f4:c465]) by MN2PR10MB3293.namprd10.prod.outlook.com
 ([fe80::b87b:5cdc:87f4:c465%6]) with mapi id 15.20.3912.030; Thu, 11 Mar 2021
 14:36:45 +0000
Subject: Re: [PATCH v4 0/3] xen/events: bug fixes and some diagnostic aids
To:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Cc:     Stefano Stabellini <sstabellini@kernel.org>, stable@vger.kernel.org
References: <20210306161833.4552-1-jgross@suse.com>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <5c495bcf-80bc-d512-6ea3-48f3ec75bb35@oracle.com>
Date:   Thu, 11 Mar 2021 09:36:43 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
In-Reply-To: <20210306161833.4552-1-jgross@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [73.249.50.119]
X-ClientProxiedBy: BL0PR05CA0005.namprd05.prod.outlook.com
 (2603:10b6:208:91::15) To MN2PR10MB3293.namprd10.prod.outlook.com
 (2603:10b6:208:12b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.195] (73.249.50.119) by BL0PR05CA0005.namprd05.prod.outlook.com (2603:10b6:208:91::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.10 via Frontend Transport; Thu, 11 Mar 2021 14:36:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f22a9807-d45a-49df-ce4d-08d8e49b1841
X-MS-TrafficTypeDiagnostic: MN2PR10MB3422:
X-Microsoft-Antispam-PRVS: <MN2PR10MB34229F47DD8389B98DCDFB7D8A909@MN2PR10MB3422.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GWqJDO4U29aSyegE8oehYK3lsuemubYN2ABoprZIhbIXoY7GEgX20AXt7vrqQ3Vy3Q95mkMO5D1xJ/5Vb9eeVuFEdyqyrKYus1rbIgEenMNtp3+qg+JOLTEBciFhg1MRUYESjL7C/ZMleKgSR/eFs0XA4VP4rAJhwidgsSpN+vA8zOCgnoDPr8AXsKTtcoTyj3KE67GUOAPxmSfkvjwBVCxuXbd3scTDCLg272w9Fc8e4BrEYSDsKgxmd9pC/JnrWM2iQYuKVqYsDED6Smv5o4yVMPk2oPBQ3TiQ447H7XjPy5MmxcCaz0Omb8LErGVMck4BD8sh99Es2f3YBGDIENMhlaWP/B9cj1gpvn/cQkzIOZodu+kW5YPfbydGgdgv5QFyytbKL/5+QOVL1suYpPxafPBeEw5MsGl1Gm7uIigqg7K2aX+yYTseDHG4E7UP8TgAnEIWJce9lZXku/qwGyhfdnAFgUSWtmX/pKB0jecWDOOA3yDydcA0bAxnVePW3aAolzCJYPCHiTLcH4TK0wI5vNDRWSOHjL6PbjGw9fId3t1h3Lif/SKoZwDCMNjZ3LqWwYJ4uf2DASB579+wqMER89yRxyUKM+InC6XVtg0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB3293.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(136003)(346002)(376002)(5660300002)(8676002)(36756003)(16576012)(8936002)(2616005)(83380400001)(956004)(4326008)(86362001)(478600001)(4744005)(31696002)(6486002)(16526019)(316002)(44832011)(2906002)(186003)(53546011)(66946007)(66476007)(31686004)(66556008)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VHpYOUs4cGhMWDFxRTZDZjZWR1gyTlk5OVd5OGIyQ3VGQWNFTjFpK011Y0Er?=
 =?utf-8?B?K05oWWFWNnI2azZFZENSMDd5MmcwSjlGZ3Bxd3R6QXlhZzN3TTY4UG9aY20r?=
 =?utf-8?B?eWRTNE93a2dBMkc3TkY4WUJKRitvM1R5SjFPbTExamxpbzBHZVZTdTlqOE9n?=
 =?utf-8?B?L29yUFQvT0l4OEwyRUUzNS9RSlZGOEtuTHBjSFIxTXVmS1dkM1ZXc3V1Y3BR?=
 =?utf-8?B?dlEza25TZWRyZHVKNXNUaUM2TXhBU05xYzAwWEE5S2lFY0xISll2VEhnSkxO?=
 =?utf-8?B?S0RrYWlKeFNVeUJsbU52VDR2MmhBcUtPMEsxT3RFaTZJWFhFOEh3cXRtUmw1?=
 =?utf-8?B?Q2JlRjF6b0h0c25Rbk1BcjN0bWQ4U2xKUGh4azNkYzdJcG5HZVM3cUFQbjdx?=
 =?utf-8?B?UStidDRLNmZkNllqdDBVaEZkWUJITlFOTEpRckVCMXRLakNVWlBBaGdEOFh3?=
 =?utf-8?B?U25ITUx3RytoQ1lybWpzd1hVTmVQZ1pjWitpa3hVQ0puKy9Pb21tbzN6OGtz?=
 =?utf-8?B?UWdsTno0V0JCSGQweTRGV2ptZDc1V3JNNzBTWFlDUm10RUNOMk96WHRsUlNr?=
 =?utf-8?B?OFo4TXh4TjJKTkUvTWdjdnZHQmwzVXM4eHIrdkRyN3RpdE5BTzJsb05Zam5t?=
 =?utf-8?B?dVpsMmkyMzYvR0YwT2FUZ1hYWjg5Qno1b2pZSmZXamdtQWpOMCtINWgwV21K?=
 =?utf-8?B?YWx3aHJkOWpnT3dkOUUvM0JMcjEvays0VlRHRlBUZ3NTa2w4Um9hdE1tYlNo?=
 =?utf-8?B?VUZVQ1lFemFLK2UxTG1ZOEhWTURYbDlPTi9UQ3VHV3RtRmo4V2dDT2RhSFJC?=
 =?utf-8?B?Y0xZUmk2N0FTMEhKUXJ6UnptVXBJT1BTMk0yOEJpdXlGZnE0d2JpSklMWVZR?=
 =?utf-8?B?SjVnNTlJK2tGd1I1cWtWbnprdUg4a3ArMVpqRmFmcDRVck9vdHlsZ3pjYk91?=
 =?utf-8?B?cTdUS0trRzl6d3JRZkNjOTRnUmdLSi9nS0ZiRU9CcVE3WG05Q3Zzekc0WFVl?=
 =?utf-8?B?eVA0R0ZhMkFBZTFGUWhIWWpyYUVVS1h4eVRKWm9rRngyNTJjdGJrN3pWVTdR?=
 =?utf-8?B?dFBQUGo0QjYvcCtVcTBiZVAxWkFIS1lFazBMZTdpUXc1UjlSL09sckdUNTFm?=
 =?utf-8?B?aCs1Q2NZNmZrd2p5NFlUOUwzK3JtUHVFNWdSbEphN3h5QjdJWit2T1dLT0R2?=
 =?utf-8?B?eldsNUVzZUlTTG9zemFBTkFuRW5xNjVwTk1UMEd3cThEWDB1RFJIeTRnakZu?=
 =?utf-8?B?UFVIZ2tpdUpuRzhRV2hjMDREUElQdkFQQm4wemRYZW9qSlBObFEydk5hdkhV?=
 =?utf-8?B?TXN5RVY4cnNUbDNZU24veExYRTFJQ3dZRlhuRzhqRjBpRFZHQ0wrQmhTVWxJ?=
 =?utf-8?B?eVFXSTZkTW9qd1ZTbkRmM1J5VFNvTkZTdnFNL3c1a3JKeGRFaFB6bkpBTkUw?=
 =?utf-8?B?V2dsTU1ZYnNLc1QzUVJlbGh0MlY3dlZPSHFMZjJyeXM2NWY4Nm9PVXVJbkxJ?=
 =?utf-8?B?elVhMElIbXVVUG52UHRDaWJ6SlNUUnpNcFFDaVl1cVI4amRGcWszVnRVSGl2?=
 =?utf-8?B?dnJlVlUzMXI5QnF2V1U3Snh1NTMybjAvOVNNL0VKbXRmeTZ6UUxOL3Y5TDNS?=
 =?utf-8?B?Qmc4MVBhbVJla3ZuMWNWU3BMUXFmbitUOUVVVUIyQlpUNlZUTk9za0RjcGhl?=
 =?utf-8?B?aHFXaWduUHRqZ0NYY3FJUEtHcElTODN1Sng1WkdwaWJBajU2bWRYZnh2cGt2?=
 =?utf-8?Q?NZLBt+fAHBgzDx3EDmRIsWnuk5BvWc6PB8+MVCa?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f22a9807-d45a-49df-ce4d-08d8e49b1841
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB3293.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 14:36:45.3653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ss1sm+BVvAgqFaIvUmVkJTc9Wn2uSGtvkwk7zWvXSpUjUqfum3rInLGCvsyz33jHDsmZXbPXxCNoAC/eDiqf80cWghI30HAb9UAXuBYMDwY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3422
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9920 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103110079
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9920 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 adultscore=0
 phishscore=0 spamscore=0 priorityscore=1501 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103110079
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 3/6/21 11:18 AM, Juergen Gross wrote:
> Those are fixes for XSA-332.
>
> The rest of the V3 patches have been applied already. There is one
> additional fix in patch 2 which addresses network outages when a guest
> is doing reboot loops.
>
> Juergen Gross (3):
>   xen/events: reset affinity of 2-level event when tearing it down
>   xen/events: don't unmask an event channel when an eoi is pending
>   xen/events: avoid handling the same event on two cpus at the same time
>
>  drivers/xen/events/events_2l.c       |  22 +++--
>  drivers/xen/events/events_base.c     | 130 ++++++++++++++++++++-------
>  drivers/xen/events/events_fifo.c     |   7 --
>  drivers/xen/events/events_internal.h |  14 +--
>  4 files changed, 123 insertions(+), 50 deletions(-)


Applied to for-linus-5.12b

