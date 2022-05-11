Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E24C95235BA
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 16:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240886AbiEKOiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 10:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237732AbiEKOix (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 10:38:53 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7098F53B51;
        Wed, 11 May 2022 07:38:52 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24BDaF7C023694;
        Wed, 11 May 2022 14:36:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=GjLuT6Wo5NilNILvCP71RUavjE9XH/ZimsxunJAvGN0=;
 b=QChsTixDBBFZ02Jc3zKi29IqlpD+raM39B7lD+8gPpFlnytmCw9ZYO4xzEFqMlRLoTvt
 7YRVxLzj3Gro5CEISWxEWvG/WMgRtogc2J42kI/+GKkFBJ19o2KQufiHmEoYVZoKzi6R
 votigqBLPOvWuMbJYWhW2fy+w14FUR9oZ7wnL6FhDnkpQD18pLQexBd09sgFIGOdh3im
 loZ//oyEJxB0dwoHvW7uOs8Rnsg3FSkBeXax7dtU+L7s4+p7qlEFcnXp4Bp5cBUlMuPb
 jhDqeQrVLENA2G/5ustzOMXJ5Q0kqMr1jmNsTFibMSXoiezRRcUz7o5SJAhBAwu/OPgP dQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwhatj1a0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 May 2022 14:36:41 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24BEa7lX038727;
        Wed, 11 May 2022 14:36:39 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fwf7apey8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 May 2022 14:36:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XSE5rnxRq8TSJ5pHlATG89OxVmE91MTXfNKJECExQFUVcylyImrUnNe5Ui5wok6miPTTmKImWBv9MTs0MxCfixx+ZYe2x/0ZyQhns3g1oeLZIv2b3gRjXCi1lS5C8bUdYpt1cRetLqXGXWkmsnv8g7ltcX3XdQ8fxYN3c9oeCKM/8aoyF2d3okzoJr7vh36FDErOhW1mWjxIRjCqaLT9wUc71737ks9llhGFV5g0ZI5OUJwbXnmz+r5dGHMbrTE0eOlGiZs3nmobSlU7Sw/LhTu8j3X97iswjd3OHarbDadTm8en4E8sepXXmLU0svI+soYQsnaGwcvSw8UgV9YfHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GjLuT6Wo5NilNILvCP71RUavjE9XH/ZimsxunJAvGN0=;
 b=gd7+K8LCfZAoH9Zmit11vXChaJmv7zwCaAdvCqKSOjIualo2YjT+JJyvctXNGYUszZ3J/RrIwrQXZvBBat6n8fLJ4Iu9eRZCXo4q9VrR+hJS2bu920Z1/w//n7juTcQaLpYM1iEaIw9oZA82adlxClrqSaYm9Vy3S7Nfnv32S/B083SfIwe31Sv1jubo8WqaloS9NlORXo1gkmMzCtegyuj1jT0pj2s8vLvDOAPMiwdHmy4gOnPyeT9mrIy5g+KRDSpgo5/eReS4ojUCBSopMv+AHNIa994lEWGHs2nq9e36wOE7izWZEhA5Uv58auSpabURQxFT900QJvyN5Lr7gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GjLuT6Wo5NilNILvCP71RUavjE9XH/ZimsxunJAvGN0=;
 b=CGlA5pH2tmRMLQu9cRQvxcQsRqy+YVUrw9JE2AZxkv2iDYcH+fZ/aMpJakWVx0eiu76pCrEyuX8r0+M7pu0+oMgOTCbHhIF9NVtRgc68tIKAPYTORv4rq5FSsPaLn16nGGrQpQHfLKoYJAi4eAgq/Xr6iuE3vfZlLwUZxiEo5ts=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by BL0PR10MB2817.namprd10.prod.outlook.com (2603:10b6:208:77::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Wed, 11 May
 2022 14:36:37 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ed81:8458:5414:f59f]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ed81:8458:5414:f59f%8]) with mapi id 15.20.5227.023; Wed, 11 May 2022
 14:36:37 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Wolfgang Walter <linux@stwm.de>,
        linux-stable <stable@vger.kernel.org>,
        Trond Myklebust <trondmy@gmail.com>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 5.4.188 and later: massive performance regression with nfsd
Thread-Topic: 5.4.188 and later: massive performance regression with nfsd
Thread-Index: AQHYZR5cM0piVXjf4kWw2Fv1L4O8aq0Zna6AgAAbcgCAAAISgIAAA5uA
Date:   Wed, 11 May 2022 14:36:37 +0000
Message-ID: <0F5EA15D-08A0-4D3E-B5A9-D62C49BF2B56@oracle.com>
References: <f8d9b9112607df4807fba8948ac6e145@stwm.de>
 <YnuuLZe6h80KCNhd@kroah.com>
 <6A15DEE1-CAC9-4C64-8643-AD28EA423046@oracle.com>
 <YnvG71v4Ay560D+X@kroah.com>
In-Reply-To: <YnvG71v4Ay560D+X@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2be9359c-6039-49e4-5d0f-08da335ba7db
x-ms-traffictypediagnostic: BL0PR10MB2817:EE_
x-microsoft-antispam-prvs: <BL0PR10MB2817ADF9F050AB93EA8CB0B993C89@BL0PR10MB2817.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z1UGxY6A7OpXUT8FviPyhArQR5LP92hOl2MjAt3GBr06IVSmX3jtfY6SpS8l1rtU1+q4t0KryuY2U9QHhqVSucXb3rnPQ7fi4c/4bP3bM6/7rz8fAsxCLeyNtB7ndcE+e9YCHygYdLPy8s169gOQ7C0wOosI6/omgfm0rYj4BduQBOLOnpSKKWQnj4/fGvHB8XRxNdovgIuo4ukTR3UTxkePTohKtNl99e1ONrIb4Ufx5+4Wc7AhaYfpq0t9MUB85hlFH0ya3dvNCD5cbqJktFWVcyjgObVvbObbhYquHG0XDTGDm0UkfS6tjCTMXQE2rSlIRJHwqE1wLxxv10qJN9J+x9r6EViUVfreNIZHhyeEw9NbW4knBsJ9kaUiEQri3MdhDQfpSXDg34c5Gea1cyliDh22fja86Os0x9yfvEmlhHSdnY59Sx+XKbZdu4rHinMC0OOygMUVdT9HFMxua+S5EoOsnS7vZll2HBXu2rIhd3PlQtV0xmUPHOwqAISXDMG21tYNkpSHfW/VsrOlCa0OC0JSK1YzvLK5nDta7X5XZ/jU7DEBE6WSw958GtlwWdcKvxPUS2vvitUIfWe2/0k96wQ1vZA9D4jaziZe118JJG/Nz6Y8Il8ugHDE0VYZJkNs37Fl4YK0YT6bHdsAS9CLPLTrhj/3XE76I/wLJxCE63WEwBCBhM5eZf60PdFTYWSeA+sqSaOycIJkt8/nbmEqX4ZA+bWvt1j349BnM2TS4w0fg9kAj+7KVCBQTTSxQcXlt61R1JxqImg0e7C/vg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38070700005)(33656002)(5660300002)(83380400001)(2906002)(38100700002)(6486002)(186003)(36756003)(4326008)(8936002)(86362001)(316002)(8676002)(91956017)(2616005)(76116006)(66446008)(66476007)(66946007)(6916009)(54906003)(66556008)(64756008)(6506007)(26005)(508600001)(71200400001)(122000001)(53546011)(6512007)(14583001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dX4xffypR7mKyOaKzTLo1Qr9EpRAseL4/e4dpwDDwLPZpyzgcLhtL5zcLLIX?=
 =?us-ascii?Q?m7P2/bpZaSwlgDXG8yOGpS0vjlHa73iY8HstvgkY2vfui3gQfySQHcw1aw9R?=
 =?us-ascii?Q?otwfGrKjk9PRcb9Afspx9i5zoRv8MnRr19p4rEerPjZTxoag3pA6w8GcV+kk?=
 =?us-ascii?Q?GhVNm3SuxSwV+PXkixb9DnV4zrkb22IUA7ifOFVFWL9kNKhbtIxyhYn2LXC0?=
 =?us-ascii?Q?DQXH1OhnMOeXfnPakPLpSUBEtyuDumhZ7kCq15/gk2/RoVyFBxB/5K3ZT/p1?=
 =?us-ascii?Q?De0D99HnuTAHpfGMDbD4roZVD6I1Gx+hP5XI9uT94+jlTFcKpi2kR27WeCPF?=
 =?us-ascii?Q?cwO8PvxJbRptfQfV3PPIeYqmqII1ism85+1W2jqpj33+em7iI74cldoloB2L?=
 =?us-ascii?Q?H1MNiug6NTl9YGaipTsKN2lkLtQnUoo14s2eDUNJ8DAYMdKAgH5StkJYu2D5?=
 =?us-ascii?Q?0FAX62YjXaPlUGCYq/d9yackGSeEjvAB6qYfWl+lWvy7D9Y5kJ2bwAtKImTz?=
 =?us-ascii?Q?NpvsP7oiGPhRwmkZT1rrZIKLmvYJzATCOf2v0Gl+XuSQGp/bix7mwuaXirph?=
 =?us-ascii?Q?L5Fk4p4OjeeJI3WJidlxxCxsOG8adYq6Bg5ltJxYZtMwzfs9rAlxuKlMuwku?=
 =?us-ascii?Q?/Ups8xaGJcWCqkaUDq+V4wn4sQklSMHERjsLE9QgpJNnTiLEor7B25cKVchO?=
 =?us-ascii?Q?mQ2oi9ekL/NQ3uySBPtrM9/eGzvdHwwUQ9Oa4iBHHrbjYxujU4RGv3orkDf3?=
 =?us-ascii?Q?CZEUL8bwXTi1kwdLAK/7yxCtGE8f+UgZGV8GQvWvcB+VhpEOty3D3tjsErmA?=
 =?us-ascii?Q?UYLUVCa5RPh7TDtccswndnycNxuOItucewlvS/e3T69s8vp7IW/AyiqY1S1k?=
 =?us-ascii?Q?QjdJhyc2+cMQZ9TJRA+ZrpZZyV55AAsVc37+yxeO//OzKUIU/6jD10U8i+dR?=
 =?us-ascii?Q?EyKC1Wuui10/y8mrvzrpHZ8+spzkgjyGmM4m8cyv5fu83BLBDia0TAFJE9N8?=
 =?us-ascii?Q?l+IjM8z3TfDNhbJJn/QrwREeWzj95c5CilfHLauJ/7V1cIMlBsKON2OSLKV2?=
 =?us-ascii?Q?yq4fznWsGnf+pkfJwy/FElwkhNbZveYOAkumVsp67pNTVPP7ws9k3QDhaCFM?=
 =?us-ascii?Q?vII8EUEbxTQ8REqdXI3JwDPqYIv8dBjHXIyH7v9aqTWDF1NC9xJSmK9n+AY2?=
 =?us-ascii?Q?9OB4FelRTJg5Ym3SWSDo1+TV/XRF7RiHrF6mVeask5iJqT9wUZCSTFEruSth?=
 =?us-ascii?Q?9rfHf7BwNiaBU2AqxERU1x2NOfh36LTLiF68vTwdXU7+VNc5lzHcb69IVgV1?=
 =?us-ascii?Q?EedjVKw0GmLA9m0ysPjWFp/+1hHZKo9ab/uL3v3Gjwh/qfh7/cUrMG3l6jHw?=
 =?us-ascii?Q?vOhh4RZG5+oxBt72KrgAyIlhl4iA2gQgZbJHCP87zpn6cNio/nCqfQ3rPKHF?=
 =?us-ascii?Q?kyQr+idjqU3ePC1Yjdb+D1N+BeigXvcueIy70pMvkiAFYrvD4jNf2Q9Ktvp7?=
 =?us-ascii?Q?Xh12sltIpwN4I9hwZDyDAkEvT3cZNGeM2FTzoRDf//uRK6q+jrvVFVwoRpk/?=
 =?us-ascii?Q?ftdbT8q5ClQU4vamfTtimokJtO5ZlSm1ZOCLRB+JVeeGuAjbHJ9Gh+kkDVdA?=
 =?us-ascii?Q?e1B4deNpVoUjpX08xdhm1XLkv8F+Gtj11nX02Fuoebg7OTtTdkTAUdUU93cf?=
 =?us-ascii?Q?HGiRwbCNtqiusrabrnyLULjuL3CstNswBZF2wPgjeCdWOLL0a5IA1ZZQKOJO?=
 =?us-ascii?Q?AYyTU2Phah9PSBJNhzedBMBtL3F1Bu0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <93440AC397C1D948B352E8A2FEC2142C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2be9359c-6039-49e4-5d0f-08da335ba7db
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2022 14:36:37.7089
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8tJ/B+HZ+KSz9q4qf6NptG8kXfe7LCjRPhFPsu7v4+28F49uPRW0ikzfAbZhX3HCrt6klAxaz+vVMrDchXW7KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2817
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-11_07:2022-05-11,2022-05-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205110068
X-Proofpoint-GUID: dWP2pE2Tlh_B-OUnLuUJgD8LqK8AWo3r
X-Proofpoint-ORIG-GUID: dWP2pE2Tlh_B-OUnLuUJgD8LqK8AWo3r
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On May 11, 2022, at 10:23 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>=20
> On Wed, May 11, 2022 at 02:16:19PM +0000, Chuck Lever III wrote:
>>=20
>>=20
>>> On May 11, 2022, at 8:38 AM, Greg KH <gregkh@linuxfoundation.org> wrote=
:
>>>=20
>>> On Wed, May 11, 2022 at 12:03:13PM +0200, Wolfgang Walter wrote:
>>>> Hi,
>>>>=20
>>>> starting with 5.4.188 wie see a massive performance regression on our
>>>> nfs-server. It basically is serving requests very very slowly with cpu
>>>> utilization of 100% (with 5.4.187 and earlier it is 10%) so that it is
>>>> unusable as a fileserver.
>>>>=20
>>>> The culprit are commits (or one of it):
>>>>=20
>>>> c32f1041382a88b17da5736886da4a492353a1bb "nfsd: cleanup
>>>> nfsd_file_lru_dispose()"
>>>> 628adfa21815f74c04724abc85847f24b5dd1645 "nfsd: Containerise filecache
>>>> laundrette"
>>>>=20
>>>> (upstream 36ebbdb96b694dd9c6b25ad98f2bbd263d022b63 and
>>>> 9542e6a643fc69d528dfb3303f145719c61d3050)
>>>>=20
>>>> If I revert them in v5.4.192 the kernel works as before and performanc=
e is
>>>> ok again.
>>>>=20
>>>> I did not try to revert them one by one as any disruption of our nfs-s=
erver
>>>> is a severe problem for us and I'm not sure if they are related.
>>>>=20
>>>> 5.10 and 5.15 both always performed very badly on our nfs-server in a
>>>> similar way so we were stuck with 5.4.
>>>>=20
>>>> I now think this is because of 36ebbdb96b694dd9c6b25ad98f2bbd263d022b6=
3
>>>> and/or 9542e6a643fc69d528dfb3303f145719c61d3050 though I didn't tried =
to
>>>> revert them in 5.15 yet.
>>>=20
>>> Odds are 5.18-rc6 is also a problem?
>>=20
>> We believe that
>>=20
>> 6b8a94332ee4 ("nfsd: Fix a write performance regression")
>>=20
>> addresses the performance regression. It was merged into 5.18-rc.
>=20
> And into 5.17.4 if someone wants to try that release.

I don't have a lot of time to backport this one myself, so
I welcome anyone who wants to apply that commit to their
favorite LTS kernel and test it for us.


>>> If so, I'll just wait for the fix to get into Linus's tree as this does
>>> not seem to be a stable-tree-only issue.
>>=20
>> Unfortunately I've received a recent report that the fix introduces
>> a "sleep while spinlock is held" for NFSv4.0 in rare cases.
>=20
> Ick, not good, any potential fixes for that?

Not yet. I was at LSF last week, so I've just started digging
into this one. I've confirmed that the report is a real bug,
but we still don't know how hard it is to hit it with real
workloads.


--
Chuck Lever



