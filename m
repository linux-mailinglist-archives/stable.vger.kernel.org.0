Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65D92ED414
	for <lists+stable@lfdr.de>; Sun,  3 Nov 2019 19:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbfKCSAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Nov 2019 13:00:44 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:56079 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726502AbfKCSAn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Nov 2019 13:00:43 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E064121B2A;
        Sun,  3 Nov 2019 13:00:42 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 03 Nov 2019 13:00:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=LGp/ke
        XIvp7+ko9uiVo7o0q4ns2HIWSg4tHOh35Lhko=; b=UPL+/W3kJhNRKIp36YLQMt
        j9IgHYVRGSniC+eMJ/aPhj9X8sQt0t9OWLAnNp85y925SZKh/poKIDj0L82nHvqr
        fd87bq+VTZnAeOA6t6IY7GziCt1u/3FJihVPTBrHjUxq3CSRrtat+49OgwgjOeHG
        Yyod13TozCHn01VW6PcIErTj5dupzgzV30TLn1wr/oZQjsjfHNix6cegtsO8hHHw
        G4Wdbwwu01B9pRHRUppl63hXbjktdsMR+q6G6OLz53dlhsvlOBM+rxcpkENO27Qt
        O+dNuwtyxX8S4ssXEgvz6l1bjMmS1AKJBMiy7Uw0hwrcsYfVedL3SEz+V/kv/jPg
        ==
X-ME-Sender: <xms:yhW_XS7uklnDFfIoU0ZpFR_JPzQFq9uX2NdBTDIa-slKnArK8vsZkA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudduuddguddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekle
    druddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
    necuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:yhW_XQeJ9rOar5uhwTvmqpMPBRmzE52TAY3YWy_i4E7y4kgUS10eDw>
    <xmx:yhW_XW4lOaNC30Kgmp504ZheRBc41caNomsQ_qF6eAs-54gWcwmFzQ>
    <xmx:yhW_XRwsTB_fl7hFnDXQ6VfYIg3UqtRs5aP_i0p3lZ7rwCE7_Z8opw>
    <xmx:yhW_XaIievIRyivMC26Obj15WUWPUNCsvY1wO-RIZUeTeK5LP6pTPw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7D19E306005C;
        Sun,  3 Nov 2019 13:00:42 -0500 (EST)
Subject: FAILED: patch "[PATCH] nl80211: fix validation of mesh path nexthop" failed to apply to 4.9-stable tree
To:     markus.theil@tu-ilmenau.de, johannes.berg@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 03 Nov 2019 19:00:33 +0100
Message-ID: <157280403313120@kroah.com>
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

From 1fab1b89e2e8f01204a9c05a39fd0b6411a48593 Mon Sep 17 00:00:00 2001
From: Markus Theil <markus.theil@tu-ilmenau.de>
Date: Tue, 29 Oct 2019 10:30:03 +0100
Subject: [PATCH] nl80211: fix validation of mesh path nexthop

Mesh path nexthop should be a ethernet address, but current validation
checks against 4 byte integers.

Cc: stable@vger.kernel.org
Fixes: 2ec600d672e74 ("nl80211/cfg80211: support for mesh, sta dumping")
Signed-off-by: Markus Theil <markus.theil@tu-ilmenau.de>
Link: https://lore.kernel.org/r/20191029093003.10355-1-markus.theil@tu-ilmenau.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4453dd375de9..7b72286922f7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -393,7 +393,7 @@ const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_MNTR_FLAGS] = { /* NLA_NESTED can't be empty */ },
 	[NL80211_ATTR_MESH_ID] = { .type = NLA_BINARY,
 				   .len = IEEE80211_MAX_MESH_ID_LEN },
-	[NL80211_ATTR_MPATH_NEXT_HOP] = { .type = NLA_U32 },
+	[NL80211_ATTR_MPATH_NEXT_HOP] = NLA_POLICY_ETH_ADDR_COMPAT,
 
 	[NL80211_ATTR_REG_ALPHA2] = { .type = NLA_STRING, .len = 2 },
 	[NL80211_ATTR_REG_RULES] = { .type = NLA_NESTED },

