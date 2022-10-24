Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB8660B92A
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbiJXUFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233890AbiJXUE5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:04:57 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8725022395A;
        Mon, 24 Oct 2022 11:26:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2302CCE131F;
        Mon, 24 Oct 2022 11:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24628C433D6;
        Mon, 24 Oct 2022 11:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611582;
        bh=LSxeXqIfLkfCe1mrHfnM4jsex1rUwKaG6O4JFKNxDsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rrJLIH/rXabOHLrfMq8iRMcdPWpbo0HsyLz3xfsts/HoomUK93hYEYIKRo+HqFnoL
         zGMFd5f31Li6LnDaTIelZ3vrGQhjGddda/HvxKHitF3njl6xTa6QBFa32SF3tIlI40
         P8b3Z+LJzTH3VpqhGanV6kmne9SECW/Az5jnjxkg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Wunderlich <frank-w@public-files.de>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.9 034/159] USB: serial: qcserial: add new usb-id for Dell branded EM7455
Date:   Mon, 24 Oct 2022 13:29:48 +0200
Message-Id: <20221024112950.649084226@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112949.358278806@linuxfoundation.org>
References: <20221024112949.358278806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Wunderlich <frank-w@public-files.de>

commit eee48781ea199e32c1d0c4732641c494833788ca upstream.

Add support for Dell 5811e (EM7455) with USB-id 0x413c:0x81c2.

Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/qcserial.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -181,6 +181,7 @@ static const struct usb_device_id id_tab
 	{DEVICE_SWI(0x413c, 0x81b3)},	/* Dell Wireless 5809e Gobi(TM) 4G LTE Mobile Broadband Card (rev3) */
 	{DEVICE_SWI(0x413c, 0x81b5)},	/* Dell Wireless 5811e QDL */
 	{DEVICE_SWI(0x413c, 0x81b6)},	/* Dell Wireless 5811e QDL */
+	{DEVICE_SWI(0x413c, 0x81c2)},	/* Dell Wireless 5811e */
 	{DEVICE_SWI(0x413c, 0x81cb)},	/* Dell Wireless 5816e QDL */
 	{DEVICE_SWI(0x413c, 0x81cc)},	/* Dell Wireless 5816e */
 	{DEVICE_SWI(0x413c, 0x81cf)},   /* Dell Wireless 5819 */


