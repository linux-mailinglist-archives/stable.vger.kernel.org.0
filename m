Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B996932D66E
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 16:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbhCDPUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 10:20:52 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:37605 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234651AbhCDPUb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 10:20:31 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id 9FFE615AB;
        Thu,  4 Mar 2021 10:19:45 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 04 Mar 2021 10:19:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=EQcD51
        ME3nGgp7py7hsfJ4KsJyBAV5cnH2H8bUihPiI=; b=RgeCcnrX2jpKlzGMtFQpaN
        3i7kpCF8xIqfogSy+3vhRujyCWokf1ST9s2eQZoGCtcRloFg1JMbfJMJdGV8MFdz
        cAVfC1OVJhMLf4NQste+ved6nJ+pLZuF9aQzzRgldeZBzKdVogls7jPgbMr+Yu1/
        FxWuYfryU8TPOWKpv7BFl1t+47C4+GZueGKw2sFzLMchBV2PU1bpQDOEC0FZuVG8
        QGw+/ynBnL9B/3FWG5TH7E2pruUOYCVDMlOFMookuJYfS1Gn92EMk2DHVNJ3DLwO
        K5+JRORbFDgop4BCfbSINZe5fKYP14FQL6i/QFN41likaI4wKs/uE2eysmNCBuow
        ==
X-ME-Sender: <xms:kfpAYMcTMkoAbWVHjTEItmYmLyLufrt8YcWHneN73haoM09RyPU4DA>
    <xme:kfpAYFP2ucWhBZUVme3MwrftAnhfQ12pSW0D78LpUwp_8BjDG567LP4tFKNXzXwXD
    Tb5w3RVLKQwWQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddtgedgjeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:kfpAYCiB6r-tSaD2e-tHbIoSWGN33miAFu3KOtJVzzLcCGImUhUyqw>
    <xmx:kfpAYA384gC7EmZeoszDotHlltsj9f1zUQesmgmvkWrcureRVg941A>
    <xmx:kfpAYEg1Vp6lcewbv3PyYt1oVJvzlGO_MirtaKi99ly0jYvtjCv61A>
    <xmx:kfpAYLG-7a3pX8dni6fCqECV12bJULTG8_o38lIeCLfs4EMN35-7H9Z_tXY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id CC5A024005C;
        Thu,  4 Mar 2021 10:19:44 -0500 (EST)
Subject: FAILED: patch "[PATCH] soundwire: debugfs: use controller id instead of link_id" failed to apply to 5.4-stable tree
To:     srinivas.kandagatla@linaro.org, vkoul@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 04 Mar 2021 16:19:42 +0100
Message-ID: <16148711823250@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 6d5e7af1f6f5924de5dd1ebe97675c2363100878 Mon Sep 17 00:00:00 2001
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Date: Fri, 15 Jan 2021 16:25:59 +0000
Subject: [PATCH] soundwire: debugfs: use controller id instead of link_id

link_id can be zero and if we have multiple controller instances
in a system like Qualcomm debugfs will end-up with duplicate namespace
resulting in incorrect debugfs entries.

Using id should give a unique debugfs directory entry and should fix below
warning too.
"debugfs: Directory 'master-0' with parent 'soundwire' already present!"

Fixes: bf03473d5bcc ("soundwire: add debugfs support")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210115162559.20869-1-srinivas.kandagatla@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>

diff --git a/drivers/soundwire/debugfs.c b/drivers/soundwire/debugfs.c
index b6cad0d59b7b..5f9efa42bb25 100644
--- a/drivers/soundwire/debugfs.c
+++ b/drivers/soundwire/debugfs.c
@@ -19,7 +19,7 @@ void sdw_bus_debugfs_init(struct sdw_bus *bus)
 		return;
 
 	/* create the debugfs master-N */
-	snprintf(name, sizeof(name), "master-%d", bus->link_id);
+	snprintf(name, sizeof(name), "master-%d", bus->id);
 	bus->debugfs = debugfs_create_dir(name, sdw_debugfs_root);
 }
 

