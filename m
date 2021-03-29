Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAEC34D1CB
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 15:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbhC2NuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 09:50:21 -0400
Received: from mail-eopbgr770138.outbound.protection.outlook.com ([40.107.77.138]:9188
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231506AbhC2NuN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 09:50:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZibXxSLUuFW+FugvPi9NxDFC3VrwbvuKSchadG4YEwQY0FsGTdv6V9N9JhHXUMxfSLGYc7JqCXTAWqs2EfdieSDY2poYZtThbhaM6gmQPIhT7YW6hE8rRBDdw5mgw3KFHqGrZ3O9RF0uSopGD1zluIPitGCGmdQWSyS1tEaZ5Mzumry+dqDTVWj4KZ04YpHjzu86AytWgKiyJNmL1I61S8esUR2Bwr9ThzqMWaQt+G+km/7/J6+zTTYD7o62EzvToc0UzKcgGty9ZKRxmUZwiHWvnyhWr7gzmgJAyK28dUn456Z0NT7mdx14PnOAbDypvC/x+Bs1WXoHMo7DoMIYrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qx8wmXEuU9/a8MxgYOXWEQa3uXZ3ItLu3u6X4qRz16w=;
 b=CPNyH052bgLUQOfCzIZmSxFcBsHFhH9QLEnr3IR9lWiP0oI4RB3ZPI1u2Hg6CGCRO4xCOEEr/45zt2Jha2ckqHGPQx0kBhtUF3kEIeyJx4BqQWhJB4l3n+5utno9Zb8v4k3MGT7b0qmFZRPhDafKiVBWlbAx2COK1BPfWw7Nso1YH6LrIFqQpSLHViSX1gBjo4LzWteSGT/KJxLj+Mpa8jv4f6ItTpmvrTdss5r1YSgLEKXNtkGtcNan4cbT+rzuVwZeFtJ9Ee3dQg+cBTrPpUMjVwQS7DhgWmU9AvPB8GcnDG6scIDnGp4r5hY/1zSOljCuqyjyaSesDyK5pGAd3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qx8wmXEuU9/a8MxgYOXWEQa3uXZ3ItLu3u6X4qRz16w=;
 b=Efre1T2f3yL0oLzTU9+lFjgHCa73wJQUfG5zMTbmIjuzg2RJSLE/UciIiGP03UrP112wKSRsTpXZSranRaYZEOpmHHvMazSHKr7npSGq1kEBoAlUPBW70HrUHGH4aTHN91bpNoGFef7QtAasIf75S0wKPwYWhTeCNCq+uW3rl4uLfwBvL8CkspcdyE55ljqkJJ8KgOso8EWYkwVd7iH1LIPKHSWKyGRV4uDzzcMkobV7YSFZhDZfFCyJhGtNDmMke1Pq4JKY8pQRVwYaGkL76asJyCW0mYUqCXdvrfCYQOFk5+M+lG0JGUwb/AvF8r04f8UiNmEVDdXUYUi5zeBJtg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none
 header.from=cornelisnetworks.com;
Received: from PH0PR01MB6439.prod.exchangelabs.com (2603:10b6:510:d::22) by
 PH0PR01MB6294.prod.exchangelabs.com (2603:10b6:510:18::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.30; Mon, 29 Mar 2021 13:50:07 +0000
Received: from PH0PR01MB6439.prod.exchangelabs.com
 ([fe80::75a5:79c6:dd14:3860]) by PH0PR01MB6439.prod.exchangelabs.com
 ([fe80::75a5:79c6:dd14:3860%5]) with mapi id 15.20.3977.033; Mon, 29 Mar 2021
 13:50:07 +0000
From:   dennis.dalessandro@cornelisnetworks.com
To:     dledford@redhat.com, jgg@ziepe.ca
Cc:     linux-rdma@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>,
        <stable@vger.kernel.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Subject: [PATCH for-rc 1/4] IB/hfi1: Call xa_destroy before freeing dummy_netdev
Date:   Mon, 29 Mar 2021 09:48:17 -0400
Message-Id: <1617025700-31865-2-git-send-email-dennis.dalessandro@cornelisnetworks.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1617025700-31865-1-git-send-email-dennis.dalessandro@cornelisnetworks.com>
References: <1617025700-31865-1-git-send-email-dennis.dalessandro@cornelisnetworks.com>
Content-Type: text/plain
X-Originating-IP: [198.175.72.68]
X-ClientProxiedBy: SJ0PR03CA0052.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::27) To PH0PR01MB6439.prod.exchangelabs.com
 (2603:10b6:510:d::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from awfm-01.cornelisnetworks.com (198.175.72.68) by SJ0PR03CA0052.namprd03.prod.outlook.com (2603:10b6:a03:33e::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Mon, 29 Mar 2021 13:50:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 144cdb14-2dcc-453c-d80b-08d8f2b9903a
X-MS-TrafficTypeDiagnostic: PH0PR01MB6294:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR01MB6294EAF2D7D40CBFE3935F78F47E9@PH0PR01MB6294.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iT49MdTY8mKvefMpN1iLrK5EhqgieBEE83YtFPg9823rd8zDPyLRTTthsuyoKfyWCRzm0bg7Zkbopuea+CCzwjOAFiyA7Y91CXyUDjFs+jq3E1W+ZKKMQ1VlXYKYXmQiQnuR0/vb8bg6dslqaNCXtD1ruVEi1WzHsnkJ3uUyS5u1CIyPLZGoGjOFlwGQvOdF/BHpUKj87C1Awz/1Wk1ZdVOKk6Trid5hb08QsZaGw+Uzfd7opbohCNt1Jbgn83Q69BHfKx/ymitlge6l0ZcYCiSnotQ2mhIDYnyAAFbxmkPjDVPePytDZZqjh2YrfMRj9BbywP0XJxYH9Qk/remyE0obMXeb2XD7ZOmWM6sBvrcn1Kx7RNFT2THKKw71ZGQagXO3vbx3t4FktAwoGFNtmBPCdHCFpUDfEgHwdg7aFPoCfRGIAvm33KceUAERcnf1axeNKs0aCXWXGQ+th/tPIT1dIMgj/AoDDzCtFDJHtSiF95CIBt+ZVg+Yrc30RtPHRA/jKD2o2PsRl/3fnZAgFzCuTL/eI8aSgKdjJGkf23cyrCmYnunh30dOIxZjFME8HK4ii+eUdjQUG3kS5l2qw1NuFrQnhNvhvAM1yjj1+CukeaqeAqBLz9wgssrzVRokb74sUyMsJRilYR66VapYMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR01MB6439.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(39830400003)(376002)(136003)(396003)(366004)(346002)(66556008)(66476007)(66946007)(186003)(6666004)(6486002)(8936002)(5660300002)(16526019)(9686003)(7696005)(52116002)(107886003)(8676002)(36756003)(478600001)(86362001)(2616005)(2906002)(956004)(316002)(26005)(4326008)(54906003)(38100700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9mqmX2+/KruV7SphcAA9R8t3n7OTZRmM508XeBtwpOfcumgDPijSprfRrKW6?=
 =?us-ascii?Q?vRMTQ0is/2/2JUKB3Bu2XfDpryhTFWrkh7A36dAR6UQ4PO+cWKfr0UXT8KA+?=
 =?us-ascii?Q?7diVSrOpEwk/xF0B8aqp+bfmCZeJQ/ikJ7smvp84XdHkk5l4jAgVkUJR58q0?=
 =?us-ascii?Q?lohkleRb0d9S0ppCABW1Q+pPUAvYkBnZfgExzmd8JVZB9NvGN/DLtrtko90+?=
 =?us-ascii?Q?XqdXLGpIuCZhpsuJA6CkG5DzW3qVfcCjRl/VC31TTZs3WHnZRnXPp4BgD9Pw?=
 =?us-ascii?Q?SPjjel6AQu8jgr2Fz0Dj1OOaK08j5waypG0Ug2EL2SOerjZ2A7qjxtzasg+F?=
 =?us-ascii?Q?MRL8RggfIDy+2b8VBDXENz00msQpjsIG8jHKCYxci+aIVMaXRoNWQS2mHF6I?=
 =?us-ascii?Q?onDGvKXSyqWoJV5ZBG/BZNL3a1A9ZQ/QkMU5HiBQZaIdP+HST136u3KulxQt?=
 =?us-ascii?Q?0K0A8zxT5hbZ1tAuzN7oXkQdsNVF0kiJO2ShSXnviJQdCb0a4+AcWEEu3xMN?=
 =?us-ascii?Q?PxUoBJ5KQlAK7hyfEdh5VwT4Ksv9AlbxlCHdhjTiBp6g5Yua9DG8dCuaabf4?=
 =?us-ascii?Q?7ONcaqmiq+Y8fEa2J/CqyGhVeLQN7J84HzHxzKDkpNDqzkezxZoOpxfYxOCM?=
 =?us-ascii?Q?Ar9MYKr0xBAVCG8IlIZuLeFeHfBPZyBh6BsSgkueCQv1B64zhR5h1IpJg0mC?=
 =?us-ascii?Q?varcwzO/09K3YgQgw0TaRo5opSJACn9ZRScHqnOIb+/wD+nqkUJ0OT37P6S3?=
 =?us-ascii?Q?K6/9slCO610mhXn3ZMLweFgofI4rly6z7/Qixf8mWoiDyUrUU9hHG+deBix3?=
 =?us-ascii?Q?jsX+jqc3+yMT4zNLQCE4AKjCiXFydLwNYPYpjptGh0svLD68U8Jlkw08s3qI?=
 =?us-ascii?Q?jHmKbcu7j3TaXxvC/zHkcQkrfR+cQSOBvaAZPYddDLyFhqpcsT7T15MWG7Gy?=
 =?us-ascii?Q?+UcdUcgWuoqMF3EX/tXi0LSxe0MUekKqg0C8K0QqOQJIZ6bMIs97jFVibiy+?=
 =?us-ascii?Q?Kt4Tr6LeyoUyznbUvDS4EIIgYbMylJMIjr9i4cLQ3aY+5pAX9bnsQhUgZKWY?=
 =?us-ascii?Q?6fogKn+8FWUq8Ssul/PrKrxLiXyQhtpqwco6CvPQLBmt+Q/xQ+MpyauvaxtP?=
 =?us-ascii?Q?LdsdgsNIrTfdtaSdVzB5yu2hPbfLXDQeYzZOt8NjmEqnbZ3VwO1KQb4CQvfy?=
 =?us-ascii?Q?EvgGC+lzOiDFbj/ypAJ4XkWGBoBuI3eI4GSVVTVMR5KLRmTQ4VwEWfMaWxfc?=
 =?us-ascii?Q?vRHpWfU2u9YqWfurg+ptd/Sb9fLcqLhrLKuDg+OhQ14Nszy68Dzb2K6Mr0kc?=
 =?us-ascii?Q?+SAnJRkMqTnICNkRz3l4aQuT?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 144cdb14-2dcc-453c-d80b-08d8f2b9903a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR01MB6439.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2021 13:50:07.7314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ja+llhy7bijU/vBPEf5quTtJBvgYRQ/5SzbMDU1MeHFdP8kfYWSz3czr3noADBz76DHZzOCM5xjwfFH3jb5DPsza+w/zGGmxRAVi4PsaDawSObTTQ56zQkb2jOEA05F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB6294
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

Before the dummy_netdev is freeed, xa_destroy() should be called to
free any internal objects to avoid potential memory leak.

Fixes: 06bde82c72d5 ("IB/hfi1: Add rx functions for dummy netdev")
Cc: <stable@vger.kernel.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
---
 drivers/infiniband/hw/hfi1/netdev_rx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/netdev_rx.c b/drivers/infiniband/hw/hfi1/netdev_rx.c
index 2c8bc02..cec02e8 100644
--- a/drivers/infiniband/hw/hfi1/netdev_rx.c
+++ b/drivers/infiniband/hw/hfi1/netdev_rx.c
@@ -372,7 +372,11 @@ int hfi1_netdev_alloc(struct hfi1_devdata *dd)
 void hfi1_netdev_free(struct hfi1_devdata *dd)
 {
 	if (dd->dummy_netdev) {
+		struct hfi1_netdev_priv *priv =
+			hfi1_netdev_priv(dd->dummy_netdev);
+
 		dd_dev_info(dd, "hfi1 netdev freed\n");
+		xa_destroy(&priv->dev_tbl);
 		kfree(dd->dummy_netdev);
 		dd->dummy_netdev = NULL;
 	}
-- 
1.8.3.1

