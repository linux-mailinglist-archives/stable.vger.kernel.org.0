Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 237F119FD82
	for <lists+stable@lfdr.de>; Mon,  6 Apr 2020 20:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgDFSvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 14:51:40 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:56621 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725928AbgDFSvk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Apr 2020 14:51:40 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 899F787E;
        Mon,  6 Apr 2020 14:51:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 06 Apr 2020 14:51:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=C6VuFn
        aAf+hqZAeLDflB/0q0tfZJwDL9m+1rbatOHno=; b=nz8gio2eszp95tNhWGjjgf
        zJu+0Lro80zCXZiS78wH5wq5+bEVIPqUmWr7/lzqAYgx9Mgro7tcyGLVRYCyuQzI
        s1PY+xSEa270gTI0bYNLs/IbRHQnFr7+GlmLXUvypnocS7EM2jAZ6vP/cbbYsDPx
        /6iPDMp0wNbNzrt3uPy7joaGzrZAhQiMJk/RBNRsNugDEJh0ewjr9W4AYs5TKPe7
        H3xA59F7tCLsGa4K00IxWM2LUGm/kWa7XCzdzPhMCELKJQ9mf/Mvg7d1A/cXbVbg
        BJGzq/OJPK6jb3BwYWyN3FVoPH/OM8l/tqXsitfCrcXs88ZNYnArSOBI1b4M1H/Q
        ==
X-ME-Sender: <xms:OnqLXm832xBjyadBvLTACGQP_tOZxsklSI7KvCItRvWs4MQvPKTgPQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudefgdduvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:OnqLXl5vQ03KX4CtWRdbxnAA55QYIa0GgpgfhoEPQBoldcDNZvbfkA>
    <xmx:OnqLXutJnme7EaagY4gRgHTsUkCSEswHJ9W0FJBKDQXPrx7Mn0OZfg>
    <xmx:OnqLXn3Uwws9uNQEjopb0mA1bfhCZ0A1P-qSL7l8ePvetgxkkowO0Q>
    <xmx:O3qLXqjMoBbSVcFaeZMGV_gFNvop_5XHQvVarrhHLIXvrdCyw41_9w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 792403280060;
        Mon,  6 Apr 2020 14:51:38 -0400 (EDT)
Subject: FAILED: patch "[PATCH] misc: rtsx: set correct pcr_ops for rts522A" failed to apply to 4.4-stable tree
To:     yuehaibing@huawei.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Apr 2020 20:51:36 +0200
Message-ID: <1586199096226162@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 10cea23b6aae15e8324f4101d785687f2c514fe5 Mon Sep 17 00:00:00 2001
From: YueHaibing <yuehaibing@huawei.com>
Date: Thu, 26 Mar 2020 11:26:18 +0800
Subject: [PATCH] misc: rtsx: set correct pcr_ops for rts522A

rts522a should use rts522a_pcr_ops, which is
diffrent with rts5227 in phy/hw init setting.

Fixes: ce6a5acc9387 ("mfd: rtsx: Add support for rts522A")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200326032618.20472-1-yuehaibing@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/misc/cardreader/rts5227.c b/drivers/misc/cardreader/rts5227.c
index 423fecc19fc4..3a9467aaa435 100644
--- a/drivers/misc/cardreader/rts5227.c
+++ b/drivers/misc/cardreader/rts5227.c
@@ -394,6 +394,7 @@ static const struct pcr_ops rts522a_pcr_ops = {
 void rts522a_init_params(struct rtsx_pcr *pcr)
 {
 	rts5227_init_params(pcr);
+	pcr->ops = &rts522a_pcr_ops;
 	pcr->tx_initial_phase = SET_CLOCK_PHASE(20, 20, 11);
 	pcr->reg_pm_ctrl3 = RTS522A_PM_CTRL3;
 

