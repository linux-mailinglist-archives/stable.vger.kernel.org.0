Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0B864A01A
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbiLLNUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:20:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbiLLNUV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:20:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60EF8B2D
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:20:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E6B7B80D3B
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF7FC433EF;
        Mon, 12 Dec 2022 13:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851217;
        bh=NtopctSroauh9BDJpEYUPO3iv9nav1WHZ7BTSQs/ZZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xJxNaheKO8tpiTIc5P+J1+8iuB8+9nkEx0hHV7fpAxM1sZXrZFu4zfxSAJw6bJPbz
         NOsG1p2KYv+EtzpxOSfsFKamPlgKMMYgUBBFnG28MUliMo2bHKeP2/ynHdrOHERCEq
         jhdNHhuq0HGZnEdWZ9Qhf38e2LUNzAb6KdzISUz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, FUKAUMI Naoki <naoki@radxa.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 01/67] arm64: dts: rockchip: keep I2S1 disabled for GPIO function on ROCK Pi 4 series
Date:   Mon, 12 Dec 2022 14:16:36 +0100
Message-Id: <20221212130917.673553304@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130917.599345531@linuxfoundation.org>
References: <20221212130917.599345531@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: FUKAUMI Naoki <naoki@radxa.com>

[ Upstream commit 849c19d14940b87332d5d59c7fc581d73f2099fd ]

I2S1 pins are exposed on 40-pin header on Radxa ROCK Pi 4 series.
their default function is GPIO, so I2S1 need to be disabled.

Signed-off-by: FUKAUMI Naoki <naoki@radxa.com>
Link: https://lore.kernel.org/r/20220924112812.1219-1-naoki@radxa.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dts b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dts
index da3b031d4bef..79d04a664b82 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dts
@@ -441,7 +441,6 @@
 &i2s1 {
 	rockchip,playback-channels = <2>;
 	rockchip,capture-channels = <2>;
-	status = "okay";
 };
 
 &i2s2 {
-- 
2.35.1



