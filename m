Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E66A05F2C64
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 10:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiJCIuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 04:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiJCIty (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 04:49:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E18B101D0;
        Mon,  3 Oct 2022 01:32:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5D1460FA5;
        Mon,  3 Oct 2022 07:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9ED1C433C1;
        Mon,  3 Oct 2022 07:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781416;
        bh=h/e78F1BrRuBse28yetjYCGwSca6i4dfXzNsCn67ybA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RMq3bXrFitdL8cfFUFxDU9Ea6gDfrqhgsqDB4MKznCeVismF5iRkDLZKNHZjNcZ4x
         zN4ukp6PW+5B9ODAFRE+UkKAz2mU7F9iVuVhWF4t4SICj81KkOQXNVQWHfYvSJgtC4
         GXLgSRxdL7MvoI59++CE4obWlYt6CxS9GNSbZmgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 12/83] net: usb: qmi_wwan: Add new usb-id for Dell branded EM7455
Date:   Mon,  3 Oct 2022 09:10:37 +0200
Message-Id: <20221003070722.292858506@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Wunderlich <frank-w@public-files.de>

commit 797666cd5af041ffb66642fff62f7389f08566a2 upstream.

Add support for Dell 5811e (EM7455) with USB-id 0x413c:0x81c2.

Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Cc: stable@vger.kernel.org
Acked-by: Bjørn Mork <bjorn@mork.no>
Link: https://lore.kernel.org/r/20220926150740.6684-3-linux@fw-web.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/qmi_wwan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1393,6 +1393,7 @@ static const struct usb_device_id produc
 	{QMI_FIXED_INTF(0x413c, 0x81b3, 8)},	/* Dell Wireless 5809e Gobi(TM) 4G LTE Mobile Broadband Card (rev3) */
 	{QMI_FIXED_INTF(0x413c, 0x81b6, 8)},	/* Dell Wireless 5811e */
 	{QMI_FIXED_INTF(0x413c, 0x81b6, 10)},	/* Dell Wireless 5811e */
+	{QMI_FIXED_INTF(0x413c, 0x81c2, 8)},	/* Dell Wireless 5811e */
 	{QMI_FIXED_INTF(0x413c, 0x81cc, 8)},	/* Dell Wireless 5816e */
 	{QMI_FIXED_INTF(0x413c, 0x81d7, 0)},	/* Dell Wireless 5821e */
 	{QMI_FIXED_INTF(0x413c, 0x81d7, 1)},	/* Dell Wireless 5821e preproduction config */


