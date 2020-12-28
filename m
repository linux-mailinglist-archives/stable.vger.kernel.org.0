Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF872E41EA
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438061AbgL1OGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:06:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:40644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438029AbgL1OGY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:06:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFB9A207A9;
        Mon, 28 Dec 2020 14:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164369;
        bh=7B47ai8sYwauPVyYhXwlNmoEeyJWD5rh9gC77CHmxmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iYmRoqlcCHDCOZAe7hRwLX3S5U49CfvAZBzh1mQiI2tWggYgRG4NKzpz9Xug/t8E6
         SAH9cZeIz3l6wPctQqJBZqxfeg+1WiazZHk0ekD2OCbNQWJwXDJFNmbJ8KeBGSoUan
         SgsamiW/sy2T035L6RlgqmLez7N6cfX/hM1j+JGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Jeffery <andrew@aj.id.au>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 157/717] ARM: dts: tacoma: Fix node vs reg mismatch for flash memory
Date:   Mon, 28 Dec 2020 13:42:35 +0100
Message-Id: <20201228125028.478760586@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Jeffery <andrew@aj.id.au>

[ Upstream commit cbee028da69d31cb927142e2828710de55a49f2a ]

The mismatch lead to a miscalculation of regions in another patch, and
shouldn't be mismatched anyway, so make them consistent.

Fixes: 575640201e66 ("ARM: dts: aspeed: tacoma: Use 64MB for firmware memory")
Signed-off-by: Andrew Jeffery <andrew@aj.id.au>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20201022014731.2035438-2-andrew@aj.id.au
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/aspeed-bmc-opp-tacoma.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/aspeed-bmc-opp-tacoma.dts b/arch/arm/boot/dts/aspeed-bmc-opp-tacoma.dts
index 4d070d6ba09f9..e86c22ce6d123 100644
--- a/arch/arm/boot/dts/aspeed-bmc-opp-tacoma.dts
+++ b/arch/arm/boot/dts/aspeed-bmc-opp-tacoma.dts
@@ -26,7 +26,7 @@
 		#size-cells = <1>;
 		ranges;
 
-		flash_memory: region@ba000000 {
+		flash_memory: region@b8000000 {
 			no-map;
 			reg = <0xb8000000 0x4000000>; /* 64M */
 		};
-- 
2.27.0



