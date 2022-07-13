Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B593573ED7
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 23:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237523AbiGMVVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 17:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237524AbiGMVUt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 17:20:49 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4003342A
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 14:20:04 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id i204-20020a1c3bd5000000b003a2fa488efdso1610676wma.4
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 14:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yEd86Uoq7xZnm4nfsxmdfjuy7DfzAG//lferu9RVGi4=;
        b=QEjAmsBXtUTmwvsSX0rxbmJj0sqan7+tGMxE5NEAsDtM9fVMMQ73aNGQnXyidzV2hU
         iFgusWrtGJ2vFp/+9dOkFhR+6PJG/daYtkJ7alTbAvm+fBoOSr38kCnjCC5MVQSe8BMH
         BYtEpOfUmAZ0Q8CqhW/DaPOEprxiExtKIv8ZRNSgA/6aBY8wTzLAFM72RrCL9iCa+iSC
         VjNQQc6t7c+w2rE0JJ6BYz8KESO9BOV3furKf0+hpkuvBwjfBxiciv/9vmnQNmXS0OzN
         K2RneYYS3E+iQArPaPmIu2hKQexayxf0UO70nClnpDDczYC4UApzHsLV9o2IzsQStL+2
         f3nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yEd86Uoq7xZnm4nfsxmdfjuy7DfzAG//lferu9RVGi4=;
        b=wgKi5gzaYk/cR7IHZp0qJIet5Q+f4qMu1OXA0taxy3F2KCQZH2Q2R/cH10qvEh5cvU
         m9YJkVoyKFAU4ZbGPrvB8Y6QgGKthZ1Oe0/i85RDTmWX49EwZk2gH7doc9AUggXKCPIP
         uN1QX+1oJ5PDo/iyz5lKOEYkN5O4HqclcfUAwxbvUetXmz4JeyRnHNDRLiGv1Fdzupga
         gVlclcLTT08MFl3EdAxMw+2YcgV0GsX3XB+lYapXP4ZV+BLW6rkHZtrPUxVNt3PqnTEG
         gN2yaYBZLVNXJRtrYQOZ4ZU/JoBjiI0n9IvJJd4VP43BM5NJC7t5xMQ3wQpPeq3ItI5c
         iqhA==
X-Gm-Message-State: AJIora8Jmbg0S8IxU82u+QIco9jQ6GGaXXpaZrWYgeUQnePj4w3shqjL
        COCVGO2fhJYcrTw6GSgjMlI=
X-Google-Smtp-Source: AGRyM1vRK43DIiNy3eApX9hQjDy7saupLsG/yZKk+gNkfuRPhC8AIyEE8cHyQdaDxxEMFa3zoD6Ilw==
X-Received: by 2002:a05:600c:3b1d:b0:3a2:60a1:fe30 with SMTP id m29-20020a05600c3b1d00b003a260a1fe30mr5649148wms.193.1657747202667;
        Wed, 13 Jul 2022 14:20:02 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id d15-20020a05600c34cf00b0039c4d022a44sm3227337wmq.1.2022.07.13.14.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 14:20:02 -0700 (PDT)
Date:   Wed, 13 Jul 2022 22:20:00 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     mkl@pengutronix.de, hbh25y@gmail.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] can: m_can: m_can_tx_handler(): fix use
 after free of skb" failed to apply to 4.19-stable tree
Message-ID: <Ys83ABORf3VUnzgO@debian>
References: <1648814539221220@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7M1Z3KMsR09upD1Y"
Content-Disposition: inline
In-Reply-To: <1648814539221220@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--7M1Z3KMsR09upD1Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Fri, Apr 01, 2022 at 02:02:19PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport, will also apply to 4.14-stable.

--
Regards
Sudip

--7M1Z3KMsR09upD1Y
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-can-m_can-m_can_tx_handler-fix-use-after-free-of-skb.patch"

From d6c487aeeb07c876dbc5c9b21aae004ea2e07037 Mon Sep 17 00:00:00 2001
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
index f5f1367d40d5c..4b88fabbdcbaa 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1438,8 +1438,6 @@ static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
 					 M_CAN_FIFO_DATA(i / 4),
 					 *(u32 *)(cf->data + i));
 
-		can_put_echo_skb(skb, dev, 0);
-
 		if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
 			cccr = m_can_read(priv, M_CAN_CCCR);
 			cccr &= ~(CCCR_CMR_MASK << CCCR_CMR_SHIFT);
@@ -1456,6 +1454,9 @@ static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
 			m_can_write(priv, M_CAN_CCCR, cccr);
 		}
 		m_can_write(priv, M_CAN_TXBTIE, 0x1);
+
+		can_put_echo_skb(skb, dev, 0);
+
 		m_can_write(priv, M_CAN_TXBAR, 0x1);
 		/* End of xmit function for version 3.0.x */
 	} else {
-- 
2.30.2


--7M1Z3KMsR09upD1Y--
