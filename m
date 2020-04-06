Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93E9C19FD84
	for <lists+stable@lfdr.de>; Mon,  6 Apr 2020 20:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgDFSvt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 14:51:49 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:55609 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725928AbgDFSvt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Apr 2020 14:51:49 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 8C43F850;
        Mon,  6 Apr 2020 14:51:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 06 Apr 2020 14:51:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=NjczVH
        OTxpvLo3J5DXedSC33Or8OKmOg81p116hyWI4=; b=zkkDexmbLka0Yy8hWPjYrJ
        32WeCAUXu3ES5vrTBsfPQlBicW0MJVAufDkmdVCuU7kMonSNqpz1aUgwzmCE5W5K
        PdZf9H2HHrGRwmo32Tt6m6G6/k1g52UKkhG8TxpyJ/NRSaoB4Lgi3m87If3v0QkC
        5Jo+EJzDd+wdsn6npmR8GFr7fhi3pjyBigdw21AyABh5EXBVQMl0ZgiK3u4eFHMV
        EZbtTLyqEB9OwEGVTZn31FjQ5OGsF604AqvFifoh+5kcG5aK4KO0p7mNB5sjFQE8
        OwvF1sV7uIs6Kib2PJpE7M3PCWpvybMb0O9M0fR3xu+uqpXzMdXKza8n78Y0ro9g
        ==
X-ME-Sender: <xms:RHqLXrAQsKeXHZAOzQVK502ephv3zuHErKmU8WDfxNfjUiWomAH1lg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudefgdduvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:RHqLXoOLtUY159n5XaQ5OqZ4sqWfz7lALMcbTGy-U0siZO3JMs1Igw>
    <xmx:RHqLXgznM-9N0F_4WXM0YzdQT3kqSU0DeHUBjW5z_uEgIuSq9yFaGg>
    <xmx:RHqLXuZFw_hXqbAQKY4_lPM4oPceq8Kq3UkojKOXpyvi6sRm-cT0WQ>
    <xmx:RHqLXk_3I8uVtcK7hyGVCD3KNc2v6PPqN8ExhmltSYHJ1t6xa_2WyQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id DC889306D3E3;
        Mon,  6 Apr 2020 14:51:47 -0400 (EDT)
Subject: FAILED: patch "[PATCH] misc: rtsx: set correct pcr_ops for rts522A" failed to apply to 4.9-stable tree
To:     yuehaibing@huawei.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Apr 2020 20:51:37 +0200
Message-ID: <158619909718026@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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
 

