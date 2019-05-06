Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 020F214F00
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbfEFOhM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:37:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727340AbfEFOhK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:37:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C14B204EC;
        Mon,  6 May 2019 14:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153429;
        bh=cesPmuFn1E7+vUXpum+7UtF2uIjj3w2YGFlHKhA2WNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ah2TQDtZKKDGZjrVSfTKDhPmHtk+BxcI2OkzJMMHgKtNOisfPas2lWxTNSH9GcxUX
         jXrJnCopguXHkr6cfhCYJSOsn2nnaZPKeqs9CDO7d4K7xyCC1JL1a1lOqCbWo5iikD
         bK8iPx6R/G+gJTJ9K7YsiZqHanunvtzWZMduSfH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeffrey Hugo <jhugo@codeaurora.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.0 086/122] clk: qcom: Add missing freq for usb30_master_clk on 8998
Date:   Mon,  6 May 2019 16:32:24 +0200
Message-Id: <20190506143102.471371865@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
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
@@ -1112,6 +1112,7 @@ static struct clk_rcg2 ufs_axi_clk_src =
 
 static const struct freq_tbl ftbl_usb30_master_clk_src[] = {
 	F(19200000, P_XO, 1, 0, 0),
+	F(60000000, P_GPLL0_OUT_MAIN, 10, 0, 0),
 	F(120000000, P_GPLL0_OUT_MAIN, 5, 0, 0),
 	F(150000000, P_GPLL0_OUT_MAIN, 4, 0, 0),
 	{ }


