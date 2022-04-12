Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A945F4FCECD
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 07:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347790AbiDLFTi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 01:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345584AbiDLFTh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 01:19:37 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6583466D;
        Mon, 11 Apr 2022 22:17:21 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23C2C9aA018415;
        Tue, 12 Apr 2022 05:17:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=dXLgYHGX2bcuJ1qIa1hHlApYOsaF6wp685Y8tY54+6o=;
 b=WXhXvzcX41+esKCCmDlvPkqbjz45fkfRQc/PMvw7gfkv2Q1AWQqZNv1tNGfW7afFG1Ms
 O9EPE0ZfKwG9h45o8FvfKiYr+3gaiZnEiymu2RD3/vROlxZrXUoy7CIdyY44y8nLbwVk
 gbAGh9EhfeSSLvXR8W2Wza9noEB/amPUKXR6RI597K5VxLW9atRGg2vHdl925NvhVOz7
 QDZbvzxK756RkDmEfZsWE7E2c4kZ6RQO0awassSIZbT/jqCsN5spyJhULGedDC6ZuEOA
 BakpaUr5z/Z1/+owerwnZm5wA5IkxptAK8edKvoH06CxMIpP6MY4Cg0QqOObcknq4NIO 8w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0r1dmky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:17:19 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23C5GD6Z034260;
        Tue, 12 Apr 2022 05:17:17 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fcg9h022d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:17:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IiY+umClL20cms85X3Y1KWfX+91G7vkHSQnL4OUDRW3N5jF6gZAwKhL68z1Y3pz/aIuUAyS0SQknCHLoCc+FoRYHBp+amisOr8RkimWmrJPKfoVxT/8bFVuh+J3KwK4m5lAHHUgLfXUjGzjFbjz/wozGa+q/CBKHsVnWdQnQ/E4miqlpZGzdR+kpQaOYBlhX5T03kkI4Lq39Ix8KyGfJeMJfI6VbslAtmvSoxu+wAPcpMR8+BEGBWBFYnPWFzpQcOQzlLuffLBj2LrB2YR8nbsyJPiZrlml1P6WDgigpuCVaZXpMAgP66HaTRwhdc4BYh1m6Cpz+GMV3v94N2oiI0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dXLgYHGX2bcuJ1qIa1hHlApYOsaF6wp685Y8tY54+6o=;
 b=nj3BHCGbScJIvXr/3omFBS9/a6Aho771aCysHW1kBvZBTVwWNc/rHOooJ9wqNOqOyG4/yGIkFN2aPYzjC9BxLLSZEqwZvsbHv1p2fbotOb15VnBUBCf3Ie802eq8BJN83dV3VsFZbWICATybMgm3hlzj1t8K6LDCil3pSa8IrJ5LKvuZBSD3jyOLTBkHsZ24stTM+KeaQwsfpOaLY3Vc73VSXO47Jvam5KuDKqDxOqX+JNg1cnPVHFxrcCe/ZzreZXvK8dc4893ycTjcycLm8DLPxTqAkSo5+gal5RMTi+turF0Pa6VQTb6ExUmum0+32IylazU9Hnozaqf/Ra8ujA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dXLgYHGX2bcuJ1qIa1hHlApYOsaF6wp685Y8tY54+6o=;
 b=N1LmCN5CyvSOGpxXTgi2n5yaGfO7fFs5LHJ5k62NN5OSpeC/AVeLpsCIsrTj9icFyFfsnfAzFy3FRp47/OlK7IZQEsmXw+bxdCrtPOjKf6aZGUAuf77g3yWFtVcrZNuYaQK1t3bCV5VgQA3IE6BHuEIxS6dJPjySKD5ncpl0t5k=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by BN8PR10MB3329.namprd10.prod.outlook.com (2603:10b6:408:cd::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 05:17:15 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 05:17:15 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v2 14/18 stable-5.15.y] gfs2: Fix mmap + page fault deadlocks for direct I/O
Date:   Tue, 12 Apr 2022 13:15:11 +0800
Message-Id: <8875032d06bd17f6bcccbc1c5197d122ae1563ae.1649733186.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649733186.git.anand.jain@oracle.com>
References: <cover.1649733186.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR06CA0039.apcprd06.prod.outlook.com
 (2603:1096:404:2e::27) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1622a63f-b137-48ca-d09e-08da1c43b514
X-MS-TrafficTypeDiagnostic: BN8PR10MB3329:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3329C223295FDA29156CAD5AE5ED9@BN8PR10MB3329.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VDpqfnSFUG2JbpNXWYkylZeYq1BGKHK3CjvESuPDDn+xaTmHc8E4RdgL/MHg+8EeapeOehOIPvdHI+73+AQsE2hpZXV5dint10jYkWSKD9jD9WaNw0to8ThydhBzIXB+XKrBenHyn4dChtNVPQ/nqt0WOwus1JrsSX9ULjBQWbGFih6c0GbYFKJmomWRbOAgWbXxj3Ob204sQyh0m2VYI/dr3Jv6J81X9Xvm7/R+4jibtwyWEtawaom4ltEylk2TpN1PICqbf+do/UgyqSdMQQYSpidfkUnfb69Uiv/NxZE0dj8czrdyArwUmoUJXQTfkbfg/seBSUlTDGUyrvbT2yODegpPyThSIupXgndUFoWyYWW4rDdTreXHpgXaZrxco19NwIhHM2P4UaAmQAGSAm2lF5kL38hm5njOLl/RaHuK6q1wWjJY9wNXyGibIMCOZPh/piN3ohoVg9iGy9n6K/1OYTq08tsQO51XcCIza5sJ45NRgD6h2b39FOpTRFPunZ1M63BjdBKlSbsCvudxkxdNiE0MSqYAiSii1sW4qeOr+MOFLO5geb7ItpXR9pJsSjSQzIIxcBzg07nuaKIYy63YMO6eFItwiKPByFO0meIoNscegcKEzxdnM4Yi6qEcB9RspiswJjVyeepg85zqMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6506007)(86362001)(38100700002)(54906003)(6916009)(316002)(6486002)(508600001)(6512007)(2906002)(6666004)(5660300002)(107886003)(2616005)(83380400001)(8676002)(66476007)(186003)(66946007)(66556008)(44832011)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mVQguToqDsYkog8xk7TJB71/olm+aNxAi7FhS7BVnJzDylUV6v/1E+YPVEi8?=
 =?us-ascii?Q?/rx94luXMZ9J83Uc+5bqOmLSIkocWuSGm60l0jDAMukkCULP2ZaPw37xFRXB?=
 =?us-ascii?Q?HIiEBt+oHAJYMw4P8aLBN7E340OJ5rEqO3D4Cp0wjXBV1NQuZ/ukcusguanm?=
 =?us-ascii?Q?HghH+/kJK2Mikbo+aj/P6lmymsEQB8NssHxQ/dgSkjnKWmdTkRdVzrOt4dpO?=
 =?us-ascii?Q?HbS17WJ59SoxWyd1O0dzbWKc9JhOUFqmwKL+zdes8Pjmw9nAiWHVogj97G+9?=
 =?us-ascii?Q?antClkJA0GWVQoCQsBUCAGjlPWqWE11cUddNl1xeTy4zJucvRuAYR0WfjAq0?=
 =?us-ascii?Q?LG8cy3l8r5bUe/R2lq1ylLeRUmVQjkvR8SsMy8oeqecRM23UlOkbiP0G0P4b?=
 =?us-ascii?Q?lylY28pMN9IgzholjxVEsEC24CjiLF8auoboaCibUUagz+DxkBWi6AT3PeXb?=
 =?us-ascii?Q?+Xivkno5HFkKZwI1DwV0ZX9iB3X/KOGb25spdV6v3QPepqFVrprIxRwWCnEa?=
 =?us-ascii?Q?z8xVs24hk8AUHzs/0bbNuf6/V862xapwMScz+CBnXdtzCvVDu2XXs/ZQDxb5?=
 =?us-ascii?Q?0WFaa+vz2yY8FAhuSo28bS9sBqGSBfeBbI8iiIL0GK8TD62ATJp/ix9sSiVO?=
 =?us-ascii?Q?ClqI7gCuskroIRUZVW3DPv2ZTvKmGfSsCn609mULBsInz74vQNqEMW4NKGMi?=
 =?us-ascii?Q?o7JJ/SlWKIRkY+Wi8quHMPcEwtRXAWW2UZq2JFl9hrdYTre+Iquzj6Cod2LA?=
 =?us-ascii?Q?9qNOKUdw2wrePdeHwPQwphAp2eTcDR/mdfj5CROxmYbkiRwcDMxIuqgKRXYt?=
 =?us-ascii?Q?XQ6Y2FKIs5DjrOfAYwagmd2iFpNveFRmjU/7SnEl2Tjm5QXMw5E0izQfCCi0?=
 =?us-ascii?Q?1aGXXcc0Xl2JVv4utM/rDZgxxHCo7jhahxYx6U98P75hoFf9qNNVxllIg71W?=
 =?us-ascii?Q?NrIM1T8Mj95fc8vLYEoNX6HusQVL7PyfffCtra1OEm1F4C+G4IFEtG3kO7Br?=
 =?us-ascii?Q?mZZv+hcXUnPjc4XtM/vItFcKrxiVCdIrvnh/B+47nEAyB19l/vDTdpbKbpQA?=
 =?us-ascii?Q?Yi9Ftuw2OApBHy+7AjsYuCuS+YaBU6gVxFXww4U6/DV58XvRdr46dXxMSpnn?=
 =?us-ascii?Q?RBv34/ooqhW+G6YZ6wxUP1BDXN90gvnZfIqjEbTgRc/aCGPhnxyg0n5o9cFu?=
 =?us-ascii?Q?T7bmgsM7Ij3SwGwj/dwvaA1gTf9XWJSzJ/qJPR32CIIJLIh3kMzcE2htGqZ5?=
 =?us-ascii?Q?At5S1FpPibv7OxTIv/JVEsIeoSOlfIcjZ77v6L4IFcU4f2O7EoF4hkuAQ72H?=
 =?us-ascii?Q?OSKbKZ/yrvR0ZtEDT5pq2GeAOa9tx9yzEtNBvPW9ZpUdLhkU3kRUTwBJod2o?=
 =?us-ascii?Q?0wmLbmFL3r24r6DAfzF8zApLJOED5r8aMsT1MJ0ycNTqd5FFlDuSQVeFSy1i?=
 =?us-ascii?Q?lFTPb9OONgzAKpHbI1RaXi2slGYAJoFDYd/A/Je2rJEY7U1NHfFY6k3EDxrf?=
 =?us-ascii?Q?LlwJxTJL7SwGRzvUSNmsiSn6JT5Vyt7wAwGcPXNRfCQPqV5FTjTko7pFpzVz?=
 =?us-ascii?Q?ClXEQiDfa+V8sLMfrDwdXGTjppPUAZllNDmROl1BiuZseojJJ74JVq1eZZ8B?=
 =?us-ascii?Q?A+t4MbiB9IY59YvkS/EuYUKmqmrIL9iPx7aM5BRFdbpb7FQvsJhEWVQslmTe?=
 =?us-ascii?Q?2yT+dB2ts0gmIycCssxWn3H7TbJ4gQksP2R2nx4WiA0UP5TlkxQlbTjqzgLg?=
 =?us-ascii?Q?Y0zDZ2HEWRkZyy+bMm/rZtFCE03+Rnb8SeK/Guv5z8OCQbbv7Sxo?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1622a63f-b137-48ca-d09e-08da1c43b514
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 05:17:15.4959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uQnlRzi0d7nD/evMvnLk+Gg8JMDjEwYltPiTCYaLB49jRehhA1kgiHosyUD2w22nR61XcvsJykd5IwFaPg7W3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3329
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-12_01:2022-04-11,2022-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204120024
X-Proofpoint-GUID: Mx_HBJing1TxC_DA4CCqd-8QtiE2xAlV
X-Proofpoint-ORIG-GUID: Mx_HBJing1TxC_DA4CCqd-8QtiE2xAlV
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

commit b01b2d72da25c000aeb124bc78daf3fb998be2b6 upstream

Also disable page faults during direct I/O requests and implement a
similar kind of retry logic as in the buffered I/O case.

The retry logic in the direct I/O case differs from the buffered I/O
case in the following way: direct I/O doesn't provide the kinds of
consistency guarantees between concurrent reads and writes that buffered
I/O provides, so once we lose the inode glock while faulting in user
pages, we always resume the operation.  We never need to return a
partial read or write.

This locking problem was originally reported by Jan Kara.  Linus came up
with the idea of disabling page faults.  Many thanks to Al Viro and
Matthew Wilcox for their feedback.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/gfs2/file.c | 99 ++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 87 insertions(+), 12 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 81835d34d6f6..247b8d95b5ef 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -812,22 +812,64 @@ static ssize_t gfs2_file_direct_read(struct kiocb *iocb, struct iov_iter *to,
 {
 	struct file *file = iocb->ki_filp;
 	struct gfs2_inode *ip = GFS2_I(file->f_mapping->host);
-	size_t count = iov_iter_count(to);
+	size_t prev_count = 0, window_size = 0;
+	size_t written = 0;
 	ssize_t ret;
 
-	if (!count)
+	/*
+	 * In this function, we disable page faults when we're holding the
+	 * inode glock while doing I/O.  If a page fault occurs, we indicate
+	 * that the inode glock may be dropped, fault in the pages manually,
+	 * and retry.
+	 *
+	 * Unlike generic_file_read_iter, for reads, iomap_dio_rw can trigger
+	 * physical as well as manual page faults, and we need to disable both
+	 * kinds.
+	 *
+	 * For direct I/O, gfs2 takes the inode glock in deferred mode.  This
+	 * locking mode is compatible with other deferred holders, so multiple
+	 * processes and nodes can do direct I/O to a file at the same time.
+	 * There's no guarantee that reads or writes will be atomic.  Any
+	 * coordination among readers and writers needs to happen externally.
+	 */
+
+	if (!iov_iter_count(to))
 		return 0; /* skip atime */
 
 	gfs2_holder_init(ip->i_gl, LM_ST_DEFERRED, 0, gh);
+retry:
 	ret = gfs2_glock_nq(gh);
 	if (ret)
 		goto out_uninit;
+retry_under_glock:
+	pagefault_disable();
+	to->nofault = true;
+	ret = iomap_dio_rw(iocb, to, &gfs2_iomap_ops, NULL,
+			   IOMAP_DIO_PARTIAL, written);
+	to->nofault = false;
+	pagefault_enable();
+	if (ret > 0)
+		written = ret;
 
-	ret = iomap_dio_rw(iocb, to, &gfs2_iomap_ops, NULL, 0, 0);
-	gfs2_glock_dq(gh);
+	if (should_fault_in_pages(ret, to, &prev_count, &window_size)) {
+		size_t leftover;
+
+		gfs2_holder_allow_demote(gh);
+		leftover = fault_in_iov_iter_writeable(to, window_size);
+		gfs2_holder_disallow_demote(gh);
+		if (leftover != window_size) {
+			if (!gfs2_holder_queued(gh))
+				goto retry;
+			goto retry_under_glock;
+		}
+	}
+	if (gfs2_holder_queued(gh))
+		gfs2_glock_dq(gh);
 out_uninit:
 	gfs2_holder_uninit(gh);
-	return ret;
+	if (ret < 0)
+		return ret;
+	return written;
 }
 
 static ssize_t gfs2_file_direct_write(struct kiocb *iocb, struct iov_iter *from,
@@ -836,10 +878,20 @@ static ssize_t gfs2_file_direct_write(struct kiocb *iocb, struct iov_iter *from,
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 	struct gfs2_inode *ip = GFS2_I(inode);
-	size_t len = iov_iter_count(from);
-	loff_t offset = iocb->ki_pos;
+	size_t prev_count = 0, window_size = 0;
+	size_t read = 0;
 	ssize_t ret;
 
+	/*
+	 * In this function, we disable page faults when we're holding the
+	 * inode glock while doing I/O.  If a page fault occurs, we indicate
+	 * that the inode glock may be dropped, fault in the pages manually,
+	 * and retry.
+	 *
+	 * For writes, iomap_dio_rw only triggers manual page faults, so we
+	 * don't need to disable physical ones.
+	 */
+
 	/*
 	 * Deferred lock, even if its a write, since we do no allocation on
 	 * this path. All we need to change is the atime, and this lock mode
@@ -849,22 +901,45 @@ static ssize_t gfs2_file_direct_write(struct kiocb *iocb, struct iov_iter *from,
 	 * VFS does.
 	 */
 	gfs2_holder_init(ip->i_gl, LM_ST_DEFERRED, 0, gh);
+retry:
 	ret = gfs2_glock_nq(gh);
 	if (ret)
 		goto out_uninit;
-
+retry_under_glock:
 	/* Silently fall back to buffered I/O when writing beyond EOF */
-	if (offset + len > i_size_read(&ip->i_inode))
+	if (iocb->ki_pos + iov_iter_count(from) > i_size_read(&ip->i_inode))
 		goto out;
 
-	ret = iomap_dio_rw(iocb, from, &gfs2_iomap_ops, NULL, 0, 0);
+	from->nofault = true;
+	ret = iomap_dio_rw(iocb, from, &gfs2_iomap_ops, NULL,
+			   IOMAP_DIO_PARTIAL, read);
+	from->nofault = false;
+
 	if (ret == -ENOTBLK)
 		ret = 0;
+	if (ret > 0)
+		read = ret;
+
+	if (should_fault_in_pages(ret, from, &prev_count, &window_size)) {
+		size_t leftover;
+
+		gfs2_holder_allow_demote(gh);
+		leftover = fault_in_iov_iter_readable(from, window_size);
+		gfs2_holder_disallow_demote(gh);
+		if (leftover != window_size) {
+			if (!gfs2_holder_queued(gh))
+				goto retry;
+			goto retry_under_glock;
+		}
+	}
 out:
-	gfs2_glock_dq(gh);
+	if (gfs2_holder_queued(gh))
+		gfs2_glock_dq(gh);
 out_uninit:
 	gfs2_holder_uninit(gh);
-	return ret;
+	if (ret < 0)
+		return ret;
+	return read;
 }
 
 static ssize_t gfs2_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
-- 
2.33.1

