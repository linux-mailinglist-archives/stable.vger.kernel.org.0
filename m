Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C037C46B304
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 07:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237100AbhLGGk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 01:40:57 -0500
Received: from mail-dm6nam11on2066.outbound.protection.outlook.com ([40.107.223.66]:30016
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S237000AbhLGGk4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Dec 2021 01:40:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aza1i/EKtnSeRbWilEyz4aLoeYBLx6xIrqk3My3Q8DbWfFj9atuxbqAp3wVU8lZTmRgBVc5/+RtyKiWbqTvkIIn0+SFlDINahB0lUAagZqUt1J0iU7uY2ydONKW0On0InBNBrfqGHOhEIqDUGnhWBP6bloFCI9oUcIJEnc/w/t1GUl/JOY4WEmjKPFqvNRa0rqj6ukupcxz+IRAFgf7AJuBjfpLTwGfhFgDiw/gAsTKm1N8nc8z4pH3GpE4c5U5d0cY+6n+G/oK5sq3ktLnC2I4qU0HFkOQdxIAEfF5JDGlxl8U2vLMgP9g2UDvrRH0BrooGGHtKr9P8Af4GLuiSow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R6xwUk0bgQS5WSOzRPW5Oltf11UbhLUv24Jh0MnySTc=;
 b=mXIn4EDU5hrjBO+cEQoQLDofcwnpSR0Bc6BR7n3F6o05pUidQ+JBhz3J9P03gRAFXmUy3ko3t2CyKy8uiHf8BS1huWPxCfYimb1m76Vc6BYoha4o8R4T9/rDx9RVUMpzWrlhkz6MvQ58i9pstZXcFkjPAL3DohmI6MtWpw4095BYz8aHHou5EMuyBod1TOZ5JRV99Kqu+MDZL9NLXAaz3FzUdqKV+BQUvbyTaaMcbIihqNC6pw1LsEZzuWdEXY31f3bzewLvHexZvWwn5QsNhAZIhTAXsIxPkk+Pvlj9qdsxJoXklzM97L54JXIIw1xtQLjYPnfv1wKMA6ITUZadWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 216.228.112.32) smtp.rcpttodomain=suse.com smtp.mailfrom=nvidia.com;
 dmarc=temperror action=none header.from=nvidia.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R6xwUk0bgQS5WSOzRPW5Oltf11UbhLUv24Jh0MnySTc=;
 b=C1PhE8UwvVZzthUdsriTzcqCyOZB3wRo2U0Vty3YKNd8fHoABhuwx6yo1wmOu+Vgyxa4S0yL3wY9BtPfvH57QhzzQeVxa5ydKmvRZeRC4+7g5iPzIGR4yZ8Pg4G7pJQf2t/2G9L0odLFWLevmUGpWxLF5MfQL7WLtyN0xN1aznhMp65qiaTLK+Jtyu9riSrxhidqEMJXGmYZFN6azgZPNuCdn8LvSFRGyVoo+ZCQNrr8E4s3KkWV4gLQ2fP9IgeqaIV2rIqkxD9jBRC7cfwkb9DYJfik8hsIL/H0nTPqyl5DcUKrKKRd3wztOqK722G48wA70VT59Hf1hgFWaxSP1w==
Received: from BN1PR14CA0009.namprd14.prod.outlook.com (2603:10b6:408:e3::14)
 by MWHPR12MB1840.namprd12.prod.outlook.com (2603:10b6:300:114::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Tue, 7 Dec
 2021 06:37:23 +0000
Received: from BN8NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e3:cafe::e0) by BN1PR14CA0009.outlook.office365.com
 (2603:10b6:408:e3::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.19 via Frontend
 Transport; Tue, 7 Dec 2021 06:37:23 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 216.228.112.32) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=nvidia.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of nvidia.com: DNS Timeout)
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT003.mail.protection.outlook.com (10.13.177.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Tue, 7 Dec 2021 06:37:21 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 6 Dec
 2021 22:37:17 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 7 Dec
 2021 06:37:17 +0000
Received: from audio.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 6 Dec 2021 22:37:14 -0800
From:   Sameer Pujar <spujar@nvidia.com>
To:     <tiwai@suse.com>, <broonie@kernel.org>, <lgirdwood@gmail.com>,
        <robh+dt@kernel.org>, <thierry.reding@gmail.com>, <perex@perex.cz>
CC:     <jonathanh@nvidia.com>, <digetx@gmail.com>,
        <alsa-devel@alsa-project.org>, <devicetree@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Sameer Pujar <spujar@nvidia.com>, <stable@vger.kernel.org>
Subject: [PATCH 1/3] ALSA: hda/tegra: Skip reset on BPMP devices
Date:   Tue, 7 Dec 2021 12:02:48 +0530
Message-ID: <1638858770-22594-2-git-send-email-spujar@nvidia.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1638858770-22594-1-git-send-email-spujar@nvidia.com>
References: <1638858770-22594-1-git-send-email-spujar@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c56cb41-79a2-4fc5-aae8-08d9b94c0634
X-MS-TrafficTypeDiagnostic: MWHPR12MB1840:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1840A29002A9EE5729B95F39A76E9@MWHPR12MB1840.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:480;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mi0JdKltRItsI1Be+ASuR9ZBe3bQbo+ZTa6M2klA7VWtCbmLKk7pNbH88NocmiwPRm8hinIzg4iLrumT36K3aBW49lT9FSKxUzoAX1aZHgKC+1d4eC2AaPvEx3wQvcyF43oopsn+Lajc5C4/MKxDWp8gDQK0XaLytd3uyQK5QvaGWq/wFXDxkQJlccsj5ikfaoSS+PNvUeUiF7vwvWi06g7pVWSASLlCXp5vMKL3I4eOacXHg5/rg2W0HUvHARpXjkbfR4FVeKJSH5GrNugK/kUy2cpTLTtTiraAuVmkF/yewPAB62BO8Mac3vggwt6JHIuk65OdyPTAzPLfHq2zbX+N6iCf3qf/onbqGK0HmfEvzzI19DC6YDJQn8yQ7u+Ph69p0XDMl1EiKNu2BbO7IJbxluyLCzGeNUcMVPzOMgzAb3bKUXneMFWcOMABlVp6B1wkBEAjz0yJAR8SZ+j/q1gffdilgVe/kqLMSmrb/aIhimDfSglhZs52p3cglnKFq1vI4Z8Tb+eF3QmszYFe/8XPIOAecGmkAmJxmG5wWZ3+XHtCE2X/bASq7ERvuAgA9fWiq5RUEQwrC8qZmKrjm/sEVuNv0djgOoeMObXo9ttoVyIeIaPMK9/OnKJlTeItBQTl4vyAc+/ZkJ6S5+Cw12oDusOp2XVdnkH4QImTQse4GWOcOCclr42B2oX5W1RGzdlScR2KIgpXbgFpqF4IKuA2vEC07LrrekZhRPOJ+YxPs+bA6gRYRS4Ul6+9Ns2/pp+Yxc64Nkf+dfOUOEsJKOOPPqzv/BkgBBJGGxijeU0=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(36860700001)(4326008)(186003)(508600001)(47076005)(83380400001)(40460700001)(7696005)(86362001)(26005)(36756003)(34070700002)(2906002)(7416002)(63370400001)(5660300002)(70206006)(70586007)(110136005)(426003)(63350400001)(8936002)(2616005)(316002)(54906003)(82310400004)(7636003)(356005)(6666004)(8676002)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 06:37:21.6935
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c56cb41-79a2-4fc5-aae8-08d9b94c0634
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1840
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

HDA regression is recently reported on Tegra194 based platforms.
This happens because "hda2codec_2x" reset does not really exist
in Tegra194 and it causes probe failure. All the HDA based audio
tests fail at the moment. This underlying issue is exposed by
commit c045ceb5a145 ("reset: tegra-bpmp: Handle errors in BPMP
response") which now checks return code of BPMP command response.

The failure can be fixed by avoiding above reset in the driver,
but the explicit reset is not necessary for Tegra devices which
depend on BPMP. On such devices, BPMP ensures reset application
during unpowergate calls. Hence skip reset on these devices
which is applicable for Tegra186 and later.

Signed-off-by: Sameer Pujar <spujar@nvidia.com>
Cc: stable@vger.kernel.org
Depends-on: 87f0e46e7559 ("ALSA: hda/tegra: Reset hardware")
---
 sound/pci/hda/hda_tegra.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/sound/pci/hda/hda_tegra.c b/sound/pci/hda/hda_tegra.c
index ea700395..862141e 100644
--- a/sound/pci/hda/hda_tegra.c
+++ b/sound/pci/hda/hda_tegra.c
@@ -68,6 +68,10 @@
  */
 #define TEGRA194_NUM_SDO_LINES	  4
 
+struct hda_data {
+	unsigned int do_reset:1;
+};
+
 struct hda_tegra {
 	struct azx chip;
 	struct device *dev;
@@ -76,6 +80,7 @@ struct hda_tegra {
 	unsigned int nclocks;
 	void __iomem *regs;
 	struct work_struct probe_work;
+	const struct hda_data *data;
 };
 
 #ifdef CONFIG_PM
@@ -427,8 +432,13 @@ static int hda_tegra_create(struct snd_card *card,
 	return 0;
 }
 
+static const struct hda_data tegra30_data = {
+	.do_reset = 1,
+};
+
 static const struct of_device_id hda_tegra_match[] = {
-	{ .compatible = "nvidia,tegra30-hda" },
+	{ .compatible = "nvidia,tegra30-hda", .data = &tegra30_data },
+	{ .compatible = "nvidia,tegra186-hda" },
 	{ .compatible = "nvidia,tegra194-hda" },
 	{},
 };
@@ -449,6 +459,8 @@ static int hda_tegra_probe(struct platform_device *pdev)
 	hda->dev = &pdev->dev;
 	chip = &hda->chip;
 
+	hda->data = of_device_get_match_data(&pdev->dev);
+
 	err = snd_card_new(&pdev->dev, SNDRV_DEFAULT_IDX1, SNDRV_DEFAULT_STR1,
 			   THIS_MODULE, 0, &card);
 	if (err < 0) {
@@ -456,10 +468,12 @@ static int hda_tegra_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	hda->reset = devm_reset_control_array_get_exclusive(&pdev->dev);
-	if (IS_ERR(hda->reset)) {
-		err = PTR_ERR(hda->reset);
-		goto out_free;
+	if (hda->data && hda->data->do_reset) {
+		hda->reset = devm_reset_control_array_get_exclusive(&pdev->dev);
+		if (IS_ERR(hda->reset)) {
+			err = PTR_ERR(hda->reset);
+			goto out_free;
+		}
 	}
 
 	hda->clocks[hda->nclocks++].id = "hda";
-- 
2.7.4

