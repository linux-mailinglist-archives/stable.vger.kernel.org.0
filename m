Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCD5501E51
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 00:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbiDNWcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 18:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347048AbiDNWcD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 18:32:03 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A131C11B;
        Thu, 14 Apr 2022 15:29:36 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23EKkvFo006846;
        Thu, 14 Apr 2022 22:29:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=G9Z9LeAVfs4uOTE51NUhaVWjpTJWUFQ4WyZtXdzwv4s=;
 b=tTNzMrPrGcgGIs7njcJZ6n6ZraNr4znQLSPBaB0uTgfBafcXr+SB2HP+zie3DQJ7oh5K
 Xlr+mFfQKN62Ry9LcrvxFl/loDvsqpThLRsyvXyThFhq+tr5HA3P4T8fq0hZQN69y6rf
 8z/Gk1nIsY78H5zOtdN67G1H4gC+0TBz7ABJXaaiNgNqr3XhLPxNqmsCf5wg/qpKY6l8
 fT/7XasNuunqs3K5eu2faVQJ/Yu8x6ifbIl40iet0n8c/17VQRzIZcuOSH9PocSs4Eah
 pYxOj97IllJ2y3m7+it/EzEvIiIxseRcbr7mzisej2bZM+nwEP9yUDPZI5dAezkJN5cU lQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb1rse6vk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:29:33 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23EMGOCp008407;
        Thu, 14 Apr 2022 22:29:32 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fcg9m6jv0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:29:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I7MVV1sGuwe/Wstsc+f88KM2xWmCMSdcEuOBIT3g2A8UnlFZN+Mo8QHwmKaDJDoNGmBydQqtzuuQ806FFTwocPLMoMTezDgsPNZZ6HxDlLhT4Oa8RnpB6ut6oPYKprHY0D8ufXXqxOv/JsoCRtc7+DfIvBu/3McMR8qvp4p4s7sB5S+OH7ena1RHVGi9vc4ARd9KVFyKsD2QQIwzLWE03eLBKYU3KZT9Rk6F0VnVTdpJDmZJ6IMWCRsm+/iR8VOwT0/0y4s6rNE5FnsfrL+8JepPWv7xPYkSU3YUDr7CsaDFhcZUfBEJCwueJipkmfJegc+BBLmieekFJ0CkgZWC5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G9Z9LeAVfs4uOTE51NUhaVWjpTJWUFQ4WyZtXdzwv4s=;
 b=AUJsNVHPkPkZ9SKW2svBXuvYAEdN08xOHAT7CpcmF3ZcQuUOBqWWqStsT0ZMOhLD+BuFza2YZyclzVUj0mQQdeSTOj4MkZHFCayr67/aBl89rz4Tg9ULRpjJbzsirvqEakFu1ErxoKdQVcXjiL0FOwBhnV/r3Ar+BXiEsS9DJe0L6hco5KUyKQXyzxqlwWWK88mzAGd8OhsxrEZ3jQyFflNa+TJGjXII6hfS6DoQ0AdRnEQCMz1+d1pxa9KItnV+B/7rSn0MX82K2S8IV/NgCqfCvR6lBWYMNmw+0cNL1b4OzO9/yasMsu2mojiZ0gJLe2h8XVfN45Hhe9lXtsFAbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G9Z9LeAVfs4uOTE51NUhaVWjpTJWUFQ4WyZtXdzwv4s=;
 b=gNZDUffgq3WCpjEvvFh2+bW+i51s/iHwgmJ6ZFMQHTpsi9vy2+kXDqRq6sqDFpI3DZDhNpDwbAg3cau1tzXjAAYXVKnlvzMCYUbUPOHx42SKG72hoyRfGjKPQxzFvv/P+Lw0thWLmA3OLNbqhvs6xpPl/iNykXmEourEKzQbdmI=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by MWHPR1001MB2094.namprd10.prod.outlook.com (2603:10b6:301:2b::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Thu, 14 Apr
 2022 22:29:30 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 22:29:30 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v3 04/18 stable-5.15.y] gfs2: Add wrapper for iomap_file_buffered_write
Date:   Fri, 15 Apr 2022 06:28:42 +0800
Message-Id: <c6935195c043510ac0c69085b8e22a906a8acc6d.1649951733.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649951733.git.anand.jain@oracle.com>
References: <cover.1649951733.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0120.jpnprd01.prod.outlook.com
 (2603:1096:405:4::36) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8ce84d0-51fe-4fdc-1fa9-08da1e663dd6
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2094:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2094BB1654F40BCBA1E0715DE5EF9@MWHPR1001MB2094.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uy22X9/Ix0y6/AxAj4/meHFtnpCgnaTdRi9UX5vXqw7pylg8SospIZjGnVz0ezNrTIhdsJMSg01Ixo4rpfPDV/BUGxHotQTRSEBGqlnut492NR8gP3Yja1ED0Em2pKJU8WP75L4BEju6LLJOp/naCMf03PVYqJk1S9uhnlnNhlejZi09W5rqAWWtwmCF46WnxkcrX2QR2LPglDFQG1nGNPqBga9OmuxM44MoEvLnTUyJZnlPreGbFc31LjPUFkFs5HbFmOtnEljhZA6KFAwrvo7G+3oxI1MTNsSry4ZKaCQh4j8zM37MPXn/LSIdt7JNJ7fQieCV7aaR1DhuBKCt6PJB15AOgzKRQQZPVWsOUG89jqLdTdOislWNXd+4vjQHsO7R4wZiIQqcQa4aW7mDjzFMkhVkltp5CG7kujjLM6Fs6qgYqFkDbbK6hLMxZOyoIzqKckIdvmbGV10EL7WH0eKnls9lW3X00wpHbn7TYrIBgfo1FJ+375zCR36OvAQw+DmThIy0EkIgWjAkNBSmCm8aRYBSRotOHWDI5J5rPO3yVICuIx3S9MDaP0sidiL86D+9fFjS5xlecYBl9ehUdqstjjl5gSkd7471NNy/2h7Zvuoy2r+KuPkBx/nzSWR6kiIiXrWaFmhKNe/D1xVs2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6486002)(2906002)(86362001)(44832011)(508600001)(6666004)(6506007)(6512007)(5660300002)(8936002)(54906003)(316002)(186003)(6916009)(66476007)(83380400001)(66946007)(66556008)(4326008)(38100700002)(2616005)(107886003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dWnizC+1EqkeeZG8IDL1PWuYUY7dab0jHxs3QaDSUb24neOdtZHt4cQdneYY?=
 =?us-ascii?Q?Ka9/bBXr1jnSRaxEVKQTPqhgaPw5/CYN7H44S58C8oNBIA3Kuexez+UEETXf?=
 =?us-ascii?Q?WZyGq0yL9F3Je30h8s73WgrYOeoXC6QZnlqdMwmZcnSp5Es9YClX7FysXjdL?=
 =?us-ascii?Q?+nU7LkSo0rVIZ1OBiRUIrJnk9drSNYw6RhqBx80czrRdzllJzeNIDINLeGHY?=
 =?us-ascii?Q?ZpxDjSSR+ZwejIl5eZvDtAIsBjiEnF4FqdIdqv5TcedRIF2ITChVEjLY1ffC?=
 =?us-ascii?Q?oZyZbGpWzkTHkdvM8Sen4uRNM029gl0rFNJy5MD2EE+SMPEm0jjsyQ/zqT3P?=
 =?us-ascii?Q?MrIP/uOiVPvWlu+BpOHzJ/HxdpD197s5zBYEbExuUB+sFV6mZ2avRCLDUt8T?=
 =?us-ascii?Q?S0rH5sD5TflV2RWVFSq0xIhZSXq1Clvq4gYiJfxeu0S2qr3EhCrJucasgieX?=
 =?us-ascii?Q?7BLXXOizPBdj5TRYvo69jKyostwmqfpRenKgVxymEKP3IAa6xfgk1lakITYl?=
 =?us-ascii?Q?RjU5F9S8DB71YuSKZJVbVpBWunmeBL26V0rsOjPHuA1S2kA83IiE/R140j+u?=
 =?us-ascii?Q?wH6iWUfX92scHaRow5rmEOu9y7f0J9wIhdwkMaI7gsH3bLO7Ho1ytgU3/q/M?=
 =?us-ascii?Q?vvbgOGOmWkoQj8LK97f7wbBUo8CehFiMY6FMUry9BfhU2fgYMcS/i4By8UUP?=
 =?us-ascii?Q?S1u+QsTsTfBkDSoXyrUQA9xul3K0ZYQdu1FouZluSFTTwQpsHOJn66s9VSBT?=
 =?us-ascii?Q?lltE0Dh9cW+VdqZ1oqzDT9HSVcpW8A4NjS58P8p1MTzG+hp4PhrxqmTsHGW6?=
 =?us-ascii?Q?oKioXtxYk/qZbuv/sqFx6oH88aZyVO6IHs+eYHFmWLgkVMSMwbt9uMNN59dM?=
 =?us-ascii?Q?n07XoFyVy3OqQiwsBZC9qJXFwesqEqjE05mJfYTa+2SvCuqbYMJA/SoB1KHx?=
 =?us-ascii?Q?ERBhp+DTiO4SB9TUqaHPQOtFtd+xNNbmLjFQeH7XM1g/PBKqH0/BFZBnOXoe?=
 =?us-ascii?Q?SzhHtX/F1MXvaCGQbIwaF2cpyMJ7ft5KXwcTFeDPyowJZrpfAKnvG7sARqUY?=
 =?us-ascii?Q?Kx3lwhFVRmN1nGazMIGT8wxzoXLUEVEd8cIVmFzzg/NrohCSN/BQJWTLO2wE?=
 =?us-ascii?Q?d/OLRJvdGZUUW8EC8bpkKo+VGFrpeSSgmA8Yis6VaJuqn6q1Jn2rmdturvC8?=
 =?us-ascii?Q?8dRb7babvPPBv/a3lRDJYvBgIwlAIfDv+Jf42082rCVhxT6OR3vFzAcR9jJ4?=
 =?us-ascii?Q?TXxoxK5PV/PZIJu47UkgSnFFkuglG+kiaQ7Hd01FaHLhsUW+DfM3DEd7phM6?=
 =?us-ascii?Q?JDQ59QsK6i/+AyrbZ9UYem6loplpR0/uMMyvdCdqo75umjyyJQkAeYPKCItJ?=
 =?us-ascii?Q?FPDBwVo7MdgNUn7MWEHCPPXAwvfiHUUqS+U8UtVqIvH/trMS8/tjdLfaTcqi?=
 =?us-ascii?Q?+jLxHsP/eNuKg6Tus8AA3NHRHfwuRcMU2di6zBShcoTAlOOdhY3Nu9imnXVR?=
 =?us-ascii?Q?542tQcPfCP4Pq7XRK0H2Gnu/Dw+/AgUUN52IF9hhv21rpEHUi2ygff3deFbl?=
 =?us-ascii?Q?y9+3Iq8LAGrBBpXyjDHO/5F0+uWhIb2Noxkp5Ys4EOKE0jfSfqWWkLGUWCn+?=
 =?us-ascii?Q?U+FGTVQNprayjj0/hnLPuCCpXYeQraVgDZqYTuYCuLerurFLHdPMCYaO1PXd?=
 =?us-ascii?Q?mk1rFsrcab4gG3fN0GMIC13JOwCxzx4/jLcj4wJxXKroU+8oGaY/WgPSvqVd?=
 =?us-ascii?Q?sYHwqcfehz12pzjf2YVEGH2JbU0ZyAQnWanwpy0vFWKiPvnyYYPL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8ce84d0-51fe-4fdc-1fa9-08da1e663dd6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 22:29:30.1004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x+8JbYxKzB0SnONjxHkbxeZn+VKpMt3vYXF/IsIsJ2Le7tb5+DgfKyYuNxi7NnClRAdm/g10ka8OIRozYTKt9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2094
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-14_07:2022-04-14,2022-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204140116
X-Proofpoint-ORIG-GUID: zMqFA84djWIm1GvUmcabuzZtrF062GXE
X-Proofpoint-GUID: zMqFA84djWIm1GvUmcabuzZtrF062GXE
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

commit 2eb7509a05443048fb4df60b782de3f03c6c298b upstream

Add a wrapper around iomap_file_buffered_write.  We'll add code for when
the operation needs to be retried here later.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/gfs2/file.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 1c8b747072cb..df5504214dd4 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -877,6 +877,20 @@ static ssize_t gfs2_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	return written ? written : ret;
 }
 
+static ssize_t gfs2_file_buffered_write(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file_inode(file);
+	ssize_t ret;
+
+	current->backing_dev_info = inode_to_bdi(inode);
+	ret = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops);
+	current->backing_dev_info = NULL;
+	if (ret > 0)
+		iocb->ki_pos += ret;
+	return ret;
+}
+
 /**
  * gfs2_file_write_iter - Perform a write to a file
  * @iocb: The io context
@@ -928,9 +942,7 @@ static ssize_t gfs2_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 			goto out_unlock;
 
 		iocb->ki_flags |= IOCB_DSYNC;
-		current->backing_dev_info = inode_to_bdi(inode);
-		buffered = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops);
-		current->backing_dev_info = NULL;
+		buffered = gfs2_file_buffered_write(iocb, from);
 		if (unlikely(buffered <= 0)) {
 			if (!ret)
 				ret = buffered;
@@ -944,7 +956,6 @@ static ssize_t gfs2_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		 * the direct I/O range as we don't know if the buffered pages
 		 * made it to disk.
 		 */
-		iocb->ki_pos += buffered;
 		ret2 = generic_write_sync(iocb, buffered);
 		invalidate_mapping_pages(mapping,
 				(iocb->ki_pos - buffered) >> PAGE_SHIFT,
@@ -952,13 +963,9 @@ static ssize_t gfs2_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		if (!ret || ret2 > 0)
 			ret += ret2;
 	} else {
-		current->backing_dev_info = inode_to_bdi(inode);
-		ret = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops);
-		current->backing_dev_info = NULL;
-		if (likely(ret > 0)) {
-			iocb->ki_pos += ret;
+		ret = gfs2_file_buffered_write(iocb, from);
+		if (likely(ret > 0))
 			ret = generic_write_sync(iocb, ret);
-		}
 	}
 
 out_unlock:
-- 
2.33.1

