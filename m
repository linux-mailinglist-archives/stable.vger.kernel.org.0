Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A76B94455DF
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbhKDPCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 11:02:25 -0400
Received: from mail-mw2nam10on2106.outbound.protection.outlook.com ([40.107.94.106]:52192
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229920AbhKDPCZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 11:02:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GkKoTiHZpQ5mi78z0QQC3eEYMI0iXbZCFipL9ezO7YM9Cb69dncJkNznt0Dij26P8q3DkgiLaNuvvCba8zqCdk6HvtLukkHlnkXr5PynKupqMvg2SLkEM8aIrlXBK1VN5Yn5Jul/jRgwcAxiKx+ICgUrLM+lwAdAFcbW//hKKORy7oAjIhol13rezq5ENe4pZXqt/LbMU7SsF0BUtZBdSxF3irMQg3ENa+dd7Rhm+GpnFnFTSYjJnFv5mc+Wl1z1FSYrI8vyC+E/chxnltLgVSPFS1Zuao/e1S83Oo9xwBjZZIWBGo0VpyswazBi8VtxZPsW5lalOjGrajgZKxC98Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ht6f4KyyhqrR2pGZ23VM31G/jZZjm0i3+CuPke8JXLM=;
 b=emKG20NpZk8K6qJQx8EvN0SeJLfGry2m7agpCQYEtknoSBMgMTlvJZs2td4mjwmSCsFtmDUn7VZiatT0ItHz7lDwpzLlTO39h5awrM8iR7RRn6lRjuGrACZncC9iWrxUj3e0/JuHbbPfRDIeLGhxAnUj5npKxeushd/9eItNgZfNRkpWzPXkmRsyM8IJfJ9wmLdWSm6tC+6iNg63yg2kcKTzzGafXOzxhg3flxI1AIo93RBqO5oIVhUS62AioXLMiClmvjSbsIjuPhiwsfF/QLVud9TX1RRXf/Date9FMrUiwUt08YNR3SdkbfXa7fSB0xm1WMqbxxHTDn7+oW3h5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ht6f4KyyhqrR2pGZ23VM31G/jZZjm0i3+CuPke8JXLM=;
 b=bmPp+FKSFy2CeMYUjHvx2Kg+pQtjQqnLigPDGvi1giLXFQZBoonVeVL4WDu7kT7UagNy6m5vi7vcdKHEKcEywBTkye7gJERaU/rH2d+6n9/wXFOyB5eijt2Vz37PnA8MnX/rx3HTIQSASkKM1+qom7SPHatsFJe/xo3zlM09QkhBHEROhvo7Wy6SCI4oAFObJzKIEeopn4ihUsiAmKr5ebJLAeOHta2cKFDRXUc11zWENZQM9AX3/ZIeATn+gopJnGzupk4VnKZqqgwM6tZbdi9OcippbLlZoLUgrAPQ14H9LjrpJiH4NZWnOjluPnc2/W+85ci9XlrNiiDwZOHl7A==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=cornelisnetworks.com;
Received: from CH0PR01MB7153.prod.exchangelabs.com (2603:10b6:610:ea::7) by
 CH2PR01MB6103.prod.exchangelabs.com (2603:10b6:610:26::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.17; Thu, 4 Nov 2021 14:59:45 +0000
Received: from CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::bdea:4e22:1b89:24e0]) by CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::bdea:4e22:1b89:24e0%7]) with mapi id 15.20.4649.019; Thu, 4 Nov 2021
 14:59:45 +0000
From:   mike.marciniszyn@cornelisnetworks.com
To:     stable@vger.kernel.org
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Subject: [PATCH 4.4-stable 0/2] Port upstream patch to 4.4.x
Date:   Thu,  4 Nov 2021 10:59:35 -0400
Message-Id: <1636037977-103575-1-git-send-email-mike.marciniszyn@cornelisnetworks.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0022.namprd13.prod.outlook.com
 (2603:10b6:208:256::27) To CH0PR01MB7153.prod.exchangelabs.com
 (2603:10b6:610:ea::7)
MIME-Version: 1.0
Received: from awfm-01.cornelisnetworks.com (208.255.156.42) by BL1PR13CA0022.namprd13.prod.outlook.com (2603:10b6:208:256::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.5 via Frontend Transport; Thu, 4 Nov 2021 14:59:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 173c93e7-9164-45a0-ead8-08d99fa3bd40
X-MS-TrafficTypeDiagnostic: CH2PR01MB6103:
X-Microsoft-Antispam-PRVS: <CH2PR01MB6103F30B74F9BAF525E88D60F28D9@CH2PR01MB6103.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:165;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: betahWHvcJVSXz4fmc/KQBuHTZt8ydfE7Tgm0IDFhqPviSQpg0CuzlL2X/Q3kB9kjccqgACefYGIWJWEz3fpJHeBWGg6wIPkoAUEgOMt61+HEZbhpHNispfdcS9gfwu/MIxBWYnTn5k02QM6vH09vSPFBtywhPKXlz03vXaQdMH/Bs9oN18svL7vB8hKh3knfWlD/I+PwKzRiwhGTd7MPtWADuDgckK6XI0y1z+B43ZasATGKTIeG6r8dzfQFHa2iOJi8fPY+jZvbXHdYJJMgmu7xRpR3dtVw0hQQCNUjCRp8Rw4OfoffFA8aAAsmrvfxdvuXWdR6XnZ34tR99/J51fyzWRilUfQBPHCdvzPfxEa08nFstpmCdBJyV98axhBV+A4ym4khKyk94/CHhBGHpTCZh1tWj4bOGyNMPDQBmUeNK/CAtRmaZ3vR8SLkvSUDWZNEEBI2LNdRFnQTIwsiDGgE/XcJ7WHNlMWia8nM5VON+tFvUbcU4xmQONOX6Ghl5t10QHcjcnfe9DrtBimRMOXD79k+ARTQDZre9V+Kybfxb2uWJU94yRRmYo7NhqaswKhmH8WBy88GO9kPIRYXXTc+QgbOgMDhCjzqAap0C+vOqUCdW58bEQeCHrm/XqpJaiURibM3dcnCGkxZ4Ey1+aMfTpkowOOXvesr0bcmYMprcx7dSreruXTt/fAK5KePOIu6whNWXSHXzjOv0KsHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB7153.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(39840400004)(136003)(346002)(52116002)(450100002)(36756003)(2906002)(107886003)(186003)(2616005)(26005)(83380400001)(38100700002)(7696005)(8936002)(6666004)(38350700002)(316002)(508600001)(8676002)(66556008)(86362001)(66946007)(956004)(9686003)(5660300002)(4326008)(66476007)(6916009)(4744005)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rqaNC1S3mGgD1KKUbMH3ROVI4vU6AQN9YgInAq3PFZkUMck+yfDOodMphCwy?=
 =?us-ascii?Q?OyERQTjIxOJsTsobMjpuesu1oolgF+LEvOjvfUl2bMIYA5AraJFtwVh3pXqw?=
 =?us-ascii?Q?1hcFikXa6PENCVKK/73ELgc5EiBIH8FSz88LXX6qSfN0JXBZNXRxEDzIHw4A?=
 =?us-ascii?Q?5aNWhXo+wxZiAH2BrCbyqWcaLo+MXb5rSTWpk2tx48wELiKdzk16vq6i3vBW?=
 =?us-ascii?Q?ur+sTcu7e/Vc7v0E9Bk/+gfoY/qKaq07RtOGjQyropj2umFzFUr4HtM6vHNw?=
 =?us-ascii?Q?sB/SmFQUA93fy6EBbB2cYhNBxKjog6thXVlEp/lSrmTC/8NtNsxY4HMWlLTf?=
 =?us-ascii?Q?7GygJ/j6U2zbozY+JEINKTC0/asmXOFEVbc8dHbtfL6Ma8CTG3t9Fo2khBSm?=
 =?us-ascii?Q?HgQ9IhHZhVwrcu0SKPr+IC8Tpo1DFArhZGMpcY/V8C7g5iDE/lvlIdBlm5m7?=
 =?us-ascii?Q?xzh/kdoHPq3zmTQQ/s6qd5uml+51BLI58jwORZgDPDQw9ucSvz7+Y5wuWw4e?=
 =?us-ascii?Q?K0MdAfkaDcCFXx+m+d/2W3EUqhzC4aBwLt1m9cDkm5OsUeaPqr0NZU3raDZG?=
 =?us-ascii?Q?FiSgwa+TMdgwraYNExtQiJ8nKdZ7lCl5cVxacT+HY6CsT5KuiEbRl2e/9Nu5?=
 =?us-ascii?Q?fkzLtNLUBUObi8iSGV1wNwlGoSieffEVVM7/WsnLlc8maosUljUpGSZBGbM+?=
 =?us-ascii?Q?9157Yb8Skwawzqk2fj3NlE0jRyoyL6ctbnLYcOj35yVmkNpEEm9X1ocoLDS0?=
 =?us-ascii?Q?H3VU5LvP43Ji+sixe7MMUdk1fvybabVqoP48/J2Vw+NBJ33WcLZCaVvukV1y?=
 =?us-ascii?Q?NulFcG5gm1dEt5wMA23Lqy43LFF92M/+5LLVHcBhZ2gWvaqM2iwzente2+4D?=
 =?us-ascii?Q?1JhwWl2NUDkrBWeGgHNX34dQkzLOX6kkuYVyf0RzVHvTbDSi14ZEmHCP71F0?=
 =?us-ascii?Q?7K73lm5y7BnJSa7ha0WbwEKC5N9amEWt8BtCNrOJZfEwVyQ5eKoc2gWPyWZG?=
 =?us-ascii?Q?tMuHXe4S51gLeW7rePMefDbGALSZqcDPauElmg1/yDCCoxcBJBefx9LDmPuW?=
 =?us-ascii?Q?253MgqJJR88l/RDznlejY2DOURzGqWQf98Xz5I/qdU3FCxWfix3Gr93+iL99?=
 =?us-ascii?Q?pOjFXDPXktfP4fD4fcnByEabVLg83Tese6kxTUApZi+R0wv3R7/YH13p2Hkq?=
 =?us-ascii?Q?wNlVh554Bz0o0ETKHFvsqG7naggJe0nbk7LiAHLkvgw7MKae+oTpnr4WZx6p?=
 =?us-ascii?Q?IKHYISU9DcNcEQJqhntWpnSgD+DrJlkvNvjcAQ+gFu1QaqHJXvGa7oNRqT0C?=
 =?us-ascii?Q?PMab9MDtBKvK6XcQMCmO3RG+gwSaTLJ+jOs7ptljZA9bgMME/CILILHFL8FG?=
 =?us-ascii?Q?lYCMU3ti5yVYq0GA8DGJ5fE9WShlH4OO7D1Qll39LW119wvAzXCbc8ag834p?=
 =?us-ascii?Q?DnuNzhEzP/nYemoEJOabfm45FTk/61gBVrYEqdF7Vo0dbCRb204PR9t7jUrL?=
 =?us-ascii?Q?RTScbzfbiuHKddCOY4yeV/dHBPJ+AGINQJrs3WjJGovYa6i3zsekbkIBnHo5?=
 =?us-ascii?Q?tW/wv6J+rjWwziRjdTzExxikGX08o+rJcByPKyuMva93IY8rDxhOcSdmZRtp?=
 =?us-ascii?Q?3TDcKlOj74+K0XcbZhmcAZHnQ+73rsoZwEK9k7YvVtCMhI9eAufaFjUIqHKF?=
 =?us-ascii?Q?exkKQ01G5Pme+axHU9Skg4EYXKtSVzzMI6emc6pFXfZ6r3M02iVmL0NibEPg?=
 =?us-ascii?Q?ry05ib1hVA=3D=3D?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 173c93e7-9164-45a0-ead8-08d99fa3bd40
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB7153.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 14:59:45.6137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UyKV6MyEGwEVYtxVNhVG9rmFyufpmzy7Hkmyr822NdKYHsruzNso06jmBpaQE/E3hxR3qFmiCQpdicYz56qaXBljYr8bR1KQUQuAAAiD1Yy8XRApLVgH6hXrppSgK0n3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR01MB6103
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>

This series ports upstream commit:

d39bf40e55e6 ("IB/qib: Protect from buffer overflow in struct qib_user_sdma_pkt fields")

Gustavo A. R. Silva (1):
  IB/qib: Use struct_size() helper

Mike Marciniszyn (1):
  IB/qib: Protect from buffer overflow in struct qib_user_sdma_pkt
    fields

 drivers/infiniband/hw/qib/qib_user_sdma.c | 35 ++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 10 deletions(-)

-- 
1.8.3.1

