Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4292B914C
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 12:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbgKSLmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 06:42:25 -0500
Received: from de-smtp-delivery-52.mimecast.com ([62.140.7.52]:20047 "EHLO
        de-smtp-delivery-52.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727122AbgKSLmO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 06:42:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1605786129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Gj8vZJXaQr5AXBTfALZR5rIPPYooNAU51tgpCsHANks=;
        b=G3Hzo8ryZ0J0Qeqd+pN7QeE3aRRixAOgYIhi5o9U+m+ETAc78FdlU7fxoH/A1v/RYGF9XB
        +o9ag1PnxZz47C+GFnOHjMRl8LULzZnN4ALLKz0Px39dV2UcF5HNBEUkRKz+iKf/7Cru69
        ZYoDAVHz8lniKkqGX5OJcjwYwMUVCXw=
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01lp2058.outbound.protection.outlook.com [104.47.2.58]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-22-MmgxEUI2OkuxF-3Yr0BOxw-1; Thu, 19 Nov 2020 12:42:07 +0100
X-MC-Unique: MmgxEUI2OkuxF-3Yr0BOxw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQkzwC1C9x98q5kfb0otw8WF/C4i1OGKnqrCzLp+OWn/tSOcImDWcnIcsNfwqdtMWdrDUMMDm+8YNMFA13DLB2wR0m49/GSKsWxTxmKQU5oq/es8jd2bVtem5n8HlVRV5muWaJBd+xlm5xZ3opL8TW7V9Gbpg/d06A+N8SINEqVI9GPzjrS4DBkrFQJmgptn7eUgWT1MHQIzk8yBfIsH8uG8e2fWObeqG1HY3JThBSuPhrIFDiKEkgoh1YlkhA1/XK5QEXnQdrwD4lPb+Ye0x3OZgC8NBM9QngrojhqocriBzkjoOw6BeyAoGwqT7q8IjqDgqXeKK7Ln/m/6Rqaq2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gj8vZJXaQr5AXBTfALZR5rIPPYooNAU51tgpCsHANks=;
 b=UUqdCDDYEHebjq9GOegWNs9q5xbzbJWIO2DXFGUVNHgRXfiPBTKs58fdQFOqSk/cZmLILRoyxP7IYt8rNvNI8I4jzHMNn83GSDlS29cBs1YtHFy57cUp8hAhSuwJkJbsZVcs9ufEZBeD6j6tOlse5gHJxqjpWIzUJf0YtfjTL4JsEH3nb8Y7+8KMJof0wT7ouou7txHhzCdwRANMp9Dd2jhe5dZH2GV7p0doCPzAh/tOx4dWkGlJNLiy75A+2Q0vjsg52bqOI7/jfO8mb6JJQpnYB7PtntDx5Dc1YTc2vTVJI6Wp3U+sy7vDdRIfuULiPs0dggXJ1L8/FNNMMoveVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB6PR0402MB2806.eurprd04.prod.outlook.com (2603:10a6:4:97::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.20; Thu, 19 Nov 2020 11:42:06 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::1c22:83d3:bc1e:6383]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::1c22:83d3:bc1e:6383%4]) with mapi id 15.20.3564.028; Thu, 19 Nov 2020
 11:42:06 +0000
From:   Zhao Heming <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, song@kernel.org,
        guoqing.jiang@cloud.ionos.com, xni@redhat.com
Cc:     Zhao Heming <heming.zhao@suse.com>, lidong.zhong@suse.com,
        neilb@suse.de, colyli@suse.de, stable@vger.kernel.org
Subject: [PATCH v4 1/2] md/cluster: block reshape with remote resync job
Date:   Thu, 19 Nov 2020 19:41:33 +0800
Message-Id: <1605786094-5582-2-git-send-email-heming.zhao@suse.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605786094-5582-1-git-send-email-heming.zhao@suse.com>
References: <1605786094-5582-1-git-send-email-heming.zhao@suse.com>
Content-Type: text/plain
X-Originating-IP: [123.123.130.58]
X-ClientProxiedBy: HKAPR03CA0033.apcprd03.prod.outlook.com
 (2603:1096:203:c9::20) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.130.58) by HKAPR03CA0033.apcprd03.prod.outlook.com (2603:1096:203:c9::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.15 via Frontend Transport; Thu, 19 Nov 2020 11:42:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 655b189c-2ed8-482a-75c3-08d88c8023b8
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2806:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0402MB2806FB2A682F739CA9AE54DD97E00@DB6PR0402MB2806.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M14iex3rx5Hl7FN8R9w9DkLDg9VQxIGQgJ6tz8azgCT2ecRs9qqyDbwTRTQy43GEbywJDyPoN1GogtN/oi/RA4LhtKL+XAiHPimZL7+GRgRpBIUQxMOMPCwwBZcXm4GoRTdR7PWhiJMS1aEG31zDS+VkA0TXnfeKGDZEanYaFbHK2PcuFhvX9q7yPM+s3btZ1LGC0ABi4jPzDF3w/+BjkB7AZtDgd+0Jp/K7mnSqMBWj5Sx26Cq9cPztWwl2GmMoIuEPkGhzjzJLZ6Ec4UJV0QLURb1tg1yFd44k5cdmaG+QM9aytnCnV6YMWrz8oIoPJUDh34JmkNadJz5EXBKQUkXQIv73epcv5MamL3A+p5Rd8oi94ib2zpRvBNqp0J/J
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(366004)(39860400002)(396003)(86362001)(2906002)(6512007)(478600001)(5660300002)(66946007)(8936002)(66556008)(52116002)(66476007)(6666004)(8886007)(4326008)(16526019)(186003)(8676002)(6506007)(316002)(6486002)(956004)(26005)(2616005)(83380400001)(36756003)(9126006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: r2Yc9foolCZNwvWYF/iPcGIdgAikzCFyeCrjmPna0mTVoGa4psI52EBkW9L165J3cI0EIspO3A4ic7S2VaE/j3QYkCvagcK6qKSleG3ju9WKUG9QyYd3TB/1SpcUKEXCSVnhtyoH6Ycmrg0RPQHJlJnoQSyVJnjlXP6jmtRFIlQ72uYNOLl85klYX88ZO6X3nCeAFPWML+Jhmv2ZCOVQ2/HHyWJotJux2Tz8NtIqBFvaQW0DUjsc2IuQ+oHVopS1GHOUKw+kQpYYNjN5ZyroW+G6xIGHGPDTm3D2JXMWPCwowsLhdQgIt6ARIQdkiLs9oLDnjw1FIyXZgFP+cAIR53u2QpX2Z0drtO3MxaSWlS0jiP5IaVf9Kljmoh0cMs/obkY8nI46oBLB0ycdO+Pa4+bDKLRbL4ZKDDmiMl7VicCps7tM7wjWmE7u8+ILt+UDdfcJaNIA5Ii3ak/2aF8DBtDKcPA4msVfC7Lris2Z8Pi+T6JHrH4I8/F5RhLfOJ8AJhHwCkUl82Lp7tJrC2ZqUiIoktoq6zKt47mKWr0Vhqa3Ep4lokIlJ1TOrGhqUrEraugWP/WaSBcLANZNMos/SB9XTvxifQmJjz99jognJKSOzUORJMF7H1qzYcFgKuXX02LMe+G2XhzsVUhQyy5goQ==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 655b189c-2ed8-482a-75c3-08d88c8023b8
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2020 11:42:05.9606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MsgR56lPvYO7IaE86G4mlFUS2IeG9dU++Z1cjw/d0QffXm39aZLigFB4F4SSYh8DOPQ21mbkI5dPRascHCSBqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2806
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reshape request should be blocked with ongoing resync job. In cluster
env, a node can start resync job even if the resync cmd isn't executed
on it, e.g., user executes "mdadm --grow" on node A, sometimes node B
will start resync job. However, current update_raid_disks() only check
local recovery status, which is incomplete. As a result, we see user will
execute "mdadm --grow" successfully on local, while the remote node deny
to do reshape job when it doing resync job. The inconsistent handling
cause array enter unexpected status. If user doesn't observe this issue
and continue executing mdadm cmd, the array doesn't work at last.

Fix this issue by blocking reshape request. When node executes "--grow"
and detects ongoing resync, it should stop and report error to user.

The following script reproduces the issue with ~100% probability.
(two nodes share 3 iSCSI luns: sdg/sdh/sdi. Each lun size is 1GB)
```
 # on node1, node2 is the remote node.
ssh root@node2 "mdadm -S --scan"
mdadm -S --scan
for i in {g,h,i};do dd if=/dev/zero of=/dev/sd$i oflag=direct bs=1M \
count=20; done

mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sdg /dev/sdh
ssh root@node2 "mdadm -A /dev/md0 /dev/sdg /dev/sdh"

sleep 5

mdadm --manage --add /dev/md0 /dev/sdi
mdadm --wait /dev/md0
mdadm --grow --raid-devices=3 /dev/md0

mdadm /dev/md0 --fail /dev/sdg
mdadm /dev/md0 --remove /dev/sdg
mdadm --grow --raid-devices=2 /dev/md0
```

Cc: stable@vger.kernel.org
Signed-off-by: Zhao Heming <heming.zhao@suse.com>
---
 drivers/md/md.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 98bac4f304ae..74280e353b8f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7278,6 +7278,7 @@ static int update_raid_disks(struct mddev *mddev, int raid_disks)
 		return -EINVAL;
 	if (mddev->sync_thread ||
 	    test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
+	    test_bit(MD_RESYNCING_REMOTE, &mddev->recovery) ||
 	    mddev->reshape_position != MaxSector)
 		return -EBUSY;
 
@@ -9662,8 +9663,11 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 		}
 	}
 
-	if (mddev->raid_disks != le32_to_cpu(sb->raid_disks))
-		update_raid_disks(mddev, le32_to_cpu(sb->raid_disks));
+	if (mddev->raid_disks != le32_to_cpu(sb->raid_disks)) {
+		ret = update_raid_disks(mddev, le32_to_cpu(sb->raid_disks));
+		if (ret)
+			pr_warn("md: updating array disks failed. %d\n", ret);
+	}
 
 	/*
 	 * Since mddev->delta_disks has already updated in update_raid_disks,
-- 
2.27.0

