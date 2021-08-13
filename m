Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAB213EB3A1
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 11:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238741AbhHMJ4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 05:56:18 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:26538 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233222AbhHMJ4R (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 05:56:17 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17D9q8f9000594;
        Fri, 13 Aug 2021 09:55:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=N0jjRAcqOAmIH7H56qUewV3eIR22IURT1mXSOBCAsXo=;
 b=XjikVhW1EUHxF7zXTqT9Eai854kIkIgqql03CnhcIXBa06VGsXZl65ybBjiao/m/tVUT
 WsSlz32O7geYDE76GsHJ9n5wot+A131qMF7hCg3Iev6nHgUVXgzQfRLvAJrb9IU9HN8W
 meGTWof5GQAsomaLy/zS+o+RogeBcXN5ZWzgO6sexDQ7VlderAg6nwHzVmVGYHOf8ILi
 YITK3aS+5M06xyAmTQ97i2lcYpzXiIu14k1QAY2M3YTUUEouQ2DPy/X4aGcr/ZqkpWYy
 k1431YtVa0/sAU8gdb0NEB3LGLhykC2dzaX2xBjeclnwSEOU8H+epXxIRxKMQhIjlEwm ZA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=N0jjRAcqOAmIH7H56qUewV3eIR22IURT1mXSOBCAsXo=;
 b=t/NbkslSMCD20hrw1tmkRsXdSiIRVtFk4LZaPSjkzoqjdjHLQjG/HFpkNDW47beZv9TD
 6yqAqp9RFCKVRfwJTe00tk8gBJyrhjz7NSNfpJ7T4q6wI1um6bz/IeqzYHe8T5qnnDVy
 lGrmhO7rgiAokEcNYQMQ+uKKNa1cRh+aDpf35igGSpalgH4156rHbJUXy0xGLJsJpk8G
 c3Ht8qlVrVrO07WZIxckqlPPZH/bzLYt/amjZO296+bhRRVzsy2QM/2ul9NRqNB3gKcZ
 SeoFbHgNjChLgn76xEJ+I56f+d8trcc6WjWhV8sZ20GLE2J88FwlWTghjMYW+OKT7n7j Og== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ad2ajjfta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 09:55:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17D9oZQv035899;
        Fri, 13 Aug 2021 09:55:49 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by aserp3020.oracle.com with ESMTP id 3accrdrqnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 09:55:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ivldzazIzN8yNgBj/XgnbE+bLdDXTo1+U8DNLe9FZZAL2HULF3HA2GNtnK5J+VwqYTg6A3NvowSG7QwE6hrT2rhWvFmzRtMVBJv/R42xD0xpQBo/H09frn40dQ+DX1TNMC7MYHVVEEE0vNTcRH+SpFhz0HI054Q4lrVHJN7pH4gib/MONksl6PIci5r9jyN9IqEDnyQ8+Zg5Max47UgIbtv3AUkSxTrcRVS6ykYrFlA+ihVNPX6kgGagfLjdYh5hJlczS3yjU+su0Wl5faoItXr7+cgqDvNSdxMoCXs1HUy8sK47flAiiw7LAIbJOuEObTVo3nY4WbYWLQ+IppKO/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N0jjRAcqOAmIH7H56qUewV3eIR22IURT1mXSOBCAsXo=;
 b=JGQHPDUa/kBOt0I5pyd+J7dNC3z0WoZwx/r6vHEBWLNQD7pTt0PK0AH/jChakkJV/o5n4P70226d0qxuAFT0nQasiUJVluQUIccDSFPf2e6ZKfmclO0QWtR+vKiZBqmKbWbBNTfOgXvALYVSVCYBT/ZAAjwLOW1NZ1cG+G9P2FtStJ4TyqoBb+X51L/+danWT4x/SFwh9Err98dW2BDd7WEVXbIRwFy+jK4Mowip4Fb6GqwlKZg41FY6OJR6gneo5cSZeaRnr8S4DxQ1NRRUS470C+Y5gj7B/uuHcH8qL05tDTmtQYU9DCjiC7GI1sDAIe1bfzGGG0Bisxz5eTZ/dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N0jjRAcqOAmIH7H56qUewV3eIR22IURT1mXSOBCAsXo=;
 b=KupKAkDEIJ0RCd/0d/1Po/+1DSEepD0Dj9lRbqBu1mdQEKvtiutJayhA2B34HUzdkFe7UOK/g33vWCb3DhmrDinhgNNaTV6YrR3YUI1xj/vptsCOozBZD54dFITS6pL6IMEVfyLHlldhaS/H1b+R8m57wH5p9Wsf+QpzK7onxaQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
 by BLAPR10MB4852.namprd10.prod.outlook.com (2603:10b6:208:30f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.19; Fri, 13 Aug
 2021 09:55:47 +0000
Received: from MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a]) by MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a%5]) with mapi id 15.20.4415.019; Fri, 13 Aug 2021
 09:55:47 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 0/7] make btrfs/153 sucessful on 5.4.y
Date:   Fri, 13 Aug 2021 17:55:23 +0800
Message-Id: <cover.1628845854.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0124.apcprd03.prod.outlook.com
 (2603:1096:4:91::28) To MN2PR10MB4128.namprd10.prod.outlook.com
 (2603:10b6:208:1d2::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (39.109.186.25) by SG2PR03CA0124.apcprd03.prod.outlook.com (2603:1096:4:91::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.9 via Frontend Transport; Fri, 13 Aug 2021 09:55:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 592d7da8-9e17-4d85-0f71-08d95e408647
X-MS-TrafficTypeDiagnostic: BLAPR10MB4852:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BLAPR10MB48526F6119BDCD6069EE29C1E5FA9@BLAPR10MB4852.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1417;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3OPoRpbIQFxapOy+S3Hg0o2/2a4ecnJhm235WY4KZf6pGDnLAwBnsHZvSwMJ9CWL/YUxrSUd1KFNlNPsbsBhvVrfMQMGk8bGTcklITzH/RJAo+Ihdqs4QV0GGbZ9OFj7EEpC7UAYzOPrShxowmNpqLV9LtahAwBvz4OOuWwM/QgAxLClBShYo/A5X4aOAbnenj5PsWEawg91KWxsaOpTPZI8p/YxAus3y/tjz4h90dMzmhposaozdUn+Fim7sF+wuULUu7CwXRv/NfrLL0zZzoen0F5cI7959nW8zPeJHLq7JvpB11CAhxYI7naQ4KL32tXjKPC3aTRTNxEnU1oFSeiw+vAeG1mDAynmqXrlhULJQN8dXQ1qXcVOSvb2kOL5fQyfTxI4B5em/845iQ3IzARm2my2uugfP9akPbhPePSG98ApAq9/Z6kctNYgqjv1zQYNtley4HMb7AlPNH3oDqhgCB6xGdyuIIIVbfteeY9Rf95VQV8wVJ+OsRM7YazMzFHjMH8p4UzKzygz8wHIr7wsYQUZaTeKOQyqI+OD5745Nvegyrc6GsDHqTBRCxc7f5hDTAWoaAMd/sE0rH8BgsA9hw+8/uhUSBrOUmAdy+43nMES+f1cKrTwtk27Krba9hzBIdzygoJREfHD97n2QGD4BZAojSJISRvqqGXj0ZzTimaM4HTRLScxCPkfulewYJCSm4T5NR/VpfxOy1kN0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(366004)(376002)(346002)(107886003)(8936002)(8676002)(2906002)(478600001)(316002)(83380400001)(44832011)(4326008)(450100002)(956004)(2616005)(86362001)(186003)(66946007)(26005)(66476007)(6666004)(6486002)(6512007)(52116002)(66556008)(36756003)(5660300002)(38350700002)(38100700002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+MvyrsbaAtCrtt/xmEKiHwgZIREUSQj3N1eAMaj/IbtPfkIdxLtqx+XQaaut?=
 =?us-ascii?Q?2jSbW/WorRjvKCakIHY6kSbl8LGT3u8o5UbvZDRLpvezyTQKTg33z43Dpzn+?=
 =?us-ascii?Q?X1rltqEf+sdFyfZ/qRXBvvMCV3HuuG2a4Wk0DnZrM9+8oaHN83DMZ4/mYt42?=
 =?us-ascii?Q?1ET8IAXppZDypTk/qJVkA7HkH/rx62QdGrb9g+mQphsIFaW5Zi169AN4I7UW?=
 =?us-ascii?Q?5o60BpY2attJIaeb0uGtSehxT7/sPVSp1LJVLzqd2omh3k81ETXs52V5Kv2R?=
 =?us-ascii?Q?Y6A5IeEeSOhFN1RC7bY8Hvn5o4IH5psTyLQBONNIe17GceY521t0Ffqcv/mK?=
 =?us-ascii?Q?qVgqMdGYZEaCqZ0wgsNAlJW27G8QXLrHxQgJZrKsYBzZxtAKs//FpRA8wVVi?=
 =?us-ascii?Q?rEb8iAdV8ASBHVUio2m6AWeSJT+XrKr9Z2C/dH5UX5gr4sGaTQnYe0+jnjeJ?=
 =?us-ascii?Q?hvRoqwTVmJ2DihPi3zHSfFiBD0N8PEAs5e+qnuBBfTPkcZq1oVESK6zKekOU?=
 =?us-ascii?Q?1YNMhSgq5212Kw8oa8pU+pFbCqvu8FZpC2dEED7tTH/wAO0oqHTM5R/KqVq9?=
 =?us-ascii?Q?bgArB+gyFEIRZtfN9SFCuseDJ+v3x6podAwQemaJiVW72uexEfEWXrUcox/6?=
 =?us-ascii?Q?/wI5c6iPOd9rPOXT/7+FlVkaV5DtrRAmHUt5xJtsaW2gzS1gNOLSmFZiVFSp?=
 =?us-ascii?Q?V+cW5Gg7IDDsAmY6FT/K4/JdT+HE14psOLtBZc+/h+th00X8IunGczZI9Ti/?=
 =?us-ascii?Q?xPwfDB3Qf6YSvIsJ6vCtuiexLEapPA0UdbgKqDyGRzawncLu1MtxqRMyNcgf?=
 =?us-ascii?Q?qrNGwrQvL/KGoSvCjk9bLBf5FBL+dz+r7m3iOfhdQK2es40y76QT/cCBZ8sD?=
 =?us-ascii?Q?c1j3515X+pdnohDSmlrjvrYYivCMKY7K/MOsT5gy1CIK59vjxV4Mji8X/375?=
 =?us-ascii?Q?eXBMxmL51orPq0OaK/+Mdi/0LgRV+SU+QxXaaC5Tpxoo1RezRi1IXTavIxAI?=
 =?us-ascii?Q?yh/maow+VpxZLG3A0r/igZKBwqaTrhARMizn3t8Z9EBSuoP1lTSRFYIKyxzu?=
 =?us-ascii?Q?F2YivEh+8DbtDTNVq2IWdLfCtNAE3UjyY7CSek0KS5gQ0aZpwjuAnVs5FMWw?=
 =?us-ascii?Q?o5hNyvZxlJ7FTD+spOj12p25PsvFvfPlng4wnPA6WHsvqFjQYZ/AIRW9t2T1?=
 =?us-ascii?Q?TFx9F6RuKM1cep/C67ZnJOvHFk2TxMuZjy+v7rVSFBySBhL7kfnK85UeutTu?=
 =?us-ascii?Q?3ovIUELLRYH0Y2CfTL5CXOZuAbV+qPcL+Elt3rFKRqt2aifUQ1+bFBfwuaHo?=
 =?us-ascii?Q?EPjlRrK5etZFz5ElUnQGspIW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 592d7da8-9e17-4d85-0f71-08d95e408647
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2021 09:55:47.6643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W7xMVDxHKWBEYS3tov3Elxw/vm6jfwkNlscWp7myU5xyxgQP8EOh8Yt7xjvx5aC8sWJif7+yDlxc2RdWmw/IyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4852
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10074 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=840
 malwarescore=0 adultscore=0 spamscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130059
X-Proofpoint-ORIG-GUID: GXQbje2TBrm3a2pe08YIu7pcmhtUnxy1
X-Proofpoint-GUID: GXQbje2TBrm3a2pe08YIu7pcmhtUnxy1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Patch 1-2 and 5 helps to fix the conflicts smoothly.
Patch 3-4 and 6 fixes the regression as reported by the
                test case btrfs/153 and comes from the below patch-set
                (btrfs: qgroup: Fix the long-existing regression of btrfs/153)
Patch 7 fixes lockdep Warning as in the commit log now reported by
the test case btrfs/153 on 5.4.y

Filipe Manana (1):
  btrfs: fix lockdep splat when enabling and disabling qgroups

Nikolay Borisov (2):
  btrfs: make qgroup_free_reserved_data take btrfs_inode
  btrfs: make btrfs_qgroup_reserve_data take btrfs_inode

Qu Wenruo (4):
  btrfs: qgroup: allow to unreserve range without releasing other ranges
  btrfs: qgroup: try to flush qgroup space when we get -EDQUOT
  btrfs: transaction: Cleanup unused TRANS_STATE_BLOCKED
  btrfs: qgroup: remove ASYNC_COMMIT mechanism in favor of reserve
    retry-after-EDQUOT

 fs/btrfs/ctree.h          |  13 +-
 fs/btrfs/delalloc-space.c |   2 +-
 fs/btrfs/disk-io.c        |   4 +-
 fs/btrfs/file.c           |   7 +-
 fs/btrfs/qgroup.c         | 308 ++++++++++++++++++++++++++++----------
 fs/btrfs/qgroup.h         |   2 +-
 fs/btrfs/transaction.c    |  16 +-
 fs/btrfs/transaction.h    |  15 --
 8 files changed, 246 insertions(+), 121 deletions(-)

-- 
2.31.1

