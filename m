Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 107C912C8CB
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733276AbfL2R5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:57:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:48384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733294AbfL2R5j (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:57:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81ACA208C4;
        Sun, 29 Dec 2019 17:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642259;
        bh=wBQWZYysjEodPuM7MCs9NoMm8rrwflDKThU5IRqDYts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SqRyNbwRo5s9zaW6a+iApWzeUWz/2J1OQhfIBNFJdFi5lNLHI49wiLW/6fJUQWY4e
         VwjzkgyQrdS7LvKl90cP7CCNDmvYNBqmMBSx34F97YINhBScThXeBNMq8mR3usbQE7
         yhw+FO4cD2YCERjcs5f5uiFq3JKQCvZRznV6IsB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.4 407/434] clk: imx: clk-imx7ulp: Add missing sentinel of ulp_div_table
Date:   Sun, 29 Dec 2019 18:27:40 +0100
Message-Id: <20191229172729.701544977@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

commit ed11e31709d7ddb19d4dc451d5bbfb15129f4cad upstream.

There should be a sentinel of ulp_div_table, otherwise _get_table_div
may access data out of the array.

Fixes: b1260067ac3d ("clk: imx: add imx7ulp clk driver")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/imx/clk-imx7ulp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/clk/imx/clk-imx7ulp.c
+++ b/drivers/clk/imx/clk-imx7ulp.c
@@ -40,6 +40,7 @@ static const struct clk_div_table ulp_di
 	{ .val = 5, .div = 16, },
 	{ .val = 6, .div = 32, },
 	{ .val = 7, .div = 64, },
+	{ /* sentinel */ },
 };
 
 static const int pcc2_uart_clk_ids[] __initconst = {


