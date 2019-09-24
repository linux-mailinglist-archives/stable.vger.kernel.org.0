Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E423ABC18A
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 07:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409019AbfIXF44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 01:56:56 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:55050 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407957AbfIXF44 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Sep 2019 01:56:56 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8O5q3Cf005689;
        Mon, 23 Sep 2019 22:56:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=X/UFUgGlJSnJ7VZ/c/9TW0G19h38aWqNZIqWJUeJUtM=;
 b=dq7/C3esbqCXsVAE/YV+xZV+Rh08eZLig7snIfO12xo+JqTOJCBk5U4rLKY76hHVzJfY
 AyTFl6TFBKF4mOOcMbewiLM9k9Lvb4LpeGsg8nUx7hNzVFJyENim6GQIMG6XLb8asNMF
 qW7z76rjsKZlCO43U5xU9s6hzZnQoinQmeZBuxv+j2370qDlpWIH52/2tzrxICtT8sHG
 WkWYMtAYxj7oVYqh1JCboYTtkiHCOvumJ/LkpFBqHJRfJAQBQXpUVSdNsgZJNad45t+Y
 J5ZKycaJPc5pCn7EYncjMA5TbWcE4xgvU3E/KLodb9v5B98glBRk8/93GwHCu7tZSBH9 AA== 
Received: from nam03-dm3-obe.outbound.protection.outlook.com (mail-dm3nam03lp2050.outbound.protection.outlook.com [104.47.41.50])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2v5ge09tyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Sep 2019 22:56:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lGZWWvCEXVCQ6tOl4Nb2mgJDSJ/yKgLFaxY6y3BX7k1OJCnh2SPLJ+PnuC98ZxpuhZ5pASnRTlAnowq2DsSAXDFj/T6BjDvcb9Tcjp/pMuaD1T7kwfSvlYm5T5FMkKjwIdbJBh5zphuv4hL47xjlwjvlX27syQe/AtCzeA0UKtIyclhNn3RXgK4o4lfuB8drLP720c9ei3YBXpEybFhCvZD4gOLYFsAEQE9RLULPOulfjP6oPQQIBfY+taHQvioNnJrK1EiqUZGgu6tnUIpsqD1G+GZ1g00Y8vB8pxWs1tmBrETkyUJOpPtsb/gev2doN+6AZjAxGII94l5F8OTX+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X/UFUgGlJSnJ7VZ/c/9TW0G19h38aWqNZIqWJUeJUtM=;
 b=AOAips/VSE5I5zEKS+gmFrqINt33aavHJIMXSnEcH/B86BqHdjhK+fA7quOQv0+L11+qG4IoUFIX6si7zwTxJPcHWdxWhZUZyQBEphhW87RDVI/xSFaqXPRa354aKhB7fKN/KduE/qjfYSITcxYyhE+Ti3nxb5viW+PxC8nyPIoAM2BSmrm66J3YRjRU8yc0OLZJGy+pcyGLh0dUbGEp9V8S7/wCvCZHqBwH9s+ndajzcMuVutK+l1Hte3v+eP+gzePEDlzJs+6CRgBLBPWo9x8knKhZ8TRVKloPvGLWfzfpqNzLIijKFpiW9AntyWZIP1Qyt8t2l9aui9m6D8YsIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 64.207.220.243) smtp.rcpttodomain=gmail.com smtp.mailfrom=cadence.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X/UFUgGlJSnJ7VZ/c/9TW0G19h38aWqNZIqWJUeJUtM=;
 b=yitYC8fsi/vxpbKRDwc3r0EmyYCsSzPoebp8vBGnbC8d9p3iZY+Y8SVZ940CVq2MY45t9WcDrdhICfepyx2hA7Mj14EnbuMIMsprUrg8/nuY1tT+chnZw9N3FIzsgh5DGjCkddfA0zadCEF2yWPugquMqs0nPHteQFqMxwyfgSw=
Received: from MN2PR07CA0009.namprd07.prod.outlook.com (2603:10b6:208:1a0::19)
 by MWHPR0701MB3674.namprd07.prod.outlook.com (2603:10b6:301:7e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2284.26; Tue, 24 Sep
 2019 05:56:08 +0000
Received: from DM3NAM05FT064.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e51::205) by MN2PR07CA0009.outlook.office365.com
 (2603:10b6:208:1a0::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2284.20 via Frontend
 Transport; Tue, 24 Sep 2019 05:56:08 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 64.207.220.243 as permitted sender)
Received: from wcmailrelayl01.cadence.com (64.207.220.243) by
 DM3NAM05FT064.mail.protection.outlook.com (10.152.98.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.15 via Frontend Transport; Tue, 24 Sep 2019 05:56:08 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by wcmailrelayl01.cadence.com (8.14.7/8.14.4) with ESMTP id x8O5txht021140
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=OK);
        Mon, 23 Sep 2019 22:56:01 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Tue, 24 Sep 2019 07:55:59 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 24 Sep 2019 07:55:59 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x8O5txDL006343;
        Tue, 24 Sep 2019 06:55:59 +0100
Received: (from piotrs@localhost)
        by lvlogina.cadence.com (8.14.4/8.14.4/Submit) id x8O5tshM006146;
        Tue, 24 Sep 2019 06:55:54 +0100
From:   Piotr Sroka <piotrs@cadence.com>
CC:     Piotr Sroka <piotrs@cadence.com>, <stable@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [v2] mtd: rawnand: Change calculating of position page containing BBM
Date:   Tue, 24 Sep 2019 06:54:31 +0100
Message-ID: <20190924055439.4212-1-piotrs@cadence.com>
X-Mailer: git-send-email 2.15.0
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:64.207.220.243;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(979002)(4636009)(396003)(136003)(376002)(39860400002)(346002)(199004)(189003)(36092001)(2906002)(70206006)(87636003)(305945005)(1671002)(86362001)(5660300002)(478600001)(70586007)(7416002)(1076003)(42186006)(36756003)(316002)(51416003)(36906005)(16586007)(50466002)(48376002)(47776003)(54906003)(109986005)(6666004)(356004)(426003)(186003)(126002)(50226002)(486006)(4326008)(81166006)(8936002)(81156014)(8676002)(26005)(476003)(336012)(2616005)(266003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR0701MB3674;H:wcmailrelayl01.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:unused.mynethost.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad6be0f6-c7d8-41b6-223d-08d740b3e50a
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(2017052603328);SRVR:MWHPR0701MB3674;
X-MS-TrafficTypeDiagnostic: MWHPR0701MB3674:
X-Microsoft-Antispam-PRVS: <MWHPR0701MB3674F904BF4AF3A2D512580EDD840@MWHPR0701MB3674.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0170DAF08C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: a85PWJr7fp3mHZ6JFNTRTi6znb+Q0ctMovNPnU5DWy6bBRaFMNL1d+yh1mvQlnwCK8ZKrfQTch2wG1lArNDPWqdrHdv0X42lLNLJBwzTcgDrZt883s7oJxlqMrCYYGnBz5Dg0kNEoOvVQPMIWjZOtoJnF5jpjvaVW/rAz2X3zHp6JhjBZ+cjhvuT6GKCfaRBfY7gwqTR7pfNay+KGmvFmdgC0KShi1B4o7AO0qWQDZrgN6ApwsMtQcNoH2/h+NcHRt7sXqk3C1Y6GugggAy8wkBLFcUsNcRgWh8dvic4QcoP6k1tTQdrh2NDtskgvw4ECtOtz00pFdXRiaNJRrFhlAFAtlYGUaNA6TSNKXBFwjQeANgouCaGVyJwVF2lS7DzRXVJIku8rYU1VD20IxrtrIATFm/upETQq9zYg2P/994=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2019 05:56:08.0823
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad6be0f6-c7d8-41b6-223d-08d740b3e50a
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[64.207.220.243];Helo=[wcmailrelayl01.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0701MB3674
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-24_03:2019-09-23,2019-09-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 malwarescore=0
 impostorscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 lowpriorityscore=0 phishscore=0 adultscore=0
 suspectscore=2 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1909240059
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Change calculating of position page containing BBM

If none of BBM flags are set then function nand_bbm_get_next_page 
reports EINVAL. It causes that BBM is not read at all during scanning
factory bad blocks. The result is that the BBT table is build without 
checking factory BBM at all. For Micron flash memories none of these 
flags are set if page size is different than 2048 bytes.

Address this regression by:
- adding NAND_BBM_FIRSTPAGE chip flag without any condition. It solves
  issue only for Micron devices.
- changing the nand_bbm_get_next_page_function. It will return 0 
  if no of BBM flag is set and page parameter is 0. After that modification
  way of discovering factory bad blocks will work similar as in kernel 
  version 5.1.

Cc: stable@vger.kernel.org
Fixes: f90da7818b14 (mtd: rawnand: Support bad block markers in first, second or last page)
Signed-off-by: Piotr Sroka <piotrs@cadence.com>
Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>
---
Changes for v2:
- add fix for micron nand driver
- add fixes and stable tags
---
 drivers/mtd/nand/raw/nand_base.c   | 8 ++++++--
 drivers/mtd/nand/raw/nand_micron.c | 4 +++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/raw/nand_base.c b/drivers/mtd/nand/raw/nand_base.c
index 5c2c30a7dffa..f64e3b6605c6 100644
--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -292,12 +292,16 @@ int nand_bbm_get_next_page(struct nand_chip *chip, int page)
 	struct mtd_info *mtd = nand_to_mtd(chip);
 	int last_page = ((mtd->erasesize - mtd->writesize) >>
 			 chip->page_shift) & chip->pagemask;
+	unsigned int bbm_flags = NAND_BBM_FIRSTPAGE | NAND_BBM_SECONDPAGE
+		| NAND_BBM_LASTPAGE;
 
+	if (page == 0 && !(chip->options & bbm_flags))
+		return 0;
 	if (page == 0 && chip->options & NAND_BBM_FIRSTPAGE)
 		return 0;
-	else if (page <= 1 && chip->options & NAND_BBM_SECONDPAGE)
+	if (page <= 1 && chip->options & NAND_BBM_SECONDPAGE)
 		return 1;
-	else if (page <= last_page && chip->options & NAND_BBM_LASTPAGE)
+	if (page <= last_page && chip->options & NAND_BBM_LASTPAGE)
 		return last_page;
 
 	return -EINVAL;
diff --git a/drivers/mtd/nand/raw/nand_micron.c b/drivers/mtd/nand/raw/nand_micron.c
index 1622d3145587..913f42854563 100644
--- a/drivers/mtd/nand/raw/nand_micron.c
+++ b/drivers/mtd/nand/raw/nand_micron.c
@@ -438,8 +438,10 @@ static int micron_nand_init(struct nand_chip *chip)
 	if (ret)
 		goto err_free_manuf_data;
 
+	chip->options |= NAND_BBM_FIRSTPAGE;
+
 	if (mtd->writesize == 2048)
-		chip->options |= NAND_BBM_FIRSTPAGE | NAND_BBM_SECONDPAGE;
+		chip->options |= NAND_BBM_SECONDPAGE;
 
 	ondie = micron_supports_on_die_ecc(chip);
 
-- 
2.15.0

