Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3DDB462059
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 20:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351407AbhK2TZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 14:25:38 -0500
Received: from mail-mw2nam12on2133.outbound.protection.outlook.com ([40.107.244.133]:6881
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232541AbhK2TXi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 14:23:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nI4DBlUSlM91x6lGnHrBwZgk1Pw7Zqa/9lnxO1qADTh5d9MsKFZvvVAkU+jE1b/XdNZ7VGorsSgLKogqNJ3pC0BYxbi1HokNDyW7Jq7ZeE9ryMETykBIUA+afZ/4NlTodt0e51zejEaAiltW470OvapJXCB9CU9rbjC2hL+G8X+0BW+rG5boDgG+fw5u44tgJVJjMEsPhDGTW0JS5Sg2R5YVZHJpMpBbCGC3/00TJFKvKmNpB94l1eFCdZiJxz3ZewXKxfm/2XupJSQYQsKgKSCfR21vqQrby+jCvPgAcSn6fJVX+0QZduMGHk8M+nMZ5svpbehjT0DDY/b7fsnTeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UEndnqqNi2+RhoADBT7S6ymHqxxV13lLD39Uk4IwrzE=;
 b=ToSBcZKhsCaoHqsXT5g+hyNz+VMe8h1xpChwOZs6rqz5WpvieSdfQaUcDkMv6W9U6ckXETxpvByVyO6T4peDtQEE4ljlS6iTpowQMeD41EOFPC7KMAfxzpZl+yuTAUyQgnOr8dWmuwy2iDOseFt31g/H4VSiR8uC93A02WTFtaAR0IWHGntfceFOiiMzGWTuc9PUxfPhAq8xWb+IS9QFdUj8JY2kKEnSkZQqTCl8r/aZzGP2c6Fmzb7esHdPMuJoHX2D+7O/KmC7ZbWh5afebV0pi5pBdlk8e0D2wliA6i9uW/ZeXy7tEECjoea4PPBTZYVGQ3rt431bVuFw3FvBMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 208.255.156.42) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=cornelisnetworks.com; dmarc=bestguesspass action=none
 header.from=cornelisnetworks.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UEndnqqNi2+RhoADBT7S6ymHqxxV13lLD39Uk4IwrzE=;
 b=WHQzg5A6MLWCsYSeXf6hI2ejY5cZprWYLdJKc3FxvLCFkmm3/FAeoWGLYAmkX497t5aU2YxjHrSLXJRd6KeTG0wO5yCYNee2QwzQg5N3oSZmyGtg1Xhe2CIIg6TsbKUcHgfUd41T3fv5cVngeaowBbf6um4Q9yVmllmvR7zXH5qAFrrYB0ufCmtSauh6R0vI8RG1/ikKzmwmHAAO6MQD4+7DyI9j1U9XAPawES/mqpG5ZiSF2GhkzZd0hjdRBAvI8btRxAn4H8LnUSa/Am5O8XapaWWIkgVk6ewtJfAsNiPAvUxfGQ8rC3RjURjH4/myc958NXloQ4hWCoQLYM5tbw==
Received: from DM3PR14CA0137.namprd14.prod.outlook.com (2603:10b6:0:53::21) by
 BL0PR01MB4546.prod.exchangelabs.com (2603:10b6:208:82::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.21; Mon, 29 Nov 2021 19:20:17 +0000
Received: from DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:53:cafe::81) by DM3PR14CA0137.outlook.office365.com
 (2603:10b6:0:53::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend
 Transport; Mon, 29 Nov 2021 19:20:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 208.255.156.42)
 smtp.mailfrom=cornelisnetworks.com; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none
 header.from=cornelisnetworks.com;
Received-SPF: Pass (protection.outlook.com: domain of cornelisnetworks.com
 designates 208.255.156.42 as permitted sender)
 receiver=protection.outlook.com; client-ip=208.255.156.42;
 helo=awfm-01.cornelisnetworks.com;
Received: from awfm-01.cornelisnetworks.com (208.255.156.42) by
 DM6NAM11FT035.mail.protection.outlook.com (10.13.172.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.22 via Frontend Transport; Mon, 29 Nov 2021 19:20:17 +0000
Received: from awfm-01.cornelisnetworks.com (localhost [127.0.0.1])
        by awfm-01.cornelisnetworks.com (8.14.7/8.14.7) with ESMTP id 1ATJK87Q118589;
        Mon, 29 Nov 2021 14:20:08 -0500
Subject: [PATCH for-rc 4/4] IB/hfi1: Fix leak of rcvhdrtail_dummy_kvaddr
From:   Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
To:     jgg@ziepe.ca
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        stable@vger.kernel.org
Date:   Mon, 29 Nov 2021 14:20:08 -0500
Message-ID: <20211129192008.101968.91302.stgit@awfm-01.cornelisnetworks.com>
In-Reply-To: <20211129191510.101968.6259.stgit@awfm-01.cornelisnetworks.com>
References: <20211129191510.101968.6259.stgit@awfm-01.cornelisnetworks.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14986a21-fde8-41dc-a280-08d9b36d4727
X-MS-TrafficTypeDiagnostic: BL0PR01MB4546:
X-Microsoft-Antispam-PRVS: <BL0PR01MB45468B5E9D9BD632C3FAA3D5F4669@BL0PR01MB4546.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SRCGl0Q2lcag1B48a2M/Jp667PADkxGIbp8iEsYC7rPCi5w4Lkhbb8lgtxbPGVkO0gEsPnMpw02Q7FeyPBLap7I5RWlA0LBCPwD8wSRtdJtvPXPCtFXmz3A6WXyWGbizr90/JmqFvcBkDFESLZqUo7AVHNfUfCp7ItknNQtN2pAzMlSGOzotGwfwSsyWWMrczcWzN8vWuvrdXPuEP0Jt6EnJAS1EflplwTKDxP6jEs1Jyp2+e7NlzVrc7LEGrxUNMR9A14mXpoIoc/RIBd4ikR25IAim25Xd6T2xn59ZFM77vZOq2KurHVvw28Wk/UXKaR609gPN+z1a7l5qQEYWnmetaT5N7YVxm6dFfRNTG/GQihWJV7jZQmEGSH7lw1mLJBTfIY6M5G7gnkeEeVfVVZdGzk86ZbNP7DYQC2+hg/4ZVeZOgfxEb7A9SG0zWqUdYiaGcJdjSztPHHtNEXINCclker1D7XGqGg26K6NDb1pKsh5bhgo/yzDMXRwj5QU9h/GHK7panpAhRwe7iJZFv7xE+mEjDHj2Qc4WCA7q0VhKOpubKe09KxGsrb/onzmWV4djD0FRhYMWTiZUk3UNpeJdzgZ28mNEP/2UOUuEBCkcPLYFS3GD0ocyNt6JHyF7aXFflYH9Fw/syYs/BAxcydHzGX36amfNX7ZaWGxLyLLBCcJhidQP0rB3OvOz9VUI+Gr4oF1bZVHbF119dRnDD3LT4W5DnLhYI18Vb7I5y5U=
X-Forefront-Antispam-Report: CIP:208.255.156.42;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:awfm-01.cornelisnetworks.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(136003)(376002)(39840400004)(396003)(346002)(36840700001)(46966006)(4326008)(2906002)(44832011)(7126003)(55016003)(81166007)(186003)(316002)(83380400001)(6916009)(336012)(26005)(70206006)(1076003)(426003)(103116003)(82310400004)(356005)(86362001)(7696005)(5660300002)(8936002)(36860700001)(508600001)(47076005)(8676002)(70586007)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 19:20:17.5373
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 14986a21-fde8-41dc-a280-08d9b36d4727
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a;Ip=[208.255.156.42];Helo=[awfm-01.cornelisnetworks.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR01MB4546
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>

This buffer is currently allocated in hfi1_init():

	if (reinit)
		ret = init_after_reset(dd);
	else
		ret = loadtime_init(dd);
	if (ret)
		goto done;

	/* allocate dummy tail memory for all receive contexts */
	dd->rcvhdrtail_dummy_kvaddr = dma_alloc_coherent(&dd->pcidev->dev,
							 sizeof(u64),
							 &dd->rcvhdrtail_dummy_dma,
							 GFP_KERNEL);

	if (!dd->rcvhdrtail_dummy_kvaddr) {
		dd_dev_err(dd, "cannot allocate dummy tail memory\n");
		ret = -ENOMEM;
		goto done;
	}

The reinit triggered path will overwrite the old allocation and leak it.

Fix by moving the allocation to hfi1_alloc_devdata() and the deallocation
to hfi1_free_devdata().

Cc: stable@vger.kernel.org
Fixes: 46b010d3eeb8 ("staging/rdma/hfi1: Workaround to prevent corruption during packet delivery")
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
---
 drivers/infiniband/hw/hfi1/init.c |   33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 6422dd6..4436ed4 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -875,18 +875,6 @@ int hfi1_init(struct hfi1_devdata *dd, int reinit)
 	if (ret)
 		goto done;
 
-	/* allocate dummy tail memory for all receive contexts */
-	dd->rcvhdrtail_dummy_kvaddr = dma_alloc_coherent(&dd->pcidev->dev,
-							 sizeof(u64),
-							 &dd->rcvhdrtail_dummy_dma,
-							 GFP_KERNEL);
-
-	if (!dd->rcvhdrtail_dummy_kvaddr) {
-		dd_dev_err(dd, "cannot allocate dummy tail memory\n");
-		ret = -ENOMEM;
-		goto done;
-	}
-
 	/* dd->rcd can be NULL if early initialization failed */
 	for (i = 0; dd->rcd && i < dd->first_dyn_alloc_ctxt; ++i) {
 		/*
@@ -1200,6 +1188,11 @@ void hfi1_free_devdata(struct hfi1_devdata *dd)
 	dd->tx_opstats    = NULL;
 	kfree(dd->comp_vect);
 	dd->comp_vect = NULL;
+	if (dd->rcvhdrtail_dummy_kvaddr)
+		dma_free_coherent(&dd->pcidev->dev, sizeof(u64),
+				  (void *)dd->rcvhdrtail_dummy_kvaddr,
+				  dd->rcvhdrtail_dummy_dma);
+	dd->rcvhdrtail_dummy_kvaddr = NULL;
 	sdma_clean(dd, dd->num_sdma);
 	rvt_dealloc_device(&dd->verbs_dev.rdi);
 }
@@ -1297,6 +1290,15 @@ static struct hfi1_devdata *hfi1_alloc_devdata(struct pci_dev *pdev,
 		goto bail;
 	}
 
+	/* allocate dummy tail memory for all receive contexts */
+	dd->rcvhdrtail_dummy_kvaddr =
+		dma_alloc_coherent(&dd->pcidev->dev, sizeof(u64),
+				   &dd->rcvhdrtail_dummy_dma, GFP_KERNEL);
+	if (!dd->rcvhdrtail_dummy_kvaddr) {
+		ret = -ENOMEM;
+		goto bail;
+	}
+
 	atomic_set(&dd->ipoib_rsm_usr_num, 0);
 	return dd;
 
@@ -1504,13 +1506,6 @@ static void cleanup_device_data(struct hfi1_devdata *dd)
 
 	free_credit_return(dd);
 
-	if (dd->rcvhdrtail_dummy_kvaddr) {
-		dma_free_coherent(&dd->pcidev->dev, sizeof(u64),
-				  (void *)dd->rcvhdrtail_dummy_kvaddr,
-				  dd->rcvhdrtail_dummy_dma);
-		dd->rcvhdrtail_dummy_kvaddr = NULL;
-	}
-
 	/*
 	 * Free any resources still in use (usually just kernel contexts)
 	 * at unload; we do for ctxtcnt, because that's what we allocate.

