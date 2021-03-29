Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F222F34D1CF
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 15:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbhC2Nuw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 09:50:52 -0400
Received: from mail-eopbgr770129.outbound.protection.outlook.com ([40.107.77.129]:40679
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231637AbhC2NuU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 09:50:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SEjfjg8/EGZOShbiRUT7zWdyaFobUxPocpY7Z0e3drMVzMoWMWGZjXLhQwyEedV5NPlqy2pLjqah1Wy+frip3Se+FEEFg+phIebgnV3SHdbA7MSCKJAdHwVZ5gNJXWtn+lVa+iBK6ow4C99kAIpYVDL83eZ/54BOHahGXeM1oYpBJUbx/d6M12J71g2aZjj0mBY/09AURrs+TATJHnBRG8n+gA8zZmNu4Z8vb+l8vHjQrqjHMa+f5hy94SVhKOkes9d8l/IdZyn1U49KQfPUdhMSGyRZA8vYWdzPMsiidtcXj4Ag/Kt1K0z/WWekWc3GarCoV3CJtvN6Hc5mfe8X1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yWGqWum3tbe2u7i/pBCc7+LMkSwDcseDsKlEo2q1wf0=;
 b=Z/wnIEUOhpTFk4++LRZOyiqD+3x/5ozrlv36JUfpS4M20qSP/2mFtf0/ln54DHe7nSW2M6QENEN5pJCROlg3zpsUcF66jsxhBeFUMClEaRfN318D7A8ak/FNHVLy50zzlmzXiHqFPzpIKttBlzYCA5jZIwoqtfuZf5qFlfQ+pkKmporROr2W1VkEOzwDLj+TNDzFfTcDQLexArm/KuR7OydDT8hK6doiE4gzfNq7Rp9c3kxWBP5l+e523Lb37SpQvpSMsPu3ZTWefO5uxfTdOAn0SQ1MnL2B0AxSQUo7eUBmMj4nWgpOg1VGeFmFiZATtxyemh2U4bPZkgV4jZlXnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yWGqWum3tbe2u7i/pBCc7+LMkSwDcseDsKlEo2q1wf0=;
 b=A/tIbuJ1mqzSdsXXZrIGtqTuzFe9cieCZN8KCTop3oFk4nRsDRHb7w2bY4ZNzoMDUV0qzRAzKzgAdwvezNC9p+F+CagiyponRXeK2VUEiQhBqA4Mp9GeaKcIRxSbCKjeS+ThUqU0DXfO6J9Gp5DTXbBumkk6PIt2ZyYW+duWTaq/esgFXFGmd2fiT+aFmDYwrVjrlVei05HJ8PTfFr0fTkxH7aBBzUyvPVFZEqzbm/mGf+uyHF4CyFJI1XeSm4oXUDeCjFQpc8AxRj5EbJLRrZg3Yor0Bf3fqBBFET6iHS5NRoQ503PUFsuZuHhjhjGIYMA5Xq9eu6OQ6tJWDzNDcw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none
 header.from=cornelisnetworks.com;
Received: from PH0PR01MB6439.prod.exchangelabs.com (2603:10b6:510:d::22) by
 PH0PR01MB6294.prod.exchangelabs.com (2603:10b6:510:18::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.30; Mon, 29 Mar 2021 13:50:19 +0000
Received: from PH0PR01MB6439.prod.exchangelabs.com
 ([fe80::75a5:79c6:dd14:3860]) by PH0PR01MB6439.prod.exchangelabs.com
 ([fe80::75a5:79c6:dd14:3860%5]) with mapi id 15.20.3977.033; Mon, 29 Mar 2021
 13:50:19 +0000
From:   dennis.dalessandro@cornelisnetworks.com
To:     dledford@redhat.com, jgg@ziepe.ca
Cc:     linux-rdma@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>,
        <stable@vger.kernel.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Subject: [PATCH for-rc 2/4] IB/hfi1: Call xa_destroy before unloading the module
Date:   Mon, 29 Mar 2021 09:48:18 -0400
Message-Id: <1617025700-31865-3-git-send-email-dennis.dalessandro@cornelisnetworks.com>
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
Received: from awfm-01.cornelisnetworks.com (198.175.72.68) by SJ0PR03CA0052.namprd03.prod.outlook.com (2603:10b6:a03:33e::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Mon, 29 Mar 2021 13:50:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59cd8307-37e9-4b49-54c4-08d8f2b99742
X-MS-TrafficTypeDiagnostic: PH0PR01MB6294:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR01MB62949E4240517736FDCA7698F47E9@PH0PR01MB6294.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oEs7cpcQ5ViKheQqMUHbl3EnUS82ogOKldnqTbTYglN5Lp+b7aFmhqy6pHnKdNjDJ1UeKHdz3WlqgbuhNnSctCgMTlDAL98U/N4eGPl1oha9ZQgMsBZdOXHx3O6xcJ1rDu7j98QxbYKotCjErQYdHai/ElKlhnIW5GXg+Ql+aJByZjywPrxTxO85vNVmIkfX+8TAHOhzUvDFBzyMZRF8LjpiAxDa89lobgzTWgeCrfJ8jY7dSlgBF2cIkCaDRLoBSrd0K2+MtLLee0rR9NeOY0qHlT9ZidoZPb0sWTeK7Zf1NG8xk33CWuJFTijJYRcC3twjie6Nw5dTAEptO2z4j9gmQKbmS9wsjCYp6zxANrFYXfIeikHod/Kyeq5nTK3EzN0p0TNf7gqTqaC2sSz3BgqnezwUKnKjh8mBcXbMkFvIhO/a5dolsQ/+mr53t3SkrAjeOMOZ908PTs25IfQ7p2RfiJVGMVFgUZgEw5sBeMUDqyMXmfJ2YC0/kiD1KEQnsWD0cOM5uEUPBqZorbz4UweTOV6QMXSAeyxfBDM9FU99duObXQZ8+a7gYKjCZbDoFGAXk+O/SQhsY681oksGxA3yPeCdZHgd16/2ZeJG19SijLKBQFJs6e9ZJ/2IZXMBJwhx5Z69quAEvFxdOyIwBCZfbqI6nSVzhAVGupv31H8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR01MB6439.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(39830400003)(376002)(136003)(396003)(366004)(346002)(83380400001)(66556008)(66476007)(66946007)(186003)(6486002)(8936002)(5660300002)(16526019)(9686003)(7696005)(52116002)(107886003)(4744005)(8676002)(36756003)(478600001)(86362001)(2616005)(2906002)(956004)(316002)(26005)(4326008)(54906003)(38100700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?LmKkJLbWaAg3kh1RFFrqpVBZVvhpik7TT3AEgcuhrFX6zanOh+mb8p0+NzL7?=
 =?us-ascii?Q?OjW6U9MrujtkkdR8BLfv+H66E08F0/q5E3+YWbVXXQuo+Y3fesTVWY+UoH1V?=
 =?us-ascii?Q?JSb0CkNpQf38NL9ncdkfH3q6fdsuAOGW0yYZwCjuYLvZtrcEpHoPz8mGsUk5?=
 =?us-ascii?Q?DmcgdcTWsi1At0GZo9KYPPRDsYU8tuQncqSvwijHhK+PMmmc1CECmVznGcxS?=
 =?us-ascii?Q?9vqnGuZjzGRzjlYytvwkx7p7NEdtj3XlTfA2vplV/iX40PO3nLsOQz5RqYp4?=
 =?us-ascii?Q?Jyxfe5644cYbwHwriMNmdHZ+8j1s/yQWsJyAEReEDlWHK27dAIjeX8mh7V8P?=
 =?us-ascii?Q?3GMOsURE89DtE42fgQXbGCVTeSkg7+7ZOWR1cHNnCI/MIUELf+8yXMuKcwz0?=
 =?us-ascii?Q?nwwXOiLS5VudRMxI6Rx0YOnuB3Eo5hOcKTE2hhdz5mawTil9v9DX2Mg7lPz6?=
 =?us-ascii?Q?bDCxWsrm3hJaNcRLfz9wxgBCnVGd3Me/Z/Nzy0XtToWQmWeFpAi0ZQ2/blWv?=
 =?us-ascii?Q?wdnYiZfzivhmMDup2vsQS/Zz41x4E3vHO2r1GCz8/uZmbosBMpEFO9Eod+jz?=
 =?us-ascii?Q?Yt07BwPN2Q8myBdtVKQNVPBUQe4yy6EZQGXPbaNr16AHhh8dxj+KqVHdjPu2?=
 =?us-ascii?Q?RbSEe2qKb50mir4XbEuNQj94T+EdQH8dyndDGO+GyVk6YrgouebVYQdn5OUS?=
 =?us-ascii?Q?fKyfSxXEE/dPN7oX/obNDNwXlpRI4Db7lcHxcW1lIdQA9/ISuPdrU2BSJpFb?=
 =?us-ascii?Q?39VSDzlXSE8+h7wU0p2uIWBczCG8SUL1g8vUpAnZRZ76fqQgRs1r2+Lplws2?=
 =?us-ascii?Q?tQ24HTyUiS/nNHrHXcru5uiYwQPJ7ndsTWCC0DSbS1CPte48quMwrlQHmdkf?=
 =?us-ascii?Q?P4VFPN10vx8mdmzxhCnM2Ot4yfxvgSW7FzCpsR6iUNtf8g9I+oEJrjgEegji?=
 =?us-ascii?Q?1bdyqw3FfukaQ6xAHKYRMJ/EYC5UY12Ey91h/dS+b0Ozdpc5JP22ujQYQanc?=
 =?us-ascii?Q?iKkaVfNKYR8WGlrBjr+HzX/AEnjox3KjgrgWz6Pub18msA+tu605poKGIhY6?=
 =?us-ascii?Q?MBVHHGhiSw/BckD0ooLsXbZoW5KL28jTULcpXR6h/oz8rIw0Q6zax+zjdV5E?=
 =?us-ascii?Q?/ABDXLO21ukmxRqGZ4jUa9IkA+UMuIWWd21drjSHLZ1ewmayAJHMBbo/uSy3?=
 =?us-ascii?Q?Y9Y6uu83TduEoZvCgE7hJ4/RdFLRkt+TBnTMgLb6aNNwdFxWK+2TaOk4goBv?=
 =?us-ascii?Q?BeiXoy3zHdEN287+hUAJ0s50Lb/tfnh8zOM8tCacDt1RrsBrR9GEOD2+YomM?=
 =?us-ascii?Q?svy6RtqeCmQAcNCTAuiCHhEn?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59cd8307-37e9-4b49-54c4-08d8f2b99742
X-MS-Exchange-CrossTenant-AuthSource: PH0PR01MB6439.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2021 13:50:19.5285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u+ZogaDLqjSaVvSi7EDhU6IP4CDf5KTfhYv6Yeh+r3LSKujMu+pQJ81lwrrknVLhCMm9D/iz1AQXvPALV5tYygws6cavNMKdQ9djyvASnkw5M1pBop3QvnJ2qcs0WDdV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB6294
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

Call xa_destroy for hfi1_dev_table before unloading the module to avoid
a potential memory leak.

Fixes: 03b92789e5cf ("hfi1: Convert hfi1_unit_table to XArray")
Cc: <stable@vger.kernel.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
---
 drivers/infiniband/hw/hfi1/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 93237bf..e4f8db4 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1507,7 +1507,7 @@ static void __exit hfi1_mod_cleanup(void)
 	node_affinity_destroy_all();
 	hfi1_dbg_exit();
 
-	WARN_ON(!xa_empty(&hfi1_dev_table));
+	xa_destroy(&hfi1_dev_table);
 	dispose_firmware();	/* asymmetric with obtain_firmware() */
 	dev_cleanup();
 }
-- 
1.8.3.1

