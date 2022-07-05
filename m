Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAA5566BEE
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbiGEMKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233454AbiGEMGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:06:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 971B218B35;
        Tue,  5 Jul 2022 05:06:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEE5961806;
        Tue,  5 Jul 2022 12:05:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F78C341C7;
        Tue,  5 Jul 2022 12:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022759;
        bh=/yME1pixWaTPzCNQ+h58b3L5P5mzojmpuiwY6mpK0uM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hIC7hWQq7FBd+uBDkcLIg95gkxffx6VxS0+W9R6XrRTuzGBqxOPRHSeBuBGyjxhAG
         mrJMhapL75Lw7imqDSlaAPkvgxy7jtNjnNfsvMsCkjrm57NZzxxFDU6V1yMy87lXY6
         Mu/Q6C/bxIpaa8Ys2keQKogVos1xwMoFJDFyoZX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Jakub Kicinski <kuba@kernel.org>,
        Fabio Porcedda <fabio.porcedda@gmail.com>
Subject: [PATCH 5.4 57/58] net: usb: qmi_wwan: add Telit 0x1070 composition
Date:   Tue,  5 Jul 2022 13:58:33 +0200
Message-Id: <20220705115611.922805851@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115610.236040773@linuxfoundation.org>
References: <20220705115610.236040773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniele Palmas <dnlplm@gmail.com>

commit 94f2a444f28a649926c410eb9a38afb13a83ebe0 upstream.

Add the following Telit FN990 composition:

0x1070: tty, adb, rmnet, tty, tty, tty, tty

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Acked-by: Bjørn Mork <bjorn@mork.no>
Link: https://lore.kernel.org/r/20211210095722.22269-1-dnlplm@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: Fabio Porcedda <fabio.porcedda@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/qmi_wwan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1316,6 +1316,7 @@ static const struct usb_device_id produc
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1040, 2)},	/* Telit LE922A */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1050, 2)},	/* Telit FN980 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1060, 2)},	/* Telit LN920 */
+	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1070, 2)},	/* Telit FN990 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1100, 3)},	/* Telit ME910 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1101, 3)},	/* Telit ME910 dual modem */
 	{QMI_FIXED_INTF(0x1bc7, 0x1200, 5)},	/* Telit LE920 */


