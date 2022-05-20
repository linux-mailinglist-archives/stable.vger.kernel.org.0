Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24AB052F559
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 23:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353766AbiETVyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 17:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353765AbiETVyS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 17:54:18 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8ED193225;
        Fri, 20 May 2022 14:54:17 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KJFKOX019300;
        Fri, 20 May 2022 21:52:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=gOQGMKCM42wGCxdMessjG7zo5uT8wRChfGWD7zi2yes=;
 b=TH3EfYsTJv/wiKANr9LBbbB9PtYPrxljlPGaJ3LDtGRF+ZcuDfO9gxjVtc8n4h5F+qK/
 Lc15Pfj2VocFyJt/QZAaSIcfdhCgtw/BLAchMxgrMPgAsij5sFuwxA6OymH+SUOyBE7f
 IqMxef2yXhIM387dO+0OmHIJBF7/rGUQYnjWgyoDd7OmLJP17adYX5rjgsy7XHervcRR
 yipE28mMAZXj0vIx6DBUkb7UiJa0bSHDBi0Da/pXcW2VsOf61ptpb/xy3M9AiZPldi+k
 CWzL7EKRXXhneiSNcmmllc3bO0UKTBM3u7vlrf0DEFIloA9TgZl5Yo5J7aOkhMszuJj5 nA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24aaqr4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 21:52:07 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24KLjvSQ036614;
        Fri, 20 May 2022 21:52:07 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v6vb7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 21:52:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VLcXiNf3BAHAx9nOvjyHvtHGxO8ySpgGmfDaMjuNwJuKvstEcLybaFIATrxSKtqBu+7O/1tUCglvTSYCOyEhnZgIwfbfaCqBo//4zvfyIhcfaxWgrkPV9Vki5vGc/4dFHYS2SpasyALUEYaC91rvpSluK/NgWgW9Bj9RGrqIu/repq9zfBAYukLjHtkwFb5JVdFLfoNUl2bJ1mk07KMy+CPTZRqYsXKC2Q5TlBavZZHuKOiYbLDyzvmaUV2wPRr/j9E5w8nJ6OWAavtU5ERAzpTuI/xkQrmXnXqNoJU/AkACEQCIR5KLzeUOb4mA2/LMRsIPDNaVOvsBTktkG6OzJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gOQGMKCM42wGCxdMessjG7zo5uT8wRChfGWD7zi2yes=;
 b=MOkJbVKdKLh6rQBfg9d5/uBlVsxSjiRMyS6sLLdRUYMfRDpmRF4wUGFxRmgsIt7pJHATKWJppy2D2aCNZhMNMemXFlGlYwvguPXWE8aOmhheYW+iYl+dbJlQqCMJ+Si+HyLA6PImdyPRDDb1PWb4pda83oulHra7QMkcLEsdEe7XqdPevfp8YYNemwQ9hpu/QhQcafZdUsik6qMNQCyZNOXBDJ2s+J7mOhe/gxYKOIIowM7cfkSx5QDotHZGUMa9ck3vUsbOkCRJAN4f+kSxdwDcPVdL6V60o78OQR6zuST/Zfe+Fe4dmYOwVGPZqyUXsqrPgL/wYOFUuLIaM39PsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gOQGMKCM42wGCxdMessjG7zo5uT8wRChfGWD7zi2yes=;
 b=eRQqYLXJmGTs+NNA55TZDJ/eI+2oMQNTZQr7RZutP+DneqvCYsuFDNJdyDIcQHu3Z5LmV0t8Yai3qKkZjxwzsNjJd7Q8vbPo+1zDbJ50y1HN/P3TQxXRGJzd8/PEEHtf4GjMUoUAr/+YnABL8KTG8gNdS9MuMmAJLL4aSZN4QDI=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by DM4PR10MB6232.namprd10.prod.outlook.com (2603:10b6:8:8f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Fri, 20 May
 2022 21:52:05 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ed81:8458:5414:f59f]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ed81:8458:5414:f59f%9]) with mapi id 15.20.5273.017; Fri, 20 May 2022
 21:52:04 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Trond Myklebust <trondmy@hammerspace.com>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux@stwm.de" <linux@stwm.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 5.4.188 and later: massive performance regression with nfsd
Thread-Topic: 5.4.188 and later: massive performance regression with nfsd
Thread-Index: AQHYZR5cM0piVXjf4kWw2Fv1L4O8aq0Zna6AgAAbcgCAAAISgIAAA5uAgA41xoCAABHMgIAAVxMA
Date:   Fri, 20 May 2022 21:52:04 +0000
Message-ID: <3FE1F779-A2EC-4E23-BBCC-28C5E8AFCBB1@oracle.com>
References: <f8d9b9112607df4807fba8948ac6e145@stwm.de>
 <YnuuLZe6h80KCNhd@kroah.com>
 <6A15DEE1-CAC9-4C64-8643-AD28EA423046@oracle.com>
 <YnvG71v4Ay560D+X@kroah.com>
 <0F5EA15D-08A0-4D3E-B5A9-D62C49BF2B56@oracle.com>
 <59118799-0148-41F3-BA03-BB69151B74EE@oracle.com>
 <1792eb49d2a9820bbcf7b240f53158170041da6d.camel@hammerspace.com>
In-Reply-To: <1792eb49d2a9820bbcf7b240f53158170041da6d.camel@hammerspace.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cea1cc94-3157-4ef3-e885-08da3aaafa95
x-ms-traffictypediagnostic: DM4PR10MB6232:EE_
x-microsoft-antispam-prvs: <DM4PR10MB623243DDEBB5CDB2689B2BAC93D39@DM4PR10MB6232.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TjC1cX+pYHt849stDJgrjOvLtEIkn8I1/vC+hYnabIbX7bggdqS76s0f9MA8Yw9+Prs2E0f/OTQH/muXB19GyYwDFGNjqobbOVq7pwIndPLJ7ToZpE+yUUkEiWXe3XVijUdk9NdfR+D2wDpCz49FK9rbohTlxirk2yn5cFsuhWnM+TCYelEiwdk/BaPzBw52G+ZYTakpe9VVO94fR9b6ySFbMj2lRXja7JguGjOVzJnret6zh+Q79bMonTTDWIcotYajr19EQWqy/AMlg70HUWeY4Crr12OdhXssTTAMbb+dn5IL45YvQq5P+ah1gN7Zj0SaUQiSfESB4wms9c/O/ausUHHaX7q6uqTrDgZIA8NlD0PpZ8nVC0DYYgZTb7AplT3DmZs3DloQw/fH/xCthvIAC1bYuBr5tMtiai+SSqJ6bdv/XTh9NjpcD7KBKFboDw4u8mARd5w7UQvyqlVk2SgbAk6mEoxCxDVSDUCkzAEwXy52EucEPBSsXflhGM1dSkET+YdzTDE0JGk7nFkZUhbAe2FcqhFezjdrTocTUwVgioOg80bFgkPaBg1sDaDSFfD4BTFdjdm2mUpoEDTy6tIfVeAkgtb9rGtJlbSjECtn9K08Q1B51vCbAgWk1U3MufBq1AplGTYrbo35Z8VMvGRSpWI2/yf4WvDktRxsGR3b7HPAceBr+ckr8+4fD2RTlJ5c9wkKKo+QzIIu/vn/+Ql3Y8iU7vgRCBD2ESrgHUlbPAm4QN97cJEGE9rMTZ42B962Tea1m356izrvDO9ysIjzOErTNUw5+H7M5AVwMD8Y4DdbSv6enpHDigKCZXzpg5QsMh5rvz0QR70EP+whxwS+1SWZC9Dv6m4Gx2SuHbs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6916009)(86362001)(53546011)(6506007)(8936002)(186003)(36756003)(6512007)(4326008)(316002)(26005)(33656002)(54906003)(2616005)(966005)(6486002)(76116006)(71200400001)(8676002)(91956017)(83380400001)(66556008)(5660300002)(38100700002)(38070700005)(2906002)(66476007)(66446008)(508600001)(122000001)(66946007)(64756008)(14583001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?k2NcL2YW16AZareClCsuqzOu3Z8FjBybsvPsjlC7+Ps2Ts9nhSTK3/jmYR7r?=
 =?us-ascii?Q?jjMHrOx1XCyKIhsdclVvRdg8FV54/zXaI2DqGCqEFEWc01ACrK2E1i7DFIS8?=
 =?us-ascii?Q?SGmnL6Sb7J2y5/GUCNRzhGfzMrFzCpgmEVPRtGPyzX9y4zouebgSlgiq8xH1?=
 =?us-ascii?Q?OboC9DbyGC6vjzyU99Gs3xF3lFLDtWVoKwhzVB4dSgmnAAyzJ9M+W3s1zoWP?=
 =?us-ascii?Q?NaFdhTCHmgnN12FDdkutNXt123jkXJzrpeIgnhHHNepStMB02p7VemmY3g+c?=
 =?us-ascii?Q?FI7cb54/TG86/BkrPIGt6S4y0T3+m2Vu22ALmd9LSCtRi8DleATBo38j80yG?=
 =?us-ascii?Q?+EQOH3oPFFo8KL+a/n2IlEfNver0sSJ8WTScPDc/PMAxkdawmDsGrCcO9FvB?=
 =?us-ascii?Q?71GXFwIxV7a7lIfEdABAJ7r0J22E3OfvOlPYc6/c6A5MY6qthqpR9BVcTCoy?=
 =?us-ascii?Q?9fVlzEmsV7+ZTAQrnVBftqdhibF1mPJ5xATkVYS5iHILSqVkqr9V3/T8YAKw?=
 =?us-ascii?Q?lIXRBKhxirltypaTb0yRuT4dJuBWxzY/3fDpnbYp+bAcEnjpc5kF7bICzj9W?=
 =?us-ascii?Q?0nQ4WnL3UAxr2LCo58nIYFhRqgwDCnfDkzJzTi8nZdlXRl/d2U0HyyolMuhz?=
 =?us-ascii?Q?yAXPHYCvgby4sAj03FzE2NtyGw+v301Gggeh6SGCl9Kt6C7Uiyu27SoQ3KdA?=
 =?us-ascii?Q?w+b1zfjLqleemyJZW2jK8ahL7YY8xARPr3nChzZ2t7RIOOp0fGipRsKsfv4/?=
 =?us-ascii?Q?sCBbXa4Cx1czXtt0yABnBTxX2pD4gACAaIAVaYSLYh/DnZ4lzoDusWphO3A1?=
 =?us-ascii?Q?NNGt4a7jaGFZs/yHWFHO9bPtdOIHNN51TXgYMUojiqDT3OO8syZaX8u38euE?=
 =?us-ascii?Q?Js8wKa1TpYQ7IJHYhdPZw87LTG94WvQiwdwTTct6wocYflF4fZrRkCVjfppq?=
 =?us-ascii?Q?AupWe03Sm4Bga0f5W8AWoPs1Gs+cLR/lELWQId59EamhNrJhseRHGOvXCPM6?=
 =?us-ascii?Q?h36DlXhCuHi/8KJwnLvqtTdq7MLXRm85kKyuwERuWbw9/74JNjZ/cVhGE1XD?=
 =?us-ascii?Q?xBJrujE5Hd6jxFXvYnHgxH75FDxCX0MrP3Uny1SWG28GhaOPuS51FACKZfVn?=
 =?us-ascii?Q?rEOlRMdCVick0ETk/fUbpQafivg6YLdD8WQEZL4IPrzMKRoyolI82oGe0H8P?=
 =?us-ascii?Q?aFyH4yCCGtxnPBAIKO4zYoUxHNOrD9J8KOpFSzCp1AqCYwvjcuqG9/lxRt2e?=
 =?us-ascii?Q?KtWMnujtoPUwjvTpQPTrDIvE7VnqlQ/HO1NLb8DwVzeiZN/mgod3/vPjH3J5?=
 =?us-ascii?Q?xRkrh/aLluHtJii67cESX0jdXAax2VdP7F2zc71S12ZLftMKyZ/AgsJskah0?=
 =?us-ascii?Q?gsHONPHtwldvUC0Jxsqh9C8fNz3YzJWwkBOS8hFN6O7M4qJr0Peqqmdds7lk?=
 =?us-ascii?Q?D96lO4u6N0G/W4tZphr+rOCGTNAtcoNVGwGXfQFM+mBzRKwv91U+GQcJDRne?=
 =?us-ascii?Q?xYkvKNIH64rPpCyYRhxwMuC0mdovmYiIU2Z1KeymSWdEHVy+UqGE/lc+roHw?=
 =?us-ascii?Q?plQapHLc/BsCX4jgmWilQHQPerWsnoCIRsh7WH/WFAUnUaiqW4xqctnhsdX/?=
 =?us-ascii?Q?yIplE9+cJVpX2tasizFw9BEkCRNNBuOxKl221/QDTlEs/X+CBz6642Ofc5AL?=
 =?us-ascii?Q?9qWz/JBhd1zzK2Phup9lyzy/w8prQw40lYrQq8lyQBVXrUmSF1Q3jDn5yrxE?=
 =?us-ascii?Q?bBTAX+ER6PjnZr7AXZYvT3a+bvbQCvw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FCFCACD04B870A45B60F1DC2415C1B30@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cea1cc94-3157-4ef3-e885-08da3aaafa95
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2022 21:52:04.9169
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Bjf5iHtsXPhxUjKRk8LLDexkRiXkI3TT8N2f/QRUGsO779wg/JbTWLKvkbL/08S/flchxfRF0NYvnmSBGEcN3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6232
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-20_07:2022-05-20,2022-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205200134
X-Proofpoint-ORIG-GUID: RptaC-OdKXeHnnCDamsy8NTu9AVSiBLp
X-Proofpoint-GUID: RptaC-OdKXeHnnCDamsy8NTu9AVSiBLp
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On May 20, 2022, at 12:40 PM, Trond Myklebust <trondmy@hammerspace.com> w=
rote:
>=20
> On Fri, 2022-05-20 at 15:36 +0000, Chuck Lever III wrote:
>>=20
>>=20
>>> On May 11, 2022, at 10:36 AM, Chuck Lever III
>>> <chuck.lever@oracle.com> wrote:
>>>=20
>>>=20
>>>=20
>>>> On May 11, 2022, at 10:23 AM, Greg KH
>>>> <gregkh@linuxfoundation.org> wrote:
>>>>=20
>>>> On Wed, May 11, 2022 at 02:16:19PM +0000, Chuck Lever III wrote:
>>>>>=20
>>>>>=20
>>>>>> On May 11, 2022, at 8:38 AM, Greg KH
>>>>>> <gregkh@linuxfoundation.org> wrote:
>>>>>>=20
>>>>>> On Wed, May 11, 2022 at 12:03:13PM +0200, Wolfgang Walter
>>>>>> wrote:
>>>>>>> Hi,
>>>>>>>=20
>>>>>>> starting with 5.4.188 wie see a massive performance
>>>>>>> regression on our
>>>>>>> nfs-server. It basically is serving requests very very
>>>>>>> slowly with cpu
>>>>>>> utilization of 100% (with 5.4.187 and earlier it is 10%) so
>>>>>>> that it is
>>>>>>> unusable as a fileserver.
>>>>>>>=20
>>>>>>> The culprit are commits (or one of it):
>>>>>>>=20
>>>>>>> c32f1041382a88b17da5736886da4a492353a1bb "nfsd: cleanup
>>>>>>> nfsd_file_lru_dispose()"
>>>>>>> 628adfa21815f74c04724abc85847f24b5dd1645 "nfsd:
>>>>>>> Containerise filecache
>>>>>>> laundrette"
>>>>>>>=20
>>>>>>> (upstream 36ebbdb96b694dd9c6b25ad98f2bbd263d022b63 and
>>>>>>> 9542e6a643fc69d528dfb3303f145719c61d3050)
>>>>>>>=20
>>>>>>> If I revert them in v5.4.192 the kernel works as before and
>>>>>>> performance is
>>>>>>> ok again.
>>>>>>>=20
>>>>>>> I did not try to revert them one by one as any disruption
>>>>>>> of our nfs-server
>>>>>>> is a severe problem for us and I'm not sure if they are
>>>>>>> related.
>>>>>>>=20
>>>>>>> 5.10 and 5.15 both always performed very badly on our nfs-
>>>>>>> server in a
>>>>>>> similar way so we were stuck with 5.4.
>>>>>>>=20
>>>>>>> I now think this is because of
>>>>>>> 36ebbdb96b694dd9c6b25ad98f2bbd263d022b63
>>>>>>> and/or 9542e6a643fc69d528dfb3303f145719c61d3050 though I
>>>>>>> didn't tried to
>>>>>>> revert them in 5.15 yet.
>>>>>>=20
>>>>>> Odds are 5.18-rc6 is also a problem?
>>>>>=20
>>>>> We believe that
>>>>>=20
>>>>> 6b8a94332ee4 ("nfsd: Fix a write performance regression")
>>>>>=20
>>>>> addresses the performance regression. It was merged into 5.18-
>>>>> rc.
>>>>=20
>>>> And into 5.17.4 if someone wants to try that release.
>>>=20
>>> I don't have a lot of time to backport this one myself, so
>>> I welcome anyone who wants to apply that commit to their
>>> favorite LTS kernel and test it for us.
>>>=20
>>>=20
>>>>>> If so, I'll just wait for the fix to get into Linus's tree as
>>>>>> this does
>>>>>> not seem to be a stable-tree-only issue.
>>>>>=20
>>>>> Unfortunately I've received a recent report that the fix
>>>>> introduces
>>>>> a "sleep while spinlock is held" for NFSv4.0 in rare cases.
>>>>=20
>>>> Ick, not good, any potential fixes for that?
>>>=20
>>> Not yet. I was at LSF last week, so I've just started digging
>>> into this one. I've confirmed that the report is a real bug,
>>> but we still don't know how hard it is to hit it with real
>>> workloads.
>>=20
>> We believe the following, which should be part of the first
>> NFSD pull request for 5.19, will properly address the splat.
>>=20
>> https://git.kernel.org/pub/scm/linux/kernel/git/cel/linux.git/commit/?h=
=3Dfor-next&id=3D556082f5e5d7ecfd0ee45c3641e2b364bff9ee44
>>=20
>>=20
> Uh... What happens if you have 2 simultaneous calls to
> nfsd4_release_lockowner() for the same file? i.e. 2 separate processes
> owned by the same user, both locking the same file.
>=20
> Can't that cause the 'putlist' to get corrupted when both callers add
> the same nf->nf_putfile to two separate lists?

IIUC, cl_lock serializes the two RELEASE_LOCKOWNER calls.

The first call finds the lockowner in cl_ownerstr_hashtbl and
unhashes it before releasing cl_lock.

Then the second cannot find that lockowner, thus it can't
requeue it for bulk_put.

Am I missing something?

--
Chuck Lever



