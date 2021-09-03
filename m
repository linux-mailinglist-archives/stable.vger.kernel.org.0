Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBD74002D3
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 18:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349793AbhICQD4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 12:03:56 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:19640 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349786AbhICQDz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 12:03:55 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 183DOZb5015848;
        Fri, 3 Sep 2021 16:02:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=7FtrqmUcFZVEZ+k/NMvQsodHtQ0QIKQJKnBfcAYkEwU=;
 b=cM5zy4q7Lhw6A1Gfbin2E3csIxEfWzE3U16ickVmaIaB6uHbH9HsBxmZq9Iqu0hAStr5
 JTq5+CXtr5sZyPfe6gBgr0JB4ihGwfH8P2T1BlqqqGl3zPjuYSqg5XoriTlbCxaTEe2t
 rtagBPDAudqMugyRcoJHn7Hnm3eVdKzKm5Dk/cIQ1haxAvQ3ev4sP1PLbL6mYBkVUqAY
 ZUn0epx/bVSzDIQJO7LcGV5avThb+heatcrEWR1X43Lu9jMBw6LcHeFqgeYSF93wcZC8
 iAHpL9SjH61yqIGr4Cqhjf/RhP2Sc23rBl1iVO6O2qxXlnxGX3YPFcQenCiYr9oJzJMV +w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=7FtrqmUcFZVEZ+k/NMvQsodHtQ0QIKQJKnBfcAYkEwU=;
 b=k4Jdngotn11QTRioGxOPgbTvFgkGhIbkrspS6ZoJ2+NX52mIPY6Y3RWq/qD8LfDrNTfW
 7kuJh7AkWL76nRdqzmy5p5w+JKHWvdpkONqlkKHrHooqYoAUjBVHSci0i3WyCMsTxmPb
 6NiXm4c3aIa6e8Sjp6MRriW6nHHZq2K1EonENp7ZbvwZkejTkwexW0qTTW0SXVZC6Z/T
 S7otnl0QkH+lomrf4fqvaJX5qRO6YzdmbtMiktSclUme0XpktZB73uB9QSXalR1j09al
 jK3e+wTUmRd0ej3lbJ1SrSvB0w1yDAYrr4EAZLEQ/7vEnZk/ZSOqmU0D6oI0sfWDqMpw RQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aufj79cmv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Sep 2021 16:02:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 183FuBO4085140;
        Fri, 3 Sep 2021 16:02:50 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by aserp3030.oracle.com with ESMTP id 3atdyypbjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Sep 2021 16:02:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aqclf/17s1Hsdp6KgQ7WrAaTDU8Dqy/CkJRALDrri5LJ6DKzKVD3Fg4Ps5+LycGqyXcqJSDMbcf+UmxXaRVEiIw2azhdU0coyfrFErAhTE2Qr2KplhViwQ0lm7pKG2MsLolCgME3l9Nd3VH2VEnbgHXUDn4WDxakc5fT5dbyy1dGzTMNJ9VVPODVxlmnzihLUSTt0Dueo6poi3ojLlV++034A4ElMLuo8ef/Am+nGJNhwVhtIgcHdcUIL36COQd1mzz5dR0WC0E0Sj0aOiZthoX/SpY447V775k7+RVS5KBzGXNaAd4YTC7uU2Ug3kvVcrtldl6FMtYijSinQhkBog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7FtrqmUcFZVEZ+k/NMvQsodHtQ0QIKQJKnBfcAYkEwU=;
 b=ZNvntv+fR9Uv2/0jDzjnxyWacqGO7Xpc6WfFRsejJycduRbpG8f4/w8Qu3sjydSCeTxHaBLyj799w2rCLr5RgIvuORaf3G+gKCRuo8Zmf2MkmnTd9rfR/qV3oV6AYTp+2dQ9LdDFf+yCunMrSkKk0eO42fmGt8WBvNPTW58dRdzqwfTeVz2u7AfPtlcXVnuPCz4pqss/f9Vez4ujjZ82R/t1MsUY/JPj49Fx5C0mCPTeoxu4R7GNoVNokrlqZ0mIoKB+QX43QWcM4uGIhSkRPz9yAcLbD55w5aoSJnrr5oEyr+UjfCa5rHHznCtRoUBw4Y0HdK3CfbLdnvHkvKMREQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7FtrqmUcFZVEZ+k/NMvQsodHtQ0QIKQJKnBfcAYkEwU=;
 b=QHg9l1E9NfZi8w7vzDVWgNtdzdoukysV6wX7s94Tkjr7aVMu0iUFMH6ne0TjknBMUnaf6hKTtotIUlLDAKup2NNPV1cvLMDt6Jw3kSFCrTIkgn30Dpagz3TjuFwpcQaUlsJ1tXscA2c1q3WPDcMm1MTV3BYn2gXAzTkrB0K+FyE=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3158.namprd10.prod.outlook.com (2603:10b6:a03:15d::23)
 by BY5PR10MB4113.namprd10.prod.outlook.com (2603:10b6:a03:20d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.24; Fri, 3 Sep
 2021 16:02:48 +0000
Received: from BYAPR10MB3158.namprd10.prod.outlook.com
 ([fe80::a116:b514:b312:c2d7]) by BYAPR10MB3158.namprd10.prod.outlook.com
 ([fe80::a116:b514:b312:c2d7%7]) with mapi id 15.20.4478.022; Fri, 3 Sep 2021
 16:02:48 +0000
Subject: Re: [PATCH 4.9 12/16] net/rds: dma_map_sg is entitled to merge
 entries
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20210901122248.920548099@linuxfoundation.org>
 <20210901122249.305212889@linuxfoundation.org> <20210903065035.GA11871@amd>
From:   Gerd Rausch <gerd.rausch@oracle.com>
Message-ID: <a5edcbfd-7492-964d-688f-4f2a3f45e4ca@oracle.com>
Date:   Fri, 3 Sep 2021 09:02:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <20210903065035.GA11871@amd>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0216.namprd04.prod.outlook.com
 (2603:10b6:806:127::11) To BYAPR10MB3158.namprd10.prod.outlook.com
 (2603:10b6:a03:15d::23)
MIME-Version: 1.0
Received: from ib0.gerd.us.oracle.com (2405:ba00:8000:1021::1046) by SN7PR04CA0216.namprd04.prod.outlook.com (2603:10b6:806:127::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17 via Frontend Transport; Fri, 3 Sep 2021 16:02:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c785133-e3b3-4376-8add-08d96ef44615
X-MS-TrafficTypeDiagnostic: BY5PR10MB4113:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4113ACBF9C6223818276015E87CF9@BY5PR10MB4113.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mv9WtRGKJhPYxdj4oj86QfWaMw5GgmOKgb0PX/cMjZPcNF8OEmNrwgndH0BBkl1siKOCqDf/FJzNmSCCi4ljzbOzCBpGrW+a11kdoGyKIcESsMxun6iXBHn7kOxS/Lnmty3XXzCOLK8Q1fe/wJgxBZ15lpIjk3O+OM45g1h4BGAobuhd3p6re5fWLhA2iCgzSQozA3ie1NOntjslOWM03SGfCbK6setdiroc94i0w8+w3dJIo8Zv58Ei7wu76B8x+8x6Qy0hFMi+t7BF4O6Cs8MsmpEEWZGNX0Qj37Wy7PrP024GnxfOgAUOhgSZktPtDKxL+JYEZY2aLLrfrL5KFMEPsoPwBFIuqi0GtAfYIK/0nPdz2mRnp2XtaFpt2ck3D+u3UNz7x5imwkdAZa2OIVpcQ7t48AYKExQpeApBm0ijX3/JDSlsICE60CpI2wCOZqIoaynoNfksBXEbSNfNEHqAJiOTgerQauYpJHrjiOjk/8PePEfQWJUuhS6Fit9ikEsUjf8eEewaohH0mFkLJYRaNxr2wV9hJstQzGT/5Ql4S5gkZUB9FQ66sBqIyqOYtwHvIhuuQeUzZPElMea2P03LxsDMxa+fgVCDslezBozekvvQLir85S0tSiyHPU1taxxAZsctFv64aQbwwz/Rn0eRc5mAzNBn8U81GItD/2FEkXVM2cRWWFVaAaTOW31j7wUPz97isz7A2xyJNOrKi6x1VV5evBIYouaE5m1o77c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3158.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(396003)(136003)(376002)(366004)(186003)(6486002)(2616005)(66556008)(110136005)(8676002)(54906003)(31696002)(7696005)(36756003)(52116002)(5660300002)(316002)(86362001)(478600001)(44832011)(38100700002)(4326008)(66476007)(2906002)(6666004)(66946007)(8936002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?Windows-1252?Q?8v93ZRxyQNyx5PxzylhIopXVb4Clb56Y89swtQtFOGc5rJ8hOqZ8VJNQ?=
 =?Windows-1252?Q?UJgLMZ8JEyIFeji2/kleuaPnL0wIZTJ13KsM5C8Fw6FLNe4c3NibS/sX?=
 =?Windows-1252?Q?XdXXcZYM6MSLlA3V/udpGlRryfTFEO04M8jiV408IzjojdOMd6KnHBQZ?=
 =?Windows-1252?Q?k6wM+U52u6j7TxjfJEQxrR1A81h2a5FM+35PgLd5XrkA4xr1F16E+e+L?=
 =?Windows-1252?Q?AIQF8TnR4J1J8sMiR+eCHVv6FUqc6WFyEfxsyDrLXJ/1ToDEDtmM1Hs0?=
 =?Windows-1252?Q?rfnvg1ofun9hqt9lUOuI+7Q/P9mwtZMEDEq4DsG+sZhqB8CbvmTIJQaO?=
 =?Windows-1252?Q?cElsQSSQq2S3qK1BNZTC/U8xIkDebZ31QV9BNgt58Yq/7YmP0OFw5UyH?=
 =?Windows-1252?Q?5wdW59eqBAnEyKeojHTot0T7XJlq+/Tynv+nEP4WK2ZVPMRRJL2nGpDo?=
 =?Windows-1252?Q?VeuJffvrqb3SDvDP9wxe1/WaHFepRBMozSbS18XhMPH0sM+kZUi5NKvh?=
 =?Windows-1252?Q?L9pYJxj89BJUoDHyrSiaoClfSG9kN3sqT7A0q7wH4ZUKJMh9rZH0e5Ri?=
 =?Windows-1252?Q?fqbM+yfErlAm5K02CnLW4NFWwYflp+2ILd5pdNG5yQVoxzDTWonTsCuM?=
 =?Windows-1252?Q?MCegVeBUwN7oL3a8oXTP5+cawHQnBxjM3h5vzwPS+ZVIcqCDP1C9yz3v?=
 =?Windows-1252?Q?IfDtkETCZ4e48ZMCPkIO03SEOqVVNv+FB8YYvl+EB28CrTS/3bUtqD2A?=
 =?Windows-1252?Q?DDG23t2KfE6z7mxN51V2/pwOd+smXo9waDqs6D51sBnKtzjkJysiHUHi?=
 =?Windows-1252?Q?5EWbeyIuv45YPbITTwPSnR3r3wXc9Q1qUFIIVO8INr6zmCJgOL0dUgYn?=
 =?Windows-1252?Q?jznMOifuKvhb0saWbaPYYCoX8yC6dXvK2e8BzLB9USygaTCbZAoprzpo?=
 =?Windows-1252?Q?sO/I6q3kfsjUGlDt6MKwby0sL5LPyY+OSLH8VzM5wP2IOWe0y/C6qjOe?=
 =?Windows-1252?Q?FlcRerQPiXo/UsVtJV4osOai7Hhdl4p9J5rVMizr4jkCKZ0sqFTc32Yy?=
 =?Windows-1252?Q?lk8JSugiqpi5fbB7j7MJJ2V62Oacep41ZgOt4+f1P/CGbmHxMx4nHiqQ?=
 =?Windows-1252?Q?3Fv9XVD33WoPYJDIdFpaDNGGHVrK+OWtg9mW6RZ/AsTxrfrkPfAZ+GMq?=
 =?Windows-1252?Q?PjdsWEIVFEB48g08ux3kp/0fkROxC/4Qk2cIFcys+Ff062WH0P9CR2dH?=
 =?Windows-1252?Q?v4FHbqDGx6dqRYkca6YshsO2bgffg+z+DkRSjGxkaqD2lZBo5uk0zOgf?=
 =?Windows-1252?Q?LTHEn8omgOcUNHM3nJkSzn1i1d1BseJyIp9uI0mVCbCMQCKv8NzgaIfN?=
 =?Windows-1252?Q?MRLDEt+ialaCs5KOCJkZ0mm9OKu9kN109RmAp5j9VbPo5aGloysOCqHs?=
 =?Windows-1252?Q?nyzgoFQZcyNzxpR7UFu8bQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c785133-e3b3-4376-8add-08d96ef44615
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3158.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2021 16:02:47.8617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bKLOVAQR5SpXu02yM0DnRGNCE/oHP/tPQz4qelBD8xiuLTfO/o6pZeKhUnV0yTIyRqgdHQ9I/Hj6e4pvMzBRCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4113
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10096 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 phishscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2108310000
 definitions=main-2109030096
X-Proofpoint-ORIG-GUID: bWIsnzbd83TwzMEpTwajjCzCb7aTd0cy
X-Proofpoint-GUID: bWIsnzbd83TwzMEpTwajjCzCb7aTd0cy
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Pavel,

On 02/09/2021 23.50, Pavel Machek wrote:
>> [ Upstream commit fb4b1373dcab086d0619c29310f0466a0b2ceb8a ]
>>
>> Function "dma_map_sg" is entitled to merge adjacent entries
>> and return a value smaller than what was passed as "nents".
>>
>> Subsequently "ib_map_mr_sg" needs to work with this value ("sg_dma_len")
>> rather than the original "nents" parameter ("sg_len").
>>
>> This old RDS bug was exposed and reliably causes kernel panics
>> (using RDMA operations "rds-stress -D") on x86_64 starting with:
>> commit c588072bba6b ("iommu/vt-d: Convert intel iommu driver to the iommu ops")
>>
>> Simply put: Linux 5.11 and later.
> 
> I see this queued for 4.19 and 5.10 where "iommu/vt-d: Convert intel
> iommu driver to the iommu ops" is not present. It may be okay for
> older kernels, too, but I wanted to double-check.
> 

It should be okay for older kernels as well.

The bug has always been there, but only started to cause panics
in cases where "dma_map_sg" actually did merge adjacent entries.

We bisected the crash down to the commit mentioned above (c588072bba6b),
on platforms that use the intel iommu.

That intel-iommu commit wasn't there on Linux-5.10 and older.
But the RDS bug was.

Hope this helps,

  Gerd
