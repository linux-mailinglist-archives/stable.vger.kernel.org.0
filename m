Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFD74998FD
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453894AbiAXVbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:31:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450843AbiAXVVf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:21:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A910C0604D7;
        Mon, 24 Jan 2022 12:15:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5905B81229;
        Mon, 24 Jan 2022 20:15:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6B9C340E5;
        Mon, 24 Jan 2022 20:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055340;
        bh=8rZU2mkEPnLSkCNjqQB28l5RSQofZ+GqJfjHJOjlecg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mdjnzj7UnUvHGtreTKFwsvS4MUJCpSMqUgL7sHtazuPLH3o4XJ4hxTR6wWmvI+y0P
         JszxB9cA5V63GpQbObk2Hde/yP9gE5x51Z+8uabG/rCfw8acnnK6RNJCtl8GdKFQQ3
         x4xSZLUcIORYl6dv7io6lBHc6PbN3GZnSmJaOMDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <narmstrong@baylibre.com>,
        Alexander Stein <alexander.stein@mailbox.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 120/846] arm64: dts: amlogic: meson-g12: Fix GPU operating point table node name
Date:   Mon, 24 Jan 2022 19:33:57 +0100
Message-Id: <20220124184105.113776975@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@mailbox.org>

[ Upstream commit bb98a6fd0b0e227cefb2ba91cea2b55455f203b7 ]

Starting with commit 94274f20f6bf ("dt-bindings: opp: Convert to DT
schema") the opp node name has a mandatory pattern. This change
fixes the dtbs_check warning:
gpu-opp-table: $nodename:0: 'gpu-opp-table' does not match
'^opp-table(-[a-z0-9]+)?$'
Put the 'gpu' part at the end to match the pattern.

Fixes: 916a0edc43f0 ("arm64: dts: amlogic: meson-g12: add the Mali OPP table and use DVFS")
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Alexander Stein <alexander.stein@mailbox.org>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/20211026182813.900775-2-alexander.stein@mailbox.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index 00c6f53290d43..428449d98c0ae 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -58,7 +58,7 @@
 		secure-monitor = <&sm>;
 	};
 
-	gpu_opp_table: gpu-opp-table {
+	gpu_opp_table: opp-table-gpu {
 		compatible = "operating-points-v2";
 
 		opp-124999998 {
-- 
2.34.1



