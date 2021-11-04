Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0EBC4455B0
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhKDOwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 10:52:51 -0400
Received: from mail-mw2nam12on2120.outbound.protection.outlook.com ([40.107.244.120]:26784
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231166AbhKDOwu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 10:52:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GUnTgRdUyYGAFWY3jacBwtTWwVh4pV48XslCl2OcEMAhIgMkW5PhRtpFTgtQfTmu8A2ycodiGWxzyxFGMJ5hNy+qTJNyeAHZVzuJfBuJ6jnAobDIFfaZBCdm69+nMFhl5CYa9e/gJldeALc10xuPS6HxN2MbwqlZLfVRZVU6ZjGgmguCc7aMIaAzI6M1Z24EFcA0rSe6hbz+S+/2dFzzQ4Y6y+qqOupaQDya8SOj2KKICrXJMrwbdlDyaiFeFcKFcLP73AHnWhuU4MLw2fZ6vtTHHUQtvh1ajL27e2HZIPOe080bf4nNcebhqglqqRL54vsXyO1/fUXn/eVHYLTt3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DhjBRYsM1tpjxUibVIlGbkzEGXLlAff5oS9Zentib80=;
 b=PtD70+8f4zHPxmQ0uZYPJHsK42mhsb794nhRDBDUnH2w6i763XSDv71myOaHyErvyKWkFtWXNIU/zlUCDxmn4cUuFhFN4MWhYuNwU5znOT9L2X9BanG7PVyOOKE1YP407NZaUFV3F5+O8v1O0yZxZoM60G/nP4Pff+F0UIs+tp4E82lhbpxbiESDjCCG9MkgGOJw2V4Y/q2h5b7AETFiXuQYS8Vz/aWBRWgGBo9S2flqoeeNKN7vwFD27lWQf7mJefP6wV+o06jKXmCNIM8248HA5ry0k+fb7h87b8J4PcK/HwU0G3iG+n/1RqYoriJZIjdHTsc9aNf6frmIt5XsXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DhjBRYsM1tpjxUibVIlGbkzEGXLlAff5oS9Zentib80=;
 b=Np6dWJWI/Im2LT/a5guR5QziSISLdLGNWpRAhBdTQ8pGQiGv18JoHTTdcMdwYfx0JbqgNdnxALVBpT8yfU+9JVsM7k/kF0mJPQYpomRhfJKl6rWlF7eXW9cjEnZKf18enuyZD//FxpfKZeDsCct+zrCxFKe6Yl3mSiawHrbD7iZIRueyqs0qffrMMJTPtY6lmt0GGVl+HzAPc4SNOpQ2b162FAzOKSdhQp/yoUlElbswWwQNkthvZQLQt8piOwJDJE2IVKOz27emw/pAWYU67g6JqE2f7XOkxXK+CulwB9ELgyFzXr3cjCk6GILUCNrad5wiFA/psGGzKsD3EmRgPw==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=cornelisnetworks.com;
Received: from CH0PR01MB7153.prod.exchangelabs.com (2603:10b6:610:ea::7) by
 CH0PR01MB6892.prod.exchangelabs.com (2603:10b6:610:105::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.10; Thu, 4 Nov 2021 14:50:07 +0000
Received: from CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::bdea:4e22:1b89:24e0]) by CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::bdea:4e22:1b89:24e0%7]) with mapi id 15.20.4649.019; Thu, 4 Nov 2021
 14:50:07 +0000
From:   mike.marciniszyn@cornelisnetworks.com
To:     stable@vger.kernel.org
Cc:     linux-rdma@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelis.networks.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 4.9-stable 1/2] IB/qib: Use struct_size() helper
Date:   Thu,  4 Nov 2021 10:50:00 -0400
Message-Id: <1636037401-89082-2-git-send-email-mike.marciniszyn@cornelisnetworks.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1636037401-89082-1-git-send-email-mike.marciniszyn@cornelisnetworks.com>
References: <1636037401-89082-1-git-send-email-mike.marciniszyn@cornelisnetworks.com>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR10CA0007.namprd10.prod.outlook.com
 (2603:10b6:208:120::20) To CH0PR01MB7153.prod.exchangelabs.com
 (2603:10b6:610:ea::7)
MIME-Version: 1.0
Received: from awfm-01.cornelisnetworks.com (208.255.156.42) by MN2PR10CA0007.namprd10.prod.outlook.com (2603:10b6:208:120::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Thu, 4 Nov 2021 14:50:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad150e49-294f-4b07-c418-08d99fa2648e
X-MS-TrafficTypeDiagnostic: CH0PR01MB6892:
X-Microsoft-Antispam-PRVS: <CH0PR01MB689291E60A9FD148E1F4E994F28D9@CH0PR01MB6892.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GLuwPr9p2k+zKOtqCKSAoaGSfCA11m5LR2rlonSwAYiLRvEy9SMc1n6iJCw515OKvVk6M6wUscVofdq/xpfIf0aYgL68r6XPiWoJ1Itiqq8JwpGSiI1J+dZrtSJ6UBpeFe+zovVTAzgIy15qljuk9SQiRsInz2BIgvTTrei/tJ2lbWE4xgLVjgTsOz4iN8ia2+z7x5bC+EmZB/tv9IRY8btnkSkgfJ+oroXAUayd72k8BH9mUFR6ws4QdNJaahG2FGaAFcvQB3200nEILf/qrPf8xP3JAIJBZrNzRUNlJDI/lJbefZ8zg3Mwv8KclfiOG7fOg7pNdBVbMOcj7vOCL53LRjwweNOX/SqVqS8JfF2Or9shqk/yS24T98HFUfVGWEnfuwJZB1AzLjyr5PlLavuJgeCjgxCa60kzxUZGKC+TYSwjDNHwnGmYQ1YoBJZjXgHL8fQCmivPq/1iH8bj2Ypp8WLLtowBWeR9f5YgxTNECvG94LYjQZ6t33QpnQxPk6NOcwo6lbvvgo6WVITJZW3TN5+9sKbJXin+/UDdgzkA9CUryh1sKph6hjP1XKcy2shTwaRPynoV0qNfR6cO5bf9AFd31XTfPxhCGTkw6ZHXbK9y5Mws44QRtMb6bk5dE7jiEK1cCt6zwDoBSQ28Nk5ObJdrLjK47QMvrOOcrdXOyE5qxcs+6gEu5FL3GaSzRJsG+7NLAoQMjSgRhGUzsA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB7153.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(396003)(39840400004)(366004)(5660300002)(8936002)(316002)(508600001)(38350700002)(38100700002)(7696005)(52116002)(26005)(86362001)(66946007)(2616005)(6666004)(4326008)(6916009)(956004)(83380400001)(186003)(2906002)(54906003)(6486002)(8676002)(66476007)(66556008)(36756003)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mr6/YlTMNEDzJircm7NJ0C9IjXJr85vRefsDgbc42OdYWQ5wvSCqKomnDoYw?=
 =?us-ascii?Q?nkXSeVK7p7mNxm2cY4alTShCpaWCmRi1mk7/75z1kO+4Z2BrXcGhds+Y3Z4C?=
 =?us-ascii?Q?MZ/c1preKRiZY70prt6DX5RTfi2Cj2BnWQ7+y/G5Q87Jqpuc+/oe2/Kbk4ud?=
 =?us-ascii?Q?4ISgxzRdV2IHBPzUzXyQmydr96xd22HMopis7c4SdrwOTAX/AWwTS3sAq+Qx?=
 =?us-ascii?Q?Jx+tp3db8R4L7jNgxCM+jJVn5U5NevbqoHdQa7yPgSYKXmFyqRaNd21acrPb?=
 =?us-ascii?Q?k9nXMSgvI/0RK+P76FGC2dJYdxjWt8HqAf1go6sT8KqiaTogNDL7GDA3a54r?=
 =?us-ascii?Q?bleOfFhmHPTkUSmWLyZuKPUlSGpPPRrpk7FeYHrgJtgrKmt+UIAf7+E6VHGC?=
 =?us-ascii?Q?ld4QbN0fFZjkRXavUvcUv58p+crJyk0JXpgolrqk9aHErCOuqf7okFsHYKfG?=
 =?us-ascii?Q?quRo9U/bZLEs4+R7v9EQMMmUNln46zvCl+ci3yzL59S/W/bPUqvryVLVv7O9?=
 =?us-ascii?Q?BlJoiBz7wN3I84TQAsIY0JZHUfgV/bPzX7SXT1XiwY0naQapMdeglugEgkVA?=
 =?us-ascii?Q?qcYQLCWEuCa6wfQl02RLeuEljCS8I4CrS/x1MMOE6TJ814pSMjP9YSMJkpQv?=
 =?us-ascii?Q?T6DRQgzvRIl1pX44wXOjA1jOjLy4p4lmsEzkVneojnY/RY2d9+mVhUIE89AE?=
 =?us-ascii?Q?TMRSWrH/L3LLYuoet/fvIGBrxQus8tH5F5te/iX3ev0Abl+dYIGqiqD77Oyq?=
 =?us-ascii?Q?rRdYRr3G0akSECa0X0Py1BKhQ9vb1aLO0yqlF7dvbpTKvMkJAWBUDkxhoxPq?=
 =?us-ascii?Q?h7HVigTMyS6ijSK+/jEKkqcvWyTnNBQ0kJzHy/IgtR1lIqRxzgaCyuqmD0gM?=
 =?us-ascii?Q?4Ly7tsZV2uv1+/6YJ6xnSXsKt8tlbPfNh98i7yd3CWG75zImJpAAeUy3Pu3v?=
 =?us-ascii?Q?z0i8s9Dr7jyE9eQJ5jmlyRt5rWS7TVFL+UjtkU+ezaE0t9z74Kfk3b1mHn5n?=
 =?us-ascii?Q?Bzo572D/xcCesSdJ5WA6mUSWZrZjQWJdeNpJOPzFRG3WUpu72ut1hctXvtdO?=
 =?us-ascii?Q?2Kdn5XXVZF2C0GHjTbowCayc51oaukPSMnm1/bO+EQuTgjl1B60DIaXw+Xx5?=
 =?us-ascii?Q?MfdRPJ4i2fCpwxUcn38mdMDB4W35vGwAXSjKyJKdOxxnxZqkqwgF+u5tyZZY?=
 =?us-ascii?Q?F2Ysppgzy0vvW0WCCiNSMR80pe81YCBxnC6VVaAsqqE67jBf9eu3qNtUGgvh?=
 =?us-ascii?Q?g7GHtsIq2Pf3jIMeVh4eHsrY7qaEd0hDOgNOlB2/0Ba9MM/FWdEKOgIt20tw?=
 =?us-ascii?Q?eZ4BdmHiRb5glPu3rylK4jsf9oxfMpD9GaZkbORAp3ueoLAsqS+UYEjLDU7p?=
 =?us-ascii?Q?ROWLwCpQJy9af5sllzck1QJ94Dot2fIT+eERsBHx22H1RvXS4xPQxrxmx7NJ?=
 =?us-ascii?Q?kwU4WrlrJTtpyz3IbBtBR9o7b/dVpYhniW3oka7WmW4+vzZMi2nGNrrUC1So?=
 =?us-ascii?Q?Wv0FYBAySKBddJpR1YavqIoRuwbxiGcSjoDL9fgMopEk4agvqr2UIdZAZmx6?=
 =?us-ascii?Q?OKExMW4m+ajWQlUr7CKoge4x6FmkZGXzjK4yqq7FcAgN0Qu5Z4S5wH8t0t1v?=
 =?us-ascii?Q?foRg3p1w6+0x1tyxDn/e00U1j2R/u9MYEI4lO6qax1LUjuAXQhhSyHACBb1h?=
 =?us-ascii?Q?D17P4ODiAzPRbuOnUjZymy78F1W5aoEJUxbQAzESnEgxtmH8pamL5qUAApFN?=
 =?us-ascii?Q?i+tTzHrUBA=3D=3D?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad150e49-294f-4b07-c418-08d99fa2648e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB7153.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 14:50:07.1705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gJKivpNNBNzBnLIwm+P7zZ1nrCoQB6W/co0vQMEwpfF6mPqE3ubXDnfuQNcS4GjE/y0cPEZt5JWSpXNHhZV+5j314zDl9lx9cBgPLiBER1PvFONONxjo0cozwOCuArcn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR01MB6892
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

Upstream commit 829ca44ecf60e9b6f83d0161a6ef10c1304c5060.

[Apply to 4.9.x]

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes, in particular in the
context in which this code is being used.

So, replace the following form:

sizeof(*pkt) + sizeof(pkt->addr[0])*n

with:

struct_size(pkt, addr, n)

Also, notice that variable size is unnecessary, hence it is removed.

This code was detected with the help of Coccinelle.

Backport notes:
- required include of linux/overflow.h

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelis.networks.com>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 drivers/infiniband/hw/qib/qib_user_sdma.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_user_sdma.c b/drivers/infiniband/hw/qib/qib_user_sdma.c
index 3e0677c..deef6ff 100644
--- a/drivers/infiniband/hw/qib/qib_user_sdma.c
+++ b/drivers/infiniband/hw/qib/qib_user_sdma.c
@@ -41,6 +41,7 @@
 #include <linux/rbtree.h>
 #include <linux/spinlock.h>
 #include <linux/delay.h>
+#include <linux/overflow.h>
 
 #include "qib.h"
 #include "qib_user_sdma.h"
@@ -908,10 +909,11 @@ static int qib_user_sdma_queue_pkts(const struct qib_devdata *dd,
 		}
 
 		if (frag_size) {
-			int pktsize, tidsmsize, n;
+			int tidsmsize, n;
+			size_t pktsize;
 
 			n = npages*((2*PAGE_SIZE/frag_size)+1);
-			pktsize = sizeof(*pkt) + sizeof(pkt->addr[0])*n;
+			pktsize = struct_size(pkt, addr, n);
 
 			/*
 			 * Determine if this is tid-sdma or just sdma.
-- 
1.8.3.1

