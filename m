Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7E4632412
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 14:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbiKUNmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 08:42:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbiKUNmE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 08:42:04 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45119596;
        Mon, 21 Nov 2022 05:41:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669038118; x=1700574118;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WA/TZriNXCVpyXKJ9P6CH+4zm9j1q1ICmB+nOCyp11w=;
  b=rIhZnCp7zFct6ViFtZ1W+3LErVvPrItvU+580dzwgb8EHRY/N4HCk8PC
   zv41kd70ghUVihr8wmv/a3o28ddOX/EqilsjfCK+LyRoyfMIOAmC1BB3c
   EwH8/PYGdB9rKcet9d3CfhxjjfVV+SIpO7Kcql2zH8A0/NJm1Ja4BGAI0
   k3oHU8o12ji0RbJQ89ZeeR9rj2rFzuCPWKD45edUZM7kq1MkmQI+mStzJ
   XigouOauIWsS21MDRN5DJbK+ucOJqcEX2wkQPO7KW501zhKURHylWosf8
   WLWpdY1gRQ0yDicmymmusnxfwbII4iJxdxghxZDF0liD1o1q3wdWL8DNU
   A==;
X-IronPort-AV: E=Sophos;i="5.96,181,1665471600"; 
   d="scan'208";a="184483608"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Nov 2022 06:41:58 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 21 Nov 2022 06:41:52 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 21 Nov 2022 06:41:50 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <alexander.sverdlin@nokia.com>, <linux-mtd@lists.infradead.org>
CC:     Tudor Ambarus <tudor.ambarus@microchip.com>, <richard@nod.at>,
        <miquel.raynal@bootlin.com>, <linux-kernel@vger.kernel.org>,
        <michael@walle.cc>, <stable@vger.kernel.org>, <p.yadav@ti.com>,
        <vigneshr@ti.com>
Subject: Re: [PATCH v2] mtd: spi-nor: Check for zero erase size in spi_nor_find_best_erase_type()
Date:   Mon, 21 Nov 2022 15:41:47 +0200
Message-ID: <166903807811.85501.2255834791206092904.b4-ty@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211119081412.29732-1-alexander.sverdlin@nokia.com>
References: <20211119081412.29732-1-alexander.sverdlin@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,T_SPF_TEMPERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 19 Nov 2021 09:14:12 +0100, Alexander A Sverdlin wrote:
> From: Alexander Sverdlin <alexander.sverdlin@nokia.com>
> 
> Erase can be zeroed in spi_nor_parse_4bait() or
> spi_nor_init_non_uniform_erase_map(). In practice it happened with
> mt25qu256a, which supports 4K, 32K, 64K erases with 3b address commands,
> but only 4K and 64K erase with 4b address commands.
> 
> [...]

Applied to spi-nor/next, thanks!

[1/1] mtd: spi-nor: Check for zero erase size in spi_nor_find_best_erase_type()
      https://git.kernel.org/mtd/c/2ebc336be081

Best regards,
-- 
Tudor Ambarus <tudor.ambarus@microchip.com>
