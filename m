Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563C92B8229
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 17:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbgKRQqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 11:46:21 -0500
Received: from de-smtp-delivery-52.mimecast.com ([62.140.7.52]:23567 "EHLO
        de-smtp-delivery-52.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727117AbgKRQqV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 11:46:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1605717977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OXDAv8DY1+g8a2vDhDMFNStRlT/gXE2qwyIf7kBLCNE=;
        b=Yb/6IEpCsssRPwGwkzqZdAYy3vOOpApwFB4cgJlel7+gsFX09CJbE7auHJOU2n6njZrWEx
        YapsaBOrqEqL3pmCSMl+gmenzWelTXA8oqtSkStDyXndFc9KgvAhr8EKrzAgzudb2vrgkP
        Wle+QY2zSVhBLF6qSsy4Pc8O2aaTMgc=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2059.outbound.protection.outlook.com [104.47.12.59]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-22-p8rLQe32P26Cva9Usgj7Nw-1; Wed, 18 Nov 2020 17:46:16 +0100
X-MC-Unique: p8rLQe32P26Cva9Usgj7Nw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PHyHKzR6RtG2y8CTBbhSU4/qMk4Ad/A1D99VglwH57mSE1hMls2Nh2SORuLcVtdGdKUusoSV179ohSyL9ePItq3ZmA0NO3ma2pzgV13PZ1w7DpZbp62WCSwLuMVVkWCWQqPGZbUNx99VLDXbaEJXqSZdwXEKNKjklAumZvqIFNmM56fKFiUtQ8pqsZsAOz7hK0aQmQJoc6VZOkYFEhdqiYAOMzkOdAGID4j2eJoEg2qu8NSCeAS3+VNpDuLNMTvRPOM5lg+ccDFLUUXazyQMvJHMcNJXYKkiETHqE6LccLKTvrWbme8fHb6qiyKp2rQyqxtHb5vtovYixr0y3V2o/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OXDAv8DY1+g8a2vDhDMFNStRlT/gXE2qwyIf7kBLCNE=;
 b=VDt17XNRTu256NCO7vWne3506WRdvvicC4PhZuoHYeu3Djxlvi74FIW8zCOHcKWVpNvMoPDRtLQa4VM5Os0OqkI/q72rnqxhKSWaeOa+U+W3FZmXBHtQ5Eq10U0cCcOSGJOGlDh+3tZH7fW9HVizdRieePKUcUgm1J7Tm2QVv1zNM6z0EEvoKuH/xteYznkHdNUpnCn3hGhacoqr3alYoNNT8DceG6EtWf+tU0uzX4OIPJKb+91/cT7narnqPTgnIduIqGmB5X84hCgWNqh/v1gdD3t6fhyGRpYfbxkPCzFuN0TT+8+glkR8Adcq6QA7AMoAW4qemU73HXkhyBRZAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB8PR04MB5643.eurprd04.prod.outlook.com (2603:10a6:10:aa::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3564.25; Wed, 18 Nov 2020 16:46:15 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::1c22:83d3:bc1e:6383]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::1c22:83d3:bc1e:6383%4]) with mapi id 15.20.3564.028; Wed, 18 Nov 2020
 16:46:15 +0000
From:   Zhao Heming <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, song@kernel.org,
        guoqing.jiang@cloud.ionos.com, xni@redhat.com
Cc:     Zhao Heming <heming.zhao@suse.com>, lidong.zhong@suse.com,
        neilb@suse.de, colyli@suse.de, stable@vger.kernel.org
Subject: [PATCH v4 1/2] md/cluster: block reshape with remote resync job
Date:   Thu, 19 Nov 2020 00:45:53 +0800
Message-Id: <1605717954-20173-2-git-send-email-heming.zhao@suse.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605717954-20173-1-git-send-email-heming.zhao@suse.com>
References: <1605717954-20173-1-git-send-email-heming.zhao@suse.com>
Content-Type: text/plain
X-Originating-IP: [123.123.135.93]
X-ClientProxiedBy: HK2PR04CA0078.apcprd04.prod.outlook.com
 (2603:1096:202:15::22) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.135.93) by HK2PR04CA0078.apcprd04.prod.outlook.com (2603:1096:202:15::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Wed, 18 Nov 2020 16:46:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d17aa74a-47e2-4bbe-77ae-08d88be1769e
X-MS-TrafficTypeDiagnostic: DB8PR04MB5643:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB5643FFFBEDCD2179785DFC0E97E10@DB8PR04MB5643.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vqGoOwE+IPmx8krzLOia+OifJAhhnWUzX82VTLsJrzmTFrYcDDR83tiOXRgYNBP0nBX76fjbxriCeAiVWXwJ+3gmN6ZvjmPV+BLAZx0u/+7DsytnFJffHthrgddXkedsllo8eyGw+Sw634+KjkowtB40AYJ4fB6ARj7IdB39M4bmaOy0wd4xBtabZ0dKZQWoY/Ogei+UmPuU4AMI7EO/p061afAr3Oz6jkpx37O4ka30S3WCRMXQRg627fSeItE/PZl+BnOd458ewYypfqvRsLX5fdLULyde32H+Ae+sCALOlG/hOkkKucWK01guX0scahP6lMkPw/zvFVkMRNY2bn3bZA/hg8Iw9B2xY02H/5B3pyMHEHLWaTwgpVuWT9Jq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(136003)(346002)(376002)(6512007)(8676002)(6666004)(66556008)(66946007)(4326008)(16526019)(316002)(2906002)(478600001)(2616005)(5660300002)(956004)(66476007)(52116002)(186003)(8936002)(8886007)(86362001)(36756003)(83380400001)(26005)(6506007)(6486002)(9126006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: gTsQqaZ7hizvrdiUWvFOg/h9q/LLESzCKvkX+yFUSNd5pKb4R+1ZJxhhqDKulGteQQXc1qVekZK3jkxGk3A+Kf9OlbY4gecdGxqZJTLrHUxLlG5ymEV12LFO8NPZOwEC/hI9jiJqOQHP3rjJDl0c75gpxg7Jejqow/xWgUrwUQhYQ/a8CeNvldZiqAnaYzLHOyeuY2tdQ+eGQkHvN3R2BCIy8+AAy79WKZ7u2oya+xgG2OirBgh4AuIR6NlK+SpItdcch3Jhs1nqLNjpUuB8yJ7Q7varlZKYiQvGxkpHu0lTedcUCKe8o7zagJRQF3YHpponM72Lttb3oYbgFNAswftP4q6ZxSvwd8J2yVjR3vJwynupEwdTZCWLaQkEDKo6gpsuolZ/WrbQs0haxz3y5pWNY9FmCP3Z9p6zz2u3Ss2zEeCTftRp5f4PedISZBOVXIC1M8G+vN8XkGo578sNn2Ms/nSyj50OgqsVgvyRpkK/702PWieEEX476b5amN4Nopb7wuLqp59BvgrMK8xRIIE4w0Gtc+3TDxZnEkdPPrqbqZ7tOlkC/X2hAspsj6vJ/Omlr4rIQrbeVrTAjFmPqw1XSWV2QggnKpzciWagqKoKn4drihrOz5N6MJMbYuIt3TnviCW9wCYuXej22kauSA==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d17aa74a-47e2-4bbe-77ae-08d88be1769e
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2020 16:46:15.0272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sWxpI6OYgSPf8vOGLuSfjs9su/8MVYNxIaUtxieDu7abTHqnB1xMBag8uXRDseV4jKNrFdonALMUxJIdXpWTKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5643
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

