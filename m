Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4542A41D6AC
	for <lists+stable@lfdr.de>; Thu, 30 Sep 2021 11:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349626AbhI3JrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 05:47:01 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:62826 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349566AbhI3Jqz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Sep 2021 05:46:55 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18U4hG1Y015493
        for <stable@vger.kernel.org>; Thu, 30 Sep 2021 02:45:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=hmmTsXtuaK4Sfp9Spk6mWHXnhj0T7bjoZiFfizNv1UE=;
 b=DLOJjCtVWkkZNfmLSix0wjYoDyoMRLpObNVUztqHsog+a/8eDofp04lwRtA0QZqPETJG
 u4vkJCwtdkIc2iHKWPFsaj2LhwE/F5kEge1GvCdn+5qVE9+jCtaTZxkAdv+BgILIoS29
 0pXjtes1YFEXVOSjaY+5eI183UkSogzaK9xj2Lge2g4HYTXNchc0WYmiuT61kI8hJLOh
 xEqyG3phq76vxRJ62viKvlQsALJOcBL7h52pg6siqqHr1DVJdyusBHLIRljDjBAUQzjC
 LDrz5cnKVXt95ZgCbCATDGMryMDV9JqTEbpm+0SdAiWjmEu9rd3QVZnXL9xTiXWYz4AZ 3w== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by mx0a-0014ca01.pphosted.com with ESMTP id 3bct60ugsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 30 Sep 2021 02:45:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QIsb36drSK54vZx+i0Vxv2wxOIebJZlC0QEEODJhEEygWU+b7VzdssEg/iZn+QvuW43rV5tccZVeXvZJhC3cQCFgL64d8I2YkMYSQ7lKcNH174c8IrRMg9ze7oq+lT4kBZFiP6Ay2Fybaqig3VUSNApuu+oK8hM6NDYngSnwKv9vKWeYztO6ZDqq23X7bu0nd/ETbWs+OBvA8uvQEDx613udfLhYKyZ/uTSEcX+FMYOpIBjDU7HWlVQR/1YTk+8D9099G/DmyP9wV90v9WVpFBbvVyADaRXXSuzWW3+3QkRRcvjL4JPAWbYjJSoTxpoeVykBlY0DhU5PUgoRGjzSKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=hmmTsXtuaK4Sfp9Spk6mWHXnhj0T7bjoZiFfizNv1UE=;
 b=BhACvJ6S/5mDrqgXgCjgpv5mvd5RWSaiVVQ6DUfwwCAIgwC8ArXgpGW3jAlwPnR9QTcMpw4SnbKys4M7LgYxMS/8b3tHsjNPqdOxPRMHhbMb9cYDl/2wc8+sFeXH38BWgjNItvwomnIkEK1vaXaR+gqLyjNpwoE5JMw5d8lUjDDw4HLmFAlBUj3Iwv7eJccyxhlkXbd5bvEkjha2R+mEcbx/PkAQZpfnf0NQL8p2Hann44ulJQ4fvdPOLrFIX49/rVqSW6JBeOoFkhE4LUZbTDpi2WsH9b5AemJBPqFKlObqGYIwMtOgOuU4D/LiTG5qDdkwNASiwI/9bcBROBU8Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 64.207.220.244) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hmmTsXtuaK4Sfp9Spk6mWHXnhj0T7bjoZiFfizNv1UE=;
 b=YPSYJOy510ktTB2pDbAL6/HYw5APrQJlhqlBOeOSssrj6PdZAE8VtSnRGAQYAyDxAKPWXP5B30YZTF9MdhPlCzGi4D0sD3Rf6WeNAv1/O6H5xRTEMFcmZ+6qroXW/iQ9siykxf+0yv53tK1MFeBl/SkclWAhAN4+Gg1RHmHcuHo=
Received: from DM3PR11CA0007.namprd11.prod.outlook.com (2603:10b6:0:54::17) by
 DM6PR07MB7977.namprd07.prod.outlook.com (2603:10b6:5:33::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4544.15; Thu, 30 Sep 2021 09:45:05 +0000
Received: from DM6NAM12FT060.eop-nam12.prod.protection.outlook.com
 (2603:10b6:0:54:cafe::40) by DM3PR11CA0007.outlook.office365.com
 (2603:10b6:0:54::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend
 Transport; Thu, 30 Sep 2021 09:45:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 64.207.220.244)
 smtp.mailfrom=cadence.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none
 header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 64.207.220.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=64.207.220.244; helo=wcmailrelayl01.cadence.com;
Received: from wcmailrelayl01.cadence.com (64.207.220.244) by
 DM6NAM12FT060.mail.protection.outlook.com (10.13.179.128) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.8 via Frontend Transport; Thu, 30 Sep 2021 09:45:03 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by wcmailrelayl01.cadence.com (8.14.7/8.14.4) with ESMTP id 18U9j2EK202349
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=OK)
        for <stable@vger.kernel.org>; Thu, 30 Sep 2021 02:45:03 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu5.global.cadence.com (10.160.110.202) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 30 Sep 2021 11:44:43 +0200
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu5.global.cadence.com (10.160.110.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 30 Sep 2021 11:44:43 +0200
Received: from gli-login.cadence.com (10.187.128.100) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 30 Sep 2021 11:44:43 +0200
Received: from gli-login.cadence.com (localhost [127.0.0.1])
        by gli-login.cadence.com (8.14.4/8.14.4) with ESMTP id 18U9ihxG027349;
        Thu, 30 Sep 2021 11:44:43 +0200
Received: (from pawell@localhost)
        by gli-login.cadence.com (8.14.4/8.14.4/Submit) id 18U9ig4S027348;
        Thu, 30 Sep 2021 11:44:42 +0200
From:   Pawel Laszczak <pawell@cadence.com>
To:     <stable@vger.kernel.org>
CC:     Pawel Laszczak <pawell@cadence.com>
Subject: [PATCH] usb: cdns3: fix race condition before setting doorbell
Date:   Thu, 30 Sep 2021 11:42:17 +0200
Message-ID: <20210930094217.23316-1-pawell@gli-login.cadence.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d32f7e17-5f95-4af5-6881-08d983f6faaa
X-MS-TrafficTypeDiagnostic: DM6PR07MB7977:
X-Microsoft-Antispam-PRVS: <DM6PR07MB7977329E21E4F4926E6E94A1DDAA9@DM6PR07MB7977.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:843;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ncMR4O/S6GenjJq/dRXGmqn7q7EnrQyMYAg0by4VdbT6cbbT0i0TNYy1g9aaYkcDyEqlf+G4czHJ3miea8Gs+oJL8eBU7aE/4DLbZ+MckKJ5OXP86/4piopaB6M6CjKnGD32PQm3HPPGONgXL78LwpA6wQ5KVxRbjNGTs6tjZD60nqwFPO1I0EzOLvNtddEAI/blBU9ug16G9I2nR2zCkAyT2sZciBPsiFT98tH5wo6qG1//jnmzSUaes+EpALaAHKErGI+bGIY0CWMWJLiF3ccmbAgUdxbokeg+5g41VYUYHCqmRhZ7n0KewjA1O7iqUIkvEmBOn+w57ZSCWaiD3SVl3HWjDCf5NcaV8MqHO7J4YOvvrbD1kr0bHMUwQIy+dmzaPxif1o5Rai43o9nRTftHjhUFcuexvQvU8alTnjqMcpCc1MkZvY4X4a068pbLxQI70l9a+DlS2igUEo4IxONBrwGDgDxq9fSh9lb3OZfw3q2UOwHGvF7GfX1WMRPS0aZYBnZLEa6dt+avCkn31wKDlQ9zJV2im2vsz/IVvm9pUsNbgYgQpQohLIK6VvU5GbFoktgiiOugmkRFipLiNJw//sHU1twDNFmgihxSnJXrUR553iIdzFtjSmhltT7QIDIRpyq4r0uldyqQJVlzB/ducZhqHsVmZRTvaWNHGtmDXkk534jitMgObVBbw64LVPgs/WpyeH6sc5u9iifLclTMt4H6UnXMaspTxdzYiDJ7+OSQE2kXPQxJ5Es3hb57X36n7FfCW52Nt4hmLB+29A==
X-Forefront-Antispam-Report: CIP:64.207.220.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:wcmailrelayl01.cadence.com;PTR:ErrorRetry;CAT:NONE;SFS:(4636009)(36092001)(46966006)(36840700001)(6666004)(81166007)(316002)(36860700001)(42186006)(86362001)(4326008)(426003)(5660300002)(356005)(1076003)(8936002)(336012)(8676002)(6916009)(82310400003)(83380400001)(107886003)(26005)(70586007)(2906002)(70206006)(508600001)(186003)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 09:45:03.9241
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d32f7e17-5f95-4af5-6881-08d983f6faaa
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[64.207.220.244];Helo=[wcmailrelayl01.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM12FT060.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB7977
X-Proofpoint-GUID: emKisD-i5AbCq6BM1ezRSXI8NnUDpQ2H
X-Proofpoint-ORIG-GUID: emKisD-i5AbCq6BM1ezRSXI8NnUDpQ2H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-30_03,2021-09-29_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 phishscore=0
 suspectscore=0 spamscore=0 mlxlogscore=883 lowpriorityscore=0 bulkscore=0
 mlxscore=0 priorityscore=1501 impostorscore=0 clxscore=1015 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109300060
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

commit b69ec50b3e55c4b2a85c8bc46763eaf33060584 upstream

For DEV_VER_V3 version there exist race condition between clearing
ep_sts.EP_STS_TRBERR and setting ep_cmd.EP_CMD_DRDY bit.
Setting EP_CMD_DRDY will be ignored by controller when
EP_STS_TRBERR is set. So, between these two instructions we have
a small time gap in which the EP_STS_TRBERR can be set. In such case
the transfer will not start after setting doorbell.

Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
cc: <stable@vger.kernel.org> # 5.4.x
Tested-by: Aswath Govindraju <a-govindraju@ti.com>
Reviewed-by: Aswath Govindraju <a-govindraju@ti.com>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
---
 drivers/usb/cdns3/gadget.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/usb/cdns3/gadget.c b/drivers/usb/cdns3/gadget.c
index f624cc87cbab..5edde6a0e77a 100644
--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -807,6 +807,19 @@ static void cdns3_wa1_tray_restore_cycle_bit(struct cdns3_device *priv_dev,
 		cdns3_wa1_restore_cycle_bit(priv_ep);
 }
 
+static void cdns3_rearm_drdy_if_needed(struct cdns3_endpoint *priv_ep)
+{
+	struct cdns3_device *priv_dev = priv_ep->cdns3_dev;
+
+	if (priv_dev->dev_ver < DEV_VER_V3)
+		return;
+
+	if (readl(&priv_dev->regs->ep_sts) & EP_STS_TRBERR) {
+		writel(EP_STS_TRBERR, &priv_dev->regs->ep_sts);
+		writel(EP_CMD_DRDY, &priv_dev->regs->ep_cmd);
+	}
+}
+
 /**
  * cdns3_ep_run_transfer - start transfer on no-default endpoint hardware
  * @priv_ep: endpoint object
@@ -1003,6 +1016,7 @@ int cdns3_ep_run_transfer(struct cdns3_endpoint *priv_ep,
 		/*clearing TRBERR and EP_STS_DESCMIS before seting DRDY*/
 		writel(EP_STS_TRBERR | EP_STS_DESCMIS, &priv_dev->regs->ep_sts);
 		writel(EP_CMD_DRDY, &priv_dev->regs->ep_cmd);
+		cdns3_rearm_drdy_if_needed(priv_ep);
 		trace_cdns3_doorbell_epx(priv_ep->name,
 					 readl(&priv_dev->regs->ep_traddr));
 	}
-- 
2.25.1

