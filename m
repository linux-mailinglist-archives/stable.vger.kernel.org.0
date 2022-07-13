Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6E5E573F17
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 23:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbiGMVl2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 17:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbiGMVl2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 17:41:28 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A392495E
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 14:41:27 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id n185so7280288wmn.4
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 14:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jvgYSgJ5lZzaBGMeau4DiSpE46btyTkqKIwRw3JZ8NM=;
        b=jTVTmKbQPptiok8mlUhU8BcVsPMkoSWDj6P8upGTTtGt1sdkaQc3F2aok2gP3+ht5U
         DUMhwsw+Dcp8/Lvvgm+fD2nZurQWRwzDuYEtgCZBbUAGrFPkCpT0oY9k8PSl83RHxCro
         qITRFHSwoi5XfnfCivSGZYaNe558G5fbHpBcovoFsO4kQ9drXWnL45CDXR6acj9XXmmn
         mMRPkf5pHTFAfp0vHLbnrqfxI2KHjkeXc6A0J5nV7KmiuPYTeLbFKe2AU1Mv80AcFtnx
         uzgnpYy8311ssEEmH/BxOQ0VTsft26kxUn8Xd4ifFKXNt7mbPj7TArCREqGfVuB2qx2i
         4hDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jvgYSgJ5lZzaBGMeau4DiSpE46btyTkqKIwRw3JZ8NM=;
        b=Hxbjp4EXuxcXQDmoJWoU/ymzz6xZPhtSoXMe/udEQD/V53hxg/nOzFyv5XbE3pOZHn
         SgdMjfq5eex6FHDyaXQhS9qFB4IZqd7UXregusMM0LvImoa1ibir2ylEQWxHvjkl3fmP
         +XxQ3QiWKbBVFyBS4527c+3cjUaiNURpA7fEDj1Qn6WYU3vZLf6YLiTsnsebyMBtc+78
         ov2qIFApw2IIkHHotwwUYFBHOVBXEtpISC1BsLtfBGdIzceBVZcTUIOmhmFUZ+hKHFGW
         HNML9zzyAocJVserO9UXi5lNhm1aiUrIVUGXA77qTvS0w2mioNkakTl0qzp2QZcWYMgT
         blQA==
X-Gm-Message-State: AJIora+ngKF7LYZvhN6xHUvGsH0vqjAlJxv1DE0rN6Iutz3FKnMkMxVd
        h/KE5qS51wo3CqOqu7h2F60=
X-Google-Smtp-Source: AGRyM1sCYSulEh3To80979knS7FZoahaHWDRkY6sArInGx12MY18+i+/YPvQ5Tu1vAVoHM6u0/BZ4A==
X-Received: by 2002:a05:600c:511c:b0:3a2:d480:9390 with SMTP id o28-20020a05600c511c00b003a2d4809390mr5510435wms.93.1657748485715;
        Wed, 13 Jul 2022 14:41:25 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id f11-20020adfe90b000000b0021d7b41255esm11914278wrm.98.2022.07.13.14.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 14:41:25 -0700 (PDT)
Date:   Wed, 13 Jul 2022 22:41:23 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     mkl@pengutronix.de, hbh25y@gmail.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] can: m_can: m_can_tx_handler(): fix use
 after free of skb" failed to apply to 4.9-stable tree
Message-ID: <Ys88AwNQTONsP6ZW@debian>
References: <164881453981207@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="lbXMHxyvBSLYumJV"
Content-Disposition: inline
In-Reply-To: <164881453981207@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--lbXMHxyvBSLYumJV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Fri, Apr 01, 2022 at 02:02:19PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--lbXMHxyvBSLYumJV
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-can-m_can-m_can_tx_handler-fix-use-after-free-of-skb.patch"

From bb339cb5aa90e31d6ceb65ac5d9937944d9666d7 Mon Sep 17 00:00:00 2001
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
index 197c27d8f584b..85380b63533fd 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1068,8 +1068,6 @@ static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
 		m_can_fifo_write(priv, 0, M_CAN_FIFO_DATA(i / 4),
 				 *(u32 *)(cf->data + i));
 
-	can_put_echo_skb(skb, dev, 0);
-
 	if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
 		cccr = m_can_read(priv, M_CAN_CCCR);
 		cccr &= ~(CCCR_CMR_MASK << CCCR_CMR_SHIFT);
@@ -1086,6 +1084,9 @@ static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
 
 	/* enable first TX buffer to start transfer  */
 	m_can_write(priv, M_CAN_TXBTIE, 0x1);
+
+	can_put_echo_skb(skb, dev, 0);
+
 	m_can_write(priv, M_CAN_TXBAR, 0x1);
 
 	return NETDEV_TX_OK;
-- 
2.30.2


--lbXMHxyvBSLYumJV--
