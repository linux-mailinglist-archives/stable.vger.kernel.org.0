Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3397F52F652
	for <lists+stable@lfdr.de>; Sat, 21 May 2022 01:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238746AbiETXpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 19:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbiETXpS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 19:45:18 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0AE51A35A9;
        Fri, 20 May 2022 16:45:17 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KIb501022587;
        Fri, 20 May 2022 23:43:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=oK4WAMv4iUTag8CdGp1mnvBaR5pQae3o2LJa1E1IVqM=;
 b=UyL6oB4M1C61LafP4oW6wr4i9YRKTQvCitpsBY5f6Oq3Vlwgld+/9XWS0wEvlUi6eO4J
 75UFROX95Df9c6ETWMOBC5LM6DhygK7zrJ2i5KLQIWsjGZehd+0Tj5URXRLMxfbWUDqo
 o8A+QbUfDidG8J1lVvS2BA4xUMoKqKdJ3qL6uAA4NCOVB24OUNs65P1sUteTT5CAGLbV
 MfxvRGa5tNMjert47as0AYunC93YwPU3RECa/pmzbE7Tua7ajKxZr9I6mtPbXL7RrJwT
 OpYyVkWOLvJI5fWY+cepth31qXmKc+vyFrcfwp7ZZZ5dJm/4zRVlkR52oJTJ/vPaXLyt KQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24yu0bsg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 23:43:08 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24KNe8tH006129;
        Fri, 20 May 2022 23:43:07 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22vc8rhn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 23:43:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k87OL2riFJLOrSOWxgDaxxxkuDbuKrKyloyeeJ8a0PXJ06NtiTVu4G8bNpH9GnvdWdZsAmb19FU6fnw4v+KQW2TTeI0oklXBPt3Qa5/wA4KGx8/Jn9LR5SaXXEF0qrwwJjTJEVpb5Y3zqdqL9QfxcbtGxqped89QeTp4Rxy8vsW+egkijxNti1gwaSPvBgPtgqUB/wrd7JBuWyL9EDA5tHyaoYt9PIhQ3smZwVXBgtYWv+YrNQt51hQQnYcz0tnwgy7jr4cO4fP7N/qFG6fvSXSk+/YgDDt0lAZB/5qmN8rEf7RAQhuWOPvkoWI6DUvAK4eyBqfjXo/Kuws0jm46Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oK4WAMv4iUTag8CdGp1mnvBaR5pQae3o2LJa1E1IVqM=;
 b=IiKnIoy8VmnPWJ862PLgM+AxXaZRTJpIzpe7h4rJK8lsuHV0J7458ylayULMg17lOZRK8YAQ3a8FIUfiJBKYL3jSSKzHw+NTpc3MD4LNEFVcaox7WJaVWfljwPAAuFcIwKixy3w2BM0iLc7cx9NTljqjc45TKtYc0GxNpPn2Ou4/4v5ipVXC5vMFjmlxX0JotLh9tweC5Sr+ei1P1yQgLGnzMAilYfvAuXO3J+chBaPGZPEVKf05vYYHQpQxKYQc77WNqCIdw2KtFnPjyl2kdSz6s3ztfRiAxpbqN8EYXiiK0tUfIMUdfzW6ZH+JSFu54qYJ1qu1BAK6jV3+zFLOSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oK4WAMv4iUTag8CdGp1mnvBaR5pQae3o2LJa1E1IVqM=;
 b=x47FeBZL2G7E5Fn4ocC8d4YweziwFehmX6MaQhQoKuNhM66aetye/7zzvCsNA6pZZSCv+i3D6nSe0Zz4q2CZ7nqqutllW+Lz38cnZh9A6uf8O67MebEawY9NDmKTuY5fZRcq1AnhWLdObbLwZrXBui/pDeMf6UHR0vc02Fuyk6U=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by PH0PR10MB5657.namprd10.prod.outlook.com (2603:10b6:510:fc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Fri, 20 May
 2022 23:43:04 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ed81:8458:5414:f59f]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ed81:8458:5414:f59f%9]) with mapi id 15.20.5273.017; Fri, 20 May 2022
 23:43:04 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Trond Myklebust <trondmy@hammerspace.com>
CC:     "linux@stwm.de" <linux@stwm.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: 5.4.188 and later: massive performance regression with nfsd
Thread-Topic: 5.4.188 and later: massive performance regression with nfsd
Thread-Index: AQHYZR5cM0piVXjf4kWw2Fv1L4O8aq0Zna6AgAAbcgCAAAISgIAAA5uAgA41xoCAABHMgIAAVxMAgAAJFACAABXugA==
Date:   Fri, 20 May 2022 23:43:04 +0000
Message-ID: <FB8CBEF6-07B4-416C-B9B4-56E03C7E6628@oracle.com>
References: <f8d9b9112607df4807fba8948ac6e145@stwm.de>
 <YnuuLZe6h80KCNhd@kroah.com>
 <6A15DEE1-CAC9-4C64-8643-AD28EA423046@oracle.com>
 <YnvG71v4Ay560D+X@kroah.com>
 <0F5EA15D-08A0-4D3E-B5A9-D62C49BF2B56@oracle.com>
 <59118799-0148-41F3-BA03-BB69151B74EE@oracle.com>
 <1792eb49d2a9820bbcf7b240f53158170041da6d.camel@hammerspace.com>
 <3FE1F779-A2EC-4E23-BBCC-28C5E8AFCBB1@oracle.com>
 <1a38a01debc727a1e11243fd6207d915ac90c251.camel@hammerspace.com>
In-Reply-To: <1a38a01debc727a1e11243fd6207d915ac90c251.camel@hammerspace.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cb86b1ff-1d20-41a2-1d6f-08da3aba7bfc
x-ms-traffictypediagnostic: PH0PR10MB5657:EE_
x-microsoft-antispam-prvs: <PH0PR10MB56576B268A2E43E31FA697EF93D39@PH0PR10MB5657.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: otzTJnsvQNMA30YUKDOptRW0XVVXftwmRPVGo+YnXXPhlZxsgXTAqj+ZxdtiA4DWgPUd2h5a179aD8GGkWxuQn1RM0XvgvwDSZMyXXD3WAUZskBbx7+F3AfWv8nCEP9oPyfXwyoRWLrkBkJIeJL8bGPvjpJ3V6AVPQ0M50pmrOWAcTtzKolxt9nhhsoX8cJEUNRtRiAlqntrUSiSAtVUtlFx7p5FCXJggFUn7Fam+UWQmr9k3HJVGMKby4kZ8p5UjJWjX1OZ+2BH6TxqOXBdDw+PffRLpQczbG+LkeE45dEAhK6d9xa7rVxzrvBUFaztw+ry7K5jlpCAVoI8KJjra4CnX+DFzYq7lyb+3OxB1CuKAgBrO83CZYC9oPP52UYNsgEM2zQr/Q6VtimMFvw9twtOBBHc3FMCtJlT3mBcO/TyuVPAFuCvjNvCjlUw5PGNLK14WBYUocUbUBLpFqSfmqsls6SMAmh0WVZmQ6CNcOfqF7TjRwVNLGfsHrjsejQ/lLlmD2jo3dZDMVG3o49zltV66g9+sQXOwdgobe1cr9SvMz1Au/62ZMq7fI7IsLdTOLrp6uE8TMBhVntTh94lq+q5aLZICRjr8A0hZSv85xRmIBViC7KX/LXE+ixARORRuuig/yrS/eir2GL4lOeMPuMRsnQj9g6oQFpMvR0rG0SgYhf+P7FprjnUoWaS0IlzZNkeHRjVEwny9h2tR+QpYtW8CXP6n9ZCw/VVs2sx2uQEJcTer4Xj0yGX3HXv6weu30N0ZCxoAG89J7vSzJMW1SYzS7vTEAuoW+awPooZdLXn6dVU8RorFXD2fxV1HiaghIhmPJ6D6/kH5QznxrfLCaWjT8kIgnMq7h9JrDaz94c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(66476007)(66556008)(66946007)(66446008)(76116006)(71200400001)(4326008)(6916009)(122000001)(26005)(86362001)(64756008)(2616005)(53546011)(508600001)(8936002)(6506007)(6486002)(33656002)(83380400001)(5660300002)(966005)(316002)(186003)(36756003)(54906003)(2906002)(6512007)(91956017)(38070700005)(38100700002)(14583001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jz2ANya7MoCro6x2CNnKtdE75Fa77bb1sR7QzbsJKRRKMWHOWuBymzAbPIpk?=
 =?us-ascii?Q?rQyZFJaM1vTeohxxAsfayFkXnunEFM+WDbmH3NFAZYzjaWzvhnKRkjr3eY1F?=
 =?us-ascii?Q?PEmYbFMhHztyZI3wPdHs4ght/93Kh3jWbGTVjVDo3c2XfcoGf/CB0J9FGNpe?=
 =?us-ascii?Q?V4fAy3OJRaL4VhpknqlBPz1xAZkAQtQX2Na4rp0dm5OenJJdUdSBFIiDneMG?=
 =?us-ascii?Q?xOOWbxZF3oKOnZU6KYpQ53qRbyxrozE32OanqGNz/iwYCPPzZTOweuZWaDAA?=
 =?us-ascii?Q?piox2qTxGrtWwfIM9QjdMvrUB85jzk+B0cjHhdzmv2Lxdb4IAqNVYrStIFHq?=
 =?us-ascii?Q?/6UAY4ROsN/Y5uxhkStusYjc+kG0CHsaRL/U9fdbNxF+wAjVQOc5jgtdKauQ?=
 =?us-ascii?Q?33ZHxgs9Hsn2v6SuLPQQ19i6u8vWHS5Hs4TGn8aqiqil69c3D5xW+H7uJo7x?=
 =?us-ascii?Q?1s42jubfirDJct1npTjzH3EgA4Mlh6y2JAGYKBFLumVZFcly8Rfuo+wI800L?=
 =?us-ascii?Q?M9BmvrQT9e6CueCrkYHes9a4ylJ68/nQR2j0yqVdB/VetJakLOlbpszJleEW?=
 =?us-ascii?Q?N0BW6nyKYolitqTm7K++CjRwaZPWyXUFfeiNvANQ04FtVV0wJq8MNNIhDKHp?=
 =?us-ascii?Q?Vmsr5SaWR4UVdf1HVaPltLaYJ/O3wNI9dYcVzcq10lZ7QlwJBN8Xa01f+Qw9?=
 =?us-ascii?Q?jdpVLzMi2Uk7r8kgpv72sQTwJwIZLLu2ls7y22CbxOTyoOs6HD9NIr9Q4/0R?=
 =?us-ascii?Q?K+ZwEZdryq41uwjnvC0RazwGSRw64Q437FL2da6mEi/RhE5BJiXjGJL0go1G?=
 =?us-ascii?Q?QneoAginJOK/ffrJhRlzQCnGHB8DFIr4X8fgpuwgoXnOSAxlxg+tYuQ5A3kd?=
 =?us-ascii?Q?aJWgROgUonyaoXZ6e2boUhpN7eGRnQuyNkmdwHtvnVN0T1bw1UQq3kWCHKOg?=
 =?us-ascii?Q?sbFnmvztzWmk/lYUViuGk6Kn63INXDkkEGNArVwtkZ3NcxfbVmi6dO4+vZmt?=
 =?us-ascii?Q?6L5FbjESlYzDMsShf/hyHEjfLMwBbhys54FxPqP3ZIhATuYqO844xI/Xn9YO?=
 =?us-ascii?Q?PZgxAkcAx5jvqKRjSO+6XdBiD+9iLynhOStxWx2l2vfEcnHHOByiYue7cNA/?=
 =?us-ascii?Q?KlewythiLTkffENFB8s9SGJM1mN8utfgehV/SWIi3twMsYFYsRZYUSqt41Hu?=
 =?us-ascii?Q?NqkYsp1Kt9TyNHjHwr0xzV27tUrGAJelwej+ARCYyIzauvkB6vWpjHtXK628?=
 =?us-ascii?Q?MQWtg53haXrcSiQhENZFB4PccZ7fY3thw427T84FgjBddS6eos3hl0LxazNS?=
 =?us-ascii?Q?3DZ2p5lCyRjbtg8l2J4KXmTo+b27tZEx95GxErV5gua/VqjRETivTdgaJUpY?=
 =?us-ascii?Q?Sdj+iUaRc+VVV79DbGwRVdcmeKAfv4VKAyVQ8J6SOrwFsLFU4/jbResF7v6+?=
 =?us-ascii?Q?VbMdwnLcHfaZ5XbhZun3G6rZ+O+AntTdooQF1m4YGl2J7292rhjwOwvoTerk?=
 =?us-ascii?Q?vvrjUPjpBk5lrC6THRDYLi6r+OoqHg0eUZwXh0jhh1Nu2UV1/l2qgSPDYoSi?=
 =?us-ascii?Q?hhOPYu6RcoZUT42/XAbvnQPEUJq0xfY/HoxCx9xtKHMwi3MMuf+aaPbt//Au?=
 =?us-ascii?Q?E7Sx2DIwo1uEGV5Tln1fRxLvnLAqrsG6jfsL/P12kPzUbeEHahfD8W5Djo3y?=
 =?us-ascii?Q?e6oizDIovaGdk1GTMHZ2Pl1fgRTR8pa157g1qYygowOSyoYAo+y3K55fNcqC?=
 =?us-ascii?Q?4A0ev/TZ2DB6XnK+bOcwRjq1oj9Mdcg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DF27B2F01785304A82604A5BB50BAD51@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb86b1ff-1d20-41a2-1d6f-08da3aba7bfc
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2022 23:43:04.4638
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4egXb4hmCnq5s8SG+7nOybjomtRCEgRqbIbUeQDAG2oaMeJuPpQOpzUblZPwJhh0D1RgLmO6COTrFYQSqF2ouQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5657
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-20_08:2022-05-20,2022-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205200145
X-Proofpoint-GUID: QAYied-pkwPHCdQ7IvAk9qqnh-1Mm6-l
X-Proofpoint-ORIG-GUID: QAYied-pkwPHCdQ7IvAk9qqnh-1Mm6-l
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On May 20, 2022, at 6:24 PM, Trond Myklebust <trondmy@hammerspace.com> wr=
ote:
>=20
> On Fri, 2022-05-20 at 21:52 +0000, Chuck Lever III wrote:
>>=20
>>=20
>>> On May 20, 2022, at 12:40 PM, Trond Myklebust
>>> <trondmy@hammerspace.com> wrote:
>>>=20
>>> On Fri, 2022-05-20 at 15:36 +0000, Chuck Lever III wrote:
>>>>=20
>>>>=20
>>>>> On May 11, 2022, at 10:36 AM, Chuck Lever III
>>>>> <chuck.lever@oracle.com> wrote:
>>>>>=20
>>>>>=20
>>>>>=20
>>>>>> On May 11, 2022, at 10:23 AM, Greg KH
>>>>>> <gregkh@linuxfoundation.org> wrote:
>>>>>>=20
>>>>>> On Wed, May 11, 2022 at 02:16:19PM +0000, Chuck Lever III
>>>>>> wrote:
>>>>>>>=20
>>>>>>>=20
>>>>>>>> On May 11, 2022, at 8:38 AM, Greg KH
>>>>>>>> <gregkh@linuxfoundation.org> wrote:
>>>>>>>>=20
>>>>>>>> On Wed, May 11, 2022 at 12:03:13PM +0200, Wolfgang Walter
>>>>>>>> wrote:
>>>>>>>>> Hi,
>>>>>>>>>=20
>>>>>>>>> starting with 5.4.188 wie see a massive performance
>>>>>>>>> regression on our
>>>>>>>>> nfs-server. It basically is serving requests very very
>>>>>>>>> slowly with cpu
>>>>>>>>> utilization of 100% (with 5.4.187 and earlier it is
>>>>>>>>> 10%) so
>>>>>>>>> that it is
>>>>>>>>> unusable as a fileserver.
>>>>>>>>>=20
>>>>>>>>> The culprit are commits (or one of it):
>>>>>>>>>=20
>>>>>>>>> c32f1041382a88b17da5736886da4a492353a1bb "nfsd: cleanup
>>>>>>>>> nfsd_file_lru_dispose()"
>>>>>>>>> 628adfa21815f74c04724abc85847f24b5dd1645 "nfsd:
>>>>>>>>> Containerise filecache
>>>>>>>>> laundrette"
>>>>>>>>>=20
>>>>>>>>> (upstream 36ebbdb96b694dd9c6b25ad98f2bbd263d022b63 and
>>>>>>>>> 9542e6a643fc69d528dfb3303f145719c61d3050)
>>>>>>>>>=20
>>>>>>>>> If I revert them in v5.4.192 the kernel works as before
>>>>>>>>> and
>>>>>>>>> performance is
>>>>>>>>> ok again.
>>>>>>>>>=20
>>>>>>>>> I did not try to revert them one by one as any
>>>>>>>>> disruption
>>>>>>>>> of our nfs-server
>>>>>>>>> is a severe problem for us and I'm not sure if they are
>>>>>>>>> related.
>>>>>>>>>=20
>>>>>>>>> 5.10 and 5.15 both always performed very badly on our
>>>>>>>>> nfs-
>>>>>>>>> server in a
>>>>>>>>> similar way so we were stuck with 5.4.
>>>>>>>>>=20
>>>>>>>>> I now think this is because of
>>>>>>>>> 36ebbdb96b694dd9c6b25ad98f2bbd263d022b63
>>>>>>>>> and/or 9542e6a643fc69d528dfb3303f145719c61d3050 though
>>>>>>>>> I
>>>>>>>>> didn't tried to
>>>>>>>>> revert them in 5.15 yet.
>>>>>>>>=20
>>>>>>>> Odds are 5.18-rc6 is also a problem?
>>>>>>>=20
>>>>>>> We believe that
>>>>>>>=20
>>>>>>> 6b8a94332ee4 ("nfsd: Fix a write performance regression")
>>>>>>>=20
>>>>>>> addresses the performance regression. It was merged into
>>>>>>> 5.18-
>>>>>>> rc.
>>>>>>=20
>>>>>> And into 5.17.4 if someone wants to try that release.
>>>>>=20
>>>>> I don't have a lot of time to backport this one myself, so
>>>>> I welcome anyone who wants to apply that commit to their
>>>>> favorite LTS kernel and test it for us.
>>>>>=20
>>>>>=20
>>>>>>>> If so, I'll just wait for the fix to get into Linus's
>>>>>>>> tree as
>>>>>>>> this does
>>>>>>>> not seem to be a stable-tree-only issue.
>>>>>>>=20
>>>>>>> Unfortunately I've received a recent report that the fix
>>>>>>> introduces
>>>>>>> a "sleep while spinlock is held" for NFSv4.0 in rare cases.
>>>>>>=20
>>>>>> Ick, not good, any potential fixes for that?
>>>>>=20
>>>>> Not yet. I was at LSF last week, so I've just started digging
>>>>> into this one. I've confirmed that the report is a real bug,
>>>>> but we still don't know how hard it is to hit it with real
>>>>> workloads.
>>>>=20
>>>> We believe the following, which should be part of the first
>>>> NFSD pull request for 5.19, will properly address the splat.
>>>>=20
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/cel/linux.git/commit/?=
h=3Dfor-next&id=3D556082f5e5d7ecfd0ee45c3641e2b364bff9ee44
>>>>=20
>>>>=20
>>> Uh... What happens if you have 2 simultaneous calls to
>>> nfsd4_release_lockowner() for the same file? i.e. 2 separate
>>> processes
>>> owned by the same user, both locking the same file.
>>>=20
>>> Can't that cause the 'putlist' to get corrupted when both callers
>>> add
>>> the same nf->nf_putfile to two separate lists?
>>=20
>> IIUC, cl_lock serializes the two RELEASE_LOCKOWNER calls.
>>=20
>> The first call finds the lockowner in cl_ownerstr_hashtbl and
>> unhashes it before releasing cl_lock.
>>=20
>> Then the second cannot find that lockowner, thus it can't
>> requeue it for bulk_put.
>>=20
>> Am I missing something?
>=20
> In the example I quoted, there are 2 separate processes running on the
> client. Those processes could share the same open owner + open stateid,
> and hence the same struct nfs4_file, since that depends only on the
> process credentials matching. However they will not normally share a
> lock owner, since POSIX does not expect different processes to share
> locks.
>=20
> IOW: The point is that one can relatively easily create 2 different
> lock owners with different lock stateids that share the same underlying
> struct nfs4_file.

Is there a similar exposure if two different clients are locking
the same file? If so, then we can't use a per-nfs4_client semaphore
to serialize access to the nf_putfile field.


--
Chuck Lever



