Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 506A61BA5A6
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 16:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgD0ODT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 10:03:19 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:40777 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726879AbgD0ODT (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 27 Apr 2020 10:03:19 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 0BE34194018D;
        Mon, 27 Apr 2020 10:03:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 27 Apr 2020 10:03:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=uaSQya
        Jyz41zuyqOs8UfEi1NyWhyEJLWZkreh96pfzc=; b=lv38GZ8r1MceMFcZZUegNq
        g7GR1R9AuiO6rRPdq/7dELcKJpeJa0AKQfTUd2CyHsk6QV0RR8suk6u4a1gFQ/H1
        aRtG1a2+crEC518H2fbHIjPQBuESeZlzmimGJKYdflvJJgQikhv+cvmcFa05qywQ
        B8zhJYGuzhFjV3AnEr1R3Ex1cYtGvEeIAjzzmYzWhZWJv/x5vBKDRcR4uI6Fv2SU
        ODocszs3ad4JSzHss2XYSJn0aCDUdUj5RetTWLbKnNL7CrtKKJgxYTB1WyDv0fEp
        1/Q8wXF4Bxo2mjJmHM2V0l88zVAwACVgzdtJU/yNUaXjzumAgoc6AJs+Ami9k0hw
        ==
X-ME-Sender: <xms:JOamXh3nysQfPXXsa4DKQWT1yeAYluF6Pn0uXrbL0ZZR0Fq4SA3i3Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheelgdejtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:JOamXi55PVe8rwy7sNoOJ9AtQf0PZd12TbsBvxVBpQKGq-zdovD6Ng>
    <xmx:JOamXtrUK7qtiWAYXLmbFQ1Ayw_iL0TyUy6xwcQk9vTikVpRb6oEkA>
    <xmx:JOamXl90ddxr0fn5zVZB0BgHo3duVaVbJ1kpBR1sUWEpB17e8EcSWg>
    <xmx:JuamXskq-gV6SmLAD0d8DpNOw4czBgFjPgu1QclZylQxICTjIcl72w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9145E3065D7D;
        Mon, 27 Apr 2020 10:03:16 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iio: imu: st_lsm6dsx: flush hw FIFO before resetting the" failed to apply to 5.4-stable tree
To:     lorenzo@kernel.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, mario.tesi@st.com,
        vitor.soares@synopsys.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Apr 2020 16:03:13 +0200
Message-ID: <1587996193185120@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3a63da26db0a864134f023f088d41deacd509997 Mon Sep 17 00:00:00 2001
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Fri, 13 Mar 2020 19:06:00 +0100
Subject: [PATCH] iio: imu: st_lsm6dsx: flush hw FIFO before resetting the
 device

flush hw FIFO before device reset in order to avoid possible races
on interrupt line 1. If the first interrupt line is asserted during
hw reset the device will work in I3C-only mode (if it is supported)

Fixes: 801a6e0af0c6 ("iio: imu: st_lsm6dsx: add support to LSM6DSO")
Fixes: 43901008fde0 ("iio: imu: st_lsm6dsx: add support to LSM6DSR")
Reported-by: Mario Tesi <mario.tesi@st.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Reviewed-by: Vitor Soares <vitor.soares@synopsys.com>
Tested-by: Vitor Soares <vitor.soares@synopsys.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
index 84d219ae6aee..4426524b59f2 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -2036,11 +2036,21 @@ static int st_lsm6dsx_init_hw_timer(struct st_lsm6dsx_hw *hw)
 	return 0;
 }
 
-static int st_lsm6dsx_init_device(struct st_lsm6dsx_hw *hw)
+static int st_lsm6dsx_reset_device(struct st_lsm6dsx_hw *hw)
 {
 	const struct st_lsm6dsx_reg *reg;
 	int err;
 
+	/*
+	 * flush hw FIFO before device reset in order to avoid
+	 * possible races on interrupt line 1. If the first interrupt
+	 * line is asserted during hw reset the device will work in
+	 * I3C-only mode (if it is supported)
+	 */
+	err = st_lsm6dsx_flush_fifo(hw);
+	if (err < 0 && err != -ENOTSUPP)
+		return err;
+
 	/* device sw reset */
 	reg = &hw->settings->reset;
 	err = regmap_update_bits(hw->regmap, reg->addr, reg->mask,
@@ -2059,6 +2069,18 @@ static int st_lsm6dsx_init_device(struct st_lsm6dsx_hw *hw)
 
 	msleep(50);
 
+	return 0;
+}
+
+static int st_lsm6dsx_init_device(struct st_lsm6dsx_hw *hw)
+{
+	const struct st_lsm6dsx_reg *reg;
+	int err;
+
+	err = st_lsm6dsx_reset_device(hw);
+	if (err < 0)
+		return err;
+
 	/* enable Block Data Update */
 	reg = &hw->settings->bdu;
 	err = regmap_update_bits(hw->regmap, reg->addr, reg->mask,

