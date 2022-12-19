Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A697651034
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 17:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbiLSQUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 11:20:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232081AbiLSQUf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 11:20:35 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A3C133;
        Mon, 19 Dec 2022 08:20:34 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJFxFff028286;
        Mon, 19 Dec 2022 16:20:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=KDQIl8DincmtwTIBP9/v7nsnc6e5ZzQYo8DVqjh961k=;
 b=LU4BxFZ8LHD8+ueY91Wo0ZBBfoJpCTW2EEOJkpMi+vKf7LkjGpLMNFUve4HSSKhCin43
 ENBhqMlj4kjTo2fceiLj2LfjfPFNxH7OrEcqhS3bN5/3utDXNyRpXxBCVV+uGmzq2DJL
 1wKprXEHzM1cTbKDyDfKWxd4AVc3kdlDDqJoHQRsY7WP9Ib/nL7I0LB66ZUukjhII2Lt
 n6KdJrc8j/rfkWYGrNQp1iq95M5eb5Ekkbz1+b8p5fAGUUZb9S8T8REjscryDfozn5qz
 Sc/MiTaiwmMGbZSaqY0pio3gCIAeQpErpIxL507b3d3CIbUqiXcM26qdSNJVsyd4WMsm OA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tqu8us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Dec 2022 16:20:19 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BJG15Pf024209;
        Mon, 19 Dec 2022 16:20:18 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mh473yj2x-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Dec 2022 16:20:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ew19fC2X0YBbvIzpBA41n/Alh60cn3Sp6Qkj0HBgnTCtTsolZDABBIOPbIILWUSnvUiX5xEoerRh64D51d8mxiBYbzrz/oxQNEf3ybDXJogCMCmSwt4+ZgyWr25KBNNnQHzSdXCFlGvNr7SUZDdQaruOQXbxTTViEq2WDdV0mCyQMPhyj38nBdYwO03hbHhN33dEpT9NwMTMCyarz6I8NFX5OJu/T7gKuTdi4IUJTbmIcZ0dJoaZGUAr9D31EulcTw7FBMofdwnp6DELr7lkz5V3sDJDiYx39ihWLwFzL2JPvuGEEga0TQ0OPM8DBG342dfZIUH1T/y91/eHrGNqUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KDQIl8DincmtwTIBP9/v7nsnc6e5ZzQYo8DVqjh961k=;
 b=ja3xV/H86MiIGiy0B5m+DdfSPvo7mKc4MDdyoPQalC06kB7IN3zFkH8OH/ZR70GaV3fTs6r4a3/PNuL/ZYNTkbb7q7AzWqVvS16M3WPyUooeuRoUp2Edvq0Gm2ddug6MSzePqRVCOoRUPbtW4nh3yEVBJ5Vg2VSnGlnabUiPHMd2/9aD/EUnitqqNGVd2D/1fLjphnSl17LypL0d7pLMnLc9GY5ko0K7n+rT65MsV/Iakl/XD8H8LGedCio6cQQLQ8pQzGfZGVAdm6242ppcl44uysuQlXwn6kesvM0PrtdL7tR2I/UIUvTYdbAtHSuLYNgexjQosiN7RFvo+jdhOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KDQIl8DincmtwTIBP9/v7nsnc6e5ZzQYo8DVqjh961k=;
 b=A+JSMOEJshEY3+Bz2z8uBU/xo+MNSRj+eRgUGRTmcji+7Gzrn4fQuHIhR6ndopNm1lz3hBqBbCxxuu/XIDY1uzJmcEiNrr9Hy6SJ2RLZtaJUSs0Ji6cNhUUkALs7Nfkhldo3DzNHrqpqPhbS+vCCKF1/MRo0qsEdgXJTdtQ2lao=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by CO6PR10MB5652.namprd10.prod.outlook.com (2603:10b6:303:135::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 16:20:16 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::a02:2ac8:ee3e:682]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::a02:2ac8:ee3e:682%4]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 16:20:16 +0000
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
Subject: [PATCH v2 2/2] test_maple_tree: Add test for mas_spanning_rebalance()
 on insufficient data
Thread-Topic: [PATCH v2 2/2] test_maple_tree: Add test for
 mas_spanning_rebalance() on insufficient data
Thread-Index: AQHZE8XHNNHGYHGPtUakkZXyDajcKw==
Date:   Mon, 19 Dec 2022 16:20:15 +0000
Message-ID: <20221219161922.2708732-3-Liam.Howlett@oracle.com>
References: <20221219161922.2708732-1-Liam.Howlett@oracle.com>
In-Reply-To: <20221219161922.2708732-1-Liam.Howlett@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.35.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB3022:EE_|CO6PR10MB5652:EE_
x-ms-office365-filtering-correlation-id: f1fc2dec-8cdd-4fd4-64e0-08dae1dce9f6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QtVHzxWqJj+rVCaXOCKEQoca/nn7dMlLs6D0sn9mzjSSPr4Z43g6DHEUkvACWAlqBZzARjB2ot9l7xjMt71rv4gKP+wB5vi846pgu/fXrAyhJ5aWJfBybQ8KZHr1Pp3KobCt9eoynCHWNUspx6c0auYmGVAO7C87rk577VN4NlWekDi2uofRbTYlP4JuXLIkWoVmebe7b0eJ5zKAaB2xLdSJPPMG/88JgPMwhbZuJV/2HuPpLo41x1e6zRzj/ZMb86ZQOYMrmHJzWPxFKphbSXtP1Z3WF13tsEndsOuxUWt2/BWYoQYHSeahmcmGXDWx9AXSF2eUM0K0LtoDDueZqMZc/ZQB2vPFy0mpRsyg3jFuA5OzDfT3DK07HRSTjAfwk4ZTvoNg+13jJl3/k/KXP1Klkq58tuVPBm6INM9lHWjfvZ+3XH4TdqLQXbpB4Ky0vTU6uKmWkQH8Sgiukci/WFHuSh2Q8NyZvDn3AW6gmHqrss/1hp7RgpoQqSItGUF+whIlo9F8xLlQfxKAxx46bdmonqxOAe2f494fNaKkKPSHe5AvAKdzk+zNtcrUGJYutycZUH6lIiSdoVmcC59k5uAYUtUulHlqnKxJCdAQGc7J5qNXxuh2MCLYwe50+/Xlj6mQeEVJtJl2dqFYNAEhGlZVDtZpCj4DAJ0YXMQYPJggOAZ4yw8tYZ90P/QJV2qS6c+OHJBgvtlg6BLWYE3XUA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(39860400002)(346002)(366004)(451199015)(478600001)(6486002)(71200400001)(6506007)(86362001)(186003)(2616005)(6512007)(66556008)(26005)(316002)(66476007)(66946007)(66446008)(64756008)(91956017)(54906003)(76116006)(110136005)(36756003)(38100700002)(41300700001)(8676002)(4326008)(1076003)(83380400001)(2906002)(44832011)(122000001)(8936002)(38070700005)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?7pocQWLZas64FzjybfWHJzbpYoYSnF0Si2b9G990P0fFMRsxjXDksw05Zm?=
 =?iso-8859-1?Q?NVfEyTzhmRKsDc7+JG0Qt7rJVHi5IWtOFLqbT7dIx7ubMFSnAptT633lN1?=
 =?iso-8859-1?Q?IqOApbp5H02IyMUYLs5IUJvwhmUw0NNuv8LybKduYgAUhId089D5s5EWWz?=
 =?iso-8859-1?Q?zfGfXviKM5uwo25t9aE7Zs795KjmhnxKkFUqkLKGkqRGkRo0sS9DWZ5STA?=
 =?iso-8859-1?Q?x8ARL+HPd+k/r0ezarSBoTGnhgdHkYwr4ZnAFklDiHkfnATdYr9v6bVDK2?=
 =?iso-8859-1?Q?By07Ed+brVFhYp2AAWe1K4JJl3vnBQE0QTzCu/0Eu+VRnuKKx5GOUbxayr?=
 =?iso-8859-1?Q?yQfyP/xoLxeMayKSF/btISijGZSVe4lm1BAG80c7pw1jmlmJqp37ELgIl9?=
 =?iso-8859-1?Q?fOjPLL7CmxUcgyCFGNfKfdjStq8V47LsO8DbBUB01xCOebUNOYGCsykNgn?=
 =?iso-8859-1?Q?1dfIwt5WdWa/RGlRGH/6A5obDNmQsfWF2eF2mytZlApzTbNDywO+3Y8Zk+?=
 =?iso-8859-1?Q?NguR2CAa/MUmWleP0sbe1coee3lsgXA8cSLjRoroyp98ZKu7PiRp39C0IC?=
 =?iso-8859-1?Q?JZZSl639gbJxiPNyEC99Jkh+hwFGbXKJT6MGaG9kHO/KyIB80FcW6Lb1k0?=
 =?iso-8859-1?Q?XouLKayzVjQhBJnVMbNvz/lDnJ486C+pcHwkK2v9h1KNg6yTfHr74K9kAz?=
 =?iso-8859-1?Q?rVdvd1waU4+VGyzKR1rnas8XSp4wAO7fKn3RkvdTygWhZ8Zu7Qx20Y+/gz?=
 =?iso-8859-1?Q?vic/7q76vJUS8LV1A/CmwGvPqylh6pBDMmR5d5NaOWMAz2qhKohZqS/SOL?=
 =?iso-8859-1?Q?GFYCQgTePsynJKkbfGN45GXAFjKLwt4oG/tYA+bTp/QhhjbmkTR+wYDivW?=
 =?iso-8859-1?Q?xdm+Dv8yBNI8uxKkZYPdGitJqMEWPN9LaQr6fORk7aVazmU1QBZNE0I0jp?=
 =?iso-8859-1?Q?+fRSB8IcDFrKdorAuEIbQYXUkcD2r3f1nWhIFVJLj29S56+vJubSVnedYK?=
 =?iso-8859-1?Q?XW4szkcqCBHD61ONmxBVc6jUtiZQ3iUV2KRo8O1zHh1NemeaeF4/MVCeAu?=
 =?iso-8859-1?Q?tt6qmosV37aKhGiTHsMzDnOImz85hKd9hwo9SzZPib6nec3zPxdeGic4v9?=
 =?iso-8859-1?Q?ZYvQRtIj0iKko/qTxOGerPHFoNXa/Z8iOfyqJCs10/OLmHuZDQKyv24cni?=
 =?iso-8859-1?Q?PCqQfierynWA8C1CLYCB3eVMdk+T4ckXuDTbFeapJHXrcyKMXs2WOAZJou?=
 =?iso-8859-1?Q?2kSgU+rfhTit+OUQBvHIyPCiie5SIuEGO8HxgYfu6cZwxa0MqCFze2vdov?=
 =?iso-8859-1?Q?N7d8+Gas4/SwwF6/ZkkII+lfiDhCjfcdiSXeA5KeVKuJUqp+8LCzD2+W37?=
 =?iso-8859-1?Q?f/jj94hZLfh9R/lxa0F5pDcc4lRIF8Uo5Wpu1Nnm6xB3kRoOh3xkV1J0Ux?=
 =?iso-8859-1?Q?TG+CApj1si+Xphx9vLUeSl/8fFHbWthZG3QQue6jgLHSoepRDcVcBQX8IR?=
 =?iso-8859-1?Q?IgPVVf0uSE/5TM5ujs5W2qEvkcbwBhqlUDL0oVF9uAspkBnmJDIfHjGbH1?=
 =?iso-8859-1?Q?eWg6QzuMXmdUJVw8ZYnmrcvdtQ8bXhCimkwxCcBYm6h7C4dJW5Jdt+Lr36?=
 =?iso-8859-1?Q?4pbS5o9D64NB1r3X4QDweRZgeRy6MJh65RINt1AqJst1SXp85WeSVSSg?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1fc2dec-8cdd-4fd4-64e0-08dae1dce9f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2022 16:20:15.7515
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4s8I4Ik6LGOKNIT499qrlmXlViFyy4SfbP572NbCcU7zF+ZTUmkGvq1Y30B0e6zNmW5LUZThWE/0VWFHKmbegQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5652
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 adultscore=0 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212190145
X-Proofpoint-GUID: nFGKeV6DE16SS2IT3A5T5eleMSh5J1Jl
X-Proofpoint-ORIG-GUID: nFGKeV6DE16SS2IT3A5T5eleMSh5J1Jl
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add a test to the maple tree test suite for the spanning rebalance
insufficient node issue does not go undetected again.

Cc: Andrei Vagin <avagin@gmail.com>
Cc: usama.anjum@collabora.com
CC: stable@vger.kernel.org
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/test_maple_tree.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/lib/test_maple_tree.c b/lib/test_maple_tree.c
index f425f169ef08..497fc93ccf9e 100644
--- a/lib/test_maple_tree.c
+++ b/lib/test_maple_tree.c
@@ -2498,6 +2498,25 @@ static noinline void check_dup(struct maple_tree *mt=
)
 	}
 }
=20
+static noinline void check_bnode_min_spanning(struct maple_tree *mt)
+{
+	int i =3D 50;
+	MA_STATE(mas, mt, 0, 0);
+
+	mt_set_non_kernel(9999);
+	mas_lock(&mas);
+	do {
+		mas_set_range(&mas, i*10, i*10+9);
+		mas_store(&mas, check_bnode_min_spanning);
+	} while (i--);
+
+	mas_set_range(&mas, 240, 509);
+	mas_store(&mas, NULL);
+	mas_unlock(&mas);
+	mas_destroy(&mas);
+	mt_set_non_kernel(0);
+}
+
 static DEFINE_MTREE(tree);
 static int maple_tree_seed(void)
 {
@@ -2742,6 +2761,10 @@ static int maple_tree_seed(void)
 	check_dup(&tree);
 	mtree_destroy(&tree);
=20
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
+	check_bnode_min_spanning(&tree);
+	mtree_destroy(&tree);
+
 #if defined(BENCH)
 skip:
 #endif
--=20
2.35.1
