Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 814B7496843
	for <lists+stable@lfdr.de>; Sat, 22 Jan 2022 00:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiAUXe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jan 2022 18:34:57 -0500
Received: from mail-am6eur05on2113.outbound.protection.outlook.com ([40.107.22.113]:33298
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229814AbiAUXe5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Jan 2022 18:34:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lw42IqNGcw4v78HRv17m1y+87ZHCAGEXd+QdE+LMxCAUjQ+ESiOEA14XH19thzS0xubX5d24kZ88areYseJAZ9O3iynHE67E6WJzfl6YjDHHLV+gJLW1nC5nnUXXuzELc34iFJETRNMWROBl4goQSFfaUynAaDHrPUemChBMbsBEHHq2nC6TjzbidrTBL0eNzkMyW/LpM40WhrrWVF2RRmzpr4v4bK1bPukTSbCAUM0+csez97WvdFp3TcGLFwCyxkuMZ6tBgnvBYHgFVuBUZoMPMbN5cwGcNvYBGztXMQ+8XZmiE0Z9pyeEwRTSqFEu+wZrheLvTnCXWj6Ys0d6Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BzYa0NJNqeVrErnu1r8Ho20M32iIJi9uTKOy7nbV4KI=;
 b=DyMiHeC69G9QyKcvNgsQCmASmkS6zecCduTagYcyzd0pkpNR63K9C0dZ5xegVr9yvho20ARpqxu9DZgSOJSWDFMvVrnWpRSVUo21toxUdzN2JwoLWQaNTU6MHa5GTG08Vc38R/RjTg8WR+d9POmXGJTh/KoUYGWPbD7GGVhqpUs/AG0n264LPD5daucDJdH3gXxQibXjRI07nXABzr01Js8okEt1sU47rkqCYlqO7RK7nnra3zQI4PKvj9pErhZjB9QaxbEJLA5HmbYPCIfQon/gy6eo8439dRPDCc87HvQzTJfZAJuJB+3RFhb5Ub5XrUohEpfc/NxK6RrPfB7uPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 194.176.121.59) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=sma.de;
 dmarc=fail (p=quarantine sp=quarantine pct=100) action=quarantine
 header.from=sma.de; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sma.de; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BzYa0NJNqeVrErnu1r8Ho20M32iIJi9uTKOy7nbV4KI=;
 b=Ollj98ZEgFHINQulv7WHG5DEmYcLFIJa+QiYIFW+sW8frY+oHbY7JNs7M3D6pZki9gVJYe8gStwyzoRvB8x9of7NTUTLs3JmWAPO/1eplttWsXeEsoX4Jt3KMrY0Swr/jdWPATPnYGe5NIfcICzf3WySqyR97in+a4tozNk8ADA=
Received: from OL1P279CA0053.NORP279.PROD.OUTLOOK.COM (2603:10a6:e10:14::22)
 by VI1PR04MB3008.eurprd04.prod.outlook.com (2603:10a6:802:f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Fri, 21 Jan
 2022 23:34:53 +0000
Received: from HE1EUR02FT042.eop-EUR02.prod.protection.outlook.com
 (2603:10a6:e10:14:cafe::4a) by OL1P279CA0053.outlook.office365.com
 (2603:10a6:e10:14::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7 via Frontend
 Transport; Fri, 21 Jan 2022 23:34:53 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 194.176.121.59) smtp.mailfrom=sma.de; dkim=none (message not signed)
 header.d=none;dmarc=fail action=quarantine header.from=sma.de;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning sma.de
 discourages use of 194.176.121.59 as permitted sender)
Received: from webmail.sma.de (194.176.121.59) by
 HE1EUR02FT042.mail.protection.outlook.com (10.152.11.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Fri, 21 Jan 2022 23:34:52 +0000
Received: from SVR-DE-EXHYB-01.sma.de ([10.0.40.14]) by webmail.sma.de over TLS secured channel with Microsoft SMTPSVC(8.5.9600.16384);
         Sat, 22 Jan 2022 00:34:20 +0100
Received: from pc6682 (10.9.12.142) by SVR-DE-EXHYB-01.sma.de (10.0.40.14)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.2176.2; Sat, 22
 Jan 2022 00:34:08 +0100
Date:   Sat, 22 Jan 2022 00:34:07 +0100
From:   Andre Kalb <svc.sw.rte.linux@sma.de>
To:     <stable@vger.kernel.org>
Subject: [PATCH] regulator: core: Let boot-on regulators be powered off
Message-ID: <YetC7/ZaUwd68hGi@pc6682>
Reply-To: Andre Kalb <andre.kalb@sma.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [10.9.12.142]
X-ClientProxiedBy: SVR-DE-EXHYB-01.sma.de (10.0.40.14) To
 SVR-DE-EXHYB-01.sma.de (10.0.40.14)
X-OriginalArrivalTime: 21 Jan 2022 23:34:20.0069 (UTC) FILETIME=[69CA2D50:01D80F1F]
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e24023c-115e-4771-0202-08d9dd369fc9
X-MS-TrafficTypeDiagnostic: VI1PR04MB3008:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB3008D6C9BDA0C362403AA2F7E35B9@VI1PR04MB3008.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:275;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tWLgJqYP0QvCFwLglI8kF/SZ+EexPBMJ83QGusoSYU0ccDK/g6fz6pvLaBQZzaDz6PKTREboJIKj+KPNJ6ZReHns9E0XBRmHpDQGJyweoa8aVMD0gZEEM9xpjcuxfGhUaZwrfGBy40j82Jr+N6ovwhTKPJTZqVdmdw7zLPvQlJNyGpO7Glxk5y0KK7qouLDGF/WGHzdWAL/Et8llbPu1FL4IiAIOyC1K/EI2wHhCjvK5dWoCApc20Dvf7lDvrpij+zUufXEmE3cw6CYu3jzPzx/hyOvRtln3g5mSZXNC7u+23onU9wDlhcYWgwGqllDw6AZqy1o/iYEZ3yiYAoGtXJbBIbWY/AbfAFPc3wj5bBAanCXv91GBC/DbFs7TOuHYzy8/ceI3HknQco1Wo2r3Kd5zeXweWPjNQxa7wEI62BQub1zah+DlsBhvOAYF5sSjgb15JqpWwUo6iHmH5xB4sKB+fL/O5PGXnaWOvige9hQeNLdVXyIpeOkxfyqLMJoCsZi5XBMXBMcMN3PraSpi6Vljcr17d7Lsq/Vw2zKgpFoiXxc7wAFEOu6uGK8crEo0yrQlWmvdRgSD0bIriIJwbS+Ih4kvizSeJKivdkSgrAXShRW/KAmqMpvXzaO8YkkaTfMPHeZEV5m5efcQpWkphRx5C0250Z3KGVlF1Bo0+us7Ir/h1pokWwT7NCWBO93zO3YXu6+zW7/TIYx/rmtwkDcHh4j1lCrTXOp51gNm+gZlDR7tPW3evxpqHdqn6TRLNMphakDLeRo9q/Nl+NJo1rH45dauKBQIxdW9iWqy37xivCp4R9iU3mct5yLiq5VC
X-Forefront-Antispam-Report: CIP:194.176.121.59;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:webmail.sma.de;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(86362001)(6916009)(9576002)(26005)(186003)(8676002)(47076005)(426003)(356005)(36860700001)(16526019)(5660300002)(336012)(2906002)(9686003)(83380400001)(81166007)(70586007)(508600001)(82310400004)(70206006)(55016003)(966005)(33716001)(8936002)(316002)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: sma.de
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 23:34:52.7733
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e24023c-115e-4771-0202-08d9dd369fc9
X-MS-Exchange-CrossTenant-Id: a059b96c-2829-4d11-8837-4cc1ff84735d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=a059b96c-2829-4d11-8837-4cc1ff84735d;Ip=[194.176.121.59];Helo=[webmail.sma.de]
X-MS-Exchange-CrossTenant-AuthSource: HE1EUR02FT042.eop-EUR02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3008
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 089b3f61ecfc43ca4ea26d595e1d31ead6de3f7b ]

Boot-on regulators are always kept on because their use_count value
is now incremented at boot time and never cleaned.

Only increment count value for alway-on regulators.
regulator_late_cleanup() is now able to power off boot-on regulators
when unused.

Fixes: 45f9c1b2e57c ("regulator: core: Clean enabling always-on regulators + their supplies")
Signed-off-by: Pascal Paillet <p.paillet@st.com>
Link: https://lore.kernel.org/r/20191113102737.27831-1-p.paillet@st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Acked-by: Andre Kalb <andre.kalb@sma.de>
# 4.19.x
---
 drivers/regulator/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 088ed4ee6d83..045075cd256c 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1211,7 +1211,9 @@ static int set_machine_constraints(struct regulator_dev *rdev)
 			rdev_err(rdev, "failed to enable\n");
 			return ret;
 		}
-		rdev->use_count++;
+
+		if (rdev->constraints->always_on)
+			rdev->use_count++;
 	}
 
 	print_constraints(rdev);
-- 
2.31.1

