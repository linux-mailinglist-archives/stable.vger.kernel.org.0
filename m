Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1A751367B
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 16:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348166AbiD1OO3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 10:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348129AbiD1OOX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 10:14:23 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8136FF5A
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 07:11:05 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SBCnXX018532;
        Thu, 28 Apr 2022 07:10:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=eMDkGQBNa7hgVy9Y1iS/MobLGWjQN+yazfJbaTb+BTw=;
 b=HpV6yVnvt0kPoTgijgGqYJjEMRartzitmZ2O2A4DeUXCTsFkbCNzDKv+xc4+nnHvVjU6
 CJe9Mz6Bk7Z2KljAkru7mXnSnclZ4DX/b+2Nf4Qz1pSUV6q6POFLEV04/sEPuTEXkQQe
 AFPgYhD+MbCKpea+0lgUMcgigX2Va1xWvUAVpD0OTf4iTr0Cvi/jwGXDnE69ceNVfXf6
 foa+CPnrOI6JClC54BbZHcF5veTRXOh24XqahKMwdbfRQrvQg1/2Tl+N7rjJKcFu214f
 gNC1Kd87kOtfESrriQ1IY9kOGbDmULcA+Pu3W5NUstpT+49Kp8vGpgpuVl9u6wGWMxdO 2w== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fps57sdss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Apr 2022 07:10:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HXVr1cQqEWAP7NBbh0aWDOZkEga0v+9BMDaOjT9r9kJWM4eNUoa2FeEVg4fkmFLhjEkjGnHahGWmwNCWN1zRGk7jNjqVwwQvCJjTGLUlrzyJvd6n6atCDuJgL+TTBUx5VZfahQtRZn6cs7nh+ie6GdxieYGLzrHeBRIsD6fMu3xis2qCzpQsvrB5PH20x0Whh55PKB02VqMqOEE5a2rV9PAattOMAZzEGsGlXmlpJYbRoDfs6pKVj+kdtIAM1VPcDvpCXmuJXbpNKdj7GObQy68Fz89EuumAGYpMBn7lAx4pIKF+cpM2CliVng/6K9W4RolTrKujV/YMCqlu8NVyFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eMDkGQBNa7hgVy9Y1iS/MobLGWjQN+yazfJbaTb+BTw=;
 b=T9ZtxH5PeQm1RV7LQkGDl7iDh4SltQ19oZRQliIyiSaPurdPtrZUP3bYvmdb2P5ZLW6UsZDLWEFg55Re/OO7PNgaTBGPZPFwWhoX66i2GQfZ3g+blG/lFaHGZP6FAeT67JF61R4BSTwjOyF/eW1GCafhNY71db05QaUVGzdJWN9bnzlOVQ+nvvKxuufJBrrV6ktHcW0JCeIxsdL6prlidPeaxImdzGd4Y7WkSmkBmAmkriEiYWQGsnZSWwbqxDgd54sIEhyjGy1jkCyoFHQXtxU1yjHaJeD33EOYzCyWjUOjIUVRU7Ex/KcDKN14qVPdvqkoee5u2TfBHfRFR73YRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by BN6PR11MB1425.namprd11.prod.outlook.com (2603:10b6:405:9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 28 Apr
 2022 14:10:53 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::806f:3f7a:c1be:ff34]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::806f:3f7a:c1be:ff34%7]) with mapi id 15.20.5186.023; Thu, 28 Apr 2022
 14:10:53 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Lin Ma <linma@zju.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Xu Jia <xujia39@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 1/2] hamradio: defer 6pack kfree after unregister_netdev
Date:   Thu, 28 Apr 2022 17:10:31 +0300
Message-Id: <20220428141032.1026227-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR08CA0024.eurprd08.prod.outlook.com
 (2603:10a6:803:104::37) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 773f047f-c25f-437c-98c9-08da2920e7d9
X-MS-TrafficTypeDiagnostic: BN6PR11MB1425:EE_
X-Microsoft-Antispam-PRVS: <BN6PR11MB14255AEA54768CE5B26F17D5FEFD9@BN6PR11MB1425.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uXlZpYCJCgKIMz9TERBCRk8ZX4c9Xk4+8wUjS+dotW+bKkDhY+PJllv85nKTo74DkPWbWgpPNYK4rfJjTSDhmayuz1LTFPrFHmVqIxjSWa9M3XS2Y5Ra7KaiOr1WGCnWJY0vx8S+Ssr5DepRb22BMItUBg/bw4cq57Bk4pXvnwGHVpbT7Iu/LQh3kRcg9v9OL9njgm2X8BFlUqZGgXUC27fg/EWDrdI/TqPDwnTkx4n1auzCOVCGd4wC58tcU7OSgeoY2jZ1onEWMHliVpe+uOds7lV0sJWavZRuroViBefzwFJAjOcFJ9RJ1JhhyvMfdutsjKQLOOtkkwUQAA8Cs8lZjfnMQCbCCejdXM/JlOToqoTgCC5N8aJqIAHSsd5hP5E5gXeZaYEQnxM1eMhlp7LRzFjPxUdzJ7G6rLgy711ZAKHfxWTpED2pXz8al9xGbn3HbD0MCeLAnq5qxO3/N9edR68fZkeA9gl7t2Jm7mkgooBHd9sFcoOaS5+NqeWOMIFMHCASMEoQqeDyFbtzKp6tVg0kmIm2RC60wUKEx08vqTOHp7eKlOgIj5htWB5xJpP0XRMQQX9VvWS/ejGIeMGqh0jPbsR3Y58xeOkU/8QERAfQ8Kjo3kiND2OShhgzPgyTRNhRO9g2S006nHnJRuq76gNeF7eEARrCd/a+bHA2/vnRhxy/4JZ1s73nAEN0nAGcrKtfmjfBrkhfwa72HomwqUkEX6PkQKDhW3DNo84aLyyBT1C8rQJAXo45HC4PL9c1flyt+1rGvIuswSk/9v2QTo0FdU5vEfF/e63J6ewKQqHk7icv1izsTNPKRE+KZDXQa0glekGZqGuUj8pn+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(44832011)(38350700002)(38100700002)(6512007)(26005)(66946007)(5660300002)(2906002)(4326008)(8676002)(8936002)(66556008)(66476007)(36756003)(1076003)(186003)(86362001)(316002)(6486002)(107886003)(966005)(2616005)(54906003)(6916009)(52116002)(508600001)(83380400001)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R6Zn1ljXnQQIc9GKGuxmwFxGWlDyzOOQ4O9+EZmcjwm7C6J7g0J1z/Y9eegH?=
 =?us-ascii?Q?Ewoh6PnPgNHD4jrAjaTI94+GcKVSR6Fj1fZhr8EOHae8JJOYqaT67eElppTL?=
 =?us-ascii?Q?B/zzX5Q1+Mb6kFbvmgJELrFdkl7WvsSkSuJo1MYM3s+hQLnXeTIXfTWJARa6?=
 =?us-ascii?Q?6LoUfJirJs133e9ABRea5ezhhOSx34FZsPFsPRoravXiMQ7Yc1PBU7WAgn9d?=
 =?us-ascii?Q?aBAVp/4AiLGUJGxw5WBONQ1ve1kZyr1O3VzO0HoDHWsGjCN6tyXIpwbpVA2d?=
 =?us-ascii?Q?Q0wdf1bs5BRBeYPIdE5sOAvhRnx38GDp8A6dslnNQKk2aUfIV3wAWDdLk8Wa?=
 =?us-ascii?Q?QP9OnwPjEGZKlkMUQHN9Qc1Zhry2Iz+oz9nK43ppBAoSpSvmCelIYg9GE7ZG?=
 =?us-ascii?Q?89VCxpREQEyECL4zTm4Wdt/XxtYFRQOErSxwjubGfTVQ8vXcGMjEGacj405w?=
 =?us-ascii?Q?Q2pmsug8JUNtlOztlrlnWnZR1DoZNRcSVQwvzkursQhZtZb3AWXL3vPMO3iZ?=
 =?us-ascii?Q?NJThMsDS7VA01FKgHcX1kncpi2Yroh02T7vfSuQNmkQoo4ZzRIgEejLGdzGr?=
 =?us-ascii?Q?9LsdRyiHq5dHr8GQ0rBrpd4yIl+gx7ei7cJ6FHIWg7dqwCeG9aBwFedTa+9n?=
 =?us-ascii?Q?07s/X7gTxafXQiJtKPxgMnJdiDC4fMWwQpO78xzYc9vIuS7N5160fgaXDpq2?=
 =?us-ascii?Q?l9s82cafjuFcqf+FvXNrEZTsWaox6/lQtW0evXezlz4gOOlfg+VrtnAs5FdH?=
 =?us-ascii?Q?uqZGvypYhj/rRxm6KW/9jBzFgTCWgbrhAgYvpTSi4Di6AM6Vl48KTvz/iOCu?=
 =?us-ascii?Q?ZDXRm8Dkh2HrRm/lTFwFkj+pVejRJ0JFG8PXcAeghXcQeZkJ3x3nmVU8fG0b?=
 =?us-ascii?Q?CMnkD1ZcnFy4iTGgrCvOOLbZL25mqZ4g8Af8C2DKMTpRwwnH+w7OA8uEjnxj?=
 =?us-ascii?Q?MZfTAneP8WqQDE6hkNLE5hkz8IRV63fk2FKWrPSBB7hcRYxR5amwq/yFdrMx?=
 =?us-ascii?Q?HqT/vx7vFQ+qQ3Q/GFu9XOEOj3MU1gDrbp4JnMiyG2SWaohhdp50oDOs59TY?=
 =?us-ascii?Q?6pjU+fcVpFYu+wUn6qZKPvC0k0w/RN9+h7b7ieFU3OkjMf9vSp2/CkUT2pxG?=
 =?us-ascii?Q?VCufAS0uBR8cW4DaDwSNvhFcBLIz0L+vxPe2rhXb/HtZg/DkkN8DPKkjAZid?=
 =?us-ascii?Q?IFB5OO0DmNtnUFbzj5nZngCLSg/VDMkUuyxGw0oJRxJ3MApbS+ODXHT/PoNY?=
 =?us-ascii?Q?oaA5Dg1hV1Fvz6mViOCHfp73/EjQXHwrihtKZYFHRI04VfQAzgEzdepygeAG?=
 =?us-ascii?Q?o4VCroWAKWJP5tMv08mm7XqZPf2nGAKD90mVNNgplgwoO1HAgr/slUat629C?=
 =?us-ascii?Q?riGOxnMAXd39ji9JZ7OPuKYlsTb0wYNEkyH9e2zimS3DCSNEmbWOwSC5dbbT?=
 =?us-ascii?Q?7CUKIpKVtY89YMECQ1Lr3LDCbqtlAjqBuk24rUR7fw3OmFmIeDgxvVU5+BvK?=
 =?us-ascii?Q?1scLHWn6PNjyF9OSnfmTB202RyPfIU41wv4sCRFI2uuLEAbMen3q0nox7Lul?=
 =?us-ascii?Q?ieLhKCyNfeHN3U0gOhV3VzDV6mFspGC1HRgFcEV5RDzw/KJjl0XVQ5dPhhtC?=
 =?us-ascii?Q?8WeZWiMaiceethxiEVguw87aXWjoRVdtMSKXNfQAZ3Jdd2f7eGAGYedE9rKY?=
 =?us-ascii?Q?MsNDxhz00wcnlwwwUKlNyg10tMy4ATiMAdk3rQXkwcsmN3LYQgZ/XKfFrODt?=
 =?us-ascii?Q?6fYBmVrk//cB5EedOk0AvBDSOhjSmXY=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 773f047f-c25f-437c-98c9-08da2920e7d9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 14:10:53.3242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MdzhkjB77pl9L8274BTxpmIv9TDchuo8Q9iEkrCgw7kachGFB7tIafgwpG8yv/z+LvvYDaw/QdgctrghGSOKui631SXWWGcT5dUymhkepGE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1425
X-Proofpoint-GUID: atvGlhTz7RD9V2tkAWUSFKSeakdAfttn
X-Proofpoint-ORIG-GUID: atvGlhTz7RD9V2tkAWUSFKSeakdAfttn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-28_01,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 phishscore=0
 mlxlogscore=764 malwarescore=0 clxscore=1015 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204280088
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lin Ma <linma@zju.edu.cn>

commit 0b9111922b1f399aba6ed1e1b8f2079c3da1aed8 upstream.

There is a possible race condition (use-after-free) like below

 (USE)                       |  (FREE)
  dev_queue_xmit             |
   __dev_queue_xmit          |
    __dev_xmit_skb           |
     sch_direct_xmit         | ...
      xmit_one               |
       netdev_start_xmit     | tty_ldisc_kill
        __netdev_start_xmit  |  6pack_close
         sp_xmit             |   kfree
          sp_encaps          |
                             |

According to the patch "defer ax25 kfree after unregister_netdev", this
patch reorder the kfree after the unregister_netdev to avoid the possible
UAF as the unregister_netdev() is well synchronized and won't return if
there is a running routine.

Signed-off-by: Lin Ma <linma@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Xu Jia <xujia39@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
These commits are part of CVE-2022-1195 patchset.
Reference: https://bugzilla.redhat.com/show_bug.cgi?id=2056381
[1] https://github.com/torvalds/linux/commit/3e0588c291d6ce225f2b891753ca41d45ba42469
[2] https://github.com/torvalds/linux/commit/b2f37aead1b82a770c48b5d583f35ec22aabb61e
[3] https://github.com/torvalds/linux/commit/0b9111922b1f399aba6ed1e1b8f2079c3da1aed8
[4] https://github.com/torvalds/linux/commit/81b1d548d00bcd028303c4f3150fa753b9b8aa71

Commits [1] and [2] are already present in 4.14-stable, this patchset includes
backports for [3] and [4] (clean cherry-picks from 5.10 stable).

 drivers/net/hamradio/6pack.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 3d5b2b4899ec..7ff1c6f7eea2 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -690,9 +690,11 @@ static void sixpack_close(struct tty_struct *tty)
 	del_timer_sync(&sp->tx_t);
 	del_timer_sync(&sp->resync_t);
 
-	/* Free all 6pack frame buffers. */
+	/* Free all 6pack frame buffers after unreg. */
 	kfree(sp->rbuff);
 	kfree(sp->xbuff);
+
+	free_netdev(sp->dev);
 }
 
 /* Perform I/O control on an active 6pack channel. */
-- 
2.36.0

