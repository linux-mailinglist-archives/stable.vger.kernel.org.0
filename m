Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213751EFA43
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728158AbgFEOQI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:16:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728082AbgFEOQH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:16:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9ADAB2075B;
        Fri,  5 Jun 2020 14:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366567;
        bh=pcwZ8QAtQqf2jGKfibADVbKbceKZrKRWppgjgQ5/tFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uzgcbxcfQ0y2/RM6msfsi8lFezEmMjlE09+tZPFieBzRQSCh+LFdkwYCHvdrHj7wp
         pAvM73OWwf/Cfy5VUQh0Ik42qJm7uCDCBopKHXpY2VXHIJUWhRXfxBSyh40DYl0ykT
         MSakJu8TELi8YNZqJ1Swmee20MiGfT3yWWo+rqI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Giuseppe Marco Randazzo <gmrandazzo@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Christian Lamparter <chunkeey@gmail.com>
Subject: [PATCH 5.7 06/14] p54usb: add AirVasT USB stick device-id
Date:   Fri,  5 Jun 2020 16:14:56 +0200
Message-Id: <20200605135951.392458504@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605135951.018731965@linuxfoundation.org>
References: <20200605135951.018731965@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Giuseppe Marco Randazzo <gmrandazzo@gmail.com>

commit 63e49a9fdac1b4e97ac26cb3fe953f210d83bc53 upstream.

This patch adds the AirVasT USB wireless devices 124a:4026
to the list of supported devices. It's using the ISL3886
usb firmware. Without this modification, the wiki adapter
is not recognized.

Cc: <stable@vger.kernel.org>
Signed-off-by: Giuseppe Marco Randazzo <gmrandazzo@gmail.com>
Signed-off-by: Christian Lamparter <chunkeey@gmail.com> [formatted, reworded]
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200405220659.45621-1-chunkeey@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intersil/p54/p54usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/intersil/p54/p54usb.c
+++ b/drivers/net/wireless/intersil/p54/p54usb.c
@@ -61,6 +61,7 @@ static const struct usb_device_id p54u_t
 	{USB_DEVICE(0x0db0, 0x6826)},	/* MSI UB54G (MS-6826) */
 	{USB_DEVICE(0x107b, 0x55f2)},	/* Gateway WGU-210 (Gemtek) */
 	{USB_DEVICE(0x124a, 0x4023)},	/* Shuttle PN15, Airvast WM168g, IOGear GWU513 */
+	{USB_DEVICE(0x124a, 0x4026)},	/* AirVasT USB wireless device */
 	{USB_DEVICE(0x1435, 0x0210)},	/* Inventel UR054G */
 	{USB_DEVICE(0x15a9, 0x0002)},	/* Gemtek WUBI-100GW 802.11g */
 	{USB_DEVICE(0x1630, 0x0005)},	/* 2Wire 802.11g USB (v1) / Z-Com */


