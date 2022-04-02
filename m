Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90B6A4F008D
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 12:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347252AbiDBK3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 06:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239094AbiDBK3h (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 06:29:37 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E7E1AA059;
        Sat,  2 Apr 2022 03:27:45 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2321uneZ013045;
        Sat, 2 Apr 2022 10:27:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=OJHiOrVzOQHcjM9MuaDqOrx6aWEc8l2qZYk1hIKwVoo=;
 b=bVZAXQaf0Lj2tEzYUF8JwZeA5YexDZ2ws+6cwyv24F+7sn3+fxYtb7Q9szkKSNEVcw91
 TWDm05wNCoYYxb0dzqdSrVIi+6MIWU1TyNZArJde1b5BUS/zU7/7iNJIgSmc5SgVJlU7
 wZqakbqvdYUJdq+dfxy12rUMYZgs7vKpDFVf1PrBI+MMok48Tn830KdgrBHv5uGKkQ1M
 NJ3x2tOJiTQsFbiV7oGwxwDbwddIDXEkgC9am+COg1K6qAUSKnlNGdxo0ft9aNm+ACM5
 CqMvEx0xARbcUoGw31XhGN3InvWgtgS9Se3sh4D47E92tkg7Ip53iUk0EOJbH7lVVVmt Bg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6d92rcaj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:27:39 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 232AMFaH001681;
        Sat, 2 Apr 2022 10:27:38 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f6cx0y5mt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:27:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i2Bx/0gTVGcTIGN6I0mz+/g4pTb5PG4gqKJ+1hExPxmUVTHtZwMNUxvyx9FbTxC7XcZSg9XL7vEspel69bCS5qmXqAL/wcSKyfHWuyMeK6tMhlI6Ub6Fz9bL2Y4JA3xgXattT+0Vg0/D4x9SEaOKRuDbTIVgzwKeRf1m48ijeh+XVLygIXKz9DHnfbpSDfDceF6+L1z4QZJhiwlxLrdHjm4iCGRgFIkVgbmlzCfnET0OPG+lXqayvV0dfdveUody3deJYErwVJ9CIYqSB+kY10GjZk4KNQV7dauPHzifbH0sjY3epQJijf8ftqwOBpxsiJ1UdeMRfluMVRiIwdNkgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OJHiOrVzOQHcjM9MuaDqOrx6aWEc8l2qZYk1hIKwVoo=;
 b=fqoY4J8HtKnP1iNDtin19dBzuKKz3oFw+8pNzjYelujn5CAD0BlM4TMYL23aBYrRHYaK3Tzo41zHjAT+8CcJUh6kb03cWpdL8F7OA5AX3WcE4bi/AfTq3b7UIu+5RohggBzqtat3VWzZ0virWlRl2lSvsWtfVPUl+NskfFnjWoanaYy6fiu4jDgmphQZ0QGDvTc/mk3PpexHhFivmBI1gy4Ic4RJgF7V/l+d5Cfcjt2od1b5sboWHY0bcWX+q5eMIoTFrudBqNmmA/kFrurgL9tSpvzM/PQDn3hZpbAkN15gFX1TsLDFb2ErfJ6DsFjIOhaPX+J5UeHP7gAgZef/rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OJHiOrVzOQHcjM9MuaDqOrx6aWEc8l2qZYk1hIKwVoo=;
 b=Hx3eR59e8/aIXyfwEnzkmbETTedCEf3hrZX0/Z9XUnZwXbPsYv7OxM07HMeYddhrZabULNtCoS95n7XESlw1IvBuitKFKF9tzAhl+/S5s6jRVOnwJTlokQwXDI1zAkEJbikWPLIQnaKlrTKnpeb+UYx4vhQJ9R1F6a6pqI5I5e0=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by DM6PR10MB3049.namprd10.prod.outlook.com (2603:10b6:5:6f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Sat, 2 Apr
 2022 10:27:36 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e%6]) with mapi id 15.20.5123.016; Sat, 2 Apr 2022
 10:27:36 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 11/17 stable-5.15.y] iomap: Support partial direct I/O on user copy failures
Date:   Sat,  2 Apr 2022 18:25:48 +0800
Message-Id: <f8669e9adb9914c9b659874d439eb857535a20fb.1648636044.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1648636044.git.anand.jain@oracle.com>
References: <cover.1648636044.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0091.apcprd02.prod.outlook.com
 (2603:1096:4:90::31) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60999a49-b02c-4fe3-8345-08da149367df
X-MS-TrafficTypeDiagnostic: DM6PR10MB3049:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3049FD817EA914FF71D5F54BE5E39@DM6PR10MB3049.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: otSXZ6u3C8i0wI9XoWMGhmWX8X002PBtBNpMqSwcF6ZalbCzbGHFGVQ7Vlyg5sdVxYZYRU9IQ/tFWQwziSXINmAjHm0puyf0rlcflig3ugAN3rCgBu+ScshLr2P5Y1ZQF5BJkcylGULA14TEMlcXggJQ7xpKf2KMBZsWtAwL9cpT5q3zqZczNTQZte+4CyzLLWozJXMCykg1NmaHdr5xY2hMjs8WhduKoSjXXZyjMF2xk0AU+QZCudCUfnUhYlGDk385oKXtVkNLyDyYM04n3E2WZtFS1aJqoiERyCliZyEhAX7lQpVk2xxlr8csAy4CW8mwDs7QSioTYfXT3/RUcgaGOffhxl0DGlRLnva+BnRHvEUv17Mwk0Cx3c9CnKOdg8xEDZT+jSN9Pw47cRjaqTIuJrQb/d1Rq3hl3c5H7piOyYpo5hfHnWvUyOCra77ZhzmHWA6b77kt2jCYlBXoBJTj/QFkU1rFTfXdeXXVqlphroW9zzLTBQ+4kImnuwiMJx8wOiUdu1GNBs0LhtpU7jMOLQQ+PhxliXzejprm5+nfvRzRrJuHIO8cD+UKNk/GSTCGP6BN8nuOhErqihsR4ownQaqtj5/6SCHyFQgPG6oZNryuGevySwnaBOYze9+uB/WrBa6AY6Djrf9qfiWrew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(38100700002)(83380400001)(316002)(508600001)(6512007)(36756003)(86362001)(26005)(6486002)(44832011)(66476007)(6506007)(54906003)(2616005)(6666004)(4326008)(186003)(6916009)(66946007)(107886003)(66556008)(5660300002)(8676002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?61A5Yf2cUMjft0RxWI+Uq2XXEbZBREh1rrVqr15ahwGNdYSEoqSSR5MB+XhO?=
 =?us-ascii?Q?pNFBNMVd30sjyAH0OtebAsQGcvaFEic9zkhCoyu3lMXyuascuMHouoqBg4m9?=
 =?us-ascii?Q?VnOEAgHh17dh+5v2fGxKY7zZhkCCZLGlfqsmnFazy3fqbmewjnrwuK3Qv5Zd?=
 =?us-ascii?Q?YfymPvx7NbIdv6Lmp/hvr17/69bZnSPThxzkxCAHjIA2tkRsN27aN4R8FfO/?=
 =?us-ascii?Q?3frWi6uTmxRsEc/ICDpDm+lfmOVhvCj9GeKfUiGP5gWGNPCqaq1PrJViAUUA?=
 =?us-ascii?Q?ucgFU7KCRtvjkN2IgV2hO3C3QBaUzShuzQmMJTz2tP2i1/Do5T+7KNoCFt5A?=
 =?us-ascii?Q?KHShwN3DFDhAZcltSv/I+saflg4KB0GRQpQRV2gCAdD4069+lDUZve8swT6E?=
 =?us-ascii?Q?NQ82TfJv+YF7M7kYi7Nr+1Wv293HBF8DmKsLuEiNJAWKaVRhmodlgEqrAl0p?=
 =?us-ascii?Q?cWTfVPUsdEYOF7wvd7cJRJjkXXX01YMF2skbroBViu7IFO7GQR82bAgupd9E?=
 =?us-ascii?Q?c1TfQeZvji52wQcCsC5gtorjxJychGyI4BIylkKUPpVSL9+nx3Tjda+Eb2hF?=
 =?us-ascii?Q?W2rOlNd8TJM2Gi5Lf+avr/Rmnyya4mvmGhNDRjPfa/9TV5/U70YUiKkNSLqj?=
 =?us-ascii?Q?gu1EJAMytm9RSK/uYQFqMpZIyRLfgCYyL/wJlXn31H90rRYq5NDmnRQFb1kb?=
 =?us-ascii?Q?NAKyv+XDBUHaU1qIRRojNwowrghicE64DJtwQjmgIRA+wiAJodaAXBLixZB+?=
 =?us-ascii?Q?HENgLdGObaitdzH7svLeYYzjdk15a8fbwvbrWTA4kL/2zseZcGqr2C6sHMGU?=
 =?us-ascii?Q?oYO7RCiDW1x3l4S7Cgwoy7wT0AD/GO/8xmh73hyybVUimVP1m6zMgaF54bVU?=
 =?us-ascii?Q?PPhw8btbW+EqXo5bk50QplEiYyPAJP25Qapg3AGSHFvUmxicyLap7zb7KafP?=
 =?us-ascii?Q?Q/ePbGpRYqWnEdKnKgXE+iaMAyIF5avufplh6lO8ZfiIC9R8FDaJQp+i6LgL?=
 =?us-ascii?Q?uHCcRhinIPC9BUAbdOJJs3RfyOYuOnHW5cnY8x/heqaaiee46mK1smduj8Fv?=
 =?us-ascii?Q?EIygEY+KhBhGOvsaEsFyRnkGYBktx84AkMHO1O9qCBPbIzIeJkcHwPk/+4+9?=
 =?us-ascii?Q?JevK9q+grx20R+XcTUgdqCfOIVSXdz1H5jwDCxt6/lcPfD4Ufr9n8FkVU7+f?=
 =?us-ascii?Q?VVxoaVyPFgtzRtRFSBcxh3EB/Z/N3daz8Xf60LYOC45Hcf+hO1PCWw+feLgW?=
 =?us-ascii?Q?STnf4bannSft7hsURKxYSfGVjT3toFq1djBbZG/vCjUWFHbUPxr8VC4we/kj?=
 =?us-ascii?Q?Sc8N6TwNcWxfGTAjPjGiN4VXOuRsdH7Me2+kxuRyTK/DbBel+CJkmZ5/U0h9?=
 =?us-ascii?Q?bHWc+rMKQPajqPEmo7042PYZ6NzPcTiIsp7mXCBtdUHRCxIgE5Off27rMCvI?=
 =?us-ascii?Q?6XHcQq69Ag8RUfj9vXJwG1tXCoR8FsvNDp0KX8Rm6HqSN2qop55g9sRqqwvF?=
 =?us-ascii?Q?QOTBvHGwzkFA/ZBqxE4Pu1tqJlE6QsgKPWNByReCpJ6wXA+nEitRoixhxGkq?=
 =?us-ascii?Q?3DoE+oIDWURK3rjgev8vh6uBc9p1XPvPlG1geVM7O4967uXgIk53elTzWxCa?=
 =?us-ascii?Q?be6/DBdgqe2bNoUhwQKZVxN/lLWykiodq/+FwLoiCpuOaf8NS70dlp5oHy0N?=
 =?us-ascii?Q?VTUyt4/pGFPORoRQpXuC4XSfQCkFR730iGcO/+E0KifrTPOOxW6W/gxyKVV8?=
 =?us-ascii?Q?/jN15K3hVKwPeRLI4XilXz7gv3ST/7s=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60999a49-b02c-4fe3-8345-08da149367df
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2022 10:27:36.2733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m3vw4tjBxiP+pvR47un2cuG0mvi26a1sZ/aolA5IP7+j/WWzyUXZJnXW636AoPVuL4SdmybDIYFFYDXsL+mqtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3049
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-02_03:2022-03-30,2022-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204020064
X-Proofpoint-ORIG-GUID: yWDjXIo00gy-vF37pXH-f-z5CG3SFEvH
X-Proofpoint-GUID: yWDjXIo00gy-vF37pXH-f-z5CG3SFEvH
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 97308f8b0d867e9ef59528cd97f0db55ffdf5651 upstream

In iomap_dio_rw, when iomap_apply returns an -EFAULT error and the
IOMAP_DIO_PARTIAL flag is set, complete the request synchronously and
return a partial result.  This allows the caller to deal with the page
fault and retry the remainder of the request.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/iomap/direct-io.c  | 6 ++++++
 include/linux/iomap.h | 7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index a2a368e824c0..a434fb7887b2 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -581,6 +581,12 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (iov_iter_rw(iter) == READ && iomi.pos >= dio->i_size)
 		iov_iter_revert(iter, iomi.pos - dio->i_size);
 
+	if (ret == -EFAULT && dio->size && (dio_flags & IOMAP_DIO_PARTIAL)) {
+		if (!(iocb->ki_flags & IOCB_NOWAIT))
+			wait_for_completion = true;
+		ret = 0;
+	}
+
 	/* magic error code to fall back to buffered I/O */
 	if (ret == -ENOTBLK) {
 		wait_for_completion = true;
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 24f8489583ca..2a213b0d1e1f 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -330,6 +330,13 @@ struct iomap_dio_ops {
   */
 #define IOMAP_DIO_OVERWRITE_ONLY	(1 << 1)
 
+/*
+ * When a page fault occurs, return a partial synchronous result and allow
+ * the caller to retry the rest of the operation after dealing with the page
+ * fault.
+ */
+#define IOMAP_DIO_PARTIAL		(1 << 2)
+
 ssize_t iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		const struct iomap_ops *ops, const struct iomap_dio_ops *dops,
 		unsigned int dio_flags);
-- 
2.33.1

