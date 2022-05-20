Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2EE152EF5E
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 17:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351015AbiETPj0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 11:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351018AbiETPjO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 11:39:14 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB49317996E;
        Fri, 20 May 2022 08:38:59 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KFUs3P025083;
        Fri, 20 May 2022 15:36:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=BRDhp6x9h6AES8PKhN2/fPw7w/amRKDLwpsBWHER364=;
 b=aCkoYYN9kmAv+PV5YYkHchIW7w/a2Js5BjC1isrLuppzrgspmCTJJBdA1JRmAqb5Iq2E
 waOAMvFZhBSCnBsuPqH9cAidCTjD5WbvUQ5J1BAcSLKmAjAutnjwnpsh400fbGcBqwDg
 x72Ypr8n8ipKZmOZ7uaSw/zk8jCR5RmEn4abzun30lfD4H/HxCOccJuEPyVIxoHQKtDi
 z++tY08tJF703CZUu0+RpeiSjlzG0FUhlzYqdTDKueZa/N1h6163RQ3/zmFwmHZgo/Te
 6LESLo2wZVgLQ1bwPmQPNVqaqw2v/PJZU3se4mYOQYulyQmCBosay2shot0QYSeJJVvF +w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g2310yd1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 15:36:47 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24KFQ79N002655;
        Fri, 20 May 2022 15:36:45 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22vbxhuk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 15:36:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hBeVoR5oSIoQtbrVKFzbaQ/R+8ywlhrTOmRTSm/NiOorlxpIb5mf/XtOTVX5WdTQomuNFQMyX5ARd3zIHp0xKz7NEtSHiAkhdqoonoZxVugHc7bj3C3mmXC1ZvXphqJODaTdzfTWESpiBoQn5YZKiXmR8qOfReBsT5rsEPzP6t2bXIoYheIZMN6EzVJxyn/3wEOlzPSdQJ9rZmKmW18JTyRg7wtGe0bYJLq1kf+3VDXZ8tb7bnOOJBPdlTJW1LSK9pquLUgiWa7BQJz4JulbS8uWkFo4h8nXOt8tDjxokZCTj73zw34n3IMLZqEf7C5CjSFKLHn5gOeBwAgOal7OHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BRDhp6x9h6AES8PKhN2/fPw7w/amRKDLwpsBWHER364=;
 b=jBGcDUuWXWDpEMGc3+jjhMTqQe3uCXoMk8AUElqjIVlaFPhx1kIwdM4G2dOYdIOtBAfjfESMB5WbhwuiNkXJaRr5X+RygWiFcSypkAjRoepYhg5msOrDzC7NyJsIeUWP4SRhso16w2TX7064D0pA9NOalnEzeGdafApUDnZciRiNWjrS6IxHF6G06WQ86rpqJB6M86tESzed2p9UovsDDySFw8cssJDHKVUl5fTKe1+7/q+ZCRTGv7ZEiqQXFNsJ3D0IWb2GyRgHTdGnlws6zNhszEBMm0R3rmjH/oaiCEFyDgTcFI6TnSRa5Wjvhi9k5cjjvHSRmwTXkb/+ohCmgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BRDhp6x9h6AES8PKhN2/fPw7w/amRKDLwpsBWHER364=;
 b=0PyKltQKMnfBvDZv1rijOX0+w96YN+aXbEXs3XprZw2cpMYWnhpSw+7IfP1LvMrdfIMvEfdW2m1U7CwPK6WwacSs8qSQFvhGkuvL8FLB3EpXkxEUuAUnIYeyycVkCH/mh6jMK+JbT+xmwYF1VRaoLR5nUzqfdz4wwq+RSLvxNfc=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by DM6PR10MB3387.namprd10.prod.outlook.com (2603:10b6:5:1aa::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Fri, 20 May
 2022 15:36:43 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ed81:8458:5414:f59f]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ed81:8458:5414:f59f%9]) with mapi id 15.20.5273.017; Fri, 20 May 2022
 15:36:43 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Wolfgang Walter <linux@stwm.de>,
        linux-stable <stable@vger.kernel.org>,
        Trond Myklebust <trondmy@gmail.com>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 5.4.188 and later: massive performance regression with nfsd
Thread-Topic: 5.4.188 and later: massive performance regression with nfsd
Thread-Index: AQHYZR5cM0piVXjf4kWw2Fv1L4O8aq0Zna6AgAAbcgCAAAISgIAAA5uAgA41xoA=
Date:   Fri, 20 May 2022 15:36:43 +0000
Message-ID: <59118799-0148-41F3-BA03-BB69151B74EE@oracle.com>
References: <f8d9b9112607df4807fba8948ac6e145@stwm.de>
 <YnuuLZe6h80KCNhd@kroah.com>
 <6A15DEE1-CAC9-4C64-8643-AD28EA423046@oracle.com>
 <YnvG71v4Ay560D+X@kroah.com>
 <0F5EA15D-08A0-4D3E-B5A9-D62C49BF2B56@oracle.com>
In-Reply-To: <0F5EA15D-08A0-4D3E-B5A9-D62C49BF2B56@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 58da857f-0ac8-482b-f390-08da3a768ad8
x-ms-traffictypediagnostic: DM6PR10MB3387:EE_
x-microsoft-antispam-prvs: <DM6PR10MB33878A7B2D4CEBE2B1A3308993D39@DM6PR10MB3387.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tnvh2QpmI88MD9ku+9Tvj9nUtwzvn+NHnXfkYO4F/aEMYZhsRFLIkGTB03BMQE+AY23U9Ncbe4rzZzfgCoGOdBDIkp9JBxp/BGsLojFraHRA3tC/Oqr6AFvTRIf9VgQaD7comLQiyPS4AKDNDO1BNdICK+k0AP0dbKRnbLtaogN+4hUjx7OQS2sKJwvcD66ymc2HCVyhDsSHi/Lh+rkocIk8Nd7Cu6GAByLFQQ1tLw4YdaNqY9H1UDobUt17dZvZcKHZ44PbpbmHWeAeEmwA1oD5pKB3cbyeR39/2tlLXGkvPn4gHxcG1Rwm4zWvWoBie4N8V+UvQzcP4ZCP0Bn/5BJ15lp2txIzbThFpDXPHG10iaSPflCv7kbgNsUMSRPeL4O9jtnFFAhimVgCG6IKWY19O7kxvOKftmHdmxmr09xoCHpV9GXZ7mMuUcZeSOaLzKD69cOYKMgzswoC1hLZ670SV5kbXpWtHGSSJsmPSUubysltHny57hHaqkr6B1qY97702XrGAMARAOUFf+cQw+NRzH72qVHfkp737usyUvvD2jN/G7tHIomkuJW4uno6wb8gccazgn/MwEz1LFdUytuX/sFuTrlwYiMmpVP3LNr/4O9ib1o0EVhwglZf3zMdNmGtvksvDPNWTkMjSmnMWqPPezpqtEmg3pGo1sxRnf9dZ2zGiVohZNO0OKvAKyLXINzoP4HwTDq213tvhMDECDUnHrN+j/jw/gjyGFSbY9bkL/zlJbFk4eXJ0qZlb/fXl++j0Gb7pGsqSD1MZR2YmgdxO0bv705WAveUT4B6bxRzWE9vSEVn2wCrEk0AUfnTaz7tZiMSacc2nJh7kMQZ+d6mVEZ3soBd3vNH8+JJ30Q=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(71200400001)(966005)(6486002)(186003)(6506007)(508600001)(91956017)(53546011)(86362001)(2616005)(54906003)(33656002)(8936002)(38070700005)(38100700002)(26005)(6916009)(83380400001)(122000001)(36756003)(8676002)(5660300002)(66446008)(316002)(6512007)(66476007)(76116006)(66946007)(64756008)(4326008)(66556008)(2906002)(14583001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?so9/cGSF6qi2RMzWNu4ENBscv1ZUDgExrAp3km/Ow6MM5cJdjSIFZUG5I7fp?=
 =?us-ascii?Q?y7C6TueuHGeJzvImbH6JhXKKDixFjTTr1qhLLYGPaScgOnm8cbMm1TAJRPyk?=
 =?us-ascii?Q?nSy+2QHy6nGaoejWVg24Ws63G2iCyokvZG8y5BSD93aeQGcA1JA/LOXrWK2a?=
 =?us-ascii?Q?/hlETaPNnuaAIGP30UH4DdK33UcipzRANtthH/81NHe6dmWVqdUV9WRBm1Hr?=
 =?us-ascii?Q?77qSx3Fd5c5MmJf4S2On/3aaebrWKx9AjVkc9rzA9F089ZfE5mqD28xthmdZ?=
 =?us-ascii?Q?Sbfg2VlTutiYw+BlDOzm2z6L12idnZ2l2vM5nVXnaaHd9/OlcWRFYPZ/QKOa?=
 =?us-ascii?Q?ROHfx/fdlGISsBeecVA1KzFIeWIANbzr4zN4E8alK1BV1Z3kiz4z0lAyrQ7u?=
 =?us-ascii?Q?KJJ9MBbYyuuU/k9zKyBqpX81IhVw13DU2jVU0xFZ5K6cmRCtTY6t4NpY6rmp?=
 =?us-ascii?Q?nZJ+vRDMPWPRXJUPUGoWQSS0g64169OShdYxodPGAAX/BygbBJ23qsi9DkNf?=
 =?us-ascii?Q?bDflbFZLiUcar/L1ubnXs8VaegONWrZlxRQKsHKh+cJOHqapnBocZTZk/bH8?=
 =?us-ascii?Q?lwmLV33Armn2F6o69TRpLue/Lksq9j3YiI+WpWaj4f/fTazDAUqyLcGdwNW6?=
 =?us-ascii?Q?lFylfj5DkmczWR18l2gZpMdBS6fEZLMO2BmsMKvKO1VTcbkSqmC4Z28YfS6+?=
 =?us-ascii?Q?DeD2ES8yHLJP39Am1Qu9GRri/QItWMi0B7wa4Qa3Hgyv2ICcFa5plXiSrzNU?=
 =?us-ascii?Q?gU2T9EmB5HHuksfRe7FeclLZhR4S+yKcNPM7rgkLuESAKpRJn+EKlFiVzFkv?=
 =?us-ascii?Q?eCADwJwLzfWe3JQaxsuW3+qt5k6ePcp4Guhw1JKeV5RiLzcH1NuAGqef/XHm?=
 =?us-ascii?Q?n3IbxzDsVvL3yaF0akcvXBBICrZyhguDy9WLU7Lg1gMWXMov33jChDlUtI/r?=
 =?us-ascii?Q?99CaZLiKCGuMdFwQWPH+2tbWZKJ7gi9M0pmCCdrIKoKN4i/kmGSDoxfgNYw8?=
 =?us-ascii?Q?Xju9J+a+NCkKXeFw/lUIFZPz2ZP8Iz8BSFxkdPQlaU6UTV4+hAvmfnBNCWSx?=
 =?us-ascii?Q?HueiaB/M1RPfRCro65DLWv5Hu/pcBhxR07UWpka9niw6Oy/FAkroFFhohtGb?=
 =?us-ascii?Q?aDOYko90tB/JrKVGOd+73v7slIc8z2MihXFyslPjyxF8pjaMTLrzoipT/TOL?=
 =?us-ascii?Q?dIVOln2n22TYuDWeQH1UtR+mbsTAr/g8LrLdlQzQl7DKc+ImvJTDtQ6AeQ7Y?=
 =?us-ascii?Q?pUWpRFRy5H4pYhbPsukirUaGaj7vFpxqSPyyAkdBDFQFoamLVU8aGCa/Vm++?=
 =?us-ascii?Q?bzz5IgcJeToW8q0pLroje0zt29+q7u/aOQhgKcSWXeEx5loAreuN3uTMhMWp?=
 =?us-ascii?Q?HlOJuaidfwVncLpiN0FeKhc8/aBD0OSpInmjFT7isC4y1CPOBbUIcNXCPkkX?=
 =?us-ascii?Q?JrolelYKEM0qmHq6gXdmNPZUZZ5o2c57VIvTpU89Mnzi/par2uLa1zmN8fAk?=
 =?us-ascii?Q?y18DXIOS3L+iFx3ev99rFxNiV4zucUYnrd2aio29U4Au0fYzWGc9gQA5uCbs?=
 =?us-ascii?Q?pD6tamsSZIt7/+QiecYDEFBvz9Kpsb3MP9uhHuyNs/KIi+0hSsHXFhIJedcy?=
 =?us-ascii?Q?zm72Mvpd09AGyoSWoJxvVlESG+edaf+qILi3AOSmv4yJIjgaRUR7Jky2z9Ac?=
 =?us-ascii?Q?q0u3Cbh88PRbXv9BiVc/iQmkQJrfD0cEibp5dKdv7wSc4OuqMRGcgM1Jqkx1?=
 =?us-ascii?Q?cK4Q8WEiFMwuOHd3bfjvmkQmbqA9V4Q=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <420926F8A5848E498DB6396F797FC96D@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58da857f-0ac8-482b-f390-08da3a768ad8
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2022 15:36:43.6216
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8DJT69XTfNaGU9BlearIpnECDhddeLNXmNY96nXWomsmEtoRCpPBlhBVLd96WyjRK39cbSGcHQ34ZVuz6yvyqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3387
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-20_04:2022-05-20,2022-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205200105
X-Proofpoint-ORIG-GUID: SzqfDY1WcW81Q_voVGvY-H3Ag1dhKhdY
X-Proofpoint-GUID: SzqfDY1WcW81Q_voVGvY-H3Ag1dhKhdY
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On May 11, 2022, at 10:36 AM, Chuck Lever III <chuck.lever@oracle.com> wr=
ote:
>=20
>=20
>=20
>> On May 11, 2022, at 10:23 AM, Greg KH <gregkh@linuxfoundation.org> wrote=
:
>>=20
>> On Wed, May 11, 2022 at 02:16:19PM +0000, Chuck Lever III wrote:
>>>=20
>>>=20
>>>> On May 11, 2022, at 8:38 AM, Greg KH <gregkh@linuxfoundation.org> wrot=
e:
>>>>=20
>>>> On Wed, May 11, 2022 at 12:03:13PM +0200, Wolfgang Walter wrote:
>>>>> Hi,
>>>>>=20
>>>>> starting with 5.4.188 wie see a massive performance regression on our
>>>>> nfs-server. It basically is serving requests very very slowly with cp=
u
>>>>> utilization of 100% (with 5.4.187 and earlier it is 10%) so that it i=
s
>>>>> unusable as a fileserver.
>>>>>=20
>>>>> The culprit are commits (or one of it):
>>>>>=20
>>>>> c32f1041382a88b17da5736886da4a492353a1bb "nfsd: cleanup
>>>>> nfsd_file_lru_dispose()"
>>>>> 628adfa21815f74c04724abc85847f24b5dd1645 "nfsd: Containerise filecach=
e
>>>>> laundrette"
>>>>>=20
>>>>> (upstream 36ebbdb96b694dd9c6b25ad98f2bbd263d022b63 and
>>>>> 9542e6a643fc69d528dfb3303f145719c61d3050)
>>>>>=20
>>>>> If I revert them in v5.4.192 the kernel works as before and performan=
ce is
>>>>> ok again.
>>>>>=20
>>>>> I did not try to revert them one by one as any disruption of our nfs-=
server
>>>>> is a severe problem for us and I'm not sure if they are related.
>>>>>=20
>>>>> 5.10 and 5.15 both always performed very badly on our nfs-server in a
>>>>> similar way so we were stuck with 5.4.
>>>>>=20
>>>>> I now think this is because of 36ebbdb96b694dd9c6b25ad98f2bbd263d022b=
63
>>>>> and/or 9542e6a643fc69d528dfb3303f145719c61d3050 though I didn't tried=
 to
>>>>> revert them in 5.15 yet.
>>>>=20
>>>> Odds are 5.18-rc6 is also a problem?
>>>=20
>>> We believe that
>>>=20
>>> 6b8a94332ee4 ("nfsd: Fix a write performance regression")
>>>=20
>>> addresses the performance regression. It was merged into 5.18-rc.
>>=20
>> And into 5.17.4 if someone wants to try that release.
>=20
> I don't have a lot of time to backport this one myself, so
> I welcome anyone who wants to apply that commit to their
> favorite LTS kernel and test it for us.
>=20
>=20
>>>> If so, I'll just wait for the fix to get into Linus's tree as this doe=
s
>>>> not seem to be a stable-tree-only issue.
>>>=20
>>> Unfortunately I've received a recent report that the fix introduces
>>> a "sleep while spinlock is held" for NFSv4.0 in rare cases.
>>=20
>> Ick, not good, any potential fixes for that?
>=20
> Not yet. I was at LSF last week, so I've just started digging
> into this one. I've confirmed that the report is a real bug,
> but we still don't know how hard it is to hit it with real
> workloads.

We believe the following, which should be part of the first
NFSD pull request for 5.19, will properly address the splat.

https://git.kernel.org/pub/scm/linux/kernel/git/cel/linux.git/commit/?h=3Df=
or-next&id=3D556082f5e5d7ecfd0ee45c3641e2b364bff9ee44


--
Chuck Lever



