Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D64D9651038
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 17:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbiLSQUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 11:20:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232087AbiLSQUd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 11:20:33 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22552BE9;
        Mon, 19 Dec 2022 08:20:32 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJFwwTX006969;
        Mon, 19 Dec 2022 16:20:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=NDkSBjzdwLwncyvm8sHTFzzk1yAZB0eg7D/tZMY80Hc=;
 b=HLRlMb31NNquYBAiI5P5fxNqtvifnsFxLIAEfr4ki+byGY7+SuqTGgSZ/HWQifolP1Q8
 z5kJA4NzRekSrYzK+yhLHQXMvt0tf1wMo3EyQoU/WBqrS393r8WucobEp98dTBALFixH
 2Le0MpieeP1ex3IeC61kQMW3FN/fduMc9bAWuRZunK9QctkE9+rcc6hUyL+vCQJwmsG7
 n3eKGQcjy9DPhOAyDMux60jCw6+/74FouyyK6stRy29n1x5Kn7sUaxUl6Xuci7rQBN8H
 be5fgDfW1vSSuEQMbpuU5oexMO+gV7+nUIzxTSngkZUTIXFyBmZ0Tiwg7dwk5U2K+/Ii /w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tsu9xw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Dec 2022 16:20:18 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BJG15Pd024209;
        Mon, 19 Dec 2022 16:20:18 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mh473yj2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Dec 2022 16:20:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=axJ+/jYWmUXyAvgtbHUFAcRRajTl6zOk09vYJQ+D3/ZTQBPXVDIE1lTfWxMuMkSNLZPpibEj7onmgVsTd+859vPLg6bId2gnlVqUoVibp1bTjUt5T+mWrt2E8+/grkHT9pTavJC+4jD692FN4SblFZl1tC+Lu2nYbq7mdLBk+yO2zF5ASmgd4U+/ExTig6HAUw1vtXKXyPdIHgesqcd28ymKe/OSeJysxgCyUBbhDts15g7D9PIu8BNjtE5bUy7S1EtDvULBNlcuElyCTeUF+LE94+Sg5LCY3oHz0ySJFJXPTeX//hutmblde/s5ByAYEiTjJbHStPYu7qp279RUgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NDkSBjzdwLwncyvm8sHTFzzk1yAZB0eg7D/tZMY80Hc=;
 b=gOqDy/ar9eQFBPRxC6y8OD1mAl8XmvLKxDMxB9jGwjrBmlzELhQKAXueo2eboM5rPFUZzB9gsOWxa2pd23hewPPCXMswpywR2OCAbjohzMGIWf/gOIXuGfkb01ZdBppHRrNdH3+E1xYSeWT16RaUlsp8Q3edJpC6CWIJ7PjkoU6gYbnufTjQmZAs3jsp0wQotU0KLx7xAGE8k53LGOaATlp2zVPon9pPjoqYSstMVCxWe8j2Fnb7/ga65k4trSR1TZScAnOJAPC8IjpUvfPSFFlCkxBksLtN8jzOLVgKDY2GzTRAzSNgdy1T84tgWT53rxf0088H01vrb0giqyf0tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NDkSBjzdwLwncyvm8sHTFzzk1yAZB0eg7D/tZMY80Hc=;
 b=uXsa2V6gd8yG6yvmo7V26nUHcc7y7uX1SlxfTiBV0HunkS7YbZDChME3h+trVckDgjYdzzGfY2wz2wqQZZRhgVnPg+3M3RgNIsoaNUs4Sqx6XCfhFQrEe9GrxZLBf/KW1nu1uM/FgiyIw0dlVzp1rMtTkfwtuwcx5ab+xnGAa1o=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by CO6PR10MB5652.namprd10.prod.outlook.com (2603:10b6:303:135::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 16:20:15 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::a02:2ac8:ee3e:682]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::a02:2ac8:ee3e:682%4]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 16:20:15 +0000
From:   Liam Howlett <liam.howlett@oracle.com>
To:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "maple-tree@lists.infradead.org" <maple-tree@lists.infradead.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Liam Howlett <liam.howlett@oracle.com>,
        Andrei Vagin <avagin@gmail.com>,
        "usama.anjum@collabora.com" <usama.anjum@collabora.com>,
        Mike Rapoport <rppt@kernel.org>
Subject: [PATCH v2 1/2] maple_tree: Fix mas_spanning_rebalance() on
 insufficient data
Thread-Topic: [PATCH v2 1/2] maple_tree: Fix mas_spanning_rebalance() on
 insufficient data
Thread-Index: AQHZE8XH6lqHEYgEdUO6kTGKmCGsZg==
Date:   Mon, 19 Dec 2022 16:20:15 +0000
Message-ID: <20221219161922.2708732-2-Liam.Howlett@oracle.com>
References: <20221219161922.2708732-1-Liam.Howlett@oracle.com>
In-Reply-To: <20221219161922.2708732-1-Liam.Howlett@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.35.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB3022:EE_|CO6PR10MB5652:EE_
x-ms-office365-filtering-correlation-id: c63082c4-a4e3-42b3-91b6-08dae1dce9a0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xmohHv6oIgSalX61wYej1j96LbFD/9Y5AfBCDZ9dMf0wRq5JfBJHcQCBZj8UcQU7hW4EBqLffENXJ+JukwAvZ426Ai2OzDSRkTqUF7GSNi5WLW7gRy1Jvl6KohDR33cSjZHMLmdb/+CMjyo4vhqtwUUGV+QRNfwXoN1PgVyMkV00V/1KQvmLemRhR9a77I9SxV5LqktJokqx/EyF1wKf48i0e5KO4Z8o19ldKKRCDx+vUfDUbo6xuvQ+LncUAuo4BCAyRd89KheuaxgPgGP4exuTYCYlhI9l85oB48syxCJ7FVEOkfqEHRcqtiWNJNMTdEkx/ZwVcU7jO5ZG+1xr5lMe6DjdlVGfaXStBcWCeFLxFnDg2/7mMG38eoR45Y8Ive27nv+RLli3+1Fefz8QyzU8Hps23I2nwa0lStZP2K9qkz1nvccuy99mwd8Oz9/u3kWmNfVwAWayOzFAjwVWkoh1Ki2ezmTsf6GgA4NR1csxMFr+ojKdQB4ybTj8w/XeTIlxTgN3qc7t0iUzp8XN+hYgTMECMatVFxnO9al+5Ue6sgHc0F7I/b0ldWX9FjkedawbsJ4HlDAmCA2fnuPF3iTXxQOhFF1rIyW9Br+UsRTfJpbP6uHzWI++U4uubS2xK35utXrhkLPZmePyD8DCROeeCuL1Bs8AwWD3G2vQb+y3CJtTlMDCgfJpU5RvKBN6BkmoUA1BkwdDSOy1PxRLDA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(39860400002)(346002)(366004)(451199015)(478600001)(6486002)(71200400001)(6506007)(86362001)(186003)(2616005)(6512007)(66556008)(26005)(316002)(66476007)(66946007)(66446008)(64756008)(91956017)(54906003)(76116006)(110136005)(36756003)(38100700002)(41300700001)(8676002)(4326008)(1076003)(83380400001)(2906002)(44832011)(122000001)(8936002)(38070700005)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?5BgBU7RqX2Pyw0S5Q6yZ2kSkrJA60p7dApbkIJAL+UNLEVS5rG2PiWKfHu?=
 =?iso-8859-1?Q?8xI6rDBg0W+Y3gfcwjQrSB/1scLsYuFwgQjbaNkGJ00HjF2TkMRIlTIEHN?=
 =?iso-8859-1?Q?veq2P5e9+CYgcwU4yhpcIK8Hmho7CFbZuBgJMRKWsih9ge7eF3lKc08zzF?=
 =?iso-8859-1?Q?qwwsJsINFREiHOqR0SDgOnMRPJ7Z6e4BxzleICZ+Z0iose+2iBZF0Q7fRF?=
 =?iso-8859-1?Q?LEEwPivdzhlE7LEDNLzHXPpC+g6anZZrwx8oSKEZsS5U7UHQh/dBYSee45?=
 =?iso-8859-1?Q?7uxyB5GsBfWIU1FAH1x1W6uV7r09Uw+HgZ+dJHzzNWE7nUn396xwWMxZf9?=
 =?iso-8859-1?Q?zqJBzd86u+OUnYkBkVdnBcop7WiLmTz4JPButH6oYY2hC97fy4k6bRQjdH?=
 =?iso-8859-1?Q?qiC0eaRFkfIWfZCZcI1GrWFBADbE/mug/+1GjYRB4xeito1b9u+Kh9pN/M?=
 =?iso-8859-1?Q?QoCR66M6lHF5k+16SeOwfo3/pZkua9tV9xntv+cyWPW1Lb1dQGDdMTwPKF?=
 =?iso-8859-1?Q?+r4VmXwnTabvpUd4+vTIzW6zlxUSDiNahQGXFoDaUqVDb5FY2oZxOvVi7n?=
 =?iso-8859-1?Q?oC5rGgU1pt6HtwmfZvxQdAbL7/uZOGY1+Cq8MlsiQfIsZFlEkWA7zOXTlA?=
 =?iso-8859-1?Q?ULeKqnEZsa++1GUY+RX9LMwnpHIGa05oj8XSYeLlwww6y55qnw+hVm/5Kj?=
 =?iso-8859-1?Q?gAFnbnb2NlNWZGmud1tjOf3shGziG+fEeSzZ3pT/H9TmJuArB8H+bCx3QH?=
 =?iso-8859-1?Q?G3ia4oPiomuJIlDbYVxS7Tqc6Kk5ygXL5cBYsmhXmsWix5EXHR3BOwercJ?=
 =?iso-8859-1?Q?4rll4ZIpun9zQv0PeqDb2GGUa3wlTmYGz8nBFpdq1T1pzN5bQSYq/DY/Ab?=
 =?iso-8859-1?Q?998PMVG0T77/N7cn0RBupvkDpJ+MP+VXl8ZQHqjxV4fJpeA95AxnIV6tqj?=
 =?iso-8859-1?Q?w9+LVkDiWqT78ruizZjltcgU8n0Z9JGQmPjoi7ZrbvAIpP4cbuXGKRsMEq?=
 =?iso-8859-1?Q?FUcm+HtP4nRvDlaVPRSQIODVKFh2ky28I2jP/L5VuL+MDnPr9QspJRCbfF?=
 =?iso-8859-1?Q?sOVQFgoV2AStpTFEBxPIyFs+9XKVJyNWj/04x6SLtzZ/CmUp366bU1A/07?=
 =?iso-8859-1?Q?4HgC1ZYjiZuNciZdqFdb/gLtcWP5mS2ZVx73SDbZe55d9sEdhuss3imgXP?=
 =?iso-8859-1?Q?Up4Hu6d57KyqnHHs7hqdSaYT1NanelxcXEAjskJFdIcfUbIpuvYMFX9T9t?=
 =?iso-8859-1?Q?XXc6ivFcUyGtsGlP+0s/zEtz6DmtKOi+5uqFkTXF7CsGZngu8niWnlpQkc?=
 =?iso-8859-1?Q?5lBdmIBm14fpH9lJEoerVRSIGjQBcwNm4GGTl7RqyG+eU+ILG/59KLN4GM?=
 =?iso-8859-1?Q?6DfQVwPdiJlVDtD1u4XcHR0ObtAaFwXTRmgJbsFRCSQ65YTn64Tl9C8wD+?=
 =?iso-8859-1?Q?JmAvtGTcFw5tIS4ieqrjmes+YdZ5FsfWJMwNwDecmoo2+eXTvP3CFstQhB?=
 =?iso-8859-1?Q?N85708rmC5zZxn5TAjnQmruLqwCDnNX//YUYCzrIOY0OKPbcwvWb4QXiX+?=
 =?iso-8859-1?Q?ea8aTcVqjRE6/BE/rVe+eS2I0CXUaLb8aU1gUQKUwueZzh1JRO4oeGB1mg?=
 =?iso-8859-1?Q?g6H2qKKiMBjZoc8KqrgRUgNR7zmLrwW2TDwlqc2b6Gvpk0+4wx8dfisw?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c63082c4-a4e3-42b3-91b6-08dae1dce9a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2022 16:20:15.4546
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vdF/VLuaBstPqaXGsBls5z1H8mzVcdTA/nU9+MxNXaRJ3arUCVpeZQL8UGeaa6e9YeKgOwgrfZL2wPUHQJwcEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5652
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 adultscore=0 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212190145
X-Proofpoint-ORIG-GUID: 6EFrQ6-1uamCumz_B3GdIzRsl8q_ndO2
X-Proofpoint-GUID: 6EFrQ6-1uamCumz_B3GdIzRsl8q_ndO2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Mike Rapoport contacted me off-list with a regression in running criu.
Periodic tests fail with an RCU stall during execution.  Although rare,
it is possible to hit this with other uses so this patch should be
backported to fix the regression.

An insufficient node was causing an out-of-bounds access on the node in
mas_leaf_max_gap().  The cause was the faulty detection of the new node
being a root node when overwriting many entries at the end of the tree.

Fix the detection of a new root and ensure there is sufficient data
prior to entering the spanning rebalance loop.

Cc: Andrei Vagin <avagin@gmail.com>
Cc: usama.anjum@collabora.com
CC: stable@vger.kernel.org
Reported-and-tested-by: Mike Rapoport <rppt@kernel.org>
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index fe3947b80069..26e2045d3cda 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -2994,7 +2994,9 @@ static int mas_spanning_rebalance(struct ma_state *ma=
s,
 	mast->free =3D &free;
 	mast->destroy =3D &destroy;
 	l_mas.node =3D r_mas.node =3D m_mas.node =3D MAS_NONE;
-	if (!(mast->orig_l->min && mast->orig_r->max =3D=3D ULONG_MAX) &&
+
+	/* Check if this is not root and has sufficient data.  */
+	if (((mast->orig_l->min !=3D 0) || (mast->orig_r->max !=3D ULONG_MAX)) &&
 	    unlikely(mast->bn->b_end <=3D mt_min_slots[mast->bn->type]))
 		mast_spanning_rebalance(mast);
=20
--=20
2.35.1
