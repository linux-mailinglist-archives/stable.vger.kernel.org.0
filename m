Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C46683A5826
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 13:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbhFMMBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 08:01:06 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:39623 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231794AbhFMMBF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 08:01:05 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 326C110C0;
        Sun, 13 Jun 2021 07:59:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 13 Jun 2021 07:59:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=5r0tx9
        JN569WkfHMbeVqg6DMwtyTSRNp+UzJGAAKsUo=; b=YLet15002ABXc9zS2147zB
        bQE/VFHi30JXV+Dlmv7JKM59oSdJsjlspAfS+VQ/xgUmm3X4ZiUzjnz4+Fox5CS9
        eRK5iWyvPUkENgnS9CYuSpObAQQvp43UA67H0tl3TCSCxf4khaSVcmEnq91czV6T
        Zgww9VwStPB+skn1snVqtmRYePF8qh3rR7akU/mF9ddnIJFm/23aEzRGgffeZnd1
        3B56yFLypplW+/upZJeoc4wHdqg63h3DjkCPHHqnrUQByLws/TumXpcQs0pkVAt2
        9bqFi4XCpetwM00yZaTmFuMpEzcmeyCM+XFNdxOGr6a/QDIfg/+1rIzMq04Pdgzg
        ==
X-ME-Sender: <xms:B_PFYGt7YMIbZSGzT9Mgm7v16jCZCAsK1yXKq5LBltml-_0QPU7vbw>
    <xme:B_PFYLfKkEr4McFIH0L8DDO9EpzvEdgVHJGIVuFBJBiMGrhW7sJwak87MysPCT-2c
    ej3rPJw3PqDmQ>
X-ME-Received: <xmr:B_PFYBwS218Mp9l1IWXE3m3xWHSNiEWzKqaNf9F3vvzXnxR9jOIq-e-72Q0-FOeOhJ4ceuzDtj8Uy490TEcUuAMTWN8xHhy2>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedggeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:B_PFYBNKP-GvvSGZ6JtYX-LeBjHES4KKA60Fr0P8EKjwEjIPSQJtKQ>
    <xmx:B_PFYG9gR8TZHudEuZafg8RWQStam8fwy5z6Vn5ijfM_W3ixRx782Q>
    <xmx:B_PFYJVlQlxP9aj9ruW-j6FwPnvU1jiiqu95yW2T0iqQq3MFpW1fBg>
    <xmx:B_PFYNYI2ED_e4ELlNjm8McYI4cQCWxE5JKzK8A7etW9VVxv4cTo7UxOOUI>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 07:59:03 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: pd: Set PD_T_SINK_WAIT_CAP to 310ms" failed to apply to 4.14-stable tree
To:     kyletso@google.com, gregkh@linuxfoundation.org, linux@roeck-us.net,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 13:59:01 +0200
Message-ID: <162358554110953@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

From 6490fa565534fa83593278267785a694fd378a2b Mon Sep 17 00:00:00 2001
From: Kyle Tso <kyletso@google.com>
Date: Fri, 28 May 2021 16:16:13 +0800
Subject: [PATCH] usb: pd: Set PD_T_SINK_WAIT_CAP to 310ms

Current timer PD_T_SINK_WAIT_CAP is set to 240ms which will violate the
SinkWaitCapTimer (tTypeCSinkWaitCap 310 - 620 ms) defined in the PD
Spec if the port is faster enough when running the state machine. Set it
to the lower bound 310ms to ensure the timeout is in Spec.

Fixes: f0690a25a140 ("staging: typec: USB Type-C Port Manager (tcpm)")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Kyle Tso <kyletso@google.com>
Link: https://lore.kernel.org/r/20210528081613.730661-1-kyletso@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/include/linux/usb/pd.h b/include/linux/usb/pd.h
index bf00259493e0..96b7ff66f074 100644
--- a/include/linux/usb/pd.h
+++ b/include/linux/usb/pd.h
@@ -460,7 +460,7 @@ static inline unsigned int rdo_max_power(u32 rdo)
 #define PD_T_RECEIVER_RESPONSE	15	/* 15ms max */
 #define PD_T_SOURCE_ACTIVITY	45
 #define PD_T_SINK_ACTIVITY	135
-#define PD_T_SINK_WAIT_CAP	240
+#define PD_T_SINK_WAIT_CAP	310	/* 310 - 620 ms */
 #define PD_T_PS_TRANSITION	500
 #define PD_T_SRC_TRANSITION	35
 #define PD_T_DRP_SNK		40

