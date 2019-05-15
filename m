Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85CDA1EC92
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 12:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfEOK7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 06:59:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727068AbfEOK7I (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 06:59:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0219221734;
        Wed, 15 May 2019 10:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557917947;
        bh=eOTddtt9JHkdkE4s/OJ0DLB73GajNTU/Z2/QyW2b3cg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=On8+U8rDAjfMrxv+/vZoxRD/nLIpi5+V3OAOpz/+sZPotxykbKBVqz8MQPyyZ6mdf
         OSU80usVbFrZD/7Be4pcPmXkYsGaXvrr5qjXBWdIDw1F5EYY2QOeEfuxhcdq286v+9
         7rTCTl2VAxTZy9POdOZ7V2PT1kUEpZ0IL1oeUoNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: [PATCH 3.18 35/86] USB: media: disable tlg2300 driver
Date:   Wed, 15 May 2019 12:55:12 +0200
Message-Id: <20190515090649.819062832@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090642.339346723@linuxfoundation.org>
References: <20190515090642.339346723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

The tlg2300 driver was moved to the staging tree back in 3.19, and then
removed entirely from the tree in 4.0.  Because it breaks with an
upcoming fix for the USB power management logic, let's just disable it
from 3.18.y in case anyone is actually using it, as they really
shouldn't be anymore.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/tlg2300/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/usb/tlg2300/Kconfig
+++ b/drivers/media/usb/tlg2300/Kconfig
@@ -1,6 +1,7 @@
 config VIDEO_TLG2300
 	tristate "Telegent TLG2300 USB video capture support"
 	depends on VIDEO_DEV && I2C && SND && DVB_CORE
+	depends on BROKEN
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	depends on RC_CORE


