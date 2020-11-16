Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB7232B4B20
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 17:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731011AbgKPQ3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 11:29:38 -0500
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:50463 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730795AbgKPQ3i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 11:29:38 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 6187119402E9;
        Mon, 16 Nov 2020 11:29:37 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 16 Nov 2020 11:29:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=VvBlhv
        uWhVPvcaWMAt/XPTyxUkSfeaJljIACngC9cWM=; b=SrkSqVgQzYgAn2+LMbAeyV
        W0O3o5hHDZexhvwjxU1+SQP6PWoa2kA9M++wd4j7jpcBKmP8VcCn+CBt+K8sKZpw
        st7SFqJvRDctNaET73NKy5V0zNFc2oHzHc742ceBfzGVwdZtwmZV81ft/dY47345
        /sEdw6KU0jJx3wErLZhLjwtMVs+rnX8YlHnFi831Pr0hgy5dLrC8Ggo5jEVb4kc1
        y4/QygFYiA4zb7MgHWMZu2QYEYf0efRzg3D7eErucM/Pu858oAX+BPUdyiKB8o94
        h3ZNh9KCzmv9SrnY2bPELytwNkYgY0FegYyJfzzZTvNhPhQoHHkdOLQ22l3jfHUA
        ==
X-ME-Sender: <xms:8aiyX-ypOPxYy003VyOUr43CFeQPvMmanlTtbvwUSVNpAmzWjxLqPw>
    <xme:8aiyX6R9UOLRbtAqm1322E404jc4L_fKUrwOloHyOL6lKkNis7WkRXHgnf6zBbNFd
    VEw9yxCBDlTSA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudefuddgledtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkeejgffftefgveeggeehudfgleehkedthedtiefhie
    elieetveejvdfgvdeljeelnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:8aiyXwUvt69syG2UoiY5dgOj1JPHu4G84vc8sFi-NRC2r_tvuIky6A>
    <xmx:8aiyX0jvvFjlS5RScjJu-xscv3Ud3xd07ATMV8AKKjcpZ0MrRgxp3A>
    <xmx:8aiyXwBWEMrSrLqFh7sjm54KSYRG9Eks6MHyMnl6ipbruMrTs65b8g>
    <xmx:8aiyXzMjUFw0S9aPcs-lpd504M9dQ0ozc2BUpdGSva90Per_IDBq1g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id EF9423280060;
        Mon, 16 Nov 2020 11:29:36 -0500 (EST)
Subject: FAILED: patch "[PATCH] mmc: renesas_sdhi_core: Add missing tmio_mmc_host_free() at" failed to apply to 4.9-stable tree
To:     yoshihiro.shimoda.uh@renesas.com,
        niklas.soderlund+renesas@ragnatech.se, ulf.hansson@linaro.org,
        wsa+renesas@sang-engineering.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Nov 2020 17:30:15 +0100
Message-ID: <160554421517246@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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

From e8973201d9b281375b5a8c66093de5679423021a Mon Sep 17 00:00:00 2001
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Date: Fri, 6 Nov 2020 18:25:30 +0900
Subject: [PATCH] mmc: renesas_sdhi_core: Add missing tmio_mmc_host_free() at
 remove
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The commit 94b110aff867 ("mmc: tmio: add tmio_mmc_host_alloc/free()")
added tmio_mmc_host_free(), but missed the function calling in
the sh_mobile_sdhi_remove() at that time. So, fix it. Otherwise,
we cannot rebind the sdhi/mmc devices when we use aliases of mmc.

Fixes: 94b110aff867 ("mmc: tmio: add tmio_mmc_host_alloc/free()")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1604654730-29914-1-git-send-email-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/renesas_sdhi_core.c b/drivers/mmc/host/renesas_sdhi_core.c
index 414314151d0a..03c905a781a7 100644
--- a/drivers/mmc/host/renesas_sdhi_core.c
+++ b/drivers/mmc/host/renesas_sdhi_core.c
@@ -1160,6 +1160,7 @@ int renesas_sdhi_remove(struct platform_device *pdev)
 
 	tmio_mmc_host_remove(host);
 	renesas_sdhi_clk_disable(host);
+	tmio_mmc_host_free(host);
 
 	return 0;
 }

