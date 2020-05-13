Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD831D0D53
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387746AbgEMJwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:52:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733174AbgEMJwG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:52:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF70320575;
        Wed, 13 May 2020 09:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363526;
        bh=A3Y2v+4SlLEutyfNVUrIBwwpsZ4l2T67ReBBophFU2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V7LvRX8A7wPXIvyG8LfBwJ2Wnf8xVHg1Sjf6nT6DZ/UKbQ9xnZBjKHg1d+TtMjeeF
         lnZneaygyho/7GPmDvTtLxWAtt73vhlZLY0PzliWUS+/MfaS0+ra7jj3/CWM8Ok0Zd
         4sLODIQJGVdTC4H0vFHqLuhHyMXBPftAGOm3vSyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Jolly <Kangie@footclan.ninja>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.6 002/118] USB: serial: qcserial: Add DW5816e support
Date:   Wed, 13 May 2020 11:43:41 +0200
Message-Id: <20200513094417.831600703@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Jolly <Kangie@footclan.ninja>

commit 78d6de3cfbd342918d31cf68d0d2eda401338aef upstream.

Add support for Dell Wireless 5816e to drivers/usb/serial/qcserial.c

Signed-off-by: Matt Jolly <Kangie@footclan.ninja>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/qcserial.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -173,6 +173,7 @@ static const struct usb_device_id id_tab
 	{DEVICE_SWI(0x413c, 0x81b3)},	/* Dell Wireless 5809e Gobi(TM) 4G LTE Mobile Broadband Card (rev3) */
 	{DEVICE_SWI(0x413c, 0x81b5)},	/* Dell Wireless 5811e QDL */
 	{DEVICE_SWI(0x413c, 0x81b6)},	/* Dell Wireless 5811e QDL */
+	{DEVICE_SWI(0x413c, 0x81cc)},	/* Dell Wireless 5816e */
 	{DEVICE_SWI(0x413c, 0x81cf)},   /* Dell Wireless 5819 */
 	{DEVICE_SWI(0x413c, 0x81d0)},   /* Dell Wireless 5819 */
 	{DEVICE_SWI(0x413c, 0x81d1)},   /* Dell Wireless 5818 */


