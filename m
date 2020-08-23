Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEFF24ED25
	for <lists+stable@lfdr.de>; Sun, 23 Aug 2020 14:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgHWMYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Aug 2020 08:24:01 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:55463 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727786AbgHWMYA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Aug 2020 08:24:00 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id A571B1940429;
        Sun, 23 Aug 2020 08:23:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 23 Aug 2020 08:23:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=7MADrH
        lpbG7kbNQfcvwcoswdKrFtjXjKld1ucquLU8s=; b=uPUWbDO9BHYlynACCBPleM
        EICXAIqqJE6+cW5kkT5uH5Mai7IdtQzT7tvjKpwUn7hdBbJwTCNCjACw5UXLyE0X
        d6ioaMcwjcE/3jdXdqnlQhxBnz+8VgBhzIniJ25GvIPMc7lXxF0CNHWfx6LbDV7V
        N3VxJ02ZcWZP5NwYXcVOhIGj3ne+46Rn19oXHfTgVcxH9sdZ//d6ahliwlXocL9U
        qG4Ww4d60UINqeBYn50jAiccpDEpibR6K9gfe8V6R/eIK9ghFNquRc6DKQljq4RM
        1YsrZJYdbLuwFfpcbuVua4WKSkIfAQA7urtv7cQG40l8adsDytEF7oYWKbyFqT9g
        ==
X-ME-Sender: <xms:319CX2TgskEkfZjIqk18SC3wKYS_2IgrGc_6eH82M_dGO9V26ykD4Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudduiedgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:319CX7x-6Yq2kLAu1tZDHObBVK5m3aOF6fj8jjPfbnKxVDtKW3e_cg>
    <xmx:319CXz02-MGq_KWfoPj-4pHU5s3C4yhG-paYrySz6ykKng15B044hA>
    <xmx:319CXyBSicIyFKfJuiR0R54PTNsCQdlM89b8FRQDN0IYawCLMa7DQg>
    <xmx:319CX_L9zAxafxCAm8D7Rj6uDZBwRJjgSH_YRRJ_CyuQrVevdnbfEw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 021B53280059;
        Sun, 23 Aug 2020 08:23:58 -0400 (EDT)
Subject: FAILED: patch "[PATCH] opp: Put opp table in dev_pm_opp_set_rate() for empty tables" failed to apply to 5.7-stable tree
To:     swboyd@chromium.org, rnayak@codeaurora.org, stable@vger.kernel.org,
        viresh.kumar@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Aug 2020 14:24:19 +0200
Message-ID: <15981854598296@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.7-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8979ef70850eb469e1094279259d1ef393ffe85f Mon Sep 17 00:00:00 2001
From: Stephen Boyd <swboyd@chromium.org>
Date: Tue, 11 Aug 2020 14:28:36 -0700
Subject: [PATCH] opp: Put opp table in dev_pm_opp_set_rate() for empty tables

We get the opp_table pointer at the top of the function and so we should
put the pointer at the end of the function like all other exit paths
from this function do.

Cc: v5.7+ <stable@vger.kernel.org> # v5.7+
Fixes: aca48b61f963 ("opp: Manage empty OPP tables with clk handle")
Reviewed-by: Rajendra Nayak <rnayak@codeaurora.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
[ Viresh: Split the patch into two ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index 9d7fb45b1786..f2f32786ee45 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -893,8 +893,10 @@ int dev_pm_opp_set_rate(struct device *dev, unsigned long target_freq)
 		 * have OPP table for the device, while others don't and
 		 * opp_set_rate() just needs to behave like clk_set_rate().
 		 */
-		if (!_get_opp_count(opp_table))
-			return 0;
+		if (!_get_opp_count(opp_table)) {
+			ret = 0;
+			goto put_opp_table;
+		}
 
 		if (!opp_table->required_opp_tables && !opp_table->regulators &&
 		    !opp_table->paths) {

