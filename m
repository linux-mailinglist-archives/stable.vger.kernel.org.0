Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9428434D1D1
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 15:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbhC2Nuy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 09:50:54 -0400
Received: from mail-mw2nam12on2123.outbound.protection.outlook.com ([40.107.244.123]:12609
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231368AbhC2Nu0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 09:50:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UFyqEUtp5yuayQ9ITnqdr/OSIATOTMfYuniMhgkiOtaKFhc3PGDo9fe3J34S8gaFr4Asx2cIoCKdOH2zBNynMVXV5gsNAAbAuZbfYpkQjBxu/k5auRiPqncAYrGxM2reeiJBdAcTMSDPHYmO+yARj8yNQyEDGmJhO3IQj/AyvqDwkWPnw/M1vclHepg24AGcFtYsozSM6b4BVd1UuJNfNt+2I8v0RdiW3wCTekKXM2CPlg6pZElQYnu7k8fTmhcnE/ksgoHlUQJ3UaGfzqI5IOG+QtwtCsWiVi+ppsxwO1MXCE0WdSsIMfxyRsEQntm9gT6mtW5jJBqksebiG47CeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m4PWcWPOH49F9ij76FALXeP2sWUKHBix0+CnDKiMTDY=;
 b=D8c8QsIpeh9Wecy41OzUXoU0BZYwRgAqNNCJvT/kTba0YZkXzG+ESBapbZGt77Epf3qAdawCz05936Z6tKYLLHMqggkk+RFQ4pnwglAPgzIyZG/SszOaUJdsZwa4XthRrbThzRFb7bo0jOwenpll73AMYOHlmiaeuMkpyqfJ8KCvmP7Re/Tl9WzgUrpEUx3KaNZQ7LuDPfDIeodtL0nagX9vOtBKF94Fn+SQTBLxbPyZKoMePoVoe9Q1BXXd3RhQHd0PnEwwmTQjCBHwiJCZipXsJ+rAwG5IAoxsz8uMgfdpX2FiB1MnaH/1RGscXsV4JfnitVc5trfVztwOmaLjwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m4PWcWPOH49F9ij76FALXeP2sWUKHBix0+CnDKiMTDY=;
 b=ke6Fpj9q6UZwbTGVxKqpew6AQUF4f2m+skEyTmWGMNsUkvfT+kWVjd1QsFT0GeX3aKgc/+d1DZRaaffdYSgSAvLtZZqNe0kucGN+g2dNOFAE2dO9Rd3MS1l1Cu9mS+Ib/qqtE6Hy74OlkSms/zclQucfVSyyqX00b5ARVz2CLh0M8BUIJ2OxirjtAGpsStS9pDiRV7EYwuY4Q6KNJXOTVbgUsAOSDJL+Auq/eOAPy10fmyS9K4W+Et+i5Cu82zy+ATelggrKQS9g0Q/391l5GCgOO6rs2aWrcguIrzIxTuOlRayZPR077ff/syOxHtouOeh9EzTXLnmm/FCwIWTI9A==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none
 header.from=cornelisnetworks.com;
Received: from PH0PR01MB6439.prod.exchangelabs.com (2603:10b6:510:d::22) by
 PH0PR01MB6294.prod.exchangelabs.com (2603:10b6:510:18::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.30; Mon, 29 Mar 2021 13:50:25 +0000
Received: from PH0PR01MB6439.prod.exchangelabs.com
 ([fe80::75a5:79c6:dd14:3860]) by PH0PR01MB6439.prod.exchangelabs.com
 ([fe80::75a5:79c6:dd14:3860%5]) with mapi id 15.20.3977.033; Mon, 29 Mar 2021
 13:50:25 +0000
From:   dennis.dalessandro@cornelisnetworks.com
To:     dledford@redhat.com, jgg@ziepe.ca
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        <stable@vger.kernel.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Subject: [PATCH for-rc 4/4] IB/hfi1: Fix regressions in security fix
Date:   Mon, 29 Mar 2021 09:48:20 -0400
Message-Id: <1617025700-31865-5-git-send-email-dennis.dalessandro@cornelisnetworks.com>
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
Received: from awfm-01.cornelisnetworks.com (198.175.72.68) by SJ0PR03CA0052.namprd03.prod.outlook.com (2603:10b6:a03:33e::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Mon, 29 Mar 2021 13:50:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02f3fabb-7754-4047-3eeb-08d8f2b99a9a
X-MS-TrafficTypeDiagnostic: PH0PR01MB6294:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR01MB62941FBBDF86F1E8562EBF39F47E9@PH0PR01MB6294.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I2pH4MFMqLIWxpbJ4tVzlJwR9UN+ZX/RAaIcPuSBtIKWj1lwUIKhym7x///Ya8Wb9Pnu/HgVfezNSSZ18a9wYvVMiavNIYb8bN1eS9r0d9feV21QHuC52qi3cy4X2hx7rLlHwipEI/akJzmoHmcNQMERSaav3+1zc+tirT0+/bsmSAXDTI3USm56TddO4st71K1joDayqFCZRomrCuMO745TfQPtRUyNjE90BZ/NM1RNE+bze9cC03Wbt9dChAs88K9AW8Ly4LPnB6AI5TAxqBXkqrmpOmDLNOYfVqUUl/SN/shE7jMH9SYQjO4SfHmN9FBNWaTH0LMFHeuDoRq/5/m3eY+DEgJo2JVw4SINpIHlSVjiGjazphIDX8xRA7fQpUFk1pg776Rd1PGARk2GTkAgi9aw1Vs6AvfhzMNgu8vJwIcQKWEJAuLzkl/snJHiyHbxKMU4FiY+7oXEFZSqYCOvC+5ybCQ0n+LsKRZe+PjhnUDlHKSv+T2mS00IR+tj+w8eY9sMMJdi8mozFS7t0KRnVpgUoBn1yeauoJsnHVhsZ96VRG17TO9ZDqTAtLKmDlZstw1FkplVnXSdyK6PnvPKZshnPgyq+KC5sHeFdorUOpIDu63nX1pGcUCYfGdt3Mp2MWgOczm6yr2s+ipMgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR01MB6439.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(39830400003)(376002)(136003)(396003)(366004)(346002)(83380400001)(66556008)(66476007)(66946007)(15650500001)(186003)(6666004)(6486002)(8936002)(5660300002)(16526019)(9686003)(7696005)(52116002)(107886003)(8676002)(36756003)(478600001)(86362001)(2616005)(2906002)(956004)(316002)(26005)(4326008)(54906003)(38100700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?wtIbwOgLl2pDIp1tC9ZjCPWo0wk9CqR2XpBxnU6r2A4NNfp/CNhTeDFPWAYf?=
 =?us-ascii?Q?uQbMdBgVd18eFo2g3HqF3IVFzj61Gp2nEY1PUijmFsvtUu+uIOV3aDl2FHe9?=
 =?us-ascii?Q?KKb8LqtyU0q5gQ8Fa7xMKC2N8hbatxEM51WAIV1txJZBaRVL6BDzSpP0tX64?=
 =?us-ascii?Q?OM6GYXD/4qJLKwVibeP3IyZr8F3GTdOgH/5TSXPlzSXQziYVdMOIiOhiO/oZ?=
 =?us-ascii?Q?AGAPmr1kU4r1rYxrQlYQPnbmFSQJZDknNIkwmY4yuufxK3pejEirKWuTZOdk?=
 =?us-ascii?Q?Kiu9HdhmvOgpXEigqHJboVYXQFCwiPHjrjAEnrQlG9/8dbmleVU3kFW9hSqA?=
 =?us-ascii?Q?fhhf8QuZo1jzpj9qaSn6Wrh+18DYko44AHlzwkJcFKi1/rMbTPk3HCtq4hcy?=
 =?us-ascii?Q?qd24XKkrtekgmZRfEsBw+MjQG7Dtji5iEDedseXR1ZTlQml7HjX4zNB5khvE?=
 =?us-ascii?Q?hv60hsZW7w5Q87yFdNBIzZDDdobLdf8506vOGpBdzINQE5W1ZL0jL57qSg8P?=
 =?us-ascii?Q?u5AYcOIoFv687Y3qpuAnGPQoCdKO+bmQbjVFWuiE73A1CaNmtdHpd1smLAAn?=
 =?us-ascii?Q?vbu1bMfjusCV0rb26RdwQwjsKNE1zfQs7VOqu59iW2zyQSFcIhkBGpNpnV3M?=
 =?us-ascii?Q?EAo4IOcgDHS5qSV9v/jxNV6SV+CDTUV+Op5IohY+faVwvGqd/11YpgMuZGRP?=
 =?us-ascii?Q?z/rMYvwD/BlAk8yfoV/YjbzITPwQJWpR5cmTNqH2L8QmOrSiMh7elsJvqcDw?=
 =?us-ascii?Q?DqidlhT0xZaW3DpDzz8S1V7BUzg3t70K9NUBKrDAu/eVo0BN/63wiO5HWR3J?=
 =?us-ascii?Q?9SGEXeLdNK84o/ruybgIZdvjtTQAxW/dSvFAhA610ewJ70vUIyDWiETXmuYA?=
 =?us-ascii?Q?U/mdggLt/svYHyNhhXaJDpSdkZsxOgx71zQbKBIfZ31Ajf3BbrCduRTaQwQK?=
 =?us-ascii?Q?SogYiNZmdFghv5lu9IEPl/s3PKQED2le/wruu1K0v+kq7tWr96rGvMVxrof4?=
 =?us-ascii?Q?i1EuL4ScKdl3MvVue7ImUws5nRdMA8U1VizRiSYGGSbXk6DJF1DgK0aFyXKc?=
 =?us-ascii?Q?q8SeYtugDXJhu33zNUD2oARdavvKZib2TBf3QYtblnvk4r97KUticys71vWA?=
 =?us-ascii?Q?3y6DPPDIfTOt+0iiylyeposfvUTZw/JHVB6shmMw5MJXIAtNCbM6yiGz7uPK?=
 =?us-ascii?Q?5M6dE+DMUocDZbfatOvWqoga71sZvNo5kGn5pV2kv5jyXwn/Pqbu1U6NeoB3?=
 =?us-ascii?Q?0LV5pakN0HS27ELXcAX60lAR4nZFfRzVQMDAv9Uk48IQOYdYb1t8vaJ0268d?=
 =?us-ascii?Q?fvwaGw0Lg7eKR7xs9PP7x6LD?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02f3fabb-7754-4047-3eeb-08d8f2b99a9a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR01MB6439.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2021 13:50:25.1378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e6zurrCT9AZCEykQ0+wg7PwMBisvY772/znBpyJDAUzYGjr19W3pusYf1jYoDpcg9cwMbx18c3BwLCgiuNAW91LHDKjIlWK5DI6aRKTQDuqP4sxco8lj8PKfh/kESSqA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB6294
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>

The security code guards for non-current mm in all cases for
updating the rb tree.

That is ok for insert, but NOT ok for remove, since the insert
has already guarded the node from being inserted and the remove
can be called with a different mm because of a segfault other similar
"close" issues where current-mm is NULL.

Best case, is we leak pages. worst case we delete items for an lru_list
more than once:
[20945.911107] list_del corruption, ffffa0cd536bcac8->next is LIST_POISON1 (dead000000000100)

Fix by removing the guard from any functions that remove nodes
from the tree assuming the node was entered into the tree as valid since
the insert is guarded.

Fixes: 3d2a9d642512 ("IB/hfi1: Ensure correct mm is used at all times")
Cc: <stable@vger.kernel.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
---
 drivers/infiniband/hw/hfi1/mmu_rb.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.c b/drivers/infiniband/hw/hfi1/mmu_rb.c
index f3fb28e..375a881 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.c
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.c
@@ -210,9 +210,6 @@ bool hfi1_mmu_rb_remove_unless_exact(struct mmu_rb_handler *handler,
 	unsigned long flags;
 	bool ret = false;
 
-	if (current->mm != handler->mn.mm)
-		return ret;
-
 	spin_lock_irqsave(&handler->lock, flags);
 	node = __mmu_rb_search(handler, addr, len);
 	if (node) {
@@ -235,9 +232,6 @@ void hfi1_mmu_rb_evict(struct mmu_rb_handler *handler, void *evict_arg)
 	unsigned long flags;
 	bool stop = false;
 
-	if (current->mm != handler->mn.mm)
-		return;
-
 	INIT_LIST_HEAD(&del_list);
 
 	spin_lock_irqsave(&handler->lock, flags);
@@ -271,9 +265,6 @@ void hfi1_mmu_rb_remove(struct mmu_rb_handler *handler,
 {
 	unsigned long flags;
 
-	if (current->mm != handler->mn.mm)
-		return;
-
 	/* Validity of handler and node pointers has been checked by caller. */
 	trace_hfi1_mmu_rb_remove(node->addr, node->len);
 	spin_lock_irqsave(&handler->lock, flags);
-- 
1.8.3.1

