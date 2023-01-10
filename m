Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A18E6664A9C
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239542AbjAJSeD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235340AbjAJSco (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:32:44 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2C51581D;
        Tue, 10 Jan 2023 10:29:09 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30AIIBrR006581;
        Tue, 10 Jan 2023 18:29:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2022-7-12;
 bh=ryq5ykfW8hyb5XMulMyq6cEQa+L00s9lDWKmuxRTQhg=;
 b=1GANX/Lv3yWMv3ZiyVv9R/syqYDQJ79ANd5YjntnnZw+4CoVXxyoKT4J8b1mHyc3eENH
 0+FdU54m2eeJxZWeJhVMJ351mJXS5tIom1Y4dr58uvmbE9aKN10ZhHF4GV7plu+yyy6p
 Nc5c1wrFvg4sLDvBM16hp4aBX+QxkNp0yTN/VLC0rqWrkVdqiaL6cKhU+9L3HF4E0yoH
 gTtm2BGRx7q+NHZIPfiuurTokEqOJuyNSbCHOkTXJIFYP8lg9d+C8k+9m6i9vcF/qCSg
 zhGAD0ud7TslxfQzmeJ7grwa3Z0Cprb4MHZVOV0bY3Cfi9fx/eIT+rq17vqoRdFN73/B GQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n1cbq850u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Jan 2023 18:29:00 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30AIITOd015348;
        Tue, 10 Jan 2023 18:28:59 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n1d6cgdjc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Jan 2023 18:28:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f8cG3WwR7jc40FWxiVxRLn0nJFf1A04WNOXD8QqB45x1GrS2rpMoNRRyF7PxlFTE/o/QbPM60CYcJHQv4PGqaedT92FvnEaASghQ40ZLfFP/2TooNy+Hvff/VNGYyWqeD0cbja1QGks6QiYSYHtwkAk2mjlCScBQGpevxmaiwQNF9NaLRnmCVA/e3zd3fRCoxZQ/CH2oJ88xhRSIavlEsBwYLulZe2SuiteWMQh47UfeRNZx4n49IiPvNYPMj16LfOQwsBbgGnNkshthha7m9hMt0Ib7zOdBjxZ13fRByvDNol/HKURm8kQ4ZiZz5A0gGa64t03Dv7BmRCrivVxwkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ryq5ykfW8hyb5XMulMyq6cEQa+L00s9lDWKmuxRTQhg=;
 b=crowLIhCJSS7+BH3I5tv5duRby8PUusfVXqyzk+eKdqBRzRtAFsGDz9b3wdnk1tq7zv5Nm1k0KRSRQ59cdBaeWESfFEw3mrRWPt1/jSkg3kNVrXv/uEhpDLMEbdIeifXK4BCknhrm7bF7QiDOCoOeMoL+I3M6INUdWOZgfJ0vu1aakm4PCljj31D7Nyu7VJz68b5danxz4AKJkyTSe9SQpMnNs0WBas3f9cKXwuj2PQLDwJcEoRvaOkenz4/iKMcrEKl8bsLMB8MEIGWV9KapjJLqPuarZke7EoB7EatmitbtLDwSyHp3PcKv5ZnvSQqGJYdJ4WJKyILakhGv9UG8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ryq5ykfW8hyb5XMulMyq6cEQa+L00s9lDWKmuxRTQhg=;
 b=0RnUC0nny+bCMn0pPaHv1XJCRl1JeSBvJWZDdVe/8O0dMqQz6IUIUcTVY81TQ4qyvOEcR0AkzRbJdD1APaVEWoNe+1bS/3KRvF4I869f4asqZhsBCbhno5GPLRpvWEMcCZ3ZS/fQDaV4qKvTrZQuX+lhvSzfkVyRk3nnaiHJk14=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by PH0PR10MB4614.namprd10.prod.outlook.com (2603:10b6:510:42::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Tue, 10 Jan
 2023 18:28:57 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::a02:2ac8:ee3e:682]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::a02:2ac8:ee3e:682%4]) with mapi id 15.20.6002.012; Tue, 10 Jan 2023
 18:28:57 +0000
From:   Liam Howlett <liam.howlett@oracle.com>
To:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "maple-tree@lists.infradead.org" <maple-tree@lists.infradead.org>
CC:     Liam Howlett <liam.howlett@oracle.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH v2] nommu: Fix split_vma() map_count error
Thread-Topic: [PATCH v2] nommu: Fix split_vma() map_count error
Thread-Index: AQHZJSFm3vE8pFFbEU+0mBeoZWAv6g==
Date:   Tue, 10 Jan 2023 18:28:57 +0000
Message-ID: <20230110182853.1265561-1-Liam.Howlett@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.35.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB3022:EE_|PH0PR10MB4614:EE_
x-ms-office365-filtering-correlation-id: 5fa22971-aef7-4f92-13fd-08daf3388961
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fbHGA6nTJEZE1wuIs90cla5TE9IiC96AQpgHJqqNI+/NrrVrNAnDaqunuRqJlvxU8Hc42Cx3v1H9+6fiOUDJr3xxobjN+cBXjKRKgNF5Zl8aLEaOTwVb4H61skBlnqcspfvXNtcJStyTGIsqp0V78VAZDIU+cczL6cXryodEsUWW9iewKG33+D4hvyfpOk6yPrrpukukJvn9GCkByeUdses6Q/fqG1Ss2g709W11s2VRUL2GFO1XAkVv4C+RnlI+qyTb/t5HwvjARYTmTMYrGSTg2OfxiwcHGw5n/7Kdj0Q94DG8YBHE8ZhBEfYlzBtGxrNeYWqEA/zsjuy3ncuDKKM89iLe3y+NW7IyDCKDCW2Fr1p65t45GNF1PiiYb9UerNUyZMRoJ8E57a03cRY05Iw1n/tsCiHf0G9L6eA0f3S3YJLJIKH87TZYhHy3RGUnjSaRJj3+GWMGiqex21pvCW5sC8+huZfIZyrDv5ARQsCL7I6+S5/ne3hiArDm1g3Jfmi32P3F/0MO4ZWpbDjPxS+7io9WynK9eWUN58drPQmkQHHDZ0NUAPlbEsAgqBbO402jUETP9BBWwWSWcJ3h8IEYSwMzdGofeSOnuwBYPqpTIc63T5se99PVcbL3CbSsqojOOuR3zB0ifx+ylwmvTgnahJtcNL89byTXsRenJs+cHSHcs8zHnGUdBTY23RQprgMgz5bl6rmJ0soe7p9DfA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(366004)(376002)(396003)(136003)(451199015)(2906002)(110136005)(54906003)(5660300002)(36756003)(86362001)(44832011)(8936002)(41300700001)(4326008)(38070700005)(8676002)(66946007)(64756008)(66446008)(66476007)(76116006)(66556008)(91956017)(38100700002)(122000001)(316002)(6506007)(6486002)(83380400001)(71200400001)(186003)(2616005)(26005)(6512007)(478600001)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?4nj0R8PYKDWs7CIBflsz279ZDihN7x10Y4ggjUdUMOxvfny4iwOy7qonHq?=
 =?iso-8859-1?Q?IdtqOWuA7C1Lvi9KlOcJmh1G7EQtM0tcCM6zmp1DrV39JGZJrgBFGRE5+O?=
 =?iso-8859-1?Q?m1tLcwqkV64IMNhp7iR/up7sZlz4wcyLfhasIXfPP4JkNrPtKwdyZ/7cKN?=
 =?iso-8859-1?Q?N/L/lDXqaB/Bup7Jq1R69sItmgDB1nZ19HMfq4QRCmfo0jN21Olq2C38wr?=
 =?iso-8859-1?Q?wEYqwKGKQCO8+/cmp/qr9a/F35o4znayHYlKsVyVrFxMrAuLkjTeavJDwH?=
 =?iso-8859-1?Q?GaqDdtNDXuyi5W7yxjqkGcSGSE+tNWR+XVnM0db/Deh/kr8cfWyxM8i3PK?=
 =?iso-8859-1?Q?g7RnZzTr5MHVnDuLlo5U6XmpddwuP1JoZ+79tLmr8wzVoG7I9DVQoePNSv?=
 =?iso-8859-1?Q?tP8wNDhWJ3VwAnNsJgzsqgvmwqnBbw67d2hdYqbkyxdDmIckPdl3bjCOHI?=
 =?iso-8859-1?Q?vI4JwXtcyuAi7qbFf61HkojRR1Pv4nRvsVBu85m2acYJmU9jsJM6Zq64jw?=
 =?iso-8859-1?Q?Qw0nIZB7LCAObJBsNg2JUbYKd2MlMycp4qU/wpXG5iumkrcnQZ9cge64Kv?=
 =?iso-8859-1?Q?raRS0+vefFjUhFau9+SvcWfFcT4YQ+Z8LJsQ+nW2JsEOR4P8Hlwqb6pzoH?=
 =?iso-8859-1?Q?c8W6DRar+RrAeXjW+0F6mBW41CvwhJWzs3Vx4Q+4mtwcAKNdLZyzODVqCs?=
 =?iso-8859-1?Q?1+wJXRPQBqddWJdQp7GdR3jKP7JUQtJC0LmNjh8MiLHiCBzzhhT+OjJaGm?=
 =?iso-8859-1?Q?WfeuOB1d8jRoNb/O29PjS4lmc8iYLMppUdmpI5Ki4ej99cebDHIFViVmGc?=
 =?iso-8859-1?Q?tdRU8/Ttfslk1Zr/Y0UOgcK5IziJGbOKhWhjx2LPX4H7EiW43VNpdnzq21?=
 =?iso-8859-1?Q?S2cEHh4CgL8lA7nyKHNyxtPfaaIawS/fqqyYnwbYNDAAvsD4lqJCiW+n2c?=
 =?iso-8859-1?Q?RVqj4dknAb7nHfzhnPtUaSNez+9DGQhhDM+9175EwGyQg8AA8ghv2/s2Me?=
 =?iso-8859-1?Q?01CwZWeyaH6vaaI0PDs1padWAIIk7hlimjpHyd++U3iGhmet1V2zgNpxQp?=
 =?iso-8859-1?Q?MdxScDsu8McFt0pordwpfcObOTQzzQJt5nAW1f81gOTklYbllKIRi1rW3a?=
 =?iso-8859-1?Q?9MS9JQg3KsxeatOFi+EoGFzqXEkwqsjydyG1ZKhikLxFmXuupbwMtfl2cy?=
 =?iso-8859-1?Q?oki4WzVJU+gN1ZY7j3BPo8dQbzaBGmlL0qy8i5NEVtAq0IN0WOJSATA1Ja?=
 =?iso-8859-1?Q?8GHEVL+8IzuYjKJP8UVDVnN/CDzBkpddDZT5s8WIY9oGv7q0ykBFUje+Gi?=
 =?iso-8859-1?Q?+ozgD4QOFUje8xHlXgYmn5/vHzImvSJH5gBOwC7klzDNbdqrz1I9y9qpAB?=
 =?iso-8859-1?Q?cUfvmTFcKebNBSfatyiRzcY7bre+NiOcoeB34jSwlJMwgq9J4NcQq3PkTf?=
 =?iso-8859-1?Q?JMz3mjzL3PYrbi95QBsG+4f5cbyBgL+4AGARZxXDXyPoKLP8psFQrlBkRd?=
 =?iso-8859-1?Q?1PleJMQZm4lcATEo+1QGJxprMu0VS7REFIaX0Lpqf4QdzS55v457ozGEhs?=
 =?iso-8859-1?Q?Ugs89AaMpMRChuVjRhrOp5TANvR1Nhcs1kkEuNQ6swhBoe9Nexy2tLoI/b?=
 =?iso-8859-1?Q?5QVWyn3OG4KpEnljwGYhXuR9L1n04FOPISHTvWVqripDBfn/vFYl4ufA?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: nc5GCj6KrNYiwb6edAU5lo+TLQGjPvE9vHjubQgTrl6KrfSOaFO9+rbYKpnQfkIzVSWcx5FtO4uuh6LSmgCVhxwvudDJBhhVHU6TroqNcvtAXZjVZlG8xReGXVH7mNwWAMzKlIDyIZbVrrsnbZ70n9Zd3W0BEj+BN04vYabKVZxEahwNX8mt47dRc8JJ7BzGVZ2cPT6km+N31vLegjYoDOt55ashVAxA9FPmGqdmQ/OSS1akBViSnDYYD5R0XuoW+azgp+K4xwSxXRxLeEoFp7IzC4BANe9Djuh2dyQYGPqEqAUjetHL3coBPk3dxViS30Vdh39qvkXP7pyLhQttAQTLUeP0LxvvXuMYPc+afpQ3Zgtxbz5BElTiwYrMatD2rpjQyiJNOzte6UyVqWYXQqJBFrjEGMfw0qqDMjB/bX8xodLp0dJ16ht04WtUYpWhAGko0qoC23BUWtscVwchdD+kSDAMPuZ81YTWkxCq8aWAM4FV98SMnwH9JTW+uVLyEsI8dgEjx1GHMhP29lxqjWo8y8Ou1dKb9tnaNm4zs4drTaYMPO+eAIfoz6Kkb0bh7qKMJotaD2Ae880mQTp3566PIlbHM0eGbNtfdxG3VA4UMb+F4qoHFquZTccCQl7NznQMqXAQihFStdZCstEYEux/vskKsM19BxyZFClVKZ9lHqdUKRmSB71KCTAcKaNU1gnGk9Jl8AAVr+xeEZ/U7l2s7OVLoMsKoeN/3Y63MhpwmlN/3i221SGr2PJGBwze2sUhjUjJvrt8GpkNa/5DRFmUBgPM2w+13SDd9gVfha7gmpw0QPwSH3vxGC6uN0m+2B80FxUpEtaxZsxrnfAuReclTrtLrg6Uj+qb4QhzbDmKuDfb/eN7ywhMfaPh9sLP4SZ5Ec7rw4tjioutmNOzZg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fa22971-aef7-4f92-13fd-08daf3388961
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2023 18:28:57.4436
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H55jrUWNjDDG/57xtEEcN9yqv9tYHqb03INCW81VJ7B6/LWXox6FJG4j1kkG7Wt3dUJZ4kJu/gfo5oKuqQDZLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4614
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-10_07,2023-01-10_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 adultscore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301100119
X-Proofpoint-ORIG-GUID: tnoGI06UnJuPFT5ZvSxI_cuQcGDzHBZL
X-Proofpoint-GUID: tnoGI06UnJuPFT5ZvSxI_cuQcGDzHBZL
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During the maple tree conversion of nommu, an error in counting the VMAs
was introduced by counting the existing VMA again.  The counting used to
be decremented by one and incremented by two, but now it only increments
by two.  Fix the counting error by moving the increment outside the
setup_vma_to_mm() function to the callers.

Cc: stable@vger.kernel.org
Fixes: 8220543df148 ("nommu: remove uses of VMA linked list")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---

Changes since v1:
 - Added 'Cc: stable@vger.kernel.org' to commit message

 mm/nommu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 844af5be7640..5b83938ecb67 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -559,7 +559,6 @@ void vma_mas_remove(struct vm_area_struct *vma, struct =
ma_state *mas)
=20
 static void setup_vma_to_mm(struct vm_area_struct *vma, struct mm_struct *=
mm)
 {
-	mm->map_count++;
 	vma->vm_mm =3D mm;
=20
 	/* add the VMA to the mapping */
@@ -587,6 +586,7 @@ static void mas_add_vma_to_mm(struct ma_state *mas, str=
uct mm_struct *mm,
 	BUG_ON(!vma->vm_region);
=20
 	setup_vma_to_mm(vma, mm);
+	mm->map_count++;
=20
 	/* add the VMA to the tree */
 	vma_mas_store(vma, mas);
@@ -1347,6 +1347,7 @@ int split_vma(struct mm_struct *mm, struct vm_area_st=
ruct *vma,
 	if (vma->vm_file)
 		return -ENOMEM;
=20
+	mm =3D vma->vm_mm;
 	if (mm->map_count >=3D sysctl_max_map_count)
 		return -ENOMEM;
=20
@@ -1398,6 +1399,7 @@ int split_vma(struct mm_struct *mm, struct vm_area_st=
ruct *vma,
 	mas_set_range(&mas, vma->vm_start, vma->vm_end - 1);
 	mas_store(&mas, vma);
 	vma_mas_store(new, &mas);
+	mm->map_count++;
 	return 0;
=20
 err_mas_preallocate:
--=20
2.35.1
