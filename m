Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA4A0506D9
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbfFXJ54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 05:57:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728322AbfFXJ5z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 05:57:55 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A778208CA;
        Mon, 24 Jun 2019 09:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370274;
        bh=M2ODuiLtPrAiaUrOgynMafr0SgDtC+lDi9UWFMoPayI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h5kWNv0R3vr30c2hmw4YkCsNr7NxXStnip/oT8LO38Rn7LlFVPcp0j75mCiqPqNSo
         e3Y8jv4qpy5V/RRNj7/71FQKOALzUnhk6fcvke8cqOJf9XpfgXp3TrxMOABrfRSyKD
         /ciKfWLLx21GjHSdBp29aoB6y6Ua3fQ2H7uRH1no=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joao Pinto <jpinto@synopsys.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>,
        Alexey Brodkin <abrodkin@synopsys.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 13/51] ARC: [plat-hsdk]: Add missing multicast filter bins number to GMAC node
Date:   Mon, 24 Jun 2019 17:56:31 +0800
Message-Id: <20190624092307.932195316@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092305.919204959@linuxfoundation.org>
References: <20190624092305.919204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ecc906a11c2a0940e1a380debd8bd5bc09faf454 ]

GMAC controller on HSDK boards supports 256 Hash Table size so we need to
add the multicast filter bins property. This allows for the Hash filter
to work properly using stmmac driver.

Cc: Joao Pinto <jpinto@synopsys.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
Acked-by: Alexey Brodkin <abrodkin@synopsys.com>
Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/boot/dts/hsdk.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arc/boot/dts/hsdk.dts b/arch/arc/boot/dts/hsdk.dts
index 8f627c200d60..c033ae45fe42 100644
--- a/arch/arc/boot/dts/hsdk.dts
+++ b/arch/arc/boot/dts/hsdk.dts
@@ -163,6 +163,7 @@
 			interrupt-names = "macirq";
 			phy-mode = "rgmii";
 			snps,pbl = <32>;
+			snps,multicast-filter-bins = <256>;
 			clocks = <&gmacclk>;
 			clock-names = "stmmaceth";
 			phy-handle = <&phy0>;
-- 
2.20.1



