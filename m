Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86CC02FC6FC
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 02:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730833AbhATBiD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 20:38:03 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53276 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729841AbhATBh6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jan 2021 20:37:58 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10K1YEQb119873;
        Wed, 20 Jan 2021 01:37:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=58xQqYbiA3gFY1mH16yxiFLJL72Q8WqtkNLAmrNRloo=;
 b=S5S5fqhvky1snrhXXyNlG4m1TiTyJYzvCvOrvSVgLEBALEgk4MFM2yhczOhR9rwA+JLY
 qsJRS25O6F3czCOOdL4GrRfXY4qCddPEcy+7XAOCdvAzE8TV3bv8drpTVI9iZEr2B948
 TqU9d04APPPbeCtSizlFVK3XbogTctpqpAGhvkiuEcIygTtmZd85rP94Kr+vM7Az6672
 5GKfiEOSGCfGAIDTnVSIeOpT5fR50wB+81wFeNHvDwN/YPg263RYTPNnDkpUhjCRUttn
 qCCzeHc3QBa9cJauPvx7wZJJMUV/VFcCOdKjrXhqc7nFdSEVrIKoA5Z/MwkiMIbs0ivb UQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3668qmrare-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jan 2021 01:37:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10K1UcVI006819;
        Wed, 20 Jan 2021 01:35:10 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by aserp3030.oracle.com with ESMTP id 3668qudaf7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jan 2021 01:35:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AZm9MPXEb3PJxIBH3WcGHTb8U+sqasLexU7KmYbUlBKwnvaxdU9saefMVTUfTD2gXit9Y2shkhp10w0d4WadfL5DLShgpYl1UpmaTTCC8azH0GUGHtEsWLbYJbK9RmalkF4zz0h6MTmwiAx5kKIAb8LoOf5X+lfNzu7AAtzF7iPrsqrFNjMSmsoyqgGFLUgafnfG9IwMurJScPRUxB0vy1XRzzTkmv5mBlLwUU+M1rk2Bu8M+GUjXnHp/K5vU/d3woM/DsAvsabFzKIbGARpNH2ozpnqStEiaJwMHAx900zKKS2e9oD4SYeLXbmfJxqFgGmI8+4o2NrwU6Ib/FBcuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=58xQqYbiA3gFY1mH16yxiFLJL72Q8WqtkNLAmrNRloo=;
 b=DG2y7Mti6o22rLJNRkml2EgkprLqEaUf2Duh+ndN+cdoBOS+hK3gLfzsR5c5pqxFpl0b1IVQF50zm/OcmzXxTZpZglCoUo4DRfkTFMncUAZQ7Wf9Afr1GIcYEjq/QT2HKWkEhkQ40uwIXBKpkoMTGpeeVGtV/xMsb5+O6FkkWeZOi5DX1xd1rLtAvHOFIQkT+xnynb1nX8nEUyIJcjeUsMIbnYryuNN3cxIvKz2tpUvHzSF+F8Hr2BmcvCzqqT3NZC9I1JOA5/Tjk7+M6HW2MXJ4+lKnO4+p+m3cfKg0jPzUExUmOpOQ925agVuPZvxteBf7U9MbHPr89JMBBDzqwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=58xQqYbiA3gFY1mH16yxiFLJL72Q8WqtkNLAmrNRloo=;
 b=LuM/XaQQgyhrjsi7tMoPHmVKwUovWXtlpSU0B6gC+LW8Ps1OgKpyVqOjYLRW3jOe6qjIPotUoOGKWRD8lsNW6wQq8UlmbCeuvaY0EVvic+SxK0ifoD94GUNWolEGivFHfqGllPxTV7oVyv0C+gQAblwyQUAbhtwKDIs6eJgAQeM=
Authentication-Results: lists.xenproject.org; dkim=none (message not signed)
 header.d=none;lists.xenproject.org; dmarc=none action=none
 header.from=oracle.com;
Received: from SA2PR10MB4572.namprd10.prod.outlook.com (2603:10b6:806:f9::18)
 by SN6PR10MB2637.namprd10.prod.outlook.com (2603:10b6:805:44::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Wed, 20 Jan
 2021 01:35:07 +0000
Received: from SA2PR10MB4572.namprd10.prod.outlook.com
 ([fe80::4c5b:9cf:616d:b140]) by SA2PR10MB4572.namprd10.prod.outlook.com
 ([fe80::4c5b:9cf:616d:b140%6]) with mapi id 15.20.3784.011; Wed, 20 Jan 2021
 01:35:07 +0000
Subject: Re: [PATCH AUTOSEL 5.10 26/45] x86/xen: Fix xen_hvm_smp_init() when
 vector callback not available
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     David Woodhouse <dwmw@amazon.co.uk>,
        Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org
References: <20210120012602.769683-1-sashal@kernel.org>
 <20210120012602.769683-26-sashal@kernel.org>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <86c0baa1-f8c5-2580-6ee9-efc7043c2bf5@oracle.com>
Date:   Tue, 19 Jan 2021 20:35:04 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <20210120012602.769683-26-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [138.3.200.43]
X-ClientProxiedBy: SN4PR0201CA0068.namprd02.prod.outlook.com
 (2603:10b6:803:20::30) To SA2PR10MB4572.namprd10.prod.outlook.com
 (2603:10b6:806:f9::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.74.103.107] (138.3.200.43) by SN4PR0201CA0068.namprd02.prod.outlook.com (2603:10b6:803:20::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Wed, 20 Jan 2021 01:35:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b28f780-0e22-4742-3e00-08d8bce39e90
X-MS-TrafficTypeDiagnostic: SN6PR10MB2637:
X-Microsoft-Antispam-PRVS: <SN6PR10MB2637ADA77B9A4C4D36C8D9EB8AA20@SN6PR10MB2637.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:172;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tsX4QwPYkGgJ6nlbBbMVgDuKXMd8l56H8aGPis4e5/Cp5RYWQ6nvlB/FeKm4DbEaXqh0Lnam656mdm4HQr7B3qoPFiJIHB6Xl9AR1Uk0qL25mKjtupsVm0pUZR+K1nEWBcT0epJ5tK0kIYsyiSLuE23aKaqHGw5twVNGI/Tiz2l5f2tY7qNlbdt2LtSwSE1OaEv8kU8kU2TtPYy/dkOVzDWrS2HdX8SDycGLLiMCF5PGiSTq5gchgXwBhPKOb1XpEYAJ23573DvHTD1E6FJE3vF09pShuKSMCjuB6O6MAalx6jFh7jlp8ImPm3vaQBuguq4gdHh4EcFxtFxAUfSYhh1MQH7inGqUd4hLpxSiTMJ1C4WahhKYn/Qom2KN+wLraA4FDqPri8ZxvVHtLNttaRDb3CB7yCU0LaH3oKBcQ4lPW6Wo5sIUqaSHYvRmX0MqJnsIo6v2ION5bqB/sOM5IGgNQgwM5QoG3NuHyQJ2DnHXkvWIivnroLvozNP+hQMHJKknsxgoGa8DRqClC1Jt8vhQ5swOYAHY+5XxYiMKH6uSe3kn00kx032+QUvRZ1m8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4572.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(346002)(396003)(136003)(366004)(558084003)(478600001)(5660300002)(4326008)(44832011)(8936002)(6486002)(316002)(966005)(16576012)(31696002)(186003)(54906003)(2906002)(31686004)(36756003)(2616005)(16526019)(8676002)(66556008)(956004)(86362001)(66476007)(26005)(53546011)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZXdaMzM0MUZsbk9UeTRTclFteGFiN3B6bEl3RW9sR3hXaWdCL3dxaWFybE1D?=
 =?utf-8?B?OHB5NTA3V3RDZ20xUzZweTZnbnRhQTE4djZCRnptWGQ2ckpRQTV1MGVXcW1r?=
 =?utf-8?B?MTVYaDlyb29kWW50NjdhQ0VVMC9lYkJ1WFJKYmRha2hLOEhRbS9aRUY5UnlI?=
 =?utf-8?B?anM4Q2pjTUtDNzQxYXJVd1poZjdrTGkwVnAvdUMyN3ZtdnlLQ1c5SnpWL2xq?=
 =?utf-8?B?WU9PejZ1c2REakwxcVU5U2dYU0RSUjJyeFU3VFJWNzRraVRXZU5iNnNZbFdk?=
 =?utf-8?B?cFNNYjJ2MGt5aFo1WU1oS2tEdS9yU1Nlb0JzazI2YWRTYm4rRzJla1dMS3dY?=
 =?utf-8?B?aTdtY0NSamM5dm1PVURUSW9abW9ZejJPU0hyallhN3hrdnR1T0NpZGVhQlJi?=
 =?utf-8?B?dytSdHlzaU5WcDV3YU9SOWJGU3dZWlVXZGhxWm5HTHhreU9nMHV1R1dCdEc5?=
 =?utf-8?B?ZDB2eDBBMk9rdExLZGJyaGpNSU0xZkdveTF5cWltaTJSdVc1QUpSbnhrTjU0?=
 =?utf-8?B?dUlNSUtNY1EyTHRJRVRtMjU4SzlXS1dKdUc1SFRLZ05GalFGN2IvcGZKcjM4?=
 =?utf-8?B?RDhBeXBrbThRTWNNeGgyaTBzbTFjTFpuYlN5R3NqaXlIeEUvUll1RlRWc3pz?=
 =?utf-8?B?ZjRkcmhoNjFMcGNhSnRoelVPVStCZi9XNzVtQ2RtN2VpOEpHTnNheEthOWtk?=
 =?utf-8?B?WjBsd2did1BTQnRkNWNHK1NtaVYyRnJwMVMvZWJramEzZndqdkxMVEVQZ1Nv?=
 =?utf-8?B?OElZZ3FDenpQRlRMMll0ZEgzb2IydGJvMjBnYktON2Rkdnh6YXJzbElMY3pu?=
 =?utf-8?B?NFhaSjBjR3MwN1FDemJ0WVlwWG4xbHd4Ymp6ZU84bU9mNjB2TFVjUmI4ODZ1?=
 =?utf-8?B?dDNWMzNLbGhZSlFSR29tcExyTEpVV3Y1YWRadnFMOEZhd3lpWThKTnppM1Nn?=
 =?utf-8?B?YzlieXUxMkRWSzdhNGFic3VLWkJrckhlb1FKeEZnMDlTYi9QNFRBNHpRUDRw?=
 =?utf-8?B?aDZkVG5vSjh6b2d1a3I0K3VLVXg5cDRKTVlNOWc0amxQQ1E0aGxOOVFqSmo4?=
 =?utf-8?B?dzhCTWFyem00RHZkYVI3L3ZtWmdMRHFibFRtR0lLUitUU3NtSzNsajVRRVlj?=
 =?utf-8?B?eEZmWHRwSXppN0Ntc0x4RTlSKytPWURFTFBpMFNTQS9mQ0s0Z2FzSDBuRFdW?=
 =?utf-8?B?N0lNTklLMDkxRnBNT1Eza3JCOXFremhFNG8zMXkvNStoWm1Kc3oxZlIzOEdk?=
 =?utf-8?B?TzdKa0daZE4rbFBwd3hBVW1uM0pqZmxWMGtVRVNPMWUxUXd0MHluekNGM3lZ?=
 =?utf-8?B?bUVVQnRxWC9OWUlpME44NTdiQmtvRWRxL243dDdjYVEzMHdZZWJZTDZZSVJD?=
 =?utf-8?B?dDE2U1dpN25lNHZ1WHF2STFxVi8vOVZ6Nnc0M1d4SFJweFBnYUNNNG5pbmQ0?=
 =?utf-8?Q?JmyU1d2G?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b28f780-0e22-4742-3e00-08d8bce39e90
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4572.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2021 01:35:07.8628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bqMPrp6Q1qGbTYrg8ZcKTYkwQn708LXTFeYaB2Tu1sQSSsZYEVeZLP3hDJuA/0+nD+tafzTwCvESZZiiCjJbxhxVuC9aTAp32gTvt1dWWeU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2637
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9869 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101200005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9869 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 adultscore=0 impostorscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1031 bulkscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101200006
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 1/19/21 8:25 PM, Sasha Levin wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
>
> [ Upstream commit 3d7746bea92530e8695258a3cf3ddec7a135edd6 ]


Sasha, you will also want https://lore.kernel.org/lkml/20210115191123.27572-1-rdunlap@infradead.org/, it is sitting in Xen staging tree.


-boris



