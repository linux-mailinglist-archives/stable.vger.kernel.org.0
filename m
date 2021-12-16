Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD00C4772A1
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 14:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237207AbhLPNFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 08:05:17 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:43384 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237233AbhLPNFQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 08:05:16 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BGCUBI1011745;
        Thu, 16 Dec 2021 13:05:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=zC65l+39CBCp+dw1xl4cUd5wrd9eoBwoj1+w3rfTY2w=;
 b=htJYZy0LsdBSmjVmMRi3/K15EM8iH34wSWtRFlQc6V7Cbs4stdcd/VzA0hd2V6W0PqA8
 1WT27oB893UUi/0J9qxAEYkLKAT6d/M3dnLz7J3G3DY3AEC7av6I2/+4itqYipROvul0
 45LzJnNLv4aeTEZd5t7x1kTjl9W7Kl4Y08JIgnkqjjimK29tQcPWLoMtN1qwhUi1sHFU
 mKJdXPHuQAhuQ1iQ2lCzrr8HnZDcSA5Q/1xDMR2qoAz3akWkH3S9dBiypc4puYSsJMYz
 rih/92ntWhitFOMupMqV/6Jr+a4Ny0WtRBw2H8Rdh67mFrE/asj7AzfBaDndLUVuNgKH uw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cyknp2p14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Dec 2021 13:05:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BGD2A07168854;
        Thu, 16 Dec 2021 13:05:12 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by aserp3030.oracle.com with ESMTP id 3cyju9uj4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Dec 2021 13:05:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QFwmGowIOB1DeSrIjYE1lhiW1IaCOiWMP6/HnjR9RiEkV55Sm3Ni1en1j9dNVdNjCsMaNzzRsiT2c0uNo55not46GlUB02F+towEVRuwhAyo/hFPOpKMyXZau0Jssehb765ILLqD5Z5mstPt0jwcaaN5/8j6EE4fX7ERl+05ZXLdevdDBbslfKDy6dxLduGHPXoqbXiDykvpd6acVaDDmUtHiFLRykMn8jiNRAMyamDuKZN9QlMNkxfrLFUOVBUmk+ABUhK/WKtLLt8PqFFnvGb3n87A7/Zr0qE2634ahrZstULsAoexIIcBaTzcg1fYTCoawiJU4pCdkJe0fgZF8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zC65l+39CBCp+dw1xl4cUd5wrd9eoBwoj1+w3rfTY2w=;
 b=LIhrUGbpgt+E+gmpuGkK0a1BaaOMXU2uIDCzCRR10Pi5HBeTy6lN6vXg7IZy66T5WMaqbzvdHbbkzv9EDKIVDG+lXAQK3d+DJjV3NnWC5RFhEh9hCub1iyrrRJikJ4cnO/A0EEw/Mnz1V7B6KVIEGf8Ta0+6+HOK188l634OVLAUx0uh9h83sSOAKtmUdQxIQKpxkqIdB+xv71u9juhpARIADdrtmlNafu2iJjwZenKrh+MLfT+epdo+up9RTy4AUOFfPmN1g+yIAxyKCArIZeRAAQZ7MNfbjFet1DwnTS+iJBydihTV6rc0uS3Hx9wY4cteyJ98nklXPkhKv3QGXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zC65l+39CBCp+dw1xl4cUd5wrd9eoBwoj1+w3rfTY2w=;
 b=aIavBj+70TYhV6WTN/M/p8jfOw+So7UlZRezCHd9ab2jG24v7fQIpnX2FujPAvIPeaypkAIrFjJOapb1Fdpzhjt6Lq8FRHnE/R2IaymaVP3mnKEsV4fACQATd9sfA9+JsWRLh6NNnrTtiXpDNTHqEbmPp/kygaK071o3STBwqbM=
Received: from MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
 by BLAPR10MB5186.namprd10.prod.outlook.com (2603:10b6:208:321::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.15; Thu, 16 Dec
 2021 13:05:10 +0000
Received: from MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::f450:87d2:4d68:5e00]) by MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::f450:87d2:4d68:5e00%8]) with mapi id 15.20.4778.018; Thu, 16 Dec 2021
 13:05:10 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH stable-5.15.y 4/4] btrfs: remove stale comment about the btrfs_show_devname
Date:   Thu, 16 Dec 2021 21:04:13 +0800
Message-Id: <2fe0e10df7494300346f88470230a883f20753c4.1639658429.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1639658429.git.anand.jain@oracle.com>
References: <cover.1639658429.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0185.jpnprd01.prod.outlook.com
 (2603:1096:404:ba::29) To MN2PR10MB4128.namprd10.prod.outlook.com
 (2603:10b6:208:1d2::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5aae66f-a66f-4c4e-57e6-08d9c094b0ca
X-MS-TrafficTypeDiagnostic: BLAPR10MB5186:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB5186B7FD268296CE200FD70AE5779@BLAPR10MB5186.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:514;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RYJtD0PHlU4tan/sSCKhphglnSV7z7KqGlxgR8Pqx1xehsAtMrFgTeo3x0DVVWas1Iu3sozjuoPYVrWSLZlxqBTJb0ejy8chBqCzioOT02y9ZNtJpKucEpicO7lnopU6m/HUTQLxaagivrLqjcPMAfkbTCPM11+PV7/Ed805AEgwEkGnkceBxQwjOhKqNCLXSX63TnCooujqjXAXjKlgQpHOgVQYdlUrPIaA4WsctvQ5HqRUEEsYa5V1b6ML6eAAzbc4/J99JKUpoPS8NK8BpPKwEgL2CMqCSgq6mtIEkb/x4VTr4QT3MVFMIevjJN+YaVlkBJMSuCJOt3r5U1qneobbj1pubzwP46nGQCJBZ//zQGlPfm+VBuGdpI7KINeaeqGd0lQvL3KRv8mI6IrDZjrx4gCOfMNpUeoMr/b01GKmjVCcIJ57c/NraJWC+/Ls3FN1an8LXmfZdkrP/gD3ozaZK1CDZwGoRF3N6fo2s2yOBAaU+NQnWJ1Uvxs54nJ9qGsUn9t/MMc0cVrD10NmcwJPjs7kGYc0PFonxAopsgalMXgCqxzQ9jFVX9ZJhdUD0lHGuGdd1LQHlxu9ZaOrgGG4Cm108SIcSzTneM6fgvvKbrMCKUv0/nIP56T2bms+4hNmyLj1PgvyyxRGavDZUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(5660300002)(66476007)(316002)(8676002)(36756003)(508600001)(2906002)(86362001)(4326008)(186003)(6486002)(8936002)(83380400001)(6506007)(44832011)(38100700002)(6512007)(54906003)(2616005)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YgaKw6Hio92+RMqUNZdKjUWPSftjFJjeoGat9MgYr+cDvK4O1SxCfnsx8Eq4?=
 =?us-ascii?Q?1hV9iSgqwD1l26CvAv9Wr1SEFd2sRdCNbHXJO8K/aSat9xnDyqnhSKHeHA0M?=
 =?us-ascii?Q?VODy0M9Nw45WOaPGz9eC9CY2cOTroj/+BNLYoJ452ue8bziX/PlEJm4f8DB8?=
 =?us-ascii?Q?49wdH7g3OTzD0jrEC8YqG8piMwLot0g83aHFO2TSoCc4c23X5XZCUIh4kjQR?=
 =?us-ascii?Q?hzw4XXKQAB0297HbsSRAQwo/jdL2c42RnkOL1r4PZWGR6Ztevf/YZwWBKSi0?=
 =?us-ascii?Q?o5B65KMPzC4LP9RQb9OPHh7xcAObzaWzvr0eE4IyIY/EmbIDDwbtAZQbZp51?=
 =?us-ascii?Q?DHso8UfkqXv/20XrXpijpa9seUH65k9Co8IyY2NvgLSCYeQF9xmGp+OsOG9+?=
 =?us-ascii?Q?YXJi/Xu8JwWI7UlvTqOkgoVXP8X6f5Hg1q+aOCge/7kfT9gQ6fuUEz7IJp3m?=
 =?us-ascii?Q?sesAysJYoYTkZLDTcN0kir1ZYHm82LA6JLvzKFdc5w0H+WrhUXaZHh/kcrTE?=
 =?us-ascii?Q?cJ4d018gkN/zyrL6gjWOXoQP5xddlLO7AgN5cr26sTPL7ghvS7BWuNsUcsxK?=
 =?us-ascii?Q?OrxkDOFi+TjG7QM/Rv1Nr+eHioAPz+/UZla1MKFY0D4STtqRdLvIgSLNDgGm?=
 =?us-ascii?Q?39mASb4EL7cxIE7leYOSFfrYa4f4xJiklkh60OueHP/BOSVgFu36UDSPILsa?=
 =?us-ascii?Q?E6CJdYDX54fHaMU6MWjrrQ0j/iuyKFfp2zOvu2tYEUqKjqiStJw/xi4pwuRY?=
 =?us-ascii?Q?GUK8Yihj9pYqzwcJkVUxI7aQg3WNfHOqhY1lgWAao5Sp9XB4T6/83Ej284ky?=
 =?us-ascii?Q?8PHKzPptALXGcKGf3xnDda3Bt5oCvF9OML8qazn6VYm+HTy8nftFeIzW8pL9?=
 =?us-ascii?Q?52qqWU0Sq+D9rXVBWkm0Yp6sgTs/7ZzJo0mgarGYNq/4mphg+aefylUuKgC1?=
 =?us-ascii?Q?6Pq7fQdDNzEM7oFC0/DrnaM8i34s0CXghMKXDY2WXARO17sEnxpWKhZrj2Pb?=
 =?us-ascii?Q?Hqh8h57HzQaV7D19C6agruh2VdV3igLgh+L77pp0Y3RNZiype027uhijiw8K?=
 =?us-ascii?Q?a2JFt37NS1V3aIV/FJU6MjzkzeTmPdC4n5dfrymqIgBU7UZO0ddfC+iHhOoJ?=
 =?us-ascii?Q?m9VAkUq5qdgad0wTUppDz5A5rpr557uJTtxPvaZrLmnST+1zwFUj4gHFGCGD?=
 =?us-ascii?Q?XwmAIF5/hOXN+7AaxrVDyft7Wuy3rl2dDwdXk+qXyLzP4Y3wSAZqWqV06yiR?=
 =?us-ascii?Q?CyxsurNjUugP/WQ7eif8KKIg1qqcReBzNs/jUX+B6BtOASnoS/od/pTv7P9U?=
 =?us-ascii?Q?dP/fkREoNHa1MHRRegHF+iqkGknS6lwfZaw+3GCvw3X7EArz+bkvVaWz3pfQ?=
 =?us-ascii?Q?fMzNf+yiHSBOoR7V4vFjWkjS1Q7gNB9zxrOIqsxM2Srs4TKItLcPr5ipdVSB?=
 =?us-ascii?Q?0fperUfPJgbEgAXsjAHQUpyAIIW3bTdfswZB7OLlehI1PBYjofroN62kKAxi?=
 =?us-ascii?Q?GxT+WFganNZw9SyMh5BWTXjczbJoc77ivMLo1uKmyAzyYOMjQ9IejBjqbzTT?=
 =?us-ascii?Q?dzKF7X9ILDHoO62GwV2I20FpPJ64dOuWJ3DtOYzCpJo3l2Dn258MDi4nQfEH?=
 =?us-ascii?Q?3CzoIcZNYjUPeTzzOlEc7lmzcaLv8vbPvQqnBWrAg9iMfMnMwc2qMHp6LKPq?=
 =?us-ascii?Q?93e9CA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5aae66f-a66f-4c4e-57e6-08d9c094b0ca
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 13:05:10.4472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 67U9eUsBS/ji7+v/E8oTQRbpLGCU4KUYpeI/XmDz5Q5P3x64JWZ0EbPe1En7CTds30B3mESmEbP1dD+48PZGsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5186
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10199 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112160073
X-Proofpoint-ORIG-GUID: _GVqpNRuH99cqVxqWrQ8s4-XsVqi2t9Z
X-Proofpoint-GUID: _GVqpNRuH99cqVxqWrQ8s4-XsVqi2t9Z
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit cdccc03a8a369b59cff5e7ea3292511cfa551120 upstream.

There were few lockdep warnings because btrfs_show_devname() was using
device_list_mutex as recorded in the commits:

  0ccd05285e7f ("btrfs: fix a possible umount deadlock")
  779bf3fefa83 ("btrfs: fix lock dep warning, move scratch dev out of device_list_mutex and uuid_mutex")

And finally, commit 88c14590cdd6 ("btrfs: use RCU in btrfs_show_devname
for device list traversal") removed the device_list_mutex from
btrfs_show_devname for performance reasons.

This patch removes a stale comment about the function
btrfs_show_devname and device_list_mutex.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b996ea0dc78b..0f549d2681c0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2312,13 +2312,6 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_device *tgtdev)
 
 	mutex_unlock(&fs_devices->device_list_mutex);
 
-	/*
-	 * The update_dev_time() with in btrfs_scratch_superblocks()
-	 * may lead to a call to btrfs_show_devname() which will try
-	 * to hold device_list_mutex. And here this device
-	 * is already out of device list, so we don't have to hold
-	 * the device_list_mutex lock.
-	 */
 	btrfs_scratch_superblocks(tgtdev->fs_info, tgtdev->bdev,
 				  tgtdev->name->str);
 
-- 
2.33.1

