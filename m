Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9975547B767
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 03:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233695AbhLUB7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 20:59:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbhLUB7S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 20:59:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC24C061397;
        Mon, 20 Dec 2021 17:59:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DBB6B810D9;
        Tue, 21 Dec 2021 01:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC2EC36AEA;
        Tue, 21 Dec 2021 01:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640051952;
        bh=uYCQ1QCMzG/a71Xx9c4MuFbCz6l0SnV6hhcm1SSKeN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GA/xJuXBZFyNnZmMoyygYK/6glGy9xIzuNifWDz6na/sbs9fKhwpAF2y+QqCfI0vp
         vCKC+h3VjsURqVk1SqAoAWuGJ4kGd/7YYXIfm9ilCtVxCd9csc8M+BhIOzr+7CqqJP
         VFZH4PyUvyaWJVTmhHieVAkpmIlOybQnugAv094Q6dd1ro8Xw6URcUfcdoSaIGPNcg
         CPiaK//IPKtlg7hGy4AdXFeji50/V+F/uPLZnFXO8Ag8bTVBgBxj2UkxWpZZDVJnuy
         bKvMvIb3Wk5AMvmqHJT9crxtBLwUTECmOz/RqGxWX8/JYC+bagIMJZU36GG6Hk7iR0
         2BCGUn2ej7eKA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Pelletier <plr.vincent@gmail.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, qiuwenbo@kylinos.com.cn,
        yash.shah@sifive.com, devicetree@vger.kernel.org,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 28/29] riscv: dts: sifive unmatched: Link the tmp451 with its power supply
Date:   Mon, 20 Dec 2021 20:57:49 -0500
Message-Id: <20211221015751.116328-28-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221015751.116328-1-sashal@kernel.org>
References: <20211221015751.116328-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Pelletier <plr.vincent@gmail.com>

[ Upstream commit f6f7fbb89bf8dc9132fde55cfe67483138eea880 ]

Fixes the following probe warning:
  lm90 0-004c: Looking up vcc-supply from device tree
  lm90 0-004c: Looking up vcc-supply property in node /soc/i2c@10030000/temperature-sensor@4c failed
  lm90 0-004c: supply vcc not found, using dummy regulator

Signed-off-by: Vincent Pelletier <plr.vincent@gmail.com>
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts b/arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts
index 09d9342282339..0c4a508869059 100644
--- a/arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts
+++ b/arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts
@@ -59,6 +59,7 @@ &i2c0 {
 	temperature-sensor@4c {
 		compatible = "ti,tmp451";
 		reg = <0x4c>;
+		vcc-supply = <&vdd_bpro>;
 		interrupt-parent = <&gpio>;
 		interrupts = <6 IRQ_TYPE_LEVEL_LOW>;
 	};
-- 
2.34.1

