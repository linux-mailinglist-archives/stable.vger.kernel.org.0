Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 693E26DEE7D
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbjDLIlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbjDLIlQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:41:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43E53C31
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:40:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA77163004
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:38:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09842C433EF;
        Wed, 12 Apr 2023 08:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288721;
        bh=SLpOfQEjPlGpbHjo3wIAyVQkF2NdFTx7+4xJkm4r93s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kUyvzzVBrhsGRXBqHRBTvmfGJt8BeiFFV3fgkW8IYL+hwOyHwc+mJfklZ9I+cjMR0
         5fFLD6lJUDA2WTpbZ2GXCMKktNgZ096VuFtx4uVMZcX1Vac9lXfR55r4wcdqy6qE7h
         4iQ/8IUQK5MW3YERFCB1EsdFNzbcY8t9ev1dOyGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kees Jan Koster <kjkoster@kjkoster.org>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 55/93] USB: serial: cp210x: add Silicon Labs IFS-USB-DATACABLE IDs
Date:   Wed, 12 Apr 2023 10:33:56 +0200
Message-Id: <20230412082825.470042062@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Jan Koster <kjkoster@kjkoster.org>

commit 71f8afa2b66e356f435b6141b4a9ccf953e18356 upstream.

The Silicon Labs IFS-USB-DATACABLE is used in conjunction with for example
the Quint UPSes. It is used to enable Modbus communication with the UPS to
query configuration, power and battery status.

Signed-off-by: Kees Jan Koster <kjkoster@kjkoster.org>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -120,6 +120,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x10C4, 0x826B) }, /* Cygnal Integrated Products, Inc., Fasttrax GPS demonstration module */
 	{ USB_DEVICE(0x10C4, 0x8281) }, /* Nanotec Plug & Drive */
 	{ USB_DEVICE(0x10C4, 0x8293) }, /* Telegesis ETRX2USB */
+	{ USB_DEVICE(0x10C4, 0x82AA) }, /* Silicon Labs IFS-USB-DATACABLE used with Quint UPS */
 	{ USB_DEVICE(0x10C4, 0x82EF) }, /* CESINEL FALCO 6105 AC Power Supply */
 	{ USB_DEVICE(0x10C4, 0x82F1) }, /* CESINEL MEDCAL EFD Earth Fault Detector */
 	{ USB_DEVICE(0x10C4, 0x82F2) }, /* CESINEL MEDCAL ST Network Analyzer */


