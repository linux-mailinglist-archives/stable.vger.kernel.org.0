Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0055D419A92
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235882AbhI0RKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:10:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235626AbhI0RIt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:08:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED20560F70;
        Mon, 27 Sep 2021 17:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762420;
        bh=UOtbJN11IgaL8n5jQqF4YIQpqohAKu2mHELdkAGvZUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lQ6Lqw/BieR/wE2d5I/TR+eie06ksaXPupakLgof77MMKMxIi0cs3DQtDjOFnV55E
         oMXL8U/OQQm3SRecaVFpf8Z08C1elneP4VuHVz+SOLaVdWL5aavfngP9ykLcRGTTA7
         7vHDpNWzNsc913YerQTZfmqFBEv4Kty9T945QhxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Oliver Neukum <oneukum@suse.com>,
        Julian Sikorski <belegdol+github@gmail.com>
Subject: [PATCH 5.10 016/103] Re-enable UAS for LaCie Rugged USB3-FW with fk quirk
Date:   Mon, 27 Sep 2021 19:01:48 +0200
Message-Id: <20210927170226.274673271@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Sikorski <belegdol@gmail.com>

commit ce1c42b4dacfe7d71c852d8bf3371067ccba865c upstream.

Further testing has revealed that LaCie Rugged USB3-FW does work with
uas as long as US_FL_NO_REPORT_OPCODES and US_FL_NO_SAME are enabled.

Link: https://lore.kernel.org/linux-usb/2167ea48-e273-a336-a4e0-10a4e883e75e@redhat.com/
Cc: stable <stable@vger.kernel.org>
Suggested-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Julian Sikorski <belegdol+github@gmail.com>
Link: https://lore.kernel.org/r/20210913181454.7365-1-belegdol+github@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_uas.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -50,7 +50,7 @@ UNUSUAL_DEV(0x059f, 0x1061, 0x0000, 0x99
 		"LaCie",
 		"Rugged USB3-FW",
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
-		US_FL_IGNORE_UAS),
+		US_FL_NO_REPORT_OPCODES | US_FL_NO_SAME),
 
 /*
  * Apricorn USB3 dongle sometimes returns "USBSUSBSUSBS" in response to SCSI


