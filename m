Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E07BC55CE30
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233483AbiF0LXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234583AbiF0LXb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:23:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B94D656C;
        Mon, 27 Jun 2022 04:23:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01FE7B8111C;
        Mon, 27 Jun 2022 11:23:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E9AC3411D;
        Mon, 27 Jun 2022 11:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329000;
        bh=hGuOut/iB47OP+a8fIGR+FF0ZAQpLfuGm7US7TJUxkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w3sQeST/x4gk7bKtBrSRedOm4ztbmFOQpFM+AC3hlXcXmf0FM6qpdysu+l8qsh+Yt
         LrDxrtVQlzrNZzVfUP80xs3wbq4xktdLqi1AbBdb44CW3WIyif82GaYy/lSV4VKRHl
         tEwkDpJ4JVJMf2a/ni0z7s+JjcJm4jH87mpX+nik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        Carlo Lobrano <c.lobrano@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 018/102] USB: serial: option: add Telit LE910Cx 0x1250 composition
Date:   Mon, 27 Jun 2022 13:20:29 +0200
Message-Id: <20220627111934.006180213@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Carlo Lobrano <c.lobrano@gmail.com>

commit 342fc0c3b345525da21112bd0478a0dc741598ea upstream.

Add support for the following Telit LE910Cx composition:

0x1250: rmnet, tty, tty, tty, tty

Reviewed-by: Daniele Palmas <dnlplm@gmail.com>
Signed-off-by: Carlo Lobrano <c.lobrano@gmail.com>
Link: https://lore.kernel.org/r/20220614075623.2392607-1-c.lobrano@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1279,6 +1279,7 @@ static const struct usb_device_id option
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1231, 0xff),	/* Telit LE910Cx (RNDIS) */
 	  .driver_info = NCTRL(2) | RSVD(3) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x1250, 0xff, 0x00, 0x00) },	/* Telit LE910Cx (rmnet) */
 	{ USB_DEVICE(TELIT_VENDOR_ID, 0x1260),
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, 0x1261),


