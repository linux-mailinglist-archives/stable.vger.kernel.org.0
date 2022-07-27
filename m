Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7295830DA
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242898AbiG0RnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242786AbiG0Rmp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:42:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B74089A99;
        Wed, 27 Jul 2022 09:52:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08B6EB821D5;
        Wed, 27 Jul 2022 16:52:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BBCDC433C1;
        Wed, 27 Jul 2022 16:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940725;
        bh=S8MbOHpDXGviGRD/I1+/w6TY0TLAHiwFdOgvISSGvt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OK2qT3q3LnEzligtTI7AKM8MVYofjTVAunNOgKAibBB3bydtnvxapwL6+GY0FOLbJ
         IUl5uIgFt910l+DHe2BNciYlEapAmmkiiWQEYXJTdBVbR9lKa8DV72R/O1dop8qzG8
         K9qNA8L6MbcPF0yMuYj7JTKSROVza6TrVYBhCq5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 099/158] net: dsa: sja1105: silent spi_device_id warnings
Date:   Wed, 27 Jul 2022 18:12:43 +0200
Message-Id: <20220727161025.419040793@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 855fe49984a8a3899f07ae1d149d46cd8d4acb52 ]

Add spi_device_id entries to silent following warnings:
 SPI driver sja1105 has no spi_device_id for nxp,sja1105e
 SPI driver sja1105 has no spi_device_id for nxp,sja1105t
 SPI driver sja1105 has no spi_device_id for nxp,sja1105p
 SPI driver sja1105 has no spi_device_id for nxp,sja1105q
 SPI driver sja1105 has no spi_device_id for nxp,sja1105r
 SPI driver sja1105 has no spi_device_id for nxp,sja1105s
 SPI driver sja1105 has no spi_device_id for nxp,sja1110a
 SPI driver sja1105 has no spi_device_id for nxp,sja1110b
 SPI driver sja1105 has no spi_device_id for nxp,sja1110c
 SPI driver sja1105 has no spi_device_id for nxp,sja1110d

Fixes: 5fa6863ba692 ("spi: Check we have a spi_device_id for each DT compatible")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220717135831.2492844-1-o.rempel@pengutronix.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index b33841c6507a..7734c6b1baca 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -3383,12 +3383,28 @@ static const struct of_device_id sja1105_dt_ids[] = {
 };
 MODULE_DEVICE_TABLE(of, sja1105_dt_ids);
 
+static const struct spi_device_id sja1105_spi_ids[] = {
+	{ "sja1105e" },
+	{ "sja1105t" },
+	{ "sja1105p" },
+	{ "sja1105q" },
+	{ "sja1105r" },
+	{ "sja1105s" },
+	{ "sja1110a" },
+	{ "sja1110b" },
+	{ "sja1110c" },
+	{ "sja1110d" },
+	{ },
+};
+MODULE_DEVICE_TABLE(spi, sja1105_spi_ids);
+
 static struct spi_driver sja1105_driver = {
 	.driver = {
 		.name  = "sja1105",
 		.owner = THIS_MODULE,
 		.of_match_table = of_match_ptr(sja1105_dt_ids),
 	},
+	.id_table = sja1105_spi_ids,
 	.probe  = sja1105_probe,
 	.remove = sja1105_remove,
 	.shutdown = sja1105_shutdown,
-- 
2.35.1



