Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0AA23A5B75
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 04:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbhFNCFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 22:05:52 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:25925 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232287AbhFNCFv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 22:05:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1623636229; x=1655172229;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9iBFXDazEbc4Fz32FNWxfNTGqRKiyXnKG9jtdTIHOcQ=;
  b=P5JWk7TaSEHF7UMQ0QSaARwwVUBSL0WvbXwbNu3SlP57cnjNWiClplDr
   fn/AM6KYdLre8SWvFz8hysXjZsluDvZ8pRC/E1/lZbew75mnF/6XIn+Jd
   hJZ9Jz7dxanFRpH0cYqp3A62fLy5alDobQjERZupyfF+qM05gYRToLQnP
   SMUVEfFYYvchHD4d+WjW5XYNSO0cxNTyMIiLwPw0TFyExV4n3OPtitswN
   1085QtkwmQnV1lssHjt+oq9RRU3HgufXL0SIr1CS4mHowXwfVpbRq9rvo
   +h7EARXeq0mQKu/bIthAGDGoylmz2vf4Tb7VqCpdeeok4M0xL5KGzTjDL
   g==;
IronPort-SDR: Rebp3FzKQMTBBQ6mEyWb1e0i6UskqixnFFfWkhkRVjixus6Y3A9Lc7LKwSgQ/dsE3Jhil45YgV
 mTdaEU9qgJDJvN1S7KO3F+aNj1Ei5jtjE6oJrMTlP8YqIrPGJBoJf8ClXaYkFb8jAzgg48zbnb
 7VEbMPXesjS+zWA/E34Cy7AIkujLjVRTiwcGQ6dyXaElU3VwF0WozlyvSX2AL1UmQTtLcHX6I0
 uWOhaLXoa9feVfeoFV9WczvB/6WfPsPKfueYcm02C+99tWjXZMbSAdshkJau/BZyU12MmkouAN
 rMw=
X-IronPort-AV: E=Sophos;i="5.83,272,1616428800"; 
   d="scan'208";a="171046373"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Jun 2021 10:03:49 +0800
IronPort-SDR: 6kQwzTD6RrRajbShLbPWun6FRi9rryQI0bcXjedAc2IcbFjnWUP9BCeoQgcH24+5GbHHkJJA5e
 M8ZvAwDinN/ggLw/tKSXvfv+IcU6tmhkpYHwL4g0IyDzF/OSATuS2Kb5L05lu8FcO5+kYC0cP/
 EYL5kyTKyXKgxTGmjuDE5JjEg/XxuYuvB9KXhMJR4JmRfzv2KSaUVA1lw7G3+SzIiCMnv00wKh
 cPOPrM0RzEDYtJ+c8vHjPpBB+Tx2wM9+xRjhiJPM6FBhq83H5r9IXWV4Lx2cnFzoE71qhG/5Zg
 nnrtcnIiDNXR2vgTAFQ3j3hr
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2021 18:42:46 -0700
IronPort-SDR: v8VZfZkM2I8/6nkF4hXJ6XJq456S9+2zQiCp1xZzOcGyLLPS+kSIE8cQa2pq8+iwfFhV8xhomK
 zQAPXwQ0b0/Ip4oHFgdGprZUdS6ZdvYyRqS48TDxSFWNPwniECCHLonR0hi1HugrPAdrQ2tbA9
 PtV2is/+886YvXcXp/aaNVeoF4ynGf7h6BdYcb7Qwl3XJrQsZ0Rf+oQX2YHiSvUxxAi7t9j82C
 jl3GYqKDdFNXCvEzYxC9jIJ4TQ6YrOjYkwm23jBSvKWkfEacGHtaL21CgVeQ4O7p9QV+aso3N4
 vpE=
WDCIronportException: Internal
Received: from unknown (HELO twashi.fujisawa.hgst.com) ([10.225.163.118])
  by uls-op-cesaip02.wdc.com with ESMTP; 13 Jun 2021 19:03:49 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Stephen Boyd <sboyd@kernel.org>,
        linux-clock <linux-clk@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: [PATCH] clk: Fix k210_clk_set_parent() in k210 driver
Date:   Mon, 14 Jun 2021 11:02:17 +0900
Message-Id: <20210614020217.42323-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In k210_clk_set_parent(), add missing writel() call to update the mux
register of a clock to change its parent.

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
@@ -722,6 +722,7 @@ static int k210_clk_set_parent(struct clk_hw *hw, u8 index)
 		reg |= BIT(cfg->mux_bit);
 	else
 		reg &= ~BIT(cfg->mux_bit);
+	writel(reg, ksc->regs + cfg->mux_reg);
 	spin_unlock_irqrestore(&ksc->clk_lock, flags);
 
 	return 0;
-- 
2.31.1

