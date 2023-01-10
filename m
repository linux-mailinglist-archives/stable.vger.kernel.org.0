Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1BB664ADA
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239467AbjAJSgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:36:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239562AbjAJSfq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:35:46 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6F012D01;
        Tue, 10 Jan 2023 10:31:28 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30AILbUN026032;
        Tue, 10 Jan 2023 18:31:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2022-7-12;
 bh=4Pp0vJ2m9ujViSQMacPDQL5Yai2nPxGHgqTAz+Woxmk=;
 b=DklV9LYTzWwxh5R2fz5/fOabmj8sd42YrB1wZDuHgF74rmNmrB/xU8mW+8PEHkyeEK9Z
 kRb0COtExbFCXwwxOMjGi0UOgeD3uG8P2iuDHlUAh/FWQOuDMMfsiDcPKthTeJdQHLyV
 Qa0d1v8Pj1RvqkmQHEDPa+s/ZsxmzzMrJhiYFWcAaM/ZkdY7lLiITBGHEHQX0cj1obYu
 qgEVUxhCUYrEABdi1PzemBRSPWoKRok1Y6ht8qizoiZqWo34baVYc2cXB2Kyn+Z2JNux
 YaFSS8+rpFgXs2nYb3Rm3ujAJ0t9Uqu83l93RrK+ZXC/MMhTpYkujGEjAlAZ+zNlQbwa Jg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3my0btp24b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Jan 2023 18:31:21 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30AHFox6008160;
        Tue, 10 Jan 2023 18:31:20 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n1a43kw8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Jan 2023 18:31:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gxe0yGmig6rFtZOI4Wzh3FM+E+Hx0+S14jiae2Ldf95IrGcsAYhQEV2Pk7bU6Ydr6O0w9AZ6RPx4cDdnn5KVMUaDusjvmPudU5ceTiPlyWS15idL9A2K9XBzUPuQmezY46GUSX1mxBVngIFKgVkJD6QMYk2zZ60bLjM+UJTNkyZpIBxsIqbVRiJKAIu2kHnpegXv/tHgtXIvpTwGqMIzHU5HzT9+UbE8i8ADMPdF64F/Qnejxdc28Mp0IUt3SPmwjzdwrBjezAEaw6W1jW4W04tJbS3yKe6+CSYP/iH2kcMexdusvAwleW1KL0vA0jZjGdRPbzDO/Sx+n5AJxq3Hig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Pp0vJ2m9ujViSQMacPDQL5Yai2nPxGHgqTAz+Woxmk=;
 b=N9176WgHQ9BPzZcY14PenNAhvJW1G5BVxF58y8R3iFuUVJYoomnxrNMK44WmahKt60qOzX3JraZ2PipSH+12EESaB37aSKPkvR6Npqp3jusIMLS1/f8B1CFgT0aVv5qJ7HnwieQHum5YDUYUdsvMiyh32p8N4YtRkpja5z1DUtRu2IPONjaiBASctaNbO3dY72FxzP9lICo++Upr8hXR4Fz3bTJSa192vXF9+hGBAHnRwF7mpv6A9Pqo6x+/mmeIIphtonmwlD2JdEl65Ucf2nH38iavdqkKn7YH+VZxizDt1aGoOPJgZcaD4gQG037mLppoHAF2ltrIre9sIrqUVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Pp0vJ2m9ujViSQMacPDQL5Yai2nPxGHgqTAz+Woxmk=;
 b=nMYAi0u/96LQszVKGkz+vkkiKAFNKl/aus04SZGEdiL3QpSWyjzeIkuuxrDr0amgv/FIAhP7MwO1Mr3w/uWWOMKxAhCc7x0kesGHcDVaxvhaiO/qrs3Cyd66lUynM5GAExNTQ5mzpUlBUapQh97IBYm29wwscMz/3niRwQAaCyU=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by PH7PR10MB6987.namprd10.prod.outlook.com (2603:10b6:510:27b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.10; Tue, 10 Jan
 2023 18:31:18 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::a02:2ac8:ee3e:682]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::a02:2ac8:ee3e:682%4]) with mapi id 15.20.6002.012; Tue, 10 Jan 2023
 18:31:18 +0000
From:   Liam Howlett <liam.howlett@oracle.com>
To:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "maple-tree@lists.infradead.org" <maple-tree@lists.infradead.org>
CC:     Liam Howlett <liam.howlett@oracle.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH v2] nommu: Fix memory leak in do_mmap() error path
Thread-Topic: [PATCH v2] nommu: Fix memory leak in do_mmap() error path
Thread-Index: AQHZJSG6awBw/jODyEuOun/2rM6IXw==
Date:   Tue, 10 Jan 2023 18:31:18 +0000
Message-ID: <20230110183104.1266017-1-Liam.Howlett@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.35.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB3022:EE_|PH7PR10MB6987:EE_
x-ms-office365-filtering-correlation-id: f047ff7b-3839-414c-db87-08daf338dd59
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5XAvoVhg6ExU5oQgLz2pZ+usI79p5AzrkfdRMeNbb3yh1MG9d+sJMPg0K55bmg6fWrP/LuMQZTUwzTdHYRVVc+cf1uWT5df4aItnQX7+evi0gof/XEGSVbJKkMgKW6zaWE6kphdBMw9A782xKtAmepg72dp9wI43mM7IXaMvS8jq5EgRUEDrkDC3l/fXFpevVWvVcl2TgzD/NKmbzkw07bxMDUWtnAPDZCusfeC9u3wrs6+UGwYWQCMMnsQY/qkOanoDzsOB8IdFfkf5gakim71CRIEKGT5tfPY1t1ey7vlCKpCiAzjUuems/q4duCZldxD/6nJHFDPJNlNTNf/b9wQC2aEOn0SAObJtgFxDYPv7Nzd/4uA8pOlx4ytEzaQQ9JP2Ldw2UZWmj3TpCBS6FCLbE1o8LWYAiR+aRK4kzWg+912sui2SqDDaoEm402YOIRqURggW/68+31J1jAY5nUjtkErZi1k039HRaLhhelkQteqeyea5oTyyduKw0TviViEELxKanyqh7u73zlSFBGwdFhu7wif18hycg47kXS2fUAqbhOXnZlOqbGGqbIlZAPh5BjjPiRE1S8qAcRe3JhuCEGuigPgmDi+G7Xz821H54GSIXAUP4rhqfuT4l4+CLSImYCNwKa6XzyssiaA61g78AwLkje6hXy7A2DIGUEDbT99J43SHo/MJ45tNGJfAwkFpV2ZiOQMQFYhz1vsdhw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(396003)(39860400002)(136003)(376002)(451199015)(41300700001)(38100700002)(38070700005)(122000001)(8676002)(4326008)(2906002)(44832011)(36756003)(5660300002)(8936002)(83380400001)(26005)(186003)(71200400001)(64756008)(6512007)(6506007)(478600001)(6486002)(54906003)(110136005)(316002)(1076003)(2616005)(86362001)(76116006)(66946007)(91956017)(66556008)(66446008)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?M2g+8h//m877Ms1m+ArJBp1sXvi+aIfPhMDsgM0LOiRKwKt1sE7pFz7RNX?=
 =?iso-8859-1?Q?/NqspwStLX9imA78IVir7jUcodzVJ/wuvnXvWfVhsI7ygFzYFY5zRtL9Fp?=
 =?iso-8859-1?Q?IPdqZGvXHExjLY9GUoh8cHfUem+sdqWYm3TTClmYwjkMrbDdllr5S48fas?=
 =?iso-8859-1?Q?IvlF79/Q+t4OH2dA0AjBdwWLGyNw9yLpFgeeni9ED+RIAOtbdQ2eylUzSp?=
 =?iso-8859-1?Q?txMARR9F0qphU9tBAl0e6xT3Lp4Edf0Z9b30gDIixEFdb0kIxk9E1kAdha?=
 =?iso-8859-1?Q?z4msbeJoz74/ZCV8rBO0c255zQZpvyv3Y8LN9eO82XaBjKkPkQr/xDgK5I?=
 =?iso-8859-1?Q?+82TaorSu1i+wXoQqGtV2la6Zo+68n/5UjNPs/kDGBK169gMoExZgWv/lZ?=
 =?iso-8859-1?Q?c49kQQ2oo7pLL8PKnkow2FR6K7kQTbe4rxtT7o8v/A8+kYKOhyYipGSwdi?=
 =?iso-8859-1?Q?gVegytrvJh+zvyUXvojOWoqnl1542EaffD/BFmyGS7VbV6mfB0+qIyYQ2n?=
 =?iso-8859-1?Q?mHt749qoEj2fcKX5lG5fQ4gI35+0hJ86t7rhLyJd1cC75HytmjhrSX0lLj?=
 =?iso-8859-1?Q?E56m+naHN8P8KztTvetfK7INHKzag4XWsNHucca29c3RMkIvJ2KU2345pm?=
 =?iso-8859-1?Q?IsKVc63jGOE8YgvSyp88/RrQT6rzHkiDZ1LF7kt+9w3ew95uaML4Wtvq8i?=
 =?iso-8859-1?Q?MQi18jx2pnVftW2X5tb5R6F5KibfBJA2hP49gDeeVs3OfckGbpS8Xhjqlg?=
 =?iso-8859-1?Q?dJZiP9fF5RqytQhCV/g2YlzKhsuXsHMOvvDZZYzgRdKmhNSQoCGsHGu9bs?=
 =?iso-8859-1?Q?8tZRsI4tEci8Fw7VNGkN8uumg4OSwHdMEovjN4blI3DVJEhf+dxF6XatJ8?=
 =?iso-8859-1?Q?CD98MJq+215wvkVnhpWhR+ozIjF6IGPnc23LnZhDDuhe2ja+i7J8xvun1p?=
 =?iso-8859-1?Q?1agx2Dj949dohaKe6nmr30W+FMmcHuMI6m6Fg5VA5kwsxTQ++fi88sdBHT?=
 =?iso-8859-1?Q?J2hGra6N/CZ7UCEfbEo8d8HPzj8CxdAq9zqOuTQCmQ+23x6zrRwmE2tJCH?=
 =?iso-8859-1?Q?YarZxmLd7hE3jXIJ0VzUIe2rLK48VBYaE2kLjQAi4NkvdcYoTn0vGPskZZ?=
 =?iso-8859-1?Q?pteXpe6MADBnGEvEEDMXpktDHyGcq2pifLggAL7zb3sm5hcqZZih2p/nZI?=
 =?iso-8859-1?Q?d9p+zBVPD8EJvRYUA8YKIGPoz3y586OHEmU8uBLvgweUEtCYtUD4G22EcU?=
 =?iso-8859-1?Q?54tOI9oyxzLQlNUTZxZnTm8A6cZEbUy/vCyx3oDbYXlrRwJs6zwVsjMLXY?=
 =?iso-8859-1?Q?alRfuj12hs03CFtBwfQ6cU46gEQooZhkSe4FvLLWHMpaHj9dscYlJ8cLoo?=
 =?iso-8859-1?Q?Qw+O9XzGaH+TVdEZDm/405WuKT4v3Q0yEPB9KWS8MYKowx3dIpWHWJ9wPL?=
 =?iso-8859-1?Q?1/RPTkVE+xmbdCicfZSFNTDJpZOUqylNgVT39SM21+9ibfreqIiEemA2pn?=
 =?iso-8859-1?Q?OYJ2fpdEeLa09qs3TGLKZmTdmn2Si6fAv0DB2+YarqB2IDg80cNJvrjYF3?=
 =?iso-8859-1?Q?qqFo32HZVTM3fXyCnM+LcOWhg0uSY/jERh0LdH5OOiwHIVjfHxcawBC92Q?=
 =?iso-8859-1?Q?3Yy0MBPUDo5jiK088BF8GB+h7SVPGYt62cLuTDXUXc+s72yOyIJQcGGw?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: QrmNfTTfXYJorXLct1jr+eVhhUIb1VsbFEudW1TUbr8cvEQAu/nfRIig+64FHB0gG4h79YJRf5UuUw3H4le4D1TK6mpXbhhDay/8x1WIzOB5qIownkcouKhvhJPmi955s/2UJe1rUMk4HbbnD8oU6KErIyzQP4EvHt0u8dQTy/ETfFr+mZvzcv0toyKAWWGAmjccx3gght7qSGspfO+XeoIVu5gS4R8hc1IejQNs+dKNQG9IT/Dt8fRwko1PB/PZxAMPlvGcTTggtPwk3oPYIu4sFHwe2UIQ55Pl95mWZoYckj8JbGQTUSBW9nqZytJpjk7Pf+Ga55q85406dF5ElcCMkS8IZlokC1lmBE2d25dF3HJIUmv4rRwiqFln8ghVJtCFgge5o/OA+AdbfBm9LdRPXMEMwqiFdctj+tyoLJLtzGk7UBiI9OuB1P4DSMCmaajQRxLXhdM5PjN/uYhN3W85s6vbwj0A9ILtTF535W0xrLBqqY4KCCzKzgERC0sgrGV0pI9aF7paCbiybovBVxg3vV+tXAtPD/CXymHEnCYndu9ZFuWjMzkW15gR56C0L2DBLZVCNWV1Qi6Y92rBvg6om6U90m+dzzWiBgzQi9UPNgsyyWqUeaLXMd1WnK1Gp3enyADR9Y1fmqfG141eMiNSHa+oabHPsBcfQs0GJUIKXj8j7YdS90ZggIZPbA1izrXj+pIu84SC99zuIQyjPOJH6gaDHWYiyKcmANJ5SmyYm/DfqkGrXDxGshk/ZH7tuvnXOnf8B5TX0AKGQffj1j2WQBQTDdfVZhUSTDpb1eRcrSZ/NuNkkNCKA8/GJXcWL1cskEa1VAyaSn3GTJKroKzbeoPdOMhrohfI8qknEbA4GbxJ9y/LiK/T7DKGDxEQb461ltX6zOejBmSA7pQVkA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f047ff7b-3839-414c-db87-08daf338dd59
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2023 18:31:18.3406
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +TjjeYvBZaBjGSGaWkadzgzf8Y18nSmNl+lZrO23QtpnHMal8sFur5VlNBTi5mIdc7oK+PRwxULQG8o6DbAiig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6987
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-10_07,2023-01-10_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301100119
X-Proofpoint-GUID: p8SJArurH-X90bMIOms2sRJ-b1jPSkSC
X-Proofpoint-ORIG-GUID: p8SJArurH-X90bMIOms2sRJ-b1jPSkSC
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The preallocation of the maple tree nodes may leak if the error path to
"error_just_free" is taken.  Fix this by moving the freeing of the maple
tree nodes to a shared location for all error paths.

Cc: stable@vger.kernel.org
Fixes: 8220543df148 ("nommu: remove uses of VMA linked list")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---

Changes since v1:
 - Added 'Cc: stable@vger.kernel.org' to commit message

 mm/nommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 214c70e1d059..c8252f01d5db 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1240,6 +1240,7 @@ unsigned long do_mmap(struct file *file,
 error_just_free:
 	up_write(&nommu_region_sem);
 error:
+	mas_destroy(&mas);
 	if (region->vm_file)
 		fput(region->vm_file);
 	kmem_cache_free(vm_region_jar, region);
@@ -1250,7 +1251,6 @@ unsigned long do_mmap(struct file *file,
=20
 sharing_violation:
 	up_write(&nommu_region_sem);
-	mas_destroy(&mas);
 	pr_warn("Attempt to share mismatched mappings\n");
 	ret =3D -EINVAL;
 	goto error;
--=20
2.35.1
