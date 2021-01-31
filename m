Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23F85309D25
	for <lists+stable@lfdr.de>; Sun, 31 Jan 2021 15:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbhAaOqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jan 2021 09:46:17 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:37419 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233015AbhAaOoJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jan 2021 09:44:09 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 862A11291;
        Sun, 31 Jan 2021 09:43:23 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 31 Jan 2021 09:43:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=g9qANA
        Ri4k5FxtDUsy6wPNlBJpdzw94mOLGF8rBtLcM=; b=B36PgI+pE+sgNQW4w87PhQ
        Li3ABni4G6NOklH78TUDEiJr0qfgA3EU7ltE9LMCbQUoPmIUPNFacDA5LPf7pBLH
        FkO0oeNw3gYjlCT0M3G6rrdrocsFmic+NALIIw4VqVI+7ZNF5aX7EcLQsH9cmy4z
        g8AbDXDBUCpZ6+XL1dMIF5QPMABejQzKCm/Q5Ku/h7/dNzamkXaf6aIEJtU5F0Eu
        evLwAAjujVm8x/S8+8GPVfW4YmF3KhvRdqecEnJwGe+XkMWnPzVrp3KewQrx6xiI
        VMWlW4GIF4bs9P3nbxnCrql+qCzqkGdPI15ODvt9c7WWAYlyJi7oY1N5XWo1ET5A
        ==
X-ME-Sender: <xms:CsIWYL0xBNTtI7m85k32K-5P4jGx990pTd2ds3ofkPESAHLT5-6mYg>
    <xme:CsIWYKEXqxJPnTP_uvxgM7wVYj59fRdxYRZSsB1o2dzJ8TxkOHLXzZGB86H5-_6Z8
    PEDYyJ1tjCIqA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeeigdeifecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeehgefguedvheejffeiheehuedvjeefhfegvefggedvue
    dufeevgeffuedvteelueenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:CsIWYL4N4AdKh9ou4H9qRGCjyBmCH0sidRTXQSq8XFBP29ZUIwtqNA>
    <xmx:CsIWYA36yVqu2cuWdN9-yNprDk1zhT5hXL5lg215Wm5lYxPrPUIIAQ>
    <xmx:CsIWYOHp5iTs0OmDTwYqWxIzDneoUHruYcN4tHxyjI2M8uHtxt99Rw>
    <xmx:C8IWYJPkLVNzSe-8R5pIjBzrcpHIwevge8X5Z6OPM1_O65NxQCwp8u2RNic>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 75689108005C;
        Sun, 31 Jan 2021 09:43:22 -0500 (EST)
Subject: FAILED: patch "[PATCH] PM: hibernate: flush swap writer after marking" failed to apply to 4.4-stable tree
To:     laurentbadel@eaton.com, rafael.j.wysocki@intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 31 Jan 2021 15:43:20 +0100
Message-ID: <1612104200127205@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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

