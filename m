Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF9A1EAA9F
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730448AbgFASJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:09:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729780AbgFASJo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:09:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9330021531;
        Mon,  1 Jun 2020 18:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034984;
        bh=PWB2t7f58OTgQdOQWXKpGzdge1XV4v+1OvpmDWYEvUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PDDx2wMgRN8GqE9yrJDrgtMosj+o/UNvUpPhmnLZxOHTpvxhgx89MRvD+j1mkOCwu
         wxwFqlC4zE+op0IA7duWJInT1kgWRRED6rMQ06PGLtOvGggvPV2YHdqtDuu/ozuu0i
         +jy79dsVIejOyRFZkrTLxZmU6vxOdMvGoD9x/NN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Hilliard <james.hilliard1@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 063/142] Input: usbtouchscreen - add support for BonXeon TP
Date:   Mon,  1 Jun 2020 19:53:41 +0200
Message-Id: <20200601174044.436273485@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Hilliard <james.hilliard1@gmail.com>

[ Upstream commit e3b4f94ef52ae1592cbe199bd38dbdc0d58b2217 ]

Based on available information this uses the singletouch irtouch
protocol. This is tested and confirmed to be fully functional on
the BonXeon TP hardware I have.

Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
Link: https://lore.kernel.org/r/20200413184217.55700-1-james.hilliard1@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/usbtouchscreen.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/touchscreen/usbtouchscreen.c b/drivers/input/touchscreen/usbtouchscreen.c
index 16d70201de4a..397cb1d3f481 100644
--- a/drivers/input/touchscreen/usbtouchscreen.c
+++ b/drivers/input/touchscreen/usbtouchscreen.c
@@ -182,6 +182,7 @@ static const struct usb_device_id usbtouch_devices[] = {
 #endif
 
 #ifdef CONFIG_TOUCHSCREEN_USB_IRTOUCH
+	{USB_DEVICE(0x255e, 0x0001), .driver_info = DEVTYPE_IRTOUCH},
 	{USB_DEVICE(0x595a, 0x0001), .driver_info = DEVTYPE_IRTOUCH},
 	{USB_DEVICE(0x6615, 0x0001), .driver_info = DEVTYPE_IRTOUCH},
 	{USB_DEVICE(0x6615, 0x0012), .driver_info = DEVTYPE_IRTOUCH_HIRES},
-- 
2.25.1



