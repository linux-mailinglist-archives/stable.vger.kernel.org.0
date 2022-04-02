Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58E14F0087
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 12:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239094AbiDBK3x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 06:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354313AbiDBK3v (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 06:29:51 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662D21AA4A6;
        Sat,  2 Apr 2022 03:27:58 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2322rVrp018751;
        Sat, 2 Apr 2022 10:27:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=rM2OYNDnjOSXgpIxpKd8yTK/tasdQ+W01Fq39WF5u3k=;
 b=JClaEBIN4ha/AbM4ZRTODlSiq4Mh6EuVvSigpdDkcj7U+Tv1gAJzmPflZ7+OTriLpwLq
 UGEhUkpOsB9e4QIDCBVWLEs9y8YolTa/f/X27WTlv0UcBo/b5fLLWRttKWsMDHCKgaI1
 qX1K6BL6+aU1KVTnG6yVV13v2auEx3VUQfUYRkrtTinG6xWRQu/2Bm9/dpRESOk8dko0
 DwMkWPO/yD0Bu5NdNx6epS8XAy38YL5L5+39nTuhGt5Voy3kmMsg2Z0juBHddnObvbU5
 Z4qrxFVcJsGsux6u0XzF0l/lFvlhgIHFsKPUVw9ERALltu1pwxWF8si6rJ3WlWLsko27 xg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6e3sgb06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:27:56 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 232AKhAm004384;
        Sat, 2 Apr 2022 10:27:56 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2048.outbound.protection.outlook.com [104.47.51.48])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f6cx163v3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:27:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JKqrXL3M1oc5msM81mM6v013/YS7Uf73xgIwCvsLvE16hfG/2aCg7lWRHAiGmSsILj/xnSa61lMEKMZLTUXgbsGGB2VT3Jyb/n2AYjWiVedg5LG1GIx8sW2Md2wqsKKliJQ7npiOuJkCYjLQ3+RKsdI2S9mbf8pWZIrFlr+YW4wjiXON//65X3Xa73q42AV7gSQHGDwB9N3lq9AOKVcmfvZhkPXOvCydxvETErvQm7m95bvQ2whmTaPZGrwJk8VYZRuFbCDYvSX6dfA821vDSEAFqLY9vbonFzKSLKdEvsYs8aHhq+715iChBC/95qXF8p2DftYcRXL3wqzbbtC1aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rM2OYNDnjOSXgpIxpKd8yTK/tasdQ+W01Fq39WF5u3k=;
 b=E3omIxcxyWjshFWP/icpCCnK4u3MDSh1DVI41Tcb/NDz6HgY1nKDGBW784dMjFKW++YPNmVCp/x0o3LD0fuJfJMz5GARmpt77gIa7j48Jlcx+bBpQ/+9DyiV3UFsQs5i3lDpHR+BCtg08MFoAWj3rF7KmNz5XnDORzyjpAWAaLcvHRF831hF1SF1tY9cwMToQszz4ga+1xDmaaBmTbucV3sf78s79dfRC5OcbFs3yAGIiB3V/I0iod5EMXHfTaPLOJfZ7YXM3p2Ft3wW9JM6uXJnC+lpVUroVy1z/HBSCBuOJnZKu6ARbURWolYQCGTIbJG+HtuJvaGhy7mSFF9Otg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rM2OYNDnjOSXgpIxpKd8yTK/tasdQ+W01Fq39WF5u3k=;
 b=paEiSAN/Dut9h9ZunwRl+3LoJLqPVeB5TYKLGrNmPJtVFDH7m4xzG7vs26VeoLWqRoJE8XKwn1EYWGxtiZEVmr/mwsUVZ8iNqlok9xljmEmD7GxEYgq+e/czwLfpjCbvMhao4AG1Y/zzNv9BYBpPi6dtnqCMoxii7/LRvqjW6l0=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by DM6PR10MB3049.namprd10.prod.outlook.com (2603:10b6:5:6f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Sat, 2 Apr
 2022 10:27:54 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e%6]) with mapi id 15.20.5123.016; Sat, 2 Apr 2022
 10:27:54 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 13/17 stable-5.15.y] gup: Introduce FOLL_NOFAULT flag to disable page faults
Date:   Sat,  2 Apr 2022 18:25:50 +0800
Message-Id: <b1925ae2efbb181f76139437b1dd5129df6fdb81.1648636044.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1648636044.git.anand.jain@oracle.com>
References: <cover.1648636044.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0206.apcprd04.prod.outlook.com
 (2603:1096:4:187::21) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1f2689f-87e4-479b-4348-08da14937267
X-MS-TrafficTypeDiagnostic: DM6PR10MB3049:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3049C6908D28D6D1F489E9B1E5E39@DM6PR10MB3049.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +qR/swzYfLCEjU2p4/SiDHhnZBpTIoS2qM9S8wBKK4elfM5KFgkJ8RAB63kf1khtvT21YdnuPKAeAcrhJdTXTEP4aPfEhCDhz2zJMmxNINdDQNdsumSepcrDk4n+Bqcnf6mJ4H5qFiVAZN3rMPLdFwk39PlR/KjPIsFIA5L9cwGGspkiyk5ZW2SRy9Qn1tmRIq7+h55TZ6yorTkuckl6JG5ulazF4MS8u0B4o8uSHFuchrnFIVPVPXgS1dzhU4wyvGS10CdIZNWZISqyGv8fSABHCY5wu3oLx7ubL8VTR7FFatp9HwOdDGijEaBk+0x5qIJwvZFkOXKpJ1s26uvM4euY6sn1kOnake4mDl1ghPuDE0ELXCNbshQLyT8oI3+jxqA5fDbYN3O/okdUMWJCExJb/UrBxJ90o22kW+vjPCVFcEJSGZWhVCkK8uEyrpDyzn2HWjHBoJam+goGzKED6RsGzkRMbGS9Gu5V2OOoCjuhOnh4bJ9pzgFTKic0rdp2UbcY/YFaJBW/miZ38JHFDLLJcKJFS2KDBsttJMm58jZFpJGQyIEWGJjZVRY7LBnDrTCyADC7JsB1XJKbwD++rqxW19KmbFVGqaqQxjBHUIzNv3jqa0AKSdmvOLZoXEhJnsjjn8xJ/QCQ14UbTgGOHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(38100700002)(83380400001)(316002)(508600001)(6512007)(36756003)(86362001)(26005)(6486002)(44832011)(66476007)(6506007)(54906003)(2616005)(6666004)(4326008)(186003)(6916009)(66946007)(107886003)(66556008)(5660300002)(8676002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rXGsSHnw94a1QHMy9J42FTknH/ZNdleBlIx6gSUiuFHf1QWsMjeLBEPjO2Yf?=
 =?us-ascii?Q?3LzVgOtwcE+sOSCFlW7OmPBQMRwg9TWDkOyQ1cJ4X9LRrX/KlYAmEEEDCdur?=
 =?us-ascii?Q?mfyqMeUvsiuCsIoOEHGjHOe8CpqRj3yQJphVwJunrK8A8y3TAc7peYpPrVzA?=
 =?us-ascii?Q?uigIPvBeWftwgo+IY460r4R1tbssCh4LEaUNGhBGE7FbHjPi3sZWJpH0/sNP?=
 =?us-ascii?Q?kTjIBUBuE24/umtLamKxwD0Z7rJyVP3++qNPyDlMXFA9pXFT+141eAArLlW7?=
 =?us-ascii?Q?Qh6Qf6PJdBAaIcKkIPDw/uNJARbKYX1aLbzgjOUOgcS356yfSRbpLxPObv8D?=
 =?us-ascii?Q?fDoRJI7jSPBZBpxn6A9a8wxPR3W07/hbrbs549PNzYS4cNmZhQ4E/VQdao0A?=
 =?us-ascii?Q?ofpykzXHPt1oUrOLatAowcc6HqAtNKsErE5up/g9liYv0nLI/MZ2d+0rAEb2?=
 =?us-ascii?Q?qZaVCCk1O82tGj/m/RIG/CgvRgYa4AJKV1vSbF4SlFfV/66mJ7fKTkbMGU+f?=
 =?us-ascii?Q?T+jvKp8xO/eiQIW1l0bRLAo7Libk2/ugGLp4TND7rY6jHFO07+0Em9eEPGZi?=
 =?us-ascii?Q?UoIdYbHfRFnoMpLDv4Y9AbYIHeS7zF8GhbIOb/NX7cDyE5vMuUlwYl1feypG?=
 =?us-ascii?Q?7ByRs2Sfn7B9VahsMiwCU2wuVFWzLYVb3jHH2NtvKZifmDK1FlD9OhWdurdB?=
 =?us-ascii?Q?EmzIm+L44PuQiDvTq5Epp4cWyv+Hox9HeNnhqbRb7kWTgYo1gf4A+ueLTYz2?=
 =?us-ascii?Q?YG+VDw2Ktydf6hzJ3cahNtN2nIfChF1H8M7JZkBFrEBS1UlaRmYO6i+ngumt?=
 =?us-ascii?Q?gdG0oOc8gVPvEff3stlucrffrEM37bAgU83WUrg9wlK7cNXJKAy2MMU1l9IZ?=
 =?us-ascii?Q?v1p09DJAj5yGnS/YvtbNoGY+OivKCKQrlvZMwMhQMWO+5wHY67EEL1vFvJjX?=
 =?us-ascii?Q?DLktay9BXeGYnZpt3K2XWhZek2OM3CAASMgxCfkgKASBhGjxgwctDVgcBl6Y?=
 =?us-ascii?Q?Mq4ZqIz8TDaEGhwcvWeL2zrKEAO2DxEKVEG3UdwEoYx+04WD8RqYVotHTQBp?=
 =?us-ascii?Q?o4aqGoWL2PJK26qTwoWXSMHmk6QZpIw2gxxlymrfrr+0kZrAS6JS/qCe9ymW?=
 =?us-ascii?Q?10BhDhmRJ3RTaStpUeH+sCI9H36/mmYaURVcEkyL9tgFIDaNCeLOH+VT0Ahf?=
 =?us-ascii?Q?rEOc2n4IPkb9yZ8Ne4+ZVi8KYTwPwcWVHoikHbiR1kXiHBDb69le9OQBQ9n1?=
 =?us-ascii?Q?jmyffv3Ptq7AW4pkwIpuPulKzVD6K6izbZPW1SnpgNf+fIr7nSBlQ2Kd64lB?=
 =?us-ascii?Q?Zms+DqVrpHOOdpg9o8F99f58mBFnBfOSj/F8Ffr9yxvLK/Q0xYRfNlPfp8Xz?=
 =?us-ascii?Q?9mOWs0bJ+UX5C/sN9+vqJzUy5K5uetovguyaOsm2iVtMHJpm3FTv6el0wrBO?=
 =?us-ascii?Q?4mwitfovx/TIABNq2eradnultna5woWdYasZ1llRSRtqQ1DAQvGEe9mOyzJS?=
 =?us-ascii?Q?zkvMJsqtltvp3Nh1kKto2I7RtFhUoNrLcEfVf0Ns8oYfzXxEm+dlARRfZCdx?=
 =?us-ascii?Q?5CAk2jkv4fYByZb6EOVhuXytX35AW2fMmQsR1NYTbbd6ttCXNPAyz8fQjeAo?=
 =?us-ascii?Q?7zN9+jrlY2ClZpwnigtc9eR2QhDc7tGdeK2AaSEGvuAJyoN029t6RHRRfH8z?=
 =?us-ascii?Q?QdQvtkt3/9Ra9KvS+pN1IwcfWmZrDwBhVPa/elV2jnLwFrKDl0tOBtddYcC+?=
 =?us-ascii?Q?cqV/YZCkMXDLCnQvk3KG5HSdVOWhcTw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1f2689f-87e4-479b-4348-08da14937267
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2022 10:27:54.0976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0YSY59EuC5iFZfs3MjBcH9jUatMuWyfcRT4c+CyxfxsGfFOCgw/dda7xtVrH+x/XqyRrOQ5LhlEx+jscC2POYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3049
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-02_03:2022-03-30,2022-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204020064
X-Proofpoint-ORIG-GUID: 90nY1c_3FLV_slk5tyGjZvFd0SqMq-qh
X-Proofpoint-GUID: 90nY1c_3FLV_slk5tyGjZvFd0SqMq-qh
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

commit 55b8fe703bc51200d4698596c90813453b35ae63 upstream

Introduce a new FOLL_NOFAULT flag that causes get_user_pages to return
-EFAULT when it would otherwise trigger a page fault.  This is roughly
similar to FOLL_FAST_ONLY but available on all architectures, and less
fragile.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 include/linux/mm.h | 3 ++-
 mm/gup.c           | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 90c2d7f3c7a8..04345ff97f8c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2858,7 +2858,8 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
 #define FOLL_FORCE	0x10	/* get_user_pages read/write w/o permission */
 #define FOLL_NOWAIT	0x20	/* if a disk transfer is needed, start the IO
 				 * and return without waiting upon it */
-#define FOLL_POPULATE	0x40	/* fault in page */
+#define FOLL_POPULATE	0x40	/* fault in pages (with FOLL_MLOCK) */
+#define FOLL_NOFAULT	0x80	/* do not fault in pages */
 #define FOLL_HWPOISON	0x100	/* check page is hwpoisoned */
 #define FOLL_NUMA	0x200	/* force NUMA hinting page fault */
 #define FOLL_MIGRATION	0x400	/* wait for page to replace migration entry */
diff --git a/mm/gup.c b/mm/gup.c
index bd53a5bb715d..a4c6affe6df3 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -943,6 +943,8 @@ static int faultin_page(struct vm_area_struct *vma,
 	/* mlock all present pages, but do not fault in new pages */
 	if ((*flags & (FOLL_POPULATE | FOLL_MLOCK)) == FOLL_MLOCK)
 		return -ENOENT;
+	if (*flags & FOLL_NOFAULT)
+		return -EFAULT;
 	if (*flags & FOLL_WRITE)
 		fault_flags |= FAULT_FLAG_WRITE;
 	if (*flags & FOLL_REMOTE)
@@ -2868,7 +2870,7 @@ static int internal_get_user_pages_fast(unsigned long start,
 
 	if (WARN_ON_ONCE(gup_flags & ~(FOLL_WRITE | FOLL_LONGTERM |
 				       FOLL_FORCE | FOLL_PIN | FOLL_GET |
-				       FOLL_FAST_ONLY)))
+				       FOLL_FAST_ONLY | FOLL_NOFAULT)))
 		return -EINVAL;
 
 	if (gup_flags & FOLL_PIN)
-- 
2.33.1

