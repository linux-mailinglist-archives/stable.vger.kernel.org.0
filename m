Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9943783A2
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhEJKqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:46:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232829AbhEJKok (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:44:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 436376198E;
        Mon, 10 May 2021 10:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642828;
        bh=YlyS1KYWYHDC9aAc6DmEhWZcPrNEX/qKz9BiKHXLyOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EgsS0ZoX5iv7B93sLCCNpoZPTJzv0sZ7DsAcHIClKiyoQqDWc3O/pMi2mOvThix/u
         kZGwjwrNDpCXaxV2rf/Qq6ncCzuAWIcgnQbsGJyBAKzChcUPbgfkXZi/gQgYqf/hFZ
         7ZcmiisdVa4hksjdgiT9dPWYjpN+1g+P/kHdiVaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/299] ARM: tegra: acer-a500: Rename avdd to vdda of touchscreen node
Date:   Mon, 10 May 2021 12:17:45 +0200
Message-Id: <20210510102007.155851472@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit b27b9689e1f3278919c6183c565d837d0aef6fc1 ]

Rename avdd supply to vdda of the touchscreen node. The old supply name
was incorrect.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/tegra20-acer-a500-picasso.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra20-acer-a500-picasso.dts b/arch/arm/boot/dts/tegra20-acer-a500-picasso.dts
index a0b829738e8f..068aabcffb13 100644
--- a/arch/arm/boot/dts/tegra20-acer-a500-picasso.dts
+++ b/arch/arm/boot/dts/tegra20-acer-a500-picasso.dts
@@ -448,7 +448,7 @@
 
 			reset-gpios = <&gpio TEGRA_GPIO(Q, 7) GPIO_ACTIVE_HIGH>;
 
-			avdd-supply = <&vdd_3v3_sys>;
+			vdda-supply = <&vdd_3v3_sys>;
 			vdd-supply  = <&vdd_3v3_sys>;
 		};
 
-- 
2.30.2



