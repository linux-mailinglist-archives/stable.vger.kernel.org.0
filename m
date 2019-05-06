Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 602E014E5E
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbfEFOmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:42:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726959AbfEFOmE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:42:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 970B221479;
        Mon,  6 May 2019 14:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153724;
        bh=385CK5g0kpK3lqPM3QqwDpj3sUCE0y8wLuVdT640+NY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FdjBNjfmVbrEl1QKBRQs5k0uBD5y63PfTzjTj+k9zuub/hIUpUZjD1iGK5e8YGJzR
         vGrBjThXoNBkZXEn8kNU1uEluBbEd20nI21Si2TXSBYDeXm/XB8qaAGykyfUNlyavU
         2F9vF5umbKvEFwbSx3Ea33msRnXHWGRdE8GQp+gk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeffrey Hugo <jhugo@codeaurora.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 4.19 73/99] clk: qcom: Add missing freq for usb30_master_clk on 8998
Date:   Mon,  6 May 2019 16:32:46 +0200
Message-Id: <20190506143100.745505322@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.899356316@linuxfoundation.org>
References: <20190506143053.899356316@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffrey Hugo <jhugo@codeaurora.org>

commit 0c8ff62504e3a667387e87889a259632c3199a86 upstream.

The usb30_master_clk supports a 60Mhz frequency, but that is missing from
the table of supported frequencies.  Add it.

Fixes: b5f5f525c547 (clk: qcom: Add MSM8998 Global Clock Control (GCC) driver)
Signed-off-by: Jeffrey Hugo <jhugo@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/qcom/gcc-msm8998.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/clk/qcom/gcc-msm8998.c
+++ b/drivers/clk/qcom/gcc-msm8998.c
@@ -1101,6 +1101,7 @@ static struct clk_rcg2 ufs_axi_clk_src =
 
 static const struct freq_tbl ftbl_usb30_master_clk_src[] = {
 	F(19200000, P_XO, 1, 0, 0),
+	F(60000000, P_GPLL0_OUT_MAIN, 10, 0, 0),
 	F(120000000, P_GPLL0_OUT_MAIN, 5, 0, 0),
 	F(150000000, P_GPLL0_OUT_MAIN, 4, 0, 0),
 	{ }


