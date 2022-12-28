Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D019A65796C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233448AbiL1PBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233398AbiL1PAw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:00:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE38286
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:00:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D1E7B81719
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE673C433EF;
        Wed, 28 Dec 2022 15:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239640;
        bh=5+NbVSRPuQBuAknbwIoK0y8/8BUfbHuJf89N4DK1f2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PWPNALtTTQWp5f1jEcvVlHeRlbhyuV77QaKJspP7EE1yaAe79jg8bjiZNG3oFB+SZ
         LVQlwDq7P8A50uGYAOaoLNa3BU23gbe/gLz26KW9/OM2v7nOYFqtM8Ww3+PwENSsZ+
         qD7sbn54KsrzSr2kshuDTORes3AeSPfjdkcXNhE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Conor Dooley <conor.dooley@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0022/1146] riscv: dts: microchip: fix memory node unit address for icicle
Date:   Wed, 28 Dec 2022 15:26:01 +0100
Message-Id: <20221228144330.775849321@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit d6105a8b7c160a73ae04054c8921eba80a294146 ]

Evidently I forgot to update the unit address for the 38-bit cached
memory node when I changed the address in the reg property..
Update it to match.

Fixes: 6c1193301791 ("riscv: dts: microchip: update memory configuration for v2022.10")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/microchip/mpfs-icicle-kit.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/boot/dts/microchip/mpfs-icicle-kit.dts b/arch/riscv/boot/dts/microchip/mpfs-icicle-kit.dts
index ec7b7c2a3ce2..8ced67c3b00b 100644
--- a/arch/riscv/boot/dts/microchip/mpfs-icicle-kit.dts
+++ b/arch/riscv/boot/dts/microchip/mpfs-icicle-kit.dts
@@ -37,7 +37,7 @@ ddrc_cache_lo: memory@80000000 {
 		status = "okay";
 	};
 
-	ddrc_cache_hi: memory@1000000000 {
+	ddrc_cache_hi: memory@1040000000 {
 		device_type = "memory";
 		reg = <0x10 0x40000000 0x0 0x40000000>;
 		status = "okay";
-- 
2.35.1



