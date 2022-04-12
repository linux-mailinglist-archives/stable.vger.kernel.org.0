Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 241DD4FCEBA
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 07:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347740AbiDLFSW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 01:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236362AbiDLFSW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 01:18:22 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3E8344EF;
        Mon, 11 Apr 2022 22:16:05 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23C2QjdT029058;
        Tue, 12 Apr 2022 05:16:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=G9Z9LeAVfs4uOTE51NUhaVWjpTJWUFQ4WyZtXdzwv4s=;
 b=eTR14l8oEsbJk0zmd0Qe3tEQzTDvQvc/0EG+vuu2LYMoWWa6StD9BJ9yDPPh0jyoZtrr
 6gufcEoyoLpChDrV7TVRDRdyPn4Iu2nu/mKsxvkBajFS8/fntY1TvfuWWE1xSksmLFsz
 hACt17KDR/0AsmNLJ7o2BvpSFTlME4DAc/BHC3i2ThYQJs5z6KVSfz2VIC+NBPq24ts0
 YtQATJfgu/GaL60zcue4rBWzSLS29DXpccOQ6NGQ5PlyDwJoJt6/FTkVSP5VSo8mzb4N
 t59OR1JHiGbkG0/UiBDaMfkiqxgNAY2qirYNwLHsR6qcZcZlF3SpsmHYf62DKllxkLy0 NA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb1rs5nfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:16:02 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23C5Fkhq016620;
        Tue, 12 Apr 2022 05:16:01 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fb0k2h5ne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:16:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bzUGtpBKEmF/HDVOJxgxmrAoA1/F8+sS6P32agcYnC5SFfoZ6sK2zxK4LOYNLSsMI97OJE9ZmHscqWrr3njJmfw1e/GLYa1LBlc9VH+Ld3mmXNUcHmTdkCk/X04XwCTW28spsooByDC+Densygax59D9RDolqwhVB2GqMhEzs+s1Act2Annldx+3zOd5FthfZ1tZxR2g7yvBgtzmzJTISys0qxbwVtVK134b59GB6fDmc9rws9cW5UV61+GGO8RArc4dflMuHhLb2DTaWpGftkcLw3tfOPaLUru2UCGiv/2Lwj3t9WvoW9JtmX+Hr6sH2xJH632dGhKgR5FaifcrxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G9Z9LeAVfs4uOTE51NUhaVWjpTJWUFQ4WyZtXdzwv4s=;
 b=BLv0IadlOwM4t0Mfts/HS+LvkAiCBDB3IfWdjvIE6vn0kB92S5MiMBLN7PgEEh5737PiYpn/6CoRinbZNpZ9T1knx7Mg6Q9VhUrwK8Obw//HvN/yhhMyDRQbmY2DgDMIQ3iLT61BFi+Sqc/BvB+LgIbHWJZfOjpwE2pQr6RWrNjRc0n6/F7tngfJmPGKyp/YeOcWArb4Bf+s8NrUhlmNBCwM7QLplTShBh2oeZ78SMWQgPHPSxgQNboQVInZYaYyHBWWsF1wiUBETsVZGdENczFw9wzI5vH9TfJHxgl4lIp1Pq5XOq+M/ZbiD/BJDcr6CGI41PVmq6/Eu+KgmbD1Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G9Z9LeAVfs4uOTE51NUhaVWjpTJWUFQ4WyZtXdzwv4s=;
 b=UYTppReBSyYgFVWBa7hCQzaeGaqkZhf3O+k98HzbIdlYslrgRdaudmgzH87NbuVhIy4ZrR9lXzYxi9yPSom5j+hMQLr0hDDnj87Uyz9G6f2kdIZn/Jk4SAakaIaCb7UC9N9j2QoSiCmc4Kb093rVDvfAiT/lI35z+qRd8eRvI2k=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by BN8PR10MB3329.namprd10.prod.outlook.com (2603:10b6:408:cd::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 05:15:59 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 05:15:59 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v2 04/18 stable-5.15.y] gfs2: Add wrapper for iomap_file_buffered_write
Date:   Tue, 12 Apr 2022 13:15:01 +0800
Message-Id: <7e734837e0c0124722903fea573b48a269fb5b50.1649733186.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649733186.git.anand.jain@oracle.com>
References: <cover.1649733186.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0023.apcprd02.prod.outlook.com
 (2603:1096:4:195::11) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c316362a-e04b-4ddc-3a0a-08da1c43878e
X-MS-TrafficTypeDiagnostic: BN8PR10MB3329:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB332979755549B8CDF1F14DA4E5ED9@BN8PR10MB3329.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UQuFN2qZw1emeiroRAPTz1OV/yIti5Dr1o1STXhXviyc1PZ3oXhVhSpOBfkACiAQV54MTPQwSrfNCeiyr+3zDdSuQmMGohgThnahdVdgJ+LLQWgUW9LiUFzhYJpVqcr56eo4yJz8NOc6HXTsdICl8gdW+AJBWoo3e9vl3BiN2CTatxpA1ZZ2AHMauwU5jT/jp2ac1ZBuIwbjFEPCAa8UUF1UvuuscnSEKFAzmshjJI96S1L4c8+NW0yVmJBMi0Gwbvc3m7ALp/zkA7UpBm9hXglbwiVBlWNaKNK1d5Ft5odh3YD9sDnmIpHOLqtNoDO8WXVrOjMyaoGWvgRMPw2pCZjUXawtCpSRKRf0/y3emUMpl4/7Luj/XPBHVZwTg4rB3NNTyE5UK4WCTw2MpjW1s6dLweXUECPsoDeXnN32ltsHQSuorRfl11SjppziO610z0jIfhir88QOU0wW35ZHK34w+xvKWBURiUQyrWnifMsPEyIsPX6iijmVHYVaBVhg7dSvJMnHWVlnJdrOCFl+9SARQ7uo9aKEsTNRwoZuVy0nSQL3MdNop7tV14IrpvSTJ9wvAiNCNSj6kPo69qzd0CLkTWPzbjDfWX63uPievCRRx/WGL0lfMpHvHp2uWxGDjlledUvb8CG2zwCGcBSxpQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6506007)(86362001)(38100700002)(54906003)(6916009)(316002)(6486002)(508600001)(6512007)(2906002)(6666004)(5660300002)(107886003)(2616005)(83380400001)(8676002)(66476007)(186003)(66946007)(66556008)(44832011)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LhFhIxz99kdkaeq1ZLVjlPP/93+X7uTGawP26uMP4wha0sGyrM7BnaJB8dOR?=
 =?us-ascii?Q?rLJ0i3iYRytnQ1Dyzmt7EBHT5JmFTVz3TinNcYfnE+7FF5bXDUd5cuw5uiX2?=
 =?us-ascii?Q?vOSmHz52CBJanjaMeZqcCUKeb4d1sHbuJj9DHaNQnmfubIXicEHrZVeSKa6F?=
 =?us-ascii?Q?LhA1OOO3vVWuLXcEuP7tgQR5k7h0q+aNkMub8TvuqCHU0nHj6B5ZQ46QdOS6?=
 =?us-ascii?Q?wdJ2Bm7CUWNI7yVr4phs/Pc1+qOYG76Ruw4LKE/rJpfSLOlVLom8cJ8gRaGN?=
 =?us-ascii?Q?wysj/SKXuUVeaZeOhHO2r4nx5KKB64I0WwdlTaiSZycyXobGpv6lKWXqOuSa?=
 =?us-ascii?Q?ydp5yC9kPZtXpC21hQCMyl1kI9cgMnTWuQFSAZs0KMTQY9jqi1VYndtDVcfR?=
 =?us-ascii?Q?Ts+wcuJyolna135ATOspr/buDCqsKCV6vo9z3w9CxhiERe8FmVWdjMjLEl/X?=
 =?us-ascii?Q?DYmxCadUeoNDu5r2Ah+XNYkM1qNB6oD7qj+3V3hip/ydtEX2j1UP9AM3hVzM?=
 =?us-ascii?Q?9EvNQcB8EVN2oZHtEgfmtDb0Tzi1dQwmKyNW9MPfjr3XngMqJJbmB8wKFV+k?=
 =?us-ascii?Q?LK6zH/3ip/BOr/UuBktPlftJ58ZF3+36JwQZqCONyLv/Wu5q3+X/FBH12/Tb?=
 =?us-ascii?Q?xRArG5eeaOd2TR6zLUVQE+DgImuVoSLl6pyVvp/73c20QtxBADsP38Cm2vzA?=
 =?us-ascii?Q?QxmAxuvi72TMOPvOvbhd7fv3A8QgFMTgwFTDfSN4WzyQQWPBZDUWbWsFZMOa?=
 =?us-ascii?Q?noRF6XeGe2p95Iuaq8P1J2lo7Z2f7CMWUHw90mrcZRiLErazUd7Uoc4LwO8E?=
 =?us-ascii?Q?JzrbL49OtnTCnyXDyUslGK7XfMpRf6Z4NbfunRp1zCc38MnHMNlQF4XhT0JZ?=
 =?us-ascii?Q?A/95sO7C5NQoNuJdtie3WxnOecJUFVGw4kJ8q7EoSBLdHO6yiYd827SpsQhP?=
 =?us-ascii?Q?r4QMCeeNIF6WA3waW+AN7klY61FwjZOxDbksmdyU2TFnXWOShznjEQZYUDUs?=
 =?us-ascii?Q?MJt1UtcfWbdfeRQNXkb1KjnqeoybleMcGT7zsOxdxzbkVOR0iM138wyMkG+c?=
 =?us-ascii?Q?KnwVOz7waruEGmb+b5wBa0aEpNuyZKHhm7f1lbdxP5wKoKwSW59uEMXYDQXg?=
 =?us-ascii?Q?sMDl5EgWpBJleqMaMdeaSDA5yQii9XGXOkCl27KzJKtqCEco85ZPz2BtdLUT?=
 =?us-ascii?Q?4s0Grs6qdDz3oFXUNPnsmI17A26cF3/n0IE1JMY4HyzKCVAXEdl5i0zXWJEu?=
 =?us-ascii?Q?IU8Hv5lthwTZ/TJfpGMr4GGhft380KVtMymw9CycP6/7Nm1IyqPI+e9nVZUt?=
 =?us-ascii?Q?5e0mNzrYNe0TBWkRc2ICriF35+qYYv867b+mubNFvOsTsqbXmbXw2drjCRxb?=
 =?us-ascii?Q?xCw9xY1Z0I72mmdvC9a5BcotknI1giSxmZXELr3i6UG92JgthUDon98oE+mL?=
 =?us-ascii?Q?1xtXfUjd27y5mHelMAKsAPm0mr0V/e6cHSiZFvO4NXEVCeCrMoTBfPQED03o?=
 =?us-ascii?Q?y/6Gu+QJJcrorZLhkXk4Xdcr2tAtobhsThp2fJtC57SNiDZX/7br+f8mZeTb?=
 =?us-ascii?Q?Cs70DQEoyy5dVOTzvqo6h5qimuHK4EeNod6OfMrS1nmwIVLQkpoOEMHIls/9?=
 =?us-ascii?Q?iwk4LLRa/dbg3LgMoZWz99/uhmE3tbKxU77mo1iIlKeCiMMzY6PuA8ye2xK5?=
 =?us-ascii?Q?EkM/2ifRRq6L6mSLpiw8kxv7aarjd1CpquRkhYu63uNQuXQKnQZdj80ETCnb?=
 =?us-ascii?Q?+QKu5UvPbaagQqyw57ZoghScMfPAumTureSCLORecLtRjuW8ExYS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c316362a-e04b-4ddc-3a0a-08da1c43878e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 05:15:59.1633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 46DeyKyCJfWhmd8eHFrEgkeA18cOerT8d+44+v8fDfF83r4XlAa6JfQRQAenHBU1zg9sFsolCQ2lwex47tIPsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3329
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-12_01:2022-04-11,2022-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204120024
X-Proofpoint-ORIG-GUID: XQWMy-a9hJ8jtwnDemwnDVf5KzI__Oen
X-Proofpoint-GUID: XQWMy-a9hJ8jtwnDemwnDVf5KzI__Oen
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

