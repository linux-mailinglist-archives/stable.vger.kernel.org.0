Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 062BE573E4F
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 22:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237326AbiGMUy4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 16:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237388AbiGMUyp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 16:54:45 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803DA10575
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 13:54:43 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id i204-20020a1c3bd5000000b003a2fa488efdso1568212wma.4
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 13:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=12kYHEYlPMImlUIx2EE5O0/dgFJyE9qy93/xFI7liZo=;
        b=MVBgrmXtTuuEonHCjEfZxJECWZT1U/f6UWFJHX3m+bA+nAUrSPhJmoOWueEWrgfsD2
         PxZL5tm0d8jFAyegXbFTHhPQwM1Iij+Pbiy2mGPz7WVKCBh8kOFqR7c4QaxRk8injiLR
         8FJ9aDErycyKAZ7VH+r8IiN+P7hzTAKTTEDaHLRhPw5lriNd+X2+t8YVo086aBdT58eY
         ktXZraA+6NjGyMPdX1/PEupOcR7CNq35wyR9p8R9Ohtv/3c/q5W6Uf3X88yrB5M/iBS7
         /XrLS3bXp7x2qjcZklV3QX6EnUEX9IDmhA+sSCEjK3wrIJZFnFH5e14P/dveq1i1QJ4l
         Dtiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=12kYHEYlPMImlUIx2EE5O0/dgFJyE9qy93/xFI7liZo=;
        b=pMHumkfP7iflHxOEMjj7HH4sOiCptquPlwGT51jZo36HJammjzGN06t2x1JwfbaaSK
         ObcmekUz21kSerthxUh++B4rF6d1NQVw8EmjTXYVR23Q5MVKd4cjnnQk8pyYb0jRs1oZ
         lbzPE7kzQTYKdbef/gi9E/zgSqUSnVNRIDD1JtAxf4y1GJQlmJdoSIMFYzEBzBF/OW0Y
         sieMOeiWM7gueextC8SC9YnvpPO8g8d0ZsT/ZqEDiGqBlHFVDjcW7EWIoeyR/LcrJI6I
         gDiwEJKY737ZsHX73Kxn5KjbgPITPSuUJ8bwEGW3uz3y54zw+ZerPoZpiLL2SH1vBZCn
         uGQg==
X-Gm-Message-State: AJIora8dUWAqPyDxlZ75c8UZnAUcK/4vy3fnv9W7c8mNs69V/DCYildn
        9b84pRW4xRS84IewfZiNuAaki66S0tiE0Q==
X-Google-Smtp-Source: AGRyM1tAoH3yy69fzDajIjm+G+Cx5mWwHNq8LKXi0eZ8Uop2eo2HrUYQde6rFsBOFEDjA/p6Mjx8bw==
X-Received: by 2002:a05:600c:3b17:b0:3a2:ee46:e312 with SMTP id m23-20020a05600c3b1700b003a2ee46e312mr11179868wms.49.1657745682080;
        Wed, 13 Jul 2022 13:54:42 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id y12-20020a5d620c000000b0021d63fe0f03sm11641117wru.12.2022.07.13.13.54.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 13:54:41 -0700 (PDT)
Date:   Wed, 13 Jul 2022 21:54:39 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     mkl@pengutronix.de, hbh25y@gmail.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] can: m_can: m_can_tx_handler(): fix use
 after free of skb" failed to apply to 5.4-stable tree
Message-ID: <Ys8xDyCCL6WQmKYW@debian>
References: <1648814538103133@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6yuSXIZxCb3uVwba"
Content-Disposition: inline
In-Reply-To: <1648814538103133@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--6yuSXIZxCb3uVwba
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Fri, Apr 01, 2022 at 02:02:18PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--6yuSXIZxCb3uVwba
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-can-m_can-m_can_tx_handler-fix-use-after-free-of-skb.patch"

From 05d0fcb7b35198251c27d5ba1f2be4debf782753 Mon Sep 17 00:00:00 2001
From: Marc Kleine-Budde <mkl@pengutronix.de>
Date: Thu, 17 Mar 2022 08:57:35 +0100
Subject: [PATCH] can: m_can: m_can_tx_handler(): fix use after free of skb

commit 2e8e79c416aae1de224c0f1860f2e3350fa171f8 upstream.

can_put_echo_skb() will clone skb then free the skb. Move the
can_put_echo_skb() for the m_can version 3.0.x directly before the
start of the xmit in hardware, similar to the 3.1.x branch.

Fixes: 80646733f11c ("can: m_can: update to support CAN FD features")
Link: https://lore.kernel.org/all/20220317081305.739554-1-mkl@pengutronix.de
Cc: stable@vger.kernel.org
Reported-by: Hangyu Hua <hbh25y@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/net/can/m_can/m_can.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 9ae3efce0f66b..26f721664e761 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1443,8 +1443,6 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 					 M_CAN_FIFO_DATA(i / 4),
 					 *(u32 *)(cf->data + i));
 
-		can_put_echo_skb(skb, dev, 0);
-
 		if (cdev->can.ctrlmode & CAN_CTRLMODE_FD) {
 			cccr = m_can_read(cdev, M_CAN_CCCR);
 			cccr &= ~(CCCR_CMR_MASK << CCCR_CMR_SHIFT);
@@ -1461,6 +1459,9 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 			m_can_write(cdev, M_CAN_CCCR, cccr);
 		}
 		m_can_write(cdev, M_CAN_TXBTIE, 0x1);
+
+		can_put_echo_skb(skb, dev, 0);
+
 		m_can_write(cdev, M_CAN_TXBAR, 0x1);
 		/* End of xmit function for version 3.0.x */
 	} else {
-- 
2.30.2


--6yuSXIZxCb3uVwba--
