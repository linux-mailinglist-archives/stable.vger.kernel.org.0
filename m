Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A46B23CC016
	for <lists+stable@lfdr.de>; Sat, 17 Jul 2021 02:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhGQAbk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 20:31:40 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:54218 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhGQAbk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Jul 2021 20:31:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1626481724; x=1658017724;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lYEdL49XjEL5ihB164MImXORbJhCpRLDMRW9PuPSa6U=;
  b=OzGuCj0QyBs1wz8sCrv9trY413CJDBRrGPdL9JJ8ETwRYdowo12Ni2gv
   JzDSYiXrbPedXSeCxjk+c96I6QxlFoOTEznTEGDDnJEnyvuP4Dy5mUj89
   fTTWMGAQENe5vBcIDPR1kR4o5w8s6FSzCB4exHQGfVlXBoO1unHj1Rij+
   a2tK9YewSAn+gigcWih97D+D+vDbd4uSZuvsKcGb0kQ8w9gt1p0qDcYY4
   nweraLst6MjZvhX4KADOfyKg6Bi+gtR9sUXgv+iuickLqGdsJIkRvsYMw
   LKrg1+f8GRVlnc/g/T5MiIDmxKnyqxJh7TmS5sWF19Oqkkk/wNoiJTuGa
   w==;
X-IronPort-AV: E=Sophos;i="5.84,246,1620662400"; 
   d="scan'208";a="179624443"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jul 2021 08:28:44 +0800
IronPort-SDR: QEnlACPDlwLBcJy1p9S6UWl2/GIYqjw+75zSCHZq5xdhT2KQttzxK8d9UbSTtx4Bfkftu0fEy8
 A5oqHa5SpeFGX1X4lJ1OCEa5XkH/soji4v7XcI/HUoCasXvJW/blQBqDrXDJ/fumn+uo59jiaC
 9DtdXlAZ8ISHpqUDsuBSh+SaPfr6I9eeJVY4OJ1JgDLM+NEvz7b31/8fXXNddOIUdadPt7oArK
 nwfpk6lSGgcBltAMhyQ1E8TYKA9pwAayBE3jROBfm+ARyIuGcYBKxPkGTLffL5ZT7JI8Wif6RP
 DAgFHP2M4eYbcvKkWVFgJdiH
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2021 17:05:11 -0700
IronPort-SDR: NXd+SPCz5Xj472jV2oQ8CCxw4frUo7PvKKMkUenPQjPenIkYkwBCg2Wt2v+OIoGxqyKUK8WVIE
 w90RIC/0K3xlZ2eQS25tLiZ6UG1WF0xsUeJVRvS6J6Ipk3f/Pg+044zomY+1PLzpmJR4rmFY0U
 QN6QEg/WGA5qiOR2rP9KHjBViB7LZxR0S6Iz8yaQ7H6C6O+4ALhK9rArGvQf94NCqsWV791DSN
 rr/vELiGBpMXprYGgfKAjOjDctYOSYMUnTC57IN+ePO90gZ/olrlEdCqZYiuwuoAJW+qK0Bhbx
 VSI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2021 17:28:44 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4GRTVh3SWCz1Rwt3
        for <stable@vger.kernel.org>; Fri, 16 Jul 2021 17:28:44 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1626481724;
         x=1629073725; bh=lYEdL49XjEL5ihB164MImXORbJhCpRLDMRW9PuPSa6U=; b=
        LbCE9wRsRbOGxwbtYGlD97Ob1YiMWdOOgddUmLEk4GhcsCcZZWJuJWqJv/ZW3+oP
        aqiKQ8i7h9BdU2SwsUZYgGk5INeTycx8PrNvWkN5eZTVc60ntW9Pr+sN1MhpvlpV
        5rQs+6Nj99HE4ezqIAaP5mnBScZqkLuoApe6j5bQ89+iKW24IuRgGcUSI4qFZVGL
        tJpG12lNk0mqgVe0b34TIgq6X1YoPBHa4nI+fX8oBSH7wpE+IpNBFXYAIKastCB5
        TG6aUm2ngKO8yaC9/2xVjg1bchFArcKGCdbDz0FKjqn0MNb2qdpvTqK0hAvPF8BK
        ggowpRngDL3IVl15C6dZTQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id OT3Z2T8H_cWR for <stable@vger.kernel.org>;
        Fri, 16 Jul 2021 17:28:44 -0700 (PDT)
Received: from twashi.fujisawa.hgst.com (unknown [10.225.163.49])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4GRTVg4yhLz1Rwry;
        Fri, 16 Jul 2021 17:28:43 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     stable@vger.kernel.org
Subject: [PATCH] clk: k210: Fix k210_clk_set_parent()
Date:   Sat, 17 Jul 2021 09:28:34 +0900
Message-Id: <20210717002834.7001-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

In k210_clk_set_parent(), add missing writel() call to update the mux
register of a clock to change its parent. This also fixes a compilation
warning with clang when compiling with W=3D1.

Fixes: c6ca7616f7d5 ("clk: Add RISC-V Canaan Kendryte K210 clock driver")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/clk/clk-k210.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/clk-k210.c b/drivers/clk/clk-k210.c
index 6c84abf5b2e3..67a7cb3503c3 100644
--- a/drivers/clk/clk-k210.c
+++ b/drivers/clk/clk-k210.c
@@ -722,6 +722,7 @@ static int k210_clk_set_parent(struct clk_hw *hw, u8 =
index)
 		reg |=3D BIT(cfg->mux_bit);
 	else
 		reg &=3D ~BIT(cfg->mux_bit);
+	writel(reg, ksc->regs + cfg->mux_reg);
 	spin_unlock_irqrestore(&ksc->clk_lock, flags);
=20
 	return 0;
--=20
2.31.1

