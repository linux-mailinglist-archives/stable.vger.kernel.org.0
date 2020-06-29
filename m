Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5B420DBB8
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729284AbgF2UJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:09:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732930AbgF2TaX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F2CF251F3;
        Mon, 29 Jun 2020 15:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444912;
        bh=nQhk4ferhdpSiVYEziuRKJniwPCP21C39LLTWy0DsMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dWWNiIM/KB4Mm6FvomLCFaIEEy8RzcXrTf69YlUYddPsa8szMVhefGdFK+uxzvjLu
         3OodYE49KsS7enrvDcyqGELn93slGKQ/NlIw12CdlPyF+Beh1BKMv/gLy9h+/tPobk
         yfXR5LA60+OQSdGzVMzwag0U5FCK2xEYtGFYYIyM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 008/131] i2c: tegra: Cleanup kerneldoc comments
Date:   Mon, 29 Jun 2020 11:32:59 -0400
Message-Id: <20200629153502.2494656-9-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit c990bbafdb11c608bba2d529f72ded9bdff88678 ]

Some of the kerneldoc uses a strange spelling for abbreviations. Turn
them into all-uppercase and clean up some whitespace issues while at it.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-tegra.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 47d196c026ba6..9a6b9a1b88aef 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -145,8 +145,8 @@ enum msg_end_type {
  * @has_continue_xfer_support: Continue transfer supports.
  * @has_per_pkt_xfer_complete_irq: Has enable/disable capability for transfer
  *		complete interrupt per packet basis.
- * @has_single_clk_source: The i2c controller has single clock source. Tegra30
- *		and earlier Socs has two clock sources i.e. div-clk and
+ * @has_single_clk_source: The I2C controller has single clock source. Tegra30
+ *		and earlier SoCs have two clock sources i.e. div-clk and
  *		fast-clk.
  * @has_config_load_reg: Has the config load register to load the new
  *		configuration.
@@ -155,7 +155,6 @@ enum msg_end_type {
  *		applicable if there is no fast clock source i.e. single clock
  *		source.
  */
-
 struct tegra_i2c_hw_feature {
 	bool has_continue_xfer_support;
 	bool has_per_pkt_xfer_complete_irq;
@@ -170,22 +169,22 @@ struct tegra_i2c_hw_feature {
 };
 
 /**
- * struct tegra_i2c_dev	- per device i2c context
+ * struct tegra_i2c_dev - per device I2C context
  * @dev: device reference for power management
- * @hw: Tegra i2c hw feature.
- * @adapter: core i2c layer adapter information
- * @div_clk: clock reference for div clock of i2c controller.
- * @fast_clk: clock reference for fast clock of i2c controller.
+ * @hw: Tegra I2C HW feature
+ * @adapter: core I2C layer adapter information
+ * @div_clk: clock reference for div clock of I2C controller
+ * @fast_clk: clock reference for fast clock of I2C controller
  * @base: ioremapped registers cookie
- * @cont_id: i2c controller id, used for for packet header
- * @irq: irq number of transfer complete interrupt
- * @is_dvc: identifies the DVC i2c controller, has a different register layout
+ * @cont_id: I2C controller ID, used for packet header
+ * @irq: IRQ number of transfer complete interrupt
+ * @is_dvc: identifies the DVC I2C controller, has a different register layout
  * @msg_complete: transfer completion notifier
  * @msg_err: error code for completed message
  * @msg_buf: pointer to current message data
  * @msg_buf_remaining: size of unsent data in the message buffer
  * @msg_read: identifies read transfers
- * @bus_clk_rate: current i2c bus clock rate
+ * @bus_clk_rate: current I2C bus clock rate
  */
 struct tegra_i2c_dev {
 	struct device *dev;
-- 
2.25.1

