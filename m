Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E19B25BF44A
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 05:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbiIUDY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 23:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiIUDYY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 23:24:24 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 377867D1DE;
        Tue, 20 Sep 2022 20:24:23 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KLO6iX019476;
        Wed, 21 Sep 2022 03:24:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=ZdfE5jLuCOFEyeEFVAnt1RSUROri6hWGWFNj56rDJ20=;
 b=XHbpQ8PWNwMdkH8PgHKyEOqmBDACfgSldEPBNRNEKJdQ0TfMeIzQC9vmrsq1hVATcVEh
 7zQLs7GSCYwUXfE/B15OQuSVKOg78gjKw2Bq5ceRdhaB35SGYqwEk9eSgCQlbaMdjNva
 osm9JHMrJZ9YqfW6F2aXJbkDYbPoLlxlAbu0qag/zRAgAeURuqrhIOj00/TgpZ5yRa93
 WbC6hw24F1JC5e2xvmdfO9EL16rrQwh59QF/bBKsnFxEuph27b4wE5cNs/kJPHsS4UEg
 u6Ekr0Ngkbrk8qBPzQy3Z84FkqF7ZsLYaQ9PWd8CY7Kt8ESRIfRDXskvYd9J1ODAAQe7 0Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn68m90m3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 03:24:18 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28L21P4k025528;
        Wed, 21 Sep 2022 03:24:17 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2177.outbound.protection.outlook.com [104.47.73.177])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39ee95h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 03:24:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ipnFHoR3SJVA8EUEm7dFyTgjE3hJwBRNoAbCo6x1fleoDuXn1xNe6GQ9ApwvjwmfF7xiRPZBGMR1Ue2H5IFQZv+eZWdGJHTku7oPwFrJ1l7N8kqErIB1xfIzqyVWGeXJPnfTpYwso6GscSqsTbuiAP/Z/1gP8U93t7Eod1SIKo2musNTg4kxJY/oqINPr3m2pKCeIgJ9KVvUeJUi+u7w3KtBVtMVZZ6+jqo9sPnDzvGDU59gwfy9ghgjU1rdzf8KO0RkkvEypnwHehOBiEyLN0TP7CZrtoJfmOZKFSoK1FSc4J5T2j02Mi8V/D+btmRREdcxOmQlb52ofU/aVAR6Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZdfE5jLuCOFEyeEFVAnt1RSUROri6hWGWFNj56rDJ20=;
 b=AjZcW/DugjXggsI6AS5ay6Nr1A6KMKZaWftG/m6OIiQKKObTb91cZWJB+5+SAYUYryUC5OMM4A2gzYjVPZ5iXwahLNYOHy2zJHAmGTTaqmg2ZjHO5+OALC5KhcFb8e8ED3p2ICYSpx0QiLoDbr8zPt7hYWourLB7LqbBIxE7xrzED+4Wl7Itxh7j0VkfqKtIraRvNvRU7O3JGGMkXXVeg5ecXIwcm9M7QTlwoNqpkksfIe17RIGIYetv+1Pe+Q1Rp6TLluylAPX4eCT2JeZ9Ixfr0NTnlFoEswlhS3q39qZdL9KwWa6DdJ+GK006Kq79iJ/pzJGOrBPomp1sF7B5fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZdfE5jLuCOFEyeEFVAnt1RSUROri6hWGWFNj56rDJ20=;
 b=K5XDQOdRWc1tx7WD9bSGNNMN5OusfxcuF7mBtE5ge8OA2PyiDew56dRzC7RgqpMppb/PB08jdVoDkz05SundGXeUMMZ4aYXGuV6k3VcVVkvusq+Kzus7BDwQvsAFWU23JuN5Q8jScUjRFLAtRuzX2VtpYC6TR3xI13ksZx7FcNg=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by MW4PR10MB5838.namprd10.prod.outlook.com (2603:10b6:303:18e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Wed, 21 Sep
 2022 03:24:13 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Wed, 21 Sep 2022
 03:24:13 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 02/17] iomap: iomap that extends beyond EOF should be marked dirty
Date:   Wed, 21 Sep 2022 08:53:37 +0530
Message-Id: <20220921032352.307699-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220921032352.307699-1-chandan.babu@oracle.com>
References: <20220921032352.307699-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0054.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::13) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MW4PR10MB5838:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a124d7d-9462-4450-275b-08da9b80c1ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5mXRWeQNb7kwBe8CgJW5WPXkgsX2OjC6ys9zQnGVv0Tpn4+YnYsNt4qDx7QVbZzqBjsD5BCFEFTME0g9x/ofVF4CDkMshYoDD2pgxF3sXd2AQ7jwYLOFzexpwqnBJGgG6KUk/rIWUN4WvhZa94zr6MuY3zPcsYFzYFtPYG4ofwhKfAeA0s6E/g5FC2UVMMk9qBoZs0FCtw+VOLc7n6i81g+5NHFDA6bqJYKSPPrPiBXsgdpeqbrwdwHVlN5ZvJCbePWYtWeVQeYl3P5mSW5bExSk2H7LV98r0SVmLf77YWFsTBZ1JzPU2IPSiIDPMmCB4ZSj7EkqZVkVq23bfYuKhH903QCIy9XkWoG5XYvrUfbNVjV+emsmdxRqT0zYXgqwPDWXDnDYKaFvleX7JL0JJ2T/PU5lTiZhwpoy+5Uyax9sgm8uz2CaErV/vImCmrNoE5cSG2pkoJ8M4cWfA/3reSe3KZ21qZA88T80LuI4FoX+Mbmfmcl3uPmgHo5Bbco0ZqjeuQpsteQ4OPM3zf1UpyEXsBfuKHSHUlDnJLBccM3tHnDj0r5XB3L4CsITCx8rrgV6ytYwSTPZhpE5bS6I0LELqStmdvBCCifmzJHz6qLZGelDoisbmg4tzYMHzgWxxqAuY1IIKt9s88MCOWOVfWt9x0rihAs0LNlVhfmqZ/z+9CAxZR/ucBO34R6vV6OdBsIxn5jQewp2TE9daH4OgSOPfQER0kYpWLtJkMvyhzZkbD52zYNcb9pVK4PnUPMj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(39860400002)(346002)(376002)(451199015)(186003)(2616005)(1076003)(5660300002)(316002)(478600001)(6486002)(38100700002)(86362001)(36756003)(6916009)(41300700001)(66556008)(6512007)(6666004)(6506007)(26005)(83380400001)(66476007)(8936002)(66946007)(8676002)(2906002)(4326008)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qEyA7gpB32sOROFlAG91JtpUmbsC8vU3n08/BeweX1QojWX4D3ttOQNJhyyd?=
 =?us-ascii?Q?0wZoAQBLHB8LL1aoXTs552Oqa9MZRn217KBsHgJM5/VPOWHHjk4M/b9xBvzh?=
 =?us-ascii?Q?DCup7vPMUpOCzQswOUY79xWD1vaGIA6B5WSkmj6Aik/hN0ziayplz8+CzPlc?=
 =?us-ascii?Q?qIFOQcIW9sHp4OyL0CH8lST28KPGBVJOPOvMV5mGezC0JGa3SIrAvJfQGfXm?=
 =?us-ascii?Q?i5gytpDJgEzEGdAQKno2nv+huaB59xUzE0gK/J9be704+WFH6bDH+QOCeYJG?=
 =?us-ascii?Q?VhBHcJXaymGqMfeTrTUl4hDoY/M5FS8XOjrFpX/4ajGmlb5JNmxR8u5GnMjr?=
 =?us-ascii?Q?C4N54xEES9x2sGMjH53WWkqOUMDdPVeGzHNAhm2k5/mQSXgrx4BrWqexCPcJ?=
 =?us-ascii?Q?DxyWkGakPzMc1XJ8WjOTH/EB4/lL90QIxyBFD/GQIUfCDq9+bD18745bp49u?=
 =?us-ascii?Q?Ky+P447S5o0zocPAnPFKTnaufwDVkHr7B7J0BsOvvN241qTEkVNDk0eRAAgK?=
 =?us-ascii?Q?tpjaTVlhVofKEh4uNxj6LZoDejPBuyOK8u48ODUjv5m1vjqfV4Cbesn84pMB?=
 =?us-ascii?Q?dMNf5Sj6DJfVUQkwXUqHj6tmOjTqEVNRj/Jw93O6E495A8dLodjZpzatXcJJ?=
 =?us-ascii?Q?5pc5jRjd8NMOeX5FgDaT5eOhu6hDor/7X5Jyxaqrz3k3YO8Ej8YzyGTmFno+?=
 =?us-ascii?Q?Vch71ZaVZGBcliKe9c/anGnC9maS3g6/yHK9OoqCPmsh4WSUAuPXObsO8Kdh?=
 =?us-ascii?Q?gNyY8SpRCWiMwiHxsOTNeO3zwz9TEav/kt06FW4DrQxLNr9pkJN3V99n6A2c?=
 =?us-ascii?Q?1cl/5EU8T85rJIZ0uxlSaJV8a4T18duFPxzSDEPuGpX2DCxyRApNuGdzesLI?=
 =?us-ascii?Q?rsDyqRU7OjO5l374QBcaasnj4y0GMU1SbSK17JjwlOZwIyqBUxQbyHX9e7hO?=
 =?us-ascii?Q?KtSQp5JPqgrNwuN+8u5i15JEXIRJtcflmg5bd+0K2pYaJNlBIPEk+qLYgSZh?=
 =?us-ascii?Q?paWTf90Fz+rmgWwvmnfhsBbfW0weXwKphUmu6bo9MU0K4hw2gilNvqWbNsoW?=
 =?us-ascii?Q?VssvJ/B1yLcBTixXl0H1aVD/oU6edWFR9sY1LBoRsnL7wdrKHgS5IXC0O9Jz?=
 =?us-ascii?Q?LN8UThxFZxRUKj0Jey6JJxkD3Vs7NiRExiSuVJlzZcggCQd+vWDlznfaBBwx?=
 =?us-ascii?Q?hcTmgbwg1mIZm/HpWFLXowtD15zz1vXAA3QG2iw+gHBXtlwGSnK099iNWeiG?=
 =?us-ascii?Q?DRH3dcQ6vwFh9V6W2joyXXoPrRnfzNv6WGjvJtHnv6TsVxiB8ZeJVzAKNhEH?=
 =?us-ascii?Q?GLDZaa+qbtAAkvdujhZTtZsxb8hOiOl7ofmjK0qeu2lnLZz0VEAXLgOcC9Fm?=
 =?us-ascii?Q?NSQQtSUJrRCb7IyZZNl5IuFeUTV/2Ezx8Zu8ASa/p7YFJM1Dw9fLkTPjZrGN?=
 =?us-ascii?Q?SE9LUUOsMqODxT1XhdXXXklMvD2chJkZtLMy9ZhQYqGvZY9dXckAerbAjN7S?=
 =?us-ascii?Q?cccMEe6/Mk28d23NLPgfyUqH149CsN0ttowfl5PcL/iW3i9rOw8+fN8brI1P?=
 =?us-ascii?Q?EmrOZLifU2sTezyuiGm7HNudpzbub/Q1/WKUGkD1+rncmai5Abq6BgOgmQRc?=
 =?us-ascii?Q?Lw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a124d7d-9462-4450-275b-08da9b80c1ad
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 03:24:13.4753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3csgEfm5PGi+KJ6hj2acZisyfqy/BhaZbTTru+ih0Um6FwnKWpOITbce90V+E9lSgYwN8cTGNcM/5VKEUrLLHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5838
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-21_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209210020
X-Proofpoint-ORIG-GUID: waIbB71OzxquWppEZAv1k7KcJsfBQ-yJ
X-Proofpoint-GUID: waIbB71OzxquWppEZAv1k7KcJsfBQ-yJ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit 7684e2c4384d5d1f884b01ab8bff2369e4db0bff upstream.

When doing a direct IO that spans the current EOF, and there are
written blocks beyond EOF that extend beyond the current write, the
only metadata update that needs to be done is a file size extension.

However, we don't mark such iomaps as IOMAP_F_DIRTY to indicate that
there is IO completion metadata updates required, and hence we may
fail to correctly sync file size extensions made in IO completion
when O_DSYNC writes are being used and the hardware supports FUA.

Hence when setting IOMAP_F_DIRTY, we need to also take into account
whether the iomap spans the current EOF. If it does, then we need to
mark it dirty so that IO completion will call generic_write_sync()
to flush the inode size update to stable storage correctly.

Fixes: 3460cac1ca76 ("iomap: Use FUA for pure data O_DSYNC DIO writes")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: removed the ext4 part; they'll handle it separately]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_iomap.c    | 7 +++++++
 include/linux/iomap.h | 2 ++
 2 files changed, 9 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 239c9548b156..26cf811f3d96 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1055,6 +1055,13 @@ xfs_file_iomap_begin(
 	trace_xfs_iomap_alloc(ip, offset, length, XFS_DATA_FORK, &imap);
 
 out_finish:
+	/*
+	 * Writes that span EOF might trigger an IO size update on completion,
+	 * so consider them to be dirty for the purposes of O_DSYNC even if
+	 * there is no other metadata changes pending or have been made here.
+	 */
+	if ((flags & IOMAP_WRITE) && offset + length > i_size_read(inode))
+		iomap->flags |= IOMAP_F_DIRTY;
 	return xfs_bmbt_to_iomap(ip, iomap, &imap, shared);
 
 out_found:
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 53b16f104081..74e05e7b67f5 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -32,6 +32,8 @@ struct vm_fault;
  *
  * IOMAP_F_DIRTY indicates the inode has uncommitted metadata needed to access
  * written data and requires fdatasync to commit them to persistent storage.
+ * This needs to take into account metadata changes that *may* be made at IO
+ * completion, such as file size updates from direct IO.
  */
 #define IOMAP_F_NEW		0x01	/* blocks have been newly allocated */
 #define IOMAP_F_DIRTY		0x02	/* uncommitted metadata */
-- 
2.35.1

