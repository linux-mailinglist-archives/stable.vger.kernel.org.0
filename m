Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEC51600FD0
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 15:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbiJQNDy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 09:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbiJQNDf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 09:03:35 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2054.outbound.protection.outlook.com [40.107.93.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0278A5FF69;
        Mon, 17 Oct 2022 06:03:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BMQMyR3YLcdCNJlgVxW5F2BB3OC9XntI5DVo14ZMocR2OAE/GzOZiCX8DX9pu5gb5byJGMYVjEl/mUnLPLl3L+qZP8n4DpfU8upve2FQN7aVJzWojkYy/ej3LKKh3hWucDhfLW9E5aEd/J9rAtsFKhYVgnzbHezSKKttpiZxveRNCbgl6X88937OvAMx1IX04Rs7iMdKm6by+6fFB6/Sp99nJPOgfOxl2OIotoxqjQkDzXT4c/5BWFQINtYRLZA5csU53wl9G2g+XzVGDGf7QGcy3a0imxozqBox5mtR5CPtE0modzdWad85FwLRaUAZYPw1cl2YkhpB5HDDWtCy0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BYuSInCvIAfCQ55JjQ6IWp5t2y7biL17oocUTqgL/3g=;
 b=BWStdwJI0S+IB3pgBd99tD6wzmFO4FtrPHxHugUVvMQWDGHEpCEFC5X0gDEUQ9eLyS507F7w39JoL43aQOrBDedS04pG8ExPUBtIZaq9U0Eb4ehTP4BLTk7Q685N6R2oG/ALq6PJezyOopQs2zg23u6a/2ljVRtVcN8ewdjhfcqotIWJBGvjdrXchzBaZE8OA41CujEevw2+dm2OJ7KQJY8/2T9HSVZnV3Ai+wH4ihqBMpsmKIw4Hy/pV/cQ5Lo5bsqAA1Y2vdXQcn+rqmGyhdYVBE1V7uUdmjIltau6c++bZAI0+qv169VWnae0fXxtLH1WSDN5PhF8sjpFqP8AVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linaro.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BYuSInCvIAfCQ55JjQ6IWp5t2y7biL17oocUTqgL/3g=;
 b=YG/+C/DnvlIYagtqH3x9fY25nc4BJotaQ0jfoqg5fbKfEvvYy3KNR0exBN8rZf+0CuNU/Sku8RSca5Nv8Mvb+jc6lyOhSxr2G7nvTUOtIutI9UC42fuUbNGvvvnGhhhMGb40Bya8QSGdHS3uEy9g+NvK/vtaIGdvkgc1LXVPi2Q=
Received: from BN9PR03CA0440.namprd03.prod.outlook.com (2603:10b6:408:113::25)
 by SN7PR12MB7022.namprd12.prod.outlook.com (2603:10b6:806:261::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Mon, 17 Oct
 2022 13:03:20 +0000
Received: from BN8NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:113:cafe::6c) by BN9PR03CA0440.outlook.office365.com
 (2603:10b6:408:113::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32 via Frontend
 Transport; Mon, 17 Oct 2022 13:03:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT055.mail.protection.outlook.com (10.13.177.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Mon, 17 Oct 2022 13:03:19 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 17 Oct
 2022 08:03:18 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 17 Oct
 2022 06:03:17 -0700
Received: from xhdlakshmis40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.31 via Frontend
 Transport; Mon, 17 Oct 2022 08:03:15 -0500
From:   Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>
CC:     <devicetree@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <saikrishna12468@gmail.com>, <git@amd.com>,
        Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 2/2] Revert "dt-bindings: pinctrl-zynqmp: Add output-enable configuration"
Date:   Mon, 17 Oct 2022 18:33:03 +0530
Message-ID: <20221017130303.21746-3-sai.krishna.potthuri@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221017130303.21746-1-sai.krishna.potthuri@amd.com>
References: <20221017130303.21746-1-sai.krishna.potthuri@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT055:EE_|SN7PR12MB7022:EE_
X-MS-Office365-Filtering-Correlation-Id: d51f0c87-5e3f-4c10-4fb4-08dab03ff6ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YSWjF7LWkKO4kCkwUTB4WMwCq5aeuVH+MK2zyZMFK2G83A/QOD+KcH0Rx6Ofiwlphbu8cc7hpy+vTXunvmJhYYyIqHgWldw/n2y5xEU5IOs1ArUV6TCwnedvcXibxOA4CubVJSiyLjqOavENHy/nBHUt1NlgO1oeutNWoYFC5gBOpAy1RIdQw0cqoTLz/QeGs8yV93HsQjqjcE/EscdeMdNdklcRjtkneLPgY/WjXg1hdyYtrYsKiib4JWJjqi+e92y21l6jer0B1nMjpxl7QXc8mptiZenQT8zSIEAdDb3JwY3huymTf0zIqpIYYWdj51nMYrZXlWBZi2zNSWjRmNQRe+hpGm41XBt957a0QtBRxAC4vHMyNRsyHOGXpV1/kRNiA/3OsUfmo43fQD1F2sFq87Qg9dDNxHFjo6CtMQrp640osRMv+QCGQOV4AH/rnS78Eavb7r8R+g2U4XGtDcyIV5Ancvv5JmEWhZgm+//T3CMDn5mhc+GqFJITvFKNDZaFnPFKRbAtSdptuIRPzmGzCib+jpiTl+Gs2rOPiNk4YFHntwKRvUxFLEJVqT6TaKjpN/4h2E0CdkzSJ7dza4G5JJAjaat/h9qr8RErawqPwO1r3FbvL7AyRhzCPSdp7T0fnFDVuA5hWCd3eNmu+3VUV/aIACkrr7vM9bdpv2qwkz+gWaosIKK1SsvcCWN2widQYkJfJ616uSrI2PsWu+dqh3LIhMxUx4ieNBXPetKDjqcEOmbsiU/OmPi9PLwpDr6GtnzTo6nXUlSs/Hoi5EYNPnCr8c0fbSECPDvVGD8dbRWMRW6RBoGvxs+TPv2a
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(136003)(376002)(346002)(451199015)(40470700004)(46966006)(36840700001)(82310400005)(40460700003)(478600001)(5660300002)(8936002)(8676002)(41300700001)(70206006)(70586007)(54906003)(110136005)(4326008)(40480700001)(316002)(36860700001)(103116003)(2906002)(83380400001)(86362001)(356005)(47076005)(426003)(36756003)(82740400003)(81166007)(26005)(1076003)(336012)(2616005)(186003)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 13:03:19.6178
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d51f0c87-5e3f-4c10-4fb4-08dab03ff6ce
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7022
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 133ad0d9af99bdca90705dadd8d31c20bfc9919f.

On systems with older PMUFW (Xilinx ZynqMP Platform Management Firmware)
using these pinctrl properties can cause system hang because there is
missing feature autodetection.
When this feature is implemented, support for these two properties should
bring back.

Cc: stable@vger.kernel.org
Signed-off-by: Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
---
 .../devicetree/bindings/pinctrl/xlnx,zynqmp-pinctrl.yaml      | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/xlnx,zynqmp-pinctrl.yaml b/Documentation/devicetree/bindings/pinctrl/xlnx,zynqmp-pinctrl.yaml
index 1e2b9b627b12..2722dc7bb03d 100644
--- a/Documentation/devicetree/bindings/pinctrl/xlnx,zynqmp-pinctrl.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/xlnx,zynqmp-pinctrl.yaml
@@ -274,10 +274,6 @@ patternProperties:
           slew-rate:
             enum: [0, 1]
 
-          output-enable:
-            description:
-              This will internally disable the tri-state for MIO pins.
-
           drive-strength:
             description:
               Selects the drive strength for MIO pins, in mA.
-- 
2.17.1

