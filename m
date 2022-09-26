Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC325EA2DB
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237590AbiIZLPd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237804AbiIZLOM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:14:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2014B647C9;
        Mon, 26 Sep 2022 03:36:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9E5360CFB;
        Mon, 26 Sep 2022 10:36:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F86C433C1;
        Mon, 26 Sep 2022 10:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188599;
        bh=Bd4NT7bbB8cLbIQEupGQ5VfJHKOTc2fkz7gqkI6Rt4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mJZU4A4eMPMAPmF2ZM7GB6rGiJfVFdGiLxleZgqqjDbSpq+HVri+2kxcUjugyg21P
         6Eh3giNcbme0B+0IuTTyhE7prBpvtPtk8i4O6eezr81YRrZYJcRc3ntqw22exSY9Ck
         /JEulO+WMCIpb8YjUuUQ+rz4VD/+t/NoMADxrfxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jagan Teki <jagan@amarulasolutions.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/148] arm64: dts: rockchip: Fix typo in lisense text for PX30.Core
Date:   Mon, 26 Sep 2022 12:11:35 +0200
Message-Id: <20220926100758.327775420@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jagan Teki <jagan@amarulasolutions.com>

[ Upstream commit 4a00c43818dcc19be97250d4c3c4a1e2f1ed4f9d ]

Fix the Amarula Solutions typo mistake in lisense text added
in Engicam PX30.Core SoM dtsi.

Fixes: d92a7c331f53c ("arm64: dts: rockchip: Add Engicam PX30.Core SOM")
Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
Link: https://lore.kernel.org/r/20220822103524.266731-1-jagan@amarulasolutions.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/px30-engicam-px30-core.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/px30-engicam-px30-core.dtsi b/arch/arm64/boot/dts/rockchip/px30-engicam-px30-core.dtsi
index 7249871530ab..5eecbefa8a33 100644
--- a/arch/arm64/boot/dts/rockchip/px30-engicam-px30-core.dtsi
+++ b/arch/arm64/boot/dts/rockchip/px30-engicam-px30-core.dtsi
@@ -2,8 +2,8 @@
 /*
  * Copyright (c) 2020 Fuzhou Rockchip Electronics Co., Ltd
  * Copyright (c) 2020 Engicam srl
- * Copyright (c) 2020 Amarula Solutons
- * Copyright (c) 2020 Amarula Solutons(India)
+ * Copyright (c) 2020 Amarula Solutions
+ * Copyright (c) 2020 Amarula Solutions(India)
  */
 
 #include <dt-bindings/gpio/gpio.h>
-- 
2.35.1



