Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819E447B75A
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 03:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234024AbhLUB7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 20:59:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233695AbhLUB6x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 20:58:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4DCC061401;
        Mon, 20 Dec 2021 17:58:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A79666134A;
        Tue, 21 Dec 2021 01:58:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D218BC36AE9;
        Tue, 21 Dec 2021 01:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640051928;
        bh=7NSsBaHXQMFfVoY4cW3RE40VwQv5+FRGo36d2V2oPwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mKJMtDG614YL+Px8Qh6b4iqImdk4+CglMnHXnJBz004CP57uYnVcNJg3kMnJYt8Qn
         +FKUC9jq7ElIdfsmkvFdtjGmQDCUVxV03EisfSAbs1tKFCYZe+w12Mco421lTPVXTK
         sFECvFx+L9oT2W7/BxK1Q8KuQt/EA2JD4GK1mxyyp6zKQjgzHToVGuyJCMlEf2OGpV
         Dlxo95gD+iNatAyyjb6fo7ugHSGQxlH4LAM9TcSEeDFCI4QSeQS0ibPps6MhVrkARY
         lh5kTXpzDo2quj16/ldAlcS0BsE8i0rZGC8whlCx/MOGR8GqdzPzQav8+ey8FGHei9
         n57slcUqRGnjg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Pelletier <plr.vincent@gmail.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, qiuwenbo@kylinos.com.cn,
        yash.shah@sifive.com, devicetree@vger.kernel.org,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 24/29] riscv: dts: sifive unmatched: Name gpio lines
Date:   Mon, 20 Dec 2021 20:57:45 -0500
Message-Id: <20211221015751.116328-24-sashal@kernel.org>
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

[ Upstream commit ea81b91e4e256b0bb75d47ad3a5c230b2171a005 ]

Follow the pin descriptions given in the version 3 of the board schematics.

Signed-off-by: Vincent Pelletier <plr.vincent@gmail.com>
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts b/arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts
index 2e4ea84f27e77..a788b99638af8 100644
--- a/arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts
+++ b/arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts
@@ -250,4 +250,8 @@ &pwm1 {
 
 &gpio {
 	status = "okay";
+	gpio-line-names = "J29.1", "PMICNTB", "PMICSHDN", "J8.1", "J8.3",
+		"PCIe_PWREN", "THERM", "UBRDG_RSTN", "PCIe_PERSTN",
+		"ULPI_RSTN", "J8.2", "UHUB_RSTN", "GEMGXL_RST", "J8.4",
+		"EN_VDD_SD", "SD_CD";
 };
-- 
2.34.1

