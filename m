Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9651C309D26
	for <lists+stable@lfdr.de>; Sun, 31 Jan 2021 15:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbhAaOq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jan 2021 09:46:26 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:60775 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231390AbhAaOoV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jan 2021 09:44:21 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 1151E12D2;
        Sun, 31 Jan 2021 09:43:31 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 31 Jan 2021 09:43:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=gBxB/H
        kbWDaTLM18q3T0KZw7nPW2qg7LAhiwXM3PXZw=; b=aqyyUHisGhmyj6Ty+USTwc
        KCCEfHzTVjImkDnbMUiek2EiuL3qLdxn9QHOm4xMYw04ASQM0tofpp/cIrI1y7PB
        RqBrpXXw+Ql2NaPbI7qliaPHBP6sDEenuM83kyFMLjsiOoGAO9/xuOW3GKDlAWfG
        odRHEVL9VTftWvnDlpwv0wUUHWmgaIqQz6hFWtGBb13Z/m7RHHjf3UZqbUEN5DAi
        ykr7BUUv+LRnbanXSMdi3dnKpoqgO5qa94oXBokPg+Kf8/xi8ntEL1x7/3JCjP31
        ibP9++fnwHBaj/NCTyDv1crQ54rEViJZOfR99vphyfA9S4L7Pa461eQ5jFbvXk3Q
        ==
X-ME-Sender: <xms:EsIWYJtGsQ-vGAFcOZPpi8xV1msgGztoDTVWZpnizp3Uo0LSSa4lhw>
    <xme:EsIWYCduxLxRXILjfbNeEEt-R-ZWzV2ppYQHAq8f00dPPNWm2SsfEXObM2CEN3qJn
    avSa0TT7nL_AA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeeigdeifecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeehgefguedvheejffeiheehuedvjeefhfegvefggedvue
    dufeevgeffuedvteelueenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:EsIWYMxI7i-J3sS1TS1TKEzXBo5-Lt7LgmAr1GJOfXBl4nif7VLdlQ>
    <xmx:EsIWYAOzz8YERfFVcj5jqzeLNyEq00RR9EUjmBUcp7cO1kTbpH3vsA>
    <xmx:EsIWYJ-uSx7fUqQEaXEOzTzmRqgs0XJ0U3hiqwlbS2YoTZgFcddeEA>
    <xmx:EsIWYGEzt46VvNj5064hwjxO8GhBpu0KoFHwICvpJM0k-9vXLE_zB6orZ0I>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6061724005D;
        Sun, 31 Jan 2021 09:43:30 -0500 (EST)
Subject: FAILED: patch "[PATCH] PM: hibernate: flush swap writer after marking" failed to apply to 4.14-stable tree
To:     laurentbadel@eaton.com, rafael.j.wysocki@intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 31 Jan 2021 15:43:21 +0100
Message-ID: <1612104201118248@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fef9c8d28e28a808274a18fbd8cc2685817fd62a Mon Sep 17 00:00:00 2001
From: Laurent Badel <laurentbadel@eaton.com>
Date: Fri, 22 Jan 2021 17:19:41 +0100
Subject: [PATCH] PM: hibernate: flush swap writer after marking
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

﻿Flush the swap writer after, not before, marking the files, to ensure the
signature is properly written.

Fixes: 6f612af57821 ("PM / Hibernate: Group swap ops")
Signed-off-by: Laurent Badel <laurentbadel@eaton.com>
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index c73f2e295167..72e33054a2e1 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -497,10 +497,10 @@ static int swap_writer_finish(struct swap_map_handle *handle,
 		unsigned int flags, int error)
 {
 	if (!error) {
-		flush_swap_writer(handle);
 		pr_info("S");
 		error = mark_swapfiles(handle, flags);
 		pr_cont("|\n");
+		flush_swap_writer(handle);
 	}
 
 	if (error)

