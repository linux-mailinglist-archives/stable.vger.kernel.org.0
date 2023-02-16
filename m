Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 176A5698C89
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 07:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjBPGFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 01:05:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjBPGF3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 01:05:29 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557CA36FED;
        Wed, 15 Feb 2023 22:05:28 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31G2KAct025733;
        Thu, 16 Feb 2023 05:22:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=u4iNwLWP426ed6jlxNmohY9sqxf7h5Q768RSUfPthWQ=;
 b=zAF3C1ppq6xL/2Kua4Hv73T1yeEhS+hKHGg8UZoHNsIbK2S72Qr7S/X+smS8LvEToXNI
 IMSSv05cdgCaSLVLA6n6ZTkzUfWQpbqN9aGMnfPzQN4RYvnXVXP7eTm+H+dqcajIWRSy
 kLc10yxwgU+qLv3OD+4CbzQV5BKTqbM7jxutgdtM6FBRZlv/hrfSKQOxg8PAQokl2nGp
 1ZB3BelrbCV5wIfugBXaoEVjvaf8dVFcEWvxSdKSWoOckpjEROfbBDJ3MoWEzbysuTsO
 zbVw1RFJ9/R0oCW2BVRV5m2+vbyuWeYlKHIfPmhbsQY67W4llYDe6p4Krk5seR+k3va1 bw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1m12anu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:22:20 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31G2noP5016800;
        Thu, 16 Feb 2023 05:22:19 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f85wmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:22:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kY77IjLYkJ+edZ8YumAM5xCF7bKgdgrb8gmhak5gJ/f/or9CZtz3PVdIuds3sVsn6aeUnucQVvuxuT1n8jGeL6YXh/xrfRUQGUy8qo5mfHg0u1GCBlR/22aHMsoDm0YforTjWEMloevjexmxhOLNi+q4rRQVn6ZtIejJPAb48zev8gjuc+BhA/QDhr4cETPpHq8jVf0gMkAdzvAh8MKh6Egww9ZwuqIS+EddWiGC3xhFo9s7cM4eESlcNeIKJ8vpJWKU450Ga7bsT1iw1N2AGnLmedowx/aQUQvVvZxW4ZFxJOM3M1Prx9BjCp0+lK7IsVlAOMCaGrg9V+5G8q0Wlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u4iNwLWP426ed6jlxNmohY9sqxf7h5Q768RSUfPthWQ=;
 b=H7FiKnzvd/r6lDO6lcBTvBERVwag3bpa1ei0iwVZ07hM2lTZSuzZbB2a/YoCF6DEwgwj5jevWE92NX2cXPwQzKp5B3iVZGaheV3yw+GbJdWQxkevf3GmioYkAZlx543f4911AkMnqsY/Fcen9DqCBarEy55ZKFXvi18KP96pXzz1Z/JtcKfW+4Z7XDhMuYayQVMxkg6HHRRirqC5dd5M82ZgRvJYP+h0dCqcSYnEgLxGS7GD4AQJGin4Asf2eDHTyR97Q6IUgjCHs8f3ZNIHB6/i2cmm298k9HzWykDGKFeTgHhYpQoAAyKbajdDO5BA+O2kGHG0I9RnRxX2Hxy7QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u4iNwLWP426ed6jlxNmohY9sqxf7h5Q768RSUfPthWQ=;
 b=JqKbZSIkFCAMQEdw3ZDstjMYb/XCUGEoS+Lv4rTUxwV50GOp+XcC+/XoQ2LOg6Ra820MjLh6lKDKb+A1x4N3p4MjeSJtOWB5qfrQPmftV7txLJHv24svnaZzimHKst4DB2+unE6WWMr5zIOEnnKXdOVKKeZMNFo4w3Npo9b4JBI=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DM4PR10MB6789.namprd10.prod.outlook.com (2603:10b6:8:10b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.12; Thu, 16 Feb
 2023 05:22:17 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.012; Thu, 16 Feb 2023
 05:22:17 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 15/25] xfs: clean up xfs_bui_item_recover iget/trans_alloc/ilock ordering
Date:   Thu, 16 Feb 2023 10:50:09 +0530
Message-Id: <20230216052019.368896-16-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230216052019.368896-1-chandan.babu@oracle.com>
References: <20230216052019.368896-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0248.apcprd06.prod.outlook.com
 (2603:1096:4:ac::32) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DM4PR10MB6789:EE_
X-MS-Office365-Filtering-Correlation-Id: 3907376b-3f6b-4a39-40aa-08db0fddc545
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1e4h9VpdROO48VhdpGQf33pKAPEe6S/8hgfvk8A0KS34ujnpV6d+Tm/Cmbsdu50LUlYZx37BpKWbBMv2eTXdy6gPT2H1PPO8S5t5EhMDychgS25zc2/Y81cdbC7BqN6njChaE95kHH+5Ctq6z06XfZG9Hvtu/LsPG81k6tdhTleE9fFVfmL55zX2hEJvEm1jisJD7lsb+DMcsubPt12piD1XJA5dUiK0YW8Ps5d/F0oNg0SFn//lpQNOX6y3nXvGFWo75sBTnDvXxc9kPOhaBH21rYWOIKC+fOW8LxBfNIS1R7YsEK0G5vp9IFUG3rKGqDTi629u7WMg22yFroX47y4fEqfu7g3mxA7XCb7Vxf1RcigQtsImORQdfoKUsqLwJ+sfZ2pJx7FeJLbMFkaaQ9q8VsQACxnBTiLr4h2SjBR8iMNKMUU0Uw2mB1Aprdqsnm0pR5EnZJ9UNUg7hq628/BIlhaeRc43l6M8Yz1U6OM1jIM4QI5OPJd5uB51idLE3MM6jsD0m0wVRFqWmPcwPiC7lp8mbaHm2c2k+3tw0aSV+6tEdHUCfBbB8MTA/xJ1llOhTfoS67MuOOP/cFd706RoFKzahjzE36dmP5huxGKlI3XzW0O1b8IV61EuC9A9jlABsvn9/PXgyjuOMhe1Dw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(366004)(396003)(376002)(136003)(451199018)(2616005)(5660300002)(38100700002)(316002)(6512007)(6486002)(2906002)(1076003)(6506007)(36756003)(26005)(478600001)(4326008)(66556008)(66476007)(8936002)(66946007)(86362001)(41300700001)(8676002)(83380400001)(6666004)(186003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?60X0mNQWSDZmk4A22xGJIWfKyfulbeZj3EQxZAuMXfKtmE8ezdZwfkbKSVyi?=
 =?us-ascii?Q?HfXUcqswk5CkeD7Gq6ue0l/A/2L4AQ6lSUAy255OrIdLKyC5b9LSBQHWHNTw?=
 =?us-ascii?Q?NlP4pHYNnyilIPd+LdriiSXGtG9LXS94Y3QXs7M1jiZlKh7zDvt1ijx2y7XB?=
 =?us-ascii?Q?3JYllL383CbSjxRANk6morw7Zmbow6yZNxzkj7krfjSk+UPO3FYqMgZx8LQ+?=
 =?us-ascii?Q?rjnhzQWKnk0TqRvnw9tQ5kRQxMvVjhOLUfxqP5KXxkyB5xtAjRPgu6ykukYx?=
 =?us-ascii?Q?SxFVRQodd0vmrctbanStPLhFYlZxr5Pg5BhtPickOeKXqZR+9XAttTNebJX1?=
 =?us-ascii?Q?B9No0Ch9cHM39ffy5M0arclRpWVo2dYaDESXlycrHKON9p/D26JFq7fTFfaI?=
 =?us-ascii?Q?ZCUl7rmnl2RLwn0cvI16yZpQZuVfTG+4c49LlUy/aN9KFGZ7bHMjybYXf/hp?=
 =?us-ascii?Q?n51o2pcdM6ZHp5+Qocw2CzDD0XzAVemAKjbnP9fCuYnMV3gOlR1HyLbdzIEP?=
 =?us-ascii?Q?i54mZuqHYOxwoFYglnAlzYSoqi33zMaYIl8KwMQEPR0Cb1uVMRvZHYe7abiP?=
 =?us-ascii?Q?/VJvjpNeCBC+myHQ/IqXLaRtJHbDQ6GTQlxZ5Aa0Ja7386NzOel4YuZsW5nr?=
 =?us-ascii?Q?TObrnebGIsMqMfdZAMwppg2k+oo9Oz+vyw88p6hn8WG9RUzWv59BwX0ob/tL?=
 =?us-ascii?Q?Xb2y9utEVb3aAVGyPY4/9tTkXQqBdkAFc43yHVlXdTA/+oqwdVZauNSMfaKE?=
 =?us-ascii?Q?WIZlMRat8QWfDwcv1/SWHBUxLW6PW6oHBHrZ37RzoQAXIYhE60MbMo22iV/N?=
 =?us-ascii?Q?FZ0KxWI6asCOZlc2GvZhSbSi4vARoT/KWh+zsnisU3erLqyeVjWX5yWI/j4P?=
 =?us-ascii?Q?gdt0ueTeAHU3ER3URhscsvVTPz25LFsLOGbLyNupNq6SoUg87UqIXAjlLvmG?=
 =?us-ascii?Q?hTPDL8+OlWF4CnVLK55L7dv2Rt2eSpsn74Wx2Ll2wJBAlfTlJlbLarECRPTj?=
 =?us-ascii?Q?kNMCUxl4c3ePsKA0qb9KfZvwRauujxBgdcOBmEp74yRy0YvUi7guRUXpzE17?=
 =?us-ascii?Q?UpjwNaUxOrRVN1sIH1OHO1pHSTwx6IEOM2CfewyLD+jFHh2yXSdcuSUoPsCR?=
 =?us-ascii?Q?SuiGwkiBcijTPwUq9IcgC3mH8B/kwS5mJNmCpSRBQwHZIQk6ESWlEwrk3eZN?=
 =?us-ascii?Q?D4ZAGuz2QqTBHBJi0SI20bDCzWnGYdcC+l1MInvw06/q4ae8aCUFqv2LcvnN?=
 =?us-ascii?Q?GTMtJXeSfeJXFKpuwy90x211BccGvXgjizTtGfhNTNAOXJrarLOzzBJ1Bbgi?=
 =?us-ascii?Q?Uh4Bb73Ky1sw2hYTxCeI4g4Y+SihZP7sX/MUJE3cVYABXR4yZJGZ4QLRQm/d?=
 =?us-ascii?Q?rmPdWzhgOmhorLWtm4M1PkEJxeOxXWM7wWovAlBYJMPji2f8wAnNyBX7wyoz?=
 =?us-ascii?Q?54Ynk4LU1FfqwQUoXF3VOdzPEM3qDPZXfsRrkUg6ILnVBrhD6XIi6ZFkV8mg?=
 =?us-ascii?Q?zzZ7Rm1NuSgQt54EIHLB2rP3DxYrlU5T6vmr+3DfoJPKd5obuKTrdt10FRvt?=
 =?us-ascii?Q?MN1vWz58bab/Z4ms09b8XEY2WvmXn45xHt9YWgCnbORrK2GLszR3VrgPaemm?=
 =?us-ascii?Q?sQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: +/BR6QNCmmdflOPn67/nxUSqA134Vc5lMBUZ29Fx16x9tlgd3wCO9X8/ulVc4z725514ai5zPTRa4Nuu0tCw0sp5DE5b3coaY3sHJEGk/rao6Umxd46Abl56qOaWhvGPgSdkQbCJvYoBT0G7ewx4TfK5mH4IsLdPJBiFKvzONFgD2h4866upznJqAqf8jaV3Dbmgnz+uSGS0bZjFG2NNkYpvc2fBU13WjgN1bqUsHHqDvqRPdnlycc40cnK2BtEA5Jj8nqNkSsy0Xbe/tFb2mEyZLJAr9PMsE16Juxssny2MTimkK17q685mHDXaGqUW63oubgcZYl6VBWdvt2/iSa/Bwud2GU65l3cYBbQs5jeLKhocrUIQPgyN2GVH32bExNKBTtVSCHxE0jcariCaRKIUuYM061DQEdeLDxfIZ5M2kNFzN054/emLjXgqQ5d3x178IltnukX7diLbau/m7uu3ebzwfepNsxjqPmZRQ+YEr7XfYrfvybepBp5ncRm6MbjEDYIDoxmbxWoKKOCjXBixUk2wCijxxjhLWyageKcqEdi7coWhWBV1wTdymu4zJ9paLgGZrESWWSYmbewX9C+Apk+p1x6zPLPrUOJvOHOo2mwnnNmHxBb0XwtwPBJZ5Q4OmxYK4WkCZ5EeTEBfPnwGxW4MDegwIp5kkzK97kHtkWHNZ218Kzs6m/kKCrv1cVzLoZr7uzt2Qg2FzfPDPxuIAQ9kmHHxlB45iTMw634/QTL/nvRtjJMGXHzgyRuxahiQj2y73/NiC/QUvprtmBAvgpDtP1rNkCjrHwotXmu7Ce/W4viF06fc+h7arkPD4OwZ0lsZMh50mqa9tkVoHF9yO02GPPYpWFSAh1TwSnCEtxoeZW9r3mA3zdUQmTPm
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3907376b-3f6b-4a39-40aa-08db0fddc545
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 05:22:17.5989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g1Zf7+thbK47W3yBupvoqReqA4tOXStIY7b+a8OKOJrDxR/bdArI6pWN5a5NqBasaClkskvuJ0mWtx4lAimN5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6789
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_03,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302160043
X-Proofpoint-GUID: pE5xCstmUAelaSUfl7kHragjWNgXzp30
X-Proofpoint-ORIG-GUID: pE5xCstmUAelaSUfl7kHragjWNgXzp30
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 64a3f3315bc60f710a0a25c1798ac0ea58c6fa1f upstream.

In most places in XFS, we have a specific order in which we gather
resources: grab the inode, allocate a transaction, then lock the inode.
xfs_bui_item_recover doesn't do it in that order, so fix it to be more
consistent.  This also makes the error bailout code a bit less weird.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_item.c | 38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 381dd4f078b0..f7015eabfdc9 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -22,6 +22,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_trans_space.h"
 #include "xfs_error.h"
+#include "xfs_quota.h"
 
 kmem_zone_t	*xfs_bui_zone;
 kmem_zone_t	*xfs_bud_zone;
@@ -488,21 +489,26 @@ xfs_bui_recover(
 		return -EFSCORRUPTED;
 	}
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
-			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
+	/* Grab the inode. */
+	error = xfs_iget(mp, NULL, bmap->me_owner, 0, 0, &ip);
 	if (error)
 		return error;
 
-	budp = xfs_trans_get_bud(tp, buip);
-
-	/* Grab the inode. */
-	error = xfs_iget(mp, tp, bmap->me_owner, 0, XFS_ILOCK_EXCL, &ip);
+	error = xfs_qm_dqattach(ip);
 	if (error)
-		goto err_inode;
+		goto err_rele;
 
 	if (VFS_I(ip)->i_nlink == 0)
 		xfs_iflags_set(ip, XFS_IRECOVERY);
 
+	/* Allocate transaction and do the work. */
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
+			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
+	if (error)
+		goto err_rele;
+
+	budp = xfs_trans_get_bud(tp, buip);
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
 	count = bmap->me_len;
@@ -510,7 +516,7 @@ xfs_bui_recover(
 			whichfork, bmap->me_startoff, bmap->me_startblock,
 			&count, state);
 	if (error)
-		goto err_inode;
+		goto err_cancel;
 
 	if (count > 0) {
 		ASSERT(bui_type == XFS_BMAP_UNMAP);
@@ -522,16 +528,20 @@ xfs_bui_recover(
 	}
 
 	set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
+	/* Commit transaction, which frees the transaction. */
 	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
+	if (error)
+		goto err_unlock;
+
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_irele(ip);
-	return error;
+	return 0;
 
-err_inode:
+err_cancel:
 	xfs_trans_cancel(tp);
-	if (ip) {
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		xfs_irele(ip);
-	}
+err_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+err_rele:
+	xfs_irele(ip);
 	return error;
 }
-- 
2.35.1

